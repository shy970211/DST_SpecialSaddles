local assets = 
{
	Asset("ANIM", "anim/skeleton_saddle.zip"),
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
	inst.AnimState:SetBuild("skeleton_saddle")
	inst.AnimState:PlayAnimation("idle")

	inst.mounted_foleysound = "dontstarve/beefalo/saddle/race_foley"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/skeleton_saddle.xml"
    inst.components.inventoryitem.imagename = "skeleton_saddle"

	inst:AddComponent("saddler")
	inst.components.saddler:SetBonusDamage(32)
	inst.components.saddler:SetBonusSpeedMult(1)
	inst.components.saddler:SetSwaps("skeleton_saddle", "swap_saddle")
	inst.components.saddler:SetDiscardedCallback(ondiscarded)

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(2)
	inst.components.finiteuses:SetUses(2)
	inst.components.finiteuses:SetOnFinished(onusedup)

	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("skeleton_saddle", fn, assets)