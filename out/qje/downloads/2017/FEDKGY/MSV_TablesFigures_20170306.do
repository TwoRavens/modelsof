
/*==============================================================================
================================================================================


 Stata Tables and Figures for Mian, Sufi, and Verner 
 Quarterly Journal of Economics, 2017 
 March, 2017
 
 
================================================================================ 
==============================================================================*/		


cap log close 
clear all 
set more off , permanently
set scheme sol, permanently
graph set window fontface "Times New Roman"


** SET YOUR PATHS HERE
global path "/Users/emilverner/Dropbox/Research/IBC/MSV_ReplicationKit_20170307/Stata"
cd "${path}"
global destination "/Users/emilverner/Dropbox/Research/IBC/Tables_Figures_test"	


	
		
/*------------------------------------------------------------------------------

 Table 1: Summary Statistics
 
------------------------------------------------------------------------------*/
		
		
use "${path}/masterdata_annual.dta", clear

reg lnGDP_Fd3  L1D3HHD_GDP L1D3NFD_GDP  if mainsmp1==1
gen regsample = e(sample)
tempfile  main_data
save     `main_data' 
		
		
local dvars "lnGDP_d1 lnGDP_Fd3 D1PD_GDP D3PD_GDP D1HHD_GDP D3HHD_GDP D1NFD_GDP D3NFD_GDP  L1D3GD_GDP_Sol2 L1D3NFL_GDP lnhhC_realLCU_d1 lnhhCdur_realLCU_Fd1 lnhhCnondur_realLCU_Fd1 hhC_GDP_d1 lnI_realLCU_d1 lnGC_realLCU_d1 lnX_ifs_d1 lnIm_ifs_d1 NX_ifs_GDP_d1 CA_GDP_d1 s_Xc_d1 s_Imc_d1 D1lnREER_BIS_m12 unrate_Fd1 unrate_Fd3 Fd3_lnGDP_WEO_F Fd3_WEOerror_F L1D3lnRHPIq4 spr_r_q4 ih_ig10 ic_ig10 icorp_ig10 L1toL3hys"



*** (i) Nobs, Mean, Median, SD, SD/SD_y

estpost summarize `dvars' if regsample==1, detail

matrix S= [e(count)\e(mean)\e(p50)\e(sd)]'
matrix list S
clear
* Store in new dataset
svmat2 S, rnames(variable)
rename S1 Nobs
rename S2 Mean
rename S3 Median
rename S4 SD 
sum SD if variable=="lnGDP_d1"
gen SD_SDy = SD/r(mean)
order variable Nobs Mean Median SD SD_SDy
gen sercorr = .
tempfile d1_sumstats
save    `d1_sumstats'


*** (ii) Serial Corr 

** compute serial corr for each country, then take average weighted by sample size 
use `main_data', clear

drop if c_mainsmp~=1

levelsof CountryCode, local(countries)

foreach v in `dvars'{

	* temporary dataset: variable `v' serial correlation for each country
	use `main_data', clear
	collapse year, by(CountryCode countrycode)
	drop year
	tempfile temp`v'
	gen sercorr     = .
	gen T           = .
	save    `temp`v''

	* compute serial corr for variable v across all countries in main reg and take avg
	foreach i in `countries' {
		use `main_data', clear
		keep if CountryCode ==`i' & regsample==1
		tsset year, yearly
		cap qui corrgram `v', lags(1)        // compute autocorrelation for `v' for country `i'
		scalar rac1 = r(ac1)
		qui sum `v'
		scalar nobs = r(N)
		use `temp`v'', clear        
		replace sercorr = rac1 if CountryCode ==`i'
		replace       T = nobs if CountryCode ==`i'
		save `temp`v'', replace		
	}
	list
	sum T
	display "Number of total country-years= " r(sum) // should be ~695
	* take weighted average (by sample size) and store in summary stats dataset hp_sumstats
	summarize sercorr [aw=T]
	scalar meansercorr = r(mean)
	use `d1_sumstats', clear
	replace sercorr = meansercorr if variable=="`v'"
	save `d1_sumstats', replace
}



*** Make Table 

* column headers
label var Nobs "N"
label var Mean "Mean"
label var Median "Median"
label var SD   "SD"
label var SD_SDy "\( \frac{SD}{SD( \Delta y )} \) "
label var sercorr "Ser. Cor."

* variable names (first column)
replace variable = " \( \Delta y \) " if variable=="lnGDP_d1"
replace variable = " \( \Delta_3 y \) " if variable=="lnGDP_Fd3"
replace variable = " \( \Delta d^{Private} \) " if variable=="D1PD_GDP"
replace variable = " \( \Delta_3 d^{Private} \) " if variable=="D3PD_GDP"
replace variable = " \( \Delta d^{HH} \) " if variable=="D1HHD_GDP"
replace variable = " \( \Delta_3 d^{HH} \) " if variable=="D3HHD_GDP"
replace variable = " \( \Delta d^{F} \) " if variable=="D1NFD_GDP"
replace variable = " \( \Delta_3 d^{F} \) " if variable=="D3NFD_GDP"
replace variable = "\( \Delta_3 d^{Gov} \)" if variable=="L1D3GD_GDP_Sol2"
replace variable = "\( \Delta_3 d^{Netforeign} \)" if variable=="L1D3NFL_GDP"
replace variable = " \( \Delta c \) " if variable=="lnhhC_realLCU_d1"
replace variable = " \( \Delta c^{dur} \) " if variable=="lnhhCdur_realLCU_Fd1"
replace variable = " \( \Delta c^{nondur} \) " if variable=="lnhhCnondur_realLCU_Fd1"
replace variable = " \( \Delta C/Y \) " if variable=="hhC_GDP_d1"
replace variable = " \( \Delta i \) " if variable=="lnI_realLCU_d1"
replace variable = " \( \Delta g \) " if variable=="lnGC_realLCU_d1"
replace variable = " \( \Delta x \) " if variable=="lnX_ifs_d1"
replace variable = " \( \Delta m \) " if variable=="lnIm_ifs_d1"
replace variable = " \( \Delta NX/Y \) " if variable=="NX_ifs_GDP_d1"
replace variable = " \( \Delta CA/Y \) " if variable=="CA_GDP_d1"
replace variable = " \( \Delta s^{XC} \)" if variable=="s_Xc_d1"
replace variable = " \( \Delta s^{MC} \)" if variable=="s_Imc_d1"
replace variable = " \( \Delta reer \)" if variable=="D1lnREER_BIS_m12"
replace variable = " \( \Delta u \)" if variable=="unrate_Fd1"
replace variable = " \( \Delta_3 u \)" if variable=="unrate_Fd3"
replace variable = "\( \Delta_3 y_{t+3|t}^{WEO} \)" if variable=="Fd3_lnGDP_WEO_F"
replace variable = "\( \Delta_3 (y_{t+3} - y_{t+3|t}^{WEO}) \)" if variable=="Fd3_WEOerror_F"
replace variable = "\( \Delta_3 \ln(P^{Housing}) \)" if variable=="L1D3lnRHPIq4"
replace variable = " \( spr^{real} \)" if variable=="spr_r_q4"
replace variable = " \( spr^{MS} \)" if variable=="ih_ig10"
replace variable = " \( spr^{CS} \)" if variable=="ic_ig10"
replace variable = " \( spr^{corp} \)" if variable=="icorp_ig10"
replace variable = "Avg HYS, t-3 to t-1" if variable=="L1toL3hys"


* round
foreach v in Mean Median SD SD_SDy sercorr {
	replace `v' = round(`v',0.01)
	format  `v' %9.2f	

}

drop if variable== "Avg HYS, t-3 to t-1"
drop if variable== " \( spr^{CS} \)"

#delimit ;
texsave using "${destination}/Table_SumStats_d1.tex", 
        nofix location(h) marker(Table_SumStats_d1)
        replace frag varlabels title("Summary Statistics")
		footnote("\textit{Notes}:  Log changes and ratios are multiplied by 100 to report changes in percentages or percentage points. 
		\( \Delta \) and \(\Delta_3 \) denote to one-year and three-year changes, respectively. 
		The variables \(y , d^{Private}, d^{HH}, d^F, d^{Gov}, \Delta_3 d^{Netforeign}, c, c^{dur}, c^{nondur}, C/Y, i, g, x, m, NX/Y, CA/Y, s^{XC}, s^{MC}, reer, u, y_{t+3|t}^{WEO}, \) 
		\( \ln(P^{Housing}), spr^{real}, spr^{MS},\) and \(spr^{corp} \) denote 
		log real GDP, private non-financial debt to GDP, household debt to GDP, non-financial firm debt to GDP, government debt to GDP, change net foreign liabilities (sum of current account to GDP deficits), 
		log real consumption, log real durable consumption, log real nondurable consumption, consumption to GDP, log real investment, log real government consumption, log nominal exports, log nominal imports, 
		net exports to GDP, current account to GDP, the share of consumption exports to total exports, the share of consumption imports to total imports, log real effective exchange rate, the unemployment rate, 
		the IMF Fall \textit{World Economic Outlook} time t forecast of growth from t to t+3, the log real house price index, the real 10 year government bond yield spread with respect to the United States, 
		mortgage-sovereign spread, and the corporate-sovereign spread, respectively.");
#delimit cr




/*------------------------------------------------------------------------------

 Table 2: Timing of RHS
 
------------------------------------------------------------------------------*/

cap est drop *
use "${path}/masterdata_annual.dta", clear

gen L1yd3 = L.lnGDP_d3
 
forv i=0/6 {
	gen F`i'L1yd3 = F`i'.L1yd3
	local j=`i'-1
	label var F`i'L1yd3 "$ \Delta_3 y_{it+`j'} $"
}
	label var F1L1yd3 "$ \Delta_3 y_{it} $"
	label var F0L1yd3 "$ \Delta_3 y_{it-1} $"

forv i=0/6 {	
	eststo: xtivreg2 F`i'L1yd3 L1D3HHD_GDP L1D3NFD_GDP  if c_mainsmp==1 , fe cluster(CountryCode year)
	estadd local FE "\checkmark"
	test L1D3HHD_GDP == L1D3NFD_GDP
	local pval: display %9.4f r(p)
	estadd local tst = `pval'	
}
 
local controls ""

* Table: Varying timing of lag
#delimit ;
esttab  using "${destination}/Table_timing.tex",       
	   keep(L1D3HHD_GDP L1D3NFD_GDP) 
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   mgroups( "Dependent variable: \( \Delta_3 y_{it+k}, k=-1,0,...,5  \)" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))  
	   obslast label
	   booktabs   substitute(\_ _) nonotes
	   scalars("FE Country fixed effects" "tst Test for equality of \\ \hspace{.2cm} \( \beta_{HH}\) and \( \beta_F,\)  p-value" "r2 \(R^2\)") ;
#delimit cr



 


/*------------------------------------------------------------------------------

 Table 3: Household Debt Expansion Predicts Lower Growth
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear		
cap est drop *

* (1) Total private debt
eststo: xtivreg2 lnGDP_Fd3 L1D3PD_GDP if mainsmp1==1 & L1D3NFD_GDP~=. , fe cluster(CountryCode year)
estadd local FE "\checkmark"

* (2) HHD
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP if mainsmp1==1 & L1D3NFD_GDP~=. , fe cluster(CountryCode year)
estadd local FE "\checkmark"

* (3) NFD	
eststo: xtivreg2 lnGDP_Fd3 L1D3NFD_GDP if mainsmp1==1 & L1D3NFD_GDP~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"

* (4) HHD and NFD together
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

eststo: xtivreg2 lnGDP_Fd3 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3HHD_GDP L1D3NFD_GDP if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

* (6) GovDebt/GDP
eststo: xtivreg2 lnGDP_Fd3 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3HHD_GDP L1D3NFD_GDP L1D3GD_GDP_Sol2 if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

* (7) Net foreign debt
eststo: xtivreg2 lnGDP_Fd3 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3HHD_GDP L1D3NFD_GDP L1D3NFL_GDP if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

* (8) NFD Interaction
gen       L1toL3CA = L.CA_USD + L2.CA_USD + L3.CA_USD 
gen     L1D3NFLpos = (L1toL3CA<0)                    
replace L1D3NFLpos = . if L1toL3CA==.
gen     L1D3NFLposXL1D3HHD_GDP = L1D3NFLpos*L1D3HHD_GDP
label var L1D3NFLpos             " $  \mathbf{1}( \Delta_3 d^{Netforeign}_{it-1} >0$ )"
label var L1D3NFLposXL1D3HHD_GDP " $ \Delta_3 d^{HH}_{it-1} * \mathbf{1} ( \Delta_3 d^{Netforeign}_{it-1} >0  $ ) "

eststo: xtivreg2 lnGDP_Fd3 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3HHD_GDP L1D3NFD_GDP L1D3NFLpos L1D3NFLposXL1D3HHD_GDP  if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"



#delimit ;
esttab using "${destination}/Table3.tex", 
	   keep(L1D3PD_GDP L1D3HHD_GDP L1D3NFD_GDP L1D3GD_GDP_Sol2  L1D3NFL_GDP L1D3NFLpos L1D3NFLposXL1D3HHD_GDP) 
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant nomtitles
	   mgroups( "Dependent variable: \( \Delta_3 y_{it+3} \)" , pattern(1 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))  
	   obslast  scalars("FE Country fixed effects" "LDV Distributed lag in \( \Delta y \)" "tst Test for equality of \\ \hspace{.2cm} \( \beta_{HH}\) and \( \beta_F,\)  p-value" "r2 \(R^2\)") 
	   booktabs label  nonotes substitute(\_ _);
#delimit cr	   






/*------------------------------------------------------------------------------

 Table 4: Robustness
 
------------------------------------------------------------------------------*/

	
*** Non-circular Panel Moving Block (Pairs) Bootstrap (Goncalves 2011)
quietly{
set seed 117
use "${path}/masterdata_annual.dta", clear
keep if mainsmp1==1
keep CountryCode year lnGDP_Fd3 lnGDP_Fd1 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1
keep if lnGDP_Fd3!=. & L1D3NFD_GDP~=.
gen mody = mod(year,3)
*keep if mody==1

sum
tempfile DATA
save    `DATA'   // draw blocks from this data matrix

* Store SD(beta_boot) here
clear
set obs 8
gen sd_H = .
gen sd_F = .
gen q_u_H = .
gen q_l_H = .
gen q_u_F = .
gen q_l_F = .
gen q_05_H = .
gen q_995_H = .
gen q_05_F = .
gen q_995_F = .
gen q_5_H = .
gen q_95_H = .
gen q_5_F = .
gen q_95_F = .
gen sd_b_H_b_F = .
gen m_b_H_b_F  = .
gen cov_H_F    = .
gen b = _n
tempfile SDs
save    `SDs'

* loop over block lengths
forv b=3/3 {
	
	use `DATA', clear
	local M = `b' // block length
	sum year
	local T1 = r(min) 
	local TM = r(max) - `M' + 1
	local TM_T1 = `TM' - `T1'
	local N = r(N)
	dis `T1'
	dis `TM'
	dis `N'

	* preallocate matrix with estimates 
	clear 
	local B = 1000  // number of pseudosamples
	set obs `B'
	gen j = _n
	gen b_H = .
	gen b_F = .
	tempfile results
	save    `results'
	clear

	forv j=1/`B' {
		quietly{
		* draw boostrap sample
		clear
		tempfile DATA_BOOT
		save    `DATA_BOOT', empty
		local t=1
		while `t' < `N' { 
			use `DATA', clear
			local u1 =  floor((`TM_T1'+1)*runiform() + `T1') // draw a year from uniform distribution between T1 and TM -> lower year of block
			local u2 = `u1' + `M' - 1                        // upper year of block
			keep if inrange(year,`u1',`u2')
			tab year
			append using `DATA_BOOT'                         // append this block to the pseudo-sample
			save `DATA_BOOT', replace
			sum year
			local t = r(N)
		}
		drop if _n > `N'                                     // drop observations so pseudo-sample size == data size

		* run and save fixed effects regression on this sample
		areg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 , absorb(CountryCode)
		use `results' , clear
		replace b_H = _b[L1D3HHD_GDP] if j == `j'
		replace b_F = _b[L1D3NFD_GDP] if j == `j'
		save `results', replace
		}
	}
	
	** summarize beta's from these B pseudo-samples
	sum b_H , detail
	local sd_H = r(sd)
	sum b_F , detail
	local sd_F = r(sd)
	
	* 95%, 99% CIs
	foreach X in H F {
		egen b_`X'_mean = mean(b_`X')
		gen dm_b_`X' = b_`X' - b_`X'_mean
		egen p2_5_`X' = pctile(dm_b_`X'), p(2.5)	
		sum p2_5_`X'
		local q_l`X' = r(mean)
		egen p97_5_`X' = pctile(dm_b_`X'), p(97.5)	
		sum p97_5_`X'
		local q_u`X' = r(mean)
		
		egen p0_5_`X' = pctile(dm_b_`X'), p(0.5)	
		sum p0_5_`X'
		local q_05`X' = r(mean)
		egen p99_5_`X' = pctile(dm_b_`X'), p(99.5)	
		sum p99_5_`X'
		local q_995`X' = r(mean)		

		egen p5_`X' = pctile(dm_b_`X'), p(5)	
		sum p5_`X'
		local q_5`X' = r(mean)
		egen p95_`X' = pctile(dm_b_`X'), p(95)	
		sum p95_`X'
		local q_95`X' = r(mean)				
		
	}
	
	gen b_H_b_F = b_H - b_F
	sum b_H_b_F 
	local m_b_H_b_F = r(mean)
	local sd_b_H_b_F = r(sd)
	gen pos = (b_H_b_F >=0 )
	sum pos 
	correlate b_H b_F, covariance
	local cov_H_F = r(cov_12) 
	
	* store SDs and upper/lower limits of 95% CI
	use `SDs', clear
		replace sd_H = `sd_H' if b == `b'
		replace sd_F = `sd_F' if b == `b'
		foreach X in H F{
		replace q_u_`X' = `q_u`X'' if b == `b'
		replace q_l_`X' = `q_l`X'' if b == `b'
		replace q_05_`X'  = `q_05`X'' if b== `b'
		replace q_995_`X'  = `q_995`X'' if b== `b'
		replace q_5_`X'  = `q_5`X'' if b== `b'
		replace q_95_`X'  = `q_95`X'' if b== `b'
	}
		replace m_b_H_b_F  = `m_b_H_b_F'  if b== `b'
		replace sd_b_H_b_F = `sd_b_H_b_F' if b== `b'
		replace cov_H_F    = `cov_H_F'    if b== `b'
	save `SDs', replace
}

* CI figure
gen b_H = -0.333
gen b_F = -0.0464

foreach X in H F {
	gen b_`X'_95l = b_`X' - q_u_`X'
	gen b_`X'_95u = b_`X' - q_l_`X'
	gen b_`X'_99l = b_`X' - q_995_`X'
	gen b_`X'_99u = b_`X' - q_05_`X'
	gen b_`X'_90l = b_`X' - q_95_`X'
	gen b_`X'_90u = b_`X' - q_5_`X'
	
}

** Test for difference of b_H b_F
* t-statistic for difference
gen t_b_H_b_F = m_b_H_b_F / sd_b_H_b_F
gen p_b_H_b_F=2*(1-normal(abs(t_b_H_b_F))) 

	* using bootstrapped covariance
	gen se_diff = (sd_H^2 + sd_F^2 - 2*cov_H_F)^(1/2)
	gen p_diff  = 2*(1-normal(abs((-.333-0.0464)/se_diff))) 

}	
*	
local var_H = sd_H[3]^2 
local var_F = sd_F[3]^2 
local pv_boot= round(p_b_H_b_F[3],0.0001)



*** Table 4

cap est drop *
use "${path}/masterdata_annual.dta", clear	

* controls 
local cont   "L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1"

** PANEL A

* non-overlapping observations
gen mod3_year =mod(year,3) // modulus of year with respect to 3

eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d3  if mainsmp1==1 & mod3_year==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Non-overl."		
estadd local comment_s "\textbf{Non-Overl.}"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (v) Arellano-Bond
	* prepare data
	keep if mod3_year==1
	replace lnGDP = 100*lnGDP
	xtset CountryCode year, delta(3)
	
* AB: equation in differences
eststo: xtabond2 F.D.lnGDP D.lnGDP L1D3HHD_GDP L1D3NFD_GDP, gmm(D.lnGDP) iv(L.L1D3HHD_GDP L.L1D3NFD_GDP, passthru) cluster(CountryCode year) noleveleq
estadd local LDV "\checkmark"
estadd local comment "Non-overl."	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'

* excluding country fixed effects
use "${path}/masterdata_annual.dta", clear		
eststo: cgmreg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP `cont'  if mainsmp1==1 , cluster(CountryCode year)
estadd local LDV "\checkmark"
estadd local comment "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* bootstrap CI
eststo m_boot: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP `cont'  if mainsmp1==1, fe cluster(CountryCode year)
matrix mymatrix = e(V)
matrix mymatrix[1,1] = `var_H' 
matrix mymatrix[2,2] = `var_F'
matrix list  mymatrix
capture program drop myrepost
program myrepost, eclass
ereturn repost V = `1'
end
myrepost mymatrix
matrix list e(V)
estimates store m_boot
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Full"
estadd local tst = `pv_boot'


* trend
gen t=year
label var t "Trend"
eststo: xtivreg2 lnGDP_Fd3 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3HHD_GDP L1D3NFD_GDP t if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Full"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

* year FE
tab year , gen(year_)
eststo: xtivreg2 lnGDP_Fd3 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3HHD_GDP L1D3NFD_GDP year_* if mainsmp1==1, fe cluster(CountryCode year) partial(year_*)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local TE "\checkmark"
estadd local comment "Full"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	
	
* alternative variable: L1D3HHD_L3GDP, L1D3NFD_L3GDP
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_L3GDP L1D3NFD_L3GDP `cont'  if mainsmp1==1 , fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Full"
estadd local comment_s "Full"
test L1D3HHD_L3GDP == L1D3NFD_L3GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'


#delimit ;	   
esttab  using "${destination}/Table_robustness_A.tex",
	   keep(L1D3HHD_GDP L1D3NFD_GDP t L1D3HHD_L3GDP L1D3NFD_L3GDP)
	   coeflabels(L1D3HHD_L3GDP " \( \Delta_3 d^{HH}_{it-1}, \)  alt norm." L1D3NFD_L3GDP " \( \Delta_3 d^{F}_{it-1},\) alt. norm.") 
	   mtitles("OLS" "AB-GMM" "OLS" "MBB SE" "OLS" "OLS" "OLS")
	   replace compress b(a2) se(a2)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("FE Country fixed effects" "LDV Distributed lag in \( \Delta y\)" "TE Year fixed effects"  "comment Sample" "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "r2 \(R^2\)") 
	   mgroups( "Dependent variable: \( \Delta_3 y_{it+3} \)", pattern(1 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///	   
	   booktabs label  nonotes substitute(\_ _); 
#delimit cr





*** PANEL (B)
cap est drop *
* Developed / Emerging
eststo: qui xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP `cont'  if mainsmp1==1 & emergingdummy==0, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Developed"
estadd local comment_s "\textbf{Developed}"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP `cont'  if mainsmp1==1 & emergingdummy==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Emerging"
estadd local comment_s "\textbf{Emerging}"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

* pre 1995
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP `cont'   if mainsmp1==1 & year<=1992, fe cluster(CountryCode year) 
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Pre 1995"	
estadd local comment_s "\textbf{Pre 1995}"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'	

* pre 2006
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP `cont'   if mainsmp1==1 & year<=2003, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Pre 2006"	
estadd local comment_s "\textbf{Pre 2006}"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

* pre 2006, trend
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP t `cont' if mainsmp1==1 & year<=2003, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local comment "Pre 2006"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	

* pre 2006, year FE
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP  year_* `cont' if mainsmp1==1 & year<=2003, fe cluster(CountryCode year) 
estadd local FE "\checkmark"
estadd local LDV "\checkmark"
estadd local TE "\checkmark"
estadd local comment "Pre 2006"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'	



#delimit ;	   
esttab using "${destination}/Table_robustness_B.tex",
	   keep(L1D3HHD_GDP L1D3NFD_GDP t)
	   nomtitles
	   replace compress b(a2) se(a2)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("FE Country fixed effects" "LDV Distributed lag in \( \Delta y\)" "TE Year fixed effects" "comment Sample" "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "r2 \(R^2\)") 
	   mgroups( "Dependent variable: \( \Delta_3 y_{it+3} \)", pattern(1 0 0 0 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///	   
	   booktabs label  nonotes substitute(\_ _); 
#delimit cr






/*------------------------------------------------------------------------------

 Table 5: HH Debt Finances Consumption Booms
 
------------------------------------------------------------------------------*/

cap est drop *
use "${path}/masterdata_annual.dta", clear		

* labels
label var hhC_GDP_d1          "$\Delta_1 \frac{C}{Y}_{it}$"
label var I_GDP_d1            "$\Delta_1 \frac{I}{Y}_{it}$"
label var NX_ifs_GDP_d1       "$\Delta_1 \frac{NX}{Y}_{it}$"
label var CA_GDP_d1           "$\Delta_1 \frac{CA}{Y}_{it}$"
label var s_Imc_d1            "$\Delta_1 s^{MC}_{it}$"
label var s_Xc_d1             "$\Delta_1 s^{XC}_{it}$ "
label var D1lnREER_BIS_m12    "\( \Delta_1 reer_{it} \)"
label var hhCnondur_GDP_d1    "$\Delta_1 \frac{C^{nondur}}{Y}_{it}$"
label var hhCdur_GDP_d1       "$\Delta_1 \frac{C^{dur}}{Y}_{it}$"
label var hhCservices_GDP_d1  "$\Delta_1 \frac{C^{services}}{Y}_{it}$"


* C/Y
eststo: xtivreg2 hhC_GDP_d1 D1HHD_GDP D1NFD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* non-durable consumption
eststo: xtivreg2 hhCnondur_GDP_d1 D1HHD_GDP D1NFD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* durable consumption
eststo: xtivreg2 hhCdur_GDP_d1 D1HHD_GDP D1NFD_GDP    if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* services consumption
eststo: xtivreg2 hhCservices_GDP_d1 D1HHD_GDP D1NFD_GDP    if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* I/Y
eststo: xtivreg2 I_GDP_d1 D1HHD_GDP D1NFD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* NX/Y
eststo: xtivreg2 NX_ifs_GDP_d1 D1HHD_GDP D1NFD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* CA/Y
eststo: xtivreg2 CA_GDP_d1 D1HHD_GDP D1NFD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* s_Imc
eststo: xtivreg2 s_Imc_d1 D1HHD_GDP D1NFD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"
* s_Xc
eststo:xtivreg2 s_Xc_d1 D1HHD_GDP D1NFD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=., fe  cluster(CountryCode year)
estadd local FE "\checkmark"

# delimit; 
esttab using "${destination}/Table_contemp_GDPcomponents_d1.tex",
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("FE Country fixed effects" "r2 \(R^2\)") booktabs label  nonotes substitute(\_ _);	   
# delimit cr






/*------------------------------------------------------------------------------

 Table 6: Proxy SVAR First Stage Table
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear		

* construct instruments
areg ih_ig10 , absorb(CountryCode)
predict ih_r, res
by CountryCode: egen sd_ih = sd(ih_ig10)
gen ih_std = ih_r /sd_ih
sum ih_std, detail	
gen ih_50     =  (ih_std <`r(p50)')
replace ih_50 = . if ih_ig10 ==.

* residualize
foreach v in ih_ig10 ih_50  {
	areg `v' L(1/5).HHD_L1GDP L(1/5).NFD_L1GDP L(1/5).lnGDP if lnGDP~=. & HHD_L1GDP~=. & NFD_L1GDP~=. , absorb(CountryCode)
	predict `v'_res, r	
}	

label var ih_ig10_res "MS Spread, residual"
label var ih_50_res "Low MS Spread Indicator, residual"
label var u_hhd     "\( \hat u^{d^{HH}}_{it} \)"
label var u_nfd     "\( \hat u^{d^F}_{it} \)"

** run first stage regressions
foreach uu in u_hhd u_nfd {
	foreach xx in  ih_ig10_res ih_50_res{

		reg   `uu' `xx' , cluster(year)	
		
		est store `uu'_`xx'
		local Rsquare: display %5.3f e(r2)
		estadd local Rsquared = `Rsquare' 
		test `xx'
		local Fstat: display %5.3f r(F)
        estadd local Ftest = `Fstat' 
		
	}
}

** Table: Proxy SVAR First Stage: HHD Residuals
#delimit ;
esttab  u_hhd_ih_ig10_res  u_hhd_ih_50_res  u_nfd_ih_ig10_res  u_nfd_ih_50_res
       using "${destination}/Table_ProxySVAR_FirstStage.tex", 
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("Ftest F statistic" "Rsquared \(R^2\)") 
	   mgroups("\shortstack{Residual from VAR \\ Household Debt Equation}" "\shortstack{Residual from VAR \\ Firm Debt Equation}"  , pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   booktabs label  nonotes substitute(\_ _);
#delimit cr





/*------------------------------------------------------------------------------

 Table 7: IV Cases, Eurozone and 2000s boom
 
------------------------------------------------------------------------------*/


*** A. Euro example 
use "${path}/masterdata_annual.dta", clear
keep if Continent==3
* drop non-Eurozone countries (except DK, pegged)
drop if c_mainsmp~=1
drop if countrycode == "CHE" | countrycode=="CZE" | countrycode=="GBR" | ///
        countrycode == "HUN" | countrycode=="NOR" | countrycode=="SWE" | ///
	    countrycode == "POL" | countrycode=="SVK" | countrycode=="LUX"   
keep if year>=1992

gen spr_r_q4_9699 = spr_r_q4 - L3.spr_r_q4 if year==1999
gen HHD_GDP_0207 = HHD_GDP - L5.HHD_GDP if year==2007
gen NFD_GDP_0207 = NFD_GDP - L5.NFD_GDP if year==2007
gen y_0710   = 100*(lnGDP - L3.lnGDP) if year==2010
gen y_0207   = lnGDP - L5.lnGDP if year==2007

collapse spr_r_q4_9699 HHD_GDP_0207 NFD_GDP_0207 y_0710 y_0207  , by(countrycode CountryCode)

label var y_0710 "\( \Delta_{07-10} y_i \)"
label var y_0207 "\( \Delta_{02-07} y_i \)"

* OLS
reg y_0710 HHD_GDP_0207 , r
est store euro_ols
estadd local eqn "OLS"

* first stage		 
reg HHD_GDP_0207 spr_r_q4_9699, r
est store euro_fs
test spr_r_q4_9699
local Fstat: display %5.1f r(F)
estadd local Ftest = `Fstat'
estadd local eqn "FS"

* IV
ivregress gmm y_0710 (HHD_GDP_0207 = spr_r_q4_9699), r
est store euro_iv
estadd local eqn "IV"

* IV including controls
ivregress gmm y_0710 (HHD_GDP_0207 = spr_r_q4_9699) NFD_GDP_0207 y_0207, r
est store euro_iv_controls
estadd local eqn "IV"

		
		
*** B. Mortgage sovereign spread and 2000s boom 

use "${path}/masterdata_annual.dta", clear	
drop if countrycode=="HUN" // report regressions without Hungary (large outlier and marginal source of credit in FC)
foreach v in ih_ig10 {	
	forv i=1/9{
		gen D`i'`v' = `v' - L`i'.`v' 
	}
}
rename D5HHD_GDP HHD_GDP_0207
rename D5NFD_GDP NFD_GDP_0207
gen y_0710 = lnGDP_Fd3 if year==2007
gen y_0207 = lnGDP_d5 if year==2007
label var y_0710 "\( \Delta_{07-10} y_i \)"
label var y_0207 "\( \Delta_{02-07} y_i \)"
gen ih_ig10_2000_04 = L3.D4ih_ig10 if year==2007
label var ih_ig10_2000_04 "\(\Delta_{00-04} spr^{MS}_i\)"
label var HHD_GDP_0207 "\(\Delta_{02-07} d^{HH}_i \)"
label var NFD_GDP_0207 "\(\Delta_{02-07} d^{F}_i\)"
label var ih_ig10 "\(spr_{it}^{MS}\)"

* OLS
reg y_0710 HHD_GDP_0207 if year==2007 & ih_ig10_2000_04~=., r
est store MSS_ols
estadd local eqn "OLS"

* first stage
reg HHD_GDP_0207 ih_ig10_2000_04 if year==2007 , r
est store MSS_fs
test ih_ig10_2000_04
local Fstat: display %5.3f r(F)
estadd local Ftest = `Fstat'
estadd local eqn "FS"

* IV
ivregress gmm y_0710 (HHD_GDP_0207 = ih_ig10_2000_04) if year==2007 , first
est store MSS_iv
estadd local eqn "IV"

* IV
ivregress gmm y_0710 (HHD_GDP_0207 = ih_ig10_2000_04) NFD_GDP_0207 y_0207 if year==2007 , first
est store MSS_iv_controls
estadd local eqn "IV"
		
		
#delimit ;
esttab euro_ols euro_fs euro_iv  euro_iv_controls  MSS_ols MSS_fs MSS_iv MSS_iv_controls
       using "${destination}/Table_NaturalExperiments.tex", 
	   keep(HHD_GDP_0207 NFD_GDP_0207 y_0207 spr_r_q4_9699 ih_ig10_2000_04  ) 
	   order(spr_r_q4_9699 HHD_GDP_0207 L1D3HHD_GDP  )
	   coeflabels(spr_r_q4_9699 "\( \Delta_{96-99} spr^{real}_i \)" HHD_GDP_0207 "\( \Delta_{02-07} d^{HH}_i \)" NFD_GDP_0207 "\( \Delta_{02-07} d^F_i \)" )
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   mgroups( "Eurozone Case and Sovereign Spread over U.S." "2000s Boom and Mortgage-Sovereign Spread", pattern( 1 0 0 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///	   
	   obslast  scalars("eqn Equation" "Ftest First stage F-statistic" "r2 \(R^2\)") 
	   booktabs label  nonotes substitute(\_ _);
#delimit cr	 





/*------------------------------------------------------------------------------

 Table 8: Professional Forecasts
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear
cap est drop *

* sample restriction
keep if mainsmp1==1 
* OECD restriction: these East Asian economies have intermittent coverage (gaps or only included for some years)
gen     smp_ng=1 
replace smp_ng=0 if countrycode=="HKG" | countrycode=="IDN" | countrycode=="SGP" | countrycode=="THA"


** forecasts
* (1) IMF
eststo: xtivreg2 Fd2_lnGDP_WEO_F L1D3HHD_GDP L1D3NFD_GDP if  lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (2) OECD
eststo: xtivreg2 Fd2_lnGDP_OECD_F L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=. & smp_ng==1 & Fd2_OECDerror_F~=. , fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'
	
** forecast errors
* (3) IMF 1 (t,t+1)
eststo: xtivreg2 Fd1_WEOerror_F L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (4) IMF 2
eststo: xtivreg2 Fd2_WEOerror_F L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (5) IMF 3
eststo: xtivreg2 Fd3_WEOerror_F L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (6) OECD 1 
eststo: xtivreg2 Fd1_OECDerror_F L1D3HHD_GDP L1D3NFD_GDP if smp_ng==1 & year>=1973 & lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (7) OECD 2
eststo: xtivreg2 Fd2_OECDerror_F L1D3HHD_GDP L1D3NFD_GDP if smp_ng==1 & lnGDP_Fd3~=. , fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (8) forecast error IMF: pre 2006
eststo: xtivreg2 Fd1_WEOerror_F  L1D3HHD_GDP L1D3NFD_GDP  if lnGDP_Fd3~=. & year<=2005 & lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Pre 2006"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* (9) forecast error OECD: pre 2006
eststo: xtivreg2 Fd1_OECDerror_F L1D3HHD_GDP L1D3NFD_GDP  if smp_ng==1 & year>=1973 & year<=2005 & lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Pre 2006"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'


#delimit ;
esttab using "${destination}/Table_WEO_OECD_fcasts.tex", 
	   keep(L1D3HHD_GDP L1D3NFD_GDP) 
	   mtitles("\( \Delta_2 y_{t+2|t}^{IMF} \)" "\( \Delta_2 y_{t+2|t}^{OECD} \)" "\( e^{IMF}_{t+1|t}\)" "\( e^{IMF}_{t+2|t}\)" "\( e^{IMF}_{t+3|t}\)" "\( e^{OECD}_{t+1|t}\)" "\( e^{OECD}_{t+2|t}\)" "\( e^{IMF}_{t+1|t}\)" "\( e^{OECD}_{t+1|t}\)")
	   replace compress b(a2) se(a2)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("FE Country fixed effects" "smp Sample" "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "r2 \(R^2\)") 
	   mgroups( "Growth Forecast" "Forecast Error" "\shortstack{ Forecast Error \\ Sample up to 2006}", pattern(1 0 1 0 0 0 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   booktabs label  nonotes substitute(\_ _);
#delimit cr	 	






/*------------------------------------------------------------------------------

 Table 9: Nonlinearity and Heterogeneity
 
------------------------------------------------------------------------------*/



use "${path}/masterdata_annual.dta", clear
		  		  
** Non-linearity
foreach X in HH NF {
	gen `X'_POS = (L1D3`X'D_GDP>0)*L1D3`X'D_GDP
	gen `X'_NEG = (L1D3`X'D_GDP<=0)*L1D3`X'D_GDP	
}

label var HH_POS "$ \Delta_3 d_{it-1}^{HH} * \mathbf{1}( \Delta_3 d_{it-1}^{HH} > 0 ) $"
label var HH_NEG "$ \Delta_3 d_{it-1}^{HH} * \mathbf{1}( \Delta_3 d_{it-1}^{HH} \leq 0 ) $"
label var NF_POS "$ \Delta_3 d_{it-1}^F * \mathbf{1}( \Delta_3 d_{it-1}^F > 0 ) $"
label var NF_NEG "$ \Delta_3 d_{it-1}^F * \mathbf{1}( \Delta_3 d_{it-1}^F \leq 0 ) $"

eststo NL_1: xtivreg2 lnGDP_Fd3 HH_POS HH_NEG NF_POS NF_NEG L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
    
* Fixed
qui xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if mainsmp1==1 & ERA_coarse2==1, fe cluster(CountryCode year)
est store ERA_1
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* Intermediate
qui xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if mainsmp1==1 & ERA_coarse2==2, fe cluster(CountryCode year)
est store ERA_2
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'
* Floating
qui xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if mainsmp1==1 & ERA_coarse2==3, fe cluster(CountryCode year)
est store ERA_3
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'



#delimit;
esttab NL_1 ERA_1 ERA_2 ERA_3  
       using "${destination}/Table_Heterogeneity.tex", 
	   keep(HH_POS HH_NEG NF_POS NF_NEG L1D3HHD_GDP L1D3NFD_GDP  ) 
	   replace compress b(a3) se(a3)   star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("FE Country fixed effects" "Dy Distributed lag in \(\Delta y\)" "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "r2 \(R^2\)") 
	   mgroups("Non-linearity" "Fixed" "Intermediate" "Freely floating" "\shortstack{Net foreign \\ borrower}", pattern( 1 1 1 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   booktabs label  nonotes substitute(\_ _);
#delimit cr




/*------------------------------------------------------------------------------

 Table 10: Unemployment
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear

** I. Baseline regression with unemployment rate
* baseline
xtivreg2 unrate_Fd3 L1D3HHD_GDP L1D3NFD_GDP if mainsmp1==1 & L1D3NFD_GDP~=. & lnGDP_Fd3~=., fe cluster(CountryCode year)
est store ur_1
estadd local FE "\checkmark"
estadd local comment "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

* lagged DV
xtivreg2 unrate_Fd3 L1D3HHD_GDP L1D3NFD_GDP L(1/3).unrate_d1 if mainsmp1==1 & L1D3NFD_GDP~=. & lnGDP_Fd3~=., fe cluster(CountryCode year)
est store ur_2
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
estadd local comment "Full"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'


** II. Unemployment rate regression by exchange rate regime
xtivreg2 unrate_Fd3 L1D3HHD_GDP L1D3NFD_GDP L(1/3).unrate_d1 if mainsmp1==1 & ERA_coarse2==1 & lnGDP_Fd3~=., fe cluster(CountryCode year)
est store u_Fixed
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

xtivreg2 unrate_Fd3 L1D3HHD_GDP L1D3NFD_GDP L(1/3).unrate_d1 if mainsmp1==1 & ERA_coarse2==2 & lnGDP_Fd3~=., fe cluster(CountryCode year)
est store u_Int
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'

xtivreg2 unrate_Fd3 L1D3HHD_GDP L1D3NFD_GDP L(1/3).unrate_d1 if mainsmp1==1 & ERA_coarse2==3 & lnGDP_Fd3~=., fe cluster(CountryCode year)
est store u_Float
estadd local FE "\checkmark"
estadd local Dy "\checkmark"
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.3f r(p)
estadd local tst = `pval'


#delimit;
esttab ur_1 ur_2   u_Fixed u_Int u_Float 
       using "${destination}/Table_unrate_and_heterogeneity.tex", 
	   keep(L1D3HHD_GDP L1D3NFD_GDP ) 
	   replace compress b(a3) se(a3)   star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("FE Country fixed effects" "Dy Distributed lag in \(\Delta u \)" "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "r2 \(R^2\)") 
	   mgroups("Full Sample" "\shortstack{Fixed ER \\ Regimes}" "Intermediate" "Freely floating" "\shortstack{Net foreign \\ borrower}", pattern(1 0 1 1 1 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   booktabs label  nonotes substitute(\_ _);
#delimit cr



	
/*------------------------------------------------------------------------------

 Table 11: House Prices and Household Debt
 
------------------------------------------------------------------------------*/
	
cap est drop *
use "${path}/masterdata_annual.dta", clear
label var L1D3lnRHPIq4 "\( \Delta_3 \ln(P_{it-1}^{Housing}) \) " 

* correlation between HP growth and HHD growth
eststo: xtivreg2  L1D3lnRHPIq4 L1D3HHD_GDP if mainsmp1==1 & lnGDP_Fd3~=. & L1D3NFD_GDP~=. , fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
	
* HP main OLS specification alone and as control	

	* hpi as control
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1D3lnRHPIq4 			          if mainsmp1==1 , fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
	* control for lagged GDP growth
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1D3lnRHPIq4 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if mainsmp1==1 , fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Full"
estadd local LDV "\checkmark"

	* pre 2000
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1D3lnRHPIq4 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if mainsmp1==1 & year <=2003, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local smp "Pre 2006"
estadd local LDV "\checkmark"

	* year FE
tab year, gen(year_)
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1D3lnRHPIq4 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 year_* if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local TE "\checkmark"
estadd local smp "Full"
estadd local LDV "\checkmark"

* Table (tex): House Prices;
#delimit ;
esttab using "${destination}/Table_HousePrices.tex", 
	   keep( L1D3HHD_GDP L1D3NFD_GDP L1D3lnRHPIq4 ) 
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant nomtitles
	   obslast  scalars("FE Country fixed effects" "LDV Distributed lag in $\Delta y$ "  "TE Year fixed effects" "smp Sample" "r2 \(R^2\)") 
	   mgroups("\( \Delta_3 \ln(P^{Housing}_{it-1}) \)" "\( \Delta_3 y_{it+3} \) ", pattern(1 1 0 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   booktabs label  nonotes substitute(\_ _);
#delimit cr	   


	


/*------------------------------------------------------------------------------

 Table 12: External components and Global cycle
 Figure A: Correlation with global cycle excluding country i

------------------------------------------------------------------------------*/

use "${path}/masterdata_annual.dta", clear		
cap est drop *

** create variables
gen NX_ifs_Fd3_GDPt = (NX_ifs_Fd3 / GDP_currentUSD ) * 1000000 * 100
gen X_ifs_Fd3_GDPt  = (X_ifs_Fd3 / GDP_currentUSD )  * 1000000 * 100
gen Im_ifs_Fd3_GDPt = (Im_ifs_Fd3 / GDP_currentUSD ) * 1000000 * 100
* mean total trade
gen X_Im_GDP = X_ifs_GDP + Im_ifs_GDP
egen mean_X_Im_GDP = mean(X_Im_GDP) if mainsmp1==1, by(CountryCode)
* L1HHD_GDP x trade/gdp share
gen L1D3HHD_GDPxmeanX_Im = L1D3HHD_GDP*mean_X_Im_GDP / 100

local yvars "NX_ifs_Fd3_GDPt lnX_Im_ifs_Fd3  X_ifs_Fd3_GDPt Im_ifs_Fd3_GDPt s_Imc_Fd3" 
foreach y in `yvars' {
	eststo: qui xtivreg2 `y' L1D3HHD_GDP L1D3NFD_GDP L(1/3).lnGDP_d1  if mainsmp1==1 & lnGDP_Fd3 ~=., fe cluster(CountryCode year)
	estadd local FE "\checkmark"
	estadd local LDV "\checkmark"
	test L1D3HHD_GDP == L1D3NFD_GDP
	local pval: display %9.3f r(p)
	estadd local tst = `pval'
}

* openess
eststo: qui xtivreg2 NX_ifs_Fd3_GDPt L1D3HHD_GDP L1D3HHD_GDPxmeanX_Im L1D3NFD_GDP L(1/3).lnGDP_d1 if mainsmp1==1 & lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* openess with time fixed effects
tab year, gen(year_)
eststo: qui xtivreg2 NX_ifs_Fd3_GDPt L1D3HHD_GDP L1D3HHD_GDPxmeanX_Im L1D3NFD_GDP L(1/3).lnGDP_d1 year_* if mainsmp1==1 & lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local TE "\checkmark"
estadd local LDV "\checkmark"


** Compute average global credit expansion excluding country i
* pre-allocate dataset
clear
tempfile worldcreditseries
save `worldcreditseries', empty replace


forv i=1/30 {
	use "${path}/masterdata_annual.dta", clear
	drop if mainsmp1!=1
	egen id = group(CountryCode)
	* indicator that row t has all variables
	gen indicator = (D3HHD_GDP ~=. & D3NFD_GDP~=. & lnGDP~=.)
	qui sum CountryCode if id==`i'
	local code = r(mean)
	* drop country i
	drop if id==`i' 
	
	collapse (mean) W_i_D3HHD_GDP=D3HHD_GDP    W_i_D3NFD_GDP=D3NFD_GDP    ///
			 if indicator==1 , by(year)
	gen CountryCode = `code'
	tempfile W_`i'
	save    `W_`i''
	use `worldcreditseries'
	append using `W_`i''
	save `worldcreditseries', replace
}

* merge world credit variable back onto main dataset
use "${path}/masterdata_annual.dta", clear
drop if mainsmp1!=1
merge 1:1 CountryCode year using `worldcreditseries', keep(1 3) nogen
xtset CountryCode year, yearly
egen corr_HHD_W = corr( D3HHD_GDP W_i_D3HHD_GDP ), by(CountryCode)
egen corr_NFD_W = corr( D3NFD_GDP W_i_D3NFD_GDP ), by(CountryCode)

*** Table 12 (cont.)

* variables
gen L1W_i_D3HHD_GDP = L.W_i_D3HHD_GDP
label var L1W_i_D3HHD_GDP " $ \text{Global}_{-i} \Delta_3 d^{HH}_{it-1} $ "
gen L1D3HHD_GDPxcorr_HHD_W = L1D3HHD_GDP*corr_HHD_W
label var L1D3HHD_GDPxcorr_HHD_W "$ \Delta_3 d^{HH}_{it-1}  \times \rho_i^{Global} $"
gen NX_ifs_Fd3_GDPt = (NX_ifs_Fd3 / GDP_currentUSD ) * 1000000 * 100
gen X_ifs_Fd3_GDPt  = (X_ifs_Fd3 / GDP_currentUSD )  * 1000000 * 100
gen Im_ifs_Fd3_GDPt = (Im_ifs_Fd3 / GDP_currentUSD ) * 1000000 * 100


* Column (1): interaction with world beta
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3HHD_GDPxcorr_HHD_W L1D3NFD_GDP L(1/3).lnGDP_d1 if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* Column (2): interaction with world beta, net exports
eststo: xtivreg2 NX_ifs_Fd3_GDPt L1D3HHD_GDP L1D3HHD_GDPxcorr_HHD_W L1D3NFD_GDP L(1/3).lnGDP_d1 /*L1D3NFD_GDPxcorr*/ if mainsmp1==1 & lnGDP_Fd3~=., fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* Column (3): include global household credit expansion
eststo: xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1W_i_D3HHD_GDP L(1/3).lnGDP_d1 if mainsmp1==1, fe cluster(CountryCode year)
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* labels
label var NX_ifs_Fd3_GDPt  "$ \frac{\Delta_3 NX_{it+3}}{Y_{it}} $" 
label var lnX_Im_ifs_Fd3   "$ \Delta_3 \ln \frac{X_{it+3}}{M_{it+3}} $"
label var X_ifs_Fd3_GDPt   "$ \frac{\Delta_3 X_{it+3}}{Y_{it}} $ "
label var Im_ifs_Fd3_GDPt  "$\frac{ \Delta_3 M_{it+3}}{Y_{it}}$"
label var s_Imc_Fd3        "\( \Delta_3 s^{MC}_{it+3} \)"

#delimit ;
* Table: Global Credit Cycles;
esttab using "${destination}/Table_components_global.tex", 
	   keep(L1D3HHD_GDP   L1D3NFD_GDP L1D3HHD_GDPxmeanX_Im L1D3HHD_GDPxcorr_HHD_W L1W_i_D3HHD_GDP) 
	   order(L1D3HHD_GDP   L1D3NFD_GDP L1D3HHD_GDPxmeanX_Im L1D3HHD_GDPxcorr_HHD_W L1W_i_D3HHD_GDP) 
	   coeflabels(L1D3HHD_GDPxmeanX_Im "$ \Delta_3 d^{HH}_{it-1} \times \text{openness}_i $ ")
	   replace compress b(a2) se(a2)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant
	   obslast  scalars("FE Country fixed effects" "LDV Distributed lag in $\Delta y$" "TE Year fixed effects"  "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "r2 \(R^2\)") 
	   booktabs label  nonotes substitute(\_ _) ;  
#delimit cr



*** Figure: Correlation (beta) with global factor
#delimit ;
graph bar corr_HHD_W if mainsmp1==1, over(countrycode, sort( (mean) corr_HHD_W )  label(angle(90)) )
	  name(beta_with_world,replace)  ytitle("")  bar(1, color(navy)) bar(2,color(maroon))
	  legend(order( 1 "Household" 2 "NF Firm")) ;
graph export "${destination}/Fig_beta_worldcredit.png", replace;
#delimit cr





/*------------------------------------------------------------------------------

 Table 13:  Global Time Series
 Table 6A:  Global Time Series Robustness
 Figure 7:  Global Time Series Scatterplots
 
------------------------------------------------------------------------------*/


*** Aggregate: Raw sum across countries
use "${path}/masterdata_annual.dta", clear
drop if c_mainsmp~=1
drop if CREDIT_ANA_USD==. 
keep CountryCode countrycode year CREDIT_AHA_USD CREDIT_ANA_USD GDP_currentUSD GDP_realUSD
gen HHD = CREDIT_AHA_USD
gen NFD = CREDIT_ANA_USD
gen Y   = GDP_currentUSD

gen L4NFD0 = L4.NFD if L4.NFD~=.
gen L1NFD0 = L1.NFD if L4.NFD~=.
gen L4HHD0 = L4.HHD if L4.NFD~=.
gen L1HHD0 = L.HHD  if L4.NFD~=.
gen L4Y0   = L4.Y  if L4.NFD~=.
gen L1Y0   = L.Y   if L4.NFD~=.
gen F5y0   = F5.GDP_realUSD2005 if L4.NFD~=.
gen F3y0   = F3.GDP_realUSD2005 if L4.NFD~=.
gen   y0   =    GDP_realUSD2005 if L4.NFD~=.
forv i=1/4{
gen   L`i'y0   =  L`i'.GDP_realUSD2005 if L4.NFD~=.
} 
collapse (sum) L4HHD0 L1HHD0 L4NFD0 L1NFD0 ///
			   L1y0 L2y0 L3y0 L4y0 ///
               L4Y0 L1Y0 ///
			   y0 F3y0 F5y0, by(year)
  
gen L1D3HHD_GDP_SUM = 100*( L1HHD0/L1Y0 - L4HHD0/L4Y0 )
gen L1D3NFD_GDP_SUM = 100*( L1NFD0/L1Y0 - L4NFD0/L4Y0 )

gen L1y_d1_SUM = 100*( log(L1y0)-log(L2y0) )
gen L2y_d1_SUM = 100*( log(L2y0)-log(L3y0) )
gen L3y_d1_SUM = 100*( log(L3y0)-log(L4y0) )

gen y_Fd3_SUM = 100*( log(F3y0) - log(y0) )
gen y_Fd5_SUM = 100*( log(F5y0) - log(y0) )
 
tempfile SUM
save    `SUM'


*** Aggregate: Unweighted average

use "${path}/masterdata_annual.dta", clear
drop if mainsmp1!=1
gen L1lnGDP_Fd3 = L1.lnGDP_Fd3
gen indicator = (L1D3HHD_GDP~=. & L1D3NFD_GDP~=. & lnGDP_Fd1~=. )  
collapse L1D3HHD_GDP L1D3NFD_GDP lnGDP_Fd* L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1lnGDP_Fd3 ///
         lnGDP_d1 lnGDP_d3 if indicator==1 , by(year)

merge 1:1 year using `SUM', keep(1 3) nogen
tsset year, yearly

gen t = year -1963
gen t2 = t*t
label var L1D3HHD_GDP "Global $\Delta_3 d^{HH}_{t-1}$"
label var L1D3NFD_GDP "Global $\Delta_3 d^F_{t-1}$" 
label var lnGDP_Fd3   "Global $\Delta_3 y_{t+3}$" 
label var L1lnGDP_d1   "Global $\Delta y_{t-1}$"
label var L2lnGDP_d1   "Global $\Delta y_{t-2}$"
label var L3lnGDP_d1   "Global $\Delta y_{t-3}$"
label var t " Trend"
label var t2 "\( \text{Trend}^2 \)"
label var L1D3HHD_GDP_SUM "Global agg. $\Delta_3 d^{HH}_{t-1}$"
label var L1D3NFD_GDP_SUM "Global agg. $\Delta_3 d^F_{t-1}$" 
label var y_Fd3_SUM   "Global agg. $\Delta_3 y_{t+3}$" 
label var L1y_d1_SUM   "Global agg. $\Delta y_{t-1}$"
label var L2y_d1_SUM   "Global agg. $\Delta y_{t-2}$"
label var L3y_d1_SUM   "Global agg. $\Delta y_{t-3}$"



****************************************
*** Table 13: Global Time Series	   


* Column (1)
qui reg lnGDP_Fd3 L1D3HHD_GDP // get R2 
local R2: display %5.3f e(r2)
newey lnGDP_Fd3 L1D3HHD_GDP, lag(6) 
est store global_1
estadd local smpl "Full"
estadd local R2 = `R2'
	
* Column (2)
qui reg lnGDP_Fd3 L1D3NFD_GDP //get R2
local R2: display %5.3f e(r2)
newey lnGDP_Fd3 L1D3NFD_GDP, lag(6)
est store global_2
estadd local smpl "Full"
estadd local R2 = `R2'

* Column (3)
qui reg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP
local R2: display %5.3f e(r2)
newey lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP, lag(6)
est store global_3
estadd local smpl "Full"
estadd local R2 = `R2'
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'

* Column (4)
qui reg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1
local R2: display %5.3f e(r2)
newey lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 , lag(6)
est store global_4
estadd local smpl "Full"
estadd local R2=`R2'	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'
	
* Column (5)
qui reg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if year<=2003
local R2: display %5.3f e(r2)
qui newey lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if year<=2003, lag(6)
est store global_5
estadd local smpl "Pre 2006"
estadd local R2 = `R2'
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'

	
* Table 12: Global Time Series Regression;
#delimit ;
esttab global_1 global_2 global_3 global_4 global_5 
       using "${destination}/Table_globaltimeseries.tex", 
	   keep(L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 ) nomtitle
	   scalars("smpl Sample" "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "R2 $ R^2$")
	   mgroups( "Dependent variable: global average \( \Delta_3 y_{t+3}\)" , pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 )  
	   obslast  noconstant
	   booktabs label  nonotes substitute(\_ _) ;  
#delimit cr	   

	   
   
	   
****************************************
*** Appendix Table	A6   
	

cap est drop *
	
*** (1)-(2) Trend	
qui reg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t
local R2: display %5.3f e(r2)
newey lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t , lag(6)
est store t11 
estadd local smpl "Full"
estadd local LDV "\checkmark"
estadd local R2=`R2'	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'

* ex Great Recession
qui reg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t if year<=2003
local R2: display %5.3f e(r2)
eststo t12: newey lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t if year<=2003 , lag(6)
estadd local smpl "Pre 2006"
estadd local LDV "\checkmark"
estadd local R2=`R2'	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'

*** (3)-(4) Quadratic Trend	
qui reg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t t2
local R2: display %5.3f e(r2)
eststo t21: newey lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t t2, lag(6)
estadd local smpl "Full"
estadd local LDV "\checkmark"
estadd local R2=`R2'	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'

* ex Great Recession
qui reg lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t t2 if year<=2003
local R2: display %5.3f e(r2)
eststo t22: newey lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 t t2 if year<=2003 , lag(6)
estadd local smpl "Pre 2006"
estadd local LDV "\checkmark"
estadd local R2=`R2'	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'


*** (5)-(6) Sum Instead of Unweighted Average

qui reg y_Fd3_SUM L1D3HHD_GDP_SUM L1D3NFD_GDP_SUM L1y_d1_SUM L2y_d1_SUM L3y_d1_SUM
local R2: display %5.3f e(r2)
eststo s1: newey y_Fd3_SUM L1D3HHD_GDP_SUM L1D3NFD_GDP_SUM L1y_d1_SUM L2y_d1_SUM L3y_d1_SUM , lag(6)
estadd local smpl "Full"
estadd local LDV "\checkmark"
estadd local R2=`R2'	
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'
	
* ex Great Recession
qui reg y_Fd3_SUM L1D3HHD_GDP_SUM L1D3NFD_GDP_SUM L1y_d1_SUM L2y_d1_SUM L3y_d1_SUM if year<=2003
local R2: display %5.3f e(r2)
eststo s2: newey y_Fd3_SUM L1D3HHD_GDP_SUM L1D3NFD_GDP_SUM L1y_d1_SUM L2y_d1_SUM L3y_d1_SUM if year<=2003, lag(6)
estadd local smpl "Pre 2006"
estadd local LDV "\checkmark"
estadd local R2 = `R2'
test L1D3HHD_GDP == L1D3NFD_GDP
local pval: display %9.4f r(p)
estadd local tst = `pval'



* Table: Appendix;
#delimit ;
esttab t11 t12 t21 t22 s1 s2
       using "${destination}/Table_globaltimeseries_app.tex", 
	   keep(L1D3HHD_GDP_SUM L1D3NFD_GDP_SUM L1D3HHD_GDP L1D3NFD_GDP t t2 ) 
	   order(L1D3HHD_GDP L1D3NFD_GDP L1D3HHD_GDP_SUM L1D3NFD_GDP_SUM t t2 ) 
	   scalars("smpl Sample" "LDV Distributed lag in $\Delta y$" "tst Test for equality of \\ \hspace{.2cm}  \( \beta_{HH}\) and \( \beta_F,\) p-value" "R2 $ R^2$")
	   mgroups( "\shortstack{Dependent variable: \\ global average \( \Delta_3 y_{t+3}\)}" "\shortstack{Dependent variable: \\ global aggregate \( \Delta_3 y_{t+3}\)}" , pattern(1 0 0 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 )  
	   obslast nomtitle  noconstant booktabs label  nonotes substitute(\_ _) ;  
#delimit cr	   
	
	
	   
*** Figure 7   
* Figure: Global HHD Forecast;
#delimit ;
twoway scatter lnGDP_Fd3 L1D3HHD_GDP , name(scatter_world_HHD,replace)
       m(i) mlab(year) mlabsize(vsmall) mlabposition(0) mlabcolor(gs10)
	   ytitle("Global average GDP growth, t to t+3" ) xtitle("Global Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit lnGDP_Fd3 L1D3HHD_GDP, color(black) legend(off);
graph export "${destination}/Fig_scatter_worldHHD.png", replace;

reg L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=. ;
predict r_L1D3HHD_GDP, res ;
twoway scatter lnGDP_Fd3 r_L1D3HHD_GDP , name(scatter_world_HHD_partial,replace)
       m(i) mlab(year) mlabsize(vsmall) mlabposition(0) mlabcolor(gs10)
	   ytitle("Global average GDP growth, t to t+3" ) xtitle("Global Household Debt to GDP Expansion, t-4 to t-1" ) ||        
	   lfit lnGDP_Fd3 r_L1D3HHD_GDP, color(black) legend(off);
graph export "${destination}/Fig_scatter_worldHHD_partial.png", replace;

reg L1D3NFD_GDP L1D3HHD_GDP if lnGDP_Fd3~=. ;
predict r_L1D3NFD_GDP, res ;
twoway scatter lnGDP_Fd3 r_L1D3NFD_GDP , name(scatter_world_NFD,replace)
       m(i) mlab(year) mlabsize(vsmall) mlabposition(0) mlabcolor(gs10)
	   ytitle("Global average GDP growth, t to t+3" ) xtitle("Global NF Firm Debt to GDP Expansion, t-4 to t-1")  ||        
	   lfit lnGDP_Fd3 r_L1D3NFD_GDP , color(black) legend(off);
graph export "${destination}/Fig_scatter_worldNFD_partial.png", replace;
#delimit cr







	   
	   
	   
	   
	   

/*------------------------------------------------------------------------------

 Figure 2 : Robustness with Jorda LP IRF
 Figure A4
 
------------------------------------------------------------------------------*/

use "${path}/masterdata_annual.dta", clear
forv i=0/10{
	gen F`i'y = F`i'.lnGDP * 100
}
forv i=0/5{
	gen L`i'HHD_L1GDP = L`i'.HHD_L1GDP
	gen L`i'NFD_L1GDP = L`i'.NFD_L1GDP
	
	gen L`i'HHD_GDP = L`i'.HHD_GDP
	gen L`i'NFD_GDP = L`i'.NFD_GDP
	
	gen L`i'y = L`i'.lnGDP * 100
	gen L`i'D1y = L`i'.lnGDP_d1 
}
gen trend = year
tab year, gen(year_)
tempfile DATA
save    `DATA'


	

*** Jorda VAR, Levels
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	xtivreg2 F`t'y L0HHD_L1GDP L1HHD_L1GDP L2HHD_L1GDP L3HHD_L1GDP L4HHD_L1GDP  ///
                   L0NFD_L1GDP L1NFD_L1GDP L2NFD_L1GDP L3NFD_L1GDP L4NFD_L1GDP  ///
			       L0y L1y L2y L3y L4y ///
				   if mainsmp1==1, fe cluster(CountryCode year) //partial(L1HHD_L1GDP L2HHD_L1GDP L3HHD_L1GDP L4HHD_L1GDP L1NFD_L1GDP L2NFD_L1GDP L3NFD_L1GDP L4NFD_L1GDP L0y L1y L2y L3y L4y)
	
	use `JORDA', clear
	replace b_HH = _b[L0HHD_L1GDP]      if hor == `t'
	replace b_F  = _b[L0NFD_L1GDP]      if hor == `t'
	replace se_HH= _se[L0HHD_L1GDP]     if hor == `t'
	replace se_F = _se[L0NFD_L1GDP]     if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}

# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1 .1 .6)) ylabel(#10)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_BASELINE,replace) ;		   
	graph export "${destination}/Fig_JordaVAR.pdf", as(pdf) replace;
# delimit cr

*** Jorda VAR with Time Trend
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	xtivreg2 F`t'y L0HHD_L1GDP L1HHD_L1GDP L2HHD_L1GDP L3HHD_L1GDP L4HHD_L1GDP  ///
                   L0NFD_L1GDP L1NFD_L1GDP L2NFD_L1GDP L3NFD_L1GDP L4NFD_L1GDP  ///
			       L0y L1y L2y L3y L4y  ///
				   trend /// INCLUDE A TIME TREND
				   if mainsmp1==1, fe cluster(CountryCode year)
	
	use `JORDA', clear
	replace b_HH= _b[L0HHD_L1GDP]        if hor == `t'
	replace b_F = _b[L0NFD_L1GDP]        if hor == `t'
	replace se_HH= _se[L0HHD_L1GDP]      if hor == `t'
	replace se_F = _se[L0NFD_L1GDP]      if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}


# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1.0 .1 .6)) ylabel(#10)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_TREND,replace) ;		   
	   graph export "${destination}/Fig_JordaVAR_Trend.pdf", as(pdf) replace;
# delimit cr


*** Baseline Jorda VAR, Differences
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	xtivreg2 lnGDP_Fd`t' D1HHD_GDP L1D1HHD_GDP L2D1HHD_GDP L3D1HHD_GDP L4D1HHD_GDP  ///
                         D1NFD_GDP L1D1NFD_GDP L2D1NFD_GDP L3D1NFD_GDP L4D1NFD_GDP  ///
			             L0D1y     L1D1y       L2D1y       L3D1y       L4D1y    ///
				         if mainsmp1==1 , fe cluster(CountryCode year)

	use `JORDA', clear
	replace b_HH = _b[D1HHD_GDP]      if hor == `t'
	replace b_F  = _b[D1NFD_GDP]      if hor == `t'
	replace se_HH= _se[D1HHD_GDP]     if hor == `t'
	replace se_F = _se[D1NFD_GDP]     if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}


# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1 .2 .6)) ylabel(#11)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_diff,replace) ;		   
	graph export "${destination}/Fig_JordaVAR_diff.pdf", as(pdf) replace;
# delimit cr



*** Jorda VAR, Differences, Trend
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	xtivreg2 lnGDP_Fd`t' D1HHD_GDP L1D1HHD_GDP L2D1HHD_GDP L3D1HHD_GDP L4D1HHD_GDP  ///
                         D1NFD_GDP L1D1NFD_GDP L2D1NFD_GDP L3D1NFD_GDP L4D1NFD_GDP  ///
			             L0D1y L1D1y L2D1y L3D1y L4D1y   ///
						 trend ///
				         if mainsmp1==1 , fe cluster(CountryCode year)
	
	use `JORDA', clear
	replace b_HH = _b[D1HHD_GDP]      if hor == `t'
	replace b_F  = _b[D1NFD_GDP]      if hor == `t'
	replace se_HH= _se[D1HHD_GDP]     if hor == `t'
	replace se_F = _se[D1NFD_GDP]     if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}


# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1 .1 .6)) ylabel(#10)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_diff_trend,replace) ;		   
	graph export "${destination}/Fig_JordaVAR_diff_trend.pdf", as(pdf) replace;
# delimit cr


*** Jorda VAR, Excl Great Recession
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	local end = 2006 - `t'
	xtivreg2 F`t'y L0HHD_L1GDP L1HHD_L1GDP L2HHD_L1GDP L3HHD_L1GDP L4HHD_L1GDP  ///
                   L0NFD_L1GDP L1NFD_L1GDP L2NFD_L1GDP L3NFD_L1GDP L4NFD_L1GDP  ///
			       L0y L1y L2y L3y L4y   ///
				   if mainsmp1==1 & year<=`end', fe cluster(CountryCode year)
	
	use `JORDA', clear
	replace b_HH = _b[L0HHD_L1GDP]      if hor == `t'
	replace b_F  = _b[L0NFD_L1GDP]      if hor == `t'
	replace se_HH= _se[L0HHD_L1GDP]     if hor == `t'
	replace se_F = _se[L0NFD_L1GDP]     if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}


# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1 .1 .6)) ylabel(#10)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_pre2000,replace) ;		   
	graph export "${destination}/Fig_JordaVAR_pre2000.pdf", as(pdf) replace;
# delimit cr

*** Jorda VAR, Excl Great Recession, Trend
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	local end = 2006 - `t'
	xtivreg2 F`t'y L0HHD_L1GDP L1HHD_L1GDP L2HHD_L1GDP L3HHD_L1GDP L4HHD_L1GDP  ///
                   L0NFD_L1GDP L1NFD_L1GDP L2NFD_L1GDP L3NFD_L1GDP L4NFD_L1GDP  ///
			       L0y L1y L2y L3y L4y   ///
				   trend ///
				   if mainsmp1==1 & year<=`end', fe cluster(CountryCode year)
	
	use `JORDA', clear
	replace b_HH = _b[L0HHD_L1GDP]      if hor == `t'
	replace b_F  = _b[L0NFD_L1GDP]      if hor == `t'
	replace se_HH= _se[L0HHD_L1GDP]     if hor == `t'
	replace se_F = _se[L0NFD_L1GDP]     if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}


# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1 .1 .6)) ylabel(#10)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_pre2000_trend,replace) ;		   
	graph export "${destination}/Fig_JordaVAR_pre2000_trend.pdf", as(pdf) replace;
# delimit cr

*** Jorda VAR, Differences, Excl Great Recession
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	local end = 2006 - `t'
	xtivreg2 lnGDP_Fd`t' D1HHD_GDP L1D1HHD_GDP L2D1HHD_GDP L3D1HHD_GDP L4D1HHD_GDP  ///
                         D1NFD_GDP L1D1NFD_GDP L2D1NFD_GDP L3D1NFD_GDP L4D1NFD_GDP  ///
			             L0D1y L1D1y L2D1y L3D1y L4D1y   ///
				   if mainsmp1==1 & year<=`end', fe cluster(CountryCode year)
	
	use `JORDA', clear
	replace b_HH = _b[D1HHD_GDP]      if hor == `t'
	replace b_F  = _b[D1NFD_GDP]      if hor == `t'
	replace se_HH= _se[D1HHD_GDP]     if hor == `t'
	replace se_F = _se[D1NFD_GDP]     if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}


# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1 .1 .6)) ylabel(#10)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_pre2000_diff,replace) ;		   
	graph export "${destination}/Fig_JordaVAR_diff_pre2000.pdf", as(pdf) replace;
# delimit cr




*** Baseline Jorda VAR, Differences, Excl Great Recession, Trend
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen se_HH  = 0 if hor==0
gen b_F    = 0 if hor==0
gen se_F   = 0 if hor==0 
save `JORDA', empty replace	

forv t=1/10 {
	use `DATA', clear
	local end = 2006 - `t'
	xtivreg2 lnGDP_Fd`t' D1HHD_GDP L1D1HHD_GDP L2D1HHD_GDP L3D1HHD_GDP L4D1HHD_GDP  ///
                         D1NFD_GDP L1D1NFD_GDP L2D1NFD_GDP L3D1NFD_GDP L4D1NFD_GDP  ///
			             L0D1y L1D1y L2D1y L3D1y L4D1y   ///
						 trend ///
				   if mainsmp1==1 & year<=`end', fe cluster(CountryCode year)
	
	use `JORDA', clear
	replace b_HH = _b[D1HHD_GDP]      if hor == `t'
	replace b_F  = _b[D1NFD_GDP]      if hor == `t'
	replace se_HH= _se[D1HHD_GDP]     if hor == `t'
	replace se_F = _se[D1NFD_GDP]     if hor == `t'
	save `JORDA', replace
		
}
foreach X in HH F {
	gen `X'u = b_`X' + 1.96*se_`X'
	gen `X'l = b_`X' - 1.96*se_`X'
}


# delimit ;
twoway connected b_HH HHl HHu b_F Fu Fl hor ,
	   ytitle("") yscale(range(-1 .1 .6)) ylabel(#10)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid dash dash solid dash dash) lcolor(black black black navy navy navy)
	   mcolor(black black black navy navy navy)  msymbol(O i i S i i) 
	   legend(order(1 "Household" 4 "Firm")) 
	   name(JORDA_pre2000_diff_trend,replace) ;		   
	graph export "${destination}/Fig_JordaVAR_diff_pre2000_trend.pdf", as(pdf) replace;
# delimit cr


*** Baseline Jorda VAR, One-Year Differences
clear
tempfile JORDA
set obs 11
gen hor    = _n - 1
gen b_HH   = 0 if hor==0
gen b_F    = 0 if hor==0
gen pdiff  = 0 if hor==0
save `JORDA', empty replace	


forv t=1/10 {
	use `DATA', clear
	
	xtivreg2 F`t'.lnGDP_d1 D1HHD_GDP L1D1HHD_GDP L2D1HHD_GDP L3D1HHD_GDP L4D1HHD_GDP  ///
                         D1NFD_GDP L1D1NFD_GDP L2D1NFD_GDP L3D1NFD_GDP L4D1NFD_GDP  ///
			             L0D1y     L1D1y       L2D1y       L3D1y       L4D1y    ///
				         if mainsmp1==1 , fe cluster(CountryCode year)
	
	test D1HHD_GDP==D1NFD_GDP
	local p: display %9.3f r(p)
	use `JORDA', clear
	replace b_HH = _b[D1HHD_GDP]      if hor == `t'
	replace b_F  = _b[D1NFD_GDP]      if hor == `t'
	replace pdiff= `p'                if hor == `t'
	save `JORDA', replace
		
}


# delimit ;
twoway connected b_HH b_F hor ,
	   ytitle("") yscale(range(-.5 .2 .4)) ylabel(#11)
	   xtitle("Years after shock") xlabel(#10)
	   lpattern(solid solid ) lcolor(black navy )
	   mcolor(black navy )  msymbol(O S)  mlab(pdiff) mlabpos(6) 
	   legend(order(1 "Household" 2 "Firm")) 
	   name(JORDA_diff,replace) ;		   
	graph export "${destination}/Fig_JordaVAR_oneyeardiff.pdf", as(pdf) replace;
# delimit cr




			  
*** Implied decline in GDP from t=3 to t=6 and SE 
use `DATA', clear		  
xtivreg2 F3.lnGDP_Fd3 L0HHD_L1GDP L1HHD_L1GDP L2HHD_L1GDP L3HHD_L1GDP L4HHD_L1GDP   ///
                      L0NFD_L1GDP L1NFD_L1GDP L2NFD_L1GDP L3NFD_L1GDP L4NFD_L1GDP   ///
			          L0y L1y L2y L3y L4y  ///
				      if mainsmp1==1, fe cluster(CountryCode year) partial(L1HHD_L1GDP L2HHD_L1GDP L3HHD_L1GDP L4HHD_L1GDP  L1NFD_L1GDP L2NFD_L1GDP L3NFD_L1GDP L4NFD_L1GDP L0y L1y L2y L3y L4y )
test L0HHD_L1GDP==L0NFD_L1GDP






/*------------------------------------------------------------------------------

 Figure 3: Scatterplot
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear
lowess lnGDP_Fd3 L1D3HHD_GDP,  nograph generate(lnGDP_Fd3_lowess)
sort L1D3HHD_GDP
# delimit;		
twoway scatter lnGDP_Fd3 L1D3HHD_GDP if mainsmp1==1, name(scatterHHD,replace)
       m(i) mlab(c_yr) mlabsize(tiny) mlabcolor(gs10) mlabposition(0)
	   ytitle("GDP growth, t to t+3" ) xtitle("Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit lnGDP_Fd3 L1D3HHD_GDP if mainsmp1==1, color(black) legend(off) lwidth(medthick) ||
	   scatter lnGDP_Fd3_lowess L1D3HHD_GDP if L1D3HHD_GDP>-10, m(i) connect(l) lpattern(dash) lcolor(black) ;    
graph export "${destination}/Fig_scatter_HHD.png", replace;


* partial out NF debt;
reg L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=.;
predict r_L1D3HHD_GDP, res;

lowess lnGDP_Fd3 r_L1D3HHD_GDP, nograph generate(lnGDP_Fd3_partial1_lowess);
sort r_L1D3HHD_GDP;
twoway scatter lnGDP_Fd3 r_L1D3HHD_GDP if mainsmp1==1, name(scatterHHD_partial,replace)
       m(i) mlab(c_yr) mlabsize(tiny) mlabposition(0) mlabcolor(gs10) xscale(range(-20 30))
	   ytitle("GDP growth, t to t+3" ) xtitle("Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit lnGDP_Fd3 r_L1D3HHD_GDP if mainsmp1==1, color(black) lwidth(medthick) legend(off)  ||
	   scatter lnGDP_Fd3_partial1_lowess r_L1D3HHD_GDP if r_L1D3HHD_GDP>-15, m(i) connect(l) lpattern(dash) lcolor(black) ;        
graph export "${destination}/Fig_scatter_HHD_partial.png", replace;

* partial out HH debt;
reg L1D3NFD_GDP L1D3HHD_GDP if lnGDP_Fd3~=.;
predict r_L1D3NFD_GDP, res;

lowess lnGDP_Fd3 r_L1D3NFD_GDP, nograph generate(lnGDP_Fd3_partial2_lowess);
sort r_L1D3NFD_GDP;
twoway scatter lnGDP_Fd3 r_L1D3NFD_GDP if mainsmp1==1 & r_L1D3NFD_GDP< 50 , name(scatterNFD_partial,replace)
       m(i) mlab(c_yr) mlabsize(tiny) mlabposition(0) mlabcolor(gs10) xscale(range(-50 50))
	   ytitle("GDP growth, t to t+3" ) xtitle("NF Firm Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit lnGDP_Fd3 r_L1D3NFD_GDP if mainsmp1==1, color(black) lwidth(medthick) legend(off) ||
	   scatter lnGDP_Fd3_partial2_lowess r_L1D3NFD_GDP if r_L1D3NFD_GDP>-50 & r_L1D3NFD_GDP< 50, m(i) connect(l) lpattern(dash) lcolor(black) ;        	   
graph export "${destination}/Fig_scatter_NFD_partial.png", replace;
#delimit cr	  





/*------------------------------------------------------------------------------

 Figure 5: IV examples
 
------------------------------------------------------------------------------*/


*** (a) Eurozone case
use "${path}/masterdata_annual.dta", clear
keep if Continent==3

drop if c_mainsmp~=1
drop if countrycode == "CHE" | countrycode=="CZE" | countrycode=="GBR" | ///
        countrycode == "HUN" | countrycode=="NOR" | countrycode=="SWE" | ///
	    countrycode == "POL" | countrycode=="SVK" | countrycode=="LUX"   
keep if year>=1992

gen spr_r_q4_9699 = spr_r_q4 - L3.spr_r_q4 if year==1999
gen HHD_GDP_0207 = HHD_GDP - L5.HHD_GDP if year==2007
gen NFD_GDP_0207 = NFD_GDP - L5.NFD_GDP if year==2007
gen y_0710   = 100*(lnGDP - L3.lnGDP) if year==2010
gen y_0207   = lnGDP - L5.lnGDP if year==2007
collapse spr_r_q4_9699 HHD_GDP_0207 NFD_GDP_0207 y_0710 y_0207  , by(countrycode CountryCode)

* first stage: 02-07
twoway scatter HHD_GDP_0207 spr_r_q4_9699, ylabel(-10[10]50) mlab(countrycode) mlabsize(small) || ///
       lfit    HHD_GDP_0207 spr_r_q4_9699, name(fs_0207,replace) legend(off) ///
	   title("First Stage") ///
	   xtitle("1996-1999 change in country spread (rel. to US)") ytitle("2002-2007 change in household debt to GDP")
* reduced form 
twoway scatter y_0710 spr_r_q4_9699, mlab(countrycode) mlabsize(small) || ///
       lfit    y_0710 spr_r_q4_9699, name(rf,replace) legend(off) ///
	   title("Reduced Form") ///
	   xtitle("1996-1999 change in country spread (rel. to US)") ytitle("2007-2010 change in log GDP")
* second stage
reg HHD_GDP_0207 spr_r_q4_9699
predict HHD_GDP_hat 
reg y_0710 HHD_GDP_hat
twoway scatter y_0710 HHD_GDP_hat, mlab(countrycode) mlabsize(small) || ///
       lfit    y_0710 HHD_GDP_hat, name(ss,replace) legend(off) ///
	   title("Second Stage") ///
	   xtitle("2002-2007 change in predicted household debt to GDP") ytitle("2007-2010 change in log GDP")
* OLS  
twoway scatter y_0710 HHD_GDP_0207, mlab(countrycode) mlabsize(small) || ///
       lfit    y_0710 HHD_GDP_0207, name(ols,replace) legend(off) ///
	   title("OLS") ///
	   xtitle("2002-2007 change in household debt to GDP") ytitle("2007-2010 change in log GDP")

graph combine fs_0207 rf ss ols
graph export "${destination}/Fig_EuroCase_spr_r_q4_9699.png",replace

*** (b) Mortgage-Sovereign Spread
use "${path}/masterdata_annual.dta", clear	
gen D4ih_ig10  = ih_ig10 - L4.ih_ig10 
drop if countrycode=="HUN"
*** (1) First stage
** 2000-2002 decline in spreads, 2002-2007 rise in HHD
#delimit ;
** 2000-2004 decline in spreads, 2002-2007 rise in HHD;
twoway scatter D5HHD_GDP L3.D4ih_ig10 if year==2007 , mlab(countrycode) mlabsize(small) mlabpos(6) 
    xtitle("2000-2004 change in mortgage-sovereign spread") 
    ytitle("2002-2007 change in household debt to GDP") yscale(range(-10 40)) ylabel(-10(10)40) || 
	lfit D5HHD_GDP L3.D4ih_ig10 if year==2007 & countrycode~="HUN", legend(off) name(FS_MSS_2000_04,replace) title("First Stage") ;
*** (2) Reduced form;
* MS spread from 2000-2004;
twoway scatter lnGDP_Fd3 L3.D4ih_ig10 if year==2007  , mlab(countrycode) mlabsize(small) mlabpos(6)
    xtitle("2000-2004 change in mortgage-sovereign spread") ytitle("2007-2010 change in log GDP") || 
	lfit lnGDP_Fd3 L3.D4ih_ig10 if year==2007 , legend(off) name(RF_MSS_2000_04,replace) title("Reduced Form") ;
*** (3) Second stage;
reg D5HHD_GDP L3.D4ih_ig10 if year==2007 ;  // spr 2000-2004;
predict  D5HHD_GDP_hat;
reg lnGDP_Fd3 D5HHD_GDP_hat if year==2007 ;
twoway scatter lnGDP_Fd3 D5HHD_GDP_hat if year==2007 , mlab(countrycode) mlabsize(small) mlabpos(6)
    xtitle("2002-2007 predicted change in household debt to GDP")  ytitle("2007-2010 change in log GDP") || 
	lfit lnGDP_Fd3 D5HHD_GDP_hat if year==2007 , legend(off) name(SS_MSS_2000_04,replace) title("Second Stage") ;	
*** (4) OLS;
twoway scatter lnGDP_Fd3 D5HHD_GDP if year==2007 & D5HHD_GDP_hat~=. , mlab(countrycode) mlabsize(small) mlabpos(6)
    xtitle("2002-2007 change in household debt to GDP")  ytitle("2007-2010 change in log GDP") || 
	lfit lnGDP_Fd3 D5HHD_GDP if year==2007 & D5HHD_GDP_hat~=. , legend(off) name(OLS,replace) 
	title("OLS");	
#delimit cr

*** Combine graphs
graph combine FS_MSS_2000_04 RF_MSS_2000_04 SS_MSS_2000_04 OLS , name(MSS_2008recession,replace)
graph export "$destination/Fig_MSS_2008recession.png", replace




/*------------------------------------------------------------------------------

 Figure 6: IMF, OECD forecast errors scatterplot
 
------------------------------------------------------------------------------*/


* (a): IMF
use "${path}/masterdata_annual.dta", clear
xtreg Fd3_lnGDP_WEO_F L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=., fe vce(cluster CountryCode)
gen WEOsmp=e(sample)
* forecast
lowess Fd3_lnGDP_WEO_F L1D3HHD_GDP if WEOsmp==1, nograph generate(Fd3_lnGDP_WEO_F_lowess)
sort L1D3HHD_GDP
# delimit;		
twoway scatter Fd3_lnGDP_WEO_F L1D3HHD_GDP if WEOsmp==1, name(scatterWEOHHD,replace)
       m(i) mlab(c_yr) mlabsize(tiny) mlabposition(0) mlabcolor(gs10)
	   ytitle("IMF WEO t to t+3 GDP Forecast" ) xtitle("Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit Fd3_lnGDP_WEO_F L1D3HHD_GDP if WEOsmp==1, color(black) legend(off) lwidth(medthick) ||
	   scatter Fd3_lnGDP_WEO_F_lowess L1D3HHD_GDP if WEOsmp==1 , m(i) connect(l) lpattern(dash) lcolor(black) ;    
graph export "${destination}/Fig_scatter_HHD_WEO.pdf", as(pdf) replace;
#delimit cr

* forecast error
lowess Fd3_WEOerror_F L1D3HHD_GDP if WEOsmp==1, nograph generate(Fd3_WEOerror_F_lowess)
sort L1D3HHD_GDP
# delimit;		
twoway scatter Fd3_WEOerror_F L1D3HHD_GDP if WEOsmp==1, name(scatterWEOerrorHHD,replace)
       m(i) mlab(c_yr) mlabsize(tiny) mlabposition(0) mlabcolor(gs10)
	   ytitle("IMF WEO t to t+3 GDP Forecast Error" ) xtitle("Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit Fd3_WEOerror_F L1D3HHD_GDP if WEOsmp==1, color(black) legend(off) lwidth(medthick) ||
	   scatter Fd3_WEOerror_F_lowess L1D3HHD_GDP if WEOsmp==1 , m(i) connect(l) lpattern(dash) lcolor(black) ;    
graph export "${destination}/Fig_scatter_HHD_WEOerror.pdf", as(pdf) replace;
#delimit cr


* (b): OECD
use "${path}/masterdata_annual.dta", clear
keep if mainsmp1==1 & lnGDP_Fd3~=.
keep if year>=1973 // forecasts before 1973 available intermittently (Pons 2000 uses 1973- sample)

* sample with no gaps
* these East Asian economies have intermittent coverage (gaps or only included for some years)
gen smp_ng = 1 
replace smp_ng=0 if countrycode=="HKG" | countrycode=="IDN" | countrycode=="SGP" | countrycode=="THA"

* Forecast
lowess Fd2_lnGDP_OECD_F L1D3HHD_GDP if smp_ng==1, nograph generate(Fd2_OECD_lowess) 
sort L1D3HHD_GDP
# delimit;		
twoway scatter Fd2_lnGDP_OECD_F L1D3HHD_GDP if smp_ng==1 , name(scatterOECDHHD,replace)
       m(i) mlab(c_yr) mlabsize(tiny) mlabposition(0) mlabcolor(gs10)
	   ytitle("OECD t to t+2 GDP Forecast" ) xtitle("Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit Fd2_lnGDP_OECD_F L1D3HHD_GDP if smp_ng==1, color(black) legend(off) lwidth(medthick)  ||
	   scatter Fd2_OECD_lowess L1D3HHD_GDP if smp_ng==1, m(i) connect(l) lpattern(dash) lcolor(black) ;    
graph export "${destination}/Fig_scatter_HHD_OECD.pdf", as(pdf) replace;
#delimit cr

* Figure: OECD t to t+2 forecast error vs hh credit expansion
lowess Fd2_OECDerror_F L1D3HHD_GDP if smp_ng==1, nograph generate(Fd2_OECDerror_lowess) 
sort L1D3HHD_GDP
# delimit;		
twoway scatter Fd2_OECDerror_F L1D3HHD_GDP if smp_ng==1 & Fd2_OECDerror_F<=11 , name(scatterOECDerrorHHD,replace)
       m(i) mlab(c_yr) mlabsize(tiny) mlabposition(0) mlabcolor(gs10)
	   ytitle("OECD t to t+2 GDP Forecast Error" ) xtitle("Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit Fd2_OECDerror_F L1D3HHD_GDP if smp_ng==1, color(black) legend(off) lwidth(medthick)  ||
	   scatter Fd2_OECDerror_lowess L1D3HHD_GDP if smp_ng==1, m(i) connect(l) lpattern(dash) lcolor(black) ;    
graph export "${destination}/Fig_scatter_HHD_OECDerror.pdf", as(pdf) replace;
#delimit cr







		



********************************************************************************
********************************************************************************
*
* ONLINE APPENDIX TABLES AND FIGURES
*
********************************************************************************
********************************************************************************



/*------------------------------------------------------------------------------

 Table A1: Country Summary
 
------------------------------------------------------------------------------*/
				
use "${path}/masterdata_annual.dta", clear
drop if NFD_GDP ==.
* mean, sd of D1HHD_GDP,D1NFD_GDP
by CountryCode: egen mean_D1HHD_GDP = mean(D1HHD_GDP) 
by CountryCode: egen   sd_D1HHD_GDP =   sd(D1HHD_GDP)
by CountryCode: egen mean_D1NFD_GDP = mean(D1NFD_GDP)
by CountryCode: egen   sd_D1NFD_GDP =   sd(D1NFD_GDP)
	
collapse (first) start = year (last) end = year (mean) mean_D1HHD_GDP (mean) sd_D1HHD_GDP (mean) mean_D1NFD_GDP (mean) sd_D1NFD_GDP  , by(c)
tostring start, gen(start_str)
tostring end,   gen(end_str)
gen date_range = start_str + "-" + end_str
keep  c date_range mean_D1HHD_GDP mean_D1NFD_GDP sd_D1HHD_GDP sd_D1NFD_GDP
order c date_range mean_D1HHD_GDP mean_D1NFD_GDP sd_D1HHD_GDP sd_D1NFD_GDP
* column headers
label var c          "Country"
label var date_range "Years"
label var mean_D1HHD_GDP  "Average \( \Delta d^{HH} \)"
label var mean_D1NFD_GDP  "Average \( \Delta d^{HH} \)"
label var   sd_D1HHD_GDP  "Std. dev. \( \Delta d^F \)"
label var   sd_D1NFD_GDP  "Std. dev. \( \Delta d^F \)"

* number formats
foreach v in mean_D1HHD_GDP mean_D1NFD_GDP sd_D1HHD_GDP sd_D1NFD_GDP {
	replace `v' = round(`v',0.01)
	format  `v' %9.2f	

}
#delimit ;
texsave using "${destination}/Table_Country_Summary.tex", 
	    nofix location(h)  marker(Table_Country_Summary)
        replace frag varlabels title("Summary of Countries in the Sample and Key Statistics")
		footnote("\textit{Notes}: This table lists the 30 countries in the sample and the years covered in the main regressions.  The last four columns report the mean and standard deviation of the changes in household debt to GDP and non-financial firm debt to GDP for each country.");
#delimit cr
		



/*------------------------------------------------------------------------------

  Table A2: IV for USA with hys
  
------------------------------------------------------------------------------*/

use "${path}/masterdata_annual.dta", clear		
keep if countrycode=="USA" 
tsset year
** USA OLS
qui reg lnGDP_Fd3 L1D3HHD_GDP
local R2: display %5.3f e(r2)
newey lnGDP_Fd3 L1D3HHD_GDP, lag(6)
est store OLS
estadd local R2 = `R2'

local inst "L1toL3hys"
** PD
ivregress gmm lnGDP_Fd3 (L1D3PD_GDP=`inst') , first wmatrix(hac nwest 6)
est store iv_PD
local R2: display %5.3f e(r2)
estadd local R2 = `R2'
* first stage
reg L1D3PD_GDP `inst'
local R2: display %5.3f e(r2)
newey L1D3PD_GDP `inst', lag(6)
est store fs_PD
test `inst'
local Fstat: display %5.3f r(F)
estadd local Ftest = `Fstat'
estadd local R2 = `R2'
** HHD
ivregress gmm lnGDP_Fd3 (L1D3HHD_GDP=`inst') , first wmatrix(hac nwest 6)
est store iv_HHD
local R2: display %5.3f e(r2)
estadd local R2 = `R2'

* first stage 
qui reg L1D3HHD_GDP `inst'
local R2: display %5.3f e(r2)
newey L1D3HHD_GDP `inst', lag(6)
est store fs_HHD
test `inst'
local Fstat: display %5.3f r(F)
estadd local Ftest = `Fstat'
estadd local R2 = `R2'

** HHD with lagged gdp growth
ivregress gmm lnGDP_Fd3 (L1D3HHD_GDP=`inst') L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 , first wmatrix(hac nwest 6)
est store iv_HHD_Ly
estadd local LDVlnY "\checkmark"
local R2: display %5.3f e(r2)
estadd local R2 = `R2'
		
* first stage 
qui reg L1D3HHD_GDP `inst' L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1
local R2: display %5.3f e(r2)
newey L1D3HHD_GDP `inst' L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1, lag(6)
est store fs_HHD_Ly
estadd local LDVlnY "\checkmark"
test `inst'
local Fstat: display %5.3f r(F)
estadd local Ftest = `Fstat'
estadd local R2 = `R2'

** Table: IV with US high yield share;
#delimit ;
esttab OLS fs_PD fs_HHD fs_HHD_Ly iv_PD iv_HHD iv_HHD_Ly
       using "${destination}/Table_hysIV.tex", 
	   keep(`inst' L1D3PD_GDP L1D3HHD_GDP)
	   order(`inst' L1D3PD_GDP L1D3HHD_GDP)
	   replace compress b(a3) se(a3)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("LDVlnY Distributed Lag in $\Delta y$" "Ftest F statistic" "R2 \(R^2\)") 
	   mtitles( "\(\Delta_3 y_{it+3}\)" "\(\Delta_3 d^{Private}_{it-1}\)" "\(\Delta_3 d^{HH}_{it-1}\)" "\(\Delta_3 d^{HH}_{it-1}\)" "\(\Delta_3 y_{it+3}\)" "\(\Delta_3 y_{it+3}\)" "\(\Delta_3 y_{it+3}\)")
	   mgroups("OLS" "First stage" "IV" , pattern(1 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   booktabs label  nonotes substitute(\_ _);
#delimit cr	 



/*------------------------------------------------------------------------------

 Table A3: Forecast Revisions
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear
keep if mainsmp1==1 
gen smp_ng = 1 
replace smp_ng=0 if countrycode=="HKG" | countrycode=="IDN" | countrycode=="SGP" | countrycode=="THA"

* IMF: t+2 forecast revision between t and t+1
xtset CountryCode year, yearly
gen WEO_tplus1rev = F.WEOF_FdlnY_1 - WEOF_FdlnY_2 
xtivreg2 WEO_tplus1rev L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=. , fe cluster(CountryCode year)
est store IMF_tplus2_rev1
estadd local FE "\checkmark"
* IMF: t+3 forecast revision between t and t+1
gen   WEO_tplus3_rev1 = F.WEOF_FdlnY_2  - WEOF_FdlnY_3 
xtivreg2 WEO_tplus3_rev1 L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=. , fe cluster(CountryCode year)
est store IMF_tplus3_rev1
estadd local FE "\checkmark"
* IMF: t+3 forecast revision between t+1 and t+2
gen   WEO_tplus3_rev2 = F2.WEOF_FdlnY_1 - F.WEOF_FdlnY_2 
xtivreg2 WEO_tplus3_rev2 L1D3HHD_GDP L1D3NFD_GDP if lnGDP_Fd3~=. & WEO_tplus3_rev1~=. , fe cluster(CountryCode year)
est store IMF_tplus3_rev2
estadd local FE "\checkmark"
* OECD: t+2 growth revision between t and t+1
gen OECD_tplus1rev = F.OECD_FdlnY_1 - OECD_FdlnY_2 
xtivreg2 OECD_tplus1rev L1D3HHD_GDP L1D3NFD_GDP if smp_ng==1 & year>=1973 & lnGDP_Fd3~=. , fe cluster(CountryCode year)
est store OECD_tplus2_rev1
estadd local FE "\checkmark"

#delimit ;
** Table: IMF WEO and OECD Forecasts revisions ;
esttab IMF_tplus2_rev1 OECD_tplus2_rev1 IMF_tplus3_rev1 IMF_tplus3_rev2 
       using "${destination}/Table_WEO_OECD_fcasts_revisions.tex", 
	   keep(L1D3HHD_GDP L1D3NFD_GDP) 
	   mtitles("\(rev_{t+2|t,t+1}^{IMF} \)" "\(rev_{t+2|t,t+1}^{OECD}\)" "\(rev_{t+3|t,t+1}^{IMF}\)" "\(rev_{t+3|t+1,t+2}^{IMF}\)")
	   replace compress b(a2) se(a2)  star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   obslast  scalars("FE Country Fixed Effects""r2 \(R^2\)") 
	   mgroups("Revision of \(t+2\) Growth Forecast" "Revision of \(t+3\) Growth Forecast", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///
	   booktabs label  nonotes substitute(\_ _);
#delimit cr	
	

	


	
	
/*------------------------------------------------------------------------------

 Table A4: Robustness to Additional Control Variables
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear	
gen L1D3lnGDP  = L1.lnGDP_d3
gen L1D3NFLGDP = L.CAD_GDP + L2.CAD_GDP + L3.CAD_GDP 
label var L1D3lnGDP "\( \Delta_3 y_{it-1} \)"
label var L1D3NFLGDP "\( \Delta_3 d^{Netforeign}_{it-1} \)"
gen L1D3I_res = L.I_dwellings_GDP - L4.I_dwellings_GDP
label var L1D3I_res "\( \Delta_3 \frac{I^{res}}{Y}_{it-1} \)"

* rise in C/Y
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP  L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3hhC_GDP , fe cluster(CountryCode year)
est store hhCtoGDP
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* rise in Cdur /Y
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP  L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3hhCdur_GDP         , fe cluster(CountryCode year)
est store hhCdurtoGDP
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* res I
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP  L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3I_res         , fe cluster(CountryCode year)
est store I_res
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* net foreign liabilities accumulation
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP  L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3NFLGDP /*i.year*/, fe cluster(CountryCode year)
est store NFL
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* REER appreciation 
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP  L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 L1D3lnREER_BIS_m12, fe cluster(CountryCode year)
est store REER
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

*--- country specific time trends ---*
* year
gen t=year
qui tab CountryCode, gen(C)
forv k=1/30 {
	gen txC`k' = t*C`k'
}
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 txC* if mainsmp1==1 , fe cluster(CountryCode year)
est store trends
estadd local FE "\checkmark"
estadd local trend "\checkmark"
estadd local LDV "\checkmark"


* 1-year ahead: no spread				  
xtivreg2 lnGDP_Fd1 L1D3HHD_GDP L1D3NFD_GDP   L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if icorp_ig10~=. & L1icorp_ig10~=. , fe cluster(CountryCode year)
est store Fd1
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* 1-year ahead: include spread			
xtivreg2 lnGDP_Fd1 L1D3HHD_GDP L1D3NFD_GDP  icorp_ig10 L1icorp_ig10 L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if  icorp_ig10~=. & L1icorp_ig10~=. , fe cluster(CountryCode year)		  
est store spread_Fd1
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* 3-year ahead: no spread
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP  L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 if icorp_ig10~=. & L1icorp_ig10~=., fe cluster(CountryCode year)
est store Fd3
estadd local FE "\checkmark"
estadd local LDV "\checkmark"

* 3-year ahead: include spread
xtivreg2 lnGDP_Fd3 L1D3HHD_GDP L1D3NFD_GDP icorp_ig10 L1icorp_ig10  L1lnGDP_d1 L2lnGDP_d1 L3lnGDP_d1 , fe cluster(CountryCode year)
est store spread_Fd3
estadd local FE "\checkmark"
estadd local LDV "\checkmark"


* Table: Robustness to Other Predictors;
#delimit ;
esttab hhCtoGDP hhCdurtoGDP I_res REER trends Fd1 spread_Fd1 Fd3 spread_Fd3 
       using "${destination}/Table_KitchenSink_Robustness.tex", 
	   keep(L1D3HHD_GDP L1D3NFD_GDP  L1D3hhC_GDP L1D3hhCdur_GDP L1D3I_res  L1D3lnREER_BIS_m12 icorp_ig10 L1icorp_ig10 ) 
	   order(L1D3HHD_GDP L1D3NFD_GDP L1D3hhC_GDP L1D3hhCdur_GDP L1D3I_res L1D3lnREER_BIS_m12 icorp_ig10 L1icorp_ig10 ) 
	   replace compress b(a3) se(a3)   star(+ 0.10 * 0.05 ** 0.01 ) noconstant 
	   mgroups( "\shortstack{Consumption or Residential \\ Investment Booms}" "\shortstack{Real Exchange \\ Rate}" "\shortstack{Time \\ Trends}" "Corporate Credit Spread", pattern(1 0 0 1  1 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) ///	   
	   obslast  scalars("FE Country Fixed Effects" "LDV Distributed Lag in \( \Delta y \) " "trend Country-specific Time Trends" "r2 \(R^2\)" ) 
	   booktabs label  nonotes substitute(\_ _);
#delimit cr		
		
	


/*------------------------------------------------------------------------------

 Table A5: POOSF 
 
------------------------------------------------------------------------------*/


use "${path}/masterdata_annual.dta", clear

* VAR forecast of t to t+3 growth = t+1 (+) t+2 (+) t+3 single period growth
gen Fc_VAR_Fd3   = VAR_1 + VAR_2 + VAR_3

* RMSFE for one-year growth forecasts
	* VAR, WEO and RW
forv i=1/5{
	gen AR_`i'_e2 = (lnGDP_d1 - L`i'.AR_`i')^2
	gen VAR_`i'_e2= (lnGDP_d1 - L`i'.VAR_`i')^2  // squared fcast error
	gen WEO_F`i'_e2  = (WEO_dlnY_rlzd - L`i'.WEOF_FdlnY_`i')^2
	gen RW_`i'_e2 = (lnGDP_d1 -L`i'.lnGDP_d1)^2
}
	gen OECD_F1_e2 = (OECD_dlnY_rlzd - L1.OECD_FdlnY_1)^2
	gen OECD_F2_e2 = (OECD_dlnY_rlzd - L2.OECD_FdlnY_2)^2

* samples to compare RMSFE
keep if year>=2000			// look at post year 2000 
reg OECD_F1_e2 VAR_1_e2
gen smp1=e(sample)
reg OECD_F2_e2 VAR_2_e2
gen smp2=e(sample)
forv i=3/5{
reg WEO_F`i'_e2 VAR_`i'_e2
gen smp`i'=e(sample)
}
* store RMSFE in this dataset
tempfile Fdata
save    `Fdata'
clear
set obs 5
gen horizon =_n
gen IMF=.
gen OECD=.
gen VAR3=.
gen AR=.
gen RW=.
tempfile RMSFE
save    `RMSFE'

forv i=1/5{
display "Horizon: `i'"
	* IMF
	use `Fdata', clear
	sum WEO_F`i'_e2 if smp`i'==1
	use `RMSFE', clear
	replace IMF = sqrt(r(mean)) if horizon==`i'
	save `RMSFE', replace
	* OECD
	use `Fdata', clear
	if `i'<3 {
	sum OECD_F`i'_e2 if smp`i'==1
	use `RMSFE', clear
	replace OECD = sqrt(r(mean)) if horizon==`i'
	save `RMSFE', replace
	}
	* AR
	use `Fdata', clear	
	sum AR_`i'_e2  if smp`i'==1
	use `RMSFE', clear
	replace AR = sqrt(r(mean)) if horizon==`i'
	save `RMSFE', replace
	* VAR
	use `Fdata', clear
	sum VAR_`i'_e2  if smp`i'==1
	use `RMSFE', clear
	replace VAR = sqrt(r(mean)) if horizon==`i'
	save `RMSFE', replace
	* RW
	use `Fdata', clear
	sum RW_`i'_e2  if smp`i'==1
	use `RMSFE', clear
	replace RW = sqrt(r(mean)) if horizon==`i'
	save `RMSFE', replace
}
use `RMSFE', clear

** POOSF RMSFE Table for Appendix
label var horizon "Forecast Horizon"
label var IMF     "IMF"
label var OECD     "OECD"
label var VAR3    "VAR"
label var AR     "AR"
label var RW     "RW"
gen Horizon ="1 year"
label var Horizon "Forecast Horizon"
forv i=2/5{
replace Horizon = "`i' years" if horizon ==`i'
}
order Horizon
drop horizon
* round
foreach v in IMF OECD VAR3 AR RW {
	replace `v' = round(`v',0.01)
	format  `v' %9.2f	

}
#delimit ;
texsave using "${destination}/Table_POOSF_RMSFE.tex", 
        nofix location(h) marker(POOSF_RMSFE)
        replace frag varlabels title("Root Mean Squared Errors of Pseudo Out-Of-Sample GDP Growth Forecasts, 2000-2012")
		footnote("\textit{Notes}: This table shows the root means squared errors from pseudo out-of-sample forecasts of one-year GDP growth over the following five years.  Root mean squared forecast errors from the IMF and OECD are computed using realized growth in year \(t\) reported in year \(t+2\) reports.  VAR forecasts refer to forecasts from a three variable VAR using real GDP growth, the change in household debt to GDP, and the change in non-financial firm debt to GDP.  The VAR is estimated on the pooled sample.  AR forecasts refer to forecasts from an autoregressive model of GDP growth estimated on the pooled sample.  Both VAR and AR models include five lags.  RW forecasts refer to forecasts from a random walk model (no change).");
#delimit cr





	

/*------------------------------------------------------------------------------

 Figure A5: beta_hh for each country individually
 
------------------------------------------------------------------------------*/
	
* variables
local xvar "L1D3HHD_GDP"
local cont "L(1/3).lnGDP_d1"
local yvar "lnGDP_Fd3"

* dataset for results
clear
tempfile results2
gen xvars  = ""
gen b_HH   = .
gen se_HH  = .
gen  N     = .
gen country = ""
save `results2', empty replace	

use "${path}/masterdata_annual.dta", clear
levelsof countrycode , local(countries)
local row=1
foreach x in `countries'{
	display("`x'")
	* run time series regression for country `x'.  For IRL and IDN only control for L1lnGDP_d3 (df issue)
	use "${path}/masterdata_annual.dta", clear
	keep if countrycode=="`x'"
	tsset year
	if "`x'"~="IRL" & "`x'"~="IDN" {
	reg  `yvar'  `xvar' `cont' if countrycode=="`x'" & mainsmp1==1	//, robust bw(6)
	}
	else{
	reg `yvar'  `xvar' L.lnGDP_d3 if countrycode=="`x'" & mainsmp1==1	//, robust bw(3)
	}
	est store r_`x'
	
	* store regression results
	use `results2', clear
	set obs `row'
	cap replace b_HH = _b[`xvar']       if _n==`row'
	cap replace se_HH= _se[`xvar']      if _n==`row'
	cap replace country = "`x'"         if _n==`row'
	cap replace N = `e(N)'              if _n==`row'
	cap replace xvars  = "`xvar'"       if _n==`row'
	save `results2', replace
	
	local row = `row'+1	
	
}

est tab r_*, se p stats(r2 N)

use `results2' ,clear
gen b_HH_u = b_HH+1.96*se_HH
gen b_HH_l = b_HH-1.96*se_HH
tostring N, gen(Nstr)
gen country_N = country + "(N=" + Nstr + ")"
* Summary statistics of estimates: mean of estimates very similar to full sample mean
gen precision = 1/(se_HH^2)
sum b_HH, detail
local b_HH_uw: display %5.3f r(mean)
sum b_HH [aw=N], detail
sum b_HH [aw=precision], detail
local b_HH_w: display %5.3f r(mean)

sort b_HH 
gen x = _n 

labmask x, values(country)

* Figure: Bar plot of beta_HH_i;
#delimit;
graph twoway bar b_HH x, xlabel(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30, valuelabels angle(90) )   
             ytitle("Estimated coefficient") lcolor(navy) color(navy) legend(off) xtitle("")
			 text( 2.5 2 "Unweighted average of estimates: `b_HH_uw'." "Precision weighted average: `b_HH_w'.", place(e) justification(left) size(medsmall) ) 
             || rcap b_HH_u b_HH_l x, lcolor(gs4)
             ; 
graph export "${destination}/Fig4_bar_b_HH_country.pdf", as(pdf) replace;			 
#delimit cr	 




		
/*------------------------------------------------------------------------------

 Figure A6: Scatterplot for Japan case
 
------------------------------------------------------------------------------*/
				

use "${path}/masterdata_annual.dta", clear

# delimit;		
twoway scatter lnGDP_Fd3 L1D3HHD_GDP if mainsmp1==1 & countrycode=="JPN" & lnGDP_Fd3<25, name(scatterHHD_JPN,replace)
        mlab(year) mlabsize(vsmall) mlabcolor(gs10) mlabposition(0) m(i)
	   ytitle("GDP growth, t to t+3" ) xtitle("Household Debt to GDP Expansion, t-4 to t-1") ||        
	   lfit lnGDP_Fd3 L1D3HHD_GDP if mainsmp1==1 & countrycode=="JPN", color(black) legend(order(2 "1964-2012" 3 "1964-1995" )  position(12) ring(0) ) lwidth(medthick) ||
	   lfit lnGDP_Fd3 L1D3HHD_GDP if mainsmp1==1 & countrycode=="JPN" & year<=1992, m(i) connect(l) lwidth(medthick) lpattern(dash) lcolor(black) ;    
graph export "${destination}/Fig_scatter_HHD_JPN.png", replace;
#delimit cr	  		
		



	
/*------------------------------------------------------------------------------

 Figure A7: Preceding IMF Forecasts (t-5)
 
------------------------------------------------------------------------------*/
		
		
use "${path}/masterdata_annual.dta", clear
keep if mainsmp1==1
drop if lnGDP_Fd3==.  
forv i=1/5{
	gen L5WEO_Fd`i'  = L5.Fd`i'_lnGDP_WEO_F  
	gen L5WEOe_Fd`i' = L5.Fd`i'_WEOerror_F   
}
tempfile WEOdata
save    `WEOdata'

clear
tempfile results
gen yvar   = ""
gen xvars  = .
local xvar1 "L1D3HHD_GDP L1D3NFD_GDP"
gen hor    = . 
gen timing = ""
foreach j in HH NF {
gen b_`j'      = .
gen se_`j'     = .
}
save `results', empty replace

local row=1

foreach yy in "L5WEO_Fd" "L5WEOe_Fd" {
	forv x=1/1{
		forv i=1/5{  // loop over horizons
		use `WEOdata', clear
		* run regression
		xtivreg2 `yy'`i'  `xvar`x'' , fe cluster( CountryCode year)
	
		* store results
		use `results', clear
		set obs `row'		
		cap replace b_HH   = _b[L1D3HHD_GDP]  if _n==`row'
		cap replace se_HH  = _se[L1D3HHD_GDP] if _n==`row'
		cap replace b_NF   = _b[L1D3NFD_GDP]  if _n==`row'
		cap replace se_NF  = _se[L1D3NFD_GDP] if _n==`row'
		cap replace xvars  = `x'              if _n==`row'
		cap replace yvar   = "`yy'"           if _n==`row'
	    replace hor    = `i'              if _n==`row'
		save `results', replace
		local row = `row'+1
		}
	}
}

* 95% CI
foreach j in HH NF {
gen b_`j'_l = b_`j' - 1.96*se_`j'
gen b_`j'_u = b_`j' + 1.96*se_`j'
}

replace hor = hor-5 if (yvar=="L5WEO_Fd" | yvar=="L5WEOe_Fd" ) 
** Figure: t-5 forecast of t-4,t-3,t-2,t-1,t on L1D3HHD_GDP, L1D3NFD_GDP
#delimit ;
twoway (connected b_HH b_HH_l b_HH_u  hor if yvar=="L5WEO_Fd" & hor <=5 & xvar==1,
	   name(tminus5WEOforecast,replace) 
	   title("Year t-5 GDP Forecast")
	   xtitle("Year t-5 forecast of growth from t-5 to t-4,..., t")
	   yscale(range(-0.4 0.4))
       lpattern(solid dash dash)
	   lcolor(black black black)
	   mcolor(black black black) msymbol(O i i)
	   legend(order(1 "Household" 4 "NF Firm")) )
	   (connected b_NF b_NF_l b_NF_u hor if yvar=="L5WEO_Fd" & hor <=5 & xvar==1, 
	   lpatter(solid dash dash)
	   lcolor(navy navy navy)
	   mcolor(navy navy navy)  msymbol(S i i) );	  	 
	   
** Figure: t-5 forecast error of t-4,t-3,t-2,t-1,t on L1D3HHD_GDP, L1D3NFD_GDP;
twoway (connected b_HH b_HH_l b_HH_u  hor if yvar=="L5WEOe_Fd" & hor <=5 & xvar==1,
	   name(tminus5WEOforecasterror,replace) 
	   title("Year t-5 GDP Forecast Error")
	   xtitle("Year t-5 forecast error of growth from t-5 to t-4,..., t")
	   yscale(range(-0.4 0.4))
       lpattern(solid dash dash)
	   lcolor(black black black)
	   mcolor(black black black) msymbol(O i i)
	   legend(order(1 "Household" 4 "NF Firm")) )
	   (connected b_NF b_NF_l b_NF_u hor if yvar=="L5WEOe_Fd" & hor <=5 & xvar==1, 
	   lpatter(solid dash dash)
	   lcolor(navy navy navy)
	   mcolor(navy navy navy)  msymbol(S i i) );
#delimit cr

* Combine Figure: t-5+h|t-5 forecasts and forecast errors
grc1leg tminus5WEOforecast tminus5WEOforecasterror, name(tminus5WEO,replace) ycommon
graph export "${destination}/Fig_WEO_tminus5_fcast.png", replace		
		
		

				
		
