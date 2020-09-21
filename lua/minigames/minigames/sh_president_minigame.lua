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
    desc = "ttt2_minigames_president_bonushp (Def. 100)"
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
end

if SERVER then
  local ttt2_minigames_president_bonushp = CreateConVar("ttt2_minigames_president_bonushp", "100", {FCVAR_ARCHIVE}, "Extra health gained by the detective")
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    local pres = nil
    for i = 1, #plys do
      if plys[i]:GetBaseRole() == ROLE_DETECTIVE and not pres then
        pres = plys[i]
      end
    end
    if not pres then return end

    pres:SetMaxHealth(100 + ttt2_minigames_president_bonushp:GetInt())
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

  function MINIGAME:IsSelectable()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      if plys[i]:GetBaseRole() == ROLE_DETECTIVE then return true end
    end
    return false
  end
end
