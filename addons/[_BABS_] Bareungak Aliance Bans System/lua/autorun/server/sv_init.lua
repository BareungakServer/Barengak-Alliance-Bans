--[[
바른각 연합밴 시스템 클라이언트 (BABS) v1.1
ⓒ 2016 ~ 2018 Breaking Studio, Bareungak Alliance Bans 모든 권리 보유.
]]

	AliBansConfig = {}
	local Config = AliBansConfig
	Config.Version = "1.1" --연합벤 현재 버전
	Config.Commander = "!연합밴" --연합벤 메뉴 명령어
    Config.LVersion = ""

	if SERVER then
	util.AddNetworkString( "AliBanMenu" )
		print("[BABS] 바른각 연합밴 클라이언트 로드....")
		print("[BABS] 바른각 연합밴 클라이언트 버전 : v1.1")
		banlist = {}
		content = ""
		local url = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/db_bans.html"
		
		function check()
		http.Fetch(url, function(html)
				banlist = string.Explode("|",html)
				content = html
				Config.LVersion = banlist[1]
				if(banlist[1] > Config.Version) then
				print("[BABS] 바른각 연합밴 시스템 클라이언트 업데이트가 필요합니다!")

				for k, v in pairs(player.GetAll()) do
					v:PrintMessage( HUD_PRINTTALK, "[BABS] 바른각 연합밴 시스템 클라이언트 업데이트가 필요합니다!" )
				end

				end
				
				for k, v in pairs(player.GetAll()) do
					v:PrintMessage( HUD_PRINTTALK, "[BABS] 연합밴 데이터베이스 불러오기 성공!" )
				end
			    print("[BABS] 연합밴 데이터베이스 목록을 불러왔습니다.")
		end,
		function( error )
			print("[BABS] 연합밴 데이터베이스 목록을 불러오지 못했습니다.")
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
		check()
		usercheck()
					for _,ban in pairs(banlist) do
						if ban == v:SteamID() then
						     kickuser(v)
						end
					end
		end
		
	             function kickuser(v)
	             	 print("Kick " .. v:Nick() .. " by BABS Client System")
	             	user:Kick("[BABS] 당신은 바른각 연합밴 시스템에 의하여 추방됬습니다.\n연합밴 사유: http://steamcommunity.com/groups/barnaliedbans")
	             	for k, v in pairs(player.GetAll()) do
					v:PrintMessage( HUD_PRINTTALK, user:Nick() .. " 님은 바른각 연합밴 시스템에서 공식 추방당했습니다.")
			end
	             end

		function init()
		check()
		timer.Create("UpdateAlibanList", 3600 , 0, check)
		print("[BABS] 바른각 연합밴 시스탬을 구성중 입니다...")
		end
		
		hook.Add( "Initialize", "InitializeAliBans", init )
		hook.Add( "PlayerInitialSpawn", "CheckUsers", aliget )
		
		concommand.Add( "aliban_update", function( ply, cmd, args )
		if(ply:IsSuperAdmin()) then
		check()
		else
		return false
		end
	end )


		hook.Add( "PlayerSay", "AliBanMenu", function( ply, text, public )
		if ( text == Config.Commander ) then
		 if(ply:IsSuperAdmin()) then
		  net.Start( "AliBanMenu" )
	      net.Send(ply)
		 else
		   return false
		 end
		end
		end)

		concommand.Add( "getlist", function( ply, cmd, args )
		  ply:PrintMessage( HUD_PRINTTALK, "버전, 스팀 아이디" .. table.ToString(banlist))
	    end )

	    concommand.Add( "getversion", function( ply, cmd, args )
		  ply:PrintMessage( HUD_PRINTTALK, "최신 버전 : " .. Config.LVersion .. "  현재 버전 : " .. Config.Version )
	    end )


	end