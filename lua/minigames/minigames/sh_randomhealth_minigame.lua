if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_randomhealth_up = {
    slider = true,
    min = -100,
    max = 100,
    desc = "(Def. 100)"
  },

  ttt2_minigames_randomhealth_lw = {
    slider = true,
    min = -100,
    max = 100,
    desc = "(Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Random Health for everyone!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  local ttt2_minigames_randomhealth_up = CreateConVar("ttt2_minigames_randomhealth_up", "100", {FCVAR_ARCHIVE}, "Upper limit for random health gained")
  local ttt2_minigames_randomhealth_lw = CreateConVar("ttt2_minigames_randomhealth_lw", "0", {FCVAR_ARCHIVE}, "Lower limit for random health gained")
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local ply = plys[i]

      local newhealth = ply:Health() + math.random(ttt2_minigames_randomhealth_lw:GetInt(), ttt2_minigames_randomhealth_up:GetInt())

      ply:SetHealth(newhealth)

      if ply:Health() > ply:GetMaxHealth() then
        ply:SetMaxHealth(newhealth)
      end
    end
  end

  function MINIGAME:OnDeactivation()

  end
end
