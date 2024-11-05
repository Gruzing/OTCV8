
local m = macro(1000, "Enable combo", function() end)
UI.Label("Leader:")
addTextEdit("leader", storage.comboLeader or "Player name", function(widget, text)
    storage.comboLeader = text
end)
UI.Label("Rune ID:")
addTextEdit("attack", storage.comboAttack or "3155", function(widget, text)
    storage.comboAttack = text
end)
addSeparator()

onMissle(function(missle)
    if m.isOff() then return end
    local src = missle:getSource()
    if src.z ~= posz() then
      return
    end
    local from = g_map.getTile(src)
    local to = g_map.getTile(missle:getDestination())
    if not from or not to then
      return
    end
    local fromCreatures = from:getCreatures()
    local toCreatures = to:getCreatures()
    if #fromCreatures ~= 1 or #toCreatures ~= 1 then
      return
    end
    local c1 = fromCreatures[1]
    local t1 = toCreatures[1]
    if c1:getName():lower() == storage.comboLeader:lower() then
        useWith(tonumber(storage.comboAttack), t1)
    end
end)