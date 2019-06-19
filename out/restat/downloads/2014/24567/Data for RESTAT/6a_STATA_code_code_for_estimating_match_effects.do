* try to see the distributio of match effects!

use "C:\Users\Bo\Documents\NC Peers\temp\basic_Jan09.dta", clear
sort lea  schlcode year
merge lea schlcode year using "C:\Users\Bo\Documents\NC Peers\ccd.dta", uniqusing
drop if _merge==2
drop _merge

egen sch_id=group(lea schlcode)
egen teach_id=group(teachid)
egen teach_sch=group(teachid sch_id)
egen class=group(teachid sch_id year)
gen obs_id=_n
*save mobility_data_file.dta , replace

sum  sch_id teach_id teach_sch

*get variance of teacher and school fixed effects without match effects!

xi: felsdvreg m_growth l_math  r_same s_same clsize  exp_3  exp_4 exp_10 exp_25 exp_missing  i.pared  i.grade i.year pblack pwhite phisp pfreelunch ln_enrol i.locale , i(teach_id) j(sch_id) p(teacher_fx) f(school_fx) xb(XB)  res(res_basic_m) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) cons
sum teacher_fx school_fx res_basic_m

bysort teach_id: gen count_teach=_n
bysort sch_id: gen count_sch=_n

sum teacher_fx if count_teach==1
sum school_fx if count_sch==1
gen res_basic_m_2=m_growth-XB

xi: felsdvreg r_growth l_read  r_same s_same clsize  exp_3  exp_4 exp_10 exp_25 exp_missing  i.pared  i.grade i.year pblack pwhite phisp pfreelunch ln_enrol i.locale , i(teach_id) j(sch_id) p(teacher_fx1) f(school_fx1) xb(XB1)  res(res_basic_r) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) cons
sum teacher_fx1 school_fx1 res_basic_r
sum teacher_fx1 if count_teach==1
sum school_fx1 if count_sch==1
gen res_basic_r_2=r_growth-XB

*********************************************************************


* NOW with match fixed effects

xi: xtreg m_growth l_math  r_same s_same clsize  exp_3  exp_4 exp_10 exp_25 exp_missing  i.pared  i.grade i.year pblack pwhite phisp pfreelunch ln_enrol i.locale , fe i(teach_sch) 
predict y_part_m, ue
predict res_m, e
sum res_m
bysort  teach_sch: egen teacher_school_fx_m=mean(y_part_m)

xi: xtreg r_growth l_read  r_same s_same clsize  exp_3  exp_4 exp_10 exp_25 exp_missing  i.pared  i.grade i.year pblack pwhite phisp pfreelunch ln_enrol i.locale , fe i(teach_sch) 
predict y_part_r, ue
predict res_r, e
sum res_r
bysort  teach_sch: egen teacher_school_fx_r=mean(y_part_r)


drop if y_part_r==. & y_part_m==.
bysort teach_sch: gen count_match=_n 


felsdvreg y_part_m , i(teach_id) j(sch_id) p(teacher_fx3) f(school_fx3) xb(XB)  res(res3) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) cons
bysort teach_sch: egen match_fx_m=mean(res3)
sum  res3
sum teacher_fx3 if count_teach==1
sum school_fx3 if count_sch==1
sum match_fx_m if count_match==1
gen res3_a=res3-match_fx_m
sum res3_a


felsdvreg y_part_r , i(teach_id) j(sch_id) p(teacher_fx4) f(school_fx4) xb(XB)  res(res4) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) cons
bysort teach_sch: egen match_fx_r=mean(res4)
sum  res4
sum teacher_fx4 if count_teach==1
sum school_fx4 if count_sch==1
sum match_fx_r if count_match==1
gen res4_a=res4-match_fx_r
sum res4_a

save "C:\Users\Bo\Documents\orthogonal_matches.dta" , replace

rename  match_fx_r  match_fx_orth_r
rename  match_fx_m  match_fx_orth_m

duplicates drop  lea schlcode teachid , force
save "C:\Users\Bo\Documents\orthogonal_match_effects.dta" , replace

*********************************************************************

*Create files for R to estimate random effects!

use "C:\Users\Bo\Documents\orthogonal_matches.dta" , clear
keep y_part_r y_part_m teach_id sch_id teach_sch class res_basic_r_2 res_basic_m_2 obs_id
save "C:\Users\Bo\Documents\R_file.dta" , replace


*** Run R code after runnning this in Stata


*********************************************************************
*** AFTER runnign the R-code then run this


*get the PLUPs from R 

clear
insheet using "C:\Users\Bo\Documents\sch_fx_math.txt", delimiter(`" "') 
rename  intercept sch_id
rename v2 sch_fx_math
save "C:\Users\Bo\Documents\Match FX\sch_fx_math.dta" , replace

clear
insheet using "C:\Users\Bo\Documents\match_fx_math.txt", delimiter(`" "')
rename  intercept teach_sch
rename v2 match_fx_math
save "C:\Users\Bo\Documents\Match FX\match_fx_math.dta" , replace

clear
insheet using "C:\Users\Bo\Documents\teach_fx_math.txt", delimiter(`" "')
rename  intercept teach_id
rename v2 teach_fx_math
save "C:\Users\Bo\Documents\Match FX\teach_fx_math.dta" , replace


clear
insheet using "C:\Users\Bo\Documents\sch_fx_read.txt", delimiter(`" "')
rename  intercept sch_id
rename v2 sch_fx_read
save "C:\Users\Bo\Documents\Match FX\sch_fx_read.dta" , replace

clear
insheet using "C:\Users\Bo\Documents\match_fx_read.txt", delimiter(`" "')
rename  intercept teach_sch
rename v2 match_fx_read
save "C:\Users\Bo\Documents\Match FX\match_fx_read.dta" , replace

clear
insheet using "C:\Users\Bo\Documents\teach_fx_read.txt", delimiter(`" "')
rename  intercept teach_id
rename v2 teach_fx_read
save "C:\Users\Bo\Documents\Match FX\teach_fx_read.dta" , replace

*******************  Merge them all in   ************************************************

use "C:\Users\Bo\Documents\Match FX\sch_fx_read.dta" , clear
merge sch_id using "C:\Users\Bo\Documents\Match FX\sch_fx_math.dta" , unique sort
drop _merge
save "C:\Users\Bo\Documents\Match FX\school_fx.dta" , replace

use "C:\Users\Bo\Documents\Match FX\teach_fx_read.dta" , clear
merge teach_id using "C:\Users\Bo\Documents\Match FX\teach_fx_math.dta" , unique sort
drop _merge
save "C:\Users\Bo\Documents\Match FX\teach_fx.dta" , replace

use "C:\Users\Bo\Documents\Match FX\match_fx_read.dta" , clear
merge teach_sch using "C:\Users\Bo\Documents\Match FX\match_fx_math.dta" , unique sort
drop _merge
save "C:\Users\Bo\Documents\Match FX\match_fx.dta" , replace

******************* Now use the BLUPS in regressions *********************













