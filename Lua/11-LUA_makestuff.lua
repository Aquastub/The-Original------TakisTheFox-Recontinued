/*	HEADER
	Iterators that give mobjs special attributes when they spawn
	
*/

local forcepspritesskins = {
	[MT_ROSY] = {"amy",SKINCOLOR_ROSY},
}

local MOBJ_LIST = {
	--ring types
	[1] = {
		mobjs = {
			MT_RING,
			MT_COIN,
			MT_BLUESPHERE,
			MT_TOKEN,
			MT_EMBLEM,
			MT_BOUNCERING,
			MT_RAILRING,
			MT_INFINITYRING,
			MT_AUTOMATICRING,
			MT_EXPLOSIONRING,
			MT_SCATTERRING,
			MT_GRENADERING,
			MT_REDTEAMRING,
			MT_BLUETEAMRING
		},
		hook = "MobjSpawn",
		func = function(mo)
			mo.takis_givecombotime = true
			if mo.type == MT_RING
			or mo.type == MT_COIN
			or mo.type == MT_BLUESPHERE
			or mo.type == MT_TOKEN
			or mo.type == MT_REDTEAMRING
			or mo.type == MT_BLUETEAMRING
				mo.takis_ringtype = true
			end
		end,
	},
	--flingables
	[2] = {
		mobjs = {
			MT_EGGROBO1,
			MT_ROSY,
		},
		hook = "MobjSpawn",
		func = function(mo)
			if not mo
			or not mo.valid
				return
			end
			
			mo.takis_flingme = true
			
			if mo.type == MT_ROSY
				mo.flags = $|MF_ENEMY
			end
		end
	},
	--non flingables
	[3] = {
		mobjs = {
			MT_EGGMAN_GOLDBOX,
			MT_EGGMAN_BOX,
			MT_BIGMINE,
			MT_SHELL,
			MT_STEAM,	--thz steam
			--strange divide by 0 with one of these 2
			MT_ROLLOUTSPAWN,
			MT_ROLLOUTROCK,
			MT_DUSTDEVIL,
			MT_DUSTLAYER,
		},
		hook = "MobjSpawn",
		func = function(mo)
			if not mo
			or not mo.valid
				return
			end
			
			mo.takis_flingme = false
		end
	},
	--shield types
	[4] = {
		mobjs = {
			MT_ELEMENTAL_ORB,
			MT_ATTRACT_ORB,
			MT_FORCE_ORB,
			MT_ARMAGEDDON_ORB,
			MT_WHIRLWIND_ORB,
			MT_PITY_ORB,
			MT_FLAMEAURA_ORB,
			MT_BUBBLEWRAP_ORB,
			MT_THUNDERCOIN_ORB,
		},
		hook = "MobjThinker",
		func = function(shield)
			if not shield
			or not shield.valid
				return
			end
			
			if not shield.target
			or not shield.target.valid
				return
			end
			
			local p = shield.target.player
			local me = shield.target
			local takis = p.takistable
			
			if takis
				if (me.skin == TAKIS_SKIN)
					shield.stretched = true
					shield.spritexscale,shield.spriteyscale = me.spritexscale,me.spriteyscale
					shield.spriteyoffset = me.spriteyoffset
				else
					if (shield.stretched)
						shield.spritexscale,shield.spriteyscale = FU,FU
						shield.spriteyoffset = 0
						shield.stretched = false
					end
				end
			end
			
			--multi layered
			if (shield.tracer and shield.tracer.valid)
				local overlay = shield.tracer
				overlay.spritexscale,overlay.spriteyscale = shield.spritexscale,shield.spriteyscale
				overlay.spriteyoffset = shield.spriteyoffset
			end
		end
	},
	--laughing types
	[5] = {
		mobjs = {
			MT_EMERALD1,
			MT_EMERALD2,
			MT_EMERALD3,
			MT_EMERALD4,
			MT_EMERALD5,
			MT_EMERALD6,
			MT_EMERALD7,
			MT_TOKEN,
			
			MT_BLUEFLAG,
			MT_REDFLAG,
			
			MT_EMBLEM,
			
			MT_1UP_BOX,
			MT_SCORE10K_BOX,
		},
		hook = "MobjDeath",
		func = function(gem,_,tak)
			if not (gem and gem.valid) then return end
			if not (tak and tak.valid) then return end
			if (tak.skin == TAKIS_SKIN)
				S_StartAntonLaugh(tak)
			end
		end	
	},
	--reg gibs
	[6] = {
		mobjs = {
			MT_FANG,
			MT_ROSY,
		},
		hook = "MobjSpawn",
		func = function(mo)
			if not (mo and mo.valid) then return end
			mo.takis_metalgibs = false
		end
	},
	--amy ragdolls
	[7] = {
		mobjs = {
			MT_ROSY,
		},
		hook = "MobjSpawn",
		func = function(mo)
			if not (mo and mo.valid) then return end
			
			--2.2.14 already has SPR2_PLAY
			if (VERSION == 202)
			and (SUBVERSION >= 14)
				return
			end
			
			mo.takis_playerragsprites = true
			if forcepspritesskins[mo.type] ~= nil
				mo.takis_playerragskin = forcepspritesskins[mo.type][1]
				if mo.color == SKINCOLOR_NONE
					mo.takis_playerragcolor = forcepspritesskins[mo.type][2]
				else
					mo.takis_playerragcolor = mo.color		
				end
				mo.takis_playerragcolorized = mo.colorized
			end
		end
	},
}	

for i = 1,#MOBJ_LIST
	local data = MOBJ_LIST[i]
	
	for k,motype in ipairs(data.mobjs)
		addHook(data.hook,data.func,motype)
	end
	
	print("Completed making things special. ("..i.."/"..#MOBJ_LIST..")")
end

TAKIS_FILESLOADED = $+1