BABSConfigs = {}

local Config = BABSConfigs
Config.Version = 2.1 --연합밴  현재 버전
Config.Command = "!연합밴" --연합밴  메뉴 명령어
Config.APIKey = "" --스팀 API 키를 큰따옴표 사이에 입력해주세요.
Config.Reason = "[BABS] 연합밴 사유: http://steamcommunity.com/groups/barnaliedbans"
Config.KickAllSub = true --"true"로 놓으시면 가족공유 계정이 모두 차단됩니다 (기본 false)
--------------[이 아래는 만지지 마세요]--------------
Config.Banlist = {}
Config.BanSlist = {}
Config.LVersion = "" --서버로부터 불러온 최신버전
Config.URL = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/db_bans_meta.html" --데이터베이스 링크
--구버젼과 충돌 방지를 위해 URL에는 _meta 수식어 붙임

if SERVER then
    util.AddNetworkString("BABSMenu")

    function BABScheck()
        http.Fetch(Config.URL, function(body)
            Config.Banlist = string.Explode("|", string.Replace(body," ",""))
            --for _, item in pairs(Config.Banlist) do --이러면 의미가 없음
            --  Config.Banlist[item] = true
            --end

            Config.LVersion = tonumber(Config.Banlist["Ver"])

            if (Config.LVersion > Config.Version) then
                MsgC(Color(0, 212, 255), "[BABS]",Color(255,255,255)," 새로운 업데이트가 있습니다!\n")
                PrintMessage(HUD_PRINTTALK, "[BABS] 새로운 업데이트가 있습니다!\n")
            end

            MsgC(Color(0, 212, 255), "[BABS]",Color(255,255,255)," 데이터베이스 업데이트 완료!\n")
            PrintMessage(HUD_PRINTTALK, "[BABS] 데이터베이스 업데이트 완료!\n")
        end, function(error)
            MsgC(Color(0, 212, 255), "[BABS]",Color(255,255,255)," 데이터베이스를 업데이트 하는동안 오류가 발생하였습니다. " .. error .. "\n")
        end)
    end

    function BABSsubcheck(v)
        http.Fetch(string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&steamid=%s&appid_playing=4000", Config.APIKey, v:SteamID64()), function(body)
            local body = util.JSONToTable(body)

            if (not body or not body.response or not body.response.lender_steamid) then
                MsgC(Color(0, 212, 255), "[BABS]",Color(255,255,255)," API 값을 받지 못했습니다, SteamAPI 키가 제대로 적혀있는지 확인해주세요.\n")

                return
            end

            local lender = body.response.lender_steamid

            if (Config.KickAllSub and lender ~= 0) then
                v:Kick("[BABS] 이 서버에서는 가족공유 계정이 금지되어 있습니다.") -- 자체 함수로 킥하면 연합밴으로 혼동할 가능성 있음
                local txt = "[BABS] " .. v:Nick() .. "(고유번호 " .. v:SteamID() .. ") 는(은) 가족공유 계정으로 인해 추방되었습니다! " .. "[" .. os.date("%Y:%m:%d / %H:%M:%S") .. "]\n"
                MsgC(Color(255, 150, 0), txt)
                PrintMessage(HUD_PRINTTALK, txt)
                file.Append("babs/log.txt", txt)
            end

                if (Config.Banlist[util.SteamIDFrom64(lender)]) then
                    BABSkickuser(v, 1)
                end


        end, function(error)
            MsgC(Color(0, 212, 255), "[BABS]",Color(255,255,255)," SteamAPI 응답이 올바르지 않습니다. Steam 서버가 닫혀 있을 수도 있습니다. " .. error .. "\n")
        end)
    end

    function BABSaliget(v)
        if (Config.Banlist[v:SteamID()]) then
           BABSkickuser(v, 0)
        end
    end

    function BABSkickuser(v,id)
        local reason = Config.Reason
        if(id == 0) then
            local txt = "[BABS] " .. v:Nick() .. " (고유번호 " .. v:SteamID() .. ") 는(은) 바른각 연합밴 시스템에 의하여 공식 추방되었습니다! " .. "[" .. os.date("%Y:%m:%d / %H:%M:%S") .. "]\n"
        else
            reason = reason .. " (부계정 감지)"
            local txt = "[BABS] " .. v:Nick() .. " (고유번호 " .. v:SteamID() .. ") 는(은) 바른각 연합밴 시스템에 의하여 공식 추방되었습니다! (부계정 감지) " .. "[" .. os.date("%Y:%m:%d / %H:%M:%S") .. "]\n"
        end
        v:Kick(reason)
        MsgC(Color(255, 0, 0), txt)
        PrintMessage(HUD_PRINTTALK, txt)
        file.Append("babs/log.txt", txt)
    end


    hook.Add("Initialize", "InitializeBABS", function()
        BABScheck()
        timer.Create("UpdateBABS", 1800, 0, BABScheck)
        MsgC(Color(0, 210, 255), "[BABS]",Color(255,255,255)," 시스템이 로딩되었습니다! 현재 버전 : v" .. Config.Version .. "\n")
    end)

    hook.Add("PlayerAuthed", "BABSCheckUsers", function(v)
        BABSaliget(v)
        BABSsubcheck(v)
    end)


    hook.Add("PlayerSay", "BABSCallMenu", function(v, cmd)
        if (string.Trim(string.lower(cmd)) == Config.Command and v:IsSuperAdmin()) then
            net.Start("BABSMenu")
            net.Send(v)
            return ""
        end
    end)

    concommand.Add("babs_update", function(v)
        if (not v:IsValid() or v:IsSuperAdmin()) then --서버 콘솔인경우 IsValid == false
            BABScheck()
        end
    end)

    concommand.Add("babs_getlist", function(v)
        if v:IsValid() then
            v:PrintMessage(HUD_PRINTTALK, "[BABS] 콘솔을 보세요.") --밴리스트가 방대해지면 콘솔 출력이 더 나음
            v:PrintMessage(HUD_PRINTCONSOLE,table.ToString(Config.Banlist,"Ban List",true))
        else
        MsgN("Version, SteamID:")
        PrintTable(Config.Banlist)
    end


    end)

    concommand.Add("babs_getversion", function(v)
        if v:IsValid() then
            v:PrintMessage(HUD_PRINTTALK, "[BABS] 최신 버전 : " .. Config.LVersion .. "  현재 버전 : " .. Config.Version)
        else
            MsgN("[BABS] Last version : " .. Config.LVersion .. "  Current version : " .. Config.Version)
        end
    end)
end
