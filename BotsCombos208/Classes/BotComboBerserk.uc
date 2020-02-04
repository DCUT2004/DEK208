/* Unlike BotComboDefensive, we *do not* want to fully reproduce ComboBerserk.
 * It sucks. We'd rather come up with something that simply increases the fire
 * rate of the player in question.
 */
class BotComboBerserk extends Combo
	config(BotsCombos);

var config float Modifier;

var xEmitter Effect;
var BCBerserkInv BCBInv;

function StartEffect(xPawn P)
{
	if (P.Role == ROLE_Authority)
		Effect = Spawn(class'OffensiveEffect', P,, P.Location, P.Rotation);
// Create an inventory object to do the actual Berserk stuff ...
	if (BCBInv == None)
		BCBInv = spawn(class'BCBerserkInv', P,,,rot(0,0,0));
	if (BCBInv == None)
		StopEffect(P);

	BCBInv.BCD = self;
// It will be replicated in BCBInv to the client
	BCBInv.Modifier = Modifier;
	BCBInv.bBerserk = true;
	BCBInv.GiveTo(P);
}

// Be careful - this is called by Destroyed(), and trying to call
// Destroy() here runs into inf recursions.
function StopEffect(xPawn P)
{
	if (BCBInv != None)
	{
		BCBInv.StopBerserk(P);
	}
	if (Effect != None)
		Effect.Destroy();
}

defaultproperties
{
     Modifier=0.500000
     ExecMessage="Berserk!"
     ComboAnnouncementName="Berzerk"
     keys(0)=2
     keys(1)=2
     keys(2)=1
     keys(3)=1
}
