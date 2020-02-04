class ArtifactMeteorShower extends EnhancedRPGArtifact
		config(UT2004RPG);

var config float MeteorLifespan;

function BotConsider()
{
	if (Instigator.Controller.Adrenaline < AdrenalineRequired)
		return;

	if ( !bActive && Instigator.Controller.Enemy != None
		   && Instigator.Controller.CanSee(Instigator.Controller.Enemy) && NoArtifactsActive() && FRand() < 0.3 )	// fairly rare
		Activate();
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local Vehicle V;
	local MeteorShowerInv Inv;
	local bool bCanSpawn;
	
	Super(EnhancedRPGArtifact).Activate();

	if (Instigator != None && Instigator.Controller != None)
	{
		if(Instigator.Controller.Adrenaline < (AdrenalineRequired*AdrenalineUsage))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired*AdrenalineUsage, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		if (LastUsedTime  + (TimeBetweenUses*TimeUsage) > Instigator.Level.TimeSeconds)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// cannot use yet
		}

		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle

		}
		bCanSpawn = GetSpawnHeight(Instigator.Location);
		if (bCanSpawn)
		{
			Inv = MeteorShowerInv(Instigator.FindInventoryType(class'MeteorShowerInv'));
			if (Inv == None)
			{
				Inv = Instigator.Spawn(class'MeteorShowerInv',Instigator);
				Inv.GiveTo(Instigator);
				Inv.Lifespan = MeteorLifespan;
				SetRecoveryTime(TimeBetweenUses*TimeUsage);
				Instigator.Controller.Adrenaline -= AdrenalineRequired*AdrenalineUsage;
				if (Instigator.Controller.Adrenaline < 0)
					Instigator.Controller.Adrenaline = 0;
			}
			else
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
				bActive = false;
				GotoState('');
				return;
			}
		}
		else
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 7000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}		
	}
	bActive = false;
	GotoState('');
	return;
}

function bool GetSpawnHeight(Vector MyLocation)
{
	local Vector UpEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	
	UpEndLocation = MyLocation + vect(0,0,1500);

    	AHit = Trace(HitLocation, HitNormal, UpEndLocation, MyLocation, true);
	if (AHit == None || !AHit.bWorldGeometry)
		return True;	
	else 
		return False;
}


exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 5000)
		return "Cannot use this artifact again yet";
	else if (Switch == 6000)
		return "Meteor shower is already active";
	else if (Switch == 7000)
		return "You do not have enough room above you to use this artifact";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
	 MeteorLifespan=10.0000
     AdrenalineRequired=50
     TimeBetweenUses=30
     CostPerSec=1
     MinActivationTime=0.000001
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.MeteorShower'
     ItemName="Meteor Shower"
}
