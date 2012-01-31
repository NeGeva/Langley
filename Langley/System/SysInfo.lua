local T, C, F = unpack(select(2, ...))
local mediaFolder = "Interface\\Addons\\Langley\\System\\Media\\"

local format = string.format
local floor = math.floor

--- ----------------------------------
--> Button
--- ----------------------------------
--Button(82/128,32),Display(64,32),Board(82/128,128),StatusBar(44/64,8),StatusBarBg(46/64,8)
--
local Lv1,Lv2,Lv3 = 1,19,20
local cs = CreateFrame("Frame", nil, UIParent)
cs:SetFrameLevel(1)
cs:SetFrameStrata("HIGH")
cs:SetSize(82,32)
cs:Show()
cs:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50,-1)

local function CTex(f)
	f:SetFrameLevel(Lv2)
	f:SetFrameStrata("HIGH")
	f:SetSize(82,32)
	f:Show()
	
	f.tex = f:CreateTexture(nil, "BACKGROUND")
	f.tex:SetTexture(mediaFolder.."Button")
	f.tex:SetSize(82,32)
	f.tex:SetTexCoord(0,82/128,0,1)
	f.tex:SetVertexColor(unpack(T.Color.BgColor))
	f.tex:SetAlpha(0.8)
	f.tex:SetPoint("TOP", f, "TOP", 0,0)

	f.barbg = f:CreateTexture(nil, "BACKGROUND")
	f.barbg:SetTexture(mediaFolder.."StatusbarBg")
	f.barbg:SetSize(46,8)
	f.barbg:SetTexCoord(0,46/64,0,1)
	f.barbg:SetVertexColor(unpack(T.Color.BgColor))
	f.barbg:SetAlpha(0.8)
	f.barbg:SetPoint("TOP", f, "BOTTOM", 0,4)

	f.board = f:CreateTexture(nil, "BACKGROUND")
	f.board:SetTexture(mediaFolder.."Board")
	f.board:SetSize(82,128)
	f.board:SetTexCoord(0,82/128,0,1)
	f.board:SetVertexColor(unpack(T.Color.BgColor))
	f.board:SetAlpha(0.8)
	f.board:SetPoint("TOP", f, "BOTTOM", 0,0)
end

-->Button1
local Button1 = CreateFrame("Button", nil, UIParent)
Button1:SetPoint("BOTTOMRIGHT", cs, "BOTTOMRIGHT", 0,0)
CTex(Button1)

-->Display1
local Display1 = CreateFrame("Frame", nil, UIParent)
Display1:SetFrameLevel(Lv1)
Display1:SetSize(64,32)
Display1:Show()
Display1:SetPoint("BOTTOMRIGHT", cs, "BOTTOMRIGHT", 15-82,1)

local Display1_Bg = Display1:CreateTexture(nil, "BACKGROUND")
Display1_Bg:SetTexture(mediaFolder.."Display")
Display1_Bg:SetSize(64,32)
Display1_Bg:SetVertexColor(unpack(T.Color.BgColor))
Display1_Bg:SetAlpha(0.8)
Display1_Bg:SetPoint("BOTTOMRIGHT", Display1, "BOTTOMRIGHT", 0,0)

-->Button2
local Button2 = CreateFrame("Button", nil, UIParent)
Button2:SetPoint("BOTTOMRIGHT", cs, "BOTTOMRIGHT", 2*15-82-64,0)
CTex(Button2)

-->Display2
local Display2 = CreateFrame("Frame", nil, UIParent)
Display2:SetFrameLevel(Lv1)
Display2:SetSize(64,32)
Display2:Show()
Display2:SetPoint("BOTTOMRIGHT", cs, "BOTTOMRIGHT", 3*15-2*82-64,1)

local Display2_Bg = Display2:CreateTexture(nil, "BACKGROUND")
Display2_Bg:SetTexture(mediaFolder.."Display")
Display2_Bg:SetSize(64,32)
Display2_Bg:SetVertexColor(unpack(T.Color.BgColor))
Display2_Bg:SetAlpha(0.8)
Display2_Bg:SetPoint("BOTTOMRIGHT", Display2, "BOTTOMRIGHT", 0,0)

-->Button3
local Button3 = CreateFrame("Button", nil, UIParent)
Button3:SetPoint("BOTTOMRIGHT", cs, "BOTTOMRIGHT", 4*15-2*82-2*64,0)
CTex(Button3)



-->Script
local function MoveUp(f,y,l)
	local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint()
	f:SetScript("OnUpdate",function(self)
		local step = 1/F.Timer(0.3)
		if yOfs <= y-l*step then
			yOfs = yOfs+l*step
			f:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
		else
			f:SetPoint(point, relativeTo, relativePoint, xOfs, y)
		end
	end)
end

local function MoveDown(f,y,l)
	local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint()
	f:SetScript("OnUpdate",function(self)
		local step = 1/F.Timer(0.3)
		if yOfs > y+l*step then
			yOfs = yOfs-l*step
			f:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
		else
			f:SetPoint(point, relativeTo, relativePoint, xOfs, y)
		end
	end)
end

-->Durability
local function Durability(f)
	f.DuraBar = f:CreateTexture(nil, "ARTWORK")
	f.DuraBar:SetTexture(mediaFolder.."Statusbar")
	f.DuraBar:SetSize(44,8)
	f.DuraBar:SetTexCoord(0,44/64,0,1)
	f.DuraBar:SetVertexColor(unpack(T.Color.BgColor))
	f.DuraBar:SetAlpha(1.0)
	f.DuraBar:SetPoint("TOPLEFT", f, "BOTTOM", -22,4)

	f.DuraTxt = f:CreateFontString(nil, "ARTWORK")
	f.DuraTxt:SetFont(T.Font.basic03, 12, nil)--"OUTLINE MONOCHROME"
	f.DuraTxt:SetAlpha(0.8)
	f.DuraTxt:SetPoint("BOTTOM", f, "BOTTOM", 0, 5)
	f.DuraTxt:SetJustifyH("CENTER")
	
	Dura = {
		[1] = {1, "Head", 1000},
		[2] = {3, "Shoulder", 1000},
		[3] = {5, "Chest", 1000},
		[4] = {6, "Waist", 1000},
		[5] = {9, "Wrist", 1000},
		[6] = {10, "Hands", 1000},
		[7] = {7, "Legs", 1000},
		[8] = {8, "Feet", 1000},
		[9] = {16, "Main Hand", 1000},
		[10] = {17, "Off Hand", 1000},
		[11] = {18, "Ranged", 1000},
	}

	local Slots = Dura--["durtable"]
	local Total = 0
	local current, max

	f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	f:RegisterEvent("MERCHANT_SHOW")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		for i = 1, 11 do
			if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
				current, max = GetInventoryItemDurability(Slots[i][1])
				if current then 
					Slots[i][3] = current/max
					Total = Total + 1
				end
			end
		end
	
		table.sort(Slots, function(a, b) return a[3] < b[3] end)
	
		f.DuraTxt:SetText(F.Hex(T.Color.Orange)..floor(Slots[1][3]*100).."|r")
	
		local d, d2
		if Total == 0 then
			d = 0.00001
			d2 = 0
		else
			d = Slots[1][3]
			d2 = floor(Slots[1][3]*100)
		end
		
		if d2 < 30 then
			f.DuraBar:SetVertexColor(unpack(T.Color.Red))
		elseif(d2>=30 and d2<70) then
			f.DuraBar:SetVertexColor(unpack(T.Color.Orange))
		else
			f.DuraBar:SetVertexColor(unpack(T.Color.Orange))
		end
		f.DuraBar:SetWidth(math.abs(d) * 44)
   		f.DuraBar:SetTexCoord(0, math.abs(d)*44/64, 0, 1)
	
		Total = 0	
	end)
	
	f:SetScript("OnMouseDown", function(self, button) 
		if (button == "LeftButton") then
			if InCombatLockdown() then return end
			ReloadUI()
		elseif (button == "RightButton") then
			local yoff = select(5, self:GetPoint())
			if yoff == 0 then MoveUp(self,110,110)
			else MoveDown(self,0,110) 
			end	
		end
	end)
end

-->Container
local function Bag(f)
	f.BagBar = f:CreateTexture(nil, "ARTWORK")
	f.BagBar:SetTexture(mediaFolder.."Statusbar")
	f.BagBar:SetSize(44,8)
	f.BagBar:SetTexCoord(0,44/64,0,1)
	f.BagBar:SetVertexColor(unpack(T.Color.BgColor))
	f.BagBar:SetAlpha(1.0)
	f.BagBar:SetPoint("TOPLEFT", f, "BOTTOM", -22,4)

	f.BagTxt = f:CreateFontString(nil, "ARTWORK")
	f.BagTxt:SetFont(T.Font.basic03, 12, nil)--"OUTLINE MONOCHROME"
	f.BagTxt:SetAlpha(0.8)
	f.BagTxt:SetPoint("BOTTOM", f, "BOTTOM", 0, 5)
	f.BagTxt:SetJustifyH("CENTER")
	

	f:RegisterEvent("PLAYER_LOGIN")
	f:RegisterEvent("BAG_UPDATE")
	f:SetScript("OnEvent", function(self, event)
		local free,total = 0, 0
		for i = 0, NUM_BAG_SLOTS do
			local freeslots = GetContainerNumFreeSlots(i)
			free, total = free + freeslots, total + GetContainerNumSlots(i)
		end
	
		f.BagTxt:SetText(F.Hex(T.Color.Orange)..free.."|r")
	
		local d, d2
		if free == 0 then
			d = 0.00001
			d2 = 0
		else
			d = free/total
			d2 = floor(free/total*100)
		end
		
		if d2 < 20 then
			f.BagBar:SetVertexColor(unpack(T.Color.Red))
		elseif(d2>=20 and d2<70) then
			f.BagBar:SetVertexColor(unpack(T.Color.Orange))
		else
			f.BagBar:SetVertexColor(unpack(T.Color.Orange))
		end
		f.BagBar:SetWidth(math.abs(d-1) * 44)
   		f.BagBar:SetTexCoord(0, math.abs(d-1)*44/64, 0, 1)
		free,total = 0,0
	end)
	f:SetScript("OnMouseDown", function(self, button) 
		if (button == "LeftButton") then
			OpenAllBags()
			--ToggleBag(0)
		elseif (button == "RightButton") then
			local yoff = select(5, self:GetPoint())
			if yoff == 0 then MoveUp(self,110,110)
			else MoveDown(self,0,110) 
			end	
		end
	end)
end

-->Timer
local function Timer(f)
	f.LateBar = f:CreateTexture(nil, "ARTWORK")
	f.LateBar:SetTexture(mediaFolder.."Statusbar")
	f.LateBar:SetSize(44,8)
	f.LateBar:SetTexCoord(0,44/64,0,1)
	f.LateBar:SetVertexColor(unpack(T.Color.BgColor))
	f.LateBar:SetAlpha(1.0)
	f.LateBar:SetPoint("TOPLEFT", f, "BOTTOM", -22,4)

	f.TimeTxt = f:CreateFontString(nil, "ARTWORK")
	f.TimeTxt:SetFont(T.Font.basic03, 12, nil)--"OUTLINE MONOCHROME"
	f.TimeTxt:SetAlpha(0.8)
	f.TimeTxt:SetPoint("BOTTOM", f, "BOTTOM", 0, 5)
	f.TimeTxt:SetJustifyH("CENTER")
	
	f:SetScript("OnUpdate", function(self) 
		local late, r = select(4,GetNetStats()), 200
		local d, d2
		if late == 0 then
			d = 0.00001
			d2 = 0
		else
			d = min(late/r,1)
			d2 = floor(d*100)
		end
		
		if late < 200 then
			--f.LateBar:SetVertexColor(unpack(T.Color["3.0"]))
			local r,g,b = F.Gradient(d,T.Color["3.0"],T.Color["Red"])
			f.LateBar:SetVertexColor(r,g,b)
		else
			local r,g,b = F.Gradient(d,T.Color["3.0"],T.Color["Red"])
			f.LateBar:SetVertexColor(r,g,b)
		end
		f.LateBar:SetWidth(math.abs(d) * 44)
   		f.LateBar:SetTexCoord(0, math.abs(d)*44/64, 0, 1)
		late = 0
		
		local hour,minute = GetGameTime()
		f.TimeTxt:SetText(F.Hex(T.Color.Orange)..hour .. ":" .. minute.."|r")
	end)
	
	f:SetScript("OnMouseDown", function(self, button) 
		if (button == "LeftButton") then
			OpenAllBags()
			--ToggleBag(0)
		elseif (button == "RightButton") then
			local yoff = select(5, self:GetPoint())
			if yoff == 0 then MoveUp(self,110,110)
			else MoveDown(self,0,110) 
			end	
		end
	end)
end

-->Timer Board
local function Timer_B(f)
	f.Late = CreateFrame("Frame", nil, f)
	f.Late:SetFrameLevel(Lv3)
	f.Late:SetFrameStrata("HIGH")
	f.Late:SetSize(66,46)
	f.Late:SetPoint("TOP", f, "BOTTOM", 0,-10)
	
	f.Late_Bg = f.Late:CreateTexture(nil, "BACKGROUND")
	f.Late_Bg:SetTexture(T.Line)
	f.Late_Bg:SetSize(66,46)
	f.Late_Bg:SetVertexColor(0,0,0)
	f.Late_Bg:SetAlpha(0.2)
	f.Late_Bg:SetPoint("TOP", f.Late, "TOP", 0,0)
	
	f.Late_Bg_T = f.Late:CreateTexture(nil, "BORDER")
	f.Late_Bg_T:SetTexture(mediaFolder.."Top")
	f.Late_Bg_T:SetSize(128,16)
	f.Late_Bg_T:SetVertexColor(unpack(T.Color.Orange))
	f.Late_Bg_T:SetAlpha(0.8)
	f.Late_Bg_T:SetPoint("TOPLEFT", f.Late, "TOPLEFT", -3,3)
	
	f.Late_Bg_B = f.Late:CreateTexture(nil, "BORDER")
	f.Late_Bg_B:SetTexture(mediaFolder.."Bottom")
	f.Late_Bg_B:SetSize(128,16)
	f.Late_Bg_B:SetVertexColor(unpack(T.Color.Orange))
	f.Late_Bg_B:SetAlpha(0.8)
	f.Late_Bg_B:SetPoint("BOTTOMLEFT", f.Late, "BOTTOMLEFT", -3,-3)
	
	f.LateTxt_S = f.Late:CreateTexture(nil, "BORDER")
	f.LateTxt_S:SetTexture(mediaFolder.."Latency")
	f.LateTxt_S:SetSize(16,16)
	f.LateTxt_S:SetVertexColor(unpack(T.Color.Orange))
	f.LateTxt_S:SetAlpha(0.8)
	f.LateTxt_S:SetPoint("TOPLEFT", f.Late, "TOPLEFT", 2,-3)
	
	f.LateTxt = f.Late:CreateFontString(nil, "ARTWORK")
	f.LateTxt:SetFont(T.Font.basic05, 9, "OUTLINE MONOCHROME")--"OUTLINE MONOCHROME"
	f.LateTxt:SetAlpha(0.6)
	f.LateTxt:SetPoint("TOPRIGHT", f.Late, "TOPRIGHT", -6, -6)
	f.LateTxt:SetJustifyH("RIGHT")
	f.LateTxt:SetText(F.Hex(T.Color.Orange).."--".."|r")
	
	f.MemoTxt_S = f.Late:CreateTexture(nil, "BORDER")
	f.MemoTxt_S:SetTexture(mediaFolder.."Memory")
	f.MemoTxt_S:SetSize(16,16)
	f.MemoTxt_S:SetVertexColor(unpack(T.Color.Orange))
	f.MemoTxt_S:SetAlpha(0.8)
	f.MemoTxt_S:SetPoint("TOP", f.LateTxt_S, "BOTTOM", 0,4)
	
	f.MemoTxt = f.Late:CreateFontString(nil, "ARTWORK")
	f.MemoTxt:SetFont(T.Font.basic05, 9, "OUTLINE MONOCHROME")--"OUTLINE MONOCHROME"
	f.MemoTxt:SetAlpha(0.6)
	f.MemoTxt:SetPoint("TOPRIGHT", f.LateTxt, "BOTTOMRIGHT", 0, -3)
	f.MemoTxt:SetJustifyH("RIGHT")
	f.MemoTxt:SetText(F.Hex(T.Color.Orange).."--".."|r")
	
	f.FPSTxt_S = f.Late:CreateTexture(nil, "BORDER")
	f.FPSTxt_S:SetTexture(mediaFolder.."FramePS")
	f.FPSTxt_S:SetSize(16,16)
	f.FPSTxt_S:SetVertexColor(unpack(T.Color.Orange))
	f.FPSTxt_S:SetAlpha(0.8)
	f.FPSTxt_S:SetPoint("TOP", f.MemoTxt_S, "BOTTOM", 0,4)
	
	f.FPSTxt = f.Late:CreateFontString(nil, "ARTWORK")
	f.FPSTxt:SetFont(T.Font.basic05, 9, "OUTLINE MONOCHROME")--"OUTLINE MONOCHROME"
	f.FPSTxt:SetAlpha(0.6)
	f.FPSTxt:SetPoint("TOPRIGHT", f.MemoTxt, "BOTTOMRIGHT", 0, -3)
	f.FPSTxt:SetJustifyH("RIGHT")
	f.FPSTxt:SetText(F.Hex(T.Color.Orange).."--".."|r")
	
	f.Late:SetScript("OnUpdate", function(self)
		local down, up, lagHome, lagWorld = GetNetStats()
		f.LateTxt:SetText(F.Hex(T.Color.Orange)..lagWorld .. "ms".."|r")
		
		local totalMemo = 0
		UpdateAddOnMemoryUsage()
		for i = 1, GetNumAddOns() do 
			totalMemo = totalMemo + GetAddOnMemoryUsage(i)
		end
		if totalMemo >= 1024 then 
			Memo = format("%.1fm", totalMemo / 1024)
		else
			Memo = format("%.0fk", totalMemo)
		end
		f.MemoTxt:SetText(F.Hex(T.Color.Orange)..Memo.."|r")
		totalMemo = 0
		
		local fps = floor(GetFramerate())
		f.FPSTxt:SetText(F.Hex(T.Color.Orange)..fps.."|r")
	end)
	
	f.BuClock = CreateFrame("Frame", nil, f)
	f.BuClock:SetFrameLevel(Lv3)
	f.BuClock:SetFrameStrata("HIGH")
	f.BuClock:SetSize(43,20)
	f.BuClock:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", -8,-56-5)
	
	f.BuClock.B = f.BuClock:CreateTexture(nil, "OVERLAY")
	f.BuClock.B:SetTexture(mediaFolder.."Border1")
	f.BuClock.B:SetSize(64,32)
	f.BuClock.B:SetVertexColor(unpack(T.Color.Orange))
	f.BuClock.B:SetAlpha(0.8)
	f.BuClock.B:SetPoint("RIGHT", f.BuClock, "RIGHT", 11,0)
	
	f.BuClock.T = f.BuClock:CreateTexture(nil, "OVERLAY")
	f.BuClock.T:SetTexture(mediaFolder.."Clock")
	f.BuClock.T:SetSize(32,16)
	f.BuClock.T:SetVertexColor(unpack(T.Color.Orange))
	f.BuClock.T:SetAlpha(0.8)
	f.BuClock.T:SetPoint("TOPLEFT", f.BuClock, "TOPLEFT", 5,-2)
	
	f.BuTimer = CreateFrame("Frame", nil, f)
	f.BuTimer:SetFrameLevel(Lv3)
	f.BuTimer:SetFrameStrata("HIGH")
	f.BuTimer:SetSize(43,20)
	f.BuTimer:SetPoint("TOPRIGHT", f.BuClock, "BOTTOMRIGHT", 0,-3)
	
	f.BuTimer.B = f.BuClock:CreateTexture(nil, "OVERLAY")
	f.BuTimer.B:SetTexture(mediaFolder.."Border1")
	f.BuTimer.B:SetSize(64,32)
	f.BuTimer.B:SetVertexColor(unpack(T.Color.Orange))
	f.BuTimer.B:SetAlpha(0.8)
	f.BuTimer.B:SetPoint("RIGHT", f.BuTimer, "RIGHT", 11,0)
	
	f.BuTimer.T = f.BuClock:CreateTexture(nil, "OVERLAY")
	f.BuTimer.T:SetTexture(mediaFolder.."Timer")
	f.BuTimer.T:SetSize(32,16)
	f.BuTimer.T:SetVertexColor(unpack(T.Color.Orange))
	f.BuTimer.T:SetAlpha(0.8)
	f.BuTimer.T:SetPoint("TOPLEFT", f.BuTimer, "TOPLEFT", 5,-2)
	
	f.BuAuto = CreateFrame("Frame", nil, f)
	f.BuAuto:SetFrameLevel(Lv3)
	f.BuAuto:SetFrameStrata("HIGH")
	f.BuAuto:SetSize(20,43)
	f.BuAuto:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 8,-56-5)
	
	f.BuAuto.B = f.BuClock:CreateTexture(nil, "OVERLAY")
	f.BuAuto.B:SetTexture(mediaFolder.."Border2")
	f.BuAuto.B:SetSize(32,64)
	f.BuAuto.B:SetVertexColor(unpack(T.Color.Orange))
	f.BuAuto.B:SetAlpha(0.8)
	f.BuAuto.B:SetPoint("TOPLEFT", f.BuAuto, "TOPLEFT", -6,11)
	
	f.BuAuto.T = f.BuClock:CreateTexture(nil, "OVERLAY")
	f.BuAuto.T:SetTexture(mediaFolder.."Auto")
	f.BuAuto.T:SetSize(32,64)
	f.BuAuto.T:SetVertexColor(unpack(T.Color.Orange))
	f.BuAuto.T:SetAlpha(0.8)
	f.BuAuto.T:SetPoint("TOPLEFT", f.BuAuto, "TOPLEFT", -6,11)
end


-->
Durability(Button1)
Bag(Button2)
Timer(Button3)
Timer_B(Button3)

