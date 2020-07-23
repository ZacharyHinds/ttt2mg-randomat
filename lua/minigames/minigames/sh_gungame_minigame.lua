if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_gungame_timer = {
    slider = true,
    min = 1,
    max = 60,
    desc = "(Def. 5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Gun Game!"
    },
    desc = {
      English = ""
    }
  }
else
  ttt2_minigames_gungame_timer = CreateConVar("ttt2_minigames_gungame_timer", "5", {FCVAR_ARCHIVE}, "Time between weapon changes")
end

if SERVER then
  function MINIGAME:OnActivation()
    local weps = {}
    for _, ent in ipairs(ents.GetAll()) do
      if ent.Base == "weapon_tttbase" and ent.AutoSpawnable then
        ent:Remove()
      end
    end

    for _, wep in ipairs(weapons.GetList()) do
      if wep.AutoSpawnable and (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) then
        table.insert(weps, wep)
      end
    end

    timer.Create("GunGameMinigame", ttt2_minigames_gungame_timer:GetInt(), 0, function()
      if GetRoundState() ~= ROUND_ACTIVE then timer.Remove("GunGameMinigame") return end
      for k, ply in ipairs(player.GetAll()) do
        local ac = false
        if ply:GetActiveWeapon().Kind == WEAPON_HEAVY or ply:GetActiveWeapon().Kind == WEAPON_PISTOL then
          ac = true
        end

        for _, wep in ipairs(ply:GetWeapons()) do
          if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
            ply:StripWeapon(wep.ClassName)
          end
        end

        local wepGiven = table.Random(weps)
        ply:Give(wepGiven.ClassName)
        ply:SetFOV(0, 0.2)
        if ac then
          ply:SelectWeapon(wepGiven.ClassName)
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("GunGameMinigame")
  end
end
