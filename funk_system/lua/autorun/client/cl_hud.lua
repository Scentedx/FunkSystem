include("autorun/sh_config.lua")

surface.CreateFont( "DrawFont", {
	font = "System", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 16,
} )

net.Receive("funk_draw_message", function(len, ply)
   
        timer.Create("NachrichtTimer", 60, 1, function() 
        end)
    

        hook.Add("HUDPaint", "DrawNormalTimerMessage", function() 
        if timer.Exists("NachrichtTimer") then
            if timer.TimeLeft("NachrichtTimer") == 0 or nil  then
                timer.Destroy("NachrichtTimer")
                else
                    draw.SimpleText("[Funk] Normaler Funk wird in: " .. math.ceil(timer.TimeLeft("NachrichtTimer")) .. " Sekunden übermittelt!", "DrawFont", ScrW() / 2 * .3, ScrH() * .65, Color(0, 153, 51), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                    net.Start("funk_normal_running")
                    net.WriteBool(false)
                    net.SendToServer()
                end
        end
            end)
    

end)

net.Receive("funk_draw_messagef", function(len, ply) 
    
    timer.Create("VerschlNachrichtTimer", 180, 1, function() 
    end)

    hook.Add("HUDPaint", "DrawTimerMessage", function() 
    if timer.Exists("VerschlNachrichtTimer") then
        if timer.TimeLeft("VerschlNachrichtTimer") == 0 or nil  then
            timer.Destroy("VerschlNachrichtTimer")
            else
                draw.SimpleText("[vFunk] Verschlüsselter Funk wird in: " .. math.ceil(timer.TimeLeft("VerschlNachrichtTimer")) .. " Sekunden übermittelt!", "DrawFont", ScrW() / 2 * .3, ScrH() * .65, Color(128,0,128,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                net.Start("funk_verschl_running")
                net.WriteBool(false)
                net.SendToServer()
            end
    end
        end)

    if ( timer.TimeLeft("VerschlNachrichtTimer") == nil ) then 
        timer.Remove("VerschlNachrichtTimer")
    elseif  ( timer.TimeLeft("VerschlNachrichtTimer") == 0 ) then
        timer.Remove("VerschlNachrichtTimer")
    end

end)