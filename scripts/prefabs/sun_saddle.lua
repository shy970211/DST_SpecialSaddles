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

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("saddlebasic")
	inst.AnimState:SetBuild("sun_saddle")
	inst.AnimState:PlayAnimation("idle")
	
    inst.Light:SetFalloff(0.6)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(223/255, 208/255, 69/255)
    inst.Light:Enable(true)

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



	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("sun_saddle", fn, assets)