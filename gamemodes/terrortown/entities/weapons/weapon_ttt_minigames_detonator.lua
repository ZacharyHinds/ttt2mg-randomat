
if CLIENT then
	SWEP.PrintName = "Detonator"
	SWEP.Slot = 7

	SWEP.ViewModelFOV = 60
else
	util.AddNetworkString("ttt2mg_update_dettarget")
end

SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.Weight = 2

SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.HoldType = "slam"
SWEP.AdminSpawnable = true
SWEP.Kind = WEAPON_NONE
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

function SWEP:SetDetTarget(ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end

	self.detTarget = ply:SteamID64()

	if SERVER then
		net.Start("ttt2mg_update_dettarget")
		net.WriteEntity(self)
		net.WriteString(self.detTarget)
		net.WriteString(ply:Nick())
		net.Send(self:GetOwner())
	end
end

function SWEP:GetDetTarget()
	return player.GetBySteamID64(self.detTarget)
end

if CLIENT then
	net.Receive("ttt2mg_update_dettarget", function()
		local det = net.ReadEntity()
		det.detTarget = net.ReadString()
		det.PrintName = LANG.GetParamTranslation("ttt2mg_randomat_detonator", {nick = net.ReadString()})

	end)
end

if SERVER then
	function SWEP:OwnerChanged()
		self:SetDetTarget(self:GetDetTarget())
	end
end

local function FindBody(ply)
	local bodies = ents.FindByClass("prop_ragdoll")
	for i = 1, #bodies do
		local rag = bodies[i]
		local player = CORPSE.GetPlayer(rag)
		if player:SteamID64() == ply:SteamID64() then
			return rag
		end
	end
	return nil
end

function SWEP:DetonateTarget()
	local owner = self:GetOwner()
	local target = self:GetDetTarget()
	if not IsValid(target) or not target:IsPlayer() then return end
	local pos = nil
	local wasAlive = true
	if not target:Alive() then
		local rag = FindBody(target)
		local wasAlive = false
		if rag then pos = rag:GetPos() end
	elseif not target:IsSpec() and not (SpecDM and target:IsGhost()) then
		pos = target:GetPos()
	end
	if not pos then return end
	if SERVER then
		local dmgInfo = DamageInfo()
		dmgInfo:SetDamage(400)
		dmgInfo:SetDamageType(DMG_BLAST)
		dmgInfo:SetInflictor(self)
		dmgInfo:SetAttacker(owner)

		
		-- events.Trigger(EVENT_TTT2MG_DETONATOR, owner, target, dmginfo, wasAlive)
		util.BlastDamageInfo(dmgInfo, pos, 230)
		
		local effect = EffectData()
		effect:SetStart(pos)
		effect:SetOrigin(pos)
		effect:SetScale(300)
		effect:SetRadius(300)
		effect:SetMagnitude(400)
		
		util.Effect("Explosion", effect, true, true)
		util.Effect("HelicopterMegaBomb", effect, true, true)
		sound.Play("ambient/explosions/explode_4.wav", pos, 95, 100, 1)

		-- local announce_mode = GetConVar("ttt2_minigames_detonators_announce"):GetInt()
		-- print("TT2 Minigame Detonator Announce Mode:", announce_mode)

		net.Start("det_announce_epop")
		net.WriteString(self:GetOwner():Nick())
		net.WriteString(target:Nick())
		net.WriteInt(GetConVar("ttt2_minigames_detonators_announce"):GetInt(), 3)
		net.Broadcast()

	else
		local pos = self:GetDetTarget():GetPos()
		local trace = util.TraceLine({
			start = pos + Vector(0, 0, 64),
			endpos = pos + Vector(0, 0, -128),
			filter = self
		})
		util.Decal("Scorch", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
	end
end


function SWEP:TauntTarget()
	local owner = self:GetOwner()
	local target = self:GetDetTarget()
	local pos = target:GetPos()
	sound.Play("weapons/c4/c4_beep1.wav", pos, 105, math.random(80, 200), 1)
end

function SWEP:Initialize()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
	-- self:SetDetTarget(self.Target)
end

function SWEP:Equip()
	local target = self:GetDetTarget()
	if not target or not IsValid(target) then return end	
	self:GetOwner():PrintMessage(HUD_PRINTTALK, "You have recieved the detonator for "..target:Nick())	

	-- if CLIENT then
	-- 	target = self:GetDetTarget()
	-- 	self.PrintName = GetParamTranslation("ttt2mg_randomat_detonator", {nick = target:Nick()})
	-- end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
	-- if CLIENT then
	-- 	local target = self:GetDetTarget() or self.Target
	-- 	self.PrintName = GeParamTranslation("ttt2mg_randomat_detonator", {nick = target:Ntick()})
	-- end
	return true
end

function SWEP:PrimaryAttack()
	self:DetonateTarget()
	if SERVER then
		self:Remove()
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		self:TauntTarget()
	end
end

if SERVER then
	hook.Add("PlayerCanPickupWeapon", "TTT2MGPreventDetPickup", function(ply, wep)
		if not IsValid(ply) or not IsValid(wep) then return end

		if wep:GetClass() ~= "weapon_ttt_minigames_detonator" then return end

		local ply_weps = ply:GetWeapons()
		for i = 1, #ply_weps do
			if ply_weps[i]:GetClass() == wep:GetClass() then return false end
		end
	end)
end