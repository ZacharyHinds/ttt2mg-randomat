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
    desc = "(Def. 15)"
  },

  ttt2_minigames_malfunction_lw = {
    slider = true,
    min = 0,
    max = 60,
    desc = "(Def. 1)"
  },

  ttt2_minigames_malfunction_all = {
    checkbox = true,
    desc = "(Def. 0)"
  },

  ttt2_minigames_malfunction_dur = {
    slider = true,
    min = 0,
    max = 3,
    decimal = 1,
    desc = "(Def. 0.5)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Malfunction!"
    },
    desc = {
      English = ""
    }
  }
else
  ttt2_minigames_malfunction_up = CreateConVar("ttt2_minigames_malfunction_up", "15", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  ttt2_minigames_malfunction_lw = CreateConVar("ttt2_minigames_malfunction_lw", "1", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  ttt2_minigames_malfunction_all = CreateConVar("ttt2_minigames_malfunction_all", "0", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  ttt2_minigames_malfunction_dur = CreateConVar("ttt2_minigames_malfunction_dur", "0.5", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
end

if SERVER then
  function MINIGAME:OnActivation()
    local x = 0
    local wep = 0
    timer.Create("MalfunctionMinigame", math.random(ttt2_minigames_malfunction_lw:GetInt(), ttt2_minigames_malfunction_up:GetInt()), 0, function()
      for _, ply in ipairs(player.GetAll()) do
        if ply:IsSpec() or not ply:Alive() then continue end

        if x == 0 or ttt2_minigames_malfunction_all:GetBool() then
          wep = ply:GetActiveWeapon()
          local dur = ttt2_minigames_malfunction_dur:GetFloat()
          local repeats = math.floor(dur / wep.Primary.Delay) + 1
          timer.Create("MalfunctionMinigameFire", wep.Primary.Delay, repeats, function()
            if wep:Clip1() ~= 0 then
              wep:PrimaryAttack()
              wep:SetNextPrimaryFire(CurTime() + wep.Primary.Delay)
            end
          end)
          x = 1
        end
      end
      x = 0
      timer.Adjust("MalfunctionMinigame", math.random(ttt2_minigames_malfunction_lw:GetInt(), ttt2_minigames_malfunction_up:GetInt()))
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MalfunctionMinigame")
    timer.Remove("MalfunctionMinigameFire")
  end
end
