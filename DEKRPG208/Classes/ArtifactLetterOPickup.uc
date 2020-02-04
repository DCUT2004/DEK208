class ArtifactLetterOPickup extends TournamentPickUp;

var ArtifactLetterGlow GemXPGlow;
var MutUT2004RPG RPGMut;

#exec  AUDIO IMPORT NAME="ExpPickup" FILE="C:\UT2004\Sounds\ExpPickup.WAV" GROUP="ArtifactSounds"

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	GemXPGlow = spawn(class'ArtifactLetterGlow',self,,Location,Rotation);
	if (GemXPGlow != None)
		GemXPGlow.RemoteRole = ROLE_SimulatedProxy;

	RPGMut = class'MutUT2004RPG'.static.GetRPGMutator(Level.Game);
}

auto state Pickup
{
	function Touch(Actor Other)
	{
	        local Pawn PawnOwner;
			local Controller C;
		local LetterBInv B;
		local LetterNInv N;
		local LetterUInv U;
		local LetterSInv S;

		if (ValidTouch(Other))
		{
			PawnOwner = Pawn(Other);
			if (PawnOwner != None && PawnOwner.Health > 0)
			{
				B = LetterBInv(PawnOwner.FindInventoryType(class'LetterBInv'));
				N = LetterNInv(PawnOwner.FindInventoryType(class'LetterNInv'));
				U = LetterUInv(PawnOwner.FindInventoryType(class'LetterUInv'));
				S = LetterSInv(PawnOwner.FindInventoryType(class'LetterSInv'));
				if (B == None || N == None || U == None || S == None)
				{
					for ( C = Level.ControllerList; C != None; C = C.NextController )
						if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(PawnOwner.Controller) )
							PlayerController(C).ClientPlaySound(Sound'GameSounds.Fanfares.UT2k3Fanfare01');
					
					if (PawnOwner.PlayerReplicationInfo != None)
						BroadcastLocalizedMessage(class'LetterOMessage', 0, PawnOwner.PlayerReplicationInfo);
				}
			}
		}
		Super.Touch(Other);
	}
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	return MaxDesireability;
}

defaultproperties
{
     MaxDesireability=1.500000
     InventoryType=Class'DEKRPG208.LetterOInv'
     PickupMessage="You got letter O! Spell BONUS!"
     PickupSound=Sound'DEKRPG208.ArtifactSounds.ExpPickup'
     PickupForce="SniperRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster207P.Artifacts.BONUSlettersO'
     LifeSpan=30.000000
     DrawScale=0.900000
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.SBlend_1'
     AmbientGlow=128
}
