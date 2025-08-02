/*	HEADER
	For config loading and whatnot
	
*/

--we load other people's config sometimes, maybe add another file
--with the player name? dont load if they mismatch?
--obv we cant put it in the config file, we need to be...
--conservative with file size

--thank you SMS reborn for being reusable!
--Y7GDSUYFHIDJPK AAAAAAAAAAAHHHHHHHHH!!!!!!!!
COM_AddCommand("takis_load", function(p,loadlicense, sig, a1,a2,a3,a4,t1,t2,a5,a6,a7,a8,a9,a10,a11,a12,timeshit)
	
	
	if sig ~= TAKIS_ACHIEVEMENTINFO.luasig
		CONS_Printf(p,"\x85"+"Do not use this command manually!")
		return
	end
	
	if a1 == nil
		p.takistable.io.savestate = 4
		p.takistable.io.savestatetime = 2*TR
		p.takistable.io.loaded = true
		CONS_Printf(p,"\x85There was an error loading your Takis config! Try again through the menu.")
		S_StartSound(nil,sfx_lose,p)
		return
	end
	
	if not p.takistable then return end
	local errored = false

	if (TAKIS_DEBUGFLAG & DEBUG_CONFIG)
		print("\x83TAKIS:\x80 ("..p.name..") takis_load: Loading config...")
	end
	
	if (loadlicense == "yes")
	and TAKIS_USEOTHERIO
		if (TAKIS_DEBUGFLAG & DEBUG_CONFIG)
			print("\x83TAKIS:\x80 ("..p.name..") takis_load: Loading license...")
		end
		
		a1 = tonumber($)
		a2 = tonumber($)
		a3 = tonumber($)
		a4 = tonumber($)
		t1 = tonumber($)
		local license = p.takistable.license
		
		if a1 >= 0
			license.ranover = a1
		else
			CONS_Printf(p,"\x85"+"Error loading Lincense value 1! Defaulting to 0...")
			errored = true
		end

		if a2 >= 0
			license.miles = a2
		else
			CONS_Printf(p,"\x85"+"Error loading Lincense value 2! Defaulting to 0...")
			errored = true
		end

		if a3 >= 0
			license.crashes = a3
		else
			CONS_Printf(p,"\x85"+"Error loading Lincense value 3! Defaulting to 0...")
			errored = true
		end

		if a4 >= 0
			license.bumps = a4
		else
			CONS_Printf(p,"\x85"+"Error loading Lincense value 4! Defaulting to 0...")
			errored = true
		end
		
		if t1 >= 0
			license.mugshot = t1
		else
			CONS_Printf(p,"\x85"+"Error loading Lincense value 5! Defaulting to 0...")
			errored = true
		end
		
		--wtf.....
		p.takistable.license.haslicense = true
		p.takistable.io.savestate = (errored and 4 or 2)
		p.takistable.io.savestatetime = 2*TR
		p.takistable.io.loaded = true
		return
	end
	
	a1 = tonumber($) --Turn all of you to numbers!
	a2 = tonumber($)
	a3 = tonumber($)
	a4 = tonumber($)
	--quick taunts
	t1 = tonumber($)
	t2 = tonumber($)

	a5 = tonumber($)
	a6 = tonumber($)
	a7 = tonumber($)
	a8 = tonumber($)
	a9 = tonumber($)
	a10 = tonumber($)
	a11 = tonumber($)
	a12 = tonumber($)
	timeshit = tonumber($)

	local takis = p.takistable

	if a1 == 1
		takis.io.nostrafe = 1
	elseif a1 == 0
		takis.io.nostrafe = 0
	else
		CONS_Printf(p,"\x85"+"Error loading No-Strafe! Defaulting to 0...")
		errored = true
	end

	if a2 == 1
		takis.io.nohappyhour = 1
	elseif a2 == 0
		takis.io.nohappyhour = 0
	else
		CONS_Printf(p,"\x85"+"Error loading No Happy Hour! Defaulting to 0...")
		errored = true
	end
	
	if a3 == 1
		takis.io.minhud = 1
	elseif a3 == 0
		takis.io.minhud = 0
	else
		CONS_Printf(p,"\x85"+"Error loading MinHud! Defaulting to 0...")
		errored = true
	end
	
	if a4 == 1
		takis.io.morehappyhour = 1
	elseif a4 == 0
		takis.io.morehappyhour = 0
	else
		CONS_Printf(p,"\x85"+"Error loading More Happy Hour! Defaulting to 0...")
		errored = true
	end

	--1-7 pls
	if t1 ~= nil
	and (t1 < 8)
		takis.tauntquick1 = t1
	else
		CONS_Printf(p,"\x85"+"Error loading Quick Taunt slot 1! Defaulting to 0...")
		errored = true
	end

	--1-7 pls
	if t2 ~= nil
	and (t2 < 8)
		takis.tauntquick2 = t2
	else
		CONS_Printf(p,"\x85"+"Error loading Quick Taunt slot 2! Defaulting to 0...")
		errored = true
	end

	if a5 == 1
		takis.io.tmcursorstyle = 1
	elseif a5 == 2
		takis.io.tmcursorstyle = 2
	else
		CONS_Printf(p,"\x85"+"Error loading Cursor Style! Defaulting to 1...")
		errored = true
	end

	if a5 == 1
		takis.io.quakes = 1
	elseif a5 == 0
		takis.io.quakes = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Quakes! Defaulting to 1...")
		errored = true
	end

	if a7 == 1
		takis.io.flashes = 1
	elseif a7 == 0
		takis.io.flashes = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Flashes! Defaulting to 1...")
		errored = true
	end

	if a10 == 1
		takis.io.clutchstyle = 1
	elseif a10 == 0
		takis.io.clutchstyle = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Clutch Style! Defaulting to 1..")
		errored = true
	end

	if a11 == 1
		takis.io.sharecombos = 1
	elseif a11 == 0
		takis.io.sharecombos = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Share Combos! Defaulting to 1...")
		errored = true
	end

	if a12 == 1
		takis.io.dontshowach = 1
	elseif a12 == 0
		takis.io.dontshowach = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Don't show Achs.! Defaulting to 1...")
		errored = true
	end
	
	if a8 == 1
		takis.io.laggymodel = 1
	elseif a8 == 0
		takis.io.laggymodel = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Laggy Model! Defaulting to 1...")
		errored = true
	end
	
	if a9 == 1
		takis.io.autosave = 1
	elseif a9 == 0
		takis.io.autosave = 0
	else
		CONS_Printf(p,"\x85"+"Error loading Autosave! Defaulting to 1...")
		errored = true
	end
	
	if (timeshit ~= nil)
	and timeshit > 0
		takis.totalshit = abs(timeshit)
	end

	CONS_Printf(p, "\x82Loaded "..skins[TAKIS_SKIN].realname.."' Settings!")
	p.takistable.io.savestate = (errored and 4 or 2)
	p.takistable.io.savestatetime = 2*TR
	p.takistable.io.loaded = true
end)

rawset(_G, "TakisConstructSaveCode", function(p, default)
	local a1 = 0	--nostrafe
	local a2 = 0	--nohappyhour
	local a3 = 0	--minhud
	local a4 = 0	--morehappyhour
	local t1 = 0	--quicktaunt1
	local t2 = 0	--quicktaunt2
	local a5 = 1	--cursorstyle
	local a6 = 1	--quakes
	local a7 = 1	--flashes
	local a8 = 0	--laggymodel
	local a9 = 1	--autosave
	local a10 = 1	--clutchstyle
	local a11 = 1	--sharecombos
	local a12 = 0	--dontshowach
	local timeshit = 0	--idk what this one does lmao
	
	if not default
		local t = p.takistable.io
		local tay = p.takistable
		
		a1 = t.nostrafe
		a2 = t.nohappyhour
		a3 = t.minhud
		a4 = t.morehappyhour
		t1 = tay.tauntquick1
		t2 = tay.tauntquick2
		a5 = t.tmcursorstyle
		a6 = t.quakes
		a7 = t.flashes
		a8 = t.laggymodel
		a9 = t.autosave
		a10 = t.clutchstyle
		a11 = t.sharecombos
		a12 = t.dontshowach
		timeshit = tay.totalshit
	end
	
	return	" "..a1.." "..a2.." "..a3.." "..a4.." "..t1.." "
			..t2.." "..a5.." "..a6.." "..a7.." "..a8.." "..a9.." "
			..a10.." "..a11.." "..a12.." "..timeshit
end)

rawset(_G, "TakisSaveStuff", function(p, silent, forcebackup)
	if not (p and p.valid) then return end
	if (TAKIS_DEBUGFLAG & DEBUG_CONFIG)
		print("\x83TAKIS:\x80 ("..p.name..") TakisSaveStuff(): Saving config...")
	end
	
	if (p ~= consoleplayer) then return end
	if forcebackup == nil then forcebackup = false end
	if (modeattacking) then return end
	
	local t = p.takistable.io
	local tay = p.takistable
	--well i dont see why not
	TakisSaveAchievements(p)
	TakisKart_SaveLicense(p)
	p.takistable.io.savestate = 1
	
	--write
	--TODO: version numbers to prevent messed up saves
	DEBUG_print(p,IO_CONFIG|IO_SAVE)
	
	t.hasfile = true
	
	local file = io.openlocal("client/takisthefox/config.dat", "r")
	local backup = io.openlocal("client/takisthefox/backupconfig.dat","r")
	if file
		if file
			local donotsave = false
			
			if not p.takistable.io.loaded
				CONS_Printf(p, "\x85".."Couldn't save "..skins[TAKIS_SKIN].realname.."' settings! (Save not loaded yet!)")
				donotsave = true
			elseif p.jointime < TR*2
				CONS_Printf(p, "\x85".."Couldn't save "..skins[TAKIS_SKIN].realname.."' settings! (Ingame for less than 2 seconds!)")
				donotsave = true
			end
			
			if donotsave
				file:close()
				p.takistable.io.savestate = 3
				p.takistable.io.savestatetime = 2*TR
				return
			end
		end
		
		local lastcode = file:read("*a")
		local savestring = TakisConstructSaveCode(p)
		
		if backup
			if (lastcode ~= savestring) or forcebackup
				backup = io.openlocal("client/takisthefox/backupconfig.dat", "w+")
				backup:write(lastcode)
			end
		else
			backup = io.openlocal("client/takisthefox/backupconfig.dat", "w+")
			backup:write(savestring)
		end
		
		if not forcebackup
			file = io.openlocal("client/takisthefox/config.dat", "w+")
			file:write(savestring)
		end
		
		if not silent
			CONS_Printf(p, "\x82Saved "..skins[TAKIS_SKIN].realname.."' settings!")
		end
			
		file:close()
		if backup
			backup:close()
		end
		p.takistable.io.savestate = 2
		p.takistable.io.savestatetime = 2*TR
		return
	--WRITE ONE THEN DUMBASS!
	else
		local savestring = TakisConstructSaveCode(p)
		file = io.openlocal("client/takisthefox/config.dat", "w+")
		file:write(savestring)
		if not silent
			CONS_Printf(p, "\x82Saved "..skins[TAKIS_SKIN].realname.."' settings!")
		end
			
		file:close()
		p.takistable.io.savestate = 2
		p.takistable.io.savestatetime = 2*TR
		return
	end
	p.takistable.io.savestate = 3
	p.takistable.io.savestatetime = 2*TR
end)

rawset(_G, "TakisLoadStuff", function(p)
	
	if p.takistable.io.loaded
		return
	end
	
	--well why not
	TakisKart_LoadLicense(p)
	
	DEBUG_print(p,IO_CONFIG|IO_SAVE)
	
	local file = io.openlocal("client/takisthefox/config.dat")
	
	--load file
	if file 
		
		p.takistable.io.hasfile = true
		
		local code = file:read("*a")
		local defaultsave = TakisConstructSaveCode(p,true)
		if code == defaultsave
			file = io.openlocal("client/takisthefox/backupconfig.dat")
			code = file:read("*a")
		end
		
		if code ~= nil and not (string.find(code, ";"))
			if p.takistable.io.loadtries < 3
				p.takistable.io.savestate = 1
				COM_BufInsertText(p, "takis_load no "..TAKIS_ACHIEVEMENTINFO.luasig..code)
			else
				p.takistable.io.savestate = 3
				p.takistable.io.savestatetime = 2*TR
				p.takistable.io.loaded = true
			end
		end
		
		file:close()
		
	else
		
		local file = io.openlocal("client/takisthefox/backupconfig.dat")
		if file
			CONS_Printf(p,"\x82".."Found a backup config! Loading...")
			local code = file:read("*a")
			
			if code ~= nil and not (string.find(code, ";"))
				if p.takistable.io.loadtries < 3
					p.takistable.io.savestate = 1
					COM_BufInsertText(p, "takis_load no "..TAKIS_ACHIEVEMENTINFO.luasig..code)
					CONS_Printf(p,"\x82".."Remember to save your config!")
				else
					p.takistable.io.savestate = 3
					p.takistable.io.savestatetime = 2*TR
					p.takistable.io.loaded = true
				end
				file:close()
			end
			return
		end
		
		p.takistable.HUD.cfgnotifstuff = 6*TR+18
		--whatever...
		p.takistable.io.loaded = true
		
	end
end)

rawset(_G, "TakisKart_AwardLicense", function(p)
	
	/*
	if p.takistable.license.haslicense
	or (skins[p.skin].name ~= TAKIS_SKIN)
	or netgame
	or not TAKIS_USEOTHERIO
		return
	end
	*/
	
	local takis = p.takistable
	local license = takis.license
	
	license.haslicense = true
	license.licenseaward = 4*TR
end)

rawset(_G, "TakisKart_ChangeLicense", function(p,key,change)
	
	if not p.takistable.license.haslicense
	or skins[p.skin].name ~= TAKIS_SKIN
	or not TAKIS_USEOTHERIO
		return
	end
	
	local takis = p.takistable
	local license = takis.license
	
	license.haslicense = true
	license[key] = $+change
end)

rawset(_G, "TakisKart_SaveLicense", function(p)
	--dont overwrite our existing license if we havent loaded our config yet
	if not p.takistable.io.loaded
	or not TAKIS_USEOTHERIO
		return
	end
	
	if (TAKIS_DEBUGFLAG & DEBUG_CONFIG)
		print("\x83TAKIS:\x80 ("..p.name..") TakisKart_SaveLicense(): Saving license...")
	end
	
	local license = p.takistable.license
	
	if not license.haslicense
		if (TAKIS_DEBUGFLAG & DEBUG_CONFIG)
			print("\x83TAKIS:\x80 	^^ Shouldn't be saving, no license!")
		end
		return
	end
	
	if (p ~= consoleplayer) then return end
	
	local file = io.openlocal("client/sigmaLICENSE.dat", "w+")
	if file
		license.haslicense = true
		--file = io.openlocal("client/takisthefox/driverslicense.dat", "w+")
		file:write(
			" "..license.ranover..
			" "..license.miles..
			" "..license.crashes..
			" "..license.bumps..
			" "..license.mugshot
		)
		
		file:close()
	end
	
end)

rawset(_G, "TakisKart_LoadLicense", function(p)
	if not TAKIS_USEOTHERIO
		return
	end
	
	local file = io.openlocal("client/sigmaLICENSE.dat")
	
	--load file
	if file 
		
		p.takistable.license.haslicense = true
		
		local code = file:read("*a")
		
		if code ~= nil and not (string.find(code, ";"))
			COM_BufInsertText(p, "takis_load yes "..TAKIS_ACHIEVEMENTINFO.luasig.." "..code)
		end
		
		file:close()
		
	end
	

end)

TAKIS_FILESLOADED = $+1
