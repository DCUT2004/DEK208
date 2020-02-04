class ArtifactDualOne extends EnhancedRPGArtifact;

function BotConsider()
{
	return;
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local Vehicle V;
	local DualityInv Inv;
	local Weapon W;

	if ((Instigator == None) || (Instigator.Controller == None))
	{
		bActive = false;
		GotoState('');
		return;	// really corrupt
	}
	
	if (Instigator != None && Instigator.Health > 0)
	{
		if (LastUsedTime + (TimeBetweenUses*AdrenalineUsage) > Instigator.Level.TimeSeconds)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// cannot use yet
		}

		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
		}
		Inv = DualityInv(Instigator.FindInventoryType(class'DualityInv'));
		if (RPGWeapon(Instigator.Weapon) != None)
			W = RPGWeapon(Instigator.Weapon).ModifiedWeapon;
		else
			W = Instigator.Weapon;
		if (Inv != None)
		{
			if (W == Inv.DualWeaponOne || W == Inv.DualWeaponTwo)
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
				bActive = false;
				GotoState('');
				return;
			}
			if (Inv.DualWeaponOne == None)
			{
				Inv.DualWeaponOne = W;
				Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
				SetTimer(0.2, True);
			}
			else
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
				bActive = false;
				GotoState('');
				return;
			}
		}
		else	//something wrong
		{
			bActive = false;
			GotoState('');
			return;
		}
	}
	bActive = false;
	GotoState('');
	return;
}

function Timer()
{
	setTimer(0, false);

	Destroy();
	Instigator.NextItem();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot use this artifact yet";
	else if (Switch == 2000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 3000)
		return "This weapon has already been selected in a dual combination";
	else if (Switch == 4000)
		return "Dual weapon set";
	else if (Switch == 5000)
		return "A dual weapon for this slot has already been selected";
	else if (Switch == 6000)
		return "You have already selected your dual weapons";
}

defaultproperties
{
     MinActivationTime=0.000001
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.1'
     ItemName="Set Dual Weapon 1"
}
