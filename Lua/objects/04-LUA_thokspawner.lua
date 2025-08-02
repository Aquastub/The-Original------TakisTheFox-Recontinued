/*	HEADER
	Placeholder MT_THOK mainly used for respawning objects
	
*/

local function afterimage(th,me)
	if not me
	or not me.valid
		return
	end
	
	local models = CV_FindVar("gr_models").value
	
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
	
	ghost.angle = me.angle
	
	local color = SKINCOLOR_GREEN
	
	--not everyone is salmon
	local salnum = #skincolors[ColorOpposite(me.color)]
	if (consoleplayer and consoleplayer.valid)
	--laggy model? dont color shift if it is!
	and not (models and consoleplayer.takistable.io.laggymodel and CV_FindVar("renderer").value == 2)
		th.afterimagecolor = $+1
		if (th.afterimagecolor > #skincolors-1-salnum)
			th.afterimagecolor = 1
		end
	end
	color = salnum+th.afterimagecolor
	
	if G_GametypeHasTeams()
		color = me.color-1
	end
	ghost.blendmode = AST_ADD
	
	ghost.color = color
	ghost.takis_spritexscale,ghost.takis_spriteyscale = me.spritexscale, me.spriteyscale
	ghost.takis_spritexoffset,ghost.takis_spriteyoffset = me.spritexoffset, me.spriteyoffset
	ghost.takis_rollangle = me.rollangle
	ghost.takis_pitch = me.pitch
	ghost.takis_roll = me.roll
	
	return ghost
end

--car is assumed to be the thok mobj
local function soundhandle(car,data)
	
	local numsounds = TakisKart_ExtraSounds and 13 or 6
	
	local closedist = 160*FU
	local fardist = 1536*FU
	
	local dampenval = 48
	
	local class,s,w = 0,0,0
	
	local volume = 255
	local voldamp = FU
	
	local targetsnd = 0
	
	local kartspeed = data.stats[1]
	local kartweight = data.stats[2]
	s = (kartspeed-1)/3
	w = (kartweight-1)/3
	if s < 0 then s = 0 end
	if s > 2 then s = 2 end
	if w < 0 then w = 0 end
	if w > 2 then w = 2 end
	
	class = s+(3*w)
	
	if leveltime < 8 -- or p.exiting
		car.enginesound = 0
		return
	end
	
	local doreturn = false
	if TakisKart_ExtraSounds
		doreturn = (leveltime % 8)
	else
		if S_SoundPlaying(car,sfx_karte0)
		or S_SoundPlaying(car,sfx_karte1)
		or S_SoundPlaying(car,sfx_karte2)
		or S_SoundPlaying(car,sfx_karte3)
		or S_SoundPlaying(car,sfx_karte4)
		or S_SoundPlaying(car,sfx_karte5)
			doreturn = true
		end
	end
	
	if doreturn --(leveltime % 8)
		return
	end
	
	local cmdmove = 0 --(6*abs(car.moving))/25	
	local speedthing = GetCarSpeed(car)/FU/20
	targetsnd = (cmdmove+speedthing)/2
	--clamp
	targetsnd = max(0,min(numsounds-1,targetsnd))
	
	if car.enginesound < targetsnd then car.enginesound = $+1 end
	if car.enginesound > targetsnd then car.enginesound = $-1 end
	car.enginesound = max(0,min(numsounds-1,car.enginesound))
	
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
	if not TakisKart_ExtraSounds then class = 0; volume = $/2 end
	S_StartSoundAtVolume(car,startingsound+car.enginesound+(class*numsounds),volume)
	
end

--thok respawns stuff for us
addHook("MobjThinker",function(th)
	if not (th and th.valid) then return end
	
	if (th.camefromcard)
		
		th.flags2 = $|MF2_DONTDRAW
		--tic respawn timer
		if (th.respawntime)
			if th.respawntime > CV_FindVar("respawnitemtime").value * TICRATE
			and not th.cardhadspecial
				th.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
			end
			th.tics,th.fuse = -1,-1
			th.respawntime = $-1
		else
			local card = P_SpawnMobjFromMobj(th,0,0,0,MT_TAKIS_HEARTCARD)
			card.spawnflags = th.cardflags
			card.spawnedfrommt = true
			if th.cardhadambush
				card.cardhadambush = th.cardhadambush
				card.flags = $|MF_NOGRAVITY
			end
			if th.cardhadspecial
				card.cardhadspecial = th.cardhadspecial
			end
			if th.cardtime ~= nil
				card.cardtime = th.cardtime
			end
			P_RemoveMobj(th)
		end
	elseif (th.camefromcrate)
		th.flags2 = $|MF2_DONTDRAW
		--tic respawn timer
		if (th.respawntime)
			if th.respawntime > CV_FindVar("respawnitemtime").value * TICRATE
				th.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
			end
			th.tics,th.fuse = -1,-1
			th.respawntime = $-1
		else
			local card = P_SpawnMobjFromMobj(th,0,0,0,MT_TAKIS_HEARTCRATE)
			card.scale = th.scale*7/5
			card.destscale = th.scale
			card.angle = th.angle
			card.spawnpos = th.spawnpos
			P_RemoveMobj(th)
		end
	elseif (th.camefromsolid)
		th.flags2 = $|MF2_DONTDRAW
		--tic respawn timer
		if (th.respawntime)
			if th.respawntime > CV_FindVar("respawnitemtime").value * TICRATE
				th.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
			end
			if (th.respawntime <= TR)
				if not (th.respawntime % 2)
					th.state = th.solid.state
					th.flags2 = $ &~MF2_DONTDRAW
				else
					th.state = S_THOK
				end
			end
			
			th.angle = th.solid.angle
			th.tics,th.fuse = -1,-1
			th.respawntime = $-1
		else
			local s = th.solid
			local new = P_SpawnMobj(s.pos[1],s.pos[2],s.pos[3],s.type)
			new.flags = s.flags
			new.flags2 = s.flags2
			new.angle = s.angle
			new.scale = s.scale
			new.color = s.color
			
			P_RemoveMobj(th)
		end	
	elseif th.isFUCKINGdead
		local grav = P_GetMobjGravity(th)
		grav = $
		th.momz = $+(grav*P_MobjFlip(th))
	elseif th.isakartspark
		th.prevmomz = $ or th.momz
		if th.timealive == nil
			th.timealive = 0
		else
			th.timealive = $+1
		end
		th.sprite = SPR_THND
		th.spritexscale,th.spriteyscale = FU,FU
		th.angle = TakisMomAngle(th)
		th.rollangle = R_PointToAngle2(0, 0, TakisMomAngle(th), th.momz)

		if P_IsObjectOnGround(th)
			if P_RandomChance(FU/2)
			and (th.prevmomz*P_MobjFlip(th)) <= -5*th.scale
			and not th.bouncedup
				P_SetObjectMomZ(th,-
					FixedDiv(
						FixedDiv(th.prevmomz,th.scale),
						2*FU+(P_RandomFixed()*(P_RandomChance(FU/2) and 1 or -1))
					)
				)
				th.bouncedup = true
			else
				P_RemoveMobj(th)
				return
			end
		end
		th.frame = G|FF_FULLBRIGHT|FF_PAPERSPRITE
		local maxiter = 2
		local momx = th.momx/(maxiter*2)
		local momy = th.momy/(maxiter*2)
		local momz = th.momz/(maxiter*2)
		for i = 0,maxiter-1
			local posx,posy,posz = 0,0,0
			posx = momx*i
			posy = momy*i
			posz = momz*i
			local angle = th.angle
			local spark = P_SpawnMobjFromMobj(th,
				posx,
				posy,
				posz,
				MT_THOK
			)
			local lifetime = 8
			spark.scale = th.scale
			spark.angle = angle
			spark.spritexscale,spark.spriteyscale = th.spritexscale,th.spriteyscale
			spark.blendmode = th.blendmode
			spark.tics,spark.fuse = lifetime,lifetime
			spark.color = th.color
			spark.destscale = 0
			spark.scalespeed = $*2
			spark.sprite = th.sprite
			spark.frame = th.frame
			if th.isrealspark
				spark.camefromspark = true
			end
		end
		th.prevmomz = th.momz
	elseif th.camefromspark
		if th.tics > 4
		and th.tics <= 6
			th.color = SKINCOLOR_APRICOT
		elseif th.tics > 2
		and th.tics <= 4
			th.color = SKINCOLOR_LEMON
		elseif th.tics <= 2
			th.color = SKINCOLOR_WHITE
		end
	--try to make rakis act like a player
	elseif th.metalhelper
		local metal = th.metal
		local accspeed = FixedDiv(abs(FixedHypot(metal.momx,metal.momy)), metal.scale)
		
		--print(L_FixedDecimal(accspeed))
		
		th.clutching = $ or 0
		th.last = $ or {
			sprite = SPR2_STND,
			frame = A,
			momz = 0,
			grounded = false,
		}
		th.hammerblastdown = $ or 0
		th.afterimagecolor = $ or 0
		
		P_SetOrigin(th,metal.x,metal.y,metal.z)
		
		if (metal.state == S_PLAY_WALK
		or metal.sprite2 == SPR2_WALK
		or metal.state == S_PLAY_DASH
		or metal.sprite2 == SPR2_DASH)
		--and not takis.dontfootdust
		and (metal.sprite2 ~= SPR2_KART)
			local frame = metal.frame & FF_FRAMEMASK
			local dostep = false
			
			if (metal.state == S_PLAY_WALK
			or metal.sprite2 == SPR2_WALK)
				dostep = ((frame == A) or (frame == E))
			else
				dostep = ((frame == A) or (frame == C))
			end
			
			if dostep
				if not th.z
					local sfx = P_RandomRange(sfx_takst1,sfx_takst3)
					
					S_StartSoundAtVolume(th,sfx_takst0,255/2)
					S_StartSound(th,sfx)
					th.steppedthisframe = true
					TakisSpawnDust(metal,
						metal.angle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
						P_RandomRange(0,-10),
						P_RandomRange(-1,2)*metal.scale+P_RandomFixed(),
						{
							xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
							zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = 0,
							thrustspread = 0,
							
							momz = 0,
							momzspread = 0,
							
							scale = metal.scale*4/5,
							scalespread = 0,--(P_RandomFixed()/4*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = 15+P_RandomRange(-2,3),
						}
					)
					
				end
			else
				th.steppedthisframe = false
			end
		else
			th.steppedthisframe = false
		end
		
		if (metal.sprite2 == SPR2_DASH)
			if th.last.sprite ~= SPR2_DASH
				S_StartSound(th,sfx_cltch3)
				
				local d1 = P_SpawnMobjFromMobj(metal, -20*cos(metal.angle + ANGLE_45), -20*sin(metal.angle + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
				local d2 = P_SpawnMobjFromMobj(metal, -20*cos(metal.angle - ANGLE_45), -20*sin(metal.angle - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
				d1.angle = R_PointToAngle2(metal.x, metal.y, d1.x, d1.y) --- ANG5
				d2.angle = R_PointToAngle2(metal.x, metal.y, d2.x, d2.y) --+ ANG5
				
				for j = -1,1,2
					for i = 3,P_RandomRange(5,10)
						TakisKart_SpawnSpark(metal,
							metal.angle+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
							SKINCOLOR_ORANGE,
							true,
							true
						)
						TakisSpawnDust(metal,
							metal.angle+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
							P_RandomRange(0,-50),
							P_RandomRange(-1,2)*metal.scale,
							{
								xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								thrust = P_RandomRange(0,-10)*metal.scale,
								thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								momz = (P_RandomRange(4,0)*i)*(metal.scale/2),
								momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
								
								scale = metal.scale,
								scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								fuse = 15+P_RandomRange(-5,5),
							}
						)
					end
				end
						
			end
			
			afterimage(th,metal)
			th.clutching = $+1
			TakisSpawnDust(metal,
				metal.angle+FixedAngle(P_RandomRange(-45,45)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
				P_RandomRange(0,-50),
				P_RandomRange(-1,2)*metal.scale,
				{
					xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = P_RandomRange(0,-10)*metal.scale,
					thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					momz = P_RandomRange(4,0)*P_RandomRange(3,10)*(metal.scale/2),
					momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
					
					scale = metal.scale,
					scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					fuse = 15+P_RandomRange(-5,5),
				}
			)
		else
			th.clutching = 0
			th.afterimagecolor = 0
		end
		
		if th.last.sprite ~= SPR2_SMUG
		and metal.sprite2 == SPR2_SMUG
			S_StartSound(th,sfx_tawhip)
		elseif th.last.sprite ~= SPR2_TDD3
		and metal.sprite2 == SPR2_TDD3
			S_StartSound(th,sfx_altdi1)
			S_StartSound(th,sfx_smack)
			S_StartSound(th,sfx_s3k5d)
			
			for p in players.iterate
				local m2 = p.realmo
				
				if not m2 or not m2.valid
					continue
				end
				
				local rag = metal
				if (FixedHypot(m2.x-rag.x,m2.y-rag.y) <= 128*rag.scale)
					DoQuake(p,
						FixedMul(
							10*FU, FixedDiv(128*rag.scale - FixedHypot(m2.x-rag.x,m2.y-rag.y),128*rag.scale)
						),
						15
					)
				end
				--DoQuake(p,10*FU,15)
			end
			
			for i = 0, 8
				local radius = metal.scale*16
				local fa = (i*ANGLE_45)
				local mz = metal.scale
				local dust = TakisSpawnDust(metal,
					fa,
					0,
					P_RandomRange(-1,2)*metal.scale,
					{
						xspread = 0,
						yspread = 0,
						zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						thrust = 0,
						thrustspread = 0,
						
						momz = P_RandomRange(0,1)*metal.scale,
						momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
						
						scale = metal.scale,
						scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						fuse = 23+P_RandomRange(-2,3),
					}
				)
				dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
				dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
			end
		elseif metal.sprite2 == SPR2_SLID
			if th.last.sprite ~= SPR2_SLID
				S_StartSound(th,sfx_eeugh)
			end
			
			local chance = P_RandomChance(FU/3)
			if accspeed >= 30*FU
				chance = true
			end
			if accspeed <= 20*FU
				chance = false
			end
			
			--kick up dust
			if chance
				TakisSpawnDust(metal,
					metal.angle+FixedAngle(P_RandomRange(-45,45)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
					P_RandomRange(0,-50),
					P_RandomRange(-1,2)*metal.scale,
					{
						xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
						
						thrust = P_RandomRange(0,-10)*metal.scale,
						thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
						
						momz = P_RandomRange(4,0)*P_RandomRange(3,10)*(metal.scale/2),
						momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
						
						scale = metal.scale,
						scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
						
						fuse = 15+P_RandomRange(-5,5),
					}
				)
				if not (metal.eflags & (MFE_UNDERWATER|MFE_TOUCHLAVA) == MFE_UNDERWATER)
					S_StartSound(th,sfx_s3k7e)
				end
			end
		elseif th.last.sprite ~= SPR2_THUP
		and metal.sprite2 == SPR2_THUP
			S_StartSound(th,sfx_tayeah)
		elseif th.last.sprite ~= SPR2_PAIN
		and metal.sprite2 == SPR2_PAIN
			S_StartAntonOw(metal)
			
			--probably not taunting
			if (metal.momz ~= 0)
				S_StartSound(th,sfx_altow1)
				S_StartSound(th,sfx_smack)
				SpawnEnemyGibs(metal,metal)
				SpawnBam(metal,true)
			end
		elseif metal.sprite2 == SPR2_MLEE
			if th.last.sprite ~= SPR2_MLEE
				S_StartSoundAtVolume(th,sfx_airham,3*255/5)
			end
			
			local fallingspeed = (8*metal.scale)
			if ((metal.eflags&MFE_UNDERWATER) and not (metal.eflags & MFE_TOUCHLAVA)) then fallingspeed = $*3/4 end
			if metal.momz*P_MobjFlip(metal) <= fallingspeed
				
				if not S_SoundPlaying(th,sfx_takhmb)
					S_StartSound(th,sfx_takhmb)
				end
				
				if th.hammerblastdown
				and (th.hammerblastdown % 5 == 0)
				and (metal.momz*P_MobjFlip(metal) <= 16*metal.scale)
					P_SpawnGhostMobj(metal)
				end
				
			end
			th.hammerblastdown = $+1
			
		elseif metal.sprite2 == SPR2_GLID
			if th.last.sprite ~= SPR2_GLID
				S_StartSound(metal,sfx_takdiv)
				TakisSpawnDustRing(metal,16*metal.scale,0)
			end
			local angle = metal.angle
			local momz = metal.momz*P_MobjFlip(metal)
			momz = $*P_MobjFlip(metal)
			
			metal.pitch = $-FixedMul(momz*10,cos(angle))
			metal.roll = $-FixedMul(momz*10,sin(angle))
		elseif th.last.sprite ~= SPR2_JUMP
		and metal.sprite2 == SPR2_JUMP
			S_StartSound(th,skins[metal.skin].soundsid[SKSJUMP])
			local maxi = P_RandomRange(8,16)
			for i = 0, maxi
				local fa = FixedAngle(i*FixedDiv(360*FU,maxi*FU))
				local dust = TakisSpawnDust(metal,
					fa,
					0,
					P_RandomRange(-1,2)*metal.scale,
					{
						xspread = 0,
						yspread = 0,
						zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						thrust = 0,
						thrustspread = 0,
						
						momz = P_RandomRange(0,1)*metal.scale,
						momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
						
						scale = metal.scale,
						scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						fuse = 12+P_RandomRange(-2,3),
					}
				)
				dust.momx = FixedMul(sin(fa),metal.radius)/2
				dust.momy = FixedMul(cos(fa),metal.radius)/2
			end

			local wind = P_SpawnMobjFromMobj(metal,0,0,0,MT_THOK)
			wind.scale = metal.scale
			
			wind.fuse = 10
			wind.tics = -1
			
			wind.frame = A
			wind.sprite = SPR_RAIN
			wind.frame = B
			
			wind.renderflags = $|RF_PAPERSPRITE
			wind.startingtrans = 0
			
			wind.angle = TakisMomAngle(metal)
			wind.spritexscale,wind.spriteyscale = metal.scale,metal.scale
			wind.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0,0,metal.momx,metal.momy),FixedMul(9*FU,skins[metal.skin].jumpfactor)) + ANGLE_90
		elseif (th.last.sprite == SPR2_JUMP
		or th.last.sprite == SPR2_FALL)
		and metal.sprite2 == SPR2_ROLL
			local maxi = P_RandomRange(8,16)
			for i = 0, maxi
				local fa = FixedAngle(i*FixedDiv(360*FU,maxi*FU))
				local dust = TakisSpawnDust(metal,
					fa,
					0,
					P_RandomRange(-1,2)*metal.scale,
					{
						xspread = 0,
						yspread = 0,
						zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						thrust = 0,
						thrustspread = 0,
						
						momz = P_RandomRange(0,1)*metal.scale,
						momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
						
						scale = metal.scale,
						scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
						
						fuse = 12+P_RandomRange(-2,3),
					}
				)
				dust.momx = FixedMul(sin(fa),metal.radius)/2
				dust.momy = FixedMul(cos(fa),metal.radius)/2
			end

			--wind ring
			local ring = P_SpawnMobjFromMobj(metal,
				0,0,-5*metal.scale*P_MobjFlip(metal),MT_THOK --MT_WINDRINGLOL
			)
			if (ring and ring.valid)
				ring.renderflags = RF_FLOORSPRITE
				ring.frame = $|FF_TRANS50
				ring.startingtrans = FF_TRANS50
				ring.scale = FixedDiv(metal.scale,2*FU)
				P_SetObjectMomZ(ring,-metal.momz*2*P_MobjFlip(metal))
				--i thought this would fade out the object
				ring.fuse = 10
				ring.destscale = FixedMul(ring.scale,2*FU)
				ring.colorized = true
				ring.color = SKINCOLOR_WHITE
				ring.state = S_SOAPYWINDRINGLOL
			end
			
			S_StartSoundAtVolume(th,sfx_takdjm,4*255/5)
			
		elseif metal.sprite2 == SPR2_SKID
			if th.last.sprite ~= SPR2_SKID
				S_StartSound(th,skins[TAKIS_SKIN].soundsid[SKSSKID])
			end
			
			local ang = TakisMomAngle(metal)
			if P_RandomChance(FU/3)
				for i = 0,1
					TakisKart_SpawnSpark(metal,
						ang+FixedAngle(P_RandomRange(-25,25)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
						SKINCOLOR_ORANGE,
						true,
						true
					)
				end
			end
			TakisSpawnDust(metal,
				ang+FixedAngle(P_RandomRange(-25,25)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
				P_RandomRange(0,-30),
				P_RandomRange(-1,2)*metal.scale,
				{
					xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
					zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = P_RandomRange(0,-5)*metal.scale,
					thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					momz = P_RandomRange(4,0)*(metal.scale/2),
					momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
					
					scale = metal.scale/2,
					scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					fuse = 15+P_RandomRange(-5,5),
				}
			)
		
		end
		
		if metal.sprite2 ~= SPR2_MLEE
		and th.last.sprite == SPR2_MLEE
			S_StopSoundByID(th,sfx_takhmb)
			if (metal.eflags & MFE_JUSTHITFLOOR)
			or (P_IsObjectOnGround(metal))
				local maxi = 16+abs(th.last.momz*P_MobjFlip(metal)/metal.scale/5)
				for i = 0, maxi
					local radius = metal.scale*16
					local fa = FixedAngle(i*(FixedDiv(360*FU,maxi*FU)))
					local mz = th.last.momz/7
					local dust = TakisSpawnDust(metal,
						fa,
						0,
						P_RandomRange(-1,2)*metal.scale,
						{
							xspread = 0,
							yspread = 0,
							zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = 0,
							thrustspread = 0,
							
							momz = P_RandomRange(0,1)*metal.scale,
							momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = metal.scale,
							scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = 23+P_RandomRange(-2,3),
						}
					)
					dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
					dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
					
				end
				S_StartSoundAtVolume(th, sfx_pstop,4*255/5)
			end
			th.hammerblastdown = 0
		else
			--momentum based squash and stretch
			--if not takis.dontlanddust
			if abs(metal.momz) >= 18*metal.scale
				local mom = FixedDiv(abs(metal.momz),metal.scale)-18*FU
				mom = $/50
				mom = -min($,FU*4/5)
				metal.spritexscale,
				metal.spriteyscale = FU+mom,FU-(mom*9/10)
			else
				metal.spritexscale,metal.spriteyscale = FU,FU
			end
			
			if (metal.eflags & MFE_JUSTHITFLOOR)
			or (P_IsObjectOnGround(metal)
			and not th.last.grounded
			and th.last.grounded ~= nil)
			and (metal.sprite2 ~= SPR2_KART)
				S_StartSoundAtVolume(th,sfx_takst0,255*4/5)
				S_StartSound(th,sfx_takst4)
				if th.last.momz*P_MobjFlip(metal) <= -18*metal.scale
					local momz = th.last.momz*P_MobjFlip(metal)
					local rich = 10*FU
					S_StartSoundAtVolume(th,sfx_taklfh,255*4/5)
					
					if momz+18*metal.scale < 0
						rich = $+abs(FixedDiv(momz+18*metal.scale,FU))
					end
					--DoQuake(p,rich,15)
				end
				for i = 0, 8
					local radius = metal.scale*16
					local fa = (i*ANGLE_45)
					local mz = th.last.momz/10
					local dust = TakisSpawnDust(metal,
						fa,
						0,
						P_RandomRange(-1,2)*metal.scale,
						{
							xspread = 0,
							yspread = 0,
							zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							thrust = 0,
							thrustspread = 0,
							
							momz = P_RandomRange(0,1)*metal.scale,
							momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
							
							scale = metal.scale,
							scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
							
							fuse = 23+P_RandomRange(-2,3),
						}
					)
					dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
					dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
					
				end
			end
		end
		
		if metal.sprite2 ~= SPR2_GLID
			metal.pitch = 0
			metal.roll = 0
		end
		
		if metal.sprite2 ~= SPR2_SKID
			S_StopSoundByID(th,skins[TAKIS_SKIN].soundsid[SKSSKID])
		end
		
		if metal.sprite2 == SPR2_KART
			local frameset = TakisKart_KarterData[TAKIS_SKIN].legacyframes and TakisKart_Framesets.legacy or TakisKart_Framesets.norm
			local frame = metal.frame & FF_FRAMEMASK
			local drifting = false
			
			--Shitty
			if TakisKart_KarterData[TAKIS_SKIN].legacyframes
				drifting = (frame == frameset.driftL)
							or (frame == frameset.driftL + frameset.vibrateoffset)
							or (frame == frameset.driftR)
							or (frame == frameset.driftR + frameset.vibrateoffset)
			else
				drifting = frame >= frameset.driftL or frame <= frameset.driftR + frameset.vibrateoffset
			end
			
			if TakisKart_KarterData[TAKIS_SKIN].legacyframes
			--youve GOTTA be ebraking here
			--and (frame == 
			and FixedHypot(metal.momx,metal.momy) == 0
				--
			end
			
			if drifting
			and not S_SoundPlaying(th,sfx_kartdr)
			and P_IsObjectOnGround(metal)
				S_StartSound(th,sfx_kartdr)
			elseif (not drifting or not P_IsObjectOnGround(metal))
				S_StopSoundByID(th,sfx_kartdr)
			end
			
			if (frame == frameset.pain)
			and (th.last.frame ~= frameset.pain)
				S_StartAntonOw(th)
				S_StartSound(th,sfx_s3k9b)
			end
			
			if drifting
				local momang = TakisMomAngle(metal)
				local DS_minscale = FU*7/10
				local DS_maxscale = FU*13/10
				
				if not (th.driftfxL and th.driftfxL.valid)
					local spawner = P_SpawnMobjFromMobj(metal,
						P_ReturnThrustX(nil,momang,-metal.radius),
						P_ReturnThrustY(nil,momang,-metal.radius),
						0,
						MT_TAKIS_DRIFTSPARK
					)
					P_SetOrigin(spawner,
						spawner.x+FixedMul(metal.radius*2,cos(momang+ANGLE_90)),
						spawner.y+FixedMul(metal.radius*2,sin(momang+ANGLE_90)),
						spawner.z
					)
					spawner.angle = R_PointToAngle2(
						spawner.x,spawner.y,
						metal.x,metal.y
					)
					--spawner.tracer = car
					th.driftfxL = spawner
				end
				
				if not (th.driftfxR and th.driftfxR.valid)
					local spawner2 = P_SpawnMobjFromMobj(metal,
						P_ReturnThrustX(nil,momang,-metal.radius),
						P_ReturnThrustY(nil,momang,-metal.radius),
						0,
						MT_TAKIS_DRIFTSPARK
					)
					P_SetOrigin(spawner2,
						spawner2.x-FixedMul(metal.radius*3/2,cos(momang+ANGLE_90)),
						spawner2.y-FixedMul(metal.radius*3/2,sin(momang+ANGLE_90)),
						spawner2.z
					)
					spawner2.angle = R_PointToAngle2(
						spawner2.x,spawner2.y,
						metal.x,metal.y
					)
					--spawner2.tracer = car
					th.driftfxR = spawner2
				end

				for i = -1,1,2
				
					local spawn = th.driftfxL
					if i == 1 then spawn = th.driftfxR end
					
					if not (spawn and spawn.valid) then continue end
					
					spawn.color = TakisKart_DriftColor(2)
					spawn.scale = metal.scale
					spawn.tracer = th
					
					local g = P_SpawnGhostMobj(spawn)
					g.destscale = 0
					g.tics = 3
					
					/*
					if car.driftbrake
						local angle = momang+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
						TakisKart_SpawnSpark(spawn,angle,SKINCOLOR_ORANGE,true)
					end
					*/
					
					P_MoveOrigin(spawn,
						metal.x+P_ReturnThrustX(nil,momang,-metal.radius),
						metal.y+P_ReturnThrustY(nil,momang,-metal.radius),
						GetActorZ(metal,spawn,1)
					)
					P_MoveOrigin(spawn,
						spawn.x+(FixedMul(metal.radius*3/2,cos(momang+ANGLE_90))*i),
						spawn.y+(FixedMul(metal.radius*3/2,sin(momang+ANGLE_90))*i),
						spawn.z
					)
					spawn.angle = R_PointToAngle2(
						spawn.x,spawn.y,
						metal.x,metal.y
					)
					local s1,s2 = FU,FU
					if turndir ~= 0
						if turndir == driftdir
							if sign == i
								s1,s2 = DS_maxscale,DS_maxscale
							else
								s1,s2 = DS_minscale,DS_minscale
							end
						else
							if sign == -i
								s1,s2 = DS_maxscale,DS_maxscale
							else
								s1,s2 = DS_minscale,DS_minscale
							end
							
						end
					end
					spawn.spritexscale,spawn.spriteyscale = s1,s2
				
				end
			else
				for i = -1,1,2
				
					local spawn = th.driftfxL
					if i == 1 then spawn = th.driftfxR end
					
					if not (spawn and spawn.valid) then continue end
					
					P_RemoveMobj(spawn)
					spawn = nil
				end
			
			end
		end
		
		local spd = skins[metal.skin].runspeed
		accspeed = abs(FixedHypot(FixedHypot(metal.momx,metal.momy),metal.momz))
		accspeed = FixedDiv($,metal.scale)
		
		--wind effect
		for i = 1,10
			if accspeed > (spd*2)*i
				TakisDoWindLines(metal,nil,SKINCOLOR_PEPPER)
				for j = 1,i
					TakisDoWindLines(metal,nil,SKINCOLOR_PEPPER)
				end
			end
		end
		
		if accspeed >= 8*spd/5
			TakisDoWindLines(metal,nil,SKINCOLOR_PEPPER)
		elseif accspeed >= 7*spd/5
			if not (leveltime % 2)
				TakisDoWindLines(metal,nil,SKINCOLOR_PEPPER)
			end
		elseif accspeed >= 6*spd/5
			if not (leveltime % 5)
				TakisDoWindLines(metal,nil,SKINCOLOR_PEPPER)
			end
		elseif accspeed >= spd
			if not (leveltime % 7)
				TakisDoWindLines(metal,nil,SKINCOLOR_PEPPER)
			end
		end
		
		th.last.sprite = metal.sprite2
		th.last.frame = metal.frame & FF_FRAMEMASK
		th.last.momz = metal.momz
		th.last.grounded = P_IsObjectOnGround(metal)
	elseif th.state == S_LHRT
		if th.paperspin
			th.angle = $+ANG15*th.rng
		else
			th.rollangle = $+ANG15*th.rng
		end
	else
		return
	end
	
end,MT_THOK)

TAKIS_FILESLOADED = $+1