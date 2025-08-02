/*	HEADER
	All HUD drawing goes here
	No function should modify takis.HUD from here! Edit in TakisHudStuff()!
	
*/

if not (rawget(_G, "customhud")) return end
local modname = "takisthefox"
local battleoffset = 15
local textboxmoveup = 0
local doihaveminhud = false

local function setinterp(v,set)
	if (v.interpolate)
		return v.interpolate(set)
	else
		return -1
	end
end

local modversion = dofile("versionNum.lua")
modversion = string.sub($,1,12)
local builddate = dofile("buildDate.lua")

local viewingangles = {}
local aimingangles = {}

--HUD flyingscore
local hfs = {
	scorex = 0,
	scorey = 0,
	scorea = '',
	scores = 0,
}
rawset(_G,"Takis_HUDBonus",{})
--moved here because ummm man i dont even know
rawset(_G,"TakisAddBonus",function(p,type,text,time,score)
	if Takis_HUDBonus[p] == nil then Takis_HUDBonus[p] = {} end
	
	table.insert(Takis_HUDBonus[p],{
		type = type,
		text = text,
		--add half a second for the tween
		tics = time + TR,
		stics = time + TR,
		score = score,
		ypos = (hfs.scorey-30)*FU,
		wait = 12,
	})
end)
addHook("MapLoad",do
	Takis_HUDBonus = {}
end)
local combopatchx = 0

--TODO: remove all separate black boxes and simplify them into
--		one generic drawing func
local function drawblackbox(v, x,y, width,height, flags, colormap)
	width = max($,4*FU)
	height = max($,7*FU)
	
	local fill = v.cachePatch("TA_BB_STENC_F")
	local tcorn = v.cachePatch("TA_BB_STENC_TC")
	local bcorn = v.cachePatch("TA_BB_STENC_BC")
	local cornf = v.cachePatch("TA_BB_STENC_FC")
	
	local fhei = fill.height*FU
	v.drawStretched(x + 2*FU,y,
		width - 4*FU,
		FixedDiv(height,fhei),
		fill,
		flags,
		colormap
	)
	
	for i = 0,1
		v.drawScaled(x + (width*i),
			y,
			FU,
			tcorn,
			flags|(V_FLIP*i),
			colormap
		)
		
		v.drawScaled(x + (width*i),
			(y + height)-3*FU,
			FU,
			bcorn,
			flags|(V_FLIP*i),
			colormap
		)
		v.drawStretched(x + (width*i),
			y + 3*FU,
			FU, --width - 4*FU,
			FixedDiv(height - 6*FU,cornf.height*FU),
			cornf,
			flags|(V_FLIP*i),
			colormap
		)
	end
end

local function drawfont(v, x,y, scale, text, font, align, flags, cmap)
	if align == nil then align = "left" end
	
	local textWidth = 0
	if align ~= "left"
		for i = 1, string.len(text)
			
		end
	end
	
end

local function happyshakelol(v)
	local s = 5
	local shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
	
	local d1 = v.RandomRange(-1,1)
	local d2 = v.RandomRange(-1,1)
	if d1 == 0
		d1 = v.RandomRange(-1,1)
	end
	if d2 == 0
		d2 = v.RandomRange(-1,1)
	end

	shakex = $*s*d1
	shakey = $*s*d2
	
	return shakex,shakey
end


--if TAKIS_ISDEBUG then return end

--HEALTH----------

local function drawheartcards(v,p)

	if (customhud.CheckType("takis_heartcards") != modname) return end
	
	if p.takis_noabil ~= nil
	and mapheaderinfo[gamemap].takis_tutorialmap ~= nil
		if p.takistable.heartcards == TAKIS_MAX_HEARTCARDS
			return
		end
	end
	
	local amiinsrbz = false
	
	if (gametype == GT_ZE2)
		amiinsrbz = true
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz
	or p.takistable.hhexiting
		return
	end
	
	local xoff = 15*FU
	local takis = p.takistable
	local me = p.mo
	
	local oldmh = doihaveminhud
	if mapheaderinfo[gamemap].takis_karttutorial
		doihaveminhud = true
		if takis.heartcards == TAKIS_MAX_HEARTCARDS
			return
		end
	end
	
	if p.takis_noabil ~= nil
	and mapheaderinfo[gamemap].takis_tutorialmap ~= nil
	or (doihaveminhud)
		xoff = -2*FU
	end
	doihaveminhud = oldmh
	
	--space allocated for all the cards
	local bump = TAKIS_MISC.cardbump
	/*
	if ((TAKIS_NET.inbossmap)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.health))
	or (HAPPY_HOUR.happyhour)
		bump = TAKIS_MISC.cardbump
	end
	*/
	local maxspace = 90*FU+bump
	
	--position of the first card
	local maxx = maxspace
	
	--heart cards
	for i = 1, TAKIS_MAX_HEARTCARDS do
		
		local j = i
		
		local eflag = V_HUDTRANS
		if (TAKIS_NET.inbossmap)
		and (takis.HUD.bosscards and takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid)
		and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.health)
			eflag = $ &~V_HUDTRANS
			eflag = $|(v.userTransFlag())
		end
		
		--patch
		local patch = v.cachePatch("HEARTCARD1")
		if ultimatemode
			patch = v.cachePatch("HEARTCARD3")
		end
		
		local hp = (takis.HUD.heartcards.spintic) and takis.HUD.heartcards.oldhp or takis.heartcards
		
		if takis.HUD.heartcards.spintic
			local maxhp2 = takis.heartcards
			if (TAKIS_MAX_HEARTCARDS-i > takis.HUD.heartcards.oldhp - 1)
				patch = v.cachePatch("HEARTCSPIN"..4-(takis.HUD.heartcards.spintic/2))
			end
		end
		if TAKIS_MAX_HEARTCARDS-i > takis.heartcards - 1
		or p.spectator
			patch = v.cachePatch("HEARTCARD2")
			if p.spectator
				eflag = V_HUDTRANSHALF
			end
		end
		
		--
		
		--always make the first card (onscreen) go up
		local add = -3*FU
		local iseven = TAKIS_MAX_HEARTCARDS%2 == 0
		if (i%2 and iseven)
		or (not (i%2) and not iseven)
			add = 3*FU
		end
		
		if TAKIS_MAX_HEARTCARDS == 1
			add = 0
			j = 0
		end
		
		--shake
		local shakex,shakey = 0,0
		
		if takis.HUD.heartcards.shake
		and not (paused)
		and not (menuactive and takis.isSinglePlayer)
		and not p.spectator
			
			local s = takis.HUD.heartcards.shake
			shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
			
			local d1 = v.RandomRange(-1,1)
			local d2 = v.RandomRange(-1,1)
			if d1 == 0
				d1 = v.RandomRange(-1,1)
			end
			if d2 == 0
				d2 = v.RandomRange(-1,1)
			end
		
			shakex = $*s*d1
			shakey = $*s*d2
		end
		--
		
		local incre = (FixedMul(
				FixedDiv(maxspace,TAKIS_MAX_HEARTCARDS*FU)*j,
				FU*4/5
			)
		)
		
		if (takis.inBattle) then add = $+battleoffset*FU end

		--draw from last to first
		local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|eflag
		v.drawScaled(maxx-(incre)+xoff+shakex,
			15*FU+add-takis.HUD.heartcards.add+shakey,
			4*FU/5, patch, flags
		)
	end
	
end

local function drawbosscards(v,p)

	if (customhud.CheckType("takis_bosscards") != modname) return end
	
	local xoff = -20*FU
	local takis = p.takistable
	local me = p.mo
	local bosscards = takis.HUD.bosscards
	
	if (bosscards == nil) then return end
	if not (bosscards.mo and bosscards.mo.valid) then return end
	if (bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) then return end
	
	local amiinsrbz = false
	
	if (gametype == GT_ZE2)
		amiinsrbz = true
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz
	or p.takistable.hhexiting
	or p.takistable.inChaos
		return
	end
	
	
	--space allocated for all the cards
	local bump = 0
	if (bosscards.mo.health)
		bump = TAKIS_MISC.cardbump
	end
	local maxspace = 110*FU+bump
	
	--position of the first card
	local maxx = maxspace
	
	if TAKIS_BOSSCARDS.bossprefix[bosscards.mo.type] ~= nil then xoff = 4*FU end
	if doihaveminhud then xoff = -20*FU end
	
	--tween in/out
	local et = TR/2
	local tween = 0
	if not (TAKIS_NET.inbossmap and bosscards.mo.health)
	and (bosscards.mo)
		local tics = min(bosscards.timealive or 0,et+1)
		tween = ease.outback((FU/et)*tics,-300*FU,0,FU*3/2)
	end
	xoff = $+tween
	
	--boss cards
	for i = 1, bosscards.maxcards do
		
		local j = i
		
		local eflag = V_HUDTRANS
		if (TAKIS_NET.inbossmap)
		and (bosscards.mo and bosscards.mo.health)
			eflag = $ &~V_HUDTRANS
			eflag = $|(v.userTransFlag())
		end
		
		--patch
		local patch = v.cachePatch("HEARTCARD3")
		if (bosscards.name == "Rakis")
			patch = v.cachePatch("HEARTCARD1")
		end
		
		if bosscards.maxcards-i > bosscards.cards-1
			patch = v.cachePatch("HEARTCARD2")
		end			
		--
		
		--always make the first card (onscreen) go up
		local add = -3*FU
		local iseven = bosscards.maxcards%2 == 0
		if (i%2 and iseven)
		or (not (i%2) and not iseven)
			add = 3*FU
		end
		
		if bosscards.maxcards == 1
			add = 0
		end
			
		local shakex,shakey = 0,0
		if bosscards.cardshake
		and not (paused)
		and not (menuactive and (not multiplayer or splitscreen))
			
			local s = bosscards.cardshake
			shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
			
			local d1 = v.RandomRange(-1,1)
			local d2 = v.RandomRange(-1,1)
			if d1 == 0
				d1 = v.RandomRange(-1,1)
			end
			if d2 == 0
				d2 = v.RandomRange(-1,1)
			end
		
			shakex = $*s*d1
			shakey = $*s*d2
		end
		
		local incre = (FixedMul(
				FixedDiv(maxspace,bosscards.maxcards*FU)*j,
				FU*4/5
			)
		)
		
		--draw from last to first
		local flags = V_SNAPTORIGHT|V_SNAPTOTOP|eflag|V_FLIP
		v.drawScaled(300*FU-(maxx-(incre)+xoff)+shakex,
			15*FU+add+shakey,
			4*FU/5, patch, flags
		)
	end
	
end

--      ----------

--FACE  ----------

local faceticcer = 0

--Use this instead of takis.HUD.statusface to avoid any potential resynchs,
--even though hud.statusface is only used for hud and not positioning
local statusface = {
	state = '',
	frame = 0,
	priority = 0,
	--for "SPR2" states
	spr2 = SPR2_STND,
}

--referencing doom's status face code
-- https://github.com/id-Software/DOOM/blob/77735c3ff0772609e9c8d29e3ce2ab42ff54d20b/linuxdoom-1.10/st_stuff.c#L752
local function calcstatusface(p,takis)
	local me = p.mo
	local noretrooverride = false
	
	if (me and me.valid)
	and not (me.flags & MF_NOTHINK)
		faceticcer = leveltime
	end
	
	--idle
	if not HAPPY_HOUR.happyhour
	and not ((p.pizzaface) or ultimatemode)
		statusface.state = "IDLE"
		statusface.frame = (faceticcer/3)%2
		statusface.priority = 0
	else
		statusface.state = "PTIM"
		statusface.frame = (2*faceticcer/3)%2
		statusface.priority = 0
	end
	if takis.isAngry
		statusface.state = "AGRY"
		statusface.frame = (faceticcer/3)%4
		statusface.priority = 0
	end
	if (takis.transfo & TRANSFO_SHOTGUN)
		statusface.state = "SGUN"
		statusface.frame = (faceticcer/3)%2
		statusface.priority = 0		
	end
	if ((takis.transfo & TRANSFO_BALL)
	or (p.pflags & PF_SPINNING))
	and (p.realmo.sprite2 == SPR2_ROLL)
		--im lazy and dont want to draw more ball frames
		statusface.state = "SPR2"
		statusface.spr2 = SPR2_ROLL
		statusface.frame = p.realmo.frame
		statusface.priority = 0
		noretrooverride = true
	end
	if (takis.transfo & TRANSFO_PANCAKE)
		statusface.state = "PCKE"
		statusface.frame = (faceticcer/4)%2
		statusface.priority = 0		
	end
	
	if (takis.heartcards <= (TAKIS_MAX_HEARTCARDS/TAKIS_MAX_HEARTCARDS or 1))
	and not (takis.fakeexiting)
	and (statusface.state == "IDLE")
		statusface.state = "PTIM"
		statusface.frame = (2*faceticcer/3)%2
		statusface.priority = 0	
	end
	
	if statusface.priority < 10
		
		--dead
		if not (me)
		or (not me.health)
		or (p.playerstate ~= PST_LIVE)
		or (p.spectator)
		or (me.sprite2 == SPR2_TDD3)
			statusface.state = "DEAD"
			statusface.frame = 0
			statusface.priority = 9
		end
	end
	
	if statusface.priority < 9
		
		--pain
		if not takis.resettingtoslide
			if ((takis.inPain or takis.inFakePain)
			or (takis.ticsforpain)
			or (me.sprite2 == SPR2_PAIN)
			or (me.state == S_PLAY_PAIN)
			or (takis.HUD.statusface.painfacetic))
			or (me.pizza_out or me.pizza_in)
			or (takis.pitanim)
			or (takis.screaming)
			and me.sprite2 ~= SPR2_SLID
				statusface.state = "PAIN"
				statusface.frame = (faceticcer%4)/2
				statusface.priority = 8
			end
		end
	end
	
	
	if statusface.priority < 8
		
		--evil grin when killing someone
		--or a boss
		if takis.HUD.statusface.evilgrintic
		or (takis.transfo & TRANSFO_SHOTGUN
		and TAKIS_NET.chaingun
		and takis.use >= TR*2)
			statusface.state = "EVL_"
			statusface.frame = (faceticcer/4)%2
			statusface.priority = 7
		end
		
	end
	
	if statusface.priority < 7
		
		--happy face
		if takis.HUD.statusface.happyfacetic
		or takis.tauntid == 2
			statusface.state = "HAPY"
			statusface.frame = (faceticcer/2)%2
			statusface.priority = 6		
		end
		
	end
	
	
	if statusface.priority < 6
		
		--doom's godmode face
		if (p.pflags & PF_GODMODE)
			statusface.state = "GOD_"
			statusface.frame = (faceticcer/3)%2
			statusface.priority = 5
		end
		
	end
	
	if statusface.priority < 2
	
		--space drown
		if ((P_InSpaceSector(me)) and (p.powers[pw_spacetime]))
		or ((p.powers[pw_underwater]) and (p.powers[pw_underwater] <= 11*TR))
			statusface.state = "SDWN"
			statusface.frame = (faceticcer)%2
			statusface.priority = 1
		end
		
	end
	
	--isnt this just so retro?
	--god, if only i lived in retroville
	if TAKIS_NET.isretro
	and not noretrooverride
		statusface.frame = 0
	end
	
end

local function drawface(v,p)

	if (customhud.CheckType("takis_statusface") != modname) return end
	
	if (p.takis_noabil ~= nil and mapheaderinfo[gamemap].takis_tutorialmap ~= nil) then return end
	
	local amiinsrbz = false
	
	if (gametype == GT_ZE2)
		amiinsrbz = true
	end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or amiinsrbz
	or p.takistable.hhexiting
		return
	end
	
	if mapheaderinfo[gamemap].takis_karttutorial
		return
	end
	
	local takis = p.takistable
	local me = p.realmo
	
	if not (me and me.valid) then return end
	if (me.skin ~= TAKIS_SKIN) then return end
	if (doihaveminhud) then return end
	
	local eflags = V_HUDTRANS
	
	local headcolor
	if p.spectator
		headcolor = SKINCOLOR_CLOUDY
		eflags = V_HUDTRANSHALF
	else
		if ((me) and (me.valid))
			headcolor = me.color
		else
			headcolor = SKINCOLOR_CLOUDY
			eflags = V_HUDTRANSHALF
		end
	end
	
	local pre = "TAK"
	local scale = 2*FU/5
	local x,y2 = 0,0
	if TAKIS_NET.isretro
		pre = "RETR_"
		scale = $*3
		x = -17*FU
		y2 = -20*FU
	end
	
	calcstatusface(p,takis)
	local healthstate,healthframe = statusface.state,statusface.frame
	local headpatch
	local flip = false
	if (healthstate ~= "SPR2")
		headpatch = v.cachePatch(pre..healthstate..tostring(healthframe))
	else
		flip = true
		headpatch = v.getSprite2Patch(TAKIS_SKIN,
			statusface.spr2,
			p.powers[pw_super] > 0,
			healthframe,
			2,0
		)
		scale = (2*FU/5)*8/5
		y2 = 7*FU
	end
	
	local y = 0
	local expectedtime = TR
	
	if HAPPY_HOUR.time and HAPPY_HOUR.time < 3*TR
	and HH_CanDoHappyStuff(p)
		local tics = HAPPY_HOUR.time
		
		if (tics < 2*TR)
			y = ease.inquad(( FU / expectedtime )*tics, 0, -60*FU)
		else
			y = ease.outquad(( FU / expectedtime )*(tics-(2*TR)), -60*FU, 0)
		end
	end
	
	if (TAKIS_NET.inbossmap)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid)
	and (takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.health)
		eflags = $ &~(V_HUDTRANS|V_HUDTRANSHALF)
		eflags = $|(v.userTransFlag())
	end
	
	if (takis.inBattle) then y2 = $+battleoffset*FU end
	
	if flip == true then eflags = $|V_FLIP end
	v.drawScaled(20*FU+x,27*FU+y+y2,
		scale,
		headpatch,
		V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|eflags,
		v.getColormap((me and me.valid and me.colorized or p.spectator) and TC_RAINBOW or nil,headcolor)
	)

end

local function calcbossface(bosscards,me)
	local status = bosscards.statusface
	
	--idle
	status.state = "IDLE"
	status.frame = (leveltime/3)%2
	status.priority = 0
		
	if (bosscards.maxcards > 0)
	and (bosscards.cards <= 2)
		status.state = "LWHP"
		status.frame = (2*leveltime/3)%2
		status.priority = 0	
	end
	
	if status.priority < 10
		
		--dead
		if (not me.health)
		or (bosscards.cards == 0)
			status.state = "DEAD"
			status.frame = 0
			status.priority = 9
		end
	end
	
	if status.priority < 9
		
		--pain
		if (me.flags2 & MF2_FRET)
		or (me.state == me.info.painstate)
			status.state = "PAIN"
			status.frame = (leveltime%4)/2
			status.priority = 8
		end
		
	end
	
	
	if status.priority < 8
		
		--evil grin when killing someone
		-- --or attacking		
		if (me.p_target and me.p_target.valid)
		and (me.p_target.health == 0 
		or me.p_target.state == S_PLAY_PAIN
		or me.p_target.sprite2 == SPR2_PAIN)
		/*
		or (me.state == me.info.meleestate
		or me.state == me.info.missilestate)
		*/
			status.state = "EVL_"
			status.frame = (leveltime/4)%2
			status.priority = 7
		end
		
	end
	
	return status.state, status.frame
end

local function drawbossface(v,p)

	if (customhud.CheckType("takis_statusface") != modname) return end
	

	local takis = p.takistable
	local me = p.mo
	local bosscards = takis.HUD.bosscards
	
	if not (bosscards.mo and bosscards.mo.valid) then return end
	if not (bosscards.name) then return end
	if (bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) then return end
	if (takis.inChaos) then return end
	if (doihaveminhud) then return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	
	local eflags = v.userTransFlag()
	
	local pre = TAKIS_BOSSCARDS.bossprefix[bosscards.mo.type]
	local scale = 2*FU/5
	
	if pre == nil then return end
	
	local healthstate,healthframe = calcbossface(bosscards,bosscards.mo)	
	local headpatch
	local headstring = pre..healthstate..tostring(healthframe)
	if not v.patchExists(headstring)
		pre = "TAK"
		headstring = pre..healthstate..tostring(healthframe)
		eflags = $|V_FLIP
	end
	
	local tcmap = (bosscards.mo.flags2 & MF2_FRET and (leveltime % 2)) and TC_BOSS or TC_DEFAULT
	local cmap = SKINCOLOR_NONE
	if (bosscards.mo.color ~= SKINCOLOR_NONE)
		cmap = bosscards.mo.color
		tcmap = (bosscards.mo.colorized and TC_RAINBOW or TC_DEFAULT)
	end
	
	headpatch = v.cachePatch(headstring)
	
	--tween in/out
	local et = TR/2
	local tween = 0
	if not (TAKIS_NET.inbossmap and bosscards.mo.health)
	and (bosscards.mo)
		local tics = min(bosscards.timealive or 0,et+1)
		tween = ease.outback((FU/et)*tics,-300*FU,0,FU*3/2)
	end
	
	v.drawScaled((300-5)*FU-tween,
		27*FU,
		scale,
		headpatch,
		V_SNAPTORIGHT|V_SNAPTOTOP|eflags,
		v.getColormap(tcmap,cmap)
	)

end

--      ----------

--RINGS ----------

local function drawrings(v,p)

	if (customhud.CheckType("rings") != modname) return end

	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	or p.takistable.hhexiting
	or (p.takis_noabil ~= nil 
	and mapheaderinfo[gamemap].takis_tutorialmap ~= nil 
	and p.rings == 0)
	or (ultimatemode)
		return
	end

	
	if (hud.enabled("score") or hud.enabled("time") or hud.enabled("rings"))
	and not (p.takistable.inBattle)
		local y = 9*FU
		if (p.takistable.inBattle)
			y = $+battleoffset*FU	
		end
		
		v.drawScaled(8*FU,y,FU,
			v.cachePatch("TA_HUDBG"..(doihaveminhud and "2" or "1")),
			V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANSHALF
		)
	end
	
	local takis = p.takistable
	
	local ringpatch = takis.HUD.rings.sprite
	local flash = false
	
	if p.rings == 0
	and takis.heartcards <= 0
	and not (p.exiting)
		flash = true
	end
	
	if (p.rings <= 0)
	and ((not (gametyperules & GTR_FRIENDLY))
	or G_RingSlingerGametype()
	and not p.spectator)
		flash = true
	end
	
	flash = (flash and ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1))

	local eflag = V_HUDTRANS
	if p.spectator then eflag = V_HUDTRANSHALF end
	
	if not (doihaveminhud)
		local ringFx,ringFy = unpack(takis.HUD.rings.FIXED)
		local ringx,ringy = unpack(takis.HUD.rings.int)
		
		if (p.takis_noabil ~= nil)
		and mapheaderinfo[gamemap].takis_tutorialmap ~= nil
		or mapheaderinfo[gamemap].takis_karttutorial
			ringx = 102
			if (takis.heartcards == TAKIS_MAX_HEARTCARDS)
			--and not (mapheaderinfo[gamemap].takis_karttutorial)
				ringFy = 28*FU
				ringy = 15
			end
		end
		
		local val = p.rings
		
		if (takis.inBattle)
			ringFy = $+battleoffset*FU	
			ringy = $+battleoffset	
		end
		
		local spinframe = 0
		if takis.HUD.rings.ringframe ~= 0
			spinframe = FixedInt(takis.HUD.rings.spin) % takis.HUD.rings.ringframe
		end
		
		local patch,flip = v.getSpritePatch(ringpatch, spinframe, 0)
		if patch == nil
			if takis.HUD.rings.ringframe ~= 0
				patch = v.getSpritePatch(ringpatch, spinframe-1, 0)
				--still???
				if patch == nil
					patch = v.getSpritePatch(ringpatch, 0, 0)
				end
			else
				patch = v.getSpritePatch(ringpatch, 0, 0)
			end
		end
		eflag = $|(flip and V_FLIP or 0)
		
		if takis.HUD.rings.shake
			local s = takis.HUD.rings.shake
			local shakex,shakey = v.RandomFixed()/6,v.RandomFixed()/6
			
			local d1 = v.RandomRange(-1,1)
			local d2 = v.RandomRange(-1,1)
			if d1 == 0
				d1 = v.RandomRange(-1,1)
			end
			if d2 == 0
				d2 = v.RandomRange(-1,1)
			end
		
			shakex = $*s*d1
			shakey = $*s*d2
			ringFx = $+shakex
			ringFy = $+shakey
		end
		
		local colormap
		local tcolormap
		
		if G_GametypeHasTeams()
		and ringpatch == "TRNG"
			if p.spectator
				ringpatch = "RING"
			else
				colormap = v.getColormap(nil,p.ctfteam == 1 and skincolor_redring or skincolor_bluering)
			end
		end
		
		if flash
			tcolormap = v.getColormap(TC_RAINBOW,SKINCOLOR_RED)
		end
		
		--classic x = 102
		v.drawScaled(
			ringFx,
			ringFy,
			FU/2,
			patch,
			V_SNAPTOLEFT|V_SNAPTOTOP|eflag|V_PERPLAYER,
			colormap
		)
		
		local rings = (takis.HUD.rings.drawrings > 0) and tostring(takis.HUD.rings.drawrings) or "*"
		if rings:len() < 4
			for i = 1,4-rings:len()
				rings = "*"..$
			end
		end
		for i = rings:len(),1,-1
			local n = string.sub(rings,i,i)
			local number = (n ~= "*") and n or "0"
			local oflag = (n == "*") and V_HUDTRANSHALF or V_HUDTRANS
			local patch = v.cachePatch("STTNUM"+number)
			ringx = $-v.cachePatch("STTNUM0").width
			v.drawScaled(ringx*FU,
				ringy*FU,
				FU,
				patch,
				V_SNAPTOLEFT|V_SNAPTOTOP|(eflag &~(V_FLIP|V_HUDTRANS))|V_PERPLAYER|oflag,
				tcolormap
			)
				
		end
		
	else
 		
		local off = (takis.inBattle) and battleoffset or 0
		
		v.drawScaled(20*FU,
			52*FU+(off*FU),
			FU/4,
			v.getSpritePatch(ringpatch, A, 0, 0),
			V_SNAPTOLEFT|V_SNAPTOTOP|eflag|V_PERPLAYER,
			nil
		)
		v.drawString(45,45+off,
			p.rings,
			V_SNAPTOLEFT|V_SNAPTOTOP|eflag|V_PERPLAYER,
			"thin-right"
		)
		
	end
	
end

--      ----------

--TIMER ----------

--this is so minhud
-- https:--mb.srb2.org/addons/minhud.2927/
local function howtotimer(player)
	local flash, tics = false
	
	local pt, lt = player.realtime, leveltime
	local puretlimit, purehlimit = CV_FindVar("timelimit").value, CV_FindVar("hidetime").value
	local tlimit = puretlimit * 60 * TR
	local hlimit = purehlimit * TR
	local extratext = ''
	local extrafunc = ''
	local timertype = "regular"
	local forcedraw = false
	
	-- Counting down the hidetime?
	if (gametyperules & GTR_STARTCOUNTDOWN)
	and (pt <= hlimit)
		tics = hlimit - pt
		--match race nums
		tics = $+(TR-1)
		
		flash = true
		extrafunc = "countinghide"
		timertype = "counting"
		forcedraw = true
	else
		
		-- Time limit?
		if (gametyperules & GTR_TIMELIMIT) 
		and (puretlimit) then -- Gotta thank CobaltBW for spotting this oversight.
			if (tlimit > pt)
				tics = (tlimit+(TR-1)) - pt
				--match race nums
				--tics = $+(TR-1)
			else -- Overtime!
				tics = 0
			end
			if ((gametyperules & (GTR_STARTCOUNTDOWN|GTR_TAG)) == (GTR_STARTCOUNTDOWN|GTR_TAG))
				if (tlimit+hlimit > pt)
					tics = (tlimit+hlimit+(TR-1)) - pt
					--tics = $+(TR-1)
				else -- Overtime!
					tics = 0
				end
			end
			
			forcedraw = true
			flash = true
			timertype = "counting"
		-- Post-hidetime normal.
        elseif (gametyperules & GTR_STARTCOUNTDOWN)
		and (gametyperules & GTR_TIMELIMIT) -- Thanking 'im again.
			tics = pt-hlimit
        elseif (gametyperules & GTR_STARTCOUNTDOWN)
            tics = pt
			tics = $+hlimit
			extrafunc = "hiding"
			timertype = "counting"
		--level timelimit
		elseif (mapheaderinfo[gamemap].countdown)
			local climit = (mapheaderinfo[gamemap].countdown*TR)
			if climit > pt
				tics = climit - pt
			else
				tics = 0
			end
			forcedraw = true
			flash = true
		else
            tics = pt
        end
	end
	
	flash = (flash and (tics < 30*TR) and (lt/5 & 1)) -- Overtime?
	
	return flash, tics, extratext, extrafunc, timertype, forcedraw
end

local function drawcountdown(v,p)
	--if (customhud.CheckType("time") != modname) return end
	
	local takis = p.takistable
	local cd = takis.HUD.countdown
	
	--countdown
	if cd.tics
		if cd.tics == 1 then return end
		local trans = 0
		if cd.tics <= 9
			trans = (10-cd.tics)<<V_ALPHASHIFT
		end
		
		local scorenum = "CMBCF"
		local score = cd.number
		local prevw
		if not prevw then prevw = 0 end
		local scale = 2*FU+cd.scale+cd.scale2
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*scale*4/10)		
		end
		
		for i = 1,string.len(score)
			local sc = FixedDiv(scale,2*FU)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			--local textwidth = (patch.width*scale*4/10)
			v.drawScaled(160*FU+prevw-(textwidth/2),
				145*FU-(patch.height/2*sc)+6*FU-(FU/2),
				sc,
				patch,
				trans
			)
				
			prevw = $+(patch.width*scale*4/10)
		end
	
	end

end

/*
	and (not altpos)
	and not modeattacking
	and not (forcedraw or altpos)
		if not p.exiting then return end
	end
	
*/

local function shouldtimerdraw(v,p,altpos,type,forcedraw)
	if altpos
	or modeattacking
		return true
	end
	
	if (type == "regular"
	and (gametype == GT_COOP))
	and not (doihaveminhud)
	and not HAPPY_HOUR.happyhour
		if not p.exiting then return false; end
	end
	
	
	--this shouldnt happen because you never have minhud in these levels
	if (doihaveminhud)
	and (p.takis_noabil ~= nil
	and mapheaderinfo[gamemap].takis_tutorialmap ~= nil)
	and not p.exiting
		return false
	end
	
	return true
end

--TODO: this wont show in tab menu
local function drawtimer(v,p,altpos)

	if (customhud.CheckType("time") != modname) return end
	
	if altpos == nil then altpos = false end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	or HAPPY_HOUR.othergt
		return
	end
	
	local takis = p.takistable
	local cd = takis.HUD.countdown
	
	--time
	--this is so minhud
	local flashflag = 0
	local flash,timetic,extratext,extrafunc,type,forcedraw = howtotimer(p)
	
	if not shouldtimerdraw(v,p,altpos,type,forcedraw) then return end
	/*
	if (type == "regular"
	and (gametype == GT_COOP))
	and (not altpos)
	and not modeattacking
	and not (doihaveminhud)
	and not HAPPY_HOUR.happyhour
	and not (forcedraw or altpos)
		if not p.exiting then return end
	end
	
	if (doihaveminhud)
	and (p.takis_noabil ~= nil
	and mapheaderinfo[gamemap].takis_tutorialmap ~= nil)
	and not p.exiting
		return
	end
	*/
	
	if flash
		flashflag = V_REDMAP
	end
	
	local hours = G_TicsToHours(timetic)
	local minutes = G_TicsToMinutes(timetic, false)
	local seconds = G_TicsToSeconds(timetic)
	local tictrn  = G_TicsToCentiseconds(timetic)
	local spad, tpad = '', ''
	local extra = ''
	local extrac = ''
	
	--paddgin!!
	if (seconds < 10) then spad = '0' end
	if (tictrn < 10) then tpad = '0' end
	
	local timex, timey = unpack(takis.HUD.timer.int)
	local timetx = takis.HUD.timer.text
			
	if hours > 0
		extrac = ":"
		if (minutes < 10)
			extrac = $.."0"
		end
	else
		hours = ''
	end
	
	if timetic >= (10*60*TR)
	and extrafunc == ''
		extra = " (SUCKS)"
	end
	
	/*
	if p.spectator
		timex, timey = unpack(takis.HUD.timer.spectator)
	elseif ( ((p.pflags & PF_FINISHED) and (netgame))
	or extrafunc == "hiding"
	or extrafunc == "countinghide")
	and not p.exiting
		timex, timey = unpack(takis.HUD.timer.finished)
	end
	*/
	
	local flag = V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER|flashflag
	if altpos
		flag = $ &~V_HUDTRANS
		if multiplayer
			flag = $ &~(V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER)
			timetx = 4
			timex = timetx+103
			timey = 184
		end
	end
	if (takis.inBattle)
		timey = 25
		timex = 160
		flag = $ &~V_SNAPTOLEFT
		if (gametype == GT_DIAMOND)
		or (gametype == GT_TEAMDIAMOND)
		or (gametype == GT_CP)
		or (gametype == GT_TEAMCP)
		or (gametype == GT_BATTLECTF)
			timey = $+10
			if (gametype == GT_BATTLECTF)
				timey = $+5
			end
		end
	end
	
	if (doihaveminhud)
	and not takis.inBattle
		timex = 100
		timey = 45
		
		v.drawScaled(50*FU,
			44*FU,
			FU,
			v.cachePatch("NGRTIMER"),
			flag
		)
		
	end
	
	v.drawString(timex, timey,
		hours..extrac..minutes..":"..spad..seconds.."."..tpad..tictrn,
		flag,
		(
			(takis.inBattle) and "thin-center" or "thin-right" --(doihaveminhud and "thin-right" or "right")
		)
	)
	if not takis.inBattle
	and not doihaveminhud
		v.drawString(timetx, timey, "Time"..extra,flag,"thin")
	end

	if extrastring ~= ''
	and not doihaveminhud
		v.drawString(timetx, timey+8, extratext,flag,"thin")			
	end
	
	drawcountdown(v,p)
	
end

--      ----------

--SCORE ----------

local function drawscore(v,p)

	if (customhud.CheckType("score") != modname) return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	or (p.takis_noabil ~= nil
	and mapheaderinfo[gamemap].takis_tutorialmap ~= nil)
		return
	end
	
	if (PTSR)
		if PTSR.intermission_tics
		or (PTSR:inVoteScreen())
		or (HAPPY_HOUR.gameover)
			return
		end
	end
	
	--some of
	if (gametype == GT_TEAMARENA)
	or (gametype == GT_SURVIVAL)
	or (gametype == GT_TEAMSURVIVAL)
	or (gametype == GT_DIAMOND)
	or (gametype == GT_TEAMDIAMOND)
	or (gametype == GT_CP)
	or (gametype == GT_TEAMCP)
	or (gametype == GT_BATLECTF)
	and (takis.inBattle)
		return
	end
	
	if mapheaderinfo[gamemap].takis_karttutorial
		return
	end
	
	local takis = p.takistable
	
	local fs = takis.HUD.flyingscore
	local xshake = fs.xshake
	local yshake = fs.yshake
		
	/*
	if fs.tics
	and (takis.io.minhud == 0)
		score = p.score-fs.lastscore
	end
	*/
	--v.drawString((300-15)*FU+xshake, 15*FU+yshake, takis.HUD.flyingscore.scorenum,V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS|V_PERPLAYER,"fixed-right")
	
	--buggie's tf2 engi code
	local scorenum = "SCREFT"
	local score = fs.scorenum
	local align = "right"
	
	if ((takis.HUD.lives.useplacements
	and takis.placement == 1)
	or (score >= 99999990))
		scorenum = "GSCREFT"
	end
	
	local prevw
	if not prevw then prevw = 0 end
	
	--alignment stuff
	--14 pixels away from edge like timer
	local x,y = 300-2+(v.cachePatch(scorenum.."1").width*4/10),15
	
	if takis.HUD.bosscards.mo and takis.HUD.bosscards.mo.valid
	and not (takis.HUD.bosscards.nocards
	or TAKIS_BOSSCARDS.nobosscards[takis.HUD.bosscards.mo.type] ~= nil)
		y = $+30
	end
	
	local snap = V_SNAPTORIGHT|V_SNAPTOTOP
	if takis.inChaos
		x = 303
		y = 55
	end
	
	if (gametype == GT_ARENA)
		x = 160
		y = 35
		align = "center"
		snap = V_SNAPTOTOP
	end
	
	if (circredux and circuitmap)
		y = $ + 20
	end
	
	local width = FixedMul(string.len(score)*FU,(v.cachePatch(scorenum.."1").width*FU*4/10))
	if align == "center"
		width = $/2
	elseif align ~= "right"
		width = 0
	end
	--
	
	--correct for width-1
	hfs.scorex, hfs.scorey = x,y
	hfs.scorea = align
	hfs.scores = snap
	
	for i = 1,string.len(score)
		local n = string.sub(score,i,i)
		v.drawScaled((x+prevw)*FU+xshake-width,
			y*FU+yshake,
			FU/2,
			v.cachePatch(scorenum+n),
			snap|V_HUDTRANS|V_PERPLAYER
		)
			
		prevw = $+v.cachePatch(scorenum+n).width*4/10
	end
	
	if fs.tics
	and (doihaveminhud == false)
		local expectedtime = 2*TR
		local tics = ((2*TR)+1)-fs.tics
		
		local total_width = (v.width() / v.dupx()) + 1
		local total_height = (v.height() / v.dupy()) + 1
		
		local cxpos = (160*FU-(total_width*FU/2))+takis.HUD.combo.basex
		local cypos = ((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey

		local sxpos = (160*FU+(total_width*FU/2))-(300*FU-((x*FU)+((v.cachePatch(scorenum.."1").width*4/10)*FU)))
		local sypos = ((100*FU)-(total_height*FU/2))+(y*FU)
		
		local fx = ease.inexpo(
			( FU / expectedtime )*tics,
			cxpos+5*FU+combopatchx, 
			sxpos
		)
		local fy = ease.inexpo(
			( FU / expectedtime )*tics,
			cypos+7*FU, 
			sypos
		)
		
		v.drawString(fx, fy, 
			fs.num,
			V_HUDTRANS|V_PERPLAYER,
			"thin-fixed-center"
		)
		
	end
end

--      ----------

--LIVES ----------

local function getnamemap(name)
	local map = V_YELLOWMAP
	if name == "Rakis"
	or name == "Raykis"
	or name == "Sjakis"
		map = V_REDMAP
	elseif name == "Taykis"
	or name == "Takeys"
		map = V_GREENMAP
	elseif name == "Blukis"
		map = V_BLUEMAP
	elseif name == "Golkis"
		map = (leveltime/4 % 3 == 0) and V_YELLOWMAP or ((leveltime/4 % 3 == 1 or leveltime/4 % 3 == 3) and V_BROWNMAP or V_ORANGEMAP)
	elseif name == "Rakeys"
		map = V_MAGENTAMAP
	elseif name == "Poyo"
	or name == "Speckis"
		map = V_INVERTMAP
	elseif name == "Jsakis"
		map = V_AZUREMAP
	end
	return map
end

local buttonmoveup = false
local tooltiptobt = {
	["C1"] = "c1",
	["C2"] = "c2",
	["C3"] = "c3",
	["JUMP"] = "jump",
	["SPIN"] = "use",
}
local function drawtooltip(v,p, x,y,disp, tooltip)
	local me = p.mo
	local takis = p.takistable
	
	local flags = tooltip.flags or V_HUDTRANS
	flags = $|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
	
	local tween = -55*FU
	local buttonsize = FU/2
	local thing = false
	if tooltip.tics >= TAKIS_TOOLTIP_TIME - (TR/2)
		local intic = TR/2 - (tooltip.tics - ((TAKIS_TOOLTIP_TIME-TR) + TR/2))
		local etin = TR/2
		tween = ease.outback((FU/etin)*intic, -55*FU, 0, FU*3/2)
	elseif tooltip.tics <= (TR/2) + 1
		local intic = TR/2 - (tooltip.tics-1)
		local etin = TR/2
		tween = ease.inquad((FU/etin)*intic, 0, -150*FU)
		thing = true
		--buttonsize = ease.inquad((FU/etin)*intic, FU/2, FU/4)
	else
		tween = 0
	end
	
	x = $ + tween
	if tooltip.tics ~= 1
		local off = 0
		if tooltip.button2
			off = 20*FU
		end
		
		v.drawScaled(x - 3*FU, y+disp, (FU), v.cachePatch("TA_BUTTONBG"),
			(flags &~(V_ALPHAMASK))|V_HUDTRANSHALF
		)
		v.drawString(x+20*FU + off,
			y+disp+5*FU,
			tooltip.text,
			V_ALLOWLOWERCASE|(flags &~(V_ALPHAMASK))|V_HUDTRANS,
			"thin-fixed"
		)
	end
	
	if tooltip.prolong
	and thing
		x = $ - tween
	end
	
	local bttrans = (flags & V_ALPHAMASK)
	local holdingdown = false
	local thres
	if (tooltip.holdthresh ~= nil)
		local mybutton = takis[tooltiptobt[tooltip.button]]
		thres = min(mybutton*FU, tooltip.holdthresh*FU)
		
		if thres
			bttrans = V_HUDTRANSHALF
		end
	end
	
	v.drawScaled(x,
		y+disp,
		buttonsize,
		v.cachePatch("TB_"..tooltip.button),
		(flags &~(V_ALPHAMASK))|bttrans
	)
	if tooltip.button_am
		v.drawString(x + 5*FU,
			y+disp + 10*FU,
			"x"..tooltip.button_am,
			(flags &~(V_ALPHAMASK))|V_ALLOWLOWERCASE|bttrans,
			"thin-fixed"
		)	
	end
	if tooltip.button2
		v.drawScaled(x + 25*FU,
			y+disp,
			buttonsize,
			v.cachePatch("TB_"..tooltip.button2),
			(flags &~(V_ALPHAMASK))|bttrans
		)
		v.drawString(x + 15*FU,
			y+disp + 5*FU,
			"or",
			(flags &~(V_ALPHAMASK))|V_ALLOWLOWERCASE|bttrans,
			"thin-fixed"
		)
	end
	if tooltip.button2_am
		v.drawString(x + 30*FU,
			y+disp + 10*FU,
			"x"..tooltip.button2_am,
			(flags &~(V_ALPHAMASK))|V_ALLOWLOWERCASE|bttrans,
			"thin-fixed"
		)	
	end
	
	if thres ~= nil
	and thres > 0
		local height = FixedMul(v.cachePatch("TB_"..tooltip.button).height*FU,FixedDiv(
			tooltip.holdthresh*FU - thres,tooltip.holdthresh*FU
		))
		if height < 0
			height = 0
		end
		
		v.drawCropped(
			x,
			y+disp + height/2,
			buttonsize,buttonsize,
			v.cachePatch("TB_"..tooltip.button),
			(flags &~(V_ALPHAMASK))|V_HUDTRANS,
			nil,
			0,height,
			v.cachePatch("TB_"..tooltip.button).width*FU,
			v.cachePatch("TB_"..tooltip.button).height*FU
		)
		
	end
	
	return tooltip.dispreturn or -20*FU
	
end

local function drawlivesbutton(v,p,x,y,flags)
	local me = p.mo
	local takis = p.takistable
	
	local disp = 0
	
	if takis.HUD.lives.tweentic
		local et = TR/2
		local tic = (5*TR)-takis.HUD.lives.tweentic
		local low = 0
		local high = 35*FU
		
		if tic <= TR/2
			disp = ease.outback((FU/et)*tic,low, high, FU*3/2)
		elseif tic >= 4*TR+TR/2
			disp = ease.inquad((FU/et)*((4*TR+TR/2)-tic), high, low)
		else
			disp = high
		end
		
		disp = -$
	end
	
	if (takis.clutchcombo)
	and (takis.io.clutchstyle == 0)
		disp = $-2*FU
	end
	
	if (modeattacking)
		if p.pflags & PF_AUTOBRAKE
			disp = $-10*FU
		else
			disp = $-5*FU
		end
	end
	
	/*
	if ((takis.firenormal)
	or (takis.HUD.rthh.sptic or takis.io.savestate ~= 0)
	or buttonmoveup)
	*/
	if buttonmoveup
	and not takis.HUD.lives.tweentic
		disp = $-35*FU
	end
	
	if (p.inkart and not p.takistable.HUD.lives.nokarthud)
		disp = $-33*FU
	end
	
	if not p.inkart
		local tp = takis.HUD.tooltips
		
		for k,tooltip in pairs(takis.HUD.tooltips)
			
			if tooltip.tics
				disp = $ + drawtooltip(v,p, x,y,disp, tooltip) or 0
			end
			
		end
		
		/*
		if tp["shield"].tics
			disp = $ + drawtooltip(v,p, x,y,disp, tp["shield"]) or 0
		end
		if tp["minecart"].tics
			disp = $ + drawtooltip(v,p, x,y,disp, tp["minecart"]) or 0
		end
		if tp["deshotgun"].tics
			disp = $ + drawtooltip(v,p, x,y,disp, tp["deshotgun"]) or 0
		end
		if tp["canceltaunt"].tics
			disp = $ + drawtooltip(v,p, x,y,disp, tp["canceltaunt"]) or 0
		end
		*/
		
	/*
	else
		if not p.takistable.HUD.lives.nokarthud
		and not (TAKIS_TUTORIALSTAGE and TAKIS_TUTORIALSTAGE < 6)
			v.drawScaled(x - 3*FU, y+disp, (FU), v.cachePatch("TA_BUTTONBG"), flags|V_HUDTRANSHALF)
			v.drawScaled(x, y+disp, (FU/2), v.cachePatch("TB_C3"), flags|V_HUDTRANS)
			v.drawString(x+20*FU, y+disp+5*FU, "Look behind",V_ALLOWLOWERCASE|flags|V_HUDTRANS, "thin-fixed")	
			disp = $-20*FU
			
			if not TAKIS_NET.forcekart
				v.drawScaled(x - 3*FU, y+disp, (FU), v.cachePatch("TA_BUTTONBG"), flags|V_HUDTRANSHALF)
				v.drawScaled(x, y+disp, (FU/2), v.cachePatch("TB_C2"), flags|V_HUDTRANS)
				v.drawString(x+20*FU, y+disp+5*FU, "Dismount",V_ALLOWLOWERCASE|flags|V_HUDTRANS, "thin-fixed")
				disp = $-20*FU
			end
		end
		*/
	end
	
	/*
	if (takis.nocontrol and takis.taunttime)
	and (takis.tauntid ~= 6)
		v.drawScaled(x - 3*FU, y+disp, (FU), v.cachePatch("TA_BUTTONBG"), flags|V_HUDTRANSHALF)
		v.drawScaled(x,
			y+disp,
			(FU/2),
			v.cachePatch("TB_C1"),
			flags|V_HUDTRANS
		)
		v.drawString(x+20*FU,
			y+disp+5*FU,
			"Cancel Taunt",
			V_ALLOWLOWERCASE|flags|V_HUDTRANS,
			"thin-fixed"
		)
	end
	*/
	
end

local function drawemeralds(v,emeraldpics,x,y,scale,f,pemeralds)
	--epic source :iwantsummadat:
	-- https://github.com/STJr/SRB2/blob/master/src/hu_stuff.c#L2754
	
	if (pemeralds & EMERALD1)
		v.drawScaled(x  , y-6*FU, scale, emeraldpics[0], f);
	end
	
	if (pemeralds & EMERALD2)
		v.drawScaled(x+4*FU, y-3*FU, scale, emeraldpics[1], f);
	end

	if (pemeralds & EMERALD3)
		v.drawScaled(x+4*FU, y+3*FU, scale, emeraldpics[2], f);
	end

	if (pemeralds & EMERALD4)
		v.drawScaled(x  , y+6*FU, scale, emeraldpics[3], f);
	end

	if (pemeralds & EMERALD5)
		v.drawScaled(x-4*FU, y+3*FU, scale, emeraldpics[4], f);
	end

	if (pemeralds & EMERALD6)
		v.drawScaled(x-4*FU, y-3*FU, scale, emeraldpics[5], f);
	end

	if (pemeralds & EMERALD7)
		v.drawScaled(x  , y  , scale, emeraldpics[6], f);	
	end
	
end

--ordinal numbers
local placetext = {
	[1] = ",",
	[2] = ":",
	[3] = "!",
	
	[21] = ",",
	[22] = ":",
	[23] = "!",
	
	[31] = ",",
	[32] = ":",
	[33] = "!",
}

local placetext2 = {
	[","] = "ST",
	[":"] = "ND",
	["!"] = "RD",
	["?"] = "TH",
}

local placestring = {
	[0] = '',
	[1] = "P",	--gold font
	[2] = "S",	--silver font
	[3] = "B",	--bronze font
}

local function isplayerlosing(p)
	local winningpos = 1
	local pcount = 0
	local takis = p.takistable
	
	if takis.placement == 1
		return false
	end
	
	for player in players.iterate
		if (player.spectator)
			continue
		end
		if not player.takistable
			continue
		end
		if player.takistable.placement > pcount
			pcount = player.takistable.placement
		end
	end
	
	if pcount <= 1
		return false
	end
	
	winningpos = pcount/2
	if (pcount % 2)
		winningpos = $+1
	end
	
	return (takis.placement > winningpos)
	
end

--i guess we could put placements here in match
local function drawlivesarea(v,p)

	if (customhud.CheckType("lives") != modname) return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
	or p.takistable.inSRBZ
	--or (p.textBoxInAction)
	or (TAKIS_DEBUGFLAG & (DEBUG_SPEEDOMETER|DEBUG_BUTTONS))
	or p.takistable.hhexiting
	or (p.takis_noabil ~= nil
	and mapheaderinfo[gamemap].takis_tutorialmap ~= nil)
		return
	end
	
	local me = p.mo
	local takis = p.takistable
	
	local x = takis.HUD.lives.tweenx
	local y = 190*FU - textboxmoveup
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
	local contpatch = v.getSprite2Patch(p.skin,SPR2_XTRA,false,C,0,0)
	local nolivestext = false
	
	if (circredux and circuitmap)
		y = $ - 20*FU
	end
	
	setinterp(v,true)
	drawlivesbutton(v,p,15*FU,y-20*FU,flags)
	setinterp(v,false)
	
	if (p.inkart and not p.takistable.HUD.lives.nokarthud) then return end
	
	if not (p.skincolor)
	or modeattacking
		return
	end
	
	local infinite = false
	
	if (G_GametypeUsesLives())
		if CV_FindVar("cooplives").value == 0
			infinite = true
		end
	elseif (G_PlatformGametype() and not (gametyperules & GTR_LIVES))
		infinite = true
	elseif G_RingSlingerGametype() and not (gametyperules & GTR_FRIENDLY)
		infinite = true
	else
		nolivestext = true
	end
	
	
	if takis.isSinglePlayer
		if p.lives ~= INFLIVES
			infinite = false
		else
			infinite = true
		end
	end
	
	if infinite then nolivestext = true end
	
	local colorized = false
	if (p.spectator)
	or (p.ctfteam == 1 or p.ctfteam == 2)
	and G_GametypeHasTeams()
		colorized = true
		nolivestext = true
	end
	
	local color = v.getColormap((colorized) and TC_RAINBOW or nil,(p.spectator) and SKINCOLOR_CLOUDY or p.skincolor)
	local textmap = getnamemap(takis.HUD.hudname)
	
	--this is juuust wide enough to peak out from the side
	if takis.HUD.lives.tweentic
		drawblackbox(v,
			x - 3*FU,
			y - 24*FU,
			58*FU,31*FU,
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANSHALF
		)
		/*
		v.drawScaled(x,y,FU,v.cachePatch("TA_LIVESBACK"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANSHALF
		)
		*/
		
		if TAKIS_ISDEBUG
			local longestw = max(
				v.stringWidth(modversion,0,"thin"),
				v.stringWidth(builddate,0,"thin")
			)
			longestw = $ + 6
			
			drawblackbox(v,
				323*FU - x - longestw*FU,
				y - 20*FU,
				longestw*FU,
				24*FU,
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF|V_SNAPTOLEFT))|V_HUDTRANSHALF|V_SNAPTORIGHT
			)
			v.drawString(320*FU - x,y-8*FU,
				modversion,
				(flags &~(V_SNAPTOLEFT))|V_ALLOWLOWERCASE|V_SNAPTORIGHT|V_HUDTRANS,
				"thin-fixed-right"
			)
			v.drawString(320*FU - x,y-16*FU,
				builddate,
				(flags &~(V_SNAPTOLEFT))|V_ALLOWLOWERCASE|V_SNAPTORIGHT|V_HUDTRANS,
				"thin-fixed-right"
			)
		end
	end
	
	if p.spectator
		flags = $|V_HUDTRANSHALF
		textmap = V_GRAYMAP
	else
		flags = $|V_HUDTRANS
		if G_GametypeHasTeams()
			if p.ctfteam == 1
				textmap = V_REDMAP
			elseif p.ctfteam == 2
				textmap = V_BLUEMAP
			end
			
			v.drawString(x+52*FU,
				y-8*FU,
				(p.ctfteam == 1) and "red" or "blu",
				flags|((p.ctfteam == 1) and V_REDMAP or V_BLUEMAP),
				"fixed-right"
			)
	
		elseif (gametyperules & GTR_TAG)
			if (p.pflags & PF_TAGIT)
				v.drawString(x+52*FU,
					y-8*FU,
					"it!",
					flags,
					"fixed-right"
				)
				textmap = V_ORANGEMAP
			end
			nolivestext = true
		end
	end
	
	local cont = {
		scale = FU,
		xoff = 10*FU,
		yoff = 0,
	}
	if not contpatch
		contpatch = v.getSprite2Patch(p.skin,SPR2_XTRA,false,A,0,0)
		cont.scale = FU/2
		cont.yoff = -16*FU
		cont.xoff = 0
	end
	if contpatch == v.getSprite2Patch(p.skin, SPR2_STND)
		contpatch = v.cachePatch("CHARICO")
	end
	
	if contpatch
		v.drawScaled(x+cont.xoff,
			y+cont.yoff,
			cont.scale,
			contpatch,
			flags,color
		)
	end
	cont = nil
	
	if not nolivestext
		local lives = takis.oldlives
		
		/*
		if CV_FindVar("cooplives").value == 3
		and (netgame or multiplayer)
			lives = TAKIS_MISC.livescount
		end
		*/
		
		local scorenum = "CMBCF"
		if lives >= 99
			scorenum = "CMBCFP"
		end
		local score = lives
		local scale = FU
		
		local prevw
		if not prevw then prevw = 0 end
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*scale*4/10)		
		end
		
		for i = 1,string.len(score)
			local sc = FixedDiv(scale,2*FU)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			--local textwidth = (patch.width*scale*4/10)
			v.drawScaled(x+prevw-textwidth+50*FU,
				y-(patch.height*sc)+6*FU-(FU/2)-takis.HUD.lives.bump,
				sc,
				patch,
				flags
			)
				
			prevw = $+(patch.width*scale*4/10)
		end
	else
		--match placements
		if takis.HUD.lives.useplacements
		and not (p.spectator or G_GametypeHasTeams())
			local top3 = takis.placement and takis.placement < 4
			local inlosingplace = isplayerlosing(p)
			local losing = inlosingplace and (leveltime/4 & 1)
			local scorenum = "CMBCF"
			local score = takis.placement
			score = $..(placetext[takis.placement] or "?")
			local scale = FU
			
			if (gametyperules & GTR_RACE)
			and circuitmap
				local maxlaps = CV_FindVar("numlaps").value
				if p.laps == maxlaps-1 
				or (p.pflags & PF_FINISHED)
				or (p.exiting)
					scorenum = (top3 and not inlosingplace) and "CMBCF"..placestring[takis.placement] or (losing and "CMBCFR" or "CMBCF")
				end
			else
				scorenum = (top3 and not inlosingplace) and "CMBCF"..placestring[takis.placement] or (losing and "CMBCFR" or "CMBCF")
			end
			
			local prevw
			if not prevw then prevw = 0 end
			
			local textwidth = 0
			for i = 1,string.len(score)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				if placetext2[n] ~= nil
					patch = v.cachePatch(scorenum..placetext2[n])
				end
				textwidth = $+(patch.width*scale*4/10)		
			end
			
			for i = 1,string.len(score)
				local sc = FixedDiv(scale,2*FU)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				if placetext2[n] ~= nil
					patch = v.cachePatch(scorenum..placetext2[n])
				end
				v.drawScaled(x+prevw-textwidth+50*FU,
					y-(patch.height*sc)+6*FU-(FU/2)-takis.HUD.lives.bump,
					sc,
					patch,
					flags
				)
					
				prevw = $+(patch.width*scale*4/10)
			end
		end
	end
	
	v.drawString(x+52*FU,
		y-18*FU,
		string.sub(takis.HUD.hudname,1,7),
		flags|V_ALLOWLOWERCASE|textmap,
		"thin-fixed-right"
	)
	
	local disp = 0
	buttonmoveup = false
	
	--powerstones
	if (gametyperules & GTR_POWERSTONES)
	and (CV_FindVar("powerstones").value)
		disp = 15*FU
		
		local emeraldpics = {
			[0] = v.cachePatch("TEMER1"),
			[1] = v.cachePatch("TEMER2"),
			[2] = v.cachePatch("TEMER3"),
			[3] = v.cachePatch("TEMER4"),
			[4] = v.cachePatch("TEMER5"),
			[5] = v.cachePatch("TEMER6"),
			[6] = v.cachePatch("TEMER7"),
		}
		
		local stop
		if (leveltime & 1)
		and p.powers[pw_invulnerability]
		and (p.powers[pw_sneakers] ==
		p.powers[pw_invulnerability])
			drawemeralds(v,
				emeraldpics,
				x+63*FU,
				y-10*FU,
				FU/2,
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
				127		--allemeralds
			)		
			stop = true
		end
		
		if not stop
			drawemeralds(v,
				emeraldpics,
				x+63*FU,
				y-10*FU,
				FU/2,
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
				p.powers[pw_emeralds]
			)
		end
	end
	
	if takis.HUD.rthh.sptic
		local tic = takis.HUD.rthh.sptic
		local tween = 0
		
		local et = TR/2
		if tic >= 2*TR+et
			local tics = (3*TR)-takis.HUD.rthh.sptic
			tween = ease.outback((FU/et)*tics,40*FU,0,FU*3/2)
		elseif tic <= et
			local tics = et-takis.HUD.rthh.sptic
			tween = ease.inexpo((FU/et)*tics,0,40*FU)
		end
		
		v.drawString(
			x+60*FU,
			y-20*FU+tween,
			"Checkpoint!",
			V_YELLOWMAP|(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS|V_ALLOWLOWERCASE),
			"thin-fixed"
		)
		local frame = (5*leveltime/6)%14
		local patch = v.cachePatch("TAHHS"..frame)
		v.drawScaled(x+60*FU+((v.stringWidth("Checkpoint!",0,"thin"))*FU/2)-(v.cachePatch("TAHHS0").width*FU/4),
			y-10*FU+tween,
			FU/2,
			patch,
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
		)
		disp = $+55*FU
	end
	
	if (p.ptsr)
	and (me and me.valid and me.pfstuntime)
	and p.ptsr.pizzaface
		v.drawScaled(
			x+60*FU+disp,
			y-24*FU,
			FU,
			v.cachePatch("TA_ICE2"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
		)
		
		local stunmax = CV_PTSR.pizzatimestun.value*TR
		local stuntime = me.pfstuntime
		local tics = L_FixedDecimal(FixedDiv(stuntime*FU,TR*FU),1)
		
		local erm = FixedDiv(stuntime*FU,stunmax*FU)
		local height = v.cachePatch("TA_ICE").height*FU - FixedMul(erm,v.cachePatch("TA_ICE").height*FU)
		if height < 0 then
			height = 0
		end
		
		v.drawCropped(
			x+60*FU+disp,
			y-24*FU+height,
			FU,FU,
			v.cachePatch("TA_ICE"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS,
			nil,
			0,height,
			v.cachePatch("TA_ICE").width*FU,
			v.cachePatch("TA_ICE").height*FU
		)
		
		v.drawString(x+60*FU+disp+(v.cachePatch("TA_ICE").width*FU/2),
			y-27*FU+(v.cachePatch("TA_ICE").height*FU/2),
			tics,
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS|V_YELLOWMAP,
			"thin-fixed-center"
		)
		
		disp = $+30*FU
		
	end
	
	if takis.io.savestate ~= 0
		local state = "IDLE"
		if takis.io.savestate == 2
			state = "GOOD"
		elseif takis.io.savestate == 3
			state = "BAD"
		elseif takis.io.savestate == 4
			state = "WARN"
		end
		
		v.drawScaled(
			x+70*FU+disp,
			y-8*FU,
			FU,
			v.cachePatch("TA_SAVE_"..state),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
		)
		
		if not takis.io.loaded
		and takis.io.loadtries > 1
			local scorenum = (leveltime/4) % 2 and "CMBCF" or "CMBCFR"
			local score = takis.io.loadtries
			local scale = FU
			
			local prevw
			if not prevw then prevw = 0 end
			
			local textwidth = 0
			for i = 1,string.len(score)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				textwidth = $+(patch.width*scale*4/10)		
			end
			
			for i = 1,string.len(score)
				local sc = FixedDiv(scale,2*FU)
				local n = string.sub(score,i,i)
				local patch = v.cachePatch(scorenum+n)
				--local textwidth = (patch.width*scale*4/10)
				v.drawScaled(x+prevw-textwidth+80*FU+disp,
					y-(patch.height*sc)+5*FU,
					sc,
					patch,
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS
				)
					
				prevw = $+(patch.width*scale*4/10)
			end
		end
		
		disp = $+30*FU
	end
	
	if All7Emeralds(emeralds)
		if not takis.kart.paidforkart
			if (takis.kart.ringspaid)
				v.drawScaled(
					x+75*FU+disp,
					y-10*FU,
					FU/2,
					v.cachePatch("TKRTB8"),
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS,
					v.getColormap(nil,p.skincolor)
				)
				v.drawString(
					x+75*FU+disp,
					y-10*FU,
					"\x82"..(50-takis.kart.ringspaid).."\x80 rings",
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS|V_ALLOWLOWERCASE,
					"thin-fixed-center"
				)
				v.drawString(
					x+75*FU+disp,
					y-2*FU,
					"left",
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS|V_ALLOWLOWERCASE,
					"thin-fixed-center"
				)
				buttonmoveup = true
				disp = $+30*FU
			elseif (p.rings >= 50)
				v.drawScaled(
					x+75*FU+disp,
					y-18*FU,
					FU/2,
					v.cachePatch("TKRTB8"),
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS,
					v.getColormap(nil,p.skincolor)
				)
				v.drawString(
					x+75*FU+disp,
					y-18*FU,
					"(hold)",
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|(p.panim == PA_IDLE and V_HUDTRANS or V_HUDTRANSHALF)|V_ALLOWLOWERCASE,
					"thin-fixed-center"
				)
				v.drawString(
					x+75*FU+disp,
					y-10*FU,
					"C3 to buy",
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|(p.panim == PA_IDLE and V_HUDTRANS or V_HUDTRANSHALF)|V_ALLOWLOWERCASE,
					"thin-fixed-center"
				)
				v.drawString(
					x+75*FU+disp,
					y-2*FU,
					"kart",
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|(p.panim == PA_IDLE and V_HUDTRANS or V_HUDTRANSHALF)|V_ALLOWLOWERCASE,
					"thin-fixed-center"
				)
				buttonmoveup = true
				disp = $+30*FU			
			end
		elseif (not p.inkart and (takis.kart.mobj and takis.kart.mobj.valid))
			v.drawScaled(
				x+75*FU+disp,
				y-10*FU,
				FU/2,
				v.cachePatch("TKRTB8"),
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS,
				v.getColormap(nil,p.skincolor)
			)
			if takis.c3
				local string = (min(FU,FixedDiv(takis.c3*FU,TR*FU))*100)/FU.."%"
				v.drawString(
					x+75*FU+disp,
					y-18*FU,
					string,
					(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS|V_YELLOWMAP,
					"thin-fixed-center"
				)
			end
			v.drawString(
				x+75*FU+disp,
				y-10*FU,
				"C3 to",
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS|V_ALLOWLOWERCASE,
				"thin-fixed-center"
			)
			v.drawString(
				x+75*FU+disp,
				y-2*FU,
				"recall",
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF))|V_HUDTRANS|V_ALLOWLOWERCASE,
				"thin-fixed-center"
			)
			buttonmoveup = true
			disp = $+30*FU
		end
	end
	
	--lives fill
	if (takis.firenormal)
	--?
	--and not (takis.HUD.lives.tweentic)
		local openingmenu = false
		if (takis.c2 or takis.c3) then openingmenu = true end
		
		local fn = min(takis.firenormal,TR)
		local c2 = min(takis.c2,TR)
		local c3 = min(takis.c3,TR)
		
		local timetic = FixedDiv(fn*FU,TR*FU)
		
		if openingmenu
			timetic = FixedDiv(
				(fn*FU)+(c2*FU)+(c3*FU),
				3*TR*FU
			)
		end
		
		local percent = FixedMul(100*FU,timetic)
		
		local pre = "TA_LIVESFILL_"
		/*
		local erm = FixedDiv(percent,100*FU)
		local height = v.cachePatch(pre.."FILL").height*FU - FixedMul(erm,v.cachePatch(pre.."FILL").height*FU)
		if height < 0 then
			height = 0
		end
		*/
		local scale = FU
		
		--back
		v.drawScaled(x+80*FU+disp,y-10*FU,scale,
			v.cachePatch(pre.."BACK"),
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANSHALF)
		)		
		
		local maxsegs = 50
		local fx,fy = x+80*FU+disp,y-10*FU
		for i = 0,maxsegs,1
			if timetic == 0 then break end
			
			local angmath = 
			FixedMul(
				FixedDiv(
					FixedMul(360*FU,timetic),
					maxsegs*FU
				),
				i*FU
			)-90*FU
			local angle = FixedAngle(angmath)
			v.drawScaled(
				fx+(9*cos(angle)),
				fy+(9*sin(angle)),
				FU/2,
				v.cachePatch(pre.."BALL"),
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
				v.getColormap(0,openingmenu and SKINCOLOR_GREEN or SKINCOLOR_WHITE)
			)
		end
		
		/*
		v.drawCropped(x+80*FU+disp,y-10*FU+FixedMul(height,SKINCOLOR_WHITEscale),scale,scale,
			v.cachePatch(pre.."FILL"),
			V_ADD|(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANSHALF), 
			v.getColormap(0,openingmenu and SKINCOLOR_GREEN or SKINCOLOR_WHITE),
			0,height,
			v.cachePatch(pre.."FILL").width*FU,
			v.cachePatch(pre.."FILL").height*FU
		)
		*/
		
		local string = L_FixedDecimal(percent,1).."%"
		v.drawString(
			x+80*FU+disp,
			y-13*FU,
			string,
			(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS),
			"thin-fixed-center"
		)
		
		local showing = takis.HUD.lives.tweentic > 0
		if (5*TR)-takis.HUD.lives.tweentic > 4*TR+(TR/2)
			showing = false
		end
		
		if not (showing and not openingmenu)
			v.drawString(
				x+95*FU+disp,
				y-13*FU,
				openingmenu and (modeattacking and "Menu disabled" or "Open menu") or "Show lives",
				(flags &~(V_HUDTRANS|V_HUDTRANSHALF)|V_HUDTRANS|V_ALLOWLOWERCASE),
				"thin-fixed"
			)		
		end
		
		disp = $+30*FU
	end
	
	buttonmoveup = disp ~= 0
end

--      ----------

--CLUTCH----------

local function drawclutches(v,p,cam)

	if (customhud.CheckType("takis_clutchstuff") != modname) return end
	
	/*
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	*/
	
	local takis = p.takistable
	local me = p.mo
	
	if (takis.io.clutchstyle == 0)
		local y = hudinfo[HUD_LIVES].y*FU
		
		if takis.HUD.lives.tweentic
			local et = TR/2
			local tic = (5*TR)-takis.HUD.lives.tweentic
			local low = hudinfo[HUD_LIVES].y*FU
			local high = hudinfo[HUD_LIVES].y*FU-35*FU
			
			if tic <= TR/2
				y = ease.outback((FU/et)*tic,low, high, FU*3/2)
			elseif tic >= 4*TR+TR/2
				y = ease.inquad((FU/et)*((4*TR+TR/2)-tic), high, low)
			else
				y = high
			end
			
		end
		if (modeattacking)
			if p.pflags & PF_AUTOBRAKE
				y = $-10*FU
			else
				y = $-5*FU
			end
		end
		if ((takis.firenormal)
		and not takis.HUD.lives.tweentic)
		or (takis.HUD.rthh.sptic)
			y = $-35*FU
		end
	
		if takis.clutchtime > 0
			local barx = hudinfo[HUD_LIVES].x*FU
			local bary = y+20*FU
			local color = SKINCOLOR_CRIMSON
			local pre = "CLTCHBAR_"
			
			local clutchadjust = takis.clutchtime --max(takis.clutchtime - p.cmd.latency,0)
			
			if (clutchadjust <= 11)
			and (clutchadjust > 0)
				color = SKINCOLOR_GREEN
			end
			
			
			v.drawScaled(barx, bary, FU, v.cachePatch(pre.."BACK"),
				V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
			)
			
			local max = 23*FU
			--local timer = (23-clutchadjust)*FU
			local timer2 = (23-takis.clutchtime)*FU
			local scale = FU
			
			local erm = FixedDiv((timer2),max)
			local width = FixedMul(erm,v.cachePatch(pre.."FILL").width*FU)
			if width < 0 then
				width = 0
			end
			/*
			v.drawCropped(barx,bary,scale,scale,
				v.cachePatch(pre.."FILL"),
				V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANSHALF|V_PERPLAYER, 
				v.getColormap(nil,SKINCOLOR_YELLOW),
				0,0,
				width,v.cachePatch(pre.."FILL").height*FU
			)
			
			erm = FixedDiv((timer),max)
			width = FixedMul(erm,v.cachePatch(pre.."FILL").width*FU)
			if width < 0 then
				width = 0
			end
			*/
			v.drawCropped(barx,bary,scale,scale,
				v.cachePatch(pre.."FILL"),
				V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER, 
				v.getColormap(nil,color),
				0,0,
				width,v.cachePatch(pre.."FILL").height*FU
			)
			
			v.drawScaled(barx, bary, FU, v.cachePatch(pre.."MARK"),
				V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
			)
		end
		--clutch combo
		if takis.clutchcombo
			
			v.drawString(hudinfo[HUD_LIVES].x*FU,
				y+10*FU,
				takis.clutchcombo.."x BOOSTS",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,
				"fixed"
			)
			
		end
	elseif (takis.io.clutchstyle == 1)
		--chrispy chars
		local player = p
		local mo = player.realmo
		local color = SKINCOLOR_CRIMSON
		local pre = "CLTCHMET_"
		
		--no need to draw any of this if no relevant values are being used
		if takis.clutchcombo == 0
		and takis.clutchspamcount == 0
		and takis.clutchtime == 0
			return
		end
		
		if (takis.clutchtime <= 11)
		and (takis.clutchtime > 0)
			color = SKINCOLOR_GREEN
		end
		
		local flip = 1
		local bubble = v.cachePatch(pre.."BACK")
		local angdiff = ANGLE_90
		local x, y, scale, nodraw
		local cutoff = function(y) return false end
		
		if cam.chase and not (player.awayviewtics and not takis.in2D)
			x, y, scale, nodraw = R_GetScreenCoords(v, player, cam, mo)
			if nodraw then return end
			
			scale = $*2
			if mo.eflags & MFE_VERTICALFLIP
			and player.pflags & PF_FLIPCAM
				y = 200*FRACUNIT - $
			else
				flip = P_MobjFlip(mo)
			end
			scale = FixedMul($,mo.scale)
		else
			x, y, scale = 160*FRACUNIT, (100 + bubble.height >> 1)*FRACUNIT, FRACUNIT
		end
		
		scale = min($,FU)
		
		if splitscreen
			if player == secondarydisplayplayer
				cutoff = function(y) return y < (bubble.height*scale >> 1) end
			else
				cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
			end
		end
		
		local angle = angdiff + ANGLE_90
		local x = x - P_ReturnThrustX(nil, angle, 40*scale)
		local y = y - flip*P_ReturnThrustY(nil, angle, 70*scale)
			
		if not cutoff(y)
			if takis.clutchcombo
				v.drawString(x,y,
					"x"..takis.clutchcombo,
					V_PERPLAYER|V_HUDTRANS|V_ALLOWLOWERCASE,
					"fixed"
				)
				v.drawString(x,y+(8*FU),
					"boosts",
					V_PERPLAYER|V_HUDTRANS,
					"thin-fixed"
				)
			end
			if (takis.clutchspamcount)
			and not (takis.clutchcombo)
				if (takis.clutchspamcount >= 3)
				and (takis.clutchspamcount < 7)
					v.drawString(x,y,
						"don't",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)			
					v.drawString(x,y+8*FU,
						"spam",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)
				elseif (takis.clutchspamcount >= 7)
					v.drawString(x,y,
						"clutch on",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)			
					v.drawString(x,y+8*FU,
						"green",
						V_PERPLAYER|V_HUDTRANS,
						"thin-fixed"
					)				
				end
			end
			
			if takis.clutchtime > 0
				v.drawScaled(x, y, scale, bubble, V_PERPLAYER|V_HUDTRANS)
				
				local max = 23*FU
				--local timer = ((23-takis.clutchtime) - p.cmd.latency)*FU
				local timer2 = (23-takis.clutchtime)*FU
				
				--this yellow one is what your timer WOULDVE been!
				--dont clutch with this one!
				local erm = FixedDiv((timer2),max)
				local width = v.cachePatch(pre.."FILL").height*FU-FixedMul(erm,v.cachePatch(pre.."FILL").height*FU)
				if width < 0 then
					width = 0
				end
				
				/*
				v.drawCropped(x,y+FixedMul(width,scale),scale,scale,
					v.cachePatch(pre.."FILL"),
					V_PERPLAYER|V_HUDTRANSHALF, 
					v.getColormap(nil,SKINCOLOR_YELLOW),
					0,width,
					v.cachePatch(pre.."FILL").width*FU,v.cachePatch(pre.."FILL").height*FU
				)
				
				--this green one is corrected according to the ammount of ping you have
				--DO clutch with this one!
				erm = FixedDiv((timer),max)
				width = v.cachePatch(pre.."FILL").height*FU-FixedMul(erm,v.cachePatch(pre.."FILL").height*FU)
				if width < 0 then
					width = 0
				end
				*/
				
				v.drawCropped(x,y+FixedMul(width,scale),scale,scale,
					v.cachePatch(pre.."FILL"),
					V_PERPLAYER|V_HUDTRANS, 
					v.getColormap(nil,color),
					0,width,
					v.cachePatch(pre.."FILL").width*FU,v.cachePatch(pre.."FILL").height*FU
				)
				
				v.drawScaled(x, y, scale, v.cachePatch(pre.."MARK"), V_PERPLAYER|V_HUDTRANS)
			end
		end
	end
	
end

--      ----------

local function drawnadocount(v,p,cam)

	if (customhud.CheckType("takis_nadocount") != modname) return end
	
	local takis = p.takistable
	local me = p.mo
	
	if not takis then return end 
	
	if not (takis.transfo & TRANSFO_TORNADO)
	or not takis.nadocount
		return
	end
	
	--chrispy chars
	local player = p
	local mo = player.realmo
	
	local flip = 1
	local bubble = v.cachePatch("CMBCF"..takis.nadocount)
	local angdiff = ANGLE_90
	local x, y, scale, nodraw
	local cutoff = function(y) return false end
	
	if cam.chase and not (player.awayviewtics and not takis.in2D)
		x, y, scale, nodraw = R_GetScreenCoords(v, player, cam, mo)
		if nodraw then return end
		
		scale = $*2
		if mo.eflags & MFE_VERTICALFLIP
		and player.pflags & PF_FLIPCAM
			y = 200*FRACUNIT - $
		else
			flip = P_MobjFlip(mo)
		end
	else
		scale = FU
		x = (160*FU)
		y = 100*FU
	end
	
	if splitscreen
		if player == secondarydisplayplayer
			cutoff = function(y) return y < (bubble.height*scale >> 1) end
		else
			cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
		end
	end
	
	local angle = angdiff + ANGLE_90
	local x = x - P_ReturnThrustX(nil, angle, -(bubble.width*scale)/2)
	y = $+flip*(-50*scale)
	if not cutoff(y)
		v.drawScaled(x, y, scale, bubble, V_PERPLAYER|V_HUDTRANS)
	end

end

--COMBO ----------

local function drawmincombo(v,p,maxtime)
	local takis = p.takistable
	local me = p.mo
	
	if takis.combo.count
	or takis.combo.outrotics
		local pre = "MINCBAR_"
		
		local backx = (takis.HUD.combo.x)-3*FU
		local backy = takis.HUD.combo.y-9*FU
		local combonum = takis.combo.count
		if (takis.combo.outrotics)
			combonum = takis.combo.failcount
		end
		local max = maxtime*FU or 1
		local erm = FixedDiv((takis.HUD.combo.fillnum),max)
		local width = FixedMul(erm,v.cachePatch(pre.."FILL").width*FU)
		if width < 0 then
			width = 0
		end
		local scale = FU/2
		
		if me.flags & MF_NOTHINK
			backy = $+((leveltime % 4) < 2 and FU or -FU) 
		end
		
		v.drawScaled(backx,
			backy,
			scale*2,
			v.cachePatch(pre.."BAR2"),
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANSHALF|V_PERPLAYER
		)
		
		v.drawScaled(backx+3*FU, backy+9*FU, scale, v.cachePatch(pre.."BACK"),
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
		)
		
		
		local color
		if takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/4
			color = SKINCOLOR_RED
		elseif takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU/2
			color = SKINCOLOR_ORANGE
		elseif takis.HUD.combo.fillnum <= TAKIS_MAX_COMBOTIME*FU*3/4
			color = SKINCOLOR_YELLOW
		end
		if (takis.combo.frozen)
			color = SKINCOLOR_ICY
			
			if (p.powers[pw_invulnerability] >= 3*TR)
				color = SKINCOLOR_SUPERSPARK
			end
		end
		
		v.drawCropped(backx+3*FU,backy+9*FU,scale,scale,
			v.cachePatch(pre.."FILL"),
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER, 
			v.getColormap(nil,color),
			0,0,
			width,v.cachePatch(pre.."FILL").height*FU
		)
		
		local scorenum = "CMBCF"
		local combonum = takis.combo.count
		if (takis.combo.outrotics)
			combonum = takis.combo.failcount
		end
		local score = combonum
		
		local prevw = 0
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*FU*4/10)		
		end
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			v.drawScaled(backx+prevw-textwidth+89*FU,
				backy,
				scale,
				patch,
				V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER
			)
				
			prevw = $+(patch.width*FU*4/10)
		end
		/*
		v.drawString(backx-(v.cachePatch(pre.."FILL").width*scale)-FU*2,
			backy-3*FU,
			takis.combo.count.."x",
			V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,
			"thin-fixed-right"
		)
		*/
		
		if not takis.combo.outrotics
			local length = #TAKIS_COMBO_RANKS
			v.drawString(backx+3*FU,
				backy+14*FU,
				TAKIS_COMBO_RANKS[ ((takis.combo.rank-1) % length)+1 ],
				V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
			if takis.combo.score ~= "dontdraw"
				v.drawString(backx+3*FU,
					backy+FU,
					"+"..takis.combo.score,
					V_SNAPTOTOP|V_SNAPTOLEFT|V_HUDTRANS|V_PERPLAYER|V_ALLOWLOWERCASE
					|(((takis.HUD.combo.penaltyshake and (leveltime/2 % 2))) and V_REDMAP or 0),
					"thin-fixed"
				)
			end
		end

	end

	if takis.combo.awardable
	and not takis.combo.dropped
		--takis.combo.awardable = true
		
		local patch = v.cachePatch("FCTOKEN")
		
		local fs = takis.HUD.flyingscore
		local x = hfs.scorex*FU-(patch.width*FU/3)
		local y = (hfs.scorey+15)*FU
		
		if (p.ptsr and p.ptsr.rank)
		and HAPPY_HOUR.othergt
			x = $-20*FU
		end
		local grow = takis.HUD.combo.tokengrow
		
		v.drawScaled(x-(grow*25),y-(grow*20),FU/3+grow,
			patch,
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
			v.getColormap(nil, p.skincolor)
		)
	end
	
	--this is so um jammer lammy
	for k,va in pairs(takis.HUD.comboshare)
		if not va.tics then continue end
		
		local total_width = (v.width() / v.dupx()) + 1
		local total_height = (v.height() / v.dupy()) + 1
		
		
		local x,y = va.x,va.y
		
		if va.tics <= TR/2
			--THANKS SAXA FOR HELPIN ME WITH THE COORDS!!
			local pre = "MINCBAR_"
			local et = TR/2
			local tics = et-va.tics
			
			local ypos = ((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey
			local xpos = 160*FU-(total_width*FU/2)
			
			if takis.combo.time
				xpos = $+(v.cachePatch(pre.."FILL").width*FU/2)
			end
			
			y = ease.outback(
				(FU/et)*tics,
				va.starty,
				ypos,
				FU*4
			)
			x = ease.insine(
				(FU/et)*tics,
				va.startx,
				xpos,
				FU
			)
			
		end
		
		local waveforce = FU*3
		local ay = FixedMul(waveforce,sin(FixedAngle(leveltime*20*FU)))
		if va.tics <= TR/2
			ay = 0
		end
		
		local cpatch = v.cachePatch("TAKCOSHARE")
		local color = v.getColormap(nil,
			(leveltime/2 % 2) and SKINCOLOR_GREEN
			or SKINCOLOR_RED
		)
		local xoff = -7*FU
		v.drawScaled(x+8*FU-xoff,y+ay,FU,cpatch,0,color)
		v.drawString(x+8*FU-xoff,y+ay,"+"..va.comboadd,0,"fixed-right")
	end
	
end

local function drawcombostuff(v,p,cam)

	if (customhud.CheckType("takis_combometer") != modname) return end
	
	if (TAKIS_DEBUGFLAG & DEBUG_BOSSCARD) then return end
	
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	local maxtime = TAKIS_MAX_COMBOTIME
	if (p.ptsr)
	and (HAPPY_HOUR.othergt)
		maxtime = p.ptsr.combo_maxtime
		takis.combo.time = p.ptsr.combo_timeleft
	end

	if doihaveminhud
		setinterp(v,true)
		drawmincombo(v,p,maxtime)
		setinterp(v,false)
		return
	end
	
	setinterp(v,true)
	if (takis.combo.failtics)
		local meter = v.cachePatch("TAKCOBACK")
		local offy = 0
		if (takis.combo.count)
			offy = meter.height*FU+5*FU
		end
		
		v.drawString(15*FU+(meter.width*FU/2),
			takis.HUD.combo.basey+offy,
			"That combo was",
			V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
			"thin-fixed-center"
		)
		local length = #TAKIS_COMBO_RANKS
		local xs,ys = happyshakelol(v)
		xs,ys = $1/3,$2/3
		v.drawString(15*FU+(meter.width*FU/2)+xs,
			takis.HUD.combo.basey+15*FU+ys+offy,
			TAKIS_COMBO_RANKS[ ((takis.combo.failrank-1) % length)+1 ],
			V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
			"thin-fixed-center"
		)
		
		local score = takis.combo.failcount
		local prevw = 0
		local scorenum = "CMBCF"
		local fontwidth = 0
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			fontwidth = $+v.cachePatch(scorenum+n).width*4/10
		end
		fontwidth = $*FU
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			v.drawScaled(15*FU+(meter.width*FU/2)+(prevw*FU)-(fontwidth/2),
				(takis.HUD.combo.basey+25*FU+offy),--(v.cachePatch(scorenum+n).height*FixedDiv(scale-FU,4*FU)),
				FU/2,
				v.cachePatch(scorenum+n),
				V_HUDTRANS|	V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
			)
				
			prevw = $+v.cachePatch(scorenum+n).width*4/10
		end
		
		local verys = takis.combo.failcount/(#TAKIS_COMBO_RANKS*TAKIS_COMBO_UP)
		if verys > 0
			local verypatch = v.cachePatch("TAKCOVERY")
			
			v.drawScaled(15*FU+((verypatch.width*FU/3)/2),
				takis.HUD.combo.basey+offy+12*FU,
				FU/3,
				verypatch,
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
			)
			
			if verys > 1
				v.drawString(15*FU+((verypatch.width*FU/3)/2),
					takis.HUD.combo.basey+offy+15*FU,
					"x"..verys,
					V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
					"thin-fixed-center"
				)
			end
			
		end
	end
	
	if takis.combo.count
	or takis.combo.outrotics
		local slide = 0
		if (takis.combo.slidetime)
			slide = takis.combo.slidein
		end
		local comboscale = takis.HUD.combo.scale+FU
		local shake = -FixedMul(takis.HUD.combo.shake,comboscale)
		local backx = (takis.HUD.combo.x)+slide
		local backy = takis.HUD.combo.y + shake
		if (takis.combo.outrotointro)
			backy = takis.HUD.combo.y+shake---takis.combo.outrotointro+shake
		end
		local combonum = takis.combo.count
		if (takis.combo.outrotics)
			combonum = takis.combo.failcount
		end
		
		if (me and me.valid)
		and me.flags & MF_NOTHINK
			backy = $+((leveltime % 4) < 2 and FU or -FU) 
		end
		
		/*
		if takis.HUD.combo.penaltyshake
			backx = $+((leveltime % 2) < 1 and takis.HUD.combo.penaltyshake*FU or -takis.HUD.combo.penaltyshake*FU)
		end
		*/
		
		/*
		if ((p.pflags & PF_FINISHED) and (netgame))
		and not p.exiting
			backy = $+(20*FU)
		end
		*/
		
		local max = maxtime*FU or 1
		local erm = FixedDiv((takis.HUD.combo.fillnum),max)
		local width = FixedMul(erm,v.cachePatch("TAKCOFILL").width*FU)
		local color
		if takis.HUD.combo.fillnum <= maxtime*FU/4
			color = SKINCOLOR_RED
		elseif takis.HUD.combo.fillnum <= maxtime*FU/2
			color = SKINCOLOR_ORANGE
		elseif takis.HUD.combo.fillnum <= maxtime*FU*3/4
			color = SKINCOLOR_YELLOW
		end
		if (takis.combo.frozen)
			color = SKINCOLOR_ICY
			
			if (p.powers[pw_invulnerability] >= 3*TR)
				color = SKINCOLOR_SUPERSPARK
			end
		end
		if width < 0 then
			width = 0
		end
		combopatchx = v.cachePatch("TAKCOFILL").width*FU/2
		
		v.drawCropped(backx,backy,comboscale,comboscale,
			v.cachePatch("TAKCOFILL"),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER, 
			v.getColormap(nil,color),
			0,0,
			width,v.cachePatch("TAKCOFILL").height*FU
		)
		
		v.drawScaled(backx,backy,comboscale,
			v.cachePatch("TAKCOBACK"),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
		)
		
		
		if not (takis.combo.outrotics)
			if p.ptsr
			and (HAPPY_HOUR.othergt)
				local prank_able = p.ptsr.combo_timesfailed == 0 and p.ptsr.combo_times_started == 1 
				if not prank_able
					v.drawString(backx+5*comboscale+(FixedMul(combopatchx,comboscale)),
						backy+6*comboscale+(v.cachePatch("TAKCOFILL").height*comboscale/2)-(7*comboscale/2),
						"no p-rank",
						V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
						"thin-fixed-center"
					)
				end
			end
			if takis.combo.score ~= "dontdraw"
				v.drawString(backx+5*comboscale+(FixedMul(combopatchx,comboscale)),
					backy+6*comboscale+(v.cachePatch("TAKCOFILL").height*comboscale/2)-(7*comboscale/2),
					takis.combo.score,
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
					|(((takis.HUD.combo.penaltyshake and (leveltime/2 % 2))) and V_REDMAP or 0),
					"thin-fixed-center"
				)
			end
		end
		
		/*
		if not (takis.combo.outrotics)
			TakisDrawPatchedText(v,
				backx+5*comboscale+(FixedMul(patchx,comboscale))-(v.stringWidth(tostring(takis.combo.score),0,"thin")*comboscale/2),
				backy+(7*comboscale),
				tostring(takis.combo.score),
				{
					font = "TNYFN",
					flags = (V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER),
					align = 'left',
					scale = comboscale,
					fixed = true
				}
			)
		end
		*/
		
		if not takis.combo.outrotics
			--draw combo rank
			--this isnt patched text bnecause of issues with the
			--color codes
			local length = #TAKIS_COMBO_RANKS
			v.drawString(backx+7*comboscale,
				backy+20*comboscale,
				TAKIS_COMBO_RANKS[ ((takis.combo.rank-1) % length)+1 ],
				V_HUDTRANS|V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
				"thin-fixed"
			)
		end
		
		--font
		local scorenum = "CMBCF"
		local score = combonum
		
		local prevw
		if not prevw then prevw = 0 end
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			v.drawScaled(backx+FixedMul(75*FU+(prevw*FU),comboscale),
				backy+5*FU,
				FixedDiv(comboscale,2*FU),
				v.cachePatch(scorenum+n),
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
			)
				
			prevw = $+v.cachePatch(scorenum+n).width*4/10
		end
		
		if takis.combo.cashable
			v.drawString(backx+5*comboscale+(FixedMul(combopatchx,comboscale)),
				backy-2*comboscale,
				"C1+C2: Cash in!",
				V_ALLOWLOWERCASE|V_GREENMAP|V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
				"thin-fixed-center"
			)
		end
		
		--draw the verys
		local maxvery = 19	
		
		local waveforce = FU*2
		waveforce = $+(FU/50*((takis.combo.verylevel-1)))
		if takis.combo.verylevel > 0
			for i = 1, takis.combo.verylevel
				
				local verypatch = v.cachePatch("TAKCOVERY")
				--if not (i % 2)
				--	verypatch = v.cachePatch("TAKCOSUPR")
				--end
				
				local k = ((i-1)%maxvery) --x
				local j = ((i-1)/maxvery) --y
				
				local angle = FixedAngle(maxvery*FU)
				local ay = FixedMul(waveforce,sin((leveltime-k)*angle))
				
				v.drawScaled(backx+(7*FU)+(k*(5*FU)),
					backy+(37*FU)+(j*6*FU)+ay,
					FU/3,
					verypatch,
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
				)
				
			end
			/*
			v.drawString(backx+(7*FU)+(maxvery*(5*FU)),
				backy+(37*FU),
				"x"..takis.combo.verylevel.."\x83 Verys!",
				V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
				"thin-fixed"
			)
			*/
		end
		
	end

	if takis.combo.awardable
	and not takis.combo.dropped
		--takis.combo.awardable = true
		
		local patch = v.cachePatch("FCTOKEN")
		
		local fs = takis.HUD.flyingscore
		local x = hfs.scorex*FU-(patch.width*FU/3)
		local y = (hfs.scorey+20)*FU
		
		if (p.ptsr and p.ptsr.rank)
		and HAPPY_HOUR.othergt
			x = $-20*FU
		end
		local grow = takis.HUD.combo.tokengrow
		
		v.drawScaled(x-(grow*25),y-(grow*20),FU/3+grow,
			patch,
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
			v.getColormap(nil, p.skincolor)
		)
	end
	
	--this is so um jammer lammy
	for k,va in pairs(takis.HUD.comboshare)
		if not va.tics then continue end
		
		local total_width = (v.width() / v.dupx()) + 1
		local total_height = (v.height() / v.dupy()) + 1
		
		/*
		v.drawString(
			160*FU-(total_width*FU/2),
			((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey,
			"Combo Share",
			V_ALLOWLOWERCASE,
			"fixed"
		)
		*/
		
		local x,y = va.x,va.y
		/*
		if va.tics >= (2*TR+(TR/2))-1
			x,y = R_GetScreenCoords(v, p, cam, players[va.node].realmo)
			va.x,va.y = x,y
			va.startx = x
			va.starty = y
		end
		*/
		
		if va.tics <= TR/2
			--THANKS NICK FOR HELPIN ME WITH THE COORDS!!
			local et = TR/2
			local tics = et-va.tics
			
			local ypos = ((100*FU)-(total_height*FU/2))+takis.HUD.combo.basey+9*FU
			local xpos = 160*FU-(total_width*FU/2)
			
			if takis.combo.time
				xpos = $+(v.cachePatch("TAKCOBACK").width*FU/2)
			end
			
			y = ease.outback(
				(FU/et)*tics,
				va.starty,
				ypos,
				FU*4
			)
			x = ease.insine(
				(FU/et)*tics,
				va.startx,
				xpos,
				FU
			)
			
		end
		
		local waveforce = FU*3
		local ay = FixedMul(waveforce,sin(FixedAngle(leveltime*20*FU)))
		if va.tics <= TR/2
			ay = 0
		end
		
		local cpatch = v.cachePatch("TAKCOSHARE")
		local color = v.getColormap(nil,
			(leveltime/2 % 2) and SKINCOLOR_GREEN
			or SKINCOLOR_RED
		)
		local xoff = -7*FU
		v.drawScaled(x+8*FU-xoff,y+ay,FU,cpatch,0,color)
		v.drawString(x+8*FU-xoff,y+ay,"+"..va.comboadd,0,"fixed-right")
	end
	setinterp(v,false)
	
end

--      ----------

local function drawjumpscarelol(v,p)

	if (customhud.CheckType("takis_c3jumpscare") != modname) return end

	local takis = p.takistable
	local h = takis.HUD.funny
	
	if h.tics
		if not h.wega
			v.fadeScreen(35,10)
			
			local scale = FU*7/5
			local p = v.cachePatch("BALL_BUSTER")
			
			local x = v.RandomFixed()*3
			if (leveltime/2) % 2
				x = -$
			end
			
			if h.alsofunny
				p = v.cachePatch("BASTARD")
				scale = FU/2
			end
			
			v.drawScaled(((300/2)*FU)+x,h.y,scale,p,0)
		else
			if h.tics > TR
				local trans = 0
				if h.tics < TR+10
					trans = (10-(h.tics-TR))<<V_ALPHASHIFT
				end
				
				--WTRF LOLOLOL
				local patch = v.cachePatch("TA_WEGA")
				
				local width = patch.width
				local height = patch.height
				local total_width = (v.width() / v.dupx()) + 1
				local total_height = (v.height() / v.dupy()) + 1
				local hscale = FixedDiv(total_width * FU, width * FU)
				local vscale = FixedDiv(total_height * FU, height * FU)
				
				v.drawStretched(0, 0,
					hscale, vscale,
					patch, 
					V_SNAPTOTOP|V_SNAPTOLEFT
				)		
			end
		end
	end
	
end

local function drawhappyhour(v,p)

	if (customhud.CheckType("PTSR_itspizzatime") != modname) and (HAPPY_HOUR.othergt) then return end
	
	if not HH_CanDoHappyStuff(p)
		return
	end
	
	local takis = p.takistable
	
	if (HAPPY_HOUR.time) and (HAPPY_HOUR.time <= 5*TR)
	and (HAPPY_HOUR.gameover == false)
		local date = os.date("*t")
		
		local tics = HAPPY_HOUR.time

		takis.HUD.happyhour.doingit = true
		
		local cmap = 0xFF00
		
		if tics < 15
			v.fadeScreen(cmap,tics)
		elseif ((tics >= 15) and (tics < ((2*TR)+17) ))
			v.fadeScreen(cmap,16)
		elseif ((tics >= ((2*TR)+17)) and (tics < 103))
			v.fadeScreen(cmap,16-(tics-87)) 
		end
		if tics < 4*TR
		and not (p.texttimer < TICRATE/2)
			if p.texttimer
			and p.textvar == 1
				v.drawString(160,
					52,
					"GET TO THE GOAL!",
					V_PERPLAYER|V_GREENMAP,
					"center"
				)
			end
		end
		
		local h = takis.HUD.happyhour
		local y = 40*FU
		
		local me = p.realmo

		local back = 4*FU/5
		
		local pa = v.cachePatch
		
		if tics > 2
			local shakex,shakey = happyshakelol(v)
			v.drawScaled(
				h.its.x+shakex,
				y+h.its.yadd+shakey,
				h.its.scale,
				pa(h.its.patch..h.its.frame),
				V_SNAPTOTOP|v.userTransFlag()
			)
			
			local happy = h.happy.patch
			if date.hour == 6 or date.hour == 18
				happy = "TAHY_SAD"
			end
			
			shakex,shakey = happyshakelol(v)
			v.drawScaled(
				h.happy.x+shakex,
				y+h.happy.yadd+shakey,
				h.happy.scale,
				pa(happy..h.happy.frame),
				V_SNAPTOTOP|v.userTransFlag()
			)
			
			shakex,shakey = happyshakelol(v)
			v.drawScaled(
				h.hour.x+shakex,
				y+h.hour.yadd+shakey,
				h.hour.scale,
				pa(h.hour.patch..h.hour.frame),
				V_SNAPTOTOP|v.userTransFlag()
			)
			if tics > 4
				local pat = SPR2_TRNS
				local scale = 6*FU/5
				--if this looks weird, i dont care
				local frame = skins[p.skin].sprites[SPR2_TRNS].numframes - 1
				local skin = me.skin or p.skin
				local hires = skins[skin].highresscale or FU
				local yadd = 15*FU
				
				--?
				if (me and me.valid)
				and P_IsValidSprite2(me,SPR2_HHF_)
					pat = SPR2_HHF_
					scale = 3*FU/5
					frame = h.face.frame
					yadd = 0
				end
				
				shakex,shakey = happyshakelol(v)
				shakex,shakey = $1/2, $2/2
				local face = v.getSprite2Patch(p.skin,pat,false,frame,0,0)
				v.drawScaled(
					h.face.x+x+shakex,
					(130*FU)+h.face.yadd+yadd+shakey,
					FixedMul(scale,hires),
					face,
					v.userTransFlag(), v.getColormap(p.skin,p.skincolor)
				)
			end
		end
	end
	
end

local function getlaptext(p)
	local text = ''
	local exitingCount, playerCount = PTSR_COUNT()
	local lapsperplayertext = "\x82Your Laps:"
	local inflaps = "\x83Laps:"
	local num = ''
	
	--lots of these for backwards compatability
	local laps = (PTSR.laps)
	local maxlaps = PTSR.maxlaps
	
	if p.ptsr.pizzaface
		return '',"dontdraw"
	end
	
	if CV_PTSR.default_maxlaps.value
		text = lapsperplayertext
		num = p.ptsr.laps.." / "..PTSR.maxlaps
		p.takistable.HUD.lapanim.maxlaps = PTSR.maxlaps
		return text,num
	else
		text = inflaps
		num = p.ptsr.laps
		p.takistable.HUD.lapanim.maxlaps = -1
		return text,num
	end

end

local function drawtelebar(v,p)

	
	local takis = p.takistable
	local me = p.mo
	local h = takis.HUD.ptsr
	
	local color = SKINCOLOR_GREEN
	local pre = "CLTCHMET_"
	
	local charge = (p.pizzacharge or 0)
	local max = TR*FU
	
	if p.pizzachargecooldown
		max = CV_PTSR.pizzatpcooldown.value*FU
		charge = p.pizzachargecooldown
		color = SKINCOLOR_RED
	end
	
	local back = v.cachePatch(pre.."BACK")
	local x = 110*FU
	local y = 190*FU+h.yoffset
	local scale = FU/2
	
	v.drawScaled(
		x,
		y,
		scale,
		back,
		V_SNAPTOBOTTOM|V_HUDTRANS
	)

	local timer = charge*FU
	local erm = FixedDiv((timer),max)
	local width = v.cachePatch(pre.."FILL").height*FU-FixedMul(erm,v.cachePatch(pre.."FILL").height*FU)
	if width < 0 then
		width = 0
	end
	
	v.drawCropped(x,
		y+FixedMul(width,scale),
		scale,scale,
		v.cachePatch(pre.."FILL"),
		V_SNAPTOBOTTOM|V_HUDTRANS|V_FLIP, 
		v.getColormap(nil,color),
		0,width,
		v.cachePatch(pre.."FILL").width*FU,v.cachePatch(pre.."FILL").height*FU
	)
end

local function drawpizzatips(v,p)

	if (customhud.CheckType("PTSR_tooltips") != modname) return end
	
	if not HH_CanDoHappyStuff(p)
		return
	end
	
	local takis = p.takistable
	local h = takis.HUD.ptsr
	local me = p.realmo
	
	if (takis.hhexiting) then return end
	
	if not (HAPPY_HOUR.othergt and HAPPY_HOUR.happyhour)
		return
	end
	
	local tics = HAPPY_HOUR.time
	
	if p.ptsr == nil then return end
	
	local text,num = getlaptext(p)
	local exitingCount, playerCount = PTSR_COUNT()

	if (not p.ptsr.pizzaface)
	and (p.ptsr.outofgame)
	and (p.playerstate ~= PST_DEAD) 
	and not (p.ptsr.laps >= PTSR.maxlaps and CV_PTSR.default_maxlaps.value)
	and not PTSR.gameover then
		if not p.hold_newlap then
			v.drawString(160, 130, "\x85Hold FIRE to try a new lap!", V_ALLOWLOWERCASE|V_SNAPTOBOTTOM, "thin-center")
		else
			local per = (FixedDiv(p.hold_newlap*FRACUNIT, PTSR.laphold*FRACUNIT)*100)/FRACUNIT
			v.drawString(160, 130, "\x85Lapping... "..per.."%", V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, "thin-center")
		end
	end
	
	if tics > 3
		h.xoffset = 0
		if num ~= 'dontdraw'
		and not p.spectator
			h.xoffset = 31
			
			v.drawScaled(65*FU+(h.xoffset*FU),170*FU+(h.yoffset),3*FU/5,v.cachePatch("TA_LAPFLAG"),V_HUDTRANS|V_SNAPTOBOTTOM)
			--v.drawString((85+h.xoffset)*FU,(160)*FU+(h.yoffset),text,V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"thin-fixed-center")

			v.drawString((85+h.xoffset)*FU,(177)*FU+(h.yoffset),num,V_PURPLEMAP|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"fixed-center")
		end
		
		if playerCount == 1
			v.drawString((85+h.xoffset)*FU,(160-16)*FU+(h.yoffset),"\x88".."Exercise",V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"thin-fixed-center")
			v.drawString((85+h.xoffset)*FU,(160-8)*FU+(h.yoffset),"\x88".."Mode",V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,"thin-fixed-center")
		end
		
	end
		
	if p.ptsr.pizzaface
		/*
		if (p.pizzachargecooldown)
			v.drawString(153+(h.xoffset),162+(h.yoffset),"Cooling down...",V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small-fixed")
		elseif (p.pizzacharge)
			v.drawString(153+(h.xoffset),162+(h.yoffset),"Charging!",V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small-fixed")
		else
			v.drawString(153+(h.xoffset),162+(h.yoffset),"Hold FIRE to teleport!", V_SNAPTOBOTTOM|V_HUDTRANS|V_ALLOWLOWERCASE,"small-fixed")
		end
		*/
		drawtelebar(v,p)
	else
		local gm_metadata = PTSR.currentModeMetadata()
		local lapflag_patch_x = 148*FU
		local lapflag_text_x = lapflag_patch_x + 17*FU
		local ese = 160*FU+(h.yoffset)
		
		if gm_metadata.core_endurance
			-- Difficulty
			local difficulty_name = "PTSR_DIFF_FIRE"
			difficulty_name = $ .. "A" .. tostring((leveltime/2)%14)
			local difficulty_patch = v.cachePatch(difficulty_name)
			local difficulty_string = string.format("%.2f", PTSR.difficulty)
			v.drawScaled(lapflag_patch_x+(40*FU), ese-(FU*14), FU/2, difficulty_patch, V_PERPLAYER|V_SNAPTOBOTTOM)
			customhud.CustomFontString(v, lapflag_text_x+(40*FU), ese-(FU*6), difficulty_string, "PTFNT", V_PERPLAYER|V_SNAPTOBOTTOM, "center", FU/3, SKINCOLOR_PURPLE)
			
			-- Pizzaface Speed
			local pfspeed_name = "PTSR_PFSHOE"
			pfspeed_name = $ .. "_A_" .. tostring((leveltime/2)%16)
			local pfspeed_patch = v.cachePatch(pfspeed_name)
			local pfspeed_string = string.format("%.2fX", PTSR.pizzaface_speed_multi)
			v.drawScaled(lapflag_patch_x-(40*FU), ese-(FU*14), FU/2, pfspeed_patch, V_PERPLAYER|V_SNAPTOBOTTOM)
			customhud.CustomFontString(v, lapflag_text_x-(40*FU), ese-(FU*4), pfspeed_string, "PTFNT", V_PERPLAYER|V_SNAPTOBOTTOM, "center", FU/3, SKINCOLOR_SANGRIA)
			
		end
		
	end
end

local function hhtimerbase(v,p)
	if not HAPPY_HOUR.happyhour
		return
	end
	
	if not HAPPY_HOUR.timelimit
		return
	end
	
	if HAPPY_HOUR.time < 2
		return
	end
	
	local tics = HAPPY_HOUR.timeleft
	
	local takis = p.takistable
	
	if tics == nil
		tics = 0
	end
	
	local min = tics/(60*TR) --G_TicsToMinutes(tics,true)
	local sec = G_TicsToSeconds(tics)
	local cen = G_TicsToCentiseconds(tics)
	local spad,cpad,extrastring = '','',''
	
	--paddgin!!
	if (sec < 10) then spad = '0' end
	if (cen < 10) then cpad = '0' end
	
	local timertime = min..":"..spad..sec
	extrastring = "."..cpad..cen 
	if not (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		extrastring = ''
	end
	
	local string = timertime..extrastring
	
	local h = takis.HUD.ptsr
		
	local frame = ((5*leveltime/6)%14)
	local patch
	/*
	local trig = HAPPY_HOUR.trigger
	if (trig and trig.valid)
	and (trig.type == MT_HHTRIGGER)
		patch = v.getSpritePatch(SPR_HHT_,trig.frame,0)
	else
	*/
	patch = v.cachePatch("TAHHS"..frame)
	
	if not (HAPPY_HOUR.othergt and gametype == GT_PTSPICER)
	or (p.spectator)
		h.xoffset = (-GetInternalFontWidth(tostring(string),TAKIS_HAPPYHOURFONT)-30)/10
	end
	
	if not (takis.inNIGHTSMode)
		v.drawScaled(110*FU+(h.xoffset*FU),168*FU+(h.yoffset),FU,patch,V_HUDTRANS|V_SNAPTOBOTTOM)
		
		if not (HAPPY_HOUR.overtime)
			TakisDrawPatchedText(v,
				(150+(h.xoffset))*FU,
				173*FU+(h.yoffset),
				tostring(string),
				{
					font = TAKIS_HAPPYHOURFONT,
					flags = (V_SNAPTOBOTTOM|V_HUDTRANS),
					align = 'left',
					scale = 4*FU/5,
					fixed = true
				}
			)
		else
			local x,y = happyshakelol(v)
			v.drawScaled(
				(150+h.xoffset)*FU+x,173*FU+h.yoffset+y,4*FU/5,
				v.cachePatch(TAKIS_HAPPYHOURFONT.."OT"),
				V_SNAPTOBOTTOM|V_HUDTRANS
			)
		end
	else
		if (p.exiting) then return end
		
		v.drawScaled(100*FU,10*FU-(h.yoffset),
			FU,v.cachePatch("TAHHS"..frame),
			V_HUDTRANS|V_SNAPTOTOP
		)
	
	end

end

local function drawpizzatimer(v,p)

	if (customhud.CheckType("PTSR_bar") != modname) return end
	
	if not HH_CanDoHappyStuff(p)
		return
	end
	
	hhtimerbase(v,p)
end

local function drawhappytime(v,p)
	if (customhud.CheckType("takis_happyhourtime") != modname) return end
	
	if HAPPY_HOUR.othergt
		return
	end
	
	hhtimerbase(v,p)
end

--before i learned about patch_t...
local rankwidths = {
	["S"] = 34*FU,
	["A"] = 36*FU,
	["B"] = 32*FU,
	["C"] = 36*FU,
	["D"] = 35*FU,
}
local rankheights = {
	["S"] = 43*FU,
	["A"] = 44*FU,
	["B"] = 43*FU,
	["C"] = 40*FU,
	["D"] = 39*FU,
}

local function drawpizzaranks(v,p)

	if (customhud.CheckType("PTSR_rank") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	if gametype ~= GT_PTSPICER then return end
	if p.pizzaface then return end
	
	if (PTSR)
		if PTSR.intermission_tics
		or (PTSR:inVoteScreen())
		or (HAPPY_HOUR.gameover)
			return
		end
	end
	
	local takis = p.takistable
	local h = takis.HUD.rank
	if p.ptsr == nil then return end
	
	local patch = v.cachePatch("HUDRANK"..p.ptsr.rank)
	
	local fs = takis.HUD.flyingscore
	local x = hfs.scorex*FU-(patch.width*FU/3)
	local y = (hfs.scorey+20)*FU
	if doihaveminhud
		y = (hfs.scorey+15)*FU
	end
		
	if (p.ptsr and p.ptsr.rank)
		v.drawScaled(x-(h.grow*25),y-(h.grow*20),FU/3+h.grow,
			patch,
			V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP
		)
		if h.percent
		and (p.ptsr.rank ~= "P")
			--thanks jisk for the help lol
			
			if p.ptsr.rank == "S"
			and not (p.ptsr.combo_timesfailed == 0 
			and p.ptsr.combo_times_started == 1)
				return
			end
			
			local max = h.percent
			local erm = FixedDiv((h.score),max)
			
			local scale2 = rankheights[p.ptsr.rank]-(FixedMul(erm,rankheights[p.ptsr.rank]))
			
 			if scale2 < 0 then scale2 = FU end
			
			v.drawCropped(x,y+(scale2/3),FU/3,FU/3,
				v.cachePatch("RANKFILL"..p.ptsr.rank),
				V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP, 
				v.getColormap(nil, nil),
				0,scale2,
				rankwidths[p.ptsr.rank],rankheights[p.ptsr.rank]
			)
			
		end
	end

end

local function drawtauntmenu(v,p)

	if (customhud.CheckType("takis_tauntmenu") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if not takis.tauntmenu.open
		return
	end
	
	if not takis.tauntmenu.closingtime
		if takis.tauntmenu.yadd ~= 0
			local et = TR/2
			takis.tauntmenu.yadd = ease.outquad(( FU / et )*takis.tauntmenu.tictime,200*FU,0)
		end
		/*
		if takis.tauntmenu.tictime < 16
			v.fadeScreen(0xFF00,takis.tauntmenu.tictime)
		else
			v.fadeScreen(0xFF00,16)
		end
		*/
	else
		if takis.tauntmenu.yadd ~= 200*FU
			local et = TR/2
			takis.tauntmenu.yadd = ease.inquad(( FU / et )*((TR/2)-takis.tauntmenu.closingtime),0,200*FU)
		end	
		local tic = takis.tauntmenu.closingtime
		if tic > 16
			tic = 16
		end
		--v.fadeScreen(0xFF00,tic)
	end
	local yadd = takis.tauntmenu.yadd
	
	yadd = -25*FU
	
	v.drawScaled(160*FU,
		108*FU+yadd,
		FU/2,
		v.cachePatch("TAUNTBACK"),
		V_30TRANS,
		v.getColormap(nil, SKINCOLOR_BLACK)
	)
	v.drawString(15*FU,
		(75*FU)+yadd,
		"Taunt",
		V_ALLOWLOWERCASE,
		"fixed"
	)
	v.drawString(305*FU,
		(75*FU)+yadd,
		"Hit C1 to Cancel (Or double tap TF)",
		V_ALLOWLOWERCASE,
		"thin-fixed-right"
	)
	v.drawString(15*FU,
		(90*FU)+yadd,
		"Hit C3 to join a Partner Taunt",
		V_ALLOWLOWERCASE,
		"thin-fixed"
	)
	v.drawString(305*FU,
		(86*FU)+yadd,
		"Quick Taunt: TF+#+C2/C3",
		V_ALLOWLOWERCASE,
		"small-fixed-right"
	)
	v.drawString(305*FU,
		(94*FU)+yadd,
		"Delete Quick Taunt: TF+Fire+C2/C3",
		V_ALLOWLOWERCASE,
		"small-fixed-right"
	)
	v.drawScaled(160*FU,
		100*FU+yadd,
		FU/2,
		v.cachePatch("TAUNTSEPAR"),
		0
	)
	
	local ydisp = 25*FU
	for i = 1, 7 --#takis.tauntmenu.list
		v.drawScaled((20+(35*i))*FU,103*FU+yadd+ydisp,FU/2,v.cachePatch("TAUNTCELL"),V_10TRANS,v.getColormap(nil, SKINCOLOR_BLACK))
		local name = takis.tauntmenu.list[i]
		--local xoffset = takis.tauntmenu.xoffsets[i] or 0
		local showicon = true
		
		local trans = 0
		if ((name == "")
		or (name == nil))
			name = "\x86None"
			trans = V_50TRANS
			showicon = false
		--there IS an entry, but no functions to call for it
		elseif ((TAKIS_TAUNT_INIT[i] == nil) or (TAKIS_TAUNT_THINK[i] == nil))
			name = "\x86"..takis.tauntmenu.list[i]
			trans = V_50TRANS
		end
		
		if not TakisIsTauntUsable(p,i,true)
			trans = V_50TRANS
		end
		
		if (i == takis.tauntmenu.cursor)
		and (takis.io.tmcursorstyle == 2)
			v.drawScaled((20+(35*i))*FU,103*FU+yadd+ydisp,(FU*6/10),v.cachePatch("TAUNTCUR"),0,v.getColormap(nil, SKINCOLOR_SUPERGOLD4))
		end
		
		if showicon
			
			local icon = (takis.tauntmenu.gfx.pix[i]) or "MISSING"
			local scale = (takis.tauntmenu.gfx.scales[i]) or FU
			
			local x,y = 0,0
			if icon == "MISSING"
				x,y = (-31*FU)/2,(-31*FU)/2
			end
			v.drawScaled( (20+(35*i))*FU+x, 103*FU+yadd+ydisp+y,
				scale, v.cachePatch(tostring(icon)),
				trans,
				v.getColormap(TAKIS_SKIN, p.skincolor)
			)
		end
		
		if type(name) == "string"
			v.drawString( (20+(35*i))*FU,(125*FU)+yadd+ydisp,
				name,trans|V_ALLOWLOWERCASE,
				"small-fixed-center"
			)
		elseif type(name) == "table"
			local work = 0
			for j = 1,#name
				v.drawString( (20+(35*i))*FU,(125*FU)+yadd+ydisp + work,
					name[j],trans|V_ALLOWLOWERCASE,
					"small-fixed-center"
				)
				work = $+4*FU
			end
		end
		
		if (takis.io.tmcursorstyle == 1)
			v.drawString( (20+(35*i))*FU,(135*FU)+yadd+ydisp,
				i,trans|V_ALLOWLOWERCASE,
				"small-fixed-center"
			)
		end
		if (i == takis.tauntquick1)
			v.drawString( (20+(35*i))*FU,(140*FU)+yadd+ydisp,
				"TF+C2",trans|V_ALLOWLOWERCASE,
				"small-fixed-center"
			)		
		end
		if (i == takis.tauntquick2)
			v.drawString( (20+(35*i))*FU,(140*FU)+yadd+ydisp,
				"TF+C3",trans|V_ALLOWLOWERCASE,
				"small-fixed-center"
			)		
		end

	end
	
	if (takis.io.tmcursorstyle == 2)
		v.drawString(160*FU,(135*FU)+yadd+ydisp,
			"Use Weapon Next/Prev to scroll. Press Fire Normal to select.",V_ALLOWLOWERCASE,
			"small-fixed-center"
		)	
	end
	
end

local function drawwareffect(v,p)
	if (customhud.CheckType("takis_tauntmenu") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if not (takis.shotgunned)
		return
	end
	
	local fade = 0
	local time = takis.shotguntime/10
	local maxfade = 3
	
	if (time%(maxfade*2))+1 > maxfade
		fade = maxfade-(time%maxfade)
	else
		fade = (time%maxfade)
	end
	fade = $+1
	
--	v.fadeScreen(35,fade)
	--drawfill my favorite :kindlygimmesummadat:
	v.drawScaled(0,0,FU*10,v.cachePatch("TAUNTBACK"),(9-fade)<<V_ALPHASHIFT,v.getColormap(nil,SKINCOLOR_RED))
end

local letter = {
	"Dear pesky blaster...",
	"The Badniks and I have taken over your",
	"spirit stash. The spirits are now",
	"permanent guests at each of my seven",
	"Special Stages. I dare you to find them...",
	"If you can!"
}
	
local function drawcosmenu(v,p)
	if (customhud.CheckType("takis_cosmenu") != modname) return end
	
	local takis = p.takistable
	local me = p.mo
	
	local menu = takis.cosmenu
	local page = TAKIS_MENU.entries[menu.page]
	
	local function happyshakelol(v,pos,evenless)
		pos = $ or 0
		local s = 5
		local shakex,shakey = v.RandomFixed()/2,v.RandomFixed()/2
		
		local d1 = v.RandomRange(-1,1)
		local d2 = v.RandomRange(-1,1)
		if d1 == 0
			d1 = v.RandomRange(-1,1)
		end
		if d2 == 0
			d2 = v.RandomRange(-1,1)
		end

		shakex = $*s*d1
		shakey = $*s*d2
		
		local oncur = 0
		if pos-1 == takis.cosmenu.y then oncur = FU end
		
		shakex,shakey = FixedDiv($1,2*FU),FixedDiv($2,2*FU)
		shakex,shakey = FixedMul($1,oncur),FixedMul($2,oncur)
		if (evenless)
			shakex,shakey = FixedDiv($1,2*FU),FixedDiv($2,2*FU)		
		end
		
		return shakex,shakey
	end
	
	local pos = {x = 15,y = 15}
	local shakex,shakey = happyshakelol(v)
	
	local pagecolor = SKINCOLOR_GREEN
	if (page.color == "mo.color")
		pagecolor = mo.color
	elseif (page.color == "p.skincolor")
		pagecolor = p.skincolor
	else
		pagecolor = page.color
	end
	
	
	--TODO: transparent box behind text, I CANT SEE IT!
	--drawfill my favorite :kindlygimmesummadat:
	v.drawFill(0,0,nil,nil,
		--even if there is tearing, you wont see the black void
		skincolors[pagecolor].ramp[15]|V_SNAPTOLEFT|V_SNAPTOTOP
	)
	
	local bgp = v.cachePatch("TA_MENUBG")
	local bgscale = FU
	local total_width = (v.width() / v.dupx()) + 1
	local total_height = (v.height() / v.dupy()) + 1
	local bgflags = V_SNAPTOTOP|V_SNAPTOLEFT|V_10TRANS
	local bgmaxi = FixedInt(FixedDiv(total_width*FU,bgp.width*bgscale))+1
	local bgmaxj = FixedInt(FixedDiv(total_height*FU,bgp.height*bgscale))+1
	local bgxoff = (-leveltime*5000)%(bgp.width*bgscale)
	local bgyoff = (leveltime*5000)%(bgp.height*bgscale)
	
	-- +1 for scrolling
	for i = 0,bgmaxi
		for j = 0,bgmaxj
			local x = (bgp.width*bgscale*i)
			local y = -bgp.height*bgscale+(bgp.height*bgscale*j)
			v.drawScaled(x+bgxoff,
				y+bgyoff,
				bgscale,bgp,bgflags,
				v.getColormap(nil,pagecolor)
			)
			/*
			v.drawString(x+bgxoff,
				y+bgyoff,
				"i"..i..", j"..j.."\n"
				.."max "..bgmaxi..", "..bgmaxj,
				bgflags|V_ALLOWLOWERCASE|V_RETURN8,
				"thin-fixed"
			)
			*/
		end
	end
	
	v.drawScaled((300-pos.x)*FU,pos.y*FU,(FU/2)+(FU/12),
		v.cachePatch("TB_C1"),
		V_SNAPTORIGHT|V_SNAPTOTOP
	)
	v.drawString(300-pos.x-5,pos.y,
		"Leave",
		V_SNAPTORIGHT|V_SNAPTOTOP|V_YELLOWMAP|V_ALLOWLOWERCASE,
		"right"
	)
	if takis.io.savestate ~= 0
		local state = "IDLE"
		if takis.io.savestate == 2
			state = "GOOD"
		elseif takis.io.savestate == 3
			state = "BAD"
		elseif takis.io.savestate == 4
			state = "WARN"
		end
		
		v.drawScaled(
			(300-pos.x)*FU,
			pos.y+35*FU+(v.cachePatch("TA_SAVE_IDLE").height*FU/2),
			FU,
			v.cachePatch("TA_SAVE_"..state),
			V_SNAPTORIGHT|V_SNAPTOTOP|V_YELLOWMAP
		)
		
	end
	
	--draw title
	v.drawString(pos.x,pos.y,
		page.title.."\x80 ("..tostring(menu.page+1).."/"..tostring(#TAKIS_MENU.entries+1)..")",
		V_SNAPTOLEFT|V_SNAPTOTOP|V_YELLOWMAP|V_ALLOWLOWERCASE,
		"left"
	)
	
	local longestwidth = 0
	local lowestheight = ((100*FU)+(total_height*FU/2))-(60*FU)
	local lowestiter = 0
	local alreadysetwrap = false
	
	--the TEXT.
	local lastx = pos.x
	for i = 1,#page.text
		shakex,shakey = happyshakelol(v,i)
		if not ((menu.page == 1) or (menu.page == 3))
			
			--handles text wrapping if it goes too close to the
			--bottom of the screen
			--ONLY WRAPS ONCE so try not to use so many entries :)
			local txtlength = 0
			local texty = pos.y*FU+10*FU*i
			--absolute coords on screen
			local absy = ((100*FU)-(total_height*FU/2))+texty
			--check bottom of string (+8)
			--idea is to generally keep the entries away from the hints & controls
			local toolow = (absy+8*FU >= lowestheight) and true or false
			if toolow
				if lowestiter == 0
					lowestiter = i
				end
				if not alreadysetwrap
					pos.x = $+(longestwidth/FU)+10
				end
				texty = pos.y*FU+10*FU*((i-lowestiter)+1)
				alreadysetwrap = true
			end
			
			if i-1 == takis.cosmenu.y
				v.drawScaled(pos.x*FU,texty,FU,
					v.cachePatch("TA_MENUTXTCUR"),
					V_SNAPTOLEFT|V_SNAPTOTOP,
					v.getColormap(nil,ColorOpposite(pagecolor),nil)
					--this breaks in 2.2.14 but its whatever
				)
			end
			
			if (page.text[i] == "$$$$$")
				local txt = ''
				if io
				and (p == consoleplayer)
					DEBUG_print(p,IO_CONFIG|IO_MENU)
					local file = io.openlocal("client/takisthefox/config.dat")
					
					if file 
						local extra = ''
						local curcode = TakisConstructSaveCode(p)
						local code = file:read("*a")
						if code ~= curcode
							extra = "\x87 (Outdated)"
						end
						if code ~= nil and not (string.find(code, ";"))
							txt = "\x82".."Config: "..code..extra
						end
						file:close()
					else
						txt = "\x86No Config."
					end
					
				else
					txt = "\x85Other person's config."
				end
				v.drawString(pos.x*FU, texty,
					txt,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
				txtlength = v.stringWidth(txt,V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU
			elseif (page.text[i] == "$$$$$$")
				local txt = ''
				if io
				and (p == consoleplayer)
					DEBUG_print(p,IO_CONFIG|IO_MENU)
					local file = io.openlocal("client/takisthefox/backupconfig.dat")
					
					if file 
						local code = file:read("*a")
						if code ~= nil and not (string.find(code, ";"))
							txt = "\x82".."Backup Config: "..code
						end
						file:close()
					else
						txt = "No Backup."
					end
					
				else
					txt = "\x85Other person's config."
				end
				v.drawString(pos.x*FU, texty,
					txt,
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
				txtlength = v.stringWidth(txt,V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU
			else
				v.drawString(pos.x*FU+shakex, texty+shakey,
					page.text[i],
					V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
				txtlength = v.stringWidth(page.text[i],V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU
				if (page.values ~= nil)
				and (#page.values)
				and (page.values[i] ~= nil)
					local value = '\x85???'
					
					--get the table so we can get our value
					if (type(page.values[i]) == "string")
						--surely theres a better way to do this
						local table = TAKIS_NET
						if page.table == "takis.io"
							table = takis.io
						elseif page.table == "takis"
							table = takis
						elseif page.table == "player"
							table = p
						elseif page.table == "_G"
							table = _G
						elseif page.table ~= nil
							table = p[page.table]
						end
						value = table[(page.values[i])]
						
						if page.textvalues ~= nil
							if page.textvalues[i] ~= nil
								value = page.textvalues[i][value]
							end
						end
						value = tostring($)
						
					else
						value = tostring(page.values[i])
					end
					if value == nil or value == "nil" then value = '\x85???' end
					
					v.drawString(pos.x*FU+txtlength+shakex,
						texty+shakey,
						": \x82"..value,
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
						"thin-fixed"
					)
					txtlength = $+(v.stringWidth(": \x82"..value,V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,"thin")*FU)
				end
			end
			if txtlength > longestwidth
				longestwidth = txtlength
			end
		--achs & drivers page
		else
			if menu.page == 3
				local player = players[takis.cosmenu.linnode]
				
				local license = player.takistable.license
				
				if not All7Emeralds(emeralds)
				and not license.haslicense
					v.drawString(pos.x*FU,pos.y*FU+10*FU,
						"Hmm... Nothing here yet.",
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
						"thin-fixed"
					)
					v.drawString(pos.x*FU,pos.y*FU+18*FU,
						"Come back after getting all the spirits.",
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
						"thin-fixed"
					)
				else
					
					if not license.haslicense
						v.drawString(pos.x*FU,pos.y*FU+11*FU,
							"Order in a kart by holding C3!",
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
							"thin-fixed"
						)
					else
						v.drawString(pos.x*FU,pos.y*FU+10*FU+(v.cachePatch("TA_LICENSE").height*FU),
							"[Jump] - Change photo",
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
							"thin-fixed"
						)
						
						v.drawScaled(pos.x*FU,(pos.y+10)*FU,FU,
							v.cachePatch("TA_LICENSE"),
							V_SNAPTOLEFT|V_SNAPTOTOP,
							v.getColormap(nil,ColorOpposite(player.skincolor),
								nil	--2.2.14
							)
						)
						
						do
							v.drawScaled(pos.x*FU,(pos.y+10)*FU,FU,
								v.cachePatch(TAKIS_MUGSHOTS[license.mugshot].patch),
								V_SNAPTOLEFT|V_SNAPTOTOP,
								v.getColormap(nil,player.skincolor)
							)
							
							if takis.license.mugtime
								v.drawScaled(pos.x*FU+FU,(pos.y+88)*FU,FU,
									v.cachePatch("TA_LICENSECR"),
									V_SNAPTOLEFT|V_SNAPTOTOP|V_50TRANS
								)
								v.drawString(pos.x*FU+FU,(pos.y+89)*FU,
									TAKIS_MUGSHOTS[license.mugshot].credit or "No credit",
									V_YELLOWMAP|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
									"thin-fixed"
								)
							end
							
							for i = 1,#TAKIS_MUGSHOTS
								if player ~= p then break end
								
								local swid = (v.stringWidth("[Jump] - Change photo ",0,"thin")*FU)+(7*FU*i)
								local flags = (i ~= license.mugshot) and V_50TRANS or 0
								local color = (i == license.mugshot) and SKINCOLOR_YELLOW or SKINCOLOR_BLACK
								v.drawScaled(pos.x*FU+swid,
									pos.y*FU+14*FU+(v.cachePatch("TA_LICENSE").height*FU),
									FU,
									v.cachePatch("TA_LIVESFILL_BALL"),
									V_SNAPTOLEFT|V_SNAPTOTOP|flags,
									v.getColormap(nil,color)
								)
								
							end
						end
						
						v.drawString((pos.x+85)*FU,pos.y*FU+60*FU,
							"People ran over: "..license.ranover,
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_INVERTMAP,
							"thin-fixed"
						)
						v.drawString((pos.x+85)*FU,pos.y*FU+70*FU,
							"Fracs driven: "..license.miles.." fu",
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_INVERTMAP,
							"thin-fixed"
						)
						v.drawString((pos.x+85)*FU,pos.y*FU+80*FU,
							"Crashes: "..license.crashes,
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_INVERTMAP,
							"thin-fixed"
						)
						v.drawString((pos.x+85)*FU,pos.y*FU+90*FU,
							"Wall bumps: "..license.bumps,
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_INVERTMAP,
							"thin-fixed"
						)
						
						/*
						--203 130
						local rankpatch = v.cachePatch("HUDRANKD")
						local scale = FU/2
						v.drawScaled((pos.x+188)*FU-(rankpatch.width*scale/2),
							pos.y*FU+115*FU+(rankpatch.height*scale/2),
							scale,
							rankpatch,
							V_SNAPTOLEFT|V_SNAPTOTOP
						)
						*/
					end
					
				end
			else
				local maxach = 16
				local number = consoleplayer.takistable.achfile
				for i = 0,maxach-1
					--bits to shift up by
					local j = i+(menu.achpage*maxach)
					
					if j > NUMACHIEVEMENTS-1 then break end
					
					local has = V_60TRANS
					local t = TAKIS_ACHIEVEMENTINFO
					local ach = t[1<<j]
					
					if (number & (1<<j))
					and not (TAKIS_NET.usedcheats or TAKIS_NET.noachs)
						has = 0
					end
					
					local x = pos.x*FU+((140*FU)*(i%2))
					local y = pos.y*FU+10*FU+(17*FU*(i/2))
					
					if ach == nil
						local icon = v.cachePatch("ACH_INVALID")
						v.drawScaled(x,
							y,
							FU/4,
							icon,
							V_SNAPTOLEFT|V_SNAPTOTOP
						)
						v.drawString(x+FU+(icon.width*FU/4),
							y,
							"Invalid Achievement",
							V_REDMAP|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
							"thin-fixed"
						)
						continue
					end
				
					v.drawScaled(x,
						y,
						ach.scale or FU,
						(number & (1<<j)) and v.cachePatch(ach.icon) or ((ach.flags & AF_SECRET and has) and v.cachePatch("ACH_SPLACEHOLDER") or v.cachePatch("ACH_PLACEHOLDER")),
						V_SNAPTOLEFT|V_SNAPTOTOP|has
					)
					v.drawString(x+FU+(v.cachePatch(ach.icon).width*(ach.scale or FU)),
						y,
						(ach.flags & AF_SECRET and has) and "Secret Achievement" or (ach.name or "Ach. Enum "..(1<<j)),
						(V_GRAYMAP and has or 0)|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
						"thin-fixed"
					)
					v.drawString(x+FU+(v.cachePatch(ach.icon).width*(ach.scale or FU)),
						y+(8*FU),
						(ach.flags & AF_SECRET and has) and " " or (ach.text or "Flavor text goes here"),
						(V_GRAYMAP and has or 0)|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
						"small-fixed"
					)
					
				end
				
				if not (TAKIS_NET.usedcheats)
					--draw a bigger version so you can see the icon
					local x = pos.x*FU
					local y = pos.y*FU+10*FU+(17*FU*((maxach+1)/2))
					
					local t = TAKIS_ACHIEVEMENTINFO
					local num,num2 = menu.achcur,menu.achcur
					num = $+(menu.achpage*maxach)
					local ach = t[1<<num]
					local has = V_60TRANS
					if (number & (1<<num))
						has = 0
					end
					
					local curx = pos.x*FU+((140*FU)*(num2%2))
					local cury = pos.y*FU+10*FU+(17*FU*(num2/2))
					v.drawScaled(curx,cury,FU,
						v.cachePatch("TA_MENUACHCUR"),
						V_SNAPTOLEFT|V_SNAPTOTOP,
						v.getColormap(nil,SKINCOLOR_SUPERGOLD4)
					)
					
					local x2 = pos.x*FU
					v.drawString(300*FU-x2,y+16*FU,
						"(Jump) Set "..(menu.achpage+1).."/"..((NUMACHIEVEMENTS > 16) and "2" or "1"),
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
						"thin-fixed-right"
					)
					
					if ach == nil
						local icon = v.cachePatch("ACH_INVALID")
						v.drawScaled(x,
							y,
							FU/2,
							icon,
							V_SNAPTOLEFT|V_SNAPTOTOP
						)
						v.drawString(x+FU+(icon.width*FU/2),
							y,
							"Invalid Achievement",
							V_REDMAP|V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
							"fixed"
						)
					else
						--ok draw the ach
						v.drawScaled(x,
							y,
							(ach.scale or FU)*2,
							(number & (1<<num)) and v.cachePatch(ach.icon) or ((ach.flags & AF_SECRET and has) and v.cachePatch("ACH_SPLACEHOLDER") or v.cachePatch("ACH_PLACEHOLDER")),
							V_SNAPTOLEFT|V_SNAPTOTOP|has
						)
						v.drawString(x+FU+(v.cachePatch(ach.icon).width*((ach.scale or FU)*2)),
							y,
							(ach.flags & AF_SECRET and has) and "Secret Achievement" or (ach.name or "Ach. Enum "..(1<<i)),
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
							"fixed"
						)
						v.drawString(x+FU+(v.cachePatch(ach.icon).width*((ach.scale or FU)*2)),
							y+(8*FU),
							(ach.flags & AF_SECRET and has) and " " or (ach.text or "Flavor text goes here"),
							V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_RETURN8,
							"thin-fixed"
						)
						
						local disp = 0
						if has == 0
							v.drawString(300*FU-x,y,
								"You have this.",
								V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
								"thin-fixed-right"
							)
							disp = 8*FU
						end
						if (ach.flags & AF_MP)
							v.drawString(300*FU-x,y+disp,
								"MP only",
								V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
								"thin-fixed-right"
							)					
							
							local leg = v.stringWidth(" MP only",V_ALLOWLOWERCASE,"thin")*FU
							
							v.drawScaled(300*FU-x-leg,y+disp,
								FU,
								v.cachePatch("TA_NETGAME"),
								V_SNAPTOLEFT|V_SNAPTOTOP
							)					
						end
						if (ach.flags & AF_SP)
							v.drawString(300*FU-x,y+disp,
								"SP only",
								V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
								"thin-fixed-right"
							)					
							
							local leg = v.stringWidth(" SP only",V_ALLOWLOWERCASE,"thin")*FU
							
							v.drawScaled(300*FU-x-leg,y+disp,
								FU,
								v.cachePatch("TA_SINGLEP"),
								V_SNAPTOLEFT|V_SNAPTOTOP
							)					
						end
					end
				else
					local x = pos.x*FU
					local y = pos.y*FU+10*FU+(17*FU*((NUMACHIEVEMENTS+1)/2))				
					
					v.drawString(x,y,
						TAKIS_NET.noachs and "Achievements have been disabled by the server."
						or "Achievements cannot be earned in cheated games.",
						V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_REDMAP,
						"thin-fixed"
					)
				end
			end
		end
	end
	pos.x = lastx
	
	if (page.hints ~= nil)
	and (#page.hints)
		if (page.hints[menu.y+1] ~= nil)
			shakex,shakey = happyshakelol(v,menu.y+1,true)
			v.drawString(pos.x*FU+shakex, (200-pos.y)*FU-10*FU+shakey,
				page.hints[menu.y+1],
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		end
	end
	
	local hinttrans = 0
	if menu.hintfade > 0
		if menu.hintfade > (3*TR+9)
			hinttrans = (menu.hintfade-(3*TR+9))<<V_ALPHASHIFT
		end
		if menu.hintfade < 10
			hinttrans = (10-menu.hintfade)<<V_ALPHASHIFT
		end
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-42*FU+shakey,
			"[C1] - Exit",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-34*FU+shakey,
			"[Jump] - Select",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-26*FU+shakey,
			"[Up/Down] - Move Cursor",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		shakex,shakey = happyshakelol(v,menu.y+1,true)
		v.drawString(pos.x*FU+shakex, ((200-pos.y)*FU)-18*FU+shakey,
			"[Left/Right] - Flip page",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_GRAYMAP|V_RETURN8|V_ALLOWLOWERCASE|hinttrans,
			"thin-fixed"
		)
		
	end
	
	if takis.HUD.showingletter
		v.fadeScreen(0xFF00,16)
		local color = v.getColormap(nil,p.skincolor)
		v.drawScaled(160*FU,100*FU,FU,v.cachePatch("IMP_LETTER"),V_HUDTRANS,color)
		/*
		v.drawString(82,11,"Dear pesky rodents...",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(76,21,"The Badniks and I have taken over\nGreenflower City. The Chaos Emeralds are",V_RETURN8|V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(72,37,"now permanent guests at one of my seven",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		v.drawString(69,45,"Special Stages. I dare you to find them, if\nyou can! ",V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")
		*/
		
		for k,val in ipairs(letter)
			v.drawString(82,11*k,val,V_ALLOWLOWERCASE|V_HUDTRANS|V_INVERTMAP,"thin")		
		end
		
		v.drawString(82,11*(#letter+1),"C2 - Exit",V_ALLOWLOWERCASE|V_HUDTRANS|V_GRAYMAP,"left")
		v.drawScaled(108*FU,131*FU,FU,v.cachePatch("IMP_SIG"),V_HUDTRANS)
	end
end

local function drawcfgnotifs(v,p)
	if (customhud.CheckType("takis_cfgnotifs") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local HUD = takis.HUD
	local me = p.mo
	
	if not HUD.cfgnotifstuff
		return
	end
	
	local trans = 0
	
	if HUD.cfgnotifstuff >= 6*TR+9
		trans = (HUD.cfgnotifstuff-(6*TR+9))<<V_ALPHASHIFT
	elseif HUD.cfgnotifstuff < 10
		trans = (10-HUD.cfgnotifstuff)<<V_ALPHASHIFT
	end
	
	local waveforce = FU/10
	local ay = FixedMul(waveforce,sin(leveltime*ANG2))
	v.drawScaled(160*FU,65*FU,FU+ay,v.cachePatch("BUBBLEBOX"),trans)
	
	if not multiplayer
		v.drawString(160,50,"Would you like to play",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,60,"the Takis Tutorial?",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,70,"\x86".."C2 - Yes",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,80,"\x86".."C3 - Dismiss",trans|V_ALLOWLOWERCASE,"thin-center")
	else
		v.drawString(160,50,"You have no Config, check",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,60,"out the \x86takis_openmenu\x80.",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,70,"\x86(Hold FN+C3+C2)",trans|V_ALLOWLOWERCASE,"thin-center")
		v.drawString(160,80,"\x86".."C3 - Dismiss",trans|V_ALLOWLOWERCASE,"thin-center")
	end
end

local function drawbonuses(v,p)
	if (customhud.CheckType("takis_bonuses") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	
	/*
	local HUD = takis.HUD
	local me = p.mo
	local fs = HUD.flyingscore
	
	
	TakisDrawBonuses(
		v, p, -- Self explanatory.
		fs.scorex*FU, (fs.scorey*FU)+15*FU, fs.scores|V_ALLOWLOWERCASE, -- Powerups X & Y. Flags.
		'thin-fixed'..snap, -- string alignment.
		8*FU, ANGLE_90-- Distance to shift and which angle to do so.
	)
	*/
	
	if Takis_HUDBonus[p] == nil then return end
	local bonus = Takis_HUDBonus[p]
	
	local snap = "-"..hfs.scorea
	if hfs.scorea ~= "center" and hfs.scorea ~= "right" then snap = '' end
	
	local bonustargety = (hfs.scorey+15)*FU
	local i = 0

	--adds up all the bonus' tics to check if all are removed
	local alltics = 0
	local waiting = 0
	for k,va in ipairs(bonus)
		alltics = $+va.tics
		waiting = $+va.wait
	end

	for k,va in ipairs(bonus)
		if va.tics <= 0
			if alltics <= 0
				table.remove(bonus,k)
			end
			continue
		end
		
		local tween = ease.inoutback(
			va.wait and (FU/17) * (va.stics - va.tics) or FU,
			70*FU, 0, 2*FU
		)
		if va.tics <= 17
			tween = ease.outback(
				(FU/17) * va.tics,
				70*FU, 0,  2*FU
			)
		end
		
		v.drawString(hfs.scorex*FU + tween,
			va.ypos,
			va.text.."\x80 - "..va.score.."+",
			hfs.scores|V_ALLOWLOWERCASE|V_HUDTRANS,
			"thin-fixed"..snap
		)
		
		if not paused
			va.ypos = ease.outquad(FU/10,$, bonustargety + 8*i*FU)
			--if alltics > 17 * #bonus
			if va.tics > 17
				va.tics = $-1
				va.ticdown = false
			--Summa!	
			else
				va.ticdown = waiting <= 0
				if alltics == 17 * #bonus
				and takis.yeahed
					va.wait = $-1
					if va.wait == 0
						va.tics = $ + (#bonus - k)
					end
				end
				
			end
			if va.ticdown
				va.tics = $-1
			end
		end
		i = $+1
	end
	/*
	v.drawString(hfs.scorex*FU,
		bonustargety + 8*i*FU,
		alltics..", "..17 * #bonus..", "..waiting,
		hfs.scores|V_ALLOWLOWERCASE|V_HUDTRANS,
		"thin-fixed"..snap
	)
	*/
end

local function drawcrosshair(v,p)
	if (customhud.CheckType("takis_crosshair") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if not (takis.shotgunned)
		return
	end
	
	if (camera.chase and not (p.awayviewtics and not takis.in2D))
		return
	end
	
	if p.awayviewtics then return end
	
	local trans = V_HUDTRANS
	local scale = FU/2
	if takis.shotguncooldown
		scale = $+FixedDiv(takis.shotguncooldown*FU,6*FU)
		trans = V_HUDTRANSHALF
	end
	if (takis.noability & NOABIL_SHOTGUN)
		trans = V_HUDTRANSHALF
	end
	
	v.drawScaled(160*FU,100*FU,scale,v.cachePatch("SHGNCRSH"),trans)
end

local function drawtutbuttons(v,p)
	if (customhud.CheckType("takis_tutbuttons") != modname) return end
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	if (p.takis_noabil == nil) then return end
	if (mapheaderinfo[gamemap].takis_tutorialmap == nil) then return end
	if (p.textBoxInAction) then return end
	
	local takis = p.takistable
	local me = p.mo
	
	local disp = 0
	
	if (takis.transfo & TRANSFO_SHOTGUN)
	and (takis.shotgunforceon == false)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C3"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"De-Shotgun",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_DIVE)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C1"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			takis.transfo & TRANSFO_SHOTGUN and "Shoulder Bash" or "Dive",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_SLIDE)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C2"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"Spin (hold on slope)",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)
		disp = $-20
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_C2"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"Slide",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_HAMMER)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_SPIN"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"Hammer Blast (hold)",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_THOK)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_JUMP"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			"x2 Double Jump",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end
	
	if not (p.takis_noabil & NOABIL_CLUTCH)
		v.drawScaled(hudinfo[HUD_LIVES].x*FU,
			(hudinfo[HUD_LIVES].y+disp)*FU,
			(FU/2)+(FU/12),
			v.cachePatch("TB_SPIN"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS
		)
		v.drawString(hudinfo[HUD_LIVES].x+20,
			hudinfo[HUD_LIVES].y+(disp+5),
			takis.transfo & TRANSFO_SHOTGUN and "Shoot" or "Clutch Boost",
			V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS,
			"thin"
		)	
		disp = $-20
	end	

end

local function drawbosstitles(v,p)
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	local bosscards = takis.HUD.bosscards
	local title = takis.HUD.bosstitle
	
	if not title.tic then return end
	
	if not (bosscards.mo and bosscards.mo.valid) then return end
	
	if (bosscards.name)
		
		local ticker = title.tic-TR
		
		if 2*TR-ticker < 16
			--we probably just loaded the level
			if (leveltime <= 2*TR)
			or (p.jointime <= 2*TR)
				v.fadeScreen(0xFF00,32-(2*TR-ticker))
			else
				v.fadeScreen(0xFF00,(2*TR-ticker))
			end
		else
			if (ticker > 0)
				if (ticker < 16)
					v.fadeScreen(0xFF00,ticker)
				else
					v.fadeScreen(0xFF00,16)
				end
			end
		end
		
		if (3*TR-title.tic > 3)
			local tx,ty = unpack(title.takis)
			local x,y = unpack(title.egg)
			local vx1,vx2 = unpack(title.vs)
			local bosswidth = v.levelTitleWidth(bosscards.name)
			local sx,sy
			
	
			local patch = v.cachePatch("BT_SPIKEY"..(title.tic/2%3))
			
			local width = patch.width
			local height = patch.height
			local total_width = (v.width() / v.dupx()) + 1
			local hscale = FixedDiv(total_width * FU, width * FU)
			local vscale = FU
			if (3*TR-title.tic) < 17
				vscale = FixedDiv(3*TR*FU-(title.tic*FU),16*FU)
			elseif title.tic < 17
				vscale = FixedDiv(title.tic*FU,16*FU)				
			end
			
			v.drawStretched(0, (ty+10)*FU, hscale, vscale, patch, V_SNAPTOLEFT)
			--6 41
			v.drawScaled((tx-94)*FU,(ty-19)*FU,FU,v.cachePatch("BTP_TAKIS"..(title.tic/3%2)),0,v.getColormap(nil,p.skincolor))
			sx,sy = v.RandomRange(-1,1),v.RandomRange(-1,1)
			v.drawLevelTitle(tx+sx,ty+sy,takis.HUD.hudname or "Takis",0)
			
			sx,sy = happyshakelol(v)
			v.drawScaledNameTag(vx1*FU+sx,
				100*FU+sy,"V",0,FU,
				SKINCOLOR_KETCHUP,SKINCOLOR_WHITE
			)
			sx,sy = happyshakelol(v)
			v.drawScaledNameTag(vx2*FU+sx,
				100*FU+sy,"S",0,FU,
				SKINCOLOR_KETCHUP,SKINCOLOR_WHITE
			)
			
			patch = v.cachePatch("BT_SPIKEY"..(title.tic/2%3))
			v.drawStretched(320*FU, (y+10)*FU, hscale, vscale, patch, V_SNAPTORIGHT|V_FLIP)
			--294 121
			local bosspatch --= v.cachePatch("BTP_BOSSBLANK")
			local pstring = "BTP_"..string.upper(bosscards.name)..(title.tic/3%2)
			if not v.patchExists(pstring)
				bosspatch = v.cachePatch("BTP_BOSSDEFAULT"..(title.tic/3%2))
			else
				bosspatch = v.cachePatch(pstring)
			end
			
			v.drawScaled((x+94)*FU,(y-19)*FU,FU,bosspatch,0)
			sx,sy = v.RandomRange(-1,1),v.RandomRange(-1,1)
			v.drawLevelTitle(x-bosswidth+sx,y+sy,bosscards.name,0)
		end
		
		local trans = 0
		if title.tic >= 3*TR-9
			trans = (title.tic-(3*TR-9))<<V_ALPHASHIFT
		elseif title.tic < 10
			trans = (10-title.tic)<<V_ALPHASHIFT
		end
		if G_BuildMapTitle(gamemap) ~= nil
			v.drawString(160,190,G_BuildMapTitle(gamemap),V_YELLOWMAP|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|trans,"thin-center")
		end
	end
	
end

local function drawtransfotimer(v,p,cam)
	if (customhud.CheckType("takis_transfotimer") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not (takis.transfo & (TRANSFO_PANCAKE|TRANSFO_FIREASS))
		return
	end
	
	if doihaveminhud
		v.drawString(15*FU,55*FU,
			"Transfo:",
			V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_HUDTRANS,
			"thin-fixed"
		)
		
		local pre = "MINFOB_"
		local back = v.cachePatch(pre.."BACK")
		local fill = v.cachePatch(pre.."FILL")
		
		local color = v.getColormap(nil,me.color)
		local color2 = v.getColormap(nil,p.skincolor)
		
		local max = TAKIS_MAX_TRANSFOTIME*FU
		local time = 0
		local time2 = 0
		local type = 0
		local type2 = 0
		
		v.drawScaled(54*FU,56*FU,FU,
			back,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS
		)
		
		if takis.transfo & TRANSFO_PANCAKE
			if takis.pancaketime > takis.fireasstime
				time = takis.pancaketime*FU
				type = 0
			else
				time2 = takis.pancaketime*FU
				type2 = 0
			end
		end
		if takis.transfo & TRANSFO_FIREASS
			if takis.fireasstime > takis.pancaketime
				time = takis.fireasstime*FU
				type = 1
			else
				time2 = takis.fireasstime*FU
				type2 = 1
			end
		end
		
		local erm = FixedDiv(time,max)
		local width = FixedMul(erm,fill.width*FU)
		if width < 0 then
			width = 0
		end
		
		local erm2 = FixedDiv(time2,max)
		local width2 = FixedMul(erm2,fill.width*FU)
		if width2 < 0 then
			width2 = 0
		end
		
		v.drawCropped(54*FU,56*FU,FU,FU,
			fill,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, 
			(type == 1) and color or color2,
			0,0,
			width,fill.height*FU
		)
		
		v.drawCropped(54*FU,56*FU,FU,FU,
			fill,
			V_SNAPTOLEFT|V_SNAPTOTOP|V_HUDTRANS, 
			(type2 == 1) and color or color2,
			0,0,
			width2,fill.height*FU
		)
		
	else
	
		local pre = "TRANSFOM_"
		local flip = 1
		local bubble = v.cachePatch(pre.."BAR")
		local fill = v.cachePatch(pre.."FILL")
		local mark = v.cachePatch(pre.."TIC")
		local x, y, scale, nodraw
		local cutoff = function(y) return false end
		local bottom = false
		
		if cam.chase and not (p.awayviewtics and not takis.in2D)
			x, y, scale, nodraw = R_GetScreenCoords(v, p, cam, me)
			if nodraw then return end
			
			scale = $*2
			if me.eflags & MFE_VERTICALFLIP
			and p.pflags & PF_FLIPCAM
				y = 200*FRACUNIT - $
			else
				flip = P_MobjFlip(me)
			end
			scale = FixedMul($,me.scale)
		else
			x, y, scale, bottom = 160*FRACUNIT, (130 - bubble.height >> 1)*FRACUNIT, FRACUNIT*2, true
		end
		
		scale = FixedDiv($,2*FU)
		
		if splitscreen
			if p == secondarydisplayplayer
				cutoff = function(y) return y < (bubble.height*scale >> 1) end
			else
				cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
			end
		end
		
		if not cutoff(y)
			
			local total_width = (v.width() / v.dupx()) + 1
			local total_height = (v.height() / v.dupy()) + 1
			if not bottom
				
				local bottommost = ((100*FU)-(total_height*FU/2))+165*FU
				if y > bottommost
					y = bottommost
					scale = FU
				end
				
			end
			
			local color = v.getColormap(nil,takis.fireasscolor)
			local color2 = v.getColormap(nil,p.skincolor)
			local invc  = v.getColormap(nil,SKINCOLOR_SALMON)
			
			x = $-(bubble.width*scale/2)
			y = $+25*scale
			
			local max = TAKIS_MAX_TRANSFOTIME*FU
			
			local time = 0
			local time2 = 0
			local type = 0
			local type2 = 0
			
			if takis.transfo & TRANSFO_PANCAKE
				if takis.pancaketime >= takis.fireasstime
					time = takis.pancaketime*FU
					type = 0
				else
					time2 = takis.pancaketime*FU
					type2 = 0
				end
			end
			if takis.transfo & TRANSFO_FIREASS
				if takis.fireasstime >= takis.pancaketime
					time = takis.fireasstime*FU
					type = 1
				else
					time2 = takis.fireasstime*FU
					type2 = 1
				end
			end
			
			local erm = FixedDiv(time,max)
			local width = FixedMul(erm,fill.width*FU)
			if width < 0 then
				width = 0
			end
			
			local erm2 = FixedDiv(time2,max)
			local width2 = FixedMul(erm2,fill.width*FU)
			if width2 < 0 then
				width2 = 0
			end
			
			local snap = (bottom) and V_SNAPTOBOTTOM or 0
			v.drawCropped(x,y,scale,scale,
				fill,
				snap|V_HUDTRANS|V_PERPLAYER, 
				(type == 1) and color or color2,
				0,0,
				width,fill.height*FU
			)
			
			v.drawCropped(x,y,scale,scale,
				fill,
				snap|V_HUDTRANS|V_PERPLAYER, 
				(type2 == 1) and color or color2,
				0,0,
				width2,fill.height*FU
			)
			
			v.drawScaled(x, y, scale, bubble, snap|V_PERPLAYER|V_HUDTRANS)
			if time2
				local offset = FixedMul(FixedMul(fill.width*FU,erm2),scale)+scale
				v.drawScaled(x+4*scale+offset, y+3*scale, scale, mark, snap|V_PERPLAYER|V_HUDTRANS,invc)
			end
			
			local offset = FixedMul(FixedMul(fill.width*FU,erm),scale)+scale
			v.drawScaled(x+4*scale+offset, y+3*scale, scale, mark, snap|V_PERPLAYER|V_HUDTRANS,invc)
		
		end
		
	end
	
end

local function drawfallout(v,p,tabdraw)
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	local tic = takis.pitanim
	
	if not tic then return end
	
	local width = (v.width() / v.dupx()) + 1
	local height = (v.height() / v.dupy()) + 1
	
	if tic >= 2*TR
		local timer = 3*TR-tic
		if timer >= TR/2+2
			v.fadeScreen(0xFF00,(timer-TR/2-2)*2)
		end
	elseif tic >= TR
		v.fadeScreen(0xFF00,32)
	elseif tic < TR
		local left = (160*FU)-(width*FU/2)--FixedMul(340*FU,FixedDiv(width*FU, 340*FU))
		local right = (160*FU)+(width*FU/2)+10*FU
		
		local wipe = v.cachePatch("TA_WIPE")
		local zig = v.cachePatch("TA_WIPEZIG")
		local zag = v.cachePatch("TA_WIPEZAG")
		
		local hscale = FixedDiv(width * FU, wipe.width * FU)
		local vscale = FixedDiv(height * FU, wipe.height * FU)
		
		--local tween = ease.inback((FU/TR)*(TR-tic),left,right,FU*2)
		local tween = ease.inquint((FU/TR)*(TR-tic),left,right)
		
		v.drawStretched(tween, 0, 
			hscale, vscale,
			zig,
			V_SNAPTOTOP
		)
		v.drawStretched(tween, 0, 
			hscale, vscale,
			wipe,
			V_SNAPTOTOP
		)
		v.drawStretched(tween, 0, 
			hscale, vscale,
			zag,
			V_SNAPTOTOP
		)
	end
	

	local top = (100*FU)-(height*FU/2)-10*FU
	local bottom = (100*FU)+(height*FU/2)+10*FU
	
	local tweentic = min(3*TR-tic,TR/2)
	local et = TR/2
	local tween = ease.outback((FU/et)*tweentic,
		top,
		100*FU,
		FU*2
	)
	
	if tic <= TR
	and tic > TR/2
		--
	end
	
	if tic <= TR
	and tic > et
		tween = ease.inback((FU/et)*(TR-tic),
			100*FU,
			bottom,
			FU*2
		)
	end
	
	if tic > et
	and not tabdraw
		v.drawString(160*FU,tween,"Fall out!",0,"fixed-center")
	end
end

local function drawdriftmeter(v,p,cam)
	if (customhud.CheckType("takis_kart_driftmeter") != modname) return end	
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not p.inkart then return end
	if not (me.tracer and me.tracer.valid) then return end
	local car = me.tracer
	if (car.drift == 0) then return end
	if not (car.iskart) then return end
	
	local width = 72*FU
	local flip = 1
	local bubble = v.cachePatch("TA_KDRIFT_BAR")
	local fill = v.cachePatch("TA_KDRIFT_FILL")
	local x, y, scale, nodraw
	local cutoff = function(y) return false end
	local bottom = false
	
	if cam.chase -- and (not p.awayviewtics and takis.in2D)
		x, y, scale, nodraw = R_GetScreenCoords(v, p, cam, me)
		if nodraw then return end
		
		scale = $*2
		if me.eflags & MFE_VERTICALFLIP
		and p.pflags & PF_FLIPCAM
			y = 200*FRACUNIT - $
		else
			flip = P_MobjFlip(me)
		end
		scale = FU
	else
		x, y, scale, bottom = 160*FRACUNIT, (110 - bubble.height >> 1)*FRACUNIT, FRACUNIT, true
	end
	
	
	if splitscreen
		if p == secondarydisplayplayer
			cutoff = function(y) return y < (bubble.height*scale >> 1) end
		else
			cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
		end
	end
	
	if not cutoff(y)
		
		y = $+25*scale
		local percent = 0
		local tmap = 0
		local snap = (bottom) and V_SNAPTOBOTTOM or 0
		local bounce = false
		
		if car.drift ~= 0
			local driftstage = TakisKart_DriftLevel(car.stats,car.driftspark)
			local percentage = 0
			local value = TakisKart_DriftSparkValue(car.stats)
			local max = 0
			local barfill = 0
			
			if car.drift == 0 then return end
			
			if car.driftspark >= value*4
				percentage = 400*FU
				tmap = skincolors[TakisKart_DriftColor(driftstage)].chatcolor
			elseif car.driftspark >= value*3
				barfill = car.driftspark-(value*3)
				percentage = 300*FU+FixedMul(100*FU,FixedDiv(barfill,value))
				tmap = V_PURPLEMAP
				max = value
			elseif car.driftspark >= value*2
				barfill = car.driftspark-(value*2)
				percentage = 200*FU+FixedMul(100*FU,FixedDiv(barfill,value))
				tmap = V_REDMAP
				max = value
			elseif car.driftspark >= value
				barfill = car.driftspark-value
				percentage = 100*FU+FixedMul(100*FU,FixedDiv(barfill,value))
				tmap = V_SKYMAP
				max = value
			else
				barfill = car.driftspark
				percentage = FixedMul(100*FU,FixedDiv(barfill,value))
				max = value
			end
			if car.ctrcar
				local maxdrifttime = car.maxdrifttime
				
				driftstage = 2
				tmap = V_SKYMAP
				
				barfill = car.drifttime*FU
				if car.drifttime > maxdrifttime
					barfill = 0
				end
				max = maxdrifttime*FU
				
				percentage = FixedMul(100*FU,FixedDiv(barfill,max))
			end
			if car.driftbrake
			and (car.driftbrake & 1)
				tmap = V_REDMAP
				bounce = true
			end
			
			
			percent = FixedInt(percentage)
			
			if driftstage > 1
			and driftstage ~= 5
				v.drawScaled(x,
					y,
					scale,
					fill,
					snap|V_PERPLAYER|V_HUDTRANS,
					v.getColormap(nil,TakisKart_DriftColor(driftstage-1))
				)
			end
			
			local color = TakisKart_DriftColor(driftstage)
			if driftstage == 5
				v.drawScaled(x,
					y,
					scale,
					fill,
					snap|V_PERPLAYER|V_HUDTRANS,
					v.getColormap(nil,color)
				)
			else
				local um = FixedDiv(barfill,max)
				local width = FixedMul(um,fill.width*FU)
				if width < 0 then
					width = 0
				end
				
				v.drawCropped(x,y,scale,scale,
					fill,
					snap|V_PERPLAYER|V_HUDTRANS, 
					v.getColormap(nil,color),
					0,0,
					width,fill.height*FU
				)
			
			end
		end
		
		local driftstring = percent.."%"
		if (string.len(driftstring) < 4)
			for i = 1,4 - string.len(driftstring)
				driftstring = "0"..$
			end
		end
		
		v.drawScaled(x, y, scale, bubble, snap|V_PERPLAYER|V_HUDTRANS)
		v.drawString(x+(bubble.width*scale/2)+3*scale,
			y-2*scale-((bounce) and scale or 0),
			driftstring,
			tmap|snap|V_PERPLAYER|V_HUDTRANS,
			"thin-fixed-right"
		)
	end
		
end

local function kartspeedometer(v,p,takis,car,minus)
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER) then return end
	
	local scale = FU
	local x,y = (hudinfo[HUD_LIVES].x+15)*FU+minus,(hudinfo[HUD_LIVES].y)*FU - textboxmoveup - (modeattacking and 20*FU or 0)
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS
	
	local maxspeed = 70*FU
	local speed = FixedDiv(takis.accspeed,maxspeed)
	local sroll
	if (speed ~= 0)
		sroll = FixedAngle(90*FU-FixedMul(90*FU,speed))
	else
		sroll = FixedAngle(90*FU)
	end
	sroll = $+FixedAngle(33*FU)
	
	v.drawScaled(5*FU+minus,192*FU - textboxmoveup - (modeattacking and 20*FU or 0),scale/2,
		v.cachePatch("TA_KFUEL_BCRC"),
		flags
	)
		
	local maxsegs = 50
	local meterfill = FixedDiv(abs(car.accel),car.basemaxspeed/8)
	local fx,fy = x,y-FU
	for i = 0,maxsegs,1
		if meterfill == 0 then break end
		
		local angmath = 
		FixedMul(
			FixedDiv(
				FixedMul(120*FU,meterfill),
				maxsegs*FU
			),
			i*FU
		)
		angmath = $+FixedAngle(33*FU)
		
		local angle = FixedAngle(angmath)
		v.drawScaled(
			fx+(15*cos(angle)),
			fy+(15*sin(angle)),
			FU/3,
			v.cachePatch("TA_LIVESFILL_BALL"),
			flags,
			v.getColormap(0,SKINCOLOR_WHITE)
		)
	end
	
	v.drawScaled(x,
		y-(AngleFixed(sroll) == 0 and 4*FU or 0),
		scale/2,
		v.getSpritePatch(SPR_THND,F,0,sroll),
		flags
	)
	
	local scorenum = "CMBCF"
	local score = FixedInt(takis.accspeed)
	local prevw
	if not prevw then prevw = 0 end
	
	local textwidth = 0
	for i = 1,string.len(score)
		local n = string.sub(score,i,i)
		local patch = v.cachePatch(scorenum+n)
		textwidth = $+(patch.width*scale*4/10)		
	end
	
	for i = 1,string.len(score)
		local sc = FixedDiv(scale,2*FU)
		local n = string.sub(score,i,i)
		local patch = v.cachePatch(scorenum+n)
		--local textwidth = (patch.width*scale*4/10)
		v.drawScaled(x+prevw-(textwidth/2),
			y-(patch.height*sc)+6*FU-(FU/2),
			sc,
			patch,
			flags
		)
			
		prevw = $+(patch.width*scale*4/10)
	end
	local stats = {}
	if p.restat ~= nil
		stats[1],stats[2] = unpack(p.restat)
	else
		stats[1],stats[2] = unpack(car.stats)
	end
	v.drawString(x,y+4*FU,
		stats[1]..", "..stats[2],
		flags,
		"thin-fixed-center"
	)
	
	v.drawScaled(x-26*FU,y+4*FU - FU/2,
		FU/2,
		v.cachePatch("TA_KGEAR"),
		flags
	)
	v.drawString(x-20*FU,y+4*FU,
		car.gear,
		flags,
		"thin-fixed"
	)
	
	if car.inringslinger
		local percent = min( FixedDiv(max(p.rings,p.spheres)*FU,40*FU),FU)
		local x,y = 95*FU+minus,130*FU
		local color
		local segcolor = {73, 64, 52, 54, 55, 35, 34, 33, 202, 180, 181, 182, 164, 165, 166, 153, 152}
		
		local width = max(FixedMul(percent,29*FU)/FU, 0)
		local ring = min(max(p.rings,p.spheres),40)
		if ring > 0 and width == 0
			width = 1
		end
		
		local ind = (ring*(#segcolor))/(40+1)
		
		v.drawFill((x/FU)-27,((y/FU)),width,3,segcolor[max(ind-1,1)]|flags)
		v.drawFill((x/FU)-27,((y/FU))+1,width,1,segcolor[max(ind-2,1)]|flags)
		v.drawFill((x/FU)-27,((y/FU))+3,width,3,segcolor[max(ind,1)]|flags)
		
		local patch = "RINGA0"
		if p.spheres > p.rings
			patch = "SPHRA0"
		end
		
		v.drawScaled(x-35*FU,
			y+7*FU,
			FU/4,
			v.cachePatch(patch),
			flags
		)
		
		v.drawScaled(x-27*FU,
			y+FU,
			FU/2,
			v.cachePatch("TA_KRING_BAR"),
			flags
		)
	end
	
	if car.tiregrease
		local fill = v.cachePatch("TA_KGREASE_BAR")
		v.drawScaled(4*FU+minus,
			187*FU - textboxmoveup - (modeattacking and 20*FU or 0),
			FU/2,
			v.cachePatch("TA_KGREASE_ICO"),
			flags
		)
		local erm = FixedDiv(car.tiregrease,3*TR)
		local width = FixedMul(erm,fill.width*FU)
		if width < 0 then
			width = 0
		end
		
		v.drawCropped(23*FU+minus,191*FU - textboxmoveup - (modeattacking and 20*FU or 0),
			FU,FU,
			fill,
			flags, 
			nil,
			0,0,
			width,fill.height*FU
		)
	end
	
end

local function kartfuelometer(v,p,takis,car,minus)
	if not car.takiscar then return end
	
	local x,y = (hudinfo[HUD_LIVES].x+60)*FU+minus,(hudinfo[HUD_LIVES].y)*FU - textboxmoveup - (modeattacking and 20*FU or 0)
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
		x = $+25*FU
	end
	local jerry = v.cachePatch("TA_KFUEL_CAN")
	local needroll = 0
	local maxfuel = 100*FU
	local lev = 100*FU-car.fuel
	local fuel = FixedDiv(lev,maxfuel)
	local color = SKINCOLOR_SUPERSILVER1
	if (car.damagetic
	or car.fuel <= 25*FU)
	and (leveltime/2 % 2)
		color = SKINCOLOR_RED 
	end
	local colorm = v.getColormap(nil,color)
	needroll = (FixedAngle(180*FU-FixedMul(180*FU,fuel))-ANGLE_90)
	
	v.drawScaled(x,
		y-(jerry.height*FU/2)-(FU/2),
		FU/2,
		v.cachePatch("TA_KFUEL_CIRC"),
		flags,
		colorm
	)	
	v.drawScaled(x,
		y-(jerry.height*FU/2)-(FU/2),
		FU,
		v.cachePatch("TA_KFUEL_EF"),
		flags,
		colorm
	)	
	v.drawScaled(x,
		y-(jerry.height*FU/2)+FU-(AngleFixed(needroll) == 0 and 4*FU or 0),
		FU/2,
		v.getSpritePatch(SPR_THND,E,0,needroll),
		flags,
		colorm
	)
	v.drawScaled(x,
		y-(jerry.height*FU/2),
		FU/2,
		jerry,
		flags,
		colorm
	)	
end

local function drawminkartmeters(v,p,takis,car,minus)
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER) then return end
	
	local scale = FU
	local x = 3*FU + minus
	local y = 145*FU - textboxmoveup - (modeattacking and 20*FU or 0)
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_HUDTRANS
	
	v.drawScaled(x,y-3*FU,FU,
		v.cachePatch("TA_KART_BACKING3"),
		(flags &~V_HUDTRANS)|V_HUDTRANSHALF
	)
	
	local scorenum = "SCREFT"
	do
		local score = min(takis.accspeed/FU,999)
		if score == 0 then score = "*" end
		if (string.len(score) < 3)
			for i = 1,3 - string.len(score)
				score = "*"..$
			end
		end
		
		local align = "right"
		
		local width = FixedMul(string.len(score)*FU,7*FU)
		if align == "center"
			width = $/2
		elseif align ~= "right"
			width = 0
		end
		
		local prevw = 0
		
		for i = 1,string.len(score)
			local myflags = flags
			local n = string.sub(score,i,i)
			if n == "*"
				n = "0"
				myflags = $ &~V_HUDTRANS
				myflags = $|V_HUDTRANSHALF
			end
			
			v.drawScaled(x+(prevw*FU) - width + (43*FU),
				y,
				FU/2,
				v.cachePatch(scorenum+n),
				myflags
			)
			
			prevw = $+7
		end
		
		v.drawScaled(x+(prevw*FU) - width + (44*FU),
			y,
			FU/2,
			v.cachePatch(scorenum.."{"),
			flags
		)
	end
	
	v.drawScaled(x + 2*FU,
		y - FU,
		FU,
		v.cachePatch("TA_KGEAR"),
		flags
	)
	v.drawScaled(x + (12*FU),
		y,
		FU/2,
		v.cachePatch(scorenum+car.gear),
		flags
	)

	if car.inringslinger
		v.drawScaled(x,y-24*FU,FU,
			v.cachePatch("TA_KART_BACKING3"),
			(flags &~V_HUDTRANS)|V_HUDTRANSHALF
		)
		
		local xoffset = 17
		local yoffset = 17
		
		local percent = min( FixedDiv(max(p.rings,p.spheres)*FU,40*FU),FU) 
		local color
		local segcolor = {73, 64, 52, 54, 55, 35, 34, 33, 202, 180, 181, 182, 164, 165, 166, 153, 152}
		
		local width = max(FixedMul(percent,29*FU)/FU, 0)
		local ring = min(max(p.rings,p.spheres),40)
		if ring > 0 and width == 0
			width = 1
		end
		
		local ind = (ring*(#segcolor))/(40+1)
		
		v.drawFill((x/FU)+xoffset,((y/FU) - yoffset),width,3,segcolor[max(ind-1,1)]|flags)
		v.drawFill((x/FU)+xoffset,((y/FU) - yoffset)+1,width,1,segcolor[max(ind-2,1)]|flags)
		v.drawFill((x/FU)+xoffset,((y/FU) - yoffset)+3,width,3,segcolor[max(ind,1)]|flags)
		
		local patch = "RINGA0"
		if p.spheres > p.rings
			patch = "SPHRA0"
		end
		
		v.drawScaled(x + (xoffset-7)*FU,
			y - (yoffset*FU) + 6*FU,
			FU/4,
			v.cachePatch(patch),
			flags
		)
		
		v.drawScaled(x + xoffset*FU,
			y - (yoffset*FU),
			FU/2,
			v.cachePatch("TA_KRING_BAR"),
			flags
		)
	end
	
	if car.takiscar
		local color = SKINCOLOR_GOLD
		local pre = "CLTCHBAR_"
		local myx = x + 10*FU
		
		if (car.damagetic
		or car.fuel <= 25*FU)
		and (leveltime/2 % 2)
			color = SKINCOLOR_RED
		end
		
		v.drawCropped(myx,
			y + 13*FU,
			scale,scale,
			v.cachePatch(pre.."BACK"),
			flags, 
			nil,
			0,0,
			v.cachePatch(pre.."FILL").height*8/10*FU,v.cachePatch(pre.."FILL").height*FU
		)
		
		local max = 100*FU
		local timer2 = car.fuel
		local scale = FU
		
		local erm = FixedDiv((timer2),max)
		local width = FixedMul(erm,v.cachePatch(pre.."FILL").width*FU)
		if width < 0 then
			width = 0
		end
		
		v.drawCropped(myx,
			y + 13*FU,
			scale,scale,
			v.cachePatch(pre.."FILL"),
			flags, 
			v.getColormap(nil,color),
			0,0,
			width*8/10,v.cachePatch(pre.."FILL").height*FU
		)
		
	end
	
end

local function kartminimap(v,p)
	if not v.patchExists(G_BuildMapName(gamemap).."R")
	or leveltime
		return
	end
	
	local mx,my
	local maptrans = V_50TRANS
	
	local mm_x = (320)-50
	local mm_y = (200/2)-16
	
	local mpatch = v.cachePatch(G_BuildMapName(gamemap).."R")
	
	mx = mm_x - (mpatch.width/2)
	my = mm_y - (mpatch.height/2)
	
	mx = $-(mpatch.leftoffset*FU)
	my = $-(mpatch.topoffset*FU)

	local mx2,my2
	mx2 = mx + (mpatch.width/2)
	my2 = my + (mpatch.height/2)
	
	v.drawScaled(mx*FU,
		my*FU,
		FU,
		mpatch,
		maptrans|V_SNAPTORIGHT
	)
	
	local posx = (mx2*FU)+(p.mo.x/1000)
	local posy = (my2*FU)+(p.mo.y/1000)
	
	v.drawScaled(posx,posy,FU/2,v.cachePatch("MISSING"),V_SNAPTORIGHT)
	
	/*
	local x,y,scale
	local patch
	local colormap
	
	local mpatch
	
	local mm_x,mm_y
	
	local anumxpos,anumypos
	local amxpos,amypos
	
	local maxx,maxy,minx,miny
	
	local mapwidth,mapheight
	local xoffset,yoffset
	local xscale,yscale,zoom
	local patchw,patchh
	
	x,y,scale = p.mo.x, p.mo.y, FU
	patch = v.cachePatch("MISSING")
	
	mm_x = (320)-50
	mm_y = (200/2)-16
	
	mpatch = v.cachePatch(G_BuildMapName(gamemap).."R")
	
	mx = mm_x - (mpatch.width/2)
	my = mm_y - (mpatch.height/2)
	
	mx = $-(mpatch.leftoffset*FU)
	my = $-(mpatch.topoffset*FU)
	
	maxx,maxy = INT32_MAX,INT32_MAX
	minx,miny = INT32_MIN,INT32_MIN
	
	maxx = $ >> FRACBITS
	maxy = $ >> FRACBITS
	minx = $ >> FRACBITS
	miny = $ >> FRACBITS
	
	mapwidth = maxx-minx
	mapheight = maxy-miny
	
	xoffset = (minx + mapwidth/2)<<FRACBITS
	yoffset = (miny + mapheight/2)<<FRACBITS
	
	xscale = FixedDiv(mpatch.width,mapwidth)
	yscale = FixedDiv(mpatch.height,mapheight)
	zoom = FixedMul(min(xscale,yscale),FU-(FU/20))
	
	anumxpos = (FixedMul(x, zoom) - FixedMul(xoffset, zoom))
	anumypos = (FixedMul(y, zoom) - FixedMul(yoffset, zoom))
	
	patchw = patch.width*scale/2
	patchh = patch.height*scale/2
	
	amxpos = anumxpos + ((mx + mpatch.width/2)<<FRACBITS) - patchw
	amypos = anumypos + ((my + mpatch.height/2)<<FRACBITS) - patchh
	
	print(L_FixedDecimal(amxpos))
	
	v.drawScaled(mx*FU,my*FU,FU,mpatch,maptrans|V_SNAPTORIGHT,colormap)
	v.drawScaled(mx*FU,my*FU,scale,patch,V_SNAPTORIGHT,colormap)
	*/
	
end

local function drawkartmeters(v,p)
	if (customhud.CheckType("takis_kart_meters") != modname) return end	
	
	local takis = p.takistable
	local me = p.realmo	
	
	--if p.textBoxInAction then return end
	if not p.inkart then return end
	if not (me.tracer and me.tracer.valid) then return end
	local car = me.tracer
	if car.type ~= MT_TAKIS_KART_HELPER then return end
	
	kartminimap(v,p)
	
	local minx = -55*FU
	local maxx = 12*FU
	local x = maxx
	local y = 128*FU - textboxmoveup - (modeattacking and 20*FU or 0)
	if p.kartingtime < TR/2
		local etin = TR/2
		local intic = p.kartingtime
		
		x = ease.outback((FU/etin)*intic,minx, maxx, FU*3/2)
		
	end
	if not (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
	and not takis.HUD.lives.nokarthud
		local patchname = ((car.takiscar or car.inringslinger) and "TA_KART_BACKING" or "TA_KART_BACKING2")
		v.drawScaled(x,y,FU,
			v.cachePatch(patchname),
			V_HUDTRANSHALF|V_SNAPTOLEFT|V_SNAPTOBOTTOM
		)
	end
	
	if takis.HUD.lives.nokarthud
		drawminkartmeters(v,p,takis,car,x-3*FU)
		return
	end
	
	kartspeedometer(v,p,takis,car,x-3*FU)
	kartfuelometer(v,p,takis,car,x-3*FU)
		
end


local function drawlapanim(v,p)
	local takis = p.takistable
	local me = p.realmo	
	local lapanim = takis.HUD.lapanim
	local x = 160*FU
	local y = 60*FU
	local tween = 0
	local et = 20
	local maxlaps = lapanim.maxlaps
	
	if lapanim.tics == 0 then return end
	
	if lapanim.tics >= 80-(et/2)
		et = $/2
		tween = ease.outquad((FU/et)*(et-(lapanim.tics-(80-et))), 300*FU, 0)	
	elseif lapanim.tics <= et
		tween = ease.inback((FU/et)*(et-lapanim.tics),
			0,
			-300*FU,
			FU*2
		)
	end
	x = $+tween
	
	local lastlap = lapanim.lapnum == maxlaps
	
	v.drawScaled(x,
		y,
		FU,
		lastlap and v.cachePatch("TA_LAPANIM_TXT2") or v.cachePatch("TA_LAPANIM_TXT1"),
		V_SNAPTOTOP|V_HUDTRANS,
		v.getColormap(nil,p.skincolor)
	)
	
	local waveforce = FU*2
	local thumbsine = FixedMul(waveforce,sin(leveltime*ANG15))
	v.drawScaled(x,
		y+thumbsine,
		FU,
		(isplayerlosing(p) and v.cachePatch("TA_LAPANIM_BAD") or v.cachePatch("TA_LAPANIM_GOOD")),
		V_SNAPTOTOP|V_HUDTRANS,
		v.getColormap(nil,p.skincolor)
	)
	
	local time = lapanim.time
	local min = G_TicsToMinutes(time,true)
	local sec = G_TicsToSeconds(time)
	local cen = G_TicsToCentiseconds(time)
	local timestr = tostring(min)..":"..(sec < 10 and "0" or '')..tostring(sec).."."..(cen < 10 and "0" or '')..tostring(cen)
	
	v.drawString(x,y+15*FU,
		timestr,
		V_SNAPTOTOP|V_HUDTRANS|((lapanim.tics/2 % 2) and V_YELLOWMAP or V_ORANGEMAP),
		"fixed-center"
	)
	
	if not lastlap
		local scorenum = "CMBCF"
		local score = lapanim.lapnum
		if score < 10
			score = "0"..$
		end
		local scale = FU*2
		
		local prevw
		if not prevw then prevw = 0 end
		
		local textwidth = 0
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			textwidth = $+(patch.width*scale*4/10)		
		end
		
		for i = 1,string.len(score)
			local sc = FixedDiv(scale,2*FU)
			local n = string.sub(score,i,i)
			local patch = v.cachePatch(scorenum+n)
			--local textwidth = (patch.width*scale*4/10)
			v.drawScaled(x+prevw-textwidth+60*FU,
				y-(patch.height*sc)+16*FU,
				sc,
				patch,
				V_SNAPTOTOP|V_HUDTRANS
			)
				
			prevw = $+(patch.width*scale*4/10)
		end
	end
	
end

local function drawracelaps(v,p)
	if (customhud.CheckType("takis_racelaps") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not (gametyperules & GTR_RACE) then return end
	if not circuitmap then return end
	if (circredux) then return end
	
	local lapflag = v.cachePatch("TA_LAPFLAG")
	local scale = 3*FU/5
	v.drawScaled(160*FU-(lapflag.width*3*FU/5/2),
		170*FU,
		scale,
		lapflag,
		V_HUDTRANS|V_SNAPTOBOTTOM
	)
	v.drawString(160*FU,
		160*FU,
		"Laps",
		V_YELLOWMAP|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,
		"thin-fixed-center"
	)
	
	local maxlaps = CV_FindVar("numlaps").value
	if p.laps ~= maxlaps
		local map = (p.laps == maxlaps-1 
			and leveltime/4 & 1 
			and p.starpostnum == TAKIS_NET.maxpostcount
			and not isplayerlosing(p)
		) and V_YELLOWMAP or V_PURPLEMAP
		
		v.drawString(160*FU,
			177*FU,
			(p.laps+1).."/"..maxlaps,
			map|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,
			"fixed-center"
		)
	else
		v.drawString(160*FU,
			177*FU,
			"Finished!",
			V_YELLOWMAP|V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM|V_RETURN8,
			"fixed-center"
		)	
	end
	
end

--lmao lol
local numtotrans = {
	[9] = V_90TRANS,
	[8] = V_80TRANS,
	[7] = V_70TRANS,
	[6] = V_60TRANS,
	[5] = V_50TRANS,
	[4] = V_40TRANS,
	[3] = V_30TRANS,
	[2] = V_20TRANS,
	[1] = V_10TRANS,
	[0] = 0,
}

--rsneo
local function drawviewmodel(v,p,cam)
	if (customhud.CheckType("takis_viewmodel") != modname) return end	
	
	/*
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	*/
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not (me and me.valid) then return end
	
	if cam.chase
		return
	end
	
	if (p.awayviewtics and not (takis.in2D))
		return
	end
	
	if p.spectator then return end
	
	if (p.inkart)
	and (me.tracer and me.tracer.valid)
		local car = me.tracer
		local yoff = FixedDiv(me.momz*takis.gravflip,me.scale)/2 - me.spriteyoffset*2
		
		local tirefr = M
		--idling
		if car.animstate == 0
			tirefr = ((leveltime % 2) and O or M)
			yoff = $ - (leveltime % 2)*FU
		--slow/fast
		else --if car.animstate
			if leveltime % 2
				if car.animstate == 1
					yoff = $ - 2*FU
				end
				tirefr = N
			end
		end
		
		local turnang = (car.rmomt*2)/FU*ANG1
		local sloperoll = 0 --FixedMul(me.pitch,-sin(me.angle)) + FixedMul(me.roll,cos(me.angle))
		--sloperoll = $*takis.gravflip
		
		local patch = v.getSpritePatch(SPR_THND,K,0,
			sloperoll + turnang
		)
		/*
		local steeringp = v.getSpritePatch(SPR_THND,L,0,
			sloperoll
		)
		*/
		local tirepatch = v.getSpritePatch(SPR_THND,tirefr,0,
			sloperoll
		)
		
 		local offset = P_ReturnThrustY(nil,(me.angle /*TakisMomAngle(me,p.drawangle)*/ - p.drawangle),30*FU)		
		
		local x, y
		x = 160*FU + offset + me.spritexoffset*2
		y = 205*FU + max(yoff, -12*FU)
		offset = -FixedMul(sin(turnang), 10*me.spritexscale)
		
		local cmap
		if (me.colorized)
			cmap = v.getColormap(TC_RAINBOW,me.color)
		end
		if (TakisKart_DriftLevel(car.stats,car.driftspark) > 1)
		and (leveltime/2) & 1
			cmap = v.getColormap(TC_RAINBOW,TakisKart_DriftColor(TakisKart_DriftLevel(car.stats,car.driftspark)))
		end
		
		
		if not splitscreen
			v.drawStretched(x,y,
				me.spritexscale,me.spriteyscale,
				tirepatch,
				V_SNAPTOBOTTOM|V_PERPLAYER,
				cmap and cmap or v.getColormap(nil,me.color)
			)
			/*
			v.drawStretched(x,y,
				me.spritexscale,me.spriteyscale,
				tirepatch,
				V_SNAPTOBOTTOM|V_PERPLAYER|V_FLIP,
				cmap
			)
			
			v.drawStretched(x,y,
				me.spritexscale,me.spriteyscale,
				steeringp,
				V_SNAPTOBOTTOM|V_PERPLAYER,
				cmap and cmap or v.getColormap(nil,me.color)
			)
			*/
			v.drawStretched(x + offset, y,
				me.spritexscale,me.spriteyscale,
				patch,
				V_SNAPTOBOTTOM|V_PERPLAYER,
				cmap
			)
			
			
		end
		return
	end
	
	local col = v.getColormap((me.colorized and TC_RAINBOW or TC_DEFAULT), me.color)
	local x, y
	if (takis.transfo & TRANSFO_SHOTGUN)
	
		local framenum = (takis.HUD.viewmodel.frameinc/4)+1
		local patch = v.cachePatch("TA_VIEW_"..framenum)
		local scale = FU
		
		local offsety = takis.HUD.viewmodel.boby
		offsety = max($,-18*FU)
		/*
		local offsetx = takis.HUD.viewmodel.bobx
		
		do
			local lastangle = viewingangles[p] or 0
			local myangle = p.cmd.angleturn << 16
			
			local adjust = (lastangle - myangle)
			
			adjust = ($/ANG1)*FU
			adjust = clamp(-30*FU,$,30*FU) --max(-30*FU,min($,30*FU))
			offsetx = $ - adjust --(lastangle - myangle)
		end
		do
			local lastaim = aimingangles[p] or 0
			local myaim = p.aiming
			
			local adjust = (lastaim - myaim)
			
			adjust = ($/ANG1)*FU
			adjust = max(-30*FU,min($,30*FU))
			offsety = $ - adjust
			
		end
		viewingangles[p] = p.cmd.angleturn << 16
		aimingangles[p] = p.cmd.aiming
		*/
		
		x = 32*FU + takis.HUD.viewmodel.bobx
		y = 48*FU + offsety 
		
		if not splitscreen
			v.drawScaled(x,
				y,
				scale,
				patch,
				V_SNAPTOBOTTOM|V_PERPLAYER,
				col
			)
			
			if takis.afterimaging
				local timealive = TR-takis.bashtics
				local transnum = numtotrans[((timealive*2/3)+1) %9]
				col = v.getColormap(TC_RAINBOW,takis.afterimagecolor)
				v.drawScaled(x,
					y,
					scale,
					patch,
					V_SNAPTOBOTTOM|V_PERPLAYER|V_ADD|transnum,
					col
				)
			end
		end
		
		if takis.inBattle
			v.drawScaled(152*FU,
				185*FU + (leveltime/3 & 1)*FU ,
				FU,
				v.cachePatch("TA_SHOTGUNSH"),
				V_SNAPTOBOTTOM|V_PERPLAYER
			)
			v.drawString(165,190,
				3 - takis.shotgunshots,
				V_SNAPTOBOTTOM|V_PERPLAYER|((takis.shotgunshots >= 2 and (leveltime/3 & 1)) and V_REDMAP or 0),
				"thin"
			)
		end
	else
		if not (G_RingSlingerGametype()
		or takis.inSRBZ
		or p.powers[pw_shield] & SH_FIREFLOWER
		or (takis.transfo & TRANSFO_FIREASS))
			return
		end
		--rsneo has its own
		if RingSlinger then return end
		
		local currentweapon = takis.currentweapon
		local mm = gametype == GT_MURDERMYSTERY
		local role = p.role or 0
		if (takis.weapondelaytics)
			currentweapon = "FIRE"
		end
		local patch = v.cachePatch("TA_VIEWR_"..currentweapon)
		local scale = FU
		
		x = 208*FU + takis.HUD.viewmodel.bobx
		y = 80*FU + takis.HUD.viewmodel.boby
		
		if not splitscreen
			v.drawScaled(x,
				y,
				scale,
				patch,
				V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_PERPLAYER,
				col
			)
			
			/*
			if (takis.currentweapon == 0
			or takis.currentweapon == 1
			or takis.currentweapon == 4
			or takis.current)
			*/
			if v.patchExists("TA_VIEWR_"..currentweapon.."R")
			and not takis.weapondelaytics
				col = nil
				if takis.currentweapon == 0
					col = v.getColormap(nil,G_GametypeHasTeams() and (p.ctfteam == 1 and skincolor_redring or skincolor_bluering) or SKINCOLOR_RED)
				end
				v.drawScaled(x,
					y,
					scale,
					v.cachePatch("TA_VIEWR_"..takis.currentweapon.."R"),
					V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_PERPLAYER,
					col
				)
			
			end
			
		end
		
		
	end
end

/*
local function drawtransfotimer(v,p,cam)
	if (customhud.CheckType("takis_transfotimer") != modname) return end	
	
	if (skins[p.skin].name ~= TAKIS_SKIN)
		return
	end
	
	local takis = p.takistable
	local me = p.realmo	
	
	if not (takis.flamedash)
		return
	end
	
	local fillpercent = FixedMul(120*FU,FixedDiv(takis.flamedash,100*FU))
	fillpercent = 121 - FixedInt($)
	if fillpercent <= 0
		return
	end
	if string.len(tostring(fillpercent)) < 3
		for i = 1,3 - string.len(tostring(fillpercent))
			fillpercent = "0"..$
		end
	end
	local pre = "FSMFG"
	local flip = 1
	local back = v.cachePatch("FSMBG001")
	local fill = v.cachePatch(pre..fillpercent)
	local x, y, scale, nodraw
	local cutoff = function(y) return false end
	local side = false
	
	if cam.chase and not (p.awayviewtics and not takis.in2D)
		x, y, scale, nodraw = R_GetScreenCoords(v, p, cam, me)
		if nodraw then return end
		
		scale = $*2
		if me.eflags & MFE_VERTICALFLIP
		and p.pflags & PF_FLIPCAM
			y = 200*FRACUNIT - $
		else
			flip = P_MobjFlip(me)
		end
		scale = FixedMul($,me.scale)
	else
		x, y, scale, side = 160*FRACUNIT, (130 - back.height >> 1)*FRACUNIT, FRACUNIT*2, true
	end
	
	scale = FixedDiv($,2*FU)
	scale = $*2
	
	if splitscreen
		if p == secondarydisplayplayer
			cutoff = function(y) return y < (back.height*scale >> 1) end
		else
			cutoff = function(y) return y > 200*FRACUNIT + (back.height*scale >> 1) end
		end
	end
	
	if not cutoff(y)
		
		local snap = side and V_SNAPTOLEFT or 0
		
		x = $ - (back.width*scale/2)
		y = $ - (back.height*scale/2) - 10*scale
		
		v.drawScaled(x, y, scale, back, snap|V_PERPLAYER|V_HUDTRANS)
		if v.patchExists(pre..fillpercent)
			v.drawScaled(x, y, scale, fill, snap|V_PERPLAYER|V_HUDTRANS)
		end
	end
	
end
*/

/*
local function drawbubbles(v,p,cam)
	--chrispy chars
	local player = p
	local mo = player.mo
	
	local flip = 1
	local bubble = v.cachePatch("TA_BUBBLE")
	local angdiff = ANGLE_90
	local x, y, scale
	local cutoff = function(y) return false end
	
	if cam.chase and not (player.awayviewtics and not (me.flags2 & MF2_TWOD))
		x, y, scale = R_GetScreenCoords(v, player, cam, mo)
		x = $+(10*scale)
		if mo.eflags & MFE_VERTICALFLIP
		and player.pflags & PF_FLIPCAM
			y = 200*FRACUNIT - $
		else
			flip = P_MobjFlip(mo)
		end
	else
		x, y, scale = 160*FRACUNIT, (100 + bubble.height >> 1)*FRACUNIT, FRACUNIT/3
	end
	
	if splitscreen
		if player == secondarydisplayplayer
			cutoff = function(y) return y < (bubble.height*scale >> 1) end
		else
			cutoff = function(y) return y > 200*FRACUNIT + (bubble.height*scale >> 1) end
		end
	end
	
	local angle = angdiff - ANGLE_90
	local x = x - P_ReturnThrustX(nil, angle, 50*scale)
	local y = y - flip*P_ReturnThrustY(nil, angle, 64*scale)
		
	if not cutoff(y)
	and p.powers[pw_underwater]
		local j = -1
		for i = -3,2
			j = $+1
			local flag = V_HUDTRANSHALF
			if j-1 < p.powers[pw_underwater]/TR/5
				flag = V_HUDTRANS
			end
			v.drawScaled(x, y+(i*25*scale), scale, bubble, V_PERPLAYER|flag)
		end
	end
end
*/

local function DrawButton(v, player, x, y, flags, color, color2, butt, release, symb, strngtype)
-- Buttons! Shows input controls.
-- butt parameter is the button cmd in question.
-- symb represents the button via drawn string.
	
	if release == nil then release = 0 end
	
	local offs, col
	if (butt >= 1) then
		if (butt == 1)
			offs = -1
			col = flags|color2
		else
			offs = 0
			col = flags|color
		end
	else
		offs = (release == 0) and 1 or 0
		col = flags|16
		v.drawFill(
			(x), (y+9),
			10, 1, flags|29
		)
	end
	v.drawFill(
		(x), (y)-offs,
		10, 10,	col
	)
	
	local stringx, stringy = 1, 1
	if (strngtype == 'thin') then
		stringx, stringy = 0, 2
	end
	
	v.drawString(
		(x+stringx), (y+stringy)-offs,
		symb, flags, strngtype
	)
end

local musname
addHook("ThinkFrame",do
	musname = S_MusicName()
end)

local getpstate = {
	[0] = "PST_LIVE",
	[1] = "PST_DEAD",
	[2] = "PST_REBORN",
}
local getdmg = {
	[0] = "None",
	[1] = "DMG_WATER",
	[2] = "DMG_FIRE",
	[3] = "DMG_ELECTRIC",
	[4] = "DMG_SPIKE",
	[5] = "DMG_NUKE",
	[128] = "DMG_INSTAKILL",
	[129] = "DMG_DROWNED",
	[130] = "DMG_SPACEDROWN",
	[131] = "DMG_DEATHPIT",
	[132] = "DMG_CRUSHED",
	[133] = "DMG_SPECTATOR",
}

local getcarry = {
	[0] = "none",
	[1] = "generic",
	[2] = "player",
	[3] = "nightsmode",
	[4] = "nightsfall",
	[5] = "brakgoop",
	[6] = "zoomtube",
	[7] = "ropehang",
	[8] = "macespin",
	[9] = "minecart",
	[10] = "rollout",
	[11] = "pterabyte",
	[12] = "dustdevil",
	[13] = "fan",
	[20] = "kart",
}
local charabilites = {
	[0] = "CA_NONE",
	[1] = "CA_THOK",
	[2] = "CA_FLY",
	[3] = "CA_GLIDEANDCLIMB",
	[4] = "CA_HOMINGTHOK",
	[5] = "CA_SWIM",
	[6] = "CA_DOUBLEJUMP",
	[7] = "CA_FLOAT",
	[8] = "CA_SLOWFALL",
	[9] = "CA_TELEKINESIS",
	[10] = "CA_FALLSWITCH",
	[11] = "CA_JUMPBOOST",
	[12] = "CA_AIRDRILL",
	[13] = "CA_JUMPTHOK",
	[14] = "CA_BOUNCE",
	[15] = "CA_TWINSPIN",
}
local charabilites2 = {
	[0] = "CA2_NONE",
	[1] = "CA2_SPINDASH",
	[2] = "CA2_GUNSLINGER",
	[3] = "CA2_MELEE",
}

local function drawflag(v,x,y,string,flags,onmap,offmap,align,flag)
	local map = offmap
	if flag
		map = onmap
	end
	
	v.drawString(x,y,string,flags|map,align)
end

local function drawdebug(v,p)
	local takis = p.takistable
	local me = p.mo
	
	if not TAKIS_ISDEBUG
		return
	end
	
	if (TAKIS_DEBUGFLAG & DEBUG_BUTTONS)
		local x, y = 15, hudinfo[HUD_LIVES].y
		local flags = V_HUDTRANS|V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTOLEFT
		local color = (p.skincolor and skincolors[p.skincolor].ramp[4] or 0)
		local color2 = (ColorOpposite(p.skincolor) and skincolors[ColorOpposite(p.skincolor)].ramp[4] or 0)
		DrawButton(v, p, x, y, flags, color, color2, takis.jump, takis.jump_R, 'J', 'left')
		DrawButton(v, p, x+11, y, flags, color, color2, takis.use, takis.use_R, 'S', 'left')
		DrawButton(v, p, x+22, y, flags, color, color2, takis.tossflag, takis.tossflag_R, 'TF', 'thin')
		DrawButton(v, p, x+33, y, flags, color, color2, takis.c1, takis.c1_R, 'C1', 'thin')
		DrawButton(v, p, x+44, y, flags, color, color2, takis.c2, takis.c2_R, 'C2', 'thin')
		DrawButton(v, p, x+55, y, flags, color, color2, takis.c3, takis.c3_R, 'C3', 'thin')
		DrawButton(v, p, x+66, y, flags, color, color2, takis.fire, takis.fire_R, 'F', 'left')
		DrawButton(v, p, x+77, y, flags, color, color2, takis.firenormal, takis.firenormal_R, 'FN', 'thin')
		DrawButton(v, p, x+88, y, flags, color, color2, takis.weaponmasktime,takis.weaponmasktime_R, takis.weaponmask, 'left')
		
		--these arent really flags so it wouldnt make sense to draw them like they are
		v.drawString(x,y-128,"pw_carry",flags,"thin")
		v.drawString(x,y-120,getcarry[p.powers[pw_carry]] or "Unknown",flags,"thin")
		
		v.drawString(x,y-108,"pw_strong",flags,"thin")
		drawflag(v,x+00,y-100,"NN",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_NONE))
		drawflag(v,x+15,y-100,"AN",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_ANIM))
		drawflag(v,x+30,y-100,"PN",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_PUNCH))
		drawflag(v,x+45,y-100,"TL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_TAIL))
		drawflag(v,x+60,y-100,"ST",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_STOMP))
		drawflag(v,x+75,y-100,"UP",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_UPPER))
		drawflag(v,x+90,y-100,"GD",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_GUARD))
		--line 2
		drawflag(v,x+00,y-90,"HV",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_HEAVY))
		drawflag(v,x+15,y-90,"DS",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_DASH))
		drawflag(v,x+30,y-90,"WL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_WALL))
		drawflag(v,x+45,y-90,"FL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_FLOOR))
		drawflag(v,x+60,y-90,"CL",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_CEILING))
		drawflag(v,x+75,y-90,"SP",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_SPRING))
		drawflag(v,x+90,y-90,"SK",flags,V_GREENMAP,V_REDMAP,"thin",(p.powers[pw_strong] & STR_SPIKE))
		
		v.drawString(x,y-78,"transfo",flags|V_GREENMAP,"thin")
		drawflag(v,x+00,y-70,"SG",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_SHOTGUN))
		drawflag(v,x+15,y-70,"BL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_BALL))
		drawflag(v,x+30,y-70,"PC",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_PANCAKE))
		drawflag(v,x+45,y-70,"EL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_ELEC))
		drawflag(v,x+60,y-70,"TR",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_TORNADO))
		drawflag(v,x+75,y-78,
			FixedMul(FixedDiv(takis.fireasstime*FU,TAKIS_MAX_TRANSFOTIME*FU),100*FU)/FU.."%",
		flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_FIREASS))
		drawflag(v,x+75,y-70,"FA",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_FIREASS))
		drawflag(v,x+90,y-70,"MT",flags,V_GREENMAP,V_REDMAP,"thin",(takis.transfo & TRANSFO_METAL))
		
		v.drawString(x,y-58,"noability",flags|V_GREENMAP,"thin")
		drawflag(v,x+00,y-50,"CL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_CLUTCH))
		drawflag(v,x+15,y-50,"HM",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_HAMMER))
		drawflag(v,x+30,y-50,"DI",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_DIVE))
		drawflag(v,x+45,y-50,"SL",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SLIDE))
		drawflag(v,x+60,y-50,"WD",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_WAVEDASH))
		drawflag(v,x+75,y-50,"SG",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SHOTGUN))
		drawflag(v,x+75,y-58,"FO",flags,V_GREENMAP,V_REDMAP,"thin",(takis.shotgunforceon))
		drawflag(v,x+90,y-50,"SH",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_SHIELD))
		drawflag(v,x+105,y-50,"TH",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_THOK))
		drawflag(v,x+120,y-50,"AI",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_AFTERIMAGE))
		drawflag(v,x+135,y-50,"MT",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_MOBILETAUNT))
		drawflag(v,x+150,y-50,"TR",flags,V_GREENMAP,V_REDMAP,"thin",(takis.noability & NOABIL_TRANSFO))
		
		v.drawString(x,y-38,"FSTASIS",flags|V_GREENMAP,"thin")
		v.drawString(x,y-30,takis.stasistic,flags,"thin")
		
		v.drawString(x+60,y-38,"stasis",flags,"thin")
		drawflag(v,x+60,y-30,"FS",flags,V_GREENMAP,V_REDMAP,"thin",(p.pflags & PF_FULLSTASIS))
		drawflag(v,x+78,y-30,"JS",flags,V_GREENMAP,V_REDMAP,"thin",(p.pflags & PF_JUMPSTASIS))
		drawflag(v,x+96,y-30,"SS",flags,V_GREENMAP,V_REDMAP,"thin",(p.pflags & PF_STASIS))
		
		v.drawString(x,y-18,"nocontrol",flags|V_GREENMAP,"thin")
		v.drawString(x,y-10,takis.nocontrol,flags,"thin")
		
		v.drawString(x+60,y-18,"nocontrol",flags,"thin")
		v.drawString(x+60,y-10,p.powers[pw_nocontrol],flags,"thin")
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_STATE)
		local pstate = getpstate[p.playerstate]
		local dmg = getdmg[takis.saveddmgt]
		
		if (me and me.valid)
			v.drawString(100,100,"State: "..me.state,V_ALLOWLOWERCASE,"thin")
			drawflag(v,100,108,"Sprite2: "..spr2names[me.sprite2 &~FF_SPR2SUPER],V_ALLOWLOWERCASE,V_YELLOWMAP,0,"thin",(me.sprite2 & FF_SPR2SUPER))
			v.drawString(100,116,"PState: "..pstate,V_ALLOWLOWERCASE,"thin")
			v.drawString(100,124,"Deadtimer: "..p.deadtimer,V_ALLOWLOWERCASE,"thin")
			v.drawString(100,132,"DMG: "..dmg ,V_ALLOWLOWERCASE,"thin")
			drawflag(v,100,140,"TDeadtimer: "..takis.deadtimer,V_ALLOWLOWERCASE,V_GREENMAP,0,"thin",(takis.freezedeath))
			v.drawString(100,148,"Rollangle: "..string.format("%f",AngleFixed(me.rollangle)),V_ALLOWLOWERCASE,"thin")
			v.drawString(100,156,"Tics: "..me.tics,V_ALLOWLOWERCASE,"thin")
			
			drawflag(v,200,100,"Pain",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inPain))
			drawflag(v,200,108,"FakePain",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inFakePain))
			drawflag(v,200,116,"WaterSlide",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.inwaterslide))
			drawflag(v,200,124,"WasWaterSlide",V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.wasinwaterslide))
			drawflag(v,200,132,"TicsForPain: "..takis.ticsforpain,V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.ticsforpain > 0))
			drawflag(v,200,140,"TicsInPain: "..takis.ticsinpain,V_PERPLAYER|V_ALLOWLOWERCASE,V_GREENMAP,V_REDMAP,"thin",(takis.ticsinpain > 0))
			v.drawString(200,148,"Pitanim: "..takis.pitanim,V_PERPLAYER|V_ALLOWLOWERCASE,"thin")
			v.drawString(200,156,"Pittime,Count: "..takis.pittime..","..takis.pitcount,V_PERPLAYER|V_ALLOWLOWERCASE,"thin")
		else
			v.drawString(100,100,
				"Player mobj not valid!!",
				V_ALLOWLOWERCASE,
				"thin"
			)
		end
	end
	if (TAKIS_DEBUGFLAG & DEBUG_ACH)
		for k,va in ipairs(takis.HUD.steam)
			if va == nil
				continue
			end
			
			local t = TAKIS_ACHIEVEMENTINFO
			v.drawString(165,k*8,t[va.enum].name,
				V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOTOP,
				"thin"
			)
		end
		local work = 0
		for p2 in players.iterate
			local extra = ''
			if p2.takistable.achbits
				extra = " ("..p2.takistable.achbits..")"
			end
			v.drawString(290,30+(work*8),
				"[#"..#p2.."] "..p2.name.." - "..p2.takistable.achfile..extra,
				V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE|
				((p2 == p) and V_YELLOWMAP or 0),
				"thin-right"
			)
			work = $+1
		end
		v.drawString(290,30+(work*8),
			"\x8EusedCheats\x80:\x84 "..tostring(usedCheats),
			V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE,
			"thin-right"
		)
		v.drawString(290,38+(work*8),
			"TAKIS_NET.usedcheats:\x84 "..tostring(TAKIS_NET.usedcheats),
			V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE,
			"thin-right"
		)
		v.drawString(290,46+(work*8),
			"TAKIS_NET.achtime:\x84 "..TAKIS_NET.achtime,
			V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE,
			"thin-right"
		)
	end
	if (TAKIS_DEBUGFLAG & DEBUG_QUAKE)
		local red = (not takis.io.quakes) and V_REDMAP or 0
		for k,va in ipairs(takis.quake)
			if va == nil
				continue
			end
			
			v.drawString(40,8*(k-1),
				va.tics.." | "..
				L_FixedDecimal(va.intensity,3)..
				((va.id ~= nil) and (" - "..va.id) or ''),
				red|V_HUDTRANS|V_ALLOWLOWERCASE,
				"left"
			)
		end
		v.drawString(40,-8,L_FixedDecimal(takis.quakeint,3),red|V_HUDTRANS,"left")
	end
	if (TAKIS_DEBUGFLAG & DEBUG_HAPPYHOUR)
		local strings = Tprtable("Happy Hour",HAPPY_HOUR,false)
		for k,va in ipairs(strings)
			v.drawString(100,30+(8*(k-1)),va,V_ALLOWLOWERCASE,"thin")
		end
		
		local dh = {}
		dh.x = tonumber(mapheaderinfo[gamemap].takis_hh_exit_x)
		dh.y = tonumber(mapheaderinfo[gamemap].takis_hh_exit_y)
		dh.z = tonumber(mapheaderinfo[gamemap].takis_hh_exit_z)
		for k,v in pairs(dh)
			if v == nil
				dh.valid = false
				break
			else
				dh.valid = true
				continue
			end
		end
		local th = {}
		th.x = tonumber(mapheaderinfo[gamemap].takis_hh_trig_x)
		th.y = tonumber(mapheaderinfo[gamemap].takis_hh_trig_y)
		th.z = tonumber(mapheaderinfo[gamemap].takis_hh_trig_z)
		th.flip = mapheaderinfo[gamemap].takis_hh_trig_flip ~= nil
		for k,v in pairs(th)
			if type(v) == "boolean" then continue end
			if v == nil
				th.valid = false
				break
			else
				th.valid = true
				continue
			end
		end
		
		v.drawString(100,
			30+(8*(#strings)),
			"door: {x="..(dh.x or "nil")..",y="..(dh.y or "nil")..",z="..(dh.z or "nil").."}",
			V_ALLOWLOWERCASE|((not dh.valid) and V_REDMAP or 0),"thin"
		)
		v.drawString(100,
			38+(8*(#strings)),
			"trig: {x="..(th.x or "nil")..",y="..(th.y or "nil")..",z="..(th.z or "nil")..",f="..(tostring(th.flip) or "nil").."}",
			V_ALLOWLOWERCASE|((not th.valid) and V_REDMAP or 0),"thin"
		)
		v.drawString(100,
			46+(8*(#strings)),
			"candoshit: "..tostring( HH_CanDoHappyStuff(p) ),
			V_ALLOWLOWERCASE,
			"thin"
		)
		
	end
	--not exactly aligned but whatever
	if (TAKIS_DEBUGFLAG & DEBUG_ALIGNER)
		v.drawScaled(160*FU-(FU/2),100*FU-(FU/2),FU,v.cachePatch("ALIGNER"),V_20TRANS)
	end
	if (TAKIS_DEBUGFLAG & DEBUG_PFLAGS)
		v.drawString(100,50,"Charability1: "..charabilites[p.charability] or p.charability,
			V_ALLOWLOWERCASE|V_PERPLAYER,"small-thin"
		)
		v.drawString(100,54,"Charability2: "..charabilites2[p.charability2] or p.charability2,
			V_ALLOWLOWERCASE|V_PERPLAYER,"small-thin"
		)
		v.drawString(100,86,"Skin flags",V_ALLOWLOWERCASE|V_PERPLAYER,"small")
		drawflag(v,100,90,"SUP",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_SUPER)
		)		
		drawflag(v,115,90,"NSS",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_NOSUPERSPIN)
		)		
		drawflag(v,130,90,"NSD",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_NOSPINDASHDUST)
		)
		drawflag(v,145,86,string.format("%.2f",skins[p.skin].highresscale*100).."%",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_HIRES)
		)		
		drawflag(v,145,90,"HIR",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_HIRES)
		)		
		drawflag(v,160,90,"NSK",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_NOSKID)
		)		
		drawflag(v,175,90,"NSA",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_NOSPEEDADJUST)
		)		
		drawflag(v,190,90,"ROW",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_RUNONWATER)
		)		
		drawflag(v,205,90,"NJD",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_NOJUMPDAMAGE)
		)		
		drawflag(v,220,90,"STP",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.charflags & SF_STOMPDAMAGE)
		)		
		
		drawflag(v,100,60,"FC",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_FLIPCAM)
		)
		drawflag(v,110,60,"AM",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_ANALOGMODE)
		)
		drawflag(v,120,60,"DC",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_DIRECTIONCHAR)
		)
		drawflag(v,130,60,"AB",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_AUTOBRAKE)
		)
		drawflag(v,140,60,"GM",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_GODMODE)
		)
		drawflag(v,150,60,"NC",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_NOCLIP)
		)
		drawflag(v,160,60,"IV",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_INVIS)
		)
		drawflag(v,170,60,"ad",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_ATTACKDOWN)
		)
		drawflag(v,180,60,"sd",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_SPINDOWN)
		)
		drawflag(v,190,60,"jd",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_JUMPDOWN)
		)
		drawflag(v,200,60,"wd",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_WPNDOWN)
		)
		drawflag(v,210,60,"Stasis not drawn",
			V_PERPLAYER,
			V_GREENMAP,0,
			"small"
		)
		
		drawflag(v,100,70,"AA",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_APPLYAUTOBRAKE)
		)
		drawflag(v,110,70,"sj",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_STARTJUMP)
		)
		drawflag(v,120,70,"ju",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_JUMPED)
		)
		drawflag(v,130,70,"nj",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_NOJUMPDAMAGE)
		)
		drawflag(v,140,70,"sp",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_SPINNING)
		)
		drawflag(v,150,70,"ss",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_STARTDASH)
		)
		drawflag(v,160,70,"th",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_THOKKED)
		)
		--
		drawflag(v,160,74,"th",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			takis.thokked
		)
		drawflag(v,160,78,"di",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			takis.dived
		)
		--
		drawflag(v,170,70,"sa",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_SHIELDABILITY)
		)
		drawflag(v,180,70,"gl",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_GLIDING)
		)
		drawflag(v,190,70,"bc",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_BOUNCING)
		)
		drawflag(v,200,70,"sl",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			takis.inwaterslide
		)
		drawflag(v,210,70,"tc",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_TRANSFERTOCLOSEST)
		)
		drawflag(v,220,70,"nd",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_DRILLING)
		)
		drawflag(v,230,70,"go",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_GAMETYPEOVER)
		)
		drawflag(v,240,70,"it",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_TAGIT)
		)
		drawflag(v,250,70,"fs",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_FORCESTRAFE)
		)
		drawflag(v,260,70,"cc",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_CANCARRY)
		)
		drawflag(v,270,70,"fin",
			V_PERPLAYER,
			V_GREENMAP,V_REDMAP,
			"small",
			(p.pflags & PF_FINISHED)
		)
		v.drawString(270,74,
			"exiting "..p.exiting,
			V_PERPLAYER|(p.exiting and V_GREENMAP or V_REDMAP),
			"small"
		)
		v.drawString(270,78,
			"fxiting "..takis.fakeexiting,
			V_PERPLAYER|(takis.fakeexiting and V_GREENMAP or V_REDMAP),
			"small"
		)
		v.drawString(270,82,
			"yahwait "..takis.yeahwait,
			V_PERPLAYER|(takis.yeahwait and V_GREENMAP or V_REDMAP),
			"small"
		)
		v.drawString(270,86,
			"yeahed  "..tostring(takis.yeahed),
			V_PERPLAYER|(takis.yeahed and V_GREENMAP or V_REDMAP),
			"small"
		)
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
		
		local ypos = hudinfo[HUD_LIVES].y
		if modeattacking then ypos = hudinfo[HUD_LIVES].y+10 end
		local maxspeed = 200*FU
		local speed = FixedDiv(takis.accspeed,maxspeed)
		local runspeed = FixedDiv(p.runspeed,maxspeed)
		local normalspeed = FixedDiv(p.normalspeed,maxspeed)
		local roll
		local rsroll
		local nroll
		local scale = FU
		local offy2 = 0
		if (speed ~= 0)
			roll = FixedAngle(180*FU-FixedMul(180*FU,speed))
		else
			roll = FixedAngle(180*FU)
		end
		if (normalspeed ~= 0)
			nroll = FixedAngle(180*FU-FixedMul(180*FU,normalspeed))
		else
			nroll = FixedAngle(180*FU)
		end
		if (runspeed ~= 0)
			rsroll = FixedAngle(180*FU-FixedMul(180*FU,runspeed))
		else
			rsroll = FixedAngle(180*FU)
		end
		if AngleFixed(roll) == 0
			offy2 = -4
		end
		
		for i = 0,10
			local offy = 0
			local ra = FixedAngle(180*FU-(i*18)*FU)
			if i == 10
				offy = -4
			end
			v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
				(ypos-8+offy)*FU,
				FU/2,
				v.getSpritePatch(SPR_THND,B,0,ra),
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
			)
			if i == 5
				v.drawString((hudinfo[HUD_LIVES].x+30)*FU+(30*cos(ra)),
					(ypos-8+offy)*FU-(35*sin(ra))-(4*FU),
					"100",
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
					"thin-fixed-center"
				)	
			elseif i == 10
				v.drawString((hudinfo[HUD_LIVES].x+30)*FU+(35*cos(ra)),
					(ypos-8+offy)*FU-(35*sin(ra))-(7*FU),
					"200",
					V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
					"thin-fixed-center"
				)	
			end
		end
		
		v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
			(ypos-8+offy2)*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,D,0,rsroll),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
		)
		v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
			(ypos-8+offy2)*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,C,0,nroll),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
		)
		
		v.drawScaled((hudinfo[HUD_LIVES].x+30)*FU,
			(ypos-8+offy2)*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,A,0,roll),
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
		)
		
		local scorenum = "CMBCF"
		local score = L_FixedDecimal(takis.accspeed,3)
		
		local prevw
		if not prevw then prevw = 0 end
		
		for i = 1,string.len(score)
			local n = string.sub(score,i,i)
			--if n == "." then n = "DOT" end
			v.drawScaled(hudinfo[HUD_LIVES].x*FU+(prevw*scale),
				(ypos)*FU-(v.cachePatch(scorenum+n).height*FixedDiv(scale-FU,2*FU)),
				FixedDiv(scale,2*FU),
				v.cachePatch(scorenum+n),
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
			)
				
			prevw = $+v.cachePatch(scorenum+n).width*4/10
		end
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-60)*FU,
			L_FixedDecimal(me.friction,3).." friction",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-68)*FU,
			p.thrustfactor.." thrust",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)

		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-76)*FU,
			p.accelstart..", "..p.acceleration.." accelstart, accel",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-84)*FU,
			L_FixedDecimal(me.movefactor,3).." movefactor",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		v.drawString(hudinfo[HUD_LIVES].x*FU,
			(ypos-92)*FU,
			L_FixedDecimal(me.subsector.sector.friction,3).." sec fric",
			V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
			"thin-fixed"
		)
		
		if me.tracer and me.tracer.valid
			v.drawString(hudinfo[HUD_LIVES].x*FU,
				(ypos-100)*FU,
				L_FixedDecimal(me.tracer.friction,3).." tracer friction",
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
				"thin-fixed"
			)
			v.drawString(hudinfo[HUD_LIVES].x*FU,
				(ypos-108)*FU,
				L_FixedDecimal(me.tracer.movefactor,3).." tracer movefactor",
				V_HUDTRANS|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER,
				"thin-fixed"
			)
		
		end
		
		/*
		//height debug
		local scale = FU/10
		local floorz = me.floorz
		local drawz = 175*FU-FixedMul(floorz,scale)
		v.drawFill(105,175-(FixedMul(floorz,scale)/FU),60,2,
			skincolors[ColorOpposite(p.skincolor)].ramp[4]|
			V_SNAPTOBOTTOM
		)
		local dist = (me.z-floorz)
		v.drawScaled(115*FU,
			drawz-FixedMul(dist,scale),
			FixedMul(scale,skins[me.skin].highresscale or FU),
			v.getSprite2Patch(me.skin,me.sprite2,
			p.powers[pw_super] > 0,
			me.frame,
				3,me.rollangle
			),
			V_SNAPTOBOTTOM,
			v.getColormap(nil,me.color)
		)
		for i = 0,2
			v.drawScaled(122*FU+(i*FU*7),
				drawz,
				FixedMul(scale,skins[i].highresscale or FU),
				v.getSprite2Patch(i,SPR2_STND,false,A,
					3,0
				),
				V_SNAPTOBOTTOM,
				v.getColormap(i,skins[i].prefcolor)
			)		
		end
		v.drawScaled(146*FU,
			drawz,
			scale,
			v.getSpritePatch(SPR_BRAK,A,3,0),
			V_SNAPTOBOTTOM
		)
		v.drawString(115*FU,
			drawz-4*FU-FixedMul(dist,FixedDiv(scale,2*FU)),
			L_FixedDecimal(dist,3),
			V_SNAPTOBOTTOM,
			"thin-fixed"
		)
		*/
	end
	if (TAKIS_DEBUGFLAG & DEBUG_HURTMSG)
		for i = 0,#takis.hurtmsg
			local strings = Tprtable("i "..i,takis.hurtmsg[i],false)
			for k,va in ipairs(strings)
				v.drawString(100,(4*(k-1))+(16*i),va,V_ALLOWLOWERCASE,"small")
			end
		end
	end
	if (TAKIS_DEBUGFLAG & DEBUG_BOSSCARD)
		local bosscards = takis.HUD.bosscards
		
		local x,y = 10,60
		local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE
		if not (bosscards.mo and bosscards.mo.valid)
			v.drawString(x,y,"No boss",flags|V_REDMAP,"thin")
		else
			/*
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
			*/
			
			local hascard
			v.drawString(x,y,
				"mo: \x86"..tostring(bosscards.mo),
				flags,"thin"
			)		
			v.drawString(x,y+8,"type#: "..tonumber(bosscards.mo.type),flags,"thin")		
			v.drawString(x,y+16,bosscards.name or "No name",flags,"thin")		
			v.drawString(x,y+24,"HP: "..
				bosscards.mo.health.."/"..
				bosscards.maxcards..
				((bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) and " (Not drawn)" or ''),
				flags|((bosscards.nocards or TAKIS_BOSSCARDS.nobosscards[bosscards.mo.type] ~= nil) and V_REDMAP or 0),"thin"
			)		
			v.drawString(x,y+32,"face: "..
				(TAKIS_BOSSCARDS.bossprefix[bosscards.mo.type] or "No face prefix"),
				flags,"thin"
			)		
			local strings = Tprtable("statusface",bosscards.statusface,false)
			for k,va in ipairs(strings)
				v.drawString(x,y+32+(k*8),va,flags,"thin")		
			end
		end
		flags = $|V_SNAPTORIGHT &~V_SNAPTOLEFT
		local strings = Tprtable("TAKIS_BOSSCARDS.nobosscards",TAKIS_BOSSCARDS.nobosscards,false)
		for k,va in ipairs(strings)
			v.drawString(300-x,y-8+(k*8),va,flags,"thin-right")		
		end
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_NET)
		local dex = 10
		local cv = {
			[1] = CV_TAKIS.nerfarma,
			[2] = CV_TAKIS.tauntkills,
			[3] = CV_TAKIS.achs,
			[4] = CV_TAKIS.collaterals,
			[5] = CV_TAKIS.heartcards,
			[6] = CV_TAKIS.hammerquake,
			[7] = CV_TAKIS.chaingun,
			[8] = CV_TAKIS.noeffects,
			[9] = CV_TAKIS.forcekart,
			[10] = CV_TAKIS.allowkarters,
		}
		local net = {
			[1] = TAKIS_NET.nerfarma,
			[2] = TAKIS_NET.tauntkillsenabled,
			[3] = TAKIS_NET.noachs,
			[4] = TAKIS_NET.collaterals,
			[5] = TAKIS_NET.cards,
			[6] = TAKIS_NET.hammerquakes,
			[7] = TAKIS_NET.chaingun,
			[8] = TAKIS_NET.noeffects,
			[9] = TAKIS_NET.forcekart,
			[10] = TAKIS_NET.allowkarters,
		}
		local name = {
			[1] = "Nerf arma",
			[2] = "Taunt kills",
			[3] = "Achs",
			[4] = "Collaterals",
			[5] = "Cards",
			[6] = "Hammer quakes",
			[7] = "Chaingun",
			[8] = "No effects",
			[9] = "Forcekart",
			[10] = "Allowkarters",
		}
		local boolclr = {
			[true] = "\x83",
			[false] = "\x85",
		}
		
		for i = 1,dex
			local bool = net[i]
			if i == 3 then
				bool = not $
			end
			local s1 = cv[i].value and " " or ''
			local s2 = bool and " " or ''
			local c1 = boolclr[cv[i].value == 1]
			local c2 = boolclr[bool]
			v.drawString(100,
				2+(i*8),
				"\x86".."CV: "..c1..string.lower(tostring(cv[i].string))..s1..
				"\x86 NET: "..c2..tostring(bool)..s2.."\x86 - \x80"..
				name[i],
				V_HUDTRANS|V_ALLOWLOWERCASE|V_MONOSPACE,
				"thin"
			)
			local ds = (cv[i].value == 1) ~= bool
			if ds
				v.drawString(100,
					2+(i*8),
					"Desynched!",
					V_HUDTRANS|V_ALLOWLOWERCASE|V_MONOSPACE|V_YELLOWMAP,
					"thin-right"
				)
			end
		end
		
		--other shit
		local bottom = 10+(dex*8)
		local n = TAKIS_NET
		local m = TAKIS_MISC
		v.drawString(100,bottom,
			"FC: "..(n.partdestroy).."/"..(n.numdestroyables).." things",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		v.drawString(100,bottom+8,
			"count: exit: "..m.exitingcount..", takis: "..m.takiscount..", other: "..m.playercount,
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		v.drawString(100,bottom+16,
			"cardbump: "..L_FixedDecimal(m.cardbump,2)..", starpost: "..n.maxpostcount..", fallout: "..tostring(n.allowfallout),
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		local ss = n.inspecialstage
		local bm = n.inbossmap
		local bk = n.inbrakmap
		local retro = n.isretro == TOL_MARIO
		drawflag(v,100,bottom+24,"spec",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			ss
		)
		drawflag(v,140,bottom+24,"boss",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			bm
		)
		drawflag(v,100,bottom+32,"brak",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			bk
		)
		drawflag(v,140,bottom+32,"retro",
			V_HUDTRANS|V_ALLOWLOWERCASE,
			V_GREENMAP,V_REDMAP,
			"thin",
			retro
		)
		
		v.drawString(100,bottom+40,
			"lifepool: "..m.livescount..", bosscards: "..tostring(n.allowbosscards),
			V_HUDTRANS|V_ALLOWLOWERCASE,
			"thin"
		)
		
		local strings = Tprtable("SPIKE_LIST",SPIKE_LIST,false)
		for k,va in ipairs(strings)
			v.drawString(100,bottom+40+(8*k),
				va,
				V_HUDTRANS|V_ALLOWLOWERCASE,
				"thin"
			)
		end
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_MUSIC)
		local flags = V_SNAPTOLEFT
		v.drawString(5,
			92,
			musname or "null",
			flags,
			"left"
		)
		local bpm = TAKIS_BEATMS[string.lower(musname or '')]
		
		if bpm ~= nil
			do
				local pre = "MINFOB_"
				local fill = v.cachePatch(pre.."FILL")
				local tick = v.cachePatch(pre.."TICK")
				local bump = (60*MUSICRATE)/bpm
				
				v.drawScaled(5*FU,110*FU,FU*2,fill,flags,v.getColormap(nil,SKINCOLOR_BLACK))
				for i = 0,3
					local xoff = FixedMul(fill.width*FU*2,(FU/4)*i)
					v.drawScaled(5*FU + xoff,
						110*FU,FU*2,
						tick,flags,
						v.getColormap(nil,i == 0 and SKINCOLOR_GOLDENROD or SKINCOLOR_SANDY)
					)
					
				end
				
				local leng = S_GetMusicLength()
				local pos = S_GetMusicPosition()
				local metadata = TAKIS_BEATMETADATA[string.lower(musname or '')]
				local introbeats = 0
				if (metadata ~= nil)
					if metadata.milliseconds ~= nil
						bump = metadata.milliseconds
					end
					
					if metadata.introms ~= nil
						pos = $ - metadata.introms
						leng = $ - metadata.introms
					end
					
					if metadata.introbeats ~= nil
						introbeats = metadata.introbeats
					end
				end
				
				
				local posstring = L_FixedDecimal(FixedDiv(pos,MUSICRATE),2).."/"..L_FixedDecimal(FixedDiv(leng,MUSICRATE),2)
				
				if introbeats
				and (pos / bump) < introbeats
					--pos = 0
					v.drawString(5,
						138,
						"Rest "..(introbeats - (pos / bump)),
						flags|V_ALLOWLOWERCASE,
						"thin"
					)
				end
				
				pos = max($,0)
				local xoff = FixedMul(fill.width*FU*2, FixedDiv(pos % (bump*4),bump*4))
				local sizeinc = FixedDiv(TAKIS_MISC.cardbump,10*FU)
				local tick = v.cachePatch("TRANSFOM_TIC")
				v.drawScaled(5*FU + xoff,
					114*FU - FixedMul(tick.height*FU,sizeinc - FU) - tick.height*FU,
					FU + sizeinc,
					tick,
					flags,v.getColormap(nil,SKINCOLOR_SALMON)
				)
				
				v.drawString(5,
					100,
					posstring,
					flags,
					"thin"
				)
				v.drawString(5,
					130,
					"Beat "..TAKIS_MISC.lastbump,
					flags|V_ALLOWLOWERCASE,
					"thin"
				)
				
				v.drawString(55*FU, -- + TAKIS_MISC.cardbump,
					130*FU,
					"BPM: "..bpm,
					flags|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
				
			end
			
		end
		
		/*
		if not TAKIS_BEATMS[string.lower(musname or '')]
			flags = $|V_REDMAP
		end
		
		local leng = S_GetMusicLength()
		local pos = S_GetMusicPosition()
		local posstring = L_FixedDecimal(FixedDiv(pos,MUSICRATE),2).."/"..L_FixedDecimal(FixedDiv(leng,MUSICRATE),2)
		v.drawString(5,
			100,
			posstring,
			flags,
			"left"
		)
		local HAHA = 0
		if (leng ~= 0)
			local percent = L_FixedDecimal(FixedMul(FixedDiv(pos,leng),100*FU),2).."%"
			HAHA = v.stringWidth(percent.."==",0,normal)
			v.drawString(5,
				120,
				percent,
				flags,
				"left"
			)
			
			v.drawString(55,
				120,
				"beat "..TAKIS_MISC.lastbump,
				flags,
				"left"
			)
			
			local pre = "MINFOB_"
			local fill = v.cachePatch(pre.."FILL")
			local erm = FixedDiv(pos,leng)
			local width = FixedMul(erm,fill.width*FU)
			if width < 0 then
				width = 0
			end
			
			v.drawScaled(5*FU,110*FU,FU,fill,flags,v.getColormap(nil,SKINCOLOR_BLACK))
			v.drawCropped(5*FU,110*FU,FU,FU,
				fill,
				flags, 
				nil,
				0,0,
				width,fill.height*FU
			)
		end
		*/
	end
	if (TAKIS_DEBUGFLAG & DEBUG_KART)
		if not p.inkart then return end
		if not (me.tracer and me.tracer.valid) then return end
		local car = me.tracer
		
		if takis.HUD.lives.nokarthud
			local targetsnd = 0
			local cmdmove = (6*abs(car.moving))/25
			local speedthing = FixedDiv(FixedHypot(car.momx,car.momy),car.scale)/FU/20
			targetsnd = (cmdmove+speedthing)/2
			--clamp
			targetsnd = max(0,min(12,targetsnd))
			
			v.drawString(10,80,
				"target: "..targetsnd,
				V_SNAPTOLEFT|V_SNAPTOTOP,
				"left"
			)
			v.drawString(10,88,
				"engine: "..car.enginesound,
				V_SNAPTOLEFT|V_SNAPTOTOP,
				"left"
			)

			--local planez = (P_MobjFlip(me) == -1) and "ceilingheight" or "floorheight"
			--local heightdiff = abs(R_PointInSubsector(car.x+car.momx,car.y+car.momy).sector[planez] - me.subsector.sector[planez])
			local steppingup = true --LMAOO heightdiff > 0 and heightdiff <= 48*me.scale
			local telex = (me.subsector.sector.specialflags & SSF_DOUBLESTEPUP and P_IsObjectOnGround(me) and (not me.standingslope) and steppingup and me.z or me.x)
			local x,y = 	car.x-car.momx,	car.y-car.momy
			local x2,y2 = 	telex - me.momx,me.y - me.momy
			v.drawString(10,96,
				"dist: "..L_FixedDecimal(R_PointToDist2(x,y,x2,y2),3),
				V_SNAPTOLEFT|V_SNAPTOTOP|(telex == me.z and V_YELLOWMAP or 0),
				"left"
			)
			v.drawString(10,104,
				"radi: "..(car.radius*INT8_MAX)/FU,
				V_SNAPTOLEFT|V_SNAPTOTOP,
				"left"
			)

			v.drawString(10,112,
				"speed: "..L_FixedDecimal(car.accel*8,3).."/"..L_FixedDecimal(car.maxspeed,3).."/"..L_FixedDecimal(car.basemaxspeed,3),
				V_SNAPTOLEFT|V_SNAPTOTOP,
				"left"
			)
			local spinouttype = "none"
			if car.spinouttype & (1<<0)
				spinouttype = "spin"
			end
			if car.spinouttype & (1<<1)
				spinouttype = "tumble"
			end
			if car.spinouttype & (1<<2)
				spinouttype = "bigtumble"
			end
			if car.spinouttype & (1<<3)
				spinouttype = "stumble"
			end
			v.drawString(10,120,
				"spin: "..spinouttype,
				V_SNAPTOLEFT|V_SNAPTOTOP,
				"left"
			)
			v.drawString(10,128,
				"s,a: "..GetAccelStat(p,1,car.stats[2])..", "..GetAccelStat(p,2,car.stats[1]),
				V_SNAPTOLEFT|V_SNAPTOTOP,
				"left"
			)
		else
			local flag = 0
			if car.wallcooldown
				flag = V_REDMAP
			end
			v.drawString(10,60,
				"SlopeTransfer: "..tostring(car.slopetransfer),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|flag,
				"thin"
			)
			v.drawString(10,68,
				"WallStick, Line: "..tostring(car.wallstick)..", "..tostring(car.wallline),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|flag,
				"thin"
			)
			v.drawString(10,76,
				"UnstickTimer: "..tostring(car.wallunstick),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|flag,
				"thin"
			)
			v.drawString(10,84,
				"RealGrounded: "..tostring(P_IsObjectOnGround(car)),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|flag,
				"thin"
			)
			v.drawString(10,92,
				"Bike: "..tostring(car.bikemode)..", IDrift: "..tostring(car.insidedrift),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|flag,
				"thin"
			)
			v.drawString(10,100,
				"MF: "..string.format("%f",tostring(car.fakemovefactor*100)),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|flag,
				"thin"
			)
			v.drawString(10,108	,
				"OR: "..car.offroad,
				V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE|flag,
				"thin"
			)
		end
		
		v.drawString(160,135,
			L_FixedDecimal(AngleFixed(car.angle),3).."a",
			V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-center"
		)
		for i = 0,35
			v.drawScaled(160*FU,
				170*FU,
				FU/2,
				v.getSpritePatch(SPR_THND,B,0,FixedAngle(10*FU*i)),
				V_SNAPTOBOTTOM|V_50TRANS
			)
		end
		
		v.drawScaled(160*FU,
			170*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,A,0,car.angle),
			V_SNAPTOBOTTOM|V_60TRANS,
			v.getColormap(TC_RAINBOW,p.skincolor)
		)
		--slope angle is more important than this second angle needle
		if car.standingslope and car.standingslope.valid
			v.drawScaled(160*FU,
				170*FU,
				FU/2,
				v.getSpritePatch(SPR_THND,A,0,car.standingslope.xydirection),
				V_SNAPTOBOTTOM
			)
		else
			v.drawScaled(160*FU,
				170*FU,
				FU/2,
				v.getSpritePatch(SPR_THND,A,0,FixedAngle(car.momt)+car.angle),
				V_SNAPTOBOTTOM|V_10TRANS
			)
		end
		v.drawScaled(160*FU,
			170*FU,
			FU/2,
			v.getSpritePatch(SPR_THND,C,0,FixedAngle(car.rmomt)+car.angle),
			V_SNAPTOBOTTOM
		)
		if car.bumpangle
			v.drawScaled(160*FU,
				170*FU,
				FU/2,
				v.getSpritePatch(SPR_THND,A,0,car.bumpangle),
				V_SNAPTOBOTTOM|V_20TRANS,
				v.getColormap(TC_RAINBOW,ColorOpposite(p.skincolor))
			)
		end
		
	end
	if (TAKIS_DEBUGFLAG & DEBUG_CONFIG)
		/*
		v.drawString(290,20,
			"io.hasfile = "..tostring(takis.io.hasfile),
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"thin-right"
		)
		v.drawString(290,28,
			"license.haslicense = "..tostring(takis.license.haslicense),
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"thin-right"
		)
		*/
		local work = 0
		for p2 in players.iterate
			local clr = p2.takistable.io.hasfile and "\x83" or "\x85"
			local aclr = p2.takistable.license.haslicense and "\x83" or "\x85"
			v.drawString(290,30+(work*8),
				"[#"..#p2.."] "..p2.name.."\x80 - "..clr..tostring(p2.takistable.io.hasfile).."\x80, "..aclr..tostring(p2.takistable.license.haslicense),
				V_HUDTRANS|V_SNAPTOTOP|V_SNAPTORIGHT|V_ALLOWLOWERCASE|
				((p2 == p) and V_YELLOWMAP or 0),
				"thin-right"
			)
			work = $+1
		end		
	end
	
	--debug end
end

--draw the stuff
--customhud.SetupItem("takis_wareffect", 		modname/*,	,	"game",	1*/)
customhud.SetupItem("takis_clutchstuff",	modname/*,	,	"game",	23*/) --
customhud.SetupItem("takis_combometer", 	modname/*,	,	"game",	27*/) 
customhud.SetupItem("takis_heartcards", 	modname/*,	,	"game",	30*/) --
customhud.SetupItem("takis_bosscards", 		modname)
customhud.SetupItem("takis_statusface", 	modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_c3jumpscare", 	modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_tauntmenu", 		modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_cosmenu", 		modname/*,	,	"game",	31*/) --
customhud.SetupItem("takis_cfgnotifs", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_bonuses", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_crosshair", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_happyhourtime", 	modname/*,	,	"game",	10*/)
customhud.SetupItem("textspectator", 		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_nadocount",	 	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_tutbuttons",	 	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_transfotimer", 	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_kart_driftmeter",modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_kart_meters",	modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_racelaps",		modname/*,	,	"game",	10*/)
customhud.SetupItem("takis_viewmodel",		modname/*,	,	"game",	10*/)
local altmodname = "vanilla"
local istakisrn = false
local wastakis = false
local gamewastakis = false
local nohudswitching = false
local stillswitchitems = false
addHook("PostThinkFrame",do
	local player = displayplayer
	if not (player and player.valid)
		return
	end
	if not player.takistable
		return
	end
	wastakis = istakisrn
	if player.takistable.isTakis
		istakisrn = true
		wastakis = true
	else
		istakisrn = false
	end
end)

local stoppeddrawing = false
local dontdrawtakishud = false
addHook("HUD", function(v,p,cam)
	if not p
	or not p.valid
	or PSO
		return
	end
	
	if not p.takistable
		return
	end
	
	local takis = p.takistable
	local me = p.mo
	
	if TAKIS_DEBUGFLAG & DEBUG_NOHUD
		if not stoppeddrawing
			if takis.io.morehappyhour == 0
			and (not takis.otherskin
			or takis.otherskintime == 1)
				customhud.SetupItem("PTSR_itspizzatime","spicerunners")
			else
				customhud.SetupItem("PTSR_itspizzatime",modname)
			end
			drawhappyhour(v,p)
			
			if not takis.otherskin
			or takis.otherskintime == 1
			or (wastakis or gamewastakis)
				if not nohudswitching
					customhud.SetupItem("rings",			altmodname)
					if not (HAPPY_HOUR.othergt)
						customhud.SetupItem("time",			altmodname)
						customhud.SetupItem("score",		altmodname)
					else
						customhud.SetupItem("time",			"spicerunners")
						customhud.SetupItem("score",		"spicerunners")			
					end
					customhud.SetupItem("lives",			altmodname)
					customhud.SetupItem("PTSR_bar",			"spicerunners")
					customhud.SetupItem("PTSR_tooltips",	"spicerunners")
					customhud.SetupItem("PTSR_rank", 		"spicerunners")
					--customhud.SetupItem("PTSR_combo", 		"spicerunners")
					customhud.SetupItem("PTSR_lap", 		"spicerunners")
					customhud.SetupItem("textspectator",	altmodname)
					customhud.SetupItem("crosshair",		altmodname)
				end
			end
			gamewastakis = true
		end
		stoppeddrawing = true
		return
	else
		stoppeddrawing = false
	end
	
	/*
	if p.takistable.inNIGHTSMode
	or (TAKIS_NET.inspecialstage)
		return
	end
	*/
	
	nohudswitching = false
	dontdrawtakishud = false
	if gametype == GT_ZE2
	or gametype == GT_SAXAMM
		nohudswitching = true
		if gametype == GT_SAXAMM
			dontdrawtakishud = true
		end
	end
	
	if takis
		drawhappytime(v,p)
		local jetty = p.isjettysyn
		
		if p.textBoxInAction
			textboxmoveup = ease.inquart(FU*9/10,$,57*FU)
		else
			if not p.textBoxClose
				textboxmoveup = ease.inquart(FU*9/10,$,0)
			end
		end
		
		doihaveminhud = (consoleplayer and consoleplayer.valid) and consoleplayer.takistable.io.minhud == 1 or 0
		if TAKIS_TUTORIALSTAGE then doihaveminhud = false end
		
		--haha FUNNY DRRR elemt
		--THIS GAME IS SHIT
		if (p.deadtimer
		and (takis.deathfunny))
		and gametype ~= GT_SAXAMM
			local thok = v.getSpritePatch(SPR_TMIS,S,0)
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
		end
		
		if (takis.isTakis
		and not jetty)
			
			--wastakis = true
			local opmode = (me and me.valid and me.state == S_OBJPLACE_DUMMY and not netgame) or false
			
			/*
			local modname = modname
			if dontdrawtakishud
				modname = "IDKBRODONOTUSETHIS"
			end
			
			print('name',modname,modname,dontdrawtakishud)
			*/
			
			if not gamewastakis or stillswitchitems
				customhud.SetupItem("takis_clutchstuff",	modname)
				if opmode
					customhud.SetupItem("rings", 			altmodname) 
					customhud.SetupItem("time", 			altmodname) 
					customhud.SetupItem("score", 			altmodname) 
				else
					customhud.SetupItem("rings", 			modname) 
					customhud.SetupItem("time", 			modname) 
					customhud.SetupItem("score", 			modname) 
				end
				customhud.SetupItem("lives", 				modname)
				customhud.SetupItem("takis_combometer", 	modname) 
				customhud.SetupItem("takis_heartcards", 	modname)
				customhud.SetupItem("takis_bosscards", 		modname)
				customhud.SetupItem("takis_statusface", 	modname)
				customhud.SetupItem("takis_c3jumpscare", 	modname)
				customhud.SetupItem("takis_tauntmenu", 		modname)
				customhud.SetupItem("takis_cosmenu", 		modname)
				customhud.SetupItem("takis_cfgnotifs", 		modname)
				customhud.SetupItem("takis_bonuses", 		modname)
				customhud.SetupItem("takis_crosshair", 		modname)
				customhud.SetupItem("takis_happyhourtime", 	modname)
				customhud.SetupItem("textspectator", 		modname)
				customhud.SetupItem("takis_nadocount", 		modname)
				customhud.SetupItem("takis_tutbuttons", 	modname)
				customhud.SetupItem("takis_transfotimer", 	modname)
				customhud.SetupItem("bossmeter",			modname)
				customhud.SetupItem("takis_kart_driftmeter",modname)
				customhud.SetupItem("takis_kart_meters",	modname)
				customhud.SetupItem("takis_racelaps",		modname)
				customhud.SetupItem("takis_viewmodel",		modname)
				if takis.transfo & TRANSFO_SHOTGUN
					customhud.SetupItem("crosshair",		modname)
				else
					customhud.SetupItem("crosshair",		altmodname)
				end
				
				customhud.SetupItem("PTSR_rank", modname)
				--customhud.SetupItem("PTSR_combo", modname)
				customhud.SetupItem("PTSR_lap", modname)
				--customhud.SetupItem("rank", modname)		
			end
			gamewastakis = true
			
			if takis.io.nohappyhour == 0
				customhud.SetupItem("PTSR_itspizzatime",modname)
				customhud.SetupItem("PTSR_bar",modname)
				customhud.SetupItem("PTSR_tooltips",modname)
			elseif takis.io.nohappyhour == 1
				customhud.SetupItem("PTSR_itspizzatime","spicerunners")
				customhud.SetupItem("PTSR_bar","spicerunners")
				customhud.SetupItem("PTSR_tooltips","spicerunners")
			end
			
			if p.takis
			and p.takis.shotgunnotif
				local waveforce = FU/10
				local ay = FixedMul(waveforce,sin(leveltime*ANG2))
				v.drawScaled(160*FU,65*FU,FU+ay,v.cachePatch("SPIKEYBOX"),0)
				local draw = true
				if p.takis.shotgunnotif >= 5*TR
					if not (p.takis.shotgunnotif % 2)
						draw = false
					end
				elseif p.takis.shotgunnotif <= TR
					if not (p.takis.shotgunnotif % 2)
						draw = false
					end				
				end
				
				if draw
					v.drawString(160,55,"\x85Something's new in",V_ALLOWLOWERCASE,"thin-center")
					v.drawString(160,65,"\x89Ultimate Mode\x85!",V_ALLOWLOWERCASE,"thin-center")
					v.drawString(160,75,"C3 - What's up?",V_ALLOWLOWERCASE,"thin-center")
				end
				
			end
			
			local hasstat = CV_FindVar("perfstats").value
			local mm = gametype == GT_MURDERMYSTERY
			local devmode = 0 --CV_FindVar("devmode").value
			
			----w2s hud
			setinterp(v,true)
			drawviewmodel(v,p,cam)
			drawclutches(v,p,cam)
			drawnadocount(v,p,cam)
			drawtransfotimer(v,p,cam)
			--drawdriftmeter(v,p,cam)
			
			drawfallout(v,p)
			setinterp(v,false)
			----
			
			if not dontdrawtakishud
				if not (hasstat or mm)
					drawrings(v,p)
					drawtimer(v,p)
				end
				drawkartmeters(v,p)
				if not mm
					drawlivesarea(v,p)
				end
				drawracelaps(v,p)
				drawlapanim(v,p)
				if not (opmode or mm)
					drawcombostuff(v,p,cam)
				end
				drawpizzatips(v,p)
				drawpizzatimer(v,p)
			else
				drawcountdown(v,p)
			end
			
			if takis.nadotuttic
				local trans = 0
				
				if takis.nadotuttic >= 5*TR-9
					trans = (takis.nadotuttic-(5*TR-9))<<V_ALPHASHIFT
				elseif takis.nadotuttic < 10
					trans = (10-takis.nadotuttic)<<V_ALPHASHIFT
				end
				local waveforce = FU/10
				local ay = FixedMul(waveforce,sin(leveltime*ANG2))
				v.drawScaled(160*FU,65*FU,FU+ay,v.cachePatch("SPIKEYBOX"),trans)
				v.drawString(160,55,"\x82Tornado Transfo!",V_ALLOWLOWERCASE|trans,"thin-center")
				v.drawString(160,65,"Spin to go faster!",V_ALLOWLOWERCASE|trans,"thin-center")
				v.drawString(160,75,"C3 - Whatever",V_ALLOWLOWERCASE|trans,"thin-center")
				
			end
			
			drawcfgnotifs(v,p)
			if not dontdrawtakishud
				drawtutbuttons(v,p)
				if not (hasstat or mm or devmode)
					drawscore(v,p)
				end
				setinterp(v,true)
				drawbosstitles(v,p)
				setinterp(v,false)
				if not (hasstat or opmode or mm)
					drawheartcards(v,p)
					drawbosscards(v,p)
					drawface(v,p)
					drawbossface(v,p)
					drawpizzaranks(v,p)
					drawbonuses(v,p)
				end
			end
			setinterp(v,true)
			drawcrosshair(v,p)
			setinterp(v,false)
			drawtauntmenu(v,p)
			if (takis.cosmenu.menuinaction)
				drawcosmenu(v,p)
			end
			drawhappyhour(v,p)
			
			if takis.license.licenseaward
				local scale = FU/2
				local linc = v.cachePatch("TA_LICENSE")
				local x,y = 160*FU,100*FU
				local license = takis.license
				
				if license.licenseaward > (4*TR) - TR/2
					local et = TR/2
					local tics = license.licenseaward - ((3*TR)+TR/2)
					tics = et - ($ - 1)
					
					scale = ease.outexpo((FU/et)*tics, 1, FU/2)
					scale = max($,1)
				end
				if license.licenseaward >= TR
					y = $ + sin(FixedAngle(FU)*(leveltime*8))*4
					v.drawString(x,y + linc.height*scale/2 + 8*FU,
						"License Get!",
						V_YELLOWMAP|V_ALLOWLOWERCASE,
						"fixed-center"
					)
				else
					local et = TR
					local tics = et - license.licenseaward
					
					local total_width = (v.width() / v.dupx()) + 1
					local total_height = (v.height() / v.dupy()) + 1
					
					local ypos = ((100*FU)+(total_height*FU/2))
					local xpos = 160*FU-(total_width*FU/2)
					
					y = ease.inquad(
						(FU/et)*tics,
						$,
						ypos,
						FU*4
					)
					x = ease.inquad(
						(FU/et)*tics,
						$,
						xpos,
						FU
					)
					scale = ease.inquad(
						(FU/et)*tics,
						$,
						1,
						FU
					)
					
				end
				x = $ - linc.width*scale/2
				y = $ - linc.height*scale/2
				
				
				v.drawScaled(x,y,scale,
					linc,
					0,
					v.getColormap(nil,ColorOpposite(p.skincolor))
				)
				
				v.drawScaled(x,y,scale,
					v.cachePatch(TAKIS_MUGSHOTS[license.mugshot].patch),
					0,
					v.getColormap(nil,p.skincolor)
				)
			end
			
			--record attack stuff
			if (modeattacking)
			and (p.powers[pw_carry] ~= CR_NIGHTSMODE)
				if (leveltime <= 5*TR)
					local tween = 0
					local et = TR/2
					local trans = 0
					local trans2 = V_50TRANS
					if leveltime <= et
						trans = ((18-leveltime)/2)<<V_ALPHASHIFT
						--trans2 = ((9-leveltime)/4)<<V_ALPHASHIFT
						tween = ease.outexpo((FU/et)*(leveltime),200*FU, 0)				
					elseif leveltime >= 4*TR+et
						local tics = leveltime-(4*TR+et)
						trans = (tics/2)<<V_ALPHASHIFT
						--trans2 = (tics/4)<<V_ALPHASHIFT
						tween = ease.inexpo((FU/et)*tics,0,200*FU)				
					end
					
					local happytime = CV_TAKIS.happytime.value
					--local fs = takis.HUD.flyingscore
					local x = hfs.scorex*FU+tween
					local y = (hfs.scorey+22)*FU
					local constext = true
					local hhtext = "takis_happyhour"
					if (TAKIS_MISC.inescapable[string.lower(G_BuildMapTitle(gamemap) or '')] == true)
						happytime = 0
						constext = false
						hhtext = "Inescapable map"
					end
					local frame = happytime and ((5*leveltime/6)%14) or 0
					local patch = v.cachePatch("TAHHS"..frame)
					
					drawblackbox(v, x - 76*FU,y - 9*FU, 78*FU,36*FU, trans2|V_SNAPTORIGHT|V_SNAPTOTOP)
					/*
					v.drawScaled(x,
						y-9*FU,
						FU,
						v.cachePatch("TA_HH_BOX"),
						trans2|V_SNAPTORIGHT|V_SNAPTOTOP
					)
					*/
					v.drawString(x,
						y+10*FU,
						hhtext,
						V_ALLOWLOWERCASE|V_GRAYMAP|trans|V_SNAPTORIGHT|V_SNAPTOTOP,
						"thin-fixed-right"
					)
					if constext
						v.drawString(x,
							y+18*FU,
							"Change in cons.",
							V_ALLOWLOWERCASE|trans|V_SNAPTORIGHT|V_SNAPTOTOP,
							"thin-fixed-right"
						)
					end
					v.drawString(x-50*FU,
						y-4*FU,
						happytime and "ON" or "OFF",
						V_YELLOWMAP|trans|V_SNAPTORIGHT|V_SNAPTOTOP,
						"fixed"
					)
					v.drawScaled(x-(v.stringWidth("takis_happyhour",0,"thin")*FU),
						y-7*FU,
						FU/2,
						patch,
						trans|V_SNAPTORIGHT|V_SNAPTOTOP
					)
				end
				
				if takis.HUD.rthh.tics
					local time = takis.HUD.rthh.time
					local min = G_TicsToMinutes(time,true)
					local sec = G_TicsToSeconds(time)
					local cen = G_TicsToCentiseconds(time)
					local tstring = tostring(min)..":"..(sec < 10 and "0" or '')..tostring(sec).."."..(cen < 10 and "0" or '')..tostring(cen)
					
					local x = 130*FU
					local y = 150*FU
					
					local waveforce = FU*3
					local ay = FixedMul(waveforce,sin (FixedAngle(leveltime*20*FU)))
					
					local cpatch = v.cachePatch("TAKCOSHARE")
					local color = v.getColormap(nil,
						(leveltime/2 % 2) and SKINCOLOR_GREEN
						or SKINCOLOR_RED
					)
					local xoff = -7*FU
					v.drawScaled(x+8*FU-xoff,y+ay,FU,cpatch,0,color)
					v.drawString(x+8*FU-xoff,y+ay,tstring,V_YELLOWMAP,"fixed-right")
				
				end
			end
			
			if (takis.shotguntuttic)
				local string = ''
				if (takis.tossflag)
					local dec = L_FixedDecimal(
						FixedMul(
							FixedDiv(takis.tossflag*FU,
								17*FU
							),
							100*FU
						),
						1
					)
					string = "("..dec.."%) "
				end
				
				v.drawString(160,200-25,string.."\x82TOSSFLAG\x80: Shotgun Tutorial",
					V_ALLOWLOWERCASE|V_HUDTRANS|V_SNAPTOBOTTOM,
					"thin-center"
				)
			end
			
			--i fucking love this ....
			--TODO: i thought i fixed this?
			local lowercase = {
				["o"] = true,
				["u"] = true,
				["v"] = true,
				["e"] = true,
				["h"] = true,
				["u"] = true,
				["r"] = true,
				["t"] = true,
				["a"] = true,
				["k"] = true,
				["i"] = true,
				["s"] = true,
				["m"] = true,
			}
			
			if takis.HUD.timeshit
				local x,y = 160,170
				local trans = 0
				if takis.HUD.timeshit > (5*TR)
					trans = (takis.HUD.timeshit-5*TR)<<V_ALPHASHIFT
				elseif takis.HUD.timeshit < 10
					trans = (10-takis.HUD.timeshit)<<V_ALPHASHIFT
				end
				
				--buggie's tf2 engi code
				local scorenum = "SCREFT"
				local score = "You've hurt Takis "..takis.totalshit.." times..."
				
				local width = 0
				for i = 1,string.len(score)
					local n = string.sub(score,i,i)
					if lowercase[n] ~= nil
						n = $.."TH"
					end
					n = n:upper()
					width = $+v.cachePatch(scorenum+n).width*4/10
				end
				width = $/2
				
				
				local prevw
				if not prevw then prevw = 0 end
				
				for i = 1,string.len(score)
					local n = string.sub(score,i,i)
					if n == " "
						prevw = $+v.cachePatch(scorenum..n).width*4/10
						continue
					end
					if lowercase[n] ~= nil
						n = $.."TH"
					end
					n = n:upper()
					
					local xshake,yshake = happyshakelol(v)
					xshake,yshake = $1/2,$2/2
					v.drawScaled((x+prevw)*FU+xshake-(width*FU),
						y*FU+yshake,
						FU/2,
						v.cachePatch(scorenum..n),
						trans|V_SNAPTOBOTTOM
					)
						
					prevw = $+v.cachePatch(scorenum+n).width*4/10
				end
	
			end
			
		--not takis lol
		else
			
			if takis.io.morehappyhour == 0
			and (not takis.otherskin
			or takis.otherskintime == 1)
				customhud.SetupItem("PTSR_itspizzatime","spicerunners")
			else
				customhud.SetupItem("PTSR_itspizzatime",modname)
			end
			drawhappyhour(v,p)
			
			if not takis.otherskin
			or takis.otherskintime == 1
			or (wastakis or gamewastakis)
				if not nohudswitching
					customhud.SetupItem("rings",			altmodname)
					if not (HAPPY_HOUR.othergt)
						customhud.SetupItem("time",			altmodname)
						customhud.SetupItem("score",		altmodname)
					else
						customhud.SetupItem("time",			"spicerunners")
						customhud.SetupItem("score",		"spicerunners")			
					end
					customhud.SetupItem("lives",			altmodname)
					customhud.SetupItem("PTSR_bar",			"spicerunners")
					customhud.SetupItem("PTSR_tooltips",	"spicerunners")
					customhud.SetupItem("PTSR_rank", 		"spicerunners")
					--customhud.SetupItem("PTSR_combo", 		"spicerunners")
					customhud.SetupItem("PTSR_lap", 		"spicerunners")
					customhud.SetupItem("textspectator",	altmodname)
					customhud.SetupItem("crosshair",		altmodname)
				end
			end
			gamewastakis = false
			
			if p.inkart
				customhud.SetupItem("lives",			modname)
				drawviewmodel(v,p,cam)
				if not dontdrawtakishud
					drawlivesarea(v,p)
				end
				
				drawkartmeters(v,p)
				drawlapanim(v,p)
				--drawdriftmeter(v,p,cam)
				
				wastakis = true
				gamewastakis = true
				stillswitchitems = true
			end
			--wastakis = false
			--customhud.SetupItem("rank", "pizzatime2.0")
			
			--elfilin stuff
			/*
			if ((me) and (me.valid))
			and (me.skin == "elfilin")
			and (p.elfilin)
				--check out my sweet new ride!
				local ride = p.elfilin.ridingplayer
				
				if p.elfilin
				and ((ride) and (ride.valid))

					local p2 = ride.player
					local takis2 = p2.takistable
					
					if ride.skin == TAKIS_SKIN
						
						if takis2.io.nohappyhour == 0
						and takis.io.morehappyhour == 0
							customhud.SetupItem("PTSR_itspizzatime",modname)
							drawhappyhour(v,p2)
						end
						
						
						local workx = (265*FU)-(35*FU)
						
						--draw p2's heartcards
						for i = 1, TAKIS_MAX_HEARTCARDS
							local patch = v.cachePatch("HEARTCARD2")
							
							if takis2.heartcards >= i
								patch = v.cachePatch("HEARTCARD1")
							end
							
							v.drawScaled(
								workx,
								100*FU,
								FU/2,
								patch,
								V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER
							)
							
							workx = $+(12*FU)
							
						end
					
						
						--show p2's combo
						drawcombostuff(v,p2)
						
					end
					
				end
				
			end
			*/
			
			if takis.cosmenu.menuinaction
				drawcosmenu(v,p)
			end
		end
		drawjumpscarelol(v,p)
		--Tprtable("steam",takis.HUD.steam)
		--Only you can see these
		for k,va in ipairs(consoleplayer.takistable.HUD.steam)
			if va == nil
				continue
			end
			
			local enum = va.enum
			local bottom = 16*FU
			local trans = 0
			local yadd = 28*FU*(k-1)
			yadd = -$
			if va.tics < 10
				trans = (10-va.tics)<<V_ALPHASHIFT
			end
			
			local t = TAKIS_ACHIEVEMENTINFO
			local x = va.xadd
			
			v.drawScaled(178*FU+x,172*FU+yadd,FU,
				v.cachePatch("ACH_BOX"),
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM
			)
			v.drawScaled((300*FU)-118*FU+x,(200*FU)-bottom-(8*FU)+yadd,
				t[enum].scale or FU,
				v.cachePatch(t[enum].icon),
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM
			)
			v.drawString((300*FU)-100*FU+x,
				(200*FU)-bottom-(8*FU)+yadd,
				t[enum].name or "Ach. Enum "..enum,
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_RETURN8,
				"thin-fixed"
			)
			v.drawString((300*FU)-100*FU+x,
				(200*FU)-bottom+yadd,
				t[enum].text or "Flavor text goes here",
				trans|V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_RETURN8,
				"small-fixed"
			)
			
		end
		
		if takis.HUD.menutext.tics
			local trans = 0
			if takis.HUD.menutext.tics > (3*TR)
				trans = (takis.HUD.menutext.tics-3*TR)<<V_ALPHASHIFT
			elseif takis.HUD.menutext.tics < 10
				trans = (10-takis.HUD.menutext.tics)<<V_ALPHASHIFT
			end
			
			v.drawString(160,200-16,"\x86".."FN+C3+C2 (hold)\x80 - Open Menu",trans|V_ALLOWLOWERCASE|V_SNAPTOBOTTOM,"thin-center")
			v.drawString(160,200-8,"\x86takis_openmenu\x80 - Open Menu",trans|V_ALLOWLOWERCASE|V_SNAPTOBOTTOM,"thin-center")
		end
	
		drawdebug(v,p)
		
		if (me and me.valid)
		and (me.spbtarg and me.spbtarg.valid)
			local spb = me.spbtarg
			local patch,flip = v.getSprite2Patch(TAKIS_SKIN,
				spb.sprite2,
				false,
				spb.frame,
				1,
				spb.rollangle
			)
			
			v.drawScaled(290*FU,
				170*FU+(spb.spriteyoffset/2),
				FU/2,
				patch,
				V_SNAPTORIGHT|V_SNAPTOBOTTOM,
				v.getColormap(nil,spb.color)
			)
			
		end
		
	end
end)

addHook("HUD", function(v)
	if (TAKIS_DEBUGFLAG & DEBUG_SPEEDOMETER)
		v.drawString(0,0,
			"funny: "..L_FixedDecimal(
				FixedMul(
					FixedDiv(TAKIS_TITLETIME,120*TR),
					100*FU
				),
				1
			).."%",
			V_SNAPTOLEFT|V_SNAPTOTOP,
			"left"
		)
	end
	
	if TAKIS_TITLEFUNNY
		v.fadeScreen(35,10)
		
		TAKIS_TITLEFUNNYY = $*3/4
		
		local scale = FU*7/5
		local p = v.cachePatch("BALL_BUSTER")
		
		local x = v.RandomFixed()*3
		if ((TAKIS_TITLETIME%4) < 3)
			x = -$
		end
		
		v.drawScaled((160*FU)+x,TAKIS_TITLEFUNNYY,scale,p,0)	
	else
		if (TAKIS_TITLETIME >= 60*TR)
			local erm = FixedDiv((TAKIS_TITLETIME-60*TR)*FU or 1,60*TR*FU)
			local mul = FixedMul(erm,10*FU)
			
			mul = $/FU
			v.fadeScreen(35,mul)
		end
	end
end,"title")

local emeraldslist = {
	[0] = SKINCOLOR_GREEN,
	[1] = SKINCOLOR_SIBERITE,
	[2] = SKINCOLOR_SAPPHIRE,
	[3] = SKINCOLOR_SKY,
	[4] = SKINCOLOR_TOPAZ,
	[5] = SKINCOLOR_FLAME,
	[6] = SKINCOLOR_SLATE,
}

addHook("HUD", function(v)
	if consoleplayer
	and consoleplayer.takistable
		local p = consoleplayer
		local takis = p.takistable
		if takis.isTakis
			customhud.SetupItem("coopemeralds",modname)
			
			if G_CoopGametype()
			or (gametyperules & GTR_CAMPAIGN)
			and customhud.CheckType("coopemeralds") == modname
				if not multiplayer
					local maxspirits = 6
					local maxspace = 200
					for i = 0,maxspirits
						local patch,flip = v.getSpritePatch(SPR_TSPR,
							TakisFetchSpiritFrame(i,(emeralds & 1<<i ~= 0)),
							(((leveltime/4)+i)%8)+1
						)
						v.drawScaled(
							60*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i,
							120*FU,
							FU,
							patch,
							((flip) and V_FLIP or 0)|((emeralds & 1<<i == 0) and V_50TRANS or 0),
							v.getColormap(nil,emeraldslist[i])
						)
					end
				--mp display
				else
					local maxspirits = 6
					local maxspace = 66
					for i = 0,maxspirits
						local patch,flip = v.getSpritePatch(SPR_TSPR,
							TakisFetchSpiritFrame(i,(emeralds & 1<<i ~= 0)),
							(((leveltime/4)+i)%8)+1
						)
						v.drawScaled(
							20*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i,
							18*FU,
							FU/4,
							patch,
							((flip) and V_FLIP or 0)|((emeralds & 1<<i == 0) and V_50TRANS or 0),
							v.getColormap(nil,emeraldslist[i])
						)
					end			
				end
			end
			
			local flash,timetic,extratext,extrafunc,type = howtotimer(p)
			
 			/*if (type == "regular"
			and (gametyperules & GTR_CAMPAIGN))
			and not modeattacking
			and (doihaveminhud == false)*/
			if not shouldtimerdraw(v,p,false,type,forcedraw)
			and (customhud.CheckType("time") == modname)
				drawtimer(v,p,true)
			end
			
			--drawfallout(v,p,true)
			
		else
			--game hud doesnt run while this is in action so set this here
			if not takis.otherskin
			or takis.otherskintime == 1
			or wastakis
				customhud.SetupItem("coopemeralds",altmodname)
			end
		end
		
		drawjumpscarelol(v,p)
	end
end,"scores")

addHook("HUD", function(v,p,tic,endtic)
	if tic >= endtic then return end
	
	if not (p.takistable) then return end
	local takis = p.takistable
	customhud.SetupItem("stagetitle",	altmodname)
	
	if (skins[p.skin].name == TAKIS_SKIN)
		if (mapheaderinfo[gamemap].bonustype == 1)
			if takis.HUD.bosstitle.tic == 0
				customhud.SetupItem("stagetitle",	altmodname)
				return
			end
		else
			if (p.starpostnum ~= TAKIS_NET.maxpostcount+32)
				customhud.SetupItem("stagetitle",	altmodname)
				return
			end
		end
		
		customhud.SetupItem("stagetitle", 		modname)
	else
		if not takis.otherskin
		or takis.otherskintime == 1
		or wastakis
			customhud.SetupItem("stagetitle",	altmodname)
		end
	end
end,"titlecard")

addHook("HUD", function(v)
	if consoleplayer
	and consoleplayer.takistable
		local p = consoleplayer
		local takis = p.takistable
		
		if skins[consoleplayer.skin].name == TAKIS_SKIN
			customhud.SetupItem("intermissiontitletext",altmodname)
			if takis.lastss
				if not TAKIS_MISC.stagefailed
					customhud.SetupItem("intermissiontitletext",modname)
					
					local offset = 0
					if All7Emeralds(emeralds)
						local kstring = "\x82".."50\x80 rings, hold \x82".."C3"
						v.drawLevelTitle(160-(v.levelTitleWidth(kstring)/2),
							46,
							kstring,
							0
						)
						offset =  v.levelTitleHeight(kstring)
					end
					
					local string2 = (All7Emeralds(emeralds)) and "Got them all!" or "Got a Spirit!"
					if string.lower(G_BuildMapTitle(takis.lastmap)) == "black hole zone"
						string2 = "Got nothing LMAO"
					end
					v.drawLevelTitle(160-(v.levelTitleWidth(string2)/2),
						46 - offset,
						string2,
						0
					)
					
				end
				
				customhud.SetupItem("intermissionemeralds",	modname)
				local maxspirits = 6
				local maxspace = 200
				
				local em = takis.lastemeralds
				if TAKIS_MISC.inttic >= TR then em = emeralds end
				
				for i = 0,maxspirits
					local patch,flip = v.getSpritePatch(SPR_TSPR,
						TakisFetchSpiritFrame(i,(em & 1<<i ~= 0)),
						(((TAKIS_MISC.inttic/4)+i)%8)+1
					)
					v.drawScaled(
						60*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i,
						104*FU,
						FU,
						patch,
						((flip) and V_FLIP or 0)|((em & 1<<i == 0) and V_50TRANS or 0),
						v.getColormap(nil,emeraldslist[i])
					)
				end
				
				--tween
				if TAKIS_MISC.inttic < TR
					local expectedtime = TR
					for i = 0,maxspirits
						--we didnt even get this one
						if (emeralds & 1<<i == 0) then continue end
						--we already have it
						if (em & 1<<i) then continue end
						
						local patch,flip = v.getSpritePatch(SPR_TSPR,
							TakisFetchSpiritFrame(i,true),
							(((TAKIS_MISC.inttic/4)+i)%8)+1
						)
						
						local tweenx = ease.outexpo(( FU / expectedtime )*(TAKIS_MISC.inttic),160*FU, 60*FU+FixedDiv(maxspace*FU,maxspirits*FU)*i)
						local tweeny = ease.outexpo(( FU / expectedtime )*(TAKIS_MISC.inttic),-300*FU, 104*FU)
						
						v.drawScaled(
							tweenx,
							tweeny,
							FU,
							patch,
							((flip) and V_FLIP or 0),
							v.getColormap(nil,emeraldslist[i])
						)
					end
				end
				
			end
		else
			if not takis.otherskin
			or takis.otherskintime == 1
			or wastakis
				customhud.SetupItem("intermissionemeralds",	altmodname)
				customhud.SetupItem("intermissiontitletext",altmodname)
			end
		end
	end
end,"intermission")

TAKIS_FILESLOADED = $+1
