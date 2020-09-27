if SERVER then
  AddCSLuaFile()
end


MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Infinite Ammo!"
      Русский = "Бесконечные патроны!"
    },
    desc = {
      English = "Everyone has infinite ammo!"
      Русский = "У всех бесконечные патроны!"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    if items.GetStored("item_ttt_infinishoot") then
      local plys = util.GetAlivePlayers()
      for i = 1, #plys do
        plys[i]:GiveEquipmentItem("item_ttt_infinishoot")
      end
    else
      hook.Add("EntityFireBullets", "MinigameAmmo", function(ply, data)
        if not IsValid(ply) or not ply:IsPlayer() then return end
        local wep = ply:GetActiveWeapon()

        if not wep.HasAmmo or not wep:HasAmmo() or not wep.AutoSpawnable or (wep.Kind == WEAPON_EQUIP1 or wep.Kind == WEAPON_EQUIP2) then return end

        wep.inf_clip_old = wep:Clip1()
        wep:SetClip1(wep:GetMaxClip1() + 1)
      end)
    end
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityFireBullets", "MinigameAmmo")
  end
end
