Scriptname EXMPlaceOrderCastMarkerScript extends ObjectReference  
{Script for the object placed at the target position of the EXM "Order Spell".
Used for orders that require a reference position that isn't the player}

EXMCombatOrdersScript Property ordersScript Auto

Event OnLoad()
	ordersScript.StartOrderProcedure(self)
	RegisterForSingleUpdate(5.0)
EndEvent

Event OnUpdate()
	Disable()
	Delete()
endEvent

