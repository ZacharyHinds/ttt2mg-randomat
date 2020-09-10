if SERVER then
  AddCSLuaFile()
  include("minigames/engine/sh_functions.lua")
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_randomxn_count = {
    slider = true,
    min = 1,
    max = 20,
    desc = "(Def. 5)"
  }
}

ttt2_minigames_randomxn_count = CreateConVar("ttt2_minigames_randomxn_count", "5", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Number of games to activate")

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Multigame"
    },
    desc = {
      English = "Random x" .. ttt2_minigames_randomxn_count:GetInt()
    }
  }
end

if SERVER then
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
    timer.Create("RandomxnMinigame", 12.5, ttt2_minigames_randomxn_count:GetInt(), function()
      local minigame = self:SelectGame()
      if not minigame then return end

      ActivateMinigame(minigame)
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("RandomxnMinigame")
  end

end
