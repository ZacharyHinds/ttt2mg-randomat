if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_cantstop_disable_back = {
    checkbox = true,
    desc = "(Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Can't Stop!"
    },
    desc = {
      English = "Won't Stop!"
    }
  }
else
  ttt2_minigames_cantstop_disable_back = CreateConVar("ttt2_minigames_cantstop_disable_back", "1", {FCVAR_ARCHIVE}, "Disable the \"s\" key")
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("Think", "CantStopMinigame", function()
      local plys = player.GetAll()
      for i = 1, #plys do
        local ply = plys[i]
        if ply:Alive() and not ply:IsSpec() then
          ply:ConCommand("+forward")
          if ttt2_minigames_cantstop_disable_back:GetBool() then
            ply:ConCommand("-back")
          end
        elseif not ply.MgExcept then
          ply:ConCommand("-forward")
          ply.MgExcept = true
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "CantStopMinigame")
    local plys = player.GetAll()
    for i = 1, #plys do
      plys[i]:ConCommand("-forward")
      ply.MgExcept = nil
    end
  end
end
