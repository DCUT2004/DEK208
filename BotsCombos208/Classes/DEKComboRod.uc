/* Originally tried to extend ComboDefensive, but that didn't go over well.
 * Server would bomb with Infinite script recursions!  Really, the only
 * function that's essentially different is Timer. */
class DEKComboRod extends Combo;

var class<xEmitter> HitEmitterClass;
var config int DamagePerHit;
var float TargetRadius;
var config int AdrenPerTarget;

function StartEffect(xPawn P)
{
	SetTimer(0.5, true);
	Timer();
}

function Timer()
{
	local Controller C, NextC;
	local xEmitter HitEmitter;
	local Pawn P;
	local DruidArtifactLightningRod Rod;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	P = Pawn(Owner);
	if (P != None && P.Health > 0)
	{
		MiInv = MissionInv(P.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(P.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(P.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(P.FindInventoryType(class'Mission3Inv'));
		Rod = DruidArtifactLightningRod(P.FindInventoryType(class'DruidArtifactLightningRod'));
	}

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;

		if(C == None)
		{
			C = NextC;
			break;
		}
		
		if ( C.Pawn != None && P != None && P.Controller != None && C.Pawn != P && C.Pawn.Health > 0 && !C.SameTeamAs(P.Controller)
			    && VSize(C.Pawn.Location - P.Location) < TargetRadius && FastTrace(C.Pawn.Location, P.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionBalloon') && PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) == None )
		{
			if(C == None)
			{
				C = NextC;
				break;
			}
			C.Pawn.TakeDamage(DamagePerHit, P, C.Pawn.Location, vect(0,0,0), class'DamTypeEnhLightningRod');
			if(C == None)
			{
				C = NextC;
				break;
			}
			HitEmitter = spawn(HitEmitterClass,,, P.Location, rotator(C.Pawn.Location - P.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = C.Pawn.Location;
			P.Controller.Adrenaline -= AdrenPerTarget;
			if (P.Controller.Adrenaline < 0)
				P.Controller.Adrenaline = 0;
			if(C == None)
			{
				C = NextC;
				break;
			}

			//now see if we killed it
			if (C == None || C.Pawn == None || C.Pawn.Health <= 0 )
				if ( P != None)
					class'ArtifactLightningBeam'.static.AddArtifactKill(P, class'WeaponRod');	// assume killed
				
			//Mission Tracking	
			if (Rod != None && MiInv != None && !MiInv.ThunderGodComplete)
			{
				if (Rod.bActive)
				{
					if (M1Inv != None && !M1Inv.Stopped && M1Inv.ThunderGodActive)
					{
						M1Inv.MissionCount++;
					}
					else if (M2Inv != None && !M2Inv.Stopped && M2Inv.ThunderGodActive)
					{
						M2Inv.MissionCount++;
					}
					else if (M3Inv != None && !M3Inv.Stopped && M3Inv.ThunderGodActive)
					{
						M3Inv.MissionCount++;
					}
				}
			}
		}
		C = NextC;
	}
	
	if (P != None && P.Controller != None && P.Controller.Adrenaline < 0)
		P.Controller.Adrenaline = 0;
}

function StopEffect(xPawn P)
{
}

defaultproperties
{
     HitEmitterClass=Class'XEffects.LightningBolt'
     DamagePerHit=10
     TargetRadius=2000.000000
     AdrenPerTarget=3
     ExecMessage="Lightning Rod!"
     keys(0)=1
     keys(1)=1
     keys(2)=1
     keys(3)=1
}
