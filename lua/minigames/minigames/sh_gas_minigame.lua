if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_gas_timer = {
    slider = true,
    min = 1,
    max = 10,
    desc = "(Def. 15)"
  },

  ttt2_minigames_gas_affectall = {
    checkbox = true,
    desc = "(Def. 0)"
  },

  ttt2_minigames_gas_discomb = {
    checkbox = true,
    desc = "(Def. 1)"
  },

  ttt2_minigames_gas_fire = {
    checkbox = true,
    desc = "(Def. 0)"
  },

  ttt2_minigames_gas_smoke = {
    checkbox = true,
    desc = "(Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Bad Gas!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  local ttt2_minigames_gas_timer = CreateConVar("ttt2_minigames_gas_timer", "15", {FCVAR_ARCHIVE}, "Delay between grenade drops")
  local ttt2_minigames_gas_affectall = CreateConVar("ttt2_minigames_gas_affectall", "0", {FCVAR_ARCHIVE}, "Should the grenade drop at everyone simultaneously")
  local ttt2_minigames_gas_discomb = CreateConVar("ttt2_minigames_gas_discomb", "1", {FCVAR_ARCHIVE}, "Should discombobulators drop")
  local ttt2_minigames_gas_fire = CreateConVar("ttt2_minigames_gas_fire", "0", {FCVAR_ARCHIVE}, "Should incendiaries drop")
  local ttt2_minigames_gas_smoke = CreateConVar("ttt2_minigames_gas_smoke", "0", {FCVAR_ARCHIVE}, "Should smokes drop")
  local nadeTable = {}

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
    if ttt2_minigames_gas_discomb:GetBool() then nadeTable[#nadeTable + 1] = "ttt_confgrenade_proj" end
    if ttt2_minigames_gas_fire:GetBool() then nadeTable[#nadeTable + 1] = "ttt_firegrenade_proj" end
    if ttt2_minigames_gas_smoke:GetBool() then nadeTable[#nadeTable + 1] = "ttt_smokegrenade_proj" end

    timer.Create("GasMinigame", ttt2_minigames_gas_timer:GetInt(), 0, function()
      local plys = player.GetAll()
      if ttt2_minigames_gas_affectall:GetBool() then
        for i = 1, #plys do
          local ply = plys[i]
          if not ply:Alive() or ply:IsSpec() then continue end
          local nade = ents.Create(nadeTable[math.random(#nadeTable)])
          if not IsValid(nade) then continue end

          nade:SetPos(ply:GetPos())
          nade:SetOwner(ply)
          nade:SetThrower(ply)
          nade:SetGravity(0.4)
          nade:SetFriction(0.2)
          nade:SetElasticity(0.45)
          nade:Spawn()
          nade:PhysWake()
          nade:SetDetonateExact(1)
        end
      else
        local ply = plys[math.random(#plys)]
        while not ply:Alive() or ply:IsSpec() do
          RemovePly(plys, ply)
          ply = plys[math.random(#plys)]
        end
        local nade = ents.Create(nadeTable[math.random(#nadeTable)])
        if not IsValid(nade) then return end
        nade:SetPos(ply:GetPos())
        nade:SetOwner(ply)
        nade:SetThrower(ply)
        nade:SetGravity(0.4)
        nade:SetFriction(0.2)
        nade:SetElasticity(0.45)
        nade:Spawn()
        nade:PhysWake()
        nade:SetDetonateExact(1)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("GasMinigame")
  end
end
