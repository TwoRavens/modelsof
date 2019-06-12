*******************************************************************************
* SUMM STATS (FIRM LEVEL)
*******************************************************************************
*local varlist   = "sales profits pm roa ass numw2 Nowners sales_w2 profit_w2 profit_owner totownerpayment ownerpay_owner ownerpay_w2  ownerpay_profit ownerpay_sales"

*******************************************************************************
* SUMM STATS PROGRAM
*******************************************************************************
capture program drop summ_IRS
program summ_IRS
	set more off
	syntax, samplevar(varname) name(string) varlist(string) [ minobs(integer 10) ]
	 
	
	 
	cd $outdir/summ
	foreach x of varlist `varlist'{
	preserve

	keep if `samplevar'==1
	keep `x'
	keep if !mi(`x') 
	assert _N>`minobs'
	 sort `x'
	 gen `x'_group = int(100*(_n-1)/_N) 
		
			   egen `x'_p10h = mean(`x') if abs(`x'_group - 10) <= 1 
			   egen `x'_p10 = max(`x'_p10h)
			   egen `x'_p50h = mean(`x') if abs(`x'_group - 50) <= 1 
			   egen `x'_p50 = max(`x'_p50h)
			   egen `x'_p90h = mean(`x') if abs(`x'_group - 90) <= 1
			   egen `x'_p90 = max(`x'_p90h)
			   egen `x'_count = count(`x') 

			   estpost tabstat `x', listwise statistics(mean)
			   eststo Mean
			   rename `x' `x'_orig
			   rename `x'_p10 `x'  
			   estpost tabstat `x', listwise statistics(mean)
			   eststo P10
			   rename `x' `x'_p10
			   rename `x'_p50 `x' 
			   estpost tabstat `x', listwise statistics(mean)
			   eststo P50
			   rename `x' `x'_p50
			   rename `x'_p90 `x' 
			   estpost tabstat `x', listwise statistics(mean)
			   eststo P90
			   rename `x' `x'_p90
			   rename `x'_count `x' 
			   estpost tabstat `x', listwise statistics(mean)
			   eststo N	   
			   rename `x' `x'_count
			   rename `x'_orig `x'
			   esttab Mean P10 P50 P90 N using summ_`x'.csv, ///
			   cells(mean(fmt(3)))  replace label unstack nodepvar noobs  nonumber


			   *drop `x'_*
			   restore
	}   


	preserve 
	clear
	foreach var in `varlist'{
	insheet using summ_`var'.csv, clear names 
	drop if _n==1
	tempfile data_`var'
	save `data_`var''
	}

	clear
	foreach var in `varlist'{
	append using `data_`var''

	}
	rename v1 varname
	export delimited stats_`name'.csv, replace
	
	foreach var in `varlist'{
	rm summ_`var'.csv
	}
	restore
    cd $dodir
end


use $dtadir/summstats_bld5_largest_dosage_v6.dta, clear
g fullsample=1
g loser=(winner==0)
g doseQ5 = (doseQ==5)
gen winnerQ5=winner*(doseQ==5)

g fullsample100=(t==0)
g doseQ5100 =  (doseQ==5 & t==0)
g winner100 =  (winner& t==0)
g winnerQ5100 = (winnerQ5 & t==0)
g loserQ5100 = (doseQ==5 & loser==1 & t==0)
g loser100 = (loser& t==0)

g winnerQ5pre = (winnerQ5 & t<=0)
g loserQ5pre  = (doseQ==5 & loser==1 & t<=0)

g fullsamplepre = (t<=0)
g winnerpre = (winner==1 & t<=0)
g loserpre  = (loser==1 & t<=0)
g doseQ5pre = (doseQ==5 & t<=0)
g doseLTQ5pre = (doseQ<5 & t<=0)


gen wage_4p=(wb-wage_ent3*ent3)/(emp-ent3)
**************************
* EXECUTE
**************************
/*
summ_IRS, samplevar(fullsample) name(fullsample) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1  wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(winner) name(winner) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(doseQ5) name(doseQ5) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1  wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(winnerQ5) name(winnerQ5) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(loser) name(loser) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
*/
/*
*PRE
summ_IRS, samplevar(fullsamplepre) name(fullsamplepre) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1  wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(winnerpre) name(winnerpre) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(loserpre) name(loserpre) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(doseQ5pre) name(doseQ5pre) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1  wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(doseLTQ5pre) name(doseLTQ5pre) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")

summ_IRS, samplevar(winnerQ5pre) name(winnerQ5pre) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
summ_IRS, samplevar(loserQ5pre) name(loserQ5pre) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f rat_jani rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp")
*/



*t==0

summ_IRS, samplevar(fullsample100) name(fullsample100) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1  wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f  rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp wage_4p wage_ent3")
summ_IRS, samplevar(winner100) name(winner100) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f  rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp wage_4p wage_ent3")
summ_IRS, samplevar(doseQ5100) name(doseQ5100) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f  rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp wage_4p wage_ent3")
summ_IRS, samplevar(winnerQ5100) name(winnerQ5100) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f  rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp wage_4p wage_ent3")
summ_IRS, samplevar(loserQ5100) name(loserQ5100) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1  wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f  rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp wage_4p wage_ent3")
summ_IRS, samplevar(loser100) name(loser100) varlist("posrev posemp rev va ebitd profits lcomp emp wb s1 wb_emp lcomp_emp rev_emp va_emp profits_emp ebitd_emp s1_emp      emp_cht emp_stay emp_inv emp_noninv emp_m emp_f emp_jani emp_ent emp_contract emp_broad rat_cht rat_stay rat_inv rat_noninv rat_m rat_f  rat_ent rat_contract rat_prior rat_broad dose  sep_rate shr_stay shr_cht shr_inv shr_noninv shr_m shr_f shr_jani shr_ent shr_contract sep_rate_noninv winner tot_inc tot_inc_emp tot_ded tot_ded_emp oinc oinc_emp wage_4p wage_ent3")









