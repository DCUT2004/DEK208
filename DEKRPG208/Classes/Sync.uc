/*
	I'm sick of adding functions to the RPGPlayerReplicationInfo for things like
	projectile speeds (Force).
	
	This is a new solution attempt, an Actor that will be spawned on all clients,
	just to transmit certain information to them.
	
	ClientFunction is to do whatever is supposed to do on the client, all information
	required can simply be replicated.
*/
class Sync extends Actor;

var float LifeTime;

replication
{
	reliable if(Role == ROLE_Authority && bNetInitial)
		LifeTime;
}

simulated event Tick(float dt)
{
	Super.Tick(dt);

	LifeTime -= dt;
	if(LifeTime <= 0.0f)
	{
		Destroy();
		return;
	}

	if(Role == ROLE_Authority)
		return;
	
	if(ClientFunction())
		Destroy();
}

//return true if this should be destroyed (client)
simulated function bool ClientFunction();

defaultproperties
{
     Lifetime=5.000000
     DrawType=DT_None
     bNetTemporary=True
     bAlwaysRelevant=True
     bReplicateInstigator=True
     bReplicateMovement=False
     RemoteRole=ROLE_SimulatedProxy
}
