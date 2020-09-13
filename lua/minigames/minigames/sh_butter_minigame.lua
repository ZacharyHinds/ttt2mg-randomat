if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_butter_timer = {
    slider = true,
    min = 1,
    max = 30,
    desc = "(Def. 10)"
  },
  ttt2_minigames_butter_affectall = {
    checkbox = true,
    desc = "(Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Butterfingers!"
    },
    desc = {
      English = "Hold your weapons tightly!"
    }
  }
end

if SERVER then
  local ttt2_minigames_butter_timer = CreateConVar("ttt2_minigames_butter_timer", "10", {FCVAR_ARCHIVE}, "Time between each weapon drop")
  local ttt2_minigames_butter_affectall = CreateConVar("ttt2_minigames_butter_affectall", "0", {FCVAR_ARCHIVE}, "Should butterfingers affect everyone at once")
  function MINIGAME:OnActivation()
    timer.Create("ButterMinigame", ttt2_minigames_butter_timer:GetInt(), 0, function()
      local plys = util.GetAlivePlayers()
      local ply
      if ttt2_minigames_butter_affectall:GetBool() then
        for i = 1, #plys do
          ply = plys[i]
          local wep = ply:GetActiveWeapon()
          if not IsValid(wep) then continue end

          if wep.AllowDrop then
            ply:DropWeapon(wep)
            ply:SetFOV(0, 0.2)
            ply:EmitSound("vo/npc/Barney/ba_pain01.wav")
          end
        end
      else
        repeat
          if #plys <= 0 then return end
          local rnd = math.random(#plys)
          ply = plys[rnd]
          table.remove(plys, rnd)
        until IsValid(ply)
        local wep = ply:GetActiveWeapon()
        if not IsValid(wep) then return end
        if wep.AllowDrop then
          ply:DropWeapon(wep)
          ply:SetFOV(0, 0.2)
          ply:EmitSound("vo/npc/Barney/ba_pain01.wav")
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("ButterMinigame")
  end
end
