if SERVER then
  AddCSLuaFile()
  include("minigames/engine/sh_functions.lua")
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_choose_mode = {
    combobox = true,
    choices = {
      "0 - Playerwide vote",
      "1 - One player's choice",
      "2 - Random between options 1 and 2"
    },
    desc = "ttt2_minigames_choose_mode (Def. 2)"
  },

  ttt2_minigames_choose_count = {
    slider = true,
    min = 1,
    max = 10,
    desc = "ttt2_minigames_choose_count (Def. 5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Pick Your Poison!"
    },
    desc = {
      English = "Select a minigame!"
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_choose_start")
  local ttt2_minigames_choose_mode = CreateConVar("ttt2_minigames_choose_mode", "2", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Voting mode")
  local ttt2_minigames_choose_count = CreateConVar("ttt2_minigames_choose_count", "5", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Number of choices")
  local votes = {}
  local vote_mode = 2
  local active_mgs = {}

  local function ResetVotes()
    votes = {}
    vote_mode = 2
  end

  local function DoVoting()
    vote_mode = ttt2_minigames_choose_mode:GetInt()
    if vote_mode == 2 then
      vote_mode = math.random(0,1)
    end
    return vote_mode == 0
  end

  local function CountVotes()
    local winner = {name = "", votes = 0}
    local ties = {}
    -- local tie_score = {}
    local names = {}
    local counts = {}
    for key, val in pairs(votes) do
      if val > 0 then
        names[#names + 1] = key
        counts[#counts + 1] = val
      end
    end
    for i = 1, #names do
      local name = names[i]
      local count = counts[i]
      if i <= 1 then
        winner.name = name
        winner.votes = count
      elseif count > winner.votes then
        winner.name = name
        winner.votes = count
        ties = {}
      elseif vote_count == winner.votes then
        winner.name = nil
        winner.votes = count
        ties[#ties + 1] = name
      end
    end
    if not winner.name and #ties > 0 then
      return ties[math.random(#ties)]
    elseif winner.name then
      return winner.name
    end
  end

  local function EndVote()
    local winner = CountVotes()
    if not winner then return end
    ActivateMinigame(minigames.Get(winner))
    active_mgs[#active_mgs + 1] = minigames.Get(winner)
    ResetVotes()
  end

  net.Receive("ttt2mg_choose_start", function(len, ply)
    local mgname = net.ReadString()
    local mg = minigames.Get(mgname)
    if not DoVoting() then
      ActivateMinigame(mg)
    else
      votes[mgname] = votes[mgname] + 1
    end
  end)

  local function GenerateMinigameChoices()
    local choices = {}
    for i = 1, ttt2_minigames_choose_count:GetInt() do
      local mgs = minigames.GetList()
      local mg
      repeat
        if #mgs <= 0 then return choices end
        local rnd = math.random(#mgs)
        mg = mgs[rnd]
        table.remove(mgs, rnd)
      until mg:IsSelectable() and GetConVar("ttt2_minigames_" .. mg.name .. "_enabled"):GetBool() and not mg:IsActive() and mg.name ~= "sh_pick_minigame"
      choices[#choices + 1] = mg.name
    end
    for i = 1, #choices do
      votes[choices[i]] = 0
    end
    return choices
  end

  local function SendChoices(choices)
    local plys = util.GetFilteredPlayers(function(ply)
      return ply:Alive() and ply:IsPlayer() and not ply:IsSpec() and not ply:IsBot()
    end)
    local ply = plys[math.random(#plys)]
    net.Start("ttt2mg_choose_start")
    net.WriteTable(choices)
    if ttt2_minigames_choose_mode:GetInt() == 0 then
      net.Send(plys)
    else
      net.Send(ply)
    end
  end

  function MINIGAME:OnActivation()
    SendChoices(GenerateMinigameChoices())
    if DoVoting() then
      timer.Simple(30, EndVote)
    end
  end

  function MINIGAME:OnDeactivation()
    for i = 1, #active_mgs do
      DeactivateMinigame(active_mgs[i])
    end
    active_mgs = {}
  end
end

if CLIENT then
  net.Receive("ttt2mg_choose_start", function()
    local choices = net.ReadTable()
    local fallback = choices[math.random(#choices)]
    local didVote = false
    local Frame = vgui.Create("DFrame")
    Frame:SetTitle(LANG.TryTranslation("ttt2mg_choose_frame"))
    Frame:SetPos(5, ScrH() / 3)
    Frame:SetSize(150, 10 + (20 * (#choices + 1)))
    Frame:SetVisible(true)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    for i = 1, #choices do
      local choice = choices[i]
      local Button = vgui.Create("DButton", Frame)
      Button:SetText(LANG.TryTranslation("ttt2_minigames_" .. choice .. "_name"))
      Button:SetPos(0, 10 + (20 * i))
      Button:SetSize(150, 20)
      Button.DoClick = function()
        net.Start("ttt2mg_choose_start")
        net.WriteString(choice)
        net.SendToServer()
        Frame:Close()
        didVote = true
      end
    end
    timer.Simple(29.5, function()
      if didVote or not Frame.Close then return end
      Frame:Close()
      net.Start("ttt2mg_choose_start")
      net.WriteString(fallback)
      net.SendToServer()
    end)
  end)
  function MINIGAME:OnActivation()
  end

  function MINIGAME:OnDeactivation()
  end
end
