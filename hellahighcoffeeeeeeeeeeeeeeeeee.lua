-- Utility functions
function safeGetRawMetatable(obj)
    local success, mt = pcall(getrawmetatable, obj)
    return success and mt or nil
end

function safeSetReadOnly(mt, state)
    pcall(function() setreadonly(mt, state) end)
end

-- Get metatables
local meta = debug.getmetatable(game)
local rawMeta = safeGetRawMetatable(game)
if not meta or not rawMeta then
    warn("Failed to get metatables!")
    return
end

-- Store original metamethods
local origIndex = rawMeta.__index
local origNewIndex = meta.__newindex
local origNamecall = meta.__namecall

-- Helper value for spoofing
local spoofBool = Instance.new("BoolValue")
spoofBool.Value = false

-- Make metatables writable
safeSetReadOnly(meta, false)
safeSetReadOnly(rawMeta, false)

-- Advanced __index hook
rawMeta.__index = function(self, key)
    if typeof(self) == "Instance" and self:IsA("Part") and key == "Anchored" then
        return origIndex(spoofBool, "Value")
    end
    return origIndex(self, key)
end

-- Advanced __newindex hook
meta.__newindex = newcclosure(function(self, key, value)
    if checkcaller() then
        return origNewIndex(self, key, value)
    end

    if typeof(self) == "Instance" and self:IsA("Humanoid") then
        if key == "Health" and value == 0 then return end
        if key == "WalkSpeed" and value == 0 then return end
    end

    if key == "CFrame" and (tostring(self) == "Torso" or tostring(self) == "HumanoidRootPart") then
        return
    end

    return origNewIndex(self, key, value)
end)

-- Advanced __namecall hook
meta.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if not checkcaller() then
        if method == "BreakJoints" then
            return wait(9e9)
        end
    end

    if method == "FireServer" then
        if tostring(self) == "lIII" then
            return wait(9e9)
        end
        if args[1] == "hey" and args[1] == "ws" then
            return wait(9e9)
        end
    end

    return origNamecall(self, ...)
end)
