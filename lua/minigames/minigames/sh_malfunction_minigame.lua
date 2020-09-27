if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_malfunction_up = {
    slider = true,
    min = 1,
    max = 60,
    desc = "ttt2_minigames_malfunction_up (Def. 15)"
  },

  ttt2_minigames_malfunction_lw = {
    slider = true,
    min = 0,
    max = 60,
    desc = "ttt2_minigames_malfunction_lw (Def. 1)"
  },

  ttt2_minigames_malfunction_all = {
    checkbox = true,
    desc = "ttt2_minigames_malfunction_all (Def. 0)"
  },

  ttt2_minigames_malfunction_dur = {
    slider = true,
    min = 0,
    max = 3,
    decimal = 1,
    desc = "ttt2_minigames_malfunction_dur (Def. 0.5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Malfunction!"
      Русский = "Неисправность!"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  local ttt2_minigames_malfunction_up = CreateConVar("ttt2_minigames_malfunction_up", "15", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  local ttt2_minigames_malfunction_lw = CreateConVar("ttt2_minigames_malfunction_lw", "1", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  local ttt2_minigames_malfunction_all = CreateConVar("ttt2_minigames_malfunction_all", "0", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  local ttt2_minigames_malfunction_dur = CreateConVar("ttt2_minigames_malfunction_dur", "0.5", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  function MINIGAME:OnActivation()
    local wep = 0
    local plys = player.GetAll()
    timer.Create("MalfunctionMinigame", math.random(ttt2_minigames_malfunction_lw:GetInt(), ttt2_minigames_malfunction_up:GetInt()), 0, function()
      local target_plys = {}
      if ttt2_minigames_malfunction_all:GetBool() then
        for i = 1, #plys do
          if not plys[i]:Alive() or plys[i]:IsSpec() then continue end
          target_plys[#target_plys + 1] = plys[i]
        end
      else
        target_plys[1] = plys[math.random(#plys)]
      end

      for i = 1, #target_plys do
        local ply = target_plys[i]
        if ply:IsSpec() or not ply:Alive() then continue end
        wep = ply:GetActiveWeapon()
        local dur = ttt2_minigames_malfunction_dur:GetFloat()
        if not wep.Primary then continue end
        local repeats = math.floor(dur / wep.Primary.Delay) + 1

        timer.Create("MalfunctionMinigameFire", wep.Primary.Delay, repeats, function()
          if wep:Clip1() == 0 then return end
          wep:PrimaryAttack()
          wep:SetNextPrimaryFire(CurTime() + wep.Primary.Delay)
        end)
      end
      timer.Adjust("MalfunctionMinigame", math.random(ttt2_minigames_malfunction_lw:GetInt(), ttt2_minigames_malfunction_up:GetInt()))
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MalfunctionMinigame")
    timer.Remove("MalfunctionMinigameFire")
  end
end
