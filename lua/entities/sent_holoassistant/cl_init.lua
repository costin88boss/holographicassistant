include("shared.lua")

// List used for PostDrawTranslucentRenderables hook.
// Purpose is to loop through each entity and draw each text display.
local holoAssistants = {}
//"holoAssistants or {}" would have been ideal if it was e.g. not local

// constant vars
local hintDisplayScale = 100
local textSplitWidth = 200

function ENT:Initialize()
    // Using a clientside model because server will send position updates. 
    // Those position updates give a visual glitch,
    // And these's no downside with clientside models, sooooo
    self.clientMdl = ClientsideModel("models/player.mdl")
    // self.clientMdl:SetParent(self) no need

    self.clientMdl:SetColor(Color(255, 255, 255, 255))
    self.clientMdl:SetRenderMode(RENDERMODE_TRANSCOLOR)
    self.clientMdl:SetPos(self:GetPos())

    self.HintTextLines = { "Hi there! I am a holographic assistant!"}

    // self.clientMdl:Spawn() auto-spawns apparently

   table.insert(holoAssistants, self)
end

function ENT:OnRemove()
    self.clientMdl:Remove()
    // wiki says to avoid this function, but in our case it works fine.
    table.RemoveByValue(holoAssistants, self)
end

// organisation can work I guess
local function GetFloatingPos(ent)
    local ply = ent:GetOwner() // to make the code shorter
    local fwd = ply:GetForward()
    fwd.z = 0
    fwd:Normalize()

    local relPos = (55 * fwd + -45 * ply:GetRight())
    relPos.z = 0

    plyPos = ply:GetPos()
    plyPos.z = 0

    local lerpPos = LerpVector(0.25, ent.clientMdl:GetPos(), plyPos + relPos)
    lerpPos.z = Lerp(0.1, ent.clientMdl:GetPos().z, ply:GetPos().z)

    lerpPos.z = lerpPos.z + math.sin(CurTime() * 3) * 0.15 // inner num is speed, outer is height
    lerpPos.x = lerpPos.x + math.sin(CurTime() + 7 * 3) * 0.5 // inner num is speed, outer is height
    lerpPos.y = lerpPos.y + math.sin(CurTime() + 19 * 3) * 0.5 // inner num is speed, outer is height

    return lerpPos
end

// Clientside model position update
function ENT:Think()
    self.clientMdl:SetPos(GetFloatingPos(self))

    local ang = self:GetOwner():GetAngles()
    ang.p = 0
    ang.y = ang.y - 140
    self.clientMdl:SetAngles(LerpAngle(0.1, self.clientMdl:GetAngles(), ang))
end


// Due to ent:SetNoDraw(true), this won't work for the text stuff
// Leaving empty function for demonstration only
function ENT:Draw()

end

surface.CreateFont("HoloAssistantFont", {
    font = "Arial",
    size = 14,
    weight = 500,
})

// The ID is [addon + sent + name], always make sure your IDs are unique lol
hook.Add("PostDrawTranslucentRenderables", "holographicassistant_sent_holoassistant_drawtexttips", function()
    for i, ents in pairs(holoAssistants) do
        local ang = holoAssistants[i].clientMdl:GetAngles()
        ang.r = ang.r + 90
        ang.y = ang.y + 90

        //local pos = GetFloatingPos(holoAssistants[i], true)
        local pos = holoAssistants[i].clientMdl:GetPos()
        pos = pos + holoAssistants[i].clientMdl:GetForward() * 15
        pos = pos + holoAssistants[i].clientMdl:GetRight() * 10
        pos.z = pos.z + 55

        cam.Start3D2D(pos, ang, 0.1)

        surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect( 0, 0, 2 * hintDisplayScale, 1 * hintDisplayScale)

        surface.SetFont("HoloAssistantFont")
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(2, 0)
        //surface.DrawText(holoAssistants[i].HintText)

        for i, line in pairs(holoAssistants[i].HintTextLines) do
            surface.DrawText(line)
            surface.SetTextPos(2, 15 + (i - 1) * 15)
        end

        cam.End3D2D()
    end
end)

function ENT:OnHoloAssistantHintChanged(name, old, new)
    self.HintTextLines = {}

    surface.SetFont("HoloAssistantFont")
    local w, _ = surface.GetTextSize(new)
    if(w <= textSplitWidth) then
        self.HintTextLines = { new }
        return 
    end

    // Nerd code splitting text. Worked quite a lot here.
    local words = string.Explode(" ", new)
    local lines = {}
    local testLine = ""
    local finalLine = ""
    local i = 1
    while i <= #words do
        testLine = testLine .. words[i]
        local w, _ = surface.GetTextSize(testLine)
        testLine = testLine .. " "
        if(w > textSplitWidth) then
            table.insert(lines, finalLine)
            testLine = ""
            finalLine = ""
            continue 
        end
        finalLine = testLine
        i = i + 1
    end
    table.insert(lines, finalLine)

    self.HintTextLines = lines
end