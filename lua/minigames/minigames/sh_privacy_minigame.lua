if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "We've updated our privacy policy.",
      Русский = "Мы обновили нашу политику конфиденциальности."
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
        local rolecolor = ply:GetRoleLtColor() or COLOR_ORANGE


        net.Start("privacy_mg_notif")
        net.WriteString(rolename)
        net.WriteColor(rolecolor)
        net.WriteString(equipment)
        net.Broadcast()
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTTOrderedEquipment", "PrivacyMinigameNotification")
  end
elseif CLIENT then
  net.Receive("privacy_mg_notif", function()
    local rolename = net.ReadString()
    local rolecolor = net.ReadColor()
    local equipment = net.ReadString()
    equipment = LANG.TryTranslation(equipment) or equipment

    EPOP:AddMessage({
      text = LANG.GetParamTranslation("ttt2mg_privacy_epop", {role = rolename, item = equipment}),
      color = rolecolor},
      nil,
      4,
      nil,
      true
    )
  end)
end
