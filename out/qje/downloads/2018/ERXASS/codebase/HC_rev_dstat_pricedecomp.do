/* -------------------------------------------------------------------HC_rev_pricedecomp.do

Stuart Craig
Last updated 20180804
*/

timestamp, output
cap mkdir dstat_pricedecomp
cd dstat_pricedecomp 

/*
------------------------------------------------

Run the decomposition with varying
treatments of time
- ttype selects the relevant time window
	(month, quarter, year)
- "way" selects functional form
	- 1 No control
	- 2 Aggregate shocks
	- 3 Interacted with level
	- 4 Isolate a narrow window (2011, Q1 2011, Jan 2011)

------------------------------------------------
*/


foreach ttype in month year  qtr {
	
	cap confirm file HC_pricedecomp_4ways_t`ttype'.dta
	if _rc!=0 {
	cap postclose decomp
	postfile decomp d level r2 str10 proc N CoV using HC_pricedecomp_4ways_t`ttype'_all.dta, replace

	// Can toggle multiple treatments of time here
	forval way = 3/3 {
	di ""
	di "Version: `way'", _c
	foreach proc of global proclist {
	if "`proc'"=="ip" continue
	di "`proc'", _c
	qui {
	
	//-------------------------------------------Load the data
		
		use ${ddHC}/HC_epdata_`proc'.dta, clear
		
		// Make this the same as the regression samples
		keep if inrange(ep_adm_y,2010,2011)
		keep if adj_price<.
		
		// Build some fixed effects 
		cap gen ep_adm_m = mofd(ep_adm_d)
		cap gen ep_adm_q = qofd(ep_adm_d)
		cap egen hfe = group(prov_e_npi)
		cap egen hrrfe = group(prov_hrrnum)
		
		cap gen pat_mkt=1
		foreach v of varlist pat_prod pat_fund pat_mkt {
			cap confirm numeric var `v'
			if _rc!=0 {
				cap drop temp
				rename `v' temp
				qui egen `v' = group(temp)
			}
		}
	//-------------------------------------------How are we treating time?	
		
		cap drop time
		if "`ttype'"=="year"  qui egen time = group(ep_adm_y)
		if "`ttype'"=="qtr"   qui egen time = group(ep_adm_q)
		if "`ttype'"=="month" qui egen time = group(ep_adm_m)
		
		// Way 1 is no control for month
		loc time ""
		// Way 2 is to control for month in aggregate
		if `way'==2 loc time time
		// Way 3 is to control for month of level
		if `way'==3 {
			cap drop hfe
			qui egen hfe = group(prov_e_npi time)
			cap drop hrrfe
			qui egen hrrfe = group(prov_hrrnum time)
		}
		if `way'==4 {
			if "`ttype'"=="month" keep if ep_adm_m==ym(2011,1)
			if "`ttype'"=="year" keep if ep_adm_y==2011
			if "`ttype'"=="qtr"   keep if qofd(ep_adm_d)==yq(2011,1)
		}
	//-------------------------------------------Calculate the aggregate measures	
		// Grab the sample size
		qui count
		loc N=r(N)
		// Grab average within-hospital-month CoV
		preserve
			collapse (mean) mean_price=price (sd) sd_price = price, by(prov_e_npi ep_adm_m) fast
			qui gen cov = sd/mean
			qui summ cov, mean
			loc cov = r(mean)
		restore

	//-------------------------------------------Pull the R2 from the level regressions	
		
		loc pc "pat_age pat_female"
		loc ins "pat_prod pat_fund"
		loc drg ""
		if "`proc'"=="ip" loc drg "ep_drg"
		qui reghdfe price, absorb(`pc' `drg' `time') keepsin
		post decomp (`way') (1) (e(r2)) ("`proc'") (`N') (`cov')
		
		qui reghdfe price, absorb(`pc' `drg' `time' `ins') keepsin
		post decomp (`way') (2) (e(r2)) ("`proc'") (`N') (`cov')
		
		qui reghdfe price, absorb(`pc' `drg' `time' `ins' hrrfe) keepsin
		post decomp (`way') (3) (e(r2)) ("`proc'") (`N') (`cov')
		
		qui reghdfe price, absorb(`pc' `drg' `time' `ins' hfe) keepsin
		post decomp (`way') (4) (e(r2)) ("`proc'") (`N') (`cov')
		
		qui reghdfe price charge, absorb(`pc' `drg' `time' `ins' hfe) keepsin
		post decomp (`way') (5) (e(r2)) ("`proc'") (`N') (`cov')
		
	}
	}
	}
	postclose decomp
	}

	// Need to alter this as well if going for multiple time treatments
	forval way=3/3 {
		qui {
			use HC_pricedecomp_4ways_t`ttype'_all.dta, clear
			keep if d==`way'
			drop d
			rename r2 r2_
			reshape wide r2, i(proc) j(level)

			qui gen s=.
			loc ctr=0
			foreach proc of global proclist {
				if "`proc'"=="ip" continue
				loc ++ctr
				replace s = `ctr' if proc=="`proc'"
			}
			sort s
			drop s
		}
		list
		outsheet using HC_rev_dstat_pricedecomp_v`way'_t`ttype'.csv, comma replace
	}
}

exit
