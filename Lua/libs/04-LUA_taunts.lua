/*	HEADER
	Everything taunt related goes here
	
*/

rawset(_G, "TAKIS_TAUNT_DIST",75*FU)

rawset(_G, "TF_TAUNTKILL",1<<0)
rawset(_G, "TF_MOBILE",1<<1)

local function L_ZCollide(mo1,mo2)
	if mo1.z > mo2.height+mo2.z then return false end
	if mo2.z > mo1.height+mo1.z then return false end
	return true
end

local function CheckForRadios(p)
	if gametype ~= GT_SAXAMM then return end
end

--taunt inits

local function init_ouch(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 24
	S_StartAntonOw(me)
	takis.tauntcancel = false
end

local function init_smug(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 12
	takis.tauntspecial = P_RandomChance(FRACUNIT/10)
	S_StartSound(me,sfx_tawhip)
	takis.tauntcancel = false
end

local function init_conga(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.tauntextra = {
		angle = me.angle
	}
	
	takis.taunttime = 2
	takis.stasistic = 2
	takis.tauntacceptspartners = false
	P_PlayJingleMusic(p,"_conga",0,true,JT_OTHER)
	takis.tauntcancel = true
end

local function init_bat(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	if not (TAKIS_NET.tauntkillsenabled)
		return false
	end
	
	takis.taunttime = 3*TR
	S_StartSound(me,sfx_spndsh)
	takis.tauntcancel = false
end

local function init_bird(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.tauntextra = {
		loops = 0,
		offset = false,
	}
	
	takis.taunttime = 2
	takis.stasistic = 2
	takis.tauntacceptspartners = false
	me.state = S_PLAY_TAKIS_BIRD
	P_PlayJingleMusic(p,"brdwrd",0,true,JT_OTHER)
	takis.tauntcancel = true
end

local function init_yeah(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 99
	takis.stasistic = 2
	takis.tauntacceptspartners = false
	TakisSpawnConfetti(me)
	S_StartSound(me,sfx_tayeah)
	takis.tauntcancel = false
	me.tics = -1
end

local function init_dead(p)
	local me = p.mo
	local takis = p.takistable
	local menu = takis.tauntmenu
	
	takis.taunttime = 2
	takis.stasistic = 2
	takis.tauntacceptspartners = false
	
	me.state = S_PLAY_DEAD
	me.sprite2 = SPR2_TDD3
	
	takis.tauntextra = {
		angle = p.drawangle,
		timer = 0,
	}
	
	S_StartSound(me,sfx_altdi1)
	S_StartSound(me,sfx_smack)
	S_StartSound(me,sfx_s3k5d)
	
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
	takis.tauntcancel = true
end


--taunt thinks

local function think_ouch(p)
	local me = p.mo
	local takis = p.takistable
	
	me.state = S_PLAY_PAIN
end

local function think_smug(p)
	local me = p.mo
	local takis = p.takistable

	me.state = S_PLAY_TAKIS_SMUGASSGRIN
	if not takis.tauntspecial
		me.frame = A
	else
		me.frame = B
	end
	if me.tics == -1
		me.tics = 12
	end

end

local function think_conga(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	takis.taunttime = 4
	takis.tauntjoinable = true
	
	if takis.kart.sidemove > 15
		takis.tauntextra.angle = $ - ANG2
	end
	if takis.kart.sidemove < -15
		takis.tauntextra.angle = $ + ANG2
	end
	
	local angle = takis.tauntextra.angle
	p.drawangle = angle
	if P_TryMove(me, 
		me.x + FixedMul(4*cos(angle),me.scale),
		me.y + FixedMul(4*sin(angle),me.scale),
		false
	)
		P_InstaThrust(me,p.drawangle,2*me.scale)
		P_MovePlayer(p)
	end
	if me.state ~= S_PLAY_TAKIS_CONGA
		me.state = S_PLAY_TAKIS_CONGA
	end
	
	local tic = leveltime%24
	local tic2 = leveltime%48
	for i = 0,1
		takis.spritexscale = $+ease.inoutback((FU/24)*tic,0,FU/3,FU*3) 
		takis.spriteyscale = $-ease.inoutback((FU/24)*tic,0,FU/3,FU*3) 
	end
	takis.tiltdo = true
	takis.tiltvalue = $+FixedAngle(FixedMul(30*FU,
		(FU/24)*tic*(tic2 >= 24 and 1 or -1)
	))
	
	--cancel conga
	if (takis.c1)
	or (takis.tossflag == 1 and takis.tossflag_R)
		TakisResetTauntStuff(p)
		P_RestoreMusic(p)
		me.state = S_PLAY_STND
		TakisResetState(p)
	end
end

local function think_bat(p)
	local me = p.mo
	local takis = p.takistable
	
	if not takis.onGround
		TakisResetTauntStuff(p)
		return
	end
	
	takis.stasistic = 2
	if (takis.taunttime ~= 3*TR)
		if takis.taunttime > TR
			--
		elseif takis.taunttime == TR
			S_StartSound(me,sfx_mswing)
		elseif takis.taunttime == 32
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
			thok.parent = me
			TakisBreakAndBust(p,thok)
			
			local fakerange = 250*FU
			local range = 80*FU
			searchBlockmap("objects", function(ref, found)
				if R_PointToDist2(found.x, found.y, ref.x, ref.y) <= range
				and L_ZCollide(found,ref)
				and (found.health)
				and (found ~= me)
					if CanFlingThing(found)
						SpawnBam(ref)
						SpawnEnemyGibs(thok,found)
						S_StartSound(found,sfx_smack)
						S_StartSound(me,sfx_sdmkil)
						SpawnRagThing(found,me,me)
						local ghs = P_SpawnGhostMobj(found)
						ghs.fuse = 10*TR
						ghs.flags2 = $|MF2_DONTDRAW
						S_StartSound(ghs,sfx_homrun)
						didit = true
					elseif SPIKE_LIST[found.type]
						P_KillMobj(found,me,me)
					elseif (found.player and found.player.valid)
						if CanPlayerHurtPlayer(p,found.player)
							P_KillMobj(found,me,me)
							didit = true
						end
						TakisAwardAchievement(p,ACHIEVEMENT_HOMERUN)
						SpawnBam(ref)
						SpawnEnemyGibs(found,found)
						S_StartSound(found,sfx_smack)
						S_StartSound(me,sfx_sdmkil)
						local ang = p.drawangle
						
						P_InstaThrust(found,ang,175*FU)
						L_ZLaunch(found,60*FU)
						P_MovePlayer(found.player)
						found.state = S_PLAY_PAIN
						
						local ghs = P_SpawnGhostMobj(me)
						ghs.fuse = 10*TR
						ghs.flags2 = $|MF2_DONTDRAW
						S_StartSound(ghs,sfx_homrun)
						S_StartSound(nil,sfx_homrun,found.player)
						
						if found.health
							found.state = S_PLAY_PAIN
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
			return didit
		end
	end
end

local function think_bird(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	takis.taunttime = $+2
	
	if me.state == S_PLAY_TAKIS_BIRD
		local cap = 6
		local off = takis.tauntextra.offset and 6 or 0
		local ticker = (takis.taunttime-2)/4 % cap
		
		if (((takis.taunttime-2)*4) % (cap*4)) == 20
			takis.tauntextra.loops = $+1
			if takis.tauntextra.loops >= P_RandomRange(8,25)
				takis.tauntextra.loops = 0
				if not takis.tauntextra.offset
					takis.tauntextra.offset = true
					off = $+6
				else
					takis.tauntextra.offset = false
					off = 0
				end
			end
		end
		
		--me.state = S_PLAY_TAKIS_BIRD
		--me.frame = ((takis.taunttime-2) % 6)
		me.frame = (ticker)+off
	end
	
	--cancel conga
	if (takis.c1)
	or (takis.tossflag == 1 and takis.tossflag_R)
		TakisResetTauntStuff(p)
		P_RestoreMusic(p)
		me.state = S_PLAY_STND
		TakisResetState(p)
	end
end

local function think_yeah(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	
	if takis.taunttime > 1
		if me.sprite2 ~= SPR2_THUP
			me.frame = A
			me.sprite2 = SPR2_THUP
		end
		
		takis.HUD.statusface.happyfacetic = 2
		
		if P_RandomChance(FRACUNIT-((takis.taunttime*655)+36))
			me.frame = B
		else
			me.frame = A
		end
	else
		me.state = S_PLAY_STND
		TakisResetState(p)
		takis.taunttime = 0
	end
		
end

local function think_dead(p)
	local me = p.mo
	local takis = p.takistable
	
	takis.nocontrol = 2
	takis.taunttime = $+1
	takis.tauntextra.timer = $+1
	
	if me.state ~= S_PLAY_DEAD
		me.state = S_PLAY_DEAD
		me.sprite2 = SPR2_TDD3
	end
	
	if gametype ~= GT_COOP
		takis.spriteyscale = $ + sin(FixedAngle(takis.tauntextra.timer*FU))/5
		takis.spritexscale = $ - sin(FixedAngle(takis.tauntextra.timer*FU))/5
	end
	
	p.drawangle = takis.tauntextra.angle
	
	me.tics = -1
	
	--cancel conga
	if (takis.c1)
	or (takis.tossflag == 1 and takis.tossflag_R)
		TakisResetTauntStuff(p)
		P_RestoreMusic(p)
		me.state = S_PLAY_STND
		TakisResetState(p)
	end
end

local function join_conga(leader,joiner)
	joiner.mo.angle = leader.takistable.tauntextra.angle
	joiner.takistable.tauntextra.angle = joiner.mo.angle
	
	local lead = leader.mo
	local angle = joiner.mo.angle
	P_TryMove(joiner.mo,
		lead.x + P_ReturnThrustX(nil,angle,-40*lead.scale),
		lead.y + P_ReturnThrustY(nil,angle,-40*lead.scale),
		false
	)
end

rawset(_G, "TAKIS_TAUNT_INIT", {
	[1] = init_ouch,
	[2] = init_smug,
	[3] = init_conga,
	[4] = init_bat,
	[5] = init_bird,
	[6] = init_yeah,
	[7] = init_dead,
})

rawset(_G, "TAKIS_TAUNT_THINK", {
	[1] = think_ouch,
	[2] = think_smug,
	[3] = think_conga,
	[4] = think_bat,
	[5] = think_bird,
	[6] = think_yeah,
	[7] = think_dead,
})

rawset(_G, "TAKIS_TAUNT_JOIN", {
	[1] = nil,
	[2] = nil,
	[3] = join_conga,
	[4] = nil,
	[5] = nil,
	[6] = nil,
	[7] = nil,
})

rawset(_G, "TAKIS_TAUNT_FLAGS", {
	[3] = TF_MOBILE,
	[4] = TF_TAUNTKILL,
})

--functions to check if a taunt is usuable in a certain situation
rawset(_G, "TAKIS_TAUNT_REJECT", {
/*
	[1] = think_ouch,
	[2] = think_smug,
	[3] = think_conga,
	[4] = think_bat,
	[5] = think_bird,
	[6] = think_yeah,
*/
})

rawset(_G, "TakisIsTauntUsable",function(p,tauntid,onlychecks)
	--if TAKIS_TAUNT_REJECT[tauntid] == nil then return true end
	
	local takis = p.takistable
	local usable = true
	
	if (TAKIS_TAUNT_FLAGS[tauntid] or 0) & TF_MOBILE
	and (p.powers[pw_nocontrol] or (p.pflags & PF_STASIS) or takis.nocontrol or takis.noability & NOABIL_MOBILETAUNT)
		if not onlychecks
			CONS_Printf(p,"\x85You cannot use this taunt as you are currently immobile.")
		end
		usable = false
	end
	
	if (TAKIS_TAUNT_FLAGS[tauntid] or 0) & TF_TAUNTKILL
	and (not TAKIS_NET.tauntkillsenabled or gametype == GT_ZE2 or gametype == GT_SAXAMM)
		if not onlychecks
			CONS_Printf(p,"\x85You cannot use this taunt as the server has tauntkills disabled.")
		end
		usable = false
	end
	
	if TAKIS_TAUNT_REJECT[tauntid] ~= nil
		usable = TAKIS_TAUNT_REJECT[tauntid](p)
	end
	
	if not usable
	and not onlychecks
		S_StartSound(nil,sfx_adderr,p)
		takis.tauntreject = true
	end
	return usable
end)

TAKIS_FILESLOADED = $+1
