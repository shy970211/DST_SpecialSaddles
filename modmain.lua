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
-- 增加80%移速(speed +80%)
-- Ingredient("silk", 108), Ingredient("goose_feather", 56), Ingredient("livinglog", 2)}, TECH.SCIENCE_TWO,
AddRecipe2("winged_saddle", {Ingredient("silk", 108), Ingredient("goose_feather", 56), Ingredient("livinglog", 2)}, 
TECH.SCIENCE_TWO, {atlas = "images/winged_saddle.xml", image = "winged_saddle.tex", no_deconstruction=true}, {"RIDING"})

-- AddDeconstructRecipe("winged_saddle",	{Ingredient("goose_feather", 5)} )
STRINGS.NAMES.WINGED_SADDLE = zh_en("风之鞍具", "Winged Saddle")
STRINGS.RECIPE_DESC.WINGED_SADDLE = zh_en("采用最轻盈的材料制作而成，符合空气动力学的最快鞍具。", "Fastest aerodynamic saddle made from the lightest materials")


-- 暗影鞍具
-- 增加32攻击力(damage +32)，增加减伤50%，骑手饥饿值消耗*2.5
-- Ingredient("nightmarefuel", 32), Ingredient("slurper_pelt", 16),  Ingredient("boneshard", 8), Ingredient("minotaurhorn", 2)}, TECH.MAGIC_TWO,
AddRecipe2("skeleton_saddle", {Ingredient("nightmarefuel", 32), Ingredient("slurper_pelt", 16),  Ingredient("boneshard", 8), Ingredient("minotaurhorn", 2)}, 
TECH.MAGIC_TWO, {atlas = "images/skeleton_saddle.xml", image = "skeleton_saddle.tex", no_deconstruction=true}, {"RIDING"})

-- AddDeconstructRecipe("skeleton_saddle",	{Ingredient("minotaurhorn", 1)} )
STRINGS.NAMES.SKELETON_SADDLE = zh_en("暗影鞍具", "Shadow Saddle")
STRINGS.RECIPE_DESC.SKELETON_SADDLE = zh_en("禁忌的暗影工艺, 把你的宠物变成战争机器。", "Forbidden Shadowcraft, Turn your pet into a war machine")


-- 月光鞍具
-- 增加60%移速(speed +60%)，增加18攻击力(damage +18)，减少骑行所需顺重度5%，防止过热
-- Ingredient("malbatross_feather", 48), Ingredient("moonglass", 24), Ingredient("opalpreciousgem", 2), Ingredient("walrus_tusk", 4)}, TECH.CELESTIAL_ONE,
AddRecipe2("lunar_saddle", {Ingredient("malbatross_feather", 48), Ingredient("moonglass", 24), Ingredient("walrus_tusk", 4), Ingredient("opalpreciousgem", 2)}, 
TECH.CELESTIAL_THREE, {atlas = "images/lunar_saddle.xml", image = "lunar_saddle.tex", no_deconstruction=true}, {"RIDING"})

-- AddDeconstructRecipe("lunar_saddle",	{Ingredient("moonglass", 6)} )
STRINGS.NAMES.LUNAR_SADDLE = zh_en("月光鞍具", "Lunar Saddle")
STRINGS.RECIPE_DESC.LUNAR_SADDLE = zh_en("注入月光力量的超强力鞍具。我甚至有点嫉妒那只牛，威尔逊悄声说道。", "I'm even a little jealous of that cow, Wilson whispered")


-- 旭日鞍具
-- 增加45%移速(speed +45%)，增加10攻击力(damage +10)，减少骑行所需顺重度5%，防止过冷
-- Ingredient("manrabbit_tail", 32), Ingredient("thulecite_pieces", 16), Ingredient("redgem", 8), Ingredient("livinglog", 4)}, TECH.MAGIC_TWO,
AddRecipe2("sun_saddle", {Ingredient("manrabbit_tail", 32), Ingredient("thulecite_pieces", 16),  Ingredient("livinglog", 4), Ingredient("yellowgem", 2),}, 
TECH.ANCIENT_FOUR, {atlas = "images/sun_saddle.xml", image = "sun_saddle.tex", no_deconstruction=true}, {"RIDING"})

-- AddDeconstructRecipe("sun_saddle",	{Ingredient("manrabbit_tail", 8)} )
STRINGS.NAMES.SUN_SADDLE = zh_en("旭日鞍具", "Sunburst Saddle")
STRINGS.RECIPE_DESC.SUN_SADDLE = zh_en("太阳，温暖和力量", "sun, warmth and power")

-- TECH.NONE, TECH.SCIENCE_TWO, TECH.MAGIC_TWO, TECH.CELESTIAL_THREE, TECH.ANCIENT_FOUR,

-- 装备特殊鞍具对生物的特殊效果
local function OnSaddleChanged(inst, data)
    if data.saddle ~= nil then
		if data.saddle.components.saddler.swapbuild == 'skeleton_saddle' then
			-- inst.components.
			-- print("有生物装备了暗影鞍具，防御力提升50%")
			-- print(inst.components.health.externalabsorbmodifiers:Get())
			inst.components.health.externalabsorbmodifiers:SetModifier("skeleton_saddle", 0.5)
			-- print(inst.components.health.externalabsorbmodifiers:Get())
		end
	else
		inst.components.health.externalabsorbmodifiers:RemoveModifier("skeleton_saddle")
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
	local TEMP_WALL_Modifi = 20
	if data.target ~= nil then
		local saddler = data.target.components.rideable.saddle.components.saddler
		if saddler.swapbuild == 'lunar_saddle' and inst.components.temperature ~= nil then
			-- print("防止过热，启动")
			-- print(inst.components.temperature.maxtemp)
			inst.components.temperature.maxtemp = inst.components.temperature.maxtemp - TEMP_WALL_Modifi
		end
		if saddler.swapbuild == 'sun_saddle' and inst.components.temperature ~= nil then
			-- print("防止过冷，启动")
			-- print(inst.components.temperature.mintemp)
			inst.components.temperature.mintemp = inst.components.temperature.mintemp + TEMP_WALL_Modifi
		end
		if saddler.swapbuild == 'skeleton_saddle' and inst.components.temperature ~= nil then
			-- print("加速饥饿消耗")
			-- print(inst.components.hunger.hungerrate)
			inst.components.hunger.burnratemodifiers:SetModifier(saddler.inst, 2.5)
		end
	end
end


local function onDismount(inst, data)
	local TEMP_WALL_Modifi = 20
	if data.target ~= nil then
		local saddler = data.target.components.rideable.saddle.components.saddler
		if saddler.swapbuild == 'lunar_saddle' and inst.components.temperature ~= nil then
			-- print("防止过热，关闭")
			inst.components.temperature.maxtemp = inst.components.temperature.maxtemp + TEMP_WALL_Modifi
		end
		if saddler.swapbuild == 'sun_saddle' and inst.components.temperature ~= nil then
			-- print("防止过冷，关闭")
			inst.components.temperature.mintemp = inst.components.temperature.mintemp - TEMP_WALL_Modifi
		end
		if saddler.swapbuild == 'skeleton_saddle' and inst.components.temperature ~= nil then
			-- print("恢复饥饿消耗")
			inst.components.hunger.burnratemodifiers:RemoveModifier(saddler.inst)
		end
	end
end


local function SpecialSaddleRiderAdapter(self)
	self.inst:ListenForEvent("mounted", onMounted)
	self.inst:ListenForEvent("dismounted", onDismount)
end
AddComponentPostInit("rider", SpecialSaddleRiderAdapter)





-- 添加水果圣代功能：少量增加驯服度
AddPrefabPostInit("fruitmedley", function(inst)
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