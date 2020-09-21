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
    desc = "ttt2_minigames_gungame_timer (Def. 5)"
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
end

if SERVER then
  local ttt2_minigames_gungame_timer = CreateConVar("ttt2_minigames_gungame_timer", "5", {FCVAR_ARCHIVE}, "Time between weapon changes")
  function MINIGAME:OnActivation()
    local ents = ents.GetAll()
    local weps = weapons.GetList()
    local gungame_weps = {}

    for i = 1, #ents do
      local ent = ents[i]
      if ent.Base == "weapon_tttbase" and ent.AutoSpawnable then
        ent:Remove()
      end
    end

    for i = 1, #weps do
      local wep = weps[i]
      if wep.AutoSpawnable and (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) then
        gungame_weps[#gungame_weps + 1] = wep
      end
    end

    timer.Create("GunGameMinigame", ttt2_minigames_gungame_timer:GetInt(), 0, function()
      if GetRoundState() ~= ROUND_ACTIVE then timer.Remove("GunGameMinigame") return end
      local plys = util.GetAlivePlayers()
      for i = 1, #plys do
        local ply = plys[i]
        local ac = false
        if ply:GetActiveWeapon().Kind == WEAPON_HEAVY or ply:GetActiveWeapon().Kind == WEAPON_PISTOL then
          ac = true
        end

        weps = ply:GetWeapons()

        for j = 1, #weps do
          local wep = weps[j]
          if wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL then
            ply:StripWeapon(wep.ClassName)
          end
        end

        local wepGiven = gungame_weps[math.random(#gungame_weps)]
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
