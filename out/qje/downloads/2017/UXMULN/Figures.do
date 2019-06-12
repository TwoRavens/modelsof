

clear *

cap cd "~/Dropbox/Projects/The Demand for Status/Final_data_QJE"

set more off

/************************

Figure 2

************************/


clear*

use Datasets/Experiment1.dta, clear

drop if exclude == 1

count if Gold==1
count if Platinum_upgrade==1
count if Platinum_upgrade_merit==1

regress decision Gold Platinum_upgrade Platinum_upgrade_merit , nocons robust

mat R=J(3,4,.) 
local row=1
foreach X in  Gold Platinum_upgrade Platinum_upgrade_merit {
mat R[`row',1]=_b[`X']
mat R[`row',2]=_b[`X']-1.96*_se[`X']
mat R[`row',3]=_b[`X']+1.96*_se[`X']
mat R[`row',4]=`row'
local ++row
}
clear
svmat R
la var R4 Group
la var R1 "Take-up Rates"
label define groups 1 "(1) Benefits upgrade"  2 "(2) Platinum upgrade" 3 "(3) Plat. upgrade merit" 
label values R4 groups
set scheme s2mono
twoway (bar R1 R4, barw(0.65) fi(inten30) lc(black) lw(medium) ) ///
	   (rcap R3 R2 R4, lc(gs5)), ///
	   legend(off) xlabel(1/3, valuelabel) ///
	   ylabel(0.0(0.05)0.275) yscale(range(0.0 0.275))  ///
	   text(0.05 1 "13.7%") text(0.05 2 "21.0%") text(0.05 3 "23.0%") ///
	   text(0.0125 1 "N=271") text(0.0125 2 "N=281") text(0.0125 3 "N=283") ///
	   text(0.24 1.5 "p-value=0.025") ///
	   text(0.26 1.5 "H{subscript:0}: (1)=(2)") ///	   
	   text(0.24 2.5 "p-value=0.549") ///
	   text(0.26 2.5 "H{subscript:0}: (2)=(3)") ///	   
	   graphregion(color(white))    ytitle("Take-up Rates") ///


	   	   	   
graph export "Figures/Figure_experiment1.pdf", replace		   


/************************

Figure 3

************************/

/* Note: the NDA with the partner bank does not allow us to post the transaction data. Therefore, it is not possible to replicate column 2 of Table A.1.


use Final_data_QJE/Datasets/Transactions.dta, clear


count if C20000000 == 1 
count if C30000000 == 1 
count if C40000000 == 1 
count if C50000000 == 1 


reg visible C20000000 C30000000 C40000000 C50000000, nocons robust


mat R=J(4,4,.) 
test _b[C20000000]=_b[C30000000]
test _b[C30000000]=_b[C40000000]
test _b[C40000000]=_b[C50000000]
local row=1
foreach X in  C20000000 C30000000 C40000000 C50000000 {
mat R[`row',1]=_b[`X']
mat R[`row',2]=_b[`X']-1.96*_se[`X']
mat R[`row',3]=_b[`X']+1.96*_se[`X']
mat R[`row',4]=`row'
local ++row
}
clear
svmat R
la var R4 "Credit Limit"
la var R1 "Share Visible Transaction"
label define groups 1 "(1) Rp 20m"  2 "(2) Rp 30m" 3 "(3) Rp 40m" 4 "(4) Rp 50m"
label values R4 groups
set scheme s2mono
twoway (bar R1 R4, barw(0.65) fi(inten30) lc(black) lw(medium) ) ///
	   (rcap R3 R2 R4, lc(gs5)), ///
	   legend(off) xlabel(1/4, valuelabel) ///
	   xline(2.5, lpattern(-) lcolor(gs10)) ///
	   ylabel(0.0(0.05)0.3) yscale(range(0.0 0.3))  ///
	   text(0.05 1 "10.2%") text(0.05 2 "11.4%") text(0.05 3 "17.5%") text(0.05 4 "18.6%") ///
	   text(0.0125 1 "N=737") text(0.0125 2 "N=552") text(0.0125 3 "N=1094") text(0.0125 4 "N=109") ///
	   text(0.235 1.5 "H{subscript:0}: (1)=(2)") ///	  
	   text(0.215 1.5 "p-value=0.372") ///
	   text(0.235 2.5 "H{subscript:0}: (2)=(3)") ///	  
	   text(0.215 2.5 "p-value<0.001") ///
	   text(0.235 3.5 "H{subscript:0}: (3)=(4)") ///	  
	   text(0.215 3.5 "p-value=0.637") ///
	   text(0.275 1.5 "Gold") text(0.275 3.5 "Platinum") ///
	   graphregion(color(white))    ytitle("Share Visible Transactions")
	   	   	   
graph export "Figures/Figure_transaction.pdf", replace		   

*/

/************************

Figure 4

************************/

clear*

use Datasets/Experiment2.dta, clear


keep if exclude==0 

gen T1=T==1
gen T0=T==0

reg Y T1 T0, nocons robust


mat R=J(2,4,.) 
test _b[T1]=_b[T0]
local row=1
foreach X in  T0 T1 {
mat R[`row',1]=_b[`X']
mat R[`row',2]=_b[`X']-1.96*_se[`X']
mat R[`row',3]=_b[`X']+1.96*_se[`X']
mat R[`row',4]=`row'
local ++row
}
clear
svmat R
la var R4 Group
la var R1 "Take-up Rates"
label define groups 1 "(1) Control"  2 "(2) Treatment" 
label values R4 groups
set scheme s2mono
twoway (bar R1 R4, barw(0.65) fi(inten30) lc(black) lw(medium) ) ///
	   (rcap R3 R2 R4, lc(gs5)), ///
	   legend(off) xlabel(1/2, valuelabel) ///
	   ylabel(0.0(0.1)0.6) yscale(range(0.0 0.6))  ///
	   text(0.075 1 "21.6%") text(0.075 2 "40.5%") ///
	   text(0.025 1 "N=51") text(0.025 2 "N=42") ///
	   text(0.51 1.5 "H{subscript:0}: (1)=(2)") ///
	   text(0.475 1.5 "p-value=0.068") ///
	   graphregion(color(white))    ytitle("Diamond Take-up Rates") ///

	   	   	   
graph export "Figures/Figure_experiment2.pdf", replace		   





/************************

Figure 5

************************/

set more off
use Datasets/mTurk.dta, clear

mat R=J(17,10,.)


gen control=1-self

forvalues x=1(1)5 {

regress demand_armani_offer`x'  self control,  r noc

mat R[`x',1]=1-_b[self]
mat R[`x',2]=1-_b[control]
mat R[`x',3]=`x'

}

mat li R

set more off
clear
svmat R

gen Armani_premium=-100 if R3==5
replace Armani_premium=-50 if R3==4
replace Armani_premium=0 if R3==3
replace Armani_premium=50 if R3==2
replace Armani_premium=100 if R3==1

drop if R1==.
expand 3
sort Armani

replace Armani=-125 if _n==1
replace Armani=-75 if _n==3

replace Armani=-75 if _n==4
replace Armani=-25 if _n==6

replace Armani=-25 if _n==7
replace Armani=25 if _n==9

replace Armani=25 if _n==10
replace Armani=75 if _n==12

replace Armani=75 if _n==13
replace Armani=125 if _n==15

la var R1 "Self Affirmation"
la var R2 "Control"
la var Armani_premium "WTP for Armani relative to Old Navy"


set scheme s2mono
twoway (line R1 Armani_premium,  )  (line R2 Armani_premium,  ), ///
        graphregion(color(white))    ytitle("Cumulative Distribution")  xlabel(-150(50)150) ylabel(0.4(0.1)1)
	   	   	   
graph export "Figures/MTurk.pdf", replace	


/************************

Figure A1

************************/


clear*

use Datasets/Experiment3.dta, clear

keep if  exclude == 0


mat TABLE4=J(30,8,.)

count if plat_ntrl==1
count if plat_pstv ==1
count if upgr_ntrl ==1
count if upgr_pstv ==1

reg takeup plat_ntrl plat_pstv upgr_ntrl upgr_pstv, noc robust


mat R=J(4,4,.) 
test _b[plat_ntrl] = _b[plat_pstv]
test _b[upgr_ntrl] = _b[upgr_pstv]
*
local row=1
foreach X in plat_ntrl plat_pstv upgr_ntrl upgr_pstv {
mat R[`row',1]=_b[`X']
mat R[`row',2]=_b[`X']-1.96*_se[`X']
mat R[`row',3]=_b[`X']+1.96*_se[`X']
mat R[`row',4]=`row'
local ++row
}
clear
svmat R
la var R4 Group
la var R1 "Take-up Rates"
label define groups 1 "(1) Neutral"  2 "(2) Self Affirmation" 3 "(3) Neutral" 4 "(4) Self Affirmation"
label values R4 groups
set scheme s2mono
twoway (bar R1 R4, barw(0.65) fi(inten30) lc(black) lw(medium) ) ///
	   (rcap R3 R2 R4, lc(gs5)), ///
	   legend(off) xlabel(1/4, valuelabel) ///
	   ylabel(0.0(0.05)0.45) yscale(range(0.0 0.45))  ///
	   xline(2.5, lpattern(-) lcolor(black)) ///
	   text(0.04 1 "32.6%") text(0.04 2 "17.6%") text(0.04 3 "10.9%") text(0.04 4 "11.4%")	///
	   text(0.0125 1 "N=43") text(0.0125 2 "N=34") text(0.0125 3 "N=46") text(0.0125 4 "N=44") ///
	   text(0.375 1.5 "H{subscript:0}: (1)=(2)") ///
	   text(0.35 1.5 "p-value=0.199") ///
	   text(0.375 3.5 "H{subscript:0}: (3)=(4)") ///
	   text(0.35 3.5 "p-value=0.754") ///
	   graphregion(color(white))    ytitle("Take-up Rates") ///
	   text(0.425 1.5 "Platinum upgrade") text(0.425 3.5 "Benefits upgrade") ///
	   	   	   
graph export "Figures/Figure_experiment3.pdf", replace	

