if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_dying_timer = {
    slider = true,
    min = 1,
    max = 60,
    desc = "(Def. 3)"
  },

  ttt2_minigames_dying_dmg = {
    slider = true,
    min = 1,
    max = 100,
    desc = "(Def. 5)"
  },

  ttt2_minigames_dying_affectall = {
    checkbox = true,
    desc = "(Def. 0)"
  },

  ttt2_minigames_dying_cankill = {
    checkbox = true,
    desc = "(Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Death comes..."
    },
    desc = {
      English = "Every moment could be your last!"
    }
  }
end

if SERVER then
  local ttt2_minigames_dying_timer = CreateConVar("ttt2_minigames_dying_timer", "3", {FCVAR_ARCHIVE}, "How often damage is dealt")
  local ttt2_minigames_dying_dmg = CreateConVar("ttt2_minigames_dying_dmg", "5", {FCVAR_ARCHIVE}, "How much damage is dealt per instance")
  local ttt2_minigames_dying_affectall = CreateConVar("ttt2_minigames_dying_affectall", "0", {FCVAR_ARCHIVE}, "Should everyone be damaged simultaneously")
  local ttt2_minigames_dying_cankill = CreateConVar("ttt2_minigames_dying_cankill", "1", {FCVAR_ARCHIVE}, "Should people be able to die from this damage?")

  function MINIGAME:OnActivation()
    timer.Create("DyingMinigameTimer", ttt2_minigames_dying_timer:GetInt(), 0, function()
      local dmg = DamageInfo()
      dmg:SetDamage(ttt2_minigames_dying_dmg:GetInt())
      dmg:SetAttacker(game.GetWorld())
      dmg:SetInflictor(game.GetWorld())
      dmg:SetDamageForce(Vector(0, 0, 1))

      local plys = util.GetAlivePlayers()
      for i = 1, #plys do
        local ply
        repeat
          if #plys <= 0 then return end
          local rnd = math.random(#plys)
          ply = plys[rnd]
          table.remove(plys, rnd)
        until IsValid(ply) and ply:Alive() and not ply:IsSpec()
        if not (ply:Health() < ttt2_minigames_dying_dmg:GetInt()) or ttt2_minigames_dying_cankill:GetBool() then
          ply:TakeDamageInfo(dmg)
        end
        if not ttt2_minigames_dying_affectall:GetBool() then return end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("DyingMinigameTimer")
  end
end
