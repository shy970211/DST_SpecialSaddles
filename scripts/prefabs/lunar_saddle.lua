local assets = 
{
	Asset("ANIM", "anim/lunar_saddle.zip"),
}

local function ondiscarded(inst)
    inst.components.finiteuses:Use()
end

local function onusedup(inst)
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function lunar_saddle()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("saddlebasic")
	inst.AnimState:SetBuild("lunar_saddle")
	inst.AnimState:PlayAnimation("idle")

	inst.mounted_foleysound = "dontstarve/beefalo/saddle/race_foley"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/lunar_saddle.xml"
    inst.components.inventoryitem.imagename = "lunar_saddle"

	inst:AddComponent("saddler")
	inst.components.saddler:SetBonusDamage(18)
	inst.components.saddler:SetBonusSpeedMult(1.6)
	inst.components.saddler:SetSwaps("lunar_saddle", "swap_saddle")
	inst.components.saddler:SetDiscardedCallback(ondiscarded)

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(3)
	inst.components.finiteuses:SetUses(3)
	inst.components.finiteuses:SetOnFinished(onusedup)

	inst:AddTag("combatmount")
	MakeHauntableLaunch(inst)

	return inst
end

local function lunar_saddle_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.6)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(64 / 255, 64 / 255, 208 / 255)
    inst.Light:Enable(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("HASHEATER")
	inst:AddComponent("heater")
	inst.components.heater.heat = 10
	inst.components.heater:SetThermics(false, true)

	inst.persists = false

    return inst
end

return Prefab("lunar_saddle", lunar_saddle, assets, { "lunar_saddle" })
	, Prefab("lunar_saddle_fn", lunar_saddle_fn)