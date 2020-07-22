if SERVER then
  AddCSLuaFile()
end


MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_ammo_buymenu = {
    checkbox = true,
    desc = "Affects buy menu weapons (Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Infinite Ammo!"
    },
    desc = {
      English = "Everyone has infinite ammo!"
    }
  }
else
  CreateConVar("ttt2_minigames_ammo_buymenu", "0", {FCVAR_ARCHIVE}, "Infinite ammo for buy menu weapons")
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("EntityFireBullets", "MinigameAmmo", function(ply, data)
      local wep = ply:GetActiveWeapon()

      if not wep.HasAmmo or not wep:HasAmmo() then return end

      if not GetConVar("ttt2_minigames_ammo_buymenu"):GetBool() and not (wep.Kind == WEAPON_EQUIP1 or wep.Kind == WEAPON_EQUIP2) then return end

      wep.inf_clip_old = wep:Clip1()
      wep:SetClip1(wep:GetMaxClip1() + 1)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityFireBullets", "MinigameAmmo")
    -- for _, ply in ipairs(player.GetAll()) do
    --   ply:GetActiveWeapon().inf_clip_old = ply:GetActiveWeapon()
  end
end
