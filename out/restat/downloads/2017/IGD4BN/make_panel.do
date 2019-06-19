

*this section cleans the MPD data - creates an hourly panel

clear
set more off


*has PSA

use  dccrime_2011.dta
append using  dccrime_2012.dta
append using  dccrime_2013.dta

g date = substr(start_date, 1, strpos(start_date, " ")-1)
g date_m = date(date, "MDY")
g year = year(date_m)
g hour = hh(clock(start_date, "MDYhm"))
g minute = mm(clock(start_date, "MDYhm"))

keep start_date date_m psa offense method hour minute year

drop if year < 2011

g gun = 0
	replace gun = 1 if method == "GUN"
g homicide = 0
	replace homicide = 1 if offense == "HOMICIDE"
g arson = 0
	replace arson = 1 if offense == "ARSON"
g awdw = 0
	replace awdw = 1 if offense == "ASSAULT W/DANGEROUS WEAPON"
g burglary = 0
	replace burglary = 1 if offense == "BURGLARY"
g mvt = 0
	replace mvt = 1 if offense == "MOTOR VEHICLE THEFT"
g rob = 0
	replace rob = 1 if offense == "ROBBERY"
g sex_ab = 0
	replace sex_ab = 1 if offense == "SEX ABUSE"
g theft = 0
	replace theft = 1 if offense == "THEFT F/AUTO" | offense == "THEFT/OTHER"
g violent = 0
	replace violent = 1 if homicide ==1 | awdw ==1| sex_ab ==1 | rob == 1

g one = 1
bys psa date_m hour: egen psa_num_hom = sum(homicide)
bys psa date_m hour: egen psa_num_rep = sum(one)
bys psa date_m hour: egen psa_num_gun = sum(gun)
bys psa date_m hour: egen psa_num_vio = sum(violent)

keep psa hour date_m psa_num_rep psa_num_gun psa_num_vio psa_num_hom
duplicates drop 

destring psa, replace force
drop if psa ==.
*occurs when psa is "unknown"

save  mpd_reports_panel.dta, replace

************************************************************************************

*this sections preps the SST data - creates an hourly panel

clear
set more off


insheet using  psa_ss_inc_join.txt

keep incident_i psa
rename incident_i incidentid
save  sst_inc_psa.dta, replace

clear
set more off

use  sst_incidents.dta

merge 1:1 incidentid using  sst_inc_psa.dta
drop _merge


g date = string(month)+"/"+string(day)+"/"+string(year)
g date_m = date(date, "MDY")

g mult_shot = 0
	replace mult_shot = 1 if type == "Multiple Gunshots"

bys psa date hour: egen psa_num_inc = count(year)
bys psa date hour: egen psa_num_mult_inc = sum(mult_shot)

*cleaning up panel
keep hour date_m psa psa_num_inc  
duplicates drop

drop if psa ==0


save  sst_activations_panel.dta, replace

************************************************************************************
**This sections preps the 911 calls

clear
set more off
set mem 4000m

use  calls911_psatract.dta

g date_st = string(eventdate, "%8.0f")
g date = substr(date_st,1,4)+"/"+substr(date_st,5,2)+"/"+substr(date_st,7,2)
g date_m = date(date, "YMD")
drop date_st

g hour = substr(datetimestamp, 9,2)
destring hour, replace

replace date_m = date_m - 1 if hour < 6


order psa date_m hour 

g one = 1
g mpd = 0
	replace mpd = 1 if agency == "MPD"
g gunshot = 0
	replace gunshot = 1 if eventtype == "GSHT"

bys psa date_m hour: egen num_calls = sum(one)
bys psa date_m hour: egen num_calls_mpd = sum(mpd)
bys psa date_m hour: egen num_calls_gunshot = sum(gunshot)

keep psa date_m hour num_calls num_calls_mpd num_calls_gunshot

duplicates drop

drop if psa ==0

save  calls_panel.dta, replace


************************************************************************************
*this section merges the SST, MPD, weather and 911 call data

clear
set more off 
clear matrix
clear mata
set mem 4000m

use  empty_panel.dta

merge 1:1 psa date_m hour using  mpd_reports_panel.dta
	drop if _merge == 2
	*4 mpd observation have no date, all others from PSAs without SST coverage
	drop _merge

merge 1:1 psa date_m hour using  sst_activations_panel.dta
	drop if _merge == 2
	drop _merge

merge 1:1 psa date_m hour using  calls_panel.dta
	drop if _merge == 2
	drop _merge	

*filling in zeros for hours with no gunshots and MPD crimes
foreach c in psa_num_hom psa_num_rep psa_num_gun psa_num_vio psa_num_inc num_calls num_calls_mpd num_calls_gunshot{
replace `c' = 0 if `c' == . 
}

merge m:1 date_m hour using  rain_hourly.dta
replace rain = 0 if rain ==. 
drop if _merge == 2
drop _merge

g year = year(date_m)

g doy = doy(date_m)
*leap years
replace doy = doy - 1 if (year == 2008 | year ==2012)

*for day fixed effects and such - ASSIGNING BEFORE 6 AM TO PREVIOUS DAY
replace doy = doy - 1 if hour < 6
replace date_m = date_m - 1 if hour < 6

g dow = dow(date_m)
*zero is sunday
g month = month(date_m)
g day = day(date_m)


* creating a dummy for the 11pm hour
g eleven = 0
replace eleven = 1 if hour == 23

*creating 2 groups for the 2 cutoffs
g start = 0
replace start = 1 if doy < 213
*Sept 1 cutoff
g end = 1-start

**** Making/normalizing running variable - depends on start vs end
g run_var_start = (-1)*(doy - 181) 
g run_var_end = doy - 244 

* creating treatment variables
g curfew_early = 0
	replace curfew_early = 1 if doy < 182 | doy > 243

g runvar_start_int = curfew_early * run_var_start
g runvar_end_int = curfew_early * run_var_end
	
*coding specific school start and end dates
g school = 0
	replace school = 1 if year == 2010 & (doy > 234 | doy < 174)
	replace school = 1 if year == 2011 & (doy > 233 | doy < 169)
	replace school = 1 if year == 2012 & (doy > 238 | doy < 166)
	replace school = 1 if year == 2013 & (doy > 237 | doy < 172)
	replace school = 1 if year == 2009 & (doy > 235 | doy < 167)
	replace school = 1 if year == 2008 & (doy > 236 | doy < 164)
	replace school = 1 if year == 2007 & (doy > 238 | doy < 166)
	replace school = 1 if year == 2006 & (doy > 239 | doy < 166)

	
egen psa_id = group(psa)
compress

g coverage = 0
replace coverage = 1 if district ==7 & (year > 2006 | (year == 2006 & month > 4))
replace coverage = 1 if district ==5 & (year > 2008 | (year == 2008 & month > 2))
replace coverage = 1 if district ==6 & (year > 2008 | (year == 2008 & month > 2))
replace coverage = 1 if district ==3 & (year > 2008 | (year == 2008 & month > 6))

keep if coverage == 1

*needed to merge weather after reassigning the before 6am hours - important for daily panel (not for hourly)
merge m:1 date_m using  weather.dta
	drop if _merge ==2
	drop _merge

	rename prcp prcpday
	drop snwd snow
	
rename rain prcp
save hourlypanel.dta, replace


