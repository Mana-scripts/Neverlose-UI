return function (id)
    local LoadScript_Table = {
        Source = ""
    }

    function LoadScript_Table:Load()
        local success, err = pcall(function()
            loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Games/"..tostring(id).."/"..LoadScript_Table.Source..".lua"))()
        end)
        if not success then
            warn("Something went wrong | ", err)
        end
    end

    return LoadScript_Table
end
