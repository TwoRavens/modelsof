
*randomizing at treatment level - this affects first set of regressions


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
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, cluster(villid) 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, cluster(villid) 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, cluster(villid) 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, cluster(villid) 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, cluster(villid) 
mycmd (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, cluster(villid) 

egen M = max(endors_visit), by(villid)
gen MOrig = M
egen MM = count(villid), by(villid d_visit ins_edu)
*Will use these indices below: M is index of original selection for visit; MM is # of observations in each ins_edu category
bysort villid: gen N = _n
sort N villid
global N = 38
mata Y = st_data((1,$N),"M")
generate Order = _n
generate double U = .
sort villid N
mata YY = st_data(.,("d_visit","ins_edu","d_highreward","endors_LSA","MM"))
sort Order

*Two aspects to the randomization:
*(A) Selection of villages (25 of 38) for endorsement: endors_visit
*(B) Within village treatment - stratified by village (d_visit, ins_edu, d_highreward, endors_LSA)
*In (B), d_visit, ins_edu, d_highreward occur regardless of whether village selected in (A) or not - so, can simply randomize outcomes across the population within the village
*If selected in (A), then .5 of each category of ins_edu endorsed with endors_LSA within each village (conditional on d_visit == 1 of course)
*No pattern whatsoever of endors_LSA with d_highreward
*Note systematic coding issue: when village endorsed (endors_visit = 1) endors_visit set to zero for individuals not visited (d_visit == 0) even though village as a whole has endors_visit == 1.

*Proof:
tab villid endors_LSA if d_visit == 1 & endors_visit == 1 & ins_edu == 0
tab villid endors_LSA if d_visit == 1 & endors_visit == 1 & ins_edu == 1
tab villid endors_LSA if d_visit == 1 & endors_visit == 1 & d_highreward == 0
tab villid endors_LSA if d_visit == 1 & endors_visit == 1 & d_highreward == 1

*Procedure:  All okay for villages that were originally selected for endorsement, simply shuffle outcomes there if randomization selects them again
*For villages not originally selected, if randomization selects village level endorsement will have to randomly allocate 1/2 of each ins_edu category to endors_LSA 

mata ResF = J($reps,6,.); ResD = J($reps,6,.); ResDF = J($reps,6,.); ResB = J($reps,39,.); ResSE = J($reps,39,.)
forvalues c = 1/$reps {
	matrix FF = J(6,3,.)
	matrix BB = J(39,2,.)
	display "`c'"
	set seed `c'
*Randomization of village level treatment
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"M",Y)
	sort villid N
	quietly replace M = M[_n-1] if villid == villid[_n-1] & N > 1
	quietly replace endors_visit = M
*Randomization of within village treatment - components that do not depend upon village level treatment
	sort villid N
	quietly replace U = uniform()
	sort villid U
	mata st_store(.,("d_visit","ins_edu","d_highreward","endors_LSA","MM"),YY)
*Setting values back to zero on villages originally selected but now not selected
	quietly replace endors_LSA = 0 if endors_visit == 0
	sort Order
	quietly replace U = uniform()
	sort villid d_visit ins_edu U
*Setting 1/2 of each ins_edu category to endors_visit == 1 on villages not originally selected - the uniform() part randomizes 50/50 for odd numbered groups
	quietly by villid d_visit ins_edu: replace endors_LSA = 1 if endors_visit == 1 & d_visit == 1 & _n <= floor(.5*MM+uniform()) & MOrig == 0
	quietly replace endors_visit = 0 if d_visit == 0
	
foreach X in DK_basixi wealth_indexi logpce_new_wi { 
	quietly replace `X'Xendors_LSA = `X'*endors_LSA 
	quietly replace `X'Xins_edu = `X'*ins_edu 
	quietly replace `X'Xd_highreward = `X'*d_highreward 
	} 

global i = 1
global j = 1

*Table 5
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit, cluster(villid) 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD38, cluster(villid) 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit VD2-VD26 VD28-VD38 $hhcontrols, cluster(villid) 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiXendors_LSA DK_basixiXins_edu DK_basixiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit DK_basixiX* $hhcontrols VD2-VD26 VD28-VD38, cluster(villid) 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiXendors_LSA wealth_indexiXins_edu wealth_indexiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit wealth_indexiX* $hhcontrols VD2-VD26 VD28-VD38, cluster(villid) 
mycmd1 (d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiXendors_LSA logpce_new_wiXins_edu logpce_new_wiXd_highreward) reg ins_lev d_visit endors_LSA ins_edu d_highreward endors_visit logpce_new_wiX* $hhcontrols VD2-VD26 VD28-VD38, cluster(villid) 

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
save ip\FisherACGTTTV1, replace

***********************************************


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

use ip\FisherACGTTTV1, clear
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
save results\FisherACGTTTV, replace

erase a.dta

