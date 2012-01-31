
local addon, ns = ...
local oUF = oUFLangley or oUF

local tags = ns.tags 
local _, playerClass = UnitClass('player')

--- ----------------------------------
--> Castbar
--- ----------------------------------

--gen castbar------
ns.Lib.gen_castbar = function(f)  
	local channelingTicks = {
		-- warlock
		[GetSpellInfo(1120)] = 5, -- drain soul
		[GetSpellInfo(689)] = 3, -- drain life
		[GetSpellInfo(5740)] = 4, -- rain of fire
		[GetSpellInfo(79268)] = 3, -- 灵魂收割
		-- druid
		[GetSpellInfo(740)] = 4, -- Tranquility
		[GetSpellInfo(16914)] = 10, -- Hurricane
		-- priest
		[GetSpellInfo(15407)] = 3, -- mind flay
		[GetSpellInfo(48045)] = 5, -- mind sear
		[GetSpellInfo(47540)] = 2, -- penance 
		-- mage
		[GetSpellInfo(5143)] = 5, -- arcane missiles
		[GetSpellInfo(10)] = 5, -- blizzard
		[GetSpellInfo(12051)] = 4, -- evocation
	}
	local ticks = {}
		setBarTicks = function(castBar, ticknum)
		if ticknum and ticknum > 0 then
			local delta = castBar:GetWidth() / ticknum
			for k = 1, ticknum do
				if not ticks[k] then
					ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
					ticks[k]:SetTexture(ns.Tex.Bar.Bar)
					ticks[k]:SetVertexColor(ns.Tex.Color.BgColor[1], ns.Tex.Color.BgColor[2], ns.Tex.Color.BgColor[3],0.6)
					ticks[k]:SetWidth(2)
					ticks[k]:SetHeight(castBar:GetHeight())
				end
				ticks[k]:ClearAllPoints()
				ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 )
				ticks[k]:Show()
			end
		else
			for k, v in pairs(ticks) do
				v:Hide()
			end
		end
	end
	OnCastbarUpdate = function(self, elapsed)
		local currentTime = GetTime()
		if self.casting or self.channeling then
			local parent = self:GetParent()
			local duration = self.casting and self.duration + elapsed or self.duration - elapsed
			if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
				self.casting = nil
				self.channeling = nil
				return
			end
			if parent.unit == 'player' then
				if self.delay ~= 0 then
					self.Time:SetFormattedText('%.1f | |cffff0000%.1f|r', duration, self.casting and self.max + self.delay or self.max - self.delay)
				else
					self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
					self.Lag:SetFormattedText("%d ms", self.SafeZone.timeDiff * 1000)
				end
			else
				self.Time:SetFormattedText('%.1f | %.1f', duration, self.casting and self.max + self.delay or self.max - self.delay)
			end
			self.duration = duration
			self:SetValue(duration)
			self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
		else
			self.Spark:Hide()
			local alpha = self:GetAlpha() - 0.02
			if alpha > 0 then
				self:SetAlpha(alpha)
			else
				self.fadeOut = nil
				self:Hide()
			end
		end
	end
	OnCastSent = function(self, event, unit, spell, rank)
		if self.unit ~= unit or not self.Castbar.SafeZone then return end
		self.Castbar.SafeZone.sendTime = GetTime()
	end
	PostCastStart = function(self, unit, name, rank, text)
		local pcolor = {255/255, 128/255, 128/255}
		local interruptcb = {95/255, 182/255, 255/255}
		self:SetAlpha(1.0)
		self.Spark:Show()
		self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
		local parent = self:GetParent()
		if parent.unit == "player" then
			local sf = self.SafeZone
			sf.timeDiff = GetTime() - sf.sendTime
			sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
			sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
			sf:Show()
			if self.casting then
				setBarTicks(self, 0)
			else
				local spell = UnitChannelInfo(unit)
				self.channelingTicks = channelingTicks[spell] or 0
				setBarTicks(self, self.channelingTicks)
			end
		--elseif (unit == "target" or unit == "focus" or unit == "party") and not self.interrupt then
		elseif not self.interrupt then
			self:SetStatusBarColor(interruptcb[1],interruptcb[2],interruptcb[3],1)
		else
			self:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3],1)
		end
	end
	PostCastStop = function(self, unit, name, rank, castid)
		if not self.fadeOut then 
			self:SetStatusBarColor(unpack(self.CompleteColor))
			self.fadeOut = true
		end
		self:SetValue(self.max)
		self:Show()
	end
	PostChannelStop = function(self, unit, name, rank)
		self.fadeOut = true
		self:SetValue(0)
		self:Show()
	end
	PostCastFailed = function(self, event, unit, name, rank, castid)
		self:SetStatusBarColor(unpack(self.FailColor))
		self:SetValue(self.max)
		if not self.fadeOut then
			self.fadeOut = true
		end
		self:Show()
	end	
	
	-->>CastBar
	local cbColor = {95/255, 182/255, 255/255}
    local s = CreateFrame("StatusBar", "oUF_Castbar"..f.mystyle, f)
    s:SetStatusBarTexture(ns.Tex.Bar.Bar)
	--ns.Lib.fixStatusbar(s)
    s:SetStatusBarColor(95/255, 182/255, 255/255)
    s:SetFrameLevel(2)
    s.CastingColor = cbColor
    s.CompleteColor = {20/255, 208/255, 0/255}
    s.FailColor = {255/255, 12/255, 0/255}
    s.ChannelingColor = cbColor
	
	if f.mystyle == "player" then
		s:SetSize(240, 16)
		
		local h = CreateFrame("Frame", nil, s)
		h:SetFrameLevel(1)
		h:SetPoint("TOPLEFT",-0,0)
		h:SetPoint("BOTTOMRIGHT",0,-0)
		
		local h4 = CreateFrame("Frame", nil, s)
		h4:SetFrameLevel(0)
		h4:SetPoint("TOPLEFT", s, "TOPLEFT", -2, 2)
		h4:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", 2, -2)
		h4:SetBackdrop({
			edgeFile = ns.Tex.Glow, 
			edgeSize = 2,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		h4:SetBackdropBorderColor(ns.Tex.Color.BgColor[1], ns.Tex.Color.BgColor[2], ns.Tex.Color.BgColor[3], 0.6)
		
		local b = s:CreateTexture(nil, "BACKGROUND")
		b:SetTexture(ns.Tex.Line)
		b:SetVertexColor(s:GetStatusBarColor())
		b:SetAlpha(0.2)
		b:SetAllPoints(h)
		-->
		local left = s:CreateTexture(nil, "OVERLAY")
		left:SetTexture(ns.Tex.CastBar.Left)
		left:SetSize(16,32)
		left:SetVertexColor(unpack(ns.Tex.Color.Orange))
		left:SetPoint("RIGHT", s, "LEFT", 0,0)
		left:SetAlpha(1)
		
		local left_bg = s:CreateTexture(nil, "BACKGROUND")
		left_bg:SetTexture(ns.Tex.CastBar.Left)
		left_bg:SetSize(16,32)
		left_bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		left_bg:SetAllPoints(left)
		left_bg:SetAlpha(0.8)
		
		local right = s:CreateTexture(nil, "OVERLAY")
		right:SetTexture(ns.Tex.CastBar.Right)
		right:SetSize(16,32)
		right:SetVertexColor(unpack(ns.Tex.Color.Orange))
		right:SetPoint("LEFT", s, "RIGHT", 0,0)
		right:SetAlpha(1)
		
		local right_bg = s:CreateTexture(nil, "BACKGROUND")
		right_bg:SetTexture(ns.Tex.CastBar.Right)
		right_bg:SetSize(16,32)
		right_bg:SetVertexColor(unpack(ns.Tex.Color.BgColor))
		right_bg:SetAllPoints(right)
		right_bg:SetAlpha(0.8)
	else
		s:SetSize(128, 22)
		
		local h = CreateFrame("Frame", nil, s)
		h:SetFrameLevel(1)
		h:SetPoint("TOPLEFT",-0,0)
		h:SetPoint("BOTTOMRIGHT",0,-0)
		
		local castbar_bg = h:CreateTexture(nil, "BACKGROUND")
		castbar_bg:SetTexture(ns.Tex.Bar.Bar)
		castbar_bg:SetSize(128+s:GetHeight()+12+4+4+4, s:GetHeight()+12+4+4)
		castbar_bg:SetVertexColor(unpack(ns.Tex.Color.Blue))
		castbar_bg:SetPoint("TOPLEFT", s, "TOPLEFT", -(s:GetHeight()+12+4+4), 4)
		castbar_bg:SetAlpha(0.75)
		
		local b = s:CreateTexture(nil, "BACKGROUND")
		b:SetTexture(ns.Tex.Line)
		
		b:SetVertexColor(s:GetStatusBarColor())
		b:SetAlpha(0.2)
		b:SetAllPoints(h)
		
		local h3 = CreateFrame("Frame", nil, s)
		h3:SetFrameLevel(3)
		h3:SetPoint("TOPLEFT",-0,0)
		h3:SetPoint("BOTTOMRIGHT",0,-0)
		h3:SetBackdrop({
			edgeFile = "Interface\\Buttons\\WHITE8x8", 
			edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		h3:SetBackdropBorderColor(1, 1, 1, 1)
		
		local h4 = CreateFrame("Frame", nil, s)
		h4:SetFrameLevel(0)
		h4:SetPoint("TOPLEFT", castbar_bg, "TOPLEFT", -2, 2)
		h4:SetPoint("BOTTOMRIGHT", castbar_bg, "BOTTOMRIGHT", 2, -2)
		h4:SetBackdrop({
			edgeFile = ns.Tex.Glow, 
			edgeSize = 2,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		h4:SetBackdropBorderColor(ns.Tex.Color.BgColor[1], ns.Tex.Color.BgColor[2], ns.Tex.Color.BgColor[3], 0.6)
	end
	
    sp = s:CreateTexture(nil, "OVERLAY")
    sp:SetBlendMode("ADD")
    sp:SetAlpha(0.5)
    sp:SetHeight(s:GetHeight()*2.5)
	
	-->CastBar Txt
    local txt = ns.Lib.gen_fontstring(s, ns.Tex.Font.Name, 9, ns.Cfg.Font.Name.Outline)
    local t = ns.Lib.gen_fontstring(s, ns.Tex.Font.Number, 9, ns.Cfg.Font.Number.Outline)
	local c = ns.Lib.gen_fontstring(s, ns.Tex.Font.Number, 9, ns.Cfg.Font.Number.Outline)
	if f.mystyle == "player" then
		txt:SetPoint("LEFT", 10, 1)
		t:SetPoint("RIGHT", s, "RIGHT", -5, -1)
		txt:SetPoint("RIGHT", t, "LEFT", -5, 2)
		txt:SetJustifyH("LEFT")
	else
		txt:SetPoint("LEFT", 10, 1)
		txt:SetPoint("RIGHT", -10, 1)
		txt:SetJustifyH("CENTER")
		t:SetPoint("TOPRIGHT", s, "BOTTOMRIGHT", -1, -4)
		c:SetPoint("TOPLEFT", s, "BOTTOMLEFT", 1, -4)
	end
	
	-->CastBar Icon--
    local i = s:CreateTexture(nil, "ARTWORK")
	i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	if f.mystyle == "player" then
		i:SetSize(s:GetHeight()+0,s:GetHeight()+0)
		--i:SetPoint("LEFT", s, "RIGHT", 2, 0)
		--i:SetPoint("RIGHT", s, "LEFT", -8, 0)
	else
		i:SetSize(s:GetHeight()+12,s:GetHeight()+12)
		i:SetPoint("TOPRIGHT", s, "TOPLEFT", -4, 0)
	end
    
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(3)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-0,0)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",0,-0)
	-->Set Backdrop
	h2:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8", 
		edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	})
	h2:SetBackdropBorderColor(1, 1, 1, 1)
	
    if f.mystyle == "player" then
      local z = s:CreateTexture(nil,"OVERLAY")
      z:SetTexture(ns.Tex.Bar.Bar)
      z:SetVertexColor(1,0.1,0,.6)
      z:SetPoint("TOPRIGHT")
      z:SetPoint("BOTTOMRIGHT")
	  s:SetFrameLevel(10)
      s.SafeZone = z
      local l = ns.Lib.gen_fontstring(s, ns.Tex.Font.Number, 10, ns.Cfg.Font.Number.Outline)
      l:SetPoint("CENTER", -2, 17)
      l:SetJustifyH("RIGHT")
	  l:Hide()
      s.Lag = l
      f:RegisterEvent("UNIT_SPELLCAST_SENT", OnCastSent)
    end
	
	if f.mystyle == "player" then
		s:SetPoint(unpack(ns.Cfg.CastBar.Position.Player))
    elseif f.mystyle == "target" then
		c:SetText("Target")
		s:SetPoint(unpack(ns.Cfg.CastBar.Position.Target))
	elseif f.mystyle == "pet" then
		c:SetText("Pet")
		s:SetPoint(unpack(ns.Cfg.CastBar.Position.Pet))
	elseif f.mystyle == "focus" then
		c:SetText("Focus")
		s:SetPoint(unpack(ns.Cfg.CastBar.Position.Focus))
	elseif f.mystyle == "boss" then
		c:SetText("Boss")
		s:SetPoint(unpack(ns.Cfg.CastBar.Position.Boss))
    end
	
    s.OnUpdate = OnCastbarUpdate
    s.PostCastStart = PostCastStart
    s.PostChannelStart = PostCastStart
    s.PostCastStop = PostCastStop
    s.PostChannelStop = PostChannelStop
    s.PostCastFailed = PostCastFailed
    s.PostCastInterrupted = PostCastFailed
	
    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
end

ns.Lib.gen_mirrorcb = function(f)
    for _, bar in pairs({
		'MirrorTimer1',
		'MirrorTimer2',
		'MirrorTimer3',
	}) do   
      for i, region in pairs({_G[bar]:GetRegions()}) do
        if (region.GetTexture and region:GetTexture() == ns.Tex.Bar.Bar) then
          region:Hide()
        end
      end
      _G[bar..'Border']:Hide()
      _G[bar]:SetParent(UIParent)
      _G[bar]:SetScale(1)
      _G[bar]:SetHeight(15)
      _G[bar]:SetWidth(280)
      _G[bar]:SetBackdropColor(.1,.1,.1)
      _G[bar..'Background'] = _G[bar]:CreateTexture(bar..'Background', 'BACKGROUND', _G[bar])
      _G[bar..'Background']:SetTexture(ns.Tex.Bar.Bar)
      _G[bar..'Background']:SetAllPoints(bar)
      _G[bar..'Background']:SetVertexColor(.15,.15,.15,.75)
      _G[bar..'Text']:SetFont(ns.Tex.Font.Name, 10, ns.Cfg.Font.Name.Outline)
      _G[bar..'Text']:ClearAllPoints()
      _G[bar..'Text']:SetPoint('CENTER', MirrorTimer1StatusBar, 0, 1)
      _G[bar..'StatusBar']:SetAllPoints(_G[bar])
	  _G[bar..'StatusBar']:SetStatusBarTexture(ns.Tex.Bar.Bar)
      --glowing borders
      local h = CreateFrame("Frame", nil, _G[bar])
      h:SetFrameLevel(0)
      h:SetPoint("TOPLEFT",-0,0)
      h:SetPoint("BOTTOMRIGHT",0,-0)
    end
end
