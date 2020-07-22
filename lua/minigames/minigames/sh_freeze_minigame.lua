if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_freeze_duration = {
    slider = true,
    min = 1,
    max = 10,
    desc = "(Def. 5)"
  },

  ttt2_minigames_freeze_timer = {
    slider = true,
    min = 1,
    max = 60,
    desc = "(Def. 30)"
  }
}

ttt2_minigames_freeze_timer = CreateConVar("ttt2_minigames_freeze_timer", "30", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Duration of Freeze")

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Freeze!"
    },
    desc = {
      English = "All Innocents will freeze (and become immune) every " .. ttt2_minigames_freeze_timer:GetInt() .. " seconds"
    }
  }
else
  ttt2_minigames_freeze_duration = CreateConVar("ttt2_minigames_freeze_duration", "5", {FCVAR_ARCHIVE}, "Delay between freezes")
  util.AddNetworkString("freeze_minigame_popup")
end

if SERVER then
  function MINIGAME:OnActivation()
    timer.Create("FreezeMinigame", ttt2_minigames_freeze_timer:GetInt(), 0, function()
      net.Start("freeze_minigame_popup")
      net.Broadcast()

      for _, ply in ipairs(player.GetAll()) do
        if not ply:Alive() or ply:IsSpec() or not ply:HasTeam(TEAM_INNOCENT) then continue end

        ply:Freeze(true)
        ply.isFrozen = true
        timer.Simple(ttt2_minigames_freeze_duration:GetInt(), function()
          ply:Freeze(false)
          ply.isFrozen = false
        end)
      end
    end)

    hook.Add("EntityTakeDamage", "FreezeMinigameImmunity", function(ply, dmg)
      if ply:IsValid() and ply.isFrozen then
        dmg:ScaleDamage(0)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityTakeDamage", "FreezeMinigameImmunity")
    timer.Remove("FreezeMinigame")
  end
end

if CLIENT then
  net.Receive("freeze_minigame_popup", function()
    EPOP:AddMessage({
      text = "Freeze!",
      color = Color(19, 159, 235, 255)},
      "",
      1
    )
  end)
end
