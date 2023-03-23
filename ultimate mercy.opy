#Global variables

globalvar mercyDummy 0
globalvar rezEventOrder 1
globalvar rezEventCaster 2
globalvar rezEventTarget 3
globalvar rezEventKillfeed 4
globalvar rezEventAbility 5
globalvar criticalHealthPlayers 6
globalvar gameQuickAssemble 7
globalvar gameQuickSetup 8
globalvar mercyRegenHealingPercent 9
globalvar mercyYellowbeamHealingPercent 10
globalvar mercyGACooldownPercent 11
globalvar mercyRezCooldownPercent 12
globalvar mercyPlayersInSpawn 13
globalvar mercyPlayersInMercySetup 14
globalvar mercySetupPresetName 15
globalvar mercySetupPassiveName 16
globalvar mercySetupPassiveDesc 17
globalvar mercySetupWeaponName 18
globalvar mercySetupWeaponDesc 19
globalvar mercySetupAbility1Name 20
globalvar mercySetupAbility1Desc 21
globalvar mercySetupAbility2Name 22
globalvar mercySetupAbility2Desc 23
globalvar mercySetupUltimateName 24
globalvar mercySetupUltimateDesc 25
globalvar debugToggle 26
globalvar debugHostStatusEffect 27
globalvar debugHostInstaLockMercy 28
globalvar debugHostPermaUlt 29
globalvar debugHostHurtSelfButton 30
globalvar debugHostHurtPlayerButton 31
globalvar debugHostKillSelfButton 32
globalvar debugHostKillPlayerButton 33
globalvar debugHostHealDummyButton 34
globalvar debugHealDummy 35
globalvar debugHostBoostDummyButton 36
globalvar debugBoostDummy 37
globalvar debugHostDamageDummyButton 38
globalvar debugDamageDummy 39
globalvar debugHostServerLoad 40
globalvar debugHostSpeedometer 41
globalvar debugHostTargeting 42
globalvar debugPlayerPermaDeath 43

#Player variables

playervar currentHero 0
playervar isBeingResurrected 1
playervar isInvulnerable 2
playervar passiveHealMod 3
playervar passiveEffect 4
playervar beamTarget 5
playervar beamRange 6
playervar yellowbeamHealMod 7
playervar yellowbeamFactor 8
playervar gaRange 9
playervar gaDirection 10
playervar baDummy 11
playervar baTarget 12
playervar baInWorldText 13
playervar rezTarget 14
playervar rezVisualEffect 15
playervar rezSoundEffect 16
playervar rezCameraOffset 17
playervar rezAssist 18
playervar teamIndex 19
playervar teamColor 20
playervar eyePositionOffset 21
playervar massrezTargets 22
playervar massrezCurTargetCount 23
playervar massrezHUDSpacer 24
playervar massrezHUDText 25
playervar medigunTarget 26
playervar medigunHealingFactor 27
playervar currentOverhealth 28
playervar overhealthPool 29
playervar isVaccinated 30
playervar vaccinatorVisualEffect1 31
playervar vaccinatorVisualEffect2 32
playervar vaccinatorSoundEffect 33
playervar isCastingUbercharge 34
playervar isUbercharged 35
playervar uberchargeVisualEffect1 36
playervar uberchargeVisualEffect2 37
playervar uberchargeSoundEffect 38
playervar isInMercySetup 39
playervar mercySetupBar 40
playervar mercySetupCurProgress 41
playervar mercyPresetVersion 42
playervar mercyPassiveVersion 43
playervar mercyWeaponVersion 44
playervar mercyAbility1Version 45
playervar mercyAbility2Version 46
playervar mercyUltimateVersion 47


#Subroutine names

subroutine createMercyDummy 0


#Activated extensions

#!extension buffAndDebuffSounds
#!extension buffStatusEffects
#!extension energyExplosionEffects


def createMercyDummy():
    @Name "create mercy dummy"
    
    createDummy(Hero.MERCY, eventPlayer.getTeam(), -1, eventPlayer.getPosition() + vect(0, 2.5, 0), eventPlayer.getFacingDirection())
    mercyDummy[eventPlayer.teamIndex] = getLastCreatedEntity()
    wait()
    mercyDummy[eventPlayer.teamIndex].startForcingName(rezEventCaster)
    mercyDummy[eventPlayer.teamIndex].setInvisibility(Invis.ALL)
    mercyDummy[eventPlayer.teamIndex].setStatusEffect(null, Status.PHASED_OUT, 9999)
    mercyDummy[eventPlayer.teamIndex].disablePlayerCollision()
    mercyDummy[eventPlayer.teamIndex].disableEnvironmentCollision(true)
    if rezEventAbility == abilityIconString(Hero.MERCY, Button.ABILITY_2):
        mercyDummy[eventPlayer.teamIndex].startModifyingVoicelinePitch(1.1, false)
    mercyDummy[eventPlayer.teamIndex].setUltCharge(100)


rule "update mercy dummy position":
    @Event global
    @Condition entityExists(mercyDummy) == true

    do:
        mercyDummy.teleport(rezEventCaster.getPosition() + vect(0, 2.5, 0))
        wait()
    while RULE_CONDITION


rule "global initialize":
    mercyDummy = [null, null]
    rezEventOrder = -1
    rezEventCaster = null
    rezEventTarget = null
    rezEventAbility = null
    criticalHealthPlayers = []
    gameQuickAssemble = createWorkshopSetting(bool, "1 - GAME SETTINGS", "1A - QUICK ASSEMBLE", false, 0)
    gameQuickSetup = createWorkshopSetting(bool, "1 - GAME SETTINGS", "1B - QUICK SETUP", false, 1)
    mercyRegenHealingPercent = createWorkshopSetting(int[0:500], "2 - MERCY SETTINGS", "2A - REGENERATION HEALING PERCENT", 100, 0)
    mercyYellowbeamHealingPercent = createWorkshopSetting(int[0:500], "2 - MERCY SETTINGS", "2B - YELLOW BEAM HEALING PERCENT", 100, 1)
    mercyGACooldownPercent = createWorkshopSetting(int[0:500], "2 - MERCY SETTINGS", "2C - GUARDIAN ANGEL COOLDOWN PERCENT", 100, 2)
    mercyRezCooldownPercent = createWorkshopSetting(int[0:500], "2 - MERCY SETTINGS", "2D - RESURRECT COOLDOWN PERCENT", 100, 3)
    debugToggle = createWorkshopSetting(bool, "99 - DEBUG", "99A - DEBUG TOGGLE", false, 0)
    debugHostStatusEffect = createWorkshopSetting(enum["NONE", "UNKILLABLE", "INVINCIBLE", "PHASED OUT"], "99 - DEBUG", "99B - HOST STATUS EFFECT", 0, 1)
    debugHostInstaLockMercy = createWorkshopSetting(bool, "99 - DEBUG", "99C - HOST INSTALOCK MERCY", false, 2)
    debugHostPermaUlt = createWorkshopSetting(bool, "99 - DEBUG", "99D - HOST PERMA ULT", false, 3)
    debugHostHurtSelfButton = createWorkshopSetting(bool, "99 - DEBUG", "99E - HOST HURT SELF BUTTON (CROUCH + PRIMARY FIRE)", false, 4)
    debugHostHurtPlayerButton = createWorkshopSetting(bool, "99 - DEBUG", "99F - HOST HURT PLAYER BUTTON (CROUCH + SECONDARY FIRE)", false, 5)
    debugHostKillSelfButton = createWorkshopSetting(bool, "99 - DEBUG", "99G - HOST KILL SELF BUTTON (CROUCH + RELOAD)", false, 6)
    debugHostKillPlayerButton = createWorkshopSetting(bool, "99 - DEBUG", "99H - HOST KILL PLAYER BUTTON (CROUCH + MELEE)", false, 7)
    debugHostHealDummyButton = createWorkshopSetting(bool, "99 - DEBUG", "99I - HOST HEALTH DUMMY BUTTON (CROUCH + INTERACT)", false, 8)
    debugHealDummy = null
    debugHostBoostDummyButton = createWorkshopSetting(bool, "99 - DEBUG", "99I - HOST BOOST DUMMY BUTTON (CROUCH + ABILITY 1)", false, 9)
    debugBoostDummy = null
    debugHostDamageDummyButton = createWorkshopSetting(bool, "99 - DEBUG", "99J - HOST DAMAGE DUMMY BUTTON (CROUCH + JUMP)", false, 10)
    debugDamageDummy = null
    debugHostServerLoad = createWorkshopSetting(bool, "99 - DEBUG", "99K - HOST SERVER LOAD", false, 10)
    debugHostSpeedometer = createWorkshopSetting(bool, "99 - DEBUG", "99L - HOST SPEEDOMETER", false, 11)
    debugHostTargeting = createWorkshopSetting(bool, "99 - DEBUG", "99M - HOST TARGETING", false, 12)
    debugPlayerPermaDeath = createWorkshopSetting(bool, "99 - DEBUG", "99N - PLAYER PERMADEATH", false, 13)
    mercySetupPresetName = ["CUSTOM", "MERCY 1.0", "MERCY 2.0", "MERCY 3.0", "MERCY 4.0", "MERCY 5.0", "MERCY 6.0", "MERCY 7.0"]
    mercySetupPassiveName = ["REGENERATION 1.0", "REGENERATION 2.0", "SYMPATHETIC RECOVERY"]
    mercySetupPassiveDesc = ["RECEIVE 20 HPS AFTER NOT TAKING DAMAGE FOR 1S", "22.5 HPS AFTER NOT TAKING DAMAGE FOR 1.5S", "RECEIVE 25% OF HEALING DEALT TO OTHERS"]
    mercySetupWeaponName = ["CADUCEUS STAFF 1.0", "CADUCEUS STAFF 2.0", "CADUCEUS STAFF 3.0"]
    mercySetupWeaponDesc = ["DEAL 60 HPS TO A TARGET / BOOST DAMAGE OF A TARGET BY 30%", "DEAL 55 HPS TO A TARGET (+5 HPS DURING VALKYRIE) / BOOST DAMAGE OF A TARGET BY 30%", "DEAL 45 HPS TO A TARGET (+15 HPS DURING VALKYRIE / +50% HPS WHEN TARGET IS AT CRITICAL HEALTH) / BOOST DAMAGE OF A TARGET BY 30%"]
    mercySetupAbility1Name = ["GUARDIAN ANGEL 1.0", "GUARDIAN ANGEL 2.0", "GUARDIAN ANGEL 3.0", "GUARDIAN ANGEL 4.0", "BATTLE ANGEL"]
    mercySetupAbility1Desc = ["FLY TO AN ALLY (1.5S CD / NO SLINGSHOT / NO SUPERJUMP)", "FLY TO AN ALLY (1.5 CD / FORWARD SLINGSHOT / SUPERJUMP AT LOW SPEEDS)", "FLY TO AN ALLY (1.5S CD / OMNIDIRECTIONAL SLINGSHOT / SUPERJUMP WHENEVER)", "FLY TO AN ALLY (2.5S CD / OMNIDIRECTIONAL SLINGSHOT / SUPERJUMP WHENEVER)", "FLY TO AN ALLY/ENEMY (2.5S CD / OMNIDIRECTIONAL SLINGSHOT / SUPERJUMP WHENEVER)"]
    mercySetupAbility2Name = ["NONE", "RESURRECT 1.0", "RESURRECT 2.0", "RESURRECT 3.0", "RESURRECT (CANON) (NOT YET IMPLEMENTED)"]
    mercySetupAbility2Desc = ["NO ABILITY 2 / -10% ULT COST", "REVIVE A NEARBY DEAD ALLY WITHIN A 5M RADIUS (30S CD / INSTANT CAST)", "REVIVE A NEARBY DEAD ALLY WITHIN A 5M RADIUS (30S CD / 1.75S CAST TIME / INSTANT CAST DURING VALKYRIE)", "REVIVE A NEARBY DEAD ALLY WITHIN A 5M RADIUS (30S CD / 1.75S CAST TIME)", "DEAL 100 HPS TO AN ALLY FOR 1.75S (15S CD)"]
    mercySetupUltimateName = ["MASS RESURRECT", "VALKYRIE 1.0", "VALKYRIE 2.0 (NOT YET IMPLEMENTED)", "VALKYRIE 3.0"]
    mercySetupUltimateDesc = ["REVIVE NEARBY DEAD ALLIES WITHIN A 15M RADIUS (DOES NOT REQUIRE LOS)", "ENHANCE ALL ABILITIES AND GAIN THE ABILITY TO FLY (PASSIVE ALWAYS ACTIVE / CHAIN BEAM / INFINITE AMMO / INCREASES GA RANGE AND SPEED / RESETS REZ ON CAST AND SHORTENS REZ CD)", "ENHANCE ALL ABILITIES AND GAIN THE ABILITY TO FLY (PASSIVE ALWAYS ACTIVE / CHAIN BEAM / INFINITE AMMO / INCREASES GA RANGE AND SPEED / GIVES A BONUS REZ CHARGE)", "ENHANCE ALL ABILITIES AND GAIN THE ABILITY TO FLY (PASSIVE ALWAYS ACTIVE / CHAIN BEAM / INFINITE AMMO / INCREASES GA RANGE AND SPEED)"]
    mercyPlayersInSpawn = []
    mercyPlayersInMercySetup = []


rule "player initialize":
    @Event eachPlayer
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.preloadHero(Hero.MERCY)
    eventPlayer.currentHero = eventPlayer.getCurrentHero()
    eventPlayer.isBeingResurrected = false
    eventPlayer.passiveHealMod = null
    eventPlayer.passiveEffect = null
    eventPlayer.beamTarget = null
    eventPlayer.beamRange = 15
    eventPlayer.yellowbeamHealMod = null
    eventPlayer.yellowbeamFactor = 60 / 45
    eventPlayer.gaRange = 30
    eventPlayer.gaDirection = vect(0, 0, 0)
    eventPlayer.baTarget = null
    eventPlayer.rezTarget = null
    eventPlayer.rezVisualEffect = null
    eventPlayer.rezSoundEffect = null
    eventPlayer.rezCameraOffset = vect(0, 0, 0)
    if eventPlayer.getTeam() == Team.1:
        eventPlayer.teamIndex = 0
        eventPlayer.teamColor = Color.TEAM_1
    else:
        eventPlayer.teamIndex = 1
        eventPlayer.teamColor = Color.TEAM_2
    eventPlayer.massrezTargets = 0
    eventPlayer.medigunHealingFactor = 3
    eventPlayer.mercySetupBar = null
    eventPlayer.mercySetupCurProgress = 0
    eventPlayer.isInMercySetup = false
    eventPlayer.mercyPresetVersion = 7
    # eventPlayer.mercyPassiveVersion = 1
    # eventPlayer.mercyWeaponVersion = 1
    # eventPlayer.mercyAbility1Version = 1
    # eventPlayer.mercyAbility2Version = 1
    # eventPlayer.mercyUltimateVersion = 1


rule "mercy picked":
    @Event eachPlayer
    @Condition eventPlayer.currentHero != eventPlayer.getCurrentHero()
    @Condition eventPlayer.isDummy() == false

    if eventPlayer.getCurrentHero() == Hero.MERCY:
        startHealingModification(eventPlayer, eventPlayer, 0, HealingReeval.NONE)
        eventPlayer.passiveHealMod = getLastHealingModification()
        startHealingModification(getPlayers(eventPlayer.getTeam()).exclude(eventPlayer), eventPlayer, eventPlayer.yellowbeamFactor * (mercyYellowbeamHealingPercent / 100), HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
        eventPlayer.yellowbeamHealMod = getLastHealingModification()
    else:
        stopHealingModification(eventPlayer.passiveHealMod)
        stopHoT(eventPlayer.passiveEffect)
        stopHealingModification(eventPlayer.yellowbeamHealMod)
        eventPlayer.setAbility1Enabled(true)
        eventPlayer.setAbility2Enabled(true)
        eventPlayer.setUltEnabled(true)
        eventPlayer.allowButton(Button.PRIMARY_FIRE)
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.allowButton(Button.ABILITY_1)
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.eyePositionOffset = eventPlayer.getEyePosition() - eventPlayer.getPosition()
    eventPlayer.currentHero = eventPlayer.getCurrentHero()


rule "game quick assemble":
    @Event global
    @Condition gameQuickAssemble == true
    @Condition isAssemblingHeroes() == true

    setMatchTime(10)
    waitUntil(isInSetup(), 99999)


rule "game quick setup":
    @Event global
    @Condition gameQuickSetup == true
    @Condition isInSetup() == true

    setMatchTime(30)
    getPlayers(Team.1).teleport(getObjectivePosition(0) + vect(0, 5, 0))


rule "player is at critical health":
    @Event eachPlayer
    @Condition eventPlayer.getNormalizedHealth() <= 0.5
    @Condition eventPlayer.isDummy() == false

    criticalHealthPlayers.append(eventPlayer)


rule "player is no longer at critical health":
    @Event eachPlayer
    @Condition eventPlayer.getNormalizedHealth() > 0.5
    @Condition eventPlayer.isDummy() == false

    criticalHealthPlayers.remove(eventPlayer)


rule "casting rez with invalid target":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility2Version == 2
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.rezTarget == null
    @Condition eventPlayer.isDummy() == false

    eventPlayer.cancelPrimaryAction()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


rule "casting rez with valid target(s)":
    @Event eachPlayer
    @Hero mercy
    @Condition ((eventPlayer.mercyAbility2Version == 2 or eventPlayer.mercyAbility2Version == 3 or eventPlayer.mercyAbility2Version == 4) and eventPlayer.isUsingAbility2()) or (eventPlayer.mercyUltimateVersion == 1 and eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.getUltCharge() == 100 and eventPlayer.massrezTargets != null and eventPlayer.isAlive() and not eventPlayer.hasStatusEffect(Status.ASLEEP) and not eventPlayer.hasStatusEffect(Status.FROZEN) and not eventPlayer.hasStatusEffect(Status.HACKED) and not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) and not eventPlayer.hasStatusEffect(Status.STUNNED)) == true
    @Condition eventPlayer.isDummy() == false
    
    rezEventCaster = eventPlayer
    if eventPlayer.isUsingAbility2():
        if eventPlayer.mercyAbility2Version == 2 or (eventPlayer.mercyAbility2Version == 3 and eventPlayer.isUsingUltimate()):
            eventPlayer.cancelPrimaryAction()
            eventPlayer.rezTarget = eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())
            eventPlayer.rezTarget.isBeingResurrected = true
            eventPlayer.rezTarget.resurrect()
            rezEventTarget = eventPlayer.rezTarget
            rezEventAbility = abilityIconString(Hero.MERCY, Button.ABILITY_2)
        elif eventPlayer.mercyAbility2Version == 3 or eventPlayer.mercyAbility2Version == 4:
            waitUntil(not eventPlayer.isUsingAbility2(), 99999)
        if eventPlayer.isUsingUltimate():
            eventPlayer.setAbilityCooldown(Button.ABILITY_2, 7.5 * (mercyRezCooldownPercent / 100))
        else:
            eventPlayer.setAbilityCooldown(Button.ABILITY_2, 30 * (mercyRezCooldownPercent / 100))
        eventPlayer.rezTarget = null
        if eventPlayer.mercyAbility2Version == 4:
            return
    elif eventPlayer.isHoldingButton(Button.ULTIMATE):
        eventPlayer.massrezTargets.isBeingResurrected = true
        eventPlayer.massrezTargets.resurrect()
        rezEventTarget = eventPlayer.massrezTargets
        rezEventAbility = abilityIconString(Hero.MERCY, Button.ULTIMATE)
        eventPlayer.isInvulnerable = true
        eventPlayer.setUltCharge(0)
        eventPlayer.massrezTargets = null
    eventPlayer.cancelPrimaryAction()
    eventPlayer.startGrantingAssistFor(rezEventTarget, AssistReeval.NONE)
    rezEventTarget.rezAssist = [getLastAssistID(), getTotalTimeElapsed()]
    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.getPosition(), 1.5)
    wait()
    rezEventTarget.setHealth(1)
    heal(rezEventTarget, eventPlayer, 9999)
    rezEventTarget.setHealth(rezEventTarget.getMaxHealth() - 1)
    heal(rezEventTarget, eventPlayer, 9999)
    rezEventTarget = null
    destroyDummy(mercyDummy[eventPlayer.teamIndex].getTeam(), mercyDummy[eventPlayer.teamIndex].getSlot())
    createMercyDummy()
    wait()
    mercyDummy[eventPlayer.teamIndex].forceButtonPress(Button.ULTIMATE)
    eventPlayer.cancelPrimaryAction()
    wait(0.168, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    wait(0.55, Wait.RESTART_WHEN_TRUE)
    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * vect(1.5, 2, 1.5)), 2)
    wait(0.85, Wait.RESTART_WHEN_TRUE)
    destroyDummy(mercyDummy[eventPlayer.teamIndex].getTeam(), mercyDummy[eventPlayer.teamIndex].getSlot())


rule "getting rez'd":
    @Event eachPlayer
    @Condition eventPlayer.isBeingResurrected == true
    @Condition eventPlayer.isDummy() == false
    
    bigMessage(eventPlayer, "REVIVING")
    smallMessage(rezEventCaster, " {0} SAVED {1} ".format(heroIcon(eventPlayer.getCurrentHero()), eventPlayer))
    eventPlayer.rezCameraOffset = normalize(eventPlayer.getFacingDirection()) * -3
    eventPlayer.startCamera(eventPlayer.getEyePosition() + eventPlayer.rezCameraOffset, eventPlayer.getEyePosition(), 6)
    eventPlayer.startFacing(eventPlayer.getFacingDirection(), 9999, Relativity.TO_WORLD, FacingReeval.NONE)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2.25)
    eventPlayer.setStatusEffect(null, Status.ROOTED, 1.5)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.INTERACT)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ULTIMATE)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.getPosition(), 1.25)
    playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENADE_INCREASED_HEALING_SOUND, Color.WHITE, eventPlayer.getPosition(), 100)
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, eventPlayer.teamColor, eventPlayer, 1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.rezVisualEffect = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND, eventPlayer.teamColor, eventPlayer, 100, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.rezSoundEffect = getLastCreatedEntity()
    wait(0.75, Wait.RESTART_WHEN_TRUE)
    eventPlayer.rezCameraOffset = vect(0, 0, 0)
    wait(0.75, Wait.RESTART_WHEN_TRUE)
    eventPlayer.stopCamera()
    eventPlayer.stopFacing()
    eventPlayer.allowButton(Button.CROUCH)
    eventPlayer.allowButton(Button.JUMP)
    wait(0.75, Wait.RESTART_WHEN_TRUE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.INTERACT)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ULTIMATE)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    destroyEffect(eventPlayer.rezVisualEffect)
    destroyEffect(eventPlayer.rezSoundEffect)
    eventPlayer.isBeingResurrected = false


rule "getting invulnerability":
    @Event eachPlayer
    @Condition eventPlayer.isInvulnerable == true
    @Condition eventPlayer.isDummy() == false

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2.25)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.getPosition(), 1.25)
    playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENADE_INCREASED_HEALING_SOUND, Color.WHITE, eventPlayer.getPosition(), 100)
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, eventPlayer.teamColor, eventPlayer, 1, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.rezVisualEffect = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND, eventPlayer.teamColor, eventPlayer, 100, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.rezSoundEffect = getLastCreatedEntity()
    wait(2.25, Wait.RESTART_WHEN_TRUE)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    destroyEffect(eventPlayer.rezVisualEffect)
    destroyEffect(eventPlayer.rezSoundEffect)
    eventPlayer.isInvulnerable = false


rule "create rez event killfeed":
    @Event eachPlayer
    @Condition eventPlayer.isBeingResurrected == true
    @Condition eventPlayer.isDummy() == false

    hudHeader(getAllPlayers(), "{0} {1} > {2}".format("{0} {1}".format(rezEventCaster, heroIcon(rezEventCaster.getCurrentHero())), rezEventAbility, "{0} {1}".format(heroIcon(rezEventTarget[rezEventTarget.index(eventPlayer)].getCurrentHero()), rezEventTarget[rezEventTarget.index(eventPlayer)])), HudPosition.LEFT, rezEventOrder, eventPlayer.teamColor, HudReeval.NONE, SpecVisibility.DEFAULT)
    rezEventKillfeed[len(rezEventKillfeed)] = [getLastCreatedText(), getTotalTimeElapsed()]
    while len(rezEventKillfeed) > 4:
        destroyHudText(rezEventKillfeed[0][0])
        del rezEventKillfeed[0]
    rezEventOrder -= 1


rule "destroy rez event killfeed":
    @Event global
    @Condition len(rezEventKillfeed) >= 1

    waitUntil(any([getTotalTimeElapsed() - player[1] >= 8 for player in rezEventKillfeed]), 99999)
    destroyHudText(rezEventKillfeed[0][0])
    del rezEventKillfeed[0]
    if RULE_CONDITION:
        goto RULE_START


rule "rez assist expired":
    @Event eachPlayer
    @Condition getTotalTimeElapsed() >= eventPlayer.rezAssist[1] + 10.25

    stopAssist(eventPlayer.rezAssist[0])


rule "mercy setup menu":
    @Event global

    progressBarHud(mercyPlayersInSpawn, localPlayer.mercySetupCurProgress, "HOLD [{0}] TO {1} MERCY SETUP".format(buttonString(Button.INTERACT), "CLOSE" if localPlayer in mercyPlayersInMercySetup else "OPEN"), HudPosition.TOP, 100, rgb(193, 112, 10), Color.WHITE, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.DEFAULT)
    createEffect(mercyPlayersInMercySetup, Effect.ORB, Color.BLACK, updateEveryTick(localPlayer.getEyePosition() + (localPlayer.getFacingDirection() * 0.8)), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    hudText(mercyPlayersInMercySetup, "{0} {1}".format(heroIcon(Hero.MERCY), localPlayer.mercyPresetVersion), "[{0}] PRESET".format(buttonString(Button.CROUCH)), mercySetupPresetName[localPlayer.mercyPresetVersion], HudPosition.TOP, 101, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, " ", HudPosition.TOP, 102, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInMercySetup, "{0} {1}".format(iconString(Icon.PLUS), localPlayer.mercyPassiveVersion), "[{0}] PASSIVE".format(buttonString(Button.RELOAD)), mercySetupPassiveName[localPlayer.mercyPassiveVersion - 1], HudPosition.TOP, 103, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, mercySetupPassiveDesc[localPlayer.mercyPassiveVersion - 1], HudPosition.TOP, 104, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, " ", HudPosition.TOP, 105, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInMercySetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.PRIMARY_FIRE), localPlayer.mercyWeaponVersion), "[{0}] WEAPON".format(buttonString(Button.PRIMARY_FIRE)), mercySetupWeaponName[localPlayer.mercyWeaponVersion - 1], HudPosition.TOP, 106, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, mercySetupWeaponDesc[localPlayer.mercyWeaponVersion - 1], HudPosition.TOP, 107, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, " ", HudPosition.TOP, 108, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInMercySetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.ABILITY_1), localPlayer.mercyAbility1Version), "[{0}] ABILITY 1".format(buttonString(Button.ABILITY_1)), mercySetupAbility1Name[localPlayer.mercyAbility1Version - 1], HudPosition.TOP, 109, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, mercySetupAbility1Desc[localPlayer.mercyAbility1Version - 1], HudPosition.TOP, 110, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, " ", HudPosition.TOP, 111, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInMercySetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.ABILITY_2), localPlayer.mercyAbility2Version), "[{0}] ABILITY 2".format(buttonString(Button.ABILITY_2)), mercySetupAbility2Name[localPlayer.mercyAbility2Version - 1], HudPosition.TOP, 112, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, mercySetupAbility2Desc[localPlayer.mercyAbility2Version - 1], HudPosition.TOP, 113, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, " ", HudPosition.TOP, 114, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInMercySetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.ULTIMATE), localPlayer.mercyUltimateVersion), "[{0}] ULTIMATE".format(buttonString(Button.ULTIMATE)), mercySetupUltimateName[localPlayer.mercyUltimateVersion - 1], HudPosition.TOP, 115, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInMercySetup, mercySetupUltimateDesc[localPlayer.mercyUltimateVersion - 1], HudPosition.TOP, 116, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "mercy player is in spawn":
    @Event eachPlayer
    @Hero mercy
    @Condition isWaitingForPlayers() == true or isInSetup() == true or (isInSetup() == false and eventPlayer.isInSpawnRoom() == true)

    mercyPlayersInSpawn.append(eventPlayer)


rule "mercy player is no longer in spawn or no longer mercy":
    @Event eachPlayer
    @Condition eventPlayer.currentHero != eventPlayer.getCurrentHero() or isWaitingForPlayers() == false or (isWaitingForPlayers() == false and isInSetup() == false and eventPlayer.isInSpawnRoom() == false)

    mercyPlayersInSpawn = mercyPlayersInSpawn.exclude(eventPlayer)
    mercyPlayersInMercySetup = mercyPlayersInMercySetup.exclude(eventPlayer)


rule "mercy player is switching setup mode":
    @Event eachPlayer
    @Hero mercy
    @Condition isWaitingForPlayers() == true or isInSetup() == true or (isInSetup() == false and eventPlayer.isInSpawnRoom() == true)
    @Condition eventPlayer.mercySetupCurProgress < 100
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    do:
        if eventPlayer not in mercyPlayersInMercySetup:
            eventPlayer.mercySetupCurProgress += 2.5
        else:
            eventPlayer.mercySetupCurProgress += 5
        wait()
    while RULE_CONDITION
    if eventPlayer.mercySetupCurProgress == 100:
        if eventPlayer not in mercyPlayersInMercySetup:
            mercyPlayersInMercySetup.append(eventPlayer)
            eventPlayer.setStatusEffect(null, Status.ROOTED, 99999)
            eventPlayer.disallowButton(Button.PRIMARY_FIRE)
            eventPlayer.disallowButton(Button.SECONDARY_FIRE)
            eventPlayer.disallowButton(Button.ABILITY_1)
            eventPlayer.setAbility2Enabled(false)
            eventPlayer.disallowButton(Button.ULTIMATE)
            eventPlayer.disallowButton(Button.INTERACT)
            eventPlayer.disallowButton(Button.MELEE)
            eventPlayer.disallowButton(Button.RELOAD)
        else:
            mercyPlayersInMercySetup = mercyPlayersInMercySetup.exclude(eventPlayer)
    eventPlayer.mercySetupCurProgress = 0
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 99999)


rule "mercy player is changing preset":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInMercySetup
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    eventPlayer.mercyPresetVersion += 1
    if eventPlayer.mercyPresetVersion >= len(mercySetupPresetName):
        eventPlayer.mercyPresetVersion = 1
    switch eventPlayer.mercyPresetVersion:
        case 1:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 1
            eventPlayer.mercyAbility2Version = 1
            eventPlayer.mercyUltimateVersion = 1
            break
        case 2:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 1
            eventPlayer.mercyAbility2Version = 2
            eventPlayer.mercyUltimateVersion = 2
            break
        case 3:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 2
            eventPlayer.mercyAbility2Version = 2
            eventPlayer.mercyUltimateVersion = 3
            break
        case 4:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 2
            eventPlayer.mercyAbility2Version = 3
            eventPlayer.mercyUltimateVersion = 3
            break
        case 5:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 2
            eventPlayer.mercyAbility1Version = 2
            eventPlayer.mercyAbility2Version = 4
            eventPlayer.mercyUltimateVersion = 4
            break
        case 6:
            eventPlayer.mercyPassiveVersion = 2
            eventPlayer.mercyWeaponVersion = 2
            eventPlayer.mercyAbility1Version = 3
            eventPlayer.mercyAbility2Version = 4
            eventPlayer.mercyUltimateVersion = 4
            break
        case 7:
            eventPlayer.mercyPassiveVersion = 3
            eventPlayer.mercyWeaponVersion = 3
            eventPlayer.mercyAbility1Version = 4
            eventPlayer.mercyAbility2Version = 4
            eventPlayer.mercyUltimateVersion = 4
            break
        default:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 1
            eventPlayer.mercyAbility2Version = 1
            eventPlayer.mercyUltimateVersion = 1


rule "mercy player is changing passive":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInMercySetup
    @Condition eventPlayer.mercyPresetVersion <= 7
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    eventPlayer.mercyPresetVersion = 0
    eventPlayer.mercyPassiveVersion += 1
    if eventPlayer.mercyPassiveVersion > len(mercySetupPassiveName):
        eventPlayer.mercyPassiveVersion = 1


rule "mercy player is changing weapon":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInMercySetup
    @Condition eventPlayer.mercyPresetVersion <= 7
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false

    eventPlayer.mercyPresetVersion = 0
    eventPlayer.mercyWeaponVersion += 1
    if eventPlayer.mercyWeaponVersion > len(mercySetupWeaponName):
        eventPlayer.mercyWeaponVersion = 1


rule "mercy player is changing weapon":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInMercySetup
    @Condition eventPlayer.mercyPresetVersion <= 7
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.mercyPresetVersion = 0
    eventPlayer.mercyWeaponVersion = 4


rule "mercy player is changing ability 1":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInMercySetup
    @Condition eventPlayer.mercyPresetVersion <= 7
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true

    eventPlayer.mercyPresetVersion = 0
    eventPlayer.mercyAbility1Version += 1
    if eventPlayer.mercyAbility1Version > len(mercySetupAbility1Name):
        eventPlayer.mercyAbility1Version = 1


rule "mercy player is changing ability 2":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInMercySetup
    @Condition eventPlayer.mercyPresetVersion <= 7
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true

    eventPlayer.mercyPresetVersion = 0
    eventPlayer.mercyAbility2Version += 1
    if eventPlayer.mercyAbility2Version > len(mercySetupAbility2Name):
        eventPlayer.mercyAbility2Version = 1


rule "mercy player is changing ultimate":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInMercySetup
    @Condition eventPlayer.mercyPresetVersion <= 7
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true

    eventPlayer.mercyPresetVersion = 0
    eventPlayer.mercyUltimateVersion += 1
    if eventPlayer.mercyUltimateVersion > len(mercySetupUltimateName):
        eventPlayer.mercyUltimateVersion = 1


rule "setup mercy character":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer not in mercyPlayersInMercySetup
    
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.INTERACT)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
    stopHealingModification(eventPlayer.passiveHealMod)
    stopHoT(eventPlayer.passiveEffect)
    switch eventPlayer.mercyPresetVersion:
        case 1:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 1
            eventPlayer.mercyAbility2Version = 1
            eventPlayer.mercyUltimateVersion = 1
            break
        case 2:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 1
            eventPlayer.mercyAbility2Version = 2
            eventPlayer.mercyUltimateVersion = 2
            break
        case 3:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 2
            eventPlayer.mercyAbility2Version = 2
            eventPlayer.mercyUltimateVersion = 3
            break
        case 4:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 1
            eventPlayer.mercyAbility1Version = 2
            eventPlayer.mercyAbility2Version = 3
            eventPlayer.mercyUltimateVersion = 3
            break
        case 5:
            eventPlayer.mercyPassiveVersion = 1
            eventPlayer.mercyWeaponVersion = 2
            eventPlayer.mercyAbility1Version = 2
            eventPlayer.mercyAbility2Version = 4
            eventPlayer.mercyUltimateVersion = 4
            break
        case 6:
            eventPlayer.mercyPassiveVersion = 2
            eventPlayer.mercyWeaponVersion = 2
            eventPlayer.mercyAbility1Version = 3
            eventPlayer.mercyAbility2Version = 4
            eventPlayer.mercyUltimateVersion = 4
            break
        case 7:
            eventPlayer.mercyPassiveVersion = 3
            eventPlayer.mercyWeaponVersion = 3
            eventPlayer.mercyAbility1Version = 4
            eventPlayer.mercyAbility2Version = 4
            eventPlayer.mercyUltimateVersion = 4
    if eventPlayer.mercyPassiveVersion == 1 or eventPlayer.mercyPassiveVersion == 2:
        startHealingModification(eventPlayer, eventPlayer, 0, HealingReeval.NONE)
        eventPlayer.passiveHealMod = getLastHealingModification()
    destroyDummy(eventPlayer.baDummy.getTeam(), eventPlayer.baDummy.getSlot())
    destroyInWorldText(eventPlayer.baInWorldText)
    if eventPlayer.mercyAbility1Version == 5:
        eventPlayer.baTarget = eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))
        createDummy(Hero.MERCY, eventPlayer.getTeam(), -1, eventPlayer.getPosition(), vect(0, 0, 0))
        eventPlayer.baDummy = getLastCreatedEntity()
        eventPlayer.baDummy.startForcingName(eventPlayer)
        eventPlayer.baDummy.setInvisibility(Invis.ALL)
        eventPlayer.baDummy.setStatusEffect(null, Status.PHASED_OUT, 99999)
        eventPlayer.baDummy.disablePlayerCollision()
        eventPlayer.baDummy.disableEnvironmentCollision(true)
        eventPlayer.baDummy.setGravity(0)
        eventPlayer.baDummy.attachTo(eventPlayer, vect(0, 35, 0))
        createInWorldText(eventPlayer, abilityIconString(Hero.MERCY, Button.ABILITY_1), eventPlayer.baTarget.getPosition() + vect(0, 2, 0), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.WHITE, SpecVisibility.DEFAULT)
        eventPlayer.baInWorldText = getLastCreatedText()
    if eventPlayer.mercyAbility2Version == 1:
        eventPlayer.setAbility2Enabled(false)
    else:
        eventPlayer.setAbility2Enabled(true)
    if eventPlayer.mercyUltimateVersion == 1:
        eventPlayer.disallowButton(Button.ULTIMATE)
    else:
        eventPlayer.allowButton(Button.ULTIMATE)


rule "regen normal":
    @Event playerTookDamage
    @Hero mercy
    @Condition eventPlayer.mercyPassiveVersion == 1 or eventPlayer.mercyPassiveVersion == 2
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isDummy() == false

    stopHoT(eventPlayer.passiveEffect)
    if eventPlayer.mercyPassiveVersion == 1:
        wait(1, Wait.RESTART_WHEN_TRUE)
        if not eventPlayer.isUsingUltimate():
            eventPlayer.startHoT(eventPlayer, 9999, 20 * (mercyRegenHealingPercent / 100))
        else:
            return
    else:
        wait(1.5, Wait.RESTART_WHEN_TRUE)
        if not eventPlayer.isUsingUltimate():
            eventPlayer.startHoT(eventPlayer, 9999, 22.5 * (mercyRegenHealingPercent / 100))
        else:
            return
    eventPlayer.passiveEffect = getLastHoT()


rule "deactivate regen normal":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) >= eventPlayer.getMaxHealth()
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.isDummy() == false
    
    stopHoT(eventPlayer.passiveEffect)


rule "regen valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isDummy() == false

    stopHoT(eventPlayer.passiveEffect)
    if eventPlayer.mercyPassiveVersion == 1:
        eventPlayer.startHoT(eventPlayer, 9999, 20 * (mercyRegenHealingPercent / 100))
    else:
        eventPlayer.startHoT(eventPlayer, 9999, 22.5 * (mercyRegenHealingPercent / 100))
    eventPlayer.passiveEffect = getLastHoT()
    waitUntil(eventPlayer.isDead(), 15)
    if eventPlayer.isDead():
        stopHoT(eventPlayer.passiveEffect)


rule "yellow beam 1.0 normal":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 1
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInMercySetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (60 / 45) * 100


rule "yellow beam 1.0 valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 1
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer not in mercyPlayersInMercySetup
    @Condition eventPlayer.isDummy() == false

    eventPlayer.yellowbeamFactor = 100


rule "yellow beam 1.0 critical":
    @Event global

    startHealingModification(criticalHealthPlayers, [player for player in getPlayersOnHero(Hero.MERCY, Team.ALL) if player.mercyWeaponVersion == 1], (60 / 90) * 100, HealingReeval.RECEIVERS_AND_HEALERS)


rule "yellow beam 2.0 normal":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 2
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInMercySetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (55 / 45) * 100


rule "yellow beam 2.0 valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 2
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer not in mercyPlayersInMercySetup
    @Condition eventPlayer.isDummy() == false

    eventPlayer.yellowbeamFactor = 100


rule "yellow beam 2.0 critical":
    @Event global

    startHealingModification(criticalHealthPlayers, [player for player in getPlayersOnHero(Hero.MERCY, Team.ALL) if player.mercyWeaponVersion == 2 and not player.isUsingUltimate()], (55 / 82.5) * 100, HealingReeval.RECEIVERS_AND_HEALERS)
    startHealingModification(criticalHealthPlayers, [player for player in getPlayersOnHero(Hero.MERCY, Team.ALL) if player.mercyWeaponVersion == 2 and player.isUsingUltimate()], (60 / 90) * 100, HealingReeval.RECEIVERS_AND_HEALERS)


rule "yellow beam 3.0":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 3
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInMercySetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = 100


rule "gun ammo":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.getAmmo(0) <= eventPlayer.getMaxAmmo(0) * 0.2
    @Condition eventPlayer.isDummy() == false
    
    do:
        eventPlayer.disallowButton(Button.PRIMARY_FIRE)
        eventPlayer.forceButtonPress(Button.RELOAD)
        wait()
        waitUntil(not eventPlayer.isReloading(), 10)
    while RULE_CONDITION
    eventPlayer.allowButton(Button.PRIMARY_FIRE)


rule "GA 1.0":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility1Version == 1
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isDummy() == false

    waitUntil(eventPlayer.isInAir(), 99999)
    if eventPlayer.isInAir():
        eventPlayer.disallowButton(Button.JUMP)
        eventPlayer.disallowButton(Button.CROUCH)
        waitUntil(not eventPlayer.isUsingAbility1(), 99999)
        eventPlayer.allowButton(Button.JUMP)
        eventPlayer.allowButton(Button.CROUCH)


rule "GA 2.0":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility1Version == 2
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isDummy() == false

    waitUntil(eventPlayer.isInAir(), 99999)
    if eventPlayer.isInAir():
        eventPlayer.disallowButton(Button.JUMP)
        eventPlayer.disallowButton(Button.CROUCH)
        eventPlayer.gaDirection = normalize(eventPlayer.getVelocity())
        eventPlayer.startFacing(eventPlayer.gaDirection, 9999, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        wait()
        eventPlayer.gaDirection = directionTowards(eventPlayer, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()))
        wait(0.1)
        waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH), 99999)
        if eventPlayer.isHoldingButton(Button.CROUCH) and eventPlayer.getSpeed() <= 9 and not eventPlayer.isUsingUltimate():
            eventPlayer.allowButton(Button.CROUCH)
            eventPlayer.forceButtonPress(Button.CROUCH)
        elif eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.allowButton(Button.JUMP)
            eventPlayer.forceButtonPress(Button.JUMP)
            wait()
            if eventPlayer.getThrottle().z == vect(0, 0, -1).z:
                eventPlayer.applyImpulse(eventPlayer.gaDirection, 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        eventPlayer.stopFacing()
        eventPlayer.allowButton(Button.JUMP)
        eventPlayer.allowButton(Button.CROUCH)


rule "GA cd":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

    if eventPlayer.mercyAbility1Version != 4 and eventPlayer.mercyAbility1Version != 5:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1.5 * (mercyGACooldownPercent / 100))
    else:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2.5 * (mercyGACooldownPercent / 100))


rule "GA range valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isDummy() == false

    eventPlayer.gaRange *= 2
    waitUntil(not eventPlayer.isUsingUltimate(), 15)
    eventPlayer.gaRange /= 2


rule "GA speed valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 2 or eventPlayer.mercyUltimateVersion == 3
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition 4 <= distance(eventPlayer.getPosition() + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()).getPosition() + vect(0, 1.2, 0)) and distance(eventPlayer.getPosition() + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()).getPosition() + vect(0, 1.2, 0)) <= eventPlayer.gaRange + 0.5
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()).getPosition() + vect(0, 1.2, 0), BarrierLos.PASS_THROUGH_BARRIERS) == true
    # @Condition eventPlayer.isInViewAngle(eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()), 17.5) == true
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.setMoveSpeed(33 / 25 * 100)
    waitUntil(not eventPlayer.isUsingAbility1() or not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setMoveSpeed(100)


rule "BA target update":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility1Version == 5
    # @Condition eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) != eventPlayer.baTarget
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).isAlive() == true
    @Condition 4 <= distance(eventPlayer + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) + vect(0, 1.2, 0)) and distance(eventPlayer + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) + vect(0, 1.2, 0)) <= eventPlayer.gaRange + 0.5
    @Condition isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())), BarrierLos.PASS_THROUGH_BARRIERS) == true

    do:
        eventPlayer.baTarget = eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))
        wait()
    while RULE_CONDITION
    eventPlayer.baTarget = null


rule "BA attach update":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility1Version == 5
    @Condition eventPlayer.baTarget != null
    @Condition eventPlayer.isUsingAbility1() == true
    # @Condition eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) != eventPlayer.baTarget
    # @Condition eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).isAlive() == true
    # @Condition 4 <= distance(eventPlayer + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) + vect(0, 1.2, 0)) and distance(eventPlayer + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) + vect(0, 1.2, 0)) <= eventPlayer.gaRange + 0.5
    # @Condition isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())), BarrierLos.PASS_THROUGH_BARRIERS) == true

    # do:
    #     if eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).isAlive() and 4 <= distance(eventPlayer + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) + vect(0, 1.2, 0)) and distance(eventPlayer + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())) + vect(0, 1.2, 0)) <= eventPlayer.gaRange + 0.5 and isInLoS(eventPlayer, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())), BarrierLos.PASS_THROUGH_BARRIERS) and eventPlayer.isAlive() and eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).isAlive() and eventPlayer.isUsingAbility1():
    #         eventPlayer.baTarget = eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))
    #         eventPlayer.baDummy.detach()
    #         eventPlayer.baDummy.attachTo(eventPlayer.baTarget, vect(0, 0, 0))
    #     else:
    #         eventPlayer.baDummy.detach()
    #         eventPlayer.baDummy.attachTo(eventPlayer, vect(0, 35, 0))
    #     wait()
    # while RULE_CONDITION
    # eventPlayer.baDummy.detach()
    eventPlayer.baDummy.attachTo(eventPlayer.baTarget, vect(0, 0, 0))
    waitUntil(eventPlayer.isInAir(), 99999)
    wait(0.1)
    # eventPlayer.baDummy.detach()
    eventPlayer.baDummy.attachTo(eventPlayer, vect(0, 35, 0))


rule "no rez reduce ult cost":
    @Event eachPlayer
    @Condition eventPlayer.mercyAbility2Version == 1
    @Condition eventPlayer.getUltCharge() >= 80

    eventPlayer.setUltCharge(100)


rule "rez targeting":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition distance(eventPlayer.getPosition() + eventPlayer.eyePositionOffset, eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()).getPosition() + vect(0, 1.2, 0)) <= 5.5
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()).getPosition() + vect(0, 1.2, 0), BarrierLos.PASS_THROUGH_BARRIERS) == true
    @Condition eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()).isDead() == true
    @Condition eventPlayer.isDummy() == false

    do:
        eventPlayer.rezTarget = eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam())
        wait()
    while RULE_CONDITION
    eventPlayer.rezTarget = null


rule "valk 1.0 rez reset":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isDummy() == false

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


rule "valk 2.0 bonus rez charge":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 3
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isDummy() == false

    # eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


rule "mass rez targeting":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion != 4
    @Condition eventPlayer.mercyUltimateVersion == 1
    @Condition eventPlayer.getUltCharge() == 100
    @Condition len([player for player in getDeadPlayers(eventPlayer.getTeam()) if distance(eventPlayer.getPosition(), player.getPosition()) <= 15.5].exclude(eventPlayer)) >= 1

    do:
        eventPlayer.massrezTargets = [player for player in getDeadPlayers(eventPlayer.getTeam()) if distance(eventPlayer.getPosition(), player.getPosition()) <= 15.5].exclude(eventPlayer)
        wait()
    while RULE_CONDITION
    eventPlayer.massrezTargets = null


rule "mass rez display":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 1
    @Condition len(eventPlayer.massrezTargets) >= 1

    do:
        eventPlayer.massrezCurTargetCount = len(eventPlayer.massrezTargets)
        hudSubtext(eventPlayer, "\n\n", HudPosition.TOP, 1000, Color.WHITE, HudReeval.NONE)
        eventPlayer.massrezHUDSpacer = getLastCreatedText()
        if len(eventPlayer.massrezTargets) == 1:
            hudSubheader(eventPlayer, "{0} TEAMMATE DOWN X{1}".format(iconString(Icon.SKULL), len(eventPlayer.massrezTargets)), HudPosition.TOP, 1001, rgb(247, 152, 20), HudReeval.STRING)
        elif len(eventPlayer.massrezTargets) == 2:
            hudSubtext(eventPlayer, "{0} TEAMMATE DOWN X{1}".format(iconString(Icon.SKULL), len(eventPlayer.massrezTargets)), HudPosition.TOP, 1001, rgb(247, 152, 20), HudReeval.STRING)
        elif len(eventPlayer.massrezTargets) >= 3:
            hudHeader(eventPlayer, "{0} TEAMMATE DOWN X{1}".format(iconString(Icon.SKULL), len(eventPlayer.massrezTargets)), HudPosition.TOP, 1001, rgb(247, 152, 20), HudReeval.STRING)
        eventPlayer.massrezHUDText = getLastCreatedText()
        waitUntil(len(eventPlayer.massrezTargets) != eventPlayer.massrezCurTargetCount, 99999)
        destroyHudText(eventPlayer.massrezHUDSpacer)
        destroyHudText(eventPlayer.massrezHUDText)
    while RULE_CONDITION


rule "medigun targeting":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 4

    eventPlayer.medigunTarget = healee
    if eventPlayer.isCastingUbercharge:
        eventPlayer.medigunTarget.isUbercharged = true
    else:
        eventPlayer.medigunTarget.isUbercharged = false
    wait(0.05, Wait.RESTART_WHEN_TRUE)
    eventPlayer.medigunTarget.isUbercharged = false
    eventPlayer.medigunTarget = null


rule "medigun healing":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 4
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInMercySetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (40 / 45) * 100


rule "medigun healing factor":
    @Event playerTookDamage
    @Condition getPlayersOnHero(Hero.MERCY, eventPlayer.getTeam()).mercyWeaponVersion == 4

    eventPlayer.medigunHealingFactor = max(eventPlayer.medigunHealingFactor - eventDamage / 200, 1)
    wait(1.5, Wait.RESTART_WHEN_TRUE)
    while eventPlayer.medigunHealingFactor < 3:
        eventPlayer.medigunHealingFactor += 0.01
        wait(3.5 / 100, Wait.RESTART_WHEN_TRUE)


rule "medigun healing mod":
    @Event eachPlayer

    startHealingModification(eventPlayer, [player for player in getPlayersOnHero(Hero.MERCY, eventPlayer.getTeam()) if player.mercyWeaponVersion == 4], eventPlayer.medigunHealingFactor * 100, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)


rule "":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()

    createInWorldText(hostPlayer, eventPlayer.medigunHealingFactor, eventPlayer.getEyePosition() + vect(0, 1, 0), 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE, SpecVisibility.DEFAULT)


rule "medigun overheal":
    @Event playerReceivedHealing
    @Condition healer != healee
    @Condition healer.mercyWeaponVersion == 4
    @Condition healer.getCurrentHero() == Hero.MERCY
    @Condition eventPlayer.getHealth() == eventPlayer.getMaxHealth()
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL) < (eventPlayer.getMaxHealth() / 2)

    eventPlayer.currentOverhealth = eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL)
    removeHealthPool(eventPlayer.overhealthPool)
    eventPlayer.addHealthPool(Health.NORMAL, min((eventPlayer.getMaxHealth() / 2), eventPlayer.currentOverhealth + (40 * eventPlayer.medigunHealingFactor   ) / 32), false, false)
    eventPlayer.overhealthPool = getLastCreatedHealthPool()
    wait(0.5, Wait.RESTART_WHEN_TRUE)
    while eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer.getMaxHealthOfType(Health.NORMAL):
        eventPlayer.currentOverhealth = eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL)
        removeHealthPool(eventPlayer.overhealthPool)
        if eventPlayer.currentOverhealth <= 50 * 0.025:
            return
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.currentOverhealth - (eventPlayer.getMaxHealth() / 2) / 15 * 0.025, false, false)
        eventPlayer.overhealthPool = getLastCreatedHealthPool()
        wait(0.025, Wait.RESTART_WHEN_TRUE)


rule "medigun overheal bug fix":
    @Event eachPlayer
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) * 999 > eventPlayer.getMaxHealthOfType(Health.NORMAL)

    eventPlayer.currentOverhealth = 0
    removeHealthPool(eventPlayer.overhealthPool)


rule "vaccinator":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 4
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0

    eventPlayer.isVaccinated = true
    eventPlayer.medigunTarget.isVaccinated = true
    wait(2.5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10)


rule "getting vaccinated":
    @Event eachPlayer
    @Condition eventPlayer.isVaccinated == true

    eventPlayer.setDamageReceived(25)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR, eventPlayer.teamColor, eventPlayer, 1)
    playEffect(getAllPlayers(), DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR, eventPlayer.teamColor, eventPlayer, 1)
    createEffect(getAllPlayers(), Effect.GOOD_AURA, eventPlayer.teamColor, eventPlayer, 1.25, EffectReeval.NONE)
    eventPlayer.vaccinatorVisualEffect1 = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, eventPlayer.teamColor, eventPlayer, 1, EffectReeval.NONE)
    eventPlayer.vaccinatorVisualEffect2 = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND, eventPlayer.teamColor, eventPlayer, 100, EffectReeval.NONE)
    eventPlayer.vaccinatorSoundEffect = getLastCreatedEntity()
    wait(2.5)
    eventPlayer.setDamageReceived(100)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, eventPlayer.teamColor, eventPlayer, 1)
    destroyEffect(eventPlayer.vaccinatorVisualEffect1)
    destroyEffect(eventPlayer.vaccinatorVisualEffect2)
    destroyEffect(eventPlayer.vaccinatorSoundEffect)
    eventPlayer.isVaccinated = false


rule "ubersaw":
    @Event playerDealtDamage
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 4
    @Condition eventAbility == Button.MELEE

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 20)


rule "ubercharge":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 4
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100

    eventPlayer.isCastingUbercharge = true
    eventPlayer.isUbercharged = true
    eventPlayer.medigunTarget.isUbercharged = true


rule "ubercharge drain rate":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isCastingUbercharge == true
    @Condition eventPlayer.getUltCharge() > 0

    do:
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() - 1)
        wait(1 / 12.5 / max(len([player for player in getPlayers(eventPlayer.getTeam()) if player.hasStatusEffect(Status.INVINCIBLE)]) - 1, 1))
    while RULE_CONDITION
    eventPlayer.isUbercharged = false
    eventPlayer.isCastingUbercharge = false


rule "getting ubercharged":
    @Event eachPlayer
    @Condition eventPlayer.isUbercharged == true

    destroyEffect(eventPlayer.uberchargeVisualEffect1)
    destroyEffect(eventPlayer.uberchargeVisualEffect2)
    destroyEffect(eventPlayer.uberchargeSoundEffect)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    playEffect(getAllPlayers(), DynamicEffect.SYMMETRA_TELEPORTER_REAPPEAR, eventPlayer.teamColor, eventPlayer, 1)
    createEffect(getAllPlayers(), Effect.ECHO_CLONING, eventPlayer.teamColor, eventPlayer, 1, EffectReeval.NONE)
    eventPlayer.uberchargeVisualEffect1 = getLastCreatedEntity()
    createEffect(eventPlayer, Effect.ANA_NANO_BOOSTED, eventPlayer.teamColor, eventPlayer, 1, EffectReeval.NONE)
    eventPlayer.uberchargeVisualEffect2 = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED_SOUND, eventPlayer.teamColor, eventPlayer, 100, EffectReeval.NONE)
    eventPlayer.uberchargeSoundEffect = getLastCreatedEntity()
    waitUntil(not eventPlayer.isUbercharged, 20)
    eventPlayer.isUbercharged = false
    wait(1, Wait.RESTART_WHEN_TRUE)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, eventPlayer.teamColor, eventPlayer, 1)
    destroyEffect(eventPlayer.uberchargeVisualEffect1)
    destroyEffect(eventPlayer.uberchargeVisualEffect2)
    destroyEffect(eventPlayer.uberchargeSoundEffect)


rule "workshop inspector":
    @Event global

    if not debugToggle:
        disableInspector()


rule "host status effect":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostStatusEffect > 0
    @Condition hostPlayer.hasSpawned() == true

    switch debugHostStatusEffect:
        case 1:
            hostPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
            break
        case 2:
            hostPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
            break
        case 3:
            hostPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)


rule "host instalock mercy":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostInstaLockMercy == true
    @Condition hostPlayer.hasSpawned() == true

    wait()
    hostPlayer.startForcingHero(Hero.MERCY)


rule "host give ult when spawn":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostPermaUlt == true
    @Condition hostPlayer.hasSpawned() == true
    
    hostPlayer.setUltCharge(100)


rule "host give ult when switch":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostPermaUlt == true
    @Condition hostPlayer.currentHero != hostPlayer.getCurrentHero()
    
    wait()
    hostPlayer.setUltCharge(100)


rule "host give ult when ult done":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostPermaUlt == true
    @Condition hostPlayer.isUsingUltimate() == false
    @Condition hostPlayer.getUltCharge() < 100
    @Condition hostPlayer.isCastingUbercharge == false
    @Condition hostPlayer.hasStatusEffect(Status.INVINCIBLE) == false
    
    hostPlayer.setUltCharge(100)


rule "host hurt self":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostHurtSelfButton == true
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    damage(hostPlayer, hostPlayer, hostPlayer.getHealth() - 1)


rule "host hurt player":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostHurtPlayerButton == true
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    damage(hostPlayer.getPlayerClosestToReticle(Team.ALL), hostPlayer.getPlayerClosestToReticle(Team.ALL), hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).getHealth() - 1)
    hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).setMoveSpeed(0)
    hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).setJumpEnabled(false)
    hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).teleport(hostPlayer.getPosition())


rule "host kill self":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostKillSelfButton == true
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.RELOAD) == true
    
    kill(hostPlayer, hostPlayer)


rule "host kill player":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostKillPlayerButton == true
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.MELEE) == true
    
    kill(hostPlayer.getPlayerClosestToReticle(Team.ALL), hostPlayer.getPlayerClosestToReticle(Team.ALL))
    hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).teleport(hostPlayer.getPosition())


rule "host heal dummy":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostHealDummyButton == true
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.INTERACT) == true
    
    destroyDummy(debugHealDummy.getTeam(), debugHealDummy.getSlot())
    createDummy(Hero.ANA, hostPlayer.getTeam(), -1, hostPlayer.getPosition(), hostPlayer.getFacingDirection())
    debugHealDummy = getLastCreatedEntity()
    debugHealDummy.setMaxHealth(10000)
    wait()
    debugHealDummy.setHealth(1)


rule "host boost dummy":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostBoostDummyButton == true
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    destroyDummy(debugBoostDummy.getTeam(), debugBoostDummy.getSlot())
    createDummy(Hero.MOIRA, hostPlayer.getTeam(), -1, hostPlayer.getPosition(), hostPlayer.getFacingDirection())
    debugBoostDummy = getLastCreatedEntity()
    debugBoostDummy.setStatusEffect(null, Status.PHASED_OUT, 99999)
    debugBoostDummy.startForcingButton(Button.SECONDARY_FIRE)


rule "host damage dummy":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostDamageDummyButton == true
    @Condition hostPlayer.isHoldingButton(Button.CROUCH) == true
    @Condition hostPlayer.isHoldingButton(Button.JUMP) == true
    
    destroyDummy(debugDamageDummy.getTeam(), debugDamageDummy.getSlot())
    createDummy(Hero.ANA, getOppositeTeam(hostPlayer.getTeam()), -1, hostPlayer.getPosition(), hostPlayer.getFacingDirection())
    debugDamageDummy = getLastCreatedEntity()
    debugDamageDummy.setMaxHealth(10000)


rule "host server load":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostServerLoad == true
    @Condition hostPlayer.hasSpawned() == true

    hudSubtext(hostPlayer, "{0} CUR | {1} AVG | {2} PEAK".format(getServerLoad(), getAverageServerLoad(), getPeakServerLoad()), HudPosition.LEFT, 100, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    hudSubtext(hostPlayer, hostPlayer.rezTarget, HudPosition.LEFT, 101, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)


rule "host speedometer":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostSpeedometer == true
    @Condition hostPlayer.hasSpawned() == true
    
    hudSubtext(hostPlayer, "{0} H M/S | {1} V M/S | {2} FW M/S".format(updateEveryTick(hostPlayer.getHorizontalSpeed()), updateEveryTick(hostPlayer.getVerticalSpeed()), updateEveryTick(hostPlayer.getSpeedInDirection(hostPlayer.getFacingDirection()))), HudPosition.LEFT, 101, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    hudSubtext(hostPlayer, hostPlayer.getThrottle(), HudPosition.LEFT, 102, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    hudSubtext(hostPlayer, hostPlayer.getVelocity(), HudPosition.LEFT, 103, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    hudSubtext(hostPlayer, hostPlayer.getFacingDirection(), HudPosition.LEFT, 104, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)


rule "host targeting":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostTargeting == true
    @Condition hostPlayer.hasSpawned() == true

    hudSubtext(hostPlayer, hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()), HudPosition.TOP, 1000, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    # hudSubtext(hostPlayer, "LOS {0}".format(isInLoS(hostPlayer.getEyePosition(), hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).getPosition() + vect(0, 1.2, 0), BarrierLos.PASS_THROUGH_BARRIERS)), HudPosition.TOP, 101, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    # hudSubtext(hostPlayer, "REZ ANGLE {0}".format(hostPlayer.isInViewAngle(hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()), 100)), HudPosition.TOP, 102, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    # hudSubtext(hostPlayer, "RANGE | GA {0} | REZ {1}".format(distance(hostPlayer.getPosition() + hostPlayer.eyePositionOffset, hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).getEyePosition()) <= hostPlayer.gaRange + 0.5, distance(hostPlayer.getPosition() + hostPlayer.eyePositionOffset, hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).getEyePosition()) <= 5.5), HudPosition.TOP, 103, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    # hudSubtext(hostPlayer, "{0} DEG".format(angleBetweenVectors(hostPlayer.getFacingDirection(), vectorTowards(hostPlayer.getPosition(), hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam())))), HudPosition.TOP, 104, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    # hudSubtext(hostPlayer, "{0} M".format(distance(hostPlayer.getPosition(), hostPlayer.getPlayerClosestToReticle(hostPlayer.getTeam()).getPosition())), HudPosition.TOP, 105, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)
    hudSubtext(hostPlayer, hostPlayer.rezTarget, HudPosition.TOP, 1001, Color.WHITE, HudReeval.STRING, SpecVisibility.NEVER)


rule "player permadeath":
    @Event eachPlayer
    @Condition debugToggle == true
    @Condition debugPlayerPermaDeath == true
    @Condition eventPlayer != hostPlayer
    
    eventPlayer.setRespawnTime(9999)

