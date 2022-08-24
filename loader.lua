if not isfolder("illusion") then
  makefolder("illusion")
  makefolder("illusion/bases")
  local backupUrl = "https://raw.githubusercontent.com/incelsub/uwusion/main/backup"
  writefile("illusion/main.lua", game:HttpGet(backupUrl .. "/main.lua"))
  writefile("illusion/8f4UD6py.lua", game:HttpGet(backupUrl .. "/8f4UD6py.lua"))
  writefile("illusion/e3vwnjPx.lua", game:HttpGet(backupUrl .. "/e3vwnjPx.lua"))
end

local hooker = getgenv()[string.reverse("noitcnufkooh")]

local serialize = function(data)
  return game:GetService("HttpService"):JSONEncode(data)
end

local deserialize = function(data)
  return game:GetService("HttpService"):JSONDecode(data)
end

local crackBody = serialize({
  success = true,
  response = {
    key = "uwu"
  }
})

local oldSynReq; oldSynReq = hooker(syn.request, function(tbl)
  if tbl.Url == "https://authillusion.lol/linkvertise/bloxburg" then
    print("Returning cute body")
    return { Body = crackBody }
  end
  if tbl.Url == "https://authillusion.lol/bloxburg/createbase" then
    print("intercepting base save request")
    local baseId = string.split(game:GetService("HttpService"):GenerateGUID(false), "-")[1]
    writefile("illusion/bases/" .. baseId .. ".json", tbl.Body)
    return { Body = serialize({
      success = true,
      response = {
        BaseID = baseId
      }
    }) }
  end
  if tbl.Url == "https://authillusion.lol/bloxburg/getbase" then
    print("intercepting get base request")
    local data = deserialize(tbl.Body)
    local baseData = readfile("illusion/bases/" .. data.base_id .. ".json")
    if not baseData then
      return { Body = serialize({
        success = false,
        error = 404
      }) }
    end
    return { Body = serialize({
      success = true,
      response = {
        baseJson = deserialize(baseData).base_json
      }
    }) }
  end
  return oldSynReq(tbl)
end)

local oldHttpGet; oldHttpGet = hooker(game.HttpGet, newcclosure(function(self, url)
  if string.match(url, "pastebin.com") then
    local fileName = string.split(url, "/raw/")[2]
    local backupFile = readfile("illusion/" .. fileName .. ".lua")
    if backupFile then 
      return backupFile 
    end
  end
  return oldHttpGet(self, url)
end))

loadstring(readfile("illusion/main.lua"))()

local uwusionWhitelist = game:GetService("CoreGui"):WaitForChild("Illusion Whitelist")
local tab = uwusionWhitelist:WaitForChild("Frame"):WaitForChild("FeaturesContainer"):WaitForChild("ScrollingFrame")
local keyBox = tab:WaitForChild("Textbox")
local submitKey = tab:WaitForChild("Submit Key")
keyBox.TextBox.Text = "uwu"
task.wait()
firesignal(submitKey.TextButton.MouseButton1Down)
