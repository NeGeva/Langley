local T, C, F = unpack(select(2, ...))
local mediaFolder = "Interface\\Addons\\Langley\\Chat\\Media\\"

-->Lua APIs
local format = string.format
local floor = math.floor
-->WoW APIs

-->Init
local Lv1,Lv2,Lv3,Lv4 = 1,18,19,20

--- ----------------------------------
--> ChatBar
--- ----------------------------------
local function CHLight(f)
	if C["HLBorder"] ~= true then return end
	local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint()
	local parent = f:GetParent()
	local texture = f:GetTexture()
	print(texture)
	print(texture.."W")
	f.HL = parent:CreateTexture(nil, "BACKGROUND")
	f.HL:SetTexture(texture.."W")
	f.HL:SetSize(f:GetSize())
	f.HL:SetTexCoord(f:GetTexCoord())
	f.HL:SetVertexColor(unpack(T.Color.White))
	f.HL:SetAlpha(1)
	f.HL:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
end

local function creatChatBar(f)
	local channel = {
		{"/say", 255/255,255/255,255/255},
		{"/yell", 255/255,64/255,64/255},
		{"/guild", 64/255,255/255,64/255},
		{"/whisper", 255/255,128/255,255/255},
		{"/emote", unpack(T.Color.Red)},
		{"/party", 170/255,170/255,255/255},
		{"/raid", 255/255,127/255,0},
		{"/officer", 64/255,255/255,64/255},
	}
	
	local cnum = getn(channel)
	
	local ChatBar = CreateFrame("Button", "ChatBar", f)
	ChatBar:SetSize(16*cnum+32,16)
	ChatBar:SetFrameLevel(Lv3)
	ChatBar:Show()
	ChatBar:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -10,1)
	
	for i = 1,cnum do
		ChatBar[i] = CreateFrame("Button", nil, ChatBar)
		ChatBar[i]:SetSize(16,16)
		ChatBar[i]:SetFrameLevel(Lv4)
		ChatBar[i]:Show()
		if i == 1 then
			ChatBar[i]:SetPoint("BOTTOMLEFT", ChatBar, "BOTTOMLEFT", 0,0)
		else
			ChatBar[i]:SetPoint("BOTTOMLEFT", ChatBar[i-1], "BOTTOMRIGHT", 0,0)
		end
		
		ChatBar[i].tex = ChatBar[i]:CreateTexture(nil, "OVERLAY")
		ChatBar[i].tex:SetTexture(mediaFolder.."ChatButton1")
		ChatBar[i].tex:SetSize(16,8)
		ChatBar[i].tex:SetPoint("BOTTOMLEFT", ChatBar[i], "BOTTOMLEFT", 0,0)
		ChatBar[i].tex:SetVertexColor(channel[i][2],channel[i][3],channel[i][4] )
		ChatBar[i].tex:SetAlpha(0.75)
		
		ChatBar[i].tex_b = ChatBar[i]:CreateTexture(nil, "BACKGROUND")
		ChatBar[i].tex_b:SetTexture(mediaFolder.."ChatButton1")
		ChatBar[i].tex_b:SetSize(16,8)
		ChatBar[i].tex_b:SetPoint("BOTTOMLEFT", ChatBar[i], "BOTTOMLEFT", 0,0)
		ChatBar[i].tex_b:SetVertexColor(T.Color.BgColor)
		ChatBar[i].tex_b:SetAlpha(0.6)
		
		ChatBar[i]:SetScript("OnEnter", function(self)
			ChatBar[i].tex:SetAlpha(1)
		end)
		ChatBar[i]:SetScript("OnLeave", function(self)
			ChatBar[i].tex:SetAlpha(0.75)
		end)
		ChatBar[i]:SetScript("OnMouseDown", function(self, button)
			ChatFrame_OpenChat(channel[i][1], SELECTED_DOCK_FRAME);	
		end)
	end
	local Roll = CreateFrame("Button", "rollMacro", ChatBar, "SecureActionButtonTemplate")
	Roll:SetAttribute("*type*", "macro")
	Roll:SetAttribute("macrotext", "/roll")
	Roll:SetSize(32,16)
	Roll:SetFrameLevel(Lv4)
	Roll:Show()
	Roll:SetPoint("BOTTOMLEFT", ChatBar[cnum], "BOTTOMRIGHT", 0,0)
	
	Roll.tex = Roll:CreateTexture(nil, "OVERLAY")
	Roll.tex:SetTexture(mediaFolder.."ChatButton2")
	Roll.tex:SetSize(32,8)
	Roll.tex:SetPoint("BOTTOMLEFT", Roll, "BOTTOMLEFT", 0,0)
	Roll.tex:SetVertexColor(unpack(T.Color["3.0"]))
	Roll.tex:SetAlpha(0.6)
		
	Roll.tex_b = Roll:CreateTexture(nil, "BACKGROUND")
	Roll.tex_b:SetTexture(mediaFolder.."ChatButton2")
	Roll.tex_b:SetSize(32,8)
	Roll.tex_b:SetPoint("BOTTOMLEFT", Roll, "BOTTOMLEFT", 0,0)
	Roll.tex_b:SetVertexColor(T.Color.BgColor)
	Roll.tex_b:SetAlpha(0.4)
	
	Roll:SetScript("OnEnter", function(self)
		Roll.tex:SetAlpha(1)
	end)
	Roll:SetScript("OnLeave", function(self)
		Roll.tex:SetAlpha(0.6)
	end)
end

--- ----------------------------------
--> ChatFrame
--- ----------------------------------

-->>Fading alpha
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

-->>Script
local function HideForever(f)
	f:SetScript("OnShow", f.Hide)
	f:Hide()
end

local cBolder_tab = {
	bgFile = T.px,
	edgeFile = T.px,
	tile = false,--平铺
	tileSize = 0, edgeSize = 4, 
	insets = {left = 0, right = 0, top = 0, bottom = 0},
}
local cBolder = function(f)
	f:SetBackdrop(cBolder_tab);
	f:SetBackdropColor(0,0,0,0.2)
	f:SetBackdropBorderColor(0.09, 0.09, 0.09, 0)
end

-->CreatFrame for EditBox
local function creatTex(f)
	local cFrame = CreateFrame("Frame", nil, f)
	cFrame:SetFrameLevel(Lv2)
	cFrame:SetAllPoints(f.editBox)
	cFrame:SetAlpha(1)
	cFrame:Show()
	-->Creat Bolder
	cBolder(cFrame)
	-->Creat ChatBar
	creatChatBar(cFrame)
	
	local boxLeft = cFrame:CreateTexture(nil, "ARTWORK")
	boxLeft:SetTexture(mediaFolder.."BoxLeft")
	boxLeft:SetSize(32,32)
	boxLeft:SetVertexColor(unpack(T.Color.BgColor))
	boxLeft:SetAlpha(0.8)
	boxLeft:SetPoint("BOTTOMLEFT", cFrame, "BOTTOMLEFT", -1,-2)
	CHLight(boxLeft)
	
	local boxRight = cFrame:CreateTexture(nil, "ARTWORK")
	boxRight:SetTexture(mediaFolder.."BoxRight")
	boxRight:SetSize(32,32)
	boxRight:SetVertexColor(unpack(T.Color.BgColor))
	boxRight:SetAlpha(0.8)
	boxRight:SetPoint("BOTTOMRIGHT", cFrame, "BOTTOMRIGHT", 1,-2)
	CHLight(boxRight)
	
	local boxMid = cFrame:CreateTexture(nil, "ARTWORK")
	boxMid:SetTexture(mediaFolder.."BoxMid")
	boxMid:SetHeight(32)
	boxMid:SetVertexColor(unpack(T.Color.BgColor))
	boxMid:SetAlpha(0.8)
	boxMid:SetPoint("BOTTOMLEFT", boxLeft, "BOTTOMRIGHT", 0,0)
	boxMid:SetPoint("BOTTOMRIGHT", boxRight, "BOTTOMLEFT", 0,0)
	
	boxMid.HL = cFrame:CreateTexture(nil, "BACKGROUND")
	boxMid.HL:SetTexture(mediaFolder.."BoxMidW")
	boxMid.HL:SetHeight(32)
	boxMid.HL:SetVertexColor(unpack(T.Color.White))
	boxMid.HL:SetAlpha(1)
	boxMid.HL:SetPoint("BOTTOMLEFT", boxLeft, "BOTTOMRIGHT", 0,0)
	boxMid.HL:SetPoint("BOTTOMRIGHT", boxRight, "BOTTOMLEFT", 0,0)
end

local tabs = {
	"Left",
	"Middle",
	"Right",
	"SelectedLeft",
	"SelectedMiddle",
	"SelectedRight",
	"Glow",
	"HighlightLeft",
	"HighlightMiddle",
	"HighlightRight"
}

-->Do
HideForever(ChatFrameMenuButton)
HideForever(FriendsMicroButton)
BNToastFrame:SetClampedToScreen(true)

for i = 1, NUM_CHAT_WINDOWS do
	local frame = _G[("ChatFrame%d"):format(i)]
	
	-->Hide Buttons
	HideForever(frame.buttonFrame)
	
	-->Resize （为0时不限制大小）
	--frame:SetMinResize(0,0)
	--frame:SetMaxResize(0,0)
	
	-->Allow the chat frame to move to the end of the screen
	frame:SetClampedToScreen(false)
	frame:SetClampRectInsets(0,0,0,0)
	
	-->Move EditBox
	frame.editBox:SetAltArrowKeyMode(true)
	frame.editBox:EnableMouse(true)
	frame.editBox:ClearAllPoints()
	frame.editBox:SetPoint("TOPLEFT",  _G.ChatFrame1, "BOTTOMLEFT", 0, -10)
	frame.editBox:SetPoint("TOPRIGHT", _G.ChatFrame1, "BOTTOMRIGHT", 0, -10)
	frame.editBox:SetFrameLevel(Lv3)
	frame.editBox:SetHeight(28)
	
	frame:SetFrameLevel(Lv1)
	creatTex(frame)
	
	--local Box = 
	
	-->Hide Textures
	local tex = ({frame.editBox:GetRegions()})
    tex[6]:SetAlpha(0) tex[7]:SetAlpha(0) tex[8]:SetAlpha(0) tex[9]:SetAlpha(0) tex[10]:SetAlpha(0) tex[11]:SetAlpha(0)
	
	for g = 1, #CHAT_FRAME_TEXTURES do
        _G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
    end
    for index, value in pairs(tabs) do
        local texture = _G['ChatFrame'..i..'Tab'..value]
        texture:SetTexture(nil)
    end
end

-->>Set Chat
local function SetChat()
	FCF_SetLocked(ChatFrame1, nil)
	FCF_SetChatWindowFontSize(self, ChatFrame1, 12)
	for i = 1, 10 do
		_G["ChatFrame"..i]:SetFont(T.Font.Zfull, 12, nil)--"OUTLINE MONOCHROME","THINOUTLINE"
	end
	ChatFrame1:SetShadowOffset(0, 0)
	ChatFrame1:SetShadowColor(0.09,0.09,0.09,0.8)
	ChatFrame1:SetAlpha(1)
	
    ChatFrame1:ClearAllPoints()
    ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 20,45)
    ChatFrame1:SetFrameLevel(Lv1)
    ChatFrame1:SetUserPlaced(true)
	
	for i=1,10 do 
		local frame = _G[("ChatFrame%d"):format(i)]
		FCF_SetWindowAlpha(frame, 0) 
	end
    FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
end

local cFrameHelp = CreateFrame("Frame", nil, UIParent)
cFrameHelp:RegisterEvent("PLAYER_ENTERING_WORLD")
cFrameHelp:SetScript("OnEvent", function() SetChat() end)

--- ----------------------------------
--> Function
--- ----------------------------------
-->>Chat Scroll Module
hooksecurefunc('FloatingChatFrame_OnMouseScroll', function(self, dir)
	if dir > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsControlKeyDown() then
			-->only need to scroll twice because of blizzards scroll
			self:ScrollUp()
			self:ScrollUp()
		end
	elseif dir < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsControlKeyDown() then
			-->only need to scroll twice because of blizzards scroll
			self:ScrollDown()
			self:ScrollDown()
		end
	end
end)

-->>afk/dnd msg filter
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)

-->>Per-line chat copy via time stamps
if TimeStampsCopy then
	local AddMsg = {}
	local AddMessage = function(frame, text, ...)
		text = string.gsub(text, "%[(%d+)%. .-%]", "[%1]")
		text = ('|cffffffff|Hm_Chat|h|r%s|h %s'):format('|cff'..tscol..''..date('%H:%M')..'|r', text)
		return AddMsg[frame:GetName()](frame, text, ...)
	end
	for i = 1, 10 do
		if i ~= 2 then
			AddMsg["ChatFrame"..i] = _G["ChatFrame"..i].AddMessage
			_G["ChatFrame"..i].AddMessage = AddMessage
		end
	end
end

-->> URL copy Module
local tlds = {
	"[Cc][Oo][Mm]", "[Uu][Kk]", "[Nn][Ee][Tt]", "[Dd][Ee]", "[Ff][Rr]", "[Ee][Ss]",
	"[Bb][Ee]", "[Cc][Cc]", "[Uu][Ss]", "[Kk][Oo]", "[Cc][Hh]", "[Tt][Ww]",
	"[Cc][Nn]", "[Rr][Uu]", "[Gg][Rr]", "[Ii][Tt]", "[Ee][Uu]", "[Tt][Vv]",
	"[Nn][Ll]", "[Hh][Uu]", "[Oo][Rr][Gg]", "[Ss][Ee]", "[Nn][Oo]", "[Ff][Ii]"
}

local uPatterns = {
	'(http://%S+)',
	'(www%.%S+)',
	'(%d+%.%d+%.%d+%.%d+:?%d*)',
}

local cTypes = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_YELL",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_SAY",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_CONVERSATION",
}

for _, event in pairs(cTypes) do
	ChatFrame_AddMessageEventFilter(event, function(self, event, text, ...)
		for i=1, 24 do
			local result, matches = string.gsub(text, "(%S-%."..tlds[i].."/?%S*)", "|cff8A9DDE|Hurl:%1|h[%1]|h|r")
			if matches > 0 then
				return false, result, ...
			end
		end
 		for _, pattern in pairs(uPatterns) do
			local result, matches = string.gsub(text, pattern, '|cff8A9DDE|Hurl:%1|h[%1]|h|r')
			if matches > 0 then
				return false, result, ...
			end
		end 
	end)
end

local GetText = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if obj:GetObjectType() == "FontString" and obj:IsMouseOver() then
			return obj:GetText()
		end
	end
end

local SetIRef = SetItemRef
SetItemRef = function(link, text, ...)
	local txt, frame
	if link:sub(1, 6) == 'm_Chat' then
		frame = GetMouseFocus():GetParent()
		txt = GetText(frame:GetRegions())
		txt = txt:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		txt = txt:gsub("|H.-|h(.-)|h", "%1")
	elseif link:sub(1, 3) == 'url' then
		frame = GetMouseFocus():GetParent()
		txt = link:sub(5)
	end
	if txt then
		local editbox
		if GetCVar('chatStyle') == 'classic' then
			editbox = LAST_ACTIVE_CHAT_EDIT_BOX
		else
			editbox = _G['ChatFrame'..frame:GetID()..'EditBox']
		end
		editbox:Show()
		editbox:Insert(txt)
		editbox:HighlightText()
		editbox:SetFocus()
		return
	end
	return SetIRef(link, text, ...)
end

