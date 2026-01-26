local noclip = false
local noclip_speed = 1.0

RegisterCommand("noclip", function()
    noclip = not noclip
    local ped = PlayerPedId()

    if noclip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        print("Noclip Enabled")
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        print("Noclip Disabled")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if noclip then
            local ped = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local dx, dy, dz = GetCamDirection()
            
            -- Speed multipliers
            local speed = noclip_speed
            if IsControlPressed(0, 21) then speed = speed * 3.0 end -- Left Shift to go faster
            
            -- Disable controls to prevent walking animations
            DisableControlAction(0, 30, true) -- Move LR
            DisableControlAction(0, 31, true) -- Move UD

            if IsControlPressed(0, 32) then -- W
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end
            if IsControlPressed(0, 33) then -- S
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
    end
end)

-- Helper function to get the direction the camera is facing
function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    -- Normalize the vector
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end