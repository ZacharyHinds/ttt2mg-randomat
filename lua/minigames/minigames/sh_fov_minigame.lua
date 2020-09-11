if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_fov_scale = {
    slider = true,
    min = 0,
    max = 3,
    decimal = 1,
    desc = "(Def. 1.5)"
  }
}


if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Quake Pro"
    },
    desc = {
      English = ""
    }
  }
else
  ttt2_minigames_fov_scale = CreateConVar("ttt2_minigames_fov_scale", "1.5", {FCVAR_ARCHIVE}, "Scale of fov increase")
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    local changed_fov = {}

    for i = 1, #plys do
      local ply = plys[i]
      changed_fov[ply] = ply:GetFOV() * ttt2_minigames_fov_scale:GetFloat()
    end

    timer.Create("FOVMinigame", 0.1, 0, function()
      for i = 1, #plys do
        local ply = plys[i]
        if not IsValid(ply) then continue end
        if ply:Alive() and not ply:IsSpec() then
          ply:SetFOV(changed_fov[ply], 0)
        else
          ply:SetFOV(0, 0)
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("FOVMinigame")
    if not starting_plys then return end
    for _, ply in pairs(starting_plys) do
      ply:SetFOV(0, 0)
    end
  end
end
