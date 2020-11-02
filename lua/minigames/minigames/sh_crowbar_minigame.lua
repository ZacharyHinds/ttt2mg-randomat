if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_crowbar_dmg = {
    slider = true,
    min = 1,
    max = 10,
    decimal = 1,
    desc = "ttt2_minigames_crowbar_dmg (Def. 2.5)"
  },
  ttt2_minigames_crowbar_push = {
    slider = true,
    min = 1,
    max = 100,
    desc = "ttt2_minigames_crowbar_push (Def. 20)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "The 'bar has been raised!",
      Русский = "Бар был поднят на воздух!"
    },
    desc = {
      English = ""
    }
  }

end

if SERVER then
  local ttt2_minigames_crowbar_dmg = CreateConVar("ttt2_minigames_crowbar_dmg", "2.5", {FCVAR_ARCHIVE}, "Damage Multiplier for the crowbar")
  local ttt2_minigames_crowbar_push = CreateConVar("ttt2_minigames_crowbar_push", "20", {FCVAR_ARCHIVE}, "Push force multiplier for the crowbar")
  local push
  function MINIGAME:OnActivation()
    push = GetConVar("ttt_crowbar_pushforce"):GetInt()
    RunConsoleCommand("ttt_crowbar_pushforce", push * ttt2_minigames_crowbar_push:GetFloat())
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local weps = plys[i]:GetWeapons()
      for j = 1, #weps do
        local wep = weps[j]
        if wep:GetClass() == "weapon_zm_improvised" then
          wep.Primary.Damage = wep.Primary.Damage * ttt2_minigames_crowbar_dmg:GetFloat()
          break
        end
      end
    end
  end

  function MINIGAME:OnDeactivation()
    RunConsoleCommand("ttt_crowbar_pushforce", push)
    local plys = util.GetAlivePlayers()
    for i = 1, #plys do
      local weps = plys[i]:GetWeapons()
      for j = 1, #weps do
        local wep = weps[j]
        if wep:GetClass() == "weapon_zm_improvised" then
          wep.Primary.Damage = wep.Primary.Damage / ttt2_minigames_crowbar_dmg:GetFloat()
          break
        end
      end
    end
  end
end
