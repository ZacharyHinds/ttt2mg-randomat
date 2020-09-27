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
    desc = "ttt2_minigames_bees_count (Def. 4)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Bees!"
      Русский = "Пчёлы!"
    },
    desc = {
      English = "NOT THE BEES!"
      Русский = "ТОЛЬКО НЕ ПЧЁЛЫ!"
    }
  }
end

if SERVER then
  local ttt2_minigames_bees_count = CreateConVar("ttt2_minigames_bees_count", "4", {FCVAR_ARCHIVE}, "Number of bees spawned per person")
  local BeeNPC = "npc_manhack"
  local bees = {}

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
      local ply
      repeat
        if #plys <= 0 then return end

        local rnd = math.random(#plys)
        ply = plys[rnd]
        table.remove(plys, rnd)
      until IsValid(ply) and ply:Alive() and not ply:IsSpec()

      local spos = ply:GetPos() + Vector(math.random(-75, 75), math.random(-75, 75), math.random(200, 250))
      local headBee = SpawnNPC(ply, spos, BeeNPC)
      if not IsValid(headBee) then return end
      headBee:SetNPCState(2)
      headBee:SetHealth(1000)
      bees[#bees + 1] = headBee

      local Bee = ents.Create("prop_dynamic")
      if not IsValid(Bee) then return end
      Bee:SetModel("models/lucian/props/stupid_bee.mdl")
      Bee:SetPos(spos)
      Bee:SetParent(headBee)
      headBee:SetNoDraw(true)
    end)
  end

  function BeeCleanup()
    for i = 1, #bees do
      if IsValid(bees[i]) then bees[i]:Remove() end
    end
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MinigameBees")
    BeeCleanup()
  end

  function MINIGAME:IsSelectable()
    if not WEPS.IsInstalled("weapon_ttt_beenade") then
      return false
    else
      return true
    end
  end
end
