if SERVER then
  AddCSLuaFile()
end


MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Infinite Ammo!"
    },
    desc = {
      English = "Everyone has infinite ammo!"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("EntityFireBullets", "MinigameAmmo", function(ply, data)
      local wep = ply:GetActiveWeapon()

      if not wep.HasAmmo or not wep:HasAmmo() or not wep.AutoSpawnable or (wep.Kind == WEAPON_EQUIP1 or wep.Kind == WEAPON_EQUIP2) then return end

      wep.inf_clip_old = wep:Clip1()
      wep:SetClip1(wep:GetMaxClip1() + 1)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityFireBullets", "MinigameAmmo")
  end
end
