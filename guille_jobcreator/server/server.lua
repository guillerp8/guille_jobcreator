ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 


local database = false
local jobPoints = {}
local config = {}
local models = {}
local blips = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM jobconfigs", {
    }, function(result)
        for i = 1,#result, 1 do
            print("^3[^2guille_jobs^3]^0 Job Active: ^2 society_"..result[i]['job'] .. "^0 Job name: ^2" ..result[i]['job'].. "^0" )
            TriggerEvent('esx_society:registerSociety', result[i]['job'], result[i]['job'], "society_"..result[i]['job'],  "society_"..result[i]['job'],  "society_"..result[i]['job'], {type = 'public'})
            TriggerEvent('esx_phone:registerNumber', result[i]['job'], 'Número de '..result[i]['job'], true, true)
        end
        TriggerEvent("guille_jobs:server:refreshCars")
        TriggerEvent("guille_jobs:server:updatePoints")
        TriggerEvent("guille_jobs:server:refreshBlips")
        TriggerEvent("guille_jobs:server:refreshItems")
        TriggerEvent("guille_jobs:server:refreshConfigs")
        TriggerEvent("guille_jobs:server:getOutfits")
        SetConvarServerInfo("guille_jobcreator [by guillerp#1928]", Config.scriptVersion)
    end)
end)




RegisterServerEvent("guille_jobs:server:addJob")
AddEventHandler("guille_jobs:server:addJob", function(job, joblabel)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        MySQL.Async.execute('INSERT INTO jobs (name, label, whitelisted) VALUES (@name, @label, @whitelisted)', {
            ['@name'] = job,
            ['@label'] = joblabel, 
            ['@whitelisted'] = 1,
        })
        MySQL.Async.execute('INSERT INTO jobs (name, label, whitelisted) VALUES (@name, @label, @whitelisted)', {
            ['@name'] = "off"..job,
            ['@label'] = joblabel, 
            ['@whitelisted'] = 1,
        })
        MySQL.Async.execute('INSERT INTO addon_account (name, label, shared) VALUES (@name, @label, @shared)', {
            ['@name'] = "society_"..job,
            ['@label'] = joblabel, 
            ['@shared'] = 1,
        })
        MySQL.Async.execute('INSERT INTO addon_inventory (name, label, shared) VALUES (@name, @label, @shared)', {
            ['@name'] = "society_"..job,
            ['@label'] = joblabel, 
            ['@shared'] = 1,
        })
        MySQL.Async.execute('INSERT INTO datastore (name, label, shared) VALUES (@name, @label, @shared)', {
            ['@name'] = "society_"..job,
            ['@label'] = joblabel, 
            ['@shared'] = 1,
        })
    else
        print("^3[^2guille_jobs^3]^0 Alguien ha intentado crear un job sin permisos")
        DropPlayer(xPlayer.source, "[guille_jobs]^0 Crear job sin permiso. ¿Cheater?")
    end

end)

RegisterServerEvent("guille_jobs:server:addGrade")
AddEventHandler("guille_jobs:server:addGrade", function(job, num, grade, label, money)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
            ['@job_name'] = job,
            ['@grade'] = num, 
            ['@name'] = grade,
            ['@label'] = label,
            ['@salary'] = money,
            ['@skin_male'] = '{}',
            ['@skin_female'] = '{}',
        })
        MySQL.Async.execute('INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (@job_name, @grade, @name, @label, @salary, @skin_male, @skin_female)', {
            ['@job_name'] = "off"..job,
            ['@grade'] = num, 
            ['@name'] = grade,
            ['@label'] = "off"..label,
            ['@salary'] = 0,
            ['@skin_male'] = '{}',
            ['@skin_female'] = '{}',
        })
    else
        print("^3[^2guille_jobs^3]^0 Alguien ha intentado crear un job sin permisos")
        DropPlayer(xPlayer.source, "[guille_jobs]^0 Crear job sin permiso. ¿Cheater?")
    end

end)

RegisterServerEvent("guille_jobs:server:addPoints")
AddEventHandler("guille_jobs:server:addPoints", function(job, boss, shop, duty, garagein, garageout, cloackroom, stock, heading)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(job)
    print(shop)
    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode(job),
            ['@name'] = "garagein", 
            ['@coords'] = json.encode(garagein),
        })
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode(job),
            ['@name'] = "garageout", 
            ['@coords'] = json.encode(garageout),
        })
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode(job),
            ['@name'] = "shop", 
            ['@coords'] = json.encode(shop),
        })
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode(job),
            ['@name'] = "boss", 
            ['@coords'] = json.encode(boss),
        })
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode(job),
            ['@name'] = "duty", 
            ['@coords'] = json.encode(duty),
        })
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode("off"..job),
            ['@name'] = "duty", 
            ['@coords'] = json.encode(duty),
        })
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode(job),
            ['@name'] = "cloackroom", 
            ['@coords'] = json.encode(cloackroom),
        })
        MySQL.Async.execute('INSERT INTO jobpoints (job, name, coords) VALUES (@job, @name, @coords)', {
            ['@job'] = json.encode(job),
            ['@name'] = "stock", 
            ['@coords'] = json.encode(stock),
        })
        print("^3[^2guille_jobs^3]^0 Refreshing es_extended jobs")
        TriggerEvent("es_extended:updateJobs")
        Wait(500)
        print("^3[^2guille_jobs^3]^0 Refreshing esx_society jobs")
        TriggerEvent("esx_society:refreshJobs")
        Wait(500)
        print("^3[^2guille_jobs^3]^0 Refreshing addon_account")
        TriggerEvent("esx_adddonaccount:refreshAccount")
        Wait(500)
        print("^3[^2guille_jobs^3]^0 Refreshing addon_inventory")
        TriggerEvent("esx_adddoninventory:refreshInventory")
        Wait(500)
        print("^3[^2guille_jobs^3]^0 Refreshing datastore")
        TriggerEvent("esx_datastore:refreshDatastore")
        Wait(500)
        print("^3[^2guille_jobs^3]^0 Refreshing blips")
        TriggerEvent("guille_jobs:server:refreshBlips")
        Wait(500)
        print("^3[^2guille_jobs^3]^0 Refreshing points")
        TriggerEvent("guille_jobs:server:updatePoints")
        Wait(500)
        print("^3[^2guille_jobs^3]^0 Sync with clients")
        TriggerClientEvent("guille_jobs:client:syncJobs", -1)
        xPlayer.showNotification('El job ' ..job.. ' se ha creado correctamente')
    else
        print("^3[^2guille_jobs^3]^0 Alguien ha intentado crear puntos de un job sin permisos")
        DropPlayer(xPlayer.source, "[guille_jobs]^0 Crear puntos sin permiso. ¿Cheater?")
    end

end)

RegisterNetEvent("guille_jobs:server:duty")
AddEventHandler("guille_jobs:server:duty", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    if string.match(job, "off") then
        local injob = job:gsub('off', '')
        xPlayer.setJob(injob, grade)
    else
        local offjob = "off"..job
        xPlayer.setJob(offjob, grade)
    end

end)

RegisterServerEvent("guille_jobs:server:addConfigs")
AddEventHandler("guille_jobs:server:addConfigs", function(job, search, handcuff, vehinfo, identity, obj, alerts, bill, shop)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        MySQL.Async.execute('INSERT INTO jobconfigs (job, shop, car1, car2, idman, vehmanagement, alerts, handcuff, bill, obj) VALUES (@job, @shop, @car1, @car2, @idman, @vehmanagement, @alerts, @handcuff, @bill, @obj)', {
            ['@job'] = job,
            ['@shop'] = shop, 
            ['@car1'] = "zentorno",
            ['@car2'] = "zentorno",
            ['@idman'] = identity,
            ['@vehmanagement'] = vehinfo,
            ['@alerts'] = alerts,
            ['@handcuff'] = handcuff,
            ['@bill'] = bill,
            ['@obj'] = obj,
        })
        Wait(5000)
        TriggerEvent("guille_jobs:server:refreshConfigs")
        TriggerClientEvent("guille_jobs:client:addPoints", xPlayer.source, job)
    else
        print("^3[^2guille_jobs^3]^0 Alguien ha intentado crear configs de un job sin permisos")
        DropPlayer(xPlayer.source, "[guille_jobs]^0 Crear configs sin permiso. ¿Cheater?")
    end
end)


RegisterServerEvent("guille_jobs:server:refreshConfigs")
AddEventHandler("guille_jobs:server:refreshConfigs", function()
    MySQL.Async.fetchAll("SELECT * FROM jobconfigs", {}, function(result)
        config = {}
        for i = 1,#result, 1 do
            
            table.insert(config, {job = result[i]['job'], idman = result[i]['idman'], vehman = result[i]['vehmanagement'], alerts = result[i]['alerts'], handcuff = result[i]['handcuff'], bill = result[i]['bill'], obj = result[i]['obj']})
        end
        print()
    end)
end)

ESX.RegisterServerCallback('guille_jobs:getConfigJob', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    while xPlayer == nil do 
        xPlayer = ESX.GetPlayerFromId(source) 
        Wait(500) 
    end
    local jobConfigs = {}
    for i = 1, #config, 1 do
        if xPlayer.job.name == config[i]['job'] then
            table.insert(jobConfigs, {job = config[i]['job'], idman = config[i]['idman'], vehman = config[i]['vehman'], alerts = config[i]['alerts'], handcuff = config[i]['handcuff'], bill = config[i]['bill'], obj = config[i]['obj']})
        end
    end
    cb(jobConfigs)
end)    

RegisterCommand("createjob", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        TriggerClientEvent("guille_jobcreator:client:startCreation", xPlayer.source)
    else
        print("Un jugador ha intentado crear un job sin ser admin")
    end
end, false)

RegisterCommand("deletejob", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = args[1]
    local init = false
    for k,v in pairs(jobPoints) do
        inIt = true
    end
    if not inIt then
        xPlayer.showNotification('No hay jobs creados con ' ..GetCurrentResourceName())
    end
    for k,v in pairs(jobPoints) do
        local value = #jobPoints - 0
        if job == jobPoints[k]['job'] then
            if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
                xPlayer.showNotification('Started delete job process ' ..job.. ' created with ' ..GetCurrentResourceName())
                MySQL.Async.execute('DELETE FROM jobpoints WHERE job=@job', {
                    ['@job'] = json.encode(job),
                })
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobpoints WHERE job=@job', {
                    ['@job'] = json.encode("off"..job),
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobpoints")
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobblips WHERE job=@job', {
                    ['@job'] = job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobblips")
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobconfigs WHERE job=@job', {
                    ['@job'] = job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobconfigs")
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobs WHERE name=@name', {
                    ['@name'] = "off"..job,
                })
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobs WHERE name=@name', {
                    ['@name'] = job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobs")
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobitems WHERE job=@job', {
                    ['@job'] = job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobshops")
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobitems WHERE job=@job', {
                    ['@job'] = job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobgrades")
                Wait(500)
                MySQL.Async.execute('DELETE FROM job_grades WHERE job_name=@job_name', {
                    ['@job_name'] = "off"..job,
                })
                Wait(500)
                MySQL.Async.execute('DELETE FROM job_grades WHERE job_name=@job_name', {
                    ['@job_name'] = job,
                })
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Deleting from job_grades")
                Wait(500)
                MySQL.Async.execute('DELETE FROM addon_account WHERE name=@name ', {
                    ['@name'] = "society_"..job,
                })
                Wait(500)
                MySQL.Async.execute('DELETE FROM addon_account_data WHERE account_name=@account_name ', {
                    ['@account_name'] = "society_"..job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from addon_account")
                Wait(500)
                MySQL.Async.execute('DELETE FROM addon_inventory WHERE name=@name ', {
                    ['@name'] = "society_"..job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobclothes")
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobclothes WHERE job=@job ', {
                    ['@job'] = job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from jobvehicles")
                Wait(500)
                MySQL.Async.execute('DELETE FROM jobcars WHERE job=@job ', {
                    ['@job'] = job,
                })
                Wait(500)
                MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE inventory_name=@inventory_name ', {
                    ['@inventory_name'] = "society_"..job,
                })
                print("^3[^2guille_jobs^3]^0 Deleting from addon_inventory")
                Wait(500)
                MySQL.Async.execute('DELETE FROM datastore WHERE name=@name ', {
                    ['@name'] = "society_"..job,
                })
                Wait(500)
                MySQL.Async.execute('DELETE FROM datastore_data WHERE name=@name ', {
                    ['@name'] = "society_"..job,
                })
        
                print("^3[^2guille_jobs^3]^0 Deleting from datastore")
                Wait(500)
                xPlayer.showNotification('El job ~r~'..job..'~w~ ha sido borrado')
                print("^3[^2guille_jobs^3]^0 Finished deleting from database | Starting sync with players")
                local xPlayers = ESX.GetPlayers() 
                for i=1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    if xPlayer.job.name == job then
                        xPlayer.setJob('unemployed', 0)
                        xPlayer.showNotification('Ypur job ' ..job.. ' has been deleted, now you are unemployed')
                        print("^3[^2guille_jobs^3]^0 Player with id " ..xPlayers[i].. " changed job to unemployed due his job named "..job.." was deleted")
                    end
                end
                print("^3[^2guille_jobs^3]^0 Refreshing es_extended jobs")
                TriggerEvent("es_extended:updateJobs")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing items from shops")
                TriggerEvent("guille_jobs:server:refreshItems")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing esx_society jobs")
                TriggerEvent("esx_society:refreshJobs")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing addon_account")
                TriggerEvent("esx_adddonaccount:refreshAccount")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing cars")
                TriggerEvent("guille_jobs:server:refreshCars")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing clothes")
                TriggerEvent("guille_jobs:server:getOutfits")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing points")
                TriggerEvent("guille_jobs:server:updatePoints")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing addon_inventory")
                TriggerEvent("esx_adddoninventory:refreshInventory")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing blips")
                TriggerEvent("guille_jobs:server:refreshBlips")
                Wait(500)
                print("^3[^2guille_jobs^3]^0 Refreshing datastore")
                TriggerEvent("esx_datastore:refreshDatastore")
                Wait(500)
                TriggerClientEvent("guille_jobs:client:syncJobs", -1)
                print("^3[^2guille_jobs^3]^0 Job full deleted and sync with all players done!")
            else
                print("^3[^2guille_jobs^3]^0 Un jugador ha borrar crear un job sin ser admin")
            end
            break
        end
        if k == value then
            xPlayer.showNotification('No existen jobs con el nombre ' ..job.. ' creados con ' ..GetCurrentResourceName())
        end
    end
    
    
end, false)

RegisterServerEvent("guille_jobs:server:addCar")
AddEventHandler("guille_jobs:server:addCar", function(car)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        MySQL.Async.execute('INSERT INTO jobcars (model, job) VALUES (@model, @job)', {
            ['@model'] = car,
            ['@job'] = xPlayer.job.name, 
        })
        Wait(5000)
        xPlayer.showNotification('You added the car '..car..' to the job '..xPlayer.job.name)
        TriggerEvent("guille_jobs:server:refreshCars")
    else
        xPlayer.showNotification('No perms')
    end
end)

RegisterServerEvent("guille_jobs:server:addItem")
AddEventHandler("guille_jobs:server:addItem", function(type, item, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        if item or ESX.GetWeapon(item) then
            MySQL.Async.execute("INSERT INTO jobitems (itemType, name, job, price) VALUES (@itemType, @name, @job, @price)", {
                ['@itemType'] = type,
                ['@name'] = item,
                ['@job'] = xPlayer.job.name,
                ['@price'] = price,
            })
            Wait(5000)
            xPlayer.showNotification('You added the item ' ..item.. ' with price ' ..price.. ' an type ' ..type)
            TriggerEvent("guille_jobs:server:refreshItems")
        else
            xPlayer.showNotification('El item puesto no existe')
        end
    else
        ESX.ShowNotification('?')
    end
end)



RegisterServerEvent("guille_jobs:server:refreshCars")
AddEventHandler("guille_jobs:server:refreshCars", function()
    models = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM jobcars', {
    }, function(result)
        if result ~= nil then
            for i = 1, #result, 1 do
                table.insert(models, {model = result[i]['model'], job = result[i]['job']})
            end
            print("^3[^2guille_jobs^3]^0 Refreshing cars of jobs")
        else
            print("^3[^2guille_jobs^3]^0 No hay coches añadidos para el job " ..xPlayer.job.name)
        end
    end)
end)

RegisterServerEvent("guille_jobs:server:addBlip")
AddEventHandler("guille_jobs:server:addBlip", function(job, text, sprite, color)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('INSERT INTO jobblips (text, coords, sprite, color, job) VALUES (@text, @coords, @sprite, @color, @job)', {
        ['@text'] = text,
        ['@coords'] = json.encode(xPlayer.getCoords()),
        ['@sprite'] = sprite,
        ['@color'] = color,
        ['@job'] = job,
    })

end)



RegisterServerEvent("guille_jobs:server:refreshBlips")
AddEventHandler("guille_jobs:server:refreshBlips", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    blips = {}
    MySQL.Async.fetchAll('SELECT * FROM jobblips', {
    }, function(result)
        if result ~= nil then
            for i = 1, #result, 1 do
                table.insert(blips, {text = result[i]['text'], coords = json.decode(result[i]['coords']), sprite = result[i]['sprite'], color = result[i]['color'], job = result[i]['job']})
            end
            print("^3[^2guille_jobs^3]^0 Refreshing blips of jobs")
        else
            print("^3[^2guille_jobs^3]^0 No hay coches añadidos para el job " ..xPlayer.job.name)
        end
    end)
end)



ESX.RegisterServerCallback('guille_jobs:getBlips', function(source,cb)
    local jobBlips = {}
    for i = 1, #blips, 1 do
        table.insert(jobBlips, {text = blips[i]['text'], coords = blips[i]['coords'], sprite = blips[i]['sprite'], color = blips[i]['color'], job = blips[i]['job']})
    end
    cb(jobBlips)
end)

local items = {}

RegisterServerEvent("guille_jobs:server:refreshItems")
AddEventHandler("guille_jobs:server:refreshItems", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    items = {}
    MySQL.Async.fetchAll('SELECT * FROM jobitems', {
    }, function(result)
        if result ~= nil then
            for i = 1, #result, 1 do
                table.insert(items, {name = result[i]['name'], type = result[i]['itemType'], job = result[i]['job'], price = result[i]['price']})
            end
            print("^3[^2guille_jobs^3]^0 Refreshing items of the shop of the jobs")
        else
            print("^3[^2guille_jobs^3]^0 No hay items en la tienda añadidos para el job " ..xPlayer.job.name)
        end
    end)
end)

ESX.RegisterServerCallback('guille_jobs:getItemsOrWeapons', function(source, cb)
    local itemstocb = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    for i = 1, #items, 1 do
        if items[i]['job'] == xPlayer.job.name then
            if items[i]['type'] == "weapon" then
                table.insert(itemstocb, {name = items[i]['name'], label = ESX.GetWeaponLabel(items[i]['name']), type = items[i]['type'], job = items[i]['job'], price = items[i]['price']})
            else
                table.insert(itemstocb, {name = items[i]['name'], label = ESX.GetItemLabel(items[i]['name']), type = items[i]['type'], job = items[i]['job'], price = items[i]['price']})
            end
        end
    end
    cb(itemstocb)
end)

ESX.RegisterServerCallback('guille_jobs:getCars', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local cars = {}
    for i = 1, #models, 1 do
        if models[i]['job'] == xPlayer.job.name then
            table.insert(cars, {model = models[i]['model']})
        end
    end
    cb(cars)
end)

RegisterServerEvent("guille_jobs:server:addOutfit")
AddEventHandler("guille_jobs:server:addOutfit", function(name, skin)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "admin" then
        MySQL.Async.execute("INSERT INTO jobclothes (job, label, skin) VALUES (@job, @label, @skin)", {
            ['@skin'] = skin,
            ['@job'] = xPlayer.job.name,
            ['@label'] = name,
        })
        Wait(5000)
        TriggerEvent("guille_jobs:server:getOutfits")
        xPlayer.showNotification('You added a custom outfit')
    end
end)

local customClothes = {}

RegisterServerEvent("guille_jobs:server:getOutfits")
AddEventHandler("guille_jobs:server:getOutfits", function()
    print("^3[^2guille_jobs^3]^0 Refreshing outfits of the jobs")
    customClothes = {}
    MySQL.Async.fetchAll("SELECT * FROM jobclothes", {}, function(result)
        for i = 1, #result, 1 do
            table.insert(customClothes, {label = result[i]['label'], skin = json.decode(result[i]['skin']), job = result[i]['job']})
        end
    end)
end)

ESX.RegisterServerCallback('guille_jobs:getCustomOutfits', function(source,cb)
    local clothes = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    for i = 1, #customClothes, 1 do
        if customClothes[i]['job'] == xPlayer.job.name then
            table.insert(clothes, {label = customClothes[i]['label'], skin = customClothes[i]['skin']})
        end
    end
    cb(clothes)
end)

RegisterServerEvent("guille_jobs:server:pedClothes")
AddEventHandler("guille_jobs:server:pedClothes", function(gender, clothes)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "superadmin" then
        if gender == 0 then
            MySQL.Async.execute("UPDATE job_grades SET skin_male = @skin WHERE job_name = @job_name AND grade = @grade", {
                ['@skin'] = clothes,
                ['@job_name'] = xPlayer.job.name,
                ['@grade'] = xPlayer.job.grade,
            })
        else
            MySQL.Async.execute("UPDATE job_grades SET skin_female = @skin WHERE job_name = @job_name AND grade = @grade", {
                ['@skin'] = clothes,
                ['@job_name'] = xPlayer.job.name,
                ['@grade'] = xPlayer.job.grade,
            })
        end
        TriggerEvent("reloadskin")
    end

end)

RegisterServerEvent("guille_jobs:server:buyItem")
AddEventHandler("guille_jobs:server:buyItem", function(name, type, price)

    local xPlayer = ESX.GetPlayerFromId(source)
    local price = tonumber(price)
    if type == "weapon" then
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            xPlayer.addWeapon(name, 100)
            
            xPlayer.showNotification('You bought a ' ..ESX.GetWeaponLabel(name).. ' for ' ..price.. ' $')
        else
            xPlayer.showNotification('No ~r~money')
        end
    elseif type == "item" then
        if xPlayer.getMoney() >= price then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(name, 1)
            
            xPlayer.showNotification('You bougth a ' ..ESX.GetItemLabel(name).. ' for ' ..price.. ' $')
        else
            xPlayer.showNotification('No ~r~money')
        end
    end

end)





RegisterServerEvent("guille_jobs:server:updatePoints")
AddEventHandler("guille_jobs:server:updatePoints", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    jobPoints = {}
    if source == "" then
        MySQL.Async.fetchAll("SELECT * FROM jobpoints", {
        }, function(result)
            for i = 1,#result, 1 do
                if result[i]['name'] == "garagein" then
                    local decode = json.decode(result[i]['coords'])
                    table.insert(jobPoints, {job = json.decode(result[i]['job']), coords = decode['coordssave'], name = result[i]['name'], heading = decode['heading']})
                else
                    table.insert(jobPoints, {job = json.decode(result[i]['job']), coords = json.decode(result[i]['coords']), name = result[i]['name']})
                end
            end
        end)
    else
        print("^3[^2guille_jobs^3]^0 Hey! Te estan intentando reventar la base de datos")
    end

end)    

ESX.RegisterServerCallback('guille_jobs:getPoints', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    while xPlayer == nil do 
        xPlayer = ESX.GetPlayerFromId(source) 
        Wait(500) 
    end
    local points = {}
    for i = 1, #jobPoints, 1 do
        if jobPoints[i]['job'] == xPlayer.job.name then
            table.insert(points, {job = jobPoints[i]['job'], coords = jobPoints[i]['coords'], name = jobPoints[i]['name'], heading = jobPoints[i]['heading']})
        end
    end
    cb(points)

end)    

function CheckGangs(xPlayer) 
    for _,v in pairs(Config.Gangs) do
        if xPlayer.job.name == v.Job then
            return true
        else
            return false
        end
    end
end

function sendToDiscord(webhook, name, message, color)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "guillerp scripts",
                ["icon_url"] = "https://i.ibb.co/GdpN9Zh/Wack.png",
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "guillerp", embeds = connect, avatar_url = "https://i.ibb.co/GdpN9Zh/Wack.png"}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('guille_jobs:sendlog')
AddEventHandler('guille_jobs:sendlog', function(type, var, var2)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier(source)
    local name = GetPlayerName(source)
    local gang = xPlayer.job.name

    if type == 'cardel' then
        sendToDiscord(Configw.Webhook, "Car delete", "**User: **"..name.."\n"..identifier.. "\n**Car:** ".. var .. "\n**Gang: **" .. gang .. "", 65280)
    elseif type == 'society' then
        sendToDiscord(Configw.Webhook, "Society menu opened", "**User: **"..name.."\n"..identifier.. "\n**Gang:** ".. var .. "", 65280)
    elseif type == 'carspawn' then
        sendToDiscord(Configw.Webhook, "Car spawned", "**User: **"..name.."\n"..identifier.. "\n**Car:** ".. var .. "\n**Gang: **" .. gang .. "", 65280)
    elseif type == 'gangmsg' then
        sendToDiscord(Configw.Webhook, "Message to a gang", "**User: **"..name.."\n"..identifier.. "\n**Gang: ** ".. var .. "\n**Message: **" .. var2 .. "", 65280)
    elseif type == 'stock' then
        sendToDiscord(Configw.Webhook, "Stock menu", "**User: **"..name.."\n"..identifier.. "\n**Gang: ** ".. gang .. "\n**Stock menu opened**", 65280)
    elseif type == 'weapons' then
        sendToDiscord(Configw.Webhook, "Stock menu", "**User: **"..name.."\n"..identifier.. "\n**Gang: ** ".. gang .. "\n**Weapons menu opened**", 65280)
    end
end)


ESX.RegisterServerCallback('guille_jobs:getPlayerInventory', function(source, cb)
	xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory


	cb({items = items, weapons = xPlayer.getLoadout()})
end)

ESX.RegisterServerCallback('guille_jobs:getStockItems', function(source, cb)
    xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. gang, function(inventory)
        cb(inventory.items)
	end)
end)

local stockOpened = {}

ESX.RegisterServerCallback('guille_jobs:stockNoDupe', function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    if stockOpened[job] then
        cb(true)
    else
        cb(false)
    end
end)


RegisterServerEvent("guille_jobs:server:openMenu")
AddEventHandler("guille_jobs:server:openMenu", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    stockOpened[job] = true
end)

RegisterServerEvent("guille_jobs:server:menuClose")
AddEventHandler("guille_jobs:server:menuClose", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    stockOpened[job] = false
end)

local searchOpened = {}

RegisterServerEvent("guille_jobs:server:addPlayer")
AddEventHandler("guille_jobs:server:addPlayer", function(player)
    searchOpened[player] = true
end)

RegisterServerEvent("guille_jobs:server:closePlayer")
AddEventHandler("guille_jobs:server:closePlayer", function(player)
    searchOpened[player] = false
end)

ESX.RegisterServerCallback('guille_jobs:checkDupe', function(source,cb,player) 
    if searchOpened[player] then
        cb(false)
    else
        cb(true)
    end
end)

ESX.RegisterServerCallback('guille_jobs:getWeapons', function(source, cb)
    xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'.. gang .. '', function(store)
		local weapons = store.get('weapons')
		if weapons == nil then
			weapons = {}
		end
		cb(weapons)
	end)
end)

RegisterServerEvent('guille_jobs:putStockItems')
AddEventHandler('guille_jobs:putStockItems', function(type, itemName, count)
	local xPlayer = nil
	while xPlayer == nil do
		xPlayer = ESX.GetPlayerFromId(source)
		Wait(10)
	end
    local gang = xPlayer.job.name

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'.. gang ..'', function(inventory)
			local item = inventory.getItem(itemName)
			local playerItemCount = xPlayer.getInventoryItem(itemName).count

			if item.count >= 0 and count <= playerItemCount then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
			else
				xPlayer.showNotification('Invalid quantity')
			end

			xPlayer.showNotification(('Item added: ' .. count .. ' - ' ..item.label.. ''))
		end)

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(itemName).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(itemName, count)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. gang ..'', function(account)
			end)
		else
			xPlayer.showNotification('Invalid quantity')
		end

	elseif type == 'item_weapon' then

		TriggerEvent('esx_datastore:getSharedDataStore', 'society_'.. gang ..'', function(store)
			local storeWeapons = store.get('weapons') or {}

			table.insert(storeWeapons, {
				name = itemName,
				ammo = count
			})

			store.set('weapons', storeWeapons)
			xPlayer.removeWeapon(itemName)
		end)
    end

end)

ESX.RegisterServerCallback('guille_jobs:getVehInfo', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		local vehInfo = {
			plate = plate
		}
		if result[1] then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(inforesult)

				if Config.EnableESXIdentity then
					vehInfo.owner = inforesult[1].firstname .. ' ' .. inforesult[1].lastname
				else
					vehInfo.owner = inforesult[1].name
				end

				cb(vehInfo)
			end)
		else
			cb(vehInfo)
		end
	end)
end)

RegisterNetEvent('guille_jobs:getStockItem')
AddEventHandler('guille_jobs:getStockItem', function(itemName, count)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. gang .. '', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then

			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification('Withdrawn item: ' .. count .. ' ' ..inventoryItem.label.. '')
			else
				xPlayer.showNotification('Invalid quantity')
			end
		else
			xPlayer.showNotification('Invalid quantity')
		end
	end)
end)


ESX.RegisterServerCallback('guille_jobs:removeweapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local gang = xPlayer.job.name
    TriggerEvent('esx_datastore:getSharedDataStore', 'society_'.. gang .. '', function(store)
        local storeWeapons = store.get('weapons') or {}
        local ammo = nil
        for i=1, #storeWeapons, 1 do
            
            if storeWeapons[i].name == weaponName  then
                weaponName = storeWeapons[i].name
                ammo       = storeWeapons[i].ammo
                table.remove(storeWeapons, i)
                break
            end
        end

        store.set('weapons', storeWeapons)
        xPlayer.addWeapon('' .. weaponName .. '', ammo)
    end)
end)

ESX.RegisterServerCallback('guille_jobs:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}
        data.dob = xPlayer.get('dateofbirth')
        data.height = xPlayer.get('height')

        if xPlayer.get('sex') == 'm' then data.sex = 'male' else data.sex = 'female' end

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end

            TriggerEvent('esx_license:getLicenses', target, function(licenses)
                data.licenses = licenses
                cb(data)
            end)
		end)
	end
end)

RegisterNetEvent('guille_jobs:server:confiscatePlayerItem')
AddEventHandler('guille_jobs:server:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count <= amount then
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)
				sourceXPlayer.showNotification("You robbed x" ..amount.. " of " ..sourceItem.label .. " - " ..sourceXPlayer.name)
				targetXPlayer.showNotification("You have been robbed x" ..amount.. " of " ..sourceItem.label .. " - " ..sourceXPlayer.name)
			else
				sourceXPlayer.showNotification("No puedes llevar más unidades de este item")
			end
		else
			sourceXPlayer.showNotification("Invalid quantity")
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney(itemName, amount)

		sourceXPlayer.showNotification("You robbed " .. amount .. " of " .. itemName .. " to " ..targetXPlayer.name)
		targetXPlayer.showNotification("You have been robbed " .. amount .. " of " .. itemName .. " to " ..targetXPlayer.name)

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon(itemName, amount)

		sourceXPlayer.showNotification("You robbed the weapon " .. ESX.GetWeaponLabel(itemName) .. " - " .. targetXPlayer.name.. " in quantity of x" ..amount)
		targetXPlayer.showNotification("You have been robbed the weapon " .. ESX.GetWeaponLabel(itemName) .. " - " .. targetXPlayer.name.. " in quantity of x" ..amount)
	end
end)

RegisterServerEvent('guille_jobs:handcuff')
AddEventHandler('guille_jobs:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    if target == 0 then
        xPlayer.showNotification('Not players near')
	else
        TriggerClientEvent('esx_policejob:handcuff', target)
    end
end)

RegisterServerEvent('guille_jobs:outfromveh')
AddEventHandler('guille_jobs:outfromveh', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if target == 0 then
        xPlayer.showNotification('Not players near')
    else
        TriggerClientEvent('guille_jobs:OutVehicle', target)
    end
end)


RegisterServerEvent('guille_jobs:putinvehicle')
AddEventHandler('guille_jobs:putinvehicle', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if target == 0 then
        xPlayer.showNotification('Not players near')
    else
        TriggerClientEvent('guille_jobs:putInVehicle', target)
    end
end)


RegisterServerEvent('guille_jobs:escort')
AddEventHandler('guille_jobs:escort', function(target)
    TriggerClientEvent('guille_jobs:drag', target, source)
end)


RegisterServerEvent('guille_jobs:requestarrest')
AddEventHandler('guille_jobs:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    TriggerClientEvent('guille_jobs:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('guille_jobs:doarrested', source)
end)

RegisterServerEvent('guille_jobs:requestrelease')
AddEventHandler('guille_jobs:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    TriggerClientEvent('guille_jobs:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('guille_jobs:douncuffing', source)
end)

local name = "[^4guille_jobcreator^7]"

AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		function checkVersion(error, latestVersion, headers)
			local currentVersion = Config.scriptVersion           
			if tonumber(currentVersion) < tonumber(latestVersion) then
				print(name .. " ^1is outdated.\nCurrent version: ^8" .. currentVersion .. "\nNewest version: ^2" .. latestVersion .. "\n^3Update^7: https://github.com/guillerp8/guille_jobcreator")
			elseif tonumber(currentVersion) > tonumber(latestVersion) then
				print(name .. " has skipped the latest version ^2" .. latestVersion .. ". Either Github is offline or the version file has been changed")
			else
				print(name .. " is updated.")
			end
		end
	
		PerformHttpRequest("https://raw.githubusercontent.com/guillerp8/jobcreatorversion/ma/version", checkVersion, "GET")
	end
end)

MySQL.ready(function()
    if GetCurrentResourceName() == resourceName then
		function checkVersion(error, latestVersion, headers)
			local currentVersion = Config.scriptVersion            
            
			if tonumber(currentVersion) < tonumber(latestVersion) then
				print(name .. " ^1is outdated.\nCurrent version: ^8" .. currentVersion .. "\nNewest version: ^2" .. latestVersion .. "\n^3Update^7: https://github.com/guillerp8/guille_jobcreator")
			elseif tonumber(currentVersion) > tonumber(latestVersion) then
				print(name .. " has skipped the latest version ^2" .. latestVersion .. ". Either Github is offline or the version file has been changed")
			else
				print(name .. " is updated.")
			end
		end
	
		PerformHttpRequest("https://raw.githubusercontent.com/guillerp8/jobcreatorversion/ma/version", checkVersion, "GET")
	end
end)

-- https://github.com/Project-Entity/pe-hud/blob/main/server/version_sv.lua
