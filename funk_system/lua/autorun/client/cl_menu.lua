include("autorun/sh_config.lua")

-- Button klick nachricht senden
-- DProgress 20 Sekunden um nachricht zu senden
-- Checkbox falls verschlüsselt oder nicht
-- Sounds hinzufügen, bei Funken, und während übermittlung
net.Receive("funk_open", function()

    surface.CreateFont( "ButtonTxT", {
        font = "Arial", 
        extended = false,
        size = 13,
        weight = 500,
    } )

    surface.CreateFont( "PanelTxT", {
        font = "System", 
        extended = false,
        size = 15,
        weight = 500,
    } )

    surface.CreateFont( "ScreenTxt", {
        font = "System", 
        extended = false,
        size = 21,
        weight = 500,
    } )



local mainfenster = vgui.Create("DFrame")
    mainfenster:SetSize(600, 300)
    mainfenster:Center()
    mainfenster:SetTitle(FUNK_TITLE)
    mainfenster:ShowCloseButton(true)
    mainfenster:SetDraggable(false)
    mainfenster:MakePopup()
    mainfenster:SetBackgroundBlur(true)
    mainfenster.btnMinim:SetVisible(false)
    mainfenster.btnMaxim:SetVisible(false)
    mainfenster.btnClose:SetVisible(false)
    mainfenster:SetDeleteOnClose(true)

    mainfenster.Paint = function(self, w, h)
        surface.SetDrawColor(50, 50, 50, 200)
        surface.DrawRect(0, 0, w, h)
        surface.SetFont("PanelTxT")
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(mainfenster:GetWide() / 2 * .82 , mainfenster:GetTall() / 2 * .4)
        surface.DrawText("Person auswählen!")
    end

    local sendbuttonp = vgui.Create("DPanel", mainfenster)
    sendbuttonp:SetSize(100, 25)
    sendbuttonp:SetPos(mainfenster:GetWide() / 2 * .82 , mainfenster:GetTall() / 2 + 30)
    sendbuttonp.Paint = function(self, w, h)
        surface.SetDrawColor(30, 30, 30, 200)
        surface.DrawRect(0, 0, w, h)
    end

    local vfunkding = vgui.Create("DCheckBoxLabel", mainfenster)
        vfunkding:SetSize(100, 25)
        vfunkding:SetPos(mainfenster:GetWide()  * .36 , mainfenster:GetTall() / 2 * .77 )
        vfunkding:SetFont("PanelTxT")
        vfunkding:SetText("Verschlüsselter Funk [3x]")
        vfunkding:SizeToContents()
        function vfunkding:OnChange(val)
            if val then 
                chat.AddText(Color(128, 0, 128), "[vFunk] Wird jetzt verschlüsselt...")
            else
                chat.AddText(Color(255, 255, 255), "[Funk] Funk ohne Verschlüsslung...")
            end
        end

    local spielerauswahl = vgui.Create("DComboBox", mainfenster)
        spielerauswahl:SetPos(mainfenster:GetWide() * .4, mainfenster:GetTall() * .25)
        spielerauswahl:SetSize(120, 20)
        spielerauswahl:SetValue("Name auswählen!")
        
        spielerauswahl.OnSelect = function(_, _, value)
            print(value .. " wurde ausgewählt!")
        end

        for k, v in pairs(player.GetAll()) do
            repeat
                if v:Name() == LocalPlayer():Name() then 
                do break end end
                until 
            spielerauswahl:AddChoice( v:Name() )
        end

    local nachrichttxt = vgui.Create("DTextEntry", mainfenster)
        nachrichttxt:SetPos(mainfenster:GetWide() * .25, mainfenster:GetTall() / 2)
        nachrichttxt:SetSize(300, 20)
        nachrichttxt:SetText("Nachricht einfügen!")
        nachrichttxt.OnEnter = function(self)
        end

    local closebutton = vgui.Create("DImageButton", mainfenster)
    closebutton:SetSize(32, 32)
    closebutton:SetPos(mainfenster:GetWide() * .97, 1)
    closebutton:SetImage("icon16/cancel.png")
    closebutton:SizeToContents()
    closebutton:SetVisible(true)
    function closebutton:OnMousePressed()
        closebutton:Remove()
        mainfenster:Close()
    end

   local sendbutton = vgui.Create("DButton", sendbuttonp)
        sendbutton:SetSize(100, 25)
        sendbutton:SetPos(0, 0)
        sendbutton:SetText("Absenden!")
        sendbutton.Paint = function(self, w, h)
            surface.SetDrawColor(30, 30, 30, 200)
            surface.DrawRect(0, 0, w, h)
        end
        
        function sendbutton:DoClick()
            if ( nachrichttxt:GetValue() == "Nachricht einfügen!") then 
                chat.AddText(Color(255, 50, 50), "Du musst eine Nachricht eingeben!")  
                return false
            elseif ( nachrichttxt:GetValue() == "" ) then 
                chat.AddText(Color(255, 50, 50), "Du musst eine Nachricht eingeben!")  
                return false
            else
                if ( spielerauswahl:GetSelected() == nil  ) then 
                    chat.AddText(Color(255, 50, 50), "Du musst eine Person auswählen!")  
                    return false  
                elseif ( spielerauswahl:GetSelected() == LocalPlayer():Name() ) then 
                    chat.AddText(Color(255, 50, 50), "Du kannst dich nicht selbst anfunken!")  
                    return false
                else
                    net.Start("funk_nachricht")
                    net.WriteString(LocalPlayer():Name())
                    net.WriteString(spielerauswahl:GetSelected())
                    net.WriteString(nachrichttxt:GetValue())
                    net.WriteBool(vfunkding:GetChecked())
                    net.SendToServer()         
                    closebutton:Remove()
                    mainfenster:Close()
                end
            end
        end

        net.Receive("dont_drawsir", function(len, ply)
    
            -- drawsirr = net.ReadBool()
              --   if ( ply != LocalPlayer() ) then return false end
                --     if ( drawsirr == true ) then 
                  --       mainfenster:Close()
                    -- end
                if ( LocalPlayer() != ply) then return false end
                    if IsValid(mainfenster) then 
                        mainfenster:Close()
                        timer.Simple(1, function()
                            chat.AddText(color_red, "[FUNK] Warte bis die Funk-Nachricht übermittelt worden ist!")
                        end)
                    end
         end)
                 
         net.Receive("dont_drawsirr", function(len, ply)
            if ( LocalPlayer() != ply) then return false end
                if IsValid(mainfenster) then 
                mainfenster:Close()
                timer.Simple(1, function()
                    chat.AddText(color_red, " [FUNK] Warte bis die Funk-Nachricht übermittelt worden ist!")
                end)
            end
         end)

end)


      