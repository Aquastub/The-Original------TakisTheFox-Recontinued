/*	HEADER
	Commands for debugging purposes
	
*/

if not TAKIS_ISDEBUG
	TAKIS_FILESLOADED = $+1
	return
end

local prn = CONS_Printf

local ranktonum = {
	["P"] = 6,
	["S"] = 5,
	["A"] = 4,
	["B"] = 3,
	["C"] = 2,
	["D"] = 1,
}

local function notinlevel()
	if not isdedicatedserver
		return gamestate ~= GS_LEVEL
	else
		if (p == server)
			return false
		else
			return gamestate ~= GS_LEVEL
		end
	end
	return false
end

COM_AddCommand("setrank", function(p,rank)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if rank == nil
		return
	end
	
	if (gametype ~= GT_PTSPICER)
		return
	end
	
	if not (ranktonum[rank])
		rank = "D"
	end
	
	if ranktonum[rank] > 6
		rank = "P"
	end
	
	if ranktonum[rank] < 1
		rank = "D"
	end
	
	
	local pec = (PTSR.maxrankpoints)/6
	if rank == "D"
		p.score = 0
	elseif rank == "C" then
		p.score = pec*2
		
	elseif rank == "B" then
		p.score = pec*4
	elseif rank == "A" then
		p.score = pec*8
	elseif rank == "S" then
		p.score = pec*13
	else
		/*
		if player.timeshit then
			player.ptsr_rank = "S"
		else
			player.ptsr_rank = "P"
		end
		*/
		
		player.ptsr_rank = "P"
	end
	

	
end,COM_ADMIN)

COM_AddCommand("sethp", function(p,type,amt)
	if notinlevel()
		return
	end
	if not p.mo.health
		return
	end
	local takis = p.takistable
	if not (takis.isTakis)
		return
	end
	if type == nil
		return
	end
	if amt == nil
		return
	end
	
	type = tonumber($)
	if ((type > 3) or (type < 1))
		return
	end
	
	TakisHealPlayer(p,p.mo,takis,type,amt)
end,COM_ADMIN)

local function GetPlayerHelper(pname)
	-- Find a player using their node or part of their name.
	local N = tonumber(pname)
	if N ~= nil and N >= 0 and N < 32 then
		for player in players.iterate do
			if #player == N then
	return player
			end
		end
	end
	for player in players.iterate do
		if string.find(string.lower(player.name), string.lower(pname)) then
			return player
		end
	end
	return nil
end
local function GetPlayer(player, pname)
	local player2 = GetPlayerHelper(pname)
	if not player2 then
		CONS_Printf(player, "No one here has that name.")
	end
	return player2
end

COM_AddCommand("setscore", function(p,score)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end

	if score == nil
		return
	end
	
	if string.lower(score) == "max"
		p.score = UINT32_MAX
		return
	end
	
	score = abs(tonumber(score))
	
	p.score = score
end,COM_ADMIN)

local shields = {
	["n"] = SH_NONE,
	["p"] = SH_PITY,
	["w"] = SH_WHIRLWIND,
	["a"] = SH_ARMAGEDDON,
	["pk"] = SH_PINK,
	["e"] = SH_ELEMENTAL,
	["m"] = SH_ATTRACT,
	["fa"] = SH_FLAMEAURA,
	["b"] = SH_BUBBLEWRAP,
	["t"] = SH_THUNDERCOIN,
	["f"] = SH_FORCE|1,
	["ff"] = SH_FIREFLOWER,
}

COM_AddCommand("reshield", function(p,sh,hp)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end

	if sh == nil
		return
	end
	
	sh = string.lower($)
	if not (sh == "setbit" or sh == "setbits")
		hp = abs(tonumber($) or 0)
		hp = min($,254)
		
		if shields[sh] ~= nil
			local shield = shields[sh]
			if shields[sh] ~= SH_NONE
				P_SpawnShieldOrb(p)
				if shield & SH_FORCE
					shield = SH_FORCE|hp
				end
			else
				P_RemoveShield(p)
				shield = SH_NONE
			end
			P_SwitchShield(p,shield)
			if sh == "ff"
				p.realmo.color = SKINCOLOR_WHITE
			end
		end
	else
		hp = abs(tonumber($) or 0)
		
		if hp == 0
			prn(p,"Second argument must be bits to be set.")
			prn(p,(1).."    - SH_PITY")
			prn(p,(2).."    - SH_WHIRLWIND")
			prn(p,(3).."    - SH_ARMAGEDDON")
			prn(p,(4).."    - SH_PINK")
			prn(p,(256).."  - SH_FORCE (255 & under HP)")
			prn(p,(512).."  - SH_FIREFLOWER")
			prn(p,(1024).." - SH_PROTECTFIRE")
			prn(p,(2048).." - SH_PROTECTWATER")
			prn(p,(4096).." - SH_PROTECTELECTRIC")
			prn(p,(8192).." - SH_PROTECTSPIKE")
			return
		end
		
		p.powers[pw_shield] = hp
		P_SpawnShieldOrb(p)
		
	end
	
end,COM_ADMIN)

COM_AddCommand("leave", function(p)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	P_DoPlayerExit(p)
	p.exiting = 4
	p.pflags = $|PF_FINISHED
end,COM_ADMIN)

COM_AddCommand("setdebug", function(p,...)
	local args = {...}
	/*
	if args == {}
		CONS_Printf(p,"Current flag is "..TAKIS_DEBUGFLAG)
		CONS_Printf(p,"Use: speedometer, happyhour, buttons")
		return
	end
	*/
	
	for _, enum in ipairs(args)
		local todo = string.upper(enum)
		local realnum = _G["DEBUG_"..todo] or 0
		if realnum ~= 0
			if TAKIS_DEBUGFLAG & realnum
				TAKIS_DEBUGFLAG = $ &~realnum
			else
				TAKIS_DEBUGFLAG = $|realnum
			end
		else
			prn(p,"Flag invalid ("..todo..")")
		end
	end
	
end,COM_LOCAL)

COM_AddCommand("panic", function(p,tics,flags)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if (HAPPY_HOUR.othergt)
		if not HAPPY_HOUR.happyhour
			COM_BufInsertText(p,"ptsr_panic")
		else
			COM_BufInsertText(p,"ptsr_timeto1")
		end
		return
	end
	
	if tics == nil
		return
	end
	
	if flags == nil
		flags = 0
	end
	
	flags = abs(tonumber($)) or 0
	
	tics = abs(tonumber($)) or 0
	
	if (flags & 1 == 1)
		tics = $*TR
	elseif (flags & 2 == 2)
		tics = $*60*TR
	end
	
	--erm,, whatevre, set it to the playher
	HH_Trigger(p.realmo,p,tics)
	
end,COM_ADMIN)

COM_AddCommand("shotgun", function(p,force)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if not (p.mo.health)
	or (p.mo.skin ~= TAKIS_SKIN)
		prn(p,"You can't use this right now.")
		return	
	end
	
	local takis = p.takistable
	
	if (takis.shotgunned)
		TakisDeShotgunify(p,force ~= nil)
	
	else
		TakisShotgunify(p)
	end
	
end,COM_ADMIN)

COM_AddCommand("kart", function(p,mine,idk)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	/*
	local thing = false
	--yeah this lets other people using my name use this
	--but WHO CARES this command is basically harmless lmao
	if (p.name == "luigi budd") --LMAO
		aval = true
		thing = true
	end
	
	
	*/
	
	local aval = TAKIS_NET.allowkarters
	if not aval
		if not (p.takistable.license.haslicense)
		or not (p == server or IsPlayerAdmin(p))
			prn(p,"Unknown command 'kart'")	--lmao
			return	
		end
		
		if (gametype == GT_SAXAMM)
			prn(p,"Karts are restricted in this gamemode.")
			return	
		end
	end
	
	if not (p.takistable.license.haslicense)
		prn(p,"Unknown command 'kart'")
		return
	end
	
	if not (p.mo and p.mo.valid and p.mo.health)
		prn(p,"You can't use this right now.")
		return	
	end
	
	local thing = true
	do
		local angle = p.mo.angle+ANGLE_90
		local k = P_SpawnMobjFromMobj(p.mo,
			(not circuitmap) and P_ReturnThrustX(nil,angle,-75*FU) or 0,
			(not circuitmap) and P_ReturnThrustY(nil,angle,-75*FU) or 0,
			0,MT_TAKIS_KART
		)
		k.angle = p.mo.angle
		if (mine ~= nil)
			k.owner = p
		end
		if thing
			k.paidfor = true
		end
		if idk
			k.special = true
		end
	end
end)

local function GetPlayerHelper(pname)
	-- Find a player using their node or part of their name.
	local N = tonumber(pname)
	if N ~= nil and N >= 0 and N < 32 then
		for player in players.iterate do
			if #player == N then
	return player
			end
		end
	end
	for player in players.iterate do
		if string.find(string.lower(player.name), string.lower(pname)) then
			return player
		end
	end
	return nil
end
local function GetPlayer(player, pname)
	local player2 = GetPlayerHelper(pname)
	if not player2 then
		CONS_Printf(player, "No one here has that name.")
	end
	return player2
end

COM_AddCommand("shotgunfor", function(p,node,force)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if node == nil
		return
	end
	
	local p2 = GetPlayer(p,node)
	if p2
		if not (p2.takistable)
			prn(p,"They can't use this right now.")
			return	
		end
		
		local takis = p2.takistable
		if not (p2.mo.health)
		or (p2.mo.skin ~= TAKIS_SKIN)
			prn(p,"They can't use this right now.")
			return	
		end
		
		if (takis.shotgunned)
			TakisDeShotgunify(p2,force ~= nil)
			prn(p2,p.name.." stole your Shotgun!")
		
		else
			TakisShotgunify(p2)
			prn(p2,p.name.." gifted you with the Shotgun")
		end
		
		prn(p,"Shotgunified "..p2.name)
	end
end,COM_ADMIN)

COM_AddCommand("setmaxhp",function(p,amt)
	if notinlevel()
		CONS_Printf(p,"You can't use this right now.")
	end


	if (amt == nil)
		CONS_Printf(p,"Type number lel")
		return
	else
		amt = abs(tonumber(amt))
		if amt == 0
			CONS_Printf(p,"You do this you die")
			return
		end
		TakisChangeHeartCards(amt)
	end
end,COM_ADMIN)

COM_AddCommand("forcedialog",function(p,type)
	if notinlevel()
		CONS_Printf(p,"You can't use this right now.")
	end
	
	if TAKIS_TEXTBOXES[type] ~= nil
		TakisTextBoxes:DisplayBox(p,TAKIS_TEXTBOXES[type])
	else
		prn(p,"Textbox set doesn't exist.")
	end
end,COM_ADMIN)

COM_AddCommand("killme",function(p,type)
	if notinlevel()
		CONS_Printf(p,"You can't use this right now.")
	end
	
	if type == nil then return end
	
	type = string.upper($)
	type = _G["DMG_"..type] or DMG_INSTAKILL
	P_KillMobj(p.realmo,nil,nil,type)
	p.takistable.saveddmgt = type
	
end,COM_ADMIN)

COM_AddCommand("reinvuln", function(p,tics,flags)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if tics == nil
		return
	end
	
	if flags == nil
		flags = 0
	end
	
	flags = abs(tonumber($)) or 0
	
	tics = abs(tonumber($)) or 0
	
	if (flags & 1 == 1)
		tics = $*TR
	elseif (flags & 2 == 2)
		tics = $*60*TR
	end
	
	p.powers[pw_invulnerability] = tics
end,COM_ADMIN)

COM_AddCommand("freeroam",NiGHTSFreeroam,COM_ADMIN)

COM_AddCommand("spheres", function(p, num)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil then return end
	
	num = tonumber($)
	
	p.spheres = num
end,COM_ADMIN)

COM_AddCommand("rings", function(p, num)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil then return end
	
	num = tonumber($)
	
	p.rings = num
end,COM_ADMIN)

COM_AddCommand("lives", function(p, num)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil then return end
	
	num = tonumber($)
	
	p.lives = num
end,COM_ADMIN)

COM_AddCommand("setach", function(p, num)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil 
		if num == "all"
			for i = 0,NUMACHIEVEMENTS-1
				TakisAwardAchievement(p,1<<i)
			end
		end
		return
	end
	
	local file = p.takistable.achfile
	local enum = 1<<tonumber(num)
	
	TakisAwardAchievement(p,enum)
	
end,COM_ADMIN)

COM_AddCommand("sharecombo", function(p, num)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil 
		return
	end
	
	local sharedex = p.takistable.HUD.comboshare[#p]
	sharedex.comboadd = $+num
	sharedex.tics = TR*3/2
	local x,y = R_GetScreenCoords(nil,p,camera,players[#p].realmo)
	sharedex.x,sharedex.y = x,y
	sharedex.startx,sharedex.starty = x,y
	
end,COM_ADMIN)

COM_AddCommand("forcecheat", function(p)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	G_SetUsedCheats(false)
	
end,COM_ADMIN)

COM_AddCommand("pong", function(p)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	TakisSpawnPongler(p.realmo,p.drawangle)
	
end,COM_ADMIN)

COM_AddCommand("testmap", function(p,act)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	act = tonumber(act)
	if act == nil
		act = 1
	elseif act < 1
		act = 1
	elseif act > 2
		act = 2
	end
	
	local map = 1002+act
	
	if G_BuildMapTitle(map) ~= "Test Room "..act
		prn(p,"Test map "..act.." has been replaced, cannot teleport.")
		return	
	end
	
	G_SetCustomExitVars(map,2)
	G_ExitLevel()
	
end,COM_ADMIN)

COM_AddCommand('powerstone', function(p, arg)
	if arg == nil
		return
	else
		if arg == 'all' then arg = '1234567' end
		local previous = p.powers[pw_emeralds]
		p.powers[pw_emeralds] = 0
		local bit = 1
		for i=1,7 do
			if string.find(arg, tostring(i)) ~= nil then
				p.powers[pw_emeralds] = $ | bit
			end
			bit = $ * 2
		end
	end
end, COM_ADMIN)

COM_AddCommand("prhappyhour", function(p)
	local strings = Tprtable("Happy Hour",HAPPY_HOUR,false)
	for k,va in ipairs(strings)
		print(va)
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
	
	print("door: {x="..(dh.x or "nil")..",y="..(dh.y or "nil")..",z="..(dh.z or "nil").."}")
	print("trig: {x="..(th.x or "nil")..",y="..(th.y or "nil")..",z="..(th.z or "nil")..",f="..(tostring(th.flip) or "nil").."}")
	print("candoshit: "..tostring( HH_CanDoHappyStuff(p) ))
end,COM_ADMIN)

/*
COM_AddCommand("spb", function(p,node,allowself,speed)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	local thok = P_SpawnMobj(0,0,0,MT_THOK)
	local realmo = (p.realmo or thok)
	local targetmo = TAKIS_NET.scoreboard[1].realmo
	
	local spb = P_SpawnMobjFromMobj(realmo,
		-140*cos(realmo.angle),
		-140*sin(realmo.angle),
		0,MT_TAKIS_BOMBLMAO)
	spb.parent = p
	spb.tracer = realmo
	--P_SetOrigin(spb,0,0,0)
	
	if speed == nil then speed = 48*FU end
	speed = L_DecimalFixed($)
	print(string.format("%f",speed))
	
	if node ~= nil
		local p2 = GetPlayer(p,node)
		if p2
			
			if not (p2.mo.health)
				prn(p,"This person is already dead, sending to 1st place...")
			else
				targetmo = p2.realmo
			end
			
		end
	end
	
	if targetmo == realmo
	and not allowself
		prn(p,"This would've sent to you. Add true to the end of the command to allow this.")
		P_RemoveMobj(spb)
		return
	end
	
	spb.target = targetmo
	spb.movedir = R_PointToAngle2(spb.x,spb.y, targetmo.x,targetmo.y)
	for p in players.iterate
		if p.realmo ~= targetmo
			S_StartSound(spb,sfx_kc57,p)
		else
			S_StartSound(nil,sfx_kc57,p)
		end
	end
	spb.myspeed = speed
	
	prn(p,"Sent out SPB to "..targetmo.player.name)
end,COM_ADMIN)
*/

local DBG_FREEZEMO = (1<<0)
local DBG_FREEZEPMO = (1<<1)

COM_AddCommand("freezemo", function(p,player)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	local pcount = 0
	for player in players.iterate
		pcount = $+1
	end
	
	if (pcount > 1 and not TAKIS_FREEZEDBG)
		prn(p,"You can't use this in netgames.")
		return
	end
	
	if player == "disable"
		print((TAKIS_FREEZEDBG == -1 and "Enabling" or "Disabling").." freeze thinker.")
		TAKIS_FREEZEDBG = -1 - $		
		return
	end
	
	if TAKIS_FREEZEDBG and not player
		print("Mobjs have been thawed")
		TAKIS_FREEZEDBG = 0
	else
		if not (TAKIS_FREEZEDBG & DBG_FREEZEMO)
			print("Mobjs have been frozen")
			TAKIS_FREEZEDBG = DBG_FREEZEMO
		end
		if player
		and not (TAKIS_FREEZEDBG & DBG_FREEZEPMO)
			print("Player mobjs have been frozen")
			TAKIS_FREEZEDBG = $|DBG_FREEZEPMO
		end
	end
	
end,COM_ADMIN)

/*
COM_AddCommand("dobonus", function(p,bonust)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end

	if not (p.takistable)
		prn(p,"You can't use this right now.")
		return	
	end
	
	if bonust == nil
		return	
	end
	bonust = string.lower($)
	
	local takis = p.takistable
	local bonus = takis.bonuses
	if bonust == "shotgun"
		bonus["shotgun"].tics = 3*TR+18
		
	elseif bonust == "ultimatecombo"
		bonus["ultimatecombo"].tics = 3*TR+18
		
	elseif bonust == "heartcard"
		table.insert(bonus.cards,{tics = TR+18,score = 100,text = "\x8EHeart Card\x80"})
	end
end,COM_ADMIN)
*/

COM_AddCommand("spawnmobj", function(p,type,aiming,offset)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	local me = p.realmo
	if not (me and me.valid)
		prn(p,"You can't use this right now.")
		return
	end

	if type == nil
		prn(p,"spawnmobj <type> <aiming> <offset>")
		return
	end
	
	local mobjtype = nil
	if offset == nil then offset = "50" end
	local soffset = L_DecimalFixed(offset)
	--if soffset == 0 then soffset = 50*FU end
	soffset = FixedMul($,me.scale)
	
	if tonumber(type) ~= nil
		mobjtype = abs(tonumber(type))
	else
		if tostring(type) ~= nil
			local tstring = string.upper(tostring(type))
			if (string.sub(tstring,1,3) ~= "MT_")
				tstring = "MT_"..$
			end
			if (pcall(do return _G[tstring] end))
				mobjtype = _G[tstring]
			end
		end
	end
	
	if mobjtype == nil
	or (mobjtype < 0)
	or (mobjtype > #mobjinfo)
	or (mobjinfo[mobjtype] == nil)
		mobjtype = nil
	end
	
	if mobjtype == nil
		prn(p,"Type does not exist")
		return
	end
	
	soffset = $+mobjinfo[mobjtype].radius
	local off2 = {x = 0, y = 0, z = 0}
	if aiming ~= nil
		--off2.x = FixedMul(soffset,cos(p.aiming))
		--off2.y = FixedMul(soffset,sin(p.aiming))
		off2.z = FixedMul(soffset,sin(p.aiming))
	end
	
	local spawn = P_SpawnMobjFromMobj(me,
		P_ReturnThrustX(nil,me.angle,soffset)+off2.x,
		P_ReturnThrustY(nil,me.angle,soffset)+off2.y,
		off2.z,
		mobjtype
	)
	spawn.angle = me.angle
	spawn.scale = me.scale
	
	if (spawn.renderflags & RF_PAPERSPRITE)
	or (spawn.frame & FF_PAPERSPRITE)
		spawn.angle = $+ANGLE_90
	end
	
end,COM_ADMIN)

COM_AddCommand("tpto", function(p,node)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if node == nil
		return
	end
	
	local me = p.realmo
	if not (me and me.valid)
		prn(p,"You can't use this right now.")
		return
	end
	
	local p2 = GetPlayer(p,node)
	if p2
		local mo = p2.realmo
		if not (mo and mo.valid)
			prn(p,"You can't use this right now.")
			return
		end
		
		me.momz = 0
		P_SetOrigin(me,mo.x,mo.y,mo.z)
	end
end,COM_ADMIN)

COM_AddCommand("tpme", function(p,node)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if node == nil
		prn(p,"tpme <name or node to bring>")
		prn(p,"Use @all to being everyone")
		return
	end
	
	local me = p.realmo
	if not (me and me.valid)
		prn(p,"You can't use this right now.")
		return
	end
	
	if node == "@all"
		for p2 in players.iterate
			if (p2 == p) then continue end
			
			local mo = p2.realmo
			if not (mo and mo.valid)
				prn(p,"They can't use this right now.")
				continue
			end
			
			mo.reactiontime = 2
			mo.momz = 0
			P_SetOrigin(mo,me.x,me.y,me.z)
		end
		return
	end
	
	local p2 = GetPlayer(p,node)
	if p2
		local mo = p2.realmo
		if not (mo and mo.valid)
			prn(p,"They can't use this right now.")
			return
		end
		
		mo.reactiontime = 2
		mo.momz = 0
		P_SetOrigin(mo,me.x,me.y,me.z)
	end
end,COM_ADMIN)

COM_AddCommand("damageboss", function(p, num)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if tonumber(num) == nil then return end
	local takis = p.takistable
	
	if not takis
		prn(p,"You can't use this right now.")
		return
	end
	
	local boss = takis.HUD.bosscards.mo
	
	num = tonumber($)
	
	P_DamageMobj(boss,nil,p.realmo,num)
end,COM_ADMIN)

COM_AddCommand("brolyki", function(p, tics, scalemul)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	tics = tonumber($)
	if tics == nil
		tics = TR --states[S_TAKIS_BROLYKI].tics
	end
	tics = abs($)
	
	scalemul = L_DecimalFixed($)
	if scalemul == 0
	or scalemul == nil
		scalemul = FU
	end
	scalemul = abs($)
	
	local ki = P_SpawnMobjFromMobj(p.realmo,0,0,0,MT_TAKIS_BROLYKI)
	ki.tracer = p.realmo
	ki.tics = tics
	ki.threshold = tics
	ki.scalemul = scalemul
	ki.color = p.realmo.color
	
end,COM_ADMIN)

/*
COM_AddCommand("thrustcrawla", function(p,push)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	local craw = P_SpawnMobjFromMobj(p.mo,
		P_ReturnThrustX(nil,p.mo.angle,64*p.mo.scale),
		P_ReturnThrustY(nil,p.mo.angle,64*p.mo.scale),
		0,
		MT_BLUECRAWLA
	)
	craw.flags = $|MF_SLIDEME
	if push
		craw.flags = $|MF_PUSHABLE
	end
	craw.angle = p.mo.angle
	
	P_Thrust(craw,craw.angle,64*craw.scale)
	craw.fuse = 3*TR
end,COM_ADMIN)
*/

COM_AddCommand("doas", function(p,node,...)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	if node == nil
		prn(p,"doas <player name/node> <command1, command2, ...>.")
		prn(p,"	-Executes any commands as a player. Accepts spaces.")
		return
	end
	
	local consinput = ''
	do
		for _,v in ipairs({...})
			consinput = $..v.." "
		end
	end
	
	local p2 = GetPlayer(p,node)
	if p2
		if p2 == server
		and string.find(string.lower(consinput),"quit")
			prn(p,"You can't make the server quit.")
			return
		end
		
		COM_BufInsertText(p2,consinput)
		prn(p,'Executed "'..consinput..'" as '..p2.name)
	end
end,COM_ADMIN)

/*
COM_AddCommand("bumperlol", function(p)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	local craw = P_SpawnMobjFromMobj(p.mo,
		P_ReturnThrustX(nil,p.realmo.angle,100*p.mo.scale) + p.realmo.momx,
		P_ReturnThrustY(nil,p.realmo.angle,100*p.mo.scale) + p.realmo.momy,
		0,
		MT_TAKIS_BUMPERLMAO
	)
	craw.flags = $|MF_SLIDEME
	craw.angle = p.realmo.angle
	P_Thrust(craw,craw.angle,64*craw.scale + FixedHypot(p.realmo.momx,p.realmo.momy))
	S_StartSound(p.realmo,sfx_kc5b)
	S_StartSound(p.realmo,sfx_s3k51)
end,COM_ADMIN)
*/

COM_AddCommand("rescale", function(p, scalemul)
	if notinlevel()
		prn(p,"You can't use this right now.")
		return
	end
	
	scalemul = L_DecimalFixed($)
	if scalemul == 0
	or scalemul == nil
		scalemul = FU
	end
	
	p.realmo.destscale = scalemul
	--p.realmo.scalespeed = FixedDiv((scalemul - p.realmo.scale),TR*FU/2)
	
end,COM_ADMIN)

COM_AddCommand("debughooks",function(p)
	if notinlevel()
		CONS_Printf(p,"You can't use this right now.")
	end
	
	TAKIS_DEBUG_HOOKS = not $
	
	prn(p,"Hook time debugging has been turned "..(TAKIS_DEBUG_HOOKS and "on" or "off"))
	
end,COM_ADMIN)

addHook("ThinkFrame",do
	local pcount = 0
	for player in players.iterate
		pcount = $+1
	end
	
	if (pcount > 1 and not TAKIS_FREEZEDBG) then return end
	if TAKIS_FREEZEDBG == -1 then return end
	
	for mo in mobjs.iterate()
		
		if TAKIS_FREEZEDBG
			if (mo.player and mo.player.valid) and not (TAKIS_FREEZEDBG & DBG_FREEZEPMO) then continue end
			if (mo.prevthink ~= nil) then continue end
			if mo.prevthink == nil
				mo.prevthink = (mo.flags & MF_NOTHINK)
			end
			mo.flags = $|MF_NOTHINK
		else
			if (mo.prevthink == nil) then continue end
			if mo.prevthink == 0
				mo.flags = $ &~MF_NOTHINK
			end
			mo.prevthink = nil
		end
		
	end
	
end)

/*
COM_AddCommand("_gmodify", function(p,gdex,value,vty)
	local dex = _G[gdex]
	
	if dex == nil
		prn(p,"This global var is nil")
		return
	end
	
	local type = type(dex)
	
	if type == "no value"
		prn(p,"This global var has no value")
		return
	elseif type == "function"
		prn(p,"This global var is a function")
		return
	elseif type == "table"
		prtable(gdex,dex)
		return
	end
	
	if vty == "boolean"
		value = boolean[string.lower($)]
	elseif vty == "number"
		value = tonumber($)
	end
	
	print("Changing "..gdex.." from "..tostring(dex).." to "..tostring(value))
	dex = value
	print(dex)
	
end,COM_ADMIN)
*/

TAKIS_FILESLOADED = $+1
