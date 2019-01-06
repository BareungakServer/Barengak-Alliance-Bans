--[[ BABS -----------------------------------------------------------------------------------------

@System Creator : lill74, _jellen
@System Inspection : Bareungak

The source code can be modified for non-profit purposes, original authors, and second revision, 
if the distribution ban is complied with.

--------------------------------------------------------------------------------------------------]]
BABSConfigs = {}
local Config = BABSConfigs
Config.Version = 3.4 -- 연합밴 현재 버전
Config.APIKey = "" -- SteamAPI 키 을(를) 큰 따옴표 사이에 입력해주세요.
Config.Command = "!연합밴" -- 인터페이스를 실행하는 명령어를 설정해주세요.
Config.Reason = "[BABS] 바른각 연합밴 사유 : "
Config.KickAllSub = false -- "true" 으(로) 설정하시면 가족공유 계정이 모두 차단됩니다. [ 기본값 : false ]
--------------[ 선 아래 코드를 수정하지 마시오. ]--------------
Config.Banlist = {}
Config.LVersion = "" -- 서버로 부터 받아온 최신버전
Config.URL = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/db_banlist.json" -- BABS 데이터베이스 링크
Config.UpdateTime = 1200

if SERVER then

    resource.AddFile( "materials/frame_logo.png" )
    resource.AddFile( "materials/whitelist.png" )
    resource.AddFile( "materials/update_db.png" )
    resource.AddFile( "materials/group.png" )
    resource.AddFile( "materials/update_addon.png" )
    resource.AddFile( "materials/close.png" )

    util.AddNetworkString("BABSMenu")

    function BABScheck()
        sql.Query("DELETE FROM babslist;")
        http.Fetch(Config.URL, function(body)
            Config.Banlist = util.JSONToTable(body)
            Config.LVersion = tonumber(Config.Banlist["Ver"])

            if (Config.LVersion > Config.Version) then
                MsgC(Color(0, 212, 255), "[BABS]", Color(255, 255, 255), " 새로운 업데이트가 있습니다!\n")
                PrintMessage(HUD_PRINTTALK, "[BABS] 새로운 업데이트가 있습니다!\n")
            end

            MsgC(Color(0, 212, 255), "[BABS]", Color(255, 255, 255), " 데이터베이스 업데이트 완료!\n")
            PrintMessage(HUD_PRINTTALK, "[BABS] 데이터베이스 업데이트 완료!\n")
        end, function(error)
            MsgC(Color(0, 212, 255), "[BABS]", Color(255, 255, 255), " 데이터베이스를 업데이트 하는동안 오류가 발생하였습니다. " .. error .. "\n")
        end)

        if (sql.TableExists("babslist")) then
            for k, v in pairs(Config.Banlist) do
                if tonumber(k) ~= nil and not sql.Query("SELECT SteamID FROM babslist WHERE SteamID = '" .. Config.Banlist[k][1]["SteamID"] .. "'") then
                    sql.Query("INSERT INTO babslist( SteamID,Reason ) VALUES( '" .. Config.Banlist[k][1]["SteamID"] .. "', '" .. Config.Banlist[k][1]["Reason"] .. "' )")
                end
            end
        end
    end

    function BABSsubcheck(v)
        http.Fetch(string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&steamid=%s&appid_playing=4000", Config.APIKey, v:SteamID64()), function(body)
            local body = util.JSONToTable(body)

            if (not body or not body.response or not body.response.lender_steamid) then
                MsgC(Color(0, 212, 255), "[BABS]", Color(255, 255, 255), " SteamAPI 값을 받지 못했습니다! SteamAPI 키가 제대로 적혀있는지 확인해주세요.\n")

                return
            end

            local lender = body.response.lender_steamid

            if (Config.KickAllSub and lender ~= "0") then
                BABSkickuser(v, "본 서버에서는 가족공유 계정이 금지되어 있습니다.")
            end

            if (Config.Banlist[util.SteamIDFrom64(lender)]) then
                BABSkickuser(v, "(부계정 감지)")
            end
        end, function(error)
            MsgC(Color(0, 212, 255), "[BABS]", Color(255, 255, 255), " SteamAPI 응답이 올바르지 않습니다! Steam 서버에 문제가 있을 수 있습니다. " .. error .. "\n")
        end)
    end

    function BABSaliget(v)
        if (sql.TableExists("babslist")) then
            query = sql.Query("SELECT Reason FROM babslist WHERE SteamID = '" .. v:SteamID64() .. "'")

            if query then
                BABSkickuser(v, query[1]["Reason"])
            end
        end
    end

    function BABSkickuser(v, creason)
        local reason = Config.Reason .. creason
        v:Kick(reason)
        MsgC(Color(255, 0, 0), reason)
        PrintMessage(HUD_PRINTTALK, reason)
        file.Append("babs/log.txt", reason)
    end

    hook.Add("Initialize", "InitializeBABS", function()
        if (not sql.TableExists("babslist")) then
            sql.Query("CREATE TABLE babslist( SteamID TEXT, Reason TEXT )")
        end

        timer.Create("UpdateBABS", Config.UpdateTime, 0, BABScheck)
        MsgC(Color(0, 210, 255), "[BABS]", Color(255, 255, 255), " 시스템이 로딩되었습니다! 연합밴 클라이언트 버전 : v" .. Config.Version .. "\n")
        BABScheck()
    end)

    hook.Add("PlayerAuthed", "BABSCheckUsers", function(v)
        BABSaliget(v)
        BABSsubcheck(v)
    end)

    hook.Add("PlayerSay", "BABSCallMenu", function(v, cmd)
        if (string.Trim(string.lower(cmd))) == Config.Command then
            net.Start("BABSMenu")
            net.Send(v)
        end
    end)

    concommand.Add("babs_interface", function(v)
        if v:IsValid() then
            net.Start("BABSMenu")
            net.Send(v)
        end
    end)

    concommand.Add("babs_update", function(v)
        if (not v:IsValid() or v:IsSuperAdmin()) then
            BABScheck()
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