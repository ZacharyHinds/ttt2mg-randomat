if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Sudden Death!",
      Русский = "Внезапная смерть!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    timer.Create("SuddenDeathMinigame", 1, 0, function()
      for i = 1, #plys do
        plys[i]:SetHealth(1)
        plys[i]:SetMaxHealth(1)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("SuddenDeathMinigame")
  end
end
