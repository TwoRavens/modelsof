

set more off
capture log close


local measurement = 0
local florida_high = 0
local florida_distance = 0
local PDMP = 0

if `measurement' == 1 {
	estimates clear
	use heroin_deaths_state_month.dta, clear

	quietly summ date if year==2010 & month==8
	local reform = r(mean)

	** create variables that denote whether a state is in the higher or lower 
	** risk group for a number of factors.
	do risk_factors_1.do
		
	gen trend = date - `reform'
	gen treat = (date - `reform')*(date >= `reform')
	replace trend=0 if date>=`reform'
	   
	gen index=trend

	replace trend=0 if treat>0

	xi i.month
	gen hd_hs=rfact7_ge50==1 & rfact1_ge50==1
	gen hd_ls=rfact7_ge50==1 & rfact1_ge50==0
	gen ld_hs=rfact7_ge50==0 & rfact1_ge50==1
	gen ld_ls=rfact7_ge50==0 & rfact1_ge50==0

	sum hd_hs hd_ls ld_hs ld_ls

	gen trend_hdhs=trend*hd_hs
	gen trend_hdls=trend*hd_ls
	gen trend_ldhs=trend*ld_hs
	gen trend_ldls=trend*ld_ls

	gen treat_hdhs=treat*hd_hs
	gen treat_hdls=treat*hd_ls
	gen treat_ldhs=treat*ld_hs
	gen treat_ldls=treat*ld_ls

	gen heroin_deaths_pc=heroin_deaths*100000/population
	gen opioid_deaths_pc=opioid_deaths*100000/population
	gen h_or_o_deaths_pc=h_or_o_deaths*100000/population

	sum heroin_deaths_pc opioid_deaths_pc h_or_o_deaths_pc [aweight=population] if index<=-1 & index>=-12

	gen agege50_pop=age5064_pop+age6579_pop+agege80_pop

	** merge on measurement error versions of deaths
	capture drop _merge
	sort fips year month
	merge 1:1 fips year month using ..\processed_data\pred_deaths
	* some state-month combos aren't in the using data because there were no
	* drug deaths; appropriately replace things with zeros.
	foreach x of varlist heroin-horo_hat_spec {
		replace `x' = 0 if `x'==. & year>=2004
	}
	
	** measurement error corrected death rates
	gen m_heroin = h_hat_spec*100000/population
	gen m_opioid = o_hat_spec*100000/population
	gen m_horo   = horo_hat_spec*100000/population

	** Regressions
	** heroin
	areg m_heroin trend_ldls treat_ldls trend_hdls treat_hdls trend_ldhs treat_ldhs trend_hdhs treat_hdhs ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004, abs(fips) vce(cluster fips)
	lincom treat_hdhs-trend_hdhs
	lincom treat_ldhs-trend_ldhs
	lincom treat_hdls-trend_hdls
	lincom treat_ldls-trend_ldls
	lincom treat_hdhs-trend_hdhs-(treat_ldls-trend_ldls)
	lincom treat_ldhs-trend_ldhs-(treat_ldls-trend_ldls)
	lincom treat_hdls-trend_hdls-(treat_ldls-trend_ldls)
	summ m_heroin [aweight=population] if inrange(index,-12,-1) & year>=2004

	areg m_heroin trend_ldls treat_ldls trend_hdls treat_hdls trend_ldhs treat_ldhs trend_hdhs treat_hdhs ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012, abs(fips) vce(cluster fips)
	lincom treat_hdhs-trend_hdhs
	lincom treat_ldhs-trend_ldhs
	lincom treat_hdls-trend_hdls
	lincom treat_ldls-trend_ldls
	lincom treat_hdhs-trend_hdhs-(treat_ldls-trend_ldls)
	lincom treat_ldhs-trend_ldhs-(treat_ldls-trend_ldls)
	lincom treat_hdls-trend_hdls-(treat_ldls-trend_ldls)
	summ m_heroin [aweight=population] if inrange(index,-12,-1) & year>=2004 & year<=2012
	
	** opioids
	areg m_opioid trend_ldls treat_ldls trend_hdls treat_hdls trend_ldhs treat_ldhs trend_hdhs treat_hdhs ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004, abs(fips) vce(cluster fips)
	lincom treat_hdhs-trend_hdhs
	lincom treat_ldhs-trend_ldhs
	lincom treat_hdls-trend_hdls
	lincom treat_ldls-trend_ldls
	lincom treat_hdhs-trend_hdhs-(treat_ldls-trend_ldls)
	lincom treat_ldhs-trend_ldhs-(treat_ldls-trend_ldls)
	lincom treat_hdls-trend_hdls-(treat_ldls-trend_ldls)
	summ m_opioid [aweight=population] if inrange(index,-12,-1) & year>=2004

	areg m_opioid trend_ldls treat_ldls trend_hdls treat_hdls trend_ldhs treat_ldhs trend_hdhs treat_hdhs ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012, abs(fips) vce(cluster fips)
	lincom treat_hdhs-trend_hdhs
	lincom treat_ldhs-trend_ldhs
	lincom treat_hdls-trend_hdls
	lincom treat_ldls-trend_ldls
	lincom treat_hdhs-trend_hdhs-(treat_ldls-trend_ldls)
	lincom treat_ldhs-trend_ldhs-(treat_ldls-trend_ldls)
	lincom treat_hdls-trend_hdls-(treat_ldls-trend_ldls)
	summ m_opioid [aweight=population] if inrange(index,-12,-1) & year>=2004 & year<=2012

	** heroin or opioids
	areg m_horo trend_ldls treat_ldls trend_hdls treat_hdls trend_ldhs treat_ldhs trend_hdhs treat_hdhs ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004, abs(fips) vce(cluster fips)
	lincom treat_hdhs-trend_hdhs
	lincom treat_ldhs-trend_ldhs
	lincom treat_hdls-trend_hdls
	lincom treat_ldls-trend_ldls
	lincom treat_hdhs-trend_hdhs-(treat_ldls-trend_ldls)
	lincom treat_ldhs-trend_ldhs-(treat_ldls-trend_ldls)
	lincom treat_hdls-trend_hdls-(treat_ldls-trend_ldls)
	summ m_horo [aweight=population] if inrange(index,-12,-1) & year>=2004 

	areg m_horo trend_ldls treat_ldls trend_hdls treat_hdls trend_ldhs treat_ldhs trend_hdhs treat_hdhs ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012, abs(fips) vce(cluster fips)
	lincom treat_hdhs-trend_hdhs
	lincom treat_ldhs-trend_ldhs
	lincom treat_hdls-trend_hdls
	lincom treat_ldls-trend_ldls
	lincom treat_hdhs-trend_hdhs-(treat_ldls-trend_ldls)
	lincom treat_ldhs-trend_ldhs-(treat_ldls-trend_ldls)
	lincom treat_hdls-trend_hdls-(treat_ldls-trend_ldls)
	summ m_horo [aweight=population] if inrange(index,-12,-1) & year>=2004 & year<=2012
	
	** results qualitatively the same as your original results.
}

if `florida_high' == 1 {
	estimates clear
	use heroin_deaths_state_month.dta, clear

	quietly summ date if year==2010 & month==8
	local reform = r(mean)

	** create variables that denote whether a state is in the higher or lower 
	** risk group for a number of factors.
	do risk_factors_1.do
		
	gen trend = date - `reform'
	gen treat = (date - `reform')*(date >= `reform')
	replace trend=0 if date>=`reform'
	   
	gen index=trend

	replace trend=0 if treat>0

	xi i.month

	gen heroin_deaths_pc=heroin_deaths*100000/population
	gen opioid_deaths_pc=opioid_deaths*100000/population
	gen h_or_o_deaths_pc=h_or_o_deaths*100000/population

	gen agege50_pop=age5064_pop+age6579_pop+agege80_pop

	** indicate which states are more influenced by the Florida pill mills
	gen pillmill=fips==13 | fips== 1 | fips==21| fips==47 ///
	| fips==44| fips==23| fips==34| fips==24| fips==18 ///
	| fips==54| fips==9| fips==28| fips==26| fips==36| fips==37 ///
	| fips==39 | fips==12

	gen inter_trend = trend*pillmill
	gen inter_treat = treat*pillmill

**********************************************
** first do analyses for all states
**********************************************
	gen hh_yf=rfact1_ge50==1 & pillmill==1
	gen hh_nf=rfact1_ge50==1 & pillmill==0
	gen lh_yf=rfact1_ge50==0 & pillmill==1
	gen lh_nf=rfact1_ge50==0 & pillmill==0

	sum hh_* lh_*
	
	gen trend_hhyf=trend*hh_yf
	gen trend_hhnf=trend*hh_nf
	gen trend_lhyf=trend*lh_yf
	gen trend_lhnf=trend*lh_nf

	gen treat_hhyf=treat*hh_yf
	gen treat_hhnf=treat*hh_nf
	gen treat_lhyf=treat*lh_yf
	gen treat_lhnf=treat*lh_nf

	areg heroin_deaths_pc trend_hhyf treat_hhyf trend_hhnf treat_hhnf ///
	trend_lhyf treat_lhyf trend_lhnf treat_lhnf ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012, abs(fips) vce(cluster fips)
	lincom treat_hhyf-trend_hhyf
	lincom treat_lhyf-trend_lhyf
	lincom treat_hhnf-trend_hhnf
	lincom treat_lhnf-trend_lhnf
	lincom treat_hhyf-trend_hhyf-(treat_hhnf-trend_hhnf)
	lincom treat_lhyf-trend_lhyf-(treat_lhnf-trend_lhnf)


**********************************************
** limit to states with high pre-reform Oxy levels
**********************************************
	drop trend_* treat_* 
	keep if rfact7_ge50 == 1
	
	drop trend treat 
	gen trend = (date - `reform')*(date < `reform')
	gen treat = (date - `reform')*(date >= `reform')
    replace trend=0 if date>=`reform'
	
	sum hh_* lh_*
	
	gen trend_hhyf=trend*hh_yf
	gen trend_hhnf=trend*hh_nf
	gen trend_lhyf=trend*lh_yf
	gen trend_lhnf=trend*lh_nf

	gen treat_hhyf=treat*hh_yf
	gen treat_hhnf=treat*hh_nf
	gen treat_lhyf=treat*lh_yf
	gen treat_lhnf=treat*lh_nf

	areg heroin_deaths_pc trend_hhyf treat_hhyf trend_hhnf treat_hhnf ///
	trend_lhyf treat_lhyf trend_lhnf treat_lhnf ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004, abs(fips) vce(cluster fips)
	lincom treat_hhyf-trend_hhyf
	lincom treat_lhyf-trend_lhyf
	lincom treat_hhnf-trend_hhnf
	lincom treat_lhnf-trend_lhnf
	lincom treat_hhyf-trend_hhyf-(treat_hhnf-trend_hhnf)
	lincom treat_lhyf-trend_lhyf-(treat_hhnf-trend_hhnf)
	lincom treat_hhyf-trend_hhyf-(treat_hhnf-trend_hhnf)

	
	areg heroin_deaths_pc trend_hhyf treat_hhyf trend_hhnf treat_hhnf ///
	trend_lhyf treat_lhyf trend_lhnf treat_lhnf ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012, abs(fips) vce(cluster fips)
	lincom treat_hhyf-trend_hhyf
	lincom treat_lhyf-trend_lhyf
	lincom treat_hhnf-trend_hhnf
	lincom treat_lhnf-trend_lhnf
	lincom treat_hhyf-trend_hhyf-(treat_hhnf-trend_hhnf)
	lincom treat_lhyf-trend_lhyf-(treat_lhnf-trend_lhnf)

	
}

if `florida_distance' == 1 {	
	estimates clear
	use heroin_deaths_state_month.dta, clear
	
	quietly summ date if year==2010 & month==8
	local reform = r(mean)
	
	** create variables that denote whether a state is in the higher or lower 
	** risk group for a number of factors.
	do risk_factors_1.do
	
	gen trend = date - `reform'
	gen treat = (date - `reform')*(date >= `reform')

    sort fips year month
    merge 1:1 fips year month using h_o_data
     
	gen index=trend

    xi i.month

	gen heroin_deaths_pc=heroin_deaths*100000/population
	gen opioid_deaths_pc=opioid_deaths*100000/population
	gen h_or_o_deaths_pc=h_or_o_deaths*100000/population

	gen agege50_pop=age5064_pop+age6579_pop+agege80_pop

	capture drop _merge
	sort fips
	merge m:1 fips using florida_distances.dta
	
	replace miles = miles/1000
	replace drivingtimemin=drivingtimemin/600
	
	gen trendmiles = trend*miles
	gen treatmiles = treat*miles
	gen trendmins = trend*drivingtimemin
	gen treatmins = treat*drivingtimemin
	
	gen trendhyp_miles = trend/miles
	gen treathyp_miles = treat/miles
	gen trendhyp_mins = trend/drivingtimemin
	gen treathyp_mins = treat/drivingtimemin
	
	areg heroin_deaths_pc trend treat trendmiles treatmiles ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012, abs(fips) vce(cluster fips)	
	estimates store miles1
	
	** drop alaska
	areg heroin_deaths_pc trend treat trendmiles treatmiles ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012 & state!="ALASKA" & state!="HAWAII", abs(fips) vce(cluster fips)	
	estimates store miles2
	
	** driving time as distance
	areg heroin_deaths_pc trend treat trendmins treatmins ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012 & state!="HAWAII", abs(fips) vce(cluster fips)	
	estimates store mins1
	
	areg heroin_deaths_pc trend treat trendmins treatmins ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012 & state!="ALASKA" & state!="HAWAII", abs(fips) vce(cluster fips)	
	estimates store mins2
	
	*******************************************************
	** Now hyperbolic version to get away from linearity
	*******************************************************
	areg heroin_deaths_pc trend treat trendhyp_miles treathyp_miles ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012, abs(fips) vce(cluster fips)	
	estimates store miles3
	
	** drop alaska
	areg heroin_deaths_pc trend treat trendhyp_miles treathyp_miles ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012 & state!="ALASKA" & state!="HAWAII", abs(fips) vce(cluster fips)	
	estimates store miles4
	
	** driving time as distance
	areg heroin_deaths_pc trend treat trendhyp_mins treathyp_mins ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012 & state!="HAWAII", abs(fips) vce(cluster fips)	
	estimates store mins3
	
	areg heroin_deaths_pc trend treat trendhyp_mins treathyp_mins ///
	_I* age2034_pop age3549_pop agege50_pop black* oth* hisp* urate ///
	[aweight=population] if year>=2004 & year<=2012 & state!="ALASKA" & state!="HAWAII", abs(fips) vce(cluster fips)	
	estimates store mins4
}

if `PDMP' == 1 {	
	estimates clear
	use heroin_deaths_state_month.dta, clear
	
	quietly summ date if year==2010 & month==8
	local reform = r(mean)
	
	** create variables that denote whether a state is in the higher or lower 
	** risk group for a number of factors.
	do risk_factors_1.do
	
	gen trend = date - `reform'
	gen treat = (date - `reform')*(date >= `reform')

    sort fips year month
    merge 1:1 fips year month using h_o_data
     
	gen index=trend

    xi i.month

	** group states into three categories: pre 2010, post 2010, never
	** based on Carey and Buchmueller's breakdown in their Table 1.
	gen pdmp = 1
	replace pdmp = 2 if fips==5 | fips==10 | fips==13 | fips==24 | fips==30 ///
	| fips==31 | fips==33 | fips==46 | fips==55
	replace pdmp = 3 if fips==11 | fips==29
	
	collapse (sum) heroin_deaths population, by(year month pdmp date)
	
	gen hrate = heroin_deaths/(population/100000)
	
	twoway (line hrate date if pdmp==1)(line hrate date if pdmp==2)(line hrate date if pdmp==3)
	
	drop population
	reshape wide hrate heroin_deaths, i(year month date) j(pdmp)
	order date year month hrate* heroin_deaths*
	forvalues i = 1(1)3 {
		replace hrate`i'=. if heroin_deaths`i'<10
	}
	
	export excel using pdmp_groups_data.xlsx, replace firstrow(variables)
	
	
}
