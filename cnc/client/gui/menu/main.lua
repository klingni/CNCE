_menuPool = MenuPool.New()
_menuPool:RefreshIndex()
mainMenu = nil


local Maps = {}
local choosenMap
local copHint = true
local randomeTeams = false
local choosenTrafficDensity = 0.5
local choosenPedDensity = 0.5
local choosenTime = 0.5


TriggerServerEvent('CNC:Map:startInit')
TriggerEvent('CNC:createMarker')


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function AddMenuMaps(menu)
    local maps = {
        "RANDOME"
    }

    for i,map in ipairs(Maps) do
        table.insert( maps,map['infos']['title'] )
    end

    local newitemMap = NativeUI.CreateListItem("Maps", maps, 1, 'Maps')
    
    local densityTrafficDensity = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
    local newitemTrafficDensity = NativeUI.CreateListItem("Traffic Density", densityTrafficDensity, 6, 'Set Traffic density')

    local densityPed = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
    local newitemPedDensity = NativeUI.CreateListItem("Ped Density", densityPed, 6, 'Set Traffic density')

    local time = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
    local newitemTime = NativeUI.CreateListItem("Time", time, 6, 'Set Time')
    
    
    menu:AddItem(newitemMap)
    menu:AddItem(newitemTrafficDensity)
    menu:AddItem(newitemPedDensity)
    menu:AddItem(newitemTime)


    menu.OnListChange = function(sender, item, index)
        if item == newitemMap then
            choosenMap = index - 1
        elseif item == newitemTrafficDensity then

            choosenTrafficDensity = (index -1)/10
        elseif item == newitemPedDensity then
            choosenPedDensity = (index -1)/10
        elseif item == newitemTime then
            choosenTime = (index -1)/10
        end
    end
end

function AddMenuCopHint(menu)
    local newitemHint = NativeUI.CreateCheckboxItem("Show Cop hints", copHint,  "Shows the cops the possible getaway positions on the map.")
    local newitemChoice = NativeUI.CreateCheckboxItem("Randome Team", randomeTeams,  "Choose teams randomly or by yourself.")
   
    menu:AddItem(newitemHint)
    menu:AddItem(newitemChoice)
    
    menu.OnCheckboxChange = function(sender, item, checked_)
        if item == newitemHint then
            copHint = checked_
            print('copHint: ' .. tostring(copHint))
        end
        if item == newitemChoice then
            randomeTeams = checked_
            print('randomeTeams: ' .. tostring(randomeTeams))
        end
    end
end

function AddMenuStartRound(menu)
    local newitem = UIMenuItem.New("~g~Start / Join Round~s~", "Starts a CNC-Round or join a running Round.")
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, index)
        if item == newitem then
            local string = "Start/Join Round"
            ShowNotification(string)
            --TriggerServerEvent('CNC:startRound', choosenMap, true, randomeTeams)
            TriggerServerEvent('CNC:startRound', choosenMap, copHint, randomeTeams, choosenPedDensity, choosenTrafficDensity, choosenTime)
        end
    end
end



RegisterNetEvent('CNC:Map:init')
AddEventHandler('CNC:Map:init', function (maps)
    Maps = maps
    --Citizen.Trace(#maps)
end)


function openMenu( )
    TriggerServerEvent('CNC:Map:refreshMap')
    choosenMap = 0
    --Citizen.Trace('open Menue')
    mainMenu = NativeUI.CreateMenu("Settings", "~b~Settings")
    _menuPool:Add(mainMenu)
    AddMenuMaps(mainMenu)
    AddMenuCopHint(mainMenu)
    AddMenuStartRound(mainMenu)

    _menuPool:RefreshIndex()
    mainMenu:Visible(true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
         _menuPool:MouseControlsEnabled(false)
        _menuPool:ControlDisablingEnabled(false)

        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 166) then
            if mainMenu == nil then
                openMenu()
            else
                if (not _menuPool:IsAnyMenuOpen()) then
                    openMenu()
                else
                    _menuPool:CloseAllMenus()
                end
            end
        end
    end
end)
