

local btnZomIn = UI.Button("zoomIn", function() zoomIn() end)
local btnZomOut = UI.Button("zoomOut", function() zoomOut() end)
local btnExitLabel = UI.Button("IdzExit", function() CaveBot.gotoLabel("exit") end) 
----

local clIcon = addIcon("clI", {text="Label:\nExit",switchable = false, movable=true}, function()
 CaveBot.gotoLabel("exit")
 CaveBot.setOn()
end)
clIcon:setSize({height=40,width=50})
clIcon.text:setFont('verdana-11px-rounded')
clIcon:breakAnchors()
clIcon:move(75,95)