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

