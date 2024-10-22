setDefaultTab("OWN")
UI.Label("CheckMSG")
local checkOnText = macro(100, "Check onTextMSG", function() end)
local checkOnTalk = macro(100, "Check onTalkMSG", function() end)
onTextMessage(function(mode, text)
--if  mode == 17 or mode == 28 then return end
--if channelId == 13 then
  if checkOnText.isOff() then return end
  print("[onTXT][T]: " .. text .. ". [M]: [" .. mode .. "].")
end)
onTalk(function(name, level, mode, text, channelId, pos)
  if checkOnTalk.isOff() then return end
  print("Message: " .. text .. " Napisana przez: " .. name .. " Na kanaleno ID: " .. channelId .. " Posiada Mode: " .. mode)
end)
UI.Separator()

local a = "getChildren"
local b = "getText"
local c = "channelId"
local d = "Nazwa chatu: "
local e = ", ID chatu: "

local f = function(w)
    local g = w[a](w)
    for h = 1, #g do
        local i = g[h]
        if i[b](i) ~= '' then
            local j = i[c]
            local k = i[b](i)
            print(d .. k .. e .. j)
        end
    end
end

listakanalow = macro(1000, "ChannelListDownload", function()
    g_game.requestChannels()
    local l = modules.game_console.channelsWindow
    if l then
        local m = l:getChildById('channelList')
        if m then
            f(m)
            listakanalow.setOff()
        end
    end
end)
UI.Separator()
UI.Button("Term", function() modules.client_terminal.toggle() end)
UI.Separator()
