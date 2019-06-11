
*** Summary Statistics of Key Variables from 2006 to 2015 ***
use "Data.dta", clear
keep if Tec==1
tabstat Patent LnPat Invention LnInv Size Age SaleRat ROA Fix Leverage Liquidity Growth State IndRat Dual Institution, by(Tec) s(n mean sd min med max) f(%10.4f) column(s)

use "Data.dta", clear
keep if Tec==0
tabstat Patent LnPat Invention LnInv Size Age SaleRat ROA Fix Leverage Liquidity Growth State IndRat Dual Institution, by(Tec) s(n mean sd min med max) f(%10.4f) column(s)

*** Figure 1: Patent applications adjusted by industry and time before and after certification ***
use "Data.dta", clear
keep if Tec==1
gen n=Year-firsttec
bysort Year Industry: egen indpat=mean(LnPat) 
gen y=LnPat-indpat
bysort n: egen pat=mean(y)
keep if n>=-3
keep if n<=5
label variable pat "Industry-Year Adjusted Patent"
graph twoway connected pat n, xlabel(-3(1)5) xtitle("") ytitle("") legend(on) scheme(s1mono)

*** Preliminary analysis: Tobit regression ***
use "Data.dta", clear
tobit LnPat Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit LnInv Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
tobit LnPat Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province if firsttec<=2009 | firsttec==.,ll(0) vce (ro)
eststo m3
tobit LnInv Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province if firsttec<=2009 | firsttec==.,ll(0) vce (ro)
eststo m4
esttab m1 m2 m3 m4,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 

*** Robustness test: Heckman two-step method ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=.
probit Tec ntec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province 
predict zg if e(sample),xb
gen lambda=normalden(zg)/normal(zg) 
tobit LnPat Tec lambda Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Povince,ll(0) vce (ro)
eststo m1
tobit LnInv Tec lambda Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
esttab m1 m2,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province)

*** Robustness test: Analysis based on PSM-DID method ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=.
bysort Stkcd: gen PatGrowth=LnPat/LnPat[_n-1]-1 
bysort Stkcd: gen ptec=1 if year==firsttec-1
set seed 10101
gen u=runiform() 
sort u 
psmatch2 Tec LnPats PatGrowth if ptec==1 | tec==0, mahal(year industry) 
*** Figure 2: Propensity Score Matching Effect ***
twoway (kdensity _ps if _treat==1,legend( label (1 "treat"))) (kdensity _ps if _treat==0,legend( label (2 "control"))), xtitle("pscore") title("before matching") scheme (s1mono)
twoway (kdensity _ps if (_treat==1),legend( label (1 "treat"))) (kdensity _ps if (_treat==0 & _wei!=.),legend( label (2 "control"))), xtitle("pscore") title("after matching")scheme (s1mono)
sort _id
sort Stkcd Year
keep if _weight!=.
keep Stkcd Year Tec
gen match=1
duplicates drop Stkcd, force 
save "PSM.dta"
merge m:1 Stkcd using "Data.dta"
drop _merge
replace match=0 if match==.
save "PSMDID.dta"

use "PSMDID.dta"
drop if firsttec >2009 & firsttec !=. 
keep if match==1
gen After=1 if Year>=firsttec
replace After=0 if After==.
gen did=After*Tec
set matsize 5000 
set more off
tobit LnPat did Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Stkcd i.Year,ll(0) vce (ro) 
eststo m1
tobit LnInv did Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Stkcd i.Year,ll(0) vce (ro)
eststo m2
esttab m1 m2,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Stkcd *.Year) 

*** Robustness test: Certification instances and corporate innovation ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=. 
tobit LnPat Ins Size SaleRat Sub RDRat ROA Age Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry if Tec==1,ll(0) vce (ro)
eststo m1
tobit LnInv Ins Size SaleRat Sub RDRat ROA Age Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry if Tec==1,ll(0) vce (ro)
eststo m2
esttab m1 m2,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year) 

*** Other robustness tests ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=. 
tobit LngGra Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit InvRat Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
tobit LnPat Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province if otheriqualification=0,ll(0) vce (ro)
eststo m3
tobit LnInv Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province if otheriqualification=0,ll(0) vce (ro)
eststo m4
esttab m1 m2 m3 m4,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 

*** Mechanism test: Tangible channel ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=.
gen etr=TaxYh*Tec
gen bt=Sub*Tec
tobit TaxYh Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit LnPat etr Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
tobit LnInv etr Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m3
tobit Sub Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m4
tobit LnPat bt Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m5
tobit LnInv bt Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m6
esttab m1 m2 m3 m4 m5 m6,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 
 

*** Mechanism test: Intangible Channel ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=. 
gen RD1=RDC*Tec
gen RD2=RDP*Tec
tobit RDC Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit LnPat RD1 Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
tobit LnInv RD1 Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m3
tobit RDP Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m4
tobit LnPat RD2 Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m5
tobit LnInv RD2 Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m6
esttab m1 m2 m3 m4 m5 m6,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 

*** Heterogeneity analysis ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=. 
gen xz=State*Tec
tobit LnPat Tec xz Size Age SaleRat ROA Fix Lev Liquidity Growth IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit LnInv Tec xz Size Age SaleRat ROA Fix Lev Liquidity Growth IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
esttab m1 m2,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 

gen zl=EI*Tec
tobit LnPat Tec zl Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit LnInv Tec zl Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
esttab m1 m2,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 

hhi operatingincome, by(industry)
gen hhi=hhi_operatingincome*100
gen jz=hhi*Tec
tobit LnPat Tec jz Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Province,ll(0) vce (ro)
eststo m1
tobit LnInv Tec jz Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Province,ll(0) vce (ro)
eststo m2
esttab m1 m2,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Year *.Province) 

*** Appendix Figure 1: Invention patent applications adjusted by industry and time before and after certification ***
use "Data.dta", clear
keep if Tec==1
gen n=Year-firsttec
bysort Year Industry: egen indpat=mean(LnInv)
gen y=LnInv-indpat
bysort n: egen pat=mean(y)
keep if n>=-3
keep if n<=5
label variable pat "Industry-Year Adjusted Invention"
graph twoway connected pat n, xlabel(-3(1)5) xtitle("") ytitle("") legend(on) scheme(s1mono)

*** Appendix: Common trend ***
use "PSMDID.dta", clear
drop if firsttec >2009 & firsttec !=. 
gen dumo=1 if Year==2006
replace dumo=0 if dumo==.
gen dumt=1 if Year==2007
replace dumt=0 if dumt==.
gen dido=dumo*Tec
gen didt=dumt*Tec

tobit LnPat dido Tec dumo Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Industry i.Province,ll(0) vce (ro) 
eststo m1
tobit LnInv dido Tec dumo Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Industry i.Province,ll(0) vce (ro) 
eststo m2
tobit LnPat didt Tec dumt Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Industry i.Province,ll(0) vce (ro) 
eststo m3
tobit LnInv didt Tec dumt Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Industry i.Province,ll(0) vce (ro) 
eststo m4
esttab m1 m2 m3 m4,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Province) // 


*** Appendix: Mechanism test: Bank credit ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=. 
gen xd=Ldebt*Tec
tobit Ldebt Tec Size Age SaleRat ROA Growth State IndRat Dual Institution i.Year i.Industry i.Provincell(0) vce (ro)
eststo m1
tobit LnPat xd Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
tobit LnInv xd Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m3
esttab m1 m2 m3,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 

*** Appendix: Economic, financial and legal institutional environment ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=. 
tobit LnPat Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution System i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit LnInv Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution System i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
tobit LnGra Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution System i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m3
tobit InvRat Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution System i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m4
esttab m1 m2 m3 m4,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 

*** Appendix: Direct effects or other underlying mechanisms ***
use "Data.dta", clear
drop if firsttec >2009 & firsttec !=. 
tobit LnPat Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution TaxYh Sub RDC RDP i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m1
tobit LnInv Tec Size Age SaleRat ROA Fix Lev Liquidity Growth State IndRat Dual Institution TaxYh Sub RDC RDP i.Year i.Industry i.Province,ll(0) vce (ro)
eststo m2
esttab m1 m2,compress nogap star(* 0.1  ** 0.05 *** 0.01) b(%10.4f) drop(*.Industry *.Year *.Province) 


