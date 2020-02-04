/* The mutator class for BotsCombos.  This is where all combo replacement
 * starts.  Some code here does not apply to dedicated server environs.  It's
 * kept in the hope that if someone really really really wanted to try it in
 * a Non-DS situation, it might still work. */
class MutBotsCombos extends Mutator
	config(BotsCombos);

var config string newComboString[16];
var config class<Combo> newComboClass[16];


function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local xPlayer xpl;
	local int c;

	bSuperRelevant = 0;

// Not so convinced this works.  It was this way in NoInvis ...
	if(Bot(Other) != None)
	{
		for(c = 0; c < ArrayCount(Bot(Other).ComboNames); c++ )
		{
			Bot(Other).ComboNames[c] = newComboString[c];
		}
	}
// I'm not sure this has to be here - I know if the similar code in
// ModifyPlayer wasn't there, things don't work 100% as desired.
// NoInvis had a similar stanza but not one in ModifyPlayer ...
// Perhaps this is for non-dedicated situations?
	else if(xPlayer(Other) != None && Level.NetMode != NM_DedicatedServer)
	{
		Warn("Check replacment run:"@Other);
		Warn("Level.NetMode:"@Level.NetMode);
		xpl = xPlayer(Other);
		for (c = 0; c < ArrayCount(xpl.ComboList); c++)
		{
			if(newComboString[c] != "")
			{
				xpl.ComboNameList[c] = newComboString[c];
				xpl.ComboList[c] = class<Combo>( DynamicLoadObject(newComboString[c], class'Class' ) );
			}else
			{
				xpl.ComboNameList[c] = "";
				xpl.ComboList[c] = None;
			}
		}
	}
	return true;
}

/* Don't ask me why - this gets called twice it seems, resulting in the
 * replication occurring twice at least for the first guy.
 * It could be a problem, I don't know yet. */
function ModifyPlayer(Pawn Other)
{
	local xPawn xp;
	local xPlayer xpl;
	local int c;
	local BotsCombosReplication BCRep;

	Super.ModifyPlayer(Other);

	if(BCRep == None)
		BCRep = spawn(class'BotsCombosReplication',Other,,,rot(0,0,0));
	if(BCRep == None)
		Warn("No BCRep found - UNSAFE TO CONTINUE!");
	BCRep.BCMut = self;
	BCRep.Initialize();

// This should fix the bot bug I ran into in my testing.
	if (Bot(Other.Controller) != None)
	{
		for(c = 0; c < ArrayCount(Bot(Other.Controller).ComboNames); c++ )
		{
			Bot(Other.Controller).ComboNames[c] = newComboString[c];
		}
	}

	xp = xPawn(Other);
	if (xp == None)
		return;
	xpl = xPlayer(xp.Controller);
	if(xpl == None)
		return;
	for (c = 0; c < ArrayCount(xpl.ComboList); c++)
	{
		if(newComboString[c] != "")
		{
			xpl.ComboNameList[c] = newComboString[c];
			xpl.ComboList[c] = class<Combo>( DynamicLoadObject(newComboString[c], class'Class' ) );      
		}else
		{
			xpl.ComboNameList[c] = "";
			xpl.ComboList[c] = None;
		}
	}
}

defaultproperties
{
     newComboString(0)="BotsCombos208.BotComboDefensive"
     newComboString(1)="BotsCombos208.BotComboBerserk"
     newComboString(2)="BotsCombos208.DEKComboRod"
     newComboString(3)="BotsCombos208.DEKComboGhost"
     newComboClass(0)=Class'BotsCombos208.BotComboDefensive'
     newComboClass(1)=Class'BotsCombos208.BotComboBerserk'
     newComboClass(2)=Class'BotsCombos208.DEKComboRod'
     newComboClass(3)=Class'BotsCombos208.DEKComboGhost'
     GroupName="BotsCombos208"
     FriendlyName="Bot's Combos"
     Description="Bot's Combo fixes the berserk and booster combos for UT2004 RPG. It also replaces the speed combo with the lightning rod combo, and the invisibility combo with the holograph combo."
}
