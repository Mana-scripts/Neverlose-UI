local Module = {}

function Module:Discord(code)
  local req = (syn and syn.request) or (http and http.request) or http_request
  if req then
    req({
      Url = 'http://127.0.0.1:6463/rpc?v=1',
      Method = 'POST',
      Headers = {
        ['Content-Type'] = 'application/json',
        Origin = 'https://discord.com'
      },
      Body = game:GetService('HttpService'):JSONEncode({
        cmd = 'INVITE_BROWSER',
        nonce = game:GetService('HttpService'):GenerateGUID(false),
        args = {code = code}
      })
    })
    else
    if setclipboard then
      setclipboard(tostring(code))
    end
  end
end

function Module:TapSimulatorRemoteBypass()
    local tables = {}
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            table.insert(tables, obj)
        end
    end
    print("-------------------------------- \n")
    local EventsFolder, FunctionsFolder, Remotes = nil, nil, {}
    for i, v in pairs(tables) do
        local success, err = pcall(function()
            if v.OpenEgg and type(v) == "table" then
                for i, v in pairs(v) do
                    if v.Remote and v.Name and typeof(v.Remote) == "Instance" and type(v) == "table" then
                        if v.Folder.Name == "Functions" then
                            v.Remote.Name = v.Name
                            FunctionsFolder = v.Folder
                        end
                        
                        if v.Folder.Name == "Events" then
                            v.Remote.Name = v.Name
                            EventsFolder = v.Folder
                        end

                        for i,v in pairs(v.Folder:GetChildren()) do
                            Remotes[v.Name] = v
                        end
                    end
                end
            end
        end)
        if not success then
            -- print(err)
        end
    end
    
    for i,v in pairs(Remotes) do
        print(i,v)
    end

  return EventsFolder, FunctionsFolder, Remotes
end

return Module
