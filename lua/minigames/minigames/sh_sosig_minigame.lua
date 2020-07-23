if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Sosig."
    },
    desc = {
      English = "Sosig"
    }
  }
else
  util.AddNetworkString("sosig_trigger")
end

if SERVER then
  function MINIGAME:OnActivation()
    net.Start("sosig_trigger")
    net.Broadcast()

    for k, ply in ipairs(player.GetAll()) do
      for _, wep in ipairs(ply:GetWeapons()) do
        wep.Primary.Sound = "weapons/sosig.mp3"
      end
    end

    hook.Add("WeaponEquip", "SosigMinigameEquip", function(wep, ply)
      timer.Create("SosigMinigameDelay", 0.1, 1, function()
        net.Start("sosig_trigger")
        net.Send(ply)
        for k, ply in ipairs(player.GetAll()) do
          for _, wep in ipairs(ply:GetWeapons()) do
            wep.Primary.Sound = "weapons/sosig.mp3"
          end
        end
      end)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("WeaponEquip", "SosigMinigameEquip")
  end
end
