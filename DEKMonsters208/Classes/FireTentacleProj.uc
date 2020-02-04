class FireTentacleProj extends DCTentacleProjectile;

var float HeatLifeSpan;
var config float BaseChance;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local SuperHeatInv Inv;
	local Pawn P;
	local MagicShieldInv MInv;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
		
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
				Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
				Explode(Location, vect(0,0,1));				
			}
			else
				Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
				Explode(Location, vect(0,0,1));
		}
	}	
}

defaultproperties
{
     HeatLifespan=4.000000
     BaseChance=25.000000
     MyDamageType=Class'DEKMonsters208.DamTypeFireTentacle'
     Skins(0)=Texture'DEKMonstersTexturesMaster206E.FireMonsters.FireGib'
}
