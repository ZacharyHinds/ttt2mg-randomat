if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted, Based on Randomat event by Owningle"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_recoil_max = {
    slider = true,
    min = 1000,
    max = 2000000,
    decimal = 0,
    desc = "ttt2_minigames_recoil_max (Def. 150000)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Recoil"
    },
    desc = {
      English = "It's a helluva kick"
    }
  }
end

if SERVER then
  local ttt2_minigames_recoil_max = CreateConVar("ttt2_minigames_recoil_max", "150000", {FCVAR_ARCHIVE}, "ttt2_minigames_recoil_max")
  function MINIGAME:OnActivation()
    hook.Add("EntityFireBullets", "MinigameRecoil", function(ply, data)
      if not ply:IsPlayer() then return end

      local velocity = ply:GetVelocity()
      local ply_vec = Vector(ply:EyePos().x - ply:GetEyeTrace().HitPos.x, ply:EyePos().y - ply:GetEyeTrace().HitPos.y, ply:EyePos().z - ply:GetEyeTrace().HitPos.z)
      ply_vec:Normalize()
      velocity = ply_vec * math.exp(tonumber(math.pow(data.Damage / 2, 1 / 2))) * 4.8 * data.Num
      if velocity:Length() > ttt2_minigames_recoil_max:GetInt() then
        velocity = (velocity / velocity:Length()) * ttt2_minigames_recoil_max:GetInt()
      end
      ply:SetVelocity(velocity)
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("EntityFireBullets", "MinigameRecoil")
  end
end
