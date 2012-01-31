
--- ----------------------------------
--> Init
--- ----------------------------------

local addon, ns = ...
local oUF = oUFLangley or oUF

local tags = ns.tags
  
local Raid = CreateFrame("Frame")  

local _, playerClass = UnitClass('player')

--- ----------------------------------
--> Function
--- ----------------------------------

-->>Status Bar Filling Fix<<--
local fixStatusbar = function(b)
	b:GetStatusBarTexture():SetHorizTile(false)
	b:GetStatusBarTexture():SetVertTile(false)
end

local CreateShadow = function(f)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(0)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -3, 3)
	shadow:SetPoint("BOTTOMLEFT", -3, -3)
	shadow:SetPoint("TOPRIGHT", 3, 3)
	shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	shadow:SetBackdrop({
		edgeFile = ns.Tex.Glow, 
		edgeSize = 4,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	
	shadow:SetBackdropColor( .05,.05,.05, .9)
	shadow:SetBackdropBorderColor(0.09, 0.09, 0.09, 0.75)
	f.shadow = shadow
	return shadow
end

local frame = function(f)
	if f.frame == nil then
		local frame = CreateFrame("Frame", nil, f)
		frame:SetFrameLevel(20)
		frame:SetFrameStrata(f:GetFrameStrata())
		frame:SetPoint("TOPLEFT", -1, 1)
		frame:SetPoint("BOTTOMLEFT", 1, -1)
		frame:SetPoint("TOPRIGHT", 1, 1)
		frame:SetPoint("BOTTOMRIGHT", 1, 1)
		frame:SetBackdrop({ 
			bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
			edgeFile = "Interface\\Buttons\\WHITE8x8", 
			--tile = false, tileSize = 1, 
			edgeSize = 1,
			--edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		
		frame:SetBackdropColor(.09,.09,.09, 0)
		--frame:SetBackdropBorderColor(unpack(cfg.orange))
		frame:SetBackdropBorderColor(.09,.09,.09, 0.75)
		f.frame = frame
	end
end

--- ----------------------------------
--> Main
--- ----------------------------------
	
-->debuff highlight
local CanDispel = {
	PRIEST = { Magic = true, Disease = true, },
	SHAMAN = { Magic = true, Curse = true},
	PALADIN = { Magic = true, Poison = true, Disease = true, },
	MAGE = { Curse = true, },
	DRUID = { Magic = true, Curse = true, Poison = true},
}
local dispellist = CanDispel[playerClass] or {}

local ChangedTarget = function(self)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:SetBackdropColor(.8, .8, .8, 1)
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end

local FocusTarget = function(self)
	if UnitIsUnit('focus', self.unit) then
		self.FocusHighlight:SetBackdropColor(cfg.focusHLcol[1], cfg.focusHLcol[2], cfg.focusHLcol[3], cfg.focusHLcol[4])
		self.FocusHighlight:Show()
	else
		self.FocusHighlight:Hide()
	end
end

function Raid.CreateThreatBorder(self)
	local glowBorder = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}
	self.Thtborder = CreateFrame("Frame", nil, self)
	self.Thtborder:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
	self.Thtborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
	self.Thtborder:SetBackdrop(glowBorder)
	self.Thtborder:SetFrameLevel(20)
	self.Thtborder:Hide()	
end

function Raid.UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		self.Thtborder:Show()
		self.Thtborder:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Thtborder:SetBackdropBorderColor(r, g, b, 0)
		self.Thtborder:Hide()
	end
end

-->>Raid Functions<<------
Raid.gen_hpbar = function(f)
	-->statusbar
	--f.colors =colors
	local s = CreateFrame("Statusbar", nil, f)
	s:SetStatusBarTexture(ns.Tex.Bar.Bar)
	--fixStatusbar(s)
	s:SetSize(f:GetWidth(), f:GetHeight())
	s:SetFrameLevel(3)
	s:SetPoint("CENTER",0,0)
	-->helper
    local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",0,0)
    h:SetPoint("BOTTOMRIGHT",0,0)
	frame(h)
	CreateShadow(h)
	
	-->bg
	local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(ns.Tex.Line)
	b:SetAllPoints(s)
	b:SetAlpha(0.6)
	
	f.Health = s
	f.Health.bg = b
end

Raid.gen_ppbar = function(f)
	--f.colors =colors
	local s = CreateFrame("Statusbar", nil, f)
	s:SetStatusBarTexture(ns.Tex.Line)
	--fixStatusbar(s)
	s:SetSize(f:GetWidth()*3/5, f:GetHeight()/10)
	s:SetPoint("BOTTOMLEFT", f.Health, "BOTTOMLEFT", 0, 0)
	s:SetFrameLevel(5)
	
	-->helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
	h:SetAllPoints(s)
	frame(h)

    -->bg
    local b = s:CreateTexture(nil, "BACKGROUND")
	b:SetTexture(ns.Tex.Line)
	b:SetAllPoints(s)
	b:SetAlpha(0.6)
	
	f.Power = s
	f.Power.bg = b
end

Raid.gen_hpstrings = function(f, unit)
	local h = CreateFrame("Frame", nil, f)
	h:SetAllPoints(f.health)
	h:SetFrameLevel(10)
	
	local name = ns.Lib.gen_fontstring(h, ns.Tex.Font.Name, 9, ns.Cfg.Font.Name.Outline)	
	name:SetPoint("BOTTOM", f.Health, "BOTTOM", 0, f:GetHeight()/3)
	--name:SetPoint("CENTER", f.Health, "CENTER", 0, 0)
	--name:SetShadowOffset(0.25, -0.25)
	name:SetJustifyH("CENTER")
	name.overrideUnit = true
	name:SetAlpha(0.8)

	local hp_value = ns.Lib.gen_fontstring(h, ns.Tex.Font.Number, 7, ns.Cfg.Font.Number.Outline)
	hp_value:SetPoint("TOP", f.Health, "TOP", 0,0)
	hp_value:SetShadowOffset(0.25, -0.25)
	hp_value:SetJustifyH("CENTER")
	hp_value.overrideUnit = true
	
	f:Tag(name, '[raidcolor][raidname]')
	--f:Tag(hp_value, '[raidcolor][raidhp][afkdnd]')
end

Raid.gen_elements = function(f)
	-->container
	local container = CreateFrame("Frame", nil, f)
	container:SetAllPoints(f)
	container:SetFrameLevel(10)
	
	-->Debuffs
	local debuffs = CreateFrame("Frame", nil, f)
	debuffs:SetWidth(ns.Cfg.Raid.Indicator.DebuffSize)
	debuffs:SetHeight(ns.Cfg.Raid.Indicator.DebuffSize)
    debuffs:SetPoint("BOTTOMLEFT", 0, 1)
    debuffs.size = ns.Cfg.Raid.Indicator.DebuffSize
	debuffs.CustomFilter = CustomFilter
    f.raidDebuffs = debuffs

	-->Leader/Assistant/ML Icons
    if ns.Cfg.Raid.Indicator.LeaderIcons then
		li = container:CreateTexture(nil, "OVERLAY")
		li:SetPoint("TOPLEFT", f, 0, 6)
		li:SetSize(12,12)
		li:SetAlpha(0.75)
		f.Leader = li
		
		ai = container:CreateTexture(nil, "OVERLAY")
		ai:SetPoint("TOPLEFT", f, 0, 6)
		ai:SetSize(12,12)
		ai:SetAlpha(0.75)
		f.Assistant = ai
		
		local ml = container:CreateTexture(nil, 'OVERLAY')
		ml:SetSize(12,12)
		ml:SetPoint('LEFT', f.Leader, 'RIGHT')
		f.MasterLooter = ml
	end
	
	-->Raid Icon
    local ri = container:CreateTexture(nil,'OVERLAY')
	ri:SetTexture(ns.Tex.Sign.Raidicons)
    ri:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 5)
    ri:SetSize(13, 13)
    f.RaidIcon = ri
	
	-->LFD Icon
	--[[
	local lfdi = ns.Lib.gen_fontstring(f.Health, cfg.NumbFontF, 9, cfg.NumbFontF)
	lfdi:SetPoint("LEFT", f.Health, "LEFT",0,3)
	lfdi:SetShadowOffset(1.25, -1.25)
	f:Tag(lfdi, '[negeva_LFD]')
	--]]
	local rl = f.Health:CreateTexture(nil, 'OVERLAY')
	rl:SetSize(12,12)
	rl:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", 0,0)
	f.LFDRole = rl
	
	-->Enable Indicators
	f.Indicators = true
	
	--[[
	-- Healing prediction--
	if cfg.healbar then
		local ohpb = CreateFrame('StatusBar', nil, f.Health)
		ohpb:SetPoint('TOPLEFT', f.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		ohpb:SetPoint('BOTTOMLEFT', f.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		ohpb:SetWidth(cfg.raid_width)
		ohpb:SetStatusBarTexture(cfg.hpbar_texture)
		ohpb:SetStatusBarColor(1, 0.5, 0, cfg.healalpha)
		f.ohpb = ohpb
        
		local mhpb = CreateFrame('StatusBar', nil, f.Health)
		mhpb:SetPoint('TOPLEFT', ohpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
		mhpb:SetPoint('BOTTOMLEFT', ohpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
		mhpb:SetWidth(cfg.raid_width)
		mhpb:SetStatusBarTexture(cfg.hpbar_texture)
		mhpb:SetStatusBarColor(0, 1, 0.5, cfg.healalpha)
		f.mhpb = mhpb

		f.HealPrediction = { myBar = mhpb, otherBar = ohpb, maxOverflow = cfg.healoverflow }
	end
	--]]
end
--[[
Raid.gen_background = function(f)
	local rbg
	if not RaidBG then
		rbg = CreateFrame("frame","RaidBG",UIParent) 
		rbg:SetSize(cfg.raid_width*5+cfg.raid_spacing*3+16, cfg.raid_height*5+cfg.raid_spacing*3+15)
		rbg:SetPoint(cfg.raid_pos[1], cfg.raid_pos[2], cfg.raid_pos[3], cfg.raid_pos[4]-6, cfg.raid_pos[5]+6)
		rbg:SetBackdrop({edgeFile = cfg.backdrop_edge_texture,edgeSize = 5})
		
		rbg.bg = rbg:CreateTexture(nil, "PARENT")
		rbg.bg:SetTexture(cfg.backdrop_texture)
		rbg.bg:SetBlendMode("BLEND")
		rbg.bg:SetPoint("TOPLEFT", rbg, "TOPLEFT", 0, 0);
		rbg.bg:SetPoint("BOTTOMRIGHT", rbg, "BOTTOMRIGHT", 0, 0);
		rbg.bg:SetVertexColor(.15,.15,.15,.75)
		rbg:SetFrameStrata("BACKGROUND") 
		rbg:SetBackdropBorderColor(0,0,0,1)
		rbg:Hide()
		rbg:EnableMouse(true) 
	end
end	
--]]

--- ----------------------------------
--> Indicators Spawn
--- ----------------------------------
oUF.classIndicators={
	["PRIEST"] = {
			["TL"] = "[raid:pom]",
			["TR"] = "[raid:ws][raid:pws]",
			["TR2"] = "[raid:fw][raid:pwb]",
			["BL"] = "[raid:sp][raid:fort]",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "[raid:rnwTime]",
	},
	["DRUID"] = {
			["TL"] = "[raid:wg]",
			["TR"] = "[raid:lb]",
			["TR2"] = "[raid:regrow]",
			["BL"] = "[raid:motw]",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "[raid:rejuvTime]",
		},
	["WARRIOR"] = {
			["TL"] = "",
			["TR"] = "[raid:vigil]",
			["TR2"] = "[raid:SW]",
			["BL"] = "",
			["BR"] = "[raid:stragi]",
			["BR2"] = "",
			["Cen"] = "",
	},
	["DEATHKNIGHT"] = {
			["TL"] = "",
			["TR"] = "",
			["TR2"] = "",
			["BL"] = "[raid:how]",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "",
	},
	["SHAMAN"] = {
			["TL"] = "[raid:earth]",
			["TR"] = "",
			["TR2"] = "",
			["BL"] = "",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "[raid:ripTime]",
	},
	["PALADIN"] = {
			["TL"] = "",
			["TR"] = "[raid:beacon]",
			["TR2"] = "[raid:forbearance]",
			["BL"] = "[raid:might]",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "",				
	},
	["WARLOCK"] = {
			["TL"] = "[raid:di]",
			["TR"] = "[raid:ss]",
			["TR2"] = "",
			["BL"] = "",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "",
	},
	["HUNTER"] = {
			["TL"] = "",
			["TR"] = "",
			["TR2"] = "",
			["BL"] = "",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "",
	},
	["ROGUE"] = {
			["TL"] = "",
			["TR"] = "",
			["TR2"] = "",
			["BL"] = "",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "",
	},
	["MAGE"] = {
			["TL"] = "[raid:fmagic]",
			["TR"] = "",
			["TR2"] = "",
			["BL"] = "[raid:int]",
			["BR"] = "",
			["BR2"] = "",
			["Cen"] = "",
	}
}

--- ----------------------------------
--> Handover
--- ----------------------------------

ns.Raid = Raid