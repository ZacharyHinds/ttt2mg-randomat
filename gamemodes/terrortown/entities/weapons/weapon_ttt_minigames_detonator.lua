if CLIENT then
	SWEP.PrintName = "Detonator"
	SWEP.Slot = 7

	SWEP.ViewModelFOV = 60
end

SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.Weight = 2

SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.HoldType = "slam"
SWEP.AdminSpawnable = true
SWEP.Kind = WEAPON_EQUIP2
SWEP.Target = nil

SWEP.AllowDrop = false
SWEP.NoSights = true
SWEP.UseHands = true
SWEP.LimitedStock = true
SWEP.AmmoEnt = nil

SWEP.Primary.Delay = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Cone = 0
SWEP.Primary.Ammo = nil
SWEP.Primary.ClipSize = -1
SWEP.Primary.ClipMax = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Sound = ""

if SERVER then
  function PlayerDetonate(owner, ply)
    if owner:GetSubRole() == ROLE_JESTER or owner:GetSubRole() == ROLE_MARKER then return end

    local explode = ents.Create("env_explosion")
    explode:SetPos(ply:GetPos())
    explode:SetOwner(owner)
    explode:Spawn()
    explode:SetKeyValue("iMagnitude", "230")
    explode:Fire("Explode", 0, 0)
    explode:EmitSound("ambient/explosions/explode_4.wav", 400, 400)
  end

  for _, pl in pairs(player.GetAll()) do
    pl:PrintMessage(HUD_PRINTTALK, owner:Nick() .. " has detonated " .. pl:Nick())
  end
end

function SWEP:Initialize()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
end

function SWEP:Equip()
    if not self.Target or not IsValid(self.Target) then return end
	self.Owner:PrintMessage(HUD_PRINTTALK, "You have recieved the detonator for "..self.Target:Nick())
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
	return true
end

function SWEP:PrimaryAttack()
	if SERVER then
		PlayerDetonate(self:GetOwner(), self.Target)
    self:Remove()
	end
end
