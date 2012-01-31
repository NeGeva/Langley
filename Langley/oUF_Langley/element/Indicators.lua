
local _, ns = ...
local oUF =  oUFLangley or oUF

local _, class = UnitClass("player")

local update = 0.25

--- ----------------------------------
--> Indicators
--- ----------------------------------

local Enable = function(self)
	if(self.Indicators) then
	
	-->>TopLeft<<--
	self.AuraStatusTL = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusTL:ClearAllPoints()
	self.AuraStatusTL:SetPoint("TOPLEFT", self, "TOPLEFT", 0,0)
	self.AuraStatusTL:SetJustifyH("LEFT")
	self.AuraStatusTL:SetFont(ns.Tex.Font.Square, ns.Cfg.Raid.Indicator.AuraStatus.FontSize, "OUTLINE MONOCHROME")
	self.AuraStatusTL.frequentUpdates = update
	self:Tag(self.AuraStatusTL, oUF.classIndicators[class]["TL"])
	
	-->>TopRight<<--
	self.AuraStatusTR = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusTR:ClearAllPoints()
	self.AuraStatusTR:SetPoint("TOPRIGHT", self, "TOPRIGHT", 1,0)
	self.AuraStatusTR:SetJustifyH("RIGHT")
	self.AuraStatusTR:SetFont(ns.Tex.Font.Square, ns.Cfg.Raid.Indicator.AuraStatus.FontSize, "OUTLINE MONOCHROME")
	self.AuraStatusTR.frequentUpdates = update
	self:Tag(self.AuraStatusTR, oUF.classIndicators[class]["TR"])
	
	-->>TopRight(left)<<--
	self.AuraStatusTR2 = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusTR2:ClearAllPoints()
	self.AuraStatusTR2:SetPoint("TOPRIGHT", self,"TOPRIGHT", -13,0)
	self.AuraStatusTR2:SetJustifyH("RIGHT")
	self.AuraStatusTR2:SetFont(ns.Tex.Font.Square, ns.Cfg.Raid.Indicator.AuraStatus.FontSize, "OUTLINE MONOCHROME")
	self.AuraStatusTR2.frequentUpdates = update 
	self:Tag(self.AuraStatusTR2, oUF.classIndicators[class]["TR2"])
	
	-->>BottomLeft<<--
	self.AuraStatusBL = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusBL:ClearAllPoints()
	self.AuraStatusBL:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0,-1)
	self.AuraStatusBL:SetJustifyH("LEFT")
	self.AuraStatusBL:SetFont(ns.Tex.Font.Square, ns.Cfg.Raid.Indicator.AuraStatus.FontSize, "OUTLINE MONOCHROME")
	self.AuraStatusBL.frequentUpdates = update 
	self:Tag(self.AuraStatusBL, oUF.classIndicators[class]["BL"])
	
	-->>BottomRight<<--
	self.AuraStatusBR = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusBR:ClearAllPoints()
	self.AuraStatusBR:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1,-1)
	self.AuraStatusBR:SetJustifyH("RIGHT")
	self.AuraStatusBR:SetFont(ns.Tex.Font.Square, ns.Cfg.Raid.Indicator.AuraStatus.FontSize, "OUTLINE MONOCHROME")
	--self.AuraStatusBR:SetFont(cfg.symbols, cfg.symbolsize, cfg.NumbFontF)
	self.AuraStatusTR.frequentUpdates = update
	self:Tag(self.AuraStatusBR, oUF.classIndicators[class]["BR"])
	
	-->>BottomRight(left)<<--
	self.AuraStatusBR2 = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusBR2:ClearAllPoints()
	self.AuraStatusBR2:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -7,-1)
	self.AuraStatusBR2:SetJustifyH("RIGHT")
	self.AuraStatusBR2:SetFont(ns.Tex.Font.Square, ns.Cfg.Raid.Indicator.AuraStatus.FontSize, "OUTLINE MONOCHROME")
	self.AuraStatusTR2.frequentUpdates = update
	self:Tag(self.AuraStatusBR2, oUF.classIndicators[class]["BR2"])	
	
	-->>Center<<--
	self.AuraStatusCen = self.Health:CreateFontString(nil, "OVERLAY")
	self.AuraStatusCen:ClearAllPoints()
	self.AuraStatusCen:SetPoint("TOP", self, "TOP", 0,0)
	self.AuraStatusCen:SetJustifyH("CENTER")
	self.AuraStatusCen:SetFont(ns.Tex.Font.Timer, ns.Cfg.Raid.Indicator.AuraStatus.FontSize, ns.Cfg.Font.Number.Outline)
	--self.AuraStatusCen:SetShadowOffset(1.25, -1.25)
	self.AuraStatusCen.frequentUpdates = update 
	self:Tag(self.AuraStatusCen, oUF.classIndicators[class]["Cen"])
		return true
	end
end

oUF:AddElement('Indicators', nil, Enable, nil)