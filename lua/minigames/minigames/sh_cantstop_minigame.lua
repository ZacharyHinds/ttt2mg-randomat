if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_cantstop_disable_back = {
    checkbox = true,
    desc = "ttt2_minigames_cantstop_disable_back (Def. 1)"
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
end

if SERVER then
  local ttt2_minigames_cantstop_disable_back = CreateConVar("ttt2_minigames_cantstop_disable_back", "1", {FCVAR_ARCHIVE}, "Disable the \"s\" key")
  function MINIGAME:OnActivation()
    hook.Add("Think", "CantStopMinigame", function()
      if GetRoundState() == ROUND_ACTIVE then
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
      else
        local plys = player.GetAll()
        for i = 1, #plys do
          local ply = plys[i]
          ply:ConCommand("-forward")
          ply.MgExcept = nil
        end
        hook.Remove("Think", "CantStopMinigame")
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "CantStopMinigame")
    local plys = player.GetAll()
    for i = 1, #plys do
      plys[i]:ConCommand("-forward")
      plys[i].MgExcept = nil
    end
  end
end
