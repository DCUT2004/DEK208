class ArtifactRemoteDamage extends RPGArtifact
		config(UT2004RPG);

var class<xEmitter> HitEmitterClass;
var config int AdrenalineRequired;
var config float MaxRange;
var config int DamageRunTime;
var config int XPforUse;
var RPGRules Rules;
var config float KillXPPerc;

function BotConsider()
{
	return;		// the chance of a bot using this correctly is soo low as to be not worth it.
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');

	CheckRPGRules();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function Activate()
{
	local Vehicle V;
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local Pawn  HitPawn;
	local Vector StartTrace;
	local xEmitter HitEmitter;
	local Actor A;
	local DamageInv DInv;
	local CraftsmanInv CInv;

	if ((Instigator != None) && (Instigator.Controller != None))
	{
		if (Instigator.Controller.Adrenaline < AdrenalineRequired)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// not enough power to charge
		}

		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
		}

		// lets see what we hit then
		FaceDir = Vector(Instigator.Controller.GetViewRotation());
		StartTrace = Instigator.Location + Instigator.EyePosition();
		BeamEndLocation = StartTrace + (FaceDir * MaxRange);

		// See if we hit something.
       		AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
		if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
		{
			// missed. 
			bActive = false;
			GotoState('');
			return;	// didn't hit an enemy
		}

		HitPawn = Pawn(AHit);
		if ( HitPawn != Instigator && HitPawn.Health > 0 && HitPawn.Controller.SameTeamAs(Instigator.Controller)
		     && VSize(HitPawn.Location - StartTrace) < MaxRange && Vehicle(HitPawn) == None)
		{
			if( HitPawn.HasUDamage())
			{
				// missed. 
				Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
				bActive = false;
				GotoState('');
				return;	// didn't hit a person we can give extra damage to
			}
			CInv = CraftsmanInv(HitPawn.FindInventoryType(class'CraftsmanInv'));
			if (CInv != None)
			{   // already got one
				Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
				bActive = false;
				GotoState('');
				return;	// Can't remote-boost a Craftsman
			}
			// now do the work
			// udamage is false so can't already have this set yet
			DInv = DamageInv(HitPawn.FindInventoryType(class'DamageInv'));
			DInv = spawn(class'DamageInv', HitPawn,,, rot(0,0,0));
			if(DInv != None)
			{
				DInv.bSphereActivated = False;
				DInv.Rules = Rules;
				DInv.KillXPPerc = KillXPPerc;
				DInv.DamagePlayerController = Instigator.Controller;
				DInv.EstimatedRunTime = DamageRunTime;
				DInv.GiveTo(HitPawn);
			}

			// take off adrenaline, and add xp
			Instigator.Controller.Adrenaline -= AdrenalineRequired;
			if (Instigator.Controller.Adrenaline < 0)
				Instigator.Controller.Adrenaline = 0;

			// got it.
			HitEmitter = spawn(HitEmitterClass,,, (StartTrace + Instigator.Location)/2, rotator(HitLocation - ((StartTrace + Instigator.Location)/2)));
			if (HitEmitter != None)
			{
				HitEmitter.mSpawnVecA = HitPawn.Location;
			}

			A = spawn(class'BlueSparks',,, Instigator.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(Sound'WeaponSounds.LightningGun.LightningGunImpact',,1.5*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
			}
			A = spawn(class'BlueSparks',,, HitPawn.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(Sound'WeaponSounds.LightningGun.LightningGunImpact',,1.5*HitPawn.TransientSoundVolume,,HitPawn.TransientSoundRadius);
			}

			if(HitPawn != None && PlayerController(HitPawn.Controller) != None)	
				PlayerController(HitPawn.Controller).ReceiveLocalizedMessage(class'DamageConditionMessage', 0, Instigator.PlayerReplicationInfo);

			// ok, lets see if the initiator gets any xp
			if ((XPforUse > 0) && (Rules != None))
			{
				Rules.ShareExperience(RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv')), XPforUse);
			}

		}
	}
	bActive = false;
	GotoState('');
	return;			
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
		return "Cannot use this artifact inside a vehicle.";
	else if (Switch == 4000)
		return "That person cannot accept the powerup.";
	else if (Switch == 5000)
		return "Cannot remote-boost a Craftsman.";
	else
		return "At least" @ switch @ "adrenaline is required to use this artifact";
}

defaultproperties
{
     HitEmitterClass=Class'DEKRPG208.PurpleBoltEmitter'
     MaxRange=3000.000000
     AdrenalineRequired=100
     DamageRunTime=20
     XPForUse=10
     KillXPPerc=0.250000
     CostPerSec=1
     MinActivationTime=0.000001
     IconMaterial=Texture'DEKRPGTexturesMaster207P.Artifacts.RemoteDamageIcon'
     ItemName="Remote Extra Damage"
}
