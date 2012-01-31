
--- --------------------------
--> Init
--- --------------------------
  
-->get the addon namespace
local addon, ns = ...
local oUF = oUFLangley or oUF

--local cfg = ns.cfg
local tags = ns.tags
--local lib = ns.lib
local Warn = ns.Warn
local Raid = ns.Raid

--- ----------------------------------
--> Style Functions
--- ----------------------------------
local class = select(2, UnitClass("player"))

-->>Colour<<--
colors = setmetatable({
	power = setmetatable({
		["MANA"] = {0.36, 0.45, 0.88},
		["RAGE"] = {0.8, 0.21, 0.31},
		["FUEL"] = {0, 0.55, 0.5},
		["FOCUS"] = {0.71, 0.43, 0.27},
		["ENERGY"] = {0.85, 0.83, 0.35},
		["AMMOSLOT"] = {0.8, 0.6, 0},
		["RUNIC_POWER"] = {0, 0.82, 1},
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	}, {__index = oUF.colors.power}),
	class = setmetatable({
		["DEATHKNIGHT"] = {0.97, 0.22 , 0.33},
		["DRUID"] = {1, 0.49, 0.04},
		["HUNTER"] = {0.58, 0.86, 0.49},
		["MAGE"] = {0, 0.76, 1},
		["PALADIN"] = {1, 0.22, 0.52},
		["PRIEST"] = {0.80, 0.99, 0.99},
		["ROGUE"] = {1, 0.91, 0.2},
		["SHAMAN"] = {0, 0.6, 0.6},
		["WARLOCK"] = {0.6, 0.47, 0.85},
		["WARRIOR"] = {0.9, 0.65, 0.45},
	}, {__index = oUF.colors.class}),
}, {__index = oUF.colors})

reactioncolours = {
	[1] = {255/255, 30/255, 60/255},
	[2] = {255/255, 30/255, 60/255},
	[3] = {255/255, 30/255, 60/255},
	[4] = {1, 1, 0.3},
	[5] = {0.26, 1, 0.22},
	[6] = {0.26, 1, 0.22},
	[7] = {0.26, 1, 0.22},
	[8] = {0.26, 1, 0.22},
}

-->>Update Health<<--
local updateHealth = function(bar, unit, min, max)
	-->Colour<--
	local color, t = {1, 1, 1} 
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = bar:GetParent().colors.class[class]
	else
		t = reactioncolours[UnitReaction(unit, "player")]
	end
	
	if(t) then
		color = {r=t[1], g=t[2], b=t[3]}
	end
	-->GetParent<--
	local parent = bar:GetParent()
	
	-->Filling<--
	bar:SetStatusBarColor(color.r, color.g, color.b, 0)
	--bar.Filling:SetVertexColor(unpack(cfg.HPcolor))
	
	--local lifeact = UnitHealth(unit)
	--local lifemax = UnitHealthMax(unit)
	
	local d, d2, d3
	if max == 0 or min == 0 then
		d = 0.00001
		d2 = 0
		d3 = 0
	else
		d = floor(min/max*10000+1)/10000
		d2 = 1*floor(min/max*10000+0.5)/1000
		d3 = floor(min/max*100)
	end
	
	if parent.mystyle == "player" then
		bar.Filling:SetWidth(128*math.abs(d))
		bar.Filling:SetTexCoord(0, math.abs(d), 0, 1)
	elseif parent.mystyle == "target" then
		bar.Filling:SetWidth(128*math.abs(d))
		bar.Filling:SetTexCoord(math.abs(d-1), 1, 0, 1)
	elseif parent.mystyle == "tot" or parent.mystyle == "boss" then
		bar.Filling:SetWidth(50*math.abs(d)+14)
		bar.Filling:SetTexCoord(math.abs(d-1)*(50/64), 1, 0, 1)
		bar.Filling:SetVertexColor(color.r, color.g, color.b)
	elseif parent.mystyle == "pet" then
		bar.Filling:SetWidth((128-24)*math.abs(d))
		bar.Filling:SetTexCoord(0, math.abs(d)*((128-24)/128), 0, 1)
		--bar.Filling:SetVertexColor(color.r, color.g, color.b)
		--bar.Filling_Bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	elseif parent.mystyle == "focus" then
		bar.Filling:SetWidth((128-24)*math.abs(d))
		bar.Filling:SetTexCoord(0, math.abs(d)*((128-24)/128), 0, 1)
		bar.Filling:SetVertexColor(color.r, color.g, color.b)
		bar.Filling_Bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	elseif parent.mystyle == "party" then
		bar.Filling:SetHeight(47*math.abs(d))
		--bar.Filling:SetTexCoord(0, 1, 0, (math.abs(d)*(47/64)))
		bar.Filling:SetTexCoord(0, 1, math.abs(d-1)*(47/64)+(17/64), 1)
		bar.Filling:SetVertexColor(color.r, color.g, color.b)
		bar.Filling_Bg:SetVertexColor(color.r, color.g, color.b)
	end
end

-->>Update Power<<--
local updatePower = function(bar, unit, min, max)
	-->Colour<--
	local color, t = {1, 1, 1} 
	if(UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = bar:GetParent().colors.class[class]
	else
		t = reactioncolours[UnitReaction(unit, "player")]
	end
	
	if(t) then
		color = {r=t[1], g=t[2], b=t[3]}
	end
	-->GetParent<--
	local parent = bar:GetParent()
	
	-->Filling<--
	bar:SetStatusBarColor(color.r, color.g, color.b, 0)
	
	local d, d2, d3
	if max == 0 or min == 0 then
		d = 0.00001
		d2 = 0
		d3 = 0
	else
		d = floor(min/max*10000+1)/10000
		d2 = 1*floor(min/max*10000+0.5)/1000
		d3 = floor(min/max*100)
	end
	
	if parent.mystyle == "player" then
		bar.Filling:SetWidth(128*math.abs(d))
		bar.Filling:SetTexCoord(0, math.abs(d), 0, 1)
		bar.Filling:SetVertexColor(color.r, color.g, color.b)
		bar.Filling_Bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	elseif parent.mystyle == "target" then
		bar.Filling:SetWidth(50*math.abs(d)+14)
		bar.Filling:SetTexCoord(math.abs(d-1)*(50/64), 1, 0, 1)
		bar.Filling:SetVertexColor(color.r, color.g, color.b)
		bar.Filling_Bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	elseif parent.mystyle == "pet" then
		bar.Filling:SetWidth(43*math.abs(d))
		bar.Filling:SetTexCoord(0, math.abs(d)*(43/64), 0, 1)
		--bar.Filling:SetVertexColor(color.r, color.g, color.b)
		--bar.Filling_Bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	elseif parent.mystyle == "focus" then
		bar.Filling:SetWidth(43*math.abs(d))
		bar.Filling:SetTexCoord(0, math.abs(d)*(43/64), 0, 1)
		bar.Filling:SetVertexColor(color.r, color.g, color.b)
		bar.Filling_Bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	end
end

-->>Update RaidPower<<--
local updateRaidPower = function(bar, unit, min, max)
	local parent = bar:GetParent()
	local powerType,_ = UnitPowerType(parent.unit)
	if powerType ~= 0 then
		bar:Hide()
	else
		bar:Show()
	end
	--local powerType, powerTypeString = UnitPowerType(parent.unit)
	--print(powerType)
	--print(powerTypeString)
end

-->>genStyle<<--
local function genStyle(self)
	ns.Lib.init(self)
    --ns.Lib.moveme(self)
	ns.Lib.shift_focus(self)
	
	ns.Lib.gen_hpbar(self)
	ns.Lib.gen_ppbar(self)
	
	ns.Lib.gen_hpstrings(self)
	ns.Lib.gen_ppstrings(self)
	self.colors = colors
end

local function genStyle_player_target(self)
	self.Health.PostUpdate = updateHealth
	self.Health.frequentUpdates = true
	
	self.Power.PostUpdate = updatePower
	self.Power.frequentUpdates = true
	--[[
	self.Health.colorClass = true
	self.Health.colorTapping = true
    self.Health.colorDisconnected = true
    self.Health.colorHappiness = true
    self.Health.colorReaction = true
	self.Health.bg.multiplier = 0.0
	--self.Power.colorPower = true
	--self.Power.colorClass = true
	--self.Power.colorTapping = true
    --self.Power.colorDisconnected = true
    --self.Power.colorHappiness = true
	--self.Power.colorReaction = true
    self.Power.bg.multiplier = 0.0
	--]]
end

local function genStyle_others(self)
	self.Health.PostUpdate = updateHealth
	self.Power.PostUpdate = updatePower
end

--- ----------------------------------
--> Style
--- ----------------------------------

-->>The Player Style<<--
local function CreatePlayerStyle(self, unit, isSingle)
	--style specific stuff
	self:SetSize(128+16, 32)
	self:SetScale(1)
	self.mystyle = "player"
	
	genStyle(self)
	genStyle_player_target(self)
	
	if ns.Cfg.FCS.CastBar then
		ns.Lib.gen_castbar(self)
		ns.Lib.gen_mirrorcb(self)
	end	
	--ns.Lib.createBuffs(self)
	ns.Lib.createDebuffs(self)
	ns.Lib.gen_InfoIcons(self)
	ns.Lib.gen_RaidMark(self)
	
	--Specific stuff
	ns.Lib.gen_Runes(self)
	ns.Lib.gen_CPoints(self)
	ns.Lib.TotemBars(self)
	ns.Lib.gen_HolyPower(self)
	ns.Lib.gen_Shards(self)
	ns.Lib.gen_EclipseBar(self)
	ns.Lib.gen_FCS(self)
	
	--createThreatBar(self)
	--createSwingBar(self)
	createAuraWatchers(self)
	Warn.HP(self)
	Warn.Player(self)
end  
  
-->>The Target Style<<--
local function CreateTargetStyle(self, unit, isSingle)
    --style specific stuff
    self:SetSize(128+16, 32)
    self:SetScale(1)
    self.mystyle = "target"
    genStyle(self)
	genStyle_player_target(self)
 
    if ns.Cfg.FCS.CastBar then
		ns.Lib.gen_castbar(self)
		--CreateCastBar(self)
	end

    ns.Lib.createAuras(self)
	ns.Lib.gen_InfoIcons(self)
	ns.Lib.gen_RaidMark(self)
	ns.Lib.shift_focus(self)
	--self.Range = {insideAlpha = 1, outsideAlpha = 0.4}
	--ns.Lib.gen_spellrange(self)
	if ns.Cfg.AuraWatcher.ForTarget then
		createAuraWatchers(self)
	end
	Warn.HP(self)
	Warn.Target(self)
end  
  
-->>The ToT Style<<--
local function CreateToTStyle(self)
    --style specific stuff
    self:SetSize(50+16, 16)
    self:SetScale(1)
    self.mystyle = "tot"
    genStyle(self)
    genStyle_others(self)
    ns.Lib.createDebuffs(self)
	ns.Lib.gen_InfoIcons(self)
	ns.Lib.gen_RaidMark(self)
	--ns.Lib.shift_focus(self)
	--ns.Lib.gen_spellrange(self)
end 

-->>The Focus Style<<--
local function CreateFocusStyle(self, unit, isSingle)
    -->style specific stuff
    self:SetSize(80, 16)
    self:SetScale(1)
    self.mystyle = "focus"
    genStyle(self)
    genStyle_others(self)
    if ns.Cfg.FCS.CastBar then
		ns.Lib.gen_castbar(self)
	end
    --ns.Lib.gen_portrait(self)
	--ns.Lib.gen_ppstrings(self)
	--ns.Lib.createAuras(self)
    ns.Lib.createDebuffs(self)
	ns.Lib.gen_InfoIcons(self)
	ns.Lib.gen_RaidMark(self)
	--ns.Lib.shift_focus(self)
	--ns.Lib.gen_spellrange(self)
	--plugins--
	--SpellRange(self)
end  

-->>The Focus Target Style<<--
local function CreateFocusTargetStyle(self)
    -->style specific stuff
    self:SetSize(64, 16)
    self:SetScale(1)
    self.mystyle = "focustarget"
    ns.Lib.init(self)
	ns.Lib.shift_focus(self)
	self.colors = colors
	
	ns.Lib.Focus_Target_Tag(self)
    ns.Lib.createDebuffs(self)
	ns.Lib.gen_InfoIcons(self)
	ns.Lib.gen_RaidMark(self)
	ns.Lib.shift_focus(self)
	--ns.Lib.gen_spellrange(self)
end 

-->>The Pet Style<<--
local function CreatePetStyle(self, unit, isSingle)
    -->style specific stuff
    self:SetSize(128-24, 16)
    self:SetScale(1)
    self.mystyle = "pet"
    genStyle(self)
    genStyle_others(self)
    if ns.Cfg.FCS.CastBar then
		--ns.Lib.gen_castbar(self)
	end
    ns.Lib.createDebuffs(self)
	--[[
	if (isSingle) then 
		self:SetSize(self.width,self.height)
	end
	--]]
end  

-->>The Pet Target Style<<--
local function CreateFocusTargetStyle(self)
    -->style specific stuff
    self:SetSize(64, 16)
    self:SetScale(1)
    self.mystyle = "pettarget"
    ns.Lib.init(self)
	ns.Lib.shift_focus(self)
	--ns.Lib.gen_hpbar(self)
	self.colors = colors
	
	ns.Lib.Focus_Target_Tag(self)
	ns.Lib.shift_focus(self)
end 

-->>The Boss Style<<--
local function CreateBossStyle(self, unit, isSingle)
	self:SetSize(50+16, 16)
    self:SetScale(1)
	self.mystyle = "boss"
	genStyle(self)
    genStyle_others(self)
    ns.Lib.createDebuffs(self)
	self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.6}
	if ns.Cfg.FCS.CastBar then
		ns.Lib.gen_castbar(self)
	end
	--ns.Lib.AltPowerBar(self)
end

-->>The Party Style<<--
local function CreatePartyStyle(self)
	--style specific stuff
	self:SetSize(16, 47)
	self:SetScale(1)
	self.mystyle = "party"
	ns.Lib.init(self)
	ns.Lib.shift_focus(self)
	
	ns.Lib.gen_hpbar(self)
	
	self.colors = colors
	self.Health.PostUpdate = updateHealth
	self.Health.frequentUpdates = true
	self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.6}
    --ns.Lib.createDebuffs(self)
	ns.Lib.gen_InfoIcons(self)
	ns.Lib.gen_RaidMark(self)
	ns.Lib.Party_Tag(self)
end

-->>The Party Pet Style<<--
local function CreatePartyPetStyle(self, unit, isSingle)
    -->style specific stuff
	self:SetSize(cfg.partypet_width, cfg.partypet_height)
    self:SetScale(1)
    self.mystyle = "partypet"
	genStyle(self)
	self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.6}
    --self.Health.frequentUpdates = true
    --self.Health.colorDisconnected = true
    --self.Health.colorHappiness = true
    self.Health.colorClass = true
    self.Health.colorReaction = true
    --self.Health.colorHealth = true
    self.Health.bg.multiplier = 0.0
    --self.Power.colorPower = true
	self.Power.colorClass = true
    --self.Power.bg.multiplier = 0.0
    --ns.Lib.gen_portrait(self)
    ns.Lib.createDebuffs(self)
end  

-->>The Party Targets Style<<--
local function CreatePartyTargetStyle(self)
    -->style specific stuff
    self:SetSize(80, ns.Cfg.Font.Name.Size+2)
	self:SetScale(1)
    self.mystyle = "partytarget"
	ns.Lib.init(self)
	ns.Lib.shift_focus(self)
	--ns.Lib.gen_hpbar(self)
	self.colors = colors
	ns.Lib.Party_Target_Tag(self)
	self.Range = {
            insideAlpha = 1,
            outsideAlpha = 0.6}
end  

-->>The Raid Style<<--
local function CreateRaidStyle(self)
    self:SetSize(ns.Cfg.Raid.Size.Width, ns.Cfg.Raid.Size.Height)
    self:SetScale(1)
    self.mystyle = "raid"
    ns.Lib.init(self)
	self.colors = colors
	Raid.gen_hpbar(self)
	Raid.gen_ppbar(self)
	Raid.gen_hpstrings(self)
	Raid.gen_elements(self)
	ns.Lib.createDebuffs(self)
	--self.colors.smooth = {1,0,0, 176/255,48/255,96/255, 0.1,0.1,0.1}
	
	self.Health.colorClass = true
	self.Health.colorDisconnected = true
	self.Health.colorReaction = true
	self.Power.colorPower = true
	self.Health.bg.multiplier = 0.4
	self.Power.bg.multiplier = 0.4
	
	self.Health.frequentUpdates = true
	
	self.Power.PostUpdate = updateRaidPower
	self.Power.frequentUpdates = true
	
	--ns.Lib.gen_spellrange(self)
	self.Range = {insideAlpha = 1, outsideAlpha = 0.4}
	
	Raid.CreateThreatBorder(self)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", Raid.UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", Raid.UpdateThreat)
	
	if ns.Cfg.Raid.Switch.ShowRaidBg then 
		--Raid.gen_background(self) 
	end
end 

--- ----------------------------------
--> Spawn Units
--- ----------------------------------

if ns.Cfg.Player.Switch then
	oUF:RegisterStyle("oUF_LangleyPlayer", CreatePlayerStyle)
	oUF:SetActiveStyle("oUF_LangleyPlayer")
	local player = oUF:Spawn("player", "oUF_Langley_PlayerFrame")
	player:SetPoint(unpack(ns.Cfg.Player.Position))
	--player:SetScale(1)	
end
  
if ns.Cfg.Target.Switch then
    oUF:RegisterStyle("oUF_LangleyTarget", CreateTargetStyle)
    oUF:SetActiveStyle("oUF_LangleyTarget")
    local target = oUF:Spawn("target", "oUF_Langley_TargetFrame")  
	target:SetPoint(unpack(ns.Cfg.Target.Position))
	--target:SetScale(1)
end

if ns.Cfg.ToT.Switch then
    oUF:RegisterStyle("oUF_LangleyToT", CreateToTStyle)
    oUF:SetActiveStyle("oUF_LangleyToT")
    local tot = oUF:Spawn("targettarget", "oUF_Langley_ToTFrame")
	tot:SetPoint(unpack(ns.Cfg.ToT.Position))
	--tot:SetScale(1)
end

if ns.Cfg.Focus.Switch then
    oUF:RegisterStyle("oUF_LangleyFocus", CreateFocusStyle)
    oUF:SetActiveStyle("oUF_LangleyFocus") 
    local focus = oUF:Spawn("focus", "oUF_Langley_FocusFrame")  
	focus:SetPoint(unpack(ns.Cfg.Focus.Position))
	--focus:SetScale(1)
	
    oUF:RegisterStyle("oUF_LangleyFocusTarget", CreateFocusTargetStyle)	
	oUF:SetActiveStyle("oUF_LangleyFocusTarget")
	local focust = oUF:Spawn("focustarget", "oUF_Langley_FocusFrame")
	focust:SetPoint(unpack(ns.Cfg.Focus.FocusTarget))
	--focust:SetScale(1)
end

if ns.Cfg.Pet.Switch then
    oUF:RegisterStyle("oUF_LangleyPet", CreatePetStyle)
    oUF:SetActiveStyle("oUF_LangleyPet")
 	local pet = oUF:Spawn("pet", "oUF_Langley_PetFrame")
	pet:SetPoint(unpack(ns.Cfg.Pet.Position))
	--pet:SetScale(1)
end

-->>BOSS Frames<<--
if ns.Cfg.Boss.Switch then
	oUF:RegisterStyle("oUF_LangleyBoss", CreateBossStyle)
	oUF:SetActiveStyle("oUF_LangleyBoss")
	local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn("boss"..i, "oUF_Langley_Boss"..i)
			if i == 1 then
				boss[i]:SetPoint(unpack(ns.Cfg.Boss.Position))
			else
				boss[i]:SetPoint("BOTTOM", boss[i-1], "TOP", 0, ns.Cfg.Boss.Spacing)
		end
	end
end

-->>Party Frames<<--
oUF:RegisterStyle("oUF_LangleyParty", CreatePartyStyle)
oUF:RegisterStyle("oUF_LangleyPartyPet", CreatePartyPetStyle)
oUF:RegisterStyle("oUF_LangleyPartyTarget", CreatePartyTargetStyle)

--local visible = 'custom [group:party,nogroup:raid][@raid6,noexists,group:raid] show;hide'
local visible = 'party,raid,solo'
if ns.Cfg.Party.Switch.ShowParty then
	oUF:SetActiveStyle("oUF_LangleyParty")
	local party = oUF:SpawnHeader("oUF_Party", nil, visible,
		"showParty", true,
		--"showRaid", true,
		--"showPlayer", true,
		"showSolo", ns.Cfg.Party.Switch.ShowPartyInSolo,
		--"template","oUF_partypet",
		"point", "TOP",
		--'xOffset', cfg.party_spacing,
		"yOffset", 9)
	party:SetPoint("TOPLEFT", "UIParent", "LEFT", 0, 2*ns.Cfg.Party.Height)
end

if ns.Cfg.Party.Switch.ShowPartyPet and oUF_Party:IsVisible() then
    oUF:SetActiveStyle("oUF_LangleyPartyPet")
    local partypet = {}
    for i = 1, 4 do
        partypet[i] = oUF:Spawn('partypet'..i, 'oUF_PartyPet'..i)
        if i == 1 then
            partypet[i]:SetPoint('TOPRIGHT', oUF_Party, 'TOPLEFT', -10, 0)
        else
            partypet[i]:SetPoint('TOP', partypet[i-1], 'BOTTOM', 0, -9)
        end
    end
end

if (ns.Cfg.Party.Switch.ShowPartyTarget and oUF_Party:IsVisible()) then
	oUF:SetActiveStyle("oUF_LangleyPartyTarget")
	local partytarget = {}
	local partyMembers = GetNumPartyMembers()
    for i = 1, 4 do
		partytarget[i] = oUF:Spawn("party"..i.."target", "oUF_Party"..i.."target")
		--
		if i == 1 then
			partytarget[i]:SetPoint("TOPLEFT", oUF_Party, "TOPRIGHT", 0, -ns.Cfg.Party.Height*0.5)
		else
			partytarget[i]:SetPoint('TOP', partytarget[i-1], 'TOP', 0, -ns.Cfg.Party.Height+9)
		end
		--
		--partytarget[i]:SetPoint("TOPLEFT", "oUF_PartyUnitButton"..i, "RIGHT", 0, 0)
	end
end

-->>Raid Frames<<--
if ns.Cfg.Raid.Switch.ShowRaid then
	local visible_raid = "raid"
	if (ns.Cfg.Raid.Switch.ShowRaidInParty and ns.Cfg.Raid.Switch.ShowRaidInSolo) then
		visible_raid = "party,raid,solo"
	else
		if ns.Cfg.Raid.Switch.ShowRaidInParty then
			visible_raid = "party,raid"
		elseif ns.Cfg.Raid.Switch.ShowRaidInSolo then
			visible_raid = "raid,solo"
		else
			visible_raid = "raid"
		end
	end
	oUF:RegisterStyle("oUF_LangleyRaid", CreateRaidStyle)
	oUF:SetActiveStyle("oUF_LangleyRaid")
	local raid = oUF:SpawnHeader('oUF_Raid', nil, visible, 
		'showRaid', true,
		'showParty', true,
		'showPlayer', true,
		'showSolo', ns.Cfg.Raid.Switch.ShowRaidInSolo,
		'sortMethod', 'INDEX',	--'INDEX','NAME',
		'groupFilter', '1,2,3,4,5',
		'groupingOrder', '1,2,3,4,5',
		'groupBy', 'GROUP',
		'maxColumns', 5,
		'unitsPerColumn', 5,
		'column', 4,
		'columnSpacing', 4,
		'columnAnchorPoint', 'LEFT',
		'sortDir', 'ASC',	--'ASC','DESC',升序，降序
		--'point', 'TOP',
		'xOffset', ns.Cfg.Raid.Size.Spacing,
		'yOffset', -ns.Cfg.Raid.Size.Spacing)
	raid:SetPoint(unpack(ns.Cfg.Raid.Position))
end

--- ----------------------------------
--> Slash
--- ----------------------------------
--[[
-->Reload UI<--
SlashCmdList.RELOADUI = ReloadUI
SLASH_RELOADUI1 = "/rl"
--]]
-->TestUI Take from Qulight<--
local testlangley = TestLangley or function() end

TestLangley = function(msg)
	if msg == "boss" then
		oUF_Langley_Boss1:Show(); oUF_Langley_Boss1.Hide = function() end; oUF_Langley_Boss1.unit = "player"
		oUF_Langley_Boss2:Show(); oUF_Langley_Boss2.Hide = function() end; oUF_Langley_Boss2.unit = "player"
		oUF_Langley_Boss3:Show(); oUF_Langley_Boss3.Hide = function() end; oUF_Langley_Boss3.unit = "player"
		oUF_Langley_Boss4:Show(); oUF_Langley_Boss4.Hide = function() end; oUF_Langley_Boss4.unit = "player"
	elseif msg == "party" then
		oUF_Party:Show(); oUF_Party.Hide = function() end; oUF_Party.unit = "player"
		--oUF_PartyUnitButton1 
	--[[
	elseif msg == "arena" then
		ElvDPSArena1:Show(); ElvDPSArena1.Hide = function() end; ElvDPSArena1.unit = "player"
		ElvDPSArena2:Show(); ElvDPSArena2.Hide = function() end; ElvDPSArena2.unit = "player"
		ElvDPSArena3:Show(); ElvDPSArena3.Hide = function() end; ElvDPSArena3.unit = "player"
		ElvDPSArena4:Show(); ElvDPSArena4.Hide = function() end; ElvDPSArena4.unit = "player"
		ElvDPSArena5:Show(); ElvDPSArena5.Hide = function() end; ElvDPSArena5.unit = "player"
	--]]
	elseif msg == "pet" then
		oUF_Langley_PetFrame:Show(); oUF_Langley_PetFrame.Hide = function() end; oUF_Langley_PetFrame.unit = "player"
	elseif msg == "raid" then
		oUF_Raid:Show(); oUF_Raid.Hide = function() end; oUF_Raid.unit = "player"
	elseif msg == "buff" then -- better dont test it ^^
		UnitAura = function()
		-- name, rank, texture, count, dtype, duration, timeLeft, caster
		return 139, 'Rank 1', 'Interface\\Icons\\Spell_Holy_Penance', 1, 'Magic', 0, 0, "player"
		end
		if(oUF) then
			for i, v in pairs(oUF.units) do
				if(v.UNIT_AURA) then
					v:UNIT_AURA("UNIT_AURA", v.unit)
				end
			end
		end
	end
end

SlashCmdList.TestLangley = TestLangley
SLASH_TestLangley1 = "/testlangley"