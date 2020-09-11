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
    local plys = player.GetAll()
    timer.Create("DeafMinigameDelay", 1, 1, function()
      hook.Add("Think", "DeafMinigameThink", function()
        for i = 1, #plys do
          plys[i]:ConCommand("soundfade 100 1")
        end
      end)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "DeafMinigameThink")
  end
end
