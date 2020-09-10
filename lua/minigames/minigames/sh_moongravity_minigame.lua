if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_moongravity_gravity = {
    slider = true,
    min = 0,
    max = 1,
    decimal = 1,
    desc = "(Def. 0.1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Moon Gravity!"
    },
    desc = {
      English = ""
    }
  }
else
  ttt2_minigames_moongravity_gravity = CreateConVar("ttt2_minigames_moongravity_gravity", "0.1", {FCVAR_ARCHIVE}, "Gravity multiplier")
end

if SERVER then
  function MINIGAME:OnActivation()
    for _, ply in ipairs(player.GetAll()) do
      if ply:Alive() and not ply:IsSpec() then ply:SetGravity(ttt2_minigames_moongravity_gravity:GetFloat()) end
    end
    timer.Create("GravityMinigame", 1, 0, function()
      for k, ply in ipairs(player.GetAll()) do
        if ply:Alive() and not ply:IsSpec() then ply:SetGravity(ttt2_minigames_moongravity_gravity:GetFloat()) end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("GravityMinigame")
    for _, ply in ipairs(player.GetAll()) do
      ply:SetGravity(1)
    end
  end
end
