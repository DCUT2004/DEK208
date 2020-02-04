class NecroAdrenWraithBlackHole extends UpgradeShockRifleBlackHole;

simulated function Attract(float DeltaTime, float RadiusScale, float StrengthScale)
{
	local Actor A;
	local Pawn P;
	local Vehicle V;
	local float actualAttractRadius, actualAttractStrength, dist;
	local vector dir, attraction;

	actualAttractRadius = AttractionRadius * RadiusScale;
	actualAttractStrength = AttractionStrength * StrengthScale;
	foreach DynamicActors(class'Actor', A)
	{
		P = Pawn(A);
		V = Vehicle(A);
		if ( A == None || P == None || A.Role != ROLE_Authority && !A.bNetTemporary || A.Location == Location || P.Controller == None || (P.Controller != None && P.Controller.SameTeamAs(Instigator.Controller)) || (1 << A.Physics & WantedPhysicsModes) == 0)
			continue; //stop. don't go through with the Attract function.
		if ( V != None && V.Driver != None)
			continue;
		if (P == Class'ONSWeaponPawn')
			continue;
		if (ClassIsChildOf(P.Class,Class'ONSWeaponPawn'))
			continue;
		if (P.GetTeamNum() == Instigator.GetTeamNum())
			continue;
		if (ClassIsChildOf(P.Class,Class'DruidBlock'))
			continue;
		dir = Location - A.Location;
		dist = VSize(dir);
		dir /= dist;

		if (dist > actualAttractRadius)
			continue;

		attraction = dir * (actualAttractStrength * Square(1 - dist / actualAttractRadius));

		if (P != None && P.Health > 0 && P.Controller != None && !P.Controller.SameTeamAs(Instigator.Controller) && (P != V || !ClassIsChildOf(P.Class,Class'Vehicle') || P != Class'ONSWeaponPawn' || !ClassIsChildOf(P.Class,Class'ONSWeaponPawn') || P != Class'ASTurret' || !ClassIsChildOf(P.Class,Class'ASTurret')))
		{
			if (P.Physics == PHYS_Ladder && P.OnLadder != None)
			{
				if (vector(P.OnLadder.WallDir) dot attraction < -100)
					P.SetPhysics(PHYS_Falling);
			}
			else if (P.Physics == PHYS_Walking)
			{
				if (P.PhysicsVolume.Gravity dot attraction < -100)
					P.SetPhysics(PHYS_Falling);
			}
			else if (P.Physics == PHYS_Spider)
			{
				// probably not a good idea as I have no idea what people use spider physics for
				if (P.Floor dot attraction > 1000)
					P.SetPhysics(PHYS_Falling);
			}
		}
		//else continue;

		// check this, in case physics change
		if (A.Physics == PHYS_Karma || A.Physics == PHYS_KarmaRagdoll)
		{
			A.KAddImpulse(DeltaTime * 10 * Sqrt(A.KGetMass()) * attraction, vect(0,0,0));
		}
		else if (P != None && P != Class'Vehicle')
		{
			A.Velocity += DeltaTime * attraction / Sqrt(A.Mass);
			P.Velocity.Z=50;
		}
		else if (UpgradeShockRifleBlackHole(A) != None && dist < 3 * (CollisionRadius + A.CollisionRadius))
		{
			A.Velocity -= DeltaTime * attraction / Sqrt(A.Mass);
		}
		else
		{
			A.Velocity += DeltaTime * attraction / Sqrt(A.Mass);
		}
	}
}

defaultproperties
{
	 AttractionRadius=800.000000
	 AttractionStrength=60000.000000
     SingularityEffectClass=Class'DEKMonsters208.NecroAdrenWraithBlackHoleEffect'
     LightningDamageType=Class'DEKMonsters208.DamTypeAdrenWraithLightning'
     DetonationTime=4.000000
     Damage=80.000000
     DamageRadius=500.000000
     MyDamageType=Class'DEKMonsters208.DamTypeAdrenWraithBlackHole'
}
