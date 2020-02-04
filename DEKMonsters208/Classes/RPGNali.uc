class RPGNali extends SMPNaliFighter;
	
var MutUT2004RPG RPGMut;

function PostBeginPlay()
{
	local Mutator m;
	local class<RPGWeapon> NewWeaponClass;
	local RPGWeapon RPGWeapon;
	Super.PostBeginPlay(); //probably cant call this. What's the ramifications?

	for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
		if (MutUT2004RPG(m) != None)
		{
			RPGMut = MutUT2004RPG(m);
			break;
		}
		
	if(Weapon == None)
		return; //huh?

	NewWeaponClass = RPGMut.GetRandomWeaponModifier(Weapon.class, self);
	if(NewWeaponClass == None)
		return;
	
	RPGWeapon = spawn(NewWeaponClass, self,,, rot(0,0,0));
	if(RPGWeapon == None)
		return;

	RPGWeapon.Generate(None);
	RPGWeapon.SetModifiedWeapon(Weapon, true);

	Weapon.DetachFromPawn(self);
	Weapon = RPGWeapon;
	RPGWeapon.Instigator = Self;
	AddInventory(RPGWeapon);
	RPGWeapon.AttachToPawn(self);
	RPGWeapon.Identify();
	bNoThrowWeapon=false;

	//tweak for mine? Nuke? Painter?
	if
	(
		Weapon.bSniping || 
		ClassIsChildOf( RPGWeapon.ModifiedWeapon.class, class'ONSMineLayer' ) ||
		ClassIsChildOf( RPGWeapon.ModifiedWeapon.class, class'ShockRifle' ) ||
		ClassIsChildOf( RPGWeapon.ModifiedWeapon.class, class'Redeemer' ) ||
		ClassIsChildOf( RPGWeapon.ModifiedWeapon.class, class'Painter' )
	)
		bMeleeFighter=false;
	Weapon.ClientState = WS_ReadyToFire;
}

function TossWeapon(Vector TossVel)
{
	return;		// do not throw, and see if crash stops
//	bNoThrowWeapon = false;
//	if(Weapon.isA('RPGWeapon') && Weapon.class != class'RPGWeapon')
//		super.TossWeapon(TossVel);
}

function bool SameSpeciesAs(Pawn P)
{
	return ( P.class == class'RPGNali' );
}

defaultproperties
{
     ControllerClass=Class'DEKMonsters208.DCNaliFighterController'
}
