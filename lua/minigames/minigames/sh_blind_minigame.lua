if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_blind_duration = {
    slider = true,
    min = 1,
    max = 60,
    desc = "ttt2_minigames_blind_duration (Def. 30)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Blinded!"
      Русский = "Слепота!"
    },
    desc = {
      English = "The Traitors have been temporarily blinded!"
      Русский = "Предатели временно ослеплены!"
    }
  }
else
  util.AddNetworkString("blind_minigame")
end


if SERVER then
  local ttt2_minigames_blind_duration = CreateConVar("ttt2_minigames_blind_duration", "30", {FCVAR_ARCHIVE}, "Duration of the traitor's blindness")
  function TriggerBlind()
    net.Start("blind_minigame")
    net.WriteBool(true)
    net.Broadcast()

    local duration = ttt2_minigames_blind_duration:GetInt()

    timer.Create("MinigameBlind", duration, 1, function()
      net.Start("blind_minigame")
      net.WriteBool(false)
      net.Broadcast()
    end)
  end

  function RemoveBlind()
    net.Start("blind_minigame")
    net.WriteBool(false)
    net.Broadcast()
  end

  function MINIGAME:OnActivation()
    TriggerBlind()
  end

  function MINIGAME:OnDeactivation()
    RemoveBlind()
  end
end

if CLIENT then
  blind_active = false

  net.Receive("blind_minigame", function()
    if net.ReadBool() then
      blind_active = true
    else
      blind_active = false
    end
  end)

  function BlindPlayer()
    if not blind_active then return end
    local client = LocalPlayer()

    if client:HasTeam(TEAM_TRAITOR) then
      surface.SetDrawColor(0, 0, 0, 255)
      surface.DrawRect(0, 0, ScrW(), ScrH())
    end
  end

  hook.Add("HUDPaint", "BlindMinigame", BlindPlayer)
end
