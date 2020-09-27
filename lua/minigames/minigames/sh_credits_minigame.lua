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
    desc = "ttt2_minigames_credits_count (Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Infinite Credits for Everyone!"
      Русский = "Бесконечные кредиты для всех!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  local ttt2_minigames_credits_count = CreateConVar("ttt2_minigames_credits_count", "1", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  function MINIGAME:OnActivation()
    local plys = player.GetAll()
    timer.Create("CreditsMinigame", 0, 0, function()
      for i = 1, #plys do
        plys[i]:SetCredits(ttt2_minigames_credits_count:GetInt())
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("CreditsMinigame")
  end
end
