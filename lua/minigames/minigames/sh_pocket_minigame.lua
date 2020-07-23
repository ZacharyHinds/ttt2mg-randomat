if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "What did I find in my pocket?"
    },
    desc = {
      English = ""
    }
  }
else
end

if SERVER then
  function GiveRandomWeapon(ply)
    if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then return end
    if ply.randomweptries == 100 then ply.randomweptries = nil return end
    ply.randomweptries = ply.randomweptries + 1

    local weps = {}
    for _, wep in ipairs(weapons.GetList()) do
      if wep and wep.CanBuy then
        table.insert(weps, wep)
      end
    end
    table.Shuffle(weps)
    local item = table.Random(weps)
    local is_item = tonumber(item.id)
    local swep_table = (not is_item) and weapons.GetStored(item.ClassName) or nil

    if is_item then
      if ply:HasEquipmentItem(is_item) then
        GiveRandomWeapon(ply)
      else
        ply:GiveEquipmentItem(is_item)
        hook.Call("TTTOrderedEquipment", ply, is_item, true)
        hook.Call("TTT2OrderedEquipment", ply, is_item, true, 0, true)
        ply.randomweptries = 0
      end
    elseif swep_table then
      if ply:CanCarryWeapon(swep_table) then
        ply:Give(item.ClassName)
        hook.Call("TTTOrderedEquipment", ply, item.ClassName, false)
        hook.Call("TTT2OrderedEquipment", ply, item.ClassName, false, 0, true)
        if swep_table.WasBought then
          swep_table:WasBought(ply)
        end
        ply.randomweptries = 0
      else
        GiveRandomWeapon(ply)
      end
    end
  end

  function MINIGAME:OnActivation()
    timer.Simple(0.1, function()
      for _, ply in ipairs(player.GetAll()) do
        if not ply:Alive() or ply:IsSpec() then continue end
        ply.randomweptries = 0
        GiveRandomWeapon(ply)
      end
    end)
  end

  function MINIGAME:OnDeactivation()

  end
end
