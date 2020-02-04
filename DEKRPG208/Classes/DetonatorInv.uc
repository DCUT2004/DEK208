class DetonatorInv extends Inventory
	config(UT2004RPG);

var int TimerCount;
var float RecoveryTime;

replication
{
	reliable if (Role == ROLE_Authority)
		SetClientRecoveryTime;
}

simulated function PostNetBeginPlay()
{
	if(Level.NetMode != NM_DedicatedServer)
		enable('Tick');

	super.PostNetBeginPlay();
}

function SetRecoveryTime(int RecoveryPeriod)
{
	RecoveryTime = Level.TimeSeconds + (RecoveryPeriod);
	SetClientRecoveryTime(RecoveryPeriod);
}

simulated function SetClientRecoveryTime(int RecoveryPeriod)
{
	// set the recoverytime on the client side for the hud display
	if(Level.NetMode != NM_DedicatedServer)
	{
		RecoveryTime = Level.TimeSeconds + RecoveryPeriod;
	}
}

simulated function int GetRecoveryTime()
{
	 return int(RecoveryTime - Level.TimeSeconds);
}

defaultproperties
{
}
