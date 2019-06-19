/********************************************************************************
*** NC-VA-SC-KY-MO-AR SBIR, State Match Program (SMP), DUNS/NETS Project-level dataset
*** Data building do file ***
********************************************************************************

Primary Data Sources:

1. SBIR award data for the following states - NC, VA, SC, KY, MO, AR.
	a. Phase I award activity from 2000 - 2010
	b. Phase II award activity from 2000 - 2014
	
	website: https://www.sbir.gov/sbirsearch/award/all

2. State Match Phase I & II Programmatic Activity for NC and KY
	a. NC Department of Commerce provided award level data from 2006 - 2010

	website: http://www.nccommerce.com/sti/grant-programs/one-nc-small-business-program
	
	b. KY Science and Technology Corporation provided award level data from 2007 - 2010
	
	website: http://www.kstc.com/

3. Lanahan handmatched the DUNS ID for the set of firms with a Phase I SBIR award 
from the sample using Hoover's Mergent Intellect. Lanahan had access to this proprietary
database through the University of North Carolina's library.

4. The authors purchased firm-level data from Don Walls & Associates. Primary sources
of data: National Establishment Time Series (NETS). The following link provides an
overview of the longitudinal database.

	http://maryannfeldman.web.unc.edu/data-sources/longitudinal-databases/national-establishment-time-series-nets/

********************************************************************************

Building Dataset Part I:

Appendix C.1 in the supplementary materials details the match procedure for this dataset.
There was no unique identifier between any of the data sources. Thus Lanahan relied 
on a series of string matches. Parts of the match procedure were automated; however,
every step was vetted with handmatching to ensure accuracy of the match.

1. Match Phase II awards to Phase I awards: based on firm name, title, abstract
2. Match State Match Phase I and Phase II awards to Phase I: based on firm name, title
3. Identify DUNS ID using SBIR firm name and address. Additional websearches were
	conducted to ensure accuracy of DUNS match
4. Contracted Don Walls & Associates automated the DUNS to NETS match 


Building Dataset Part II:

The code below details how Lanahan integrated these various data sources to complete
the data building process.

*******************************************************************************/
* Step 1: Append NC-VA-SC & KY-MO-AR SBIR, SMP, DUNS/NETS Project-level datasets
********************************************************************************
clear all
set more off 
set mem 1g
use "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC data rebuild/take 3/NC VA SC data ready to append.dta"
* 2765 Phase I projects in NC* study + 883 Phase I projects in KY* study = 3648 Phase I project total
append using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/KY data rebuild/KY MO AR data ready to append.dta"
save "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS appended.dta", replace

********************************************************************************
* Step 2: Clean up SBIR dataset (drop STTR projects and P2 preceding P1 matches) 
********************************************************************************
clear all
use "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS appended.dta"
gen sttr = 1 if Program == "STTR"
drop if sttr == 1
gen p1_to_p2_lag = p2year - p1year
* 5 Phase II projects precede Phase I year, so drop
drop if p1_to_p2_lag < 0
gen p1_to_smp1_lag = smp1year - p1year
drop if p1_to_smp1_lag < 0
* 1 SMP1 project precedes Phase I year, so drop
gen p2_to_smp2_lag = smp2year - p2year
drop if p2_to_smp2_lag < 0
drop sttr Program 
foreach var in p1_to_p2 p1_to_smp1 p2_to_smp2 {
recode `var' (.=0)
}
lab var p1_to_p2 "Phase I to Phase II time lag (yr)"
lab var p1_to_smp1 "Phase I to SMP-I time lag (yr)"
lab var p2_to_smp2 "Phase II to SMP-II time lag (year)"
* 3509 Phase I projects = 3648 - 132 (sttr) - 5 (p2 precede p1 year) - 1 (smp1 precede p1 year) - 1 (smp2 precede p2 year)

** REQUESTED NETS DATA FOR 3509 Phase I PROJECTS **

save "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS appended cleaned.dta", replace

********************************************************************************
* Step 3: Prep data for NETS data request
********************************************************************************
clear all
set more off 
set mem 1g
use "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS appended cleaned.dta"
sort firm_id
collapse DUNS_number, by (firm_id)

/* verification check
rename DUNS DUNS_verification
save "/Users/Lauren/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/DUNS & firm_id verification before send to match.dta", replace
merge m:m firm_id using "/Users/Lauren/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS appended cleaned.dta"
corr DUNS_number DUNS_verification
*/

** 909 firms in dataset, 109 do not have DUNS_number (12% missing DUNS_id)
drop if DUNS_number == 99
** 800 firms to match to NETS
save "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/DUNS & firm_id to match to NETS.dta", replace
*export excel using "/Users/Lauren/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/DUNS & firm_id to match to NETS.xlsx", firstrow(variables)

********************************************************************************
* Step 3.1: Merge in NETS data
********************************************************************************
*(a) note missing
clear all
use "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS appended cleaned.dta"
rename DunsNumber DunsNumber_destring
sum p1amt
merge m:m firm_id using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/NETS data/NETS v3a.dta"
* note: 172 projects have no DUNS info, so unable to assess if NETS is an option for these (95% have DUNS number)
drop _merge
*(b) p1year
sort firm_id 
merge m:m firm_id p1year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/NETS data/NETS v7a_p1.dta"
drop if _merge == 2
gen p1_NETS_match = 1 if _merge == 3
lab var p1_NETS_match "SBIR Phase I project matched to NETS on p1year"
drop _merge
* 2991 P1 projects matched to NETS (85%)
*(c) p2year
sort firm_id
merge m:m firm_id p2year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/NETS data/NETS v7a_p2.dta"
* 1179 P2 projects matched to NETS (86%)
drop if _merge == 2
gen p2_NETS_match = 1 if _merge == 3
lab var p2_NETS_match "SBIR Phase II project matched to NETS on p2year"
drop _merge
*(d) smp1year
sort firm_id
merge m:m firm_id smp1year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/NETS data/NETS v7a_smp1.dta"
* 231 SMP-I projects matched to NETS (90%)
drop if _merge == 2
gen smp1_NETS_match = 1 if _merge == 3
lab var smp1_NETS_match "SMP-I project matched to NETS on smp1year"
drop _merge
*(d) smp2year
sort firm_id
merge m:m firm_id smp2year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/NETS data/NETS v7a_smp2.dta"
* 29 SMP-II projects matched to NETS (88%)
drop if _merge == 2
drop _merge
save "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS NETS v1.dta", replace
*(e) firm characteristics (time invariant)
merge m:m firm_id p1year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/NETS data/NETS v7a_NETS.dta"
* 2991 P1 projects matched to NETS 
drop if _merge == 2
drop _merge

*(f) p2year_control (add so have NETS information for control group of firms that do not receive the P2 award)
** pull in control data that approximates p2year of activity for those firms that did not secure a P2 award
gen p1p2 = p2year - p1year
** on average there are ~1.2 years between P1 and P2 award
gen p2year_control = p1year + 1
lab var p2year_control "Estimation of P2 year (1 year after P1 award)"
sort firm_id
merge m:m firm_id p2year_control using"/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/NETS data/NETS v7a_p2_control.dta"
drop if _merge == 2
gen p2_control_NETS_match = 1 if _merge == 3
lab var p2_control_NETS_match "NETS matched to SBIR firm, approximating P2 period"
drop _merge
save "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS NETS v2.dta", replace

********************************************************************************
* Step 4: Label Variables
********************************************************************************
clear all
use "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS NETS v2.dta"

*(a) Drop p1 awards that fall out of the 2000 - 2010 timeframe 
drop if p1year > 2010
* 627 p1awards dropped (2882 total)

*(a.1) additional clean-up
recode phase2 (.=0)
recode smp1 (.=0)

*(b.1) create SBIR P1 capacity variable
sort firm_id 
by firm_id: gen p1capacity_total  = _N 
lab var p1capacity_total "Total number of P1 awards per firm over full time frame"
sort firm_id p1year
by firm_id p1year: gen p1capacity_annual  = _N 
lab var p1capacity_annual "Total number of P1 awards per firm per year"
sort firm_id
by firm_id: gen p1capacity_counter = _n
lab var p1capacity_counter "counter of the number of P1 awards per firm over the 10 yr span"
sort firm_id p1year
by firm_id p1year: egen counter = min(p1capacity_counter)
gen p1prior_capacity = counter - 1
lab var p1prior_capacity "Number of prior P1 awards per firm, not inlcuding current year"

*(b.2) create SBIR P2 capacity variable 
sort firm_id
by firm_id: egen p2capacity_total = sum(phase2)
lab var p2capacity_total "Total number of P2 awards per firm over the full time frame"
sort firm_id p2year
by firm_id p2year: gen p2capacity_annual = _N
replace p2capacity_annual = . if phase2 == 0
lab var p2capacity_annual "Total number of P2 awards per firm per year"
sort firm_id p2year
by firm_id: gen p2capacity_counter = _n if phase2 == 1
lab var p2capacity_counter "counter of the number of P2 awards per firm over the 10 yr span"

sort firm_id p2year
by firm_id p2year: egen counter2 = min(p2capacity_counter)
gen p2prior_capacity = counter2 - 1
lab var p2prior_capacity "Number of prior P2 awards, not inlcuding current year"

*(b.3) SBIR capacity dummies
sum p1capacity_total, detail
* allocate the distribution of dummies based on the spread of the data
gen p1_cap_1 = 1 if p1capacity_total < 5
recode p1_cap_1 (.=0)
lab var p1_cap_1 "Phase I capacity (less than 5)"
gen p1_cap_2 = 1 if p1capacity_total > 4 & p1capacity_total < 11
recode p1_cap_2 (.=0)
lab var p1_cap_2 "Phase I capacity (5 - 10)"
gen p1_cap_3 = 1 if p1capacity_total > 10 & p1capacity_total <26
recode p1_cap_3 (.=0)
lab var p1_cap_3 "Phase I capacity (11 - 25)"
gen p1_cap_4 = 1 if p1capacity_total > 25
recode p1_cap_4 (.=0)
lab var p1_cap_4 "Phase I capacity (greater than 25)"

*(c.1) deflate financial information -- 2005 baseline year
gen year = p1year
merge m:m year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/probit/Paper/Research Policy Submission/R&R/gdp price deflator.dta"
drop if _merge == 2
drop _merge
rename gdp_price_deflator gdp_deflator_p1
label var gdp_deflator_p1 "Fiscal yr GDP Implicit Price Deflators -- base yr 2005 (as of July 2013) for Phase 1 activity"
drop year
gen p1amt_pd = p1amt/gdp_deflator_p1
lab var p1amt_pd "SBIR Phase I Amt ($) price deflated"
gen year = p2year
merge m:m year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/probit/Paper/Research Policy Submission/R&R/gdp price deflator.dta"
drop if _merge == 2
drop _merge
rename gdp_price_deflator gdp_deflator_p2
label var gdp_deflator_p2 "Fiscal yr GDP Implicit Price Deflators -- base yr 2005 (as of July 2013) for Phase 2 activity"
gen p2amt_pd = p2amt/gdp_deflator_p2
lab var p2amt_pd "SBIR Phase II Amt ($) price deflated"
drop year
gen year = smp1year
merge m:m year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/probit/Paper/Research Policy Submission/R&R/gdp price deflator.dta"
drop if _merge == 2
drop _merge
rename gdp_price_deflator gdp_deflator_smp1
label var gdp_deflator_smp1 "Fiscal yr GDP Implicit Price Deflators -- base yr 2005 (as of July 2013) for SMP 1 activity"
drop year
gen smp1amt_pd = smp1amt/gdp_deflator_smp1
lab var p1amt_pd "SMP-I Amt ($) price deflated"
** pull for NETS data only (e.g. sales)
gen year = p2year_control
merge m:m year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/probit/Paper/Research Policy Submission/R&R/gdp price deflator.dta"
drop if _merge == 2
drop _merge
rename gdp_price_deflator gdp_deflator_p2year_control
label var gdp_deflator_p2year_control "Fiscal yr GDP Implicit Price Deflators -- base yr 2005 (as of July 2013) for Phase 2 CONTROL activity"
drop year

**recode missing for P2 and SMP1 variables
gen p2amt_pd_recode = p2amt_pd
recode p2amt_pd_recode (.=0)
gen smp1amt_pd_recode = smp1amt_pd
recode smp1amt_pd_recode (.=0)
lab var p2amt_pd_recode "SBIR Phase II Amt ($) price deflated (missing coded as 0)"
lab var smp1amt_pd_recode "SMP-I Amt ($) price deflated (missing coded as 0)"

*(c.2) adjust sales variables from NETS
gen sales_p1yr_pd = Sales_p1year/gdp_deflator_p1
gen sales_p2yr_pd = Sales_p2year/gdp_deflator_p2
gen sales_smp1yr_pd = Sales_smp1year/gdp_deflator_smp1
gen sales_p2yr_control_pd = Sales_p2year_control/gdp_deflator_p2year_control
lab var sales_p1yr_pd "Firm sales in p1yr ($), price deflated"
lab var sales_p2yr_pd "Firm sales in p2yr ($), price defalted"
lab var sales_smp1yr_pd "Firm sales in smp1yr ($), price deflated"
lab var sales_p2yr_control_pd "Firm sales in p2yr_control ($), price deflated"
gen sales_p2yr_pd_full = sales_p2yr_pd
replace sales_p2yr_pd_full = sales_p2yr_control_pd if sales_p2yr_pd == .
lab var sales_p2yr_pd_full "Firm sales in p2yr period (pd), yr estimated for firms w/o P2 award"


*(c.3) adjust $1k, $10k and log form
foreach x in p1amt_pd p2amt_pd smp1amt_pd p2amt_pd_recode smp1amt_pd_recode sales_p1yr_pd sales_p2yr_pd sales_smp1yr_pd sales_p2yr_pd_full{
gen `x'_10k = `x'/10000
lab var `x'_10k "`x' (in ten-thousands $)"
gen `x'_1k = `x'/1000
lab var `x'_1k "`x' (in thousands $)"
gen `x'_log = ln(`x')
lab var `x'_log "`x', logged"
}

*(d) create mills variables -- used for stratification, though p1capacity_total is also useful
gen mills_40 = 1 if p1capacity_total > 40
recode mills_40 (.=0)
lab var mills_40 "Mill: firm secured more than 40 SBIR Phase I awards over 10 yr time frame"
gen mills_10 = 1 if p1capacity_total > 10
recode mills_10 (.=0)
lab var mills_10 "Mill: firm secured more than 10 SBIR Phase I awards over 10 yr time frame"
gen mills_5 = 1 if p1capacity_total > 5
recode mills_5 (.=0)
lab var mills_5 "Mill: firm secured more than 5 SBIR Phase I awards over 10 yr time frame"
gen p1prior_dum = 1 if p1prior_capacity > 0
recode p1prior_dum (.=0)
lab var p1prior_dum "Prior P1 award, binary indicator"

*(e) CBSA location: pulled from HUD zip to cbsa crosswalk 
/*
clear all
use "/Users/Lauren/Dropbox/EDA 2014 (1)/TAAF/Hot Spots/zip to cbsa/zip cbsa crosswalk.dta"
sort zip
quietly by zip: gen dup = cond(_N==1,0,_n)
sum dup
gen dup_zip = 1 if dup > 0
drop if TOT_RATIO < 0.5 & dup_zip == 1
drop dup dup_zip
quietly by zip: gen dup = cond(_N==1,0,_n)
sum dup
gen dup_zip = 1 if dup > 0
drop if BUS_RATIO < 0.5 & dup_zip == 1
drop dup dup_zip
sort zip
quietly by zip: gen dup = cond(_N==1,0,_n)
sum dup
save "/Users/Lauren/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/zip cbsa crosswalk no dups.dta", replace
*/

sort zipcode
gen zip = zipcode
* 3133 obs with zip codes
recode zip (.=-9)
merge m:m zip using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/zip cbsa crosswalk no dups.dta" 
drop if _merge == 2
drop dup
gen project_id_unique = project_id
replace project_id_unique = project_id + 100000 if cohort == 1
sort project_id_unique
quietly by project_id_unique: gen dup = cond(_N==1,0,_n)
lab var project_id_unique "unique ID for Phase I awards, NC* (1); KY* (2), derived from project_id"
sum dup
gen cbsa = 1 if _merge == 3
recode cbsa (.=0)
lab var cbsa "firm is located in CBSA, derived from HUD database"

/*(e.1) create CBSA spillover capacity
sort CBSA
by CBSA: gen p1cbsa_capacity_total = _N
lab var p1cbsa_capacity_total "Total number of P1 awards per CBSA over full time frame"
replace p1cbsa_capacity_total = 0 if CBSA == .
sort CBSA p1year
by CBSA p1year: gen p1cbsa_capacity_annual = _N
lab var p1cbsa_capacity_annual "Total number of P1 awards per CBSA per year"
sort CBSA
by CBSA: gen p1cbsa_capacity_counter = _n
lab var p1cbsa_capacity_counter "counter of the number of P1 awards per CBSA over the 10 yr span"
sort CBSA p1year
by CBSA p1year: egen cbsa_counter = min(p1cbsa_capacity_counter)
gen p1prior_cbsa_capacity = cbsa_counter - 1
lab var p1prior_cbsa_capacity "Number of prior P1 awards, not including current year"
foreach var in p1cbsa_capacity_total p1cbsa_capacity_annual p1cbsa_capacity_counter cbsa_counter {
replace `var' = 0 if CBSA == 99999 | CBSA == .
} 
replace p1prior_cbsa = 0 if CBSA == 99999
replace p1prior_cbsa = 0 if CBSA == . 

*(e.2) CBSA info pulled from NETS data
gen cbsa_dum_nets = 1 if CBSA_NETS != ""
recode cbsa_dum_nets (.=0)
lab var cbsa_dum_nets "Firm located in CBSA (binary), derived from NETS"
*/

*(f) EPSCOR variable
gen epscor = 1 if state == "ky" | state == "ar" | state == "sc"
recode epscor (.=0)
lab var epscor "Firm located in EPSCoR state"
* year state designated as EPSCoR: AR (1980); KY (1985); SC (1980); MO became an epscor state in 2012, not coded in this analysis

*(g) Age of firm/ year established
gen yr_est = YearStart_NETS
destring yr_est, replace
lab var yr_est "Year established, reported from NETS"
gen out_of_bis = OutofBis_NETS
destring out_of_bis, replace
lab var out_of_bis "Out of Business, reported from NETS"
gen oob_dum = 1 if out_of_bis != .
recode oob_dum (.=0) if yr_est != .
lab var oob_dum "Out of Business dummy, computed only for projects matched to NETS"
gen firm_age = 2014 - yr_est
lab var firm_age "Firm age (2014 - year established)"

*(g.1) create dummies
sum yr_est, detail
gen age_1 = 1 if yr_est > 2005 & yr_est !=.
recode age_1 (.=0) if yr_est !=.
lab var age_1 "Firm established after 2005"
gen age_2 = 1 if yr_est > 1999 & yr_est < 2006
recode age_2 (.=0) if yr_est !=.
lab var age_2 "Firm established between 2000 - 2005"
gen age_3 = 1 if yr_est > 1989 & yr_est < 2000
lab var age_3 "Firm established between 1990 - 1999"
recode age_3 (.=0) if yr_est !=.
gen age_4 = 1 if yr_est < 1990 & yr_est !=.
recode age_4 (.=0) if yr_est !=.
lab var age_4 "Firm established before 1990"

*(h) Employment data
gen Emp_p2year_full = Emp_p2year
replace Emp_p2year_full = Emp_p2year_control if Emp_p2year == .
lab var Emp_p2year_full "Emp in p2yr period, yr estimated for firms w/o P2 award"
gen emp_ch_full = Emp_p2year_full - Emp_p1year
gen emp_ch = Emp_p2year - Emp_p1year
lab var emp_ch "employment change from p1year to p2year, derived from NETS (firms w P2 awards only)"

*(h.1) Size -- derived from employment data (create dummies)
sum Emp_p1year, detail
** worth noting that 10% of firms have less than 3 employees (really small)
gen size_1 = 1 if Emp_p1year < 5 & Emp_p1year !=.
recode size_1 (.=0) if Emp_p1year !=.
gen size_2 = 1 if Emp_p1year < 11 & Emp_p1year > 4
recode size_2 (.=0) if Emp_p1year !=.
gen size_3 = 1 if Emp_p1year > 10 & Emp_p1year < 31
recode size_3 (.=0) if Emp_p1year !=.
gen size_4 = 1 if Emp_p1year > 30 & Emp_p1year !=.
recode size_4 (.=0) if Emp_p1year !=.
lab var size_1 "Firm size, very small (less than 5 emp)"
lab var size_2 "Firm size, small (5 - 10 emp)"
lab var size_3 "Firm_size, medium (11 - 30 emp)"
lab var size_4 "firm_size, large (over 30 emp)"

*(j) Industrial classification
*(j.1) Industrial classification as defined by SBIR federal mission agency
* ~93% of projects are funded by one of the primary agencies (dod, hhs, nsf, nasa, or doe)
egen agency_group_id = group(agency)
gen primary_agency = 1 if agency== "dod"|agency=="hhs"|agency=="nsf"|agency=="nasa"|agency=="doe"
recode primary_agency (.=0)

gen dod = 1 if agency == "dod"
recode dod (.=0)
gen hhs = 1 if agency == "hhs"
recode hhs (.=0)
gen nsf = 1 if agency == "nsf"
recode nsf (.=0)
gen nasa = 1 if agency == "nasa"
recode nasa (.=0)
gen doe = 1 if agency == "doe"
recode doe (.=0)
gen other = 1 if primary_agency !=1
recode other (.=0)

egen ind_group_SIC3 = group(SIC3_NETS)
egen ind_group_SIC2 = group(SIC2_NETS)

*(j.2) create dummies based on 2 digit SIC codes
gen ind_1 = 1 if SIC2_NETS == "87"
lab var ind_1 "SIC2, Engineering (87*)"
recode ind_1 (.=0) if SIC2_NETS !=""
gen ind_2 = 1 if SIC2_NETS == "73"
lab var ind_2 "SIC2, Business Services (73*)"
recode ind_2 (.=0) if SIC2_NETS !=""
gen ind_3 = 1 if SIC2_NETS == "38"
lab var ind_3 "SIC2, Instruments (38*)"
recode ind_3 (.=0) if SIC2_NETS !=""
gen ind_4 = 1 if SIC2_NETS == "36"
lab var ind_4 "SIC2, Electronic (36*)"
recode ind_4 (.=0) if SIC2_NETS !=""
gen ind_5 = 1 if SIC2_NETS !="87"&SIC2_NETS!="73"&SIC2_NETS!="38"&SIC2_NETS!="36"&SIC2_NETS!=""
recode ind_5 (.=0) if SIC2_NETS !=""
lab var ind_5 "SIC2, other (not 87, 73, 38, or 36)"

*(j.3) create dummies based on SIC major classifications (Source: https://www.osha.gov/pls/imis/sic_manual.html)
gen ind_div_a = 1 if SIC2_NETS=="01"|SIC2_NETS=="02"|SIC2_NETS=="07"|SIC2_NETS=="09"
recode ind_div_a (.=0) if SIC2_NETS !=""
lab var ind_div_a "Agriculture, Forestry, and Fishing"
gen ind_div_c = 1 if SIC2_NETS=="16"|SIC2_NETS=="17"
recode ind_div_c (.=0) if SIC2_NETS !=""
lab var ind_div_c "Construction"
gen ind_div_d = 1 if SIC2_NETS=="20"|SIC2_NETS=="22"|SIC2_NETS=="24"|SIC2_NETS=="27"|SIC2_NETS=="28"|///
SIC2_NETS=="30"|SIC2_NETS=="32"|SIC2_NETS=="33"|SIC2_NETS=="34"|SIC2_NETS=="35"|SIC2_NETS=="36"|///
SIC2_NETS=="37"|SIC2_NETS=="38"|SIC2_NETS=="39"
recode ind_div_d (.=0) if SIC2_NETS !=""
lab var ind_div_d "Manufacturing"
gen ind_div_e = 1 if SIC2_NETS=="45"|SIC2_NETS=="48"|SIC2_NETS=="49"
recode ind_div_e (.=0) if SIC2_NETS !=""
lab var ind_div_e "Transportation"
gen ind_div_f = 1 if SIC2_NETS=="50"|SIC2_NETS=="51"|SIC2_NETS=="52"|SIC2_NETS=="55"|SIC2_NETS=="57"|SIC2_NETS=="59"
recode ind_div_f (.=0) if SIC2_NETS !=""
lab var ind_div_f "Trade"
gen ind_div_h = 1 if SIC2_NETS=="67"
recode ind_div_h (.=0) if SIC2_NETS !=""
lab var ind_div_h "Finance"
gen ind_div_i = 1 if SIC2_NETS=="73"|SIC2_NETS=="80"|SIC2_NETS=="82"|SIC2_NETS=="83"|SIC2_NETS=="86"|///
SIC2_NETS=="87"|SIC2_NETS=="89"
recode ind_div_i (.=0) if SIC2_NETS !=""
lab var ind_div_i "Services"

*(j.4) create NAICS codes
gen naics = NAICS_p1year
gen naics_2digit = regexs(0) if(regexm(naics, "[0-9][0-9]"))
gen naics_3digit = regexs(0) if(regexm(naics, "[0-9][0-9][0-9]"))
gen naics_4digit = regexs(0) if(regexm(naics, "[0-9][0-9][0-9][0-9]"))
destring naics, replace

gen ind_naics_1 = 1 if naics_4digit == "5417"
recode ind_naics_1 (.=0) if naics_4digit !=""
lab var ind_naics_1 "NAICS, Scientific R&D Services (5417*)"
gen ind_naics_2 = 1 if naics_4digit == "5413"
recode ind_naics_2 (.=0) if naics_4digit !=""
lab var ind_naics_2 "NAICS, Architectural & Engineering Services (5413*)"
gen ind_naics_3 = 1 if naics_4digit == "5415"
recode ind_naics_3 (.=0) if naics_4digit !=""
lab var ind_naics_3 "NAICS, Computer System Services (5415*)"
gen ind_naics_4 = 1 if naics_4digit=="5414"|naics_4digit=="5416"|naics_4digit == "5418"|naics_4digit == "5419"
recode ind_naics_4 (.=0) if naics_4digit !=""
lab var ind_naics_4 "NAICS, Other Services (541* not 5417;5413;5415)"
gen ind_naics_5 = 1 if naics_2digit=="33"
recode ind_naics_5 (.=0) if naics_2digit !=""
lab var ind_naics_5 "NAICS, Metal-related Manufacturing (33*)"
gen ind_naics_6 = 1 if naics_2digit=="32"|naics_2digit=="31"
recode ind_naics_6 (.=0) if naics_2digit !=""
lab var ind_naics_6 "NAICS, Nonmetal-related Manufacturing (31*; 32*)"
gen ind_naics_7 = 1 if naics_2digit=="11"|naics_2digit=="23"|naics_2digit=="42"|naics_2digit=="44"|naics_2digit=="45"|naics_2digit=="48"|naics_2digit=="49"|naics_2digit=="51"|naics_2digit=="56"|naics_2digit=="61"|naics_2digit=="62"|naics_2digit=="71"|naics_2digit=="81"|naics_2digit=="92"
recode ind_naics_7 (.=0) if naics_2digit !=""
lab var ind_naics_7 "NAICS, Other (not 31-33; 54)"

*(k) Woman owned established -- reported by SBIR data
gen woman_owned_sbir = 1 if WomanOwned =="Yes"
replace woman_owned_sbir = 0 if WomanOwned =="No"

*(l) interactions
*(l.1) small & young firms
gen small_young = age_1 * size_1
recode small_young (.=0) if size_1 !=.
lab var small_young "Young, small firm (est. after 2005, less than 5 employees)"
gen sm = size_1 + size_2
recode sm (.=0) if size_1 !=.
gen yg = age_1 + age_2
recode yg (.=0) if age_1 !=.
gen small_young1 = sm*yg
recode small_young1 (.=0) if size_1 !=.
lab var small_young1 "Young, small firm (est. after 2000, less than 10 employees)"

*(m) sales change dummy
gen sales_ch = sales_p2yr_pd_10k - sales_p1yr_pd_10k
gen sales_ch_dum = 1 if sales_ch > 0 & sales_ch != .
recode sales_ch_dum (.=0) if sales_ch !=.
lab var sales_ch_dum "Sales change from p2yr to p1yr, 1 if > 0, 0 otherwise (firms only with P2 award)"
gen sales_ch_full = sales_p2yr_pd_full_10k - sales_p1yr_pd_10k 
lab var sales_ch_full "Sales change from P2 to P1, p2yr approximated for unsuccessful firms"
gen sales_ch_full_dum = 1 if sales_ch_full > 0 & sales_ch_full != .
recode sales_ch_full_dum (.=0) if sales_ch_full !=.
lab var sales_ch_full_dum "Sales change from p2yr to p1yr, 1 if > 0, 0 otherwise (p2yr approximated)"

*(n) add in federal and industry funding from RP paper 1 (probit_sbir.do)
gen state_original = state
gen state_uc = upper(state)
drop state
rename state_uc state
sort state p1year
drop _merge
merge m:m state p1year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/federal & industry funding.dta"
drop if _merge == 2
drop _merge
rename state state_uc
rename state_original state
** variables: State revenue; Venture Capital; Federal Applied R&D
* level: tot_rev_nber_pd VCamt_C_level_RP_paper2_pd applied_RD_deflated_level
* log: tot_rev_nber_pd_log VCamt_C_level_RP_paper2_pd_log log_applied_RD_deflated

*(o) add in university funding (by zip)
sort zip p1year
merge m:m zip p1year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/University R&D by ZipCode cleaned.dta"
** only 271 matched 
drop if _merge == 2
drop _merge
lab var total_HE "Total HE exp (deflated) based on zip merge"
lab var total_HE_lag1 "Total HE exp, 1yr lag (deflated) based on zip merge"
lab var total_HE_lag2 "Total HE exp, 2yr lag (deflated) based on zip merge"
rename total_HE total_HE_zip
rename total_HE_lag1 total_HE_zip_lag1
rename total_HE_lag2 total_HE_zip_lag2

*clean up cbsa codes in main file
replace CBSA = 11700 if city == "asheville" & CBSA ==.
replace CBSA = 13980 if city == "bl" & CBSA ==.
replace CBSA = 13980 if city == "blackburg" & CBSA ==.
replace CBSA = 13980 if city == "blacksburg" & CBSA ==.
replace CBSA = 20500 if city == "carrboro" & CBSA ==.
replace CBSA = 39580 if city == "cary" & CBSA ==.
replace CBSA = 20500 if city == "ch" & CBSA ==.
replace CBSA = 20500 if city == "chapel hill" & CBSA ==.
replace CBSA = 16740 if city == "charlotte" & CBSA ==.
replace CBSA = 16820 if city == "charlottesville"
replace CBSA = 41180 if city == "chesterfield" & CBSA ==.
replace CBSA = 13980 if city == "christiansburg" & CBSA ==.
replace CBSA = 47894 if city == "clifton" & CBSA ==.
replace CBSA = 17900 if city == "columbia" & CBSA ==. & state =="sc"
replace CBSA = 17860 if city == "columbia" & CBSA ==. & state =="mo"
replace CBSA = 17140 if city == "covington" & CBSA ==.
replace CBSA = 20500 if city == "durham" & CBSA ==.
replace CBSA = 22220 if city == "fayetteville" & CBSA ==.
replace CBSA = 11700 if city == "fletcher" & CBSA ==.
replace CBSA = 24660 if city == "greensboro" & CBSA ==.
replace CBSA = 47260 if city == "hampton" & CBSA ==.
replace CBSA = 47894 if city == "herndon" & CBSA ==.
replace CBSA = 25940 if city == "hilton head" & CBSA ==.
replace CBSA = 25940 if city == "hilton head island" & CBSA ==.
replace CBSA = 30460 if city == "lexington" & CBSA ==.
replace CBSA = 31140 if city == "louisville" & CBSA ==.
replace CBSA = 39580 if city == "morrisville" & CBSA ==.
replace CBSA = 16700 if city == "north charleston" & CBSA ==.
replace CBSA = 13980 if city == "radford" & CBSA ==.
replace CBSA = 39580 if city == "raleigh" & CBSA ==.
replace CBSA = 40220 if city == "roanoke" & CBSA ==.
replace CBSA = 40620 if city == "rolla" & CBSA ==.
replace CBSA = 41180 if city == "saint louis" & CBSA ==.
replace CBSA = 47894 if city == "sp" & CBSA ==.
replace CBSA = 41180 if city == "st. charles" & CBSA ==.
replace CBSA = 41180 if city == "st. louis" & CBSA ==.
replace CBSA = 47894 if city == "warrenton" & CBSA ==.
replace CBSA = 47260 if city == "williamsburg" & CBSA ==.
replace CBSA = 47260 if city == "yorktown" & CBSA ==.
replace CBSA = 38060 if city == "chandler" & CBSA ==.
replace CBSA = 19260 if city == "danville" & CBSA ==.
replace CBSA = 29999 if city == "gallatin" & CBSA ==.
replace CBSA = 17900 if city == "irmo" & CBSA ==.
replace CBSA = 10620 if city == "locust" & CBSA ==.
replace CBSA = 47894 if city == "middleburg" & CBSA ==.
replace CBSA = 33980 if city == "newport" & CBSA ==. & state =="nc"
replace CBSA = 35100 if city == "oriental" & CBSA ==.
replace CBSA = 30460 if city == "sadieville" & CBSA ==.
replace CBSA = 44420 if city == "staunton" & CBSA ==.
replace CBSA = 51999 if city == "saltville"
replace CBSA = 51999 if city == "arvonia"
replace CBSA = 51999 if city == "colonial beach"
replace CBSA = 51999 if city == "locust grove"
replace CBSA = 05999 if city == "dermott"
replace CBSA = 29999 if city == "doniphan"
replace CBSA = 29999 if city == "leasburg"
replace CBSA = . if city == "irvine"
replace CBSA = . if city == "woodstock"

/*(p) add in university funding (by cbsa) -- more comprehensive than university RD by zip code
clear all
use "/Users/Lauren/Dropbox/Lauren Dissertation/University R&D/Lauren's sample states university R&D.dta"
sort cbsa year
collapse (sum) total totalhighereducationrdexpenditur deflatedtotalhighereducationrdex ///
 totalrdexpendituresinallfieldssu deflatedtotalrdexpendituresinall, by(cbsa year)
rename totalhighereducationrdexpenditur tot_HE_RD_exp_cbsa 
lab var tot_HE_RD_exp_cbsa "Total HE RD expenditure by cbsa (sum)"
rename deflatedtotalhighereducationrdex tot_HE_RD_exp_pd_cbsa
lab var tot_HE_RD_exp_pd_cbsa "Total HE RD expenditure by cbsa (sum, deflated)"
rename totalrdexpendituresinallfieldssu tot_RD_exp_all_cbsa
lab var tot_RD_exp_all_cbsa "Total RD expenditures in all fields by cbsa (sum)"
rename deflatedtotalrdexpendituresinall tot_RD_exp_all_pd_cbsa
lab var tot_RD_exp_all_pd_cbsa "Total RD expenditures in all fields by cbsa (sum, deflated)"
rename total tot_HE_cbsa
lab var tot_HE_cbsa "Total HE expenditures by cbsa (sum)"
rename cbsa CBSA
gen p1year = year
save "/Users/Lauren/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/HE RD by CBSA 97 - 11 cleaned.dta", replace 
*/

* cleaned file: "/Users/Lauren/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/HE RD by CBSA 97 - 11 cleaned.dta"
sort CBSA p1year
merge m:m CBSA p1year using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/HE RD by CBSA 97 - 11 cleaned.dta"
drop if _merge == 2
drop _merge
recode tot_HE_RD_exp_pd_cbsa (.=0)

* log university RD variables
foreach var of varlist tot_HE_RD_exp_cbsa tot_HE_RD_exp_pd_cbsa tot_RD_exp_all_cbsa tot_RD_exp_all_pd_cbsa {
gen `var'_log = ln(`var')
}
lab var p1prior_dum "Prior Phase I award (binary)"
lab var tot_HE_RD_exp_pd_cbsa_log "Total HE RD expenditure by cbsa (deflated, logged)"

*(q) -- was originally e.1 -- create CBSA spillover capacity
sort CBSA
by CBSA: gen p1cbsa_capacity_total = _N
lab var p1cbsa_capacity_total "Total number of P1 awards per CBSA over full time frame"
sort CBSA p1year
by CBSA p1year: gen p1cbsa_capacity_annual = _N
lab var p1cbsa_capacity_annual "Total number of P1 awards per CBSA per year"
sort CBSA
by CBSA: gen p1cbsa_capacity_counter = _n
lab var p1cbsa_capacity_counter "counter of the number of P1 awards per CBSA over the 10 yr span"
sort CBSA p1year
by CBSA p1year: egen cbsa_counter = min(p1cbsa_capacity_counter)
gen p1prior_cbsa_capacity = cbsa_counter - 1
lab var p1prior_cbsa_capacity "Number of prior P1 awards in cbsa, not including current year"
foreach var in p1cbsa_capacity_total p1cbsa_capacity_annual p1cbsa_capacity_counter cbsa_counter p1prior_cbsa_capacity{
replace `var' = 0 if CBSA == .
} 

*(r) CBSA activity, relative to state's SBIR activity
sort statecode
by statecode: gen p1st_capacity_total = _N
lab var p1st_capacity_total "Total number of P1 awards per state over full time frame"
sort statecode p1year
by statecode p1year: gen p1st_capacity_annual = _N
lab var p1st_capacity_annual "Total number of P1 awards per state per year"
gen cbsa_p1_state_ratio = p1cbsa_capacity_annual/p1st_capacity_annual
lab var cbsa_p1_state_ratio "Ratio of P1 awards CBSA to state per year"

save "/Users/Lauren/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS NETS v3.dta", replace

********************************************************************************
** add in yr established information. NETS did not have complete information on this variable,
** so Lanahan conducted a manual search to add in missing values. Have yr_est data on 96% of the sample.
********************************************************************************
clear all
use "/Users/Lauren/llanahan/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS NETS v3.dta"

** add in more yr_est variables, looked up establishment dates online (6/17/14)**
gen yr_est1 = 2004 if firm_id == 100026
replace yr_est1 = 1897 if firm_id == 200005
replace yr_est1 = 2007 if firm_id == 100028
replace yr_est1 = 2007 if firm_id == 100034
replace yr_est1 = 2010 if firm_id == 100035
replace yr_est1 = 1994 if firm_id == 100038
replace yr_est1 = 2005 if firm_id == 200028
replace yr_est1 = 1999 if firm_id == 100045
replace yr_est1 = 2001 if firm_id == 200035
replace yr_est1 = 1996 if firm_id == 100056
replace yr_est1 = 1973 if firm_id == 100059
replace yr_est1 = 2002 if firm_id == 100062
replace yr_est1 = 2000 if firm_id == 200043
replace yr_est1 = 1998 if firm_id == 100068
replace yr_est1 = 1817 if firm_id == 200048
replace yr_est1 = 2002 if firm_id == 100077
replace yr_est1 = 1993 if firm_id == 100078
replace yr_est1 = 2007 if firm_id == 100082
replace yr_est1 = 2008 if firm_id == 100086
replace yr_est1 = 2000 if firm_id == 100089
replace yr_est1 = 2004 if firm_id == 200058
replace yr_est1 = 2007 if firm_id == 200069
replace yr_est1 = 2006 if firm_id == 100123
replace yr_est1 = 1989 if firm_id == 200080
replace yr_est1 = 1994 if firm_id == 100142
replace yr_est1 = 1999 if firm_id == 100156
replace yr_est1 = 2001 if firm_id == 100160
replace yr_est1 = 1994 if firm_id == 100166
replace yr_est1 = 2006 if firm_id == 100168
replace yr_est1 = 2001 if firm_id == 100170
replace yr_est1 = 2003 if firm_id == 200090
replace yr_est1 = 1996 if firm_id == 200096
replace yr_est1 = 1995 if firm_id == 200099
replace yr_est1 = 1981 if firm_id == 100214
replace yr_est1 = 1997 if firm_id == 100196
replace yr_est1 = 2007 if firm_id == 100197
replace yr_est1 = 2000 if firm_id == 100200
replace yr_est1 = 1991 if firm_id == 100204
replace yr_est1 = 1999 if firm_id == 100219
replace yr_est1 = 2004 if firm_id == 200114
replace yr_est1 = 1990 if firm_id == 100227
replace yr_est1 = 1993 if firm_id == 200115
replace yr_est1 = 2008 if firm_id == 100233
replace yr_est1 = 2009 if firm_id == 100239
replace yr_est1 = 2002 if firm_id == 100240
replace yr_est1 = 1983 if firm_id == 100246
replace yr_est1 = 2004 if firm_id == 100248
replace yr_est1 = 1999 if firm_id == 100256
replace yr_est1 = 2004 if firm_id == 100264
replace yr_est1 = 1990 if firm_id == 100276
replace yr_est1 = 2005 if firm_id == 200127
replace yr_est1 = 1997 if firm_id == 100284
replace yr_est1 = 1995 if firm_id == 200130
replace yr_est1 = 1998 if firm_id == 100287
replace yr_est1 = 2006 if firm_id == 100294
replace yr_est1 = 2000 if firm_id == 100304
replace yr_est1 = 1997 if firm_id == 200140
replace yr_est1 = 2007 if firm_id == 100306
replace yr_est1 = 1999 if firm_id == 200143
replace yr_est1 = 2008 if firm_id == 200144
replace yr_est1 = 2003 if firm_id == 100314
replace yr_est1 = 1992 if firm_id == 100317
replace yr_est1 = 2008 if firm_id == 100328
replace yr_est1 = 2001 if firm_id == 100331
replace yr_est1 = 2005 if firm_id == 100334
replace yr_est1 = 2009 if firm_id == 100341
replace yr_est1 = 1998 if firm_id == 200157
replace yr_est1 = 2008 if firm_id == 100346
replace yr_est1 = 2001 if firm_id == 200164
replace yr_est1 = 2000 if firm_id == 100353
replace yr_est1 = 1985 if firm_id == 200166
replace yr_est1 = 1992 if firm_id == 200169
replace yr_est1 = 1998 if firm_id == 200172
replace yr_est1 = 2008 if firm_id == 100378
replace yr_est1 = 2010 if firm_id == 100387
replace yr_est1 = 2004 if firm_id == 200191
replace yr_est1 = 1998 if firm_id == 200192
replace yr_est1 = 2006 if firm_id == 200193
replace yr_est1 = 2000 if firm_id == 100403
replace yr_est1 = 1996 if firm_id == 100408
replace yr_est1 = 2003 if firm_id == 200205
replace yr_est1 = 2008 if firm_id == 200208
replace yr_est1 = 2008 if firm_id == 100421
replace yr_est1 = 2004 if firm_id == 100424
replace yr_est1 = 2003 if firm_id == 200215
replace yr_est1 = 1991 if firm_id == 200217
replace yr_est1 = 2003 if firm_id == 100435
replace yr_est1 = 1998 if firm_id == 200229
replace yr_est1 = 2008 if firm_id == 100445
replace yr_est1 = 1998 if firm_id == 100452
replace yr_est1 = 2001 if firm_id == 100457
replace yr_est1 = 2007 if firm_id == 100493
replace yr_est1 = 2004 if firm_id == 100496
replace yr_est1 = 2008 if firm_id == 100500
replace yr_est1 = 2003 if firm_id == 100512
replace yr_est1 = 2008 if firm_id == 100513
replace yr_est1 = 2008 if firm_id == 200250
replace yr_est1 = 1999 if firm_id == 100519
replace yr_est1 = 2004 if firm_id == 100526
replace yr_est1 = 2003 if firm_id == 100527
replace yr_est1 = 2002 if firm_id == 100530
replace yr_est1 = 2001 if firm_id == 100542
replace yr_est1 = 2010 if firm_id == 200259
replace yr_est1 = 2002 if firm_id == 100546
replace yr_est1 = 2004 if firm_id == 200269
replace yr_est1 = 1991 if firm_id == 200276
replace yr_est1 = 2005 if firm_id == 200277
replace yr_est1 = 2002 if firm_id == 200290
replace yr_est1 = 2005 if firm_id == 100611
replace yr_est1 = 1992 if firm_id == 100617
replace yr_est1 = 2005 if firm_id == 100623
replace yr_est1 = 1988 if firm_id == 200301
replace yr_est1 = 1991 if firm_id == 100639
** able to identify year founded for 96% of the sample

*Update age dummies
drop age_*
gen yr_est_full = yr_est
replace yr_est_full = yr_est1 if yr_est1 !=.

sum yr_est_full, detail
gen age_1 = 1 if yr_est_full > 2001 & yr_est_full !=.
recode age_1 (.=0) if yr_est_full !=.
lab var age_1 "Firm established after 2001"
gen age_2 = 1 if yr_est_full > 1997 & yr_est_full < 2002
recode age_2 (.=0) if yr_est_full !=.
lab var age_2 "Firm established between 1998 - 2001"
gen age_3 = 1 if yr_est_full > 1989 & yr_est_full < 1998
lab var age_3 "Firm established between 1990 - 1997"
recode age_3 (.=0) if yr_est_full !=.
gen age_4 = 1 if yr_est_full < 1990 & yr_est_full !=.
recode age_4 (.=0) if yr_est_full !=.
lab var age_4 "Firm established before 1990"

save "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS NETS v4.dta", replace

********************************************************************************
clear all 
use "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/SBIR SMP DUNS NETS v4.dta"
global dir "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data"

** Additional data cleaning 

* 	Add in employment data
sort project_id_unique
merge 1:1 project_id_unique using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/emp1_impute.dta"
drop _merge
gen emp_impute_dum = 1 if Emp_p1year == .
recode emp_impute_dum (.=0)

*	Identification: firm characteristics
gen WomanOwn_dum = 1
replace WomanOwn_dum = 0 if WomanOwned == "No"
gen HUB_dum = 1
replace HUB_dum = 0 if HUBZoneOwned == "No"
gen Minority_dum = 1
replace Minority_dum = 0 if MinorityOwned =="No"
lab var WomanOwn_dum "Woman Owned"
lab var HUB_dum "HUBZone"
lab var cbsa "CBSA"
lab var Minority_dum "Minority Owned"

* 	Cleaning of control variables, recode 0's as 1 so the value is not dropped when logged
foreach var in tot_HE_RD_exp_pd_cbsa VCamt_C_level_RP_paper2_pd {
gen `var'_0s = `var'
replace `var'_0s = 1 if `var'==0
gen `var'_ln = ln(`var'_0s)
}
lab var tot_HE_RD_exp_pd_cbsa_ln "HE R&D, adjusted (log form, per cbsa)"
lab var VCamt_C_level_RP_paper2_pd_ln "Venture Capital, adjusted (log form, per state)"
lab var log_applied_RD_deflated "Federal Applied R&D, adjusted (log form, per state)"
lab var phase2 "Secure Phase II"
lab var p1prior_capacity "Cumulative prior PI awards (per firm)"
lab var cbsa_p1_state_ratio "SBIR capacity"
lab var p1cbsa_capacity_annual "CBSA Phase I Annual Capacity"
global variables phase2 smp1 p1prior_capacity tot_HE_RD_exp_pd_cbsa_ln VCamt_C_level_RP_paper2_pd_ln log_applied_RD_deflated 
sum $variables
sum $variables if p1year > 2001
gen yr_est_full_impute = yr_est_full
replace yr_est_full_impute = p1year-6 if yr_est_full == .
gen yr_impute_dum = 1 if yr_est_full == .
recode yr_impute_dum (.=0)

gen DunNum_match = 1 if DunsNumber !=""
recode DunNum_match (.=0)



** Select varaibles for Lanahan & Feldman Analysis: the variables below are used for replication of project-level analysis.
keep phase2 p1prior_capacity p1year p2year smp1year WomanOwn_dum HUB_dum ///
Minority_dum p1cbsa_capacity_annual yr_est_full Emp_p1year agency smp1amt_pd_10k statecode ///
firm_id ind_naics_1 ind_naics_2 ind_naics_3 ind_naics_4 ind_naics_5 ind_naics_6 ind_naics_7 ///
state OutofBis NETS_match DunNum_match agency_group_id LastMove_NETS MoveYear_NETS ///
MoveYear_move_yr* State_NETS state_uc OriginState_NETS tot_HE_RD_exp_pd_cbsa_ln VCamt_C_level_RP_paper2_pd_ln ///
log_applied_RD_deflated cohort emp1_impute dod nsf hhs year smp1 p1capacity_total Emp_p2year_full firm_age
drop if p1year < 2002

save "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/Dataverse.dta", replace
export delimited using "/Users/llanahan/Dropbox/SBIRSTTR_data_analysis/firm level analysis/NC* & KY* appended data/Dataverse/SBIR project level data.csv", replace

END
















