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
end

if SERVER then
  function GiveRandomWeapon(ply)
    if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then return end
    if ply.randomweptries == 100 then ply.randomweptries = nil return end
    ply.randomweptries = ply.randomweptries + 1

    local weps = weapons.GetList()
    local pocket_weps = {}
    for i = 1, #weps do
      local wep = weps[i]
      if wep and wep.CanBuy then
        pocket_weps[#pocket_weps + 1] = wep
      end
    end
    local item = pocket_weps[math.random(#pocket_weps)]
    local is_item = tonumber(item.id)
    local swep_table = (not is_item) and weapons.GetStored(item.ClassName) or nil

    if is_item then
      if ply:HasEquipmentItem(is_item) then
        GiveRandomWeapon(ply)
      else
        ply:GiveEquipmentItem(is_item)
        ply.randomweptries = 0
      end
    elseif swep_table then
      if ply:CanCarryWeapon(swep_table) then
        ply:Give(item.ClassName)
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
