use "C:\Users\Yuanyuan Wan\Dropbox\MourifieWan\testing late\Submission Process\REStat\Application\Angrist1991\Angrist 1991 SIPP.dta", clear

set trace off

set matsize 11000

drop if rsncode==999
drop if kwage==.
drop if educ==.
drop if age_5==.
drop if nrace==.

gen Y=log(kwage)
gen D=nvstat

//Education variable.

gen X1=0
replace X1=1 if educ>11
replace X1=2 if educ>12

//Age variable.

gen X2=0
replace X2=1 if age_5>30
replace X2=2 if age_5>33
replace X2=3 if age_5>36

gen X3=nrace




gen group = 0

//generate subgroups by education and age.
replace group =1 if X3==0 & X1==0 & Y>0
replace group =2 if X3==0 & X1==1 & Y>0
replace group =3 if X3==0 & X1==2 & Y>0
replace group =4 if X3==1 & X1==0 & Y>0
replace group =5 if X3==1 & X1==1 & Y>0
replace group =6 if X3==1 & X1==2 & Y>0


tabulate group

save "C:\Users\Yuanyuan Wan\Dropbox\MourifieWan\testing late\Submission Process\REStat\Application\Angrist1991\bigsample1991.dta", replace //This sample is going to be important shortly.

local i=1 //Here we do use a loop.

while `i'<7 {
use "C:\Users\Yuanyuan Wan\Dropbox\MourifieWan\testing late\Submission Process\REStat\Application\Angrist1991\bigsample1991.dta", clear
keep if group==`i'

scalar N=500
centile(Y), centile(2.5 97.5)
scalar UB=r(c_2)
scalar LB=r(c_1)
gen T = LB+ 0.01*_n
replace T=. if T>UB
sum T Y

gen Zone=rsncode 
egen cone=mean(Zone)
gen cnil = (1-cone)
gen Ybar1 = cone*D*(1-Zone)-cnil*D*Zone
gen Ybar2 = cnil*(1-D)*Zone-cone*(1-D)*(1-Zone)

if _N>0{
clrtest (Ybar1 Y T) (Ybar2 Y T), met("local") level(0.9,0.95,0.99)
di "Results for group " `i'
/*
display e(bdwh1)
display e(bdwh2)
display e(cl95)
matrix list e(theta1)
matrix list e(se1)
matrix list e(theta2)
matrix list e(se2)
*/
}

if _N==0 {
di "Group " `i' " has no observations."
}

local i=`i'+1
}



//Anti truncation line.
