if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_explode_timer = {
    slider = true,
    min = 1,
    max = 120,
    desc = "(Def. 30)"
  }
}

ttt2_minigames_explode_timer = CreateConVar("ttt2_minigames_explode_timer", "30", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Delay between explosions")

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Random Player Explosions!"
    },
    desc = {
      English = "A Random Person Will Explode every " .. ttt2_minigames_explode_timer:GetInt() .. " seconds!"
    }
  }
else
  util.AddNetworkString("explosion_minigame_exploded")
end

if SERVER then
  function MINIGAME:OnActivation()

    local effectdata = EffectData()

    timer.Create("MinigameExplode", ttt2_minigames_explode_timer:GetInt(), 0, function()
      local plys = {}
      for _, ply in ipairs(player.GetAll()) do
        if ply:GetBaseRole() ~= ROLE_DETECTIVE then
          table.insert(plys, ply)
        end
      end


      local ply = plys[math.random(#plys)]

      if IsValid(ply) and ply:Alive() and not ply:IsSpec() then
        net.Start("explosion_minigame_exploded")
        net.WriteString(ply:Nick())
        net.Broadcast()

        ply:EmitSound(Sound("ambient/explosions/explode_4.wav"))

        util.BlastDamage(ply, ply, ply:GetPos(), 300, 10000)

        effectdata:SetStart(ply:GetPos() + Vector(0, 0, 10))
        effectdata:SetOrigin(ply:GetPos() + Vector(0, 0, 10))
        effectdata:SetScale(1)

        util.Effect("HelicopterMegaBomb", effectdata)
      else
        net.Start("explosion_minigame_exploded")
        net.WriteString("No one")
        net.Broadcast()
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("MinigameExplode")
  end
end

if CLIENT then
  net.Receive("explosion_minigame_exploded", function()
    local name = net.ReadString()

    EPOP:AddMessage({
      text = name .. " exploded!",
      color = COLOR_ORANGE,
      6
    })
  end)
end
