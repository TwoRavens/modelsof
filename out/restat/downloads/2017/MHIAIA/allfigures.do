** Replication of all figures in the paper

******************** Create figure 1

use "$datatemp/rosstat_allvars.dta", clear
keep if Year>=1975 & Year<=1988
collapse (sum) numbir numwomen_1544, by(loc Year)
gen gfr_official = numbir*1000/numwomen_1544
keep gfr_official Year loc
reshape wide gfr_official, i(Year) j(loc)
rename gfr_official1 gfr_early
rename gfr_official2 gfr_late

******************** Create figure 2
set more off
use "$datatemp/rosstat_allvars.dta", clear
gen numwom1 = numwomen_1544 if Year==1979
bysort Birthplace_code: egen numwomen_79=max(numwom1)

gen treat = (loc==1)
local r replace
char Year[omit] 1980
xi i.Year*treat i.Birthplace_code 
* With year and oblast fixed effects
regress gfr_official _IYeaX*  _IYear* _IBirthplac* if Year>=1975 & Year<=1986 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 using "$output/figure2.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')
local r append

* With co-variates at the year and oblast level
regress gfr_official _IYeaX*  _IYear* _IBirthplac* concrete brick meat timber canned trade if Year>=1975 & Year<=1986 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 using "$output/figure2.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')

**************** Create figure 3
set more off
use "$datatemp/gfr_adjusted.dta", clear
set matsize 5000
sort Birthplace Year
merge (Birthplace Year) using "$datatemp/covars_oblast.dta"
keep if _merge==3

gen datemnth_num = ym(Year, Birthmonth)
gen loc1 = (loc==1)
gen mnth_ind = datemnth_num
keep if Year>=1978 & Year<=1983
* Omits 1978
replace mnth_ind = 0 if datemnth_num<=227
local r replace
xi i.mnth_ind*loc1 i.Birthplace_code i.Birthmonth*i.Birthplace_code
regress gfr_2002_adj _ImntXloc* _Imnth_ind* _IBirthplac* _IBirXBir* _IBirthmont* concrete brick timber trade meat canned if Year>=1978 & Year<=1983 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 using "$output/figure3.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')

************** Create figure 4
set more off
use "$datatemp/rosstat_allvars.dta", clear
gen numwom1 = numwomen_1544 if Year==1979
bysort Birthplace_code: egen numwomen_79=max(numwom1)

gen treat1 = 1980 if loc==1
replace treat1 = 1981 if loc==2
gen Texp1 = Year-treat1
local r replace
char Texp1[omit] 0 
xi i.Year i.Texp1 i.Birthplace_code
regress gfr_official _ITexp* _IYear* _IBirthplac* meat canned trade if Year>=1976 & Year<=1992 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 using "$output/figure4.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')


************** Create figure 5
set more off
use "$datatemp/rosstat_allvars.dta", clear
gen numwom1 = numwomen_1544 if Year==1979
bysort Birthplace_code: egen numwomen_79=max(numwom1)

gen numwom_rur79=women_rur_79*100/(women_rur_79+women_urb_79)
gen lths_per = (elem+hs_inc)*100/(elem+hs_inc+College+College_inc+hs_spec+hs_gen)

gen treat2 = 1980 if loc==1
replace treat2 = 1981 if loc==2
gen Texp2 = Year-treat2
local r replace
char Texp2[omit] 0 
xi i.Texp2*numwom_rur79 i.Year i.Birthplace_code 
* Panel A
regress gfr_official  _ITexXnum*  numwom_rur79 trade meat canned _IYear* _IBirthplac* if Year>=1976 & Year<=1992 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 using "$output/figure5.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')
local r append
xi i.Texp2*lths_per i.Year i.Birthplace_code
* Panel B
regress gfr_official  _ITexXlth*  lths_per _IYear* _IBirthplac* trade meat canned if Year>=1976 & Year<=1992 [w=numwomen_79], vce(cluster Birthplace_code)
outreg2 using "$output/figure5.xls", `r' addstat(Num oblasts, e(N_clust)) addtext(Name, "`var'") bracket noaster ctitle(`e(cmdline)')

************** Create figure B3
** Russia
set obs 10000000
gen a = 6.19+1.031*rnormal()
gen c = 90+9*rnormal()
gen e_rus = (a/75.95)/(((c*12*18-425)-(c*12*18))/(c*12*18)*(-1))
* The elasticity estimate
sum e_rus
* Confidence Interval
centile e_rus, centile(2.5, 97.5)

** Austria
gen a1 = 0.068+0.012*rnormal()
* make the se as 5 percent of the value
gen c1 = 389+19.2*rnormal()
gen e_aus = (a1/0.32)/(((c1*18*12-4080)-(c1*18*12))/(c1*18*12)*(-1))
* The elasticity estimate
sum e_aus
* Confidence Interval
centile e_aus, centile(2.5, 97.5)

** Canada
gen a2 = .039+.007*rnormal()
gen c2_a = 7935+396.75*rnormal()
gen c2_b = 6348+317.4*rnormal()
gen c2_c = 5324+266.25*rnormal()
gen c2 = (500/(c2_a*18))*.45+(1000/(c2_b*18))*.35+(8000/(c2_c*18))*.2
gen e_can = (a2/.45)/c2
* The elasticity estimate
sum e_can
* Confidence Interval
centile e_can, centile(2.5, 97.5)

** Spain
gen a3 = .0634+.0115*rnormal()
gen c3 = 150000+7500*rnormal()
gen e_spa = a3/(2500/c3)
* The elasticity estimate
sum e_spa
* Confidence Interval
centile e_spa, centile(2.5, 97.5)

