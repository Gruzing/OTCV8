-- create bot dir
  if not g_resources.directoryExists("/bot") then
    g_resources.makeDir("/bot")
    if not g_resources.directoryExists("/bot") then
      return onError("Can't create bot directory in " .. g_resources.getWriteDir())
    end
  end
  
  -- get list of configs
  createDefaultConfigs()
  local configs = g_resources.listDirectoryFiles("/bot", false, false)  

-- clean
  configList.onOptionChange = nil
  enableButton.onClick = nil
  configList:clearOptions()  
     
  -- select active config based on settings
  local settings = g_settings.getNode('bot') or {}
  local index = g_game.getCharacterName() .. "_" .. g_game.getClientVersion()
  if settings[index] == nil then
    settings[index] = {
      enabled=false,
      config=""
    }
  end  

  -- init list and buttons
  for i=1,#configs do 
    configList:addOption(configs[i])
  end
  configList:setCurrentOption(settings[index].config)
  if configList:getCurrentOption().text ~= settings[index].config then
    settings[index].config = configList:getCurrentOption().text
    settings[index].enabled = false
  end
  
  enableButton:setOn(settings[index].enabled)
  
  configList.onOptionChange = function(widget)
    settings[index].config = widget:getCurrentOption().text
    g_settings.setNode('bot', settings)
    g_settings.save()
    refresh()
  end
  
  enableButton.onClick = function(widget)
    settings[index].enabled = not settings[index].enabled
    g_settings.setNode('bot', settings)
    g_settings.save()
    refresh()    
  end
  
  if not g_game.isOnline() or not settings[index].enabled then
    statusLabel:setOn(true)
    statusLabel:setText("Status: disabled\nPress off button to enable")
    return
  end
  
  local configName = settings[index].config

  
