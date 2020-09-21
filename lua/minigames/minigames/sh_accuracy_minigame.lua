if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted, Based on Randomat event by Owningle"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_accuracy_dmg = {
    slider = true,
    min = 1,
    max = 20,
    desc = "ttt2_minigames_accuracy_dmg (Def. 1)"
  },
  ttt2_minigames_accuracy_heal = {
    slider = true,
    min = 0,
    max = 20,
    desc = "ttt2_minigames_accuracy_heal (Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Accuracy Training"
    },
    desc = {
      English = "Missed shots backfire and hits heal"
    }
  }
end

if SERVER then
  local ttt2_minigames_accuracy_dmg = CreateConVar("ttt2_minigames_accuracy_dmg", "1", {FCVAR_ARCHIVE}, "Damage dealt per missed shot")
  local ttt2_minigames_accuracy_heal = CreateConVar("ttt2_minigames_accuracy_heal", "1", {FCVAR_ARCHIVE}, "Health gained per hit shot")
  function MINIGAME:OnActivation()
    hook.Add("EntityFireBullets", "MinigameAccuracyFire", function(ent, data)
      ent.shotBullet = true
      timer.Simple(0.1, function()
        if ent.hitShotBullet then
          ent.hitShotBullet = false
          ent:SetHealth(math.Clamp(ent:Health() + ttt2_minigames_accuracy_heal:GetInt(), 0, ent:GetMaxHealth()))
        else
          ent:TakeDamage(ttt2_minigames_accuracy_dmg:GetInt())
        end
      end)
    end)

    hook.Add("EntityTakeDamage", "MinigameAccuracyHit", function(ent, dmginfo)
      if ent:IsPlayer() then
        dmginfo:GetAttacker().hitShotBullet = true
        dmginfo:GetAttacker().shotBullet = false
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityFireBullets", "MinigameAccuracyFire")
    hook.Remove("EntityTakeDamage", "MinigameAccuracyHit")
  end
end
