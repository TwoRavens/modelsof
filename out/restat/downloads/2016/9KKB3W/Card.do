
set matsize 11000


local i=1 //Here we do use a loop.

while `i'<8 {

use "C:\Users\Yuanyuan Wan\Dropbox\Testing Late\Empirical\card.dta", clear

keep if group==`i'

centile(Y), centile(2.5 97.5)
scalar UB=r(c_2)
scalar LB=r(c_1)
/*if `i'==5 {scalar LB=5.7}*/
disp UB
disp LB

gen T = LB+ 0.01*_n
replace T=. if T>UB


scalar N=500 //This is a grid with 500 points.


sum T


egen c1=mean(Z)
gen c0=1-c1

disp c1

gen Ybar1 = c1*D*(1-Z)-c0*D*Z
gen Ybar2 = c0*(1-D)*Z-c1*(1-D)*(1-Z)


if _N>0{
clrtest (Ybar1 Y T) (Ybar2 Y T), met("local") level(0.9,0.95,0.99,0.995)

di "Results for group " `i'

}


	
local i=`i'+1
}


clear 
local i=8

use "C:\Users\Yuanyuan Wan\Dropbox\Testing Late\Empirical\card.dta", clear

keep if group>0

centile(Y), centile(2.5 97.5) //This stores the results in the return memory.
scalar UB=r(c_2) //This sets a scalar equal to the 95th percentile of the data.
scalar LB=r(c_1) //This sets a scalar equal to the 5th percentile of the data.

gen T = LB+ 0.01*_n
replace T=. if T>UB


noisily sum T Y

egen c1=mean(Z)
gen c0=1-c1

disp c1

gen Ybar1 = c1*D*(1-Z)-c0*D*Z
gen Ybar2 = c0*(1-D)*Z-c1*(1-D)*(1-Z)
clrtest (Ybar1 Y T) (Ybar2 Y T), met("local") level(0.9,0.95,0.99,0.995)
di "Results for whole sample "


//Anti truncation line.
