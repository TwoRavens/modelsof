global cluster = "session1"

use DatKN, clear

global i = 1
global j = 1

*Table 2
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		mycmd (award) reg `Y' award `specification' if treatment !=2, cluster(session1)
		}
	}

