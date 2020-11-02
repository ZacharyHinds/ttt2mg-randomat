if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_soulmate_all = {
    checkbox = true,
    desc = "ttt2_minigames_soulmate_all (Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Soulmates",
      Русский = "Родственные души"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_soulmate_epop")
  local ttt2_minigames_soulmate_all = CreateConVar("ttt2_minigames_soulmate_all", "0", {FCVAR_ARCHIVE}, "Whether everyone should have a soulmate")
  function MINIGAME:OnActivation()
    local x = 0

    local ply1 = {}
    local ply2 = {}
    local plys = util.GetAlivePlayers()

    for i = 1, #plys do
      local ply = plys[i]

      x = x + 1
      if math.floor(x / 2) ~= x / 2 then
        ply1[#ply1 + 1] = ply
      else
        ply2[#ply2 + 1] = ply
      end
    end

    local size = 1

    table.Shuffle(ply1)
    table.Shuffle(ply2)

    if ttt2_minigames_soulmate_all:GetBool() then
      size = #ply2

      for i = 1, #ply2 do
        local ply_1 = ply1[i]
        local ply_2 = ply2[i]
        net.Start("ttt2mg_soulmate_epop")
        net.WriteString("ttt2mg_soulmate_yours")
        net.WriteString(ply_2:Nick())
        net.Send(ply_1)
        net.Start("ttt2mg_soulmate_epop")
        net.WriteString("ttt2mg_soulmate_yours")
        net.WriteString(ply_1:Nick())
        net.Send(ply_2)
      end
      if ply1[#ply2 + 1] then
        local ply_1 = ply1[#ply2 + 1]
        net.Start("ttt2mg_soulmate_epop")
        net.WriteString("ttt2mg_soulmate_none")
        net.Send(ply_1)
      end

      timer.Create("SoulmatesMinigameTimer", 0.1, 0, function()
        for i = 1, size do
          if not ply1[i]:Alive() and ply2[i]:Alive() then
            ply2[i]:Kill()
          elseif ply1[i]:Alive() and not ply2[i]:Alive() then
            ply1[i]:Kill()
          end
        end
      end)
    else
      local rnd1 = math.random(#ply1)
      local rnd2 = math.random(#ply2)
      local ply_1 = ply1[rnd1]
      local ply_2 = ply2[rnd2]
      plys = player.GetAll()
      net.Start("ttt2mg_soulmate_epop")
      net.WriteString("ttt2mg_soulmate_pair")
      net.WriteString(ply_1:Nick())
      net.WriteString(ply_2:Nick())
      net.Broadcast()
      timer.Create("SoulmatesMinigameTimer", 0.1, 0, function()
        if not ply_1:Alive() and ply_2:Alive() then
          ply_2:Kill()
        elseif not ply_2:Alive() and ply_1:Alive() then
          ply_1:Kill()
        end
      end)
    end

  end

  function MINIGAME:OnDeactivation()
    timer.Remove("SoulmatesMinigameTimer")
  end
else
  function MINIGAME:ShowActivationEPOP() end
  net.Receive("ttt2mg_soulmate_epop", function()
    local msg = net.ReadString()
    if msg == "ttt2mg_soulmate_yours" then
      local nick = net.ReadString()
      msg = LANG.GetParamTranslation(msg, {nick = nick})
    elseif msg == "ttt2mg_soulmate_none" then
      msg = LANG.TryTranslation(msg)
    elseif msg == "ttt2mg_soulmate_pair" then
      msg = LANG.GetParamTranslation(msg, {nick1 = net.ReadString(), nick2 = net.ReadString()})
    else return end

    local client = LocalPlayer()
    client:PrintMessage(HUD_PRINTTALK, msg)
    EPOP:AddMessage({
        text = msg,
        color = COLOR_ORANGE
    },
      nil,
      12,
      nil,
      true
    )
  end)
end
