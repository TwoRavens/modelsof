
* -------------------------------------------------------------
	Build judge leniency variable
* ------------------------------------------------------------- 

clear
use "$data/input_data_august.dta"
destring assets prev chapter discharge june_add fee, replace
tostring harvardid, replace
drop dup index
duplicates tag zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev, gen(dup)
bys  zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev: gen index = _n if dup>0
replace index = 1 if dup==0
sort index zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev
save "$data/input_data_august.dta", replace


clear
use "$data/input_file_august.dta"

split file_date, parse("/")
destring file_date1, replace
destring file_date2, replace
destring file_date3, replace

* Drop any observations that have a duplicate - none in credit report data
duplicates tag harvardid file_date, gen(dup2)
drop if dup2>0
drop dup2

capture rename file_date1 file_month
capture rename file_date2 file_day
capture rename file_date3 file_year


** SAMPLE RESTRICTIONS
** dropping june add = 1 and file_year < 2002
drop if file_year<2002
drop if june_add==1
gen presample= file_year==2002 & file_month<=6
destring discharge, replace
drop if discharge==.

drop if file_date=="" | chapter==. | judge=="" | trustee=="" | judge=="none" | office=="" | court==""


* create end date variable using best available info
gen end_date = .
replace end_date = date(dismiss_date, "MDY") if end_date==. & dismiss_date!=""
replace end_date = date(discharge_date, "MDY") if end_date==. & discharge_date!=""
replace end_date = date(dec_date, "MDY") if end_date==. & dec_date!=""
replace end_date = date(close_date, "MDY") if end_date==. & close_date!=""
format end_date %d

* 283,334 individuals given to TU in this sample of filers, 29,471 from pre-sample

duplicates tag  zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev, gen(dup)
bys zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev: gen index = _n if dup>0
replace index = 1 if dup==0
sort index  zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev

merge 1:1 index zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev using "$data/input_data_august.dta"

gen merge = 0 
replace merge = 1 if _merge==3

gen merge_sample = 0
replace merge_sample = 1 if _merge==3 & sample==1


** regular Z
egen mean_j_pooled = mean(discharge), by(judge office) 
egen obs_j_pooled = count(discharge), by(judge office) 
egen mean_c_pooled = mean(discharge) , by(office) 
egen obs_c_pooled = count(discharge) , by(office) 
gen z_ij_pooled = (mean_j_pooled*obs_j_pooled - discharge) / (obs_j_pooled-1)  - (mean_c_pooled*obs_c_pooled - discharge) / (obs_c_pooled-1) 

save "$data/input_data_file_august_merged_matched.dta", replace


 *-------------------------------------------------------------
*	Define analysis sample 
	
* ------------------------------------------------------------- ;
set more off
use "$data/inputAllData_Aug2014.dta"
*  4,963,421 obs

split file_date, parse("/")
destring file_date1, replace
destring file_date2, replace
destring file_date3, replace

* Drop any observations that have a duplicate - none in credit report data
duplicates tag harvardid file_date year, gen(dup2)
drop if dup2>0
drop dup2

* cleaning up filing dates
capture rename file_date1 file_month
capture rename file_date2 file_day
capture rename file_date3 file_year


** SAMPLE RESTRICTIONS
** dropping june add = 1 and file_year < 2002
drop if file_year<2002
drop if june_add=="1"
drop if file_year==2002 & file_month<=6
destring discharge, replace
drop if discharge==.

bys harvardid file_date: gen index = _n
bys harvardid : gen index2 = _n

* drop filings with missing information;
* dropped 0 obs
drop if file_date=="" | chapter=="" | judge=="" | trustee=="" | judge=="none" | office=="" | court==""


* finally drop if a judge sees less than 10 cases in an office - chapter - year combination

bys chapter office judge file_year: egen obs = count(discharge) if index==1


* create end date variable using best available info
gen end_date = .
replace end_date = date(dismiss_date, "MDY") if end_date==. & dismiss_date!=""
replace end_date = date(discharge_date, "MDY") if end_date==. & discharge_date!=""
replace end_date = date(dec_date, "MDY") if end_date==. & dec_date!=""
replace end_date = date(close_date, "MDY") if end_date==. & close_date!=""
format end_date %d



* ---------------------------------------------------------------------------------
*Renorming file dates because credit card pulls occur in June of each calendar year
* --------------------------------------------------------------------------------


gen file_year2 = .
replace file_year2 = file_year if file_month <= 6
replace file_year2 = file_year + 1 if file_month > 6



* -------------------------------------------------------------
*	Create misc control variables
* ------------------------------------------------------------- ;

* office by time of filing effects;
egen absorbid = group(office file_year)
egen absorbid2 = group(office file_year file_month)



* -------------------------------------------------------------
*	Keep key variables and drop the rest 
* ------------------------------------------------------------- 


rename score_2 score2

replace score = . if score==1 | score==2 | score==3

gen missing_age = age==0

replace curaddr = . if curaddr==999
replace automof = . if automof==999

gen deadflag2 = .
replace deadflag2 = 1 if deadflag=="Y"
replace deadflag2 = 0 if deadflag=="N"

gen homeflag2 = .
replace homeflag2 = 1 if homeflag=="Y"
replace homeflag2 = 0 if homeflag=="N"


gen hmequity2 = .
replace hmequity2 = 1 if hmequity=="Y"
replace hmequity2 = 0 if hmequity=="N"

gen studact2 = .
replace studact2 = 1 if studact=="Y"
replace studact2 = 0 if studact=="N"

gen studdef2 = .
replace studdef2 = 1 if studdef=="Y"
replace studdef2 = 0 if studdef=="N"




* indicators for foreclosures, repos, chargoffs, liens, collections, judgemnts, bankrupties**
foreach var in mortin12 auttrds autopv6 autopn6 cur2gn12 trdsat cmop2up jdgst12h bankin12 forecl12 lien12 chgoff12 repo12 collec12 foreclth repoth chrgoff lienth allcollc colle12h colxm12h rev12mth retopn12 retver12 retrev12 bkropen bkropn12 bkopen12 trdver12{
gen `var'_ind = 0 if `var'==0
replace `var'_ind = 1 if `var'>0
}	



* dollar amounts divided by 1000
foreach var in trdutlop revtotbl colbl12h colcrlth trdhghbl agcoltha agcolthb colamtth instrbal trdcl6 revaggcr bkrcrdlt bkavgbal bkagbal bkagblth trdbal trdbal6 trdbalm mrtagbal heqagbal autbalt rettot12  bkavgcl bkhicrlm{
replace `var' = `var'/1000
}

** nonmortgage balances from trdbal and trdbalm
gen trdbalnm = trdbal - trdbalm


gen sample0 = year - file_year2 == 0

gen sample1 = year - file_year2 == 1
gen sample2 = year - file_year2 == 2
gen sample3 = year - file_year2 == 3
gen sample4 = year - file_year2 == 4
gen sample5 = year - file_year2 == 5
gen sample6 = year - file_year2 == 6
gen sample7 = year - file_year2 == 7


gen sampleneg1 = year - file_year2 == -1
gen sampleneg2 = year - file_year2 == -2
gen sampleneg3 = year - file_year2 == -3
gen sampleneg4 = year - file_year2 == -4
gen sampleneg5 = year - file_year2 == -5


** creating variables for each year -4 to 5


foreach var in age  automof mortin12_ind auttrds_ind autopv6_ind autopn6_ind  revtotbl colbl12h colcrlth mortinq6 numinq6 revratio mortutil agcoltha agcolthb trdbalnm trdbal trdbal6 cur2gn12 cur2gn12_ind cmop2up cmop2up_ind judgsuih jdgst12h jdgst12h_ind trdutil autopv6 numinq12 bkitnum instrbal mortin12 autopn6 trdsat trdsat_ind  trdcl6 revaggcr bkrcrdlt  rev12mth retopn12 retver12 retrev12 bkropen bkropn12 bkopen12 trdver12 bkavgbal rev12mth_ind retopn12_ind retver12_ind retrev12_ind bkropen_ind bkropn12_ind bkopen12_ind trdver12_ind curaddr bankin12 bankin12_ind forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind forecl12 lien12 chgoff12 repo12 collec12 colle12h colxm12h  hmequity2 studact2 studdef2 agbkrupt lienth rellien satlien paidjudg unpdjudg allcollc colamtth trdcnt trdopn auttrds bkhicrlm bkavgcl heqnum heqagbal homeflag2  deadflag2 paidcol unpdcol bktrades bkagbal autbalt trdbalm mortgnum mrtagbal score cmop4up cmop5up {
foreach timeperiod in neg4 neg3 neg2 neg1 0 1 2 3 4 5 6 7{
bys harvardid : gen `var'_`timeperiod' = `var' if sample`timeperiod'==1
bys harvardid: egen temp = mean(`var'_`timeperiod')
replace `var'_`timeperiod' = temp if `var'_`timeperiod'==.
drop temp
}
} 



keep if index==1


save "$data/inputAllData_analysis_Feb2016.dta", replace

* number of medical collections

foreach timeperiod in 0 1 2 3 4 5 6 7{
gen colm12h_`timeperiod' = collec12_`timeperiod' - colxm12h_`timeperiod'
gen colm12h_ind_`timeperiod' = 0 if colm12h_`timeperiod'==0
replace colm12h_ind_`timeperiod' = 1 if colm12h_`timeperiod'>0
}
egen colm12h_0_4 = rowmean(colm12h_0 colm12h_1 colm12h_2 colm12h_3 	colm12h_4) 
egen colm12h_ind_0_4 = rowmean(colm12h_ind_0 colm12h_ind_1 colm12h_ind_2 colm12h_ind_3 	colm12h_ind_4) 


** creating outcome variables averaging 0-4 years post-filing

foreach var in  automof mortin12_ind auttrds_ind autopv6_ind autopn6_ind  revtotbl colbl12h colcrlth mortinq6 numinq6 revratio mortutil agcoltha agcolthb trdbalnm trdbal trdbal6 cur2gn12 cur2gn12_ind cmop2up cmop2up_ind judgsuih jdgst12h jdgst12h_ind trdutil autopv6 numinq12 bkitnum instrbal mortin12 autopn6 trdsat trdsat_ind  trdcl6 revaggcr bkrcrdlt  rev12mth retopn12 retver12 retrev12 bkropen bkropn12 bkopen12 trdver12 bkavgbal rev12mth_ind retopn12_ind retver12_ind retrev12_ind bkropen_ind bkropn12_ind bkopen12_ind trdver12_ind curaddr bankin12 bankin12_ind forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind forecl12 lien12 chgoff12 repo12 collec12 colle12h colxm12h  hmequity2 studact2 studdef2 agbkrupt lienth rellien satlien paidjudg unpdjudg allcollc colamtth trdcnt trdopn auttrds bkhicrlm bkavgcl heqnum heqagbal homeflag2  deadflag2 paidcol unpdcol bktrades bkagbal autbalt trdbalm mortgnum mrtagbal score cmop4up cmop5up {
egen `var'_0_4 = rowmean(`var'_0 `var'_1 `var'_2 `var'_3 	`var'_4) 
egen `var'_5_7 = rowmean(`var'_5 `var'_6 `var'_7) 
}


** creating outcome variables averaging 1-4 years post-filing

foreach var in  automof mortin12_ind auttrds_ind autopv6_ind autopn6_ind  revtotbl colbl12h colcrlth mortinq6 numinq6 revratio mortutil agcoltha agcolthb trdbalnm trdbal trdbal6 cur2gn12 cur2gn12_ind cmop2up cmop2up_ind judgsuih jdgst12h jdgst12h_ind trdutil autopv6 numinq12 bkitnum instrbal mortin12 autopn6 trdsat trdsat_ind  trdcl6 revaggcr bkrcrdlt  rev12mth retopn12 retver12 retrev12 bkropen bkropn12 bkopen12 trdver12 bkavgbal rev12mth_ind retopn12_ind retver12_ind retrev12_ind bkropen_ind bkropn12_ind bkopen12_ind trdver12_ind curaddr bankin12 bankin12_ind forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind forecl12 lien12 chgoff12 repo12 collec12 colle12h colxm12h  hmequity2 studact2 studdef2 agbkrupt lienth rellien satlien paidjudg unpdjudg allcollc colamtth trdcnt trdopn auttrds bkhicrlm bkavgcl heqnum heqagbal homeflag2  deadflag2 paidcol unpdcol bktrades bkagbal autbalt trdbalm mortgnum mrtagbal score cmop4up cmop5up {
egen `var'_1_4 = rowmean(`var'_1 `var'_2 `var'_3 	`var'_4) 
}

** building cumulative variables 0-4 years post-filing
foreach	var in mortin12_ind auttrds_ind autopv6_ind autopn6_ind homeflag2 deadflag2 cur2gn12 cur2gn12_ind jdgst12h jdgst12h_ind bankin12 bankin12_ind   forecl12 lien12 chgoff12 repo12 collec12 forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind{
egen `var'_cum_4 = rowmax(`var'_0 `var'_1 `var'_2 `var'_3 	`var'_4)
egen `var'_cum_3 = rowmax(`var'_0 `var'_1 `var'_2 `var'_3 )
egen `var'_cum_2 = rowmax(`var'_0 `var'_1 `var'_2)
egen `var'_cum_1 = rowmax(`var'_0 `var'_1 )
gen `var'_cum_0 = `var'_0 
}

** building cumulative variables 1-4 years post-filing
foreach	var in mortin12_ind auttrds_ind autopv6_ind autopn6_ind homeflag2 deadflag2 cur2gn12 cur2gn12_ind jdgst12h jdgst12h_ind bankin12 bankin12_ind   forecl12 lien12 chgoff12 repo12 collec12 forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind{
egen `var'_cum_4_alt = rowmax(`var'_1 `var'_2 `var'_3 	`var'_4)
egen `var'_cum_3_alt = rowmax(`var'_1 `var'_2 `var'_3 )
egen `var'_cum_2_alt = rowmax(`var'_1 `var'_2)
egen `var'_cum_1_alt = rowmax(`var'_1 )
}
	
** building totals by 4 years years post-filing
foreach	var in  cur2gn12  jdgst12h bankin12   forecl12 lien12 chgoff12 repo12 collec12 {
gen `var'_tot_4 = `var'_0 +  `var'_1 + `var'_2 + `var'_3 + `var'_4
gen `var'_tot_4_alt = `var'_1 + `var'_2 + `var'_3 	+ `var'_4
}	

** creating baseline variables averaging 1-4 years pre-filing
** note this only captures people who filed 2002-2005
foreach var in  automof mortin12_ind auttrds_ind autopv6_ind autopn6_ind  revtotbl colbl12h colcrlth mortinq6 numinq6 revratio mortutil agcoltha agcolthb trdbalnm trdbal trdbal6 cur2gn12 cur2gn12_ind cmop2up cmop2up_ind judgsuih jdgst12h jdgst12h_ind trdutil autopv6 numinq12 bkitnum instrbal mortin12 autopn6 trdsat trdsat_ind  trdcl6 revaggcr bkrcrdlt  rev12mth retopn12 retver12 retrev12 bkropen bkropn12 bkopen12 trdver12 bkavgbal rev12mth_ind retopn12_ind retver12_ind retrev12_ind bkropen_ind bkropn12_ind bkopen12_ind trdver12_ind curaddr bankin12 bankin12_ind forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind forecl12 lien12 chgoff12 repo12 collec12 colle12h colxm12h  hmequity2 studact2 studdef2 agbkrupt lienth rellien satlien paidjudg unpdjudg allcollc colamtth trdcnt trdopn auttrds bkhicrlm bkavgcl heqnum heqagbal homeflag2  deadflag2 paidcol unpdcol bktrades bkagbal autbalt trdbalm mortgnum mrtagbal score cmop4up cmop5up {
egen `var'_baseline = rowmean(`var'_neg1 `var'_neg2 `var'_neg3 `var'_neg4) 
}




** creating baseline variables averaging -2 to -4 years post-filing

foreach var in  automof mortin12_ind auttrds_ind autopv6_ind autopn6_ind  revtotbl colbl12h colcrlth mortinq6 numinq6 revratio mortutil agcoltha agcolthb trdbalnm trdbal trdbal6 cur2gn12 cur2gn12_ind cmop2up cmop2up_ind judgsuih jdgst12h jdgst12h_ind trdutil autopv6 numinq12 bkitnum instrbal mortin12 autopn6 trdsat trdsat_ind  trdcl6 revaggcr bkrcrdlt  rev12mth retopn12 retver12 retrev12 bkropen bkropn12 bkopen12 trdver12 bkavgbal rev12mth_ind retopn12_ind retver12_ind retrev12_ind bkropen_ind bkropn12_ind bkopen12_ind trdver12_ind curaddr bankin12 bankin12_ind forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind forecl12 lien12 chgoff12 repo12 collec12 colle12h colxm12h  hmequity2 studact2 studdef2 agbkrupt lienth rellien satlien paidjudg unpdjudg allcollc colamtth trdcnt trdopn auttrds bkhicrlm bkavgcl heqnum heqagbal homeflag2  deadflag2 paidcol unpdcol bktrades bkagbal autbalt trdbalm mortgnum mrtagbal score cmop4up cmop5up {
egen `var'_neg2_neg4 = rowmean(`var'_neg2 `var'_neg3 `var'_neg4) 
}
	
	** creating baseline variables averaging -3 to -4 years post-filing

foreach var in  automof mortin12_ind auttrds_ind autopv6_ind autopn6_ind  revtotbl colbl12h colcrlth mortinq6 numinq6 revratio mortutil agcoltha agcolthb trdbalnm trdbal trdbal6 cur2gn12 cur2gn12_ind cmop2up cmop2up_ind judgsuih jdgst12h jdgst12h_ind trdutil autopv6 numinq12 bkitnum instrbal mortin12 autopn6 trdsat trdsat_ind  trdcl6 revaggcr bkrcrdlt  rev12mth retopn12 retver12 retrev12 bkropen bkropn12 bkopen12 trdver12 bkavgbal rev12mth_ind retopn12_ind retver12_ind retrev12_ind bkropen_ind bkropn12_ind bkopen12_ind trdver12_ind curaddr bankin12 bankin12_ind forecl12_ind lien12_ind chgoff12_ind repo12_ind collec12_ind forecl12 lien12 chgoff12 repo12 collec12 colle12h colxm12h  hmequity2 studact2 studdef2 agbkrupt lienth rellien satlien paidjudg unpdjudg allcollc colamtth trdcnt trdopn auttrds bkhicrlm bkavgcl heqnum heqagbal homeflag2  deadflag2 paidcol unpdcol bktrades bkagbal autbalt trdbalm mortgnum mrtagbal score cmop4up cmop5up {
egen `var'_neg3_neg4 = rowmean(`var'_neg3 `var'_neg4) 
}
	

*** indicators for observing homeownership for each period per person
foreach timeperiod in neg4 neg3 neg2 neg1 0 1 2 3 4 5 6 7{
gen home_ind_`timeperiod' = 0 if homeflag2_`timeperiod' ==.
replace home_ind_`timeperiod' = 1 if homeflag2_`timeperiod'!=.
}


* mortgage credit lines
foreach timeperiod in neg4 neg3 neg2 neg1 0 1 2 3 4 5 6 7{
gen mutil_`timeperiod' = mortutil_`timeperiod'/100
gen mortcrl_`timeperiod'  = trdbalnm_`timeperiod'/mutil_`timeperiod'
replace mortcrl_`timeperiod' = 0 if trdbalnm_`timeperiod' == 0
}
egen mortcrl_0_4 = rowmean(mortcrl_0 mortcrl_1 mortcrl_2 mortcrl_3 mortcrl_4)


**** non-mortgage inquiries
foreach timeperiod in neg4 neg3 neg2 neg1 0 1 2 3 4  5 6 7{
gen nonmortinq6_`timeperiod' = numinq6_`timeperiod' - mortinq6_`timeperiod'
}
egen nonmortinq6_0_4 = rowmean(nonmortinq6_0 nonmortinq6_1 nonmortinq6_2 nonmortinq6_3 nonmortinq6_4)
egen nonmortinq6_5_7 = rowmean(nonmortinq6_5 nonmortinq6_6 nonmortinq6_7)


** topcoding continuous outcome variables to -1 year 99th percentiles
foreach var in autopv6 autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
_pctile `var'_neg1, p(99)
local `var'_99 = r(r1)
}

foreach var in autopv6 autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
foreach timeperiod in neg2 neg1 0 1 2 3 4{
	gen `var'_tc_`timeperiod' = `var'_`timeperiod'
	replace `var'_tc_`timeperiod' = ``var'_99' if `var'_tc_`timeperiod' > ``var'_99'
	}
}


foreach var in autopv6 autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
foreach timeperiod in 5 6 7{
	gen `var'_tc_`timeperiod' = `var'_`timeperiod'
	replace `var'_tc_`timeperiod' = ``var'_99' if `var'_tc_`timeperiod' > ``var'_99'& `var'_tc_`timeperiod'!=.
	}
}

*** creating new average 0-4 year outcomes after topcoding
foreach var in autopv6 autbalt trdbalnm trdbalm revtotbl instrbal agcolthb rev12mth  mortin12 revaggcr mortcrl revratio mortutil nonmortinq6 mortinq6 {
egen `var'_0_4_tc = rowmean(`var'_tc_0 `var'_tc_1 `var'_tc_2 `var'_tc_3 `var'_tc_4) 
egen `var'_5_7_tc = rowmean(`var'_tc_5 `var'_tc_6 `var'_tc_7 ) 

}

** dummying out missing 
gen missing_neg1 = home_ind_neg1 ==0
foreach var in mortin12_ind autopv6_ind autbalt_tc homeflag2 score forecl12_ind repo12_ind lien12_ind collec12_ind  chgoff12_ind jdgst12h_ind bankin12_ind cur2gn12_ind  trdbalnm_tc trdbalm_tc revtotbl_tc instrbal_tc agcolthb_tc rev12mth_tc  mortin12_tc revaggcr_tc mortcrl_tc revratio_tc mortutil_tc nonmortinq6_tc mortinq6_tc  {
replace `var'_neg1 = 0 if missing_neg1==1 & `var'_neg1==.
}

gen missing_age_0 = age_0==0

gen missing_score_neg1 = score_neg1==.
replace score_neg1 = 0 if missing_score_neg1==1


gen sample = 0 
replace sample = 1 if homeflag2_0!=.	

save "$data/inputAllData_analysis_reshape_Feb2016.dta", replace
* 183,046 obs	
	

*** merging TU data to instrument calculated using full sample
drop index 
destring assets prev, replace
duplicates tag  zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev, gen(dup)
bys zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev: gen index = _n if dup>0
replace index = 1 if dup==0
sort index  zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev

merge 1:1 index zip_str file_date court office trustee judge discharge dismiss_date discharge_date close_date dec_date assets prev using "$data/input_data_file_august_merged_matched.dta"
save "$data/inputAllData_analysis_reshape_Feb2016.dta", replace

**** merging TU data to zipcode-income data
clear
use "$data/zip_income9811_filled.dta", clear
xtset, clear
gen zip_str = zip_code
tostring zip_str, replace
replace zip_str = "0" + zip_str if length(zip_str)==4

keep if year <=2002
collapse (mean) income, by(zip_str)
save zip_income, replace

clear
use "$data/inputAllData_analysis_reshape_Feb2016.dta", replace
merge m:1 zip_str using zip_income, gen(merge_zip)

drop if merge_zip==2
replace income= 0 if income==.

gen missing_zip_income = (income==0)
save "$data/inputAllData_analysis_reshape_Feb2016.dta", replace






