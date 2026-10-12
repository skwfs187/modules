--Credits : https://scriptblox.com/raw/NEW-MAP-BloxStrike-No-Spread-Open-Source-232179

local loadedModules = getloadedmodules()
local Bullet
for index = 1, #loadedModules do
    local success, module = pcall(require, loadedModules[index])
    if success and type(module) == "table" and type(module._performRaycast) == "function"
       and type(module.getTrueSpread) == "function" then
        Bullet = module
        break
    end
end

if not Bullet then
    return warn("ummmmm")
end

local originalRaycast = Bullet._performRaycast
Bullet._performRaycast = function(self, _, ...) return originalRaycast(self, 0, ...) end

local spreadGetters = { "getTrueSpread", "getBaseSpread", "getSpreadForConfig",
                        "getBaseSpreadForConfig", "getMovementSpreadForConfig" }
for index = 1, #spreadGetters do
    local getterName = spreadGetters[index]
    if type(Bullet[getterName]) == "function" then
        Bullet[getterName] = function() return 0 end
    end
end

Bullet._updateShotSpread = function(self)
    local spreadConfig = self.ActiveSpreadConfig or (self.Properties and self.Properties.Spread)
    local minSpread = spreadConfig and spreadConfig.Range and spreadConfig.Range.Min
    if minSpread and self.Spread then
        self.Spread:setPosition(minSpread)
        self.Spread:setGoal(minSpread)
    end
end
