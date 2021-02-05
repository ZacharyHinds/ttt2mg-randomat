if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_democracy_public = {
    checkbox = true,
    desc = "ttt2_minigames_democracy_public (Def. 1)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Democracy"
    },
    desc = {
      English = "Civic murder!"
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_democracy_start")
  util.AddNetworkString("ttt2mg_democracy_vote")
  util.AddNetworkString("ttt2mg_democracy_end")
  util.AddNetworkString("ttt2mg_democracy_epop")
  local ttt2_minigames_democracy_public = CreateConVar("ttt2_minigames_democracy_public", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Are players' votes public knowledge")
  local votes = {}

  net.Receive("ttt2mg_democracy_vote", function(len, ply)
    local selected_id = net.ReadString()
    votes[selected_id] = votes[selected_id] + 1
    local selected_nick = net.ReadString()
    local plys = player.GetAll()
    ply:PrintMessage(HUD_PRINTTALK, "You voted for" .. selected_nick)
    if not ttt2_minigames_democracy_public:GetBool() then return end
    for i = 1, #plys do
      local pl = plys[i]
      if pl == ply then continue end
      pl:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " voted for " .. selected_nick)
    end
  end)

  local function PrepareVotes(plys)
    votes = {}
    for i = 1, #plys do
      votes[plys[i]:SteamID64()] = 0
    end
  end

  local function ClearVotes()
    votes = {}
  end

  local function CountVotes()
    local plys = util.GetAlivePlayers()
    local winner = {ply = nil, votes = 0}
    for i = 1, #plys do
      local ply = plys[i]
      local id64 = ply:SteamID64()
      local vote_count = votes[id64]
      if i <= 1 and vote_count > 0 then
        winner.ply = ply
        winner.votes = vote_count
      elseif vote_count > winner.votes then
        winner.ply = ply
        winner.votes = vote_count
      elseif vote_count == winner.votes then
        winner.ply = nil
        winner.votes = vote_count
      end
    end
    return winner.ply, winner.votes
  end

  local function EndVotingRound()
    local chosen, vote_count = CountVotes()
    local result_state
    if not chosen and vote_count > 0 then
      result_state = "Vote Failed: Tie"
      print("[TTT2MG Democracy] Tie")
    elseif vote_count == 0 then
      result_state = "Vote Failed: Insufficient Votes"
      print("[TTT2MG Democracy] Insufficient Votes")
    elseif chosen:Alive() and chosen:IsPlayer() and not chosen:IsSpec() then
      result_state = chosen:Nick() .. " has been voted for!"
      print("[TTT2MG Democracy] Player " .. chosen:Nick() .. " has been voted for!")
      chosen:Kill()
    end
    local plys = player.GetAll()
    for i = 1, #plys do
      plys[i]:PrintMessage(HUD_PRINTTALK, result_state)
    end
    net.Start("ttt2mg_democracy_epop")
    net.WriteString(result_state)
    net.Broadcast()
  end

  local function StartVotingRound()
    local plys = util.GetAlivePlayers()
    PrepareVotes(plys)
    local nicks = {}
    local ids = {}
    for i = 1, #plys do
      local ply = plys[i]
      -- tbl[plys[i]:Nick()] = plys[i]:SteamID64()
      nicks[i] = ply:Nick()
      ids[i] = ply:SteamID64()
    end
    net.Start("ttt2mg_democracy_start")
    net.WriteBool(true)
    net.WriteTable(nicks)
    net.WriteTable(ids)
    net.Broadcast()
    timer.Simple(30, EndVotingRound)
  end

  function MINIGAME:OnActivation()
    StartVotingRound()
    timer.Create("TTT2mgVotingTimer", 35, 0, function()
      if GetRoundState() ~= ROUND_ACTIVE then
        timer.Remove("TTT2mgVotingTimer")
        ClearVotes()
      end
      StartVotingRound()
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("TTT2mgVotingTimer")
    ClearVotes()
  end
end

if CLIENT then
  function MINIGAME:OnActivation()
  end

  function MINIGAME:OnDeactivation()
  end

  net.Receive("ttt2mg_democracy_start", function()
    if not net.ReadBool() then return end
    local nicks = net.ReadTable()
    local ids = net.ReadTable()
    local Frame = vgui.Create("DFrame")
    Frame:SetTitle("Democracy Minigame")
    Frame:SetPos(5, ScrH() / 3)
    Frame:SetSize(150,10 + (20 * (#nicks + 1)))
    Frame:SetVisible(true)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    -- Frame:MakePopup()
    -- local k = 0
    -- for nick, id in pairs(plys) do
    for i = 1, #nicks do
      local nick = nicks[i]
      local id = ids[i]
      -- k = k + 1
      local Button = vgui.Create("DButton", Frame)
      Button:SetText(nick)
      Button:SetTextColor(Color(0,0,0))
      Button:SetPos(0, 10 + (20 * i))
      Button:SetSize(150,20)
      Button.DoClick = function()
        -- local steamid = id
        -- print(steamid)
        net.Start("ttt2mg_democracy_vote")
        net.WriteString(id)
        net.WriteString(nick)
        net.SendToServer()
        Frame:Close()
      end
    end
    timer.Simple(29.5, function()
      if not Frame.Close then return end
      Frame:Close()
    end)
  end)

  net.Receive("ttt2mg_democracy_epop", function()
    local result_state = net.ReadString()
    EPOP:AddMessage({
        text = result_state,
        color = COLOR_ORANGE
      },
      nil,
      12,
      nil,
      true
    )
  end)
end
