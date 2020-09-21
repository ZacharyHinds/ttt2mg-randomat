if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_grave_health = {
    slider = true,
    min = 1,
    max = 100,
    desc = "ttt2_minigames_grave_health (Def. 30)"
  },

  ttt2_minigames_grave_delay = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2_minigames_grave_delay (Def. 3)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "RISE FROM YOUR GRAVE!"
    },
    desc = {
      English = "The dead will return as Infected!"
    }
  }
end

if SERVER then
  local ttt2_minigames_grave_health = CreateConVar("ttt2_minigames_grave_health", "30", {FCVAR_ARCHIVE}, "Health of Infected respawned")
  local ttt2_minigames_grave_delay = CreateConVar("ttt2_minigames_grave_delay", "3", {FCVAR_ARCHIVE}, "Respawn delay for minigame")
  function MINIGAME:OnActivation()
    hook.Add("PostPlayerDeath", "GraveMinigame", function(ply)
      if ply.RisenForRound == true then return end
      -- local revivalreason = LANG.TryTranslation("ttt2_minigames_" .. self.name .. "_name")

      ply:Revive(
        ttt2_minigames_grave_delay:GetInt(),
        function()
          ply:SetRole(ROLE_INFECTED)
          ply:SetHealth(ttt2_minigames_grave_health:GetInt())
          ply:SetMaxHealth(ttt2_minigames_grave_health:GetInt())
          ply.RisenForRound = true
          SendFullStateUpdate()
        end,
        nil,
        true,
        false
      )
      ply:SendRevivalReason("ttt2_minigames_" .. self.name .. "_name")
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostPlayerDeath", "GraveMinigame")
  end

  function MINIGAME:IsSelectable()
    if not INFECTED then
      return false
    else
      return true
    end
  end
end
