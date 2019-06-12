****************************
** FDI with my own dataset
**   Copied from FDI 1.0 on May 30, 2009
****************************

/*	This is the master do file to create the FDI dataset

	Rich Nielsen, rnielsen@fas.harvard.edu
	Last modified: 24 November, 2007   */

/*	The original data and do files all use the directory:
	F:\1.Most of my stuff\Research Projects\2.with Nielson\Foreign Aid and FDI\FDI 1.0\FDI master data and do files
	If they are no longer in this location, then the
	directories will need to be changed  */

*I use Gleditsch's improved GDP var as the base
*See his readme_4.1 file for definitions of these vars.


clear
insheet using "aid/rawdata/gleditsch/expgdpv5.0/expgdp_v5.0.asc", delimiter(" ")
gen countryname_g="proper(countryname)"
rename stateid countrycode_g
run "pta/scripts/Standardize Country Codes.do"
move  countryname_g countrycode_g
drop countrynumcode_g origin
rename statenum countrynumcode_g
sort  countryname_g year
rename  pop population //(Units are in 1000's)
replace population = population*1000
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

save "fdi/rawdata/RR fdi data.dta" , replace



/* this section adds trade */
** Note that I'm now using the trade statistics from COPE put
** together by Josh Loud rather than Gleditsch's data because
** the Gleditsch data stops at 2000.

clear

use "fdi/rawdata/COPE.Master.Complete.11June07.dta", clear
keep countryname partner year trademd
rename trademd totaltrade1

gen DAC=1 if partner=="United States of America" | partner=="Austria" | partner=="Belgium" | partner=="Canada" | partner=="Denmark" | partner=="France" | partner=="German Federal Republic" |  partner=="Ireland" | partner=="Italy/Sardinia" | partner=="Luxembourg" | partner=="Netherlands" | partner=="Norway" | partner=="Portugal" | partner=="Spain" | partner=="Sweden" | partner=="Switzerland" | partner=="United Kingdom"
replace DAC=1 if partner=="Japan" | partner=="Finland" | partner=="Australia" | partner=="New Zealand" 
drop if DAC!=1
egen trade = sum(totaltrade1), by(countryname year)
egen trade_DAC=sum(totaltrade1) if DAC==1, by(countryname year)
*notes trade_DAC: I think these trade data are given in millions of current year US dollars
**                In any case, check with Josh who put it together.
drop  partner  totaltrade1 DAC
duplicates drop
gen ln_trade_DAC=ln((trade_DAC*1000000)+1)
gen ln_trade=ln((trade*1000000)+1)
save "fdi/rawdata/Trade data for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/Trade data for merge.dta", unique sort _merge(_merge_trade_vars)
move _merge_trade_vars population
tab countryname if _merge_trade_vars==2
*drop if _merge_trade_vars==2 /*This drops micro-states and oddly New Zealand before 1968.  Not sure why */
drop _merge_trade_vars
erase "fdi/rawdata/Trade data for merge.dta"



/* This section adds democracy and regime durability from Polity IV */
save "fdi/rawdata/RR fdi data.dta" , replace
clear
insheet using "fdi/rawdata/p4v2006.csv"
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

run "pta/scripts/Standardize Country Names.do"
run "pta/scripts/Standardize Country Codes.do"
move  countrycode_g year
drop if  countrycode_g=="Country Code (Gleditsch)"
keep countryname year polity2 durable
/* This part drops the -66, -77, -88 (foreign occ, anarchy, and transition, respective) */
/* It might be a good idea to estimate the transition values */
replace polity2=. if polity2==-77
save "fdi/rawdata/Polity var for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/Polity var for merge.dta", unique sort _merge(_merge_polity_vars)
move _merge_polity_vars population
tab countryname if  _merge_polity_vars==2
*drop if _merge_polity_vars==2
drop _merge_polity_vars

erase "fdi/rawdata/Polity var for merge.dta"


/* This part adds ICRG variables */
/*This section adds the ICRG governance variables */
save "fdi/rawdata/RR fdi data.dta" , replace
clear
use "fdi/rawdata/ICRG.complete.dta", clear
rename country countryname
/* This solves some duplicates */
drop if countryname=="Germany" & year<=1990
drop if countryname=="West Germany" & year>=1991
drop if countryname=="East Germany" & year>=1991
drop if countryname=="Czech Republic" & year<=1992
drop if countryname=="Czechoslovakia" & year>=1993
drop if countryname=="Russia" & year<=1991
drop if countryname=="USSR" & year>=1992
do "pta/scripts/Standardize Country Names.do"
do "pta/scripts/Standardize Country Codes.do"
drop if  countrycode_g=="Country Code (Gleditsch)" /* drops Hong Kong, New Caledonia */
keep  countryname year corruption_icrg government_stability_icrg
save "fdi/rawdata/ICRG governance var for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/ICRG governance var for merge.dta", unique sort _merge(_merge_icrg_var)
move _merge_icrg_var population
tab countryname if _merge_icrg_var==2
*drop if _merge_icrg_var==2 /*just drops non-independent states */
drop _merge_icrg_var

erase "fdi/rawdata/ICRG governance var for merge.dta"


/* This part merges in Li and Renick's dataset */
save "fdi/rawdata/RR fdi data.dta" , replace
clear
use "fdi/rawdata/QL replication", clear
rename country countryname
do "pta/scripts/Standardize Country Names.do"
do "pta/scripts/Standardize Country Codes.do"
rename   growth ql_growth
rename  cow ql_cow
rename  control8 ql_control8
rename  durable ql_durable
rename  dem ql_dem
rename selection ql_selection
rename  constraint ql_constraint
rename  participate ql_participate
rename  property2index ql_property2index
rename  fdiinflead ql_fdiinflead
rename  wfdiinflead ql_wfdiinflead
rename  loggdp ql_loggdp
rename  loggdppc ql_loggdppc
rename  instab ql_instab
rename  oecd ql_oecd
rename  chrmwi ql_chrmwi
rename  lproperty2 ql_lproperty2
rename  exdev ql_exdev
rename  otherproperty ql_otherproperty
rename  dempr ql_dempr
rename  fdisharelead ql_fdisharelead
rename  fdiinfgdplead ql_fdiinfgdplead
rename  polrightn ql_polrightn
rename  civlibn ql_civlibn
rename  freedom ql_freedom
rename  sample ql_sample
save "fdi/rawdata/QL replication for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/QL replication for merge.dta", unique sort _merge(_merge_QL)
move _merge_QL population
/*There is a problem with Czech rep., Slovokia, and Czechoslovakia.
  Li and Resnick have them in the dataset seperately from 82-92, but they are
  missing variables so I really doubt that they were in their regressions anyways
  so I drop them here.  These are the only 2's.*/
tab countryname if _merge_QL==2
*drop if _merge_QL==2 
drop _merge_QL

erase "fdi/rawdata/QL replication for merge.dta"


/* This part merges in the WDI variables */
save "fdi/rawdata/RR fdi data.dta" , replace
clear
insheet using "fdi/rawdata/wdi data.1.csv"
rename  bnkltdinvcdforeigndirectinvestme  fdi1
rename  bxkltdinvdtgdzsforeigndirectinve fdi2
rename  bxkltdinvdtgizsforeigndirectinve fdi3
rename  bxkltdinvcdwdforeigndirectinvest fdi4
rename  bgkltdinvgdzsgrossforeigndirecti fdi5
rename  negditotlzsgrosscapitalformation capformation
rename  nygdpmktpkdgdpconstant2000us gdp2000
rename  nygdpmktpcdgdpcurrentus gdpcurrent
rename  nygdpmktpkdzggdpgrowthannual gdpgrowth
rename  nygdppcapkdzggdppercapitagrowtha gdpgrowthpc
rename  nygdppcapkdgdppercapitaconstant2 gdppc2000
rename  txvaltechmfzshightechnologyexpor techexports
rename  txvaltechcdhightechnologyexports techexports2
rename  txvalagrizsunagriculturalrawmate agricultexports
rename  txvalservcdwtcommercialserviceex commservexports
drop  txvalothrzswtcomputercommunicati
rename  bxgsrgnfscdexportsofgoodsandserv exportscurrentbop
rename  neexpgnfskdexportsofgoodsandserv exports2000
rename  neexpgnfscdexportsofgoodsandserv exportscurrent
rename  txvalfoodzsunfoodexportsofmercha foodexports
rename  txvalfuelzsunfuelexportsofmercha fuelexports
do "pta/scripts/Standardize Country Names.do"
do "pta/scripts/Standardize Country Codes.do"
save "fdi/rawdata/wdi.1 for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/wdi.1 for merge.dta", unique sort _merge(_merge_wdi1)
move _merge_wdi1 population
tab countryname if _merge_wdi1==2 
*drop if _merge_wdi1==2 
drop _merge_wdi1
gen fdiin= fdi2* gdpcurrent
move fdiin fdi1

erase "fdi/rawdata/wdi.1 for merge.dta"

save "fdi/rawdata/RR fdi data.dta" , replace
clear
insheet using "fdi/rawdata/wdi data.2.csv"
rename  panusfcrfofficialexchangeratelcu exrate
rename  fpcpitotlzginflationconsumerpric inflationcpi
rename  nygdpdeflkdzginflationgdpdeflato gdpdeflator
rename  txvalmanfzsunmanufacturesexports manufacturesexports
rename  txvalmrchcdwtmerchandiseexportsc merchexports
rename  txvalmmtlzsunoresandmetalsexport oremetalexports
do "pta/scripts/Standardize Country Names.do"
do "pta/scripts/Standardize Country Codes.do"
save "fdi/rawdata/wdi.2 for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/wdi.2 for merge.dta", unique sort _merge(_merge_wdi2)
move _merge_wdi2 population
tab countryname if _merge_wdi2==2 
*drop if _merge_wdi2==2 
drop _merge_wdi2
egen exratemdev_80_00=mdev(exrate), by(countryname)

erase "fdi/rawdata/wdi.2 for merge.dta"



save "fdi/rawdata/RR fdi data.dta" , replace
clear
insheet using "fdi/rawdata/wdi data.3.csv"
rename  pxrexreerrealeffectiveexchangera realexrate
do "pta/scripts/Standardize Country Names.do"
do "pta/scripts/Standardize Country Codes.do"
save "fdi/rawdata/wdi.3 for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/wdi.3 for merge.dta", unique sort _merge(_merge_wdi3)
move _merge_wdi3 population
tab countryname if _merge_wdi3==2 
*drop if _merge_wdi3==2 
drop _merge_wdi3

erase "fdi/rawdata/wdi.3 for merge.dta"



/* This adds the Sachs Warner data */
save "fdi/rawdata/RR fdi data.dta" , replace
clear
use "fdi/rawdata/Sachs and Warner.dta", clear
keep  country year sxp80
rename country countryname
do "pta/scripts/Standardize Country Names.do"
do "pta/scripts/Standardize Country Codes.do"
*This drops non-independent territories
drop if  countrycode_g=="Country Code (Gleditsch)"
save "fdi/rawdata/sachs warner for merge.dta", replace
clear
use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/sachs warner for merge.dta", unique sort _merge(_merge_sachs)
move _merge_sachs population
tab countryname if _merge_sachs==2 
*drop if _merge_sachs==2 
drop _merge_sachs
egen sxp80_1=mean(sxp80),by(countryname)

erase "fdi/rawdata/sachs warner for merge.dta"


/* Adding in the CIRI data */
save "fdi/rawdata/RR fdi data.dta" , replace
clear
insheet using "fdi/rawdata/data.CIRI.csv"
rename ctry countryname
/* The fix below deleted missing values where Gleditsch treats the
	countries as continuous and CIRI treats them as separate  */
drop if countryname=="Soviet Union" & year>=1992
drop if countryname=="Russia" & year<=1991
drop if countryname=="Yemen Arab Republic (North Yemen)" & year>=1991
drop if countryname=="Yemen" & year<=1990
do "pta/scripts/Standardize Country Names.do"
/*	There are no 1980 values in the CIRI database.  Is this my fault?
  	The -999's in CIRI are for when there was no mention in the reports
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
save "fdi/rawdata/CIRI vars for merge.dta" , replace
clear
use "fdi/rawdata/RR fdi data", clear
merge countryname year using "fdi/rawdata/CIRI vars for merge.dta", unique sort _merge(_merge_ciri_vars)
move  _merge_ciri_vars population
/* I checked: this deletes states not in Gleditsch--either micro states or not yet independent
	The only states left as _merge 2's are thos from 2001-2004  */
tab countryname if _merge_ciri_vars==2
*drop if _merge_ciri_vars==2
drop  _merge_ciri_vars
* This makes squared terms for physint, empinx, and wosum.
capture gen physint_sq=physint*physint
capture gen empinx_sq=empinx*empinx
capture gen wosum_sq=wosum*wosum

erase "fdi/rawdata/CIRI vars for merge.dta"


/*  Add World Bank Area Dummies */
do "fdi/rawdata/Make world bank geographic regions.09.03.07.do"

/*  This adds an OECD variable, as defined by the World Bank, 2006 */
gen OECD=1 if countryname=="United States of America" | countryname=="Austria" | countryname=="Belgium" | countryname=="Canada" | countryname=="Denmark" | countryname=="France" | countryname=="German Federal Republic" | countryname=="Greece" | countryname=="Iceland" | countryname=="Ireland" | countryname=="Italy/Sardinia" | countryname=="Luxembourg" | countryname=="Netherlands" | countryname=="Norway" | countryname=="Portugal" | countryname=="Spain" | countryname=="Sweden" | countryname=="Switzerland" | countryname=="Turkey/Ottoman Empire" | countryname=="United Kingdom"
replace OECD=1 if countryname=="Japan" | countryname=="Finland" | countryname=="Australia" | countryname=="New Zealand"
/*Not sure about these ones--these are the new members?*/
replace OECD=1 if countryname=="Mexico" | countryname=="Czech Republic"  | countryname=="Hungary" | countryname=="Poland" | countryname=="Korea, Republic of" | countryname=="Slovakia"
replace OECD=0 if OECD!=1



/* Setting the time-series */
drop countrynum
egen countrynum=group(countryname)
tsset countrynum year


save "fdi/rawdata/RR fdi data.dta" , replace

clear
set mem 700M
set more off

** load the treaty data and format it
insheet using "other/ICCPR and CAT through 2008.csv"

  rename name countryname
  rename iccprob iccpr
  rename opirat opt1
  rename catob cat

  drop if countryname=="Czechos"
  drop if countryname=="YemenAR"

  run "pta/scripts/Standardize Country Names.do"
  run "pta/scripts/Standardize Country Codes.do"
   
  tab countryname if countrycode_g=="Country Code (Gleditsch)"



  ** make dummy variables for each year after ratification
  ** PROBLEM:  what do we do with a case like the USSR/Russia, where the ratification isn't new
  **  but the rules I've coded here would count it as new because it is a "new" country
  
  local hras iccpr opt1 cat art22
  foreach HRA of local hras {
    gen `HRA'_yrs = 0 if `HRA'==0
    replace `HRA'_yrs=1 if `HRA'==1 & `HRA'[_n-1]==0 & countryname==countryname[_n-1]
      ** the line below makes it so that "new" states (USSR -> Russia)
      **    start over on their ratification year.
      ** leaving it out leaves these states with missing values which doesn't seem right either.
    *replace `HRA'_yrs=1 if `HRA'==1 & countryname!=countryname[_n-1]
    replace `HRA'_yrs = `HRA'_yrs[_n-1]+1 if `HRA'_yrs==. & `HRA'!=. & countryname==countryname[_n-1]
  }

  ** what if the rewards come prior to the ratification?
  ** we make a second ratification years that has the year 6 years prior to ratification as the base year
  egen countrynum = group(countryname)
  tsset countrynum year

  local hras iccpr opt1 cat art22
  foreach HRA of local hras {
    gen `HRA'_yrs2 = f10.`HRA'_yrs  
    replace `HRA'_yrs2 = `HRA'_yrs2[_n-1]+1 if `HRA'_yrs2[_n-1]>0 & `HRA'_yrs2[_n-1]!=. & `HRA'_yrs2==. & `HRA'!=. & countryname==countryname[_n-1]
    replace `HRA'_yrs2 = 0 if `HRA'_yrs2[_n-1]==0 & `HRA'_yrs2==. & `HRA'!=. & countryname==countryname[_n-1]
  }



save "fdi/rawdata/treaties.dta", replace
clear



use "fdi/rawdata/RR fdi data.dta", clear
merge countryname year using "fdi/rawdata/treaties.dta", unique sort
drop countrynum
egen countrynum=group(countryname)
tsset countrynum year
erase "fdi/rawdata/treaties.dta"

save "fdi/rawdata/RR fdi data.dta" , replace

beep

*********************************
** DONE building the data
*********************************



