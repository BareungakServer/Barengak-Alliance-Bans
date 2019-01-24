--[[ BABS -----------------------------------------------------------------------------------------

@VGUI Designer : Bareungak

Modification of the interface is possible, but not re-publishing or writing
to other Addon after modification.

--------------------------------------------------------------------------------------------------]]

if CLIENT then

    local groupurl = "http://steamcommunity.com/groups/barnaliedbans"

    net.Receive("BABSMenu", function(len, ply)
    	local Frame = vgui.Create("DFrame")
    	Frame:SetTitle("")
    	Frame:SetSize(1050,663)
    	Frame:Center()
    	Frame:MakePopup()
        Frame:ShowCloseButton(false)

        Frame.Paint = function( self, w, h )
    	   draw.RoundedBox( 0, 0, 0, w, h, Color(25, 25, 25) ) -- Dark Main
           draw.RoundedBox( 0, 200, 0, 850, 2, Color(229, 229, 229) ) -- White Upper
           draw.RoundedBox( 0, 0, 650, 1050, 13, Color(104, 33, 122) ) -- Pink Down
           draw.SimpleText( "v3.4 for Garry's mod", "HudHintTextSmall", 960, 651, Color(255, 255, 255) ) -- Text of Version
           draw.SimpleText( "System Creator : lill74, _jellen  |  VGUI Creator : Bareungak", "DermaDefault", 5, 649, Color(255, 255, 255) )
        end

        local logo_img = vgui.Create( "DImage", Frame ) -- frame logo image
        logo_img:SetPos( 0, 0 )
        logo_img:SetSize( 200, 650 )
        logo_img:SetImage( "materials/frame_logo.png" )

        local frame_html = vgui.Create( "DHTML", Frame ) -- big frame html
        frame_html:SetPos( 200, 2 )
        frame_html:SetSize( 850, 648 )
        frame_html:OpenURL( "https://raw.githubusercontent.com/BareungakServer/Barengak-Alliance-Bans/master/status_main.png" )

        local whitelist_btn = vgui.Create( "DImageButton", Frame ) -- whitelist button
        whitelist_btn:SetPos( 21, 114 )
        whitelist_btn:SetSize( 156, 24 )
        whitelist_btn:SetImage( "materials/whitelist.png" )
        whitelist_btn.DoClick = function()
            chat.AddText( Color( 0, 210, 255 ), "[BABS]", Color( 255, 255, 255 ), " 해당 기능은 현재 사용할 수 없습니다.")
        end

        local updatedb_btn = vgui.Create( "DImageButton", Frame ) -- updatedb button
        updatedb_btn:SetPos( 27, 156 )
        updatedb_btn:SetSize( 142, 24 )
        updatedb_btn:SetImage( "materials/update_db.png" )
        updatedb_btn.DoClick = function()
            RunConsoleCommand("babs_update")
        end

        local group_btn = vgui.Create( "DImageButton", Frame ) -- group button
        group_btn:SetPos( 30, 199 )
        group_btn:SetSize( 137, 20 )
        group_btn:SetImage( "materials/group.png" )
        group_btn.DoClick = function()
            gui.OpenURL(groupurl)
        end

        local updatead_btn = vgui.Create( "DImageButton", Frame ) -- group button
        updatead_btn:SetPos( 27, 239 )
        updatead_btn:SetSize( 144, 25 )
        updatead_btn:SetImage( "materials/update_addon.png" )
        updatead_btn.DoClick = function()
            RunConsoleCommand("babs_getversion")
        end

        local close_btn = vgui.Create( "DImageButton", Frame ) -- close button
        close_btn:SetPos( 53, 485 )
        close_btn:SetSize( 87, 28 )
        close_btn:SetImage( "materials/close.png" )
        close_btn.DoClick = function()
            Frame:Close()
        end
    end)
end