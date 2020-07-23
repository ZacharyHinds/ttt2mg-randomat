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
    desc = "(Def. 3)"
  },

  ttt2_minigames_harpoon_strip = {
    checkbox = true,
    desc = "(Def. 1)"
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
else
  ttt2_minigames_harpoon_timer = CreateConVar("ttt2_minigames_harpoon_timer", "3", {FCVAR_ARCHIVE}, "Delay between being given harpoons")
  ttt2_minigames_harpoon_strip = CreateConVar("ttt2_minigames_harpoon_strip", "1", {FCVAR_ARCHIVE}, "Should the minigame strip other weapons")
  ttt2_minigames_harpoon_weaponid = CreateConVar("ttt2_minigames_harpoon_strip", "ttt_m9k_harpoon", {FCVAR_ARCHIVE}, "Should the minigame strip other weapons")
end

if SERVER then
  function MINIGAME:OnActivation()
    timer.Create("HarpoonMinigame", ttt2_minigames_harpoon_timer:GetInt(), 0, function ()
      for _, ply in ipairs(player.GetAll()) do
        if not ply:Alive() or ply:IsSpec() then continue end

        if table.Count(ply:GetWeapons()) ~= 1 or (table.Count(ply:GetWeapons()) == 1 and ply:GetActiveWeapon():GetClass() ~= ttt2_minigames_harpoon_weaponid:GetString()) then
          if ttt2_minigames_harpoon_strip:GetBool() then ply:StripWeapons() end
          ply:Give("ttt_m9k_harpoon")
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("HarpoonMinigame")
  end
end
