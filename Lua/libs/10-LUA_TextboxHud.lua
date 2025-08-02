/*	HEADER
	Draws textboxes
	
*/

--This needs to draw OVER takis hud, so execute this after
local TB = TakisTextBoxes -- shortcut

local function BreakUpText(v, s) -- lol
    local str = {s}
    local i = 1
    while v.stringWidth(str[i], V_ALLOWLOWERCASE, "normal") > 306 do
        if i > 5 then break end
        
        str[i+1] = str[i]
        local a
        while true do
            str[i] = string.sub($, 1, -2)
            if v.stringWidth(str[i], V_ALLOWLOWERCASE, "normal") <= 306 and (string.sub(str[i], -1, -1) == " " or string.find(str[i], "\n")) then
                if string.find(str[i], "\n") then str[i] = string.sub($, 1, string.find($, "\n")-1) else str[i] = string.sub(str[i], 1, -2) end
                a = string.len(str[i])
                break
            end
        end
        str[i+1] = string.sub($, a+2, -1)
        i = $+1
        
        if string.find(str[i], "\n") then
            str[i+1] = string.sub(str[i], string.find(str[i], "\n")+1, -1)
            str[i] = string.sub($, 1, string.find($, "\n")-1)
            
            if str[i]:len() == 0 then
                str[i] = str[i+1]
                str[i+1] = ""
            end
        end
        str[i+2] = str[i+1]
    end
        
    if string.find(str[i], "\n") then
        str[i+1] = string.sub(str[i], string.find(str[i], "\n")+1, -1)
        str[i] = string.sub($, 1, string.find($, "\n")-1)
        
        if str[i]:len() == 0 then
            str[i] = str[i+1]
            str[i+1] = ""
        end
    end
    
    if str[i+2] == str[i+1] then str[i+2] = "" end
    return str
end


local posTable = {
    up = {x = 160, y = 155, a = "center"},
    down = {x = 160, y = 183, a = "center"},
    left = {x = 7, y = 169, a = "left"},
    right = {x = 313, y = 169, a = "right"},
    ul = {x = 7, y = 155, a = "left"},
    ur = {x = 313, y = 155, a = "right"},
    dl = {x = 7, y = 183, a = "left"},
    dr = {x = 313, y = 183, a = "right"},
    center = {x = 160, y = 169, a = "center"}
}
local cursTable = {
    up = {x = 152, y = 163},
    down = {x = 152, y = 191},
    left = {x = 7, y = 177},
    right = {x = 296, y = 177},
    ul = {x = 7, y = 163},
    ur = {x = 296, y = 163},
    dl = {x = 7, y = 191},
    dr = {x = 296, y = 191},
    center = {x = 152, y = 177}
}

-- Box drawer
local function textboxStringDrawer(v, x, y, sss, f, box)
    local t = BreakUpText(v, sss)
    
    for i, str in ipairs(t) do
        local space = 0
        if not (box and box.settings) then return end
        for j = 1, #str do
            local k = 0
            for l = 1, i-1 do
                if t[l] then k = $+#t[l]+1 end
            end
            local rendstr = str:sub(j,j)
            if box.settings.escape[j+k] then rendstr = box.settings.escape[j+k]..$ end
            
            if box.settings.mode[j+k] == 0 then -- Normal
                v.drawString(x+space, y+8*(i-1), rendstr, f)
            elseif box.settings.mode[j+k] == 4 then -- Wavy
                v.drawString(x+space, y+8*(i-1)+(2*sin(FixedAngle(ease.linear(((j+leveltime)%10)*FRACUNIT/10, 0, 360)*FRACUNIT))/FRACUNIT), rendstr, f)
            else -- Shake
                local shkchnc = {FRACUNIT/20, FRACUNIT/5, FRACUNIT/2}
                local randx,randy = 0,0
                if v.RandomChance(shkchnc[box.settings.mode[j+k]]) then
                    randx,randy = v.RandomRange(-1,1),v.RandomRange(-1,1)
                end
                v.drawString(x+space+randx, y+8*(i-1)+randy, rendstr, f)
            end
            space = $+v.stringWidth(rendstr, f)
        end
    end
end

--maybe let textboxes draw to hud?
hud.add(function(v, player)
	if (player.textBoxClose)
		local box = player.textBoxClose
		local xt = box.xtween
		local xs = box.xscale
		
		v.drawStretched(0+xt,146*FU,
			FU-xs, FU,
			v.cachePatch("TA_SPCHBOX"), V_SNAPTOBOTTOM|box.flag
		)
		    
	end
	
    if not player.textBox or not player.textBox.tree then return end
    local tb = player.textBox
    local box = tb.tree[tb.current]
    local xt = -700*FU
	local xs = FU-FU/6
	if tb.settings
		xt = tb.settings.xtween
		xs = tb.settings.xscale
	end
	
	if not box then return end
	
	local colormap = box.color
	if box.color == "playercolor"
		if box.portrait[1] == skins[player.skin].name
			colormap = player.skincolor
		else
			if box.fallbackcolor == nil
				colormap = skins[box.portrait[1]].prefcolor
			else
				colormap = box.fallbackcolor
			end
		end
	end
    -- Portrait
    if box.portrait then
		local yoff = box.portyoffset or 0
        local spr, flip = v.getSprite2Patch(box.portrait[1], box.portrait[2], box.portrait[5] or false, box.portrait[3], box.portrait[4])
        local colr = v.getColormap(box.portrait[1], colormap)
		local hires = skins[box.portrait[1]].highresscale or FU
        v.drawScaled(32*FRACUNIT+xt,
			146*FRACUNIT + (spr.topoffset*hires/3)+yoff,
			hires,
			spr,
			(flip and V_FLIP or 0)|V_SNAPTOBOTTOM,
			colr
		)
    end
    
    -- Box
	local bflag = (player.textBox.move) and V_50TRANS or 0
    v.drawStretched(0+xt,146*FU,
		FU-xs, FU,
		v.cachePatch("TA_SPCHBOX"), V_SNAPTOBOTTOM|bflag
	)
	
    if box.name then 
		local name = box.name
		local map = box.namemap or V_YELLOWMAP
		if box.name == "takisname"
			map = 0
			if colormap == SKINCOLOR_GREEN
				name = "\x83Taykis"
			elseif colormap == SKINCOLOR_RED
			and not ((colormap == skincolor_redteam) and G_GametypeHasTeams())
				name = "\x85Yakis"
			elseif colormap == SKINCOLOR_SALMON
				name = "\x85Rakis"
			else
				name = "\x83Takis"
			end
		end
		
		v.drawString(48*FU+xt, 138*FU,
			name,
			map|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"fixed"
		)
	end
    
    if tb.render then
		--actually draw the text
        textboxStringDrawer(v, 7, 153, tb.render, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, tb)
    end
    
    if box.choices then
        local e = ""
        for i, j in ipairs(box.choices) do
            local h = (tb.choice == i) and V_YELLOWMAP or 0
            v.drawString(posTable[j.pos].x, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|h, posTable[j.pos].a)
            if tb.choice == i then e = j.pos end
        end
        if e and cursTable[e] then v.draw(cursTable[e].x, cursTable[e].y, v.cachePatch("M_CURSOR"), V_SNAPTOBOTTOM) end
    end
    
	/*
    if box.mini then
        for i, j in ipairs(box.mini) do
            local a = "thin-"..posTable[j.pos].a
            if a == "thin-left" then a = "thin" end
            
            local spr = v.getSprite2Patch(j.portrait[1], SPR2_TBXM, false, j.portrait[2], 1)
            local colormap = j.color
			if j.color == "playercolor"
			and j.name == skins[player.skin].name
				colormap = player.skincolor
			end
			
			local col = v.getColormap(j.portrait[1], colormap)
            
            if tb.settings.wait < 2+i and tb.settings.wait > i then
                if a == "thin" then
                    v.draw(posTable[j.pos].x+8, posTable[j.pos].y+10, spr, V_SNAPTOBOTTOM|V_50TRANS, col)
                    v.drawString(posTable[j.pos].x+16, posTable[j.pos].y+2, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_50TRANS, a)
                elseif a == "thin-right" then
                    v.draw(posTable[j.pos].x-8, posTable[j.pos].y+10, spr, V_SNAPTOBOTTOM|V_FLIP|V_50TRANS, col)
                    v.drawString(posTable[j.pos].x-16, posTable[j.pos].y+2, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_50TRANS, a)
                else
                    v.draw(posTable[j.pos].x-(v.stringWidth(j.text, V_ALLOWLOWERCASE, "thin")/2), posTable[j.pos].y+10, spr, V_SNAPTOBOTTOM|V_50TRANS, col)
                    v.drawString(posTable[j.pos].x+8, posTable[j.pos].y+2, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_50TRANS, a)
                end
            elseif tb.settings.wait >= 2+i then
                if a == "thin" then
                    v.draw(posTable[j.pos].x+8, posTable[j.pos].y+8, spr, V_SNAPTOBOTTOM, col)
                    v.drawString(posTable[j.pos].x+16, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, a)
                elseif a == "thin-right" then
                    v.draw(posTable[j.pos].x-8, posTable[j.pos].y+8, spr, V_SNAPTOBOTTOM|V_FLIP, col)
                    v.drawString(posTable[j.pos].x-16, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, a)
                else
                    v.draw(posTable[j.pos].x-(v.stringWidth(j.text, V_ALLOWLOWERCASE, "thin")/2), posTable[j.pos].y+8, spr, V_SNAPTOBOTTOM, col)
                    v.drawString(posTable[j.pos].x+8, posTable[j.pos].y, j.text, V_SNAPTOBOTTOM|V_ALLOWLOWERCASE, a)
                end
            end
        end
    end
	*/
end)

TAKIS_FILESLOADED = $+1