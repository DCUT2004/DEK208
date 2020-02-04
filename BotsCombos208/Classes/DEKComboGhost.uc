class DEKComboGhost extends Combo;

#exec OBJ LOAD FILE="..\Textures\D-E-K-HoloGramFX.utx"
#exec OBJ LOAD FILE="..\Sounds\announcerfemale2k4.uax"

var Material ModifierOverlay;
var MagicShieldInv Inv;

function StartEffect(xPawn P)
{
	SetTimer(0.5, true);
	Timer();
	SwitchOnInvulnerability(P);
}

function SwitchOnInvulnerability(xPawn P)
{
	P.SetCollision(false,false,false);
	P.bCollideWorld = true;
	
	//Give Magic Shield.
	Inv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
	if (Inv == None)
	{
		Inv = spawn(class'MagicShieldInv', P,,, rot(0,0,0));
		Inv.GiveTo(P);
	}
	
	//P.PlaySound(Sound'AnnouncerFemale2k4.Generic.Holograph', SLOT_None, 500.0);
	if (PlayerController(P.Controller) != None)
		PlayerController(P.Controller).ClientPlaySound(Sound'AnnouncerFemale2k4.Generic.Holograph');
}

function SwitchOffInvulnerability(xPawn P)
{
	local CraftsmanInv CInv;
	
	//P.Controller.bGodMode = false;
	P.SetCollision(true,true,true);
	P.bCollideWorld = true;
	//P.Mass = P.Default.Mass;
	
	CInv = CraftsmanInv(P.FindInventoryType(class'CraftsmanInv'));	//could be that a Craftsman hasn't bought the MS ability yet, but oh well..
	if (Inv != None && CInv == None)
	{
		Inv.Destroy();
	}
}

simulated function Timer()
{
    local Pawn P;
	local Vehicle V;

    P = Pawn(Owner);
	V = Vehicle(Owner);
	
	if (Role == ROLE_Authority)
	{
		if (P != None)
		{
			P.setOverlayMaterial(ModifierOverlay, 1, true);
		}
	}
	
	if (V != None)
		Destroy();
}

function StopEffect(xPawn P)
{
	SwitchOffInvulnerability(P);
}

defaultproperties
{
     ModifierOverlay=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_2'
     ExecMessage="Holograph!"
     Duration=10.000000
     keys(0)=8
     keys(1)=8
     keys(2)=4
     keys(3)=4
}
