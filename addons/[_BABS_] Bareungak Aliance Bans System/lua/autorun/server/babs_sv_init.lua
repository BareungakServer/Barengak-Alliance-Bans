BABSConfigs = {}

local Config = BABSConfigs
Config.Version = 2.0 --연합밴  현재 버전
Config.Command = "!연합밴" --연합밴  메뉴 명령어
Config.LVersion = "" --서버로부터 불러온 최신버전
Config.URL = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/db_bans.html" --데이터베이스 링크 
Config.APIKey = "" --스팀 API 키를 큰따옴표 사이에 입력해주세요.
Config.Reason = "[BABS] 연합밴 사유: http://steamcommunity.com/groups/barnaliedbans"
Config.KickAllSub = true --"true"로 놓으시면 가족공유 계정이 모두 차단됩니다 (기본 false)
Config.Banlist = {}
Config.BanSlist = {}

if SERVER then
    util.AddNetworkString("BABSMenu")

    function BABScheck()
        http.Fetch(Config.URL, function(body)
            Config.Banlist = string.Explode("|", string.Replace(body,"",""))
            for _, item in pairs(Config.Banlist) do
              Config.BanSlist[string.Trim(item)] = true
            end

            Config.LVersion = tonumber(Config.Banlist[1])

            if (Config.LVersion > Config.Version) then
                MsgC(Color(255, 0, 0), "[BABS] 새로운 업데이트가 있습니다!\n")
                PrintMessage(HUD_PRINTTALK, "[BABS] 새로운 업데이트가 있습니다!\n")
            end

            MsgC(Color(255, 0, 0), "[BABS] 데이터베이스 업데이트 완료!\n")
            PrintMessage(HUD_PRINTTALK, "[BABS] 데이터베이스 업데이트 완료!\n")
        end, function(error)
            MsgC(Color(255, 0, 0), "[BABS] 데이터베이스를 업데이트 하는동안 오류가 발생하였습니다. " .. error .. "\n")
        end)
    end

    function BABSsubcheck(v)
        http.Fetch(string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&steamid=%s&appid_playing=4000", Config.APIKey, v:SteamID64()), function(body)
            local body = util.JSONToTable(body)

            if (not body or not body.response or not body.response.lender_steamid) then
                MsgC(Color(255, 0, 0), "[BABS] API 값을 받지 못했습니다, SteamAPI 키가 제대로 적혀있는지 확인해주세요.\n")

                return ""
            end

            local lender = body.response.lender_steamid

            if (Config.KickAllSub and lender ~= 0) then
                BABSkickuser(v, 1)
            end

                if (Config.BanSlist[util.SteamIDFrom64(lender)] == true) then
                    BABSkickuser(v, 1)
                end


        end, function(error)
            MsgC(Color(255, 0, 0), "[BABS] SteamAPI 응답이 올바르지 않습니다. Steam 서버가 닫혀 있을 수도 있습니다. " .. error .. "\n")
        end)
    end

    function BABSaliget(v)
        if (Config.BanSlist[v:SteamID()] == true) then
           BABSkickuser(v, 0)
        end
    end

    function BABSkickuser(v,id)
        local reason = Config.Reason
        if(id == 0) then
        local txt = "[BABS]" .. v:Nick() .. " 스팀 아이디 " .. v:SteamID() .. " 는(은) 바른각 연합밴 시스템에 의하여 공식 추방되었습니다! " .. "[" .. os.date("%Y:%m:%d / %H:%M:%S") .. "]\n"

    else
        reason = Config.Reason .. " (부계정 감지)"
         local txt = "[BABS]" .. v:Nick() .. " 스팀 아이디 " .. v:SteamID() .. " 는(은) 바른각 연합밴 시스템에 의하여 공식 추방되었습니다! (부계정 감지) " .. "[" .. os.date("%Y:%m:%d / %H:%M:%S") .. "]\n"
    end
        v:Kick(reason)
        MsgC(Color(255, 0, 0), txt)
        PrintMessage(HUD_PRINTTALK, txt)
        file.Append("babs/log.txt", txt)
    end


    hook.Add("Initialize", "InitializeBABS", function()
        BABScheck()
        timer.Create("UpdateBABS", 600, 0, BABScheck)
        MsgC(Color(255, 0, 0), "[BABS] 시스템이 로딩되었습니다! 현재 버전 : v" .. Config.Version .. "\n")
    end)

    hook.Add("PlayerAuthed", "BABSCheckUsers", function(v)
        BABSaliget(v)
        BABSsubcheck(v)
    end)


    hook.Add("PlayerSay", "BABSCallMenu", function(v, cmd)
        if (string.Trim(string.lower(cmd)) == Config.Command and v:IsSuperAdmin()) then
                net.Start("BABSMenu")
                net.Send(v)
        end
    end)

        concommand.Add("babs_update", function(v)
        if (v:IsSuperAdmin() and v:IsValid()) then
            BABScheck()
        end
    end)

    concommand.Add("babs_getlist", function(v)
        if v:IsValid() then
                v:PrintMessage(HUD_PRINTTALK, "버전, 스팀아이디" .. table.ToString(Config.Banlist))
        else
        MsgN("Version, SteamID" .. table.ToString(Config.Banlist))
    end


    end)

    concommand.Add("babs_getversion", function(v)
        if v:IsValid() then
        v:PrintMessage(HUD_PRINTTALK, "최신 버전 : " .. Config.LVersion .. "  현재 버전 : " .. Config.Version)
        else
        MsgN("Last version : " .. Config.LVersion .. "  Current version : " .. Config.Version)
    end
    end)
end