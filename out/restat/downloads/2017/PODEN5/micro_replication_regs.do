

use nlsy_data_repvars.dta, clear

/* UI - Men Figure 2 */

set more off
matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979)
outreg2 using micro_rep_nostateFE, replace
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save manui_logit_nostateFE_rep.dta, replace

restore

/* UI - Women Figure 3 */

set more off
matrix define mydata = .,.,.
logit b femuiyearm7up femuiyearm56 femuiyearm34 femuiyearm12 femuiyear01 femuiyear23 femuiyear45 femuiyear67 femuiyear89 femuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_ndfem>45 & weeks_ndfem<.) | (weeks_d1fem>45 & weeks_d1fem<.)) , cluster(id1979)
outreg2 using micro_rep_nostateFE, append
test femuiyearm12 = femuiyear01
test femuiyearm7up + femuiyearm56 + femuiyearm34 + femuiyearm12 = 0
margins, dydx(femuiyearm7up femuiyearm56 femuiyearm34 femuiyearm12 femuiyear01 femuiyear23 femuiyear45 femuiyear67 femuiyear89 femuiyear10up) post
matrix define mydata = mydata\ _b[femuiyearm7up], _se[femuiyearm7up], -8
matrix define mydata = mydata\ _b[femuiyearm56], _se[femuiyearm56], -6
matrix define mydata = mydata\ _b[femuiyearm34], _se[femuiyearm34], -4
matrix define mydata = mydata\ _b[femuiyearm12], _se[femuiyearm12], -2
matrix define mydata = mydata\ _b[femuiyear01], _se[femuiyear01], 0
matrix define mydata = mydata\ _b[femuiyear23], _se[femuiyear23], 2
matrix define mydata = mydata\ _b[femuiyear45], _se[femuiyear45], 4
matrix define mydata = mydata\ _b[femuiyear67], _se[femuiyear67], 6
matrix define mydata = mydata\ _b[femuiyear89], _se[femuiyear89], 8
matrix define mydata = mydata\ _b[femuiyear10up], _se[femuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save femui_logit_nostateFE_rep.dta, replace

restore

/* UI - Men by financial benefit Figure 4 */

set more off
matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 i.year /*i.state*/ if lastgt0finben==1 & year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979)
outreg2 using micro_rep_nostateFE, append 
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen finben = 1
save manui_logit_finbengt0_nostateFE_rep.dta, replace

restore

set more off
matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 i.year /*i.state*/ if lastgt0finben==0 & year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979)
outreg2 using micro_rep_nostateFE, append 
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen finben = 0
save manui_logit_finbenlt0_nostateFE_rep.dta, replace
restore

/* UI - Men by debt Figure 5 */

set more off
matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 i.year /*i.state*/ if lastgt40debts==1 & year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979)
outreg2 using micro_rep_nostateFE, append 
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen debtgt40 = 1
save manui_logit_debtsgt40_nostateFE_rep.dta, replace
restore

set more off
matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 i.year /*i.state*/ if lastgt40debts==0 & year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979)
outreg2 using micro_rep_nostateFE, append 
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen debtgt40 = 0
save manui_logit_debtslt40_nostateFE_rep.dta, replace
restore


/* Divorce Figure 6 */

set more off
matrix define mydata = .,.,.
logit b myearm7up myearm56 myearm34 myearm12 myear01 myear23 myear45 myear67 myear89 myear10up gcompletec black age age2 male lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & evermarried==1 & pb!=1, cluster(id1979)
outreg2 using micro_rep_nostateFE, append
test myearm12 = myear01
test myearm7up + myearm56 + myearm34 + myearm12 = 0
margins, dydx(myearm7up myearm56 myearm34 myearm12 myear01 myear23 myear45 myear67 myear89 myear10up) post
matrix define mydata = mydata\ _b[myearm7up], _se[myearm7up], -8
matrix define mydata = mydata\ _b[myearm56], _se[myearm56], -6
matrix define mydata = mydata\ _b[myearm34], _se[myearm34], -4
matrix define mydata = mydata\ _b[myearm12], _se[myearm12], -2
matrix define mydata = mydata\ _b[myear01], _se[myear01], 0
matrix define mydata = mydata\ _b[myear23], _se[myear23], 2
matrix define mydata = mydata\ _b[myear45], _se[myear45], 4
matrix define mydata = mydata\ _b[myear67], _se[myear67], 6
matrix define mydata = mydata\ _b[myear89], _se[myear89], 8
matrix define mydata = mydata\ _b[myear10up], _se[myear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save div_logit_nostateFE_rep.dta, replace

restore 

/* Disability Figure 7 */

set more off
matrix define mydata = .,.,.
logit b hyearm7up hyearm56 hyearm34 hyearm12 hyear01 hyear23 hyear45 hyear67 hyear89 hyear10up gcompletec black age age2 male lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1, cluster(id1979)
outreg2 using micro_rep_nostateFE, append
test hyearm12 = hyear01
test hyearm7up + hyearm56 + hyearm34 + hyearm12 = 0
margins, dydx(hyearm7up hyearm56 hyearm34 hyearm12 hyear01 hyear23 hyear45 hyear67 hyear89 hyear10up) post
matrix define mydata = mydata\ _b[hyearm7up], _se[hyearm7up], -8
matrix define mydata = mydata\ _b[hyearm56], _se[hyearm56], -6
matrix define mydata = mydata\ _b[hyearm34], _se[hyearm34], -4
matrix define mydata = mydata\ _b[hyearm12], _se[hyearm12], -2
matrix define mydata = mydata\ _b[hyear01], _se[hyear01], 0
matrix define mydata = mydata\ _b[hyear23], _se[hyear23], 2
matrix define mydata = mydata\ _b[hyear45], _se[hyear45], 4
matrix define mydata = mydata\ _b[hyear67], _se[hyear67], 6
matrix define mydata = mydata\ _b[hyear89], _se[hyear89], 8
matrix define mydata = mydata\ _b[hyear10up], _se[hyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save health_logit_nostateFE_rep.dta, replace

restore

/* Divorce by financial benefit Figure 8 */

set more off
matrix define mydata = .,.,.
logit b myearm7up myearm56 myearm34 myearm12 myear01 myear23 myear45 myear67 myear89 myear10up gcompletec black age age2 male i.year /*i.state*/ if lastgt0finben==1 & year>1982 & age <. & insample==1 & evermarried==1 & pb!=1, cluster(id1979)
outreg2 using micro_rep_nostateFE, append
test myearm12 = myear01
test myearm7up + myearm56 + myearm34 + myearm12 = 0
margins, dydx(myearm7up myearm56 myearm34 myearm12 myear01 myear23 myear45 myear67 myear89 myear10up) post
matrix define mydata = mydata\ _b[myearm7up], _se[myearm7up], -8
matrix define mydata = mydata\ _b[myearm56], _se[myearm56], -6
matrix define mydata = mydata\ _b[myearm34], _se[myearm34], -4
matrix define mydata = mydata\ _b[myearm12], _se[myearm12], -2
matrix define mydata = mydata\ _b[myear01], _se[myear01], 0
matrix define mydata = mydata\ _b[myear23], _se[myear23], 2
matrix define mydata = mydata\ _b[myear45], _se[myear45], 4
matrix define mydata = mydata\ _b[myear67], _se[myear67], 6
matrix define mydata = mydata\ _b[myear89], _se[myear89], 8
matrix define mydata = mydata\ _b[myear10up], _se[myear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timediv
gen finben = 1
save div_logit_finbengt0_nostateFE_rep.dta, replace

restore

set more off
matrix define mydata = .,.,.
logit b myearm7up myearm56 myearm34 myearm12 myear01 myear23 myear45 myear67 myear89 myear10up gcompletec black age age2 male i.year /*i.state*/ if lastgt0finben==0 & year>1982 & age <. & insample==1 & evermarried==1 & pb!=1, cluster(id1979)
outreg2 using micro_rep_nostateFE, append
test myearm12 = myear01
test myearm7up + myearm56 + myearm34 + myearm12 = 0
margins, dydx(myearm7up myearm56 myearm34 myearm12 myear01 myear23 myear45 myear67 myear89 myear10up) post
matrix define mydata = mydata\ _b[myearm7up], _se[myearm7up], -8
matrix define mydata = mydata\ _b[myearm56], _se[myearm56], -6
matrix define mydata = mydata\ _b[myearm34], _se[myearm34], -4
matrix define mydata = mydata\ _b[myearm12], _se[myearm12], -2
matrix define mydata = mydata\ _b[myear01], _se[myear01], 0
matrix define mydata = mydata\ _b[myear23], _se[myear23], 2
matrix define mydata = mydata\ _b[myear45], _se[myear45], 4
matrix define mydata = mydata\ _b[myear67], _se[myear67], 6
matrix define mydata = mydata\ _b[myear89], _se[myear89], 8
matrix define mydata = mydata\ _b[myear10up], _se[myear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timediv
gen finben = 0
save div_logit_finbenlt0_nostateFE_rep.dta, replace

restore


/* Disability by financial benefit Figure 9 */

set more off
matrix define mydata = .,.,.
logit b hyearm7up hyearm56 hyearm34 hyearm12 hyear01 hyear23 hyear45 hyear67 hyear89 hyear10up gcompletec black age age2 male i.year /*i.state*/ if lastgt0finben==1 & year>1982 & age <. & insample==1 & pb!=1, cluster(id1979)
outreg2 using micro_rep_nostateFE, append
test hyearm12 = hyear01
test hyearm7up + hyearm56 + hyearm34 + hyearm12 = 0
margins, dydx(hyearm7up hyearm56 hyearm34 hyearm12 hyear01 hyear23 hyear45 hyear67 hyear89 hyear10up) post
matrix define mydata = mydata\ _b[hyearm7up], _se[hyearm7up], -8
matrix define mydata = mydata\ _b[hyearm56], _se[hyearm56], -6
matrix define mydata = mydata\ _b[hyearm34], _se[hyearm34], -4
matrix define mydata = mydata\ _b[hyearm12], _se[hyearm12], -2
matrix define mydata = mydata\ _b[hyear01], _se[hyear01], 0
matrix define mydata = mydata\ _b[hyear23], _se[hyear23], 2
matrix define mydata = mydata\ _b[hyear45], _se[hyear45], 4
matrix define mydata = mydata\ _b[hyear67], _se[hyear67], 6
matrix define mydata = mydata\ _b[hyear89], _se[hyear89], 8
matrix define mydata = mydata\ _b[hyear10up], _se[hyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timedis
gen finben = 1
save dis_logit_finbengt0_nostateFE_rep.dta, replace

restore

set more off
matrix define mydata = .,.,.
logit b hyearm7up hyearm56 hyearm34 hyearm12 hyear01 hyear23 hyear45 hyear67 hyear89 hyear10up gcompletec black age age2 male i.year /*i.state*/ if lastgt0finben==0 & year>1982 & age <. & insample==1 & pb!=1, cluster(id1979)
outreg2 using micro_rep_nostateFE, append
test hyearm12 = hyear01
test hyearm7up + hyearm56 + hyearm34 + hyearm12 = 0
margins, dydx(hyearm7up hyearm56 hyearm34 hyearm12 hyear01 hyear23 hyear45 hyear67 hyear89 hyear10up) post
matrix define mydata = mydata\ _b[hyearm7up], _se[hyearm7up], -8
matrix define mydata = mydata\ _b[hyearm56], _se[hyearm56], -6
matrix define mydata = mydata\ _b[hyearm34], _se[hyearm34], -4
matrix define mydata = mydata\ _b[hyearm12], _se[hyearm12], -2
matrix define mydata = mydata\ _b[hyear01], _se[hyear01], 0
matrix define mydata = mydata\ _b[hyear23], _se[hyear23], 2
matrix define mydata = mydata\ _b[hyear45], _se[hyear45], 4
matrix define mydata = mydata\ _b[hyear67], _se[hyear67], 6
matrix define mydata = mydata\ _b[hyear89], _se[hyear89], 8
matrix define mydata = mydata\ _b[hyear10up], _se[hyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timedis
gen finben = 0
save dis_logit_finbenlt0_nostateFE_rep.dta, replace

restore


/* married and single - Appendix Figure 1 */

matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)) & married==1, cluster (id1979)
outreg2 using micro_rep_nostateFE, append
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen married = 1
save manui_logit_married_nostateFE_rep.dta, replace

restore

set more off
/* single */
matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)) & married==0, cluster (id1979)
outreg2 using micro_rep_nostateFE, append
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen married = 0
save manui_logit_single_nostateFE_rep.dta, replace

restore

/* above/below median income in previous survey year - appendix figure 2 */


matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)) & lastincgt==1, cluster (id1979)
outreg2 using micro_rep_nostateFE, append
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen lastincgt = 1
save manui_logit_lastincgt_nostateFE_rep.dta, replace

restore

matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)) & lastincgt==0, cluster (id1979)
outreg2 using micro_rep_nostateFE, append
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen lastincgt = 0
save manui_logit_lastinclt_nostateFE_rep.dta, replace

restore

/* by bankruptcy type - appendix figure 3 */

set more off
matrix define mydata = .,.,.
logit b7 manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979)
outreg2 using micro_rep_nostateFE, append
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen b7 = 1
save manui_logit_b7_nostateFE_rep.dta, replace

restore


matrix define mydata = .,.,.
logit b13 manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979)
outreg2 using micro_rep_nostateFE, append
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
margins, dydx(manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up) post
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI
gen b7 = 0
save manui_logit_b13_nostateFE_rep.dta, replace

restore

/* LOG ODDS - Appendix Table 1 */

set more off
matrix define mydata = .,.,.
logit b manuiyearm7up manuiyearm56 manuiyearm34 manuiyearm12 manuiyear01 manuiyear23 manuiyear45 manuiyear67 manuiyear89 manuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_nd>45 & weeks_nd<.)| (weeks_d1>45 & weeks_d1<.)), cluster (id1979) or
outreg2 using micro_rep_nostateFE_logodds, replace eform
test manuiyearm12 = manuiyear01
test manuiyearm7up + manuiyearm56 + manuiyearm34 + manuiyearm12 = 0
matrix define mydata = mydata\ _b[manuiyearm7up], _se[manuiyearm7up], -8
matrix define mydata = mydata\ _b[manuiyearm56], _se[manuiyearm56], -6
matrix define mydata = mydata\ _b[manuiyearm34], _se[manuiyearm34], -4
matrix define mydata = mydata\ _b[manuiyearm12], _se[manuiyearm12], -2
matrix define mydata = mydata\ _b[manuiyear01], _se[manuiyear01], 0
matrix define mydata = mydata\ _b[manuiyear23], _se[manuiyear23], 2
matrix define mydata = mydata\ _b[manuiyear45], _se[manuiyear45], 4
matrix define mydata = mydata\ _b[manuiyear67], _se[manuiyear67], 6
matrix define mydata = mydata\ _b[manuiyear89], _se[manuiyear89], 8
matrix define mydata = mydata\ _b[manuiyear10up], _se[manuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save manui_logit_nostateFE_logodds_rep.dta, replace

restore

set more off
matrix define mydata = .,.,.
logit b femuiyearm7up femuiyearm56 femuiyearm34 femuiyearm12 femuiyear01 femuiyear23 femuiyear45 femuiyear67 femuiyear89 femuiyear10up gcompletec black age age2 lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1 & ((weeks_ndfem>45 & weeks_ndfem<.) | (weeks_d1fem>45 & weeks_d1fem<.)) , cluster(id1979) or
outreg2 using micro_rep_nostateFE_logodds, append eform
test femuiyearm12 = femuiyear01
test femuiyearm7up + femuiyearm56 + femuiyearm34 + femuiyearm12 = 0
matrix define mydata = mydata\ _b[femuiyearm7up], _se[femuiyearm7up], -8
matrix define mydata = mydata\ _b[femuiyearm56], _se[femuiyearm56], -6
matrix define mydata = mydata\ _b[femuiyearm34], _se[femuiyearm34], -4
matrix define mydata = mydata\ _b[femuiyearm12], _se[femuiyearm12], -2
matrix define mydata = mydata\ _b[femuiyear01], _se[femuiyear01], 0
matrix define mydata = mydata\ _b[femuiyear23], _se[femuiyear23], 2
matrix define mydata = mydata\ _b[femuiyear45], _se[femuiyear45], 4
matrix define mydata = mydata\ _b[femuiyear67], _se[femuiyear67], 6
matrix define mydata = mydata\ _b[femuiyear89], _se[femuiyear89], 8
matrix define mydata = mydata\ _b[femuiyear10up], _se[femuiyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save femui_logit_nostateFE_logodds_rep.dta, replace

restore

set more off
matrix define mydata = .,.,.
logit b myearm7up myearm56 myearm34 myearm12 myear01 myear23 myear45 myear67 myear89 myear10up gcompletec black age age2 male lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & evermarried==1 & pb!=1, cluster(id1979) or
outreg2 using micro_rep_nostateFE_logodds, append eform
test myearm12 = myear01
test myearm7up + myearm56 + myearm34 + myearm12 = 0
matrix define mydata = mydata\ _b[myearm7up], _se[myearm7up], -8
matrix define mydata = mydata\ _b[myearm56], _se[myearm56], -6
matrix define mydata = mydata\ _b[myearm34], _se[myearm34], -4
matrix define mydata = mydata\ _b[myearm12], _se[myearm12], -2
matrix define mydata = mydata\ _b[myear01], _se[myear01], 0
matrix define mydata = mydata\ _b[myear23], _se[myear23], 2
matrix define mydata = mydata\ _b[myear45], _se[myear45], 4
matrix define mydata = mydata\ _b[myear67], _se[myear67], 6
matrix define mydata = mydata\ _b[myear89], _se[myear89], 8
matrix define mydata = mydata\ _b[myear10up], _se[myear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save div_logit_nostateFE_logodds_rep.dta, replace

restore

set more off
matrix define mydata = .,.,.
logit b hyearm7up hyearm56 hyearm34 hyearm12 hyear01 hyear23 hyear45 hyear67 hyear89 hyear10up gcompletec black age age2 male lastfinben lastfinben2 i.year /*i.state*/ if year>1982 & age <. & insample==1 & pb!=1, cluster(id1979) or
outreg2 using micro_rep_nostateFE_logodds, append eform
test hyearm12 = hyear01
test hyearm7up + hyearm56 + hyearm34 + hyearm12 = 0
matrix define mydata = mydata\ _b[hyearm7up], _se[hyearm7up], -8
matrix define mydata = mydata\ _b[hyearm56], _se[hyearm56], -6
matrix define mydata = mydata\ _b[hyearm34], _se[hyearm34], -4
matrix define mydata = mydata\ _b[hyearm12], _se[hyearm12], -2
matrix define mydata = mydata\ _b[hyear01], _se[hyear01], 0
matrix define mydata = mydata\ _b[hyear23], _se[hyear23], 2
matrix define mydata = mydata\ _b[hyear45], _se[hyear45], 4
matrix define mydata = mydata\ _b[hyear67], _se[hyear67], 6
matrix define mydata = mydata\ _b[hyear89], _se[hyear89], 8
matrix define mydata = mydata\ _b[hyear10up], _se[hyear10up], 10

preserve

clear
svmat mydata
drop if mydata1 ==.
rename mydata1 beta
rename mydata2 se
rename mydata3 timeUI

save health_logit_nostateFE_logodds_rep.dta, replace

restore

/* Appendix Table 2 */

xi: reg totaldebts_tc2 byearm9up byearm78 byearm56 byearm34 byearm12 byear01 byear23 byear45 byear67 byear89 byear10up gcompletec black age age2 i.year if age <. & insample==1, cluster(id1979)
sum totaldebts_tc2 if bankdiffyr==. & e(sample)
xi: reg amtothdebts2 byearm9up byearm78 byearm56 byearm34 byearm12 byear01 byear23 byear45 byear67 byear89 byear10up gcompletec black age age2 i.year if age <. & insample==1, cluster(id1979)
sum amtothdebts2 if bankdiffyr==. & e(sample)
xi: reg own byearm9up byearm78 byearm56 byearm34 byearm12 byear01 byear23 byear45 byear67 byear89 byear10up gcompletec black age age2 i.year if age <. & insample==1, cluster(id1979)
sum own if bankdiffyr==. & e(sample)

/* Appendix Table 3 */

gen edcat = .
replace edcat = 1 if gcompletec<=11
replace edcat = 2 if gcompletec==12
replace edcat= 3 if gcompletec>12 & gcompletec<16
replace edcat = 4 if gcompletec>=16 & gcompletec<.
tab edcat if year==2004 & age<. [aw=wgt]

sum age if year==2004 & age<. [aw=wgt]
sum momhgc1979 if year==2004 & age<. [aw=wgt]
sum dadhgc1979 if year==2004 & age<. [aw=wgt]
sum male if year==2004 & age<. [aw=wgt]
sum black if year==2004 & age<. [aw=wgt]

by id1979: egen everb = sum(b)
sum everb
sum everb if year==2004 & age<. [aw=wgt]

by id1979: egen evermanyearui = sum(manyearui)
gen evermanui = evermanyearui>0 & evermanyearui<.
sum evermanui if year==2004 & age<. [aw=wgt]

by id1979: egen everfemyearui = sum(femyearui)
gen everfemui = everfemyearui>0 & everfemyearui<.
sum everfemui if year==2004 & age<. [aw=wgt]

by id1979: egen marshocktot = sum(marshock)
gen everdivorced = marshocktot>0 & marshocktot<.
sum everdivorced if year==2004 & age<. [aw=wgt]

by id1979: egen healthshocktot = sum(healthshock)
gen everhealth = healthshocktot>0 & healthshocktot<.
sum everhealth if year==2004 & age<. [aw=wgt]

/* Appendix Table 4 - NLSY results */

gen anyui = onui==1 | onuisp==1
gen anynui03 = anyui==1 | l.anyui==1 | l2.anyui==1 | l3.anyui==1
tab b anynui03, row nof

gen manui = (onui==1 & male==1) | (onuisp==1 & male==0)
gen anyuiman03 = manui==1 | l.manui==1 | l2.manui==1 | l3.manui==1
tab b anyuiman03 if male==1, row nof

gen femui = (onui==1 & male==0) | (onuisp==1 & male==1)
gen anyuifem03 = femui==1 | l.femui==1 | l2.femui==1 | l3.femui==1
tab b anyuifem03 if male==0, row nof

gen marshock03 = marshock == 1 | l.marshock==1 | l2.marshock==1 | l3.marshock==1
tab b marshock03, row nof

gen healthshock03 = health == 1 | l.health==1 | l2.health==1 | l3.health==1
tab b healthshock03, row nof

gen anyuishock = 0
by id1979: replace anyuishock = 1 if anyui==1 & l.anyui==0 & year<1996
by id1979: replace anyuishock = 1 if anyui==1 & l2.anyui==0 & year>=1996
tab b anyuishock, row nof

gen manuishock03 = manuishock==1 | l.manuishock==1 | l2.manuishock==1 | l3.manuishock==1
tab b manuishock03 if male==1, row nof

gen femuishock03 = femuishock==1 | l.femuishock==1 | l2.femuishock==1 | l3.femuishock==1
tab b femuishock03 if male==0, row nof

gen div03 = myear01 + myear23
tab b div03, row nof

gen health03 = hyear01 + hyear23
tab b health03, row nof


/* Appendix Table 4 - PSID results */

/* note: everything below here requires downloading Erik Hurst's PSID extract here:
http://faculty.chicagobooth.edu/erik.hurst/research/b_aer2000b.dta

use erik_b_aer2000b.dta, clear
tsset id time

/* flag post-bankruptcy observations */
gen timeb = time if bank==1
by id: egen timeb2 = min(timeb)
by id: gen pb = timeb2<time

gen yearnowork = time if nowork==1
by id: egen workyearloss = min(yearnowork)
gen noworkrelyear = time - workyearloss

/* create year until / after unemployment dummies */
gen noworkyear01 = 0
replace noworkyear01 = 1 if noworkrelyear==0 | noworkrelyear==1
gen noworkyear23 = 0
replace noworkyear23 = 1 if noworkrelyear==2 | noworkrelyear==3
gen noworkyear45 = 0 
replace noworkyear45 = 1 if noworkrelyear==4 | noworkrelyear==5
gen noworkyear67 = 0 
replace noworkyear67 = 1 if noworkrelyear==6 | noworkrelyear==7
gen noworkyear89 = 0 
replace noworkyear89 = 1 if noworkrelyear==8 | noworkrelyear==9
gen noworkyearm12 = 0
replace noworkyearm12 = 1 if noworkrelyear==-1 | noworkrelyear==-2
gen noworkyearm34 = 0 
replace noworkyearm34 = 1 if noworkrelyear==-3 | noworkrelyear==-4
gen noworkyearm56 = 0
replace noworkyearm56 = 1 if noworkrelyear==-5 | noworkrelyear==-6
gen noworkyearm78 = 0
replace noworkyearm78 = 1 if noworkrelyear==-7 | noworkrelyear==-8
gen noworkyearm9up = 0
replace noworkyearm9up = 1 if noworkrelyear<-8
gen noworkyear10up= 0
replace noworkyear10up = 1 if noworkrelyear>9 & noworkrelyear<.
gen noworkyearm7up = 0
replace noworkyearm7up = 1 if noworkrelyear<-6

/* divorce shocks */

gen yeardiv = time if divor==1
by id: egen divyearloss = min(yeardiv)
gen divrelyear = time - divyearloss

/* create year until / after divorce dummies */
gen divyear01 = 0
replace divyear01 = 1 if divrelyear==0 | divrelyear==1
gen divyear23 = 0
replace divyear23 = 1 if divrelyear==2 | divrelyear==3
gen divyear45 = 0 
replace divyear45 = 1 if divrelyear==4 | divrelyear==5
gen divyear67 = 0 
replace divyear67 = 1 if divrelyear==6 | divrelyear==7
gen divyear89 = 0 
replace divyear89 = 1 if divrelyear==8 | divrelyear==9
gen divyearm12 = 0
replace divyearm12 = 1 if divrelyear==-1 | divrelyear==-2
gen divyearm34 = 0 
replace divyearm34 = 1 if divrelyear==-3 | divrelyear==-4
gen divyearm56 = 0
replace divyearm56 = 1 if divrelyear==-5 | divrelyear==-6
gen divyearm78 = 0
replace divyearm78 = 1 if divrelyear==-7 | divrelyear==-8
gen divyearm9up = 0
replace divyearm9up = 1 if divrelyear<-8
gen divyear10up= 0
replace divyear10up = 1 if divrelyear>9 & divrelyear<.
gen divyearm7up = 0
replace divyearm7up = 1 if divrelyear<-6

/* health shocks */

gen yearhealth = time if health==1
by id: egen healthyearloss = min(yearhealth)
gen healthrelyear = time - healthyearloss

/* create year until / after health shock dummies */
gen healthyear01 = 0
replace healthyear01 = 1 if healthrelyear==0 | healthrelyear==1
gen healthyear23 = 0
replace healthyear23 = 1 if healthrelyear==2 | healthrelyear==3
gen healthyear45 = 0 
replace healthyear45 = 1 if healthrelyear==4 | healthrelyear==5
gen healthyear67 = 0 
replace healthyear67 = 1 if healthrelyear==6 | healthrelyear==7
gen healthyear89 = 0 
replace healthyear89 = 1 if healthrelyear==8 | healthrelyear==9
gen healthyearm12 = 0
replace healthyearm12 = 1 if healthrelyear==-1 | healthrelyear==-2
gen healthyearm34 = 0 
replace healthyearm34 = 1 if healthrelyear==-3 | healthrelyear==-4
gen healthyearm56 = 0
replace healthyearm56 = 1 if healthrelyear==-5 | healthrelyear==-6
gen healthyearm78 = 0
replace healthyearm78 = 1 if healthrelyear==-7 | healthrelyear==-8
gen healthyearm9up = 0
replace healthyearm9up = 1 if healthrelyear<-8
gen healthyear10up= 0
replace healthyear10up = 1 if healthrelyear>9 & healthrelyear<.
gen healthyearm7up = 0
replace healthyearm7up = 1 if healthrelyear<-6

gen nowork03 = nowork==1 | l.nowork==1 | l2.nowork==1 | l3.nowork==1
tab bank nowork03 [aw=weight], row nof

gen div03 = divor==1 | l.divor==1 | l2.divor==1 | l3.divor==1
tab bank div03 [aw=weight], row nof

gen health03 = health==1 | l.health==1 | l2.health==1 | l3.health==1
tab bank health03 [aw=weight], row nof

gen firstnowork03 = noworkyear01 + noworkyear23
tab bank firstnowork03 [aw=weight], row nof

gen firstdiv03 = divyear01 + divyear23
tab bank firstdiv03 [aw=weight], row nof

gen firsthealth03 = healthyear01 + healthyear23
tab bank firsthealth03 [aw=weight], row nof

*/

log close
