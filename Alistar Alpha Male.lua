--[[

Alistar Alpha Male by oicq747285250
v1 2015/1/13

]]--

if myHero.charName ~= "Alistar" then return end
_G.AUTOUPDATE = true
_G.USESKINHACK = false


local version = "1.1"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/oicq747285250/Bol/master/Alistar%20Alpha%20Male.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Alistar%20Alpha%20Male:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/oicq747285250/Bol/master/Alistar%20Alpha%20Male.version")
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
	["SxOrbWalk"] = "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
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
local qRange = 365 -- Range Q
local wRange = 650 -- Range W

function OnLoad()
	PrintChat("<font color=\"#00ff00\">Alistar Alpha Male by oicq747285250</font>")
	
	
		Config = scriptConfig("Alistar Alpha Male "..version, "Alistar Alpha Male "..version)
		Config:addParam("autoQW", "AutoWQ while combo pressing", SCRIPT_PARAM_ONOFF, true)
		Config:addParam("combokey", "Combokey(32)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(32))
		Config:addParam("autoWkey", "AutoWkey in range near mouse(67)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(67))
		Config:addParam("autoQkey", "AutoQkey in range near mouse(88)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(88))
		Config:permaShow("combokey")
		Config:permaShow("autoWkey")
		Config:permaShow("autoQkey")
		Config:addParam("uaa", "Use AA in Combo", SCRIPT_PARAM_ONOFF, true)
		
		Config:addParam("drange", "Draw circle", SCRIPT_PARAM_ONOFF, true)
		
		ts = TargetSelector(TARGET_NEAR_MOUSE, wRange, DAMAGE_MAGIC, true)
		Config:addTS(ts)

		Config:addSubMenu("Orbwalking", "Orbwalking")
		SxOrb:LoadToMenu(Config.Orbwalking)
		
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
	if sac or mma then
		SxOrb.SxOrbMenu.General.Enabled = false
	end
	SxOrb:ForceTarget(ts.target)
local x1, y1, OnScreen1 = get2DFrom3DAM(myHero.x, myHero.y, myHero.z)
local x2, y2, OnScreen2 = get2DFrom3DAM(ts.target.x, ts.target.y, ts.target.z)
DrawLine(x1, y1, x2, y2, 3, 0xFF00FF00)
DrawCircle(ts.target.x, ts.target.y, ts.target.z, 100, 0x00FF00)
end
if (Config.autoWkey) then
	if (ts.target ~= nil) then
		if (myHero:CanUseSpell(_W) == READY) then
			CastSpell(_W, ts.target)
		
		end
	end
end
if (Config.autoQkey) then
	if (ts.target ~= nil) then
		if (myHero:CanUseSpell(_Q) == READY) then
			if (GetDistance(ts.target) <= qRange) then
				CastSpell(_Q)
			end
		
		end
	end
end
if (Config.combokey) then
	caa()
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

function caa()
	if Config.uaa then
		SxOrb:EnableAttacks()
	elseif not Config.uaa then
		SxOrb:DisableAttacks()
	end
end
