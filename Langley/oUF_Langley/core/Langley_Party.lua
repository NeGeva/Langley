
--- ----------------------------------
--> Init
--- ----------------------------------

local addon, ns = ...
local oUF = oUFLangley or oUF

local tags = ns.tags 

local _, playerClass = UnitClass('player')

--- ----------------------------------
--> Party
--- ----------------------------------
oUF.Tags["LFD"] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if role == "HEALER" then
		return "|cff8AFF30".."} ".."Healer".."|r"
	elseif role == "TANK" then
		return "|cffFFF130".."} ".."Tank".."|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161".."} ".."Damager".."|r"
	end
end
oUF.TagEvents["LFD"] = 'PLAYER_ROLES_ASSIGNED PARTY_MEMBERS_CHANGED'

ns.Lib.Party_Tag = function(f)
	local LFD_role = ns.Lib.gen_fontstring(f.Health, ns.Tex.Font.Number, 9, ns.Cfg.Font.Number.Outline)
	LFD_role:SetAlpha(0.4)
	LFD_role:SetPoint("BOTTOMLEFT", f.Health, "RIGHT", 0,0)
	--LFD_role:SetShadowOffset(1.25, -1.25)
	f:Tag(LFD_role, "[LFD]")
	--f:Tag(LFD_role, "|cffFF6161".."} ".."Damager".."|r")
end

ns.Lib.Party_Target_Tag = function(f)
	-->Creating Helper Frame
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
	
	local name = ns.Lib.gen_fontstring(h, ns.Tex.Font.Name, ns.Cfg.Font.Name.Size, ns.Cfg.Font.Name.Outline)
	name:SetAlpha(0.4)
	name:SetJustifyH("LEFT")
	name:SetPoint("TOPLEFT", f, "TOPLEFT", 0,0)
	name:SetWidth(80)
	name:SetHeight(ns.Cfg.Font.Name.Size+2)
	f:Tag(name, ns.Tex.Color.Hex.Red.."-|r".."[negeva_color][name]")
end