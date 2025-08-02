--reminder that this mod is "ASK ME" reusability, despite what 
--the discussion page says

-- "Terrible Character..."

rawset(_G, "TAKIS_DEBUG_HOOKS", false)

local function dprint(...)
	if not (TAKIS_DEBUG_HOOKS)
		return
	end
	print(...)
end

----FROM HERE TO SECOND ---- IS CODE WRITEN BY SAXASHITTER/LITERALLYMARIO/NICK
local __addHook = addHook
local at_file = "init.lua"

rawset(_G, "addHook", function(name, func, ...)
	dprint("\x83TAKIS:\x80 Hook "..name.." added")
	local filelocation = at_file
	__addHook(name, function(...)
		local first = getTimeMicros()
		local val = {func(...)}
		local second = getTimeMicros()
		if (second-first) > 5000 then
			dprint("\x83TAKIS:\x80 Hook "..name.." ran at higher rate than expected")
			dprint("Location: "..filelocation)
			dprint("Time taken (ms): "..tostring(second-first))
			dprint("")
		end
		
		return unpack(val)
	end, ...)
end)

----

rawset(_G, "TAKIS_ISDEBUG", true)
--stuff not related to config, like achievements and whatnot
rawset(_G, "TAKIS_USEOTHERIO", true)

if (VERSION == 202) and (SUBVERSION < 12)
	local special = P_RandomChance(FRACUNIT/13)
	local ticker = 0
	
	addHook("ThinkFrame",do
		ticker = $+1
		
		for p in players.iterate
			if skins[p.skin].name == "takisthefox"
				R_SetPlayerSkin(p,0)
			end
		end
	end)
	
	local txt = {
		"Your version of \x82SRB2",
		"is \x85outdated!",
		"Please update to",
		"\x82".."2.2.12+\x80!"
	}
	
	local function dep(v)
		local waveforce = FU*3
		local ay = FixedMul(waveforce,sin(FixedAngle(ticker*5*FU)))
		
		local box = v.cachePatch("BLACK_BOX_NUMBER_23423423")
		local x = 160*FU-(box.width*FU/2)
		local y = ay+80*FU--(box.height/2)
		
		
		v.fadeScreen(0xFF00,20)
		
		v.drawScaled(x,y,FU,box,V_50TRANS)
		
		local shitter = v.cachePatch("TA_POOPSHIT")
		v.drawScaled(x+(shitter.width*FU/2),
			y+(shitter.height*FU/2),
			FU/2,
			shitter,
			0
		)
		
		v.drawString(x+(box.width*FU/2)-2*FU,
			y+2*FU,
			"takis:",
			V_GREENMAP,
			"fixed"
		)
		
		for k,va in ipairs(txt)
			v.drawString(x+(box.width*FU/2)-2*FU,
				y+2*FU+(k*8*FU),
				va,
				V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		end
		
	end
	
	local hudlist = {
		"title",
		"game",
		"intermission",
		"scores",
	}
	
	for _,type in pairs(hudlist)
		addHook("HUD",dep,type)
	end
	
	S_StartSound(nil,sfx_skid)
	return
end

--from chrispy chars!!! by Lach!!!!
rawset(_G,"SafeFreeslot",function(...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			freeslot(item)
		end
	end
end)

local modversion = dofile("versionNum.lua")
local builddate = dofile("buildDate.lua")

rawset(_G, "takis_printdebuginfo",function(p)
	if not p
		print("\x82".."Extra Debug Stuff:\n"..
			/*
			"\x8D".."Build Date (MM/DD/YYYY) = \x80"..TAKIS_BUILDDATE.."\n"..
			"\x8D".."Build Time = \x80"..TAKIS_BUILDTIME.."\n"..
			*/
			"\x8D".."# of files done = \x80"..TAKIS_FILESLOADED.."/"..TAKIS_NUMFILES,
			"Mod version: "..modversion,
			"Build date: "..builddate.."\n"
			
		)	
	else
		CONS_Printf(p,"\x82".."Extra Debug Stuff:\n"..
			/*
			"\x8D".."Build Date (MM/DD/YYYY) = \x80"..TAKIS_BUILDDATE.."\n"..
			"\x8D".."Build Time = \x80"..TAKIS_BUILDTIME.."\n"..
			*/
			"\x8D".."# of files done = \x80"..TAKIS_FILESLOADED.."/"..TAKIS_NUMFILES,
			"Mod version: "..modversion,
			"Build date: "..builddate.."\n"
		)	
	end
end)

rawset(_G, "takis_printwarning",function(p)
	if not p
		print("\x82This is free for anyone to host!\n"..
			"Please send feedback and bug reports to \x83@epixgamer3333333\x82 on Discord!"
			
		)	
	else
		CONS_Printf(p,"\x82This is free for anyone to host!\n"..
			"Please send feedback and bug reports to \x83@luigibudd\x82 on Discord!"
		)	
	end
	
end)

local error_list = {}
local filetree = {
	"01-LUA_init.lua",
	"05-LUA_net.lua",
	
	--libs
	"libs/01-LUA_CustomHud.lua",
	"libs/02-LUA_functions.lua",
	"libs/03-LUA_achievements.lua",
	"libs/04-LUA_taunts.lua",
	"libs/05-LUA_menu.lua",
	"libs/06-LUA_happyhour.lua",
	"libs/07-LUA_NFreeroam.lua",
	"libs/08-LUA_Textboxes.lua",
	"SPEC-libs/09-LUA_RakisOverFang.lua",
	
	--objects
	"objects/01-LUA_shotgun.lua",
	"objects/02-LUA_heartcards.lua",
	"objects/03-LUA_metaldetector.lua",
	"objects/04-LUA_thokspawner.lua",
	"objects/05-LUA_crates.lua",
	"objects/06-LUA_dummy.lua",
	"objects/07-LUA_broly.lua",
	--"DEBUG-objects/08-LUA_gimmicks.lua",
	
	"02-LUA_io.lua",
	"03-LUA_main.lua",
	"04-LUA_cmds.lua",
	"DEBUG-06-LUA_devcmds.lua",
	"07-LUA_hud.lua",
	"08-LUA_misc.lua",
	"09-LUA_compat.lua",
	"10-LUA_kart.lua",
	"11-LUA_makestuff.lua",
	"12-LUA_events.lua",
	"13-LUA_bosshud.lua",
	
	"libs/10-LUA_TextboxHud.lua",
}
rawset(_G, "TAKIS_FILESLOADED", 0)
rawset(_G, "TAKIS_NUMFILES", #filetree)

--the file stuff
--execute files
for k,v in ipairs(filetree)
	at_file = v
	
	if (string.sub(v,1,5) == "SPEC-") then
		--??
		if input.gameControlDown(GC_TOSSFLAG)
			print("Skipped file "..v.."\n")
			TAKIS_NUMFILES = $-1
			continue
		end
		v = string.sub(v,6)
	end
	if (string.sub(v,1,6) == "DEBUG-") then
		if not TAKIS_ISDEBUG
			TAKIS_NUMFILES = $-1
			continue
		end
		v = string.sub(v,7)
	end
	
	if (string.sub(v,1,4) == "DNU-") then
		print("Skipped file "..v.."\n")
		TAKIS_NUMFILES = $-1
		continue
	end
	
	local old_done = TAKIS_FILESLOADED
	local bool,result = pcall(dofile,v)
	if TAKIS_FILESLOADED == old_done
		table.insert(error_list,{
			name = v,
			result = result
		})
	end
	--print(bool,result)
	
	print('Done file "'..v..'" ('..TAKIS_FILESLOADED..')\n')
end

takis_printdebuginfo()

if TAKIS_FILESLOADED ~= TAKIS_NUMFILES
	print("\x85"..(TAKIS_NUMFILES-TAKIS_FILESLOADED).." file(s) were not executed.")
	S_StartSound(nil,sfx_skid)
	
	for k,v in ipairs(error_list)
		local file = v.name
		print('\x85 * Expected file \x80"'..file..'"\x85 to complete, but got an error instead.')
		if v.result ~= nil
		print("\x85 @ -> "..v.result)
		end
	end
	print('')
end

--saxa
rawset(_G, "addHook", __addHook)

takis_printwarning()
