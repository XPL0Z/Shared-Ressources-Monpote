-- Création d'un nouveau thread Citizen
Citizen.CreateThread(function()

  -- Boucle infinie pour vérifier en continu
  while true do

      -- Attente de 1ms entre chaque itération de la boucle pour éviter le surcharge du processeur
      Citizen.Wait(1)

      NetworkSetFriendlyFireOption(true)
      SetCanAttackFriendly(playerPed, true, true)

      -- Vérifie si le bouton 166 est pressé
      if IsControlJustPressed(1,166) then
          -- Si le bouton est pressé, la fonction menu est appelée
          menu()
      end

  end

end)

-- Initialisation de la variable etat à false
etat = false
vehetat = false
Ragdoll = false
noclip = false
invisible = false
seatbealt = false
radioOff = false
-- Définition de la fonction menu
function menu()

  -- Création d'un nouveau menu avec RageUI
  local menuTest = RageUI.CreateMenu("Monpote's Mode menu","Trop BG")

  -- Rend le menu visible si il ne l'est pas, et inversement
  RageUI.Visible(menuTest, not RageUI.Visible(menuTest))

  -- Boucle tant que menuTest existe
  while menuTest do
      
      -- Attente de 0ms entre chaque itération de la boucle pour éviter le surcharge du processeur
      Citizen.Wait(0)

      -- Vérifie si le menu est visible
      RageUI.IsVisible(menuTest,true,true,true,function()
      

          -- Création d'un bouton avec un label à droite
          RageUI.ButtonWithStyle("Vehicule",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
      
            -- Si le bouton est sélectionné, le menu est supprimé et la fonction veh est appelée
            if Selected then
              menuTest=RMenu:DeleteType("Titre", true)
              RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
              veh()

            end
          end)
          
          RageUI.ButtonWithStyle("Weapon",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
              menuTest=RMenu:DeleteType("Monpote's Mode menu", true)
              RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
              weapon()
            end
          end)

          RageUI.ButtonWithStyle("Teleport",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
              menuTest=RMenu:DeleteType("Monpote's Mode menu", true)
              RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
              tp()
            end
          end)



          RageUI.ButtonWithStyle("World",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
      
            -- Si le bouton est sélectionné, le menu est supprimé et la fonction veh est appelée
            if Selected then
              menuTest=RMenu:DeleteType("Titre", true)
              RageUI.Visible(menuTest, not RageUI.Visible(menuTest))
              world()


          -- Création d'une case à cocher pour activer/désactiver le GodMode
          RageUI.Checkbox("GodMode",nil, etat, {}, function(Hovered,Active,Selected,Checked)
          -- Si la case est sélectionnée, la variable etat est mise à jour et le GodMode est activé/désactivé
            if Selected then
              etat = Checked
              if etat==true then
                SetEntityInvincible(PlayerPedId(), true)
                print("Je suis en GodMode")
              else
                SetEntityInvincible(PlayerPedId(), false)
                print("Je ne suis plus en GodMode")
              end
            end
          end)

          RageUI.Checkbox("Noclip", nil, noclip, {}, function(Hovered,Active,Selected,Checked)
            if Selected then
              noclip = Checked
              local playerPed = PlayerPedId()
              local isInVehicle = IsPedInAnyVehicle(playerPed, false)
              local vehicle = nil
              local speed = 2.0

              if isInVehicle then
                vehicle = GetVehiclePedIsIn(playerPed, false)
              end

              if noclip == true then
                SetEntityCollision(playerPed, false, true)
                SetEntityInvincible(playerPed, true)
                if isInVehicle then
                  SetEntityCollision(vehicle, false, false)
                  SetEntityInvincible(vehicle, true)
                end
              print("NOCLIP ON")
            else
              SetEntityCollision(playerPed, true, true)
              SetEntityInvincible(playerPed, false)
              if isInVehicle then
                SetEntityCollision(vehicle, true, true)
                SetEntityInvincible(vehicle, false)
              end
              print("NOCLIP OFF")
            end
          end
        end)

        local speed = 0.005

        Citizen.CreateThread(function()
          while true do
            Citizen.Wait(0)
        
            if noclip then
              local playerPed = PlayerPedId()
              local coords = GetEntityCoords(playerPed)
              local camCoords = GetGameplayCamCoord()
              local direction = GetCamRot(camCoords, 2)
              local isControlPressed = false
        
              if IsControlPressed(0, 32) then
                local directionVector = GetDirectionFromRotation(direction) * speed
                coords = vector3(coords.x + directionVector.x, coords.y + directionVector.y, coords.z + directionVector.z)
                isControlPressed = true
              end
              if IsControlPressed(0, 33) then
                local directionVector = GetDirectionFromRotation(direction) * speed
                coords = vector3(coords.x - directionVector.x, coords.y - directionVector.y, coords.z - directionVector.z)
                isControlPressed = true
              end
              if IsControlPressed(0, 34) then -- Gauche
                local directionVector = GetDirectionFromRotation(direction) * speed
                coords = vector3(coords.x - directionVector.y, coords.y + directionVector.x, coords.z)
                isControlPressed = true
              end
              if IsControlPressed(0, 35) then -- Droite
                local directionVector = GetDirectionFromRotation(direction) * speed
                coords = vector3(coords.x + directionVector.y, coords.y - directionVector.x, coords.z)
                isControlPressed = true
              end
              if IsControlPressed(0, 22) then
                coords = vector3(coords.x, coords.y, coords.z + speed)
                isControlPressed = true
              end
              if IsControlPressed(0, 36) then
                coords = vector3(coords.x, coords.y, coords.z - speed)
                isControlPressed = true
              end
              if isControlPressed then
                SetEntityCoordsNoOffset(playerPed, coords, true, true, true)
              end
            end
          end
        end)

        function GetDirectionFromRotation(rotation)
          local adjustedRotation = (math.pi / 180.0) * rotation
          return vector3(-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.sin(adjustedRotation.x))
        end

          RageUI.Checkbox("No Ragdoll",nil, Ragdoll, {}, function(Hovered, Active, Selected, Checked)
            
            if Selected then
              Ragdoll = Checked
              if Ragdoll ==true then
                SetPedCanRagdoll(PlayerPedId(), false)
              else
                SetPedCanRagdoll(PlayerPedId(), true)
              end
            end
          end)
          RageUI.Checkbox("invisible", nil, invisible, {}, function(Hovered, Active, Selected, Checked)
            if Selected then
              invisible = Checked
              if invisible == true then
                SetEntityVisible(PlayerPedId(), false, 0)
              else
                SetEntityVisible(PlayerPedId(), true, 0)
              end
            end
          end)
      end, function()
      end)

      if not RageUI.Visible(menuTest) then
          menuTest=RMenu:DeleteType("Monpote's Mode menu", true)
      end

  end

end

-- Fonction pour charger un modèle de véhicule
function loadModel(modelHash)
  -- Demande le chargement du modèle
  RequestModel(modelHash)

  -- Boucle tant que le modèle n'est pas chargé
  while not HasModelLoaded(modelHash) do
    -- Attente de 1ms entre chaque itération de la boucle pour éviter le surcharge du processeur
    Citizen.Wait(1)
    -- Nouvelle demande de chargement du modèle
    RequestModel(modelHash)
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if radioOff == true then
      if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        SetVehRadioStation(vehicle, "OFF")
      end
    end
  end
end)
-- Fonction pour gérer le menu des véhicules
function veh()

  -- Création d'un nouveau menu avec RageUI
  local veh = RageUI.CreateMenu("Veh","Vehicule")

  -- Rend le menu visible si il ne l'est pas, et inversement
  RageUI.Visible(veh, not RageUI.Visible(veh))

  -- Boucle tant que le menu veh existe
  while veh do
      
      -- Attente de 0ms entre chaque itération de la boucle pour éviter le surcharge du processeur
      Citizen.Wait(0)

      -- Vérifie si le menu est visible
      RageUI.IsVisible(veh,true,true,true,function()

        RageUI.ButtonWithStyle("Chercher la voiture", "Entrez le nom du modèle pour obtenir la voiture", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
          if Selected then
              DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
              while (UpdateOnscreenKeyboard() == 0) do
                  DisableAllControlActions(0);
                  Wait(0);
              end
              if (GetOnscreenKeyboardResult()) then
                  local result = GetOnscreenKeyboardResult()
                  local vehicleHash = GetHashKey(result)
                  if IsModelInCdimage(vehicleHash) and IsModelAVehicle(vehicleHash) then
                      loadModel(vehicleHash)
                      local coords = GetEntityCoords(PlayerPedId(), true)
                      local vehicle = CreateVehicle(vehicleHash, coords, GetEntityHeading(PlayerPedId()), true, false)
                      TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                      print("Voiture spawnée")
                  else
                      print("Le modèle de voiture n'existe pas")
                  end
              else 
                  menu()
              end
          end
        end)

          RageUI.ButtonWithStyle("Repaire", "Repare la voiture", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            if Selected then
              SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId(), false))
            end
          end)
          -- Création d'un bouton avec un label à droite
          RageUI.ButtonWithStyle("tampa2","tampa2", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
              -- Si le bouton est sélectionné, le modèle de véhicule est chargé et le véhicule est créé
              if Selected then    
                  loadModel(GetHashKey('tampa2'))

                  local coords = GetEntityCoords(PlayerPedId(), true)

                  local Vehicule = CreateVehicle(GetHashKey('tampa2'), coords, GetEntityHeading(PlayerPedId()), true, false)

                  TaskWarpPedIntoVehicle(PlayerPedId(), Vehicule, -1)
                  GiveWeaponToPed(PlayerPedId(), "WEAPON_PISTOL", 9999, true, false)
                  GiveWeaponToPed(PlayerPedId(), "weapon_stickybomb", 9999, true, false)
                
                  print('Spawn veh')
              end
          end)  


          -- Création d'un bouton avec un badge à droite
          RageUI.ButtonWithStyle("hydra","hydra", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
              -- Si le bouton est sélectionné, un message est affiché dans la console
              if Selected then
                loadModel(GetHashKey('hydra'))

                local coords = GetEntityCoords(PlayerPedId(), true)

                local Vehicule = CreateVehicle(GetHashKey('hydra'), coords, GetEntityHeading(PlayerPedId()), true, false)

                TaskWarpPedIntoVehicle(PlayerPedId(), Vehicule, -1)
              
                print('Spawn veh')
              end
          end)  

          RageUI.Checkbox("Vehicul GodMode",nil, vehetat, {}, function(Hovered, Active, Selected, Checked)
            if Selected then
              vehetat = Checked
              if vehetat==true then
                SetEntityInvincible(GetVehiclePedIsIn(PlayerPedId(), false), true)
              else
                SetEntityInvincible(GetVehiclePedIsIn(PlayerPedId(), false), false)
              end
            end
          end)
        RageUI.Checkbox("Seat bealt", "IMPOSSIBLE DE QUITTER LE VEHICULE", seatbealt, {}, function(Hovered, Active, Selected, Checked)
          if Selected then
            seatbealt = Checked
            if seatbealt == true then
              SetPedCanBeKnockedOffVehicle(PlayerPedId(), true)
            else
              SetPedCanBeKnockedOffVehicle(PlayerPedId(), false)
            end
          end
        end)
        RageUI.Checkbox("Radio auto OFF", "étain directemand la radio", radioOff, {}, function(Hovered, Active, Selected, Checked)
          if Selected then
            radioOff = Checked
          end
        end)

      end, function()
      end)

      -- Si le menu n'est pas visible, le menu est supprimé et la fonction menu est appelée
      if not RageUI.Visible(veh) then
          veh=RMenu:DeleteType("Titre", true)

          menu()

      end

  end

end

function weapon()
  local weapon = RageUI.CreateMenu("Weapon", "Weapon")
  RageUI.Visible(weapon, not RageUI.Visible(weapon))
  while weapon do
    Citizen.Wait(0)
    RageUI.IsVisible(weapon,true,true,true,function()

      RageUI.ButtonWithStyle("Chercher l'arme", "Entrez le nom du modèle pour obtenir l'arme", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
        if Selected then
            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
            while (UpdateOnscreenKeyboard() == 0) do
                DisableAllControlActions(0);
                Wait(0);
            end
            if (GetOnscreenKeyboardResult()) then
                local result = GetOnscreenKeyboardResult()
                local weaponHash = GetHashKey(result)
                if IsWeaponValid(weaponHash) then
                    GiveWeaponToPed(PlayerPedId(), weaponHash, 9999, false, true)
                    print("Arme donnée")
                else
                    print("Le modèle d'arme n'existe pas")
                end
            else 
                menu()
            end
        end
    end)

    end,function()
    end)

    if not RageUI.Visible(weapon) then
      weapon=RMenu:DeleteType("Weapon", true)
      menu()
    end

  end

end

function tp()
  local tp = RageUI.CreateMenu("Teleport", "TP")
  RageUI.Visible(tp, not RageUI.Visible(tp))
  while tp do
    Citizen.Wait(0)
    RageUI.IsVisible(tp,true,true,true,function()

      RageUI.ButtonWithStyle("Get coords",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
        if Selected then
          local coords = GetEntityCoords(PlayerPedId(), false)
          print(coords)
        end
      end)

      RageUI.ButtonWithStyle("Areaport","TP", {RightLabel = "→"}, true,function(Hovered, Active, Selected)
        if Selected then
          SetPedCoordsKeepVehicle(PlayerPedId(), -1720.43, -2921.617, 13.94443)
        end
      end)
      RageUI.ButtonWithStyle("Maze Bank", "TP TOP", {RightLabel = "→"}, true,function(Hovered, Active, Selected)
        if Selected then
          SetPedCoordsKeepVehicle(PlayerPedId(), -75.20296, -819.1085, 326.1754)
        end
      end)

      RageUI.ButtonWithStyle("BASE MILITERE","TP", {RightLabel = "→"}, true,function(Hovered, Active, Selected)
        if Selected then
          SetPedCoordsKeepVehicle(PlayerPedId(), -2018.737, 2865.175, 32.9061)
        end
      end)

    end,function()
    end)

    if not RageUI.Visible(tp) then
      tp=RMenu:DeleteType("Teleport", true)

      menu()

    end

  end

end

function world()
  local world = RageUI.CreateMenu("World", "World")
  RageUI.Visible(weapon, not RageUI.Visible(world))
  while world do
    Citizen.Wait(0)
    RageUI.IsVisible(world,true,true,true,function()

      RageUI.ButtonWithStyle("Set time to day","Day", {RightLabel = "→"}, true,function(Hovered,Active,Selected)
        if Selected then
          TriggerServerEvent('setTime', 12, 0)
        end
      end)
    end,function()
    end)

    if not RageUI.Visible(world) then
      world=RMenu:DeleteType("World", true)

      menu()

    end

  end

end