
--- ----------------------------------
--> Init
--- ----------------------------------

local addon, ns = ...
local oUF = oUFLangley or oUF

local tags = CreateFrame("Frame") 

local t = "t"--上
local y = "y"--下
local z = "z"--方块

local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 240 then
				pos = pos + 4
			elseif c > 225 then
				pos = pos + 3
			elseif c > 192 then
				pos = pos + 2
			else
				pos = pos + 1
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

-->change some colors--
local function hex(r, g, b)
	if r then
		if (type(r) == "table") then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
	end
end

-->format numbers--
function round(num, idp)
  if idp and idp > 0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function CoolNumber(num)
	if(num >= 1e6) then
		return round(num/1e6, 1).."m"
	elseif(num >= 1e3) then
		return round(num/1e3, 1).."k"
	else
		return num
	end
end

--- ----------------------------------
--> Custom tags
--- ----------------------------------

--DDG------
oUF.Tags["negeva_DDG"] = function(u)
	if not UnitIsConnected(u) then
		return "|cffCFCFCF OFF|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF GHO|r"
	elseif UnitIsDead(u) then
		return "|cffCFCFCF RIP|r"
	elseif(UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return "|cffCFCFCF TAP|r"
	
	end
end	
oUF.TagEvents["negeva_DDG"] = 'UNIT_HEALTH'

--hp------
oUF.Tags["negeva_hp"] = function(u)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) or(UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return oUF.Tags['negeva_DDG'](u)
	else
		local min, max = UnitHealth(u), UnitHealthMax(u)
		local def = oUF.Tags['missinghp'](u) or 0
		if u == "player" then
			return CoolNumber(min)--[[.." | "..CoolNumber(def)]]
		elseif u == "target" then
			return CoolNumber(min)--[[.." | "..CoolNumber(max)]]
		else
			return CoolNumber(min)
		end
	end
end
oUF.TagEvents["negeva_hp"] = 'UNIT_HEALTH'

--perhp------
oUF.Tags["negeva_perhp"] = function(u)
	local min, max = UnitHealth(u), UnitHealthMax(u)
	if (round(min/max, 2)*100) == 100 then
		return "|cffF3970000|r"
	else
		return "|cffF39700"..(round(min/max, 2)*100)
	end
end
oUF.TagEvents["negeva_perhp"] = 'UNIT_HEALTH'

--/--
oUF.Tags["/"] = function(u) 
	return "|cffF39700/|r" 
end

--pp------
oUF.Tags["negeva_pp"] = function(u)
	local _, ptype = UnitPowerType(u)
	local min, max = UnitPower(u), UnitPowerMax(u)
	if ptype then
		return hex(colors.power[ptype] or {250/255,  75/255,  60/255})..CoolNumber(min)
	end
end	
oUF.TagEvents["negeva_pp"] = "UNIT_POWER UNIT_MAXPOWER"
--oUF.TagEvents["negeva_pp"] = 'UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_RUNIC_POWER'

--perpp------
oUF.Tags["negeva_perpp"] = function(u)
	local min, max = UnitPower(u), UnitPowerMax(u)
	local min, max = UnitHealth(u), UnitHealthMax(u)
	if (round(min/max, 2)*100) == 100 then
		return "|cffF3970000|r"
	else
		return "|cffF39700"..(round(min/max, 2)*100)
	end
end
oUF.TagEvents["negeva_perpp"] = "UNIT_POWER UNIT_MAXPOWER"

--druidPower------
oUF.Tags["druidPower"] = function(unit)
	local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)
	return unit == "player" and UnitPowerType(unit) ~= 0 and min ~= max and ("|cff5F9BFF%d%%|r"):format(min / max * 100)
end
oUF.TagEvents["druidPower"] = "UNIT_POWER UNIT_MAXPOWER UPDATE_SHAPESHIFT_FORM"

--afkdnd------
oUF.Tags["afkdnd"] = function(unit)
	if unit then
		return UnitIsAFK(unit) and "|cffffffff<AFK>|r " or UnitIsDND(unit) and "|cffffffff<DND>|r "
	end
end
oUF.TagEvents["afkdnd"] = "PLAYER_FLAGS_CHANGED"

--info------
oUF.Tags["negeva_info"] = function(u) 
	local level = UnitLevel(u)
    local race = UnitRace(u) or nil
	local typ = UnitClassification(u)
	local color = GetQuestDifficultyColor(level)
	
	if level <= 0 then
		level = "??" 
		color.r, color.g, color.b = 1, 0, 0
	end
	if u == "player" or (u == "target" and UnitIsPlayer("target")) then
		if level == 85 then 
			level = "" 
		end
	end
	--[[
	if typ=="rareelite" then
		return hex(color)..level..'r+'
	elseif typ=="elite" then
		return hex(color)..level..'+'
	elseif typ=="rare" then
		return hex(color)..level..'r'
	else
	--]]
	--[[
	if typ == "worldboss" then
		return level.."B "
	elseif typ == "rareelite" then
		return level.."R+ "
	elseif typ == "elite" then
		return level.."+ "
	elseif typ == "rare" then
		return level.."R "
	else
		return level.." "
    end
	--]]
	return level.." "
end
oUF.TagEvents["negeva_info"] = 'UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED'

--color------
oUF.Tags["negeva_color"] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents["negeva_color"] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

--LFD------
oUF.Tags['negeva_LFD'] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if role == "HEALER" then
		return "|cff8AFF30H|r"
	elseif role == "TANK" then
		return "|cffFFF130T|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161D|r"
	end
end
oUF.TagEvents['negeva_LFD'] = 'PLAYER_ROLES_ASSIGNED PARTY_MEMBERS_CHANGED'

-->combo points
oUF.Tags['combo'] = function(u)
	local cp = UnitExists("vehicle") and GetComboPoints("vehicle", "target") or GetComboPoints("player", "target")
	cpcol = {"8AFF30","FFF130","FF6161"}
	if cp == 1 then	return "|cff"..cpcol[1]..z.."|r" 
	elseif cp == 2 then	return "|cff"..cpcol[1]..z..z.."|r"
	elseif cp == 3 then	return "|cff"..cpcol[1]..z..z.."|r |cff"..cpcol[2]..z.."|r" 
	elseif cp == 4 then	return "|cff"..cpcol[1]..z..z.."|r |cff"..cpcol[2]..z..z.."|r" 
	elseif cp == 5 then	return "|cff"..cpcol[1]..z..z.."|r |cff"..cpcol[2]..z..z.."|r |cff"..cpcol[3]..z.."|r"
	end
end
oUF.TagEvents['combo'] = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED"

local MAELSTROM_WEAPON = GetSpellInfo(53817)
oUF.Tags["maelstrom"] = function(unit)
	if unit == "player" then
		local name, _, icon, count = UnitBuff("player", MAELSTROM_WEAPON)
		return name and count
	end
end	
oUF.TagEvents["maelstrom"] = "UNIT_AURA"

--- ----------------------------------
--> Raid tags
--- ----------------------------------

--raidname------
oUF.Tags["raidhpname"] = function(u)
	local name = UnitName(u)
	local c, m = UnitHealth(u), UnitHealthMax(u) 
	if c == 0 then 
		return "RIP" 
	elseif(UnitIsGhost(u)) then 
		return "GHO" 
	elseif(not UnitIsConnected(u)) then 
		return "OFF" 
	elseif c < m then 
		return oUF.Tags["missinghp"](u) 
	else 
		return utf8sub(name, 5, false) 
	end 
end
oUF.TagEvents["raidhpname"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE"

--raidname
oUF.Tags['raidname'] = function(u, r)
	local name = UnitName(r or u)
	return utf8sub(name, 5, false)
end
oUF.TagEvents['mono:raidname'] = 'UNIT_NAME_UPDATE UNIT_CONNECTION'

--raidhp
oUF.Tags["raidhp"]  = function(u)
	local per = oUF.Tags['perhp'](u).."%" or 0
	--local per = oUF.Tags['perhp'](u) or 0
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['negeva_DDG'](u)
	else
		return per
	end
end
oUF.TagEvents["raidhp"] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION'

--- ----------------------------------
--> Handover
--- ----------------------------------

ns.tags = tags