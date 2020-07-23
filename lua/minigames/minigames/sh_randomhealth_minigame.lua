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
else
  ttt2_minigames_randomhealth_up = CreateConVar("ttt2_minigames_randomhealth_up", "100", {FCVAR_ARCHIVE}, "Upper limit for random health gained")
  ttt2_minigames_randomhealth_lw = CreateConVar("ttt2_minigames_randomhealth_lw", "0", {FCVAR_ARCHIVE}, "Lower limit for random health gained")
end

if SERVER then
  function MINIGAME:OnActivation()
    for _, ply in ipairs(player.GetAll()) do
      if not ply:Alive() or ply:IsSpec() then continue end

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
