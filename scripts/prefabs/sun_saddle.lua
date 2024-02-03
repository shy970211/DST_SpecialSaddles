local assets = 
{
	Asset("ANIM", "anim/sun_saddle.zip"),
}

local function ondiscarded(inst)
    inst.components.finiteuses:Use()
end

local function onusedup(inst)
    SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function sun_saddle()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("saddlebasic")
	inst.AnimState:SetBuild("sun_saddle")
	inst.AnimState:PlayAnimation("idle")

	inst.mounted_foleysound = "dontstarve/beefalo/saddle/race_foley"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/sun_saddle.xml"
    inst.components.inventoryitem.imagename = "sun_saddle"

	inst:AddComponent("saddler")
	inst.components.saddler:SetBonusDamage(10)
	inst.components.saddler:SetBonusSpeedMult(1.45)
	inst.components.saddler:SetSwaps("sun_saddle", "swap_saddle")
	inst.components.saddler:SetDiscardedCallback(ondiscarded)

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(3)
	inst.components.finiteuses:SetUses(3)
	inst.components.finiteuses:SetOnFinished(onusedup)

	inst:AddTag("combatmount")
	MakeHauntableLaunch(inst)

	return inst
end

local function sun_saddle_fn()
	local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("HASHEATER")
	inst:AddComponent("heater")
	inst.components.heater.heat = 30

	inst.persists = false
	return inst
end

return Prefab("sun_saddle", sun_saddle, assets)
	, Prefab("sun_saddle_fn", sun_saddle_fn)