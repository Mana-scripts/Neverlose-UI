local Loader_Module = {
    Source = ""
}

function Loader_Module:LoadScript(id)

    local success, err = pcall(function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Games/"..tostring(id).."/"..Loader_Module.Source..".lua"))()
    end)
    if not success then
        warn("Something went wrong | ", err)
    end

end

return Loader_Module
