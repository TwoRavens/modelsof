clear
set more off 

cd "C:\ExitInnovationPaper\"

use "BaselineData.dta", clear

gen birth_year = year - firm_age79 + 1

sort nui year
by nui: egen min_firm_age79 = min(firm_age79)
replace min_firm_age79 = min_firm_age79 - 1

stset firm_age79, id(nui) failure(firm_exit==1) enter(time min_firm_age79)

xi i.industry2_4 i.year i.region i.add_sh50

*********** Regressions **************

* Table 2: Baseline results on Innovation and Plant Deaths *

* Column 1
xtcloglog firm_exit d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog
mfx, varlist(d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6)

* Column 2 
xtprobit firm_exit d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog
mfx, varlist(d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6)

* Column 3
xtlogit firm_exit d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog
mfx, varlist(d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6)

* Column 4 
xtcloglog firm_exit d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog
mfx, varlist(d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6)

* Column 5 
xtprobit firm_exit d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog
mfx, varlist(d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6)

* Column 6 
xtlogit firm_exit d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog
mfx, varlist(d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6)


*** Table 3: Robustness Results on Innovation and Plant Death

* Column 1 * 
stcox d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=.,  vce(robust) tvc(av_sales1 firm_size multi_plant) texp(ln(firm_age79))

* Table 3: Robustness Results on Innovation and Plant Death *

* Column 2
areg firm_exit d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., absorb(nui) robust cluster(nui)

* Column 3 
streg d_add_any_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini d_sales_ind6 n_herf_6d n2_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., d(weib) vce(robust) frailty(invgaussian)

* Column 4 
clogit surv6  d_add_any_7 crisis_year, group(nui) vce(robust)  
margins, dydx(*) predict(pu0)

 * Column 5 * 
stcox d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=.,  vce(robust) tvc(av_sales1 firm_size multi_plant) texp(ln(firm_age79))

* Column 6
areg firm_exit d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., absorb(nui) robust cluster(nui)

* Column 7 
streg d_inno_mul_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini d_sales_ind6 n_herf_6d n2_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., d(weib) vce(robust) frailty(invgaussian)

* Column 8
clogit surv6  d_inno_mul_7 crisis_year if d_add_any_7 ~=., group(nui) vce(robust)  


** Table 4: Results on Characterization of Innovation and Plant Death 

* Column 1
xtcloglog firm_exit d_add_X_7 d_add_nX_7 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., re nolog

* Column 2
xtcloglog firm_exit d_add_any_7_mul d_add_any_7_sin av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., re nolog

* Column 3
xtcloglog firm_exit d_add7_forM d_add7_nforM av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., re nolog


** Table 5: Results on Diversification, Technical and Market Risk, Innovation and Plant Death 

* Column 1 
xtcloglog firm_exit d_add_any_7_sin d_add_any_7_mul av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., re nolog

* Column 2 
xtcloglog firm_exit _Iadd_sh50_1 _Iadd_sh50_2 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog

* Column 3 * 
xtcloglog firm_exit d_add_prox d_add_nprox av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog

* Column 4
xtcloglog firm_exit inno7_nsin10 inno7_sin10 av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if d_add_any_7 ~=., re nolog

* Column 5
xtcloglog firm_exit inno7_std5_small inno7_std5_big av_sales1 firm_size K_intensity multi_plant firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog


** Table 6: Results on Plant Performance and Innovation 

* Column 1
areg lprod_wind1 d_add_any_7 _Iyear_*, absorb(nui)
 
* Column 2
areg lprod_wind1 d_add_any_7 av_sales1 K_intensity multi_plant firm_size firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_*, absorb(nui)

* Column 3
areg lprod_wind1 d_add_any_7 firm_exit av_sales1 K_intensity multi_plant firm_size firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_*, absorb(nui)

* Column 4 * 
foreach var of varlist lprod_wind1 {
sort nui year
by nui: gen `var'_lag1= `var'[_n-1]
by nui: gen `var'_lag2= `var'[_n-2]
xtivreg `var' d_add_any_7 (`var'_lag1 = `var'_lag2) av_sales1 K_intensity multi_plant firm_size firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_*, fd 
} 

* Column 5
areg profit1_rate_w1 d_add_any_7 _Iyear_*, absorb(nui)

* Column 6
areg profit1_rate_w1 d_add_any_7 av_sales1 K_intensity multi_plant firm_size firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_*, absorb(nui)

* Column 7
areg profit1_rate_w1 d_add_any_7 firm_exit av_sales1 K_intensity multi_plant firm_size firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_*, absorb(nui)

* Column 8 
foreach var of varlist profit1_rate_w1 {
sort nui year
by nui: gen `var'_lag1= `var'[_n-1]
by nui: gen `var'_lag2= `var'[_n-2]
xtivreg `var' d_add_any_7 (`var'_lag1 = `var'_lag2) av_sales1 K_intensity multi_plant firm_size firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_*, fd 
} 

** Figure 7: Results on Diversification, Technical Risk, Innovation and Performance ** 

* Column 1 * 
foreach var of varlist lprod_wind1 {
sort nui year
ivreg d.`var' d.d_add_any_7_sin d.d_add_any_7_mul (d.`var'_lag1 = d.`var'_lag2) d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 
test d.d_add_any_7_sin - d.d_add_any_7_mul = 0 
} 

* Column 2 * 
foreach var of varlist profit1_rate_w1 {
sort nui year
ivreg d.`var' d.d_add_any_7_sin d.d_add_any_7_mul (d.`var'_lag1 = d.`var'_lag2) d.firm_exit d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 
test d.d_add_any_7_sin - d.d_add_any_7_mul = 0 
} 

* Column 3 * 
foreach var of varlist lprod_wind1 {
sort nui year
ivreg d.`var' d._Iadd_sh50_1 d._Iadd_sh50_2 (d.`var'_lag1 = d.`var'_lag2) d.firm_exit d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 
test d._Iadd_sh50_1 - d._Iadd_sh50_2 = 0 
} 

* Column 4 * 
foreach var of varlist profit1_rate_w1 {
sort nui year
ivreg d.`var' d._Iadd_sh50_1 d._Iadd_sh50_2 (d.`var'_lag1 = d.`var'_lag2) d.firm_exit d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 
test d._Iadd_sh50_1 - d._Iadd_sh50_2 = 0 
} 

* Column 5 * 
foreach var of varlist lprod_wind1 {
sort nui year
ivreg d.`var' d.inno7_nsin10 d.inno7_sin10 (d.`var'_lag1 = d.`var'_lag2) d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 
test d.inno7_nsin10 - d.inno7_sin10 = 0 
} 
* Column 6 * 
foreach var of varlist profit1_rate_w1 {
sort nui year
ivreg d.`var' d.inno7_nsin10 d.inno7_sin10 (d.`var'_lag1 = d.`var'_lag2) d.firm_exit d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 
test d.inno7_nsin10 - d.inno7_sin10 = 0 
} 

* Column 7 *
foreach var of varlist lprod_wind1 {
sort nui year
ivreg d.`var' d.inno7_std5_big d.inno7_std5_small (d.`var'_lag1 = d.`var'_lag2) d.firm_exit d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 
test d.inno7_std5_big - d.inno7_std5_small = 0 
} 

* Column 8 * 
foreach var of varlist profit1_rate_w1 {
sort nui year
ivreg d.`var' d.inno7_std5_big d.inno7_std5_small (d.`var'_lag1 = d.`var'_lag2) d.firm_exit d.av_sales1 d.K_intensity d.multi_plant d.firm_size d.firm_size2 d.firm_size_ini d.firm_size_ini2 d.av_sales1_age d.firm_size_age d.multi_plant_age d.d_sales_ind6 d.n2_herf_6d d.n_herf_6d d.inno_ind6 d._Iyear_1998 if d_add_any_7_sin ~=.
test d.inno7_std5_big - d.inno7_std5_small = 0 
} 

** Appendix Table 2: Additional Robustness Results on Innovation and Plant Death 


* Column 1 

** Panel A: Product Innovation
xtcloglog firm_exit d_add_any_7 av_sales1 firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if multi_plant ~= 1 & multi_plant ~=., re nolog

** Panel B: Number of New Products
xtcloglog firm_exit d_inno_mul_7 av_sales1 firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if multi_plant ~= 1 & multi_plant ~=., re nolog

* Column 2 

* Panel A: Product Innovation 
xtcloglog firm_exit d_add_any_7 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if tot_workers2 >= 15 * tot_workers2 ~=., re nolog

* Panel B: Number of New Products
xtcloglog firm_exit d_inno_mul_7 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_* if tot_workers2 >= 15 & tot_workers2 ~=., re nolog
 
 
 * Column 3

* Panel A: Product Innovation 
xtcloglog firm_exit d_add_any_6 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog

* Panel B: Number of New Products 
xtcloglog firm_exit d_inno_mul_6 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog


* Column 4 

* Panel A: Product Innovation 
xtcloglog firm_exit d_add_any_7 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 d_exp lprod d_FDI multi_plant_age av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog

* Panel B: Number of New Products 
xtcloglog firm_exit d_inno_mul_7 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 d_exp lprod d_FDI multi_plant_age av_sales1_age firm_size_age multi_plant_age d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog


* Column 5 

* Panel A: Product Innovation 
xtcloglog firm_exit d_add_any_7 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age av_wage6 ad_sales6 K_intense6 entry_rate6 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog

* Panel B: Number of New Products 
xtcloglog firm_exit d_inno_mul_7 av_sales1 multi_plant firm_size K_intensity firm_size2 firm_size_ini firm_size_ini2 av_sales1_age firm_size_age multi_plant_age av_wage6 ad_sales6 K_intense6 entry_rate6 d_sales_ind6 n2_herf_6d n_herf_6d inno_ind6 _Iyear_* _Iindustry2_* _Iregion_*, re nolog
