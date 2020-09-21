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
    desc = "ttt2_minigames_blink_cap (Def. 12)"
  },
  ttt2_minigames_blink_delay = {
    slider = true,
    min = 0,
    max = 3,
    decimal = 1,
    desc = "ttt2_minigames_blink_delay (Def. 0.5)"
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
  local angels = {}
  function MINIGAME:OnActivation()
    if ttt2_minigames_blink_cap:GetInt() <= 0 then return end
    local plys = util.GetAlivePlayers()
    timer.Create("AngelMinigame", ttt2_minigames_blink_delay:GetFloat(), ttt2_minigames_blink_cap:GetInt(), function()
      local ply
      repeat
        if #plys <= 0 then
          plys = util.GetAlivePlayers()
          if #plys <= 0 then return end
        end
        local rnd = math.random(#plys)
        ply = plys[rnd]
        table.remove(plys, rnd)
      until IsValid(ply)

      local ent = ents.Create("weepingangel")
      if not IsValid(ent) then return end
      ent:SetPos(ply:GetAimVector())
      ent:Spawn()
      ent:Activate()
      ent:SetVictim(ply)
      ent:DropToFloor()
      angels[#angels + 1] = ent
    end)
  end

  function MINIGAME:IsSelectable()
    if ttt2_minigames_blink_cap:GetInt() <= 0 then return false end
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("AngelMinigame")
    for i = 1, #angels do
      angels[i]:Remove()
    end
  end

  function MINIGAME:IsSelectable()
    if not WEPS.IsInstalled("ttt_weeping_angel") then
      return false
    else
      return true
    end
  end
end
