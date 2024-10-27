AddCSLuaFile("entities/sent_holoassistant/cl_init.lua")
AddCSLuaFile("entities/sent_holoassistant/shared.lua")

include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local ent = ents.Create("sent_holoassistant")
    
    ent:SetOwner(ply)
    ent:SetPos(tr.HitPos + tr.HitNormal)

    ent:SetNoDraw(true) // we're using a clientside model instead + it removes a shadow.

	ent:Spawn()
	ent:Activate()

	table.insert(holoAssistants, ent)

	return ent
end

function ENT:OnRemove()
	table.RemoveByValue(holoAssistants, self)
end