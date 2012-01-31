local T, C, F = unpack(select(2, ...))
local mediaFolder = "Interface\\Addons\\Langley\\Clock\\Media\\"

--- ----------------------------------
--> Clock
--- ----------------------------------
local Clock = CreateFrame("Frame", nil, UIParent)
Clock:SetFrameLevel(1)
Clock:SetSize(256,32)
Clock:Show()
Clock:SetPoint("TOP", UIParent, "TOP", 0,0)

local Bg = Clock:CreateTexture(nil, "BACKGROUND")
Bg:SetTexture(mediaFolder.."Clock_b")
Bg:SetSize(256,32)
Bg:SetVertexColor(unpack(T.Color.RGB.BgColor))
Bg:SetAlpha(1)
Bg:SetPoint("TOP", Clock, "TOP", 0,0)
--[[
local BgC = Clock:CreateTexture(nil, "ARTWORK")
BgC:SetTexture(T.Line)
BgC:SetSize(2,2)
BgC:SetVertexColor(unpack(T.Color.RGB.Orange))
BgC:SetAlpha(0.9)
BgC:SetPoint("TOP", Clock, "TOP", 0,0)
--]]
local ClockTxt = Clock:CreateFontString(nil, "OVERLAY")
ClockTxt:SetFont(mediaFolder.."Digital-7.ttf", 26, nil)--"OUTLINE MONOCHROME"
--ClockTxt:SetPoint("TOPRIGHT", Clock, "TOP", 12, 0)
ClockTxt:SetPoint("TOP", Clock, "TOP", 0, 0)
ClockTxt:SetJustifyH("CENTER")
ClockTxt:SetText("|cffF27F11".."88:88".."|r")
--ClockTxt:SetShadowOffset(0.3, -0.3)
--ClockTxt:SetShadowColor(unpack(cfg.black))

local ClockTxt_s = Clock:CreateFontString(nil, "OVERLAY")
ClockTxt_s:SetFont(mediaFolder.."Digital-7.ttf", 16, nil)--"OUTLINE MONOCHROME"
--ClockTxt_s:SetPoint("TOPLEFT", Clock, "TOP", 12, -2)
ClockTxt_s:SetPoint("TOPLEFT", ClockTxt, "TOPRIGHT", 5, -2)
ClockTxt_s:SetJustifyH("LEFT")
ClockTxt_s:SetText("|cffF27F11"..":88".."|r")

local function ClockUpdate(self)
	local h = date("%H")
	local m = date("%M")
	local s = date("%S")
	--h1h2,m1m2,s1s2
	--h1 = floor(seconds/36000)
	--h1,h2 = math.modf(h/10)
	--m1,m2 = math.modf(m/10)
	--s1,s2 = math.modf(s/10)
	ClockTxt:SetText("|cffF27F11"..h..":"..m.."|r")
	ClockTxt_s:SetText("|cffF27F11"..s.."|r")
end

Clock:SetScript("OnUpdate", function(self) ClockUpdate(self) end)
--print(time{year=1970, month=1, day=1,hour=8,min=0,sec=0})
--print(string.match(GetCVar("gxResolution"), "%d+x(%d+)"))
