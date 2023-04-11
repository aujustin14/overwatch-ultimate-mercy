#Global variables

globalvar ultVoicelineDummy 0
globalvar rezEventOrder 1
globalvar rezEventCaster 2
globalvar rezEventTarget 3
globalvar rezEventKillfeed 4
globalvar rezEventAbilityName 5
globalvar rezEventAbilityIcon 6
globalvar criticalHealthPlayers 7
globalvar fullNonShieldHealthPlayers 8
globalvar gameQuickAssemble 9
globalvar gameQuickSetup 10
globalvar mercyRegenHealingPercent 11
globalvar mercyYellowbeamHealingPercent 12
globalvar mercyGACooldownPercent 13
globalvar mercyRezCooldownPercent 14
globalvar mercyPlayersCanSetup 15
globalvar mercyPlayersInSetup 16
globalvar mercySetupPresetList 17
globalvar mercySetupPresetName 18
globalvar mercySetupPresetDesc 19
globalvar mercySetupPassiveName 20
globalvar mercySetupPassiveDesc 21
globalvar mercySetupWeaponName 22
globalvar mercySetupWeaponDesc 23
globalvar mercySetupAbility1Name 24
globalvar mercySetupAbility1Desc 25
globalvar mercySetupAbility2Name 26
globalvar mercySetupAbility2Desc 27
globalvar mercySetupUltimateName 28
globalvar mercySetupUltimateDesc 29
globalvar debugToggle 30
globalvar debugHostStatusEffect 31
globalvar debugHostInstaLockMercy 32
globalvar debugHostPermaUlt 33
globalvar debugHostHurtSelfButton 34
globalvar debugHostHurtPlayerButton 35
globalvar debugHostKillSelfButton 36
globalvar debugHostKillPlayerButton 37
globalvar debugHostHealDummyButton 38
globalvar debugHealDummy 39
globalvar debugHostBoostDummyButton 40
globalvar debugBoostDummy 41
globalvar debugHostDamageDummyButton 42
globalvar debugDamageDummy 43
globalvar debugHostServerLoad 44
globalvar debugHostSpeedometer 45
globalvar debugHostTargeting 46
globalvar debugPlayerPermaDeath 47

#Player variables

playervar currentHero 0
playervar isBeingResurrected 1
playervar isImmobile 2
playervar isInvulnerable 3
playervar hasSuperjumped 4
playervar passiveHealMod 5
playervar passiveEffect 6
playervar beamTarget 7
playervar beamRange 8
playervar yellowbeamHealMod 9
playervar yellowbeamFactor 10
playervar gaRange 11
playervar gaVelocity 12
playervar gaLastKnownDirection 13
playervar gaCanonDummy 14
playervar baDummy 15
playervar baTarget 16
playervar rezTarget 17
playervar rezLastCooldown 18
playervar rezLastTimeElapsed 19
playervar rezBonusChargeHUD 20
playervar rezVisualEffect 21
playervar rezSoundEffect 22
playervar rezCameraOffset 23
playervar rezAssist 24
playervar teamIndex 25
playervar teamColor 26
playervar eyePositionOffset 27
playervar massrezTargets 28
playervar massrezCurTargetCount 29
playervar massrezHUDSpacer 30
playervar massrezHUDText 31
playervar valkCanonDummy 32
playervar valkCanonBar 33
playervar valkCanonCurProgress 34
playervar isValkDummy 35
playervar medigunTarget 36
playervar medigunHealingFactor 37
playervar currentOverhealth 38
playervar overhealthPool 39
playervar isVaccinated 40
playervar vaccinatorVisualEffect1 41
playervar vaccinatorVisualEffect2 42
playervar vaccinatorSoundEffect 43
playervar isCastingUbercharge 44
playervar isUbercharged 45
playervar uberchargeVisualEffect1 46
playervar uberchargeVisualEffect2 47
playervar uberchargeSoundEffect 48
playervar isInMercySetup 49
playervar mercySetupBar 50
playervar mercySetupCurProgress 51
playervar mercySetupCurSetup 52
playervar mercyPresetVersion 53
playervar mercyPassiveVersion 54
playervar mercyWeaponVersion 55
playervar mercyAbility1Version 56
playervar mercyAbility2Version 57
playervar mercyUltimateVersion 58
playervar isCastingExtendedUltimate 59
playervar maxHealth 60
playervar Z 61


#Subroutine names

subroutine createUltVoicelineDummy 0
subroutine destroyUltVoicelineDummy 1
subroutine updateMercyPresetVersion 2


#Activated extensions

#!extension buffAndDebuffSounds
#!extension buffStatusEffects
#!extension energyExplosionEffects


def createUltVoicelineDummy():
    @Name "create ult voiceline dummy"
    
    destroyDummy(ultVoicelineDummy[eventPlayer.teamIndex].getTeam(), ultVoicelineDummy[eventPlayer.teamIndex].getSlot())
    createDummy(Hero.MERCY, eventPlayer.getTeam(), -1, eventPlayer.getPosition() + vect(0, 2.5, 0), eventPlayer.getFacingDirection())
    ultVoicelineDummy[eventPlayer.teamIndex] = getLastCreatedEntity()
    wait()
    ultVoicelineDummy[eventPlayer.teamIndex].startForcingName(rezEventCaster)
    ultVoicelineDummy[eventPlayer.teamIndex].setInvisibility(Invis.ALL)
    ultVoicelineDummy[eventPlayer.teamIndex].setStatusEffect(null, Status.PHASED_OUT, 9999)
    ultVoicelineDummy[eventPlayer.teamIndex].disablePlayerCollision()
    ultVoicelineDummy[eventPlayer.teamIndex].disableEnvironmentCollision(true)
    if rezEventAbilityIcon == abilityIconString(Hero.MERCY, Button.ABILITY_2):
        ultVoicelineDummy[eventPlayer.teamIndex].startModifyingVoicelinePitch(1.1, false)
    ultVoicelineDummy[eventPlayer.teamIndex].setUltCharge(100)
    ultVoicelineDummy[eventPlayer.teamIndex].forceButtonPress(Button.ULTIMATE)
    wait(0.016, Wait.RESTART_WHEN_TRUE)
    ultVoicelineDummy[eventPlayer.teamIndex].attachTo(eventPlayer, vect(0, 0, 0))

def destroyUltVoicelineDummy():
    @Name "destroy ult voiceline dummy"

    destroyDummy(ultVoicelineDummy[eventPlayer.teamIndex].getTeam(), ultVoicelineDummy[eventPlayer.teamIndex].getSlot())


def updateMercyPresetVersion():
    @Name "update mercy preset version"

    eventPlayer.mercySetupCurSetup = 10000 * eventPlayer.mercyPassiveVersion + 1000 * eventPlayer.mercyWeaponVersion + 100 * eventPlayer.mercyAbility1Version + 10 * eventPlayer.mercyAbility2Version + eventPlayer.mercyUltimateVersion
    for eventPlayer.Z in range(len(mercySetupPresetList)):
        if mercySetupPresetList[eventPlayer.Z] == eventPlayer.mercySetupCurSetup:
            eventPlayer.mercyPresetVersion = eventPlayer.Z
            return
    eventPlayer.mercyPresetVersion = 0


rule "global initialize":
    ultVoicelineDummy = [null, null]
    rezEventOrder = -1
    rezEventCaster = null
    rezEventTarget = null
    rezEventAbilityIcon = null
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
    mercySetupPresetList = [11111, 11111, 12112, 12123, 12224, 12234, 13245, 23345, 34445, 35556, 46778]
    mercySetupPresetName = ["CUSTOM", "MERCY (ALPHA)", "MERCY 1.0", "MERCY 2.0", "MERCY 3.0", "MERCY 4.0", "MERCY 5.0", "MERCY 6.0", "MERCY 7.0", "MERCY (CANON)", "TF2 MEDIC"]
    mercySetupPresetDesc = ["CUSTOM PRESET", "14 MAY 2015", "24 MAY 2016 - 19 SEP 2017", "19 SEP 2017 - 17 OCT 2017", "17 OCT 2017 - 16 NOV 2017", "16 NOV 2017 - 30 JAN 2018", "30 JAN 2018 - 12 MAY 2022", "4 OCT 2022 - 7 FEB 2023", "7 FEB 2023 - CURRENT", "I'LL BE WATCHING OVER YOU", "LET'S GO PRACTICE MEDICINE"]
    mercySetupPassiveName = ["REGENERATION 1.0", "REGENERATION 2.0", "SYMPATHETIC RECOVERY", "MEDIC'S REGENERATION (NOT YET IMPLEMENTED)"]
    mercySetupPassiveDesc = ["RECEIVE 20 HPS AFTER NOT TAKING DAMAGE FOR 1 S", "RECEIVE 22.5 HPS AFTER NOT TAKING DAMAGE FOR 1.5 S", "RECEIVE 25% OF HEALING DEALT TO OTHERS", "CONSTANTLY RECEIVE 10 HPS (+12.5% HPS PER S, UP TO +100% HPS, TAKING DAMAGE RESETS BONUS / +100% HPS WHEN HEALING INJURED ALLIES / BONUSES STACK MULTIPLICATIVELY)"]
    mercySetupWeaponName = ["CADUCEUS STAFF (ALPHA)", "CADUCEUS STAFF 1.0", "CADUCEUS STAFF 2.0", "CADUCEUS STAFF 3.0", "CADUCEUS STAFF (CANON)", "MEDIC'S MEDIGUN"]
    mercySetupWeaponDesc = ["DEAL 50 HPS TO A TARGET (CAN'T HEAL SHIELD HEALTH) / BOOST DAMAGE OF A TARGET BY 30%", "DEAL 60 HPS TO A TARGET / BOOST DAMAGE OF A TARGET BY 30%", "DEAL 55 HPS TO A TARGET (+5 HPS DURING VALKYRIE) / BOOST DAMAGE OF A TARGET BY 30%", "DEAL 45 HPS TO A TARGET (+33.3% HPS DURING VALKYRIE / +50% HPS WHEN TARGET IS AT CRITICAL HEALTH / BONUSES STACK MULTIPLICATIVELY) / BOOST DAMAGE OF A TARGET BY 30%", "DEAL 60 HPS TO A TARGET", "DEAL 30 HPS TO A TARGET (+25% HPS PER S FOR EACH ALLY, UP TO +200% HPS, EVERY 3 DAMAGE TAKEN BY AN ALLY REDUCES BONUS BY 1% FOR THAT ALLY)"]
    mercySetupAbility1Name = ["GUARDIAN ANGEL 1.0", "GUARDIAN ANGEL 2.0", "GUARDIAN ANGEL 3.0", "GUARDIAN ANGEL 4.0", "GUARDIAN ANGEL (CANON)", "BATTLE ANGEL", "MEDIC'S HASTE (NOT YET IMPLEMENTED)"]
    mercySetupAbility1Desc = ["FLY TO AN ALLY (1.5 S CD / NO SLINGSHOT OR NO SUPERJUMP)", "FLY TO AN ALLY (1.5 CD / FORWARD SLINGSHOT)", "FLY TO AN ALLY (1.5 S CD / OMNIDIRECTIONAL SLINGSHOT / SUPERJUMP WHENEVER)", "FLY TO AN ALLY (2.5 S CD / OMNIDIRECTIONAL SLINGSHOT, -20% SPEED DURING BACKWARDS SLINGSHOT / SUPERJUMP WHENEVER)", "FLY THE MAXIMUM DISTANCE (1.5 S CD / NO SLINGSHOT / NO SUPERJUMP)", "FLY TO AN ALLY/ENEMY (2.5 S CD / OMNIDIRECTIONAL SLINGSHOT / SUPERJUMP WHENEVER)", "NO ABILITY 1 / INCREASES MOVEMENT SPEED BY 40%"]
    mercySetupAbility2Name = ["NONE", "RESURRECT 1.0", "RESURRECT 2.0", "RESURRECT 3.0", "RESURRECT (CANON) (NOT YET IMPLEMENTED)", "VALKYRIE (NOT YET IMPLEMENTED)", "MEDIC'S VACCINATOR"]
    mercySetupAbility2Desc = ["NO ABILITY 2 / -10% ULT COST", "REVIVE A NEARBY DEAD ALLY WITHIN A 5M RADIUS (30 S CD / INSTANT CAST)", "REVIVE A NEARBY DEAD ALLY WITHIN A 5M RADIUS (30 S CD / 1.75 S CAST TIME / INSTANT CAST DURING VALKYRIE)", "REVIVE A NEARBY DEAD ALLY WITHIN A 5M RADIUS (30 S CD / 1.75 S CAST TIME)", "DEAL 100 HPS TO AN ALLY FOR 1.75 S (15 S CD)", "ENHANCE ALL ABILITIES AND GAIN THE ABILITY TO FLY", "CREATE A BUBBLE FOR YOU AND YOUR HEALING TARGET, BLOCKING 50% INCOMING DAMAGE (2.5 S DURATION / 8 S CD)"]
    mercySetupUltimateName = ["MASS RESURRECT (ALPHA)", "MASS RESURRECT", "VALKYRIE 1.0", "VALKYRIE 2.0", "VALKYRIE 3.0", "VALKYRIE (CANON)", "RESURRECT (NOT YET IMPLEMENTED)", "MEDIC'S UBERCHARGE"]
    mercySetupUltimateDesc = ["REVIVE NEARBY DEAD ALLIES (15 M RADIUS / 1.5 S CAST TIME / DOES NOT REQUIRE LOS / IMMOBILE DURING CAST / -20% ULT COST)", "REVIVE NEARBY DEAD ALLIES (15 M RADIUS / 2.25 S CAST TIME / DOES NOT REQUIRE LOS / INVULNERABILITY DURING CAST)", "ENHANCE ALL ABILITIES AND GAIN THE ABILITY TO FLY (20 S DURATION / PASSIVE ALWAYS ACTIVE / CHAIN BEAM / INFINITE AMMO / INCREASES GA RANGE AND SPEED / RESETS REZ ON CAST AND SHORTENS REZ CD)", "ENHANCE ALL ABILITIES AND GAIN THE ABILITY TO FLY (20 S DURATION / PASSIVE ALWAYS ACTIVE / CHAIN BEAM / INFINITE AMMO / INCREASES GA RANGE AND SPEED / GIVES A BONUS REZ CHARGE)", "ENHANCE ALL ABILITIES AND GAIN THE ABILITY TO FLY (15 S DURATION / PASSIVE ALWAYS ACTIVE / CHAIN BEAM / INFINITE AMMO / INCREASES GA RANGE AND SPEED)", "GAIN THE ABILITY TO FLY (15 S DURATION / -50% ULT COST)", "REVIVE NEARBY DEAD ALLIES (8 M RADIUS / REQUIRES LOS / 1.25 S CAST TIME)", "BECOME INVINCIBLE FOR YOU AND YOUR HEALING TARGET (LASTS UP TO 10 S, MULTIPLE TARGETS REDUCE TOTAL DURATION)"]
    mercyPlayersCanSetup = []
    mercyPlayersInSetup = []


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
    eventPlayer.gaVelocity = vect(0, 0, 0)
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
    eventPlayer.mercyPresetVersion = 8


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
    eventPlayer.maxHealth = eventPlayer.getMaxHealth()


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

    setMatchTime(25)


rule "game quick setup teleport":
    @Event eachPlayer
    @Condition gameQuickSetup == true
    @Condition eventPlayer.hasSpawned() == true

    wait()
    eventPlayer.teleport(getObjectivePosition(0) + vect(0, 5, 0))


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


rule "player is at full non shield health":
    @Event eachPlayer
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) >= eventPlayer.getMaxHealthOfType(Health.NORMAL)
    @Condition eventPlayer.isDummy() == false

    fullNonShieldHealthPlayers.append(eventPlayer)


rule "player is no longer at full non shield health":
    @Event eachPlayer
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) < eventPlayer.getMaxHealthOfType(Health.NORMAL)
    @Condition eventPlayer.isDummy() == false

    fullNonShieldHealthPlayers.remove(eventPlayer)


rule "casting rez":
    @Event eachPlayer
    @Hero mercy
    @Condition (eventPlayer.mercyAbility2Version in [2, 3, 4] and eventPlayer.isUsingAbility2()) or (eventPlayer.mercyUltimateVersion in [1, 2] and eventPlayer.isHoldingButton(Button.ULTIMATE) and eventPlayer.getUltCharge() == 100 and eventPlayer.massrezTargets != null and eventPlayer.isAlive() and not eventPlayer.hasStatusEffect(Status.ASLEEP) and not eventPlayer.hasStatusEffect(Status.FROZEN) and not eventPlayer.hasStatusEffect(Status.HACKED) and not eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) and not eventPlayer.hasStatusEffect(Status.STUNNED) and eventPlayer not in mercyPlayersInSetup) == true
    @Condition eventPlayer.isDummy() == false
    
    rezEventCaster = eventPlayer
    if eventPlayer.isUsingAbility2():
        if eventPlayer.mercyAbility2Version == 2 or (eventPlayer.mercyAbility2Version == 3 and eventPlayer.isUsingUltimate()):
            eventPlayer.cancelPrimaryAction()
            eventPlayer.rezTarget = [(sorted([player for player in getDeadPlayers(eventPlayer.getTeam()) if distance(eventPlayer.getPosition() + eventPlayer.eyePositionOffset, player.getPosition() + vect(0, 1.2, 0)) <= 5.5], lambda i: angleBetweenVectors(eventPlayer.getFacingDirection(), vectorTowards(eventPlayer.getPosition(), i.getPosition()))))[0]]
            if eventPlayer.rezTarget != null:
                eventPlayer.rezTarget.isBeingResurrected = true
                rezEventTarget = eventPlayer.rezTarget
                rezEventAbilityName = "RESURRECT"
                rezEventAbilityIcon = abilityIconString(Hero.MERCY, Button.ABILITY_2)
            else:
                eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
                rezEventCaster = null
                rezEventTarget = null
                rezEventAbilityName = null
                rezEventAbilityIcon = null
                return
        elif eventPlayer.mercyAbility2Version in [3, 4]:
            waitUntil(not eventPlayer.isUsingAbility2(), 99999)
        if eventPlayer.isUsingUltimate():
            if eventPlayer.mercyUltimateVersion == 2:
                eventPlayer.setAbilityCooldown(Button.ABILITY_2, 10 * (mercyRezCooldownPercent / 100))
            elif eventPlayer.mercyUltimateVersion == 3 and eventPlayer.rezLastCooldown != -1 and eventPlayer.rezLastTimeElapsed != -1:
                eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.rezLastCooldown - (getTotalTimeElapsed() - eventPlayer.rezLastTimeElapsed))
                eventPlayer.rezLastCooldown = -1
                eventPlayer.rezLastTimeElapsed = -1
                destroyHudText(eventPlayer.rezBonusChargeHUD)
        else:
            eventPlayer.setAbilityCooldown(Button.ABILITY_2, 30 * (mercyRezCooldownPercent / 100))
        eventPlayer.rezTarget = null
        if (eventPlayer.mercyAbility2Version == 3 and not eventPlayer.isUsingUltimate()) or eventPlayer.mercyAbility2Version == 4:
            return
    elif eventPlayer.isHoldingButton(Button.ULTIMATE):
        eventPlayer.massrezTargets.isBeingResurrected = true
        rezEventTarget = eventPlayer.massrezTargets
        rezEventAbilityName = "MASS RESURRECT"
        rezEventAbilityIcon = abilityIconString(Hero.MERCY, Button.ULTIMATE)
        if eventPlayer.mercyUltimateVersion == 1:
            eventPlayer.isImmobile = true
        elif eventPlayer.mercyUltimateVersion == 2:
            eventPlayer.isInvulnerable = true
        eventPlayer.setUltCharge(0)
        eventPlayer.massrezTargets = null
    eventPlayer.startGrantingAssistFor(rezEventTarget, AssistReeval.NONE)
    rezEventTarget.rezAssist = [getLastAssistID(), getTotalTimeElapsed()]
    playEffect(getPlayers(eventPlayer.getTeam()), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.getPosition() + vect(eventPlayer.getFacingDirection().x * 0.25, 1.5, eventPlayer.getFacingDirection().z * 0.25), 1)
    playEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.getPosition() + vect(eventPlayer.getFacingDirection().x * 0.25, 1.5, eventPlayer.getFacingDirection().z * 0.25), 1)
    createUltVoicelineDummy()
    wait()
    rezEventTarget.setHealth(1)
    heal(rezEventTarget, eventPlayer, 9999)
    rezEventTarget.setHealth(rezEventTarget.getMaxHealth() - 1)
    heal(rezEventTarget, eventPlayer, 9999)
    eventPlayer.cancelPrimaryAction()
    wait(0.184, Wait.RESTART_WHEN_TRUE)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    if len(rezEventTarget) == 1:
        smallMessage(eventPlayer, "   {0}  SAVED {1} ({2})".format(iconString(Icon.HEART), rezEventTarget[0], rezEventTarget[0].getCurrentHero()))
    else:
        smallMessage(eventPlayer, "   {0}  SAVED {1} PLAYERS".format(iconString(Icon.HEART), len(rezEventTarget)))
    wait(0.55, Wait.RESTART_WHEN_TRUE)
    playEffect(getAllPlayers().exclude(eventPlayer), DynamicEffect.GOOD_EXPLOSION, Color.YELLOW, eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * vect(1.5, 2, 1.5)), 2)
    rezEventCaster = null
    rezEventTarget = null
    rezEventAbilityName = null
    rezEventAbilityIcon = null
    wait(0.75, Wait.RESTART_WHEN_TRUE)
    destroyUltVoicelineDummy()


rule "getting rez'd":
    @Event eachPlayer
    @Condition eventPlayer.isBeingResurrected == true
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.resurrect()
    bigMessage(eventPlayer, "REVIVING")
    eventPlayer.rezCameraOffset = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + normalize(eventPlayer.getFacingDirection()) * -3, null, null, false).getHitPosition() - eventPlayer.getEyePosition()
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
    playEffect(getPlayers(eventPlayer.getTeam()), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.getPosition(), 1)
    playEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.getPosition(), 1)
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


rule "getting immobility":
    @Event eachPlayer
    @Condition eventPlayer.isImmobile == true
    @Condition eventPlayer.isDummy() == false

    eventPlayer.setStatusEffect(null, Status.ROOTED, 1.5)
    playEffect(getPlayers(eventPlayer.getTeam()), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.getPosition(), 1.25)
    playEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.getPosition(), 1.25)
    playEffect(getAllPlayers(), DynamicEffect.ANA_BIOTIC_GRENADE_INCREASED_HEALING_SOUND, Color.WHITE, eventPlayer.getPosition(), 100)
    wait(1.5, Wait.RESTART_WHEN_TRUE)
    eventPlayer.isImmobile = false


rule "getting invulnerability":
    @Event eachPlayer
    @Condition eventPlayer.isInvulnerable == true
    @Condition eventPlayer.isDummy() == false

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2.25)
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_IMPACT, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, eventPlayer.teamColor, eventPlayer.getPosition() + vect(0, 1.25, 0), 1)
    playEffect(getPlayers(eventPlayer.getTeam()), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer.getPosition(), 1.25)
    playEffect(getPlayers(getOppositeTeam(eventPlayer.getTeam())), DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, eventPlayer.getPosition(), 1.25)
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

    hudHeader(getAllPlayers(), "{0} {1} > {2}".format("{0} {1}".format(rezEventCaster, heroIcon(rezEventCaster.getCurrentHero())), rezEventAbilityIcon, "{0} {1}".format(heroIcon(rezEventTarget[rezEventTarget.index(eventPlayer)].getCurrentHero()), rezEventTarget[rezEventTarget.index(eventPlayer)])), HudPosition.LEFT, rezEventOrder, eventPlayer.teamColor, HudReeval.NONE, SpecVisibility.DEFAULT)
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

    progressBarHud(mercyPlayersCanSetup, localPlayer.mercySetupCurProgress, "HOLD [{0}] TO {1} MERCY SETUP".format(buttonString(Button.INTERACT), "CLOSE" if localPlayer in mercyPlayersInSetup else "OPEN"), HudPosition.TOP, 100, rgb(193, 112, 10), Color.WHITE, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.DEFAULT)
    createEffect(mercyPlayersInSetup, Effect.ORB, Color.BLACK, updateEveryTick(localPlayer.getEyePosition() + (localPlayer.getFacingDirection() * 0.8)), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    hudText(mercyPlayersInSetup, "{0} {1}".format(heroIcon(Hero.MERCY), localPlayer.mercyPresetVersion), "[{0}] PRESET".format(buttonString(Button.CROUCH)), mercySetupPresetName[localPlayer.mercyPresetVersion], HudPosition.TOP, 101, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, mercySetupPresetDesc[localPlayer.mercyPresetVersion], HudPosition.TOP, 102, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, " ", HudPosition.TOP, 103, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInSetup, "{0} {1}".format(iconString(Icon.PLUS), localPlayer.mercyPassiveVersion), "[{0}] PASSIVE".format(buttonString(Button.RELOAD)), mercySetupPassiveName[localPlayer.mercyPassiveVersion - 1], HudPosition.TOP, 104, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, mercySetupPassiveDesc[localPlayer.mercyPassiveVersion - 1], HudPosition.TOP, 105, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, " ", HudPosition.TOP, 106, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInSetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.PRIMARY_FIRE), localPlayer.mercyWeaponVersion), "[{0}] WEAPON".format(buttonString(Button.PRIMARY_FIRE)), mercySetupWeaponName[localPlayer.mercyWeaponVersion - 1], HudPosition.TOP, 107, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, mercySetupWeaponDesc[localPlayer.mercyWeaponVersion - 1], HudPosition.TOP, 108, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, " ", HudPosition.TOP, 109, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInSetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.ABILITY_1), localPlayer.mercyAbility1Version), "[{0}] ABILITY 1".format(buttonString(Button.ABILITY_1)), mercySetupAbility1Name[localPlayer.mercyAbility1Version - 1], HudPosition.TOP, 110, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, mercySetupAbility1Desc[localPlayer.mercyAbility1Version - 1], HudPosition.TOP, 111, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, " ", HudPosition.TOP, 112, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInSetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.ABILITY_2), localPlayer.mercyAbility2Version), "[{0}] ABILITY 2".format(buttonString(Button.ABILITY_2)), mercySetupAbility2Name[localPlayer.mercyAbility2Version - 1], HudPosition.TOP, 113, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, mercySetupAbility2Desc[localPlayer.mercyAbility2Version - 1], HudPosition.TOP, 114, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, " ", HudPosition.TOP, 115, Color.WHITE, HudReeval.VISIBILITY)
    hudText(mercyPlayersInSetup, "{0} {1}".format(abilityIconString(Hero.MERCY, Button.ULTIMATE), localPlayer.mercyUltimateVersion), "[{0}] ULTIMATE".format(buttonString(Button.ULTIMATE)), mercySetupUltimateName[localPlayer.mercyUltimateVersion - 1], HudPosition.TOP, 116, rgb(236, 233, 189), rgb(236, 233, 189), rgb(28, 239, 239), HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(mercyPlayersInSetup, mercySetupUltimateDesc[localPlayer.mercyUltimateVersion - 1], HudPosition.TOP, 117, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)


rule "mercy player is in spawn":
    @Event eachPlayer
    @Hero mercy
    @Condition isWaitingForPlayers() == true or isInSetup() == true or (not isInSetup() and eventPlayer.isInSpawnRoom()) == true

    mercyPlayersCanSetup.append(eventPlayer)


rule "mercy player is no longer in spawn or no longer mercy":
    @Event eachPlayer
    @Condition eventPlayer.currentHero != eventPlayer.getCurrentHero() or (isWaitingForPlayers() or isInSetup() or (not isInSetup() and eventPlayer.isInSpawnRoom())) == false

    mercyPlayersCanSetup = mercyPlayersCanSetup.exclude(eventPlayer)
    mercyPlayersInSetup = mercyPlayersInSetup.exclude(eventPlayer)


rule "mercy player is switching setup mode":
    @Event eachPlayer
    @Hero mercy
    @Condition isWaitingForPlayers() == true or isInSetup() == true or (not isInSetup() and eventPlayer.isInSpawnRoom()) == true
    @Condition eventPlayer.mercySetupCurProgress < 100
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true

    do:
        if eventPlayer not in mercyPlayersInSetup:
            eventPlayer.mercySetupCurProgress += 2.5
        else:
            eventPlayer.mercySetupCurProgress += 5
        wait()
    while RULE_CONDITION
    if eventPlayer.mercySetupCurProgress == 100:
        if eventPlayer not in mercyPlayersInSetup:
            mercyPlayersInSetup.append(eventPlayer)
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
            mercyPlayersInSetup = mercyPlayersInSetup.exclude(eventPlayer)
    eventPlayer.mercySetupCurProgress = 0
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 99999)


rule "mercy player is changing preset":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInSetup
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    eventPlayer.mercyPresetVersion += 1
    if eventPlayer.mercyPresetVersion >= len(mercySetupPresetName):
        eventPlayer.mercyPresetVersion = 1
    eventPlayer.mercyPassiveVersion = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 10000)
    eventPlayer.mercyWeaponVersion = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 1000 % 10)
    eventPlayer.mercyAbility1Version = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 100 % 100 % 10)
    eventPlayer.mercyAbility2Version = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 10 % 1000 % 100 % 10)
    eventPlayer.mercyUltimateVersion = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] % 10000 % 1000 % 100 % 10)


rule "mercy player is changing passive":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInSetup
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    eventPlayer.mercyPassiveVersion += 1
    if eventPlayer.mercyPassiveVersion > len(mercySetupPassiveName):
        eventPlayer.mercyPassiveVersion = 1
    updateMercyPresetVersion()


rule "mercy player is changing weapon":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInSetup
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false

    eventPlayer.mercyWeaponVersion += 1
    if eventPlayer.mercyWeaponVersion > len(mercySetupWeaponName):
        eventPlayer.mercyWeaponVersion = 1
    updateMercyPresetVersion()


rule "mercy player is changing ability 1":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInSetup
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true

    eventPlayer.mercyAbility1Version += 1
    if eventPlayer.mercyAbility1Version > len(mercySetupAbility1Name):
        eventPlayer.mercyAbility1Version = 1
    updateMercyPresetVersion()


rule "mercy player is changing ability 2":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInSetup
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true

    eventPlayer.mercyAbility2Version += 1
    if eventPlayer.mercyAbility2Version > len(mercySetupAbility2Name):
        eventPlayer.mercyAbility2Version = 1
    updateMercyPresetVersion()


rule "mercy player is changing ultimate":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer in mercyPlayersInSetup
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true

    eventPlayer.mercyUltimateVersion += 1
    if eventPlayer.mercyUltimateVersion > len(mercySetupUltimateName):
        eventPlayer.mercyUltimateVersion = 1
    updateMercyPresetVersion()


rule "setup mercy character":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer not in mercyPlayersInSetup
    
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.INTERACT)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
    stopHealingModification(eventPlayer.passiveHealMod)
    stopHoT(eventPlayer.passiveEffect)
    if eventPlayer.mercyWeaponVersion in [4, 5]:
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    else:
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
    if eventPlayer.mercyPresetVersion != 0:
        eventPlayer.mercyPassiveVersion = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 10000)
        eventPlayer.mercyWeaponVersion = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 1000 % 10)
        eventPlayer.mercyAbility1Version = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 100 % 100 % 10)
        eventPlayer.mercyAbility2Version = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] / 10 % 1000 % 100 % 10)
        eventPlayer.mercyUltimateVersion = floor(mercySetupPresetList[eventPlayer.mercyPresetVersion] % 10000 % 1000 % 100 % 10)
    if eventPlayer.mercyPassiveVersion == 1 or eventPlayer.mercyPassiveVersion == 2:
        startHealingModification(eventPlayer, eventPlayer, 0, HealingReeval.NONE)
        eventPlayer.passiveHealMod = getLastHealingModification()
    destroyDummy(eventPlayer.baDummy.getTeam(), eventPlayer.baDummy.getSlot())

    destroyDummy(eventPlayer.gaCanonDummy.getTeam(), eventPlayer.gaCanonDummy.getSlot())
    destroyDummy(eventPlayer.baDummy.getTeam(), eventPlayer.baDummy.getSlot())
    eventPlayer.setAbility1Enabled(true)
    eventPlayer.setMoveSpeed(100)
    if eventPlayer.mercyAbility1Version == 5:
        createDummy(hostPlayer.getCurrentHero(), hostPlayer.getTeam(), -1, vect(0, 0, 0), vect(0, 0, 0))
        eventPlayer.gaCanonDummy = getLastCreatedEntity()
        wait()
        eventPlayer.gaCanonDummy.setRespawnTime(9999)
        wait()
        kill(eventPlayer.gaCanonDummy, null)
        eventPlayer.gaCanonDummy.startForcingName(eventPlayer)
        eventPlayer.gaCanonDummy.setInvisibility(Invis.ALL)
        eventPlayer.gaCanonDummy.setGravity(0)
        eventPlayer.gaCanonDummy.startForcingPosition(updateEveryTick(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * eventPlayer.gaRange, null, eventPlayer, false).getHitPosition() - eventPlayer.getFacingDirection() - vect(0, 1.1, 0)) if updateEveryTick(distance(eventPlayer, raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * eventPlayer.gaRange, null, eventPlayer, false).getHitPosition() - eventPlayer.getFacingDirection() - vect(0, 1.1, 0))) > 6 else vect(0, 0, 0), true)
    elif eventPlayer.mercyAbility1Version == 6:
        eventPlayer.baTarget = eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))
        createDummy(Hero.MERCY, eventPlayer.getTeam(), -1, eventPlayer.getPosition(), vect(0, 0, 0))
        eventPlayer.baDummy = getLastCreatedEntity()
        wait()
        eventPlayer.baDummy.setRespawnTime(9999)
        wait()
        kill(eventPlayer.baDummy, null)
        eventPlayer.baDummy.startForcingName(eventPlayer)
        eventPlayer.baDummy.setInvisibility(Invis.ALL)
        eventPlayer.baDummy.setGravity(0)
        eventPlayer.baDummy.startForcingPosition(updateEveryTick(eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).getPosition()) if updateEveryTick(eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam())).isAlive() and distance(eventPlayer, eventPlayer.getPlayerClosestToReticle(getOppositeTeam(eventPlayer.getTeam()))) > 6) else vect(0, 0, 0), true)
    elif eventPlayer.mercyAbility1Version == 7:
        eventPlayer.setAbility1Enabled(false)
        eventPlayer.setMoveSpeed(140)

    eventPlayer.setAbility2Enabled(true)
    eventPlayer.allowButton(Button.ABILITY_2)
    if eventPlayer.mercyAbility2Version == 1:
        eventPlayer.setAbility2Enabled(false)
    elif eventPlayer.mercyAbility2Version == 7:
        eventPlayer.disallowButton(Button.ABILITY_2)
    
    eventPlayer.allowButton(Button.ULTIMATE)
    if eventPlayer.mercyUltimateVersion in [1, 2, 6, 7, 8]:
        eventPlayer.disallowButton(Button.ULTIMATE)


rule "regen normal":
    @Event playerTookDamage
    @Hero mercy
    @Condition eventPlayer.mercyPassiveVersion in [1, 2]
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


rule "yellow beam alpha normal":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 1
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (50 / 45) * 100


rule "yellow beam alpha valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 1
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false

    eventPlayer.yellowbeamFactor = (50 / 60) * 100


rule "yellow beam 1.0/canon normal":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == [2, 5]
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (60 / 45) * 100


rule "yellow beam 1.0/canon valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == [2, 5]
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false

    eventPlayer.yellowbeamFactor = (60 / 60) * 100


rule "yellow beam 2.0 normal":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 3
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (55 / 45) * 100


rule "yellow beam 2.0 valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 3
    @Condition eventPlayer.mercyUltimateVersion == 2
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false

    eventPlayer.yellowbeamFactor = (60 / 60) * 100


rule "yellow beam 3.0":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 4
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (45 / 45) * 100


rule "yellow beam healing modifiers":
    @Event global

    startHealingModification(criticalHealthPlayers, [player for player in getPlayersOnHero(Hero.MERCY, Team.ALL) if player.mercyWeaponVersion != 4], 2 / 3 * 100, HealingReeval.RECEIVERS_AND_HEALERS)
    startHealingModification(fullNonShieldHealthPlayers, [player for player in getPlayersOnHero(Hero.MERCY, Team.ALL) if player.mercyWeaponVersion == 1], 0, HealingReeval.RECEIVERS_AND_HEALERS)


rule "gun weapon draw":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getCurrentWeapon() == 2
    @Condition eventPlayer.isDummy() == false

    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    waitUntil(eventPlayer.getCurrentWeapon() == 1, 0.5)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)


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
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE):
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
        waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) or eventPlayer.getAmmo(0) <= eventPlayer.getMaxAmmo(0) * 0.2 or eventPlayer.getCurrentWeapon() == 1, 99999)
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "GA 1.0/canon":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility1Version in [1, 5]
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isDummy() == false or eventPlayer.isValkDummy == true

    waitUntil(eventPlayer.isInAir() or not eventPlayer.isUsingAbility1(), 99999)
    while eventPlayer.isUsingAbility1():
        waitUntil(eventPlayer.isInAir() or not eventPlayer.isUsingAbility1(), 99999)
        eventPlayer.disallowButton(Button.JUMP)
        eventPlayer.disallowButton(Button.CROUCH)
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 99999)
        wait(0.325)
        eventPlayer.allowButton(Button.JUMP)
        eventPlayer.allowButton(Button.CROUCH)
        if eventPlayer.isHoldingButton(Button.JUMP):
            eventPlayer.startForcingButton(Button.JUMP)
            waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isUsingAbility1(), 99999)
            eventPlayer.stopForcingButton(Button.JUMP)
        elif eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.startForcingButton(Button.CROUCH)
            waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isUsingAbility1(), 99999)
            eventPlayer.stopForcingButton(Button.CROUCH)


rule "GA 2.0":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility1Version == 2
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isDummy() == false

    waitUntil(eventPlayer.isInAir() or not eventPlayer.isUsingAbility1(), 99999)
    while eventPlayer.isUsingAbility1():
        waitUntil(eventPlayer.isInAir() or not eventPlayer.isUsingAbility1(), 99999)
        eventPlayer.disallowButton(Button.JUMP)
        eventPlayer.disallowButton(Button.CROUCH)
        wait(0.1)
        waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isHoldingButton(Button.JUMP), 99999)
        if eventPlayer.isHoldingButton(Button.JUMP) and not eventPlayer.hasSuperjumped:
            eventPlayer.hasSuperjumped = true
            eventPlayer.gaLastKnownDirection = eventPlayer.getFacingDirection()
            eventPlayer.gaVelocity = normalize(eventPlayer.getVelocity())
            eventPlayer.setFacing(eventPlayer.gaVelocity, Relativity.TO_WORLD)
            wait(0.085)
            eventPlayer.allowButton(Button.JUMP)
            eventPlayer.forceButtonPress(Button.JUMP)
            eventPlayer.setFacing(eventPlayer.gaLastKnownDirection, Relativity.TO_WORLD)
            if eventPlayer.getThrottle() == Vector.BACKWARD:
                wait()
                eventPlayer.applyImpulse(eventPlayer.gaVelocity, eventPlayer.getSpeed() * 0.25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
        eventPlayer.allowButton(Button.JUMP)
        eventPlayer.allowButton(Button.CROUCH)
        if eventPlayer.isHoldingButton(Button.JUMP):
            eventPlayer.startForcingButton(Button.JUMP)
            waitUntil(not eventPlayer.isHoldingButton(Button.JUMP) or eventPlayer.isUsingAbility1(), 99999)
            eventPlayer.stopForcingButton(Button.JUMP)
        elif eventPlayer.isHoldingButton(Button.CROUCH):
            eventPlayer.startForcingButton(Button.CROUCH)
            waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH) or eventPlayer.isUsingAbility1(), 99999)
            eventPlayer.stopForcingButton(Button.CROUCH)
        waitUntil(eventPlayer.isOnGround() or not eventPlayer.isUsingAbility1(), 99999)
        eventPlayer.hasSuperjumped = false


rule "GA 3.0 backwards slingshot speed":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility1Version == 3
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getThrottle() == Vector.BACKWARD
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    waitUntil(eventPlayer.getSpeedInDirection(eventPlayer.getFacingDirection()) < 0, 1)
    if eventPlayer.getSpeedInDirection(eventPlayer.getFacingDirection()) < 0:
        eventPlayer.applyImpulse(normalize(eventPlayer.getVelocity()), eventPlayer.getSpeed() * 0.225, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        waitUntil(not eventPlayer.isUsingAbility1(), 99999)


rule "GA CD":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

    if eventPlayer.mercyAbility1Version not in [4, 6]:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, max(1.5 * (mercyGACooldownPercent / 100), 0.25))
    else:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, max(2.5 * (mercyGACooldownPercent / 100), 0.25))


rule "GA range valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion in [3, 4, 5]
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isDummy() == false

    eventPlayer.gaRange *= 2
    waitUntil(not eventPlayer.isUsingUltimate(), 15)
    eventPlayer.gaRange /= 2


rule "GA speed valk":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion in [2, 3]
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getSpeed() >= 9.25
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.setMoveSpeed(33 / 25 * 100)
    waitUntil(not eventPlayer.isUsingAbility1() or not eventPlayer.isUsingUltimate(), 99999)
    eventPlayer.setMoveSpeed(100)


rule "no rez reduce ult cost":
    @Event eachPlayer
    @Condition eventPlayer.mercyAbility2Version == 1
    @Condition eventPlayer.getUltCharge() >= 90

    eventPlayer.setUltCharge(100)


rule "mass rez targeting":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion in [1, 2, 7]
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
    @Condition eventPlayer.mercyUltimateVersion in [1, 2, 7]
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


rule "valk 1.0 rez reset":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 3
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.isCastingExtendedUltimate == false
    @Condition eventPlayer.isDummy() == false

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)


rule "valk 2.0 bonus rez charge":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 4
    @Condition eventPlayer.isUsingUltimate()
    @Condition eventPlayer.isCastingExtendedUltimate == false
    @Condition eventPlayer.isDummy() == false

    eventPlayer.rezLastCooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
    eventPlayer.rezLastTimeElapsed = getTotalTimeElapsed()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    hudHeader(eventPlayer, "{0} BONUS RESURRECT CHARGE AVAILABLE".format(abilityIconString(Hero.MERCY, Button.ABILITY_2)), HudPosition.TOP, 1001, rgb(247, 152, 20), HudReeval.STRING)
    eventPlayer.rezBonusChargeHUD = getLastCreatedText()


rule "valk 2.0 bonus rez charge expired":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 4
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer.rezLastCooldown != -1
    @Condition eventPlayer.rezLastTimeElapsed != -1
    @Condition eventPlayer.isDummy() == false

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.rezLastCooldown - (getTotalTimeElapsed() - eventPlayer.rezLastTimeElapsed))
    eventPlayer.rezLastCooldown = -1
    eventPlayer.rezLastTimeElapsed = -1
    destroyHudText(eventPlayer.rezBonusChargeHUD)


rule "valk 1.0/2.0 duration":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.MERCY
    @Condition eventPlayer.mercyUltimateVersion in [3, 4]
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.preloadHero(Hero.MERCY)
    eventPlayer.isCastingExtendedUltimate = true
    waitUntil(eventPlayer.isDead(), 15)
    if eventPlayer.isAlive():
        eventPlayer.setUltCharge(100)
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        waitUntil(eventPlayer.isDead(), 5.5)
        if eventPlayer.isAlive():
            eventPlayer.rezLastCooldown = eventPlayer.getAbilityCooldown(Button.ABILITY_2)
            eventPlayer.startForcingHero(Hero.ANA)
            eventPlayer.startForcingHero(Hero.MERCY)
            eventPlayer.stopForcingCurrentHero()
            eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.rezLastCooldown)
            eventPlayer.rezLastCooldown = -1
    eventPlayer.isCastingExtendedUltimate = false


rule "valk canon":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 5
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatusEffect(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatusEffect(Status.FROZEN) == false
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) == false
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false
    @Condition eventPlayer.hasStatusEffect(Status.STUNNED) == false
    @Condition eventPlayer not in mercyPlayersInSetup

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setUltCharge(0)
    eventPlayer.setUltEnabled(false)
    createDummy(eventPlayer.getCurrentHero(), eventPlayer.getTeam(), -1, eventPlayer.getPosition(), eventPlayer.getFacingDirection())
    eventPlayer.valkCanonDummy = getLastCreatedEntity()
    wait()
    eventPlayer.valkCanonDummy.setUltCharge(100)
    wait()
    eventPlayer.valkCanonDummy.forceButtonPress(Button.ULTIMATE)
    eventPlayer.valkCanonDummy.setInvisibility(Invis.ALL)
    eventPlayer.valkCanonDummy.startThrottleInDirection(updateEveryTick(eventPlayer.getThrottle()), 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
    eventPlayer.valkCanonDummy.startFacing(updateEveryTick(eventPlayer.getFacingDirection()), 9999, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.valkCanonDummy.isValkDummy = true
    eventPlayer.attachTo(eventPlayer.valkCanonDummy, vect(0, 0, 0))
    eventPlayer.valkCanonCurProgress = 100
    progressBarHud(eventPlayer, eventPlayer.valkCanonCurProgress, "VALKYRIE", HudPosition.TOP, 10001, Color.WHITE, Color.WHITE, ProgressHudReeval.VALUES, SpecVisibility.DEFAULT)
    eventPlayer.valkCanonBar = getLastCreatedText()
    waitUntil(eventPlayer.isDead() or not eventPlayer.valkCanonDummy.isUsingUltimate(), 99999)
    destroyDummy(eventPlayer.valkCanonDummy.getTeam(), eventPlayer.valkCanonDummy.getSlot())
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setUltEnabled(true)


rule "valk canon update bar progress":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.valkCanonCurProgress == 100
    
    while eventPlayer.valkCanonCurProgress > 0 and eventPlayer.isAlive():
        eventPlayer.valkCanonCurProgress -= 2
        wait(2 / (100 / 15))
    eventPlayer.valkCanonCurProgress = 0
    destroyProgressBarHud(eventPlayer.valkCanonBar)


rule "valk canon jump":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 5
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.valkCanonDummy.startForcingButton(Button.JUMP)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 99999)
    eventPlayer.valkCanonDummy.stopForcingButton(Button.JUMP)


rule "valk canon crouch":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 5
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.valkCanonDummy.startForcingButton(Button.CROUCH)
    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), 99999)
    eventPlayer.valkCanonDummy.stopForcingButton(Button.CROUCH)


rule "valk canon GA":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 5
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    eventPlayer.valkCanonDummy.startForcingButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isHoldingButton(Button.ABILITY_1), 99999)
    eventPlayer.valkCanonDummy.stopForcingButton(Button.ABILITY_1)


rule "medigun targeting":
    @Event playerDealtHealing
    @Hero mercy
    @Condition eventPlayer.mercyWeaponVersion == 6

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
    @Condition eventPlayer.mercyWeaponVersion == 6
    @Condition eventPlayer.isUsingUltimate() == false
    @Condition eventPlayer not in mercyPlayersInSetup
    @Condition eventPlayer.isDummy() == false
    
    eventPlayer.yellowbeamFactor = (30 / 45) * 100


rule "medigun healing factor":
    @Event playerTookDamage
    @Condition getPlayersOnHero(Hero.MERCY, eventPlayer.getTeam()).mercyWeaponVersion == 6

    eventPlayer.medigunHealingFactor = max(eventPlayer.medigunHealingFactor - (eventDamage / 300), 1)
    while eventPlayer.medigunHealingFactor < 3:
        eventPlayer.medigunHealingFactor += 0.01
        wait(4 / 100, Wait.RESTART_WHEN_TRUE)
    eventPlayer.medigunHealingFactor = 3


rule "medigun healing mod":
    @Event eachPlayer

    startHealingModification(eventPlayer, [player for player in getPlayersOnHero(Hero.MERCY, eventPlayer.getTeam()) if player.mercyWeaponVersion == 6], eventPlayer.medigunHealingFactor * 100, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)


rule "medigun overheal":
    @Event playerReceivedHealing
    @Condition healer != healee
    @Condition healer.mercyWeaponVersion == 6
    @Condition healer.getCurrentHero() == Hero.MERCY
    @Condition eventPlayer.getHealth() >= eventPlayer.getMaxHealth()
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL) < ((eventPlayer.getMaxHealth() / 2) - (eventPlayer.getMaxHealth() / 2 % 25))

    eventPlayer.currentOverhealth = eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL)
    if eventPlayer.currentOverhealth < ((eventPlayer.maxHealth / 2) - (eventPlayer.maxHealth / 2 % 25)):
        removeHealthPool(eventPlayer.overhealthPool)
        eventPlayer.addHealthPool(Health.NORMAL, min((eventPlayer.getMaxHealth() / 2) - (eventPlayer.getMaxHealth() / 2 % 25), eventPlayer.currentOverhealth + (30 * eventPlayer.medigunHealingFactor) / 32), false, false)
        eventPlayer.overhealthPool = getLastCreatedHealthPool()
    wait(0.5, Wait.RESTART_WHEN_TRUE)
    while eventPlayer.getHealthOfType(Health.NORMAL) > eventPlayer.getMaxHealthOfType(Health.NORMAL):
        eventPlayer.currentOverhealth = eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL)
        removeHealthPool(eventPlayer.overhealthPool)
        if eventPlayer.currentOverhealth <= 50 * 0.025:
            return
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.currentOverhealth - ((eventPlayer.getMaxHealth() / 2) - (eventPlayer.getMaxHealth() / 2 % 25)) / 10 * 0.025, false, false)
        eventPlayer.overhealthPool = getLastCreatedHealthPool()
        wait(0.025, Wait.RESTART_WHEN_TRUE)
    eventPlayer.currentOverhealth = 0


rule "medigun unlimited overheal bug fix":
    @Event eachPlayer
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) - eventPlayer.getMaxHealthOfType(Health.NORMAL) > eventPlayer.getMaxHealthOfType(Health.NORMAL) * 3

    eventPlayer.currentOverhealth = 0
    removeHealthPool(eventPlayer.overhealthPool)
    # eventPlayer.setHealth(eventPlayer.getMaxHealth())


rule "":
    @Condition hostPlayer.hasSpawned()

    # hudHeader(hostPlayer, hostPlayer.getMaxHealth(), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    # hudHeader(hostPlayer, hostPlayer.medigunTarget.getMaxHealth(), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    # hudHeader(hostPlayer, hostPlayer.medigunTarget.getHealthOfType(Health.NORMAL) - hostPlayer.medigunTarget.getMaxHealthOfType(Health.NORMAL), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    # hudHeader(hostPlayer, (hostPlayer.medigunTarget.getMaxHealth() / 2) - (hostPlayer.medigunTarget.getMaxHealth() / 2 % 25), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    hudHeader(hostPlayer, hostPlayer.medigunTarget.getHealthOfType(Health.NORMAL), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    hudHeader(hostPlayer, hostPlayer.medigunTarget.getMaxHealthOfType(Health.NORMAL), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    hudHeader(hostPlayer, hostPlayer.medigunTarget.getHealth(), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    hudHeader(hostPlayer, hostPlayer.medigunTarget.getMaxHealth(), HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)
    hudHeader(hostPlayer, hostPlayer.medigunTarget.currentOverhealth, HudPosition.LEFT, 999999, Color.WHITE, HudReeval.STRING)


rule "vaccinator":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyAbility2Version == 7
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatusEffect(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatusEffect(Status.FROZEN) == false
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) == false
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false
    @Condition eventPlayer.hasStatusEffect(Status.STUNNED) == false
    @Condition eventPlayer not in mercyPlayersInSetup

    eventPlayer.isVaccinated = true
    eventPlayer.medigunTarget.isVaccinated = true
    wait(2.5)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)


rule "getting vaccinated":
    @Event eachPlayer
    @Condition eventPlayer.isVaccinated == true

    eventPlayer.setDamageReceived(50)
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
    @Condition eventPlayer.mercyWeaponVersion == 6
    @Condition eventAbility == Button.MELEE

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 15)


rule "ubercharge":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.mercyUltimateVersion == 8
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatusEffect(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatusEffect(Status.FROZEN) == false
    @Condition eventPlayer.hasStatusEffect(Status.HACKED) == false
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false
    @Condition eventPlayer.hasStatusEffect(Status.STUNNED) == false
    @Condition eventPlayer not in mercyPlayersInSetup

    eventPlayer.isCastingUbercharge = true
    eventPlayer.isUbercharged = true
    eventPlayer.medigunTarget.isUbercharged = true
    createUltVoicelineDummy()
    wait(1.5, Wait.RESTART_WHEN_TRUE)
    destroyUltVoicelineDummy()


rule "ubercharge drain rate":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isCastingUbercharge == true
    @Condition eventPlayer.getUltCharge() > 0

    do:
        eventPlayer.setUltCharge(eventPlayer.getUltCharge() - 1)
        wait(1 / 10 / max(len([player for player in getPlayers(eventPlayer.getTeam()) if player.hasStatusEffect(Status.INVINCIBLE)]) - 1, 1))
    while RULE_CONDITION
    eventPlayer.isUbercharged = false
    eventPlayer.isCastingUbercharge = false


rule "getting ubercharged":
    @Event eachPlayer
    @Condition eventPlayer.isUbercharged == true

    if not eventPlayer.hasStatusEffect(Status.INVINCIBLE):
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
    hostPlayer.stopForcingCurrentHero()


rule "host give ult when spawn":
    @Event global
    @Condition debugToggle == true
    @Condition debugHostPermaUlt == true
    @Condition hostPlayer.hasSpawned() == true
    
    wait()
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
    @Condition hostPlayer.getUltCharge() != 100
    @Condition hostPlayer.isCastingUbercharge == false
    @Condition hostPlayer.hasStatusEffect(Status.INVINCIBLE) == false
    
    wait()
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

