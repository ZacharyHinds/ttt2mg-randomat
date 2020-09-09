if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "We've updated our privacy policy."
    },
    desc = {
      English = ""
    }
  }
else
  util.AddNetworkString("privacy_mg_notif")
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("TTTOrderedEquipment", "PrivacyMinigameNotification", function(ply, equipment, is_item)
        local rolename = ply:GetRoleString()

        net.Start("privacy_mg_notif")
        net.WriteString(rolename)
        net.WriteEntity(ply)
        net.WriteTable(ply:GetRoleColor())
        net.WriteString(equipment)
        net.WriteBool(is_item)
        net.Broadcast()
    end)
  end

  function MINIGAME:OnDeactivation()

  end
elseif CLIENT then
  net.Receive("privacy_mg_notif", function()
    local rolename = net.ReadString()
    local rolecolor = net.ReadTable()
    local equipment = net.ReadString()

    EPOP:AddMessage({
      text = rolename .. " bought " .. equipment,
      color = rolecolor},
      "",
      2
    )
  end)
end
