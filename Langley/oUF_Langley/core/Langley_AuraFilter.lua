
Whitelist = {

--- ------------------------------------------------
--> auras
--- ------------------------------------------------
	auras = {
		--The Ruby Sanctum 红玉圣殿
			[GetSpellInfo(74562) or "炽热燃灼"] = true,		 				-- Fiery Combustion
			[GetSpellInfo(75883) or "燃灼"] = true, 		 				-- Combustion
			[GetSpellInfo(74792) or "灵魂耗损"] = true, 		 			-- Soul Consumption
			[GetSpellInfo(75876) or "耗损"] = true, 		 				-- Consumption
				
		--Icecrown Citadel 冰冠堡垒
			--The Lower Spire 城门区
				[GetSpellInfo(38028) or "水之墓穴"] = true, 				-- Web Wrap
				[GetSpellInfo(69483) or "黑暗清算"] = true, 				-- Dark Reckoning
				[GetSpellInfo(71124) or "厄运诅咒"] = true, 				-- Curse of Doom
			
			--The Plagueworks 瘟疫区
				[GetSpellInfo(71089) or "冒泡的脓汁"] = true, 				-- Bubbling Pus
				[GetSpellInfo(71127) or "致死重伤"] = true,					-- Mortal Wound
				[GetSpellInfo(71163) or "吞噬人型生物"] = true, 			-- Devour Humanoid
				[GetSpellInfo(71103) or "蜕变喷雾"] = true, 				-- Combobulating Spray
				[GetSpellInfo(71157) or "感染之伤"] = true,					-- Infested Wound
			
			--The Crimson Hall 血色厅堂
				[GetSpellInfo(70645) or "影链术"] = true, 					-- Chains of Shadow
				[GetSpellInfo(70671) or "寄生腐气"] = true, 				-- Leeching Rot
				[GetSpellInfo(70432) or "鲜血枯竭"] = true,					-- Blood Sap
				[GetSpellInfo(70435) or "撕裂血肉"] = true,					-- Rend Flesh
			
			--Frostwing Hall 冰龙区
				[GetSpellInfo(71257) or "蛮野打击"] = true, 				-- Barbaric Strike
				[GetSpellInfo(71252) or "箭雨"] = true, 					-- Volley
				[GetSpellInfo(71327) or "蛛网"] = true, 					-- Web
				[GetSpellInfo(36922) or "低沉咆哮"] = true,					-- Bellowing Roar
			
			--Lord Marrowgar 玛洛加尔领主
				[GetSpellInfo(70823) or "冷焰"] = true, 					-- Coldflame
				[GetSpellInfo(69065) or "被刺穿"] = true, 					-- Impaled
				[GetSpellInfo(70835) or "骸骨风暴"] = true, 				-- Bone Storm
			
			--Lady Deathwhisper 亡语者女士
				[GetSpellInfo(72109) or "死亡凋零"] = true,					-- Death and Decay
				[GetSpellInfo(71289) or "支配心智"] = true, 				-- Dominate Mind
				[GetSpellInfo(71204) or "无胁之触"] = true, 				-- Touch of Insignificance
				[GetSpellInfo(67934) or "冰霜疫病"] = true,					-- Frost Fever
				[GetSpellInfo(71237) or "鲁钝诅咒"] = true, 				-- Curse of Torpor
				[GetSpellInfo(72491) or "亡域打击"] = true, 				-- Necrotic Strike
			
			--Gunship Battle 炮艇战斗
				[GetSpellInfo(69651) or "致伤打击"] = true,	 				-- Wounding Strike
			
			--Deathbringer Saurfang 死亡使者萨鲁法尔
				[GetSpellInfo(72293) or "堕落勇士印记"] = true,				-- Mark of the Fallen Champion
				[GetSpellInfo(72442) or "沸血"] = true,						-- Boiling Blood
				[GetSpellInfo(72449) or "血魄符文"] = true,					-- Rune of Blood
				[GetSpellInfo(72769) or "血魄气息"] = true,					-- Scent of Blood (heroic)
			
			--Rotface 烂肠
				[GetSpellInfo(71224) or "突变感染"] = true,					-- Mutated Infection
				[GetSpellInfo(71215) or "软泥流"] = true, 					-- Ooze Flood
				[GetSpellInfo(69774) or "黏稠软泥"] = true, 				-- Sticky Ooze
			
			--Festergut 腐面
				[GetSpellInfo(69279) or "气体孢子"] = true,					-- Gas Spore
				[GetSpellInfo(71218) or "污秽毒气"] = true,					-- Vile Gas
				[GetSpellInfo(72219) or "胃囊膨胀"] = true,					-- Gastric Bloat
			
			--Professor 普崔希德教授
				[GetSpellInfo(70341) or "泥浆潭"] = true,					-- Slime Puddle
				[GetSpellInfo(72549) or "延展黏液"] = true,					-- Malleable Goo
				[GetSpellInfo(71278) or "窒息毒气"] = true,					-- Choking Gas Bomb
				[GetSpellInfo(70215) or "毒气膨胀"] = true,					-- Gaseous Bloat
				[GetSpellInfo(70447) or "暴躁软泥怪黏著"] = true,			-- Volatile Ooze Adhesive
				[GetSpellInfo(72454) or "突变瘟疫"] = true,					-- Mutated Plague
				[GetSpellInfo(70405) or "突变转化"] = true,					-- Mutated Transformation
				[GetSpellInfo(72856) or "肆虐瘟疫"] = true,					-- Unbound Plague
				[GetSpellInfo(70953) or "瘟疫病疾"] = true,					-- Plague Sickness
			
			--Blood Princes 鲜血议会
				[GetSpellInfo(72796) or "激光"] = true,						-- Glittering Sparks
				[GetSpellInfo(71822) or "暗影共鸣"] = true,					-- Shadow Resonance
			
			--Blood-Queen Lana'thel 鲜血女王兰娜瑟尔
				[GetSpellInfo(70838) or "血魄之镜"] = true,					-- Blood Mirror
				[GetSpellInfo(72265) or "极乐斩击"] = true,					-- Delirious Slash
				[GetSpellInfo(71473) or "血腥女王精华"] = true,				-- Essence of the Blood Queen
				[GetSpellInfo(71474) or "狂乱嗜血"] = true,					-- Frenzied Bloodthirst
				[GetSpellInfo(73070) or "煽动恐惧"] = true,					-- Incite Terror
				[GetSpellInfo(71340) or "暗殒契印"] = true,					-- Pact of the Darkfallen
				[GetSpellInfo(71265) or "群聚暗影"] = true,					-- Swarming Shadows
				[GetSpellInfo(70923) or "失控狂乱"] = true,					-- Uncontrollable Frenzy
			
			--Valithria Dreamwalker 踏梦者瓦莉瑟瑞娅
				[GetSpellInfo(70873) or "翡翠精力"] = true,					-- Emerald Vigor
				[GetSpellInfo(71746) or "冰霜圆柱"] = true,					-- Column of Frost
				[GetSpellInfo(71741) or "溃法力场"] = true,					-- Mana Void
				[GetSpellInfo(71738) or "腐败"] = true, 					-- Corrosion
				[GetSpellInfo(71733) or "酸液爆发"] = true, 				-- Acid Burst
				[GetSpellInfo(71283) or "脏汁喷洒"] = true, 				-- Gut Spray
				[GetSpellInfo(71941) or "扭曲梦魇"] = true,					-- Twisted Nightmares
			
			--Sindragosa 辛达苟萨
				[GetSpellInfo(69762) or "无束魔法"] = true,					-- Unchained Magic
				[GetSpellInfo(69766) or "不稳定"] = true, 		 			-- Instability
				[GetSpellInfo(70126) or "冰霜信标"] = true, 				-- Frost Beacon
				[GetSpellInfo(70157) or "寒冰之墓"] = true, 				-- Ice Tomb

			--The Lich King 巫妖王
				[GetSpellInfo(70337) or "亡域瘟疫"] = true,					-- Necrotic plague
				[GetSpellInfo(72149) or "震慑波"] = true, 					-- Shockwave
				[GetSpellInfo(70541) or "寄生"] = true, 					-- Infest
				[GetSpellInfo(69242) or "灵魂厉啸"] = true, 				-- Soul Shriek
				[GetSpellInfo(69409) or "灵魂收割"] = true, 				-- Soul Reaper
				[GetSpellInfo(72762) or "污染"] = true, 					-- Defile
				[GetSpellInfo(68980) or "灵魂割取"] = true, 				-- Harvest Soul	

			
		--Trial of the Crusader
			[GetSpellInfo(66331) or "穿刺"] = true,							-- Impale	
			[GetSpellInfo(66406) or "狗头人上身!"] = true,					-- Snobolled!
			[GetSpellInfo(66819) or "强酸喷射"] = true,						-- Acidic Spew
			[GetSpellInfo(66821) or "熔岩喷射"] = true,						-- Molten Spew
			[GetSpellInfo(66823) or "麻痹毒素"] = true,						-- Paralytic Toxin
			[GetSpellInfo(66532) or "魔能火球"] = true,						-- Fel Fireball
			[GetSpellInfo(66237) or "血肉成灰"] = true,						-- Incinerate Flesh
			[GetSpellInfo(66242) or "地狱烈焰"] = true,						-- Burning Inferno		
			[GetSpellInfo(66197) or "军团烈焰"] = true,						-- Legion Flame
			[GetSpellInfo(66283) or "旋压痛击"] = true,						-- Spinning Pain Spike
			[GetSpellInfo(66209) or "加拉克苏斯之触"] = true,				-- Touch of Jaraxxus
			[GetSpellInfo(66211) or "虚空诅咒"] = true,						-- Curse of the Nether	
			[GetSpellInfo(67906) or "女王之吻"] = true,						-- Mistress' Kiss	
			[GetSpellInfo(65812) or "痛苦无常"] = true,						-- Unstable Affliction
			[GetSpellInfo(67283) or "黑暗之触"] = true,						-- Touch of Darkness
			[GetSpellInfo(67298) or "光明之触"] = true,						-- Touch of Light	
			[GetSpellInfo(67309) or "双生之刺"] = true,						-- Twin Spike
			[GetSpellInfo(67176) or "黑暗精粹"] = true,						-- Dark Essence
			[GetSpellInfo(67222) or "光明精粹"] = true,						-- Light Essence
			[GetSpellInfo(67574) or "被阿努巴拉克追逐"] = true,				-- Pursued by Anub'arak
			[GetSpellInfo(66013) or "刺骨之寒"] = true,						-- Penetrating Cold
			[GetSpellInfo(67847) or "破甲虚弱"] = true,						-- Expose Weakness
			[GetSpellInfo(66012) or "寒冰打击"] = true,						-- Freezing Slash
			[GetSpellInfo(67863) or "酸腺撕咬"] = true,						-- Acid-Drenched Mandibles
	
		-- Vault of Archavon
			[GetSpellInfo(67332) or "余烬"] = true,							-- Flaming Cinder
			["Frostbite"] = true,											-- Frostbite
	
		-- Ulduar
			[GetSpellInfo(64412) or "相位冲压"] = true,						-- Phase Punch
			[GetSpellInfo(63612) or "闪电烙印"] = true,						-- Lightning Brand
			[GetSpellInfo(63615) or "破坏护甲"] = true,						-- Ravage Armor	
			[GetSpellInfo(62283) or "钢铁根须"] = true,						-- Iron Roots
			[GetSpellInfo(63169) or "石化联结"] = true,						-- Petrify Joints
			[GetSpellInfo(64771) or "熔化护甲"] = true,						-- Fuse Armor	
			[GetSpellInfo(62548) or "灼烧"] = true,							-- Scorch
			[GetSpellInfo(62680) or "烈焰喷射"] = true,						-- Flame Jets
			[GetSpellInfo(62717) or "熔渣炉"] = true,						-- Slag Pot	
			[GetSpellInfo(63024) or "重力炸弹"] = true,						-- Gravity Bomb
			[GetSpellInfo(63018) or "灼热之光"] = true,						-- Searing Light
			[GetSpellInfo(61888) or "压倒能量"] = true,						-- Overwhelming Power	
			[GetSpellInfo(62269) or "死亡符文"] = true,						-- Rune of Death
			[GetSpellInfo(61903) or "熔化冲压"] = true,						-- Fusion Punch
			[GetSpellInfo(61912) or "静电瓦解"] = true,						-- Static Disruption	
			[GetSpellInfo(64290) or "岩石之握"] = true,						-- Stone Grip
			[GetSpellInfo(63355) or "压碎护甲"] = true,						-- Crunch Armor
			[GetSpellInfo(62055) or "脆弱皮肤"] = true,						-- Brittle Skin
			[GetSpellInfo(62469) or "冰冻"] = true,							-- Freeze
			[GetSpellInfo(61969) or "快速冻结"] = true,						-- Flash Freeze
			[GetSpellInfo(62188) or "刺骨之寒"] = true,						-- Biting Cold
			[GetSpellInfo(62042) or "风暴之锤"] = true,						-- Stormhammer
			[GetSpellInfo(62130) or "重压打击"] = true,						-- Unbalancing Strike
			[GetSpellInfo(62526) or "符文爆裂"] = true,						-- Rune Detonation
			[GetSpellInfo(62470) or "震耳雷霆"] = true,						-- Deafening Thunder
			[GetSpellInfo(62532) or "监护者之握"] = true,					-- Conservator's Grip
			[GetSpellInfo(62589) or "自然之怒"] = true,						-- Nature's Fury
			[GetSpellInfo(62861) or "钢铁根须"] = true,						-- Iron Roots
			[GetSpellInfo(63666) or "凝固汽油炸弹"] = true,					-- Napalm Shell
			[GetSpellInfo(62997) or "等离子冲击"] = true,					-- Plasma Blast
			[GetSpellInfo(64668) or "磁场"] = true,							-- Magnetic Field
			[GetSpellInfo(63276) or "无面者的印记"] = true,					-- Mark of the Faceless
			[GetSpellInfo(63322) or "萨隆邪铁蒸汽"] = true,					-- Saronite Vapors
			[GetSpellInfo(63147) or "萨拉的怒火"] = true,					-- Sara's Anger
			[GetSpellInfo(63134) or "萨拉的祝福"] = true,					-- Sara's Blessing
			[GetSpellInfo(63138) or "萨拉的热情"] = true,					-- Sara's Fervor
			[GetSpellInfo(63830) or "心灵疾病"] = true,						-- Malady of the Mind
			[GetSpellInfo(63802) or "心智链接"] = true,						-- Brain Link
			[GetSpellInfo(63042) or "支配心智"] = true,						-- Dominate Mind
			[GetSpellInfo(64152) or "脱水毒药"] = true,						-- Draining Poison
			[GetSpellInfo(64153) or "黑色热疫"] = true,						-- Black Plague
			[GetSpellInfo(64125) or "挤压"] = true,							-- Squeeze	
			[GetSpellInfo(64156) or "冷漠"] = true,							-- Apathy
			[GetSpellInfo(64157) or "厄运诅咒"] = true,						-- Curse of Doom
	},	


--- -----------------------------------------------------
--> pvps
--- -----------------------------------------------------
	pvps = {
		--Priest
			[GetSpellInfo(6346) or "防护恐惧结界"] = true,					-- Fear Ward
			[GetSpellInfo(605) or "精神控制"] = true,						-- Mind Control
			[GetSpellInfo(34914) or "吸血鬼之触"] = true,					-- Vampiric Touch	
			[GetSpellInfo(2944) or "噬灵疫病"] = true,						-- Devouring Plague
			[GetSpellInfo(589) or "暗言术：痛"] = true,						-- Shadow Word: Pain
			[GetSpellInfo(8122) or "心灵尖啸"] = true,						-- Psychic Scream
			[GetSpellInfo(64044) or "心灵惊骇"] = true,						-- Psychic Horror	
			[GetSpellInfo(6788) or "虚弱灵魂"] = true,						-- Weakened Soul
			[GetSpellInfo(69910) or "痛苦压制"] = true,						-- Pain Suppression
			[GetSpellInfo(15487) or "沉默"] = true,							-- Silence
			[GetSpellInfo(15473) or "暗影形态"] = true,						-- Shadowform	
			[GetSpellInfo(47585) or "消散"] = true,							-- Dispersion	
			[GetSpellInfo(17) or "真言术：盾"] = true,						-- Power Word: Shield
			[GetSpellInfo(139) or "恢复"] = true,							-- Renew
			[GetSpellInfo(33076) or "愈合祷言"] = true,						-- Prayer of Mending
	
		--Paladin
			[GetSpellInfo(25771) or "自律"] = true,							-- Forbearance
			[GetSpellInfo(642) or "圣盾术"] = true,							-- Divine Shield
			[GetSpellInfo(10278) or "保护之手"] = true,						-- Hand of Protection
			[GetSpellInfo(1044) or "自由之手"] = true,						-- Hand of Freedom
			[GetSpellInfo(6940) or "牺牲之手"] = true,						-- Hand of Sacrifice	
			[GetSpellInfo(10308) or "制裁之锤"] = true, 					-- Hammer of Justice
			[GetSpellInfo(20066) or "忏悔"] = true, 						-- Repentance
			[GetSpellInfo(53563) or "圣光道标"] = true, 					-- Beacon of Light
	
		--Rogue
			[GetSpellInfo(31224) or "暗影斗篷"] = true,						-- Cloak of Shadows
			[GetSpellInfo(5277) or "闪避"] = true,							-- Evasion
			[GetSpellInfo(2094) or "致盲"] = true,							-- Blind
			[GetSpellInfo(6770) or "闷棍"] = true, 							-- Sap
			[GetSpellInfo(408) or "肾击"] = true, 							-- Kidney Shot
			[GetSpellInfo(1776) or "凿击"] = true, 							-- Gouge	
		
		--Warrior
			[GetSpellInfo(12294) or "致死打击"] = true,						-- Mortal Strike
			[GetSpellInfo(1715) or "断筋"] = true,							-- Hamstring
			[GetSpellInfo(871) or "盾墙"] = true,							-- Shield Wall	
	
		--Druid
			[GetSpellInfo(33786) or "旋风"] = true,							-- Cyclone
			[GetSpellInfo(339) or "纠缠根须"] = true,						-- Entangling Roots
			[GetSpellInfo(29166) or "激活"] = true,							-- Innervate
			[GetSpellInfo(2637) or "休眠"] = true,							-- Hibernate
			[GetSpellInfo(774) or "回春术"] = true,							-- Rejuvenation
			[GetSpellInfo(8936) or "愈合"] = true,							-- Regrowth
			[GetSpellInfo(33763) or "生命绽放"] = true,						-- Lifebloom
	
		--Warlock
			[GetSpellInfo(5782) or "恐惧"] = true,							-- Fear
			[GetSpellInfo(5484) or "恐惧嚎叫"] = true,						-- Howl of Terror
			[GetSpellInfo(6358) or "诱惑"] = true, 							-- Seduction
			[GetSpellInfo(30108) or "痛苦无常"] = true, 					-- Unstable Affliction		
			[GetSpellInfo(1714) or "语言诅咒"] = true, 						-- Curse of Tongues
			[GetSpellInfo(18223) or "疲劳诅咒"] = true, 					-- Curse of Exhaustion
			[GetSpellInfo(6789) or "死亡缠绕"] = true,						-- Death Coil
			[GetSpellInfo(30283) or "暗影之怒"] = true,						-- Shadowfury
	
		--Shaman
			[GetSpellInfo(51514) or "妖术"] = true,							-- Hex
			[GetSpellInfo(974) or "大地之盾"] = true,						-- Earth Shield
			[GetSpellInfo(61295) or "激流"] = true,							-- Riptide
	
		--Mage
			[GetSpellInfo(18469) or "法术反制 - 沉默"] = true,				-- Silenced - Improved Counterspell - Rank1
			[GetSpellInfo(55021) or "沉默 - 强化法术反制"] = true,			-- Silenced - Improved Counterspell - Rank2
			[GetSpellInfo(2139) or "法术反制"] = true,						-- Counterspell
			[GetSpellInfo(118) or "变形术"] = true,							-- Polymorph
			[GetSpellInfo(61305) or "变形术"] = true,						-- Polymorph Black Cat
			[GetSpellInfo(28272) or "变形术"] = true,						-- Polymorph Pig
			[GetSpellInfo(61721) or "变形术"] = true,						-- Polymorph Rabbit
			[GetSpellInfo(61780) or "变形术"] = true,						-- Polymorph Turkey
			[GetSpellInfo(28271) or "变形术"] = true,						-- Polymorph Turtle
			[GetSpellInfo(44572) or "深度冻结"] = true,						-- Deep Freeze
			[GetSpellInfo(45438) or "寒冰屏障"] = true, 					-- Ice Block	
			[GetSpellInfo(122) or "冰霜新星"] = true,						-- Frost Nova
	
		--Hunter
			[GetSpellInfo(49050) or "瞄准射击"] = true,						-- Aimed Shot
			[GetSpellInfo(19503) or "驱散射击"] = true,						-- Scatter Shot
			[GetSpellInfo(55041) or "冰冻陷阱效果"] = true,					-- Freezing Trap Effect
			[GetSpellInfo(2974) or "摔绊"] = true,							-- Wing Clip
			[GetSpellInfo(19263) or "威慑"] = true,							-- Deterrence
			[GetSpellInfo(34692) or "野兽之心"] = true, 					-- The Beast Within
			[GetSpellInfo(34490) or "沉默射击"] = true, 					-- Silencing Shot
			[GetSpellInfo(19386) or "翼龙钉刺"] = true, 					-- Wyvern Sting
			[GetSpellInfo(19577) or "胁迫"] = true, 						-- Intimidation
	
		--Death Knight
			[GetSpellInfo(45524) or "寒冰锁链"] = true,						-- Chains of Ice
			[GetSpellInfo(48707) or "反魔法护罩"] = true,					-- Anti-Magic Shell
			[GetSpellInfo(47476) or "绞袭"] = true,							-- Strangulate	
	},

--- -----------------------------------------------------
--> bars
--- -----------------------------------------------------
	bars = {
	
		DEATHKNIGHT = {

			-- Buffs
			[GetSpellInfo(48707) or "反魔法护罩"] = true,					-- Anti-Magic Shell
			[GetSpellInfo(51052) or "反魔法领域"] = true,					-- Anti-Magic Zone
			[GetSpellInfo(49222) or "白骨之盾"] = true,						-- Bone Shield
			[GetSpellInfo(59052) or "冰冻之雾"] = true,						-- Freezing Fog_你的下一次凛风冲击不消耗符文。
			[GetSpellInfo(48792) or "冰封之韧"] = true,						-- Icebound Fortitude
			[GetSpellInfo(51124) or "杀戮机器"] = true,						-- Killing Machine_你的下一次冰冷触摸、凛风冲击或冰霜打击必定爆击。

			[GetSpellInfo(49039) or "巫妖之躯"] = true,						-- Lichborne
			--[GetSpellInfo(51271) or "Pillar of Frost"] = true,			-- Pillar of Frost
			[GetSpellInfo(51271) or "铜墙铁壁"] = true,						-- Unbreakable Armor
			[GetSpellInfo(55233) or "吸血鬼之血"] = true,					-- Vampiric Blood
		
			-- Debuffs
			[GetSpellInfo(55078) or "血之疫病"] = true,						-- Blood Plague
			[GetSpellInfo(45524) or "寒冰锁链"] = true,						-- Chains of Ice
			[GetSpellInfo(55095) or "冰霜疫病"] = true,						-- Frost Fever
			[GetSpellInfo(49203) or "饥饿之寒"] = true,						-- Hungering Cold
			[GetSpellInfo(47476) or "绞袭"] = true,							-- Strangulate
		},
	
		DRUID = {
	
			-- Buffs
			[GetSpellInfo(22812) or "树皮术"] = true,						-- Barkskin
			[GetSpellInfo(50334) or "狂暴"] = true,							-- Berserk
			[GetSpellInfo(1850) or "急奔"] = true,							-- Dash
			[GetSpellInfo(5229) or "激怒"] = true, 							-- Enrage
			[GetSpellInfo(22842) or "狂暴回复"] = true,						-- Frenzied Regeneration
			[GetSpellInfo(29166) or "激活"] = true,							-- Innervate		
			[GetSpellInfo(33763) or "生命绽放"] = true,						-- Lifebloom
			[GetSpellInfo(16689) or "自然之握"] = true,						-- Nature's Grasp
			[GetSpellInfo(8936) or "愈合"] = true,							-- Regrowth
			[GetSpellInfo(774) or "回春术"] = true,						-- Rejuvenation
			[GetSpellInfo(52610) or "野蛮咆哮"] = true,						-- Savage Roar_物理伤害提高30%。
			--[GetSpellInfo(93400) or "流星"] = true,						-- Shooting Stars_CTM
			[GetSpellInfo(61336) or "生存本能"] = true,						-- Survival Instincts_30%的生命值
			[GetSpellInfo(467) or "荆棘术"] = false,						-- Thorns
			[GetSpellInfo(16864) or "清晰预兆"] = true,						-- 清晰预兆
			
			-- Debuffs
			[GetSpellInfo(5211) or "猛击"] = true,					    	-- Bash
			[GetSpellInfo(33786) or "旋风"] = true,							-- Cyclone
			[GetSpellInfo(99) or "挫志咆哮"] = true,	 			   		-- Demoralizing Roar
			[GetSpellInfo(339) or "纠缠根须"] = true,	    				-- Entangling Roots
			[GetSpellInfo(5570) or "虫群"] = true,	    					-- Insect Swarm
			[GetSpellInfo(16979) or "野性冲锋 - 熊"] = true,				-- Feral Charge - Bear
			[GetSpellInfo(2637) or "休眠"] = true,					   	 	-- Hibernate
			[GetSpellInfo(33745) or "割伤"] = true,				    		-- Lacerate_熊
			[GetSpellInfo(49802) or "割碎"] = true,				    		-- Maim_终结技昏迷
			[GetSpellInfo(8921) or "月火术"] = true,			    		-- Moonfire
			[GetSpellInfo(1822) or "斜掠"] = true,				    		-- Rake
			[GetSpellInfo(1079) or "割裂"] = true,							-- Rip
			--[GetSpellInfo(93402) or "日炎術"] = true,						-- Sunfire_CTM
		},
	
		HUNTER = {
	
			-- Buffs
			--[GetSpellInfo(82692) or "專注之火"] = true,					-- Focus Fire_CTM
			[GetSpellInfo(56453) or "荷枪实弹"] = true,						-- Lock and Load_下一次奥术射击或爆炸射击不触发冷却
			[GetSpellInfo(34477) or "误导"] = true,							-- Misdirection
			--[GetSpellInfo(82925) or "準備、就緒、瞄準... "] = true,		-- Ready, Set, Aim..._CTM
			[GetSpellInfo(3045) or "急速射击"] = true,						-- Rapid Fire
			[GetSpellInfo(35098) or "疾速杀戮"] = true,						-- Rapid Killing
			[GetSpellInfo(34692) or "野兽之心"] = true,						-- The Beast Within
			--[GetSpellInfo(77769) or "陷阱發射器"] = true,					-- Trap Launcher_CTM

			-- Debuffs
			[GetSpellInfo(3674) or "黑箭"] = true,							-- Black Arrow
			[GetSpellInfo(35101) or "冲击弹幕"] = true,						-- Concussive Barrage
			[GetSpellInfo(5116) or "震荡射击"] = true,						-- Concussive Shot
			[GetSpellInfo(19185) or "诱捕"] = true,							-- Entrapment
			[GetSpellInfo(53301) or "爆炸射击"] = true,						-- Explosive Shot 
			[GetSpellInfo(3355) or "冰冻陷阱效果"] = true,  				-- Freezing Trap
			[GetSpellInfo(51740) or "献祭陷阱效果"] = true,					-- Immolation Trap 
			[GetSpellInfo(1513) or "恐吓野兽"] = true,						-- Scare Beast 
			[GetSpellInfo(1978) or "毒蛇钉刺"] = true,			  		  	-- Serpent Sting
			[GetSpellInfo(34490) or "沉默射击"] = true,						-- Silencing Shot
			[GetSpellInfo(2974) or "摔绊"] = true,				 		   	-- Wing Clip
			[GetSpellInfo(19386) or "翼龙钉刺"] = true,		 		   		-- Wyvern Sting		
		},
	
		MAGE = {

			-- Buffs
			[GetSpellInfo(12042) or "奥术强化"] = true,						-- Arcane Power
			[GetSpellInfo(11426) or "寒冰护体"] = true,						-- Ice Barrier
			[GetSpellInfo(45438) or "寒冰屏障"] = true,						-- Ice Block
			[GetSpellInfo(66) or "隐形术"] = true,							-- Invisibility
			[GetSpellInfo(543) or "防护火焰结界"] = true,			   		-- Mage Ward
			[GetSpellInfo(1463) or "法力护盾"] = true,				    	-- Mana Shield
			[GetSpellInfo(130) or "缓落术"] = true,					    	-- Slow Fall

			-- Debuffs
			[GetSpellInfo(44572) or "深度冻结"] = true,	    				-- Deep Freeze
			[GetSpellInfo(122) or "冰霜新星"] = true,			    		-- Frost Nova
			[GetSpellInfo(11255) or "强化法术反制"] = true,					-- Improved Counterspell
			[GetSpellInfo(44457) or "活动炸弹"] = true,						-- Living Bomb
			[GetSpellInfo(118) or "变形术"] = true,					   	 	-- Polymorph
			--[GetSpellInfo(82676) or "Ring of Frost"] = true,				-- Ring of Frost
			[GetSpellInfo(31589) or "减速"] = true,					   		-- Slow

		},
	
		PALADIN = {

			-- Buffs
			[GetSpellInfo(31850) or "炽热防御者"] = true,					-- Ardent Defender
			[GetSpellInfo(31884) or "复仇之怒"] = true,						-- Avenging Wrath
			[GetSpellInfo(53651) or "圣光道标"] = true,						-- Beacon of Light		
			[GetSpellInfo(31842) or "神启"] = true,							-- Divine Favor
			[GetSpellInfo(54428) or "神圣恳求"] = true,						-- Divine Plea
			[GetSpellInfo(642) or "圣盾术"] = true,							-- Divine Shield
			--[GetSpellInfo(90174) or "Hand of Light"] = true,				-- Hand of Light
			--[GetSpellInfo(84963) or "Inquisition"] = true,				-- Inquisition
			--[GetSpellInfo(85696) or "Zealotry"] = true,					-- Zealotry
		
			-- Debuffs
			[GetSpellInfo(20066) or "忏悔"] = true,							-- Repentance
		
		},
	
		PRIEST = {

			-- Buffs
			--[GetSpellInfo(81208) or "Chakra: Heal"] = true,				-- Chakra: Heal
			--[GetSpellInfo(81206) or "Chakra: Prayer of Healing"] = true,	-- Chakra: Prayer of Healing
			--[GetSpellInfo(81207) or "Chakra: Renew"] = true,				-- Chakra: Renew
			--[GetSpellInfo(81209) or "Chakra: Smite"] = true,				-- Chakra: Smite
			--[GetSpellInfo(87118) or "Dark Evangelism"] = true,			-- Dark Evangelism
			[GetSpellInfo(47585) or "消散"] = true,							-- Dispersion
			--[GetSpellInfo(81662) or "Evangelism"] = true,					-- Evangelism
			[GetSpellInfo(47788) or "守护之魂"] = true,						-- Guardian Spirit
			[GetSpellInfo(33206) or "痛苦压制"] = true,						-- Pain Suppression
			[GetSpellInfo(10060) or "能量灌注"] = true,						-- Power Infusion
			[GetSpellInfo(48066) or "真言术：盾"] = true,					-- Power Word: Shield
			[GetSpellInfo(33076) or "愈合祷言"] = true,						-- Prayer of Mending
			[GetSpellInfo(139) or "恢复"] = true,					    	-- Renew
			[GetSpellInfo(63735) or "好运"] = true,							-- Serendipity
			--[GetSpellInfo(77487) or "Shadow Orb"] = true,					-- Shadow Orbs

			-- Debuffs
			[GetSpellInfo(2944) or "噬灵疫病"] = true,						-- Devouring Plague
			[GetSpellInfo(14914) or "神圣之火"] = true,						-- Holy Fire	
			--[GetSpellInfo(87178) or "Mind Spike"] = true,					-- Mind Spike
			[GetSpellInfo(64044) or "心灵惊骇"] = true,						-- Psychic Horror	
			[GetSpellInfo(589) or "暗言术：痛"] = true,						-- Shadow Word: Pain	
			[GetSpellInfo(9484) or "束缚亡灵"] = true,						-- Shackle Undead	
			[GetSpellInfo(15487) or "沉默"] = true,							-- Silence	
			[GetSpellInfo(34914) or "吸血鬼之触"] = true,					-- Vampiric Touch	

		},
	
		ROGUE = {

			-- Buffs
			[GetSpellInfo(13750) or "冲动"] = true,		    				-- Adrenaline Rush
			--[GetSpellInfo(84747) or "Deep Insight"] = true,		    	-- Bandit's Guile
			[GetSpellInfo(13877) or "剑刃乱舞"] = true,				    	-- Blade Flurry
			[GetSpellInfo(31230) or "装死"] = true,			 			   	-- Cheat Death
			--[GetSpellInfo(84617) or "Revealing Strike"] = true,		    -- Revealing Strike
			[GetSpellInfo(51713) or "暗影之舞"] = true,				    	-- Shadow Dance
			[GetSpellInfo(5171) or "切割"] = true,							-- Slice and Dice

			-- Debuffs
			[GetSpellInfo(2094) or "致盲"] = true,					    	-- Blind
			[GetSpellInfo(1833) or "偷袭"] = true,							-- Cheap Shot
			[GetSpellInfo(26679) or "致命投掷"] = true,			 	  	 	-- Deadly Throw
			[GetSpellInfo(51722) or "拆卸"] = true, 						-- Dismantle
			[GetSpellInfo(8647) or "破甲"] = true,					    	-- Expose Armor
			[GetSpellInfo(703) or "锁喉"] = true,							-- Garrote
			[GetSpellInfo(1776) or "凿击"] = true,					    	-- Gouge
			[GetSpellInfo(408) or "肾击"] = true,							-- Kidney Shot
			[GetSpellInfo(1943) or "割裂"] = true,							-- Rupture
			[GetSpellInfo(6770) or "闷棍"] = true,							-- Sap
			--[GetSpellInfo(79140) or "Vendetta"] = true,						-- Vendetta

		},
	
		SHAMAN = {

			-- Buffs
			[GetSpellInfo(974) or "大地之盾"] = true,				    	-- Earth Shield
			--[GetSpellInfo(77796) or "Focused Insight"] = true,		    -- Focused Insight
			[GetSpellInfo(324) or "闪电之盾"] = true,		   			 	-- Lightning Shield
			[GetSpellInfo(51530) or "漩涡武器"] = true,		   			 	-- Maelstrom Weapon
			[GetSpellInfo(61295) or "激流"] = true,							-- Riptide
			[GetSpellInfo(30823) or "萨满之怒 "] = true,			    	-- Shamanistic Rage
			--[GetSpellInfo(79206) or "Spiritwalker's Grace"] = true,	    -- Spiritwalker's Grace
			--[GetSpellInfo(73685) or "Unleash Life"] = true,		    	-- Unleash Life

			-- Debuffs
			--[GetSpellInfo(76780) or "Bind Elemental"] = true,				-- Bind Elemental
			[GetSpellInfo(8042) or "大地震击"] = true,						-- Earth Shock
			[GetSpellInfo(8050) or "烈焰震击"] = true,						-- Flame Shock
			[GetSpellInfo(63685) or "冰冻"] = true,							-- Frozen Power Freeze
			[GetSpellInfo(8056) or "冰霜震击"] = true,						-- Frost Shock
			[GetSpellInfo(51514) or "妖术"] = true,							-- Hex

		},
	
		WARLOCK = {

			-- Buffs
			[GetSpellInfo(54277) or "爆燃"] = true,							-- Backdraft
			--[GetSpellInfo(85114) or "Improved Soul Fire"] = true,			-- Improved Soul Fire
			[GetSpellInfo(59672) or "恶魔变形"] = true,						-- Metamorphosis
			--[GetSpellInfo(91711) or "Nether Ward"] = true,				-- Nether Ward
			[GetSpellInfo(17941) or "暗影冥思"] = true,						-- Shadow Trance_下一个暗影箭成为瞬发法术。
			[GetSpellInfo(6229) or "暗影防护结界"] = true,					-- Shadow Ward

			-- Debuffs
			[GetSpellInfo(980) or "痛苦诅咒"] = true,		 		 	 	-- Bane of Agony
			[GetSpellInfo(603) or "厄运诅咒"] = true,				  	 	-- Bane of Doom
			--[GetSpellInfo(80240) or "Bane of Havoc"] = true,			  	-- Bane of Havoc
			[GetSpellInfo(710) or "放逐术"] = true,				  			-- Banish
			[GetSpellInfo(172) or "腐蚀术"] = true,					  		-- Corruption
			[GetSpellInfo(18223) or "疲劳诅咒"] = true,						-- Curse of Exhaustion
			[GetSpellInfo(1714) or "语言诅咒"] = true,						-- Curse of Tongues
			[GetSpellInfo(48181) or "鬼影缠身"] = true,						-- Haunt
			[GetSpellInfo(348) or "献祭"] = true,							-- Immolate
			--[GetSpellInfo(74434) or "Soulburn"] = true,					-- Soulburn
			[GetSpellInfo(30108) or "痛苦无常"] = true,						-- Unstable Affliction

		},
	
		WARRIOR = {

			-- Buffs
			[GetSpellInfo(18499) or "狂暴之怒"] = true,						-- Berserker Rage
			[GetSpellInfo(46916) or "猛击！"] = true,						-- Bloodsurge
			--[GetSpellInfo(85730) or "Deadly Calm"] = true,				-- Deadly Calm
			[GetSpellInfo(12292) or "死亡之愿"] = true,						-- Death Wish
			[GetSpellInfo(3411) or "援护"] = true,					    	-- Intervene
			--[GetSpellInfo(85739) or "Meat Cleaver"] = true,			    -- Meat Cleaver
			[GetSpellInfo(12975) or "破釜沉舟"] = true,						-- Last Stand
			[GetSpellInfo(1719) or "鲁莽"] = true,			  			  	-- Recklessness
			[GetSpellInfo(20230) or "反击风暴"] = true,						-- Retaliation
			--[GetSpellInfo(86663) or "Rude Interruption"] = true,			-- Rude Interruption
			[GetSpellInfo(2565) or "盾牌格挡"] = true,				    	-- Shield Block
			[GetSpellInfo(871) or "盾墙"] = true,							-- Shield Wall
			[GetSpellInfo(23920) or "法术反射"] = true,	    				-- Spell Reflection
			[GetSpellInfo(52437) or "猝死"] = true,		    				-- Sudden Death
			[GetSpellInfo(12328) or "横扫攻击"] = true,		   			 	-- Sweeping Strikes
			[GetSpellInfo(50227) or "剑盾猛攻"] = true,		    			-- Sword and Board
			[GetSpellInfo(60503) or "血之气息"] = true,						-- Taste for Blood
			--[GetSpellInfo(87096) or "Thunderstruck"] = true,				-- Thunderstruck

			-- Debuffs
			[GetSpellInfo(1160) or "挫志怒吼"] = true,						-- Demoralizing Shout
			[GetSpellInfo(1715) or "断筋"] = true,				  		  	-- Hamstring
			[GetSpellInfo(772) or "撕裂"] = true,					    	-- Rend
			[GetSpellInfo(64382) or "碎裂投掷"] = true,		    			-- Shattering Throw
			[GetSpellInfo(58567) or "破甲攻击"] = true,			  		  	-- Sunder Armor
			--[GetSpellInfo(85388) or "Throwdown"] = true,			    	-- Throwdown

		},
	
		PET = {
		
			-- Hunter
			[GetSpellInfo(6991) or "喂养宠物"] = true,						-- Feed Pet
			[GetSpellInfo(19615) or "狂乱效果"] = true,						-- Frenzy
			[GetSpellInfo(136) or "治疗宠物"] = true,						-- Mend Pet
		
			-- Death Knight
			[GetSpellInfo(63560) or "食尸鬼狂乱"] = true,					-- Dark Transformation
			--[GetSpellInfo(91342) or "Shadow Infusion"] = true,			-- Shadow Infusion
		
			-- Warlock
		},
	},
}