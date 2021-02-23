if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_harpoon_timer = {
    slider = true,
    min = 1,
    max = 30,
    desc = "ttt2_minigames_harpoon_timer (Def. 3)"
  },

  ttt2_minigames_harpoon_strip = {
    checkbox = true,
    desc = "ttt2_minigames_harpoon_strip (Def. 1)"
  },
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Harpooooooooooon!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  local ttt2_minigames_harpoon_timer = CreateConVar("ttt2_minigames_harpoon_timer", "3", {FCVAR_ARCHIVE}, "Delay between being given harpoons")
  local ttt2_minigames_harpoon_strip = CreateConVar("ttt2_minigames_harpoon_strip", "1", {FCVAR_ARCHIVE}, "Should the minigame strip other weapons")
  local ttt2_minigames_harpoon_weaponid = CreateConVar("ttt2_minigames_harpoon_weaponid", "ttt_m9k_harpoon", {FCVAR_ARCHIVE}, "Should the minigame strip other weapons")
  function MINIGAME:OnActivation()
    local harpoon_class = ttt2_minigames_harpoon_weaponid:GetString()
    timer.Create("HarpoonMinigame", ttt2_minigames_harpoon_timer:GetInt(), 0, function ()
      if GetRoundState() ~= ROUND_ACTIVE then timer.Remove("HarpoonMinigame") return end
      local plys = player.GetAll()
      for i = 1, #plys do
        local ply = plys[i]
        if not ply:Alive() or ply:IsSpec() then continue end

        local weps = ply:GetWeapons()
        if #weps ~= 1 or (#weps == 1 and ply:GetActiveWeapon():GetClass() ~= harpoon_class) then
          if ttt2_minigames_harpoon_strip:GetBool() then ply:StripWeapons() end
          ply:Give(harpoon_class)
        end

      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("HarpoonMinigame")
  end

  function MINIGAME:IsSelectable()
    if not WEPS.IsInstalled(ttt2_minigames_harpoon_weaponid:GetString()) then
      return false
    else
      return true
    end
  end
end
