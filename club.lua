-- some unique func
local offsetDirections = {
  [North]      =  {0,-1},
  [East]       =  {1,0},
  [South]      =  {0,1},
  [West]       =  {-1,0},
  [NorthEast]  =  {-1,-1},
  [SouthEast]  =  {-1,1},
  [SouthWest]  =  {1,1},
  [NorthWest]  =  {1,-1},
}
function Creature.getNextPosition(self,offset,ignoreDiagonal)
  local nextDir = self:getDirection()
  if ignoreDiagonal and nextDir > 3 then
    if table.find({NorthEast,SouthEast},nextDir) then
      nextDir = East
    else
      nextDir = West
    end
  end
  offset = offset or 1
  local off = offsetDirections[nextDir]
  local pos = self:getPosition()
  pos.x, pos.y = pos.x + (off[1] * offset), pos.y + (off[2] * offset)
  return pos
end

function Creature.getNextTile(self,offset,ignoreDiagonal)
  local nextPos = self:getNextPosition(offset,ignoreDiagonal)
  return g_map.getTile(nextPos)
end

function getTilesInRange(distance,position,ignoreBelow)
  local t = {}
  local d = distance or 2
  local pos = position or pos()
  for x = -d,d do
    for y = -d,d do
      if not ignoreBelow or x ~= 0 or y ~= 0 then
        local tile = g_map.getTile({x=pos.x+x,y=pos.y+y,z=pos.z})
        if tile then
          table.insert(t,tile)
        end
      end
    end
  end
  return t
end

function findItemOnGroundInRange(id,range,position,ignoreBelow)
  local pos = position or pos()
  for i, tile in ipairs(getTilesInRange(range,pos,ignoreBelow)) do
    for j, item in ipairs(tile:getItems()) do
      if item:getId() == id then return item end
    end
  end
end
