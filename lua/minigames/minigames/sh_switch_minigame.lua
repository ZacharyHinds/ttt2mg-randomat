if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_switch_timer = {
    slider = true,
    min = 1,
    max = 60,
    desc = "ttt2_minigames_switch_timer (Def. 15)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Switch!"
      Русский = "Switch!"
    },
    desc = {
      English = "There's this game my fauther taught me years ago, it's called \"Switch\""
      Русский = "Это игра, которую мой отец научил меня много лет назад, она называется \"Switch\""
    }
  }
else
  util.AddNetworkString("switch_minigame_popup")
end

if SERVER then
  local ttt2_minigames_switch_timer = CreateConVar("ttt2_minigames_switch_timer", "15", {FCVAR_ARCHIVE}, "Time between switches")
  function MINIGAME:OnActivation()
    timer.Create("SwitchMinigameTimer", ttt2_minigames_switch_timer:GetInt(), 0, function()
      local i = 0
      local ply1 = 0
      local ply2 = 0
      for _, ply in RandomPairs(player.GetAll()) do
        if not ply:Alive() or ply:IsSpec() then continue end

        if i == 0 then
          ply1 = ply
          i = i + 1
        elseif i == 1 then
          ply2 = ply
          i = i + 1
        end
      end
      i = 0
      net.Start("switch_minigame_popup")
      net.Broadcast()
      ply1_pos = ply1:GetPos()
      ply1:SetPos(ply2:GetPos())
      ply2:SetPos(ply1_pos)
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("SwitchMinigameTimer")
  end
end

if CLIENT then
  net.Receive("switch_minigame_popup", function()
    EPOP:AddMessage({
      text = LANG.TryTranslation("ttt2mg_switch_epop"),
      color = COLOR_ORANGE},
      nil,
      2,
      nil,
      true
    )
  end)
end
