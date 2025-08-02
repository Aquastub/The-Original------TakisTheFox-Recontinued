/*	HEADER
	Handles all Punching dummy logic
	
*/

local ORIG_FRICTION = (232 << (FRACBITS-8)) --this should really be exposed...

local colorlist = {}
addHook("MapChange",do
	colorlist = {}
end)

local function sign(val)
	if val > 0
		return 1
	end
	
	if val < 0
		return -1
	end
	
	return 0
end

addHook("MobjSpawn",function(dummy)
	local thok = P_SpawnMobjFromMobj(dummy,0,0,0,MT_THOK)
	thok.tics = -1
	thok.flags2 = $|MF2_DONTDRAW
	
	dummy.takis_metalgibs = false
	dummy.spawnthok = thok
	
	--dummies must have unique colors for identification
	dummy.color = P_RandomRange(SKINCOLOR_LAVENDER + P_RandomRange(0,50),#skincolors - SKINCOLOR_SUPERSILVER1)
	for _,clr in pairs(colorlist)
		if clr == dummy.color
			repeat
				dummy.color = P_RandomRange(SKINCOLOR_LAVENDER + P_RandomRange(0,50),#skincolors - SKINCOLOR_SUPERSILVER1)
			until clr ~= dummy.color
		end
	end
	table.insert(colorlist,dummy.color)
	
	dummy.waveoffset = P_RandomRange(-50,50)*FU
	
end,MT_TAKIS_DUMMY)

addHook("MobjThinker",function(dummy)
	if dummy.flashingtics
		dummy.flashingtics = $-1
		dummy.flags2 = $^^MF2_DONTDRAW
		dummy.flags = $ &~(MF_SHOOTABLE)
	else
		dummy.health = dummy.info.spawnhealth
		dummy.flags2 = $ &~MF2_DONTDRAW
		dummy.flags = $|MF_SHOOTABLE
	end
	dummy.friction = ORIG_FRICTION--*12/10
	
	--ringracers ball switch
	local spawn = dummy.spawnthok
	local myz = dummy.z
	local theirz = spawn.z
	
	local dist = P_AproxDistance(P_AproxDistance(spawn.x - dummy.x, spawn.y - dummy.y), theirz - myz)
	local move = P_AproxDistance(P_AproxDistance(dummy.momx, dummy.momy), dummy.momz)
	local accel = 4
	local accelscale = accel*dummy.scale
	
	if (dist < accelscale and move < accelscale)
		P_SetOrigin(dummy,spawn.x,spawn.y,theirz)
		dummy.momx,dummy.momy,dummy.momz = 0,0,0
		dummy.awayfromhome = 0
		dummy.flags = $ &~(MF_NOCLIP|MF_NOCLIPHEIGHT)
	else
		dummy.awayfromhome = $+1
		if dummy.awayfromhome >= 3*TR
			dummy.flags = $|MF_NOCLIP|MF_NOCLIPHEIGHT
		end
		
		local accelt = { FU*3/4, FU*3/16 }
		local fric = FU*99/100
		
		dummy.momx = FixedMul($, fric)
		dummy.momy = FixedMul($, fric)
		dummy.momz = FixedMul($, fric)
		
		local xsign = sign(spawn.x - dummy.x)
		local ysign = sign(spawn.y - dummy.y)
		local zsign = sign(theirz - myz)
		
		--cpp allows table indexing with bools, so convert these
		--into table entries
		local xaway = sign(dummy.momx) == xsign and 2 or 1
		local yaway = sign(dummy.momy) == ysign and 2 or 1
		local zaway = sign(dummy.momz) == zsign and 2 or 1
		
		dummy.momx = $+FixedMul(accelt[xaway], accelscale)*xsign
		dummy.momy = $+FixedMul(accelt[yaway], accelscale)*ysign
		dummy.momz = $+FixedMul(accelt[zaway], accelscale)*zsign
		
		dummy.angle = $+FixedAngle(move*2)
		if (dist > dummy.radius*2)
			P_Thrust(dummy,dummy.angle,(move / accel)*2/3)
		end
	end
	
	local waveforce = FU*3
	local ay = FixedMul(waveforce,sin(FixedAngle(leveltime*10*FU + dummy.waveoffset)))
	
	dummy.spriteyoffset = ay
	
end,MT_TAKIS_DUMMY)

addHook("MobjDeath",function(dummy,inf,sor)
	if not (inf and inf.valid) then return end
	
	P_Thrust(dummy,
		R_PointToAngle2(inf.x,inf.y, dummy.x,dummy.y),
		FixedHypot(inf.momx,inf.momy)*5
	)
	dummy.momz = inf.momz*5

	if (dummy.spawnpoint and dummy.spawnpoint.args[0])
		P_LinedefExecute(dummy.spawnpoint.args[0], dummy, nil)
	end
	
end,MT_TAKIS_DUMMY)

addHook("TouchSpecial",function(dummy,toucher)
	return true
end,MT_TAKIS_DUMMY)

addHook("NetVars",function(n)
	colorlist = n($)
end)
TAKIS_FILESLOADED = $+1