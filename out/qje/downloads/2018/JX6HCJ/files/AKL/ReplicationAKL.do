
***************************************************************

*Reworked code to minimize loading and reloading of files

*Preparatory files
use ABCteacher.dta, clear
sort codev class year 
save tempteacher, replace

use ABCteacher.dta, clear
keep if (cohort==2009&year==2009) | (cohort==2010&year==2010)
keep codev class levelno
rename levelno llevelno
sort codev class
save tempteacher2.dta, replace

*Treatment vector - actually 114 villages, not 113, as ABChousehold reveals additional treatment village used in Table 9 regressions
use ABCtestscore.dta, clear
collapse (mean) abc, by(avcode codevillage) fast
save a, replace
use ABChousehold, clear
destring codevillage, replace
collapse (mean) abc, by(avcode codevillage) fast
rename abc abcd
merge avcode codevillage using a
tab _m
regress abc abcd
replace abc = abcd if abc == .
keep abc avcode codevillage
sort avcode codevillage
mkmat avcode abc codevillage, matrix(Y)
global N = 114
keep avcode codevillage
sort codevillage
gen N = _n
sort avcode codevillage
save Sample1, replace

use ABCtestscore.dta, clear
sort codev class year
merge codev class year using tempteacher.dta
drop if _m==2
drop _m
sort codev class
merge codev class using tempteacher2.dta
tab _m
drop if _m == 2
drop _m

capture drop region regionpost regionabc abcregionpost
gen region=dosso==1
gen regionpost=region*post
gen regionabc=region*abc
gen abcregionpost=regionabc*post

bys codev class round year : gen first=_n
bys codev class round year: egen htotaldays=mean(totaldays)
bys codev class round year: egen htotaldays12=mean(totaldays12)
bys codev class round year: egen htotaldays34=mean(totaldays34)
gen teacherdaysy1= htotaldays if first==1 & time==2
gen teacherdaysy1m12= htotaldays12 if first==1 & time==2
gen teacherdaysy1m34= htotaldays34 if first==1 & time==2
gen teacherdaysy2= htotaldays if first==1 & time==4
gen percentattendy1= percentattend if  time==2
gen percentattendy1m12= percentattend12 if  time==2
gen percentattendy1m34= percentattend34 if  time==2
gen percentattendy2= percentattend if time==4

sum llevelno if time == 1 | time == 2
gen highlevel=llevelno>r(mean) if llevelno!=. & (time == 1 | time == 2)
gen highlevelabc=abc*highlevel 
replace percentattend34=100* percentattend34
replace percentattend12=100*percentattend12

**********************************

*Reproducing regressions in paper

*Table 1 and 2 are baseline characteristics comparison

*Table 3 - All okay
foreach outcome in writezscore mathzscore {
	reg `outcome' abcpost abc post if (round==1|round==2|round==4), robust cluster(codev)
	reg `outcome' abcpost abc post cohort2009 female age dosso if (round==1|round==2|round==4), robust cluster(codev)
	areg `outcome' abcpost abc post cohort2009 female age if (round==1|round==2|round==4), abs(avcode) robust cluster(codev)
	areg `outcome' abcpost post female age if (round==1|round==2|round==4), abs(codev) robust cluster(codev)
	}

*Table 4 - coefficients in wrong columns
foreach outcome in writezscore mathzscore {
	reg `outcome' abcpost abcregionpost abc regionabc region post regionpost cohort2009 female age if (round==1|round==2|round==4), robust cluster(codev)  
	areg `outcome' abcpost abcfemalepost abc femaleabc female post femalepost cohort2009 age if (round==1|round==2|round==4), abs(avcode) robust cluster(codev) 
	areg `outcome' abcpost abcyoungpost abc youngabc young post youngpost cohort2009 female age if (round==1|round==2|round==4), abs(avcode) robust cluster(codev)
	}

*Table 5 - All okay
foreach outcome in writezsc mathzsc {
	areg `outcome' abcpost abcpost6m abc post post6m cohort2009 female age, abs(avcode) robust cluster(codev)
	}

*Table 6 - All okay
foreach outcome in teacherdaysy1 teacherdaysy1m34 percentattendy1 percentattendy1m34 percentattendy2 {
	areg `outcome' abc, abs(avcode) robust cluster(codev)
	}

*Table 7 - All okay
foreach outcome in percentattend34 {
	*Drop time variable (in their regression) because it does not vary and is dropped by Stata
	areg `outcome' abc highlevela highlevel cohort2009 female if time==2, abs(avc) robust cluster(codev)
	}

svmat Y
save DatAKL1, replace


******************************************

use ABChotline.dta, clear
su meanteacher, det
gen highlevel=meanteacher>r(mean) if meanteacher!=.
gen lowlevel=meanteacher<=r(mean) if meanteacher!=.

*Table 8 - All okay

areg hotline abc cohort2009, abs(avcode) robust
areg hotline abc cohort2009 if highlevel==1, abs(avcode) robust
areg hotline abc cohort2009 if lowlevel==1, abs(avcode) robust

svmat Y
save DatAKL2, replace

sum abc if codev == 7120
sum Y2 if Y3 == 7120
*coding error in abchotline file - inconsistent with abchousehold, abcteacher, abctestscore.
*******************************

use ABChousehold.dta, clear
keep if year==2010|year==2011
gen anybip=.
replace anybip=1 if bip==1|receivebip==1
replace anybip=0 if anybip!=1 & usecellphone==1

*Table 9 - All okay

foreach outcome in cellphoneowner usecellphone makecall receivecall writesms receivesms anybip madetransferSMS receivedtransferSMS communicate_migrant celltalkrelativeniger celltalktradeniger whycell_ceremony whycell_help whycell_priceinfo {
	areg `outcome' abc, absorb(avcode) robust cluster(codev)
	}

svmat Y
gen double t = real(codevillage)
drop codevillage
rename t codevillage
save DatAKL3, replace

capture erase a.dta
capture erase tempteacher.dta
capture erase tempteacher2.dta

