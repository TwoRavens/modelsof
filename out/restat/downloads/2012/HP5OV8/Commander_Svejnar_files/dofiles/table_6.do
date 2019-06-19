clear
cap log close

log using "$logs/table6.txt", text replace


run "$dofiles/tests.ado"
run "$dofiles/robust_hausman.ado"

insheet using $data/data_db.txt

keep if year == 2003 | year == 2006

rename country country_name
replace year = 2002 if year == 2003
replace year = 2005 if year == 2006

label variable	dbrank	"	Ease of Doing Business (Rank)	"
label variable	sbrank	"	Starting a Business (Rank)	"
label variable	sbproc	"	Starting a Business (Number of Procedures)	"
label variable	sbtime	"	Starting a Business (Time)	"
label variable	sbcost	"	Starting a Business (Cost)	"
label variable	sbcap	"	Starting a Business (min. capital)	"
label variable	licrank	"	Licenses (Rank)	"
label variable	licproc	"	Licenses (Number of Procedures)	"
label variable	lictime	"	Licences (Time)	"
label variable	liccost	"	Lisences (Cost)	"
label variable	emprank	"	Employing Workers (Rank)	"
label variable	emphirescore	"	Employing Workers (Hiring)	"
label variable	emphrs	"	Employing Workers (Rigidity of Hours)	"
label variable	empfire	"	Employing Workers (Firing)	"
label variable	emprig	"	Employing Workers (Rigidity of Employment)	"
label variable	emphirecost	"	Employing Workers (Hiring Cost)	"
label variable	empfirecost	"	Employing Workers (Firing Cost)	"
label variable	proprank	"	Registering Property (Rank)	"
label variable	propproc	"	Registering Property (Number of Procedures)	"
label variable	proptime	"	Registering Property (Time)	"
label variable	propcost	"	Registering Property (Cost)	"
label variable	credrank	"	Credit (Rank)	"
label variable	credrights	"	Credit (Legal Rights)	"
label variable	credinfo	"	Credit (Information)	"
label variable	credreg	"	Credit (Public Registry)	"
label variable	credpreg	"	Credit (Private Registry)	"
label variable	invrank	"	Protecting Investors (Rank)	"
label variable	invdisc	"	Protecting Investors (Disclosure)	"
label variable	invliab	"	Protecting Investors (Director Liability)	"
label variable	invshr	"	Protecting Investors (Shareholder Suits)	"
label variable	invprot	"	Protecting Investors (Index)	"
label variable	taxrank	"	Tax (Rank)	"
label variable	taxpym	"	Tax (Number of Payments)	"
label variable	taxtime	"	Tax (Time)	"
label variable	taxrate	"	Tax (Rate)	"
label variable	traderank	"	Trade (Rank)	"
label variable	expdoc	"	Trade (Documents Export)	"
label variable	exptime	"	Trade (Time Export)	"
label variable	expcost	"	Trade (Cost Export)	"
label variable	impdoc	"	Trade (Documents Import)	"
label variable	imptime	"	Trade (Time Import)	"
label variable	impcost	"	Trade (Cost Import)	"
label variable	cntrctrank	"	Contracts (Rank)	"
label variable	cntrctproc	"	Contracts (Procedures)	"
label variable	cntrcttime	"	Contracts (Time)	"
label variable	cntrctcost	"	Contracts (Cost)	"
label variable	closerank	"	Closing (Cost)	"
label variable	closetime	"	Closing (Time)	"
label variable	closecost	"	Closing (Cost)	"
label variable	closerec	"	Closing (Recovery)	"

sort country_name year
save temp1, replace

use $data/final_data, clear
drop if owner_new4 == 1
sort country_name year
merge country_name year using temp1


/* For models */

global PARS     = "logE logA " 
global PARS2    = "logE logA owner_new1 owner_new2 owner_new5" 
global ENDOGEN  = "logE logA owner_new1 owner_new2 owner_new5 logExp" 
global EXOGEN   = "sbproc sbtime sbcost emprig empfire empfirecost cntrctproc cntrcttime cntrctcost closetime closecost closerec" 
global DUMMIES  = "sect1-sect2  sect4-sect7 i.year i.country" 

global INSTRUMENTS    = "labunsec labunsec2 age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR citytown perfqH perfqI" 
global INSTRB   = "labunsec_1 labunsec_2 labunsec_3 labunsec_age_1 labunsec_age_2 labunsec_age_3 age Q2_3perm_full_empR citytown perfqH perfqI" 


foreach var of global EXOGEN {
	destring `var', replace force
	}

gen closerec1 = closerec
replace closerec = 100 - closerec1




egen clstr = group(country prod2DIG sizeb year)

/* Create more flexible instruments */
local i = 1 
while `i' <= 3 { 
        foreach var of global INSTRUMENTS { 
                gen `var'_`i' = 0 
                replace `var'_`i' = `var' if regmac == `i' 
        } 
        local i = `i' + 1 
} 



/* regressions with constraints */

tempfile m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14


xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using $tables/table6, replace bdec(3) se aster(se) bracket label

tests, column(model1) file(`m1') df(1) insts($INSTRB) exog(numcomp3 $EXOGEN $DUMMIES) cluster(clstr)


local i = 2 
foreach var of global EXOGEN{ 

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 `var'  $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 `var' using $tables/table6, append bdec(3) se aster(se) bracket label
tests, column(model`i') file(`m`i'') df(1) insts($INSTRB) exog(numcomp3 `var' $DUMMIES) cluster(clstr)

local i = `i'+1
} 

xi: ivreg2 logS ($ENDOGEN = $INSTRB) numcomp3 $EXOGEN $DUMMIES, ffirst robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using $tables/table6, append bdec(3) se aster(se) bracket label

tests, column(model14) file(`m14') df(1) insts($INSTRB) exog(numcomp3 $EXOGEN $DUMMIES) cluster(clstr)


preserve

/* F and J Tests */

use `m1', clear

forvalues i =2(1)14{
 merge variable using `m`i''
 drop _m
 sort variable
}

outsheet using $tables/table6_tests.csv, replace comma

restore


xi: regress logS $ENDOGEN numcomp3 $EXOGEN $DUMMIES,  robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using $tables/table6_ols, replace bdec(3) se aster(se) bracket label



local i = 2 
foreach var of global EXOGEN{ 

xi: regress logS $ENDOGEN numcomp3 `var'  $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 `var' using $tables/table6_ols, append bdec(3) se aster(se) bracket label

local i = `i'+1
} 

xi: regress logS $ENDOGEN numcomp3 $EXOGEN $DUMMIES, robust cluster(clstr) 
outreg2 $ENDOGEN numcomp3 $EXOGEN using $tables/table6_ols, append bdec(3) se aster(se) bracket label



log close
