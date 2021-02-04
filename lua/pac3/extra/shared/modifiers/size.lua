local MIN, MAX = 0.1, 10

local ALLOW_TO_CHANGE = pacx.AddServerModifier("size", function(enable)
	if not enable then
		for _, ent in ipairs(ents.GetAll()) do
			if ent.pacx_size then
				pacx.SetEntitySizeMultiplier(ent)
			end
		end
	end

	-- we can also add a way to restore, but i don't think it's worth it
end)

local function change(ent, property, multiplier, default_override)
	if ent["Set" .. property] and ent["Get" .. property] then

		local default = ent.pacx_size_default_props

		if not default[property] then
			default[property] = default_override or ent["Get" .. property](ent)
		end

		ent["Set" .. property](ent, default[property] * multiplier)
	end
end

function pacx.SetEntitySizeMultiplier(ent, multiplier)
	if not multiplier then
		pacx.SetEntitySizeMultiplier(ent, 1)
		ent.pacx_size_default_props = nil
		return
	end

	multiplier = math.Clamp(multiplier, MIN, MAX)

	if multiplier == ent.pacx_size then return end

	ent.pacx_size = multiplier

	if CLIENT then
		if ent:EntIndex() > 0 then
			net.Start("pacx_size")
				net.WriteEntity(ent)
				net.WriteDouble(multiplier)
			net.SendToServer()
		end
	end

	ent.pacx_size_default_props = ent.pacx_size_default_props or {}
	local default = ent.pacx_size_default_props

	change(ent, "ViewOffset", multiplier)
	change(ent, "ViewOffsetDucked", multiplier)
	change(ent, "StepSize", multiplier)
	change(ent, "ModelScale", multiplier, 1)

	if ent.GetPhysicsObject then
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			if not default.Mass then
				default.Mass = phys:GetMass()
			end

			phys:SetMass(default.Mass * multiplier)
		end
	end

	if ent.SetHull and ent.GetHull then
		if not default.Hull then
			default.Hull = {ent:GetHull()}
		end

		local def = default.Hull
		ent:SetHull(def[1] * multiplier, def[2] * multiplier)
	end

	if ent.SetHullDuck and ent.GetHullDuck then
		if not default.HullDuck then
			default.HullDuck = {ent:GetHullDuck()}
		end

		local def = default.HullDuck
		ent:SetHullDuck(def[1] * multiplier, def[2] * multiplier)
	end
end

if SERVER then
	util.AddNetworkString("pacx_size")

	net.Receive("pacx_size", function(_, ply)
		if not ALLOW_TO_CHANGE:GetBool() then return end

		local ent = net.ReadEntity()

		if not pace.CanPlayerModify(ply, ent) then return end

		local multiplier = net.ReadDouble()

		pacx.SetEntitySizeMultiplier(ent, multiplier)
	end)
end