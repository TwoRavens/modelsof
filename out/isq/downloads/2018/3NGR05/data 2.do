/*	This creates the dyadic dataset for "Rewarding Human Rights?"
      from the monadic dataset.  

	Rich Nielsen, nielsen.rich@gmail.com
	Last modified: 24 July 2012   */

** This script assumes that you have changed the working directory
** to wherever you have opened the archive.
*** You'll want to enter the following directly from the command line: 
clear
set mem 600M
set more off
*cd "your/directory/here"


*I use Gleditsch's improved GDP var
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 
foreach NAME of local dnames {
   insheet using "data/expgdp_v5.0.asc", delimiter(" ")
   gen countryname_g="proper(countryname)"
   rename stateid countrycode_g
   run "data/Standardize Country Codes.do"
   move  countryname_g countrycode_g
   drop countrynumcode_g origin
   rename statenum countrynumcode_g
   sort  countryname_g year
   rename  pop population //(Units are in 1000's)
   rename  rgdpch rgdpc
   gen ln_population=ln(population)

   gen ln_population_sq=ln_population^2
   gen ln_rgdpc=ln(rgdpc)
   gen ln_rgdpc_sq=ln_rgdpc^2

   egen countrynum=group(countryname)
   tsset countrynum year

   gen rgdp=rgdpc*population
   gen rgdpcgrowth=((rgdpc-l.rgdpc)/l.rgdpc)*100
   gen rgdpgrowth=((rgdp-l.rgdp)/l.rgdp)*100
   rename countryname_g countryname

   gen donorname="`NAME'"

   save "working/`NAME'.dta", replace
   clear
}

use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

move donorname  countrynumcode_g
run "data/Standardize Country Names.do"
drop if stateinyeart_g==.
save "working/dat2" , replace


***************************************************************
** Add in the aid data (created by the other master build file)
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 
foreach NAME of local dnames {
   use "data/OECD 73-06.dta", clear
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}

use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

move donorname countryname
keep if  stateinyeart_g==1


**  DYADIZE the vars **
  ** this makes dyadic data out of the sector aid from each donor
local aidsectors hr cv el social econ total
foreach S of local aidsectors {
  gen dyadic_aid_`S' = .

  local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands Norway Sweden Switzerland
  foreach NAME of local dnames {
    replace  dyadic_aid_`S' = `NAME'_`S'_bil if donorname=="`NAME'"
    drop `NAME'_`S'_bil
  }

replace  dyadic_aid_`S' = NewZealand_`S'_bil if donorname=="New Zealand"
   drop NewZealand_`S'_bil
replace  dyadic_aid_`S' = US_`S'_bil if donorname=="United States"
   drop US_`S'_bil
replace  dyadic_aid_`S' = UK_`S'_bil if donorname=="United Kingdom"
   drop UK_`S'_bil

}

  ** This converts the donor world aid vars into an overall world aid var
  **   that varies by donor-year.

local aidsectors hr cv el social econ
foreach S of local aidsectors {
  gen `S'_world_aid = .
  local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Norway Sweden
  foreach NAME of local dnames {
    replace  `S'_world_aid = `NAME'_`S'_wldaid_bil if donorname=="`NAME'"
    drop `NAME'_`S'_wldaid_bil
  }

replace  `S'_world_aid = NewZea_`S'_wldaid_bil if donorname=="New Zealand"
   drop NewZea_`S'_wldaid_bil
replace  `S'_world_aid = US_`S'_wldaid_bil if donorname=="United States"
   drop US_`S'_wldaid_bil
replace  `S'_world_aid = UK_`S'_wldaid_bil if donorname=="United Kingdom"
   drop UK_`S'_wldaid_bil
replace  `S'_world_aid = Neth_`S'_wldaid_bil if donorname=="Netherlands"
   drop Neth_`S'_wldaid_bil
replace  `S'_world_aid = Switz_`S'_wldaid_bil if donorname=="Switzerland"
   drop Switz_`S'_wldaid_bil
}



gen donor_world_aid = .

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Norway Sweden
foreach NAME of local dnames {
  replace  donor_world_aid = `NAME'_wldaid_bil if donorname=="`NAME'"
  drop `NAME'_wldaid_bil
}

replace  donor_world_aid = NewZea_wldaid_bil if donorname=="New Zealand"
   drop NewZea_wldaid_bil
replace  donor_world_aid = US_wldaid_bil if donorname=="United States"
   drop US_wldaid_bil
replace  donor_world_aid = UK_wldaid_bil if donorname=="United Kingdom"
   drop UK_wldaid_bil
replace  donor_world_aid = Neth_wldaid_bil if donorname=="Netherlands"
   drop Neth_wldaid_bil
replace  donor_world_aid = Switz_wldaid_bil if donorname=="Switzerland"
   drop Switz_wldaid_bil


save "working/Dyad Aid for merge.dta", replace


clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/Dyad Aid for merge.dta", unique sort _merge(_merge_aid_vars)

erase "working/Dyad Aid for merge.dta"
capture drop countrynum
egen dyadnum=group(countryname donorname)
tsset dyadnum year

** Fills in for the main aggregated aid vars
   local aidcats hr cv el social econ total
   
   foreach cat of local aidcats {
     replace  usd2_`cat'_bil=0 if  usd2_`cat'_bil==. & year>1972 & year<2007
     replace  dyadic_aid_`cat'=0 if  dyadic_aid_`cat'==. & year>1972 & year<2007
   }

  ** World aid vars
   local aidcats2 hr cv el social econ

   foreach cat of local aidcats2 {
       replace  usd2_`cat'_world_aid_bil=0 if  usd2_`cat'_world_aid_bil==. & year>1972 & year<2007
       replace  `cat'_world_aid=0 if  `cat'_world_aid==. & year>1972 & year<2007
   }

  
   replace donor_world_aid=0 if donor_world_aid==. & year>1972 & year<2007

   ** single var that doesn't need a loop
   replace  usd2_total_bil=0 if  usd2_total_bil==. & year>1972 & year<2007
 
   ** single var that doesn't need a loop  
   replace  usd2_world_aid_bil=0 if  usd2_world_aid_bil==. & year>1972 & year<2007


   *** I don't fill in the primary/secondary donor stuff.
   *** Instead, I just dropped that set of variables
drop  usd2_hr_mil_primary usd2_cv_mil_primary usd2_el_mil_primary usd2_social_mil_primary usd2_econ_mil_primary usd2_total_mil_primary usd2_hr_waid_mil_primary usd2_cv_waid_mil_primary usd2_el_waid_mil_primary usd2_social_waid_mil_primary usd2_econ_waid_mil_primary usd2_waid_mil_primary usd2_hr_mil_second usd2_cv_mil_second usd2_el_mil_second usd2_social_mil_second usd2_econ_mil_second usd2_total_mil_second usd2_hr_waid_mil_second usd2_cv_waid_mil_second usd2_el_waid_mil_second usd2_social_waid_mil_second usd2_econ_waid_mil_second usd2_waid_mil_second
   *** I can do the primary/secondary donor thing better with 
   ***   the dyadic data anyway, splitting the sample...

  ** I also skipped making some of the vars that are in the original

/*This puts some of them in millions for prettier tables */

local aidcats hr cv el social econ total
foreach S of local aidcats {
   replace  dyadic_aid_`S' = dyadic_aid_`S'*1000
}

local aidcats hr cv el social econ donor
foreach S of local aidcats {
   replace  `S'_world_aid = `S'_world_aid*1000
}

drop _merge*

  ** some last minute changes
capture gen usd2_hrcv_bil = usd2_hr_bil + usd2_cv_bil
capture gen usd2_hrcv_mil=usd2_hrcv_bil*1000
capture gen usd2_hrcv_world_aid_mil=usd2_hrcv_world_aid_bil*1000

sort donorname countryname year
save "working/dat2.dta" , replace



/*	This part adds the CIRI variables 
	These are what limits the lower end of the sample
	They start in 1981, so with the lag, the sample starts in 1982 */
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
insheet using "data/CIRI 2007.csv"
rename ctry countryname
  ** make the 2007 version have the same vars as the 2004 version I used earlier
drop new_empinx formov dommov new_relfre injud
rename old_empinx empinx
rename old_relfre relfre
rename old_move move
rename elecsd polpar

/* The fix below deleted missing values where Gleditsch treats the
	countries as continuous and CIRI treats them as separate  */
drop if countryname=="Soviet Union" & year>=1992
drop if countryname=="Russia" & year<=1991
drop if countryname=="Yemen Arab Republic" & year>=1991
drop if countryname=="Yemen, South"
drop if countryname=="Yemen" & year<=1990
drop if countryname=="Yugoslavia" & year>1991
drop if countryname=="Yugoslavia, Federal Republic of" & year<=1991
drop if countryname=="Serbia and Montenegro" & year<=1991
drop if countryname=="Serbia and Montenegro" & year>=2000 & year<=2002
drop if countryname=="Serbia and Montenegro" & year>=2006
drop if countryname=="Yugoslavia, Federal Republic of" & (year<2000 | year>2002)
drop if countryname=="Montenegro" & year<2006
drop if countryname=="Serbia" & year<2006

run "data/Standardize Country Names.do"

/*	The -999's in CIRI are for when there was no mention in the reports
  	physint and empinx are missing if their constituent measuers are -66 or -77 */

gen anarchy=1 if disap==-77 | kill==-77 | polpris==-77 | tort==-77 | assn==-77 | move==-77 | speech==-77 | polpar==-77 | relfre==-77 | wecon==-77 | wopol==-77 | wosoc==-77
replace anarchy=0 if anarchy!=1
gen foreign_occup=1 if disap==-66 | kill==-66 | polpris==-66 | tort==-66 | assn==-66 | move==-66 | speech==-66 | polpar==-66 | relfre==-66 | wecon==-66 | wopol==-66 | wosoc==-66 
replace foreign_occup=0 if foreign_occup!=1
/* 	This allows for testst like:
	ttest  usd2_hr_bil, by(foreign_occup) unequal
	sdtest  usd2_hr_bil, by(foreign_occup) 
	to show that it doesn't matter to exclude these observations  */
notes anarchy: This is from CIRI. It is one if CIRI codes any of the HR vars as -77 which means "anarchy".
notes foreign_occup: This is from CIRI. It is one if CIRI codes any of the HR vars as -66 which means "foreign occupier".
gen physint_orig=physint
gen disap_orig=disap
gen kill_orig=kill
gen polpris_orig=polpris
gen tort_orig=tort
gen empinx_orig=empinx
gen assn_orig=assn
gen move_orig=move
gen speech_orig=speech
gen polpar_orig=polpar
gen relfre_orig=relfre
gen worker_orig=worker
gen wecon_orig=wecon
gen wopol_orig=wopol
gen wosoc_orig=wosoc
/*  This way, I can test to see what kind of aid goes to -66 and -77's */
replace  physint=. if physint==-999 /*1 missing value*/
replace  disap=. if disap==-999 
replace  kill=. if kill==-999 
replace  polpris=. if polpris==-999 
replace  tort=. if tort==-999 
replace  empinx=. if empinx==-999 /*1 missing value*/
replace  assn=. if assn==-999
replace  move=. if move==-999
replace  speech=. if speech==-999
replace  polpar=. if polpar==-999
replace  relfre=. if relfre==-999
replace  worker=. if worker==-999
replace  wecon=. if wecon==-999  /*71 missing values*/
replace  wopol=. if wopol==-999  /*16 missing values*/
replace  wosoc=. if wosoc==-999  /*132 missing values*/
/*	The -77's and -66's pose a bigger problem.  I emailed Richard Cingranell
	told me that these were for foreign occupation (-66) and anarchy (-77)
	He said that it is a "misnomer to talk about 'government human rights practices'" in these situations  */
replace  physint=. if physint==-77  /* 0 missing value */
replace  disap=. if disap==-77
replace  kill=. if kill==-77
replace  polpris=. if polpris==-77
replace  tort=. if tort==-77
replace  empinx=. if empinx==-77  /* 0 missing value */
replace  assn=. if assn==-77
replace  move=. if move==-77
replace  speech=. if speech==-77
replace  polpar=. if polpar==-77
replace  relfre=. if relfre==-77
replace  worker=. if worker==-77
replace  wecon=. if wecon==-77  /* 56 missing values */
replace  wopol=. if wopol==-77  /* 56 missing values */
replace  wosoc=. if wosoc==-77  /* 47 missing values */
replace  physint=. if physint==-66  /* 2 missing value */
replace  disap=. if disap==-66
replace  kill=. if kill==-66
replace  polpris=. if polpris==-66
replace  tort=. if tort==-66
replace  empinx=. if empinx==-66  /* 0 missing value */
replace  assn=. if assn==-66
replace  move=. if move==-66
replace  speech=. if speech==-66
replace  polpar=. if polpar==-66
replace  relfre=. if relfre==-66
replace  worker=. if worker==-66
replace  wecon=. if wecon==-66  /* 25 missing values */
replace  wopol=. if wopol==-66  /* 25 missing values */
replace  wosoc=. if wosoc==-66  /* 23 missing values */
gen wosum= wecon+ wopol+ wosoc
move wosum worker
notes wosum: gen wosum= wecon+ wopol+ wosoc (1444 missing values generated)
notes physint: CIRI variable with missing values replaced to be "."
notes empinx: CIRI variable with missing values replaced to be "."
notes wecon: CIRI variable with missing values replaced to be "."
notes wopol: CIRI variable with missing values replaced to be "."
notes wosoc: CIRI variable with missing values replaced to be "."
notes worker: CIRI variable with missing values as -66 and -77
notes physint_orig: CIRI variable with missing values as -66 and -77
notes empinx_orig: CIRI variable with missing values as -66 and -77
notes wecon_orig: CIRI variable with missing values as -66 and -77
notes wopol_orig: CIRI variable with missing values as -66 and -77
notes wosoc_orig: CIRI variable with missing values as -66 and -77
   gen donorname="`NAME'"

   save "working/`NAME'.dta", replace
   clear
}

use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/CIRI vars for merge.dta" , replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/CIRI vars for merge.dta", unique sort _merge(_merge_ciri_vars)

erase "working/CIRI vars for merge.dta"

/* Post merge clean-up */
/* I checked: this deletes states not in Gleditsch--either micro states or not yet independent
	The only states left as _merge 2's are thos from 2001-2004  */
drop if _merge_ciri_vars==2 & year<=2000
drop  _merge_ciri_vars
* This makes squared terms for physint, empinx, and wosum.
capture gen physint_sq=physint*physint
capture gen empinx_sq=empinx*empinx
capture gen wosum_sq=wosum*wosum




/* This adds conflict data from PRIO.
   Takes the place of the conflict data from Landman*/
** Data downloaded from http://www.pcr.uu.se/research/UCDP/data_and_publications/datasets.htm on Jan 19, 2009
save "working/dat2.dta" , replace

clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
insheet using "data/prio.txt", tab

/* To seperate civil conflicts from interstate conflicts,
   save the "type" var and split out the types (1-2) interstate,
   (3-4) intrastate. */

keep  sidea year 
rename sidea countryname
gen priowar=1
run "data/Standardize Country Names.do"
  ** weird problem
replace stateinyeart_g=1 if countryname=="Saudi Arabia"
drop if  stateinyeart_g==. &  microstateinyeart_g==.
  ** This is potentially a problem but it is out of the time range*France, Israel, United Kingdom	1956	2
duplicates drop
   gen donorname="`NAME'"

   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/prioA.dta", replace


clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
insheet using "data/prio.txt", tab

keep  sideb year
gen priowar=1
rename sideb countryname
run "data/Standardize Country Names.do"
  ** weird problem
replace stateinyeart_g=1 if countryname=="Saudi Arabia"
drop if  stateinyeart_g==. &  microstateinyeart_g==.
** This could be a problem except that none of these are recipients
** or else they are out of the date range.*Australia, United Kingdom, United States Of America	2003	2*Egypt, Iraq, Jordan, Lebanon, Syria	1949	2
*Egypt, Iraq, Jordan, Lebanon, Syria	1948	2
duplicates drop
   gen donorname="`NAME'"

   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/prioB.dta", replace



use "working/dat2.dta", clear
merge countryname donorname year using "working/prioA.dta", unique sort _merge(_merge_prioA)
merge countryname donorname year using "working/prioB.dta", unique sort _merge(_merge_prioB)

replace priowar=0 if priowar==.

  ** this shortens the storage of the string
compress  countryname

drop _merge_prio*
erase "working/prioB.dta"
erase "working/prioA.dta"



/* This section adds the Forces Abroad data I coded */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
insheet using "data/Foreign Forces (estimated).csv"
/* This cleanup gets rid of duplicates.  There were not foreign forces
   in any of these countries anyways  */
drop if country == "Germany West"
drop if country == "Germany, East"
drop if country == "Germany-new"
drop if country == "Soviet Union"
drop if country == "Suriname"
drop if country == "USSR"
drop if country == "Serbia and Montenegro"
drop if country == "Yemen North"
drop if country == "Yemen, North"
drop if country == "Yemen, South"
drop if country == "North Yemen"
drop if country == "South Yemen"
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if  countrycode_g=="Country Code (Gleditsch)"
drop  countrynumcode_g countrycode_g  microstateinyeart_g stateinyeart_g
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/Foreign Force vars for merge.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/Foreign Force vars for merge.dta", unique sort _merge(_merge_foreignforce_vars)
move _merge_foreignforce_vars population
drop if _merge_foreignforce_vars==2 /*the only worry with this is Bangladesh 1971 */
drop _merge_foreignforce_vars
erase "working/Foreign Force vars for merge.dta"
  ** Fill in for countries I dropped
  ** This works because I coded ALL of the forces abroad
replace usforces=0 if usforces==. & year>1947 & year<2007
replace usforce_dummy=0 if  usforce_dummy==. & year>1947 & year<2007
replace ukforces=0 if ukforces==. & year>1947 & year<2007
replace ukforce_dummy=0 if  ukforce_dummy==. & year>1947 & year<2007
replace frforces=0 if frforces==. & year>1947 & year<2007
replace frforce_dummy=0 if  frforce_dummy==. & year>1947 & year<2007
  ** make DAC forces var
gen forces_DAC1= usforces+ ukforces+ frforces
gen forces_DAC=forces_DAC1/1000
notes forces_DAC: measured in thousands of troops



/* This section adds life expectancy data from the WDI */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
use "data/Life expectancy.WDI.dta", clear
rename country countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if  countrycode_g=="Country Code (Gleditsch)"
keep  countryname year  life_exp_total avg_life_80_00
notes life_exp_total: From the WDI (World Bank 2005)
notes avg_life_80_00: This is the average of life_exp_total between 1980 and 2000.  From the WDI (World Bank 2005)
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/Life Expectancy for merge.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/Life Expectancy for merge.dta", unique sort _merge(_merge_lifeexp_vars)
move _merge_lifeexp_vars population
drop if _merge_lifeexp_vars==2 
erase "working/Life Expectancy for merge.dta"
/*Again, Bangladesh 1971 is the only questionable one.  Gleditsch doesn't
  doesn't have GDP data for it in 1971, I checked. */
drop _merge_lifeexp_vars
gen   avg_life_80_00_mean= avg_life_80_00
drop  avg_life_80_00
egen  avg_life_80_00=mean( avg_life_80_00_mean), by(countryname)
drop  avg_life_80_00_mean



/*This section adds the ICRG governance variables */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
use "data/ICRG.complete.dta", clear
rename country countryname
/* This solves some duplicates */
drop if countryname=="Germany" & year<=1990
drop if countryname=="West Germany" & year>=1991
drop if countryname=="East Germany" & year>=1991
drop if countryname=="Czech Republic" & year<=1992
drop if countryname=="Czechoslovakia" & year>=1993
drop if countryname=="Russia" & year<=1991
drop if countryname=="USSR" & year>=1992
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if  countrycode_g=="Country Code (Gleditsch)" /* drops Hong Kong, New Caledonia */
gen governance_icrg= ( corruption_icrg+ bureaucratic_quality_icrg+ law_and_order_icrg)/3
notes  governance_icrg: governance_icrg= ( corruption_icrg+ bureaucratic_quality_icrg+ law_and_order_icrg)/3
keep  countryname year governance_icrg
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/ICRG governance var for merge.dta", replace
clear
use "working/dat2.dta", clear
 merge countryname donorname year using "working/ICRG governance var for merge.dta", unique sort _merge(_merge_icrg_var)
move _merge_icrg_var population
drop if _merge_icrg_var==2 /*just drops non-independent states */
drop _merge_icrg_var
erase "working/ICRG governance var for merge.dta"



/* This section adds polity4  */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
insheet using "data/p4v2006.csv"
rename  country countryname
/* These fixes cut the data off at 1945--not ideal but doesn't matter here */
drop if countryname=="Germany" & year==1945
drop if countryname=="Germany" & year==1990
drop if countryname=="Yugoslavia" & durable==37
drop if countryname=="Yemen" & year==1990
drop if countryname=="Ethiopia" &  year==1993 & polity2==0
drop if countryname=="Vietnam North" & year==1976
drop if year<1945
drop if countryname=="Serbia"

run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
move  countrycode_g year
drop if  countrycode_g=="Country Code (Gleditsch)"
keep countryname year polity2 parcomp
/* This part drops the -66, -77, -88 (foreign occ, anarchy, and transition, respective) */
/* It might be a good idea to estimate the transition values */
replace parcomp=. if parcomp==-66
replace parcomp=. if parcomp==-77
replace parcomp=. if parcomp==-88
replace polity2=. if polity2==-77
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/Polity var for merge.dta", replace
clear
use "working/dat2.dta", clear
 merge countryname donorname year using "working/Polity var for merge.dta", unique sort _merge(_merge_polity_vars)
move _merge_polity_vars population
drop if _merge_polity_vars==2
drop _merge_polity_vars
erase "working/Polity var for merge.dta"


*** I skipped adding Freedom House




/* Put in alliance data from ATOP by Ashley Leeds */
** The COW alliance data below only goes up to 2000
** I'm dropping it to use Ashley Leeds ATOP data
save "working/dat2.dta" , replace
clear
use "data/atop3_0dy.dta", clear
keep  year atopally mem1 mem2
rename mem1 ccode1
rename mem2 ccode2
gen country=""
gen partner=""
run "data/Cow convert.do"
drop ccode*

   ** the dyads are directed so I recombine them as undirected
save "working/allies1.dta", replace

rename country country1
rename partner country
rename country1 partner
append using "working/allies1.dta"

replace partner="United States" if partner=="United States of America"
replace partner="Germany" if partner=="German Federal Republic"
gen DAC=1 if partner=="United States" | partner=="Austria" | partner=="Belgium" | partner=="Canada" | partner=="Denmark" | partner=="France" | partner=="Germany" |  partner=="Ireland" | partner=="Italy" | partner=="Luxembourg" | partner=="Netherlands" | partner=="Norway" | partner=="Portugal" | partner=="Spain" | partner=="Sweden" | partner=="Switzerland" | partner=="United Kingdom"
replace DAC=1 if partner=="Japan" | partner=="Finland" | partner=="Australia" | partner=="New Zealand" 
*replace country="United States" if country=="United States of America"
*replace country="Germany" if country=="German Federal Republic"
*replace DAC=1 if country=="United States" | country=="Austria" | country=="Belgium" | country=="Canada" | country=="Denmark" | country=="France" | country=="Germany" |  country=="Ireland" | country=="Italy" | country=="Luxembourg" | country=="Netherlands" | country=="Norway" | country=="Portugal" | country=="Spain" | country=="Sweden" | country=="Switzerland" | country=="United Kingdom"
*replace DAC=1 if country=="Japan" | country=="Finland" | country=="Australia" | country=="New Zealand" 

drop if DAC!=1
rename country countryname
rename partner donorname 
rename atopally alliance

drop  DAC
duplicates drop
drop if countryname=="German Federal Republic" & year==1990
run "data/Standardize Country Names.do"
drop if year<1948
save "working/Alliance data for merge.dta", replace
clear
use "working/dat2.dta", clear
 merge countryname donorname year using "working/Alliance data for merge.dta", unique sort _merge(_merge_alliance_vars)
move _merge_alliance_vars population
drop if _merge_alliance_vars==2  /* this is dropping New Zealand 1950-67 when it was independent,--odd, but not in my time-frame */
drop _merge_alliance_vars
erase "working/Alliance data for merge.dta"
/*  This fills in the countries that had no alliances and thus weren't counted correctly */
replace alliance=0 if alliance==. & year<2004




/*	This section adds French/British colony vars from Fearon  */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
use "data/Ethnicity, Insurgency, and Civil war.dta", clear
keep  country  year colbrit colfra
rename country countryname
drop if countryname=="Yemen, South" & year==1990
drop if countryname=="Yemen, North" & year==1990
run "data/Standardize Country Names.do"
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/Colony vars for merge.dta" , replace
clear
use "working/dat2.dta", clear
run "data/Standardize Country Codes.do"
merge countryname donorname year using "working/Colony vars for merge.dta", unique sort _merge(_merge_colony_vars)
move _merge_colony_vars population
drop if _merge_colony_vars==2
drop _merge_colony_vars
erase "working/Colony vars for merge.dta"

egen colbrit1=max(colbrit), by(countryname)
egen colfra1=max(colfra), by(countryname)



/*	This adds the Cold War var.  */
gen ColdWar=1 if year>=1992
replace ColdWar=0 if year<=1991



/* this section adds trade */
** Note that I'm now using the trade statistics from COPE put
** together by Josh Loud rather than Gleditsch's data because
** the Gleditsch data stops at 2000.

  ** For some reason, I never standardize the countrynames
  **   in the original build file, CHECK THIS

save "working/dat2.dta" , replace
clear

use "data/COPE.Master.Complete.11June07.dta", clear
keep countryname partner year trademd
rename trademd trade

gen DAC=1 if partner=="United States of America" | partner=="Austria" | partner=="Belgium" | partner=="Canada" | partner=="Denmark" | partner=="France" | partner=="German Federal Republic" |  partner=="Ireland" | partner=="Italy/Sardinia" | partner=="Luxembourg" | partner=="Netherlands" | partner=="Norway" | partner=="Portugal" | partner=="Spain" | partner=="Sweden" | partner=="Switzerland" | partner=="United Kingdom"
replace DAC=1 if partner=="Japan" | partner=="Finland" | partner=="Australia" | partner=="New Zealand" 
drop if DAC!=1
drop DAC
rename partner donorname

replace donorname="United States" if donorname=="United States of America"
replace donorname="Italy" if donorname=="Italy/Sardinia"
replace donorname="Germany" if donorname=="German Federal Republic"

gen ln_trade=ln((trade*1000000)+1)

  ** For some reason, I never standardize the countrynames
  **   in the original build file, CHECK THIS,
  **   both here and in the other file.
*run "Standardize Country Names.do"

save "working/Trade data for merge.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/Trade data for merge.dta", unique sort _merge(_merge_trade_vars)
move _merge_trade_vars population
drop if _merge_trade_vars==2 /*This drops micro-states and oddly New Zealand before 1968.  Not sure why */
drop _merge_trade_vars
erase "working/Trade data for merge.dta"




/*    This adds Years of Independence  */

save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
use "data/Idependence dates.dta", clear
duplicates tag countryname year, gen(dup)
drop if countryname=="Haiti" & startyear==1816
drop if countryname=="Montenegro" & startyear==1868
drop if countryname=="Estonia" & startyear==1918
drop if countryname=="Latvia" & startyear==1918
drop if countryname=="Lithuania" & startyear==1918
drop if countryname=="Madagascar (Malagasy)" & startyear==1816
drop if countryname=="Morocco" & startyear==1816
drop if countryname=="Algeria" & startyear==1816
drop if countryname=="Tunisia" & startyear==1816
drop if countryname=="Libya" & startyear==1816
drop if countryname=="Egypt" & startyear==1827
drop if countryname=="Afghanistan" & startyear==1816
drop if countryname=="Myanmar (Burma)" & startyear==1816
replace countryname="Cote D'Ivoire" if countryname=="Cote D’Ivoire"
drop dup
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/Idependence dates for merge.dta" , replace
clear
use "working/dat2.dta" , clear
merge countryname donorname year using "working/Idependence dates for merge.dta", unique sort _merge(_merge_indep_years)
egen startyear1 =max(startyear), by(countryname)
gen years_indep=year-startyear1
drop if  _merge_indep_years==2
drop  startday startmo startyear endday endmo endyear
drop _merge_indep_years
erase "working/Idependence dates for merge.dta"



/* This section makes a Socialist var, air distance, some area dummies  */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
use "data/distance, socialist (and others).dta", clear
move  year airdist
replace  country="Czechoslovakia" if country=="Czech Republic" & year<=1992
rename country countryname
run "data/Standardize Country Names.do"
drop  eu safri sasia transit latam eseasia wbcode newstate
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/Socialist var for merge.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/Socialist var for merge.dta", unique sort _merge(_merge_socialist_vars)
move _merge_socialist_vars population
drop if _merge_socialist_vars==2
drop _merge_socialist_vars
erase "working/Socialist var for merge.dta"



/* This section adds the PTS  */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
use "data/PTS.dta", clear
rename  COW_num ccode1
gen country="aaamistake"
run "data/COW convert.do"
move  country COWcode
drop if country=="Russia" & year<=1991
replace  country="USSR" if  wbcode=="USSR"
drop if country=="USSR" & year>1991
replace country="West Bank and Gaza" if  wbcode=="WBG"
replace country="Czech Republic" if country=="Czechoslovakia" & year >1992
drop if country=="Slovakia" & year <1993
rename country countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
move  countrycode_g COWcode
drop if  countrycode_g=="Country Code (Gleditsch)"
drop  countrynumcode_g microstateinyeart_g stateinyeart_g countrycode_g
drop  COWcode ccode1 wbcode PTScode
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/PTS data for merge.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/PTS data for merge.dta", unique sort _merge(_merge_pts_vars)
move _merge_pts_vars population
drop if _merge_pts_vars==2
drop _merge_pts_vars
erase "working/PTS data for merge.dta"



/*  Add World Bank Area Dummies */
run "data/Make world bank geographic regions.09.03.07.do"

/*  This adds an OECD variable, as defined by the World Bank, 2006 */
gen OECD=1 if countryname=="United States of America" | countryname=="Austria" | countryname=="Belgium" | countryname=="Canada" | countryname=="Denmark" | countryname=="France" | countryname=="German Federal Republic" | countryname=="Greece" | countryname=="Iceland" | countryname=="Ireland" | countryname=="Italy/Sardinia" | countryname=="Luxembourg" | countryname=="Netherlands" | countryname=="Norway" | countryname=="Portugal" | countryname=="Spain" | countryname=="Sweden" | countryname=="Switzerland" | countryname=="Turkey/Ottoman Empire" | countryname=="United Kingdom"
replace OECD=1 if countryname=="Japan" | countryname=="Finland" | countryname=="Australia" | countryname=="New Zealand"
/*Not sure about these ones--these are the new members?*/
replace OECD=1 if countryname=="Mexico" | countryname=="Czech Republic"  | countryname=="Hungary" | countryname=="Poland" | countryname=="Korea, Republic of" | countryname=="Slovakia"
replace OECD=0 if OECD!=1

/* Make egypt and israel dummies */
gen egypt=1 if countryname=="Egypt"
replace egypt=0 if egypt!=1
gen israel=1 if countryname=="Israel"
replace israel=0 if israel!=1

gen egypt_US=1 if countryname=="Egypt" & donorname=="United States"
replace egypt_US=0 if egypt_US!=1
gen israel_US=1 if countryname=="Israel" & donorname=="United States"
replace israel_US=0 if israel_US!=1


/* Nov 6 2007, I decided to consolidate the colony vars
   using Pippa Norris' dataset */
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {
use "data/Pippa Norris.Politics & Social Indicators.6.05.dta", clear
keep  nation intabrv  colony
gen year=2000
rename nation countryname
replace countryname="Panama" if countryname=="Panama Canal Zone"
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/Colony pippa for merge.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/Colony pippa for merge.dta", unique sort _merge(_merge_pippa_vars)
move _merge_pippa_vars population
drop if _merge_pippa_vars==2
drop _merge_pippa_vars
erase "working/Colony pippa for merge.dta"
egen colony1=mean(colony), by(countryname)
gen colonyDAC=0
replace colonyDAC=1 if colony1==1 | colony1==2 | colony1==3 | colony1==4 | colony1==5 | colony1==14

gen dyad_colony = 0
replace dyad_colony=1 if colony1==1 & donorname=="United Kingdom"
replace dyad_colony=1 if colony1==2 & donorname=="France"
replace dyad_colony=1 if colony1==3 & donorname=="Portugal"
replace dyad_colony=1 if colony1==4 & donorname=="Spain"
replace dyad_colony=1 if colony1==5 & donorname=="Netherlands"
replace dyad_colony=1 if colony1==14 & donorname=="Belgium"



******  ADD the UNCHR refugee data
save "working/dat2.dta" , replace
clear

local dname Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United Kingdom" "United States"

foreach NAME of local dname {
   insheet using "data/UNCHR data.02.09.09/`NAME'.txt", tab

   foreach i of numlist 1/100 {
     capture replace v`i'=subinstr(v`i',",","",100)
   }

   replace v1=subinstr(v1,"Refugees Originating from -> ","",100)


   tempfile dat
   save "`dat'"

   keep in 2
   drop v1
   destring(v*), replace
   mkmat v*, matrix(years)

   use "`dat'", clear
   drop in 1
   drop in 1
   rename v1 source
   reshape long v, i(source) j(number)


   matrix years = years'
   svmat years, names(years)

   egen year = max(years),by(number)

   drop number years1

   rename v refugees
   destring(refugees), replace force

   gen host="`NAME'"
   save "working/`NAME'.dta", replace
   clear

}

use "working/Australia.dta", clear
local dname Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United Kingdom" "United States"
foreach NAME of local dname {
  append using "working/`NAME'.dta"
  erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

rename source countryname
run "data/Standardize Country Names.do"
rename host donorname

save "working/UNCHR data", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/UNCHR data.dta", unique sort _merge(_merge_unchr_vars)
move _merge_unchr_vars population
drop if _merge_unchr_vars==2
drop _merge_unchr_vars
erase "working/UNCHR data.dta"


******************************************************************************
** On January 12, 2009, Adding in total refugees that a state is putting out
save "working/dat2.dta" , replace
clear
use "working/dat1.dta", clear
keep countryname year reftotal lnreftotal


local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 
foreach NAME of local dnames {
   use "working/dat1.dta", clear
   keep countryname year reftotal lnreftotal
   gen donorname="`NAME'"

   save "working/`NAME'.dta", replace
   clear
}

use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

save "working/UNCHR2 for merge.dta" , replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/UNCHR2 for merge.dta", unique sort _merge(_merge_unchr2_vars)

erase "working/UNCHR2 for merge.dta"



** Merge in the donor HR treaty data
  ** This is where I got the UN HR treaties from:
  ** coded them by hand with Landman's data as the base.
  ** I found a number of discrepancies between the UN listing and Landman, particularly in Australia -- I went with UN.
  ** http://treaties.un.org/Pages/Treaties.aspx?id=4&subid=A&lang=en
  ** Note, I added Italy on 15 July 2011, but I couldn't find it's optional protocol
  **  ratifications for the ICCPR.  They may be filled in incorrectly.

save "working/dat2.dta" , replace
clear

insheet using "data/HR treaties for donors.csv", comma
rename countryname donorname
gen countryname="Afghanistan"
save "working/HR treaties.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/HR treaties.dta", unique sort _merge(_merge_HR)
move _merge_HR population
drop if _merge_HR==2
drop _merge_HR
erase "working/HR treaties.dta"

local hrtreaties crc cedaw cerd opt1 opt2 ccpr cescr cat

foreach HRA of local hrtreaties {
rename `HRA' `HRA'1
egen `HRA' = max(`HRA'1), by(donorname year)
gen base`HRA' = 1 if `HRA'!=.
replace base`HRA'= 0 if `HRA'==9
gen rat`HRA' = 1 if `HRA'==2
  replace rat`HRA' = 0 if `HRA'!=2 & `HRA'!=.
}

gen basecount = basecrc + basecedaw + basecerd + baseopt1 + baseopt2 + basecescr + baseccpr + basecat
gen ratcount =  ratcrc + ratcedaw + ratcerd + ratopt1 + ratopt2 + ratcescr + ratccpr + ratcat

gen ratpercent = ratcount/basecount

  ** Makes a dummy variable for whether a donor is above or below median treaty rat.
gen treatyhigh = .
foreach YEAR of numlist 1982/2004 {
  _pctile ratpercent if year==`YEAR'
  local cutoff=r(r1)
  di `cutoff'
  replace treatyhigh = 1 if ratpercent>=`cutoff' & year==`YEAR'
  replace treatyhigh = 0 if ratpercent<`cutoff' & year==`YEAR'
}

** make treaty-physint interactions
gen physint_treatyhigh =physint*treatyhigh
gen physint_ratpercent = physint*ratpercent



** Add in the New York times search on HR data
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {

insheet using "data/HR nytimes.csv", clear
rename hrcount nytimes
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/NYtimes.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/NYtimes.dta", unique sort _merge(_merge_nytimes)
move _merge_nytimes population
drop if _merge_nytimes==2
drop _merge_nytimes
erase "working/NYtimes.dta"

** Note that there is an issue with Congo and Korea

capture gen lnnytimes=ln(nytimes+1)

  ** the var of interest is called nytimes and lnnytimes


** July 1 2011:  add machine coded NYT var
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {

insheet using "data\NYT data 2011\randomForestHRcodes.csv", comma
split v4, parse(" OR ")
rename v41 countryname
replace countryname="Saudi Arabia" if countryname=="Saudi Arabi"
rename v2 year
rename v3 nytmachine
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
keep year countryname nytmachine

   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
save "working/NYtimes.dta", replace
clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/NYtimes.dta", unique sort _merge(_merge_nytimes)
move _merge_nytimes population
drop if _merge_nytimes==2
drop _merge_nytimes
erase "working/NYtimes.dta"

capture gen lnnytmachine=ln(nytmachine+1)




** This section creates a dummy variable coded as 1 if a recipient is contiguous with
**   a donor's ally. This takes a very long time, so only run it if something changes
**  Note, I actually ran it on the server

save "working/dat2.dta" , replace

/*  This is commented out because it takes forever to run
    I did it in 12 hours on the RCE servers
 ** Make the contiguity dataset
clear
insheet using "data\contdird.csv"
rename  state1no ccode1
rename  state2no ccode2
gen country=""
gen partner=""
do "data\COW convert.do"
rename partner countryname
do "data\Standardize Country Names.do"
do "data\Standardize Country Codes.do"
rename countryname partner
rename countrynumcode_g partnercode
rename country countryname
do "data\Standardize Country Names.do"
do "data\Standardize Country Codes.do"
drop if countryname==""
save "data\contiguous.dta", replace

**make a list of the ally-partners of each donor in each year
**take each recipient
**make a list of who it is contiguous with
** see if any countries on that list match the allies of each donor in that year


*******************************************
***** this loops it over all donors and all years
use "working/dat2.dta", clear
capture gen donorallyneighbor=.
keep donorname  countrynumcode_g countrycode_g countryname alliance year donorallyneighbor
save "data/allyneighbor.dta", replace

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2004 {
    levelsof countryname if donorname=="`DONOR'" & alliance==1 & year==`YEAR', local(allies)
    foreach ALLY of local allies{
      di "`ALLY'"
      use "data\contiguous.dta", clear
      levelsof countryname if partner=="`ALLY'" & year==`YEAR', local(allycontig)
      use "data\allyneighbor.dta", clear
      foreach NEIGHBOR of local allycontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace donorallyneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "data\allyneighbor.dta", replace
    }
  }
}
*********************************************
save "data/allyneighbor.dta", replace
*/
clear
use "working/dat2.dta", clear
merge countryname donorname year using "data/allyneighbor.dta", unique sort _merge(_merge_allyneighbor)
move _merge_allyneighbor population
drop if _merge_allyneighbor==2
drop _merge_allyneighbor

replace donorallyneighbor=0 if donorallyneighbor==. & year>=1980 & year<=2004


** the exact code I ran on the server was:
** note that I just moved "allyneighbor.dta", and "contiguous.dta" over there
/*
cd "/nfs/home/R/rnielsen/Desktop/allyneighbor/"
use "allyneighbor.dta", clear

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2004 {
    levelsof countryname if donorname=="`DONOR'" & alliance==1 & year==`YEAR', local(allies)
    foreach ALLY of local allies{
      di "`ALLY'"
      use "/nfs/home/R/rnielsen/Desktop/allyneighbor/contiguous.dta", clear
      levelsof countryname if partner=="`ALLY'" & year==`YEAR', local(allycontig)
      use "/nfs/home/R/rnielsen/Desktop/allyneighbor/allyneighbor.dta", clear
      foreach NEIGHBOR of local allycontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace donorallyneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "/nfs/home/R/rnielsen/Desktop/allyneighbor/allyneighbor.dta", replace
    }
  }
}
*********************************************
save "/nfs/home/R/rnielsen/Desktop/allyneighbor/allyneighbor.dta", replace


*/



** TRADE NEIGHBOR
** This section creates a dummy variable coded as 1 if a recipient is contiguous with
**   a donor's top trading partners. This takes a very long time, so only run it if something changes
**  Note, I actually ran it on the server

save "working/dat2.dta" , replace

clear
use "working/dat2.dta", clear

** First, make a variable with top 25th percentile of trade partners
capture gen tradepartner=.
  ** only runs this part if the variable doesn't exist yet
if _rc==0 {
  levelsof donorname, local(dnames)
  foreach DONOR of local dnames {
    di "`DONOR'"
    foreach YEAR of numlist 1980/2004 {
      _pctile trade if donorname=="`DONOR'" & year==`YEAR', p(75)
      replace tradepartner = 1 if donorname=="`DONOR'" & year==`YEAR' & trade>=r(r1) & trade!=.
    }
  }
}
save "working/dat2.dta" , replace

/*  This is commented out because it takes forever to run
    I did it in 12 hours on the RCE servers
 ** Make the contiguity dataset
clear
insheet using "data\contdird.csv"
rename  state1no ccode1
rename  state2no ccode2
gen country=""
gen partner=""
do "data\COW convert.do"
rename partner countryname
do "data\Standardize Country Names.do"
do "data\Standardize Country Codes.do"
rename countryname partner
rename countrynumcode_g partnercode
rename country countryname
do "data\Standardize Country Names.do"
do "data\Standardize Country Codes.do"
drop if countryname==""
save "data\contiguous.dta", replace

**make a list of the ally-partners of each donor in each year
**take each recipient
**make a list of who it is contiguous with
** see if any countries on that list match the allies of each donor in that year



*******************************************
***** this loops it over all donors and all years
use "working/dat2.dta", clear
capture gen tradeneighbor=.
keep donorname  countrynumcode_g countrycode_g countryname tradepartner year tradeneighbor
save "data\tradeneighbor.dta", replace

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2004 {
    levelsof countryname if donorname=="`DONOR'" & tradepartner==1 & year==`YEAR', local(traders)
    foreach TRADER of local traders{
      di "`TRADER'"
      use "data\contiguous.dta", clear
      levelsof countryname if partner=="`TRADER'" & year==`YEAR', local(tradercontig)
      use "data\tradeneighbor.dta", clear
      foreach NEIGHBOR of local tradercontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace tradeneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "data\tradeneighbor.dta", replace
    }
  }
}
*********************************************
save "data\tradeneighbor.dta", replace
*/
clear
use "working/dat2.dta", clear
merge countryname donorname year using "data/tradeneighbor.dta", unique sort _merge(_merge_tradeneighbor)
move _merge_tradeneighbor population
drop if _merge_tradeneighbor==2
drop _merge_tradeneighbor

replace tradeneighbor=0 if tradeneighbor==. & year>=1980 & year<=2004
  ** drop out tradeneighbors that are also main traders
capture gen tradeneighbor2=tradeneighbor
capture replace tradeneighbor=0 if tradepartner==1

** the exact code I ran on the server was:
** note that I just moved "tradeneighbor.dta", and "contiguous.dta" over there
/*
cd "/nfs/home/R/rnielsen/Desktop/tradeneighbor/"
use "tradeneighbor.dta", clear

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2004 {
    levelsof countryname if donorname=="`DONOR'" & tradepartner==1 & year==`YEAR', local(traders)
    foreach TRADER of local traders{
      di "`TRADER'"
      use "/nfs/home/R/rnielsen/Desktop/tradeneighbor/contiguous.dta", clear
      levelsof countryname if partner=="`TRADER'" & year==`YEAR', local(tradercontig)
      use "/nfs/home/R/rnielsen/Desktop/tradeneighbor/tradeneighbor.dta", clear
      foreach NEIGHBOR of local tradercontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace tradeneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "/nfs/home/R/rnielsen/Desktop/tradeneighbor/tradeneighbor.dta", replace
    }
  }
}
*********************************************
save "/nfs/home/R/rnielsen/Desktop/tradeneighbor/tradeneighbor.dta", replace


*/



** COLONY NEIGHBOR
** This section creates a dummy variable coded as 1 if a recipient is contiguous with
**   a donor's former colonies. This takes a very long time, so only run it if something changes
**  Note, I actually ran it on the server

save "working/dat2.dta" , replace

/*  This is commented out because it takes forever to run
    I did it in 12 hours on the RCE servers
 ** Make the contiguity dataset
clear
insheet using "C:\Documents and Settings\Rich\Desktop\RHR 2009\contdird.csv"
rename  state1no ccode1
rename  state2no ccode2
gen country=""
gen partner=""
do "C:\Documents and Settings\Rich\Desktop\RHR 2009\COW convert.do"
rename partner countryname
do "C:\Documents and Settings\Rich\Desktop\RHR 2009\Standardize Country Names.do"
do "C:\Documents and Settings\Rich\Desktop\RHR 2009\Standardize Country Codes.do"
rename countryname partner
rename countrynumcode_g partnercode
rename country countryname
do "C:\Documents and Settings\Rich\Desktop\RHR 2009\Standardize Country Names.do"
do "C:\Documents and Settings\Rich\Desktop\RHR 2009\Standardize Country Codes.do"
drop if countryname==""
save "C:\Documents and Settings\Rich\Desktop\RHR 2009\contiguous.dta", replace

**make a list of the ally-partners of each donor in each year
**take each recipient
**make a list of who it is contiguous with
** see if any countries on that list match the allies of each donor in that year



*******************************************
***** this loops it over all donors and all years
use "C:\Documents and Settings\Rich\Desktop\RHR 2009\Master dataset RHR.7.0 dyadic.dta", clear

** make a dataset with top 25th percentile of trade partners
capture gen colonyneighbor=.
keep donorname  countrynumcode_g countrycode_g countryname dyad_colony year colonyneighbor
save "C:\Documents and Settings\Rich\Desktop\RHR 2009\colonyneighbor.dta", replace

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2004 {
    levelsof countryname if donorname=="`DONOR'" & dyad_colony==1 & year==`YEAR', local(colonies)
    foreach COLONY of local colonies{
      di "`COLONY'"
      use "C:\Documents and Settings\Rich\Desktop\RHR 2009\contiguous.dta", clear
      levelsof countryname if partner=="`COLONY'" & year==`YEAR', local(colonycontig)
      use "C:\Documents and Settings\Rich\Desktop\RHR 2009\colonyneighbor.dta", clear
      foreach NEIGHBOR of local colonycontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace colonyneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "C:\Documents and Settings\Rich\Desktop\RHR 2009\colonyneighbor.dta", replace
    }
  }
}
*********************************************
save "C:\Documents and Settings\Rich\Desktop\RHR 2009\colonyneighbor.dta", replace
*/
clear
use "working/dat2.dta", clear
merge countryname donorname year using "data/colonyneighbor.dta", unique sort _merge(_merge_colonyneighbor)
move _merge_colonyneighbor population
drop if _merge_colonyneighbor==2
drop _merge_colonyneighbor

replace colonyneighbor=0 if colonyneighbor==. & year>=1980 & year<=2004
  ** drop out colonies that border other colonies
capture gen colonyneighbor2=colonyneighbor
capture replace colonyneighbor=0 if dyad_colony==1


** the exact code I ran on the server was:
** note that I just moved "tradeneighbor.dta", and "contiguous.dta" over there
/*
cd "/nfs/home/R/rnielsen/Desktop/colonyneighbor/"
use "colonyneighbor.dta", clear

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2004 {
    levelsof countryname if donorname=="`DONOR'" & dyad_colony==1 & year==`YEAR', local(colonies)
    foreach COLONY of local colonies{
      di "`COLONY'"
      use "/nfs/home/R/rnielsen/Desktop/colonyneighbor/contiguous.dta", clear
      levelsof countryname if partner=="`COLONY'" & year==`YEAR', local(colonycontig)
      use "/nfs/home/R/rnielsen/Desktop/colonyneighbor/colonyneighbor.dta", clear
      foreach NEIGHBOR of local colonycontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace colonyneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "/nfs/home/R/rnielsen/Desktop/colonyneighbor/colonyneighbor.dta", replace
    }
  }
}
*********************************************
save "/nfs/home/R/rnielsen/Desktop/colonyneighbor/colonyneighbor.dta", replace


*/




** Add in donor human rights protection from CIRI
save "working/dat2.dta" , replace
clear
insheet using "data/CIRI 2007.csv"
rename ctry countryname
  ** make the 2007 version have the same vars as the 2004 version I used earlier
drop new_empinx formov dommov new_relfre injud
rename old_empinx empinx
rename old_relfre relfre
rename old_move move
rename elecsd polpar

/* The fix below deleted missing values where Gleditsch treats the
	countries as continuous and CIRI treats them as separate  */
drop if countryname=="Soviet Union" & year>=1992
drop if countryname=="Russia" & year<=1991
drop if countryname=="Yemen Arab Republic" & year>=1991
drop if countryname=="Yemen, South"
drop if countryname=="Yemen" & year<=1990
drop if countryname=="Yugoslavia" & year>1991
drop if countryname=="Yugoslavia, Federal Republic of" & year<=1991
drop if countryname=="Serbia and Montenegro" & year<=1991
drop if countryname=="Serbia and Montenegro" & year>=2000 & year<=2002
drop if countryname=="Serbia and Montenegro" & year>=2006
drop if countryname=="Yugoslavia, Federal Republic of" & (year<2000 | year>2002)
drop if countryname=="Montenegro" & year<2006
drop if countryname=="Serbia" & year<2006

run "data/Standardize Country Names.do"

/*	The -999's in CIRI are for when there was no mention in the reports
  	physint and empinx are missing if their constituent measuers are -66 or -77 */

gen anarchy=1 if disap==-77 | kill==-77 | polpris==-77 | tort==-77 | assn==-77 | move==-77 | speech==-77 | polpar==-77 | relfre==-77 | wecon==-77 | wopol==-77 | wosoc==-77
replace anarchy=0 if anarchy!=1
gen foreign_occup=1 if disap==-66 | kill==-66 | polpris==-66 | tort==-66 | assn==-66 | move==-66 | speech==-66 | polpar==-66 | relfre==-66 | wecon==-66 | wopol==-66 | wosoc==-66 
replace foreign_occup=0 if foreign_occup!=1
/* 	This allows for testst like:
	ttest  usd2_hr_bil, by(foreign_occup) unequal
	sdtest  usd2_hr_bil, by(foreign_occup) 
	to show that it doesn't matter to exclude these observations  */
notes anarchy: This is from CIRI. It is one if CIRI codes any of the HR vars as -77 which means "anarchy".
notes foreign_occup: This is from CIRI. It is one if CIRI codes any of the HR vars as -66 which means "foreign occupier".
gen physint_orig=physint
gen disap_orig=disap
gen kill_orig=kill
gen polpris_orig=polpris
gen tort_orig=tort
gen empinx_orig=empinx
gen assn_orig=assn
gen move_orig=move
gen speech_orig=speech
gen polpar_orig=polpar
gen relfre_orig=relfre
gen worker_orig=worker
gen wecon_orig=wecon
gen wopol_orig=wopol
gen wosoc_orig=wosoc
/*  This way, I can test to see what kind of aid goes to -66 and -77's */
replace  physint=. if physint==-999 /*1 missing value*/
replace  disap=. if disap==-999 
replace  kill=. if kill==-999 
replace  polpris=. if polpris==-999 
replace  tort=. if tort==-999 
replace  empinx=. if empinx==-999 /*1 missing value*/
replace  assn=. if assn==-999
replace  move=. if move==-999
replace  speech=. if speech==-999
replace  polpar=. if polpar==-999
replace  relfre=. if relfre==-999
replace  worker=. if worker==-999
replace  wecon=. if wecon==-999  /*71 missing values*/
replace  wopol=. if wopol==-999  /*16 missing values*/
replace  wosoc=. if wosoc==-999  /*132 missing values*/
/*	The -77's and -66's pose a bigger problem.  I emailed Richard Cingranell
	told me that these were for foreign occupation (-66) and anarchy (-77)
	He said that it is a "misnomer to talk about 'government human rights practices'" in these situations  */
replace  physint=. if physint==-77  /* 0 missing value */
replace  disap=. if disap==-77
replace  kill=. if kill==-77
replace  polpris=. if polpris==-77
replace  tort=. if tort==-77
replace  empinx=. if empinx==-77  /* 0 missing value */
replace  assn=. if assn==-77
replace  move=. if move==-77
replace  speech=. if speech==-77
replace  polpar=. if polpar==-77
replace  relfre=. if relfre==-77
replace  worker=. if worker==-77
replace  wecon=. if wecon==-77  /* 56 missing values */
replace  wopol=. if wopol==-77  /* 56 missing values */
replace  wosoc=. if wosoc==-77  /* 47 missing values */
replace  physint=. if physint==-66  /* 2 missing value */
replace  disap=. if disap==-66
replace  kill=. if kill==-66
replace  polpris=. if polpris==-66
replace  tort=. if tort==-66
replace  empinx=. if empinx==-66  /* 0 missing value */
replace  assn=. if assn==-66
replace  move=. if move==-66
replace  speech=. if speech==-66
replace  polpar=. if polpar==-66
replace  relfre=. if relfre==-66
replace  worker=. if worker==-66
replace  wecon=. if wecon==-66  /* 25 missing values */
replace  wopol=. if wopol==-66  /* 25 missing values */
replace  wosoc=. if wosoc==-66  /* 23 missing values */
gen wosum= wecon+ wopol+ wosoc
move wosum worker
notes wosum: gen wosum= wecon+ wopol+ wosoc (1444 missing values generated)
notes physint: CIRI variable with missing values replaced to be "."
notes empinx: CIRI variable with missing values replaced to be "."
notes wecon: CIRI variable with missing values replaced to be "."
notes wopol: CIRI variable with missing values replaced to be "."
notes wosoc: CIRI variable with missing values replaced to be "."
notes worker: CIRI variable with missing values as -66 and -77
notes physint_orig: CIRI variable with missing values as -66 and -77
notes empinx_orig: CIRI variable with missing values as -66 and -77
notes wecon_orig: CIRI variable with missing values as -66 and -77
notes wopol_orig: CIRI variable with missing values as -66 and -77
notes wosoc_orig: CIRI variable with missing values as -66 and -77

rename countryname donorname
replace donorname="Germany" if donorname=="German Federal Republic"
replace donorname="Italy" if donorname=="Italy/Sardinia"
replace donorname="United States" if donorname=="United States of America"
keep if donorname == "Australia" |  donorname == "Austria" |  donorname == "Belgium" |  donorname == "Canada" |  donorname == "Denmark" |  donorname == "Finland" |  donorname == "France" |  donorname == "Germany" |  donorname == "Ireland" |  donorname == "Italy" |  donorname == "Japan" |  donorname == "Luxembourg" |  donorname == "Netherlands" |  donorname == "New Zealand" |  donorname == "Norway" |  donorname == "Portugal" |  donorname == "Spain" |  donorname == "Sweden" |  donorname == "Switzerland" |  donorname == "United States" |  donorname == "United Kingdom" 

describe, simple
local varnames = r(varlist)
foreach VAR of local varnames {
   di "`VAR'"
   rename `VAR' donor_`VAR'
}
keep donor_*
rename donor_donorname donorname
rename donor_year year
  ** name some donor so that the merge works.  I use china because it seems to have the
  ** most observations.
gen countryname="China"
save "working/donorCIRI.dta", replace
use "working/dat2.dta", clear
merge countryname donorname year using "working/donorCIRI.dta", unique sort _merge(_merge_donorciri)
move _merge_donorciri population
drop if _merge_donorciri==2
drop _merge_donorciri
erase "working/donorCIRI.dta"

egen donor_physint2=max(donor_physint), by(donorname year)
replace donor_physint=donor_physint2 if donor_physint==.
drop donor_physint2





** ADD in the Affinity of Nations data from Gartzke
save "working/dat2.dta" , replace
clear
use "data/affinity_01242010_stata9.dta", clear

rename ccodea ccode1
rename ccodeb ccode2
** some cleanup
  ** the germanies
drop if ccode1==265
drop if ccode1==255
drop if ccode2==679 
drop if ccode1==679 
drop if ccode2==255 

gen country=""
gen partner=""
run "data/COW convert.do"
** the dyads are undirected, so I have to double the dataset
save affinitytmp, replace
rename country country1
rename partner country
rename country1 partner
append using affinitytmp

replace country="United States" if country=="United States of America"
replace country="Germany" if country=="German Federal Republic"

rename country donorname
rename partner countryname

drop if donorname=="" | countryname==""
gen OECD=1 if donorname=="United States" | donorname=="Austria" | donorname=="Belgium" | donorname=="Canada" | donorname=="Denmark" | donorname=="France" | donorname=="Germany" | donorname=="Greece" | donorname=="Iceland" | donorname=="Ireland" | donorname=="Italy" | donorname=="Luxembourg" | donorname=="Netherlands" | donorname=="Norway" | donorname=="Portugal" | donorname=="Spain" | donorname=="Sweden" | donorname=="Switzerland" | donorname=="Turkey/Ottoman Empire" | donorname=="United Kingdom"
replace OECD=1 if donorname=="Japan" | donorname=="Finland" | donorname=="Australia" | donorname=="New Zealand"
keep if OECD==1
drop OECD
run "data/Standardize Country Names.do"
keep donorname countryname year s2un* s3un*
save "working/affinity.dta", replace
use "working/dat2.dta", clear
merge countryname donorname year using "working/affinity.dta", unique sort _merge(_merge_affinity)
move _merge_affinity population
drop if _merge_affinity ==2
drop _merge_affinity 
erase "working/affinity.dta"
erase "affinitytmp.dta"

** make a binary affinity variable called "friend"

capture drop dyadnum
egen dyadnum=group(countryname donorname)
tsset dyadnum year
  ** had to take some stuff out because it isn't in the dataset yet
  ** but I think it makes exactly the same sample
gen inmysample=1 if l.physint!=. &  l.empinx!=. &  l.ln_rgdpc!=. &   l.ln_population!=. &   l.ln_trade!=. & l.alliance!=. & forces_DAC!=. & dyad_colony!=. & socialist!=. &  ColdWar!=. &  region_SSA!=. & region_Latin!=. & region_MENA!=. & region_EAsiaPac!=. & egypt_US!=. & israel_US!=. &  OECD!=1 

gen s3un = s3un4608i
_pctile s3un if inmysample==1, p(75)
local cutoff=r(r1)
gen friend = 1 if s3un>=`cutoff' & s3un!=.
replace friend = 0 if s3un<`cutoff' &s3un!=.
drop inmysample


** FRIEND NEIGHBOR
** This section creates a dummy variable coded as 1 if a recipient is contiguous with
**   a donor's UN friends. This takes a very long time, so only run it if something changes
**  Note, I actually ran it on the server

save "working/dat2.dta" , replace

/*  This is commented out because it takes forever to run
    I did it in 12 hours on the RCE servers
 ** Make the contiguity dataset
clear
insheet using "data\contdird.csv"
rename  state1no ccode1
rename  state2no ccode2
gen country=""
gen partner=""
do "data\COW convert.do"
rename partner countryname
do "data\Standardize Country Names.do"
do "data\Standardize Country Codes.do"
rename countryname partner
rename countrynumcode_g partnercode
rename country countryname
do "data\Standardize Country Names.do"
do "data\Standardize Country Codes.do"
drop if countryname==""
save "data\contiguous.dta", replace

**make a list of the ally-partners of each donor in each year
**take each recipient
**make a list of who it is contiguous with
** see if any countries on that list match the allies of each donor in that year



*******************************************
***** this loops it over all donors and all years
use "working/dat2.dta", clear

** make a dataset with top 25th percentile of trade partners
capture gen friendneighbor=.
keep donorname  countrynumcode_g countrycode_g countryname friend year friendneighbor
save "data\friendneighbor.dta", replace

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2002 {
    levelsof countryname if donorname=="`DONOR'" & friend==1 & year==`YEAR', local(friends)
    foreach FRIEND of local friends{
      di "`FRIEND'"
      use "data\contiguous.dta", clear
      levelsof countryname if partner=="`FRIEND'" & year==`YEAR', local(friendcontig)
      use "data\friendneighbor.dta", clear
      foreach NEIGHBOR of local friendcontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace friendneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "data\friendneighbor.dta", replace
    }
  }
}
*********************************************
save "data\friendneighbor.dta", replace
*/
clear
use "working/dat2.dta", clear
merge countryname donorname year using "data/friendneighbor.dta", unique sort _merge(_merge_friendneighbor)
move _merge_friendneighbor population
drop if _merge_friendneighbor==2
drop _merge_friendneighbor

  ** fill in with zeros
replace friendneighbor=0 if friendneighbor==. & year>=1980 & year<=2002
  ** drop out UN friends that border other UN friends
capture gen friendneighbor2=friendneighbor
capture replace friendneighbor=0 if friend==1


** the exact code I ran on the server was:
** note that I just moved "friendneighbor.dta", and "contiguous.dta" over there
/*
cd "/nfs/home/R/rnielsen/Desktop/friendneighbor/"
use "friendneighbor.dta", clear

levelsof donorname, local(dnames)

foreach DONOR of local dnames {
  foreach YEAR of numlist 1980/2002 {
    levelsof countryname if donorname=="`DONOR'" & friend==1 & year==`YEAR', local(friends)
    foreach FRIEND of local friends{
      di "`FRIEND'"
      use "/nfs/home/R/rnielsen/Desktop/friendneighbor/contiguous.dta", clear
      levelsof countryname if partner=="`FRIEND'" & year==`YEAR', local(friendcontig)
      use "/nfs/home/R/rnielsen/Desktop/friendneighbor/friendneighbor.dta", clear
      foreach NEIGHBOR of local friendcontig {
        di "`NEIGHBOR'"
        di "`DONOR'"
        di `YEAR'
        replace friendneighbor=1 if donorname=="`DONOR'" & countryname=="`NEIGHBOR'" & year==`YEAR'
      } 
      ** It kept eating my file--I think sleeping for a second helps it catch up
      sleep 500
      save "/nfs/home/R/rnielsen/Desktop/friendneighbor/friendneighbor.dta", replace
    }
  }
}
*********************************************
  ** because it is in Stata 10 on the servers
saveold "/nfs/home/R/rnielsen/Desktop/friendneighbor/friendneighbor.dta", replace


*/



** Ross' oil and gas data
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {

use "data/Ross Oil & Gas 1932-2006 public.dta", clear
rename cty_name countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if stateinyeart_g!=1
keep countryname year oil_gas_rentTOTAL
rename oil_gas_rentTOTAL rossoil
replace rossoil=rossoil/1000000000
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/tmp.dta", replace
use "working/dat2.dta", clear
merge countryname donorname year using "working/tmp.dta", unique sort _merge(_merge1)
drop if _merge1==2
drop _merge1
erase "working/tmp.dta"



** add in the Ron amnesty criticism data for recipients
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {

use "data/RONrrhrd8_isq.dta", clear
drop if country==141 & year<1992
drop if country==201 & year>1991
gen countryname_g = ""
rename iso countrycode_g
run "data/convert iso codes.do"
rename countryname_g countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
drop if countryname==""
keep countryname year avmdia ainr aibr
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/tmp.dta", replace
use "working/dat2.dta", clear
merge countryname donorname year using "working/tmp.dta", unique sort _merge(_merge1)
drop if _merge1==2
drop _merge1
erase "working/tmp.dta"


** add in the Ron amnesty criticism data for DONORS
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {

use "data/RONrrhrd8_isq.dta", clear
drop if country==141 & year<1992
drop if country==201 & year>1991
gen countryname_g = ""
rename iso countrycode_g
run "data/convert iso codes.do"
rename countryname_g countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
replace countryname = "United States" if countryname == "United States of America"
replace countryname = "Germany" if countryname == "German Federal Republic"
replace countryname = "Italy" if countryname == "Italy/Sardinia"
drop if countryname==""
keep countryname year avmdia ainr aibr
rename avmdia avmdia_donor
rename ainr ainr_donor
rename aibr aibr_donor
   keep if countryname == "`NAME'"
   rename countryname donorname
   gen countryname = "Afghanistan"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/tmp.dta", replace
use "working/dat2.dta", clear
merge countryname donorname year using "working/tmp.dta", unique sort _merge(_merge1)
egen aibrd = max(aibr_donor), by(donorname year)
egen ainrd = max(ainr_donor), by(donorname year)
drop aibr_donor ainr_donor

drop if _merge1==2
drop _merge1
erase "working/tmp.dta"



** Add Dannehl soviet aid data
save "working/dat2.dta" , replace
clear

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 

foreach NAME of local dnames {

use "data/master_foreign_aid_data_file.dta", clear
gen country = ""
rename code ccode1
run "data/COW convert.do"
drop if country==""
rename country countryname
run "data/Standardize Country Names.do"
run "data/Standardize Country Codes.do"
rename y1 sovietaidbach
rename y2 sovietaidcia
rename y3 prcaidbartke
rename y4 prcaidcia

keep countryname year soviet* prc*
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}
use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"
save "working/tmp.dta", replace
use "working/dat2.dta", clear
merge countryname donorname year using "working/tmp.dta", unique sort _merge(_merge1)
drop if _merge1==2
drop _merge1
erase "working/tmp.dta"

** make zeros
local A sovietaidbach sovietaidcia prcaidbartke prcaidcia
foreach i of varlist sovietaidbach sovietaidcia prcaidbartke prcaidcia {
  replace `i'=0 if `i' == .
}

save "working/dat2.dta" , replace
clear


***************************************************************
** Add in the aid data (created by the other master build file)
local dnames Australia Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 
foreach NAME of local dnames {
   use "data/disbursements 73-08.dta", clear
   gen donorname="`NAME'"
   save "working/`NAME'.dta", replace
   clear
}

use "working/Australia.dta", clear
local dnames Austria Belgium Canada Denmark Finland France Germany Ireland Italy Japan Luxembourg Netherlands "New Zealand" Norway Portugal Spain Sweden Switzerland "United States" "United Kingdom" 
 foreach NAME of local dnames {
   append using "working/`NAME'.dta"
   erase "working/`NAME'.dta"
}
erase "working/Australia.dta"

move donorname countryname
keep if  stateinyeart_g==1

**  DYADIZE the vars **
  ** this makes dyadic data out of the sector aid from each donor
local aidsectors hr cv el social econ total
foreach S of local aidsectors {
  gen dyadic_disb_`S' = .

  local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands Norway Sweden Switzerland
  foreach NAME of local dnames {
    replace  dyadic_disb_`S' = `NAME'_`S'_disb if donorname=="`NAME'"
    drop `NAME'_`S'_disb
  }

  replace  dyadic_disb_`S' = NewZealand_`S'_disb if donorname=="New Zealand"
   drop NewZealand_`S'_disb
  replace  dyadic_disb_`S' = US_`S'_disb if donorname=="United States"
   drop US_`S'_disb
  replace  dyadic_disb_`S' = UK_`S'_disb if donorname=="United Kingdom"
   drop UK_`S'_disb

}

  ** This converts the donor world aid vars into an overall world aid var
  **   that varies by donor-year.

local aidsectors hr cv el social econ
foreach S of local aidsectors {
  gen `S'_world_disb = .
  local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Norway Sweden
  foreach NAME of local dnames {
    replace  `S'_world_disb= `NAME'_`S'_wldaid_disb if donorname=="`NAME'"
    drop `NAME'_`S'_wldaid_disb
  }

replace  `S'_world_disb = NewZea_`S'_wldaid_disb if donorname=="New Zealand"
   drop NewZea_`S'_wldaid_disb
replace  `S'_world_disb = US_`S'_wldaid_disb if donorname=="United States"
   drop US_`S'_wldaid_disb 
replace  `S'_world_disb = UK_`S'_wldaid_disb if donorname=="United Kingdom"
   drop UK_`S'_wldaid_disb 
replace  `S'_world_disb = Neth_`S'_wldaid_disb if donorname=="Netherlands"
   drop Neth_`S'_wldaid_disb 
replace  `S'_world_disb = Switz_`S'_wldaid_disb if donorname=="Switzerland"
   drop Switz_`S'_wldaid_disb 
}



gen donor_world_disb = .

local dnames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Norway Sweden
foreach NAME of local dnames {
  replace  donor_world_disb = `NAME'_wldaid_disb if donorname=="`NAME'"
  drop `NAME'_wldaid_disb 
}

replace  donor_world_disb = NewZea_wldaid_disb if donorname=="New Zealand"
   drop NewZea_wldaid_disb 
replace  donor_world_disb = US_wldaid_disb if donorname=="United States"
   drop US_wldaid_disb 
replace  donor_world_disb = UK_wldaid_disb if donorname=="United Kingdom"
   drop UK_wldaid_disb 
replace  donor_world_disb = Neth_wldaid_disb if donorname=="Netherlands"
   drop Neth_wldaid_disb 
replace  donor_world_disb = Switz_wldaid_disb if donorname=="Switzerland"
   drop Switz_wldaid_disb 


save "working/Dyad disb for merge.dta", replace


clear
use "working/dat2.dta", clear
merge countryname donorname year using "working/Dyad disb for merge.dta", unique sort _merge(_merge_aid_vars)

erase "working/Dyad disb for merge.dta"
capture drop dyadnum
egen dyadnum=group(countryname donorname)
tsset dyadnum year


** Fills in for the main aggregated aid vars
   local aidcats hr cv el social econ total
   
   foreach cat of local aidcats {
     replace  disb_`cat'_mil=0 if  disb_`cat'_mil==. & year>1972 & year<2007
     replace  dyadic_disb_`cat'=0 if  dyadic_disb_`cat'==. & year>1972 & year<2007
   }

  ** World aid vars
   local aidcats2 hr cv el social econ

   foreach cat of local aidcats2 {
       replace  disb_`cat'_world_aid_mil=0 if  disb_`cat'_world_aid_mil==. & year>1972 & year<2007
       replace  `cat'_world_disb=0 if  `cat'_world_disb==. & year>1972 & year<2007
   }

  
   replace donor_world_disb=0 if donor_world_disb==. & year>1972 & year<2007

   ** single var that doesn't need a loop
   replace  disb_total_mil=0 if  disb_total_mil==. & year>1972 & year<2007
 
   ** single var that doesn't need a loop  
   replace  disb_world_aid_mil=0 if  disb_world_aid_mil==. & year>1972 & year<2007


drop _merge*

  ** some last minute changes
capture gen disb_hrcv_mil = disb_hr_mil + disb_cv_mil

sort donorname countryname year
save "working/dat2.dta" , replace



** Alliances by alliance type
/* Put in alliance data from ATOP by Ashley Leeds */
** The COW alliance data below only goes up to 2000
** I'm dropping it to use Ashley Leeds ATOP data

local A defense offense neutral nonagg consul
foreach a of local A {
  di "`a'"
  save "working/dat2.dta" , replace
  use "data/atop3_0dy.dta", clear
  keep  year `a' mem1 mem2
  rename mem1 ccode1
  rename mem2 ccode2
  gen country=""
  gen partner=""
  run "data/Cow convert.do"
  drop ccode*

   ** the dyads are directed so I recombine them as undirected
  save "working/allies1.dta", replace

  rename country country1
  rename partner country
  rename country1 partner
  append using "working/allies1.dta"

  replace partner="United States" if partner=="United States of America"
  replace partner="Germany" if partner=="German Federal Republic"
  gen DAC=1 if partner=="United States" | partner=="Austria" | partner=="Belgium" | partner=="Canada" | partner=="Denmark" | partner=="France" | partner=="Germany" |  partner=="Ireland" | partner=="Italy" | partner=="Luxembourg" | partner=="Netherlands" | partner=="Norway" | partner=="Portugal" | partner=="Spain" | partner=="Sweden" | partner=="Switzerland" | partner=="United Kingdom"
  replace DAC=1 if partner=="Japan" | partner=="Finland" | partner=="Australia" | partner=="New Zealand" 

  drop if DAC!=1
  rename country countryname
  rename partner donorname
  rename `a' alliance_`a'

  drop  DAC
  duplicates drop
  drop if countryname=="German Federal Republic" & year==1990
  run "data/Standardize Country Names.do"
  drop if year<1948
  duplicates drop countryname donorname year, force
  save "working/tmp.dta", replace
  use "working/dat2.dta", clear
  merge countryname donorname year using "working/tmp.dta", unique sort _merge(_merge1)
  drop if _merge1==2
  drop _merge1
  erase "working/tmp.dta"

  /*  This fills in the countries that had no alliances and thus weren't counted correctly */
  replace alliance_`a'=0 if alliance_`a'==. & year<2004
}

erase "working/allies1.dta"


** making a post 2001 dummy
gen post2001 = year>2001



/* Setting the time series */
capture drop dyadnum
egen dyadnum=group(countryname donorname)
tsset dyadnum year

********************************************
** changes right before running the models


gen war = priowar

gen coldwarsoc = ColdWar*socialist

** making a "treatment"
gen physabuse=1 if l.physint<=3
replace physabuse=0 if l.physint>3 & l.physint!=.


	** make aid pc vars
gen aidpc=(dyadic_aid_total*1000000)/population
gen hraidpc=(dyadic_aid_hr*1000000)/population
gen cvaidpc=(dyadic_aid_cv*1000000)/population
gen econaidpc=(dyadic_aid_econ*1000000)/population
gen socaidpc=(dyadic_aid_social*1000000)/population
gen dyadic_aid_hrcv = dyadic_aid_hr + dyadic_aid_cv
gen hrcvaidpc=(dyadic_aid_hrcv*1000000)/population

    ** disbursements
gen disbpc=(dyadic_disb_total*1000000)/population
gen hrdisbpc=(dyadic_disb_hr*1000000)/population
gen cvdisbpc=(dyadic_disb_cv*1000000)/population
gen econdisbpc=(dyadic_disb_econ*1000000)/population
gen socdisbpc=(dyadic_disb_social*1000000)/population
gen dyadic_disb_hrcv = dyadic_disb_hr + dyadic_disb_cv
gen hrcvdisbpc=(dyadic_disb_hrcv*1000000)/population


	** ln aid pc
gen lnaidpc=ln(aidpc+1)
gen lnhraidpc=ln(hraidpc+1)
gen lncvaidpc=ln(cvaidpc+1)
gen lneconaidpc=ln(econaidpc+1)
gen lnsocaidpc=ln(socaidpc+1)
gen lnhrcvaidpc = ln(hrcvaidpc+1)

  ** ln disbursements
gen lndisbpc=ln(disbpc+1)
gen lnhrdisbpc=ln(hrdisbpc+1)
gen lncvdisbpc=ln(cvdisbpc+1)
gen lnecondisbpc=ln(econdisbpc+1)
gen lnsocdisbpc=ln(socdisbpc+1)
gen lnhrcvdisbpc = ln(hrcvdisbpc+1)

	** gen ln of aid levels vars
gen lnaid=ln((dyadic_aid_total*1000000)+1)
gen lneconaid=ln((dyadic_aid_econ*1000000)+1)
gen lnsocaid=ln((dyadic_aid_social*1000000)+1)
gen lnhraid=ln((dyadic_aid_hr*1000000)+1)
gen lncvaid=ln((dyadic_aid_cv*1000000)+1)


* a couple more squared terms for the GAMs
gen tradesq=(ln_trade)^2
gen forcesq=(forces_DAC)^2


** flip physint
recode physint (0=8) (1=7) (2=6) (3=5) (5=3) (6=2) (7=1) (8=0), gen(physintflip)
drop physint
rename physintflip physint

recode donor_physint (0=8) (1=7) (2=6) (3=5) (5=3) (6=2) (7=1) (8=0), gen(donorHR)



	** making lagged variables for the matching
gen lphysint=l.physint
*gen lphysfactor=l.physint_factor
gen lempinx=l.empinx
gen lln_rgdpc=l.ln_rgdpc
gen lln_population=l.ln_population
gen lln_trade=l.ln_trade
gen lalliance=l.alliance
gen lwar=l.war
gen lln_rgdpc_sq=l.ln_rgdpc_sq
gen lempinx_sq=l.empinx_sq
gen lln_population_sq=l.ln_population_sq
gen ltradesq=l.tradesq
gen lforcesq=l.forcesq
gen ls3un = l.s3un
gen lrossoil = l.rossoil

gen llnaidpc=l.lnaidpc
gen llnhraidpc=l.lnhraidpc
gen llncvaidpc=l.lncvaidpc
gen llnhrcvaidpc=l.lnhrcvaidpc
gen llneconaidpc=l.lneconaidpc
gen llnsocaidpc=l.lnsocaidpc


gen lnworldaidtotal=ln((donor_world_aid*1000000)+1)
gen lnworldaidhr=ln((hr_world_aid*1000000)+1)
gen lnworldaidcv=ln((cv_world_aid*1000000)+1)
gen lnworldaidecon=ln((econ_world_aid*1000000)+1)
gen lnworldaidsoc=ln((social_world_aid*1000000)+1)
gen lnworldaidhrcv = ln((hr_world_aid*1000000 + cv_world_aid*1000000)+1)



  ** make some variables
gen ratpercent_physint = ratpercent*physint
gen donor_physint_physint = donor_physint * physint
gen donorallyneighbor2=donorallyneighbor
replace donorallyneighbor2=0 if alliance==1
gen allyneighbor2_physint=donorallyneighbor2 * physint
gen alliance_physint = alliance*physint
gen friend_physint = friend * physint
gen friendneighbor_physint = friendneighbor * physint
gen lnnytimes_physint = lnnytimes * physint
gen lnnytmachine_physint = lnnytmachine * physint
gen lnreftotal_physint = lnreftotal * physint
gen ColdWar_physint = ColdWar * l.physint
gen colony_physint = dyad_colony*physint
gen lntrade_physint = ln_trade*physint
gen rossoil_physint = rossoil*physint
gen aibr_physint = aibr*physint
gen aibrd_physint = aibrd*physint
egen meanaibrd_physint = mean(aibrd_physint), by(donorname year)
gen s3un_physint = s3un * physint

  ** make dummies for the gate-keeping models
gen hrcvaidrecip=1 if usd2_hrcv_bil>0
replace hrcvaidrecip=0 if usd2_hrcv_bil==0
replace hrcvaidrecip=. if usd2_hrcv_bil==.
gen econaidrecip=1 if usd2_econ_bil>0
replace econaidrecip=0 if usd2_econ_bil==0
replace econaidrecip=. if usd2_econ_bil==.
gen socaidrecip=1 if usd2_social_bil>0
replace socaidrecip=0 if usd2_social_bil==0
replace socaidrecip=. if usd2_social_bil==.
gen totalaidrecip=1 if usd2_total_bil>0
replace totalaidrecip=0 if usd2_total_bil==0
replace totalaidrecip=. if usd2_total_bil==.

gen lratpercent = l.ratpercent
gen lratpercent_physint = l.ratpercent_physint
gen ldonor_physint = l.donor_physint
gen ldonor_physint_physint = l.donor_physint_physint
gen ldonorallyneighbor2 = l.donorallyneighbor2
gen lallyneighbor2_physint = l.allyneighbor2_physint
gen lalliance_physint = l.alliance_physint
gen lfriend = l.friend
gen lfriend_physint = l.friend_physint
gen lfriendneighbor = l.friendneighbor
gen lfriendneighbor_physint = l.friendneighbor_physint
gen llnnytimes = l.lnnytimes
gen llnnytimes_physint = l.lnnytimes_physint
gen llnreftotal = l.lnreftotal
gen llnreftotal_physint = l.lnreftotal_physint
gen llnnytmachine = l.lnnytmachine
gen llnnytmachine_physint = l.lnnytmachine_physint
gen lcolony_physint = l.colony_physint
gen llntrade_physint = l.lntrade_physint
gen ls3un_physint = l.s3un_physint


*gen inmysample=1 if lnaidpc!=1 & l.physint!=. &  l.empinx!=. & l.lnaidpc!=. &  lnworldaidtotal!=. &  l.ln_rgdpc!=. &   l.ln_population!=. &   l.ln_trade!=. & l.alliance!=. & forces_DAC!=. & dyad_colony!=. & socialist!=. &  ColdWar!=. & l.war!=. &  region_SSA!=. & region_Latin!=. & region_MENA!=. & region_EAsiaPac!=. & egypt_US!=. & israel_US!=. &  OECD!=1 

*xttobit lnaidpc l.physint l.polity2 l.lnaidpc lnworldaidtotal l.ln_rgdpc l.ln_rgdpc_sq l.ln_population l.ln_population_sq l.ln_trade l.tradesq l.alliance dyad_colony socialist ColdWar coldwarsoc l.war region_SSA region_Latin region_MENA region_EAsiaPac egypt_US israel_US if OECD!=1, ll(0)
xtreg lnaidpc l.physint l.polity2 l.lnaidpc lnworldaidtotal l.ln_rgdpc l.ln_rgdpc_sq l.ln_population l.ln_population_sq l.ln_trade l.tradesq l.alliance dyad_colony socialist ColdWar coldwarsoc l.war region_SSA region_Latin region_MENA region_EAsiaPac egypt_US israel_US if OECD!=1
gen inmysample = e(sample)


/* Setting the time series */
capture drop dyadnum
egen dyadnum=group(countryname donorname)
tsset dyadnum year


compress




save "working/dat2.dta" , replace





****End of do-file****
beep
****End of do-file****








