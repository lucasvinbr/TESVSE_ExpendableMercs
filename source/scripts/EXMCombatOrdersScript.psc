Scriptname EXMCombatOrdersScript extends Quest  
{Script that handles most combat orders-related stuff}

ReferenceAlias Property ArcherMarker  Auto  
{"hold position" marker for archer mercs}

ReferenceAlias Property MeleeMarker  Auto  
{"hold position" marker for melee mercs}

ReferenceAlias Property RangerMarker  Auto  
{"hold position" marker for special ammo archer mercs}

Faction Property MercsRankedFaction  Auto  
{"the mercs' faction, which is divided by ranks that indicate their types and orders"}

Message Property SetOrdersTargetBox  Auto  
{"issue orders to which group? x, y, z or all of them?"}

Message Property SetDesiredOrderBox  Auto  
{"what do you want the selected group to do during combat?"}

GlobalVariable Property DefaultArcherOrder Auto
{"the last order type given to archers; it will also be given to newly recruited ones"}

GlobalVariable Property DefaultMeleeOrder Auto
{"the last order type given to melee fighters; it will also be given to newly recruited ones"}

GlobalVariable Property DefaultRangerOrder Auto
{"the last order type given to rangers; it will also be given to newly recruited ones"}


;Groups are usually the following:
; 0 = everyone
; 1 = archers
; 2 = melee
; 3 = special ammo archers, "rangers"
;
;Orders are the following:
; 0 = charge
; 1 = stay close to player
; 2 = hold target position
; 3 = stand ground

;so, in the merc faction, ranks 1 to 4 are archers, 5 to 8 are melee, 9 to 12 are rangers

Function StartOrderProcedure(ObjectReference hitSpot)
	int setOrderedGroupBoxChoice = -1
	int setDesiredOrderBoxChoice = -1
	
	while setOrderedGroupBoxChoice != 4
		;"who are we giving orders to?"
		setOrderedGroupBoxChoice = SetOrdersTargetBox.Show()
		if setOrderedGroupBoxChoice != 4
			setDesiredOrderBoxChoice = SetDesiredOrderBox.Show()
			if setDesiredOrderBoxChoice != 4
				;move markers if this is a "hold target pos" order
				if(setDesiredOrderBoxChoice == 2)
					MoveHoldPosMarker(setOrderedGroupBoxChoice, hitSpot)
				endif
				;order given, all windows should close now
				GiveOrderToGroup(setOrderedGroupBoxChoice, setDesiredOrderBoxChoice)
				setOrderedGroupBoxChoice = 4 
			endif
		endif
	endwhile
endfunction


Function GiveOrderToGroup(int targetGroup, int orderType)
	Int i = 72
	ReferenceAlias curMercAlias = none
	ObjectReference mercRef = none
	Actor mercActor = none
	int mercType = 0
	While(i > 11)
		i -= 1
		curMercAlias = GetAlias(i) as ReferenceAlias
		mercRef = curMercAlias.GetReference()
		
		if(mercRef != none)
			mercActor = mercRef as Actor
			;this crazy calc gets the merc type as 1,2 or 3 based on their current rank
			mercType = ((((mercActor.GetFactionRank(MercsRankedFaction) - 1) as float) / 4.0) as int) + 1
			if(mercType < 1)
				;if, for some reason, we're not of any type, we're considered archers
				mercType = 1
			endif
			
			if (targetGroup == 0 || targetGroup == mercType)
				mercActor.SetFactionRank(MercsRankedFaction, ((mercType - 1) * 4) + orderType + 1)
			endif
		endif
	EndWhile
endfunction


Function MoveHoldPosMarker(int targetGroup, ObjectReference newPos)
	if(newPos == none)
		Debug.Notification("merc orders: holding at playerpos instead")
		;eh, the reference's no longer there... let's pretend the order was to hold at the player's pos hahaha
		newPos = Game.GetPlayer()
	endif
	
	if(targetGroup == 0)
		ArcherMarker.GetReference().MoveTo(newPos)
		MeleeMarker.GetReference().MoveTo(newPos)
		RangerMarker.GetReference().MoveTo(newPos)
	elseif(targetGroup == 1)
		ArcherMarker.GetReference().MoveTo(newPos)
	elseif(targetGroup == 2)
		MeleeMarker.GetReference().MoveTo(newPos)
	else
		RangerMarker.GetReference().MoveTo(newPos)
	endif
endfunction


Function SetDefaultOrder(int targetGroup, int orderType)
	
	float orderFloat = orderType as float
	if(targetGroup == 0)
		DefaultArcherOrder.SetValue(orderFloat)
		DefaultMeleeOrder.SetValue(orderFloat)
		DefaultRangerOrder.SetValue(orderFloat)
	elseif(targetGroup == 1)
		DefaultArcherOrder.SetValue(orderFloat)
	elseif(targetGroup == 2)
		DefaultMeleeOrder.SetValue(orderFloat)
	else
		DefaultRangerOrder.SetValue(orderFloat)
	endif

endfunction
