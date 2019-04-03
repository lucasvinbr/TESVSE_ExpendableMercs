Scriptname EXMChangeTargetFaction extends Quest  

Faction Property FollowerFaction  Auto  
Faction Property SandboxerFaction  Auto  
Faction Property StickToEmissiFaction  Auto  

Function MakeTargetFollower(Actor targetRef)
	targetRef.RemoveFromFaction(SandboxerFaction)
	targetRef.RemoveFromFaction(StickToEmissiFaction)
	targetRef.AddToFaction(FollowerFaction)
	targetRef.EvaluatePackage()
endFunction

Function MakeTargetSandboxer(Actor targetRef)
	targetRef.RemoveFromFaction(FollowerFaction)
	targetRef.RemoveFromFaction(StickToEmissiFaction)
	targetRef.AddToFaction(SandboxerFaction)
	targetRef.EvaluatePackage()
endFunction

Function MakeTargetStickToEmissi(Actor targetRef)
	targetRef.RemoveFromFaction(SandboxerFaction)
	targetRef.RemoveFromFaction(FollowerFaction)
	targetRef.AddToFaction(StickToEmissiFaction)
	targetRef.EvaluatePackage()
endFunction

Function MakeAllMercsFollowers()
	Int i = 72
	While i > 11
		i -= 1
		ReferenceAlias aMercAlias = GetAlias(i) as ReferenceAlias
		
		if(aMercAlias.GetReference() != none)
			MakeTargetFollower(aMercAlias.GetReference() as Actor)
		endif
	EndWhile
endFunction

Function MakeAllMercsStickToEmissi()
	Int i = 72
	While i > 11
		i -= 1
		ReferenceAlias aMercAlias = GetAlias(i) as ReferenceAlias
		
		if(aMercAlias.GetReference() != none)
			MakeTargetStickToEmissi(aMercAlias.GetReference() as Actor)
		endif
	EndWhile
endFunction

Function MakeAllMercsSandbox()
	Int i = 72
	While i > 11
		i -= 1
		ReferenceAlias aMercAlias = GetAlias(i) as ReferenceAlias
		
		if(aMercAlias.GetReference() != none)
			MakeTargetSandboxer(aMercAlias.GetReference() as Actor)
		endif
	EndWhile
endFunction