if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Random Weapons!"
    },
    desc = {
      English = "Try your best..."
    }
  }
else
end

if SERVER then
  function MINIGAME:OnActivation()
    local weps1 = {}
    local weps2 = {}

    for _, wep in RandomPairs(weapons.GetList()) do
      if not wep.AutoSpawnable then continue end

      if wep.Kind == WEAPON_HEAVY then
        table.insert(weps1, wep)
      elseif wep.Kind == WEAPON_PISTOL then
        table.insert(weps2, wep)
      end
    end

    for _, ply in ipairs(player.GetAll()) do
      for k, wep in ipairs(ply:GetWeapons()) do
        if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
          ply:StripWeapon(wep:GetClass())
        end
      end

      local rdm_wep1 = table.Random(weps1)
      local rdm_wep2 = table.Random(weps2)

      local wep1 = ply:Give(rdm_wep1.ClassName)
      local wep2 = ply:Give(rdm_wep2.ClassName)

      wep1.AllowDrop = false
      wep2.AllowDrop = false
    end
  end

  function MINIGAME:OnDeactivation()

  end
end
