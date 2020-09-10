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
  local plys = player.GetAll()
  function MINIGAME:OnActivation()
    hook.Add("Think", "CantStopMinigame", function()
      for i = 1, #plys do
        local ply = plys[i]
        if ply:Alive() and not ply:IsSpec() then
          ply:ConCommand("+forward")
          if ttt2_minigames_cantstop_disable_back:GetBool() then
            ply:ConCommand("-back")
          end
        else
          ply:ConCommand("-forward")
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "CantStopMinigame")
    for i = 1, #plys do
      plys[i]:ConCommand("-forward")
    end
  end
end
