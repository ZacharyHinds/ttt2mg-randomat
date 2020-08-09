
-- include("includes/modules/minigames.lua")
if SERVER then
  include("minigames/engine/sh_functions.lua")
  AddCSLuaFile()
elseif CLIENT then
  SWEP.ViewModelFOV = 60
  SWEP.ViewModelFlip = false

  SWEP.EquipMenuData = {
    type = "weapon",
    name = "Randommat X",
    desc = "Randomat X starts a random minigame!"
  }

  SWEP.Icon = "VGUI/ttt/icon_randomat"

  function SWEP:PrimaryAttack() end
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP2
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.HoldType = "slam"
SWEP.AdminSpawnable = true
SWEP.AutoSwitchFrom = false
SWEP.AutoSwithTo = false

SWEP.AllowDrop = false
SWEP.NoSights = true
SWEP.UseHands = true
SWEP.CanBuy = {ROLE_DETECTIVE}

SWEP.ViewModel = "models/weapons/gamefreak/c_csgo_c4.mdl"
SWEP.WorldModel = "models/weapons/gamefreak/w_c4_planted.mdl"
SWEP.Weight = 2

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipsSize = 1
SWEP.Primary.DefaultClip = 1

function SWEP:SelectGame()
  if SERVER then
    local mgs = minigames.GetList()

    if #mgs == 0 then return end

    local availableMinigames = {}
    local forcedNextMinigame = minigames.GetForcedNextMinigame()

    for i = 1, #mgs do
      local minigame = mgs[i]

      if not GetConVar("ttt2_minigames_" .. minigame.name .. "_enabled"):GetBool() or not minigame:IsSelectable() then continue end

      if forcedNextMinigame and forcedNextMinigame.name == minigame.name then
        forcedNextMinigame = nil
        return minigame
      end

      local b = true

      local r = GetConVar("ttt2_minigames_" .. minigame.name .. "_random"):GetInt()

      if r > 0 and r < 100 then
        b = math.random(100) <= r
      elseif r <= 0 then
        b = false
      end

      if b then
        availableMinigames[#availableMinigames + 1] = minigame
      end
    end

    if #availableMinigames == 0 then return end

    return availableMinigames[math.random(#availableMinigames)]
  end
end

function SWEP:Initialize()
  util.PrecacheSound("weapons/c4_initiate.wav")
end

function SWEP:PrimaryAttack()
  if SERVER then
    print("1")
    minigame = self:SelectGame()
    if not minigame then self:Remove() return end
    print("Minigame Found")

    ActivateMinigame(minigame)
    print("Minigame Activated")

    DamageLog("[TTT2][MINIGAME] : " .. self:GetOwner():Nick() .. " [" .. self.Owner:GetRoleString() .. "] used their Gameboy")
    self:SetNextPrimaryFire(CurTime() + 10)

    self:Remove()
  end
end

function SWEP:SecondaryAttack()

end
