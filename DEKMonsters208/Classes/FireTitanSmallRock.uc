class FireTitanSmallRock extends SMPTitanSmallRock;

var float HeatLifeSpan;
var config float BaseChance;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
   local Vector X, RefNormal, RefDir;
	local SuperHeatInv Inv;
	local Pawn P;

	if (Other == Instigator)
		return;
    if (Other == Owner)
		return;
	if (Other.IsA('FireBrute') && Other.IsA('FireChildGasbag') && Other.IsA('FireChildSkaarjPupae') && Other.IsA('FireGasbag') && Other.IsA('FireGiantGasbag') && Other.IsA('FireKrall') && Other.IsA('FireLord') && Other.IsA('FireManta') && Other.IsA('FireMercenary') && Other.IsA('FireNali') && Other.IsA('FireNaliFighter') && Other.IsA('FireQueen') && Other.IsA('FireRazorfly') && Other.IsA('FireSkaarjPupae') && Other.IsA('FireSkaarjSniper') && Other.IsA('FireSkaarjTrooper') && Other.IsA('FireSkaarjSuperHeat') && Other.IsA('FireSlith') && Other.IsA('FireSlug') && Other.IsA('FireTitan'))
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
    else if ( Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			Other.TakeDamage(Damage,Instigator,HitLocation,MomentumTransfer * Normal(Velocity),MyDamageType);
			// now see if we can freeze em
			P = Pawn(Other);
			if (P != None && class'RW_Freeze'.static.canTriggerPhysics(P))

			if(rand(99) < int(BaseChance))
			{
				Inv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
				//dont add to the time a pawn is already frozen. It just wouldn't be fair.
				if (Inv == None)
				{
					Inv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
					Inv.Modifier = 2;
					Inv.LifeSpan = 3.0;
					Inv.GiveTo(P);
				}
			}
		}
	}
}

defaultproperties
{
     HeatLifespan=4.000000
     BaseChance=25.000000
}
