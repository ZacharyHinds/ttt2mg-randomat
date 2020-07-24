if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_texplode_timer = {
    slider = true,
    min = 1,
    max = 120,
    desc = "(Def. 60)"
  },

  ttt2_minigames_texplode_radius = {
    slider = true,
    min = 1,
    max = 1000,
    desc = "(Def. 600)"
  }
}

ttt2_minigames_texplode_timer = CreateConVar("ttt2_minigames_texplode_timer", "60", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How many credits should be available at a time?")

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Explosive Traitors"
    },
    desc = {
      English = "A traitor will explode in " .. ttt2_minigames_texplode_timer:GetInt() .. " seconds!"
    }
  }
else
  ttt2_minigames_texplode_radius = CreateConVar("ttt2_minigames_texplode_radius", "600", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  util.AddNetworkString("texplode_popup")
end

if SERVER then
  function MINIGAME:OnActivation()
    local x = 0
    local willExplode = true

    for _, ply in RandomPairs(player.GetAll()) do
      if not ply:Alive() or ply:IsSpec() then continue end

      if ply:HasTeam(TEAM_TRAITOR) then
        if willExplode then
          tgt = ply
          ply:PrintMessage(HUD_PRINTTALK, "You have been chosen to explode. Watch out, and stay close to innocents.")
          willExplode = false
        else
          ply:PrintMessage(HUD_PRINTTALK, tgt:Nick() .. " has been chosen to explode. Be careful.")
        end
      end
    end

    local effectdata = EffectData()
    local delay = ttt2_minigames_texplode_timer:GetInt()

    timer.Create("TExplodeMinigame", 1, delay, function()
      if GetRoundState() ~= ROUND_ACTIVE or not self:IsActive() then timer.Remove("TExplodeMinigame") end
      x = x + 1
      if delay >= 45 and x == delay - 30 then
        net.Start("texplode_popup")
        net.WriteString("30 seconds until the traitor explodes!")
        net.Broadcast()
      elseif delay >= 20 and x == delay - 10 then
        net.Start("texplode_popup")
        net.WriteString("10 seconds remaining!")
        net.Broadcast()
      elseif delay == x then
        net.Start("texplode_popup")
        net.WriteString("The traitor has exploded!")
        net.Broadcast()
        tgt:EmitSound("ambient/explosions/explode_4.wav")

        util.BlastDamage(tgt, tgt, tgt:GetPos(), ttt2_minigames_texplode_radius:GetInt(), 10000)

        effectdata:SetStart(tgt:GetPos() + Vector(0, 0, 10))
        effectdata:SetOrigin(tgt:GetPos() + Vector(0, 0, 10))
        effectdata:SetScale(1)

        util.Effect("HelicopterMegaBomb", effectdata)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("TExplodeMinigame")
  end

elseif CLIENT then
  net.Receive("texplode_popup", function()
    message = net.ReadString()
    if message then
      EPOP:AddMessage(
        {text = message,
        color = COLOR_ORANGE},
        "",
        2
      )
    end
  end)
end
