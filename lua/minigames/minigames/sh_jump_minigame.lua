if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "You can only jump once!"
    },
    desc = {
      English = ""
    }
  }
else
  util.AddNetworkString("mg_jump_popup")
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("KeyPress", "JumpMinigame", function(ply, key)
      if key == IN_JUMP and ply:Alive() and not ply:IsSpec() then
        if ply.mgJumps then
          net.Start("mg_jump_popup")
          net.WriteString(ply:Nick())
          net.Broadcast()
          util.BlastDamage(ply, ply, ply:GetPos(), 100, 500)
          ply.mgJumps = nil
        else
          ply.mgJumps = 1
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("KeyPress", "JumpMinigame")
  end
end

if CLIENT then
  net.Receive("mg_jump_popup", function()
    local name = net.ReadString()

    EPOP:AddMessage({
      text = LANG.GetParamTranslation("ttt2mg_jump_epop", {nick = name}),
      color = COLOR_ORANGE},
      nil,
      5,
      nil,
      false
    )
  end)
end
