class DEKDamageSentinelController extends Controller
	config(UT2004RPG);

var Controller PlayerSpawner;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;

var config float TimeBetweenShots;
var config float TargetRadius;
var config float XPPerHit;      // the amount of xp the summoner gets per projectile taken out
var class<xEmitter> ResupplyEmitterClass;

var float DamageAdjust;		// set by AbilityLoadedEngineer

var class<xEmitter> HitEmitterClass;        // for standard defense sentinel

var Material HealingOverlay;

var bool bHealing;
var int DoHealCount;


simulated event PostBeginPlay()
{
	local Mutator m;

	super.PostBeginPlay();

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
}

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
	if (PlayerSpawner.PlayerReplicationInfo != None && PlayerSpawner.PlayerReplicationInfo.Team != None )
	{
		if (PlayerReplicationInfo == None)
			PlayerReplicationInfo = spawn(class'PlayerReplicationInfo', self);
		PlayerReplicationInfo.PlayerName = PlayerSpawner.PlayerReplicationInfo.PlayerName$"'s Sentinel";
		PlayerReplicationInfo.bIsSpectator = true;
		PlayerReplicationInfo.bBot = true;
		PlayerReplicationInfo.Team = PlayerSpawner.PlayerReplicationInfo.Team;
		PlayerReplicationInfo.RemoteRole = ROLE_None;

		// adjust the fire rate according to weapon speed
		StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
			TimeBetweenShots = (default.TimeBetweenShots * 100)/(100 + StatsInv.Data.WeaponSpeed);
		if (DamageAdjust > 0.1)
			TimeBetweenShots = TimeBetweenShots / DamageAdjust;		// cant adjust damage for DamageAdjust, so update fire frequency
	}
	SetTimer(TimeBetweenShots, true);
}

function Timer()
{
	// lets target some enemies
	local Projectile P;
	local xEmitter HitEmitter;
	local Projectile ClosestP;
	local Projectile BestGuidedP;
	local int ClosestPdist;
	local int BestGuidedPdist;
	local Mutator m;
	Local DEKDamageSentinel DefPawn;

	if (PlayerSpawner == None || PlayerSpawner.Pawn == None || Pawn == None || Pawn.Health <= 0 || DEKDamageSentinel(Pawn) == None)
		return;		// going to die soon.

	DefPawn = DEKDamageSentinel(Pawn);

	// look for projectiles in range
	ClosestP = None;
	BestGuidedP = None;
	ClosestPdist = TargetRadius+1;
	BestGuidedPdist = TargetRadius+1;
	ForEach DynamicActors(class'Projectile',P)
	{
		if (P != None && FastTrace(P.Location, Pawn.Location) && TranslocatorBeacon(P) == None && DEKStingerTurretProj(P) == None && AerialTrapProjectile(P) == None && BombTrapProjectile(P) == None && FrostTrapProjectile(P) == NOne && ShockTrapProjectile(P) == None && WildfireTrapProjectile(P) == None && DEKLaserGrenadeProjectile(P) == None && LifeDrainSoulParticle(P) == None && VSize(Pawn.Location - P.Location) <= TargetRadius)
		{
			if ((P.InstigatorController == None ||
				(P.InstigatorController != None && ((TeamGame(Level.Game) != None && P.InstigatorController.SameTeamAs(PlayerSpawner))))))
			{
				if ( ClosestPdist > VSize(Pawn.Location - P.Location) && !P.bDeleteMe)
				{
					ClosestP = P;
					ClosestPdist = VSize(Pawn.Location - P.Location);
				}
				if (DefPawn.ResupplyLevel > 0 && ClosestP != None )
				{
					if (ClosestP.Damage < (((20.0 + DefPawn.ResupplyLevel)/20.0) * ClosestP.default.Damage)) //up to 25% extra damage if max level=5.
					{
						ClosestP.Damage *= ((20.0 + DefPawn.ResupplyLevel)/20.0);
						HitEmitter = spawn(HitEmitterClass,,, DefPawn.Location, rotator(P.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = P.Location;
					}
				}
				// ok, lets see if the initiator gets any xp
				if (StatsInv == None && PlayerSpawner != None && PlayerSpawner.Pawn != None)
					StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
				// quick check to make sure we got the RPGMut set
				if (RPGMut == None && Level.Game != None)
				{
					for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
						if (MutUT2004RPG(m) != None)
						{
							RPGMut = MutUT2004RPG(m);
							break;
						}
				}
				if ((XPPerHit > 0) && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
				{
					if (P.InstigatorController != PlayerSpawner)
						StatsInv.DataObject.AddExperienceFraction(XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
				}
			}
		}
	}
}

function Destroyed()
{
	if (PlayerReplicationInfo != None)
		PlayerReplicationInfo.Destroy();

	Super.Destroyed();
}

defaultproperties
{
     TimeBetweenShots=0.400000
     TargetRadius=700.000000
     XPPerHit=0.060000
     ResupplyEmitterClass=Class'DEKRPG208.RedBoltEmitter'
     DamageAdjust=1.000000
     HitEmitterClass=Class'DEKRPG208.PurpleBoltEmitter'
}
