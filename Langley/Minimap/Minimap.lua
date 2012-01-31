local T, C, F = unpack(select(2, ...))
local mediaFolder = "Interface\\Addons\\Rei\\Minimap\\Media\\"

qparent = UIParent         
qanchor = "TOPRIGHT"  	 
qposition_x = -70
qposition_y = -200
qheight = 400

--- ----------------------------------
--> Minimap
--- ----------------------------------
local _, class = UnitClass('player')
local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]			

Minimap:SetSize(172*C.Minimap.Scale, 172*C.Minimap.Scale)
Minimap:SetMaskTexture(mediaFolder.."Tangle")
Minimap:SetHitRectInsets(0, 0, 24*C.Minimap.Scale, 24*C.Minimap.Scale)
Minimap:SetFrameLevel(2)
Minimap:ClearAllPoints()
Minimap:SetPoint(unpack(C.Minimap.Position))
Minimap:SetScale(C.Minimap.Scale)

-->Background
local BgFrame = CreateFrame("Frame", nil, Minimap)
BgFrame:SetFrameLevel(1)
BgFrame:SetSize(256, 156)
BgFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", -(8*C.Minimap.Scale), (6*C.Minimap.Scale))	

local BgFrame_b = BgFrame:CreateTexture(nil, "BACKGROUND")
BgFrame_b:SetTexture(mediaFolder.."Background")
BgFrame_b:SetSize(256, 256)
BgFrame_b:SetPoint("TOPLEFT", BgFrame, "TOPLEFT", 0,0)
BgFrame_b:SetVertexColor(unpack(T.Color.BgColor))
BgFrame_b:SetAlpha(1)

local ArtFrame = CreateFrame("Frame", nil, Minimap)
ArtFrame:SetFrameLevel(3)
ArtFrame:SetAllPoints(BgFrame)

local ArtFrame_1 = ArtFrame:CreateTexture(nil, "OVERLAY")
ArtFrame_1:SetTexture(T.Line)
ArtFrame_1:SetSize(3,6)
ArtFrame_1:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0,-12)
ArtFrame_1:SetVertexColor(unpack(T.Color.Orange))
ArtFrame_1:SetAlpha(0.9)

local ArtFrame_2 = ArtFrame:CreateTexture(nil, "OVERLAY")
ArtFrame_2:SetTexture(T.Line)
ArtFrame_2:SetSize(3,6)
ArtFrame_2:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0,-12)
ArtFrame_2:SetVertexColor(unpack(T.Color.Orange))
ArtFrame_2:SetAlpha(0.9)

local ArtFrame_3 = ArtFrame:CreateTexture(nil, "OVERLAY")
ArtFrame_3:SetTexture(T.Line)
ArtFrame_3:SetSize(3,6)
ArtFrame_3:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 0,16)
ArtFrame_3:SetVertexColor(unpack(T.Color.Orange))
ArtFrame_3:SetAlpha(0.9)

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

-->WatchFrame
if moveWatchFrame then
	WatchFrame:ClearAllPoints()	
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint(qanchor, qparent, qanchor, qposition_x, qposition_y)
	WatchFrame.SetPoint = function() end
	WatchFrame:SetClampedToScreen(true)
	WatchFrame:SetHeight(qheight)
end

---------------------
-- mousewheel zoom --
---------------------

Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, z)
	local c = Minimap:GetZoom()
	if(z > 0 and c < 5) then
		Minimap:SetZoom(c + 1)
	elseif(z < 0 and c > 0) then
		Minimap:SetZoom(c - 1)
	end
end)

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
Minimap:SetScript('OnMouseUp', function(self, button)
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

function GetMinimapShape() return 'SQUARE' end
