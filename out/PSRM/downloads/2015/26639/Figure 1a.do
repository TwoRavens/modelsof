version 12.1

******** FIGURE 1a Marginal effects of candidate attributes at different levels of respondents’ interest in politics
use data.dta, clear

***** Setting the mean or modal values for the respondent-level variables
* pol_interest = 3.3
sum pol_interest if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_pinterest=3.3
* left_right = 4.2
sum left_right if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_leftright=4.2
* gender =0 (female)
table gender if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_gender=0
* age = 21.4
sum age if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_age=21.4
* italian = 1
table italian if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_italian=1
* student = 1
table ftstudent if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_student=1
* lyceum = 1
table lyceum if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_lyceum=1
* edu_imp = 3.1
sum edu_imp if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_eduimp=3.1
* inc_imp = 1.9
sum inc_imp if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_incimp=1.9
* hon_imp = 3.9
sum hon_imp if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_honimp=3.9
* taxspend_imp = 3.7
sum taxspend_imp if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & taxspend_imp!=. & samesex_imp!=. & Y!=.
scalar h_taximp=3.7
* samesex_imp = 3.4
sum samesex_imp if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & taxspend_imp!=. & samesex_imp!=. & Y!=.
scalar h_sseximp=3.4 
* survey =1 (2013)
table survey if pol_interest!=. & left_right!=.n & gender!=. & age!=. & italian!=. & ftstudent!=. & lyceum!=. & edu_imp!=. & inc_imp!=. & hon_imp!=. & Y!=.
scalar h_survey=1

* Note: Non-varying candidate attributes are set at their baseline values (junior high school diploma, low income, clean, more taxation and spending, same rights to same sex-couples)

** Average marginal effects graph
**********   EDUCATION
* Education: High school vs. Middle-junior high
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b1 
generate x_betahat1 = MG_b2 + MG_b16*(`a') + MG_b22*h_leftright + MG_b28*h_gender + MG_b34*h_age + MG_b40*h_italian + MG_b46*h_student ///
+ MG_b52*h_lyceum + MG_b58*h_eduimp + MG_b100 + MG_b109 + MG_b114*h_survey
gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(-.2 "-0.2" -.1 "-0.1" 0 "0" .1 "0.1" .2 "0.2" .3 "0.3" .4 "0.4", labsize(3)) title(High vs. jr high school, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Edu2_polinterest, replace)

* Education: University vs. Middle-junior high
restore, not
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b1
generate x_betahat1 = MG_b3 + MG_b17*(`a') + MG_b23*h_leftright + MG_b29*h_gender + MG_b35*h_age + MG_b41*h_italian + MG_b47*h_student ///
+ MG_b53*h_lyceum + MG_b59*h_eduimp + MG_b103 + MG_b112 + MG_b115*h_survey
gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(, nolabels noticks labsize(3)) title(University vs. jr high school, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Edu3_polinterest, replace)

graph combine Edu2_polinterest.gph Edu3_polinterest.gph, graphregion(fcolor(white)) ycommon xcommon saving(Education_polinterest, replace)
restore, not

**********   INCOME
* Income: Middle vs Low
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b4
generate x_betahat1 = MG_b5 + MG_b18*(`a') + MG_b24*h_leftright + MG_b30*h_gender + MG_b36*h_age + MG_b42*h_italian + MG_b48*h_student ///
+ MG_b54*h_lyceum + MG_b60*h_incimp + MG_b116*h_survey

gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(.2 "0.2" .1 "0.1" 0 "0" -.1 "-0.1" -.2 "-0.2", labsize(3)) title(Middle vs. low income, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Inc2_polinterest, replace)

* Income: High vs Low
restore, not
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b4
generate x_betahat1 = MG_b6 + MG_b19*(`a') + MG_b25*h_leftright + MG_b31*h_gender + MG_b37*h_age + MG_b43*h_italian + MG_b49*h_student ///
+ MG_b55*h_lyceum + MG_b61*h_incimp + MG_b117*h_survey

gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(, nolabels noticks labsize(3)) title(High vs. low income, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Inc3_polinterest, replace)

graph combine Inc2_polinterest.gph Inc3_polinterest.gph, graphregion(fcolor(white)) ycommon xcommon saving(Income_polinterest, replace)
restore, not

**********   CORRUPTION
* Corruption: Investigated vs Clean sheet
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b7
generate x_betahat1 = MG_b8 + MG_b20*(`a') + MG_b26*h_leftright + MG_b32*h_gender + MG_b38*h_age + MG_b44*h_italian + MG_b50*h_student ///
+ MG_b56*h_lyceum + MG_b62*h_honimp + MG_b118*h_survey

gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(0 "0" -.1 "-0.1" -.3 "-0.3" -.5 "-0.5", labsize(3)) title(Investigated vs. clean sheet, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Corr2_polinterest, replace)

* Corruption: Corrupt vs Clean sheet
restore, not
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b7
generate x_betahat1 = MG_b9 + MG_b21*(`a') + MG_b27*h_leftright + MG_b33*h_gender + MG_b39*h_age + MG_b45*h_italian + MG_b51*h_student ///
+ MG_b57*h_lyceum + MG_b63*h_honimp + MG_b119*h_survey

gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(, nolabels noticks labsize(3)) title(Corrupt vs. clean sheet, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Corr3_polinterest, replace)

graph combine Corr2_polinterest.gph Corr3_polinterest.gph, graphregion(fcolor(white)) ycommon xcommon saving(Corruption_polinterest, replace)
restore, not

**********   TAX AND SPEND
* Taxspend: Maintain vs More tax and spend
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b10
generate x_betahat1 = MG_b11 + MG_b64*(`a') + MG_b68*h_leftright + MG_b72*h_gender + MG_b76*h_age + MG_b80*h_italian + MG_b84*h_student ///
+ MG_b88*h_lyceum + MG_b92*h_taximp + MG_b100 + MG_b120*h_survey
* 'high school diploma' candidate, for a candidate with 'university' degree replace MG_b100 with MG_b103
gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(.4 "0.4" .3 "0.3" .2 "0.2" .1 "0.1" 0 "0" -.1 "-0.1" -.2 "-0.2" -.3 "-0.3", labsize(3)) title(Constant vs. spend-tax more, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Tax2_polinterest, replace)

* Taxspend: Less tax and spend vs More tax and spend
restore, not
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b10
generate x_betahat1 = MG_b12 + MG_b65*(`a') + MG_b69*h_leftright + MG_b73*h_gender + MG_b77*h_age + MG_b81*h_italian + MG_b85*h_student ///
+ MG_b89*h_lyceum + MG_b93*h_taximp + MG_b101 + MG_b121*h_survey
* 'high school diploma' candidate, for a candidate with 'university' degree replace MG_b101 with MG_b104
gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(, nolabels noticks labsize(3)) title(Spend-tax less vs. spend-tax more, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Tax3_polinterest, replace)

graph combine Tax2_polinterest.gph Tax3_polinterest.gph, graphregion(fcolor(white)) ycommon xcommon saving(Taxspend_polinterest, replace)
restore, not

**********   SAME SEX RIGHTS
* Same sex: Some rights vs Same rights
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b13
generate x_betahat1 = MG_b14 + MG_b66*(`a') + MG_b70*h_leftright + MG_b74*h_gender + MG_b78*h_age + MG_b82*h_italian + MG_b86*h_student ///
+ MG_b90*h_lyceum + MG_b94*h_sseximp + MG_b109 + MG_b122*h_survey
* 'high school diploma' candidate, for a candidate with 'university' degree replace MG_b109 with MG_b112
gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(0 "0" -.1 "-0.1" -.2 "-0.2" -.3 "-0.3" -.4 "-0.4" -.5 "-0.5", labsize(3)) title(Some rights vs. same rights, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Ssex2_polinterest, replace)

* Same sex: No rights vs Same rights
restore, not
estimates use m10.ster
est des
preserve
drawnorm MG_b1-MG_b123, n(10000) means(e(b)) cov(e(V)) clear seed(1)
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi using sim.dta, replace
noisily display "start"
local a=1 
while `a' <= 4 {
{
generate x_betahat0 = MG_b13
generate x_betahat1 = MG_b15 + MG_b67*(`a') + MG_b71*h_leftright + MG_b75*h_gender + MG_b79*h_age + MG_b83*h_italian + MG_b87*h_student ///
+ MG_b91*h_lyceum + MG_b95*h_sseximp + MG_b110 + MG_b123*h_survey
* 'high school diploma' candidate, for a candidate with 'university' degree replace MG_b110 with MG_b113
gen prob0=normal(x_betahat0)
gen prob1=normal(x_betahat1)
gen diff=prob1-prob0
egen probhat0=mean(prob0)
egen probhat1=mean(prob1)
egen diffhat=mean(diff)
tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi   
_pctile prob0, p(2.5,97.5) 
scalar `lo0' = r(r1)
scalar `hi0' = r(r2)  
_pctile prob1, p(2.5,97.5)
scalar `lo1'= r(r1)
scalar `hi1'= r(r2)  
_pctile diff, p(2.5,97.5)
scalar `diff_lo'= r(r1)
scalar `diff_hi'= r(r2)  
scalar `prob_hat0'=probhat0
scalar `prob_hat1'=probhat1
scalar `diff_hat'=diffhat
post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi')
}
drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat 
local a=`a'+ 0.1
display "." _c 
} 
display ""
postclose mypost
use sim.dta, clear
gen MV = _n
eclplot diff_hat diff_hi diff_lo MV, estopts(msize(small)) rplottype(rspike) ciopts(msize(small)) graphregion(fcolor(white)) ysca(noline) xsca(noline r(1/31)) ytitle(" ", size(3)) xtitle(Interest in politics, size(3)) ///
xlabel(1 "none" 11 "some" 21 "fair" 31 "high", labsize(3)) ylabel(, nolabels noticks labsize(3)) title(No rights vs. same rights, size(3)) ///
yline(0, lcolor(black) lwidth(medthin)) saving(Ssex3_polinterest, replace)

graph combine Ssex2_polinterest.gph Ssex3_polinterest.gph, graphregion(fcolor(white)) ycommon xcommon saving(Samesex_polinterest, replace)

graph combine Education_polinterest.gph Income_polinterest.gph Corruption_polinterest.gph Taxspend_polinterest.gph Samesex_polinterest.gph hist_polinterest.gph, graphregion(fcolor(white)) ycommon xcommon ///
imargin(0 0 0 0) saving(Figure_1a, replace) 
exit
