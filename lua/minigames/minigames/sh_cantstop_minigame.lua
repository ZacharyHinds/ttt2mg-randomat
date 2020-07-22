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
    local plys = {}
    for k, ply in ipairs(player.GetAll()) do
      plys[k] = ply
    end

    hook.Add("Think", "CantStopMinigame", function()
      for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() and not ply:IsSpec() then
          ply:ConCommand("+forward")
          if ttt2_minigames_cantstop_disable_back:GetBool() then
            ply:ConCommand("-back")
          end
        else
          ply:ConCommand("-forward")
          plys[_] = nil
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "CantStopMinigame")
    for _, ply in ipairs(player.GetAll()) do
      ply:ConCommand("-forward")
    end
  end
end
