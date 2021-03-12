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

  ttt2_minigames_harpoon_strip_avoid = {
    checkbox = true,
    desc = "ttt2_minigames_harpoon_strip_avoid"
  }
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
  local ttt2_minigames_harpoon_strip_avoid = CreateConVar("ttt2_minigames_harpoon_strip_avoid", "1", {FCVAR_ARCHIVE}, "Limit weapon strip to guns/traitor equipment")
  local ttt2_minigames_harpoon_weaponid = CreateConVar("ttt2_minigames_harpoon_weaponid", "ttt_m9k_harpoon", {FCVAR_ARCHIVE}, "Should the minigame strip other weapons")

  local function BetterWeaponStrip(ply, exclude_class)
    if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
    if not ttt2_minigames_harpoon_strip_avoid:GetBool() then ply:StripWeapons() return end
    local dbg = table.GetKeys(exclude_class)
    -- for i = 1, #dbg do
    --   if exclude_class[dbg[i]] then
    --     print("[TTT2MG Harpoon] Excluding class: " .. dbg[i] .. "| true")
    --   end
    -- end
    local weps = ply:GetWeapons()
    for i = 1, #weps do
      local wep = weps[i]
      local wep_class = wep:GetClass()
      if (wep.Kind == WEAPON_EQUIP or wep.Kind == WEAPON_EQUIP2 or wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL) and not exclude_class[wep_class] then
        ply:StripWeapon(wep_class)
      end
    end
  end

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
          local exclude_tbl = {}
          exclude_tbl[harpoon_class] = true
          if ttt2_minigames_harpoon_strip:GetBool() then BetterWeaponStrip(ply, exclude_tbl) end
          if ply:HasWeapon(harpoon_class) then continue end
          ply:Give(harpoon_class)
          ply:SelectWeapon(harpoon_class)
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
