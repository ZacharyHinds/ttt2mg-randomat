if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_promotion_count = {
    slider = true,
    min = 1,
    max = 5,
    desc = "ttt2_minigames_promotion_count (Def. 2)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Promotion!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  util.AddNetworkString("ttt2mg_promotion_received")
  local ttt2_minigames_promotion_count = CreateConVar("ttt2_minigames_promotion_count", "2", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Number of role choices")

  net.Receive("ttt2mg_promotion_received", function(len, ply)
    local rolename = net.ReadString()
    ply:SetRole(roles.GetByName(rolename).index)
    SendFullStateUpdate()
  end)

  function MINIGAME:OnActivation()
    local plys = util.GetFilteredPlayers(function(ply)
      return ply:Alive() and ply:IsPlayer() and not ply:IsSpec() and ply:GetSubRole() == ROLE_INNOCENT and not ply:IsBot()
    end)
    if #plys <= 0 then return end

    local ply = plys[math.random(#plys)]
    local rlsList = roles.GetList()
    local innocentRoles = {}
    local independentRoles = {}
    for i = 1, #rlsList do
      local roleData = rlsList[i]
      if not roleData:IsBaseRole() and roleData.baserole == ROLE_INNOCENT then
        innocentRoles[#innocentRoles + 1] = roleData.name
      elseif roleData:IsBaseRole() and roleData.defaultTeam ~= TEAM_INNOCENT and roleData.defaultTeam ~= TEAM_TRAITOR then
        independentRoles[#independentRoles + 1] = roleData.name
      end
    end

    local choices = {}
    for i = 1, ttt2_minigames_promotion_count:GetInt() do
      if i % 2 ~= 0 and #innocentRoles > 0 then
        local rnd = math.random(#innocentRoles)
        choices[#choices + 1] = innocentRoles[rnd]
        table.remove(innocentRoles, rnd)
      elseif #independentRoles > 0 then
        local rnd = math.random(#independentRoles)
        choices[#choices + 1] = independentRoles[rnd]
        table.remove(independentRoles, rnd)
      else
        break
      end
    end
    net.Start("ttt2mg_promotion_received")
    net.WriteTable(choices)
    net.Send(ply)
  end

  function MINIGAME:OnDeactivation()

  end
end

if CLIENT then
  net.Receive("ttt2mg_promotion_received", function()
    local choices = net.ReadTable()
    local Frame = vgui.Create("DFrame")
    Frame:SetTitle(LANG.TryTranslation("ttt2mg_promotion_frame"))
    Frame:SetPos(5, ScrH() / 3)
    Frame:SetSize(150, 10 + (20 * (#choices + 1)))
    Frame:SetVisible(true)
    Frame:SetDraggable(false)
    Frame:ShowCloseButton(false)
    for i = 1, #choices do
      local choice = choices[i]
      local Button = vgui.Create("DButton", Frame)
      -- Button:SetText(choice:gsub("^%l", string.upper))
      Button:SetText(LANG.TryTranslation(choice))
      Button:SetPos(0, 10 + (20 * i))
      Button:SetSize(150,20)
      Button.DoClick = function()
        net.Start("ttt2mg_promotion_received")
        net.WriteString(choice)
        net.SendToServer()
        Frame:Close()
      end
    end
  end)

  function MINIGAME:OnActivation()
  end

  function MINIGAME:OnDeactivation()
  end
end
