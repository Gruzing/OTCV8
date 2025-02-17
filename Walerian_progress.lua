setDefaultTab("Own")

local message = "Pokonales"
local wal_macro = macro(100000, "WalProg", function() end)
onTalk(function(name, level, mode, text, channelId, pos)
 if wal_macro.isOff() then return end
 if channelId ~= 13 then return end
 if string.find(text, message) then
  local regex = [[([0-9]*)\/([0-9]*)]]
   local re = regexMatch(text, regex)
    if #re ~= 0 then
     local currentCount, maxCount = tonumber(re[1][2]), tonumber(re[1][3])
      if currentCount >= maxCount then
        storage.walDone = true
        print("[Walerian]: skonczony.")
      end
    end
  end
end)
