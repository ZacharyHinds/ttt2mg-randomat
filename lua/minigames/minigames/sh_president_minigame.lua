if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_president_bonushp = {
    slider = true,
    min = 1,
    max = 200,
    desc = "(Def. 100)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Get Down Mr. President!"
    },
    desc = {
      English = ""
    }
  }
else
  ttt2_minigames_president_bonushp = CreateConVar("ttt2_minigames_president_bonushp", "100", {FCVAR_ARCHIVE}, "Extra health gained by the detective")
end

if SERVER then
  function MINIGAME:OnActivation()
    local d = 0
    local pres
    for _, ply in pairs(player.GetAll()) do
      if not ply:Alive() or d == 1 then continue end

      if ply:GetBaseRole() == ROLE_DETECTIVE then
        d = 1
        pres = ply
      end
    end
    if not pres then
      for _, ply in RandomPairs(player.GetAll()) do
        if pres then continue end
        if ply:Alive() and not ply:IsSpec() and ply:HasTeam(TEAM_INNOCENT) then ply:SetRole(ROLE_DETECTIVE)
          SendFullStateUpdate()
          pres = ply
        end
      end
    end

    if not pres then return false end

    pres:SetMaxHealth(ttt2_minigames_president_bonushp:GetInt())
    pres:SetHealth(pres:GetMaxHealth())

    hook.Add("PostPlayerDeath", "PresidentMinigame", function(ply)
      if ply == pres then
        for _, pl in ipairs(player.GetAll()) do
          if not pl:Alive() or pl:IsSpec() then continue end

          if pl:HasTeam(pres:GetTeam()) then pl:Kill() end
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostPlayerDeath", "PresidentMinigame")
  end
end
