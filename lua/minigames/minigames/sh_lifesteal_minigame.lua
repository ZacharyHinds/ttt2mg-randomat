if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_lifesteal_health = {
    slider = true,
    min = 1,
    max = 100,
    desc = "(Def. 25)"
  },

  ttt2_minigames_lifesteal_cap = {
    slider = true,
    min = 0,
    max = 300,
    desc = "(Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Lifesteal"
    },
    desc = {
      English = "Gain life for killing people... Is it worth it?"
    }
  }
end

if SERVER then
  local ttt2_minigames_lifesteal_health = CreateConVar("ttt2_minigames_lifesteal_health", "25", {FCVAR_ARCHIVE}, "Health gained per kill")
  local ttt2_minigames_lifesteal_cap = CreateConVar("ttt2_minigames_lifesteal_cap", "0", {FCVAR_ARCHIVE}, "Max health from event (0 to disable)")
  function MINIGAME:OnActivation()
    hook.Add("TTT2PostPlayerDeath", "LifestealMinigame", function(ply, _, attacker)
      if not IsValid(ply) then return end

      if not attacker or not attacker:IsPlayer() or not attacker:Alive() then return end

      attacker:SetHealth(attacker:Health() + ttt2_minigames_lifesteal_health:GetInt())
      if attacker:Health() > ttt2_minigames_lifesteal_cap:GetInt() and ttt2_minigames_lifesteal_cap:GetInt() ~= 0 then
        attacker:SetHealth(ttt2_minigames_lifesteal_cap:GetInt())
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostPlayerDeath", "LifestealMinigame")
  end
end
