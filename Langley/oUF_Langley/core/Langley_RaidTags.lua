local ADDON_NAME, ns = ...
local oUF = oUFLangley or oUF

local getTime = function(expirationTime)
	local expire = -1*(GetTime()-expirationTime)
	local timeleft = format("%.0f", expire)
	if expire > 0.5 then
		local spellTimer = "|cffffff00"..timeleft.."|r"
		return spellTimer
	end
end

--Magic
oUF.Tags['raid:magic+'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Magic" then
            return "|cff1E90FF".."t".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:magic'] = "UNIT_AURA"

oUF.Tags['raid:magic'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Magic" then
            return "|cff1E90FF".."z".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:magic'] = "UNIT_AURA"

--Disease
oUF.Tags['raid:disease+'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Disease" then
            return "|cffFF8000".."t".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:disease+'] = "UNIT_AURA"

oUF.Tags['raid:disease'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Disease" then
            return "|cffFF8000".."z".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:disease'] = "UNIT_AURA"

--Curse
oUF.Tags['raid:curse+'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Curse" then
            return "|cff8A2BE2".."t".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:curse+'] = "UNIT_AURA"

oUF.Tags['raid:curse'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Curse" then
            return "|cff8A2BE2".."z".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:curse'] = "UNIT_AURA"

--Poison
oUF.Tags['raid:poison+'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Poison" then
            return "|cff32CD32".."t".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:poison+'] = "UNIT_AURA"

oUF.Tags['raid:poison'] = function(u)
    local index = 1
    while true do
        local name,_,_,_, dtype = UnitAura(u, index, 'HARMFUL')
        if not name then break end
        
        if dtype == "Poison" then
            return "|cff32CD32".."z".."|r"
        end

        index = index+1
    end
end
oUF.TagEvents['raid:poison'] = "UNIT_AURA"


-->>Priest<<--
	-->愈合祷言
	oUF.pomCount = {1,11,111,1111,11111}
	oUF.Tags["raid:pom"] = function(u) 
		local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(41635))
		if fromwho == "player" then
			if (c) then 
				return "|cff66FFFF"..oUF.pomCount[c].."|r" 
			end
		else
			if (c) then 
				return "|cffFFCF7F"..oUF.pomCount[c].."|r" 
			end
		end
	end
	oUF.TagEvents["raid:pom"] = "UNIT_AURA"
	
	-->恢复
	oUF.Tags["raid:rnw"] = function(u)
		local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
		if(fromwho == "player") then
			local spellTimer = GetTime()-expirationTime
			if spellTimer > -2 then
				return "|cffFF0000".."2".."|r"
			elseif spellTimer > -4 then
				return "|cffFF9900".."2".."|r"
			else
				return "|cff33FF33".."2".."|r"
			end
		end
	end
	oUF.TagEvents["raid:rnw"] = "UNIT_AURA"
	
	-->恢复
	oUF.Tags["raid:rnwTime"] = function(u)
		local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, GetSpellInfo(139))
		if (fromwho == "player") then 
			return getTime(expirationTime) 
		end 
	end
	oUF.TagEvents["raid:rnwTime"] = "UNIT_AURA"
	
	-->真言术：盾
	oUF.Tags["raid:pws"] = function(u) 
		if UnitAura(u, GetSpellInfo(17)) then 
			return "|cff33FF33".."2".."|r" 
		end 
	end
	oUF.TagEvents["raid:pws"] = "UNIT_AURA"
	
	-->虚弱灵魂
	oUF.Tags["raid:ws"] = function(u) 
		if UnitDebuff(u, GetSpellInfo(6788)) then 
			return "|cffFF9900".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:ws"] = "UNIT_AURA"
	
	-->防御恐惧结界
	oUF.Tags["raid:fw"] = function(u) 
		if UnitAura(u, GetSpellInfo(6346)) then 
			return "|cff8B4513".."1".."|r" 
		end 
	end
	oUF.TagEvents["raid:fw"] = "UNIT_AURA"
	
	-->暗影防护
	oUF.Tags["raid:sp"] = function(u) 
		if not UnitAura(u, GetSpellInfo(79107)) then 
			return "|cff9900FF".."1".."|r" 
		end 
	end
	oUF.TagEvents["raid:sp"] = "UNIT_AURA"
	
	-->真言术：韧
	oUF.Tags["raid:fort"] = function(u) 
		if not UnitAura(u, GetSpellInfo(79105)) then
			return "|cff00A1DE".."1".."|r" 
		end 
	end 
	oUF.TagEvents["raid:fort"] = "UNIT_AURA"
	
	-->真言术：障
	oUF.Tags["raid:pwb"] = function(u) 
		if UnitAura(u, GetSpellInfo(81782)) then 
			return "|cffEEEE00".."1".."|r" 
		end 
	end
	oUF.TagEvents["raid:pwb"] = "UNIT_AURA"
	
-->>Druid<<--
	-->生命绽放
	oUF.lbCount = { 1, 11, 111}
	oUF.Tags["raid:lb"] = function(u) 
		local name, _,_, c,_,_, expirationTime, fromwho,_ = UnitAura(u, GetSpellInfo(33763))
		if not (fromwho == "player") then return end
		local spellTimer = GetTime()-expirationTime
		if spellTimer > -2 then
			return "|cffFF0000"..oUF.lbCount[c].."|r"
		elseif spellTimer > -4 then
			return "|cffFF9900"..oUF.lbCount[c].."|r"
		else
			return "|cffA7FD0A"..oUF.lbCount[c].."|r"
		end
	end
	oUF.TagEvents["raid:lb"] = "UNIT_AURA"
	
	-->回春术
	oUF.Tags["raid:rejuv"] = function(u) 
		local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, GetSpellInfo(774))
		if(fromwho == "player") then
			local spellTimer = GetTime()-expirationTime
			if spellTimer > -2 then
				return "|cffFF0000".."2".."|r"
			elseif spellTimer > -4 then
				return "|cffFF9900".."2".."|r"
			else
				return "|cff33FF33".."2".."|r"
			end
		end
	end
	oUF.TagEvents["raid:rejuv"] = "UNIT_AURA"
	
	-->回春术
	oUF.Tags["raid:rejuvTime"] = function(u)
		local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, GetSpellInfo(774))
		if (fromwho == "player") then 
			return getTime(expirationTime) 
		end 
	end
	oUF.TagEvents["raid:rejuvTime"] = "UNIT_AURA"
	
	-->愈合
	oUF.Tags["raid:regrow"] = function(u) 
		if UnitAura(u, GetSpellInfo(8936)) then 
			return "|cff00FF10".."2".."|r" 
		end 
	end
	oUF.TagEvents["raid:regrow"] = "UNIT_AURA"
	
	-->野性成长
	oUF.Tags["raid:wg"] = function(u) 
		if UnitAura(u, GetSpellInfo(48438)) then 
			return "|cff33FF33".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:wg"] = "UNIT_AURA"
	
	-->野性印记
	oUF.Tags["raid:motw"] = function(u) 
		if not(UnitAura(u, GetSpellInfo(79060)) or UnitAura(u,GetSpellInfo(79063))) then 
			return "|cff00A1DE".."1".."|r" 
		end 
	end
	oUF.TagEvents["raid:motw"] = "UNIT_AURA"

-->>Warrior<<--
	-->战斗怒吼
	oUF.Tags["raid:stragi"] = function(u) 
		if not (UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330)) or UnitAura(u, GetSpellInfo(8076))) then 
			return "|cffFF0000".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:stragi"] = "UNIT_AURA"
	
	-->警戒
	oUF.Tags['raid:vigil'] = function(u) 
		if UnitAura(u, GetSpellInfo(50720)) then 
			return "|cff8B4513".."1".."|r"
		end
	end
	oUF.TagEvents['raid:vigil'] = "UNIT_AURA"

	-->盾墙
	oUF.Tags["raid:SW"] = function(u) 
		if UnitAura(u, GetSpellInfo(871)) then 
			return "|cff9900FF".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:SW"] = "UNIT_AURA"

-->>Death Knight<<------
	-->寒冬号角
	oUF.Tags["raid:how"] = function(u) 
		if not UnitAura(u, GetSpellInfo(57330)) or (UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(8076))) then 
			return "|cffFF0000".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:how"] = "UNIT_AURA"
	
-->>Shaman<<--
	-->激流
	oUF.Tags["raid:rip"] = function(u) 
		local name, _,_,_,_,_,_, fromwho,_ = UnitAura(u, GetSpellInfo(61295))
		if(fromwho == 'player') then 
			return "|cff00FEBF".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:rip"] = 'UNIT_AURA'
	
	-->激流
	oUF.Tags["raid:ripTime"] = function(u)
	local name, _,_,_,_,_, expirationTime, fromwho,_ = UnitAura(u, GetSpellInfo(61295))
		if (fromwho == "player") then 
			return getTime(expirationTime)
		end 
	end
	oUF.TagEvents["raid:ripTime"] = 'UNIT_AURA'
	
	-->大地之盾
	oUF.earthCount = {1,11,11,111,111,1111,1111,11111,11111}
	oUF.Tags["raid:earth"] = function(u) 
		local c = select(4, UnitAura(u, GetSpellInfo(974))) 
		if c then 
			return "|cffFFCF7F"..oUF.earthCount[c].."|r" 
		end
	end
	oUF.TagEvents["raid:earth"] = 'UNIT_AURA'
	
-->>Paladin<<--
	-->力量祝福
	oUF.Tags["raid:might"] = function(u) 
		if not(UnitAura(u, GetSpellInfo(79102)) or UnitAura(u, GetSpellInfo(53138))) then 
			return "|cffFF0000".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:might"] = "UNIT_AURA"
	
	-->圣光道标
	oUF.Tags["raid:beacon"] = function(u)
		local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(53563))
		if not name then return end
		if(fromwho == "player") then
			local spellTimer = GetTime()-expirationTime
			if spellTimer > -30 then
				return "|cffFF0000".."1".."|r"
			else
				return "|cffFFCC00".."2".."|r"
			end
		else
			return "|cff996600".."2".."|r" -- other pally's beacon
		end
	end
	oUF.TagEvents["raid:beacon"] = "UNIT_AURA"
	
	-->自律
	oUF.Tags["raid:forbearance"] = function(u) 
		if UnitDebuff(u, GetSpellInfo(25771)) then 
			return "|cffFF9900".."1".."|r"
		end
	end
	oUF.TagEvents["raid:forbearance"] = "UNIT_AURA"

-->>Warlock<<--
	-->黑暗意图
	oUF.Tags["raid:di"] = function(u) 
		local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(85767)) 
		if fromwho == "player" then
			return "|cff6600FF".."2".."|r"
		elseif name then
			return "|cffCC00FF".."1".."|r"
		end
	end
	oUF.TagEvents["raid:di"] = "UNIT_AURA"
	
	-->灵魂石复活
	oUF.Tags["raid:ss"] = function(u) 
		local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707)) 
		if fromwho == "player" then
			return "|cff6600FF".."2".."|r"
		elseif name then
			return "|cffCC00FF".."1".."|r"
		end
	end
	oUF.TagEvents["raid:ss"] = "UNIT_AURA"

-->>Mage<<--
	-->奥术光辉
	oUF.Tags["raid:int"] = function(u) 
		if not(UnitAura(u, GetSpellInfo(1459))) then 
			return "|cff00A1DE".."1".."|r" 
		end
	end
	oUF.TagEvents["raid:int"] = "UNIT_AURA"
	
	-->专注魔法
	oUF.Tags["raid:fmagic"] = function(u) 
		if UnitAura(u, GetSpellInfo(54648)) then 
			return "|cffCC00FF".."1".."|r"
		end
	end
	oUF.TagEvents["raid:fmagic"] = "UNIT_AURA"