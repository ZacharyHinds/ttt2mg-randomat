if SERVER then
  AddCSLuaFile()
end

MINIGAME.author = "Wasted"
MINIGAME.contact = "Zzzaaaccc13 on TTT2 Discord"

if CLIENT then
  MINIGAME.lang = {
    name = {
      English = "We've updated our privacy policy."
    },
    desc = {
      English = ""
    }
  }
else

end

if SERVER then
  function MINIGAME:OnActivation()

  end

  function MINIGAME:OnDeactivation()

  end
end
