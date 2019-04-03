Scriptname EXMOptionsScript extends Quest  
{This script contains information related to the windows used to configure some aspects of the mod.}

Message Property MainMsgBox  Auto  

Message Property MercRaces1Box  Auto  

Message Property MercRaces2Box  Auto  

Message Property MercGendersBox  Auto  

Message Property MercCostBox  Auto  

Message Property ResetEmissiStuffBox  Auto 

Message Property ExtraOptionsBox  Auto

Spell Property summonEmissiSpell auto

Spell Property mercOrdersSpell auto

EXMMercSpawnerScript Property SpawnerScript Auto

;page 1
bool NordF = true  
bool NordM = true 
bool ImpF = true 
bool ImpM = true 
bool RedgF = true 
bool RedgM = true 
bool BretF = true 
bool BretM = true 
bool OrcF = true 
bool OrcM = true 

;page 2
bool ArgoF = true 
bool ArgoM = true 
bool KhajF = true 
bool KhajM = true 
bool DarkF = true 
bool DarkM = true 
bool WoodF = true 
bool WoodM = true 
bool HighF = true 
bool HighM = true 


float MercGoldCost = 150.0

event OnInit()
	Debug.Notification("Emissi's mercs initializing...")
	ReloadAllowedRaceList()
	
	MercGoldCost = SpawnerScript.MercGoldCost.GetValue()
	
	SpawnerScript.RefreshMercGoldCost()
	
	Debug.Notification("Emissi's mercs initialized!")
endEvent

Function GivePlayerTheEmissiSpell(Actor playerRef = none)
	if(playerRef == none)
		playerRef = Game.GetPlayer()
	endIf
	playerRef.AddSpell(summonEmissiSpell)
	playerRef.AddSpell(mercOrdersSpell)
endFunction

Function OpenTheConfigMenu()
	int mainMsgOption = 0
	while mainMsgOption != 4
		mainMsgOption = MainMsgBox.Show()
		while(mainMsgOption == 0) ;race/gender options
			int mercRacesOption = 0
			while(mainMsgOption != -1)
				if(mercRacesOption < 5)
					mercRacesOption = mercRaces1Box.Show()
					if(mercRacesOption == 5)
						mercRacesOption = 11 ;next page
					elseif(mercRacesOption == 6)
						mainMsgOption = -1
					endIf
				else
					mercRacesOption = 5
					mercRacesOption += mercRaces2Box.Show()
					if(mercRacesOption == 11)
						mainMsgOption = -1
					elseIf(mercRacesOption == 10)
						mercRacesOption = -1 ;previous page
					endIf
				endIf
			
				;do the config only if we didn't want to switch menus
				if(mercRacesOption != -1 && mercRacesOption != 11 && mainMsgOption != -1)
					DoRaceConfig(mercRacesOption)
				endIf
			endwhile
		endwhile
		
		while(mainMsgOption == 1) ;merc cost
			int mercCostOption = 0
			mercCostOption = MercCostBox.Show(MercGoldCost)
			
			if(mercCostOption == 0)
				MercGoldCost = 150
			elseIf mercCostOption == 1
				MercGoldCost += 50
			elseif mercCostOption == 2
				if(MercGoldCost >= 50)
					MercGoldCost -= 50
				endIf
			elseIf mercCostOption == 3
				MercGoldCost += 10
			elseif mercCostOption == 4
				if(MercGoldCost >= 10)
					MercGoldCost -= 10
				endIf
			else
				mainMsgOption = -1
			endIf
			
			RefreshGlobalMercGoldCost()
		endwhile
		
		while(mainMsgOption == 2) ;troubleshooting
			int troubleshootOption = 0
			troubleshootOption = ResetEmissiStuffBox.Show()
			
			if(troubleshootOption == 0)
				SpawnerScript.itemsHeldByEmissi.Revert()
				SpawnerScript.EXMheldLightCuirasses.Revert()
				SpawnerScript.EXMheldLightBoots.Revert()
				SpawnerScript.EXMheldLightGloves.Revert()
				SpawnerScript.EXMheldLightHelmets.Revert()
				SpawnerScript.EXMheldHvyCuirasses.Revert()
				SpawnerScript.EXMheldHvyBoots.Revert()
				SpawnerScript.EXMheldHvyGloves.Revert()
				SpawnerScript.EXMheldHvyHelmets.Revert()
				SpawnerScript.EXMheldBows.Revert()
				SpawnerScript.EXMheldMelee.Revert()
			else
				mainMsgOption = -1
			endIf
			
		endwhile
		
		while(mainMsgOption == 3) ;extra options
			int extraOption = 0
			extraOption = ExtraOptionsBox.Show(BoolToFloat(SpawnerScript.autoReHireMercs), BoolToFloat(SpawnerScript.mercsRegenHealth), BoolToFloat(SpawnerScript.randomizeUnspecifiedItems))
			
			if(extraOption == 0)
				SpawnerScript.autoReHireMercs = !SpawnerScript.autoReHireMercs
			elseif(extraOption == 1)
				SpawnerScript.mercsRegenHealth = !SpawnerScript.mercsRegenHealth
			elseif(extraOption == 2)
				SpawnerScript.randomizeUnspecifiedItems = !SpawnerScript.randomizeUnspecifiedItems
			else
				mainMsgOption = -1
			endIf
		endwhile
	endwhile
endFunction

Function RefreshGlobalMercGoldCost()
	SpawnerScript.MercGoldCost.SetValue(MercGoldCost)
	SpawnerScript.RefreshMercGoldCost()
endFunction

Function DoRaceConfig(int chosenRace)
	int genderBoxOption = 0
	while genderBoxOption != 2
		if chosenRace == 0
			genderBoxOption = MercGendersBox.Show(BoolToFloat(NordM), BoolToFloat(NordF))
			if(genderBoxOption == 0)
				NordM = !NordM
			elseIf(genderBoxOption == 1)
				NordF = !NordF
			endIf
		elseIf chosenRace == 1
			genderBoxOption = MercGendersBox.Show(BoolToFloat(ImpM), BoolToFloat(ImpF))
			if(genderBoxOption == 0)
				ImpM = !ImpM
			elseIf(genderBoxOption == 1)
				ImpF = !ImpF
			endIf
		elseIf chosenRace == 2
			genderBoxOption = MercGendersBox.Show(BoolToFloat(RedgM), BoolToFloat(RedgF))
			if(genderBoxOption == 0)
				RedgM = !RedgM
			elseIf(genderBoxOption == 1)
				RedgF = !RedgF
			endIf
		elseIf chosenRace == 3
			genderBoxOption = MercGendersBox.Show(BoolToFloat(BretM), BoolToFloat(BretF))
			if(genderBoxOption == 0)
				BretM = !BretM
			elseIf(genderBoxOption == 1)
				BretF = !BretF
			endIf
		elseIf chosenRace == 4
			genderBoxOption = MercGendersBox.Show(BoolToFloat(OrcM), BoolToFloat(OrcF))
			if(genderBoxOption == 0)
				OrcM = !OrcM
			elseIf(genderBoxOption == 1)
				OrcF = !OrcF
			endIf
		elseIf chosenRace == 5
			genderBoxOption = MercGendersBox.Show(BoolToFloat(ArgoM), BoolToFloat(ArgoF))
			if(genderBoxOption == 0)
				ArgoM = !ArgoM
			elseIf(genderBoxOption == 1)
				ArgoF = !ArgoF
			endIf
		elseIf chosenRace == 6
			genderBoxOption = MercGendersBox.Show(BoolToFloat(KhajM), BoolToFloat(KhajF))
			if(genderBoxOption == 0)
				KhajM = !KhajM
			elseIf(genderBoxOption == 1)
				KhajF = !KhajF
			endIf
		elseIf chosenRace == 7
			genderBoxOption = MercGendersBox.Show(BoolToFloat(DarkM), BoolToFloat(DarkF))
			if(genderBoxOption == 0)
				DarkM = !DarkM
			elseIf(genderBoxOption == 1)
				DarkF = !DarkF
			endIf
		elseIf chosenRace == 8
			genderBoxOption = MercGendersBox.Show(BoolToFloat(WoodM), BoolToFloat(WoodF))
			if(genderBoxOption == 0)
				WoodM = !WoodM
			elseIf(genderBoxOption == 1)
				WoodF = !WoodF
			endIf
		elseIf chosenRace == 9
			genderBoxOption = MercGendersBox.Show(BoolToFloat(HighM), BoolToFloat(HighF))
			if(genderBoxOption == 0)
				HighM = !HighM
			elseIf(genderBoxOption == 1)
				HighF = !HighF
			endIf
		endIf
		
		ReloadAllowedRaceList()
	endwhile
endFunction

float Function BoolToFloat(bool target)
	if target
		return 1.0
	endIf
	
	return 0.0
endFunction

Function ReloadAllowedRaceList()	
	SpawnerScript.AllowedRaceGenderPairs.Revert()
		
	if NordF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.NordF)
	endIf
	if NordM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.NordM)
	endIf
	if ArgoF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.ArgoF)
	endIf
	if ArgoM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.ArgoM)
	endIf
	if OrcF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.OrcF)
	endIf
	if OrcM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.OrcM)
	endIf
	if DarkF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.DarkF)
	endIf
	if DarkM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.DarkM)
	endIf
	if WoodF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.WoodF)
	endIf
	if WoodM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.WoodM)
	endIf
	if HighF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.HighF)
	endIf
	if HighM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.HighM)
	endIf
	if KhajF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.KhajF)
	endIf
	if KhajM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.KhajM)
	endIf
	if ImpF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.ImpF)
	endIf
	if ImpM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.ImpM)
	endIf
	if BretF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.BretF)
	endIf
	if BretM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.BretM)
	endIf
	if RedgF 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.RedgF)
	endIf
	if RedgM 
		SpawnerScript.AllowedRaceGenderPairs.AddForm(SpawnerScript.RedgM)
	endIf
	
	

EndFunction