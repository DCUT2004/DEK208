class FireGasBagBelch extends GasBagBelch;

var float HeatLifeSpan;
var config float BaseChance;

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local SuperHeatInv Inv;

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
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(InstigatorController) && !C.Pawn.IsA('FireBrute') && !C.Pawn.IsA('FireChildGasbag') && !C.Pawn.IsA('FireChildSkaarjPupae') && !C.Pawn.IsA('FireGasbag') && !C.Pawn.IsA('FireGiantGasbag') && !C.Pawn.IsA('FireKrall') && !C.Pawn.IsA('FireLord') && !C.Pawn.IsA('FireManta') && !C.Pawn.IsA('FireMercenary') && !C.Pawn.IsA('FireNali') && !C.Pawn.IsA('FireNaliFighter') && !C.Pawn.IsA('FireQueen') && !C.Pawn.IsA('FireRazorfly') && !C.Pawn.IsA('FireSkaarjPupae') && !C.Pawn.IsA('FireSkaarjSniper') && !C.Pawn.IsA('FireSkaarjTrooper') && !C.Pawn.IsA('FireSkaarjSuperHeat') && !C.Pawn.IsA('FireSlith') && !C.Pawn.IsA('FireSlug') && !C.Pawn.IsA('FireTitan')  && !C.Pawn.IsA('FireTentacle')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) && MagicShieldInv(C.Pawn.FindInventoryType(class'MagicShieldInv')) == None )
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) && (C.Pawn.FindInventoryType(class'SuperHeatInv') == None))
			{
				if(C.Pawn == None)
				{
					C = NextC;
					break;
				}
				if(rand(99) < int(BaseChance))
				{
					Inv = spawn(class'SuperHeatInv', C.Pawn,,, rot(0,0,0));
					if(Inv != None)
					{
						Inv.LifeSpan = (damageScale * HeatLifeSpan);	
						Inv.Modifier = (damageScale * HeatLifeSpan);	// *3 because the NullEntropyInv divides by 3
						Inv.GiveTo(C.Pawn);
					}
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
     HeatLifespan=4.000000
     BaseChance=25.000000
     MyDamageType=Class'DEKMonsters208.DamTypeFireGasbag'
}
