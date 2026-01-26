-- Création d'un nouveau thread Citizen detection touche f5
Citizen.CreateThread(function()

    -- Boucle infinie
    while true do
  
        -- Attente de 1ms entre chaque itération de la boucle
        Citizen.Wait(1)
  
        -- Si le bouton 166 est pressé
        if IsControlJustPressed(1,167) then
            -- Appel de la fonction menu
            menu()
            
        end
  
    end
  
end)

function estDansLaListe(valeur, liste)
    for _, v in ipairs(liste) do
        if v == valeur then
            return true
        end
    end
    return false
end
vehicule_list = {"armytanker","armytrailer","armytrailer2","baletrailer","boattrailer","cablecar","docktrailer","freighttrailer","graintrailer","proptrailer","raketrailer","tr2","tr3","tr4","trflat","tvtrailer","tanker","tanker2","trailerlarge","trailerlogs","trailersmall","trailers","trailers2","trailers3","trailers4","freight","freightcar","freightcont1","freightcont2","freightgrain","metrotrain","tanker"}

function random()
    local vehicles = GetAllVehicleModels()
    local vehi = vehicles[math.random(1, #vehicles)]
    
    showNotification("~g~ Nom vehicule spawn: " .. string.lower (vehi))
    RequestModel(vehi)
    repeat Wait(1) until HasModelLoaded(vehi)
    if IsPedSittingInAnyVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId(), false))then
        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(),false))
    end
    local veh = CreateVehicle(vehi, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    if estDansLaListe(vehi,vehicule_list) then
        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
        random()
    end
    print(vehi)
end 





function KeyboardInput(TextEntry, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(1)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end
-- function load du véhicule
function loadModel(modelHash)
    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Citizen.Wait(1)
        RequestModel(modelHash)

    end

end

-- function pour les notifs
function showNotification(msg) 
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false, true)
end

--commade pour faire spawn un véhicule randome
RegisterCommand("spawnrandomcar", function()
	local vehicles = GetAllVehicleModels()
	local veh = vehicles[math.random(1, #vehicles)]
	RequestModel(veh)
	repeat Wait(0) until HasModelLoaded(veh)
    if IsPedSittingInAnyVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId(), false))then
        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(),false))
    end
	local veh = CreateVehicle(veh, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, false)
	SetPedIntoVehicle(PlayerPedId(), veh, -1)
end)

-- Définition de la fonction menu
function menu()
  
    -- Création d'un nouveau menu avec RageUI
    local menuTest = RageUI.CreateMenu("TonyandMonpote's menu","Trop BG")

    
    -- Rend le menu visible si il ne l'est pas, et inversement
    RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
  
    -- Boucle tant que menuTest existe
    while menuTest do
        
        -- Attente de 0ms entre chaque itération de la boucle
        Citizen.Wait(0)
  
        -- Si le menu est visible
        RageUI.IsVisible(menuTest,true,true,true,function()
        
            
            RageUI.ButtonWithStyle("Vehicule",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
        
              if Selected then
                menuTest=RMenu:DeleteType("Titre", true)
                RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
                veh()
  
                end
            end)


            RageUI.ButtonWithStyle("moi",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
        
                if Selected then
                  menuTest=RMenu:DeleteType("Titre", true)
                  RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
                  moimenu()
    
                end
            end)

            RageUI.ButtonWithStyle("Armes",nil, {RightLabel = "→"},true,function(Hovered,Ative,Selected)
                if Selected then
                    menuTest=RMenu:DeleteType("Titre", true)
                    RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
                    armes()
                end
            end)

            RageUI.ButtonWithStyle("TP",nil, {RightLabel = "→"},true,function(Hovered,Ative,Selected)
                if Selected then
                    menuTest=RMenu:DeleteType("Titre", true)
                    RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
                    tp()
                end
            end)

        end, function()
        end)
  
        -- Si le menu n'est pas visible
        if not RageUI.Visible(menuTest) then
            -- Supprime le menu
            menuTest=RMenu:DeleteType("Titre", true)
        end
  
    end
  
end


function  armes()
    
    
    
    local armes = RageUI.CreateMenu("Armes","Options:")

    RageUI.Visible(armes, not RageUI.Visible(armes))

    while armes do 

        Citizen.Wait(0)

        RageUI.IsVisible(armes, true,true,true,function()

            RageUI.ButtonWithStyle("Weapon Give Code",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                -- Si le bouton est sélectionné
                if Selected then    
                    local ArmeName = KeyboardInput("Nom de l'arme", 20)
                    local weaponName = "WEAPON_" .. string.upper(ArmeName)
                    if IsWeaponValid(GetHashKey(weaponName)) then
                        GiveWeaponToPed(PlayerPedId(),GetHashKey(weaponName), 999,false,true)
                        showNotification("~g~ tu as reçu ton arme: " .. string.lower(ArmeName))
                    else

                        showNotification("~r~ Le modèle d'arme n'existe pas") 
                    end
                end
            end)  
            RageUI.ButtonWithStyle("Parachute","Vous give un parachute", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    GiveWeaponToPed(PlayerPedId(),GetHashKey("gadget_parachute"), 2, false, true)
                end
            end)
        
        end,function()
        end)

        if not RageUI.Visible(armes) then
            -- Supprime le menu
            armes=RMenu:DeleteType("Armes", true)
  
            menu()
        end
    end

end



Godemode = false

Invisible = false

Ragdoll = false


function  moimenu()
    
    local vie = GetEntityHealth(PlayerPedId())
    local vieconte =  10
    local moimenu = RageUI.CreateMenu("MOI","Options:")
    
    RageUI.Visible(moimenu, not RageUI.Visible(moimenu))

    while moimenu do 

        Citizen.Wait(0)

        RageUI.IsVisible(moimenu, true,true,true,function()

            RageUI.ButtonWithStyle("Heal",nil, {RightLabel = ""},true,function(Hovered,Ative,Selected)
                if Selected then
                    SetEntityHealth(PlayerPedId(), 2000)
                    
                end
            end)
            

            RageUI.Checkbox("No Ragdoll",nil, Ragdoll, {}, function(Hovered,Ative,Selected,Checked)
            
                if Selected then
                    Ragdoll = Checked
                    if Ragdoll == true then
                        SetPedCanRagdoll(PlayerPedId(), false)
                        showNotification ("~g~ NO Ragdoll ON")
                        
                    else
                        SetPedCanRagdoll(PlayerPedId(), true)
                        showNotification ("~r~ NO Ragdoll OFF")
                    end
                end
            end)

        
            RageUI.Checkbox("Godmode", nil, Godemode, {}, function(Hovered,Ative,Selected,Checked)
                if Selected then
                    Godemode = Checked
                    if Godemode == true then
                        SetEntityInvincible(PlayerPedId(), true)
                        showNotification ("~g~Gode Mode ON")
                    else
                        SetEntityInvincible(PlayerPedId(), false)
                        showNotification ("~r~Gode Mode OFF")
                    end
                end
            end)


            RageUI.Checkbox("Invisible",nil, Invisible, {}, function(Hovered,Ative,Selected,Checked)
            
                if Selected then
                    Invisible = Checked
                    if Invisible == true then
                        SetEntityVisible(PlayerPedId(), false, 0)
                        showNotification ("~g~Invisible ON")
                    else
                        SetEntityVisible(PlayerPedId(), true, 0)
                        showNotification ("~r~Invisible OFF")
                    end
                end
            end)
        end,function()
        end)

        if not RageUI.Visible(moimenu) then
            -- Supprime le menu
            moimenu=RMenu:DeleteType("MOI", true)
  
            menu()
        end
    end

end

function spawnveh()
  
    -- Création d'un nouveau menu avec RageUI
    local spawnveh = RageUI.CreateMenu("Spawn Véhicules","Menu pour faire spawn des Vehicules")
  
    -- Rend le menu visible si il ne l'est pas, et inversement
    RageUI.Visible(spawnveh, not RageUI.Visible(spawnveh))
  
    -- Boucle tant que menuTest existe
    while spawnveh do
        
        -- Attente de 0ms entre chaque itération de la boucle
        Citizen.Wait(0)
  
        -- Si le menu est visible
        RageUI.IsVisible(spawnveh,true,true,true,function()
            
            
            RageUI.ButtonWithStyle("Véhicule Randome", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then 
                    random()
                end
            end)
            
            RageUI.ButtonWithStyle("Vehicule Spawn Code", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                -- Si le bouton est sélectionné
                if Selected then    

                    
                    local vehName = KeyboardInput("Nom du Véhicule", 15)
                    local modelname = GetDisplayNameFromVehicleModel(vehName)

                    

                    if modelname ~= "CARNOTFOUND" then
                        if not HasModelLoaded(GetHashKey(vehName)) then
                            loadModel(GetHashKey(vehName))
                        end
                        
                        if IsPedSittingInAnyVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId(), false)) then
                            DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
                        end

                        local coords = GetEntityCoords(PlayerPedId(), true)
    
                        local vehicule = CreateVehicle(GetHashKey(vehName), coords, GetEntityHeading(PlayerPedId()), true, false)
    
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicule, -1)
                    
                        showNotification ("~g~Spawn du véhicule")
                    else
                        showNotification ("~r~ Nom du véhicule incorrect")
                
                
                    end
                end
            end)  
            
            RageUI.Separator("Préfaits")
            
            -- Création d'un bouton avec un label à droite
            RageUI.ButtonWithStyle("tampadrift",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                -- Si le bouton est sélectionné
                if Selected then    


                    if not HasModelLoaded(GetHashKey('tampa2')) then
                        loadModel(GetHashKey('tampa2'))
                    end
                    
                    if IsPedSittingInAnyVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId(), false)) then
                        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
                    end

                    local coords = GetEntityCoords(PlayerPedId(), true)
  
                    local Vehicule = CreateVehicle(GetHashKey('tampa2'), coords, GetEntityHeading(PlayerPedId()), true, false)
  
                    TaskWarpPedIntoVehicle(PlayerPedId(), Vehicule, -1)
                  
                    showNotification ("~g~Spawn du véhicule")
                end
            end)  
  
  
            -- Création d'un bouton avec un badge à droite
            RageUI.ButtonWithStyle("Hydra",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                -- Si le bouton est sélectionné
                if Selected then
                    if not HasModelLoaded(GetHashKey('hydra')) then
                        loadModel(GetHashKey('hydra'))
                    end
                    
                    if IsPedSittingInAnyVehicle(PlayerPedId(),GetVehiclePedIsIn(PlayerPedId(), false)) then
                        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
                    end

                    local coords = GetEntityCoords(PlayerPedId(), true)
  
                    local Vehicule = CreateVehicle(GetHashKey('hydra'), coords, GetEntityHeading(PlayerPedId()), true, false)
  
                    TaskWarpPedIntoVehicle(PlayerPedId(), Vehicule, -1)
                  
                    showNotification('~g~Spawn du véhicule')
                end
            end)  
  
  
        end, function()
        end)
  
        -- Si le menu n'est pas visible
        if not RageUI.Visible(spawnveh) then
            -- Supprime le menu
            spawnveh=RMenu:DeleteType("Titre", true)
  
            veh()
  
        end
  
    end
  
end


function tp()
  
    -- Création d'un nouveau menu avec RageUI
    local tp = RageUI.CreateMenu("Téléportation","Endroits:")
  
    -- Rend le menu visible si il ne l'est pas, et inversement
    RageUI.Visible(tp, not RageUI.Visible(tp))
  
    -- Boucle tant que menuTest existe
    while tp do
        
        -- Attente de 0ms entre chaque itération de la boucle
        Citizen.Wait(0)
  
        -- Si le menu est visible
        RageUI.IsVisible(tp,true,true,true,function()

            RageUI.ButtonWithStyle("Maze Bank",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    SetPedCoordsKeepVehicle(PlayerPedId(),-75.15047, -819.1027, 326.1752)
                end
            end)
            
            RageUI.ButtonWithStyle("Aeroport",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    SetPedCoordsKeepVehicle(PlayerPedId(),-1335.651, -3043.993, 13.94444)
                end
            end)
            
            RageUI.ButtonWithStyle("Base Militaire",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    SetPedCoordsKeepVehicle(PlayerPedId(),-2328.331, 3043.235, 32.81433)
                end
            end)
            RageUI.ButtonWithStyle("TP Waypoint",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    local waypointBlip = GetFirstBlipInfoId(8)
                    if DoesBlipExist(waypointBlip) then
                        local waypointCoords = GetBlipInfoIdCoord(waypointBlip)
                        local x, y, z = table.unpack(waypointCoords)
                
                        -- Essayer de trouver la coordonnée Z du sol à la position (x, y)
                        local foundGround, groundZ = GetGroundZFor_3dCoord(x, y, z + 1000, false)
                
                        if foundGround then
                            -- Si le sol est trouvé, téléporter le joueur à cette position
                            SetEntityCoords(playerPed, x, y, groundZ)
                        else
                            -- Si le sol n'est pas trouvé, téléporter le joueur à la position initiale avec un ajustement en Z
                            SetEntityCoords(playerPed, x, y, z + 1000)
                        end
                    else
                        print("No waypoint set.")
                    end

                end
            end)


            
            
            
  
        end, function()
        end)
  
        -- Si le menu n'est pas visible
        if not RageUI.Visible(tp) then
            -- Supprime le menu
            tp=RMenu:DeleteType("Téléportation", true)
  
            menu()
  
        end
  
    end
  
end
vehgodmode = false
vehhornboost = false
ped = GetPlayerPed(-1)
currentvehicle = GetVehiclePedIsIn(ped, false)
Maxspeed = GetVehicleMaxSpeed(currentvehicle)
horn = IsHornActive(currentvehicle)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)

        
            if IsHornActive(currentvehicle) then
                
                SetVehicleForwardSpeed(currentvehicle, Maxspeed)
            end

    end
end)

vehhornboost = false
function veh()
   
    -- Création d'un nouveau menu avec RageUI
    local veh = RageUI.CreateMenu("Menu Véhicule","Options:")
  
    -- Rend le menu visible si il ne l'est pas, et inversement
    RageUI.Visible(veh, not RageUI.Visible(veh))
  
    -- Boucle tant que menuTest existe
    while veh do
        
        -- Attente de 0ms entre chaque itération de la boucle
        Citizen.Wait(0)
  
        -- Si le menu est visible
        RageUI.IsVisible(veh,true,true,true,function()

            RageUI.ButtonWithStyle("Menu Spawn Véhicule","Ouverture du menu de pour Spawn les Véhicules", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    spawnveh()
                end
            end)
            

            RageUI.ButtonWithStyle("boost",nil, {RightLabel = "~r~dsa$"}, true, function(Hovered, Active, Selected)
                if Selected then
                    print(Maxspeed)
                    Vitesse = GetPedCurrentMovementSpeed(ped)
			        SetVehicleForwardSpeed(currentvehicle, Maxspeed)
			        StartScreenEffect("RaceTurbo", 0, 0)
                end
            end)

            RageUI.Checkbox("Horn Boost", nil, vehhornboost, {2}, function(Hovered,Ative,Selected,Checked)
                if Selected then
                    vehhornboost = Checked
                    
                    Citizen.CreateThread(function()
                        while true do 
                            Citizen.Wait(1)

                            currentvehicle = GetVehiclePedIsIn(ped, false)
                            if IsHornActive(currentvehicle) then
                                
                                SetVehicleForwardSpeed(currentvehicle, Maxspeed)
                            end

                        end
                    end)
                end
            end)
            

            RageUI.Checkbox("Véhicule GodeMode", "Rends le véhicule invincible", vehgodmode, {2}, function(Hovered,Ative,Selected,Checked)
                if Selected then
                    vehgodmode = Checked
                    if vehgodmode == true then
                        SetEntityInvincible(GetVehiclePedIsIn(PlayerPedId(),false),true)
                        showNotification("~g~le véhicule est en godmode")
                    else
                        SetEntityInvincible(GetVehiclePedIsIn(PlayerPedId(),false),false)
                        showNotification("~r~le véhicule est plus en godmode")
                    end
                end
            end)
            
            
  
        end, function()
        end)
  
        -- Si le menu n'est pas visible
        if not RageUI.Visible(veh) then
            -- Supprime le menu
            veh=RMenu:DeleteType("Menu Véhicule", true)
  
            menu()
  
        end
  
    end
  
end

RegisterNetEvent('annonce:sendAnnounceMessage')
AddEventHandler('annonce:sendAnnounceMessage', function(msg)
	PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)

    local AnnounceTime = 10
	local time = 0

    local function setcountdown(x) time = GetGameTimer() + x*1000 end
    local function getcountdown() return math.floor((time-GetGameTimer())/1000) end
    
    setcountdown(AnnounceTime)

    while getcountdown() > 0 do
        Citizen.Wait(1)
		local scaleform = Initialize("mp_big_message_freemode", msg)
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end
end)

-- Scaleform:
function Initialize(scaleform, msg)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~c~~r~ANNONCE") -- Titre de l'annonce
    PushScaleformMovieFunctionParameterString(msg) -- Message de l'annonce
	PopScaleformMovieFunctionVoid()
    return scaleform
end 


