


capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		if ("`absorb'" == "") quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		if ("`absorb'" ~= "") quietly `anything' if M ~= `i', cluster(`cluster') `robust' absorb(`absorb')
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************


global cluster = "villid"

global i = 1
global j = 1
	
use DatCGTTTV1, clear

global hhcontrols "DK_basixi wealth_indexi logpce_new_wi riskav1_jul06i norm_exp_rainMay06 lcultirrpcti mean_payouts buy_ins04i ins_otheri bua_newi group_addi sched_ct muslim sexheadi lage_headi lhhsizei d_highedu ins_skilli" 

*Table 5
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, robust 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, robust 


		
***********************************************

global cluster = "villageno"

use DatCGTTTV2, clear

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


use ip\JK1, clear
forvalues i = 2/18 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/18 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeACGTTTV, replace


