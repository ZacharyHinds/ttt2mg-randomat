if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Shh... It's a Secret",
      Русский = "Шшш... это секрет"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]

      if ply:GetBaseRole() == ROLE_INNOCENT then
        ply:SetRole(ROLE_SPY)
      end
    end
    SendFullStateUpdate()
  end

  function MINIGAME:OnDeactivation()

  end

  function MINIGAME:IsSelectable()
    if not SPY then
      return false
    else
      return true
    end
  end
end
