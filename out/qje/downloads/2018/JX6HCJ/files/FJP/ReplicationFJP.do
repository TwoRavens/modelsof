

********************************************************************************************

*Shortened version of their code to produce the regressions

use Analysis_sample, clear

*Tables 2 & 3 - All okay
foreach j in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	xi: ivreg `j' (tookup TookUp_muslim TookUp_Hindu_SC_Kat = Treated Treated_Hindu_SC_Kat Treated_muslim ) Hindu_SC_Kat muslim i.sewa_center i.t_month i.sampling_phase, cluster(t_group)
	}

*Eliminate xi's for faster execution during 10000 randomizations
tab sewa_center, gen(SEWACENTER)
tab t_month, gen(TMONTH)
tab sampling_phase, gen(SAMPLINGPHASE)
drop SEWACENTER1 TMONTH1 SAMPLINGPHASE1

foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	ivreg `var' (tookup TookUp_muslim TookUp_Hindu_SC_Kat = Treated Treated_Hindu_SC_Kat Treated_muslim ) Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
	}

foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
	}

save DatFJP, replace

