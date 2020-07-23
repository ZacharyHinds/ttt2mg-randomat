if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_soulmate_all = {
    checkbox = true,
    desc = "(Def. 0)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Soulmates"
    },
    desc = {
      English = ""
    }
  }
else
  ttt2_minigames_soulmate_all = CreateConVar("ttt2_minigames_soulmate_all", "0", {FCVAR_ARCHIVE}, "Whether everyone should have a soulmate")
end

if SERVER then
  function MINIGAME:OnActivation()
    local x = 0

    local ply1 = {}
    local ply2 = {}

    for _, ply in ipairs(player.GetAll()) do
      if not ply:Alive() or ply:IsSpec() then continue end

      x = x + 1
      if math.floor(x / 2) ~= x / 2 then
        table.insert(ply1, ply)
      else
        table.insert(ply2, ply)
      end
    end

    local size = 1

    table.Shuffle(ply1)
    table.Shuffle(ply2)

    if ttt2_minigames_soulmate_all:GetBool() then
      size = #ply2

      for i = 1, #ply2 do
        ply1[i]:PrintMessage(HUD_PRINTTALK, "Your soulmate is " .. ply2[i]:Nick())
        ply1[i]:PrintMessage(HUD_PRINTCENTER, "Your soulmate is " .. ply2[i]:Nick())
        ply2[i]:PrintMessage(HUD_PRINTTALK, "Your soulmate is " .. ply1[i]:Nick())
        ply2[i]:PrintMessage(HUD_PRINTCENTER, "Your soulmate is " .. ply1[i]:Nick())
      end
      if ply1[#ply2 + 1] then
        ply1[#ply2 + 1]:PrintMessage(HUD_PRINTTALK, "You have no soulmate :(")
        ply1[#ply2 + 1]:PrintMessage(HUD_PRINTCENTER, "You have no soulmate :(")
      end

    else
      for _, ply in ipairs(player.GetAll()) do
        ply:PrintMessage(HUD_PRINTTALK, ply1[1]:Nick() .. " and " .. ply2[2]:Nick() .. " are now soulmates.")
        ply:PrintMessage(HUD_PRINTCENTER, ply1[1]:Nick() .. " and " .. ply2[2]:Nick() .. " are now soulmates.")
      end
    end

    timer.Create("SoulmatesMinigameTimer", 0.1, 0, function()
      for i = 1, size do
        if not ply1[i]:Alive() and ply2[i]:Alive() then
          ply2[i]:Kill()
        elseif ply1[i]:Alive() and not ply2[i]:Alive() then
          ply1[i]:Kill()
        end
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("SoulmatesMinigameTimer")
  end
end
