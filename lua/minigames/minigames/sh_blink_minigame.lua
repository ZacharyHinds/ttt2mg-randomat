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
else
  ttt2_minigames_blink_cap = CreateConVar("ttt2_minigames_blink_cap", "12", {FCVAR_ARCHIVE}, "Max angels to spawn")
  ttt2_minigames_blink_delay = CreateConVar("ttt2_minigames_blink_delay", "0.5", {FCVAR_ARCHIVE}, "Delay between angel spawns")
end

if SERVER then
  function MINIGAME:OnActivation()
    local plys = util.GetAlivePlayers()

    local k = 1
    timer.Create("AngelMinigame", ttt2_minigames_blink_delay:GetFloat(), 0, function()
      if plys[k] then
        local ply = plys[k]

        while not ply:Alive() do
          k = k + 1
          ply = plys[k]
        end
        if k <= ttt2_minigames_blink_cap:GetInt() or ttt2_minigames_blink_cap:GetInt() == 0 then
          local ent = ents.Create("weepingangel")
          ent:SetPos(ply:GetAimVector())
          ent:Spawn()
          ent:Activate()

          ent:SetVictim(ply)
          ent:DropToFloor()
        end
        k = k + 1
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("AngelMinigame")
  end
end
