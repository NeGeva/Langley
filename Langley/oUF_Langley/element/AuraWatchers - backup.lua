local _, ns = ...
local oUF =  ns.oUF or oUF

local cfg = ns.cfg

local _, class = UnitClass("player")
local PlayerClass = select(2, UnitClass("player"))


--- -----------------------
--> BarTimers
--- -----------------------
function createAuraWatchers(self)
	if self.mystyle == "player"  then		
		self.AuraWatchers = CreateFrame("Frame", self.mystyle.."AuraWatchers", self)
		self.AuraWatchers:SetWidth(cfg.BarTimers_width)
		self.AuraWatchers:SetHeight(cfg.BarTimers_height)
		self.AuraWatchers:SetPoint("BOTTOM", self.Health, "TOP", -20,36)
	elseif self.mystyle == "target" then
		self.AuraWatchers = CreateFrame("Frame", self.mystyle.."AuraWatchers", self)
		self.AuraWatchers:SetWidth(cfg.BarTimers_width)
		self.AuraWatchers:SetHeight(cfg.BarTimers_height)
		self.AuraWatchers:SetPoint("BOTTOM", self.Health, "TOP", 0,36)
	end
end
--[[
-- Create the Backdrop
local function SetBackdrop(self, inset_l, inset_r, inset_t, inset_b)
	self:SetBackdrop {bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = false, tileSize = 0, insets = {left = -inset_l, right = -inset_r, top = -inset_t, bottom = -inset_b},}
	self:SetBackdropColor(0,0,0,1)
end
--]]
--backdrop func------
local backdrop_tab = { 
	bgFile = cfg.backdrop_texture, 
	edgeFile = cfg.backdrop_edge_texture,
	tile = false,--平铺
	tileSize = 0, 
	edgeSize = 1, 
	insets = { 
		left = 1, 
		right = 1, 
		top = 1, 
		bottom = 1,
	},
}

local function colorbackdrop(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0.09,.09,.09,1)
	f:SetBackdropBorderColor(243/255, 151/255, 0, 1)
end

-- Fontstring Function
local createFontstring = function(fr, font, size, outline)
    local fs = fr:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
end

-- Format Time	
local FormatTime = function(t)
	if t >= 86400 then -- Days
		return format("%d|cff999999d|r", floor(t/86400 + 0.5))
	elseif t >= 3600 then -- Hours
		return format("%d|cff999999h|r", floor(t/3600 + 0.5))
	elseif t >= 60 then -- Minutes
		return format("%d|cff999999m|r", floor(t/60 + 0.5))
	elseif t >= 0 then -- Seconds
		return floor(mod(t, 60))
	end
end

--Creates a Bar for the BarTimers
function CreateTimerBar(oUF, point)
	local root = oUF.AuraWatchers
	local bar = CreateFrame("StatusBar", nil, oUF)
	if(root == point) then
		bar:SetPoint("BOTTOMLEFT", root, "BOTTOMLEFT", cfg.BarTimers_height+2, 0)
	else
		bar:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", 0, cfg.BarTimers_height+cfg.BarTimers_Gap)
	end
		bar.Smooth = true
		bar:SetHeight(cfg.BarTimers_height)
		bar:SetWidth(cfg.BarTimers_width or cfg.mainframe_width - cfg.BarTimers_height - 2)-------------------------
		bar:SetStatusBarTexture(cfg.ssbar_texture)
		bar:GetStatusBarTexture():SetHorizTile(false)
		--SetBackdrop(bar, cfg.BarTimers_height+4, 2, 2, 2)
		--bar:SetBackdropColor(0,0,0,0.85)
		--colorbackdrop(bar)
		
		bar.icon = bar:CreateTexture(nil, 'ARTWORK')
		bar.icon:SetHeight(cfg.BarTimers_height)
		bar.icon:SetWidth(cfg.BarTimers_height)
		bar.icon:SetTexCoord(.1, .93, .07, .93)
		bar.icon:SetPoint("TOP")
		bar.icon:SetPoint("LEFT", root)
				
		-- Strings		
		bar.spell = createFontstring(bar, cfg.NameFont, 12, cfg.NameFontF)
		bar.spell:SetTextColor(1, 1, 1)
		bar.spell:SetJustifyH("LEFT")
		bar.spell:SetJustifyV("CENTER")
		bar.spell:SetPoint("LEFT", bar, "LEFT", 4, 0)
		bar.spell:SetHeight(cfg.BarTimers_height)
		
		bar.time = createFontstring(bar, cfg.NumbFont, 12, cfg.NumbFontF)
		bar.time:SetTextColor(1, 1, 1)
		bar.time:SetJustifyH("RIGHT")
		bar.time:SetJustifyV("CENTER")
		bar.time:SetPoint("RIGHT", bar, "RIGHT", -4, -1)
		
		bar.stack = createFontstring(bar, cfg.NumbFont, 12, cfg.NumbFontF)
		bar.stack:SetJustifyH("LEFT")
		bar.stack:SetJustifyV("CENTER")
		bar.stack:SetPoint("LEFT", bar.spell, "RIGHT", 0.5, 0)
		
		if(cfg.BarTimers_spark) then
			bar.spark = bar:CreateTexture(nil, 'OVERLAY')
			bar.spark:SetTexture(spark_texture)
			bar.spark:SetBlendMode('ADD')
			bar.spark:SetHeight(cfg.BarTimers_height+5)
			bar.spark:SetWidth((cfg.BarTimers_height/3)*2)
		end		
	
	-------------------------------------------------------------------------
	local h = CreateFrame("Frame", nil, bar)
	h:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", -2-cfg.BarTimers_height-2,-2)
	h:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 2,2)
	h:SetFrameLevel(0)
	colorbackdrop(h)
	-------------------------------------------------------------------------
	return bar
end

--OnUpdate
function UpdateAuraWatchers(AuraWatchers)
	local bars = AuraWatchers.bars
	local timenow = GetTime()		
	for index = 1, #bars do
		local bar = bars[index]

		if bar.timer.noTime then
			bar.time:SetText()
			if(cfg.BarTimers_spark) then bar.spark:SetPoint("CENTER", bar, "LEFT", -999999, 0) end
		else
			local curTime = bar.timer.expirationTime - timenow
			local timeleft = FormatTime(curTime)
			bar:SetValue(curTime)
			if(cfg.BarTimers_spark and bar.timer.expirationTime > 0) then 
				bar.spark:SetPoint("CENTER", bar, "LEFT", ((curTime) * bar:GetWidth()) / bar.timer.duration, 0) 
			end
			if(timeleft and curTime <= 60) then 
				bar.time:SetText(timeleft.."|cff999999s|r")
			elseif (curTime > 60)then
				bar.time:SetText(timeleft)
			end
		end                     
	end
end
	
--Use QuickSort to Sort Auras/Bars by duration
local qsort = function(a, b)	
	local aux_A, aux_B = a.noTime and math.huge or a.expirationTime, b.noTime and math.huge or b.expirationTime
	if cfg.invert_bar_sorting then 
		return aux_B > aux_A 
	else 
		return aux_A > aux_B
	end
end
	
--The Bar Timers Whitelist Filter
local Whitelist_bars = Whitelist.bars
local myCustomBarTimersFilter = function(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable)
	if(unitCaster == "player" and PlayerClass) then
		return Whitelist_bars[PlayerClass][name]
	end 
end
	
--Unit has an Aura
function hasUnitAura(unit, name)
	local _, _, _, count, _, _, _, caster = UnitAura(unit, name)
	if (caster and caster == "player") then
		return count
	end
end
	
--Unit has a Debuff
function hasUnitDebuff(unit, name, myspell)
	local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
	if myspell then
		if (count and caster == 'player') then 
			return count 
		end
	else
		if count then 
			return count 
		end
	end
end
			
-- Update AuraWatchers (BarTimers / Corner Indicators)
function UpdateAW(self, event, unit)
	if(self.mystyle == "player" or self.mystyle == "target") then -- Bar Timers
		if(self.unit ~= unit) then 
			return 
		end
		unit = unit or self.unit
		
		local reaction = UnitIsFriend('player', unit) and 'HELPFUL' or 'HARMFUL'                                
		local auras,lastIndex,bars = {},0,self.AuraWatchers.bars
						
		--Read the Buffs/Debuffs
		for index = 1, 40 do
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura(unit, index, reaction)
			if not name then break end
				
			if ((myCustomBarTimersFilter)(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable)) then
				lastIndex = lastIndex + 1
				auras[lastIndex] = {}
				auras[lastIndex].name = name
				auras[lastIndex].rank = rank
				auras[lastIndex].icon = icon
				auras[lastIndex].count = count
				auras[lastIndex].debuffType = debuffType
				auras[lastIndex].duration = duration
				auras[lastIndex].expirationTime = expirationTime
				auras[lastIndex].unitCaster = unitCaster
				auras[lastIndex].isStealable = isStealable
				auras[lastIndex].noTime = (duration == 0 and expirationTime == 0)
			end
		end
								
		table.sort(auras, type(before) == "function" and before or qsort )
		
		-- Create the Bars
		for index = 1 , lastIndex do
			local bar = bars[index]
			local timer = auras[index]
				
			if not bar then
				bar = CreateTimerBar(self, index == 1 and self.AuraWatchers or bars[index-1])
				bars[index] = bar
			end

			bar.timer = timer
				
			if bar.timer.noTime then
				bar:SetMinMaxValues(0, 1)
				bar:SetValue(1)
			else
				bar:SetMinMaxValues(0, bar.timer.duration)
				bar:SetValue(bar.timer.expirationTime - GetTime())
			end
									
			bar.icon:SetTexture(bar.timer.icon)
			bar.spell:SetText(bar.timer.name)
			
			if(bar.timer.count ~= 0) then
				bar.stack:SetText("|cff999999".. bar.timer.count .."|r")
			else
				bar.stack:SetText()
			end
			
			if(reaction == 'HARMFUL') then
				if(cfg.BarTimers_Color_by_Debuff) then
					local debufftype = bar.timer.debuffType 
					local color = DebuffTypeColor[debufftype] or DebuffTypeColor.none
					bar:SetStatusBarColor(color.r, color.g, color.b)
					bar.spark:SetVertexColor(color.r, color.g, color.b)
				else
					bar:SetStatusBarColor(1, 0, 0)
					bar.spark:SetVertexColor(1, 0, 0)
				end
			else
				bar:SetStatusBarColor(0, 0.4, 1)
				bar.spark:SetVertexColor(0, 0.4, 1)
			end		
			bar:Show()                      
		end
																
		--Remove unused Bars
		for index = lastIndex + 1, #bars do
			bars[index]:Hide()
		end
	end--End Bar Timers
end

--Enable AuraWatchers
function EnableAW(self)
	if self.AuraWatchers then
		self:RegisterEvent('UNIT_AURA', UpdateAW)
		self.AuraWatchers.bars = self.AuraWatchers.bars or {}
		self.AuraWatchers:SetScript('OnUpdate', UpdateAuraWatchers)
		return true
	end
end

--Disable AuraWatchers
function DisableAW(self)
	if self.AuraWatchers then
		self:UnregisterEvent('UNIT_AURA', UpdateAW)
		self.AuraWatchers:SetScript('OnUpdate', UpdateAuraWatchers)
	end
end
	
oUF:AddElement('AuraWatchers', UpdateAW, EnableAW, DisableAW) -- AuraWatchers -- END