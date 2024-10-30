-- The ID is [addon + sent + name], always make sure your IDs are unique lol
hook.Add("PostEntityTakeDamage", "holographicassistant_holoassistant_handler_damagehint", function(ent, dmgInfo, took)
    local ply = nil 
    if(dmgInfo:GetAttacker().chaHoloAssistant != nil) then
        ply = dmgInfo:GetAttacker()
    end 
    if(ent.chaHoloAssistant != nil) then
        ply = ent
    end
    if(ply == nil) then return end
    
    if (ent == ply) then
        if (ent:Health() <= 30) then
            ply.chaHoloAssistant:SetHoloAssistantHint("You're low on health! You need to seek shelter!")
            return
        end
        ply.chaHoloAssistant:SetHoloAssistantHint("It seems like you took damage! You need to be more careful next time and seek shelter.")
    end
    if (dmgInfo:GetAttacker() == ply) then
        if (IsEnemyEntityName(ent:GetClass())) then
            ply.chaHoloAssistant:SetHoloAssistantHint("You've attacked! Congratulations!")
        else
            ply.chaHoloAssistant:SetHoloAssistantHint("Watch friendly-fire!")
        end
    end
end)

hook.Add("PlayerSpawn", "holographicassistant_holoassistant_handler_spawn", function(ply)
    if (ply.chaHoloAssistant == nil) then return end

    ply.chaHoloAssistant:SetHoloAssistantHint("Hi there! I am a holographic assistant!")
end)

hook.Add("GravGunOnPickedUp", "holographicassistant_holoassistant_handler_pickedup", function(ply, ent)
    if (ply.chaHoloAssistant == nil) then return end
    if (ent:GetClass() != "npc_grenade_frag") then return end

    ply.chaHoloAssistant:SetHoloAssistantHint("A grenade! It's a good idea to throw it at enemies.")
end)

-- At this point more hooks wouldn't matter much to show my skills, so I'll stop here.
-- I hope this holoassistant code will suffice.