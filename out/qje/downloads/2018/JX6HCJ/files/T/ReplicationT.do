
*Do not do randomization analysis across distance as cannot duplicate that without knowledge of region.  Hence, analysis is treatment effect of tinc only.
*Rumphi is strata because of double vouchers in some regions 

*The do file for this paper has problems.  Most regressions are not reproduced by the do-file.  In many cases, by creating variables and reading what the
*tables say was the specification, I can reproduce the results.  In some cases (later tables) no matter what I do I cannot reproduce the results.

use "Thornton HIV Testing Data.dta", clear

*Paper's preparatory code
replace tinc = tinc *0.009456
gen consentany2004= T_consenthiv
replace consentany2004=1 if T_consentsti==1 & consentany!=1
gen inter98 = 1 if m1out==2
gen inter01 =1 if m2out==2
foreach var of varlist hadsex12 havesex_fo {
gen got_`var' = got*`var'
gen got_hiv_`var' = got*`var'*hiv2004
gen any_hiv_`var' = any*`var'*hiv2004
gen tinc_hiv_`var' = tinc*`var'*hiv2004
gen under_hiv_`var' = under*`var'*hiv2004
gen any_male_`var' = any*`var'*male
}
foreach var of varlist any tinc under{
gen `var'_male = `var'* male
}
gen male_under = male*under
drop any_male tinc_male under_male 
foreach var of varlist got hiv2004 male havesex hadsex   {
gen any_`var' = any*`var' 
gen tinc_`var'  = tinc*`var' 
gen under_`var'  = under * `var' 
gen over_`var'  = over* `var' 
}
foreach var of varlist distvct  got hadsex male havesex {
gen male_`var' = male*`var'
gen any_`var'_hiv = any*`var' * hiv2004
gen tinc_`var'_hiv = tinc*`var' * hiv2004
gen under_`var'_hiv = under*`var' * hiv2004
gen over_`var'_hiv = over*`var' * hiv2004
gen hiv_`var' = hiv2004*`var'
gen `var'_hiv = hiv2004*`var'
gen any_`var'_male= any*`var' * male
gen tinc_`var'_male= tinc*`var' * male
gen under_`var'_male = under*`var' * male
}
gen tinc_male_hadsex12 =tinc_male*hadsex12 
gen under_male_hadsex12 =under_male*hadsex12
gen MainSample = 1 if test2004==1 & age!=. & villnum!=. & tinc!=. & distvct!=. & hiv2004!=-1 & followup_test!=1
keep if Main==1
gen more1_fo = 1 if numsex_fo>1 & numsex_fo!=.
replace more1_fo = 0 if numsex_fo==1|numsex_fo==0
gen distvcts = distvct*distvct

*My code, additional variable needed to match reported tables
generate tincs = tinc*tinc

*Below I correct paper's code as necessary producing regressions that match (exactly) those reported in the paper


*Table 4 - missing code for four columns, provides incorrect code - able to figure out and match
*Mistakenly reports coefficients and s.e. for constants in probit, which don't exist, and are simply repeats of other coef.

*Paper's code
*(as described in paper's do file) Columns 1-4: OLS [actually columns 1-5 are OLS]
reg got any male hiv2004 age age2 rumphi balaka , robust cluster(villnum) 
reg got any tinc male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
reg got any tinc distvct distvcts simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
reg got any tinc over simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 

*My code
*Last two regressions above are not the actual columns of table, I create the following lines of code to fill in columns (3)-(5)
reg got any tinc tincs male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 

*Paper's code
*(as described in paper's do file) Columns 5-8: Probit [actually, columns 6-10 are probit]
dprobit got any male hiv2004 age age2 rumphi balaka , robust cluster(villnum) 
dprobit got any tinc male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
dprobit got any tinc distvct distvcts simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
dprobit got any tinc over simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 

*My code
*As before, last two probits are not columns of table, I create appropriate code for last three columns of table 
dprobit got any tinc tincs male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
dprobit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 
dprobit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka, robust cluster(villnum) 



*Table 5 - code does not reproduce table, create my own code
*Columns 5 and 6 of table mislabeled and report results with wrong regressors

gen male_any = male*any
gen never = 1 if eversex==0 
replace never=0 if eversex==1 
gen any_never=any*never 
gen over_any=over*any 
gen hiv_any=hiv2004*any

*Paper's code
*Specifications and results don't match table at all
reg got any tinc male hiv2004 over tb thinktreat mar simave rumphi balaka , robust cluster(villnum)
reg got any tinc male hiv2004 over simave never any_never rumphi balaka if mar==0, robust cluster(villnum)
reg got any tinc male_any male hiv2004 over simave rumphi balaka if balaka== 1, robust cluster(villnum)
reg got over over_any hiv2004 age male any tinc age2 simav rumphi balaka, robust cluster(villnum) 
reg got over over_hiv hiv2004 age male any tinc age2 simav rumphi balaka, robust cluster(villnum) 
reg got over hiv_any hiv2004 age male any tinc age2 simav rumphi balaka, robust cluster(villnum) 

*My code
*Alternative code which does match table (adding tincs)
*Columns 5 and 6 of table as reported are mislabeled (switched) - column 5 is interaction HIV with over, column 6 is interaction HIV with any
reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka , robust cluster(villnum)
reg got any tinc tincs male hiv2004 over simave never any_never rumphi balaka if mar==0, robust cluster(villnum)
reg got any tinc tincs male_any male hiv2004 over simave rumphi balaka if balaka== 1, robust cluster(villnum)
reg got over over_any hiv2004 age male any tinc tincs age2 simav rumphi balaka, robust cluster(villnum) 
reg got over over_hiv hiv2004 age male any tinc tincs age2 simav rumphi balaka, robust cluster(villnum) 
reg got over hiv_any hiv2004 age male any tinc tincs age2 simav rumphi balaka, robust cluster(villnum) 




*Table 6 - wrong again, had to create own code
*Paper's code
reg got any_male tinc_male under_male any tinc under  any_male_hiv tinc_male_hiv under_male_hiv any_hiv2004 tinc_hiv2004 under_hiv2004 hiv2004 male  age age2 simave rumphi if followupsu == 1 &  hadsex12==1, robust cluster(villnum)
reg hiv_got any_male tinc_male under_male any tinc under  any_male_hiv tinc_male_hiv under_male_hiv any_hiv2004 tinc_hiv2004 under_hiv2004 hiv2004 male  age age2 simave rumphi if followupsu == 1 & hadsex12==1, robust cluster(villnum)

*My code
*Now modify to include the variables and interactions listed in the table (rather than code, which is completely unrelated) - match everything exactly except reported F statistics
generate tincs_male = tincs*male
generate distvct_male = distvct*male
generate distvcts_male = distvcts*male
generate tincs_male_hiv = tincs*male*hiv2004
generate distvct_male_hiv = distvct*male*hiv2004
generate distvcts_male_hiv = distvcts*male*hiv2004
generate tincs_hiv2004 = tincs*hiv2004
generate distvct_hiv2004 = distvct*hiv2004
generate distvcts_hiv2004 = distvcts*hiv2004
reg got any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_male_hiv tinc_male_hiv tincs_male_hiv distvct_male_hiv distvcts_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if followupsu == 1 & hadsex12==1, robust cluster(villnum)
reg hiv_got any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_male_hiv tinc_male_hiv tincs_male_hiv distvct_male_hiv distvcts_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if followupsu == 1 & hadsex12==1, robust cluster(villnum)



*Table 7 - All actual ivreg results wrong - wrong list of instruments

*Paper's code
** TABLE 7: Effects of Learning HIV Results among sexually active
ivreg anycond  hiv_got got hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg anycond  ( hiv_got  got= any_male tinc_male under_male any tinc under  any_male_hiv tinc_male_hiv under_male_hiv any_hiv2004 tinc_hiv2004 under_hiv2004) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg numcond hiv_got got hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg numcond ( hiv_got  got= any_male tinc_male under_male any tinc under  any_male_hiv tinc_male_hiv under_male_hiv any_hiv2004 tinc_hiv2004 under_hiv2004) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg bought hiv_got  got hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg bought ( hiv_got got= any_male tinc_male under_male any tinc under  any_male_hiv tinc_male_hiv under_male_hiv any_hiv2004 tinc_hiv2004 under_hiv2004) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg havesex_fo hiv_got got hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg havesex_fo ( hiv_got got= any_male tinc_male under_male any tinc under  any_male_hiv tinc_male_hiv under_male_hiv any_hiv2004 tinc_hiv2004 under_hiv2004) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 

*My code for the actual ivs
*Now, modified with the regression actually used in Table 6 as opposed to the one in this do-file - this works
ivreg anycond (hiv_got got = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_male_hiv tinc_male_hiv tincs_male_hiv distvct_male_hiv distvcts_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi ) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg numcond (hiv_got got = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_male_hiv tinc_male_hiv tincs_male_hiv distvct_male_hiv distvcts_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg bought (hiv_got got = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_male_hiv tinc_male_hiv tincs_male_hiv distvct_male_hiv distvcts_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 
ivreg havesex_fo (hiv_got got = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_male_hiv tinc_male_hiv tincs_male_hiv distvct_male_hiv distvcts_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi) hiv2004 male  age age2 simave rumphi if hadsex12==1, robust cluster(villnum) 

*Regular regressions (odd numbered lines above), have no treatment variables



*Table 8 - All actual ivreg results wrong - wrong list of instruments and (in case of biprobit) wrong estimation routine

*Paper's code
ivreg anycond  got male  age age2 simave rumphi if hadsex12==1 & hiv2004==1 , robust cluster(villnum) 
ivreg anycond  ( got= any_male tinc_male under_male any tinc under  ) male  age age2 simave rumphi if hadsex12==1 & hiv2004==1 , robust cluster(villnum) 
ivreg anycond  got male  age age2 simave rumphi if hadsex12==1 & hiv2004==0 , robust cluster(villnum) 
ivreg anycond  ( got= any_male tinc_male under_male any tinc under  ) male  age age2 simave rumphi if hadsex12==1 & hiv2004==0 , robust cluster(villnum) 

*My code
*Now, modified with the instruments actually used
ivreg anycond  (got = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male male age age2 simave rumphi) male age age2 simave rumphi if hadsex12==1 & hiv2004==1 , robust cluster(villnum) 
ivreg anycond  (got = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male male age age2 simave rumphi) male  age age2 simave rumphi if hadsex12==1 & hiv2004==0 , robust cluster(villnum) 

*Paper's code
*Regular regressions (odd numbered lines above), have no treatment variables
dprobit anycond got male  age age2 simave rumphi if hadsex12==1 & hiv2004==1 , robust cluster(villnum) 
dprobit anycond got male  age age2 simave rumphi if hadsex12==1 & hiv2004==0 , robust cluster(villnum) 

*Bivariate probits don't match at all, again wrong instruments & (in this case) wrong estimation routine
probit got any_male tinc_male under_male any tinc under  male  age age2 simave rumphi if hadsex12==1 & followupsurve==1 & hiv2004==1, robust cluster(villnum)
predict betagot 
probit anycond betagot male  age age2 simave rumphi if hadsex12==1 & hiv2004==1, robust cluster(villnum)
bootstrap _b, reps(500) seed(1234) :probit anycond betagot male  age age2 simave rumphi if hadsex12==1 & hiv2004==1, robust cluster(villnum)
mfx
drop beta*

probit got any_male tinc_male under_male any tinc under  male  age age2 simave rumphi if hadsex12==1 & followupsurve==1 & hiv2004==0, robust cluster(villnum)
predict betagot 
probit anycond betagot male  age age2 simave rumphi if hadsex12==1 & hiv2004==0, robust cluster(villnum)
bootstrap _b, reps(500) seed(1234) :probit anycond betagot male  age age2 simave rumphi if hadsex12==1 & hiv2004==0, robust cluster(villnum)
mfx
drop beta*


*Paper's code
*Table 9 - Once again all ivregs have wrong list of instruments - results don't match paper
ivreg anycond  got got_hadsex12 hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
ivreg anycond  (got got_hadsex12 = any_male tinc_male under_male  under any tinc under_hadsex12 tinc_hadsex12 any_hadsex12 any_male_hadsex12 tinc_male_hadsex12 under_male_hadsex12  ) hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
ivreg numcond got got_hadsex12 hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
ivreg numcond (got got_hadsex12 = any_male tinc_male under_male  under any tinc under_hadsex12 tinc_hadsex12 any_hadsex12 any_male_hadsex12 tinc_male_hadsex12 under_male_hadsex12  ) hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
ivreg bought got got_hadsex12 hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
ivreg bought (got got_hadsex12 = any_male tinc_male under_male  under any tinc under_hadsex12 tinc_hadsex12 any_hadsex12 any_male_hadsex12 tinc_male_hadsex12 under_male_hadsex12  ) hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
ivreg havesex_fo got got_hadsex12 hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
ivreg havesex_fo (got got_hadsex12 = any_male tinc_male under_male  under any tinc under_hadsex12 tinc_hadsex12 any_hadsex12 any_male_hadsex12 tinc_male_hadsex12 under_male_hadsex12  ) hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 

*My code
*When try putting in instrument list from above, doesn't work either - Can't find any way to reproduce the results reported in the paper.

*Example
ivreg anycond  (got got_hadsex12 = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male male hadsex12 age age2 simave rumphi) hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum) 
*Or try
generate tincs_hadsex12 = tincs*hadsex12
generate distvct_hadsex12 = distvct*hadsex12
generate distvcts_hadsex12 = distvcts*hadsex12
ivreg anycond  (got got_hadsex12 = any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_hadsex12 tinc_hadsex12 tincs_hadsex12 distvct_hadsex12 distvcts_hadsex12 male hadsex12 age age2 simave rumphi) hadsex12 male age age2 simave rumphi if hiv2004==0 , robust cluster(villnum)
*Doesn't work either

gen ll = 0 if a8==0
replace ll = 1 if a8!=0 & a8!=.
gen ll_fo = 0 if likelihoodhiv_fo==1
replace ll_fo = 1 if likelihoodhiv_fo!=1 & likelihoodhiv_fo!=.
gen got_ll = got*ll
gen got_ll_fo = got*ll_fo
gen any_ll=any*ll
gen tinc_ll=tinc*ll
gen under_ll=under*ll
gen any_male_ll = any*male*ll
gen tinc_male_ll = male*tinc*ll
gen under_male_ll = male*under*ll


*Paper's code
*Table 11 - Again ivreg results not consistent with paper
ivreg anycond   got got_ll ll male  age age2 simave rumphi if hiv2004==1 & hadsex12==1, robust cluster(villnum) 
ivreg anycond  ( got got_ll= any_male tinc_male under_male any tinc under any_ll tinc_ll under_ll any_male_ll tinc_male_ll under_male_ll) ll male  age age2 simave rumphi if hiv2004==1 & hadsex12==1, robust cluster(villnum) 
ivreg anycond   got got_ll ll male  age age2 simave rumphi if hiv2004==0 & hadsex12==1, robust cluster(villnum) 
ivreg anycond  ( got got_ll= any_male tinc_male under_male any tinc under any_ll tinc_ll under_ll any_male_ll tinc_male_ll under_male_ll) ll male  age age2 simave rumphi if hiv2004==0 & hadsex12==1, robust cluster(villnum) 

*My code
*Try entering variables indicated in table, again doesn't work
ivreg anycond  (got got_ll= any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male ll male age age2 simave rumphi) ll male  age age2 simave rumphi if hiv2004==1 & hadsex12==1, robust cluster(villnum)
*Or try
generate tincs_ll = tincs*ll
generate distvct_ll = distvct*ll
generate distvcts_ll = distvcts*ll
ivreg anycond  (got got_ll= any tinc tincs distvct distvcts any_male tinc_male tincs_male distvct_male distvcts_male any_ll tinc_ll tincs_ll distvct_ll distvcts_ll ll male age age2 simave rumphi) ll male  age age2 simave rumphi if hiv2004==1 & hadsex12==1, robust cluster(villnum)
*Doesn't work either



****************************************

*Now, my combined code, using parts of the paper I can reproduce (using my modifications of do file code as necessary)
*Do not do ivreg tables because they involve either (a) regressions without treatment variables (the regular regs); (b) overidentified ivs 
*So, only doing tables 4 , 5 and 6

use "Thornton HIV Testing Data.dta", clear

*Paper's preparatory code
replace tinc = tinc *0.009456
gen consentany2004= T_consenthiv
replace consentany2004=1 if T_consentsti==1 & consentany!=1
gen inter98 = 1 if m1out==2
gen inter01 =1 if m2out==2
foreach var of varlist hadsex12 havesex_fo {
gen got_`var' = got*`var'
gen got_hiv_`var' = got*`var'*hiv2004
gen any_hiv_`var' = any*`var'*hiv2004
gen tinc_hiv_`var' = tinc*`var'*hiv2004
gen under_hiv_`var' = under*`var'*hiv2004
gen any_male_`var' = any*`var'*male
}
gen male_under = male*under
foreach var of varlist got hiv2004 male havesex hadsex   {
gen any_`var' = any*`var' 
gen tinc_`var'  = tinc*`var' 
gen under_`var'  = under * `var' 
gen over_`var'  = over* `var' 
}
foreach var of varlist distvct  got hadsex male havesex {
gen male_`var' = male*`var'
gen any_`var'_hiv = any*`var' * hiv2004
gen tinc_`var'_hiv = tinc*`var' * hiv2004
gen under_`var'_hiv = under*`var' * hiv2004
gen over_`var'_hiv = over*`var' * hiv2004
gen hiv_`var' = hiv2004*`var'
gen `var'_hiv = hiv2004*`var'
gen any_`var'_male= any*`var' * male
gen tinc_`var'_male= tinc*`var' * male
gen under_`var'_male = under*`var' * male
}
gen tinc_male_hadsex12 =tinc_male*hadsex12 
gen under_male_hadsex12 =under_male*hadsex12
gen MainSample = 1 if test2004==1 & age!=. & villnum!=. & tinc!=. & distvct!=. & hiv2004!=-1 & followup_test!=1
gen more1_fo = 1 if numsex_fo>1 & numsex_fo!=.
replace more1_fo = 0 if numsex_fo==1|numsex_fo==0
gen distvcts = distvct*distvct
gen male_any = male*any
gen never = 1 if eversex==0 
replace never=0 if eversex==1 
gen any_never=any*never 
gen over_any=over*any 
gen hiv_any=hiv2004*any
generate tincs = tinc*tinc
generate tincs_male = tincs*male
generate distvct_male = distvct*male
generate distvcts_male = distvcts*male
generate tincs_male_hiv = tincs*male*hiv2004
generate distvct_male_hiv = distvct*male*hiv2004
generate distvcts_male_hiv = distvcts*male*hiv2004
generate tincs_hiv2004 = tincs*hiv2004
generate distvct_hiv2004 = distvct*hiv2004
generate distvcts_hiv2004 = distvcts*hiv2004

drop if tinc == .

matrix F = J(18,12,.)
matrix B = J(70,2,.)
matrix V = J(70,12,.)

*Table 4 - Corrected code

local j = 1
local i = 1
reg got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
reg got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
reg got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
reg got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
reg got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

dprobit got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
probit got any male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

dprobit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
probit got any tinc male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

dprobit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
probit got any tinc tincs male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

dprobit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
probit got any tinc tincs distvct distvcts simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 

dprobit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 
probit got any tinc tincs over simave male hiv2004 age age2 rumphi balaka if MainSample == 1, robust cluster(villnum) 


*Table 5 - Corrected code
*Columns 5 and 6 of table mislabeled and report results with wrong regressors

reg got any tinc tincs male hiv2004 over tb thinktreat mar simave rumphi balaka if MainSample == 1, robust cluster(villnum)
reg got any tinc tincs any_never male hiv2004 over simave never rumphi balaka if mar==0 & MainSample == 1, robust cluster(villnum)
reg got any tinc tincs male_any male hiv2004 over simave if balaka== 1 & MainSample == 1, robust cluster(villnum)
reg got any tinc tincs over_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
reg got any tinc tincs over over_hiv hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 
reg got any tinc tincs hiv_any over hiv2004 age male age2 simav rumphi balaka if MainSample == 1, robust cluster(villnum) 

*Table 6 - Corrected code

reg got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi  if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)
reg hiv_got any tinc tincs any_male tinc_male tincs_male any_male_hiv tinc_male_hiv tincs_male_hiv any_hiv2004 tinc_hiv2004 tincs_hiv2004 distvct distvcts distvct_male distvcts_male distvct_male_hiv distvcts_male_hiv distvct_hiv2004 distvcts_hiv2004 hiv2004 male age age2 simave rumphi if MainSample == 1 & followupsu == 1 & hadsex12==1, robust cluster(villnum)

save DatT, replace
