if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

MINIGAME.conVarData = {
  ttt2_minigames_inventory_timer = {
    slider = true,
    min = 1,
    max = 60,
    desc = "ttt2_minigames_inventory_timer (Def. 15)"
  }
}

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Taking Inventory",
      Русский = "Инвентаризация"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  local ttt2_minigames_inventory_timer = CreateConVar("ttt2_minigames_inventory_timer", "15", {FCVAR_ARCHIVE}, "Time between inventory swaps")
  function MINIGAME:OnActivation()
    local ply1
    local ply2

    timer.Create("InventoryMinigame", ttt2_minigames_inventory_timer:GetInt(), 0, function()
      local x = 0
      for _, ply in RandomPairs(player.GetAll()) do
        if not ply:Alive() or ply:IsSpec() then continue end

        x = x + 1
        if x == 1 then
          ply1 = ply
        elseif x == 2 then
          ply2 = ply
        end
      end

      -- local ply1weps = ply1:GetWeapons()
      local ply1weps = {}
      for _, wep in ipairs(ply1:GetWeapons()) do
        ply1weps[#ply1weps + 1] = wep.ClassName
        print(ply1weps[#ply1weps])
        ply1:StripWeapon(ply1weps[#ply1weps])
      end
      for _, wep in ipairs(ply2:GetWeapons()) do
        ply1:Give(wep.ClassName)
        ply1:SetFOV(0, 0.2)
      end

      ply2:StripWeapons()
      for _, wep in ipairs(ply1weps) do
        ply2:Give(wep)
        ply2:SetFOV(0, 0.2)
      end
    end)
  end

  function MINIGAME:OnDeactivation()
    timer.Remove("InventoryMinigame")
  end
end
