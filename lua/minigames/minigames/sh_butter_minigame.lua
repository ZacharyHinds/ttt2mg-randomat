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
else
  ttt2_minigames_butter_timer = CreateConVar("ttt2_minigames_butter_timer", "10", {FCVAR_ARCHIVE}, "Time between each weapon drop")
  ttt2_minigames_butter_affectall = CreateConVar("ttt2_minigames_butter_affectall", "0", {FCVAR_ARCHIVE}, "Should butterfingers affect everyone at once")
end

if SERVER then
  function MINIGAME:OnActivation()
    local x = 0
    timer.Create("ButterMinigame", ttt2_minigames_butter_timer:GetInt(), 0, function()
      for _, ply in ipairs(player.GetAll()) do
        if not ply:Alive() or ply:IsSpec() then continue end

        x = x + 1
        if x == 1 or ttt2_minigames_butter_affectall:GetBool() then
          if ply:GetActiveWeapon().AllowDrop then
            ply:DropWeapon(ply:GetActiveWeapon())
            ply:SetFOV(0, 0.2)
            ply:EmitSound("vo/npc/Barney/ba_pain01.wav")
          end
        end
      end
      x = 0
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("ButterMinigame")
  end
end
