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

local function fn()
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

	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("lunar_saddle", fn, assets)