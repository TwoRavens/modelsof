***************************************
* Referendum Day Data (Not Annual)
***************************************


* (i) Synth


cd "Yourpath"


use data1.dta, clear

global XX  over_40_i over_50_i over_60_i  pub_revenue_pc_i pub_spending_pc_i log_population_i urban_pop_i  ///
					 work_pop_pop_i  work_sec1_pop_i work_sec2_pop_i motor_pop_i 
					 
global XX2  over_40_i over_50_i over_60_i  pub_revenue_pc_i pub_spending_pc_i log_population_i urban_pop_i  ///
					 work_pop_pop_i  work_sec1_pop_i work_sec2_pop_i motor_pop_i ///
					 turnout_mean_1_16 turnout_mean_17_44 


synth turnout_mean  $XX ///
					 turnout_mean(1(1)16) turnout_mean(17(1)32), ///
					  trunit(22) trperiod(33) xperiod(1(1)32) mspeperiod(1(1)32) allopt ///
					   fig resultsperiod(1(1)130) keep(resout) replace
					   
mat def X_balance = e(X_balance)
mat def W_weights = e(W_weights)
mat def Y_synthetic = e(Y_synthetic)
mat def Y_treated = e(Y_treated)

cap mat drop b
foreach covar of global XX2 {
reg  `covar'  , cluster(id), if inrange(year,1900,1924) & id!=22
  matrix   temp = _b[_cons] 
  matrix   rownames temp = "`covar'"
  mat b = nullmat(b) \ temp
  matrix colnames b = mean 
}



matrix balance_all = (X_balance, b) // balance table out
matrix balance_all[12,1]= balance_all[12,1]*100 // correct for turnout 
matrix balance_all[12,2]= balance_all[12,2]*100 // correct for turnout 
matrix balance_all[13,1]= balance_all[13,1]*100 // correct for turnout 
matrix balance_all[13,2]= balance_all[13,2]*100 // correct for turnout 

matrix rownames balance_all = "Population_over_40" "Population_over_50" "Population_over_60" "Public_Revenues" "Public_Spending" "Log_Population" "Urban_Population" "Working_Population" "Primary_Sector" "Secondary_Sector" "Motor_Vehicles" "Turnout_1900--1912" "Turnout_1913--1924"  
outtable using balance_all, mat(balance_all) ///
								replace center nobox f(%9.2f %9.2f %9.2f %9.2f) ///
								 cap("Balance") clabel("tab:balance")

mat2txt , matrix(balance_all) saving("balance_nonannual.txt")  replace // save matrices for R plot
mat2txt , matrix(W_weights) saving("W_weights_nonannual.txt")  replace
mat2txt , matrix(Y_synthetic) saving("Y_synthetic_nonannual.txt")  replace
mat2txt , matrix(Y_treated) saving("Y_treated_nonannual.txt")  replace




* (ii) DID with VD results

tab id, gen(id_)
tab dat_num, gen(dat_num_)


sort canton dat_num
bysort canton: gen time_trend=_n
bysort canton: gen time_trend_sq=time_trend^2


xtivreg2 turnout_mean sanction susp post dat_num_*, fe cluster(id dat_num) 
outreg2 using panel_VD.xls , excel  stats(coef se tstat pval ) noaster cttop("Panel VD") dec(2) replace	
tab year if e(sample)==1
xtivreg2 turnout_mean sanction susp post $XX dat_num_*, fe cluster(id dat_num) 
outreg2 using panel_VD.xls , excel  stats(coef se tstat pval ) noaster cttop("Panel VD") dec(2) append	
tab year if e(sample)==1

xtivreg2 turnout_mean sanction susp post $XX dat_num_* time_trend , fe cluster(id dat_num) 
outreg2 using panel_VD.xls , excel  stats(coef se tstat pval ) noaster cttop("Panel VD") dec(2) append	
xtivreg2 turnout_mean sanction susp post $XX dat_num_* time_trend_sq, fe cluster(id dat_num) 
outreg2 using panel_VD.xls , excel  stats(coef se tstat pval ) noaster cttop("Panel VD") dec(2) append	

* COMPUTE REGRESSION WEIGHTS FOLLOWING ABADIE ET AL AJPS
clear matrix
foreach num of numlist  2/7 9 10 11 12 13 22 23/25	{
	foreach covar of global XX2 {
		reg  `covar'  , cluster(id), if inrange(year,1900,1924) & id==`num'
		matrix   temp = _b[_cons] 
		mat X`num' = nullmat(X`num') \ temp
		matrix colnames X`num' = `num' 
		}
}

mat X1 = X22
mat one = (1)
mat X1 = nullmat(one) \ X1

mat ones = (1,1,1,1,1,1,1,1,1,1,1,1,1,1)
mat X0 = (X2, X3, X4, X5, X6, X7, X9, X10, X11, X12, X13,  X23, X24, X25)
mat X0 = nullmat(ones) \ X0
mat def W_reg = X0'*invsym(X0*X0')*X1
matrix rownames W_reg =  2 3 4 5 6 7 9 10 12 13 15 23 24 25
mat2txt , matrix(W_reg) saving("W_reg.txt")  replace

xtivreg2 turnout_mean sanction susp post $XX dat_num_*, fe cluster(id dat_num) // sample restriction to those refs that are used in regression
gen sample_restriction=e(sample)
keep if sample_restriction==1

egen dat_num_new=group(dat_num)
sum dat_num_new

egen id_new=group(id)
sum id_new
tab id_new, gen(id_new_)

* COMPUTE REGRESSION WEIGHTS 2 FOR PANEL-EQUIVALENT MODELL
clear matrix
foreach num of numlist  2/7 9 10 11 12 13 22 23/25{
   foreach ref of numlist 1/130	{
	foreach covar of varlist turnout_mean sanction susp post $XX dat_num_new* id_new_* {
	cap	mean  `covar'  if dat_num==`ref'  & id_new==`num' 
	cap	matrix   temp = e(b) 
	cap	mat X`num' = nullmat(X`num') \ temp
	cap	matrix colnames X`num' = `num' 
		}
	}
}

mat X1 = X22
mat one = (1)
mat X1 = nullmat(one) \ X1

mat ones = (1,1,1,1,1,1,1,1,1,1,1,1,1,1)
mat X0 = (X2, X3, X4, X5, X6, X7, X9, X10, X11, X12, X13,  X23, X24, X25)
mat X0 = nullmat(ones) \ X0
mat def W_reg2 = X0'*invsym(X0*X0')*X1
matrix rownames W_reg2 =  2 3 4 5 6 7 9 10 11 12 13 15 23 24 25
mat2txt , matrix(W_reg2) saving("W_reg2.txt")  replace



* (iii) PLACEBO IN TIME

synth turnout_mean over_40_i over_50_i over_60_i  pub_revenue_pc_i pub_spending_pc_i log_population_i urban_pop_i ///
					  work_pop_pop_i work_sec1_pop_i work_sec2_pop_i motor_pop_i ///
					  participation_i(1900(1)1914)  , ///
					  trunit(22) trperiod(1915) xperiod(1900(1)1914) mspeperiod(1900(1)1914) allopt ///
					   fig resultsperiod(1900(1)1970) keep(resout_time) replace


mat def W_weights_time = e(W_weights)
mat def Y_synthetic_time = e(Y_synthetic)
mat def Y_treated_time = e(Y_treated)

mat2txt , matrix(W_weights_time) saving("W_weights_time.txt")  replace
mat2txt , matrix(Y_synthetic_time) saving("Y_synthetic_time.txt")  replace
mat2txt , matrix(Y_treated_time) saving("Y_treated_time.txt")  replace


* (vi) PLACEBO IN SPACE


drop if canton=="VD"
egen id_new = group(id)
tsset id_new year

tempname resmat
        forvalues i = 1/15 {
        synth turnout_mean over_40_i over_50_i over_60_i  pub_revenue_pc_i pub_spending_pc_i log_population_i urban_pop_i ///
					  work_pop_pop_i work_sec1_pop_i work_sec2_pop_i motor_pop_i ///
					  participation_i(1900(1)1912) participation_i(1913(1)1924)  , ///
					  trunit(`i') trperiod(1925) xperiod(1900(1)1924) mspeperiod(1900(1)1924) allopt ///
					   fig resultsperiod(1900(1)1970) keep(resout_`i') replace
	    mat def W_weights = e(W_weights)
		mat def Y_synthetic = e(Y_synthetic)
		mat def Y_treated = e(Y_treated)
		mat2txt , matrix(W_weights) saving("W_weights_`i'.txt")  replace
		mat2txt , matrix(Y_synthetic) saving("Y_synthetic_`i'.txt")  replace
		mat2txt , matrix(Y_treated) saving("Y_treated_`i'.txt")  replace
        matrix `resmat' = nullmat(`resmat') \ e(RMSPE)
        local names `"`names' `"`i'"'"'
        }
        mat colnames `resmat' = "RMSPE"
        mat rownames `resmat' = `names'
matlist `resmat' , row("Treated Unit")




* (vii) USE ONLY COVARIATES BUT NO PRE-TREATMENT OUTCOMES (FORE FIGURE 6)


use data1.dta, clear

global XX  over_40_i over_50_i over_60_i  pub_revenue_pc_i pub_spending_pc_i log_population_i urban_pop_i  ///
					 work_pop_pop_i  work_sec1_pop_i work_sec2_pop_i motor_pop_i 
					 
synth turnout_mean  $XX , ///
					  trunit(22) trperiod(33) xperiod(1(1)32) mspeperiod(1(1)32) allopt ///
					   fig resultsperiod(1(1)130) keep(resout) replace
					   
matlist e(RMSPE)	
		  					   
mat def W_weights = e(W_weights)
mat def Y_synthetic = e(Y_synthetic)
mat def Y_treated = e(Y_treated)

mat2txt , matrix(W_weights) saving("W_weights_nonannual_cov_only.txt")  replace
mat2txt , matrix(Y_synthetic) saving("Y_synthetic_nonannual_cov_only.txt")  replace
mat2txt , matrix(Y_treated) saving("Y_treated_nonannual_cov_only.txt")  replace




* (viii)  USE ANNUAL DATA (FOR FIGURE 6)


use "data1_annual.dta", clear

global XX over_40_i over_50_i over_60_i  pub_revenue_pc_i pub_spending_pc_i log_population_i urban_pop_i work_pop_pop_i ///
					   work_sec1_pop_i work_sec2_pop_i motor_pop_i turnout_mean_1900_1912 turnout_mean_1913_1924

synth turnout_mean over_40_i over_50_i over_60_i  pub_revenue_pc_i pub_spending_pc_i log_population_i urban_pop_i ///
					  work_pop_pop_i work_sec1_pop_i work_sec2_pop_i motor_pop_i ///
					  turnout_mean(1900(1)1912) turnout_mean(1913(1)1924)  , ///
					  trunit(22) trperiod(1925) xperiod(1900(1)1924) mspeperiod(1900(1)1924) allopt ///
					   fig resultsperiod(1900(1)1970) keep(resout) replace


mat def X_balance = e(X_balance)
mat def W_weights = e(W_weights)
mat def Y_synthetic = e(Y_synthetic)
mat def Y_treated = e(Y_treated)

cap mat drop b
foreach covar of global XX {
reg  `covar'  , cluster(id), if inrange(year,1900,1924) & id!=22
  matrix   temp = _b[_cons] , _se[_cons]
  matrix   rownames temp = "`covar'"
  mat b = nullmat(b) \ temp
  matrix colnames b = mean  se
}

matrix bal = (X_balance, b) 
mat2txt , matrix(bal) saving("balance.txt")  replace
mat2txt , matrix(W_weights) saving("W_weights.txt")  replace
mat2txt , matrix(Y_synthetic) saving("Y_synthetic.txt")  replace
mat2txt , matrix(Y_treated) saving("Y_treated.txt")  replace



