set mem 1700m
set matsize 800

* STATA file converted from SAS (in teacher/merged directory)

use "'your directory'\both_feb08.dta", clear

**** Replace the above filename with the converted SAS datafile   merged.both_FEB08  *****

bysort lea schlcode grade year fiscmm crsnum secnum subjct acadlvl sccgrd subjlen semstr2: gen clsize=_N
replace clsize=35 if clsize>=35
egen class=group(lea schlcode grade year fiscmm crsnum secnum subjct acadlvl sccgrd subjlen semstr2)


sort mastid year grade
duplicates drop mastid year , force

tsset mastid year

gen l_math=L.math_norm
gen l2_math=L2.math_norm
gen l_read=L.read_norm
gen l2_read=L2.read_norm

*Drop observations with no lagged values (in both reading and math)

drop if l_math==. & l2_math==. & l_read==. & l2_read==.

gen m_growth=math_norm-l_math
gen r_growth=read_norm-l_read

******************************************************************
*
*	Clean the teacher variables
*
******************************************************************


gen adv_deg=0
replace  adv_deg=1 if cls_lvl_desc=="DOCTOR'S DEGREE" | cls_lvl_desc=="MASTER'S DEGREE" | cls_lvl_desc=="NON_STANDARD MASTERS" | cls_lvl_desc=="SIXTH YEAR (ADVANCED)"

gen reg_lic=0
replace reg_lic=1 if pgm_sts_desc=="CONTINUING"

replace certified=0 if certified==.

gen exp_0=0
replace exp_0=1 if experience2==0 

gen exp_3=0
replace exp_3=1 if experience2>=1 & experience2<=3 & experience2!=.

gen exp_4=0
replace exp_4=1 if experience2>=4 & experience2<=9 & experience2!=.

gen exp_10=0
replace exp_10=1 if experience2>=10 & experience2<=24 & experience2!=.

gen exp_25=0
replace exp_25=1 if experience2>24 & experience2!=.

gen exp_missing=0
replace exp_missing=1 if experience2==. 

gen lic_score=mean_norm_score
replace lic_score=0 if lic_score==. 

drop cls_lvl_desc pgm_sts_desc certificate

egen s_s=group(lea schlcode)
egen t_s=group(teachid lea schlcode)
egen t_s_g=group(teachid lea schlcode grade)
egen s_s2=group(lea schlcode mastid)

gen s_same=0
replace s_same=1 if sex==tch_sex
gen r_same=0
replace r_same=1 if ethnic==tch_eth

drop if grade==""
drop if mastid==.

drop  testdt mean_math sd_math mean_read sd_read fiscmm crsnum secnum subjct acadlvl sccgrd subjlen semstr2 

****************************************************************************************

save "'your directory'\temp\basic_Jan09.dta", replace

****************************************************************************************

**********************************************************************
*
*	Compute teacher quality   [ teach_fx_r and teach_fx_m]
*
**********************************************************************

*Need to merge in CCD data

*use "'your directory'\temp\basic_Jan09.dta", clear
sort lea  schlcode year
merge lea schlcode year using "'your directory'\ccd.dta", uniqusing
drop if _merge==2
drop _merge

*************

* Estimate teacher effects

*************

drop if year>2000
*using only data from 1995 through 2000

*Compute the Instrumental Variables adjustd teacher Effects

xi: felsdvreg l_math l2_math i.grade i.sex i.ethnic  i.pared  r_same s_same clsize  exp_missing exp_3  exp_4 exp_10 exp_25  pblack pwhite phisp pfreelunch pfreelunch_miss ln_enrol i.locale, ivar(teachid) jvar(year)  f(year_fx_m) p(teach_fx_m) m(mover_m) g(group_m) xb(xb_m) r(res_m) mnum(mnum_m) pobs(top_m)    
predict l_math_hat , xb

xi: felsdvreg l_read l2_read i.grade i.sex i.ethnic  i.pared  r_same s_same clsize  exp_missing exp_3  exp_4 exp_10 exp_25  pblack pwhite phisp pfreelunch pfreelunch_miss ln_enrol i.locale, ivar(teachid) jvar(year)  f(year_fx_r) p(teach_fx_r) m(mover_r) g(group_r) xb(xb_r) r(res_r) mnum(mnum_r) pobs(top_r)
predict l_read_hat , xb


xi: felsdvreg m_growth l_math_hat  i.grade i.sex i.ethnic  i.pared  r_same s_same clsize  exp_missing exp_3  exp_4 exp_10 exp_25   pblack pwhite phisp pfreelunch pfreelunch_miss ln_enrol i.locale, ivar(teachid) jvar(year)  f(year_fx_m) p(teach_fx_m) m(mover_m) g(group_m) xb(xb_m) r(res_m) mnum(mnum_m) pobs(top_m)    
local a=_b[l_math_hat]
xi: felsdvreg r_growth l_read_hat  i.grade i.sex i.ethnic  i.pared  r_same s_same clsize  exp_missing exp_3  exp_4 exp_10 exp_25   pblack pwhite phisp pfreelunch pfreelunch_miss ln_enrol i.locale, ivar(teachid) jvar(year)  f(year_fx_r) p(teach_fx_r) m(mover_r) g(group_r) xb(xb_r) r(res_r) mnum(mnum_r) pobs(top_r)
local b=_b[l_read_hat]

gen m_growth2=math_norm-(1-`a')*l_math
gen r_growth2=read_norm-(1-`b')*l_read


xi: felsdvreg m_growth2   i.grade i.sex i.ethnic  i.pared  r_same s_same clsize  exp_missing exp_3  exp_4 exp_10 exp_25  pblack pwhite phisp pfreelunch pfreelunch_miss ln_enrol i.locale , ivar(teachid) jvar(year)  f(year_fx_m) p(teach_fx_m) m(mover_m) g(group_m) xb(xb_m) r(res_m) mnum(mnum_m) pobs(top_m)    
outreg using "NEWFX.out" , br se 10pct replace
xi: felsdvreg r_growth2   i.grade i.sex i.ethnic  i.pared  r_same s_same clsize  exp_missing exp_3  exp_4 exp_10 exp_25  pblack pwhite phisp pfreelunch pfreelunch_miss ln_enrol i.locale , ivar(teachid) jvar(year)  f(year_fx_r) p(teach_fx_r) m(mover_r) g(group_r) xb(xb_r) r(res_r) mnum(mnum_r) pobs(top_r)
outreg using "NEWFX.out" , br se 10pct append


duplicates drop teachid , force
keep teachid teach_fx_m teach_fx_r 

egen mfx_mean=mean(teach_fx_m)
egen mfx_sd=sd(teach_fx_m)
egen rfx_mean=mean(teach_fx_r)
egen rfx_sd=sd(teach_fx_r)

replace teach_fx_m=(teach_fx_m-mfx_mean)/mfx_sd
replace teach_fx_r=(teach_fx_r-rfx_mean)/rfx_sd

keep teachid teach_fx_m teach_fx_r 
sort teachid
save "'your directory'\temp\FX_Jan09.dta" , replace


**************************************************************************
*
*	Merge in the teacher FX and compute peer variables  (missing equals zero then include dummy)
*
**************************************************************************
cd "'your directory'\temp\"

use "'your directory'\temp\basic_Jan09.dta", clear
duplicates drop teachid year , force
destring schlcode grade , force replace
tsset teachid year
gen l_school=L.schlcode
gen l_grade=L.grade

gen move_sch=l_school!=schlcode
gen move_grade=move_sch==0 & l_grade!=grade
gen move_any=max(move_sch, move_grade)

keep teachid lea schlcode grade year move_*
sort teachid year
save "temp_a" , replace
bysort year lea schlcode grade: egen total_move_sch=total(move_sch)
bysort year lea schlcode grade: egen total_move_any=total(move_any)
bysort year lea schlcode grade: egen total_move_grade=total(move_grade)
duplicates drop lea schlcode grade year  , force
sort lea schlcode grade year
keep lea schlcode grade year total_*
save temp_b , replace

use "temp_a", clear
sort lea schlcode grade year
merge lea schlcode grade year using "temp_b" , uniqusing
drop _merge
tostring  schlcode grade, replace
sort teachid lea schlcode grade year
save "mobile.dta" , replace


use "'your directory'\temp\Basic_Jan09.dta", clear
sort teachid
merge teachid using "'your directory'\temp\FX_Jan09.dta" , uniqusing
drop if _merge==2
drop _merge
sort teachid lea schlcode grade year
merge teachid lea schlcode grade year using "mobile.dta" , uniqusing
drop _merge


gen tfx_missing_r=0
replace tfx_missing_r=1 if teach_fx_r==.
replace teach_fx_r=0 if teach_fx_r==.

gen tfx_missing_m=0
replace tfx_missing_m=1 if teach_fx_m==.
replace teach_fx_m=0 if teach_fx_m==.

save  "temp1.dta", replace

*  Create the mean teacher characteristics for teachers

duplicates drop teachid year grade lea schlcode , force

bysort grade year lea schlcode: egen mean_exper=mean(experience2)
bysort grade year lea schlcode: egen mean_exp0=mean(exp_0)
bysort grade year lea schlcode: egen mean_exp3=mean(exp_3)
bysort grade year lea schlcode: egen mean_exp10=mean(exp_10)
bysort grade year lea schlcode: egen mean_exp25=mean(exp_25)
bysort grade year lea schlcode: egen mean_exp4=mean(exp_4)
bysort grade year lea schlcode: egen mean_exp_miss=mean(exp_missing)
bysort grade year lea schlcode: egen mean_cert=mean(certified)
bysort grade year lea schlcode: egen mean_adv_deg=mean(adv_deg)
bysort grade year lea schlcode: egen mean_reg_lic=mean(reg_lic)
bysort grade year lea schlcode: egen mean_lic_score=mean(lic_score)

bysort grade year lea schlcode: egen mean_tfx_r=mean(teach_fx_r)
bysort grade year lea schlcode: egen mean_tfx_miss_r=mean(tfx_missing_r)
bysort grade year lea schlcode: egen mean_tfx_m=mean(teach_fx_m)
bysort grade year lea schlcode: egen mean_tfx_miss_m=mean(tfx_missing_m)

bysort grade year lea schlcode: gen mean_count=_N
keep  lea schlcode grade year mean_* move_grade move_sch move_any total_* move_*

duplicates drop year grade lea schlcode , force
sort  year grade lea schlcode 

****************************************************************************************

save "teacher_means.dta", replace

****************************************************************************************

use  "temp1.dta", clear
sort  year grade lea schlcode  
merge  year grade lea schlcode using "teacher_means.dta", uniqusing
drop _merge

gen  peer_tfx_m= (mean_count/(mean_count-1))*(mean_tfx_m- teach_fx_m/mean_count)
gen  peer_tfx_r= (mean_count/(mean_count-1))*(mean_tfx_r- teach_fx_r/mean_count)

gen  peer_tfx_miss_m= (mean_count/(mean_count-1))*(mean_tfx_miss_m- tfx_missing_m/mean_count)
gen  peer_tfx_miss_r= (mean_count/(mean_count-1))*(mean_tfx_miss_r- tfx_missing_r/mean_count)

gen  peer_exp= (mean_count/(mean_count-1))*[mean_exper - (experience2/mean_count)]
gen  peer_adv_deg= (mean_count/(mean_count-1))*(mean_adv_deg- adv_deg/mean_count)
gen  peer_cert= (mean_count/(mean_count-1))*(mean_cert- certified/mean_count)
gen  peer_lic_score= (mean_count/(mean_count-1))*(mean_lic_score- lic_score/mean_count)
gen  peer_reg_lic= (mean_count/(mean_count-1))*(mean_reg_lic- reg_lic/mean_count)

gen  peer_exp0= (mean_count/(mean_count-1))*(mean_exp0- exp_0/mean_count)
gen  peer_exp3= (mean_count/(mean_count-1))*(mean_exp3- exp_3/mean_count)
gen  peer_exp4= (mean_count/(mean_count-1))*(mean_exp4- exp_4/mean_count)
gen  peer_exp10= (mean_count/(mean_count-1))*(mean_exp10- exp_10/mean_count)
gen  peer_exp25= (mean_count/(mean_count-1))*(mean_exp25- exp_25/mean_count)
gen  peer_exp_miss= (mean_count/(mean_count-1))*(mean_exp_miss- exp_missing/mean_count)

save "reg_file_Jan09.dta", replace


******************************************************************************************
*
*	CREATE LAGGED PEER VARIABLES
*
******************************************************************************************

*use "reg_file_Jan09.dta", clear

duplicates drop lea schlcode teachid grade year , force

sort lea schlcode teachid grade year
keep lea schlcode teachid grade year peer_tfx_m  peer_tfx_miss_m  peer_tfx_r  peer_tfx_miss_r
egen t_s_g2= group (lea schlcode teachid grade)
tsset t_s_g2 year

* Use lag in the same grade.... if this is missing then use other grade!
 
gen lag_m_peers_test=L.peer_tfx_m
gen lag2_m_peers_test=L2.peer_tfx_m
gen lag_m_peers_miss_test=L1.peer_tfx_miss_m
gen lag2_m_peers_miss_test=L2.peer_tfx_miss_m

gen lag_r_peers_test=L.peer_tfx_r
gen lag2_r_peers_test=L2.peer_tfx_r
gen lag_r_peers_miss_test=L1.peer_tfx_miss_r
gen lag2_r_peers_miss_test=L2.peer_tfx_miss_r


*Fill in other grade lags

sort lea schlcode teachid grade year

forvalues i = 1(1)7 {
replace lag_m_peers_test= peer_tfx_m[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+1 & lag_m_peers_test==.
replace lag_r_peers_test= peer_tfx_r[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+1 & lag_r_peers_test==.
replace lag2_m_peers_test= peer_tfx_m[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+2 & lag2_m_peers_test==.
replace lag2_r_peers_test= peer_tfx_r[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+2 & lag2_r_peers_test==.
replace lag_m_peers_miss_test= peer_tfx_miss_m[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+1 & lag_m_peers_miss_test==.
replace lag_r_peers_miss_test= peer_tfx_miss_r[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+1 & lag_r_peers_miss_test==.
replace lag2_m_peers_miss_test= peer_tfx_miss_m[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+2 & lag2_m_peers_miss_test==.
replace lag2_r_peers_miss_test= peer_tfx_miss_r[_n-`i']  if lea==lea[_n-`i'] & schlcode==schlcode[_n-`i'] & teachid==teachid[_n-`i'] & year==year[_n-`i']+2 & lag2_r_peers_miss_test==.
}

* For observations with multiple grades I use the max of the second lag above as the variable!

bysort lea schlcode teachid year : egen  lag_m_peers=max(lag_m_peers_test)
replace lag_m_peers=lag_m_peers_test if lag_m_peers_test!=.
bysort lea schlcode teachid year : egen  lag_r_peers=max(lag_r_peers_test)
replace lag_r_peers=lag_r_peers_test if lag_r_peers_test!=.
bysort lea schlcode teachid year : egen  lag2_m_peers=max(lag2_m_peers_test)
replace lag2_m_peers=lag2_m_peers_test if lag2_m_peers_test!=.
bysort lea schlcode teachid year : egen  lag2_r_peers=max(lag2_r_peers_test)
replace lag2_r_peers=lag2_r_peers_test if lag2_r_peers_test!=.
bysort lea schlcode teachid year : egen  lag_m_peers_miss=max(lag_m_peers_miss_test)
replace lag_m_peers_miss=lag_m_peers_miss_test if lag_m_peers_miss_test!=.
bysort lea schlcode teachid year : egen  lag_r_peers_miss=max(lag_r_peers_miss_test)
replace lag_r_peers_miss=lag_r_peers_miss_test if lag_r_peers_miss_test!=.
bysort lea schlcode teachid year : egen  lag2_m_peers_miss=max(lag2_m_peers_miss_test)
replace lag2_m_peers_miss=lag2_m_peers_miss_test if lag2_m_peers_miss_test!=.
bysort lea schlcode teachid year : egen  lag2_r_peers_miss=max(lag2_r_peers_miss_test)
replace lag2_r_peers_miss=lag2_r_peers_miss_test if lag2_r_peers_miss_test!=.

keep lea schlcode teachid grade year  lag_m_peers lag2_m_peers lag_m_peers_miss lag2_m_peers_miss lag_r_peers lag2_r_peers lag_r_peers_miss lag2_r_peers_miss
sort lea schlcode teachid grade year
save "lagged_peers_jan09.dta", replace

*****************************************************************************************


******************************************************************************************
*
*	CREATE Future PEER VARIABLES
*
******************************************************************************************

use "reg_file_Jan09.dta", clear

duplicates drop lea schlcode teachid grade year , force

sort lea schlcode teachid grade year
keep lea schlcode teachid grade year peer_tfx_m  peer_tfx_miss_m  peer_tfx_r  peer_tfx_miss_r
egen t_s_g2= group (lea schlcode teachid grade)
tsset t_s_g2 year

* Use lag in the same grade.... if this is missing then use other grade!
 
gen t_fut_m_peers_test=F.peer_tfx_m
gen t_fut2_m_peers_test=F2.peer_tfx_m
gen t_fut_m_peers_miss_test=F1.peer_tfx_miss_m
gen t_fut2_m_peers_miss_test=F2.peer_tfx_miss_m

gen t_fut_r_peers_test=F.peer_tfx_r
gen t_fut2_r_peers_test=F2.peer_tfx_r
gen t_fut_r_peers_miss_test=F1.peer_tfx_miss_r
gen t_fut2_r_peers_miss_test=F2.peer_tfx_miss_r

*Fill in other grade lags

forvalues i = 1(1)7{
	replace t_fut_m_peers_test= peer_tfx_m[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-1 & t_fut_m_peers_test==.
	replace t_fut_r_peers_test= peer_tfx_r[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-1 & t_fut_r_peers_test==.
	replace t_fut2_m_peers_test= peer_tfx_m[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-2 & t_fut2_m_peers_test==.
	replace t_fut2_r_peers_test= peer_tfx_r[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-2 & t_fut2_r_peers_test==.
	replace t_fut_m_peers_miss_test= peer_tfx_miss_m[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-1 & t_fut_m_peers_miss_test==.	
	replace t_fut_r_peers_miss_test= peer_tfx_miss_r[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-1 & t_fut_r_peers_miss_test==.
	replace t_fut2_m_peers_miss_test= peer_tfx_miss_m[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-2 & t_fut2_m_peers_miss_test==.
	replace t_fut2_r_peers_miss_test= peer_tfx_miss_r[_n+`i']  if lea==lea[_n+`i'] & schlcode==schlcode[_n+`i'] & teachid==teachid[_n+`i'] & year==year[_n+`i']-2 & t_fut2_r_peers_miss_test==.
}


bysort lea schlcode teachid year : egen  fut_m_peers=max(t_fut_m_peers_test)
replace fut_m_peers=t_fut_m_peers_test if t_fut_m_peers_test!=.
bysort lea schlcode teachid year : egen  fut_r_peers=max(t_fut_r_peers_test)
replace fut_r_peers=t_fut_r_peers_test if t_fut_r_peers_test!=.
bysort lea schlcode teachid year : egen  fut2_m_peers=max(t_fut2_m_peers_test)
replace fut2_m_peers=t_fut2_m_peers_test if t_fut2_m_peers_test!=.
bysort lea schlcode teachid year : egen  fut2_r_peers=max(t_fut2_r_peers_test)
replace fut2_r_peers=t_fut2_r_peers_test if t_fut2_r_peers_test!=.
bysort lea schlcode teachid year : egen  fut_m_peers_miss=max(t_fut_m_peers_miss_test)
replace fut_m_peers_miss=t_fut_m_peers_miss_test if t_fut_m_peers_miss_test!=.
bysort lea schlcode teachid year : egen  fut_r_peers_miss=max(t_fut_r_peers_miss_test)
replace fut_r_peers_miss=t_fut_r_peers_miss_test if t_fut_r_peers_miss_test!=.
bysort lea schlcode teachid year : egen  fut2_m_peers_miss=max(t_fut2_m_peers_miss_test)
replace fut2_m_peers_miss=t_fut2_m_peers_miss_test if t_fut2_m_peers_miss_test!=.
bysort lea schlcode teachid year : egen  fut2_r_peers_miss=max(t_fut2_r_peers_miss_test)
replace fut2_r_peers_miss=t_fut2_r_peers_miss_test if t_fut2_r_peers_miss_test!=.


keep lea schlcode teachid grade year fut_m_peers fut2_m_peers fut_m_peers_miss fut2_m_peers_miss fut_r_peers fut2_r_peers fut_r_peers_miss fut2_r_peers_miss
sort lea schlcode teachid grade year

save "future_peers_Jan09.dta" , replace

*********************************************************************************

use "reg_file_Jan09.dta" , clear
sort lea schlcode teachid grade year
merge lea schlcode teachid grade year using "lagged_peers_jan09.dta" , uniqusing
drop _merge
sort lea schlcode teachid grade year
merge lea schlcode teachid grade year using "future_peers_jan09.dta" , uniqusing
drop _merge

duplicates drop mastid year, force
tsset mastid year
compress
save "'your directory'\Final_file_JAN09.dta" , replace

*********************************************************************************

