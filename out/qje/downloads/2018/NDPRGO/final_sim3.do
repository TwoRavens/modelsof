/*******************************************************************
sim3.do
*******************************************************************/
clear all
cap log close
set more off
set mem 12000m
cd "/Users/patrickbayer/dropbox/Pat's Stuff"

set linesize 255

* use upper bin point for near merge 
local up = 1

/*****	SWITCHES  ******/
local emp_dist = 1 /*Generate empirical distribution*/
local shares   = 2/*Generate shares*/
local sim      = 1  /*Simulation*/
local y1940    = 0 /*Simulation for 1940 - 1980 or 1980 - 2014*/

/***********************/

local drawsperyear = 300000 /*Specify number of draws per year*/

set seed 419

/*****	EMPIRICAL DISTRIBUTION   *****/
if `emp_dist'==1 {

	use completedata1964_acs_1940.dta 

	drop if perwt == 0 

	replace perwt = 100 if gqtype != 1 & year == 1950
	sort year 
	drop other
	* white, black
	gen whiteno = (white == 1 & hispan == 0)
	drop white 
	rename whiteno white

	gen blackno = (black == 1 & hispan == 0)
	drop black
	rename blackno black

	gen other = (white == 0 & black == 0)

	cap drop agegrp
	gen agegrp = .
	replace agegrp = 1 if age1==1
	replace agegrp = 2 if age2==1
	replace agegrp = 3 if age3==1
	replace agegrp = 4 if age4==1
	replace agegrp = 5 if age5==1
	replace agegrp = 6 if age6==1


	/**********************************
	dependent variable
	*********************************/

	replace incbusfm =  incbus + 1.4*incfarm if year >= 1970 & year <= 1990
	replace incbusfm = incbus00 if year >= 2000
	replace incbusfm = incbus00*1.4 if year >= 2000 & ind1950 == 105
	replace incbusfm = 0 if incbusfm == 999999
	 
	replace incwage = 0 if incwage == 99999
	replace incbusfm = 0 if incbusfm < 0

	replace incwage = 1.2*incwage if ind1950 == 105
	replace incbusfm = 1.4*incbusfm if ind1950 == 105 & year <= 1960

	gen incpe= incwage+incbusfm /*Including business and farm data*/

	replace incpe=incwage if incpe==.

	
	*************Deflating*******************/
	merge year using cpi_acs.dta
	gen rincpe = incpe/cpi*100
	drop _merge cpi
	****************************************/
	gen lincpe = log(rincpe+1)

	cap drop i
	cap drop N
	cap drop pct

	sort year agegrp edlevel rincpe
	by year agegrp edlevel: egen N = total(perwt) 
	by year agegrp edlevel rincpe: egen temp = total(perwt)
	gen half = temp/2
	by year agegrp edlevel: gen runsum = sum(perwt)
	gen runsum_n_1 = runsum[_n-1]
	by year agegrp edlevel: replace runsum_n_1 = 0 if _n==1
	gen i = .
	gen i_up = .
	gen i_low = .
	by year agegrp edlevel rincpe: replace i = half+runsum_n_1 if _n==1
	by year agegrp edlevel rincpe: replace i_low = runsum_n_1 if _n==1
	by year agegrp edlevel rincpe: replace i_up = temp+runsum_n_1 if _n==1

	replace i = i[_n-1] if i==.
	gen pct = i/N*100
	replace i_up = i_up[_n-1] if i_up==.
	gen pct_up = i_up/N*100
	replace i_low = i_low[_n-1] if i_low==.
	gen pct_low = i_low/N*100
	drop runsum runsum_n_1 half temp N i i_up i_low


	/*    iii    */
	sort year agegrp edlevel other black pct
	by year agegrp edlevel other black: egen n = total(perwt)
	by year agegrp edlevel other black pct: egen temp = total(perwt)
	gen half = temp/2
	by year agegrp edlevel other black: gen runsum1 = sum(perwt)
	gen runsum2 = runsum1[_n-1]
	by year agegrp edlevel other black: replace runsum2=0 if _n==1
	by year agegrp edlevel other black pct: gen i = half + runsum2 if _n==1
	replace i = i[_n-1] if i==.
	gen g = i/n

	drop i n half runsum1 runsum2 temp

		
	sort year agegrp edlevel other black pct_up
	by year agegrp edlevel other black: egen n_up = total(perwt)
	by year agegrp edlevel other black pct_up: egen temp_up = total(perwt)
	by year agegrp edlevel other black: gen runsum1_up = sum(perwt)
	gen runsum2_up = runsum1_up[_n-1]
	by year agegrp edlevel other black: replace runsum2_up=0 if _n==1
	by year agegrp edlevel other black pct_up: gen i_up = temp + runsum2_up if _n==1
	replace i_up = i_up[_n-1] if i_up==.
	gen g_up = i_up/n_up
		
	drop i_up n_up runsum1_up runsum2_up temp_up

	sort year agegrp edlevel other black pct_low
	by year agegrp edlevel other black: egen n_low = total(perwt)
	by year agegrp edlevel other black pct_low: egen temp_low = total(perwt)
	by year agegrp edlevel other black: gen runsum1_low = sum(perwt)
	gen runsum2_low = runsum1_low[_n-1]
	by year agegrp edlevel other black: replace runsum2_low=0 if _n==1
	by year agegrp edlevel other black pct_low: gen i_low = runsum2_low if _n==1
	replace i_low = i_low[_n-1] if i_low==.
	gen g_low = i_low/n_low

	drop i_low n_low runsum1_low runsum2_low temp_low
		
	keep g g_up g_low year agegrp edlevel other black pct pct_up pct_low rincpe

	duplicates drop year agegrp edlevel other black pct pct_up pct_low rincpe,force
	save empirical_dist7_bf_1940.dta,replace
	clear
}

/****** SHARES  *****/
if `shares'==1 {

	use completedata1964_acs_1940.dta 

	drop if perwt == 0 

	replace perwt = 100 if gqtype != 1 & year == 1950

	drop other
	* white, black
	gen whiteno = (white == 1 & hispan == 0)
	drop white 
	rename whiteno white

	gen blackno = (black == 1 & hispan == 0)
	drop black
	rename blackno black

	gen other = (white == 0 & black == 0)

	gen agegrp = .
	replace agegrp = 1 if age1==1
	replace agegrp = 2 if age2==1
	replace agegrp = 3 if age3==1
	replace agegrp = 4 if age4==1
	replace agegrp = 5 if age5==1
	replace agegrp = 6 if age6==1
	cap drop i
	cap drop n

	/*    iv    */
	sort year agegrp edlevel other black
	by year agegrp edlevel other black: egen i = total(perwt)
	by year:       egen n = total(perwt)
	gen s = i/n
	drop i n

	keep s year agegrp edlevel other black

	duplicates drop year agegrp edlevel other black,force

	sort year agegrp edlevel other black
	by year: gen runshare = sum(s)

	save shares7_1940.dta,replace
}

/*****  SIMULATION  ****/
if `sim'==1 {
	clear
	log using sim3,text replace

	tokenize 1940 1950 1960 1970 1980 1990 2000 2007 
	
	forvalues t=1/8{
	
	
		clear
		local draws = `drawsperyear'*2
		set obs `draws'
		gen t=1940
		
		gen ss = .
		replace ss=1950 if ``t''==1940
		replace ss=1960 if ``t''==1950
		replace ss=1970 if ``t''==1960
		replace ss=1980 if ``t''==1970
		replace ss=1990 if ``t''==1980
		replace ss=2000 if ``t''==1990
		replace ss=2007 if ``t''==2000
		replace ss=2014 if ``t''==2007

		gen year = .
		replace year = ``t'' if _n<=`drawsperyear'  
		replace year = ss if _n>`drawsperyear' & _n<=2*`drawsperyear'
		gen runshare = runiform()
	
		nearmrg year using shares7_1940.dta, nearvar(runshare) genmatch(qmatchS) upper
		keep if _merge==3
		rename _merge mergers
		drop runshare
		gen g_up = runiform()
		gen g_up2 = g_up 
		gen trueyear = year
		replace year = ``t'' 
		
	
	sort year agegrp edlevel other black g_up

	nearmrg year agegrp edlevel other black using empirical_dist7_bf_1940.dta,nearvar(g_up) genmatch(qmatchF) upper
	keep if _merge==3
	drop year
	rename trueyear year
	rename _merge mergeg
	gen pct_exact=pct
/*	gen pct_exact = pct_low + (pct_up - pct_low)*(g_up2 - g_low)/(qmatchF - g_low) 
*/	rename pct_up pct_up2
	gen pct_up = pct_exact

	save merge1_`y'.dta,replace
	rename rincpe rincpe1
	drop g 
	
	
	/****calculate simulated distribution of lrincwage within each cell for comparison****
	sort year agegrp educ black lrincwage
	by year agegrp educ black: egen n = count(lrincwage)
	by year agegrp educ black lrincwage: egen i = count(lrincwage)
	gen ss = i/n
	drop i n
	***************************************************************************************/

	sort year agegrp edlevel other black
	nearmrg year agegrp edlevel other black using empirical_dist7_bf_1940.dta, nearvar(pct_up) genmatch(qmatchPCT) upper
	keep if _merge==3
	
	rename _merge mergepct
	gen perwt=1
	rename pct pctL1
	rename pct_up pctL1_up


	gen mergeexc = (mergers == 3 & mergeg == 3 & mergepct == 3)
		sort year
	gen lincpe = log(rincpe+1)
	gen zerearn=(rincpe<=1)

		 foreach q in 50 75 90 {


			qreg lincpe black other i.agegrp [pw=perwt] if year==``t'' & mergeexc == 1 ,q(`q')

			}
			
			reg zerearn black other i.agegrp [pw=perwt] if year==``t'' & mergeexc == 1

			foreach q in 50 75 90 {


			qreg lincpe black other i.agegrp [pw=perwt] if year==ss & mergeexc == 1 ,q(`q')

			}
			
			reg zerearn black other i.agegrp [pw=perwt] if year==ss & mergeexc == 1
					}


			}

}

