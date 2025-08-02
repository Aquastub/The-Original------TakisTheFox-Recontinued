/*	HEADER
	Ring Racers broly ki
	
*/

/*
				local thok = v.getSpritePatch(SPR_THOK,0,0)
				local scale = FU*20
				local deadtimer = takis.deadtimer
				if deadtimer > 0
					if deadtimer > TR
						scale = 0
					else
						if deadtimer >= TR*2/3
							deadtimer = $-(TR*2/3)
							scale = ease.outsine((FU/(TR/3))*deadtimer,20*FU,0)
						elseif takis.deadtimer < 8
							scale = ease.outsine((FU/8)*takis.deadtimer,0,20*FU)
						end
					end
				end
				scale = max(0,scale)
				v.drawScaled(160*FU,100*FU+(thok.height*scale/2),scale,
					thok,
					V_SUBTRACT,
					v.getColormap(nil,p.skincolor)
				)

					if TR - mo.deathfunny == TR*2/3
						mo.thok.destscale = 0
						mo.thok.scalespeed = FixedDiv(mo.thok.scale,(TR - (TR*2/3))*FU)
					end
					
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
							MT_TAKIS_EXPLODE,
							15,20
						)
						SpawnEnemyGibs(mo,mo)
						for i = 0,3
							S_StartSound(mo,sfx_tkapow)
						end
						P_RemoveMobj(mo.thok)
						mo.thok = nil
					end
*/

--Ringracers
addHook("MobjThinker",function(ki)
	if TAKIS_NET.noeffects
		P_RemoveMobj(ki)
		return
	end
	
	if (ki.tracer and ki.tracer.valid)
		if (ki.tracer.player and ki.tracer.player.valid)
			if ki.tracer.player.takistable
			and ki.tracer.player.takistable.deathfunny
			and TakisIsScreenPlayer(ki.tracer.player)
			and CV_FindVar("showhud").value
			and gametype ~= GT_SAXAMM
				ki.flags2 = $|MF2_DONTDRAW
			else
				ki.flags2 = $ &~MF2_DONTDRAW
			end
		end
		
		ki.color = ki.tracer.color
		ki.blendmode = AST_SUBTRACT
		
		--?????
		local func = P_MoveOrigin
		if not ki.interp
			func = P_SetOrigin
			ki.interp = true
		end
		func(ki,
			ki.tracer.x,ki.tracer.y,
			ki.tracer.z - (ki.height/2)
		)
	
		ki.threshold = $ or TR
		ki.scalemul = $ or FU
		
		local tics = ki.threshold - ki.tics
		local scale = ki.tracer.scale*32
		local fadeout = ki.threshold*2/3
		local fadeout2 = ki.threshold - (ki.threshold*2/3)
		
		if tics > fadeout
			tics = $ - fadeout
			scale = ease.outsine((FU/fadeout2)*tics,ki.tracer.scale*32,0)
		elseif tics < 8
			scale = ease.outsine((FU/8)*tics,0,ki.tracer.scale*32)
		end
		
		scale = FixedMul($,ki.scalemul)
		P_SetScale(ki,scale)
		P_MoveOrigin(ki,
			ki.tracer.x,ki.tracer.y,
			ki.tracer.z - (ki.height/2)
		)
		
	else
		P_RemoveMobj(ki)
	end
	
end,MT_TAKIS_BROLYKI)

addHook("MobjDeath",function(ki,_,_)
	return true
end,MT_TAKIS_BROLYKI)

TAKIS_FILESLOADED = $+1