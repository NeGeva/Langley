--Thanks for rThreat
--- ----------------------------------
--> Init
--- ----------------------------------
local ADDON_NAME, ns = ...

if ns.FCS.Warning.Switch ~= true then return end
local mediaFolder
if IsAddOnLoaded("Langley") then
	mediaFolder = "Interface\\AddOns\\Langley\\oUF_Langley\\FCS\\media\\"
else
	mediaFolder = "Interface\\AddOns\\oUF_Langley\\FCS\\media\\"
end

--- ----------------------------------
--> FCS_ThreatBar
--- ----------------------------------
local Frame = CreateFrame("Frame", "FCS_Threat", UIParent)
Frame:SetSize(16,16)
Frame:SetPoint(unpack(ns.FCS.Warning.Pos))

local partynum = GetNumPartyMembers()
local raidnum = GetNumRaidMembers()

-->Get Threat Data
 local function GetThreatData(unit, mob)
	local isTanking, status, threatpct, rawPercent, threatValue = UnitDetailedThreatSituation(unit, mob)
	local _, class = UnitClass(unit)
	local values = {
		UnitID        = unit,
		UnitName      = UnitName(unit) or "Not found",
		UnitClass     = class or "Not found",
		isTanking     = isTanking or 0,	--1 = is tanking
		status        = status or 0,	--3 = securely tanking, 2 = insecurely tanking, 1 = not tanking but higher threat than tank, 0 = not tanking and lower threat than tank
		threatpct = threatpct or 0,	--At 100 the unit will pull aggro. Returns 100 if the unit is tanking  
		rawPercent    = rawPercent or 0,	--returns the unit's threat as a percentage of the tank's current threat
		threatValue   = threatValue or 0,   --returns the unit's total threat on the mob 
	}
	return values  
end

-->Filling
Frame.Warning = Frame:CreateTexture(nil, "ARTWORK")
Frame.Warning:SetTexture(mediaFolder.."WARNING")
Frame.Warning:SetSize(128,16)
Frame.Warning:SetVertexColor(unpack(ns.FCS.Color.RGB["Orange"]))
Frame.Warning:SetAlpha(1)
Frame.Warning:SetPoint("LEFT", Frame, "CENTER", -128,0)

-->Background
local WarningBg = Frame:CreateTexture(nil, "BACKGROUND")
WarningBg:SetTexture(mediaFolder.."WARNING")
WarningBg:SetSize(128,16)
--WarningBg:SetVertexColor(151/255, 151/255, 151/255)
--WarningBg:SetVertexColor(70/255, 79/255, 78/255)
--WarningBg:SetVertexColor(138/255, 171/255, 201/255)
WarningBg:SetVertexColor(137/255, 157/255, 192/255)
WarningBg:SetAlpha(0.75)
WarningBg:SetPoint("LEFT", Frame.Warning, "LEFT", 0,0)

-->Emergency
local EmergencyU = Frame:CreateTexture(nil, "ARTWORK")
EmergencyU:SetTexture(mediaFolder.."EmergencyU")
EmergencyU:SetSize(128,16)
EmergencyU:SetVertexColor(unpack(ns.FCS.Color.RGB["Red"]))
EmergencyU:SetAlpha(0)
EmergencyU:SetPoint("BOTTOMLEFT", Frame.Warning, "TOPLEFT", -1,-5)

local EmergencyL = Frame:CreateTexture(nil, "ARTWORK")
EmergencyL:SetTexture(mediaFolder.."EmergencyL")
EmergencyL:SetSize(128,16)
EmergencyL:SetVertexColor(unpack(ns.FCS.Color.RGB["Red"]))
EmergencyL:SetAlpha(0)
EmergencyL:SetPoint("TOPLEFT", Frame.Warning, "BOTTOMLEFT", -1,-6)

-->Threat Value
WarningTxt = Frame:CreateFontString(nil, 'OVERLAY')
WarningTxt:SetFont(mediaFolder.."rr_basic05.ttf", 10, nil)
WarningTxt:SetAlpha(0.75)
WarningTxt:SetShadowOffset(0.5, -0.5)
WarningTxt:SetShadowColor(0,0,0,1)
WarningTxt:SetPoint("TOPRIGHT", Frame.Warning, "BOTTOMLEFT", 68, 0)
WarningTxt:SetJustifyH("RIGHT")

-->Update Threat Data
local function UpdateThreat(self,event,...)
	--print(event)
	MyThreatTable = {}
	
	if UnitCanAttack("player", "target") and not(UnitIsDead("target") or UnitIsFriend("player", "target") or UnitPlayerControlled("target")) then
		MyThreatTable = GetThreatData("player", "target")
	elseif (not (UnitCanAttack("player", "target")) and UnitCanAttack("player", "targettarget") or UnitIsDead("targettarget") or UnitIsFriend("player", "targettarget") or UnitPlayerControlled("targettarget")) then
		MyThreatTable = GetThreatData("player", "targettarget")
	end
	
	if MyThreatTable.status == 3 then
		Frame.Warning:SetVertexColor(147/255, 224/255, 255/255, 1)
	elseif MyThreatTable.status == 2 then
		Frame.Warning:SetVertexColor(228/255, 255/255, 20/255, 1)
	elseif MyThreatTable.threatpct then
		if MyThreatTable.threatpct >= 80 then
			Frame.Warning:SetVertexColor(242/255, 48/255, 34/255, 1)
		elseif MyThreatTable.threatpct >= 60 and MyThreatTable.threatpct < 80 then
			Frame.Warning:SetVertexColor(217/255, 104/255, 49/255, 1)
		else
			Frame.Warning:SetVertexColor(107/255, 194/255, 53/255, 1)
		end
	else
		Frame.Warning:SetVertexColor(242/255, 48/255, 34/255, 0)
	end
	
	local d,d2 = 0.00001,0
	if MyThreatTable.threatpct then
		if MyThreatTable.threatpct == 0 then
			d = 0.00001
		else
			d = floor((MyThreatTable.threatpct)/100*10000+1)/10000
		end
		d2 = floor(MyThreatTable.threatpct)
	end
	
	WarningTxt:SetText(ns.FCS.Color.Hex["Orange"]..d2.."%")
	
	Frame.Warning:SetWidth(70 * math.abs(d))
	Frame.Warning:SetTexCoord(0, math.abs(d)*(70/128), 0, 1)
	
	-->Emergency
	if MyThreatTable.threatpct then
		if MyThreatTable.threatpct >= 70 then
			ns.FCS.Func.Fadein(EmergencyU,EmergencyL)
		else
			ns.FCS.Func.Fadehide(EmergencyU,EmergencyL)
		end
	else
		ns.FCS.Func.Fadehide(EmergencyU,EmergencyL)
	end

	-->Hide when no target
	local testid = "target"
	if UnitExists(testid) and not UnitIsDeadOrGhost(testid) and InCombatLockdown() then
		Frame:Show()
	else
		Frame:Hide()
	end
	
	if (partynum == 0 and raidnum == 0) then
	end
end

-->Event
Frame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
Frame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
Frame:RegisterEvent("PLAYER_TARGET_CHANGED")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
Frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
Frame:SetScript("OnEvent", UpdateThreat)