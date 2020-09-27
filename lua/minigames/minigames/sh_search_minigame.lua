if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "Dead Men Tell No Tales"
      Русский = "Мертвецы не рассказывают сказки"
    },
    desc = {
      English = ""
    }
  }
end

if SERVER then
  function MINIGAME:OnActivation()
    hook.Add("TTTCanSearchCorpse", "SearchMinigame", function()
      return false
    end)
  end

  function MINIGAME:OnDeactivation()
    hook.Remove("TTTCanSearchCorpse", "SearchMinigame")
  end
end
