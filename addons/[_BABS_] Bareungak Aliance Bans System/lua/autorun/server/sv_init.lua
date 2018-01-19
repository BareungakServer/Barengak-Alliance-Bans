--[[
바른각 연합밴 시스탬 (BABS) v1.0
ⓒ 2016 ~ 2018 Breaking Studio, Bareungak Alliance Bans 모든 권리 보유.
]]

AliBansConfig = {}
local Config = AliBansConfig
Config.Version = "1.0"
Config.Commander = "!연합밴"

if SERVER then
util.AddNetworkString( "AliBanMenu" )
    print("[BABS] 바른각 연합밴 시스탬 로드....")
	banlist = {}
	content = ""
	local url = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/db_bans.txt"
	
	function check()
	http.Fetch(url, function(html)
			banlist = string.Explode("|",html)
			content = html
			if(banlist[1] > Config.Version) then
			print("[BABS] 바른각 연합밴 시스탬 업데이트가 필요합니다!")

			for k, v in pairs(player.GetAll()) do
				v:PrintMessage( HUD_PRINTTALK, "[BABS] 새로운 업데이트가 있습니다!" )
			end

			end
			
			for k, v in pairs(player.GetAll()) do
				v:PrintMessage( HUD_PRINTTALK, "[BABS] 연합밴 데이터베이스 불러오기 성공!" )
			end
		    print("[BABS] 연합밴 데이터베이스 목록을 불러왔습니다.")
	end)
	end
	
	function usercheck()
			for k, v in pairs(player.GetAll()) do
				for _,ban in pairs(banlist) do
					if ban == v:SteamID() then
					    kickuser(v)
					end
				end
			end
	end
	
	function aliget(v)
	usercheck()
				for _,ban in pairs(banlist) do
					if ban == v:SteamID() then
					     kickuser(v)
					end
				end
	end
	
             function kickuser(v)
             	 print("Kick " .. v:Nick() .. " by BABS")
             	v:Kick("[BABS] 당신은 바른각 연합밴 시스탬에 의하여 추방됬습니다.\n연합밴 사유: http://barncs.xyz/Barn_Server/BarnASV/")
             	for k, v in pairs(player.GetAll()) do
				v:PrintMessage( HUD_PRINTTALK, v:Nick() .. " 님이 바른각 연합밴 시스탬에 의해 차단당했습니다!")
		end
             end

	function init()
	check()
	timer.Create("UpdateAlibanList", 120 , 0, check)
	print("[BABS] 바른각 연합밴 시스탬을 구성중 입니다...")
	end
	
	hook.Add( "PlayerInitialSpawn", "CheckUsers", aliget )
	hook.Add( "Initialize", "InitializeAliBans", init )
	
	concommand.Add( "aliban_update", function( ply, cmd, args )
	check()
end )


	hook.Add( "PlayerSay", "AliBanMenu", function( ply, text, public )
	if ( text == Config.Commander ) then
	if(ply:IsSuperAdmin()) then
	net.Start( "AliBanMenu" )
	net.WriteString(content)
    net.Send(ply)
	else
	return false
	end
	end
	end)
end