if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Visualizer",
      Русский = "Визуализатор"
    },
    desc = {
      English = "I see dead people",
      Русский = "Я вижу мёртвых людей"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("PostPlayerDeath", "VisualizerMinigameDeath", function(ply)
      cse = ents.Create("ttt_cse_proj")
      if IsValid(cse) then
        cse:SetPos(ply:GetPos())
        cse:SetOwner(ply)
        cse:SetThrower(ply)
        cse:Spawn()
        cse:PhysWake()
        local phys = cse:GetPhysicsObject()
        if IsValid(phys) then
          phys:SetVelocity(Vector(0, 0, 0))
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostPlayerDeath", "VisualizerMinigameDeath")
  end
end
