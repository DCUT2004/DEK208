class PhantomGhostInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var bool stopped;
var int RegenAmount;
var MagicShieldInv Inv;
var config int PhantomLifespan;
var array<Material> OldInstigatorSkins;
var Material OldInstigatorRepSkin;
var array<ColorModifier> GhostSkins;
var color GhostColor;
var Material ModifierOverlay;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;
	PawnOwner = Other;
	
	OldInstigatorRepSkin = PawnOwner.RepSkin;
	PawnOwner.RepSkin = None;
	
	//Set the Timer
	SetTimer(0.5, true);
	
	//Set GodMode
	SwitchOnInvulnerability();
	
	//Give Magic Shield.
	Inv = MagicShieldInv(PawnOwner.FindInventoryType(class'MagicShieldInv'));
	if (Inv == None)
	{
		Inv = spawn(class'MagicShieldINv', PawnOwner,,, rot(0,0,0));
		Inv.GiveTo(PawnOwner);
	}
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		CreateGhostSkins();
		Instigator.Skins = GhostSkins;
	}
	
	Super.GiveTo(Other);
}

simulated function CreateGhostSkins()
{
	local int x;

	OldInstigatorSkins = Instigator.Skins;
	for (x = 0; x < Instigator.Skins.length; x++)
	{
		GhostSkins[x] = ColorModifier(Level.ObjectPool.AllocateObject(class'ColorModifier'));
		GhostSkins[x].Material = Instigator.Skins[x];
		GhostSkins[x].AlphaBlend = true;
		GhostSkins[x].RenderTwoSided = true;
		GhostSkins[x].Color = GhostColor;
	}
}

simulated function SwitchOnInvulnerability()
{
	PawnOwner.Controller.bGodMode = true;
	PawnOwner.SetCollision(false,false,false);
	PawnOwner.bCollideWorld = true;
	PawnOwner.Mass = 1000.000000;
}

simulated function SwitchOffInvulnerability()
{
	local int x;
	
	PawnOwner.Controller.bGodMode = false;
	PawnOwner.SetCollision(true,true,true);
	PawnOwner.bCollideWorld = true;
	PawnOwner.Mass = PawnOwner.Default.Mass;
	
	if (GhostSkins.length != 0)
	{
		if (Role == ROLE_Authority)
			PawnOwner.RepSkin = OldInstigatorRepSkin;
		if (Level.NetMode != NM_DedicatedServer)
		{
			PawnOwner.Skins = OldInstigatorSkins;
			if (GhostSkins.length != 0)
			{
				for (x = 0; x < GhostSkins.length; x++)
					Level.ObjectPool.FreeObject(GhostSkins[x]);
				GhostSkins.length = 0;
			}
		}
	}
	PawnOwner.setOverlayMaterial(ModifierOverlay, 0.5, true);
}

simulated function Timer()
{
	Local NullEntropyInv NInv;
	Local KnockbackInv KInv;
	Local DamageInv DInv;
	Local InvulnerabilityInv IInv;
	Local Vehicle Vehicle;
	
	Vehicle = PawnOwner.DrivenVehicle;
	
	if (Invasion(Level.Game) != None && !Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 11)
	{
		Destroy();
		return;
	}
	
	if(!stopped)
	{
		PhantomLifespan--;
		if (Owner == None || PawnOwner == None)
		{
			Destroy();
			return;
		}
		if (PawnOwner != None)
		{
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PhantomGhostMessage', 0);
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PhantomGhostTimer', PhantomLifespan/2);
			if (GhostSkins.length == 0)
				CreateGhostSkins();
			PawnOwner.Skins = GhostSkins;
			PawnOwner.setOverlayMaterial(ModifierOverlay, 10, true);
		}
		if (Role == ROLE_Authority)
		{
			if (Invasion(Level.Game) != None && !Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 11)
			{
				Destroy();
				return;
			}
			if (PhantomLifespan <= 0)
			{
				stopEffect();
			}
			
			if (PawnOwner != None)
			{	
				PawnOwner.GiveHealth(RegenAmount, PawnOwner.HealthMax);
				
				KInv = KnockbackInv(PawnOwner.FindInventoryType(class'KnockbackInv'));
				if(KInv != None)
				{
					KInv.PawnOwner = None;
					KInv.Destroy();
				}
				NInv = NullEntropyInv(PawnOwner.FindInventoryType(class'NullEntropyInv'));
				if(NInv != None)
				{
					NInv.PawnOwner = None;
					NInv.Destroy();
				}	
				DInv = DamageInv(PawnOwner.FindInventoryType(class'DamageInv'));
				if(DInv != None)
				{
					DInv.SwitchOffDamage();
					DInv.Destroy();
				}	
				IInv = InvulnerabilityInv(PawnOwner.FindInventoryType(class'InvulnerabilityInv'));
				if(IInv != None)
				{
					IInv.SwitchOffInvulnerability();
					IInv.Destroy();
				}
			}
		}
	}
}

simulated function Tick(float deltaTime)
{
	local Vehicle V;
	
	if (!stopped)
	{
		if (PawnOwner != None)
		{
			V = PawnOwner.DrivenVehicle;
			if (V != None)
			{
				V.EjectDriver();
			}
		}
	}
}

simulated function stopEffect()
{	
	if(stopped)
		return;
	else
		stopped = true;
	if(PawnOwner != None)
	{
		//Switch off GodMode
		SwitchOffInvulnerability();
		
		//Remove MagicShield
		if (Inv != None)
		{
			Inv.Destroy();
		}
	}
}

simulated function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
	 ModifierOverlay=FinalBlend'DEKMonstersTexturesMaster206E.GhostMonsters.InvshadeFB'
     GhostColor=(B=255,G=255,R=255,A=26)
     RegenAmount=5
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
	 PhantomLifespan=40	//divide by 2 to get lifespan in seconds
}
