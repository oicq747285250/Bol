--[[

Teemo Alpha Male by oicq747285250
Last Update:v 1.0
2015/1/15

]]--

if myHero.charName ~= "Teemo" then return end
_G.AUTOUPDATE = true
_G.USESKINHACK = false


local version = "1.0"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/oicq747285250/Bol/master/Teemo Alpha Male.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Teemo Alpha Male:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/oicq747285250/Bol/master/Teemo Alpha Male.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end
local REQUIRED_LIBS = {
	
}
local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0
function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b><font color=\"#FF0000\">Required libraries downloaded successfully, please reload (double F9).</font>")
	end
end
for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
end



local ts
local qRange = 580 -- Range Q


function OnLoad()
		lastAttack = 0
		lastAttackCD = 0
		lastWindUpTime = 0
		PrintChat("<font color=\"#00ff00\">Teemo Alpha Male by oicq747285250</font>")
	
		
		Config = scriptConfig("Teemo Alpha Male "..version, "Teemo Alpha Male "..version)
		Config:addSubMenu("[Teemo Alpha Male]: Combo Settings", "combocfg")
		Config.combocfg:addParam("combokey", "Combokey(32-SPACE)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(32))
		Config.combocfg:addParam("autoQkey", "AutoQkey in range(67-C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(67))
		Config.combocfg:permaShow("combokey")
		Config.combocfg:permaShow("autoQkey")
		
		Config:addParam("drange", "Draw circle", SCRIPT_PARAM_ONOFF, true)
		
		ts = TargetSelector(TARGET_NEAR_MOUSE, qRange, DAMAGE_MAGIC, true)
		ts.name="Teemo"
		Config:addTS(ts)

		
		
end

function OnTick()
	ts:update()
	test()
	
	
end


function OnDraw()
	if(Config.drange) then
		if ts.target~=nil and (GetDistance(ts.target) <= qRange) then
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0xFF0000)
		else
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x33CC33)
		end
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
if (Config.combocfg.autoQkey) then
	if (ts.target ~= nil) then OrbWalking(ts.target) else MoveToMouse() end
	if (ts.target ~= nil) then
		if (myHero:CanUseSpell(_Q) == READY) then
			if (GetDistance(ts.target) <= qRange) then
				CastSpell(_Q)
			end
		
		end
	end
end
if (Config.combocfg.combokey) then
	if (ts.target ~= nil) then OrbWalking(ts.target) else MoveToMouse() end
end
end

function TimeToAttack()
    return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end
function OrbWalking(Target)
	if TimeToAttack() and GetDistance(Target) <= myHero.range + GetDistance(myHero.minBBox) then
		myHero:Attack(Target)
    elseif heroCanMove() then
        moveToCursor()
    end
end
function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end

function moveToCursor()
	if GetDistance(mousePos) then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
		myHero:MoveTo(moveToPos.x, moveToPos.z)
    end        
end
function MoveToMouse()
	local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
	local Position = myHero + (Vector(MousePos) - myHero):normalized()*300
	myHero:MoveTo(Position.x, Position.z)
end

function OnProcessSpell(object,spell)
	if object == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
        end
    end
end
