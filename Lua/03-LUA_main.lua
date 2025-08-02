/*
	--CODE TODO
	-[done]afterimages. not pt, antone blast :)
	-[done]wavedashing lol (nick wants this)
	-[done]fix up sort hitbox (uughghhh)
	-[done]combo stuff (ghiugdjk)
	-[done]erm, death messages
	-[done]make sure stuff slike clutch works in nonfriendly w/o ff
	-[done]hide hud in specialstages
	-[done]alt yellow for combo meter
	-[scrapped]do hud styles like modernsonic and toggling like mrce
	-[done]add sunstroke. already got the texasarea net
	-[done]port hud stuff to customhud
	-[done]give spikeballs a deathstate
	-[done]make freezing actually kill you
	-[done]freeze combo while finished in pizza time
	-[done]movecollide for springs to keep momentum (booster boost)
	-[done]stupid thinkframe for detecting PF_SLIDING
	-[done]also make speedpad sectors keep momentum
	-[done]reuse soap code for ptje ranks
	-[scrapped]wall bonk lol
	-[done? what did this mean]add bot stuff
	-[done]happy hour for other skins?
	-[done]fc stuff?
	-[done]custom arma to bbreak more stuff (like spikes)
	-[done]PASSWORD!!!
	-[done]make recov jump not rely on flashing
	-[done]dont kill team boxes on other teams
	-[done]conga?
	-[done]string the combo bar into 1, long graphic, use cropped to crop?
	-[done]tf2 taunt menu
	-[scrapped]countdown nums for drawtimer
	-[done?]instant finishes in multiplayer, prob after a special stage, most
	 noticable in stages with capsules
	-[done]make heartcards give score at the end
	-[done]maybe increase the homerun bat hitbox? because, yknow, the hammer
	 is big
	-[done]cursor style for the taunt menu, nums <-> cursor
	-[done? what was this referring to?]crit sfx
	-[scrapped]war timer and war timer custom gfx
	-[done]RETRO STATUSFACE FOR MARIO TOLS
	-[done]save after loading to remove invalid saves
	-[done]save during exiting
	-[done]finish death anims
	-[done]cosmenu like soap's
	-[scrapped]homework varient of happy hour
	-[done]toggle for loud and dangerous taunts
	-[scrapped]taunt_t info?
	-[scrapped]rs neo stuff for taunt functions
	-[done]fix io quicktaunts being broken
	-dont let quick taunts spam "you cant do this"
	-[done]MORE WIND LINES
	-[done]little icon above people with cosmenus open'
	-[done]cosmenu "dear pesky plumbers..." letter
	-[done? what was this reffering to?]update customhud init funcs
	-[done]find out whats making the erz1 fof conveyors hyperspeed
	-[done]only sweat if we're running
	-[scapped]make a function to add takis_menu pages
	-[scrapped]move all hud related code in shorts to their respective hud
	 drawing function
	 actually,, maybe dont, thatll make it fps dependant
	-[scrapped]spingebobb #1 hat option
	-[done]add cosmenu scolling
	-[done]when counting num destroyables, add a var to the mobj to mark it
	 as yet-to-be-destroyed. only increase thingsdestroyed if that
	 var is true
	-[done]make sure shields function properly
	-[scrapped]optional paperdoll over statusface
	-[done]pw_strong?
	-[done]still break other types of "spikes" alongside STR_SPIKE
	-[scrapped]milne kick
	-[done]taunt icons
	-ach icons
	-[done]move all takis.HUD editting code from LUA_hud to TakisHUDStuff
	-[scrapped]set takis.issuperman to random when nightserized, if true,
	 spawn a superman cape
	-[scrapped]if the Verys draw past the bottom of the screen, only draw 1 and
	 put a x3240 for the # of Verys
	-maybe give all hud elements V_PERPLAYER??
	-[done]fix the clutch being slow with smaller scales
	-MORE EFFECTS!!
	-[scrapped]placements in drawscore?
	-[done]happy hour trigger and exit objects
	-[done??]dedicated servers may be breaking heart cards?
	-[done]rings give too much score
	-[done?]we may be loading other people's cfgs??
	-[done]offset afterimages to start at salmon
	-[done?]sometimes shotgun shots dont give combo?
	-[done]cap clutch boosts at 5
	-[done]linedef trigger to open dialog
	-[done]pt spice runners support
	-[done]replace menu patches with drawfill
	-[done?]takisfest ach being buggy as hell, keeps doign every tiem
	-[done]redo the cos menu. antonblast styled?
	-[done]remove disciplinary action
	-[done]happy hour is weird when it is synched
	-[done]replace hud items only when switching, like engi
	-[done but better]cosmenu scrolling if text goes past hints
	-[done?]sometimes the PTSR bar doesnt show with nohappyhour?
	-[done]synch happy hour for joining players
	-[done]transformations
	-[scrapped]bat taunt keeps colorization if interuppted
	-[scrapped]textspectator hud stuff
	-[pretty much done]shields are squished with pancake
	-[done?]wtf is resynching & crashing servers!?? DEBUG!!!!
	-[done?]death slam not activating sometimes
	-[done]remove fc stuf
	-fling solids kill stuff
	-[done]thoks respawn flung solids
	-[done]switch all the takismusic funcs back to normal S_Sound stuff
	-[done]happy hour quakes not working
	-[done]bubbles reset state and stuff
	-[done]use takis.HUD.flyingscore to align all the rank stuff
	-[done?]2d mode is SHIT!! fix weird state bugs
	-[done?]SHIT IS STILL RESYNCHING!!
	-[done]fireass in nights freeroam
	-[scrapped]hitlag?
	-[done]clutch speed adjustmensts fro 2d & underwater
	-[done]killing blow sfx when clutching into
	-[done]ambush makes shotgun boxes gold
	-[done]metal detector to remove shotgun
	-[done]happyhour mus vars arent used in musichange if hh is activated
	 on spawn
	-[done]you can still clutch in waterslides
	-[done?]make gibs face screen in 2d instead of being a straight line
	-[done]bots can give takis leaders combo
	-[done]ujl coop score thing for combo sharing
	-[done but better]make the server execute a command when cheats are activated to
	 set a var in TAKIS_NET
	-[done]replace all dust effects with the cool funny takis_steam
	-[done]the weird *[Splash] bug with dustdevils
	-[done]make shotgun scatters their own MT_
	-[done]mt_gunshot sprites
	-[done]birdword timing and 2nd part
	-[done]skidding spawn takis dust
	-[done]no afterimages when clutching out of a slide
	-[done]no pt happy hour is broken
	-[done]since cardbump is client-side, maybe we could use S_MusicPosition
	 to get more accurate measurements?
	-[scrapped]takis things use udmf args too, man nvm udmf sucks ass
	-[done?]pacifist ach
	-[done? i dont rememver LMAO]revert rag hitboxes
	-[done but shitily]chaingun shotgon on shotgun in CanPlayerDaagePlater
	-[done]show "Show lives" when already tweened out
	-[done]limit letter to takis
	-[done]takis hh end shakes more than others
	-[done]corpse faces same angle
	-[done]teleport corpse with momentum
	-[done]shotgun forceon doenst work
	-[done]fix ach page overscroll
	-[done]no recov jump in bm
	-[done]explosion effects
	-update all maps to use udmf
	-[done?]getting hit and drrr instakill cause desynchs?
	-[done]somethings resetting our state constantly, noticable when sliding
	-[done?]HH in ptsr seems to be causing desynchs?
	-[done?]effects use a LOT of thinker time
	-just general resynchs? not as frequent as before, but still there
	-[done]convert thinkers that just do 1 thing for 1 mobj into state actions
	-REMOVE FORCE STRAFE
	-[done]dont rollangle effects with takis_noeffects
	-[done]P_SpawnMobjFromMobj's x/y/z distance values are scaled to origin's
	 scale, correct all weird offsets to be divided by scale
	 (me.height -> FixedDiv(me.height,me.scale)
	-[done]redo bonuses hud to prevent desynch
	-[done]different skid frames if braking while afterimaging or not
	-[done]weird sigfpe's in software
	-[done]some stuff adjusted for control styles (like ball in auto.) ((but
	 tbf automatic sucks ass if you play it you needa kill yourself))
	-make viewmodel angle adjust client side and handled in hud
	 because ping makes it look a little weird
	-[done]some dust effects are too large at smaller scalees
	
	--ANIM TODO
	-[done]redo smug sprites
	-[scrapped]reuse spng for jump
	-the tail on roll frames doesnt point the right way
	-redo walk 4th angle
	-[done]retro faces for the new faces
	-[done]redo tailees dead
	-BOSS TITLE SHIT!!!
	-[done]stun anim
	-[done]specki BLOX anims
	-[done]crate gibs
	-[done]driftspark papersprites
	
	--PLANNED MAPHEADERS
	--document this in some sorta manual on the mb page?
	-[done]Takis_HH_Music - regular happyhour mus, ignore styles
	-[done]Takis_HH_EndMusic - ending happyhour mus, ignore styles
	-[done]Takis_HH_NoMusic - disable happyhour mus
	-[done]Takis_HH_NoEndMusic - disable happyhour end mus
	-[done]Takis_HH_Timelimit - timelimit (in seconds)
	-[done]Takis_HH_NoInter - disable the intermission screen
	-[done]Takis_HH_NoHappyHour - disable allhappyhour from doin the lvl
	-Takis_HH_NoClang - disable mysterious clanging
	-[done]Takis_HH_Exit_[x,y,z] - exit pos
	-[done]Takis_HH_Trig_[x,y,z] - trigger pos
	
	--OTHER SHIT
	-update tut map for new transfos and fix stuff
	-make takis work for 2.2.15
	
*/

--leave some invuln for the rest of the cast, you greedy jerk!
local flashingtics = flashingtics/2

--thanks katsy for this function
local function stupidbouncesectors(mobj, sector)
    for fof in sector.ffloors()
        if not (fof.fofflags & FOF_BOUNCY) and (GetSecSpecial(fof.master.frontsector.special, 1) != 15)
            continue
        end
        if not (fof.fofflags & FOF_EXISTS)
            continue
        end
        if (mobj.z+mobj.height+mobj.momz < fof.bottomheight) or (mobj.z-mobj.momz > fof.topheight)
            continue
        end
        return true
    end
end
local function choosething(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end

--from clairebun
local function collide2(me,mob)
	if me.z > (mob.height*2)+mob.z then return false end
	if mob.z > me.height+me.z then return false end
	return true
end
local function LaunchTargetFromInflictor(type,target,inflictor,basespeed,speedadd)
	if (string.lower(type) == "instathrust") or type == 1
		P_InstaThrust(target, R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y), basespeed+(speedadd))
	else
		P_Thrust(target, R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y), basespeed+(speedadd))
	end
end
--also lazy
local function MeSoundHalfVolume(sfx,p)
	S_StartSoundAtVolume(nil,sfx,4*255/5,p)
end

local function spillrings(p,spillall)
	if p.takistable.inSaxaMM
		return
	end
	
	if p.rings
		S_StartSoundAtVolume(p.mo,sfx_s3kb9,255/2)
		local spillamount = 32
		if not (p.realmo.health)
		or (p.takistable.heartcards == 0)
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

local ranktonum = {
	["P"] = 6,
	["S"] = 5,
	["A"] = 4,
	["B"] = 3,
	["C"] = 2,
	["D"] = 1,
}

--"Trust me, I'm a programmer."
--theres GOTTA be a better way to do this
local emdex = {
	[0] = 0,
	[EMERALD1] = 1,
	[EMERALD1|EMERALD2] = 2,
	[EMERALD1|EMERALD2|EMERALD3] = 3,
	[EMERALD1|EMERALD2|EMERALD3|EMERALD4] = 4,
	[EMERALD1|EMERALD2|EMERALD3|EMERALD4|EMERALD5] = 5,
	[EMERALD1|EMERALD2|EMERALD3|EMERALD4|EMERALD5|EMERALD6] = 6,
}

addHook("PreThinkFrame",function()
	for p in players.iterate
		if not p
		or not p.valid
			continue
		end
		
		--p.HAPPY_HOURscream = {}
		
		if not p.takistable
			continue
		end
		
		local me = p.realmo
		local takis = p.takistable
		
		takis.lastpos.prethink = {
			x = p.realmo.x,
			y = p.realmo.y,
			z = p.realmo.z,
			momx = p.realmo.momx,
			momy = p.realmo.momy,
			momz = p.realmo.momz
		}
		takis.lastangle = p.cmd.angleturn << 16
		takis.lastaiming = p.aiming
		
		--handle input stuff here now because ermmmm
		--pw_nocontrol stuff
		
		if takis.noability
			--DO NOT USE THIS
			p.takis_donotuse_nothok = (takis.noability & NOABIL_THOK)
			takis.noability = 0
		end
		if (p.takis_noabil ~= nil)
			takis.noability = $|p.takis_noabil
			takis.lastminhud = takis.io.minhud
			takis.io.minhud = 0
		end
		
		--TakisDoNoabil(p,me,takis)
		TakisButtonStuff(p,takis)
		TakisBotThinker(p)
		if not takis.cosmenu.menuinaction
			takis.kart.jump = p.cmd.buttons & BT_JUMP
			takis.kart.sidemove = p.cmd.sidemove
			takis.kart.forwardmove = p.cmd.forwardmove
		end
		
		if (me and me.valid)
			if P_IsObjectOnGround(me)
			and not P_CheckDeathPitCollide(me)
			and not takis.pitanim
			and not P_InQuicksand(me)
			and not (p.onconveyor)
				if not ((me.eflags & MFE_TOUCHWATER) and not ((me.eflags & MFE_UNDERWATER) or (P_IsObjectInGoop(me))))
					takis.lastgroundedpos = {me.x,me.y,me.z,takis.gravflip}
					takis.lastgroundedangle = me.angle
				end
			end
			
			if takis.use == 1
			and p.powers[pw_carry] == CR_ROPEHANG
			and me.skin == TAKIS_SKIN
				me.momz = $+(P_GetMobjGravity(me)*takis.gravflip)
				me.z = $-(me.scale*takis.gravflip)
				takis.ropeletgo = TR/2
			end
			
			if (me.eflags & MFE_JUSTHITFLOOR)
				takis.timetouchingground = $+1
			else
				takis.timetouchingground = 0
			end
			
			takis.justHitFloor = takis.timetouchingground == 1
		end
		
		if (takis.cosmenu.menuinaction)
			TakisMenuThinker(p)
		end
		
		if (takis.transfo & TRANSFO_TORNADO)
		and not (takis.nadocrash)
			local force = 50
			--brake a bit
			if P_GetPlayerControlDirection(p) == 2
				force = $-((25-p.cmd.forwardmove)/2)
				force = min(50,$)
			end
			p.cmd.forwardmove = force
			p.cmd.sidemove = $/2
		end
		
		if (takis.freeze.tics)
			p.cmd.forwardmove,p.cmd.sidemove = 0,0
		end
		
		if (p.inkart)
		and (p.realmo.tracer and p.realmo.tracer.valid)
		and (p.realmo.tracer.iskart)
		and not (p.realmo.tracer.stasis or p.realmo.tracer.flags & MF_NOTHINK)
			if not (p.ai or p.bot)
				p.cmd.angleturn = p.realmo.tracer.angle >> 16
				p.realmo.angle = p.realmo.tracer.angle
				p.pflags = $|PF_STASIS
			end
			--P_MoveOrigin(
		end
		
	end
end)

addHook("PlayerThink", function(p)
	if not p
	or not p.valid
		return
	end
	
	if not p.takistable
		TakisInitTable(p)
		--return
	end
	
	if not p.takistable.io.loaded
	and not (p.bot or p.ai)
		if p.takistable.io.loadwait
			p.takistable.io.loadwait = $-1
		else
			--p.takistable.io.savestate = 1
			--Higher loadwait so we don't try to load again before
			--we've even loaded in
			p.takistable.io.loadwait = 3*TR
			TakisLoadStuff(p)
			p.takistable.io.loadtries = $+1
		end
	end
	
	if not (p.takistable.io.loadedach)
		p.takistable.io.loadedach = true
		TakisLoadAchievements(p)
	end
	
	--whatev
	p.takistable.isTakis = skins[p.skin].name == TAKIS_SKIN
	
	if ((p.realmo) and (p.realmo.valid))
		local me = p.realmo
		local takis = p.takistable
		
		if (me.flags & MF_NOTHINK)
		and not ((gametype == GT_PTSR or HAPPY_HOUR.othergt and HAPPY_HOUR.gameover) or gametype == GT_ZE2)
			return
		end
		
		if (not p.exiting)
		and takis.camerascale
			p.camerascale = takis.camerascale
			takis.camerascale = nil
		end
		
		local nodeshotgun = false
		if p.takis
		and (takis.isTakis)
			--shotgun monitor
			if p.takis.shotgunnotif
				if (takis.c3)
					TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.shotgunnotif)
					p.takis.shotgunnotif = 1
					nodeshotgun = true
				end
				p.takis.shotgunnotif = $-1
			else
				p.takis = nil
			end
		end
		
		TakisBooleans(p,me,takis,TAKIS_SKIN)
		
		--ffoxd's smoothspintrilas
		--here now because of kart
		do
			if not takis.prevz
			or not me.prevleveltime 
			or (me.prevleveltime ~= leveltime - 1) then
			   takis.prevz = me.z
			end

			local rmomz = me.z - takis.prevz
			me.prevleveltime = leveltime
			
			takis.rmomz = rmomz
		end
		
		--more accurate speed thing
		takis.accspeed = FixedDiv(abs(FixedHypot(p.rmomx,p.rmomy)), me.scale)
		if (CR_GRINDRAIL)
		and p.powers[pw_carry] == CR_GRINDRAIL
			local momx,momy = takis.railing.new.x - takis.railing.x, takis.railing.new.y - takis.railing.y
			takis.accspeed = FixedDiv(abs(FixedHypot(momx,momy)), me.scale)
			takis.rmomz = -(takis.railing.new.z - takis.railing.z)
		end
		takis.gravflip = P_MobjFlip(me)
		
		TakisHappyHourThinker(p)
		
		if me.skin == TAKIS_SKIN
			
			/*
			takis.HUD.happyhour.its.patch = "TAHY_ITS"
			takis.HUD.happyhour.happy.patch = "TAHY_HAPY"
			takis.HUD.happyhour.hour.patch = "TAHY_HOUR"
			*/
			
			--forced strafe
			/*
			if takis.io.nostrafe == 0
			and (takis.notCarried)
			and not ((p.pflags & (PF_SPINNING|PF_STASIS))
			or (p.powers[pw_nocontrol] or takis.nocontrol))
			and (takis.notCarried)
			and not (takis.dived and me.state == S_PLAY_GLIDE)
			and not (p.inkart)
				p.drawangle = me.angle
			end
			*/
			
			local shouldntcontinueslide = false
			--if something youre looking for isnt here, theres a good
			--chance that its in shorts!
			TakisDoShorts(p,me,takis)
			
			takis.afterimaging = false
			takis.applyfriction = true
			
			--skin name then sfx
			p.happyhourscream = {skin = TAKIS_SKIN,sfx = sfx_hapyhr}
			
			--just switched
			if (takis.otherskin)
				/*
				p.pflags = $ &~PF_INVIS
				*/
				if takis.transfo
					takis.transfo = 0
					me.colorized = false
					takis.spritexscale,takis.spriteyscale,
					me.spritexscale,me.spriteyscale = FU,FU,FU,FU
					me.spriteyoffset = 0
				end
				takis.otherskin = false
				takis.otherskintime = 0
			end
			
			if not (p.powers[pw_invulnerability])
				p.scoreadd = 0
			end
			
			/*
			if takis.c3 == 1
				for i = 0,6
					local soda = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_SPIRIT)
					soda.tracer = me
					soda.emeralddex = i
					takis.spiritlist[soda.emeralddex] = soda
				end
			end
			*/
			

			
		 	if (takis.dived and me.state == S_PLAY_GLIDE)
				p.drawangle = TakisMomAngle(me)
			end
			
			if (p.inkart)
				takis.bashtime = 0
			end
			
			if (takis.bashtime)
				takis.bashtime = $-1
				takis.noability = $|NOABIL_SLIDE|NOABIL_SHOTGUN
				local doswitch = true
				if (me.state == S_PLAY_JUMP)
					me.state = S_PLAY_TAKIS_SHOULDERBASH_JUMP
					doswitch = false
				end
				
				if (me.state == S_PLAY_TAKIS_SHOULDERBASH)
					if (me.tics > takis.bashtics)
					and (me.tics ~= takis.bashtics)
					and (takis.bashtics >= 4)
						me.tics = takis.bashtics-4
					end
					takis.bashtics = me.tics
				end
				
				
				local instates = (me.state == S_PLAY_TAKIS_SHOULDERBASH) or (me.state == S_PLAY_TAKIS_SHOULDERBASH_JUMP)
				if not instates
				and doswitch
					takis.bashtime = 0
				end
				
				if (takis.accspeed <= 15*FU)
					me.state = S_PLAY_FALL
					TakisResetState(p)
					S_StopSoundByID(me,sfx_shgnbs)
					takis.bashtime = 0
					takis.bashcooldown = true
				elseif takis.accspeed > 55*FU
					me.momx,me.momy = $1*4/5,$2*4/5
				end
				
			else
				if takis.bashtics ~= 0
					takis.bashtics = 0
				end
			end
			
			--nights stuff
			if (maptol & TOL_NIGHTS)
				if not multiplayer
					if p.powers[pw_carry] == CR_NIGHTSMODE
						if HAPPY_HOUR.happyhour
							if p.exiting
								takis.nightsexplode = true
								HH_Reset()
								P_RestoreMusic(p)
							end
						end
					elseif (p.powers[pw_carry] ~= CR_NIGHTSMODE)
					or (p.powers[pw_carry] == CR_NIGHTSFALL)
						if HAPPY_HOUR.happyhour
						and not p.nightstime
							if p.exiting
								takis.nightsexplode = true
								HH_Reset()
								P_RestoreMusic(p)
							end
						end
					
					end
					
					/*
					if HAPPY_HOUR.happyhour
					and not (takis.gotspirit and takis.gotspirit.valid)
					and (emdex[emeralds] ~= nil)
						takis.gotspirit = P_SpawnMobjFromMobj(me,0,0,0,MT_TAKIS_SPIRIT)
						--i would use some bitmath but i cant figure
						--out exactly how to get the decimal
						takis.gotspirit.emeralddex = emdex[emeralds]
						takis.gotspirit.tracer = me
					end
					*/
				end
				if p.powers[pw_carry] == CR_NIGHTSMODE
					
					if (p.exiting)
						
						--fancy explosions for HH
						if takis.nightsexplode
							if (P_RandomChance(FU/(max(2,50-(p.exiting/2)))))
								local fa = FixedAngle(P_RandomRange(0,360)*FU)
								local range = 300 + P_RandomRange(0,50)
								local xvar = 50*P_RandomRange(1,3)
								local yvar = 50*P_RandomRange(1,3)
								
								local thok = P_SpawnMobjFromMobj(me,
									P_ReturnThrustX(nil,fa,range*me.scale)+P_RandomRange(-xvar,xvar)*me.scale,
									P_ReturnThrustY(nil,fa,range*me.scale)+P_RandomRange(-yvar,yvar)*me.scale,
									P_RandomRange(-yvar,yvar)*me.scale,
									MT_RAY
								)
								thok.state = S_TAKIS_EXPLODE
								thok.scale = P_RandomRange(1,5)*FU+P_RandomFixed()
								thok.scale = $/2
								thok.spawnedfrom = true
								thok.flags = $|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPTHING
								thok.momz = 0
								thok.fancyexplode = true
								
								/*
								thok.flags2 = $|MF2_DONTDRAW
								
								TakisFancyExplode(thok,
									thok.x, thok.y, thok.z,
									P_RandomRange(60,64)*thok.scale,
									1,
									MT_TAKIS_EXPLODE,
									15,20
								)
								
								A_BossScream(thok,1,choosething(MT_BOSSEXPLODE,MT_SONIC3KBOSSEXPLODE))
								*/
								
								local sfx = P_SpawnGhostMobj(thok)
								sfx.flags2 = $|MF2_DONTDRAW
								sfx.tics = TR/4
								sfx.fuse = TR/4
								S_StartSound(sfx,sfx_tkapow)
							end
							
						end
						
						if (p.exiting <= 45)
						and (me.health)
						--ends your run?
						and not ultimatemode
							P_KillMobj(me)
							S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET4])
							me.frame = A
							me.sprite2 = SPR2_TDED
							for i = 1, 6
								A_BossScream(me,1,MT_SONIC3KBOSSEXPLODE)
							end
							S_StartSound(me,sfx_tkapow)
							DoQuake(p,me.scale*8,10,8*me.scale)
							takis.altdisfx = 3
							
						end
					end
				end
			else
				if (takis.nightsexplode)
					takis.nightsexplode = false
				end
			end
			
			--add ffoxD's FFDMomentum here because its awesome
			if (p.cmd.forwardmove or p.cmd.sidemove)
			and takis.accspeed >= p.normalspeed
			and me.friction < FU
			and not takis.inSRBZ
				me.friction = FU
			end
			
			if me.friction > 29*FU/32
				if not (takis.frictionfreeze)
					--if not (leveltime % 4)
					if takis.onGround
					and not p.powers[pw_sneakers]
						me.friction = $-(FU/200)
					end
				else
					takis.frictionfreeze = $-1
					if takis.accspeed >= 80*FU
						takis.frictionfreeze = $/2
					end
				end
			end
			
			--spin specials
			if (takis.use > 0 or takis.inSRBZ and takis.c2 > 0)
			and p.powers[pw_carry] ~= CR_NIGHTSMODE
				
				if (not takis.shotgunned)
					--clutch
					if takis.use == 1
					/*
					and (takis.onGround or 
					(takis.coyote/2 > 0
					and not (p.pflags & (PF_JUMPED|PF_JUMPSTASIS|PF_THOKKED))))
					*/
					and (takis.onGround)
					and not takis.taunttime
					and me.health
					and (me.state ~= S_PLAY_GASP)
					and (me.sprite2 ~= SPR2_PAIN)
					and not PSO
					and not (takis.yeahed)
					and (p.realtime > 0)
					and not (takis.c2 and me.state == S_PLAY_TAKIS_SLIDE)
					and not (takis.noability & NOABIL_CLUTCH)
						
						TakisDoClutch(p)
						
					end
					
					--hammer blast
					if takis.use == (TR/5)
					and not takis.onGround
					and not takis.hammerblastdown
					and not (takis.inPain or takis.inFakePain)
					and me.health
					and (takis.notCarried)
					and not (takis.noability & NOABIL_HAMMER)
					and not (takis.bombdive.started)
						S_StartSoundAtVolume(me,sfx_airham,3*255/5)
						takis.hammerblastdown = 1
						p.pflags = $|PF_THOKKED
						takis.thokked = true
						L_ZLaunch(me,
							10*skins[TAKIS_SKIN].jumpfactor
						)
						me.state = S_PLAY_MELEE
						me.tics = -1
						takis.hammerblastangle = p.drawangle
						p.pflags = $ &~PF_SHIELDABILITY
						p.jp = 1
						p.jt = 5
						--P_SetObjectMomZ(me,-9*FU)
					end
					
					--wavedash
					if takis.c3 == 1
					and takis.use < 13
					and takis.wavedashcapable
					and not (takis.noability & NOABIL_WAVEDASH)
						p.pflags = $ &~(PF_JUMPED)
						P_SetObjectMomZ(me,-8*FU)
						
						local ang = GetControlAngle(p)
						if takis.in2D
							ang = me.angle
						end
						P_InstaThrust(me,ang,FixedMul(takis.accspeed,me.scale)+14*me.scale)
						
						S_StartSoundAtVolume(me,sfx_takdiv,255/4)
						takis.ropeletgo = 5
						for i = 5, P_RandomRange(10,15)
							TakisDoWindLines(me,-8*me.scale*takis.gravflip,(takis.forcerakis and SKINCOLOR_PEPPER or nil))
						end
					end
				else
					
					local use = takis.use
					if takis.inSRBZ
						if not takis.use
							use = takis.c2
						end
					end
					
					--shotgun shot
					if ((use and TAKIS_NET.chaingun)
					or (use == 1 and not TAKIS_NET.chaingun))
					and not (takis.shotguncooldown and not TAKIS_NET.chaingun)
					and not (takis.inPain or takis.inFakePain)
					and not (takis.noability & NOABIL_SHOTGUN
					and not (takis.hammerblastdown)
					or p.pflags & PF_SPINNING)
						if (not TAKIS_NET.chaingun)
							P_Thrust(me,p.drawangle,-10*me.scale)
							P_MovePlayer(p)
							
							takis.shotguncooldown = 18
						else
							if use == 1
								P_Thrust(me,p.drawangle,-10*me.scale)
								P_MovePlayer(p)
								TakisAwardAchievement(p,ACHIEVEMENT_RIPANDTEAR)
							end
						end
						
						S_StartSound(me,sfx_shgns)
						
						TakisDoShotgunShot(p)
					end
					
				end	
				
			end
			
			--c1 specials
			if takis.c1 > 0
			and p.powers[pw_carry] ~= CR_NIGHTSMODE
			
				if not takis.shotgunned
					--dive
					--not to be confused with soap's dive!
					--mario dive
					if takis.c1 == 1
					and not takis.onGround
					and not (takis.dived)
					and (takis.notCarried)
					and me.state ~= S_PLAY_PAIN
					and me.health
					and not takis.hammerblastdown
					and not PSO
					and not (takis.noability & NOABIL_DIVE)
					and not (takis.bombdive.started)
					and not (takis.inPain or takis.inFakePain)
						takis.hammerblastjumped = 0
					
						local ang = GetControlAngle(p)
						S_StartSound(me,takis.inWater and sfx_splash or sfx_takdiv)
						
						--im not sure if this actually does anything
						--but it seems to work so im leaving it
						if ((me.flags2 & MF2_TWOD)
						or (twodlevel))
							if (p.cmd.sidemove > 0)
								ang = p.drawangle
							elseif (p.cmd.sidemove < 0)
								ang = InvAngle(p.drawangle)
							end
						end
						
						local speed = takis.accspeed
						if takis.accspeed < 20*FU
							speed = 20*FU
						end
						P_InstaThrust(me,ang,FixedMul(speed,me.scale))
						
						p.drawangle = ang
						--CreateWindRing(p,me)
						TakisSpawnDustRing(me,16*me.scale,0)

						p.pflags = $|PF_THOKKED &~(PF_JUMPED)
						takis.dived = true
						takis.thokked = true
						
						me.state = S_PLAY_GLIDE
						local momz = FixedDiv(me.momz,me.scale)*takis.gravflip
						local thrust = min((momz/2)+7*FU,18*FU)
						L_ZLaunch(me,thrust)
					end
					
				else
				
					--shoulder bash
					if takis.c1 == 1
					and not (takis.tossflag)
					and not takis.bashtime
					and not (takis.inPain or takis.inFakePain)
					and not (takis.hammerblastdown)
					and (me.state ~= S_PLAY_TAKIS_SLIDE)
					and not (takis.noability & NOABIL_SHOTGUN)
					and (takis.notCarried)
					and not takis.bashcooldown
						local ang = GetControlAngle(p)
						if ((me.flags2 & MF2_TWOD)
						or (twodlevel))
							if (p.cmd.sidemove > 0)
								ang = p.drawangle
							elseif (p.cmd.sidemove < 0)
								ang = InvAngle(p.drawangle)
							end
						end
						p.drawangle = ang
						
						local thrust = FixedMul(takis.accspeed,me.scale)+
								FixedMul(
									skins[TAKIS_SKIN].runspeed-takis.accspeed,
									me.scale
								)
						if (takis.accspeed >= skins[TAKIS_SKIN].runspeed)
							thrust = FixedMul(takis.accspeed,me.scale)
								+
								23*me.scale
						end
						
						if p.gotflag
							thrust = $/6
						end
						
						if twod
							thrust = $/4
						end
						
						local speedmul = FU
						if twod
							speedmul = $*3/4
						end
						if (takis.inWater)
						and not twod
							speedmul = $*3/4
						end
						if (p.gotflag)
							speedmul = $*7/10
						end
						
						P_InstaThrust(me,p.drawangle,FixedMul(thrust,speedmul))
						
						S_StartSound(me,sfx_shgnbs)
						P_MovePlayer(p)
						if (me.momz*takis.gravflip < 0)
							L_ZLaunch(me,3*FU)
						end
						me.state = S_PLAY_TAKIS_SHOULDERBASH
						
						takis.bashtime = TR
						
					end
					
				end
				
			end
			
			--quick taunts
			if ((takis.tossflag > 0) and ((takis.c2 > 0) or (takis.c3 > 0)))
			and takis.onGround
			and p.panim == PA_IDLE
			and takis.taunttime == 0
			and not takis.yeahed
			and not (takis.tauntmenu.open)
			and not takis.tauntreject
			--bug where holding tf + (c2/c3) + c1 will spam the taunt
			and (takis.c1 == 0)
				if ((takis.c2) and (not takis.c3))
					if takis.tauntquick1
						if ((TAKIS_TAUNT_INIT[takis.tauntquick1] ~= nil)
						and (TAKIS_TAUNT_THINK[takis.tauntquick1] ~= nil))
							if TakisIsTauntUsable(p,takis.tauntquick1)
								takis.tauntid = takis.tauntquick1
							
								--init func
								local func = TAKIS_TAUNT_INIT[takis.tauntquick1]
								func(p)
							end
						else
							if (takis.c2 == 1)
								S_StartSound(nil,sfx_notadd,p)
							end
						end
					else
						if (takis.c2 == 1)
							S_StartSound(nil,sfx_notadd,p)
						end
					end
				elseif ((takis.c3) and (not takis.c2))
					if takis.tauntquick2
						
						if ((TAKIS_TAUNT_INIT[takis.tauntquick2] ~= nil)
						and (TAKIS_TAUNT_THINK[takis.tauntquick2] ~= nil))
							if TakisIsTauntUsable(p,takis.tauntquick2)
								takis.tauntid = takis.tauntquick2
							
								--init func
								local func = TAKIS_TAUNT_INIT[takis.tauntquick2]
								func(p)
							end
						else
							if (takis.c3 == 1)
								S_StartSound(nil,sfx_notadd,p)
							end
						end
					else
						if (takis.c3 == 1)
							S_StartSound(nil,sfx_notadd,p)
						end
					end
				end
			end
			
			if takis.tauntreject
			and not (takis.c2 or takis.c3)
				takis.tauntreject = false
			end
			
			--tf2-styled taunt menu!
			if not (takis.tauntmenu.open)
				local menu = takis.tauntmenu
				menu.tictime = 0
				
				if ((takis.tossflag) and (takis.c1 == 1)
				or (takis.tossflag == 1 and takis.tossflag_R))
				and not ((takis.yeahed) or (takis.taunttime))
				and not p.spectator
					menu.yadd = 0 --500*FU
					menu.open = true
				end
				
				menu.cursor = 1
				
				if takis.weaponmasktime == 1
				and takis.weaponmask == 7
				and not takis.inSRBZ
				and not G_RingSlingerGametype()
				and not (p.spectator and takis.inSaxaMM)
					S_StartSound(me,sfx_wtsig2)
					
					local sigma = P_SpawnMobjFromMobj(me,
						0,0,GetActorZ(me,me,4),
						MT_THOK
					)
					sigma.tics = TR
					sigma.fuse = TR
					sigma.sprite = SPR_TMIS
					sigma.frame = U
					P_SetObjectMomZ(sigma,FU)
				end
				
			else
				local menu = takis.tauntmenu
				menu.tictime = $+1
				
				if not menu.closingtime
					--close
					if takis.c1 == 1
					or (takis.tossflag == 1 and takis.tossflag_R)
					or (p.playerstate ~= PST_LIVE)
						menu.closingtime = TR/2
					end
					
					if (takis.io.tmcursorstyle == 2)
						if (takis.weaponnext == 1)
							if (menu.cursor < 7)
								menu.cursor = $+1
							end
						end
						if (takis.weaponprev == 1)
							if (menu.cursor > 1)
								menu.cursor = $-1
							end
						end
					end
					
					local num = takis.weaponmask
					if (takis.io. tmcursorstyle == 2)
						num = menu.cursor
					end
					local id = menu.list[takis.weaponmask or menu.cursor]
					
					--set quick taunts
					if takis.tossflag
						
						--slot one
						if (takis.c2 == 1)
							--remove
							--delete quicktaunt
							if takis.fire
							and takis.tauntquick1
								takis.tauntquick1 = 0
								S_StartSound(nil,sfx_adderr,p)
								TakisSaveStuff(p)
							else
								local selectable = true
								if ((id == "") or (id == nil))
								or ((TAKIS_TAUNT_INIT[takis.weaponmask] == nil) or (TAKIS_TAUNT_THINK[takis.weaponmask] == nil))
									selectable = false
								end
								
								if selectable
								and takis.weaponmasktime
								and (takis.tauntquick1 ~= takis.weaponmask)
								and (takis.weaponmask ~= takis.tauntquick2)
									S_StartSound(nil,sfx_addfil,p)
									takis.tauntquick1 = takis.weaponmask
									TakisSaveStuff(p)
								end
							end
						--slot two
						elseif (takis.c3 == 1)
							--remove
							if takis.fire
							and takis.tauntquick2
								takis.tauntquick2 = 0
								S_StartSound(nil,sfx_adderr,p)
								TakisSaveStuff(p)
							else
								local selectable = true
								if ((id == "") or (id == nil))
								or ((TAKIS_TAUNT_INIT[takis.weaponmask] == nil) or (TAKIS_TAUNT_THINK[takis.weaponmask] == nil))
									selectable = false
								end
								
								if selectable
								and takis.weaponmasktime
								and (takis.tauntquick2 ~= takis.weaponmask)
								and (takis.weaponmask ~= takis.tauntquick1)
									S_StartSound(nil,sfx_addfil,p)
									takis.tauntquick2 = takis.weaponmask
									TakisSaveStuff(p)
								end
							end
						
						end 
					else
						--choose the taunt!
						if not (takis.c3)
							num = takis.weaponmask
							if (takis.io. tmcursorstyle == 2)
								num = menu.cursor
							end
							
							local selectable = true
							if ((id == "") or (id == nil))
							or ((TAKIS_TAUNT_INIT[num] == nil) or (TAKIS_TAUNT_THINK[num] == nil))
								selectable = false
							end
							
							if ( ((takis.weaponmasktime == 1) and (takis.io.tmcursorstyle == 1))
							or ((takis.firenormal == 1) and (takis.io.tmcursorstyle == 2)) )
							and selectable
							and takis.onGround
							and p.panim == PA_IDLE
							and takis.taunttime == 0
							and not takis.yeahed
							and TakisIsTauntUsable(p,num)
								takis.tauntid = num
								
								--init func
								local func = TAKIS_TAUNT_INIT[num]
								func(p)
								
								--close
								menu.open = false
							end
						--we're joining a partner taunt!
						elseif ((takis.c3 == 1) and not takis.tossflag)
							
							for p2 in players.iterate
								if p2 == p
									continue
								end
								
								local m2 = p2.realmo
								
								local dx = me.x-m2.x
								local dy = me.y-m2.y
								
								--in range!
								if FixedHypot(dx,dy) <= TAKIS_TAUNT_DIST
									if skins[p2.skin].name == TAKIS_SKIN
										if p2.takistable.tauntjoinable
										
											--we want their taunt number!
											takis.tauntid = p2.takistable.tauntid
											
											if (p2.takistable.tauntacceptspartners)
												takis.tauntpartner = p2
												p2.takistable.tauntpartner = p
											end
											
											local func = TAKIS_TAUNT_INIT[p2.takistable.tauntid]
											func(p)
											
											--If this taunt id has a func to run when we join it, do it
											if TAKIS_TAUNT_JOIN[p2.takistable.tauntid] ~= nil
												TAKIS_TAUNT_JOIN[p2.takistable.tauntid](p2,p)
											end
											
											--close
											menu.open = false
										end
									elseif skins[p2.skin].name == "inazuma"
										--Holy MOLY!
										TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.ultzuma)
										
										menu.open = false
									end
								end
								
							end
						end
					end
				--closing anim
				else
					menu.open = false
					menu.closingtime = 0
					/*
					menu.closingtime = $-1
					if menu.closingtime == 1
						menu.open = false
					end
					*/
				end
			end
			
			--c2 specials
			if takis.c2 > 0
			
				--slide
				if takis.c2 == 1
				and takis.c3 == 0
				and takis.onGround
				and not (p.pflags & PF_SPINNING)
				and takis.taunttime == 0
				and not takis.yeahed
		--		and (p.realtime > 0)
				and me.health
				and not ((takis.tauntmenu.open) and (takis.tossflag))
				and not (takis.inwaterslide or takis.resettingtoslide)
				and not (takis.noability & NOABIL_SLIDE)
				and takis.notCarried
					local ang = p.drawangle
					--manual mode
					if (p.pflags & (PF_ANALOGMODE|PF_DIRECTIONCHAR)) == PF_DIRECTIONCHAR
					and takis.io.nostrafe
						ang = me.angle
					end
					
					S_StartSound(me,sfx_eeugh)
					S_StartSound(me,sfx_taksld)
					takis.bashspin = 0
					
					/*
					local speed = 30*me.scale
					speed = FixedMul($,max(FU - FixedDiv(takis.accspeed,90*FU),0)) 
					
					P_Thrust(me, ang,
						speed
					)
					*/
					
					local thrust = 20*FU+(4*takis.accspeed/5)
					if thrust > 60*FU then thrust = 0 end
					thrust = FixedMul($,me.scale)
					if thrust
						P_InstaThrust(me,ang,thrust)
					end
					
					me.state = S_PLAY_TAKIS_SLIDE
					p.pflags = $|PF_SPINNING
					P_MovePlayer(p)
					if not ((p.cmd.forwardmove) and (p.cmd.sidemove))
					and takis.accspeed < 13*FU
						takis.slidetime = max(1,$)
						P_InstaThrust(me,ang,15*me.scale)
					end
					
					ang = TakisMomAngle(me)
					local d1 = P_SpawnMobjFromMobj(me, -20*cos(ang + ANGLE_45), -20*sin(ang + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
					local d2 = P_SpawnMobjFromMobj(me, -20*cos(ang - ANGLE_45), -20*sin(ang - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
					d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5
					d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
					for j = -1,1,2
						for i = 3,P_RandomRange(5,10)
							TakisSpawnDust(me,
								ang+FixedAngle(45*FU*j+TakisRandomFixed(0,0)),
								P_RandomRange(0,-50),
								P_RandomRange(-1,2)*me.scale,
								{
									xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									
									thrust = P_RandomRange(0,-10)*me.scale,
									thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									
									momz = (P_RandomRange(4,0)*i)*(me.scale/2),
									momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
									
									scale = me.scale,
									scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									
									fuse = 15+P_RandomRange(-5,5),
								}
							)
						end
					end
					
				end
				
				--cash in combo
				if (takis.c2 < 8)
				and ((takis.c1) and  (takis.c1 < 8))
				and (takis.combo.cashable)
					takis.combo.time = 0
				end
				
				if not takis.shotgunned
				
					--shield ability
					--team new
					local shielduse = takis.c2 == 1
					if (p.powers[pw_shield] & SH_NOSTACK == SH_FLAMEAURA)
						shielduse = takis.c2 >= 1
					end
					
					if shielduse
					and not takis.onGround
					--and (p.pflags & PF_JUMPED)
					and p.powers[pw_shield] ~= SH_NONE
					and not (takis.hammerblastdown)
						TakisTeamNewShields(p)
					end
					
					--bomb dive
					if takis.use < (TR/5)
					and takis.use
					and not takis.onGround
					and not takis.hammerblastdown
					and not (takis.inPain or takis.inFakePain)
					and me.health
					and (takis.notCarried)
					and not (takis.noability & NOABIL_HAMMER)
					and not (takis.bombdive.started)
					and not leveltime
						takis.bombdive.started = true
						p.pflags = $|PF_JUMPED|PF_THOKKED
						takis.thokked = true
						L_ZLaunch(me,
							FixedMul(15*FU,skins[TAKIS_SKIN].jumpfactor)
						)
						print("\x83TAKIS:\x80 bomb start")
					end
					
				else
					
					--shotgun stomp
					--literally just hammerblast lol
					if (takis.c2 == 1)
					and not takis.onGround
					and not (takis.shotguncooldown)
					and not (takis.hammerblastdown)
					and (takis.notCarried)
					and not (takis.inPain or takis.inFakePain)
					and not (takis.noability & NOABIL_SHOTGUN)
					and not (takis.inBattle)
						S_StartSound(me,sfx_shgns)
						
						p.jp = 1
						p.jt = 5
						
						takis.hammerblastdown = 1
						p.pflags = $|PF_THOKKED
						takis.thokked = true
						P_DoJump(p,false)
						L_ZLaunch(me,101*FU,true)
						
						TakisDoShotgunShot(p,true)
					end
				end
				
			end
			
			--c3 specials
			if (takis.c3 > 0)
			
				--deshotgun
				--unshotgun
				--un-shotgun
				if takis.c3 == TR/2
				and (takis.c2 == 0)
				and (takis.transfo & TRANSFO_SHOTGUN)
				and not (takis.tossflag)
				and (takis.shotgunforceon == false)
				and not (takis.hammerblastdown)
				and (takis.shotguntuttic == 0)
				and not nodeshotgun
					TakisDeShotgunify(p)
				end
				
				if takis.c3
				and p.powers[pw_shield] & SH_NOSTACK == SH_FLAMEAURA
				and not (takis.hammerblastdown)
				and (leveltime == 0)
					TakisTeamNewShields(p,true)
				end
				
				--this is stupid lol
				if takis.c3 == TR
					if (P_RandomChance(10))
						P_DamageMobj(me,nil,nil,1,DMG_INSTAKILL)
					end
					if P_RandomChance(1)
					and (takis.isSinglePlayer)
						G_ExitLevel()
					end
					if P_RandomChance(FU/1000)
						TakisJumpscare(p)
					end
				end
			end
			
			--shotgun tutorial
			if takis.tossflag == 17
			and (takis.shotguntuttic)
				TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES.shotgun)
				takis.shotguntuttic = 0
			end
			
			if takis.taunttime > 0
				takis.stasistic = 1
				
				--taunt anims
				if me.health
				and not (takis.inPain or takis.inFakePain)
				and (takis.notCarried)
					local think = TAKIS_TAUNT_THINK[takis.tauntid]
					think(p)
				else
					TakisResetTauntStuff(p,false)
					takis.taunttime = 1
				end
				takis.taunttime = $-1
			else
				TakisResetTauntStuff(p,false)
				
				if me.state == S_PLAY_TAKIS_SMUGASSGRIN
					me.tics = 1
				end
			end
			
			--stuff to do while in pain
			if takis.inPain
			or takis.inFakePain
				takis.ticsinpain = $+1
				takis.coyote = 0
				
				/*
				if (takis.io.flashes)
				and (true == false)
					if not (takis.painoverlay and takis.painoverlay.valid)
						takis.painoverlay = P_SpawnMobjFromMobj(me,0,0,0,MT_OVERLAY)
						local overlay = takis.painoverlay
						overlay.target = me
						overlay.sprite = SPR_PLAY
						overlay.skin = TAKIS_SKIN
						overlay.sprite2 = me.sprite2
						overlay.frame = me.frame+2
						overlay.tics = -1
						overlay.spritexscale = takis.spritexscale
						overlay.spriteyscale = takis.spriteyscale
						overlay.spriteyoffset = me.spriteyoffset
						
						overlay.blendmode = AST_SUBTRACT
						overlay.colorized = true
						overlay.color = ColorOpposite(p.skincolor)
					else
						local overlay = takis.painoverlay
						overlay.target = me
						overlay.sprite = SPR_PLAY
						overlay.skin = TAKIS_SKIN
						overlay.sprite2 = me.sprite2
						overlay.frame = me.frame+2
						overlay.tics = -1
						overlay.spritexscale = takis.spritexscale
						overlay.spriteyscale = takis.spriteyscale
						overlay.spriteyoffset = me.spriteyoffset
						
						overlay.blendmode = AST_SUBTRACT
						overlay.colorized = true
						overlay.color = ColorOpposite(p.skincolor)
						if not (leveltime/2 % 2)
							P_RemoveMobj(overlay)
						end
					end
				end
				*/
				
				if (leveltime & 1)
					me.flags2 = $ &~MF2_DONTDRAW					
				end
				
				takis.noability = $|NOABIL_SHOTGUN
				
				TakisResetTauntStuff(p,takis)
			
				takis.hammerblastjumped = 0
				if not takis.inBattle
					takis.recovwait = $+1
				else
					takis.recovwait = 0
				end
				
				if (takis.taunttime)
					P_RestoreMusic(p)
					takis.taunttime = 0
				end
				
				-- recov / recovery jump
				if (takis.jump)
				and (takis.recovwait >= TR)
				and (me.state == S_PLAY_PAIN)
					takis.ticsforpain = 0
					takis.stasistic = 0
					p.pflags = $ &~(PF_JUMPED|PF_THOKKED)
					P_DoJump(p,true)
					takis.dived,takis.thokked = false,false
					takis.inFakePain = false
				end
			else
				if (takis.painoverlay and takis.painoverlay.valid)
					P_RemoveMobj(takis.painoverlay)
				end
				takis.recovwait = 0
				takis.ticsinpain = 0
			end
			
			if me.sprite2 == SPR2_PAIN
			and me.health
				me.frame = (leveltime%4)/2
			end
			
			if (p.pflags & PF_JUMPED) and not (takis.thokked)
			and (me.state == S_PLAY_JUMP or me.state == S_PLAY_SPRING)
				takis.thokked = false
				takis.dived = false
				takis.jumptime = $+1
				if takis.jumptime < 3
					me.state = S_PLAY_SPRING
				elseif me.state ~= S_PLAY_JUMP
					me.state = S_PLAY_JUMP
				end
			else
				takis.jumptime = 0
			end
			if takis.jumptime > 0
				if takis.jumptime < 11
				and p.pflags & PF_JUMPDOWN
					takis.wavedashcapable = true
				else
					takis.wavedashcapable = false
				end
			else
				takis.wavedashcapable = false
			end
			
			--bomb dive thinker
			if takis.bombdive.started
				TakisResetHammerTime(p)
				local bomb = takis.bombdive
				takis.noability = $|NOABIL_HAMMER|NOABIL_DIVE
				p.powers[pw_strong] = $|STR_SPRING
				
				if me.momz*takis.gravflip >= -me.scale
					me.state = S_PLAY_ROLL
				else
					TakisDoWindLines(me)
					me.state = S_PLAY_FALL
				end
				
				bomb.tics = $+1
				local mul = FU*20/21
				me.momx,me.momy = FixedMul($1,mul),FixedMul($2,mul)
				me.momz = $+(P_GetMobjGravity(me)*4)
				
				if not (takis.notCarried)
					bomb.started = false
				elseif (me.eflags & MFE_SPRUNG
				or takis.fakesprung)
					bomb.started = false
					me.state = S_PLAY_SPRING
					TakisResetState(p)
					
					p.pflags = $ &~(PF_JUMPED|PF_THOKKED)
					takis.thokked = false
					takis.dived = false
				elseif not me.health
				or ((takis.inPain) or (takis.inFakePain))
				or not (takis.notCarried)
					bomb.started = false
				elseif dontdostuff
					bomb.started = false
				end
				
				if takis.onGround
				and bomb.started
					print("\x83TAKIS:\x80 bomb finish")
					bomb.started = false
					me.state = S_PLAY_STUN
					L_ZLaunch(me,5*FU)
					takis.dontlanddust = true
				end
				
			end
			
			--hammer blast thinker
			--hammerblast thinker
			--hammerblast stuff
			if takis.hammerblastdown
				p.charflags = $ &~SF_RUNONWATER
				p.powers[pw_strong] = $|(STR_SPRING|STR_HEAVY|STR_SPIKE)
				takis.noability = $|NOABIL_SHOTGUN|NOABIL_HAMMER
				--control better
				p.thrustfactor = $*3/2
				p.drawangle = me.angle
				
				if (p.pflags & PF_SHIELDABILITY)
					p.pflags = $ &~PF_SHIELDABILITY
				end
				
				--right side up lol
				me.pitch = FixedMul($,FU*3/4)
				me.roll = FixedMul($,FU*3/4)
				
				if (takis.shotgunned)
					if me.state ~= S_PLAY_TAKIS_SHOTGUNSTOMP
						me.state = S_PLAY_TAKIS_SHOTGUNSTOMP
						p.panim = PA_FALL
					end
					--wind ring
					if not (takis.hammerblastdown % 6)
					and takis.hammerblastdown > 6
					and (me.momz*takis.gravflip < 0)
						local ring = P_SpawnMobjFromMobj(me,
							0,0,-5*me.scale*takis.gravflip,MT_THOK --MT_WINDRINGLOL
						)
						if (ring and ring.valid)
							ring.renderflags = RF_FLOORSPRITE
							ring.frame = $|FF_TRANS50
							ring.startingtrans = FF_TRANS50
							ring.scale = FixedDiv(me.scale,2*FU)
							P_SetObjectMomZ(ring,10*me.scale)
							--i thought this would fade out the object
							ring.fuse = 10
							ring.destscale = FixedMul(ring.scale,2*FU)
							ring.colorized = true
							ring.color = SKINCOLOR_WHITE
							ring.state = S_SOAPYWINDRINGLOL
						end
					end
					
				else
					if me.state ~= S_PLAY_MELEE
						me.state = S_PLAY_MELEE
					end
					
				end
				
				takis.hammerblastjumped = 0
				if takis.hammerblastdown == 1
					L_ZLaunch(me,12*FU)
					takis.hammerblastwentdown = false
				end
				
				takis.thokked,takis.dived = true,true
				
				if takis.in2D
					p.drawangle = takis.hammerblastangle
				end
				
				me.momz = $+P_GetMobjGravity(me)
				
				local dontdostuff = false
				
				--the main stuff
				local fallingspeed = (8*me.scale)
				if (takis.inWater) then fallingspeed = $*3/4 end
				if me.momz*takis.gravflip <= fallingspeed
				or takis.hammerblastwentdown == true
					
					--me.momz = $*15/8
					me.momz = $-((me.scale*11/10)*takis.gravflip)
					if (takis.shotgunned)
						me.momz = $-((me.scale*14/10)*takis.gravflip)
					end
					if p.powers[pw_shield] & SH_FORCE
						me.momz = $+P_GetMobjGravity(me)
					end
					
					takis.hammerblastwentdown = true
					
					if not (takis.shotgunned)
						if not S_SoundPlaying(me,sfx_takhmb)
							S_StartSoundAtVolume(me,sfx_takhmb,255*9/10)
						end
						
						if takis.hammerblastdown
						and (takis.hammerblastdown % 5 == 0)
						and (me.momz*takis.gravflip <= 16*me.scale)
							P_SpawnGhostMobj(me)
						end
					end
					
					if not (takis.shotgunned)
						dontdostuff = TakisHammerBlastHitbox(p)
					end
					
				end
				
				local superspeed = -60*me.scale
				if (me.momz*takis.gravflip <= superspeed + 5*me.scale)
				and not (takis.lastmomz*takis.gravflip <= superspeed + 5*me.scale)
					S_StartSound(me,sfx_fastfl)
				end
				
				takis.hammerblastdown = $+1
				
				local domoves = true
				--cancel conds.
				if not (takis.notCarried)
					if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
						P_RemoveMobj(takis.hammerblasthitbox)
						takis.hammerblasthitbox = nil
					end
					takis.hammerblastdown = 0
					domoves = false
				elseif (me.eflags & MFE_SPRUNG
				or takis.fakesprung)
					takis.hammerblastdown = 0
					me.state = S_PLAY_SPRING
					TakisResetState(p)
					
					p.pflags = $ &~(PF_JUMPED|PF_THOKKED)
					takis.thokked = false
					takis.dived = false
					domoves = false
				elseif not me.health
				or ((takis.inPain) or (takis.inFakePain))
				or not (takis.notCarried)
					if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
						P_RemoveMobj(takis.hammerblasthitbox)
						takis.hammerblasthitbox = nil
					end
					takis.hammerblastdown = 0
					domoves = false
				elseif dontdostuff
					takis.hammerblastdown = 0
					domoves = false				
				end
				
				if not (takis.shotgunned)
					takis.dontlanddust = true
				end
				
				--hit ground
				if (takis.onGround or P_CheckDeathPitCollide(me))
				or (stupidbouncesectors(me,me.subsector.sector))
				or (takis.justHitFloor)
					TakisDoHammerBlastLand(p,domoves)
				end
			else
				p.powers[pw_strong] = $ &~(STR_SPRING|STR_HEAVY)
				if takis.transfo & TRANSFO_METAL
					p.powers[pw_strong] = $|STR_HEAVY
				end
				if ((takis.hammerblasthitbox) and (takis.hammerblasthitbox.valid))
					P_RemoveMobj(takis.hammerblasthitbox)
					takis.hammerblasthitbox = nil
				end
				takis.shotgunshotdown = false
				S_StopSoundByID(me,sfx_fastfl)
				S_StopSoundByID(me,sfx_takhmb)
			end
			
			if takis.hammerblastjumped
				takis.hammerblastjumped = $+1
				if takis.onGround
				--takis.hammerblastjumped == (6*7)
					takis.hammerblastjumped = 0
				end
			end
			
			if stupidbouncesectors(me,me.subsector.sector)
			and me.health
				if me.state ~= S_PLAY_ROLL
					me.state = S_PLAY_ROLL
				end
				p.pflags = $|PF_JUMPED &~PF_THOKKED
				takis.thokked = false
				takis.dived = false
			end
			
			--we're being carried!
			if not (takis.notCarried)
				takis.thokked,takis.dived = false,false
				takis.inFakePain = false
				if not (takis.inwaterslide)
					takis.afterimaging = false
				end
				--TakisResetHammerTime(p)
				takis.dontfootdust = p.powers[pw_carry] ~= CR_ROLLOUT
				takis.dontlanddust = true
				local gs = me.GSgrind
				
				if p.powers[pw_carry] == CR_MACESPIN
					if leveltime % 3 == 0
						TakisDoWindLines(me)
					end
					if (me.state ~= S_PLAY_ROLL)
						me.state = S_PLAY_ROLL
					end
					TakisResetHammerTime(p)
				elseif p.powers[pw_carry] == CR_PTERABYTE
					if (takis.use == 1)
						TakisDoClutch(p)
					end
					TakisResetHammerTime(p)
				elseif p.powers[pw_carry] == CR_MINECART	
					local cart = me.tracer
					TakisResetHammerTime(p)
					
					--Moved here to remove a mobjthinker
					if (cart and cart.valid)
					and (cart.health and me.health)
					and (takis.c1)
						p.powers[pw_carry] = CR_NONE
						
						p.mo.momx,p.mo.momy = cart.momx,cart.momy
						
						p.pflags = $|PF_JUMPED &~PF_THOKKED
						takis.thokked = false
						takis.dived = false
						
						P_SetObjectMomZ(me,8*FU)
						P_DoJump(p,true)
						p.mo.state = S_PLAY_ROLL
						
						TakisGiveCombo(p,takis,true)
						cart.target = nil
					end
				elseif (CR_GRINDRAIL)
				and p.powers[pw_carry] == CR_GRINDRAIL
				and (gs and gs.raildirection ~= nil)
					local momx,momy = takis.railing.new.x - takis.railing.x, takis.railing.new.y - takis.railing.y
					local momz = takis.rmomz
					local speed = takis.accspeed
					local angle = TakisMomAngle(me,
						nil, --gs.myrail.angle + gs.raildirection,
						momx,
						momy
					)
					
					do
						me.pitch = FixedAngle(FixedMul(momz*2,cos(angle)))
						me.roll = FixedAngle(FixedMul(momz*2,sin(angle)))
					end
					
					if not GS_RAILS.HangRail(me,gs.myrail)
					and (takis.accspeed >= 12*FU)
						local sparkcolor = SKINCOLOR_ORANGE
						if gs.railtilt
							if gs.badbalance
								angle = $ - gs.railtilt*(ANG1/15)
								sparkcolor = SKINCOLOR_PEPPER
							else
								angle = $ - gs.railtilt*(ANG1/21)
							end
						end
						
						local chance = P_RandomChance(FU/3)
						if takis.accspeed >= 30*FU
							chance = true
						end
						if chance
							for i = -1,1,2
								local s = TakisKart_SpawnSpark(me,
									angle + FixedAngle(TakisRandomFixed(44,46)*i), --FixedAngle(45*FU*i+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
									sparkcolor,
									true,
									true
								)
								L_ZLaunch(s,
									P_RandomRange(6,10)*FU + min(speed/4,35*FU) + momz
								)
								P_InstaThrust(s,
									angle,
									-speed*3/4
								)
								P_Thrust(s,
									s.angle,
									P_RandomRange(-6,-10)*s.scale
								)
								s.fmomx,s.fmomy = 0,0 --P_ReturnThrustX(nil,angle,gs.railspeed),P_ReturnThrustY(nil,angle,gs.railspeed)
							end
						end
					end
					
					/*
					local angle = R_PointToAngle2(0,0,me.momx,me.momy)
					local gs = me.GSgrind
					if gs and gs.raildirection
					and (gs.myrail and gs.myrail.valid)
						angle = me.GSgrind.myrail.angle $ + me.GSgrind.raildirection
					end
					
					*/
					
				end
				
				--rollout stuff moved to DoShorts
			end
			
			if p.inkart
				takis.noability = $|NOABIL_TRANSFO &~NOABIL_AFTERIMAGE
			end
	
			if not (takis.noability & NOABIL_AFTERIMAGE)
				if takis.clutchingtime
				or takis.glowyeffects
				and ((me.health) or (p.playerstate == PST_LIVE))
				or (takis.hammerblastdown and (me.momz*takis.gravflip <= -60*me.scale)
					and not takis.shotgunned)
				or (takis.drilleffect and takis.drilleffect.valid)
				and not takis.shotgunned
				or (takis.bashtime)
				or (p.inkart and (me.tracer and me.tracer.valid) and me.tracer.type == MT_TAKIS_KART_HELPER 
					and takis.accspeed >= 45*FU --FixedHypot(me.tracer.momx,me.tracer.momy) >= 45*FU
					and (true == false)
				)
					if not takis.shotgunned
						takis.clutchingtime = $+1
					end
					takis.afterimaging = true
					
					if not (takis.bashtime)
						takis.dustspawnwait = $+FixedDiv(takis.accspeed,64*FU)
						while takis.dustspawnwait > FU
							takis.dustspawnwait = $-FU
							--xmom code
							if (takis.onGround)
							and not (takis.clutchingtime % 10)
							and (takis.accspeed >= 45*FU)
								local d1 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle + ANGLE_45), -20*sin(p.drawangle + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
								local d2 = P_SpawnMobjFromMobj(me, -20*cos(p.drawangle - ANGLE_45), -20*sin(p.drawangle - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
								--d1.scale = $*2/3
								d1.destscale = FU/10
								d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5

								--d2.scale = $*2/3
								d2.destscale = FU/10
								d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
								d1.momx,d1.momy = me.momx*3/4,me.momy*3/4
								d2.momx,d2.momy = d1.momx,d1.momy
								d1.momz,d2.momz = takis.rmomz,takis.rmomz
								
								for i = 3,P_RandomRange(5,7)
									TakisSpawnDust(me,
										p.drawangle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
										P_RandomRange(0,-20),
										P_RandomRange(-1,2)*me.scale,
										{
											xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
											yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
											zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
											
											thrust = 0,
											thrustspread = 0,
											
											momz = P_RandomRange(6,1)*me.scale,
											momzspread = P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1),
											
											scale = me.scale,
											scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
											
											fuse = 23+P_RandomRange(-2,3),
										}
									)
								end
								/*
								for i = 3,P_RandomRange(5,7)
									local angle = p.drawangle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed())
									local dist = P_RandomRange(0,-20)
									local x,y = ReturnTrigAngles(angle)
									local steam = P_SpawnMobjFromMobj(me,
										dist*x+P_RandomFixed(),
										dist*y+P_RandomFixed(),
										P_RandomRange(-1,2)*me.scale+P_RandomFixed(),
										MT_TAKIS_STEAM
									)
									P_SetObjectMomZ(steam,
										P_RandomRange(6,1)*me.scale+P_RandomFixed(),
										false
									)
									steam.angle = angle
									steam.scale = me.scale+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1))
									steam.timealive = 1
									steam.tracer = me
									steam.destscale = 1
									steam.fuse = 20
								end
								*/
							end
						end
					end
					
					--p.charflags = $|SF_CANBUSTWALLS
					--p.powers[pw_strong] = $|STR_WALL
					
					if TakisDirBreak(p,me,p.drawangle)
						if takis.accspeed < (6*(40*FU)/5)
							takis.afterimaging = false
							me.momx,me.momy = 0,0
							me.state = S_PLAY_TAKIS_KILLBASH
							TakisResetHammerTime(p)
							L_ZLaunch(me,6*me.scale)
							P_Thrust(me,
								TakisMomAngle(me),
								-6*me.scale
							)
							takis.ropeletgo = 8
						end
						S_StartSound(me,sfx_takmcn)
						DoQuake(p,45*FU,19)
					end
					
					if (takis.accspeed >= skins[TAKIS_SKIN].normalspeed*2)
						p.charflags = $|SF_RUNONWATER
					else
						p.charflags = $ &~(SF_RUNONWATER)
					end
					
					if not (p.pflags & PF_SPINNING)
					and not (takis.glowyeffects)
					and not (takis.clutchingtime % 2)
						TakisCreateAfterimage(p,me)
					end
					
					if (takis.accspeed > FU)
						p.runspeed = takis.accspeed-FU
					else
						p.runspeed = skins[TAKIS_SKIN].runspeed/2
					end
					
					if p.panim == PA_DASH
						TakisSpawnDust(me,
							p.drawangle+FixedAngle(P_RandomRange(-45,45)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
							P_RandomRange(0,-50),
							P_RandomRange(-1,2)*me.scale,
							{
								xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
								zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								thrust = P_RandomRange(0,-10)*me.scale,
								thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								momz = P_RandomRange(4,0)*P_RandomRange(3,10)*(me.scale/2),
								momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
								
								scale = me.scale,
								scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
								
								fuse = 15+P_RandomRange(-5,5),
							}
						)
					end
				
				else
					if not p.inkart
						p.charflags = $ &~(SF_RUNONWATER)
						p.runspeed = skins[TAKIS_SKIN].runspeed/2
					end
					takis.clutchingtime = 0
					if not takis.starman
						takis.afterimagecolor = 1
					end
				end
			else
				if not p.inkart
					p.charflags = $ &~(SF_RUNONWATER)
					p.runspeed = skins[TAKIS_SKIN].runspeed/2
				end
				takis.clutchingtime = 0
				if not takis.starman
					takis.afterimagecolor = 1
				end
			end
			
			if takis.transfo & (TRANSFO_BALL|TRANSFO_METAL)
				TakisDirBreak(p,me,p.drawangle)
			end
			
			if not takis.afterimaging
				if me.state == S_PLAY_DASH
					me.state = S_PLAY_TAKIS_RESETSTATE
				end
			end
			
			--momentum based squash and stretch
			if not takis.dontlanddust
			and abs(me.momz) >= 18*me.scale
				local mom = FixedDiv(abs(me.momz),me.scale)-18*FU
				mom = $/50
				mom = -min($,FU*4/5)
				takis.spritexscale,
				takis.spriteyscale = $1+mom,$2-(mom*9/10)
			end
			
			if takis.bashspin
				if me.state ~= S_PLAY_TAKIS_TORNADO
					me.state = S_PLAY_TAKIS_TORNADO
				end
				p.drawangle = me.angle - (takis.bashspin*ANG30)
				takis.bashspin = $-1
			elseif p.powers[pw_carry] == CR_NONE
			and me.state == S_PLAY_TAKIS_TORNADO
				me.state = S_PLAY_STND
				TakisResetState(p)
				
				if takis.hammerblastjumped
					me.state = S_PLAY_SPIN
				end
			end
			if takis.bashspin < 0 then takis.bashspin = 0 end
			
			if takis.onGround
			or takis.justHitFloor
			or (me.eflags & MFE_JUSTHITFLOOR)
				--extremely weird checks to make sure we've bubbled bounced
				if (p.pflags & (PF_SHIELDABILITY|PF_THOKKED|PF_JUMPED))
				and (p.powers[pw_shield] & SH_NOSTACK) == SH_BUBBLEWRAP
				and (me.momz*takis.gravflip <= -20*me.scale)
					--P_DoBubbleBounce(p)
					p.pflags = $ &~(PF_THOKKED|PF_SHIELDABILITY)
					takis.thokked = false
					takis.dived = false
					me.state = S_PLAY_ROLL
				end
			end
			
			--stuff to do while grounded
			if takis.onGround
				if not p.inkart
					takis.coyote = 8+(p.cmd.latency)
				end
				takis.bashcooldown = false
				takis.slopeairtime = false
				takis.jumpfatigue = false
				
				if not takis.pitanim
					if takis.pittime
						takis.pittime = $-1
					else
						takis.pitcount = 0
					end
				end
				
				if takis.inFakePain
					takis.fakeflashing = flashingtics
					if (me.flags2 & MF2_TWOD or twodlevel)
					and (me.state == S_PLAY_PAIN)
						me.state = S_PLAY_STND
						TakisResetState(p)
					end
				end
				
				if not (takis.justHitFloor)
				and (takis.ticsinpain >= 2)
				and takis.inFakePain
					takis.inFakePain = false
				end
				takis.ticsforpain = 0
				
				if not P_CheckDeathPitCollide(me)
					takis.timesdeathpitted = 0
				end
				if p.pflags & PF_SPINNING
					takis.thokked = false
					p.pflags = $ &~PF_THOKKED
					if takis.accspeed >= 10*FU
					and (me.state == S_PLAY_TAKIS_SLIDE)
						local chance = P_RandomChance(FU/3)
						if takis.accspeed >= 30*FU
							chance = true
						end
						if takis.accspeed <= 20*FU
							chance = false
						end
						
						--kick up dust
						if chance
							TakisSpawnDust(me,
								p.drawangle+FixedAngle(P_RandomRange(-45,45)*FU+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
								P_RandomRange(0,-50),
								P_RandomRange(-1,2)*me.scale,
								{
									xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									
									thrust = P_RandomRange(0,-10)*me.scale,
									thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									
									momz = P_RandomRange(4,0)*P_RandomRange(3,10)*(me.scale/2),
									momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
									
									scale = me.scale,
									scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									
									fuse = 15+P_RandomRange(-5,5),
								}
							)
							if not (me.eflags & (MFE_UNDERWATER|MFE_TOUCHLAVA) == MFE_UNDERWATER)
								S_StartSound(me,sfx_s3k7e)
							end
						end
						
						P_ButteredSlope(me)
						takis.clutchingtime = $-2
						takis.noability = $|NOABIL_SHOTGUN|NOABIL_AFTERIMAGE
					end
				end
				takis.dived = false
				if takis.hammerblastjumped >= 3
					takis.hammerblastjumped = 0
				end
				takis.thokked = false
				takis.firethokked = false
				
				--keep sliding
				if (takis.c2)
				and (takis.accspeed > 5*FU)
				and (takis.onGround)
				and (takis.notCarried)
				and (not shouldntcontinueslide)
				and (not (takis.noability & NOABIL_SLIDE)
				and not (takis.transfo & TRANSFO_BALL))
					if me.state ~= S_PLAY_TAKIS_SLIDE
					and me.health
						takis.bashspin = 0
						
						S_StartSound(me,sfx_taksld)
						me.state = S_PLAY_TAKIS_SLIDE
						local ang = TakisMomAngle(me)
						local d1 = P_SpawnMobjFromMobj(me, -20*cos(ang + ANGLE_45), -20*sin(ang + ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
						local d2 = P_SpawnMobjFromMobj(me, -20*cos(ang - ANGLE_45), -20*sin(ang - ANGLE_45), 0, MT_TAKIS_CLUTCHDUST)
						d1.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d1.x, d1.y) --- ANG5
						d2.angle = R_PointToAngle2(me.x+me.momx, me.y+me.momy, d2.x, d2.y) --+ ANG5
						for j = -1,1,2
							for i = 3,P_RandomRange(5,10)
								TakisSpawnDust(me,
									ang+FixedAngle(45*FU*j+(P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1))),
									P_RandomRange(0,-50),
									P_RandomRange(-1,2)*me.scale,
									{
										xspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
										yspread = 0,--(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
										zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
										
										thrust = P_RandomRange(0,-10)*me.scale,
										thrustspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
										
										momz = (P_RandomRange(4,0)*i)*(me.scale/2),
										momzspread = ((P_RandomChance(FU/2)) and 1 or -1),
										
										scale = me.scale,
										scalespread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
										
										fuse = 15+P_RandomRange(-5,5),
									}
								)
							end
						end
					end
					takis.slidetime = max(1,$)
					p.pflags = $|PF_SPINNING
				end
					
				--footsteps
				if (me.state == S_PLAY_WALK
				or me.sprite2 == SPR2_WALK
				
				or me.state == S_PLAY_RUN
				or me.sprite2 == SPR2_RUN_
				
				or me.state == S_PLAY_DASH
				or me.sprite2 == SPR2_DASH)
				
				and (me.health)
				and not (takis.dontfootdust or takis.inSaxaMM)
				and not p.inkart
					local frame = me.frame & FF_FRAMEMASK
					local dostep = false
					
					local state = S_PLAY_WALK
					
					if me.sprite2 == SPR2_WALK
						dostep = ((frame == A) or (frame == E))
						state = S_PLAY_WALK
						
					elseif me.sprite2 == SPR2_RUN_
						dostep = ((frame == C) or (frame == F))
						state = S_PLAY_RUN
						
					elseif me.sprite2 == SPR2_DASH
						dostep = ((frame == A) or (frame == C))
						state = S_PLAY_DASH
						
					end
					
					if dostep
						if not takis.steppedthisframe
							local sfx = P_RandomRange(sfx_takst1,sfx_takst3)
							if takis.inWater
								sfx = P_RandomChance(FU/3) and (P_RandomRange(sfx_bubbl1,sfx_bubbl5)) or sfx_none
							end
							if (takis.transfo & TRANSFO_METAL)
								sfx = sfx_takst6
							end
							
							S_StartSoundAtVolume(me,sfx_takst0,255/2)
							S_StartSound(me,sfx)
							takis.steppedthisframe = true
							
							if state ~= S_PLAY_RUN
								TakisSpawnDust(me,
									p.drawangle+FixedAngle(P_RandomRange(-20,20)*FU+P_RandomFixed()),
									P_RandomRange(0,-10),
									P_RandomRange(-1,2)*me.scale+P_RandomFixed(),
									{
										xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
										yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
										zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
										
										thrust = 0,
										thrustspread = 0,
										
										momz = 0,
										momzspread = 0,
										
										scale = me.scale*4/5,
										scalespread = 0,--(P_RandomFixed()/4*((P_RandomChance(FU/2)) and 1 or -1)),
										
										fuse = 15+P_RandomRange(-2,3),
									}
								)
							else
								for i = -1,1,2
									for j = 2,P_RandomRange(3,4)
										TakisSpawnDust(me,
											p.drawangle+FixedAngle(P_RandomRange(-45,45)*FU+P_RandomFixed()*i),
											P_RandomRange(-2,-10),
											P_RandomRange(-1,2)*me.scale+P_RandomFixed(),
											{
												xspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
												yspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
												zspread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
												
												thrust = -5*me.scale,
												thrustspread = 0,
												
												momz = P_RandomRange(5,10)*me.scale,
												momzspread = 0,
												
												scale = me.scale*4/5,
												scalespread = 0,--(P_RandomFixed()/4*((P_RandomChance(FU/2)) and 1 or -1)),
												
												fuse = 15+P_RandomRange(-2,3),
											}
										)
									end
								end
							end
						end
					else
						takis.steppedthisframe = false
					end
				else
					takis.steppedthisframe = false
					takis.dontfootdust = false
				end
				
				--landing effect
				if takis.justHitFloor
				and not (me.eflags & (MFE_TOUCHWATER|MFE_TOUCHLAVA))
				and not P_CheckDeathPitCollide(me)
				and me.health
				and not p.inkart
				and not takis.inSaxaMM
					if (takis.dontlanddust == false)
					and (takis.onPosZ)
						
						S_StartSoundAtVolume(me,sfx_takst0,255*4/5)
						S_StartSound(me,sfx_takst4)
						p.jp = 1
						p.jt = -5
						if takis.lastmomz*takis.gravflip <= -18*me.scale
							local momz = takis.lastmomz*takis.gravflip
							local rich = 10*FU
							S_StartSoundAtVolume(me,sfx_taklfh,255*4/5)
							p.jt = -7
							
							if momz+18*me.scale < 0
								rich = $+abs(FixedDiv(momz+18*me.scale,FU))
							end
							DoQuake(p,rich,15)
						end
						--P_SetOrigin(me,me.x,me.y,me.z)
						
						for i = 0, 7
							local radius = FixedDiv(me.radius,me.scale)
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
									
									scale = me.scale*4/5,
									scalespread = (P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1)),
									
									fuse = 23+P_RandomRange(-2,3),
								}
							)
							dust.momx = FixedMul(FixedMul(sin(fa),radius),mz)/2
							dust.momy = FixedMul(FixedMul(cos(fa),radius),mz)/2
							
						end
						takis.inFakePain = false
						takis.ticsinpain = 0
						takis.dontlanddust = true
						
					end
				end
				
				--speedpads conserve speed too
				--NOT!!
				/*
				if P_PlayerTouchingSectorSpecial(p, 3, 5)
				and takis.onGround
				and not takis.fakesprung
					P_Thrust(me,me.angle,takis.prevspeed)
					takis.fakesprung = true
				end
				*/
			else
				if me.eflags & MFE_SPRUNG
					takis.coyote = 0
				end
				
				if takis.jumpfatigue
					if takis.accspeed > p.normalspeed*8/10
						me.momx,me.momy = FixedMul($1,FU*8/10),FixedMul($2,FU*8/10)
					end
				end
				
				if p.powers[pw_justlaunched]
					takis.slopeairtime = true
				end
				
				--coyote time
				if takis.coyote
				and (me.health)
				and (takis.notCarried)
				and not p.inkart
					takis.coyote = $-1
					if takis.jump == 1
					and not (p.pflags & (PF_JUMPED|PF_JUMPSTASIS|PF_THOKKED))
						takis.coyote = 0
						P_DoJump(p,true)
					end
				end
			end
			
			/*
			if takis.hurtfreeze > 0
				me.momx,me.momy,me.momz = 0,0,0
				p.powers[pw_flashing] = 3
				if takis.hurtfreeze <= TR
					if not (leveltime % 2)
						me.flags2 = $|MF2_DONTDRAW
					else
						me.flags2 = $ &~MF2_DONTDRAW
					end
				end
				
				if takis.hurtfreeze == TR
					local x
					local y
					local z
					x,y,z = unpack(takis.lastgroundedpos)
					P_SetOrigin(me,x,y,z+(me.height*takis.gravflip))
				end
				
				if takis.hurtfreeze == 1
					takis.fakeflashing = flashingtics
				end
				
				takis.hurtfreeze = $-1
			end
			*/
			
			DoTakisSquashAndStretch(p,me,takis)
			if takis.beingcrushed
				takis.spriteyscale = $/3
				takis.spritexscale = $*3
				
				--keep increasing this until it reaches
				--2*TR, kill if then
				if G_BuildMapTitle(gamemap) ~= "Red Room"
					takis.timescrushed = $+1
				end
				takis.crushscale = FU*2/5
				
				if not takis.crushtime
				and not (takis.transfo & TRANSFO_PANCAKE)
					S_StartSound(me,sfx_tsplat)
					S_StartSound(me,sfx_trnsfo)
					takis.transfo = $|TRANSFO_PANCAKE
					TakisAwardAchievement(p,ACHIEVEMENT_PANCAKE)
				end
				takis.pancaketime = TAKIS_MAX_TRANSFOTIME
				
				p.pflags = $ &~PF_SPINNING
				P_MovePlayer(p)
				if (me.state == S_PLAY_ROLL)
					me.state = S_PLAY_STND
				end
				
				--used to reset crushed
				takis.crushtime = TR
			else
				if not takis.crushtime
					--if (takis.saveddmgt ~= DMG_CRUSHED)
					--end
				else
					local s = FixedDiv(takis.crushtime*FU,TR*FU)
					takis.crushscale = ease.inexpo(FU-s,takis.crushscale,FU)
					
					takis.spriteyscale = FixedMul(FU,takis.crushscale)
					takis.spritexscale = FixedDiv(FU,takis.crushscale)				
					p.jt = 0
					p.jp = 0
					p.sp = 0
					p.tk = 0
					p.tr = 0
				end
			end
			
			takis.beingcrushed = false
			
			--are we dead?
			if (not me.health)
			or (p.playerstate ~= PST_LIVE)
				
				TakisDeathThinker(p,me,takis)
				if (takis.shotgunned)
					TakisDeShotgunify(p)
				end
				
				if (takis.transfo)
					S_StartSound(me,sfx_shgnk)
					takis.transfo = 0
				end
				
				if (takis.body and takis.body.valid)
					P_MoveOrigin(takis.body,
						me.x+me.momx,
						me.y+me.momy,
						me.z+me.momz
					)
					takis.body.momx,takis.body.momy,takis.body.momz = 0,0,0
					
					if me.standingslope
						takis.body.z = P_GetZAt(me.standingslope,
							me.x + me.momx,
							me.y + me.momy
						)
					end
					
					takis.body.angle = p.drawangle
					takis.body.rollangle = me.rollangle
					
					takis.body.radius,takis.body.height = me.radius,me.height
					
					takis.body.renderflags = me.renderflags
					takis.body.sprite = SPR_PLAY
					takis.body.sprite2 = me.sprite2
					takis.body.frame = me.frame
					
					takis.body.color = me.color
					
					takis.body.pitch = me.pitch
					takis.body.roll = me.roll
					takis.body.spritexscale = takis.spritexscale
					takis.body.spriteyscale = takis.spriteyscale
					takis.body.dispoffset = me.dispoffset + 1
					
					takis.body.destscale = me.scale
				end
				
				takis.wentfast = 0
				
				--death thinker and anims are called in 
				--TakisDoShorts
				
				takis.heartcards = 0
				TakisResetHammerTime(p)
				TakisResetTauntStuff(p)
				
				takis.clutchingtime = 0
				takis.afterimaging = false
				
				if not takis.deathfunny
					if S_SoundPlaying(me,skins[TAKIS_SKIN].soundsid[SKSPLDET3])
						S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET3])
						me.frame = A
						me.sprite2 = SPR2_TDED
						TakisFancyExplode(me,
							me.x, me.y, me.z,
							P_RandomRange(60,64)*me.scale,
							40,
							nil,
							15,20
						)
						for i = 1, 6
							A_BossScream(me,1,MT_SONIC3KBOSSEXPLODE)
						end
						S_StartSound(me,sfx_tkapow)
						DoQuake(p,me.scale*8,10,8*me.scale)
						takis.altdisfx = 3
						--i cant think of a better way to get this to synch 100%
						COM_BufInsertText(p,"takis_deathsync "..TAKIS_ACHIEVEMENTINFO.luasig.." 3")
					elseif S_SoundPlaying(me,skins[TAKIS_SKIN].soundsid[SKSPLDET4])
						S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET4])
						me.frame = A
						me.sprite2 = SPR2_FASS
						S_StartSound(me,sfx_takoww)
						takis.altdisfx = 4
						COM_BufInsertText(p,"takis_deathsync "..TAKIS_ACHIEVEMENTINFO.luasig.." 4")
					end
				end
				
			elseif (p.playerstate == PST_REBORN
			or p.playerstate == PST_LIVE)
				takis.deadtimer = 0
				takis.freezedeath = false
				takis.deathanim = 0
				takis.altdisfx = 0
				takis.saveddmgt = 0
				takis.stoprolling = false
				takis.deathfloored = false
				if p.bot == BOT_2PAI
				--and p.playerstate == PST_REBORN
					takis.heartcards = TAKIS_MAX_HEARTCARDS
				end
			end
			
			if p.inkart or (me.boat and me.boat.valid) then takis.combo.time = 0 end
			
			--handle combo stuff here
			if takis.combo.time ~= 0
				if TakisComboHelpers.shouldfreeze(p)
					takis.combo.frozen = true
					if ((p.exiting) and not (p.pflags & PF_FINISHED))
						takis.combo.cashable = true
					end
				else
					takis.combo.time = $-1
					--Ez
					if not takis.combo.time
						takis.HUD.combo.fillnum = 0
					end
					
					takis.combo.frozen = false
					takis.combo.cashable = false
				end
				/*
				--ALWAYS use ptsr's combo meter
				if p.ptsr
				and HAPPY_HOUR.othergt
					takis.combo.frozen = not PTSR.CanComboTimeDecrease(p)
					takis.combo.cashable = false
					takis.combo.dropped = p.ptsr.combo_timesfailed ~= 0
				end
				
				--weird hybrid with ptsr's and takis' combo meters
				local maxtime = TAKIS_MAX_COMBOTIME
				if (p.ptsr)
				and HAPPY_HOUR.othergt
					maxtime = p.ptsr.combo_maxtime
					takis.combo.time = p.ptsr.combo_timeleft
				end
				*/
				
				takis.combo.time = clamp(0,$,TAKIS_MAX_COMBOTIME)
				
				--give ultiamte combo token
				if takis.combo.lastcount < TAKIS_NET.partdestroy
				and takis.combo.count >= TAKIS_NET.partdestroy
				and not takis.combo.dropped
				and (gametype == GT_COOP)
				and not (maptol & TOL_NIGHTS)
				and not (TAKIS_NET.inbossmap or TAKIS_NET.inbrakmap)
					takis.combo.awardable = true
					takis.HUD.combo.tokengrow = FU/2
					MeSoundHalfVolume(sfx_ncitem,p)
				end
				
				local cc = takis.combo.count
				--be fair to the other runners
				/*
				if (HAPPY_HOUR.othergt)
					if p.ptsr
						takis.combo.score = "dontdraw"
					else
						takis.combo.score = ((cc*cc)/2)+(10*cc)
					end
				else
				end
				*/
				takis.combo.score = ((cc*cc)/2)+(17*cc)
				
				if takis.combo.penalty
				and takis.combo.score ~= "dontdraw"
					local bad = takis.combo.penalty
					takis.combo.score = $ - (((bad*bad)/2)+(17*bad))
					takis.combo.score = max($,0)
				end
				
				takis.combo.outrotics = 0
				
				takis.combo.verylevel = takis.combo.count/(#TAKIS_COMBO_RANKS*TAKIS_COMBO_UP)
				
			else
				takis.combo.frozen = false
				takis.combo.cashable = false
				takis.HUD.combo.shake = 0
				takis.combo.penalty = 0
				
				if takis.combo.count
					takis.combo.failcount = takis.combo.count
					takis.combo.failtics = 4*TR
					takis.combo.failrank = takis.combo.rank
					
					takis.combo.count = 0
					S_StartSound(nil,sfx_kc59,p)
					
					takis.combo.outrotointro = 0
					takis.combo.outrotics = 7*TR/5
					takis.HUD.flyingscore.lastscore = takis.combo.score
					takis.HUD.combo.momy = 3*FU
					takis.HUD.combo.momx = 3*FU
					
					if not (p.ptsr
					and HAPPY_HOUR.othergt)
						S_StartSound(nil,sfx_chchng,p)
						if takis.combo.score ~= "dontdraw"
							P_AddPlayerScore(p,takis.combo.score)
						end
					end
					
					if takis.combo.score ~= "dontdraw"
						takis.HUD.flyingscore.num = takis.combo.score
						takis.HUD.flyingscore.tics = $+2*TR
						local backx = 15*FU
						local backy = takis.HUD.combo.basey
						takis.HUD.flyingscore.x = backx+5*FU+takis.HUD.combo.patchx
						takis.HUD.flyingscore.y = backy+7*FU
					end
					
					if not (p.pflags & PF_FINISHED)
						if not takis.combo.dropped
							takis.combo.dropped = true
							if takis.combo.lastcount >= TAKIS_NET.partdestroy
								--TODO:
								--MeSoundHalfVolume(sfx_rakdns,p)
							end
						end
					end
				end
				
				takis.combo.score = 0
				
				if takis.combo.time < 0
					takis.combo.time = 0
				end
				
				takis.combo.verylevel = 0
				takis.combo.rank = 1
			end
			
			if not (takis.combo.count
			or takis.combo.outrotics)
				takis.failcount = 0
			end
			
			--this is actually stupid
			if p.exiting > 0
				
				if (p.pflags & PF_FINISHED)
					takis.combo.time = 0
					takis.fakeexiting = $+1
					
					local hadbonus = false
					--time for bonuses!
					if takis.fakeexiting == 1
						
						if takis.shotgunned
							if ((takis.shotgun) and (takis.shotgun.valid))
								P_KillMobj(takis.shotgun,me)
							end
							takis.transfo = $ &~TRANSFO_SHOTGUN
							takis.shotgun = 0
							takis.shotgunned = false
							
							P_AddPlayerScore(p,2000)
							takis.HUD.flyingscore.scorenum = $+2000
							TakisAddBonus(p,"shotgun","Shotgun",3*TR,2000)
							
							hadbonus = true
						end	
					end
					
					if takis.combo.awardable
						takis.combo.awardable = false
						
						P_AddPlayerScore(p,5000)
						takis.HUD.flyingscore.scorenum = $+5000
						TakisAddBonus(p,"ucombo","\x82Ultimate Combo\x80",3*TR,5000)
						
						hadbonus = true
						TakisAwardAchievement(p,ACHIEVEMENT_COMBO)
					end
					
					--i fell from the light, talk or should i fight
					if takis.combo.pacifist
					and TAKIS_NET.partdestroy > 0
					and not TAKIS_NET.inbossmap
					and (false == true)
						takis.combo.pacifist = false
						hadbonus = true
						TakisAwardAchievement(p,ACHIEVEMENT_PACIFIST)
					end
					
					if hadbonus
						S_StartSound(nil,sfx_chchng,p)
						hadbonus = false
					end
					
					if (p.exiting ~= 1)
					and (takis.lastexiting ~= 1)
						if (takis.heartcards)
							local tic = max(77/TAKIS_MAX_HEARTCARDS,1)
							
							--TODO: players can die if someone joins during
							--		exiting, use a variable instead of eating
							--		the cards directly
							if not (takis.fakeexiting % tic)
								
								if takis.heartcards
									takis.heartcards = $-1
									S_StartSound(nil,sfx_takhl2,p)
									
									P_AddPlayerScore(p,100)
									takis.HUD.flyingscore.scorenum = $+100
									TakisAddBonus(p,"heartcard","\x8EHeart Card",TR*3/2,100)
									
									--table.insert(takis.bonuses.cards,{tics = TR+18,score = 100,text = "\x8EHeart Card\x80"})
									--takis.bonuses["heartcard"].tics = TR+18
									--takis.bonuses["heartcard"].score = 1000
									takis.HUD.heartcards.shake = TAKIS_HEARTCARDS_SHAKETIME/2
								end
								
							end
						end
					--about to leave and still have cards left? cash them all in at once!
					else
						if takis.heartcards 
							P_AddPlayerScore(p,100*takis.heartcards)
							takis.HUD.flyingscore.scorenum = $+100*takis.heartcards
							takis.heartcards = 0
						end
						if takis.io.autosave
							TakisSaveStuff(p)
						end
					end
				else
					--exiting and no pf_finished?
					if TAKIS_NET.inbossmap
					and (gametype == GT_COOP)
					/*
					or (TAKIS_NET.exitingcount == TAKIS_NET.playercount)
						if (TAKIS_NET.exitingcount == TAKIS_NET.playercount)
						and takis.finishwait == 0
							takis.finishwait = TR
						end
					*/	
						--if not takis.finishwait
							p.pflags = $|PF_FINISHED
						--end
					end
				end
				
				local candomusic = true
				if PTSR and PTSR.gameover
					candomusic = false
					p.exiting = 99
				end
				
				if not takis.setmusic
				and (p.pflags & PF_FINISHED)
				and candomusic
					S_ChangeMusic("_abclr", false, p)
					takis.setmusic = true
					takis.yeahwait = (2*TR)+(TR/2)+5
				end

				--Yyyeah!
				if takis.yeahwait == 0
				and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
				--and (p.pflags & PF_FINISHED)
					
					if not takis.yeahed
						if p.panim == PA_IDLE
						and ((takis.onGround) or P_CheckDeathPitCollide(me))
						and takis.yeahwait == 0
							if not takis.camerascale
							--keep the camera zoomed out on the door
							and not (HAPPY_HOUR.exit and HAPPY_HOUR.exit.valid)
								takis.camerascale = p.camerascale
								p.camerascale = 28221
							end
							S_StartSound(me,sfx_tayeah)
							takis.yeahed = true
							me.tics = -1
						end
					end
				end
			else
				takis.fakeexiting = 0
				takis.yeahed = false
				takis.setmusic = false
				takis.yeahwait = 0
			end
			
			if (p.ptsr and p.ptsr.rank)
			and (HAPPY_HOUR.othergt)
				local per = (PTSR.maxrankpoints)/6
				takis.HUD.rank.percent = per
				local rank = p.ptsr.rank
				
				if (rank == "D")
					takis.HUD.rank.score = p.score
				elseif (rank == "C")
					takis.HUD.rank.score = p.score-(per)
					takis.HUD.rank.percent = $/2
				elseif (rank == "B")
					takis.HUD.rank.score = p.score-(per*2)
				elseif (rank == "A")
					takis.HUD.rank.score = p.score-(per*3)
					takis.HUD.rank.percent = $*5/2
				elseif (rank == "S")
					takis.HUD.rank.score = p.score-(per*8)
					takis.HUD.rank.percent = $*4
				end
				
				if takis.combo.score ~= "dontdraw"
					takis.HUD.rank.score = $+takis.combo.score
				end
				if takis.HUD.flyingscore.tics
					takis.HUD.rank.score = $-takis.HUD.flyingscore.lastscore
				end
				
				if ranktonum[rank] ~= takis.lastrank
				and not (p.pizzaface)
					/*
					local r = ranktonum[rank]
					--we went up!
					if r > takis.lastrank
						if r == 6
							MeSoundHalfVolume(sfx_rakupp,p)
						elseif r == 5
							MeSoundHalfVolume(sfx_rakups,p)
						elseif r == 4
							MeSoundHalfVolume(sfx_rakupa,p)
						elseif r == 3
							MeSoundHalfVolume(sfx_rakupb,p)
						elseif r == 2
							MeSoundHalfVolume(sfx_rakupc,p)
						end
					--down?
					else
						if r == 5
							MeSoundHalfVolume(sfx_rakdns,p)
						elseif r == 4
							MeSoundHalfVolume(sfx_rakdna,p)
						elseif r == 3
							MeSoundHalfVolume(sfx_rakdnb,p)
						elseif r == 2
							MeSoundHalfVolume(sfx_rakdnc,p)
						elseif r == 1
							MeSoundHalfVolume(sfx_rakdnd,p)

						end
					end
					*/
					
					takis.HUD.rank.grow = FU/3
				end		
			end
			
			takis.dontlanddust = false
			--these are stupid
			takis.lastskincolor = p.skincolor
		else
			
			TakisHUDStuff(p)
			--just switched
			if not takis.otherskin
				takis.otherskin = true
				TakisResetTauntStuff(p,true)
				if takis.HUD.showingletter
					takis.HUD.showingletter = false
					P_RestoreMusic(p)
				end
				takis.otherskintime = 1
			else
				takis.otherskintime = $+1
			end
			
			if takis.deathfunny
			and false
				takis.deathfunny = false
				me.spritexoffset = 0
			end
			takis.combo.time = 0
			--still animate happy hour and stuff
			
			if (takis.shotgunned)
				TakisDeShotgunify(p)
			end
		end
		takis.prevz = me.z
		
		if TAKIS_NET.achtime == 0
		and (takis.achbits ~= 0)
			local nextach = 0
			for i = 0,NUMACHIEVEMENTS-1
				if (takis.achbits & (1<<i)) == 0
					continue
				else
					nextach = takis.achbits & (1<<i)
					TakisAwardAchievement(p,nextach)
					break
				end
			end
		end
		
		--fake pw_flashing
		if takis.fakeflashing > 0
			p.powers[pw_flashing] = takis.fakeflashing
			takis.fakeflashing = $-1
		end
		
		if p.name
			if G_GametypeHasTeams()
				if (p.ctfteam == 1)
					p.ctfnamecolor = "\x85"+p.name+"\x80"
				elseif (p.ctfteam == 2)
					p.ctfnamecolor = "\x84"+p.name+"\x80"
				else
					p.ctfnamecolor = p.name
				end
			else
				p.ctfnamecolor = p.name
			end
		end
		
		--outside of shorts (and skin check!!!!) to check for
		--last rank
		takis.lastrank = ranktonum[p.ptsr and p.ptsr.rank or "D"]
		
		for i = 0,#takis.hurtmsg
			if takis.hurtmsg[i].tics > 0
				takis.hurtmsg[i].tics = $-1
			end
		end
		
		takis.placement = 0
		for k,v in ipairs(TAKIS_NET.scoreboard)
			if v == p
				takis.placement = k
				break
			else
				continue
			end
		end
		if takis.placement ~= takis.lastplacement
		and takis.placement ~= 0
		and takis.HUD.lives.useplacements
		and not p.spectator
			takis.HUD.lives.bump = FU*3/2
			/*
			if me.skin == TAKIS_SKIN
				local sound = min(takis.placement,16)
				S_StartSound(nil,sfx_pass01+(sound-1),p)
			end
			*/
		end
		
		--holding FN, C3, C2 open menu
		if (takis.firenormal >= TR)
		and (takis.c3 >= TR)
		and (takis.c2 >= TR)
		and not (takis.cosmenu.menuinaction)
		and not modeattacking
			TakisMenuOpenClose(p)
		end
		
		if me.battime then me.battime = $-1 end
		if me.touchingdetector then me.touchingdetector = $-1 end
		if p.inkart
			p.inkart = $-1
			
			if p.dashpadtime == nil then p.dashpadtime = 0 end
			p.dashpadtime = max($-1,0)
				
			local dashpadflash = TR/3
			if P_PlayerTouchingSectorSpecial(p,3,5)
			and p.lastflashing == 0
			and (p.powers[pw_flashing] >= dashpadflash-1
			and p.powers[pw_flashing] <= dashpadflash+1)
				p.dashpadmom = {me.momx,me.momy,p.drawangle}
				p.dashpadtime = 3
			end
			if p.onconveyor == 2
				p.windcurrmom = {p.cmomx,p.cmomy}
			else
				p.windcurrmom = nil
			end
			
			p.kartfric = {me.friction,me.movefactor}
			
			p.lastflashing = p.powers[pw_flashing]
		else
			if p.powers[pw_carry] == CR_TAKISKART
				p.powers[pw_carry] = 0
				me.tracer = nil
				CarGenericEject(p)
			end
			if p.kartingtime
				CarGenericEject(p)
			end
			p.kartingtime = 0
		end
		if (me.crownref and me.crownref.valid)
			me.crownref.takis_flingme = false
		end
		
		/*
		if p.score ~= takis.lastrealscore
			print("Score: "..(p.score - takis.lastrealscore))
			print("Scoreadd: "..p.scoreadd)
		end
		*/
		
		takis.combo.lastcount = takis.combo.count
		takis.lastmap = gamemap
		takis.lastweapon = takis.currentweapon
		takis.lastgt = gametype
		takis.lastss = G_IsSpecialStage(gamemap)
		takis.lastplacement = takis.placement
		takis.lastcarry = p.powers[pw_carry]
		takis.lastrings = takis.HUD.rings.drawrings
		takis.lastlives = p.lives
		takis.lastlaps = p.laps
		takis.prevspeed = takis.accspeed
		takis.lastmomz = me.momz
		takis.lastexiting = p.exiting
		takis.laststate = me.state
		takis.lastrealscore = p.score
		takis.lastafterimaging = takis.afterimaging
		if CV_FindVar("cooplives").value == 3
		and (netgame or multiplayer)
			takis.lastlives = TAKIS_MISC.livescount
		end
	end
	
end)

--this is really stupid
addHook("ThinkFrame", function ()
    for p in players.iterate() do
        if not (p and p.valid) then continue end
		
		local takis = p.takistable
		
		if p.spectator
			takis.inwaterslide = 0
			takis.wasinwaterslide = 0
			TakisResetHammerTime(p)
			continue
		end
		
		--this really REALLY sucks
		p.lastCR_FAN = p.powers[pw_carry] == CR_FAN
		
		takis.wasinwaterslide = takis.inwaterslide
		if takis
			takis.inwaterslide = p.pflags & PF_SLIDING
		end
		if not p.mo.health
			takis.inwaterslide = 0
		end
		
		if skins[p.skin].name == TAKIS_SKIN
		and (p.mo and p.mo.valid and p.mo.health)
			if takis.inwaterslide
			and not takis.wasinwaterslide
				S_StartSound(p.realmo,sfx_eeugh)
				p.mo.state = S_PLAY_STUN
				takis.transfo = $ &~TRANSFO_BALL
			end
			
			if not takis.inwaterslide
			and takis.wasinwaterslide
				p.mo.state = S_PLAY_ROLL
				p.pflags = $|PF_SPINNING
				takis.transfo = $|TRANSFO_BALL
				P_MovePlayer(p)
				S_StartAntonOw(p.mo)
			end
			
			if takis.transfo & TRANSFO_METAL
				p.powers[pw_spacetime] = 0
				p.powers[pw_underwater] = 0
			end
		
		end
	end
end)

local function otherwind(p,me,ang)
	TakisDoWindLines(me,0,nil,ang)
end

--thanks to Unmatched Bracket for this code!!!
--:iwantsummadat:
addHook("PostThinkFrame", function()
    for p in players.iterate() do
        if not (p and p.valid) then continue end
		if not (p.realmo and p.realmo.valid) then continue end
		
		local me = p.realmo
		local takis = p.takistable
		
		if not takis then continue end
		
		takis.lastpos = {
			x = p.realmo.x,
			y = p.realmo.y,
			z = p.realmo.z,
			momx = p.realmo.momx,
			momy = p.realmo.momy,
			momz = p.realmo.momz
		}
		
		takis.quakeint = 0
		for k,v in ipairs(takis.quake)
			if v == nil
				continue
			end
			
			local q = takis.quake
			
			if v.tics
				v.intensity = $-v.minus
				takis.quakeint = $+v.intensity
				v.tics = $-1
			else
				table.remove(q,k)
			end
		end
		if takis.quakeint
		and displayplayer == p
		and takis.io.quakes
			P_StartQuake(takis.quakeint,1)
		end
		
		--pussy shit
		if p.inkart then p.bob = 0 end
		
		local dosquash = false
		if (me.skin == TAKIS_SKIN) or p.inkart
			dosquash = true
		end
		
		if (me.skin ~= TAKIS_SKIN)
			if not dosquash
				if (takis.spritexscale ~= FU or takis.spriteyscale ~= FU)
				or (takis.tiltvalue ~= 0
					or takis.tiltroll ~= 0
					or takis.tiltdo ~= false
				)
				or (p.jt ~= 0
					or p.jp ~= 0
				)
					takis.spritexscale,takis.spriteyscale,
					me.spritexscale,me.spriteyscale = FU,FU,FU,FU
					me.spriteyoffset = 0
					me.rollangle = 0
					p.pflags = $ &~PF_INVIS
					p.jt = 0
					p.jp = 0
				end
				takis.tiltvalue = 0
				takis.tiltdo = false
				takis.tiltroll = 0
			end
			
			if (takis.transfo)
				TakisDeShotgunify(p)
				takis.spritexscale,takis.spriteyscale,
				me.spritexscale,me.spriteyscale = FU,FU,FU,FU
				me.spriteyoffset = 0
				me.rollangle = 0
				p.pflags = $ &~PF_INVIS
				takis.transfo = 0
				p.jumpfactor = skins[p.skin].jumpfactor
			end
			
			--fuck you
			if takis.pitanim
				takis.pitanim = 0
				P_KillMobj(me,nil,nil,DMG_DEATHPIT)
			end
			
		end
		
		if dosquash
			if (me.skin ~= TAKIS_SKIN)
			and p.playerstate == PST_DEAD
				TakisDeathThinker(p,me,takis)
			end
			
			--handle this in post bc funny
			local funnymax = TR
			if takis.deathfunny
			and takis.deadtimer <= funnymax
				if takis.inSaxaMM
					if MM_N.gameover
					and MM_N.end_ticker == 3*TR
					and not MM_N.voting
						p.deadtimer = funnymax
						takis.deadtimer = funnymax
					end
				end
				me.momx,me.momy,me.momz = 0,0,0
				me.flags = $|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP
				if not (takis.freeze.tics)
					if not (me.flags & MF_NOTHINK)
						me.spritexoffset = (funnymax-takis.deadtimer)*2*FU*((leveltime & 1) and 1 or -1)
					else
						me.spritexoffset = 0
					end
					me.state = S_PLAY_DEAD
					me.frame = A
					
					if (p.inkart)
						p.inkart = 2
						me.state = S_PLAY_TAKIS_KART
						me.frame = TakisKart_KarterData[me.skin].legacyframes and TakisKart_Framesets.legacy.pain or TakisKart_Framesets.norm.pain
					end
				else
					me.spritexoffset = 0
				end
				S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET3])
				S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSPLDET4])
				takis.altdisfx = 0
				if takis.deadtimer == funnymax
					me.flags = $|MF_NOCLIPTHING &~(MF_NOGRAVITY|MF_NOCLIPHEIGHT)
					if (me.skin ~= TAKIS_SKIN)
						me.flags = $|MF_NOCLIPHEIGHT
					end
					if takis.inSaxaMM
						P_InstaThrust(me,me.deathangle or me.angle,-8*FU)
						P_MovePlayer(p)
						P_SetObjectMomZ(me,6*FU)
					else
						P_Thrust(me,
							FixedAngle(
								P_RandomRange(0,360)*FU
							),
							25*me.scale
						)
						L_ZLaunch(me,25*FU)
					end
					takis.deathfunny = false
					TakisFancyExplode(me,
						me.x, me.y, me.z,
						P_RandomRange(60,64)*me.scale,
						16,
						nil,
						15,20
					)
					DoQuake(p,120*FU,TR)
					DoFlash(p,PAL_WHITE,5)
					SpawnEnemyGibs(me,me)
					for i = 0,3
						S_StartSound(me,sfx_tkapow)
					end
					
					me.state = S_PLAY_DEAD
					me.frame = A
					
					if (p.inkart)
					or (me.state == S_PLAY_TAKIS_KART)
						local leftover = P_SpawnMobjFromMobj(me,0,0,me.height*2,MT_TAKIS_KART_LEFTOVER)
						P_SetObjectMomZ(leftover,60*FU)
						leftover.angle = me.angle
						leftover.color = p.skincolor
						leftover.destscale = me.scale*3/2
						P_SetScale(leftover,leftover.destscale)
						me.momx,me.momy = 0,0
					end
				end
				if takis.deadtimer == funnymax - 18
					S_StartSound(me,sfx_megadi)
				end
			end
			if p.playerstate ~= PST_DEAD
			and takis.deathfunny
				me.flags = $ &~(MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP)
				takis.deathfunny = false
				me.spritexoffset = 0
				takis.deadtimer = 0
			end
			
			if not (me.pizza_in or me.pizza_out)
				me.spritexscale,me.spriteyscale = takis.spritexscale,takis.spriteyscale
			end
			takis.spritexscale,takis.spriteyscale = FU,FU
			
			--tilting
			--use pitch and roll?
			if me.health
				if takis.tiltdo
					local cang = takis.tiltvalue --GetControlAngle(p)
					if not takis.tiltfreeze
						takis.tiltroll = ease.inoutsine(FU/3,$,cang)
					end
					
					local viewang = R_PointToAngle(me.x,me.y)
					local angledelta = p.drawangle - viewang
					local rolladd = FixedMul(takis.tiltroll,sin(abs(angledelta))) +
									FixedMul(takis.tiltroll,cos(angledelta))
					takis.tiltangle = rolladd --$+((rolladd - $)/10) --FixedAngle(AngleFixed(rolladd) - AngleFixed(takis.tiltangle))
					
					takis.tiltdo = false
					takis.tiltfreeze = false
				else
					if takis.tiltroll ~= 0
						if takis.inWater
							takis.tiltroll = $*7/8
						else
							takis.tiltroll = $*4/5
						end
						
						local viewang = R_PointToAngle(me.x,me.y)
						local angledelta = p.drawangle - viewang
						local rolladd = FixedMul(takis.tiltroll,sin(abs(angledelta))) +
										FixedMul(takis.tiltroll,cos(angledelta))
						takis.tiltangle = rolladd --$+((rolladd - $)/10)
					end
				end
				if takis.tiltangle ~= 0
					takis.tiltrolladd = $+((takis.tiltangle - $)/1)
					me.rollangle = $+(takis.tiltrolladd - $)
				end
			else
				takis.tiltdo = false
				takis.tiltfreeze = false
			end
			takis.tiltvalue = 0
		end
		
		if (me.skin == TAKIS_SKIN)			
			if (p.skidtime)
			and (me.state == S_PLAY_SKID)
				p.drawangle = TakisMomAngle(me)
			end
			
			if (takis.transfo & TRANSFO_TORNADO)
				p.drawangle = me.angle+takis.nadoang
			end
			
			if takis.nocontrol-3 > p.powers[pw_nocontrol]
				takis.nocontrol = p.powers[pw_nocontrol]
			end
			if p.powers[pw_nocontrol] then takis.nocontrol = p.powers[pw_nocontrol] end
			
			if takis.freeze.tics
				me.momx,me.momy,me.momz = 0,0,0
				me.flags = $|MF_NOGRAVITY
				takis.freeze.tics = $-1
				takis.stasistics = 2
				
				if takis.freeze.freezeangle
					p.drawangle = takis.freeze.freezeangle
				end
				
				if takis.freeze.tics == 0
					me.momx,me.momy,me.momz = unpack(takis.freeze.momentum)
					me.state,me.sprite2,me.frame = unpack(takis.freeze.sprites)
					p.drawangle = takis.freeze.angle
					takis.freeze.set = false
					takis.freeze.freezeangle = nil
					
					if (takis.inPain or takis.inFakePain)
						p.jp = 1
						p.jt = 5
					end
					
					me.flags = $ &~MF_NOGRAVITY
				end
			else
				if takis.freeze.set
					takis.freeze.tics = 0
					TakisResetState(p)
					me.flags = $ &~MF_NOGRAVITY
					takis.freeze.freezeangle = nil
				end
				takis.freeze.set = false
			end
			
			--get rid of ugliness
			if takis.ballretain
			or (me.state >= S_PLAY_STND and me.state <= S_PLAY_RUN and takis.c2)
			and me.state ~= S_PLAY_ROLL
			and (takis.transfo & TRANSFO_BALL)
			and me.health
				me.state = S_PLAY_ROLL
			end
			
			if (takis.afterimaging)
			and not takis.bashspin
				if me.state == S_PLAY_WALK
				or me.state == S_PLAY_RUN
					me.state = S_PLAY_DASH
					TakisResetState(p)
					p.panim = PA_DASH
				end
			end
			
			--fall out thinker
			if takis.pitanim
				local pos = takis.lastgroundedpos
				local angle = takis.lastgroundedangle
				
				if pos[1] == nil
					P_KillMobj(me,nil,nil,DMG_DEATHPIT)
					takis.saveddmgt = DMG_DEATHPIT
					takis.pitanim = 0
					return
				end
				
				local groundchecker = P_SpawnMobj(pos[1],pos[2],pos[3],MT_BLUECRAWLA)
				/*
				print("groundcheck",
					P_IsObjectOnGround(groundchecker),
					P_TryMove(me,pos[1],pos[2],false)
				)
				*/
				
				--if youve fallen into the same pit more than 2 times,
				--fall back to your starpost pos
				--(or if you were standing on a floor that isnt there anymore)
				if takis.pitcount >= 3
				--or not (P_IsObjectOnGround(groundchecker) or P_TryMove(me,pos[1],pos[2],false))
					if (p.starpostnum)
						pos = {p.starpostx*FU,p.starposty*FU,p.starpostz*FU}
						angle = p.starpostangle
					else
						pos = takis.pitbackup
						angle = takis.pitbackup[4]
					end
				end
				
				p.pflags = $|PF_JUMPED|PF_DRILLING
				
				if not me.health
					takis.pitanim = 1
				end
				
				if takis.pitanim > TR
					me.flags = $|(MF_NOCLIPTHING|MF_NOCLIP|MF_NOCLIPHEIGHT)
					if takis.pitanim == 3*TR
						me.momz = -30*me.scale*takis.gravflip --takis.lastmomz
					end
				end
				
				if takis.pitanim <= 2*TR
				and takis.pitanim >= TR
					me.momx,me.momy,me.momz = 0,0,0
					me.flags = $|MF_NOGRAVITY
					me.flags2 = $|MF2_DONTDRAW
					
					if takis.pitanim == TR
						
						P_SetOrigin(me,pos[1],pos[2],pos[3])
						if pos[4] ~= nil
							
						end
						
						me.flags2 = $ &~MF2_DONTDRAW
						me.angle = angle
						p.drawangle = me.angle
						
						takis.fakeflashing = TR+(flashingtics*2)
						p.powers[pw_flashing] = TR+(flashingtics*2)
						
						me.state = S_PLAY_STND
						P_MovePlayer(p)
						P_SpawnShieldOrb(p)
						
						TakisHealPlayer(p,me,takis,3)
						
						S_StartSound(me,sfx_shldls)
						S_StartSound(me,sfx_smack)
						DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
						S_StartAntonOw(me)
						
						p.timeshit = $+1
						takis.timeshit = $+1
						takis.totalshit = $+1
						
						--poof!
						for i = 0,5
							TakisSpawnDust(me,
								FixedAngle( P_RandomRange(-337,337)*FRACUNIT ),
								10,
								P_RandomRange(0,(me.height/me.scale)/2)*me.scale,
								{
									xspread = 0,
									yspread = 0,
									zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
									
									thrust = 0,
									thrustspread = 0,
									
									momz = P_RandomRange(10,-5)*me.scale,
									momzspread = 0,
									
									scale = me.scale/2,
									scalespread = P_RandomFixed(),
									
									fuse = 20,
								}
							)
							
						end
					end
				elseif takis.pitanim > 2*TR
					takis.fakeflashing = TR+(flashingtics*2)
					me.flags2 = $ &~MF2_DONTDRAW
				end
				
				if takis.pitanim > TR
					if me.state ~= S_PLAY_DEAD
						me.state = S_PLAY_DEAD
					end
				
					if takis.pitfunny
					and me.sprite2 ~= SPR2_FASS
						me.frame = A
						me.sprite2 = SPR2_FASS
					end
					
					if (leveltime & 1)
						local ghost = P_SpawnMobj(pos[1],pos[2],pos[3],MT_THOK)
						ghost.color = p.skincolor
						ghost.frame = A
						ghost.tics = 1
						ghost.fuse = -1
						ghost.sprite = SPR_PLAY
						ghost.skin = TAKIS_SKIN
						ghost.sprite2 = SPR2_STND
						ghost.angle = angle
						ghost.colorized = true
						ghost.blendmode = AST_ADD
						ghost.scale = me.scale
						if (displayplayer and displayplayer.valid)
						and (displayplayer == p)
							ghost.flags2 = $|MF2_DONTDRAW						
						else
							ghost.flags2 = $ &~MF2_DONTDRAW
						end
					end
						
					p.powers[pw_underwater] = 0
					p.powers[pw_spacetime] = 0
				end
				
				takis.stasistic = 1
				
				p.pflags = $ &~PF_THOKKED
				takis.pitanim = $-1
				if takis.pitanim == 0
					p.pflags = $ &~(PF_JUMPED|PF_DRILLING)
				end
				P_RemoveMobj(groundchecker)
				
			else
				me.flags = $ &~(MF_NOCLIPTHING|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY)
			end
			
			--See? Tornado's still in here!
			if p.powers[pw_carry] == CR_DUSTDEVIL	
				if me.state ~= S_PLAY_TAKIS_TORNADO
					me.state = S_PLAY_TAKIS_TORNADO
				end
				local nadodist = 60
				
				local thok = P_SpawnMobjFromMobj(me,
					nadodist*cos(p.drawangle),
					nadodist*sin(p.drawangle),
					2*me.scale,
					MT_THOK
				)
				thok.angle = p.drawangle+ANGLE_90
				thok.renderflags = $|RF_PAPERSPRITE
				thok.height,thok.radius = me.height,me.radius
				thok.tics = 3
				thok.flags2 = $|MF2_DONTDRAW
				
				otherwind(p,thok,thok.angle)
				P_RemoveMobj(thok)
			end
			
			if takis.inwaterslide
			and not (p.pflags & PF_JUMPED)
			and not p.inkart
				takis.resettingtoslide = true
				
				me.state = S_PLAY_DEAD
				me.sprite2 = SPR2_STUN
				me.frame = ($ & ~FF_FRAMEMASK)
				
			else
				takis.resettingtoslide = false
			end
			
			if me.sprite2 == SPR2_STUN
				local rotspeed = takis.accspeed+15*FU
				takis.waterangle = $+FixedAngle(rotspeed)
				
				local spd = 20*FU
				local nadodist = 30
				
				local thok = P_SpawnMobjFromMobj(me,
					nadodist*cos(me.angle+takis.waterangle),
					nadodist*sin(me.angle+takis.waterangle),
					2*me.scale,
					MT_THOK
				)
				thok.angle = me.angle+takis.waterangle+ANGLE_90
				thok.renderflags = $|RF_PAPERSPRITE
				thok.height,thok.radius = me.height,me.radius
				thok.tics = 3
				thok.flags2 = $|MF2_DONTDRAW
				
				if rotspeed >= spd
					otherwind(p,thok,thok.angle)
				end
				p.drawangle = me.angle+takis.waterangle
			else
				takis.waterangle = 0
			end
			
			if (me.state == S_PLAY_WAIT)
			and (me.sprite2 == SPR2_WAIT)
			and (takis.laststate == S_PLAY_STND)
				takis.waitframe = P_RandomRange(A, skins[p.skin].sprites[SPR2_WAIT].numframes - 1)
				me.frame = takis.waitframe
			end
			
			if (takis.weaponnext and takis.weaponprev)
			and p.playerstate == PST_LIVE
			and not takis.tauntmenu.open
			and not G_RingSlingerGametype()
			and not p.spectator
			and not (takis.inPain or takis.inFakePain)
			and not (takis.taunttime)
			and (takis.isElevated and not takis.isSinglePlayer) --LOL
			and not (takis.inNIGHTSMode and not p.nightsfreeroam)
				takis.screaming = $+1
			else
				takis.screaming = 0
			end
			
			if takis.screaming
				DoQuake(p,2*FU,1,0)
				
				local face = takis.screamface
				if (me.sprite2 ~= SPR2_ROLL
				and me.sprite2 ~= SPR2_SPIN
				and me.sprite2 ~= SPR2_SLID)
					if (me.state == S_PLAY_STND)
						me.tics = -1
					end
					
					if not takis.in2D
						p.drawangle = (p.cmd.angleturn << 16) - ANGLE_135
					end
					
					if not (face and face.valid)
						takis.screamface = P_SpawnMobjFromMobj(me,
							0,0,0,
							MT_OVERLAY
						)
						face = takis.screamface
						--TODO: make spr2 for models
						face.skin = TAKIS_SKIN
						face.state = S_PLAY_WAIT
						face.tics = -1
						face.sprite2 = SPR2_AHH_
						face.tics,face.fuse = -1,-1
						face.target = me
					end
					face.dispoffset = me.dispoffset + 1
					face.destscale = me.scale
					face.scalespeed = face.destscale + 1
					face.color = me.color
					face.angle = p.drawangle
					face.frame = ((takis.screaming) % 5)
					face.colorized = me.colorized
					P_MoveOrigin(face,
						me.x,
						me.y,
						me.z
					)
					local inc = 0
					if (takis.screaming <= 5)
						inc = (6 - takis.screaming)*(FU/20)
					end
					local ran = P_RandomRange(-FU/7,(FU/7)-1)
					face.spritexscale = FU*5/4 + inc + (me.spritexscale-FU) + ran
					face.spriteyscale = FU*5/4 + inc + (me.spriteyscale-FU) - ran*4/5
					face.spritexoffset = me.spritexoffset
					face.spriteyoffset = me.spriteyoffset
					face.rollangle = me.rollangle
					face.pitch,face.roll = me.pitch,me.roll
					face.flags2 = ($ &~MF2_DONTDRAW)|(me.flags2 & MF2_DONTDRAW)
					face.blendmode = me.blendmode
				else
					if (face and face.valid)
						P_RemoveMobj(face)
						takis.screamface = nil
					end
				end
				
				if takis.screaming == 1
					DoQuake(p,13*FU,13)
					S_StartSound(me,sfx_taksc1)
				else
					if not S_SoundPlaying(me,sfx_taksc2)
					and not S_SoundPlaying(me,sfx_taksc1)
						S_StartSound(me,sfx_taksc2)
					end
				end
			else
				if (takis.screamface and takis.screamface.valid)
					P_RemoveMobj(takis.screamface)
				end
				takis.screamface = nil
				S_StopSoundByID(me,sfx_taksc1)
				S_StopSoundByID(me,sfx_taksc2)
			end

		end
		
		
    end
end)

addHook("PlayerSpawn", function(p)
	/*
	local x,y = ReturnTrigAngles(FixedAngle(180*FU-AngleFixed(p.realmo.angle)))
	if (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		P_SpawnMobjFromMobj(p.mo,100*x,100*y,0,MT_HHTRIGGER)
	end
	*/
	--	P_SpawnMobjFromMobj(p.mo,100*x,100*y,0,MT_HHEXIT)
	
	--P_RestoreMusic(p)
	local takis = p.takistable
	p.happydeath = false
	
	if not (multiplayer or netgame)
		if (p.cmd.buttons & BT_CUSTOM3
		or input.gameControlDown(GC_CUSTOM3))
		or (takis and takis.forcerakis)
		and All7Emeralds(emeralds)
			p.skincolor = SKINCOLOR_SALMON
			p.realmo.color = SKINCOLOR_SALMON
			
			p.takis_forcerakis = true
			if takis
				takis.forcerakis = true
			end
		end
	else
		p.takis_forcerakis = nil
		if takis
			takis.forcerakis = false
		end
	end
	
	if (skins[p.skin].name == TAKIS_SKIN)
		if (mapheaderinfo[gamemap].bonustype == 1)
			if (leveltime < 5)
			or (p.jointime < 5)
			and TAKIS_NET.allowbosscards
				if takis
					local title = takis.HUD.bosstitle
					title.takis[1],title.takis[2] = unpack(title.basetakis)
					title.egg[1],title.egg[2] = unpack(title.baseegg)
					title.vs[1],title.vs[2] = unpack(title.basevs)
					title.mom = 1980
					title.tic = 3*TR
 				else
					p.takis_dotitle = true
				end
			end
		end
		
		if (mapheaderinfo[gamemap].lvlttl == "Red Room")
		and p.starpostnum == 0
			if p.takis_noabil ~= (NOABIL_ALL|NOABIL_THOK) &~NOABIL_SHOTGUN
				p.takis_noabil = (NOABIL_ALL|NOABIL_THOK) &~NOABIL_SHOTGUN
			end
			TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES["REDROOM"][1])
		elseif (mapheaderinfo[gamemap].takis_karttutorial)
		and p.starpostnum == 0
			TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES["KTUT"][1])
		else
			p.takis_noabil = nil
		end
		
		if (mapheaderinfo[gamemap].takis_karttutorial)
			if not TakisKart_Karters[p.realmo.skin]
			or p.playerstate == PST_DEAD
			or p.spectator
			or p.inkart
			or (p.realmo.flags & (MF_NOCLIP|MF_NOCLIPTHING))
			or P_CheckDeathPitCollide(p.realmo)
			or not P_IsValidSprite2(p.realmo,SPR2_KART)
				return
			end
			local k = P_SpawnMobjFromMobj(p.mo,0,0,0,MT_TAKIS_KART_HELPER)
			k.target = p.realmo
			k.angle = p.mo.angle
			k.flags2 = $|MF2_DONTDRAW
			p.inkart = 2
		end
		
		if (maptol & TOL_NIGHTS)
			p.jumpfactor = FixedMul(skins[TAKIS_SKIN].jumpfactor,6*FU/10)
		else
			if (p.jumpfactor < skins[TAKIS_SKIN].jumpfactor)
				p.jumpfactor = skins[TAKIS_SKIN].jumpfactor
			end
		end
	else
		if (p.jumpfactor < skins[p.skin].jumpfactor)
			p.jumpfactor = skins[p.skin].jumpfactor
		end
	
	end
	
	if takis
		local me = p.realmo
		
		takis.freeze.tics = 0
		takis.HUD.lives.useplacements = false
		takis.pitanim = 0
		takis.pittime = 0
		takis.pitcount = 0
		takis.pitbackup = {
			me.x, me.y, me.z, me.angle, P_MobjFlip(me)
		}
		
		if takis.lastmap == 1000
		and G_BuildMapTitle(1000) == "Red Room"
		and takis.lastminhud ~= nil
			takis.io.minhud = takis.lastminhud
			takis.lastminhud = nil
		end
		
		if takis.cosmenu.menuinaction
			TakisMenuOpenClose(p)
		end
		
		if All7Emeralds(emeralds)
		and not All7Emeralds(takis.lastemeralds)
		and (skins[p.skin].name == TAKIS_SKIN)
			TakisAwardAchievement(p,ACHIEVEMENT_SPIRIT)
		end
		
		if takis.gotemeralds ~= emeralds
		and (gametyperules & GTR_FRIENDLY)
			takis.emeraldcutscene = 3*TR
		end
		
		takis.lastemeralds = emeralds
		takis.spiritlist = {}
		takis.quake = {}
		takis.deadtimer = 0
		
		TakisResetHammerTime(p)
		TakisDeShotgunify(p)
		takis.transfo = 0
		p.jumpfactor = skins[p.skin].jumpfactor
		
		p.exiting = 0
		takis.heartcards = TAKIS_MAX_HEARTCARDS
		
		takis.taunttime = 0
		takis.tauntid = 0
		
		takis.clutchingtime = 0
		takis.clutchspamcount = 0
		
		takis.yeahed = false
		takis.yeahwait = 0
		
		takis.thokked, takis.dived = false,false
		
		takis.combo.time = 0
		
		takis.wentfast = 0
		
		if (takis.body and takis.body.valid)
		and not G_RingSlingerGametype()
			P_KillMobj(takis.body)
		end
		takis.body = 0
		
		/*
		if ((takis.shotgun) and (takis.shotgun.valid))
			P_KillMobj(takis.shotgun,me)
		end
		takis.shotgun = 0
		takis.shotgunned = false
		
		if ((S_MusicName() == "WAR") or (S_MusicName() == "war"))
			P_RestoreMusic(p)
		end
		
		if ((p.mo) and (p.mo.valid))
			takis.lastgroundedpos = {p.mo.x,p.mo.y,p.mo.z}
		end
		*/
		
		takis.fakeflashing = 0
		takis.stasistic = 0
		
		takis.timeshit = p.timeshit
		
		takis.combo.outrotics = 0
		
		TakisResetTauntStuff(p,true)
		
		if gamemap ~= takis.lastmap
		or gamemap ~= takis.lastgt
		or (leveltime < 3)
			takis.combo.dropped = false
			takis.combo.awardable = false
			takis.combo.pacifist = true
		end
		
		if not (splitscreen or multiplayer)
		and p.starpostnum == 0
			takis.combo.dropped = false
			takis.combo.awardable = false
			takis.combo.pacifist = true
		end
		
	else
		if ultimatemode
			p.takis = {
				shotgunnotif = 6*TR
			}
		end
	end
	if ultimatemode
	and not (G_IsSpecialStage(gamemap) or maptol & TOL_NIGHTS)
	and (skins[p.skin].name == TAKIS_SKIN)
		local angle = p.realmo.angle+ANGLE_90
		P_SpawnMobjFromMobj(p.realmo,
			P_ReturnThrustX(nil,angle,55*FU),
			P_ReturnThrustY(nil,angle,55*FU),
			0,MT_SHOTGUN_BOX
		)
	end

end)

addHook("PlayerCanDamage", function(p, mobj)
	if not p.mo 
	or not p.mo.valid 
		return
	end
	
	if p.mo and p.mo.valid and p.mo.skin == TAKIS_SKIN
		if not p.takistable
			return
		end
		
		local me = p.mo
		local takis = p.takistable
		
		if takis.afterimaging
		or (
			( me.state == S_PLAY_TAKIS_SLIDE or (takis.transfo & TRANSFO_BALL))
			and
			--we need to be able to make afterimages to do this!
			not (takis.noability & (NOABIL_CLUTCH|NOABIL_HAMMER))
		)
		or (takis.transfo & (TRANSFO_TORNADO|TRANSFO_METAL)
		or p.powers[pw_invulnerability])
		or (p.inkart)
		
			if L_ZCollide(me,mobj)
			and CanFlingThing(mobj)
				SpawnEnemyGibs(me,mobj)
				SpawnBam(mobj,true)
				
				local ragdoll = SpawnRagThing(mobj,me)
				if (me.state == S_PLAY_TAKIS_SLIDE)
					S_StartSound(me,sfx_smack)
				end
				if (takis.transfo & TRANSFO_BALL)
					S_StartSound(me,sfx_bowl)
				end
				S_StartSound(me,sfx_sdmkil)
				
				if (takis.transfo & TRANSFO_METAL
				or p.powers[pw_invulnerability])
					if (ragdoll and ragdoll.valid)
						S_StartSound(ragdoll,sfx_takcat)
					end
				end
				
				return true
			end
			
		end
	end
end)

local function kartpain(me,inf)
	local p = me.player
	spillrings(p)
	TakisKart_DoSpinout(p,inf)
	
	/*
	if not p.inkart then return end
	if not (me.tracer and me.tracer.valid) then return end
	local car = me.tracer
	
	p.powers[pw_flashing] = flashingtics*2
	car.inpain = true
	car.painangle = car.angle
	P_SetObjectMomZ(car,P_RandomRange(25,30)*car.scale)
	SpawnBam(me,true)
	--S_StartAntonOw(car)
	car.fuel = $-(5*FU)
	car.damagetic = TR
	car.driftspark = 0
	if (inf and inf.valid)
		local ang = R_PointToAngle2(inf.x,inf.y,car.x,car.y)
		local thrust = FixedHypot(FixedHypot(inf.momx,inf.momy),inf.momz)
		local speed = FixedHypot(FixedHypot(car.momx,car.momy),car.momz)
		P_Thrust(car,ang,-thrust)
	end
	*/

end

--handle takis damage here
--freeroam damage is handled in the ShouldDamage
--something here is resynching...
addHook("MobjDamage", function(mo,inf,sor,dmg,dmgt)
	if not (mo and mo.valid)
		return
	end
	
	local p = mo.player 
	local takis = p.takistable

	if takis.inFakePain
		return true
	end
	
	if ((p.powers[pw_flashing])
	and (p.powers[pw_carry] == CR_NIGHTSMODE))
		return
	end

	if p.deadtimer > 10
		return
	end
	
	if mo.skin ~= TAKIS_SKIN
		return
	end
	
	if takis.pitanim then return end
	--if takis.pittime then return end
	if p.ptsr and p.ptsr.outofgame then return end
	if (p.guard and p.guard == 1) then return end
	
	p.pflags = $ &~PF_SHIELDABILITY
	
	--fireass
	local extraheight = false
	if not (takis.noability & NOABIL_TRANSFO)
		if dmgt == DMG_FIRE
		and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
			if not (p.powers[pw_shield] & SH_PROTECTFIRE)
			and not (takis.transfo & TRANSFO_FIREASS)
				S_StartSound(mo,sfx_fire)
				S_StartSound(mo,sfx_trnsfo)
				takis.transfo = $|TRANSFO_FIREASS
				takis.fireasssmoke = TR/2
				takis.fireasstime = TAKIS_MAX_TRANSFOTIME
				extraheight = true
				mo.state = S_PLAY_DEAD
				mo.frame = A
				mo.sprite2 = SPR2_FASS
				TakisAwardAchievement(p,ACHIEVEMENT_FIREASS)
			else
				--return true
			end
		end

		if dmgt == DMG_SPIKE
		and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
			--if not (p.powers[pw_shield] & SH_PROTECTSPIKE)
			if not (takis.transfo & TRANSFO_METAL)
				S_StartSound(mo,sfx_spkdth)
				S_StartSound(mo,sfx_trnsfo)
				takis.transfo = $|TRANSFO_METAL
				TakisAwardAchievement(p,ACHIEVEMENT_METALSIGMA)
				takis.metaltime = TAKIS_MAX_TRANSFOTIME
				P_PlayJingleMusic(p,"_metlc",0,true,JT_OTHER)
				return true
			else
				return true
			end
		end

		if dmgt == DMG_WATER
		and (takis.transfo & TRANSFO_FIREASS)
			takis.transfo = $ &~TRANSFO_FIREASS
			return false
		end
	end
	
	if mo.health
	or (takis.heartcards)
		S_StartSound(mo,sfx_smack)
		SpawnBam(mo,true)
		DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
		if takis.heartcards > (not extraheight and 1 or 0)
			S_StartAntonOw(mo)
		end
	end

	if p.powers[pw_carry] == CR_NIGHTSMODE
		if not multiplayer
			if HAPPY_HOUR.happyhour
				HAPPY_HOUR.timelimit = p.nightstime
				p.powers[pw_flashing] = $*2
			end
		end
		
		return
	end
	
	--combo penalty
	if (takis.shotgunned)
		TakisGiveCombo(p,takis,false,false,true)
	end
	
	if takis.heartcards > 0
		
		TakisResetTauntStuff(p)
		
		if (p.takis_noabil ~= nil)
			if (takis.heartcards ~= 1)
				if (takis.timeshit == 0)
					TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES["REDROOM"].timeshit)
				end
			else
				S_StartSound(mo,sfx_cdfm46)
				P_InstaThrust(mo,mo.angle,-5*mo.scale)
				L_ZLaunch(mo,8*mo.scale)
				mo.state = S_PLAY_ROLL
				p.pflags = $ &~(PF_THOKKED|PF_JUMPED)
				TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES["REDROOM"].kys,true)
				takis.fakeflashing = flashingtics*2
				return true
			end
			
		end
		
		SpawnEnemyGibs(inf or mo,mo,nil,nil,false)
		TakisResetHammerTime(p)
		
		if (inf and inf.valid)
		and inf.flags & MF_MISSILE
			dmg = $*2
		end
		
		local damage = max(1,min(TAKIS_MAX_HEARTCARDS,dmg))
		if extraheight
			damage = 0
		end
		
		--DUDE WTFFFFFF
		if extraheight == false
			--DIE
			if takis.heartcards == 1
			or (takis.heartcards - damage <= 0)
			and (damage > 0)
			--??? above checks SHOULD fail, but they dont?????
			and not extraheight
				/*
				mo.health = 0
				p.playerstate = PST_DEAD
				mo.state = S_PLAY_DEAD
				*/
				
				/*
				if mo.health
					print("ASDSADS")
					P_KillMobj(mo,inf,sor,dmgt)
				end
				*/
				
				for i = sfx_antow1,sfx_antow7
					S_StopSoundByID(mo,i)
				end
				
				if (gametyperules &
				(GTR_POINTLIMIT|GTR_RINGSLINGER|GTR_HURTMESSAGES)
				or G_RingSlingerGametype())
				and (sor and sor.valid and sor.player)
					P_AddPlayerScore(sor.player,100)
				end
				P_KillMobj(mo,inf,sor,dmgt)
				
				--lose EVERYTHING
				spillrings(p,true)
				
				return true
			end
		end
		TakisHurtMsg(p,inf,sor,dmgt)
		
		P_DoPlayerPain(p,sor,inf)
		--p.powers[pw_flashing] = TR
		takis.ticsforpain = TR
		S_StartSound(mo,sfx_shldls)
		
		if (p.powers[pw_shield] == SH_NONE)
			if damage > 0
				TakisHealPlayer(p,mo,takis,3,damage)
				spillrings(p)
			end
		else
			if damage > 0
				P_RemoveShield(p)
			end
		end
		
		if damage > 0
			p.timeshit = $+1
			if (p.gotflag)
				P_PlayerFlagBurst(p,false)
			end
			takis.timeshit = $+1
			takis.totalshit = $+1
			
			if takis.totalshit % 5 == 0
				takis.HUD.timeshit = 5*TR+9
			end
			
			if takis.totalshit >= 100 then TakisAwardAchievement(p,ACHIEVEMENT_OFFICER) end
			
			if takis.combo.time
				takis.combo.penalty = $+1
				takis.HUD.combo.penaltyshake = TR/2
			end
			
		end
		
		if p.inkart
		--and (takis.heartcards > 1)
			kartpain(mo,inf,sor)
			return true
		end
		
		if inf
		and inf.valid
			local ang = R_PointToAngle2(mo.x,mo.y, inf.x, inf.y)
			local infspeed = FixedHypot(FixedHypot(inf.momx,inf.momy),inf.momz)/3
			P_InstaThrust(mo,ang,-GetPainThrust(mo,inf,sor))
			P_Thrust(mo,R_PointToAngle2(0,0,inf.momx,inf.momy),infspeed)
		end
		L_ZLaunch(mo,(extraheight) and 17*mo.scale or 8*mo.scale)
		if not extraheight
			mo.state = S_PLAY_PAIN
		end
		
		takis.inFakePain = true
		p.pflags = $ &~(PF_THOKKED|PF_JUMPED)
		takis.thokked = false
		takis.dived = false
		if (dmgt == DMG_ELECTRIC)
			S_StartSound(mo,sfx_buzz2)
			mo.state = S_PLAY_DEAD
			takis.transfo = $|TRANSFO_ELEC
			takis.electime = TR*3/2
			L_ZLaunch(mo,4*mo.scale)
		end
		
		--award points to source
		if (sor and sor.valid
		and sor.player and sor.player.valid)
			if (gametyperules &
			(GTR_POINTLIMIT|GTR_RINGSLINGER|GTR_HURTMESSAGES)
			or G_RingSlingerGametype())
				P_AddPlayerScore(sor.player,50)
			end
		end
		
		return true
	
	end
	
end,MT_PLAYER)

addHook("MobjDamage", function(tar,inf,src)
	if not tar
	or not tar.valid
		return
	end
	
	if not src
	or not src.valid
		return
	end
	
	if src.player
	and src.skin == TAKIS_SKIN
	and src.player.takistable.combo.time
		TakisGiveCombo(src.player,src.player.takistable,false,true)
	end
end,MT_PLAYER)

--enemy knockback
local function stopmom(takis,me,ang)
	if takis.accspeed < (takis.in2D and (6*(40*FU)/5)*3/4 or (6*(40*FU)/5))
		if (me.player.powers[pw_invulnerability] == 0)
		and not (me.player.pflags & PF_SPINNING)
		and not (HAPPY_HOUR.othergt
		and HAPPY_HOUR.happyhour)
			me.momx,me.momy = 0,0
			me.state = S_PLAY_TAKIS_KILLBASH
			TakisResetHammerTime(me.player)
			L_ZLaunch(me,6*me.scale)
			P_Thrust(me,ang,-6*me.scale)
			takis.ropeletgo = 8
		end
	else
		--S_StartSound(me,sfx_takcat)
		P_Thrust(me,TakisMomAngle(me),13*me.scale)
		
		for i = 0,9
			TakisDoWindLines(me)
		end
		
		if not (me.player.pflags & PF_SPINNING or me.player.inkart)
			takis.bashspin = TR/2
		end
	end
	
	
	/*
	takis.hitlag.tics = TR/4
	takis.hitlag.speed = takis.accspeed
	takis.hitlag.momz = me.momz*takis.gravflip
	takis.hitlag.angle = me.player.drawangle
	takis.hitlag.frame = me.frame
	takis.hitlag.sprite2 = me.sprite2
	takis.hitlag.pflags = me.player.pflags
	*/
end

local function clutchhurt(t,tm)
	local p = t.player
	local takis = p.takistable
	local me = p.mo
	
	if CanPlayerHurtPlayer(p,tm.player)
		local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
		stopmom(takis,me,ang)
		
		TakisAddHurtMsg(tm.player,p,HURTMSG_CLUTCH)
		P_DamageMobj(tm,t,t,2)
		
		SpawnEnemyGibs(t,tm)
		SpawnBam(tm,{me.momx,me.momy})

		S_StartSound(tm,sfx_smack)
		
		ang = R_PointToAngle2(tm.x,tm.y, t.x,t.y)
		if tm.health
			P_Thrust(tm,ang,-6*me.scale)
			P_MovePlayer(tm.player)
		end
	end
end

local function knockbacklolll(t,tm)
	if not (t and t.valid)
		return
	end
	
	if not (tm and tm.valid)
		return
	end
	
	if not L_ZCollide(t,tm)
		return
	end
	
	local p = t.player
	local takis = p.takistable
	local me = p.mo
	
	--BUT.....
	if t.skin ~= TAKIS_SKIN
		return
	end

	if tm.parent == t
		return false
	end
	
	local takis = t.player.takistable
	
	--is this a player we're running into?
	if tm.type == MT_PLAYER
		if t.skin == TAKIS_SKIN
			if (takis.accspeed < 60*FU)
			
				--are we both afterimaging?
				if ((takis.afterimaging) and (tm.player.takistable.afterimaging))
					
					--heartcard priority
					if takis.heartcards > tm.player.takistable.heartcards
						clutchhurt(t,tm)
					
					--port priority
					--melee reference !!
					elseif #p < #tm.player
						clutchhurt(t,tm)
					end
				elseif (takis.afterimaging)
					clutchhurt(t,tm)
				end
			
			--going fast turns the other person into mush
			else
				--this strangly still kills momentum,,,
				--ehh whatever
				
				--are we both afterimaging?
				if ((takis.afterimaging) and (tm.player.takistable.afterimaging))
					
					--we have to be going faster than the other guy
					if takis.accspeed > tm.player.takistable.accspeed
					and CanPlayerHurtPlayer(p,tm.player)
						SpawnEnemyGibs(t,tm)
						SpawnBam(tm,true)
						
						S_StartSound(t,sfx_bsnipe)
						S_StartSound(tm,sfx_buzz3)
						S_StartSound(tm,sfx_bsnipe)
						local ki = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_BROLYKI)
						ki.tracer = tm
						ki.color = tm.color
						ki.scalemul = FU/2
						tm.takis_ultradeath = true
						
						TakisAddHurtMsg(tm.player,p,HURTMSG_CLUTCH)
						P_DamageMobj(tm,t,t,1,DMG_INSTAKILL)
						
						LaunchTargetFromInflictor(1,t,tm,63*t.scale,takis.accspeed/5)
						P_MovePlayer(tm.player)
						return true
					end
				
				elseif (takis.afterimaging)
					if CanPlayerHurtPlayer(p,tm.player)
						
						SpawnEnemyGibs(t,tm)
						SpawnBam(tm,true)
						
						S_StartSound(t,sfx_bsnipe)
						S_StartSound(tm,sfx_buzz3)
						S_StartSound(tm,sfx_bsnipe)
						local ki = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_BROLYKI)
						ki.tracer = tm
						ki.color = tm.color
						ki.scalemul = FU/2
						tm.takis_ultradeath = true
						
						TakisAddHurtMsg(tm.player,p,HURTMSG_CLUTCH)
						P_DamageMobj(tm,t,t,1,DMG_INSTAKILL)
						
						LaunchTargetFromInflictor(1,t,tm,63*t.scale,takis.accspeed/5)
						P_MovePlayer(tm.player)
						return true
					end
				end
				
			end
		end
		return
	end
	
	if tm.dontclutchintome ~= nil then return end
	
	if CanFlingThing(tm,MF_ENEMY|MF_BOSS|MF_SHOOTABLE)
		if takis.afterimaging
		or p.pflags & PF_SPINNING
		or p.inkart
			local ang = R_PointToAngle2(t.x,t.y, tm.x,tm.y)
			stopmom(takis,me,ang)
			
			if takis.accspeed >= 45*FU
				local diff = takis.accspeed - 45*FU
				DoQuake(p,diff/2, 20 + (diff/FU/2))
			end
			S_StartSound(tm,sfx_smack)
			S_StartSound(me,sfx_sdmkil)
			SpawnEnemyGibs(t,tm,ang)
			SpawnBam(tm,true)
			
			local ragdoll = SpawnRagThing(tm,t)
			if (me.state == S_PLAY_TAKIS_SLIDE)
				S_StartSound(me,sfx_smack)
			end
			if (takis.transfo & TRANSFO_BALL)
				S_StartSound(me,sfx_bowl)
			end
			if (ragdoll and ragdoll.valid)
			and (takis.accspeed >= (6*(40*FU)/5)
			--always "fling" them if you have guaranteed invuln!
			--actually... lets handle this elsewhere
			or (takis.transfo & TRANSFO_METAL or p.powers[pw_invulnerability]))
				S_StartSound(ragdoll,sfx_takcat)
			end
			
		end
		
	end
	
end

addHook("ShouldDamage", function(mo,inf,sor,dmg,dmgt)
	if not (mo and mo.valid)
		return
	end
	
	if mo.skin ~= TAKIS_SKIN
		return
	end
	
	local p = mo.player
	local takis = p.takistable
	
	--youre already dead, what???
	/*
	if takis.deadtimer > 10
		return
	end
	*/
	
	if takis.pitanim 
		return false
	end
	
	--BUT!!
	if (p.powers[pw_shield] == SH_ARMAGEDDON)
	and not (dmgt & DMG_DEATHMASK)
		TakisPowerfulArma(p)
		takis.fakeflashing = flashingtics*2
		return false
	end
	
	if dmgt == DMG_WATER
	and (takis.transfo & TRANSFO_FIREASS)
		takis.transfo = $ &~TRANSFO_FIREASS
		return false
	end
	
	--freeroam damage
	if p.nightsfreeroam
	and p.powers[pw_carry] != CR_NIGHTSMODE
	and not p.powers[pw_flashing]
		if (inf == mo
		or sor == mo)
			return
		end
		
		--fireass
		local extraheight = false
		if dmgt == DMG_FIRE
		and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
			if not (p.powers[pw_shield] & SH_PROTECTFIRE)
			and not (takis.transfo & TRANSFO_FIREASS)
				S_StartSound(mo,sfx_trnsfo)
				takis.transfo = $|TRANSFO_FIREASS
				takis.fireasssmoke = TR/2
				takis.fireasstime = TAKIS_MAX_TRANSFOTIME
				extraheight = true
				TakisAwardAchievement(p,ACHIEVEMENT_FIREASS)
			else
				takis.fireasstime = $+3
				if takis.fireasstime > TAKIS_MAX_TRANSFOTIME
					takis.fireasstime = TAKIS_MAX_TRANSFOTIME
				end
				return false
			end
		end
		
		if dmgt == DMG_SPIKE
		and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
			--if not (p.powers[pw_shield] & SH_PROTECTSPIKE)
			if not (takis.transfo & TRANSFO_METAL)
				S_StartSound(mo,sfx_spkdth)
				S_StartSound(mo,sfx_trnsfo)
				takis.transfo = $|TRANSFO_METAL
				TakisAwardAchievement(p,ACHIEVEMENT_METALSIGMA)
				takis.metaltime = TAKIS_MAX_TRANSFOTIME
				P_PlayJingleMusic(p,"_metlc",0,true,JT_OTHER)
				return true
			else
				return true
			end
		end
	
		if not extraheight
			S_StartSound(mo,sfx_nghurt)
			if p.nightstime > TICRATE*5
				p.nightstime = $-TICRATE*5
			else
				p.nightstime = 0
			end
		end
		
		S_StartSound(mo,sfx_smack)
		DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
		if not p.inkart
			S_StartAntonOw(mo)
		end
		
		SpawnEnemyGibs(inf or mo,mo,nil,nil,false)

		TakisResetHammerTime(p)

		P_DoPlayerPain(p,sor,inf)
		takis.ticsforpain = TR

		S_StartSound(mo,sfx_shldls)
		if (dmgt == DMG_SPIKE)
			S_StartSound(mo,sfx_spkdth)
		end
		
		p.timeshit = $+1
		takis.timeshit = $+1
		takis.totalshit = $+1
		
		if takis.totalshit >= 100 then TakisAwardAchievement(p,ACHIEVEMENT_OFFICER) end
		if inf
		and inf.valid
			local ang = R_PointToAngle2(mo.x,mo.y, inf.x, inf.y)
			P_InstaThrust(mo,ang,GetPainThrust(mo,inf,sor))
		end
		L_ZLaunch(mo,(extraheight) and 17*mo.scale or 8*mo.scale)
		if not extraheight
			mo.state = S_PLAY_PAIN
		else
			mo.state = S_PLAY_DEAD
		end
		
		takis.inFakePain = true
		p.pflags = $ &~(PF_THOKKED|PF_JUMPED)
		takis.thokked = false
		takis.dived = false
		if (dmgt == DMG_ELECTRIC)
			S_StartSound(mo,sfx_buzz2)
			mo.state = S_PLAY_DEAD
			takis.transfo = $|TRANSFO_ELEC
			takis.electime = TR*3/2
			L_ZLaunch(mo,4*mo.scale)
		end
		
		return
	end
	
	--quit camping, crawla!
	if takis.inFakePain
		return false
	end
	
	--allow players to get fireass even with fire shields
	if not (takis.noability & NOABIL_TRANSFO)
		if dmgt == DMG_FIRE
		and (p.powers[pw_shield] & SH_PROTECTFIRE
		or (inf and inf.valid and inf.type == MT_FIREBALL))
			if not (takis.transfo & TRANSFO_FIREASS)
				S_StartSound(mo,sfx_trnsfo)
				takis.transfo = $|TRANSFO_FIREASS
				takis.fireasssmoke = TR/2
				takis.fireasstime = TAKIS_MAX_TRANSFOTIME
				TakisAwardAchievement(p,ACHIEVEMENT_FIREASS)
			else
				if (inf and inf.valid and inf.type == MT_FIREBALL)
					takis.fireasstime = TAKIS_MAX_TRANSFOTIME
				else
					takis.fireasstime = $+3
				end
				if takis.fireasstime > TAKIS_MAX_TRANSFOTIME
					takis.fireasstime = TAKIS_MAX_TRANSFOTIME
				end
			end
		end
		--same here
		if dmgt == DMG_SPIKE
			if not (takis.transfo & TRANSFO_METAL)
				S_StartSound(mo,sfx_spkdth)
				S_StartSound(mo,sfx_trnsfo)
				takis.transfo = $|TRANSFO_METAL
				P_PlayJingleMusic(p,"_metlc",0,true,JT_OTHER)
				TakisAwardAchievement(p,ACHIEVEMENT_METALSIGMA)
				takis.metaltime = TAKIS_MAX_TRANSFOTIME
				return false
			else
				return false
			end
		end
	end
	
	if not (dmgt & DMG_DEATHMASK)
	and (takis.transfo & TRANSFO_METAL)
	and dmgt ~= DMG_FIRE
	
		if (inf and inf.valid)
			local angle = R_PointToAngle2(mo.x,mo.y,inf.x,inf.y)
			P_Thrust(mo,angle,-10*inf.scale)
			
			S_StartSound(mo,sfx_takmtd)
			local insta = P_SpawnMobjFromMobj(mo,0,0,0,MT_OVERLAY)
			insta.target = mo
			insta.state = S_TAKIS_INSTASHEILD
			insta.fuse = 10
			insta.tics = 10
			insta.color = SKINCOLOR_SAPPHIRE
			insta.colorized = true
		end
		if dmgt == DMG_ELECTRIC
			local rad = mo.radius/FRACUNIT
			local hei = mo.height/FRACUNIT
			local x = P_RandomRange(-rad,rad)*FRACUNIT
			local y = P_RandomRange(-rad,rad)*FRACUNIT
			local z = P_RandomRange(0,hei)*FRACUNIT
			local spark = P_SpawnMobjFromMobj(mo,x,y,z,MT_SOAP_SUPERTAUNT_FLYINGBOLT)
			spark.tracer = mo
			spark.state = P_RandomRange(S_SOAP_SUPERTAUNT_FLYINGBOLT1,S_SOAP_SUPERTAUNT_FLYINGBOLT5)			
			spark.blendmode = AST_ADD
			spark.color = P_RandomRange(SKINCOLOR_SUPERGOLD1,SKINCOLOR_SUPERGOLD5)
			spark.angle = p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT ))
		end
		return false
	end
	
	--Fall out!
	if dmgt == DMG_DEATHPIT
		if p.exiting then return end
		if TAKIS_NET.inspecialstage then return end
		if p.pflags & PF_GODMODE then return false end
		if (p.ptsr and p.ptsr.outofgame) then return false end
		
		--cartoony effect where takis drops with a
		--smoke cloud in his shape
		--
		local ghs = P_SpawnGhostMobj(mo)
		ghs.tics = -1
		ghs.frame = mo.frame
		ghs.colorized = true
		ghs.angle = p.drawangle
		ghs.fuse = 23
		ghs.color = SKINCOLOR_WHITE
		
		for i = 10,P_RandomRange(15,20)
			TakisSpawnDust(mo,
				p.drawangle+(FixedAngle( P_RandomRange(-337,337)*FRACUNIT )),
				10,
				P_RandomRange(0,mo.height/FU)*FRACUNIT,
				{
					xspread = 0,
					yspread = 0,
					zspread = (P_RandomFixed()*((P_RandomChance(FU/2)) and 1 or -1)),
					
					thrust = 0,
					thrustspread = 0,
					
					momz = 0,
					momzspread = 0,
					
					scale = mo.scale,
					scalespread = P_RandomFixed(),
					
					fuse = 20+P_RandomRange(-3,3),
				}
			)
		end
		--
		
		spillrings(p)
		S_StartSound(mo,sfx_s3k51)
		
		local forcedeath = false
		if takis.inBattle
		or circuitmap
		or takis.inSaxaMM
			forcedeath = true
		end
		
		if takis.heartcards > 1
		and TAKIS_NET.allowfallout
		and not (forcedeath)
			TakisResetHammerTime(p)
			mo.state = S_PLAY_DEAD
			
			takis.pitfunny = P_RandomChance(FU/4)
			if takis.pitfunny
				mo.sprite2 = SPR2_FASS
				S_StartSound(mo,sfx_takoww)
			end
			
			takis.pitanim = 3*TR
			takis.pittime = 3*TR
			takis.pitcount = $+1
			--take away some combo
			TakisGiveCombo(p,takis,false,false,true)
			
			--so you dont jump as you touch it
			takis.stasistic = 3
			p.powers[pw_nocontrol] = 3
			p.pflags = $|PF_FULLSTASIS &~PF_THOKKED
			if (p.powers[pw_underwater]
			and p.powers[pw_underwater] < 12*TR + 1)
				P_RestoreMusic(p)
			end
			
			return false
		else
			return true
		end
		
		/*
		if takis.timesdeathpitted > 5
			takis.saveddmgt = DMG_DEATHPIT
			return true
		end
		if takis.heartcards ~= 1
			if p.powers[pw_flashing] == 0
				TakisHealPlayer(p,mo,takis,3)
				DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
				
				p.timeshit = $+1
				takis.timeshit = $+1
				takis.totalshit = $+1
				if takis.totalshit >= 100 then TakisAwardAchievement(p,ACHIEVEMENT_OFFICER) end
				
				S_StartSound(mo,sfx_smack)
				S_StartAntonOw(mo)
				TakisHurtMsg(p,inf,sor,DMG_DEATHPIT)
				takis.pittime = 6
			end
			
			takis.timesdeathpitted = $+1
			TakisResetHammerTime(p)
			
			L_ZLaunch(mo,20*mo.scale*takis.timesdeathpitted)
			mo.state = S_PLAY_ROLL
			p.pflags = $|PF_JUMPED &~(PF_THOKKED|PF_SPINNING)
			takis.thokked = false
			takis.dived = false
			takis.fakeflashing = flashingtics*2
			takis.HUD.statusface.painfacetic = 3*TR
			
			return false
		end
		*/
		
	elseif dmgt == DMG_CRUSHED
		if takis.timescrushed < TR
			if not takis.beingcrushed
			and takis.timescrushed < 2
				SpawnEnemyGibs(mo,mo)
			end
			takis.beingcrushed = true
			return false
		end
	elseif dmgt == DMG_FIRE
		if takis.transfo & TRANSFO_FIREASS
			if takis.fireasstime < TAKIS_MAX_TRANSFOTIME
			and not takis.fireregen
				takis.fireregen = 2
				takis.fireasstime = $+8	
			end			
			return false
		end
	end
	
end,MT_PLAYER)

addHook("PlayerHeight",function(p)
	if not p
	or not p.valid
		return
	end
	
	if not p.takistable
		return
	end
	
	if ((p.realmo) and (p.realmo.valid))
		local me = p.realmo
		local takis = p.takistable
		
		if me.skin == TAKIS_SKIN
			if me.sprite2 == SPR2_TDD3
				return 15*me.scale
			end
			if takis.crushtime
			or (p.playerstate == PST_DEAD and takis.saveddmgt == DMG_CRUSHED)
				local high = P_GetPlayerHeight(p)
				if p.pflags & PF_SPINNING
					high = P_GetPlayerSpinHeight(p)
				end
				
				return FixedMul(high,FixedDiv(me.spriteyscale,FU))
			end
			if (takis.transfo & TRANSFO_TORNADO)
			and not (takis.nadocrash)
				return P_GetPlayerSpinHeight(p)
			end
		end
	end
end)

addHook("PlayerCanEnterSpinGaps",function(p)
	if not p
	or not p.valid
		return
	end
	
	if not p.takistable
		return
	end
	
	if ((p.realmo) and (p.realmo.valid))
		local me = p.realmo
		local takis = p.takistable
		
		if me.skin == TAKIS_SKIN
			local phigh = me.height
			
			if takis.crushtime
				local high = P_GetPlayerHeight(p)
				if p.pflags & PF_SPINNING
					high = P_GetPlayerSpinHeight(p)
				end
				phigh = FixedMul(high,FixedDiv(takis.spriteyscale,FU))
			end
			if ((takis.transfo & TRANSFO_TORNADO)
			and not (takis.nadocrash))
			or (me.state == S_PLAY_TAKIS_SLIDE)
				phigh = P_GetPlayerSpinHeight(p)
			end
			
			if phigh <= P_GetPlayerSpinHeight(p)
				return true
			end
		end
	end
end)

local function givecardpieces(mo, _, source)

	if not (source and source.valid)
		return
	end
	
	if source
	and source.player
	and source.player.valid
	
		if source.skin == TAKIS_SKIN
			if source.player.takistable.combo.time
			and mo.takis_givecombotime
				TakisGiveCombo(source.player,source.player.takistable,false)
			end
			
			local givescore = true
			if G_RingSlingerGametype()
			or source.player.takistable.inBattle
				givescore = false
			end
			if (HAPPY_HOUR.othergt) then givescore = false end
			
			if mo.takis_ringtype
				if mo.flags & MF_ENEMY
					print("\x83TAKIS: \x82WARNING\x80: givecardpieces(): Attempted to make non-ring mobj a ring patch!!! ("..source.player.name..")")
					print(string.format("\x83".."DEBUG:\x80 type: %d SPR_: %s",mo.type,sprnames[mo.sprite] or "nil"))
					S_StartSound(nil,sfx_skid)
				end
				source.player.takistable.HUD.rings.sprite = sprnames[mo.sprite] or "RING"
				source.player.takistable.HUD.rings.type = mo.type
			end
			
			--stop being OP >:(
			if mo.takis_givecombotime
				
				if (givescore == true)
					P_AddPlayerScore(source.player,10)
				end
			end
		end
		
		if source.player.powers[pw_carry] == CR_TAKISKART
		and mo.takis_givecombotime
		and (source.tracer and source.tracer.valid and source.tracer.takiscar)
			source.tracer.fuel = $+3*FU
			if source.tracer.fuel > 100*FU
				source.tracer.fuel = 100*FU
			end
			source.tracer.ringboost = $+5
		end
	end
	
end

addHook("MobjDeath", givecardpieces)

--thing died by takis
local function hurtbytakis(mo,inf,sor,_,dmgt)
	if not (mo and mo.valid) then return end
	
	if (not mo.health
	and CanFlingThing(mo,MF_ENEMY))
	and (sor and sor.skin == TAKIS_SKIN)
	and not ultimatemode
		if CanFlingThing(mo,MF_ENEMY)
			if P_RandomChance(FU/4)
			and (TAKIS_NET.cards)
			and (gametyperules & GTR_FRIENDLY)
				local card = P_SpawnMobjFromMobj(mo,0,0,mo.height*P_MobjFlip(mo),MT_TAKIS_HEARTCARD)
				L_ZLaunch(card,10*mo.scale)
				mo.heartcard = card
			end
		end
	end
	
	if not sor
	or not sor.valid
		--did something die outta nowhere?
		if not mo.health
		and CanFlingThing(mo)
			for p2 in players.iterate
				if not (p2 and p2.valid) then continue end
				if p2.quittime then continue end
				if p2.spectator then continue end
				if not (p2.mo and p2.mo.valid) then continue end
				if (not p2.mo.health) or (p2.playerstate ~= PST_LIVE) then continue end
				if (p2.mo.skin ~= TAKIS_SKIN) then continue end
				
				--forgot radius
				if not P_CheckSight(mo,p2.mo) then continue end
				local dx = p2.mo.x-mo.x
				local dy = p2.mo.y-mo.y
				local dz = p2.mo.z-mo.z
				local dist = TAKIS_TAUNT_DIST*5
				
				if FixedHypot(FixedHypot(dx,dy),dz) > dist
					continue
				end
				
				TakisGiveCombo(p2,p2.takistable,true,nil,nil,true)
				
			end
		end
		
		return
	end
	
	if not (sor.player and sor.player.valid) then return end
	
	if sor.skin ~= TAKIS_SKIN
		local bleader = sor.player.botleader
		
		if sor.player.bot
		and (bleader and bleader.valid)
		and (bleader.mo and bleader.mo.valid)
		and (bleader.mo.skin == TAKIS_SKIN)
		and (CanFlingThing(mo,MF_ENEMY|MF_BOSS)
		or (SPIKE_LIST[mo.type] == true)
		or (mo.type == MT_PLAYER)
		and (not mo.ragdoll))
			if not mo.health
				TakisGiveCombo(bleader,bleader.takistable,true)
			else
				TakisGiveCombo(bleader,bleader.takistable,false,true)
			end
		end
		
		return
	end
	
	if mo.ragdoll
		return
	end
	
	--wait dont give combo if we killed ourself
	if (sor == mo)
	and (sor.player and mo.player)
		return
	end
	
	if CanFlingThing(mo,MF_MONITOR)
		TakisGiveCombo(sor.player,sor.player.takistable,true)
		sor.player.takistable.HUD.statusface.happyfacetic = 3*TR/2
	end
	
	if sor.player
	and sor.player.takistable
		if CanFlingThing(mo)
		and (dmgt ~= DMG_NUKE)
			if (inf and inf.valid and inf.player and inf.player.valid)
			and (inf.player.takistable.dived
			or inf.player.takistable.thokked)
				inf.player.takistable.dived = false
				inf.player.takistable.thokked = false
				inf.player.pflags = $ &~PF_THOKKED
			end
			/*
			if inf.type == MT_THROWNSCATTER
			and inf.shotbytakis
				SpawnRagThing(mo,inf,sor)
			end
			*/
		end
		
		if CanFlingThing(mo,MF_ENEMY|MF_BOSS)
		or (SPIKE_LIST[mo.type] == true)
		or (mo.type == MT_PLAYER)
		and (not mo.ragdoll)
			if (mo.type ~= MT_PLAYER)
			and (dmgt == DMG_NUKE)
			and not (TAKIS_NET.nerfarma)
				SpawnRagThing(mo,sor)
			end
			
			if not mo.health
				if not (mo.flags & MF_BOSS)
					TakisGiveCombo(sor.player,sor.player.takistable,true)
				else
					if not (TAKIS_NET.inbossmap
					or TAKIS_NET.inbrakmap)
						TakisGiveCombo(sor.player,sor.player.takistable,true)
					end
				end
			--only damaged
			else
				TakisGiveCombo(sor.player,sor.player.takistable,false,true)
			end
			
			if mo.type == MT_PLAYER
				if (not mo.health)
				--not if we killed ourselves though
				and (mo ~= sor)
					sor.player.takistable.HUD.statusface.evilgrintic = 2*TR
				end
				if mo.player.takistable.tauntjoinable
				or mo.player.takistable.tauntacceptspartners
					TakisAwardAchievement(sor.player,ACHIEVEMENT_PARTYPOOPER)
				end
			end
		
		end
		
	end

end
local function diedbytakis(mo,inf,sor)
	hurtbytakis(mo,inf,sor)
end

addHook("MobjDeath", hurtbytakis)
addHook("MobjDamage", diedbytakis)

--summa
--cant use BossDeath since i need the source
addHook("MobjDeath",function(mo,inf,sor,dmgt)
	if not (mo and mo.valid) then return end
	if not (mo.flags & MF_BOSS) then return end
	if not (sor and sor.valid) then return end
	if sor.skin ~= TAKIS_SKIN then return end
	
	local rad = 1200*mo.scale
	for p in players.iterate
		
		local m2 = p.realmo
		
		if not m2 or not m2.valid
			continue
		end
		local rag = mo
		if (FixedHypot(m2.x-rag.x,m2.y-rag.y) <= rad)
			DoQuake(p,
				FixedMul(
					100*FU, FixedDiv( rad-FixedHypot(m2.x-rag.x,m2.y-rag.y),rad )
				),
				TR
			)
		end
	end
	mo.aTakisFUCKINGkilledME = true
	mo.takisThatFUCKINGkilledMe = sor
	S_StartSound(mo,sfx_tkapow)
end)

--takis died by thing
addHook("MobjDeath", function(mo,i,s,dmgt)
	local p = mo.player
	local takis = p.takistable
	
	if (s and s.valid)
	and (s.skin == TAKIS_SKIN)
	and (s.player and s.player.valid)
	and (s.player.takistable.heartcards ~= TAKIS_MAX_HEARTCARDS)
	and (not (gametyperules & GTR_FRIENDLY))
		TakisHealPlayer(s.player,s,s.player.takistable,1,3)
		S_StartSound(mo,sfx_takhel,s.player)
	end
	
	if mo.skin ~= TAKIS_SKIN
		if (dmgt == DMG_INSTAKILL)
		and (dmgt ~= DMG_DEATHPIT)
		and p.inkart
			takis.deathfunny = true
		end
		if takis.deathfunny
		and not (mo.takis_ultradeath)
			local ki = P_SpawnMobjFromMobj(mo,0,0,0,MT_TAKIS_BROLYKI)
			ki.tracer = mo
			ki.color = mo.color
			S_StopSound(mo)
			S_StartSound(mo,sfx_buzz3)
			takis.altdisfx = 0
			if p.inkart
				mo.state = S_PLAY_TAKIS_KART
				mo.frame = (TakisKart_KarterData[mo.skin].legacyframes and TakisKart_Framesets.legacy.pain or TakisKart_Framesets.norm.pain)
				p.inkart = 2
			end
		end
		
		return
	end
	
	--award points to source
	if (sor and sor.valid
	and sor.player and sor.player.valid)
		if (gametyperules &
		(GTR_POINTLIMIT|GTR_RINGSLINGER|GTR_HURTMESSAGES)
		or G_RingSlingerGametype())
			P_AddPlayerScore(sor.player,100)
		end
	end
	
	spillrings(p,true)
	
	if (mo.state ~= S_PLAY_DEAD)
		mo.state = S_PLAY_DEAD
	end
	mo.rollangle = 0
	
	TakisResetHammerTime(p)
	
	if (takis.heartcards > 0)
		takis.HUD.heartcards.shake = $+TAKIS_HEARTCARDS_SHAKETIME
	end
	takis.heartcards = 0
	
	takis.combo.time = 0
	takis.saveddmgt = dmgt
	
	if (mo.eflags & MFE_UNDERWATER)
		takis.saveddmgt = DMG_DROWNED
	end
	if P_InSpaceSector(mo)
		takis.saveddmgt = DMG_SPACEDROWN
	end
	
	if takis.saveddmgt == DMG_DROWNED
		if (not takis.inWater) and mo.player.powers[pw_spacetime]
			--we need to set this because srb2 is silly
			takis.saveddmgt = DMG_SPACEDROWN
		else
			takis.saveddmgt = DMG_DROWNED
		end
	elseif takis.saveddmgt == DMG_SPACEDROWN
		takis.saveddmgt = DMG_SPACEDROWN
	end
	
	if not (dmgt &~DMG_DEATHMASK)
		takis.deathfunny = P_RandomChance(FU/2)
		if takis.inSaxaMM
		and not MM:canGameEnd()
			P_InstaThrust(mo,mo.deathangle or mo.angle,-8*FU)
			P_MovePlayer(p)
			P_SetObjectMomZ(mo,6*FU)
		elseif not takis.deathfunny
			local angle = p.drawangle
			local speed = -4*mo.scale
			if (i and i.valid)
				angle = R_PointToAngle2(mo.x,mo.y, i.x,i.y)
				speed = -(FixedHypot(i.momx,i.momy) + 4*i.scale)
			end
			P_InstaThrust(mo,angle,speed)
			P_SetObjectMomZ(mo,5*FU)
		end
	end
	if (dmgt == DMG_INSTAKILL)
	or (p.inkart and dmgt ~= DMG_DEATHPIT and (mo.DJSHKSJLDHFDSKLH == nil))
		takis.deathfunny = true
		if takis.inSaxaMM
			if not MM:canGameEnd()
				takis.deathfunny = false
			end
			P_InstaThrust(mo,mo.deathangle or mo.angle,-8*FU)
			P_MovePlayer(p)
			P_SetObjectMomZ(mo,6*FU)
		end
	end
	if takis.deathfunny
	and not (mo.takis_ultradeath)
		local ki = P_SpawnMobjFromMobj(mo,0,0,0,MT_TAKIS_BROLYKI)
		ki.tracer = mo
		ki.color = mo.color
		S_StopSound(mo)
		S_StartSound(mo,sfx_buzz3)
		takis.altdisfx = 0
		if p.inkart
			mo.state = S_PLAY_TAKIS_KART
			mo.frame = (TakisKart_KarterData[mo.skin].legacyframes and TakisKart_Framesets.legacy.pain or TakisKart_Framesets.norm.pain)
			p.inkart = 2
		end
	end
	
	if takis.inSaxaMM
		S_StartSound(mo,sfx_smack)
		SpawnBam(mo,true)
		DoQuake(p,30*FU*(max(1,p.timeshit*2/3)),15)
		
		SpawnEnemyGibs(inf or mo,mo,nil,nil,false)
	end
	
	for i = sfx_antow1,sfx_antow7
		S_StopSoundByID(mo,i)
	end
	p.deadtimer = min($,1)
	
	if TAKIS_TUTORIALSTAGE
		p.lives = $+1
	end
	
end,MT_PLAYER)

--double jump
addHook("AbilitySpecial", function(p)
	if p.mo.skin ~= TAKIS_SKIN then return end
	
	local takis = p.takistable
	
	if p.charability ~= CA_DOUBLEJUMP then return end
	
	if takis.thokked
	or (p.takis_donotuse_nothok)
	or (p.pflags & PF_JUMPSTASIS)
		return true
	end
	if ((takis.inPain) or (takis.inFakePain))
		return true
	end
	
	local me = p.mo
	
	P_DoJump(p,false)
	S_StopSoundByID(me,skins[TAKIS_SKIN].soundsid[SKSJUMP])
	takis.thokked = true
	takis.hammerblastjumped = 0
	
	local jfactor = min(FixedDiv(p.jumpfactor,skins[TAKIS_SKIN].jumpfactor),FU)
	L_ZLaunch(p.mo,FixedMul(15*FU,jfactor))
	
	me.state = S_PLAY_ROLL
	if ((takis.transfo & TRANSFO_FIREASS) and (takis.firethokked))
		me.state = S_PLAY_FALL
		P_MovePlayer(p)
		S_StartSound(me,sfx_fire)
		S_StartSound(me,sfx_kc5b)
		takis.fireasssmoke = TR/2
		
		local dusts = TakisSpawnDustRing(me,16*me.scale,3*me.scale)
		for i = 1,#dusts
			local dust = dusts[i]
			if not (dust and dust.valid) then continue end
			dust.colorized = true
			dust.color = SKINCOLOR_BLACK
			dust.scale = $+(P_RandomFixed()/2*((P_RandomChance(FU/2)) and 1 or -1))
			dust.destscale = 1
		end
		
	else
		local maxi = P_RandomRange(8,16)
		for i = 0, maxi
			local fa = FixedAngle(i*FixedDiv(360*FU,maxi*FU))
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
					
					fuse = 12+P_RandomRange(-2,3),
				}
			)
			dust.momx = FixedMul(sin(fa),me.radius)/2
			dust.momy = FixedMul(cos(fa),me.radius)/2
		end

		--wind ring
		local ring = P_SpawnMobjFromMobj(me,
			0,0,-5*me.scale*takis.gravflip,MT_THOK --MT_WINDRINGLOL
		)
		if (ring and ring.valid)
			ring.renderflags = RF_FLOORSPRITE
			ring.frame = $|FF_TRANS50
			ring.startingtrans = FF_TRANS50
			ring.scale = FixedDiv(me.scale,2*FU)
			P_SetObjectMomZ(ring,-me.momz*2*takis.gravflip)
			--i thought this would fade out the object
			ring.fuse = 10
			ring.destscale = FixedMul(ring.scale,2*FU)
			ring.colorized = true
			ring.color = SKINCOLOR_WHITE
			ring.state = S_SOAPYWINDRINGLOL
		end
	
		S_StartSoundAtVolume(me,sfx_takdjm,4*255/5)
		if takis.inWater
			S_StartSound(me,sfx_splash)
		end
	end
	
	p.jp = 1
	p.jt = 5
	p.pflags = $|(PF_JUMPED|PF_JUMPDOWN|PF_THOKKED|PF_STARTJUMP) & ~(PF_SPINNING|PF_STARTDASH)
	if takis.isSuper
	or ((takis.transfo & TRANSFO_FIREASS) and (takis.firethokked == false))
		p.pflags = $ &~PF_THOKKED
		takis.thokked = false
		takis.firethokked = true
	end
	
	if takis.inSRBZ
		me.momx,me.momy = FixedMul($1,FU*8/10),FixedMul($2,FU*8/10)
		takis.jumpfatigue = true
	end
	return true
end)

--jump effect
addHook("JumpSpecial", function(p)
	if p.mo.skin ~= TAKIS_SKIN then return end
	
	local me = p.mo
	local takis = p.takistable
	
	if not takis then return end
	
	if takis.jump > 1 then return end
	if (takis.thokked or p.pflags & PF_THOKKED) then return end
	if (takis.jumptime > 0) then return end
	if p.inkart then return end
	if (p.pflags & PF_JUMPSTASIS) then return end
	if (p.pflags & (PF_JUMPED|PF_STARTJUMP) == PF_JUMPED) then return end
	
	if takis.onGround
	or takis.coyote
		local maxi = 7 --P_RandomRange(8,16)
		for i = 0, maxi
			local fa = FixedAngle(i*FixedDiv(360*FU,maxi*FU))
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
					
					fuse = 12+P_RandomRange(-2,3),
				}
			)
			dust.momx = FixedMul(sin(fa),me.radius)/2
			dust.momy = FixedMul(cos(fa),me.radius)/2
		end
		
		p.jp = 1
		p.jt = 5
		
		local wind = P_SpawnMobjFromMobj(me,0,0,0,MT_THOK)
		wind.scale = me.scale
		
		wind.fuse = 10
		wind.tics = -1
		
		wind.frame = A
		wind.sprite = SPR_RAIN
		wind.frame = B
		
		wind.renderflags = $|RF_PAPERSPRITE
		wind.startingtrans = 0
		
		wind.angle = TakisMomAngle(me)
		--wind.spritexscale,wind.spriteyscale = me.scale,me.scale
		wind.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0,0,me.momx,me.momy),FixedMul(9*FU,p.jumpfactor)) + ANGLE_90
	end
end)

--takis moved into a thing
--this should be used as the main movecollide hook from now on
addHook("MobjMoveCollide",function(tm,t)
	if not (tm.player or ((t) and (t.valid)))
		return
	end
	
	--erm, again?
	if not (t and t.valid)
		return
	end
	
	if (tm.skin ~= TAKIS_SKIN)
		return
	end
	
	local p = tm.player
	local takis = p.takistable
	
	if not (L_ZCollide(tm,t))
		return
	end
	
	if takis
		
		if not t.dontclutchintome
			knockbacklolll(tm,t)
		end
		
		if not (t and t.valid)
			return
		end
		--destroy these stupid doors
		if ((t.type == MT_SALOONDOOR) or (t.type == MT_SALOONDOORCENTER))
			if ((t.valid) and (t.health) and not (t.flags & MF_NOCLIP))
			and ((takis.afterimaging or takis.transfo & (TRANSFO_BALL|TRANSFO_METAL))
			or p.powers[pw_invulnerability])
			and (gametyperules & GTR_FRIENDLY)
				S_StartSound(t,sfx_wbreak)
				S_StartSound(t,sfx_s3k59)
				
				SpawnEnemyGibs(tm,t,nil,true)
				
				SpawnBam(t,true)
				
				if (t.type == MT_SALOONDOOR)
					t.flags = $|MF_NOCLIP
					TakisGiveCombo(p,takis,true)
					P_KillMobj(t, tm, tm)
				--waht !??
				elseif (t.type == MT_SALOONDOORCENTER)
					t.flags = $|MF_NOCLIP
				end
				
				return false
			end
		elseif (t.type == MT_STEAM)
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
					car.momz = FixedDiv($,FU*3/5)
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
				
				TakisResetHammerTime(p)
				P_DoSpring(t,tm)
				
				--P_InstaThrust(tm,t.angle,takis.prevspeed+mobjinfo[t.type].damage)
				tm.angle,p.drawangle = t.angle,t.angle
				tm.eflags = $|MFE_SPRUNG
				takis.fakesprung = true
				p.homing = 0
				
				--S_StartSound(t,mobjinfo[t.type].painsound)
				--t.state = mobjinfo[t.type].raisestate
				
				if (t.info.painchance == 3)
					if (t.flags2 & MF2_AMBUSH)
					and not (takis.transfo & TRANSFO_BALL)
					and (tm.health)
						S_StartSound(tm,sfx_trnsfo)
						tm.state = S_PLAY_ROLL
						p.pflags = $|PF_SPINNING
						takis.transfo = $|TRANSFO_BALL
						TakisAwardAchievement(p,ACHIEVEMENT_BOWLINGBALL)
					end
					
					/*
					takis.nadocount = 3
					if not (takis.transfo & TRANSFO_TORNADO)
						takis.transfo = $|TRANSFO_TORNADO
					end
					if not (TakisReadAchievements(p) & ACHIEVEMENT_TORNADO)
						takis.nadotuttic = 5*TR
					end
					
					TakisAwardAchievement(p,ACHIEVEMENT_TORNADO)
					*/
				end
				
			end
		--people bowling
		elseif (t.type == MT_PLAYER)
		and ((t.player) and (t.player.valid))
		and (p.pflags & PF_SPINNING)
		and L_ZCollide(t,tm)
		and not (t.player.inkart or p.inkart)
			if CanPlayerHurtPlayer(p,t.player)
				if not (takis.transfo & TRANSFO_BALL)
					TakisAddHurtMsg(t.player,p,HURTMSG_SLIDE)
				else
					TakisAddHurtMsg(t.player,p,HURTMSG_BALL)
				end
				P_DamageMobj(t,tm,tm,1)
				
				LaunchTargetFromInflictor(1,t,tm,63*tm.scale,takis.accspeed/5)
				P_Thrust(tm,p.drawangle,5*tm.scale)
				L_ZLaunch(t,P_RandomRange(5,15)*tm.scale,true)
				
				SpawnEnemyGibs(t,tm)
				SpawnBam(tm,true)
				
				if p.inkart
					P_KillMobj(t,tm,tm,DMG_INSTAKILL)
					tm.player.takistable.saveddmgt = DMG_INSTAKILL
					tm.player.takistable.deathfunny = true
				end
				S_StartSound(t,sfx_bowl)
				S_StartSound(tm,sfx_smack)
			end
		--spike stuff
		elseif (SPIKE_LIST[t.type] == true)
			--we mightve ran into a spike thing
			if t.health
			and ((p.powers[pw_strong] & STR_SPIKE) 
			or (takis.afterimaging)
			or (takis.transfo & (TRANSFO_TORNADO|TRANSFO_BALL)))
				P_KillMobj(t,tm,tm)
				if takis.transfo & TRANSFO_BALL
					local sfx = P_SpawnGhostMobj(tm)
					sfx.flags2 = $|MF2_DONTDRAW
					sfx.tics,sfx.fuse = 3*TR,3*TR
					S_StartSound(sfx,sfx_bowl)
				end
				return false
			end
		--fling solids
		elseif CanFlingSolid(t,tm)
		and (takis.afterimaging 
		or p.powers[pw_invulnerability] 
		or takis.isSuper 
		or takis.transfo & (TRANSFO_BALL|TRANSFO_METAL))
			if not (t and t.valid) then return end
			local j1,j2 = t,tm
			local tm = j1
			local t = j2
			
			/*
			TakisFancyExplode(tm,
				tm.x, tm.y, tm.z,
				P_RandomRange(60,64)*tm.scale,
				32,
				MT_TAKIS_EXPLODE,
				15,20
			)
			for i = 0, 34
				A_BossScream(tm,1,MT_SONIC3KBOSSEXPLODE)
			end
			*/
			
			local sfx = P_SpawnGhostMobj(tm)
			sfx.flags2 = $|MF2_DONTDRAW
			sfx.tics = 3*TR
			sfx.fuse = 3*TR
			S_StartSound(sfx,sfx_tkapow)
			
			local fling = P_SpawnMobjFromMobj(tm,0,0,0,MT_TAKIS_FLINGSOLID)
			local ang = R_PointToAngle2(tm.x,tm.y, t.x,t.y)
			fling.angle = ang
			fling.radius = tm.radius
			fling.height = tm.height
			fling.state = tm.state
			fling.spritexoffset,fling.spriteyoffset = tm.spritexoffset,tm.spriteyoffset
			fling.spritexscale,fling.spriteyscale = tm.spritexscale,tm.spriteyscale
			fling.fuse = 3*TR
			fling.color = tm.color
			L_ZLaunch(fling,
				P_RandomRange(15,20)*tm.scale+P_RandomFixed()
			)
			P_Thrust(fling,
				ang,
				-FixedMul(takis.accspeed,tm.scale)*2
			)
			if (fling.renderflags & RF_PAPERSPRITE)
			or (fling.frame & FF_PAPERSPRITE)
				fling.angle = $+ANGLE_90
			end
			
			local b1,b2 = SpawnBam(tm,true)
			local scale = max(FixedDiv(fling.height,t.height)/5,0)
			b1.scale,b2.scale = $1 + scale,$2 + scale
			
			local rad = 600*tm.scale
			for p2 in players.iterate
				
				local m2 = p2.realmo
				
				if not m2 or not m2.valid
					continue
				end
				
				if (FixedHypot(m2.x-tm.x,m2.y-tm.y) <= rad)
					DoQuake(p,
						FixedMul(
							20*FU, FixedDiv( rad-FixedHypot(m2.x-tm.x,m2.y-tm.y),rad )
						),
						10
					)
				end
			end
			S_StartSound(fling,sfx_crumbl)
			S_StartSound(fling,sfx_cdpcm9)
			
			if (multiplayer)
				--thok does our bidding for us
				local thok = P_SpawnMobjFromMobj(tm,0,0,0,MT_THOK)
				thok.camefromsolid = true
				thok.respawntime = CV_FindVar("respawnitemtime").value * TICRATE
				thok.solid = {
					type = tm.type,
					state = tm.state,
					pos = {tm.x,tm.y,tm.z},
					flags = tm.flags,
					flags2 = tm.flags2,
					angle = tm.angle,
					scale = tm.scale,
					color = tm.color
				}
			end
			
			P_RemoveMobj(tm)
			TakisGiveCombo(p,takis,true)
			
			return false
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
				TakisKart_ChangeLicense(p,"ranover",1)
				
				SpawnEnemyGibs(t,tm)
				SpawnBam(tm,true)
				
				S_StartSound(t,sfx_tsplat)
				S_StartSound(tm,sfx_smack)
			end
		elseif (t.type == MT_TAKIS_KART_HELPER)
		and (tm.tracer == t)
			return false
		--stomp
		elseif (t.type == MT_PLAYER)
		and (takis.transfo & TRANSFO_METAL)
		and L_ZCollide(t,tm)
		and (tm.momz*takis.gravflip < 0)
		and CanPlayerHurtPlayer(p,t.player)
			L_ZLaunch(tm,-takis.lastmomz*4/5)
			P_KillMobj(t,tm,tm,DMG_CRUSHED)
			S_StartSound(mt,sfx_mario5)
			local bam1 = SpawnBam(t)
			bam1.renderflags = $|RF_FLOORSPRITE
			SpawnEnemyGibs(t,tm)
			S_StartSound(t,sfx_smack)
			S_StartSound(tm,sfx_sdmkil)
		end
		
	end
end,MT_PLAYER)

-- collision stuff for 'nado
--bumpcode
addHook("MobjMoveBlocked", function(me, thing, line)
	local p = me.player
	local takis = p.takistable
	local allowbump = false
	
	if me.skin ~= TAKIS_SKIN then return end
	
	if takis.justbumped then takis.justbumped = 8; return end
	
	if takis.inwaterslide
	or (takis.transfo & TRANSFO_BALL)
	or (takis.bashtime)
	or (takis.inPain or takis.inFakePain)
	or (p.playerstate == PST_DEAD and not p.spectator)
		allowbump = true
	end
	
	if takis.slopeairtime
	and me.momz*P_MobjFlip(me) > 0
	and (takis.transfo & TRANSFO_BALL)
		allowbump = false
	end
	
	if p.inkart
		allowbump = false
	end
	
	if not allowbump
		return
	end
	
	if ((thing) and (thing.valid)) or ((line) and (line.valid))
		
		/*
		if thing and thing.valid
			
			K_KartBouncing(true,car,thing)
			
		elseif line and line.valid
			
			P_BouncePlayerMove(p,me,car,true)
			
		end
		*/
		
		local oldangle = me.angle
		local thrustang = oldangle
		if thing and thing.valid
			if thing.flags & (MF_MONITOR|MF_PUSHABLE)
				return
			end
			
			me.angle = FixedAngle(AngleFixed(R_PointToAngle2(me.x,me.y,thing.x,thing.y))+(180*FU))
			thrustang = me.angle
			P_InstaThrust(me,me.angle,FixedHypot(me.momx, me.momy)- me.friction)
			me.angle = oldangle
			
		elseif line and line.valid
			if (me.standingslope and me.standingslope.valid)
				local goingup = false
				local posfunc = P_GetZAt --P_MobjFlip(me) == 1 and P_FloorzAtPos or P_CeilingzAtPos
				
				if posfunc(me.standingslope, me.x, me.y, me.z) > me.z
				or posfunc(me.standingslope, me.x + me.momx, me.y + me.momy, me.z + me.momz) > me.z
					goingup = true
				end
				
				if goingup
					return
				end
			end
			
			/*
			P_BouncePlayerMove(p,me,me,false)
			*/
			
			if FixedHypot(me.momx,me.momy) < 7*me.scale then return end
			--THANKS MARILYN FOR LETTIN ME STEAL THIS!!
			if abs(line.dx) > 0
                local myang = TakisMomAngle(me)
                local vertang = R_PointToAngle2(0, 0, 0, me.momz)
                local lineang = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y)
                thrustang = myang + 2*(lineang - myang)
				P_InstaThrust(me, myang + 2*(lineang - myang), FixedHypot(me.momx, me.momy)- me.friction)
            else
                me.momx = $*-1
                me.momy = $*-1
            end
			
		end
		
		local bam1 = SpawnBam(me)
		bam1.scale = $/2
		
		if (takis.transfo & TRANSFO_BALL)
			local thrust = 12*me.scale
			if takis.accspeed > 120*FU
				thrust = 0
			end
			DoQuake(p,10*FU,7)
			P_Thrust(me,thrustang,thrust)
			S_StartSound(me,P_RandomRange(sfx_takbn1,sfx_takbn3))
			P_AddPlayerScore(p,5)
		else
			S_StartSound(me,sfx_s3k49)
		end
		
		if takis.bashtime
			me.state = S_PLAY_FALL
			TakisResetState(p)
			S_StopSoundByID(me,sfx_shgnbs)
			takis.bashtime = 0
			takis.bashcooldown = true
		end
		
		if takis.inPain or takis.inFakePain or p.playerstate == PST_DEAD
			me.state = S_PLAY_DEAD
			me.momx,me.momy = $1/2,$2/2
			me.momz = 0
			bam1.scale = $*2
			takis.ticsforpain = 0
			
			DoQuake(p,15*FU,15)
			
			local angle = TakisMomAngle(me) + ANGLE_90
			if line and line.valid
				angle = R_PointToAngle2(line.v1.x,line.v1.y,line.v2.x,line.v2.y)
				if angle > ANGLE_180 then angle = InvAngle($) end
				
				local x,y = P_ClosestPointOnLine(me.x,me.y,line)
				P_TryMove(me,
					x,y,true
				)
			end
			
			takis.freeze.tics = TR/2 --/6
			takis.freeze.momentum = {me.momx,me.momy,me.momz}
			takis.freeze.sprites = {me.state,me.sprite2,B}
			takis.freeze.angle = TakisMomAngle(me)
			takis.freeze.set = true
			takis.freeze.freezeangle = angle
			
			if FixedHypot(me.momx,me.momy) > FixedMul(p.runspeed,me.scale)
				local speedadd = FixedHypot(me.momx,me.momy) - FixedMul(p.runspeed,me.scale)
				speedadd = $/me.scale/2
				
				takis.freeze.tics = $+speedadd
			end
			
			p.jp = 1
			p.jt = 5
			
			SpawnEnemyGibs(me,me,nil,nil,true)
			S_StartSound(me,sfx_tsplat)
			me.frame = B|FF_PAPERSPRITE
			me.sprite2 = SPR2_FLY_
			p.drawangle = InvAngle(angle)
		end
		
		takis.justbumped = 5
		
		return true
	end
	
	/*
	if not mo
	or not mo.valid
		return
	end
	
	local p = mo.player
	local takis = p.takistable
	
	if p.mo
	and p.mo.valid
		local me = p.mo
		
		if me.skin ~= TAKIS_SKIN
			return
		end
		
		if ((thing) and (thing.valid)) or ((line) and (line.valid))
			if (takis.transfo & TRANSFO_TORNADO)
				if takis.nadotic then return end
				if takis.accspeed <= 7*FU then return end
				
				local oldangle = me.angle
				if thing and thing.valid
					if thing.flags & MF_MONITOR
						return
					end
					
					P_BounceMove(me)
					me.angle = FixedAngle(AngleFixed($)+(180*FU))
					p.drawangle = me.angle
				elseif line and line.valid
					--me.angle = FixedAngle(180*FU-AngleFixed($))
					P_BounceMove(me)
					me.angle = FixedAngle(AngleFixed($)+(180*FU))
					p.drawangle = me.angle
				end
				
				DoQuake(p,15*me.scale,5)
				S_StartSound(me,sfx_slam)
				
				takis.nadotic = 3
				if (takis.nadocount == 1)
					takis.nadocrash = TR*3/2
					me.state = S_PLAY_DEAD
				end
				
				if (takis.nadocount > 0)
					takis.nadocount = $-1
				end
				
				return true
			end
		end
	end
	*/
end, MT_PLAYER)

addHook("MobjDeath", function(mobj, inflictor, source)
	if source 
	and source.valid 
	and source.player 
	and source.player.valid
	and source.player.mo
	and source.player.mo.valid
	and source.skin == TAKIS_SKIN
		local p = source.player
		
		TakisResetHammerTime(p)
		
		source.state = S_PLAY_GASP
	end
end, MT_EXTRALARGEBUBBLE)

addHook("LinedefExecute",function(line,mo,sec)
	if not udmf
		print("\x83TAKIS:\x80 ".."TAK_NOABILITY can only be used in UDMF! (line #"..#line..")")
		return
	end
	
	if not mo.valid
	or not mo.health
	or not mo.player
	or not mo.player.valid
		return
	end
	
	local p = mo.player
	
	/*
		args 1-8 used
		"CLUTCH",
		"HAMMER",
		"DIVE",
		"SLIDE",
		"WAVEDASH",
		"SHOTGUN",
		"SHIELD",
		"THOK",
	*/
	
	local addflags = 0
	local subflags = 0
	
	for i = 0,7
		local bit = line.args[i]
		print(bit)
		
		if bit < 0
			subflags = $|(abs(bit)<<i)
		elseif bit > 0
			addflags = $|(abs(bit)<<i)
		end
	end
	
	if p.takis_noabil == nil
		p.takis_noabil = 0
	end
	
	--absolute
	if line.args[8] == 1
		p.takis_noabil = addflags
	--relative
	else
		p.takis_noabil = $|addflags &~subflags
	end
end,"TAK_NOABILITY")

addHook("LinedefExecute",function(line,mo,sec)
	if not mo.valid
	or not mo.health
	or not mo.player
	or not mo.player.valid
		return
	end
	
	local p = mo.player
	if not (p.takistable) then return end
	
	local takis = p.takistable
	
	--use metal detectors for this
	takis.transfo = 0|($ & TRANSFO_SHOTGUN)
	
end,"TAK_NOTRANSFO")

addHook("LinedefExecute",function(line,mo,sec)
	if not mo.valid
	or not mo.health
	or not mo.player
	or not mo.player.valid
	or netgame
		return
	end
	
	local p = mo.player
	if not (p.takistable) then return end
	
	local takis = p.takistable
	
	if not mapheaderinfo[gamemap].takis_karttutorial then return end
	if TAKIS_TUTORIALSTAGE < 6 then return end
	if (takis.license.haslicense) then return end
	
	TakisKart_AwardLicense(p)
	S_StartSound(nil,sfx_achern,p)
	
end,"TAK_AWARDLICENSE")

local happysongs = {
	["hpyhre"] = true,
	["hapyhr"] = true
}

local function happyhourmus(oldname, newname, mflags,looping,pos,prefade,fade)
	if splitscreen
		return
	end
	
	if not (consoleplayer and consoleplayer.valid)
		return
	end
	
	if not (consoleplayer.takistable)
		return
	end
	
	local p = consoleplayer
	local takis = p.takistable
	
	if (gamestate == GS_INTERMISSION)
	and takis.lastss
		newname = string.lower(newname)
		
		if newname == "_clear"
			--mapmusname = song
			return "blstcl",mflags,true,pos,prefade,fade	
		end
	end
	
	local dohhmus = HH_CanDoHappyStuff(consoleplayer)
	if (takis.shotgunned
	and ultimatemode)
	or (takis.transfo & TRANSFO_METAL)
		dohhmus = false
	end
	
	newname = string.lower(newname)
	
	local isspecsong
	isspecsong = string.sub(newname,1,1) == "_"
	if not isspecsong
		isspecsong = TAKIS_MISC.specsongs[newname]
	end
	
	--print(" s "..tostring(HAPPY_HOUR.happyhour))
	if ((HAPPY_HOUR.happyhour and not HAPPY_HOUR.gameover)
	and dohhmus)
		local hh = HAPPY_HOUR
		
		local nomus,noendmus,song,songend = GetHappyHourMusic()
		
		oldname = string.lower($)
		
		if TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR
			CONS_Printf(consoleplayer,"New music change:",
				"HH Music: "..song,
				"HH End Music: "..songend,
				''
			)
			CONS_Printf(consoleplayer,"Nomus",
				nomus,
				noendmus,
				''
			)
			CONS_Printf(consoleplayer,"Changing from "..oldname,"to "..newname,"")
			CONS_Printf(consoleplayer,"Spec "..tostring(not isspecsong),'')
		end
		
		--stop any lap music
		if (not isspecsong)
			local changetohappy = true
			
			if HAPPY_HOUR.timelimit
				
				if HAPPY_HOUR.timeleft
					local tics = HAPPY_HOUR.timeleft
					
					if tics <= (56*TR)
					and (noendmus == false)
						changetohappy = false
					end
				end
			end
			
			if TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR
				CONS_Printf(consoleplayer,"Change to happy:",
					tostring(changetohappy)
				)
			end
			
			if changetohappy
				if nomus then return end
				
				if oldname ~= song
					--mapmusname = song
					return song,mflags,looping,pos,prefade,fade
				end
			
			else
				if noendmus then return end
				
				if oldname ~= songend
					--mapmusname = songend
					return songend,mflags,looping,pos,prefade,fade
				end
			end
			
			return true
		end
		
	else
		local newname = string.lower(newname)
		
		if (takis.transfo & TRANSFO_METAL)
			if not isspecsong
				return "_metlc",mflags,looping,pos,prefade,fade
			end
		elseif consoleplayer.takistable.shotgunned
			
			if not ultimatemode then return end
			
			if (not isspecsong)
			and happysongs[newname] ~= true
				return "war",mflags,looping,pos,prefade,fade
			end
			
		end
	end
end
addHook("MusicChange", happyhourmus)

addHook("HurtMsg", function(p, inf, sor, dmgt)
	return TakisHurtMsg(p,inf,sor,dmgt)
end)

TAKIS_FILESLOADED = $+1
