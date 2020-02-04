class ArtifactSpecialize extends EnhancedRPGArtifact;

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
	local SpecialistInv Inv;
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
		Inv = SpecialistInv(Instigator.FindInventoryType(class'SpecialistInv'));
		if (RPGWeapon(Instigator.Weapon) != None)
			W = RPGWeapon(Instigator.Weapon).ModifiedWeapon;
		else
			W = Instigator.Weapon;
		if (Inv != None)
		{
			if (Inv.SelectedWeapon == None)
			{
				Inv.SelectedWeapon = W;
				Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
				SetTimer(0.2, True);
			}
			else
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
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
		return "A weapon has already been specialized";
	else if (Switch == 4000)
		return "You have chosen to specialize in this weapon";
	else
		return "Cannot use this artifact";
}

defaultproperties
{
     MinActivationTime=0.000001
     IconMaterial=Texture'HUDContent.Reticles.DomRing'
     ItemName="Weapon Specialize"
}
