AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"

ENT.PrintName = "Holo Assistant"
ENT.Category = "Holo Assistant"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "HoloAssistantHint")

    if (!CLIENT) then return end
    self:NetworkVarNotify("HoloAssistantHint", self.OnHoloAssistantHintChanged)
end