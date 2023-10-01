Scriptname EXMSummonEmissiSpellScript extends activemagiceffect  
{This script controls the Summon Emissi magic effect.}

Actor Property YourSummonREF Auto ; An ObjectReference will also work with the summon function

Activator Property PortalFX  Auto 
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
        Summon(akCaster, YourSummonREF, 150.0, 0.0, PortalFX)
EndEvent
 
; GetFormFromFile below to enable 'Global' flag
Function Summon(ObjectReference akSummoner = None, ObjectReference akSummon = None, Float afDistance = 150.0, Float afZOffset = 0.0, Activator arPortal = None, Int aiStage = 0) Global 

		ObjectReference newPortal

        While aiStage < 6
                aiStage += 1
                If aiStage == 1 ; Shroud summon with portal
                       newPortal = akSummon.PlaceAtMe(arPortal) ; SummonTargetFXActivator disables and deletes itself shortly after stage 5
                ElseIf aiStage == 2 ; Disable Summon
                        ;akSummon.Disable()
                ElseIf aiStage == 3 ; Move portal in front of summoner
                        newPortal.MoveTo(akSummoner, Math.Sin(akSummoner.GetAngleZ()) * afDistance, Math.Cos(akSummoner.GetAngleZ()) * afDistance, afZOffset)
                ElseIf aiStage == 4 ; Move summon to portal
                        akSummon.MoveTo(newPortal)
                ElseIf aiStage == 5 ; Enable summon as the portal dissipates
                        ;akSummon.Enable()
                EndIf
                Utility.Wait(0.6)
        EndWhile
EndFunction
