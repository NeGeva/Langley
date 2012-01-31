local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF_ThreatBar was unable to locate oUF install.')

local _, class = UnitClass("player")
local PlayerClass = select(2, UnitClass("player"))

--[[
	Elements handled:
	.ThreatBar - StatusBar
	.Text - Text value of threat percentage
	
	Options:
	.Colors - Table of colors to use for threat coloring
	.useRawThreat - Use raw threat percentage instead of normalized
	.usePlayerTarget - Always use the player target to determine threat for non-player units.
					- otherwise will always use the unit's target.
	.maxThreatVal - For use with .useRawThreat.  Allows threat percentage greater than 100.
]]--

local aggroColors = {
	[1] = {0, 1, 0, 1},
	[2] = {1, 1, 0, 1},
	[3] = {1, 0, 0, 1},
}

local function update(self, event, unit)
	if( UnitAffectingCombat(self.unit) ) then
		local _, _, threatpct, rawthreatpct, _ = UnitDetailedThreatSituation(self.unit, self.tar)
		
		if( self.useRawThreat ) then
			threatval = rawthreatpct or 0
		else
			threatval = threatpct or 0
		end
		
		self:SetValue(threatval)
		if( self.Text ) then
			self.Text:SetFormattedText("%3.1f", threatval)
		end
--[[
		if( threatval < 30 ) then
			self:SetStatusBarColor(unpack(self.Colors[1]))
		elseif( threatval >= 30 and threatval < 70 ) then
			self:SetStatusBarColor(unpack(self.Colors[2]))
		else
			self:SetStatusBarColor(unpack(self.Colors[3]))
		end
--]]
		--update bar Filling
		self.Filling:SetPoint("BOTTOMLEFT",0,0)
	
		local d
		if (threatval <= 100) then
			d = threatval/100
		elseif (threatval > 100) then
			d = 100
		end
	
		self.Filling:SetWidth(math.abs(d)*80)
		self.Filling:SetTexCoord(0, math.abs(d)*80/128, 0, 1)
		
		if( threatval < 30 ) then
			self.Filling:SetVertexColor(unpack(self.Colors[1]))
		elseif( threatval >= 30 and threatval < 70 ) then
			self.Filling:SetVertexColor(unpack(self.Colors[2]))
		else
			self.Filling:SetVertexColor(unpack(self.Colors[3]))
		end
	end
end

local function enable(self)
	local bar = self.ThreatBar
	if( bar ) then
		bar:Hide()
		bar:SetMinMaxValues(0, bar.maxThreatVal or 100)

		self:RegisterEvent("PLAYER_REGEN_ENABLED", function(self) self.ThreatBar:Hide() end)
		self:RegisterEvent("PLAYER_REGEN_DISABLED", function(self) self.ThreatBar:Show() end)
		
		bar:SetScript("OnUpdate", update)-----------------
		
		bar.Colors = (self.ThreatBar.Colors or aggroColors)
		bar.unit = self.unit
		
		if( self.usePlayerTarget ) then
			bar.tar = "playertarget"
		else
			bar.tar = bar.unit.."target"
		end

		return true
	end
end

local function disable(self)
	local bar = self.ThreatBar
	if( bar ) then
		bar:UnregisterEvent("PLAYER_REGEN_ENABLED")
		bar:UnregisterEvent("PLAYER_REGEN_DISABLED")
		bar:Hide()
		bar:SetScript("OnEvent", nil)
	end
end

-- Create the Backdrop
local function SetBackdrop(self, inset_l, inset_r, inset_t, inset_b)
	self:SetBackdrop {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", 
		tile = false, tileSize = 0, 
		insets = {left = -inset_l, right = -inset_r, top = -inset_t, bottom = -inset_b},
		}
	self:SetBackdropColor(0,0,0,1)
end

function createThreatBar(self)
	if self.mystyle == "player"  then	
		self.ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', UIParent)
		self.ThreatBar:SetPoint("BOTTOMLEFT", self.Power, "TOPLEFT", -19,9)
		self.ThreatBar:SetHeight(16)
		self.ThreatBar:SetWidth(128)
	
		self.ThreatBar:SetStatusBarTexture(ns.Tex.Bar.Blank)
		self.ThreatBar:SetFrameLevel(1)
		--SetBackdrop(self.ThreatBar, 2, 2, 2, 2)
		--self.ThreatBar:SetBackdropColor(0, 0, 0, 0.2)
		
		--filling--
		self.ThreatBar.Filling = self.ThreatBar:CreateTexture(nil, "ARTWORK")
		self.ThreatBar.Filling:SetTexture(cfg.WARNING)
		self.ThreatBar.Filling:SetPoint("BOTTOMLEFT",0,0)
		self.ThreatBar.Filling:SetWidth(128)
		self.ThreatBar.Filling:SetHeight(16)
	
		--helper--
		local h = CreateFrame("Frame", nil, s)
		h:SetAllPoints(self.ThreatBar)
		h:SetFrameLevel(2)
	
		--self.ThreatBar.Text = self.ThreatBar:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
		self.ThreatBar.Text = self.ThreatBar:CreateFontString(nil, 'OVERLAY')
		self.ThreatBar.Text:SetFont(cfg.NumbFont, cfg.NumbFontS,  cfg.NumbFontF)
		--self.ThreatBar.Text:SetShadowColor(0,0,0,1)
		self.ThreatBar.Text:SetPoint('RIGHT', self.ThreatBar, "LEFT", -20,0)
--[[		
		--overlay
		self.ThreatBar.o = self.ThreatBar:CreateTexture(nil, "OVERLAY")
		self.ThreatBar.o:SetTexture(cfg.txt_tex)
		self.ThreatBar.o:SetAllPoints(self.ThreatBar)
		self.ThreatBar.o:SetTexture(0,0,0,1)
--]]		
		self.ThreatBar.useRawThreat = false
	end
end

oUF:AddElement("ThreatBar", function() return end, enable, disable)