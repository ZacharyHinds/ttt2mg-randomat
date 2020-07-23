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
    timer.Create("DeafMinigameDelay", 1, 1, function()
      hook.Add("Think", "DeafMinigameThink", function()
        for _, ply in ipairs(player.GetAll()) do
          ply:ConCommand("soundfade 100 1")
        end
      end)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "DeafMinigameThink")
  end
end
