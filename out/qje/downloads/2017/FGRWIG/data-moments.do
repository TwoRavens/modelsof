
***********************************************************************
*** Table IV - Panel B: Within Firm Moments
***********************************************************************
* log TFP: TFP_WLP

* 1. Model B
gen B_model=LIAB-(TOTASSTS-TGINTGFIXEDASSETS)
gen net_worth_model=TGINTGFIXEDASSETS-B_model
* 2. Short-term B
gen B_st=CURRENTLIAB-CASH
gen net_worthBst=TGINTGFIXEDASSETS-B_st


local varlist B_model B_st net_worth_model net_worthBst
foreach var of local varlist {
tempvar temph templ 
_pctile `var', percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace `var'=`templ' if `var'<`templ' & `var'!=. 
replace `var'=`temph' if `var'>`temph' & `var'!=. 
}

gen ln_NW_model=ln(net_worth_model)

* generate lag values
xtset id YEAR
sort id YEAR
local varlist B_st ln_NW_model TFP
foreach var of local varlist{
by id:gen lag`var'=L.`var'
}

* Investment
gen K=TGINTGFIXEDASSET
by id:gen lagK=L.K
gen inv=K-lagK
gen inv_lagK=inv/lagK

gen log_lagK= ln(lagK)

tempvar temph templ 
_pctile inv_lagK, percentiles(2 98)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace inv_lagK=`templ' if inv_lagK<`templ' & inv_lagK!=.
replace inv_lagK=`temph' if inv_lagK>`temph' & inv_lagK!=. 

* Debt 
gen delta_debt=B_st-lagB_st
gen delta_debt_lagK=delta_debt/lagK

tempvar temph templ 
_pctile delta_debt_lagK, percentiles(2 98)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace delta_debt_lagK=`templ' if delta_debt_lagK<`templ' & delta_debt_lagK!=.
replace delta_debt_lagK=`temph' if delta_debt_lagK>`temph' & delta_debt_lagK!=. 


** Regressions
set more off
* Investment
reghdfe inv_lagK lagTFP lagln_NW_model log_lagK  , tolerance(1e-5) absorb(id YEAR#sec4 YEAR sec4 ) vce(cluster id)
estimates store m1
estadd local yearfix "yes",replace
estadd local firmfix "yes",replace
estadd local secyearfix "yes",replace	
* Debt
reghdfe inv_lagK lagTFP lagln_NW_model log_lagK  , tolerance(1e-5) absorb(id YEAR#sec4 YEAR sec4 ) vce(cluster id)
estimates store m2
estadd local yearfix "yes",replace
estadd local firmfix "yes",replace
estadd local secyearfix "yes",replace	


esttab   m1 m2  using reg_investment_debt.csv, ///
          cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
          drop(_cons ) stats(N r2 year firmfix secyearfix, fmt(%9.0g %9.2g) ///
		  labels(Obs. R$^2$ "Year FE" "Firm FE" "Sector-Year FE")) /// 
          starlevel(* 0.10 ** 0.05 *** 0.001)    ///
          title("`var'") replace	

		  
***********************************************************************
*** Table IV - Panel C: Cross Section Moments
***********************************************************************
*** Row: 13 (Leverage Coefficient)
***********************************************************************		  
gen lev_model_st=B_st/K

gen otherLT=B_model-B_st
gen otherLT_K=otherLT/K

local varlist lev_model_st otherLT_K
foreach var of local varlist{
tempvar temph templ 
_pctile `var', percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace `var'=`templ' if `var'<`templ' & `var'!=. 
replace `var'=`temph' if `var'>`temph' & `var'!=. 
}

gen logK=ln(K)
gen ln_age=ln(age)

reghdfe lev_model_st otherLT_K logK ln_age , tolerance(1e-5) absorb(sec4 YEAR YEAR#sec4) vce(cluster id)
estimates store m1
estadd local yearfix "yes",replace
estadd local secyearfix "yes",replace
estadd local firmfix "no",replace

esttab   m1  using reg_leverage.csv, ///
          cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
           drop(_cons ) stats(N r2 yearfix firmfix secyearfix, fmt(%9.0g %9.2g) ///
		  labels(Obs. R$^2$ "Year FE" "Firm FE" "Sector-Year FE")) /// 
          starlevel(* 0.10 ** 0.05 *** 0.001)    ///
          title("`var'") replace

***********************************************************************
*** Rows: 14-18 Cross-Sectional Moments
***********************************************************************	
**** MRPL and MRPK
gen VA_nominal=VA*PPI_manuf
gen mrpl=((1-alpha)/mu)*(VA_nominal/COSTEMPL)
gen mrpk=(alpha/mu)*(VA_nominal/TGINTGFIXEDASSETS)

**** Winsorize
local varlist mrpk mrpl
foreach var of local varlist{
tempvar temph templ 
_pctile `var', percentiles(0.1 99.9)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace `var'=`templ' if `var'<`templ' & `var'!=. 
replace `var'=`temph' if `var'>`temph' & `var'!=. 
}
 

**** Take logs
gen ln_mrpk=ln(mrpk)
gen ln_mrpl=ln(mrpl)

	 
bys NACEREV2CCODE YEAR: egen corr_logZ_logK = corr(TFP_WLP logK)
bys NACEREV2CCODE YEAR: egen corr_logZ_loga = corr(TFP_WLP ln_NW_model)

bys NACEREV2CCODE YEAR: egen corr_logMRPK_logZ = corr(ln_mrpk TFP_WLP)
bys NACEREV2CCODE YEAR: egen corr_logMRPK_logK = corr(ln_mrpk logK)
bys NACEREV2CCODE YEAR: egen corr_logMRPK_loga = corr(ln_mrpk ln_NW_model)
		  
***********************************************************************
*** Table IV - Panel A: 1-5 Distributional Moments
***********************************************************************	
** Rows 1 to 3: Dispersion
preserve
gen logL=ln(COSTEMPL)
bys NACEREV2CCODE YEAR: egen sd_logZ = sd(TFP_WLP)
bys NACEREV2CCODE YEAR: egen sd_logL = sd(logL)
bys NACEREV2CCODE YEAR: egen sd_logK = sd(logK)


**** Sectoral weights
bys YEAR NACEREV2CCODE:egen sector_VA=sum(VA)
bys YEAR:egen total_VA=sum(VA)
gen weight_sec=sector_VA/total_VA

bys NACEREV2CCODE YEAR:gen counsecyear=_n
gen secyear=1 if counsecyear==1
bys NACEREV2CCODE:gen counsec=_n
gen sec=1 if counsec==1
bys NACEREV2CCODE:egen mean_weight_sec=mean(weight_sec) if secyear==1
bys NACEREV2CCODE:egen maxmean_weight_sec=max(mean_weight_sec)
drop mean_weight_sec

rename maxmean_weight_sec mean_weight_sec 
egen sum_mean_weight_sec=sum(mean_weight_sec) if sec==1
gen final_mean_weight_sec=mean_weight_sec/sum_mean_weight_sec
bys NACEREV2CCODE:egen maxfinal_mean_weight_sec=max(final_mean_weight_sec)
drop secyear sec mean_weight_sec counsecyear counsec sum_mean_weight_sec mean_weight_sec
rename maxfinal_mean_weight_sec mean_weight_sec


collapse sd_*  [aw=mean_weight_sec], by(YEAR)

save Dispersion_TableIV.dta,replace

restore

** Rows 4 and 5: Top 20% Share
preserve		  
local varlist K COSTEMPL  
foreach var of local varlist {
bys YEAR:egen p80_`var'=pctile(`var') if `var'!=.,p(80)
bys YEAR:egen sum_p80_`var'=sum(`var') if `var'!=. & `var'>=p80_`var'
bys YEAR:egen sum_`var'=sum(`var') if `var'!=. 
gen p80_sh_`var'=sum_p80_`var'/sum_`var'

}



collapse p80_sh_K p80_sh_COSTEMPL , by(YEAR)

save top_20percent_firms.dta,replace		  

restore		  


***********************************************************************
*** Section: VI.B. Inspecting the Mechanism: Capital Allocation Across Firms
*** Results in Appendix E.2
***********************************************************************
** First and Last year 
gen init_year=1 if YEAR==1999
replace init_year=0 if init_year==.
				   
gen last_year=1 if YEAR==2007
replace last_year=0 if last_year==.

** keep only firms with data in 1999 and 2007
bys id:egen maxinit_year=max(init_year)
bys id:egen maxlast_year=max(last_year)

keep if maxinit_year==1 & maxlast_year==1
drop maxinit_year maxlast_year


local varlist K B_st TFP ln_NW_model log_K 
foreach var of local varlist{
gen `var'_init=`var' if init_year==1
gen `var'_last=`var' if last_year==1

by id:egen max`var'_init=max(`var'_init)
by id:egen max`var'_last=max(`var'_last)

gen delta_`var'= max`var'_last -max`var'_init

drop `var'_init `var'_last
rename max`var'_init `var'_init
drop max`var'_last
}

** generate new LHS
drop inv_lagK delta_debt_lagK
gen inv_lagK=delta_K/K_init
gen delta_debt_lagK=delta_B_st/K_init 


keep if YEAR==2007

tempvar temph templ 
_pctile inv_lagK, percentiles(2 98)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace inv_lagK=`templ' if inv_lagK<`templ' & inv_lagK!=.
replace inv_lagK=`temph' if inv_lagK>`temph' & inv_lagK!=. 

tempvar temph templ 
_pctile delta_debt_lagK, percentiles(2 98)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace delta_debt_lagK=`templ' if delta_debt_lagK<`templ' & delta_debt_lagK!=.
replace delta_debt_lagK=`temph' if delta_debt_lagK>`temph' & delta_debt_lagK!=. 

** Regressions
xi:reg inv_lagK  TFP_init ln_NW_model_init log_K_init i.sec4  , vce(cluster id)
estimates store m1
estadd local yearfix "no",replace
estadd local firmfix "no",replace
estadd local secyearfix "yes",replace	

xi:reg delta_debt_lagK  TFP_init ln_NW_model_init log_K_init i.sec4  , vce(cluster id)
estimates store m2
estadd local yearfix "no",replace
estadd local firmfix "no",replace
estadd local secyearfix "yes",replace

esttab   m1 m2  using reg_growth_initvalues.csv, ///
          cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
          drop(_cons _I* ) stats(N r2 year firmfix secyearfix, fmt(%9.0g %9.2g) ///
		  labels(Obs. R$^2$ "Year FE" "Firm FE" "Sector-Year FE")) /// 
          starlevel(* 0.10 ** 0.05 *** 0.001)    ///
          title("`var'") replace
		  
		  
		  
