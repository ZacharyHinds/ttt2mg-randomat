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
  function MINIGAME:SelectGame()
    local mgs = minigames.GetList()

    if #mgs == 0 then return end

    local availableMinigames = {}
    local forcedNextMinigame = minigames.GetForcedNextMinigame()

    for i = 1, #mgs do
      local minigame = mgs[i]

      if not GetConVar("ttt2_minigames_" .. minigame.name .. "_enabled"):GetBool() or not minigame:IsSelectable() then continue end

      if forcedNextMinigame and forcedNextMinigame.name == minigame.name then
        forcedNextMinigame = nil
        return minigame
      end

      local b = true

      local r = GetConVar("ttt2_minigames_" .. minigame.name .. "_random"):GetInt()

      if r > 0 and r < 100 then
        b = math.random(100) <= r
      elseif r <= 0 then
        b = false
      end

      if b then
        availableMinigames[#availableMinigames + 1] = minigame
      end
    end

    if #availableMinigames == 0 then return end

    return availableMinigames[math.random(#availableMinigames)]
  end

  function MINIGAME:OnActivation()
    timer.Create("IntensifiesMinigame", ttt2_minigames_intensifies_timer:GetInt(), 0, function()
      local minigame = self:SelectGame()
      if not minigame then return end

      ActivateMinigame(minigame)
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("IntensifiesMinigame")
  end

end
