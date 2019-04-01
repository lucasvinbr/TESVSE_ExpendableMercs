Scriptname EXMEmissiSpecialAmmoStorage extends ObjectReference  
{this script allows Emissi to remember the last type of ammo the player gave him}

Form Property theAmmoTypePlayerGaveMe auto

Keyword Property ammoKeyword auto

Keyword Property lightArmorKeyword auto
Keyword Property hvyArmorKeyword auto

Keyword Property cuirassKeyword auto
Keyword Property bootsKeyword auto
Keyword Property glovesKeyword auto
Keyword Property helmetsKeyword auto

Keyword Property genWeaponKeyword auto ;generic weapons could be crossbows... I guess

Keyword Property battleaxeKeyword auto
Keyword Property greatswordKeyword auto
Keyword Property warhammerKeyword auto
Keyword Property daggerKeyword auto
Keyword Property swordKeyword auto
Keyword Property waraxeKeyword auto
Keyword Property maceKeyword auto

Formlist Property itemsHeldByMe auto

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

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

  if (akSourceContainer == Game.GetPlayer())
	if(akBaseItem.HasKeyword(ammoKeyword))
		theAmmoTypePlayerGaveMe = akBaseItem
		Debug.Notification("Emissi will now give that ammo type to special ammo mercenaries")
	elseif(akBaseItem.HasKeyword(lightArmorKeyword))
		if(akBaseItem.HasKeyword(cuirassKeyword))
			EXMheldLightCuirasses.AddForm(akBaseItem)
		elseif(akBaseItem.HasKeyword(bootsKeyword))
			EXMheldLightBoots.AddForm(akBaseItem)
		elseif(akBaseItem.HasKeyword(glovesKeyword))
			EXMheldLightGloves.AddForm(akBaseItem)
		elseif(akBaseItem.HasKeyword(helmetsKeyword))
			EXMheldLightHelmets.AddForm(akBaseItem)
		endif
	elseif(akBaseItem.HasKeyword(hvyArmorKeyword))
		if(akBaseItem.HasKeyword(cuirassKeyword))
			EXMheldHvyCuirasses.AddForm(akBaseItem)
		elseif(akBaseItem.HasKeyword(bootsKeyword))
			EXMheldHvyBoots.AddForm(akBaseItem)
		elseif(akBaseItem.HasKeyword(glovesKeyword))
			EXMheldHvyGloves.AddForm(akBaseItem)
		elseif(akBaseItem.HasKeyword(helmetsKeyword))
			EXMheldHvyHelmets.AddForm(akBaseItem)
		endif
	elseif(akBaseItem.HasKeyword(battleaxeKeyword) || akBaseItem.HasKeyword(warhammerKeyword) || \
	akBaseItem.HasKeyword(waraxeKeyword) || akBaseItem.HasKeyword(daggerKeyword) || \
	akBaseItem.HasKeyword(swordKeyword) || akBaseItem.HasKeyword(maceKeyword) || \
	akBaseItem.HasKeyword(greatswordKeyword))
		EXMheldMelee.AddForm(akBaseItem)
	elseif(akBaseItem.HasKeyword(genWeaponKeyword))
		;we assume that any weapon that doesnt fit into the above keywords are ranged weapons
		EXMheldBows.AddForm(akBaseItem)
	else
		itemsHeldByMe.AddForm(akBaseItem)
	endif
  endif
endEvent

Event OnItemRemoved(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if(GetItemCount(akBaseItem) == 0)
		itemsHeldByMe.RemoveAddedForm(akBaseItem)
		
		if(akBaseItem.HasKeyword(lightArmorKeyword))
			if(akBaseItem.HasKeyword(cuirassKeyword))
				EXMheldLightCuirasses.RemoveAddedForm(akBaseItem)
			elseif(akBaseItem.HasKeyword(bootsKeyword))
				EXMheldLightBoots.RemoveAddedForm(akBaseItem)
			elseif(akBaseItem.HasKeyword(glovesKeyword))
				EXMheldLightGloves.RemoveAddedForm(akBaseItem)
			elseif(akBaseItem.HasKeyword(helmetsKeyword))
				EXMheldLightHelmets.RemoveAddedForm(akBaseItem)
			endif
		elseif(akBaseItem.HasKeyword(hvyArmorKeyword))
			if(akBaseItem.HasKeyword(cuirassKeyword))
				EXMheldHvyCuirasses.RemoveAddedForm(akBaseItem)
			elseif(akBaseItem.HasKeyword(bootsKeyword))
				EXMheldHvyBoots.RemoveAddedForm(akBaseItem)
			elseif(akBaseItem.HasKeyword(glovesKeyword))
				EXMheldHvyGloves.RemoveAddedForm(akBaseItem)
			elseif(akBaseItem.HasKeyword(helmetsKeyword))
				EXMheldHvyHelmets.RemoveAddedForm(akBaseItem)
			endif
		elseif(akBaseItem.HasKeyword(battleaxeKeyword) || akBaseItem.HasKeyword(warhammerKeyword) || \
		akBaseItem.HasKeyword(waraxeKeyword) || akBaseItem.HasKeyword(daggerKeyword) || \
		akBaseItem.HasKeyword(swordKeyword) || akBaseItem.HasKeyword(maceKeyword) || \
		akBaseItem.HasKeyword(greatswordKeyword))
			EXMheldMelee.RemoveAddedForm(akBaseItem)
		elseif(akBaseItem.HasKeyword(genWeaponKeyword))
			;we assume that any weapon that doesnt fit into the above keywords are ranged weapons
			EXMheldBows.RemoveAddedForm(akBaseItem)
		endif
	endif
endEvent
