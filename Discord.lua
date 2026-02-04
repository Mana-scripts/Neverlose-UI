return function(code)
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
