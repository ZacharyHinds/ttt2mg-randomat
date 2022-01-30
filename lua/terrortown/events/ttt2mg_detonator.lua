EVENT.base = "kill"

if CLIENT then
    EVENT.title = "title_ttt2mg_detonator"
    EVENT.icon = Material("vgui/ttt/tid/tid_destructible")

    function EVENT:GetText()
        local outString = "desc_ttt2mg_detonator"
        if event.corpse then
            outString = "desc_ttt2mg_detonator_corpse"
        end
        return {
            {
                string = "desc_ttt2mg_detonator",
                params = {
                    victim = event.victim.nick,
                    vrole = roles.GetByIndex(event.victim.role).name,
                    vteam = event.victim.team,
                    attacker = event.attacker.nick,
                    arole = roles.GetByIndex(event.attacker.role).name,
                    ateam = event.attacker.team
                },
                translateParams = true
            }
        }
    end
end

if SERVER then
    function EVENT:Trigger(victim, attacker, dmgInfo, wasAlive)
        if wasAlive then
            victim.wasDetonatorDeath = true
            return self.BaseClass.Trigger(self, victim, attacker, dmgInfo)
        else
            return self:Add({
                victim = {
                    nick = victim:Nick(),
                    role = victim:GetSubRole(),
                    team = victim:GetTeam()
                },
                attacker = {
                    nick = attacker:Nick(),
                    role = attacker:GetSubRole(),
                    team = attacker:GetTeam()
                },
                corpse = true
            })
        end

    end

    function EVENT:CalculateScore()
        return self.BaseClass.CalculateScore(self)
    end
end

function EVENT:Serialize()
    return self.BaseClass.Serialize(self)
end

hook.Add("TTT2OnTriggeredEvent", "cancel_detonator_kill_event", function(type, eventData)
    if type ~= EVENT_KILL then return end

    local ply = player.GetBySteamID64(eventData.victim.sid64)

    if not IsValid(ply) or not ply.wasDetonatorDeath then return end

    ply.wasDetonatorDeath = nil

    return false
end)