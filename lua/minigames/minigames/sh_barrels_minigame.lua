if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_barrels_count = {
    slider = true,
    min = 1,
    max = 10,
    desc = "(Def. 0)"
  },
  ttt2_minigames_barrels_range = {
    slider = true,
    min = 100,
    max = 1000,
    desc = "(Def. 100)"
  },
  ttt2_minigames_barrels_timer = {
    slider = true,
    min = 1,
    max = 240,
    desc = "(Def. 60)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Exploding Barrels!"
    },
    desc = {
      English = "Gunpowder, Treason, and Plot"
    }
  }
else
  ttt2_minigames_barrels_count = CreateConVar("ttt2_minigames_barrels_count", "3", {FCVAR_ARCHIVE}, "Number of barrels spawned per person")
  ttt2_minigames_barrels_range = CreateConVar("ttt2_minigames_barrels_range", "100", {FCVAR_ARCHIVE}, "Distance barrels spawn from the player")
  ttt2_minigames_barrels_timer = CreateConVar("ttt2_minigames_barrels_timer", "60", {FCVAR_ARCHIVE}, "Time between barrel spawns")
end


if SERVER then
  local function TriggerBarrels()
    local plys = player.GetAll()
    local spacing = ttt2_minigames_barrels_range:GetInt()
    local barrel_count = ttt2_minigames_barrels_count:GetInt()

    for j = 1, #plys do
      local ent = ents.Create("prop_physics")
      ply = plys[j]
      if not ply:Alive() or ply:IsSpec() then continue end
      for i = 1, barrel_count do
        if not IsValid(ent) then continue end
        ent:SetModel("models/props_c17/oildrum001_explosive.mdl")
        ent:SetPos(ply:GetPos() + Vector(math.random(-spacing, spacing), math.random(-spacing, spacing), math.random(5, spacing)))
        ent:Spawn()
        local phys = ent:GetPhysicsObject()
        if not IsValid(phys) then ent:Remove() end
      end
    end
  end
  function MINIGAME:OnActivation()
    TriggerBarrels()
    timer.Create("MinigameBarrelSpawn", ttt2_minigames_barrels_timer:GetInt(), 0, TriggerBarrels)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MinigameBarrelSpawn")
  end
end
