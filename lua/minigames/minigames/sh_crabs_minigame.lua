if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_crabs_count = {
    slider = true,
    min = 1,
    max = 10,
    desc = "(Def. 5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Crabs are People!"
    },
    desc = {
      English = "Headcrabs will spawn on death."
    }
  }
else
  ttt2_minigames_crabs_count = CreateConVar("ttt2_minigames_crabs_count", "5", {FCVAR_ARCHIVE}, "How many crabs to spawn when someone dies")
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("PostPlayerDeath", "CrabMinigameSpawn", function(ply)
      if not IsValid(ply) then return end

      for i = 1, ttt2_minigames_crabs_count:GetInt() do
        local crab = ents.Create("npc_headcrab")
        crab:SetPos(ply:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 0))
        crab:Spawn()
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("PostPlayerDeath", "CrabMinigameSpawn")
  end
end
