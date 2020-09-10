if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_bees_count = {
    slider = true,
    min = 1,
    max = 10,
    desc = "(Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Bees!"
    },
    desc = {
      English = "NOT THE BEES!"
    }
  }
else
  ttt2_minigames_bees_count = CreateConVar("ttt2_minigames_bees_count", "4", {FCVAR_ARCHIVE}, "Number of bees spawned per person")
  BeeNPC = "npc_manhack"
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = {}
    local getPlayers = player.GetAll
    for i = 1, #getPlayers do
      local ply = getPlayers[i]
      if ply:Alive() and not ply:IsSpec() then
        plys[#plys + 1] = ply
      end
    end
    local count = #plys

    timer.Create("MinigameBees", 0.1, ttt2_minigames_bees_count:GetInt() * count, function()
      local ply = plys[math.random(#plys)]
      while not ply:Alive() and ply:IsSpec() do
        ply = plys[math.random(1, #plys)]
      end

      spos = ply:GetPos() + Vector(math.random(-75, 75), math.random(-75, 75), math.random(200, 250))
      local headBee = SpawnNPC(ply, spos, BeeNPC)
      headBee:SetNPCState(2)

      local Bee = ents.Create("prop_dynamic")
      Bee:SetModel("models/lucian/props/stupid_bee.mdl")
      Bee:SetPos(spos)
      Bee:SetParent(headBee)
      headBee:SetNoDraw(true)
      headBee:SetHealth(1000)
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MinigameBees")
  end
end
