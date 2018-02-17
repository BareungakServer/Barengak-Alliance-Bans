--[[
바른각 연합밴 시스템 클라이언트 (BABS) v1.1
ⓒ 2016 ~ 2018 Breaking Studio, Bareungak Alliance Bans 모든 권리 보유.
]]
BABS = {}
BABS.Configs = {}
local Config = BABS.Configs
Config.Version = "1.1" --연합벤 현재 버전
Config.Commander = "!연합밴" --연합벤 메뉴 명령어
Config.LVersion = ""

if not SERVER then return end --SERVERSIDE

--if SERVER then
util.AddNetworkString( "BABS_AliBanMenu" )
print("[BABS] 바른각 연합밴 클라이언트 로드....")
print("[BABS] 바른각 연합밴 클라이언트 버전 : v" .. Config.Version)
BABS.banlist = {}
BABS.htmlcontent = ""
local url = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/db_bans.html"

--[[-------------------------------------------------------------------------
Title       : BABS.check()
Description : Check alied ban list and version with http.Fetch()
			: And executes BABS.usercheck()
---------------------------------------------------------------------------]]
function BABS.check()
http.Fetch(url,
	function(html)
		BABS.banlist = string.Explode("|",html)
		BABS.htmlcontent = html
		Config.LVersion = BABS.banlist[1]
		if (Config.LVersion > Config.Version) then
			print("[BABS] 바른각 연합밴 시스템 클라이언트 업데이트가 필요합니다!")
			for k, v in pairs(player.GetAll()) do
				if v:IsAdmin() then
					v:PrintMessage( HUD_PRINTTALK, "[BABS] 바른각 연합밴 시스템 클라이언트 업데이트가 필요합니다!" )
				end
			end
		end

		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() then
				v:PrintMessage( HUD_PRINTTALK, "[BABS] 연합밴 데이터베이스 불러오기 성공!" )
			end
		end
		print("[BABS] 연합밴 데이터베이스 목록을 불러왔습니다.")
	end,
	function( err )
		print("[BABS] 연합밴 데이터베이스 목록을 불러오지 못했습니다.")
		print("[BABS] 에러 : " .. err)
		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() then
				v:PrintMessage( HUD_PRINTTALK, "[BABS] 연합밴 데이터베이스 불러오기 실패." )
				v:PrintMessage( HUD_PRINTTALK, "[BABS] 에러 : " .. err )
			end
		end
	end)
if BABS.usercheck then BABS.usercheck() end
end

--[[-------------------------------------------------------------------------
Title       : BABS.usercheck()
Description : Check about bans within all users in a server, kicks when banned
---------------------------------------------------------------------------]]
function BABS.usercheck()
	for k, v in pairs(player.GetAll()) do
		if table.HasValue(BABS.banlist,v:SteamID()) then
		    BABS.kickuser(v)
		end
	end
end

--[[-------------------------------------------------------------------------
Title       : BABS.aliget(target)
Description : Check about target is banned or not, kicks when banned
---------------------------------------------------------------------------]]
function BABS.aliget(v)
	--BABS.check()  --1시간마다 자동 업데이트되므로 필요 없음
	--BABS.usercheck() --마찬가지로 1시간마다 자동 실행되므로 필요없음
	if table.HasValue(BABS.banlist,v:SteamID()) then
		BABS.kickuser(v)
	end
end

--[[-------------------------------------------------------------------------
Title       : BABS.kickuser(target)
Description : Kicks target and alert to everyone.
---------------------------------------------------------------------------]]
function BABS.kickuser(user)
	print("Kicking " .. user:Nick() .. " by BABS Client System")
	user:Kick("[BABS] 당신은 바른각 연합밴 시스템에 의하여 추방됬습니다.\n연합밴 사유: http://steamcommunity.com/groups/barnaliedbans")
	for k, v in pairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTTALK, user:Nick() .. " 님은 바른각 연합밴 시스템에 의해 추방당했습니다.")
	end
end

--[[-------------------------------------------------------------------------
Title       : BABS.init()
Description : Initialize BABS.
Initializing: Timer
---------------------------------------------------------------------------]]
function BABS.init()
	BABS.check()
	timer.Create("BABS_UpdateAlibanList", 3600 , 0, BABS.check)
	print("[BABS] 바른각 연합밴 시스템을 구성중 입니다...")
end
hook.Add( "Initialize", "BABS_InitializeAliBans", BABS.init )
hook.Add( "PlayerInitialSpawn", "BABS_CheckUsers", BABS.aliget )

--[[-------------------------------------------------------------------------
Title       : babs_update
Description : Updates banlist.
---------------------------------------------------------------------------]]
concommand.Add( "babs_update", function( ply, cmd, args )
	if ply:IsSuperAdmin() or not ply:IsValid() then --슈퍼어드민 또는 콘솔
		BABS.check()
	else
	return false
	end
end )

--[[-------------------------------------------------------------------------
Title       : BABS_ShowAliBanMenu(Hook)
Description : Opens BABS Menu with command.
---------------------------------------------------------------------------]]
hook.Add( "PlayerSay", "BABS_ShowAliBanMenu", function( ply, text, public )
	if ( text == Config.Commander and ply:IsSuperAdmin()) then
		net.Start( "BABS_AliBanMenu" )
		net.Send(ply)
	end
end)

--[[-------------------------------------------------------------------------
Title       : babs_getlist
Description : Prints banlist.
---------------------------------------------------------------------------]]
concommand.Add( "babs_getlist", function( ply, cmd, args )
	if ply:IsValid() then
		ply:PrintMessage( HUD_PRINTCONSOLE, "버전, 스팀 아이디 : " .. table.ToString(BABS.banlist))
		ply:PrintMessage( HUD_PRINTTALK, "콘솔을 확인해 주세요.")
	else --콘솔이라면
		MsgN("Version and SteamID :" .. table.ToString(BABS.banlist))
	end
end )

--[[-------------------------------------------------------------------------
Title       : babs_getversion
Description : Prints last version and current version.
---------------------------------------------------------------------------]]
concommand.Add( "babs_getversion", function( ply, cmd, args )
	if ply:IsValid() then
		ply:PrintMessage( HUD_PRINTTALK, "최신 버전 : " .. Config.LVersion .. "  현재 버전 : " .. Config.Version )
	else --콘솔이라면
		MsgN("Last version : " .. Config.LVersion .. "  Current version : " .. Config.Version)
	end
end )


	--end