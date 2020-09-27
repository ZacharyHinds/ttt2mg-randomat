if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Wallhack!"
      Русский = "Видение сквозь стены!"
    },
    desc = {
      English = "None can hide from my sight!"
      Русский = "Никто не сможет спрятаться от меня!"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()

  end

  function MINIGAME:OnDeactivation()

  end
end

if CLIENT then
  function MINIGAME:OnActivation()
    hook.Add("PostDrawOpaqueRenderables", "WallhackMinigameDraw", function()
      local client = LocalPlayer()

      if client:HasEquipmentItem("item_ttt_tracker") then return end

      local ang = client:EyeAngles()
      local pos = client:EyePos() + ang:Forward() * 10

      ang = Angle(ang.p + 90, ang.y, 0)

      render.ClearStencil()
      render.SetStencilEnable(true)
      render.SetStencilWriteMask(255)
      render.SetStencilTestMask(255)
      render.SetStencilReferenceValue(15)
      render.SetStencilFailOperation(STENCILOPERATION_KEEP)
      render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
      render.SetStencilPassOperation(STENCILOPERATION_KEEP)
      render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
      render.SetBlend(0)

      local ents = player.GetAll()

      for _, ply in ipairs(ents) do
        if ply:IsActive() then
          ply:DrawModel()
        end
      end

      render.SetBlend(1)
      render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

      cam.Start3D2D(pos, ang, 1)

      surface.SetDrawColor(255, 50, 50)
      surface.DrawRect( -ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)

      cam.End3D2D()

      for _, ply in ipairs(ents) do
        if ply:IsActive() then
          ply:DrawModel()
        end
      end

      render.SetStencilEnable(false)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostDrawOpaqueRenderables", "WallhackMinigameDraw")
  end
end
