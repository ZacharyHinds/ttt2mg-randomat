if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "SHUT UP!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("TTT2CanUseVoiceChat", "DeafMinigameAvoidVoice", function(ply, isTeam)
        if IsValid(ply) then
            return false
        end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTT2CanUseVoiceChat", "DeafMinigameAvoidVoice")
  end
end
