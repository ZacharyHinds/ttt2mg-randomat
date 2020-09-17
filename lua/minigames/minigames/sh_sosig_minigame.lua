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
    local plys = player.GetAll()
    for i = 1, #plys do
      local weps = plys[i]:GetWeapons()
      for j = 1, #weps do
        weps[j].Primary.Sound = "weapons/sosig.mp3"
      end
    end

    hook.Add("WeaponEquip", "SosigMinigameEquip", function(wep, ply)
      timer.Create("SosigMinigameDelay", 0.1, 1, function()
        net.Start("sosig_trigger")
        net.Send(ply)
        for i = 1, #plys do
          local weps = plys[i]:GetWeapons()
          for j = 1, #weps do
            if not weps[i].Primary then continue end
            weps[j].Primary.Sound = "weapons/sosig.mp3"
          end
        end
      end)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("WeaponEquip", "SosigMinigameEquip")
  end
end

if CLIENT then
  net.Receive("sosig_trigger", function()
    local weps = LocalPlayer():GetWeapons()
    for i = 1, #weps do
      weps[i].Primary.Sound = "weapons/sosig.mp3"
    end
  end)
end
