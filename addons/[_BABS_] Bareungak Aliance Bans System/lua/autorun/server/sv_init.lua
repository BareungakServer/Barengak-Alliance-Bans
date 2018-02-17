BABS = {}
BABS.Configs = {}

local Config = AliBansConfig
Config.Version = 0.9 --연합밴  현재 버전
Config.Command = "!연합밴" --연합밴  메뉴 명령어
Config.LVersion = "" --서버로부터 불러온 최신버전
Config.URL = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/db_bans.html" --데이터베이스 링크 https://raw.githubusercontent.com/lill74/Garrys-mod-Ali-Bans/master/ban.html
Config.APIKey = "" --스팀 API 키를 큰따옴표 사이에 입력해주세요.
Config.Reason = "[BABS]연합밴 사유: http://steamcommunity.com/groups/barnaliedbans"
Config.KickAllSub = false --"true"로 놓으시면 가족공유 계정이 모두 차단됩니다 (기본 false)
Config.Banlist = {}

if SERVER then
    util.AddNetworkString("AliBanMenu")

    function BABS.check()
        http.Fetch(Config.URL, function(body)
            Config.Banlist = string.Explode("|", body)
            Config.LVersion = tonumber(Config.Banlist[1])

            if (Config.LVersion > Config.Version) then
                MsgC(Color(255, 0, 0), "[BABS]새로운 업데이트가 있습니다!\n")
                PrintMessage(HUD_PRINTTALK, "[BABS]새로운 업데이트가 있습니다!\n")
            end

            PrintMessage(HUD_PRINTTALK, "[BABS]데이터베이스 업데이트 완료!\n")
        end, function(error)
            MsgC(Color(255, 0, 0), "[BABS]데이터베이스를 업데이트 하는동안 오류가 발생하였습니다.\n")
        end)
    end

    function BABS.subcheck(v)
        http.Fetch(string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&steamid=%s&appid_playing=4000", Config.APIKey, v:SteamID64()), function(body)
            local body = util.JSONToTable(body)

            if (not body or not body.response or not body.response.lender_steamid) then
                MsgC(Color(255, 0, 0), "[BABS]API 값을 받지 못했습니다, SteamAPI 키가 제대로 적혀있는지 확인해주세요.\n")

                return ""
            end

            local lender = body.response.lender_steamid

            if (Config.KickAllSub and lender) then
                BABS.kickuser(v)
            end

            for _, ban in pairs(Config.Banlist) do
                if lender == string.Trim(util.SteamIDTo64(ban)) then
                    BABS.kickuser(v)
                end
            end
        end, function(error)
            MsgC(Color(255, 0, 0), "[BABS]SteamAPI 응답이 올바르지 않습니다. Steam 서버가 닫혀 있을 수도 있습니다.\n")
        end)
    end

    function BABS.aliget(v)
        for _, ban in pairs(Config.Banlist) do
            if string.Trim(ban) == v:SteamID() then
                BABS.kickuser(v)
            end
        end
    end

    function BABS.kickuser(v)
        local txt = "[BABS]" .. v:Nick() .. " 스팀 아이디 " .. v:SteamID() .. " 님이 연합벤 시스템에 의해 차단당했습니다! " .. "[" .. os.date("%Y:%m:%d / %H:%M:%S") .. "]\n"
        v:Kick(Config.Reason)
        MsgC(Color(255, 0, 0), txt)
        PrintMessage(HUD_PRINTTALK, txt)
        file.Append("babs/log.txt", txt)
    end


    hook.Add("Initialize", "InitializeBABS", function()
        BABS.check()
        timer.Create("UpdateBABS", 600, 0, BABS.check)
        MsgC(Color(255, 0, 0), "[BABS]시스템이 로딩되었습니다!\n")
    end)

    hook.Add("PlayerAuthed", "CheckUsers", function(v)
        BABS.aliget(v)
        BABS.subcheck(v)
    end)

    concommand.Add("aliban_update", function(v)
        if (v:IsSuperAdmin()) then
            BABS.check()
        end
    end)

    hook.Add("PlayerSay", "AliBanMenu", function(v, cmd)
        if (string.Trim(string.lower(cmd)) == Config.Command and v:IsSuperAdmin()) then
                net.Start("AliBanMenu")
                net.Send(v)
        end
    end)

    concommand.Add("babs_getlist", function(v)
        v:PrintMessage(HUD_PRINTTALK, "버전, 스팀아이디" .. table.ToString(Config.Banlist))
    end)

    concommand.Add("babs_getversion", function(v)
        v:PrintMessage(HUD_PRINTTALK, "최신 버전 : " .. Config.LVersion .. "  현재 버전 : " .. Config.Version)
    end)
end