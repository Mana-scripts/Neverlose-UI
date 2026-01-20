local function LoadScript(id)
    local LoadScript_Table = {}

    function LoadScript_Table:Load(str)
        local success, err = pcall(function()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Games/"..tostring(id).."/"..LoadScript_Table.Source..".lua"))()
        end)
        if not success then
            warn("Something went wrong | ", err)
        end
    end

    return LoadScript_Table
end

local Loader = LoadScript(game.PlaceId)
--Loader.Source = "Source"
--Loader:Load()
