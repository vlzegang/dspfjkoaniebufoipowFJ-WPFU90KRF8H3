--// CONFIGURATION //--
local NORMAL_GRAVITY = 196.2
local BLOCKED_HUMANOID_PROPERTIES = {
    "JumpPower", "Gravity", "HipHeight", "Health", "BodyVelocity", "WalkSpeed", "BodyPosition", "BodyThrust", "BodyAngularVelocity"
}
local BLOCKED_INPUT_FLAGS = { "bv", "hb", "jp", "hh", "ws" }

--// UTILITY FUNCTIONS //--
function safe_table_find(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return i end
    end
    return nil
end

--// METATABLE SETUP //--
local rawMeta = getrawmetatable(game)
setreadonly(rawMeta, false)

local newcclosure = newcclosure
local getnamecallmethod = getnamecallmethod
local checkcaller = checkcaller
local getcallingscript = getcallingscript

local NewIndex, NameCall

--// HOOKED FUNCTIONS //--
function hook_index(self, key, value)
    if not checkcaller() then
        if typeof(self) == "Instance" and self:IsA("Humanoid") then
            pcall(function()
                game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
            end)
            if safe_table_find(BLOCKED_HUMANOID_PROPERTIES, key) then
                return nil
            end
        end
        if self == workspace and key == "Gravity" then
            return NORMAL_GRAVITY
        end
        if key == "CFrame" and self:IsDescendantOf(game.Players.LocalPlayer.Character) then
            return CFrame.new(0,0,0)
        end
    end
    return NewIndex(self, key, value)
end
function hook_namecall(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if method == "BreakJoints" and self == game.Players.LocalPlayer.Character then
        return wait(9e9)
    end
    if method == "FireServer" then
        local name = self.Name
        if name == "Input" and safe_table_find(BLOCKED_INPUT_FLAGS, args[1]) then
            return wait(9e9)
        end
        if self.Parent == (args[1] == "hey" and name ~= "SayMessageRequest") then
            return wait(9e9)
        end
    end
    return NameCall(self, unpack(args))
end

--// HOOKING //--
function hook_method()
    if hookfunction then
        NewIndex = hookfunction(rawMeta.__newindex, newcclosure(hook_index))
        NameCall = hookfunction(rawMeta.__namecall, newcclosure(hook_namecall))
        print("2")
    else
        warn("[Bypass] No suitable hook method found!")
    end
end

--// INIT //--
hook_method()
print("Game bypassed.")
