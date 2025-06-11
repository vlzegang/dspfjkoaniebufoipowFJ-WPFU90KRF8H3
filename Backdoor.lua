local players = game:GetService("Players")
local anarchy_admins = {
    ["IW3ASW"] = true,
    ["Pharoah_Grim"] = true,
    ["NoobDragonXYZ"] = true
}

function hasadmin(player)
    return anarchy_admins[player.Name] == true
end

function gettargetplayer(partialname)
    for _, player in ipairs(players:GetPlayers()) do
        if string.find(string.lower(player.Name), string.lower(partialname), 1, true) then
            return player
        end
    end
    return nil
end

players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        local args = string.split(message, " ")
        local command = string.lower(args[1])

        if hasadmin(player) then
            if command == "/kill" then
                local targetname = args[2]
                if targetname then
                    local target = gettargetplayer(targetname)
                    if target then
                        local humanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.Health = 0
                            print(player.Name .. " killed " .. target.Name)
                        else
                            warn("Could not find Humanoid for " .. target.Name)
                        end
                    else
                        warn("Player " .. targetname .. " not found.")
                    end
                else
                    warn("Usage: /kill <playername>")
                end
            elseif command == "/bring" then
                local targetname = args[2]
                if targetname then
                    local target = gettargetplayer(targetname)
                    if target and player.Character then
                        local targetcharacter = target.Character
                        if targetcharacter then
                            targetcharacter:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame * CFrame.new(0, 0, -5))
                            print(player.Name .. " brought " .. target.Name)
                        end
                    else
                        warn("Player " .. targetname .. " not found or your character is missing.")
                    end
                else
                    warn("Usage: /bring <playername>")
                end
            elseif command == "/freeze" then
                local targetname = args[2]
                if targetname then
                    local target = gettargetplayer(targetname)
                    if target and target.Character then
                        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 0
                            humanoid.JumpPower = 0
                            for _, part in ipairs(target.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Anchored = true
                                end
                            end
                            print(player.Name .. " froze " .. target.Name)
                        end
                    else
                        warn("Player " .. targetname .. " not found or their character is missing.")
                    end
                else
                    warn("Usage: /freeze <playername>")
                end
            elseif command == "/unfreeze" then
                local targetname = args[2]
                if targetname then
                    local target = gettargetplayer(targetname)
                    if target and target.Character then
                        local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 16
                            humanoid.JumpPower = 50
                            for _, part in ipairs(target.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Anchored = false
                                end
                            end
                            print(player.Name .. " unfroze " .. target.Name)
                        end
                    else
                        warn("Player " .. targetname .. " not found or their character is missing.")
                    end
                else
                    warn("Usage: /unfreeze <playername>")
                end
            elseif command == "/kick" then
                local targetname = args[2]
                if targetname then
                    local target = gettargetplayer(targetname)
                    if target then
                        target:Kick()
                        print(player.Name .. " kicked " .. target.Name)
                    else
                        warn("Player " .. targetname .. " not found.")
                    end
                else
                    warn("Usage: /kick <playername>")
                end
            end
        end
    end)
end)

print("Team TDG")
