***************************************************************************************************************************************************************
*   Table 3 
***************************************************************************************************************************************************************


*create summary stats for mobility

use "C:\Users\Bo\Documents\Match FX\endog_moving_reg_file.dta", clear
bysort  lea schlcode teachid year: egen mean_read_teacher=mean(read_norm)
bysort  lea schlcode teachid year: egen mean_math_teacher=mean(math_norm)

bysort  lea schlcode year: egen mean_read_school=mean(read_norm)
bysort  lea schlcode year: egen mean_math_school=mean(math_norm)

bysort  lea schlcode year teachid: egen mean_clsize_teacher=mean(clsize)
bysort  lea schlcode year: egen mean_clsize_school=mean(clsize)

gen non_white=ethnic!="W"
bysort  lea schlcode year teachid : egen mean_non_white_teacher=mean(non_white)
bysort  lea schlcode year: egen mean_non_white_school=mean(non_white)

duplicates drop  lea schlcode teachid year , force
 
keep lea schlcode teachid year  mean_read_teacher- mean_non_white_school
drop  non_white

sort lea schlcode teachid year
save "C:\Users\Bo\Documents\Match FX\mean_school_characteristics.dta" , replace

use "C:\Users\Bo\Documents\Match FX\mobility_reg_file.dta", clear
sort lea schlcode teachid year
merge m:1 lea schlcode teachid year using "C:\Users\Bo\Documents\Match FX\mean_school_characteristics.dta"

destring lea, gen(lea2) force
destring schlcode, gen(schlcode2) force

drop if teachid==.
sort teachid year
bysort teachid: gen entry=_n
tsset teachid entry

gen ind_moved= ( lea2!=L.lea2 |  schlcode2!=L.schlcode2 ) & ( L.lea2!=. | L.schlcode2!=.)

gen city= locale=="1" |  locale=="2"
gen urban_fringe= locale=="3" |  locale=="4"
gen town= locale=="5" |  locale=="6"
gen rural= locale=="7" |  locale=="8"


*compare places they left to those they went to! 
sum  pwhite L.pwhite  pfreelunch L.pfreelunch  mean_clsize_teacher  L.mean_clsize_teacher salary L.salary  mean_non_white_teacher  L.mean_non_white_teacher    mean_read_teacher L.mean_read_teacher   mean_read_school L.mean_read_school   sch_fx_read L.sch_fx_read  sch_fx_math L.sch_fx_math  if ind_moved==1


***************************************************************************************************************************************************************
*   Table 4
***************************************************************************************************************************************************************

use "C:\Users\Bo\Documents\NC Peers\Final_file_JAN09.dta" , clear
duplicates drop teachid year , force
tsset  teachid year
fillin teachid year
egen school_id=group(lea schlcode)

gen move_year=year+1 if school_id!=F.school_id & (F.school_id!=. | F2.school_id!=. |F3.school_id!=. | F4.school_id!=. | F5.school_id!=. | F6.school_id!=. | F7.school_id!=. | F8.school_id!=. |F9.school_id!=. |F10.school_id!=.) 

*this takes the first move in the data.... 
bysort teachid: egen min_move_year=min(move_year)
bysort teachid: egen max_move_year=max(move_year)
gen multiple_mover=  min_move_year!= max_move_year

gen move_year2=year-max_move_year
gen never_mover=max_move_year==. 


forvalues i=0/10 {
gen move_year_`i'= move_year2==`i'
}

forvalues i=1/10 {
gen move_year_m`i'= move_year2==-`i'
}

keep teachid year  move_year* multiple_mover
sort teachid year
save "C:\Users\Bo\Documents\NC Peers\1.dta" , replace


* merge back into to full dataset
use "C:\Users\Bo\Documents\NC Peers\Final_file_JAN09.dta" , clear
sort teachid year
merge m:1 teachid year using "C:\Users\Bo\Documents\NC Peers\1.dta"
egen school_id=group(lea schlcode)
compress
drop  l2_math l2_read teach_fx_m teach_fx_r move_sch move_grade move_any total_move_sch total_move_any total_move_grade tfx_missing_r tfx_missing_m mean_exper mean_exp0 mean_exp3 mean_exp10 mean_exp25 mean_exp4 mean_exp_miss mean_cert mean_adv_deg mean_reg_lic mean_lic_score mean_tfx_r mean_tfx_miss_r  mean_tfx_m mean_tfx_miss_m mean_count peer_tfx_m peer_tfx_r peer_tfx_miss_m peer_tfx_miss_r peer_exp 
drop peer_adv_deg peer_cert peer_lic_score peer_reg_lic peer_exp0 peer_exp3 peer_exp4 peer_exp10 peer_exp25 peer_exp_miss lag_m_peers lag_r_peers lag2_m_peers lag2_r_peers lag_m_peers_miss lag_r_peers_miss lag2_m_peers_miss lag2_r_peers_miss fut_m_peers fut_r_peers fut2_m_peers fut2_r_peers fut_m_peers_miss  fut_r_peers_miss fut2_m_peers_miss fut2_r_peers_miss

gen limeng_miss=limeng==""
replace limeng="M" if limeng==""
replace experience2=99 if experience2==.
xi  i.limeng i.ethnic i.grade i.sex  i.pared i.year i.experience2
egen sch_year=group(lea schlcode year)
drop if math_norm==. & read_norm==.

gen pre_in_data= move_year_m1+ move_year_m2+ move_year_m3+ move_year_m4+ move_year_m5+ move_year_m6+ move_year_m7+ move_year_m8+ move_year_m9+ move_year_m10
bysort teachid: egen switch_in_data=max(pre_in_data)
bysort teachid: egen max_0=max(move_year_0)
bysort teachid: egen max_1=max(move_year_1)
bysort teachid: egen max_2=max(move_year_2)
bysort teachid: egen max_3=max(move_year_3)
bysort teachid: egen max_4=max(move_year_4)
bysort teachid: egen max_5=max(move_year_5)
bysort teachid: egen max_6=max(move_year_6)
bysort teachid: egen max_7=max(move_year_7)
bysort teachid: egen max_8=max(move_year_8)
bysort teachid: egen max_9=max(move_year_9)

bysort teachid: egen max_m9=max(move_year_m9)
bysort teachid: egen max_m8=max(move_year_m8)
bysort teachid: egen max_m7=max(move_year_m7)
bysort teachid: egen max_m6=max(move_year_m6)
bysort teachid: egen max_m5=max(move_year_m5)
bysort teachid: egen max_m4=max(move_year_m4)
bysort teachid: egen max_m3=max(move_year_m3)
bysort teachid: egen max_m2=max(move_year_m2)
bysort teachid: egen max_m1=max(move_year_m1)

compress
save "C:\Users\Bo\Documents\Match FX\endog_moving_reg_file.dta", replace
clear
clear matrix
set mem 3g
use "C:\Users\Bo\Documents\Match FX\endog_moving_reg_file.dta" , clear


**************************** Effects on Math  **********************************

cd "C:\Users\Bo\Desktop\"

*This has indicator for each unique year of expereince, limieted english status, ethnicity, parental education, grade and year ( these are in the _I* )

areg  math_norm  l_math   clsize _I*  s_same r_same   move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2  move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , a(teachid) r cluster(teachid)
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct replace addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)


felsdvreg  math_norm  l_math   clsize _I*  s_same r_same    move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2   move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , i(teachid) j(school_id) p(ts_fx) f(sy_fx) xb(XB)  res(res) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) robust cluster(teachid) 
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct append addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)


felsdvreg  math_norm  l_math   clsize _I*  s_same r_same    move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2   move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , i(teachid) j(sch_year) p(ts_fx) f(sy_fx) xb(XB)  res(res) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) robust cluster(teachid) 
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct append addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)


felsdvreg  m_growth           clsize _I*  s_same r_same    move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2   move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , i(teachid) j(sch_year) p(ts_fx) f(sy_fx) xb(XB)  res(res) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) robust cluster(teachid)
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct append addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)




***************** Effects on reading  ***********************************************


areg  read_norm  l_read   clsize _I*  s_same r_same      move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2   move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , a(teachid) r cluster(teachid)
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct append addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)


felsdvreg  read_norm  l_read   clsize _I*  s_same r_same     move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2   move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , i(teachid) j(school_id) p(ts_fx) f(sy_fx) xb(XB)  res(res) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) robust cluster(teachid)
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct append addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)


felsdvreg  read_norm  l_read   clsize _I*  s_same r_same     move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2   move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , i(teachid) j(sch_year) p(ts_fx) f(sy_fx) xb(XB)  res(res) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) robust cluster(teachid)
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct append addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)


felsdvreg  r_growth           clsize   _I*  s_same r_same    move_year_m10 move_year_m9 move_year_m8 move_year_m7 move_year_m6 move_year_m5 move_year_m4 move_year_m3 move_year_m2   move_year_0 move_year_1 move_year_2  move_year_3 move_year_4 move_year_5 move_year_6 move_year_7 move_year_8 move_year_9  limeng_miss , i(teachid) j(sch_year) p(ts_fx) f(sy_fx) xb(XB)  res(res) mover(mover) mnum(mov_per) group(group_per) pobs(num_obsr) robust cluster(teachid)
testparm move_year_m*
local F1=r(F)
local p1=r(p)
testparm move_year_0 - move_year_9
local F2=r(F)
local p2=r(p)
outreg using mob_1.out , se br 10pct append addstat( Prob pre=0 , `p1' ,   Prob post=0 , `p2' ) adec(5,5)


***************************************************








