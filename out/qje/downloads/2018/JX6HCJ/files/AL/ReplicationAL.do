
***************************************

*Shortened form of their code, produces identical results
*Only run regressions with treatment effects, not specification checks where they run other years on treatment status in 2001 

*General Preparation

foreach year in 00 01 02 {

use base`year'.dta, clear
gen ah4=m_ahim>=4
foreach i in 0 1 {
	gen b`i'ls=lagscore
	gen b`i'ls25=0 if boy == `i'
	gen b`i'ls50=0 if boy == `i'
	gen b`i'ls75=0 if boy == `i'
	gen b`i'ls100=0 if boy == `i'
	sum lagscore if boy == `i', detail
	replace b`i'ls25 =1 if lagscore<r(p25) & boy == `i'
	replace b`i'ls50 =1 if b`i'ls25==0 & lagscore<r(p50) & boy == `i'
	replace b`i'ls75 =1 if b`i'ls50+b`i'ls25==0 & lagscore<r(p75) & boy == `i'
	replace b`i'ls100=1 if b`i'ls50+b`i'ls25+b`i'ls75==0 & boy == `i'
	gen b`i'top_ls=(b`i'ls75+b`i'ls100==1) if boy == `i'
	gen b`i'bot_ls=(b`i'ls25+b`i'ls50 ==1) if boy == `i'
	gen b`i'top_lsq=(b`i'ls100==1) if boy == `i'
	gen b`i'bot_lsq=(b`i'ls75 ==1) if boy == `i'

	gen b`i'p25=0 if boy == `i'
	gen b`i'p50=0 if boy == `i'
	gen b`i'p75=0 if boy == `i'
	gen b`i'p100=0 if boy == `i'
	logit zakaibag educav educem ah4 ole5 semarab semrel b`i'ls50 b`i'ls75 b`i'ls100 if boy == `i'
	    predict b`i'p if e(sample) == 1
	sum b`i'p, detail
	replace b`i'p25 =1 if b`i'p<r(p25) & boy == `i'
	replace b`i'p50 =1 if b`i'p25==0 & b`i'p<r(p50) & boy == `i'
	replace b`i'p75 =1 if b`i'p50+b`i'p25==0 & b`i'p<r(p75) & boy == `i'
	replace b`i'p100=1 if b`i'p50+b`i'p25+b`i'p75==0 & boy == `i'
	gen b`i'top_p=(b`i'p75+b`i'p100==1) if boy == `i'
	gen b`i'bot_p=(b`i'p25+b`i'p50 ==1) if boy == `i'
	gen b`i'top_pq=(b`i'p100==1) if boy == `i'
	gen b`i'bot_pq=(b`i'p75 ==1) if boy == `i'
	}

gen ls25=0
gen ls50=0
gen ls75=0
gen ls100=0
sum lagscore, detail
replace ls25 =1 if lagscore<r(p25)
replace ls50 =1 if ls25==0 & lagscore<r(p50)
replace ls75 =1 if ls50+ls25==0 & lagscore<r(p75)
replace ls100=1 if ls50+ls25+ls75==0
tab pair, gen(PAIR)

save aaa`year', replace

}

*Preparation for Table A5
use base00.dta, clear
gen ls25=0	
gen ls50=0
gen ls75=0
gen ls100=0
sum lagscore, detail
replace ls25 =1 if lagscore<r(p25)
replace ls50 =1 if ls25==0 & lagscore<r(p50)
replace ls75 =1 if ls50+ls25==0 & lagscore<r(p75)
replace ls100=1 if ls50+ls25+ls75==0
gen top_ls=(ls75+ls100==1)
collapse (mean) zakaibag, by(school_id boy top_ls)
rename zakaibag bagB_00
sort school_id boy top_ls
save base00bagB_00.dta, replace

*Programs to check their calculation of marginal effects for logits so as to compare with published tables
capture program drop checkmfx
program define checkmfx
	capture drop p
	quietly predict double p if e(sample) == 1, xb
	quietly replace p = p - _b[treated] if treated == 1 
	quietly replace p = exp(p)/(1+exp(p))
	quietly replace p = p*(1-p)
	quietly sum p if treated == 1
	local a = r(mean)*_b[treated]
	local b = r(mean)*_se[treated]
	display "`a'" " " "`b'"
	quietly drop p
end

*In some tables the e(sample) was a subset of the dataset, they used the full dataset for the calculation of marginal effects
capture program drop checkmfx2
program define checkmfx2
	capture drop p
	quietly predict double p if year == `1' & boy == `2' & b`2'zak_`3' == 1, xb
	quietly replace p = p - _b[treated] if treated == 1 
	quietly replace p = exp(p)/(1+exp(p))
	quietly replace p = p*(1-p)
	quietly sum p if treated == 1
	local a = r(mean)*_b[treated]
	local b = r(mean)*_se[treated]
	display "`a'" " " "`b'"
	quietly drop p
end

*They adjust coefficient for treated01 (only treated in 01 - which is how entered in regression), but summarize prediction for all treated schools (including in other years) - see Table 7 code
capture program drop checkmfx3
program define checkmfx3
	capture drop p
	quietly predict double p if boy == `1' & b`1'zak_`2' == 1, xb
	quietly replace p = p - _b[treated01] if treated01 == 1 
	quietly replace p = exp(p)/(1+exp(p))
	quietly replace p = p*(1-p)
	sum p if treated == 1
	local a = r(mean)*_b[treated]
	local b = r(mean)*_se[treated]
	display "`a'" " " "`b'"
	quietly drop p
end

*Treatment vector - used appendices to figure out singlet pair (other school closed) that was reclassified in pair 7
use base01, clear
tab school_id if pair == 7 & treated == 1 & semrel == 0
replace pair = 6 if pair == 7 & treated == 1 & semrel == 0
keep school_id pair treated
sort school_id
drop if school_id == school_id[_n-1]
set obs 40
replace pair = 6 if _n == 40
replace treated = 0 if _n == 40
replace school_id = 100 if _n == 40
tab pair treated
sort pair treated
mkmat pair treated school_id, matrix(Y)
global N = 40
keep school_id pair
rename pair Strata
sort school_id
gen N = _n
save Sample1, replace

********************************

*Checking results

use aaa01.dta, clear
 
*Table 2 - All okay

foreach g in 0 1 {
	brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
		checkmfx
	}

brl zakaibag treated semarab semrel, cluster(school_id)
brl zakaibag treated semarab semrel, logit cluster(school_id)
	checkmfx
brl zakaibag treated semarab semrel PAIR2-PAIR19, cluster(school_id)
brl zakaibag treated semarab semrel PAIR2-PAIR19, logit cluster(school_id)
	checkmfx
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
	checkmfx
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, cluster(school_id)
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, logit cluster(school_id)
	checkmfx

*Table 4 - All okay

foreach g in 0 1 {
	brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
		checkmfx
	}

****

*Table 5 - First part - All okay - Checked, and logit cases with singular covariance matrix are identical to do file results (can see these with . for se for some variables)  

use aaa00, clear
append using aaa01
*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_ls bot_ls top_p bot_p {
		quietly egen t1 = min(year) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 1
		quietly replace b`g'`k' = 0 if t2 == 0
		quietly drop t1 t2
		}
	}
quietly replace year = (year == 1)
foreach j in semarab semrel treated {
	replace `j' = `j'*year
	}
tab school_id, gen(S)

foreach g in 0 1 {
	logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
		checkmfx
	}

**************

*Table 5 - Second part - All okay

use aaa01, clear
append using aaa02
*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_ls bot_ls top_p bot_p {
		quietly egen t1 = min(year) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 2
		quietly replace b`g'`k' = 0 if t2 == 1
		quietly drop t1 t2
		}
	}
quietly replace year = (year == 1)
foreach j in semarab semrel treated {
	replace `j' = `j'*year
	}
tab school_id, gen(S)		

foreach g in 0 1 {
	logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
		checkmfx
	}

*************

*Table 5 - Third part - All okay - Again, logit cases with singular covariance matrix are identical to do file results (can see these with . for se for some variables) 

use aaa01, clear
append using aaa00
append using aaa02
foreach y in 0 1 2 {
	quietly gen year`y' = (year == `y')
	}
*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_ls bot_ls top_p bot_p {
		quietly egen t1 = max(year0) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year1) if b`g'`k' == 1, by(school_id)
		quietly egen t3 = max(year2) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 0
		quietly replace b`g'`k' = 0 if t2 == 0
		quietly replace b`g'`k' = 0 if t3 == 0
		quietly drop t1 t2 t3
		}
	}
quietly replace treated = treated*year1
foreach j in semarab semrel {
	gen `j'1 = `j'*year1
	gen `j'2 = `j'*year2
	}
tab school_id, gen(S)		

foreach g in 0 1 {
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S2-S39 if b`g'top_p == 1, robust
		checkmfx
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'top_p == 1, robust
		checkmfx
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S2-S39 if b`g'bot_p == 1, robust
		checkmfx
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'bot_p == 1, robust
		checkmfx
	}


************************

*Table 6 - Top Panel 2001 only (2000 can be considered specification check as in other tables) - All okay

use aaa01, clear

foreach g in 0 1 {
	brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
		checkmfx
	}

*******************

*Table 6 bottom panel

use aaa00, clear
append using aaa01

foreach j in semarab semrel treated {
	replace `j' = `j'*year
	}

*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_lsq bot_lsq top_pq bot_pq {
		quietly egen t1 = min(year) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 1
		quietly replace b`g'`k' = 0 if t2 == 0
		quietly drop t1 t2
		}
	}

tab school_id, gen(S)		

foreach g in 0 1 {
	logit zakaibag treated semarab semrel year S2-S39 if b`g'top_lsq == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'top_lsq == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_lsq == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'bot_lsq == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel year S2-S39 if b`g'top_pq == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'top_pq == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_pq == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'bot_pq == 1, robust
		checkmfx
	}

**********************

*Table 7 - All okay

use aaa00, clear
append using aaa01
foreach g in 0 1 {
	drop if boy == `g' & b`g'ls75 + b`g'ls100 ~= 1 
	egen t1 = min(year) if boy == `g', by(school_id)
	egen t2 = max(year) if boy == `g', by(school_id)
	drop if t1 == 1 & boy == `g'
	drop if t2 == 0 & boy == `g'
	drop t1 t2
	}
foreach n_units of numlist 18(2)24  {
	gen bag_cond_awr`n_units'= zakaibag if awr`n_units'==1
   	gen bag_cond_att`n_units'= zakaibag if att`n_units'==1
	gen awr_cond_att`n_units'= awr`n_units' if att`n_units'==1
	}
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
	   	egen b`g'zak_`outcome'=max(`outcome') if boy == `g', by (school_id)
	  	}
	}

gen year01 = (year == 1)
foreach j in semarab semrel treated {
	gen `j'01 = `j'*year01
	}
tab school_id, gen(S)

foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
			checkmfx3 `g' `outcome'
		}
	}
foreach g in 0 1 {
	foreach year in 0 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
				checkmfx2 `year' `g' `outcome'
			}
		}
	}

***********************

*No stata code for Table 8 (SAS only), same for Table A3
*Table A4 - Logit coefficient results for some specifications in Table 5 - All okay (same exact specification, just logit coefficients instead of marginal effects reported)

*Table A5 - Regressions that are new (not reproducing Table 5) - All okay

use aaa01, clear
foreach j in 0 1 {
	rename b`j'top_ls top_ls
	sort school_id boy top_ls
	merge school_id boy top_ls using base00bagB_00.dta
	tab _m
	drop if _m == 2
	drop _m
	rename top_ls b`j'top_ls
	rename bagB_00 b`j'bagB_00
	}

foreach g in 0 1 {
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
		checkmfx
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
		checkmfx
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
		checkmfx
	}

************************
***********************

*Running regressions that I will use

*Part I - Tables 2 & 4 - 2001 regressions (treatment year only, not specification checks)

use aaa01, clear

*Table 2
local i = 1
foreach g in 0 1 {
	brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
	}

brl zakaibag treated semarab semrel, cluster(school_id)
brl zakaibag treated semarab semrel, logit cluster(school_id)
brl zakaibag treated semarab semrel PAIR2-PAIR19, cluster(school_id)
brl zakaibag treated semarab semrel PAIR2-PAIR19, logit cluster(school_id)
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, cluster(school_id)
brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, logit cluster(school_id)

*Table 4
foreach g in 0 1 {
	brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	}

svmat double Y
drop PAIR1
capture drop S1
save DatAL1, replace

********************************

*Part II:  Table 5 - First part 

use aaa00, clear
append using aaa01
*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_ls bot_ls top_p bot_p {
		quietly egen t1 = min(year) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 1
		quietly replace b`g'`k' = 0 if t2 == 0
		quietly drop t1 t2
		}
	}
quietly replace year = (year == 1)
foreach j in semarab semrel treated {
	replace `j' = `j'*year
	}
tab school_id, gen(S)

foreach g in 0 1 {
	logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

svmat double Y
capture drop S1
save DatAL2, replace

*****************************

*Part III: Table 5, second part

use aaa01, clear
append using aaa02
*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_ls bot_ls top_p bot_p {
		quietly egen t1 = min(year) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 2
		quietly replace b`g'`k' = 0 if t2 == 1
		quietly drop t1 t2
		}
	}
quietly replace year = (year == 1)
foreach j in semarab semrel treated {
	replace `j' = `j'*year
	}
tab school_id, gen(S)		

foreach g in 0 1 {
	logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

svmat double Y
capture drop S1
save DatAL3, replace

*************

*Part IV: Table 5, third part

use aaa01, clear
append using aaa00
append using aaa02
foreach y in 0 1 2 {
	quietly gen year`y' = (year == `y')
	}
*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_ls bot_ls top_p bot_p {
		quietly egen t1 = max(year0) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year1) if b`g'`k' == 1, by(school_id)
		quietly egen t3 = max(year2) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 0
		quietly replace b`g'`k' = 0 if t2 == 0
		quietly replace b`g'`k' = 0 if t3 == 0
		quietly drop t1 t2 t3
		}
	}
quietly replace treated = treated*year1
foreach j in semarab semrel {
	gen `j'1 = `j'*year1
	gen `j'2 = `j'*year2
	}
tab school_id, gen(S)		

local i = 1
foreach g in 0 1 {
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S2-S39 if b`g'top_ls == 1, robust
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'top_ls == 1, robust
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S2-S39 if b`g'bot_ls == 1, robust
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'bot_ls == 1, robust
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S2-S39 if b`g'top_p == 1, robust
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'top_p == 1, robust
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S2-S39 if b`g'bot_p == 1, robust
	logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'bot_p == 1, robust
	}

svmat double Y
capture drop S1
save DatAL4, replace

************************

*Part V:  Table 6 , top panel 2001

use aaa01, clear

foreach g in 0 1 {
	brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	}

svmat double Y
capture drop S1
save DatAL5, replace

*******************

*Part VI:  Table 6, bottom panel

use aaa00, clear
append using aaa01

foreach j in semarab semrel treated {
	replace `j' = `j'*year
	}
*Following their procedure, dropping schools that don't appear in both years in each sample
foreach g in 0 1 {
	foreach k in top_lsq bot_lsq top_pq bot_pq {
		quietly egen t1 = min(year) if b`g'`k' == 1, by(school_id)
		quietly egen t2 = max(year) if b`g'`k' == 1, by(school_id)
		quietly replace b`g'`k' = 0 if t1 == 1
		quietly replace b`g'`k' = 0 if t2 == 0
		quietly drop t1 t2
		}
	}
tab school_id, gen(S)		

foreach g in 0 1 {
	logit zakaibag treated semarab semrel year S2-S39 if b`g'top_lsq == 1, robust
	logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'top_lsq == 1, robust
	logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_lsq == 1, robust
	logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'bot_lsq == 1, robust
	logit zakaibag treated semarab semrel year S2-S39 if b`g'top_pq == 1, robust
	logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'top_pq == 1, robust
	logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_pq == 1, robust
	logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'bot_pq == 1, robust
	}

svmat double Y
capture drop S1
save DatAL6, replace

*************************

*Part 7 - Table 7 - 2001 and 2000/2001 regressions only (not 2000 regressions, following procedure for all such regressions in this paper)

use aaa00, clear
append using aaa01
foreach g in 0 1 {
	drop if boy == `g' & b`g'ls75 + b`g'ls100 ~= 1 
	egen t1 = min(year) if boy == `g', by(school_id)
	egen t2 = max(year) if boy == `g', by(school_id)
	drop if t1 == 1 & boy == `g'
	drop if t2 == 0 & boy == `g'
	drop t1 t2
	}
foreach n_units of numlist 18(2)24  {
	gen bag_cond_awr`n_units'= zakaibag if awr`n_units'==1
   	gen bag_cond_att`n_units'= zakaibag if att`n_units'==1
	gen awr_cond_att`n_units'= awr`n_units' if att`n_units'==1
	}
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
	   	egen b`g'zak_`outcome'=max(`outcome') if boy == `g', by (school_id)
	  	}
	}

gen year01 = (year == 1)
foreach j in semarab semrel treated {
	gen `j'01 = `j'*year01
	}
tab school_id, gen(S)

foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

svmat double Y
capture drop S1
save DatAL7, replace

************

*Part 8:  Table A5 

*Parts that reproduce Table 5

use DatAL2, clear
foreach g in 0 1 {
	logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
		checkmfx
	}

use aaa01, clear
foreach j in 0 1 {
	rename b`j'top_ls top_ls
	sort school_id boy top_ls
	merge school_id boy top_ls using base00bagB_00.dta
	tab _m
	drop if _m == 2
	drop _m
	rename top_ls b`j'top_ls
	rename bagB_00 b`j'bagB_00
	}

foreach g in 0 1 {
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	brl zakaibag b`g'bagB_00 treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

svmat double Y
capture drop S1
save DatAL8, replace
