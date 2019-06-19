* MAIN_ESTIMATION.DO
*
* Program that calls estimation command, bootstrap, and creates graphs
* This program only works if it is called from within the "main_results.do" program
* (or any version of it)
* If this program is modified, then it affects ALL programs that call this do file in the same folder
*
* Program written for Flores, Carlos A. and Oscar A. Mitnik (2013). 
* "Comparing Treatments across Labor Markets: An Assessment of Nonexperimental 
* Multiple-Treatment Strategies", Review of Economics and Statistics, 
* December 2013, Vol. 95, No. 5, Pages 1691-1707.
*
* This version: May, 2011
*

* Include code with Mata functions needed
include "`pgsdir'main_estimation_mata_inc.do"

* Only keep necessary variables so dataset is smaller and bootstrap runs faster
keep `keepvars'

* Labels for names of estimators (determines also number of estimators)
local estim_lbl "RAW_NO_OV RAW_OV PM_X_NO_OV PM_X_OV PM_X_FLEX_NO_OV PM_X_FLEX_OV PM_GPS_PAR_OV PM_GPS_NPR_OV IPW_OV IPW_X_OV"
local nrestim: word count `estim_lbl'

* Labels for names of estimators for GRAPHS
local estim_lbl_grph ""Raw Mean - No Ovlp" "Raw Mean - Ovlp" "Partial Mean Linear X - No Ovlp" "Partial Mean Linear X - Ovlp" "Partial Mean Flex X - No Ovlp" "Partial Mean Flex X - Ovlp" "GPS-Based Parametric Partial Mean" "GPS-Based Nonparametric Partial Mean" "IPW No Covariates" "IPW With Covariates ""

* Determine number and values of treatment categories
qui tab `treatvar', matrow(tvals)
local ntreat=rowsof(tvals)
if `nrtreat'~=`ntreat' {
	di " "
	di as err "Number of labels assigned to treatments (`nrtreat') different from actual number of treatments (`ntreat')"
	error 102
}	
* Added June 2011, alternative way of determining values of treatment categories (needed below)
quietly levelsof `treatvar', local(tvals)
	

* Determine number of outcomes
local nrout: word count `yvars'
* Doubles the number of outcomes if LEC adjustment option is activated
if "`lec_adjustment'"=="1" {
		local orig_nrout = `nrout'
		local nrout = `nrout' * 2
}

* Estimate treatment effects
estimation `yvars', tvar(`treatvar') 											    ///
					 xvar(`xvars')                                      ///
					 xnodid(`xnodid')                                   ///
					 xgps(`xgps')								                        ///
					 xextra(`xextra')										                ///
					 lec_adjustment(`lec_adjustment')                   ///
					 lec_lev_vars(`lec_lev_vars')                       ///
					 lec_yvar_1(`lec_yvar_1') 							            ///
					 lec_yvar_2(`lec_yvar_2')                           ///
					 lec_vars_t(`lec_vars_t')                           ///
					 lec_vars_1(`lec_vars_1')                           ///
					 lec_vars_2(`lec_vars_2')                           ///
					 lec_grp_vars(`lec_grp_vars')                       ///
					 lec_options(`lec_options')													///
					 didy(`did')   													            ///
           samp_rate(`smp')                                   ///
           ystd(`ystd')                                       ///
           betastd(`betastd')                                 ///
           betastd_wgt_mean(`betastd_wgt_mean')	              ///
           overlap(`overlap')                                 ///
           ovlp_pooled(`ovlp_pooled')                         ///
           ovlp_value(`ovlp_value')                           ///
           ovlp_one_tail(`ovlp_one_tail')                     ///
           mprobit(`mprobit')                                 ///
				   gmm(`gmm')																				  ///
				   gmm_method(`gmm_method')														///
		  		 re_estim_gps(`re_estim_gps')												///
           max_weight(`max_wgt_value')										    ///
           ptlmn_degree(`degree')                             ///
           ptlmn_kernel(`kern')                               ///
           ptlmn_binning(`bin')                               ///
           ptlmn_bin_nr(`bin_nr') 				                    ///
           percentiles(`percentiles_list')										///
		  		 percentiles_file(`percentiles_file')    					  ///
		       descopt(`descopt')                                 ///
           descvar(`descvar')                                 ///
           descfile(`desc_file')				                      ///
		 			 balopt(`balopt')                                   ///
		 			 balvar(`xvarsbal')                                 ///
		 			 balfile(`bal_file')                                ///
		 			 kernelgraphfile(`kernelgraphfile')                 ///
		 			 boxgraphfile(`boxgraphfile')												///
		 			 resultsdir(`resultsdir')														///
		 			 treatment_lbls(`treat_lbl')



* Matrix with results: number of rows = `nrestim' (+2) and number of columns = `ntreat' * `nrout'
matrix b_te=e(b)
matrix teffects_results=J(`nrestim'+2,`nrout'*`ntreat',.)
local cter=0
local col_lab ""
local col2_lab "" 
foreach o of numlist 1/`nrout' {
	local col2_lab "`col2_lab' out_`o'"
	foreach e of numlist 1/`nrestim' {
		foreach t of numlist 1/`ntreat' {
			local cter=`cter'+1
			local tr = tvals[`t',1]
			if `e'==1 {
				local col_lab "`col_lab' out_`o':treat_`tr'"
				matrix teffects_results[`nrestim'+1,(`ntreat'*(`o'-1))+`t']=`o'
				matrix teffects_results[`nrestim'+2,(`ntreat'*(`o'-1))+`t']=`tr'
			}
			matrix teffects_results[`e',(`ntreat'*(`o'-1))+`t']=b_te[1,`cter']
		}
	}
	matrix rmsd    = (nullmat(rmsd),b_te[1,"rmsd_out_`o':"]')
	matrix mad     = (nullmat(mad),b_te[1,"mad_out_`o':"]')
	matrix maxdist = (nullmat(maxdist),b_te[1,"maxdist_out_`o':"]')
	matrix meanval = (nullmat(meanval),b_te[1,"meanval_out_`o':"]')
}
matrix colnames teffects_results = `col_lab'
matrix coleq teffects_results    = `col_eq'
matrix rownames teffects_results = `estim_lbl' outcome_nr treat_nr
matrix colnames rmsd = `col2_lab'
matrix coleq rmsd = rmsd
matrix rownames rmsd = `estim_lbl'
matrix roweq rmsd = :
matrix colnames mad = `col2_lab'
matrix coleq mad = mad
matrix rownames mad = `estim_lbl'
matrix roweq mad = :
matrix colnames maxdist = `col2_lab'
matrix coleq maxdist = maxdist
matrix rownames maxdist = `estim_lbl'
matrix roweq maxdist = :
matrix colnames meanval = `col2_lab'
matrix coleq meanval = meanval
matrix rownames meanval = `estim_lbl'
matrix roweq meanval = :


* Treatment effects, root mean squared distance and mean absolute distance
if `ystd'==0 di "Treatment effects using ORIGINAL variables"
if `ystd'==1 di "Treatment effects using STANDARDIZED variables"
if `betastd'==0 di "RMSD, MAD are NOT STANDARDIZED"
if `betastd'==1 {
	di "RMSD, MAD are STANDARDIZED BY MEAN"
	if `betastd_wgt_mean'==0 di "(Mean used in standardization is UNWEIGHTED)"
	if `betastd_wgt_mean'==1 di "(Mean used in standardization is WEIGHTED)"
}
mat list teffects_results
mat list meanval
mat list rmsd
mat list mad
mat list maxdist

* Seed
set seed 11111
scalar s_init=c(seed)
timer on 1
bootstrap _b, reps(`nreps') strata(`stratvar') saving("`resultsdir'bs_results.dta",double replace) reject(_rc==430):  ///
							estimation `yvars', 																																									  ///
												  tvar(`treatvar')                                      																		  ///
												  xvar(`xvars')                                         																		  ///
												  xgps(`xgps')                                          																		  ///
												  xextra(`xextra')                                      																		  ///
												  xnodid(`xnodid')                                      																		  ///
												  lec_adjustment(`lec_adjustment')                      																		  ///
												  lec_lev_vars(`lec_lev_vars')                          																		  ///
												  lec_yvar_1(`lec_yvar_1') 							                																		  ///
												  lec_yvar_2(`lec_yvar_2')                              																		  ///
												  lec_vars_t(`lec_vars_t')                              																		  ///
												  lec_vars_1(`lec_vars_1')                              																		  ///
												  lec_vars_2(`lec_vars_2')                              																		  ///
												  lec_grp_vars(`lec_grp_vars')                          																		  ///
												  lec_options(`lec_options')																																	///
												  didy(`did')                                           																		  ///
												  samp_rate(`smp')                                      																		  ///
												  ystd(`ystd')                                          																		  ///
												  betastd(`betastd')                                    																		  ///
												  betastd_wgt_mean(`betastd_wgt_mean')                  																		  ///
												  overlap(`overlap')                                    																		  ///
												  ovlp_pooled(`ovlp_pooled')                            																		  ///
												  ovlp_value(`ovlp_value')                              																		  ///
												  ovlp_one_tail(`ovlp_one_tail')                        																		  ///
												  mprobit(`mprobit')                                    																		  ///
							 				    gmm(`gmm')																				  												  						  ///
				   								gmm_method(`gmm_method')																																	  ///
		  		 								re_estim_gps(`re_estim_gps')																															  ///
												  max_weight(`max_wgt_value')                           																		  ///
												  ptlmn_degree(`degree')                                																		  ///
												  ptlmn_kernel(`kern')                                  																		  ///
												  ptlmn_binning(`bin')                                  																		  ///
												  ptlmn_bin_nr(`bin_nr')

timer off 1
timer list
scalar s_end=c(seed)
* Stores estimation results for possible future use (as *.ster file)
estimates save "`resultsdir'bs_estimates.ster", replace
estimates clear
estimates use "`resultsdir'bs_estimates.ster"

* Stores Var-Cov matrix from bootsrap estimation and macro variable with names in columns of coefficient vector
matrix bbs=e(b)
matrix Vbs=e(V)
local bbs_nms: colfullnames bbs

* Show Bootstrap results
estat bootstrap, normal percentile

* ADDED June 2011
* Creates CSV table (using estout) with average outcome for each treament (one table per outcome)
tempname cibs
matrix `cibs' = e(ci_percentile)
local trfst = tvals[1,1]
local trlst = tvals[`ntreat',1]
foreach o of numlist 1/`nrout' {
	tempname bbs_out`o' bbs_r_out`o' ci_r_out`o' cil_out`o' ciu_out`o' cil_r_out`o' ciu_r_out`o'
	* First reorganize vector of results for each outcome as "equations" = treatments and "coefficients" = estimators 
	* (opposite of how it comes from bootstrapped command)
	* Coefficients
	matrix `bbs_out`o''= bbs[1,"out_`o'_estim_1:treat_`trfst'".."out_`o'_estim_`nrestim':treat_`trlst'"]
	mata:st_matrix("`bbs_r_out`o''",rowshape(rowshape(st_matrix("`bbs_out`o''"), `nrestim')',1))
	* Confidence intervals (percentile-based)
	matrix `cil_out`o''=`cibs'[1,"out_`o'_estim_1:treat_`trfst'".."out_`o'_estim_`nrestim':treat_`trlst'"]
	matrix `ciu_out`o''=`cibs'[2,"out_`o'_estim_1:treat_`trfst'".."out_`o'_estim_`nrestim':treat_`trlst'"]
	mata:st_matrix("`cil_r_out`o''",rowshape(rowshape(st_matrix("`cil_out`o''"), `nrestim')',1))
	mata:st_matrix("`ciu_r_out`o''",rowshape(rowshape(st_matrix("`ciu_out`o''"), `nrestim')',1))
	matrix `ci_r_out`o'' = (`cil_r_out`o'' \ `ciu_r_out`o'')
	matrix rownames `ci_r_out`o'' = ll ul	
	
	* Need to re-arrange column names
	if `o' == 1 {
		* Get original column names
		local trns: colnames `bbs_out`o''
		* Creates "equation" names
		mata:st_local("eqnms",invtokens(rowshape(rowshape(tokens(st_local("trns")),`nrestim')',1)))
		* Creates "coefficient" names
		mata:st_local("colnms",invtokens(mm_expand((("estim_"):+strofreal(1..`nrestim')),1,`ntreat')))
	}
	
	* Assign column names
	matrix colnames `bbs_r_out`o'' = `colnms'
	matrix coleq `bbs_r_out`o'' = `eqnms'
	matrix colnames `ci_r_out`o'' = `colnms'
	matrix coleq `ci_r_out`o'' = `eqnms'
	
	* Add results and CIs
	quietly estadd matrix bbs_out`o' = `bbs_r_out`o''
	quietly estadd matrix ci_out`o'  = `ci_r_out`o''
	
	* Creates one table per outcome with average outcome per treatment	
	estout using "`resultsdir'estim_teffects_out_`o'.csv", cells((bbs_out`o'(fmt(2) label(E[Y]))) "ci_out`o'[ll](fmt(2) par([ ])) & ci_out`o'[ul](fmt(2) par([ ]))") unstack stats(N_reps N_misreps N N_ovlp N_novlp, fmt(0)) title(Average outcomes - Outcome `o') replace delimiter(",")
	* Adds ovlp_freq matrix to table
	estout e(ovlp_freq, transpose) using "`resultsdir'estim_teffects_out_`o'.csv", append delimiter(",")
	
}


* Put all results in a matrix (treatment effects, standard errors, percentile- and normal- confidence intervals)
* Matrix has number of rows=number treatments * number outcomes, number of columns = (number estimators * 6) + 3 (id cols)
* The "6" comes from 6 items of interest: t.effects, se, perc-ci-lower, perc-ci-upper, norm-ci-lower, norm-ci-upper
* Also creates a matrix with p-values for Wald test of joint equality of treatment effects within each "equation"
* (i.e. for each outcome and estimator). The matrix has as many rows as outcomes and columns as estimators
local estim_lb2 = lower("`estim_lbl'")
local nrcoeff = `nrout' * `nrestim' * `ntreat'
local nrdist = `nrout' * `nrestim'
matrix se_te=e(se)
matrix ci_n_te=e(ci_normal)
matrix ci_p_te=e(ci_percentile)
matrix bias_te=e(bias)
matrix all_te=(b_te[1,1..`nrcoeff']\se_te[1,1..`nrcoeff']\ci_n_te[1..2,1..`nrcoeff']\ci_p_te[1..2,1..`nrcoeff'])'
matrix all_rmsd=(b_te[1,(`nrcoeff'+1)..(`nrcoeff'+`nrdist')]\bias_te[1,(`nrcoeff'+1)..(`nrcoeff'+`nrdist')]\se_te[1,(`nrcoeff'+1)..(`nrcoeff'+`nrdist')])'
matrix all_mad=(b_te[1,(`nrcoeff'+`nrdist'+1)..(`nrcoeff'+(2*`nrdist'))]\bias_te[1,(`nrcoeff'+`nrdist'+1)..(`nrcoeff'+(2*`nrdist'))]\se_te[1,(`nrcoeff'+`nrdist'+1)..(`nrcoeff'+(2*`nrdist'))])'
matrix all_maxdist=(b_te[1,(`nrcoeff'+(2*`nrdist')+1)..(`nrcoeff'+(3*`nrdist'))]\bias_te[1,(`nrcoeff'+(2*`nrdist')+1)..(`nrcoeff'+(3*`nrdist'))]\se_te[1,(`nrcoeff'+(2*`nrdist')+1)..(`nrcoeff'+(3*`nrdist'))])'
matrix rmsd_mad_maxdist=(b_te[1,(`nrcoeff'+1)..(`nrcoeff'+`nrdist')],b_te[1,(`nrcoeff'+`nrdist'+1)..(`nrcoeff'+(2*`nrdist'))],b_te[1,(`nrcoeff'+(2*`nrdist')+1)..(`nrcoeff'+(3*`nrdist'))])
matrix meanval_one_row=(b_te[1,(`nrcoeff'+(3*`nrdist')+1)..(`nrcoeff'+(4*`nrdist'))])
matrix all_results=J(`nrout'*`ntreat',(`nrestim'*6)+3,.)
matrix p_values=J(`nrout',`nrestim',.)
local col_lab ""
local row_lab ""
local pv_row_lab ""
local pv_col_lab ""
local rmsd_col_lab ""
local mad_col_lab ""
local maxdist_col_lab ""
local meanval_col_lab ""
local cter=0

tempname pval_all
foreach o of numlist 1/`nrout' {
	tempname pval_out_`o' distances_out_`o' dist_ci_out_`o' 
	foreach e of numlist 1/`nrestim' {
		local elbl : word `e' of `estim_lb2'
		local rmsd_col_lab "`rmsd_col_lab' rmsd_out_`o'_`elbl'"
		local mad_col_lab "`mad_col_lab' mad_out_`o'_`elbl'"
		local maxdist_col_lab "`maxdist_col_lab' maxdist_out_`o'_`elbl'"
		local meanval_col_lab "`meanval_col_lab' meanval_out_`o'_`elbl'"
		local test_mcr_suff "[out_`o'_estim_`e']"
		foreach t of numlist 1/`ntreat' {
			local cter=`cter'+1
			local tr = tvals[`t',1]
			if `o'==1 & `t'==1 {
				local col_lab "`col_lab' b_`elbl' se_`elbl' cil_n_`elbl' ciu_n_`elbl' cil_p_`elbl' ciu_p_`elbl'"
				local pv_col_lab "`pv_col_lab' pval_`elbl'"
			}
			if `e'==1 {
				local row_lab "`row_lab' `o'_`tr'"
				matrix all_results[(`ntreat'*(`o'-1))+`t',(`nrestim'*6)+1]=`o'
				matrix all_results[(`ntreat'*(`o'-1))+`t',(`nrestim'*6)+2]=`tr'
				matrix all_results[(`ntreat'*(`o'-1))+`t',(`nrestim'*6)+3]=`t'
			}
			* Store results
			matrix all_results[(`ntreat'*(`o'-1))+`t',((`e'*6)-5)]=all_te[`cter',1..6]
			* Builds macro for test
			if `t'==1 local test_macr "`test_mcr_suff'treat_`tr'"
			else local test_macr "`test_macr'=`test_mcr_suff'treat_`tr'"
		}
		* Wald test of equality of treatment effects within each outcome and estimator
		* Stores p-value
		test `test_macr'
		matrix p_values[`o',`e']=r(p)
		* Added June 2011
		matrix `pval_out_`o''=(nullmat(`pval_out_`o'') , r(p))
	}
	local pv_row_lab = "`pv_row_lab' out_`o'"
	
	* Added June 2011
	* To make table of p-values and distance measures for each outcome
	* Distance measures (RMSD, MAD, Max dist) for this outcome
	matrix `distances_out_`o'' = (b_te[1,"rmsd_out_`o':estim_1".."rmsd_out_`o':estim_`nrestim'"],b_te[1,"mad_out_`o':estim_1".."mad_out_`o':estim_`nrestim'"],b_te[1,"maxdist_out_`o':estim_1".."maxdist_out_`o':estim_`nrestim'"])
	local colnames_`o': colfullnames `distances_out_`o''

	* CIs for distance measures (based on ci_percentile)
	matrix `dist_ci_out_`o'' = (ci_p_te[1..2,"rmsd_out_`o':estim_1".."rmsd_out_`o':estim_`nrestim'"],ci_p_te[1..2,"mad_out_`o':estim_1".."mad_out_`o':estim_`nrestim'"],ci_p_te[1..2,"maxdist_out_`o':estim_1".."maxdist_out_`o':estim_`nrestim'"])

	* Makes vector of p-values same dimension as vector of distances and assign colnames
	matrix `pval_out_`o'' = (`pval_out_`o'', J(1,colsof(`distances_out_`o'')-colsof(`pval_out_`o''),-1))
	matrix colnames `pval_out_`o'' = `colnames_`o''
	
	* Adds the p-values and distance results (and CIs) to the stored estimates results
	quietly estadd matrix pval_out_`o'      = `pval_out_`o''
	quietly estadd matrix distances_out_`o' = `distances_out_`o''
	quietly estadd matrix dist_ci_out_`o'   = `dist_ci_out_`o''
		
	* Creates one table per outcome with p-values, rmsd, mad and maxdist results
	estout using "`resultsdir'table_`sites's_out_`o'.csv", cells((pval_out_`o'(fmt(3) drop(mad*`o': maxdist*`o':) label(P-Value)) distances_out_`o'(fmt(3) label("dist"))) ". dist_ci_out_`o'[ll](fmt(3) par([ ])) & dist_ci_out_`o'[ul](fmt(3) par([ ]))") dropped("") unstack stats(N_reps N_misreps N N_ovlp N_novlp, fmt(0)) title(`sites' Sites - Outcome `o') eqlabels(",RMSD" "MAD" "Max Dist", span) replace delimiter(",")
}

* Assign labels to rows and columns
matrix colnames all_results = `col_lab' outcome_nr treat_nr treat_pos_nr
matrix rownames all_results = `row_lab' 
matrix colnames p_values = `pv_col_lab'
matrix rownames p_values = `pv_row_lab'
matrix colnames rmsd_mad_maxdist = `rmsd_col_lab' `mad_col_lab' `maxdist_col_lab'
matrix coleq rmsd_mad_maxdist = :
matrix colnames meanval_one_row = `meanval_col_lab' 
matrix coleq meanval_one_row = :
matrix list all_results
matrix list p_values

* Transpose matrices to use them for tables in Excel
matrix all_results_table=all_results'
matrix p_values_table=p_values'
matrix list all_results_table
matrix list p_values_table

* Save results, meanval and p_values matrices as ASCII files to be imported into Excel
mat2txt ,matrix(all_results_table) saving("`resultsdir'teffects_results") title(Treatment Effects Results) replace
mat2txt ,matrix(meanval) saving("`resultsdir'mean_estimators") title(Mean of Estimated Treatment Effects) replace
mat2txt ,matrix(p_values_table) saving("`resultsdir'teffects_pvalues") title(P-values for Treatment Effects) replace

* Saves treatment effects results and p-values in one Stata file that will be used to construct graphs
* Also save another file with rmsd, mad and maxdist values (together) and another file with meanval matrix (separate)
capture:  erase "`resultsdir'teffects_results.dta"
capture:  erase "`resultsdir'teffects_pvalues.dta"
capture:  erase "`resultsdir'teffects_meanval.dta"
capture:  erase "`resultsdir'teffects_rmsd_mad_maxdist.dta"
svmatf , mat(all_results) fil("`resultsdir'teffects_results.dta")
svmatf , mat(p_values) fil("`resultsdir'teffects_pvalues.dta")
svmatf , mat(meanval_one_row) fil("`resultsdir'teffects_meanval.dta")
svmatf , mat(rmsd_mad_maxdist) fil("`resultsdir'teffects_rmsd_mad_maxdist.dta")


* Uses bootstrap results to get the p-value for RMSD, MAD, max dist, and the 95% percentile
use "`resultsdir'bs_results.dta", clear

******************
* Added June 2011
* Calculates p-value and distance measures when excluding a site, if the number of sites is 5
******************
if "`sites'"=="5" {
	foreach tr of numlist 1/`nrtreat' {
		* Creates list of values and labels of treatments excluding one treatment at a time
		local tr_exclude: word `tr' of `tvals'
		local tvals_exc: list tvals - tr_exclude
		local tr_lab_exc: word `tr' of `treat_lbl'
		local treat_lbl_exc: list treat_lbl - tr_lab_exc
		
		* Calculates statistics and saves results for analysis based on reduced number of sites
		tempname b_te betas_short pval pval_all rmsd mad maxdist meanval pval_all rmsd_all mad_all maxdist_all meanval_all rmsd_ci mad_ci maxdist_ci meanval_ci rmsd_ci_all mad_ci_all maxdist_ci_all meanval_ci_all rmsd_rel mad_rel maxdist_rel rmsd_rel_all mad_rel_all maxdist_rel_all 
		matrix `b_te'=e(b)
		foreach o of numlist 1/`nrout' {
			tempname pval_out_`o' rmsd_out_`o' mad_out_`o' maxdist_out_`o' meanval_out_`o' rmsd_ci_out_`o' mad_ci_out_`o' maxdist_ci_out_`o' meanval_ci_out_`o' 
			
			foreach e of numlist 1/`nrestim' {
				capture matrix drop `betas_short'
				local test_macr_suff "[out_`o'_estim_`e']"
				local cter_t "0"
				foreach t of local tvals_exc {
					local cter_t = `cter_t' + 1
					if `cter_t' == 1 local test_macr "`test_macr_suff'treat_`t'"
					else local test_macr "`test_macr' = `test_macr_suff'treat_`t'"
					matrix `betas_short' = (nullmat(`betas_short'),`b_te'[1,"out_`o'_estim_`e':treat_`t'"])
				}
				
				* P-value from test of joint significance of reduced number of sites
				quietly test `test_macr'
				matrix `pval' = r(p)
				matrix coleq `pval' = pval_out_`o'
				matrix colnames `pval' = estim_`e'
				matrix `pval_out_`o''=(nullmat(`pval_out_`o'') , `pval')
				
				* Calculate root mean squared distance, mean absoulte distance and maximum distance 
				mata: dist("`betas_short'",0,"`rmsd'","`mad'","`maxdist'","`meanval'",0,0)
				matrix coleq `rmsd' = rmsd_out_`o'
				matrix colnames `rmsd' = estim_`e'
				matrix `rmsd_out_`o''=(nullmat(`rmsd_out_`o'') , `rmsd')
				matrix coleq `mad' = mad_out_`o'
				matrix colnames `mad' = estim_`e'
				matrix `mad_out_`o''=(nullmat(`mad_out_`o'') , `mad')
				matrix coleq `maxdist' = maxdist_out_`o'
				matrix colnames `maxdist' = estim_`e'
				matrix `maxdist_out_`o''=(nullmat(`maxdist_out_`o'') , `maxdist')
				matrix coleq `meanval' = meanval_out_`o'
				matrix colnames `meanval' = estim_`e'
				matrix `meanval_out_`o''=(nullmat(`meanval_out_`o'') , `meanval')
				
				* Calculate CIs for rmsd, mad, max_dist based on BS stored results
				mata: dist_bs("out_`o'_estim_`e'_b_treat_", `"`tvals_exc'"', "`rmsd_ci'", "`mad_ci'", "`maxdist_ci'", "`meanval_ci'",0)
				matrix coleq `rmsd_ci' = rmsd_out_`o'
				matrix colnames `rmsd_ci' = estim_`e'
				matrix `rmsd_ci_out_`o''=(nullmat(`rmsd_ci_out_`o'') , `rmsd_ci')
				matrix coleq `mad_ci' = mad_out_`o'
				matrix colnames `mad_ci' = estim_`e'
				matrix `mad_ci_out_`o''=(nullmat(`mad_ci_out_`o'') , `mad_ci')
				matrix coleq `maxdist_ci' = maxdist_out_`o'
				matrix colnames `maxdist_ci' = estim_`e'
				matrix `maxdist_ci_out_`o''=(nullmat(`maxdist_ci_out_`o'') , `maxdist_ci')
				matrix coleq `meanval_ci' = meanval_ci_out_`o'
				matrix colnames `meanval_ci' = estim_`e'
				matrix `meanval_ci_out_`o''=(nullmat(`meanval_ci_out_`o'') , `meanval_ci')
			}
			
			* Puts in one vector all the p-values results
			matrix `pval_all' = (nullmat(`pval_all'),`pval_out_`o'')
					
			* Puts in one vector rmsds and CIs for each outome
			matrix `rmsd_all'=(nullmat(`rmsd_all') , `rmsd_out_`o'')
			matrix `rmsd_ci_all'=(nullmat(`rmsd_ci_all') , `rmsd_ci_out_`o'')
			matrix rownames `rmsd_ci_all' = ll ul
			* Puts in one vector mads and CIs for each outome
			matrix `mad_all'=(nullmat(`mad_all') , `mad_out_`o'')
			matrix `mad_ci_all'=(nullmat(`mad_ci_all') , `mad_ci_out_`o'')
			matrix rownames `mad_ci_all' = ll ul
			* Puts in one vector max distances and CIs for each outome
			matrix `maxdist_all'=(nullmat(`maxdist_all') , `maxdist_out_`o'')
			matrix `maxdist_ci_all'=(nullmat(`maxdist_ci_all') , `maxdist_ci_out_`o'')
			matrix rownames `maxdist_ci_all' = ll ul
			* Puts in one vector value of means and CIs for each outome
			matrix `meanval_all'=(nullmat(`meanval_all') , `meanval_out_`o'')
			matrix `meanval_ci_all'=(nullmat(`meanval_ci_all') , `meanval_ci_out_`o'')
			matrix rownames `meanval_ci_all' = ll ul			
		}
		
		* Adds columns to pval_all matrix just so it can be output properly with estout
		matrix `pval_all' = (`pval_all',J(1,colsof((`mad_all',`maxdist_all',`meanval_all')),-1))
		* Puts all the results together and add them to the stored estimates results
		quietly estadd matrix b_exc_`tr_lab_exc' 		  = (`rmsd_all',`mad_all',`maxdist_all',`meanval_all')
		quietly estadd matrix ci_p_exc_`tr_lab_exc'   = (`rmsd_ci_all',`mad_ci_all',`maxdist_ci_all',`meanval_ci_all')
		* First fix names of pvaluex vector
		local colnames: colfullnames e(b_exc_`tr_lab_exc')
		matrix colnames `pval_all' = `colnames'
		quietly estadd matrix pvalue_exc_`tr_lab_exc' = `pval_all'
		
		* Creates one table per outcome with p-values, rmsd, mad and maxdist results
		foreach o of numlist 1/`nrout' {
			estout using "`resultsdir'table_exc_`tr_lab_exc'_from_`sites's_out_`o'.csv", keep(rmsd*`o': mad*`o': maxdist*`o':) cells((pvalue_exc_`tr_lab_exc'(fmt(3) drop(mad*`o': maxdist*`o':) label(P-Value)) b_exc_`tr_lab_exc'(fmt(3) label("dist"))) ". ci_p_exc_`tr_lab_exc'[ll](fmt(3) par([ ])) & ci_p_exc_`tr_lab_exc'[ul](fmt(3) par([ ]))") dropped("") unstack stats(N_reps N_misreps N N_ovlp N_novlp, fmt(0)) title(Excluding `tr_lab_exc' from `sites' sites results - Outcome `o') eqlabels(",RMSD" "MAD" "Max Dist", span) replace delimiter(",")
		}
	}
}
************************
* End addition June 2011
************************

* Creates matrix with all the results from BS
mkmat *, matrix(all_bs)
matrix colnames all_bs = `bbs_nms'

* Creates variables with p-values of Wald tests  for equality of means for each estimator and each iteration from BS
* Also dummies for Wald Test rejected at 5% significance level (to count percentage rejections)
local waldpv_row_lab ""
forvalues i = 1/`nreps' {
	foreach o of numlist 1/`nrout' {
		foreach e of numlist 1/`nrestim' {
			local elbl : word `e' of `estim_lb2'
			local test_mcr_suff "[out_`o'_estim_`e']"
			if `i'==1 {
				qui gen waldpv_out_`o'_estim_`e'=.
				qui gen drej_wald_out_`o'_estim_`e'=.
				local waldpv_row_lab "`waldpv_row_lab' waldpv_out_`o'_`elbl'"
			}
			foreach t of numlist 1/`ntreat' {
				local tr = tvals[`t',1]
				* Builds macro for test
				if `t'==1 local test_macr "`test_mcr_suff'treat_`tr'"
				else local test_macr "`test_macr'=`test_mcr_suff'treat_`tr'"
			}
			* Wald test of equality of treatment effects within each outcome and estimator
			* Use "capture" here to deal with cases in which bootstrap replication might be missing (March 2011)
			capture {
				* Stores p-value
				matrix bi=all_bs[`i',1..colsof(all_bs)]
				* Command b_bsi picks one row of BS replications, and the BS var-cov and puts them in ereturn
				b_bsi bi Vbs
				* Wald test of equality of means
				qui test `test_macr'
				qui replace waldpv_out_`o'_estim_`e'=r(p) if _n==`i'
				* Dummy for Wald Test rejected at 5% significance level
				qui replace drej_wald_out_`o'_estim_`e'=(r(p)<=0.05) if _n==`i'
			}
			* Calculate percentiles of p-values for Wald tests (when it gets to last replication)
			if `i'==`nreps' {
				* Percentage Wald Test rejected at 5% significance level
				qui summ drej_wald_out_`o'_estim_`e'
				matrix waldpv_centi=r(mean)
				* Wald test p-values percentiles
				qui centile waldpv_out_`o'_estim_`e', centile(0 5 50 95 100)
				matrix waldpv_centi=(waldpv_centi,r(c_1),r(c_2),r(c_3),r(c_4),r(c_5))
				matrix waldpv_cent=((nullmat(waldpv_cent))\waldpv_centi)
			}
		}
	}	
}
matrix colnames waldpv_cent = prej_5 min p5 p50 p95 max
matrix rownames waldpv_cent = `waldpv_row_lab'
matrix list waldpv_cent

* Save matrix as ASCII file to be imported into Excel
mat2txt ,matrix(waldpv_cent) saving("`resultsdir'waldpv_results") title(Centiles for Wald Tests p-values) replace

* Save dataset with results+Wald_pv results
save "`resultsdir'bs_results_waldpv.dta", replace

* Uses bootstrap results to get the p-value for RMSD, MAD, maximum distance, and some percentiles
use "`resultsdir'bs_results.dta", clear
keep rmsd* mad* maxdist*
gen row="y1"
merge row using "`resultsdir'teffects_rmsd_mad_maxdist.dta", uniqusing sort
drop row _merge

* Creates indicators for bootstrapped rmsd, mad, max distance above the actual value of rmsd, mad, max distance
* Also get some percentile of rmsd, mad, max distance
local drmsd_list ""
local dmad_list ""
local dmaxdist_list ""
foreach o of numlist 1/`nrout' {
	foreach e of numlist 1/`nrestim' {
		local elbl : word `e' of `estim_lb2'
		local drmsd_list "`drmsd_list' d_rmsd_out_`o'_b_estim_`e'"
		local dmad_list  "`dmad_list' d_mad_out_`o'_b_estim_`e'"
		local dmaxdist_list  "`dmaxdist_list' d_maxdist_out_`o'_b_estim_`e'"
		gen d_rmsd_out_`o'_b_estim_`e'= (rmsd_out_`o'_b_estim_`e' > rmsd_out_`o'_`elbl')
		gen d_mad_out_`o'_b_estim_`e' = (mad_out_`o'_b_estim_`e' > mad_out_`o'_`elbl')
		gen d_maxdist_out_`o'_b_estim_`e' = (maxdist_out_`o'_b_estim_`e' > maxdist_out_`o'_`elbl')
		* RMSD percentiles
		qui centile rmsd_out_`o'_b_estim_`e', centile(0 5 50 95 100)
		matrix rmsd_cent=(nullmat(rmsd_cent)\(r(c_1),r(c_2),r(c_3),r(c_4),r(c_5)))
		* MAD percentiles
		qui centile mad_out_`o'_b_estim_`e', centile(0 5 50 95 100)
		matrix mad_cent=(nullmat(mad_cent)\(r(c_1),r(c_2),r(c_3),r(c_4),r(c_5)))
		* MAX distance percentiles
		qui centile maxdist_out_`o'_b_estim_`e', centile(0 5 50 95 100)
		matrix maxdist_cent=(nullmat(maxdist_cent)\(r(c_1),r(c_2),r(c_3),r(c_4),r(c_5)))
	}
}

* Calculate p-values for rmsd, mad, max distance (as % of bootstrapp values above real value)
qui mean `drmsd_list' 
matrix pval_rmsd = e(b)
qui mean `dmad_list' 
matrix pval_mad = e(b)
qui mean `dmaxdist_list' 
matrix pval_maxdist = e(b)
* Puts matrices together 
matrix all_rmsd=(all_rmsd,pval_rmsd',rmsd_cent)
matrix all_mad=(all_mad,pval_mad',mad_cent)
matrix all_maxdist=(all_maxdist,pval_maxdist',maxdist_cent)
* Add names
matrix colnames all_rmsd = rmsd bias se pval min p5 p50 p95 max
matrix rownames all_rmsd = `rmsd_col_lab'
matrix roweq all_rmsd = :
matrix colnames all_mad = mad bias se pval min p5 p50 p95 max
matrix rownames all_mad = `mad_col_lab'
matrix roweq all_mad = :
matrix colnames all_maxdist = maxdist bias se pval min p5 p50 p95 max
matrix rownames all_maxdist = `maxdist_col_lab'
matrix roweq all_maxdist = :
matrix list all_rmsd
matrix list all_mad
matrix list all_maxdist

* Save matrices as ASCII files to be imported into Excel
mat2txt ,matrix(all_rmsd) saving("`resultsdir'rmsd_results") title(RMSD Results) replace
mat2txt ,matrix(all_mad) saving("`resultsdir'mad_results") title(MAD Results) replace
mat2txt ,matrix(all_maxdist) saving("`resultsdir'maxdist_results") title(Maximum Distance Results) replace


* Merge all results in one file (will be used for graphs)
use "`resultsdir'teffects_results.dta", clear
merge using "`resultsdir'teffects_pvalues.dta"
drop _merge row
erase "`resultsdir'teffects_pvalues.dta"
merge using "`resultsdir'teffects_meanval.dta"
drop _merge row
erase "`resultsdir'teffects_meanval.dta"
merge using "`resultsdir'teffects_rmsd_mad_maxdist.dta"
drop _merge row
erase "`resultsdir'teffects_rmsd_mad_maxdist.dta"

* Creates variables with the min and max of CIs across all estimators, for each treatment level and outcome
egen ci_n_min=rowmin(cil_n_*)
egen ci_n_max=rowmax(ciu_n_*)
egen ci_p_min=rowmin(cil_p_*)
egen ci_p_max=rowmax(ciu_p_*)

* To determine scales, use the local variable "nrgroups" which indicates that outcomes are "grouped"
* (for example in levels and DID) to create "out_group" variable
local out_per_grp = `nrout' / `nrgroups'
local rec_list ""
foreach g of numlist 1/`nrgroups' {
	local fst_out = `out_per_grp' * (`g'-1)+1
	local lst_out = `out_per_grp' * `g'
	local rec "(`fst_out'/`lst_out'=`g') "
	local rec_list : list rec_list | rec
}
recode outcome_nr `rec_list', generate(out_group)

* Save data for future use
save "`resultsdir'teffects_results.dta", replace

* Creates graphs for each outcome and estimator. Each graph will have two versions:
*  1) Using normal-based Confidence Intervals
*  2) Using percentile-based Confidence Intervals

* If LEC adjustment was requested, reflect that in names of yvars
if "`lec_adjustment'"=="1" {
	local orig_yvars "`yvars'"
	local yvars ""
	foreach o of numlist 1/`orig_nrout' {
		local yvname : word `o' of `orig_yvars'
		local yvars "`yvars' `yvname' lec_`yvname'"
	}
}

* Determine min and max values for xaxis and create xaxis label
qui summ treat_pos_nr
local mint = r(min)
local minx = `mint' - (0.25 * `mint')
local maxt = r(max)
local maxx = `maxt' + (0.25 * `mint')
local xaxis_lbl ""
foreach t of numlist `mint'/`maxt' {
	local tlbl : word `t' of `treat_lbl'
	local xaxis_lbl " `xaxis_lbl' `t' `"`tlbl'"' "
}
mat list meanval
foreach o of numlist 1/`nrout' {
	* Determine for this outcome the min and max confidence interval to pick right scale
	local grp=out_group[`o'*`ntreat']
	qui tabstat  ci_n_min ci_p_min if out_group==`grp', stats(min) save
	matrix cimins= r(StatTotal)
	qui tabstat  ci_n_max ci_p_max if out_group==`grp', stats(max) save
	matrix cimaxs= r(StatTotal)
	* Set the scale a little bit above and below the mins and max (factor=1.15)
	local min_n =  round(cimins[1,1] - (.25 * cimins[1,1]),.1)
	local max_n =  round(cimaxs[1,1] + (.25 * cimins[1,1]),.1)
	local min_p =  round(cimins[1,2] - (.25 * cimins[1,2]),.1)
	local max_p =  round(cimaxs[1,2] + (.25 * cimins[1,2]),.1)
	* Set scales
	local range_n "`min_n' `max_n'"
	local range_p "`min_p' `max_p'"
	
	* Initialize macro vars with graph names
	local ac_gname_n ""
	local ac_gname_p ""
	
	foreach e of numlist 1/`nrestim' {
		local oname : word `o' of `yvars'
		local elbl : word `e' of `estim_lbl_grph'
		local evname : word `e' of `estim_lb2'
		local pval = string(pval_`evname'[`o'],"%5.3f") 
		local meanval = string(meanval_out_`o'_`evname'[1],"%5.3f")
		local rmsd = string(rmsd_out_`o'_`evname'[1],"%5.3f")
		local mad = string(mad_out_`o'_`evname'[1],"%5.3f")
		local maxdist = string(maxdist_out_`o'_`evname'[1],"%5.3f")
		local xpos_meanval = `minx'+(0.015 * `mint')
		local ypos_meanval = `meanval'
		local gname_n "`graphsdir'n_`oname'_`evname'.gph"
		local gname_p "`graphsdir'p_`oname'_`evname'.gph"
		local ac_gname_n "`ac_gname_n' `gname_n'"
		local ac_gname_p "`ac_gname_p' `gname_p'"
				
		* Graph using normal-based confidence intervals
		twoway scatter b_`evname' treat_pos_nr if  outcome_nr==`o', sort || rcap  cil_n_`evname' ciu_n_`evname' treat_pos_nr if outcome_nr==`o', sort title(`elbl', size(medlarge)) subtitle("p-value joint equality test = `pval'" "RMSD = `rmsd', MAD = `mad', Max Dist = `maxdist'", size(medsmall)) ytitle(E[Y(0,D)]) yscale(range(`range_n')) ylabel(#4,format(%4.1f)) ylabel(,labsize(small)) ytick(#4) xtitle("")  xlabel(`minx' " " `xaxis_lbl' `maxx' " ", noticks) xlabel(,labsize(medlarge)) legend(off) yline(`meanval', lpattern(shortdash) lcolor(red) lwidth(medthin)) text(`ypos_meanval' `xpos_meanval' "Avg", place(n) size(small) color(black)) nodraw 
		graph save "`gname_n'", replace
		
		* Graph using percentile-based confidence intervals
		twoway scatter b_`evname' treat_pos_nr if  outcome_nr==`o', sort || rcap  cil_p_`evname' ciu_p_`evname' treat_pos_nr if outcome_nr==`o', sort title(`elbl', size(medlarge)) subtitle("p-value joint equality test = `pval'" "RMSD = `rmsd', MAD = `mad', Max Dist = `maxdist'", size(medsmall)) ytitle(E[Y(0,D)]) yscale(range(`range_p')) ylabel(#4,format(%4.1f)) ylabel(,labsize(small)) ytick(#4) xtitle("")  xlabel(`minx' " " `xaxis_lbl' `maxx' " ", noticks) xlabel(,labsize(medlarge)) legend(off) yline(`meanval', lpattern(shortdash) lcolor(red) lwidth(medthin)) text(`ypos_meanval' `xpos_meanval' "Avg", place(n) size(small) color(black)) nodraw 
		graph save "`gname_p'", replace
	}
}

* Closes graphs
graph drop _all
