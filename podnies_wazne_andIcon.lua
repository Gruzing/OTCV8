
--- lista itemow ktore maja zostac automatycznie podniesoone:
----{ jagody, pomarancze, gold nugget[NG], scarab coin[SC], diamond token, war token, bialy token, marchew, ryby, cukierki, siano ..., }
local useitemlist = { 3588, 3586, 3040, 3042, 3028, 3542, 3539, 3605, 2478 }
pickupmacro = macro(500, "Podnies Wazne", function()
  if freecap() < 10 then return end
    local tiles = getNearTiles(pos())
    for _, tile in pairs(tiles) do
        local topThing = tile:getTopLookThing()
        if topThing and table.find(useitemlist, topThing:getId()) then
            g_game.move(topThing, {x = 65535, y=SlotBack, z=0}, topThing:getCount())
        end
    end
end)
UI.Separator()

addIcon("pickup", {item={id=2119, count=1}, text="PickIT"}, function(icon, isOn)
  pickupmacro.setOn(isOn) 
end)