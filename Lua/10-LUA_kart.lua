--mariokart????????????
/*
	-[done]teleporters dont tp the kart, snaps the player back
	 sorta fixed? fixing it only brought up a new issue with tele sectors
	-[done]springs unsuable
	-[done]solids passable
	-[done]joystick support
	-clean up code and make it easier to port (seperate taksi stuff)
	-[done]make drift more accurate
	-[done?]wind sectors affect karts
	-[done]dont use so many effects when drifting
	-[done]waterslide affect karts
	-[done]bikemode (inward drift, srb2k bikemod and whatnot)
	-[done]sliptiding?
	-[done]Redo acceleration and make it more like kart's, rr's, and srb2's
	-something here is resynching
*/

local CMD_DEADZONE 		= 	14
--local STATS 			=	{9,4} --speed,weight
--local basenormalspeed 	= 	43
local spaceaccel 		=	false
local driftvolume 		=	255--/2
local greasetics 		= 	3*TR
local ctrdrift			=	false --i wonder what this does
local gamegear			=	3 --1-3
local extrastuff 		=	true
local MAPSCALE			=	FU
local lastexplodes		=	false
local allowwallstick	=	false
local ORIG_FRICTION		=	(232 << (FRACBITS-8)) --this should really be exposed...

rawset(_G,"TakisKart_Framesets",{
	norm = {
		neutral = A,
		turnL = D,
		turnR = G,
		pain = J,
		driftL = K,
		driftR = M,
		
		glanceL = O,
		glanceR = R,
		lookL = U,
		lookR = X,
		
		vibrateoffset = 1,
		tireshineoffset = 2,
	},
	legacy = {
		neutral = A,
		turnL = C,
		turnR = E,
		pain = Q,
		driftL = M,
		driftR = O,
		
		glanceL = A,
		glanceR = A,
		lookL = A,
		lookR = A,
		
		vibrateoffset = 1,
		tireshineoffset = 9,
		
		turnLts = 8,
		turnRts = 7,
		
	}
})

local frames = TakisKart_Framesets
local maxlaps = CV_FindVar("numlaps").value

local function dprint(...)
	if not (TAKIS_DEBUGFLAG & DEBUG_KART)
		return
	end
	
	print(...)
	
end

local function setmapvars(nextmap)
	if not circuitmap
		extrastuff = mapheaderinfo[nextmap].forcekartextra ~= nil
	else
		extrastuff = mapheaderinfo[nextmap].forcekartextra ~= nil
	end
	
	local mobjscale = mapheaderinfo[nextmap].mobjscale
	if mobjscale ~= nil
		MAPSCALE = L_DecimalFixed(mobjscale)
	else
		MAPSCALE = FU
	end
end

addHook("MapChange",setmapvars)

addHook("ThinkFrame",do
	setmapvars(gamemap)
	
	for p in players.iterate
		if not p.inkart then return end
		if not (p.realmo.tracer and p.realmo.tracer.valid) then return end
		
		if p.realmo.tracer.slidetime == nil then p.realmo.tracer.slidetime = 0 end
		
		if p.pflags & PF_SLIDING
		or (p.realmo.pizza_out)
			p.realmo.sprite2 = SPR2_KART
			p.realmo.frame = (TakisKart_KarterData[p.realmo.skin].legacyframe) and frames.legacy.pain or frames.norm.pain
			p.realmo.tracer.slidetime = $+1
			p.realmo.tracer.stasis = true
			p.drawangle = p.realmo.angle+(ANG15*(p.realmo.tracer.slidetime or 0))
			return
		end
	end
	
	if TAKIS_TUTORIALSTAGE
	and gamegear ~= 3
		gamegear = 3
	end
	
end)

addHook("MobjSpawn",function(mo)
	if MAPSCALE ~= FU
		--P_SetScale(mo,FixedMul(mo.scale,MAPSCALE))
		mo.scale = FixedMul($,MAPSCALE)
		mo.destscale = mo.scale
	end
end)

--kart animation guide ctrl+f: SIGMA MODE FUNCTION
if not TakisKart_Karters
	rawset(_G,"TakisKart_Karters",{})
end
if not TakisKart_KarterData
	rawset(_G,"TakisKart_KarterData",{})
end


TakisKart_Karters[TAKIS_SKIN] = true
TakisKart_KarterData[TAKIS_SKIN] = {
	basenormalspeed = 43,
	
	--speed,weight
	stats = {9,4},
	
	nolookback = true,
	takiskart = true,
	horns = {sfx_antwi1,sfx_antwi2,sfx_antwi3},
	legacyframes = true,
}

TakisKart_Karters["sonic"] = true
TakisKart_KarterData["sonic"] = {
	basenormalspeed = 43,
	
	--speed,weight
	stats = {8,2},
	
	radius = 24*FU,
	
	nolookback = false,
}
TakisKart_Karters["nick"] = true
TakisKart_KarterData["nick"] = {
	basenormalspeed = 43,
	
	--speed,weight
	stats = {3,8},
	height = 48*FU,
	
	nolookback = true,
	legacyframes = true,
}

rawset(_G,"TakisKart_ExtraSounds",false)
rawset(_G,"TakisKart_ExtraStuff",false)

SafeFreeslot("MT_TAKIS_KART_HELPER")
SafeFreeslot("S_TAKIS_KART_HELPER")
states[S_TAKIS_KART_HELPER] = {
	sprite = SPR_TKRT,
	frame = B,
	tics = -1,
}
mobjinfo[MT_TAKIS_KART_HELPER] = {
	doomednum = -1,
	spawnstate = S_TAKIS_KART_HELPER,
	flags = MF_SOLID|MF_SLIDEME,
	height = 48*FRACUNIT,
	radius = 16*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_KART")
SafeFreeslot("S_TAKIS_KART")
states[S_TAKIS_KART] = {
	sprite = SPR_TKRT,
	action = function(car)
		if car.health then return end
		if not car.fakekart then P_RemoveMobj(car); return end
		
		car.frame = B
		
		local ki = P_SpawnMobjFromMobj(car,0,0,0,MT_TAKIS_BROLYKI)
		ki.tracer = car
		ki.color = car.color
		S_StopSound(car)
		S_StartSound(car,sfx_buzz3)
		car.hitlag = TR
		
		car.momx,car.momy,car.momz = 0,0,0
		car.flags = $|MF_NOGRAVITY|MF_NOCLIPTHING
		
	end,
	frame = A,
	tics = -1,
}
mobjinfo[MT_TAKIS_KART] = {
	--$Name Kart
	--$Sprite TKRTB8
	--$Category Takis Stuff
	
	--$Arg0 Weight (1-9)
	--$Arg0Default 1
	--$Arg0Type 0

	--$Arg1 Don't bump (1-9)
	--$Arg1Default 0
	--$Arg1Type 0
	doomednum = 7008,
	spawnstate = S_TAKIS_KART,
	deathstate = S_TAKIS_KART,
	flags = MF_SPECIAL|MF_SLIDEME,
	height = 32*FRACUNIT,
	radius = 16*FRACUNIT,
}

SafeFreeslot("MT_TAKIS_KART_LEFTOVER")
SafeFreeslot("S_TAKIS_KART_DEAD")
states[S_TAKIS_KART_DEAD] = {
	sprite = SPR_TKRT,
	frame = C,
	action = function(me)
		if not me.health
			if me.hitlag == nil
				me.hitlag = TR/4
			elseif me.hitlag
				me.flags2 = $^^MF2_DONTDRAW
				
				me.hitlag = $-1
				if not me.hitlag
					P_SetObjectMomZ(me,10*FU)
					P_Thrust(me,
						FixedAngle(P_RandomRange(0,360)*FU),
						15*me.scale
					)
					me.fuse = TR/2
				end
			else
				me.flags2 = $ &~MF2_DONTDRAW
				me.flags = $|MF_NOCLIPTHING &~(MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY)
				
			end
			
			return
		end
		
		me.allowbumps = true
		me.kartweight = 3*FU
		me.spritexscale,me.spriteyscale = FU,FU
		if abs(me.momz) >= 18*me.scale
			local mom = FixedDiv(abs(me.momz),me.scale)-18*FU
			mom = $/50
			mom = -min($,FU*4/5)
			me.spritexscale,
			me.spriteyscale = $1+mom,$2-(mom*9/10)
		end
		
		if me.justbumped ~= nil
			me.justbumped = $-1
		end
		
		if not P_IsObjectOnGround(me)
			me.momz = $ + P_GetMobjGravity(me)
			me.lifetime = $ or 0
			me.flags = $ &~MF_SOLID
		else
			P_ButteredSlope(me)
			P_ButteredSlope(me)
			me.flags = $|MF_SOLID
			if not me.lastground
				me.stretch = FU*3/4
				S_StartSound(me,sfx_s3k4c)
			else
				me.stretch = $ - ($/4)
			end
			me.spritexscale = $ + (me.stretch*4/3)
			me.spriteyscale = $ - (me.stretch*4/3)
			me.lifetime = $ or 0
			
			if me.lifetime < 10*TR
				local angle = P_RandomRange(0,360)*ANG1 + FixedAngle(P_RandomFixed())
				local thok = P_SpawnMobjFromMobj(me,
					0, --P_ReturnThrustX(nil,angle,me.radius),
					0, --P_ReturnThrustY(nil,angle,me.radius),
					0,
					MT_THOK
				)
				thok.scale = me.scale*2/3
				local spark = TakisKart_SpawnSpark(thok,
					angle + ANGLE_180,
					SKINCOLOR_WHITE,
					false
				)
				spark.momx,spark.momy = $1*3/4,$2*3/4
				spark.tics = $*3/4
				spark.blendmode = AST_TRANSLUCENT
				P_RemoveMobj(thok)
				
				if not S_SoundPlaying(me,sfx_kc51)
					S_StartSound(me,sfx_kc51)
				end
				
				local flame = P_SpawnMobjFromMobj(me,
					P_RandomRange(-36,36)*FU,
					P_RandomRange(-36,36)*FU,
					0,MT_SPINFIRE
				)
				flame.scale = me.scale/4+ FixedMul(me.scale,FU*8/10 + P_RandomFixed())
				flame.target = me
				flame.fuse = TR/4
				flame.flags = $|MF_NOCLIPTHING &~(MF_PAIN)
				flame.destscale = 0
				P_SetObjectMomZ(flame,FU + P_RandomFixed())
				
				if (me.lifetime & 3)
					local smoke = P_SpawnMobjFromMobj(me,0,0,0,MT_SMOKE)
					smoke.colorized = true
					smoke.color = SKINCOLOR_BLACK
					smoke.scale = FixedMul($, 2*FU + P_RandomFixed())
					P_SetObjectMomZ(smoke,3*FU)
				end
				
				me.lifetime = $+1
			end
		end
		me.lastground = P_IsObjectOnGround(me)
	end,
	tics = 1,
	nextstate = S_TAKIS_KART_DEAD
}
mobjinfo[MT_TAKIS_KART_LEFTOVER] = {
	doomednum = -1,
	spawnstate = S_TAKIS_KART_DEAD,
	deathstate = S_TAKIS_KART_DEAD,
	flags = MF_SHOOTABLE,
	height = 28*FRACUNIT,
	radius = 16*FRACUNIT,
}

local function getslopeinfluence(mobj,player,options)
	if (mobj.flags & (MF_NOCLIPHEIGHT|MF_NOGRAVITY)) then return end
	
	if options == nil then options = {} end
	
	local thrust
	local slope = mobj.standingslope
	local p = (player and player.valid) and player or mobj.player
	
	if not (slope and slope.valid) then return end
	if (slope.flags & SL_NOPHYSICS) then return end
	
	if (p and p.valid)
	or (options.allowstand)
		if abs(slope.zdelta) < FU/4
			if not(p and p.valid)
			or not (p.pflags & PF_SPINNING)
				return
			end
		end
		
		if abs(slope.zdelta) < FU/2
			if not (p and p.valid)
				if not (mobj.momx or mobj.momy)
					return
				end
			else
				if not (p.rmomz or p.rmomy)
					return
				end
			end
		end
	end
	thrust = sin(slope.zangle)*3/2 * (-P_MobjFlip(mobj))
	
	if (p and p.pflags & PF_SPINNING)
	or (options.allowmult)
		local mul = 0
		if (mobj.momx or mobj.momy)
			local angle = TakisMomAngle(mobj) - slope.xydirection
			
			if P_MobjFlip(mobj) * slope.zdelta < 0
				angle = $^^ANGLE_180
			end
			mul = cos(angle)
		end
		thrust = FixedMul($, FU*2/3 + mul/8)
	end
	
	if (mobj.momx or mobj.momy)
		thrust = FixedMul($, FU + R_PointToDist2(0,0,mobj.momx,mobj.momy)/16)
	end
	thrust = FixedMul($, abs(P_GetMobjGravity(mobj)))
	
	thrust = FixedMul($, FixedDiv(mobj.friction,ORIG_FRICTION))
	return slope.xydirection,thrust
end

local CS_VERT = (1<<0)
local CS_ACCEL = (1<<1)
local CS_ACCELNOABS = (1<<2)

local function GetCarSpeed(car,flags)
	flags = $ or 0
	local p = car.target.player
	local speed = FixedDiv(FixedHypot(car.momx-p.cmomx,car.momy-p.cmomy),car.scale)
	
	if (flags & CS_VERT)
		speed = FixedDiv(FixedHypot(FixedHypot(car.momx-p.cmomx,car.momy-p.cmomy),car.momz),car.scale)
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

local function CanISliptide(car)
	if not car.grounded then return false end
	
	if (car.handleboost >= (7*FU/8)/2
	or car.invuln
	or car.target.player.powers[pw_sneakers]
	--sliptide anytime
	or (GetCarSpeed(car) >= car.basemaxspeed*3/2))
	--Continue
	or (car.sliptide ~= 0)
	
	and (GetCarSpeed(car) >= car.basemaxspeed/2)
	--and car.drift == 0
		return true
	end
	return false
end

rawset(_G,"CarGenericEject",function(p)
	local me = p.realmo
	
	if p.powers[pw_carry] == CR_TAKISKART
		p.powers[pw_carry] = 0
	end
	p.powers[pw_ignorelatch] = 0
	p.pflags = $ &~(PF_JUMPED|PF_DRILLING)
	p.takistable.HUD.lives.tweentic = 5*TR
	
	p.charability,p.charability2 = skins[p.skin].ability,skins[p.skin].ability2
	p.charflags = skins[p.skin].flags
	p.runspeed = skins[p.skin].runspeed
	p.restat = nil
	p.powers[pw_flashing] = 0
	
	me.color = p.skincolor
	me.colorized = false
	me.rollangle = 0
	
	me.tracer = nil
	me.spritexoffset,me.spriteyoffset = 0,0
	
	me.radius = FixedMul(skins[p.skin].radius,me.scale)
	me.height = FixedMul(skins[p.skin].height,me.scale)

	me.laststandingslope = nil
	me.lastfloorz = nil
	me.lastgrounded = nil
end)

rawset(_G,"TakisKart_GetGearMul",function()
	local gearmul = FixedDiv(gamegear*FU,3*FU)
	if gamegear < 3
		gearmul = ease.outsine(FU/4,$,FU)
	end
	return gearmul
end)

local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

local function LaunchTargetFromInflictor(type,target,inflictor,basespeed,speedadd)
	if (string.lower(type) == "instathrust") or type == 1
		P_InstaThrust(target, R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y), basespeed+(speedadd))
	else
		P_Thrust(target, R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y), basespeed+(speedadd))
	end
end

rawset(_G,"GetAccelStat",function(p,type,stat)
	--accelstart (UNUSED)
	if type == 1
		if p.restat ~= nil
			stat = p.restat[2]
		end
		
		--stat == weight
		local accel = (10 - stat)*15
		
		--heavyweights get a boost
		local weightadjust = stat/3
		accel = $+(11*weightadjust)
		
		accel = ease.insine(FU/3,$,100)
		
		return accel
		
	--acceleration
	else
		if p.restat ~= nil
			stat = p.restat[1]
		end
		
		--stat == speed
		local speed = stat*5
		speed = $+((10-stat)*2)

		--heavyweights get a boost
		local weightadjust = stat/3
		speed = $+(14*weightadjust)
		
		speed = ease.outexpo(FU/4,$,100)
		return speed
	end
end)

local function spawntiredust(p,me,car,spawnfire)
	local sign = 0
	if car.drift ~= 0
		sign = 1
		if car.drift < 0
			sign = -1
		end
		--local drift = car.drift*sign
	end
	
	local myangle = (car.inpain) and p.drawangle or car.angle
	
	local momang = myangle + ((ANGLE_45/5)*car.drift)
	
	local offx = P_ReturnThrustX(nil,momang + ANGLE_90*sign,-me.radius*3/4) 
	local offy = P_ReturnThrustY(nil,momang + ANGLE_90*sign,-me.radius*3/4) 
	
	local spawn1,spawn2
	local spawn1 = P_SpawnMobjFromMobj(me,0,0,0,MT_THOK)	
	local spawn2 = P_SpawnMobjFromMobj(me,0,0,0,MT_THOK)
	
	local particles = {}
	
	for i = -1,1,2
		
		
		local spawn = i == -1 and spawn1 or spawn2
		
		local newx = me.x + P_ReturnThrustX(nil,momang + ANGLE_135*i, 32*me.scale) + offx
		local newy = me.y + P_ReturnThrustY(nil,momang + ANGLE_135*i, 32*me.scale) + offy
		
		if me.standingslope
			spawn.z = P_GetZAt(me.standingslope,spawn.x,spawn.y)
		end
		
		spawn.scale = me.scale
		spawn.flags2 = $|MF2_DONTDRAW
		P_SetOrigin(spawn,
			newx,
			newy,
			GetActorZ(me,spawn,1)
		)
		if me.standingslope
			P_SetOrigin(spawn,
				spawn.x,spawn.y,
				P_GetZAt(me.standingslope,spawn.x,spawn.y)
			)
		end
		
		if not spawnfire
			for j = 0,1
				local dust = P_SpawnMobjFromMobj(spawn,0,0,0,MT_SPINDUST)
				dust.scale = FixedMul(me.scale,FU*8/10 + P_RandomFixed())
				P_SetObjectMomZ(dust,P_RandomRange(0,3)*FU)
				dust.momx,dust.momy = me.momx,me.momy
				
				local angle = momang + P_RandomRange(-15,15)*ANG1
				dust.angle = angle
				P_Thrust(dust,angle,P_RandomRange(0,-15)*me.scale)
				
				dust.colorized = true
				dust.color = SKINCOLOR_CLOUDY
				
				table.insert(particles,dust)
			end
		else
			local flame = P_SpawnMobjFromMobj(spawn,0,0,0,MT_SPINFIRE)
			flame.scale = me.scale/4+ FixedMul(me.scale,FU*8/10 + P_RandomFixed())
			flame.target = me
			flame.fuse = TR/2
			flame.flags = $|MF_NOCLIPTHING &~(MF_PAIN)
			
			/*
			if not (gametyperules & GTR_FRIENDLY)
			and (false == true)
				flame.state = S_TEAM_SPINFIRE1
				flame.color = me.color
			end
			*/
			
			table.insert(particles,flame)
		end
		
	end
	
	if spawn1 and spawn1.valid
		P_RemoveMobj(spawn1)
	end
	if spawn2 and spawn2.valid
		P_RemoveMobj(spawn2)
	end
	
	return particles
end

local function dospindash(p,me,car,docharge)
	
	local maxcharge = ((car.stats[1] + 8) * TR) / 6
	local takis = p.takistable
	
	takis.spritexscale = $+(FU/5)
	takis.spriteyscale = $-(FU/5)
	
	if not docharge
		car.spindashrelease = true
		S_StartSound(car,sfx_s23c)
		S_StopSoundByID(car,sfx_s3kab)
		S_StopSoundByID(car,sfx_s3kd9s)
		car.tiregrease = max($,2*TR)
		
		if car.spindashcharge > 20
			local thrust = (car.spindashcharge*me.scale)/3
			P_InstaThrust(car,car.angle,thrust)
			car.accel = car.maxspeed*3/4
		end
		car.spindashboost = max(TR/2,car.spindashcharge/5)
		
		car.spindash = false
		car.spindashcharge = 0
		car.spindashsound = 0
		car.ebrake = false
	else
		local maxcharge = ((car.stats[1] + 8) * TR) / 6
		
		if car.spindashcharge == 0
			S_StartSound(car,sfx_s3kab)
		end
		
		if car.spindashcharge < maxcharge
			car.spindashcharge = $+2
			
			if car.offroad
				car.spindashcharge = $+1
			end
		elseif car.spindashcharge > maxcharge
			car.spindashcharge = maxcharge
		end
		
		if car.spindashcharge > maxcharge/2
			local dusts = spawntiredust(p,me,car)
			for k,mo in ipairs(dusts)
				if not (mo and mo.valid) then continue end
				mo.scale = $/2
			end
		end
		
		if car.spindashcharge/(maxcharge/5) ~= car.spindashsound
			S_StartSound(car,sfx_s3kab)
			car.spindashsound = car.spindashcharge/(maxcharge/5)
		end
		
		TakisSpawnDust(me,
			car.angle+FixedAngle(P_RandomRange(-25,25)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
			-FixedDiv(car.radius,me.scale)/FU,
			P_RandomRange(-1,2)*me.scale,
			{
				xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
				yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
				zspread = 0,--(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				thrust = P_RandomRange(-5,-12)*me.scale,
				thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				momz = P_RandomRange(20,10)*(me.scale/2),
				momzspread = 0, --((P_RandomChance(FU/2)) and 1 or -1),
				
				scale = me.scale/2,
				scalespread = 0, --(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				fuse = 15+P_RandomRange(-3,5),
			}
		)
		
		car.spindash = true
		car.moving = 0
		car.reversing = 0
		car.ebrake = true
		return false
	end
end

--drrr source
local function lookatpeople(p,car,data)
	local me = p.mo
	local takis = p.takistable
	
	local maxdist = 1280*car.scale
	local blindspot = 10*FU
	local glancedir = 0
	local lastvalidglance
	local lookingback = p.cmd.buttons & BT_CUSTOM3
	local taunting = false
	
	for player in players.iterate
		local back,diff,distance
		local dir = -1
		
		if player ~= nil
			local victim = player.mo
			
			--why are you glancing at yourself
			if player == p
				continue
			end
			
			if player.spectator
				continue
			end
			
			distance = R_PointToDist2(car.x, car.y, victim.x, victim.y)
			distance = R_PointToDist2(0, car.z, distance, victim.z)
			if distance > maxdist
				continue
			end
			
			--this sucks!!!
			back = FixedAngle(AngleFixed(car.angle)+180*FU)
			diff = FixedAngle(AngleFixed(R_PointToAngle2(car.x, car.y, victim.x, victim.y))-AngleFixed(back))
			if AngleFixed(diff) > 180*FU
				diff = InvAngle(diff)
				dir = -$
			end
			
			--not behind
			if AngleFixed(diff) > 90*FU
				continue
			end
			
			if AngleFixed(diff) < blindspot
				continue
			end
			
			if not P_CheckSight(car,victim)
				continue
			end
			
			glancedir = $+dir
			lastvalidglance = dir
			
			--horn
			if lookingback
				taunting = true
				if TakisKart_KarterData[me.skin].horns ~= nil
				and #TakisKart_KarterData[me.skin].horns > 0
					
					if car.hornwait == 0
						S_StartSound(me,choosething(unpack(TakisKart_KarterData[me.skin].horns)))
						car.hornwait = 3*TR
					end
				end
			end
		end
	end
	
	if glancedir > 0
		return 1,taunting
	elseif glancedir < 0
		return -1,taunting
	end
	return lastvalidglance,taunting
	
end

--SIGMA MODE FUNCTION
/*
	--basic info for animations
	
	All kart animations use the KART sprite2, using 26 frames
	(12 optional if the skin doesn't use looking back frames).
	All animations (with a few exceptions) follow the same format of:
	
	frame 1 - neutral
	frame 2 - harsh idle vibration
	frame 3 - tireshine
	
	If you wanted to animate the base/idle animation, you'd have:
	
	frame A - neutral
	frame B - harsh idle vibration
	frame C - tireshine
	
	Some animations don't follow this convention, like pain (frame J)
	and drifting animations (K & L for left, M & N for right)
	
	Pain is 1 frame, no variations.
	Drifting is 1 neutral frame, 1 tireshine frame. Drifting should
	not have any visual offsets, as they are handled in code.
	
	frame K - neutral
	frame L - tireshine
	
	Frame list:
	
	-- Base/Idle animation
	A - neutral
	B - harsh idle vibration
	C - tireshine
	
	-- Turning Left
	D - neutral
	E - harsh idle vibration
	F - tireshine
	
	-- Turning Right
	G - neutral
	H - harsh idle vibration
	I - tireshine
	
	-- Pain
	J - neutral
	
	-- Drifting Left
	K - neutral
	L - tireshine
	
	-- Drifting Right
	M - neutral
	N - tireshine
	
	
	{ These animations are optional if the skin doesn't look to the sides
		-- Glancing Left
		O - neutral
		P - harsh idle vibration
		Q - tireshine
		
		-- Glancing Right
		R - neutral
		S - harsh idle vibration
		T - tireshine
		
		-- Looking Left
		U - neutral
		V - harsh idle vibration
		W - tireshine
		
		-- Looking Right
		X - neutral
		Y - harsh idle vibration
		Z - tireshine
	}
	
	This is completely different if the skin uses legacy frames. (SRB2K)

	Frame list:
	
	-- Base/Idle animation
	A - neutral
	B - harsh idle vibration
	
	-- Turning Left
	C - neutral
	D - harsh idle vibration
	
	-- Turning Right
	E - neutral
	F - harsh idle vibration
	
	-- Base/Idle animation
	G - Slow speed upwards offset
	
	-- Turning Left
	H - Slow speed upwards offset
	
	-- Turning Right
	I - Slow speed upwards offset
	
	-- Base/Idle animation
	J - tireshine
	
	-- Turning Left
	K - tireshine
	
	-- Turning Right
	L - tireshine
	
	-- Pain
	Q - neutral
	
	-- Drifting Left
	M - neutral
	N - tireshine
	
	-- Drifting Right
	O - neutral
	P - tireshine
	
	{
		-- Misc/SRB2K specific.
		R - crushed
		S - signpost
	}
*/

--handle animations
--anim handle
local function animhandle(p,car,data,setspeed)
	local me = p.mo
	if me.state ~= S_PLAY_TAKIS_KART
		me.state = S_PLAY_TAKIS_KART
	end
	if me.sprite2 ~= SPR2_KART
		me.sprite2 = SPR2_KART
	end
	local frameset = frames.norm
	if TakisKart_KarterData[me.skin].legacyframes
		frameset = frames.legacy
	end
	
	local speed = setspeed or GetCarSpeed(car)
	local grounded = car.grounded
	local takis = p.takistable
	
	local rumble = leveltime % 2 == 0
	local dontrumble = false
	
	local frame = frameset.neutral
	local spinningwheels = true
	local yoffset = 0
	
	local slowspeed = (car.maxspeed*3/4) + car.maxspeed/4
	if car.ebrake
	or (car.braking and car.grounded)
		speed = 15*FU
	end
	
	car.animstate = 0
	
	if car.turning
		local turn = car.sidemove
		if abs(car.sidemove) < CMD_DEADZONE
			turn = 0
		end
		
		--right
		if turn > 0
			frame = frameset.turnR
		--left
		elseif turn < 0
			frame = frameset.turnL
		end
	end
	
	if (data.nolookback ~= true)
		if takis.c3
		or (car.moving < -5 or car.reversing)
			frame = frameset.glanceR
			
			if takis.c3
				local destglance,taunt = lookatpeople(p,car,data)
				if (destglance == nil) then destglance = -1 end
				
				local ang = car.angle - (ANGLE_45*destglance)
				
				if not (car.mirrorshine and car.mirrorshine.valid)
					local spark = P_SpawnMobjFromMobj(car,
						P_ReturnThrustX(nil,ang,-me.radius*11/10),
						P_ReturnThrustY(nil,ang,-me.radius*11/10),
						0, --me.height/4,
						MT_SUPERSPARK
					)
					if (P_MobjFlip(car) == -1)
						spark.z = $-spark.height
					end
					P_SetOrigin(spark,spark.x,spark.y,spark.z)
					
					spark.dontdrawforviewmobj = car.viewaway
					spark.spritexscale,spark.spriteyscale = 2*FU,2*FU
					spark.blendmode = AST_ADD
					car.mirrorshine = spark
				else
					local spark = car.mirrorshine
					P_MoveOrigin(spark,
						me.x + P_ReturnThrustX(nil,ang,-me.radius*11/10),
						me.y + P_ReturnThrustY(nil,ang,-me.radius*11/10),
						me.z --+ me.height/4
					)
					if (P_MobjFlip(car) == -1)
						spark.z = $-spark.height
					end
					spark.blendmode = AST_ADD
					spark.dontdrawforviewmobj = car.viewaway
				end
				
			end
			
		elseif not takis.c3
			if (car.mirrorshine and car.mirrorshine.valid)
				P_RemoveMobj(car.mirrorshine)
				car.mirrorshine = nil
			end
		end
		
		if abs(car.sidemove) < CMD_DEADZONE
		and car.drift == 0
		and grounded
			local destglance,taunt = lookatpeople(p,car,data)
			if destglance == 1
				frame = taunt and frameset.lookL or frameset.glanceL
			elseif destglance == -1
				frame = taunt and frameset.lookR or frameset.glanceR
			end
		end
	end
	
	me.spritexoffset = 0
	if car.drift
		local frametic = car.drifttime % 2 == 1
		local turndir = -(car.sidemove > 0 and 1 or car.sidemove < 0 and -1 or 0)
		local driftdir = ((car.drift > 0) and 1 or -1)
		
		yoffset = 0
		
		if driftdir > 0
			frame = frameset.driftL
		else
			frame = frameset.driftR
		end
		
		--and TakisKart_KarterData[me.skin].legacyframes ~= true
		if (turndir == driftdir)
		and grounded
			local modu = (car.drifttime % 4)+1
			
			if modu == 1
				me.spritexoffset = $+(2*FU)
			elseif modu == 3
				me.spritexoffset = $-(2*FU)
			end
		end
		
		if grounded
		and not frametic
			if (turndir ~= 0 and turndir ~= driftdir)
				yoffset = $+(FU*2)
			end
		end
		
		if TakisKart_KarterData[me.skin].legacyframes == true
			if not grounded
			--or (turndir == 0)
				rumble = 0
			end
		end
		
		if rumble
			frame = $+frameset.vibrateoffset
			--me.spritexoffset = $-(2*FU)
		end
		if not car.offroad
			rumble = 0
		end
		
		spinningwheels = false
	end
	if (car.sliptide ~= 0)
		local lookL = frameset.lookL
		local lookR = frameset.lookR
		if (TakisKart_KarterData[me.skin].legacyframes == true)
			lookL = frameset.driftR
			lookR = frameset.driftL
			spinningwheels = false
		end
		
		if car.sliptide > 0
			frame = lookR
		else
			frame = lookL
		end
	end
	
	if car.spindash
		local maxcharge = ((car.stats[1] + 8) * TR) / 6
		local shake = FixedMul(((car.spindashcharge*FU)/maxcharge),FU)
		shake = $ * (leveltime & 1 and 1 or -1)
		
		me.spritexoffset = shake
	end
	
	if car.braking
	and car.grounded
		yoffset = $ + (leveltime & 1 and 2*FU or 0)
	end
	
	if P_PlayerInPain(p)
	or car.inpain
		frame = frameset.pain
		dontrumble = true
	end
	
	if car.pogospring
		frame = (P_PlayerInPain(p) or car.inpain) and frameset.pain or frameset.neutral
		spinningwheels = true
	end
	
	if not dontrumble
		--always spin wheels in midair
		if not grounded
		or car.waterrunning
			speed = slowspeed*2
		end
		
		if speed < FU
			frame = (rumble and spinningwheels) and $ + frameset.vibrateoffset or $
		elseif speed > FU
			car.animstate = 2
			--spinning wheels
			if spinningwheels
				local shineoffset = frameset.tireshineoffset
				
				if frame == frameset.turnL
				and frameset.turnLts ~= nil
					shineoffset = frameset.turnLts
				elseif frame == frameset.turnR
				and frameset.turnRts ~= nil
					shineoffset = frameset.turnRts
				end
				
				if speed < slowspeed
				and car.drift == 0
					if TakisKart_KarterData[me.skin].legacyframes == true
						local frameoffset = 6
						
						if frame == frameset.turnL
							frameoffset = 5
						elseif frame == frameset.turnR
							frameoffset = 4
						end
						
						frame = $+((not rumble) and frameoffset or 0)
					else
						yoffset = $+((rumble) and FU or 0)+yoffset
					end
					car.animstate = 1
				end
				
				frame = $+(rumble and shineoffset or 0)
			end
			
		end
	end
	
	if car.pogospring
		yoffset = 0
		car.painspin = $+GetCarSpeed(car)
	end
	
	if GetCarSpeed(car)/FU ~= 0
	and car.offroad
		yoffset = $+((rumble) and FU or 0)
	end
	
	if car.waterrunning
		if takis.accspeed - p.runspeed < slowspeed
			yoffset = $+((rumble) and FU or 0)
			if leveltime % 5 == 0
				S_StartSound(car,sfx_splish)
			end
		end
	end
	
	me.spriteyoffset = yoffset
	
	if p.powers[pw_super]
	and not (p.charflags & SF_NOSUPERSPRITES)
		me.sprite2 = $|FF_SPR2SUPER
	end
	
	me.frame = ($ &~FF_FRAMEMASK)|frame
	
end

--srb2k source
--This is resource intensive
local function soundhandle(p,car,data)
	
	local numsounds = TakisKart_ExtraSounds and 13 or 9
	
	local closedist = 160*FU
	local fardist = 1536*FU
	
	local dampenval = 48
	
	local class,s,w = 0,0,0
	
	local volume = 255
	local voldamp = FU
	
	local targetsnd = 0
	
	local kartspeed = car.stats[1]
	local kartweight = car.stats[2]
	if p.restat ~= nil
		kartspeed,kartweight = unpack(p.restat)
	end
	
	s = (kartspeed-1)/3
	w = (kartweight-1)/3
	if s < 0 then s = 0 end
	if s > 2 then s = 2 end
	if w < 0 then w = 0 end
	if w > 2 then w = 2 end
	
	class = s+(3*w)
	
	if leveltime < 8 or p.spectator -- or p.exiting
		car.enginesound = 0
		return
	end
	
	local doreturn = false
	if TakisKart_ExtraSounds
		doreturn = (leveltime % 8)
	else
		for i = 0,numsounds - 1
			if S_SoundPlaying(car,sfx_karte0 + i)
				doreturn = true
			end
		end
	end
	
	if doreturn --(leveltime % 8)
		return
	end
	
	local cmdmove = (6*abs(car.moving))/25	
	local speedthing = GetCarSpeed(car)/FU/20
	if not TakisKart_ExtraSounds
		speedthing = $/2
	end
	targetsnd = (cmdmove+speedthing)/2
	
	if car.ebrake
		targetsnd = 12
	end
	
	targetsnd = clamp(0,$,numsounds -1) --max(0,min(numsounds-1,targetsnd))
	
	if car.enginesound < targetsnd then car.enginesound = $+1 end
	if car.enginesound > targetsnd then car.enginesound = $-1 end
	car.enginesound = clamp(0,$,numsounds -1)
	
	-- This code calculates how many players (and thus, how many engine sounds) are within ear shot,
	-- and rebalances the volume of your engine sound based on how far away they are.

	-- This results in multiple things:
	-- * When on your own, you will hear your own engine sound extremely clearly.
	-- * When you were alone but someone is gaining on you, yours will go quiet, and you can hear theirs more clearly.
	-- * When around tons of people, engine sounds will try to rebalance to not be as obnoxious.
	
	for player in players.iterate
		local thisvol = 0
		local dist = 0
		
		if not (player.mo and player.mo.valid)
			continue
		end
		
		if (player.spectator)
			continue
		end
		
		if (p == player)
		and (player == displayplayer)
			continue
		end
		
		if not player.inkart
			continue
		end
		
		dist = FixedHypot(
					FixedHypot(
						p.mo.x - player.mo.x,
						p.mo.y - player.mo.y
					),
					p.mo.z - player.mo.z
				)/2
		
		if dist > fardist
			continue
		elseif dist < closedist
			thisvol = 255
		else
			thisvol = (15*((closedist-dist)/FU))/((fardist-closedist) >> (FRACBITS+4))
		end
		
		voldamp = $+(thisvol*dampenval)
	end
	
	if voldamp > FU
		volume = FixedDiv(volume*FU,voldamp)/FU
	end
	
	if volume <= 0
		return
	end
	
	local startingsound = TakisKart_ExtraSounds and (sfx_krta00 or sfx_thok) or sfx_karte0
	if not TakisKart_ExtraSounds
		class = 0
		volume = $/2
	end
	S_StartSoundAtVolume(car,startingsound+car.enginesound+(class*numsounds),volume)
	
end

local function spinouthandle(p,car)
	local me = p.mo
	local takis = p.takistable
	local spintype = car.spinouttype
	local cmd = p.cmd
	
	if P_PlayerInPain(p)
	and spintype == 0
	and not (takis.inwaterslide or p.pflags & PF_SLIDING)
		TakisKart_DoSpinout(p,nil,SPINOUT_SPIN)
		spintype = car.spinouttype
	end
	
	if spintype == 0 then return end
	
	local grounded = P_IsObjectOnGround(car)
	me.flags2 = $ &~MF2_DONTDRAW
	
	takis.inPain,takis.inFakePain,car.inpain = true,true,true
	if me.skin ~= TAKIS_SKIN
		takis.inFakePain = false
	end
	
	local endspinout = false
	local capinv = false
	car.paintics = $+1
	car.drift = 0
	car.driftedout = true
	car.driftspark = 0
	car.driftboost = 0
	cmd.sidemove,cmd.forwardmove = 0,0
	takis.tiltdo = false
	takis.tiltvalue = 0
	
	if spintype & (SPINOUT_BIGTUMBLE|SPINOUT_TUMBLE)
		car.accel = $*9/10
		me.flags2 = $ &~MF2_DONTDRAW
		local speed = GetCarSpeed(car,CS_VERT)
		if spintype & SPINOUT_BIGTUMBLE
			speed = $*2
		end
		
		car.painspin = $-speed
		
		if not grounded
			car.jumped = false
			if not car.gooptime
				car.momz = $+(P_GetMobjGravity(car)*3/5)
				if spintype & SPINOUT_BIGTUMBLE
					car.momz = $+(P_GetMobjGravity(car)*5/4)
					takis.tiltdo = false
					takis.tiltvalue = 0
					takis.tiltroll = 0
					
					me.rollangle = $+(speed*60)
				end
				if car.momz*takis.gravflip < -40*me.scale
					spintype = $|SPINOUT_BIGTUMBLE
					car.spinouttype = $|SPINOUT_BIGTUMBLE
				end
			end
			if takis.fakeflashing < flashingtics-2
				takis.fakeflashing = flashingtics
			end
		else
			local tumblemin = (spintype & SPINOUT_BIGTUMBLE) and -17*car.scale or -7*car.scale
			if car.oldmomz ~= nil
			and car.oldmomz <= tumblemin
				local div = 2*FU
				if spintype & SPINOUT_BIGTUMBLE
					div = FU*6/5
					if car.oldmomz >= -25*car.scale
						car.spinouttype = $|SPINOUT_TUMBLE &~SPINOUT_BIGTUMBLE
						me.rollangle = 0
					end
				end
				local thrust = FixedDiv(FixedDiv(car.oldmomz,car.scale),div)
				P_SetObjectMomZ(car,-thrust)
				DoQuake(p,abs(thrust),TR)
				S_StartSound(me,(abs(thrust) < 40*me.scale) and sfx_s3k5d or sfx_s3k5f)
			else
				car.threshold = $+1
				car.painspin = $ - ($/6)
				me.rollangle = 0
				
				if (abs(car.painspin) <= ANG15/4)
				and car.threshold >= TR
					endspinout = true
				end
			end
		end
	elseif spintype & SPINOUT_SPIN
		car.accel = $*9/10
		local speed = GetCarSpeed(car,CS_VERT)*5
		car.painspin = $+speed
		
		if grounded
			if (FixedHypot(car.momx - p.cmomx,car.momy - p.cmomy) <= me.scale*4)
				car.threshold = $+1
				car.painspin = $ - ($/6)
			else
				car.threshold = max($-1,0)
			end
			
			if (FixedHypot(car.momx - p.cmomx,car.momy - p.cmomy) <= me.scale/15)
			and car.accel == 0
			and car.paintics >= TR
				if (abs(car.painspin) <= ANG15/4)
				and car.threshold >= TR
					endspinout = true
				end
			end
		end
	elseif spintype & SPINOUT_STUMBLE
		car.accel = $*9/10
		local speed = GetCarSpeed(car,CS_VERT)*5
		
		if not grounded
			car.jumped = false
			if not car.gooptime
				car.momz = $+(P_GetMobjGravity(car)*4)
				car.painspin = $+speed
				me.rollangle = $+FixedAngle(speed/3)
				
			end
			if takis.fakeflashing < flashingtics-2
				takis.fakeflashing = flashingtics
			end
		else
			local tumblemin = -7*car.scale
			if car.oldmomz ~= nil
			and car.oldmomz <= tumblemin
				local div = 2*FU
				if spintype & SPINOUT_BIGTUMBLE
					div = FU*6/5
					if car.oldmomz >= -25*car.scale
						car.spinouttype = $|SPINOUT_TUMBLE &~SPINOUT_BIGTUMBLE
						me.rollangle = 0
					end
				end
				local thrust = FixedDiv(FixedDiv(car.oldmomz,car.scale),div)
				P_SetObjectMomZ(car,-thrust)
				DoQuake(p,abs(thrust),TR)
				S_StartSound(me,(abs(thrust) < 40*me.scale) and sfx_s3k5d or sfx_s3k5f)
			else
				if (FixedHypot(car.momx - p.cmomx,car.momy - p.cmomy) <= me.scale/15)
				and car.accel == 0
				and car.paintics >= TR
					endspinout = true
				end
				me.rollangle = 0
				car.painspin = $ - ($/6)
			end
		end
		
	end
	
	if car.paintics == 15*TR
	or endspinout
	and car.paintics > 5
		car.paintics = 0
		me.rollangle = 0
		car.painspin = 0
		car.inpain = false
		takis.fakeflashing = flashingtics
		car.spinouttype = 0
		car.threshold = 0
	end
	
end

local function fxhandle(p,car,wallstickingang)
	local me = p.mo
	local takis = p.takistable
	
	if (me.skin ~= TAKIS_SKIN)
		DoTakisSquashAndStretch(p,me,takis)
		if abs(me.momz) >= 18*me.scale
		and wallstickingang == nil
			local mom = FixedDiv(abs(me.momz),me.scale)-18*FU
			mom = $/50
			mom = -min($,FU*4/5)
			takis.spritexscale,
			takis.spriteyscale = $1+mom,$2-(mom*9/10)
		end
	end
	
	--underwater tilt
	if takis.inWater
		takis.tiltdo = true
		local sidemove = -p.cmd.sidemove*55*FU
		local movespeed = min(FixedDiv(takis.accspeed,22*FU),FU)
		if car.drift ~= 0
			sidemove = $ + (45*FU*car.drift)*10
		end
		
		takis.tiltvalue = $+FixedMul(sidemove,movespeed)
		takis.tiltvalue = -max(-ANG30,min(ANG30,takis.tiltvalue))
	end
	
	local planez = (P_MobjFlip(me) == 1 and me.floorz or me.ceilingz)
	
	if not (me.laststandingslope)
	and not (me.standingslope)
	and (me.eflags & (MFE_JUSTSTEPPEDDOWN))
	and (me.lastfloorz ~= planez)
	and P_IsObjectOnGround(car)
		S_StartSound(car,
			car.stairjank >= 15 and sfx_s23b or sfx_s268
		)
		car.stairjank = 17
	end
	
	local jankang = 0
	if car.stairjank
		if car.stairjank < 0 then car.stairjank = 0 end
		
		if car.stairjank >= 13
			local ang = car.angle+((leveltime % 4) < 2 and ANGLE_90 or -ANGLE_90)
			local spawn = P_SpawnMobjFromMobj(car,
				P_ReturnThrustX(nil,ang,FixedDiv(me.radius,me.scale)),
				P_ReturnThrustY(nil,ang,FixedDiv(me.radius,me.scale)),
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
			end
			spawn.flags2 = $|MF2_DONTDRAW
			
		end
		
		local ang = (ANGLE_11hh / 2 /
					(17 / car.stairjank))
		jankang = ((leveltime % 4) < 2 and ang or -ang)
		/*
		takis.tiltdo = true
		takis.tiltvalue = $+jankang
		takis.tiltroll = $+takis.tiltvalue
		*/
		
		me.rollangle = $+jankang
		takis.tiltvalue = $+jankang
		takis.tiltroll = $+jankang
		car.stairjank = max($-1,0)
	end
	
	/*
	if not extrastuff
		car.friction = ORIG_FRICTION + (FU/128)
	end
	*/
	if car.tiregrease
		local degrease = 1
		local speedin = GetCarSpeed(car)/FU/10
		local prevfric = car.friction
		degrease = $+max(3-speedin,0)
		
		for i = -1,1,2
			local tirefx = car.tirefxL
			if i == 1
				tirefx = car.tirefxR
			end
			
			local off = {
				basex = P_ReturnThrustX(nil,car.angle+(ANGLE_45*i),-me.radius*2),
				basey = P_ReturnThrustY(nil,car.angle+(ANGLE_45*i),-me.radius*2),
				x = P_ReturnThrustX(nil,car.angle+ANGLE_90,-me.radius*i),
				y = P_ReturnThrustY(nil,car.angle+ANGLE_90,-me.radius*i),
			}
			
			if leveltime % 12 == 0
				local dust = P_SpawnMobjFromMobj(me,
					FixedDiv(off.basex+off.x,me.scale),
					FixedDiv(off.basey+off.y,me.scale),
					0,
					MT_TAKIS_CLUTCHDUST
				)
				dust.angle = R_PointToAngle2(dust.x,dust.y,me.x,me.y)+ANGLE_180--+(ANG15*i)
				--dust.momx,dust.momy = $1+(car.momx),$2+(car.momy)
				
				if i == -1
					car.tirefxL = dust
				else
					car.tirefxR = dust
				end
			end	
			
			if (tirefx and tirefx.valid)
				P_MoveOrigin(tirefx,
					me.x+off.basex+off.x,
					me.y+off.basey+off.y,
					GetActorZ(me,tirefx,1)
				)
				tirefx.angle = R_PointToAngle2(tirefx.x,tirefx.y,me.x,me.y)+ANGLE_180--+(ANG15*i)
			end
			
		end
		
		if car.tiregrease <= degrease
			car.tiregrease = 0
		else
			car.tiregrease = $-degrease
		end
		car.friction = $+((FU-prevfric)/greasetics)*car.tiregrease
	else
		if (car.tirefxL and car.tirefxL.valid)
			P_RemoveMobj(car.tirefxL)
			car.tirefxL = nil
		end
		if (car.tirefxR and car.tirefxR.valid)
			P_RemoveMobj(car.tirefxR)
			car.tirefxR = nil
		end
	end
	
	if P_IsObjectOnGround(car)
	and (me.lastgrounded == false)
		p.jp = 3
		p.jt = -5
		S_StartSound(car,sfx_s3k4c)
		for i = 0, 8
			local radius = me.scale*16
			local fa = (i*ANGLE_45)
			local mz = takis.lastmomz/10
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
	
	--carbon emissions!!!
	/*
	local chance = false
	if GetCarSpeed(car,CS_ACCEL) == 0
		chance = true
	end
	if GetCarSpeed(car,CS_ACCEL) <= (TakisKart_KarterData[me.skin].basenormalspeed)*FU/4
		local slowspeed = (TakisKart_KarterData[me.skin].basenormalspeed)*FU/4
		chance = P_RandomChance(
			FixedDiv(
				slowspeed - GetCarSpeed(car,CS_ACCEL),
				slowspeed
			)
		)
	end
	if GetCarSpeed(car) > (TakisKart_KarterData[me.skin].basenormalspeed*3/2)*TakisKart_GetGearMul()
		chance = true
		
		if (leveltime % 3) == 0
		and car.grounded
			spawntiredust(p,me,car,true)
		end
	end
	
	if TAKIS_NET.noeffects
	or (TakisKart_KarterData[me.skin].bikemode)
	or car.ebrake
	or (TakisKart_KarterData[me.skin].nosmoke)
		chance = false
	end
	if chance
		local height = TakisKart_KarterData[me.skin].height
		if height == nil
			height = skins[p.skin].height
		end
		--height = $*FU --FixedMul($,me.scale)
		
		local z = ((-FU) + (height/2))*takis.gravflip
		if P_MobjFlip(me) == -1
			z = (me.z + height) - (height/2)
		end
		
		local th = P_SpawnMobjFromMobj(me,
			0,0,z,
			MT_THOK
		)
		P_RemoveMobj(th)
		
		local angle = (car.inpain) and p.drawangle or car.angle
		angle = $ + ((ANGLE_45/5)*car.drift)
		
		for i = -1,1,2
			local dust = TakisSpawnDust(me,
				angle-(FixedAngle(37*FU+(P_RandomRange(-4,4)*FU) + P_RandomFixed())*i),
				-me.radius/me.scale,
				z,
				{
					xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					zspread = 0,--(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = P_RandomRange(-4,-12)*me.scale,
					thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					momz = P_RandomRange(6,0)*(me.scale/2),
					momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
					
					scale = me.scale/2,
					scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					fuse = 20+P_RandomRange(-5,5),
				}
			)
			dust.colorized = true
			dust.color = SKINCOLOR_BLACK
		end
	end
	*/
	
	if car.waterrunning
	or (me.eflags & (MFE_TOUCHWATER|MFE_UNDERWATER) == MFE_TOUCHWATER and car.grounded)
	and GetCarSpeed(car) >= 3*FU
		local radius = -(me.radius + 20*me.scale)
		local myang = TakisMomAngle(car)
		local angle = ANGLE_45
		--?
		local sidepushx = P_ReturnThrustX(nil,myang,-radius)
		local sidepushy = P_ReturnThrustY(nil,myang,-radius)
		
		local scale = me.scale /**3/2
		if takis.accspeed - p.runspeed < 20*FU
			scale = $/2
		end
		*/
		scale = FixedDiv(GetCarSpeed(car),car.basemaxspeed)
		--scale = max($,me.scale)
		radius = $ - scale
		
		if not (car.waterfxL and car.waterfxL.valid)
			local effect = P_SpawnMobjFromMobj(me,
				P_ReturnThrustX(nil,myang - angle,FixedDiv(radius,me.scale)) - sidepushx,
				P_ReturnThrustY(nil,myang - angle,FixedDiv(radius,me.scale)) - sidepushy,
				0,
				MT_THOK
			)
			P_SetOrigin(effect, effect.x,effect.y,me.watertop)
			effect.state = S_TAKIS_WATERSPLASH
			effect.scale = scale
			effect.angle = R_PointToAngle2(effect.x,effect.y, me.x,me.y)
			car.waterfxL = effect
		end
		
		if not (car.waterfxR and car.waterfxR.valid)
			local effect = P_SpawnMobjFromMobj(me,
				P_ReturnThrustX(nil,myang + angle,radius) + sidepushx,
				P_ReturnThrustY(nil,myang + angle,radius) + sidepushy,
				0,
				MT_THOK
			)
			P_SetOrigin(effect, effect.x,effect.y,me.watertop)
			effect.state = S_TAKIS_WATERSPLASH
			effect.scale = scale
			effect.angle = R_PointToAngle2(effect.x,effect.y, me.x,me.y)
			car.waterfxR = effect
		end
		
		for i = -1,1,2
			local effect = car.waterfxL
			if i == 1 then effect = car.waterfxR end
			
			if not (effect and effect.valid) then continue end
			
			P_MoveOrigin(effect,
				car.x + P_ReturnThrustX(nil,myang + angle*i,radius) + sidepushx,
				car.y + P_ReturnThrustY(nil,myang + angle*i,radius) + sidepushy,
				me.watertop --GetActorZ(me,effect,1)
			)
			effect.scale = scale
			effect.angle = myang + angle*i --R_PointToAngle2(effect.x,effect.y, me.x,me.y)
		end
	else
		if (car.waterfxL and car.waterfxL.valid)
			P_RemoveMobj(car.waterfxL)
			car.waterfxL = nil
		end
		if (car.waterfxR and car.waterfxR.valid)
			P_RemoveMobj(car.waterfxR)
			car.waterfxR = nil
		end
	end
	
	if (car.sliptidetilt ~= 0)
		takis.tiltdo = false
		takis.tiltvalue = 0
		takis.tiltroll = 0
		takis.tiltangle = 0
		
		local viewang = R_PointToAngle(me.x,me.y)
		local angle = viewang - me.angle
		local sliptidetilt = car.sliptidetilt / 4
		
		local angleadd = FixedMul(sliptidetilt, sin(abs(angle)) )
						+ FixedMul(sliptidetilt, cos(angle))
		
		me.rollangle = angleadd + jankang
		--takis.tiltvalue = $+angleadd
		--takis.tiltroll = $+angleadd
	end
	if (car.sliptide ~= 0)
	and (leveltime & 1)
		local travelang = TakisMomAngle(car)
		do
			local newx = P_ReturnThrustX(nil,travelang - (car.sliptide*ANGLE_45), 24*car.scale)
			local newy = P_ReturnThrustY(nil,travelang - (car.sliptide*ANGLE_45), 24*car.scale)
			local dust = P_SpawnMobjFromMobj(me,
				newx,newy,0,
				MT_TAKIS_CLUTCHDUST
			)
			dust.angle = travelang + (car.sliptide*ANGLE_90)
			dust.mirrored = true
			dust.momx = car.momx*6/5
			dust.momy = car.momy*6/5
		end
		

	end
	
	me.laststandingslope = me.standingslope
	me.lastfloorz = planez --P_MobjFlip(me) == 1 and me.floorz or me.ceilingz
	me.lastgrounded = car.grounded --P_IsObjectOnGround(car)
	
	if me.funnyshit
		TakisFancyExplode(me,
			car.x + P_RandomRange(-64,64)*car.scale,
			car.y + P_RandomRange(-64,64)*car.scale,
			car.z,
			P_RandomRange(60,64)*car.scale,
			32,
			nil,
			15,20
		)
		S_StartSound(car,sfx_tkapow)
	end
end


addHook("TouchSpecial",function(car,touch)
	if not (touch.player and touch.player.valid) then return true end
	if not (touch.health) then return true end
	if not (P_IsValidSprite2(touch,SPR2_KART)) then return true end
	--if (touch.skin ~= TAKIS_SKIN) then return true end
	if not TakisKart_Karters[touch.skin] then return true end
	if (touch.player.inkart) then return true end
	if (car.owner ~= touch.player and (car.owner and car.owner.valid)) then return true end
	if (car.fakekart) then return true end
	
	if not (car.paidfor) then P_RemoveMobj(car); return end
	
	local kart = P_SpawnMobjFromMobj(car,0,0,0,MT_TAKIS_KART_HELPER)
	kart.angle = car.angle	
	kart.target = touch
	S_StartSound(kart,sfx_kartst)
	kart.fuel = car.fuel or 100*FU
	touch.player.inkart = 2
end,MT_TAKIS_KART)

addHook("MobjThinker",function(car)
	if not (car and car.valid) then return end
	if not (car.paidfor)
	and not (car.fakekart)
		if not car.thought
			car.thought = true
		else
			P_RemoveMobj(car)
			return
		end
	end
	
	car.shadowscale = car.scale
	
	if car.fakekart
		P_ButteredSlope(car)
		P_ButteredSlope(car)
		car.allowbumps = (not car.facemom) and true or false
		car.flags = $|MF_SOLID|MF_SHOOTABLE &~MF_SPECIAL
		car.frame = B
		
		if car.ceilingz - car.floorz < car.height
		and car.health
			P_KillMobj(car)
		end
		
		if not car.health
			if car.hitlag
				local off = (FU)*car.hitlag
				if leveltime & 1 then off = -$ end
				
				car.spritexoffset = off

				if car.hitlag == TR - 18
					local sfx = P_SpawnGhostMobj(car)
					sfx.flags2 = $|MF2_DONTDRAW
					sfx.fuse = 4*TR
					S_StartSound(sfx,sfx_megadi)
				end
				car.hitlag = $-1
				
				if not car.hitlag
					TakisFancyExplode(car,
						car.x, car.y, car.z,
						P_RandomRange(60,64)*car.scale,
						16,
						nil,
						15,20
					)
					
					local lo = P_SpawnMobjFromMobj(car,0,0,0,MT_TAKIS_KART_LEFTOVER)
					P_SetObjectMomZ(lo,60*FU)
					lo.angle = car.angle
					lo.color = car.color
					lo.destscale = car.scale*3/2
					P_SetScale(lo,lo.destscale)
					P_RemoveMobj(car)
				end
			else
				car.spritexoffset = 0
			end
		elseif car.facemom
			car.angle = TakisMomAngle(car)
		end
		return
	end
	
	if ((car.owner and car.owner.valid) and (displayplayer and displayplayer.valid) and displayplayer ~= car.owner)
	or (TakisKart_Karters[skins[displayplayer.skin].name] ~= true)
	or not P_IsValidSprite2(displayplayer.realmo,SPR2_KART)
		car.frame = B
	else
		car.frame = A
	end
	
end,MT_TAKIS_KART)

--combination of drrr and srb2k source
-- countersteer is how strong the controls are telling us we are turning
-- turndir is the direction the controls are telling us to turn, -1 if turning right and 1 if turning left
local function driftval(p,car, countersteer,data)
	local basedrift
	local driftangle
	local driftweight = data.stats[2]*14;

	-- If they aren't drifting or on the ground this doesn't apply
	if (car.drift == 0 or not car.grounded)
		return 0
	end
	
	/*
	if (player.kartstuff[k_driftend] != 0)
		return -266*car.drift; // Drift has ended and we are tweaking their angle back a bit
	end
	*/
	
	local style = 1 --1 for kart, 2 for drrr
	
	if style == 1
		--basedrift = 90*player.kartstuff[k_drift]; // 450
		--basedrift = 93*player.kartstuff[k_drift] - driftweight*3*player.kartstuff[k_drift]/10; // 447 - 303
		basedrift = 83*car.drift - (driftweight - 14)*car.drift/5; // 415 - 303
		driftangle = abs((252 - driftweight)*car.drift/5);
		return basedrift + FixedMul(driftangle, countersteer);
	elseif style == 2
		basedrift = (83 * car.drift) - (((driftweight - 14) * car.drift) / 5)
		local driftadjust = abs((252 - driftweight) * car.drift / 5)
		
		/*
		if car.tiregrease
			basedrift = $+(($/greasetics)*car.tiregrease)
		end
		*/
		
		return basedrift + FixedMul(driftadjust, countersteer)
	end
	
end

local function brakegfx(p,car)
	local me = p.mo
	local takis = p.takistable
	
	local momang = TakisMomAngle(car)+ANGLE_180
	
	local spawner = P_SpawnMobjFromMobj(car,
		0, --P_ReturnThrustX(nil,momang,30*car.scale),
		0, --P_ReturnThrustY(nil,momang,30*car.scale),
		0,MT_THOK
	)
	spawner.tics,spawner.fuse = 1,1
	P_SetOrigin(spawner,
		spawner.x+FixedMul(15*car.scale,cos(momang+ANGLE_90)),
		spawner.y+FixedMul(15*car.scale,sin(momang+ANGLE_90)),
		spawner.z
	)
	spawner.scale = car.scale
	
	local spawner2 = P_SpawnMobjFromMobj(car,0,0,0,MT_THOK)
	spawner2.tics,spawner2.fuse = 1,1
	P_SetOrigin(spawner2,
		spawner2.x-FixedMul(15*car.scale,cos(momang+ANGLE_90)),
		spawner2.y-FixedMul(15*car.scale,sin(momang+ANGLE_90)),
		spawner2.z
	)
	spawner2.scale = car.scale
	
	for i = 0,1
		
		local spawn = spawner
		if i == 1 then spawn = spawner2 end
		
		local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
		if car.drift == 0
			TakisKart_SpawnSpark(car,angle,SKINCOLOR_ORANGE,true)
		else
			TakisKart_SpawnSpark(car,angle,
				TakisKart_DriftColor(TakisKart_DriftLevel(car.stats,car.driftspark))
			)
		end
	end
end

--handle drifting and shit here
local function driftstuff(p,car,data)
	local cmd = p.cmd
	local me = p.mo
	local takis = p.takistable
	local grounded = car.grounded --P_IsObjectOnGround(car)
	if car.pogospring
		grounded = true
	end
	
	if car.sliptide
	and (car.drift == 0)
	and CanISliptide(car)
		local turndir = -(car.sidemove >= 0 and 1 or -1)
		if (cmd.sidemove ~= 0)
		and turndir == car.sliptide
			takis.tiltdo = false
			
			if abs(car.sliptidetilt) <= ANGLE_22h
				car.sliptidetilt = (abs($) + ANGLE_11hh / 4) * car.sliptide
			end
			
			if abs(car.sliptidetilt) <= ANGLE_112h
				car.sliptidetilt = (abs($) + ANGLE_11hh) * car.sliptide
			end
			car.sliptidetime = TR/4
		else
			car.sliptidetime = $-1
			car.sliptidetilt = $*7/8
			
			if car.sliptidetime == 0
			or true
				car.sliptide = 0
			end
		end
		
		return
	else
		car.sliptide = 0
		car.sliptidetilt = $ - ($/4)
		if (abs(car.sliptidetilt) <= ANGLE_11hh / 4)
			car.sliptidetilt = 0
		end
	end

	if cmd.buttons & BT_SPIN
		if abs(car.drift) < 5
			if car.drift < 0
				car.drift = $-1
			elseif car.drift > 0
				car.drift = $+1
			end
		end
		
		if car.drift ~= 0
		and grounded
			local stop = false
			
			/*
			if not (car.moving > 0)
			or car.reversing
				car.driftbrake = $+1
				if not S_SoundPlaying(car,sfx_skid)
					S_StartSound(car,sfx_skid)
				end
			else
				car.driftbrake = 0
				S_StopSoundByID(car,sfx_skid)
			end
			*/
			
			if GetCarSpeed(car) < FU
			or GetCarSpeed(car,CS_ACCELNOABS) <= -car.basemaxspeed/3
				car.driftbrake = TR
			elseif GetCarSpeed(car) < 10*FU
				if not car.ctrcar
					car.driftspark = $*9/10
				end
			end
			
			if car.driftbrake >= TR/2
				car.driftedout = true
				car.drift = 0
				car.driftspark = 0
				stop = true
			end
			
			--effects and whatnot
			if not stop
				
				/*
				takis.tiltdo = true
				local sidemove = car.momt*24
				local movespeed = min(FixedDiv(takis.accspeed,22*FU),FU)
				takis.tiltvalue = $+FixedMul(sidemove,movespeed)
				*/
				
				car.drifttime = $+1
				if not (car.offroad)
				and (GetCarSpeed(car) >= 10*FU)
					car.driftspark = $+24
					
					--???
					if (p.powers[pw_shield] & SH_PROTECTELECTRIC)
						car.driftspark = $+16
					end
				end
				if car.bikemode
					car.driftspark = min($,TakisKart_DriftSparkValue(car.stats)*2)
				end
				
				local turndir = -(car.sidemove >= 0 and 1 or -1)
				if (abs(car.sidemove) < CMD_DEADZONE) then turndir = 0 end
				
				local driftdir = ((car.drift > 0) and 1 or -1)
		
				if not car.ctrcar
				and not car.pogospring
					--gain back some lost speed, but not when youre
					--countersteering
					if car.maxspeed < car.basemaxspeed
					and (turndir == driftdir)
					and not car.driftboost
						if GetCarSpeed(car) >= car.maxspeed
							car.maxspeed = $+(FU/255)
						end
						
					end
				end
				
				--you dont just get "free speed", you need to actually
				--maintain it
				if GetCarSpeed(car) <= car.maxspeed - 2*FU
				and car.maxspeed >= car.basemaxspeed + 2*FU
					car.maxspeed = max(GetCarSpeed(car),car.basemaxspeed)
				elseif GetCarSpeed(car) <= car.basemaxspeed
					car.maxspeed = $ + (FU/15)
				end
				
				local diff = car.oldangle-car.angle
				local sign = 1
				if car.drift < 0
					sign = -1
				end
				local drift = car.drift*sign
				
				local momang = car.angle + (ANGLE_45/5)*car.drift
				
				local DS_minscale = FU*7/10
				local DS_maxscale = FU*13/10
				
				if not car.ctrcar
				and not car.pogospring
					if not (car.driftfxL and car.driftfxL.valid)
						local spawner = P_SpawnMobjFromMobj(me,
							P_ReturnThrustX(nil,momang,-FixedDiv(me.radius,me.scale)),
							P_ReturnThrustY(nil,momang,-FixedDiv(me.radius,me.scale)),
							0,
							MT_TAKIS_DRIFTSPARK
						)
						P_SetOrigin(spawner,
							spawner.x+FixedMul(me.radius*5/2,cos(momang+ANGLE_90)),
							spawner.y+FixedMul(me.radius*5/2,sin(momang+ANGLE_90)),
							spawner.z
						)
						spawner.angle = R_PointToAngle2(
							spawner.x,spawner.y,
							me.x,me.y
						)
						--spawner.tracer = car
						car.driftfxL = spawner
					end
					
					if not (car.driftfxR and car.driftfxR.valid)
						local spawner2 = P_SpawnMobjFromMobj(me,
							P_ReturnThrustX(nil,momang,-FixedDiv(me.radius,me.scale)),
							P_ReturnThrustY(nil,momang,-FixedDiv(me.radius,me.scale)),
							0,
							MT_TAKIS_DRIFTSPARK
						)
						P_SetOrigin(spawner2,
							spawner2.x-FixedMul(me.radius*5/2,cos(momang+ANGLE_90)),
							spawner2.y-FixedMul(me.radius*5/2,sin(momang+ANGLE_90)),
							spawner2.z
						)
						spawner2.angle = R_PointToAngle2(
							spawner2.x,spawner2.y,
							me.x,me.y
						)
						--spawner2.tracer = car
						car.driftfxR = spawner2
					end
				end
				
				if TakisKart_DriftLevel(data.stats,car.driftspark) ~= car.olddlevel
					S_StartSoundAtVolume(car,sfx_s3ka2,192)
					local level = TakisKart_DriftLevel(data.stats,car.driftspark)
					if level ~= 5
						if level == 4
							S_StartSound(car,sfx_cdfm40)
							S_StartSound(car,sfx_kc4d)
						elseif level == 3
							S_StartSound(car,sfx_cdfm40)
						end
					else
						S_StartSound(car,sfx_kc4d)
						S_StartSoundAtVolume(car,sfx_s3k9c,192)
					end
					
					for i = 10,P_RandomRange(15,20)
						local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
						local color = TakisKart_DriftColor(TakisKart_DriftLevel(data.stats,car.driftspark))
						local spark = TakisKart_SpawnSpark(car,angle,color)					
					end
					
					car.driftfxS = $+FU
					
				end
				
				/*
				local mul = FU
				if GetCarSpeed(car) > (car.basemaxspeed)*14/10
				and not car.ctrcar
					mul = FixedDiv(GetCarSpeed(car),(car.basemaxspeed)*14/10)
				end
				
				if mul > FU
					local spawn = car.driftfxR
					if car.drift > 0 then spawn = car.driftfxL end
					for i = 3,P_RandomRange(5,7)
						if not (spawn and spawn.valid) then break end
						
						local dust = TakisSpawnDust(spawn,
							spawn.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
							P_RandomRange(0,-20),
							P_RandomRange(-1,2)*me.scale,
							{
								xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								
								thrust = 0,
								thrustspread = 0,
								
								momz = P_RandomRange(0,5)*me.scale*TakisKart_DriftLevel(data.stats,car.driftspark),
								momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
								
								scale = me.scale,
								scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								
								fuse = 23+P_RandomRange(-2,3),
							}
						)
						dust.colorized = true
						dust.color = spawn.color
						dust.tracer = me
						
					end
					
				end
				*/
				
				do
					local color = TakisKart_DriftColor(TakisKart_DriftLevel(data.stats,car.driftspark))
					local offx = P_ReturnThrustX(nil,momang + ANGLE_90*sign,-me.radius) 
					local offy = P_ReturnThrustY(nil,momang + ANGLE_90*sign,-me.radius) 
					local newangle = momang + ((ANGLE_45/5)*car.drift)
					local spawndust = false
					
					if (turndir ~= 0
					or GetCarSpeed(car) <= 15*FU)
					and (leveltime % 6 == 0)
						S_StartSound(car,sfx_kartsc)
						spawndust = true
					end
					
					if car.grounded
					and (me.lastgrounded == false)
						S_StartSound(car,sfx_kartsc)
						spawndust = true
					end
					
					if spawndust
						spawntiredust(p,me,car)
					end
					
					for i = -1,1,2
					
						local spawn = car.driftfxL
						if i == 1 then spawn = car.driftfxR end
						
						if not (spawn and spawn.valid) then continue end
						
						if i == sign
							spawn.dispoffset = me.dispoffset + 2
						else
							spawn.dispoffset = me.dispoffset - 2
						end
						
						local newx = me.x + P_ReturnThrustX(nil,momang + ANGLE_135*i, 42*me.scale) + offx
						local newy = me.y + P_ReturnThrustY(nil,momang + ANGLE_135*i, 42*me.scale) + offy
						
						spawn.color = color
						spawn.scale = me.scale
						spawn.tracer = car
						
						/*
						for j = 1,2
							local g = P_SpawnGhostMobj(spawn)
							P_SetOrigin(g,
								newx + P_ReturnThrustX(nil,momang + ANGLE_135*i, 32*me.scale) + (offx)*j,
								newy + P_ReturnThrustY(nil,momang + ANGLE_135*i, 32*me.scale) + (offy)*j,
								g.z
							)
							g.momx,g.momy = car.momx,car.momy
							g.destscale = 0
							g.tics = 3
						end
						*/
						
						if car.driftbrake
							local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
							TakisKart_SpawnSpark(spawn,angle,SKINCOLOR_ORANGE,true)
						end
						
						P_MoveOrigin(spawn,
							newx,
							newy,
							GetActorZ(me,spawn,1)
						)
						if me.standingslope
							spawn.z = P_GetZAt(me.standingslope,spawn.x,spawn.y)
						end
						
						spawn.angle = newangle
						
						local s1 = FU
						if turndir ~= 0
							if turndir == driftdir
								if sign == i
									s1 = DS_maxscale
								else
									s1 = DS_minscale
								end
							else
								if sign == -i
									s1 = DS_maxscale
								else
									s1 = DS_minscale
								end
								
							end
						end
						local stagecharge = TakisKart_DriftSparkValue(data.stats)
						
						--s1 = FixedMul($, FU/2 + FixedDiv(car.driftspark*FU,stagecharge*4*FU))
						s1 = $1+car.driftfxS
						spawn.spritexscale,spawn.spriteyscale = s1,s1
					
						local chance = 0
						if car.driftspark > stagecharge
							chance = FixedDiv(car.driftspark - stagecharge,stagecharge*3)
							if s1 == DS_minscale
								chance = $/3
							end
							if car.driftspark ~= stagecharge*4
								chance = $/3
							end
						end
						
						if P_RandomChance(chance)
							local spark = P_SpawnMobjFromMobj(me,
								newx - me.x,newy - me.y,
								0,
								MT_SOAP_SUPERTAUNT_FLYINGBOLT
							)
							spark.tracer = me
							spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
							spark.blendmode = AST_ADD
							spark.color = color
							spark.angle = R_PointToAngle2(
								spark.x,spark.y,
								me.x,me.y
							)
							P_SetObjectMomZ(spark,P_RandomRange(7,12)*FU)
							P_Thrust(spark,spark.angle,P_RandomRange(-15,-20)*spark.scale)
							spark.momx,spark.momy = $+me.momx,$+me.momy
							spark.allowothers = true
							spark.destscale = 0
							spark.scalespeed = P_RandomRange(FU/12,FU/2)
						end
						
					end
				end
				
				if car.ctrcar
					for i = 1,1
						car.driftspark = 0
						car.maxdrifttime = TR*12/10
						local maxdrifttime = car.maxdrifttime
						
						local boost = FixedDiv(car.drifttime*FU,maxdrifttime*FU)
						--boost = ease.outcubic(FU/2,$,FU)
						boost = $+FU
						
						if car.drifttime > maxdrifttime*2
							car.driftedout = true
							car.drift = 0
							TakisKart_DoSpinout(p,nil,SPINOUT_SPIN)
							return
						elseif car.drifttime > maxdrifttime
							if car.drifttime == maxdrifttime+1
								S_StartSound(car,sfx_cdfm00)
							end
							boost = 0
							break
						end
						
						print(L_FixedDecimal(boost))
						
						if car.maxspeed > car.basemaxspeed
						--and not car.driftboost
							car.maxspeed = car.basemaxspeed
						end
						
						if p.cmd.buttons & BT_JUMP
						and not (p.lastbuttons & BT_JUMP)
							if car.drifttime < car.maxdrifttime*2/5
								car.drifttime = 0
								S_StartSound(car,sfx_cdfm00)
								break
							end
							
							boost = $*12/10
							local driftboost = 0
							local drifttime = 0
							driftboost = FixedMul(3*car.scale,boost)
							drifttime = TR/2 --FixedMul(TR/2,boost)
							
							print("BOOST "..L_FixedDecimal(driftboost))
						
							P_Thrust(car,
								car.angle,
								driftboost
							)
							
							S_StartSound(car,sfx_cltch2)
							if car.driftboost < drifttime+1
								car.driftboost = drifttime+1
							end 
							car.maxspeed = car.basemaxspeed*3/2
							car.basemaxspeed = $*3/2
							car.accel = max($,car.basemaxspeed*3/2)
							car.drifttime = 0
						end
					end	
				end
				
				car.driftfxS = $*4/5
				
			end
			
		end
		
		--drift sliding
		if P_IsObjectOnGround(car)
			car.momt = $+(car.drift*2*FU)
		end
	else
		--keep our drift if we let go midair
		
		--if we let go grounded, then mini turbo
		--if grounded
		if car.driftspark >= TakisKart_DriftSparkValue(data.stats)
		and not car.driftbrake
			
			local turbothrust = 0
			local turbotime = 0
			local oldturbo = car.driftboost
			
			car.driftboostcolor = 1
			if car.driftspark >= TakisKart_DriftSparkValue(data.stats)*4
				turbothrust = 25*car.scale
				turbotime = 125
				S_StartSound(car,sfx_kc5b)
				S_StartSound(car,sfx_s3kc4l)
				car.driftboostcolor = 5
				
			elseif car.driftspark >= TakisKart_DriftSparkValue(data.stats)*3
				turbothrust = 20*car.scale
				turbotime = 85
				S_StartSound(car,sfx_kc5b)
				car.driftboostcolor = 4
				
			elseif car.driftspark >= TakisKart_DriftSparkValue(data.stats)*2
				turbothrust = 15*car.scale
				turbotime = 50
				S_StartSound(car,sfx_kc5b)
				car.driftboostcolor = 3
				
			elseif car.driftspark >= TakisKart_DriftSparkValue(data.stats)
				turbothrust = 10*car.scale
				turbotime = 20
				car.driftboostcolor = 2
			end
			
			if (p.powers[pw_shield] & SH_PROTECTELECTRIC)
			and car.driftspark >= TakisKart_DriftSparkValue(data.stats)*2
				P_RemoveShield(p)
				P_Thrust(car,
					car.angle,
					turbothrust*3/2
				)
			end
			
			car.driftdiff = car.angle
			car.angle = $-(driftval(p,car,car.momt/FU,data)+((ANGLE_45/9)*car.drift))*14/10
			car.driftdiff = FixedAngle(AngleFixed(car.angle) - AngleFixed($))
			if AngleFixed(car.driftdiff) > 180*FU
				car.driftdiff = InvAngle($)
			end
			
			P_Thrust(car,
				car.angle,
				turbothrust
			)
			if not grounded
				if not car.wallstick
					P_SetObjectMomZ(car,-GetCarSpeed(car)/2-20*FU,true)
				else
					car.momz = 0
				end
			end
			
			S_StartSound(car,sfx_s23c)
			car.driftboost = turbotime
			if car.driftboost > oldturbo
				car.driftboost = (38 + car.stats[2] + car.stats[1]) * $ /40
			end
			
			car.maxspeed = car.basemaxspeed*3/2
			car.accel = max($,car.maxspeed)
		elseif car.driftspark > 0
			
			--check if we wanted to sliptide first
			if CanISliptide(car)
			and (p.cmd.sidemove ~= 0)
			and grounded
				car.sliptide = -(car.sidemove > 0 and 1 or -1)
			elseif car.driftspark < TakisKart_DriftSparkValue(data.stats)
			and (false == true)
				car.accel = $*3/5
			end
			
		end
		
		if car.sliptide == 0
		and car.drift ~= 0
			car.driftrelease = (car.drift > 0) and 5 or -5
		end
		
		car.driftedout = false
		car.drifttime = 0
		car.drift = 0
		car.driftspark = 0
		car.driftbrake = 0
	end
	
	if (car.drift == 0
	or not car.grounded)
		for i = 0,1
			local spawn = car.driftfxL
			if i == 1 then spawn = car.driftfxR end
			
			if (spawn and spawn.valid)
				P_RemoveMobj(spawn)
			end
		end
	end
	
	if car.drift ~= 0
	and not S_SoundPlaying(car,sfx_kartdr)
	and grounded
		S_StartSoundAtVolume(car,sfx_kartdr,driftvolume)
	elseif (car.drift == 0 or not grounded)
		S_StopSoundByID(car,sfx_kartdr)
	end

end

--umm dat rollout rock mod for kart
local function InSectorSpecial(mo, grounded, section, special)
	if not (mo and mo.valid and mo.health) then return end
	
	local fofsector = P_ThingOnSpecial3DFloor(mo)
	-- You can be inside a FoF without being grounded
	if fofsector then
		--print("fofsector "..(fofsector and "yes" or "no"))
		if GetSecSpecial(fofsector.special,section) == special then
			--print("has special "..section.." "..special)
			return fofsector
		end
	end
	if GetSecSpecial(mo.subsector.sector.special, section) == special then
		if not grounded then
			return mo.subsector.sector
		elseif grounded and P_IsObjectOnGround(mo) then
			local flipped = P_MobjFlip(mo) == -1
			local slope = flipped and mo.subsector.sector.c_slope or mo.subsector.sector.f_slope -- no FoF
			local savedz = mo.z
			mo.z = mo.z -- update flooz/ceilingz, since they won't match properly for this tic yet
			local savedplanez = flipped and mo.ceilingz or mo.floorz -- current position floorz/ceilingz
			mo.flags = $|MF_NOCLIPHEIGHT -- we need to noclip it to make sure a bordering sector/fof doesnt mess with the floorz/ceilingz checking
			mo.z = slope and P_GetZAt(slope, mo.x, mo.y) or flipped and mo.subsector.sector.ceilingheight or mo.subsector.sector.floorheight -- sets floorz and ceilingz using hardcode functions we can't access from here
			local notonfof = savedplanez == (flipped and mo.ceilingz or mo.floorz) -- if our actual z is the same as the calculated floorz/ceilingz for this sector's slope, we aren't on a FoF
			mo.flags = $ & ~MF_NOCLIPHEIGHT
			mo.z = savedz
			return notonfof and mo.subsector.sector or nil
		end
	end
	return nil
/*
	if leveltime
		return P_MobjTouchingSectorSpecial(mo,section,special)
	end
	
	if sector then
		print("sector "..(sector and "yes" or "no"))
		print("has special "..section.." "..special)
		if P_IsObjectOnGround(mo) then
			print("grounded pass")
			return sector
		end
	end
	
	return nil
*/
end

local function offroadcollide(p,car)
	local me = p.mo
	local takis = p.takistable
	
	if not (me and me.valid)
		return 0
	end
	
	local kartstuff = false
	if (extrastuff)
		kartstuff = true
	end
	
	local val = 0
	
	if not kartstuff
		local secfric = car.standingsec.friction
		
		if secfric < 29*FU/32
			val = 1
		elseif (P_InQuicksand(car) or P_InQuicksand(me))
			val = 2
		end
		
		
	elseif kartstuff
		--check weak offroad
		if InSectorSpecial(me,true,1,2)
			val = 3
		--reg offroad
		elseif InSectorSpecial(me,true,1,3)
			val = 4
		--strong offroad
		elseif InSectorSpecial(me,true,1,4)
			val = 5
		end
		val = $-1
	end
	
	if car.spinouttype == SPINOUT_SPIN
		val = max($,2)
	end
	return val
end

local function updateoffroad(p,car)
	local me = p.mo
	local takis = p.takistable
	
	local offroad = 0
	local strength = offroadcollide(p,car)
	
	if car.lineoffroad
		strength = car.lineoffroad
		car.lineoffroad = nil
	end
	
	if car.nooffroad
	and not car.inpain
		strength = 0
	end
	
	if strength
		if car.offroad == 0
			car.offroad = TR/2
		end
		if car.offroad > 0
			offroad = (strength << FRACBITS) / (TR/2)
			car.offroad = $+offroad
		end
		if car.offroad > (strength<<FRACBITS)
			car.offroad = (strength<<FRACBITS)
		end
	else
		car.offroad = 0
	end
	
	car.offroad = max($,0)
	
end

local function DoPogoSpring(p,me,car,sector)
	if (me.eflags & MFE_SPRUNG)
		return
	end
	
	local vscale = MAPSCALE + (me.scale - MAPSCALE)
	me.eflags = $|MFE_SPRUNG
	
	local minspeed = 48
	local maxspeed = 72
	
	local thrust = 3*GetCarSpeed(car)/2
	if thrust < minspeed<<FRACBITS
		thrust = minspeed<<FRACBITS
	end
	if thrust > maxspeed<<FRACBITS
		thrust = maxspeed<<FRACBITS
	end
	
	if not car.pogospring
		S_StartSound(car,sfx_kc2f)
	end
	
	car.momz = P_MobjFlip(me) * FixedMul(sin(ANGLE_22h),FixedMul(thrust,vscale))
	car.pogospring = 2
	
	if me.eflags & MFE_UNDERWATER
		car.momz = (177 * $)/200
	end
	me.pitch,me.roll,car.pitch,car.roll = 0,0,0,0
	P_MoveOrigin(me,car.x,car.y,car.z)
	car.pogosector = car.subsector.sector
	car.pogospeeds = {minspeed*FU,maxspeed*FU}
end

local function getkartstats(car,type,stat)
	--K_GetKartSpeed
	if type == 1
		local xspeed = 3*FU/64
		local g_cc = TakisKart_GetGearMul() + xspeed
		local k_speed = 150
		local finalspeed
		
		if car.inringslinger
			stat = 1
		end
		
		k_speed = $+stat*3
		
		finalspeed = FixedMul(k_speed<<14, g_cc)
		finalspeed = FixedMul($,
			--TODO: separate variable for accelboost
			FixedDiv(car.maxspeed,
				car.data.basenormalspeed*TakisKart_GetGearMul()
			)
		)
		return finalspeed
	--K_GetKartAccel
	else
		local k_accel = 32
		if car.inringslinger then stat = 1 end
		
		k_accel = $ + 4*(9 - stat)
		k_accel = FixedMul($, 
			((FU/2)+FixedDiv(
				car.maxspeed,
				car.data.basenormalspeed*TakisKart_GetGearMul()
				)
			)/2
		)
		return k_accel
	end
end

local function kartnewspeed(p,me,car,data)
	local accelmax = 4000
	local p_speed = getkartstats(car,1,car.stats[1])
	local p_accel = getkartstats(car,2,car.stats[2])*5/4
	
	local newspeed,oldspeed
	
	oldspeed = min(GetCarSpeed(car),p_speed) --FixedMul(GetCarSpeed(car),car.scale)
	newspeed = FixedDiv(
		FixedDiv(
			FixedMul(oldspeed,accelmax - p_accel) + 
			FixedMul(p_speed,p_accel),
		accelmax),car.friction
	)
	
	return (newspeed - oldspeed)
end

local function kart3dmovement(p,me,car,data,moving,reversing)
	local finalspeed = kartnewspeed(p,me,car,data)
	--finalspeed = $ + FixedDiv(car.maxspeed,car.basemaxspeed) - FU
	
	if car.inpain
	or car.stasis
		return 0
	end
	
	local movemul = FU
	local forwardmove = reversing and reversing or moving
	if abs(forwardmove) > CMD_DEADZONE
		forwardmove = $ + (forwardmove >= 0 and abs(p.cmd.sidemove/2) or -abs(p.cmd.sidemove/2))
	end
	
	forwardmove = clamp(-50,$,50)
	if car.forceaccel
		forwardmove = 50
		car.forceaccel = $-1
	end
	movemul = abs(forwardmove*FU)/50
	
	if forwardmove >= 0
		finalspeed = FixedMul($,movemul)
	else
		finalspeed = FixedMul(-$/2,movemul)
	end
	if p.takistable.inWater
		movepush = $*4/5
	end
	
	finalspeed = FixedMul($,car.scale)
	return finalspeed
end

--TODO: braking
local function dokartacceleration(p,me,car,data,moving,reversing)
	
	local takis = p.takistable
	
	local movepush = 0
	local moveangle = car.angle
		
	/*
	if extrastuff or false
		if car.grounded	
			movepush = kart3dmovement(p,me,car,data,moving,reversing)
		end
	--ALWAYS allow midair acceleration
	else
	*/
	do
		movepush = kart3dmovement(p,me,car,data,moving,reversing)
		/*
		if takis.inWater
			movepush = $*4/5
		end
		*/
		if not car.grounded
			movepush = $/8
			if GetCarSpeed(car) > car.maxspeed
				movepush = 0
			end
		end
	end
	
	car.braking = false
	if reversing
		if TakisAngleSpeed(car)/car.scale > 5
			if car.grounded
				brakegfx(p,car)
				if not S_SoundPlaying(car,sfx_takskd)
					S_StartSound(car,sfx_takskd)
				end
			end
			if car.drift == 0
				car.accel = $*185/200
				car.momx,car.momy = $1*185/200,$2*185/200
			end
			movepush = 0
			car.braking = true
		else
			S_StopSoundByID(car,sfx_takskd)
		end
	else
		S_StopSoundByID(car,sfx_takskd)
	end
	
	if car.grounded
		if car.drift ~= 0
			local outsideangle = (AngleFixed(ANGLE_45)/9)*car.drift
			
			--you still slip even with inside drift!
			if me.movefactor ~= FU
				local movefactor = FU - car.fakemovefactor
				local weightmul = FixedDiv(car.stats[2]*FU,9*FU)
				
				movefactor = FixedMul($,FU - weightmul)
				
				outsideangle = FixedMul($,FU + (movefactor*14/10))
			elseif car.insidedrift
				outsideangle = 0
			end
			
			moveangle = $ - FixedAngle(outsideangle)
		end
		
		if car.offroad > 0
			if GetCarSpeed(car)/FU ~= 0
				if not (leveltime % 6)
					S_StartSound(car,sfx_cdfm70)
				end
				if not (leveltime % 3)
					spawntiredust(p,me,car)
				end
			end
			movepush = FixedDiv($,(car.offroad*3/4)+FU)
		end
		
		/*
		if takis.inWater
			local steer = p.cmd.sidemove
			do 
				if car.drift == 0
					steer = $*9/5
				end
				
				local minspeed = 11*car.scale
				local baseline = INT32_MAX
				baseline = getkartstats(car,1,car.stats[1])*2/3
				
				local strafe = max(0,FixedDiv(max(FixedMul(GetCarSpeed(car),car.scale),minspeed) - minspeed, baseline - minspeed))
				steer = FixedMul($,8*strafe)
			end
			local adjust = 0
			
			if steer
				local maxadjust = ANG10/4
				
				adjust = steer/4
				
				adjust = clamp(-maxadjust,$,maxadjust)
				moveangle = $ + FixedAngle(adjust*FU/5)
				
			end
			
		end
		*/
		
		if me.movefactor ~= FU
			movepush = FixedMul($,me.movefactor)
		end
		--movepush = FixedMul($,FixedMul(me.friction,me.movefactor))
		
	end
	car.accel = ease.outquad(FU/4,$,FixedDiv(abs(movepush),car.scale)*7/5)
	if car.accel/FU < 0
		car.accel = 0
	end
	
	if car.standingsec.friction > car.friction
		car.friction = car.standingsec.friction
	else
		if not extrastuff
			car.friction = ORIG_FRICTION + (FU/130)
		end
	end
	car.movefactor = me.movefactor
	if movepush
		P_Thrust(car,moveangle,movepush)
	end
	
	if not car.grounded
		local speedcap = 50*MAPSCALE
		local speed = FixedMul(GetCarSpeed(car),car.scale)
		
		if speed > speedcap
			local div = 32*FU
			
			local newspeed = speed - FixedDiv(speed - speedcap,div)
			car.momx = FixedMul(FixedDiv(car.momx,speed), newspeed)
			car.momy = FixedMul(FixedDiv(car.momy,speed), newspeed)
		end
	end
	
end

addHook("MobjCollide",function(car,mo)
	if (mo.flags & MF_MISSILE)
		return false
	end
end,MT_TAKIS_KART_HELPER)

addHook("MobjMoveCollide",function(car,mo)
	if (mo.type == MT_PLAYER)-- and mo == car.target)
	or (mo.flags & MF_SPRING)
	--rs lo,loloskdoisjro3iwhjriekujfhlkdxzucfhlais8durhb7asdv807
	or (mo.flags & MF_MISSILE)
		return false
	elseif (mo.type == MT_DUSTDEVIL)
	and L_ZCollide(car,mo)
		L_ZLaunch(car,20*FU)
	elseif (car.bumpinginside or mo.bumpinginside)
		return false
	elseif mo.iskart
		if car.momz*P_MobjFlip(car) < 0
		and car.z + car.momz*2 <= mo.z+mo.height
		and car.z + car.momz*2 >= mo.z+car.momz
			car.momz = -$*2
			local bam = SpawnBam(car)
			bam.scale = $/2
			bam.renderflags = $|RF_FLOORSPRITE
			
			S_StartSound(car,sfx_s3k49)
		end
	/*
	elseif (mo.type == MT_BIGGRABCHAIN)
	or (mo.type == MT_SMALLGRABCHAIN)
	and L_ZCollide(car,mo)
	and (leveltime == 0)
		L_ZLaunch(car,40*FU)
	*/
	end
end,MT_TAKIS_KART_HELPER)

local function getmobjweight(mo,against)
	local weight = mo.kartweight or 5*FU
	
	if mo.player and mo.player.valid
		local p = mo.player
		
		if (against.player and not (against.tracer.spinouttype) and mo.tracer.car.spinouttype)
			weight = 0
		else
			local normalspeed = TakisKart_KarterData[mo.skin].basenormalspeed*FU
			weight = (mo.tracer.stats[2])*FU
			
			if not p.inkart
				normalspeed = p.normalspeed
				weight = 5*FU
			end
			
			if (p.takistable.accspeed > normalspeed)
				weight = $+(p.takistable.accspeed - normalspeed)
			end
		end
		
	end
	return weight
end

rawset(_G,"K_KartBouncing",function(carmode,car,thing)
	if thing.flags & (MF_PUSHABLE)
	and not thing.allowbumps
		return
	end
	
	local p,me,takis
	local justbumped = car.justbumped
	if carmode
		me = car.target
		p = me.player
		takis = p.takistable
	else
		me = car
		if (me.player and me.player.valid)
			p = me.player
			takis = p.takistable
			justbumped = takis.justbumped
		else
			justbumped = car.justbumped
		end
	end
	
	local momdifx,momdify = 0,0
	local distx,disty = 0,0
	local dot,force = 0,0
	local mass1,mass2 = 0,0
	
	if carmode
		do
			if (p.powers[pw_flashing] and p.powers[pw_flashing] < flashingtics)
				if (p.powers[pw_flashing] < flashingtics-1)
					p.powers[pw_flashing] = flashingtics-1
				end
			end
			
			local p = thing.player
			if (p and p.valid)
				
				--dont bump with these people
				if (p.exiting)
				or (p.quittime)
				or (thing.invuln and car.invuln)
					return
				end
				
				if (p.powers[pw_flashing] and p.powers[pw_flashing] < flashingtics)
					if (p.powers[pw_flashing] < flashingtics-1)
						p.powers[pw_flashing] = flashingtics-1
					end
				end
			end
		end
	end
	
	if (justbumped)
		if carmode
			car.justbumped = 8
		else
			if takis
				takis.justbumped = 8
			else
				car.justbumped = 8
			end
		end
		--return
	end
	
	if (thing.justbumped)
		thing.justbumped = 8
	end
	
	mass1 = getmobjweight(me,thing)
	mass2 = getmobjweight(thing,me)
	
	momdifx = car.momx - thing.momx
	momdify = car.momy - thing.momy
	
	distx = (car.x + thing.momx*3) - (thing.x + car.momx*3)
	disty = (car.y + thing.momy*3) - (thing.y + car.momy*3)
	
	if (distx == 0 and disty == 0)
		return
	end
	
	do
		local dist = P_AproxDistance(distx,disty)
		local nx = FixedDiv(distx,dist)
		local ny = FixedDiv(disty,dist)
		
		dist = max($,1)
		distx = FixedMul(car.radius + thing.radius, nx)
		disty = FixedMul(car.radius + thing.radius, ny)
	end
	
	if R_PointToDist2(0,0,momdifx,momdify) < 25*FU
		local mfl = R_PointToDist2(0,0,momdifx,momdify)
		local nx = FixedDiv(momdifx,mfl)
		local ny = FixedDiv(momdify,mfl)
		momdifx = FixedMul(25*FU,nx)
		momdify = FixedMul(25*FU,ny)
	end
	
	dot = FixedMul(momdifx,distx) + FixedMul(momdify, disty)
	
	if dot >= 0 then return end
	
	force = FixedDiv(dot, FixedMul(distx,distx) + FixedMul(disty,disty))
	
	do
		local newz = car.momz
		if mass2 > 0
			car.momz = -$ - thing.momz
		end
		if mass1 > 0
			thing.momz = -$ + newz
		end
	end
	
	if (mass2 > 0)
		car.momx = $ - FixedMul(FixedMul(FixedDiv(2*mass2, mass1 + mass2), force), distx)
		car.momy = $ - FixedMul(FixedMul(FixedDiv(2*mass2, mass1 + mass2), force), disty)
		if carmode
			--car.accel = $/5
		end
	end
	
	if (mass1 > 0)
	and (thing.iskart or thing.allowbumps)
		thing.momx = $ - FixedMul(FixedMul(FixedDiv(2*mass1, mass1 + mass2), force), -distx)
		thing.momy = $ - FixedMul(FixedMul(FixedDiv(2*mass1, mass1 + mass2), force), -disty)
	end
	
	local nobump = false
	
	--TODO: fix for nonkarts
	if thing.iskart
		if car.invuln
		and not thing.invuln
			TakisKart_DoSpinout(thing.target.player,car,SPINOUT_BIGTUMBLE)
			nobump = true
		--idiot
		elseif thing.invuln
		and not car.invuln
		and car.iskart
			TakisKart_DoSpinout(car.target.player,thing,SPINOUT_BIGTUMBLE)
		end
	end
	
	--stumble
	if (car.scale > thing.scale + (MAPSCALE/8))
	and thing.iskart
		TakisKart_DoSpinout(thing.target.player,car,SPINOUT_STUMBLE)
	elseif (thing.scale > car.scale + (MAPSCALE/8))
	and car.iskart
		TakisKart_DoSpinout(car.target.player,thing,SPINOUT_STUMBLE)
	end
	
	if carmode
		car.justbumped = 8
	else
		if takis
			takis.justbumped = 8
		else
			car.justbumped = 8
		end
	end
	
	if thing.iskart
		thing.justbumped = 8
	end
	
	if nobump
		return true
	end
	

end)

rawset(_G,"P_BouncePlayerMove",function(p,me,car,carmode)
	local justbumped
	if not carmode
		car = me
		justbumped = ((p and p.valid) and p.takistable.justbumped or (car.justbumped or 0))
	else
		justbumped = car.justbumped
	end
	
	local leadx,leady
	local trailx,traily
	local mmomx,mmomy = 0,0
	local oldmomx,oldmomy = car.momx,car.momy
	local tmxmove,tmymove
	
	local cmomx,cmomy = 0,0
	if (p and p.valid)
		cmomx = p.cmomx
		cmomy = p.cmomy
	end
	
	mmomx,mmomy = car.momx - cmomx, car.momy - cmomy
	
	/*
	if (car.momx > 0)
		leadx = car.x + car.radius
		trailx = car.x - car.radius
	else
		leadx = car.x - car.radius
		trailx = car.x + car.radius
	end
	if (car.momy > 0)
		leady = car.y + car.radius
		traily = car.y - car.radius
	else
		leady = car.y - car.radius
		traily = car.y + car.radius
	end
	*/
	
	--???? unexposed bullshit
	
	if justbumped >= 7
		tmxmove = mmomx
		tmymove = mmomy
	else
		tmxmove = FixedMul(mmomx, (FU - (FU>>2) - (FU>>3)))
		tmymove = FixedMul(mmomy, (FU - (FU>>2) - (FU>>3)))
	end
	
	if not carmode
		if (p and p.valid)
			p.takistable.justbumped = 8
		else
			car.justbumped = 8
		end
	else
		car.justbumped = 8
	end
	
	--this fucking SUCKS!!!!
	if FixedHypot(tmxmove,tmymove) < 15*car.scale
	and false
		--local angle = R_PointToAngle2(0,0,tmxmove,tmymove)
		
		--if abs(tmxmove) < 10*FU
		do
			local sign = (tmxmove > 1) and 1 or -1
			tmxmove = 15*car.scale*sign
		end
		--if abs(tmymove) < 10*FU
		do
			local sign = (tmymove > 1) and 1 or -1
			tmymove = 15*car.scale*sign
		end
	end
	
	tmxmove,tmymove = -$1, -$2
	car.momx,car.momy = tmxmove,tmymove
	if (p and p.valid)
		p.cmomx,p.cmomy = tmxmove,tmymove
	end
	
	if not P_TryMove(car, car.x + tmxmove, car.y + tmymove, true)
		P_TryMove(car, car.x - oldmomx, car.y - oldmomy, true)
	end
end)

rawset(_G,"GenericKartBump",function(car,thing,line)
	if ((thing) and (thing.valid)) or ((line) and (line.valid))
		local oldangle = car.angle
		if thing and thing.valid
			
			K_KartBouncing(false,car,thing)
			
		elseif line and line.valid
			local dstepup = false
			
			if line.frontside
			and line.frontside.valid
			and line.frontside.sector
			and line.frontside.sector.valid
				if line.frontside.sector.specialflags & SSF_DOUBLESTEPUP
					dstepup = true
				end
			end
			if line.backside
			and line.backside.valid
			and line.backside.sector
			and line.backside.sector.valid
				if line.backside.sector.specialflags & SSF_DOUBLESTEPUP
					dstepup = true
				end
			end
			
			if car.subsector.sector.specialflags & SSF_DOUBLESTEPUP
				dstepup = true
			end
			
			if (car.standingslope and car.standingslope.valid)
				do
					local goingup = false
					local goingup = false
					local posfunc = P_GetZAt --P_MobjFlip(me) == 1 and P_FloorzAtPos or P_CeilingzAtPos
					
					if posfunc(car.standingslope,car.x, car.y, car.z) > car.z
					or posfunc(car.standingslope, car.x + car.momx, car.y + car.momy, car.z + car.momz) > car.z
						goingup = true
					end
					
					if goingup
						car.momz = $*3/2
						return
					end
				end
				
			end
			
			if dstepup then return end
			
			P_BouncePlayerMove(nil,car,car,false)
			
		end
		
		local bam = SpawnBam(car)
		bam.scale = $/2
		
		S_StartSound(car,sfx_s3k49)
		
		return true
	end
end)

addHook("MobjMoveBlocked",GenericKartBump,MT_TAKIS_KART_LEFTOVER)
addHook("MobjMoveBlocked",GenericKartBump,MT_TAKIS_KART)

--bonk
--bumpcode
addHook("MobjMoveBlocked",function(car,thing,line)
	--if leveltime then return end
	
	if ((thing) and (thing.valid)) or ((line) and (line.valid))
		local p = car.target.player
		local me = car.target
		local takis = p.takistable
		
		if (car.teletime) then return end
		
		local sprung = takis.slopeairtime or car.sprung or (car.eflags & MFE_SPRUNG or me.eflags & MFE_SPRUNG)
		
		if (sprung) and car.momz*P_MobjFlip(car) > 0 then return end
		
		local oldangle = car.angle
		if thing and thing.valid
			
			if (thing.flags & (MF_PUSHABLE)
			and not thing.allowbumps)
				return
			end
			
			--if (leveltime < TR)
			local blockdist = car.radius + thing.radius
			if not ((abs(car.x - thing.x) > blockdist)
			or (abs(car.y - thing.y) > blockdist))
			or (car.bumpinginside or thing.bumpinginside)
				car.bumpinginside = 5
				thing.bumpinginside = 5
				return true
			end
			
			K_KartBouncing(true,car,thing)
						
			if (thing.flags & MF_MONITOR)
			and thing.health
				P_KillMobj(thing,me,me)
			end
			
			/*
			local weightmul = min(FixedDiv(car.stats[2]*FU,9*FU),FU)
			local myspeed = FixedHypot(FixedHypot(car.momz,car.momy),car.momz)
			local theirspeed = FixedHypot(FixedHypot(thing.momz,thing.momy),thing.momz)
			myspeed = FixedMul($,weightmul)
			if thing.iskart
				local tweightmul = min(FixedDiv(thing.stats[2]*FU,9*FU),FU)
				theirspeed = FixedMul($,weightmul)
			end
			
			car.angle = FixedAngle(AngleFixed(R_PointToAngle2(car.x,car.y,thing.x,thing.y))+(180*FU))
			P_InstaThrust(car,car.angle,20*car.scale+(theirspeed/2))
			car.angle = oldangle
			car.accel = $/5
			
			if thing.iskart
				oldangle = thing.angle
				thing.angle = FixedAngle(AngleFixed(R_PointToAngle2(thing.x,thing.y,car.x,car.y))+(180*FU))
				P_InstaThrust(thing,thing.angle,20*thing.scale+(myspeed/2))
				thing.angle = oldangle
				
				if car.invuln
				and not thing.invuln
					TakisKart_DoSpinout(thing.target.player,car,SPINOUT_BIGTUMBLE)
				--idiot
				elseif thing.invuln
				and not car.invuln
					TakisKart_DoSpinout(car.target.player,thing,SPINOUT_BIGTUMBLE)
				end
			end
			*/
			
		elseif line and line.valid
			local dstepup = false
			
			if line.frontside
			and line.frontside.valid
			and line.frontside.sector
			and line.frontside.sector.valid
				if line.frontside.sector.specialflags & SSF_DOUBLESTEPUP
					dstepup = true
				end
			end
			if line.backside
			and line.backside.valid
			and line.backside.sector
			and line.backside.sector.valid
				if line.backside.sector.specialflags & SSF_DOUBLESTEPUP
					dstepup = true
				end
			end
			
			--dont bump if this is like a really steep slope we're running
			--into
			/*
			local newsec = R_PointInSubsectorOrNil(car.x + car.momy,car.y + car.momy)
			if (newsec and newsec.valid)
			and (newsec ~= car.subsector)
			and newsec.sector.f_slope
			and false
				print("ASDASDSA")
				return
			end
			*/
			
			dprint("BUMPCODE")
			
			if car.subsector.sector.specialflags & SSF_DOUBLESTEPUP
				dstepup = true
			end
			
			if (car.standingslope and car.standingslope.valid)
				do
					dprint("\x83TAKIS:\x80 Wall transfer")
					local goingup = false
					local goingup = false
					local posfunc = P_GetZAt --P_MobjFlip(me) == 1 and P_FloorzAtPos or P_CeilingzAtPos
					
					if posfunc(car.standingslope,car.x, car.y, car.z) > car.z
					or posfunc(car.standingslope, car.x + car.momx, car.y + car.momy, car.z + car.momz) > car.z
						goingup = true
					end
					--car.z = posfunc(car.standingslope, car.x + car.momx, car.y + car.momy, car.z + car.momz)
					
					local perp = goingup
					
					/*
					local predictedz = 0
					local xmove,ymove = car.momx,car.momy
					
					do
						local slopemom = {x = 0,y = 0,z = 0}
						slopemom.x = car.momx
						slopemom.y = car.momy
						
						--P_QuantizeMomentumToSlope(slopemom,car.standingslope)
						do
							local slope = car.standingslope
							local axis = {x = 0,y = 0,z = 0}
							axis.x = -slope.d.y
							axis.y = slope.d.x
							
							--FV3_Rotate(slopemom,axis,slope.zangle)
							do
								local angle = slope.zangle
								local ux = FixedMul(axis.x, slopemom.x)
								local uy = FixedMul(axis.x, slopemom.y)
								local uz = FixedMul(axis.x, slopemom.z)
								
								local vx = FixedMul(axis.y, slopemom.x)
								local vy = FixedMul(axis.y, slopemom.y)
								local vz = FixedMul(axis.y, slopemom.z)
								
								local wx = FixedMul(axis.z, slopemom.x)
								local wy = FixedMul(axis.z, slopemom.y)
								local wz = FixedMul(axis.z, slopemom.z)
								
								local sa,ca = sin(angle),cos(angle)
								
								local ua = ux+vy+wz
								local ax = FixedMul(axis.x, ua)
								local ay = FixedMul(axis.y, ua)
								local az = FixedMul(axis.z, ua)
								
								local xs = FixedMul(axis.x, axis.x)
								local ys = FixedMul(axis.y, axis.y)
								local zs = FixedMul(axis.z, axis.z)
								
								local bx = FixedMul(slopemom.x, ys+zs)
								local by = FixedMul(slopemom.y, xs+zs)
								local bz = FixedMul(slopemom.z, xs+ys)
								
								local cx = FixedMul(axis.x, vy+wz)
								local cy = FixedMul(axis.y, ux+wz)
								local cz = FixedMul(axis.z, ux+vy)
								
								local dx = FixedMul(bx - cx, ca)
								local dy = FixedMul(by - cy, ca)
								local dz = FixedMul(bz - cz, ca)
								
								local ex = FixedMul(vz - wy, sa)
								local ey = FixedMul(wx - uz, sa)
								local ez = FixedMul(uy - vx, sa)
								
								slopemom.x = ax+dx+ex
								slopemom.y = ay+dy+ey
								slopemom.z = az+dz+ez
							end
							
						end
						
						xmove,ymove = slopemom.x,slopemom.y
						predictedz = car.z + slopemom.z
						
						
					end
					
					--okay... now lets check if we're transferring
					local perp = true
					
					local lineang = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y)
					local slopedir = car.standingslope.xydirection
					local jank = 15*FU
					local perp = false
					
					car.bumpangle = lineang
					slopedir,lineang = AngleFixed($1),AngleFixed($2)
					
					if not (abs(line.dx) > 0)
						lineang = $-180*FU
					end
					if lineang == 0
						slopedir = $-180*FU
					end
					
					for i = 1,2
						if i == 2
							slopedir = $+180*FU
						end
						
						if (slopedir <= lineang + (90*FU + jank)
						and slopedir >= lineang - (90*FU + jank))
						or (slopedir <= lineang - (90*FU + jank)
						and slopedir >= lineang + (90*FU + jank))
						or (slopedir == lineang)
							perp = true
						end
					end
					*/
					
					
					if perp
						car.momz = $*3/2
						
						if allowwallstick
							print("STICK GOES HERE")
							
							car.stick_line = line
							car.stick_side = P_PointOnLineSide(car.x,car.y,line) and line.backside or line.frontside
							
							car.stick_time = 5
							
						end
						
						return
					end
				end
				
				car.bumpangle = lineang
			end
			
			if dstepup then return end
			--if GetCarSpeed(car) < 7*FU then return end
			--if car.stairjank >= 15 then return end
			
			P_BouncePlayerMove(p,me,car,true)
			
			/*
			me.DJSHKSJLDHFDSKLH = true
			P_KillMobj(me,nil,nil,DMG_SPIKE)
			takis.altdisfx = 3
			me.momx,me.momy = car.momx*2,car.momy*2
			
			local weightmul = FU --min(FixedDiv(10-car.stats[2]*FU,9*FU),FU)
			
			--THANKS MARILYN FOR LETTIN ME STEAL THIS!!
			if abs(line.dx) > 0
                local myang = R_PointToAngle2(0, 0, car.momx, car.momy)
                local vertang = R_PointToAngle2(0, 0, 0, car.momz)
                local lineang = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y)
                P_InstaThrust(car,
					myang + 2*(lineang - myang),
					FixedMul(FixedHypot(car.momx, car.momy),weightmul) - car.friction
				)
				if TAKIS_DEBUGFLAG & DEBUG_KART
					print("\x83TAKIS:\x80 ("..
						car.target.player.name..") Bumpcode: abs(line.dx) > 0 = true"
					)
				end
            else
				if TAKIS_DEBUGFLAG & DEBUG_KART
					print("\x83TAKIS:\x80 ("..
						car.target.player.name..") Bumpcode: abs(line.dx) > 0 = false (lazy momentum invert)"
					)
				end
                car.momx = $*-1
                car.momy = $*-1
            end
			*/
			--car.accel = $/5
		end
		
		TakisKart_ChangeLicense(p,"bumps",1)
		local bam = SpawnBam(car)
		bam.scale = $/2
		
		/*
		if (car.target and car.target.player)
		and not car.target.player.powers[pw_flashing]
		and car.takiscar
			car.fuel = $-(5*FU)
			car.damagetic = TR
		end
		*/
		S_StartSound(car,sfx_s3k49)
		P_MoveOrigin(me,car.x,car.y,car.z)
		
		return true
	end
end,MT_TAKIS_KART_HELPER)

local function carinit(car,me,data)
	--toggles takis specific stuff (like fuel)
	car.iskart = true
	car.takiscar = TakisKart_KarterData[me.skin].takiskart or false
	if car.fuel == nil
		car.fuel = 100*FU
	end
	car.init = true
	car.inpain = false
	car.painangle = 0
	car.painspin = 0
	car.facingangle = 0
	car.damagetic = 0
	car.oldangle = 0
	car.maxspeed = data.basenormalspeed*FU
	car.basemaxspeed = car.maxspeed
	car.offroad = 0
	car.drift = 0
	car.drifttime = 0
	car.driftspark = 0
	car.driftbrake = 0
	car.driftboost = 0
	car.driftangle = 0
	car.driftedout = false
	car.driftdiff = 0
	car.momt = 0
	car.turning = false
	car.accel = 0
	car.enginesound = 0
	car.sprung = false
	car.jumped = false
	car.boostpanel = 0
	car.moving = 0
	car.nooffroad = false
	car.ringboost = 0
	car.reversing = 0
	car.stats = data.stats
	car.data = data
	car.rmomt = 0
	car.jumphalf = false
	car.hornwait = 0
	car.stairjank = 0
	car.gooptime = 0
	car.driftfxS = 0
	car.tiregrease = 0
	car.spinouttype = 0
	car.paintics = 0
	car.inringslinger = false
	car.spheredigestion = 0
	car.boostcharge = 0
	car.turningtic = 0
	car.sidemove = 0
	car.invuln = 0
	car.acceltime = 0
	car.exiting = 0
	car.drawangle = 0
	car.waterrunning = false
	car.grounded = false
	car.ctrcar = ctrdrift
	car.pogospring = 0
	car.driftboostcolor = 0
	car.exiting = 0
	car.waterignore = 0
	car.spindashcharge = 0
	car.spindash = false
	car.bikemode = data.bikemode == true
	car.insidedrift = data.insidedrift == true
	car.justbumped = 0
	car.lastflashing = 0
	car.speedpad = 0
	car.fakemovefactor = FU
	car.sliptide = 0
	car.sliptidetilt = 0
	car.forceaccel = 0
	car.driftrelease = 0
	car.animstate = 0
	
	--carinit end
end

addHook("MobjThinker",function(car)
	if not (car and car.valid) then return end
	if not (car.target and car.target.valid)
		P_RemoveMobj(car)
		return
	end
	
	local p = car.target.player
	if not (p and p.valid) then return end
	local me = p.mo
	if not (me and me.valid) then return end
	local data = TakisKart_KarterData[me.skin]
	local takis = p.takistable
	
	if not (me.health)
	or not P_IsValidSprite2(me,SPR2_KART)
	or not TakisKart_Karters[me.skin]
	or (me.boat and me.boat.valid)
	--or (me.skin ~= TAKIS_SKIN and car.takiscar)
		CarGenericEject(p)
		P_MovePlayer(p)
		if me.health
			me.state = S_PLAY_STND
			if takis.kart.paidforkart
				local newkart = P_SpawnMobjFromMobj(me,
					P_ReturnThrustX(nil,me.angle+ANGLE_90,64*me.scale),
					P_ReturnThrustY(nil,me.angle+ANGLE_90,64*me.scale),
					0,
					MT_TAKIS_KART
				)
				/*
				P_TryMove(car,
					me.x + P_ReturnThrustX(nil,me.angle+ANGLE_90,64*me.scale),
					me.y + P_ReturnThrustY(nil,me.angle+ANGLE_90,64*me.scale),
					true
				)
				*/
				newkart.scale = me.scale
				newkart.color = me.color
				newkart.fuel = car.fuel
				newkart.angle = car.angle
				newkart.owner = p
				takis.kart.mobj = newkart
				newkart.paidfor = true
				me.state = S_PLAY_STND
				P_MovePlayer(p)
				P_RemoveMobj(car)
				return
			end
		else
			if not takis.deathfunny
				local ki = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_BROLYKI)
				ki.tracer = me
				ki.color = me.color
				ki.tics = $/2
				ki.threshold = ki.tics
				ki.scalemul = FU/2
				local leftover = P_SpawnMobjFromMobj(me,0,0,me.height*2,MT_TAKIS_KART_LEFTOVER)
				P_SetObjectMomZ(leftover,60*FU)
				leftover.angle = me.angle
				leftover.color = p.skincolor
				leftover.destscale = me.scale*3/2
				P_SetScale(leftover,leftover.destscale)
			else
				P_RemoveMobj(car)
				return
			end
		end
		TakisFancyExplode(me,
			car.x, car.y, car.z,
			P_RandomRange(60,64)*car.scale,
			32,
			nil,
			15,20
		)
		P_KillMobj(car)
		/*
		if p.powers[pw_carry] == CR_TAKISKART
			p.powers[pw_carry] = 0
		end
		p.pflags = $ &~(PF_JUMPED|PF_DRILLING)
		p.charflags = skins[p.skin].flags
		me.tracer = nil
		*/
		return
	end
	
	if (me.flags & MF_NOTHINK)
		return true
	end
	
	car.flags = $|MF_SOLID
	if (me.flags & MF_NOCLIP)
		car.flags = $|MF_NOCLIP
	else
		car.flags = $ &~MF_NOCLIP
	end
	if (me.flags & MF_NOCLIPHEIGHT)
		car.flags = $|MF_NOCLIPHEIGHT
	else
		car.flags = $ &~MF_NOCLIPHEIGHT
	end
	
	if not car.init
		carinit(car,me,data)
	end
	
	if car.bumpinginside
		dprint(p.name..": bumpinginside: "..car.bumpinginside)
		car.bumpinginside = $-1
	end
	
	car.stasis = false
	car.gear = gamegear
	
	if p.powers[pw_carry] ~= CR_ZOOMTUBE
		car.mylastz = me.floorz
	end
	
	if p.powers[pw_carry] == CR_DUSTDEVIL
		L_ZLaunch(car,40*FU)
		car.sprung = true
	elseif p.powers[pw_carry] == CR_ZOOMTUBE
	or p.powers[pw_carry] == CR_MACESPIN
	or p.powers[pw_carry] == CR_ROPEHANG
	or p.powers[pw_carry] == CR_ROLLOUT
	or ((CR_GRINDRAIL)
	and p.powers[pw_carry] == CR_GRINDRAIL)
		P_MoveOrigin(car,me.x,me.y,me.z)
		car.momx,car.momy,car.momz = me.momx,me.momy,me.momz
		car.angle = me.angle
		
		me.sprite2 = SPR2_KART
		car.sidemove = p.cmd.sidemove
		animhandle(p,car,data,takis.accspeed)
		soundhandle(p,car,data)
		
		if p.powers[pw_carry] == CR_MACESPIN
			car.sprung = true
		end
		if p.powers[pw_carry] == CR_ROLLOUT
			P_KillMobj(me,car,car,DMG_INSTAKILL)
			return
			
			/*
			car.flags = $ &~MF_SOLID
			
			if takis.jump == 1
			or (p.cmd.buttons & BT_JUMP)
				P_SetObjectMomZ(car,30*FU)
				
				P_MoveOrigin(me,
					car.x,car.y,
					car.z + car.momz
				)
				print("ASDSAD")
			end
			*/
		end
		if p.powers[pw_carry] == CR_ZOOMTUBE
			local angle = TakisMomAngle(me,p.drawangle) - ANGLE_180
			
			local momz = R_PointToAngle2(0, me.z,
				R_PointToDist2(0,0,me.momx,me.momy),
				me.z + me.momz
			)
			
			if me.z > car.mylastz
			and me.momz <= me.scale
				angle = $ + ANGLE_180
				momz = -$
			end
			
			P_SpawnMobjFromMobj(me,
				P_ReturnThrustX(nil,angle,100*FU),
				P_ReturnThrustY(nil,angle,100*FU),
				0,
				MT_THOK
			)
			
			do
				me.pitch = FixedMul(momz*2,cos(angle))
				me.roll = FixedMul(momz*2,sin(angle))
			end
			
			me.rollangle = 0
		end
		
		p.inkart = 2
		car.stasis = true
		return true
	elseif p.powers[pw_carry] == CR_FAN
	or (me.subsector.sector.specialflags & SSF_FAN)
	or P_PlayerTouchingSectorSpecial(p,4,5)
		local fanpush = mobjinfo[MT_FAN].mass
		car.momz = $+fanpush
		
		if car.momz > fanpush
			car.momz = fanpush
		end
		
	end
	
	if takis.tossflag == 1
		p.jumpaccel = not $
		CONS_Printf(p,p.jumpaccel and
			"\x82Hold JUMP to accelerate your kart." or
			"\x82Hold FORWARD to accelerate your kart."
		)
		S_StartSound(nil,sfx_s268,p)
	end
	
	me.tracer = car
	P_ResetPlayer(p)
	--p.skidtime = 0
	p.charflags = $|SF_NOSKID|SF_RUNONWATER
	p.pflags = $|PF_JUMPSTASIS
	p.inkart = 2
	p.runspeed = (TakisKart_KarterData[me.skin].basenormalspeed*FU)*8/5
	--p.powers[pw_carry] = CR_TAKISKART
	p.powers[pw_ignorelatch] = 32768 - 1
	p.powers[pw_underwater] = 0
	if p.kartingtime == nil then p.kartingtime = 1 end
	p.kartingtime = $+1 or 0
	p.dashmode = 0
	car.scale = me.scale
	takis.transfo = 0|(takis.transfo & TRANSFO_SHOTGUN)
	if takis.use
	or (p["ze2_info"] and p["ze2_info"].isSprinting)
		p.cmd.buttons = $|BT_USE
	end
	TakisResetTauntStuff(p)
	spinouthandle(p,car)
	car.takiscar = TakisKart_KarterData[me.skin].takiskart or false
	if takis.otherskintime == 1
		car.basemaxspeed = data.basenormalspeed*FU
		car.maxspeed = car.basemaxspeed
		p.restat = nil
	end
	car.stats = data.stats
	car.data = data
	if (p.restat ~= nil)
		car.stats[1],car.stats[2] = p.restat[1],p.restat[2]
	end
	car.bikemode = data.bikemode == true
	car.insidedrift = data.insidedrift == true
	
	p.charability,p.charability2 = CA_NONE,CA2_NONE
	car.sidemove = p.cmd.sidemove
	if car.sidemove == 0 then car.sidemove = takis.kart.sidemove end
	
	if (G_RingSlingerGametype() or takis.inSRBZ)
		car.inringslinger = true
	else
		car.inringslinger = false
	end
	
	car.grounded = P_IsObjectOnGround(car)
	
	if p.powers[pw_invulnerability]
	or p.powers[pw_sneakers]
	or car.boostpanel
	or car.tiregrease
		p.runspeed = 10*FU
	end
	
	local canwaterrun = false
	local floorpic = me.subsector.sector.floorpic
	car.standingsec = me.subsector.sector
	for rover in me.subsector.sector.ffloors()
		local floorz = P_MobjFlip(me) == 1 and me.floorz or me.ceilingz
		local foftop = P_MobjFlip(me) == 1 and rover.topheight or rover.bottomheight
		local fofslope = P_MobjFlip(me) == 1 and rover.t_slope or rover.b_slope
		
		if (fofslope and fofslope.valid)
			foftop = P_GetZAt(fofslope,me.x,me.y)
		end
		
		if P_IsObjectOnGround(me)
		and (floorz == foftop
		--extra leeway for sloped fofs
		or (fofslope and fofslope.valid) and abs(abs(floorz) - abs(foftop)) <= 20*me.scale) 
		and (rover.flags & FOF_SOLID)
			floorpic = P_MobjFlip(me) == 1 and rover.toppic or rover.bottompic
			car.standingsec = rover.sector
		end
		
		if not canwaterrun
			canwaterrun = P_CanRunOnWater(p,rover) and (me.eflags & (MFE_TOUCHWATER|MFE_UNDERWATER))
		end
	end
	
	if car.waterignore then car.waterignore = $-1 end
	
	if takis.jump == 1
	and canwaterrun
	or (car.waterignore >= 2 and car.waterignore <= 5)
		if not car.waterignore
			car.waterignore = 5
		end
		car.grounded = true
		canwaterrun = false
	end
	
	if car.waterignore <= 4
	and car.waterignore
		car.grounded = false
	end
	
	car.waterrunning = canwaterrun and P_IsObjectOnGround(me)
	
	if not car.waterrunning
		--waterskip
		if (car.momz*P_MobjFlip(car))/car.scale < 0
		and FixedMul(GetCarSpeed(car),car.scale)/3 >= abs(car.momz)
		and (me.eflags & (MFE_TOUCHWATER|MFE_UNDERWATER) == (MFE_TOUCHWATER|MFE_UNDERWATER))
		and (takis.accspeed >= 15*FU)
			car.momz = -($*9/10)
			car.momx,car.momy = $1*3/5,$2*3/5
		end
		car.flags = $ &~MF_NOGRAVITY
	else
		if P_IsObjectOnGround(me)
		and not P_IsObjectOnGround(car)
			car.momx,car.momy = FixedMul($1,me.friction),FixedMul($2,me.friction)
			car.momz = 0
			car.flags = $|MF_NOGRAVITY
			car.grounded = true
		end
	end
	
	if P_IsObjectInGoop(car) or P_IsObjectInGoop(me)
		car.gooptime = TR*3/2
		car.jumped = false
		car.grounded = true
	else
		if car.gooptime then car.gooptime = $-1 end
	end
	
	local noslopereset = false
	if car.slopetransfer
	--make sure we're "on" a wall
	and not P_IsObjectOnGround(car)
	--and that youre "sticking" onto it (running into it)
	and car.wallstick
		car.grounded = true
		noslopereset = true
		car.momx,car.momy = FixedMul($1,me.friction),FixedMul($2,me.friction)
	end
	
	local wallstickingang = nil
	if car.wallline and car.wallline.valid
		car.stickingtime = $+1
		dprint("HANDLE STICK")
		
		local wallline = car.wallline
		local v1,v2 = wallline.v1,wallline.v2
		
		local whichside = P_PointOnLineSide(car.x,car.y,wallline)
		
		local lineang = R_PointToAngle2(v1.x,v1.y, v2.x,v2.y)
		local stickang = lineang
		if whichside
			lineang = $+ANGLE_180
		end
		
		wallstickingang = lineang
		local lx,ly = P_ClosestPointOnLine(car.x,car.y,wallline)
		local dist = R_PointToDist2(car.x,car.y,lx,ly)
		if false --do
			local lineleng = R_PointToDist2(v1.x,v1.y, v2.x,v2.y)
			local firstvleng = R_PointToDist2(v1.x,v1.y, lx,ly)
			local secondvleng = R_PointToDist2(v2.x,v2.y, lx,ly)
			
			if firstvleng > lineleng
				lx,ly = v2.x,v2.y
			end
			if secondvleng > lineleng
				lx,ly = v1.x,v1.y
			end
		
		end
		
		P_SpawnMobj(lx,ly,car.z,MT_THOK)
		P_SpawnMobj(
			v1.x,
			v1.y,
			car.z,MT_THOK
		)
		P_SpawnMobj(
			v2.x,
			v2.y,
			car.z,MT_THOK
		)
		
		--only stick if we're within the lines' verticies
		do
			local lineleng = R_PointToDist2(v1.x,v1.y,v2.x,v2.y)
			local firstvleng = R_PointToDist2(v1.x,v1.y,car.x,car.y)
			local secondvleng = R_PointToDist2(v2.x,v2.y,car.x,car.y)
			local angleto = R_PointToAngle2(car.x,car.y,lx,ly)
			
			if (firstvleng < lineleng + car.radius*2)
			and (secondvleng < lineleng + car.radius*2)
			or true
			and car.stickingtime < 5
				P_Thrust(car,
					angleto,
					5*car.scale
				)
				P_XYMovement(car)
			end
			
			takis.accspeed = abs(FixedHypot(FixedHypot(me.momx,me.momy) - car.radius/2,me.momz))
			takis.accspeed = FixedDiv($,me.scale)
		end
		
		--uncomment for antigrav
		if true
			car.flags = $|MF_NOGRAVITY
			car.momz = $*9/10
			if abs(car.momz) < FU/32
				car.momz = 0
			end
		end
		
		--stay close to the wall
		if dist <= car.radius*3/2
		and not P_IsObjectOnGround(car)
			local flip = P_MobjFlip(car)
			me.pitch = FixedAngle(FixedMul(-90*FU*flip,cos(lineang+ANGLE_90)))
			me.roll = FixedAngle(FixedMul(-90*FU*flip,sin(lineang+ANGLE_90)))
		end
		car.wallstick = TR/4
		
		local aboveline = false
		do
			local frontsec = wallline.frontsector
			local backsec = wallline.backsector
			local nextsector = nil
			
			if frontsec ~= nil
			and frontsec ~= car.subsector.sector
				nextsector = frontsec
				dprint("FRONTSEC")
			elseif backsec ~= nil
			and backsec ~= car.subsector.sector
				nextsector = backsec
				dprint("BACKSECK")
			end
			
			if nextsector and nextsector.valid
			and (GetActorZ(car,me,1) > nextsector.floorheight)
				dprint("ABOVE")
				if car.wallunstick > 2
					aboveline = true
					P_Thrust(car,
						R_PointToAngle2(car.x,car.y,lx,ly),
						car.radius/2
					)
				end
				car.wallunstick = $+1
			else
				car.wallunstick = 0
			end
		end
		aboveline = false
		
		/*
		if P_IsObjectOnGround(car)
		or car.standingslope
		or aboveline
			car.wallstick = 0
			car.wallline = nil
			car.wallcooldown = 5
			if not aboveline
				dprint("THRUSTBACK")
				P_Thrust(car,
					R_PointToAngle2(car.x,car.y,lx,ly),
					-car.radius*3/2
				)
			else
				me.pitch,me.roll = 0,0
			end
			if car.standingslope
				P_SetObjectMomZ(car,5*FU)
			end
			
		end
		*/
	end
	
	if car.wallstick
		car.wallstick = $-1
		if car.wallstick == 0
			car.wallcooldown = 5
		end
	else
		car.wallunstick = 0
		car.slopetransfer = false
		car.wallline = nil
		car.stickingtime = 0
	end
	
	if car.wallcooldown then car.wallcooldown = $-1 end
	
	if P_MobjFlip(me) == -1
		car.flags2 = $|MF2_OBJECTFLIP
	else
		car.flags2 = $ &~MF2_OBJECTFLIP
	end
	car.friction = me.friction
	car.movefactor = me.movefactor
	
	if p.pflags & PF_SLIDING
	or (takis.pitanim)
	or (me.pizza_out)
		P_MoveOrigin(car,me.x,me.y,me.z)
		car.momx,car.momy,car.momz = me.momx,me.momy,me.momz
		p.pflags = $ &~PF_JUMPSTASIS
		car.angle = me.angle
		me.sprite2 = SPR2_KART
		me.frame = (TakisKart_KarterData[me.skin].legacyframe) and frames.legacy.pain or frames.norm.pain
		car.slidetime = $+1
		car.stasis = true
		return
	else
		car.slidetime = 0
	end
	
	--??
	if p.onconveyor == 2
		car.momx,car.momy = $1+p.cmomx,$2+p.cmomy
	end
	if ApplyWindMomentum
		ApplyWindMomentum(car)
	end
	
	if (me.eflags & MFE_SPRUNG or car.eflags & MFE_SPRUNG)
		car.wallstick = 0
		car.slopetransfer = 0
		car.sprung = true
	end
	
	if car.damagetic then car.damagetic = $-1 end
	car.flags2 = $|MF2_DONTDRAW
	local cmd = p.cmd
	local grounded = car.grounded
	
	if grounded
		takis.coyote = 8+(p.cmd.latency)
	end
	
	if cmd.forwardmove == 0
	and takis.kart.forwardmove ~= 0
		cmd.forwardmove = takis.kart.forwardmove
	end
	if cmd.sidemove == 0
	and takis.kart.sidemove ~= 0
		cmd.sidemove = takis.kart.sidemove
	end
	
	local newrad,newheight = data.radius,data.height
	if newrad == nil
		newrad = skins[p.skin].radius
	end
	if newheight == nil
		newheight = skins[p.skin].height
	end
	newrad,newheight = FixedMul($1,me.scale),FixedMul($2,me.scale)
	
	me.radius,me.height = newrad,newheight
	car.radius,car.height = me.radius,me.height
	me.momx,me.momy,me.momz = car.momx,car.momy,car.momz
	
	car.basemaxspeed = data.basenormalspeed*FU
	local basemaxspeed = car.basemaxspeed
	local maxspeed = car.maxspeed
	local accel = GetAccelStat(p,2,data.stats[2]) --+ (FixedDiv(FixedHypot(car.momx,car.momy),car.scale)>>FRACBITS)*GetAccelStat(p,2,data.stats[1]) --p.accelstart + (basenormalspeed)*p.acceleration
	local slow = FU
	local accelspeedboost = basemaxspeed/2
	accel = ($*FU)/255
	
	if (car.bikemode)
		accel = $*3/2
	end

	if car.justbumped
		--accel = $/car.justbumped
		car.justbumped = $-1
	end
	if car.justbumped > 8 then car.justbumped = 8 end
	if car.justbumped < 0 then car.justbumped = 0 end
	
	if (TAKIS_TUTORIALSTAGE >= 1)
	and (TAKIS_TUTORIALSTAGE <= 2)
		car.basemaxspeed = basemaxspeed/2+(FixedMul(basemaxspeed/2, min( FixedDiv(max(p.rings,p.spheres)*FU,40*FU),FU) ))
		maxspeed = car.maxspeed
	end
	
	if car.inringslinger
		car.basemaxspeed = basemaxspeed/2+(FixedMul(basemaxspeed/2, min( FixedDiv(max(p.rings,p.spheres)*FU,40*FU),FU) ))
		maxspeed = car.maxspeed
		
		local rings = min(max(p.rings,p.spheres),40)
		local spheredigestion = 2*TR
		local digestionpower = ((10 - data.stats[1]) + (10 - data.stats[2]))-1
		digestionpower = ($*rings)/20
		
		if digestionpower >= spheredigestion
			spheredigestion = 1
		else
			spheredigestion = $-(digestionpower/2)
		end
		
		if rings > 0 and car.spheredigestion > 0
			if (spheredigestion < car.spheredigestion)
				car.spheredigestion = (spheredigestion + car.spheredigestion)/2
			end
			car.spheredigestion = $-1
			
			if (car.spheredigestion == 0)
				if (rings > 5)
					rings = $-1
				end
				car.spheredigestion = spheredigestion
			end
			
		else
			car.spheredigestion = spheredigestion
		end
		if p.rings > p.spheres
			p.rings = rings
		else
			p.spheres = rings
		end
	end
	if takis.inWater
		car.basemaxspeed = $*3/4
		accel = $*3/4
	end
	car.basemaxspeed = FixedMul($,TakisKart_GetGearMul())
	
	if car.accel ~= 0
	and car.accel < -accel*2
	--and FixedHypot(car.momx,car.momy) <= 5*car.scale
		maxspeed = car.maxspeed/2
	end
	
	if car.takiscar
		if not (TAKIS_TUTORIALSTAGE)
			car.fuel = $-(FixedDiv(100*FU,120*TR*FU))
		end
		if car.fuel <= 25*FU
			if not (leveltime % TR)
				S_StartSoundAtVolume(car,sfx_kartlf,255/2,p)
			end
		end
		
		if p.rings > takis.lastrings
			local oldfuel = car.fuel
			
			local diff = min((p.rings - takis.lastrings),20)
			car.fuel = $ + diff*FU
			car.fuel = min($,100*FU)
			
			if TAKIS_TUTORIALSTAGE == 5
			and (car.fuel == 100*FU and oldfuel ~= 100*FU)
				P_LinedefExecute(10,car) --,car,car.subsector.sector)
				S_StartSound(nil,sfx_doora1)
			end
			
		end
	end
	
	car.moving = cmd.forwardmove --or takis.kart.forwardmove
	car.reversing = min(cmd.forwardmove,0)
	if extrastuff
	and (spaceaccel or p.jumpaccel)
	and not p.bot
	and not car.inpain
	--and not (p.exiting)
		car.moving = min(takis.kart.jump,50)
		car.reversing = ((takis.kart.jump) and (cmd.forwardmove <= -CMD_DEADZONE*3/2)) and 50 or 0
	end
	if p.exiting
		if car.exiting == 1
		and extrastuff
		and lastexplodes
			print("ASDSADSAD")
			for player in players.iterate
				if p == player then continue end
				
				local pmo = player.mo
				if not (pmo and pmo.valid) then continue end
				if not (pmo.health) then continue end
				if (player.exiting) then continue end
				if not (player.inkart) then continue end
				
				print("ASDASDSADASDASDASDSAD")
				pmo.diedlast = true
				player.laps = p.laps
				player.realtime = 90238432
				player.starpostnum = TAKIS_NET.maxpostcount
				P_DoPlayerExit(p)
				player.exiting = 3*TR
				--P_KillMobj(pmo,nil,nil,DMG_INSTAKILL)
			end
		end
		
		if me.diedlast
			p.realtime = 90238432 + #p
			P_DoPlayerExit(p)
			--p.powers[pw_nocontrol] = 4
		end
		
		car.exiting = $+1
		if car.exiting > TR
			car.moving,car.reversing = 0,0
		else
			car.moving = ease.outsine((FU/TR)*car.exiting,$,0)
			car.reversing = ease.outsine((FU/TR)*car.exiting,$,0)
		end
	else
		car.exiting = 0
	end
	
	local butteredslope = true
	car.handleboost = 0
	
	local doebrake = false
	if cmd.buttons & BT_CUSTOM1
		if (car.drift == 0)
			doebrake = not car.spindashrelease
		-- e-BRAKING
		else
			car.moving = 0
			car.reversing = -50
		end
	end
	
	if (car.drift and not grounded and cmd.buttons & BT_CUSTOM1)
	or (car.ebrake and not grounded and not car.sprung)
		doebrake = true
	end
	
	if car.inpain
	or (TAKIS_TUTORIALSTAGE and TAKIS_TUTORIALSTAGE <= 3)
	or (p.textBoxInAction and not p.textBoxCanMove)
		doebrake = false
		car.spindash = false
		car.spindashcharge = 0
		car.spindashsound = 0
	end
	
	--ebrake
	if doebrake
		if grounded
			car.drift = 0
			car.driftspark = 0
		end
		car.sprung = false
		takis.slopeairtime = false
		car.handleboost = $+FU/3
		
		local spindash = (cmd.buttons & BT_USE) and grounded
		if not spindash
			if car.spindashcharge
				dospindash(p,me,car)
			else
				if not S_SoundPlaying(car,sfx_s3kd9s)
					S_StartSound(car,sfx_s3kd9s)
				end
				if grounded
				or (not grounded and not (car.moving or car.reversing))
					car.accel = $*125/200
					car.momx,car.momy = $1*175/200,$2*175/200
				end
				
				if not grounded
				--and (cmd.buttons & BT_USE)
					P_SetObjectMomZ(car,-4*FU,true)
					me.pitch = FixedMul($,FU*3/5)
					me.roll = FixedMul($,FU*3/5)
				end
				car.spindash = false
				car.spindashcharge = 0
				car.spindashsound = 0
				
				local height = FixedDiv(me.height,me.scale)/FU
				local thok = P_SpawnMobjFromMobj(me,0,0,
					P_RandomRange(height*2,height)*FU + 
					(takis.gravflip == -1 and height*FU or 0),
					MT_THOK
				)
				thok.height = me.height
				thok.flags2 = $|MF2_DONTDRAW
				thok.angle = car.angle+(not takis.in2D and ANGLE_90 or 0)
				
				do
					local wind = P_SpawnMobjFromMobj(thok,
						P_RandomRange(-32,32)*FU,
						P_RandomRange(-32,32)*FU,
						P_RandomRange(0,32)*FU,
						MT_TAKIS_WINDLINE
					)
					--wind.state = S_TAKIS_WINDLINE
					wind.blendmode = AST_ADD
					wind.frame = $|FF_FULLBRIGHT
					P_SetObjectMomZ(wind,P_RandomRange(-15,-22)*FU)
					wind.color = SKINCOLOR_GREY
					wind.angle = thok.angle
					wind.rollangle = ANGLE_270
					
					wind.momx,wind.momy,wind.momz = car.momx,car.momy,$3+car.momz
				end
				
				if (leveltime % 5 == 0)
					local ring = P_SpawnMobjFromMobj(me,
						0,0,(takis.gravflip == 1 and FixedDiv(me.height,me.scale) or 0),
						MT_THOK --MT_WINDRINGLOL
					)
					if (ring and ring.valid)
						ring.renderflags = RF_FLOORSPRITE
						ring.frame = $|FF_FULLBRIGHT
						ring.startingtrans = 0
						ring.scale = me.scale*8/10
						P_SetObjectMomZ(ring,22*FU)
						--i thought this would fade out the object
						ring.fuse = 10
						ring.colorized = true
						ring.color = SKINCOLOR_WHITE
						ring.blendmode = AST_ADD
						ring.state = S_SOAPYWINDRINGLOL
					end
				end
				if (leveltime % 6 == 0)
				and grounded
					local ring = P_SpawnMobjFromMobj(me,
						0,0,0, -- (takis.gravflip == -1 and me.height or 0),
						MT_THOK --MT_WINDRINGLOL
					)
					if (ring and ring.valid)
						ring.flags = $ &~MF_NOCLIPHEIGHT
						ring.renderflags = RF_FLOORSPRITE|RF_NOSPLATBILLBOARD|RF_OBJECTSLOPESPLAT|RF_SLOPESPLAT
						if (car.standingslope)
							P_CreateFloorSpriteSlope(ring)
							/*
							ring.floorspriteslope.zdelta = car.standingslope.zdelta
							ring.floorspriteslope.zangle = car.standingslope.zangle
							ring.floorspriteslope.xydirection = car.standingslope.xydirection
							ring.floorspriteslope.o = car.standingslope.o
							*/
						end
						ring.frame = $|FF_FULLBRIGHT
						ring.startingtrans = 0
						ring.fuse = 6
						--ring.destscale = ring.scale*5/4
						ring.colorized = true
						ring.color = SKINCOLOR_WHITE
						ring.blendmode = AST_ADD
						ring.state = S_SOAPYWINDRINGLOL
						--ring.z = car.floorz
					end
				end
				
				takis.spritexscale = $+(FU/10)
				takis.spriteyscale = $-(FU/10)
				P_RemoveMobj(thok)
			end
			
		--spindash
		else
			dospindash(p,me,car,true)
			S_StopSoundByID(car,sfx_s3kd9s)
		end
		butteredslope = false
		car.moving = 0
		car.reversing = 0
		car.ebrake = true
	else
		S_StopSoundByID(car,sfx_s3kd9s)
		car.ebrake = false
		if not (cmd.buttons & BT_USE)
			if car.spindashcharge
				dospindash(p,me,car)
				car.handleboost = FU/3
			end
			
			car.spindashcharge = 0
			car.spindash = false
			car.spindashsound = 0
		else
			if car.spindashcharge
				butteredslope = dospindash(p,me,car,true)
			end
		end
		
		if not (cmd.buttons & BT_CUSTOM1)
			car.spindashrelease = false
		end
	end
	
	--i know this is a weird button combination, so give some leeway to 
	--start accelerating
	if car.spindashboost
		--...except if youve already started moving
		if car.moving
			car.spindashboost = min($,3)
		else
			car.moving = 25
		end
		car.spindashboost = $-1
	end
	
	local moving = car.moving
	local reversing = car.reversing
	if car.inpain
	or (p.textBoxInAction and not p.textBoxCanMove)
		moving,reversing = 0,0
		butteredslope = false
	end	
	
	/*
	if (car.standingslope and car.standingslope.valid)
		local ang = car.standingslope.xydirection
		local th = P_SpawnMobjFromMobj(me,
			P_ReturnThrustX(nil, ang, 25*me.scale),
			P_ReturnThrustY(nil, ang, 25*me.scale),
			me.height/2,
			MT_THOK
		)
		th.angle = ang
		th.renderflags = RF_PAPERSPRITE
	end
	*/
	
	if p.powers[pw_sneakers]
	and false
		car.handleboost = $+(7*FU/8)
	end
	if (p.powers[pw_invulnerability])
		car.handleboost = $+(7*FU/8)/2
	end
	if (car.boostpanel)
		car.handleboost = $+(7*FU/8)
	end
	
	--turning
	--angle diff between old and new angs should be 2-3	
	if car.sidemove
		local turndir = -(car.sidemove > 0 and 1 or -1)
		local driftdir = ((car.drift > 0) and 1 or -1)
		car.turningtic = $+1
		
		--start a drift
		if (cmd.buttons & BT_SPIN)
		and not (car.driftedout)
		and (max(GetCarSpeed(car,CS_ACCEL),GetCarSpeed(car)) >= 10*FU)
		and car.drift == 0
		--and grounded
		and abs(car.sidemove) >= CMD_DEADZONE
		and moving >= CMD_DEADZONE
		and not car.reversing
		and not car.ebrake
		and not (TAKIS_TUTORIALSTAGE and TAKIS_TUTORIALSTAGE <= 2)
			car.drift = $+turndir
			car.driftangle = car.angle
			p.drawangle = $ - ANGLE_45
		end
		
		if (max(GetCarSpeed(car,CS_ACCEL),GetCarSpeed(car)) >= FU/2)
		or car.ebrake or (not grounded)
		or (car.spinouttype)
			local sidemove = 0
			if abs(car.sidemove) >= CMD_DEADZONE
			--and sidemove == FU --keyboard only
				sidemove = FixedDiv(abs(car.sidemove),32)
			end
			sidemove = min($,FU)
			local extraturn = (car.stats[2]/3)*FU*2
			local baseturn = 45*FU
			local driftturn = 50*FU --*TakisKart_GetGearMul()
			local cdriftturn = -5*FU
			if car.insidedrift
				baseturn = 47*FU
				driftturn = 53*FU
			end
			if takis.inWater
				baseturn = FixedMul($,FixedDiv(38*FU,45*FU))
				driftturn = $*11/10
			end
			
			if car.pogospring
				--baseturn = $*3
			end
			
			--drifting controls
			if car.drift ~= 0
			and grounded
				local driftadd = 0
				local mul = FU
				if GetCarSpeed(car) > (car.basemaxspeed)*14/10
					mul = FixedDiv(GetCarSpeed(car),(car.basemaxspeed)*14/10)
				end
				
				car.turningtic = min($,3)
				
				--if we're drifting, then countersteer a bit
				if turndir ~= driftdir
				
					local dest = FixedMul(cdriftturn,sidemove)*driftdir
					car.momt = ease.inexpo(FU,$,dest)
					
					if not (car.offroad)
						driftadd = $ - FixedMul(7,sidemove)
					end
				else
					if turndir == driftdir	
					and car.maxspeed > car.basemaxspeed/2
					and not car.ctrcar
						--local sidemove = min(sidemove,FU)
						car.maxspeed = $*198/201 --,FixedMul(FixedDiv(FU*198,FU*201)
					end
					
					local dest = FixedMul(FixedMul(driftturn+extraturn,sidemove),mul)*turndir
					car.momt = ease.inexpo(FU,$,dest)
					
					if not (car.offroad)
						if (p.powers[pw_shield] & SH_PROTECTELECTRIC)
							mul = $*25/10
						end
						driftadd = $ + FixedMul(FixedMul(5,sidemove),mul)
					end
				end
				if (GetCarSpeed(car) >= 10*FU)
					car.driftspark = $+driftadd
				end
				if car.bikemode
					car.driftspark = min($,TakisKart_DriftSparkValue(car.stats)*3)
				end
			else
				if (car.turningtic <= 5)
					sidemove = $/2
				end
				
				if (car.sliptide ~= 0)
					extraturn = $ + FixedMul(
						FixedDiv(GetCarSpeed(car),car.basemaxspeed),
						FixedMul(FixedDiv(60*FU,FixedDiv(7*FU,3*FU)),TakisKart_GetGearMul())
					)
				end
				
				car.momt = FixedMul(baseturn+extraturn,sidemove+car.handleboost)*turndir
				if sidemove >= FU/2
					local decre = 190*FU/201
					local weight = FU --min(10-FixedDiv(car.stats[2]*FU,9*FU),FU)
					
					if car.turningtic > TR*3/4
					and grounded
					and GetCarSpeed(car,CS_ACCELNOABS) > car.basemaxspeed/3
					and false == true
						if not takis.inWater
							weight = FU*172/200
						else
							--weight = FU*197/200
						end
						if leveltime % 6 == 0
							S_StartSound(car,sfx_kartsc)
							spawntiredust(p,me,car)
						end
					end
					if takis.inWater
						weight = FixedMul($,FU*198/200)
					end
					
					decre = FixedMul($,weight)
					car.accel = FixedMul($,decre)
				end
			end
		end
		car.turning = true
	else
		car.turningtic = 0
		car.turning = false
	end
	
	driftstuff(p,car,data)
	car.momt = $/2
	--"real" turning momentum
	car.rmomt = ease.outcubic(FU*3/5,$,car.momt)
	car.angle = $+FixedAngle(car.rmomt/9)
	--
	
	--move
	/*
	if (takis.fire == 1
	or (not (takis.fire % 3) and takis.fire))
	and p.rings > 0
	and not (car.inringslinger)
		P_GivePlayerRings(p,-1)
		local me = p.realmo
		local ring = P_SpawnMobjFromMobj(me,me.momx,me.momy,me.momz,MT_RING)
		local sfx = P_SpawnGhostMobj(ring)
		sfx.flags2 = $|MF2_DONTDRAW
		sfx.type = MT_THOK
		sfx.tics,sfx.fuse = TR,TR
		ring.shadowscale = 0
		S_StartSound(sfx,sfx_itemup)
		P_KillMobj(ring,me,me)
	end
	*/
	
	if (circuitmap)
		if (p.realtime == 0)
			--starting boost
			if leveltime >= TR
				if moving
					if car.boostcharge == 0
						car.boostcharge = cmd.latency
					end
					car.boostcharge = $+1
				else
					car.boostcharge = 0
				end
			end
			moving = 0
			
			me.flags2 = $ &~MF2_DONTDRAW
			local scale = FixedMul(FU,car.boostcharge*131)
			takis.spritexscale,takis.spriteyscale = $1+scale,$2+scale
		elseif car.boostcharge
			if car.boostcharge < 35
				if car.boostcharge > 17
					S_StartSound(car,sfx_cdfm00)
				end
			elseif car.boostcharge <= 50
				
				if car.boostcharge <= 36
					car.tiregrease = max($,TR*2)
					car.boostpanel = max($,2*TR)
					P_Thrust(car,car.angle,car.maxspeed/2)
					S_StartSound(car,sfx_cdfm01)
				else
					if car.boostcharge <= 40
						S_StartSound(car,sfx_cdfm01)
						car.tiregrease = max($,TR)
						car.boostpanel = TR
						P_Thrust(car,car.angle,car.maxspeed/2)
					else
						P_Thrust(car,car.angle,car.maxspeed/2)
						S_StartSound(car,sfx_s23c)
					end
				end
			elseif car.boostcharge > 50
				TakisKart_DoSpinout(p,nil,SPINOUT_SPIN)
				--S_StartSound(car,sfx_s3k83)
			end
			car.boostcharge = 0
		end
	end
	
	car.nooffroad = false
	if car.driftboost 
		if car.drift == 0
		or true
			car.basemaxspeed = $*3/2
		else
			car.maxspeed = data.basenormalspeed*FU
			car.driftboost = $-1
		end		
		--accel = $*2
		TakisDoWindLines(me,nil,TakisKart_DriftColor(car.driftboostcolor))
		car.driftboost = $-1
		
		/*
		if car.driftboost % 6 == 0
			local ring = CreateWindRing(p,me)
			ring.blendmode = AST_ADD
			ring.color = TakisKart_DriftColor(car.driftboostcolor)
			ring.spritexscale,ring.spriteyscale = $1*3/5,$2*3/5
			P_MoveOrigin(ring,
				me.x + P_ReturnThrustX(nil,p.drawangle,-me.radius - 6*me.scale),
				me.y + P_ReturnThrustY(nil,p.drawangle,-me.radius - 6*me.scale),
				ring.z
			)
			ring.angle = (car.angle + ((ANGLE_45/5)*car.drift)) + ANGLE_90
			P_Thrust(ring,ring.angle - ANGLE_90,-15*me.scale)
			ring.momx = $+me.momx*3/4
			ring.momy = $+me.momy*3/4
			ring.momz = $+me.momz*3/4
		end
		*/
		
		if car.driftboost < 0
			car.driftboost = 0
		end
	end
	if car.speedpad
		TakisDoWindLines(me)
		P_SpawnGhostMobj(me)
		car.speedpad = $-1
		--takis.slopeairtime = false
	end
	
	
	/*
	if car.ringboost
		if car.ringboost > 3*TR
			car.ringboost = 3*TR
		end
		car.basemaxspeed = $*13/10
		TakisDoWindLines(me,nil,SKINCOLOR_SUPERRUST4)
		car.ringboost = $-1
	end
	*/
	
	if p.powers[pw_sneakers]
	or (p.powers[pw_invulnerability])
		local color
		if p.powers[pw_invulnerability]
			if p.powers[pw_invulnerability] > 3*TR
				color = TakisKart_DriftColor(5)
				me.color = color
				me.colorized = true
			elseif p.powers[pw_invulnerability] & 1
				color = SKINCOLOR_WHITE
				me.color = color
				me.colorized = true			
			else
				color = p.skincolor
				me.color = color
				me.colorized = false
				color = nil
			end
			accel = $*2
			car.invuln = $+1 --p.powers[pw_invulnerability]
		end
		TakisDoWindLines(me,nil,color)
		car.basemaxspeed = $ + accelspeedboost
		car.nooffroad = true
		--accel = $*3/2
	end
	if not p.powers[pw_invulnerability]
	and car.invuln
		me.color = p.skincolor
		me.colorized = false
		car.invuln = 0
	end
	if (car.boostpanel)
		car.basemaxspeed = $ + accelspeedboost
		TakisDoWindLines(me)
		car.boostpanel = $-1
		car.nooffroad = true
	end
	updateoffroad(p,car)
	
	if extrastuff
		if InSectorSpecial(me,true,4,6)
		or car.linepanel
		and car.boostpanelsec ~= car.subsector.sector
			P_Thrust(car,car.angle,15*car.scale)
			car.boostpanel = TR
			S_StartSound(car,sfx_cdfm01)
			car.linepanel = 0
			car.boostpanelsec = car.subsector.sector
		end
		
		if InSectorSpecial(me,true,1,9)
		and not car.inpain
		and not (p.powers[pw_flashing])
			TakisKart_DoSpinout(p,nil,SPINOUT_SPIN)
		end
		
		--255: spring panel
		--theres no sector special for this in vanilla
		if (floorpic == "SPRING"
		or floorpic == "SPRINGS")
		and (car.grounded and P_IsObjectOnGround(car))
		and car.pogosector ~= car.subsector.sector
			local hscale = MAPSCALE + (MAPSCALE - me.scale)
			local minspeed = 24*hscale
			local pushangle = FixedHypot(car.momx,car.momy) and R_PointToAngle2(0,0,car.momx,car.momy) or me.angle
			if not (me.eflags & MFE_SPRUNG)
			and not car.pogospring
				if FixedMul(GetCarSpeed(car),me.scale) < minspeed
					P_InstaThrust(car,pushangle,minspeed)
				end
				DoPogoSpring(p,me,car)
			end
		end

		--768: spring panel (capped speed)
		--theres no sector special for this in vanilla
		if (floorpic == "SPRINGY"
		or floorpic == "SPRINGYS")
		and (car.grounded and P_IsObjectOnGround(car))
		and car.pogosector ~= car.subsector.sector
			local hscale = MAPSCALE + (MAPSCALE - me.scale)
			local minspeed = 24*hscale
			local maxspeed = 28*hscale
			local pushangle = FixedHypot(car.momx,car.momy) and R_PointToAngle2(0,0,car.momx,car.momy) or me.angle
			if not (me.eflags & MFE_SPRUNG)
			and not car.pogospring
				if FixedMul(GetCarSpeed(car),me.scale) > maxspeed
					P_InstaThrust(car,pushangle,maxspeed)
				elseif FixedMul(GetCarSpeed(car),me.scale) < minspeed
					P_InstaThrust(car,pushangle,minspeed)
				end
				DoPogoSpring(p,me,car)
			end
		end
	end
	
	if car.drift == 0
		if car.maxspeed < car.basemaxspeed
			if car.maxspeed < 0
				car.maxspeed = FU
			end
			car.maxspeed = $*202/198
		elseif maxspeed > car.basemaxspeed
			car.maxspeed = ease.inquad(FU/3,$,car.basemaxspeed)
		end
	end
	
	--ACTUALLY START MOVING
if false --#if
	if moving ~= 0
		local acceldir = 1 --(moving > 0) and 1 or -1
		if reversing and acceldir ~= -1 then acceldir = -1 end
		local move = acceldir == 1 and moving or reversing
		local forwardmove = 0
		if abs(moving) >= CMD_DEADZONE
			forwardmove = min(FixedDiv(abs(move),25),FU)
		end
		
		car.acceltime = $+1
		local cmaxspeed = FixedMul(car.maxspeed,forwardmove)
		if acceldir == 1
			if car.accel < 0
				local ab = (car.accel > 0) and 1 or -1
				car.accel = (abs($)*4/5)*ab
			end
			if car.accel+accel < cmaxspeed/8
				car.accel = $+accel
			else
				car.accel = cmaxspeed/8
			end
		--back it up terry
		else
			--braking
			--if car.accel > 0
			--or (GetCarSpeed(car,CS_ACCELNOABS) >= cmaxspeed/8)
			if TakisAngleSpeed(car)/car.scale > 5
			and wallstickingang == nil
				if grounded
					brakegfx(p,car)
					if not S_SoundPlaying(car,sfx_takskd)
						S_StartSound(car,sfx_takskd)
					end
				end
				car.accel = $*185/200
				car.momx,car.momy = $1*185/200,$2*185/200
			else
				S_StopSoundByID(car,sfx_takskd)
				if car.accel-accel > -cmaxspeed/16
					car.accel = $-accel
				else
					car.accel = -cmaxspeed/16
				end
			end
			
		end
	else
		car.accel = 0 --(FixedMul(abs($),29*FU/32))*ab
		S_StopSoundByID(car,sfx_takskd)
		car.acceltime = 0
	end
	if car.accel > (car.maxspeed/8)--+(accel*2)
		car.accel = ease.inquad(FU/3,$,car.maxspeed/8)
	end
	
	car.oldspeed = R_PointToDist2(car.momx - p.cmomx,car.momy - p.cmomy,0,0)
	local thrustangle = car.angle
	if grounded
		if car.drift ~= 0
			local outsideangle = (AngleFixed(ANGLE_45)/9)*car.drift
			
			--you still slip even with inside drift!
			if me.movefactor ~= FU
				local movefactor = FU - car.fakemovefactor
				local weightmul = FixedDiv(car.stats[2]*FU,9*FU)
				
				movefactor = FixedMul($,FU - weightmul)
				
				outsideangle = FixedMul($,FU + (movefactor*14/10))
			elseif car.insidedrift
				outsideangle = 0
			end
			
			thrustangle = car.angle - FixedAngle(outsideangle)
		--slippery turns
		else
			if me.movefactor ~= FU
			or (takis.inWater)
				local movefactor = FU - car.fakemovefactor
				local weightmul = FixedDiv(car.stats[2]*FU,9*FU)
				
				movefactor = FixedMul($,FU - weightmul)
				
				if takis.inWater
					movefactor = $/2
				end
				
				local adjust = (car.momt)/2
				adjust = FixedMul($,FU + (movefactor*14/10))
				
				thrustangle = car.angle - FixedAngle(adjust)
			end
		end
	end
	if (car.boostpanel)
		if grounded
			car.accel = max($,car.maxspeed/8)
		end
		if car.boostpanel == TR
			P_Thrust(car,thrustangle,4*car.scale)
		end
		if GetCarSpeed(car) < car.basemaxspeed
			P_Thrust(car,thrustangle,FixedMul(car.basemaxspeed-GetCarSpeed(car),car.scale))
		end
	end
	car.fakemovefactor = ease.inexpo(FU*3/4,$,me.movefactor)
	
	--orig = (232 << (FRACBITS-8))
	--Shitty
	--print(string.format("%f",FixedMul(me.friction,me.movefactor)))
	local friction = (false) and FixedMul(me.friction,me.movefactor) or me.friction  --+ (FU - me.movefactor)*9/10
	local movethrust = FixedMul(friction, car.accel) --FixedMul(car.friction, car.accel)
	
	if p.kartfric ~= nil
		car.movefactor = p.kartfric[2]
	end
	if GetCarSpeed(car) > car.maxspeed*3/2
		car.friction = FU*8/10
	else
		if p.kartfric ~= nil
			car.friction = p.kartfric[1]
		end
	end
	
	/*
	if car.friction > 29*FU/32
		if FixedHypot(car.momx,car.momy) > car.maxspeed
			movethrust = 0
		end
	end
	*/
	if not P_IsObjectOnGround(car)
		car.boostpanelsector = nil
		car.pogosector = nil
	end
	
	if not (grounded or car.pogospring)
		movethrust = $/10
		if moving >= 0
			if GetCarSpeed(car) > car.maxspeed
				movethrust = 0
			end
		elseif reversing
			if GetCarSpeed(car) > car.maxspeed/2
				movethrust = 0
			else
				movethrust = $*3
			end
		end
	else
		if car.pogospring
			local minspeed,maxspeed = unpack(car.pogospeeds)
			local angle = TakisMomAngle(car)
			
			minspeed,maxspeed = FixedMul($1,MAPSCALE),FixedMul($2,MAPSCALE)
			
			if GetCarSpeed(car) > maxspeed
				car.momx = P_ReturnThrustX(nil,angle,maxspeed)
				car.momy = P_ReturnThrustY(nil,angle,maxspeed)
				movethrust = 0
			elseif GetCarSpeed(car) < minspeed
				car.momx = P_ReturnThrustX(nil,angle,minspeed)
				car.momy = P_ReturnThrustY(nil,angle,minspeed)
			end
			
			me.pitch,me.roll = 0,0
		else
			car.pogospeeds = {0,0}
		end
		
		if not noslopereset
			car.slopetransfer = false
		end
		if car.offroad > 0
			if GetCarSpeed(car)/FU ~= 0
				if not (leveltime % 6)
					S_StartSound(car,sfx_cdfm70)
				end
				if not (leveltime % 2)
					spawntiredust(p,me,car)
				end
			end
			movethrust = FixedDiv($,car.offroad+FU)
		end
		
		/*
		if GetCarSpeed(car) > car.basemaxspeed+(FU*2)
			local mul = FU
			mul = FixedDiv(GetCarSpeed(car),car.basemaxspeed*4/5)
			movethrust = FixedDiv($,mul)
		end
		*/
	end
	movethrust = FixedMul($,car.scale)
	if wallstickingang == nil
		P_Thrust(car, thrustangle, movethrust)
	
	--we're driving on a wall, le 
	--i never finished this comment i think leaving like this is
	--funny as hell
	--handle wallstick accel
	else
		local vertmove = -sin(wallstickingang - car.angle)
		local horimove = abs(sin((wallstickingang+ANGLE_90)- car.angle))
		
		/*
		print("VERT",
			--L_FixedDecimal(FU + vertmove),
			--L_FixedDecimal(FU - vertmove),
			string.format("%f",vertmove),
			--L_FixedDecimal(abs(vertmove)),
			string.format("%f",horimove)
		)
		*/
		
		P_Thrust(car, thrustangle,
			FixedMul(movethrust, horimove)
		)
		
		movethrust = FixedDiv($,car.scale)
		--its harder to go up the wall
		if movethrust > 0
		and car.momz*P_MobjFlip(me) > 0
		and not (car.flags & MF_NOGRAVITY)
			movethrust = $/2
			movethrust = $*3/4
		end
		P_SetObjectMomZ(car, FixedMul(movethrust,vertmove), true)
	end
else
	dokartacceleration(p,me,car,data,moving,reversing)
end	--#endif
	
	if car.drift == 0
	and car.pogospring == 0
	and grounded
	and (car.accel/FU > 1 and GetCarSpeed(car) > FU)
		local myangle = car.angle
		if car.reversing
			myangle = InvAngle($)
		end
		
		local test = P_SpawnMobjFromMobj(car,0,0,0,MT_RAY)
		test.momx,test.momy = car.momx - p.cmomx, car.momy - p.cmomy
		test.angle = car.angle
		
		local diff = R_PointToAngle2(0,0,test.momx,test.momy) - myangle 
		
		--9 + 10
		if abs(diff) > 21*ANG1
			if leveltime % 6 == 0
				S_StartSound(car,sfx_kartsc)
				spawntiredust(p,me,car)
			end
		end
		P_RemoveMobj(test)
	end
	
	/*
	local nextsector = R_PointInSubsector(me.x + me.momx,me.y + me.momy)
	if not P_TryMove(me,
		me.x+P_ReturnThrustX(nil,thrustangle,movethrust),
		me.y+P_ReturnThrustY(nil,thrustangle,movethrust),
		true
	)
	and not ((car.standingslope and car.standingslope.valid)
	or (me.standingslope and me.standingslope.valid)
	or (nextsector.sector[(P_MobjFlip(me) == 1 and "f_slope" or "c_slope")]))
		car.accel = min($,15*FU/8)
	end
	*/
	
	--ringracers bro
	if true
		if not car.inpain
		and (p.realtime > 0)
		and butteredslope
		and (car.standingslope and car.standingslope.valid)
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
				local angle,thrust = getslopeinfluence(car,nil,
					{allowstand = true, allowmult = true}
				)
				if (angle ~= nil)
					P_Thrust(car,angle,thrust*2)
				end
			--a little bit of resistance on slopes
			else
				local angle,thrust = getslopeinfluence(car,nil,
					{allowstand = true, allowmult = true}
				)
				if (angle ~= nil)
					P_Thrust(car,angle,thrust*3/4)
				end
				
			end
		end
	else
		if not car.inpain
		and (p.realtime > 0)
		and butteredslope
			P_ButteredSlope(car)
			P_ButteredSlope(car)
		end
	end
	
	--tire tracks/
	/*
	if grounded
	and (GetCarSpeed(car) >= 60*FU
	or car.drift ~= 0)
	and not TAKIS_NET.noeffects
		for i = 0,1
			local momx,momy = 0,0
			if i == 1
				momx,momy = car.momx/2,car.momy/2
			end
			
			local track = P_SpawnMobjFromMobj(car,momx,momy,0,MT_THOK)
			track.scale = car.scale
			track.lifetime = 10*TR
			track.sprite = SPR_TMIS
			track.frame = F
			track.tics,track.fuse = track.lifetime,track.lifetime
			track.renderflags = RF_OBJECTSLOPESPLAT|RF_NOSPLATBILLBOARD|RF_FLOORSPRITE
			track.angle = thrustangle
			track.flags = $ &~(MF_NOSECTOR|MF_NOBLOCKMAP)
		end
	end
	--
	*/
	
	--jump
	local nojump = leveltime < 2
	if TAKIS_TUTORIALSTAGE == 1
	or (p.textBoxInAction and not p.textBoxCanMove)
		nojump = true
	end
	
	local jumped = false
	if (cmd.buttons & BT_JUMP)
	and not (p.lastbuttons & BT_JUMP)
	and not (car.ebrake)
	and not nojump
		if wallstickingang ~= nil
		and car.wallline
			local lx,ly = P_ClosestPointOnLine(car.x,car.y,car.wallline)
			
			L_ZLaunch(car,3*FU)
			P_Thrust(car,
				R_PointToAngle2(car.x,car.y,lx,ly),
				-10*car.scale
			)
			car.wallline = nil
			car.wallstick = 0
			
			S_StartSound(car,sfx_ngjump)
			car.jumped = true
			car.jumphalf = false
			jumped = true
		elseif (grounded or takis.coyote)
		and car.drift == 0
		and not car.inpain
		and not car.jumped
		and not extrastuff
			P_SetObjectMomZ(car,15*FU)
			S_StartSound(car,sfx_ngjump)
			car.jumped = true
			car.jumphalf = false
			jumped = true
		end
	end
	if not (cmd.buttons & BT_JUMP)
	and car.jumped
	and car.momz*P_MobjFlip(car) > 0
	and not car.jumphalf
		car.momz = $/2
		car.jumphalf = true
	end
	--
	
	if takis.slopeairtime then car.sprung = true end
	TakisBreakAndBust(p,car)
	TakisDirBreak(p,me,car.angle)
	local flashingtics = flashingtics/2
	if not grounded
	or wallstickingang ~= nil
		if not (car.sprung)
		and not car.gooptime
			car.momz = $+(P_GetMobjGravity(car)*3/5)
		end
		
		if takis.inWater
		and car.momz*takis.gravflip <= 10*car.scale
			car.momz = $+(P_GetMobjGravity(car)*2)
		end
		
		if wallstickingang ~= nil
		and not (car.flags & MF_NOGRAVITY)
			car.momz = $+(P_GetMobjGravity(car)*3/5)
		end
		
		if car.pogospring
			car.momz = $+(P_GetMobjGravity(car)*5/2)
			if car.pogospring ~= 1
				car.pogospring = $-1
			end
		end
	end
	
	if grounded
		if not jumped
			car.jumped = false
			car.jumphalf = false
		end
		if car.pogospring == 1
			car.pogospring = 0
			car.painspin = 0
		end
		car.sprung = false
	end
	
	animhandle(p,car,data)
	soundhandle(p,car,data)
	fxhandle(p,car,wallstickingang)
	
	do
		local ceilz = (takis.gravflip == 1 and me.ceilingz or me.floorz)
		local dobonk = false
		
		if (takis.lastmomz*takis.gravflip > 0)
			if takis.gravflip == 1
			and (
				me.z+me.height + me.momz >= ceilz-me.scale 
				--and me.z+me.height + me.momz*2 <= ceilz+me.scale
			)
				dobonk = true
			elseif takis.gravflip == -1
			and (
				me.z + me.momz <= ceilz-me.scale
				--and me.z + me.momz*2 <= ceilz+me.scale
			)
				dobonk = true
			end
		end
		
		if P_IsObjectInGoop(me)
			dobonk = false
		end
		
		if dobonk
			car.momz = -$*2 - (5*me.scale*takis.gravflip)
			local bam = SpawnBam(car)
			bam.scale = $/2
			bam.renderflags = $|RF_FLOORSPRITE
			S_StartSound(car,sfx_s3k49)
		end
	end
	
	--funny???
	if (gametype == GT_RACE
	or HAPPY_HOUR.othergt)
	or (TAKIS_NET.forcekart)
	or (takis.inSRBZ)
	or (extrastuff)
	--or (TAKIS_TUTORIALSTAGE and TAKIS_TUTORIALSTAGE <= 4)
	or (gametype == GT_SAXAMM)
		car.fuel = 100*FU
	end
	
	local dashpadflash = TR/3
	if p.dashpadtime
	and car.lastflashing == 0
	and (p.powers[pw_flashing] >= dashpadflash-1
	and p.powers[pw_flashing] <= dashpadflash+1)
		P_MoveOrigin(car,me.x,me.y,me.z)
		car.momx,car.momy = p.dashpadmom[1],p.dashpadmom[2]
		car.angle = p.dashpadmom[3]
		car.accel = car.basemaxspeed
		car.forceaccel = max($,2)
		car.speedpad = dashpadflash
	end
	
	if p.windcurrmom ~= nil
		local xmove = p.windcurrmom[1]
		local ymove = p.windcurrmom[2]
		if car.grounded
			xmove,ymove = $1/2, $2/2
		end
		--i hate this shit
		--xmove,ymove = $1/2, $2/2
		--car.momx,car.momy = $1 + xmove,$2 + ymove
		P_TryMove(car, car.x + xmove, car.y + ymove,true)
		
		if not grounded
			car.momx,car.momy = $1+xmove,$2+ymove
		end
	end
	
	--this fixes ramp sectors lol
	--local planez = (P_MobjFlip(me) == -1) and "ceilingheight" or "floorheight"
	--local heightdiff = abs(R_PointInSubsector(car.x+car.momx,car.y+car.momy).sector[planez] - me.subsector.sector[planez])
	local steppingup = true --LMAOO heightdiff > 0 and heightdiff <= 48*me.scale
	local telex = (me.subsector.sector.specialflags & SSF_DOUBLESTEPUP and P_IsObjectOnGround(me) and (not me.standingslope) and steppingup and me.z or me.x)
	local x,y = 	car.x-car.momx,	car.y-car.momy
	local x2,y2 = 	me.x - me.momx,me.y - me.momy
	if R_PointToDist2(x,y,x2,y2) > car.radius*INT8_MAX
	or (telex ~= me.x)
	or (me.reactiontime)
	or (me.justwarped == 0 and me.lastdoorcords.x ~= nil)
		P_MoveOrigin(car, me.x, me.y, GetActorZ(me,car,1))
		
		if (me.reactiontime)
		or (me.justwarped == 0 and me.lastdoorcords.x ~= nil)
			car.momx,car.momy,car.momz = 0,0,0
			car.angle = me.angle
			car.accel = 0
		end
		
		car.teletime = 3
	else
		P_MoveOrigin(me, car.x, car.y, GetActorZ(car,me,1))
	end
	
	if (car.teletime) then car.teletime = $-1 end
	
	--set the stuff for the player
	if p.ai
	or p.bot
		car.angle = me.angle
	end
	me.angle = car.angle
	--look behind
	--idk why this is so offset with different scales
	--srb2 jank i guess!?!?!?!?!?!?!??
	if p.cmd.buttons & BT_CUSTOM3
		local lookingangle = me.angle
		if car.drift ~= 0
			lookingangle = $ + ((ANGLE_45/5)*car.drift)
		end
		
		if car.viewaway == nil
			car.viewaway = P_SpawnMobjFromMobj(me,
				0, --me.momx+(FixedMul(185*me.scale,cos(lookingangle))),
				0, --me.momy+(FixedMul(185*me.scale,sin(lookingangle))),
				me.momz+(70*car.scale*P_MobjFlip(me)),
				MT_THOK
			)
			car.viewaway.flags = MF_NOCLIPTHING|MF_NOGRAVITY|MF_NOCLIPHEIGHT
			car.viewaway.tics,car.viewaway.fuse = -1,-1
			car.viewaway.flags2 = $|MF2_DONTDRAW
			car.viewaway.scale = me.scale
			P_TryMove(car.viewaway,
				me.x+(FixedMul(185*me.scale,cos(lookingangle))),
				me.y+(FixedMul(185*me.scale,sin(lookingangle))),
				true
			)
		end
		
		if (car.viewaway and car.viewaway.valid)
			local off = P_MobjFlip(me) == -1 and car.viewaway.height or 0
			car.viewaway.radius = 2*me.scale
			car.viewaway.height = 4*me.scale
			if R_PointToDist2(car.viewaway.x,car.viewaway.y, car.x,car.y) > 256*MAPSCALE
				P_SetOrigin(car.viewaway,
					me.x+(FixedMul(185*me.scale,cos(lookingangle))),
					me.y+(FixedMul(185*me.scale,sin(lookingangle))),
					car.viewaway.z
				)
			else
				P_TryMove(car.viewaway,
					me.x+(FixedMul(185*me.scale,cos(lookingangle))),
					me.y+(FixedMul(185*me.scale,sin(lookingangle))),
					true
				)
			end
			
			car.viewaway.z = me.z+(70*me.scale*P_MobjFlip(me)-off)
			car.viewaway.angle = R_PointToAngle2(car.viewaway.x,car.viewaway.y,me.x,me.y)
			car.viewaway.scale = me.scale
			p.awayviewmobj = car.viewaway
			p.awayviewtics = 2
		end
	else
		if car.viewaway and car.viewaway.valid
			P_RemoveMobj(car.viewaway)
			car.viewaway = nil
		end
	end
	if (TAKIS_NET.forcekart == false)
	and (TAKIS_TUTORIALSTAGE == 0)
		--KILL the car
		if (p.cmd.buttons & BT_CUSTOM2 and not car.inpain)
		or (car.fuel <= 0 and car.takiscar)
			p.inkart = 0
			--dismounting
			if (p.cmd.buttons & BT_CUSTOM2 and not car.inpain)
			and car.fuel > 0
				local scale = max(me.scale, FU*3/5)
				local newkart = P_SpawnMobjFromMobj(me,
					P_ReturnThrustX(nil,me.angle+ANGLE_90,64*scale),
					P_ReturnThrustY(nil,me.angle+ANGLE_90,64*scale),
					0,
					MT_TAKIS_KART
				)
				/*
				P_SetOrigin(car,
					me.x + P_ReturnThrustX(nil,me.angle+ANGLE_90,64*me.scale),
					me.y + P_ReturnThrustY(nil,me.angle+ANGLE_90,64*me.scale),
					me.z
				)
				*/
				newkart.scale = me.scale
				newkart.color = me.color
				newkart.fuel = car.fuel
				newkart.angle = car.angle
				if takis.kart.paidforkart
					newkart.owner = p
					takis.kart.mobj = newkart
					newkart.paidfor = true
				end
				me.state = S_PLAY_STND
				P_MovePlayer(p)
				P_RemoveMobj(car)
			--exploding
			else
				TakisFancyExplode(me,
					car.x, car.y, car.z,
					P_RandomRange(60,64)*car.scale,
					32,
					nil,
					15,20
				)
				P_MovePlayer(p)
				P_DoPlayerPain(p,car,car)
				P_SetObjectMomZ(me,15*me.scale)
				P_Thrust(me,car.angle,20*car.scale)
				P_MovePlayer(p)
				P_KillMobj(car)
				p.powers[pw_nocontrol] = 5
				takis.kart.paidforkart = false
				TakisKart_ChangeLicense(p,"crashes",1)
			end
			CarGenericEject(p)
			/*
			if p.powers[pw_carry] == CR_TAKISKART
				p.powers[pw_carry] = 0
			end
			p.pflags = $ &~(PF_JUMPED|PF_DRILLING)
			takis.HUD.lives.tweentic = 5*TR
			me.tracer = nil
			me.spritexoffset,me.spriteyoffset = 0,0
			p.charability,p.charability2 = skins[p.skin].ability,skins[p.skin].ability2
			p.charflags = skins[p.skin].flags
			*/
			return
		end
	end
	
	if car.hornwait then car.hornwait = $-1 end
	
	car.driftdiff = FixedAngle(AngleFixed($))--*4/5)
	if not car.inpain
		if (car.drift ~= 0)
			local driftmul = FixedDiv(car.drifttime*FU,TR/2*FU)
			driftmul = min($,FU)
			
			local drift = car.drift
			if car.drift < 0
				drift = -5 - car.drift
			elseif car.drift > 0
				drift = 5 - car.drift
			elseif car.drift == 0
				drift = 5
			end
			
			local ang = car.angle - ((ANGLE_45/5)*drift)
			p.drawangle = ang + FixedAngle(FixedMul(car.momt/2,driftmul))
		elseif (car.sliptidetilt ~= 0)
			local ang = FixedAngle(car.momt * 16/10)
			
			if car.sliptide ~= 0
				ang = FixedAngle(clamp(90*FU, AngleFixed(ang), 270*FU))
			end
			p.drawangle = car.angle + ang
			
			if (data.legacyframes == true)
				p.drawangle = $ - (ANGLE_45*car.sliptide)
			end
		else
			if car.driftrelease ~= 0
				p.drawangle = car.angle + ((ANGLE_45/5) * car.driftrelease)
				if abs(car.driftrelease) > 0
					if car.driftrelease < 0
						car.driftrelease = $+1
					elseif car.driftrelease > 0
						car.driftrelease = $-1
					end
				end
			else
				p.drawangle = FixedAngle(AngleFixed(car.angle)+AngleFixed(car.driftdiff))
			end
		end
	else
		p.drawangle = car.angle+FixedAngle(car.painspin)
	end
	if car.pogospring
		p.drawangle = car.angle+FixedAngle(car.painspin)
	end
	
	car.oldangle = car.angle
	car.olddlevel = TakisKart_DriftLevel(data.stats,car.driftspark)
	car.oldmomz = car.momz
	car.drawangle = $*4/5
	if customhud.CheckType("takis_kart_meters") == "takisthefox"
		if takis.firenormal == 1
			takis.HUD.lives.nokarthud = not $
		end
	else
		takis.HUD.lives.nokarthud = false
	end
	p.pflags = $|PF_DRILLING
	if grounded
	and me.skin == TAKIS_SKIN
		TakisKart_ChangeLicense(p,"miles",GetCarSpeed(car,CS_ACCEL)/10/FU)
	end
	
	for play in players.iterate
		if play == p then continue end
		
		if (play.spectator) then continue end
		if not (play.mo and play.mo.valid) then continue end
		local mo = play.mo
		
		if not P_IsObjectOnGround(mo) then continue end
		
		if ((not (car.eflags & MFE_VERTICALFLIP) and mo.z ~= car.z + car.height + car.scale))
		or (((car.eflags & MFE_VERTICALFLIP) and mo.z + mo.height ~= car.z - car.scale))
			continue
		end
		
		local blockdist = car.radius + mo.radius
		if (abs(car.x - mo.x) > blockdist)
		or (abs(car.y - mo.y) > blockdist)
			continue
		end
		
		P_TryMove(mo,
			mo.x + car.momx,
			mo.y + car.momy,
			true
		)
		mo.momz = car.momz
		
	end
	car.lastflashing = p.powers[pw_flashing]
	car.oldslope = car.standingslope
	if p.powers[pw_justlaunched] == 2
		car.momz = $*3/2
	end
	--
end,MT_TAKIS_KART_HELPER)

addHook("MobjRemoved",function(car)
	if (car.target and car.target.valid)
	and (car.target.player and car.target.player.valid)
		CarGenericEject(car.target.player)
	end
end,MT_TAKIS_KART_HELPER)

addHook("MobjDeath",function(car)
	local sfx = P_SpawnMobjFromMobj(car,0,0,0,MT_THOK)
	sfx.flags2 = $|MF2_DONTDRAW
	sfx.fuse,sfx.tics = TR,TR
	S_StartSound(sfx,sfx_tkapow)
	for i = 0,16
		A_BossScream(sfx,1,MT_SONIC3KBOSSEXPLODE)
	end
end,MT_TAKIS_KART_HELPER)

--misc stuff
addHook("ShouldDamage",function(me,i,s,_,dmgt)
	if not (me and me.valid) then return end
	if not extrastuff then return end
	if not (me.player.inkart) then return end
	if not (me.health) then return end
	--sectors only!
	if (i and i.valid) then return end
	if (s and s.valid) then return end
	--allow suicide
	if (dmgt & DMG_DEATHMASK) then return true end
	
	if InSectorSpecial(me,true,1,2)
	or InSectorSpecial(me,true,1,3)
	or InSectorSpecial(me,true,1,4)
		return false
	end
end,MT_PLAYER)

addHook("MobjThinker",function(mo)
	if not extrastuff then return end
	if TakisKart_ExtraStuff then return end
	if not (mo and mo.valid) then return end
	P_SpawnMobjFromMobj(mo,0,0,24*mo.scale,MT_RING)
	P_RemoveMobj(mo)
	return true
end,MT_SMASHINGSPIKEBALL)

addHook("LinedefExecute",function(line,mo,sec)
	if not mo.valid
	or not mo.health
	or not mo.player
	or not mo.player.valid
		return
	end
	
	local p = mo.player
	
	if p.inkart
		if (mo.tracer and mo.tracer.valid and mo.tracer.iskart)
			mo.tracer.fuel = 100*FU
		end
		return
	end
	if TakisKart_Karters[mo.skin] ~= true then return end
	if not P_IsValidSprite2(mo,SPR2_KART) then return end
	
	local kart = P_SpawnMobjFromMobj(mo,0,0,0,MT_TAKIS_KART_HELPER)
	kart.angle = mo.angle	
	kart.target = mo
	S_StartSound(kart,sfx_kartst)
	kart.fuel = 100*FU
	p.inkart = 2

end,"TAK_KART")

local function lineoffroad(line,mo,sec,strength)
	if not mo.valid
	or not mo.health
	or not mo.player
	or not mo.player.valid
		return
	end
	
	local p = mo.player
	
	if not p.inkart
		return
	end
	
	mo.tracer.lineoffroad = strength
end

addHook("LinedefExecute",function(line,mo,sec)
	lineoffroad(line,mo,sec,3)
end,"TAK_KOF3")
addHook("LinedefExecute",function(line,mo,sec)
	lineoffroad(line,mo,sec,4)
end,"TAK_KOF4")
addHook("LinedefExecute",function(line,mo,sec)
	lineoffroad(line,mo,sec,5)
end,"TAK_KOF5")

--red spring panel
addHook("LinedefExecute",function(line,me,sec)
	if not me.valid
	or not me.health
	or not me.player
	or not me.player.valid
		return
	end
	
	local p = me.player
	
	if not p.inkart
		return
	end
	
	local car = me.tracer
	
	local hscale = MAPSCALE + (MAPSCALE - me.scale)
	local minspeed = 24*hscale
	local pushangle = FixedHypot(car.momx,car.momy) and R_PointToAngle2(0,0,car.momx,car.momy) or me.angle
	
	if not (me.eflags & MFE_SPRUNG)
	and not car.pogospring
		if FixedMul(GetCarSpeed(car),me.scale) < minspeed
			P_InstaThrust(car,pushangle,minspeed)
		end
		DoPogoSpring(p,me,car,sec)
	end	
	
end,"TAK_RSPR")

--yellow spring panel
addHook("LinedefExecute",function(line,me,sec)
	if not me.valid
	or not me.health
	or not me.player
	or not me.player.valid
		return
	end
	
	local p = me.player
	
	if not p.inkart
		return
	end
	
	local car = me.tracer
	
	local hscale = MAPSCALE + (MAPSCALE - me.scale)
	local minspeed = 24*hscale
	local maxspeed = 28*hscale
	local pushangle = FixedHypot(car.momx,car.momy) and R_PointToAngle2(0,0,car.momx,car.momy) or me.angle

	if not (me.eflags & MFE_SPRUNG)
	and not car.pogospring
		if FixedMul(GetCarSpeed(car),me.scale) > maxspeed
			P_InstaThrust(car,pushangle,maxspeed)
		elseif FixedMul(GetCarSpeed(car),me.scale) < minspeed
			P_InstaThrust(car,pushangle,minspeed)
		end
		DoPogoSpring(p,me,car,sec)
	end
	
end,"TAK_YSPR")

--speed panel
addHook("LinedefExecute",function(line,me,sec)
	if not me.valid
	or not me.health
	or not me.player
	or not me.player.valid
		return
	end
	
	local p = me.player
	
	if not p.inkart
		return
	end
	
	local car = me.tracer
	
	car.linepanel = 1
end,"TAK_SPDP")

addHook("MapLoad",function(mapnum)
	if not extrastuff then return end
	local dontremove = mapheaderinfo[mapnum].forcedstepup ~= nil
	
	for sec in sectors.iterate
		if sec.special == 0 then continue end
		
		if sec.special == 28672
		or sec.specialflags & SSF_FORCESPIN
			sec.special = $|9 &~(28672)	--Ring Drainer (Floor Touch)
			sec.specialflags = $ &~SSF_FORCESPIN
		end
		
		if not dontremove
			if sec.specialflags & SSF_DOUBLESTEPUP
				sec.special = $ &~(13)
				sec.specialflags = $ &~SSF_DOUBLESTEPUP
			end
		end
	end
	
	for mt in mapthings.iterate
		if mt.type == 1488
			local egg = P_SpawnMobj(mt.x*FU,mt.y*FU,mt.z*FU,MT_EGGROBO1)
			egg.angle = FixedAngle(mt.angle*FU)
			P_RemoveMobj(mt.mobj)
		end
	end
end)

addHook("MobjMoveCollide",function(tm,t)
	if not (tm.player or ((t) and (t.valid)))
		return
	end
	
	--erm, again?
	if not (t and t.valid)
		return
	end
	
	local p = tm.player
	local takis = p.takistable
	
	if not (L_ZCollide(tm,t))
		return
	end
	
	if not (tm.tracer and tm.tracer.valid) then return end
	if tm.skin == TAKIS_SKIN then return end
	
	if not p.inkart
		if (p.pflags & PF_CANCARRY)
		and (t.iskart)
			return false
		end
		return
	end
	
	if takis
		
		if (t.type == MT_STEAM)
		and L_ZCollide(t,tm)
		and p.inkart
		and (tm.tracer and tm.tracer.valid)
			P_SetObjectMomZ(tm.tracer, 35*FU, false)
			tm.tracer.sprung = true
		--springs keep our momentum!
		--only horizontal springs
		elseif (t.flags & MF_SPRING)
		and L_ZCollide(t,tm)
			local twod = (tm.flags2 & MF2_TWOD or twodlevel)
			if p.inkart
			and (tm.tracer and tm.tracer.valid)
				local car = tm.tracer
				P_DoSpring(t,car)
				P_DoSpring(t,tm)
				--?
				if (takis.inWater)
					car.momz = $*12/10 --FixedDiv($,FU*3/5)
				end
				if (mobjinfo[t.type].damage ~= 0)
				and (mobjinfo[t.type].reactiontime == 0)
					car.angle = t.angle
					tm.angle = t.angle
					p.drawangle = t.angle
					car.tiregrease = 2*TR
				end
				car.sprung = true
				return
			end
			if ((mobjinfo[t.type].mass == 0) and (mobjinfo[t.type].damage ~= 0))
			and not twod
				
				P_DoSpring(t,tm)
				
				--P_InstaThrust(tm,t.angle,takis.prevspeed+mobjinfo[t.type].damage)
				tm.angle,p.drawangle = t.angle,t.angle
				tm.eflags = $|MFE_SPRUNG
				p.homing = 0
				
			end
		--kart stuff
		--run people over!
		elseif (t.type == MT_PLAYER)
		and ((t.player) and (t.player.valid))
		and (p.inkart)
		and L_ZCollide(t,tm)
		and (takis.accspeed >= 10*FU)
		and not t.player.inkart
			if CanPlayerHurtPlayer(p,t.player)
				P_DamageMobj(t,tm,tm,100)
				LaunchTargetFromInflictor(1,t,tm,63*tm.scale,takis.accspeed/5)
				P_Thrust(tm,p.drawangle,50*tm.scale)
				L_ZLaunch(t,P_RandomRange(5,15)*tm.scale,true)
				P_MovePlayer(t.player)
				
				SpawnBam(tm,true)
				
				S_StartSound(t,sfx_tsplat)
				S_StartSound(tm,sfx_smack)
			end
		elseif (t.type == MT_TAKIS_KART_HELPER)
		and (tm.tracer == t)
			return false
		end
		
	end
end,MT_PLAYER)

addHook("PlayerCanDamage", function(p, mobj)
	if not p.mo 
	or not p.mo.valid 
		return
	end
	
	if p.mo and p.mo.valid and p.mo.skin ~= TAKIS_SKIN
		if not p.takistable
			return
		end
		
		local me = p.mo
		local takis = p.takistable
		
		if (p.inkart)
			if L_ZCollide(me,mobj)
			and CanFlingThing(mobj)
				--prevent killing blow sound from mobjs way above/below us
				SpawnBam(mobj,true)
				
				--P_KillMobj(mobj, me, me) --actually kill the thing. looking at you, lance-a-bots!
				
				SpawnRagThing(mobj,me)
				if (me.state == S_PLAY_TAKIS_SLIDE)
					S_StartSound(me,sfx_smack)
				end
				if (takis.transfo & TRANSFO_BALL)
					S_StartSound(me,sfx_bowl)
				end
				S_StartSound(me,sfx_sdmkil)
				
				
			end
			return true
			
		end
	end
end)

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

local function kartpain(me,inf)
	local p = me.player
	spillrings(p)
	TakisKart_DoSpinout(p,inf)
end

addHook("MobjDamage", function(mo,inf,sor,_,dmgt)
	if not (mo and mo.valid)
		return
	end
	
	local p = mo.player 
	local takis = p.takistable

	if (p.powers[pw_carry] == CR_NIGHTSMODE)
		return
	end

	if p.deadtimer > 10
		return
	end
	
	if mo.skin == TAKIS_SKIN
		return
	end
	
	if p.inkart
		kartpain(mo,inf,sor)
		return true
	end
	
end,MT_PLAYER)

local prn = CONS_Printf
COM_AddCommand("restat", function(p,speed,weight)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if tonumber(speed) == nil
	or tonumber(weight) == nil
		prn(p,"restat <speed> <weight>")
		return
	end
	
	speed = abs(tonumber($))
	weight = abs(tonumber($))
	
	local function capstat(s)
		return max(1,min(9,s))
	end
	speed = capstat($)
	weight = capstat($)
	capstat = nil
	
	p.restat = {speed,weight}
	
	prn(p,"Restat'd to "..speed..", "..weight)
end)

COM_AddCommand("kartgear", function(p,gearnum)
	if gamestate ~= GS_LEVEL
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(gearnum) == nil
		prn(p,"kartgear <1-3>: Sets Takis Kart gear speed. 1st Gear is low speed, 3rd Gear is regular speed.")
		prn(p,"Current gear is: "..gamegear)
		return
	end
	
	gearnum = abs(tonumber($))
	
	local function capstat(s)
		return max(1,min(7,s))
	end
	gearnum = capstat($)
	capstat = nil
	
	gamegear = gearnum
	
	print("Kart gear has been set to "..gearnum)
end,COM_ADMIN)

addHook("MapThingSpawn",function(mo,mt)
	mo.fakekart = true
	mo.color = P_RandomRange(SKINCOLOR_LAVENDER + P_RandomRange(0,50),#skincolors - SKINCOLOR_SUPERSILVER1)
	
	if mt.args[0]
		local kw = clamp(1,mt.args[0],9)
		mo.kartweight = kw*FU
	end
	if mt.args[1]
		mo.facemom = true
	end
end,MT_TAKIS_KART)

addHook("NetVars",function(n)
	extrastuff = n($)
	MAPSCALE = n($)
	gamegear = n($)
	lastexplodes = n($)
	
	TakisKart_Karters = n($)
	TakisKart_KarterData = n($)
	TakisKart_ExtraSounds = n($)
	TakisKart_ExtraStuff = n($)
end)

TAKIS_FILESLOADED = $+1