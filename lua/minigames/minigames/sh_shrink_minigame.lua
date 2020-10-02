if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_shrink_scale = {
    slider = true,
    min = 0,
    max = 1,
    decimal = 1,
    desc = "ttt2_minigames_shrink_scale (Def. 0.5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Shrunked",
      Русский = "Сжатие"
    },
    desc = {
      English = "Honey, I shrunk the terrorists!",
      Русский = "Дорогая, я уменьшил террористов!"
    }
  }
end

if SERVER then
  local ttt2_minigames_shrink_scale = CreateConVar("ttt2_minigames_shrink_scale", "0.5", {FCVAR_ARCHIVE}, "Shrinking scale factor")
  local rat = ttt2_minigames_shrink_scale:GetFloat()
  function MINIGAME:OnActivation()
    local scal = ttt2_minigames_shrink_scale:GetFloat()
    local plys = player.GetAll()

    for i = 1, #plys do
      local ply = plys[i]
      if ply:IsSpec() or not ply:Alive() then continue end

      ply:SetStepSize(ply:GetStepSize() * scal, 1)
      ply:SetModelScale(ply:GetModelScale() * scal, 1)
      ply:SetViewOffset(ply:GetViewOffset() * scal)
      ply:SetViewOffsetDucked(ply:GetViewOffsetDucked() * scal)
      local a, b = ply:GetHull()
      ply:SetHull(a * scal, b * scal)
      a, b = ply:GetHullDuck()
      ply:SetHullDuck(a * scal, b * scal)
      rat = ply:GetStepSize() / 18
      ply:SetHealth(math.floor(rat * 100))
      hook.Add("TTTPlayerSpeed", "ShrinkMinigameSpeed", function()
        return math.Clamp(ply:GetStepSize() / 9, 0.25, 1)
      end)
    end

    timer.Create("ShrinkMinigameHP", 1, 0, function()
      for i = 1, #plys do
        local ply = plys[i]
        if not ply:Alive() or ply:IsSpec() then continue end

        rat = ply:GetStepSize() / 18
        if ply:Health() > math.floor(rat * 100) then
          ply:SetHealth(math.floor(rat * 100))
        end
        ply:SetMaxHealth(math.floor(rat * 100))
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTTPlayerSpeed", "ShrinkMinigameSpeed")
    local plys = player.GetAll()
    for i = 1, #plys do
      local ply = plys[i]
      ply:SetModelScale(1, 1)
      ply:SetViewOffset(Vector(0, 0, 64))
      ply:SetViewOffsetDucked(Vector(0, 0, 32))
      ply:ResetHull()
      ply:SetStepSize(18)
      timer.Remove("ShrinkMinigameHP")
    end
  end
end
