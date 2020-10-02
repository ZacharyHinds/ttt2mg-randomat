if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_jesters_base_traitor = {
    checkbox = true,
    desc = "ttt2_minigames_jesters_base_traitor (Def. 1)"
  },

  ttt2_minigames_jesters_base_detective = {
    checkbox = true,
    desc = "ttt2_minigames_jesters_base_detective (Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Jesters!",
      Русский = "Шуты!"
    },
    desc = {
      English = "One traitor, One Detective. Everyone else is a jester. Detective is stronger.",
      Русский = "Один предатель, один детектив. Все остальные - шуты. Детектив сильнее."
    }
  }
end

if SERVER then
  local ttt2_minigames_jesters_base_traitor = CreateConVar("ttt2_minigames_jesters_base_traitor", "1", {FCVAR_ARCHIVE}, "Force the sole traitor to be a base traitor")
  local ttt2_minigames_jesters_base_detective = CreateConVar("ttt2_minigames_jesters_base_detective", "1", {FCVAR_ARCHIVE}, "Force the sole traitor to be a base detective")
  function DetectiveCheck()
    local d = 0
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      if plys[i]:GetBaseRole() == ROLE_DETECTIVE then
        d = 1
        return true
      end
    end
    if d > 0 then
      return true
    else
      return false
    end
  end

  function MINIGAME:IsSelectable()
    if JESTER then
      return DetectiveCheck()
    else
      return false
    end
  end

  function MINIGAME:OnActivation()
    if not DetectiveCheck() then
      print("[TTT2][MINIGAMES][sh_jesters_minigame] Error: No Valid Detective!")
      return false
    end
    local tx = 0
    local dx = 0
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]
      if (ply:HasTeam(TEAM_TRAITOR) and tx == 0) or (ply:GetBaseRole() == ROLE_DETECTIVE and dx == 0) then
        if ply:GetBaseRole() ~= ROLE_DETECTIVE then
          if ply:GetSubRole() ~= ROLE_TRAITOR and ttt2_minigames_jesters_base_traitor:GetBool() then ply:SetRole(ROLE_TRAITOR) end
          tx = 1
        else
          if ply:GetSubRole() ~= ROLE_DETECTIVE and ttt2_minigames_jesters_base_detective:GetBool() then ply:SetRole(ROLE_DETECTIVE) end
          dx = 1
          ply:SetHealth(200)
          ply:SetMaxHealth(200)
        end
      else
        ply:SetRole(ROLE_JESTER)
      end
    end
    SendFullStateUpdate()
  end

  function MINIGAME:OnDeactivation()

  end

end
