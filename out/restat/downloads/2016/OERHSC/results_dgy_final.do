**************************
*TABLE 1 SUMMARY STATS
**************************
*** COLUMN 1 FULL SAMPLE CREDIT USERS
cd $data 
insheet using allsample.csv
keep if type=="NOBANK"
* 29,823,645  obs

* full random sample 2002-2005
keep if year>=2002 & year<=2005

gen missing_age = age==0
gen missing_score = score==1|score==2|score==3
replace score = . if score==1|score==2|score==3
gen homeflag2 = .
replace homeflag2 = 1 if homeflag=="Y"
replace homeflag2 = 0 if homeflag=="N"

* indicators for foreclosures, repos, chargoffs, liens, collections, judgemnts, bankrupties**
foreach var in mortin12 autopv6 cur2gn12 collec12 chgoff12 bankin12   jdgst12h forecl12 lien12  repo12  {
gen `var'_ind = 0 if `var'==0
replace `var'_ind = 1 if `var'>0
}	

* dollar amounts divided by 1000
foreach var in  autbalt revtotbl agcolthb instrbal  revaggcr trdbal trdbalm {
	replace `var' = `var'/1000
}

** nonmortgage balances from trdbal and trdbalm
gen trdbalnm = trdbal - trdbalm


** mortgage credit lines
gen mutil = mortutil/100
gen mortcrl  = trdbalnm/mutil

*** nonmortage inquires
gen nonmortinq6 = numinq6 - mortinq6

**** top coding
foreach var in autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
_pctile `var', p(99)
local `var'_99 = r(r1)
}

foreach var in autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
gen `var'_tc = `var'
replace `var'_tc = ``var'_99' if `var'_tc > ``var'_99'
}


** merging in zipcode income
gen zip_str = zip_code
tostring zip_str, replace
replace zip_str = "0" + zip_str if length(zip_str)==4

merge m:1 zip_str using zip_income, gen(merge_zip)

drop if merge_zip==2
replace income= 0 if income==.

gen missing_zip_income = (income==0)


collapse (mean) age missing_age  income missing_zip_income homeflag2 missing_score score  cur2gn12_ind collec12_ind chgoff12_ind bankin12_ind    jdgst12h_ind forecl12_ind lien12_ind  repo12_ind revtotbl_tc agcolthb_tc mortin12_ind trdbalnm_tc autopv6_ind autbalt_tc  rev12mth_tc  revaggcr_tc  revratio_tc  nonmortinq6_tc, by(permid)

collapse (mean) age missing_age missing_score score, by(permid)


sum age if missing_age==0 
sum income if missing_zip_income==0
sum homeflag2 score  cur2gn12_ind collec12_ind chgoff12_ind bankin12_ind    jdgst12h_ind forecl12_ind lien12_ind  repo12_ind revtotbl_tc agcolthb_tc mortin12_ind trdbalnm_tc autopv6_ind autbalt_tc  rev12mth_tc  revaggcr_tc  revratio_tc  nonmortinq6_tc
sum missing_age
sum missing_score
sum missing_zip_income


*** COLUMN 2 BANKRUPTCY FILERS
* full random sample of people who filed bankruptcy between june 2002 - june 2006
cd $data
insheet using allsample.csv
keep if type=="NOBANK"

keep if year<=2006

gen missing_age = age==0
gen homeflag2 = .
gen missing_score = score==1|score==2|score==3
replace score = . if score==1|score==2|score==3
replace homeflag2 = 1 if homeflag=="Y"
replace homeflag2 = 0 if homeflag=="N"

* indicators for foreclosures, repos, chargoffs, liens, collections, judgemnts, bankrupties**
foreach var in mortin12 autopv6 cur2gn12 collec12 chgoff12 bankin12   jdgst12h forecl12 lien12  repo12  {
gen `var'_ind = 0 if `var'==0
replace `var'_ind = 1 if `var'>0
}	

* dollar amounts divided by 1000
foreach var in  autbalt revtotbl agcolthb instrbal  revaggcr trdbal trdbalm {
	replace `var' = `var'/1000
}

** nonmortgage balances from trdbal and trdbalm
gen trdbalnm = trdbal - trdbalm


** mortgage credit lines
gen mutil = mortutil/100
gen mortcrl  = trdbalnm/mutil

*** nonmortage inquires
gen nonmortinq6 = numinq6 - mortinq6

**** top coding
foreach var in autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
_pctile `var', p(99)
local `var'_99 = r(r1)
}

foreach var in autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
gen `var'_tc = `var'
replace `var'_tc = ``var'_99' if `var'_tc > ``var'_99'
}




gen file_year = 2002 if bankin12>0 & year==2003
replace file_year = 2003 if bankin12>0 & year==2004
replace file_year = 2004 if bankin12>0 & year==2005
replace file_year = 2005 if bankin12>0 & year==2006


bys permid: egen temp_max = max(file_year)
bys permid: egen temp_min = min(file_year)
bys permid: replace file_year=. if temp_max!=temp_min

bys permid: egen temp = mean(file_year)
replace file_year = temp if file_year==.
drop temp


foreach year in 2002 2003 2004 2005 {
replace file_year = . if file_year ==`year' & bankin12>0 & year==`year'
}


drop if file_year==.

gen sampleneg1 = year - file_year == -1


** merging in zipcode income
gen zip_str = zip_code
tostring zip_str, replace
replace zip_str = "0" + zip_str if length(zip_str)==4

merge m:1 zip_str using zip_income, gen(merge_zip)

drop if merge_zip==2
replace income= 0 if income==.

gen missing_zip_income = (income==0)


sum age if sampleneg1==1 & missing_age==0 
sum income if sampleneg1==1 & missing_zip_income==0
sum homeflag2 score  cur2gn12_ind collec12_ind chgoff12_ind bankin12_ind    jdgst12h_ind forecl12_ind lien12_ind  repo12_ind revtotbl_tc agcolthb_tc mortin12_ind trdbalnm_tc autopv6_ind autbalt_tc  rev12mth_tc  revaggcr_tc  revratio_tc  nonmortinq6_tc if sampleneg1==1
sum missing_age if sampleneg1==1
sum missing_score  if sampleneg1==1
sum missing_zip_income if sampleneg1==1



*** COLUMN 3 and COLUMN 4 MATCHED JUDGE SAMPLE
use "$data/inputAllData_analysis_reshape_Feb2016.dta" if sample==1

_pctile z_ij_pooled, p(50)


*** summary stats for below median instrument
sum z_ij_pooled if z_ij_pooled_med==0
sum discharge if z_ij_pooled_med==0
sum missing_age_0 if z_ij_pooled_med==0
sum age_0 if z_ij_pooled_med==0 & missing_age_0==0
sum missing_neg1 if z_ij_pooled_med==0
sum missing_score_neg1 if z_ij_pooled_med==0
sum missing_zip_income if z_ij_pooled_med==0
sum income if z_ij_pooled_med==0 & missing_zip_income==0


* panel a
sum score_neg1 if z_ij_pooled_med==0 & missing_neg1==0  & missing_score_neg1==0
sum homeflag2_neg1 if z_ij_pooled_med==0 & missing_neg1==0 
* panel b
sum cur2gn12_ind_neg1 collec12_ind_neg1 chgoff12_ind_neg1 bankin12_ind_neg1    jdgst12h_ind_neg1 forecl12_ind_neg1 lien12_ind_neg1  repo12_ind_neg1     if z_ij_pooled_med==0 & missing_neg1==0 
* panel c
sum   revtotbl_tc_neg1 agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 if z_ij_pooled_med==0 & missing_neg1==0 
* panel d
sum  revratio_tc_neg1  nonmortinq6_tc_neg1   if z_ij_pooled_med==0 & missing_neg1==0


sum z_ij_pooled if z_ij_pooled_med==1
sum discharge if z_ij_pooled_med==1
sum missing_age_0 if z_ij_pooled_med==1
sum age_0 if z_ij_pooled_med==1 & missing_age_0==0
sum missing_neg1 if z_ij_pooled_med==1
sum missing_score_neg1 if z_ij_pooled_med==1
sum missing_zip_income if z_ij_pooled_med==1
sum income if z_ij_pooled_med==1 & missing_zip_income==0

* panel a
sum score_neg1 if z_ij_pooled_med==1 & missing_neg1==0  & missing_score_neg1==0
sum homeflag2_neg1 score_neg1 if z_ij_pooled_med==1 & missing_neg1==0 
* panel b
sum cur2gn12_ind_neg1 collec12_ind_neg1 chgoff12_ind_neg1 bankin12_ind_neg1    jdgst12h_ind_neg1 forecl12_ind_neg1 lien12_ind_neg1  repo12_ind_neg1     if z_ij_pooled_med==1 & missing_neg1==0 
* panel c
sum   revtotbl_tc_neg1 agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 if z_ij_pooled_med==1 & missing_neg1==0 
* panel d
sum  revratio_tc_neg1  nonmortinq6_tc_neg1   if z_ij_pooled_med==1 & missing_neg1==0


**** COLUMN 5 Test of Randomization 
use "$data/inputAllData_analysis_reshape_Feb2016.dta" if sample==1

areg z_ij_pooled z_ij_pooled_med , absorb(absorbid2) cluster(office)

areg age_0 z_ij_pooled_med if missing_age_0==0, absorb(absorbid2) cluster(office)

areg income z_ij_pooled_med if missing_zip_income==0, absorb(absorbid2) cluster(office)

foreach var in homeflag2_neg1 forecl12_ind_neg1 repo12_ind_neg1 lien12_ind_neg1 collec12_ind_neg1  chgoff12_ind_neg1 jdgst12h_ind_neg1 bankin12_ind_neg1 cur2gn12_ind_neg1  revtotbl_tc_neg1 agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 rev12mth_neg1_tc  revaggcr_neg1_tc  revratio_neg1_tc  nonmortinq6_neg1_tc  {
areg `var' z_ij_pooled_med if missing_neg1==0, absorb(absorbid2) cluster(office)
}

areg score_neg1 z_ij_pooled_med if missing_neg1==0 & missing_score_neg1==0, absorb(absorbid2) cluster(office)

areg missing_age_0 z_ij_pooled_med, absorb(absorbid2) cluster(office)
areg missing_zip_income z_ij_pooled_med, absorb(absorbid2) cluster(office)
areg missing_neg1 z_ij_pooled_med, absorb(absorbid2) cluster(office)
areg missing_score_neg1 z_ij_pooled_med, absorb(absorbid2) cluster(office)


***************************************************************
*	Table 2 - First Stage (2002-2005 filers)
**************************************************************** ;
use "$data/inputAllData_analysis_reshape_Feb2016.dta" if sample==1

** creating baseline financial strain index with 8 components
foreach var in forecl12_ind_neg1 repo12_ind_neg1 chgoff12_ind_neg1 lien12_ind_neg1 collec12_ind_neg1 jdgst12h_ind_neg1 bankin12_ind_neg1 cur2gn12_ind_neg1{
	sum `var' if discharge==0 & missing_neg1==0
	local mean_`var' = string(r(mean), "%12.3f") 
	local sd_`var' = string(r(sd), "%12.3f") 
}

foreach var in forecl12_ind_neg1 repo12_ind_neg1 chgoff12_ind_neg1 lien12_ind_neg1 collec12_ind_neg1 jdgst12h_ind_neg1 bankin12_ind_neg1 cur2gn12_ind_neg1 {
	gen `var'_std = (`var' - `mean_`var'')/(`sd_`var'') if missing_neg1==0
}

gen findex_neg1 = (forecl12_ind_neg1_std +  repo12_ind_neg1_std +  chgoff12_ind_neg1_std +  lien12_ind_neg1_std +  collec12_ind_neg1_std +  jdgst12h_ind_neg1_std +  bankin12_ind_neg1_std +  cur2gn12_ind_neg1_std)/8
	local mean_findex_neg1 = string(r(mean), "%12.3f") 
	local sd_findex_neg1 = string(r(sd), "%12.3f") 
gen findex_std_neg1 = (findex_neg1 - `mean_findex_neg1')/(`sd_findex_neg1')
foreach var in findex_std  {
replace `var'_neg1 = 0 if missing_neg1==1
}


* No controls
areg discharge z_ij_pooled, absorb(absorbid2)  cluster(office)

* Age/homeowner/income + Panel A (financial strain index instead of individual outcomes) 
areg discharge z_ij_pooled age_0 homeflag2_neg1 income findex_std_neg1 missing_age_0 missing_neg1 missing_zip_income, absorb(absorbid2)  cluster(office)

* Age/homeowner + Panel B 
areg discharge z_ij_pooled age_0 homeflag2_neg1 income findex_std_neg1  revtotbl_tc_neg1 agcolthb_tc_neg1  missing_age_0 missing_neg1 missing_zip_income, absorb(absorbid2)  cluster(office)

* Age/homeowner + Panel C 
areg discharge z_ij_pooled age_0 homeflag2_neg1 income findex_std_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 missing_age_0 missing_neg1 missing_zip_income, absorb(absorbid2)  cluster(office)

* Age/homeowner + Panel D 
areg discharge z_ij_pooled age_0 homeflag2_neg1 income findex_std_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1 missing_zip_income, absorb(absorbid2)  cluster(office)

* With all controls
areg discharge z_ij_pooled  age_0 homeflag2_neg1 income findex_std_neg1   revtotbl_tc_neg1 agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1  revratio_tc_neg1  nonmortinq6_tc_neg1 missing_age_0 missing_neg1 missing_zip_income, absorb(absorbid2)  cluster(office)


****************************************************************
*	Table 3 Main Results 
**************************************************************** ;
use "$data/inputAllData_analysis_reshape_Feb2016.dta" if sample==1

gen roundage_0 = round(age_0, 5)
xi, pre(r_a_) i.roundage_0


** creating baseline financial strain index with 8 components
foreach var in forecl12_ind_neg1 repo12_ind_neg1 chgoff12_ind_neg1 lien12_ind_neg1 collec12_ind_neg1 jdgst12h_ind_neg1 bankin12_ind_neg1 cur2gn12_ind_neg1{
	sum `var' if discharge==0 & missing_neg1==0
	local mean_`var' = string(r(mean), "%12.3f") 
	local sd_`var' = string(r(sd), "%12.3f") 
}

foreach var in forecl12_ind_neg1 repo12_ind_neg1 chgoff12_ind_neg1 lien12_ind_neg1 collec12_ind_neg1 jdgst12h_ind_neg1 bankin12_ind_neg1 cur2gn12_ind_neg1 {
	gen `var'_std = (`var' - `mean_`var'')/(`sd_`var'') if missing_neg1==0
}

gen findex_neg1 = (forecl12_ind_neg1_std +  repo12_ind_neg1_std +  chgoff12_ind_neg1_std +  lien12_ind_neg1_std +  collec12_ind_neg1_std +  jdgst12h_ind_neg1_std +  bankin12_ind_neg1_std +  cur2gn12_ind_neg1_std)/8
sum findex_neg1 if discharge==0 & missing_neg1==0
	local mean_findex_neg1 = string(r(mean), "%12.3f") 
	local sd_findex_neg1 = string(r(sd), "%12.3f") 
gen findex_std_neg1 = (findex_neg1 - `mean_findex_neg1')/(`sd_findex_neg1')

** creating baseline financial strain index with 6 components
gen findex_neg1_6 = (forecl12_ind_neg1_std +  repo12_ind_neg1_std +  lien12_ind_neg1_std +  collec12_ind_neg1_std +  jdgst12h_ind_neg1_std  +  cur2gn12_ind_neg1_std)/6
sum findex_neg1_6 if discharge==0 & missing_neg1==0
	local mean_findex_neg1_6 = string(r(mean), "%12.3f") 
	local sd_findex_neg1_6 = string(r(sd), "%12.3f") 
gen findex_std_neg1_6 = (findex_neg1_6 - `mean_findex_neg1_6')/(`sd_findex_neg1_6')


foreach var in findex_std  {
replace `var'_neg1 = 0 if missing_neg1==1
}


** creating financial strain index 0-4 years

foreach var in forecl12_ind_neg1 repo12_ind_neg1 chgoff12_ind_neg1 lien12_ind_neg1 collec12_ind_neg1 jdgst12h_ind_neg1 bankin12_ind_neg1 cur2gn12_ind_neg1{
	sum `var' if discharge==0 & missing_neg1==0
	local mean_`var' = string(r(mean), "%12.3f") 
	local sd_`var' = string(r(sd), "%12.3f") 
}

foreach var in forecl12_ind repo12_ind  lien12_ind collec12_ind jdgst12h_ind cur2gn12_ind chgoff12_ind bankin12_ind {
foreach timeperiod in neg2 0 1 2 3 4 5 6 7 {
	gen `var'_`timeperiod'_std = (`var'_`timeperiod' - `mean_`var'_neg1')/(`sd_`var'_neg1')
}
}

gen findex_0 = (forecl12_ind_0_std +  repo12_ind_0_std +  lien12_ind_0_std +  collec12_ind_0_std +  jdgst12h_ind_0_std +  cur2gn12_ind_0_std)/6
sum findex_neg1_6 if discharge==0 & missing_neg1==0
	local mean_findex_neg1_6 = string(r(mean), "%12.3f") 
	local sd_findex_neg1_6 = string(r(sd), "%12.3f") 
gen findex_0_std = (findex_0 - `mean_findex_neg1_6')/(`sd_findex_neg1_6')

foreach timeperiod in neg2 1 2 3 4 5 6 7 {
gen findex_`timeperiod' = (forecl12_ind_`timeperiod'_std +  repo12_ind_`timeperiod'_std +  chgoff12_ind_`timeperiod'_std +  lien12_ind_`timeperiod'_std +  collec12_ind_`timeperiod'_std +  jdgst12h_ind_`timeperiod'_std +  bankin12_ind_`timeperiod'_std +  cur2gn12_ind_`timeperiod'_std)/8
sum findex_neg1 if discharge==0 & missing_neg1==0
	local mean_findex_neg1 = string(r(mean), "%12.3f") 
	local sd_findex_neg1 = string(r(sd), "%12.3f") 
gen findex_`timeperiod'_std = (findex_`timeperiod' - `mean_findex_neg1')/(`sd_findex_neg1')
}
egen findex_0_4_std = rowmean(findex_0_std findex_1_std findex_2_std findex_3_std findex_4_std)
egen findex_5_7_std = rowmean(findex_5_std findex_6_std findex_7_std)


* dismissed mean
sum  findex_0_4_std  revtotbl_0_4_tc agcolthb_0_4_tc mortin12_ind_0_4 trdbalnm_0_4_tc autopv6_ind_0_4 autbalt_0_4_tc  revratio_0_4_tc  nonmortinq6_0_4_tc score_0_4  if discharge==0


***** 2SLS estimates 0-4 years
* No controls
foreach var of varlist  findex_0_4_std  revtotbl_0_4_tc agcolthb_0_4_tc mortin12_ind_0_4 trdbalnm_0_4_tc autopv6_ind_0_4 autbalt_0_4_tc  revratio_0_4_tc  nonmortinq6_0_4_tc    {
xtivreg2 `var' (discharge = z_ij_pooled),  fe i(absorbid2) cluster(office)
}

* With controls
foreach var of varlist findex_0_4_std  revtotbl_0_4_tc agcolthb_0_4_tc mortin12_ind_0_4 trdbalnm_0_4_tc autopv6_ind_0_4 autbalt_0_4_tc  revratio_0_4_tc  nonmortinq6_0_4_tc    {
xtivreg2 `var' (discharge = z_ij_pooled)  r_a_roundag_*  homeflag2_neg1  income findex_std_neg1  revtotbl_tc_neg1  agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1  missing_zip_income,  fe i(absorbid2) cluster(office)
}



***** 2SLS estimates 5-7 years

sum  findex_5_7_std  revtotbl_5_7_tc agcolthb_5_7_tc mortin12_ind_5_7 trdbalnm_5_7_tc autopv6_ind_5_7 autbalt_5_7_tc  revratio_5_7_tc  nonmortinq6_5_7_tc  if discharge==0

* No controls
foreach var in  findex_5_7_std  revtotbl_5_7_tc agcolthb_5_7_tc mortin12_ind_5_7 trdbalnm_5_7_tc autopv6_ind_5_7 autbalt_5_7_tc  revratio_5_7_tc  nonmortinq6_5_7_tc {
xtivreg2 `var' (discharge = z_ij_pooled) ,  fe i(absorbid2) cluster(office)
	}
	
* With controls
foreach var in  findex_5_7_std  revtotbl_5_7_tc agcolthb_5_7_tc mortin12_ind_5_7 trdbalnm_5_7_tc autopv6_ind_5_7 autbalt_5_7_tc  revratio_5_7_tc  nonmortinq6_5_7_tc  {
xtivreg2 `var' (discharge = z_ij_pooled)  r_a_roundag_*  homeflag2_neg1 income  findex_std_neg1  revtotbl_tc_neg1  agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1  missing_zip_income,  fe i(absorbid2) cluster(office)
	}		
	


****************************************************************
*	Table 4 - Subsample Results
**************************************************************** ;


use "$data/inputAllData_analysis_reshape_Feb2016.dta" if sample==1
gen roundage_0 = round(age_0, 5)
xi, pre(r_a_) i.roundage_0

* generate groups if not already defined
gen age_25_40 = age_0>=25 & age_0<40  if missing_age_0==0
gen age_40_60 = age_0>=40 & age_0<60  if missing_age_0==0
gen age_60_up = age_0>=60  if missing_age_0==0

egen tmp_median_score = median(score_neg1) if missing_neg1==0  & missing_score_neg1==0
gen fscore = score_neg1>= tmp_median_score if missing_neg1==0 & missing_score_neg1==0

gen home = homeflag2_neg1 if missing_neg1==0
gen equity = hmequity2_neg1 if missing_neg1==0

egen tmp_median_findex = median(findex_std_neg1) if missing_neg1==0
gen aboveindex = findex_std_neg1>= tmp_median_findex if missing_neg1==0


* create discharge and z variables

	gen discharge_25 = discharge* age_25_40
	gen z_ij_pooled_25 = z_ij_pooled* age_25_40
	gen discharge_40 = discharge* age_40_60
	gen z_ij_pooled_40 = z_ij_pooled* age_40_60
	gen discharge_60 = discharge* age_60_up
	gen z_ij_pooled_60 = z_ij_pooled* age_60_up
	
	gen discharge_high = discharge* fscore
	gen discharge_low = discharge*(1-fscore)
	gen z_ij_pooled_high = z_ij_pooled* fscore
	gen z_ij_pooled_low = z_ij_pooled*(1-fscore)
	

	gen discharge_home = discharge*home
	gen discharge_nothome = discharge*(1-home)
	gen z_ij_pooled_home = z_ij_pooled*home
	gen z_ij_pooled_nothome = z_ij_pooled*(1-home)
	

	gen discharge_highindex = discharge*aboveindex
	gen discharge_lowindex = discharge*(1-aboveindex)
	gen z_ij_pooled_highindex = z_ij_pooled*aboveindex
	gen z_ij_pooled_lowindex = z_ij_pooled*(1-aboveindex)
	

sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc if age_25_40==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc if age_40_60==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc if age_60_up==1 & discharge==0

sum  findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc if fscore==1 & discharge==0
sum  findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc if fscore==0 & discharge==0

sum  findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc if home==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc if home==0 & discharge==0


*** 2SLS subsample results
foreach var in  findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc  {
xtivreg2 `var' (discharge_25 discharge_40 discharge_60 = z_ij_pooled_25 z_ij_pooled_40 z_ij_pooled_60) r_a_roundag_*  homeflag2_neg1 income  findex_std_neg1  revtotbl_tc_neg1  agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1  missing_zip_income,  fe i(absorbid2) cluster(office)

xtivreg2 `var' (discharge_high discharge_low  = z_ij_pooled_high z_ij_pooled_low) r_a_roundag_*  homeflag2_neg1 income  findex_std_neg1  revtotbl_tc_neg1  agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1  missing_zip_income,  fe i(absorbid2) cluster(office)

xtivreg2 `var' (discharge_home discharge_nothome = z_ij_pooled_home z_ij_pooled_nothome) r_a_roundag_*  homeflag2_neg1 income  findex_std_neg1  revtotbl_tc_neg1  agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1  missing_zip_income,  fe i(absorbid2) cluster(office)
}


****************************************************************
*	Table 5 and 6 - Subsample Results by State Laws
****************************************************************

gen judicial  = 0
replace judicial = 1 if court=="flsb" |court=="insb"|court=="kyeb"|court=="mab"|court=="nmb"|court=="ohsb"|court=="scb"

	gen discharge_jud_home = discharge*judicial*home	
	gen z_ij_pooled_jud_home = z_ij_pooled* judicial*home
	

	gen discharge_notjud_home = discharge*(1-judicial)*home
	gen z_ij_pooled_notjud_home = z_ij_pooled*(1-judicial)*home

	
	gen discharge_jud_nohome = discharge*judicial*(1-home)	
	gen z_ij_pooled_jud_nohome = z_ij_pooled* judicial*(1-home)
	
	gen discharge_notjud_nohome = discharge*(1-judicial)*(1-home)
	gen z_ij_pooled_notjud_nohome = z_ij_pooled*(1-judicial)*(1-home)

	

gen reposale = 0
replace reposale = 1 if court== "alnb" | court=="alsb" | court=="casb"|court=="ganb"|court=="mab"|court=="mieb"|court=="miwb"|court=="mnb"|court=="moeb"|court=="mowb"|court=="ncmb"|court=="nvb"|court=="orb"|court=="tneb" |court=="tnmb" | court=="tnwb"|court=="txwb"|court=="utb"|court=="vaeb"|court=="wawb"|court=="wieb"


	gen discharge_reposale = discharge*reposale
	gen discharge_notreposale = discharge*(1-reposale)
	gen z_ij_pooled_reposale = z_ij_pooled* reposale
	gen z_ij_pooled_notreposale = z_ij_pooled*(1-reposale)	
	
	
gen nonrecourse = 0
replace nonrecourse=1 if court=="casb"|court=="mnb"|court=="orb"|court=="wawb"|court=="wieb"

	gen discharge_nonrecourse = discharge*nonrecourse
	gen discharge_recourse = discharge*(1-nonrecourse)
	gen z_ij_pooled_nonrecourse = z_ij_pooled* nonrecourse
	gen z_ij_pooled_recourse = z_ij_pooled*(1-nonrecourse)


gen fedgarnishment = court=="alnb"|court=="alsb"|court=="casb"|court=="ganb"|court=="idb"|court=="insb"|court=="kyeb"|court=="mab"|court=="ncmb"|court=="nvb"|court=="ohsb"|court=="oknb"|court=="tneb"|court=="tnmb"|court=="tnwb"|court=="utb"|court=="vaeb"
gen nogarnishment = court=="flsb"|court=="scb"|court=="txwb"
gen highexempt = court=="mieb"|court=="miwb"|court=="mnb"|court=="nmb"|court=="orb"|court=="wawb"
gen lowcap = court=="moeb"|court=="mowb"|court=="wieb"


	gen discharge_fed = discharge* fedgarnishment
	gen z_ij_pooled_fed = z_ij_pooled* fedgarnishment
	gen discharge_nogarn = discharge* nogarnishment
	gen z_ij_pooled_nogarn = z_ij_pooled* nogarnishment
	gen discharge_highexempt = discharge* highexempt
	gen z_ij_pooled_highexempt = z_ij_pooled* highexempt
	gen discharge_lowcap = discharge* lowcap
	gen z_ij_pooled_lowcap = z_ij_pooled* lowcap

	
	gen discharge_garn = discharge* (1-nogarnishment)
	gen z_ij_pooled_garn = z_ij_pooled* (1-nogarnishment)
	
	gen discharge_nofed = discharge* (1-fedgarnishment)
	gen z_ij_pooled_nofed = z_ij_pooled* (1-fedgarnishment)

	
gen exemption = 10000 if court=="alnb"|court=="alsb"
replace exemption = 75000 if court=="casb"
replace exemption = 10000000000000 if court=="flsb"
replace exemption = 20000 if court=="ganb"
replace exemption = 50000 if court=="idb"
replace exemption = 15000 if court=="insb"
replace exemption = 10000 if court=="kyeb"
replace exemption = 300000 if court=="mab"
replace exemption = 34850 if court=="mieb" | court=="miwb"
replace exemption = 200000 if court=="mnb"
replace exemption = 8000 if court=="moeb" | court=="mowb"
replace exemption = 20000 if court=="ncmb"
replace exemption = 60000 if court=="nmb"
replace exemption = 125000 if court=="nvb"
replace exemption = 10000 if court=="ohsb"
replace exemption = 10000000000000 if court=="oknb"
replace exemption = 33000 if court=="orb"
replace exemption = 10000 if court=="scb"
replace exemption = 7500 if court=="tneb" | court=="tnmb" | court=="tnwb"
replace exemption = 10000000000000 if court=="txwb"
replace exemption = 40000 if court=="utb"
replace exemption = 10000 if court=="vaeb"
replace exemption = 40000 if court=="wawb"
replace exemption = 40000 if court=="wieb"

gen ch7_minimum = (mortcrl_neg1*1000) - exemption
replace ch7_minimum = 0 if ch7_minimum<0 
	

	
	gen discharge_ch7 = discharge* ch7_minimum
	gen z_ij_pooled_ch7 = z_ij_pooled* ch7_minimum

gen highexemption = exemption>=15000

	gen discharge_highex_home = discharge*highexemption*home
	gen z_ij_pooled_highex_home = z_ij_pooled*highexemption*home
	
	gen discharge_highex_nohome = discharge*highexemption*(1-home)
	gen z_ij_pooled_highex_nohome = z_ij_pooled*highexemption*(1-home)
		
	gen discharge_lowex_home = discharge*(1-highexemption)*home
	gen z_ij_pooled_lowex_home = z_ij_pooled*(1-highexemption)*home
	
	gen discharge_lowex_nohome = discharge*(1-highexemption)*(1-home)
	gen z_ij_pooled_lowex_nohome = z_ij_pooled*(1-highexemption)*(1-home)
		


	
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4  if judicial==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4  if judicial==0 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if nonrecourse==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if nonrecourse==0 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if nogarnishment==0 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if nogarnishment==1 & discharge==0

sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if highexemption==1 & home==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if highexemption==0 & home==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if highexemption==1 & home==0 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if highexemption==0 & home==0 & discharge==0


sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if judicial==1 & home==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if judicial==0 & home==1 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if judicial==1 & home==0 & discharge==0
sum findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc score_0_4 if judicial==0 & home==0 & discharge==0

	
*** 2sls results by wage garnishment
foreach var in  findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc {
xtivreg2 `var' (discharge_garn discharge_nogarn = z_ij_pooled_garn z_ij_pooled_nogarn) r_a_roundag_*  homeflag2_neg1 income  findex_std_neg1  revtotbl_tc_neg1  agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1  missing_zip_income,  fe i(absorbid2) cluster(office)
test discharge_garn = discharge_nogarn
}
	
	
*** 2ls results by exemption

foreach var in  findex_0_4_std  revtotbl_0_4_tc  agcolthb_0_4_tc trdbalnm_0_4_tc autbalt_0_4_tc revratio_0_4_tc nonmortinq6_0_4_tc  {
xtivreg2 `var' (discharge_highex_home discharge_lowex_home discharge_highex_nohome discharge_lowex_nohome = z_ij_pooled_highex_home z_ij_pooled_lowex_home z_ij_pooled_highex_nohome z_ij_pooled_lowex_nohome) r_a_roundag_*  homeflag2_neg1 income  findex_std_neg1  revtotbl_tc_neg1  agcolthb_tc_neg1 mortin12_ind_neg1 trdbalnm_tc_neg1 autopv6_ind_neg1 autbalt_tc_neg1 revratio_tc_neg1  nonmortinq6_tc_neg1  missing_age_0 missing_neg1  missing_zip_income,  fe i(absorbid2) cluster(office)
test discharge_highex_home = discharge_lowex_home
test discharge_highex_nohome = discharge_lowex_nohome
}

	

	
