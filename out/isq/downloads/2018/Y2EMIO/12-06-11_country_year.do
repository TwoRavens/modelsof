**Setting up Country Year Data
clear 
cd "$filetree"
*cd "/Users/Allan/Dropbox/!!Papers/Liberal Peace/12-02-21_ISQ_commentary/Mousseau_Replication_Files/"
*"MIDB_310.dta" from CoW website: http://www.correlatesofwar.org/COW2%20Data/MIDs/MID310.html

use "MIDB_310.dta"
keep dispnum stabb ccode sidea fatality hiact hostlev orig styear endyear
sort ccode
gen lengthyears=endyear-styear

gen dispnumccode=dispnum*1000+ccode

sort dispnumccode
order dispnumccode lengthyears

ssc install expandby 

local i=2
while `i' <=50 {
expandby `i' if lengthyears==`i'-1, by(dispnumccode)
local i=`i'+1
} 

sort dispnumccode

by dispnumccode: gen year=styear+_n-1
drop styear endyear

gen fmid=1 if fatality>0 & fatality<7
replace fmid=0 if fatality==0

gen war=1 if fatality==6
replace war=0 if fatality<6

***Caution: Imputation Assumption****
**Simple imputation: imputing missing data on fatality to 0. 
replace fmid=0 if fatality==-9
***********

**Generate count of MIDs, fMIDs and Wars per country year
sort ccode year
by ccode year: egen midC=count(dispnum)
by ccode year: egen fmidC=total(fmid)
by ccode year: egen warC=total(war)

drop fmid war
rename midC mid
rename fmidC fmid
rename warC war

by ccode year: gen last=1 if _n==_N
keep if last==1
drop last dispnumccode lengthyears dispnum hiact hostlev orig fatality sidea

sort ccode year
save "country_year_MID.dta", replace

************


***
**Code from "CINE Data Replication Do File.do"

clear 
cd "$filetree"
*cd "/Users/Allan/Dropbox/!!Papers/Liberal Peace/12-02-21_ISQ_commentary/Mousseau_Replication_Files/"
*"raw for replication.dta" provided by Michael Mousseau on Jan 4th, 2012, as well as all files in folder "CINE_Data"
use "CINE_Data/raw for replication.dta"

**Start MM Code**
replace 	rgdpl=.	 	 if 	rgdpl	 ==	-99
replace 	openk=.		 if 	openk	 ==	-99
replace 	kc=.	 	 if 	kc	 	 ==	-99
replace 	kg=.	 	 if 	kg		 ==	-99
replace 	ki=.		 if 	ki		 ==	-99
replace 	energy=.	 if 	energy	 ==	-9
replace 	tpop=.		 if 	tpop	 ==	-9


*apparent errors in the data; nations in major transitions:
replace ki=. if ccode==315 & year==1992 | ccode==365 & year==1990 | ccode==365 & year==1991 |  ccode==366 & year==1991 | ccode==690 & year==1991
replace kc=. if ccode==690 & year==1991
replace kg=. if ccode==690 & year==1991
replace openk=. if ccode==690 & year==1991

************
g CIE = ln(lifedeer+1)
drop lifedeer


rename kc kcpct
rename ki kipct
rename kg kgpct
rename openk ktpct
g kc=(kcpct/100)*rgdpl
g ki=(kipct/100)*rgdpl
g kg=(kgpct/100)*rgdpl
g kt=(ktpct/100)*rgdpl
g kitokt=ki/kt
g kctokt=kc/kt

g lnrgdpl=ln(rgdpl)
drop rgdpl
g lnfood=ln(food)
g enrpc=energy/tpop
g lnenrpc=ln(enrpc+1)
drop energy

g imputed=0
replace imputed=1 if CIE==.

recode region1 (1=1 "West") 		(2/5=0 "Other") 				(.=.), gen(rwest)
recode region1 (2=1 "Middle East") (1=0 "Other") 	(3/5=0 "Other") (.=.), gen(rmideast)
recode region1 (3=1 "Africa") 		(1/2=0 "Other") (4/5=0 "Other") (.=.), gen(rafrica)
recode region1 (4=1 "Asia") 		(1/3=0 "Other") (5=0 "Other")   (.=.), gen(rasia)
recode region1 (5=1 "America") 	(1/4=0 "Other") 				(.=.), gen(rameri)
drop region1

g cmmst=0
replace cmmst =1 if year < 1992 & (ccode == 339  | ccode == 345  | ccode == 355  | ccode == 710  | ccode == 40  | ccode ==315  | ccode == 265 | ccode == 310  | ccode == 812  | ccode == 712  | ccode == 731  | ccode == 290 | ccode == 360 | ccode == 365 | ccode == 816)
replace cmmst=1 if ccode==731

g pcom=0		
replace pcom=1 if year >1991 & (ccode== 40 |ccode== 290 |ccode== 310 |ccode== 316 |ccode== 317 |ccode== 331 |ccode== 338 |ccode== 339 |ccode== 343 |ccode== 344 |ccode== 345 |ccode== 346 |ccode== 349 |ccode== 355 |ccode== 359 |ccode== 360 |ccode== 365 |ccode== 366 |ccode== 367 |ccode== 368 |ccode== 369 |ccode== 370 |ccode== 371 |ccode== 372 |ccode== 373 |ccode== 700 |ccode== 701 |ccode== 702 |ccode== 703 |ccode== 704 |ccode== 705 |ccode== 710 |ccode== 712 |ccode== 812 |ccode== 816) 

g micro=0
replace micro=ln(0-tpop+1001) if tpop<1000
replace micro=. if tpop==.

g y7980=0
g y8185=0
g y86=0
g y8791=0
g y92=0
g y9398=0
g y9900=0
replace y7980=1 	if year >=1979 & year<=1980
replace y8185=1 	if year >=1981 & year<=1985
replace y86=1 		if year >=1986 & year<=1986
replace y8791=1 	if year >=1987 & year<=1991
replace y92=1 		if year >=1992 & year<=1992
replace y9398=1 	if year >=1993 & year<=1998
replace y9900=1 	if year >=1999 & year<=2000

g       num6069=1959
replace num6069=year 	if year>=1960 & year <1970
g       num7174=1970
replace num7174=year 	if year>=1971 & year==1974
g       num7583=1974
replace num7583=year 	if year>=1975 & year<=1983
g       num8488=0
replace num8488=1 		if year>=1984 & year<=1988
g       num89=0
replace num89=1 		if year==1989
g       num9091=0 	
replace num9091=1 		if year==1990
replace num9091=2 		if year==1991
g       num92=0 	
replace num92=1 		if year==1992
g       num9394=0
replace num9394=1 		if year==1993
replace num9394=2 		if year==1994
g       num9598=0
replace num9598=1 		if year>=1995 & year<=	1998
g       num99=0
replace num99=1 		if year==1999
g       num00=0
replace num00=1 		if year==2000
**END MM Code**
rename CIE MMCIE

keep ccode year MMCIE enrpc lnenrpc ki kc kitokt kctokt oil pcom cmmst tpop micro rmideast year y7980 y8185 y86 y8791 y92 y9398 y9900 num6069 num7174 num7583 num8488 num89 num9091 num9394 num9598 num99 num00



**MM's imputation variables: CIE enrpc lnenrpc ki kc kitokt kctokt oil pcom cmmst tpop micro rmideast year y7980 y8185 y86 y8791 y92 y9398 y9900 num6069 num7174 num7583 num8488 num89 num9091 num9394 num9598 num99 num00
**MM's impute command: impute CIE enrpc lnenrpc ki kc kitokt kctokt oil pcom cmmst tpop micro rmideast year y7980 y8185 y86 y8791 y92 y9398 y9900 num6069 num7174 num7583 num8488 num89 num9091 num9394 num9598 num99 num00, g (iCIE)

sort ccode year
save "MM_CIE_impute_raw.dta", replace
*****



*Gleditsch Trade and GDP data country-year
clear
*Downloaded from here: http://privatewww.essex.ac.uk/~ksg/exptradegdp.html
insheet using "Other_files/exptradegdpv4.1 2/expdata.asc", delimiter(" ")
sort numa year
by numa year: gen last=1 if _n==_N

sort numb year
by numb year: gen last2=1 if _n==_N
tab last last2, m

gen ccode = numa if last==1
replace ccode= numb if last2==1

order ccode numa numb last*
keep if last==1 | last2==1
drop last*
sort ccode year
by ccode year: gen duplicate=1 if _n>1

gen gdppc=rgdpca if ccode==numa
replace gdppc=rgdpcb if ccode==numb

gen pop=popa if ccode==numa
replace pop=popb if ccode==numb

gen tottr=tottra if ccode==numa
replace tottr=tottrb if ccode==numb


order ccode year gdppc numa numb rgdp*
drop if duplicate~=.

keep ccode year gdppc pop tottr
sort ccode year
save "gleditsch_country_year.dta", replace


*acra/b		Three letter acronym for state A/B	
*numa/b		Numeric id code for state A/B
*year		Year
*expab		Export A to B
*eabo		Export A to B origin code
*impab		Import A from B
*iabo		Import A from B origin code
*expba		Export B to A 		
*ebao		Export B to A origin code
*impba		Import B from A 
*ibao		Import B from A origin code
*popa		Population of A
*rgdpca/b	Real GDP per capita of A/B
*cgdpca/b	Current GDP per capita of A/B
*goa/b		Origin of GDP per capita estimate A/B
*tottra/b	Total trade for country A/B








******************
clear

cd "$filetree"
*cd "/Users/Allan/Dropbox/!!Papers/Liberal Peace/12-02-21_ISQ_commentary/Mousseau_Replication_Files/"
do "Eugene/country_year.out.do"

sort ccode year

**Importing MID data
merge 1:1 ccode year using "country_year_MID.dta"
drop _merge
replace mid=0 if mid==.
replace fmid=0 if fmid==.
replace war=0 if war==.


sort ccode year
merge 1:1 ccode year using "gleditsch_country_year.dta"
drop if _merge==2 
*these seem to all be small countries
drop _merge

rename ccode ccode1
rename year year1
sort ccode1 year1
merge 1:1 ccode year using "beck_webb1.dta"
*browse if _merge==2
drop if _merge==2
drop _merge

rename ccode1 ccode
rename year1 year

sort ccode year
merge 1:1 ccode year using "MM_CIE_impute_raw.dta"
*browse if _merge==2
drop if _merge==2
drop _merge


*********M. Impute data**********

**If you don't have it, install mvpatterns by typing: findit mvpatterns
mvpatterns pop tpop
*cow population data (tpop) much more comprehensive

order ccode abbrev year mid fmid war gdppc cap milper milex irst energy upop tpop numstate numGPs majpow region1 polity2 xrreg xrcomp xropen xconst tottr lifepen1 acli1 income1 lifedens1 lifedeer1 lifeexp1 MMCIE enrpc lnenrpc ki kc kitokt kctokt oil pcom cmmst tpop micro rmideast year y7980 y8185 y86 y8791 y92 y9398 y9900 num6069 num7174 num7583 num8488 num89 num9091 num9394 num9598 num99 num00

sort ccode year
keep  ccode abbrev year mid fmid war gdppc cap milper milex irst energy upop tpop numstate numGPs majpow region1 polity2 tottr lifepen1 acli1 lifedens1 lifedeer1 lifeexp1 MMCIE enrpc lnenrpc ki kc kitokt kctokt oil pcom cmmst tpop micro rmideast year y7980 y8185 y86 y8791 y92 y9398 y9900 num6069 num7174 num7583 num8488 num89 num9091 num9394 num9598 num99 num00

***Warning: dropping observations missing values on some variables
drop if mid==. | cap==. | polity2==. | energy==. | upop==. | tpop==. | ccode==. 
*about 2400 observations dropped

*Evaluating distribution of variables, consider transformations to make them more normal
*See p11 of Amelia II documentation

*hist gdppc
gen lngdppc=log(gdppc)
*scatter gdppc lngdppc
drop gdppc
*hist cap
gen lncap=log(cap)
*scatter lncap cap
*hist lncap
*hist milper
gen lnmilper=log(milper)
*hist milex
gen lnmilex=log(milex)
*amazingly normally distributed
*hist irst
gen lnirst=log(irst)
*hist energy
gen lnenergy=log(energy)
*hist upop
gen lnupop=log(upop)
*hist tpop
gen lntpop=log(tpop)
*again, amazing
*hist numstate
*hist numGPs
*hist majpow
*hist polity2 
label variable tottr "Total Trade Gleditsch"
*hist tottr
gen lntottr=log(tottr)

*hist lifepen1
gen lnlifepen=log(lifepen1)
*scatter lifepen1 lnlifepen
*hist lnlifepen

*hist acli1
gen lnacli=log(acli1)
*hist lifedens1
gen lnlifedens=log(lifedens1)
*hist lifedeer1
*+1 to look like MM's measure
gen lnlifedeer=log(lifedeer1+1)
*hist lifeexp1

order ccode abbrev year mid fmid war numstate numGPs majpow region1 polity2 ln*
label variable polity2 "Polity IV Dem-Aut Score"
label variable mid "Onset or Ongoing MID"
label variable fmid "Onset or Ongoing Fatal MID"
label variable war "Onset or Ongoing War"
label variable lngdppc "Ln Real GDP per capita"
label variable lnlifedeer "Ln Life Insurance Density"
label variable lnlifedens "Ln Life Insurance Density PPP"
label variable lncap "Ln National Capabilities Index"
label variable lnmilper "Ln COW military personnel"
label variable lnmilex "Ln COW military expenditure"
label variable lnirst "Ln COW iron/steel production"
label variable lnenergy "Ln COW energy production"
label variable lnupop "Ln COW urban population"
label variable lntpop "Ln COW total population"
label variable lntottr "Ln Total Trade Gleditsch"
label variable lnlifepen "Ln Life Insurance Penetration"
label variable lnacli "Ln Life Insurance in Force to GDP"

*scatter lnlifedeer MMCIE

keep ccode abbrev year mid fmid war numstate numGPs majpow region1 polity2 ln* MMCIE enrpc lnenrpc ki kc kitokt kctokt oil pcom cmmst tpop micro rmideast year y7980 y8185 y86 y8791 y92 y9398 y9900 num6069 num7174 num7583 num8488 num89 num9091 num9394 num9598 num99 num00

drop lnlifedens
drop if year<1950
drop if year>2001
rename region1 region

**Updating MM's temporal variables
drop y7980 y8185 y86 y8791 y92 y9398 y9900 num6069 num7174 num7583 num8488 num89 num9091 num9394 num9598 num99 num00

g y7980=0
g y8185=0
g y86=0
g y8791=0
g y92=0
g y9398=0
g y9900=0
replace y7980=1 	if year >=1979 & year<=1980
replace y8185=1 	if year >=1981 & year<=1985
replace y86=1 		if year >=1986 & year<=1986
replace y8791=1 	if year >=1987 & year<=1991
replace y92=1 		if year >=1992 & year<=1992
replace y9398=1 	if year >=1993 & year<=1998
replace y9900=1 	if year >=1999 & year<=2000

g       num6069=1959
replace num6069=year 	if year>=1960 & year <1970
g       num7174=1970
replace num7174=year 	if year>=1971 & year==1974
g       num7583=1974
replace num7583=year 	if year>=1975 & year<=1983
g       num8488=0
replace num8488=1 		if year>=1984 & year<=1988
g       num89=0
replace num89=1 		if year==1989
g       num9091=0 	
replace num9091=1 		if year==1990
replace num9091=2 		if year==1991
g       num92=0 	
replace num92=1 		if year==1992
g       num9394=0
replace num9394=1 		if year==1993
replace num9394=2 		if year==1994
g       num9598=0
replace num9598=1 		if year>=1995 & year<=	1998
g       num99=0
replace num99=1 		if year==1999
g       num00=0
replace num00=1 		if year==2000

gen lngdppcsq=lngdppc^2 
gen lngdppccube=lngdppc^3

gen polity2sq=polity2^2
gen polity2cube=polity2^3

saveold "country_year_mimpute.dta", replace


**See R code for multiple imputation***
*AD: I opted to use Amelia II because it had a convenient technique for having within country temporal trends.
*R code creates files: "outdatatotal1.dta" and other files with increasing numbers for each imputation



