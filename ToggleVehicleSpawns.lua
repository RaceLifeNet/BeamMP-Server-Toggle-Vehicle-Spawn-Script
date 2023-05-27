-- List of permitted user names
local permittedUsers = {
    "User1",
    "User2",
    "User3"
}

-- Variable to track the vehicle spawning state
local isVehicleSpawningEnabled = true

-- Command handler for the toggle command and adduser command
function onChatMessage(playerId, name, message)
    -- Check if the player is in the list of permitted users
    if IsUserPermitted(name) then
        -- Check if the message is the toggle command
        if message == "/togglespawn" then
            -- Toggle the vehicle spawning state
            isVehicleSpawningEnabled = not isVehicleSpawningEnabled

            -- Send a chat message to all players indicating the new state
            local status = isVehicleSpawningEnabled and "enabled" or "disabled"
            MP.SendChatMessage(-1, "Vehicle spawning has been " .. status .. " by " .. name)

            -- Send a chat message to the permitted player confirming the toggle
            MP.SendChatMessage(playerId, "Vehicle spawning has been " .. status .. " successfully.")

            -- Print debug message to the console
            print("Vehicle spawning toggled " .. status .. " by " .. name)
        end

        -- Check if the message is the adduser command
        local command, user = string.match(message, "^/adduser%s+(%w+)$")
        if command and user then
            -- Add the user to the list of permitted users
            table.insert(permittedUsers, user)

            -- Send a chat message to the player indicating the user has been added
            MP.SendChatMessage(playerId, "User " .. user .. " has been added to the permitted users list.")

            -- Print debug message to the console
            print("User " .. user .. " added to the permitted users list by " .. name)
        end
    end
end

-- Register the chat message event
MP.RegisterEvent("onChatMessage", "onChatMessage")

-- Event handler for vehicle spawning
function onVehicleSpawn(playerId, vehicleId, data)
    -- Check if vehicle spawning is enabled
    if not isVehicleSpawningEnabled then
        -- Cancel the vehicle spawn
        return 1
    end
end

-- Register the vehicle spawning event
MP.RegisterEvent("onVehicleSpawn", "onVehicleSpawn")

-- Function to check if a player is in the list of permitted users
function IsUserPermitted(name)
    -- Check if the player's name is in the permitted users list
    for _, user in ipairs(permittedUsers) do
        if user == name then
            return true
        end
    end
    
    return false
end

-- Event handler for script initialization
function onInit()
    -- Print a message to the console indicating that the script has initialized
    print("Toggle vehicle spawning script initialized.")
end

-- Register the onInit event
MP.RegisterEvent("onInit", "onInit")
