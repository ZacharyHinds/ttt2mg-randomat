if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "No Fall Damage!"
      Русский = "Без урона от падения!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("EntityTakeDamage", "NoFallMinigame", function(ply, dmginfo)
      if IsValid(ply) and ply:IsPlayer() and dmginfo:IsFallDamage() then return true end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityTakeDamage", "NoFallMinigame")
  end
end
