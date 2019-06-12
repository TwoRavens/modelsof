
*randomizing at their level (i.e. treating observations as independent and ignoring fact treatment is applied in village groups) - this affects first set of regressions


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") {
		`anything' `if' `in', `robust' cluster(`cluster')
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, absorb(string) cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") {
		quietly `anything' `if' `in', `robust' cluster(`cluster')
		}
	else {
		quietly `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatCGTTTV1, clear

global hhcontrols "DK_basixi wealth_indexi logpce_new_wi riskav1_jul06i norm_exp_rainMay06 lcultirrpcti mean_payouts buy_ins04i ins_otheri bua_newi group_addi sched_ct muslim sexheadi lage_headi lhhsizei d_highedu ins_skilli" 

matrix F = J(6,4,.)
matrix B = J(39,2,.)

global i = 1
global j = 1

*Table 5
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, robust 

generate Order = _n
generate double U = .
mata Y = st_data(.,("endors_visit","d_visit","ins_edu","d_highreward","endors_LSA"))
sort Order

mata ResF = J($reps,6,.); ResD = J($reps,6,.); ResDF = J($reps,6,.); ResB = J($reps,39,.); ResSE = J($reps,39,.)
forvalues c = 1/$reps {
	matrix FF = J(6,3,.)
	matrix BB = J(39,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort U 
	mata st_store(.,("endors_visit","d_visit","ins_edu","d_highreward","endors_LSA"),Y)
	
foreach X in DK_basixi wealth_indexi logpce_new_wi { 
	quietly replace `X'Xendors_LSA = `X'*endors_LSA 
	quietly replace `X'Xins_edu = `X'*ins_edu 
	quietly replace `X'Xd_highreward = `X'*d_highreward 
	} 

global i = 1
global j = 1

*Table 5
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, robust 

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..6] = FF[.,1]'; ResD[`c',1..6] = FF[.,2]'; ResDF[`c',1..6] = FF[.,3]'
mata ResB[`c',1..39] = BB[.,1]'; ResSE[`c',1..39] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/6 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/39 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherCGTTTV1, replace

***********************************************

use DatCGTTTV2, clear

matrix F = J(12,4,.)
matrix B = J(66,2,.)

global i = 1
global j = 1

*Table 6
mycmd (pctdiscountT sewaT vframeT ppayT peerT) reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT) areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) reg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) areg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno) absorb(villageno)

*Table 7
mycmd (muslimT hinduT groupT) reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT) areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)

egen M1 = group(muslimT hinduT groupT)
egen MM = max(M1), by(villageno)
*Not strictly stratified by village (correspondence with authors), but groups of villages x previously surveyed are strata because treatment was differentiated by these characteristics
egen Strata = group(MM surveyT), missing
tab Strata
generate N = _n
sort Strata N
generate Order = _n
generate double U = .
mata Y = st_data(.,("muslimT","hinduT","groupT","musgr","hingr","pctdiscountT","sewaT","vframeT","ppayT","peerT","vframeXpctdiscount","ppayXpctdiscount","sewaXpctdiscount","peerXpctdiscount","surveyXpctdiscount"))

mata ResF = J($reps,12,.); ResD = J($reps,12,.); ResDF = J($reps,12,.); ResB = J($reps,66,.); ResSE = J($reps,66,.)
forvalues c = 1/$reps {
	matrix FF = J(12,3,.)
	matrix BB = J(66,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Strata U
	mata st_store(.,("muslimT","hinduT","groupT","musgr","hingr","pctdiscountT","sewaT","vframeT","ppayT","peerT","vframeXpctdiscount","ppayXpctdiscount","sewaXpctdiscount","peerXpctdiscount","surveyXpctdiscount"),Y)

global i = 1
global j = 1

*Table 6
mycmd1 (pctdiscountT sewaT vframeT ppayT peerT) reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)
mycmd1 (pctdiscountT sewaT vframeT ppayT peerT) areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)
mycmd1 (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) reg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno)
mycmd1 (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) areg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno) absorb(villageno)

*Table 7
mycmd1 (muslimT hinduT groupT) reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)
mycmd1 (muslimT hinduT groupT) areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd1 (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)
mycmd1 (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd1 (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)
mycmd1 (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)
mycmd1 (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)
mycmd1 (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..12] = FF[.,1]'; ResD[`c',1..12] = FF[.,2]'; ResDF[`c',1..12] = FF[.,3]'
mata ResB[`c',1..66] = BB[.,1]'; ResSE[`c',1..66] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/12 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/66 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherCGTTTV2, replace

*******************************************

use ip\FisherCGTTTV2, clear
mkmat F1-F4 in 1/12, matrix(FF)
mkmat B1-B2 in 1/66, matrix(BB)
drop F1-F4 B1-B2 
sort N
forvalues i = 12(-1)1 {
	local j = `i' + 6
	rename ResF`i' ResF`j'
	rename ResDF`i' ResDF`j'
	rename ResD`i' ResD`j'
	}
forvalues i = 66(-1)1 {
	local j = `i' + 39
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
save a, replace

use ip\FisherCGTTTV1, clear
mkmat F1-F4 in 1/6, matrix(F)
mkmat B1-B2 in 1/39, matrix(B)
matrix F = F \ FF
matrix B = B \ BB
drop F1-F4 B1-B2 
sort N
merge N using a
tab _m
drop _m
sort N
aorder
svmat double F
svmat double B
save results\FisherCGTTTV, replace

erase a.dta


	
