--[[

Alistar Alpha Male by oicq747285250
v1 2015/1/13

]]--

if myHero.charName ~= "Alistar" then return end
local ts
local qRange = 365 -- Range Q
local wRange = 650 -- Range W

function OnLoad()
	PrintChat("<font color=\"#00ff00\">Alistar Alpha Male by oicq747285250</font>")
	ts = TargetSelector(TARGET_NEAR_MOUSE, wRange, DAMAGE_MAGIC, true)
	
		Config = scriptConfig("Alistar Alpha Male", "amam")
		
		Config:addParam("drange", "Draw circle", SCRIPT_PARAM_ONOFF, true)
		Config:addParam("autoQW", "AutoWQ while moving(combo)", SCRIPT_PARAM_ONOFF, true)
		Config:addParam("otherwalk", "turn off when use SAC or Orbwalk ", SCRIPT_PARAM_ONOFF, true)
		Config:addParam("mousemoving", "mousemoving", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(32))
		Config:addParam("autoW", "AutoW in range near mouse", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(67))
		Config:addParam("autoQ", "AutoQ in range near mouse", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(88))
		Config:addTS(ts)
		Config:permaShow("mousemoving")
		Config:permaShow("autoW")
		Config:permaShow("autoQ")


		
end

function OnTick()
	ts:update()
	test()
	
	
end


function OnDraw()
	if(Config.drange) then
		DrawCircle(myHero.x, myHero.y, myHero.z, wRange, 0x33CC33)
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x33CC33)
	end
	test()
	
end

function get2DFrom3DAM(x, y, z)
    local pos = WorldToScreen(D3DXVECTOR3(x, y, z))
    return pos.x, pos.y, OnScreen(pos.x, pos.y)
end

function test()
if (ts.target ~= nil) then
local x1, y1, OnScreen1 = get2DFrom3DAM(myHero.x, myHero.y, myHero.z)
local x2, y2, OnScreen2 = get2DFrom3DAM(ts.target.x, ts.target.y, ts.target.z)
DrawLine(x1, y1, x2, y2, 3, 0xFF00FF00)
DrawCircle(ts.target.x, ts.target.y, ts.target.z, 100, 0x00FF00)
end
if (Config.autoW) then
	if (Config.otherwalk) then
	mmove()
	end
	if (ts.target ~= nil) then
		if (myHero:CanUseSpell(_W) == READY) then
			CastSpell(_W, ts.target)
		
		end
	end
end
if (Config.autoQ) then
	if (Config.otherwalk) then
	mmove()
	end
	if (ts.target ~= nil) then
		if (myHero:CanUseSpell(_Q) == READY) then
			if (GetDistance(ts.target) <= qRange) then
				CastSpell(_Q)
			end
		
		end
	end
end
if (Config.mousemoving) then
	if (Config.otherwalk) then
	mmove()
	end
	if(Config.autoQW) then
		if (ts.target ~= nil) then
			if (myHero:CanUseSpell(_W and _Q) == READY) then
				
					CastSpell(_W, ts.target)
					if (GetDistance(ts.target) <= qRange) then
					CastSpell(_Q)
					end
				
		
			end
		end
	end
end
end



function mmove()
	if GetDistance(mousePos) > 10 then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*250
		myHero:MoveTo(moveToPos.x, moveToPos.z)
	end 
end


