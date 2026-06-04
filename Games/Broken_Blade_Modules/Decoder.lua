local PacketCodec = {}

--// Converts a Roblox buffer to string if needed
local function toBinaryString(data)
	if typeof(data) == "buffer" then
		return buffer.tostring(data)
	end

	return data
end

--// Converts binary string back to Roblox buffer
function PacketCodec.toBuffer(str)
	return buffer.fromstring(str)
end

--// Useful if you have text like "\\x93\\x04" instead of real bytes
function PacketCodec.fromEscaped(text)
	text = text:gsub("\\x(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end)

	return text
end

function PacketCodec.toEscaped(str)
	return (str:gsub(".", function(c)
		return string.format("\\x%02X", string.byte(c))
	end))
end

--// Roblox buffer uses little-endian, MessagePack-style numbers are big-endian
local function packF64BE(n)
	local b = buffer.create(8)
	buffer.writef64(b, 0, n)

	local le = buffer.tostring(b)

	return string.char(
		le:byte(8),
		le:byte(7),
		le:byte(6),
		le:byte(5),
		le:byte(4),
		le:byte(3),
		le:byte(2),
		le:byte(1)
	)
end

local function unpackF64BE(str)
	local le = string.char(
		str:byte(8),
		str:byte(7),
		str:byte(6),
		str:byte(5),
		str:byte(4),
		str:byte(3),
		str:byte(2),
		str:byte(1)
	)

	local b = buffer.fromstring(le)
	return buffer.readf64(b, 0)
end

local function packU16BE(n)
	local hi = math.floor(n / 256) % 256
	local lo = n % 256

	return string.char(hi, lo)
end

local function packU32BE(n)
	local b1 = math.floor(n / 16777216) % 256
	local b2 = math.floor(n / 65536) % 256
	local b3 = math.floor(n / 256) % 256
	local b4 = n % 256

	return string.char(b1, b2, b3, b4)
end

local function readU16BE(str, pos)
	local b1, b2 = str:byte(pos, pos + 1)
	return b1 * 256 + b2, pos + 2
end

local function readU32BE(str, pos)
	local b1, b2, b3, b4 = str:byte(pos, pos + 3)
	return ((b1 * 256 + b2) * 256 + b3) * 256 + b4, pos + 4
end

local function isArray(tbl)
	local count = 0
	local maxIndex = 0

	for k in pairs(tbl) do
		if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
			return false
		end

		count += 1
		if k > maxIndex then
			maxIndex = k
		end
	end

	return count == maxIndex
end

local function readValue(str, pos)
	local tag = str:byte(pos)
	pos += 1

	-- positive fixint
	if tag <= 0x7F then
		return tag, pos
	end

	-- fixmap
	if tag >= 0x80 and tag <= 0x8F then
		local size = tag - 0x80
		local tbl = {}

		for _ = 1, size do
			local key
			key, pos = readValue(str, pos)

			local value
			value, pos = readValue(str, pos)

			tbl[key] = value
		end

		return tbl, pos
	end

	-- fixarray
	if tag >= 0x90 and tag <= 0x9F then
		local size = tag - 0x90
		local tbl = {}

		for i = 1, size do
			tbl[i], pos = readValue(str, pos)
		end

		return tbl, pos
	end

	-- fixstr
	if tag >= 0xA0 and tag <= 0xBF then
		local size = tag - 0xA0
		local value = str:sub(pos, pos + size - 1)

		return value, pos + size
	end

	-- nil
	if tag == 0xC0 then
		return nil, pos
	end

	-- false
	if tag == 0xC2 then
		return false, pos
	end

	-- true
	if tag == 0xC3 then
		return true, pos
	end

	-- uint8
	if tag == 0xCC then
		local value = str:byte(pos)
		return value, pos + 1
	end

	-- uint16
	if tag == 0xCD then
		return readU16BE(str, pos)
	end

	-- uint32
	if tag == 0xCE then
		return readU32BE(str, pos)
	end

	-- float64
	if tag == 0xCB then
		local bytes = str:sub(pos, pos + 7)
		return unpackF64BE(bytes), pos + 8
	end

	-- str8
	if tag == 0xD9 then
		local size = str:byte(pos)
		pos += 1

		local value = str:sub(pos, pos + size - 1)
		return value, pos + size
	end

	-- str16
	if tag == 0xDA then
		local size
		size, pos = readU16BE(str, pos)

		local value = str:sub(pos, pos + size - 1)
		return value, pos + size
	end

	-- custom Roblox Vector3 marker:
	-- C7 02 93 CB <x> CB <y> CB <z>
	if tag == 0xC7 then
		local customType = str:byte(pos)
		pos += 1

		if customType == 0x02 then
			local arr
			arr, pos = readValue(str, pos)

			return Vector3.new(arr[1], arr[2], arr[3]), pos
		end

		error("Unknown custom type: " .. tostring(customType))
	end

	error(string.format("Unsupported tag 0x%02X at byte %d", tag, pos - 1))
end

function PacketCodec.decode(data)
	local str = toBinaryString(data)

	local value, pos = readValue(str, 1)

	if pos <= #str then
		warn("Decode finished, but there are leftover bytes:", #str - pos + 1)
	end

	return value
end

local function writeValue(value)
	local valueType = type(value)
	local robloxType = typeof(value)

	if value == nil then
		return string.char(0xC0)
	end

	if valueType == "boolean" then
		return string.char(value and 0xC3 or 0xC2)
	end

	if valueType == "number" then
		if value % 1 == 0 and value >= 0 and value <= 0x7F then
			return string.char(value)
		end

		if value % 1 == 0 and value >= 0 and value <= 0xFF then
			return string.char(0xCC, value)
		end

		if value % 1 == 0 and value >= 0 and value <= 0xFFFF then
			return string.char(0xCD) .. packU16BE(value)
		end

		if value % 1 == 0 and value >= 0 and value <= 0xFFFFFFFF then
			return string.char(0xCE) .. packU32BE(value)
		end

		return string.char(0xCB) .. packF64BE(value)
	end

	if valueType == "string" then
		local len = #value

		if len <= 31 then
			return string.char(0xA0 + len) .. value
		end

		if len <= 0xFF then
			return string.char(0xD9, len) .. value
		end

		if len <= 0xFFFF then
			return string.char(0xDA) .. packU16BE(len) .. value
		end

		error("String too long")
	end

	if robloxType == "Vector3" then
		return string.char(0xC7, 0x02)
			.. writeValue({
				value.X,
				value.Y,
				value.Z
			})
	end

	if valueType == "table" then
		if isArray(value) then
			local len = #value

			if len > 15 then
				error("Only fixarray 0-15 is supported in this simple encoder")
			end

			local out = { string.char(0x90 + len) }

			for i = 1, len do
				table.insert(out, writeValue(value[i]))
			end

			return table.concat(out)
		else
			local count = 0

			for _ in pairs(value) do
				count += 1
			end

			if count > 15 then
				error("Only fixmap 0-15 is supported in this simple encoder")
			end

			local out = { string.char(0x80 + count) }

			for k, v in pairs(value) do
				table.insert(out, writeValue(k))
				table.insert(out, writeValue(v))
			end

			return table.concat(out)
		end
	end

	error("Cannot encode type: " .. tostring(robloxType))
end

function PacketCodec.encode(value)
	return writeValue(value)
end

function example()
  local raw = "\x93\x04\xCC\x8A\x91\x89\xA2tp\xC7\x02\x93\xCB@\x8E\xB1$@\x00\x00\x00\xCB@K\xFE\xDC\xE0\x00\x00\x00\xCB\xC0iL\xD4@\x00\x00\x00\xACactivationId\x02\xA8actionId\xA9\xE9\x95\xBF\xE5\x89\x91/C1\xA2we\xC3\xACskillUseType\xA6manual\xA8position\xC7\x02\x93\xCB@\x8F\xBF;\x00\x00\x00\x00\xCB@LC\xE7 \x00\x00\x00\xCB\xC0j\x9C\f\xC0\x00\x00\x00\xA6facing\xC7\x02\x93\xCB\xBF\xEE\xE8\xC7\x80\x00\x00\x00\x00\xCB?\xD0\x91!\xC0\x00\x00\x00\xAAweaponType\xA5Sword\xAEbasisDirection\xC7\x02\x93\xCB\xBF\xEE\x90\x03`\x00\x00\x00\x00\xCB?\xD2\xF7b\xA0\x00\x00\x00"
  
  local decoded = PacketCodec.decode(raw)
  
  
  
  table.foreach(decoded, print)
  
  local encoded = PacketCodec.encode(decoded)
  
  print(PacketCodec.toEscaped(encoded))
end

-- example()

return PacketCodec
