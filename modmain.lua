local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local SpawnPrefab = GLOBAL.SpawnPrefab
local unpack = GLOBAL.unpack
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TheWorld = GLOBAL.TheWorld
local ACTIONS = GLOBAL.ACTIONS
local FUELTYPE = GLOBAL.FUELTYPE
local language = GetModConfigData("language")

local function zh_en(zh, en)
	return language == "zh" and zh or en
end

PrefabFiles = {
	"skeleton_saddle",
	"winged_saddle",
	"lunar_saddle",
	"sun_saddle"
}

Assets = 
{
	-- 风之鞍具
	Asset( "ATLAS", "images/winged_saddle.xml" ),
	Asset( "IMAGE", "images/winged_saddle.tex"),

	-- 暗影鞍具
	Asset( "ATLAS", "images/skeleton_saddle.xml" ),
	Asset("IMAGE", "images/skeleton_saddle.tex"), 

	-- 月光鞍具
	Asset( "ATLAS", "images/lunar_saddle.xml" ),
	Asset( "IMAGE", "images/lunar_saddle.tex"),

	-- 旭日鞍具
	Asset( "ATLAS", "images/sun_saddle.xml" ),
	Asset( "IMAGE", "images/sun_saddle.tex"),

}

-- 风之鞍具
-- 增加80%移速(speed +80%) 骑行时能防止过热
AddRecipe2("winged_saddle", {Ingredient("silk", 108), Ingredient("goose_feather", 56), Ingredient("livinglog", 6)}, 
TECH.SCIENCE_TWO, {atlas = "images/winged_saddle.xml", image = "winged_saddle.tex", no_deconstruction=true}, {"RIDING"})
STRINGS.NAMES.WINGED_SADDLE = zh_en("风之鞍具", "Winged Saddle")
STRINGS.RECIPE_DESC.WINGED_SADDLE = zh_en("采用最轻盈的材料制作而成，符合空气动力学的最快鞍具。", "Fastest aerodynamic saddle made from the lightest materials")

-- 暗影鞍具
-- 增加32攻击力(damage +32)，提供50%减伤，骑手饥饿值消耗*2.5
AddRecipe2("skeleton_saddle", {Ingredient("nightmarefuel", 32), Ingredient("slurper_pelt", 16),  Ingredient("boneshard", 8), Ingredient("minotaurhorn", 2)}, 
TECH.MAGIC_TWO, {atlas = "images/skeleton_saddle.xml", image = "skeleton_saddle.tex", no_deconstruction=true}, {"RIDING"})
STRINGS.NAMES.SKELETON_SADDLE = zh_en("暗影鞍具", "Shadow Saddle")
STRINGS.RECIPE_DESC.SKELETON_SADDLE = zh_en("禁忌的暗影工艺, 把你的宠物变成战争机器。", "Forbidden Shadowcraft, Turn your pet into a war machine")

-- 旭日鞍具
-- 增加45%移速(speed +45%)，增加10攻击力(damage +10)，减少乘骑所需顺重度5%，装备在生物身上时成为稳定热源
AddRecipe2("sun_saddle", {
	Ingredient("manrabbit_tail", 32), Ingredient("thulecite_pieces", 16),  Ingredient("livinglog", 4), 
	Ingredient("yellowgem", 2), Ingredient("saddle_basic", 1)
}, TECH.ANCIENT_FOUR, {atlas = "images/sun_saddle.xml", image = "sun_saddle.tex", no_deconstruction=true}, {"RIDING"})
STRINGS.NAMES.SUN_SADDLE = zh_en("旭日鞍具", "Sunburst Saddle")
STRINGS.RECIPE_DESC.SUN_SADDLE = zh_en("看起来很软很温暖的样子, 让人忍不住坐上去", "It looks so soft and warm that you can't help sitting on it")

-- 月光鞍具
-- 增加60%移速(speed +60%)，增加18攻击力(damage +18)，减少乘骑所需顺重度5%，装备在生物身上时成为稳定冷源和光源，提供25%减伤
AddRecipe2("lunar_saddle", {
	Ingredient("malbatross_feather", 32), Ingredient("moonglass", 16), Ingredient("moonrocknugget", 8), 
	Ingredient("walrus_tusk", 4), Ingredient("opalpreciousgem", 2)
}, TECH.CELESTIAL_THREE, {atlas = "images/lunar_saddle.xml", image = "lunar_saddle.tex", no_deconstruction=true}, {"RIDING"})
STRINGS.NAMES.LUNAR_SADDLE = zh_en("月光鞍具", "Lunar Saddle")
STRINGS.RECIPE_DESC.LUNAR_SADDLE = zh_en("这东西似乎在不停吸收生物的热能, 这些能量去哪了？", "This thing seems to be sucking up heat from living things. Where does that energy go?")


-- 装备特殊鞍具对生物的特殊效果
local function OnSaddleChanged(inst, data)
    if data.saddle ~= nil then
		if data.saddle.components.saddler.swapbuild == 'skeleton_saddle' then
			-- print("有生物装备了暗影鞍具，防御力提升50%")
			inst.components.health.externalabsorbmodifiers:SetModifier("skeleton_saddle", 0.5)
		end
		if data.saddle.components.saddler.swapbuild == 'lunar_saddle' then
			inst.components.health.externalabsorbmodifiers:SetModifier("lunar_saddle", 0.25)
			inst._lunar_saddle_fn = SpawnPrefab("lunar_saddle_fn")
			inst:AddChild(inst._lunar_saddle_fn)
		end
		if data.saddle.components.saddler.swapbuild == 'sun_saddle' then
			inst.components.health.externalabsorbmodifiers:SetModifier("lunar_saddle", 0.25)
			inst._sun_saddle_fn = SpawnPrefab("sun_saddle_fn")
			inst:AddChild(inst._sun_saddle_fn)
		end
	else
		inst.components.health.externalabsorbmodifiers:RemoveModifier("skeleton_saddle")
		inst.components.health.externalabsorbmodifiers:RemoveModifier("lunar_saddle")
		if inst._lunar_saddle_fn ~= nil then
			inst:RemoveChild(inst._lunar_saddle_fn)
		end
		if inst._sun_saddle_fn ~= nil then
			inst:RemoveChild(inst._sun_saddle_fn)
		end
    end
end

local function SpecialSaddleRideableAdapter(self)
	self.TestObedience = function (self)
		local bounsobedience = 0
		if self.saddle ~= nil then
			if self.saddle.components.saddler.swapbuild == 'lunar_saddle' or self.saddle.components.saddler.swapbuild == 'sun_saddle' then
				bounsobedience = 0.05
			end
		end
		return self.requiredobedience == nil
			or self.inst.components.domesticatable == nil
			or self.inst.components.domesticatable:GetObedience() >= self.requiredobedience - bounsobedience
	end
	self.inst:ListenForEvent("saddlechanged", OnSaddleChanged)
end

AddComponentPostInit("rideable", SpecialSaddleRideableAdapter)


-- 装备特殊鞍具骑行时对骑手的特殊效果
local function onMounted(inst, data)
	if data.target ~= nil and data.target.components.rideable.saddle ~= nil then
		local saddler = data.target.components.rideable.saddle.components.saddler
		if saddler.swapbuild == 'skeleton_saddle' then
			print("加速饥饿消耗")
			inst.components.hunger.burnratemodifiers:SetModifier("skeleton_saddle", 2.5)
		end
		if saddler.swapbuild == 'winged_saddle' and inst.components.temperature ~= nil then
			inst._winged_saddle_fn = true
		end
	end
end

local function onDismount(inst, data)
	inst.components.temperature:RemoveModifier("lunar_saddle")
	inst.components.temperature:RemoveModifier("sun_saddle")
	inst.components.hunger.burnratemodifiers:RemoveModifier("skeleton_saddle")
	if inst._winged_saddle_fn ~= nil then
		inst._winged_saddle_fn = false
	end
end

local function IsRiderRunning(inst)
	if inst.sg ~= nil then
		rider_running = inst.sg:HasStateTag("moving")
	else
		rider_running = inst:HasTag("moving")
	end
	if rider_running == true and inst._winged_saddle_fn == true and inst.components.temperature:GetCurrent() > 50 then
		inst.components.temperature:SetTemperature(inst.components.temperature:GetCurrent() - 3)
	end
end

local function SpecialSaddleRiderAdapter(self)
	self.inst:ListenForEvent("mounted", onMounted)
	self.inst:ListenForEvent("dismounted", onDismount)
	self.inst:DoPeriodicTask(1, IsRiderRunning)
end
AddComponentPostInit("rider", SpecialSaddleRiderAdapter)


-- 添加蔬菜杂烩功能：少量增加驯服度
AddPrefabPostInit("ratatouille", function(inst)
	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(
			function(inst, eater)
				if eater.components.domesticatable ~= nil then
					hungerValue = 1 - eater.components.hunger:GetPercent()
					eater.components.domesticatable:DeltaDomestication(0.01 * hungerValue * hungerValue)
				end
			end
		)
	end
end
)