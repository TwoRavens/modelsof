
global cluster = "t_group"

use DatFJP, clear

global i = 1
global j = 1
foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	mycmd (tookup TookUp_muslim TookUp_Hindu_SC_Kat) ivreg `var' (tookup TookUp_muslim TookUp_Hindu_SC_Kat = Treated Treated_Hindu_SC_Kat Treated_muslim ) Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
	}

