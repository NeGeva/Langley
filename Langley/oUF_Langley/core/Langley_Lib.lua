
--- ----------------------------------
--> Init
--- ----------------------------------

local addon, ns = ...
local oUF = oUFLangley or oUF

local tags = ns.tags 

local _, playerClass = UnitClass('player')

--- ----------------------------------
--> Function
--- ----------------------------------
--[[
-->>Scale<<--
local function scale(x)
	local getscreenwidth = tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "(%d+)x+%d"))
	--local getwinwidth = floor(UIParent:GetWidth()+0.5)
	local getwinwidth = UIParent:GetWidth()
	local mult = getwinwidth/getscreenwidth
	--local mult = getscreenwidth/getwinwidth

	--return mult*math.floor(x/mult+0.5)
	return math.floor(x*10/mult+0.5)/10
	--return (x/mult)
	--return x
end
--]]
-->>status bar filling fix<<--
ns.Lib.fixStatusbar = function(b)
	b:GetStatusBarTexture():SetHorizTile(false)
	b:GetStatusBarTexture():SetVertTile(false)
end

local CreateShadow = function(f)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(0)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -5, 5)
	shadow:SetPoint("BOTTOMLEFT", -5, -5)
	shadow:SetPoint("TOPRIGHT", 5, 5)
	shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	shadow:SetBackdrop({
		edgeFile = ns.Tex.Glow, 
		edgeSize = 5,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	
	shadow:SetBackdropColor( .05,.05,.05, 0)
	shadow:SetBackdropBorderColor(0.09, 0.09, 0.09, 0.75)
	f.shadow = shadow
	return shadow
end

local frame = function(f)
	if f.frame == nil then
		local frame = CreateFrame("Frame", nil, f)
		frame:SetFrameLevel(0)
		frame:SetFrameStrata(f:GetFrameStrata())
		frame:SetPoint("TOPLEFT", -2, 2)
		frame:SetPoint("BOTTOMLEFT", 2, -2)
		frame:SetPoint("TOPRIGHT", 2, 2)
		frame:SetPoint("BOTTOMRIGHT", 2, 2)
		frame:SetBackdrop({ 
			bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
			edgeFile = "Interface\\Buttons\\WHITE8x8", 
			--tile = false, tileSize = 1, 
			edgeSize = 2,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		
		frame:SetBackdropColor(.09,.09,.09, 0.4)
		--frame:SetBackdropBorderColor(unpack(cfg.orange))
		frame:SetBackdropBorderColor(.09,.09,.09, 1)
		f.frame = frame
	end
end

--right click menu------
ns.Lib.menu = function(self)
	local dropdown = CreateFrame("Frame", "MyAddOnUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(dropdown, function(self)
		local unit = self:GetParent().unit
		if not unit then return end

		local menu, name, id
		if UnitIsUnit(unit, "player") then
		menu = "SELF"
		elseif UnitIsUnit(unit, "vehicle") then
			menu = "VEHICLE"
		elseif UnitIsUnit(unit, "pet") then
			menu = "PET"
		elseif UnitIsPlayer(unit) then
			id = UnitInRaid(unit)
			if id then
				menu = "RAID_PLAYER"
				name = GetRaidRosterInfo(id)
			elseif UnitInParty(unit) then
				menu = "PARTY"
			else
				menu = "PLAYER"
			end
		else
			menu = "TARGET"
			name = RAID_TARGET_ICON
		end
		if menu then
			UnitPopup_ShowMenu(self, menu, unit, name, id)
		end
	end, "MENU")


	dropdown:SetParent(self)
	ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)

	
	--remove SET_FOCUS & CLEAR_FOCUS from menu, to prevent errors
	do 
		for k,v in pairs(UnitPopupMenus) do
			for x,y in pairs(UnitPopupMenus[k]) do
				if y == "SET_FOCUS" then
					table.remove(UnitPopupMenus[k],x)
				elseif y == "CLEAR_FOCUS" then
					table.remove(UnitPopupMenus[k],x)
				end
			end
		end
	end
end	
--[[
--moveme func------
ns.Lib.moveme = function(f)
    if cfg.allow_frame_movement then
		f:SetMovable(true)
		f:SetUserPlaced(true)
		if not cfg.frames_locked then
			f:EnableMouse(true)
			f:RegisterForDrag("LeftButton","RightButton")
			f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
			f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
		end
    else
		f:IsUserPlaced(false)
    end  
end  
--]]
--et/clear focus with shift + left click------
ns.Lib.shift_focus = function(f)
    local ModKey = 'Shift'
    local MouseButton = 1
    local key = ModKey .. '-type' .. (MouseButton or '')
	if(f.unit == 'focus') then
		f:SetAttribute(key, 'macro')
		f:SetAttribute('macrotext', '/clearfocus')
	else
		f:SetAttribute(key, 'focus')
	end
end

--- ----------------------------------
--> Main
--- ----------------------------------

-->> Init <<--
ns.Lib.init = function(f)
    f.menu = ns.Lib.menu
    f:RegisterForClicks("AnyDown")
	f:SetAttribute("*type1", "target")
    f:SetAttribute("*type2", "menu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
end 
  
-->> Font String <<--
ns.Lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
end

-->> Healthbar <<--
ns.Lib.gen_hpbar = function(f, unit, min, max)
    --statusbar--
    local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(ns.Tex.Bar.Blank)
	--s:SetOrientation("VERTICAL")	
	s:SetFrameLevel(3)
	s:SetPoint("TOP", f, "TOP", 0, 0)
	
	local num
	if f.mystyle == "player" then
		s:SetStatusBarTexture(ns.Tex.Bar.BarHP_red)
		s:SetSize(128, 16)
	elseif f.mystyle == "target" then
		s:SetStatusBarTexture(ns.Tex.Bar.BarHP_red)
		s:SetSize(128, 16)
	elseif f.mystyle == "party" then
		s:SetStatusBarTexture(ns.Tex.Bar.BarPP)
		s:SetSize(16, 47)
		s:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	elseif f.mystyle == "partytarget" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(80, ns.Cfg.Font.Name.Size+2)
	elseif f.mystyle == "pet" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(128,16)
	else
		s:SetStatusBarTexture(ns.Tex.Bar.BarPP)
		s:SetSize(64, 16)
	end

	-->Helper<--
    local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetWidth(s:GetWidth())
	h:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
	h:SetPoint("TOPRIGHT", s, "TOPRIGHT", 0, 0)
	
	-->Background<--
	local b = s:CreateTexture(nil, "BACKGROUND")
	if f.mystyle == "player" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarHP_red)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		--s.Filling:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling:SetSize(128,16)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarHP_bg2)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(128,16)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarHP_bg2)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(128,16)
		
		-->Border<--
		local Border1 = s:CreateTexture(nil, "BACKGROUND")
		Border1:SetTexture(ns.Tex.Frame.BgLeft1)
		Border1:SetPoint("CENTER", s, "CENTER", 0, 0)
		Border1:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border1:SetSize(256,32)
		
		local Border2 = s:CreateTexture(nil, "BACKGROUND")
		Border2:SetTexture(ns.Tex.Frame.BgLeft2)
		Border2:SetPoint("TOPLEFT", Border1, "BOTTOMLEFT", 21, 14)
		Border2:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border2:SetSize(128,32)
		
		-->Symble<--
		local Sign1 = s:CreateTexture(nil, "OVERLAY")
		Sign1:SetTexture(ns.Tex.Sign.HP1)
		Sign1:SetPoint("RIGHT", s, "LEFT", 1, 0)
		Sign1:SetSize(16,16)
		--[[
		-->Overlay<--
		local o = s:CreateTexture(nil, "OVERLAY")
		o:SetTexture(cfg.HealthWarn_Player)
		o:SetPoint("RIGHT", s, "LEFT", 10, 2)
		--o:SetVertexColor(unpack(cfg.grey))
		o:SetSize(64,32)
		o:SetAlpha(0)
		--]]
	elseif f.mystyle == "target" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarHP_red)
		s.Filling:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 0, 0)
		--s.Filling:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling:SetSize(128,16)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarHP_bg2)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(128,16)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarHP_bg2)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(128,16)
		
		-->Border<--
		local Border1 = s:CreateTexture(nil, "BACKGROUND")
		Border1:SetTexture(ns.Tex.Frame.BgRight1)
		Border1:SetPoint("CENTER", s, "CENTER", 0, 0)
		Border1:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border1:SetSize(256,32)
		
		local Border2 = s:CreateTexture(nil, "BACKGROUND")
		Border2:SetTexture(ns.Tex.Frame.BgLeft3)
		Border2:SetPoint("TOPRIGHT", Border1, "BOTTOMRIGHT", -22, 14)
		Border2:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border2:SetSize(128,32)
		
		-->Symble<--
		local Sign1 = s:CreateTexture(nil, "OVERLAY")
		Sign1:SetTexture(ns.Tex.Sign.HP1)
		Sign1:SetPoint("LEFT", s, "RIGHT", -1, 0)
		Sign1:SetSize(16,16)
		
	elseif f.mystyle == "tot" or f.mystyle == "boss" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarPP)
		s.Filling:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 0, 0)
		--s.Filling:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling:SetSize(64,16)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarPP_bg2)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(64,16)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarPP_bg2)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(64,16)
		
		-->Border<--
		local Border1 = s:CreateTexture(nil, "BACKGROUND")
		Border1:SetTexture(ns.Tex.Frame.BgRight4)
		Border1:SetPoint("LEFT", s, "LEFT", -35, 0)
		Border1:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border1:SetSize(128,32)

		-->Symble<--
		local Sign1 = s:CreateTexture(nil, "OVERLAY")
		Sign1:SetTexture(ns.Tex.Sign.HP1)
		Sign1:SetPoint("LEFT", s, "RIGHT", -15, 0)
		Sign1:SetSize(16,16)
		
	elseif f.mystyle == "pet" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarHP_Screen)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling:SetAlpha(1)
		s.Filling:SetSize(128,16)
		s.Filling:SetTexCoord(0, 1, 0, 1)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarHP_Screen)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(128,16)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarHP_Screen)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(128,16)
		
	elseif f.mystyle == "focus" then
		--[[
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.Bar)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling:SetSize(64,16)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.Bar)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(64,16)
		
		local bg = h:CreateTexture(nil, "BACKGROUND")
		bg:SetTexture(ns.Tex.Bar.Bar)
		bg:SetSize(f:GetWidth()+4+4, f:GetHeight()+4+4)
		bg:SetVertexColor(unpack(ns.Tex.Color.Blue))
		bg:SetPoint("TOPLEFT", s, "TOPLEFT", -4, 4)
		bg:SetAlpha(0.75)
		
		local h2 = CreateFrame("Frame", nil, s)
		h2:SetFrameLevel(0)
		h2:SetPoint("TOPLEFT", bg, "TOPLEFT", -2,2)
		h2:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", 2,-2)
		h2:SetBackdrop({
			edgeFile = ns.Tex.Glow, 
			edgeSize = 2,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		h2:SetBackdropBorderColor(ns.Tex.Color.BgColor[1], ns.Tex.Color.BgColor[2], ns.Tex.Color.BgColor[3], 0.6)
		--]]
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarHP_Screen)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling:SetAlpha(1)
		s.Filling:SetSize(128,16)
		s.Filling:SetTexCoord(0, 1, 0, 1)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarHP_Screen)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(128,16)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarHP_Screen)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(128,16)
		
	elseif f.mystyle == "party" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Party.Bar)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling:SetSize(16,64)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Party.BarBg)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling_Bg:SetAlpha(0.3)
		s.Filling_Bg:SetSize(16,64)
	end
	
	f.Health = s
    f.Health.bg = b
	f.Health.helper = h
end

-->> Powerbar <<--
ns.Lib.gen_ppbar = function(f)

    --statusbar--
    local s = CreateFrame("StatusBar", nil, f)
	--s:SetOrientation("VERTICAL")	
	s:SetFrameLevel(3)
	s:SetPoint("TOP", f.Health, "BOTTOM", 0, -25)
	if f.mystyle == "player" then
		s:SetStatusBarTexture(ns.Tex.Bar.BarHP)
		s:SetSize(128, 16)
	elseif f.mystyle == "target" then
		s:SetStatusBarTexture(ns.Tex.Bar.BarHP)
		s:SetSize(64, 16)
	elseif f.mystyle == "party" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(128, 16)
	elseif f.mystyle == "tot" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(128, 16)
	elseif f.mystyle == "pet" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(64,8)
		s:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, 2)
	elseif f.mystyle == "focus" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(64,8)
		s:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, 2)
	elseif f.mystyle == "focustarget" or f.mystyle == "partytarget" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(128, 16)
	elseif f.mystyle == "partypet" then
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(128, 16)
	else
		s:SetStatusBarTexture(ns.Tex.Bar.Blank)
		s:SetSize(128, 16)
	end
	
	
	-->Helper<--
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
	h:SetPoint("TOPRIGHT", s, "TOPRIGHT", 0, 0)
	
	local h2 = CreateFrame("Frame", nil, s)
	h2:SetFrameLevel(4)
	h2:SetAllPoints(h)
	
	-->Background<--
	local b = s:CreateTexture(nil, "BACKGROUND")
	
	if f.mystyle == "player" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarHP)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling:SetSize(128,16)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarHP_bg2)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(128,16)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarHP_bg2)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(128,16)
		
		-->Border<--
		local Border1 = s:CreateTexture(nil, "BACKGROUND")
		Border1:SetTexture(ns.Tex.Frame.BgLeft1)
		Border1:SetPoint("CENTER", s, "CENTER", 0, 0)
		Border1:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border1:SetSize(256,32)
		
		local Border2 = s:CreateTexture(nil, "BACKGROUND")
		Border2:SetTexture(ns.Tex.Frame.BgLeft2)
		Border2:SetPoint("TOPLEFT", Border1, "BOTTOMLEFT", 21, 14)
		Border2:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border2:SetSize(128,32)
		
		-->Symble<--
		local Sign1 = s:CreateTexture(nil, "OVERLAY")
		Sign1:SetTexture(ns.Tex.Sign.AT1)
		Sign1:SetPoint("RIGHT", s, "LEFT", 1, 0)
		Sign1:SetSize(16,16)

	elseif f.mystyle == "target" then
		s:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -2)
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarPP)
		s.Filling:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 0, 0)
		--s.Filling:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling:SetSize(64,16)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarPP_bg2)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Red))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(64,16)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarPP_bg2)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.25)
		impression:SetSize(64,16)
		
		-->Border<--
		local Border1 = s:CreateTexture(nil, "BACKGROUND")
		Border1:SetTexture(ns.Tex.Frame.BgRight4)
		Border1:SetPoint("LEFT", s, "LEFT", -35, 0)
		Border1:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		Border1:SetSize(128,32)

		-->Symble<--
		local Sign1 = s:CreateTexture(nil, "OVERLAY")
		Sign1:SetTexture(ns.Tex.Sign.AT1)
		Sign1:SetPoint("LEFT", s, "RIGHT", -15, 0)
		Sign1:SetSize(16,16)
	
	elseif f.mystyle == "pet" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarPP_Screen)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling:SetAlpha(1)
		s.Filling:SetSize(64,8)
		s.Filling:SetTexCoord(0, 1, 0, 1)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarPP_Screen)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(64,8)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarPP_Screen)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(64,8)
	
	elseif f.mystyle == "focus" then
		-->Filling<--
		s.Filling = s:CreateTexture(nil, "ARTWORK")
		s.Filling:SetTexture(ns.Tex.Bar.BarPP_Screen)
		s.Filling:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling:SetAlpha(1)
		s.Filling:SetSize(64,8)
		s.Filling:SetTexCoord(0, 1, 0, 1)
		
		s.Filling_Bg = s:CreateTexture(nil, "BACKGROUND")
		s.Filling_Bg:SetTexture(ns.Tex.Bar.BarPP_Screen)
		s.Filling_Bg:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		s.Filling_Bg:SetVertexColor(unpack(ns.Tex.Color.Orange))
		s.Filling_Bg:SetAlpha(0.25)
		s.Filling_Bg:SetSize(64,8)
		
		local impression = h:CreateTexture(nil, "BACKGROUND")
		impression:SetTexture(ns.Tex.Bar.BarPP_Screen)
		impression:SetPoint("BOTTOMLEFT", s, "BOTTOMLEFT", 0, 0)
		impression:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		impression:SetAlpha(0.4)
		impression:SetSize(64,8)
		
	else
		
	end
	
    f.Power = s
    f.Power.bg = b
	f.Power.helper = h
end

-->> HP Strings <<--
ns.Lib.gen_hpstrings = function(f,unit)
	--creating helper frame--
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
	--health/name text strings--
	local info = ns.Lib.gen_fontstring(h, ns.Tex.Font.Number, ns.Cfg.Font.Number.Size, ns.Cfg.Font.Number.Outline)
    local name = ns.Lib.gen_fontstring(h, ns.Tex.Font.Name, ns.Cfg.Font.Name.Size, ns.Cfg.Font.Name.Outline)
    local hp_value = ns.Lib.gen_fontstring(h, ns.Tex.Font.Number, ns.Cfg.Font.Number.Size, ns.Cfg.Font.Number.Outline)
	local hp_PERvalue = ns.Lib.gen_fontstring(h, ns.Tex.Font.Percent, ns.Cfg.Font.Percent.Size, ns.Cfg.Font.Percent.Outline)	
	
	--info:SetShadowOffset(1,-1)
	--name:SetShadowOffset(1,-1)
	--hp_value:SetShadowOffset(1,-1)
	--hp_PERvalue:SetShadowOffset(1,-1)
	info:SetAlpha(0.8)
	name:SetAlpha(0.9)
	hp_value:SetAlpha(0.8)
	--hp_PERvalue:SetAlpha(0.0)
	--pp_PERvalue:SetAlpha(0.0)
	--druidpp:SetAlpha(0.7)
	
	if f.mystyle == "player" then
		-->Name<--
		name:SetJustifyH("LEFT")
		name:SetPoint("BOTTOMLEFT", f.Health, "TOPLEFT", 0,3)
		name:SetWidth(100)
		name:SetHeight(ns.Cfg.Font.Name.Size+2)
		
		--info:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0,-9)

		-->Value<--
		hp_value:SetJustifyH("LEFT")
		hp_value:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 0, -6)
		hp_value.frequentUpdates = 0.1
		
		--hp_PERvalue:SetPoint("TOP", f.Health, "BOTTOM", 0,-1)
		--hp_PERvalue.frequentUpdates = 0.1
		f:Tag(name, "[negeva_color][name]")
		f:Tag(hp_value,("[negeva_color][negeva_hp]"))
		
	elseif f.mystyle == "target" then
		-->Info<--
		info:SetJustifyH("RIGHT")
		info:SetPoint("BOTTOMLEFT", f.Health, "TOPRIGHT", 2,3)
		-->Name<--
		name:SetJustifyH("RIGHT")
		name:SetPoint("BOTTOMRIGHT", f.Health, "TOPRIGHT", 0,3)
		name:SetWidth(100)
		name:SetHeight(ns.Cfg.Font.Name.Size+2)
		
		-->Value<--
		hp_value:SetJustifyH("LEFT")
		hp_value:SetPoint("TOPRIGHT", f.Health, "BOTTOMRIGHT", 13, -6)
		hp_value.frequentUpdates = 0.1
		
		f:Tag(info, "|cffF27F11".."[negeva_info]")
		f:Tag(name, "[negeva_color][name]")
		f:Tag(hp_value,("[negeva_color][negeva_hp]".." | ".."[negeva_pp]"))
		
	elseif f.mystyle == "tot" or f.mystyle == "boss" then
		name:SetJustifyH("RIGHT")
		name:SetPoint("BOTTOMRIGHT", f.Health, "TOPRIGHT", 0,2)
		name:SetWidth(100)
		name:SetHeight(ns.Cfg.Font.Name.Size+2)
		f:Tag(name, '[negeva_color][name]')
		
	elseif f.mystyle == "pet" then
		name:SetJustifyH("LEFT")
		name:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 48,8)
		name:SetWidth(100)
		name:SetHeight(ns.Cfg.Font.Name.Size+2)
		f:Tag(name, '[negeva_color][name]')
		
	elseif f.mystyle == "focus" then
		name:SetJustifyH("LEFT")
		name:SetPoint("TOPLEFT", f.Health, "BOTTOMLEFT", 48,8)
		name:SetWidth(100)
		name:SetHeight(ns.Cfg.Font.Name.Size+2)
		f:Tag(name, '[negeva_color][name]')
		
	else
		name = ns.Lib.gen_fontstring(h, ns.Tex.Font.Name, ns.Cfg.Font.Name.Size, ns.Cfg.Font.Name.Outline)
		name:SetJustifyH("CENTER")
		name:SetPoint("LEFT", f.Health, "LEFT", 0,0)
		name:SetPoint("RIGHT", f.Health, "RIGHT", 0,0)
		f:Tag(name, "[negeva_color][name]")
	end
	
	--f:Tag(info, "")
	--f:Tag(hp_PERvalue,"[negeva_perhp]")
	--f:Tag(hp_value,("[negeva_color][negeva_hp]".." | ".."[negeva_pp]"))
end

ns.Lib.Focus_Target_Tag = function(f)
	-->Creating Helper Frame
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
	
	local arrow = h:CreateTexture(nil, "ARTWORK")
	arrow:SetTexture(ns.Tex.Arrow)
	arrow:SetSize(16,16)
	arrow:SetVertexColor(unpack(ns.Tex.Color.Red))
	arrow:SetAlpha(1)
	arrow:SetPoint("TOPLEFT", f, "TOPLEFT", 0,0)
	
	local arrow_bg = h:CreateTexture(nil, "ARTWORK")
	arrow_bg:SetTexture(ns.Tex.Arrow)
	arrow_bg:SetSize(16,16)
	arrow_bg:SetVertexColor(ns.Tex.Color.BgColor[1], ns.Tex.Color.BgColor[2], ns.Tex.Color.BgColor[3], 0.6)
	arrow_bg:SetAlpha(1)
	arrow_bg:SetAllPoints(arrow)
	
	local name = ns.Lib.gen_fontstring(h, ns.Tex.Font.Name, ns.Cfg.Font.Name.Size, ns.Cfg.Font.Name.Outline)
	name:SetJustifyH("LEFT")
	name:SetPoint("LEFT", arrow, "RIGHT", 0,0)
	name:SetWidth(80)
	name:SetAlpha(0.9)
	name:SetHeight(ns.Cfg.Font.Name.Size+2)
	f:Tag(name, "[negeva_color][name]")
end

-->> PP Strings <<--
ns.Lib.gen_ppstrings = function(f, unit)
    --creating helper frame--
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Power)
    h:SetFrameLevel(15)
	--power text strings--
	local pp = ns.Lib.gen_fontstring(h, ns.Tex.Font.Number, ns.Cfg.Font.Number.Size, ns.Cfg.Font.Number.Outline)
	local druidpp = ns.Lib.gen_fontstring(h, ns.Tex.Font.Number, ns.Cfg.Font.Number.Size, ns.Cfg.Font.Number.Outline)
	
	pp:SetAlpha(0.8)
	--pp:SetShadowOffset(1,-1)
	--druidpp:SetShadowOffset(1,-1)
	
	if f.mystyle == "player" then
		if playerClass == "DRUID" then
			druidpp:SetPoint("TOPRIGHT", f.Health, "BOTTOMRIGHT", 0,-18)
			f:Tag(druidpp,'[druidPower]')
		end
		pp:SetJustifyH("LEFT")
		pp:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -6)
		pp.frequentUpdates = 0.1
		f:Tag(pp,'[negeva_pp]')
	elseif f.mystyle == "target" then
		--pp:SetJustifyH("RIGHT")
		--pp:SetPoint("TOPRIGHT", f.Power, "BOTTOMRIGHT", 0, -5)
		--f:Tag(pp,'[negeva_pp]')
	end
end

-->> Portrait <<--
ns.Lib.gen_portrait = function(f, unit, min, max)
	local p = CreateFrame("PlayerModel", nil, f)
	p:SetFrameLevel(1)
	p:SetPoint("BOTTOMLEFT", f.Health, "BOTTOMLEFT", 20,0)
	p:SetPoint("TOPRIGHT", f.Health, "TOPRIGHT", -20,0)
	p:SetAlpha(0.4)

	f.Portrait = p
end

--- ----------------------------------
--> Aura Functions
--- ----------------------------------

-- filter some crap--
local Whitelist_auras = Whitelist.auras
local CustomFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
	if(Whitelist_auras[name]) then
		return true
	end 
end

--format time--
ns.Lib.FormatTime = function(s)
    local day, hour, minute = 86400, 3600, 60
    if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
    elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
    elseif s >= minute then
		--[[
		if s <= minute * 5 then
			return format('%d:%02d', floor(s/60), s % minute), s - floor(s)
		end
		--]]
		return format("%dm", floor(s/minute + 0.5)), s % minute
    elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
    end
    return format("%.1f", s), (s * 100 - floor(s * 100))/100
end


--aura timer--
ns.Lib.CreateAuraTimer = function(self,elapsed)
    if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
			self.timeLeft = self.timeLeft - self.elapsed
		else
			self.timeLeft = self.timeLeft - GetTime()
			self.first = false
        end
        if self.timeLeft > 0 then
			local time = ns.Lib.FormatTime(self.timeLeft)
			self.remaining:SetText(time)
			if self.timeLeft < 5 then
				self.remaining:SetTextColor(1, 0, 0)
			elseif self.timeLeft >= 5 and self.timeLeft < ns.Cfg.Aura.HideAuraTimer then
				self.remaining:SetTextColor(255/255, 207/255, 164/255)
			else
				self.remaining:SetText('')
				self.remaining:SetTextColor(255/255, 207/255, 164/255)
			end
        else
          self.remaining:Hide()
          self:SetScript("OnUpdate", nil)
        end
        self.elapsed = 0
      end
    end
end

--update icon--
ns.Lib.PostUpdateIcon = function(self, unit, icon, index, offset)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
	--Debuff desaturation
	if unitCaster ~= 'player' and unitCaster ~= 'vehicle' and not UnitIsFriend('player', unit) and icon.debuff then
		icon.icon:SetDesaturated(true)
	else
		icon.icon:SetDesaturated(false)
	end
	-- Creating aura timers
		if duration and duration > 0 and ns.Cfg.Aura.AuraTimer then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
	if unit == 'player' or unit == 'target' then
		icon.duration = duration
		icon.timeLeft = expirationTime
		icon.first = true
		icon:SetScript("OnUpdate", ns.Lib.CreateAuraTimer)
	end
end
--creating aura icons--
ns.Lib.PostCreateIcon = function(self, button)
	button:RegisterForClicks("RightButtonUp")
	button:SetAttribute("type", "cancelaura" )
	button:SetSize(ns.Cfg.Aura.Size, ns.Cfg.Aura.Size*ns.Cfg.Aura.HeightMulti)
	
    --button.cd:SetReverse()
    button.cd.noOCC = true		 		-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	self.disableCooldown = true		-- hide CD spiral
	self.showDebuffType = true		-- show debuff border 
	
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.icon:SetDrawLayer("BACKGROUND")
    --count
    button.count:ClearAllPoints()
	button.count:SetFont(ns.Tex.Font.Number, 10, ns.Cfg.Font.Number.Outline)
    button.count:SetJustifyH("RIGHT")
    button.count:SetPoint("TOPRIGHT", 1, 1)
    button.count:SetTextColor(242/255, 48/255, 34/255)--(0.7,0.7,0.7)
	
    --helper
    local h = CreateFrame("Frame", nil, button)
    h:SetFrameLevel(19)
    h:SetPoint("TOPLEFT",0,0)
    h:SetPoint("BOTTOMRIGHT",0,0)
    --CreateShadow(h)
	
    --another helper frame for our fontstring to overlap the cd frame
    local h2 = CreateFrame("Frame", nil, button)
    h2:SetAllPoints(button)
    h2:SetFrameLevel(20)
    button.remaining = ns.Lib.gen_fontstring(h2, ns.Tex.Font.Number, 9, ns.Cfg.Font.Number.Outline)
    button.remaining:SetPoint("BOTTOM", button, 1, -2)
	button.remaining:SetJustifyH('CENTER')
	--frame(h2)
	
    --overlay texture for debuff types display
    button.overlay:SetTexture(ns.Tex.Aura)
    button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
    button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
    button.overlay:SetTexCoord(0, 1, 0, 1)
    button.overlay.Hide = function(self) self:SetVertexColor(0, 0, 0) end
end

--auras for certain frames--
ns.Lib.createAuras = function(f)
    a = CreateFrame('Frame', nil, f)
	a:SetPoint('BOTTOMLEFT', f, 'TOPLEFT', -1, 4)	
    a['growth-x'] = 'RIGHT'
    a['growth-y'] = 'UP' 
    a.initialAnchor = 'BOTTOMLEFT'
    a.gap = true
    a.spacing = 2
    a.size = ns.Cfg.Aura.Size
    a.showDebuffType = true
    if (f.mystyle=="player" and ns.Cfg.Player.ShowAura) then
		a:SetPoint("BOTTOMRIGHT", f.Health, "BOTTOMLEFT", -20,-1)
		a:SetHeight((ns.Cfg.Aura.Size+a.spacing)*5)
		a:SetWidth((ns.Cfg.Aura.Size+a.spacing)*6)
		a.numBuffs = 15 
		a.numDebuffs = 15
	elseif f.mystyle=="target" then
		a:SetPoint("BOTTOMLEFT", f.Health, "BOTTOMRIGHT", 20,-1)
		a:SetHeight((ns.Cfg.Aura.Size+a.spacing)*5)
		a:SetWidth((ns.Cfg.Aura.Size+a.spacing)*6)
		a.numBuffs = 15 
		a.numDebuffs = 15
	elseif f.mystyle=="focus" then
		a:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 10,4)
		a:SetHeight((ns.Cfg.Aura.Size+a.spacing)*2)
		a:SetWidth((ns.Cfg.Aura.Size+a.spacing)*5)
		a.numBuffs = 5 
		a.numDebuffs = 5 
    end
    f.Auras = a
    a.PostCreateIcon = ns.Lib.PostCreateIcon
    a.PostUpdateIcon = ns.Lib.PostUpdateIcon
end
 
--buffs--
ns.Lib.createBuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.initialAnchor = "TOPLEFT"
    b["growth-y"] = "DOWN"
    b.num = 5
    b.size = ns.Cfg.Aura.Size
    b.spacing = 2
    b:SetHeight((ns.Cfg.Aura.Size+b.spacing)*2)
    b:SetWidth((ns.Cfg.Aura.Size+b.spacing)*8)
    if f.mystyle=="pet" then
		b.initialAnchor = "TOPRIGHT"
		b:SetPoint("TOPRIGHT", f, "BOTTOMLEFT", 0, -4)
		b["growth-x"] = "LEFT"
    elseif f.mystyle=="tot" then
		b:SetPoint("TOPLEFT", f, "BOTTOMRIGHT", 0, -4)
		b["growth-x"] = "RIGHT"
    elseif f.mystyle=="arena" then
		b.showBuffType = true
		b:SetPoint("TOPLEFT", f, "TOPRIGHT", b.spacing, -2)
		b.num = 4
		b:SetWidth((ns.Cfg.Aura.Size+b.spacing)*4)
    elseif f.mystyle=='party' then
		b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -b.spacing)
		b.num = 9
	elseif f.mystyle == "boss" then
		b.initialAnchor = "TOPRIGHT"
		b:SetPoint("TOPRIGHT", f.Health, "TOPLEFT", -4, 0)
		b["growth-x"] = "LEFT"
		b:SetHeight((ns.Cfg.Aura.Size+b.spacing)*1)
		b:SetWidth((ns.Cfg.Aura.Size+b.spacing)*5)
    end
    b.PostCreateIcon = ns.Lib.PostCreateIcon
    b.PostUpdateIcon = ns.Lib.PostUpdateIcon
    f.Buffs = b
end

--debuffs--
ns.Lib.createDebuffs = function(f)
    d = CreateFrame("Frame", nil, f)
    d.initialAnchor = "BOTTOMLEFT"
	d["growth-x"] = "RIGHT"
    d["growth-y"] = "UP"
    d.num = 3
	d.size = ns.Cfg.Aura.Size
    d.spacing = 2
	d:SetFrameLevel(19)
    d:SetHeight((ns.Cfg.Aura.Size+d.spacing)*2)
    d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*5)
    d.showDebuffType = true
	if (f.mystyle == "player" and ns.Cfg.Player.ShowDebuff) then
		d.num = 18
		d:SetPoint("BOTTOMRIGHT", f.Health, "BOTTOMLEFT", -20,-1)
		d.initialAnchor = "BOTTOMRIGHT"
		d["growth-x"] = "LEFT"
		d['growth-y'] = 'UP' 
		d:SetHeight((ns.Cfg.Aura.Size+d.spacing)*3)
		d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*6)
    elseif f.mystyle == "pet" then
		d:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, -4)
		d.initialAnchor = "TOPRIGHT"
		d["growth-x"] = "LEFT"
		d['growth-y'] = "BOTTOM"
		d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*3)
	elseif f.mystyle == "focus" then
		d.num = 5
		d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 10,4)
		d.initialAnchor = "TOPRIGHT"
		d["growth-x"] = "RIGHT"
		d['growth-y'] = "UP"
		d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*5)
    elseif f.mystyle == "tot" then
		d:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -4)
		d.initialAnchor = "TOPLEFT"
		d["growth-x"] = "RIGHT"
		d['growth-y'] = "BOTTOM"
		d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*3)
    elseif f.mystyle == "arena" then
		d.showDebuffType = true
		d:SetPoint("BOTTOMLEFT", f, "TOPLEFT", -d.spacing, 4)
		d.initialAnchor = "TOPLEFT"
		d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*4)
    elseif f.mystyle == "party" then
		d.num = 4
		d:SetPoint("BOTTOMLEFT", f.Health, "TOPLEFT", 0, 4)
		d.initialAnchor = "BOTTOMLEFT"
		d["growth-x"] = "RIGHT"
		d['growth-y'] = "UP"
		d:SetHeight((ns.Cfg.Aura.Size+d.spacing)*1)
		d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*4)
	elseif f.mystyle == "raid" then
		d.CustomFilter = CustomFilter
		d.num = 2
		d.size = 16
		d:SetPoint("CENTER", f, "CENTER", -d.spacing, -2)
		d["growth-x"] = "LEFT"
		d:SetHeight(d.size+d.spacing)
		d:SetWidth((d.size+d.spacing)*2)
	elseif f.mystyle == "boss" then
		d.CustomFilter = DebuffFilter
		d.num = 6
		d:SetPoint("BOTTOMLEFT", f.Health, "BOTTOMRIGHT", 20,-1)
		d["growth-x"] = "RIGHT"
		d['growth-y'] = "UP"
		d:SetHeight((ns.Cfg.Aura.Size+d.spacing)*1)
		d:SetWidth((ns.Cfg.Aura.Size+d.spacing)*6)
    end
    d.PostCreateIcon = ns.Lib.PostCreateIcon
    d.PostUpdateIcon = ns.Lib.PostUpdateIcon
    f.Debuffs = d
end

--- ----------------------------------
--> Icons
--- ----------------------------------

ns.Lib.gen_InfoIcons = function(f)
    local h = CreateFrame("Frame",nil,f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(17)
--[[
	-->LFD Role 
	if f.mystyle == 'party' then
		local LFD_role = ns.Lib.gen_fontstring(f.Health, ns.Tex.Font.Number, 9, ns.Cfg.Font.Number.Outline)
		LFD_role:SetPoint("CENTER", f.Health, "CENTER", 0,0)
		LFD_role:SetShadowOffset(1.25, -1.25)
		f:Tag(LFD_role, '[negeva_LFD]')
	end
--]]
--[[
	--LFD role indicator
	f.LFDRole = h:CreateTexture(nil, 'OVERLAY')
	f.LFDRole:SetSize(12,12)
	f.LFDRole:SetTexture("Interface\\AddOns\\oUF_Langley\\media\\lfd_role")
	if f.mystyle == 'party' then
		f.LFDRole:SetPoint("TOPLEFT", f, "TOPLEFT", 0,-2)
	end
	
	--Leader icon
    li = h:CreateTexture(nil, "OVERLAY")
	li:SetSize(8,3)
	if f.mystyle == 'player' then
		li:SetPoint("TOPLEFT", f, "TOPLEFT", 2,-1)
	elseif f.mystyle == 'target' then
		li:SetPoint("TOPLEFT", f, "TOPLEFT", 2,-1)
	end
	
	li:SetTexture(cfg.sigh)
	li:SetVertexColor(98/255, 244/255, 179/255, 1)
    f.Leader = li

    --Assist icon
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("CENTER", f.Leader, "CENTER", 0,0)
	ai:SetSize(16,16)
    f.Assistant = ai
	
    --MasterLooter icon
    local ml = h:CreateTexture(nil, 'OVERLAY')
	ml:SetSize(8,3)
	if f.mystyle == 'player' then
		ml:SetPoint('RIGHT', f.Leader, 'LEFT')
	elseif f.mystyle == 'target' then
		ml:SetPoint('LEFT', f.Leader, 'RIGHT')
	end
	ml:SetTexture(cfg.sigh)
	ml:SetVertexColor(98/255, 244/255, 179/255, 1)
    f.MasterLooter = ml
	
	if f.mystyle == 'player' then
	--Combat icon
		CIc = h:CreateTexture(nil, 'OVERLAY')
		CIc:SetSize(8, 3)
		CIc:SetPoint("TOPRIGHT", f.Power, "TOPRIGHT", -2, 7)
		CIc:SetTexture(cfg.sigh)
		CIc:SetVertexColor(242/255, 48/255, 34/255, 1)
		f.Combat = CIc
	
	--Rested icon
		RIc = h:CreateTexture(nil, 'OVERLAY')
		RIc:SetSize(8, 3)
		RIc:SetTexture(cfg.sigh)
		RIc:SetPoint("RIGHT", CIc, "LEFT", -5, 0)
		RIc:SetVertexColor(124/255, 252/255, 0, 1)
		f.Resting = RIc
    end
	--]]
end

--[[		
		--icons
		self.RaidIcon = func.createIcon(self,"BACKGROUND",18,self.Name,"RIGHT","LEFT",0,0,-1)
		self.ReadyCheck = func.createIcon(self.Health,"OVERLAY",24,self.Health,"CENTER","CENTER",0,0,-1)
		if self.Border then
			self.Leader = func.createIcon(self,"BACKGROUND",13,self.Border,"BOTTOMRIGHT","BOTTOMLEFT",16,18,-1)
			if self.cfg.portrait.use3D then
				self.LFDRole = func.createIcon(self.BorderHolder,"OVERLAY",12,self.Portrait,"TOP","BOTTOM",0,5,5)  
			else
				self.LFDRole = func.createIcon(self.PortraitHolder,"OVERLAY",12,self.Portrait,"TOP","BOTTOM",0,5,5)  
			end
		else
			self.Leader = func.createIcon(self,"BACKGROUND",13,self,"RIGHT","LEFT",16,-18,-1)
			self.LFDRole = func.createIcon(self,"BACKGROUND",12,self,"RIGHT","LEFT",16,18,-1)    
		end
		self.LFDRole:SetTexture("Interface\\AddOns\\rTextures\\lfd_role")
		--self.LFDRole:SetDesaturated(1)    
    
		--threat
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", func.checkThreat)
	
		self.LFDRole = func.createIcon(self.Health,"LOW",12,self.Health,"TOP","BOTTOM",0,4,-1)
		self.LFDRole:SetTexture("Interface\\AddOns\\rTextures\\lfd_role")
		self.LFDRole:SetDesaturated(1)--降低饱和度	
--]]

--gen raid mark icons
ns.Lib.gen_RaidMark = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(17)
    h:SetAlpha(1)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
	ri:SetTexture(ns.Tex.Sign.Raidicons)
	if f.mystyle == 'player' then
		ri:SetPoint("CENTER", f.Health, "CENTER", 0,0)
	elseif f.mystyle == 'party' then
		ri:SetPoint("RIGHT", f, "RIGHT", 0, 0)
	end
    ri:SetSize(16, 16)
    f.RaidIcon = ri
end

--- ----------------------------------
--> Unit specific stuff
--- ----------------------------------

ns.Lib.gen_Runes = function(self)
	if playerClass ~= "DEATHKNIGHT" then return end
	local runes = CreateFrame("Frame", nil, self)
	runes:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1,-5)
	runes:SetFrameStrata("LOW")
	runes:SetSize(self.Health:GetWidth()/2-4, 8)

	for i = 1, 6 do
		runes[i] = CreateFrame("StatusBar", nil, runes)
		runes[i]:SetHeight(runes:GetHeight())
		runes[i]:SetWidth((runes:GetWidth() - 5) / 6)
		runes[i]:SetOrientation("VERTICAL")

		if (i == 1) then
			runes[i]:SetPoint("LEFT", runes)
		else
			runes[i]:SetPoint("LEFT", runes[i-1], "RIGHT", 1, 0)
		end
		runes[i]:SetStatusBarTexture(ns.Tex.Bar.Bar)
		runes[i]:GetStatusBarTexture():SetHorizTile(false)
		frame(runes[i])
	end
				
	runes.backdrop = CreateFrame("Frame", nil, runes)
	--CreateShadow(runes.backdrop)
	runes.backdrop:SetBackdropBorderColor(.2,.2,.2,1)
	runes.backdrop:SetPoint("TOPLEFT", -2, 2)
	runes.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	runes.backdrop:SetFrameLevel(runes:GetFrameLevel() - 1)

	self.Runes = runes
end

ns.Lib.gen_CPoints = function(self)
	local bars = CreateFrame("Frame", nil, self)
	bars:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1,-5)
	bars:SetSize(self.Health:GetWidth()/2-4, 8)
	bars:SetBackdropBorderColor(0,0,0,0)
	bars:SetBackdropColor(0,0,0,0)
		
	for i = 1, 5 do					
		bars[i] = CreateFrame("StatusBar", self:GetName().."_Combo"..i, bars)
		bars[i]:SetHeight(bars:GetHeight())					
		bars[i]:SetStatusBarTexture(ns.Tex.Bar.Bar)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)
							
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		bars[i]:SetAlpha(0.8)
		bars[i]:SetWidth((bars:GetWidth() - 4)/5)
		frame(bars[i])
	end
		
	bars[1]:SetStatusBarColor(138/255, 255/255, 48/255, 1)		
	bars[2]:SetStatusBarColor(138/255, 255/255, 48/255, 1)
	bars[3]:SetStatusBarColor(255/255, 241/255, 48/255, 1)
	bars[4]:SetStatusBarColor(255/255, 241/255, 48/255, 1)
	bars[5]:SetStatusBarColor(255/255, 97/255, 97/255, 1)
		
	self.CPoints = bars
	self.CPoints.Override = ComboDisplay
		
	bars.FrameBackdrop = CreateFrame("Frame", nil, bars[1])
	--CreateShadow(bars.FrameBackdrop)
	bars.FrameBackdrop:SetBackdropBorderColor(.2,.2,.2,1)
	bars.FrameBackdrop:SetPoint("TOPLEFT", bars, "TOPLEFT", -2, 2)
	bars.FrameBackdrop:SetPoint("BOTTOMRIGHT", bars, "BOTTOMRIGHT", 2, -2)
	bars.FrameBackdrop:SetFrameLevel(bars:GetFrameLevel() - 1)
end

ns.Lib.gen_EclipseBar = function(self)
	if playerClass ~= "DRUID" then return end
	local eclipseBar = CreateFrame('Frame', nil, self)
	eclipseBar:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1,-5)
	eclipseBar:SetSize(self.Health:GetWidth()/2-4, 8)
	
	local h = CreateFrame("Frame", nil, eclipseBar)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-0,0)
	h:SetPoint("BOTTOMRIGHT",0,-0)
	frame(h)
	--CreateShadow(h)
	local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
	lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
	lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	lunarBar:SetStatusBarTexture(ns.Tex.Bar.Bar)
	lunarBar:SetStatusBarColor(0, 0, 1)
	eclipseBar.LunarBar = lunarBar
	local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
	solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	solarBar:SetStatusBarTexture(ns.Tex.Bar.Bar)
	solarBar:SetStatusBarColor(1, 3/5, 0)
	eclipseBar.SolarBar = solarBar
	local eclipseBarText = solarBar:CreateFontString(nil, 'OVERLAY')
	eclipseBarText:SetPoint('CENTER', eclipseBar, 'CENTER', 0, 1)
	eclipseBarText:SetFont(ns.Tex.Font.Number, 10, ns.Cfg.Font.Number.Outline)
	self:Tag(eclipseBarText, '[pereclipse]%')
	self.EclipseBar = eclipseBar
end

ns.Lib.gen_Shards = function(self)
	if playerClass ~= "WARLOCK" then return end
	local bars = CreateFrame("Frame", nil, self)
	bars:SetFrameStrata("LOW")
	bars:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1,-5)
	bars:SetSize(self.Health:GetWidth()/2-4, 8)

	for i = 1, 3 do					
		bars[i]=CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(bars:GetHeight())					
		bars[i]:SetStatusBarTexture(ns.Tex.Bar.Bar)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
		bars[i]:SetStatusBarColor(148/255, 130/255, 201/255)
		bars[i].bg:SetTexture(148/255, 130/255, 201/255)
					
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		bars[i].bg:SetAllPoints(bars[i])
		bars[i]:SetWidth((bars:GetWidth() - 2)/3)
		bars[i].bg:SetTexture(ns.Tex.Bar.Bar)					
		bars[i].bg:SetAlpha(0.8)
		frame(bars[i])
	end
	bars.Override = UpdateShards
	self.SoulShards = bars
	
	bars.backdrop = CreateFrame("Frame", nil, bars)
	--CreateShadow(bars.backdrop)
	bars.backdrop:SetBackdropBorderColor(.2,.2,.2,1)
	bars.backdrop:SetPoint("TOPLEFT", -0, 0)
	bars.backdrop:SetPoint("BOTTOMRIGHT", 0, -0)
	bars.backdrop:SetFrameLevel(bars:GetFrameLevel() - 1)
end

ns.Lib.gen_HolyPower = function(self)
	if playerClass ~= "PALADIN" then return end
	local bars = CreateFrame("Frame", nil, self)
	bars:SetFrameStrata("LOW")
	bars:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1,-5)
	bars:SetSize(self.Health:GetWidth()/2-4, 8)

	for i = 1, 3 do					
		bars[i]=CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(bars:GetHeight())					
		bars[i]:SetStatusBarTexture(ns.Tex.Bar.Bar)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i]:SetStatusBarColor(228/255,225/255,16/255)
					
		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		frame(bars[i])
		
		bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
		bars[i].bg:SetAllPoints(bars[i])
		bars[i]:SetWidth((bars:GetWidth() - 2)/3)
		bars[i].bg:SetTexture(ns.Tex.Bar.Bar)
		bars[i].bg:SetVertexColor(0, 0, 0, 0)		
		bars[i].bg:SetAlpha(1)
	end
				
	bars.backdrop = CreateFrame("Frame", nil, bars)
	--CreateShadow(bars.backdrop)
	bars.backdrop:SetBackdropBorderColor(.2,.2,.2,1)
	bars.backdrop:SetPoint("TOPLEFT", -2, 2)
	bars.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	bars.backdrop:SetFrameLevel(bars:GetFrameLevel() - 1)
	bars.Override = UpdateHoly
	self.HolyPower = bars	
end

--gen TotemBar for shamans--
ns.Lib.TotemBars = function(self)
	--if cfg.TotemBars then
		if playerClass ~= "SHAMAN" then return end
		
		self.TotemBar = {}
		self.TotemBar.Destroy = true
		self.TotemBar.colors = {{233/255, 46/255, 16/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}
		local TotemBar = CreateFrame('Frame', nil, self)
		TotemBar:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1,-5)
		TotemBar:SetSize(self.Health:GetWidth()/2-4, 8)
		TotemBar:SetFrameStrata("LOW")
		
		for i = 1, 4 do
			self.TotemBar[i] = CreateFrame("StatusBar", nil, TotemBar)
			self.TotemBar[i]:SetHeight(TotemBar:GetHeight())
			self.TotemBar[i]:SetWidth((TotemBar:GetWidth()-3)/4)
			self.TotemBar[i]:SetStatusBarTexture(ns.Tex.Bar.Bar)
			--self.TotemBar[i]:SetFrameLevel(11)
			--self.TotemBar[i]:SetOrientation("VERTICAL")
			if (i == 1) then
				self.TotemBar[i]:SetPoint("LEFT", TotemBar, "LEFT", 0, 0)
			else
				self.TotemBar[i]:SetPoint('TOPLEFT', self.TotemBar[i-1], "TOPRIGHT", 1, 0)
			end
			self.TotemBar[i]:GetStatusBarTexture():SetHorizTile(false)
			self.TotemBar[i]:SetMinMaxValues(0, 1)
			frame(self.TotemBar[i])
			
			self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
			self.TotemBar[i].bg:SetAllPoints()
			self.TotemBar[i].bg:SetTexture(ns.Tex.Bar.Bar)
			self.TotemBar[i].bg:SetVertexColor(0, 0, 0, 0)
		end	
	--end
end

--gen class specific power display--
--[[
  ns.Lib.gen_specificpower = function(f, unit)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(10)
    local sp = ns.Lib.gen_fontstring(h, cfg.font, 30, "THINOUTLINE")
    sp:SetPoint("CENTER", f.Health, "CENTER",0,3)
    f:Tag(sp, '[mono:sp][mono:orbs]')
  end
--]]

-->>Fire Control System<<--
ns.Lib.gen_FCS = function(f)
-->Combo Points
	if ns.Cfg.FCS.ComboPoints then
		local h = CreateFrame("Frame", nil, f)
		h:SetAllPoints(f.Health)
		h:SetFrameLevel(10)
		local cp = ns.Lib.gen_fontstring(h, ns.Tex.Font.Square, 26, "OUTLINE MONOCHROME")
		cp:SetPoint("TOP",UIParent,"CENTER", 0,-85)
		f:Tag(cp, '[combo]')
	end
-->SwingBar
	if ns.Cfg.FCS.SwingBar then
		createSwingBar(f)
	end
end
