set matsize 11000

cd "C:\Users\Yuanyuan Wan\Dropbox\MourifieWan\testing late\Submission Process\REStat\Application\AngristEvans1998"

local i=1 //Here we do use a loop.

while `i'<25 {

use smallsample_nomass_`i'.dta, clear

centile(Y), centile(2.5,97.5)
scalar UB=r(c_2)
scalar LB=r(c_1)
drop T
gen T = LB+ 0.01*_n
replace T=. if T>UB
sum T Y

if _N>0{
clrtest (Ybar1 Y T) (Ybar2 Y T), met("local") level(0.9,0.95,0.99)
di "Results for group " `i'
display e(bdwh1)
display e(bdwh2)
display e(cl95)
/*matrix list e(theta1)
matrix list e(se1)
matrix list e(theta2)
matrix list e(se2)*/
}



local i=`i'+1
}



//Anti truncation line.
