# ttt2mg-randomat
This is a port of the Randomat/Randomat 2.0 addons for TTT2 using the TTT2 Minigames system.

# Minigames

All the minigames here are based on those from the [Randomat 2.0](https://steamcommunity.com/sharedfiles/filedetails/?id=1406495040). There are some places where I've borrowed code from the original, but by and large I've rebuilt its events using the original as a guideline. Whereever possible, I've tried to incorporate TTT2's improved functions/features.

## Completed Minigames

### Infinite Ammo
* Name: sh_ammo_minigame
* Description: Gives everyone inifinite ammo with non-special weapons.

### Exploding Barrels!
* Name: sh_barrels_minigames
* Description: Spawns explosive barrels around each player throughout the round.
* ConVars:
  * ttt2_minigames_barrels_count  - Number of barrels spawned per player
  * ttt2_minigames_barrels_range  - Distance the barrels spawn from the player
  * ttt2_minigames_barrels_timer  - Time between barrel spawns

### Bees!
* Name: sh_bees_minigame
* Description: Spawns hostile bees
* Addon Dependencies:
  * [Jenssons TTT BeeNade](https://steamcommunity.com/sharedfiles/filedetails/?id=913310851)
* ConVars:
  * ttt2_minigames_bees_count - Number of bees spawned per player

### Blinded!
* Name: sh_blind_minigame
* Description: The traitors are temporarily blinded for a configurable duration.
* ConVars:
  * ttt2_minigames_blind_duration - Duration of the blindness

### Don't Blink.
* Name: sh_blink_minigame
* Description: Spawns Weeping Angels which follow and kill players.
* Addon Dependencies:
  * [TTT Weeping Angel SWEP](https://steamcommunity.com/sharedfiles/filedetails/?id=1346794275)
* ConVars:
  * ttt2_minigames_blink_cap  - Maximum angels to spawn
  * ttt2_minigames_blink_delay  - Delay between angel spawns

### Butterfingers!
* Name: sh_butter_minigame
* Description: Every so often players drop the weapon they're holding.
* ConVars:
  * ttt2_minigames_butter_timer - Time between each weapon drop
  * ttt2_minigames_butter_affectall - If enabled, everyone drops their gun simulatenously otherwise only 1 player will drop their weapon at a time.

### Can't Stop!
* Name: sh_cantstop_minigame
* Description: Everyone constantly moves forward.
* ConVars:
  * ttt2_minigames_cantstop_disable_back - If enabled, players cannot hold their backwards movement key to stop moving.

### Communism
* Name: sh_communism_minigame
* Description: Buying equipment buys it for every player

### Crabs are People!
* Name: sh_crabs_minigame
* Description: When players die, headcrabs spawn on their body.
* ConVars:
  * ttt2_minigames_crabs_count  - Number of headcrabs to spawn

### Infinite Credits for Everyone!
* Name: sh_credits_minigame
* Description: Gives everyone infinite credits.
* ConVars:
  * ttt2_minigames_credits_count = Maximum credits that can be spent in a single purchase

### The 'bar has been raised!
* Name: sh_crowbar_minigame
* Description: Increases the damage and pushforce of the crowbar
* ConVars:
  * ttt2_minigames_crowbar_dmg  - Damage multiplier for the crowbar
  * ttt2_minigames_crowbar_push - Pushforce multiplier for the crowbar

### Random Player Explosions!
* Name: sh_explode_minigame
* Description: At a set interval, a random player (excluding Detectives) explodes.
* ConVars:
  * ttt2_minigames_explode_timer  - Time between explosions

### Speeeeeed!
* Name: sh_flash_minigame
* Description: Increases the timescale of the game. This increases movement speed, firerate, reload time, etc.
* ConVars:
  * ttt2_minigames_flash_scale  - Multiplier for timescale

### Quake Pro
* Name: sh_fov_minigame
* Description: Increases the FoV
* ConVars:
  * ttt2_minigames_fov_scale  - FoV Multiplier

### Freeze!
* Name: sh_freeze_minigame
* Description: At a set interval, all innocent team players freeze in place and become invincible for a short duration
* ConVars:
  * ttt2_minigames_freeze_timer - Time between freezes
  * ttt2_minigames_freeze_duration - Duration of freeze

### Bad Gas!
* Name: sh_gas_minigame
* Description: Throughout the round, random grenades will spawn on players and explode
* ConVars:
  * ttt2_minigames_gas_timer  - Time between grenade drops
  * ttt2_minigames_gas_affectall  - If enabled, grenades will drop on everyone simultaneously, otherwise a random player will be targeted
  * ttt2_minigames_gas_discomb  - Enables discombobulators
  * ttt2_minigames_gas_fire - Enables incendiary grenades
  * ttt2_minigames_gas_smoke  - Enables smoke grenades

### RISE FROM YOUR GRAVE!
* Name: sh_grave_minigame
* Description: Dead players will revive as Infected.
* Addon Dependencies:
  * [[TTT2] Infected [ROLE]](https://steamcommunity.com/sharedfiles/filedetails/?id=1371842074)
* ConVars:
  * ttt2_minigames_grave_health - Health of Infected respawned by the minigame
  * ttt2_minigames_grave_delay  - Respawn delay for the minigame's Infected

### Gun Game
* Name: sh_gungame_minigame
* Description: Throughout the round, switch players' weapons with random new ones
* ConVars:
  * ttt2_minigames_gungame_timer  - Time between loadout switches

### Harpooooooooooon!
* Name: sh_harpoon_minigame
* Description: Gives everyone infinitely restocking harpoons.
* Addon Dependencies:
  * [[Gamemode: TTT] Traitor Harpoon](https://steamcommunity.com/sharedfiles/filedetails/?id=456189236)
  * It might work with other mods that add "ttt_m9k_harpoon" and I'm working on potentially fully removing this dependency in the near future
* ConVars:
  * ttt2_minigames_harpoon_timer  - Delay between giving new harpoons
  * ttt2_minigames_harpoon_strip  - If enabled, the minigame strips all other weapons.
  * ttt2_minigames_harpoon_weaponid - In theory, this should allow for replacing the weapon class for the harpoon with a custom one, but it isn't implemented yet
* Known bugs / TODO:
  * Harpoon stripping doesn't work properly
  * ttt2_minigames_harpoon_weaponid is not implemented

### Randomness Intensifies
* Name: sh_intensifies_minigame
* Description: Throughout the round, activates more and more minigames
* ConVars:
  * ttt2_minigames_intensifies_timer  - Time between new minigame activations
* Known bugs/ TODO:
  * This minigame can be unstable but stacking minigames is probably not what Alf anticipated when developing the TTT2 Minigames so that's to be expected

### Taking Inventory
* Name: sh_inventory_minigame
* Description: Throughout the round, swap the inventories of random players
* ConVars:
  * ttt2_minigames_inventory_timer  - Time between inventory swaps
* Known bugs / TODO:
  * Frequently weapons go "missing" between swaps and can temporarily leave some players with no weapons.
  * Affects Role-specific weapons/equipment

### Jesters!
* Name: sh_jesters_minigame
* Description: There's one detective, one traitor, and everyone else is a jester.
* Addon Dependencies:
  * [[TTT2] Jester [ROLE]](https://steamcommunity.com/sharedfiles/filedetails/?id=1363049665)
* ConVars:
  * ttt2_minigames_jesters_base_traitor - If enabled, forces the sole traitor to be a base traitor (no subrole)
  * ttt2_minigames_jesters_base_detective - If enabled, forces the detective to be a base detective (no subrole)
* Known bugs / TODO:
  * If there is no detective the minigame fails to start. (May implement an "Upgrade" function to ensure there is one)

### You can only jump once!
* Name: sh_jump_minigame
* Description: Each player can only jump once, if they jump a second time they die

### Lifesteal
* Name: sh_lifesteal_minigame
* Description: Players gain health from killing other players
* ConVars:
  * ttt2_minigames_lifesteal_health - Health gained per kill
  * ttt2_minigames_lifesteal_cap  - Maximum health for minigame (0 to disable)

### Malfunction!
* Name: sh_malfunction_minigame
* Description: Throughout the round, players will randomly fire their weapon
* ConVars:
  * ttt2_minigames_malfunction_up - Maximum time between malfunctions
  * ttt2_minigames_malfunction_lw - Minimum time between malfunctions
  * ttt2_minigames_malfunction_all  - If enabled, the malfunctions will effect everyone simulaneously, otherwise it will affect a random player
  * ttt2_minigames_malfunction_dur  - Length of the malfunction (how long the player fires for)

### Total Mayhem!
* Name: sh_mayhem_minigame
* Description: Players explode on death

### Moon Gravity!
* Name: sh_moongravity_minigame
* Description: Decreases gravity
* ttt2_minigames_moongravity_gravity  - Gravity multiplier

### No Fall Damage!
* Name: sh_nofall_minigame
* Description: Disables fall damage

### What did I find in my pocket?
* Name: sh_pocket_minigame
* Description: Gives every player a random item from the equipment shop.
* Known bugs / TODO:
  * Some items give errors which in turn break the weapon-gifting function so some players may not receive anything.

### Get Down Mr. President!
* Name: sh_president_minigame
* Description: The detective gets bonus health but if they die, everyone on their team (usually innocents) dies too.
* ConVars:
  * ttt2_minigames_president_bonushp  - Bonus health gained by detective

### Random Health for everyone!
* Name: sh_randomhealth_minigame
* Description: Everyone gets random health.
* ConVars:
  * ttt2_minigames_randomhealth_up  - Upper limit for random health gain
  * ttt2_minigames_randomhealth_lw  - Lower limit for random health gain

### Random Weapons!
* Name: sh_randomwep_minigame
* Description: Everyone gets a random primary and secondary weapon that they cannot drop or exchange.

### Multigame
* Name: sh_randomxn_minigame
* Description: Activates a few more minigames
* ConVars:
  * ttt2_minigames_randomxn_count - Number of additional minigames to activate
* Known bugs / TODO:
  * Similar issue to Randomness Intesifies

### Regeneration
* Name: sh_regen_minigame
* Description: Player health regenerates a short delay after taking damage
* ConVars:
  * ttt2_minigames_regen_delay  - Delay after taking damage to start healing
  * ttt2_minigames_regen_hp - Health regained per second

### Dead Men Tell No Tales
* Name: sh_search_minigame
* Description: Bodies cannot be searched

### Shh... It's a Secret
* Name: sh_secret_minigame
* Description: All innocents become Spies
* Addon Dependencies:
  * [[TTT2] Spy [ROLE]](https://steamcommunity.com/sharedfiles/filedetails/?id=1683708655)

### Shrunked
* Name: sh_shrink_minigame
* Description: Decreases player size (and proportionally their health, movement speed, etc.)
* ConVars:
  * ttt2_minigames_shrink_scale - Shrinking scale factor

### SHUT UP!
* Name: sh_shutup_minigame
* Description: Mutes all sounds

### Sosig
* Name: sh_sosig_minigame
* Description: Replaces all gunshot sounds with sosig.mp3

### Sudden Death
* Name: sh_suddendeath_minigame
* Description: Sets everyones health to 1

### Detonators
* Name: sh_suicide_minigame
* Description: Everyone gets a detonator for another player, if they use it, that player explodes and it tells everyone in chat "<Player X> detonated <Player Y>"

### Suspicious
* Name: sh_suspicion_minigame
* Description: Proclaims a player is suspicious. They are either a traitor or a jester
* Addon Dependencies:
  * [[TTT2] Jester [ROLE]](https://steamcommunity.com/sharedfiles/filedetails/?id=1363049665)
* ConVars:
  * ttt2_minigames_suspicion_jst_chance - Chance of making the player a jester

### Switch!
* Name: sh_switch_minigame
* Description: Throughout the round, two random players' positions will be swapped.
* ConVars:
  * ttt2_minigames_switch_timer - Time between switches

### Explosive Traitors
* Name: sh_texplode_minigame
* Description: One random traitor is marked to explode after a certain amount of time.
* ConVars:
  * ttt2_minigames_texplode_timer - Time delay before the traitor explodes
  * ttt2_minigames_texplode_radius  - Size of the traitor's explosion

### I see dead people
* Name: sh_visualizer_minigame
* Description: Players drop a visualizer on death

### Wallhack!
* Name: sh_wallhack_minigame
* Description: Players gain the ability to see players through the wall (like [[TTT2] Tracker [ITEM]](https://steamcommunity.com/sharedfiles/filedetails/?id=1795511061))

## In-Development/Broken Minigames

### Murder
* Name: sh_murder_minigame
* Description: Recreation of the Murder minigame in TTT. Traitors become murderers with an instant-kill knife, detective gets an instant-kill revolver. Everyone else loses their weapons and are made regular innocents. Pick up enough weapons get a revoler, if you shoot an innocent with the revolver, you drop it and go blind for a bit.
* ConVars:
  * ttt2_minigames_murder_knife_dmg - Knife damage
  * ttt2_minigames_murder_knife_speed - Speed multiplier when holding knife
* Known bugs / TODO:
  * Gun pickups to Revolver code is sloppy and doesn't really work consitently
  * Blind and drop weapon when innocent is shot is inconsistent
  * Knife animations are broken
  * TODO: Add throwing knife
  * TODO (Maybe): Footsteps
  * TODO (Maybe): Murderer smoke
* Current State: Its playable, but not where I'd like it to be. Use at your own risk



## TODO Minigames

### We've updated our privacy policy.
* Name: sh_privacy_minigame
* Description: All players can see when someone buys something, no names just roles though.

### Bad Trip
* Description: Players temporarily ragdoll when they jump

### Democracy
* Description: Players vote to kill

### Choose
* Description: A random player chooses a minigame to activate

# Other features

## Randomat X

Adds a remake of the Randomat, which has the wokring name of "Randomat X". This SWEP appears in the Detective shop and when used it activates a random minigame (any valid TTT2 Minigame, not just the ones included with this collection).

Known Bugs / TODO:
* The icon and model require the old randomat to be installed since I haven't made my own.
* Add sound effects
* Add randomat-like functionality to minigames (where events like "Get Down Mr. President" target the owner of the Randomat specifically) if I can figure out a somewhat elegant solution
