
use DatFJP, clear

*Table 2
global i = 1
foreach var in taken_new tdeposits {
	reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	estimates store M$i
	global i = $i + 1
	}

suest M1 M2, cluster(t_group)
test Treated Treated_Hindu_SC_Kat Treated_muslim
matrix F = (r(p), r(drop), r(df), r(chi2), 2)


*Table 3
global i = 1
foreach var in Dummy_Client_Income Talk_Fam {
	reg `var' Treated Treated_Hindu_SC_Kat Treated_muslim Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, 
	estimates store M$i
	global i = $i + 1
	}

suest M1 M2, cluster(t_group)
test Treated Treated_Hindu_SC_Kat Treated_muslim
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

drop _all
svmat double F
save results/SuestFJP, replace
