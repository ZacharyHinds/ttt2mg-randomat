if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Sudden Death!"
    },
    desc = {
      English = ""
    }
  }
else

end

if SERVER then
  function MINIGAME:OnActivation()
    timer.Create("SuddenDeathMinigame", 1, 0, function()
      for _, ply in ipairs(player.GetAll()) do
        if not ply:Alive() or ply:IsSpec() then continue end

        ply:SetHealth(1)
        ply:SetMaxHealth(1)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("SuddenDeathMinigame")
  end
end
