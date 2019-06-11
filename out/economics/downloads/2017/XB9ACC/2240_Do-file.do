clear
set more off

use tb.dta

*Describing Dataset*
desc

***Table 1: Descriptive Statistics***

swilk ab bc cb ba amntcgivesovertheprincipal amntcretainsovertheprincipal A_earnings B_earnings C_earnings AB_prop BC_prop CB_prop BA_prop Retained_prop Given_prop
sktest ab bc cb ba amntcgivesovertheprincipal amntcretainsovertheprincipal A_earnings B_earnings C_earnings AB_prop BC_prop CB_prop BA_prop Retained_prop Given_prop
log using new_sum
for var ab bc cb ba amntcgivesovertheprincipal amntcretainsovertheprincipal A_earnings B_earnings C_earnings AB_prop BC_prop CB_prop BA_prop Retained_prop Given_prop: ranksum X, by(info)
log close
outreg2 using sums.doc, word label sum(detail) drop(grpid round multiplier dividend info study) eqkeep(N max min p50 mean sd)
bysort info: outreg2 using table1.doc, word label sum(detail) drop(grpid round multiplier dividend info study) eqkeep(p50)
ssc install fprank

*** Robust Rank Order Test ***
for var ab bc cb ba amntcgivesovertheprincipal amntcretainsovertheprincipal A_earnings B_earnings C_earnings AB_prop BC_prop CB_prop BA_prop Retained_prop Given_prop: fprank X, by(info)

***Table 2: Pairwise correlations***

pwcorr AB_prop BC_prop CB_prop BA_prop amntcgiv amntcret if info == 0, sig
pwcorr AB_prop BC_prop CB_prop BA_prop amntcgiv amntcret if info == 1, sig

***Table 3: Regression analyses of Reciprocity and Selfishness ***
reg amntcret c.dividend#b(0).info ab bc, robust
outreg2 using revised.doc, word label append
reg amntcgive c.dividend#b(0).info ab bc, robust
outreg2 using revised.doc, word label append

*** Round Fixed-Effects ***
reg amntcret c.dividend#b(0).info ab bc i.round, robust
outreg2 using revised.doc, word label append
reg amntcgive c.dividend#b(0).info ab bc i.round, robust
outreg2 using revised.doc, word label append


*** Figure 2***
graph bar (mean) Retained_prop Given_prop AB_prop BC_prop BA_prop, over(multiplier) ytitle(Proportions) nolab by(info)
graph bar (mean) amntcgivesovertheprincipal amntcretainsovertheprincipal, over(multiplier) ytitle(Transfer Amounts) by(info)


***Robustness Checks and Additional Statistics***

*Check for Balance of Multiplier*
ttest mult if info == 0, by(study) uneq

*Decriptive Statistics of Differences between Studies*

estpost ttest ab bc cb ba amntcgives amntcretains A_earnings B_earnings Cearnings AB_prop BC_prop CB_prop BA_prop Retained Given if info == 0, by(study) uneq
for var ab bc cb ba A_earnings B_earnings Cearnings AB_prop BC_prop CB_prop BA_prop Retained Given amntcgives amntcretains: esize two X if info==0, by(study) uneq cohensd

estpost ttest ab bc cb ba amntcgives amntcretains A_earnings B_earnings C_earnings AB_prop BC_prop CB_prop BA_prop Retained Given if info == 1, by(study) uneq
for var ab bc cb ba A_earnings B_earnings Cearnings AB_prop BC_prop CB_prop BA_prop Retained Given amntcgives amntcretains: esize two X if info==1, by(study) uneq cohensd

*Count of zero transfers*
count if ab == 0 & study == 1 & info == 1
count if bc == 0 & study == 1 & info == 1
count if cb == 0 & study == 1 & info == 1
count if ba == 0 & study == 1 & info == 1

count if ab == 0 & study == 1 & info == 0
count if bc == 0 & study == 1 & info == 0
count if cb == 0 & study == 1 & info == 0
count if ba == 0 & study == 1 & info == 0

count if ab == 0 & study == 2 & info == 1
count if bc == 0 & study == 2 & info == 1
count if cb == 0 & study == 2 & info == 1
count if ba == 0 & study == 2 & info == 1

count if ab == 0 & study == 2 & info == 0
count if bc == 0 & study == 2 & info == 0
count if cb == 0 & study == 2 & info == 0
count if ba == 0 & study == 2 & info == 0

*Check for differences between total level of transfers*
gen total = ab + bc + cb +ba
ttest total if info==0, by(study)
ttest total if info==0, by(study) uneq

ttest dividend if info == 0, by(study) uneq
ttest dividend if info == 1, by)study) uneq

ttest total, by(study) uneq

save, replace

**** Fixed-effect and Panel-data regression ****

** Set up **

use tb
egen group = concat(grpid study info)
sort group round
destring group, gen(gid)
xtset gid round

quietly xtreg amntcret c.dividend#b(0).info ab bc, robust
outreg2 using xtreg.doc, word label
quietly xtreg amntcret c.dividend#b(0).info ab bc, fe robust
outreg2 using xtreg.doc, word label append
quietly xtreg amntcgive c.dividend#b(0).info ab bc, robust
outreg2 using xtreg.doc, word label append
qui xtreg amntcgive c.dividend#b(0).info ab bc, fe robust
outreg2 using xtreg.doc, word label append



