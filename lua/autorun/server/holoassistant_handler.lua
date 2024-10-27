// List used for PostDrawTranslucentRenderables hook.
// Purpose is to loop through each entity and draw each text display.
holoAssistants = holoAssistants or {}
// in a real-world scenario, such variable names aren't ideal because they're global

// The ID is [addon + sent + name], always make sure your IDs are unique lol
hook.Add("PostEntityTakeDamage", "holographicassistant_holoassistant_handler_damagehint", function(ent, dmgInfo, took)
    for i, assistant in pairs(holoAssistants) do
        if(ent == assistant:GetOwner()) then
            if(ent:Health() <= 30) then
                assistant:SetHoloAssistantHint("You're low on health! You need to seek shelter!")
                return
            end
            assistant:SetHoloAssistantHint("It seems like you took damage! You need to be more careful next time and seek shelter.")
        end
        if (dmgInfo:GetAttacker() == assistant:GetOwner()) then
            if(IsEnemyEntityName(ent:GetClass())) then
                assistant:SetHoloAssistantHint("You've attacked! Congratulations!")
            else
                assistant:SetHoloAssistantHint("Watch friendly-fire!")
            end
        end
    end
end)

hook.Add("PlayerSpawn", "holographicassistant_holoassistant_handler_spawn", function(ply)
    for i, assistant in pairs(holoAssistants) do
        if(ply == assistant:GetOwner()) then
            assistant:SetHoloAssistantHint("Hi there! I am a holographic assistant!")
        end
    end
end)

hook.Add("GravGunOnPickedUp", "holographicassistant_holoassistant_handler_pickedup", function(ply, ent)
    for i, assistant in pairs(holoAssistants) do
        if(ply == assistant:GetOwner()) then
            if(ent:GetClass() == "npc_grenade_frag") then
                assistant:SetHoloAssistantHint("A grenade! It's a good idea to throw it at enemies.")
            end
        end
    end
end)

// At this point more hooks wouldn't matter much to show my skills, so I'll stop here.
// I hope this holoassistant code will suffice.