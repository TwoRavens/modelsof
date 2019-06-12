
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************


use DatCGTTTV1, clear

global hhcontrols "DK_basixi wealth_indexi logpce_new_wi riskav1_jul06i norm_exp_rainMay06 lcultirrpcti mean_payouts buy_ins04i ins_otheri bua_newi group_addi sched_ct muslim sexheadi lage_headi lhhsizei d_highedu ins_skilli" 

matrix B = J(105,2,.)
global j = 1

*Table 5
global i = 0
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, robust 

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 5)


***********************************************

use DatCGTTTV2, clear

*Table 6
global i = 0
mycmd (pctdiscountT sewaT vframeT ppayT peerT) reg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT) areg boughtins pctdiscountT sewaT vframeT ppayT peerT surveyed2007, robust cluster(villageno) absorb(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) reg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno)
mycmd (pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount) areg boughtins pctdiscountT sewaT vframeT ppayT peerT vframeXpctdiscount ppayXpctdiscount sewaXpctdiscount peerXpctdiscount surveyXpctdiscount surveyed2007, robust cluster(villageno) absorb(villageno)

quietly suest $M, cluster(villageno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7
global i = 0
mycmd (muslimT hinduT groupT) reg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT) areg boughtins muslimT hinduT groupT surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1, robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="M", robust cluster(villageno) absorb(villageno)
mycmd (muslimT hinduT groupT musgr hingr) reg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno)
mycmd (muslimT hinduT groupT musgr hingr) areg boughtins muslimT hinduT groupT musgr hingr surveyedwave1 if religion_a=="H", robust cluster(villageno) absorb(villageno)

quietly suest $M, cluster(villageno)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

drop _all
svmat double F
svmat double B
save results/SuestCGTTTV, replace






