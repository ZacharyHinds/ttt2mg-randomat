if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_suspicion_jst_chance = {
    slider = true,
    min = 0,
    max = 100,
    desc = "(Def. 50)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Suspicion!"
    },
    desc = {
      English = ""
    }
  }
else
  util.AddNetworkString("suspicion_minigame_popup")
end

if SERVER then
  local ttt2_minigames_suspicion_jst_chance = CreateConVar("ttt2_minigames_suspicion_jst_chance", "50", {FCVAR_ARCHIVE}, "Chance of changing player to jester")
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    table.Shuffle(plys)
    local suspicion_ply = plys[math.random(#plys)]

    while not suspicion_ply:Alive() or suspicion_ply:IsSpec() or suspicion_ply:GetBaseRole() == ROLE_DETECTIVE do
      suspicion_ply = plys[math]
    end

    if not suspicion_ply:IsPlayer() then return end

    if math.random(1, 100) <= ttt2_minigames_suspicion_jst_chance:GetInt() then
      suspicion_ply:SetRole(ROLE_JESTER)
    elseif suspicion_ply:GetBaseRole() ~= ROLE_TRAITOR then
      suspicion_ply:SetRole(ROLE_TRAITOR)
    end
    SendFullStateUpdate()
    timer.Simple(0.1, function()
      net.Start("suspicion_minigame_popup")
      net.WriteEntity(suspicion_ply)
      net.Broadcast()
    end)
  end

  function MINIGAME:OnDeactivation()

  end
end

if CLIENT then
  net.Receive("suspicion_minigame_popup", function()
    local ply = net.ReadEntity()
    local client = LocalPlayer()

    if client:HasTeam(TEAM_TRAITOR) then
      if ply:GetSubRole() == ROLE_TRAITOR then
        EPOP:AddMessage({
          text = ply:Nick() .. " is a traitor",
          color = COLOR_RED
          },
          "",
          4
        )
        client:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " is a traitor")
      elseif ply:GetSubRole() == ROLE_JESTER then
        EPOP:AddMessage(
          {text = ply:Nick() .. " is a jester",
          color = JESTER.ltcolor},
          "",
          4
        )
        client:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " is a jester")
      end
    else
      EPOP:AddMessage(
        {text = ply:Nick() .. " seems suspicious...",
        color = COLOR_ORANGE},
        "",
        4
      )
      client:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " seems suspicious")
    end
  end)
end
