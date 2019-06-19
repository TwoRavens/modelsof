* MAIN_RESULTS.DO
*
* This program obtains all results (except for benchmark model)
* for Tables 1 to 4 in the paper
*
* It also allows (with the right modifications, see end of the program)
* to obtain all the results in Table 5 (as well as all the results in
* online appendix)
*
* Program written for Flores, Carlos A. and Oscar A. Mitnik (2013). 
* "Comparing Treatments across Labor Markets: An Assessment of Nonexperimental 
* Multiple-Treatment Strategies", Review of Economics and Statistics, 
* December 2013, Vol. 95, No. 5, Pages 1691-1707.
*
* This version:  March 2011
*

clear all
version 11
set more off
set mem 1000m
set matsize 5000
set emptycells drop
set maxvar 32000
set more off

* Fill in here information on directories
* Note: if not provided, directory from which Stata 
*       is executed is assumemd
local pgsdir 	""	// Directory with all the programs
local datadir ""	// Directory with the analysis files


* Set here name of results folder (inside the programs directory)
* which will contain all sub-folders with results
* The name of the sub-folders will be determined by options for suffixes below
local resname "Results"

* Select if analysis will be based on 4 or 5 "sites"
* (In paper, 5 sites, in appendix also 4 sites presented)
local sites "5"
                       
* Set here suffixes that will be used in naming directories
* Overlap value
* In paper q=0.0025 (0.25 percentile) used, here changes can be introduced
* to impose alternative values for q or no overlap
* Options:
*					nov:  no overlap rule imposed
*				  min:  minimum gps
*				  01p:  0.1 percentile
*				  02p:  0.2 percentile
*					025p: 0.3 percentile
*					03p:  0.3 percentile
*					04p:  0.4 percentile
*					05p:  0.5 percentile
local suff_ovlp "025p"

* GPS method & whether re-estimate GPS after overlap
* In Tables 2-3 MNL used, in Table 5 alternative GPS specifications provided
* Options: 
* 				- mnl: 					Multinomial logit
*					- mnl_r:				Multinomial logit with re-estimation of GPS after imposing overlap
*					- mprobit:  		Multinomial probit
*					- mprobit_r: 		Multinomial probit with re-estimation of GPS after imposing overlap
*					- ipt_mnl:  		Multinomial logit by GMM with IPT constraints
*					- ipt_mnl_r: 		Multinomial logit by GMM with IPT constraints and re-estimation of GPS after imposing overlap
*					- ipt_logit:		Logit by GMM (system or series estimation) with IPT constraints
*					- ipt_logit_r:	Logit by GMM (system or series estimation) with IPT constraint and re-estimation of GPS after imposing overlap  
*         - mnl_r_ipt_l:  In first stage estimate by multinomial logit, but re-estimate with logit by GMM imposing IPT conditions
local suff_mthd "mnl"
  
* Put here any other suffix (goes at the end) which identifies this particular run
local oth_suff ""                       
                      
* Check that information is complete
if ("`resname'"=="" |"`sites'"=="" | "`suff_ovlp'"=="" | "`suff_mthd'"=="") {
		di as error "Incomplete information in the initial options to run the program"
		error 499
}

* Assign current directory to programs and data directories, if not specified
if "`pgsdir'"=="" 	local pgsdir  "`c(pwd)'/"
if "`datadir'"==""	local datadir "`c(pwd)'/"

* Make sure "pgs" directory exists
capture confirm file "`pgsdir'"
if _rc~=0 {
	display as error "Cannot find programs directory"
	error 170 
}

* Checks if resname exists, and if it does not exist, then it is created
local resdir "`pgsdir'//`resname'/"
capture mkdir "`resdir'"

* Defines results directory (inside "pgsdir") and graphs directory (inside results directory)
if ("`oth_suff'"~="") local oth_suff "_`oth_suff'"
local resultsdir "`resdir'//results_`sites's_`suff_ovlp'_`suff_mthd'`oth_suff'/"
local graphsdir "`resultsdir'figures/"

* If resultsdir and graphsdir do not exist, creates them
capture mkdir "`resultsdir'"
capture mkdir "`graphsdir'"

* Creates log file
capture log close
log using "`resultsdir'main_results.log", replace

* Outcome variables
local yvars 		"vempq2t9 dvempq2t9"

* Covariates
local xpemp    			  "emppq1 emppq2 emppq3 emppq4  emppq5 emppq6 emppq7 emppq8"
local xpearn   			  "r_pearn1 r_pearn2 r_pearn3 r_pearn4 r_pearn5 r_pearn6 r_pearn7 r_pearn8"
local xdem	 	 			  "black age30t39 agege40 birth19u "
local xfam   	 			  "nevmar chld0t5 chld6t12 twochild thrchild"
local xeduc  	 			  "grade10 grade11 gradge12 hsged"
local xhist  	 			  "pshous moves1t2 movesge3 oadclt2y oadc2t5y oadc5t10 afdcpq1 afdcpq2 afdcpq3 afdcpq4 afdcpq5 afdcpq6 afdcpq7 fspq1 fspq2 fspq3 fspq4 fspq5 fspq6 fspq7 "
local xemp   	 			  "curemp wrkft6mo"
local xearn  	 			  "bernv"
local xnodid   			  "`xpemp' `xpearn'" 
local xextra    			"r_pearn_q1_q8_2 r_pearn_q1_q8_3 black_nowelf_pq1_pq7 black_nofs_pq1_pq7 black_noemp_pq1_pq8 black_r_pearn_q1_q8 black_r_pearn_q1_q8_2 black_r_pearn_q1_q8_3 nevmar_nowelf_pq1_pq7 nevmar_nofs_pq1_pq7 nevmar_noemp_pq1_pq8 nevmar_r_pearn_q1_q8 nevmar_r_pearn_q1_q8_2 nevmar_r_pearn_q1_q8_3 chld0t5_nowelf_pq1_pq7 chld0t5_nofs_pq1_pq7 chld0t5_noemp_pq1_pq8 chld0t5_r_pearn_q1_q8 chld0t5_r_pearn_q1_q8_2 chld0t5_r_pearn_q1_q8_3 gradge12_nowelf_pq1_pq7 gradge12_nofs_pq1_pq7 gradge12_noemp_pq1_pq8 gradge12_r_pearn_q1_q8 gradge12_r_pearn_q1_q8_2 gradge12_r_pearn_q1_q8_3 hsged_nowelf_pq1_pq7 hsged_nofs_pq1_pq7 hsged_noemp_pq1_pq8 hsged_r_pearn_q1_q8 hsged_r_pearn_q1_q8_2 hsged_r_pearn_q1_q8_3 pshous_nowelf_pq1_pq7 pshous_nofs_pq1_pq7 pshous_noemp_pq1_pq8 pshous_r_pearn_q1_q8 pshous_r_pearn_q1_q8_2 pshous_r_pearn_q1_q8_3 movesge3_nowelf_pq1_pq7 movesge3_nofs_pq1_pq7 movesge3_noemp_pq1_pq8 movesge3_r_pearn_q1_q8 movesge3_r_pearn_q1_q8_2 movesge3_r_pearn_q1_q8_3 oadclt2y_nowelf_pq1_pq7 oadclt2y_nofs_pq1_pq7 oadclt2y_noemp_pq1_pq8 oadclt2y_r_pearn_q1_q8 oadclt2y_r_pearn_q1_q8_2 oadclt2y_r_pearn_q1_q8_3"
local xextragps 			""

* Only to decide which variables are kept (put here variables in "xextragps" not elsewhere)
local xgpslist "noemp_pq1_pq8"

* Local economic conditions adjustment related-variables
* If lec_adjustment ==1 then run LEC adjustment
local lec_adjustment "1"

* Level at which LEC adjustment will be done (site * RA cohort)
local lec_lev_vars "alphsite radatp"
* Grouping variable for LEC adjustment (if empty, only one group)
local lec_grp_vars ""

* Variables used for LEC adjustment
* Outcome variables in t-1 and t-2
local lec_yvar_1 "emp_1 emp_1"
local lec_yvar_2 "emp_2 emp_2"

* LEC variables in period t (the ";" separates variables used in each model
local lec_v_t_out1 "lunemp_rate12     ltot_emp_pop12     lavg_tot_rern12"
local lec_v_t_out2 "lunemp_rate12_1_2 ltot_emp_pop12_1_2 lavg_tot_rern12_1_2"
local lec_vars_t   "`lec_v_t_out1' ; `lec_v_t_out2'"

local lec_v_1    "lunemp_rate_1 ltot_emp_pop_1  lavg_tot_rern_1"
local lec_v_2    "lunemp_rate_2 ltot_emp_pop_2  lavg_tot_rern_2"
local lec_vars_1 "`lec_v_1' ; `lec_v_1'"
local lec_vars_2 "`lec_v_2' ; `lec_v_2'"

* Site variable to add to LEC regression model
local lec_site_var "alphsite"

* Covariates to add to LEC regression model
local lec_xvars "`xdem' `xfam' `xeduc' `xhist'"

* Decide whether to add options to estimation of LEC model
if ("`lec_site_var'"=="" & "`lec_xvars'"=="") local lec_options ""
else {
	if ("`lec_site_var'"~="") local lec_options "lec_site_var(`lec_site_var')"
	if ("`lec_xvars'"~="") local lec_options "`lec_options' lec_xvars(`lec_xvars')"
}

* All LEC adjustment related variables together
local lecvars "`lec_lev_vars' `lec_grp_vars' `lec_yvar_1' `lec_yvar_2' `lec_vars_t' `lec_vars_1' `lec_vars_2'"
local lecvars: subinstr local lecvars ";" "", all

* Lists of variables (to "keep" later)
local xvars "`xdem' `xfam' `xeduc' `xhist' `xemp' `xearn'" 
local xgps 	"`xvars' `xnodid' `xextragps'" 

* Covariates for balancing (same as above, but in order we want them for tables)
local xempbal  "emppq1 emppq2 emppq3 emppq4  emppq5 emppq6 emppq7 emppq8 curemp wrkft6mo"
local xearnbal "r_pearn1 r_pearn2 r_pearn3 r_pearn4 r_pearn5 r_pearn6 r_pearn7 r_pearn8 bernv"
local xvarsbal "`xdem' `xfam' `xeduc' `xhist' `xempbal' `xearnbal'"

* Variables for which descriptive statistics will be presented
local descvar 		  "`yvars' `xvarsbal'"
local xlec_past_fut "`xlec_past' `xlec_future'"
local descvar: list descvar - xlec_past_fut 
local descvar "`descvar' tot_emp_pop0 avg_tot_rern0 unemp_rate0 tot_emp_popg0_2 avg_tot_rerng0_2 unemp_rateg0_2 tot_emp_popg2_0 avg_tot_rerng2_0 unemp_rateg2_0"

* Variable that defines sites
local treatvar "alphsite"

* Labels for treatment categories (determines also number of categories) - Put each label within quotes. 
if `sites'==4 {
	* Using 4 groups
	local treat_lbl ""Atlanta" "Detroit" "Grand Rapids" "Portland""
	local treat_lbl ""ATL" "DET" "GRP" "POR""
}
else if `sites'==5 {
	* Using 5 groups
	local treat_lbl ""Atlanta" "Detroit" "Grand Rapids" "Portland" "Riverside""
	local treat_lbl ""ATL" "DET" "GRP" "POR" "RIV""
}
local nrtreat: word count `treat_lbl'


* List of variables to keep to make dataset smaller (Bootstrap runs faster)
local keepvars "`yvars' `treatvar' `xvars' `xgpslist' `xnodid' `xextra' `lecvars' `xvarsbal' idnumber radatp atlanta rivrside grandrap columbus portland detroit oklahoma white hispanic black notbw ra92 ra93 ra94 tot_emp_pop0 avg_tot_rern0 unemp_rate0 tot_emp_popg0_2 avg_tot_rerng0_2 unemp_rateg0_2 tot_emp_popg2_0 avg_tot_rerng2_0 unemp_rateg2_0"
local keepvars : list uniq keepvars

* Data to be used
use "`datadir'analysis.dta", clear 

* Drops Riverside for 4 sites analyses
if (`sites'==4) drop if alphsite==7

* String indicating which outcomes are Diff-in-Diff (0=levels, 1=DID)
local did "0,1"


* THIS ONLY AFFECTS HOW THE SCALE OF THE Y AXIS OF GRAPHS IS PRESENTED
* Indicate here how many "groups" are formed by the outcomes (e.g.: the same outcome in levels, DID and LEC adjusted forms a group)
* If all outcomes are to be treated separately, put here the total number of outcomes.
* NOTE: Make sure that the number of grups is such that # outcomes/ # groups = integer number
local nrgroups "1"

* Define here if estimation on full sample (100%) or less than full sample
local smp "100"

* Set here if outcome variables will be standardized by mean and standard deviations (1=yes, 0=no)
local ystd "0"

* Set here if rmsd and mad will be standardized by mean of estimated outcomes for each estimator (1=yes, 0=no)
* (this option is set to 1 by default if ystd=0)
local betastd "1"

* Set which mean will be used for standardization (1=weighted mean, 0=unweighted mean) - only matters if "betastd"==1
local betastd_wgt_mean "0"

* Options for Overlap
* Whether overlap condition will be imposed or not (1=yes, 0=no)
if ("`suff_ovlp'"=="nov") local overlap "0"
else local overlap "1"
* Define whether percentile-base overlap (if requested) will be based
* on treatment-level-by-treatment-level percentile, or based on a percentile
* for all treatments different to the one being considered pooled
* 0=not pooled, 1=pooled
local ovlp_pooled "1"
* Rule for overlap condition (0=min/max, >0 quantile rule)
* Percentiles are defined in the [0,1] interval
if ("`suff_ovlp'"=="nov" | "`suff_ovlp'"=="min") local ovlp_value "0"
else if ("`suff_ovlp'"=="01p")  local ovlp_value "0.001"
else if ("`suff_ovlp'"=="02p")  local ovlp_value "0.002"
else if ("`suff_ovlp'"=="025p") local ovlp_value "0.0025"
else if ("`suff_ovlp'"=="03p")  local ovlp_value "0.003"
else if ("`suff_ovlp'"=="04p")  local ovlp_value "0.004"
else if ("`suff_ovlp'"=="05p")  local ovlp_value "0.005"

* Defines wether overlap is based on two tails (ovlp_one_tail=0) or one tail only (ovlp_one_tail=1)
local ovlp_one_tail "1"

* Rule for maximum (normalized) weight value. If max_wgt_value = 0 then no maximum is imposed.
local max_wgt_value "0"


* Define here if GPS will be estimated using a multinomial logit or multinomial probit (default=multinomial logit)
* if "mprobit" is 0=mlogit, if it is 1=mprobit (default if nothing specified is =0)
if ("`suff_mthd'"=="mprobit" | "`suff_mthd'"=="mprobit_r") local mprobit "1"
else local mprobit "0"

* Define here if GPS will be estimated using a multinomial logit or a GMM-based method (default=multinomial logit)
* if "gmm" is 0=mlogit, if it is 1=gmm-based method (default if nothing specified is =0)
if ("`suff_mthd'"=="ipt_mnl" | "`suff_mthd'"=="ipt_mnl_r" | "`suff_mthd'"=="ipt_logit" | "`suff_mthd'"=="ipt_logit_r" | "`suff_mthd'"=="mnl_r_ipt_l") local gmm "1" 
else local gmm "0"

* Define here the gmm method (only relevant if "gmm" = 1)
* There are four options:
*	- mlogit_gmm: 		 for estimating GPS with a standard multinomial logit model but by GMM
*	- mlogit_ipt: 		 for estimating mltinomial logit model by GMM and imposing perfect balancing conditions (IPT)
*	- logit_ipt:  		 for estimating GPS by GMM, using a system of binary logit models for each treatment category,
*	              		 imposing perfect balancing conditions 
*	- indiv_logit_ipt: for estimating GPS by GMM, using a series of one-by-one logit models for each treatment category,
*                    imposing perfect balancing conditions
* - mnl_r_ipt_l:     for estimating GPS in first stage by standard MNL (no GMM) and then re-estimate GPS in second
*										 stage by GMM using indiv_logit_ipt method (imposing IPT conditions)
*	NOTE: estimating with logit_ipt or indiv_logit_ipt give the same results, but with several treatment categories, indiv_logit_ipt is faster
if ("`suff_mthd'"=="ipt_mnl" | "`suff_mthd'"=="ipt_mnl_r") local gmm_method "mlogit_ipt"
else if ("`suff_mthd'"=="ipt_logit" | "`suff_mthd'"=="ipt_logit_r") local gmm_method "indiv_logit_ipt"
else if ("`suff_mthd'"=="mnl_r_ipt_l") local gmm_method "mnl_r_ipt_l"

* Define here if GPS will be re-estimated AFTER overlap condition is imposed (only relevant if "overlap"==1)
* if "re_estim_gps" = 0 (default) the GPS is NOT re-estimated after imposing overlap condition
* If "re_estim_gps" = 1 then GPS is estimated, then the selected overlap condition is applied, and then 
*												GPS is re-estimated only using those individuals for which the overlap condition is satisfied.
if ("`suff_mthd'"=="mnl_r" | "`suff_mthd'"=="mprobit_r" | "`suff_mthd'"=="ipt_mnl_r"  | "`suff_mthd'"=="ipt_logit_r" | "`suff_mthd'"=="mnl_r_ipt_l") local re_estim_gps "1"
else local re_estim_gps "0"


* Options for non-parametric estimation of partial mean estimator
* Degree of local polynomial regression
local degree "1"
* Kernel (only one of these two from kernel options of "locpoly": epanechnikov | gaussian)
*local kern "gaussian"
local kern "epanechnikov"
* Binning: 0= no binning, 1=binning
local bin "1"
* Number of bins (when bin=1)
local bin_nr "200"

* GPS kernel density graph name (leave empty to avoid creating graphs)
* Two versions of the files are created: 1) using standard kernel, and 
* 2) following McCrary (2008). For 2) both count- and density-based
* figures are created
local kernelgraphfile "`graphsdir'GPS_kernel_density"

* Box Plot graph name (leave empty to avoid creating graphs)
local boxgraphfile "`graphsdir'boxplot"


* Here define the percentiles for which GPS overlap quality analysis will be made
* Leave empty if overlap quality analysis is not desired
local percentiles_list "1 5 10 25 50 75 90 95 99"
* Define also the file where the table will be saved
local percentiles_file "`resultsdir'overlap_quality"

* Options for balancing
* To request balancing analysis make balopt=1, o/w =0
local balopt "1"
* Name of the file where table with balancing analysis results will be saved
local bal_file "`resultsdir'balancing"

* Options for descriptive statistics
* To request descriptive statistics make descopt=1, o/w =0
local descopt "1"
* Name of the file where table with descriptive statistics will be saved
local desc_file "`resultsdir'descriptive_stats"

* Bootstrap options
* Number of repetitions
local nreps "1000"

* Strata variable for bootstrap
local stratvar "`treatvar'"

* Here includes the do file which calls the estimation command, runs the bootstrap, creates graphs, etc.
include "`pgsdir'main_estimation.do"

log close

