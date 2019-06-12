global cluster = "hhea"

use DatABHOT1, clear

global i = 1
global j = 1
*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 


*******************************************

use DatABHOT2, clear

*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 


**************************************

use DatABHOT3a, clear

*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	}


*************************************

use DatABHOT3b, clear

*Table 6
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
		}
	}

*********************************************************************

use DatABHOT3, clear

*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)


***************************

use DatABHOT4, clear

*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)


**************************************

use DatABHOT5, clear
rename random_rankHYB rrankHYB

*Table 8
mycmd (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (rrankHYB HYBRID random_rank) areg MISTARGETDUMMY rrankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (rrankHYB random_rank) areg RTS rrankHYB random_rank, absorb(kecagroup) cluster(hhea)


************************************

use DatABHOT6, clear

*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

***********************************************

use DatABHOT7, clear

*Table 10
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)


**************************************************************************

use DatABHOT8, clear

*Table 10
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)


*****************************************************

use DatABHOT9, clear

*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

