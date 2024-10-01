-- Zbieraj przedmioty z podłogi (używaj oszczędnie, aby uniknąć debugowani
catarChao = macro(500, "- Catar Itens do chao -", function()
  if not storage.pickUp[1] then return end
  for x = -CheckPOS, CheckPOS do
    for y = -CheckPOS, CheckPOS do
    local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
      if tile then
      local things = tile:getThings()
        for a, item in pairs(things) do
          for c, catar in pairs(storage.pickUp) do
            if table.find(catar, item:getId()) then
            local containers = getContainers()
              for _, container in pairs(containers) do            
                for g, guardar in pairs(storage.containerpickUp) do
                  if table.find(guardar, container:getContainerItem():getId()) then
                    g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())
                    delay(100)               
                  end  
                end
              end
            end
          end
        end
      end
    end
  end
end)


if type(storage.pickUp) ~= "table" then
  storage.pickUp = {3035, 3246}
end

if type(storage.containerpickUp) ~= "table" then
  storage.containerpickUp = {21411}
end

local pickUpContainer = UI.Container(function(widget, items)
  storage.pickUp = items
end, true)
pickUpContainer:setHeight(35)
pickUpContainer:setItems(storage.pickUp)

local CheckPOS = 7 -- ilość SQM wokół znaku, który będzie sprawdzany.. Zostawiam 1.

UI.Label("BackPack p/ Coletar")
local containerpickUpContainer = UI.Container(function(widget, items)
  storage.containerpickUp = items
end, true)
containerpickUpContainer:setHeight(35)
containerpickUpContainer:setItems(storage.containerpickUp)