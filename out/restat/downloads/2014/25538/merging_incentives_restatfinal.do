cd ""


set mem 11g

/*--------------------------------------------*
|  MERGING AUTODATA INCENTIVE DATA TOGETHER   |
*---------------------------------------------*/



use incentivevehicles, clear
*THERE ARE SOME OBS IN THIS DATASET THAT ARE REPEATED*
contract incuid acode
drop _freq
sort incuid acode
merge m:1 incuid using incentives
*rename _merge merge1
*I CAN'T USE THE INCENTIVE IF I DON'T KNOW THE ACODE*
drop if _merge == 2
drop _merge

sort incuid
joinby incuid using IncentiveRegions

*drop if merge1==2

sort acode
*merge m:1 acode using gaspricemodels_revised
merge m:1 acode using gaspricemodels

/* WHEN MERGE==2 IT'S FOR THE "EXOTIC" BRANDS.  */

*save temp0, replace
keep if _merge==3
drop _merge


/*--------------------*
|  EXTRACTING DATES   |
*--------------------*/

split startdateuid, parse(" ")
rename startdateuid1 startdate
gen statastartdate=date(startdate,"MDY")
drop startdateuid2

split startdate, parse("/")
rename startdate1 startmonth
rename startdate2 startday
rename startdate3 startyear
destring startmonth, replace
destring startday, replace
destring startyear, replace

drop if startyear>=2007

split enddateuid, parse(" ")
rename enddateuid1 enddate
gen stataenddate=date(enddate,"MDY")
drop enddateuid2

split enddate, parse("/")
rename enddate1 endmonth
rename enddate2 endday
rename enddate3 endyear
destring endmonth, replace
destring endday, replace
destring endyear, replace

gen length=stataenddate-statastartdate
drop if length<0


*** Nate added this:
drop if endyear==2078 | endyear<2003
drop if startyear==1900




/*---------------------------------------------*
|  EDITING DATES AND GENERATING SALE LENGTHS   |
*---------------------------------------------*/

*gen truncated=0
*replace truncated=1 if endyear>=2007
*replace endmonth=12 if truncated==1
*replace endday=31 if truncated==1
*replace endyear=2006 if truncated==1
*replace enddate="12/31/2006" if truncated==1
replace stataenddate=date(enddate,"MDY")


*gen startweek=week(statastartdate)
*gen endweek=week(stataenddate)

gen startdow=dow(statastartdate)
gen enddow=dow(stataenddate)

***Nate's note: 0=Sunday, 1=Monday, etc.
***  tend to start Tues-Thurs/Fri, tend to end Mon-Wed.


gen nextmon=statastartdate+(8-startdow) if startdow>1
replace nextmon=statastartdate if startdow==1
replace nextmon=statastartdate+1 if startdow==0

gen salelength=stataenddate-statastartdate+1

drop if (startdow>1 & salelength<=(8-startdow)) | (startdow==0 & salelength==1)

gen saleweeks=ceil(salelength/7)
replace saleweeks = floor(salelength/7) if startdow>1 & salelength-(7*floor(salelength/7))<=(8-startdow)



*replace saleweeks=saleweeks+1 if enddow>=1 & startdow>enddow
compress

/*-------------------------------------------*
|  IDENTIFY THE DATE OF THE FIRST INCENTIVE  |
*-------------------------------------------*/

sort acode statastartdate

egen firstdate=min(statastartdate), by(acode)

/*---------------------------------------------*
|  CREATE ONE OBSERVATION FOR EACH SALE WEEK   |
*---------------------------------------------*/
duplicates drop 

count
gen limited = 0
replace limited = 1 if strpos(masterprogram,"College")
replace limited = 1 if strpos(masterprogram,"Farm Bureau Member")
*replace limited = 1 if strpos(masterprogram,"Owner Loyalty")
replace limited = 1 if strpos(masterprogram,"Employee Purchase")
replace limited = 1 if strpos(masterprogram,"Private Offer")
replace limited = 1 if strpos(masterprogram,"Supplier Discount")
replace limited = 1 if strpos(masterprogram,"On-The-Job Commercial")
replace limited = 1 if strpos(masterprogram,"Loyalty")
replace limited = 1 if strpos(masterprogram,"Employee")
*replace limited = 0 if strpos(masterprogram,"Employee") & startyear==2005
replace limited = 1 if strpos(masterprogram,"Supplier Appreciation")
replace limited = 1 if strpos(masterprogram,"Military")
replace limited = 1 if strpos(masterprogram,"Valued Owner Coupon")
replace limited = 1 if strpos(masterprogram,"Competitive Owner")
replace limited = 1 if strpos(masterprogram,"Driving School")
replace limited = 1 if strpos(masterprogram,"School Loaner")
replace limited = 1 if strpos(masterprogram,"Retiree")
replace limited = 1 if strpos(masterprogram,"Supplier/FLEET")
replace limited = 1 if strpos(masterprogram,"AARP")
replace limited = 1 if strpos(masterprogram,"Driver's Education")
replace limited = 1 if strpos(masterprogram,"Fleet")
replace limited = 1 if strpos(masterprogram,"Dealership Personnel")
replace limited = 1 if strpos(variationdesc,"Diesel")
replace limited = 0 if strpos(masterprogram,"Everyone")


gen manufacturer=""
replace manufacturer="Honda" if division=="Acura" | division=="Honda" 
replace manufacturer="GM" if division=="Buick" | division=="Cadillac" | division=="Chevrolet" | division=="GMC" | division=="Hummer" | division=="Oldsmobile" | division=="Pontiac" | division=="Saab" | division=="Saturn" 
replace manufacturer="DaimlerChrysler" if division=="Chrysler" | division=="Dodge" | division=="Jeep"
replace manufacturer="Ford" if division=="Ford" | division=="Jaguar" | division=="Land Rover" | division=="Lincoln" | division=="Mercury" | division=="Volvo"
replace manufacturer="Toyota" if division=="Toyota" | division=="Lexus" | division=="Scion"

drop if manufacturer=="Honda"
drop if manufacturer==""

gen mpg=.55*hwympg+.45*citympg
label variable mpg ".55*hwympg+.45*citympg"
drop if mpg==.

compress


/*---------------------------------*
|  GENERATE WEEKLY CASH INCENTIVE  |
*---------------------------------*/

gen cash2=subinstr(cash,"$","",.)
destring cash2, replace
gen incentive=cash2
replace incentive=. if incentive==0

/*-----------------------------------------------*
|  MERGING REGION DEFINITIONS OF INCENTIVES IN   |
*-----------------------------------------------*/
replace regdesc=trim(regdesc)
*sort regdesc
rename regdesc RegionName
sort incuid RegionName
merge m:1 incuid RegionName using incentivedraft2
drop if _merge==2
drop _merge

/*----------------------------------------*
|  GET DESCRIPTIVE STATISTICS: TABLE 1	  |
*----------------------------------------*/

*codebook length if incentive!=.
codebook length if limited==0 & incentive!=.
*codebook length if limited==1 & incentive!=.
*tab limited
*codebook incentive if incentive!=.
codebook incentive if limited==0 & incentive!=.
*codebook incentive if limited==1 & incentive!=.
egen numveh = count(limited) if limited==0 & incentive!=., by(incuid)
codebook numveh if limited==0 & incentive!=.

/*
* Descriptive statistics by region
codebook incentive if ECA==1 & limited==0 & incentive!=.
codebook incentive if MWA==1 & limited==0 & incentive!=.
codebook incentive if GCA==1 & limited==0 & incentive!=.
codebook incentive if RMA==1 & limited==0 & incentive!=.
codebook incentive if WCA==1 & limited==0 & incentive!=.
codebook incentive if ECA==1 & MWA==1 & GCA==1 & RMA==1 & WCA==1 & limited==0 & incentive!=.

codebook incentive if ECA==1 & limited==1 & incentive!=.
codebook incentive if MWA==1 & limited==1 & incentive!=.
codebook incentive if GCA==1 & limited==1 & incentive!=.
codebook incentive if RMA==1 & limited==1 & incentive!=.
codebook incentive if WCA==1 & limited==1 & incentive!=.
codebook incentive if ECA==1 & MWA==1 & GCA==1 & RMA==1 & WCA==1 & limited==1 & incentive!=.

codebook incentive if ECA==1 & MWA==1 & GCA==1 & RMA==1 & WCA==1 & incentive!=.
*/




drop if limited==1
drop limited
count

save temp0, replace
*	NATE'S NOTE: TEMP0 SAVED, CALL IT AND CONTINUE DEBUGGING


foreach y in "2003" "2004" "2005" "2006" {
*foreach y in "2004" "2005" "2006" {

use temp0, clear

*** Cutting down the data for speed ***

keep if year==`y'
*keep if year==2006 & division=="Chevrolet"

expandcl saleweeks, cluster(acode incuid regdesc) generate(created)

*** Nate's note:  Week count goes 1,2,3,... for each obs, now at the incentive-week level.
sort acode incuid regdesc
by acode incuid regdesc: gen weekcount=_n

gen mondays=nextmon[_n-1]+7*(weekcount-1) if weekcount>1
replace mondays=nextmon if weekcount==1 
gen endweek = (weekcount==saleweeks) 
gen startweek = (weekcount==1)


/*-------------------------------------------*
|  GENERATE WEEKLY INTEREST RATE INCENTIVE   |
*-------------------------------------------*/

gen rate36=term36
gen rate60=term60

/* MERGING IN MEAN BANKRATE DATA*/
rename year modelyear
gen month=month(mondays)
gen year=year(mondays)
sort year month
merge m:1 year month using meanbankrate.dta
keep if _merge==3
drop _merge
*rename _merge bankratemerge
drop year month
*rename modelyear year

/*-----------------------------------------------------*
|  GENERATE VARIABLES FOR THE MEAN, MEDIAN, MIN ETC.   |
*-----------------------------------------------------*/

*sort mondays acode RegionName
replace otdesc=trim(otdesc)
gen public=(otdesc=="Public")
gen dealercash=(strpos(catdesc,"Dealer"))
gen US=(strpos(RegionName,"National"))
drop if division=="Infiniti"


foreach reg in "EC" "ECA" "MW" "MWA" "GC" "GCA" "RM" "RMA" "WC" "WCA" "US" {
	replace `reg'=. if `reg'==0
	gen inc`reg'=`reg'*incentive
	gen incp`reg'=`reg'*incentive*public
	gen incd`reg'=`reg'*incentive*dealercash
	gen incc`reg'=`reg'*incentive*(1-dealercash)

}

foreach div in "EC" "MW" "GC" "RM" "WC"{
	gen loconly`div'=`div'*incentive if `div'A==.
	gen regonly`div'A=`div'A*incentive if US==.

}


drop catdesc masterprogram otdesc cash term36 term60 RegionName excluded curbweightkg passvolumeL wheelbasemm clearancemm
drop turningradiusm startdate startmonth startday startyear enddate endmonth endday endyear length nextmon weekcount 

compress
save temp1, replace



foreach i in "EC" "ECA" "MW" "MWA" "GC" "GCA" "RM" "RMA" "WC" "WCA" "US" {
	foreach var in "inc" {
		qui egen mean`var'`i'=mean(`var'`i'), by(acode mondays)
	 	qui egen max`var'`i'=max(`var'`i'), by(acode mondays)
		*egen min`var'`i'=min(`var'`i'), by(acode mondays)
		qui egen med`var'`i'=median(`var'`i'), by(acode mondays)
		compress
	}
	egen oneending`i' = max(endweek*`i'), by(acode mondays)

	*** Nate's notes: coding another candidate IV
	gen temper`i' = endweek*`i'* (inc`i'==maxinc`i')
	egen maxending`i' = max(temper`i'), by(acode mondays)
	drop temper`i'
}
save temp1_1, replace

foreach i in "EC" "ECA" "MW" "MWA" "GC" "GCA" "RM" "RMA" "WC" "WCA" "US" {
	egen onestarting`i' = max(startweek*`i'), by(acode mondays)
}

foreach i in "EC" "ECA" "MW" "MWA" "GC" "GCA" "RM" "RMA" "WC" "WCA" "US" {
	foreach var in "incp" "incd" "incc" {
		qui egen mean`var'`i'=mean(`var'`i'), by(acode mondays)
	}
}
compress

save temp1_1, replace

foreach i in "EC" "MW" "GC" "RM" "WC" {
	foreach var in "loconly" "regonly" "r36loconly" "r36regonly" "r60loconly" "r60regonly" {
		qui egen mean`var'`i'=mean(`var'`i'), by(acode mondays)
		qui egen max`var'`i'=max(`var'`i'), by(acode mondays)
		*egen min`var'`i'=min(`var'`i'), by(acode mondays)
		qui egen med`var'`i'=median(`var'`i'), by(acode mondays)
		compress
	}
}

save temp1_1, replace

drop incuid stataenddate statastartdate salelength saleweeks endweek startweek
drop inc*  regonly* loconly*
drop variationdesc startdow enddow created cash2 Exclude startdateuid enddateuid 
drop EC-WCA US public dealercash 
duplicates drop
*gen ones=1
*egen test=sum(ones), by(acode mondays)
*sum test
*save temp1_2

reshape long meaninc maxinc medinc meanr36 maxr36 medr36 meanr60 maxr60 medr60 meanincp meanincd meanincc meanincloconly maxincloconly medincloconly meanincregonly maxincregonly medincregonly meanr36loconly maxr36loconly medr36loconly meanr36regonly maxr36regonly medr36regonly meanr60loconly maxr60loconly medr60loconly meanr60regonly maxr60regonly medr60regonly oneending maxending onestarting, i(acode mondays) j(region) string 
*sort mondays acode region


gen national=(region=="US")
gen regional=0
replace regional=1 if region=="ECA" | region=="GCA" | region=="MWA" | region=="RMA" | region=="WCA"
gen local=0
replace local=1 if region=="EC" | region=="GC" | region=="MW" | region=="RM" | region=="WC"

rename mondays date

compress

sort date acode region
save incentives`y', replace

}

use incentives2003
append using incentives2004
append using incentives2005
append using incentives2006
sort date acode region

*drop if manufacturer=="Honda"
*drop if manufacturer == ""

replace meaninc = 0 if meaninc==.
replace maxinc = 0 if maxinc==.
replace medinc = 0 if medinc==.
replace oneending = 0 if oneending == .
replace meanincp = 0 if meanincp == .
replace meanincd = 0 if meanincd == .
replace meanincc = 0 if meanincc == .
replace meanincloconly = 0 if meanincloconly == .
replace maxincloconly = 0 if maxincloconly == .
replace medincloconly = 0 if medincloconly == .
replace meanincregonly = 0 if meanincregonly == .
replace maxincregonly = 0 if maxincregonly == .
replace medincregonly = 0 if medincregonly == .

rename meanincloconly meanloconly
rename maxincloconly maxloconly
rename medincloconly medloconly
rename meanincregonly meanregonly
rename maxincregonly maxregonly
rename medincregonly medregonly

save incentives_terms_revised_limited, replace

*run startstop_revised next



*clear temp1_1 temp1 temp0


