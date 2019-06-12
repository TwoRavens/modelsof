/*

VARIABLE DEFITION:

alpha=0.35
mu=1.5

VA: Deflated Value Added
COSTEMPL: Deflated Labor Cost
TGINTGFIXEDASSETS: Deflated Capital
PPI_manuf: Sectoral Price Deflator
*/



***********************************************************************
*** Figure II: Evolution of MRPK and MRPL Dispersion
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


**** Variation in MRPK and MRPL 
bys YEAR NACEREV2CCODE:egen sd_mrpk_fx=sd(ln_mrpk) if ln_mrpk!=.
bys YEAR NACEREV2CCODE:egen sd_mrpl_staf=sd(ln_mrpl) if ln_mrpl!=.


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


preserve
collapse sd_*  [aw=mean_weight_sec], by(YEAR)

* generate relative to the first observation year
gen first_year=_n

local varlist sd_mrpk sd_mrpl
foreach var of local varlist{
gen `var'_first_year=`var' if first_year==1
egen max`var'_first_year=max(`var'_first_year)
gen `var'_rel=`var'/max`var'_first_year
drop `var'_first_year max`var'_first_year
}

drop first_year

save Figure_II.dta,replace
   
restore


***********************************************************************
*** Figure III: TFPR Moments
***********************************************************************
**** Standard Deviation of log(TFPR)
gen TFPR=VA_nominal/((COSTEMPL^0.65)*(TGINTGFIXEDASSETS^0.35))

local varlist TFPR
foreach var of local varlist{
tempvar temph templ 
_pctile `var', percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace `var'=`templ' if `var'<`templ' & `var'!=. 
replace `var'=`temph' if `var'>`temph' & `var'!=. 
}

gen ln_TFPR=ln(TFPR)
bys YEAR NACEREV2CCODE:egen sd_TFPR=sd(ln_TFPR) if ln_TFPR!=.

**** Covariance of log TFPR and log(k/l)
gen KL=TGINTGFIXEDASSETS/COSTEMPL
gen ln_K_L=ln(KL)

bys NACEREV2CCODE YEAR: egen cov_logTFPR_KL = corr(ln_TFPR ln_K_L),covariance

preserve
collapse sd_TFPR  cov_logTFPR_KL [aw=mean_weight_sec], by(YEAR)

save Figure_III.dta,replace

restore


***********************************************************************
*** Figure IV: Evolution of TFP Relative to Efficient Level
***********************************************************************
gen K=TGINTGFIXEDASSETS
gen K_L=((K)^alpha)*((COSTEMPL)^(1-alpha))

* Z: TFP_HK
bys NACE2 YEAR:egen sum_VA=sum(VA_nominal)
gen kappa_num=(sum_VA)^(-1/(sigma-1))
gen kappa=kappa_num/PPI_manuf
sum kappa,detail
drop kappa_num

gen num=VA_nominal^(sigma/(sigma-1))
gen den=(TGINTGFIXEDASSETS^alpha)*[COSTEMPL^(1-alpha)]

gen TFP_HK= kappa*(num/den)

local varlist TFP_HK
foreach var of local varlist{
tempvar temph templ 
_pctile `var', percentiles(1 99)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace `var'=`templ' if `var'<`templ' & `var'!=. 
replace `var'=`temph' if `var'>`temph' & `var'!=. 
}


gen ln_TFP_HK=ln(TFP_HK)
drop num den

* Firm input share in 4-digit sector
bys NACEREV2CCODE YEAR:egen sector_K=sum(K) if K!=.
bys NACEREV2CCODE YEAR:egen sector_W=sum(COSTEMPL) if COSTEMPL!=.
gen sector_K_alpha=sector_K^alpha
gen sector_W_onealpha=sector_W^(1-alpha)
gen denominator=sector_K_alpha*sector_W_onealpha
gen sh_v=K_L/denominator

* Firm value added share in 4-digit sector
bys NACEREV2CCODE YEAR:egen sector_VA=sum(VA_nominal) if VA_nominal!=.
gen sh_s=VA_nominal/sector_VA

** Generate adjusted measures
gen A=exp(ln_TFP_HK)

gen A_sig=A^((sigma-1)/sigma)
gen sh_s_sig=sh_s^((sigma-1)/sigma)
gen sh_v_sig=sh_v^((sigma-1)/sigma)

* mean TFPR
bys NACEREV2CCODE YEAR:egen mean_A_sig=mean(A_sig)  if A_sig!=.
* mean input share
bys NACEREV2CCODE YEAR:egen mean_sh_v_sig=mean(sh_v_sig) if sh_v_sig!=.
* mean value added share
bys NACEREV2CCODE YEAR:egen mean_sh_s_sig=mean(sh_s_sig) if sh_s_sig!=.

* covariance
bys NACEREV2CCODE YEAR: egen cov_A_v = corr(sh_v_sig A_sig),covariance
bys NACEREV2CCODE YEAR: egen cov_A_s = corr(sh_s_sig A_sig),covariance

* MIS MEASURE 
*gen TFPR=VA_nominal/((COSTEMPL^0.65)*(TGINTGFIXEDASSETS^0.35))
gen TFPR_bar=sector_VA/(sector_K_alpha*sector_W_onealpha)

gen TFPR_bar_TFPR=TFPR_bar/TFPR
gen TFPR_bar_TFPR_sig=TFPR_bar_TFPR^(sigma-1)

bys NACEREV2CCODE YEAR:egen mean_TFPR_bar_TFPR_sig=mean(TFPR_bar_TFPR_sig) if TFPR_bar_TFPR_sig!=.
bys NACEREV2CCODE YEAR: egen cov_A_TFPR_bar = corr(A_sig1 TFPR_bar_TFPR_sig),covariance

gen mean_A_sig_TFPR_bar=mean_A_sig1*mean_TFPR_bar_TFPR_sig

gen MIS=[(1/(sigma-1))*ln(mean_A_sig_TFPR_bar+cov_A_TFPR_bar)] - [(1/(sigma-1))*ln(mean_A_sig1)]


** Weighted average
preserve
collapse MIS, by(YEAR)

save Figure_IV.dta,replace
  
restore 


***********************************************************************
*** Figure V: Evolution of Observed TFP Relative to Benchmarks
***********************************************************************
* Observed TFP
bys YEAR NACEREV2CCODE:egen agg_VA=sum(VA)
bys YEAR NACEREV2CCODE:egen agg_W=sum(COSTEMPL)
bys YEAR NACEREV2CCODE:egen agg_KI=sum(TGINTGFIXEDASSETS)

gen TFP_observed=agg_VA/((agg_KI^alpha)*(agg_W^(1-alpha)))

preserve
collapse TFP_observed [aw=mean_weight_sec], by(YEAR)

* generate relative to the first observation year
gen first_year=_n

local varlist TFP_observed
foreach var of local varlist{
gen `var'_first_year=`var' if first_year==1
egen max`var'_first_year=max(`var'_first_year)
gen `var'_rel=`var'/max`var'_first_year
drop `var'_first_year max`var'_first_year

}

drop first_year

save Figure_V.dta,replace

restore


***********************************************************************
*** Figure VI: Log Capital Moments
***********************************************************************
*** Standard Deviation of log k
bys NACEREV2CCODE YEAR:egen sd_ln_K=sd(ln_K) if ln_K!=.

*** Correlation of log k and log Z
bys NACEREV2CCODE YEAR: egen corr_logA_K = corr(ln_TFP_HK ln_K)
bys NACEREV2CCODE YEAR: egen cov_logA_K = corr(ln_TFP_HK ln_K),covariance

preserve
collapse sd_ln_K corr_logA_K cov_logA_K [aw=mean_weight_sec], by(YEAR)

save Figure_VI.dta,replace

restore


***********************************************************************
*** Figure X: MRPK Dispersion and Large Firms
***********************************************************************
* Large firms: firms with capital in the top 5 percent of the capital distribution.
tempvar templ temph
vallist YEAR 
local values "`r(list)'"
foreach yy of local values {
_pctile TGINTGFIXEDASSETS if YEAR==`yy' & TGINTGFIXEDASSETS!=., percentiles(5 95)
scalar `templ'=r(r1)
scalar `temph'=r(r2)
replace size_5=1 if YEAR==`yy' & TGINTGFIXEDASSETS>=`temph' & TGINTGFIXEDASSETS!=. 

}


keep if size_5==1


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


**** Variation in MRPK and MRPL 
bys YEAR NACEREV2CCODE:egen sd_mrpk_fx=sd(ln_mrpk) if ln_mrpk!=.
bys YEAR NACEREV2CCODE:egen sd_mrpl_staf=sd(ln_mrpl) if ln_mrpl!=.


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


preserve
collapse sd_*  [aw=mean_weight_sec], by(YEAR)

* generate relative to the first observation year
gen first_year=_n

local varlist sd_mrpk sd_mrpl
foreach var of local varlist{
gen `var'_first_year=`var' if first_year==1
egen max`var'_first_year=max(`var'_first_year)
gen `var'_rel=`var'/max`var'_first_year
drop `var'_first_year max`var'_first_year
}

drop first_year

save Figure_X.dta,replace
   
restore




