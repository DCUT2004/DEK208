/* This replicates the replacement of the combo to the clients. Bad bad bad bad
 * bad things happen if this doesn't do its job.  While some ideas for this
 * came from the NoInvis code, it turns out that code from UT2004RPG provided
 * better clues and easier to understand routines to get stuff to the client.
 */
class BotsCombosReplication extends ReplicationInfo;

var MutBotsCombos BCMut;
var bool Initialized;

replication
{
	reliable if (Role == ROLE_Authority)
		ClientReceiveCombos;
}

function Initialize()
{
	local int x;

	if(!Initialized)
	{
		if(BCMut != None)
		{
			for (x = 0; x < ArrayCount(BCMut.newComboString); x++)
			{
				if(BCMut.newComboString[x] != "" || BCMut.newComboClass[x] != None)
				{
					ClientReceiveCombos(x, BCMut.newComboString[x], BCMut.newComboClass[x]);
				}else
				{
					ClientReceiveCombos(x, "", None);
				}
			}
			Initialized = True;
		}
	}
}

simulated function ClientReceiveCombos(int index, string newComboString, class<Combo> newComboClass)
{
	local xPlayer p;

	p = xPlayer(Level.GetLocalPlayerController());
	if(p != None)
	{
		p.ComboNameList[index] = newComboString;
		p.ComboList[index] = newComboClass;
		if(newComboString != "")
		{
			p.ClientReceiveCombo(newComboString);
		}
	}
}

defaultproperties
{
     bReplicateInstigator=True
     bGameRelevant=True
}
