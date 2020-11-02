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
    desc = "ttt2_minigames_texplode_timer (Def. 60)"
  },

  ttt2_minigames_texplode_radius = {
    slider = true,
    min = 1,
    max = 1000,
    desc = "ttt2_minigames_texplode_radius (Def. 600)"
  }
}


if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Explosive Traitors",
      Русский = "Взрывоопасные предатели"
    },
    desc = {
      English = "A traitor will explode in {time} seconds",
      Русский = "Предатель взорвётся через {time} сек.!"
    }
  }
else
  util.AddNetworkString("texplode_popup")
  util.AddNetworkString("ttt2mg_texplode_epop")
end

if SERVER then
local ttt2_minigames_texplode_timer = CreateConVar("ttt2_minigames_texplode_timer", "60", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How many credits should be available at a time?")
local ttt2_minigames_texplode_radius = CreateConVar("ttt2_minigames_texplode_radius", "600", {FCVAR_ARCHIVE}, "How many credits should be available at a time?")
  function MINIGAME:ShowActivationEPOP()
    net.Start("ttt2mg_texplode_epop")
    net.WriteInt(ttt2_minigames_explode_timer:GetInt(), 32)
    net.WriteString(self.name)
    net.Broadcast()
  end
  function MINIGAME:OnActivation()
    self:ShowActivationEPOP()
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
        net.WriteString("ttt2mg_texplode_countdown_30")
        net.Broadcast()
      elseif delay >= 20 and x == delay - 10 then
        net.Start("texplode_popup")
        net.WriteString("ttt2mg_texplode_countdown_10")
        net.Broadcast()
      elseif delay == x then
        net.Start("texplode_popup")
        net.WriteString("ttt2mg_texplode_explode")
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
  function MINIGAME:ShowActivationEPOP() end
  net.Receive("ttt2mg_texplode_epop", function()
    local mgtime = net.ReadInt(32)
    local name = net.ReadString()
    EPOP:AddMessage({
        text = LANG.TryTranslation("ttt2_minigames_" .. name .. "_name"),
        color = COLOR_ORANGE
    },
      LANG.GetParamTranslation("ttt2_minigames_" .. name .. "_desc", {time = mgtime}) or nil,
      12,
      nil,
      true
    )
  end)
  net.Receive("texplode_popup", function()
    message = net.ReadString()
    if message then
      EPOP:AddMessage(
        {text = LANG.TryTranslation(message),
        color = COLOR_ORANGE},
        "",
        4
      )
    end
  end)
end
