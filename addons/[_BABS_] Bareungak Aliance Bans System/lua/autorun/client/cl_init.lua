if CLIENT then

net.Receive( "AliBanMenu", function( len, ply )
if(LocalPlayer():IsSuperAdmin()) then
local Frame = vgui.Create( "DFrame" )
Frame:SetSize( 300, 160 )
Frame:SetTitle( "바른각 연합밴 시스탬 (v1.0.03)" )
Frame:SetVisible( true )
Frame:SetDraggable( true )
Frame:ShowCloseButton( true )
Frame:Center()
Frame:MakePopup()
	
local DermaButton = vgui.Create( "DButton", Frame )
DermaButton:SetText( "연합밴 목록 업데이트" )
DermaButton:SetPos( 25, 50 )
DermaButton:SetSize( 250, 30 )
DermaButton.DoClick = function()	
	RunConsoleCommand("aliban_update")
end

local DermaButton = vgui.Create( "DButton", Frame )
DermaButton:SetText( "연합밴 그룹" )
DermaButton:SetPos( 25, 100 )
DermaButton:SetSize( 250, 30 )
DermaButton.DoClick = function()	
	gui.OpenURL( "http://steamcommunity.com/groups/barnaliedbans" )
end

else
return false
end
end)
end
