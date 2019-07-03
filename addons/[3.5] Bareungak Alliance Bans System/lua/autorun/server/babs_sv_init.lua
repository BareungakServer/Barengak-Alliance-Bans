--[[ BABS -----------------------------------------------------------------------------------------

English :

@System Version : 3.5
@System Developer : lill74, _Jellen, Bareungak
@System Inspection : Bareungak

The source code can be modified for non-profit purposes, original authors, and second revision, 
if the distribution ban is complied with.

--------------------------------------------------------------------------------------------------]]

BABS              = {}
BABS.Configs      = {}
BABS.Banlist      = {}
BABS.IPBanlist    = {}
BABS.Whitelist    = {}
local Config      = BABS.Configs

--[[ Editable -------------------------------------------------------------------------------------

You can modify from this line to the Warn line.

--------------------------------------------------------------------------------------------------]]

-- [Editable] 연합밴 SteamAPI 입력란, 큰 따옴표 사이에 SteamAPI를 작성해주세요! 가족공유 계정 차단에 꼭 필요합니다.
Config.APIKey     = ""

-- [Editable] 연합밴 인터페이스 클라이언트 명령어
Config.Command    = "!연합밴"

-- [Editable] 연합밴 스팀 워크샵 다운로드 허용, false 설정시 서버 네트워크를 이용합니다. [ 기본값 : true ]
Config.WorkshopDL = true

-- [Editable] 연합밴 데이터베이스 업데이트 주기 (초) [ 기본값 : 1200 ]
Config.UpdateTime = 1200

-- [Editable] SteamAPI 서버를 이용해서 모든 가족공유 계정을 차단합니다, true 설정시 차단합니다. [ 기본값 : false ]
Config.KickAllSub = false

--[[ Warn ----------------------------------------------------------------------------------------

Touching below phrase can cause problems with your script, Please Don't Touch it.

--------------------------------------------------------------------------------------------------]]

Config.Version    = 3.5
Config.LVersion   = "Not Loaded!"
Config.Reason     = "[BABS] 바른각 연합밴 등록 사유 : "
Config.URL        = "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/get_banlist.json"

BABS.PRINTTO_ADMINS = 1
BABS.PRINTTO_ALL    = 2
BABS.PRINTTO_NONE   = false

util.AddNetworkString("BABSMenu") --Open BABS Menu
util.AddNetworkString("BABSAlert") --Open Baninfo Alert
    --1. String: Ban Reason
    --2. String: IP address of player
    --3. String: SteamID64 of player
    --4. String: Ban expire date
util.AddNetworkString("BABSRequestWhitelist") --CL=>SV, Request Whitelist table
util.AddNetworkString("BABSReceiveWhitelist") --Receive Whitelist table
    --1. String: util.Compress(util.TableToJSON(BABS.Whitelist))

if Config.WorkshopDL then
    resource.AddWorkshop("1448646002")
else
-- Font Resource
    resource.AddFile( "resource/fonts/NanumBarunGothic.ttf" )
-- Sound Resource
    resource.AddFile( "sound/babs_interface/b_click.mp3" )
-- Interface Icon Resource
    resource.AddFile( "materials/babs_interface/icon/heart.png" )
    resource.AddFile( "materials/babs_interface/icon/hyperlink.png" )
-- Interface Resource
    resource.AddFile( "materials/babs_interface/frame_logo.png" )
    resource.AddFile( "materials/babs_interface/whitelist.png" )
    resource.AddFile( "materials/babs_interface/update_db.png" )
    resource.AddFile( "materials/babs_interface/group.png" )
    resource.AddFile( "materials/babs_interface/update_addon.png" )
    resource.AddFile( "materials/babs_interface/close.png" )
end
function BABS.print(str, printTarget, shouldLog)
        --BABS.print(string str, enum printTarget=BABS.PRINTTO_NONE, bool shouldLog=false)
        --Desc   : <str>를 서버 콘솔에 출력합니다.
        --       : <printTarget> == BABS.PRINTTO_ADMINS 이라면 <str>를 어드민의 채팅창에도 띄웁니다.
        --       : <printTarget> == BABS.PRINTTO_ALL    이라면 <str>를 모두  의 채팅창에도 띄웁니다.
        --       : <shouldLog>가 true라면 babs/log/YYYY-MM-DD.txt에 로그를 작성합니다.
        --Return : nil
        MsgC(Color(0, 212, 255), "[BABS] ", Color(255, 255, 255), str, "\n")

        if printTarget == BABS.PRINTTO_ADMINS then
            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() then
                    v:PrintMessage(HUD_PRINTTALK, "[BABS] " .. str)
                end
            end
        elseif printTarget == BABS.PRINTTO_ALL then
            PrintMessage(HUD_PRINTTALK, "[BABS] " .. str)
        end

        if shouldLog then
            file.Append(
                "babs/logs/" .. os.date("%Y-%m-%d") .. ".txt",
                os.date("[%H:%M:%S]") .. str .. "\n"
            )
        end
end

function BABS.update()
        --BABS.update()
        --Desc   : BABS.Banlist와 BABS.Whitelist를 업데이트하고 새로운 업데이트가 있을 시 알립니다.
        --Return : nil
        if Config.URL ~= "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/get_banlist.json" then
            BABS.print("연합밴 데이터베이스 URL 주소(Config.URL)의 임의 변경이 확인되었습니다, " ..
                       "치명적인 오류가 발생할 수 있으며, 당사는 어떠한 경우에도 해당 서버에 대한 문제를 보증하지 않습니다!",
                       BABS.PRINTTO_ADMINS, true
                      )
        end
        http.Fetch(Config.URL, function(body)
            BABS.Banlist = util.JSONToTable(body)
            BABS.IPBanlist = BABS.Banlist.IPList or {}
            Config.LVersion = tonumber(BABS.Banlist["Ver"])

            if Config.LVersion > Config.Version then
                BABS.print("새로운 업데이트가 있습니다!", BABS.PRINTTO_ADMINS)
            end
            BABS.print("데이터베이스 업데이트가 완료되었습니다!", BABS.PRINTTO_ADMINS)
        end, function(error)
            BABS.print("데이터베이스를 업데이트하는 동안 오류가 발생하였습니다! HTTP 오류 코드: " .. error, BABS.PRINTTO_ADMINS, true)
        end)
        BABS.Whitelist = util.JSONToTable(file.Read("babs/whitelist.txt", "DATA"))
end

function BABS.getFromDB(steamid)
        --BABS.getFromDB(string steamid)
        --Desc   : 밴 DB에서 steamid에 대한 정보를 얻어옵니다.
        --       : steamid 앞에 "b_"가 있어도 없어도 됩니다.
        --       : SteamID32 또는 64를 쓸 수 있습니다.
        --       : 밴이 없으면 nil을 반환합니다.
        --Return : table or nil
        steamid = tostring(steamid)
        steamid = string.gsub(steamid, "^b_", "")
        local to64 = util.SteamIDTo64(steamid)
        if to64 ~= "0" then
            return BABS.Banlist["b_" .. to64]
        elseif #steamid == 17 and string.Left(steamid, 8) == "76561198" then --SteamID64 유효성 검사
            return BABS.Banlist["b_" .. steamid]
        else
            error("[BABS] Tried to check invalid SteamID: " .. steamid)
        end
end

function BABS.getIPFromDB(ip)
    --BABS.getIPFromDB(string ip)
    --Desc   : 밴 DB에서 특정 IP에 대한 정보를 얻어옵니다. 포트가 있어도 되고 없어도 됩니다.
    --       : 없으면 nil을 반환합니다.
    --Return : (table or nil), (string originalAccountSteamid64)
    ip = string.gsub(ip, ":.+", "") --포트 제거
    local tbl = BABS.IPBanlist[ip]
    if tbl then
        return BABS.getFromDB(tbl.ID), tbl.ID:gsub("^b_", "")
    end
    return nil
end

function BABS.checkIsBanned(ply)
    --BABS.checkIsBanned(player ply)
    --Desc   : ply의 고유번호가 연합밴 대상인지 확인하고, 맞다면 킥하고 true를 반환합니다.
    --       : 아니거나 이미 밴당하는 중인 경우 false를 반환합니다.
    --Return : boolean
    if ply.isBeingKickedByBABS then return false end
    local banTbl = BABS.getFromDB(ply:SteamID64())
    if banTbl and ply:IsConnected() and ply:IsFullyAuthenticated() then
        BABS.kickUser(ply, banTbl["Reason"])
        return true
    end
    return false
end

function BABS.checkFamilyShare(ply, retries, errorInfo)
        --BABS.checkFamilyShare( player ply, INTERNAL int retries=0, INTERNAL string errorInfo=(long string) )
        --Desc   : 만약 ply가 이미 킥당하는 중이라면 실행하지 않습니다.
        --       : http.Fetch()와 SteamAPI를 이용하여 ply가 가족 공유 계정인지 확인합니다.
        --       : 가족 공유 계정이며 본계정이 연합밴 대상자일 경우, <본계정 밴사유 .. "(부계정 감지)"> 의 사유로 ply를 킥 처리합니다.
        --       : 가족 공유 계정이며 Config.KickAllSub == true일 경우, 가족공유가 금지되어있다는 사유로 ply를 킥 처리합니다.
        --       : 만약 이 과정에서 오류가 발생했을 시, retries에 1을 더하고 errorInfo를 작성한 뒤 자기 자신을 몇 초 후에 다시 호출합니다.
        --       : retries가 4회 이상이라면 에러를 발생합니다.(ErrorNoHalt)
        --Return : nil
        if ply.isBeingKickedByBABS then return end
        retries = retries or 0
        errorInfo = errorInfo or "부계정 확인 과정에서 알 수 없는 오류가 발생했습니다!"
        if retries >= 4 then
            BABS.print(errorInfo, BABS.PRINTTO_ADMINS, true)
            ErrorNoHalt("[BABS] " .. errorInfo)
            return
        end
        if APIKey == "" or not APIKey then
            BABS.print("SteamAPI 키가 적혀있지 않습니다. 부계정 감지를 위해 SteamAPI 키를 작성해 주세요.", BABS.PRINTTO_ADMINS)
            return
        end

        http.Fetch(string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&steamid=%s&appid_playing=4000", Config.APIKey, ply:SteamID64()), function(body)
            if not body then
                timer.Simple(5, function()
                    BABS.checkFamilyShare(ply,retries+1, "SteamAPI 응답이 없습니다!")
                end)
                return
            end
            local body = util.JSONToTable(body)
            if not body.response or not body.response.lender_steamid then
                timer.Simple(5, function() BABS.checkFamilyShare(ply, retries+1, "SteamAPI 응답이 올바르지 않습니다! API키가 올바르게 적혀있는지 확인해 주세요.") end)
                return
            end

            local lender = body.response.lender_steamid

            local banTbl = BABS.getFromDB(lender)
            if banTbl then
                BABS.kickUser(ply, banTbl["Reason"] .. "(부계정 감지)", lender)
            end

            if Config.KickAllSub and lender ~= "0" then
                BABS.print(ply:Nick() .. "님은 가족공유 계정이기 때문에 바른각 연합밴 시스템에 의해 추방되었습니다!", BABS.PRINTTO_ALL, true)
                ply:Kick("[BABS] 이 서버에서는 가족공유 계정을 사용하실 수 없습니다.")
            end

        end, function(errorcode)
            timer.Simple(5, function() BABS.checkFamilyShare(ply, retries+1, "API 서버에서 에러 코드를 반환했습니다! 코드: " .. errorcode) end)
        end)
end

function BABS.checkIPAddress(ply)
    --BABS.checkIPAddress(player ply)
    --Desc   : ply의 IP가 밴리스트에 IPBanlist에 있는지 확인하고,
    --       : 있다면 "이유" .. "(부계정 감지)" 의 이유로 킥하고 true를 반환합니다.
    --       : 아니거나 ply가 이미 킥당하고 있으면 false를 반환합니다.
    --Return : boolean
    if ply.isBeingKickedByBABS then return false end
    local banTbl,originalSteamID64 = BABS.getIPFromDB(ply:IPAddress())
    if banTbl and ply:IsConnected() and ply:IsFullyAuthenticated() then
        BABS.kickUser(ply, banTbl["Reason"] .. "(부계정 감지)", originalSteamID64)
        return true
    end
    return false
end

function BABS.kickUser(ply, creason, originalAccountSteamID64)
    --BABS.kickUser(player ply, string creason, string originalAccountSteamID64 = ply's steamid64)
    --Desc   : ply를 킥하고 모두에게 알립니다.
    --Return : nil
    if not ply or not ply:IsValid() then error("[BABS] Tried to kick invalid user!") end
    if ply.isBeingKickedByBABS then return end
    if not originalAccountSteamID64 then originalAccountSteamID64 = ply:SteamID64() end
    local banTbl = BABS.getFromDB(originalAccountSteamID64)
    local reason = Config.Reason .. creason
    BABS.print(ply:Nick() .. "님은 바른각 연합밴 시스템에 의해 추방되었습니다! 사유: '" .. banTbl["Name"] .. " - " .. creason .. "'", BABS.PRINTTO_ALL, true)
    net.Start("BABSAlert")
        net.WriteString(banTbl["Reason"])
        net.WriteString(ply:IPAddress())
        net.WriteString(ply:SteamID64())
        net.WriteString(banTbl["Date"])
    net.Send(ply)
    ply:Lock()
    ply:KillSilent() --No respawn if locked
    ply.isBeingKickedByBABS = true
    timer.Create( "BABS_KickTimer", 30, 1, function()
        if not IsValid(ply) then return end
        ply:Kick(reason)
    end)
end
hook.Add("PlayerSpawnObject", "BABSPreventBanningUserSpawn", function(ply)
    --밴당하고 있을때 물체스폰 금지
    if ply.isBeingKickedByBABS then return false end
end)

function BABS.getFromWhitelist(steamid64)
    --BABS.getFromWhitelist(string steamid64)
    --Desc   : steamid64가 화이트리스트에 있는지 확인합니다.
    --Return : boolean
    return not not BABS.Whitelist["b_" .. steamid64]
end

function BABS.addSteamID64ToWhitelist(steamid64, nick)
    --BABS.addSteamID64ToWhitelist(string steamid64, string nick)
    --Desc   : steamid64를 화이트리스트에 추가하고 리스트를 저장합니다.
    nick = tostring(nick) or tostring(steamid64)
    BABS.Whitelist["b_" .. steamid64] = {Nick = nick}
    file.Write("babs/whitelist.txt", util.TableToJSON(BABS.Whitelist))
end

function BABS.removeSteamID64FromWhitelist(steamid64)
    --BABS.removeSteamID64FromWhitelist(string steamid64)
    --Desc   : steamid64를 화이트리스트에서 제거하고 리스트를 저장합니다.
    BABS.Whitelist["b_" .. steamid64] = nil
    file.Write("babs/whitelist.txt", util.TableToJSON(BABS.Whitelist))
end

----Hooks----

hook.Add("Initialize", "InitializeBABS", function()
    timer.Create("UpdateBABS", Config.UpdateTime, 0, BABS.update)
    file.CreateDir("babs")
    file.CreateDir("babs/logs")
    if (not file.Exists("babs/whitelist.txt", "DATA")      ) or
       (    file.Read  ("babs/whitelist.txt", "DATA") == "")
    then
        file.Write("babs/whitelist.txt", "[]")
    end

    BABS.update()
    BABS.print("시스템이 정상적으로 로드되었습니다! 게리모드용 연합밴 버전 : v" .. Config.Version)
end)

hook.Add("PlayerAuthed", "BABSCheckUsers", function(ply)
    if not BABS.getFromWhitelist(ply:SteamID64()) then
        BABS.checkIsBanned(ply)
        BABS.checkFamilyShare(ply)
        BABS.checkIPAddress(ply)
    end
end)

hook.Add("PlayerSay", "BABSCallMenu", function(ply, cmd)
    if (string.Trim(string.lower(cmd))) == Config.Command then
        net.Start("BABSMenu")
        net.Send(ply)
    end
end)

----Concommands----

concommand.Add("babs_interface", function(v)
    if v:IsValid() then
        net.Start("BABSMenu")
        net.Send(v)
    end
end)

concommand.Add("babs_update", function(v)
    if (not v:IsValid() or v:IsSuperAdmin()) then
        BABS.update()
    end
end)

concommand.Add("babs_getversion", function(v)
    if v:IsValid() then
        v:PrintMessage(HUD_PRINTTALK, "[BABS] 최신 버전 : " .. Config.LVersion .. "  현재 버전 : " .. Config.Version)
    else
        BABS.print("Last version : " .. Config.LVersion .. "  Current version : " .. Config.Version)
    end
end)

concommand.Add("babs_addtowhitelist", function(v,_,args)
    --args[1] : steamid32/64
    --args[2] : nickname
    if v:IsValid() and not v:IsSuperAdmin() then return end
    args[1] = args[1] or "<InvalidSteamID>"
    local to64 = util.SteamIDTo64(args[1])
    local argumentIsValidSteamid64 = #args[1] == 17 and string.Left(args[1], 8) == "76561198"

    if to64 ~= "0" then 
        BABS.addSteamID64ToWhitelist(to64   , args[2])
    elseif argumentIsValidSteamid64 then
        BABS.addSteamID64ToWhitelist(args[1], args[2])
    else
        if v:IsValid() then
            v:PrintMessage(HUD_PRINTTALK, "올바른 고유번호/SteamID64가 아닙니다.")
        else
            BABS.print("올바른 고유번호/SteamID64가 아닙니다.")
        end
        return
    end

    BABS.print(args[1] .. "(" .. args[2] or args[1] .. ")" .. "이 화이트리스트에 추가되었습니다.", BABS.PRINTTO_ADMINS, true)
end)

concommand.Add("babs_removefromwhitelist", function(v,_,args)
    if v:IsValid() and not v:IsSuperAdmin() then return end
    args[1] = args[1] or "<InvalidSteamID>"
    local to64 = util.SteamIDTo64(args[1])
    local argumentIsValidSteamid64 = #args[1] == 17 and string.Left(args[1], 8) == "76561198"
    local steamid64

    if to64 ~= "0" then
        steamid64 = to64
    elseif argumentIsValidSteamid64 then
        steamid64 = args[1]
    else
        if v:IsValid() then
            v:PrintMessage(HUD_PRINTTALK, "올바른 고유번호/SteamID64가 아닙니다.")
        else
            BABS.print("올바른 고유번호/SteamID64가 아닙니다.")
        end
        return
    end

    if BABS.getFromWhitelist(steamid64) then
        BABS.removeSteamID64FromWhitelist(steamid64)
        BABS.print(args[1] .. " 이 화이트리스트에서 제거되었습니다.", BABS.PRINTTO_ADMINS, true)
    else
        if v:IsValid() then
            v:PrintMessage(HUD_PRINTTALK, "화이트리스트에 해당 고유번호가 존재하지 않습니다.")
        else
            BABS.print("화이트리스트에 해당 고유번호가 존재하지 않습니다.")
        end
    end
end)

----net.Receive----

net.Receive("BABSRequestWhitelist", function(len, ply)
    if not ply:IsAdmin() then return end
    net.Start("BABSReceiveWhitelist")
        net.WriteString(util.Compress(util.TableToJSON(BABS.Whitelist)))
    net.Send(ply)
end)