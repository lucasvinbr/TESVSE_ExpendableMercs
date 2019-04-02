Scriptname EXMClearRefOnDeath extends ReferenceAlias  
{A script that just clears the alias's reference on its death
...ok, it does some other stuff as well}


event OnDeath(Actor akKiller)	
	Debug.Notification("A mercenary has died!")
	(GetOwningQuest() as EXMMercSpawnerScript).MakeMercNoLongerNeeded(self, true)
endEvent

event OnLoad()
	if((GetOwningQuest() as EXMMercSpawnerScript).mercsRegenHealth)
		Actor meActor = GetReference() as Actor
		meActor.SetAV("HealRate", 1.50)
	endif
endEvent

Function BeDismissed()
	;no auto-re-hiring in this case
	(GetOwningQuest() as EXMMercSpawnerScript).MakeMercNoLongerNeeded(self, false)
endFunction
