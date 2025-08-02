/*	HEADER
	File entirely dedicated to handling bosscards hud and whatnot
	
*/

--boss health stuff
--this is so sa hud!!
-- https://mb.srb2.org/threads/sonic-adventure-style-hud.27294/

local bossnames = TAKIS_BOSSCARDS.bossnames
local addonbosses = TAKIS_BOSSCARDS.addonbosses
local nobosscards = TAKIS_BOSSCARDS.nobosscards
local noaddonbosscards = TAKIS_BOSSCARDS.noaddonbosscards
local bossprefix = TAKIS_BOSSCARDS.bossprefix
local addonbossprefix = TAKIS_BOSSCARDS.addonbossprefix

local function setBossMeter(p, boss)
	local bosscards = p.takistable.HUD.bosscards
	
	if (bosscards != nil)
	and (bosscards.mo == boss)
		-- It's the same guy!
		return;
	end
	
	bosscards.mo = boss;
	
	if not TAKIS_NET.allowbosscards
		return
	end
	
	local takis = p.takistable
	local title = takis.HUD.bosstitle
	title.takis[1],title.takis[2] = unpack(title.basetakis)
	title.egg[1],title.egg[2] = unpack(title.baseegg)
	title.vs[1],title.vs[2] = unpack(title.basevs)
	title.mom = 1980
	title.tic = 3*TR
end

local function bossThink(mo)
	if (mo.health <= 0)
		-- Don't add a boss that's dead!
		return;
	end
	
	-- I suppose we can iterate everyone...
	for p in players.iterate do
		if not (p.mo and p.mo.valid)
			continue;
		end
		local bosscards = p.takistable.HUD.bosscards
		
		if (bosscards != nil
		and ((bosscards.mo and bosscards.mo.valid)
		and bosscards.mo == mo))
			-- It's already us! We can move on...
			continue;
		end
		
		if (P_CheckSight(mo, p.mo))
			local updateboss = false;

			if ((bosscards == nil)
			or not (bosscards.mo and bosscards.mo.valid and bosscards.mo.health > 0))
				-- Another boss doesn't exist, so we can add it!
				updateboss = true;
			else
				-- Another boss exists already, so only assume that they're not fighting the boss when
				updateboss = (not P_CheckSight(bosscards.mo, p.mo));
			end

			if (updateboss == true)
				setBossMeter(p, mo);
			end
		end
	end
end

local function bossHurt(mo, inf, src)
	if not (mo.flags & MF_BOSS)
		-- Only bosses!
		return;
	end

	if (src and src.valid) and (src.player and src.player.valid)
		setBossMeter(src.player, mo);
	end
	for p in players.iterate
		if p.takistable.HUD.bosscards.mo == mo
			p.takistable.HUD.bosscards.cardshake = TAKIS_HEARTCARDS_SHAKETIME
		end
	end
end

local function bossMeterThink(p)
	if (p.takistable == nil) then return end
	
	if (p.takistable.HUD.bosscards == nil)
		return;
	end
	
	local takis = p.takistable
	local bosscards = takis.HUD.bosscards
	
	--Tprtable("boss",bosscards)
	if (bosscards.cards > 0)
	and not (bosscards.mo and bosscards.mo.valid and bosscards.mo.health > 0)
		bosscards.cards = 0
	else
		if bosscards.mo and bosscards.mo.valid
			
			local maxhealth = bosscards.mo.info.spawnhealth;
			bosscards.maxcards = maxhealth
			
			local bosshp = bosscards.mo.health;
			bosscards.cards = bosshp
			
			if bosscards.cardshake then bosscards.cardshake = $-1 end
			
			if bosscards.cards
				if bosscards.cards <= (2)
					if not (leveltime%TR)
						bosscards.cardshake = $+TAKIS_HEARTCARDS_SHAKETIME/2
					end
				
				elseif bosscards.cards <= (bosscards.maxcards/2)
					if not (leveltime%(TR*2))
						bosscards.cardshake = $+TAKIS_HEARTCARDS_SHAKETIME/3
					end
				end
			end
			
			bosscards.name = nil
			if bossnames[bosscards.mo.type] ~= nil
			or bosscards.mo.info.name ~= nil
				bosscards.name = bossnames[bosscards.mo.type] or bosscards.mo.info.name
			end
			
			bosscards.nocards = false
			if nobosscards[bosscards.mo.type] ~= nil
				bosscards.nocards = nobosscards[bosscards.mo.type]
			end
			
			if bosscards.timealive == nil then bosscards.timealive = 0 end
			
			if (bosscards.mo.health > 0)
				bosscards.timealive = $+1
			else
				if bosscards.timealive > 2*TR
					bosscards.timealive = 2*TR
				end
				if bosscards.timealive > 0
					bosscards.timealive = $-1
				else
					bosscards.mo = nil
				end
			end
		else
			local title = takis.HUD.bosstitle
			title.takis[1],title.takis[2] = unpack(title.basetakis)
			title.egg[1],title.egg[2] = unpack(title.baseegg)
			title.vs[1],title.vs[2] = unpack(title.basevs)
			title.mom = 1980
			title.tic = 0
		end
	end

end

local function isMobjTypeValid(mt)
	if (pcall(do return _G[mt] end))
		return _G[mt];
	else
		return nil;
	end
end

local function mapSet()
	-- Check for new addon bosses
	for k,v in pairs(addonbosses) do
		local mt = isMobjTypeValid(k);

		if not (mt)
			continue;
		end

		bossnames[mt] = v;
	end
	for k,v in pairs(noaddonbosscards) do
		local mt = isMobjTypeValid(k);

		if not (mt)
			continue;
		end

		nobosscards[mt] = v;
	end
	for k,v in pairs(addonbossprefix) do
		local mt = isMobjTypeValid(k);

		if not (mt)
			continue;
		end

		bossprefix[mt] = v;
	end

end

addHook("MapChange", mapSet);
addHook("BossThinker", bossThink);
addHook("MobjDamage", bossHurt);
addHook("MobjDeath", bossHurt);
addHook("PlayerThink",bossMeterThink)

TAKIS_FILESLOADED = $+1