if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_flash_scale = {
    slider = true,
    min = 1,
    max = 100,
    desc = "ttt2_minigames_flash_scale (Def. 50)"
  }
}


if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Speeeeeed!"
    },
    desc = {
      English = "Everthing is fast as Flash now! ({scale}% faster)"
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_flash_epop")
  local ttt2_minigames_flash_scale = CreateConVar("ttt2_minigames_flash_scale", "50", {FCVAR_ARCHIVE}, "Multiplier for time scale")
  function MINIGAME:ShowActivationEPOP()
    net.Start("ttt2mg_flash_epop")
    net.WriteInt(ttt2_minigames_flash_scale:GetInt(), 32)
    net.WriteString(self.name)
    net.Broadcast()
  end
  function MINIGAME:OnActivation()
    self:ShowActivationEPOP()
    ts = game.GetTimeScale()
    game.SetTimeScale(ts + (ttt2_minigames_flash_scale:GetInt() / 100))
  end

  function MINIGAME:OnDeactivation()
    game.SetTimeScale(1)
  end


else
  function MINIGAME:ShowActivationEPOP() end
  net.Receive("ttt2mg_flash_epop", function()
    local mgscale = net.ReadInt(32)
    local name = net.ReadString()
    EPOP:AddMessage({
        text  = LANG.TryTranslation("ttt2_minigames_" .. name .. "_name"),
        color = COLOR_ORANGE
    },
      LANG.GetParamTranslation("ttt2_minigames_" .. name .. "_desc", {scale = mgscale}),
      12,
      nil,
      true
    )
  end)
end
