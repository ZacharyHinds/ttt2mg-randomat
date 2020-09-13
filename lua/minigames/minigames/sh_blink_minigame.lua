if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_blink_cap = {
    slider = true,
    min = 1,
    max = 20,
    desc = "(Def. 12)"
  },
  ttt2_minigames_blink_delay = {
    slider = true,
    min = 0,
    max = 3,
    decimal = 1,
    desc = "(Def. 0.5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Don't Blink."
    },
    desc = {
      English = "They're coming for you..."
    }
  }
end

if SERVER then
  local ttt2_minigames_blink_cap = CreateConVar("ttt2_minigames_blink_cap", "12", {FCVAR_ARCHIVE}, "Max angels to spawn")
  local ttt2_minigames_blink_delay = CreateConVar("ttt2_minigames_blink_delay", "0.5", {FCVAR_ARCHIVE}, "Delay between angel spawns")
  function MINIGAME:OnActivation()
    if ttt2_minigames_blink_cap:GetInt() <= 0 then return end
    timer.Create("AngelMinigame", ttt2_minigames_blink_delay:GetFloat(), ttt2_minigames_blink_cap:GetInt(), function()
      local plys = util.GetAlivePlayers()
      local ply
      repeat
        if #plys <= 0 then return end
        local rnd = math.random(#plys)
        ply = plys[rnd]
        table.remove(plys, rnd)
      until IsValid(ply) and ply:Alive() and not ply:IsSpec()

      local ent = ents.Create("weepingangel")
      if not IsValid(ent) then return end
      ent:SetPos(ply:GetAimVector())
      ent:Spawn()
      ent:Activate()
      ent:SetVictim(ply)
      ent:DropToFloor()
    end)
  end

  function MINIGAME:IsSelectable()
    if ttt2_minigames_blink_cap:GetInt() <= 0 then return false end
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("AngelMinigame")
  end
end
