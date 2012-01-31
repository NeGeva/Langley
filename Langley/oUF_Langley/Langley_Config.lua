
--- ----------------------------------
--> INIT
--- ----------------------------------

local addon, ns = ...
local oUF = oUFLangley or oUF
assert(oUF, "oUF_Langley was unable to locate oUF install.")

ns.Tex = {}
ns.Cfg = {}
ns.Lib = {}

local U = {

--- ----------------------------------
--> Config
--- ----------------------------------

["Player"] = {
	["Switch"] = true,
	["Position"] = {"TOP","UIParent","BOTTOM", -220, 320},
	["ShowAura"] = false,
	["ShowDebuff"] = true,
},

["Target"] = {
	["Switch"] = true,
	["Position"] = {"TOP","UIParent","BOTTOM", 220, 320},
},

["ToT"] = {
	["Switch"] = true,
	["Position"] = {"TOPRIGHT", "oUF_Langley_TargetFrame", "BOTTOMRIGHT", 6, -28},
},

["Focus"] = {
	["Switch"] = true,
	["Position"] = {"TOP", "UIParent", "TOP", -280, -30},
	["FocusTarget"] = {
		["Switch"] = true,
		["Position"] = {"TOPLEFT", "oUF_Langley_FocusFrame", "TOPRIGHT", 10, 0},
	},
	["FocusTarget"] = {"TOPLEFT", "oUF_Langley_FocusFrame", "BOTTOMLEFT", 10, -10} 
},

["Pet"] = {
	["Switch"] = true,
	["Position"] = {"TOPRIGHT", "oUF_Langley_PlayerFrame", "TOPLEFT", -8-180, 0},
},

["Boss"] = {
	["Switch"] = true,
	["Position"] = {"TOPLEFT", "oUF_Langley_TargetFrame", "TOPRIGHT", 8+180, 0},
	["Spacing"] = 20,
},

["Party"] = {
	["Switch"] = {
		["ShowParty"] = true,
		["ShowPartyInSolo"] = true,
		["ShowPartyPet"] = false,
		["ShowPartyTarget"] = true,
	},
	["Width"] = 16,
	["Height"] = 47,
},

["Raid"] = {
	["Switch"] = {
		["ShowRaid"] = true,
		["ShowRaid40"] = false,
		["ShowRaidInSolo"] = true,
		["ShowRaidInParty"] = true,
		["ShowRaidBg"] = false,
	},
	["Size"] = {
		["Width"] = 60,
		["Height"] = 24,
		["Spacing"] = 4,
	},
	["Indicator"] = {
		["DebuffSize"] = 11,
		["LeaderIcons"] = true,
		["HealPrediction"] = true,
		["AuraStatus"] = {
			["Switch"] = true,
			["FontSize"] = 7,
			["Update"] = 0.25,
		},
	},
	["Position"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 85},
},

["Aura"] = {
	["AuraTimer"] = true,
	["HideAuraTimer"] = 300,
	["Size"] = 20,
	["HeightMulti"] = 1,
},

["AuraWatcher"] = {
	["Gap"] = 4,
	["ColorByDebuff"] = true,
	["Spark"] = true,
	["InvertSorting"] = false,
	["ForTarget"] = true,
},

["FCS"] = {	--Fire Control System
	["CastBar"] = true,
	["ComboPoints"] = true,
	["SwingBar"] = false,
	["Warning"] = {
		["Switch"] = true,
		["Position"] = {"CENTER", UIParent, "CENTER", 0,-150},
	},
},

["CastBar"] = {
	["Position"] = {
		["Player"] = {"CENTER",UIParent,"CENTER", 0,-120},
		["Target"] = {"CENTER",UIParent,"CENTER",10,120},
		["Pet"] = {"CENTER",UIParent,"CENTER", 0,-120},
		["Focus"] = {"TOP", "oUF_Langley_FocusFrame", "BOTTOM", 0, 0},
		["Boss"] = {"CENTER",UIParent,"CENTER",10,100},
	},
},

["Font"] = {
	["Name"] = {
		["Size"] = 10,
		["Outline"] = "THINOUTLINE MONOCHROME",
	},
	["Number"] = {
		["Size"] = 9,
		["Outline"] = "THINOUTLINE MONOCHROME",
	},
	["Percent"] = {
		["Size"] = 13,
		["Outline"] = "THINOUTLINE MONOCHROME",
	},
	["Numberzzz"] = 1,
},
--"THINOUTLINE", "OUTLINE MONOCHROME", "OUTLINE" or nil (no outline)

--- ----------------------------------
--> End
--- ----------------------------------

}

local mediaFolder
if IsAddOnLoaded("Langley") then
	mediaFolder = "Interface\\AddOns\\Langley\\oUF_Langley\\media\\"
	local T, C, L = unpack(select(2, ...))
	ns.Cfg = U
	--ns.Cfg = C.UnitFrame
else
	mediaFolder = "Interface\\AddOns\\oUF_Langley\\media\\"
	ns.Cfg = U
end

-->Texture
ns.Tex = {
	["Langley"] = mediaFolder.."Langley",
	["Line"] = "Interface\\Buttons\\WHITE8x8",
	["Glow"] = mediaFolder.."glowTex",
	["Aura"] = mediaFolder.."dBBorderL",
	["Arrow"] = mediaFolder.."Arrow",
	["Bar"] = {
		["Blank"] = mediaFolder.."blank",
		["Bar"] = mediaFolder.."Bar",
		["BarHP"] = mediaFolder.."BarHP",
		["BarHP_red"] = mediaFolder.."BarHP_red",
		["BarHP_bg1"] = mediaFolder.."BarHP_bg1",
		["BarHP_bg2"] = mediaFolder.."BarHP_bg2",
		["BarPP"] = mediaFolder.."BarPP",
		["BarPP_blue"] = mediaFolder.."BarPP_blue",
		["BarPP_bg1"] = mediaFolder.."BarPP_bg1",
		["BarPP_bg2"] = mediaFolder.."BarPP_bg2",
		["Bar5"] = mediaFolder.."Bar5",
		["Bar5_bg"] = mediaFolder.."Bar5_bg",
		["Bar6"] = mediaFolder.."Bar6",
		["Bar6_bg"] = mediaFolder.."Bar6-bg",
		["BarHP_Screen"] = mediaFolder.."BarHP2_Screen",
		["BarPP_Screen"] = mediaFolder.."BarPP_Screen",
	},
	["Frame"] = {
		["BgLeft"] = mediaFolder.."BgLeft",
		["BgLeft1"] = mediaFolder.."BgLeft1",
		["BgLeft2"] = mediaFolder.."BgLeft2",
		["BgLeft3"] = mediaFolder.."BgLeft3",
		["BgLeft4"] = mediaFolder.."BgLeft4",
		["BgLeft5"] = mediaFolder.."BgLeft5",
		
		["BgRight1"] = mediaFolder.."BgRight1",
		["BgRight2"] = mediaFolder.."BgRight2",
		["BgRight3"] = mediaFolder.."BgRight3",
		["BgRight4"] = mediaFolder.."BgRight4",
	},
	["Sign"] = {
		["Raidicons"] = mediaFolder.."raidicons.blp",
		["HP1"] = mediaFolder.."Sign1",
		["HP2"] = mediaFolder.."Sign2",
		["AT1"] = mediaFolder.."Sign3",
		["AT2"] = mediaFolder.."Sign4",
	},
	["Warning"] = {
		["WarnBg"] = mediaFolder.."WarningBg",
		["Resting"] = mediaFolder.."Warning_resting",
		["Combat"] = mediaFolder.."Warning_combat",
		["HP25"] = mediaFolder.."Warning_hp25",
		["Dead"] = mediaFolder.."Warning_dead",
		["Ghost"] = mediaFolder.."Warning_ghost",
		["Tapped"] = mediaFolder.."Warning_tapped",
		["Offline"] = mediaFolder.."Warning_offline",
		["Rare"] = mediaFolder.."Warning_rare",
		["Rare_Elite"] = mediaFolder.."Warning_rareelite",
		["Elite"] = mediaFolder.."Warning_elite",
		["Boss"] = mediaFolder.."Warning_boss",
		["PvP"] = mediaFolder.."Warning_pvp",
	},
	["Party"] = {
		["Bar"] = mediaFolder.."Party_Bar",
		["BarBg"] = mediaFolder.."Party_BarBg",
		["Bg1"] = mediaFolder.."Party_Bg1",
		["Bg2"] = mediaFolder.."Party_Bg2",
		["Button1"] = mediaFolder.."Party_Button1",
		["Button2"] = mediaFolder.."Party_Button2",
	},
	["Font"] = {
		["Name"] = mediaFolder.."Zfull-GB.ttf",	--Zfull-GB.ttf	--rr_basic05.ttf
		["Number"] = mediaFolder.."rr_basic05.ttf",
		["Percent"] = mediaFolder.."rr_basic05.ttf",
		["Square"] = mediaFolder.."auras.ttf",
		["Timer"] = mediaFolder.."rr_basic05.ttf",
	},
	["CastBar"] = {
		["Left"] = mediaFolder.."CastBar_left",
		["Right"] = mediaFolder.."CastBar_right",
	},
}

-->Color
ns.Tex.Color = {
	["Red"] = {242/255, 48/255, 34/255},
	["Orange"] = {242/255, 127/255, 17/255},
	["Yellow"] = {229/255, 164/255, 69/255},
	["Blue"] = {90/255, 110/255, 153/255},
	["BgColor"] = {0.09, 0.09, 0.09},
	["Hex"] = {
		["Red"] = "|cfff23022",
		["Orange"] = "|cfff27f11",
	},
}
