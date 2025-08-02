/*	HEADER
	New misc file to reduce lag
	Mobj thinkers and stuff not directly related to takis
	
*/

local transtonum = {
	[FF_TRANS90] = 9,
	[FF_TRANS80] = 8,
	[FF_TRANS70] = 7,
	[FF_TRANS60] = 6,
	[FF_TRANS50] = 5,
	[FF_TRANS40] = 4,
	[FF_TRANS30] = 3,
	[FF_TRANS20] = 2,
	[FF_TRANS10] = 1,
	[0] = 0
}
local numtotrans = {
	[9] = FF_TRANS90,
	[8] = FF_TRANS80,
	[7] = FF_TRANS70,
	[6] = FF_TRANS60,
	[5] = FF_TRANS50,
	[4] = FF_TRANS40,
	[3] = FF_TRANS30,
	[2] = FF_TRANS20,
	[1] = FF_TRANS10,
	[0] = 0,
}

local function choose(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

local function enemyCollide(rag,found)
	local range = rag.radius*3/2
	if rag.type ~= MT_TAKIS_BADNIK_RAGDOLL
	or rag.bigbox
		range = 420*rag.scale
	end
	
	if not (found and found.valid) then return end
	if not (found.health) then return end
	--if not (L_ZCollide(rag,found)) then return end
	if not rag.bigbox
		if (rag.z > found.z + (found.height*3/2)) then return end
		if (rag.z + (rag.height*3/2) < found.z) then return end
	else
		if (rag.z > found.z + range) then return end
		if (rag.z + range < found.z) then return end		
	end
	if (R_PointToDist2(found.x, found.y, rag.x, rag.y) > range) then return end
	if (found.takis_nocollateral == true) then return end
	if (found.alreadykilledthis) then return end
	
	if CanFlingThing(found,MF_ENEMY|MF_BOSS,true)
		found.alreadykilledthis = true
		
		SpawnEnemyGibs(rag,found)
		SpawnBam(found,true)
		local sfx = P_SpawnGhostMobj(found)
		sfx.flags2 = $|MF2_DONTDRAW
		S_StartSound(sfx,sfx_smack)
		SpawnRagThing(found,rag,rag.parent2)
	elseif (SPIKE_LIST[found.type] == true)
	and (found.takis_nocollateral ~= true)
		found.alreadykilledthis = true
		P_KillMobj(found,rag,rag.parent2)
	end
	if (rag and rag.valid)
	and (rag.parent2 and rag.parent2.valid)
		rag.parent2.player.scoreadd = 0
	end
end

local function FollowThink(mo)
	TakisFollowThingThink(mo,mo.tracer)
end

--after image
addHook("MobjThinker", function(ai)
	if not (ai and ai.valid) then return end
	if not (ai.target and ai.target.valid) then P_RemoveMobj(ai); return end
	
	local p = ai.target.player
	if not (p and p.valid)
		p = consoleplayer
	end
	local me = p.mo 
	
	--bruh
	if not (me and me.valid) then P_RemoveMobj(ai); return end
	
	--ai.frame = ai.takis_frame|FF_TRANS30
	
	ai.colorized = true
	if not ai.timealive
		ai.timealive = 1	
	else
		ai.timealive = $+1
	end
	
	ai.spritexoffset = ai.takis_spritexoffset or 0
	ai.spriteyoffset = ai.takis_spriteyoffset or 0
	ai.spritexscale = ai.takis_spritexscale or FU
	ai.spriteyscale = ai.takis_spriteyscale or FU
	ai.rollangle = ai.takis_rollangle or 0
	ai.pitch = ai.takis_pitch or 0
	ai.roll = ai.takis_roll or 0
	
	if not ai.old
		local transnum = numtotrans[((ai.timealive*2/3)+1) %9]
		ai.frame = ai.takis_frame|transnum
	else
		if (leveltime % 6) > 3
			ai.frame = ai.takis_frame
		else
			ai.frame = ai.takis_frame|FF_TRANS30
		end
	end
	
	ai.takis_vfx = true
	if ai.timealive ~= 1
		if TakisShouldIHideInFP(ai,p)
			ai.flags2 = $|MF2_DONTDRAW
		else
			ai.flags2 = $ &~MF2_DONTDRAW
		end
	end
	
	if ai.timealive > 5
		P_RemoveMobj(ai)
		p.takistable.afterimagecount = $-1
		return
	end
	
end, MT_TAKIS_AFTERIMAGE)

addHook("MobjThinker", function(rag)
	if not (rag and rag.valid)
		return
	end
	
	local intwod = (rag.flags2 & MF2_TWOD or twodlevel)
	
	rag.speed = abs(FixedHypot(rag.momx,rag.momy))
	rag.timealive = $+1
	if not (rag.timealive % 3)
	and not (TAKIS_NET.noeffects)
		local aa = P_SpawnMobjFromMobj(rag,0,0,rag.height/2,MT_THOK)
		aa.state = S_TAKIS_BADNIK_RAGDOLL_A
		aa.color = SKINCOLOR_KETCHUP
	end
	
	--do hitboxes
	if (TAKIS_NET.collaterals and not intwod)
		--make hitting stuff more generous
		/*
		local oldbox = {rag.radius,rag.height}
		rag.radius,rag.height = $1*2, $2*2
		
		local oldpos = {rag.x,rag.y,rag.z}
		P_SetOrigin(rag,oldpos[1],oldpos[2],
			oldpos[3]-(rag.height/2*P_MobjFlip(rag))
		)
		*/
		local px = rag.x
		local py = rag.y
		local br = 100*rag.scale
		--local range = rag.radius--*5/2 --FixedDiv(rag.radius*5/2,2*FU)
		searchBlockmap("objects", enemyCollide, rag, px-br, px+br, py-br, py+br)
		/*
		rag.radius,rag.height = unpack(oldbox)
		P_SetOrigin(rag,oldpos[1],oldpos[2],oldpos[3])
		*/
	end
	--
	
	rag.angle = $-ANG10
	if rag.speed == 0
	or ((P_IsObjectOnGround(rag)) and (rag.timealive > 4))
		SpawnEnemyGibs(nil,rag)
		
		if P_IsObjectOnGround(rag)
		and P_RandomChance(FU/2)
			P_SetObjectMomZ(rag,10*FU)
			local bam1 = SpawnBam(rag)
			bam1.renderflags = $|RF_FLOORSPRITE
			return
		end
		SpawnBam(rag,true)
		
		TakisFancyExplode(rag.parent2,
			rag.x, rag.y, rag.z,
			P_RandomRange(60,64)*rag.scale,
			32,
			nil,
			15,20
		)
			
		/*
		for i = 0, 34
			A_BossScream(rag,1,MT_SONIC3KBOSSEXPLODE)
		end
		*/
		
		local rad = 1200*rag.scale
		for p in players.iterate
			
			local m2 = p.realmo
			
			if not m2 or not m2.valid
				continue
			end
			
			if (FixedHypot(m2.x-rag.x,m2.y-rag.y) <= rad)
				DoQuake(p,
					FixedMul(
						100*FU, FixedDiv( rad-FixedHypot(m2.x-rag.x,m2.y-rag.y),rad )
					),
					17
				)
			end
		end
		
		--collaterals
		if (TAKIS_NET.collaterals and not intwod)
			local px = rag.x
			local py = rag.y
			local br = 420*rag.scale
			
			local helper = P_SpawnGhostMobj(rag)
			helper.flags2 = $|MF2_DONTDRAW
			helper.fuse = 5
			helper.parent2 = rag.parent2
			helper.bigbox = true
			searchBlockmap("objects", enemyCollide,
				/*
				if found and found.valid
				and (found.health)
				and (found.takis_nocollateral ~= true)
					if CanFlingThing(found,MF_ENEMY|MF_BOSS,true)
						SpawnRagThing(found,helper,helper.parent2)
					elseif (SPIKE_LIST[found.type] == true)
					and (found.takis_nocollateral ~= true)
						P_KillMobj(found,helper,helper.parent2)
					end
					rag.parent2.player.scoreadd = 0
				end
				*/
			helper, px-br, px+br, py-br, py+br)		
		end

		local f = P_SpawnGhostMobj(rag)
		f.flags2 = $|MF2_DONTDRAW
		f.fuse = 2*TR
		S_StartSound(f,sfx_tkapow)
		--wtfsonic
		if (f.sprite == SPR_PLAY)
			local dead = P_SpawnMobjFromMobj(f,0,0,0,MT_THOK)
			
			dead.fuse = -1
			dead.tics = 3*TR
			dead.flags = MF_NOCLIP|MF_NOCLIPHEIGHT
			
			dead.sprite = SPR_PLAY
			dead.skin = f.skin
			dead.color = f.color
			dead.frame = A
			dead.sprite2 = SPR2_DEAD
			dead.isFUCKINGdead = true
			dead.colorized = f.colorized
			P_SetObjectMomZ(dead,14*FU)

		end
		P_RemoveMobj(rag)
		
	end
end, MT_TAKIS_BADNIK_RAGDOLL)

addHook("MobjThinker",function(gib)
	if not (gib and gib.valid) then return end
	
	local grav = P_GetMobjGravity(gib)
	grav = $*3/5
	gib.momz = $+(grav*P_MobjFlip(gib))
	
	if not TAKIS_NET.noeffects
		gib.rollangle = $+(gib.angleroll or 0)
	end
	
	gib.speed = FixedHypot(gib.momx,gib.momy)
	gib.angle = $+gib.angleadd
	
	if (P_IsObjectOnGround(gib)
	and not gib.bounced)
		if not gib.iwillbouncetwice
			gib.flags = $|MF_NOCLIPHEIGHT|MF_NOCLIP
			gib.bounced = true
			gib.tics = 3*TR
			L_ZLaunch(gib,
				(gib.lessbounce and P_RandomRange(2,4) or P_RandomRange(4,9))
				*FU+P_RandomFixed()
			)
		else
			gib.iwillbouncetwice = nil
			gib.lessbounce = true
			L_ZLaunch(gib,P_RandomRange(6,9)*FU+P_RandomFixed())
		end
	end
end,MT_TAKIS_GIB)

addHook("MobjMoveBlocked",function(gib)
	if gib.flags & MF_NOCLIP then return end
	if gib.bounced then return end
	P_BounceMove(gib)
	gib.angle = FixedAngle(AngleFixed($)+180*FU)
end,MT_TAKIS_GIB)

--thinker to make it independant of state actions
addHook("MobjThinker",FollowThink,MT_TAKIS_SWEAT)
addHook("MobjThinker",FollowThink,MT_SOAP_SUPERTAUNT_FLYINGBOLT)

addHook("MobjThinker",function(mo)
	if not (mo and mo.valid)
		return
	end
	
	if not (mo.target and mo.target.valid)
		P_KillMobj(mo)
		return
	end
	
	local p = mo.target.player
	local me = p.mo
	local takis = p.takistable
	
	mo.timealive = takis.tauntjointime
	
	if mo.timealive >= TR*3/2
		mo.frame = ($ &~FF_FRAMEMASK)|B
	end
	
	if not TakisIsScreenPlayer(p)
		mo.flags2 = $|MF2_DONTDRAW
	else
		mo.flags2 = $ &~MF2_DONTDRAW
	end
	
	if me.eflags & MFE_VERTICALFLIP
		mo.eflags = $|MFE_VERTICALFLIP
		P_MoveOrigin(mo,
			me.x,
			me.y,
			(me.z + me.height - mo.height) - (me.height)
		)
	elseif (me and me.valid)
		P_MoveOrigin(mo,
			me.x,
			me.y,
			me.z+(me.height)
		)
	end	
	
end,MT_TAKIS_TAUNT_JOIN)

addHook("MobjThinker",function(gem)
	local tics = {6,16}
	if not (gem and gem.valid) then return end
	
	if not (gem.soda and gem.soda.valid)
	and (gem.health)
		gem.soda = P_SpawnMobjFromMobj(gem,0,0,5*gem.scale*P_MobjFlip(gem),MT_THOK)
		gem.soda.wait = P_RandomRange(unpack(tics))
	elseif (gem.soda and gem.soda.valid)
		local soda = gem.soda
		if (displayplayer
		and displayplayer.valid
		and skins[displayplayer.skin].name == TAKIS_SKIN)
			gem.flags2 = $|MF2_DONTDRAW
			soda.flags2 = $ &~MF2_DONTDRAW
		else
			gem.flags2 = $ &~MF2_DONTDRAW
			soda.flags2 = $|MF2_DONTDRAW
		end
		
		gem.shadowscale = gem.scale*3
		gem.circle = FixedAngle( ((2*FU)*3/2)*leveltime)
		local z = sin(gem.circle)*12
		soda.spriteyoffset = 3*FU+z
		soda.tics,soda.fuse = -1,-1
		soda.color = gem.color
		soda.sprite = SPR_TMIS
		soda.frame = G|(gem.frame &~FF_FRAMEMASK)
		if soda.wait == 0
			soda.wait = P_RandomRange(unpack(tics))
			local spark = P_SpawnMobjFromMobj(soda,0,0,soda.spriteyoffset,MT_SUPERSPARK)
			spark.destscale = 0
			spark.angle = FixedAngle(P_RandomRange(0,360)*FU)
			P_Thrust(spark,spark.angle,P_RandomRange(1,5)*soda.scale)
			P_SetObjectMomZ(spark,P_RandomRange(-5,5)*FU)
			if (displayplayer
			and displayplayer.valid
			and skins[displayplayer.skin].name == TAKIS_SKIN)
				spark.flags2 = $ &~MF2_DONTDRAW
			else
				spark.flags2 = $|MF2_DONTDRAW
			end
		else
			soda.wait = $-1
		end
	end
end,MT_EMBLEM)

addHook("MobjThinker",function(s)
	if not (s and s.valid) then return end
	if not (s.target and s.target.valid) then return end
	
	if s.target.skin == TAKIS_SKIN
		local p = s.target.player
		local takis = p.takistable
		
		if not (TAKIS_NET.nerfarma)
			
			if not (leveltime % 2)
				local rad = s.radius/FRACUNIT
				local hei = s.height/FRACUNIT
				local x = P_RandomRange(-rad,rad)*FRACUNIT
				local y = P_RandomRange(-rad,rad)*FRACUNIT
				local z = P_RandomRange(0,hei)*FRACUNIT
				local spark = P_SpawnMobjFromMobj(s,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
				spark.tracer = s.target
				spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
				spark.blendmode = AST_ADD
				spark.color = P_RandomRange(SKINCOLOR_SALMON,SKINCOLOR_KETCHUP)
				spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))
				spark.momz = P_RandomRange(0,4)*s.scale*takis.gravflip
				P_Thrust(spark,spark.angle,P_RandomRange(1,5)*s.scale)
			end
			
			local trans = 0
			trans = choose(FF_TRANS10,FF_TRANS20,FF_TRANS30,FF_TRANS40,
				FF_TRANS50,FF_TRANS60,FF_TRANS70,FF_TRANS80,FF_TRANS90)
			
			if (displayplayer and displayplayer.valid)
			and not displayplayer.takistable.io.flashes
				trans = 0
			end
			s.frame = $|trans
			s.tracer.frame = $|trans
		end
	end
end,MT_ARMAGEDDON_ORB)

addHook("BossThinker", function(mo)
	if not mo.health
	and mo.aTakisFUCKINGkilledME
		if mo.isFUCKINGdeadtimer == nil
			mo.isFUCKINGdeadtimer = 0
		else
			mo.isFUCKINGdeadtimer = $+1
		end
		
		if mo.isFUCKINGdeadtimer < 5
		and (mo.isFUCKINGdeadtimer % 3) == 0
			TakisFancyExplode(mo.takisThatFUCKINGkilledMe,
				mo.x, mo.y, mo.z,
				P_RandomRange(60,64)*mo.scale,
				16,
				nil,
				15,20
			)
			S_StartSound(mo,sfx_tkapow)
		end
		
		if mo.isFUCKINGdeadtimer <= TR*3/2
		and (mo.isFUCKINGdeadtimer % 3) == 0
			local rad = mo.radius*2/mo.scale
			local height = mo.height*2/mo.scale
			local thok = P_SpawnMobjFromMobj(mo,
				P_RandomRange(-rad,rad)*mo.scale,
				P_RandomRange(-rad,rad)*mo.scale,
				P_RandomRange(-height/2,height*3/2)*mo.scale,
				MT_THOK
			)
			SpawnBam(thok,true)
			P_RemoveMobj(thok)
		end
	end
	
	if TAKIS_BOSSCARDS.bossprefix[mo.type] == nil then return end
	
	if (mo.target and mo.target.valid)
	and (mo.target.player and mo.target.player.valid)
		mo.p_target = mo.target
	end
	
end)

addHook("MobjThinker",function(drone)
	if not (drone and drone.valid)
		return
	end
	
	if not (maptol & TOL_NIGHTS)
		return
	end
	
	if not (drone.flags & MF_NOGRAVITY)
	and drone.hadnograv
	and not multiplayer
		local coolp = server
		local i = 0
		for p in players.iterate
			if i == 0
				coolp = p
			end
			
			if (skins[p.skin].name ~= TAKIS_SKIN)
				return
			end
			i = $+1
		end
		--only on the final mare
		if coolp.mare ~= #TAKIS_NET.ideyadrones-1
			return
		end
		HH_Trigger(drone,coolp,coolp.nightstime)
		S_StartSound(drone,sfx_mclang)
		coolp.mo.angle = coolp.drawangle
		NiGHTSFreeroam(coolp)
	end
	
	drone.hadnograv = drone.flags & MF_NOGRAVITY
end,MT_EGGCAPSULE)

addHook("MobjThinker",function(fling)
	if not (fling and fling.valid) then return end
	fling.momz = $+(P_GetMobjGravity(fling)*P_MobjFlip(fling))
	
	TakisSpawnDust(fling,
		FixedAngle( P_RandomRange(-337,337)*FRACUNIT ),
		10,
		P_RandomRange(0,(fling.height/fling.scale)/2)*fling.scale,
		{
			xspread = 0,
			yspread = 0,
			zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
			
			thrust = 0,
			thrustspread = 0,
			
			momz = P_RandomRange(10,-5)*fling.scale,
			momzspread = 0,
			
			scale = fling.scale/2,
			scalespread = P_RandomFixed(),
			
			fuse = 20,
		}
	)

	/*
	if not (leveltime % 5)
		local dust = P_SpawnMobjFromMobj(fling,0,0,fling.height/2,MT_SPINDUST)
		dust.scale = FixedMul(2*FU,fling.scale)
		dust.destscale = fling.scale/4
		dust.scalespeed = FU/4
		dust.fuse = 10
	end
	if (fling.momz*P_MobjFlip(fling) < -10*fling.scale)
		fling.rollangle = $+FixedAngle(fling.momz*P_MobjFlip(fling))
	else
		fling.rollangle = $-FixedAngle(10*fling.scale)
	end
	*/
	
end,MT_TAKIS_FLINGSOLID)

addHook("MobjThinker",function(mo)
	if not (mo and mo.valid)
		return
	end
	
	if not (mo.tracer and mo.tracer.valid)
		P_RemoveMobj(mo)
		return
	end
	
	if mo.scale == mo.destscale
		P_RemoveMobj(mo)
		return
	end
	
	mo.startfuse = $ or 20
	mo.timealive = $+1
	if (mo.startfuse - mo.timealive) <= 10
		if mo.scalespeed == 0
			mo.scalespeed = mo.startscale/20
		end
		mo.scalespeed = $*6/5
	else
		mo.scalespeed = 0
	end
	
	mo.takis_vfx = true
	if TakisShouldIHideInFP(mo,mo.tracer.player)
		mo.flags2 = $|MF2_DONTDRAW
	else
		mo.flags2 = $ &~MF2_DONTDRAW
	end
	
	local mul = FU*19/22
	
	/*
	if (mo.eflags & MFE_UNDERWATER|MFE_TOUCHWATER == MFE_UNDERWATER|MFE_TOUCHWATER)
	and not (mo.eflags & MFE_TOUCHLAVA)
		mo.tics = -1
		mo.frame = A
		mo.sprite = SPR_BUBL
		mo.frame = D
		mo.rollangle = 0
		mul = $/2
	else
		if mo.sprite == SPR_BUBL
			P_RemoveMobj(mo)
			return
		end
	end
	*/
	
	mo.momx,mo.momy,mo.momz = FixedMul($1,mul),FixedMul($2,mul),FixedMul($3,mul)
end,MT_TAKIS_STEAM)

addHook("MobjSpawn",function(metal)
	if not (metal and metal.valid) then return end
	if (mapheaderinfo[gamemap].takis_rakisreplay == nil) then return end
	
	local thok = P_SpawnMobjFromMobj(metal,0,0,0,MT_THOK)
	thok.tics = -1
	thok.fuse = -1
	thok.flags2 = $|MF2_DONTDRAW
	thok.metalhelper = true
	thok.metal = metal
	
	table.insert(TAKIS_NET.metalsonics,{
		metal = metal,
		helper = thok
	})
end,MT_METALSONIC_RACE)

addHook("MobjThinker",function(metal)
	if not (metal and metal.valid) then return end
	if (mapheaderinfo[gamemap].takis_rakisreplay == nil) then return end
	
	metal.sprite = SPR_PLAY
	metal.skin = TAKIS_SKIN
	
	local hasrakis = false
	for p in players.iterate
		if p.spectator then continue end
		
		if (skins[p.skin].name == TAKIS_SKIN)
		and p.skincolor == SKINCOLOR_SALMON
			hasrakis = true
		end
		
	end
	
	if hasrakis
		metal.color = SKINCOLOR_SILVER
		metal.colorized = true
	else
		metal.color = SKINCOLOR_SALMON
		metal.colorized = false
	end
	
	
	if (mapheaderinfo[gamemap].takis_rakisach == nil) then return end
	
	for p in players.iterate
		if skins[p.skin].name ~= TAKIS_SKIN
			continue
		end
		
		if not (p.takistable)
			continue
		end
		
		if (p.takistable.achfile & ACHIEVEMENT_RAKIS)
			continue
		end
		
		TakisAwardAchievement(p,ACHIEVEMENT_RAKIS)
		
	end

end,MT_METALSONIC_RACE)

--starposts refill combo bar
local function StarpostAvail(post,touch)
	if touch.skin ~= TAKIS_SKIN
		return false
	end

	if touch.player.starpostnum < post.health
		return false
	end
	
	return true
end

addHook("MobjSpawn", function(post)
	post.activators = {
		cards = {},
		combo = {},
		cardsrespawn = {},
		comborespawn = {},
		first = {},
	}
end, MT_STARPOST)

local function docards(post,touch)
	if not StarpostAvail(post,touch) then return end
	
	local p = touch.player
	local takis = p.takistable
	
	if takis.heartcards == TAKIS_MAX_HEARTCARDS
		return
	end
	
	post.activators.cards[touch] = true
	
	if CV_FindVar("respawnitem").value
	and (splitscreen or multiplayer)
		local time = CV_FindVar("respawnitemtime").value * TICRATE
		post.activators.cardsrespawn[touch] = time
	else
		post.activators.cardsrespawn[touch] = -1
	end	
	
	TakisHealPlayer(p,touch,takis,2)
	S_StartSound(post,sfx_takhel,p)
	takis.HUD.statusface.happyfacetic = 3*TR/2
	
end
local function docombo(post,touch)
	if not StarpostAvail(post,touch) then return end

	local p = touch.player
	local takis = p.takistable
	
	if not takis.combo.time
		return
	end
	
	post.activators.combo[touch] = true
	
	if CV_FindVar("respawnitem").value
	and (splitscreen or multiplayer)
		local time = CV_FindVar("respawnitemtime").value * TICRATE
		post.activators.comborespawn[touch] = time
	else
		post.activators.comborespawn[touch] = -1
	end	
	
	TakisGiveCombo(p,takis,false,true)
	S_StartSound(post,sfx_ptchkp,p)
	

end

addHook("TouchSpecial", function(post,touch)
	local p = touch.player
	local takis = p.takistable
	
	--thanks amperbee
	if not post.activators.cards[touch]
		
		if not (post.activators.cards[touch]) 
			docards(post,touch)
		end
	end
	if not post.activators.combo[touch]
		if not (post.activators.combo[touch]) 
			docombo(post,touch)
		end
	end
	if not post.activators.first[touch]
	and not circuitmap
		if not (post.activators.first[touch]) 
			takis.HUD.menutext.tics = 3*TR+9
			
			TakisSpawnPongler(post,
				R_PointToAngle2(touch.x,touch.y,
					post.x,post.y
				)
			)
			post.activators.first[touch] = true
			S_StartSound(post,sfx_ponglr)
		end
	end
	
end, MT_STARPOST)

addHook("MobjThinker",function(me)
	if not me
	or not me.valid
		return
	end
	
	if me.activators == nil
	or (HAPPY_HOUR.time == 1)
		if HAPPY_HOUR.time == 1
			me.activators.cards = {}
			me.activators.combo = {}
			me.activators.cardsrespawn = {}
			me.activators.comborespawn = {}
			--dont set first field
		else
			me.activators = {
				cards = {},
				combo = {},
				cardsrespawn = {},
				comborespawn = {},
				first = {},
			}
		end
		return
	end
	
	for k,v in pairs(me.activators.cardsrespawn)
		if v == nil
			continue
		end
		
		if v > 0
			if v > CV_FindVar("respawnitemtime").value*TICRATE
				v = CV_FindVar("respawnitemtime").value*TICRATE
			end
			
			me.activators.cardsrespawn[k] = $-1
			
			if (HAPPY_HOUR.time == 1)
				me.activators.cardsrespawn[k] = 0
			end
		elseif v == 0
		and (me.activators.cards[k] ~= false)
			me.activators.cards[k] = false
			table.remove(me.activators.cardsrespawn,me.activators.cardsrespawn[k])
			S_StartSound(me,sfx_sprcar)
			
			local g = P_SpawnMobjFromMobj(me,0,0,me.height/4,MT_THOK)
			g.sprite = SPR_HTCD
			g.frame = A
			g.tics = TR
			g.blendmode = AST_ADD
			g.scale = FixedMul(me.scale,2*FU)
			g.destscale = FixedDiv(me.scale,4*FU)
		end
	end

	for k,v in pairs(me.activators.comborespawn)
		if v == nil
			continue
		end
		
		if v > 0
			if v > CV_FindVar("respawnitemtime").value*TICRATE
				v = CV_FindVar("respawnitemtime").value*TICRATE
			end
			
			me.activators.comborespawn[k] = $-1
			
			if (HAPPY_HOUR.time == 1)
				me.activators.comborespawn[k] = 0
			end
		elseif v == 0
		and (me.activators.combo[k] ~= false)
			me.activators.combo[k] = false
			table.remove(me.activators.comborespawn,me.activators.comborespawn[k])
			S_StartSound(me,sfx_sprcom)

			local g = P_SpawnMobjFromMobj(me,0,0,me.height/4,MT_THOK)
			g.sprite = SPR_CMBB
			g.frame = A
			g.tics = TR
			local scale =  FU/2
			g.spritexscale = scale
			g.spriteyscale = scale
			g.blendmode = AST_ADD
			g.scale = FixedMul(me.scale,2*FU)
			g.destscale = FixedDiv(me.scale,4*FU)
		end
	end
	
	local br = 215*me.scale
	
	for p in players.iterate
		if p and p.valid
		and p.realmo.health
		and P_CheckSight(me,p.realmo)
				
			if p.realmo.skin ~= TAKIS_SKIN
				continue
			end
			
			if p.starpostnum < me.health
				continue
			end
			
			local dx = me.x-p.realmo.x
			local dy = me.y-p.realmo.y
			
			if FixedHypot(dx,dy) > br
				continue
			end
			
			--thanks Monster Iestyn for this!
			if (p and p == displayplayer)
				local found = p.realmo
				
				local facingang = R_PointToAngle(me.x,me.y)
				
				/*
				local x,y = ReturnTrigAngles(R_PointToAngle2(me.x,me.y, camera.x,camera.y))
				if not camera.chase
					x,y = ReturnTrigAngles(R_PointToAngle2(me.x,me.y, found.x,found.y))
				end
				if found.flags2 & MF2_TWOD
				or twodlevel
					x,y = ReturnTrigAngles(InvAngle(R_PointToAngle(found.x,found.y)))
				end
				*/
				
				--card
				local card = P_SpawnMobjFromMobj(me,
					P_ReturnThrustX(nil,facingang,-64*me.scale),
					P_ReturnThrustY(nil,facingang,-64*me.scale),
					me.height/4+(FU*10),
					MT_UNKNOWN
				)
				card.sprite = SPR_HTCD
				card.tics = 2		
				if me.activators.cards[found] == true
					card.frame = B|FF_TRANS50
				else
					card.frame = A
				end
				
				card.frame = $|FF_PAPERSPRITE
				card.angle = facingang + ANGLE_90
				
				/*
				if found.flags2 & MF2_TWOD
				or twodlevel
					card.angle = (R_PointToAngle(me.x,me.y))-ANGLE_90
				else
					if camera.chase
						card.angle = (R_PointToAngle2(me.x,me.y, camera.x,camera.y))-ANGLE_90
					else
						card.angle = (R_PointToAngle2(me.x,me.y, found.x,found.y))-ANGLE_90					
					end
				end
				*/
				P_SetOrigin(card, card.x,card.y,card.z)
				--

				--combo
				local combo = P_SpawnMobjFromMobj(me,
					P_ReturnThrustX(nil,facingang,-64*me.scale),
					P_ReturnThrustY(nil,facingang,-64*me.scale),
					me.height/4-(FU*10),
					MT_UNKNOWN
				)
				combo.sprite = SPR_CMBB
				combo.tics = 2		
				if me.activators.combo[found] == true
					combo.frame = B|FF_TRANS50
				else
					combo.frame = A
				end
				local scale =  FU/2
				combo.spritexscale = scale
				combo.spriteyscale = scale
				
				combo.frame = $|FF_PAPERSPRITE
				combo.angle = facingang + ANGLE_90
				
				/*
				if found.flags2 & MF2_TWOD
				or twodlevel
					combo.angle = (R_PointToAngle(me.x,me.y))-ANGLE_90
				else
					if camera.chase
						combo.angle = (R_PointToAngle2(me.x,me.y, camera.x,camera.y))-ANGLE_90
					else
						combo.angle = (R_PointToAngle2(me.x,me.y, found.x,found.y))-ANGLE_90
					end
				end
				*/
				P_SetOrigin(combo, combo.x,combo.y,combo.z)
				--
			end
		end
	end
	
end,MT_STARPOST)

addHook("MobjThinker",function(pong)
	if not (pong and pong.valid) then return end
	
	local timealive = (states[S_TAKIS_PONGLER].tics+1)-(pong.tics)
	
	local circle = FixedAngle( (5*FU)*timealive )
	pong.spritexoffset = sin(circle)*12
	
	if timealive <= 10
		if pong.scalespeed == 0
			pong.scalespeed = FU/20
		end
		pong.scalespeed = $*6/5
		if timealive <= 8
			pong.frame = (pong.frame & FF_FRAMEMASK)|numtotrans[9-timealive]
		else
			pong.frame = (pong.frame & FF_FRAMEMASK)
		end
		pong.flags2 = $|MF2_DONTDRAW
	elseif timealive >= (states[S_TAKIS_PONGLER].tics+1)-9
		pong.destscale = 0
		if pong.scalespeed == 0
			pong.scalespeed = FU/20
		end
		pong.scalespeed = $*6/5
		
		if timealive >= (states[S_TAKIS_PONGLER].tics+1)-9
			local trans = timealive-((states[S_TAKIS_PONGLER].tics+1)-9)
			pong.frame = (pong.frame & FF_FRAMEMASK)|numtotrans[trans]
		end
	else
		pong.frame = (pong.frame & FF_FRAMEMASK)
		pong.destscale = 0
		pong.scalespeed = 0
	end
	
end,MT_TAKIS_PONGLER)

--chaos emeralds are replaced with spirits
local emeraldslist = {
	[0] = SKINCOLOR_GREEN,
	[1] = SKINCOLOR_SIBERITE,
	[2] = SKINCOLOR_SAPPHIRE,
	[3] = SKINCOLOR_SKY,
	[4] = SKINCOLOR_TOPAZ,
	[5] = SKINCOLOR_FLAME,
	[6] = SKINCOLOR_SLATE,
}

addHook("MobjThinker",function(gem)
	if not (gem and gem.valid) then return end
	if emeraldslist[gem.emeralddex] == nil then P_RemoveMobj(gem) return end
	
	local me = gem.tracer
	
	if not (me and me.valid) then P_RemoveMobj(gem) return end
	
	if not gem.camefromemerald
		local die = false
		if HAPPY_HOUR.gameover
		or not me.health
			die = true
		end
		
		if not die
			--assume we've just spawned
			if not gem.emeraldcolor
				gem.emeraldcolor = emeraldslist[gem.emeralddex]
				--never let spirits overlap
				if gem.emeralddex ~= 0
				and (me.player.takistable.spiritlist and
					me.player.takistable.spiritlist[gem.emeralddex-1])
					gem.timealive = me.player.takistable.spiritlist[gem.emeralddex-1].timealive--+((360/7)*gem.emeralddex)
				end
			end
			gem.frame = TakisFetchSpiritFrame(gem.emeralddex,true)
			gem.color = gem.emeraldcolor
			if gem.timealive == nil
				gem.timealive = 0
			else
				gem.timealive = $+1
			end
			local extraang = 0
			if me.player.powers[pw_carry] == CR_NIGHTSMODE
				extraang = R_PointToAngle(gem.x,gem.y)
			end
			gem.circle = extraang+FixedAngle( ((2*FU)*3/2)*gem.timealive )
			gem.circle = $+(FixedAngle(FixedDiv(333*FU,7*FU)*gem.emeralddex+1))
			
			local x,y = cos(gem.circle),sin(gem.circle)
			local z = sin(gem.circle)*12
			P_MoveOrigin(gem,
				me.x + 30*x,
				me.y + 30*y,
				GetActorZ(me,gem,1) + z + (7*gem.scale)
			)
			
			gem.angle = gem.circle+ANGLE_90
			if not camera.chase
				gem.flags2 = $|MF2_DONTDRAW
			else
				gem.flags2 = $ &~MF2_DONTDRAW
			end
			
		else
			if gem.flags & MF_NOGRAVITY
				gem.circle = $ or gem.angle-ANGLE_90
				S_StartSound(gem,sfx_shldls)
				P_SetObjectMomZ(gem,6*FU)
				P_Thrust(gem,gem.circle+ANGLE_90,2*gem.scale)
				gem.flags = $ &~MF_NOGRAVITY
			end
		end
	else
		if not gem.emeraldcolor
			gem.emeraldcolor = emeraldslist[gem.emeralddex]
		end
		gem.color = gem.emeraldcolor
		if gem.timealive == nil
			gem.timealive = 0
		else
			gem.timealive = $+1
		end
		
		gem.circle = FixedAngle( ((2*FU)*3/2)*gem.timealive )
		
		local z = sin(gem.circle)*12
		gem.spriteyoffset = 3*FU+z
		
		if (displayplayer
		and displayplayer.valid)
		and (displayplayer.realmo and displayplayer.realmo.valid)
			if skins[displayplayer.skin].name == TAKIS_SKIN
				gem.flags2 = $ &~MF2_DONTDRAW
				gem.angle = R_PointToAngle2(gem.x,gem.y,
					displayplayer.realmo.x,
					displayplayer.realmo.y
				)
			else
				gem.flags2 = $|MF2_DONTDRAW
			end
		end
	end
end,MT_TAKIS_SPIRIT)

--gotemeralds to spirits
addHook("MobjThinker",function(gem)
	if not (gem and gem.valid) then return end
	if emeraldslist[gem.frame & FF_FRAMEMASK] == nil then return end
	if not G_IsSpecialStage(gamemap) then return end
	
	if not gem.emeraldcolor
		gem.emeraldcolor = emeraldslist[gem.frame & FF_FRAMEMASK]
	end
	local soda = P_SpawnMobjFromMobj(gem,0,0,0,MT_TAKIS_SPIRIT)
	soda.tracer = gem.target
	soda.emeralddex = gem.frame & FF_FRAMEMASK
	soda.shadowscale = soda.scale*3
	gem.target.player.takistable.spiritlist[soda.emeralddex] = soda
	P_RemoveMobj(gem)
	
	return
end,MT_GOTEMERALD)

--Easier to read if this is kept here and not makestuff.lua
--collectable emeralds change into spirits and back
local function emeraldcollectspirit(gem)
	if not (gem and gem.valid) then return end
	if emeraldslist[gem.frame & FF_FRAMEMASK] == nil then return end
	if G_RingSlingerGametype() then return end
	
	if not gem.emeraldcolor
		gem.emeraldcolor = emeraldslist[gem.frame & FF_FRAMEMASK]
	end
	if not (gem.soda and gem.soda.valid)
	and (gem.health)
		gem.soda = P_SpawnMobjFromMobj(gem,0,0,5*gem.scale*P_MobjFlip(gem),MT_TAKIS_SPIRIT)
		local soda = gem.soda
		soda.tracer = gem
		soda.emeralddex = gem.frame & FF_FRAMEMASK
		soda.camefromemerald = true
		soda.shadowscale = soda.scale*3
	elseif (gem.soda and gem.soda.valid)
		if (displayplayer
		and displayplayer.valid
		and skins[displayplayer.skin].name == TAKIS_SKIN)
			gem.flags2 = $|MF2_DONTDRAW
		else
			gem.flags2 = $ &~MF2_DONTDRAW
		end
		
		gem.soda.frame = TakisFetchSpiritFrame(gem.soda.emeralddex,true)
		if not gem.health
			gem.soda.tracer = nil
		end
	end
end

local emeraldtypes = {
	MT_EMERALD1,
	MT_EMERALD2,
	MT_EMERALD3,
	MT_EMERALD4,
	MT_EMERALD5,
	MT_EMERALD6,
	MT_EMERALD7
}
for _,type in ipairs(emeraldtypes)
	addHook("MobjThinker",emeraldcollectspirit,type)
end

addHook("MobjThinker",function(drone)
	if not (drone and drone.valid) then return end
	
	if not (drone.exitsign and drone.exitsign.valid)
		local d = P_SpawnMobjFromMobj(drone,0,0,100*drone.scale,MT_THOK)
		d.sprite = SPR_TMIS
		d.frame = A
		d.tics = -1
		d.fuse = -1
		drone.exitsign = d
	end
	if not (drone.exitrow1 and drone.exitrow1.valid)
		local d = P_SpawnMobjFromMobj(drone,0,0,15*drone.scale,MT_THOK)
		d.sprite = SPR_TMIS
		d.frame = C
		d.renderflags = $|RF_PAPERSPRITE
		d.tics = -1
		d.fuse = -1
		drone.exitrow1 = d
	end
	if not (drone.exitrow2 and drone.exitrow2.valid)
		local d = P_SpawnMobjFromMobj(drone,0,0,15*drone.scale,MT_THOK)
		d.sprite = SPR_TMIS
		d.frame = C
		d.renderflags = $|RF_PAPERSPRITE
		d.tics = -1
		d.fuse = -1
		drone.exitrow2 = d
	end
	
	local ticker = (leveltime/2 % 2)
	if (displayplayer and displayplayer.valid)
	and (skins[displayplayer.skin].name == TAKIS_SKIN)
		local takis = displayplayer.takistable
		
		if takis
		and takis.io.flashes == 0
			ticker = 0
		end
	end
	
	if drone.timealive == nil
		drone.timealive = 0
	else
		drone.timealive = $+1
	end
	drone.circle = FixedAngle( (5*FU)*drone.timealive )
	
	if (drone.exitsign and drone.exitsign.valid)
		drone.exitsign.frame = D+ticker
		if not HAPPY_HOUR.happyhour
			drone.exitsign.flags2 = $|MF2_DONTDRAW
		else
			drone.exitsign.flags2 = $ &~MF2_DONTDRAW
		end
	end
	if (drone.exitrow1 and drone.exitrow1.valid)
		drone.exitrow1.frame = B+ticker
		drone.exitrow1.angle = drone.circle
		drone.exitrow1.spriteyoffset = sin(drone.circle)*12
		if not HAPPY_HOUR.happyhour
			drone.exitrow1.flags2 = $|MF2_DONTDRAW
		else
			drone.exitrow1.flags2 = $ &~MF2_DONTDRAW
		end
	end
	if (drone.exitrow2 and drone.exitrow2.valid)
		drone.exitrow2.frame = B+ticker
		drone.exitrow2.angle = drone.circle+ANGLE_90
		drone.exitrow2.spriteyoffset = sin(drone.circle)*12
		if not HAPPY_HOUR.happyhour
			drone.exitrow2.flags2 = $|MF2_DONTDRAW
		else
			drone.exitrow2.flags2 = $ &~MF2_DONTDRAW
		end
	end
	TAKIS_NET.dronepos = {drone.x,drone.y,drone.z}
end,MT_NIGHTSDRONE)

--easier for me if i keep this as a thinker LOL
addHook("MobjThinker",function(fet)
	if not (fet and fet.valid) then return end
	if (P_IsObjectOnGround(fet)) then P_RemoveMobj(fet); return end
	
	--this is awesome CHRISPYCHARS CODE!!!
	local flip = P_MobjFlip(fet)
	
	fet.momx = FixedMul($, fet.info.mass)
	fet.momy = FixedMul($, fet.info.mass)
	if not (fet.flags & MF_NOGRAVITY)
		fet.momz = FixedMul($, fet.info.mass)
		local maxfall = -FixedMul(fet.info.speed, fet.scale)
		if flip*fet.momz < maxfall
			fet.momz = flip*FixedMul(flip*$, fet.info.mass)
			if flip*fet.momz > maxfall
				fet.momz = flip*maxfall
				fet.flags = $ | MF_NOGRAVITY
			end
		end
	end
	fet.angle = $+(ANG15*fet.rngspin)
	fet.rollangle = $+(ANG15*fet.rngspin)
end,MT_TAKIS_FETTI)

addHook("MobjThinker",function(th)
	if not (th and th.valid) then return end
	
	if th.coolscalespeed == nil
		th.coolscalespeed = th.scalespeed
		th.scalespeed = 0
	end
	
	
	th.lastmomz = $ or 0
	if th.timealive == nil
		th.timealive = 0
	else
		th.timealive = $+1
	end
	local momx,momy = th.momx-th.fmomx,th.momy-th.fmomy
	th.angle = TakisMomAngle(th)
	th.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0,0,momx,momy), th.momz*P_MobjFlip(th))
	--th.momz = $+(P_GetMobjGravity(th)*2*P_MobjFlip(th))
	th.spritexscale,th.spriteyscale = FU*3/2,FU*3/2
	
	if P_IsObjectOnGround(th)
		if P_RandomChance(FU/2)
		and (th.lastmomz*P_MobjFlip(th)) <= -5*th.scale
		and (not th.bouncedup)
			P_SetObjectMomZ(th,-
				FixedDiv(
					FixedDiv(th.lastmomz,th.scale),
					2*FU+(P_RandomFixed()*(P_RandomChance(FU/2) and 1 or -1))
				)
			)
			th.bouncedup = true
		end
	end
	
	if th.isrealspark
		th.color = SKINCOLOR_ORANGE
		local tics = max(8-(th.timealive/4),0)
		if tics > 4
		and tics <= 6
			th.color = SKINCOLOR_APRICOT
		elseif tics > 2
		and tics <= 4
			th.color = SKINCOLOR_LEMON
		elseif tics <= 2
			th.color = SKINCOLOR_WHITE
		end
	end
	
	th.frame = ($ &~FF_FRAMEMASK)|H+P_RandomRange(0,2)
	if th.tics <= 9
		th.scalespeed = th.coolscalespeed
		--th.frame = $|numtotrans[10-th.tics]
	end
	
	if FixedHypot(th.momx,th.momy) == 0
		P_BounceMove(th)
		th.angle = $+ANGLE_180
		P_Thrust(th,th.angle,2*th.scale)
	end
	th.lastmomz = th.momz
	
end,MT_TAKIS_SPARK)

addHook("MobjThinker",function(wind)
	if not (wind and wind.valid) then return end
	
	local halftics = states[wind.info.spawnstate].tics/2
	if wind.tics <= halftics
		wind.spritexscale = $+FixedDiv(FU,halftics*FU)
		wind.spriteyscale = $-FixedDiv(FU,halftics*FU)
		
		wind.spritexscale = max($,1)
		wind.spriteyscale = max($,1)
		
		wind.spritexoffset = $+FixedDiv(FU,halftics*FU)
		wind.spriteyoffset = $+FixedDiv(10*FU,halftics*FU)
		
	end
end,MT_TAKIS_WINDLINE)

TAKIS_FILESLOADED = $+1