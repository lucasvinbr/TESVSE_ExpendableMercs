Scriptname EXMClearRefOnDeath extends ReferenceAlias  
{A script that just clears the alias' reference on its death
...ok, it does some other stuff as well}

;mercs can be melee, rangedArrows or rangedCustom
string Property mercType Auto

event OnDeath(Actor akKiller)	
	Debug.Notification("A mercenary has died!")
	Actor meActor = GetReference() as Actor
	(GetOwningQuest() as EXMMercSpawnerScript).MakeMercGiveItemsToEmissi(meActor, false, true, true)
	(GetOwningQuest() as EXMMercSpawnerScript).TryReHireIfActive(mercType)
endEvent

event OnLoad()
	if((GetOwningQuest() as EXMMercSpawnerScript).mercsRegenHealth)
		Actor meActor = GetReference() as Actor
		meActor.SetAV("HealRate", 1.50)
	endif
endEvent

Function BeDismissed()
	Actor meActor = GetReference() as Actor
	(GetOwningQuest() as EXMMercSpawnerScript).MakeMercGiveItemsToEmissi(meActor, false, true, true, true)
	
endFunction
