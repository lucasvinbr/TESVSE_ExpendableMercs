;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 0
Scriptname EXM_TIF__0200182E Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor plyrRef = Game.GetPlayer()
(GetOwningQuest() as EXMMercSpawnerScript).TakeGoldFrom(plyrRef , 2000)
getowningquest().setstage(20)
(GetOwningQuest() as EXMOptionsScript).GivePlayerTheEmissiSpell(plyrRef )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
