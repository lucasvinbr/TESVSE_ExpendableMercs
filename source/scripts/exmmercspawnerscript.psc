Scriptname EXMMercSpawnerScript extends Quest  

FormList Property AllowedRaceGenderPairs  Auto 

FormList property doorList auto 

FormList property itemsHeldByEmissi auto

Formlist Property EXMheldLightCuirasses auto
Formlist Property EXMheldLightBoots auto
Formlist Property EXMheldLightGloves auto
Formlist Property EXMheldLightHelmets auto

Formlist Property EXMheldHvyCuirasses auto
Formlist Property EXMheldHvyBoots auto
Formlist Property EXMheldHvyGloves auto
Formlist Property EXMheldHvyHelmets auto

Formlist Property EXMheldBows auto
Formlist Property EXMheldMelee auto

Message Property HowManyMercsMsg  Auto  

LeveledItem Property defaulMerctMeleeWeapon  Auto  
{the weapon melee mercs spawn with}

LeveledItem Property defaultMercRangedWeapon  Auto  
{The weapon archer mercs spawn with}

LeveledItem Property defaultMercPossibleArrows  Auto  
{The arrows archer mercs spawn with}

LeveledItem Property defaultMercPossibleCuirasses  Auto  
{The cuirasses mercs spawn with}

LeveledItem Property defaultMercPossibleBoots  Auto  
{The boots mercs spawn with}

Bool Property autoReHireMercs = False Auto  
{when a mercenary dies, should another one be hired automatically?}

Bool Property randomizeUnspecifiedItems = False Auto 
{should all items that aren't keyworded as armor be automatically given to hired mercs or should there be a chance for each item?}

Bool Property mercsRegenHealth = true Auto  
{do mercs regenerate health with time, like the player?}

Perk Property noTriggerTraps Auto

Actor Property theEmissi  Auto  

MiscObject Property Gold001  Auto  

GlobalVariable Property MercGoldCost Auto

ActorBase Property NordF Auto  
ActorBase Property NordM Auto 
ActorBase Property ArgoF Auto 
ActorBase Property ArgoM Auto 
ActorBase Property OrcF Auto 
ActorBase Property OrcM Auto 
ActorBase Property DarkF Auto 
ActorBase Property DarkM Auto 
ActorBase Property WoodF Auto 
ActorBase Property WoodM Auto 
ActorBase Property HighF Auto 
ActorBase Property HighM Auto 
ActorBase Property KhajF Auto 
ActorBase Property KhajM Auto 
ActorBase Property ImpF Auto 
ActorBase Property ImpM Auto 
ActorBase Property BretF Auto 
ActorBase Property BretM Auto 
ActorBase Property RedgF Auto 
ActorBase Property RedgM Auto 

Function TakeGoldFromPlayer(int amount)
	Game.GetPlayer().RemoveItem(Gold001, amount)
endFunction

Function RefreshMercGoldCost()
	UpdateCurrentInstanceGlobal(MercGoldCost)
endFunction

Function SpawnMerc(bool isArcher, bool usesSpecialAmmo = false, bool justOneMerc = false)
	;opens "how many mercs?" box, with options ranging from none to 5, depending on how much gold player has
	;the last option makes the menu open again, incrementing the desired number by 5 (5 plus the new choice)
	;this can be done indefinitely (5 plus 5 plus 5 plus 5 plus 4: you'll hire 24 mercs... or less, if your gold or the merc limit ends)
	int numberOfMercs = 0
	
	
	if !justOneMerc
		int chosenMsgBoxIndex = HowManyMercsMsg.show(numberOfMercs)
		while chosenMsgBoxIndex == 6
			numberOfMercs += 5
			chosenMsgBoxIndex = HowManyMercsMsg.show(numberOfMercs)
		endwhile
		
		numberOfMercs += chosenMsgBoxIndex
	else
		numberOfMercs = 1
	endif
	
	Actor playr = Game.GetPlayer()
	int playerLevel = playr.GetLevel()
	int mercCost = (MercGoldCost.GetValue() as int)
	EXMEmissiSpecialAmmoStorage emissiStorage = ((theEmissi as ObjectReference) as EXMEmissiSpecialAmmoStorage)
		
	While numberOfMercs > 0
		numberOfMercs -= 1
		
		if(playr.GetItemCount(Gold001) < mercCost)
			Debug.Notification("Insufficient gold; unable to hire another mercenary.")
			return
		endif
		
		;hire the merc!
		ReferenceAlias aliasForTheMerc = GetFreeAliasSlot()
		
	
		if(aliasForTheMerc == none)
			Debug.MessageBox("The limit of spawned mercenaries has been reached! Aborting the hiring procedure.")
			return
		endif

		ObjectReference placeLocation = GetASpawnPoint(theEmissi)

		ObjectReference newMerc = None
		if AllowedRaceGenderPairs.GetSize() == 0
			newMerc = placeLocation.PlaceActorAtMe(NordF)
		Else
			int raceIndex = Utility.RandomInt(0, AllowedRaceGenderPairs.GetSize() - 1)
			newMerc = placeLocation.PlaceActorAtMe(AllowedRaceGenderPairs.GetAt(raceIndex) as ActorBase)
		EndIf
			
		if(newMerc != None)
			Actor mercActor = newMerc as Actor
			
			mercActor.SetPlayerTeammate(true, true)
			
			int gearProvided = GetGearFromEmissi(mercActor, isArcher)
			;give weapon if player didn't provide
			if(gearProvided < 1)
				Form newWeapon = none
				;gear up
				if isArcher
					newWeapon = defaultMercRangedWeapon
				else
					if gearProvided == 0
						newWeapon = defaulMerctMeleeWeapon
					endif
				endif
				
				if newWeapon != none
					mercActor.AddItem(newWeapon)
					mercActor.EquipItem(newWeapon)
				endif
			endif
			
			;some default, low-rank clothes just in case the player didnt provide anything
			Form newCuirass = defaultMercPossibleCuirasses
			mercActor.AddItem(newCuirass)
			
			Form newBoots = defaultMercPossibleBoots
			mercActor.AddItem(newBoots)
			
			TakeGoldFromPlayer(MercGoldCost.GetValue() as int)
			
			
			Utility.Wait(0.2)
			
			aliasForTheMerc.ForceRefTo(mercActor)
			
			;arrows for all mercs, so that even melee fighters can use bows if really needed
			if(!usesSpecialAmmo)
					Form arrows = defaultMercPossibleArrows
					mercActor.AddItem(arrows, 999)
			else
				if(emissiStorage != None && emissiStorage.theAmmoTypePlayerGaveMe != None)
					mercActor.AddItem(emissiStorage.theAmmoTypePlayerGaveMe, 999)
				else
					Form arrows = defaultMercPossibleArrows
					mercActor.AddItem(arrows, 999)
				endif
			endif
			
			EXMClearRefOnDeath mercScript = (aliasForTheMerc as EXMClearRefOnDeath)
			;also set up skills for melee and archers (things seem to max out around level 40, so 2.5 per level seems good)
			;and set the type of merc in the merc script so that we can replace that merc in case of death
			if isArcher
				mercActor.SetAV("LightArmor", playerLevel * 2.1)
				mercActor.SetAV("HeavyArmor", playerLevel * 1.0)
				mercActor.SetAV("Block", playerLevel * 0.8)
				mercActor.SetAV("OneHanded", playerLevel * 1.2)
				mercActor.SetAV("TwoHanded", playerLevel * 1.0)
				mercActor.SetAV("Marksman", playerLevel * 2.5)
				mercActor.SetAV("Sneak", playerLevel * 2.5)
				if usesSpecialAmmo
					mercScript.mercType = "rangedCustom"
				else
					mercScript.mercType = "rangedArrows"
				endif
			else
				mercActor.SetAV("LightArmor", playerLevel * 1.0)
				mercActor.SetAV("HeavyArmor", playerLevel * 2.1)
				mercActor.SetAV("Block", playerLevel * 2.1)
				mercActor.SetAV("OneHanded", playerLevel * 2.1)
				mercActor.SetAV("TwoHanded", playerLevel * 2.1)
				mercActor.SetAV("Marksman", playerLevel * 1.0)
				mercScript.mercType = "melee"
			endif
			
			if mercsRegenHealth
				mercActor.SetAV("HealRate", 1.50)
			endif
			
			;and the no-trap-triggering perk
			mercActor.AddPerk(noTriggerTraps)
			
		EndIf
	EndWhile

	
endFunction

Function DismissMerc(Actor theMerc)
	(GetAliasSlotOfTargetMerc(theMerc) as EXMClearRefOnDeath).BeDismissed()
endFunction

Function DismissAllMercs()
	Int i = 72
	While i > 11
		i -= 1
		ReferenceAlias aMercAlias = GetAlias(i) as ReferenceAlias
		
		if(aMercAlias.GetReference() != none)
			(aMercAlias as EXMClearRefOnDeath).BeDismissed()
		endif
	EndWhile
endFunction

Function MakeMercGiveItemsToEmissi(Actor theMerc, bool onlyUnequippedItems = true, bool lockMercAfterGiving = false, bool clearMercAliasAfterGiving = false, bool deleteMercWhenAble = false)
	ReferenceAlias mercRefAlias = GetAliasSlotOfTargetMerc(theMerc)
	EXMClearRefOnDeath mercScript = (mercRefAlias as EXMClearRefOnDeath)
	
	if(lockMercAfterGiving)
		theMerc.BlockActivation(true)
	endif
	
	if(clearMercAliasAfterGiving)
		mercScript.Clear()
		
		theMerc.RemoveFromAllFactions()
		
	endif
	
	if(deleteMercWhenAble)
		theMerc.DeleteWhenAble()
	endif
	
endFunction

Function TryReHireIfActive(string deadMercType)
	if autoReHireMercs
		if(deadMercType == "rangedArrows")
			SpawnMerc(true, false, true)
		elseif(deadMercType == "melee")
			SpawnMerc(false, false, true)
		elseif(deadMercType == "rangedCustom")
			SpawnMerc(true, true, true)
		endif
	endif
endFunction

ReferenceAlias Function GetFreeAliasSlot()
	;the alias ids used by mercs range from 11 to 71
	Int i = 72
	While i > 11
		i -= 1
		ReferenceAlias aMercAlias = GetAlias(i) as ReferenceAlias
		
		if(aMercAlias.GetReference() == none)
			return aMercAlias
		endif
	EndWhile
	
	return none
endFunction

ReferenceAlias Function GetAliasSlotOfTargetMerc(ObjectReference mercRef)

	Int i = 72
	While i > 11
		i -= 1
		ReferenceAlias aMercAlias = GetAlias(i) as ReferenceAlias
		
		if(aMercAlias.GetReference() == mercRef)
			return aMercAlias
		endif
	EndWhile
	
	return none
endFunction

ObjectReference Function GetASpawnPoint(ObjectReference fallbackPoint)
	ObjectReference closestDoor  = Game.FindRandomReferenceOfAnyTypeInListFromRef(doorList, fallbackPoint, 3500)

	if ( closestDoor == None) 
		Debug.Notification("Merc will be spawned at Emissi's position")
	else
		return closestDoor
	endif

	return fallbackPoint
endFunction

Form Function GetRandomFormFromList(FormList theList)
	int listSize = theList.GetSize()
	if(listSize > 0)
		int randomIndex = Utility.RandomInt(0, theList.GetSize() - 1)
		return theList.GetAt(randomIndex)
	else
		return none
	endif
endFunction

Form Function AddRandomItemToActor(Actor theActor, FormList theItemList, FormList fallbackList)
	Form newItem = GetRandomFormFromList(theItemList)
	if(newItem != none)
		theActor.AddItem(newItem)
	elseif(fallbackList != none)
		newItem = GetRandomFormFromList(fallbackList)
		if(newItem != none)
			theActor.AddItem(newItem)
		endif
	endif
	
	return newItem;
endFunction

int Function GetGearFromEmissi(Actor theMerc, bool preferLightArmor = false)
	;adds unspecified items... (those can be armor too, and that could screw up variation, but...)
	Int iFormIndex = itemsHeldByEmissi.GetSize()
	int foundWeapType = 0
	While iFormIndex > 0
		iFormIndex -= 1
		;since we don't really know what those items are, we offer the player the chance to randomize those items being given or not
		if((randomizeUnspecifiedItems && Utility.RandomInt(0,3) < 2) || !randomizeUnspecifiedItems)
			Form kForm = itemsHeldByEmissi.GetAt(iFormIndex)
			theMerc.AddItem(kForm)
		endif
		
	EndWhile
	
	;all mercs should get both ranged and melee weaps if they are available
	if(AddRandomItemToActor(theMerc, EXMheldBows, none) != none) 
		foundWeapType += 1
	endif
	if(AddRandomItemToActor(theMerc, EXMheldMelee, none) != none) 
		foundWeapType += 1
		;if we got melee only, set foundWeapType to something less than 1, to differ from having only ranged
		if(foundWeapType == 1)
			foundWeapType = -1
		endif
	endif
	
	if(preferLightArmor)
		AddRandomItemToActor(theMerc, EXMheldLightBoots, EXMheldHvyBoots)
		AddRandomItemToActor(theMerc, EXMheldLightCuirasses, EXMheldHvyCuirasses)
		AddRandomItemToActor(theMerc, EXMheldLightGloves, EXMheldHvyGloves)
		AddRandomItemToActor(theMerc, EXMheldLightHelmets, EXMheldHvyHelmets)
	else
		AddRandomItemToActor(theMerc, EXMheldHvyBoots, EXMheldLightBoots)
		AddRandomItemToActor(theMerc, EXMheldHvyCuirasses, EXMheldLightCuirasses)
		AddRandomItemToActor(theMerc, EXMheldHvyGloves, EXMheldLightGloves)
		AddRandomItemToActor(theMerc, EXMheldHvyHelmets, EXMheldLightHelmets)
	endif
	
	return foundWeapType
endFunction
