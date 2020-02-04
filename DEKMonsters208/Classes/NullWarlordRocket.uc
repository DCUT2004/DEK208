class NullWarlordRocket extends WarlordRocket;

var float MaxNullTime;

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local NullEntropyInv Inv;

	// freezes anything not a null warlord. Any side.
	
	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if(C.Pawn == None)
		{
			C = NextC;
			break;
		}
		if (C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.Pawn.IsA('NullWarlord')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) && (C.Pawn.FindInventoryType(class'NullEntropyInv') == None))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				Inv = spawn(class'NullEntropyInv', C.Pawn,,, rot(0,0,0));
				if(Inv != None)
				{
					Inv.LifeSpan = (damageScale * MaxNullTime * 3);	
					Inv.Modifier = (damageScale * MaxNullTime * 3);	// *3 because the NullEntropyInv divides by 3
					Inv.GiveTo(C.Pawn);
				}
			}
			if(C.Pawn == None)
			{
				C = NextC;
				break;
			}
		}

		C = NextC;
	}
}

function BlowUp(vector HitLocation)
{
	Super.BlowUp(HitLocation);
	// ok, lets null them according to how close to the centre they are
	NullInBlast(DamageRadius);
}

defaultproperties
{
     MaxNullTime=3.000000
     Damage=50.000000
     MyDamageType=Class'DEKMonsters208.DamTypeNullWarlord'
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Meshes.NullRocketProj'
}
