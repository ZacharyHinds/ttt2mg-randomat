if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_regen_delay = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2_minigames_regen_delay (Def. 10)"
  },

  ttt2_minigames_regen_hp = {
    slider = true,
    min = 1,
    max = 25,
    desc = "ttt2_minigames_regen_hp (Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Regeneration"
      Русский = "Регенерация"
    },
    desc = {
      English = "We learned to heal over time, its hard, but definitely possible..."
      Русский = "Мы научились лечиться с течением времени, это тяжело, но определённо возможно..."
    }
  }
end

if SERVER then
  local ttt2_minigames_regen_delay = CreateConVar("ttt2_minigames_regen_delay", "10", {FCVAR_ARCHIVE}, "Delay after taking damage to start healing")
  local ttt2_minigames_regen_hp = CreateConVar("ttt2_minigames_regen_hp", "1", {FCVAR_ARCHIVE}, "Health healed per second")
  function MINIGAME:OnActivation()
    local plys = player.GetAll()
    for i = 1, #plys do
      local ply = plys[i]
      if ply:IsSpec() or not ply:Alive() then continue end

      ply.mgRegen = CurTime() + 1
    end

    hook.Add("Think", "RegenMinigameThink", function()
      for i = 1, #plys do
        local ply = plys[i]
        if ply:IsSpec() or not ply:Alive() then continue end

        if ply.mgRegen <= CurTime() then
          ply:SetHealth(math.Clamp(ply:Health() + ttt2_minigames_regen_hp:GetInt(), 0, ply:GetMaxHealth()))
          ply.mgRegen = CurTime() + 1
        end
      end
    end)

    hook.Add("EntityTakeDamage", "RegenMinigameDmg", function(ply, dmginfo)
      if not IsValid(ply) or not ply:IsPlayer() or ply:IsSpec() or dmginfo:GetDamage() > ply:Health() then return end

      ply.mgRegen = CurTime() + ttt2_minigames_regen_delay:GetInt()
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "RegenMinigameThink")
    hook.Remove("EntityTakeDamage", "RegenMinigameDmg")
  end
end
