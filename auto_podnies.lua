---
Global = {}
Global.PickupList = {"11693", "8024", "11701", "3560", "8060", "3560", "8062", "3442", "6531", "6511", "10202", "3427", "10202", "6531", " 6567", "3553", "9302", "7924"}
-- Macro:
local pickupmacro = macro(500, "Zbieraj Rare", function()
  local tiles = getNearTiles(pos())
  for _, tile in pairs(tiles)) do
  local topThing = tile:getTopLookThing()
  if topThing and table.find(Global.PickupList, topThing:getId()) then
    g_game.move(topThing, {x=65535, y=SlotBack, z=0}, topThing:getCount())
  end
  end
end)
-- Icon
local pickupmacroicon = addIcon("PickUp", {item=id=2134, count=100, text = "Pickup"}, function(icon, isOn)
  pickupmacro.setOn(isOn)
end)