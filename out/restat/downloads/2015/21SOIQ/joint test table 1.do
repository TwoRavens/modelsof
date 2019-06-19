clear
clear matrix
set more off
set mem 5000m 
set matsize 500 
capture log close

use /ssb/ovibos/a1/swp/kav/wk24/allreforms/data/cohorts_87_92.dta

*symmetric 3 month window. 

*87-reform: 1.05.1987. 
gen reform87=1 if fodtaar>=mdy(5,1,1987) & fodtaar<mdy(8,1,1987)
replace reform87=0 if fodtaar<mdy(5,1,1987)& fodtaar>=mdy(2,1,1987)
tab b_month if reform87==1
tab b_month if reform87==0

*88-reform: 1.juli
gen reform88=1 if fodtaar>=mdy(7,1,1988) & fodtaar<mdy(10,1,1988)
replace reform88=0 if fodtaar<mdy(7,1,1988) & fodtaar>=mdy(4,1,1988)

tab b_month if reform88==1
tab b_month if reform88==0

*89-reform: 1.april
gen reform89=1 if fodtaar>=mdy(4,1,1989) & fodtaar<mdy(7,1,1989)
replace reform89=0 if fodtaar<mdy(4,1,1989) & fodtaar>=mdy(1,1,1989)
tab b_month if reform89==1
tab b_month if reform89==0


*90-reform: 1.5.1990: 
gen reform90=1 if fodtaar>=mdy(5,1,1990) & fodtaar<mdy(8,1,1990)
replace reform90=0 if fodtaar< mdy(5,1,1990)  & fodtaar>=mdy(2,1,1990)

tab b_month if reform90==1
tab b_month if reform90==0

*91-reform: 1.7.1991: 
gen reform91=1 if  fodtaar>=mdy(7,1,1991) & fodtaar<mdy(10,1,1991)
replace reform91=0 if fodtaar<mdy(7,1,1991) & fodtaar>=mdy(4,1,1991)
tab b_month if reform91==1
tab b_month if reform91==0


*92-reform: 1.4.1992: 
gen reform92=1 if fodtaar>=mdy(4,1,1992) & fodtaar<mdy(7,1,1992)
replace reform92=0 if fodtaar< mdy(4,1,1992) & fodtaar>=mdy(1,1,1992)
tab b_month if reform92==1
tab b_month if reform92==0


*93 reform: 1.april
gen reform93=1 if fodtaar>=mdy(4,1,1993) & fodtaar<mdy(7,1,1993)
replace reform93=0 if fodtaar<mdy(4,1,1993) & fodtaar>=mdy(1,1,1993)






foreach t in 87 88 89 90 91 92  {
gen nreform`t'=1 if reform`t'==0
replace nreform`t'=0 if reform`t'==1
}

***generate linear slopes
sum fodtaar if fodtaar==mdy(5,1,1987)
local threshold87=r(mean)
display `threshold87'

sum fodtaar if fodtaar==mdy(7,1,1988)
local threshold88=r(mean)
display `threshold88'


sum fodtaar if fodtaar==mdy(4,1,1989)
local threshold89=r(mean)
display `threshold89'

sum fodtaar if fodtaar==mdy(5,1,1990)
local threshold90=r(mean)
display `threshold90'

sum fodtaar if fodtaar==mdy(7,1,1991)
local threshold91=r(mean)
display `threshold91'


sum fodtaar if fodtaar==mdy(4,1,1992)
local threshold92=r(mean)
display `threshold92'

sum fodtaar if fodtaar==mdy(4,1,1993)
local threshold93=r(mean)
display `threshold93'




*days
foreach t in 87 88 89 90 91 92 {

gen dslope`t'=fodtaar-`threshold`t'' if reform`t'!=. 
gen dslope`t'_1= dslope`t'* reform`t'
gen dslope`t'_2=dslope`t'*nreform`t' 


}


* eligible var
drop eligible
gen eligible=.

forvalues t=1987/1992 {
replace eligible=eligible`t' if b_year==`t'
}






******TEST whether the effects in table 1 (covariate balance) are jointly different from zero
*test balanced covariates



keep if reform87!=. | reform88!=. | reform89!=. | reform90!=. | reform91!=. | reform92!=.


/*

I think we can do something much simpler if we are willing to ignore the small amount of correlation due to some mothers giving birth in multiple reforms.  If we ignore this, performing a joint test is actually quite easy.What we do is first run sureg (seemingly unrelated regression) for the outcomes which all have a given reform year (like 1987).  This is a straightforward application of sureg.  After we run sureg for this given reform year, we use the "test" command to jointly test the outcomes for this reform year.  This will account for the correlation in the error terms for a given reform year across outcomes.  The output will be an F statistic -- if there are 5 outcomes being tested in a reform year, then it will be an F(5,large n) which is asymptotically a chi-square(5) / 5.  So if we multiply this F statistic by 5, we will have a chi-square(5).

Now we do separate suregs for each reform year, saving the F statistics after running the test command.  Since the sum of chi-squares has a chi-square distribution, if we take the F-statistics from each sureg multiplied by 5 (or how many ever outcomes we jointly test in each year) and add them, we will still have a chi-square distribution.  For example, if we have 5 outcomes for each of 6 reform years, we would add up the 6 F-statistics multiplied by 5 and we would have a chi-square distribution with 30 degrees of freedom.  We then simply compare the value of this chi-square test statistic to the critical value from a chi-square distribution with 30 degrees of freedom.

It should be really easy:  run sureg for each reform year followed by the test command; store the F-statistics, scale them, and sum them.



*/

log using /ssb/ovibos/a1/swp/kav/wk24/allreforms/sureg_all.log, replace
**FULL SAMPLE (includeing eligibles and ineligibles)

sureg (meduy reform87 dslope87_1 dslope87_2) (feduy reform87 dslope87_1 dslope87_2) (fageb reform87 dslope87_1 dslope87_2) (mageb reform87 dslope87_1 dslope87_2) (eligible reform87 dslope87_1 dslope87_2)

test reform87

scalar chi_reform87=r(chi2)

sureg (meduy reform88 dslope88_1 dslope88_2) (feduy reform88 dslope88_1 dslope88_2) (fageb reform88 dslope88_1 dslope88_2) (mageb reform88 dslope88_1 dslope88_2) (eligible reform88 dslope88_1 dslope88_2)

test reform88

scalar chi_reform88=r(chi2)


sureg (meduy reform89 dslope89_1 dslope89_2) (feduy reform89 dslope89_1 dslope89_2) (fageb reform89 dslope89_1 dslope89_2) (mageb reform89 dslope89_1 dslope89_2) (eligible reform89 dslope89_1 dslope89_2)

test reform89


scalar chi_reform89=r(chi2)

sureg (meduy reform90 dslope90_1 dslope90_2) (feduy reform90 dslope90_1 dslope90_2) (fageb reform90 dslope90_1 dslope90_2) (mageb reform90 dslope90_1 dslope90_2) (eligible reform90 dslope90_1 dslope90_2)

test reform90


scalar chi_reform90=r(chi2)

sureg (meduy reform91 dslope91_1 dslope91_2) (feduy reform91 dslope91_1 dslope91_2) (fageb reform91 dslope91_1 dslope91_2) (mageb reform91 dslope91_1 dslope91_2) (eligible reform91 dslope91_1 dslope91_2)

test reform91

scalar chi_reform91=r(chi2)

sureg (meduy reform92 dslope92_1 dslope92_2) (feduy reform92 dslope92_1 dslope92_2) (fageb reform92 dslope92_1 dslope92_2) (mageb reform92 dslope92_1 dslope92_2) (eligible reform92 dslope92_1 dslope92_2)

test reform92

scalar chi_reform92=r(chi2)

scalar chi_sum=chi_reform87+chi_reform88+chi_reform89+chi_reform90+chi_reform91+chi_reform92

dipslay `chi_sum'




log close








