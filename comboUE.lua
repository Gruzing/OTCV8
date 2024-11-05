local leaderName = ""
local leaderSpell = ""
local comboSpell = ""
local m_combo = macro(10000, "ComboUe", function() end) 
onTalk(function(name, level, mode, text, channelId, pos)
  if m_combo.isOn() then
    if name:lower() == leaderName:lower() and text:lower() == leaderSpell:lower() and pos and pos.z == posz() and distanceFromPlayer(pos) < 5 then
      say(comboSpell)
    end
  end
end)
