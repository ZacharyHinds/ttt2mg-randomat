if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_murder_knife_dmg = {
    slider = true,
    min = 1,
    max = 1000,
    desc = "(Def. 100)"
  },

  ttt2_minigames_murder_knife_speed = {
    slider = true,
    min = 1,
    max = 2,
    decimal = 1,
    desc = "(Def. 1.2)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Murder"
    },
    desc = {
      English = ""
    }
  }
else
  util.AddNetworkString("MurderMinigameActive")
end

function IsEvil(ply)
  if not ply:HasTeam(TEAM_INNOCENT) then
    return true
  else
    return false
  end
end

if SERVER then
  local ttt2_minigames_murder_knife_speed = CreateConVar("ttt2_minigames_murder_knife_speed", "1.2", {FCVAR_ARCHIVE}, "Murder knife speed")
  function StripBannedWeapons(ply)
    for _, wep in ipairs(ply:GetWeapons()) do
      if wep.ClassName == "weapon_ttt_minigame_murknife" then continue end
      if wep.ClassName == "weapon_ttt_minigames_murrevolver" then continue end
      if wep.ClassName == "weapon_ttt_unarmed" or wep.ClassName == "weapon_zm_carry" then continue end
      ply:StripWeapon(wep.ClassName)
      ply:SetFOV(0, 0.2)
      -- print("[TTT2][sh_murder_minigame] Stripped " .. ply:Nick() .. " " .. wep.ClassName)
    end
  end


  function MINIGAME:OnActivation()
    plys = {}
    for _, ply in ipairs(player.GetAll()) do
      if not ply:Alive() or ply:IsSpec() then continue end

      plys[#plys + 1] = ply
    end

    local wep_spawns = 0

    for _, ent in ipairs(ents.GetAll()) do
      if ent.Base == "weapon_tttbase" and ent.AutoSpawnable then
        wep_spawns = wep_spawns + 1
      end
    end

    local pck = math.ceil(wep_spawns / #plys)
    net.Start("MurderMinigameActive")
    net.WriteBool(true)
    net.WriteInt(pck, 32)
    net.Broadcast()

    for _, ply in ipairs(plys) do
      if ply:GetBaseRole() == ROLE_DETECTIVE or ply:GetSubRole() == ROLE_DETECTIVE then
        timer.Create("MinigameMurderRevolverTimer" .. ply:Nick(), 0.15, 1, function()
          ply:GiveEquipmentWeapon("weapon_ttt_minigames_murrevolver")
          -- print("[TTT2][sh_murder_minigame] Gave " .. ply:Nick() .. " weapon_ttt_minigames_murrevolver")
          StripBannedWeapons(ply)
        end)
      elseif ply:GetTeam() == TEAM_TRAITOR or ply:GetBaseRole() == ROLE_TRAITOR then
        if ply:GetSubRole() ~= ROLE_TRAITOR then
          ply:SetRole(ROLE_TRAITOR)
          -- print("[TTT2][sh_murder_minigame] Forced " .. ply:Nick() .. " base traitor")
        end
        ply:SetCredits(0)
        SendFullStateUpdate()
        timer.Create("MinigameMurderKnifeTimer" .. ply:Nick(), 0.15, 1, function()
          ply:GiveEquipmentWeapon("weapon_ttt_minigame_murknife")
          -- print("[TTT2][sh_murder_minigame] Gave " .. ply:Nick() .. " weapon_ttt_minigame_murknife")
          StripBannedWeapons(ply)
        end)
      elseif ply:GetSubRole() ~= ROLE_INNOCENT then
        ply:SetRole(ROLE_INNOCENT, TEAM_INNOCENT)
        SendFullStateUpdate()
      else
        -- print("[TTT2][sh_murder_minigame] Did nothing to " .. ply:Nick())
      end

      -- if ply:HasTeam(TEAM_TRAITOR) then ply:Give("weapon_ttt_minigame_murknife") end
      -- if ply:GetBaseRole() == ROLE_DETECTIVE then ply:Give("weapon_ttt_minigames_murrevolver") end

      if ply:GetBaseRole() == ROLE_INNOCENT then
        ply:PrintMessage(HUD_PRINTTALK, "Stay alive and gather weapons! Gathering " .. pck .. " weapons will give you a revolver!")
      end
    end
    SendFullStateUpdate()

    timer.Create("MinigameMurderWepTimer", 0.1, 0, function()
      for _, ply in ipairs(plys) do
        if not ply:Alive() or ply:IsSpec() then continue end
        StripBannedWeapons(ply)

        if not ply:HasTeam(TEAM_TRAITOR) and ply:GetNWInt("MinigameMurderWepsEquipped", 0) >= pck then
          ply:SetNWInt("MinigameMurderWepsEquipped", 0)
          ply:Give("weapon_ttt_minigames_murrevolver")
          ply:SetNWBool("MgMurderRevoler", true)
        end
      end
    end)

    hook.Add("WeaponEquip", "MinigameMurderPickup", function(wep, ply)
      if wep.ClassName ~= "weapon_ttt_minigames_murrevolver" and (wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL or wep.Kind == WEAPON_NADE) then
        ply:SetNWInt("MinigameMurderWepsEquipped", ply:GetNWInt("MinigameMurderWepsEquipped", 0) + 1)
      end
    end)

    hook.Add("TTTPlayerSpeed", "MinigameMurderSpeed", function(ply)
      if ply:GetActiveWeapon().ClassName == "weapon_ttt_minigame_murknife" then
        return ttt2_minigames_murder_knife_speed:GetFloat()
      else
        return 1
      end
    end)

    hook.Add("TTT2PostPlayerDeath", "MinigameMurderDrop", function(ply, _, attacker)
      if not IsValid(ply) then return end

      print("[sh_murder_minigame] Found attacker: " .. attacker:Nick())
      if not IsValid(attacker) then return end
      if attacker:GetActiveWeapon().ClassName ~= "weapon_ttt_minigames_murrevolver" then return end

      attacker:DropWeapon(attacker:GetActiveWeapon())
      attacker:SetNWBool("MinigameMurderBlind", true)
      timer.Create("MgMurderBlindEndDelay" .. ply:Nick(), 5, 1, function()
        attacker:SetNWBool("MinigameMurderBlind", false)
      end)
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MinigameMurderWepTimer")

    hook.Remove("WeaponEquip", "MinigameMurderPickup")
    hook.Remove("TTTPlayerSpeed", "MinigameMurderSpeed")
    hook.Remove("PostPlayerDeath", "MinigameMurderDrop")

    for _, ply in ipairs(player.GetAll()) do
      timer.Remove("MinigameMurderRevolverTimer" .. ply:Nick())
      timer.Remove("MinigameMurderKnifeTimer" .. ply:Nick())
      ply:SetNWInt("MinigameMurderWepsEquipped", 0)
      ply:SetNWBool("MgMurderRevolver", false)
    end

    net.Start("MurderMinigameActive")
    net.WriteBool(false)
    net.Broadcast()

  end
end

if CLIENT then
  local Revolvers = {}
  hook.Add("PreDrawHalos", "MgMurderGunHighlight", function()
    for _, wep in ipairs(ents.FindByClass("weapon_ttt_minigames_murrevolver")) do
      if #table.KeysFromValue(player.GetAll(), wep.Owner) ~= 0 then
  			table.RemoveByValue(Revolvers, wep)
  		elseif #table.KeysFromValue(Revolvers,wep) == 0 then
  			table.insert(Revolvers, wep)
  		end
  	end
  	halo.Add(Revolvers, Color(0,255,0), 1, 1, 10)
  end)

  function BlindPlayer(i)
    local client = LocalPlayer()
    surface.SetDrawColor(0, 0, 0, i * 5)
    surface.DrawRect(0, 0, surface.ScreenWidth(), surface.ScreenHeight())
  end

  local i = 0
  hook.Add("DrawOverlay", "MgMurderBlind", function()
    local client = LocalPlayer()
    if client:GetNWBool("MinigameMurderBlind", false) then
      -- print("[TTT2][sh_murder_minigame] Blinding: " .. client:Nick() .. " " .. i)
      i = i + 1
      BlindPlayer(i)
    elseif i > 0 then
      i = math.max(i - 2, 0)
      BlindPlayer(i)
    else
      i = 0
    end
  end)

  net.Receive("MurderEventActive", function()
  	if net.ReadBool() then
  		local maxpck = net.ReadInt(32)
  		surface.CreateFont("HealthAmmo", {font = "Trebuchet24", size = 24, weight = 750})

  		hook.Add("DrawOverlay", "RandomatMurderUI", function()
  			local pl = LocalPlayer()
  			local pks = pl:GetNWInt("MinigameMurderWepsEquipped")
  			local text = string.format("%i / %02i", pks, maxpck)

  			local y = ScrH() - 55

        if pl:HasTeam(TEAM_TRAITOR) and pl:Alive() and not pl:IsSpec() and not pl:GetNWBool("MgMurderRevolver") then
          local texttable = {}
          texttable.font = "HealthAmmo"
          texttable.color = COLOR_WHITE
          texttable.pos = { 230, y+24 }
          texttable.text = text
          texttable.xalign = TEXT_ALIGN_RIGHT
          texttable.yalign = TEXT_ALIGN_BOTTOM
          draw.RoundedBox(8, 19.6, y, 230, 25, Color(0, 0, 0, 175))
          draw.RoundedBox(8, 19.6, y, (pks/maxpck)*230, 25, Color(205, 155, 0, 255))
          draw.TextShadow(texttable, 2)
  			end
  		end)
  	else
  		hook.Remove("DrawOverlay", "RandomatMurderUI")
  	end
  end)

  function MINIGAME:OnDeactivation()
    hook.Remove("DrawOverlay", "MgMurderBlind")
  end
end
