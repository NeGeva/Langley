
--- ----------------------------------
--> Init
--- ----------------------------------
local addon, ns = ...
local oUF = oUFLangley or oUF

local Warn = CreateFrame("Frame")  
local _, playerClass = UnitClass('player')
--- ----------------------------------
--> Function
--- ----------------------------------
local function round(num, idp)
		if idp and idp > 0 then
			local mult = 10^idp
			return math.floor(num * mult + 0.5) / mult
		end
		return math.floor(num + 0.5)
end

Warn.HP = function(f)
	local HP = CreateFrame ("Frame", nil, f)
	
	local XXV = HP:CreateTexture(nil, "ARTWORK")
	XXV:SetTexture(ns.Tex.Warning.HP25)
	XXV:SetSize(64,32)
	XXV:SetAlpha(0)
	if f.unit == "player" then
		XXV:SetPoint("LEFT", f, "RIGHT", 0, 0)
	else
		XXV:SetPoint("RIGHT", f, "LEFT", 0, 0)
	end
	
	local XXV_Bg = HP:CreateTexture(nil, "BACKGROUND")
	XXV_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	XXV_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	XXV_Bg:SetSize(64,32)
	XXV_Bg:SetAlpha(0)
	XXV_Bg:SetAllPoints(XXV)
	
	local Dead = HP:CreateTexture(nil, "ARTWORK")
	Dead:SetSize(64, 32)
	Dead:SetTexture(ns.Tex.Warning.Dead)
	Dead:SetAlpha(0)
	Dead:SetAllPoints(XXV)
	
	local Dead_Bg = HP:CreateTexture(nil, "BACKGROUND")
	Dead_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Dead_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Dead_Bg:SetSize(64,32)
	Dead_Bg:SetAlpha(0)
	Dead_Bg:SetAllPoints(Dead)
	
	local Ghost = HP:CreateTexture(nil, "ARTWORK")
	Ghost:SetSize(64, 32)
	Ghost:SetTexture(ns.Tex.Warning.Ghost)
	Ghost:SetAlpha(0)
	Ghost:SetAllPoints(XXV)
	
	local Ghost_Bg = HP:CreateTexture(nil, "BACKGROUND")
	Ghost_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Ghost_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Ghost_Bg:SetSize(64,32)
	Ghost_Bg:SetAlpha(0)
	Ghost_Bg:SetAllPoints(Ghost)
	
	local function HP_onEvent(self)
		local minHealth, maxHealth = UnitHealth(f.unit), UnitHealthMax(f.unit)
		local d = round(minHealth/maxHealth, 2)*100
		
		if UnitIsGhost(f.unit) then
			Dead:SetAlpha(0)
			Dead_Bg:SetAlpha(0)
			Ghost:SetAlpha(1)
			Ghost_Bg:SetAlpha(0.75)
			XXV:SetAlpha(0)
			XXV_Bg:SetAlpha(0)
		elseif UnitIsDead(f.unit) then
			Dead:SetAlpha(1)
			Dead_Bg:SetAlpha(0.75)
			Ghost:SetAlpha(0)
			Ghost_Bg:SetAlpha(0)
			XXV:SetAlpha(0)
			XXV_Bg:SetAlpha(0)
		else
			Dead:SetAlpha(0)
			Dead_Bg:SetAlpha(0)
			Ghost:SetAlpha(0)
			Ghost_Bg:SetAlpha(0)
			if (d < 25) then
				XXV:SetAlpha(1)
				XXV_Bg:SetAlpha(0.75)
			else
				XXV:SetAlpha(0)
				XXV_Bg:SetAlpha(0)
			end
		end
	end
	
	HP:RegisterEvent("UNIT_HEALTH")
	HP:RegisterEvent("PLAYER_TARGET_CHANGED")
	HP:RegisterEvent("PLAYER_ENTERING_WORLD")
	HP:SetScript("OnEvent", HP_onEvent)
end

Warn.Player = function(f)
	local Player = CreateFrame ("Frame", nil, f)
	
	local Resting = Player:CreateTexture(nil, "ARTWORK")
	Resting:SetSize(64, 32)
	Resting:SetTexture(ns.Tex.Warning.Resting)
	--R:SetTexture[[Interface\TargetingFrame\UI-PhasingIcon]]
	--R:SetTexture[[Interface\TargetingFrame\PortraitQuestBadge]]
	Resting:SetAlpha(0)
	Resting:SetPoint("RIGHT", f, "LEFT", -4, -12)
	
	local Resting_Bg = Player:CreateTexture(nil, "BACKGROUND")
	Resting_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Resting_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Resting_Bg:SetSize(64,32)
	Resting_Bg:SetAlpha(0)
	Resting_Bg:SetAllPoints(Resting)
	
	local Combat = Player:CreateTexture(nil, "ARTWORK")
	Combat:SetTexture(ns.Tex.Warning.Combat)
	Combat:SetSize(64, 32)
	Combat:SetAlpha(0)
	Combat:SetPoint("TOP", Resting, "BOTTOM", 0, 12)
	
	local Combat_Bg = Player:CreateTexture(nil, "BACKGROUND")
	Combat_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Combat_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Combat_Bg:SetSize(64,32)
	Combat_Bg:SetAlpha(0)
	Combat_Bg:SetAllPoints(Combat)
	
	local function Player_onEvent(self)
		if (IsResting()) then
			Resting:SetAlpha(1)
			Resting_Bg:SetAlpha(0.75)
		else
			Resting:SetAlpha(0)
			Resting_Bg:SetAlpha(0)
		end
		
		if (UnitAffectingCombat(f.unit)) then
			Combat:SetAlpha(1)
			Combat_Bg:SetAlpha(0.75)
		else
			Combat:SetAlpha(0)
			Combat_Bg:SetAlpha(0)
		end
	end
	
	Player:RegisterEvent("PLAYER_UPDATE_RESTING")
	Player:RegisterEvent("PLAYER_REGEN_DISABLED")
	Player:RegisterEvent("PLAYER_REGEN_ENABLED")
	Player:RegisterEvent("PLAYER_ENTERING_WORLD")
	Player:SetScript("OnEvent", Player_onEvent)
end

Warn.Target = function(f)
	local Target = CreateFrame ("Frame", nil, f)
	
	local Tapped = Target:CreateTexture(nil, "ARTWORK")
	Tapped:SetTexture(ns.Tex.Warning.Tapped)
	Tapped:SetSize(64, 32)
	Tapped:SetAlpha(0)
	Tapped:SetPoint("LEFT", f, "RIGHT", 4, -12)
	
	local Tapped_Bg = Target:CreateTexture(nil, "BACKGROUND")
	Tapped_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Tapped_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Tapped_Bg:SetSize(64,32)
	Tapped_Bg:SetAlpha(0)
	Tapped_Bg:SetAllPoints(Tapped)
	
	local Combat = Target:CreateTexture(nil, "ARTWORK")
	Combat:SetTexture(ns.Tex.Warning.Combat)
	Combat:SetSize(64, 32)
	Combat:SetAlpha(0)
	Combat:SetPoint("TOP", Tapped, "BOTTOM", 0, 12)
	
	local Combat_Bg = Target:CreateTexture(nil, "BACKGROUND")
	Combat_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Combat_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Combat_Bg:SetSize(64,32)
	Combat_Bg:SetAlpha(0)
	Combat_Bg:SetAllPoints(Combat)
	
	local Offline = Target:CreateTexture(nil, "ARTWORK")
	Offline:SetTexture(ns.Tex.Warning.Offline)
	Offline:SetSize(64, 32)
	Offline:SetAlpha(0)
	Offline:SetPoint("TOP", Combat, "BOTTOM", 0, 12)
	
	local Offline_Bg = Target:CreateTexture(nil, "BACKGROUND")
	Offline_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Offline_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Offline_Bg:SetSize(64,32)
	Offline_Bg:SetAlpha(0)
	Offline_Bg:SetAllPoints(Offline)
	
	local Type = Target:CreateTexture(nil, "ARTWORK")
	Type:SetSize(64, 32)
	Type:SetAlpha(0)
	Type:SetPoint("TOP", Combat, "BOTTOM", 0, 12)
	
	local Type_Bg = Target:CreateTexture(nil, "BACKGROUND")
	Type_Bg:SetTexture(ns.Tex.Warning.WarnBg)
	Type_Bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	Type_Bg:SetSize(64,32)
	Type_Bg:SetAlpha(0)
	Type_Bg:SetAllPoints(Type)
	
	local function Target_onEvent(self)
		if(UnitIsTapped(f.unit) and not UnitIsTappedByPlayer(f.unit)) then
			Tapped:SetAlpha(1)
			Tapped_Bg:SetAlpha(0.75)
		else
			Tapped:SetAlpha(0)
			Tapped_Bg:SetAlpha(0)
		end
		
		if not UnitIsConnected(f.unit) then
			Offline:SetAlpha(1)
			Offline_Bg:SetAlpha(0.75)
		else
			Offline:SetAlpha(0)
			Offline_Bg:SetAlpha(0)
		end
		
		if (UnitAffectingCombat(f.unit)) then
			Combat:SetAlpha(1)
			Combat_Bg:SetAlpha(0.75)
		else
			Combat:SetAlpha(0)
			Combat_Bg:SetAlpha(0)
		end
		
		local typ = UnitClassification(f.unit)
		if typ == "worldboss" then
			Type:SetTexture(ns.Tex.Warning.Boss)
			Type:SetAlpha(1)
			Type_Bg:SetAlpha(0.75)
		elseif typ == "rareelite" then
			Type:SetTexture(ns.Tex.Warning.Rare_Elite)
			Type:SetAlpha(1)
			Type_Bg:SetAlpha(0.75)
		elseif typ == "elite" then
			Type:SetTexture(ns.Tex.Warning.Elite)
			Type:SetAlpha(1)
			Type_Bg:SetAlpha(0.75)
		elseif typ == "rare" then
			Type:SetTexture(ns.Tex.Warning.Rare)
			Type:SetAlpha(1)
			Type_Bg:SetAlpha(0.75)
		else
			Type:SetAlpha(0)
			Type_Bg:SetAlpha(0)
		end
	end
	
	Target:RegisterEvent("UNIT_HEALTH")
	Target:RegisterEvent("PLAYER_REGEN_DISABLED")
	Target:RegisterEvent("PLAYER_REGEN_ENABLED")
	Target:RegisterEvent("UNIT_CLASSIFICATION_CHANGED")
	Target:RegisterEvent("PLAYER_TARGET_CHANGED")
	Target:RegisterEvent("PLAYER_ENTERING_WORLD")
	Target:SetScript("OnEvent", Target_onEvent)
end
--- ----------------------------------
--> Handover
--- ----------------------------------
ns.Warn = Warn