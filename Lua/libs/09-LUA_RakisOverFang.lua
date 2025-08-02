/*	HEADER
	Replaces Fang bossfight with Rakis
	
	CREDITS: UnmatchedBracket
	
*/

local numberFrames = {Z+2, Z+3, Z+4, Z+5, Z+6, Z+7, Z+8, Z+9}
numberFrames[0] = Z+1

local function gunragdoll(gun,i)
	local rag = gun
	rag.rakis_shotgun_ragdoll = true
	rag.timealive = 0
	rag.flags = $ &~MF_NOGRAVITY
	rag.fuse = 4*TR
	rag.frame = B
	rag.rollangle = ANGLE_90-(ANG10*3)
	
	L_ZLaunch(rag,10*FU)
	if i and i.valid
		P_Thrust(rag, R_PointToAngle2(rag.x,rag.y, i.x,i.y), -5*rag.scale)
	end
	S_StartSound(i,sfx_shgnk)
end

addHook("MobjThinker", function (mo)
	if mo.rakis_shotgun_ragdoll then
		local rag = mo
		
		rag.timealive = $+1
		if rag.timealive % 5 == 0
			local poof = P_SpawnMobjFromMobj(rag,0,0,rag.height/2,MT_SPINDUST)
			poof.scale = FixedMul(FRACUNIT*4/5,rag.scale)
			poof.colorized = true
			poof.destscale = rag.scale/4
			poof.scalespeed = FRACUNIT/10
			poof.fuse = 10				
		end
	end
end, MT_UNKNOWN)

/*
[x] a = stand
[x] b-d = wait
[x] e = skid
[x] f-h = shoot
[x] i-k = bounce, going higher
[x] l = spring
[x] m,n = fall
[x] o = hurt
[x] p,q = laugh
[x] r = dead
[x] s-u = bomb throw?
[x] v = trip
[x] w = faceplant
[x] x,y = just hopped out of bin
[x] z = above but peeking
[x] 0 = epic smear frame of panik
[x] 1-4 = roll
[x] 5-8 = panik
*/

local fangs = {}

local function UseCloneFighter(fang)
	local onlyfang = false
	local hasrakis = false
	
	for p in players.iterate()
		if (p.spectator) then continue end
		
		if (skins[p.skin].name == TAKIS_SKIN)
		and (p.skincolor == SKINCOLOR_SALMON)
			hasrakis = true
		end
	end
	
	return hasrakis
end

addHook("MobjSpawn",function(mo)
	table.insert(fangs,mo)
	
	if not UseCloneFighter(mo)
		mo.flags2 = $ &~MF2_SLIDEPUSH
		mo.colorized = false
		mo.color = SKINCOLOR_SALMON
	else
		mo.color = SKINCOLOR_SILVER
		mo.flags2 = $|MF2_SLIDEPUSH
		mo.colorized = true
	end
	
	/*
	for p in players.iterate()
		if (skins[p.skin].name == TAKIS_SKIN)
		and (p.skincolor == SKINCOLOR_SALMON)
			mo.flags2 = $|MF2_SLIDEPUSH
		end
	end
	*/
	
end,MT_FANG)

addHook("PostThinkFrame", function ()
	if gamestate ~= GS_LEVEL
		fangs = {}
	end
	
	--for mo in mobjs.iterate() do
	for k,mo in ipairs(fangs) do
		if not (mo and mo.valid) then table.remove(fangs,k); continue end
		
		if not UseCloneFighter(mo)
			mo.flags2 = $ &~MF2_SLIDEPUSH
			mo.colorized = false
			mo.color = SKINCOLOR_SALMON
		else
			mo.color = SKINCOLOR_SILVER
			mo.flags2 = $|MF2_SLIDEPUSH
			mo.colorized = true
		end
		
		if mo.type == MT_FANG and (mo.sprite == SPR_FANG or mo.sprite == SPR_PLAY) then
			
			local oframe
			if mo.sprite == SPR_FANG then
				oframe = mo.frame & FF_FRAMEMASK
				mo.rakfang_lastframe = oframe
			else
				oframe = mo.rakfang_lastframe or A
			end
			
			mo.sprite = SPR_PLAY
			mo.skin = TAKIS_SKIN
			mo.sprite2 = SPR2_STND
			
--  			print(string.char(oframe + 65))
			local frame = A
			if oframe >= numberFrames[1] and oframe <= numberFrames[4] then
				mo.sprite2 = SPR2_ROLL
				frame = oframe - numberFrames[1]
			elseif oframe == numberFrames[0] or (oframe >= numberFrames[5] and oframe <= numberFrames[8]) then
				mo.sprite2 = SPR2_PAIN
				frame = (leveltime / 2) % 2
			elseif (oframe >= B and oframe <= D) then
				mo.sprite2 = SPR2_STUN
			elseif oframe == E then
				mo.sprite2 = SPR2_SKID
			elseif oframe >= F and oframe <= H then
				mo.sprite2 = SPR2_STND
			elseif oframe >= I and oframe <= K then
				mo.sprite2 = SPR2_NADO
				mo.angle = $ + ANGLE_45
			elseif oframe == L then
				mo.sprite2 = SPR2_SPNG
			elseif oframe == M or oframe == N then
				mo.sprite2 = SPR2_FALL
				frame = oframe - M
			elseif oframe == O then
				mo.sprite2 = SPR2_PAIN
				frame = (leveltime / 2) % 2
				if not mo.rakfang_pain then
					S_StartAntonOw(mo)
					--S_StartSound(mo, sfx_antow1 + P_RandomRange(0, 6))
				end
			elseif (oframe >= P and oframe <= Q) then
				mo.sprite2 = SPR2_TBRD
				frame = (leveltime / 4) % 6
			elseif oframe == R then
				mo.sprite2 = SPR2_DEAD
				if not mo.rakfang_hasscreamed then
					mo.rakfang_hasscreamed = true
					
					S_StopSound(mo)
					S_StartSound(mo,sfx_buzz3)
					mo.deathfunny = TR
					
					/*
					local gh = P_SpawnGhostMobj(mo)
					gh.flags2 = $|MF2_DONTDRAW
					gh.tics = TR
					
					--this keeps getting removed so idk
					local ki = P_SpawnMobjFromMobj(mo,0,0,0,MT_TAKIS_BROLYKI)
					ki.tracer = gh
					ki.color = mo.color
					*/
					
					/*
					
					local thok = P_SpawnMobjFromMobj(mo,
						0,0,mo.height/2,
						MT_THOK
					)
					thok.height = 40*mo.scale
					thok.dispoffset = -2
					thok.blendmode = AST_SUBTRACT
					thok.color = SKINCOLOR_SALMON
					thok.sprite = SPR_TMIS
					thok.frame = S
					thok.fuse = -1
					thok.tics = TR
					thok.scale = mo.scale/20
					thok.destscale = mo.scale*20
					thok.scalespeed = FixedDiv(thok.destscale - thok.scale,5*FU)
					mo.thok = thok
					*/
				end
				
				if mo.deathfunny
					
					/*
					mo.thok.height = 40*mo.thok.scale
					P_MoveOrigin(mo.thok,
						mo.x,mo.y,
						mo.z - (mo.thok.height/2)
					)
					
					if TR - mo.deathfunny == TR*2/3
						mo.thok.destscale = 0
						mo.thok.scalespeed = FixedDiv(mo.thok.scale,(TR - (TR*2/3))*FU)
					end
					*/
					
					mo.spritexoffset = (mo.deathfunny)*2*FU*((leveltime & 1) and 1 or -1)
					mo.momx,mo.momy,mo.momz = 0,0,0
					mo.flags = $|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
					mo.deathfunny = $-1
					
					if mo.deathfunny == 18
						S_StartSound(mo,sfx_megadi)
					end
					
					if not mo.deathfunny
						mo.flags = $ &~(MF_NOGRAVITY)
						P_Thrust(mo,
							FixedAngle(
								P_RandomRange(0,360)*FU
							),
							25*mo.scale
						)
						L_ZLaunch(mo,25*FU)
						TakisFancyExplode(mo,
							mo.x, mo.y, mo.z,
							P_RandomRange(60,64)*mo.scale,
							16,
							nil,
							15,20
						)
						SpawnEnemyGibs(mo,mo)
						for i = 0,3
							S_StartSound(mo,sfx_tkapow)
						end
						--P_RemoveMobj(mo.thok)
						--mo.thok = nil
					end
				end
				
			elseif (oframe >= S and oframe <= U) then
				mo.sprite2 = SPR2_TBRD
				frame = oframe - S + 1
			elseif oframe == V then
				mo.sprite2 = SPR2_TDED
			elseif oframe == W then
				mo.sprite2 = SPR2_TDD3
			elseif oframe >= X or oframe <= Z then
				mo.sprite2 = SPR2_STUN
			end
			if oframe == V then
				mo.rollangle = $ - ANG2
			else
				mo.rollangle = 0
			end
			
			mo.rakfang_pain = (oframe == O)
			
			local shotgunnow = (oframe >= F and oframe <= H)
			if shotgunnow != (not not mo.rakfang_hasshotgun) then
				if shotgunnow then
					S_StartSound(nil, sfx_shgnl)
					local x = cos(mo.angle-ANGLE_90)
					local y = sin(mo.angle-ANGLE_90)
					
					mo.rakfang_shotgun  = P_SpawnMobjFromMobj(mo,16*x,16*y,mo.height/2,MT_UNKNOWN)
					mo.rakfang_shotgun.state = S_TAKIS_SHOTGUN
					mo.rakfang_shotgun.target = mo
					mo.rakfang_shotgun.angle = mo.angle
				else
					if mo.rakfang_shotgun and mo.rakfang_shotgun.valid then
						gunragdoll(mo.rakfang_shotgun, mo)
					end
				end
			end
			
			if shotgunnow and mo.rakfang_shotgun and mo.rakfang_shotgun.valid then
				local x = cos(mo.angle-ANGLE_90)
				local y = sin(mo.angle-ANGLE_90)
				P_MoveOrigin(
					mo.rakfang_shotgun,
					mo.x + 16*x,
					mo.y + 16*y,
					mo.rakfang_shotgun.z
				)
				mo.rakfang_shotgun.angle = mo.angle
			end
			mo.rakfang_hasshotgun = shotgunnow
			mo.frame = ($ & ~FF_FRAMEMASK) + frame
			
		end
	end
end)

local swapped = false
--??? putting this in whitespace errors
addHook("ThinkFrame", function ()
	if not swapped then
		TAKIS_BOSSCARDS.bossnames[MT_FANG] = "Rakis"
		
		states[S_FANG_DIE5].var1 = sfx_antjum
		mobjinfo[MT_FANG].activesound = sfx_kc52
		swapped = true
	end
end)

function A_Boss5MakeJunk(actor, var1, var2)
	super(actor, var1, var2)

	if (var2 & 2)
	and not UseCloneFighter(actor)
		local broked = P_SpawnMobjFromMobj(actor, 0, 0, 64<<FRACBITS, MT_GHOST);
		S_StartSound(broked, sfx_antow4 + P_RandomRange(0,1));
		broked.fuse = states[S_FANG_INTRO12].tics+10;
		broked.state = S_ALART1;
	elseif var2 & 1 then
		
	else
		S_StartSound(actor, sfx_s3kd3s);
	end
end

function A_FireShot(actor, var1, var2)
	super(actor, var1, var2)
	
	if actor.type == MT_FANG then
		S_StartSound(actor, sfx_shgns)
	end
end

local colorlist = {
	SKINCOLOR_FLAME,
	SKINCOLOR_GARNET,
	SKINCOLOR_KETCHUP
}

addHook("MobjThinker", function (mo)
	if mo.target and mo.target.valid and mo.target.type == MT_FANG then
		if mo.sprite == SPR_CORK then
			S_StopSound(mo)
			mo.sprite = SPR_SHGN
			mo.frame = D|FF_FULLBRIGHT
		end
		
		mo.timealive = ($ or 0)+1
		mo.color = colorlist[P_RandomRange(1,#colorlist)]
		
		local ghost = P_SpawnGhostMobj(mo)
		ghost.colorized = true
		ghost.blendmode = AST_ADD
		ghost.destscale = 1
		ghost.angle = mo.angle+(P_RandomRange(-20,20)*FU+((P_RandomChance(FU/2) and 1 or -1)*P_RandomFixed()))
		P_Thrust(ghost,ghost.angle,-P_RandomRange(10,20)*mo.scale)
		ghost.angle = mo.angle
		P_SetObjectMomZ(ghost,P_RandomRange(-3,3)*ghost.scale)
	end
end, MT_CORK)

addHook("NetVars",function(n)
	fangs = n($)
end)

TAKIS_FILESLOADED = $+1