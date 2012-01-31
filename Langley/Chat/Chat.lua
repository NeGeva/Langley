local T, C, F = unpack(select(2, ...))
local mediaFolder = "Interface\\Addons\\Rei\\Chat\\Media\\"

--- ----------------------------------
--> ChatEdge
--- ----------------------------------
local Border = CreateFrame("Frame", nil, UIParent)
Border:SetFrameLevel(1)
Border:SetSize(64,128)
Border:Show()
Border:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0,0)

local Edge_left = Border:CreateTexture(nil, "OVERLAY")
Edge_left:SetTexture(mediaFolder.."Edge_left")
Edge_left:SetSize(64,128)
--Edge_left:SetVertexColor(100/255, 80/255, 125/255)
--Edge_left:SetVertexColor(0/255, 166/255, 192/255)
Edge_left:SetVertexColor(unpack(T.Color.BgColor))
--Edge_left:SetAlpha(1)
Edge_left:SetAlpha(0.9)
Edge_left:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0,0)

local Edge_left_b = Border:CreateTexture(nil, "ARTWORK")
Edge_left_b:SetTexture(mediaFolder.."Edge_left_b")
Edge_left_b:SetSize(64,128)
--Edge_left_b:SetVertexColor(100/255, 80/255, 125/255)
--dge_left_b:SetVertexColor(0/255, 166/255, 192/255)
Edge_left_b:SetVertexColor(unpack(T.Color.BgColor))
--Edge_left_b:SetAlpha(0.5)
Edge_left_b:SetAlpha(0.5)
Edge_left_b:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0,0)

local Edge_left_b2 = Border:CreateTexture(nil, "ARTWORK")
--local Edge_left_b2 = Border:CreateTexture(nil, "BACKGROUND")
Edge_left_b2:SetTexture(mediaFolder.."Edge_left_b")
Edge_left_b2:SetSize(64,128)
Edge_left_b2:SetVertexColor(0,0,0)
Edge_left_b2:SetAlpha(0.1)
Edge_left_b2:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0,0)

--- ----------------------------------
--> ChatBar
--- ----------------------------------
local ChatBar = CreateFrame("Button", "ChatBar", UIParent)
ChatBar:SetSize(328,16)
ChatBar:SetFrameLevel(0)
ChatBar:Show()
ChatBar:SetPoint("BOTTOMLEFT", Edge_left, "BOTTOMRIGHT", 0,0)

local channel = {
{"/say", 255/255,255/255,255/255},
{"/yell", 255/255,64/255,64/255},
{"/guild", 64/255,255/255,64/255},
{"/whisper", 255/255,128/255,255/255},
{"/emote", unpack(T.Color.Red)},
{"/party", 170/255,170/255,255/255},
{"/raid", 255/255,127/255,0},
{"/officer", unpack(T.Color.Orange)},
}

local cnum = getn(channel)
for i = 1,cnum do
	ChatBar[i] = CreateFrame("Button", nil, ChatBar)
	ChatBar[i]:SetSize(12,16)
	ChatBar[i]:SetFrameLevel(1)
	ChatBar[i]:Show()
	if i == 1 then
		ChatBar[i]:SetPoint("BOTTOMLEFT", Edge_left, "BOTTOMRIGHT", -1,0)
	else
		ChatBar[i]:SetPoint("BOTTOMLEFT", ChatBar[i-1], "BOTTOMRIGHT", -1,0)
	end
	
	ChatBar[i].tex = ChatBar[i]:CreateTexture(nil, "OVERLAY")
	ChatBar[i].tex:SetTexture(mediaFolder.."ChatButton")
	ChatBar[i].tex:SetAllPoints(ChatBar[i])
	ChatBar[i].tex:SetVertexColor(channel[i][2],channel[i][3],channel[i][4] )
	ChatBar[i].tex:SetAlpha(0.1)

	ChatBar[i].tex_b = ChatBar[i]:CreateTexture(nil, "ARTWORK")
	ChatBar[i].tex_b:SetTexture(mediaFolder.."ChatButton_b")
	ChatBar[i].tex_b:SetAllPoints(ChatBar[i])
	ChatBar[i].tex_b:SetVertexColor(channel[i][2],channel[i][3],channel[i][4] )
	ChatBar[i].tex_b:SetAlpha(0.4)

	ChatBar[i].tex_b2 = ChatBar[i]:CreateTexture(nil, "ARTWORK")
	ChatBar[i].tex_b2:SetTexture(mediaFolder.."ChatButton_b")
	ChatBar[i].tex_b2:SetAllPoints(ChatBar[i])
	ChatBar[i].tex_b2:SetVertexColor(0,0,0)
	ChatBar[i].tex_b2:SetAlpha(0.3)
	
	ChatBar[i]:RegisterEvent("ADDON_LOADED")
	ChatBar[i]:SetScript("OnEnter", function(self)
		ChatBar[i].tex:SetAlpha(1)
		ChatBar[i].tex_b:SetAlpha(0.8)
		ChatBar[i].tex_b2:SetAlpha(0.1)
	end)
	ChatBar[i]:SetScript("OnLeave", function()
		ChatBar[i].tex:SetAlpha(0.1)
		ChatBar[i].tex_b:SetAlpha(0.4)
		ChatBar[i].tex_b2:SetAlpha(0.3)
	end)
	ChatBar[i]:SetScript("OnMouseDown", function(self, button)
		ChatFrame_OpenChat(channel[i][1], SELECTED_DOCK_FRAME);	
	end)
end

--- ----------------------------------
--> Clock 
--- ----------------------------------
