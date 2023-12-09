include("parts.lua")
include("shortcuts.lua")

local pac_submit_spam = CreateConVar('pac_submit_spam', '1', CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE}, 'Prevent users from spamming pac_submit')
local pac_submit_limit = CreateConVar('pac_submit_limit', '30', CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE}, 'pac_submit spam limit')
local hitscan_allow = CreateConVar("pac_sv_hitscan", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow hitscan parts serverside")
local hitscan_max_bullets = CreateConVar("pac_sv_hitscan_max_bullets", "200", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "hitscan part maximum number of bullets")
local hitscan_max_damage = CreateConVar("pac_sv_hitscan_max_damage", "20000", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "hitscan part maximum damage")
local hitscan_spreadout_dmg = CreateConVar("pac_sv_hitscan_divide_max_damage_by_max_bullets", 0, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether or not force hitscans to divide their damage among the number of bullets fired")

local damagezone_allow = CreateConVar("pac_sv_damage_zone", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow damage zone parts serverside")
local damagezone_max_damage = CreateConVar("pac_sv_damage_zone_max_damage", "20000", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "damage zone maximum damage")
local damagezone_max_length = CreateConVar("pac_sv_damage_zone_max_length", "20000", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "damage zone maximum length")
local damagezone_max_radius = CreateConVar("pac_sv_damage_zone_max_radius", "10000", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "damage zone maximum radius")
local damagezone_allow_dissolve = CreateConVar("pac_sv_damage_zone_allow_dissolve", "1", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to enable entity dissolvers and removing NPCs\" weapons on death for damagezone")

local lock_allow = CreateConVar("pac_sv_lock", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow lock parts serverside")
local lock_allow_grab = CreateConVar("pac_sv_lock_grab", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow lock part grabs serverside")
local lock_allow_teleport = CreateConVar("pac_sv_lock_teleport", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow lock part teleports serverside")
local lock_max_radius = CreateConVar("pac_sv_lock_max_grab_radius", "200", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "lock part maximum grab radius")
local lock_allow_grab_ply = CreateConVar("pac_sv_lock_allow_grab_ply", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "allow grabbing players with lock part")
local lock_allow_grab_npc = CreateConVar("pac_sv_lock_allow_grab_npc", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "allow grabbing NPCs with lock part")
local lock_allow_grab_ent = CreateConVar("pac_sv_lock_allow_grab_ent", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "allow grabbing other entities with lock part")

local force_allow = CreateConVar("pac_sv_force", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow force parts serverside")
local force_max_length = CreateConVar("pac_sv_force_max_length", "10000", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "force part maximum length")
local force_max_radius = CreateConVar("pac_sv_force_max_radius", "10000", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "force part maximum radius")
local force_max_amount = CreateConVar("pac_sv_force_max_amount", "10000", CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "force part maximum amount of force")

local healthmod_allow = CreateConVar("pac_sv_health_modifier", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow health modifier parts serverside")
local healthmod_allowed_extra_bars = CreateConVar("pac_sv_health_modifier_extra_bars", 1, CLIENT and {FCVAR_NOTIFY, FCVAR_REPLICATED} or {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow extra health bars")
local healthmod_allow_change_maxhp = CreateConVar("pac_sv_health_modifier_allow_maxhp", 1, CLIENT and {FCVAR_NOTIFY, FCVAR_REPLICATED} or {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Allow players to change their maximum health and armor.")
local healthmod_minimum_dmgscaling = CreateConVar("pac_sv_health_modifier_min_damagescaling", -1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Minimum health modifier amount. Negative values can heal.")

local master_init_featureblocker = CreateConVar("pac_sv_block_combat_features_on_next_restart", 0, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to stop initializing the net receivers for the networking of PAC3 combat parts those selectively disabled. This requires a restart!\n0=initialize all the receivers\n1=disable those whose corresponding part cvar is disabled\n2=block all combat features\nAfter updating the sv cvars, you can still reinitialize the net receivers with pac_sv_combat_reinitialize_missing_receivers, but you cannot turn them off after they are turned on")

local enforce_netrate = CreateConVar("pac_sv_combat_enforce_netrate", 0, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "whether to enforce a limit on how often any pac combat net messages can be sent. 0 to disable, otherwise a number in mililiseconds.\nSee the related cvar pac_sv_combat_enforce_netrate_buffersize. That second convar is governed by this one, if the netrate enforcement is 0, the allowance doesn\"t matter")
local netrate_allowance = CreateConVar("pac_sv_combat_enforce_netrate_buffersize", 60, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "the budgeted allowance to limit how many pac combat net messages can be sent in bursts. 0 to disable, otherwise a number of net messages of allowance.")
local netrate_enforcement_sv_monitoring = CreateConVar("pac_sv_combat_enforce_netrate_monitor_serverside", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether or not to let clients enforce their net message rates.\nSet this to 1 to get serverside prints telling you whenever someone is going over their allowance, but it'll still take the network bandwidth.\nSet this to 0 to let clients enforce their net rate and save some bandwidth but the server won't know who's spamming net messages.")
local raw_ent_limit = CreateConVar("pac_sv_entity_limit_per_combat_operation", 500, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Hard limit to drop any force or damage zone if more than this amount of entities is selected")
local per_ply_limit = CreateConVar("pac_sv_entity_limit_per_player_per_combat_operation", 40, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Limit per player to drop any force or damage zone if this amount multiplied by each client is more than the hard limit")
local player_fraction = CreateConVar("pac_sv_player_limit_as_fraction_to_drop_damage_zone", 1, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The fraction (0.0-1.0) of players that will stop damage zone net messages if a damage zone order covers more than this fraction of the server's population, when there are more than 12 players covered")
local enforce_distance = CreateConVar("pac_sv_combat_distance_enforced", 0, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether to enforce a limit on how far a pac combat action can originate.\nIf set to a distance, it will prevent actions that are too far from the acting player.\n0 to disable.")


local global_combat_whitelisting = CreateConVar("pac_sv_combat_whitelisting", 0, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How the server should decide which players are allowed to use the main PAC3 combat parts (lock, damagezone, force).\n0:Everyone is allowed unless the parts are disabled serverwide\n1:No one is allowed until they get verified as trustworthy\tpac_sv_whitelist_combat <playername>\n\tpac_sv_blacklist_combat <playername>")
local global_combat_prop_protection = CreateConVar("pac_sv_prop_protection", 0, CLIENT and {FCVAR_REPLICATED} or {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether players owned (created) entities (physics props and gmod contraption entities) will be considered in the consent calculations, protecting them. Without this cvar, only the player is protected.")


--include("pac3/editor/server/combat_bans.lua")


pace = pace

pace.partmenu_categories_experimental = {
	["new!"] =
	{
		["icon"]				=		"icon16/new.png",
		["interpolated_multibone"] =	"interpolated_multibone",
		["damage_zone"]			=	"damage_zone",
		["hitscan"]				=	"hitscan",
		["lock"]				=		"lock",
		["force"]				=		"force",
		["health_modifier"]		=		"health_modifier",
	},
	["logic"] =
	{
		["icon"]				=		"icon16/server_chart.png",
		["proxy"]				=	"proxy",
		["command"]				=	"command",
		["event"]				=		"event",
		["text"]				=		"text",
		["link"]				=		"link",
	},
	["scaffolds"] =
	{
		["tooltip"]				=	"useful to build up structures with specific positioning rules",
		["icon"]				=		"map",
		["jiggle"]				=	"jiggle",
		["model2"]				=	"model2",
		["projectile"]			=	"projectile",
		["interpolated_multibone"] =	"interpolated_multibone",
	},
	["combat"] =
	{
		["icon"]				=		"icon16/joystick.png",
		["damage_zone"]			=	"damage_zone",
		["hitscan"]				=	"hitscan",
		["projectile"]			=	"projectile",
		["lock"]				=		"lock",
		["force"]				=		"force",
		["health_modifier"]		=		"health_modifier",
		["player_movement"]		=	"player_movement",
	},
	["animation"]=
	{
		["icon"]				=		"icon16/world.png",
		["group"]				=		"group",
		["event"]				=		"event",
		["custom_animation"]	=		"custom_animation",
		["proxy"]				=		"proxy",
		["sprite"]				=	"sprite",
		["particle"]			=		"particle",
	},
	["materials"] =
	{
		["icon"]				=		"pace.MiscIcons.appearance",
		["material_3d"]			=	"material_3d",
		["material_2d"]			=	"material_2d",
		["material_refract"]	=		"material_refract",
		["material_eye refract"] =		"material_eye refract",
		["submaterial"]			=	"submaterial",
	},
	["entity"] =
	{
		["icon"]				=		"icon16/cd_go.png",
		["bone3"]				=		"bone3",
		["custom_animation"]	=		"custom_animation",
		["gesture"]				=	"gesture",
		["entity2"]				=	"entity2",
		["poseparameter"]		=		"poseparameter",
		["camera"]				=	"camera",
		["holdtype"]		=			"holdtype",
		["effect"]				=	"effect",
		["player_config"]		=		"player_config",
		["player_movement"]	=		"player_movement",
		["animation"]		=			"animation",
		["submaterial"]		=		"submaterial",
		["faceposer"]		=			"faceposer",
		["flex"]			=			"flex",
		["material_3d"]		=		"material_3d",
		["weapon"]			=		"weapon",
	},
	["model"] =
	{
		["icon"]			=			"icon16/bricks.png",
		["jiggle"]			=		"jiggle",
		["physics"]			=		"physics",
		["animation"]		=		"animation",
		["bone3"]			=			"bone3",
		["effect"]			=		"effect",
		["submaterial"]		=		"submaterial",
		["clip2"]			=			"clip2",
		["halo"]			=			"halo",
		["material_3d"]		=		"material_3d",
		["model2"]			=		"model2",
	},
	["modifiers"] =
	{
		["icon"]			=			"icon16/connect.png",
		["fog"]				=		"fog",
		["motion_blur"]		=		"motion_blur",
		["halo"]			=			"halo",
		["clip2"]			=			"clip2",
		["bone3"]			=			"bone3",
		["poseparameter"]	=			"poseparameter",
		["material_3d"]	=			"material_3d",
		["proxy"]=						"proxy",
	},
	["effects"] =
	{
		["icon"]	=					"icon16/wand.png",
		["sprite"]	=				"sprite",
		["sound2"]	=				"sound2",
		["effect"]	=				"effect",
		["halo"]	=					"halo",
		["particles"]=					"particles",
		["sunbeams"]=					"sunbeams",
		["beam"]=						"beam",
		["projected_texture"]=		"projected_texture",
		["decal"]=					"decal",
		["text"]=					"text",
		["trail2"]=				"trail2",
		["sound"]=						"sound",
		["woohoo"]=					"woohoo",
		["light2"]=					"light2",
		["shake"]=						"shake",
	}
}

pace.partmenu_categories_default =
{
	["legacy"]=
	{
		["icon"]				=		pace.GroupsIcons.legacy,
		["trail"]=		"trail",
		["bone2"]=		"bone2",
		["model"]=		"model",
		["bodygroup"]=		"bodygroup",
		["material"]=		"material",
		["light"]=		"light",
		["entity"]=		"entity",
		["clip"]=		"clip",
		["bone"]=		"bone",
		["webaudio"]=		"webaudio",
		["ogg"]	=	"ogg",
	},
	["combat"]=
	{
		["icon"]				=		pace.GroupsIcons.combat,
		["lock"]=		"lock",
		["force"]=		"force",
		["projectile"]=		"projectile",
		["damage_zone"]	=	"damage_zone",
		["hitscan"]	=	"hitscan",
		["health_modifier"]	=	"health_modifier",
	},
	["advanced"]=
	{
		["icon"]				=		pace.GroupsIcons.advanced,
		["custom_animation"]=		"custom_animation",
		["material_refract"]=		"material_refract",
		["projectile"]=		"projectile",
		["link"]	=	"link",
		["material_2d"]	=	"material_2d",
		["material_eye refract"]	=	"material_eye refract",
		["command"]		="command",
	},
	["entity"]=
	{
		["icon"]				=		pace.GroupsIcons.entity,
		["bone3"]	=	"bone3",
		["gesture"]	=	"gesture",
		["entity2"]		="entity2",
		["poseparameter"]	=	"poseparameter",
		["camera"]	=	"camera",
		["holdtype"]=		"holdtype",
		["effect"]	=	"effect",
		["player_config"]	=	"player_config",
		["player_movement"]	=	"player_movement",
		["animation"]	=	"animation",
		["submaterial"]	=	"submaterial",
		["faceposer"]	=	"faceposer",
		["flex"]	=	"flex",
		["material_3d"]	=	"material_3d",
		["weapon"]=		"weapon",
	},
	["model"]=
	{
		["icon"]				=		pace.GroupsIcons.model,
		["jiggle"]	=	"jiggle",
		["physics"]	=	"physics",
		["animation"]=		"animation",
		["bone3"]	=	"bone3",
		["effect"]	=	"effect",
		["submaterial"]		="submaterial",
		["clip2"]	=	"clip2",
		["halo"]	=	"halo",
		["material_3d"]	=	"material_3d",
		["model2"]=		"model2",
	},
	["modifiers"]=
	{
		["icon"]				=		pace.GroupsIcons.modifiers,
		["animation"]	=	"animation",
		["fog"]	=	"fog",
		["motion_blur"]	=	"motion_blur",
		["clip2"]=		"clip2",
		["poseparameter"]	=	"poseparameter",
		["material_3d"]	=	"material_3d",
		["proxy"]	=	"proxy",
	},
	["effects"]=
	{
		["icon"]				=		pace.GroupsIcons.effects,
		["sprite"]	=	"sprite",
		["sound2"]	=	"sound2",
		["effect"]	=	"effect",
		["halo"]	=	"halo",
		["particles"]=		"particles",
		["sunbeams"]	=	"sunbeams",
		["beam"]	=	"beam",
		["projected_texture"]=		"projected_texture",
		["decal"]	=	"decal",
		["text"]	=	"text",
		["trail2"]	=	"trail2",
		["sound"]	=	"sound",
		["woohoo"]	=	"woohoo",
		["light2"]	=	"light2",
		["shake"]	=	"shake"
	}
}


local function rebuild_bookmarks()
	pace.bookmarked_ressources = pace.bookmarked_ressources or {}

	--here's some default favorites
	if not pace.bookmarked_ressources["models"] or table.IsEmpty(pace.bookmarked_ressources["models"]) then
		pace.bookmarked_ressources["models"] = {
			"models/pac/default.mdl",
			"models/pac/plane.mdl",
			"models/pac/circle.mdl",
			"models/hunter/blocks/cube025x025x025.mdl",
			"models/editor/axis_helper.mdl",
			"models/editor/axis_helper_thick.mdl"
		}
	end

	if not pace.bookmarked_ressources["sound"] or table.IsEmpty(pace.bookmarked_ressources["sound"]) then
		pace.bookmarked_ressources["sound"] = {
			"music/hl1_song11.mp3",
			"npc/combine_gunship/dropship_engine_near_loop1.wav",
			"ambient/alarms/warningbell1.wav",
			"phx/epicmetal_hard7.wav",
			"phx/explode02.wav"
		}
	end

	if not pace.bookmarked_ressources["materials"] or table.IsEmpty(pace.bookmarked_ressources["materials"]) then
		pace.bookmarked_ressources["materials"] = {
			"models/debug/debugwhite",
			"vgui/null",
			"debug/env_cubemap_model",
			"models/wireframe",
			"cable/physbeam",
			"cable/cable2",
			"effects/tool_tracer",
			"effects/flashlight/logo",
			"particles/flamelet[1,5]",
			"sprites/key_[0,9]",
			"vgui/spawnmenu/generating",
			"vgui/spawnmenu/hover"
		}
	end

	if not pace.bookmarked_ressources["proxy"] or table.IsEmpty(pace.bookmarked_ressources["proxy"]) then
		pace.bookmarked_ressources["proxy"] = {
			--[[["user"] = {

			},]]
			["fades and transitions"] ={
				{
					nicename = "standard clamp fade (in)",
					expression = "clamp(timeex(),0,1)",
					explanation = "the simplest fade.\nthis is normalized, which means you'll often multiply this whole unit by the amount you want, like a distance.\ntimeex() starts at 0, moves gradually to 1 and stops progressing at 1 due to the clamp"
				},
				{
					nicename = "standard clamp fade (out)",
					expression = "clamp(1 - timeex(),0,1)",
					explanation = "the simplest fade's reverse.\nthis is normalized, which means you'll often multiply this whole unit by the amount you want, like a distance.\ntimeex() starts at 1, moves gradually to 0 and stops progressing at 0 due to the clamp"
				},
				{
					nicename = "standard clamp fade (delayed in)",
					expression = "clamp(-1 + timeex(),0,1)",
					explanation = "the basic fade is delayed by the fact that the clamp makes sure the negative values are pulled back to 0 until the first argument crosses 0 into the clamp's range."
				},
				{
					nicename = "standard clamp fade (delayed out)",
					expression = "clamp(2 - timeex(),0,1)",
					explanation = "the reverse fade is delayed by the fact that the clamp makes sure the values beyond 1 are pulled back to 1 until the first argument crosses 1 into the clamp's range."
				},
				{
					nicename = "standard clamp fade (in and out)",
					expression = "clamp(timeex(),0,1)*clamp(3 - timeex(),0,1)",
					explanation = "this is just compounding both fades. the second clamp's 3 is comprised of 1 (the clamp max) + 1 (the delay BEFORE the fade) + 1 (the delay BETWEEN the fades)"
				},
				{
					nicename = "quick ease setup",
					expression = "easeInBack(clamp(timeex(),0,1))",
					explanation = "get started quickly with the new easing functions.\nsearch \"ease\" in the proxy's input list to see how to write them in pac3, or look at the gmod wiki to see previews of each"
				},
			},
			["pulses"] = {
				{
					nicename = "bell pulse",
					expression = "(0 + 1*sin(PI*timeex())^16)",
					explanation = "a basic normalized pulse, using a sine power."
				},
				{
					nicename = "square-like throb",
					expression = "(0 + 1 * (cos(PI*timeex())^16) ^0.3)",
					explanation = "a throbbing-like pulse, made by combining a sine power with a fractionnal power.\nthis is better explained visually, so either test it right here in game or go look at a graph to see how x, and cos or sin behave with powers.\ntry x^pow and sin(x)^pow, and try different pows"
				},
				{
					nicename = "binary pulse",
					expression = "floor(1 + sin(PI*timeex()))",
					explanation = "an on-off pulse, in other words a square wave.\nthis one completes one cycle every 2 seconds.\nfloor rounds down between 1 and 0 with nothing in-between."
				},
				{
					nicename = "saw wave (up)",
					expression = "(timeex()%1)",
					explanation = "a sawtooth wave. it can repeat a 0-1 transition."
				},
				{
					nicename = "saw wave (down)",
					expression = "(1 - timeex()%1)",
					explanation = "a sawtooth wave. it can repeat a 1-0 transition."
				},
				{
					nicename = "triangle wave",
					expression = "(clamp(-1+timeex()%2,0,1) + clamp(1 - timeex()%2,0,1))",
					explanation = "a triangle wave. it goes back and forth linearly like a saw up and down."
				}
			},
			["facial expressions"] = {
				{
					nicename = "normal slow blink",
					expression = "3*clamp(sin(timeex())^100,0,1)",
					explanation = "a normal slow blink.\nwhile flexes usually have a range of 0-1, the 3 outside of the clamp is there to trick the value into going faster in case they're too slow to reach their target"
				},
				{
					nicename = "normal fast blink",
					expression = "8*clamp(sin(timeex())^600,0,1)",
					explanation = "a normal slow blink.\nwhile flexes usually have a range of 0-1, the 8 outside of the clamp is there to trick the value into going faster in case they're too slow to reach their target\nif it's still not enough, use another flex with less blinking amount to provide the additionnal distance for the blink"
				},
				{
					nicename = "babble",
					expression = "sin(12*timeex())^2",
					explanation = "a basic piece to move the mouth semi-convincingly for voicelines.\nthere'll never be dynamic lipsync in pac3, but this is a start."
				},
				{
					nicename = "voice smoothener",
					expression = "clamp(feedback() + 70*voice_volume()*ftime() - 15*ftime(),0,2)",
					explanation = "uses a feedback() setup to raise the mouth's value gradually against a constantly lowering value, which should be more smoothly than a direct input"
				},
				{
					nicename = "look side (legacy symmetrical look)",
					expression = "3*(-1 + 2*pose_parameter(\"head_yaw\"))",
					explanation = "an expression to mimic the head's yaw"
				},
				{
					nicename = "look side (new)",
					expression = "pose_parameter_true(\"head_yaw\")",
					explanation = "an expression to mimic the head's yaw, but it requires your model to have this standard pose parameter"
				},
				{
					nicename = "look up",
					expression = "(-1 + 2*owner_eye_angle_pitch())",
					explanation = "an expression to mimic the head's pitch on a [-1,1] range"
				},
				{
					nicename = "single eyeflex direction (up)",
					expression = "-0.03*pose_parameter_true(\"head_pitch\")",
					explanation = "plug into an eye_look_up flex or an eye bone with a higher multiplier"
				},
				{
					nicename = "single eyeflex direction (down)",
					expression = "0.03*pose_parameter_true(\"head_pitch\")",
					explanation = "plug into an eye_look_down flex or an eye bone with a higher multiplier"
				},
				{
					nicename = "single eyeflex direction (left)",
					expression = "0.03*pose_parameter_true(\"head_yaw\")",
					explanation = "plug into an eye_look_left flex or an eye bone with a higher multiplier"
				},
				{
					nicename = "single eyeflex direction (right)",
					expression = "-0.03*pose_parameter_true(\"head_yaw\")",
					explanation = "plug into an eye_look_right flex or an eye bone with a higher multiplier"
				},
			},
			["spatial"] = {
				{
					nicename = "random position (cloud)",
					expression = "150*random(-1,1),150*random(-1,1),150*random(-1,1)",
					explanation = "position a part randomly across X,Y,Z\nbut constantly blinking everywhere, because random generates a new number every frame.\nyou should only use this for parts that emit things into the world"
				},
				{
					nicename = "random position (once)",
					expression = "150*random_once(0,-1,1),150*random_once(1,-1,1),150*random_once(2,-1,1)",
					explanation = "position a part randomly across X,Y,Z\nbut once, because random_once only generates a number once.\nit, however, needs distinct numbers in the first arguments to distinguish them every time you write the function."
				},
				{
					nicename = "distance-based fade",
					expression = "clamp((250/500) + 1 - (eye_position_distance() / 500),0,1)",
					explanation = "a fading based on the viewer's distance. 250 and 500 are the example distances, 250 is where the expression starts diminishing, and 750 is where we reach 0."
				},
				{
					nicename = "distance between two points",
					expression = "part_distance(uid1,uid2)",
					explanation = "Trick question! You have some homework! You need to find out your parts' UIDs first.\ntry tools -> copy global id, then paste those in place of uid1 and uid2"
				},
				{
					nicename = "revolution (orbit)",
					expression = "150*sin(time()),150*cos(time()),0",
					explanation = "Trick question! You might need to rearrange the expression depending on which coordinate system we're at. For a thing on a pos_noang bone, it works as is. But for something on your head, you would need to swap x and z\n0,150*cos(time()),150*sin(time())"
				},
				{
					nicename = "spin",
					expression = "0,360*time(),0",
					explanation = "a simple spinner on Y"
				}
			},
			["experimental things"] = {
				{
					nicename = "control a boolean directly with an event",
					expression = "event_alternative(uid1,0,1)",
					explanation = "trick question! you need to find out your event's part UID first and substitute uid1\n"
				},
				{
					nicename = "feedback system controlled with 2 events",
					expression = "feedback() + ftime()*(event_alternative(uid1,0,1) + event_alternative(uid2,0,-1))",
					explanation = "trick question! you need to find out your event parts' UIDs first and substitute uid1 and uid2.\nthe new event_alternative function gets an event's state\nwe can inject that into our feedback system to act as a positive or negative speed"
				},
				{
					nicename = "basic if-else statement",
					expression = "number_operator_alternative(1,\">\",0,100,50)",
					explanation = "might be niche but here's a basic alternator thing, you can compare the 1st and 3rd args with numeric operators like \"above\", \"<\", \"=\", \"~=\" etc. to choose between the 4th and 5th args\nit goes like this\nnumber_operator_alternative(1,\">\",0,100,50)\nif 1>0, return 100, else return 50"
				},
				{
					nicename = "pick from 3 random colors",
					expression = "number_operator_alternative(random_once(1), \"<\", 0.333, 1, number_operator_alternative(random_once(1), \">\", 0.666, 1.0, 0.75)),number_operator_alternative(random_once(1), \"<\", 0.333, 1, number_operator_alternative(random_once(1), \">\", 0.666, 0.8, 0.65)),number_operator_alternative(random_once(1), \"<\", 0.333, 1, number_operator_alternative(random_once(1), \">\", 0.666, 1.0, 0.58))",
					explanation =
						"using a shared random source, you can nest number_operator_alternative functions to get a 3-way branching random choice\n0.333 and 0.666 correspond to the chance slices where each choice gets decided so you can change the probabilities by editing these numbers\nBecause of the fact we're going deep, it's not easily readable so I'll lay out each component.\n\n" ..
						"R:  number_operator_alternative(random_once(1), \"<\", 0.333, 1, number_operator_alternative(random_once(1), \">\", 0.666, 1.0, 0.75))\n"..
						"G:  number_operator_alternative(random_once(1), \"<\", 0.333, 1, number_operator_alternative(random_once(1), \">\", 0.666, 0.8, 0.65))\n"..
						"B:  number_operator_alternative(random_once(1), \"<\", 0.333, 1, number_operator_alternative(random_once(1), \">\", 0.666, 1.0, 0.58))\n\n"..
						"The first choice is white (1,1,1), the second choice is light pink (1,0.8,1) like a strawberry milk, the third choice is light creamy brown (0.75,0.65,0.58) like chocolate milk"
				},
				{
					nicename = "feedback command attractor",
					expression = "feedback() + ftime()*(command(\"destination\") - feedback())",
					explanation =
						"This thing uses a principle of iteration similar to exponential functions to attract the feedback toward any target\n"..
						"The delta bit will get smaller and smaller as the gap between destination and feedback closes, stabilizing at 0, thereby stopping.\n"..
						"You will utilize pac_proxy commands to set the destination target: \"pac_proxy destination 2\" will make the expression tend toward 2."
				}
			}
		}

	end

end

local PANEL = {}

local player_ban_list = {}
local player_combat_ban_list = {}

local function encode_table_to_file(str)
	local data = {}
	if not file.Exists("pac3_config", "DATA") then
		file.CreateDir("pac3_config")

	end


	if str == "pac_editor_shortcuts" then
		data = pace.PACActionShortcut
		file.Write("pac3_config/" .. str..".txt", util.TableToKeyValues(data))
	elseif str == "pac_editor_partmenu_layouts" then
		data = pace.operations_order
		file.Write("pac3_config/" .. str..".txt", util.TableToJSON(data))
	elseif str == "pac_part_categories" then
		data = pace.partgroups
		file.Write("pac3_config/" .. str..".txt", util.TableToKeyValues(data))
	elseif str == "bookmarked_ressources" then
		rebuild_bookmarks()
		for category, tbl in pairs(pace.bookmarked_ressources) do
			data = tbl
			str = category
			file.Write("pac3_config/bookmarked_" .. str..".txt", util.TableToKeyValues(data))
		end
	elseif str == "eventwheel_colors" then
		data = pace.command_colors or {}
		file.Write("pac3_config/" .. str..".txt", util.TableToKeyValues(data))
	end

end

local function decode_table_from_file(str)
	if str == "bookmarked_ressources" then
		rebuild_bookmarks()
		local ressource_types = {"models", "sound", "materials", "sprites"}
		for _, category in pairs(ressource_types) do
			data = file.Read("pac3_config/bookmarked_" .. category ..".txt", "DATA")
			if data then pace.bookmarked_ressources[category] = util.KeyValuesToTable(data) end
		end
		return
	end

	local data = file.Read("pac3_config/" .. str..".txt", "DATA")
	if not data then return end

	if str == "pac_editor_shortcuts" then
		pace.PACActionShortcut = util.KeyValuesToTable(data)

	elseif str == "pac_editor_partmenu_layouts" then
		pace.operations_order = util.JSONToTable(data)

	elseif str == "pac_part_categories" then
		pace.partgroups = util.KeyValuesToTable(data)

	elseif str == "eventwheel_colors" then
		pace.command_colors = util.KeyValuesToTable(data)
	end


end

decode_table_from_file("bookmarked_ressources")
pace.bookmarked_ressources = pace.bookmarked_ressources or {}

function pace.SaveRessourceBookmarks()
	encode_table_to_file("bookmarked_ressources")
end

function PANEL:Init()
	local master_pnl = vgui.Create("DPropertySheet", self)
	master_pnl:Dock(FILL)

	local properties_filter = pace.FillWearSettings(master_pnl)
	master_pnl:AddSheet("Wear / Ignore", properties_filter)

	local editor_settings = pace.FillEditorSettings(master_pnl)
	master_pnl:AddSheet("Editor menu Settings", editor_settings)

	local editor_settings2 = pace.FillEditorSettings2(master_pnl)
	master_pnl:AddSheet("Editor menu Settings 2", editor_settings2)


	if game.SinglePlayer() or LocalPlayer():IsAdmin() then

		local general_sv_settings = pace.FillServerSettings(master_pnl)
		master_pnl:AddSheet("General Settings (SV)", general_sv_settings)

		local combat_sv_settings = pace.FillCombatSettings(master_pnl)
		master_pnl:AddSheet("Combat Settings (SV)", combat_sv_settings)

		local ban_settings = pace.FillBanPanel(master_pnl)
		master_pnl:AddSheet("Bans (SV)", ban_settings)

		local combat_ban_settings = pace.FillCombatBanPanel(master_pnl)
		master_pnl:AddSheet("Combat Bans (SV)", combat_ban_settings)

	end


	self.sheet = master_pnl

	--local properties_shortcuts = pace.FillShortcutSettings(pnl)
	--pnl:AddSheet("Editor Shortcuts", properties_shortcuts)
end

vgui.Register( "pace_settings", PANEL, "DPanel" )

function pace.OpenSettings()
	if IsValid(pace.settings_panel) then
		pace.settings_panel:Remove()
	end
	local pnl = vgui.Create("DFrame")
	pnl:SetTitle("pac settings")
	pace.settings_panel = pnl
	pnl:SetSize(800,600)
	pnl:MakePopup()
	pnl:Center()
	pnl:SetSizable(true)

	local pnl = vgui.Create("pace_settings", pnl)
	pnl:Dock(FILL)
end

concommand.Add("pace_settings", function()
	pace.OpenSettings()
end)


function pace.FillBanPanel(pnl)
	local pnl = pnl
	local BAN = vgui.Create("DPanel", pnl)
	local ply_state_list = player_ban_list or {}

	local ban_list = vgui.Create("DListView", BAN)
		ban_list:SetText("ban list")
		ban_list:SetSize(400,400)
		ban_list:SetPos(10,10)

		ban_list:AddColumn("Player name")
		ban_list:AddColumn("SteamID")
		ban_list:AddColumn("State")
		ban_list:SetSortable(false)
		for _,ply in pairs(player.GetAll()) do
			--print(ply, pace.IsBanned(ply))
			ban_list:AddLine(ply:Name(),ply:SteamID(),player_ban_list[ply] or "Allowed")
		end

		function ban_list:DoDoubleClick( lineID, line )
			--MsgN( "Line " .. lineID .. " was double clicked!" )
			local state = line:GetColumnText( 3 )

			if state == "Banned" then state = "Allowed"
			elseif state == "Allowed" then state = "Banned" end
			line:SetColumnText(3,state)
			ply_state_list[player.GetBySteamID(line:GetColumnText( 2 ))] = state
			PrintTable(ply_state_list)
		end

	local ban_confirm_list_button = vgui.Create("DButton", BAN)
		ban_confirm_list_button:SetText("Send ban list update to server")

		ban_confirm_list_button:SetTooltip("WARNING! Unauthorized use will be notified to the server!")
		ban_confirm_list_button:SetColor(Color(255,0,0))
		ban_confirm_list_button:SetSize(200, 40)
		ban_confirm_list_button:SetPos(450, 10)
		function ban_confirm_list_button:DoClick()
			net.Start("pac.BanUpdate")
			net.WriteTable(ply_state_list)
			net.SendToServer()
		end
	local ban_request_list_button = vgui.Create("DButton", BAN)
		ban_request_list_button:SetText("Request ban list from server")
		--ban_request_list_button:SetColor(Color(255,0,0))
		ban_request_list_button:SetSize(200, 40)
		ban_request_list_button:SetPos(450, 60)

		function ban_request_list_button:DoClick()
			net.Start("pac.RequestBanStates")
			net.SendToServer()
		end

		net.Receive("pac.SendBanStates", function()
			local players = net.ReadTable()
			player_ban_list = players
			PrintTable(players)
		end)


	return BAN
end

function pace.FillCombatBanPanel(pnl)
	local pnl = pnl
	local BAN = vgui.Create("DPanel", pnl)
	pac.global_combat_whitelist = pac.global_combat_whitelist or {}


	local ban_list = vgui.Create("DListView", BAN)
		ban_list:SetText("Combat ban list")
		ban_list:SetSize(400,400)
		ban_list:SetPos(10,10)

		ban_list:AddColumn("Player name")
		ban_list:AddColumn("SteamID")
		ban_list:AddColumn("State")
		ban_list:SetSortable(false)
		if GetConVar('pac_sv_combat_whitelisting'):GetBool() then
			ban_list:SetTooltip( "Whitelist mode: Default players aren't allowed to use the combat features until set to Allowed" )
		else
			ban_list:SetTooltip( "Blacklist mode: Default players are allowed to use the combat features" )
		end

		local combat_bans_temp_merger = {}

		for _,ply in pairs(player.GetAll()) do
			combat_bans_temp_merger[ply:SteamID()] = pac.global_combat_whitelist[ply:SteamID()]-- or {nick = ply:Nick(), steamid = ply:SteamID(), permission = "Default"}
		end

		for id,data in pairs(pac.global_combat_whitelist) do
			combat_bans_temp_merger[id] = data
		end

		for id,data in pairs(combat_bans_temp_merger) do
			ban_list:AddLine(data.nick,data.steamid,data.permission)
		end

		function ban_list:DoDoubleClick( lineID, line )
			--MsgN( "Line " .. lineID .. " was double clicked!" )
			local state = line:GetColumnText( 3 )

			if state == "Banned" then state = "Default"
			elseif state == "Default" then state = "Allowed"
			elseif state == "Allowed" then state = "Banned" end
			line:SetColumnText(3,state)
			pac.global_combat_whitelist[string.lower(line:GetColumnText( 2 ))].permission = state
			PrintTable(pac.global_combat_whitelist)
		end

	local ban_confirm_list_button = vgui.Create("DButton", BAN)
		ban_confirm_list_button:SetText("Send combat ban list update to server")

		ban_confirm_list_button:SetTooltip("WARNING! Unauthorized use will be notified to the server!")
		ban_confirm_list_button:SetColor(Color(255,0,0))
		ban_confirm_list_button:SetSize(200, 40)
		ban_confirm_list_button:SetPos(450, 10)
		function ban_confirm_list_button:DoClick()
			net.Start("pac.CombatBanUpdate")
			net.WriteTable(pac.global_combat_whitelist)
			net.WriteBool(true)
			net.SendToServer()
		end
	local ban_request_list_button = vgui.Create("DButton", BAN)
		ban_request_list_button:SetText("Request ban list from server")
		--ban_request_list_button:SetColor(Color(255,0,0))
		ban_request_list_button:SetSize(200, 40)
		ban_request_list_button:SetPos(450, 60)

		function ban_request_list_button:DoClick()
			net.Start("pac.RequestCombatBanStates")
			net.SendToServer()
		end

		net.Receive("pac.SendCombatBanStates", function()
			pac.global_combat_whitelist = net.ReadTable()
			ban_list:Clear()
			local combat_bans_temp_merger = {}

			for _,ply in pairs(player.GetAll()) do
				combat_bans_temp_merger[ply:SteamID()] = pac.global_combat_whitelist[ply:SteamID()]-- or {nick = ply:Nick(), steamid = ply:SteamID(), permission = "Default"}
			end

			for id,data in pairs(pac.global_combat_whitelist) do
				combat_bans_temp_merger[id] = data
			end

			for id,data in pairs(combat_bans_temp_merger) do
				ban_list:AddLine(data.nick,data.steamid,data.permission)
			end
		end)


	return BAN
end

function pace.FillCombatSettings(pnl)
	local pnl = pnl

	local master_list = vgui.Create("DCategoryList", pnl)
	master_list:Dock(FILL)
	--general
	do
		local general_list = master_list:Add("General (Global policy and Network protection)")
		general_list.Header:SetSize(40,40)
		general_list.Header:SetFont("DermaLarge")
		local general_list_list = vgui.Create("DListLayout")
		general_list_list:DockPadding(20,0,20,20)
		general_list:SetContents(general_list_list)

		local sv_prop_protection_props_box = vgui.Create("DCheckBoxLabel", general_list_list)
			sv_prop_protection_props_box:SetText("Enforce generic prop protection for player-owned props and physics entities.\nRelated to client consents, but the policies for each part are not uniform.")
			sv_prop_protection_props_box:SetSize(400,30)
			sv_prop_protection_props_box:SetConVar("pac_sv_prop_protection")


		local sv_combat_whitelisting_box = vgui.Create("DCheckBoxLabel", general_list_list)
			sv_combat_whitelisting_box:SetText("Restrict new pac3 combat (damage zone, lock, force, hitscan, health modifier) to only whitelisted users.")
			sv_combat_whitelisting_box:SetSize(400,30)
			sv_combat_whitelisting_box:SetConVar("pac_sv_combat_whitelisting")
			sv_combat_whitelisting_box:SetTooltip("off = Blacklist mode: Default players are allowed to use the combat features\non = Whitelist mode: Default players aren't allowed to use the combat features until set to Allowed")

		local sv_master_break_box = vgui.Create("DCheckBoxLabel", general_list_list)
			sv_master_break_box:SetText("Block the combat features that aren't enabled. WARNING! Requires a restart!\nThis applies to damage zone, lock, force, hitscan and health modifier parts")
			sv_master_break_box:SetSize(400,30)
			sv_master_break_box:SetConVar("pac_sv_block_combat_features_on_next_restart")
			sv_master_break_box:SetTooltip("You can go to the console and set pac_sv_block_combat_features_on_next_restart to 2 to block everything.\nif you re-enable a blocked part, update with pac_sv_combat_reinitialize_missing_receivers")

		local sv_netrate_monitoring_box = vgui.Create("DCheckBoxLabel", general_list_list)
			sv_netrate_monitoring_box:SetText("Enable serverside monitoring prints for allowance and rate limiters")
			sv_netrate_monitoring_box:SetSize(400,30)
			sv_netrate_monitoring_box:SetConVar("pac_sv_combat_enforce_netrate_monitor_serverside")
			sv_netrate_monitoring_box:SetTooltip("Enable serverside monitoring prints.\n0=let clients enforce their netrate allowance before sending messages\n1=the server will receive net messages and print the outcome.")

		local sv_netrate_time_numbox = vgui.Create("DNumSlider", general_list_list)
			sv_netrate_time_numbox:SetText("Rate limiter (milliseconds)")
			sv_netrate_time_numbox:SetValue(GetConVar("pac_sv_combat_enforce_netrate"):GetInt())
			sv_netrate_time_numbox:SetMin(0) sv_netrate_time_numbox:SetDecimals(0) sv_netrate_time_numbox:SetMax(1000)
			sv_netrate_time_numbox:SetSize(400,30)
			sv_netrate_time_numbox:SetConVar("pac_sv_combat_enforce_netrate")
			sv_netrate_time_numbox:SetTooltip("The milliseconds delay between net messages.\nIf this is 0, the allowance won't matter, otherwise early net messages use up the player's allowance.\nThe allowance regenerates gradually when unused, and one unit gets spent if the message is earlier than the rate limiter's delay.")

		local sv_netrate_buffer_numbox = vgui.Create("DNumSlider", general_list_list)
			sv_netrate_buffer_numbox:SetText("Allowance, in number of messages")
			sv_netrate_buffer_numbox:SetValue(GetConVar("pac_sv_combat_enforce_netrate_buffersize"):GetInt())
			sv_netrate_buffer_numbox:SetMin(0) sv_netrate_buffer_numbox:SetDecimals(0) sv_netrate_buffer_numbox:SetMax(400)
			sv_netrate_buffer_numbox:SetSize(400,30)
			sv_netrate_buffer_numbox:SetConVar("pac_sv_combat_enforce_netrate_buffersize")
			sv_netrate_buffer_numbox:SetTooltip("Allowance:\nIf this is 0, only the time limiter will stop pac combat messages if they're too fast.\nOtherwise, players trying to use a pac combat message earlier will deduct 1 from the player's allowance, and only stop the messages if the allowance reaches 0.")

		local sv_hard_ent_limit_numbox = vgui.Create("DNumSlider", general_list_list)
			sv_hard_ent_limit_numbox:SetText("Hard entity limit to cutoff damage zones and force parts")
			sv_hard_ent_limit_numbox:SetValue(GetConVar("pac_sv_entity_limit_per_combat_operation"):GetInt())
			sv_hard_ent_limit_numbox:SetMin(0) sv_hard_ent_limit_numbox:SetDecimals(0) sv_hard_ent_limit_numbox:SetMax(1000)
			sv_hard_ent_limit_numbox:SetSize(400,30)
			sv_hard_ent_limit_numbox:SetConVar("pac_sv_entity_limit_per_combat_operation")
			sv_hard_ent_limit_numbox:SetTooltip("If the number of entities selected is more than this value, the whole operation gets dropped.\nThis is so that the server doesn't have to send huge amounts of entity updates to everyone.")

		local sv_per_player_ent_limit_numbox = vgui.Create("DNumSlider", general_list_list)
			sv_per_player_ent_limit_numbox:SetText("Entity limit per player to cutoff damage zones and force parts")
			sv_per_player_ent_limit_numbox:SetValue(GetConVar("pac_sv_entity_limit_per_player_per_combat_operation"):GetInt())
			sv_per_player_ent_limit_numbox:SetMin(0) sv_per_player_ent_limit_numbox:SetDecimals(0) sv_per_player_ent_limit_numbox:SetMax(500)
			sv_per_player_ent_limit_numbox:SetSize(400,30)
			sv_per_player_ent_limit_numbox:SetConVar("pac_sv_entity_limit_per_player_per_combat_operation")
			sv_per_player_ent_limit_numbox:SetTooltip("When in multiplayer, with the server's player count, if the number of entities selected is more than this value, the whole operation gets dropped.\nThis is so that the server doesn't have to send huge amounts of entity updates to everyone.")

		local sv_player_fraction_slider = vgui.Create("DNumSlider", general_list_list)
			sv_player_fraction_slider:SetText("block damage zones targeting this fraction of players")
			sv_player_fraction_slider:SetValue(GetConVar("pac_sv_player_limit_as_fraction_to_drop_damage_zone"):GetFloat())
			sv_player_fraction_slider:SetMin(0) sv_player_fraction_slider:SetDecimals(2) sv_player_fraction_slider:SetMax(1)
			sv_player_fraction_slider:SetSize(400,30)
			sv_player_fraction_slider:SetConVar("pac_sv_player_limit_as_fraction_to_drop_damage_zone")
			sv_player_fraction_slider:SetTooltip("This applies when the zone covers more than 12 players. 0 is 0% of the server, 1 is 100%\nFor example, if this is at 0.5, there are 24 players and a damage zone covers 13 players, it will be blocked.")

		local sv_distance_slider = vgui.Create("DNumSlider", general_list_list)
			sv_distance_slider:SetText("distance to block combat actions that are too far")
			sv_distance_slider:SetValue(GetConVar("pac_sv_combat_distance_enforced"):GetFloat())
			sv_distance_slider:SetMin(0) sv_distance_slider:SetDecimals(0) sv_distance_slider:SetMax(64000)
			sv_distance_slider:SetSize(400,30)
			sv_distance_slider:SetConVar("pac_sv_combat_distance_enforced")
			sv_distance_slider:SetTooltip("The distance is compared between the action's origin and the player's position.\n0 to ignore.")

	end

	do --hitscan
		--[[
			pac_sv_hitscan
			pac_sv_hitscan_max_bullets
			pac_sv_hitscan_max_damage
			pac_sv_hitscan_divide_max_damage_by_max_bullets
		]]

		local hitscans_list = master_list:Add("Hitscans")
		hitscans_list.Header:SetSize(40,40)
		hitscans_list.Header:SetFont("DermaLarge")
		local hitscans_list_list = vgui.Create("DListLayout")
		hitscans_list_list:DockPadding(20,0,20,20)
		hitscans_list:SetContents(hitscans_list_list)

		local sv_hitscans_box = vgui.Create("DCheckBoxLabel", hitscans_list_list)
			sv_hitscans_box:SetText("allow serverside bullets")
			sv_hitscans_box:SetSize(400,30)
			sv_hitscans_box:SetConVar("pac_sv_hitscan")

		local hitscans_max_dmg_numbox = vgui.Create("DNumSlider", hitscans_list_list)
			hitscans_max_dmg_numbox:SetText("Max hitscan damage (per bullet, per multishot,\ndepending on the next setting)")
			hitscans_max_dmg_numbox:SetValue(GetConVar("pac_sv_hitscan_max_damage"):GetInt())
			hitscans_max_dmg_numbox:SetMin(0) hitscans_max_dmg_numbox:SetDecimals(0) hitscans_max_dmg_numbox:SetMax(268435455)
			hitscans_max_dmg_numbox:SetSize(400,30)
			hitscans_max_dmg_numbox:SetConVar("pac_sv_hitscan_max_damage")

		local sv_hitscans_distribute_box = vgui.Create("DCheckBoxLabel", hitscans_list_list)
			sv_hitscans_distribute_box:SetText("force hitscans to distribute their total damage accross bullets. if off, every bullet does full damage; if on, adding more bullets doesn't do more damage")
			sv_hitscans_distribute_box:SetSize(400,30)
			sv_hitscans_distribute_box:SetConVar("pac_sv_hitscan_divide_max_damage_by_max_bullets")

		local hitscans_max_numbullets_numbox = vgui.Create("DNumSlider", hitscans_list_list)
			hitscans_max_numbullets_numbox:SetText("Maximum number of bullets for hitscan multishots")
			hitscans_max_numbullets_numbox:SetValue(GetConVar("pac_sv_hitscan_max_bullets"):GetInt())
			hitscans_max_numbullets_numbox:SetMin(1) hitscans_max_numbullets_numbox:SetDecimals(0) hitscans_max_numbullets_numbox:SetMax(500)
			hitscans_max_numbullets_numbox:SetSize(400,30)
			hitscans_max_numbullets_numbox:SetConVar("pac_sv_hitscan_max_bullets")
	end

	do --projectiles
		local projectiles_list = master_list:Add("Projectiles")
		projectiles_list.Header:SetSize(40,40)
		projectiles_list.Header:SetFont("DermaLarge")
		local projectiles_list_list = vgui.Create("DListLayout")
		projectiles_list_list:DockPadding(20,0,20,20)
		projectiles_list:SetContents(projectiles_list_list)

		local sv_projectiles_box = vgui.Create("DCheckBoxLabel", projectiles_list_list)
			sv_projectiles_box:SetText("allow serverside physical projectiles")
			sv_projectiles_box:SetSize(400,30)
			sv_projectiles_box:SetConVar("pac_sv_projectiles")

		local sv_projectiles_mesh_box = vgui.Create("DCheckBoxLabel", projectiles_list_list)
			sv_projectiles_mesh_box:SetText("allow custom collision meshes for physical projectiles")
			sv_projectiles_mesh_box:SetSize(400,30)
			sv_projectiles_mesh_box:SetConVar("pac_sv_projectile_allow_custom_collision_mesh")

		local projectile_max_phys_radius_numbox = vgui.Create("DNumSlider", projectiles_list_list)
			projectile_max_phys_radius_numbox:SetText("Max projectile physical radius")
			projectile_max_phys_radius_numbox:SetValue(GetConVar("pac_sv_projectile_max_phys_radius"):GetInt())
			projectile_max_phys_radius_numbox:SetMin(0) projectile_max_phys_radius_numbox:SetDecimals(0) projectile_max_phys_radius_numbox:SetMax(4095)
			projectile_max_phys_radius_numbox:SetSize(400,30)
			projectile_max_phys_radius_numbox:SetConVar("pac_sv_projectile_max_phys_radius")

		local projectile_max_dmg_radius_numbox = vgui.Create("DNumSlider", projectiles_list_list)
			projectile_max_dmg_radius_numbox:SetText("Max projectile damage radius")
			projectile_max_dmg_radius_numbox:SetValue(GetConVar("pac_sv_projectile_max_damage_radius"):GetInt())
			projectile_max_dmg_radius_numbox:SetMin(0) projectile_max_dmg_radius_numbox:SetDecimals(0) projectile_max_dmg_radius_numbox:SetMax(4095)
			projectile_max_dmg_radius_numbox:SetSize(400,30)
			projectile_max_dmg_radius_numbox:SetConVar("pac_sv_projectile_max_damage_radius")

		local projectile_max_attract_radius_numbox = vgui.Create("DNumSlider", projectiles_list_list)
			projectile_max_attract_radius_numbox:SetText("Max projectile attract radius")
			projectile_max_attract_radius_numbox:SetValue(GetConVar("pac_sv_projectile_max_attract_radius"):GetInt())
			projectile_max_attract_radius_numbox:SetMin(0) projectile_max_attract_radius_numbox:SetDecimals(0) projectile_max_attract_radius_numbox:SetMax(100000000)
			projectile_max_attract_radius_numbox:SetSize(400,30)
			projectile_max_attract_radius_numbox:SetConVar("pac_sv_projectile_max_attract_radius")

		local projectile_max_dmg_numbox = vgui.Create("DNumSlider", projectiles_list_list)
			projectile_max_dmg_numbox:SetText("Max projectile damage")
			projectile_max_dmg_numbox:SetValue(GetConVar("pac_sv_projectile_max_damage"):GetInt())
			projectile_max_dmg_numbox:SetMin(0) projectile_max_dmg_numbox:SetDecimals(0) projectile_max_dmg_numbox:SetMax(100000000)
			projectile_max_dmg_numbox:SetSize(400,30)
			projectile_max_dmg_numbox:SetConVar("pac_sv_projectile_max_damage")

		local projectile_max_speed_numbox = vgui.Create("DNumSlider", projectiles_list_list)
			projectile_max_speed_numbox:SetText("Max projectile speed")
			projectile_max_speed_numbox:SetValue(GetConVar("pac_sv_projectile_max_speed"):GetInt())
			projectile_max_speed_numbox:SetMin(0) projectile_max_speed_numbox:SetDecimals(0) projectile_max_speed_numbox:SetMax(50000)
			projectile_max_speed_numbox:SetSize(400,30)
			projectile_max_speed_numbox:SetConVar("pac_sv_projectile_max_speed")

		local projectile_max_mass_numbox = vgui.Create("DNumSlider", projectiles_list_list)
			projectile_max_mass_numbox:SetText("Max projectile mass")
			projectile_max_mass_numbox:SetValue(GetConVar("pac_sv_projectile_max_mass"):GetInt())
			projectile_max_mass_numbox:SetMin(0) projectile_max_mass_numbox:SetDecimals(0) projectile_max_mass_numbox:SetMax(500000)
			projectile_max_mass_numbox:SetSize(400,30)
			projectile_max_mass_numbox:SetConVar("pac_sv_projectile_max_mass")
	end

	do --damage zone
		local damagezone_list = master_list:Add("Damage Zone")
			damagezone_list.Header:SetSize(40,40)
			damagezone_list.Header:SetFont("DermaLarge")
			local damagezone_list_list = vgui.Create("DListLayout")
			damagezone_list_list:DockPadding(20,0,20,20)
			damagezone_list:SetContents(damagezone_list_list)

		local sv_dmgzone_box = vgui.Create("DCheckBoxLabel", damagezone_list_list)
			sv_dmgzone_box:SetText("Allow damage zone")
			sv_dmgzone_box:SetSize(400,30)
			sv_dmgzone_box:SetConVar("pac_sv_damage_zone")

		local max_dmgzone_radius_numbox = vgui.Create("DNumSlider", damagezone_list_list)
			max_dmgzone_radius_numbox:SetText("Max damage zone radius")
			max_dmgzone_radius_numbox:SetValue(GetConVar("pac_sv_damage_zone_max_radius"):GetInt())
			max_dmgzone_radius_numbox:SetMin(0) max_dmgzone_radius_numbox:SetDecimals(0) max_dmgzone_radius_numbox:SetMax(32767)
			max_dmgzone_radius_numbox:SetSize(400,30)
			max_dmgzone_radius_numbox:SetConVar("pac_sv_damage_zone_max_radius")

		local max_dmgzone_length_numbox = vgui.Create("DNumSlider", damagezone_list_list)
			max_dmgzone_length_numbox:SetText("Max damage zone length")
			max_dmgzone_length_numbox:SetValue(GetConVar("pac_sv_damage_zone_max_length"):GetInt())
			max_dmgzone_length_numbox:SetMin(0) max_dmgzone_length_numbox:SetDecimals(0) max_dmgzone_length_numbox:SetMax(32767)
			max_dmgzone_length_numbox:SetSize(400,30)
			max_dmgzone_length_numbox:SetConVar("pac_sv_damage_zone_max_length")

		local max_dmgzone_damage_numbox = vgui.Create("DNumSlider", damagezone_list_list)
			max_dmgzone_damage_numbox:SetText("Max damage zone damage")
			max_dmgzone_damage_numbox:SetValue(GetConVar("pac_sv_damage_zone_max_damage"):GetInt())
			max_dmgzone_damage_numbox:SetMin(0) max_dmgzone_damage_numbox:SetDecimals(0) max_dmgzone_damage_numbox:SetMax(268435455)
			max_dmgzone_damage_numbox:SetSize(400,30)
			max_dmgzone_damage_numbox:SetConVar("pac_sv_damage_zone_max_damage")

		local sv_dmgzone_allow_dissolve_box = vgui.Create("DCheckBoxLabel", damagezone_list_list)
			sv_dmgzone_allow_dissolve_box:SetText("Allow damage entity dissolvers")
			sv_dmgzone_allow_dissolve_box:SetSize(400,30)
			sv_dmgzone_allow_dissolve_box:SetConVar("pac_sv_damage_zone_allow_dissolve")

	end

	do --lock part
		local lock_list = master_list:Add("Lock part")
			lock_list.Header:SetSize(40,40)
			lock_list.Header:SetFont("DermaLarge")
			local lock_list_list = vgui.Create("DListLayout")
			lock_list_list:DockPadding(20,0,20,20)
			lock_list:SetContents(lock_list_list)

		local sv_lock_allow_box = vgui.Create("DCheckBoxLabel", lock_list_list)
			sv_lock_allow_box:SetText("Allow lock part")
			sv_lock_allow_box:SetSize(400,30)
			sv_lock_allow_box:SetConVar("pac_sv_lock")

		local sv_lock_grab_box = vgui.Create("DCheckBoxLabel", lock_list_list)
			sv_lock_grab_box:SetText("Allow lock part grabbing")
			sv_lock_grab_box:SetSize(400,30)
			sv_lock_grab_box:SetConVar("pac_sv_lock_grab")

		local sv_lock_grab_ply_box = vgui.Create("DCheckBoxLabel", lock_list_list)
			sv_lock_grab_ply_box:SetText("Allow grabbing players")
			sv_lock_grab_ply_box:SetSize(400,30)
			sv_lock_grab_ply_box:SetConVar("pac_sv_lock_allow_grab_ply")

		local sv_lock_grab_npc_box = vgui.Create("DCheckBoxLabel", lock_list_list)
			sv_lock_grab_npc_box:SetText("Allow grabbing NPCs")
			sv_lock_grab_npc_box:SetSize(400,30)
			sv_lock_grab_npc_box:SetConVar("pac_sv_lock_allow_grab_npc")

		local sv_lock_grab_ents_box = vgui.Create("DCheckBoxLabel", lock_list_list)
			sv_lock_grab_ents_box:SetText("Allow grabbing other entities")
			sv_lock_grab_ents_box:SetSize(400,30)
			sv_lock_grab_ents_box:SetConVar("pac_sv_lock_allow_grab_ent")

		local sv_lock_teleport_box = vgui.Create("DCheckBoxLabel", lock_list_list)
			sv_lock_teleport_box:SetText("Allow lock part teleportation")
			sv_lock_teleport_box:SetSize(400,30)
			sv_lock_teleport_box:SetConVar("pac_sv_lock_teleport")

		local max_lock_radius_numbox = vgui.Create("DNumSlider", lock_list_list)
			max_lock_radius_numbox:SetText("Max lock part grab range")
			max_lock_radius_numbox:SetValue(GetConVar("pac_sv_lock_max_grab_radius"):GetInt())
			max_lock_radius_numbox:SetMin(0) max_lock_radius_numbox:SetDecimals(0) max_lock_radius_numbox:SetMax(5000)
			max_lock_radius_numbox:SetSize(400,30)
			max_lock_radius_numbox:SetConVar("pac_sv_lock_max_grab_radius")
	end

	do --force
		local force_list = master_list:Add("Force part")
			force_list.Header:SetSize(40,40)
			force_list.Header:SetFont("DermaLarge")
			local force_list_list = vgui.Create("DListLayout")
			force_list_list:DockPadding(20,0,20,20)
			force_list:SetContents(force_list_list)

		local sv_force_box = vgui.Create("DCheckBoxLabel", force_list_list)
			sv_force_box:SetText("Allow force part")
			sv_force_box:SetSize(400,30)
			sv_force_box:SetConVar("pac_sv_force")

		local max_force_radius_numbox = vgui.Create("DNumSlider", force_list_list)
			max_force_radius_numbox:SetText("Max force part radius")
			max_force_radius_numbox:SetValue(GetConVar("pac_sv_force_max_radius"):GetInt())
			max_force_radius_numbox:SetMin(0) max_force_radius_numbox:SetDecimals(0) max_force_radius_numbox:SetMax(32767)
			max_force_radius_numbox:SetSize(400,30)
			max_force_radius_numbox:SetConVar("pac_sv_force_max_radius")

		local max_force_length_numbox = vgui.Create("DNumSlider", force_list_list)
			max_force_length_numbox:SetText("Max force part length")
			max_force_length_numbox:SetValue(GetConVar("pac_sv_force_max_length"):GetInt())
			max_force_length_numbox:SetMin(0) max_force_length_numbox:SetDecimals(0) max_force_length_numbox:SetMax(32767)
			max_force_length_numbox:SetSize(400,30)
			max_force_length_numbox:SetConVar("pac_sv_force_max_length")

		local max_force_amount_numbox = vgui.Create("DNumSlider", force_list_list)
			max_force_amount_numbox:SetText("Max force part amount")
			max_force_amount_numbox:SetValue(GetConVar("pac_sv_force_max_amount"):GetInt())
			max_force_amount_numbox:SetMin(0) max_force_amount_numbox:SetDecimals(0) max_force_amount_numbox:SetMax(10000000)
			max_force_amount_numbox:SetSize(400,30)
			max_force_amount_numbox:SetConVar("pac_sv_force_max_amount")
	end

	do --health_modifier
		local healthmod_list = master_list:Add("Health modifier part")
		healthmod_list.Header:SetSize(40,40)
		healthmod_list.Header:SetFont("DermaLarge")
		local healthmod_list_list = vgui.Create("DListLayout")
		healthmod_list_list:DockPadding(20,0,20,20)
		healthmod_list:SetContents(healthmod_list_list)

		local sv_healthmod_box = vgui.Create("DCheckBoxLabel", healthmod_list_list)
			sv_healthmod_box:SetText("Allow health modifier part")
			sv_healthmod_box:SetSize(400,30)
			sv_healthmod_box:SetConVar("pac_sv_health_modifier")

		local healthmod_extrabars_box = vgui.Create("DCheckBoxLabel", healthmod_list_list)
			healthmod_extrabars_box:SetText("Allow changing max health and max armor")
			healthmod_extrabars_box:SetSize(400,30)
			healthmod_extrabars_box:SetConVar("pac_sv_health_modifier_allow_maxhp")

		local min_healthmod_dmgmult_box = vgui.Create("DNumSlider", healthmod_list_list)
			min_healthmod_dmgmult_box:SetText("Minimum combined damage multiplier allowed.\nNegative values lead to healing from damage.")
			min_healthmod_dmgmult_box:SetValue(GetConVar("pac_sv_health_modifier_min_damagescaling"):GetInt())
			min_healthmod_dmgmult_box:SetMin(-10) min_healthmod_dmgmult_box:SetDecimals(2) min_healthmod_dmgmult_box:SetMax(1)
			min_healthmod_dmgmult_box:SetSize(400,30)
			min_healthmod_dmgmult_box:SetConVar("pac_sv_health_modifier_min_damagescaling")

		local healthmod_extrabars_box = vgui.Create("DCheckBoxLabel", healthmod_list_list)
			healthmod_extrabars_box:SetText("Allow extra healthbars")
			healthmod_extrabars_box:SetSize(400,30)
			healthmod_extrabars_box:SetConVar("pac_sv_health_modifier_extra_bars")
			healthmod_extrabars_box:SetToolTip("What are those? It's like an armor layer that takes damage before it gets applied to the entity.")
	end
	return master_list
end

function pace.FillServerSettings(pnl)
	local pnl = pnl

	local master_list = vgui.Create("DCategoryList", pnl)
	master_list:Dock(FILL)

	--models/entity
			--[[
				pac_allow_blood_color
				pac_allow_mdl
				pac_allow_mdl_entity
				pac_modifier_model
				pac_modifier_size
			]]

	local model_category = master_list:Add("Allowed Playermodel Mutations")
	model_category.Header:SetSize(40,40)
	model_category.Header:SetFont("DermaLarge")
	local model_category_list = vgui.Create("DListLayout")
	model_category_list:DockPadding(20,0,20,20)
	model_category:SetContents(model_category_list)

	local pac_allow_blood_color_box = vgui.Create("DCheckBoxLabel", master_list)
		pac_allow_blood_color_box:SetText("Blood")
		pac_allow_blood_color_box:SetSize(400,30)
		pac_allow_blood_color_box:SetConVar("pac_allow_blood_color")
		model_category_list:Add(pac_allow_blood_color_box)
	local pac_allow_mdl_box = vgui.Create("DCheckBoxLabel", master_list)
		pac_allow_mdl_box:SetText("MDL")
		pac_allow_mdl_box:SetSize(400,30)
		pac_allow_mdl_box:SetConVar("pac_allow_mdl")
		model_category_list:Add(pac_allow_mdl_box)
	local pac_allow_mdl_entity_box = vgui.Create("DCheckBoxLabel", master_list)
		pac_allow_mdl_entity_box:SetText("Entity MDL")
		pac_allow_mdl_entity_box:SetSize(400,30)
		pac_allow_mdl_entity_box:SetConVar("pac_allow_mdl_entity")
		model_category_list:Add(pac_allow_mdl_entity_box)
	local pac_modifier_model_box = vgui.Create("DCheckBoxLabel", master_list)
		pac_modifier_model_box:SetText("Entity model")
		pac_modifier_model_box:SetSize(400,30)
		pac_modifier_model_box:SetConVar("pac_modifier_model")
		model_category_list:Add(pac_modifier_model_box)
	local pac_modifier_size_box = vgui.Create("DCheckBoxLabel", master_list)
		pac_modifier_size_box:SetText("Entity size")
		pac_modifier_size_box:SetSize(400,30)
		pac_modifier_size_box:SetConVar("pac_modifier_size")
		model_category_list:Add(pac_modifier_size_box)

	--movement and mass
		--[[
			pac_free_movement
		]]

	local movement_category = master_list:Add("Player Movement")
	movement_category.Header:SetSize(40,40)
	movement_category.Header:SetFont("DermaLarge")
	local movement_category_list = vgui.Create("DListLayout")
	movement_category_list:DockPadding(20,20,20,20)
	movement_category:SetContents(movement_category_list)

	local pac_allow_movement_form = vgui.Create("DComboBox", movement_category_list)
		pac_allow_movement_form:SetText("Allow PAC player movement")
		--pac_allow_movement_form:SetSize(400,20)
		pac_allow_movement_form:SetSortItems(false)

		pac_allow_movement_form:AddChoice("disabled")
		pac_allow_movement_form:AddChoice("disabled if noclip not allowed")
		pac_allow_movement_form:AddChoice("enabled")

		pac_allow_movement_form.OnSelect = function(_, _, value)
			if value == "disabled" then
				net.Start("pac_send_sv_cvar")
				net.WriteString("pac_free_movement")
				net.WriteString("0")
				net.SendToServer()
				--pac_allow_movement_form.form = generic_form("PAC player movement is disabled.")
			elseif value == "disabled if noclip not allowed" then
				net.Start("pac_send_sv_cvar")
				net.WriteString("pac_free_movement")
				net.WriteString("-1")
				net.SendToServer()
				--pac_allow_movement_form.form = generic_form("PAC player movement is disabled if noclip is not allowed.")
			elseif value == "enabled" then
				net.Start("pac_send_sv_cvar")
				net.WriteString("pac_free_movement")
				net.WriteString("1")
				net.SendToServer()
				--pac_allow_movement_form.form = generic_form("PAC player movement is enabled.")
			end
		end

		--mode:ChooseOption(mode_str)

	local pac_player_movement_allow_mass_box = vgui.Create("DCheckBoxLabel", movement_category_list)
		pac_player_movement_allow_mass_box:SetText("Allow Modify Mass")
		pac_player_movement_allow_mass_box:SetSize(400,30)
		movement_category_list:Add(pac_player_movement_allow_mass_box)
		pac_player_movement_allow_mass_box:SetConVar("pac_player_movement_allow_mass")

	local playermovement_min_mass_numbox = vgui.Create("DNumSlider", movement_category_list)
		playermovement_min_mass_numbox:SetText("Mimnimum mass players can set for themselves")
		playermovement_min_mass_numbox:SetValue(GetConVar("pac_player_movement_min_mass"):GetFloat())
		playermovement_min_mass_numbox:SetMin(0.01) playermovement_min_mass_numbox:SetDecimals(0) playermovement_min_mass_numbox:SetMax(1000000)
		playermovement_min_mass_numbox:SetSize(400,30)
		movement_category_list:Add(playermovement_min_mass_numbox)
		playermovement_min_mass_numbox:SetConVar("pac_player_movement_min_mass")


	local playermovement_max_mass_numbox = vgui.Create("DNumSlider", movement_category_list)
		playermovement_max_mass_numbox:SetText("Maximum mass players can set for themselves")
		playermovement_max_mass_numbox:SetValue(GetConVar("pac_player_movement_max_mass"):GetFloat())
		playermovement_max_mass_numbox:SetMin(0.01) playermovement_max_mass_numbox:SetDecimals(0) playermovement_max_mass_numbox:SetMax(1000000)
		playermovement_max_mass_numbox:SetSize(400,30)
		movement_category_list:Add(playermovement_max_mass_numbox)
		playermovement_max_mass_numbox:SetConVar("pac_player_movement_max_mass")


	local pac_player_movement_allow_mass_dmgscaling_box = vgui.Create("DCheckBoxLabel", movement_category_list)
		pac_player_movement_allow_mass_dmgscaling_box:SetText("Allow damage scaling of physics damage based on player's mass")
		pac_player_movement_allow_mass_dmgscaling_box:SetSize(400,30)
		movement_category_list:Add(pac_player_movement_allow_mass_dmgscaling_box)
		pac_player_movement_allow_mass_dmgscaling_box:SetConVar("pac_player_movement_physics_damage_scaling")
		movement_category_list:Add(pac_player_movement_allow_mass_dmgscaling_box)


	--wear limits and bans
		--[[
			pac_sv_draw_distance
			pac_sv_hide_outfit_on_death WORKSHOP DEPRECATED
			pac_submit_limit
			pac_submit_spam
			pac_ban
			pac_unban
		]]

	local wear_list = master_list:Add("Server wearing/drawing")
	wear_list.Header:SetSize(40,40)
	wear_list.Header:SetFont("DermaLarge")
	local draw_distance_list = vgui.Create("DListLayout")
	draw_distance_list:DockPadding(20,0,20,20)
	wear_list:SetContents(draw_distance_list)

	local draw_dist_numbox = vgui.Create("DNumSlider", draw_distance_list)
		draw_dist_numbox:SetText("Server draw distance")
		draw_dist_numbox:SetValue(GetConVar("pac_sv_draw_distance"):GetInt())
		draw_dist_numbox:SetMin(0) draw_dist_numbox:SetDecimals(0) draw_dist_numbox:SetMax(50000)
		draw_dist_numbox:SetSize(400,30)
		draw_dist_numbox:SetConVar("pac_sv_draw_distance")

	local pac_submit_limit_numbox = vgui.Create("DNumSlider", draw_distance_list)
		pac_submit_limit_numbox:SetText("pac_submit limit")
		pac_submit_limit_numbox:SetValue(GetConVar("pac_submit_limit"):GetInt())
		pac_submit_limit_numbox:SetMin(0) pac_submit_limit_numbox:SetDecimals(0) pac_submit_limit_numbox:SetMax(100)
		pac_submit_limit_numbox:SetSize(400,30)
		pac_submit_limit_numbox:SetConVar("pac_submit_limit")

	local pac_submit_spam_box = vgui.Create("DCheckBoxLabel", draw_distance_list)
		pac_submit_spam_box:SetText("prevent pac_submit spam")
		pac_submit_spam_box:SetSize(400,30)
		pac_submit_spam_box:SetConVar("pac_submit_spam")



	--misc
		--[[
			sv_pac_webcontent_allow_no_content_length
			sv_pac_webcontent_limit
			pac_to_contraption_allow
			pac_max_contraption_entities
			pac_restrictions
		]]
	local misc_list = master_list:Add("Misc")
	misc_list.Header:SetSize(40,40)
	misc_list.Header:SetFont("DermaLarge")
	local misc_list_list = vgui.Create("DListLayout")
	misc_list_list:DockPadding(20,0,20,20)
	misc_list:SetContents(misc_list_list)
	local webcontent_no_content_box = vgui.Create("DCheckBoxLabel", misc_list_list)
		webcontent_no_content_box:SetText("allow downloads with no content length")
		webcontent_no_content_box:SetSize(400,30)
		webcontent_no_content_box:SetConVar("sv_pac_webcontent_allow_no_content_length")

	local contraption_box = vgui.Create("DCheckBoxLabel", misc_list_list)
		contraption_box:SetText("allow contraptions")
		contraption_box:SetSize(400,30)
		contraption_box:SetConVar("pac_to_contraption_allow")

	local contraption_entities_numbox = vgui.Create("DNumSlider", misc_list_list)
		contraption_entities_numbox:SetText("PAC3 contraption entities limit")
		contraption_entities_numbox:SetValue(GetConVar("pac_max_contraption_entities"):GetInt())
		contraption_entities_numbox:SetMin(0) contraption_entities_numbox:SetDecimals(0) contraption_entities_numbox:SetMax(200)
		contraption_entities_numbox:SetSize(400,30)
		contraption_entities_numbox:SetConVar("pac_max_contraption_entities")

	local cam_restrict_box = vgui.Create("DCheckBoxLabel", misc_list_list)
		cam_restrict_box:SetText("restrict PAC editor camera movement")
		cam_restrict_box:SetSize(400,30)
		cam_restrict_box:SetConVar("pac_restrictions")


	return master_list
end


--part order, shortcuts
function pace.FillEditorSettings(pnl)

	local buildlist_partmenu = {}
	local f = vgui.Create( "DPanel", pnl )
	f:SetSize(800)
	f:Center()

	local LeftPanel = vgui.Create( "DPanel", f ) -- Can be any panel, it will be stretched

	local partmenu_order_presets = vgui.Create("DComboBox",LeftPanel)
	partmenu_order_presets:SetText("Select a part menu preset")
	partmenu_order_presets:AddChoice("factory preset")
	partmenu_order_presets:AddChoice("legacy")
	partmenu_order_presets:AddChoice("expanded PAC4.5 preset")
	partmenu_order_presets:AddChoice("bulk select poweruser")
	partmenu_order_presets:AddChoice("user preset")
	partmenu_order_presets:SetX(10) partmenu_order_presets:SetY(10)
	partmenu_order_presets:SetWidth(200)
	partmenu_order_presets:SetHeight(20)

	local partmenu_apply_button = vgui.Create("DButton", LeftPanel)
	partmenu_apply_button:SetText("Apply")
	partmenu_apply_button:SetX(220)
	partmenu_apply_button:SetY(10)
	partmenu_apply_button:SetWidth(65)
	partmenu_apply_button:SetImage('icon16/accept.png')

	local partmenu_clearlist_button = vgui.Create("DButton", LeftPanel)
	partmenu_clearlist_button:SetText("Clear")
	partmenu_clearlist_button:SetX(285)
	partmenu_clearlist_button:SetY(10)
	partmenu_clearlist_button:SetWidth(65)
	partmenu_clearlist_button:SetImage('icon16/application_delete.png')

	local partmenu_savelist_button = vgui.Create("DButton", LeftPanel)
	partmenu_savelist_button:SetText("Save")
	partmenu_savelist_button:SetX(350)
	partmenu_savelist_button:SetY(10)
	partmenu_savelist_button:SetWidth(70)
	partmenu_savelist_button:SetImage('icon16/disk.png')



	local partmenu_choices = vgui.Create("DScrollPanel", LeftPanel)
	local partmenu_choices_textAdd = vgui.Create("DLabel", LeftPanel)
	partmenu_choices_textAdd:SetText("ADD MENU COMPONENTS")
	partmenu_choices_textAdd:SetFont("DermaDefaultBold")
	partmenu_choices_textAdd:SetColor(Color(0,200,0))
	partmenu_choices_textAdd:SetWidth(200)
	partmenu_choices_textAdd:SetX(10)
	partmenu_choices_textAdd:SetY(30)

	local partmenu_choices_textRemove = vgui.Create("DLabel", LeftPanel)
	partmenu_choices_textRemove:SetText("DOUBLE CLICK TO REMOVE")
	partmenu_choices_textRemove:SetColor(Color(200,0,0))
	partmenu_choices_textRemove:SetFont("DermaDefaultBold")
	partmenu_choices_textRemove:SetWidth(200)
	partmenu_choices_textRemove:SetX(220)
	partmenu_choices_textRemove:SetY(30)

	local partmenu_previews = vgui.Create("DListView", LeftPanel)
	partmenu_previews:AddColumn("index")
	partmenu_previews:AddColumn("control name")
	partmenu_previews:SetSortable(false)
	partmenu_previews:SetX(220)
	partmenu_previews:SetY(50)
	partmenu_previews:SetHeight(320)
	partmenu_previews:SetWidth(200)



	local shortcutaction_choices = vgui.Create("DComboBox", LeftPanel)
	shortcutaction_choices:SetText("Select a PAC action")
	for _,name in ipairs(pace.PACActionShortcut_Dictionary) do
		shortcutaction_choices:AddChoice(name)
	end
	shortcutaction_choices:SetX(10) shortcutaction_choices:SetY(400)
	shortcutaction_choices:SetWidth(170)
	shortcutaction_choices:SetHeight(20)
	shortcutaction_choices:ChooseOptionID(1)

	function shortcutaction_choices:Think()
		self.next = self.next or 0
		self.found = self.found or false
		if self.next < RealTime() then self.found = false end
		if self:IsHovered() then
			if input.IsKeyDown(KEY_UP) then
				if not self.found then self:ChooseOptionID(math.Clamp(self:GetSelectedID() + 1,1,table.Count(pace.PACActionShortcut_Dictionary))) self.found = true self.next = RealTime() + 0.3 end
			elseif input.IsKeyDown(KEY_DOWN) then
				if not self.found then self:ChooseOptionID(math.Clamp(self:GetSelectedID() - 1,1,table.Count(pace.PACActionShortcut_Dictionary))) self.found = true self.next = RealTime() + 0.3 end
			else self.found = false end
		else self.found = false
		end
	end

	local shortcuts_description_text = vgui.Create("DLabel", LeftPanel)
	shortcuts_description_text:SetFont("DermaDefaultBold")
	shortcuts_description_text:SetText("Edit keyboard shortcuts")
	shortcuts_description_text:SetColor(Color(0,0,0))
	shortcuts_description_text:SetWidth(200)
	shortcuts_description_text:SetX(10)
	shortcuts_description_text:SetY(380)

	local shortcutaction_presets = vgui.Create("DComboBox", LeftPanel)
	shortcutaction_presets:SetText("Select a shortcut preset")
	shortcutaction_presets:AddChoice("factory preset", pace.PACActionShortcut_Default)
	shortcutaction_presets:AddChoice("no CTRL preset", pace.PACActionShortcut_NoCTRL)
	shortcutaction_presets:AddChoice("experimental preset", pace.PACActionShortcut_Experimental)

	for i,filename in ipairs(file.Find("pac3_config/pac_editor_shortcuts*.txt","DATA")) do
		local data = file.Read("pac3_config/" .. filename, "DATA")
		shortcutaction_presets:AddChoice(string.GetFileFromFilename(filename), util.KeyValuesToTable(data))
	end

	shortcutaction_presets:SetX(10) shortcutaction_presets:SetY(420)
	shortcutaction_presets:SetWidth(170)
	shortcutaction_presets:SetHeight(20)
	function shortcutaction_presets:OnSelect(num, name, data)
		pace.PACActionShortcut = data
		pace.FlashNotification("Selected shortcut preset: " .. name .. ". View console for more info")
		pac.Message("Selected shortcut preset: " .. name)
		for i,v in pairs(data) do
			if #v > 0 then MsgC(Color(50,250,50), i .. "\n") end
			for i2,v2 in pairs(v) do
				MsgC(Color(0,250,250), "\t" .. table.concat(v2, "+") .. "\n")
			end
		end
	end


	local shortcutaction_choices_textCurrentShortcut = vgui.Create("DLabel", LeftPanel)
	shortcutaction_choices_textCurrentShortcut:SetText("Shortcut to edit:")
	shortcutaction_choices_textCurrentShortcut:SetColor(Color(0,60,160))
	shortcutaction_choices_textCurrentShortcut:SetWidth(200)
	shortcutaction_choices_textCurrentShortcut:SetX(200)
	shortcutaction_choices_textCurrentShortcut:SetY(420)


	local shortcutaction_index = vgui.Create("DNumberWang", LeftPanel)
	shortcutaction_index:SetToolTip("index")
	shortcutaction_index:SetValue(1)
	shortcutaction_index:SetMin(1)
	shortcutaction_index:SetMax(10)
	shortcutaction_index:SetWidth(30)
	shortcutaction_index:SetHeight(20)
	shortcutaction_index:SetX(180)
	shortcutaction_index:SetY(400)

	local function update_shortcutaction_choices_textCurrentShortcut(num)
		shortcutaction_choices_textCurrentShortcut:SetText("<No shortcut at index "..num..">")
		num = tonumber(num)
		local action, val = shortcutaction_choices:GetSelected()
		local strs = {}

		if action and action ~= "" then
			if pace.PACActionShortcut[action] and pace.PACActionShortcut[action][num] then
				for i,v in ipairs(pace.PACActionShortcut[action][num]) do
					strs[i] = v
				end
				shortcutaction_choices_textCurrentShortcut:SetText("Shortcut to edit: " .. table.concat(strs, " + "))
			else
				shortcutaction_choices_textCurrentShortcut:SetText("<No shortcut at index "..num..">")
			end
		end
	end
	update_shortcutaction_choices_textCurrentShortcut(1)

	function shortcutaction_index:OnValueChanged(num)
		update_shortcutaction_choices_textCurrentShortcut(num)
	end

	function shortcutaction_choices:OnSelect(i, action)
		shortcutaction_index:OnValueChanged(shortcutaction_index:GetValue())
	end

	local binder1 = vgui.Create("DBinder", LeftPanel)
	binder1:SetX(10)
	binder1:SetY(440)
	binder1:SetHeight(30)
	binder1:SetWidth(90)
	function binder1:OnChange( num )
		if not num or num == 0 then return end
		if not input.GetKeyName( num ) then return end
		LocalPlayer():ChatPrint("New bound key 1: "..input.GetKeyName( num ))
		pace.FlashNotification("New bound key 1: "..input.GetKeyName( num ))
	end

	local binder2 = vgui.Create("DBinder", LeftPanel)
	binder2:SetX(105)
	binder2:SetY(440)
	binder2:SetHeight(30)
	binder2:SetWidth(90)
	function binder2:OnChange( num )
		if not num or num == 0 then return end
		if not input.GetKeyName( num ) then return end
		LocalPlayer():ChatPrint("New bound key 2: "..input.GetKeyName( num ))
		pace.FlashNotification("New bound key 2: "..input.GetKeyName( num ))
	end

	local binder3 = vgui.Create("DBinder", LeftPanel)
	binder3:SetX(200)
	binder3:SetY(440)
	binder3:SetHeight(30)
	binder3:SetWidth(90)
	function binder3:OnChange( num )
		if not num or num == 0 then return end
		if not input.GetKeyName( num ) then return end
		LocalPlayer():ChatPrint("New bound key 3: "..input.GetKeyName( num ))
		pace.FlashNotification("New bound key 3: "..input.GetKeyName( num ))
	end

	local function send_active_shortcut_to_assign(tbl)
		local action = shortcutaction_choices:GetValue()
		local index = shortcutaction_index:GetValue()

		if not tbl then
			pace.PACActionShortcut[action] = pace.PACActionShortcut[action] or {}
			pace.PACActionShortcut[action][index] = pace.PACActionShortcut[action][index] or {}

			if table.IsEmpty(pace.PACActionShortcut[action][index]) then
				pace.PACActionShortcut[action][index] = nil
				if table.IsEmpty(pace.PACActionShortcut[action]) then
					pace.PACActionShortcut[action] = nil
				end
			else
				pace.PACActionShortcut[action][index] = nil
			end
		elseif not table.IsEmpty(tbl) then
			pace.AssignEditorShortcut(shortcutaction_choices:GetValue(), tbl, shortcutaction_index:GetValue())
		end
		encode_table_to_file("pac_editor_shortcuts")
	end

	local bindclear = vgui.Create("DButton", LeftPanel)
	bindclear:SetText("clear")
	bindclear:SetTooltip("deletes the current shortcut at the current index")
	bindclear:SetX(10)
	bindclear:SetY(480)
	bindclear:SetHeight(30)
	bindclear:SetWidth(90)
	bindclear:SetColor(Color(200,0,0))
	bindclear:SetIcon("icon16/keyboard_delete.png")
	function bindclear:DoClick()
		binder1:SetSelectedNumber(0)
		binder2:SetSelectedNumber(0)
		binder3:SetSelectedNumber(0)
		send_active_shortcut_to_assign()
		update_shortcutaction_choices_textCurrentShortcut(shortcutaction_index:GetValue())
	end

	local bindoverwrite = vgui.Create("DButton", LeftPanel)
	bindoverwrite:SetText("confirm")
	bindoverwrite:SetTooltip("applies the current shortcut combination at the current index")
	bindoverwrite:SetX(105)
	bindoverwrite:SetY(480)
	bindoverwrite:SetHeight(30)
	bindoverwrite:SetWidth(90)
	bindoverwrite:SetColor(Color(0,200,0))
	bindoverwrite:SetIcon("icon16/disk.png")
	function bindoverwrite:DoClick()
		local tbl = {}
		local i = 1
		--print(binder1:GetValue(), binder2:GetValue(), binder3:GetValue())
		if binder1:GetValue() ~= 0 then tbl[i] = input.GetKeyName(binder1:GetValue()) i = i + 1 end
		if binder2:GetValue() ~= 0 then tbl[i] = input.GetKeyName(binder2:GetValue()) i = i + 1 end
		if binder3:GetValue() ~= 0 then tbl[i] = input.GetKeyName(binder3:GetValue()) end
		if not table.IsEmpty(tbl) then
			pace.FlashNotification("Combo " .. shortcutaction_index:GetValue() .. " committed: " .. table.concat(tbl," "))
			if not pace.PACActionShortcut[shortcutaction_choices:GetValue()] then
				pace.PACActionShortcut[shortcutaction_choices:GetValue()] = {}
			end
			send_active_shortcut_to_assign(tbl)
			update_shortcutaction_choices_textCurrentShortcut(shortcutaction_index:GetValue())
		end
		encode_table_to_file("pac_editor_shortcuts")
	end

	function bindoverwrite:DoRightClick()
		Derma_StringRequest("Save preset", "Save a keyboard shortcuts preset?", "pac_editor_shortcuts",
			function(name) file.Write("pac3_config/"..name..".txt", util.TableToKeyValues(pace.PACActionShortcut))
				shortcutaction_presets:AddChoice(name..".txt")
			end
		)
	end

	local bindcapture_text = vgui.Create("DLabel", LeftPanel)
	bindcapture_text:SetFont("DermaDefaultBold")
	bindcapture_text:SetText("")
	bindcapture_text:SetColor(Color(0,0,0))
	bindcapture_text:SetX(300)
	bindcapture_text:SetY(480)
	bindcapture_text:SetSize(300, 30)

	function bindcapture_text:Think()
		self:SetText(pace.bindcapturelabel_text)
	end
	local bindcapture = vgui.Create("DButton", LeftPanel)
	bindcapture:SetText("capture input")
	bindcapture:SetX(200)
	bindcapture:SetY(480)
	bindcapture:SetHeight(30)
	bindcapture:SetWidth(90)
	pace.bindcapturelabel_text = ""
	function bindcapture:DoClick()
		pace.delayshortcuts = RealTime() + 5
		local input_active = {}
		local no_input = true
		local inputs_str = ""
		local previous_inputs_str = ""
		pace.FlashNotification("Recording input... Release one key when you're done")

		hook.Add("Tick", "pace_buttoncapture_countdown", function()
			pace.delayshortcuts = RealTime() + 5
			local inputs_tbl = {}
			inputs_str = ""
			for i=1,172,1 do --build bool list of all current keys
				if input.IsKeyDown(i) then
					input_active[i] = true
					inputs_tbl[i] = true
					no_input = false
					inputs_str = inputs_str .. input.GetKeyName(i) .. " "
				else
					input_active[i] = false
				end
			end
			pace.bindcapturelabel_text = "Recording input:\n" .. inputs_str

			if previous_inputs_tbl and table.Count(previous_inputs_tbl) > 0 then
				if table.Count(inputs_tbl) < table.Count(previous_inputs_tbl) then
					pace.FlashNotification("ending input!" .. previous_inputs_str)

					local tbl = {}
					local i = 1
					for key,bool in pairs(previous_inputs_tbl) do
						tbl[i] = input.GetKeyName(key)
						i = i + 1
					end
					--print(shortcutaction_choices:GetValue(), shortcutaction_index:GetValue())
					pace.AssignEditorShortcut(shortcutaction_choices:GetValue(), tbl, shortcutaction_index:GetValue())
					--pace.PACActionShortcut[shortcutaction_choices:GetValue()][shortcutaction_index:GetValue()] = tbl
					pace.delayshortcuts = RealTime() + 5
					pace.bindcapturelabel_text = "Recorded input:\n" .. previous_inputs_str
					hook.Remove("Tick", "pace_buttoncapture_countdown")
				end
			end
			previous_inputs_str = inputs_str
			previous_inputs_tbl = inputs_tbl
		end)

	end

	local bulkbinder = vgui.Create("DBinder", LeftPanel)
	function bulkbinder:OnChange( num )
		GetConVar("pac_bulk_select_key"):SetString(input.GetKeyName( num ))
	end
	bulkbinder:SetX(210)
	bulkbinder:SetY(400)
	bulkbinder:SetSize(80,20)
	bulkbinder:SetText("bulk select key")

	local function ClearPartMenuPreviewList()
		local i = 0
		while (partmenu_previews:GetLine(i + 1) ~= nil) do
			i = i+1
		end
		for v=i,0,-1 do
			if partmenu_previews:GetLine(v) ~= nil then partmenu_previews:RemoveLine(v) end
			v = v - 1
		end
	end

	local function FindImage(option_name)
		if option_name == "save" then
			return pace.MiscIcons.save
		elseif option_name == "load" then
			return pace.MiscIcons.load
		elseif option_name == "wear" then
			return pace.MiscIcons.wear
		elseif option_name == "remove" then
			return pace.MiscIcons.clear
		elseif option_name == "copy" then
			return pace.MiscIcons.copy
		elseif option_name == "paste" then
			return pace.MiscIcons.paste
		elseif option_name == "cut" then
			return 'icon16/cut.png'
		elseif option_name == "paste_properties" then
			return pace.MiscIcons.replace
		elseif option_name == "clone" then
			return pace.MiscIcons.clone
		elseif option_name == "partsize_info" then
			return'icon16/drive.png'
		elseif option_name == "bulk_apply_properties" then
			return 'icon16/application_form.png'
		elseif option_name == "bulk_select" then
			return 'icon16/table_multiple.png'
		elseif option_name == "spacer" then
			return 'icon16/application_split.png'
		elseif option_name == "hide_editor" then
			return 'icon16/application_delete.png'
		elseif option_name == "expand_all" then
			return 'icon16/arrow_down.png'
		elseif option_name == "collapse_all" then
			return 'icon16/arrow_in.png'
		elseif option_name == "copy_uid" then
			return pace.MiscIcons.uniqueid
		elseif option_name == "help_part_info" then
			return 'icon16/information.png'
		elseif option_name == "reorder_movables" then
			return 'icon16/application_double.png'
		end
		return 'icon16/world.png'
	end

	partmenu_choices:SetY(50)
	partmenu_choices:SetX(10)
	for i,v in pairs(pace.operations_all_operations) do
		local pnl = vgui.Create("DButton", f)
		pnl:SetText(string.Replace(string.upper(v),"_"," "))
		pnl:SetImage(FindImage(v))

		function pnl:DoClick()
			table.insert(buildlist_partmenu,v)
			partmenu_previews:AddLine(#buildlist_partmenu,v)
		end
		partmenu_choices:AddItem(pnl)
		pnl:SetHeight(18)
		pnl:SetWidth(200)
		pnl:SetY(20*(i-1))
	end

	partmenu_choices:SetWidth(200)
	partmenu_choices:SetHeight(320)
	partmenu_choices:SetVerticalScrollbarEnabled(true)


	local RightPanel = vgui.Create( "DTree", f )
	Test_Node = RightPanel:AddNode( "Test", "icon16/world.png" )
	test_part = pac.CreatePart("base") //the menu needs a part to get its full version in preview
	function RightPanel:DoRightClick()
		temp_list = pace.operations_order
		pace.operations_order = buildlist_partmenu
		pace.OnPartMenu(test_part)
		temp_list = pace.operations_order
		pace.operations_order = temp_list
	end
	function RightPanel:DoClick()
		temp_list = pace.operations_order
		pace.operations_order = buildlist_partmenu
		pace.OnPartMenu(test_part)
		temp_list = pace.operations_order
		pace.operations_order = temp_list
	end
	test_part:Remove() //dumb workaround but it works


	local div = vgui.Create( "DHorizontalDivider", f )
	div:Dock( FILL )
	div:SetLeft( LeftPanel )
	div:SetRight( RightPanel )

	div:SetDividerWidth( 8 )
	div:SetLeftMin( 50 )
	div:SetRightMin( 50 )
	div:SetLeftWidth( 450 )
	partmenu_order_presets.OnSelect = function( self, index, value )
		local temp_list = {"wear","save","load"}
		if value == "factory preset" then
			temp_list = table.Copy(pace.operations_default)
		elseif value == "legacy" then
			temp_list = table.Copy(pace.operations_legacy)
		elseif value == "expanded PAC4.5 preset" then
			temp_list = table.Copy(pace.operations_experimental)
		elseif value == "bulk select poweruser" then
			temp_list = table.Copy(pace.operations_bulk_poweruser)
		elseif value == "user preset" then
			temp_list = pace.operations_order
		end
		ClearPartMenuPreviewList()
		for i,v in ipairs(temp_list) do
			partmenu_previews:AddLine(i,v)
		end
		buildlist_partmenu = temp_list
	end

	function partmenu_apply_button:DoClick()
		pace.operations_order = buildlist_partmenu
	end

	function partmenu_clearlist_button:DoClick()
		ClearPartMenuPreviewList()
		buildlist_partmenu = {}
	end

	function partmenu_savelist_button:DoClick()
		encode_table_to_file("pac_editor_partmenu_layouts")
	end

	function partmenu_previews:DoDoubleClick(id, line)
		table.remove(buildlist_partmenu,id)

		ClearPartMenuPreviewList()
		for i,v in ipairs(buildlist_partmenu) do
			partmenu_previews:AddLine(i,v)
		end

		PrintTable(buildlist_partmenu)
	end


	if pace.operations_order then
		for i,v in pairs(pace.operations_order) do
			table.insert(buildlist_partmenu,v)
			partmenu_previews:AddLine(#buildlist_partmenu,v)
		end
	end

	return f
end

--camera movement
function pace.FillEditorSettings2(pnl)
	local panel = vgui.Create( "DPanel", pnl )
	--[[ movement binds
		CreateConVar("pac_editor_camera_forward_bind", "w")

		CreateConVar("pac_editor_camera_back_bind", "s")

		CreateConVar("pac_editor_camera_moveleft_bind", "a")

		CreateConVar("pac_editor_camera_moveright_bind", "d")

		CreateConVar("pac_editor_camera_up_bind", "space")

		CreateConVar("pac_editor_camera_down_bind", "")

		]]

	--[[pace.camera_movement_binds = {
		["forward"] = pace.camera_forward_bind,
		["back"] = pace.camera_back_bind,
		["moveleft"] = pace.camera_moveleft_bind,
		["moveright"] = pace.camera_moveright_bind,
		["up"] = pace.camera_up_bind,
		["down"] = pace.camera_down_bind,
		["slow"] = pace.camera_slow_bind,
		["speed"] = pace.camera_speed_bind
		}
	]]

	local LeftPanel = vgui.Create( "DPanel", panel ) -- Can be any panel, it will be stretched
	local RightPanel = vgui.Create( "DPanel", panel ) -- Can be any panel, it will be stretched
	LeftPanel:SetSize(300,600)
	RightPanel:SetSize(300,600)
	local div = vgui.Create( "DHorizontalDivider", panel )
	div:Dock( FILL )
	div:SetLeft( LeftPanel )
	div:SetRight( RightPanel )

	div:SetDividerWidth( 8 )
	div:SetLeftMin( 50 )
	div:SetRightMin( 50 )
	div:SetLeftWidth( 400 )

	local movement_binders_label = vgui.Create("DLabel", LeftPanel)
	movement_binders_label:SetText("PAC editor camera movement")
	movement_binders_label:SetFont("DermaDefaultBold")
	movement_binders_label:SetColor(Color(0,0,0))
	movement_binders_label:SetSize(200,40)
	movement_binders_label:SetPos(30,5)

	local forward_binder = vgui.Create("DBinder", LeftPanel)
		forward_binder:SetSize(40,40)
		forward_binder:SetPos(100,40)
		forward_binder:SetTooltip("move forward")
		forward_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["forward"]:GetString()))
		function forward_binder:OnChange(num)
			pace.camera_movement_binds["forward"]:SetString(input.GetKeyName( num ))
		end

	local back_binder = vgui.Create("DBinder", LeftPanel)
		back_binder:SetSize(40,40)
		back_binder:SetPos(100,80)
		back_binder:SetTooltip("move back")
		back_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["back"]:GetString()))
		function back_binder:OnChange(num)
			pace.camera_movement_binds["back"]:SetString(input.GetKeyName( num ))
		end

	local moveleft_binder = vgui.Create("DBinder", LeftPanel)
		moveleft_binder:SetSize(40,40)
		moveleft_binder:SetPos(60,80)
		moveleft_binder:SetTooltip("move left")
		moveleft_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["moveleft"]:GetString()))
		function moveleft_binder:OnChange(num)
			pace.camera_movement_binds["moveleft"]:SetString(input.GetKeyName( num ))
		end

	local moveright_binder = vgui.Create("DBinder", LeftPanel)
		moveright_binder:SetSize(40,40)
		moveright_binder:SetPos(140,80)
		moveright_binder:SetTooltip("move right")
		moveright_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["moveright"]:GetString()))
		function moveright_binder:OnChange(num)
			pace.camera_movement_binds["moveright"]:SetString(input.GetKeyName( num ))
		end

	local up_binder = vgui.Create("DBinder", LeftPanel)
		up_binder:SetSize(40,40)
		up_binder:SetPos(180,40)
		up_binder:SetTooltip("move up")
		up_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["up"]:GetString()))
		function up_binder:OnChange(num)
			pace.camera_movement_binds["up"]:SetString(input.GetKeyName( num ))
		end

	local down_binder = vgui.Create("DBinder", LeftPanel)
		down_binder:SetSize(40,40)
		down_binder:SetPos(180,80)
		down_binder:SetTooltip("move down")
		down_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["down"]:GetString()))
		function down_binder:OnChange(num)
			print(num, input.GetKeyName( num ))
			pace.camera_movement_binds["down"]:SetString(input.GetKeyName( num ))
		end

	local slow_binder = vgui.Create("DBinder", LeftPanel)
		slow_binder:SetSize(40,40)
		slow_binder:SetPos(20,80)
		slow_binder:SetTooltip("go slow")
		slow_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["slow"]:GetString()))
		function slow_binder:OnChange(num)
			pace.camera_movement_binds["slow"]:SetString(input.GetKeyName( num ))
		end

	local speed_binder = vgui.Create("DBinder", LeftPanel)
		speed_binder:SetSize(40,40)
		speed_binder:SetPos(20,40)
		speed_binder:SetTooltip("go fast")
		speed_binder:SetValue(input.GetKeyCode(pace.camera_movement_binds["speed"]:GetString()))
		function speed_binder:OnChange(num)
			pace.camera_movement_binds["speed"]:SetString(input.GetKeyName( num ))
		end

	local Parts = pac.GetRegisteredParts()
	local function get_icon(str, fallback)
		if str then
			if pace.MiscIcons[string.gsub(str, "pace.MiscIcons.", "")] then
				return pace.MiscIcons[string.gsub(str, "pace.MiscIcons.", "")]
			else
				local img = string.gsub(str, ".png", "") --remove the png extension
				img = string.gsub(img, "icon16/", "") --remove the icon16 base path
				img = "icon16/" .. img .. ".png" --why do this? to be able to write any form and let the program fix the form
				return img
			end
		elseif Parts[fallback] then
			return Parts[fallback].Icon
		else
			return "icon16/page_white.png"
		end

	end

	local categorytree = vgui.Create("DTree", RightPanel)
		categorytree:SetY(30)
		categorytree:SetSize(360,400)

	local function class_partnode_add(parentnode, class)
		if Parts[class] then
			for i,v in ipairs(parentnode:GetChildNodes()) do --can't make duplicates so remove to place it at the end
				if v:GetText() == class then v:Remove() end
			end

			local part_node = parentnode:AddNode(class)
			part_node:SetIcon(get_icon(nil, class))
			part_node.DoRightClick = function()
				local menu = DermaMenu()
				menu:AddOption("remove", function() part_node:Remove() end):SetImage("icon16/cross.png")
				menu:MakePopup()
				menu:SetPos(input.GetCursorPos())
			end
		end
	end
	local function bring_up_partclass_list(cat_node)

		--function from pace.OnAddPartMenu(obj)
		local base = vgui.Create("EditablePanel")
		base:SetPos(input.GetCursorPos())
		base:SetSize(200, 300)

		base:MakePopup()

		function base:OnRemove()
			pac.RemoveHook("VGUIMousePressed", "search_part_menu")
		end

		local edit = base:Add("DTextEntry")
		edit:SetTall(20)
		edit:Dock(TOP)
		edit:RequestFocus()
		edit:SetUpdateOnType(true)

		local result = base:Add("DScrollPanel")
		result:Dock(FILL)

		function edit:OnEnter()
			if result.found[1] then
				class_partnode_add(cat_node, result.found[1].ClassName)
			end
			base:Remove()
		end

		edit.OnValueChange = function(_, str)
			result:Clear()
			result.found = {}

			for _, part in ipairs(pace.GetRegisteredParts()) do
				if (part.FriendlyName or part.ClassName):find(str, nil, true) then
					table.insert(result.found, part)
				end
			end

			table.sort(result.found, function(a, b) return #a.ClassName < #b.ClassName end)

			for _, part in ipairs(result.found) do
				local line = result:Add("DButton")
				line:SetText("")
				line:SetTall(20)
				line.DoClick = function()
					class_partnode_add(cat_node, part.ClassName)
				end

				local btn = line:Add("DImageButton")
				btn:SetSize(16, 16)
				btn:SetPos(4,0)
				btn:CenterVertical()
				btn:SetMouseInputEnabled(false)
				if part.Icon then
					btn:SetImage(part.Icon)
				end

				local label = line:Add("DLabel")
				label:SetTextColor(label:GetSkin().Colours.Category.Line.Text)
				label:SetText((part.FriendlyName or part.ClassName):Replace('_', ' '))
				label:SizeToContents()
				label:MoveRightOf(btn, 4)
				label:SetMouseInputEnabled(false)
				label:CenterVertical()

				line:Dock(TOP)
			end

			--base:SetHeight(20 * #result.found + edit:GetTall())
			base:SetHeight(600 + edit:GetTall())

		end

		edit:OnValueChange("")

		pac.AddHook("VGUIMousePressed", "search_part_menu", function(pnl, code)
			if code == MOUSE_LEFT or code == MOUSE_RIGHT then
				if not base:IsOurChild(pnl) then
					base:Remove()
				end
			end
		end)
	end
	local function bring_up_category_icon_browser(category_node)
		local master_frame = vgui.Create("DFrame")
		master_frame:SetPos(input.GetCursorPos())
		master_frame:SetSize(400,400)

		local browser = vgui.Create("DIconBrowser", master_frame)
		function browser:OnChange()
			category_node:SetIcon(self:GetSelectedIcon())
		end
		browser:SetSize(400,380)
		browser:SetPos(0,40)

		local frame = vgui.Create("EditablePanel", master_frame)
		local edit = vgui.Create("DTextEntry", frame)
		frame:SetSize(300,20)
		function browser:Think()
			if not IsValid(category_node) then master_frame:Remove() end
			x = master_frame:GetX()
			y = master_frame:GetY()
			frame:SetPos(x,y+20)
			frame:MakePopup()
		end

		function edit:OnValueChange(value)
			browser:FilterByText( value )
		end
		master_frame:MakePopup()
		frame:MakePopup()
		edit:Dock(TOP)
		edit:RequestFocus()
		edit:SetUpdateOnType(true)
	end
	local function bring_up_tooltip_edit(category_node)
		local frame = vgui.Create("EditablePanel")
		local edit = vgui.Create("DTextEntry", frame)
		function edit:OnEnter(value)
			category_node:SetTooltip(value)
			frame:Remove()
		end
		function frame:Think()
			if input.IsMouseDown(MOUSE_LEFT) and not (self:IsHovered() or edit:IsHovered()) then self:Remove() end
		end
		frame:MakePopup()

		frame:SetSize(300,30)
		frame:SetPos(input.GetCursorPos())

		edit:Dock(TOP)
		edit:RequestFocus()
		edit:SetUpdateOnType(true)
	end
	local function bring_up_name_edit(category_node)
		local frame = vgui.Create("EditablePanel")
		local edit = vgui.Create("DTextEntry", frame)
		edit:SetText(category_node:GetText())
		function edit:OnEnter(value)
			category_node:SetText(value)
			frame:Remove()
		end
		function frame:Think()
			if input.IsMouseDown(MOUSE_LEFT) and not (self:IsHovered() or edit:IsHovered()) then self:Remove() end
		end
		frame:MakePopup()

		frame:SetSize(300,30)
		frame:SetPos(category_node.Label:LocalToScreen(category_node.Label:GetPos()))

		edit:Dock(TOP)
		edit:RequestFocus()
		edit:SetUpdateOnType(true)
	end

	local function load_partgroup_template_into_tree(categorytree, tbl)
		tbl = tbl or pace.partgroups or pace.partmenu_categories_default
		categorytree:Clear()
		for category,category_contents in pairs(tbl) do

			local category_node = categorytree:AddNode(category)
			category_node:SetIcon(get_icon(category_contents.icon, category))

			category_node.DoRightClick = function()
				local menu = DermaMenu()
				menu:AddOption("insert part in category", function() bring_up_partclass_list(category_node) end):SetImage("icon16/add.png")
				menu:AddOption("select icon", function() bring_up_category_icon_browser(category_node) end):SetImage("icon16/picture.png")
				menu:AddOption("write a tooltip", function() bring_up_tooltip_edit(category_node) end):SetImage("icon16/comment.png")
				menu:AddOption("rename this category", function() bring_up_name_edit(category_node) end):SetImage("icon16/textfield_rename.png")
				menu:AddOption("remove this category", function() category_node:Remove() end):SetImage("icon16/cross.png")
				menu:MakePopup()
				menu:SetPos(input.GetCursorPos())
			end

			if category_contents["tooltip"] then
				category_node:SetTooltip(category_contents["tooltip"])
			end

			for field,value in pairs(category_contents) do
				if Parts[field] then
					class_partnode_add(category_node, field)
				end
			end
		end
	end

	local function extract_partgroup_template_from_tree(categorytree)
		local tbl = {}
		for i,category_node in ipairs(categorytree:Root():GetChildNodes()) do
			tbl[category_node:GetText()] = {}
			--print(i,category_node:GetText(),category_node.Label:GetTooltip(),  category_node:GetIcon())
			if category_node:GetTooltip() ~= nil and category_node:GetTooltip() ~= "" then tbl[category_node:GetText()]["tooltip"] = category_node:GetTooltip() end
			tbl[category_node:GetText()]["icon"] = category_node:GetIcon()

			for i2,part_node in ipairs(category_node:GetChildNodes()) do
				tbl[category_node:GetText()][part_node:GetText()] = part_node:GetText()
				--print("\t",part_node:GetText())
			end
		end
		return tbl
	end

	load_partgroup_template_into_tree(categorytree, pace.partgroups)

	local part_categories_presets = vgui.Create("DComboBox", RightPanel)
		part_categories_presets:SetText("Select a part category preset")
		part_categories_presets:AddChoice("active preset")
		part_categories_presets:AddChoice("factory preset")
		part_categories_presets:AddChoice("experimental preset")
		local default_partgroup_presets = {
			["pac_part_categories.txt"] = true,
			["pac_part_categories_experimental.txt"] = true,
			["pac_part_categories_default.txt"] = true
		}
		for i,filename in ipairs(file.Find("pac3_config/pac_part_categories*.txt","DATA")) do
			if not default_partgroup_presets[string.GetFileFromFilename(filename)] then
				part_categories_presets:AddChoice(string.GetFileFromFilename(filename))
			end
		end

		part_categories_presets:SetX(10) part_categories_presets:SetY(10)
		part_categories_presets:SetWidth(170)
		part_categories_presets:SetHeight(20)

	part_categories_presets.OnSelect = function( self, index, value )
		if value == "factory preset" then
			pace.partgroups = pace.partmenu_categories_default
		elseif value == "experimental preset" then
			pace.partgroups = pace.partmenu_categories_experimental
		elseif string.find(value, ".txt") then
			pace.partgroups = util.KeyValuesToTable(file.Read("pac3_config/"..value))
		elseif value == "active preset" then
			decode_table_from_file("pac_part_categories")
			if not pace.partgroups_user then pace.partgroups_user = pace.partgroups end
			file.Write("pac3_config/pac_part_categories_user.txt", util.TableToKeyValues(pace.partgroups_user))
		end
		load_partgroup_template_into_tree(categorytree, pace.partgroups)
	end

	local part_categories_save = vgui.Create("DButton", RightPanel)
		part_categories_save:SetText("Save")
		part_categories_save:SetImage("icon16/disk.png")
		part_categories_save:SetX(180) part_categories_save:SetY(10)
		part_categories_save:SetWidth(80)
		part_categories_save:SetHeight(20)
		part_categories_save:SetTooltip("Left click to save preset to the active slot\nRight click to save to a new file")
		part_categories_save.DoClick = function()
			pace.partgroups = extract_partgroup_template_from_tree(categorytree)
			file.Write("pac3_config/pac_part_categories.txt", util.TableToKeyValues(extract_partgroup_template_from_tree(categorytree)))
		end
		part_categories_save.DoRightClick = function()
			Derma_StringRequest("Save preset", "Save a part category preset?", "pac_part_categories",
				function(name) file.Write("pac3_config/"..name..".txt", util.TableToKeyValues(extract_partgroup_template_from_tree(categorytree)))
					part_categories_presets:AddChoice(name..".txt")
				end
			)
		end

	local part_categories_add_cat = vgui.Create("DButton", RightPanel)
		part_categories_add_cat:SetText("Add category")
		part_categories_add_cat:SetImage("icon16/add.png")
		part_categories_add_cat:SetX(260) part_categories_add_cat:SetY(10)
		part_categories_add_cat:SetWidth(100)
		part_categories_add_cat:SetHeight(20)
		part_categories_add_cat.DoClick = function()
			local category_node = categorytree:AddNode("Category " .. categorytree:Root():GetChildNodeCount() + 1)
			category_node:SetIcon("icon16/page_white.png")

			category_node.DoRightClick = function()
				local menu = DermaMenu()
				menu:AddOption("insert part in category", function() bring_up_partclass_list(category_node) end):SetImage("icon16/add.png")
				menu:AddOption("select icon", function() bring_up_category_icon_browser(category_node) end):SetImage("icon16/picture.png")
				menu:AddOption("write a tooltip", function() bring_up_tooltip_edit(category_node) end):SetImage("icon16/comment.png")
				menu:AddOption("rename this category", function() bring_up_name_edit(category_node) end):SetImage("icon16/textfield_rename.png")
				menu:AddOption("remove this category", function() category_node:Remove() end):SetImage("icon16/cross.png")
				menu:MakePopup()
				menu:SetPos(input.GetCursorPos())
			end
		end

	return panel
end

function pace.GetPartMenuComponentPreviewForMenuEdit(menu, option_name)
	local pnl = vgui.Create("DButton", menu)
	pnl:SetText(string.Replace(string.upper(option_name),"_"," "))
	return pnl
end

function pace.ConfigureEventWheelMenu()
	pace.command_colors = pace.command_colors or {}
	local master_panel = vgui.Create("DFrame")
	master_panel:SetTitle("event wheel config")
	master_panel:SetSize(500,800)
	master_panel:Center()
	local mid_panel = vgui.Create("DPanel", master_panel)
	mid_panel:Dock(FILL)

	local scr_pnl = vgui.Create("DScrollPanel", mid_panel)
	scr_pnl:SetSize(490,800)
	scr_pnl:SetPos(0,45)
	local list = vgui.Create("DListLayout", scr_pnl) list:Dock(FILL)

	local first_panel = vgui.Create("DPanel", mid_panel)
	first_panel:SetSize(500,40)
	first_panel:Dock(TOP)

	local circle_style_listmenu = vgui.Create("DComboBox",first_panel)
	circle_style_listmenu:SetText("Choose eventwheel style")
	circle_style_listmenu:SetSize(150,20)
	circle_style_listmenu:AddChoice("legacy")
	circle_style_listmenu:AddChoice("concentric")
	circle_style_listmenu:AddChoice("alternative")
	function circle_style_listmenu:OnSelect( index, value )
		if value == "legacy" then
			GetConVar("pac_eventwheel_style"):SetString("0")
		elseif value == "concentric" then
			GetConVar("pac_eventwheel_style"):SetString("1")
		elseif value == "alternative" then
			GetConVar("pac_eventwheel_style"):SetString("2")
		end
	end

	local circle_clickmode = vgui.Create("DComboBox",first_panel)
	circle_clickmode:SetText("Choose eventwheel clickmode")
	circle_clickmode:SetSize(160,20)
	circle_clickmode:SetPos(150,0)
	circle_clickmode:AddChoice("clickable and activates on close")
	circle_clickmode:AddChoice("not clickable, but activate on close")
	circle_clickmode:AddChoice("clickable, but do not activate on close")
	function circle_clickmode:OnSelect( index, value )
		if value == "clickable and activates on close" then
			GetConVar("pac_eventwheel_clickmode"):SetString("0")
		elseif value == "not clickable, but activate on close" then
			GetConVar("pac_eventwheel_clickmode"):SetString("-1")
		elseif value == "clickable, but do not activate on close" then
			GetConVar("pac_eventwheel_clickmode"):SetString("1")
		end
	end


	local rectangle_style_listmenu = vgui.Create("DComboBox",first_panel)
	rectangle_style_listmenu:SetText("Choose eventlist style")
	rectangle_style_listmenu:SetSize(150,20)
	rectangle_style_listmenu:SetPos(0,20)
	rectangle_style_listmenu:AddChoice("legacy-like")
	rectangle_style_listmenu:AddChoice("concentric")
	rectangle_style_listmenu:AddChoice("alternative")

	function rectangle_style_listmenu:OnSelect( index, value )
		if value == "legacy-like" then
			GetConVar("pac_eventlist_style"):SetString("0")
		elseif value == "concentric" then
			GetConVar("pac_eventlist_style"):SetString("1")
		elseif value == "alternative" then
			GetConVar("pac_eventlist_style"):SetString("2")
		end
	end

	local rectangle_clickmode = vgui.Create("DComboBox",first_panel)
	rectangle_clickmode:SetText("Choose eventlist clickmode")
	rectangle_clickmode:SetSize(160,20)
	rectangle_clickmode:SetPos(150,20)
	rectangle_clickmode:AddChoice("clickable and activates on close")
	rectangle_clickmode:AddChoice("not clickable, but activate on close")
	rectangle_clickmode:AddChoice("clickable, but do not activate on close")
	function rectangle_clickmode:OnSelect( index, value )
		if value == "clickable and activates on close" then
			GetConVar("pac_eventlist_clickmode"):SetString("0")
		elseif value == "not clickable, but activate on close" then
			GetConVar("pac_eventlist_clickmode"):SetString("-1")
		elseif value == "clickable, but do not activate on close" then
			GetConVar("pac_eventlist_clickmode"):SetString("1")
		end
	end

	local rectangle_fontsize = vgui.Create("DComboBox",first_panel)
	rectangle_fontsize:SetText("Eventlist font / height")
	rectangle_fontsize:SetSize(160,20)
	rectangle_fontsize:SetPos(310,20)
	for _,font in ipairs(pace.Fonts) do
		rectangle_fontsize:AddChoice(font)
	end

	function rectangle_fontsize:OnSelect( index, value )
		GetConVar("pac_eventlist_font"):SetString(value)
	end

	local circle_fontsize = vgui.Create("DComboBox",first_panel)
	circle_fontsize:SetText("Eventwheel font size")
	circle_fontsize:SetSize(160,20)
	circle_fontsize:SetPos(310,0)
	for _,font in ipairs(pace.Fonts) do
		circle_fontsize:AddChoice(font)
	end

	function circle_fontsize:OnSelect( index, value )
		GetConVar("pac_eventwheel_font"):SetString(value)
	end

	local customizer_button_box = vgui.Create("DCheckBox",first_panel)
	customizer_button_box:SetTooltip("Show the Customize button when eventwheels are active")
	customizer_button_box:SetSize(20,20)
	customizer_button_box:SetPos(470,0)
	customizer_button_box:SetConVar("pac_eventwheel_show_customize_button")


	local events = {}
	for i,v in pairs(pac.GetLocalParts()) do
		if v.ClassName == "event" then
			local e = v:GetEvent()
			if e == "command" then
				local cmd, time, hide = v:GetParsedArgumentsForObject(v.Events.command)
				local this_event_hidden = v:IsHiddenBySomethingElse(false)
				events[cmd] = cmd
			end
		end

	end

	local names = table.GetKeys( events )
	table.sort(names, function(a, b) return a < b end)

	local copied_color = nil
	local lanes = {}
	local colorpanel
	if LocalPlayer().pac_command_events then
		if table.Count(names) == 0 then
			local error_label = vgui.Create("DLabel", list)
			error_label:SetText("Uh oh, nothing to see here! Looks like you don't have any command events in your outfit!\nPlease go back to the editor.")
			error_label:SetPos(100,200)
			error_label:SetFont("DermaDefaultBold")
			error_label:SetSize(450,50)
			error_label:SetColor(Color(150,0,0))
		end
		for _, name in ipairs(names) do
			local pnl = vgui.Create("DPanel") list:Add(pnl) pnl:SetSize(400,20)
			local btn = vgui.Create("DButton", pnl)

			btn:SetSize(200,25)
			btn:SetText(name)
			btn:SetTooltip(name)


			if pace.command_colors[name] then
				local tbl = string.Split(pace.command_colors[name], " ")
				btn:SetColor(Color(tonumber(tbl[1]),tonumber(tbl[2]),tonumber(tbl[3])))
			end
			local colorbutton = vgui.Create("DButton", pnl)
			colorbutton:SetText("Color")
			colorbutton:SetIcon("icon16/color_wheel.png")
			colorbutton:SetPos(200,0) colorbutton:SetSize(65,20)
			function colorbutton:DoClick()
				if IsValid(colorpanel) then colorpanel:Remove() end
				local clr_frame = vgui.Create("DPanel")
				colorpanel = clr_frame
				function clr_frame:Think()
					if not pace.command_event_menu_opened and not IsValid(master_panel) then self:Remove() end
				end

				local clr_pnl = vgui.Create("DColorMixer", clr_frame)
				if pace.command_colors[name] then
					local str_tbl = string.Split(pace.command_colors[name], " ")
					clr_pnl:SetBaseColor(Color(tonumber(str_tbl[1]),tonumber(str_tbl[2]),tonumber(str_tbl[3])))
				end

				clr_frame:SetSize(300,200) clr_pnl:Dock(FILL)
				clr_frame:SetPos(self:LocalToScreen(0,0))
				clr_frame:RequestFocus()
				function clr_pnl:Think()
					if input.IsMouseDown(MOUSE_LEFT) then

						if not IsValid(vgui.GetHoveredPanel()) then
							self:Remove() clr_frame:Remove()
						else
							if vgui.GetHoveredPanel():GetClassName() == "CGModBase" and not self.clicking then
								self:Remove() clr_frame:Remove()
							end
						end
						self.clicking = true
					else
						self.clicking = false
					end
				end
				function clr_pnl:ValueChanged(col)
					pace.command_colors = pace.command_colors or {}
					pace.command_colors[name] = col.r .. " " .. col.g .. " " .. col.b
					btn:SetColor(col)
				end

			end

			local copypastebutton = vgui.Create("DButton", pnl)
			copypastebutton:SetText("Copy/Paste")
			copypastebutton:SetToolTip("right click to copy\nleft click to paste")
			copypastebutton:SetIcon("icon16/page_copy.png")
			copypastebutton:SetPos(265,0) copypastebutton:SetSize(150,20)
			function copypastebutton:DoClick()
				if not copied_color then return end
				pace.command_colors[name] = copied_color
				btn:SetColor(Color(tonumber(string.Split(copied_color, " ")[1]), tonumber(string.Split(copied_color, " ")[2]), tonumber(string.Split(copied_color, " ")[3])))
			end
			function copypastebutton:DoRightClick()
				for _,tbl in pairs(lanes) do
					if tbl.cmd ~= name then
						tbl.copypaste:SetText("Copy/Paste")
					end
				end
				copied_color = pace.command_colors[name]
				if copied_color then
					self:SetText("copied: " .. pace.command_colors[name])
				else
					self:SetText("no color to copy!")
				end
			end

			local clearbutton = vgui.Create("DButton", pnl)
			clearbutton:SetText("Clear")
			clearbutton:SetIcon("icon16/cross.png")
			clearbutton:SetPos(415,0) clearbutton:SetSize(60,20)
			function clearbutton:DoClick()
				btn:SetColor(Color(0,0,0))
				pace.command_colors[name] = nil
			end

			lanes[name] = {cmd = name, main_btn = btn, color_btn = colorbutton, copypaste = copypastebutton, clear = clearbutton}
		end
	end

	function master_panel:OnRemove()
		gui.EnableScreenClicker(false)
		pace.command_event_menu_opened = nil
		encode_table_to_file("eventwheel_colors", pace.command_colors)
		if pace.event_wheel_list_opened then pac.closeEventSelectionList(true) end
		if pace.event_wheel_opened then pac.closeEventSelectionWheel(true) end
	end

	master_panel:RequestFocus()
	gui.EnableScreenClicker(true)
	pace.command_event_menu_opened = master_panel
end


decode_table_from_file("pac_editor_shortcuts")
decode_table_from_file("pac_editor_partmenu_layouts")
decode_table_from_file("eventwheel_colors")

if not file.Exists("pac_part_categories_experimental.txt", "DATA") then
	file.Write("pac3_config/pac_part_categories_experimental.txt", util.TableToKeyValues(pace.partmenu_categories_experimental))
end
if not file.Exists("pac_part_categories_default.txt", "DATA") then
	file.Write("pac3_config/pac_part_categories_default.txt", util.TableToKeyValues(pace.partmenu_categories_default))
end
decode_table_from_file("pac_part_categories")
pace.partgroups = pace.partgroups or pace.partmenu_categories_default
