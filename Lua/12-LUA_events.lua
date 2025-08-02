/*	HEADER
	One shot event thinkers for Takis
	
*/

--netplay be damned
addHook("MobjDeath",function(em,_,me)
	if not (em and em.valid) then return end
	if not (me and me.valid) then return end
	local p = me.player
	
	if (em.soda and em.soda.valid)
		P_RemoveMobj(em.soda)
	end
	
	if not (p and p.valid) then return end
	local takis = p.takistable
	if not takis then return end
	if me.skin ~= TAKIS_SKIN then return end
	
	S_StartSound(me,sfx_sptclt)
	for i = 10,P_RandomRange(15,20)
		local note = P_SpawnMobjFromMobj(em,0,0,0,MT_THOK)
		note.flags = $|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING
		note.sprite = SPR_TMIS
		note.frame = P_RandomRange(K,M)
		note.tics,note.fuse = 3*TR,3*TR
		note.angle = FixedAngle(P_RandomRange(0,360)*FU)
		P_Thrust(note,note.angle,P_RandomRange(5,10)*note.scale)
		P_SetObjectMomZ(note,P_RandomRange(-10,10)*FU)
	end
	
	TakisGiveCombo(p,takis,false,true)
end,MT_EMBLEM)

--fix this stupid zfighting issue in opengl
addHook("MobjSpawn",function(drone)
	if (maptol & TOL_NIGHTS)
		drone.dispoffset = -1
		table.insert(TAKIS_NET.ideyadrones,drone)
	end
end,MT_EGGCAPSULE)

--SUMMIT!
addHook("GameQuit",function(quit)
	if (consoleplayer and consoleplayer.valid)
	and (consoleplayer.takistable and consoleplayer.takistable.io.autosave)
	and not modeattacking
		TakisSaveStuff(consoleplayer,true)
	end
	
	if not quit then return end
	
	S_StopMusic(consoleplayer)
	S_StartSound(nil,sfx_summit)
end)

addHook("MobjDeath",function(dust,_,_,_,dmgt)
	if not (dust and dust.valid) then return end
	
	if dmgt == DMG_DEATHPIT
		return true
	end
	return
end,MT_TAKIS_STEAM)

addHook("ShouldDamage",function(dust,_,_,_,dmgt)
	if not (dust and dust.valid) then return end
	
	if dmgt == DMG_DEATHPIT
		return false
	end
	return
end,MT_TAKIS_STEAM)

addHook("MobjDeath",function(t,i,s)
	if s
	and s.skin == TAKIS_SKIN
	and s.player
	
		if s.player.takistable.combo.time
			TakisGiveCombo(s.player,s.player.takistable,false,true)
		end
		
		if s.player.powers[pw_shield] & SH_FIREFLOWER
			if s.player.takistable.heartcards ~= TAKIS_MAX_HEARTCARDS
				TakisHealPlayer(s.player,s,s.player.takistable,1,1)
				S_StartSound(s,sfx_takhel,s.player)
			end
		end
	end
end,MT_FIREFLOWER)

addHook("MobjDeath", function(target,inflict,source)
	if source
	and source.skin == TAKIS_SKIN
	and source.player
		for p in players.iterate
			p.takistable.HUD.statusface.happyfacetic = 3*TR/2
		end
	end
end, MT_TOKEN)

--yeah im acting petty with my stupid kart shit
--just LET ME ACT AUTISTIC WITH MY DUMBASS KART dude FUCK OFF holy shit
--you know who you are
addHook("MobjRemoved",function(k)
	if k.paidfor and k.special
		return true
	end
end,MT_TAKIS_KART)

--give spikeballs a deathstate
addHook("MobjDeath",function(mo,i,s)
	local gst = P_SpawnGhostMobj(mo)
	gst.flags2 = $|MF2_DONTDRAW
	gst.fuse = 3*TR
	
	S_StartSound(gst,mobjinfo[MT_SPIKE].deathsound)
	
	for i = 0,5
		local dust = TakisSpawnDust(mo,
			FixedAngle( P_RandomRange(-337,337)*FRACUNIT ),
			10,
			P_RandomRange(0,(mo.height/mo.scale)/2)*mo.scale,
			{
				xspread = 0,
				yspread = 0,
				zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
				
				thrust = 0,
				thrustspread = 0,
				
				momz = P_RandomRange(10,-5)*mo.scale,
				momzspread = 0,
				
				scale = mo.scale/2,
				scalespread = P_RandomFixed(),
				
				fuse = 20,
			}
		)
		dust.tracer = s
		
		/*
		local debris = P_SpawnMobjFromMobj(mo,
			(P_RandomRange(-10,10)*mo.scale),
			(P_RandomRange(-10,10)*mo.scale),
			(P_RandomRange(-10,10)*mo.scale),
			MT_THOK
		)
		debris.sprite = SPR_USPK
		debris.frame = P_RandomRange(E,F)
		debris.tics = -1
		debris.fuse = 3*TR
		debris.angle = R_PointToAngle2(debris.x,debris.y, mo.x,mo.y)
		debris.flags = $ &~MF_NOGRAVITY
		L_ZLaunch(debris,10*mo.scale)
		P_Thrust(debris,InvAngle(debris.angle),2*mo.scale)
		*/
	end
	
end,MT_SPIKEBALL)

TAKIS_FILESLOADED = $+1