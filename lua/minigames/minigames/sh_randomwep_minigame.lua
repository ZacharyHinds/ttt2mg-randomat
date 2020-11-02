if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Random Weapons!",
      Русский = "Случайное оружие!"
    },
    desc = {
      English = "Try your best...",
	  Русский = "Желаю удачи..."
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local weps1 = {}
    local weps2 = {}
    local weps = weapons.GetList()

    for i = 1, #weps do
      local wep = weps[i]
      if not wep.AutoSpawnable then continue end

      if wep.Kind == WEAPON_HEAVY then
        weps1[#weps1 + 1] = wep
      elseif wep.Kind == WEAPON_PISTOL then
        weps2[#weps2 + 1] = wep
      end
    end

    local plys = player.GetAll()
    for i = 1, #plys do
      local ply = plys[i]
      weps = ply:GetWeapons()
      for j = 1, #weps do
        wep = weps[j]
        if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
          ply:StripWeapon(wep:GetClass())
        end
      end

      local rdm_wep1 = weps1[math.random(#weps1)]
      local rdm_wep2 = weps2[math.random(#weps2)]

      local wep1 = ply:Give(rdm_wep1.ClassName)
      local wep2 = ply:Give(rdm_wep2.ClassName)

      wep1.AllowDrop = false
      wep2.AllowDrop = false
    end
  end

  function MINIGAME:OnDeactivation()

  end
end
