setDefaultTab("Main");

---- MAIN FUNCTIONS TO CORRECT WORK.
-- odczyt pliku z zapisana lista.
readJson = function(filePath, callback)
    if g_resources.fileExists(filePath) then
        local status, result = pcall(function()
            return json.decode(g_resources.readFileContents(filePath))
        end)
        if not status then
            return onError("Blad ladowania pliku (" .. filePath .. "). Aby rozwiazac problem, usun plik. Blizsze dane: " .. result)
        end

        callback(result);
    end
end

-- zapisywanie zabic

saveKills = function(configFile, content)
    local status, result = pcall(function()
        return json.encode(content, 2)
    end);

    if not status then
        return onError("Blad podczas zapisywania konfiguracji. Blizsze dane: " .. result);
    end

    if result:len() > 100 * 1024 * 1024 then
        return onError("Plik konfiguracyjny wiekszy niz 100 MB nie zostanie zapisany.");
    end

    g_resources.writeFileContents(configFile, result);
end

-- definicja katalogu do zapisu

MAIN_DIRECTORY = "/bot/" .. modules.game_bot.contentsPanel.config:getCurrentOption().text .. "/storage/" .. g_game.getWorldName() ..'/'
STORAGE_DIRECTORY = "" .. MAIN_DIRECTORY .. name() ..  '.json';

--zdefiniowanie killLisyy

storageMonsters = {
    kills = {};
}

if not g_resources.directoryExists(MAIN_DIRECTORY) then
    g_resources.makeDir(MAIN_DIRECTORY);
end

readJson(STORAGE_DIRECTORY, function(result)
    storageMonsters = result;
    if (type(storageMonsters.kills) ~= 'table') then
        storageMonsters.kills = {};
    end
end);


-- Kill Lista skrypt
-- 

local mkPanelname = "monsterKill"
if not storage[mkPanelname] then storage[mkPanelname] = { min = false } end

--UI

local monsterKill = setupUI([[
Panel
  margin-top: 5
  height: 130

  Button
    id: resetList
    anchors.left: parent.left
    anchors.top: parent.top
    width: 20
    height: 17
    margin-top: 2
    margin-left: 3
    text: !
    color: red
    tooltip: Reset Data

  Button
    id: showList
    anchors.right: parent.right
    anchors.top: parent.top
    width: 20
    height: 17
    margin-top: 2
    margin-right: 3
    text: -
    color: red

  BotTextEdit
    id: filter
    text-align: center
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    height: 20
    width: 100
    editable: true
    max-length: 255

  ScrollablePanel
    id: content
    image-source: /images/ui/menubox
    image-border: 4
    image-border-top: 17
    anchors.top: showList.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 88
    padding: 3
    vertical-scrollbar: mkScroll
    layout:
      type: verticalBox

  BotSmallScrollBar
    id: mkScroll
    anchors.top: content.top
    anchors.bottom: content.bottom
    anchors.right: content.right
    margin-top: 2
    margin-bottom: 5
    margin-right: 5
  
  ]], parent)
monsterKill:setId(mkPanelname)
local lbls = {};

local function toggleWin(load)
    if load then
        monsterKill:setHeight(20)
        monsterKill.showList:setText("+")
        monsterKill.showList:setColor("green")
    else
        monsterKill:setHeight(115)
        monsterKill.showList:setText("-")
        monsterKill.showList:setColor("red")
    end
end

function refreshMK()

    local searchText = monsterKill.filter:getText():lower();

    if #lbls > 0 and (#storageMonsters.kills == #lbls) then
        local i = 1;
        for k, v in pairs(storageMonsters.kills) do
            if searchText == "" or k:lower():find(searchText, 1, true) then
                lbls[i].name:setText(k .. ':')
                lbls[i].count:setText("x"..v)
                i = i + 1;
            end
        end
    else
        for _, child in pairs(monsterKill.content:getChildren()) do
            child:destroy();
        end
        local i = 1;
        for k, v in pairs(storageMonsters.kills) do
            if searchText == "" or k:lower():find(searchText, 1, true) then
                lbls[k] = g_ui.loadUIFromString([[
Panel
  height: 16
  margin-left: 2

  Label
    id: name
    text:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    text-auto-resize: true
    font: verdana-11px-bold

  Label
    id: count
    text:
    anchors.top: name.top
    anchors.right: parent.right
    margin-right: 30
    text-auto-resize: true
    color: orange
    font: verdana-11px-bold

]], monsterKill.content)

                if lbls[k] then
                    lbls[k].name:setText(k .. ':')
                    lbls[k].count:setText("x"..v)
                end
                monsterKill.resetList.onClick = function(widget)
                    storageMonsters.kills[k] = nil;
                    saveKills(STORAGE_DIRECTORY, storageMonsters)
                    refreshMK()
                end
                monsterKill.resetList.onDoubleClick = function(widget)
                    storageMonsters.kills = {};
                    saveKills(STORAGE_DIRECTORY, storageMonsters)
                    refreshMK()
                end
                i = i + 1;
            end
        end
    end
end

function getKills(mobName)

    if storageMonsters.kills[mobName] then

        return storageMonsters.kills[mobName];
    end
    return 0;
end

function checkKillOnCreature(creature)
    local creatureName = creature:getName();
    if storageMonsters.kills[creatureName] then
        storageMonsters.kills[creatureName] = storageMonsters.kills[creatureName] + 1;
    else
        storageMonsters.kills[creatureName] = 1;
    end
    refreshMK();
    saveKills(STORAGE_DIRECTORY, storageMonsters);
end


refreshMK();
toggleWin(storage[mkPanelname].min);

monsterKill.showList.onClick = function(widget)
    storage[mkPanelname].min = (monsterKill:getHeight() == 115)
    toggleWin(storage[mkPanelname].min)
end

monsterKill.filter.onTextChange = function(widget)
    refreshMK();
end


onCreatureHealthPercentChange(function(creature, percent)
    if (not creature:isMonster()) then return; end
    if creature:getHealthPercent() <= 0 and g_game.getAttackingCreature() == creature then
        checkKillOnCreature(creature)
    end
end);