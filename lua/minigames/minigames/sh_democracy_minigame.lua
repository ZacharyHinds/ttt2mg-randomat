if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2mg_democracy_public = {
    checkbox = true,
    desc = "ttt2mg_democracy_public (Def. 1)"
  },

  ttt2mg_democracy_dead_players = {
    checkbox = true,
    desc = "ttt2mg_democracy_dead_players (Def. 0)"
  },

  ttt2mg_democracy_anonymous = {
    checkbox = true,
    desc = "ttt2mg_democracy_anonymous (Def. 0)"
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
  local ttt2mg_democracy_public = CreateConVar("ttt2mg_democracy_public", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Are players' votes public knowledge")
  local ttt2mg_democracy_dead_players = CreateConVar("ttt2mg_democracy_dead_players", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should dead players be included in vote list?")
  local ttt2mg_democracy_anonymous = CreateConVar("ttt2mg_democracy_anonymous", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should votes be anonymous")
  local votes = {}

  net.Receive("ttt2mg_democracy_vote", function(len, ply)
    local selected_id = net.ReadString()
    votes[selected_id] = votes[selected_id] + 1
    local selected_nick = net.ReadString()
    -- local plys = player.GetAll()
    -- ply:PrintMessage(HUD_PRINTTALK, "You voted for " .. selected_nick)
    net.Start("ttt2mg_democracy_vote")
    net.WriteString("ttt2mg_misc_you")
    net.WriteBool(true)
    net.WriteString(selected_nick)
    net.Send(ply)
    if not ttt2mg_democracy_public:GetBool() then return end
    net.Start("ttt2mg_democracy_vote")
    if not ttt2mg_democracy_anonymous:GetBool() then
      net.WriteString(ply:Nick())
      net.WriteBool(false)
    else
      net.WriteString("ttt2mg_misc_someone")
      net.WriteBool(true)
    end
    net.WriteString(selected_nick)
    net.SendOmit(ply)
    -- ply:PrintMessage(HUD_PRINTTALK, LANG.GetParamTranslation("ttt2mg_democracy_voted_for", {nick = "You", target = selected_nick}))
    -- for i = 1, #plys do
    --   local pl = plys[i]
    --   if pl == ply then continue end
    --   -- pl:PrintMessage(HUD_PRINTTALK, ply:Nick() .. " voted for " .. selected_nick)
    --   pl:PrintMessage(HUD_PRINTTALK, LANG.GetParamTranslation("ttt2mg_democracy_voted_for", {nick = ply:Nick(), target = selected_nick}))
    -- end
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
    local plys
    if ttt2mg_democracy_dead_players:GetBool() then
      plys = player.GetAll()
    else
      plys = util.GetAlivePlayers()
    end
    local winner = {ply = nil, votes = 0}
    for i = 1, #plys do
      local ply = plys[i]
      local id64 = ply:SteamID64()
      local vote_count = votes[id64]
      if i <= 1 and vote_count and vote_count > 0 then
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
    local nick = "none"
    if not chosen and vote_count > 0 then
      -- result_state = "Vote Failed: Tie"
      result_state = "ttt2mg_democracy_vote_tie"
      print("[TTT2MG Democracy] Tie")
    elseif vote_count == 0 then
      -- result_state = "Vote Failed: Insufficient Votes"
      result_state = "ttt2mg_democracy_insufficient"
      print("[TTT2MG Democracy] Insufficient Votes")
    elseif chosen:IsPlayer() then
      -- result_state = chosen:Nick() .. " has been voted for!"
      result_state = "ttt2mg_democracy_vote_result"
      nick = chosen:Nick()
      print("[TTT2MG Democracy] Player " .. nick .. " has been voted for!")
      chosen:Kill()
    else
      result_state = "ttt2mg_democracy_insufficient"
    end
    -- local plys = player.GetAll()
    -- for i = 1, #plys do
    --   plys[i]:PrintMessage(HUD_PRINTTALK, result_state)
    -- end
    net.Start("ttt2mg_democracy_epop")
    net.WriteString(result_state)
    net.WriteString(nick)
    net.Broadcast()
  end

  local function StartVotingRound()
    local plys
    if ttt2mg_democracy_dead_players:GetBool() then
      plys = player.GetAll()
    else
      plys = util.GetAlivePlayers()
    end
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
    local client = LocalPlayer()
    if not client:Alive() or client:IsSpec() then return end
    if client.IsGhost and client:IsGhost() then return end
    local nicks = net.ReadTable()
    local ids = net.ReadTable()
    local Frame = vgui.Create("DFrame")
    Frame:SetTitle(LANG.TryTranslation("ttt2mg_democracy_frame"))
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
    local nick = net.ReadString()
    if nick ~= "none" then
      result_state = LANG.GetParamTranslation(result_state, {nick = nick})
    else
      result_state = LANG.TryTranslation(result_state)
    end
    EPOP:AddMessage({
        text = result_state,
        color = COLOR_ORANGE
      },
      nil,
      12,
      nil,
      true
    )
    LocalPlayer():PrintMessage(HUD_PRINTTALK, result_state)
  end)

  net.Receive("ttt2mg_democracy_vote", function()
    local voter = net.ReadString()
    if net.ReadBool() then
      voter = LANG.TryTranslation(voter)
    end
    local selected = net.ReadString()
    LocalPlayer():PrintMessage(HUD_PRINTTALK, LANG.GetParamTranslation("ttt2mg_democracy_voted_for", {who = voter, target = selected}))
  end)
end
