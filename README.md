# Neverlose UI Game Loader

A simple Roblox script loader that automatically loads supported game scripts from the Neverlose-UI library based on the current `PlaceId`.

## 📦 Features

* Auto-detects game using `game.PlaceId`
* Loads script from GitHub repository
* Supports multiple games
* Encodes spaces in file names automatically
* Copies PlaceId to clipboard
* Displays welcome message after loading
* Easy to expand with new games

---

## 📁 Script Structure

### Data Table

```lua
local Data = {
	Owner = "Mana",
	Library = "Neverlose-UI"
}
```

Defines:

* **Owner** → GitHub username
* **Library** → Repository name

This builds the base GitHub URL automatically.

---

### Base URL

```lua
local BaseURL = ("https://raw.githubusercontent.com/%s-scripts/%s/refs/heads/main/Games/"):format(Data.Owner, Data.Library)
```

Generates:

```
https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Games/
```

---

### EncodeSpaces Function

```lua
local function EncodeSpaces(str)
	return BaseURL .. str:gsub(" ", "%%20")
end
```

Encodes spaces in file names:

```
Anime Fighting Simulator.lua
↓
Anime%20Fighting%20Simulator.lua
```

---

### Supported Games

```lua
local Games = {
	[18172550962] = EncodeSpaces("Pixel Blade.lua"),
	[18172553902] = EncodeSpaces("Pixel Blade.lua"),
	[130247632398296] = EncodeSpaces("Anime Fighting Simulator.lua"),
	[76285745979410] = EncodeSpaces("Anime Card Collection.lua"),
	[75992362647444] = EncodeSpaces("Tap Simulator.lua"),
	[74260430392611] = EncodeSpaces("Rebirth Champions Ultimate.lua"),
	[2753915549] = EncodeSpaces("Blox Fruits.lua"),
	[4442272183] = EncodeSpaces("Blox Fruits.lua"),
	[7449423635] = EncodeSpaces("Blox Fruits.lua"),
}
```

Each **PlaceId** maps to a script file inside:

```
Games/
```

Example:

```
2753915549 → Blox Fruits.lua
```

---

## 🚀 Usage

### Run the Loader

```lua
LoadScript(game.PlaceId)
```

The script will:

1. Detect current game
2. Find matching PlaceId
3. Load script from GitHub
4. Execute it
5. Print welcome message

---

## 🧠 Load Function

```lua
function LoadScript(id)
	local url = Games[id]

	if not url then
		warn("Game not supported:", id)
		return
	end
    
	print("Loading:", url)

	local scriptSource = game:HttpGetAsync(url)
	loadstring(scriptSource)()
	print("Welcome "..game.Players.LocalPlayer.Name.."!")
end
```

### How it works

* Gets script URL from `Games` table
* Downloads script using `HttpGetAsync`
* Executes using `loadstring`
* Greets player

---

## 📋 Clipboard Utility

```lua
print(game.PlaceId)
setclipboard(tostring(game.PlaceId))
```

This:

* Prints PlaceId
* Copies PlaceId to clipboard

Useful for adding new games.

---

## ➕ Adding New Games

### Step 1

Upload script to:

```
Games/New Game.lua
```

### Step 2

Add PlaceId:

```lua
[123456789] = EncodeSpaces("New Game.lua"),
```

### Step 3

Done ✅

---

## ⚠️ Game Not Supported

If game is not supported:

```
Game not supported: 123456789
```

Add it to the `Games` table.

---

## 📂 Repository Structure

```
Neverlose-UI/
│
├── Games/
│   ├── Blox Fruits.lua
│   ├── Pixel Blade.lua
│   ├── Anime Fighting Simulator.lua
│   ├── Tap Simulator.lua
│
└── Loader.lua
```

---

## 👤 Author

**Mana**

GitHub:
[https://github.com/Mana-scripts](https://github.com/Mana-scripts)

---

## 🛠 Requirements

* Roblox Executor
* HttpGet enabled
* loadstring support

---

## 📜 License
