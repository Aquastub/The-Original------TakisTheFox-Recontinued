/*	HEADER
	Functions that perform stuff
	
*/

local CS_AUTOMATIC = 1
local CS_MANUAL = 2
local CS_STRAFE = 3
local CS_OLDANALOG = 4
local function GetControlStyle(p)
	local flags = p.pflags & (PF_ANALOGMODE|PF_DIRECTIONCHAR)
	
	if flags == (PF_ANALOGMODE|PF_DIRECTIONCHAR)
		return CS_AUTOMATIC
	elseif flags == PF_DIRECTIONCHAR
		return CS_MANUAL
	elseif flags == 0
		return CS_STRAFE
	elseif flags == PF_ANALOGMODE
		return CS_OLDANALOG
	end
	
end

--idk why i didnt just rawset this before
rawset(_G,"L_ZCollide",function(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end)

local BTtoTable = {
	[BT_CUSTOM1] = "c1",
	[BT_CUSTOM2] = "c2",
	[BT_CUSTOM3] = "c3",
	[BT_USE] = "use",
	[BT_TOSSFLAG] = "tossflag",
	[BT_ATTACK] = "fire",
	[BT_FIRENORMAL] = "firenormal",
	[BT_JUMP] = "jump",
	[BT_WEAPONNEXT] = "weaponnext",
	[BT_WEAPONPREV] = "weaponprev",
}

local function btntic(p,tic,enum)
	local btn = p.cmd.buttons
	if btn & enum
		if tic ~= 0
			p.takistable[BTtoTable[enum].."_R"] = 5 + p.cmd.latency
		end
		tic = $+1
	else
		tic = 0
		if p.takistable[BTtoTable[enum].."_R"] > 0
			p.takistable[BTtoTable[enum].."_R"] = $-1
		end
	end
	return tic
end

local cusbut = {
	[1] = BT_CUSTOM1,
	[2] = BT_CUSTOM2,
	[3] = BT_CUSTOM3
}
rawset(_G, "TakisButtonStuff", function(p,takis)
	
	local btn = p.cmd.buttons
	
	takis.jump = btntic(p,$,BT_JUMP)
	takis.nadouse = takis.use
	takis.use = btntic(p,$,BT_USE)
	takis.tossflag = btntic(p,$,BT_TOSSFLAG)
	for i = 1,3
		takis["c"..i] = btntic(p,$,cusbut[i])
	end
	takis.fire = btntic(p,$,BT_ATTACK)
	takis.firenormal = btntic(p,$,BT_FIRENORMAL)
	
	if btn & BT_WEAPONMASK
		takis.weaponmasktime = $+1
		takis.weaponmask = (btn & BT_WEAPONMASK)
	else
		takis.weaponmasktime = 0
		takis.weaponmask = 0
	end
	
	takis.weaponnext = btntic(p,$,BT_WEAPONNEXT)
	takis.weaponprev = btntic(p,$,BT_WEAPONPREV)
	
	if (takis.nocontrol)
	or (p.pflags & PF_STASIS)
	or (p.powers[pw_nocontrol])
	or (p.realmo.flags & MF_NOTHINK)
	--teleporters
	or (p.realmo.reactiontime)
		if takis.nocontrol
			takis.nocontrol = $-1
		end
		/*
		takis.jump = 0
		takis.use = 0
		takis.tossflag = 0
		takis.c1 = 0
		takis.c2 = 0
		takis.c3 = 0
		takis.fire = 0
		takis.firenormal = 0
		takis.weaponmasktime = 0
		takis.weaponmask = 0
		takis.weaponnext = 0
		takis.weaponprev = 0
		*/
		takis.noability = NOABIL_ALL|NOABIL_THOK|NOABIL_AFTERIMAGE
		if takis.nocontrol
		--LOL THIS FIXES IT
		and (p.powers[pw_carry] ~= CR_DUSTDEVIL)
			p.powers[pw_nocontrol] = takis.nocontrol
		end
	end
	
end)

rawset(_G, "TakisBooleans", function(p,me,takis,SKIN)
	local posz = me.floorz
	local z = me.z
	if (P_MobjFlip(me) == -1)
		posz = me.ceilingz
		z = me.z+me.height
	end
	
	takis.onPosZ = (z == posz)
	
	takis.onGround = (P_IsObjectOnGround(me)) or (takis.onPosZ) and (not (P_CheckDeathPitCollide(me)))
	if (p.powers[pw_carry] == CR_ROLLOUT) then takis.onGround = true end
	takis.inPain = P_PlayerInPain(p)
	takis.isTakis = (me.skin == SKIN) or (skins[p.skin].name == SKIN)
	takis.isSinglePlayer = ((not netgame) and (not splitscreen))
	takis.inWater = (me.eflags&MFE_UNDERWATER) and not (me.eflags & MFE_TOUCHLAVA)
	takis.inGoop = P_IsObjectInGoop(me)
	takis.notCarried = ((p.powers[pw_carry] == CR_NONE) and not (takis.inwaterslide))
	if p.powers[pw_carry] == CR_FAN
	or p.lastCR_FAN
		takis.notCarried = true
	end
	takis.isElevated = IsPlayerAdmin(p) or (p == server)
	takis.inNIGHTSMode = (p.powers[pw_carry] == CR_NIGHTSMODE) or (maptol & TOL_NIGHTS)
	takis.inSRBZ = gametype == GT_ZE2
	takis.inChaos = (CBW_Chaos_Library and CBW_Chaos_Library.Gametypes[gametype])
	takis.isSuper = p.powers[pw_super] > 0
	takis.isAngry = (me.health or p.playerstate == PST_LIVE) and (takis.combo.count >= 10)
	takis.inBattle = (CBW_Battle and CBW_Battle.BattleGametype())
	takis.in2D = (me.flags2 & MF2_TWOD or twodlevel)
	takis.inSaxaMM = (MM and MM:isMM())
	
	--cheap
	if me.skin ~= SKIN
		if takis.onGround
			takis.slopeairtime = false
		else
			if p.powers[pw_justlaunched]
				takis.slopeairtime = true
			end
		end
	end
end)

local function dorandom()
	local random = P_RandomRange(0,1)
	if random == 0
		random = -1
	end
	return random
end
local function getdec(random)
	return P_RandomByte() * 256 * random
end

local function ResetHHHud(p)
	local hh = p.takistable.HUD.happyhour	

	hh.its.scale = FU/100
	hh.happy.scale = FU/100
	hh.hour.scale = FU/100
	
	hh.its.yadd = -100*FU
	hh.happy.yadd = -400*FU
	hh.hour.yadd = -1000*FU
	hh.face.yadd = -100*FU
	
	hh.its.momy = 0
	hh.happy.momy = 0
	hh.hour.momy = 0
	hh.face.momy = 0

	hh.its.momx = 0
	hh.happy.momx = 0
	hh.hour.momx = 0
	hh.face.momx = 0

	hh.its.x = 60*FU
	hh.happy.x = 155*FU
	hh.hour.x = 260*FU
	hh.face.x = 155*FU
	
end

rawset(_G, "TakisAnimateHappyHour", function(p)
	local takis = p.takistable
	local hud = takis.HUD
	local me = p.mo

	if HAPPY_HOUR.timelimit
		
		if HAPPY_HOUR.timeleft
			local tics = HAPPY_HOUR.timeleft
			local time = hud.timeshake
			
			local cando = HH_CanDoHappyStuff(p)
			
			if tics <= (56*TR)
			and cando
			and not HAPPY_HOUR.gameover
				hud.timeshake = ((56*TR)-tics)+1
			end
			
		else
			hud.timeshake = 0
		end
		
	else
		hud.timeshake = 0
	end
	
	local cando = HH_CanDoHappyStuff(p)
	local hh = hud.happyhour
	
	--TODO: This is old and messy, maybe due for a rewrite?
	--		yeah no this definietl;y needs a rewrite this shit is SOOO MESSY
	if HAPPY_HOUR.time and HAPPY_HOUR.time <= 5*TR	
	and (cando)
		
		local tics = HAPPY_HOUR.time
		if tics == 1
			ResetHHHud(p)
		end
		
		hh.its.frame = ((leveltime/3)%2)
		hh.happy.frame = ((leveltime/3)%2)
		hh.hour.frame = ((leveltime/3)%2)
		local faceframes = 2
		if (P_IsValidSprite2(me,SPR2_HHF_))
			faceframes = skins[p.skin].sprites[SPR2_HHF_].numframes
		end
		hh.face.frame = ((leveltime/3)%faceframes)
		
		local frac = FU/16
		local back = FU*10
		
		if hh.doingit
			if not hh.falldown
				
				hh.its.yadd = ease.outback(frac,$,0,back)
				hh.happy.yadd = ease.outback(frac,$,0,back)
				hh.hour.yadd = ease.outback(frac,$,0,back)
				
				--elseif hud.happyhour.face.yadd ~= 0
				hh.face.yadd = ease.outquad(frac,$,0)
			else
				--THIS SHIT IS SO ASS
				local grav = FU
				hh.its.momy = $ + grav
				hh.happy.momy = $ + grav
				hh.hour.momy = $ + grav
				hh.face.momy = $ + grav
				
				hh.its.yadd = $ + hh.its.momy
				hh.happy.yadd = $ + hh.happy.momy
				hh.hour.yadd = $ + hh.hour.momy
				hh.face.yadd = $ + hh.face.momy
			
				hh.its.x = $ + hh.its.momx
				hh.happy.x = $ + hh.happy.momx
				hh.hour.x = $ + hh.hour.momx
				hh.face.x = $ + hh.face.momx
				
			end
		end

		hh.doingit = true
		
		hh.its.scale = ease.outback(frac,		$,	3*FU/5,	back)
		hh.happy.scale = ease.outback(frac,	$,	3*FU/5,	back)
		hh.hour.scale = ease.outback(frac,	$,	3*FU/5,	back)
		
		hh.falldown = tics >= 2*TR
		if tics == 2*TR
			local min,max = 4,10
			hh.its.momy = -P_RandomRange(min,max)*FU + getdec(0)
			hh.happy.momy = -P_RandomRange(min,max)*FU + getdec(0)
			hh.hour.momy = -P_RandomRange(min,max)*FU + getdec(0)
			hh.face.momy = -P_RandomRange(min,max)*FU + getdec(0)
			
			min,max = -6,6
			--Goes to far left
			hh.its.momx = P_RandomRange(min,1)*FU + getdec(0)
			
			--Either side
			hh.happy.momx = -P_RandomRange(min/2,max/2)*FU + getdec(0)
			hh.face.momx = -P_RandomRange(min/2,max/2)*FU + getdec(0)
			
			--Goes to far right
			hh.hour.momx = P_RandomRange(-1,max)*FU + getdec(0)
		end
	
	else
		hh.doingit = false
		hh.falldown = false
		
		ResetHHHud(p)
	end
	

end)

rawset(_G, "TakisHappyHourThinker", function(p)
	local takis = p.takistable
	local me = p.realmo
	
	--happy hour hud and stuff
	local cando = HH_CanDoHappyStuff(p)
	
	if HAPPY_HOUR.happyhour
	and (cando)
		if not HAPPY_HOUR.gameover
			local tics = HAPPY_HOUR.time
			
			if not modeattacking
				p.realtime = leveltime - takis.HUD.rthh.time
			end
			
			if (tics == 1)
				if (HAPPY_HOUR.othergt)
					S_StartSound(nil,sfx_mclang,p)
				end
				TakisGiveCombo(p,takis,false,true)
			end
			
			if (me.health)
			--how convienient that 8 tics just so happens to be
			--exactly 22 centiseconds!
			and (tics == 8)
				if (p.happyhourscream
				and p.happyhourscream.skin == me.skin)
					S_StartSound(nil,p.happyhourscream.sfx,p)
				end
			end
			
			
			DoQuake(p,2*FU,1,0,"HHThinker - Shake")
			
			if (tics <= TR)
				DoQuake(p,(72-(2*tics))*FU,1,0,"HHThinker - HHStart shake")
			end
		end
	end
	
	//end of happy hour quakes
	if HAPPY_HOUR.timelimit
	and cando
		if HAPPY_HOUR.timeleft
			local tics = HAPPY_HOUR.timeleft
			local time = takis.HUD.timeshake
			
			if tics <= (56*TR)
				local nomus,noendmus,song,songend = GetHappyHourMusic()
				
				if not takis.sethappyend
				and not noendmus
					S_ChangeMusic(HAPPY_HOUR.songend,false,p,0,0,3*MUSICRATE)
					mapmusname = HAPPY_HOUR.songend
					takis.sethappyend = true
				end
				DoQuake(p,(time*FU)/50,1,0,"HHThinker - EOHH1")
				DoQuake(p,(time*FU)/50,1,0,"HHThinker - EOHH2")
			end
			
		else
			takis.sethappyend = false
		end
		
	else
		takis.sethappyend = false
	end
	

end)

--this is so minhud!!!
local function DoCountdownLogic(p)
	local takis = p.takistable
	local hud = takis.HUD
	local cd = hud.countdown
	
	
	-- Determine if countdown should be drawn. Return tics for purposes.
	-- Manage variables related to countdown.
	cd.scale = ease.inexpo(FU*8/10,$,0)
	if not (cd.lock) then cd.tics = max(0, $-1) end
	
	if (cd.sound) and (cd.sound ~= sfx_none)
	and (takis.isTakis)
		S_StartSound(nil, cd.sound, p)
		cd.sound = sfx_none
	end
	
	local tics = -1
	local hidetime = CV_FindVar("hidetime").value*TICRATE
	local timelimit = CV_FindVar("timelimit").value*60*TICRATE
	local hidecountdown = hidetime - leveltime
	local timecountdown = timelimit - leveltime
	if ((gametyperules & (GTR_STARTCOUNTDOWN|GTR_TAG)) == (GTR_STARTCOUNTDOWN|GTR_TAG))
		timecountdown = (timelimit+hidetime) - leveltime
	end
	
	-- Gametype uses a time limit - countdown when it's about to end/enter overtime.
	if (gametyperules & GTR_TIMELIMIT)
	and (timecountdown > 0) and (timecountdown <= 4*TICRATE)
	and (timecountdown%TICRATE == 0)
		tics = max(-1, timecountdown)
		return true, tics
	end
	
	-- Gametype uses a starting countdown.
	if (gametyperules & GTR_STARTCOUNTDOWN)
	and (hidecountdown >= 0) and (hidecountdown <= 3*TICRATE)
	and (hidecountdown%TICRATE == 0)
		tics = max(-1, hidetime - leveltime)
		return true, tics
	end
	
	-- Gametype is a race - do a starting countdown.
	if (gametyperules & GTR_RACE)
	and (leveltime >= TICRATE and leveltime <= 4*TICRATE)
	and (leveltime%TICRATE == 0)
	--vanilla hardcodes this part so it wouldnt make sense to have it again
	and (true == false)
	--and (gametype ~= GT_RACE)
		tics = max(-1, TICRATE*4 - leveltime)
		return true, tics
	end
	
	if (takis.inSaxaMM)
		tics = MM_N.time
		
		if (tics > 0 and tics <= 3*TR)
		and (tics % TR == TR-1)
			return true, max(-1,tics+TR)
		end
	end
	
	return false, tics
	
end
local function DoCountdown(p)
	local takis = p.takistable
	local hud = takis.HUD
	local cd = hud.countdown

	local racenum, sound, scale, scale2 = "", sfx_none, cd.scale, 0
	local trigger, tics, overtime = DoCountdownLogic(p)
	
	if (tics/TR) == 3
		racenum = "3"
		sound = sfx_s3ka7
		scale2 = 0
	elseif (tics/TR) == 2
		racenum = "2!"
		sound = sfx_s3ka7
		scale2 = FU/4
	elseif (tics/TR) == 1
		racenum = "1!!"
		sound = sfx_s3ka7
		scale2 = FU/2
	elseif (tics/TR) == 0
		racenum = overtime and "{" or "}"
		sound = sfx_s3kad
		scale2 = 0
	end
	
	if (trigger) -- Setup the timer, bounce, number to display, and sound to play.
	and not (cd.lock)
		cd.tics = TR
		cd.scale = FU
		cd.scale2 = scale2
		cd.number = racenum
		cd.sound = sound
		cd.lock = true
	elseif not (trigger)
	and (cd.lock)
		cd.lock = false
	end
	
end

rawset(_G, "TakisHUDStuff", function(p)
	local takis = p.takistable
	local hud = takis.HUD
	local me = p.realmo
	
	DoCountdown(p)
	
	if ((G_RingSlingerGametype()
	and not (
		(gametyperules & GTR_LIVES)
		or G_GametypeHasTeams()
		or (gametyperules & GTR_TAG)
	))
	or HAPPY_HOUR.othergt
	or gametyperules & GTR_RACE)	
		hud.lives.useplacements = true
	end
	
	local realslinger = false
	local ringslinger = false
	if (G_RingSlingerGametype() or takis.inSRBZ)
		realslinger = true
		ringslinger = true
	end
	if (p.powers[pw_shield] & SH_FIREFLOWER)
	or (takis.transfo & TRANSFO_FIREASS)
		ringslinger = true
	end
	
	if (takis.transfo & TRANSFO_SHOTGUN)
	or (ringslinger)
	and not p.spectator
		local mm = gametype == GT_MURDERMYSTERY
		local role = p.role or 0
		
		if (takis.transfo & TRANSFO_SHOTGUN)
			if (takis.inPain or takis.inFakePain)
			or p.powers[pw_carry] == CR_ZOOMTUBE
			or (takis.noability & NOABIL_SHOTGUN or p.pflags & PF_SPINNING)
			or takis.shotgunshotdown
				hud.viewmodel.boby = max($, 70*FRACUNIT)
			end
		end
		
		if realslinger
		and not (takis.transfo & TRANSFO_SHOTGUN)
			if (takis.lastweapon ~= takis.currentweapon
			and not takis.weapondelaytic)
				hud.viewmodel.boby = max($, 70*FRACUNIT)
			end
		end
		
		--rsneo
		--bobbing
		hud.viewmodel.bob = min(FixedMul(p.rmomx,p.rmomx) + FixedMul(p.rmomy,p.rmomy) / 30, 7*FRACUNIT)
		
		local wdt = min(takis.weapondelaytics,4)
		
		if (takis.transfo & TRANSFO_SHOTGUN)
			wdt = 0
		end
		if wdt == 1
			hud.viewmodel.bobx = 0
			hud.viewmodel.boby = 0
		end
		
		local target
		if P_IsObjectOnGround(me)
			target = FixedMul(sin(leveltime * ANG20),hud.viewmodel.bob)
		else
			target = max(min(10*FRACUNIT, me.momz), -10*FRACUNIT)
		end
		do
			local lastaim = takis.lastaiming
			local myaim = p.aiming
			
			local adjust = (lastaim - myaim)
			
			adjust = ($/ANG1)*FU
			adjust = max(-30*FU,min($,30*FU))
			target = $ - adjust
			
		end
		if wdt
			target = $+(wdt*45*FU)
			target = min($,140*FU)
		end
		if ringslinger
		and not (takis.transfo & TRANSFO_SHOTGUN)
			if p.climbing 
			or (G_TagGametype() and not (p.pflags & PF_TAGIT))
			--or takis.currentweapon == -1
			or (mm and role == ROLE_INNOCENT)
				target = max($,130*FU)
				takis.currentweapon = -1
			end
		end
		
		local diff = max(target - hud.viewmodel.boby, -45*FRACUNIT)
		hud.viewmodel.boby = $ + diff / 4
		
		if P_IsObjectOnGround(me)
			target = (-p.cmd.sidemove * FRACUNIT / 18)
		else
			target = 0
		end
		do
			local lastangle = takis.lastangle
			local myangle = p.cmd.angleturn << 16
			
			local adjust = (lastangle - myangle)
			
			adjust = ($/ANG1)*FU
			adjust = clamp(-30*FU,$,30*FU) --max(-30*FU,min($,30*FU))
			target = $ - adjust --(lastangle - myangle)
		end
		if wdt
			target = $-(wdt*70*FU)
			hud.viewmodel.bobx = $-(wdt*15*FU)
			hud.viewmodel.bobx = max($,-185*FU)
			--target = max($,-225*FU)
		end
		
		diff = target - hud.viewmodel.bobx
		hud.viewmodel.bobx = $ + diff / 10
		
		if hud.viewmodel.frameinc
			hud.viewmodel.frameinc = $-1
		end
	else
		hud.viewmodel.boby = max($, 70*FRACUNIT)
	end
	
	hud.rings.ringframe = 0
	if mobjinfo[hud.rings.type].spawnstate
	and (states[mobjinfo[hud.rings.type].spawnstate].frame & FF_ANIMATE)
		hud.rings.ringframe = states[mobjinfo[hud.rings.type].spawnstate].var1
	end
	local ringframe = hud.rings.ringframe
	
	if p.rings > hud.rings.drawrings
		hud.rings.drawrings = $+1
			
		for i = 1,21
			if (p.rings - hud.rings.drawrings >= (i+1))
				
				hud.rings.drawrings = $+1
				
			end
		end
	elseif p.rings < hud.rings.drawrings
		hud.rings.drawrings = $-1
			
		for i = 1,21
			if (hud.rings.drawrings - p.rings >= (i+1))
				
				hud.rings.drawrings = $-1
				
			end
		end
	end
	
	if hud.rings.drawrings ~= takis.lastrings
		if not (hud.rings.spin/FU)
			hud.rings.spin = ringframe*2*FU
		else
			hud.rings.spin = $+P_RandomRange(ringframe/2,ringframe)*FU
		end
		hud.rings.shake = TR/2
	end
	
	local noringspinning = false
	if takis.accspeed > 30*FU
		hud.rings.spin = $+FixedMul(FU,FixedDiv(takis.accspeed,30*FU))
		noringspinning = true
	end
	
	if hud.rings.spin
	and not noringspinning
		if not (hud.rings.spin > ringframe*2*FU)
			hud.rings.spin = FixedMul($,FU*8/10)
		else
			hud.rings.spin = $*8/10
		end
	end
	if hud.rings.shake
		hud.rings.shake = $-1
	end
	
	--i should make a timer func for these 
	if hud.rthh.tics
		hud.rthh.tics = $-1
	end
	if hud.rthh.sptic
		hud.rthh.sptic = $-1
	end
	
	hud.hudname = skins[p.skin].hudname
	if me.skin == TAKIS_SKIN
		if p.skincolor == SKINCOLOR_SALMON
			hud.hudname = "Rakis"
			
		elseif p.skincolor == SKINCOLOR_GREEN
			hud.hudname = "Taykis"
		elseif p.skincolor == SKINCOLOR_RED
		and not ((p.skincolor == skincolor_redteam) and G_GametypeHasTeams())
			hud.hudname = "Raykis"
		
		elseif p.skincolor == SKINCOLOR_SHAMROCK
			hud.hudname = "Takeys"
		elseif p.skincolor == SKINCOLOR_SIBERITE
			hud.hudname = "Rakeys"
			
		--jsmoothie!!!!
		elseif p.skincolor == SKINCOLOR_AZURE
			hud.hudname = "Jsakis"
		elseif p.skincolor == SKINCOLOR_PINK
			hud.hudname = "Sjakis"
			
		elseif p.skincolor == SKINCOLOR_BLUE
		and not ((p.skincolor == skincolor_blueteam) and G_GametypeHasTeams())
			hud.hudname = "Blukis"
		elseif p.skincolor == SKINCOLOR_YELLOW
			hud.hudname = "Yakis"
		elseif p.skincolor == SKINCOLOR_GOLDENROD
			hud.hudname = "Golkis"
		
		--tailoyo
		elseif p.skincolor == SKINCOLOR_BLACK
			hud.hudname = "Poyo"
		--specki
		elseif p.skincolor == SKINCOLOR_CARBON
			hud.hudname = "Speckis"
		end
	end
	
	if (PTSR)
	and (HAPPY_HOUR.othergt)
		if (PTSR.gameover)
			
			local tics = PTSR.intermission_tics
			if tics == nil then tics = PTSR.gameover_tics end
			
			if tics <= 2*TR
				local et = 2*TR
				hud.ptsr.yoffset = ease.inquad(( FU / et )*tics,0,200*FU)
			else
				if hud.ptsr.yoffset ~= 200*FU
					hud.ptsr.yoffset = 200*FU
				end
			end
			
		end
	end
	
	if (gametyperules & GTR_RACE)
	and circuitmap
		if p.realtime == 0
			takis.laptime = 0
		end
		
		local maxlaps = CV_FindVar("numlaps").value
		hud.lapanim.maxlaps = maxlaps
		if p.laps > takis.lastlaps
			S_StopSoundByID(me,sfx_strpst)
			if p.laps == maxlaps
				S_StartSound(nil,sfx_s3k6a,p)
			elseif p.laps == maxlaps-1
				S_StartSound(nil,sfx_s3k68,p)
			elseif p.laps < maxlaps-1
				S_StartSound(nil,sfx_strpst,p)
			end
			
			if p.laps ~= maxlaps
				hud.lapanim.lapnum = p.laps+1
				hud.lapanim.tics = 80
				hud.lapanim.time = takis.laptime
				takis.laptime = 0
			end
		end
		if p.laps ~= maxlaps
		and (p.realtime > 0)
			takis.laptime = $+1
		end
	else
		takis.laptime = 0
	end
	
	if hud.lapanim.tics
		hud.lapanim.tics = $-1
	end
	
	if hud.menutext.tics
		hud.menutext.tics = $-1
	end
	
	if hud.cfgnotifstuff
		if takis.c3 then hud.cfgnotifstuff = 1 end
		if (not multiplayer) and takis.c2
			--wtf??? this isnt hudstuff
			G_SetCustomExitVars(1000,2)
			G_ExitLevel()
			hud.cfgnotifstuff = 1
		end
		hud.cfgnotifstuff = $-1
	end
	
	if takis.nadotuttic
		if takis.c3 then takis.nadotuttic = 1 end
		takis.nadotuttic = $-1
	end 
	
	/*
	local bonus = takis.bonuses
	if bonus["shotgun"].tics
		bonus["shotgun"].tics = $-1
	end
	
	if bonus["ultimatecombo"].tics
		bonus["ultimatecombo"].tics = $-1
	end
	
	if bonus["happyhour"].tics
		bonus["happyhour"].tics = $-1
	end
	
	for k,val in ipairs(bonus.cards)
		if val.tics
			val.tics = $-1
		else
			--table.remove(bonus.cards,k)
		end
	end
	*/
	
	if hud.heartcards.add > 0
		hud.heartcards.add = $*20/22
	end

	if hud.heartcards.shake > 0
		hud.heartcards.shake = $-1
	end
	
	if hud.heartcards.spintic
		hud.heartcards.spintic = $-1
	else
		if hud.heartcards.oldhp then hud.heartcards.oldhp = 0 end
		if hud.heartcards.hpdiff then hud.heartcards.hpdiff = 0 end
	end
	
	if hud.statusface.evilgrintic > 0
		hud.statusface.evilgrintic = $-1
	end
	
	if hud.statusface.happyfacetic > 0
		hud.statusface.happyfacetic = $-1
	end

	if hud.statusface.painfacetic > 0
		hud.statusface.painfacetic = $-1
	end
	
	if (me.health)
	and not (takis.fakeexiting)
		if takis.heartcards <= (TAKIS_MAX_HEARTCARDS/TAKIS_MAX_HEARTCARDS)
			if not (leveltime%TR)
				hud.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME/2
			end
		
		elseif takis.heartcards <= (TAKIS_MAX_HEARTCARDS/2)
			if not (leveltime%(TR*2))
				hud.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME/3
			end
		
		elseif takis.heartcards == 0

			if not (leveltime%(3*TR/5))
				hud.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME/4
			end
		
		end
	end
	
	
	local cando = HH_CanDoHappyStuff(p)
	
	--happy hour hud and stuff
	if HAPPY_HOUR.time
	and (cando)
		local tics = HAPPY_HOUR.time
		
		if (tics == 1)
			hud.ptsr.yoffset = 200*FU
		end
		
		if not (HAPPY_HOUR.gameover)
			if tics <= 2*TR
				if hud.ptsr.yoffset ~= 0
					local et = 2*TR
					hud.ptsr.yoffset = ease.outquad(( FU / et )*tics,200*FU,0)
				end
			else
				if hud.ptsr.yoffset ~= 0
					hud.ptsr.yoffset = 0
				end
			end
		else
			tics = HAPPY_HOUR.gameovertics
			if tics <= 2*TR
				if hud.ptsr.yoffset ~= 200*FU
					local et = 2*TR
					hud.ptsr.yoffset = ease.inquad(( FU / et )*tics,0,200*FU)
				end
			else
				if hud.ptsr.yoffset ~= 200*FU
					hud.ptsr.yoffset = 200*FU
				end
			end
		end
	else
		hud.ptsr.yoffset = 200*FU
	end
	
	if hud.flyingscore.tics > 0
		--in hud.lua now
		/*
		local expectedtime = 2*TR
		local tics = ((2*TR)+1)-hud.flyingscore.tics
		
		--this is the combo pos and whatnot
		local backx = 15*FU
		local backy = 70*FU
		
		hud.flyingscore.x = ease.inexpo(
			( FU / expectedtime )*tics,
			backx+5*FU+hud.combo.patchx, 
			hud.flyingscore.scorex*FU
		)
		hud.flyingscore.y = ease.inexpo(
			( FU / expectedtime )*tics,
			backy+7*FU, 
			hud.flyingscore.scorey*FU
		)
		*/
		
		hud.flyingscore.tics = $-1
	else
		if hud.flyingscore.num
			hud.flyingscore.scorenum = $+hud.flyingscore.num
			hud.flyingscore.num = 0
		end
		hud.flyingscore.lastscore = 0
	end

	if hud.rank.grow > 0
		hud.rank.grow = $/2
	end

	TakisAnimateHappyHour(p)
	
	local random = dorandom()

	local score = p.score
	if hud.flyingscore.tics
	and takis.io.minhud == 0
		score = p.score-hud.flyingscore.lastscore
	end
	random = dorandom()
	
	if score > hud.flyingscore.scorenum
		if (score-hud.flyingscore.scorenum >= 5)
			hud.flyingscore.scorenum = $+5
			
			random = dorandom()
			hud.flyingscore.xshake = getdec(random) --v.RandomFixed()*random
			random = dorandom()
			hud.flyingscore.yshake = getdec(random) --v.RandomFixed()*random
			
			for i = 1,1000
				if (score-hud.flyingscore.scorenum >= 5*(i+1))
					
					hud.flyingscore.scorenum = $+5
					
					random = dorandom(v)
					hud.flyingscore.xshake = $+getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
					random = dorandom(v)
					hud.flyingscore.yshake = $+getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
				
				end
			end
		else
			hud.flyingscore.scorenum = $+score-hud.flyingscore.scorenum
		end
	elseif score < hud.flyingscore.scorenum
		if (hud.flyingscore.scorenum-score >= 5)
			hud.flyingscore.scorenum = $-5
			
			random = dorandom()
			hud.flyingscore.xshake = -getdec(random)
			random = dorandom()
			hud.flyingscore.yshake = -getdec(random)
			
			for i = 1,1700
				if (hud.flyingscore.scorenum-score >= 5*(i+1))
					
					hud.flyingscore.scorenum = $-5
					
					random = dorandom()
					hud.flyingscore.xshake = $-getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
					random = dorandom()
					hud.flyingscore.yshake = $-getdec(random) --FixedDiv(v.RandomFixed(),2*FU)*random
				
				end
			end
		else
			hud.flyingscore.scorenum = $-(hud.flyingscore.scorenum-score)
		end
	end
		
	hud.flyingscore.xshake = $/3
	hud.flyingscore.yshake = $/3
	
	if hud.combo.scale ~= 0
		hud.combo.scale = ease.inexpo(FU*7/10,$,0)
	end
	
	hud.combo.penaltyshake = max($-1,0)
	
	if hud.combo.fillnum ~= takis.combo.time*FU
	and takis.combo.time
		hud.combo.fillnum = ease.outquad(FU/5,$,takis.combo.time*FU)
	end
	
	local lives = p.lives
	if (CV_FindVar("cooplives").value == 3)
	and (netgame or multiplayer)
		lives = TAKIS_MISC.livescount
	end
	
	if lives ~= takis.lastlives
		takis.oldlives = takis.lastlives
		if not hud.lives.tweentic
			hud.lives.tweentic = 5*TR
		else
			if hud.lives.tweentic < 4*TR
				hud.lives.tweentic = 4*TR
			end
		end
	end
	
	if (not (gametyperules & GTR_FRIENDLY)
	and not p.spectator)
	--take a peak at your lives by holding fn
	or ((takis.firenormal >= TR) and not (takis.c2 or takis.c3))
	or modeattacking
	or takis.lastskincolor ~= p.skincolor
	or HAPPY_HOUR.othergt
	or p.inkart
	or (takis.inBattle)
	and (me.health)
		if not hud.lives.tweentic
			hud.lives.tweentic = 5*TR
		else
			if hud.lives.tweentic < 2*TR+1
				hud.lives.tweentic = 2*TR+1
			end
		end
	end
	
	if ((takis.firenormal == TR) and not (takis.c2 or takis.c3))
		for k,tooltip in pairs(hud.tooltips)
			
			if tooltip.prolong
				tooltip.tics = TAKIS_TOOLTIP_TIME
			end
			
		end
	end
	
	if takis.inBattle
		hud.lives.tweentic = 0
	end
	
	if hud.lives.tweenwait == 0
		if hud.lives.tweentic
			local minx = -55*FU
			local maxx = 15*FU
			
			local etin = TR/2
			local intic = (5*TR)-hud.lives.tweentic
			
			if intic <= TR/2
				hud.lives.tweenx = ease.outback((FU/etin)*intic,minx, maxx, FU*3/2)
			else
				hud.lives.tweenx = maxx
			end
			
			if intic >= TR
			and takis.oldlives ~= lives
				takis.oldlives = lives
				hud.lives.bump = FU*3/2
			end
			
			if intic >= 4*TR
				if intic > 4*TR+etin
					hud.lives.tweenx = minx
				else
					hud.lives.tweenx = ease.inquad((FU/etin)*(4*TR-intic), maxx, minx)
				end
			end
			
			hud.lives.tweentic = $-1
		else
			hud.lives.tweenx = -55*FU
		end
		
	else
		hud.lives.tweenwait = $-1
	end
	
	if hud.lives.bump then hud.lives.bump = $*4/5 end
	
	local maxtime = TAKIS_MAX_COMBOTIME
	if (p.ptsr)
	and HAPPY_HOUR.othergt
		maxtime = p.ptsr.combo_maxtime
		takis.combo.time = p.ptsr.combo_timeleft
	end
	
	--red
	if hud.combo.fillnum <= maxtime*FU/4
		hud.combo.shake = sin(FixedAngle(FU)*(leveltime*32)*2)*2
	--orange
	elseif hud.combo.fillnum <= maxtime*FU/2
		hud.combo.shake = sin(FixedAngle(FU)*(leveltime*32)*2)
	end

	hud.showingachs = 0
	for k,va in ipairs(hud.steam)
		if va == nil
			continue
		end
		
		local enum = va.enum
		
		if hud.showingachs & enum
			table.remove(hud.steam,k)
			break
		end
		
		hud.showingachs = $|enum
		
		local t = TAKIS_ACHIEVEMENTINFO
		local x = va.xadd
		if va.xadd ~= 0
			va.xadd = $*2/3 --ease.outquad(( FU / et )*(takis.HUD.steam.tics-(3*TR)), 9324919, 0)
		end
		va.tics = $-1
				
		if hud.steam[k].tics == 0
			table.remove(hud.steam,k)
		end
		
	end
	
	if hud.funny.tics
		hud.funny.y = $*4/5
		hud.funny.tics = $-1
	end
	
	if p.takis_dotitle
		local title = hud.bosstitle
		title.takis[1],title.takis[2] = unpack(title.basetakis)
		title.egg[1],title.egg[2] = unpack(title.baseegg)
		title.vs[1],title.vs[2] = unpack(title.basevs)
		title.mom = 1980
		title.tic = 3*TR
		p.takis_dotitle = nil
	end
	
	if hud.bosstitle.tic
		local title = hud.bosstitle
		
		if title.mom ~= 0
			if title.tic > 16
				title.mom = $*5/6
			else
				title.mom = $*9/6
			end
			title.takis[1] = title.basetakis[1]-title.mom
			title.egg[1] = title.baseegg[1]+title.mom
			title.vs[1] = title.basevs[1]+title.mom
			title.vs[2] = title.basevs[2]-title.mom
		else
			title.takis[1],title.takis[2] = unpack(title.basetakis)
			title.egg[1],title.egg[2] = unpack(title.baseegg)		
		end
		
		if title.tic == 16 then title.mom = -6 end
		title.tic = $-1
	end

	if hud.combo.tokengrow ~= 0
		hud.combo.tokengrow = $/2
	end
	
	if takis.combo.slidetime
		local et = TR/2
		takis.combo.slidein = ease.outback((FU/et)*((TR/2)-takis.combo.slidetime), -300*FU, 0, FU)
		
		takis.combo.slidetime = $-1
	else
		takis.combo.slidein = -300*FU
	end
	
	if takis.combo.failtics then takis.combo.failtics = $-1 end
	
	--this shouldnt resynch
	for i = 0,31
		if players[i] == nil then continue end
		
		local sharedex = hud.comboshare[i]
		
		if sharedex == nil
			hud.comboshare[i] = {
				comboadd = 0,
				tics = 0,
				x = 0,
				y = 0,
				node = i
			}
		end
		
		
	end
	
	for k,sharedex in pairs(hud.comboshare)
		if sharedex.tics
			sharedex.tics = $-1
			
			if sharedex.comboadd > 99999
				sharedex.comboadd = 99999
			end
			
			if sharedex.tics == TR/2
				S_StartSound(nil,sfx_didgod,p)
			end
			
			if sharedex.tics == 0
				for i = 1,sharedex.comboadd
					TakisGiveCombo(p,takis,true,false,nil,true)
				end
			end
		else
			sharedex.comboadd = 0
			sharedex.x = 0
			sharedex.y = 0
			sharedex.startx = nil
			sharedex.starty = nil
		end
	end
	
	if hud.timeshit
		hud.timeshit = $-1
	end
	
	if takis.license.licenseaward
		takis.license.licenseaward = $-1
	end
	
	if takis.license.mugtime
		takis.license.mugtime = $-1
	end
	
	if (p.powers[pw_shield] ~= SH_NONE)
		if not hud.tooltips["shield"].tics
			hud.tooltips["shield"].tics = TAKIS_TOOLTIP_TIME
		else
			if hud.tooltips["shield"].tics ~= 1
				hud.tooltips["shield"].tics = $-1
			end
		end
		hud.tooltips["shield"].prolong = true
		--WTFFFFFFFF./..
		if (takis.noability & NOABIL_SHIELD)
			hud.tooltips["shield"].flags = V_HUDTRANS
		else
			hud.tooltips["shield"].flags = V_HUDTRANSHALF
		end
	else
		if hud.tooltips["shield"].tics > TR/2
		or hud.tooltips["shield"].prolong
			hud.tooltips["shield"].tics = TR/2
		else
			hud.tooltips["shield"].tics = max($-1,0)
		end
		hud.tooltips["shield"].prolong = false
	end
	
	if (p.powers[pw_carry] == CR_MINECART)
		if not hud.tooltips["minecart"].tics
			hud.tooltips["minecart"].tics = TAKIS_TOOLTIP_TIME
		else
			if hud.tooltips["minecart"].tics ~= 1
				hud.tooltips["minecart"].tics = $-1
			end
		end
		hud.tooltips["minecart"].prolong = true
	else
		if hud.tooltips["minecart"].tics > TR/2
		or hud.tooltips["minecart"].prolong
			hud.tooltips["minecart"].tics = TR/2
		else
			hud.tooltips["minecart"].tics = max($-1,0)
		end
		hud.tooltips["minecart"].prolong = false
	end

	if (takis.transfo & TRANSFO_SHOTGUN)
	and (takis.shotgunforceon == false)
		if not hud.tooltips["deshotgun"].tics
			hud.tooltips["deshotgun"].tics = TAKIS_TOOLTIP_TIME
		else
			if hud.tooltips["deshotgun"].tics ~= 1
				hud.tooltips["deshotgun"].tics = $-1
			end
		end
		hud.tooltips["deshotgun"].prolong = true
		hud.tooltips["deshotgun"].flags = takis.hammerblastdown and V_HUDTRANSHALF or V_HUDTRANS
	else
		if hud.tooltips["deshotgun"].tics > TR/2
		or hud.tooltips["deshotgun"].prolong
			hud.tooltips["deshotgun"].tics = TR/2
		else
			hud.tooltips["deshotgun"].tics = max($-1,0)
		end
		hud.tooltips["deshotgun"].prolong = false
	end

	if (takis.taunttime)
	and (takis.tauntcancel)
		if not hud.tooltips["canceltaunt"].tics
			hud.tooltips["canceltaunt"].tics = TAKIS_TOOLTIP_TIME
		else
			if hud.tooltips["canceltaunt"].tics ~= 1
				hud.tooltips["canceltaunt"].tics = $-1
			end
		end
		hud.tooltips["canceltaunt"].prolong = true
	else
		if hud.tooltips["canceltaunt"].tics > TR/2
		or hud.tooltips["canceltaunt"].prolong
			hud.tooltips["canceltaunt"].tics = TR/2
		else
			hud.tooltips["canceltaunt"].tics = max($-1,0)
		end
		hud.tooltips["canceltaunt"].prolong = false
	end
	
	if takis.io.savestatetime
		takis.io.savestatetime = $-1
		if takis.io.savestatetime == 0
			takis.io.savestate = 0
		end
	end
	
--hud stuff end
--hudstuff end

end)

--the treaqel
local function collide3(mo1,mo2,range)
	if mo1.z-(range*P_MobjFlip(mo1)) > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z+(range*P_MobjFlip(mo1)) then return false end
	return true
end
local function otherwind(me)
	local r = me.radius/FU
	local wind = P_SpawnMobj(
		me.x + (P_RandomRange(r, -r) * FRACUNIT),
		me.y + (P_RandomRange(r, -r) * FRACUNIT),
		me.z + (P_RandomKey(me.height / FRACUNIT) * FRACUNIT) - me.height/2,
		MT_THOK)
	wind.scale = me.scale
	wind.fuse = wind.tics
	wind.sprite = SPR_RAIN
	wind.renderflags = $|RF_PAPERSPRITE
	wind.angle = me.angle
	wind.spritexscale,wind.spriteyscale = me.scale,me.scale
	wind.rollangle = ANGLE_90
	wind.source = me
	wind.blendmode = AST_ADD
end

local superred = {
	--red team
	[1] = {
		[0] = SKINCOLOR_PEPPER,
		[1] = SKINCOLOR_KETCHUP,
		[2] = SKINCOLOR_RED,
		[3] = SKINCOLOR_KETCHUP,
		[4] = SKINCOLOR_GARNET,
		[5] = SKINCOLOR_RED
	},
	--blue team
	[2] = {
		[0] = SKINCOLOR_DUSK,
		[1] = SKINCOLOR_COBALT,
		[2] = SKINCOLOR_CERULEAN,
		[3] = SKINCOLOR_SAPPHIRE,
		[4] = SKINCOLOR_SKY,
		[5] = SKINCOLOR_ARCTIC
	}
}

-- thinkers for each transfo
rawset(_G, "TakisTransfoHandle", function(p,me,takis)
	--Riptire
	if (takis.transfo & TRANSFO_BALL)
		if me.state ~= S_PLAY_ROLL
		and takis.notCarried
			--BUT, if we're trying to continue slide, keep the ball
			if ((takis.justHitFloor or me.eflags & MFE_JUSTHITFLOOR
			or (me.state >= S_PLAY_STND and me.state <= S_PLAY_RUN and takis.accspeed >= 10*FU))
			and takis.c2)
			--its super fun when you can drift around
			or (p.pflags & PF_JUMPED)
			and not takis.hammerblastdown
			and me.health
				me.state = S_PLAY_ROLL
				p.pflags = $|PF_SPINNING
				takis.ballretain = 2
				takis.noability = $|NOABIL_SLIDE
				if not (p.pflags & PF_JUMPED)
					P_Thrust(me,TakisMomAngle(me),FixedMul(takis.accspeed,me.scale)/2)
				end
			else
				--detransfo otherwise
				if takis.ballretain == 0
					S_StopSoundByID(me,sfx_trnsfo)
					S_StopSoundByID(me,sfx_takst5)
					S_StartSound(me,sfx_shgnk)
					p.pflags = $ &~PF_SPINNING
					takis.transfo = $ &~TRANSFO_BALL
					p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
				end
			end
		elseif takis.notCarried
			p.pflags = $|PF_SPINNING
			takis.afterimaging = false
			takis.clutchingtime = 0
			takis.noability = $|NOABIL_SLIDE
			takis.bashspin = 0
			
			takis.spriteyscale = $ + (FU/5)
			
			if me.standingslope and me.standingslope.valid
				local goingdown = false
				local posfunc = P_MobjFlip(me) == 1 and P_FloorzAtPos or P_CeilingzAtPos
				
				if posfunc(
					me.x+me.momx,
					me.y+me.momy,
					me.z+me.momz
					,me.height
				)*P_MobjFlip(me) < GetActorZ(me,me,1)
				--im guessing this P_MobjFlip will allow goingdown to be
				--set in reverse grav
					goingdown = true
				end
				
				local newsec = R_PointInSubsector(me.x+me.momx,me.y+me.momy).sector
				if not (newsec.f_slope and P_MobjFlip(me) == 1
				or newsec.c_slope and P_MobjFlip(me) == -1)
					goingdown = false
				end
				
				if goingdown
					P_ButteredSlope(me)
					P_ButteredSlope(me)
				end
			elseif (takis.steppeddown)
			and ((takis.prevz - me.z)*takis.gravflip >= 7*me.scale)
				P_Thrust(me,TakisMomAngle(me),
					(takis.prevz - me.z)/5*takis.gravflip
				)
			end
			
			if (takis.onGround)
				if takis.accspeed >= 50*FU
					takis.glowyeffects = 2
				end
				
				if not S_SoundPlaying(me,sfx_takst5)
					S_StartSoundAtVolume(me,sfx_takst5,255*4/5)
				end
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor*10
				
				local turningang = R_PointToAngle2(0,0,p.cmd.forwardmove*FU/10,p.cmd.sidemove*FU/10)
				local braking = P_GetPlayerControlDirection(p) == 2 and (takis.accspeed >= 15*FU)
				
				--Auto already handles this for us
				if GetControlStyle(p) ~= CS_AUTOMATIC
				or braking
					turningang = 0
				end
				me.angle = $ - (turningang/40)
				
				local maxaccel = 60*FU
				if p.powers[pw_sneakers] then maxaccel = 78*FU end
				local speed = maxaccel
				
				speed = FixedMul($,max(FU - FixedDiv(takis.accspeed,maxaccel),0)) 
				speed = FixedMul($,me.scale)
				if braking
					for i = 0,1
						local angle = (TakisMomAngle(me) + ANGLE_180) + FixedAngle(P_RandomRange(-45,45)*FU+P_RandomFixed())
						TakisKart_SpawnSpark(me,angle,SKINCOLOR_ORANGE,true)
					end
					speed = -$/4
					
					if (leveltime % 4 == 0)
						S_StartSound(me,sfx_s3k67,p)
					end
					
				end
				
				p.drawangle = (GetControlStyle(p) == CS_AUTOMATIC) and (p.cmd.angleturn << 16) or me.angle
				P_Thrust(me,p.drawangle,speed/8)
				
				local adjustangle = (TakisMomAngle(me) - (p.cmd.angleturn << 16)) + ANGLE_90
				if FixedMul(takis.accspeed,cos(adjustangle))
					local newspeed = FixedMul(takis.accspeed,cos(adjustangle))
					newspeed = min(abs($),FU*2)
					if cos(adjustangle) < 0
						newspeed = -$
					end
					
					newspeed = FixedMul($,me.scale)
					P_Thrust(me,p.drawangle + ANGLE_90, newspeed)
				end
				
				local chance = P_RandomChance(FU/3)
				if takis.accspeed >= 30*FU
					chance = true
				end
				if takis.accspeed <= 20*FU
					chance = false
				end
				
				if chance
					TakisSpawnDust(me,
						p.drawangle+FixedAngle(P_RandomRange(-45,45)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
						P_RandomRange(0,-50),
						P_RandomRange(-1,2)*me.scale,
						{
							xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = P_RandomRange(0,-10)*me.scale,
							thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							momz = P_RandomRange(4,0)*P_RandomRange(3,10)*(me.scale/2),
							momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = me.scale,
							scalespread = FixedMul(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1), me.scale),
							
							fuse = 15+P_RandomRange(-5,5),
						}
					)
				end
				
				if takis.balldrift ~= 0
					if not S_SoundPlaying(me,sfx_kartdr)
						S_StartSound(me,sfx_kartdr)
					end
					if (leveltime % 6 == 0)
						S_StartSoundAtVolume(me,sfx_kartsc,255/2)
					end
					
					local sign = takis.balldrift
					local momang = TakisMomAngle(me)
					local offx = P_ReturnThrustX(nil,momang + ANGLE_90*sign,-me.radius*3/2) 
					local offy = P_ReturnThrustY(nil,momang + ANGLE_90*sign,-me.radius*3/2) 
					
					if not (takis.balldriftfx and takis.balldriftfx.valid)
						takis.balldriftfx = P_SpawnMobjFromMobj(me,
							offx,offy,
							0,
							MT_TAKIS_DRIFTSPARK
						)
						P_SetOrigin(takis.balldriftfx,
							takis.balldriftfx.x + me.momx,
							takis.balldriftfx.y + me.momy,
							takis.balldriftfx.z + me.momz
						)
					end
					local driftfx = takis.balldriftfx
					P_MoveOrigin(driftfx,
						me.x + offx + me.momx,
						me.y + offy + me.momy,
						me.z + me.momz
					)
					driftfx.angle = R_PointToAngle2(
						driftfx.x, driftfx.y,
						me.x + me.momx, me.y + me.momy
					)
					driftfx.color = p.skincolor
					
					local offx = P_ReturnThrustX(nil,momang,me.radius*3/2) 
					local offy = P_ReturnThrustY(nil,momang,me.radius*3/2) 
					P_MoveOrigin(driftfx,
						driftfx.x + offx,
						driftfx.y + offy,
						driftfx.z
					)
					
					local inc = FixedDiv(takis.accspeed,maxaccel)
					driftfx.spritexscale = inc
					driftfx.spriteyscale = inc
					
					/*
					local olda = driftfx.angle
					driftfx.angle = momang + ANGLE_90*sign
					for i = 1,P_RandomRange(2,4)
						local spark = TakisKart_SpawnSpark(me,
							driftfx.angle+FixedAngle(P_RandomRange(-25,25)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
							p.skincolor,
							true
						)
						spark.tracer = me
					end
					driftfx.angle = olda
					*/
				else
					S_StopSoundByID(me,sfx_kartdr)
					if (takis.balldriftfx and takis.balldriftfx.valid)
						P_RemoveMobj(takis.balldriftfx)
						takis.balldriftfx = nil
					end
				end
			else
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
				S_StopSoundByID(me,sfx_takst5)
				S_StopSoundByID(me,sfx_kartdr)
				if (takis.balldriftfx and takis.balldriftfx.valid)
					P_RemoveMobj(takis.balldriftfx)
					takis.balldriftfx = nil
				end
				
				--a bit of air drag when jumping
				local cap = 55*FU
				if takis.accspeed > cap
				and (p.pflags & PF_JUMPED)
					local newspeed = takis.accspeed - FixedDiv(takis.accspeed - cap, 32*FU)
					newspeed = FixedMul($,me.scale)
					me.momx = P_ReturnThrustX(nil,TakisMomAngle(me),newspeed)
					me.momy = P_ReturnThrustY(nil,TakisMomAngle(me),newspeed)
					
					--signify drag
					TakisDoWindLines(me,-takis.rmomz,SKINCOLOR_WHITE,TakisMomAngle(me) + ANGLE_180)
				end
				
			end
			
		else
			takis.transfo = $ &~TRANSFO_BALL
			S_StopSoundByID(me,sfx_trnsfo)
			S_StopSoundByID(me,sfx_takst5)
			S_StopSoundByID(me,sfx_kartdr)
			S_StartSound(me,sfx_shgnk)
			p.pflags = $ &~PF_SPINNING
			takis.transfo = $ &~TRANSFO_BALL
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
			TakisResetState(p)
		end
		if takis.ballretain then takis.ballretain = $-1 end
	else
		S_StopSoundByID(me,sfx_takst5)
		S_StopSoundByID(me,sfx_kartdr)
		takis.ballretain = 0
	end
	
	if (takis.transfo & TRANSFO_PANCAKE)
		if takis.pancaketime
			p.pflags = $|PF_INVIS
			if (me.momz*takis.gravflip <= 0)
			and not takis.onGround
			and (takis.jump)
			and not takis.hammerblastdown
				me.momz = $*21/23
				
				local tic = leveltime%24
				local tic2 = leveltime%48
				takis.tiltdo = true
				takis.tiltvalue = $+FixedAngle(FixedMul(30*FU,
					(FU/24)*tic*(tic2 >= 23 and 1 or -1)
				))
				
				if leveltime & 1
					local radius = skins[p.skin].radius*2
					
					TakisSpawnDust(me,
						0,
						0,
						GetActorZ(me,me,4),
						{
							xspread = P_RandomRange(-(radius / me.scale),radius / me.scale)*me.scale,
							yspread = P_RandomRange(-(radius / me.scale),radius / me.scale)*me.scale,
							zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = 0,
							thrustspread = 0,
							
							momz = 0,
							momzspread = 0,
							
							scale = me.scale/2,
							scalespread = P_RandomFixed(),
							
							fuse = 20,
						}
					)
				end
				
			end
			takis.pancaketime = $-1
			
			--if we'd be crushed normally, refill timer
			if me.ceilingz - me.floorz < P_GetPlayerSpinHeight(p)
				takis.pancaketime = TAKIS_MAX_TRANSFOTIME
			end
			
			p.jumpfactor = skins[TAKIS_SKIN].jumpfactor*3/2
			
			local thok = P_SpawnMobjFromMobj(me,0,0,0,MT_THOK)
			thok.radius = me.radius
			thok.height = P_GetPlayerHeight(p)
			thok.fuse = 1
			thok.flags2 = $|MF2_DONTDRAW
			thok.parent = me
			
			local fakerange = 250*FU
			local range = thok.radius*2
			searchBlockmap("objects", function(ref, found)
				if ref == me then return end
				if R_PointToDist2(found.x, found.y, ref.x, ref.y) > range
					return
				end
				if not L_ZCollide(found,ref) then return end
				if not (found.health) then return end
				
				--if found.takis_givecombotime
				if found.takis_ringtype
				and not found.isFUCKINGdeadmaybe
					local coolpos = {
						found.x,
						found.y,
						found.z
					}
					
					P_SetOrigin(found, me.x,me.y,me.z)
					P_SetOrigin(found, unpack(coolpos))
					found.isFUCKINGdeadmaybe = true
					
				end
				
			end, 
			thok,
			thok.x-fakerange, thok.x+fakerange,
			thok.y-fakerange, thok.y+fakerange)
	
			/*
			local maxspeed = p.normalspeed*3/4
			local oldspeed = takis.prevspeed
			local speed = R_PointToDist2(me.momx - p.cmomx,me.momy - p.cmomy,0,0)
			if speed > maxspeed
			and not (p.pflags & PF_SPINNING)
			and takis.onground
			and (me.friction ~= FU
			and not takis.afterimaging)
				local tmomx,tmomy
				if oldspeed > maxspeed
					if (speed > oldspeed)
						tmomx = FixedMul(FixedDiv(me.momx - p.cmomx, speed), oldspeed)
						tmomy = FixedMul(FixedDiv(me.momy - p.cmomy, speed), oldspeed)
						me.momx = tmomx
						me.momy = tmomy
					end
				else
					tmomx = FixedMul(FixedDiv(me.momx - p.cmomx, speed), maxspeed)
					tmomy = FixedMul(FixedDiv(me.momy - p.cmomy, speed), maxspeed)
					me.momx = tmomx
					me.momy = tmomy
				end
			end
			*/
			
		else
			p.pflags = $ &~PF_INVIS
			S_StopSoundByID(me,sfx_trnsfo)
			S_StartSound(me,sfx_shgnk)
			takis.transfo = $ &~TRANSFO_PANCAKE
			p.jumpfactor = skins[TAKIS_SKIN].jumpfactor
		end
	else
		if takis.pancaketime
			takis.pancaketime = 0
			p.pflags = $ &~PF_INVIS
		end
	end
	--LOST BITS!!
	if (takis.transfo & TRANSFO_TORNADO)
		if leveltime then P_KillMobj(me,me,me) end
		
		local sfx_nado = sfx_tknado
		local sfx_nado2 = sfx_tkfndo
		
		if (takis.nadocount > 0)
			takis.noability = $|NOABIL_ALL
			takis.thokked = true
			takis.nadotime = $+2
			
			takis.nadoang = $+FixedAngle(20*FU)
			local nadodist = 30
			local lastspin = takis.nadouse
			
			local speed = 30*me.scale
			
			nadodist = $*2
			local waveforce = FU*5
			local ay = FixedMul(waveforce,sin(takis.nadotime*2*ANG2))
			local thok = P_SpawnMobjFromMobj(me,
				me.momx+nadodist*cos(me.angle+takis.nadoang),
				me.momy+nadodist*sin(me.angle+takis.nadoang),
				2*me.scale+FixedMul(ay,me.scale),
				MT_THOK
			)
			thok.angle = me.angle+takis.nadoang+ANGLE_90
			thok.renderflags = $|RF_PAPERSPRITE
			thok.height,thok.radius = me.height,me.radius
			thok.tics = 3
			thok.flags2 = $|MF2_DONTDRAW
			nadodist = $/2
			
			otherwind(thok)
			otherwind(thok)
			
			
			if (takis.use)
			or (not takis.onGround and takis.accspeed >= 45*FU)
				takis.nadoang = $+FixedAngle(10*FU)
				takis.nadotime = $+3
				otherwind(thok)
				otherwind(thok)
				
				speed = 50*me.scale
				if (takis.use == 1)
					S_StopSoundByID(me,sfx_nado)
				end
				--pull stuff in!
				local px = me.x+(me.momx)
				local py = me.y+(me.momy)
				local br = 350*me.scale
				local rbr = br
				
				searchBlockmap("objects", function(me, found)
					if not (found and found.valid) then return end
					if not (found.health) then return end
						local zrange = 100
						if (found.type ~= MT_EGGMAN_BOX)
						and (collide3(me,found,zrange*me.scale))
						--the real range
						and (FixedHypot(found.x-me.x,found.y-me.y) <= rbr)
							if ((found.flags & (MF_ENEMY|MF_BOSS))
							or (found.takis_flingme))
							or (found.type == MT_PLAYER)
								local source = found
								local enemy = thok
								local zdist = enemy.z - source.z
								local enx = enemy.x+(nadodist*cos(me.angle+takis.nadoang))
								local eny = enemy.y+(nadodist*sin(me.angle+takis.nadoang))
								if P_MobjFlip(source) == -1
									zdist = (enemy.z+enemy.height)-(source.z+source.height)
								end
								local dist = FixedHypot(FixedHypot(enx - source.x,eny - source.y),zdist)
								local speed = FixedMul(FixedDiv(dist,rbr),rbr)/15
								
								local cando = true
								if (source.player)
									local p2 = source.player
									if (P_PlayerInPain(p2))
									or (p2.powers[pw_flashing])
									or not (CanPlayerHurtPlayer(p,p2))
										cando = false
									end
								end
								if cando
									source.momx = $+FixedMul(FixedDiv(enx - source.x,dist),FixedMul(speed,source.scale))
									source.momy = $+FixedMul(FixedDiv(eny - source.y,dist),FixedMul(speed,source.scale))
									source.momz = $+FixedMul(FixedDiv(zdist,dist),FixedMul(speed,source.scale))
									
									if (source.player)
										source.state = S_PLAY_PAIN
										if (dist <= nadodist*FU*3)
											--?? please??
											TakisAddHurtMsg(source.player,p,HURTMSG_NADO)
											TakisAddHurtMsg(source.player,p,HURTMSG_NADO)
											P_DamageMobj(source,enemy,enemy)
											P_Thrust(source,R_PointToAngle2(
												source.x,source.y, enx,eny
												),
												-26*source.scale
											)
										end
									end
								end
							end
						end
				end, me, px-br, px+br, py-br, py+br)	
				
			end
			
			if lastspin
			and takis.use == 0
				S_StopSoundByID(me,sfx_nado2)
			end
			
			if not (takis.onGround)
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor/4
			else
				p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
			end
			
			p.normalspeed = FixedDiv(speed,me.scale)
			P_MovePlayer(p)
			
			if not (takis.use)
				if not S_SoundPlaying(me,sfx_nado)
					S_StartSound(me,sfx_nado)
				end
			else
				if not S_SoundPlaying(me,sfx_nado2)
					S_StartSound(me,sfx_nado2)
				end
			end
			
			local state = S_PLAY_TAKIS_TORNADO
			if (p.playerstate == PST_LIVE)
				if (me.state ~= state)
					me.state = state
				else
					p.powers[pw_strong] = $|STR_SPIKE|STR_WALL
				end
			end
			
			takis.clutchingtime = 0
			takis.dustspawnwait = $+FixedDiv(takis.accspeed,50*FU)
			while takis.dustspawnwait > FU
				takis.dustspawnwait = $-FU
				--xmom code
				if (takis.onGround)
				and not (leveltime % 10)
				and (takis.accspeed >= 45*FU)
					local d1 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle + ANGLE_45), -20*sin(p.drawangle + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
					local d2 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle - ANGLE_45), -20*sin(p.drawangle - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
					--d1.scale = $*2/3
					d1.destscale = FU/10
					d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5

					--d2.scale = $*2/3
					d2.destscale = FU/10
					d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
				
					d1.momx,d1.momy = me.momx*3/4,me.momy*3/4
					d2.momx,d2.momy = d1.momx,d1.momy
					d1.momz,d2.momz = takis.rmomz,takis.rmomz
				end
			end
			
			local notransfo = TRANSFO_BALL
			if (takis.transfo & notransfo)
				takis.transfo = $ &~notransfo
			end
			
			if takis.nadotic > 0 then takis.nadotic = $-1 end
		else
			S_StopSoundByID(me,sfx_nado)
			S_StopSoundByID(me,sfx_nado2)
			takis.nadoang = 0
			takis.nadotime = 0
			
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
			p.normalspeed = skins[TAKIS_SKIN].normalspeed
			
			if (takis.nadocrash)
				takis.stasistic = 2
				takis.noability = NOABIL_ALL
				local state = S_PLAY_DEAD
				if (me.state ~= state)
					me.state = state
				end
				
				if takis.nadocrash == 1
					S_StartAntonOw(me)
				end
				takis.nadocrash = $-1
			else
				P_DoJump(p,true)
				me.momz = $/10
				S_StartSound(me,sfx_shgnk)
				takis.transfo = $ &~TRANSFO_TORNADO		
			end
		end
		
	end
	if (takis.transfo & TRANSFO_FIREASS)
		if takis.inWater
			takis.transfo = $ &~TRANSFO_FIREASS
			S_StartSound(me,sfx_shgnk)
			me.color = p.skincolor
			me.colorized = false
			return
		end
		
		if (takis.transfo & TRANSFO_METAL)
		and (takis.metaltime > takis.fireasstime - 3)
			takis.transfo = $ &~TRANSFO_FIREASS
			P_RestoreMusic(p)
		end
		
		local mintime = 3*TR
		local blinktime = TR
		
		if takis.fireregen
			takis.fireregen = $-1
		else
			if takis.fireasstime == mintime
				S_StartSound(me,sfx_steam2)
			end
		end
		
		takis.fireasscolor = superred[G_GametypeHasTeams() and p.ctfteam or 1][P_RandomRange(0,5)]
		if takis.fireasstime > mintime
			local flame = P_SpawnMobjFromMobj(me,
				P_RandomRange(-me.radius/me.scale,me.radius/me.scale)*me.scale+P_RandomFixed(),
				P_RandomRange(-me.radius/me.scale,me.radius/me.scale)*me.scale+P_RandomFixed(),
				P_RandomRange(-me.height/me.scale,me.height/me.scale)*me.scale+P_RandomFixed(),
				MT_FLAMEPARTICLE
			)
			P_SetObjectMomZ(flame,P_RandomRange(2,4)*me.scale+P_RandomFixed())
			flame.colorized = true
			flame.color = takis.fireasscolor
		end
		
		if (takis.fire == 1 or takis.firenormal == 1)
		and takis.fireballtime == 0
			local fb = P_SpawnPlayerMissile(me,MT_FIREBALL)
			if fb and fb.valid
				fb.fuse = 3*TR
				S_StartSound(me,sfx_mario7)
				takis.fireballtime = TR
				p.weapondelay = max($,TR)
				p.pflags = $|PF_ATTACKDOWN
			end
		end
		
		if takis.fireasstime > mintime
			me.color = takis.fireasscolor
			me.colorized = true
		else
			if takis.fireasstime > blinktime
				if not (takis.fireasstime/2 % 2)
					me.color = p.skincolor
					me.colorized = false
				else
					me.color = takis.fireasscolor
					me.colorized = true
				end
			else
				if not (takis.fireasstime % 2)
					me.color = p.skincolor
					me.colorized = false
				else
					me.color = takis.fireasscolor
					me.colorized = true
				end
			end
		end
		
		if takis.fireasstime <= 0
			takis.transfo = $ &~TRANSFO_FIREASS
			S_StartSound(me,sfx_shgnk)
			me.color = p.skincolor
			me.colorized = false
		end
		
		if not takis.fireregen
			takis.fireasstime = $-1
		end	
	else
		if takis.fireasstime
			me.color = p.skincolor
			me.colorized = false
			takis.fireasstime = 0
		end
	end
	if (takis.transfo & TRANSFO_SHOTGUN)
		local gun = takis.shotgun
		if G_RingSlingerGametype()
			p.weapondelay = max(5,$)
		end
		
		if not (takis.shotgun and takis.shotgun.valid)
		and not (takis.c3)
		and not (me.flags & (MF_NOCLIP|MF_NOCLIPHEIGHT))
			local x = cos(p.drawangle-ANGLE_90)
			local y = sin(p.drawangle-ANGLE_90)
			
			takis.shotgun = P_SpawnMobjFromMobj(me,16*x,16*y,me.height/2,MT_TAKIS_SHOTGUN)
			takis.shotgun.target = me
			takis.shotgun.angle = p.drawangle
			print("\x83TAKIS:\x80 "..p.name..": Spawned new shotgun")
		end
		
		if not takis.shotgunned
			takis.transfo = $ &~TRANSFO_SHOTGUN
		end
	else
		local gun = takis.shotgun
		if (gun and gun.valid)
		and (gun.health)
			P_RemoveMobj(gun)
			takis.shotgun = nil
		end
		takis.shotgunshots = 0
	end
	
	if (takis.transfo & TRANSFO_METAL)
		if (takis.transfo & TRANSFO_FIREASS)
		and (takis.fireasstime > takis.metaltime)
			takis.transfo = $ &~TRANSFO_METAL
		end
		
		local grav = P_GetMobjGravity(me)*3/2
		if takis.inWater
			grav = $*2
		end
		if (me.momz*takis.gravflip <= -2*me.scale)
			me.momz = $+(grav)
		end
		me.color = SKINCOLOR_JET
		me.colorized = true
		p.powers[pw_strong] = $|STR_SPIKE
		p.powers[pw_underwater] = 0
		p.powers[pw_spacetime] = 0
		takis.metaltime = $-1
		--takis.noability = $|NOABIL_THOK
		TakisBreakAndBust(p,me)
		
		if P_RandomChance(FU/2)
			local wind = P_SpawnMobj(
				me.x + P_RandomRange(-18,18)*me.scale,
				me.y + P_RandomRange(-18,18)*me.scale,
				me.z + (me.height/2) + P_RandomRange(-20,20)*me.scale+me.momz,
				MT_BOXSPARKLE
			)
			wind.momx = me.momx
			wind.momy = me.momy
			wind.momz = me.momz
		end
		
		if takis.justHitFloor
		and (takis.lastmomz*takis.gravflip <= -18*me.scale)
		and not takis.hammerblastdown
			local radius = abs(takis.lastmomz)
			
			for i = 0, 16
				local fa = (i*ANGLE_22h)
				local spark = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
				spark.momx = P_ReturnThrustX(nil,fa,radius) --FixedMul(sin(fa),radius)
				spark.momy = P_ReturnThrustY(nil,fa,radius) --FixedMul(cos(fa),radius)
				local spark2 = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
				spark2.momx = P_ReturnThrustX(nil,fa,radius/20) --FixedMul(sin(fa),radius/20)
				spark2.momy = P_ReturnThrustY(nil,fa,radius/20) --FixedMul(cos(fa),radius/20)
			end
			DoQuake(p,FU*37,20)
			
			--KILL!
			local rad = takis.lastmomz
			local px = me.x
			local py = me.y
			local br = abs(rad*10)
			searchBlockmap("objects", function(me, found)
				if not (found and found.valid) then return end
				if not (found.health) then return end
				if found.alreadykilledthis then return end
				
				if CanFlingThing(found)
					if not (found.flags & MF_BOSS)
						found.alreadykilledthis = true
					end
					local rag = SpawnRagThing(found,me)
					if (rag and rag.valid)
						S_StartSound(found,sfx_sdmkil)
					end
				elseif (found.type == MT_PLAYER)
					if CanPlayerHurtPlayer(p,found.player)
						TakisAddHurtMsg(found.player,p,HURTMSG_HAMMERQUAKE)
						P_DamageMobj(found,me,me,abs(me.momz/FU/4))
					end
					DoQuake(found.player,
						FixedMul(
							75*FU, FixedDiv( br-FixedHypot(found.x-me.x,found.y-me.y),br )
						),
						15
					)
				elseif (SPIKE_LIST[found.type] == true)
					found.alreadykilledthis = true
					P_KillMobj(found,me,me)
				end
			end, me, px-br, px+br, py-br, py+br)		
		end
		
		local mintime = 3*TR
		local blinktime = TR
		
		if takis.metaltime > mintime
			me.color = SKINCOLOR_JET
			me.colorized = true
		else
			if takis.metaltime > blinktime
				if not (takis.metaltime/2 % 2)
					me.color = p.skincolor
					me.colorized = false
				else
					me.color = SKINCOLOR_JET
					me.colorized = true
				end
			else
				if not (takis.metaltime % 2)
					me.color = p.skincolor
					me.colorized = false
				else
					me.color = SKINCOLOR_JET
					me.colorized = true
				end
			end
		end
		
		if takis.metaltime <= 0
			takis.transfo = $ &~TRANSFO_METAL
			S_StartSound(me,sfx_shgnk)
			S_StartSound(me,sfx_mario8)
			me.color = p.skincolor
			me.colorized = false
			P_RestoreMusic(p)
		end
		
	else
		if takis.metaltime
			me.colorized = false
			me.color = p.skincolor
			P_RestoreMusic(p)
			S_StartSound(me,sfx_mario8)
		end
		takis.metaltime = 0
	end

	-- this should be the last since its the shortest
	if (takis.transfo & TRANSFO_ELEC)
		if takis.electime
			takis.inPain = true
			takis.inFakePain = true
			
			if (leveltime % 3) == 0
				me.color = SKINCOLOR_SUPERGOLD1
			else
				me.color = SKINCOLOR_JET
			end
			
			local rad = FixedDiv(me.radius,me.scale)/FU
			local hei = FixedDiv(me.height,me.scale)/FU
			local x = P_RandomRange(-rad,rad)*FU
			local y = P_RandomRange(-rad,rad)*FU
			local z = P_RandomRange(0,hei)*FU
			local spark = P_SpawnMobjFromMobj(me,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
			spark.tracer = me
			spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
			spark.blendmode = AST_ADD
			spark.color = P_RandomRange(SKINCOLOR_SUPERGOLD1,SKINCOLOR_SUPERGOLD5)
			spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))

			me.colorized = true
			
			if (me.state ~= S_PLAY_DEAD)
				me.state = S_PLAY_DEAD
				me.frame = A
				me.sprite2 = SPR2_FASS
			end
			
			--so the instathrust doesnt move us by an inch
			p.cmd.forwardmove = max($,10)
			
			if (takis.justHitFloor)
			and not P_CheckDeathPitCollide(me)
				local range = 235
				L_ZLaunch(me,4*FU)
				p.drawangle = $+(FixedAngle(
					P_RandomRange(-range,range)*FU+P_RandomFixed()
					)
				)
				P_InstaThrust(me,p.drawangle,14*me.scale)
				P_MovePlayer(p)
				me.state = S_PLAY_DEAD
				me.frame = A
				me.sprite2 = SPR2_FASS
				
				local bam1,bam2 = SpawnBam(me,true)
				local bams = {bam1,bam2}
				for i = 1,2
					--if i == 2 or i == 4 then continue end
					local color = P_RandomRange(SKINCOLOR_SUPERGOLD1,SKINCOLOR_SUPERGOLD5)
					bams[i].colorized = true
					--bams[i+1].colorized = true
					bams[i].color = color
					--bams[i+1].color = color
					bams[i].scale = $/2
					--bams[i+1].scale = $/2
					bams[i].destscale = $/2
					--bams[i+1].destscale = $/2
					
				end
				
			end
			
			if not takis.onGround
				me.momz = $-(me.scale/2*takis.gravflip)
			end
			
			p.powers[pw_nocontrol] = 2
			p.pflags = $|PF_FULLSTASIS
			takis.electime = $-1
		else
			me.color = p.skincolor
			me.colorized = false
			me.state = S_PLAY_WALK
			P_MovePlayer(p)
			takis.transfo = $ &~TRANSFO_ELEC
		end
	end
end)

--checks to turn into a transfo
rawset(_G, "TakisTransfo", function(p,me,takis)
	
	--ball
	do
		if (me.standingslope)
			if ((takis.prevz - me.z)*takis.gravflip >= 7*me.scale)
			and (me.state == S_PLAY_TAKIS_SLIDE)
			and (p.pflags & PF_SPINNING)
			and not (takis.transfo & TRANSFO_BALL)
			and (takis.c2 > 4)
			and (takis.accspeed >= 30*FU)
				S_StartSound(me,sfx_trnsfo)
				me.state = S_PLAY_ROLL
				takis.transfo = $|TRANSFO_BALL
				TakisAwardAchievement(p,ACHIEVEMENT_BOWLINGBALL)
			end
		--you can do these on stairs too cause its kinda annoying
		--only having these on slopes
		elseif (takis.steppeddown)
		and ((takis.prevz - me.z)*takis.gravflip >= 7*me.scale)
		and (me.state == S_PLAY_TAKIS_SLIDE)
		and (p.pflags & PF_SPINNING)
		and not (takis.transfo & TRANSFO_BALL)
		and (takis.c2 > 4)
		and (takis.accspeed >= 30*FU)
			S_StartSound(me,sfx_trnsfo)
			me.state = S_PLAY_ROLL
			takis.transfo = $|TRANSFO_BALL
			TakisAwardAchievement(p,ACHIEVEMENT_BOWLINGBALL)
		end
	end
	
	TakisTransfoHandle(p,me,takis)
end)

local function SpeckiStuff(p)
	local me = p.realmo
	if me.skin ~= TAKIS_SKIN then return end
	
	if p.specki_gimmicks
		p.specki_gimmicks.mpspecials = true
	end
end

--hook system?
rawset(_G, "TakisDoNoabil", function(p,me,takis)
	if takis.inSRBZ
		takis.noability = (NOABIL_ALL|NOABIL_AFTERIMAGE|NOABIL_TRANSFO) &~(NOABIL_SHOTGUN|NOABIL_MOBILETAUNT)
		if not ZE2.round_active
			takis.noability = $|NOABIL_MOBILETAUNT
		end
	end
	if (takis.wavedashcapable)
		takis.noability = $|NOABIL_HAMMER
	end
	if (p.gotflag)
		takis.noability = $|NOABIL_HAMMER|NOABIL_AFTERIMAGE
	end
	
	local insuperspeed = (takis.hammerblastdown and (me.momz*takis.gravflip <= -60*me.scale))
	if (p.pflags & PF_SPINNING)
	or (takis.accspeed < 30*FU and takis.clutchingtime > 10)
	or (p.powers[pw_carry] and p.powers[pw_carry] ~= CR_ROLLOUT)
	or (p.playerstate ~= PST_LIVE or not me.health)
	or (takis.hammerblastdown and (me.momz*takis.gravflip > -60*me.scale))
		takis.noability = $|NOABIL_AFTERIMAGE
	end
	if insuperspeed then takis.noability = $ &~NOABIL_AFTERIMAGE end
	if p.powers[pw_carry] == CR_NIGHTSMODE
		takis.noability = $|NOABIL_SLIDE &~NOABIL_AFTERIMAGE
	end
	
	if takis.ropeletgo
		takis.noability = $|NOABIL_HAMMER
		takis.ropeletgo = $-1
	end
	
	if takis.pitanim
	or p.inkart
	or (gametyperules & GTR_RACE and p.realtime == 0)
	or ((CR_GRINDRAIL)
	and p.powers[pw_carry] == CR_GRINDRAIL)
		takis.noability = $|NOABIL_ALL|NOABIL_THOK|NOABIL_TRANSFO
	end
	
	if p.oldc_infoscreen
		takis.noability = $|NOABIL_CLUTCH
	end
	
	if gametype == GT_MURDERMYSTERY
	or takis.inSaxaMM
		takis.noability = $|NOABIL_ALL|NOABIL_THOK|NOABIL_TRANSFO &~(NOABIL_SHOTGUN|NOABIL_MOBILETAUNT)
	end
	
	if not p.spectator and G_TagGametype()
		local hidetime = CV_FindVar("hidetime").value*TR
		
		if (leveltime < hidetime)
			if (p.pflags & PF_TAGIT)
				takis.noability = $|NOABIL_ALL|NOABIL_THOK
			end
		elseif (gametyperules & GTR_HIDEFROZEN)
			if not (p.pflags & PF_TAGIT)
				takis.noability = $|NOABIL_ALL|NOABIL_THOK
			end
		end
	end
	
	if p.spectator
	or (me.boat and me.boat.valid)
	or (p.isjettysyn)
		takis.noability = $|NOABIL_ALL|NOABIL_THOK
		takis.transfo = 0
		TakisResetHammerTime(p)
	end
	
	if takis.inBattle
		takis.noability = $|NOABIL_TRANSFO
	end
	
	/*
	if takis.transfo & TRANSFO_METAL
		takis.noability = $|NOABIL_THOK
	end
	*/
end)

local function SpawnPoof(me,mobj)
	for i = 0,P_RandomRange(10,15)
		local dust = TakisSpawnDust(mobj,
			FixedAngle( P_RandomRange(-337,337)*FRACUNIT ),
			10,
			P_RandomRange(0,(mobj.height/mobj.scale)/2)*mobj.scale,
			{
				xspread = 0,
				yspread = 0,
				zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				thrust = 0,
				thrustspread = 0,
				
				momz = P_RandomRange(10,-5)*mobj.scale,
				momzspread = 0,
				
				scale = mobj.scale/2,
				scalespread = P_RandomFixed(),
				
				fuse = 20,
			}
		)
		dust.tracer = me
	end
end

rawset(_G, "TakisDoShorts", function(p,me,takis)
	
	if (takis.transfo & TRANSFO_SHOTGUN)
		p.drawangle = me.angle
	end
	
	local mm = gametype == GT_MURDERMYSTERY
	local role = p.role or 0
	local wd = p.weapondelay
	if mm then wd = p.mmweapondelay end
	if takis.inSRBZ
		local itemtime = 0
		local slot = ZE2:FetchInventorySlot(p)
		if slot
			itemtime = slot.firerate_left or 0
		end
		local weapondelay = max(p["ze2_info"].weapondelay or 0,itemtime)
		wd = max(weapondelay,p["ze2_info"].reload)
	end
	
	if not (wd)
		takis.currentweapon = p.currentweapon
		if p.currentweapon == 0
			if p.rings == 0
				takis.currentweapon = -1
			end
			if p.powers[pw_infinityring]
				takis.currentweapon = 7
			end
		end
		
		if (p.powers[pw_shield] & SH_FIREFLOWER)
		or (takis.transfo & TRANSFO_FIREASS)
			takis.currentweapon = 8
		end
		
		if takis.inSRBZ
		and (ZE2)
			if ZE2:FetchInventorySlot(p)
				local iteminfo = ZE2:FetchInventorySlot(p)
				if iteminfo.displayname
					local wname = string.lower(iteminfo.displayname)
					--sigma
					if wname == "automatic ring"
						takis.currentweapon = 1
					elseif wname == "bounce ring"
						takis.currentweapon = 2
					elseif wname == "explosion ring"
						takis.currentweapon = 5
					elseif wname == "rail ring"
						takis.currentweapon = 6
					elseif wname == "red ring"
						takis.currentweapon = 0
					elseif wname == "scatter ring"
						takis.currentweapon = 3
					elseif wname == "infinity ring"
						takis.currentweapon = 7
					elseif wname == "grenade"
						takis.currentweapon = 4
					--ze2 weapons
					elseif wname == "milk"
						takis.currentweapon = 9
					elseif wname == "energy drink"
						takis.currentweapon = 10
					elseif wname == "apple"
						takis.currentweapon = 11
					elseif wname == "gfzsphere"
						takis.currentweapon = 12
					elseif wname == "blue spring"
						takis.currentweapon = 13
					elseif wname == "wood fence"
						takis.currentweapon = 14
					elseif wname == "w's mirror"
						takis.currentweapon = 15
					elseif wname == "landmine"
						takis.currentweapon = 16

					else
						takis.currentweapon = -1
					end
				end
				if p["ze2_info"].reload
				or (iteminfo.ammo ~= nil and iteminfo.ammo == 0)
					takis.currentweapon = -1
				end
				
			end
		end
		
	end
	
	if takis.weapondelaytics
		takis.weapondelaytics = $+1
	end
	if (wd)
		if not takis.weapondelaytics
		and (takis.inSRBZ and p.cmd.buttons & BT_ATTACK or (p.pflags & PF_ATTACKDOWN) or p["ze2_info"] and p["ze2_info"].reload)
			takis.weapondelaytics = 1
		end
	else
		takis.weapondelaytics = 0
	end
	
	TakisHUDStuff(p)
	
	if takis.ticsforpain > 0
		if me.state ~= S_PLAY_PAIN
			me.state = S_PLAY_PAIN
		end
		takis.ticsforpain = $-1
	end
	
	--no more spinning while jumping
	if p.pflags & PF_JUMPED
		p.pflags = $ &~PF_SPINNING
	end

	--clutch stuff
	if takis.clutchtime > 0
		takis.clutchtime = $-1
	elseif takis.clutchingtime == 0
		takis.clutchcombo = 0
	end
	
	if me.eflags & MFE_SPRUNG
		takis.dived = false
		takis.thokked = false
		takis.inFakePain = false
	end
	
	if not (p.pflags & PF_SPINNING)
	or not (takis.transfo & TRANSFO_TORNADO)
		if (p.thrustfactor ~= skins[TAKIS_SKIN].thrustfactor)
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
		end
	end
	
	TakisTransfo(p,me,takis)
	
	--Doing this in a zoomtube in TP's liftoff gauntry would
	--gaurantee a crash, so dont do this
	if (takis.notCarried)
		local t = P_LookForEnemies(p,true,false)
		--ive turned this into a lightspeed attack HELP I CANT STOP IT
		if (p.powers[pw_shield]&SH_NOSTACK) == SH_ATTRACT
		and (p.homing)
		and (takis.attracttarg and takis.attracttarg.valid and takis.attracttarg.health)
		and (takis.attracttarg == t)
			local t = takis.attracttarg
			me.angle = R_PointToAngle2(me.x,me.y,t.x,t.y)
			P_HomingAttack(me,t)
			if (me.state ~= S_PLAY_ROLL)
			or not (t.health)
				p.homing = 0
			end
		end
		
		takis.attracttarg = nil
		if (p.powers[pw_shield]&SH_NOSTACK) == SH_ATTRACT
		and t and t.valid
		and not (me.state >= 59 and me.state <= 64)
		and not (takis.noability & NOABIL_SHIELD)
			takis.attracttarg = t
			P_SpawnLockOn(p, t, S_LOCKON2)
		else
			takis.attracttarg = nil
		end
	end
	
	if takis.accspeed <= FU*9
		takis.clutchtime = 0
		takis.clutchcombo = 0
		takis.clutchingtime = 0
	end
	
	if (p.pflags & PF_SPINNING)
		if takis.slidetime
			takis.slidetime = $+1
		end
	else
		takis.slidetime = 0
	end
	
	--cancel slide when slow
	if (p.pflags & PF_SPINNING)
	and takis.accspeed <= 24*FU
	and takis.slidetime >= TR
	--try to sustain our slide if we're holding c2
	and not (takis.c2)
		p.pflags = $ &~PF_SPINNING
		if takis.accspeed >= p.runspeed
			me.state = S_PLAY_RUN
		else
			me.state = S_PLAY_WALK
		end
	end

	if takis.stasistic
		p.pflags = $|PF_FULLSTASIS
		takis.stasistic = $-1
	end
	
	if takis.clutchcombotime > 0
		if takis.clutchcombotime == 1
			takis.clutchcombo = 0
		end
		takis.clutchcombotime = $-1
	end
	
	if takis.clutchingtime < 0
		takis.clutchingtime = 0
	end
	
	if takis.combo.outrotics
		takis.combo.outrotics = $-1
		takis.HUD.combo.momy = $-(FU/2)
		takis.HUD.combo.y = $-takis.HUD.combo.momy
		takis.HUD.combo.x = $+takis.HUD.combo.momx
	else
		if not takis.combo.outrotointro
			if (takis.HUD.combo.y ~= takis.HUD.combo.basey)
				takis.HUD.combo.y = takis.HUD.combo.basey
				takis.HUD.combo.momy = 0
			end
			if (takis.HUD.combo.x ~= takis.HUD.combo.basex)
				takis.HUD.combo.x = takis.HUD.combo.basex
				takis.HUD.combo.momx = 0
			end
		else
			if (takis.HUD.combo.y ~= takis.HUD.combo.basey)
				takis.HUD.combo.y = takis.HUD.combo.basey
				takis.HUD.combo.momy = 0
			end
			if (takis.HUD.combo.x ~= takis.HUD.combo.basex)
				takis.HUD.combo.x = takis.HUD.combo.basex
				takis.HUD.combo.momx = 0
			end
			takis.combo.outrotointro = $*4/5
			takis.HUD.combo.y = $-takis.combo.outrotointro
		end
	end
	
	if (p.powers[pw_sneakers] > 0)
	and not (HAPPY_HOUR.gameover and HAPPY_HOUR.othergt)
	and not (p.spectator)
	and (me.health)
		local rad = FixedDiv(me.radius,me.scale)/FU
		local hei = FixedDiv(me.height,me.scale)/FU
		local x = P_RandomRange(-rad,rad)*FU
		local y = P_RandomRange(-rad,rad)*FU
		local z = P_RandomRange(0,hei)*FU
		local spark = P_SpawnMobjFromMobj(me,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
		spark.tracer = me
		spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
		spark.blendmode = AST_ADD
		spark.color = me.color
		spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))
	end
	
	/*
	--respawning by default should already do this
	if p.playerstate == PST_REBORN
		if me.rollangle then me.rollangle = 0 end
	end
	*/
	
	local lastspeed = takis.accspeed
	takis.accspeed = abs(FixedHypot(FixedHypot(me.momx,me.momy),me.momz))
	
	local spd = 6*skins[me.skin].runspeed/5
	if (p.powers[pw_carry] == CR_NIGHTSMODE)
		spd = 23*FU
	else
		takis.accspeed = FixedDiv($,me.scale)
	end
	
	local windcolor = nil
	if takis.forcerakis
		windcolor = SKINCOLOR_PEPPER
	end
	if (CR_GRINDRAIL)
	and p.powers[pw_carry] == CR_GRINDRAIL
		me.momx,me.momy = takis.railing.new.x - takis.railing.x, takis.railing.new.y - takis.railing.y
		takis.rmomz = -$
	end
	
	--wind effect
	for i = 1,10
		if takis.accspeed > (spd*2)*i
			TakisDoWindLines(me,takis.rmomz,windcolor)
			for j = 1,i
				TakisDoWindLines(me,takis.rmomz,windcolor)
			end
		end
	end
	
	if takis.accspeed >= 8*spd/5
		TakisDoWindLines(me,takis.rmomz,windcolor)
	elseif takis.accspeed >= 7*spd/5
		if not (leveltime % 2)
			TakisDoWindLines(me,takis.rmomz,windcolor)
		end
	elseif takis.accspeed >= 6*spd/5
		if not (leveltime % 5)
			TakisDoWindLines(me,takis.rmomz,windcolor)
		end
	elseif takis.accspeed >= spd
		if not (leveltime % 7)
			TakisDoWindLines(me,takis.rmomz,windcolor)
		end
	--i think the wind lines here make you feel really aerodynamic and fast
	elseif me.state == S_PLAY_RUN
		if not (leveltime % 12)
			TakisDoWindLines(me,takis.rmomz,windcolor)
		end
	end
	windcolor = nil
	if (CR_GRINDRAIL)
	and p.powers[pw_carry] == CR_GRINDRAIL
		me.momx,me.momy = 0,0
		takis.rmomz = -$
	end
	
	--nights stuff
	if ((p.drilltimer
	and p.drillmeter
	and not p.drilldelay)
	and (takis.jump)
	and (me.state == S_PLAY_NIGHTS_DRILL)
	and (takis.accspeed >= 23*FU)
	and (p.powers[pw_carry] == CR_NIGHTSMODE))
		if not (takis.drilleffect and takis.drilleffect.valid)
			takis.drilleffect = P_SpawnMobjFromMobj(me,
				P_ReturnThrustX(nil,p.drawangle,17*me.scale),
				P_ReturnThrustY(nil,p.drawangle,17*me.scale),
				0,
				MT_THOK --MT_TAKIS_DRILLEFFECT
			)
			local d = takis.drilleffect
			d.tracer = me
			d.angle = p.drawangle
			d.dispoffset = 2
			--!?!?!
			d.takis_flingme = false
			d.state = S_TAKIS_DRILLEFFECT
			p.powers[pw_strong] = $|STR_PUNCH|STR_STOMP|STR_UPPER
		end
		if not (leveltime%2)
			TakisCreateAfterimage(p,me)
		end
	else
		if (takis.drilleffect and takis.drilleffect.valid)
			P_RemoveMobj(takis.drilleffect)
		end
		p.powers[pw_strong] = $ &~(STR_PUNCH|STR_STOMP|STR_UPPER)
		if (p.powers[pw_carry] == CR_NIGHTSMODE)
			takis.afterimaging = false
			takis.clutchingtime = 0
		end
	end
	
	if p.powers[pw_carry] ~= CR_NIGHTSMODE
		takis.accspeed = lastspeed
	end
	
	if takis.yeahed
	and me.health
		me.tics = -1
		if me.sprite2 ~= SPR2_THUP
			me.frame = A
			me.sprite2 = SPR2_THUP
		end
		
		takis.tauntid = 0
		takis.taunttime = 0
		
		takis.HUD.statusface.happyfacetic = 2
		
		if P_RandomChance(FU-((p.exiting*655)+36))
			me.frame = B
		else
			me.frame = A
		end
	end

	if me.sprite2 == SPR2_THUP
	and (takis.tauntid ~= 6)
		takis.tauntid = 0
		takis.taunttime = 0
		
		takis.HUD.statusface.happyfacetic = 2
	
	end
	
	if takis.yeahwait
		takis.yeahwait = $-1
		if (p.pflags & PF_FINISHED)
		and not (HAPPY_HOUR.othergt)
			-- shouldve just kept this at 99 :/
			-- thanks for the help SMS Alfredo!
			p.exiting = 99
		end
	end
	
	if takis.crushtime ~= 0
		if not (takis.transfo & TRANSFO_PANCAKE)
			takis.crushtime = $-1
		end
	else
		takis.timescrushed = 0
	end
	
	if takis.accspeed >= 60*FU
		if (me.state == S_PLAY_WALK or me.state == S_PLAY_RUN)
		and (p.playerstate == PST_LIVE)
		and (takis.notCarried)
			takis.wentfast = 10*TR
		end
	elseif (takis.heartcards <= (TAKIS_MAX_HEARTCARDS/6 or 1))
	and not (takis.fakeexiting)
	and (p.playerstate == PST_LIVE)
		takis.wentfast = 3
	end
	if (p.playerstate ~= PST_LIVE)
	or p.spectator
		takis.wentfast = 0
	end
	
	if takis.inSRBZ
		local pze = p["ze2_info"]
		
		if mapheaderinfo[gamemap].ze2_noabilities
		and (leveltime == -1)
			takis.noability = $|NOABIL_THOK
		end
		
		if pze.isSprinting
			takis.wentfast = TR
			
			if pze.sprintmeter == 0
			and leveltime % 20 == 0
				TakisSpawnDust(me,
					p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT )),
					10,
					P_RandomRange((me.height/me.scale)/2,(me.height/me.scale)*3/2)*me.scale,
					{
						xspread = 0,
						yspread = 0,
						zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
						
						thrust = P_RandomRange(5,10)*me.scale,
						thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
						
						momz = P_RandomRange(10,-5)*me.scale,
						momzspread = 0,
						
						scale = me.scale,
						scalespread = P_RandomFixed(),
						
						fuse = 20,
					}
				)
			end
		end
		
		local drinkeffect = ZE2:FindEffectAttributes(p,"normalspeed_multiplier")
		if #drinkeffect
			local rad = FixedDiv(me.radius,me.scale)/FU
			local hei = FixedDiv(me.height,me.scale)/FU
			local x = P_RandomRange(-rad,rad)*FU
			local y = P_RandomRange(-rad,rad)*FU
			local z = P_RandomRange(0,hei)*FU
			local spark = P_SpawnMobjFromMobj(me,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
			spark.tracer = me
			spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
			spark.blendmode = AST_ADD
			spark.color = me.color
			spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))
		end
	end
	
	
	--spawn sweat mobj
	if takis.wentfast ~= 0
	and not p.spectator
		if not (takis.sweat and takis.sweat.valid)
			takis.sweat = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_SWEAT)
			takis.sweat.tracer = me
		end
		takis.wentfast = $-1
	else
		if (takis.sweat and takis.sweat.valid)
			--dont remove the sweat if its still animating
			if (takis.sweat.state == S_TAKIS_SWEAT2) -- or (takis.sweat.state == S_TAKIS_SWEAT4))
			--remove IMMEDIATELY or else the world WILL end
			or p.spectator
				P_RemoveMobj(takis.sweat)
			end
		end
	end
	
	
	if takis.inWater
		if (takis.sweat and takis.sweat.valid)
			P_RemoveMobj(takis.sweat)
			takis.wentfast = 0
		end
	end
	
	--elfilin cheers refill combo
	if (p.elfride)
	and (p.elfride.cheerdur/5 > 0)
		TakisGiveCombo(p,takis,false,true)
	end
	
	--animate slide
	if me.state == S_PLAY_TAKIS_SLIDE
	and me.health
	and (me.sprite2 == SPR2_SLID)
		
		/*
		local speed = FixedDiv(FixedMul(takis.accspeed,me.scale),FixedMul(me.scale,me.movefactor))
		if speed > 16<<FRACBITS
			me.tics = 1
		else
			me.tics = 2
		end
		*/
		me.frame = ((takis.accspeed/FU) % 2)
	end
	
	if takis.fakesprung
		me.eflags = $ &~MFE_SPRUNG
		takis.fakesprung = false
	end
	
	if takis.glowyeffects
		
		takis.afterimaging = true
		
		--ffoxd's smooth spintrails
		
		local freq = FRACUNIT*30
		local mospeed = R_PointToDist2(0, 0, R_PointToDist2(0, 0, me.momx, me.momy), me.momz)
		local dist = min(mospeed/freq,25)

		-- The loop, repeats until it spawns all the thok objects.			
		for i = dist, 1, -1 do

		--	local ghost = P_SpawnMobjFromMobj(me, (me.momx/dist)*i, (me.momy/dist)*i, (me.momz/dist)*i, MT_THOK)
			local ghost = P_SpawnGhostMobj(me)
			ghost.scale = 7*me.scale/5
			ghost.fuse = 8
			ghost.destscale = 1
			ghost.scalespeed = $*7/5
			
		/*
			ghost.skin = me.skin
			ghost.sprite = me.sprite
			ghost.sprite2 = me.sprite2
			ghost.state = me.state
			ghost.frame = me.frame|TR_TRANS50
			ghost.angle = p.drawangle
		*/	
			ghost.color = me.color
			ghost.colorized = true
			ghost.destscale = me.scale/3
			ghost.blendmode = AST_ADD
			ghost.frame = $|TR_TRANS10
			P_SetOrigin(ghost, 
				ghost.x-(me.momx/dist)*i, 
				ghost.y-(me.momy/dist)*i, 
				ghost.z-(takis.rmomz/dist)*i
			)
			
		end
		
		takis.glowyeffects = $-1
	end
	
	--spin steer
	if not (takis.transfo & TRANSFO_BALL)
		if ((p.pflags & PF_SPINNING)
		and not (p.pflags & PF_STARTDASH)
		and (takis.onGround))
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor*3
		else
			p.thrustfactor = skins[TAKIS_SKIN].thrustfactor
		end
	end
	
	local doingclapper = false
	for p2 in players.iterate
		if p2 == p
			continue
		end
		
		local m2 = p2.realmo
		
		if ((m2) and (m2.valid))
		and (p2.takistable)
			local dx = me.x-m2.x
			local dy = me.y-m2.y
			
			--in range!
			if FixedHypot(dx,dy) <= TAKIS_TAUNT_DIST
				if m2.skin == TAKIS_SKIN
					if (not takis.taunttime)
						if p2.takistable.tauntjoinable
							--this is stupid,,,, :/
							doingclapper = true
							/*
							local tics = 6
							if ((takis.tauntjoin) and (takis.tauntjoin.valid))
							and not (takis.accspeed or me.momz)
							and me.health
								takis.tauntjoin.tics = tics
							else
								takis.tauntjoin = P_SpawnMobjFromMobj(me, 0, 0, me.height*2, MT_TAKIS_TAUNT_JOIN)
								takis.tauntjoin.target = me
							end
							*/
						end
					end
				elseif m2.skin == "inazuma"
					--done some data mining PLS DONT KIL ME
					--INZAAUMA
					local isultimate = false
					
					isultimate = (p2.inazuma and p2.inazuma.flags & (1<<6))
					
					if isultimate
					and not (takis.taunttime or p.textBoxInAction)
						doingclapper = true
						/*
						local tics = 6
						if ((takis.tauntjoin) and (takis.tauntjoin.valid))
						and not (takis.accspeed or me.momz)
						and me.health
							takis.tauntjoin.tics = tics
						else
							takis.tauntjoin = P_SpawnMobjFromMobj(me, 0, 0, me.height*2, MT_TAKIS_TAUNT_JOIN)
							takis.tauntjoin.target = me
						end
						*/
					end
				end
			end
		end
	end
	
	if (takis.accspeed or me.momz)
	or not me.health
		doingclapper = false
	end
	
	if doingclapper
		if not (takis.tauntjoin and takis.tauntjoin.valid)
			takis.tauntjoin = P_SpawnMobjFromMobj(me, 0, 0, me.height, MT_TAKIS_TAUNT_JOIN)
			takis.tauntjoin.tics = -1
			takis.tauntjoin.target = me
		end
		if takis.tauntjointime < 2*TR
			takis.tauntjointime = $+1
		end
	else
		if takis.tauntjointime
			takis.tauntjointime = $-1
		end
		
		if (takis.tauntjoin and takis.tauntjoin.valid)
			P_RemoveMobj(takis.tauntjoin)
			takis.tauntjoin = 0
		end
	end
	
	if (takis.shotgunned)
		takis.afterimaging = false
		takis.shotguntime = $+1
		if not (takis.transfo & TRANSFO_SHOTGUN)
			TakisDeShotgunify(p)
		end
	else		
		takis.shotguntime = 0
	end
	
	if (takis.shotguncooldown)
		takis.shotguncooldown = $-1
	end
	
	if (takis.timesincelastshot)
		takis.timesincelastshot = $-1
	end
	
	if (takis.dropdashstaletime)
		takis.dropdashstaletime = $-1
	elseif takis.dropdashstale 
		takis.dropdashstale = 0
	end
	
	if p.soaptable
		if p.soaptable.bananapeeled == 1
			TakisAwardAchievement(p,ACHIEVEMENT_BANANA)
		end
	end
	
	if p.skincolor == SKINCOLOR_SALMON
	and takis.lastskincolor ~= SKINCOLOR_SALMON
		TakisAwardAchievement(p,ACHIEVEMENT_RAKIS)
	elseif p.skincolor == SKINCOLOR_CARBON
	and takis.lastskincolor ~= SKINCOLOR_CARBON
	and (skins["specki"] ~= nil)
		TakisAwardAchievement(p,ACHIEVEMENT_SPECKI)
	end
	
	if takis.clutchspamtime
		takis.clutchspamtime = $-1
	elseif takis.clutchspamcount
		takis.clutchspamcount = 0
	end

	if takis.combo.dropped
	and takis.combo.awardable
		takis.combo.awardable = false
	end
	
	if takis.afterimaging
	or (p.powers[pw_invulnerability]
	or p.powers[pw_super] or takis.hammerblasstdown)
	or (takis.transfo & TRANSFO_METAL)
		p.powers[pw_strong] = $|STR_SPIKE
	else
		p.powers[pw_strong] = $ &~STR_SPIKE
	end

	--no continue state
	if (me.sprite2 >= SPR2_CNT1)
	and (me.sprite2 <= SPR2_CNT3)
	or (takis.heartcards == 0 and me.health and not (p.exiting or HAPPY_HOUR.gameover))
		if (me.sprite2 >= SPR2_CNT1)
		and (me.sprite2 <= SPR2_CNT3)
			CONS_Printf(p,"\x83TAKIS:\x80 Don't set Takis' sprite to SPR2_CNT1-3!")
		end
		P_KillMobj(me)
	end
	
	if (takis.heartcards > TAKIS_MAX_HEARTCARDS)
		takis.heartcards = TAKIS_MAX_HEARTCARDS
	elseif takis.heartcards < 0
		takis.heartcards = 0
	end
	
	if (takis.afterimaging
	and takis.shotgunned)
		takis.afterimaging = false
	end
		
	if (takis.shotguntuttic)
		takis.shotguntuttic = $-1
	end
	
	TakisNoShield(p)
	
	if (p.powers[pw_shield] & SH_FIREFLOWER)
		if (me.color ~= SKINCOLOR_BONE)
		and not (takis.transfo & TRANSFO_FIREASS)
			me.color = SKINCOLOR_BONE
		end
		if not (leveltime % TR)
			A_BossScream(me, 1, MT_FIREBALLTRAIL)
		end
	end
	
	if (HAPPY_HOUR.othergt)
	and (HAPPY_HOUR.overtime)
	and (HAPPY_HOUR.happyhour)
		p.powers[pw_sneakers] = 3
	end
	
	if (me.sprite2 == SPR2_FASS)
		me.frame = (leveltime/3%2)
	end
	
	takis.hhexiting = false
	if (PTSR)
	and (HAPPY_HOUR.othergt)
		if (p.lap_hold)
		and (PTSR.laphold)
			if (p.lap_hold == PTSR.laphold-1)
				TakisGiveCombo(p,takis,false,true)
			end
		end
		if (PTSR.gameover)
			takis.hhexiting = true
			takis.noability = NOABIL_ALL
			
			if (p.playerstate == PST_LIVE and not p.spectator)
				if not (p.pflags & PF_FINISHED)
					p.pflags = $|PF_FINISHED
				end
				p.exiting = 100
			end
			
		end
	end
	
	if (me.pizza_in)
	and me.state ~= S_PLAY_DEAD
		if not (takis.pizzastate)
			takis.pizzastate = true
		end
		TakisResetHammerTime(p)
		me.state = S_PLAY_DEAD
		me.frame = A
		me.sprite2 = SPR2_FASS
		takis.spritexscale,takis.spriteyscale = me.spritexscale,me.spriteyscale
	end
	
	if (me.pizza_out)
	and (takis.pizzastate)
	and (me.pizza_out == 1)
		me.state = S_PLAY_STND
		P_MovePlayer(p)
		takis.pizzastate = false
		TakisGiveCombo(p,takis,false,true)
		takis.spritexscale,takis.spriteyscale = me.spritexscale,me.spriteyscale
	end
	
	if (me.state == S_PLAY_MELEE)
	and not (takis.hammerblastdown)
		if (me.momz*takis.gravflip > 0)
			me.state = S_PLAY_SPRING
		else
			me.state = S_PLAY_FALL
		end
		
	end
	
	if takis.fireasssmoke
		if not takis.onGround
			if not takis.firethokked
				me.sprite2 = SPR2_FASS
			end
			A_BossScream(me,1,MT_TNTDUST)
			takis.fireasssmoke = $-1
		else
			P_MovePlayer(p)
			takis.fireasssmoke = 0
		end
	end
	
	if takis.fireballtime then takis.fireballtime = $-1 end
	
	if (p.powers[pw_invulnerability] and
	TAKIS_NET.isretro)
		takis.starman = true
		local color = TakisKart_DriftColor(5) --SKINCOLOR_GREEN
		
		/*
		--not everyone is salmon
		local salnum = #skincolors[ColorOpposite(p.skincolor)]
		takis.afterimagecolor = $+1
		if (takis.afterimagecolor > #skincolors-1-salnum)
			takis.afterimagecolor = 1
		end
		color = salnum+takis.afterimagecolor
		*/
		
		me.color = color
		me.colorized = true
		if not (p.powers[pw_invulnerability] > 3*TR)
			if p.powers[pw_invulnerability] > TR
				if not (p.powers[pw_invulnerability]/2 % 2)
					me.color = (p.powers[pw_shield] & SH_FIREFLOWER) and SKINCOLOR_WHITE or p.skincolor
					me.colorized = false
				end
			else
				if not (p.powers[pw_invulnerability] % 2)
					me.color = (p.powers[pw_shield] & SH_FIREFLOWER) and SKINCOLOR_WHITE or p.skincolor
					me.colorized = false
				end
			end
		end
	elseif takis.starman
		me.color = (p.powers[pw_shield] & SH_FIREFLOWER) and SKINCOLOR_WHITE or p.skincolor
		me.colorized = false
		takis.starman = false
	end
	
	/*
	if takis.hitlag.tics
		local lag = takis.hitlag
		me.momx,me.momy,me.momz = 0,0,0
		me.flags = $|MF_NOGRAVITY
		me.frame = A
		me.sprite2 = lag.sprite2
		me.frame = lag.frame
		takis.stasistic = 2
		
		lag.tics = $-1
		if lag.tics == 1
			p.drawangle = lag.angle
			P_InstaThrust(me,lag.angle,FixedMul(lag.speed,me.scale))
			me.momz = lag.momz*takis.gravflip
			me.flags = $ &~MF_NOGRAVITY
			p.pflags = lag.pflags
			P_MovePlayer(p)
			lag.tics = 0
			takis.stasistic = 0
		end
		takis.accspeed = lag.speed
		
	else
		takis.hitlag.speed = 0
		takis.hitlag.momz = 0
		takis.hitlag.angle = 0
	end
	*/
	
	/*
	if leveltime % TR == 0
		takis.hitlag.tics = TR/3
		takis.hitlag.speed = takis.accspeed
		takis.hitlag.momz = me.momz*takis.gravflip
		takis.hitlag.angle = p.drawangle
	end
	*/
	
	if takis.emeraldcutscene
		--print(takis.emeraldcutscene)
		takis.emeraldcutscene = $-1
		
		
		if takis.emeraldcutscene == 0
			takis.gotemeralds = emeralds
		end
	end
	
	--telegraph coyote time by removing airwalk
	if (p.panim == PA_IDLE
	or me.state == S_PLAY_WAIT 
	or me.state == S_PLAY_WALK 
	or me.state == S_PLAY_RUN 
	or me.state == S_PLAY_DASH)
	and not
	((p.pflags & PF_SPINNING)
	or (p.pflags & PF_JUMPED))

		if not takis.onGround
		and p.powers[pw_carry] != CR_ROLLOUT
		and p.powers[pw_carry] != CR_MINECART
		and p.powers[pw_carry] != CR_ZOOMTUBE
		and p.powers[pw_carry] != CR_ROPEHANG
		and p.powers[pw_carry] != CR_PLAYER
		and p.powers[pw_carry] != CR_NIGHTSMODE
		and not takis.coyote
			if me.momz*takis.gravflip >= 0
				me.state = S_PLAY_SPRING
			else
				me.state = S_PLAY_FALL
			end
		end
		
	end
	
	if takis.isAngry
		if leveltime % 20 == 0
			TakisSpawnDust(me,
				p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT )),
				10,
				P_RandomRange((me.height/me.scale)/2,(me.height/me.scale)*3/2)*me.scale,
				{
					xspread = 0,
					yspread = 0,
					zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = P_RandomRange(5,10)*me.scale,
					thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					momz = P_RandomRange(10,-5)*me.scale,
					momzspread = 0,
					
					scale = me.scale,
					scalespread = P_RandomFixed(),
					
					fuse = 20,
				}
			)
		end
	end
	
	if HAPPY_HOUR.happyhour
	and HAPPY_HOUR.othergt
	and HH_CanDoHappyStuff(p)
		local mname = string.lower(S_MusicName(p) or '') 
		if (mname ~= HAPPY_HOUR.song
		or mname ~= HAPPY_HOUR.songend)
		and (TAKIS_MISC.specsongs[mname] ~= true)
			S_ChangeMusic(HAPPY_HOUR.song,true,p)
		end
	end
	
	if not takis.notCarried
	and (p.powers[pw_carry] == CR_ROLLOUT)
		local rock = me.tracer
		
		if (rock and rock.valid)
			if me.state == S_PLAY_FALL
			or (me.state == S_PLAY_TAKIS_SHOTGUNSTOMP)
				me.state = S_PLAY_STND
				P_MovePlayer(p)
			end
			
			if P_GetPlayerControlDirection(p) == 2
			and takis.accspeed >= 20*FU
				if not S_SoundPlaying(rock,sfx_takskd)
				and not S_SoundPlaying(me,skins[TAKIS_SKIN].soundsid[SKSSKID])
					S_StartSound(rock,sfx_takskd)
				end
				
				rock.spritexoffset = (2*FU)*((leveltime % 2) and 1 or -1)
				if P_RandomChance(FU/2)
					local ang = TakisMomAngle(rock)
					for i = 0,1
						local spark = TakisKart_SpawnSpark(rock,
							ang+FixedAngle(P_RandomRange(-25,25)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
							SKINCOLOR_ORANGE,
							true,
							true
						)
						spark.tracer = me
					end
				end
				
				local friction = FU*21/22
				rock.momx,rock.momy = FixedMul($1,friction),FixedMul($2,friction)
			else
				S_StopSoundByID(rock,sfx_takskd)
				rock.spritexoffset = 0
			end
		end
	end
	
	local maxskid = 16
	if (p.skidtime)
	and (me.state == S_PLAY_SKID)
		if takis.skidframe == -1
			if takis.lastafterimaging
				takis.skidframe = B
			else
				takis.skidframe = A
			end
		end
		me.frame = ($ &~FF_FRAMEMASK)|takis.skidframe
		
		local ang = TakisMomAngle(me)
		if not takis.io.nostrafe
			takis.skidforcetime = maxskid
			takis.skidangle = FixedAngle(AngleFixed(ang) - AngleFixed(me.angle))
			if AngleFixed(takis.skidangle) > 180*FU
				takis.skidangle = InvAngle($)
			end
		end
		
		if P_RandomChance(FU/3)
			for i = 0,1
				TakisKart_SpawnSpark(me,
					ang+FixedAngle(P_RandomRange(-25,25)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
					SKINCOLOR_ORANGE,
					true,
					true
				)
			end
		end
		TakisSpawnDust(me,
			ang+FixedAngle(P_RandomRange(-25,25)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
			P_RandomRange(0,-30),
			P_RandomRange(-1,2)*me.scale,
			{
				xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
				yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
				zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				thrust = P_RandomRange(0,-5)*me.scale,
				thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				momz = P_RandomRange(4,0)*(me.scale/2),
				momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
				
				scale = me.scale/2,
				scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				fuse = 15+P_RandomRange(-5,5),
			}
		)
	else
		S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSSKID])
		
		takis.skidframe = -1
		if takis.skidforcetime
			takis.skidangle = FixedAngle(AngleFixed($)*4/5)
			p.drawangle = me.angle+takis.skidangle
			if takis.skidangle == 0
				takis.skidforcetime = 0
			end
			takis.skidforcetime = $-1
		end
	end
	
	if p.nightsfreeroam
		local waveforce = FU*3
		local dest = TAKIS_NET.dronepos
		local angle = R_PointToAngle2(me.x,me.y, dest[1],dest[2])
		local bouncex = FixedMul(waveforce,sin(FixedAngle(leveltime*15*FU)))
		local adistance = 35*FU+bouncex
		local arrow1 = takis.nfreeroamarrow
		if arrow1 == nil
		or not (arrow1 and arrow1.valid)
			takis.nfreeroamarrow = P_SpawnMobjFromMobj(me,
				FixedMul(adistance,cos(angle)),
				FixedMul(adistance,sin(angle)),
				me.height/4,
				MT_TAKIS_CLUTCHDUST
			)
			arrow1 = takis.nfreeroamarrow
		end
		
		local dx = dest[1]-me.x
		local dy = dest[2]-me.y
		local dz = dest[3]-me.z
		P_MoveOrigin(arrow1,
			me.x+me.momx+FixedMul(adistance,cos(angle)),
			me.y+me.momy+FixedMul(adistance,sin(angle)),
			me.z+me.momz+me.height/4
		)
		
		arrow1.state = S_THOK
		arrow1.sprite = SPR_TMIS
		arrow1.frame = C
		arrow1.renderflags = $|RF_PAPERSPRITE|RF_FULLBRIGHT
		arrow1.tics = -1
		arrow1.fuse = -1
		arrow1.angle = angle
		arrow1.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0, 0, dx, dy), dz) - ANGLE_270
	else
		if (takis.nfreeroamarrow and takis.nfreeroamarrow.valid)
			P_RemoveMobj(takis.nfreeroamarrow)
		end
		takis.nfreeroamarrow = nil
	end
	
	if p.spectator
		takis.dontlanddust = true
	end
	
	--on the really rare and awful edge case someone joins
	--EXACTLY as leveltime reaches a minute, DONT use leveltime,
	--since it might result in a config loss, so use jointime instead
	if (p.jointime % (60*TR)) == 0
	and p.jointime > 0
	and (takis.io.loaded)
	and (takis.io.autosave)
		TakisSaveStuff(p,true)
	end
	
	--ceiling bonk
	if not p.spectator
		local ceilz = (takis.gravflip == 1 and me.ceilingz or me.floorz)
		local dobonk = false
		
		if me.momz/me.scale == 0
		and (takis.lastmomz*takis.gravflip > 0)
			if takis.gravflip == 1
			and (
				GetActorZ(me,me,2) >= ceilz-me.scale 
				and GetActorZ(me,me,2) <= ceilz+me.scale
			)
				dobonk = true
			elseif takis.gravflip == -1
			and (
				me.z >= ceilz-me.scale
				and me.z <= ceilz+me.scale
			)
				dobonk = true
			end
		end
		
		if P_IsObjectInGoop(me)
			dobonk = false
		end
		
		if dobonk
			if not TAKIS_NET.isretro
				S_StartSound(me,sfx_takceh)
			end
			local momz = takis.lastmomz*takis.gravflip
			local rich = 5*FU
			p.jt = -3
			
			DoQuake(p,rich,10)
		end
		
	end
	
	--keep the 6 max, but only let you use 1 card
	--having the empty space be filled up with cards
	--looks better
	if ultimatemode
		if takis.heartcards > 1
			takis.heartcards = 1
		end
	end
	
	local dotilting = false
	if takis.inWater
	or p.pflags & PF_SPINNING
		dotilting = true
	end
	
	if (me.state == S_PLAY_GLIDE)
		dotilting = true
	end
	
	if p.powers[pw_carry] == CR_NIGHTSMODE
		dotilting = false
	end
	
	if dotilting
		takis.tiltdo = true
		local sidemove = -p.cmd.sidemove*55*FU
		local movespeed = min(FixedDiv(takis.accspeed,22*FU),FU)
		takis.tiltvalue = $+FixedMul(sidemove,movespeed)
		
		if takis.inWater
			takis.tiltvalue = -clamp(-ANG30,takis.tiltvalue,ANG30) --max(-ANG30,min(ANG30,takis.tiltvalue))
		end
		
		do
			local lastangle = takis.lastangle
			local myangle = p.cmd.angleturn << 16
			local adjust = 0
			
			if (takis.transfo & TRANSFO_BALL)
			and (p.pflags & PF_SPINNING)
				adjust = $ + TakisMomAngle(me) - me.angle
			end
			adjust = $ + (lastangle - myangle)
			
			--adjust = clamp(-ANG30,$,ANG30) --max(-ANG30,min($,ANG30))
			
			if takis.inWater
				adjust = -$
			end
			
			takis.tiltvalue = $ - adjust
		end
		
		if (p.pflags & PF_SPINNING)
			if not takis.onGround
				takis.tiltfreeze = true
			elseif (takis.transfo & TRANSFO_BALL)
				if takis.onGround
				and (abs(takis.tiltvalue)/ANG1)*FU >= 17*FU
					takis.balldrift = (takis.tiltvalue/ANG1)*FU > 0 and 1 or -1
				else
					takis.balldrift = 0
				end
			end
		end
	end
	
	if All7Emeralds(emeralds)
	and (takis.c3 >= TR*3/4)
	and not (takis.c2 or takis.firenormal)
		if (takis.c3 % 3 == 0)
		and not (takis.kart.mobj and takis.kart.mobj.valid or p.inkart)
		and p.panim == PA_IDLE
		and (p.rings > 0)
			P_GivePlayerRings(p,-1)
			S_StartSound(nil,sfx_itemup,p)
			takis.kart.ringspaid = $+1
			
			local spark = P_SpawnMobjFromMobj(me,
				P_RandomRange(-32,32)*FU,
				P_RandomRange(-32,32)*FU,
				FixedDiv(me.height/2,me.scale) + P_RandomRange(-24,24)*FU,
				MT_THOK
			)
			spark.fuse = -1
			spark.flags = $ &~MF_NOGRAVITY
			spark.state = S_SPRK1
			spark.angle = R_PointToAngle2(spark.x,spark.y,me.x,me.y)
			P_Thrust(spark,spark.angle,P_RandomRange(-3,6)*me.scale)
			
		--recall
		elseif takis.c3 == TR
		and (takis.kart.mobj and takis.kart.mobj.valid and not p.inkart)
			P_SetOrigin(takis.kart.mobj,
				me.x + P_ReturnThrustX(nil,p.drawangle,50*me.scale),
				me.y + P_ReturnThrustY(nil,p.drawangle,50*me.scale),
				GetActorZ(me,takis.kart.mobj,1)
			)
			takis.kart.mobj.momz = 0
			takis.kart.mobj.angle = p.drawangle
			--correct gravity-ness
			if P_MobjFlip(takis.kart.mobj) ~= takis.gravflip
				takis.kart.mobj.eflags = ($ &~MFE_VERTICALFLIP)|(me.eflags & MFE_VERTICALFLIP)
			end
			SpawnPoof(me,takis.kart.mobj)
			S_StartSound(takis.kart.mobj,sfx_mixup)
			
		end
	end
	
	if (not (takis.kart.mobj and takis.kart.mobj.valid)
	or not All7Emeralds(emeralds))
	and takis.kart.paidforkart
	and not p.inkart
		takis.kart.ringspaid = 0
		takis.kart.paidforkart = false
	end
	
	if takis.kart.ringspaid == 50
		S_StartSound(nil,sfx_chchng,p)
		takis.kart.ringspaid = 0
		local car = P_SpawnMobjFromMobj(me,
			P_ReturnThrustX(nil,p.drawangle,50*me.scale),
			P_ReturnThrustY(nil,p.drawangle,50*me.scale), 
			0,
			MT_TAKIS_KART
		)
		car.color = p.skincolor
		car.owner = p 
		car.angle = p.drawangle
		car.paidfor = true
		SpawnPoof(me,car)
		takis.kart.mobj = car
		takis.kart.paidforkart = true
	end
	
	if (takis.slopeairtime and (p.pflags & PF_JUMPED == 0))
	and me.momz*takis.gravflip < 0
	and (me.state ~= S_PLAY_GLIDE)
		local angle = p.drawangle --TakisMomAngle(me,p.drawangle)
		local momz = me.momz*takis.gravflip
		if (me.state ~= S_PLAY_GLIDE)
		and momz > 0
			momz = 0
		end
		--momz = $*takis.gravflip
		
		do --if FixedMul(
			me.pitch = $-FixedMul(momz*10,cos(angle))
			me.roll = $-FixedMul(momz*10,sin(angle))
		end
	
	elseif (me.state == S_PLAY_GLIDE)
		local angle = TakisMomAngle(me,p.drawangle)
		local momz = -FixedDiv(me.momz,me.scale)
		--momz = $*takis.gravflip
		
		do
			me.pitch = FixedAngle(FixedMul(momz*2,cos(angle)))
			me.roll = FixedAngle(FixedMul(momz*2,sin(angle)))
		end
		
	end
	
	/*
	local ang = p.drawangle
	if (me.standingslope and me.standingslope.valid)
		ang = me.standingslope.xydirection
	end
	
	me.pitch = FixedAngle(FixedMul(-90*FU,cos(ang)))
	me.roll = FixedAngle(FixedMul(-90*FU,sin(ang)))
	*/
	
	if takis.justbumped then takis.justbumped = $-1 end
	
	if p.takis_forcerakis
		if not multiplayer
			takis.forcerakis = true
		end
		p.takis_forcerakis = nil
	end
	
	SpeckiStuff(p)
	
	TakisDoNoabil(p,me,takis)
	
	--stairjank?
	local myplanez = (takis.gravflip == 1 and me.floorz or me.ceilingz)
	if (me.eflags & MFE_JUSTSTEPPEDDOWN)
	and me.lastplanez ~= myplanez
	and not (me.standingslope or me.lastslope)
	--Not standing on an object
	and (me.eflags & MFE_ONGROUND)
	and not (takis.inSaxaMM)
		--only if youre actually like "stepping" up it
		if (p.panim >= PA_WALK) and (p.panim <= PA_DASH)
			S_StartSoundAtVolume(me,sfx_takst7,255/2)
			
			local ang = p.drawangle+((leveltime % 4) < 2 and ANGLE_90 or -ANGLE_90)
			local spawn = P_SpawnMobjFromMobj(me,
				P_ReturnThrustX(nil,ang,me.radius),
				P_ReturnThrustY(nil,ang,me.radius),
				0,
				MT_THOK
			)
			spawn.angle = ang+P_RandomRange(-15,15)*FU+P_RandomFixed()
			for i = 0,P_RandomRange(0,3)
				local spark = TakisKart_SpawnSpark(spawn,
					ang+ANGLE_180,
					SKINCOLOR_FUCHSIA,
					false
				)
				spark.momx,spark.momy = $1*3/4,$2*3/4
				spark.tics = $/2
				spark.spritexscale,spark.spriteyscale = $1/2,$2/2
			end
			P_RemoveMobj(spawn)
			
			/*
			for j = -1,1,2
				for i = 1,P_RandomRange(2,3)
					TakisSpawnDust(me,
						p.drawangle+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
						P_RandomRange(0,-50),
						P_RandomRange(-1,2)*me.scale,
						{
							xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = P_RandomRange(0,-10)*me.scale,
							thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							momz = (P_RandomRange(4,0)*i)*(me.scale/2),
							momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = (takis.stairjank >= 8) and me.scale/2 or me.scale*3/4,
							scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = 15+P_RandomRange(-5,5),
						}
					)
				end
			end
			*/
			
			takis.stairjank = 10
		end
		takis.steppeddown = 2
	end
	if takis.stairjank
		me.spriteyoffset = ((leveltime % 4) < 2 and takis.stairjank/2*FU or -takis.stairjank/2*FU)
	end
	takis.stairjank = max($-1,0)
	takis.steppeddown = max($-1,0)
	
	if (me.state == S_PLAY_WAIT)
	and (me.sprite2 == SPR2_WAIT)
		takis.waittics = $+1
		me.frame = takis.waitframe
		
		if takis.waittics >= TR + P_RandomRange(0,TR)
			me.state = S_PLAY_STND
			me.tics = $ + P_RandomRange(TR,8*TR)
		end
	else
		takis.waittics = 0
	end
	
	me.lastplanez = myplanez
	me.lastslope = me.standingslope
	
	p.crushresistance = 4*TR
	p.deathpitteleportresistance = 0
	p.alreadyhascombometer = 2
	
	--This gap puts us in a roll but doesnt crush us
	/*
	if me.ceilingz - me.floorz < P_GetPlayerHeight(p)
	and me.ceilingz - me.floorz >= P_GetPlayerSpinHeight(p)
		if me.state == S_PLAY_STND
		or me.state == S_PLAY_WALK
			p.pflags = $|PF_SPINNING
			P_MovePlayer(p)
			me.state = S_PLAY_ROLL
		end
	end
	*/
	
	if takis.clutchfirefx
		P_ElementalFire(p)
		takis.clutchfirefx = $-1
	end
	
	/*
	if takis.c3 == 1
		TakisFancyExplode(me,
			me.x, me.y, me.z,
			P_RandomRange(60,64)*me.scale,
			32,
			nil,
			15,20
		)
	end
	*/
	
--shorts end
--shortsend
end)

--from clairebun
--https://wiki.srb2.org/wiki/User:Clairebun/Sandbox/Common_Lua_Functions#L_Choose
local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

local cv_models
local function GetModelsVal()
	if not cv_models
		cv_models = CV_FindVar("gr_models")
	end
	
	return cv_models.value
end

--soaps createafterimage modified to include multiple colors
rawset(_G, "TakisCreateAfterimage", function(p,me)
	if not me
	or not me.valid
		return
	end
	
	local takis = p.takistable
	takis.afterimagecount = $+1
	
	local ghost = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_AFTERIMAGE)
	ghost.target = me
		
	--ghost.fuse = SoapFetchConstant("afterimages_fuse")
	
	ghost.skin = me.skin
	ghost.scale = me.scale
	
	ghost.sprite = me.sprite
	
	ghost.state = me.state
	ghost.sprite2 = me.sprite2
	ghost.takis_frame = me.frame
	ghost.tics = -1
	ghost.colorized = true
	
	ghost.angle = p.drawangle
	
	local color = SKINCOLOR_GREEN
	
	if not (
		os.date("*t").day >= 1 and os.date("*t").day <= 5
		and os.date("*t").month == 4
	)
		--not everyone is salmon
		local salnum = #skincolors[ColorOpposite(p.skincolor)]
		if not (takis.starman)
		and (consoleplayer and consoleplayer.valid)
		--laggy model? dont color shift if it is!
		and not (GetModelsVal() and consoleplayer.takistable.io.laggymodel and CV_FindVar("renderer").value == 2)
			takis.afterimagecolor = $+1
			if (takis.afterimagecolor > #skincolors-1-salnum)
				takis.afterimagecolor = 1
			end
		end
		color = salnum+takis.afterimagecolor
		
		if G_GametypeHasTeams()
			color = p.skincolor-1
		end
		ghost.blendmode = AST_ADD
	else
		color = choosething(
			SKINCOLOR_FLAME,
			SKINCOLOR_SUNSET,
			SKINCOLOR_AQUA,
			SKINCOLOR_VAPOR,
			SKINCOLOR_PURPLE
		)
		takis.afterimagecolor = color
		ghost.old = true
	end
	
	ghost.color = color
	ghost.takis_spritexscale,ghost.takis_spriteyscale = me.spritexscale, me.spriteyscale
	ghost.takis_spritexoffset,ghost.takis_spriteyoffset = me.spritexoffset, me.spriteyoffset
	ghost.takis_rollangle = me.rollangle
	ghost.takis_pitch = me.pitch or 0
	ghost.takis_roll = me.roll or 0
	
	--Dont draw right ontop of our takis
	ghost.flags2 = $|MF2_DONTDRAW
	ghost.dispoffset = me.dispoffset - 1
	
	return ghost
end)

rawset(_G, "CreateWindRing", function(p,me)
	local circle = P_SpawnMobjFromMobj(me, 0, 0, 24*FU, MT_THOK) --MT_WINDRINGLOL)
	circle.angle = p.drawangle + ANGLE_90
	circle.fuse = 14
	circle.scale = FixedMul(FU/3,me.scale)
	circle.destscale = 10*me.scale
	circle.scalespeed = FU/10
	circle.colorized = true
	circle.color = SKINCOLOR_WHITE
	circle.momx = -me.momx/2
	circle.momy = -me.momy/2
	circle.startingtrans = FF_TRANS10
	circle.state = S_SOAPYWINDRINGLOL
	return circle
end)

rawset(_G, "DoTakisSquashAndStretch", function(p, me, takis)
	local dontdo = false
	if (p.powers[pw_carry] == CR_NIGHTSMODE)
	or (p.powers[pw_carry] == CR_PLAYER)
	or (p.powers[pw_carry] == CR_ZOOMTUBE)
	or (p.powers[pw_carry] == CR_PTERABYTE)
	or (p.powers[pw_carry] == CR_MINECART)
	or (p.powers[pw_carry] == CR_ROPEHANG)
	or (p.powers[pw_carry] == CR_MACESPIN)
	or (me.pizza_out or me.pizza_in)
	or (p.inkart)
	or (takis.taunttime)
		dontdo = true
	end
	
	if p.jt == nil then
		--jt is the only thing responsible for the stretching!?!?
		p.jt = 0
		p.jp = 0
		p.sp = 0
		p.tr = 0
	end
	if p.jt > 0 then
		p.jt = $ - 1
	end
	if p.jt < 0 then
		p.jt = $ + 1
	end
	/*
	if not dontdo
		if me.momz*takis.gravflip < 1 then
			p.jp = 0
		end
		if me.state != S_PLAY_CLIMB
		and not (me.eflags & MFE_GOOWATER) then
			if me.momz*takis.gravflip > 0
			and p.jp == 0
			and me.state != S_PLAY_FLY
			and me.state != S_PLAY_SWIM
			and me.state != S_PLAY_FLY_TIRED
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_RUN
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_BOUNCE_LANDING
			and (p.pflags & PF_JUMPED) then
				p.jp = 1
				p.jt = 5
			end
			if me.momz*takis.gravflip > 0
			and p.jt < 0
			and me.state != S_PLAY_FLY
			and me.state != S_PLAY_SWIM
			and me.state != S_PLAY_FLY_TIRED
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_RUN
			and me.state != S_PLAY_WALK
			and me.state != S_PLAY_BOUNCE_LANDING then
				p.jp = 1
				p.jt = 5
			end
		elseif (me.eflags & MFE_GOOWATER)
			p.jp = 1
		end
		if not ((p.pflags & PF_THOKKED)
		or takis.thokked) then
			p.tk = 0
		end
		if (p.pflags & PF_THOKKED or takis.thokked)
		and p.tk == 0 then
			p.tk = 1
			p.jt = 5
		end
	end
	*/
	p.maths = p.jt*FU
	p.maths = p.maths / 10
	takis.spriteyscale = $+(p.maths)
	
	p.maths = p.jt*p.spinheight
	if me.state != S_PLAY_ROLL then
		p.maths = p.jt*p.height
	end
	p.maths = p.maths / 20
	if me.skin == TAKIS_SKIN
		if not takis.onGround
			me.spriteyoffset = -1*p.maths
		elseif (takis.spriteyscale == FU)
		and me.spriteyoffset ~= 0
		and (takis.justHitFloor or takis.onGround)
			me.spriteyoffset = 0
		end
	end
	
	p.maths = p.jt*FU
	p.maths = p.maths / 10
	p.maths = p.maths*-1
	takis.spritexscale = $+(p.maths)
end)

--thank you Tatsuru for this thing on the srb2 discord!
local function CheckAndCrumble(me, sec)
	local val = false
	for fof in sec.ffloors()
		if not (fof.flags & FF_EXISTS) continue end -- Does it exist?
		if not (fof.flags & FF_BUSTUP) continue end -- Is it bustable?
		
		if me.z + me.height < fof.bottomheight continue end -- Are we too low?
		if me.z > fof.topheight continue end -- Are we too high?
		
		if (me.type == MT_PLAYER)
			TakisGiveCombo(me.player,me.player.takistable,true)
		elseif (me.type == MT_THOK)
			TakisGiveCombo(me.parent.player,me.parent.player.takistable,true)		
		elseif (me.type == MT_TAKIS_GUNSHOT)
			TakisGiveCombo(me.parent.player,me.parent.player.takistable,true)		
		end
		EV_CrumbleChain(fof) -- Crumble
		val = true
	end
	return val
end

rawset(_G, "TakisBreakAndBust", function(p, me)
	return CheckAndCrumble(me, me.subsector.sector)
end)

--breaks walls in your direction
rawset(_G, "TakisDirBreak", function(p, me, angle)
	local takis = p.takistable
	
	local newsubsec = R_PointInSubsectorOrNil(
		me.x + me.momx + P_ReturnThrustX(nil,angle,me.radius*2),
		me.y + me.momy + P_ReturnThrustY(nil,angle,me.radius*2)
	)
	
	local val = false
	
	if not (newsubsec and newsubsec.valid) then return end
	
	local newsec = newsubsec.sector
	
	if not (newsec and newsec.valid) then return end
	
	for rover in newsec.ffloors()
	
		if not (rover.flags & FF_EXISTS) continue end
		if not (rover.flags & FF_BUSTUP) continue end
		
		if me.z + me.height < rover.bottomheight continue end 
		if me.z > rover.topheight continue end
		
		TakisGiveCombo(p,takis,true)
		
		EV_CrumbleChain(rover)
		val = true
	end
	
	return val
end)


rawset(_G, "DoQuake", function(p, int, tic, minus, id)
	local m = int/tic
	if minus == 0
		m = 0
	end
	table.insert(p.takistable.quake,{intensity = int,tics = tic,minus = m,id = id})
end)

rawset(_G, "DoFlash", function(p, pal, tic)
	if p.takistable.io.flashes
		P_FlashPal(p,pal,tic)
	end
end)

rawset(_G, "S_StartAntonOw", function(source,p)
	if source == nil
		return
	end
	S_StartSound(source, P_RandomRange(sfx_antow1,sfx_antow7),p)
end)
rawset(_G, "S_StartAntonLaugh", function(source,p)
	S_StartSound(source, P_RandomRange(sfx_antwi1,sfx_antwi3),p)
end)

local function collide2(me,mob)
	if me.z > (mob.height*2)+mob.z then return false end
	if mob.z > me.height+me.z then return false end
	return true
end

--can @p1 damage @p2?
--P_TagDamage, P_PlayerHitsPlayer
rawset(_G, "CanPlayerHurtPlayer", function(p1,p2,nobs)
	if not (p1 and p1.valid)
	or not (p2 and p2.valid)
		return false
	end
	
	local allowhurt = true
	local ff = CV_FindVar("friendlyfire").value
	
	if not (nobs)
		--no griefing!
		if TAKIS_NET.inspecialstage
			return false
		end
		
		if not (p1.mo and p1.mo.valid)
			return false
		end
		if not (p2.mo and p2.mo.valid)
			return false
		end
		
		if not p1.mo.health
			return false
		end
		if not p2.mo.health
			return false
		end
		
		if ((p2.powers[pw_flashing])
		or (p2.powers[pw_invulnerability])
		or (p2.powers[pw_super]))
			return false
		end
		
		if (leveltime <= CV_FindVar("hidetime").value*TR)
		and (gametyperules & GTR_STARTCOUNTDOWN)
			return false
		end
		
		if (p1.botleader == p2)
			return false
		end
		
		--battlemod parrying
		if (p2.guard and p2.guard == 1)
			return false
		end
		
		if p1.takistable.inBattle
		and CBW_Battle.MyTeam(p1,p2)
			return false
		end
		
		if p1.takistable.inSaxaMM
		and (p1.mm and p1.mm.role ~= 3) --murderer magic number
			return false
		end
		
	end
	
	--this should already account for all cases
	if (not (ff or gametyperules & GTR_FRIENDLYFIRE)) and (gametyperules & GTR_FRIENDLY)
		allowhurt = false
	end
	
	if G_GametypeHasTeams()
		if (not (ff or gametyperules & GTR_FRIENDLYFIRE)) and (p2.ctfteam == p1.ctfteam)
			allowhurt = false
		end
	end
	
	if gametype == GT_RACE
		allowhurt = false
	end
	
	return allowhurt

end)

rawset(_G, "TakisTeamNewShields", function(p,flamedash)
	local s = p.powers[pw_shield]
	local f = s&SH_NOSTACK
	local takis = p.takistable
	local me = p.mo
	
	if not (me.health)
	or (takis.noability & NOABIL_SHIELD)
		return
	end
	
	--if player.pflags & PF_JUMPED
	if (f or p.powers[pw_super])
	and not (me.state >= S_PLAY_NIGHTS_TRANS1
	and me.state <= S_PLAY_NIGHTS_TRANS6)
		local t = takis.attracttarg
		
		TakisResetHammerTime(p)
		
		if flamedash
			takis.flamedash = $-FU/4
			if takis.flamedash <= 0
				P_RemoveShield(p)
				return
			end
			P_Thrust(me,p.drawangle,me.scale*13/10)
			P_MovePlayer(p)
			if me.friction < FU
				takis.frictionfreeze = 10
				me.friction = FU
				takis.frictionfreeze = 10
			end
			return
		end
		
		if s & SH_FORCE
			p.pflags = $|PF_THOKKED|PF_SHIELDABILITY
			takis.thokked,takis.dived = true,true
			S_StartSound(me,sfx_ngskid)
			me.momx = 0
			me.momy = 0
			me.momz = 0
		end
		if f == SH_WHIRLWIND
		or f == SH_THUNDERCOIN
			P_DoJumpShield(p)
		end
		if f == SH_ARMAGEDDON
			p.pflags = $|PF_THOKKED|PF_SHIELDABILITY
			TakisPowerfulArma(p)
			me.state = S_PLAY_ROLL
		end
		if f == SH_ATTRACT
			p.pflags = $|PF_THOKKED|PF_SHIELDABILITY
			p.homing = 2
			if t and t.valid
				P_HomingAttack(me,t)
				me.angle = R_PointToAngle2(me.x,me.y,t.x,t.y)
				me.state = S_PLAY_ROLL
				S_StartSound(me, sfx_s3k40)
				p.homing = 3*TR
				p.pflags = $|PF_JUMPED &~(PF_THOKKED|PF_NOJUMPDAMAGE)
				takis.thokked = false
			else
				S_StartSound(me, sfx_s3ka6)
				p.pflags = $ &~PF_THOKKED
				takis.thokked = false
			end
		end
		if f == SH_BUBBLEWRAP
		or f == SH_ELEMENTAL
			local elem = ((p.powers[pw_shield]&SH_NOSTACK) == SH_ELEMENTAL)
			p.pflags = $|PF_THOKKED|PF_SHIELDABILITY
			takis.thokked,takis.dived = true,true
			if elem
				if not (takis.thokked or takis.dived or p.pflags & (PF_THOKKED|PF_SHIELDABILITY))
					me.momx = 0
					me.momy = 0
					S_StartSound(me, sfx_s3k43)
				end
			else
				--player.mo.momx = $-(player.mo.momx/3)
				--player.mo.momy = $-(player.mo.momy/3)
				P_Thrust(me,p.drawangle,2*me.scale)
				p.pflags = $|PF_SHIELDABILITY &~(PF_NOJUMPDAMAGE)
				me.state = S_PLAY_ROLL
				S_StartSound(me,sfx_s3k44)
			end
			L_ZLaunch(me, -24*FRACUNIT, false)
		end
		if f == SH_FLAMEAURA
		--and not (takis.thokked or takis.dived or p.pflags & (PF_THOKKED|PF_SHIELDABILITY))
			p.pflags = $|PF_THOKKED|PF_SHIELDABILITY
			takis.thokked = true
			takis.dived = true
			
			local speed = 30*me.scale
			speed = FixedMul($,max(FU - FixedDiv(takis.accspeed,90*FU),0)) 
			
			P_Thrust(me, me.angle,
				speed
			)
			
			p.drawangle = me.angle
			p.pflags = $&~PF_NOJUMPDAMAGE
			
			if me.state ~= S_PLAY_ROLL 
				me.state = S_PLAY_ROLL
			end
			S_StartSound(me,sfx_s3k43)
		end
	end
end)

--TODO: still not accurate
rawset(_G, "TakisNoShield", function(p)
	local s = p.powers[pw_shield]
	local f = s&SH_NOSTACK
	local takis = p.takistable
	local me = p.realmo
	
	local preset = false
	
	if not (me.health)
		takis.noability = $|NOABIL_SHIELD
	end
	
	if not (not takis.onGround
	--and (p.pflags & PF_JUMPED)
	and p.powers[pw_shield] ~= SH_NONE
	and not (takis.hammerblastdown))
	--and f ~= SH_FLAMEAURA
		takis.noability = $|NOABIL_SHIELD
	end
	
	if (takis.shotgunned)
	or not takis.notCarried
		takis.noability = $|NOABIL_SHIELD
	end
	
	if (f or p.powers[pw_super])
	and not (me.state >= 59 and me.state <= 64)
		local t = takis.attracttarg
		if (f == SH_PITY)
		or (f == SH_PINK)
			takis.noability = $|NOABIL_SHIELD
		end
		
		if f == SH_WHIRLWIND
		or f == SH_THUNDERCOIN
			if (p.pflags & (PF_THOKKED|PF_SHIELDABILITY))
				takis.noability = $|NOABIL_SHIELD
			end
		end
		
		if f == SH_ATTRACT
			if not ((p.powers[pw_shield]&SH_NOSTACK) == SH_ATTRACT
			and not (me.state >= 59 and me.state <= 64))
				takis.noability = $|NOABIL_SHIELD
			end
		end
		
		/*
		if f == SH_FLAMEAURA
		and not preset
			takis.noability = $ &~NOABIL_SHIELD
		end
		*/
		
		if f == SH_BUBBLEWRAP
		or f == SH_ELEMENTAL
			if (takis.thokked or takis.dived or p.pflags & (PF_THOKKED|PF_SHIELDABILITY))
			and (f ~= SH_BUBBLEWRAP)
				takis.noability = $|NOABIL_SHIELD
			end
		end
		
		if s & SH_FORCE
		and (p.pflags & PF_SHIELDABILITY)
			takis.noability = $|NOABIL_SHIELD
		end
		
	end
end)

rawset(_G, "TakisHealPlayer", function(p,me,takis,healtype,healamt)
	if takis.inSaxaMM and healtype ~= 3 then return end
	
	if healamt == nil
		healamt = 1
	end
	
	--hurt
	if healtype == 3
		if takis.isSuper then return end
		
		if takis.heartcards ~= 0
			takis.heartcards = $-(abs(healamt))
		end
		if takis.heartcards < 0
			takis.heartcards = 0
		end
		takis.HUD.heartcards.shake = TAKIS_HEARTCARDS_SHAKETIME
		return
	--full heal
	elseif healtype == 2
		if takis.heartcards == TAKIS_MAX_HEARTCARDS
		or ultimatemode
			return
		end

		takis.HUD.heartcards.oldhp = takis.heartcards
		takis.HUD.heartcards.spintic = 4*2
		
		takis.heartcards = TAKIS_MAX_HEARTCARDS
		takis.HUD.heartcards.hpdiff = takis.heartcards - takis.HUD.heartcards.oldhp
		
		takis.HUD.statusface.happyfacetic = 2*TR
		p.timeshit = 0
	elseif healtype == 1
		if takis.heartcards == TAKIS_MAX_HEARTCARDS
		or ultimatemode
			return
		end
		
		takis.HUD.heartcards.oldhp = takis.heartcards
		takis.HUD.heartcards.spintic = 4*2
		
		takis.heartcards = $+healamt
		takis.HUD.heartcards.hpdiff = takis.heartcards - takis.HUD.heartcards.oldhp
		
		takis.HUD.statusface.happyfacetic = 2*TR
		
		if p.timeshit
			p.timeshit = $-1
		end
	else
		error("\x85".."TakisHealPlayer has an invalid healtype.\x80("..healtype..")",2)
		return
	end
	
	--S_StartSound(me,sfx_takhel,p)
	local maxturn = P_RandomRange(12,18)
	for i = 0,maxturn
		local radius = 35
		
		local turn = FixedDiv(360*FU,maxturn*FU)
		local fa = FixedAngle(i*turn)
		fa = $+FixedAngle(P_RandomRange(-4,4)*FU)
		
		local heart = P_SpawnMobjFromMobj(me,
			P_ReturnThrustX(nil,fa,radius*me.scale),
			P_ReturnThrustY(nil,fa,radius*me.scale),
			me.height/2*P_MobjFlip(me),
			MT_THOK
		)
		heart.state = S_LHRT
		heart.frame = A|choosething(0,TR_TRANS10)
		heart.blendmode = AST_ADD
		heart.tics = -1
		heart.angle = R_PointToAngle2(me.x,me.y,heart.x,heart.y)
		heart.fuse = TR*3
		heart.flags = $ &~MF_NOGRAVITY
		local ran = P_RandomRange(2,5)*FU+P_RandomFixed()		
		L_ZLaunch(heart,FixedMul(ran,me.scale*2))
		
		ran = P_RandomRange(2,5)*FU+P_RandomFixed()		
		P_Thrust(heart,heart.angle,FixedMul(ran,me.scale))
		heart.momx,heart.momy,heart.momz = $1+me.momx,$2+me.momy,$3 --+me.momz
		
		heart.scale = me.scale + P_RandomFixed()
		heart.scalespeed = FU/heart.fuse
		heart.destscale = $/5+FixedMul(P_RandomRange(FU/10,FU-2),me.scale)
		
		heart.paperspin = P_RandomChance(FU/2)
		if heart.paperspin
			heart.rng = P_RandomChance(FU/2) and 1 or -1
			heart.renderflags = $|RF_PAPERSPRITE
			heart.angle = P_RandomRange(0,360)*FU
		else
			heart.rng = P_RandomRange(-1,1)
		end
	end
		
end)

local monitorctfteam = {
	[MT_RING_REDBOX] = 1,
	[MT_RING_BLUEBOX] = 2	
}
rawset(_G, "SpawnRagThing",function(tm,t,source)
	if source == nil
		source = t
	end
	
	local result
	
	local speed = FixedHypot(t.momx,t.momy)
	if t.player
		local p = t.player
		local takis = p.takistable
		
		speed = takis.accspeed
		DoQuake(p,t.scale*25+(speed/4),10)
		
		if (takis.inChaos)
			P_DamageMobj(tm,t,t,1)
			return
		end
		if (gametype == GT_ZE2)
			P_DamageMobj(tm,t,t,P_RandomRange(10,15))
			return
		end
	else
		local rad = 1000*t.scale
		for p in players.iterate
			
			local m2 = p.realmo
			
			if not m2 or not m2.valid
				continue
			end
			
			if (FixedHypot(m2.x-t.x,m2.y-t.y) <= rad)
				DoQuake(p,
					FixedMul(
						t.scale*25+(speed/4), FixedDiv( rad-FixedHypot(m2.x-t.x,m2.y-t.y),rad )
					),
					10
				)
			end
		end
		
	end
	
	if not (tm.flags & MF_BOSS)
		if (CanFlingThing(tm,MF_ENEMY))
			if (tm.takis_playerragsprites)
				tm.sprite = SPR_PLAY
				tm.skin = tm.takis_playerragskin or "sonic"
				tm.sprite2 = SPR2_STND
				if tm.color == SKINCOLOR_NONE
					tm.color = tm.takis_playerragcolor or SKINCOLOR_BLUE
				end
				tm.colorized = tm.takis_playerragcolorized or $
			end
			
			--spawn ragdoll thing here
			local ragdoll = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_BADNIK_RAGDOLL)
			tm.tics = -1
			ragdoll.sprite = tm.sprite
			if tm.sprite == SPR_PLAY
				ragdoll.skin = tm.skin
				ragdoll.frame = A
				ragdoll.sprite2 = SPR2_PAIN
			else
				ragdoll.frame = tm.frame
			end
			ragdoll.color = tm.color
			ragdoll.angle = t.angle
			ragdoll.height = tm.height
			ragdoll.radius = tm.radius
			ragdoll.scale = tm.scale
			ragdoll.timealive = 1
			ragdoll.parent2 = source
			ragdoll.target = tm
			ragdoll.flags = MF_SOLID|MF_NOCLIPTHING
			ragdoll.ragdoll = true
			ragdoll.colorized = tm.colorized
			
			L_ZLaunch(ragdoll,7*t.scale)
			
			local thrust = 63
			P_Thrust(ragdoll,ragdoll.angle,
				thrust*t.scale+FixedMul(speed,t.scale)
			)
			
			if P_RandomChance(FRACUNIT/13)
				S_StartSound(ragdoll,sfx_takoww)
			end
			result = ragdoll
			
		elseif (tm.flags & MF_MONITOR)
			--but are we allowed to break it?
			if ((tm.type == MT_RING_REDBOX) or
			(tm.type == MT_RING_BLUEBOX))
				if monitorctfteam[tm.type] ~= source.player.ctfteam
					return
				end
			end
			
			--spawn ragdoll thing here
			local ragdoll = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_BADNIK_RAGDOLL)
			tm.tics = -1
			ragdoll.sprite = tm.sprite
			ragdoll.color = tm.color
			ragdoll.angle = R_PointToAngle2(tm.x,tm.y, t.x,t.y)
			ragdoll.frame = tm.frame
			ragdoll.height = tm.height
			ragdoll.radius = tm.radius
			ragdoll.scale = tm.scale
			ragdoll.timealive = 1
			
			L_ZLaunch(ragdoll,7*t.scale)
			P_Thrust(ragdoll,ragdoll.angle,-63*t.scale-FixedMul(speed,t.scale))
			
			TakisFancyExplode(source,
				tm.x, tm.y, tm.z,
				P_RandomRange(60,64)*tm.scale,
				32,
				nil,
				15,20
			)
			
			/*
			for i = 0, 34
				A_BossScream(ragdoll,1,MT_SONIC3KBOSSEXPLODE)
			end
			*/
			
			local f = P_SpawnGhostMobj(ragdoll)
			f.flags2 = $|MF2_DONTDRAW
			f.fuse = 2*TR
			S_StartSound(f,sfx_tkapow)
			P_RemoveMobj(ragdoll)		
		end
		
		P_KillMobj(tm,t,source)
		--S_StopSound(tm)
		if ((tm) and (tm.valid))
		and (CanFlingThing(tm,MF_ENEMY))
			--hide deathstate
			tm.flags2 = $|MF2_DONTDRAW
			if tm.tics == -1
				tm.tics = 1
			end
		end
	else
		
		if (tm.flags2 & MF2_FRET)
			return
		end
		
		
		if speed < 60*t.scale
			P_DamageMobj(tm,t,source)
		elseif speed >= 60*t.scale
			P_KillMobj(tm,t,source)
			S_StartSound(t,sfx_tacrit)
			
			local ki = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_BROLYKI)
			ki.tracer = tm
			ki.color = tm.color or t.color
		end
	end
	
	return result
end)

local getcomnum = {
	[0] = sfx_tcmup0,
	[1] = sfx_tcmup1,
	[2] = sfx_tcmup2,
	[3] = sfx_tcmup3,
	[4] = sfx_tcmup4,
	[5] = sfx_tcmup5,
	[6] = sfx_tcmup6,
	[7] = sfx_tcmup7,
	[8] = sfx_tcmup8,
	[9] = sfx_tcmup9,
	[10] = sfx_tcmupa,
	[11] = sfx_tcmupb,
	[12] = sfx_tcmupc
}

--returns true if action (add/max/remove combo) was successful
--im SOO good at shadowing
local mathmax = max
rawset(_G, "TakisGiveCombo",function(p,takis,add,max,remove,shared)
	if (p.takis_noabil ~= nil)
	and (p.takis_noabil & NOABIL_WAVEDASH)
		return
	end
	
	if p.ptsr
	and (HAPPY_HOUR.othergt)
		return
	end
	
	if (p.powers[pw_carry] == CR_NIGHTSMODE)
	or not (gametyperules & GTR_FRIENDLY)
	or (maptol & TOL_NIGHTS)
	or (TAKIS_NET.inspecialstage)
	or (takis.inChaos)
	or p.inkart
	or (p.realmo.boat and p.realmo.boat.valid)
		return
	end
	if add == nil
		add = false
	end
	if max == nil
		max = false
	end
	if remove == nil
		remove = false
	end
	if shared == nil
		shared = false
	end
	
	if add == true
		if (HAPPY_HOUR.othergt and HAPPY_HOUR.overtime)
		and not takis.combo.count
			return
		end
		
		local prevcount = takis.combo.count
		takis.combo.pacifist = false
		takis.combo.count = $+1
		local cc = takis.combo.count
		if (HAPPY_HOUR.othergt)
			if p.ptsr
				takis.combo.score = "dontdraw"
			else
				takis.combo.score = ((cc*cc)/2)+(10*cc)
			end
		else
			takis.combo.score = ((cc*cc)/2)+(17*cc)
		end
		if takis.combo.penalty
		and takis.combo.score ~= "dontdraw"
			local bad = takis.combo.penalty
			takis.combo.score = $ - (((bad*bad)/2)+(17*bad))
			takis.combo.score = mathmax($,0)
		end
		
		if takis.combo.count == 1
			S_StartSound(nil,sfx_kc3c,p)
			if takis.combo.outrotics
				takis.combo.outrotointro = takis.HUD.combo.basey - takis.HUD.combo.y
				if takis.combo.failcount >= 50 --TAKIS_NET.partdestoy
					TakisAwardAchievement(p,ACHIEVEMENT_COMBOALMOST)
				end
				takis.combo.outrotics = 0
			--started a new combo?
			else
				takis.combo.slidetime = TR/2
			end
		end
		
		if not (takis.combo.count % TAKIS_COMBO_UP)
			takis.HUD.combo.scale = $+(FU/10)
			S_StartSound(nil,getcomnum[
					((takis.combo.count/TAKIS_COMBO_UP)-1)%13
				],
				p
			)
			takis.combo.rank = $+1
			if (takis.combo.rank)
			and not (takis.combo.rank % 2)
				takis.HUD.statusface.evilgrintic = TR*3/2
			end
		end
		
		if takis.combo.count/(#TAKIS_COMBO_RANKS*TAKIS_COMBO_UP) == 1
		and prevcount/(#TAKIS_COMBO_RANKS*TAKIS_COMBO_UP) == 0
			TakisAwardAchievement(p,ACHIEVEMENT_VERYLAME)
		end
		
		takis.combo.time = TAKIS_MAX_COMBOTIME
		
		if (takis.io.sharecombos == 1)
		and not shared
			for p2 in players.iterate
				if not (p2 and p2.valid) then continue end
				if p2 == p then continue end
				if p2.quittime then continue end
				if p2.spectator then continue end
				if not (p2.mo and p2.mo.valid) then continue end
				if (not p2.mo.health) or (p2.playerstate ~= PST_LIVE) then continue end
				if (p2.mo.skin ~= TAKIS_SKIN) then continue end
				if (p2.takistable.io.sharecombos == 0) then continue end
				if not (p2.mo and p2.mo.valid) then continue end
				
				--forgot radius
				if not P_CheckSight(p.mo,p2.mo) then continue end
				local dx = p2.mo.x - p.mo.x
				local dy = p2.mo.y - p.mo.y
				local dz = p2.mo.z - p.mo.z
				local dist = (TAKIS_TAUNT_DIST*5)*5/2
				
				if FixedHypot(FixedHypot(dx,dy),dz) > dist
					continue
				end
				
				local tak2 = p2.takistable
				local sharedex = tak2.HUD.comboshare[#p]
				sharedex.comboadd = $+1
				sharedex.tics = TR*3/2
				local x,y = R_GetScreenCoords(nil,p2,camera,players[#p].realmo)
				sharedex.x,sharedex.y = x,y
				sharedex.startx,sharedex.starty = x,y
				
				TakisGiveCombo(p2,tak2,false,true,nil,true)
				
			end
		end
		return true
	else
		if not takis.combo.count
			return
		end
		
		if (remove)
			if takis.combo.time >= TAKIS_PART_COMBOTIME
				takis.combo.time = $-TAKIS_PART_COMBOTIME
			else
				takis.combo.time = 0
			end
		else
			if max == true
				takis.combo.time = TAKIS_MAX_COMBOTIME
			else
				takis.combo.time = $+TAKIS_PART_COMBOTIME
			end
		end
		return true
	end
end)

--delf!!
rawset(_G, "TakisDoWindLines", function(me,rmomz,color,forceang)
	if not me.health then return end
	
	local p = me.player
	
	if (p and p.valid)
		if p.takistable.forcerakis
			color = SKINCOLOR_PEPPER
		end
	end
	
	if (p and p.valid)
	and (p.powers[pw_carry] == CR_ROLLOUT
	or p.powers[pw_carry] == CR_PLAYER)
		TakisDoWindLines(me.tracer,p.takistable.rmomz,color,forceang)
	end
	
	local momz = rmomz
	if momz == nil
		momz = me.momz
		if (p and p.valid)
			momz = p.takistable.rmomz
		end
    end
	
	local offx,offy = 0,0
	if R_PointToDist2(0,0,me.momx,me.momy) > me.radius*2
		local timesx = FixedDiv(me.momx,me.radius*2)
		local timesy = FixedDiv(me.momy,me.radius*2)
		
		if timesx ~= 0
			offx = FixedDiv(me.momx,timesx) * P_RandomRange(0,timesx/me.scale)
		end
		if timesy ~= 0
			offy = FixedDiv(me.momy,timesy) * P_RandomRange(0,timesy/me.scale)
		end
	end
	
	local wind = P_SpawnMobj(
		me.x + P_RandomRange(-36,36)*me.scale + offx,
		me.y + P_RandomRange(-36,36)*me.scale + offy,
		me.z + (me.height/2) + P_RandomRange(-20,20)*me.scale + momz,
		MT_TAKIS_WINDLINE
	)
	--wind.state = S_TAKIS_WINDLINE
	wind.scale = me.scale
	if forceang == nil
		wind.angle = TakisMomAngle(me)
	else
		wind.angle = forceang
	end
	/*
	wind.momx = me.momx*3/4
	wind.momy = me.momy*3/4
	wind.momz = momz*3/4
	*/
	
	local mocolor = color
	if mocolor == nil
	and color == nil
		mocolor = SKINCOLOR_SAPPHIRE
		if (me.type == MT_METALSONIC_RACE)
			mocolor = SKINCOLOR_PEPPER
		end
	end
	wind.color = mocolor
	wind.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0,0,me.momx,me.momy), momz)
    
	wind.source = me
	
	return wind
	
end)

rawset(_G, "TakisSpawnDeadBody", function(p, me, soap)
	if (p.deadtimer >= 3*TR)-- and (me.flags2 & MF2_DONTDRAW))
	and not (soap.body and soap.body.valid)
		soap.body = P_SpawnMobjFromMobj(me, 0, 0, 0, MT_TAKIS_DEADBODY)
		soap.body.tics = -1
		soap.body.skin = me.skin
		soap.body.scale = me.scale
		soap.body.state = me.state
		soap.body.sprite2 = me.sprite2
		soap.body.angle = p.drawangle
		soap.body.rollangle = me.rollangle
		soap.body.color = me.color
		soap.body.frame = me.frame
		soap.body.spritexscale = me.spritexscale
		soap.body.spriteyscale = me.spriteyscale
		soap.body.pitch = me.pitch
		soap.body.roll = me.roll
		
		soap.body.flags = me.flags
		soap.body.eflags = me.eflags
		soap.body.momx = me.momx
		soap.body.momy = me.momy
		soap.body.momz = me.momz
		soap.body.target = me
		
		soap.body.colorized = me.colorized
		
		soap.body.shadowscale = me.shadowscale
	end
end)

local function IncrementDeadtimer(p,takis)
	takis.deadtimer = $+1
	if takis.deadtimer >= 3*TR
		takis.freezedeath = false
		if takis.deadtimer >= 3*TR
			if p.deadtimer < 3*TR
				p.deadtimer = 3*TR
			end
		end
	end
end

rawset(_G, "TakisDeathThinker",function(p,me,takis)
	if (p.spectator) then return end
	
	takis.accspeed = 0
	takis.tiltdo = false
	
	takis.freezedeath = false
	
	if p.deadtimer == 1
	and not takis.deathfunny
		DoFlash(p,PAL_NUKE,7)
	end
	
	if takis.deathfunny
		takis.altdisfx = 0
		me.momz = 0-P_GetMobjGravity(me)
		if P_IsObjectOnGround(me)
			me.z = $+(me.scale*takis.gravflip)
		end
		takis.freezedeath = true
		IncrementDeadtimer(p,takis)
		if takis.deadtimer < 3*TR
			p.deadtimer = min(2,$)
		end
		return
	end
	
	if me.skin ~= TAKIS_SKIN
		return
	end
	
	takis.tiltdo = false
	takis.tiltvalue = 0
	
	--explosion anim
	if me.sprite2 == SPR2_TDED
		if p.deadtimer < 21
			A_BossScream(me,0,MT_SONIC3KBOSSEXPLODE)
		end
		if not takis.stoprolling
			me.rollangle = $-(ANG2*2)
		end
	end
	
	if me.state == S_PLAY_PAIN
	or me.state == S_PLAY_JUMP
	or me.state == S_PLAY_FALL
	or me.state == S_PLAY_SPRING
	or me.sprite2 == SRP2_FALL
	and not takis.freeze.tics
		me.state = S_PLAY_DEAD
	end
	
	if takis.saveddmgt
		takis.altdisfx = 0
		if takis.saveddmgt == DMG_CRUSHED
			--if me.momz*takis.gravflip > 0 then me.momz = 0 end
			takis.altdisfx = 0
			
			if p.deadtimer == 1
				S_StartSound(me,sfx_tsplat)
				local maxi = P_RandomRange(8,16)
				for i = 0, maxi
					local fa = FixedAngle(i*FixedDiv(360*FU,maxi*FU))
					local dust = TakisSpawnDust(me,
						fa,
						0,
						P_RandomRange(-1,2)*me.scale,
						{
							xspread = 0,
							yspread = 0,
							zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = 0,
							thrustspread = 0,
							
							momz = P_RandomRange(0,1)*me.scale,
							momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = me.scale,
							scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = TR+P_RandomRange(-2,3),
						}
					)
					dust.momx = FixedMul(sin(fa),me.radius*2)/2
					dust.momy = FixedMul(cos(fa),me.radius*2)/2
				end
				if takis.onGround
					L_ZLaunch(me,15*FU)
				end
			end
			
			me.spritexscale,me.spriteyscale = FU,FU
			me.rollangle = 0
			if not (me.flags & MF_NOGRAVITY)
				local flip = takis.gravflip
				me.momz = FixedMul($, FU*60/63)
				local maxfall = -FixedMul(FU/2, me.scale)
				if flip*me.momz < maxfall
					me.momz = flip*FixedMul(flip*$, FU*60/63)
					if flip*me.momz > maxfall
						me.momz = flip*maxfall
						me.flags = $ | MF_NOGRAVITY
					end
				end
			end
			if not takis.onGround
				takis.freezedeath = true
			end
			
			me.frame = A
			me.sprite2 = SPR2_FLY_
			me.frame = A
			me.height = 0
			me.flags = $ &~MF_NOCLIPHEIGHT
			me.renderflags = RF_FLOORSPRITE|RF_NOSPLATBILLBOARD|RF_OBJECTSLOPESPLAT|RF_SLOPESPLAT
			if (me.standingslope)
				P_CreateFloorSpriteSlope(me)
			else
				P_RemoveFloorSpriteSlope(me)
			end
			me.pitch,me.roll = 0,0
			
			TakisSpawnDeadBody(p,me,takis)
			IncrementDeadtimer(p,takis)
			return
		elseif takis.saveddmgt == DMG_ELECTRIC
			
			if p.deadtimer <= TICRATE
				if (leveltime % 3) == 0
					me.color = SKINCOLOR_SUPERGOLD1
				else
					me.color = SKINCOLOR_JET
				end
				
				if p.deadtimer == 1
					S_StartSound(me, sfx_buzz2)
				end
	
				local rad = FixedDiv(me.radius,me.scale)/FU
				local hei = FixedDiv(me.height,me.scale)/FU
				local x = P_RandomRange(-rad,rad)*FU
				local y = P_RandomRange(-rad,rad)*FU
				local z = P_RandomRange(0,hei)*FU
				local spark = P_SpawnMobjFromMobj(me,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
				spark.tracer = me
				spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
				spark.blendmode = AST_ADD
				spark.color = P_RandomRange(SKINCOLOR_SUPERGOLD1,SKINCOLOR_SUPERGOLD5)
				spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))

				me.colorized = true
			elseif p.deadtimer == TICRATE+1
				me.color = p.skincolor
				me.colorized = false
			end
		
		elseif takis.saveddmgt == DMG_SPACEDROWN
			
			if takis.deadtimer == 1
				SpawnBam(me,true)
				local sfx = P_SpawnGhostMobj(me)
				sfx.tics = TR
				sfx.flags2 = $|MF2_DONTDRAW
				S_StartSound(sfx,sfx_takpop)
			end
			S_StopSound(me)
			me.flags2 = $|MF2_DONTDRAW
			me.momz = 0
			me.flags = $|MF_NOGRAVITY
			IncrementDeadtimer(p,takis)
			return
		
		elseif takis.saveddmgt == DMG_DROWNED
			
			if (takis.inWater)
				me.momz = me.scale*takis.gravflip
			end
			me.rollangle = $-FixedAngle(FU/2)
			TakisSpawnDeadBody(p,me,takis)
			IncrementDeadtimer(p,takis)
			return
			
		elseif takis.saveddmgt == DMG_FIRE
			if (p.deadtimer == 1)
				S_StartSound(me,sfx_takoww)
			end
			
			if me.color ~= SKINCOLOR_JET
				me.color = SKINCOLOR_JET
				me.colorized = true
			end

			if p.deadtimer < 10
				S_StartSound(me,sfx_fire)
			end
			
			if (me.sprite2 ~= SPR2_FASS)
			and not takis.deathfloored
				me.sprite2 = SPR2_FASS
			end
			
			if (leveltime & 3) == 0
			and p.deadtimer <= 2*TICRATE
				A_BossScream(me, 0, MT_FIREBALLTRAIL)
			end
			
		elseif takis.saveddmgt == DMG_DEATHPIT
			if p.deadtimer == 1
				local momz = takis.lastmomz
				if momz < -30*me.scale*takis.gravflip
					momz = -30*me.scale*takis.gravflip
				end
				me.momz = momz
			end
			me.momx,me.momy = 0,0
			me.flags = $|(MF_NOCLIPTHING|MF_NOCLIP|MF_NOCLIPHEIGHT)
			IncrementDeadtimer(p,takis)
			return
		end
	end
	
	me.flags = $ &~MF_NOCLIPHEIGHT
	TakisSpawnDeadBody(p,me,takis)
	
	IncrementDeadtimer(p,takis)
	
	if takis.freezedeath
		p.deadtimer = min(5,$)
	end
	
	/*
	if (me.rollangle ~= 0)
	or not (takis.onGround)
	and (capdead)
		p.deadtimer = min(5,$)
	end
	*/
	
	if not takis.deathfunny
		if (takis.justHitFloor or takis.onGround)
		and p.deadtimer > 3
		and (not takis.deathfloored)
			if takis.saveddmgt ~= DMG_DEATHPIT
			and P_CheckDeathPitCollide(me)
				takis.saveddmgt = DMG_DEATHPIT
				local ghs = P_SpawnGhostMobj(me)
				ghs.tics = -1
				ghs.frame = me.frame
				ghs.colorized = true
				ghs.angle = p.drawangle
				ghs.fuse = 23
				ghs.color = SKINCOLOR_WHITE
				
				for i = 10,P_RandomRange(15,20)
					TakisSpawnDust(me,
						p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT )),
						10,
						P_RandomRange(0,me.height/FU)*FRACUNIT,
						{
							xspread = 0,
							yspread = 0,
							zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = 0,
							thrustspread = 0,
							
							momz = 0,
							momzspread = 0,
							
							scale = me.scale,
							scalespread = P_RandomFixed(),
							
							fuse = 20+P_RandomRange(-3,3),
						}
					)
				end
				S_StartSound(me,sfx_s3k51)
				me.flags = $|(MF_NOCLIPTHING|MF_NOCLIP|MF_NOCLIPHEIGHT)
				me.momz = -30*me.scale*takis.gravflip --takis.lastmomz
				p.deadtimer = 1
				takis.deathfloored = true
				return
			end
			me.tics = -1
			if (me.rollangle == 0)
				me.state = S_PLAY_DEAD
				me.frame = A
				me.sprite2 = SPR2_TDD2
				p.jp = 2
				p.jt = -5
				takis.deathfloored = true
			else
				L_ZLaunch(me,10*FU)
				me.rollangle = 0
				takis.stoprolling = true
				takis.deathfloored = false
			end
			
			S_StartSound(me,sfx_altdi1)
			S_StartSound(me,sfx_smack)
			S_StartSound(me,sfx_s3k5d)
			
			DoFlash(p,PAL_NUKE,5)
			DoQuake(p,10*FU,15)
			for i = 0, 8
				local radius = me.scale*16
				local fa = (i*ANGLE_45)
				local mz = me.scale
				local dust = TakisSpawnDust(me,
					fa,
					0,
					P_RandomRange(-1,2)*me.scale,
					{
						xspread = 0,
						yspread = 0,
						zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						thrust = 0,
						thrustspread = 0,
						
						momz = P_RandomRange(0,1)*me.scale,
						momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
						
						scale = me.scale,
						scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						fuse = 23+P_RandomRange(-2,3),
					}
				)
				dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
				dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
			end
			
		--fell back down again
		elseif not (takis.justHitFloor or takis.onGround)
		and p.deadtimer > 3
		and takis.deathfloored
			me.state = S_PLAY_DEAD
			me.frame = A
			me.sprite2 = SPR2_TDD2
			takis.deathfloored = false
		end
		
		if takis.deathfloored
			p.drawangle = InvAngle(TakisMomAngle(me,InvAngle(p.drawangle)))
			if me.state ~= S_PLAY_DEAD
				me.state = S_PLAY_DEAD
			end
			me.tics = -1
			if me.sprite2 ~= SPR2_TDD2
				me.frame = A
				me.sprite2 = SPR2_TDD2
			end
		end
	end
end)

/*
local function FixedLerp(val1,val2,amt)
	local p = FixedMul(FRACUNIT-amt,val1) + FixedMul(amt,val2)
	return p
end

local blerp0 = {
	["ULTIMATE"] = 0,
	["SHOTGUN"] = 0,
	["HAPPYHOUR"] = 0,
	--["HEART"] = 0,
}
local blerp1 = {
	["ULTIMATE"] = 0,
	["SHOTGUN"] = 0,
	["HAPPYHOUR"] = 0,
	--["HEART"] = 0,
}

rawset(_G,"TakisDrawBonuses", function(v, p, x, y, flags, salign, dist, angle)

	local lerp = 0
	if (p == displayplayer)
		lerp = blerp0
	else
		lerp = blerp1
	end
	
	local takis = p.takistable
	local bonus = takis.bonuses
	
	local lerpx, lerpy = 0, 0
	local interpr = FU*60/100
	local function DoShift(val, ang)
		lerpx = $+P_ReturnThrustX(nil, ang, val)
		lerpy = $+P_ReturnThrustY(nil, ang, val)
	end
	local function DoLerp(kind, retract, val)
		if (p == displayplayer) then
			if blerp0[kind] == nil then blerp0[kind] = 0 end
			if (retract)
				blerp0[kind] = ease.inquart(interpr,blerp0[kind], 0)
			else
				blerp0[kind] = ease.inquart(interpr,blerp0[kind], val)
			end
		else
			if (retract)
				blerp1[kind] = FixedLerp(blerp1[kind], 0, FU*70/100)
			else
				blerp1[kind] = FixedLerp(blerp1[kind], val, FU*70/100)
			end
		end
	end
	
	if bonus["shotgun"].tics
		local trans = 0
		if bonus["shotgun"].tics > 3*TR+9
			trans = (bonus["shotgun"].tics-(3*TR+9))<<V_ALPHASHIFT
		--elseif bonus["shotgun"].tics < 10
		--	trans = (10-bonus["shotgun"].tics)<<V_ALPHASHIFT
		end
		
		v.drawString(x+lerpx, y+lerpy, 
			bonus["shotgun"].text.."\x80 - "..bonus["shotgun"].score.."+", 
			flags|trans, salign
		)
		
		DoShift(lerp["SHOTGUN"], angle)
		DoLerp("SHOTGUN", false, dist)
	else
		DoShift(lerp["SHOTGUN"], angle)
		DoLerp("SHOTGUN", true, dist)
	end
	
	if bonus["ultimatecombo"].tics
		local trans = 0
		if bonus["ultimatecombo"].tics > 3*TR+9
			trans = (bonus["ultimatecombo"].tics-(3*TR+9))<<V_ALPHASHIFT
		--elseif bonus["ultimatecombo"].tics < 10
		--	trans = (10-bonus["ultimatecombo"].tics)<<V_ALPHASHIFT
		end
		
		v.drawString(x+lerpx, y+lerpy, 
			bonus["ultimatecombo"].text.."\x80 - "..bonus["ultimatecombo"].score.."+", 
			flags|trans, salign
		)
		
		DoShift(lerp["ULTIMATE"], angle)
		DoLerp("ULTIMATE", false, dist)
	else
		DoShift(lerp["ULTIMATE"], angle)
		DoLerp("ULTIMATE", true, dist)
	end
	
	if bonus["happyhour"].tics
		local trans = 0
		if bonus["happyhour"].tics > 3*TR+9
			trans = (bonus["happyhour"].tics-(3*TR+9))<<V_ALPHASHIFT
		--elseif bonus["happyhour"].tics < 10
		--	trans = (10-bonus["happyhour"].tics)<<V_ALPHASHIFT
		end
		
		v.drawString(x+lerpx, y+lerpy, 
			bonus["happyhour"].text.."\x80 - "..bonus["happyhour"].score.."+", 
			flags|trans, salign
		)
		
		DoShift(lerp["HAPPYHOUR"], angle)
		DoLerp("HAPPYHOUR", false, dist)
	else
		DoShift(lerp["HAPPYHOUR"], angle)
		DoLerp("HAPPYHOUR", true, dist)
	end
	
	for k,val in ipairs(bonus.cards)
		if blerp0["HEART"..k] == nil then blerp0["HEART"..k] = 0 end
		if val.tics
			local trans = 0
			if val.tics > TR+9
				trans = (val.tics-(TR+9))<<V_ALPHASHIFT
			--elseif val.tics < 10
			--	trans = (10-val.tics)<<V_ALPHASHIFT
			end
			
			v.drawString(x+lerpx, y+lerpy, 
				val.text.."\x80 - "..val.score.."+", 
				flags|trans, salign
			)
			
			DoShift(lerp["HEART"..k], angle)
			DoLerp("HEART"..k, false, dist)
		else
			DoShift(lerp["HEART"..k], angle)
			DoLerp("HEART"..k, true, dist)
			if lerp["HEART"..k] == 0
				table.remove(bonus.cards,k)
			end
		end
		
	end
end)
*/

rawset(_G, "GetInternalFontWidth", function(str, font)

	-- No string
	if not (str) then return 0 end

	local width = 0

	for i=1,#str do
		-- (Using patch width by the way)
		if (font == "STCFN") then -- default font
			width = $1+8
		elseif (font == "TNYFN") then
			width = $1+7
		elseif (font == "LTFNT") then
			width = $1+20
		elseif (font == "TTL") then
			width = $1+29
		elseif (font == "CRFNT" or font == "NTFNT") then -- TODO: Credit font centers wrongly
			width = $1+16
		elseif (font == "NTFNO") then
			width = $1+20
		else
			width = $1+27
		end
	end
	return width
end)

--TODO: stop using this
rawset(_G, "TakisDrawPatchedText", function(v, x, y, str, parms)

	-- Scaling
	local scale = (parms and parms.scale) or 1*FRACUNIT
	local hscale = (parms and parms.hscale) or 0
	local vscale = (parms and parms.vscale) or 0
	local yscale = (8*(FRACUNIT-scale))
	-- Spacing
	local xspacing = (parms and parms.xspace) or 0 -- Default: 8
	local yspacing = (parms and parms.yspace) or 4
	-- Text Font
	local font = (parms and parms.font) or "STCFN"
	local uppercs = (parms and parms.uppercase) or false
	local align = (parms and parms.align) or nil
	local flags = (parms and parms.flags) or 0
	local fixed = (parms and parms.fixed) or false

	-- Split our string into new lines from line-breaks
	local lines = {}

	for ls in str:gmatch("[^\r\n]+") do
		table.insert(lines, ls)
	end

	-- For each line, set some stuff up
	for seg=1,#lines do
		
		local line = lines[seg]
		-- Fixed Position
		local fx = x << FRACBITS
		local fy = y << FRACBITS
		if fixed
			fx = x
			fy = y
		end
		-- Offset position
		local off_x = 0
		local off_y = 0
		-- Current character & font patch (we assign later later instead of local each char)
		local char
		local charpatch

		-- Alignment options
		if (align) then
			-- TODO: not working correctly for CRFNT
			if (align == "center") then
				if not fixed
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)/2), scale) << FRACBITS -- accs for scale
				else
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)/2), scale)
				end
				-- 	fx = $1-FixedMul( (v.stringWidth(line, 0, "normal")/2), scale) << FRACBITS
			elseif (align == "right") then
				if not fixed
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)), scale) << FRACBITS
				else
					fx = $1-FixedMul( (GetInternalFontWidth(line, font)), scale)
				end
				-- fx = $1-FixedMul( (v.stringWidth(line, 0, "normal")), scale) << FRACBITS
			end
		end

		-- Go over each character in the line
		for strpos=1,#line do
			local drawable = true
			-- get our character step by step
			char = line:sub(strpos, strpos)

			-- TODO: custom skincolors will make a mess of this since the charlimit is 255
			-- Set text color, inputs, and more through special characters
			-- Referencing skincolors https:--wiki.srb2.org/wiki/List_of_skin_colors

			-- TODO: effects?
			-- if (char:byte() == 161) then
			-- 	continue
			-- end
			-- print(strpos<<27)
			-- off_x = (cos(v.RandomRange(ANG1, ANG10)*leveltime))
			-- off_y = (sin(v.RandomRange(ANG1, ANG10)*leveltime))
			-- local step = strpos%3+1
			-- print(step)
			-- off_x = cos(ANG10*leveltime)*step
			-- off_y = sin(ANG10*leveltime)*step

			-- Skip and replace non-existent space graphics
			if not char:byte() or char:byte() == 32 then
				fx = $1+2*scale
				drawable = false
			end

			-- Unavoidable non V_ALLOWLOWERCASE flag toggle (exclude specials above 210)
			if (uppercs or (font == "CRFNT" or font == "NTFNT" or font == 'PTFNT'))
			and not (char:byte() >= 210) then
				char = tostring(char):upper()
			end

			-- transform the char to byte to a font patch
			charpatch = v.cachePatch( string.format("%s%03d", font, string.byte(char)) )

			-- Draw char patch
			if drawable
				v.drawStretched(
					fx+off_x, fy+off_y+yscale,
					scale+hscale, scale+vscale, charpatch, flags)
				-- Sets the space between each character using font width
			end
			fx = $1+(xspacing+charpatch.width)*scale
			--fy = $1+yspacing*scale
		end

		-- Break new lines by spacing and patch width for semi-accurate spacing
		y = $1+(yspacing+charpatch.height)*scale >> FRACBITS 
	end	

end)

rawset(_G,"TakisPowerfulArma",function(p)
	local me = p.mo
	local takis = p.takistable
	local rad = 2700*FU
	
	if (takis.inBattle)
		CBW_Battle.ArmaCharge(p)
		S_StartSoundAtVolume(me, sfx_s3kc4s, 200)
		S_StartSoundAtVolume(nil, sfx_s3kc4s, 80)
		p.armachargeup = 1
		return
	end
	
	if not (TAKIS_NET.nerfarma)
	--idk something bugs out and its 3am sooo
	and not G_RingSlingerGametype()
	
		--kill!
		local px = me.x
		local py = me.y
		local br = rad
		
		searchBlockmap("objects", function(me, found)
			if not (found and found.valid) then return end
			if not (found.health) then return end
			if found.alreadykilledthis then return end
			
			if (CanFlingThing(found,MF_ENEMY|MF_BOSS))
				found.alreadykilledthis = true
				P_KillMobj(found,me,me,DMG_NUKE)
			elseif SPIKE_LIST[found.type] == true
				found.alreadykilledthis = true
				P_KillMobj(found,me,me,DMG_NUKE)
			end
		end, me, px-br, px+br, py-br, py+br)			
		
		--yes powerful arma is just regular arma lol
		P_BlackOw(p)
		S_StartSound(me, sfx_bkpoof)
		DoFlash(p,PAL_NUKE,20)
		DoQuake(p,75*FU,20)
		
		for p2 in players.iterate
			if p2 == p
				continue
			end
			
			local m2 = p2.realmo
			
			if not m2 or not m2.valid
				continue
			end
			
			if (FixedHypot(m2.x-me.x,m2.y-me.y) <= rad)
				if (CanPlayerHurtPlayer(p,p2))
					TakisAddHurtMsg(p2,p,HURTMSG_ARMA)
					P_DamageMobj(m2,me,me,DMG_NUKE)
				end
				DoFlash(p2,PAL_NUKE,20)
				DoQuake(p2,
					FixedMul(
						75*FU, FixedDiv( rad-FixedHypot(m2.x-me.x,m2.y-me.y),rad )
					),
					20
				)
			end
		end
				
		--sparks
		for i = 1, 40 do
			local fa = (i*FixedAngle(9*FU))
			local x = FixedMul(cos(fa), 22*(me.scale/FU))*FU
			local y = FixedMul(sin(fa), 22*(me.scale/FU))*FU
			local height = me.height
			local spark = P_SpawnMobjFromMobj(me,x,y,(height/2)*takis.gravflip,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
			spark.tracer = me
			spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)
			spark.color = p.skincolor
			spark.momx, spark.momy = x,y
			spark.blendmode = AST_ADD
			spark.angle = fa	
		end
		for i = 0, 16
			local fa = (i*ANGLE_22h)
			local spark = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
			spark.momx = FixedMul(sin(fa),rad)
			spark.momy = FixedMul(cos(fa),rad)
			local spark2 = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
			spark2.color = me.color
			spark2.momx = FixedMul(sin(fa),rad/20)
			spark2.momy = FixedMul(cos(fa),rad/20)
		end
		p.powers[pw_shield] = SH_NONE
	else
		P_BlackOw(p)
	end
	
	--get an extra combo from the shield
	TakisGiveCombo(p,takis,true)
end)

rawset(_G,"TakisResetTauntStuff",function(p,killclapper)
	local takis = p.takistable
	if takis.taunttime
		takis.taunttime = 0
		P_RestoreMusic(p)
		TakisResetState(p)
		takis.tauntid = 0
		takis.tauntspecial = 0
		takis.tauntextra = {}
	end
	if (killclapper)
		if (takis.tauntjoin and takis.tauntjoin.valid)
			P_KillMobj(takis.tauntjoin)
		end
		takis.tauntjoin = 0
	end
	takis.tauntjoinable = false
	takis.tauntpartner = 0
	takis.tauntacceptspartners = false
end)

/*
rawset(_G,"ReturnTrigAngles",function(angle)
	error("ReturnTrigAngles is deprecated, use P_ReturnThrustX/Y instead.", 2)
	return cos(angle),sin(angle)
end)
*/

rawset(_G,"TakisDoShotgunShot",function(p,down)
	if down == nil
		down = false
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if takis.noability & NOABIL_SHOTGUN then return end
	
	DoQuake(p,10*FU,10)
	
	local lastaimingbeforedown = p.aiming
	if down
		if (takis.gravflip == 1)
			p.aiming = FixedAngle(FU*270)
		else
			p.aiming = FixedAngle(FU*89)
		end
		takis.shotgunshotdown = true
	else
		if not (TAKIS_NET.chaingun)
			takis.HUD.viewmodel.frameinc = 5*4
		else
			takis.HUD.viewmodel.frameinc = P_RandomRange(2,3)*4
		end
		
		if me.flags2 & MF2_TWOD
		or twodlevel
			p.aiming = 0
		end
	end
	
	local ssmul = 10
	
	--rs neo
	
	--horiz
	local spread = 2
	for i = -2, 2
		local r = P_RandomFixed
		local ran = P_RandomRange(0,1)
		if ran == 0 then ran = -1 end
		
		local shotspread = FixedAngle( FixedMul( FixedMul( r(), r() ), r() ) * ran) * ssmul
		
		--the first shot is always accurate
		if takis.timesincelastshot == 0
			shotspread = 0
		end
		
		local shot = P_SPMAngle(me, MT_TAKIS_GUNSHOT, me.angle + i * ANG1*spread+shotspread, 1, 0)
		if ((shot) and (shot.valid))
			shot.parent = me
			shot.flags2 = $|MF2_RAILRING
			shot.timealive = 1
			P_Thrust(shot,shot.angle,takis.accspeed)
			
		end
		
	end
	--vert
	for i = -2, 2
		if i == 0
			continue
		end
		
		local r = P_RandomFixed
		local ran = P_RandomRange(0,1)
		if ran == 0 then ran = -1 end
		
		local shotspread = FixedAngle( FixedMul( FixedMul( r(), r() ), r() ) * ran) * ssmul

		--the first shot is always accurate
		if takis.timesincelastshot == 0
			shotspread = 0
		end
		
		local prevaim = p.aiming
		p.aiming = $ + i * ANG1*spread
		local shot = P_SPMAngle(me, MT_TAKIS_GUNSHOT, me.angle+shotspread, 1, 0)
		
		--extra horiz
		if ((i == -1) or (i == 1))
			for j = -1, 1
				shotspread = FixedAngle( FixedMul( FixedMul( r(), r() ), r() ) * ran) * ssmul
				
				local shot = P_SPMAngle(me, MT_TAKIS_GUNSHOT, me.angle + (j * ANG1*spread)+shotspread, 1, 0)
				if ((shot) and (shot.valid))
					shot.parent = me
					shot.flags2 = $|MF2_RAILRING
					shot.timealive = 1
					P_Thrust(shot,shot.angle,takis.accspeed)
					
				end
				
			end
		end
		p.aiming = prevaim
		
		if shot and shot.valid
			shot.parent = me
			shot.flags2 = $|MF2_RAILRING
			shot.timealive = 1
			P_Thrust(shot,shot.angle,takis.accspeed)
			
		end
	end
	
	p.aiming = lastaimingbeforedown
	takis.timesincelastshot = TR
	takis.shotgunshots = $+1
	
	if takis.inBattle
	and takis.shotgunshots == 3
		TakisDeShotgunify(p)
	end
	
end)

local function DoCommandPress(p,me,takis,menu)
	if menu.jump == 1
		if TAKIS_MENU.entries[menu.page].commands
		and TAKIS_MENU.entries[menu.page].commands[menu.y+1] ~= nil
			local pre = "takis_"
			if (TAKIS_MENU.entries[menu.page].noprefix) then pre = '' end
			
			COM_BufInsertText(p,pre..TAKIS_MENU.entries[menu.page].commands[menu.y+1])
			S_StartSound(nil,sfx_menu1,p)
		elseif TAKIS_MENU.entries[menu.page].cvars
		and TAKIS_MENU.entries[menu.page].cvars[menu.y+1] ~= nil
			local cv = TAKIS_MENU.entries[menu.page].cvars[menu.y+1]
			local setting = 0
			setting = 1-cv.value
			COM_BufInsertText(p,cv.name.." "..setting)
			S_StartSound(nil,sfx_menu1,p)
			
		end
	end
end

rawset(_G,"TakisMenuThinker",function(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.cosmenu
	
	if not takis.cosmenu.menuinaction
		return
	end
	
	if p.spectator
	or not (me and me.valid)
		TakisMenuOpenClose(p)
		return
	end
	
 	takis.nocontrol = 3
	p.pflags = $ |PF_FULLSTASIS|PF_FORCESTRAFE
	
	if (p.cmd.buttons & BT_CUSTOM1)
		TakisMenuOpenClose(p)
		return
	end
	
	if (p.cmd.buttons & BT_CUSTOM2)
	and takis.HUD.showingletter
		takis.HUD.showingletter = false
		P_RestoreMusic(p)
	end
	
	local menu = takis.cosmenu
	
	if menu.hintfade > 0 then menu.hintfade = $-1 end
	
	if (p.cmd.forwardmove > 19)
		menu.up = $+1
		menu.down = 0
	else
		menu.up = 0
	end
	if (p.cmd.forwardmove < -19)
		menu.down = $+1
		menu.up = 0
	else
		menu.down = 0
	end
	if (p.cmd.sidemove > 19) and not (menu.up or menu.down)
		menu.right = $+1
		menu.left = 0
		menu.scroll = 0
	else
		menu.right = 0
	end
	if (p.cmd.sidemove < -19) and not (menu.up or menu.down)
		menu.left = $+1
		menu.right = 0
		menu.scroll = 0
	else
		menu.left = 0
	end
	if (p.cmd.buttons & BT_JUMP) and not (p.cmd.buttons & BT_SPIN)
		menu.jump = $+1
	else
		menu.jump = 0
	end
	
	
	if menu.left == 1
	or menu.left >= TR/2
		if menu.page > 0
			menu.y = 0
			menu.page = $-1
			S_StartSound(nil,sfx_menu1,p)
		end		
	end
	if menu.right == 1
	or menu.right >= TR/2
		if menu.page ~= #TAKIS_MENU.entries
			menu.y = 0
			menu.page = $+1
			S_StartSound(nil,sfx_menu1,p)
		end
	end
	
	if menu.page == 3
		DoCommandPress(p,me,takis,menu)
		return
	end
	if menu.page == 1
		local off = (menu.achpage*16)
		local max = 0
		if (NUMACHIEVEMENTS > 16)
			max = (menu.achpage == 0) and 15 or (NUMACHIEVEMENTS-1)-off
		else
			max = 15
		end
		
		if menu.achcur > max
			menu.achcur = max
		end
		
		if menu.up == 1
		or menu.up >= TR/2
			if menu.achcur ~= 0
				menu.achcur = $-1
				S_StartSound(nil,sfx_menu1,p)
			end
		end
		if menu.down == 1
		or menu.down >= TR/2
			if menu.achcur ~= max
				menu.achcur = $+1
				S_StartSound(nil,sfx_menu1,p)
			end
		end
		if menu.jump == 1
		and (NUMACHIEVEMENTS > 16)
			menu.achpage = 1-$
			menu.achcur = 0
			S_StartSound(nil,sfx_menu1,p)
		end
		return
	end
	
	if menu.up == 1
	or menu.up >= TR/2
		if menu.y ~= 0
			menu.y = $-1
			S_StartSound(nil,sfx_menu1,p)
		end
	end
	if menu.down == 1
	or menu.down >= TR/2
		if menu.y ~= #TAKIS_MENU.entries[menu.page].text-1
			menu.y = $+1
			S_StartSound(nil,sfx_menu1,p)
		end
	end
	DoCommandPress(p,me,takis,menu)
end)

rawset(_G, "Tprtable", function(text, t, doprint, prefix, cycles)
    prefix = $ or ""
    cycles = $ or {}
	if doprint == nil
		doprint = true
	end
	
	local stringtext = {}

	if doprint
		print(prefix..text.." = {")
	end
	table.insert(stringtext,prefix..text.." = {")
	
    for k, v in pairs(t)
		local colorcode = ''
        if type(v) == "table"
            if cycles[v]
				if doprint
					print(prefix.."    "..tostring(k).." = "..tostring(v))
				end
				table.insert(stringtext,prefix.."    "..tostring(k).." = "..tostring(v))
            else
                cycles[v] = true
                Tprtable(k, v, doprint, prefix.."    ", cycles)
            end
        elseif type(v) == "string"
			colorcode = "\x8D"
			if doprint
				print(prefix.."    "..tostring(k)..' = '..colorcode..'"'..v..'"')
			end
			table.insert(stringtext,prefix.."    "..tostring(k)..' = '..colorcode..'"'..v..'"')
        else
			if type(v) == "userdata" and v.valid
				colorcode = "\x86"
				if (v.name)
					v = v.name
				end
			end
			if (type(v) == "boolean")
			or (type(v) == "function")
				colorcode = "\x84"
			end
			
			if doprint
				print(prefix.."    "..tostring(k).." = "..colorcode..tostring(v))
			end
			table.insert(stringtext,prefix.."    "..tostring(k).." = "..colorcode..tostring(v))
        end
    end
	
	if doprint
		print(prefix.."}")
	end
	table.insert(stringtext,prefix.."}")
	return stringtext
end)

/*
rawset(_G,"Takis_GiveScore",function(p,num)
	num = tonumber($)
	
	if num ~= 0
		local sym = "+"
		local cmap = V_GREENMAP
		if num < 0
			sym = "-"
			cmap = V_REDMAP
		end
		
		table.insert(p.takistable.HUD.scoretext,{
			cmap = cmap,
			trans = V_HUDTRAN,
			text = sym..num,
			ymin = 0,
			tics = TR,
		})
	
		P_AddPlayerScore(p,num)
	
	end
end)
*/

rawset(_G, "TakisAddHurtMsg",function(p,sourcep,enum)

	if enum == nil
		return
	end
	p.takistable.hurtmsg[enum].tics = 2
	
	if p.takistable.inBattle
		CBW_Battle.PrintGameFeed(nil,
			CBW_Battle.CustomHurtMessage(p,sourcep.mo,
				p.takistable.hurtmsg[enum].text
			)
		)
	end
end)

rawset(_G, 'L_FixedDecimal', function(str,maxdecimal)
	if str == nil or tostring(str) == nil
		return '<invalid FixedDecimal>'
	end
	local number = tonumber(str)
	maxdecimal = ($ != nil) and $ or 3
	if tonumber(str) == 0 return '0' end
	local polarity = abs(number)/number
	local str_polarity = (polarity < 0) and '-' or ''
	local str_whole = tostring(abs(number/FRACUNIT))
	if maxdecimal == 0
		return str_polarity..str_whole
	end
	local decimal = number%FRACUNIT
	decimal = FRACUNIT + $
	decimal = FixedMul($,FRACUNIT*10^maxdecimal)
	decimal = $>>FRACBITS
	local str_decimal = string.sub(decimal,2)
	return str_polarity..str_whole..'.'..str_decimal
end)

--reset hammerblast
rawset(_G, "TakisResetHammerTime", function(p)
	local takis = p.takistable
	takis.hammerblastdown = 0
	takis.hammerblastwentdown = false
	takis.hammerblastjumped = 0
	takis.hammerblastgroundtime = 0
end)

rawset(_G, "TakisShotgunify", function(p,forceon)
	local takis = p.takistable
	local me = p.mo
	
	if me.skin ~= TAKIS_SKIN
		return
	end
	
	takis.shotgunforceon = false
	takis.transfo = $|TRANSFO_SHOTGUN
	takis.shotgunned = true
	takis.shotgunforceon = (forceon == true)
	takis.HUD.viewmodel.frameinc = 5*4
	if ultimatemode
		S_ChangeMusic("war",true,p)
	end
	S_StartSound(me,sfx_shgnl)
	
	if not (takis.achfile & ACHIEVEMENT_BOOMSTICK)
		takis.shotguntuttic = 7*TR+(TR/2)
	end
	
	TakisAwardAchievement(p,ACHIEVEMENT_BOOMSTICK)
	
	if not ((takis.shotgun) and (takis.shotgun.valid))
		local x = cos(p.drawangle-ANGLE_90)
		local y = sin(p.drawangle-ANGLE_90)
		
		takis.shotgun = P_SpawnMobjFromMobj(me,16*x,16*y,me.height/2,MT_TAKIS_SHOTGUN)
		takis.shotgun.target = me
		takis.shotgun.angle = p.drawangle
	end
	TakisResetHammerTime(p)
end)

rawset(_G, "TakisDeShotgunify", function(p)
	local takis = p.takistable
	local me = p.mo
	
	if ((takis.shotgun) and (takis.shotgun.valid))
		P_KillMobj(takis.shotgun,me)
	end
	takis.shotgun = 0
	takis.shotgunned = false
	takis.transfo = $ &~TRANSFO_SHOTGUN
	if string.lower(S_MusicName()) == "war"
	and (me.health)
		P_RestoreMusic(p)
	end
	TakisResetHammerTime(p)
end)

--dont set rollangle anymore, it uses extra memory and just looks bad
rawset(_G,"SpawnBam",function(mo,paperextra)
	--local rollfunny = FixedAngle(P_RandomRange(0,359)*FU+P_RandomFixed())
	local angleadd = FixedAngle(P_RandomRange(0,359)*FU+P_RandomFixed())
	local bam3
	local angle = TakisMomAngle(mo)
	local mirrored = P_RandomChance(FU/2)
	local randomstate = P_RandomRange(0,3)
	
	if not paperextra then angleadd = 0 end
	
	local bam = P_SpawnMobjFromMobj(mo,0,0,FixedDiv(mo.height,mo.scale)/2,MT_TNTDUST)
	bam.state = S_TAKIS_IMPACT_1 + randomstate
	bam.angle = angle+ANGLE_90+angleadd
	--bam.rollangle = rollfunny
	bam.renderflags = $|RF_NOSPLATBILLBOARD
	bam.mirrored = mirrored
	
	if paperextra
		bam3 = P_SpawnMobjFromMobj(mo,0,0,FixedDiv(mo.height,mo.scale)/2,MT_TNTDUST)
		bam3.state = S_TAKIS_IMPACT_1 + randomstate
		bam3.angle = angle+ANGLE_180+angleadd
		--bam3.rollangle = rollfunny
		bam3.renderflags = $|RF_NOSPLATBILLBOARD
		bam3.mirrored = mirrored
	end
	
	return bam,bam3
end)

rawset(_G,"TakisChangeHeartCards",function(amt)
	if amt == nil then return end
	if not tonumber(amt) then return end
	amt = abs($)
	
	local oldcards = TAKIS_MAX_HEARTCARDS
	TAKIS_MAX_HEARTCARDS = amt
	for p in players.iterate
		if skins[p.skin].name ~= TAKIS_SKIN then continue end
		if not p.takistable then return end
		local takis = p.takistable
		
		if takis.heartcards ~= oldcards then continue end
		
		takis.heartcards = TAKIS_MAX_HEARTCARDS
	end
end)

rawset(_G,"TakisMenuOpenClose",function(p)
	local takis = p.takistable
	if not takis then return end
	if takis.cosmenu.menuinaction
		takis.cosmenu.menuinaction = false
		takis.HUD.showingletter = false
		P_RestoreMusic(p)
		p.pflags = $ &~PF_FORCESTRAFE		
		return
	end
	
	takis.cosmenu.menuinaction = true
end)

--because im LAZY.
--gets @actor's @type of z for @targ
rawset(_G,"GetActorZ",function(actor,targ,type)
	if type == nil then type = 1 end
	if not (actor and actor.valid) then return 0 end
	if not (targ and targ.valid) then return 0 end
	
	local flip = P_MobjFlip(actor)
	
	--get z
	if type == 1
		if flip == 1
			return actor.z
		else
			return actor.z+actor.height-targ.height
		end
	--get top z
	elseif type == 2
		if flip == 1
			return actor.z+actor.height
		else
			return actor.z-targ.height
		end
		
	--RELATIVE
	--get z
	--since theres a good chance we're using these with P_SpawnMobjFromMobj,
	--make the distances absolute (FU, not mo.scale) since ^ already
	--does that
	elseif type == 3
		if flip == 1
			--ez
			return 0
		else
			return FixedDiv(actor.height-targ.height,actor.scale)
		end
	--get top z
	elseif type == 4
		if flip == 1
			return FixedDiv(actor.height,actor.scale)
		else
			return -FixedDiv(targ.height,actor.scale)
		end
	end
	
	return 0
end)

rawset(_G,"GetControlAngle",function(p)
	return (p.cmd.angleturn << 16) + R_PointToAngle2(0, 0, p.cmd.forwardmove << 16, -p.cmd.sidemove << 16)
end)

rawset(_G,"TakisHurtMsg",function(p,inf,sor,dmgt)
	if (gametype == GT_COOP)
	or (not (p.mo and p.mo.valid))
		return
	end
	if p.spectator
		return
	end
	if not inf
	or not inf.valid
		return
	end
	if not sor
	or not sor.valid
		return
	end
	if not (netgame)
		return
	end
	
	if not (inf.skin == TAKIS_SKIN
	or sor.skin == TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
		
	if takis.inBattle then return end
	
	local livetext = me.health and "hurt" or "killed"
	local sortext = sor.health and '' or "The late "
	
	for i = 0, #takis.hurtmsg
		--print("i "..i)
		--print(takis.hurtmsg[i].tics)
		if takis.hurtmsg[i].tics
			print(sortext..sor.player.ctfnamecolor.."'s "..takis.hurtmsg[i].text.." "..livetext.." "..p.ctfnamecolor)
			return true
		end
	end
end)

--will this be a metal or regular set?
rawset(_G,"MetalOrRegularGibs",function(mo)
	local spawnmetal = true
	
	if ((mo.flags & MF_ENEMY|MF_BOSS)
	or (mo.type == MT_TAKIS_BADNIK_RAGDOLL))
		if (TAKIS_NET.isretro)
			spawnmetal = false
		end
		if mo.takis_metalgibs ~= nil
			spawnmetal = mo.takis_metalgibs
		end
	end
	
	if (mo.type == MT_PLAYER or mo.sprite == SPR_PLAY)
		if not (
			(mo.player and (mo.player.charflags & SF_MACHINE))
			or
			(skins[mo.skin].flags & SF_MACHINE)
		)
			spawnmetal = false
		else
			spawnmetal = true
		end
	end
	
	return spawnmetal
end)

--t is the thing causing, tm is the thing gibbing
local oldgibs = false
rawset(_G,"SpawnEnemyGibs",function(t,tm,ang,fromdoor,nomomentum)
	if (tm.flags & MF_MONITOR) and not tm.takis_monitorgibs then return end
	
	if oldgibs
		local speed
		if (t and t.valid)
			speed = t.player and t.player.takistable.accspeed or FixedHypot(t.momx,t.momy)
			if ang == nil
				ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
			end
		else
			ang = FixedAngle( AngleFixed(R_PointToAngle2(tm.x,tm.y, tm.momx,tm.momy)) + 180*FU)
			speed = FixedHypot(tm.momx,tm.momy)
		end
		
		
		local x,y,z = tm.x,tm.y,tm.z
		
		--midpoint
		if (t and t.valid)
			x = ((t.x + tm.x)/2)+P_RandomRange(-1,1)+P_RandomFixed()
			y = ((t.y + tm.y)/2)+P_RandomRange(-1,1)+P_RandomFixed()
			z = ((t.z + tm.z)/2)+P_RandomRange(-1,1)+P_RandomFixed()
		end
		
		local mo = tm or t
		if not (mo.flags2 & MF2_TWOD)
			ang = $+ANGLE_90
		else
			ang = $+ANGLE_180
		end
		for i = 0,P_RandomRange(5,16)
			local gib = P_SpawnMobj(x,y,z,MT_TAKIS_GIB)
			gib.flags2 = $ &~MF2_TWOD
			gib.scale = mo.scale
			gib.iwillbouncetwice = P_RandomChance(FU/2)
			
			gib.frame = P_RandomRange(A,I)
			if (mo and mo.valid)
				if not fromdoor
					if not MetalOrRegularGibs(mo)
						gib.frame = choosething(A,B,E,G,H,I)
					end
				else
					gib.frame = A
					gib.sprite = states[S_WOODDEBRIS].sprite
					gib.radius = 10*gib.scale
					gib.height = 10*gib.scale
				end
			end
			gib.flags2 = $|(mo.flags2 & MF2_OBJECTFLIP)
			
			local angrng = P_RandomRange(0,1)
			gib.angle = angrng and ang or ang-ANGLE_180
			gib.rollangle = FixedAngle(P_RandomRange(0,359)*FU+P_RandomFixed())
			gib.angleroll = FixedAngle(P_RandomRange(1,15)*FU+P_RandomFixed())*(angrng or -1)
			gib.fuse = 3*TR
			L_ZLaunch(gib,P_RandomRange(6,20)*FU+P_RandomFixed())
			if (t and t.valid)
				P_Thrust(gib,
					R_PointToAngle2(t.x,t.y, tm.x,tm.y),
					speed/6
				)
			end
			P_Thrust(gib,gib.angle,P_RandomRange(1,10)*gib.scale+P_RandomFixed())
		end
	--try new gibs
	else
		local count = P_RandomRange(9,19)
		if fromdoor then count = $/3 end
		if TAKIS_NET.noeffects then count = $/2 end
		
		local tmomx,tmomy = 0,0
		if (t and t.valid)
		and (nomomentum == nil)
			tmomx,tmomy = t.momx*3/4,t.momy*3/4
		end
		
		local mo = tm or t
		for i = 0,count
			
			local fa = FixedAngle(i*FixedDiv(360*FU,count*FU))
			local radius = 15*mo.scale
			local gib = P_SpawnMobjFromMobj(mo,
				P_ReturnThrustX(nil,fa,radius), --FixedMul(cos(fa),radius),
				P_ReturnThrustY(nil,fa,radius), --FixedMul(sin(fa),radius),
				(mo.height/2),
				MT_TAKIS_GIB
			)
			
			gib.flags2 = $ &~MF2_TWOD
			--gib.scale = mo.scale
			gib.iwillbouncetwice = P_RandomChance(FU/2)
			
			gib.frame = P_RandomRange(A,I)
			if (mo and mo.valid)
				if not fromdoor
					if not MetalOrRegularGibs(mo)
						gib.frame = choosething(A,B,E,G,H,I)
					end
				else
					gib.frame = A|FF_PAPERSPRITE
					gib.sprite = states[S_WOODDEBRIS].sprite
				end
			end
			if mo.takis_gibsprite ~= nil
				gib.frame = A
				gib.sprite = mo.takis_gibsprite
			end
			if mo.takis_gibframes ~= nil
				gib.frame = choosething(unpack(mo.takis_gibframes))
			end
			if mo.takis_gibframeflags ~= nil
				gib.frame = $|(mo.takis_gibframeflags &~FF_FRAMEMASK)
			end
			
			if gib.frame & FF_PAPERSPRITE
				gib.radius = 10*gib.scale
				gib.height = 10*gib.scale
			end
			gib.flags2 = $|(mo.flags2 & MF2_OBJECTFLIP)
			
			local angrng = P_RandomRange(0,1)
			gib.angle = fa
			gib.angleadd = FixedAngle(P_RandomRange(1,15)*FU+P_RandomFixed())*(angrng or -1)
			gib.rollangle = FixedAngle(P_RandomRange(0,359)*FU+P_RandomFixed())
			gib.angleroll = FixedAngle(P_RandomRange(1,15)*FU+P_RandomFixed())*(angrng or -1)
			gib.fuse = 3*TR
			L_ZLaunch(gib,P_RandomRange(4,15)*FU+P_RandomFixed())
			/*
			if (t and t.valid)
				P_Thrust(gib,
					R_PointToAngle2(t.x,t.y, tm.x,tm.y),
					speed/6
				)
			end
			*/
			P_Thrust(gib,gib.angle,P_RandomRange(1,10)*gib.scale+P_RandomFixed())
			gib.momx,gib.momy = $1+tmomx,$2+tmomy
		end
	end
end)

rawset(_G,"CanFlingThing",function(en,flags,fromcolat)
	local flingable = false
	flags = $ or MF_ENEMY|MF_BOSS|MF_MONITOR
	
	if not (en and en.valid) then return false end
	
	if (en.flags2 & MF2_FRET)
		return false
	end
	
	if en.dontclutchintome ~= nil then return false end
	
	if en.flags & (flags)
		flingable = true
	end
	
	if en.takis_flingme ~= nil
		if en.takis_flingme == true
			flingable = true
		elseif en.takis_flingme == false
			flingable = false
		end
	end
	
	if fromcolat
		if en.takis_nocollateral == true
			flingable = false
		end
	end
	
	if (en.type == MT_EGGMAN_BOX or en.type == MT_EGGMAN_GOLDBOX) then flingable = false end
	return flingable
	
end)

rawset(_G, 'L_ZLaunch', function(mo,thrust,relative)
	if mo.eflags&MFE_UNDERWATER
		thrust = FixedMul($,FixedDiv(117*FU,200*FU))	--lmao
	end
	P_SetObjectMomZ(mo,thrust,relative)
end)

--AAAAHHHH!
rawset(_G,"TakisJumpscare",function(p,wega)
	local takis = p.takistable
	TakisAwardAchievement(p,ACHIEVEMENT_JUMPSCARE)
	takis.HUD.funny.tics = 3*TR
	takis.HUD.funny.y = 400*FU
	takis.HUD.funny.alsofunny = P_RandomChance(FU/10)
	--wega
	if not takis.HUD.funny.alsofunny
	or (wega == true)
		takis.HUD.funny.wega = (wega) and true or P_RandomChance(FU/4)
		if takis.HUD.funny.wega
			S_SetInternalMusicVolume(0,p)
			S_FadeMusic(100,3*MUSICRATE,p)
			S_StartSound(nil,sfx_wega,p)
			return
		end
	end
	S_StartSound(nil,sfx_jumpsc,p)
end)

rawset(_G,"TakisSpawnConfetti",function(mo)
	if not (mo and mo.valid) then return end
	
	local spawner = P_SpawnMobjFromMobj(mo,0,0,0,MT_THOK)
	spawner.flags2 = $|MF2_DONTDRAW
	spawner.angle = mo.angle
	
	for i = 0, P_RandomRange(10,17)
		spawner.angle = $+FixedAngle(P_RandomRange(-130,130)*FU+P_RandomFixed())
		
		local fet = P_SpawnMobjFromMobj(spawner,
			P_ReturnThrustX(nil,spawner.angle,P_RandomRange(4,15)*mo.scale) + mo.momx,
			P_ReturnThrustY(nil,spawner.angle,P_RandomRange(4,15)*mo.scale) + mo.momy,
			mo.momz,
			MT_TAKIS_FETTI
		)
		P_SetOrigin(fet,fet.x,fet.y,GetActorZ(mo,fet,2))
		fet.scale = mo.scale+((P_RandomFixed()*(P_RandomRange(0,1) and 1 or -1))/2)
		fet.angle = spawner.angle
		
		P_Thrust(fet,fet.angle,P_RandomRange(0,3)*fet.scale+P_RandomFixed())
		P_SetObjectMomZ(fet,P_RandomRange(2,5)*FU+P_RandomFixed())
		
		fet.rngspin = P_RandomRange(0,1) and 1 or -1
		fet.rollangle = FixedAngle(P_RandomRange(0,130)*FU+P_RandomFixed()*fet.rngspin)
		
		local salmon = ColorOpposite(mo.color or SKINCOLOR_FOREST)
		local minsal = max(salmon-3,1)
		local maxsal = min(salmon+3,#skincolors)
		local colortobe = P_RandomRange(minsal,maxsal)
		
		fet.color = colortobe
		
		fet.frame = P_RandomRange(A,D)
		
	end
end)

rawset(_G,"TakisDoClutch",function(p)
	local me = p.mo
	local takis = p.takistable
	
	if not (me and me.valid) then return end
	
	--but wait! first thing we needa do is check if we're
	--allowed to clutch on a rollout rock
	if (p.powers[pw_carry] == CR_ROLLOUT)
		local rock = me.tracer
		local inwater = rock.eflags & (MFE_TOUCHWATER|MFE_UNDERWATER)
		--if the rock isnt grounded, dont clutch
		if not (P_IsObjectOnGround(rock) or inwater)
			return
		end
	end
	
	local ccombo = min(takis.clutchcombo,3)
	
	if ccombo >= 3
		if me.friction < FU
			me.friction = FU
			takis.frictionfreeze = 10
		end
	end
	
	local israkis = p.skincolor == SKINCOLOR_SALMON
	if G_GametypeHasTeams()
	and (skincolor_redteam == SKINCOLOR_SALMON
	or skincolor_blueteam == SKINCOLOR_SALMON)
	and (p.skincolor == SKINCOLOR_SALMON)
		israkis = false
	end
	
	if not israkis
		S_StartSoundAtVolume(me,sfx_clutch,255/2)
	else
		S_StartSoundAtVolume(me,sfx_cltch3,255*4/5)
	end
	if not takis.clutchingtime
		S_StartSoundAtVolume(me,sfx_cltch2,255*4/5)
	end
	
	takis.clutchingtime = 1
	--print(takis.clutchtime)
	
	local thrust = FixedMul( (4*FU), (ccombo*FU)/2 )
	
	--not too fast, now
	if thrust >= 13*FU
	--and not (p.powers[pw_sneakers])
		thrust = 13*FU
	end
	local maxthrust = thrust
	
	local clutchadjust = takis.clutchtime --max((takis.clutchtime - p.cmd.latency),0)
	
	--clutch boost
	if (clutchadjust > 0)
		if (clutchadjust <= 11)
			--if takis.clutchcombo > 1
			
				takis.clutchcombo = $+1
				takis.clutchcombotime = 2*TR
				
				S_StartSoundAtVolume(me,sfx_kc5b,255/3)
				if ccombo >= 3
					S_StartSoundAtVolume(me,sfx_cltch2,255/2)
				end
				if takis.clutchcombo >= 6
					local volume = min(
						(takis.clutchcombo - 5)*12,
						215 + P_RandomRange(-5,10)
					)
					S_StartSoundAtVolume(me,sfx_cltch4,volume)
				end
				
				--effect
				local ghost = P_SpawnGhostMobj(me)
				ghost.scale = 3*me.scale/2
				ghost.destscale = FixedMul(me.scale,2)
				ghost.colorized = true
				ghost.frame = $|TR_TRANS10
				ghost.blendmode = AST_ADD
				for i = 0, 4 do
					P_SpawnSkidDust(p,25*me.scale)
				end
				if not G_RingSlingerGametype()
					P_ElementalFire(p)
					takis.clutchfirefx = 2
				end
				
				ghost.momx,ghost.momy = me.momx,me.momy
				ghost.momz = takis.rmomz
				
				--P_Thrust(me,p.drawangle,3*me.scale/2)
				thrust = $+(3*FU/2)+FU
			--end
		--dont thrust too early, now!
		elseif clutchadjust > 16
			
			takis.clutchspamcount = $+1
			takis.clutchcombo = 0
			takis.clutchcombotime = 0
			thrust = FU/5
			if takis.clutchspamcount >= 3
				thrust = 0
			end
			
		end
	end
	
	/*
	for i = 0, 10 do
		P_SpawnSkidDust(p,15*me.scale)
	end
	*/
	
	--you can clutch out of slides, but dont abuse it
	--ok people are abusing this too much, you cant clutch out of slides at all
	if (p.pflags & PF_SPINNING)
	and (takis.accspeed > 50*FU)
	and not (takis.transfo & TRANSFO_BALL)
		thrust = 0
		P_InstaThrust(me,GetControlAngle(p),FixedMul(min(takis.accspeed*3/4,50*FU),me.scale))
		S_StartSound(me,sfx_didbad)
		me.movefactor = $/2
	end
	
	if p.powers[pw_sneakers]
		thrust = $*9/5
	end
	
	if p.gotflag
		thrust = $/6
	end
	
	--stop that stupid momentum mod from givin
	--us super speed for spamming
	if thrust == 0
	and not p.powers[pw_sneakers]
	and (takis.clutchspamcount >= 3)
		P_InstaThrust(me,GetControlAngle(p),FixedDiv(
				FixedMul(takis.accspeed,me.scale),
				3*FU
			)
		)
	end
	
	if (takis.accspeed > ((p.powers[pw_sneakers] or takis.isSuper) and 70*FU or 50*FU))
		takis.frictionfreeze = 10
		me.friction = FU
		thrust = 0
	end
	
	
	local mo = (p.powers[pw_carry] == CR_ROLLOUT) and me.tracer or me
	thrust = FixedMul(thrust,me.scale)
	
	local twod = (mo.flags2 & MF2_TWOD or twodlevel)
	local ang = (takis.io.nostrafe and not twod) and GetControlAngle(p) or me.angle
	
	if twod
		thrust = $/4
	end
	
	local speedmul = FU
	if twod
		speedmul = $*3/4
	end
	if (takis.inWater)
	and not twod
		speedmul = $*3/4
	end
	if (p.gotflag)
		speedmul = $*7/10
	end
	
	p.pflags = $ &~PF_SPINNING
	if mo == me
		P_Thrust(mo,ang,thrust)
		p.drawangle = ang
	else
		P_InstaThrust(mo,ang,
			FixedHypot(mo.momx,mo.momy)+thrust
		)
		p.drawangle = FixedAngle(AngleFixed(ang)+180*FU)
	end
	
	local runspeed = FixedMul(skins[TAKIS_SKIN].runspeed,speedmul)
	if takis.accspeed < runspeed
		P_Thrust(mo,ang,FixedMul(runspeed-takis.accspeed,me.scale))
	end
	
	--xmom code
	local d1,d2
	if takis.notCarried
		d1 = P_SpawnMobjFromMobj(me, -20*cos(ang + ANGLE_45), -20*sin(ang + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
		d2 = P_SpawnMobjFromMobj(me, -20*cos(ang - ANGLE_45), -20*sin(ang - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
		d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5
		d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
		
		d1.momx,d1.momy = mo.momx/2,mo.momy/2
		d2.momx,d2.momy = mo.momx/2,mo.momy/2
		d1.momz = takis.rmomz
		d2.momz = takis.rmomz
	end
	
	if takis.onGround
		me.state = S_PLAY_DASH
		P_MovePlayer(p)
		p.panim = PA_DASH
	end
	takis.clutchtime = 23
	takis.clutchspamtime = 23
	
	if takis.clutchspamcount == 5
		TakisAwardAchievement(p,ACHIEVEMENT_CLUTCHSPAM)
	end
	
	local combod = false
	if takis.clutchcombo <= 1
		p.jp = 2
		p.jt = -5
	else
		combod = true
		p.jp = 3
		p.jt = -8
	end
	
	takis.coyote = 0
	
	for j = -1,1,2
		for i = 3,P_RandomRange(4,7)
			local spark = TakisKart_SpawnSpark(me,
				ang+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
				SKINCOLOR_ORANGE,
				true,
				true
			)
			local dust = TakisSpawnDust(me,
				ang+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
				P_RandomRange(0,-50),
				P_RandomRange(-1,2)*me.scale,
				{
					xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = P_RandomRange(0,-10)*me.scale,
					thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					momz = (P_RandomRange(4,0)*i)*(me.scale/2),
					momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
					
					scale = me.scale,
					scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					fuse = 15+P_RandomRange(-5,5),
				}
			)
			if combod
				spark.scale = $*3/2
				if P_RandomChance(FU/2)
				or i <= 5
					dust.color = p.skincolor
					dust.colorized = true
					dust.blendmode = AST_ADD
					spark.color = dust.color
				end
			end
		end
		if combod
			local dustef = P_SpawnMobjFromMobj(me,
				P_ReturnThrustX(nil,ang + (ANGLE_45*j),FixedDiv(me.radius,me.scale) + 6*FU),
				P_ReturnThrustY(nil,ang + (ANGLE_45*j),FixedDiv(me.radius,me.scale) + 6*FU),
				0,
				MT_TAKIS_DRIFTSPARK
			)
			dustef.tracer = me
			dustef.angle = R_PointToAngle2(dustef.x,dustef.y,
				mo.x + mo.momx,
				mo.y + mo.momy
			)
			dustef.fuse = TR/4
			--dustef.scalespeed = FixedDiv(dustef.scale - 1,dustef.fuse*FU)
			--dustef.destscale = 0
			dustef.color = p.skincolor
			dustef.momx = mo.momx*3/4
			dustef.momy = mo.momy*3/4
			P_Thrust(dustef,
				ang + (ANGLE_90*j),
				5*mo.scale
			)
			dustef.scale = $*12/10
		end
	end
	
	takis.noability = $ &~NOABIL_AFTERIMAGE
end)

rawset(_G,"TakisFollowThingThink",function(follow,tracer,ztype,doscale)
	if not (follow and follow.valid) then return end
	if not (tracer and tracer.valid) then return true end
	
	if ztype ~= false
		if ztype == nil
			if mobjinfo[follow.type].takis_ztype ~= nil
				ztype = mobjinfo[follow.type].takis_ztype
			else
				ztype = 1
			end
		end
		if ztype > 2 then ztype = 2 end
		ztype = abs($)
	end
	
	--Cool
	if follow.type == MT_SOAP_SUPERTAUNT_FLYINGBOLT
		ztype = false
	end
	
	local tplr = tracer.player
	if not (tplr and tplr.valid)
		tplr = displayplayer
	end
	
	follow.takis_vfx = true
	if TakisShouldIHideInFP(follow,tplr)
		follow.flags2 = $|MF2_DONTDRAW
	else
		follow.flags2 = $ &~MF2_DONTDRAW
	end
	
	if tracer.skin ~= TAKIS_SKIN
	and (tracer.type == MT_PLAYER)
	and (follow.allowothers ~= true)
		follow.flags2 = $|MF2_DONTDRAW
	end
	
	if tracer.flags2 & MF2_DONTDRAW
		follow.flags2 = $|MF2_DONTDRAW
	end
	
	if tracer.eflags & MFE_VERTICALFLIP
		follow.eflags = $|MFE_VERTICALFLIP
	else
		follow.eflags = $ &~MFE_VERTICALFLIP
	end
	
	if ztype ~= false
		P_MoveOrigin(follow,
			tracer.x,
			tracer.y,
			GetActorZ(tracer,follow,ztype)
		)
	end
	
	follow.scale = tracer.scale
	if mobjinfo[follow.type].takis_doscale ~= nil
		doscale = mobjinfo[follow.type].takis_doscale
	end
	if doscale
		follow.spritexscale,follow.spriteyscale = tracer.spritexscale,tracer.spriteyscale	
	end
	
end)

rawset(_G,"R_GetScreenCoords",function(v, p, c, mx, my, mz)
	
	local camx, camy, camz, camangle, camaiming
	if p.awayviewtics then
		camx = p.awayviewmobj.x
		camy = p.awayviewmobj.y
		camz = p.awayviewmobj.z
		camangle = p.awayviewmobj.angle
		camaiming = p.awayviewaiming
	elseif c.chase then
		camx = c.x
		camy = c.y
		camz = c.z
		camangle = c.angle
		camaiming = c.aiming
	else
		camx = p.mo.x
		camy = p.mo.y
		camz = p.viewz-20*FRACUNIT
		camangle = p.mo.angle
		camaiming = p.aiming
	end

	-- Lat: I'm actually very lazy so mx can also be a mobj!
	if type(mx) == "userdata" and mx.valid
		my = mx.y
		mz = mx.z
		mx = mx.x	-- life is easier
	end

	local x = camangle-R_PointToAngle2(camx, camy, mx, my)

	local distfact = cos(x)
	if not distfact then
		distfact = 1
	end -- MonsterIestyn, your bloody table fixing...

	if x > ANGLE_90 or x < ANGLE_270 then
		return -320, -100, 0, true	--pass on extra "dontdraw" parameter
	else
		x = FixedMul(tan(x, true), 160<<FRACBITS)+160<<FRACBITS
	end
	
	local pointtodist = R_PointToDist2(camx, camy, mx, my)
	if not pointtodist then
		pointtodist = 1
	end
	
	
	local y = camz-mz
	if y == 0
	or pointtodist == 0
	or distfact == 0
		return -320, -100, 0, true
	end
	
	--print(y/FRACUNIT)
	y = FixedDiv(y, FixedMul(distfact, pointtodist))
	y = (y*160)+(100<<FRACBITS)
	y = y+tan(camaiming, true)*160
 
	local scale = FixedDiv(160*FRACUNIT, FixedMul(distfact, pointtodist))
	--print(scale)

	return x, y, scale
end)

rawset(_G,"TakisSpawnDust",function(me,angle,dist,z,options)
	if options == nil
		options = {
			xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
			yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
			zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
			
			thrust = 0,
			thrustspread = 0,
			
			momz = P_RandomRange(6,1)*me.scale,
			momzspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
			
			scale = me.scale,
			scalespread = FixedMul((P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),me.scale),
			
			fuse = 20,
		}
		if TAKIS_DEBUGFLAG
			print("\x83TAKIS: TakisSpawnDust(): options is nil")
		end
	end
	
	local type = MT_TAKIS_STEAM
	local inwater = me.eflags & (MFE_UNDERWATER|MFE_TOUCHLAVA) == MFE_UNDERWATER
	if inwater
		type = choosething(MT_SMALLBUBBLE,MT_MEDIUMBUBBLE)
		options.scale = $*2
	end
	
	--TODO: dist MUST be fixed_t
	local x,y = cos(angle),sin(angle) --ReturnTrigAngles(angle)
	local steam = P_SpawnMobjFromMobj(me,
		dist*x + (options.xspread or 0),
		dist*y + (options.yspread or 0),
		z + (options.zspread or 0),
		type
	)
	steam.angle = angle
	P_Thrust(steam,
		steam.angle,
		(options.thrust or 0) + (options.thrustspread or 0)
	)
	L_ZLaunch(steam,
		FixedDiv((options.momz or 0),me.scale) + (options.momzspread or 0),
		false
	)
	steam.scale = (options.scale or me.scale) + FixedMul((options.scalespread or 0),me.scale)
	steam.timealive = 1
	steam.tracer = me
	steam.destscale = 4
	steam.fuse = (options.fuse or 16)
	steam.startfuse = steam.fuse
	steam.startscale = steam.scale
	if not inwater
	and not TAKIS_NET.noeffects
		steam.rollangle = $+(ANGLE_180*(P_RandomChance(FU/2) and 1 or 0))
	end
	return steam
end)

rawset(_G,"TakisSpawnPongler",function(mo,ang)
	local pong = P_SpawnMobjFromMobj(mo,
		P_ReturnThrustX(nil,ang+ANGLE_90,mo.radius),
		P_ReturnThrustY(nil,ang+ANGLE_90,mo.radius),
		mo.height/2,
		MT_TAKIS_PONGLER
	)
	pong.momz = 3*mo.scale*P_MobjFlip(mo)
	
	local oldscale = pong.scale
	pong.scale = $/6
	pong.destscale = oldscale
	pong.scalespeed = 0
	
	pong.angle = ang+ANGLE_90
	pong.frame = P_RandomRange(A,states[S_TAKIS_PONGLER].var1)
	pong.flags2 = $|MF2_DONTDRAW
	return pong
end)

rawset(_G,"CanFlingSolid",function(t,tm)
	local flingable = false
	local flags = MF_SOLID|MF_SCENERY
	
	if not (t and t.valid) then return false end
	
	if t.flags & (flags) == flags
		flingable = true
	end
	
	if t.takis_flingme ~= nil
		flingable = false
	end
	
	if (t.flags & (MF_SPECIAL|MF_ENEMY|MF_MONITOR|MF_PUSHABLE))
	or (tm and tm.valid and t.parent == tm)
	or (t.type == MT_PLAYER)
		flingable = false
	end
	
	return flingable
	
end)

rawset(_G,"GetPainThrust",function(mo,inf,sor)
	local thrust = 4*FU
	
	if (inf and inf.valid)
		if ((inf.flags2 & MF2_SCATTER) and sor)
			local dist = FixedHypot(FixedHypot(sor.x-mo.x, sor.y-mo.y),sor.z-mo.z)
			dist = 128*inf.scale - dist/4
			if dist < 4*inf.scale
				dist = 4*inf.scale
			end
			thrust = dist
		elseif ((inf.flags2 & MF2_EXPLOSION) and sor)
			if (inf.flags2 & MF2_RAILRING)
				thrust = 38*inf.scale
			else
				thrust = 30*inf.scale
			end
		elseif inf.flags2 & MF2_RAILRING
			thrust = 45*inf.scale
		end
	end
	return FixedMul(thrust,mo.scale)
	
end)

--well... dont mind if i do
--CRIPSHYCHARS
rawset(_G, "TakisSpawnDustRing", function(mo, speed, thrust, num, alwaysabove)
	local momz = mo.momz
	if alwaysabove
		momz = -P_MobjFlip(mo)*abs($)
	end
	if abs(momz) < mo.scale
		momz = $ < 0 and -mo.scale or mo.scale
	end
		
	local forwardangle = TakisMomAngle(mo)
	local sideangle = forwardangle + ANGLE_90
	local vangle = R_PointToAngle2(0, 0, FixedHypot(mo.momx, mo.momy), momz)
	
	local cosine = cos(vangle)
	local sine = sin(vangle)
	
	local radius = FixedDiv(mo.height, mo.scale) >> 1
	local xspawn = -FixedMul(FixedMul(cos(forwardangle), cosine), radius)
	local yspawn = -FixedMul(FixedMul(sin(forwardangle), cosine), radius)
	local zspawn = -FixedMul(sine, radius)
	
	local hthrust = 0
	local vthrust = 0
	if thrust
		hthrust = FixedMul(thrust, cosine)
		vthrust = FixedMul(thrust, sine)
	end
	
	cosine = FixedMul($, speed)
	sine = FixedMul($, speed)
	
	local dustlist = {}
	
	num = $ or 16
	for i = 1, num
		local type = MT_TAKIS_STEAM
		local inwater = mo.eflags & (MFE_UNDERWATER|MFE_TOUCHLAVA) == MFE_UNDERWATER
		if inwater
			type = choosething(MT_SMALLBUBBLE,MT_MEDIUMBUBBLE)
		end
		
		local dust = P_SpawnMobjFromMobj(mo, xspawn, yspawn, radius, type)
		
		local a = FixedAngle(i*FixedDiv(360*FU,num*FU)) + forwardangle
		
		local forwardthrust = FixedMul(cos(a), sine)
		local sidethrust = FixedMul(sin(a), speed)
		local zthrust = FixedMul(cosine, cos(a))
		
		dust.z = $ + zspawn
		
		P_Thrust(dust, forwardangle, forwardthrust - hthrust)
		P_Thrust(dust, sideangle, sidethrust)
		dust.momz = -zthrust - vthrust
			
		dust.fuse = 20
		dust.timealive = 1
		dust.tracer = mo
		dust.destscale = 1
		dust.startfuse = dust.fuse
		dust.startscale = dust.scale
		if not inwater
			dust.rollangle = $+(ANGLE_180*(P_RandomChance(FU/2) and 1 or 0))
		else
			dust.scale = $*2
		end
		table.insert(dustlist,dust)
	end
	return dustlist
end)

rawset(_G,"TakisKart_SpawnSpark",function(car,angle,color,realspark,nobackthrust)
	local momx,momy = car.momx, car.momy
	if nobackthrust == true
		momx,momy = 0,0
	end
	local type = MT_TAKIS_SPARK
	local inwater = car.eflags & (MFE_UNDERWATER|MFE_TOUCHLAVA) == MFE_UNDERWATER
	if inwater
		type = choosething(MT_SMALLBUBBLE,MT_MEDIUMBUBBLE)
	end
	local spark = P_SpawnMobjFromMobj(car,
		P_ReturnThrustX(nil,angle,-FixedDiv(car.radius,car.scale)),
		P_ReturnThrustY(nil,angle,-FixedDiv(car.radius,car.scale)),
		(P_RandomRange(-1,2)*FU)+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
		type
	)
	local lifetime = P_RandomRange(states[spark.info.spawnstate].var1,states[spark.info.spawnstate].var2)
	spark.angle = angle
	spark.blendmode = AST_ADD
	spark.tics = lifetime
	spark.scale = car.scale
	L_ZLaunch(spark,(P_RandomRange(6,10)*FU)+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)))
	if nobackthrust ~= 1
		P_Thrust(spark,
			spark.angle,
			P_RandomRange(-4,-6)*2*car.scale--+(FixedHypot(car.momx,car.momy)/2)
		)
	end
	spark.momx,spark.momy = $1+momx,$2+momy
	spark.fmomx,spark.fmomy = momx,momy
	
	spark.destscale = 0
	spark.color = color
	if realspark
	and (spark.type ~= MT_TAKIS_SPARK)
		spark.isrealspark = true
		--spark.blendmode = 0
	end
	return spark
end)

rawset(_G,"TakisKart_DriftSparkValue",function(stats)
	if stats == nil
		stats = {9,4}
	end
	local kartspeed = stats[1]
	return (26*4 + kartspeed*2 + (9-stats[2]))*8
end)

rawset(_G,"TakisKart_DriftLevel",function(stats,driftspark)
	if type(stats) ~= "table"
		driftspark = stats
		stats = {9,4}
	end
	local level = 0
	if driftspark >= TakisKart_DriftSparkValue(stats)*4
		level = 5
	elseif driftspark >= TakisKart_DriftSparkValue(stats)*3
		level = 4
	elseif driftspark >= TakisKart_DriftSparkValue(stats)*2
		level = 3
	elseif driftspark >= TakisKart_DriftSparkValue(stats)
		level = 2
	elseif driftspark < TakisKart_DriftSparkValue(stats)
		level = 1
	end
	return level
end)

local driftclr = {
	[5] = "spec",
	[4] = SKINCOLOR_GALAXY,
	[3] = SKINCOLOR_SALMON,
	[2] = SKINCOLOR_SAPPHIRE,
	[1] = SKINCOLOR_SILVER,
	[0] = SKINCOLOR_SILVER
}

rawset(_G,"TakisKart_DriftColor",function(driftlevel,timer)
	local clr = driftclr[driftlevel] or SKINCOLOR_SILVER
	if clr == "spec"
		if timer == nil then timer = leveltime end
		clr = SKINCOLOR_LAVENDER + (timer % (SKINCOLOR_SUPERSILVER1-SKINCOLOR_LAVENDER))
	end
	return clr
end)

-- https://github.com/STJr/Kart-Public/blob/master/src/k_kart.c
-- line 2551
rawset(_G,"TakisFancyExplode",function(tracer,x,y,z,radius,count,type,minz,maxz,centered)
	local OLDEXPLOSION = (TAKIS_NET.noeffects) == false
	if OLDEXPLOSION
		count = 5
		
		local placehold = P_SpawnMobj(x,y,z,MT_RAY)
		
		local anglecount = FixedDiv(360*FU,count*FU)
		for i = 0,count
			local fa = FixedAngle(anglecount*i)
			local mobj = P_SpawnMobjFromMobj(placehold,
				FixedMul(cos(fa),radius),
				FixedMul(sin(fa),radius),
				0, --FU - FixedMul(mobjinfo[type].height,tracer.scale)/2,
				MT_THOK
			)
			mobj.flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPTHING|MF_RUNSPAWNFUNC
			mobj.state = S_TAKIS_EXPLODE
			mobj.momz = 0
			--mobj.spritexscale,mobj.spriteyscale = FU*2,FU*2
			mobj.flags2 = $ &~MF2_DONTDRAW
			
			mobj.angle = R_PointToAngle2(mobj.x,mobj.y, placehold.x,placehold.y)
			mobj.scale = $+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))
			
			P_Thrust(mobj, mobj.angle,
				-6*mobj.scale
			)
			P_SetObjectMomZ(mobj,P_RandomRange(minz,maxz)*FU)
			mobj.oldfx = true
			
			/*
			local dist = FixedHypot(FixedHypot(placehold.x - mobj.x,placehold.y - mobj.y),placehold.z - mobj.z)
			dist = max($,1)
			local pos = {
				x = mobj.x,
				y = mobj.y,
				z = mobj.z
			}
			
			if centered
				mobj.x,mobj.y,mobj.z = x,y,z
			end
			
			mobj.momx = FixedMul(FixedDiv(pos.x - x, dist), FixedDiv(dist, 6*FU))
			mobj.momy = FixedMul(FixedDiv(pos.y - y, dist), FixedDiv(dist, 6*FU))
			mobj.momz = FixedMul(FixedDiv(pos.z - z, dist), FixedDiv(dist, 6*FU))
			mobj.momz = $+P_RandomRange(minz,maxz)*mobj.scale
			mobj.flags = $|MF_NOCLIPTHING
			mobj.takis_vfx = true
			mobj.tracer = tracer
			*/
			
		end
		P_RemoveMobj(placehold)
	else
		local placehold = P_SpawnMobj(x,y,z,MT_THOK)
		placehold.flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPTHING|MF_RUNSPAWNFUNC
		placehold.state = S_TAKIS_EXPLODE
		placehold.momz = 0
		placehold.scale = FU*2
		placehold.z = $ - placehold.height/2
		placehold.flags2 = $ &~MF2_DONTDRAW
		--placehold.spawnedfrom = true
		--placehold.takis_vfx = true
		--placehold.fancyexplode = true
		--placehold.scale = 
	end
end)

local function forcehambounce(p)
	local me = p.realmo
	local takis = p.takistable
	
	TakisDoHammerBlastLand(p,false)
	
	if (takis.transfo & TRANSFO_SHOTGUN)
		return
	end
	
	takis.hammerblastjumped = 1
	
	P_DoJump(p,false)
	me.state = S_PLAY_ROLL
	
	local momz = 15*FU
	if takis.jump > 0
	and me.health
	and not ((takis.inPain) or (takis.inFakePain))
	and not (takis.noability & NOABIL_THOK)
		momz = 19*FU
	end
	L_ZLaunch(me,momz)
	
	S_StartSoundAtVolume(me,sfx_kc52,180)
	
	p.pflags = $|PF_JUMPED &~PF_THOKKED
	takis.thokked = false
	takis.dived = false
end

rawset(_G,"TakisDoHammerBlastLand",function(p,domoves)
	local me = p.realmo
	local takis = p.takistable

	--dust effect
	--if not (me.eflags & MFE_TOUCHWATER)
	if not (takis.shotgunned)
		local maxi = 16+abs(takis.lastmomz*takis.gravflip/me.scale/5)
		for i = 0, maxi
			local radius = FU*16
			local fa = FixedAngle(i*(FixedDiv(360*FU,maxi*FU)))
			local mz = takis.lastmomz/7
			local dust = TakisSpawnDust(me,
				fa,
				0,
				P_RandomRange(-1,2)*me.scale,
				{
					xspread = 0,
					yspread = 0,
					zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = 0,
					thrustspread = 0,
					
					momz = P_RandomRange(0,1)*me.scale,
					momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
					
					scale = me.scale,
					scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					
					fuse = 23+P_RandomRange(-2,3),
				}
			)
			dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
			dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
			
		end
	end
	
	if takis.inBattle
		for play in players.iterate
			if play.spectator then continue end
			if play == p then continue end
			if not CanPlayerHurtPlayer(p,play) then continue end
			
			local found = play.mo
			
			if not (found and found.valid) then continue end
			if not (found.health) then continue end
			if (play.tumble) then continue end
			
			local dist = FixedHypot(FixedHypot(found.x - me.x, found.y - me.y),found.z - me.z)
			local maxdist = abs(takis.lastmomz)*11/2
			
			if dist > maxdist then continue end
			
			local tics = abs(takis.lastmomz)/me.scale
			
			CBW_Battle.DoPlayerTumble(play,tics,
				R_PointToAngle2(found.x,found.y,
					me.x,me.y
				),
				abs(takis.lastmomz)
			)
			
		end
		p.lockmove = false
		p.melee_state = 0
	end
	
	--impact sparks
	local superspeed = -60*me.scale
	if ((takis.lastmomz*takis.gravflip) <= superspeed)
		S_StartSound(me,sfx_s3k9b)
		local radius = abs(takis.lastmomz)
		if (p.powers[pw_shield] == SH_ARMAGEDDON)
			radius = $*2
		end
		
		for i = 0, 16
			local fa = (i*ANGLE_22h)
			local spark = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
			spark.momx = FixedMul(sin(fa),radius)
			spark.momy = FixedMul(cos(fa),radius)
			local spark2 = P_SpawnMobjFromMobj(me,0,0,0,MT_SUPERSPARK)
			spark2.color = me.color
			spark2.momx = FixedMul(sin(fa),radius/20)
			spark2.momy = FixedMul(cos(fa),radius/20)
		end
		DoQuake(p,FU*37,20)
		
		if not (G_RingSlingerGametype() or TAKIS_NET.hammerquakes == false)
			--KILL!
			local rad = takis.lastmomz
			local px = me.x
			local py = me.y
			local br = abs(rad*10)
			
			searchBlockmap("objects", function(me, found)
				if not (found and found.valid) then return end
				if not (found.health) then return end
				if (found.takis_nocollateral == true) then return end
				if (found.alreadykilledthis) then return end
				
				local dist = FixedHypot(FixedHypot(found.x - me.x, found.y - me.y),found.z - me.z)
				if dist > br then return end
				
				if CanFlingThing(found,nil,true)
					if not (found.flags & MF_BOSS)
						found.alreadykilledthis = true
					end
					local rag = SpawnRagThing(found,me)
					if (rag and rag.valid)
						S_StartSound(rag,sfx_sdmkil)
					end
				elseif (found.type == MT_PLAYER)
					if CanPlayerHurtPlayer(p,found.player)
						TakisAddHurtMsg(found.player,p,HURTMSG_HAMMERQUAKE)
						P_DamageMobj(found,me,me,abs(me.momz/FU/4))
					end
					DoQuake(found.player,
						FixedMul(
							75*FU, FixedDiv( br-FixedHypot(found.x-me.x,found.y-me.y),br )
						),
						15
					)
				elseif (SPIKE_LIST[found.type] == true)
				and (found.takis_nocollateral ~= true)
					found.alreadykilledthis = true
					P_KillMobj(found,me,me)
				end
			end, me, px-br, px+br, py-br, py+br)		
		end
	end
	
	if not (takis.shotgunned)
		S_StartSoundAtVolume(me, sfx_pstop,4*255/5)
	else
		S_StartSound(me,sfx_slam)
	end
	S_StartSound(me,sfx_takmcn)
	
	local quake = 40*FU
	if (takis.shotgunned)
		quake = 55*FU
	end
	DoQuake(p,quake,15)
	P_MovePlayer(p)
	if TakisBreakAndBust(p,me)
		forcehambounce(p)
		return
	end
	
	if not (takis.shotgunned)
	and domoves
		--holding jump while landing? boost us up!
		if takis.jump > 0
		and me.health
		and not ((takis.inPain) or (takis.inFakePain))
		and not (takis.noability & NOABIL_THOK)
			local time = min(takis.hammerblastdown,TR*25/10)
			if p.powers[pw_shield] == SH_WHIRLWIND
				time = $*3/2
			end
			local basemomz = 20*FU
			if p.powers[pw_shield] == SH_BUBBLEWRAP
			or p.powers[pw_shield] == SH_ELEMENTAL
				basemomz = 25*FU
			end
			
			takis.hammerblastjumped = 1
			
			P_DoJump(p,false)
			me.state = S_PLAY_SPINDASH
			L_ZLaunch(me,basemomz+(time*FU/8)*takis.gravflip)
			
			S_StartSoundAtVolume(me,sfx_kc52,180)
			p.jp = 1
			p.jt = 5
			
			p.pflags = $|PF_JUMPED &~PF_THOKKED
			takis.thokked = false
			
			takis.noability = $|NOABIL_SLIDE
			
		--holding spin while landing? boost us forward!
		elseif (takis.use > 0)
		and me.health
		and not (takis.noability & NOABIL_CLUTCH)
			if not takis.dropdashstale
				S_StartSound(me,sfx_cltch2)
			else
				S_StartSound(me,sfx_didbad)
			end
			
			me.state = S_PLAY_DASH
			
			takis.clutchingtime = 0
			takis.glowyeffects = takis.hammerblastdown/3
			
			local ang = GetControlAngle(p)
			
			if ((me.flags2 & MF2_TWOD)
			or (twodlevel))
				if (p.cmd.sidemove > 0)
					ang = p.drawangle
				elseif (p.cmd.sidemove < 0)
					ang = InvAngle(p.drawangle)
				end
			end
			
			if takis.accspeed+15*FU <= 80*FU
				P_InstaThrust(me,ang,
					FixedDiv(
						FixedMul(
							FixedMul(takis.accspeed+15*FU,me.scale),
							p.powers[pw_sneakers] and FU*7/5 or FU
						),
						max(FU,takis.dropdashstale*3/2*me.scale)
					),
					true
				)
			else
				takis.frictionfreeze = 10
				me.friction = FU
			end
			P_MovePlayer(p)
			
			--effect
			local ghost = P_SpawnGhostMobj(me)
			ghost.scale = 3*me.scale/2
			ghost.destscale = FixedMul(me.scale,2)
			ghost.colorized = true
			ghost.frame = $|TR_TRANS10
			ghost.blendmode = AST_ADD
			ghost.angle = p.drawangle
			ghost.momx,ghost.momy = me.momx*3/4,me.momy*3/4
			for j = -1,1,2
				for i = 3,P_RandomRange(4,7)
					TakisKart_SpawnSpark(me,
						ang+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
						SKINCOLOR_ORANGE,
						true,
						true
					)
					TakisSpawnDust(me,
						ang+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
						P_RandomRange(0,-50),
						P_RandomRange(-1,2)*me.scale,
						{
							xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = P_RandomRange(0,-10)*me.scale,
							thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							momz = (P_RandomRange(4,0)*i)*(me.scale/2),
							momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = me.scale,
							scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = 15+P_RandomRange(-5,5),
						}
					)
				end
			end
			
			do
				local d1 = P_SpawnMobjFromMobj(me, -20*cos(ang + ANGLE_45), -20*sin(ang + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
				local d2 = P_SpawnMobjFromMobj(me, -20*cos(ang - ANGLE_45), -20*sin(ang - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
				d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5
				d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
				
				d1.momx,d1.momy = me.momx/2,me.momy/2
				d2.momx,d2.momy = me.momx/2,me.momy/2
				d1.momz = takis.rmomz
				d2.momz = takis.rmomz
			end
			
			takis.dropdashstale = $+1
			takis.dropdashstaletime = 2*TR
		end
		
	end
	takis.hammerblastdown = 0
end)

--buggie gave me this
local function peptoboxed(mobj)
	--should work with no errors...
	if mobj.player.pep and mobj.skin == "peppino"
		mobj.player.height = mobj.player.spinheight
		mobj.player.mo.radius = 3*skins[mobj.skin].radius/2
		mobj.player.pflags = $&~PF_SPINNING
		  
		if not mobj.player.pep.transfo
			PT_SpawnEffect(mobj,"sfx_peppino_transform") --Custom peppino function, would not work
			mobj.player.pep.transfoappear = 16
		end
		PT_SpawnEffect(mobj,"poof") --Custom peppino function, would not work
		mobj.player.pep.transfo = "box"
		mobj.player.pep.transfovars = {}
		mobj.state = S_BOXPEP_TRNS
		mobj.player.pep.transfovars["transanimtime"] = 20
		mobj.player.pep.transfotime = 30*TICRATE
		mobj.player.jumpfactor = 2*skins[mobj.skin].jumpfactor/3
		return true
	end
	return false
end

--hammerhitbox
rawset(_G,"TakisHammerBlastHitbox",function(p)
	local me = p.realmo
	local takis = p.takistable
	local didit = false
	
	if takis.inBattle
		p.lockmove = false
		p.melee_state = 0
	end
	
	local dispx = FixedMul(42*me.scale+(20*me.scale),cos(p.drawangle))
	local dispy = FixedMul(42*me.scale+(20*me.scale),sin(p.drawangle))
	local thok = P_SpawnMobjFromMobj(
		me,
		dispx+me.momx,
		dispy+me.momy,
		--theres some discrepancies with these on different scales,
		--but its miniscule so whatever yknow
		(-FixedMul(TAKIS_HAMMERDISP,me.scale)*takis.gravflip)+me.momz
		+(takis.gravflip == -1 and -me.height or 0),
		MT_THOK
	)
	thok.radius = 40*me.scale
	thok.height = 60*me.scale
	thok.scale = me.scale
	thok.fuse = 2
	thok.flags2 = $|MF2_DONTDRAW
	thok.parent = me
	P_SetOrigin(thok,
		me.x+dispx+me.momx,
		me.y+dispy+me.momy,
		me.z+(-FixedMul(TAKIS_HAMMERDISP,me.scale)*takis.gravflip)+me.momz
		+(takis.gravflip == -1 and -me.height+thok.height or 0)
	)
	
	if TakisBreakAndBust(p,thok)
		didit = true
	end
	
	--wind ring
	if not (takis.hammerblastdown % 6)
	and takis.hammerblastdown > 6
	and (me.momz*takis.gravflip < 0)
	and (thok and thok.valid)
		local ring = P_SpawnMobjFromMobj(thok,
			0,0,-5*me.scale*takis.gravflip,MT_THOK --MT_WINDRINGLOL
		)
		if (ring and ring.valid)
			ring.renderflags = RF_FLOORSPRITE
			ring.frame = $|FF_TRANS50
			ring.startingtrans = FF_TRANS50
			ring.scale = FixedDiv(me.scale,2*FU)
			P_SetObjectMomZ(ring,10*me.scale)
			--i thought this would fade out the object
			ring.fuse = 10
			ring.destscale = FixedMul(ring.scale,2*FU)
			ring.colorized = true
			ring.color = SKINCOLOR_WHITE
			ring.state = S_SOAPYWINDRINGLOL
		end
	end
	
	local fakerange = 250*FU
	local range = thok.radius*3/2
	searchBlockmap("objects", function(ref, found)
		if found == me then return end
		if R_PointToDist2(found.x, found.y, thok.x, thok.y) > range
			return
		end
		if not L_ZCollide(found,thok) then return end
		if not (found.health) then return end
		if not P_CheckSight(me,found) then return end
		if (found.alreadykilledthis) then return end
		
		if CanFlingThing(found)
			if not (found.flags & MF_BOSS)
				found.alreadykilledthis = true
			end
			
			local bam1 = SpawnBam(ref)
			bam1.renderflags = $|RF_FLOORSPRITE
			SpawnEnemyGibs(thok,found)
			S_StartSound(found,sfx_smack)
			S_StartSound(me,sfx_sdmkil)
			SpawnRagThing(found,me,me)
			didit = true
		elseif SPIKE_LIST[found.type] == true
			found.alreadykilledthis = true
			P_KillMobj(found,me,me)
		elseif (found.player and found.player.valid)
			if CanPlayerHurtPlayer(p,found.player)
				local bam1 = SpawnBam(ref)
				bam1.renderflags = $|RF_FLOORSPRITE
				SpawnEnemyGibs(thok,found)
				S_StartSound(found,sfx_smack)
				S_StartSound(me,sfx_sdmkil)
				if not takis.inBattle
					P_KillMobj(found,me,me,DMG_CRUSHED)
				else
					P_DamageMobj(found,me,me,2)
				end
				TakisAddHurtMsg(found.player,p,HURTMSG_HAMMERBOX)
				if not found.health
					found.alreadykilledthis = true
				end
				didit = true
			elseif peptoboxed(found)
				didit = true
			end
		elseif (found.flags & MF_SPRING)
		and (found.info.painchance ~= 3)
			if (GetActorZ(found,me,2) > (takis.gravflip == 1 and me.floorz or me.ceilingz))
				local bam1 = SpawnBam(ref)
				bam1.renderflags = $|RF_FLOORSPRITE
				P_DoSpring(found,me)
			end
		elseif (found.type == MT_HHTRIGGER)
			local bam1 = SpawnBam(ref)
			bam1.renderflags = $|RF_FLOORSPRITE
			local tl = tonumber(mapheaderinfo[gamemap].takis_hh_timelimit or 3*60)*TR
			if mapheaderinfo[gamemap].takis_hh_timelimit ~= nil
			and string.lower(tostring(mapheaderinfo[gamemap].takis_hh_timelimit)) == "none"
				tl = 0
			end
			HH_Trigger(found,p,tl)
			
			S_StartSound(found,found.info.deathsound)
			found.state = found.info.deathstate
			
			found.spritexscaleadd = 2*FU
			found.spriteyscaleadd = -FU*3/2
			didit = true
		end
	end, 
	thok,
	thok.x-fakerange, thok.x+fakerange,
	thok.y-fakerange, thok.y+fakerange)		

	if (me.momz*takis.gravflip) <= -60*me.scale
		didit = false
	end
	
	if didit
		forcehambounce(p)
	end
	return didit
end)

local emeraldframelist = {
	[0] = A,
	[1] = C,
	[2] = E,
	[3] = G,
	[4] = I,
	[5] = K,
	[6] = M,
}

rawset(_G,"TakisFetchSpiritFrame",function(index,gotit)
	local frame = emeraldframelist[index]
	if not (gotit)
		frame = $+1
	end
	return frame
end)

--you're mother
rawset(_G,"TakisMomAngle",function(mo,fallback,Amomx,Amomy)
	if not (mo and mo.valid) then return end
	
	local momx,momy = (Amomx ~= nil) and Amomx or mo.momx, (Amomy ~= nil) and Amomy or mo.momy
	if (momx/mo.scale ~= 0 or momy/mo.scale ~= 0)
		if (mo.player and mo.player.valid)
		and (Amomx == nil or Amomy == nil)
			momx,momy = $1-mo.player.cmomx,$2-mo.player.cmomy
		end
		return R_PointToAngle2(0,0,momx,momy)
	else
		return (fallback ~= nil and fallback or ((mo.player and mo.player.valid) and mo.player.drawangle or mo.angle))
	end
end)

rawset(_G,"TakisIsScreenPlayer",function(p)
	return ((splitscreen and p == secondarydisplayplayer) or p == displayplayer)
end)

rawset(_G,"TakisGetCameraMobj",function()
	local cam = camera
	if (displayplayer and displayplayer.valid)
		
		if not CV_FindVar("chasecam").value
			
			local pmo = displayplayer.realmo
			if not (pmo and pmo.valid)
				pmo = displayplayer.mo
			end
			
			if (pmo and pmo.valid)
				local th = P_SpawnMobj(
					pmo.x,
					pmo.y,
					GetActorZ(pmo,pmo,2),
					MT_RAY
				)
				th.angle = pmo.angle
				pmo = th
			end
			cam = pmo
		else
			cam = camera
		end
		
		if displayplayer.awayviewtics
		and (displayplayer.awayviewmobj and displayplayer.awayviewmobj.valid)
			cam = displayplayer.awayviewmobj
		end
		
		if not (cam and cam.valid)
			cam = camera
		end
	end
	return cam
end)

--dictates whether mobj @fx coming from @sourcep should dontdraw
rawset(_G,"TakisShouldIHideInFP",function(fx,sourcep)
	if not fx.takis_vfx then return end
	
	if not TakisIsScreenPlayer(sourcep) then return false end
	
	if not (camera.chase)
		local cam = TakisGetCameraMobj()
		--only dontdraw afterimages that are too close to the player
		local dist = TAKIS_TAUNT_DIST*3
		
		local dx = (cam.x) - fx.x
		local dy = (cam.y) - fx.y
		local dz = (cam.z) - fx.z
		if FixedHypot(FixedHypot(dx,dy),dz) < dist
			return true
		else
			return false
		end
	else
		return false
	end
end)

rawset(_G, 'L_DecimalFixed', function(str)
	if str == nil return nil end
	local dec_offset = string.find(str,'%.')
	if dec_offset == nil
		return (tonumber(str) or 0)*FRACUNIT
	end
	local whole = tonumber(string.sub(str ,0,dec_offset-1)) or 0
	local decimal = tonumber(string.sub(str,dec_offset+1)) or 0
	whole = $ * FRACUNIT
	local dec_len = string.len(decimal)
	decimal = $ * FRACUNIT / (10^dec_len)
	return whole + decimal
end)

rawset(_G,"TakisBotThinker",function(p)
	if (p.bot == 0 or p.ai == 0) then return end
	if not (p.realmo and p.realmo.valid) then return end
	
	local me = p.realmo
	local takis = p.takistable
	
	takis.noability = $|NOABIL_CLUTCH
	
	if (takis.tauntjoin and takis.tauntjoin.valid)
	and not takis.taunttime
		local menu = takis.tauntmenu
		for p2 in players.iterate
			if p2 == p
				continue
			end
			
			local m2 = p2.realmo
			
			local dx = me.x-m2.x
			local dy = me.y-m2.y
			
			--in range!
			if FixedHypot(dx,dy) <= TAKIS_TAUNT_DIST
				if skins[p2.skin].name == TAKIS_SKIN
					if p2.takistable.tauntjoinable
					
						--we want their taunt number!
						takis.tauntid = p2.takistable.tauntid
						
						if (p2.takistable.tauntacceptspartners)
							takis.tauntpartner = p2
							p2.takistable.tauntpartner = p
						end
						
						local func = TAKIS_TAUNT_INIT[p2.takistable.tauntid]
						func(p)
						
						--close
						menu.open = false
					end
				elseif skins[p2.skin].name == "inazuma"
					--Holy MOLY!
					TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.ultzuma)
					
					menu.open = false
				end
			end
			
		end
	end
	
	local pb = p.botleader
	if not (pb and pb.valid) then return end
	
	local tak2 = pb.takistable
	local bmo = pb.realmo
	
	if takis.taunttime
	and (not tak2.taunttime or tak2.c1 == 1)
		TakisResetTauntStuff(p)
	end
	
	local dist = FixedHypot(FixedHypot(bmo.x - me.x,bmo.y - me.y),bmo.z - me.z)
	
	if (pb.pflags & PF_SPINNING)
	and (dist <= TAKIS_TAUNT_DIST*3)
		takis.c2 = $+1
		p.cmd.buttons = $ &~BT_USE
		takis.use = 0
	end
	
	if p.playerstate == PST_LIVE
		takis.heartcards = TAKIS_MAX_HEARTCARDS
	end
	
end)

--P_MovePlayer but without moving and only animation changes
rawset(_G,"TakisResetState",function(p)
	local cmd = p.cmd
	local me = p.realmo
	
	if not (me and me.valid) then return end
	
	local onground = P_IsObjectOnGround(me)
	local issuper = p.powers[pw_super]
	local takis = p.takistable
	local accspeed = FixedMul(takis.accspeed,me.scale)
	
	local runspeed = FixedMul(p.runspeed,me.scale)
	if (issuper)
		runspeed = FixedMul($,FU*5/3)
	end
	runspeed = FixedMul($,me.movefactor)
	
	
	--P_SkidStuff(p)
	
	--lets start animating our player
	if ((cmd.forwardmove ~= 0 or cmd.sidemove ~= 0) or (issuper and not onground))
		if (p.charflags & SF_DASHMODE)
		and (p.dashmove >= 3*TR)
		and (p.panim == PA_RUN)
		and (not p.skidtime)
		and (onground or ((p.charability == CA_FLOAT or p.charability == CA_SLOWFALL) and p.secondjump == 1) or (issuper))
			me.state = S_PLAY_DASH
		elseif (accspeed >= runspeed and p.panim == PA_WALK and not p.skidtime
		and (onground or ((p.charability == CA_FLOAT or p.charability == CA_SLOWFALL) and p.secondjump == 1) or (issuper)))
			if not onground
				me.state = S_PLAY_FLOAT_RUN
			else
				me.state = S_PLAY_RUN
			end
		elseif ((((p.charability == CA_FLOAT or p.charability == CA_SLOWFALL) and p.secondjump == 1) or issuper) and p.panim == PA_IDLE and not onground)
			me.state = S_PLAY_FLOAT
		elseif ((p.rmomx or p.rmomy) and p.panim == PA_IDLE)
			me.state = S_PLAY_WALK
		end
	end
	
	if (p.charflags & SF_DASHMODE and p.panim == PA_DASH and p.dashmode < 3*TR)
		me.state = S_PLAY_RUN
	end
	
	if (p.panim == PA_RUN and accspeed < runspeed)
		if (not onground or (((p.charability == CA_FLOAT or p.charability == CA_SLOWFALL) and p.secondjump == 1) or (issuper)))
			me.state = S_PLAY_FLOAT
		else
			me.state = S_PLAY_WALK
		end
	end
	
	if onground
		if (me.state == S_PLAY_FLOAT)
			me.state = S_PLAY_WALK
		elseif (me.state == S_PLAY_FLOAT_RUN)
			me.state = S_PLAY_RUN
		end
	end
	
	if ((p.panim == PA_SPRING and me.momz*takis.gravflip < 0)
	or ((((p.charflags & SF_NOJUMPSPIN) and (p.pflags & PF_JUMPED)
	and p.panim == PA_JUMP)) and (me.momz*takis.gravflip < 0)))
		me.state = S_PLAY_FALL
	elseif (onground and (p.panim == PA_SPRING or p.panim == PA_FALL
	or p.panim == PA_RIDE or p.panim == PA_JUMP) and not me.momz)
		me.state = S_PLAY_STND
	end
	
	if (not me.momx and not me.momy and not me.momz and p.anim == PA_WALK)
		me.state = S_PLAY_STND
	end
	
	if onground and (me.momx or me.momy)
	and p.panim ~= PA_WALK
	and not me.momz
	and p.panim ~= PA_DASH
		if accspeed < runspeed
			me.state = S_PLAY_WALK
		else
			me.state = S_PLAY_RUN
		end
	end
	
	--works fine as is so i dont think i need the rest of the func
end)

local CS_VERT = (1<<0)
local CS_ACCEL = (1<<1)
local CS_ACCELNOABS = (1<<2)

local function GetCarSpeed(car,flags)
	flags = $ or 0
	local pmo = car.target
	local cmomx,cmomy = 0,0
	if (pmo and pmo.valid and pmo.player)
		cmomx,cmomy = pmo.player.cmomx,pmo.player.cmomy
	end
	local speed = FixedDiv(FixedHypot(car.momx,car.momy),car.scale)
	
	if (flags & CS_VERT)
		speed = FixedDiv(FixedHypot(FixedHypot(car.momx-cmomx,car.momy-cmomy),car.momz),car.scale)
	end
	if (flags & (CS_ACCEL|CS_ACCELNOABS))
		if flags & CS_ACCELNOABS
			speed = car.accel*8
		else
			speed = abs(car.accel*8)
		end
	end
	
	return speed
end

local function spillrings(p,spillall)
	if p.rings
		S_StartSoundAtVolume(p.mo,sfx_s3kb9,255/2)
		local spillamount = 32
		if not (p.realmo.health)
		or spillall
			spillamount = p.rings
		end
		
		if (p.rings >= spillamount)
			P_PlayerRingBurst(p,spillamount)
			p.rings = $ - spillamount
		else
			P_PlayerRingBurst(p,-1)
			p.rings = 0
		end
	end
	if (p.gotflag)
		P_PlayerFlagBurst(p,false)
	end
	P_PlayerWeaponAmmoBurst(p)
	P_PlayerWeaponPanelBurst(p)
	P_PlayerEmeraldBurst(p)
end

rawset(_G,"TakisKart_DoSpinout",function(p,inf,forcespin)
	local me = p.mo
	if not p.inkart then return end
	if not (me.tracer and me.tracer.valid) then return end
	local car = me.tracer

	p.powers[pw_flashing] = flashingtics
	car.inpain = true
	car.painangle = car.angle
	car.driftspark = 0
	S_StartSound(me,sfx_s3k9b)
	
	local spintype = SPINOUT_SPIN
	
	local basemaxspeed = TakisKart_KarterData[me.skin].basenormalspeed*FU
	local myspeed = FixedHypot(GetCarSpeed(car),FixedDiv(me.momz,me.scale))
	local speedmul = max(FixedDiv(myspeed,basemaxspeed),FU)
	
	local theirspeed = 0
	if (inf and inf.valid)
		theirspeed = FixedDiv(FixedHypot(FixedHypot(inf.momx,inf.momy),inf.momz),inf.scale)
	end
	local sor = inf or me
	local dontspill = false
	
	if speedmul > FU
		if speedmul >= FU*2
			spintype = SPINOUT_BIGTUMBLE
		else
			spintype = SPINOUT_TUMBLE
		end
	end
	
	if forcespin ~= nil
		spintype = forcespin
	end
	
	if spintype ~= SPINOUT_SPIN
		SpawnBam(me,true)
		if spintype == SPINOUT_BIGTUMBLE
			P_SetObjectMomZ(car,50*sor.scale)
			P_Thrust(car,TakisMomAngle(sor),25*sor.scale + theirspeed)
		elseif spintype == SPINOUT_TUMBLE
			P_SetObjectMomZ(car,20*sor.scale)
			if (inf and inf.valid)
				P_Thrust(car,TakisMomAngle(sor),theirspeed)
			end
		elseif spintype & SPINOUT_STUMBLE
			P_Thrust(car,TakisMomAngle(car),myspeed + theirspeed)
			if (inf and inf.valid)
				P_Thrust(car,TakisMomAngle(sor),theirspeed)
			end
			P_SetObjectMomZ(car,25*sor.scale)
			dontspill = true
		end
		if not dontspill
			car.fuel = $-(5*FU)
			car.damagetic = TR
		end
	else
		P_Thrust(car,TakisMomAngle(car),myspeed + theirspeed)
		if (inf and inf.valid)
			P_Thrust(car,TakisMomAngle(sor),theirspeed)
		end
		
	end
	car.spinouttype = spintype
	
	if not dontspill
		P_PlayRinglossSound(me,p)
		spillrings(p)
		if TakisKart_KarterData[me.skin].painsounds ~= nil
		and #TakisKart_KarterData[me.skin].painsounds
			S_StartSound(me,choosething(unpack(TakisKart_KarterData[me.skin].painsounds)))
		end
	end
end)

--returns the mobj's speed, positive if its going in the mobj's angle,
--negative otherwise
rawset(_G,"TakisAngleSpeed",function(mo,ang)
	if ang == nil
		ang = mo.angle
	end
	local momang = TakisMomAngle(mo,ang)
	local speed = FixedHypot(mo.momx,mo.momy)
	
	local anglediff = abs(AngleFixed(ang)) - abs(AngleFixed(momang))
	anglediff = abs($)
	
	--if abs(abs(AngleFixed(ang)) - abs(AngleFixed(momang))) > 180*FU
	if anglediff > (90*FU)
	and anglediff < (90*FU + (360*FU))
		return -speed
	else
		return speed
	end

end)

rawset(_G,"clamp",function(minimum,value,maximum)
	if maximum < minimum
		local temp = minimum
		minimum = maximum
		maximum = temp
	end
	return max(minimum,min(maximum,value))
end)

--table of helper funcs?
--clean up combo code, its really messy
rawset(_G,"TakisComboHelpers",{
	shouldfreeze = function(p)
		local me = p.realmo
		local takis = p.takistable
		
		local frozen = false
		local carried = false

		if not (takis.notCarried)
		or ((p.pflags & PF_STASIS) and not (takis.taunttime and takis.tauntid))
		or ((p.exiting) and not (p.pflags & PF_FINISHED))
		or (p.powers[pw_nocontrol])
		or (takis.nocontrol)
		or (takis.inwaterslide)
		or (takis.freeze.tics)
			frozen = true
			carried = true
		end
		
		if (me.pizza_in or me.pizza_out)
		or (HAPPY_HOUR.othergt and HAPPY_HOUR.overtime)
		or (p.ptsr and p.ptsr.outofgame)
			frozen = true
		end
		
		if (p.powers[pw_invulnerability] >= 3*TR
		and takis.combo.count >= 20)
			takis.combo.time = min($+2,TAKIS_MAX_COMBOTIME)
			frozen = true
		end
		
		--theres a good chance theres nothing
		--refilling our combo on our carry!
		if frozen and carried
			takis.combo.time = TAKIS_MAX_COMBOTIME
		end
		
		return frozen
	end,
})

rawset(_G,"TakisRandomFixed",function(a,b)
	return P_RandomRange(a,b)*FU + (P_RandomFixed() * (P_RandomChance(FU/2) and 1 or -1))
end)

TAKIS_FILESLOADED = $+1