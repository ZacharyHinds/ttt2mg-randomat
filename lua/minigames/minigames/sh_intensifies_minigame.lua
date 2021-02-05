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
    desc = "ttt2_minigames_intensifies_timer (Def. 20)"
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
  local active_mgs = {}

  function MINIGAME:OnActivation()
    timer.Create("IntensifiesMinigame", ttt2_minigames_intensifies_timer:GetInt(), 0, function()
      local minigame = minigames.Select()
      if not minigame then return end

      ActivateMinigame(minigame)
      active_mgs[#active_mgs + 1] = minigame
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("IntensifiesMinigame")
    for i = 1, #active_mgs do
      DeactivateMinigame(active_mgs[i])
    end
    active_mgs = {}
  end

end
