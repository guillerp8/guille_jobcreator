local PlayerData = {}
local configs = {}
local playerPoints = {}
local job = nil
local points = 0
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(0) 
    end 
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = ESX.GetPlayerData()
    TriggerEvent("guille_jobs:client:syncJobs")
    
end)

function ShowFloatingHelpNotification(msg, coords)
	SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z + 0.7)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(2, false, true, -1)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    TriggerEvent("guille_jobs:client:syncJobs")
end)

local blipsCreated = {}

RegisterNetEvent("guille_jobs:client:syncJobs")
AddEventHandler("guille_jobs:client:syncJobs", function()
    Citizen.Wait(200)
    log("Receiving job data...")
    ESX.TriggerServerCallback('guille_jobs:getPoints', function(result)
        playerPoints = {}
        configs = {}
        log("Refreshing points")
        for i = 1, #result, 1 do
            table.insert(playerPoints, {job = result[i]['job'], coords = result[i]['coords'], name = result[i]['name'], heading = result[i]['heading']})
        end
        if PlayerData.job.grade_name ~= "boss" then
            for k,v in pairs(playerPoints) do
                if v.name == "boss" then
                    log("Adjusting markers")
                    table.remove(playerPoints, k)
                    break
                end
            end
        end
    end)
    ESX.TriggerServerCallback('guille_jobs:getConfigJob', function(result)
        log("Refreshing configs")
        for i = 1, #result, 1 do
            table.insert(configs, {job = result[i]['job'], idman = result[i]['idman'], vehman = result[i]['vehman'], alerts = result[i]['alerts'], handcuff = result[i]['handcuff'], bill = result[i]['bill'], obj = result[i]['obj']}) 
        end
    end)
    ESX.TriggerServerCallback('guille_jobs:getBlips', function(result)
        log("Refreshing blips")
        for i = 1, #blipsCreated, 1 do
            RemoveBlip(blipsCreated[i])
        end
        blipsCreated = {}
        for i = 1,#result, 1 do
            local blip = AddBlipForCoord(result[i]['coords']['x'], result[i]['coords']['y'], result[i]['coords']['y'])
            SetBlipSprite(blip, result[i]['sprite'])
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.9)
            SetBlipColour(blip, result[i]['color'])
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(result[i]['text'])
            EndTextCommandSetBlipName(blip)
            table.insert(blipsCreated, blip)
        end
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerData.job = job
end)


RegisterNetEvent("guille_jobcreator:client:startCreation")
AddEventHandler("guille_jobcreator:client:startCreation", function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        startCreation = true;
    })
end)

local pointsCoords = {}
RegisterNetEvent("guille_jobs:client:addPoints")
AddEventHandler("guille_jobs:client:addPoints", function(job)
    points = 0
    local vehiclecreated = true
    local veh
    while true do
        Citizen.Wait(0)
        local hit, coords, entity = RayCastGamePlayCamera(1000.0)
        DrawMarker(1, coords - vector3(0, 0, 0.3), 0, 0, 0, 0, 0, 0, 2.0000, 2.0000, 0.6001,255,0,20, 255, 0, 0, 0, 0)
        if points == 0 then
            ESX.ShowHelpNotification('Press ~r~E~w~ to add the point of boss')
            if IsControlJustPressed(1, 38) then
                Citizen.Wait(100)
                table.insert(pointsCoords, {coordsboss = coords})
                print(pointsCoords[1]['coordsboss'])
                points = points + 1
            end
        end
        if points == 1 then
            ESX.ShowHelpNotification('Press ~r~E~w~ to add the point of shop')
            if IsControlJustPressed(1, 38) then
                Citizen.Wait(100)
                table.insert(pointsCoords, {coordsshop = coords})
                points = points + 1
                print(pointsCoords[2]['coordsshop'])
            end
        end
        if points == 2 then
            ESX.ShowHelpNotification('Press ~r~E~w~ to add the point of duty')
            if IsControlJustPressed(1, 38) then
                Citizen.Wait(100)
                table.insert(pointsCoords, {coordsduty = coords})
                points = points + 1
                print(pointsCoords[3]['coordsduty'])
            end
        end
        if points == 3 then
            if vehiclecreated then
                local hash = GetHashKey("zentorno")
                RequestModel(hash)
                while not HasModelLoaded(hash) do
                    Citizen.Wait(1)
                end
                veh = CreateVehicle(hash, coords, 100.00, false, false)
                SetEntityCollision(veh, false, false)
                vehiclecreated = false
            end
            SetEntityCoords(veh, coords)
            local heading = GetEntityHeading(PlayerPedId())
            SetEntityHeading(veh, heading)           
            SetEntityAlpha(veh, 180, 0)
            ESX.ShowHelpNotification('Press ~r~E~w~ to add the point of take a vehicle')
            if IsControlJustPressed(1, 38) then
                Citizen.Wait(100)
                table.insert(pointsCoords, {coordssave = coords, heading = heading})
                points = points + 1
                
            end
        end
        if points == 4 then
            SetEntityCoords(veh, coords)
            SetEntityHeading(veh, GetEntityHeading(PlayerPedId()))
            SetEntityAlpha(veh, 180, 0)
            ESX.ShowHelpNotification('Press ~r~E~w~ to add the point of save a vehicle')
            if IsControlJustPressed(1, 38) then
                Citizen.Wait(100)
                table.insert(pointsCoords, {coordsout = coords})
                points = points + 1
                DeleteVehicle(veh)
            end
        end
        if points == 5 then
            ESX.ShowHelpNotification('Press ~r~E~w~ to add the point of clothes')
            if IsControlJustPressed(1, 38) then
                Citizen.Wait(100)
                table.insert(pointsCoords, {coordscloack = coords})
                points = points + 1
            end
        end
        if points == 6 then
            ESX.ShowHelpNotification('Press ~r~E~w~ to add the point of armory')
            if IsControlJustPressed(1, 38) then
                Citizen.Wait(100)
                table.insert(pointsCoords, {coordsstock = coords})
                points = points + 1
            end
        end
        if points == 7 then
            points = 0
            TriggerServerEvent("guille_jobs:server:addPoints", job, pointsCoords[1]['coordsboss'], pointsCoords[2]['coordsshop'], pointsCoords[3]['coordsduty'], pointsCoords[4], pointsCoords[5]['coordsout'], pointsCoords[6]['coordscloack'], pointsCoords[7]['coordsstock'])
            pointsCoords = {}
            break
        end
    end
end)



function RayCastGamePlayCamera(distance)
    -- https://github.com/Risky-Shot/new_banking/blob/main/new_banking/client/client.lua
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end


function RotationToDirection(rotation)
    -- https://github.com/Risky-Shot/new_banking/blob/main/new_banking/client/client.lua
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

RegisterNUICallback("exit", function(cb)
    SetNuiFocus(false, false) 
end)

RegisterNUICallback("create", function(cb)
    SetNuiFocus(false, false)
    if cb.job ~= "" then
        
        if cb.joblabel ~= "" then
            TriggerServerEvent("guille_jobs:server:addJob", cb.job, cb.joblabel)
        else
            log("Te ha faltado un argumento imprescindible")
        end
        if cb.grade1 ~= "" then

        else
            log("Te ha faltado un argumento imprescindible")
        end
        if cb.grade1mon ~= "" then

            TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 1, "employe", cb.grade1, cb.grade1mon)
        else
            log("Te ha faltado un argumento imprescindible")
        end
        if cb.grade2 ~= "" then
            log(cb.grade2)
        else
            log("Te ha faltado un argumento imprescindible")
        end
        if cb.grade2mon ~= "" then
            if cb.grade3 == "" or cb.grade3 == nil then
                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 2, "boss", cb.grade2, cb.grade2mon)
            else
                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 2, "guard", cb.grade2, cb.grade2mon)
            end
        else
            log("Te ha faltado un argumento imprescindible")
        end
        if cb.grade3 ~= nil then

            if cb.grade4 == "" or cb.grade4 == nil then

                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 3, "boss", cb.grade3, cb.grade3mon)
            else
                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 3, "bat", cb.grade3, cb.grade3mon)
            end
        end
        if cb.grade4 ~= nil then

            if cb.grade5 == "" or cb.grade5 == nil then
                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 4, "boss", cb.grade4, cb.grade4mon)
            else
                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 4, "batm", cb.grade4, cb.grade4mon)
            end
        end
        if cb.grade5 ~= nil then

            if cb.grade6 == "" or cb.grade6 == nil then
                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 5, "boss", cb.grade5, cb.grade5mon)
            else
                TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 5, "batma", cb.grade5, cb.grade5mon)
            end
        end
        if cb.grade6 ~= nil then

            TriggerServerEvent("guille_jobs:server:addGrade", cb.job, 6, "boss", cb.grade6, cb.grade6mon)
        end
        if cb.blipadded == 1 then

            TriggerServerEvent("guille_jobs:server:addBlip", cb.job, cb.bliptext, cb.blipsprite, cb.blipcolor)
        end
        TriggerServerEvent("guille_jobs:server:addConfigs", cb.job, cb.search, cb.handcuff, cb.vehinfo, cb.identity, cb.obj, cb.alerts, cb.bill, cb.shop)
    else
        log("Te ha faltado un argumento imprescindible")
    end

end)

function log(txt)
    print("^3[^2guille_jobs^3]^0 " ..txt)
end

Citizen.CreateThread(function()
    while true do

        local wait = 1000

        local job
        local ped = PlayerPedId()
        for k,v in pairs(playerPoints) do
            local coords = GetDistanceBetweenCoords(GetEntityCoords(ped), v.coords.x, v.coords.y, v.coords.z, true) 
            if coords < 20 then
                wait = 0
                if PlayerData.job.name == v.job then
                    DrawMarker(1, v.coords.x, v.coords.y, v.coords.z - 0.33, 0, 0, 0, 0, 0, 0, 2.0000, 2.0000, 0.6001,255,0,0, 500, 0, 0, 0, 0)
                end
            end

            if coords < 1.50 then
                
                if v.name == "boss" then
                    if PlayerData.job.grade_name == "boss" then
                        z = v.coords.z + 2
                        ShowFloatingHelpNotification("Press ~r~E~w~ to open the boss actions", vector3(v.coords.x, v.coords.y, v.coords.z ) + vector3(0, 0, 1))
                        if IsControlJustPressed(1,38) then
                            TriggerEvent("guille_jobs:bossactions")
                        end
                    end
                elseif v.name == "shop" then
                    ShowFloatingHelpNotification("Press ~r~E~w~ to open the shop", vector3(v.coords.x, v.coords.y, v.coords.z) + vector3(0, 0, 1))
                    if IsControlJustPressed(1,38) then
                        Shop()
                    end
                elseif v.name == "garagein" then
                    ShowFloatingHelpNotification("Press ~r~E~w~ to open the vehicles", vector3(v.coords.x, v.coords.y, v.coords.z) + vector3(0, 0, 1))
                    if IsControlJustPressed(1,38) then
                        Cars(v.coords.x, v.coords.y, v.coords.z, v.heading)
                    end
                elseif v.name == "stock" then
                    ShowFloatingHelpNotification("Press ~r~E~w~ to open the armory", vector3(v.coords.x, v.coords.y, v.coords.z) + vector3(0, 0, 1))
                    if IsControlJustPressed(1,38) then
                        Storage()
                    end
                elseif v.name == "garageout" then
                    ShowFloatingHelpNotification("Press ~r~E~w~ to save the vehicle", vector3(v.coords.x, v.coords.y, v.coords.z) + vector3(0, 0, 1))

                    if IsControlJustPressed(1,38) then
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local model = GetEntityModel(vehicle)
                        local carname = GetDisplayNameFromVehicleModel(model)
                        local text = GetLabelText(carname)
                        if IsPedInAnyVehicle(ped, true) then 
                            if text == "NULL" then
                                if Config.progressBars then
                                    TaskLeaveVehicle(ped, vehicle, 0)
                                    FreezeEntityPosition(vehicle, true)
                                    exports['progressBars']:startUI(3000, 'Guardando el vehículo')
                                    Citizen.Wait(3000)
                                    NetworkFadeOutEntity(vehicle, false, true)
                                    Citizen.Wait(1000)
                                    DeleteVehicle(vehicle)
                                else
                                    TaskLeaveVehicle(ped, vehicle, 0)
                                    Citizen.Wait(2000)
                                    NetworkFadeOutEntity(vehicle, false, true)
                                    Citizen.Wait(1000)
                                    DeleteVehicle(vehicle)
                                end
                                ESX.ShowNotification('You deleted a  ' .. carname)
                            else
                                if Config.progressBars then
                                    TaskLeaveVehicle(ped, vehicle, 0)
                                    FreezeEntityPosition(vehicle, true)
                                    exports['progressBars']:startUI(3000, 'Guardando el vehículo')
                                    Citizen.Wait(3000)
                                    NetworkFadeOutEntity(vehicle, false, true)
                                    Citizen.Wait(1100)
                                    DeleteVehicle(vehicle)
                                else
                                    TaskLeaveVehicle(ped, vehicle, 0)
                                    Citizen.Wait(2000)
                                    NetworkFadeOutEntity(vehicle, false, true)
                                    Citizen.Wait(1000)
                                    DeleteVehicle(vehicle)
                                end
                                ESX.ShowNotification('You deleted a  ' .. text)
                            end
                        else
                            ESX.ShowNotification('You must be in a car to delete it')
                        end
                    end
                elseif v.name == "duty" then
                    ShowFloatingHelpNotification("Press ~r~E~w~ to open duty", vector3(v.coords.x, v.coords.y, v.coords.z) + vector3(0, 0, 1))
                    if IsControlJustPressed(1, 38) then
                        TriggerServerEvent("guille_jobs:server:duty")
                    end
                elseif v.name == "cloackroom" then 
                    ShowFloatingHelpNotification("Presiona ~r~E~w~ to clothes", vector3(v.coords.x, v.coords.y, v.coords.z) + vector3(0, 0, 1))
                    if IsControlJustPressed(1, 38) then
                        skin()
                    end
                end
            end
        end  
        Citizen.Wait(wait)    
    end
end)

RegisterCommand("additem", function(source, args)

    if args[1] == "weapon" or args[1] == "item" then
        if args[2] ~= nil then
            local price = tonumber(args[3])
            if args[3] ~= nil and type(price) == 'number' then
                TriggerServerEvent("guille_jobs:server:addItem", args[1], args[2], price)
            else
                ESX.ShowNotification('Make sure to put a valid item price')
            end
        else
            ESX.ShowNotification('Enter an item or weapon')
        end
    else
        ESX.ShowNotification('Please enter a valid ~ r ~ item type ~ w ~ (~ b ~ weapon ~ w ~ o ~ b ~ item ~ w ~)')
    end

end, false)

-- Functions 

Shop = function()
    ESX.TriggerServerCallback('guille_jobs:getItemsOrWeapons', function(result)
        local elements = {}
        for i = 1, #result, 1 do
            table.insert(elements, {
                label = result[i]['label'].. ' - <span style="color:green; font-weight:bold; font-size:17px;"> $'..result[i]['price']..'</span>',
                value = result[i]['name'],
                itemType = result[i]['type'],
                price = result[i]['price'],
            })
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), "shop",
        { 
        title = "Tienda", 
        align = "bottom-right", 
        elements = elements 
        }, function(data, menu)
            TriggerServerEvent("guille_jobs:server:buyItem", data.current.value, data.current.itemType, data.current.price)
        end, function(data, menu) 
            menu.close() 
        end)
    end)
end

Cars = function(x, y, z, heading)
    ESX.TriggerServerCallback('guille_jobs:getCars', function(result)
        local elements = {}
        for i = 1, #result, 1 do
            table.insert(elements, {
                label = result[i]['model'],
                value = result[i]['model'],
            })
        end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_veh',
            {
                title    = "Vehicle spawn menu",
                align    = 'top-right',
                elements = elements
            },
        function(data, menu)
            local action = data.current.value
            ESX.Game.SpawnVehicle(data.current.value, vector3(x, y, z), heading, function(vehicle) 
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
            ESX.UI.Menu.CloseAll()
        end, function(data, menu)
            menu.close()
        end)
    end)

end

RegisterCommand("addcar", function(source, args)
    local car = args[1]
    if IsModelInCdimage(car) then
        TriggerServerEvent("guille_jobs:server:addCar", car)        
    else
        ESX.ShowNotification('That model does not exist')
    end
end, false)

RegisterNetEvent("guille_jobs:bossactions")
AddEventHandler("guille_jobs:bossactions", function()

    local options = {
        wash = Config.EnableMoneyWash,
    }
    ESX.UI.Menu.CloseAll()
    TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu) 
        menu.close()
    end,options)

end)

RegisterNetEvent("guille_jobs:reglog")
AddEventHandler("guille_jobs:reglog", function(type, gang, msg)
    TriggerServerEvent('guille_jobs:sendlog', type, gang, msg)
end)


isgang = function(job)
    for k, v in pairs(Config.Gangs) do 
       if (v.Job == job) then 
        return true
       end
    end 
    return false
end



RegisterKeyMapping('openmenugangs', ('GangMenu'), 'keyboard', 'F6')


OpenBodySearchMenu = function(player)
    ESX.TriggerServerCallback('guille_jobs:checkDupe', function(result)
        if result then
            TriggerServerEvent("guille_jobs:server:addPlayer", GetPlayerServerId(player))
            ESX.TriggerServerCallback('guille_jobs:getOtherPlayerData', function(data)
                local elements = {}
        
                for i=1, #data.accounts, 1 do
                    if data.accounts[i].name == 'money' and data.accounts[i].money > 0 then
                        table.insert(elements, {
                            label    = 'Take money: <strong><span style="color:green;">' ..ESX.Math.GroupDigits(ESX.Math.Round(data.accounts[i].money)).."$</span></strong>",
                            value    = 'money',
                            itemType = 'item_account',
                            amount   = data.accounts[i].money
                        })
                    end
                    if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                        table.insert(elements, {
                            label    = 'Take money dirty: <strong><span style="color:red;">' ..ESX.Math.GroupDigits(ESX.Math.Round(data.accounts[i].money)).."$</span></strong>",
                            value    = 'black_money',
                            itemType = 'item_account',
                            amount   = data.accounts[i].money
                        })
                    end
                end
        
                table.insert(elements, {label = ('-- Weapons --')})
        
                for i=1, #data.weapons, 1 do
                    table.insert(elements, {
                        label    = 'Take weapon: ' ..ESX.GetWeaponLabel(data.weapons[i].name).. " - " ..data.weapons[i].ammo .." bala(s)",
                        value    = data.weapons[i].name,
                        itemType = 'item_weapon',
                        amount   = data.weapons[i].ammo
                    })
                end
        
                table.insert(elements, {label = ('-- Inventario --')})
        
                for i=1, #data.inventory, 1 do
                    if data.inventory[i].count > 0 then
                        table.insert(elements, {
                            label    = 'Take item: ' .. data.inventory[i].label ..' x'..data.inventory[i].count,
                            value    = data.inventory[i].name,
                            itemType = 'item_standard',
                            amount   = data.inventory[i].count
                        })
                    end
                end
        
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
                    title    = ('search'),
                    align    = 'bottom-right',
                    elements = elements
                }, function(data, menu)
                    if data.current.value then
                        TriggerServerEvent('guille_jobs:server:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
                        TriggerServerEvent("guille_jobs:server:closePlayer", GetPlayerServerId(player))
                        OpenBodySearchMenu(player)
                    end
                end, function(data, menu)
                    TriggerServerEvent("guille_jobs:server:closePlayer", GetPlayerServerId(player))
                    menu.close()
                end)
            end, GetPlayerServerId(player))
            RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
            while not HasAnimDictLoaded('anim@gangops@facility@servers@bodysearch@') do Wait(0) end
                TaskPlayAnim(GetPlayerPed(-1), 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, 1.0, 3000, 49, 0, 0, 0, 0)
        
            Wait(3000)
        else 
            ESX.ShowNotification('Someone is searching this player')
        end
        
    end, GetPlayerServerId(player))
	
end

skin = function()
    local elements = {}
    table.insert(elements, { label = "Civil clothes", value = "civile" })
    table.insert(elements, { label = "Custom clothes", value = "custom" })

    ESX.UI.Menu.Open('default',GetCurrentResourceName(), "skin_menu",
    { 
        title = "Skin menu", 
        align = "bottom-right", 
        elements = elements 
    }, function(data, menu)
        local v = data.current.value
        if v == "work" then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
                    print(jobSkin.skin_male)
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
            end)
        elseif v == "custom" then
            openCustomClothesMenu()
        elseif v == "civile" then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
    end, function(data, menu) 
        menu.close() 
    end)
end

RegisterCommand("addcustomclothes", function(source, args)
    TriggerEvent('skinchanger:getSkin', function(skin) plySkin = skin; end)
	local clothes = '{\"tshirt_1\":'..plySkin["tshirt_1"]..',\"tshirt_2\":'..plySkin["tshirt_2"]..',\"torso_1\":'..plySkin["torso_1"]..',\"torso_2\":'..plySkin["torso_2"]..',\"shoes_1\":'..plySkin["shoes_1"]..',\"shoes_2\":'..plySkin["shoes_2"]..',\"pants_1\":'..plySkin["pants_1"]..',\"pants_2\":'..plySkin["pants_2"]..',\"arms\":'..plySkin["arms"]..'}'
    log(clothes)
    if args[1] then
        TriggerServerEvent("guille_jobs:server:addOutfit", args[1], clothes)
        ESX.ShowNotification('You have added an outfit')
    else 
        ESX.ShowNotification('Give the outfit a name')
    end
end, false)

openCustomClothesMenu = function()
    ESX.TriggerServerCallback('guille_jobs:getCustomOutfits', function(result)
        local elements = {}
        for i = 1, #result, 1 do
            table.insert(elements, {label = result[i]['label'], value = result[i]['skin']})
        end
        ESX.UI.Menu.Open('default',GetCurrentResourceName(),"custom_menu",
        { 
        title = "Custom clothes menu", 
        align = "bottom-right", 
        elements = elements 
        }, function(data, menu)
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, data.current.value)
            end)
        end, function(data, menu) 
        menu.close() 
        end)
    end)
end

RegisterCommand("menubug", function()
    ESX.UI.Menu.CloseAll()
    TriggerServerEvent("es_extended:updateJobs")
end,false)



RegisterCommand("addskin", function(source, args)
    local job = args[1]

    TriggerEvent('skinchanger:getSkin', function(skin) plySkin = skin; end)
	local clothes = '{\"tshirt_1\":'..plySkin["tshirt_1"]..',\"tshirt_2\":'..plySkin["tshirt_2"]..',\"torso_1\":'..plySkin["torso_1"]..',\"shoes_1\":'..plySkin["shoes_1"]..',\"shoes_2\":'..plySkin["shoes_2"]..',\"pants_1\":'..plySkin["pants_1"]..',\"pants_2\":'..plySkin["pants_2"]..',\"arms\":'..plySkin["arms"]..'}'
    log(clothes)
    if plySkin["sex"] == 0 then
        TriggerServerEvent("guille_jobs:server:pedClothes", 0, clothes)
    else
        TriggerServerEvent("guille_jobs:server:pedClothes", 1, clothes)
    end

end, false)

RegisterNetEvent('guille_gans:outfromv')
AddEventHandler('guille_gans:outfromv', function(target)
    local targetped = GetPlayerPed(target)
    local myped = PlayerPedId()
    ClearPedTasks(targetped)
    plyPos = GetEntityCoords(myped,  true)
    local xnew = plyPos.x+2
    local ynew = plyPos.y+2
    SetEntityCoords(myped, xnew, ynew, plyPos.z)
end)

OpenIdentityCardMenu = function(player)
	ESX.TriggerServerCallback('guille_jobs:getOtherPlayerData', function(data)
		local elements = {
			{label = ('name:' ..data.name)},
			{label = ('job' .. ('%s - %s'):format(data.job, data.grade) .. '')}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = ('Sex ' .. (data.sex))})
			table.insert(elements, {label = ('dob ' .. data.dob)})
			table.insert(elements, {label = ('Height' .. data.height)})
		end

		if data.drunk then
			table.insert(elements, {label = ('Bac' .. data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = ('license')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction2', {
			title    = ('citizen_interaction'),
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
				
			end, function(data, menu)
			menu.close()

		end)

	end, GetPlayerServerId(player))
end

OpenPutStocksMenu = function()

	ESX.TriggerServerCallback('guille_jobs:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Your inventory',
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			if data.current.type == 'item_weapon' then
				menu.close()
				TriggerServerEvent('guille_jobs:putStockItems', data.current.type, data.current.value, data.current.ammo)

				ESX.SetTimeout(300, function()
					OpenPutStocksMenu()
				end)
			else

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
					title = 'quantity'
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if count == nil then
						ESX.ShowNotification('Invalid amount, try again')
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('guille_jobs:putStockItems', data.current.type, data.current.value, count)
						Storage()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

OpenGetStockMenu = function()
    
	ESX.TriggerServerCallback('guille_jobs:getStockItems', function(items)
		local elements = {}
		for i=1, #items, 1 do
			table.insert(elements, {
				label = items[i].label .. ' x' .. items[i].count,
				type = 'item_standard',
				value = items[i].name,
				haveImage = true
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armario2_menu', {
			title    = '' .. PlayerData.job.name .. ' inventory',
			align    = 'top-right',
			elements = elements,
			enableImages = true
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sacar_items', {
				title = 'quantity'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('Invalid quantity')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('guille_jobs:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStockMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

Storage = function()
    ESX.TriggerServerCallback('guille_jobs:stockNoDupe', function(result)
        if result == false then
            TriggerServerEvent('guille_jobs:sendlog', 'stock')
            TriggerServerEvent("guille_jobs:server:openMenu")
            local elements = {}
            table.insert(elements, { label = "Poner items", value = "put" })
            table.insert(elements, { label = "Coger items", value = "get" })
            table.insert(elements, { label = "Armas", value = "weapons" })
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'get_missions', {
                title = ('' .. PlayerData.job.name .. ' actions'),
                align = 'top-right',
                elements = elements
            }, function(data, menu)
                local v = data.current.value
                if v == "put" then
                    OpenPutStocksMenu()
                elseif v == "get" then
                    OpenGetStockMenu()
                elseif v == "weapons" then
                    Weapons()
                end
            end, function(data, menu)
                menu.close()
                TriggerServerEvent("guille_jobs:server:menuClose")
            end)
        else
            ESX.ShowNotification('Someone is already using the stock menu')
        end
    end)
end


Weapons = function()
    TriggerServerEvent('guille_jobs:sendlog', 'weapons')
	ESX.TriggerServerCallback('guille_jobs:getWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
            table.insert(elements, {
                label = ESX.GetWeaponLabel(weapons[i].name),
                value = weapons[i].name,
                type = 'item_weapon',
                haveImage = true
            })
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = ('' .. PlayerData.job.name .. ' weapons'),
			align    = 'top-right',
			elements = elements,
			enableImages = true
		}, function(data, menu)
			menu.close()
			ESX.TriggerServerCallback('guille_jobs:removeweapon', function()
				Weapons()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

local isDragging = false

RegisterCommand('openmenugangs', function()
    local ped = PlayerPedId()

    local elements = {}
    if Config.enableDefaultSearch then
        table.insert(elements, { label = "Cachear", value = "search" })
    end
    if configs[1] ~= nil then
        if configs[1]['handcuff'] == 1 then
            table.insert(elements, { label = "Search", value = "handcuff" })
            table.insert(elements, { label = "Handcuff/Unhandcuff", value = "unarrest" })
            table.insert(elements, { label = "Add in vehicle", value = "vehiclein" })
            table.insert(elements, { label = "Out from vehicle", value = "vehicleout" })
            table.insert(elements, { label = "Escort", value = "escort" })
        end
        if configs[1]['idman'] == 1 then
            table.insert(elements, { label = "See licenses", value = "licenses" })
        end
        if configs[1]['alerts'] == 1 then
            table.insert(elements, { label = "Alerts", value = "alerts" })
        end
        if configs[1]['vehman'] == 1 then
            table.insert(elements, { label = "Vehicle interaction", value = "vehman" })
        end
        if configs[1]['bill'] == 1 then
            table.insert(elements, { label = "Billing", value = "bill" })
        end
        if configs[1]['obj'] == 1 then
            table.insert(elements, { label = "Objects", value = "objects" })
        end
    end
    
    		
		
	    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'get_missions', {
	    title = ('' .. PlayerData.job.name .. ' actions'),
	    align = 'top-right',
	    elements = elements
	    }, function(data, menu)
	    local v = data.current.value
	    if v == 'handcuff' then
		local player, distance = ESX.Game.GetClosestPlayer()
		local playerheading = GetEntityHeading(ped)
		local playerlocation = GetEntityForwardVector(PlayerPedId())
		local playerCoords = GetEntityCoords(ped)
		if distance < 3 and distance ~= -1 then
		    TriggerServerEvent('guille_jobs:requestarrest', GetPlayerServerId(player), playerheading, playerCoords, playerlocation)
		end
	    elseif v == 'unarrest' then
		local player, distance = ESX.Game.GetClosestPlayer()
		local playerheading = GetEntityHeading(ped)
		local playerlocation = GetEntityForwardVector(PlayerPedId())
		local playerCoords = GetEntityCoords(ped)
		if distance < 3 and distance ~= -1 then
		TriggerServerEvent('guille_jobs:requestrelease', GetPlayerServerId(player), playerheading, playerCoords, playerlocation)
		else
		    ESX.ShowNotification('Not players near')
		end
	    elseif v == 'search' then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance < 3 and distance ~= -1 then
		    OpenBodySearchMenu(player)
		else
		    ESX.ShowNotification('Not players near')
		end
	    elseif v == "objects" then
		objects()
	    elseif v == "vehiclein" then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance < 3 and distance ~= -1 then
		    ClearPedTasks(PlayerPedId())
		    TriggerServerEvent('guille_jobs:putinvehicle', GetPlayerServerId(player))
		end
	    elseif v == "vehicleout" then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance < 3 and distance ~= -1 then
		    TriggerServerEvent('guille_jobs:outfromveh', GetPlayerServerId(player))
		end
	    elseif v == "escort" then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance < 3 and distance ~= -1 then
		    TriggerServerEvent('guille_jobs:escort', GetPlayerServerId(player))
		    if not isDragging then
			ESX.Streaming.RequestAnimDict('switch@trevor@escorted_out', function()
			    TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
			end)
			isDragging = true
		    else
			Wait(500)
			ClearPedTasks(PlayerPedId())
			isDragging = false
		    end
		end
	    elseif v == "bill" then

		ESX.UI.Menu.Open("dialog",GetCurrentResourceName(),"billing",
		{
		    title = "Cantidad de la multa"
		}, function(data, menu)
		local amount = tonumber(data.value)
		if amount == nil then
		    ESX.ShowNotification("Cantidad inválida")
		else
		    menu.close()
		    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		    if closestPlayer == -1 or closestDistance > 3.0 then
			ESX.ShowNotification("Not players near")
		    else
			TriggerServerEvent("esx_billing:sendBill", GetPlayerServerId(closestPlayer), "society_" .. PlayerData.job.name, PlayerData.job.name, amount)
			ESX.ShowNotification("Bill sent")
		    end
		end
		end, function(data, menu)
		    menu.close()
		end)
	    elseif v == "licenses" then
		local player, distance = ESX.Game.GetClosestPlayer()
		if distance < 3 and distance ~= -1 then
		    IdentitySee(GetPlayerServerId(player))
		end
	    elseif v == "vehman" then
		local vehicle = ESX.Game.GetVehicleInDirection()
		if DoesEntityExist(vehicle) then
		    openVehMenu(vehicle)
		else
		    ESX.ShowNotification('No vehicle near')
		end
	    end
	    end, function(data, menu)
	    menu.close()
	    end)
    
end, false)

local handcuff = false

function OpenAlertaMenu(source)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'first_menu',
	{
		title    = 'Cambiar estado de Alerta',
		align    = 'bottom-right',
		elements = {
			{label = "Alerta Azul",	value = 5},
			{label = "Alerta Verde",	value = 4},
			{label = "Alerta Amarilla",	value = 3},
			{label = "Alerta Roja",	value = 2},
			{label = "Alerta Negra",	value = 1},
			{label = "Ninguna",	value = 0},
		}
	}, function(data, menu)
		TriggerServerEvent('chat:alerta', data.current.value, true)
	end,
	function(data, menu)
		menu.close()
	end)
end

local objectsSpawned = {}

objects = function()
    
    ESX.UI.Menu.Open('default',GetCurrentResourceName(),"obj_menu",
    { 
    title    = 'Colocar objetos',
    align    = 'top-left',
    elements = { -- esx_policejob https://github.com/esx-framework/esx_policejob/blob/master/client/main.lua
        {label = ('Cono'), model = 'prop_roadcone02a'},
        {label = ('Barrera'), model = 'prop_barrier_work05'},
        {label = ('Barrera naranja'), model = 'prop_mp_barrier_02b'},
        {label = ('Barrera flecha derecha'), model = 'prop_mp_arrow_barrier_01'},
        {label = ('Barrera pequeña'), model = 'prop_barrier_work01a'},
        {label = ('Cono luces'), model = 'prop_air_conelight'},
        {label = ('Cono simple'), model = 'prop_roadcone02c'},
        {label = ('Pinchos'), model = 'p_ld_stinger_s'},
    }
    }, function(data, menu)
        ESX.Game.SpawnObject(data.current.model, GetEntityCoords(PlayerPedId()), function(object)
            SetEntityHeading(object, GetEntityHeading(PlayerPedId()))
            PlaceObjectOnGroundProperly(object)
            FreezeEntityPosition(object, true)
        end) 
    end, function(data, menu) 
    menu.close() 
    end)
end

Citizen.CreateThread(function()
    local objects = {
        'prop_roadcone02a',
        'prop_barrier_work05',
        'prop_mp_barrier_02b',
        'prop_mp_arrow_barrier_01',
        'prop_barrier_work01a',
        'prop_air_conelight',
        'prop_roadcone02c',
        'p_ld_stinger_s',
    }
    while true do
        local wait = 2000
        for k,v in pairs(objects) do
            local object = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 3.0, GetHashKey(v), false, false, false)
            local coords = GetEntityCoords(object)
            if DoesEntityExist(object) then
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) < 3 then
                    wait = 0
                    ESX.ShowFloatingHelpNotification("Presiona ~r~E~w~ para eliminar el objeto", coords + vector3(0, 0, 1))
                    if IsControlJustPressed(1, 38) then
                        DeleteObject(object)
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)

RegisterNetEvent('guille_jobs:getarrested')
AddEventHandler('guille_jobs:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z - 1)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)	
	handcuff = true
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('guille_jobs:doarrested')
AddEventHandler('guille_jobs:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end) 

openVehMenu = function(veh)
    local elements = {}
    table.insert(elements, {label = "Vehicle info", value = 'vehinfo'})
    table.insert(elements, {label = "Rob", value = 'force'})
    table.insert(elements, {label = "Impound", value = 'impound'})
    if Config.vehManagementRepair then
        table.insert(elements, {label = "Repair", value = 'repair'})
    end
    if Config.vehManagementClean then
        table.insert(elements, {label = "Clean", value = 'clean'})
    end

    ESX.UI.Menu.Open('default',GetCurrentResourceName(), "veh_menu",
    { 
    title = "Menu de interacción vehicular", 
    align = "bottom-right", 
    elements = elements 
    }, function(data, menu)
        local v = data.current.value

        if v == "vehinfo" then
            local vehinf = ESX.Game.GetVehicleProperties(veh)
            seeVehInfo(vehinf)
        elseif v == "force" then
            robVeh(veh)
        elseif v == "impound" then
            impoundVeh(veh)
        elseif v == "repair" then
            repairVeh(veh)
        elseif v == "clean" then
            cleanVeh(veh)
        end

    end, function(data, menu) 
        menu.close() 
    end)
end

seeVehInfo = function(vehicleinfo)
    ESX.TriggerServerCallback('guille_jobs:getVehInfo', function(result)
        local elements = {{label = "Matrícula "..result.plate}}

        if result.owner == nil then
            table.insert(elements, {label = "Unknown owner"})
        else
            table.insert(elements, {label = "Property of: " ..result.owner})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
            title    = "Información del vehículo",
            align    = 'bottom-right',
            elements = elements
        }, nil, function(data, menu)
            menu.close()
        end)
    end, vehicleinfo.plate)
end

repairVeh = function(veh)
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING', 0, true)
    Citizen.Wait(10000)
    ESX.ShowNotification('The vehicle has been repaired')
    SetVehicleFixed(veh)
    ClearPedTasks(PlayerPedId())
end

robVeh = function(veh)
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING', 0, true)
    Citizen.Wait(10000)
    ClearPedTasks(PlayerPedId())

    SetVehicleDoorsLocked(veh, 1)
    SetVehicleDoorsLockedForAllPlayers(veh, false)
    ESX.ShowNotification("The vehicle has been unlocked")
end

cleanVeh = function(veh)
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_MAID_CLEAN', 0, true)
    Citizen.Wait(10000)
    SetVehicleDirtLevel(veh, 0)
    ClearPedTasks(PlayerPedId())
    ESX.ShowNotification("The vehicle has been cleaned")
end

local vehpos = nil

impoundVeh = function(veh)
    vehpos = GetEntityCoords(veh)
    TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    Citizen.Wait(5000)
    ESX.Game.DeleteVehicle(veh)
    ClearPedTasks(PlayerPedId())
    ESX.ShowNotification('The vehicle has been impound')
    vehpos = nil
end

RegisterNetEvent('guille_jobs:getuncuffed')
AddEventHandler('guille_jobs:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z - 1)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	handcuff = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('guille_jobs:douncuffing')
AddEventHandler('guille_jobs:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('guille_jobs:putInVehicle')
AddEventHandler('guille_jobs:putInVehicle', function()
	if handcuff then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if IsAnyVehicleNearPoint(coords, 5.0) then
			local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

			if DoesEntityExist(vehicle) then
				local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

				for i=maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end

				if freeSeat then
					TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
					dragStatus.isDragged = false
				end
			end
		end
	end
end)

RegisterNetEvent('guille_jobs:OutVehicle')
AddEventHandler('guille_jobs:OutVehicle', function()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 16)
	end
end)


function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

-- ESX POLICEJOB THREADS

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if handcuff == true then
			--DisableControlAction(0, 1, true) -- Disable pan
			--DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 21, true)
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, 32, true) -- W
			--DisableControlAction(0, 34, true) -- A
			--DisableControlAction(0, 31, true) -- S
			--DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			--DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(1500)
		end
	end
end)

local drag = false
local dragUser = nil

RegisterNetEvent('guille_jobs:drag')
AddEventHandler('guille_jobs:drag', function(playerWhoDrag)
	if handcuff then
        drag = not drag
        dragUser = playerWhoDrag
	end
end)

Citizen.CreateThread(function()
	local wasDragged

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if handcuff and drag then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragUser))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.10, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Citizen.Wait(1000)
				end
			else
				wasDragged = false
				drag = false
				DetachEntity(playerPed, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(playerPed, true, false)
		else
			Citizen.Wait(500)
		end
	end
end)

function IdentitySee(player)
	TriggerServerEvent('jsfour-idcard:open', player, GetPlayerServerId(PlayerId()))
end

function checkTable(table)
    local init = false
    for k,v in pairs(table) do
        inIt = true
    end
    if inIt then
        return true
    else
        return false
    end
end


