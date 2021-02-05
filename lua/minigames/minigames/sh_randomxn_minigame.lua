if SERVER then
  AddCSLuaFile()
  include("minigames/engine/sh_functions.lua")
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_randomxn_count = {
    slider = true,
    min = 1,
    max = 20,
    desc = "ttt2_minigames_randomxn_count (Def. 5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Multigame"
    }
  }
end

if SERVER then
  local active_mgs = {}
  local ttt2_minigames_randomxn_count = CreateConVar("ttt2_minigames_randomxn_count", "5", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Number of games to activate")
  function MINIGAME:ShowActivationEPOP()
    net.Start("ttt2mg_randomxn_epop")
    net.WriteInt(ttt2_minigames_randomxn_count:GetInt(), 32)
    net.Broadcast()
  end

  function MINIGAME:OnActivation()
    timer.Create("RandomxnMinigame", 12.5, ttt2_minigames_randomxn_count:GetInt(), function()
      local minigame = minigames.Select()
      if not minigame then return end

      ActivateMinigame(minigame)
      active_mgs[#active_mgs + 1] = minigame
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("RandomxnMinigame")
    for i = 1, #active_mgs do
      DeactivateMinigame(active_mgs[i])
    end
    active_mgs = {}
  end
else
  function MINIGAME:ShowActivationEPOP() end

  net.Receive("ttt2mg_randomxn_epop", function()
    local mgcount = net.ReadInt(32)
    EPOP:AddMessage({
        text = LANG.GetParamTranslation("ttt2mg_randomxn_epop", {count = mgcount}),
        color = COLOR_ORANGE
    },
      nil,
      12,
      nil,
      true
    )
  end)
end
