if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Communism"
    },
    desc = {
      English = ""
    }
  }
else
  util.AddNetworkString("ttt2_communism_orderpopup")
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("TTTOrderedEquipment", "CommunismMinigame", function(ply, equipment, is_item)
      local plys = util.GetAlivePlayers()
      for i = 1, #plys do
        local pl = plys[i]
        if pl:SteamID() == ply:SteamID() then continue end

        if not is_item then
          pl:GiveEquipmentWeapon(equipment)
        else
          pl:GiveEquipmentItem(equipment)
        end
      end
      net.Start("ttt2_communism_orderpopup")
      net.WriteString(ply:GetRoleString())
      net.WriteString(equipment)
      net.WriteTable(ply:GetRoleColor())
      net.Broadcast()
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTTOrderedEquipment", "CommunismMinigame")
  end
elseif CLIENT then
  net.Receive("ttt2_communism_orderpopup", function()
    local rolestring = net.ReadString()
    local equipment = net.ReadString()
    local rolecolor = net.ReadTable()
    EPOP:AddMessage({
      text = rolestring .. " bought everyone " .. equipment,
      color = rolecolor},
      "",
      2
    )
  end)
end
