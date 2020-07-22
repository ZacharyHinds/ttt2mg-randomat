if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_credits_count = {
    slider = true,
    min = 1,
    max = 10,
    desc = "(Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Infinite Credits for Everyone!"
    },
    desc = {
      English = ""
    }
  }
else
  ttt2_minigames_credits_count = CreateConVar("ttt2_minigames_credits_count", "1", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
end

if SERVER then
  function MINIGAME:OnActivation()
    timer.Create("CreditsMinigame", 0, 0, function()
      for _, ply in ipairs(player.GetAll()) do
        ply:SetCredits(ttt2_minigames_credits_count:GetInt())
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("CreditsMinigame")
  end
end
