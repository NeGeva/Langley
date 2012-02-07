local T, C, F = unpack(select(2, ...))
local mediaFolder = "Interface\\Addons\\Langley\\Minimap\\Media\\"

-->>Init
local Lv1,Lv2,Lv3 = 1,2,3
--- ----------------------------------
--> Minimap
--- ----------------------------------
local _, class = UnitClass('player')
local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]			

Minimap:SetSize(200*C.Minimap.Scale, 200*C.Minimap.Scale)
Minimap:SetMaskTexture(mediaFolder.."Tangle")
--Minimap:SetHitRectInsets(0, 0, 24*C.Minimap.Scale, 24*C.Minimap.Scale)
Minimap:SetFrameLevel(2)
Minimap:ClearAllPoints()
Minimap:SetPoint(unpack(C.Minimap.Position))
Minimap:SetScale(C.Minimap.Scale)

-->>Texture
local function CHLight(f)
	if C["HLBorder"] ~= true then return end
	local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint()
	local parent = f:GetParent()
	local texture = f:GetTexture()
	--print(texture)
	--print(texture.."W")
	f.HL = parent:CreateTexture(nil, "ARTWORK")
	f.HL:SetTexture(texture.."W")
	f.HL:SetSize(f:GetSize())
	f.HL:SetTexCoord(f:GetTexCoord())
	f.HL:SetVertexColor(unpack(T.Color.White))
	f.HL:SetAlpha(1)
	f.HL:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
end

local function CButton(f)

end

--- ----------------------------------
--> Functions
--- ----------------------------------
local Location = CreateFrame("Button", nil, Minimap)
Location:SetFrameLevel(Lv2)

Location.txt = Location:CreateFontString(nil, "OVERLAY")
Location.txt:SetFont(T.Font.Zfull, 12, "OUTLINE MONOCHROME")--"OUTLINE MONOCHROME"
Location.txt:SetAlpha(0.8)
Location.txt:SetPoint("RIGHT", Minimap, "LEFT", -5, 60)
Location.txt:SetJustifyH("RIGHT")

Location.t = Location:CreateFontString(nil, "OVERLAY")
Location.t:SetFont(T.Font.auras, 18, "OUTLINE MONOCHROME")--"OUTLINE MONOCHROME"
Location.t:SetAlpha(0.8)
Location.t:SetPoint("RIGHT", Location.txt, "LEFT", 0, -2)
Location.t:SetJustifyH("CENTER")
Location.t:SetText(F.Hex(T.Color.Orange).."l".."|r")

Location:RegisterEvent("ZONE_CHANGED")
Location:RegisterEvent("ZONE_CHANGED_INDOORS")
Location:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Location:RegisterEvent("PLAYER_ENTERING_WORLD")
Location:RegisterEvent("MINIMAP_ZONE_CHANGED")
Location:SetScript("OnEvent", function(self, event)
	--local subzone, zone, pvp = GetSubZoneText(), GetZoneText(), GetZonePVPInfo()
	local minizone,pvpType = GetMinimapZoneText(),GetZonePVPInfo()
	local pvpcolor = F.Hex(T.Color.Orange)
	if pvpType == "contested" or pvpType == "hostile" then
		pvpcolor = F.Hex(T.Color.Yellow)
	elseif pvpType == "sanctuary" then
		F.Hex(T.Color.Blue)
	elseif pvpType == "combat" then
		pvpcolor = F.Hex(T.Color.Red)
	end
	Location.txt:SetText(pvpcolor..minizone.."|r")
end)


--- ----------------------------------
--> Hide
--- ----------------------------------
local dummy = function() end
local _G = getfenv(0)

local frames = {
	"GameTimeFrame",
	"MinimapBorderTop",
	"MinimapNorthTag",
	"MinimapBorder",
	"MinimapZoneTextButton",
	"MinimapZoomOut",
	"MinimapZoomIn",
	"MiniMapVoiceChatFrame",
	"MiniMapWorldMapButton",
    "MiniMapMailBorder",
	"GuildInstanceDifficulty",
	"MiniMapBattlefieldBorder",
}

for i in pairs(frames) do
    _G[frames[i]]:Hide()
    _G[frames[i]].Show = dummy
end

LoadAddOn('Blizzard_TimeManager')
TimeManagerClockButton.Show = TimeManagerClockButton.Hide
TimeManagerClockButton:Hide()

--- ----------------------------------
--> Move some stuff
--- ----------------------------------
MinimapCluster:EnableMouse(false)

-->Tracking
MiniMapTrackingBackground:SetAlpha(0)
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, 0, 20)
MiniMapTracking:SetScale(.9)

-->BG icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, 0, 20)

-->LFG icon
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:SetPoint("TOPLEFT", Minimap, 0, -15)

-->Mail
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, 0, -15)
MiniMapMailFrame:SetFrameStrata("LOW")
MiniMapMailIcon:SetTexture(mediaFolder.."mail")
MiniMapMailBorder:Hide()

-->Hide Instance Difficulty flag
MiniMapInstanceDifficulty:ClearAllPoints()
--MiniMapInstanceDifficulty:Hide()
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, -15)
MiniMapInstanceDifficulty:SetAlpha(0.2)
MiniMapInstanceDifficulty:SetFrameStrata("LOW")


--- ----------------------------------
--> 
--- ----------------------------------
-->>MouseWheel zoom
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	local Zoom,maxZoom = Minimap:GetZoom(),Minimap:GetZoomLevels()
	if d > 0 then
		Minimap:SetZoom((Zoom+1 >= maxZoom and maxZoom) or Zoom+1)
	elseif d < 0 then
		Minimap:SetZoom((Zoom-1 <= 0 and 0) or Zoom-1)
	end
end)

-->>WatchFrame
if moveWatchFrame then
	WatchFrame:ClearAllPoints()	
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint(qanchor, qparent, qanchor, qposition_x, qposition_y)
	WatchFrame.SetPoint = function() end
	WatchFrame:SetClampedToScreen(true)
	WatchFrame:SetHeight(qheight)
end
------------------------
-- move and clickable --
------------------------
--[[
Minimap:SetMovable(true)
Minimap:SetUserPlaced(true)
Minimap:SetScript("OnMouseDown", function()
    if (IsAltKeyDown()) then
        Minimap:ClearAllPoints()
        Minimap:StartMoving()
    end
end)
--]]
Minimap:SetScript('OnMouseDown', function(self, button)
	Minimap:StopMovingOrSizing()
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    elseif (button == 'MiddleButton') then
        ToggleCalendar()
    else
        Minimap_OnClick(self)
    end
end)

-- calendar slashcmd
SlashCmdList["CALENDAR"] = function()
	ToggleCalendar()
end
SLASH_CALENDAR1 = "/cl"
SLASH_CALENDAR2 = "/calendar"

--function GetMinimapShape() return 'SQUARE' end



--[[

function Minimap_UpdateRotationSetting()
    if ( GetCVar("rotateMinimap") == "1" ) then
        MinimapCompassTexture:Show();
        MinimapNorthTag:Hide();
    else
        MinimapCompassTexture:Hide();
        MinimapNorthTag:Show();
    end
end





















]]--