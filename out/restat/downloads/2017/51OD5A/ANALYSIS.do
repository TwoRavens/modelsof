
********************************************************************************
*************************** DIRECTORIES AND SWITCHES ***************************
********************************************************************************

set more off
set matsize 10000

* Specify computer
local comp="davidbyrne10"

* Specify input and output directories
cd "/Users/`comp'/Dropbox/Research/Billcap/Stata/doFiles/ANALYSIS/"
local datdir = "/Users/`comp'/Dropbox/Research/Billcap/Stata/Data/"
local figdir = "/Users/`comp'/Desktop/ReStatFigs/"
local paperdir= "/Users/`comp'/Dropbox/Research/Billcap/Writing_presenting/TellmeSomething/"


**** Switches for sample construction
local makerawdat=0			/* Construct variables from raw dataset */
local makesamp=0			/* Construct sample, variables 			*/

**** Switches for analysis
local sumstats=0			/* Summary statistics 							  */
local bayes=0				/* Bayesian model test from Burks et. al 2013	  */
local hetero=0				/* Baseline heterogeneous treatment effects (TEs) */
local hetero_time=1			/* Time-varying heterogeneous TEs				  */
local nonpara=0				/* Non-parametric tests for hetero TEs			  */
local qte=0					/* Quantile TEs					  				  */
local ranktest=0			/* Rank-preservation assumption tests (appendix)  */
local figures=0				/* Figures										  */

********************************************************************************
************************* RAW DATA, CREATE VARIABLES ***************************
********************************************************************************
if(`makerawdat'==1){

****  LOAD DATA
	* See .do files in the ConstructData folder for construction of 
	* Interval_sample_analysis_robust.dta dataset
	use `datdir'Interval_sample_analysis_robust.dta, clear
	drop _merge
	merge m:1 account_number using `datdir'survey.dta
	drop if _merge ==2
	drop _merge
	gen attrit = (lastobs < td(01jun2013))	 
	save `datdir'raw_data_monthly.dta, replace

	* Updated treatment data from email campaigns data (Charlie)
	use `datdir'data_email_treatment.dta, clear
	sort account_number
	merge m:m account_number using `datdir'raw_data_monthly.dta
	drop if _merge==1	
	drop _merge

	* Treatment indicator
	rename treatment treatment1
	gen treatment2=cond(read_date>=firstemail & firstemail!=.,1,0)
	replace received_date=firstemail if firstemail<received_date | (firstemail!=. & received_date==.)  	
	gen T=(treatment1==1 | treatment2==1)	
	quietly summ read_date if T ==1
	local min_Tdate = r(min)
	sort account_number read_date
	gen temp=read_date if T==1
	by account_number: egen first_treatment_date=min(temp)
	replace first_treatment_date=td(01jun2013) if first_treatment_date==.
	format first_treatment_date %td
	save `datdir'raw_data_monthly.dta, replace

	* Access indicator 
	use `datdir'data_email_panel.dta, clear
	rename date read_date
	sort account_number read_date
	by account_number: gen CumEmailed_2=sum(emails)
	by account_number: gen CumOpened_2=sum(opens)
	by account_number: gen CumClicked_2=sum(clicks)
	keep account_number read_date CumEmailed_2 CumOpened_2 CumClicked_2
	merge m:m account_number read_date using `datdir'raw_data_monthly.dta
	drop if _merge==1
	
	rename CumEmailSent_monthly CumEmailed_1	
	rename CumEmailOpen_monthly CumOpened_1
	rename CumClicked_monthly CumClicked_1
	gen frac_1=CumOpened_1/CumEmailed_1
	gen frac_2=CumOpened_2/CumEmailed_2
	gen frac_1alt=CumClicked_1/CumEmailed_1
	gen frac_2alt=CumClicked_2/CumEmailed_2	
	
	gen A=cond((frac_2>0 & frac_2!=.) | (frac_1>0 & frac_1!=.),1,0)
	gen A2=cond((frac_2alt>0  & frac_2alt!=.) | (frac_1alt>0 & frac_1alt!=.),1,0)
	
	drop accessed_date
	sort account_number read_date
	by account_number: gen temp1=read_date if A==1 & A[_n-1]==0
	by account_number: egen accessed_date=min(temp1)
	by account_number: gen temp2=read_date if A2==1 & A2[_n-1]==0
	by account_number: egen accessed2_date=min(temp2)	
	format accessed_date accessed2_date %td
	drop temp1 temp2 _merge
	
	* Treatment waves
	gen wave1 = (received_date < td(01Mar2013)) 
	gen wave2 = (received_date >= td(01Mar2013)) & (received_date < td(01June2013))
	replace wave2 =1 if received_date==. & firstob <td(01mar2013) & attrit==1
	gen wave3 = (wave1==0) & (wave2==0)	
	sort account_number read_date
	save `datdir'raw_data_monthly.dta, replace
	
	* Months since treatment/access, adoption (for time-varying treatment effects)
	gen read_month=mofd(read_date)
	gen received_month=mofd(received_date)
	gen accessed_month=mofd(accessed_date)
	gen accessed2_month=mofd(accessed2_date)	
	gen month_since_T=read_month-received_month
	gen month_since_A=read_month-accessed_month
	gen month_since_A2=read_month-accessed2_month	
	
	replace month_since_T=-1 if month_since_T<0 | month_since_T==.
	replace month_since_A=-1 if month_since_T==-1 | month_since_A<0 | month_since_A==.
	replace month_since_A2=-1 if month_since_T==-1 | month_since_A2<0 | month_since_A2==.	
	
	forval i=0(1)7{
		gen Tm`i'=cond(month_since_T==`i',1,0)	
		gen Tm`i'_raw=Tm`i'
		gen Am`i'=cond(month_since_A==`i',1,0)	
		gen Am`i'_raw=Am`i'	
		gen A2m`i'=cond(month_since_A2==`i',1,0)	
		gen A2m`i'_raw=A2m`i'			
	}

	* Ex-post experimental phases
	gen phase1 = firstob <= `min_Tdate'
	gen phase2 = firstob <= td(01Mar2013) & phase1==0
	gen phase3 = firstob >  td(01Mar2013) & firstob<.
	gen phase=1 if phase1==1
	replace phase=2 if phase2==1
	replace phase=3 if phase3==1	

	gen postT1 =1 if read_date >= `min_Tdate' & read_date<. & phase1==1
	replace postT1 =0 if postT1 ==.
	
	* post T interactions for those entering in phase 2 or phase 3 or treated in phase 2 
	gen postT2 =1 if read_date >= td(01Mar2013) & read_date<. & (phase2==1 | wave2==1 | wave3==1)
	replace postT2 =0 if postT2 ==.
	
	
	* merge with census at SA1 level (8 accounts not matched)
	merge m:1 account_number using `datdir'CustomerCensusVoteSA1.dta , ///
		keepusing(P_pollingGRN median_HHincome median_age av_age PRented median_rooms PFullTime PBachelor SA1)
	
	keep if _merge==3
	
	* impute missing SA1 data (results robust to all of this)
	local varlist = "P_pollingGRN median_HHincome median_age av_age PRented median_rooms PFullTime PBachelor"
	display "`yvarlist'"
	foreach yvar in `varlist'{
		local xvars=subinstr("`varlist'","`yvar'","",1)
		display "`yvar'"
		display "`xvars'"
		impute `yvar' `xvars', generate(impute_`yvar')
	}
	foreach yvar in `varlist'{
		display "`yvar'"
		replace `yvar'=impute_`yvar' if `yvar'==.
		drop impute_`yvar'
	
	}

	quietly tab read_date, gen(day)
	
	drop day1
	
	gen no_ans = (quantiles_prior==.) | (quantile_hhrooms ==.)

	egen mediangreenvote=median(P_pollingGRN)
	gen green=.
	replace green=1 if P_pollingGRN>mediangreenvote & P_pollingGRN~=.
	replace green=0 if P_pollingGRN<=mediangreenvote


	* large houses (no response ==0)
	egen median_Nrooms = median(home_num_bedrooms) 
	gen large_house = home_num_bedrooms > median_Nrooms & home_num_bedrooms <.
	replace large_house=0 if large_house==.
	
	gen small_house = home_num_bedrooms <= median_Nrooms & home_num_bedrooms <.
	replace small_house=0 if large_house==.
	
	
	* high occupancy i.e. lots of residents (no response ==0)
	egen median_people = median(hh_size)
	gen high_occupancy = (hh_size > median_people) & (hh_size<.)
	replace high_occupancy =0 if high_occupancy ==.
	
	gen low_occupancy = (hh_size <= median_people) & (hh_size<.)
	replace low_occupancy =0 if low_occupancy ==.
	
	* does not have gas appliances, does not have air con (no respond ==0)
	gen no_gasappliances = gas_appliances==0
	gen no_ac = have_ac==0
	
	replace  have_ac=0 if have_ac==.
	replace gas_appliances =0 if gas_appliances==.
	
	drop mediangreenvote median_Nrooms median_people
	
* rescale income and age variables

	replace median_HHincome=median_HHincome/1000
	gen income_green = median_HHincome * (green)

	label variable T "Received information"
	label variable income_green "Income $ \times$ green"
	
* indicator variables for use quantiles
	quietly tab fequantile, gen(use_q)
	
* Number of days with Billcap
	drop _merge
	save `datdir'raw_data_monthly.dta, replace
	
	clear 
	use `datdir'data_frmp_raw.dta
	keep customer_number contract_start_date_dmy
	rename customer_number account_number
	rename contract_start_date_dmy start_date
	gen contract_start_month=mofd(start_date)
	sort account_number
	merge m:m account_number using `datdir'raw_data_monthly.dta
	drop if _merge==1	
	gen Nday=read_date-contract_start_date
	sort account_number read_date
	drop if Nday<0		

	
	sort account_number read_month read_date
	replace contract_start_month=read_month if read_month<contract_start_month
	format read_month %tm
	save `datdir'raw_data_monthly.dta, replace
}


********************************************************************************
************************* MAKE SAMPLE, INTERACTIONS ****************************
********************************************************************************
if(`makesamp'==1){

	* Switch for constructing samples
	local exper=0
	
	* Two samples used in study 
		* 1. Experimental sample (main sample, described in paper) (exper==1)
		* 2. Sample of all survey respondents (exper==0)	

	** Prior Beliefs
	clear
	use `datdir'raw_data_monthly.dta
	keep if read_month>=tm(2012m7) & read_month<=tm(2013m6)

	* Experimental sample, otherwise full sample
	local str="_allresp"
	if(`exper'==1){
		keep if phase1==1
		local str=""
	}
	
	* Update priors, usage quantiles
	drop use_q1 use_q2 use_q3 use_q4 use_q5 fe fequantile quantile_hhrooms
	sort account_number read_date
	save `datdir'sample_monthly`str'.dta, replace

	* Household fixed effects in pre-treatment energy use
	sort read_date account_number
	by read_date: egen mu_ldailykWh=mean(ldailykWh)
	gen demean_ldailykWh=ldailykWh-mu_ldailykWh
	xtset account_number read_date
	xtreg demean_ldailykWh if T==0, fe
	predict fe, u
	sort account_number read_date
	drop if T==1
	by account_number: keep if _n==1
	xtile fequantile=fe, nq(5)
	
	* Within home-size quantile
	gen quantile_hhrooms=.
	forval i=1(1)4{
		xtile quantile_hh`i'=fe if home_num_bedrooms==`i', nq(5)
		tab quantile_hh`i'
		replace quantile_hhrooms=quantile_hh`i' if home_num_bedrooms==`i'
		drop quantile_hh`i'
	}
	keep account_number quantile_hhrooms fequantile
	merge m:m account_number using `datdir'sample_monthly`str'.dta, nogen
	
	* Unconditional usage level quantile
	replace fequantile=2 if fequantile==.
	forval i=1(1)5{
		gen use_q`i'=cond(fequantile==`i',1,0)
	}
	
	gen dif_qs = quantile_hhrooms - quantiles_prior 	
	gen use_above = 0
	replace use_above =1 if dif_qs >0 & dif_qs ~=. /*(dif_qs >0 --> use above prior --> implies underestimate use)*/

	gen use_below =0
	replace use_below =1	 if dif_qs <0 

	gen use_corr =0
	replace use_corr=1 if dif_qs==0	
	
	save `datdir'sample_monthly`str'.dta, replace	
	
	** Aggregation to Monthly Data
	collapse(mean) dailykWh contract_start_month first_treatment_date phase1 phase2 phase3 SA1 ///
					T postT1 postT2 Tm0 Tm1 Tm2 Tm3 Tm4 Tm5 Tm6 Tm7 ///
					A Am0 Am1 Am2 Am3 Am4 Am5 Am6 Am7 ///
					A2 A2m0 A2m1 A2m2 A2m3 A2m4 A2m5 A2m6 A2m7 ///
					use_above use_corr use_below no_ans ///
					use_q1 use_q2 use_q3 use_q4 use_q5 quantile_hhrooms quantiles_prior ///
					green median_HHincome PRented income_green PBachelor PFullTime ///
					have_ac no_ac gas_appliances no_gasappliances large_house small_house high_occupancy low_occupancy ///
					home_num_bedrooms home_num_people owner_type house swimming_pool ///
					P_pollingGRN av_age median_age median_rooms, by(account_number read_month)
	gen Nmonth=1+round(read_month-contract_start_month)
	gen NmonthSq=Nmonth*Nmonth
	gen NmonthCu=Nmonth*Nmonth*Nmonth
	gen NmonthQu=Nmonth*Nmonth*Nmonth*Nmonth
	dummies Nmonth
	drop Nmonth37-Nmonth79
	gen Nqtr=ceil(Nmonth/3)
	gen NqtrSq=Nqtr*Nqtr
	gen NqtrCu=Nqtr*Nqtr*Nqtr
	gen NqtrQu=Nqtr*Nqtr*Nqtr*Nqtr	
	dummies Nqtr
	drop Nqtr25-Nqtr27

	gen ldailykWh=log(dailykWh)
	
	foreach var in  phase1 phase2 phase3 ///
					T postT1 postT2 Tm0 Tm1 Tm2 Tm3 Tm4 Tm5 Tm6 Tm7 ///
					A Am0 Am1 Am2 Am3 Am4 Am5 Am6 Am7 ///
					A2 A2m0 A2m1 A2m2 A2m3 A2m4 A2m5 A2m6 A2m7 ///
					use_above use_corr use_below no_ans ///
					use_q1 use_q2 use_q3 use_q4 use_q5 {
			qui replace `var'=cond(`var'>0 & `var'!=.,1,0)		
	}
	
	* Churn indicator, month dummies, Nmonth dummies
	by account_number: egen last_read_month=max(read_month)
	gen churn=cond(read_month==last_read_month & last_read_month<tm(2013m6),1,0)
	drop if read_month==tm(2013m6)	/* month=641 in June 2013 */
	dummies read_month

	* For tabulating sample counts, priors, quintiles
	sort account_number read_month
	by account_number: gen unq=1 if _n==1
	by account_number: egen temp2=total(T)
	by account_number: gen T_ever=cond(temp2>0,1,0)
	by account_number: egen temp3=total(A)
	by account_number: gen A_ever=cond(temp3>0,1,0)	
	by account_number: egen temp4=total(A2)
	by account_number: gen A2_ever=cond(temp4>0,1,0)	
	drop temp2 temp3 temp4
	
	gen prior=0
	replace prior=1 if use_below==1
	replace prior=-1 if use_above==1
	replace prior=. if no_ans==1
	
	gen use_quintile=1 if use_q1==1
	replace use_quintile=2 if use_q2==1
	replace use_quintile=3 if use_q3==1
	replace use_quintile=4 if use_q4==1
	replace use_quintile=5 if use_q5==1
	
	gen phase=1 if phase1==1
	replace phase=2 if phase2==1
	replace phase=3 if phase3==1
	
	* Pretreatment usage, sample restriction
	by account_number: egen preT_dailykWh=mean(dailykWh) if T==0
	by account_number: replace preT_dailykWh=preT_dailykWh[_n-1] if preT_dailykWh==. & preT_dailykWh[_n-1]!=.
	sort account_number read_month
	
	* Start of sample quarter
	by account_number: egen Nmonth_start=min(Nmonth)
	forval i=1(1)12{
		local q1=1+(`i'-1)*3
		local q2=`i'*3
		gen Nqtr_start`i'=cond(Nmonth_start>=`q1' & Nmonth_start<=`q2',1,0)	
	}
	save `datdir'sample_monthly`str'.dta, replace
	
	* Monthly electricity consumption
	use `datdir'raw_data_monthly.dta
	sort account_number read_month
	collapse(sum) dailykWh, by(account_number read_month)
	rename dailykWh monthlykWh
	merge m:m account_number read_month using `datdir'sample_monthly`str'.dta, nogen
	save `datdir'sample_monthly`str'.dta, replace		
	
	
	** Interactions
	* T and post-treatment period interactions
	order use_above use_corr use_below no_ans ///
		  median_HHincome av_age PFullTime PRented green ///
		  have_ac no_ac gas_appliances no_gasappliances large_house small_house high_occupancy low_occupancy

	foreach var1 in use_above use_corr use_below no_ans{
		foreach var2 in use_q1 use_q2 use_q3 use_q4 use_q5{
			qui gen `var1'__`var2' = `var1'*`var2'
		}
	}

	foreach var1 in T postT1 postT2 Tm0 Tm1 Tm2 Tm3 Tm4 Tm5 Tm6 Tm7 ///
					A Am0 Am1 Am2 Am3 Am4 Am5 Am6 Am7 ///
					A2 A2m0 A2m1 A2m2 A2m3 A2m4 A2m5 A2m6 A2m7{
		foreach var2 in use_above use_corr use_below no_ans ///
					use_q1 use_q2 use_q3 use_q4 use_q5  ///
					median_HHincome av_age PFullTime PRented green ///
					have_ac no_ac gas_appliances no_gasappliances large_house small_house high_occupancy low_occupancy {
			qui gen `var1'__`var2' = `var1'*`var2'
		}
		foreach var3 in use_above use_corr use_below no_ans{
			foreach var4 in use_q1 use_q2 use_q3 use_q4 use_q5{
				qui gen `var1'__`var3'__`var4' = `var1'*`var3'*`var4'
			}
		}
	}

	* Miscellaneous changes
	gen T1=cond(first_treatment_date<td(01dec2012),1,0)
	gen T2=cond(T1==0 & first_treatment_date<td(01apr2013),1,0)
	gen T3=cond(T1==0 & T2==0,1,0)
	gen treat=1 if T1==1
	replace treat=2 if T2==1
	replace treat=3 if T1==0 & T2==0
	
	sort account_number read_month
	by account_number: egen temp=total(churn)
	gen churn_ever=cond(temp>0,1,0)
	
	replace median_HHincome=median_HHincome*1000
	replace PRented=PRented*100
	replace PFullTime=PFullTime*100	
	
	* Save datasets
	sort account_number read_month
	save `datdir'sample_monthly`str'.dta, replace	
}
		
********************************************************************************
**************************** SUMMARY STATISTICS ********************************
********************************************************************************
if(`sumstats'==1){

	local priorvars="use_above use_corr use_below"
	local usevars="use_q1 use_q2 use_q4 use_q5"
	local demogvars="median_HHincome av_age PFullTime PRented green"
	local indvars="have_ac gas_appliances swimming_pool home_num_people home_num_bedrooms house"
	
	
	** Table 1: Average Daily Pre-Treatment Electricity Use (in kWh) by Home
	* Energy Report Treatment Wave
	
	* Mean differences, treatment and control, Jul/Aug/Sep
	use `datdir'sample_monthly.dta, clear
	gen treat_alt=1 if treat==1
	replace treat_alt=23 if treat==2 | treat==3
	sort treat_alt read_month
	collapse (mean) dailykWh, by(treat_alt read_month)
	keep if read_month<tm(2012m10)
	gen dailykWh1=dailykWh if treat_alt==1
	gen dailykWh23=dailykWh if treat_alt==23
	replace dailykWh23=dailykWh23[_n+3] if dailykWh23==.
	drop if dailykWh1==.
	gen diff123=dailykWh1-dailykWh23
	keep read_month dailykWh1 dailykWh23 diff123
	sort read_month
	save `paperdir'Table1_pretreat_use.dta, replace	
	
	* Mean differences, treatment and control, Oct/Nov/Dec/Jan/Feb
	use `datdir'sample_monthly.dta, clear
	gen treat_alt=2 if treat==2
	replace treat_alt=3 if treat==3
	drop if treat_alt==.
	sort treat_alt read_month
	collapse (mean) dailykWh, by(treat_alt read_month)
	keep if read_month>=tm(2012m10) & read_month<=tm(2013m2)
	gen dailykWh2=dailykWh if treat_alt==2
	gen dailykWh3=dailykWh if treat_alt==3
	replace dailykWh3=dailykWh3[_n+5] if dailykWh3==.
	drop if dailykWh2==.
	gen diff23=dailykWh2-dailykWh3
	keep read_month dailykWh2 dailykWh3 diff23
	sort read_month
	merge m:m read_month using `paperdir'Table1_pretreat_use.dta, nogen
	sort read_month
	order read_month dailykWh1 dailykWh23 diff123 dailykWh2 dailykWh3 diff23
	gen stat=1
	sort stat read_month
	save `paperdir'Table1_pretreat_use.dta, replace
	
	* Cluster se's for mean differences, treatment and control
	use `datdir'sample_monthly.dta, clear
	gen treat_alt=1 if treat==1
	replace treat_alt=0 if treat==2 | treat==3
	gen sdvar=.
	gen read_month_temp=.
	local k=1
	forval t=630(1)632{
		reg dailykWh treat_alt if read_month==`t', cluster(SA1)
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace read_month_temp=`t' if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep read_month_temp sdvar
	keep if sdvar!=.
	rename read_month_temp read_month
	rename sdvar diff123
	gen stat=2
	sort stat read_month
	merge m:m stat read_month using `paperdir'Table1_pretreat_use.dta, nogen
	sort stat read_month
	save `paperdir'Table1_pretreat_use.dta, replace
		
	use `datdir'sample_monthly.dta, clear
	gen treat_alt=1 if treat==2
	replace treat_alt=0 if treat==3
	drop if treat==1
	gen sdvar=.
	gen read_month_temp=.
	local k=1
	forval t=633(1)637{
		reg dailykWh treat_alt if read_month==`t', cluster(SA1)
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace read_month_temp=`t' if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep read_month_temp sdvar
	keep if sdvar!=.
	rename read_month_temp read_month
	rename sdvar diff23
	gen stat=2
	sort stat read_month
	merge m:m stat read_month using `paperdir'Table1_pretreat_use.dta, nogen
	sort read_month stat
	gen month=""
	replace month="Jul 2012" if read_month==630 & stat==1
	replace month="Aug 2012" if read_month==631 & stat==1	
	replace month="Sep 2012" if read_month==632 & stat==1	
	replace month="Oct 2012" if read_month==633 & stat==1
	replace month="Nov 2012" if read_month==634 & stat==1
	replace month="Dec 2012" if read_month==635 & stat==1
	replace month="Jan 2013" if read_month==636 & stat==1
	replace month="Feb 2012" if read_month==637 & stat==1
	order month dailykWh1 dailykWh23 diff123 dailykWh2 dailykWh3 diff23
	format dailykWh1 dailykWh23 diff123 dailykWh2 dailykWh3 diff23 %12.2f 
	drop read_month stat
	save `paperdir'Table1_pretreat_use.dta, replace


	** Table 2: Household Characteristcs and Census Block-level Demographics
	* by Home Energy Report Treatment Wave
	forval j=1(1)2{
		use `datdir'sample_monthly.dta, clear
		
		* Sample counts
		tab unq 
		forval k=1(1)3{
			qui sum treat if unq==1 & treat==`k'
			local n`k'=r(N)
		}

		if(`j'==1){
			keep if unq==1 & no_ans==0
			local varlist="`indvars'"
		}
		if(`j'==2){
			keep if unq==1
			local varlist="`demogvars'"
		}
		sort treat
		collapse (mean) `varlist', by(treat)
		xpose, clear varname
		forval i=1(1)3{
			rename v`i' wave`i'
			format wave`i' %12.2f
		}
		gen diff12=wave1-wave2
		gen diff23=wave2-wave3
		gen diff13=wave1-wave3
		format diff12 %12.2f
		format diff23 %12.2f
		format diff13 %12.2f
		order _varname
		drop if _varname=="treat"
		gen stat=1
		gen vartype=`j'
		sort vartype stat _varname
		if(`j'>1){
			merge m:m vartype stat _varname using `paperdir'Table2_balance_obs_exper.dta, nogen 
		}
		sort vartype stat _varname
		save `paperdir'Table2_balance_obs_exper.dta, replace
		
		forval  m=1(1)3{
			use `datdir'sample_monthly.dta, clear
			if(`j'==1){
				keep if unq==1 & no_ans==0
			}
			if(`j'==2){
				keep if unq==1
			}
			gen sdvar=.
			gen _varname=""
			local k=1	
			foreach var in `varlist'{
				if(`m'==1){
					reg `var' T2 if treat==1 | treat==2, cluster(account_number)
				}
				if(`m'==2){
					reg `var' T3 if treat==2 | treat==3, cluster(account_number)
				}
				if(`m'==3){
					reg `var' T3 if treat==1 | treat==3, cluster(account_number)
				}				
				mat temp=e(V)
				svmat temp, names(cov)
				replace cov1=sqrt(cov1)
				replace cov1=. if _n>1
				egen tempsd=mean(cov1)
				replace sdvar=tempsd if _n==`k'
				replace _varname="`var'" if _n==`k'
				local k=`k'+1
				drop cov1 cov2 tempsd

			}
			keep _varname sdvar
			drop if sdvar==.
			if(`m'==1){
				rename sdvar diff12 
			}
			if(`m'==2){
				rename sdvar diff23 
			}
			if(`m'==3){
				rename sdvar diff13 
			}	
			gen vartype=`j'
			gen stat=2
			sort vartype stat _varname
			merge m:m vartype stat _varname using `paperdir'Table2_balance_obs_exper.dta, nogen
			sort vartype stat _varname
			save `paperdir'Table2_balance_obs_exper.dta, replace			
		}
	}
	sort vartype _varname stat
	replace _varname="" if stat==2
	order _varname wave1 wave2 wave3 diff12 diff13 diff23 
	keep _varname wave1 wave2 wave3 diff12 diff13 diff23 
	format diff12 diff23 diff13 %12.2f
	gen t12=diff12/diff12[_n+1] if _varname!=""
	gen t13=diff13/diff13[_n+1] if _varname!=""
	gen t23=diff23/diff23[_n+1] if _varname!=""	
	
	replace _varname="Has gas appliances" if _varname=="gas_appliances"
	replace _varname="Has air conditioning" if _varname=="have_ac"
	replace _varname="Has swimming pool" if _varname=="swimming_pool"	
	replace _varname="Has freestanding house" if _varname=="house"		
	replace _varname="Number of residents" if _varname=="home_num_people"		
	replace _varname="Number of bedrooms" if _varname=="home_num_bedrooms"	
	replace _varname="Full-time employment rate" if _varname=="PFullTime"	
	replace _varname="Proportion of households renting" if _varname=="PRented"	
	replace _varname="Average age" if _varname=="av_age"
	replace _varname="Has above median vote share for Green Party" if _varname=="green"
	replace _varname="Median household income" if _varname=="median_HHincome"
	replace _varname=_varname[_n-1] if _varname==""
	gen varnum=.
	replace varnum=1 if _varname=="Has air conditioning" 
	replace varnum=2 if _varname=="Has gas appliances" 	
	replace varnum=3 if _varname=="Has swimming pool" 	
	replace varnum=4 if _varname=="Has freestanding house" 
	replace varnum=5 if _varname=="Number of residents" 
	replace varnum=6 if _varname=="Number of bedrooms" 
	replace varnum=7 if _varname=="Median household income" 
	replace varnum=8 if _varname=="Average age" 
	replace varnum=9 if _varname=="Full-time employment rate" 
	replace varnum=10 if _varname=="Proportion of households renting" 	
	replace varnum=11 if _varname=="Has above median vote share for Green Party" 
	sort varnum wave1
	replace _varname="" if wave1==.
	drop varnum
	set obs 23
	qui replace _varname="Number of Households" if _n==23
	qui replace wave1=`n1' if _n==23
	qui replace wave2=`n2' if _n==23
	qui replace wave3=`n3' if _n==23
	save `paperdir'Table2_balance.dta, replace		
	rm `paperdir'Table2_balance_obs_exper.dta

	** Table 3: Summary Statistics by Survey Response and Attrition Status
		
	* Survey respondent/non-respondent, observable characteristics
	use `datdir'sample_monthly.dta, clear
	keep if unq==1
	sort no_ans
	collapse (mean) `demogvars', by(no_ans)
	xpose, clear varname
	drop if _varname=="no_ans"	
	rename v1 survey_resp
	rename v2 survey_nonresp
	gen diff=survey_resp-survey_nonresp
	gen stat=1
	sort _varname stat
	save `paperdir'Table3_surveyrep_chars.dta, replace
	
	use `datdir'sample_monthly.dta, clear
	keep if unq==1
	gen sdvar=.
	gen _varname=""
	local k=1	
	foreach var in `demogvars'{
		reg `var' no_ans, cluster(SA1)			
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace _varname="`var'" if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep _varname sdvar
	drop if sdvar==.
	rename sdvar diff	
	gen stat=2
	sort _varname stat
	merge m:m _varname stat using `paperdir'Table3_surveyrep_chars.dta, nogen
	sort _varname stat
	order _varname survey_resp survey_nonresp diff
	save `paperdir'Table3_surveyrep_chars.dta, replace
	
	* Survey respondent/non-respondent, pre-treatment usage Aug, Jul, Sep
	use `datdir'sample_monthly.dta, clear
	sort no_ans read_month
	collapse (mean) dailykWh, by(no_ans read_month)
	keep if read_month<tm(2012m10)
	gen dailykWh_surveynonresp=dailykWh if no_ans==1
	gen dailykWh_surveyresp=dailykWh if no_ans==0
	replace dailykWh_surveynonresp=dailykWh_surveynonresp[_n+3] if dailykWh_surveynonresp==.
	drop if dailykWh_surveyresp==.
	gen diff_surveyresp=dailykWh_surveyresp-dailykWh_surveynonresp
	keep read_month dailykWh_surveyresp dailykWh_surveynonresp diff
	sort read_month
	gen stat=1
	sort read_month stat
	save `paperdir'Table3_survey_pretreat_use.dta, replace	

	use `datdir'sample_monthly.dta, clear
	gen sdvar=.
	gen read_month_temp=.
	local k=1
	forval t=630(1)632{
		reg dailykWh no_ans if read_month==`t', cluster(SA1)
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace read_month_temp=`t' if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep read_month_temp sdvar
	keep if sdvar!=.
	rename read_month_temp read_month
	rename sdvar diff_surveyresp
	gen stat=2
	sort read_month stat
	merge m:m stat read_month using `paperdir'Table3_survey_pretreat_use.dta, nogen
	sort read_month stat
	order read_month dailykWh_surveyresp dailykWh_surveynonresp diff_surveyresp
	format dailykWh_surveyresp dailykWh_surveynonresp diff_surveyresp %12.2f 
	save `paperdir'Table3_survey_pretreat_use.dta, replace	
	
	* Attritors/non-attritors, observable characteristics
	use `datdir'sample_monthly.dta, clear
	keep if unq==1
	gen treat_ever=cond(T1==1 | T2==1,1,0)
	sort churn_ever
	collapse (mean) `demogvars', by(churn_ever)
	xpose, clear varname
	drop if _varname=="churn_ever"	
	rename v1 attritor
	rename v2 non_attritor
	gen diff=attritor-non_attritor
	gen stat=1
	sort _varname stat
	save `paperdir'Table3_attrit_chars.dta, replace
	
	use `datdir'sample_monthly.dta, clear
	keep if unq==1
	gen sdvar=.
	gen _varname=""
	local k=1	
	foreach var in `demogvars'{
		reg `var' churn_ever, cluster(SA1)			
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace _varname="`var'" if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep _varname sdvar
	drop if sdvar==.
	rename sdvar diff	
	gen stat=2
	sort _varname stat
	merge m:m _varname stat using `paperdir'Table3_attrit_chars.dta, nogen
	sort _varname stat
	order _varname attritor non_attritor diff
	save `paperdir'Table3_attrit_chars.dta, replace	
	
	* Attritors/non-attritors, pre-treatment usage Aug, Jul, Sep	
	use `datdir'sample_monthly.dta, clear
	sort churn_ever read_month
	collapse (mean) dailykWh, by(churn_ever read_month)
	keep if read_month<tm(2012m10)
	gen dailykWh_attritor=dailykWh if churn_ever==1
	gen dailykWh_non_attritor=dailykWh if churn_ever==0
	replace dailykWh_attritor=dailykWh_attritor[_n+3] if dailykWh_attritor==.
	drop if dailykWh_non_attritor==.
	gen diff=dailykWh_attritor-dailykWh_non_attritor
	keep read_month dailykWh_attritor dailykWh_non_attritor diff
	sort read_month
	gen stat=1
	sort read_month stat
	save `paperdir'Table3_attrit_pretreat_use.dta, replace	

	use `datdir'sample_monthly.dta, clear
	gen sdvar=.
	gen read_month_temp=.
	local k=1
	forval t=630(1)632{
		reg dailykWh churn_ever if read_month==`t', cluster(SA1)
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace read_month_temp=`t' if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep read_month_temp sdvar
	keep if sdvar!=.
	rename read_month_temp read_month
	rename sdvar diff
	gen stat=2
	sort read_month stat
	merge m:m stat read_month using `paperdir'Table3_attrit_pretreat_use.dta, nogen
	sort read_month stat
	order read_month dailykWh_attritor dailykWh_non_attritor diff
	format dailykWh_attritor dailykWh_non_attritor diff %12.2f 
	save `paperdir'Table3_attrit_pretreat_use.dta, replace		

	* Combine Table 3 for survey respondents and non-respondents and for 
	* attritors and non-attritors
	use `paperdir'Table3_surveyrep_chars, clear
	rename diff diff_survey
	sort _varname stat
	save `paperdir'Table3_survey_attrit.dta, replace
	use `paperdir'Table3_attrit_chars.dta, clear
	rename diff diff_attrit	
	sort _varname stat
	merge m:m _varname stat using `paperdir'Table3_survey_attrit.dta, nogen
	sort _varname stat
	save `paperdir'Table3_survey_attrit.dta, replace
	
	use `paperdir'Table3_survey_pretreat_use, clear
	rename dailykWh_surveyresp survey_resp
	rename dailykWh_surveynonresp survey_nonresp
	rename diff_surveyresp diff_survey
	gen _varname = "Jul 2012" if read_month==630
	replace _varname = "Aug 2012" if read_month==631
	replace _varname = "Sep 2012" if read_month==632	
	drop read_month
	sort _varname stat
	merge m:m _varname stat using `paperdir'Table3_survey_attrit.dta, nogen
	save `paperdir'Table3_survey_attrit.dta, replace

	use `paperdir'Table3_attrit_pretreat_use, clear
	rename dailykWh_attritor attritor
	rename dailykWh_non_attritor non_attritor
	rename diff diff_attrit
	gen _varname = "Jul 2012" if read_month==630
	replace _varname = "Aug 2012" if read_month==631
	replace _varname = "Sep 2012" if read_month==632
	drop read_month
	sort _varname stat
	merge m:m _varname stat using `paperdir'Table3_survey_attrit.dta, nogen
	drop stat
	order _varname
	replace _varname="Full-time employment rate" if _varname=="PFullTime"	
	replace _varname="Proportion of households renting" if _varname=="PRented"	
	replace _varname="Average age" if _varname=="av_age"
	replace _varname="Above median vote share for Green Party" if _varname=="green"
	replace _varname="Median household income" if _varname=="median_HHincome"
	gen t_attrit=diff_attrit/diff_attrit[_n+1] if attritor!=.
	gen t_survey=diff_survey/diff_survey[_n+1] if survey_resp!=.	
	replace _varname="" if attritor==.
	order _varname survey_resp survey_nonresp diff_survey attritor non_attritor diff_attrit t_survey t_attrit
	save `paperdir'Table3_survey_attrit.dta, replace
	
	rm `paperdir'Table3_surveyrep_chars.dta
	rm `paperdir'Table3_attrit_chars.dta
	rm `paperdir'Table3_survey_pretreat_use.dta
	rm `paperdir'Table3_attrit_pretreat_use.dta
	

	** Table 4: Joint Distribution of Prior Beliefs and Actual Energy Use
	forval j=1(1)2{
		if(`j'==1){
			/* Experimental sample of survey respondents */
			use `datdir'sample_monthly.dta, clear	
		}
		else{
			/* Full sample of survey respondents */
			/* (includes survey respondents who flow in/out of sample) */
			use `datdir'sample_monthly_allresp.dta, clear	
		}
		sort account_number read_month
		by account_number: keep if _n==1 & quantiles_prior!=.
		tab  quantiles_prior quantile_hhrooms 
		
		sum quantile_hhrooms
		local nobs=r(N)
		forval i=1(1)5{
			gen q`i'=cond(quantile_hhrooms==`i',1,0)
		}
		sort quantiles_prior
		collapse(sum) q1 q2 q3 q4 q5, by(quantiles_prior)
		
		set obs 6	
		forval i=1(1)5{
			replace q`i'=100*q`i'/`nobs'
			egen tmp=total(q`i')	
			replace q`i'=tmp in 6	
			drop tmp
		}
		replace quantiles_prior=6 if quantiles_prior==.
		gen tot=q1+q2+q3+q4+q5
		format q1 q2 q3 q4 q5 tot %12.2f
		xpose, clear
		drop if _n==1
		gen col="1-20%" if _n==1
		replace col="20-40%" if _n==2
		replace col="40-60%" if _n==3
		replace col="60-80%" if _n==4
		replace col="80-100%" if _n==5
		replace col="Total" if _n==6
		order col
		format v1 v2 v3 v4 v5 v6 %12.2f
		gen num=_n
		gen panel=`j'
		sort panel num
		if(`j'>1){
			merge m:m panel num using `paperdir'Table4_priors.dta, nogen
		}
		
		save `paperdir'Table4_priors.dta, replace
	}
	drop panel num
	rename v1 v1_20
	rename v2 v20_40
	rename v3 v40_60
	rename v4 v60_80
	rename v5 v80_v100
	rename v6 Total
	save `paperdir'Table4_priors.dta, replace

	
	** Table A.1: Pre-Treatment Monthly Electricity Use: Survey Respondents and Non-Respondents
	use `datdir'sample_monthly.dta, clear
	sort no_ans read_month
	collapse (mean) monthlykWh, by(no_ans read_month)
	keep if read_month<tm(2012m10)
	gen monthlykWh_surveynonresp=monthlykWh if no_ans==1
	gen monthlykWh_surveyresp=monthlykWh if no_ans==0
	replace monthlykWh_surveynonresp=monthlykWh_surveynonresp[_n+3] if monthlykWh_surveynonresp==.
	drop if monthlykWh_surveyresp==.
	gen diff_surveyresp=monthlykWh_surveyresp-monthlykWh_surveynonresp
	keep read_month monthlykWh_surveyresp monthlykWh_surveynonresp diff
	sort read_month
	gen stat=1
	sort read_month stat
	save `paperdir'App_Table1_survey_pretreat_use.dta, replace	

	use `datdir'sample_monthly.dta, clear
	gen sdvar=.
	gen read_month_temp=.
	local k=1
	forval t=630(1)632{
		reg monthlykWh no_ans if read_month==`t', cluster(account_number)
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace read_month_temp=`t' if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep read_month_temp sdvar
	keep if sdvar!=.
	rename read_month_temp read_month
	rename sdvar diff_surveyresp
	gen stat=2
	sort read_month stat
	merge m:m stat read_month using `paperdir'App_Table1_survey_pretreat_use.dta, nogen
	sort read_month stat
	order read_month monthlykWh_surveyresp monthlykWh_surveynonresp diff_surveyresp
	format monthlykWh_surveyresp monthlykWh_surveynonresp diff_surveyresp %12.2f 
	gen _varname="Jul 2012" if read_month==630 & stat==1
	replace _varname="Aug 2012" if read_month==631 & stat==1
	replace _varname="Sep 2012" if read_month==632 & stat==1
	order _varname
	drop read_month stat
	save `paperdir'App_Table1_survey_pretreat_use.dta, replace	
	
	* Table A.2: Summary Statistics by Survey Response: Full Sample of Respondents and Non-Respondents
	use `datdir'sample_monthly_allresp.dta, clear
	keep if unq==1
	sort no_ans
	collapse (mean) `demogvars', by(no_ans)
	xpose, clear varname
	drop if _varname=="no_ans"	
	rename v1 survey_resp
	rename v2 survey_nonresp
	gen diff=survey_resp-survey_nonresp
	gen stat=1
	sort _varname stat
	save `paperdir'App_Table2_survey_chars.dta, replace
	
	use `datdir'sample_monthly_allresp.dta, clear
	keep if unq==1
	gen sdvar=.
	gen _varname=""
	local k=1	
	foreach var in `demogvars'{
		reg `var' no_ans, cluster(SA1)			
		mat temp=e(V)
		svmat temp, names(cov)
		replace cov1=sqrt(cov1)
		replace cov1=. if _n>1
		egen tempsd=mean(cov1)
		replace sdvar=tempsd if _n==`k'
		replace _varname="`var'" if _n==`k'
		local k=`k'+1
		drop cov1 cov2 tempsd
	}
	keep _varname sdvar
	drop if sdvar==.
	rename sdvar diff	
	gen stat=2
	sort _varname stat
	merge m:m _varname stat using `paperdir'App_Table2_survey_chars.dta, nogen
	sort _varname stat
	order _varname survey_resp survey_nonresp diff
	replace _varname="Full-time employment rate" if _varname=="PFullTime"	
	replace _varname="Proportion of households renting" if _varname=="PRented"	
	replace _varname="Average age" if _varname=="av_age"
	replace _varname="Above median vote share for Green Party" if _varname=="green"
	replace _varname="Median household income" if _varname=="median_HHincome"	
	replace _varname="" if stat==2
	format survey_resp survey_nonresp diff %12.2f
	drop stat
	save `paperdir'App_Table3_survey_chars.dta, replace	
	
	
}	
********************************************************************************
**************************** TEST OF BAYESIAN MODEL ****************************
********************************************************************************
if(`bayes'==1){
	
	* Table 5, panel a
	use `datdir'sample_monthly_allresp.dta, clear
	keep if unq==1 & no_ans==0
	tab quantiles_prior quantile_hhrooms
	forval i=1(1)5{
		gen q`i'=cond(quantile_hhrooms==`i',1,0)
	}
	sort quantiles_prior
	collapse (sum) q1 q2 q3 q4 q5, by(quantiles_prior)
	gen s=q1+q2+q3+q4+q5
	set obs 6
	foreach var1 in q1 q2 q3 q4 q5{
		replace `var1'=`var1'[1]+`var1'[2]+`var1'[3]+`var1'[4]+`var1'[5] in 6
		forval i=1(1)5{
			replace `var1'=`var1'[`i']/q1[6] in `i'
		}
	}
	keep q1-q5
	keep if _n<=5
	xpose, clear
	foreach var1 in v1 v2 v3 v4 v5{
		replace `var1'=`var1'*100
	}
	format v1 v2 v3 v4 v5 %12.2f
	rename v1 v1_20
	rename v2 v20_40
	rename v3 v40_60
	rename v4 v60_80
	rename v5 v80_100
	gen num=_n
	gen panel=1
	sort panel num
	save `paperdir'Table5_bayes.dta, replace
	
	
	* Table 5, panel b
	* Constrained ML estimator for Bayesian Model allocation function is 
	* obtained using the .m files in the /Analysis/Bayes folder, see
	* 'Test_From_ML_Electricity_full.m', 'ML_Electricity_full.m' and 'fun.m'
	* with results file 'ML_Electricity_full.text'
	cd Bayes
	insheet using ML_Electricity_full.csv, clear
	foreach var1 in v1 v2 v3 v4 v5{
		replace `var1'=`var1'*100
	}
	format v1 v2 v3 v4 v5 %12.2f
	rename v1 v1_20
	rename v2 v20_40
	rename v3 v40_60
	rename v4 v60_80
	rename v5 v80_100
	gen num=_n
	gen panel=2
	
	* Combine Table 5 panels and b, save Table 5
	sort panel num
	merge m:m panel num using `paperdir'Table5_bayes.dta, nogen
	sort panel num
	gen actual="1-20%" if num==1
	replace actual="20-40%" if num==2
	replace actual="40-60%" if num==3
	replace actual="60-80%" if num==4
	replace actual="80-100%" if num==5
	order actual
	drop num
	save `paperdir'Table5_bayes.dta, replace
	
	
}
********************************************************************************
********************** HETEROGENEOUS TREATMENT EFFECTS *************************
********************************************************************************
if(`hetero'==1){		
	eststo clear
	set matsize 1000
	local demogvars="median_HHincome av_age PFullTime PRented green"

	* Table 7: Treatement Effects of Home Energy Reports on Energy Use by 
	* Informedness, Baseline Energy Use and Demographics
	
	* Table A.4: IV Estimates of Local Average Treatment Effects (LATE) of Home
	* Energy Reports on Energy Use by Informedness, Baseline Energy Use, and 
	* Demographics
	
	* Table A.5: To construct this table, re-run the code belo exactly, except in
	* the file "Hetero_pool.do" remove "[pweight=ipw]" in all of the regressions
	
	* Get original pooled heterogeneous treatment effects estimates
	use `datdir'sample_monthly.dta, clear
	do "Hetero_pool.do"
	gen boot=0
	sort boot param
	save `datdir'sample_monthly_pool.dta, replace

	* Bootstrap samples and estimates 
	local B=500
	set seed 291213
	local Ncluster=2423 
	forval b=1(1)`B'{
		display `b'
		use `datdir'sample_monthly.dta, clear
		bsample `Ncluster', cluster(account_number)	
		qui do "Hetero_pool.do"
		gen boot=`b'
		sort boot param
		qui merge m:m boot param using `datdir'sample_monthly_pool.dta, nogen
		sort boot param 
		qui save `datdir'sample_monthly_pool.dta, replace
	}

	* Table 7 with bootstrap confidence intervals
	keep if boot==0
	gen stat=1
	drop boot
	sort param stat
	qui save `datdir'sample_monthly_pool_Table7.dta, replace
	
	* Cluster bootstrap percentile confidence intervals
	use `datdir'sample_monthly_pool.dta, clear
	drop if boot==0
	sort param boot
	collapse(mean) est11 est21 est31 est41 est51 est61 est71, by(param) 
	foreach var in est11 est21 est31 est41 est51 est61 est71{
		rename `var' `var'_mu
	}
	sort param
	qui save `datdir'sample_monthly_pool_Table7_tmp.dta, replace
	use `datdir'sample_monthly_pool.dta, clear
	drop if boot==0
	merge m:m param using `datdir'sample_monthly_pool_Table7_tmp.dta
	sort param boot
	foreach var in est11 est21 est31 est41 est51 est61 est71{
		gen `var'_diff=(`var'-`var'_mu)^2
	}
	
	collapse(sum) est11_diff est21_diff est31_diff est41_diff est51_diff est61_diff est71_diff, by(param)
	foreach var in est11 est21 est31 est41 est51 est61 est71{
		gen `var'=sqrt(`var'_diff/(`B'-1))
	}
	keep param est11 est21 est31 est41 est51 est61 est71
	gen stat=2
	sort param stat
	merge m:m param stat using `datdir'sample_monthly_pool_Table7.dta
	sort param stat
	foreach var in est11 est21 est31 est41 est51 est61 est71{
		replace `var'=. if `var'==0
		format `var' %12.2f
	}
	
	* Construct variable names
	gen varname="Treatment" if param==1 & stat==1
	replace var="(Underestimate relative energy use)" if param==2 & stat==1
	replace var="(Correct about relative energy use)" if param==3 & stat==1
	replace var="(Overestimate relative energy use)" if param==4 & stat==1
	replace var="(Low energy use: 1st quintile)" if param==5 & stat==1
	replace var="(Below avg energy use: 2nd quintile)" if param==6 & stat==1
	replace var="(Above avg energy use: 4th quintile)" if param==7 & stat==1
	replace var="(High energy use: 5th quintile)" if param==8 & stat==1
	replace var="(High income)" if param==9 & stat==1
	replace var="(High age)" if param==10 & stat==1
	replace var="(High employment rate)" if param==11 & stat==1
	replace var="(High home rental rate)" if param==12 & stat==1
	replace var="(High Green Party support)" if param==13 & stat==1
	order varname
	drop param stat _merge
	save `datdir'sample_monthly_pool_Table7.dta, replace
	
	* Table 7
	drop est61 est71
	save `paperdir'Table7_hetero.dta, replace
	
	* Table A.5 
	* code for saving table if [pweight=ipw] is removed from Hetero_pool.do
	*drop est61 est71
	*save `paperdir'App_Table5_hetero_noIPW.dta, replace
	
	* Table A.4
	use `datdir'sample_monthly_pool_Table7.dta, clear
	keep varname est61 est71
	save `paperdir'App_Table4_hetero_LATE.dta, replace
	
	rm `datdir'sample_monthly_pool_Table7.dta
	rm `datdir'sample_monthly_pool_Table7_tmp.dta
	
}



********************************************************************************
******************TIME VARYING HETEROGENEOUS TREATMENT EFFECTS *****************
********************************************************************************
if(`hetero_time'==1){		

	* Estimate
	use `datdir'sample_monthly.dta, clear
	do "Hetero_time_est.do"
	gen boot=0
	sort boot parmnum parmseq
	save `datdir'sample_monthly_time.dta, replace

	* Number of clusters, bootstraps
	* Boostrap sampling and estimates
	local Ncluster=2423
	local B=250
	set seed 291213
	display "Bootstrap Counter"
	forval b=1(1)`B'{
		display `b'
		use `datdir'sample_monthly.dta, clear
		bsample `Ncluster', cluster(account_number)		
		qui do "Hetero_time_est.do"
		keep parmseq parm parmnum estimate stderr period min95 max95
		gen boot=`b'
		sort boot parmnum parmseq
		qui merge m:m boot parmnum parmseq using `datdir'sample_monthly_time.dta, nogen
		sort boot parmseq
		qui save `datdir'sample_monthly_time.dta, replace	
	}
	
	* Save sample estimates
	keep if boot==0
	drop boot
	sort parmnum parmseq
	qui save `datdir'sample_monthly_time_fig.dta, replace
	keep parmnum parmseq estimate stderr
	rename estimate estimate_main
	rename stderr stderr_main
	qui save `datdir'sample_monthly_time_fig_tmp.dta, replace
		
	* Compute bootstrap-t confidence intervals
	use `datdir'sample_monthly_time.dta
	drop if boot==0
	sort parmnum parmseq boot
	merge m:m parmnum parmseq using `datdir'sample_monthly_time_fig_tmp.dta, nogen
	sort boot parmnum parmseq
	gen t_boot=(estimate-estimate_main)/stderr
	gen t_max=.
	gen t_min=.
	forval i=1(1)8{
		forval j=1(1)10{
			qui sum t_boot if parmnum==`i' & parmseq==`j', detail
			qui replace t_max=r(p95) if parmnum==`i' & parmseq==`j'
			qui replace t_min=r(p5) if parmnum==`i' & parmseq==`j'
		}
	}
	sort parmnum parmseq t_boot
	by parmnum parmseq: keep if _n==1
	keep parmnum parmseq t_max t_min
	merge m:m parmnum parmseq using `datdir'sample_monthly_time_fig.dta, nogen
	gen min=estimate+t_min*stderr
	gen max=estimate+t_max*stderr
	save `datdir'sample_monthly_time_fig.dta, replace
	rm `datdir'sample_monthly_time_fig_tmp.dta
	rm `datdir'sample_monthly_time2.dta
	
	* Figure 6: Time Varying Treatment Effects by Informedness
	local yrange="-30 -20 -10 0 10 20 30"
	local xrange="-2 -1 0 1 2 3 4 5 6 7"		
	twoway	(scatter estimate period if parmnum==5, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==5, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==5, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==5, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(off)
	graph export "`paperdir'Fig6_hetero_time_use_above.pdf", replace as(pdf)	
	
	twoway	(scatter estimate period if parmnum==6, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==6, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==6, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==6, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(off)
	graph export "`paperdir'Fig6_hetero_time_use_corr.pdf", replace as(pdf)						 
	
	local yrange="-30 -20 -10 0 10 20 30"
	local xrange="-2 -1 0 1 2 3 4 5 6 7"
	twoway	(scatter estimate period if parmnum==7, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==7, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==7, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==7, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(5) order(1 2) label(1 "Treatment Effect") label(2 "95% CI"))							 
	graph export "`paperdir'Fig6_hetero_time_use_below.pdf", replace as(pdf)	
	
	twoway	(scatter estimate period if parmnum==8, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==8, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==8, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==8, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(off)
	graph export "`paperdir'Fig6_hetero_time_no_ans.pdf", replace as(pdf)	
	
	
	* Figure 7: Time Varying Treatment Effects by Level of Energy Use
		local yrange="-30 -20 -10 0 10 20 30"
	local xrange="-2 -1 0 1 2 3 4 5 6 7"	
	twoway	(scatter estimate period if parmnum==1, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==1, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==1, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==1, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(5) order(1 2) label(1 "Treatment Effect") label(2 "95% CI"))
	graph export "`paperdir'Fig7_hetero_time_use_q1.pdf", replace as(pdf)					
	
	twoway	(scatter estimate period if parmnum==2, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==2, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(off)
	graph export "`paperdir'Fig7_hetero_time_use_q2.pdf", replace as(pdf)	
	
	twoway	(scatter estimate period if parmnum==3, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==3, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==3, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==3, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(off)
	graph export "`paperdir'Fig7_hetero_time_use_q4.pdf", replace as(pdf)		
	
	twoway	(scatter estimate period if parmnum==4, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if parmnum==4, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(scatter max period if parmnum==4, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(thin)) || ///
			(line zero period if parmnum==4, lcolor(black)), ///
			ytitle("Treatment Effect (% Change in Energy Use)") xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(off)
	graph export "`paperdir'Fig7_hetero_time_use_q5.pdf", replace as(pdf)						

	rm `datdir'sample_monthly_time_fig.dta
	
	
	

}


********************************************************************************
*************NON-PARAMETRIC TESTS FOR TREATMENT EFFECT HETEROGENEITY ***********
********************************************************************************
if(`nonpara'==1){		
	local priorvars="use_above use_corr use_below"
	local usevars="use_q1 use_q2 use_q4 use_q5"
	local demogvars="green median_HHincome PRented income_green PBachelor"
	local indvars="have_ac gas_appliances large_house high_occupancy"
	local allvars="`priorvars' `usevars' `demogvars'"
	
	use `datdir'sample_monthly.dta, clear
	qui gen stat1=.
	qui gen df1=.
	qui gen pval1=.
	qui gen stat2=.
	qui gen pval2=.			
	save `datdir'tempdat1.dta, replace	

	forval t=634(1)640{
				
		use `datdir'tempdat1.dta, clear
		
		keep if read_month==`t'
		if(`t'<638){
			local m=1
		}
		if(`t'>=638){
			drop if T1==1
			local m=2
		}
		display "**********************************************************************"
		display "****************************READ MONTH `t'****************************"
		display "**********************************************************************"
		display " " 
		display "****************************************************"
		display "**************METHOD ONE: ALL COVARIATES************"
		display "****************************************************"
		
		test_condate dailykWh `allvars', tvar(T`m')
		matrix temp= r(Qtests)
		replace stat1=temp[1,1] in 1
		matrix temp=r(dfQtests)
		qui replace df1=temp[1,1] in 1
		matrix temp=r(pQtests)
		qui replace pval1=temp[1,1] in 1
		matrix temp=r(Ttests)
		qui replace stat2=temp[1,1] in 1
		matrix temp=r(pTtests)
		qui replace pval2=temp[1,1] in 1				
		save `datdir'tempdat2.dta, replace

		reg dailykWh `allvars', cluster(account_number)
		
		display " " 
		display "****************************************************"
		display "***********METHOD TWO: TOP DOWN COVARIATES**********"
		display "****************************************************"
		local j=1
		local nvar=17
		local currvars="`allvars'"
		while(`j'<=`nvar'){
			clear
			use `datdir'tempdat2.dta		
			qui parmby "reg dailykWh `currvars', cluster(account_number)", label norestore
			qui drop if parm=="_cons"
			gen abs_t=abs(t)
			egen min_t=min(abs_t)			
			if(min_t<2){				
				qui drop if abs_t==min_t
				local nvar=_N
				forval k=1(1)`nvar'{
					local var1=parm[`k']
					if(`k'==1){
						local currvars="`var1'"
					}
					else{
						local currvars="`currvars' `var1'" 
					}
				}
			}
			else{
				local j=`nvar'
			}
			local j=`j'+1
		}
		
		clear
		use `datdir'tempdat2.dta, replace
		test_condate dailykWh `currvars', tvar(T`m')
		matrix temp= r(Qtests)
		replace stat1=temp[1,1] in 2
		matrix temp=r(dfQtests)
		qui replace df1=temp[1,1] in 2
		matrix temp=r(pQtests)
		qui replace pval1=temp[1,1] in 2
		matrix temp=r(Ttests)
		qui replace stat2=temp[1,1] in 2
		matrix temp=r(pTtests)
		qui replace pval2=temp[1,1] in 2	
		save `datdir'tempdat2.dta, replace
		reg dailykWh `currvars', cluster(account_number)
		
		
		display " " 
		display "****************************************************"
		display "***********METHOD THREE: BOTTOM UP COVARIATES*******"
		display "****************************************************"
		local k=1
		local j=1
		local nvar=17
		local allvars="`priorvars' `usevars' `demogvars' `indvars'"
		local currvars=""
		while(`k'<`nvar'){
			*display "`k'"
			foreach var1 in `allvars'{
				clear
				use `datdir'tempdat2.dta, replace		
				qui parmby "reg dailykWh `currvars' `var1', cluster(account_number)", label norestore
				qui keep if parm=="`var1'"
				local curr_t=abs(t)
				if(`j'==1){
					local max_t=`curr_t'
					local maxvar="`var1'"		
				}
				if(`j'>1 & `curr_t'>`max_t'){
					local max_t=`curr_t'
					local maxvar="`var1'"
				}
				local j=`j'+1
			}
			if(`max_t'<2){
				local k=17
			}
			else{
				local allvars=subinstr("`allvars'"," `maxvar'","",1)
				local currvars="`currvars' `maxvar'"
				local k=`k'+1
				local j=1
			}
		}
		
		clear
		use `datdir'tempdat2.dta, replace
		test_condate dailykWh `currvars', tvar(T`m')
		matrix temp= r(Qtests)
		replace stat1=temp[1,1] in 3
		matrix temp=r(dfQtests)
		qui replace df1=temp[1,1] in 3
		matrix temp=r(pQtests)
		qui replace pval1=temp[1,1] in 3
		matrix temp=r(Ttests)
		qui replace stat2=temp[1,1] in 3
		matrix temp=r(pTtests)
		qui replace pval2=temp[1,1] in 3	
		
		reg dailykWh `currvars', cluster(account_number) 
		keep stat1 df1 pval1 stat2 pval2
		drop if stat1==.
		gen read_month=`t'
		gen cov_sel=_n
		sort read_month cov_sel
		if(`t'>634){
			merge m:m read_month cov_sel using `paperdir'Table6_nonpara.dta, nogen
		}
		save `paperdir'Table6_nonpara.dta, replace				
	}
	sort read_month cov_sel
	gen period="Nov 2012" if cov_sel==2 & read_month==634
	replace period="Dec 2012" if cov_sel==2 & read_month==635
	replace period="Jan 2013" if cov_sel==2 & read_month==636
	replace period="Feb 2013" if cov_sel==2 & read_month==637
	replace period="Mar 2013" if cov_sel==2 & read_month==638
	replace period="Apr 2013" if cov_sel==2 & read_month==639
	replace period="May 2013" if cov_sel==2 & read_month==640
	gen sel="AC" if cov_sel==1
	replace sel="TD" if cov_sel==2
	replace sel="BU" if cov_sel==3
	format stat1 pval1 stat2 pval2 %12.2f
	order period sel stat1 df1 pval1 stat2 pval2	
	save `paperdir'Table6_nonpara.dta, replace	
	rm `datdir'tempdat1.dta
	rm `datdir'tempdat2.dta
	
}
	

********************************************************************************
************************* QUANTILE TREATMENT EFFECTS ***************************
********************************************************************************
if(`qte'==1){
	* Obtain QTE estimates
	use `datdir'sample_monthly.dta, clear
	do "Qte.do"
	gen boot=0
	sort boot q
	save `datdir'qte.dta, replace
	
	* Create B bootstrap samples and get qte estimates
	local B=500
	local Ncluster=2423
	set seed 291213
	forval b=1(1)`B'{
		* Get the bootstrap QTE estimates, clustering at HH level
		display `b'
		use `datdir'sample_monthly.dta, clear
		bsample `Ncluster', cluster(account_number)
		qui do "Qte.do"
		gen boot=`b'
		sort boot q
		qui merge m:m boot q using `datdir'qte.dta, nogen
		sort boot q
		qui save `datdir'qte.dta, replace
	}
	
	* Cluster bootstrap percentile confidence intervals
	gen tmp1=1 if boot==1
	egen tmp2=total(tmp1)
	gen min95=.
	gen max95=.
	gen sd=.
	local Npts=tmp2
	forval i=1(1)`Npts'{
		gen tmp3=q if _n==`i'
		egen tmp4=mean(tmp3)
		sum estimate if q==tmp4, detail
		replace min95=r(p5) if _n==`i'
		replace max95=r(p95) if _n==`i'
		replace sd=r(sd) if _n==`i'
		drop tmp3 tmp4
	}
	* Figure
	twoway line estimate q if boot==0, connect(stairstep) lpattern(solid) lwidth(medthick) lcolor(gs0) || ///
		   line max95 q if boot==0, connect(stairstep) lpattern(solid) lwidth(thin) lcolor(gs0) || ///
		   line min95 q if boot==0, connect(stairstep) lpattern(solid) lwidth(thin) lcolor(gs0) ///
		   xlabel(0(0.1)1) yline(0) ///
		   xtitle("Quantile of Energy Use Distribution") ytitle("Treatment Effect (% Change in Energy Use)") ///
		   legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(7) order(1 2) label(1 "QTE") label(2 "90% CI"))							 
	graph export "`paperdir'Fig5_qte.pdf", replace as(pdf)

	
}
********************************************************************************
********************* TESTING RANK PRESERVATION ASSUMPTION *********************
********************************************************************************
if(`ranktest'==1){

	* Table A.3: Treatment and Control Differences at Quantiles of the Outcome 
	* Distribution
	use `datdir'sample_monthly.dta, clear
	keep if read_month==638	/* March 2013 */
	local demogvars="median_HHincome av_age PRented PFullTime green"
	keep monthlykWh `demogvars' T account_number
	save `datdir'tempdat1.dta, replace
	local k=1
	foreach var1 in `demogvars'{
		use `datdir'tempdat1.dta, clear
		keep T monthlykWh `var1' account_number
		sort T `var1'
		xtile quart0=monthlykWh if T==0, nq(4)
		xtile quart1=monthlykWh if T==1, nq(4)	
		save `datdir'tempdat2.dta, replace
		forval q=1(1)4{
			use `datdir'tempdat2.dta, clear
			qui parmby "reg `var1' T if (quart0==`q' | quart1==`q'), cluster(account_number)", label norestore
			keep if parmseq==1
			keep estimate p
			rename estimate diff`q'
			rename p p`q'
			gen var="`var1'"
			sort var
			if(`k'!=1 | `k'==1 & `q'>1){
				merge m:m var using `paperdir'App_Table3_rank_preserve.dta, nogen
			}
			save `paperdir'App_Table3_rank_preserve.dta, replace
		}
		local k=`k'+1
	}	
	order var diff1 diff2 diff3 diff4 p1 p2 p3 p4
	format diff1 diff2 diff3 diff4 p1 p2 p3 p4 %12.2f
	replace var="Median weekly income" if var=="median_HHincome"
	replace var="Average age" if var=="av_age"
	replace var="Full-time employment rate" if var=="PFullTime"
	replace var="Proportion of home renters" if var=="PRented"
	replace var="Has above median vote share for Green Party" if var=="green"
	save `paperdir'App_Table3_rank_preserve.dta, replace	
}
	

********************************************************************************
*********************************** FIGURES ************************************
********************************************************************************
if(`figures'==1){

	* Figure 2: Distribution of Errors-in-Beliefs About Relative Energy Use
	use `datdir'sample_monthly_allresp.dta, clear	
	sort account_number read_month
	by account_number: keep if _n==1 & quantiles_prior!=.
	tab quantiles_prior quantile_hhrooms 
	gen diff_q=quantile_hhrooms-quantiles_prior
	tab quantile_hhrooms diff_q

	* Panel a
	hist diff_q, frac ylabel(0(0.1)0.6) xtick(-5(1)5) xlabel(-4(1)4) ///
			start(-5) width(1) discrete fcolor(black) lcolor(white) ///
			ytitle("Fraction of Households") xtitle("Overestimate use                               Correct                               Underestimate use", size(vsmall))
	graph export "`paperdir'Fig2_a.pdf", replace as(pdf)	

	* Panel b
	hist diff_q if quantiles_prior!=3, frac ylabel(0(0.1)0.6) xtick(-5(1)5) xlabel(-4(1)4) ///
			start(-4) width(1) discrete fcolor(black) lcolor(white) ///
			ytitle("Fraction of Households") xtitle("Overestimate use                               Correct                               Underestimate use", size(vsmall))
	graph export "`paperdir'Fig2_b.pdf", replace as(pdf)

	* Panel c
	twoway 	(hist diff_q if quantile_hhrooms==2, frac ylabel(0(0.1)0.6) xtick(-5(1)5) xlabel(-4(1)4) ///
			start(-5) width(1) discrete fcolor(black) lcolor(white) ///
			ytitle("Fraction of Households") xtitle("Overestimate use                               Correct                               Underestimate use", size(vsmall))) ///
			(hist diff_q if quantile_hhrooms==4, frac ylabel(0(0.1)0.6) xtick(-5(1)5) xlabel(-4(1)4) ///
			start(-5) width(1) discrete fcolor(gs10) lcolor(white) barwidth(0.8) ///
			legend(size(vsmall) region(lwidth(*0.25)) title("Actual Quantile - Prior Belief Quantile", size(vsmall)) label(1 "Actual 20-40%") label(2 "Actual 60-80%")))
	graph export "`paperdir'Fig2_c.pdf", replace as(pdf)	

	* Panel d
	twoway 	(hist diff_q if quantile_hhrooms==1, frac ylabel(0(0.1)0.6) xtick(-5(1)5) xlabel(-4(1)4) ///
			start(-5) width(1) discrete fcolor(black) lcolor(white) ///
			ytitle("Fraction of Households") xtitle("Overestimate use                               Correct                               Underestimate use", size(vsmall))) ///
			(hist diff_q if quantile_hhrooms==5, frac ylabel(0(0.1)0.6) xtick(-5(1)5) xlabel(-4(1)4) ///
			start(-5) width(1) discrete fcolor(gs10) lcolor(white) barwidth(0.8) ///
			legend(size(vsmall) region(lwidth(*0.25)) title("Actual Quantile - Prior Belief Quantile", size(vsmall)) label(1 "Actual 1-20%") label(2 "Actual 80-100%")))
	graph export "`paperdir'Fig2_d.pdf", replace as(pdf)	
		
	* Figure 3 and Figure A.6: Difference in Average Daily Electricity Consumption Between
	* Treatment and Control Within Electricity Use Quintile
	local xrange="-2 -1 0 1 2 3 4 5 6 7"
	local xrange2="-6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7"
	local yrange="-5 -4 -3 -2 -1 0 1 2 3 4 5"	
	forval i=0(1)5{
		use `datdir'sample_monthly.dta, clear
		if(`i'>0){
			keep if use_q`i'==1
		}
		do "Hetero_time_figs.do"
		
		* Figure 3
		if(`i'==0){
			twoway	(scatter estimate period if period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lwidth(medthick) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
					(scatter min period if period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
					(scatter max period if period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///			
					(line zero period if period>=-2, lcolor(black) lpattern(solid)), ///
					ytitle("Change in Daily Energy Use (kWh)") xtitle("Months Since Treatment") ///
					ylabel(`yrange') xlabel(`xrange') legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(5) order(1 2) label(1 "Treatment Effect") label(2 "95% CI"))							 							 
		}
		else{
			twoway	(scatter estimate period if period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lwidth(medthick) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
					(scatter min period if period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
					(scatter max period if period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///			
					(line zero period if period>=-2, lcolor(black) lpattern(solid)), ///
					ytitle("Change in Daily Energy Use (kWh)") xtitle("Months Since Treatment") ///
					ylabel(`yrange') xlabel(`xrange') legend(off)
		}
		graph export "`paperdir'Fig3_kwhplot_use_q`i'.pdf", replace as(pdf)
		
		* Extended plot for Appendix, Figure A.6
		if(`i'==0){
			twoway	(scatter estimate period, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lwidth(medthick) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
					(scatter min period, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
					(scatter max period, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///			
					(line zero period, lcolor(black) lpattern(solid)), ///
					ytitle("Change in Daily Energy Use (kWh)") xtitle("Months Since Treatment")  ///
					ylabel(`yrange') xlabel(`xrange2') legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(5) order(1 2) label(1 "Treatment Effect") label(2 "95% CI"))							 							 
		}
		else{
			twoway	(scatter estimate period, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lwidth(medthick) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
					(scatter min period, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
					(scatter max period, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///			
					(line zero period, lcolor(black) lpattern(solid)), ///
					ytitle("Change in Daily Energy Use (kWh)") xtitle("Months Since Treatment")  ///
					ylabel(`yrange') xlabel(`xrange2') legend(off)							 							 
		}
		graph export "`paperdir'App_Fig6_kwhplot_use_q`i'.pdf", replace as(pdf)			
	}	
	
	
	* Figure 4: Difference in Average Daily Electricitu Consumption between 
	* Treatment and Control Within Use Level and Informedness Sub-group
	forval i=1(1)4{
		use `datdir'sample_monthly.dta, clear
		if(`i'==1){
			keep if use_q1==1 & no_ans==1
			local j=1
			local p=0
		}
		if(`i'==2){
			keep if use_q1==1 & use_below==1
			local j=1
			local p=1			
		}	
		if(`i'==3){
			keep if use_q5==1 & no_ans==1
			local j=5
			local p=0			
		}
		if(`i'==4){
			keep if use_q5==1 & use_above==1
			local j=5
			local p=1			
		}	
		do "Hetero_time_figs.do"
		gen group=`i'	
		sort group parmseq
		if(`i'>1){
			merge m:m group parmseq using `datdir'tempdat2.dta, nogen
		}
		save `datdir'tempdat2.dta, replace
	}	
	* Plots
	local xrange="-2 -1 0 1 2 3 4 5 6 7"
	local yrange=""
	twoway	(scatter estimate period if group==1 & period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lwidth(medthick) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if group==1 & period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
			(scatter max period if group==1 & period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
			(scatter estimate period if group==2 & period>=-2, connect(line) mcolor(gs8) msymbol(S) msize(small) lcolor(gs8) lwidth(medthick) lpattern(solid)) || ///
			(scatter min period if group==2 & period>=-2, connect(line) mcolor(gs8) msymbol(S) msize(vsmall) lcolor(gs8) lpattern(shortdash) lwidth(vthin)) || ///
			(scatter max period if group==2 & period>=-2, connect(line) mcolor(gs8) msymbol(S) msize(vsmall) lcolor(gs8) lpattern(shortdash) lwidth(vthin)) || ///			
			(line zero period if period>=-2, lcolor(black) lpattern(solid)), ///
			ytitle("Change in Daily Energy Use (kWh)", height(5)) xtitle("Months Since Treatment") ///
			ylabel(`yrange') xlabel(`xrange') legend(size(small) region(lwidth(*0.25)) rows(2) order(4 5 1 2) label(4 "Bottom 20% Energy Users, Overestimate Use") ///
			label(1 "Bottom 20% Energy Users, All Other Households") label(5 "95% CI") label(2 "95% CI"))							 
	graph export "`paperdir'Fig4_kwhplot_use_q1_priors.pdf", replace as(pdf)	
	
	twoway	(scatter estimate period if group==3 & period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(small) lcolor(gs0) lwidth(medthick) lpattern(solid) xline(0, lcolor(black) lpattern(dash))) || ///
			(scatter min period if group==3 & period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
			(scatter max period if group==3 & period>=-2, connect(line) mcolor(gs0) msymbol(O) msize(vsmall) lcolor(gs0) lpattern(shortdash) lwidth(vthin)) || ///
			(scatter estimate period if group==4 & period>=-2, connect(line) mcolor(gs8) msymbol(S) msize(small) lcolor(gs8) lwidth(medthick) lpattern(solid)) || ///
			(scatter min period if group==4 & period>=-2, connect(line) mcolor(gs8) msymbol(S) msize(vsmall) lcolor(gs8) lpattern(shortdash) lwidth(vthin)) || ///
			(scatter max period if group==4 & period>=-2, connect(line) mcolor(gs8) msymbol(S) msize(vsmall) lcolor(gs8) lpattern(shortdash) lwidth(vthin)) || ///			
			(line zero period if period>=-2, lcolor(black) lpattern(solid)), ///
			ytitle("Change in Daily Energy Use (kWh)", height(5)) xtitle("Months Since Treatment") ///		
			ylabel(`yrange') xlabel(`xrange') legend(size(small) region(lwidth(*0.25)) rows(2) order(4 5 1 2) label(4 "Top 20% Energy Users, Underestimate Usage") ///
			label(1 "Top 20% Energy Users, All Other Households") label(5 "95% CI") label(2 "95% CI"))								 
	graph export "`paperdir'Fig4_kwhplot_use_q5_priors.pdf", replace as(pdf)	

	* Figure A.5: Average Daily Electricity Consumption by Use Level in Levels
	forval i=0(1)5{
		clear
		use `datdir'sample_monthly.dta, clear
		keep if read_month>=tm(2012m7) & read_month<=tm(2013m2)
		local xvals="633"
		tab unq
		sort read_month T1 account_number
		
		if(`i'>0){
			keep if use_q`i'==1
		}
		if(`i'==0){
			local yvar="8 10 12 14 16"
		}
		if(`i'==1){
			local yvar="4.5 5 5.5 6 6.5 7 7.5"
		}
		if(`i'==2){
			local yvar="4 6 8 10 12 14"
		}
		if(`i'==3){
			local yvar="6 8 10 12 14 16"
		}
		if(`i'==4){
			local yvar="6 8 10 12 14 16 18 20"
		}	
		if(`i'==5){
			local yvar="12 12 14 16 18 20 22 24 26"
		}			
		tab T1 unq
		egen tmp0=total(unq)
		egen tmp1=total(unq) if T1==1
		gen tmp2=tmp0-tmp1
		qui sum tmp1
		local Nobs1=r(mean)
		qui sum tmp2
		local Nobs2=r(mean)
		display `Nobs1'
		display `Nobs2'
		collapse (mean) dailykWh (sd) sd=dailykWh (count) n=dailykWh, by(read_month T1)
		gen min90=dailykWh-1.65*(sd/sqrt(n))
		gen max90=dailykWh+1.65*(sd/sqrt(n))
		if(`i'==0){
			twoway 	line dailykWh min90 max90 read_month if T1==1, xline(`xvals', lcolor(black) lpattern(dash)) ///
					lcolor(gs0 gs0 gs0) lpattern(solid shortdash shortdash) lwidth(medthick thin thin) || ///
					line dailykWh min90 max90 read_month if T1==0, ///
					lcolor(gs10 gs10 gs10) lpattern(solid shortdash shortdash) lwidth(medthick thin thin) ///
					legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(1) order(1 2 4 5) label(1 "Treatment") label(4 "Control") label(2 "95% CI") label(5 "95% CI")) ///
					xtitle(Month) ytitle(Average Daily Electricity Use (kWh)) ylabel(`yvar') xlabel(630 631 632 633 634 635 636 637, labsize(small))					
		}
		else{
			twoway 	line dailykWh min90 max90 read_month if T1==1, xline(`xvals', lcolor(black) lpattern(dash)) ///
					lcolor(gs0 gs0 gs0) lpattern(solid shortdash shortdash) lwidth(medthick thin thin) || ///
					line dailykWh min90 max90 read_month if T1==0, ///
					lcolor(gs10 gs10 gs10) lpattern(solid shortdash shortdash) lwidth(medthick thin thin) ///
					legend(off) ///
					xtitle(Month) ytitle(Average Daily Electricity Use (kWh)) ylabel(`yvar') xlabel(630 631 632 633 634 635 636 637, labsize(small))					
		}
		graph export "`paperdir'App_Fig5_kwhplot_use_q`i'_level.pdf", replace as(pdf)
	}
	
	* Figure A.1: Distribution of Average Daily Pre-Treatment Energy Use for 
	* Survey Respondents and Non-Respondents 
	use `datdir'sample_monthly.dta, clear	
	forval t=630(1)632{
		ksmirnov dailykWh if read_month==`t', by(no_ans)	
		local pval=r(p)	
		if(`t'==630){
			twoway 	kdensity dailykWh if no_ans==1 & read_month==`t', lcolor(gs0) || ///
					kdensity dailykWh if no_ans==0 & read_month==`t', lcolor(gs10) ///
					legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(1) label(1 "Survey Respondents") label(2 "Non-Respondents")) ///
					xtitle("Daily electricity use (kWh)") title(Kolomogorov-Smirnov P-value=`pval')
		}
		else{
			twoway 	kdensity dailykWh if no_ans==1 & read_month==`t', lcolor(gs0) || ///
					kdensity dailykWh if no_ans==0 & read_month==`t', lcolor(gs10) ///
					legend(off) ///
					xtitle("Daily electricity use (kWh)") title(Kolomogorov-Smirnov P-value=`pval')
		}
		graph export "`paperdir'App_Fig1_surveykWhuse`t'_daily.pdf", replace as(pdf)			
	}	

	* Figure A.2: Distribution of Monthly Pre-Treatment Energy USe for 
	* Survey Respondents and Non-Respondents
	forval t=630(1)632{
		ksmirnov monthlykWh if read_month==`t', by(no_ans)	
		local pval=r(p)
		if(`t'==630){
			twoway 	kdensity monthlykWh if no_ans==1 & read_month==`t', lcolor(gs0) || ///
					kdensity monthlykWh if no_ans==0 & read_month==`t', lcolor(gs10) ///
					legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(1) label(1 "Survey Respondents") label(2 "Non-Respondents")) ///
					xtitle(Monthly electricity use (kWh)) title(Kolomogorov-Smirnov P-value=`pval')
		}
		else{
			twoway 	kdensity monthlykWh if no_ans==1 & read_month==`t', lcolor(gs0) || ///
					kdensity monthlykWh if no_ans==0 & read_month==`t', lcolor(gs10) ///
					legend(off) ///
					xtitle("Monthly electricity use (kWh)") title(Kolomogorov-Smirnov P-value=`pval')
		}
		graph export "`paperdir'App_Fig2_surveykWhuse`t'_monthly.pdf", replace as(pdf)
	}
	
	* Figure A.3: Distribution of Average Daily Pre-Treatment Energy Use for 
	* Attritors and Non-Attritors
	use `datdir'sample_monthly.dta, clear	
	sort account_number read_month
	forval t=630(1)632{
		ksmirnov dailykWh if read_month==`t', by(churn_ever)	
		local pval=r(p)	
		if(`t'==630){
			twoway 	kdensity dailykWh if churn_ever==1 & read_month==`t', lcolor(gs0) || ///
					kdensity dailykWh if churn_ever==0 & read_month==`t', lcolor(gs10) ///
					legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(1) label(1 "Attritors") label(2 "Non-attritors")) ///
					xtitle("Daily electricity use (kWh)") title(Kolomogorov-Smirnov P-value=`pval')
		}
		else{
			twoway 	kdensity dailykWh if churn_ever==1 & read_month==`t', lcolor(gs0) || ///
					kdensity dailykWh if churn_ever==0 & read_month==`t', lcolor(gs10) ///
					legend(off) ///
					xtitle("Daily electricity use (kWh)") title(Kolomogorov-Smirnov P-value=`pval')
		}
		graph export "`paperdir'App_Fig3_attritkWhuse`t'_daily.pdf", replace as(pdf)			
	}
	
	* Figure A.4: Distribution of Monthly Pre-Treatment Energy Use for 
	* Attritors and Non-Attritors
	use `datdir'sample_monthly.dta, clear	
	sort account_number read_month	
	forval t=630(1)632{
		ksmirnov monthlykWh if read_month==`t', by(churn_ever)	
		local pval=r(p)
		if(`t'==630){
			twoway 	kdensity monthlykWh if churn_ever==1 & read_month==`t', lcolor(gs0) || ///
					kdensity monthlykWh if churn_ever==0 & read_month==`t', lcolor(gs10) ///
					legend(size(small) rows(2) ring(0) region(lwidth(*0.25)) position(1) label(1 "Attritors") label(2 "Non-attritors")) ///
					xtitle(Monthly electricity use (kWh)) title(Kolomogorov-Smirnov P-value=`pval')
		}
		else{
			twoway 	kdensity monthlykWh if churn_ever==1 & read_month==`t', lcolor(gs0) || ///
					kdensity monthlykWh if churn_ever==0 & read_month==`t', lcolor(gs10) ///
					legend(off) ///
					xtitle(Monthly electricity use (kWh)) title(Kolomogorov-Smirnov P-value=`pval')		
		}
		graph export "`paperdir'App_Fig4_attritkWhuse`t'_monthly.pdf", replace as(pdf)
	}	
}






