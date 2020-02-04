class PoisonSlugMiniBioGlob extends BioGlob;

var float PoisonLifeSpan;
var config float BaseChance;

function NullInBlast(float Radius)
{
	local float damageScale, pawndist;
	local vector pawndir;
	local Controller C, NextC;
	Local DruidPoisonInv Inv;

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if ( C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.Pawn.IsA('PoisonSlug') && !C.Pawn.IsA('PoisonPupae') && !C.Pawn.IsA('PoisonQueen')
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location))
		{
			pawndir = C.Pawn.Location - Location;
			pawndist = FMax(1,VSize(pawndir));
			damageScale = 1 - FMax(0,pawndist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'RW_Freeze'.static.canTriggerPhysics(C.Pawn) 
				&& (C.Pawn.FindInventoryType(class'DruidPoisonInv') == None) && (C.Pawn.FindInventoryType(class'MagicShieldInv') == None))
				
				if(rand(99) < int(BaseChance))
			{
				Inv = spawn(class'DruidPoisonInv', C.Pawn,,, rot(0,0,0));
				if(Inv != None)
				{
					Inv.LifeSpan = (damageScale * PoisonLifeSpan);	
					Inv.Modifier = (damageScale * PoisonLifeSpan);	// *3 because the NullEntropyInv divides by 3
					Inv.GiveTo(C.Pawn);
				}
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
     LightBrightness=80.000000
     PoisonLifespan=4.000000
     BaseChance=33.000000
     Speed=1000.000000
     MyDamageType=Class'DEKMonsters208.DamTypePoisonSlug'
}
