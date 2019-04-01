Scriptname EXMVeryBigWeightLimit extends Actor  
{This script makes the actor it is attached to have a very big, almost limitless carry weight limit.}

Event OnLoad()
	Self.SetActorValue("CarryWeight", 9999)
EndEvent
