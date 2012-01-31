
local ADDON_NAME, ns = ...

ns.FCS = {}

local mediaFolder
if IsAddOnLoaded("Langley") then
	mediaFolder = "Interface\\AddOns\\Langley\\oUF_Langley\\FCS\\media\\"
else
	mediaFolder = "Interface\\AddOns\\oUF_Langley\\FCS\\media\\"
end

ns.FCS = {
	["Color"] = {
		["RGB"] = {
			["Red"] = {242/255, 48/255, 34/255},
			["Orange"] = {242/255, 127/255, 17/255},
		},
		["Hex"] = {
			["Red"] = "|cfff23022",
			["Orange"] = "|cfff27f11",
		},
	},
	["Warning"] = {
		["Switch"] = ns.Cfg.FCS.Warning.Switch or true,
		["Pos"] = ns.Cfg.FCS.Warning.Position or {"CENTER", UIParent, "CENTER", 0,-150},
	},
	["Func"] = {},
}

ns.FCS.Func.Round = function(num, idp)
	if idp and idp > 0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

ns.FCS.Func.Timer = function(steptime)
	if GetFramerate() >= 60 then
		return 60 * steptime
	else 
		return GetFramerate() * steptime
	end
end

ns.FCS.Func.Fadein = function(t1,t2,t3,t4)
	local f = t1:GetParent()
	f:SetScript("OnUpdate",function(self)
		step = 1/ns.FCS.Func.Timer(0.3)
		if t1:GetAlpha() < 1 then
			t1:SetAlpha(min(t1:GetAlpha() + step, 1))
			if t2 then t2:SetAlpha(min(t2:GetAlpha() + step, 1)) end
			if t3 then t3:SetAlpha(min(t3:GetAlpha() + step, 1)) end
			if t4 then t4:SetAlpha(min(t4:GetAlpha() + step, 1)) end
		else
			ns.FCS.Func.Fadeout(t1,t2,t3,t4)
		end
	end)
end

ns.FCS.Func.Fadeout = function(t1,t2,t3,t4)
	local f = t1:GetParent()
	f:SetScript("OnUpdate",function(self)
		step = 1/ns.FCS.Func.Timer(0.7)
		if t1:GetAlpha() > 0 then
			t1:SetAlpha(max(t1:GetAlpha() - step, 0))
			if t2 then t2:SetAlpha(max(t2:GetAlpha() - step, 0)) end
			if t3 then t3:SetAlpha(max(t3:GetAlpha() - step, 0)) end
			if t4 then t4:SetAlpha(max(t4:GetAlpha() - step, 0)) end
		else
			ns.FCS.Func.Fadein(t1,t2,t3,t4)
		end
	end)
end

ns.FCS.Func.Fadeshow = function(t1,t2,t3,t4)
	local f = t1:GetParent()
	f:SetScript("OnUpdate",function(self)
		step = 1/ns.FCS.Func.Timer(0.3)
		if t1:GetAlpha() < 1 then
			t1:SetAlpha(min(t1:GetAlpha() + step, 1))
			if t2 then t2:SetAlpha(min(t2:GetAlpha() + step, 1)) end
			if t3 then t3:SetAlpha(min(t3:GetAlpha() + step, 1)) end
			if t4 then t4:SetAlpha(min(t4:GetAlpha() + step, 1)) end
		end
	end)
end

ns.FCS.Func.Fadehide = function(t1,t2,t3,t4)
	local f = t1:GetParent()
	f:SetScript("OnUpdate",function(self)
		step = 1/ns.FCS.Func.Timer(0.7)
		if t1:GetAlpha() > 0 then
			t1:SetAlpha(max(t1:GetAlpha() - step, 0))
			if t2 then t2:SetAlpha(max(t2:GetAlpha() - step, 0)) end
			if t3 then t3:SetAlpha(max(t3:GetAlpha() - step, 0)) end
			if t4 then t4:SetAlpha(max(t4:GetAlpha() - step, 0)) end
		end
	end)
end