include("autorun/sh_config.lua")

local allplayers = player.GetAll()

util.AddNetworkString("funk_open")
util.AddNetworkString("funk_nachricht")
util.AddNetworkString("funk_ticked")
util.AddNetworkString("funk_draw_message")
util.AddNetworkString("funk_draw_messagef")
util.AddNetworkString("funk_verschl_running")
util.AddNetworkString("funk_normal_running")
util.AddNetworkString("dont_drawsir")
util.AddNetworkString("dont_drawsirr")


net.Receive("funk_normal_running", function(len, ply)
    local normalrunning = net.ReadBool()
        if normalrunning == false then 
            net.Start("dont_drawsir")
            net.WriteBool(true)
            net.Send(ply)
        end
end)

net.Receive("funk_verschl_running", function(len, ply)
    local verschlrunning = net.ReadBool()
        if verschlrunning == false then 
            net.Start("dont_drawsirr")
            net.WriteBool(true)
            net.Send(ply)
        end
end)
    if ( !verschlrunning or !normalrunning ) then 
hook.Add("PlayerSay", "FunkCommand", function(sender, text, teamChat)
        
        if ( string.lower(text) == "/funk" ) then 
            net.Start("funk_open")
            net.Send(sender)
            return ""
        end

        if ( string.lower(text) == "!funk" ) then 
            net.Start("funk_open")
            net.Send(sender)
            return ""
        end
end)
    else 
    return false 
    end
net.Receive("funk_nachricht", function(len, ply)

    local sender = net.ReadString()
    local target = net.ReadString()
    local message = net.ReadString()
    local ticked = net.ReadBool()

    if ( ply:GetName() != sender ) then 
        ply:Ban(0, true)
        PrintMessage(HUD_PRINTTALK, "Weg mit dir du Huan! " .. ply:GetName().. " ist ein schmutziger Hacker! Und wurde permanent dafür gebannt!")
        return false 
    end

    if ( ticked == true ) then
        net.Start("funk_draw_messagef")
        net.Send(ply)
        timer.Create("VFunkTimer", 180, 1, function()
            PrintMessage(HUD_PRINTTALK, "<c=128,0,128>[VFUNK]</c> <c=255,255,102>*" .. sender .. " an " .. target .. "*</c> " ..  message  )  
        timer.Remove("VFunkTimer")
        end)
    else
        net.Start("funk_draw_message")
        net.Send(ply)
        timer.Create("FunkTimer", 60, 1, function()
            PrintMessage(HUD_PRINTTALK, "<c=0,153,51>[FUNK]</c> <c=255,255,102>*" .. sender .. " an " .. target .. "*</c> " ..  message  )
        timer.Remove("FunkTimer")
        end)
    end

end)

