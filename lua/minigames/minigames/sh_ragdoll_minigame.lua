if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Bad Trip"
      Русский = "Бэд трип"
    },
    desc = {
      English = "Watch your step!"
      Русский = "Смотри под ноги!"
    }
  }
end

if SERVER then
  local newPos
  local function PlayerStuck(ply)
    local trace = {
      start = ply:GetPos(),
      endpos = nil,
      mask = MASK_PLAYERSOLID,
      filter = ply
    }
    trace.endpos = trace.start
    if util.TraceEntity(trace, ply).StartSolid == false then
      print("[Ragdoll Minigame] " .. ply:Nick() .. " is stuck")
      return true
    else
      print("[Ragdoll Minigame] " .. ply:Nick() .. " is not stuck")
      return false
    end
    -- return util.TraceEntity(trace, ply).StartSolid ~= true
  end

  local function FindSpace(ply, direction, step)
    print("[Ragdoll Minigame] Finding Space for " .. ply:Nick())
    local i = 0
    while (i < 100) do
      local origin = ply:GetPos()
      origin = origin + step * direction
      ply:SetPos(origin)
      if not PlayerStuck(ply) then
        newPos = origin
        print("[Ragdoll Minigame] Space Found")
        return true
      end
      i = i + 1
    end
    print("[Ragdoll Minigame] Space Not Found")
    return false
  end

  local function UnstuckPly(ply)
    local oldPos = ply:GetPos()
    newPos = oldPos

    if not PlayerStuck(ply) then
      print("[Ragdoll Minigame] Fixing Player: " .. ply:Nick())
      local angle = ply:GetAngles()
      local forward = angle:Forward()
      local right = angle:Right()
      local up = angle:Up()

      local SearchScale = 1

      if not FindSpace(ply, forward, SearchScale) and
        not FindSpace(ply, right, SearchScale) and
        not FindSpace(ply, right, -SearchScale) and
        not FindSpace(ply, up, SearchScale) and
        not FindSpace(ply, up, -SearchScale) and
        not FindSpace(ply, forward, -SearchScale)
      then
        print("[Ragdoll Minigame] Unstuck Failed for " .. ply:Nick())
        return false
      end
      if oldPos == newPos then
        print("[Ragdoll Minigame] " .. ply:Nick() .. " is already unstuck!")
        return true
      else
        ply:SetPos(newPos)
        if ply and ply:IsValid() and ply:GetPhysicsObject():IsValid() then
          if ply:IsPlayer() then
            ply:SetVelocity(vector_origin)
          end
          ply:GetPhysicsObject():SetVelocity(vector_origin)
        end
        print("[Ragdoll Minigame] Unstuck succeeded for " .. ply:Nick())
        return true
      end
    end
  end

  local function unragdollPly(ply)
    print("[Ragdoll Minigame] Unragdolling " .. ply:Nick())
    ply.inRagdoll = false
    ply:SetParent()

    local ragdoll = ply.ragdoll
    ply.ragdoll = nil

    ply:Spawn()

    if ragdoll:IsValid() then
      local pos = ragdoll:GetPos()
      -- pos.z = pos.z + 10
      ply:SetPos(pos)
      ply:SetVelocity(ragdoll:GetVelocity())
      local yaw = ragdoll:GetAngles().yaw
      ply:SetAngles(Angle(0, yaw, 0))
      ragdoll:DisallowDeleting(false)
      ragdoll:Remove()
    end

    ply:SetHealth(ply.spawnInfo.health)
    for i = 1, #ply.spawnInfo.weps do
      local wep = ply.spawnInfo.weps[i]
      local plywep = ply:GetWeapon(wep)
      if wep.Clip then
        plywep:SetClip1(plywep.Clip)
      end
      ply:SetAmmo(wep.Reserve, plywep:GetPrimaryAmmoType(), true)
    end
    ply:SelectWeapon(ply.spawnInfo.activeWeapon)

    if #ply.spawnInfo.equipment >= 1 then
      for i = 1, #ply.spawnInfo.equipment do
        ply:GiveEquipmentItem(ply.spawnInfo.equipment[i])
      end
    end
    ply:DropToFloor()
    ply.DroppingToGround = true

    timer.Simple(0.1, function()
      ply.DroppingToGround = nil
      if ply:IsInWorld() then
        UnstuckPly(ply)
      end
    end)
  end

  local function ragdollPly(ply)
    print("[Ragdoll Minigame] Ragdolling " .. ply:Nick())
    ply.inRagdoll = true
    ply.spawnInfo = {}

    local weps = {}
    local plyweps = ply:GetWeapons()
    for i = 1, #plyweps do
      local wep = plyweps[i]
      weps[wep.ClassName] = {}
      weps[wep.ClassName].Clip = wep:Clip1()
      weps[wep.ClassName].Reserve = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
    end

    local equipment = {}
    equipment[EQUIP_RADAR] = false
    equipment[EQUIP_ARMOR] = false
    equipment[EQUIP_DISGUISE] = false

    if ply:HasEquipmentItem(EQUIP_RADAR) then
      equipment[EQUIP_RADAR] = true
    end
    if ply:HasEquipmentItem(EQUIP_ARMOR) then
      equipment[EQUIP_ARMOR] = true
    end
    if ply:HasEquipmentItem(EQUIP_DISGUISE) then
      equipment[EQUIP_DISGUISE] = true
    end

    local info = {}
    info.weps = weps
    info.activeWeapon = ply:GetActiveWeapon().ClassName
    info.health = ply:Health()
    info.credits = ply:GetCredits()
    info.equipment = equipment
    ply.spawnInfo = info

    local ragdoll = ents.Create("prop_ragdoll")
    ragdoll.ragdolledPly = ply
    ragdoll:SetPos(ply:GetPos())
    local velocity = ply:GetVelocity()
    ragdoll:SetAngles(ply:GetAngles())
    ragdoll:SetModel(ply:GetModel())
    ragdoll:Spawn()
    ply:SetParent(ragdoll)

    for i = 1, ragdoll:GetPhysicsObjectCount() do
      local phys_obj = ragdoll:GetPhysicsObject(i - 1)
      phys_obj:SetVelocity(velocity)
    end
    ragdoll:Activate()

    ply:Spectate(OBS_MODE_CHASE)
    ply:SpectateEntity(ragdoll)
    ply:StripWeapons()

    ragdoll:DisallowDeleting(true, function(old, new)
      if ply:IsValid() then ply.ragdoll = new end
    end)

    ply.ragdoll = ragdoll
    hook.Add("Think", ply:Nick() .. "UnragdollTimer", function()
      if IsValid(ragdoll) and ragdoll:GetPhysicsObject(1):GetVelocity():Length() <= 10 then
        unragdollPly(ply)
        hook.Remove("Think", ply:Nick() .. "UnragdollTimer")
      end
    end)
  end

  function MINIGAME:OnActivation()
    local plys = player.GetAll()
    for i = 1, #plys do
      plys[i].inRagdoll = false
    end
    -- local delay = CurTime() + 1
    hook.Add("Think", "RagdollMinigameAirCheck", function()
      -- if delay > CurTime() then return end
      plys = util.GetAlivePlayers()
      for i = 1, #plys do
        local ply = plys[i]
        if not ply:IsOnGround() and not ply.inRagdoll and ply:WaterLevel() == 0 and not ply.DroppingToGround then
          ragdollPly(ply)
        end
      end
      -- delay = CurTime() + 1
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("Think", "RagdollMinigameAirCheck")
  end

  function MINIGAME:IsSelectable()
    return false -- Broken so don't run
  end
end
