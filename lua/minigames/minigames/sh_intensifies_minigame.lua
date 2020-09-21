if SERVER then
  AddCSLuaFile()
  include("minigames/engine/sh_functions.lua")
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_intensifies_timer = {
    slider = true,
    min = 1,
    max = 60,
    desc = "(Def. 20)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Randomness Intensifies"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  local ttt2_minigames_intensifies_timer = CreateConVar("ttt2_minigames_intensifies_timer", "20", {FCVAR_ARCHIVE}, "How often should a new game be activated")

  function MINIGAME:OnActivation()
    timer.Create("IntensifiesMinigame", ttt2_minigames_intensifies_timer:GetInt(), 0, function()
      local minigame = minigames.Select()
      if not minigame then return end

      ActivateMinigame(minigame)
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("IntensifiesMinigame")
  end

end
