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
    desc = "(Def. 50)"
  }
}

ttt2_minigames_flash_scale = CreateConVar("ttt2_minigames_flash_scale", "50", {FCVAR_ARCHIVE}, "Multiplier for time scale")

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Speeeeeed!"
    },
    desc = {
      English = "Everthing is fast as Flash now! (" .. ttt2_minigames_flash_scale:GetInt() .. "% faster)"
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    ts = game.GetTimeScale()
    game.SetTimeScale(ts + (ttt2_minigames_flash_scale:GetInt() / 100))
  end

  function MINIGAME:OnDeactivation()
    game.SetTimeScale(1)
  end
end
