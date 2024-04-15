local MUTATOR = {}

MUTATOR.ClassName = "size"

function MUTATOR:WriteArguments(multiplier, other)
	net.WriteFloat(multiplier)
	if other then
		net.WriteBool(true)
		net.WriteFloat(other.StandingHullHeight)
		net.WriteFloat(other.CrouchingHullHeight)
		net.WriteFloat(other.HullWidth)
	else
		net.WriteBool(false)
	end

	if SERVER then
		local hidden_state = self.original_state[3]
		if hidden_state then
			net.WriteBool(true)
			net.WriteTable(hidden_state)
		else
			net.WriteBool(false)
		end
	else
		net.WriteBool(false)
	end
end

function MUTATOR:ReadArguments()
	local multiplier = math.Clamp(net.ReadFloat(), 0.5, 2)
	local other = false
	local hidden_state

	if net.ReadBool() then
		other = {}
		other.StandingHullHeight = net.ReadFloat()
		other.CrouchingHullHeight = net.ReadFloat()
		other.HullWidth = net.ReadFloat()
	end

	if net.ReadBool() then
		hidden_state = net.ReadTable()
	end

	return multiplier, other, hidden_state
end

function MUTATOR:StoreState()
	local ent = self.Entity

	return
		1, --ent:GetModelScale(),
		false, -- we will just ent:ResetHull()
		{
			ViewOffset = ent.GetViewOffset and ent:GetViewOffset() or nil,
			ViewOffsetDucked = ent.GetViewOffsetDucked and ent:GetViewOffsetDucked() or nil,
			StepSize = ent.GetStepSize and ent:GetStepSize() or nil,
		}
end

local functions = {
	"ViewOffset",
	"ViewOffsetDucked",
	"StepSize",
}

function MUTATOR:Mutate(multiplier, other, hidden_state)
	local ent = self.Entity

	if ent:GetModelScale() ~= multiplier then
		ent:SetModelScale(multiplier)
	end

	-- hmmm
	hidden_state = hidden_state or self.original_state[3]

	if hidden_state then
		for _, key in ipairs(functions) do
			local original = hidden_state[key]
			if original then
				local setter = ent["Set" .. key]

				if setter then
					setter(ent, original * multiplier)
				end
			end
		end
	end
end

pac.emut.Register(MUTATOR)