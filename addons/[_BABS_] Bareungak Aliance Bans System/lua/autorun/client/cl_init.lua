if CLIENT then
    local groupurl = "http://steamcommunity.com/groups/barnaliedbans"
    local infourl = "http://steamcommunity.com/groups/barnaliedbans"

    net.Receive("AliBanMenu", function(len, ply)
        if (LocalPlayer():IsSuperAdmin()) then
            surface.CreateFont("BigFont", {
                font = "NanumGothic",
                size = 60,
                weight = 400,
                antialias = true
            })

            surface.CreateFont("MediumFont", {
                font = "NanumGothic",
                size = 40,
                weight = 400,
                antialias = true
            })

            surface.CreateFont("SmallFont", {
                font = "NanumGothic",
                size = 19,
                weight = 400,
                antialias = true
            })

            local Frame = vgui.Create("DFrame")
            Frame:SetTitle("")
            Frame:SetSize(ScrW() * 0.196, ScrH() * 0.633)
            Frame:Center()
            Frame:MakePopup()

            Frame.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30)) -- black gui
                draw.RoundedBox(0, 0.05 * ScrW(), 0.236 * ScrH(), 0.0928125 * ScrW(), 0.1116 * ScrH(), Color(49, 49, 49)) -- gray gui
                draw.RoundedBox(0, 0.05 * ScrW(), 0.236 * ScrH(), 0.0928125 * ScrW(), 0.0222 * ScrH(), Color(0, 104, 183)) -- white update gui
                draw.RoundedBox(0, 0, 0, 0.020625 * ScrW(), 0.6333 * ScrH(), Color(0, 104, 183)) -- blue gui
                draw.RoundedBox(0, 0.0209375 * ScrW() - 1, 0.594444 * ScrH(), 0.175 * ScrW() + 1, 0.03833 * ScrH(), Color(0, 104, 183)) -- blue gui
                draw.SimpleText("v2.0", "BigFont", 0.065625 * ScrW(), 0.26666 * ScrH(), Color(255, 255, 255))
                draw.SimpleText("바른각 연합밴", "MediumFont",0.03125 * ScrW(), 0.592222 * ScrH(), Color(255, 255, 255))
            end

            local Button1 = vgui.Create("DButton", Frame)
            Button1:SetText("연합밴 새로고침")
            Button1:SetTextColor(Color(255, 255, 255))
            Button1:SetPos(0.04375 * ScrW(), 0.055555 * ScrH())
            Button1:SetSize(0.125 * ScrW(), 0.03333 * ScrH())

            Button1.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(250, 96, 0)) -- Draw a blue button
            end

            Button1.DoClick = function()
                RunConsoleCommand("aliban_update")
            end

            local Button2 = vgui.Create("DButton", Frame)
            Button2:SetText("연합밴 정보")
            Button2:SetTextColor(Color(255, 255, 255))
            Button2:SetPos(0.04375 * ScrW(), 0.111111 * ScrH())
            Button2:SetSize(0.125 * ScrW(), 0.033333 * ScrH())

            Button2.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(250, 96, 0)) -- Draw a blue button
            end

            Button2.DoClick = function()
                gui.OpenURL(infourl)
            end

            local Button3 = vgui.Create("DButton", Frame)
            Button3:SetText("업데이트 확인")
            Button3:SetTextColor(Color(255, 255, 255))
            Button3:SetPos(0.04375 * ScrW(), 0.37777 * ScrH())
            Button3:SetSize(0.125 * ScrW(), 0.03333 * ScrH())

            Button3.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 53, 103)) -- Draw a blue button
            end

            Button3.DoClick = function()
                RunConsoleCommand("babs_getversion")
            end

            local Button4 = vgui.Create("DButton", Frame)
            Button4:SetText("연합밴 그룹")
            Button4:SetTextColor(Color(255, 255, 255))
            Button4:SetPos(0.04375 * ScrW(), 0.433333 * ScrH())
            Button4:SetSize(0.125 * ScrW(), 0.03333 * ScrH())

            Button4.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 53, 103)) -- Draw a blue button
            end

            Button4.DoClick = function()
                gui.OpenURL(groupurl)
            end

            local Button5 = vgui.Create("DButton", Frame)
            Button5:SetText("연합밴 목록 보기")
            Button5:SetTextColor(Color(255, 255, 255))
            Button5:SetPos(0.04375 * ScrW(), 0.488888 * ScrH())
            Button5:SetSize(0.125 * ScrW(), 0.033333 * ScrH())

            Button5.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 53, 103)) -- Draw a blue button
            end

            Button5.DoClick = function()
                RunConsoleCommand("babs_getlist")
            end
        end
    end)
end