/*	HEADER
	Keep track of and edit anything that is synched
	TAKIS_MISC should not be synched, as it is clientside only
	
*/

local t = TAKIS_NET
local m = TAKIS_MISC

local boolean = {
	["false"] = false,
	["true"] = true,
}

local function debugf(name,cv,tv)
	if not TAKIS_ISDEBUG then return end
	if not (TAKIS_DEBUGFLAG & DEBUG_NET) then return end
	
	print("\x83TAKIS:\x80 "..name.." = cv: "..cv.." tv: "..tv)
end

rawset(_G,"CV_TAKIS",{})
CV_TAKIS.nerfarma = CV_RegisterVar({
	name = "takis_nerfarma",
	defaultvalue = "false",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.nerfarma = boolean[string.lower(cv.string)]
		debugf("nerfarma",string.lower(cv.string),tostring(t.nerfarma))
	end
})
CV_TAKIS.tauntkills = CV_RegisterVar({
	name = "takis_tauntkills",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.tauntkillsenabled = boolean[string.lower(cv.string)]
		debugf("tauntkills",string.lower(cv.string),tostring(t.tauntkillsenabled))
	end
})
CV_TAKIS.achs = CV_RegisterVar({
	name = "takis_achs",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.noachs = not boolean[string.lower(cv.string)]
		debugf("achs",string.lower(cv.string),tostring(not t.achs))
	end
})
CV_TAKIS.collaterals = CV_RegisterVar({
	name = "takis_collaterals",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.collaterals = boolean[string.lower(cv.string)]
		debugf("collaterals",string.lower(cv.string),tostring(t.collaterals))
	end
})
CV_TAKIS.heartcards = CV_RegisterVar({
	name = "takis_heartcards",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.cards = boolean[string.lower(cv.string)]
		debugf("cards",string.lower(cv.string),tostring(t.cards))
	end
})
CV_TAKIS.hammerquake = CV_RegisterVar({
	name = "takis_hammerquakes",
	defaultvalue = "true",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.hammerquakes = cv.value == 1 --boolean[string.lower(cv.string)]
		debugf("hammerquakes",string.lower(cv.string),tostring(t.hammerquakes))
	end
})
CV_TAKIS.chaingun = CV_RegisterVar({
	name = "takis_chaingun",
	defaultvalue = "false",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.chaingun = boolean[string.lower(cv.string)]
		debugf("chaingun",string.lower(cv.string),tostring(t.chaingun))
	end
})
CV_TAKIS.happytime = CV_RegisterVar({
	name = "takis_happyhour",
	defaultvalue = "true",
	flags = CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		if consoleplayer
			CONS_Printf(consoleplayer,
				"\x82*Happy Hour in SP is "..
				(cv.value and "enabled" or "disabled")
				..", restart the map for changes to take effect"
			)
		else
			print(
				"\x82*Happy Hour in SP is "..
				(cv.value and "enabled" or "disabled")
				..", restart the map for changes to take effect"
			)
		end
		S_StartSound(nil,sfx_ponglr,consoleplayer)
	end
})
CV_TAKIS.noeffects = CV_RegisterVar({
	name = "takis_noeffects",
	defaultvalue = "false",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.noeffects = boolean[string.lower(cv.string)]
		debugf("noeffects",string.lower(cv.string),tostring(t.noeffects))
	end
})
CV_TAKIS.forcekart = CV_RegisterVar({
	name = "takis_forcekart",
	defaultvalue = "false",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.forcekart = boolean[string.lower(cv.string)]
		debugf("forcekart",string.lower(cv.string),tostring(t.forcekart))
	end
})
CV_TAKIS.allowkarters = CV_RegisterVar({
	name = "takis_allowkarters",
	defaultvalue = "false",
	flags = CV_NETVAR|CV_CALL,
	PossibleValue = CV_TrueFalse,
	func = function(cv)
		t.allowkarters = boolean[string.lower(cv.string)]
		debugf("allowkarters",string.lower(cv.string),tostring(t.allowkarters))
	end
})

local function livesCount()
	if (gametyperules & GTR_TAG)
		return
	end
	if (G_GametypeHasTeams())
		return
	end
	
	if (G_GametypeUsesLives())
		if ((netgame or multiplayer) and G_GametypeUsesCoopLives() and (CV_FindVar("cooplives").value == 3))
			local lives = 0
			
			for p in players.iterate
				if p.lives < 1
					continue
				end
				
				if (p.lives == INFLIVES)
					lives = INFLIVES
					break
				elseif lives < 99
					lives = $+p.lives
				end
				
			end
			
			m.livescount = lives
		end
	end
end

addHook("MapChange", function(mapid)
	TakisChangeHeartCards(6)
	if (mapheaderinfo[mapid].takis_maxheartcards)
		if (tonumber(mapheaderinfo[mapid].takis_maxheartcards) > 0)
			TakisChangeHeartCards(tonumber(mapheaderinfo[mapid].takis_maxheartcards))
		end
	end
	
	mapmusname = mapheaderinfo[mapid].musname
	
	for p in players.iterate
		if p.takistable == nil
			continue
		end
		
		p.takistable.HUD.bosscards = {
			maxcards = 0,
			dontdrawcards = false,
			cards = 0,
			cardshake = 0,
			mo = 0,
			name = '',
			statusface = {
				priority = 0,
				state = "IDLE",
				frame = 0,
			},
			timealive = 0,
		}
		p.takistable.HUD.bosstitle.tic = 0
	end
	
	t.ideyadrones = {}
	t.inbossmap = false
end)

--will this synch though?
addHook("MapLoad", function(mapid)
	
	local oldts = TAKIS_TUTORIALSTAGE
	TAKIS_TUTORIALSTAGE = 0
	
	if (mapheaderinfo[gamemap].takis_karttutorial)
	or (mapheaderinfo[gamemap].takis_tutorialmap)
	and not netgame
		TAKIS_TUTORIALSTAGE = 1
		for p in players.iterate
			if p.starpostnum ~= 0
				TAKIS_TUTORIALSTAGE = oldts
				break
			end
		end
	end
	
	t.numdestroyables = 0
	t.partdestroy = 0
	t.inbrakmap = false
	t.dronepos = {0,0,0}
	
	t.allowfallout = mapheaderinfo[gamemap].takis_allowfallout == nil
	t.allowbosscards = mapheaderinfo[gamemap].takis_allowbosscards == nil
	
	m.lastbump = 0
	m.cardbump = 0
	
	for mt in mapthings.iterate
		
		if mt.mobj and mt.mobj.valid
			local mobj = mt.mobj
				
			
			if mobj.type == MT_CYBRAKDEMON
				t.inbrakmap = true
			end
			
			if (CanFlingThing(mobj))
			or (SPIKE_LIST[mobj.type] == true)
				t.numdestroyables = $+1
			end
		else
			continue
		end
		
	end
	
	t.maxpostcount = 0
	local maxcount = 0
	for mobj in mobjs.iterate()
		--?
		if not (mobj and mobj.valid) then continue end
		
		if mobj.type ~= MT_STARPOST
			continue
		end
		if mobj.health > maxcount
			maxcount = mobj.health
		else
			continue
		end
	end
	t.maxpostcount = maxcount
	
	if t.numdestroyables ~= 0
		t.partdestroy = t.numdestroyables/(m.playercount+2) or 1
	end
	
	for p in players.iterate
		
	end
	
end)

--in milliseconds
--maybe this should use bpm?
--IT DOES USE BPM,,,,,
rawset(_G,"TAKIS_BEATMS",{
	["vsboss"] = 136,	--440,	--136 bpm
	["vsalt"] = 160,	--370,	--160 bpm
	["vsmetl"] = 184,	--320,	--184 bpm
	["vsbrak"] = 108,	--270,	--108 bpm 8/8
	["vsfang"] = 145,	--410,	--145 bpm
	["hapyhr"] = 130,	--460,	--130 bpm
	["hpyhre"] = 135,	--440,	--135 bpm
	["_metlc"] = 146,	--410,	--146 bpm
	["bcz1"] = 164,
})
rawset(_G,"TAKIS_BEATMETADATA",{
	["vsboss"] = {
		introms = 220,
		milliseconds = 440,
	},
	["vsfang"] = {
		introms = 6 * MUSICRATE,
	},
	["vsbrak"] = {
		introms = (24 * MUSICRATE) + (MUSICRATE/2),
	},
	["bcz1"] = {
		introbeats = 15,
	},
})


local gslist = {
	[0] = 	"GS_NULL",
	[1] = 	"GS_LEVEL",
	[2] = 	"GS_INTERMISSION",
	[3] = 	"GS_CONTINUING",
	[4] = 	"GS_TITLESCREEN",
	[5] = 	"GS_TIMEATTACK",
	[6] = 	"GS_CREDITS",
	[7] = 	"GS_EVALUATION",
	[8] = 	"GS_GAMEEND",
	[9] = 	"GS_INTRO",
	[10] = 	"GS_ENDING",
	[11] = 	"GS_CUTSCENE",
	[12] = 	"GS_DEDICATEDSERVER",
	[13] = 	"GS_WAITINGPLAYERS",
}

addHook("ThinkFrame", do
	
	--CVtoNET()
	
	if usedCheats
	and not t.usedcheats
		t.usedcheats = true
		print("\x83NOTICE:\x80 Achievements cannot be earned in cheated games.")
	end
	
	if gamestate == GS_TITLESCREEN
		TAKIS_TITLETIME = $+1
		
		--you probably wont get this without stalling
		if TAKIS_TITLETIME == (120*TR)
			S_StopMusic()
			S_StartSound(nil,sfx_jumpsc)
			TAKIS_TITLEFUNNY = (TR)+1
			TAKIS_TITLEFUNNYY = 500*FU
		end
		if TAKIS_TITLEFUNNY > 0
			if TAKIS_TITLEFUNNY == 1
				COM_BufInsertText(consoleplayer,"quit")
			end
			TAKIS_TITLEFUNNY = $-1
		end
	else
		TAKIS_TITLETIME = 0
	end
	
	if gamestate ~= GS_LEVEL
		return
	end
	
	if t.achtime then t.achtime = $-1 end
	
	t.inspecialstage = G_IsSpecialStage(gamemap)
	t.isretro = (maptol & TOL_MARIO)
	
	m.inttic = 0
	t.inbossmap = $ or (mapheaderinfo[gamemap].bonustype == 1)
	
	t.allowfallout = mapheaderinfo[gamemap].takis_allowfallout == nil
	t.allowbosscards = mapheaderinfo[gamemap].takis_allowbosscards == nil
	
	if G_BuildMapTitle(gamemap) ~= nil
	and m.forcenofallout[string.lower(G_BuildMapTitle(gamemap))] == true
		t.allowfallout = false
	end
	livesCount()
	
	local playerCount = 0
	local exitingCount = 0
	local takisCount = 0
	t.scoreboard = {}
	for p in players.iterate
		if p.valid
			if p.exiting
			or p.spectator 
			or p.pizzaface
			or (p.ptsr_outofgame or (p.ptsr and p.ptsr.outofgame))
			or p.playerstate == PST_DEAD
				exitingCount = $+1
			end
			if (skins[p.skin].name == TAKIS_SKIN)
				takisCount = $+1
			end
			
			if not p.spectator
				table.insert(t.scoreboard,p)
			end
			
			playerCount = $+1
		end
	end
	table.sort(t.scoreboard, function(a,b)
		local p1 = a
		local p2 = b
		
		if gametype == GT_RACE
			if circuitmap
				if not (p2 and p2.valid) then return true end
				
				if p1.laps > p2.laps then
					return true
				elseif p1.laps < p2.laps
					return false
				end
				if p1.starpostnum > p2.starpostnum
					return true
				else
					if p1.realtime < p2.realtime
						return true
					end
				end
			else
				if p1.realtime < p2.realtime then
					return true
				end
			end
		else
			if p1.score > p2.score then
				return true
			end
			
		end
		
	end)
	m.exitingcount = exitingCount
	m.playercount = playerCount
	m.takiscount = takisCount
	
	if t.forcekart
	or (mapheaderinfo[gamemap].takis_karttutorial)
		for p in players.iterate
			if not TakisKart_Karters[p.realmo.skin]
			or p.playerstate ~= PST_LIVE
			or p.spectator
			or p.inkart
			or (p.realmo.flags & (MF_NOCLIP|MF_NOCLIPTHING|MF_NOTHINK))
			or P_CheckDeathPitCollide(p.realmo)
			or not P_IsValidSprite2(p.realmo,SPR2_KART)
				continue
			end
			local k = P_SpawnMobjFromMobj(p.mo,0,0,0,MT_TAKIS_KART_HELPER)
			k.target = p.realmo
			k.angle = p.mo.angle
			k.flags2 = $|MF2_DONTDRAW
			p.inkart = 2
		end
	end
	
	if not (leveltime % 3*TR)
	and ((multiplayer) and not splitscreen)
	and not (t.noachs)
		if m.takiscount >= 6
			for p in players.iterate
				if skins[p.skin].name == TAKIS_SKIN
				and not (p.takistable.achfile & ACHIEVEMENT_TAKISFEST)
					TakisAwardAchievement(p,ACHIEVEMENT_TAKISFEST)
				end
			end
			
		end
	end
	
	if TAKIS_MAX_HEARTCARDS < 1
		TakisChangeHeartCards(6)
	end
	
	for k,mo in ipairs(t.ideyadrones)
		if not (mo and mo.valid)
			table.remove(t.ideyadrones,k)
		end
	end
	for k,mo in ipairs(t.metalsonics)
		if not (mo and mo.valid)
			table.remove(t.metalsonics,k)
		end
	end
	
	local docardbump = false
	
	if (t.inbossmap
	or (HAPPY_HOUR.happyhour))
	or (displayplayer and displayplayer.valid and displayplayer.takistable
	and (displayplayer.takistable.transfo & TRANSFO_METAL))
	or (mapheaderinfo[gamemap].takis_rakisach ~= nil)
		docardbump = true
	end
	
	if docardbump
		local pos = S_GetMusicPosition()
		local musicname = S_MusicName()
		
		if t.inbossmap
			musicname = mapheaderinfo[gamemap].musname 
		end
		if HAPPY_HOUR.happyhour
			musicname = mapmusname
		end
		
		local bpm = TAKIS_BEATMS[string.lower(musicname or '')] or 140
		local bump = (60*MUSICRATE)/bpm
		local introbeats = 0
		
		local metadata = TAKIS_BEATMETADATA[string.lower(musicname or '')]
		if (metadata ~= nil)
			if metadata.milliseconds ~= nil
				bump = metadata.milliseconds
			end
			
			if metadata.introms ~= nil
				pos = $ - metadata.introms
				pos = max($,0)
			end

			if metadata.introbeats ~= nil
				introbeats = metadata.introbeats
			end
		end
		
		local beattobe = (pos / bump)
		
		if beattobe ~= m.lastbump
		and beattobe > introbeats
			m.cardbump = 10*FU
			m.lastbump = beattobe
		end
	end
	
	if m.cardbump ~= 0 then m.cardbump = $*5/6 end
end)

--didnt know stagefailed was passed onto IntermissionThinker
--until i looked at the source code. this should be documented
--on the wiki now, thanks to yours truely :))))
addHook("IntermissionThinker",function(stagefailed)
	m.inttic = $+1
	m.stagefailed = stagefailed
	
	for p in players.iterate
		local takis = p.takistable
		
		if takis
		and (skins[p.skin].name == TAKIS_SKIN)
		and takis.lastss
			if m.inttic == TR
				if not stagefailed
				and string.lower(G_BuildMapTitle(takis.lastmap)) ~= "black hole zone"
					S_StartSound(nil,sfx_sptclt,p)
				else
					S_StartSound(nil,sfx_altdi1,p)
				end
			elseif m.inttic == TR+(TR*4/5)
				if All7Emeralds(emeralds)
					S_StartSound(nil,sfx_tayeah,p)
				elseif not stagefailed
					if string.lower(G_BuildMapTitle(takis.lastmap)) == "black hole zone"
						S_StartSound(nil,sfx_takoww,p)
					else
						S_StartAntonLaugh(nil,p)
					end
				else
					S_StartSound(nil,sfx_antow3,p)
				end
			end
		end
	end
end)

--this only works if you dont have a menu open...
addHook("KeyDown", function(key)
	if gamestate == GS_TITLESCREEN
		TAKIS_TITLETIME = $-10
		if TAKIS_TITLETIME < 0 then TAKIS_TITLETIME = 0 end
	end
end)

TAKIS_FILESLOADED = $+1
