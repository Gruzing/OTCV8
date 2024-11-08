
-- Auto select channel 
UI.Label('Zaznaczanie kanalu:') 
UI.TextEdit(storage.selectChannel or "1", function(widget, text) 
  storage.selectChannel = text 
end) 
macro(750, "Select Channel", function() 
  local channels = g_ui.getRootWidget():recursiveGetChildById("channels") 
  local widget = channels:getParent() 
  local submit = widget:recursiveGetChildById("submitButton") 
  if #channels:getChildren() > 0 then 
    channels:focusChild(channels:getChildByIndex(storage.selectChannel)) 
    submit:onClick() 
  end 
end) 
