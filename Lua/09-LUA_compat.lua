--external compatability

local compat = {
	oldcname = false,
	skipmonitor = false,
	mrcemom = false,
	inatext = false,
	peptext = false,
	speckismash = false,
	ptsrhook = false,
	ze2config = false,
	jetski = false,
	battlemod = false,
	gsrailskin = false,
	mmshowdown = false,
}

local function printf(...)
	
	local texts = {...}
	for k,v in ipairs(texts)
		print("\x83TAKIS:\x80 "..v)
	end
	
	if not TAKIS_ISDEBUG then return end
	Tprtable("compat",compat)
end

addHook("ThinkFrame",do
	if (OLDC and OLDC.SetSkinFullName) and not compat.oldcname
		OLDC.SetSkinFullName(TAKIS_SKIN,"Takis")
		compat.oldcname = true
		printf("Added OLDC Fullname.")
	end
	if (AddSkipMonitor) and not compat.skipmonitor
		AddSkipMonitor(MT_SHOTGUN_BOX,35,"Time to kick ass!","")
		compat.skipmonitor = true
		printf("Added Shotgun box for Skip.")
	end
	if skins["inazuma"]
	and not compat.inatext
		TAKIS_TEXTBOXES.ultzuma = {
			[1] = { 
				name = takisname,
				portrait = takisport,
				color = "playercolor",
				text = "Holy MOLY! Is that |esc\x88Ultimate Inazuma|esc\x80!?",
				sound = takisvox,
				soundchance = takischance,
				delay = 2*TICRATE,
				next = 2
			},
			[2] = { 
				name = "Ultimate Inazuma",
				namemap = V_SKYMAP,
				portrait = {"inazuma", SPR2_CLNG, A, 8, true},
				portyoffset = -30*FU,
				color = SKINCOLOR_ULTIMATE1,
				text = "Yeah, it's me.",
				sound = {sfx_menu1},
				soundchance = FU,
				delay = 2*TICRATE,
				next = 0
			},
		}
		compat.inatext = true
		printf("Added Silverhorn textboxes.")
	end
	if skins["npeppino"]
	and not compat.peptext
		TAKIS_TEXTBOXES.ntopp = {
			[1] = { 
				name = takisname,
				portrait = takisport,
				color = "playercolor",
				text = "Holy crap, Peppino Spaghetti!?",
				sound = takisvox,
				soundchance = takischance,
				delay = 2*TICRATE,
				next = 2
			},
			[2] = { 
				name = "Peppino",
				portrait = {"npeppino", SPR2_STND, A, 8, true},
				color = SKINCOLOR_WHITE,
				text = "Peppino",
				sound = {sfx_menu1},
				soundchance = FU/2,
				delay = 2*TICRATE,
				next = 0
			},
		}
		compat.peptext = true
		printf("Added NTOPP textboxes.")
	end
	if (mrceCharacterPhysics)
	and not compat.mrcemom
		--forces thrustfactor,,, stinky....
		mrceCharacterPhysics(TAKIS_SKIN,false,false,1)
		compat.mrcemom = true
		printf("Disabled MRCE momentum.")
	end
	if (specki and specki.gimmicks.smash)
	and not compat.speckismash
		local ctf = specki.gimmicks.smash
		ctf.stuff["takisthefox"] = {
			jumpheight = 12*FU,
			weight = FU,
		}
		compat.speckismash = true
		printf("Added Specki stuff.")
	end
	if (PTSR
	and PTSR_AddHook)
	and not compat.ptsrhook
		PTSR_AddHook("pfplayerfind",function(pizza,p)
			if skins[p.skin].name ~= TAKIS_SKIN then return end
			
			local takis = p.takistable
			if (takis.pitanim)
				return false --dont target
			end
		
		end)
		
		PTSR_AddHook("pfdamage",function(touch,pizza)
			if not (touch and touch.valid) then return end
			--if touch.skin ~= TAKIS_SKIN then return end
			
			local p = touch.player
			local takis = p.takistable
			if (takis.pitanim
			or ((takis.pittime >= (3*TR)-2) and takis.onGround)
			and takis.isTakis)
			or p.inkart
				PTSR.DoParry(touch,pizza)
				return true
			end
			
		end)
		
		PTSR_AddHook("pfprestunthink",function(pizza)
			if not (pizza and pizza.valid) then return end
			
			pizza.takis_flingme = false
		end)
		
		PTSR_AddHook("onlap",function(lapper)
			if not (lapper and lapper.valid) then return end
			if lapper.skin ~= TAKIS_SKIN then return end
			
			local p = lapper.player
			local takis = p.takistable
			TakisGiveCombo(p,takis,false,true)
			local hud = takis.HUD
			hud.lapanim.lapnum = p.ptsr.laps+1
			hud.lapanim.tics = 80
			hud.lapanim.time = p.ptsr.laptime
		end)
		
		PTSR_AddHook("ondamage",function(me)
			if not (me and me.valid) then return end
			if me.skin ~= TAKIS_SKIN then return end
			
			local p = me.player
			local takis = p.takistable
			
			if takis.transfo & TRANSFO_METAL
				return true
			end
		end)
		
		compat.ptsrhook = true
		printf("Added PTSR stuff.")
	end
	if (ZE2	
	and ZE2.AddConfig)
	and not compat.ze2config
		ZE2.AddConfig("takisthefox", {
			normalspeed = 19 * FRACUNIT,
			sprintboost = 12 * FRACUNIT,
			health = 60,
			charability = CA_DOUBLEJUMP,
			charability2 = CA2_NONE,
			jumpfactor = FU*4/5,
			actionspd = 30*FRACUNIT,
			desc1 = "Ready to blast zombies.",
			desc2 = "Average speed. Double jump included."
		})
		
		/*
		local summa = ZE2:CreateItem("summa", {
			icon = "SUMMAIND",
			iconscale = FU/2,
			firerate = TICRATE*5,
			sound = sfx_oyahx,
			limited = true,
			count = 3,
			price = 1,
			ontrigger = function(p)
				COM_BufInsertText(server,"takis_dojumpscare @random true")
				DoQuake(p,100*FU,5*TR)
			end
		})
		ZE2:RegisterShop_ItemID(summa)
		
		local nunna = ZE2:CreateItem("nunna", {
			icon = "NUNNAIND",
			iconscale = FU/2,
			firerate = TICRATE,
			sound = sfx_nunna,
			limited = true,
			count = 15,
			price = 1,
			ontrigger = function(p)
				DoFlash(p,PAL_WHITE,5)
			end
		})
		ZE2:RegisterShop_ItemID(nunna)
		
		ZE2:CreateItem("pan", {
			icon = "SUMMAIND",
			iconscale = FU/2,
			firerate = TICRATE,
			sound = sfx_mswing,
			limited = false,
			price = 110,
			ontrigger = function(p)
				local me = p.realmo
				
				local didit = false
				
				local dispx = FixedMul(42*me.scale+(20*me.scale),cos(p.drawangle))
				local dispy = FixedMul(42*me.scale+(20*me.scale),sin(p.drawangle))
				local thok = P_SpawnMobjFromMobj(
					me,
					dispx+me.momx,
					dispy+me.momy,
					0,
					MT_THOK
				)
				thok.radius = 40*FU
				thok.height = 60*FU
				thok.fuse = 1
				thok.flags2 = $|MF2_DONTDRAW
				thok.mobjteam = p["ze2_info"].team
				
				local fakerange = 250*FU
				local range = 80*FU
				searchBlockmap("objects", function(ref, found)
					if R_PointToDist2(found.x, found.y, ref.x, ref.y) <= range
					and L_ZCollide(found,ref)
					and (found.health)
					and (found ~= me)
						if CanFlingThing(found)
							didit = true
						elseif (found.player and found.player.valid)
							if found.player["ze2_info"].team ~= p["ze2_info"].team
								P_KillMobj(found,me,me)
								didit = true
							end
						else
							return false
						end
					end
				end, 
				thok,
				thok.x-fakerange, thok.x+fakerange,
				thok.y-fakerange, thok.y+fakerange)		
				if didit
					TakisResetTauntStuff(p)
				end
			end
		})
		*/
		
		compat.ze2config = true
		printf("Added ZE2 stuff.")
	end
	if boatchars
	and not compat.jetski
		boatchars[TAKIS_SKIN] = {0, 0, 0}
		compat.jetski = true
		printf("Added RushChars jetski.")
	end
	if (CBW_Battle and CBW_Battle.SkinVars)
	and not compat.battlemod
		local B = CBW_Battle
		
		local function Shotgunify(me,doaction)
			local p = me.player
			local takis = p.takistable
			
			p.actiontext = "Shotgunify"
			p.actionrings = 120
			p.actionsuper = true
			
			if doaction == 1
			and not (takis.transfo & TRANSFO_SHOTGUN)
				if p.rings < p.actionrings
					S_StartSound(nil, sfx_s3k8c, p)
					return
				end
				
				CBW_Battle.PayRings(p)
				TakisShotgunify(p)
			end
			
		end
		
		local function Priority(p)
			local takis = p.takistable
			
			if takis.afterimaging
				B.SetPriority(p,
					0,0,
					"knuckles_glide",
					3, 1,
					"Clutch Boost"
				)
			end
		end
		
		B.SkinVars[TAKIS_SKIN] = {
			flags = SKINVARS_GUARD|SKINVARS_NOSPINSHIELD,
			weight = 125,
			shields = 1,
			guard_frame = 1,
			special = Shotgunify,
			func_priority_ext = Priority,
			/*
			special = Titanium,
			func_precollide = Titanium_PreCollide,
			func_collide = Titanium_Collide,
			func_postcollide = Titanium_PostCollide
			*/
		}
		compat.battlemod = true
		printf("Added BattleMod stuff.")
	end
	if GS_RAILS_SKINS
	and not compat.gsrailskin
		GS_RAILS_SKINS[TAKIS_SKIN] = {}
		local GS_SKIN = GS_RAILS_SKINS[TAKIS_SKIN]
		
		GS_SKIN["PreGrindThinker"] = function(p,me,gs,rail)
			local takis = p.takistable
			
			takis.railing = {
				x = me.x,
				y = me.y,
				z = me.z
			}
		end
		GS_SKIN["GrindThinker"] = function(p,me,gs,rail)
			local takis = p.takistable
			
			takis.railing.new = {
				x = me.x,
				y = me.y,
				z = me.z
			}
			
			local momx,momy = takis.railing.new.x - takis.railing.x, takis.railing.new.y - takis.railing.y
			takis.accspeed = FixedDiv(abs(FixedHypot(momx,momy)), me.scale)
			
			if p.inkart
				me.frame = TakisKart_KarterData[me.skin].legacyframes and TakisKart_Framesets.legacy.driftL or TakisKart_Framesets.norm.driftR
				me.sprite2 = SPR2_KART
			end
		end
		
		compat.gsrailskin = true
		printf("Added GS Rails stuff.")
	end
	if MM and MM.showdownSprites
	and not compat.mmshowdown
		MM.showdownSprites[TAKIS_SKIN] = "MMSD_TAKISTF"
		
		compat.mmshowdown = true
		printf("Saxa's MM stuff.")
	end
end)

TAKIS_FILESLOADED = $+1