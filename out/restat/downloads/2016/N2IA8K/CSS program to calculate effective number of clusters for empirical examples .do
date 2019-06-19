global dir  "enter path name here/CSS_REStat_2016"


clear

*************
*** KRUEGER EXAMPLE - DATA FROM MHE WEBSITE http://economics.mit.edu/faculty/angrist/data1/mhe/krueger


/* create Krueger scaled scores */

*this part sorts and creates a rank (or percentile) variable for each student by their "total reading scaled score" (and math)
set more off
/* reading score */
use "$dir/webstar.dta", clear
keep if cltypek > 1			/* regular classes */
keep if treadssk ~= .

sort treadssk
gen pread0 = 100*_n/_N
egen pread = mean(pread0), by(treadssk)	/* percentile score in reg. classes */

keep treadssk pread
sort tread
keep if tread ~= tread[_n-1]
save tempr, replace

/* math score */
use "$dir/webstar.dta", clear
keep if cltypek > 1			/* regular classes */
keep if tmathssk ~= .

sort tmathssk
gen pmath0 = 100*_n/_N
egen pmath = mean(pmath0), by(tmathssk)

keep tmathssk pmath
sort tmath
keep if tmath ~= tmath[_n-1]
save tempm, replace

/* merge percentile scores back on */
use "$dir/webstar.dta", clear

*keep if attend project star class in kindergarden
keep if stark == 1

sort treadssk
merge treadssk using tempr
ipolate pread treadssk, gen(pr) epolate
drop _merge

sort tmathssk
merge tmathssk using tempm
ipolate pmath tmathssk, gen(pm) epolate
replace pm = 0 if pm < 0
drop _merge

*create score average of reading and math
egen pscore = rowmean(pr pm)

/* create classroom ids using other variables - (from Angrist program)*/
egen classid1 = group(schidkn cltypek)
egen cs1 = count(classid1), by(classid1)

egen classid2 = group(classid1 totexpk hdegk cladk) if cltypek==1 & cs >= 20
egen classid3 = group(classid1 totexpk hdegk cladk) if cltypek>1 & cs >= 30

gen temp = classid1*100
egen classid = rowtotal(temp classid2 classid3)
egen cs = count(classid), by(classid)

* create control variables for regression - school id, race, gender, free lunch status, teacher race, teacher exp, teacher educ

*student characteristics
gen female = ssex == 2
gen white=inlist(srace,1,3) if srace ~= .
gen freelunch=sesk==1 if sesk~=.

*teacher characeteristics
gen twhite= tracek== 1  if tracek ~= .
gen tmaster= hdegk>=3 & hdegk<=4 if hdegk~=.
gen texp=totexpk

keep if cs <= 27 & pscore ~= .

keep pscore cs schidkn classid female white freelunch twhite texp tmaster


*xi i.schidkn
reg pscore cs female white freelunch twhite texp tmaster i.schidkn, vce(cluster classid) 


effclusters_CSS, key_rhs(cs) clustvar(classid)




effclusters_IK_CSS, key_rhs(cs) clustvar(classid) 



egen group_class=group(classid)
gen n=1
collapse (sum) n, by(group_class)

sum n, detail
*coef of variation
di 100 * r(sd) / r(mean)



**********************************
** HERSCH (1998) EXAMPLE - DATA PROVIDED BY COLIN CAMERON, 6/13/13
**********************************

clear

infile double wage double lnw double blsrate double jhrate ///
double occrate double age double agesq double potexp ///
double potexpsq double educ byte union byte nonwhite ///
double uslhrs2 byte northe byte midw byte west byte south ///
byte rural byte smsa2 byte smsa3 byte smsa4 byte smsa5 ///
byte smsabig byte prof byte mgr byte tech byte sales ///
byte clerical byte services byte crafts byte oper ///
byte transop byte labor byte minconst byte mfg byte tcpu /// 
byte whtrade byte retrade byte fire byte service ///
double children byte married byte single double othfamy ///
byte wagesam byte mjocc byte mjind double hrspay byte wc ///
double ind92 double occ92 using "$dir/CGM_JBES_2011_hersch.DAT"


global regressorlist blsrate occrate potexp potexpsq educ union nonwhite ///
	northe midw west smsa2 smsa3 smsa4 smsa5 smsabig prof mgr tech ///
	sales clerical crafts oper transop labor ///
	minconst mfg tcpu whtrade retrade fire

egen indbyocc92 = group(ind92 occ92)

* Default standard errors 
*regress lnw $regressorlist 

* Heteroskedastic robust standard errors 
*regress lnw $regressorlist , vce(robust)  


* One-way cluster on industry 
regress lnw $regressorlist , vce(cluster ind92) noconstant

effclusters_CSS ,  key_rhs(blsrate) clustvar(ind92) 



collapse (count) obs=wage, by(ind92)

sum obs, detail
*coef of variation
di 100 * r(sd) / r(mean)


************************
** CALC COEF OF VARIATION FOR DESIGNS
************************

clear
set obs 100
gen ng=25
sum ng, detail
di 100 * r(sd) / r(mean)

replace ng=124 if _n==1
replace ng=24 if _n>1
sum ng, detail
di 100 * r(sd) / r(mean)

replace ng=223 if _n==1
replace ng=23 if _n>1
sum ng, detail
di 100 * r(sd) / r(mean)

replace ng=322 if _n==1
replace ng=22 if _n>1
sum ng, detail
di 100 * r(sd) / r(mean)
	
replace ng=421 if _n==1
replace ng=21 if _n>1
sum ng, detail
di 100 * r(sd) / r(mean)

replace ng=520 if _n==1
replace ng=20 if _n>1
sum ng, detail
di 100 * r(sd) / r(mean)

log close





