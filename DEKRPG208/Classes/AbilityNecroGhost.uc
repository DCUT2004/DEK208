class AbilityNecroGhost extends RPGDeathAbility
	abstract;
	
var config float PhantomDamageMultiplier;

static function bool GenuinePreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel)
{
	local Vehicle V;
	Local PhantomGhostInv Inv;
	local PhantomDeathGhostInv PDInv;
	Local NullEntropyInv NInv;
	Local KnockbackInv KInv;
	Local DamageInv DInv;
	Local InvulnerabilityInv IInv;
	local NecroInv NEInv;

	//Deviation from Mysterial's code. I dont think I need this.
	//if (Killed.Location.Z < Killed.Region.Zone.KillZ || Killed.PhysicsVolume.IsA('ConvoyPhysicsVolume'))
	//	return false;

	//spacefighters destroy all their inventory on possess, so if we do anything here it will never die
	//because our marker will get destroyed afterward
	if ( Killed.IsA('ASVehicle_SpaceFighter')
	     || (Killed.DrivenVehicle != None && Killed.DrivenVehicle.IsA('ASVehicle_SpaceFighter')) )
		return false;

	//this ability doesn't work with SVehicles or any kind of turret (can't change their physics)

	// Okay um.  This seems to work for monsters, blocks and sentinels!  Fix that!
	if (Killed.IsA('Monster') || DruidBlock(Killed) != None || DruidExplosive(Killed) != None  || DruidEnergyWall(Killed) != None || (ASVehicle(Killed) != None && ASVehicle(Killed).bNonHumanControl))
		return false;

	if (Killed.bStationary || Killed.IsA('SVehicle'))
	{
		//but maybe we can save the driver!
		V = Vehicle(Killed);
		if (V != None && !V.bRemoteControlled && !V.bEjectDriver && V.Driver != None)
			V.Driver.Died(Killer, DamageType, HitLocation);
		return false;
	}

	//ability won't work if pawn is still attached to the vehicle
	if (Killed.DrivenVehicle != None)
	{
		Killed.Health = 1; //so vehicle will properly kick pawn out
		Killed.DrivenVehicle.KDriverLeave(true);
	}

// ULTIMA REMOVED.  Shouldn't be needed in RPGDeathAbility.
	
	KInv = KnockbackInv(Killed.FindInventoryType(class'KnockbackInv'));
	if(KInv != None)
	{
		KInv.PawnOwner = None;
		KInv.Destroy();
	}
	NInv = NullEntropyInv(Killed.FindInventoryType(class'NullEntropyInv'));
	if(NInv != None)
	{
		NInv.PawnOwner = None;
		NInv.Destroy();
	}	
	DInv = DamageInv(Killed.FindInventoryType(class'DamageInv'));
	if(DInv != None)
	{
		DInv.SwitchOffDamage();
		DInv.Destroy();
	}	
	IInv = InvulnerabilityInv(Killed.FindInventoryType(class'InvulnerabilityInv'));
	if(IInv != None)
	{
		IInv.SwitchOffInvulnerability();
		IInv.Destroy();
	}
	NEInv = NecroInv(Killed.FindInventoryType(class'NecroInv'));
	if(NEInv != None)
	{
		return false; //don't allow Ghosting under revenant state
	}
	
	Inv = PhantomGhostInv(Killed.FindInventoryType(class'PhantomGhostInv'));
	PDInv = PhantomDeathGhostInv(Killed.FindInventoryType(class'PhantomDeathGhostInv'));
	
	if (Inv == None)
	{
		Inv = Killed.spawn(class'PhantomGhostInv', Killed,,, rot(0,0,0));
		Inv.GiveTo(Killed);
		return true;
	}
	else
	{
		if (AbilityLevel >= 2)
		{
			if (Killed.Level.Game.IsA('Invasion'))
			{
				if (PDInv == None)
				{
					PDInv = Killed.spawn(class'PhantomDeathGhostInv', Killed,,, rot(0,0,0));
					PDInv.GiveTo(Killed);	
					return true;
				}
				else
				{
					PDInv.GiveTo(Killed);
					return false;
				}
			}
			else
				return false;
		}
		else
			return false;
	}
	return false;
}

static function bool PreventSever(Pawn Killed, name boneName, int Damage, class<DamageType> DamageType, int AbilityLevel)
{
	local PhantomGhostInv Inv;
	local PhantomDeathGhostInv PDInv;

	Inv = PhantomGhostInv(Killed.FindInventoryType(class'PhantomGhostInv'));
	if (Inv != None)
		return false;
		
	PDInv = PhantomDeathGhostInv(Killed.FindInventoryType(class'PhantomDeathGhostInv'));
	if (PDInv != None)
		return false;

	return true;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local PhantomGhostInv Inv;

	if(!bOwnedByInstigator)
		return;
	if(bOwnedByInstigator && Damage > 0 && Instigator != None)
	{
		Inv = PhantomGhostInv(Instigator.FindInventoryType(class'PhantomGhostInv'));
		if (Inv != None && !Inv.stopped)
			Damage *= default.PhantomDamageMultiplier;
			Log("Reducing damage for Blood Drain during Second Phantom");
	}
}

defaultproperties
{
	 PhantomDamageMultiplier=1.50000
     MinHealthBonus=200
     MinDR=50
     LevelCost(1)=40
	 LevelCost(2)=40
     ExcludingAbilities(0)=Class'UT2004RPG.AbilityGhost'
     ExcludingAbilities(1)=Class'DEKRPG208.DruidGhost'
     AbilityName="Phantom"
     Description="Level One:|Much like the traditional ghost ability, the first time each spawn that you take damage that would kill you, instead of dying you will become a non-corporeal phantom where you will continue your life. This ability allows you to control your phantom state, and you will regenerate health and deal more damage during this state.||Level Two:|Upon taking a second fatal hit, instead of dying you will once again become a phantom, but this time you cannot return from the phantom state and you cannot directly attack targets. If all other team members are dead or are also phantoms during the second phantom state, you will automatically suicide. During this phantom state, you can pass through targets to build up energy for an attack.||You need at least 200 Health Bonus and 50 Damage Reduction to purchase this ability. You cannot have this ability and Ghost at the same time.||Cost(per level): 40"
     MaxLevel=2
}
