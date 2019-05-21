* 
* Historical origins of concentration
* 
* Note: needs mat2txt from SSC


version 14
set seed 132456
set linesize 100

use ../Data/data_P, clear
sort statefip cd congress
keep if inlist(congress, 109, 110, 111, 112)
drop if congress==112 & statefip==39 & cd==8  
merge m:1 statefip using ../Data/stateHistory
keep if _merge==3
drop _merge
replace H_slavery1860 = H_slavery1860/100

* global y  = "P_dwnom1"     
global uc = "U_membcr4"    
global P = "H_rtwshyrs H_collshyrs" 

collapse U_membcr4 H_rtwshyrs H_collshyrs H_slavery1860 U_pref1_w U_pref2_w A_Nfirms A_empl_dispersion A_median_income A_BA_or_higher A_service A_agricult A_urban A_black, by(statefip cd)

* U_pref1_w: share favoring SEVERAL unions  => anti-concentration
* U_pref2_w: share favoring mililary end to strikes  => anti-union

egen U_pref1_wz = std(U_pref1_w)
egen U_pref2_wz = std(U_pref2_w)
egen A_empl_dispersionz = std(A_empl_dispersion)


* (1) No controls
xtset statefip
xtreg $uc c.U_pref1_wz##c.A_empl_dispersionz c.U_pref2_wz##c.A_empl_dispersionz, vce(robust)
est sto m1

* (2) Slavery 
xtreg $uc c.U_pref1_wz##c.A_empl_dispersionz c.U_pref2_wz##c.A_empl_dispersionz H_slavery1860, vce(robust)
est sto m2

* Slavery + Policy
xtreg $uc c.U_pref1_wz##c.A_empl_dispersionz c.U_pref2_wz##c.A_empl_dispersionz  H_slavery1860 $P, vce(robust)
est sto m3

*  Slavery + Policy + N_firm
xtreg $uc c.U_pref1_wz##c.A_empl_dispersionz c.U_pref2_wz##c.A_empl_dispersionz A_Nfirms H_slavery1860 $P, vce(robust)
est sto m4

* Covariates 2 factors explaining 74\% of var
fac A_median_income A_BA_or_higher A_service A_agricult A_urban A_black, ipf
fac A_median_income A_BA_or_higher A_service A_urban A_black, fac(1) ipf
predict f1
xtreg $uc c.U_pref1_wz##c.A_empl_dispersionz c.U_pref2_wz##c.A_empl_dispersionz A_Nfirms H_slavery1860 $P f1, vce(robust)
est sto m5

* Table
esttab m1 m2 m3 m4 m5, nostar bracket b(%5.3f) se(%5.3f) keep( c.U_pref1_wz#c.A_empl_dispersionz U_pref1_wz U_pref2_wz c.U_pref2_wz#c.A_empl_dispersionz A_empl_dispersionz) varwidth(20)


* Save mfx for plot
est restore m4
margins, dydx(A_empl_dispersionz) at(U_pref1_wz = (-2 (0.1) 2))
mat B = r(table)
mat B = B'
mat2txt, matrix(B) saving(Figure_A_4_2_plotdata1.tab) replace
margins, dydx(A_empl_dispersionz) at(U_pref2_wz = (-2 (0.1) 2))
mat B = r(table)
mat B = B'
mat2txt, matrix(B) saving(Figure_A_4_2_plotdata2.tab) replace

* save estimation data for gallup variables (used to plot density)
keep U_pref?_wz
export delim "Figure_A_4_2_plotdataX.tab", delim(tab)

