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
end

if SERVER then
  local ttt2_minigames_bees_count = CreateConVar("ttt2_minigames_bees_count", "4", {FCVAR_ARCHIVE}, "Number of bees spawned per person")
  local BeeNPC = "npc_manhack"
  function RemovePly(plys, ply)
    local j = 1
    for i = 1, #plys do
      if plys[i] ~= ply then
        if i ~= j then
          plys[j] = plys[i]
        end
        j = j + 1
      else
        plys[i] = nil
      end
    end
  end

  function MINIGAME:OnActivation()
    local plys = {}
    local getPlayers = player.GetAll()
    for i = 1, #getPlayers do
      local ply = getPlayers[i]
      if ply:Alive() and not ply:IsSpec() then
        plys[#plys + 1] = ply
      end
    end

    timer.Create("MinigameBees", 0.1, ttt2_minigames_bees_count:GetInt() * #plys, function()
      local ply = plys[math.random(#plys)]
      while not IsValid(ply) or not ply:Alive() and ply:IsSpec() do
        plys = RemovePly(plys, ply)
        ply = plys[math.random(1, #plys)]
      end

      local spos = ply:GetPos() + Vector(math.random(-75, 75), math.random(-75, 75), math.random(200, 250))
      local headBee = SpawnNPC(ply, spos, BeeNPC)
      if not IsValid(headBee) then return end
      headBee:SetNPCState(2)

      local Bee = ents.Create("prop_dynamic")
      if not IsValid(Bee) then return end
      Bee:SetModel("models/lucian/props/stupid_bee.mdl")
      Bee:SetPos(spos)
      Bee:SetParent(headBee)
      headBee:SetNoDraw(true)
      headBee:SetHealth(1000)
    end)
  end

  function BeeCleanup()
    local entities = ents.GetAll()
    for i = 1, #entities do
      local ent = entities[i]
      if ent:IsNPC() and ent:Classify(CLASS_MANHACK) then
        ent:Remove()
      end
    end
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MinigameBees")
    BeeCleanup()
  end
end
