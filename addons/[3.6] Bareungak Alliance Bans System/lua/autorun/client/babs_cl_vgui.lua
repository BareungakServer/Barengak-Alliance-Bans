--[[ BABS -----------------------------------------------------------------------------------------

@VGUI Designer : Bareungak

Modification of the interface is possible, but not re-publishing or writing
to other Addon after modification.

--------------------------------------------------------------------------------------------------]]

AddCSLuaFile( "babs_cl_fonts.lua" )
include( "babs_cl_fonts.lua" )

if CLIENT then

    local groupurl = "http://steamcommunity.com/groups/barnaliedbans"
    local homepageurl = "https://www.bareungak.com/w_babs"

    net.Receive( "BABSMenu", function( len, ply )
    	local InterFrame = vgui.Create( "DFrame" )
    	InterFrame:SetTitle( "" )
    	InterFrame:SetSize( 1050, 670 )
    	InterFrame:Center()
    	InterFrame:MakePopup()
        InterFrame:ShowCloseButton( false )

        InterFrame.Paint = function( self, w, h )
    	   draw.RoundedBox( 0, 0, 0, w, h, Color( 15, 15, 15 ) ) -- Dark Main
           draw.RoundedBox( 0, 200, 0, 850, 2, Color( 229, 229, 229 ) ) -- White Upper
           draw.RoundedBox( 0, 0, 650, 1050, 20, Color( 104, 33, 122 ) ) -- Pink Down
           draw.SimpleText( "BABS v3.6 | DB KO_KR", "InterFrame_Explanation_Font", 5, 651, Color( 255, 255, 255 ) ) -- Pink Text 1
           draw.SimpleText( "게임 서버와 유저 모두를 위한 게리모드 연합밴 시스템, 바른각 연합밴 입니다.", "InterFrame_Explanation_Font", 170, 651, Color( 255, 255, 255 ) ) -- Pink Text 2
        end

        local InfoFrame = vgui.Create( "DFrame" )
    	InfoFrame:SetTitle( "" )
    	InfoFrame:SetSize( 680, 335 )
        InfoFrame:Center()
        InfoFrame:MakePopup()
        InfoFrame:ShowCloseButton( false )
        InfoFrame:SetVisible( false )

        InfoFrame.Paint = function( self, w, h )
    	   draw.RoundedBox( 0, 0, 0, w, h, Color( 15, 15, 15 ) ) -- Dark Main
           draw.RoundedBox( 0, 0, 0, 680, 12, Color( 255, 255, 255 ) ) -- White Upper
        end

        local InfoFrame_html = vgui.Create( "DHTML", InfoFrame ) -- License Info HTML
        InfoFrame_html:SetPos( 0, 12 )
        InfoFrame_html:SetSize( 680, 323 )
        InfoFrame_html:OpenURL( "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/license_info.png" )

        local InfoFrame_Close_Btn = vgui.Create( "DImageButton", InfoFrame ) -- Close Button
        InfoFrame_Close_Btn:SetPos( 666, 2 )
        InfoFrame_Close_Btn:SetSize( 9, 9 )
        InfoFrame_Close_Btn:SetImage( "materials/babs_interface/icon/close.png" )
        InfoFrame_Close_Btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
            InfoFrame:SetVisible( false )
            InterFrame:SetVisible( true )
        end

        local InterFrame_logo_img = vgui.Create( "DImage", InterFrame ) -- Frame Logo Image
        InterFrame_logo_img:SetPos( 0, 0 )
        InterFrame_logo_img:SetSize( 200, 650 )
        InterFrame_logo_img:SetImage( "materials/babs_interface/frame_logo.png" )

        local InterFrame_html = vgui.Create( "DHTML", InterFrame ) -- Background Frame HTML
        InterFrame_html:SetPos( 200, 2 )
        InterFrame_html:SetSize( 850, 648 )
        InterFrame_html:OpenURL( "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/status_main.png" )

        local InterFrame_whitelist_btn = vgui.Create( "DImageButton", InterFrame ) -- Whitelist Button
        InterFrame_whitelist_btn:SetPos( 21, 114 )
        InterFrame_whitelist_btn:SetSize( 156, 24 )
        InterFrame_whitelist_btn:SetImage( "materials/babs_interface/whitelist.png" )
        InterFrame_whitelist_btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
            chat.AddText( Color( 0, 210, 255 ), "[BABS]", Color( 255, 255, 255 ), " 기능은 존재하나 아직 인터페이스에 추가되있지 않습니다, 콘솔을 이용하세요.")
        end

        local InterFrame_updatedb_btn = vgui.Create( "DImageButton", InterFrame ) -- UpdateDB Button
        InterFrame_updatedb_btn:SetPos( 27, 156 )
        InterFrame_updatedb_btn:SetSize( 142, 24 )
        InterFrame_updatedb_btn:SetImage( "materials/babs_interface/update_db.png" )
        InterFrame_updatedb_btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
            RunConsoleCommand("babs_update")
        end

        local InterFrame_group_btn = vgui.Create( "DImageButton", InterFrame ) -- Group Button
        InterFrame_group_btn:SetPos( 30, 199 )
        InterFrame_group_btn:SetSize( 137, 20 )
        InterFrame_group_btn:SetImage( "materials/babs_interface/group.png" )
        InterFrame_group_btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
            gui.OpenURL(groupurl)
        end

        local InterFrame_updatead_btn = vgui.Create( "DImageButton", InterFrame ) -- UpdateCheck Button
        InterFrame_updatead_btn:SetPos( 27, 239 )
        InterFrame_updatead_btn:SetSize( 144, 25 )
        InterFrame_updatead_btn:SetImage( "materials/babs_interface/update_addon.png" )
        InterFrame_updatead_btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
            RunConsoleCommand("babs_getversion")
        end

        local InterFrame_Close_Btn = vgui.Create( "DImageButton", InterFrame ) -- Close Button
        InterFrame_Close_Btn:SetPos( 53, 485 )
        InterFrame_Close_Btn:SetSize( 87, 28 )
        InterFrame_Close_Btn:SetImage( "materials/babs_interface/close.png" )
        InterFrame_Close_Btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
            InterFrame:Close()
        end

        local InterFrame_Hyperlink_Btn = vgui.Create( "DImageButton", InterFrame ) -- Hyperlink Button
        InterFrame_Hyperlink_Btn:SetPos( 1006, 651 )
        InterFrame_Hyperlink_Btn:SetSize( 16, 16 )
        InterFrame_Hyperlink_Btn:SetImage( "materials/babs_interface/icon/hyperlink.png" )
        InterFrame_Hyperlink_Btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
        	gui.OpenURL(homepageurl)
        end

        local InterFrame_Heart_Btn = vgui.Create( "DImageButton", InterFrame ) -- Heart Button
        InterFrame_Heart_Btn:SetPos( 1025, 650 )
        InterFrame_Heart_Btn:SetSize( 16, 16 )
        InterFrame_Heart_Btn:SetImage( "materials/babs_interface/icon/heart.png" )
        InterFrame_Heart_Btn.DoClick = function()
            surface.PlaySound("babs_interface/b_click.mp3")
            InterFrame:SetVisible( false )
            InfoFrame:SetVisible( true )
            InfoFrame:MoveToFront()
        end
    end)

    net.Receive( "BABSAlert", function( len, ply )
        local AlertPanel_Outside = vgui.Create( "DPanel" )
        AlertPanel_Outside:SetSize( ScrW(), ScrH() )
        AlertPanel_Outside:SetBackgroundColor( Color( 25, 25 ,25 ) )
        AlertPanel_Outside:Center()

        local AlertPanel = vgui.Create( "DPanel" )
        AlertPanel:SetSize( 1920, 1080 )
        AlertPanel:Center()
        AlertPanel:MoveToFront()

        local AlertPanel_HTML = vgui.Create( "DHTML", AlertPanel ) -- Alert Background Image
        AlertPanel_HTML:SetPos( 0, 0 )
        AlertPanel_HTML:SetSize( 1920, 1080 )
        AlertPanel_HTML:OpenURL( "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/alert_background.png" )
        AlertPanel_HTML:Center()

        local AlertPanel_Text_Reason = vgui.Create( "DLabel", AlertPanel ) -- Alert Reason Text
        local AlertPaenl_Server_Reason = net.ReadString()
        AlertPanel_Text_Reason:SetPos( 515, 505 )
        AlertPanel_Text_Reason:SetFont( "AlertPanel_Reason_Font" )
        AlertPanel_Text_Reason:SetText( AlertPaenl_Server_Reason )
        AlertPanel_Text_Reason:SizeToContents()

        local AlertPanel_Text_Date = vgui.Create( "DLabel", AlertPanel ) -- Alert Date Text
        local AlertPanel_Client_Date = os.date( "%Y-%m-%d" )
        AlertPanel_Text_Date:SetPos( 1735, 28 )
        AlertPanel_Text_Date:SetFont( "AlertPanel_Date_Font" )
        AlertPanel_Text_Date:SetText( AlertPanel_Client_Date )
        AlertPanel_Text_Date:SizeToContents()

        local AlertPanel_Text_IUTInfo = vgui.Create( "DLabel", AlertPanel ) -- Alert IP, UID, Time Text
        local AlertPanel_Client_IP = net.ReadString()
        local AlertPanel_Client_64 = net.ReadString()
        local AlertPnael_Client_Time = os.time()
        local AlertPanel_Client_TimeDate = os.date( "%H:%M" )
        AlertPanel_Text_IUTInfo:SetPos( 1470, 61 )
        AlertPanel_Text_IUTInfo:SetFont( "AlertPanel_MInfo_Font" )
        AlertPanel_Text_IUTInfo:SetText( "IP : " .. AlertPanel_Client_IP .. ", UID : " .. AlertPanel_Client_64 .. ", Date : " .. "KST " .. AlertPanel_Client_TimeDate )
        AlertPanel_Text_IUTInfo:SizeToContents()

        local AlertPanel_Text_SInfo = vgui.Create( "DLabel", AlertPanel ) -- Alert Specific Text
        local AlertPanel_Database_Unban = net.ReadString()
        AlertPanel_Text_SInfo:SetPos( 1750, 75 )
        AlertPanel_Text_SInfo:SetFont( "AlertPanel_MInfo_Font" )
        AlertPanel_Text_SInfo:SetText( "Specific : " .. AlertPanel_Database_Unban )
        AlertPanel_Text_SInfo:SizeToContents()
    end)
end