if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_freeze_duration = {
    slider = true,
    min = 1,
    max = 10,
    desc = "ttt2_minigames_freeze_duration (Def. 5)"
  },

  ttt2_minigames_freeze_timer = {
    slider = true,
    min = 1,
    max = 60,
    desc = "ttt2_minigames_freeze_timer (Def. 30)"
  },

  ttt2_minigames_freeze_quotes = {
    checkbox = true,
    desc = "ttt2_minigames_freeze_quotes (Def. 1)"
  },

  ttt2_minigames_freeze_desc = {
    checkbox = true,
    desc = "ttt2_minigames_freeze_desc (Def. 0)"
  }
}


if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Freeze!"
    },
    desc = {
      English = "All Innocents will freeze (and become immune) every {time} seconds"
    }
  }
else
  util.AddNetworkString("freeze_minigame_popup")
  util.AddNetworkString("ttt2mg_freeze_epop")
end

if SERVER then
  local ttt2_minigames_freeze_timer = CreateConVar("ttt2_minigames_freeze_timer", "30", {FCVAR_ARCHIVE}, "Duration of Freeze")
  local ttt2_minigames_freeze_duration = CreateConVar("ttt2_minigames_freeze_duration", "5", {FCVAR_ARCHIVE}, "Delay between freezes")
  local ttt2_minigames_freeze_quotes = CreateConVar("ttt2_minigames_freeze_quotes", "1", {FCVAR_ARCHIVE}, "Use quotes instead of minigame name")
  local ttt2_minigames_freeze_desc = CreateConVar("ttt2_minigames_freeze_desc", "0", {FCVAR_ARCHIVE}, "Show minigame description")
  function MINIGAME:ShowActivationEPOP()
    net.Start("ttt2mg_freeze_epop")
    net.WriteBool(ttt2_minigames_freeze_quotes:GetBool())
    net.WriteBool(ttt2_minigames_freeze_desc:GetBool())
    net.WriteInt(ttt2_minigames_freeze_timer:GetInt(), 32)
    net.WriteString(self.name)
    net.Broadcast()
  end
  function MINIGAME:OnActivation()
    self:ShowActivationEPOP()
    timer.Create("FreezeMinigame", ttt2_minigames_freeze_timer:GetInt(), 0, function()
      net.Start("freeze_minigame_popup")
      net.Broadcast()
      local plys = util.GetAlivePlayers()

      for i = 1, #plys do
        local ply = plys[i]
        if not ply:Alive() or ply:IsSpec() or not ply:HasTeam(TEAM_INNOCENT) then continue end

        ply:Freeze(true)
        ply.isFrozen = true
        timer.Simple(ttt2_minigames_freeze_duration:GetInt(), function()
          ply:Freeze(false)
          ply.isFrozen = false
        end)
      end
    end)

    hook.Add("EntityTakeDamage", "FreezeMinigameImmunity", function(ply, dmg)
      if ply:IsValid() and ply.isFrozen then
        dmg:ScaleDamage(0)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityTakeDamage", "FreezeMinigameImmunity")
    timer.Remove("FreezeMinigame")
  end
end

if CLIENT then
  function MINIGAME:ShowActivationEPOP()

  end
  net.Receive("ttt2mg_freeze_epop", function()
    local isQuote = net.ReadBool()
    local showDesc = net.ReadBool()
    local mgtime = net.ReadInt(32)
    local name = net.ReadString()
    if isQuote then
      EPOP:AddMessage({
          text = LANG.TryTranslation("ttt2mg_freeze_epop_" .. math.random(15)),
          color = COLOR_ORANGE
        },
        shoDesc and LANG.GetParamTranslation("ttt2_minigames_" .. name .. "_desc", {time = mgtime}),
        12,
        nil,
        true
      )
    else
      EPOP:AddMessage({
          text = LANG.TryTranslation("ttt2_minigames_" .. name .. "_name"),
          color = COLOR_ORANGE
      },
        showDesc and LANG.GetParamTranslation("ttt2_minigames_" .. name .. "_desc", {time = mgtime}),
        12,
        nil,
        true
      )
    end
  end)

  net.Receive("freeze_minigame_popup", function()
    EPOP:AddMessage({
      text = "Freeze!",
      color = Color(19, 159, 235, 255)},
      nil,
      5,
      nil,
      true
    )
  end)
end
