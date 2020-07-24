if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Total Mayhem!"
    },
    desc = {
      English = ""
    }
  }
else
end

if SERVER then
  function MINIGAME:OnActivation()
    local effectData = EffectData()

    hook.Add("TTT2PostPlayerDeath", "MayhemMinigameExplode", function(ply, _, attacker)
      if not IsValid(ply) then return end

      timer.Create("MayhemMinigameDelay" .. ply:Nick(), 0.1, 1, function()
        local explode = ents.Create("env_explosion")
        explode:SetPos(ply:GetPos())
        explode:SetOwner(attacker)
        explode:Spawn()
        explode:SetKeyValue("iMagnitude", "150")
        explode:Fire("Explode", 0, 0)
        explode:EmitSound("ambient/explosions/explode_4.wav", 400, 400)
      end)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostPlayerDeath", "MayhemMinigameExplode")
  end
end
