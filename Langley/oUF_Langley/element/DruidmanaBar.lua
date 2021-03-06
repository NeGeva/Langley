--- ----------------------------------
--> Init
--- ----------------------------------

local addon, ns = ...
local oUF =  oUFLangley or oUF

--- ----------------------------------
--> Function
--- ----------------------------------

--if not oUF then print"oUF_DruidMana: error: oUF not found" return end
if(select(2, UnitClass('player')) ~= 'DRUID') then return end

-- add tag
oUF.Tags['druidmana']  = function() 
	local min, max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)
	if min~=max then 
		return min
	else
		return max
	end
end
oUF.TagEvents['druidmana'] = 'UNIT_POWER UNIT_MAXPOWER'

local UNIT_POWER = function(self, event, unit, powerType)
	if(self.unit ~= unit) then return end

	local druidmana = self.DruidMana

	if(druidmana.PreUpdate) then
		druidmana:PreUpdate(unit)
	end
	local min, max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)

	druidmana.ManaBar:SetMinMaxValues(0, max)
	druidmana.ManaBar:SetValue(min)

	local r, g, b
	if(druidmana.colorClass and UnitIsPlayer(unit)) then
		local t = RAID_CLASS_COLORS['DRUID']
		r, g, b = t['r'], t['g'], t['b']
	elseif(druidmana.colorSmooth) then
		r, g, b = self.ColorGradient(min / max, unpack(oUF.smoothGradient or oUF.colors.smooth))
	else
		local t = PowerBarColor['MANA']
		r, g, b = t['r'], t['g'], t['b']
	end
	if(b) then
		druidmana.ManaBar:SetStatusBarColor(r, g, b)

		local bg = druidmana.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if(druidmana.PostUpdatePower) then
		return druidmana:PostUpdatePower(unit)
	end
end

local UPDATE_VISIBILITY = function(self, event)
	local druidmana = self.DruidMana
	-- check form
	local form = GetShapeshiftFormID()
	if (form == BEAR_FORM or form == CAT_FORM) then
		druidmana:Show()
	else
		druidmana:Hide()
	end
end

local Update = function(self, ...)
	UNIT_POWER(self, ...)
	return UPDATE_VISIBILITY(self, ...)
end

local ForceUpdate = function(element)
	return Update(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
	local druidmana = self.DruidMana
	if(druidmana and unit == 'player') then
		druidmana.__owner = self
		druidmana.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', UNIT_POWER)
		self:RegisterEvent('UNIT_MAXPOWER', UNIT_POWER)
		self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', UPDATE_VISIBILITY)

		return true
	end
end

local Disable = function(self)
	local druidmana = self.DruidMana
	if(druidmana) then
		self:UnregisterEvent('UNIT_POWER', UNIT_POWER)
		self:UnregisterEvent('UNIT_MAXPOWER', UNIT_POWER)
		self:UnregisterEvent('UPDATE_SHAPESHIFT_FORM', UPDATE_VISIBILITY)
	end
end

--- ----------------------------------
--> Creat Druidmana
--- ----------------------------------
function createDruidmana(self)
	local manaBarFrame = CreateFrame("Frame", nil, self)
	manaBarFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	manaBarFrame:SetHeight(4)
	manaBarFrame:SetWidth(self:GetWidth())
	manaBarFrame:SetFrameLevel(4)
	createBGFrame(manaBarFrame, 3)
	
	local ManaBar = CreateFrame('StatusBar', nil, manaBarFrame)
	ManaBar:SetPoint('LEFT', manaBarFrame, 'LEFT', 0, 0)
	ManaBar:SetSize(manaBarFrame:GetWidth(), manaBarFrame:GetHeight())
	ManaBar:SetStatusBarTexture(cfg.hexagon)
	ManaBar:GetStatusBarTexture():SetHorizTile(true)
	ManaBar:SetFrameLevel(5)

	local MBText = setFont(ManaBar, cfg.NumbFont, 10, "OUTLINE", 2)
	MBText:SetPoint('CENTER', ManaBar, 'CENTER', 0, 0)
	self:Tag(MBText, '[druidPower]')

	manaBarFrame.ManaBar = ManaBar
	self.DruidMana = manaBarFrame
end

--- ----------------------------------
--> End
--- ----------------------------------

oUF:AddElement("DruidMana", Update, Enable, Disable)
