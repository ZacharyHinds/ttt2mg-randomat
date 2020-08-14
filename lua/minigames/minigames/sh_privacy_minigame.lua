if SERVER then
  AddCSLuaFile()
end

-- include("enhancednotificationscore/shared.lua")

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
        rolename = ply:GetRoleString()
        rolename = string.gsub("^%a", string.upper)

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
  local tbl = {}
  local role = {}
  local function GetEquipmentTranslation(name, printName)
    local SafeTranslation = LANG.TryTranslation
    local translatedText = SafeTranslation(printName)
    if translatedText == printName and name then
      translatedText = SafeTranslate(name)
    end

    if translatedText == name and printName then
      translatedText = printName
    end

    return translatedText
  end

  net.Receive("privacy_mg_notif", function()
    local rolename = net.ReadString()
    local ply = net.ReadEntity()
    local rolecolor = net.ReadTable()
    local equipment = net.ReadString()
    local is_item = net.ReadBool()

    local curRole = ply:GetSubRole()

    if tbl == nil or role ~= curRole then
      tbl = GetEquipmentForRole(ply, curRole, true)
      role = curRole
    end

    local itemObject = nil

    if is_item then
      for _, item in pairs(tbl) do
        itemObject = item
        break
      end
    else
      itemObject = weapons.GetStored(equipment)
    end

    local itemName = itemObject and GetEquipmentTranslation(itemObject.name, itemObject.PrintName) or "Undefined"
    local itemMaterial = itemObject and (itemObject.material or itemObject.Icon) or "vgui/ttt/tbn_ic_default"

    local bgColor = Color(255, 0, 0)

    bgColor = rolecolor

    bgColor.a = 240

    local message = 'bought "' .. itemName .. '"'
    local mat = Material(itemMaterial)
    MSTACK:AddImagedMessage(message, mat, rolename)

    chat.AddText(Color(255, 255, 255), rolename, Color(200, 200, 200), " bought ", Color(255, 255, 255), itemName)
  end)

end
