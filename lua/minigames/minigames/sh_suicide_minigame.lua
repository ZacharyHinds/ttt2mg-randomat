if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Detonators",
      Русский = "Детонаторы"
    },
    desc = {
      English = "So that's it. What, we some kind of suicide squad?",
      Русский = "Так вот оно. Что, мы какой-то отряд самоубийц?"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plysize = 0

    plylist = {}

    for _, ply in ipairs(player.GetAll()) do
      if not ply:Alive() or ply:IsSpec() then continue end

      plysize = plysize + 1

      plylist[plysize] = {}
      plylist[plysize]["ply"] = ply
      plylist[plysize]["tgt"] = ply
    end

    for k, _ in pairs (plylist) do

      if plysize > 1 and k < plysize then
        plylist[k]["tgt"] = plylist[k + 1]["ply"]
      elseif plysize > 1 then
        plylist[k]["tgt"] = plylist[1]["ply"]
      end

      timer.Create("DetMinigameTimer", 12, 1, function()
          plylist[k]["ply"]:PrintMessage(HUD_PRINTCENTER, "You have a detonator for " .. plylist[k]["tgt"]:Nick())
      end)

      plylist[k]["ply"]:PrintMessage(HUD_PRINTTALK, "You have a detonator for " .. plylist[k]["tgt"]:Nick())

      for i, wep in ipairs(plylist[k]["ply"]:GetWeapons()) do
        if wep.Kind == WEAPON_EQUIP2 then
          plylist[k]["ply"]:StripWeapon(wep:GetClass())
        end
      end

      plylist[k]["ply"]:Give("weapon_ttt_minigames_detonator")
      plylist[k]["ply"]:GetWeapon("weapon_ttt_minigames_detonator").Target = plylist[k]["tgt"]

    end
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("DetMinigameTimer")
  end
end
