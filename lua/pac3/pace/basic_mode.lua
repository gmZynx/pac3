pace.BasicParts = 
{
	model = true,
	light = true,
	sprite = true,
	bone = true,
}

pace.BasicProperties = 
{
	Position = true,
	Model = true,
	Angles = true,
	Size = true,
	ParentName = true,
	Alpha = true,
	Color = true,
	Skin = true,
	Material = true,
	Name = true,
	Description = true,
	Hide = true,
	SpritePath = true,
	Brightness = true,
	Bone = true,
}

local basic_mode = CreateConVar("pac_basic_mode", #table.Merge(table.Merge(file.Find("pac3/*", "DATA")), table.Merge(file.Find("pac3/sessions/*", "DATA"))) == 0 and "1" or "0" )

function pace.ToggleBasicMode()
	RunConsoleCommand("pac_basic_mode", basic_mode:GetBool() and "0" or "1")
	if pace.Editor and pace.Editor:IsValid() then
		pace.CloseEditor()
		timer.Simple(0.1, function()
			pace.OpenEditor()
		end)
	end
end

function pace.IsInBasicMode()
	return basic_mode:GetBool()
end