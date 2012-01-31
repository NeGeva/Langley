
local addon, ns = ...
local oUF = oUFLangley or oUF

--- ----------------------------------
--> 
--- ----------------------------------
-->Party Background
local Party = CreateFrame("Frame", nil, UIParent)
Party:SetFrameLevel(0)

local P_upper = Party:CreateTexture(nil, "BACKGROUND")
P_upper:SetTexture(ns.Tex.Party.Bg1)
P_upper:SetPoint("BOTTOMLEFT", oUF_Party, "TOPLEFT", -1, -11)
P_upper:SetVertexColor(0, 0, 0, 1)
P_upper:SetSize(16,64)

local P_low = Party:CreateTexture(nil, "BACKGROUND")
P_low:SetTexture(ns.Tex.Party.Bg2)
P_low:SetPoint("TOPLEFT", P_upper, "BOTTOMLEFT", 0, -141)
P_low:SetVertexColor(0, 0, 0, 1)
P_low:SetSize(16,64)

-->Button Upper
local B1 = CreateFrame("Frame", nil, UIParent)
B1:SetSize(16,64)
B1:SetPoint("TOPLEFT", P_upper, "TOPLEFT", 0, 0)
B1:SetFrameLevel(0)

local B1_art = B1:CreateTexture(nil, "ARTWORK")
B1_art:SetTexture(ns.Tex.Party.Button1)
B1_art:SetPoint("TOPLEFT", B1, "TOPLEFT", 0, 0)
B1_art:SetVertexColor(unpack(ns.Tex.Color.Orange))
B1_art:SetAlpha(0)
B1_art:SetSize(16,64)

local B1_bg = B1:CreateTexture(nil, "BACKGROUND")
B1_bg:SetTexture(ns.Tex.Party.Button1)
B1_bg:SetPoint("TOPLEFT", B1, "TOPLEFT", 0, 0)
B1_bg:SetVertexColor(0, 0, 0)
B1_bg:SetAlpha(0)
B1_bg:SetSize(16,64)

-->Buttion Low
local B2 = CreateFrame("Frame", nil, UIParent)
B2:SetSize(16,64)
B2:SetPoint("TOPLEFT", P_low, "TOPLEFT", 0, 0)
B2:SetFrameLevel(0)

local B2_art = B1:CreateTexture(nil, "ARTWORK")
B2_art:SetTexture(ns.Tex.Party.Button2)
B2_art:SetPoint("TOPLEFT", B2, "TOPLEFT", 0, 0)
B2_art:SetVertexColor(unpack(ns.Tex.Color.Orange))
B2_art:SetAlpha(0)
B2_art:SetSize(16,64)

local B2_bg = B1:CreateTexture(nil, "BACKGROUND")
B2_bg:SetTexture(ns.Tex.Party.Button2)
B2_bg:SetPoint("TOPLEFT", B2, "TOPLEFT", 0, 0)
B2_bg:SetVertexColor(0, 0, 0)
B2_bg:SetAlpha(0)
B2_bg:SetSize(16,64)

-->Party Bg
local impression = {}
for i = 1,4 do
	impression[i] = Party:CreateTexture(nil, "BACKGROUND")
	impression[i]:SetTexture(ns.Tex.Party.BarBg)
	if i == 1 then
		impression[i]:SetPoint("TOPLEFT", P_upper, "BOTTOMLEFT", 1, 28)
	else
		impression[i]:SetPoint("TOPLEFT", impression[i-1], "BOTTOMLEFT", 0, 26)
	end
	impression[i]:SetVertexColor(unpack(ns.Tex.Color.BgColor))
	impression[i]:SetAlpha(0.4)
	impression[i]:SetSize(16,64)
end

--- ----------------------------------
--> Handover
--- ----------------------------------
ns.Frame = Frame