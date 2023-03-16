if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_detonators_announce = {
    combobox = true,
    choices = {
      "0 - No Announcement",
      "1 - Announce when someone is detonated",
      "2 - Announce who detonated who"
    },
    desc = "ttt2_minigames_detonators_announce (Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Detonators"
    },
    desc = {
      English = "So that's it. What, we some kind of suicide squad?"
    }
  }
end

if SERVER then
  util.AddNetworkString("det_announce_epop")
  CreateConVar("ttt2_minigames_detonators_announce", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "0: Don't Announce; 1: Announce someone detonated; 2: Announce who detonated who")
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

      -- for i, wep in ipairs(plylist[k]["ply"]:GetWeapons()) do
      --   if wep.Kind == WEAPON_EQUIP2 then
      --     plylist[k]["ply"]:StripWeapon(wep:GetClass())
      --   end
      -- end

      plylist[k]["ply"]:Give("weapon_ttt_minigames_detonator")
      plylist[k]["ply"]:GetWeapon("weapon_ttt_minigames_detonator").Target = (plylist[k]["tgt"])
      plylist[k]["ply"]:GetWeapon("weapon_ttt_minigames_detonator"):SetDetTarget(plylist[k]["tgt"])

    end
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("DetMinigameTimer")
  end
end

if CLIENT then
  net.Receive("det_announce_epop", function()
    owner_nick = net.ReadString()
    victim_nick = net.ReadString()
    announce_mode = net.ReadInt(3)
    if announce_mode == 0 then
      return 
    elseif announce_mode == 1 then
      EPOP:AddMessage({
        text = LANG.GetParamTranslation("ttt2mg_randomat_detonator_announce_1", {victim = victim_nick}),
        color = COLOR_ORANGE,
        nil,
        4,
        nil,
        true
      })
    else
      EPOP:AddMessage({
        text = LANG.GetParamTranslation("ttt2mg_randomat_detonator_announce_2", {attacker = owner_nick, victim = victim_nick}),
        color = COLOR_ORANGE,
        nil,
        4,
        nil,
        true
      })
    end
  end)
end
