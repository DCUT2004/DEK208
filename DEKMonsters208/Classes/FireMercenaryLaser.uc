//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FireMercenaryLaser extends ONSAttackCraftPlasmaProjectileRed;

var float HeatLifeSpan;
var config float BaseChance;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Vector X, RefNormal, RefDir;
	local SuperHeatInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
	
    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
    }
	if ( Role == ROLE_Authority )
	{
		Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
		// now see if we can freeze em
		P = Pawn(Other);
		if (P != None && P.Controller != None && P.Health > 0 && !P.Controller.SameTeamAs(InstigatorController) && class'RW_Freeze'.static.canTriggerPhysics(P))
		{
			MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
			if (MInv == None)
			{
				if(rand(99) < int(BaseChance))
				{
					Inv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
					if (Inv == None)
					{
						Inv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
						Inv.Modifier = 2;
						Inv.LifeSpan = 3.0;
						Inv.GiveTo(P);
					}
				}
				Explode(Location, vect(0,0,1));				
			}
			else
				Explode(Location, vect(0,0,1));
		}
	}	
}

defaultproperties
{
     HeatLifespan=3.000000
     BaseChance=25.000000
     HitEffectClass=Class'DEKMonsters208.FireMercenaryPlasmaHitEffect'
     PlasmaEffectClass=Class'DEKMonsters208.FireMercenaryPlasmaEffect'
     Speed=2500.000000
     MaxSpeed=2500.000000
     DamageRadius=100.000000
     MyDamageType=Class'DEKMonsters208.DamTypeFireMercenary'
}
