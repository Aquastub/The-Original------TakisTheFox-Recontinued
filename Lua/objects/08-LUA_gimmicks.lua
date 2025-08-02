/*	HEADER
	Funny stupid SRB2K gimmicks
	
*/

SafeFreeslot("MT_TAKIS_BOMBLMAO")
SafeFreeslot("S_TAKIS_BOMBLMAO")
states[S_TAKIS_BOMBLMAO] = {
	sprite = SPR_PLAY,
	frame = A|FF_FULLBRIGHT,
	action = function(mo)
		mo.color = 1
		mo.skin = TAKIS_SKIN
		mo.sprite = SPR_PLAY
		mo.sprite2 = SPR2_KART
	end,
	tics = -1,
}
mobjinfo[MT_TAKIS_BOMBLMAO] = {
	doomednum = -1,
	spawnstate = S_TAKIS_BOMBLMAO,
	spawnhealth = 1,
	height = 48*FRACUNIT,
	radius = 24*FRACUNIT,
	speed = 80*FRACUNIT,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_SPECIAL|MF_RUNSPAWNFUNC,
	mass = 100,
}

SafeFreeslot("MT_TAKIS_BUMPERLMAO")
SafeFreeslot("S_TAKIS_BUMPERLMAO")
states[S_TAKIS_BUMPERLMAO] = {
	sprite = SPR_TMIS,
	frame = G|FF_FULLBRIGHT,
	tics = -1,
}
mobjinfo[MT_TAKIS_BUMPERLMAO] = {
	doomednum = -1,
	spawnstate = S_TAKIS_BUMPERLMAO,
	painstate = S_TAKIS_BUMPERLMAO,
	spawnhealth = 4,
	damage = 1,
	activesound = sfx_s3k96,
	height = 32*FRACUNIT,
	radius = 45*FRACUNIT,
	speed = 128*FRACUNIT,
	flags = MF_SPECIAL|MF_SLIDEME,
	mass = 100,
}


-- https://github.com/STJr/Kart-Public/blob/44b4a6852858eebba5f9f50da2ac9f4b2889ad1a/src/p_enemy.c#L193
--rubberbanding on this one is a bit harsh but thats the whole point
addHook("MobjThinker",function(spb)
	if not (spb and spb.valid) then return end
	
	spb.succ = true
	spb.skin = TAKIS_SKIN
	spb.sprite2 = SPR2_KART
	spb.color = TakisKart_DriftColor(5)
	local desiredspeed = FixedMul(spb.myspeed,spb.scale)
	local wspeed = desiredspeed
	local xyspeed = desiredspeed
	local zspeed = desiredspeed
	local hang,vang,dist
	local cx,cy = 0,0
	local targ = spb.target
	if targ == nil
	or not (targ and targ.valid and targ.health)
		if #TAKIS_NET.scoreboard == 0
			P_KillMobj(spb)
			return
		end
		for k,v in ipairs(TAKIS_NET.scoreboard)
			if v and v.realmo and v.realmo.valid and v.realmo.health
				spb.target = v.realmo
				break
			end
		end
		targ = spb.target
	end
	local p = targ.player
	targ.spbtarg = spb
	
	if targ.pizza_in or targ.pizza_out
		return true
	end
	
	if (targ and targ.health and not (p and p.spectator))
		local defspeed = wspeed
		local range = FixedDiv(100*targ.scale,FixedDiv(spb.myspeed,48*FU))
		local spark = ((10-9)+4)/2
		local easiness = ((9+(10-spark)) << FRACBITS)/2
		
		spb.flags = $ &~MF_NOCLIPTHING
		
		if p
			local fracmax = 32
			
			defspeed = FixedMul(((fracmax+1)<<FRACBITS) - easiness, (148+36)<<14)/fracmax
			
			cx,cy = p.cmomx,p.cmomy
		end
		
		dist = P_AproxDistance(P_AproxDistance(spb.x - targ.x, spb.y - targ.y), spb.z - targ.z)
		
		wspeed = FixedMul(defspeed, FU + FixedDiv(dist-range, range))
		if (wspeed < defspeed)
			wspeed = defspeed;
		end
		if (wspeed > 3*defspeed)
			wspeed = 3*defspeed;
		end
		if (wspeed < 30*targ.scale)
			wspeed = 30*targ.scale;
		end
		if (p.pflags & PF_SLIDING)
			wspeed = p.speed/2;		
		end
		
		hang = R_PointToAngle2(spb.x,spb.y, targ.x,targ.y)
		vang = R_PointToAngle2(0,spb.z, dist, targ.z)
		
		if wspeed > spb.cvmem
			spb.cvmem = $+(wspeed - spb.cvmem)/TR
		else
			spb.cvmem = wspeed
		end
		
		local input = hang - spb.angle
		local invert = (AngleFixed(input) > 180*FU)
		if invert
			input = InvAngle($)
		end
		
		xyspeed = FixedMul(spb.cvmem, max(0, (((195<<FRACBITS) - AngleFixed(input))/90)-FU))
		
		input = FixedAngle(AngleFixed(input)/4)
		if invert
			input = InvAngle($)
		end
		
		spb.angle = $+input
		
		input = vang - spb.movedir
		invert = (AngleFixed(input) > 180*FU)
		if invert
			input = InvAngle($)
		end
		
		zspeed = FixedMul(spb.cvmem, max(0, (((195<<FRACBITS) - AngleFixed(input))/90)-FU))
		input = FixedAngle(AngleFixed(input)/4)
		if invert
			input = InvAngle($)
		end
		
		spb.movedir = $+input
	end
	spb.momx = cx+FixedMul(FixedMul(xyspeed,cos(spb.angle)),cos(spb.movedir))
	spb.momy = cy+FixedMul(FixedMul(xyspeed,sin(spb.angle)),cos(spb.movedir))
	spb.momz = FixedMul(zspeed,sin(spb.movedir))
	
	if spb.viewaway == nil
	or not (spb.viewaway and spb.viewaway.valid)
		spb.viewaway = P_SpawnMobjFromMobj(spb,-100*cos(spb.angle),-100*sin(spb.angle),80*spb.scale,MT_THOK)
		spb.viewaway.angle = spb.angle
		spb.viewaway.flags2 = MF2_DONTDRAW
		spb.viewaway.fuse,spb.viewaway.tics = -1,-1
	else
		spb.viewaway.angle = spb.angle
		spb.viewaway.flags2 = MF2_DONTDRAW
		spb.viewaway.fuse,spb.viewaway.tics = -1,-1
		P_MoveOrigin(spb.viewaway,
			spb.x-150*cos(spb.angle)+spb.momx,
			spb.y-150*sin(spb.angle)+spb.momy,
			spb.z+70*spb.scale+spb.momz
		)
		if spb.tracer.player.spectator
			spb.tracer.player.awayviewmobj = spb.viewaway
			spb.tracer.player.awayviewtics = 1
		end
	end
	
	if not S_SoundPlaying(spb,sfx_kc64)
		S_StartSound(spb,sfx_kc64)
	end
	
	local waveforce = FixedDiv(FixedHypot(FixedHypot(spb.momx,spb.momy),spb.momz),spb.scale)/FU+5
	spb.spriteyoffset = FixedMul(4*FU,sin(FixedAngle(leveltime*waveforce*FU)))
	spb.shadowscale = FU-(FixedDiv(spb.spriteyoffset,16*FU))
	TakisDoWindLines(spb,spb.momz,spb.color)
	
	local frame = A
	
	if abs((AngleFixed(hang) - AngleFixed(spb.angle))*2) >= 12*FU
		if not S_SoundPlaying(spb,sfx_kartdr)
			S_StartSoundAtVolume(spb,sfx_kartdr,255/2)
		end
		
		local sign = 0
		if ((AngleFixed(hang) - AngleFixed(spb.angle))*2) > 0
			frame = K
			sign = 1
		else
			frame = M
			sign = $-2
		end
		spb.angle = $+(45*FU*sign)
	else
		S_StopSoundByID(spb,sfx_kartdr)
	end
	
	local cang = -(hang - spb.angle)*2
	local viewang = R_PointToAngle(spb.x,spb.y)
	local angledelta = spb.angle - viewang
	local rolladd = FixedMul(cang,sin(abs(angledelta))) +
					FixedMul(cang,cos(angledelta))
	spb.rollangle = rolladd
	spb.frame = ($ &~FF_FRAMEMASK)|(frame+(leveltime % 2))

	if (CV_FindVar("renderer").value == 2
	and CV_FindVar("gr_models").value)
		return
	end
	
	local gh = P_SpawnGhostMobj(spb)
	gh.colorized = true
	gh.blendmode = AST_ADD
	
	
end,MT_TAKIS_BOMBLMAO)

addHook("TouchSpecial",function(spb,th)
	if not (spb and spb.valid) then return end
	if not (th and th.valid) then return true end
	
	local tracer = (gametype ~= GT_SAXAMM) and spb.tracer or nil
	
	if (th.health)
	and CanFlingThing(th,MF_ENEMY|MF_BOSS)
		P_KillMobj(th,spb,tracer)
		return true
	elseif (th.player)
		if (spb.target == th)
			--i'll destroy you to death
			P_DamageMobj(th,spb,tracer,DMG_INSTAKILL)
			if (spb and spb.valid)
				P_KillMobj(th,spb,tracer)
				P_RemoveMobj(spb.viewaway)
			end
		else
			P_DamageMobj(th,spb,tracer)
			return true
		end
	end
	
end,MT_TAKIS_BOMBLMAO)

addHook("ShouldDamage",function(spb,_,_,_,dmgt)
	if not (spb and spb.valid) then return end
	
	if dmgt == DMG_DEATHPIT
		return false
	end
end,MT_TAKIS_BOMBLMAO)
addHook("MobjDeath",function(spb,_,_,_,dmgt)
	if not (spb and spb.valid) then return end
	
	if dmgt == DMG_DEATHPIT
		return true
	end
end,MT_TAKIS_BOMBLMAO)
addHook("MobjRemoved",function(spb)
	if not (spb and spb.valid) then return end
	
	return true
end,MT_TAKIS_BOMBLMAO)

addHook("TouchSpecial",function(drop,me)
	if not (drop and drop.valid) then return end
	if not (me and me.valid) then return end
	if (me.eflags & MFE_SPRUNG) then return true; end
	
	local strength = 0
	local p = me.player
	local takis = p.takistable
	
	if (drop.health <= 0 or me.health <= 0)
		return true
	end
	
	strength = 140
	
	P_Thrust(drop,R_PointToAngle2(drop.x,drop.y, me.x,me.y),strength*me.scale)
	
	local bumppower = FU
	do
		local speeddamp = FixedDiv(takis.accspeed, 2*p.runspeed)
		bumppower = ease.inquad(
			min(speeddamp,FU),
			FU,
			3*FU*4
		)
		
	end
	drop.health = $-1
	
	if drop.health == 3
		drop.color = SKINCOLOR_LIME
	elseif drop.health == 2
		drop.color = SKINCOLOR_GOLD
	elseif drop.health == 1
		drop.color = SKINCOLOR_CRIMSON
	end
	
	S_StartSound(me,P_RandomRange(sfx_takbn1,sfx_takbn3))
	
	if (p.inkart)
		P_Thrust(me.tracer,
			R_PointToAngle2(me.x,me.y,drop.x,drop.y),
			-FixedMul(FixedHypot(drop.momx,drop.momy) + FixedHypot(me.momx,me.momy),FU) --bumppower)
		)
	end
	
	P_Thrust(me,
		R_PointToAngle2(me.x,me.y,drop.x,drop.y),
		-FixedMul(FixedHypot(drop.momx,drop.momy) + FixedHypot(me.momx,me.momy),FU) --bumppower)
	)
	P_InstaThrust(drop,
		R_PointToAngle2(me.x,me.y,drop.x,drop.y),
		FixedMul(FixedHypot(drop.momx,drop.momy) + FixedHypot(me.momx,me.momy),FU)/2 --bumppower)
	)
	me.momz = -$
	me.eflags = $|MFE_SPRUNG
	
	drop.flags = drop.info.flags
	
	local b1,b2 = SpawnBam(drop,true)
	
	b1.colorized = true
	b1.color = SKINCOLOR_WHITE
	b2.colorized = true
	b2.color = SKINCOLOR_WHITE
	
	if drop.health == 0
		P_RemoveMobj(drop)
	end
	return true
	
end,MT_TAKIS_BUMPERLMAO)
addHook("MobjThinker",P_ButteredSlope,MT_TAKIS_BUMPERLMAO)
addHook("MobjMoveBlocked",function(drop,mo,line)
	P_BounceMove(drop)
end,MT_TAKIS_BUMPERLMAO)

TAKIS_FILESLOADED = $+1