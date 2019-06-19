* BALANCING.DO
*
* BALANCING Mata Function (compiled once for using it)
*
* Mata function to test balancing of covariantes after estimating GPS (which has to be provided)
*
* Program written for Flores, Carlos A. and Oscar A. Mitnik (2013). "Comparing Treatments across Labor Markets:
* An Assessment of Nonexperimental Multiple-Treatment Strategies", Review of Economics and Statistics, 
* December 2013, Vol. 95, No. 5, Pages 1691-1707.
*
* Inputs for the function are
* gps_suffix    = variable with estimated GPS (and suffix for particular levels of exposure variables)
* xvar          = covariates over which balancing will be tested
* expvar        = exposure variable for which GPS was calculated
* expvcat_suff  = suffix of dummy variables identifying categories of expvar_cat for which blocking on GPS
*                 will be conducted  (evaluating each at the median exposure level of the category)
* nexp_cat      = # of categories (i.e. number of dummies with suffix expvcat_suff)
* nblocks       = # of blocks (quantiles) within each category in which GPS will be blocked
*                 (default is 10 quantiles)
* std	      		= if =1 then difference of meas are standardized, otherwise present them in actual values
* fname		 			= name of the ASCII file where the results will be saved
* touse         = sample selection variable `touse'
* ovlp_var	 		= variable indicating observations that satisfy overlap condition
* fe_model	 		= 1 if differences of means will be done with fixed efffects
* fe_var		 		= name of variable that will be used as fixed effect
*
* The function generates a temporary Stata matrix `mat_all' which has in each row a variable and the number of columns is
* equal to nexp_cat*2. The first row identifies the median exposure level at the category given by the column
*
* To run the function, in Stata write: 
* mata: balancing("gps", "t_all", "xvar", "expvar", "expvcat_suff", nexp_cat, nblocks, std, "`touse'","`fe_model'","`fe_var'")
*
* Version: May 2011 
*

version 9
capture mata: mata drop balancing()
mata:
void function balancing(string gps_suffix, string xvar, string expvar, string expvcat_suff, numeric scalar nexp_cat, numeric scalar nblocks, numeric scalar std, string fname,  | string scalar touse, string scalar ovlp_var,  numeric scalar fe_model, string scalar fe_var)
{

	// If `touse' is not defined
	if (strlen(touse)==0) tousest=""
	else tousest=" if " + touse + " ==1"

	// If ovlp_var is not defined
	if (strlen(ovlp_var)==0) tousest_ovlp=tousest
	else {
		if (strlen(touse)==0) tousest_ovlp=" if " + ovlp_var + " ==1"
		else tousest_ovlp=" if " + touse + " ==1 & " + ovlp_var + " ==1"
		// Read overlap variable
		ovlp=J(0,0,0)
		st_view(ovlp,.,ovlp_var,touse)
	}

	// Read exposure variable data
	t=J(0,0,0)
	st_view(t,.,expvar,touse)
	
	// If ovlp_var was not defined, create a vector of ones
	//if (strlen(ovlp_var)==0) ovlp=J(rows(t),1,1)
	
	// Read categorical variables (put them in one matrix, with number of cols given by nexp_cat)
	ft=mm_freq(t,1,tval=.) // tval is a vector with all the distinct values of t
	tcat=J(0,0,0)
	st_view(tcat,.,expvcat_suff:+strofreal(tval'),touse)
		
	// Read estimated gps (given by gps_suffix)
	gps=J(0,0,0)
	st_view(gps,.,st_local(gps_suffix),touse)
	
	// Column vector with names of xvar 
	xvar_nms=tokens(xvar)'
	
	// If std ==1 then differences of means will be based on standardized variables, if not just actual diff of means
	if (std==1) d_xvar_nms="c_":+xvar_nms 
	else d_xvar_nms=xvar_nms

	// Read xvars
	xvar=J(0,0,0)
	st_view(xvar,.,xvar_nms',touse)

	// Calculates mean of xvars
	xvar_mean=mean(xvar)'

	// Calculates standard deviaton of xvars
	xvar_sd=diagonal(variance(xvar)):^.5

	// Creates "centered" (standardized) variables if std==1
	if (std==1) stata("center " + mm_invtokens(xvar_nms') + ", standardize")

	///////////////////////////////////////////////////////////////////////////////////
	//
	// Calculate joint test (F-test) of differences across categories of treatment groups 
	// for each covariate. The groups are given by the variables associated to expvcat_suff 
	// Creates a table of means before imposing overlap, after imposing overlap and adjusted
	// by IPW, as well as creates a table of p-values, per covariate.
	// Three cases: before imposing overlap, after imposing overlap, and 
	// inverse probability weighting on GPS.
	// 
	///////////////////////////////////////////////////////////////////////////////////
	
	if (strlen(ovlp_var)==0) {	
		// Initialize matrix of means
		means_all=J(rows(xvar_nms),nexp_cat*2,.)
		
		// Initialize matrix of p-values
		pvalues_all=J(rows(xvar_nms),2,.)
		
		// Initialize counters for # p-values <=0.10, <=0.05 and <=0.01	
		tot_nr_xs=J(1,2,rows(xvar_nms))
		nr_pval_10=J(1,2,0)
		nr_pval_5 =J(1,2,0)
		nr_pval_1 =J(1,2,0)
		
		// Addition May 2011: Initialize matrix of RMSDs
		rmsds_all=J(rows(xvar_nms),2,.)		
	}
	else {
		// Initialize matrix of means
		means_all=J(rows(xvar_nms),nexp_cat*3,.)
		
		// Initialize matrix of p-values
		pvalues_all=J(rows(xvar_nms),3,.)
		
		// Initialize counters for # p-values <=0.10, <=0.05 and <=0.01	
		tot_nr_xs=J(1,3,rows(xvar_nms))
		nr_pval_10=J(1,3,0)
		nr_pval_5 =J(1,3,0)
		nr_pval_1 =J(1,3,0)	
		
		// Addition May 2011: Initialize matrix of RMSDs
		rmsds_all=J(rows(xvar_nms),3,.)
	}
	// String with names of dummies to be used in the regressions
	alldums = mm_invtokens(expvcat_suff:+strofreal(tval'))
	
	// String with test to run after each regression
	ftest_str = " "	
	for (k=1; k<=nexp_cat; k++) ftest_str = ftest_str + " " + (k==1 ? " " :"=") + expvcat_suff + strofreal(tval[k])
	
	// Run regressions to calculate p-values of F-Tesf of joint equality of dummies associated to expvcat_suff
	// for each variable in xvar		
	coli=0
	for (j=1; j<=rows(xvar_nms); j++) {
		// Indicates column where results will be stored
		coli=1
		
		// Regression with only the exposure categorical dummies
		// (unadjusted difference of means NOT IMPOSING OVERLAP)
		// If fe_model==1, run the differences with fixed effects
		if (fe_model==1) {
			stata("quietly areg " + d_xvar_nms[j] + " " + alldums + " " +  tousest + ", robust absorb(" + fe_var + ")")
		}
		// Or without fixed effects
		else {
			stata("quietly regress " + d_xvar_nms[j] + " " + alldums + " " +  tousest + ", robust nocons")
		}
		stata("quietly matrix means=e(b)")
		// Stores means in means_all
		means_all[j,(((coli-1)*nexp_cat)+1)..(coli*nexp_cat)]=st_matrix("means")
		// F-test of joint equality
		stata("quietly test " + ftest_str)
		stata("quietly matrix pv=r(p)")
		// Stores p-value in pvalues_all
		pvalues_all[j,coli]=st_matrix("pv")
		// Updates counters
		nr_pval_10[1,coli]= nr_pval_10[1,coli]+ (pvalues_all[j,coli]<=0.10 ? 1 : 0)
		nr_pval_5[1,coli] = nr_pval_5[1,coli] + (pvalues_all[j,coli]<=0.05 ? 1 : 0)
		nr_pval_1[1,coli] = nr_pval_1[1,coli] + (pvalues_all[j,coli]<=0.01 ? 1 : 0)	
		// Addition May 2011: Calculates Root Mean Square Distance of the regression coefficients
		//                    It is a way of assesing overall degree of balancing across all treatment values			 	
		// Calculates root mean squared distance to mean (or zero, if mean=0)
		rmsds_all[j,coli]=(sqrt(rowsum((st_matrix("means"):-mean(st_matrix("means")')):^2)/nexp_cat))/(std==0 ? abs(mean(st_matrix("means")')) : 1)
				
		// Runs this if ovlp_var defined
		if (strlen(ovlp_var)!=0) {
			// Advance column counter
			coli=coli+1							
			// Regression with only the exposure categorical dummies
			// (unadjusted difference of means AFTER IMPOSING OVERLAP)
			// If fe_model==1, run the differences with fixed effects
			if (fe_model==1) {
				stata("quietly areg " + d_xvar_nms[j] + " " + alldums + " " +  tousest_ovlp + ", robust absorb(" + fe_var + ")")
			}
			// Or without fixed effects
			else {
				stata("quietly regress " + d_xvar_nms[j] + " " + alldums + " " +  tousest_ovlp + ", robust nocons")
			}
			stata("quietly matrix means=e(b)")
			// Stores means in means_all
			means_all[j,(((coli-1)*nexp_cat)+1)..(coli*nexp_cat)]=st_matrix("means")
			// F-test of joint equality
			stata("quietly test " + ftest_str)
			stata("quietly matrix pv=r(p)")
			// Stores p-value in pvalues_all
			pvalues_all[j,coli]=st_matrix("pv")
			// Updates counters
			nr_pval_10[1,coli]= nr_pval_10[1,coli]+ (pvalues_all[j,coli]<=0.10 ? 1 : 0)
			nr_pval_5[1,coli] = nr_pval_5[1,coli] + (pvalues_all[j,coli]<=0.05 ? 1 : 0)
			nr_pval_1[1,coli] = nr_pval_1[1,coli] + (pvalues_all[j,coli]<=0.01 ? 1 : 0)
			// Addition May 2011: Calculates Root Mean Square Distance of the regression coefficients
			//                    It is a way of assesing overall degree of balancing across all treatment values			 	
			// Calculates root mean squared distance to mean (or zero, if mean=0)
			rmsds_all[j,coli]=(sqrt(rowsum((st_matrix("means"):-mean(st_matrix("means")')):^2)/nexp_cat))/(std==0 ? abs(mean(st_matrix("means")')) : 1)
		}

		// Regression with only the exposure categorical dummies
		// (unadjusted difference of means AFTER IMPOSING OVERLAP)
		// AND WITH INVERSE PROBABILITY WEIGHTING (IPW)
		
		// Advance column counter
		coli=coli+1							

		// Creates weighting variable a temporary variable
		wgt=1:/gps
		wname=st_tempname(1)
		idx=st_addvar("double",wname)
		st_store(.,idx,touse,wgt)   
		
		// If fe_model==1, run the differences with fixed effects
		if (fe_model==1) {
			stata("quietly areg " + d_xvar_nms[j] + " " + alldums + " [pw=" + wname + "] " +  tousest_ovlp + " , robust absorb(" + fe_var + ")")
		}
		// Or without fixed effects
		else {
			stata("quietly regress " + d_xvar_nms[j] + " " + alldums + " [pw=" + wname + "] " +  tousest_ovlp + ", robust nocons")
		}
		stata("quietly matrix means=e(b)")
		// Stores means in means_all
		means_all[j,(((coli-1)*nexp_cat)+1)..(coli*nexp_cat)]=st_matrix("means")
		// F-test of joint equality
		stata("quietly test " + ftest_str)
		stata("quietly matrix pv=r(p)")
		// Stores p-value in pvalues_all
		pvalues_all[j,coli]=st_matrix("pv")
		// Updates counters
		nr_pval_10[1,coli]= nr_pval_10[1,coli]+ (pvalues_all[j,coli]<=0.10 ? 1 : 0)
		nr_pval_5[1,coli] = nr_pval_5[1,coli] + (pvalues_all[j,coli]<=0.05 ? 1 : 0)
		nr_pval_1[1,coli] = nr_pval_1[1,coli] + (pvalues_all[j,coli]<=0.01 ? 1 : 0)
		// Addition May 2011: Calculates Root Mean Square Distance of the regression coefficients
		//                    It is a way of assesing overall degree of balancing across all treatment values			 	
		// Calculates root mean squared distance to mean (or zero, if mean=0)
		rmsds_all[j,coli]=(sqrt(rowsum((st_matrix("means"):-mean(st_matrix("means")')):^2)/nexp_cat))/(std==0 ? abs(mean(st_matrix("means")')) : 1)
	}
	
	// Present results
	if (strlen(ovlp_var)!=0) {
		first_means_all_row = ("Variable","raw_":+strofreal((1::nexp_cat)'),"raw_ovlp_":+strofreal((1::nexp_cat)'),"IPW_":+strofreal((1::nexp_cat)'))
		first_pv_row = ("Variable","Raw","Raw w/Ovlp","IPW")
		first_rmsd_row = ("Variable","Raw","Raw w/Ovlp","IPW")
	}
	else {
		first_means_all_row = ("Variable","raw_":+strofreal((1::nexp_cat)'),"IPW_":+strofreal((1::nexp_cat)'))
		first_pv_row = ("Variable","Raw","IPW")
		first_rmsd_row = ("Variable","Raw","IPW")
	}
	first_pv_col = (xvar_nms\"# Xs p-val<=0.10"\"# Xs p-val<=0.05"\"# Xs p-val<=0.01")	
	" "
	" "
	"********************************************************************************************************************************"
	"Means of each treatment category before overlap" + (strlen(ovlp_var)!=0 ? ", after overlap " : " ") + "& IPW" + (std==1 ? " - Standardized" : " - In levels")
	(first_means_all_row\(xvar_nms,strofreal(means_all)))
	"********************************************************************************************************************************"
	" "
	" "
	"***********************************************************************************"
	"P-Values for joint test of equality across treatment categories, for each covariate"
	(first_pv_row\(first_pv_col,strofreal(pvalues_all\nr_pval_10\nr_pval_5\nr_pval_1)))
	"***********************************************************************************"
	" "
	" "
	"********************************************************************************************************************************"
	"RMSDs of each treatment category before overlap" + (strlen(ovlp_var)!=0 ? ", after overlap " : " ") + "& IPW" + (std==1 ? " - Standardized" : " - In levels")
	(first_rmsd_row\(xvar_nms,strofreal(rmsds_all)))
	"********************************************************************************************************************************"
	" "
	" "
		
	// Outputs means_all results as an ASCII file
	mm_outsheet(fname+ "_joint_means" + ".out", (first_means_all_row\(xvar_nms,strofreal(means_all))) ,"replace")
	// Outputs p-values results as an ASCII file
	mm_outsheet(fname+ "_joint_pval" + ".out", (first_pv_row\(first_pv_col,strofreal(pvalues_all\nr_pval_10\nr_pval_5\nr_pval_1))) ,"replace")
	// Outputs rmsds_all results as an ASCII file
	mm_outsheet(fname+ "_joint_rmsds" + ".out", (first_rmsd_row\(xvar_nms,strofreal(rmsds_all))) ,"replace")

	// Added May 2011: Also output the matrices with "estout" command to *.csv files
	out_mats=st_tempname(3)
	// Outputs means_all results as an ASCII file
	st_matrix(out_mats[1], means_all)
	st_matrixcolstripe(out_mats[1], (J(1,cols(first_means_all_row[|.,2 \ .,.|]),"")\first_means_all_row[|.,2 \ .,.|])')
	st_matrixrowstripe(out_mats[1], (J(rows(xvar_nms),1,""),xvar_nms))
	stata("estout matrix(" + out_mats[1] + ") using " + char(34) + fname + "_joint_means.csv" + char(34) + ", delimiter(,) replace")
	// Outputs p-values results as an ASCII file
	st_matrix(out_mats[2], (pvalues_all\nr_pval_10\nr_pval_5\nr_pval_1))
	st_matrixcolstripe(out_mats[2], (J(1,cols(first_pv_row[|.,2 \ .,.|]),"")\first_pv_row[|.,2 \ .,.|])')
	fpvc = (xvar_nms\"nr_Xs_pval_lt_10_perc"\"nr_Xs_pval_lt_5_perc"\"nr_Xs_pval_lt_1_perc")	
	st_matrixrowstripe(out_mats[2], (J(rows(fpvc),1,""),fpvc))
	stata("estout matrix(" + out_mats[2] + ") using " + char(34) + fname + "_joint_pval.csv" + char(34) + ", delimiter(,) replace")
	// Outputs rmsds_all results as an ASCII file
	st_matrix(out_mats[3], rmsds_all)
	st_matrixcolstripe(out_mats[3], (J(1,cols(first_rmsd_row[|.,2 \ .,.|]),"")\first_rmsd_row[|.,2 \ .,.|])')
	st_matrixrowstripe(out_mats[3], (J(rows(xvar_nms),1,""),xvar_nms))
	stata("estout matrix(" + out_mats[3] + ") using " + char(34) + fname + "_joint_rmsds.csv" + char(34) + ", delimiter(,) replace")
	
	
	///////////////////////////////////////////////////////////////////////////////////
	//
	// Calculate pairwise comparisons one treatment against all others 
	// (before imposing overlap, after imposing overlap, and blocking on GPS
	// 
	///////////////////////////////////////////////////////////////////////////////////
		
	// Creates first columns for matrix with difference of means (containing overall median exposure, min exposure, max exposure, 
	// # obs, mean of xvars, sd of vars)
	first_col=(mm_median(t),.\colmin(t),.\colmax(t),.\rows(t),.\xvar_mean,xvar_sd)

	// Vector tmedian has the median exposure level for each category of expvar
	tmedian=J(1,nexp_cat,0)

	// Vector tmin has the min exposure level for each category of expvar
	tmin=J(1,nexp_cat,0)

	// Vector tmax has the max exposure level for each category of expvar
	tmax=J(1,nexp_cat,0)

	// Vector nobs has the number of observations in each category of expvar
	// Total number of observations
	nobs=colsum(tcat)

	// Number of observations after overlap
	if (strlen(ovlp_var)==0) nobs_ovlp=nobs
	else nobs_ovlp = colsum(tcat[mm_which(ovlp:==1),.])

	// Determines number of blocks inside each category for which balancing will be tested
 	p=J(0,1,0)
	for (i=0; i<=100; i=i+(100/nblocks)) p=(p\i)
	
	// Coefficients on differences of means results will be accumulated in matrices b_unadj, b_unadj_ovlp and b_adj
	b_unadj=J(rows(xvar_nms),nexp_cat,0)
	b_unadj_ovlp=J(rows(xvar_nms),nexp_cat,0)
	b_adj=J(rows(xvar_nms),nexp_cat,0)
	
	// T-stats results will be accumulated in matrices t_unadj, t_unadj_ovlp and t_adj
	t_unadj=J(rows(xvar_nms),nexp_cat,0)
	t_unadj_ovlp=J(rows(xvar_nms),nexp_cat,0)
	t_adj=J(rows(xvar_nms),nexp_cat,0)

	// Set to zero counters for how many covariates are statistically significant at 90%, 95%, 99%
	tot_nr_xs=rows(xvar_nms):+J(1,nexp_cat,0)
	unadj_sig_xs=J(3,nexp_cat,0)
	unadj_ovlp_sig_xs=J(3,nexp_cat,0)
	adj_sig_xs=J(3,nexp_cat,0)
	
	// For each category and variable checks balancing
	for (c=1; c<=nexp_cat; c++) {
 		
 		// Checks if there are enough observations in the category "c" to perform blocking
 		if (nobs_ovlp[c]<=5*nblocks) {
 			"Not enough observations in category " + strofreal(c) + " to perform blocking"
 			"(Number of observations = " + strofreal(nobs_ovlp[c]) +")"
 			continue
 		}

 		// Median of exposure variable for observations with exposure in category "c"
 		tmedian[c]=mm_median(select(t,(tcat[.,c]:==1)))
 		
 		// Min of exposure variable for observations with exposure in category "c"
 		tmin[c]=colmin(select(t,(tcat[.,c]:==1)))
 		
 		// Max of exposure variable for observations with exposure in category "c"
 		tmax[c]=colmax(select(t,(tcat[.,c]:==1)))
 		
 		// Gets appropriate GPS variable (i.e. gps_median)
 		// Gets name of temporary variable in macro "gps_suffix"_tmedian[c] in Stata
 		gps_median=J(0,0,0)
 		st_view(gps_median,.,st_local(gps_suffix+"_"+strofreal(tmedian[c])),touse)
 		
 		// Vector ptiles has the cutoff points of percentiles of gps_median variable
 		// calculated based only on individuals with exposure given by tcat[c] AND that satisfy overlap (if applicable)
		ptiles=mm_quantile(select(gps_median,(tcat[.,c]:==1 :& ovlp:==1)), 1, p/100)
		
		// Replace the mininum and maximum percentiles by the min(gps_median) and max(gps_median) respectively
		// to avoid dropping observations from the analysis
		ptiles[1,1]=colmin(gps_median)
		ptiles[rows(ptiles),1]=colmax(gps_median)
				
		// Matrix ptiles_dum has # of columns equal to nblocks, each column is a
		// dummy =1 if observation belongs to percentile of gps_median given by column position, =0 o/w
		// This is created for all individuals which satisfy the overlap condition
		// (other individuals are assigned missing values)
		ptiles_dum=(mm_cut(gps_median,ptiles)*J(1,nblocks,1)):==(J(rows(gps_median),1,1)*ptiles[1..nblocks]')
		ptiles_dum[.,nblocks]=ptiles_dum[.,nblocks]+(mm_cut(gps_median,ptiles):==ptiles[nblocks+1])  // Makes sure max(gps_median) 
																	   			   // is assigned to top decile
		mis=mm_which(ovlp:~=1)
		ptiles_dum[mis',.]=J(rows(mis),nblocks,.)  // Missing if do not satisfy overlap condition
				
		// Creates matrix of interactions between ptiles_dum variables and tcat[c]
		// This is created for all individuals with calculated gps within the min and max of ptiles
		// (other individuals are assigned missing values)
		ptilesXtcat=ptiles_dum:*tcat[.,c]
		
		// Add ptiles_dum and ptilesXtcat to the Stata dataset as temporary variables so 
		// regressions can be run
		idx1=st_addvar("double",ptdum_nms=st_tempname(cols(ptiles_dum)))
		st_store(.,ptdum_nms,touse,ptiles_dum)   
		idx2=st_addvar("double",ptXtcat_nms=st_tempname(cols(ptilesXtcat)))
		st_store(.,ptXtcat_nms,touse,ptilesXtcat) 

		// Percentage of total number of observations in each percentile (among non-missing observations)
		wgt_ptile=colsum(ptiles_dum):/sum(ptiles_dum)
		
		// Builds lincom formula (to be used below)
		lncomb = " "
		for (k=1; k<=nblocks; k++)  lncomb = (lncomb + " " + (k==1 ? " " :"+") + strofreal(wgt_ptile[k]) + " * "+ ptXtcat_nms[k])
				
		// Run regressions to check balancing on each variable in xvar
		for (j=1; j<=rows(xvar_nms); j++) {
			// Regression with only the exposure categorical dummy
			// (unadjusted difference of means NOT IMPOSING OVERLAP)
			// If fe_model==1, run the differences with fixed effects
			if (fe_model==1) {
				stata("quietly areg " + d_xvar_nms[j] + " " + expvcat_suff + strofreal(c) + " " +  tousest + ", robust absorb(" + fe_var + ")")
			}
			// Or without fixed effects
			else {
				stata("quietly regress " + d_xvar_nms[j] + " " + expvcat_suff + strofreal(tval[c]) + " " +  tousest + ", robust")
			}
			bu=st_matrix("e(b)")'
			seu=diagonal(st_matrix("e(V)")):^.5
			// Coefficient of the unadjusted difference of means for this category of expvar
			b_unadj[j,c]=bu[1]   
			// t-statistic of the unadjusted difference of means for this category of expvar
			t_unadj[j,c]=bu[1]/seu[1]   

			if (strlen(ovlp_var)==0) {						
				bu_ovlp=J(0,0,0)
				t_unadj_ovlp=J(0,0,0);
			}
			else {
				// Regression with only the exposure categorical dummy
				// (unadjusted difference of means IMPOSING OVERLAP)
				// If fe_model==1, run the differences with fixed effects
				if (fe_model==1) {
					stata("quietly areg " + d_xvar_nms[j] + " " + expvcat_suff + strofreal(tval[c]) + " " +  tousest_ovlp + ", robust absorb(" + fe_var + ")")
				}
				// Or without fixed effects
				else {
					stata("quietly regress " + d_xvar_nms[j] + " " + expvcat_suff + strofreal(tval[c]) + " " +  tousest_ovlp + ", robust")
				}
				bu_ovlp=st_matrix("e(b)")'
				seu_ovlp=diagonal(st_matrix("e(V)")):^.5
				// Coefficient of the unadjusted difference of means for this category of expvar
				b_unadj_ovlp[j,c]=bu_ovlp[1]   
				// t-statistic of the unadjusted difference of means for this category of expvar
				t_unadj_ovlp[j,c]=bu_ovlp[1]/seu_ovlp[1] 
			}	
			
			// Regresssion blocking by gps percentile and interaction with category of expvar to 
			// obtain t-stat of adjusted difference of means
			// If fe_model==1, run the differences with fixed effects
			if (fe_model==1) {
				stata("quietly areg " + d_xvar_nms[j] + " " +   mm_invtokens(ptXtcat_nms) + " " +  mm_invtokens(ptdum_nms) + " " +  tousest_ovlp + ", robust absorb(" + fe_var + ")")
			}
			// Or without fixed effects
			else {
				stata("quietly regress " + d_xvar_nms[j] + " " +   mm_invtokens(ptXtcat_nms) + " " +  mm_invtokens(ptdum_nms) + " " +  tousest_ovlp + ", robust nocons")
			}
			// With lincom Stata command obtain t-stat from blocking
			stata("quietly lincom "+ lncomb)
			ba=st_numscalar("r(estimate)")
			sea=st_numscalar("r(se)")
			// Coefficient of the gps-blocking adjusted difference of means for this category of expvar
			b_adj[j,c]=ba
			// t-statistic of the gps-blocking adjusted difference of means for this category of expvar
			t_adj[j,c]=ba/sea
			
			// Updates counters for number of significant covariates at different significance levels
			// Unadjusted
			unadj_sig_xs[1,c]=unadj_sig_xs[1,c] + (abs(t_unadj[j,c])>=1.64 ? 1 : 0) // 90%
			unadj_sig_xs[2,c]=unadj_sig_xs[2,c] + (abs(t_unadj[j,c])>=1.96 ? 1 : 0) // 95%
			unadj_sig_xs[3,c]=unadj_sig_xs[3,c] + (abs(t_unadj[j,c])>=2.58 ? 1 : 0) // 99%
			// Unadjusted after imposing overlap
			unadj_ovlp_sig_xs[1,c]=unadj_ovlp_sig_xs[1,c] + (abs(t_unadj_ovlp[j,c])>=1.64 ? 1 : 0) // 90%
			unadj_ovlp_sig_xs[2,c]=unadj_ovlp_sig_xs[2,c] + (abs(t_unadj_ovlp[j,c])>=1.96 ? 1 : 0) // 95%
			unadj_ovlp_sig_xs[3,c]=unadj_ovlp_sig_xs[3,c] + (abs(t_unadj_ovlp[j,c])>=2.58 ? 1 : 0) // 99%
			// Adjusted                                                                       
			adj_sig_xs[1,c]=adj_sig_xs[1,c] + (abs(t_adj[j,c])>=1.64 ? 1 : 0) // 90%
			adj_sig_xs[2,c]=adj_sig_xs[2,c] + (abs(t_adj[j,c])>=1.96 ? 1 : 0) // 95%
			adj_sig_xs[3,c]=adj_sig_xs[3,c] + (abs(t_adj[j,c])>=2.58 ? 1 : 0) // 99%
		}
	}
	
	// Put matrices b_unadj, b_unadj_ovlp and b_adj together in matrix matb_all
	matb_all=(b_unadj,b_unadj_ovlp,b_adj)
	
	// Put matrices t_unadj, t_unadj_ovlp and t_adj together in matrix mat_all
	mat_all=(t_unadj,t_unadj_ovlp,t_adj)
		
	// Displays results
	row_labels=("t_median"\"t_min"\"t_max"\"# obs"\xvar_nms)
	cter_labels=("Tot # Xs"\"# Xs signif 90%"\"# Xs signif 95%"\"# Xs signif 99%")
	if (strlen(ovlp_var)==0) {
		clab1_ovlp=J(0,0,0)
		clab2_ovlp=J(0,0,0)
	}	
	else {
		clab1_ovlp="unadj_ovlp_":+strofreal((1::nexp_cat)')
		clab2_ovlp="unadj_ovlp_":+strofreal((1::nexp_cat)')
	}
	cols_labels1=("","All-Mean","All-S.D.","unadj_":+strofreal((1::nexp_cat)'),clab1_ovlp,"adj_":+strofreal((1::nexp_cat)'))
	cols_labels2=("","unadj_":+strofreal((1::nexp_cat)'),clab2_ovlp,"adj_":+strofreal((1::nexp_cat)'))
	"Balancing of covariates with " + strofreal(nblocks) + " blocks"
	"Difference of Means Unadjusted" + (std==1 ? " - Standardized" : " - In levels")
	(("","All-Mean","All-S.D.","unadj_":+strofreal((1::nexp_cat)'))\(row_labels,strofreal((first_col,(tmedian\tmin\tmax\nobs\b_unadj)))))
	if (strlen(ovlp_var)!=0) {
		"Difference of Means Unadjusted IMPOSING Overlap" + (std==1 ? " - Standardized" : " - In levels")
		(("","unadj_ovlp_":+strofreal((1::nexp_cat)'))\(row_labels,strofreal(((tmedian\tmin\tmax\nobs_ovlp\b_unadj_ovlp)))))
	}
	"Difference of Means Adjusted" + (std==1 ? " - Standardized" : " - In levels")
	(("","adj_":+strofreal((1::nexp_cat)'))\(row_labels,strofreal((tmedian\tmin\tmax\nobs_ovlp\b_adj))))
	
	
	"T-statistics Unadjusted"
	(("","unadj_":+strofreal((1::nexp_cat)'))\(row_labels,strofreal((tmedian\tmin\tmax\nobs\t_unadj)))\(cter_labels,strofreal((tot_nr_xs\unadj_sig_xs))))
	if (strlen(ovlp_var)!=0) {
		"T-statistics Unadjusted IMPOSING Overlap"
		(("","unadj_":+strofreal((1::nexp_cat)'))\(row_labels,strofreal((tmedian\tmin\tmax\nobs_ovlp\t_unadj_ovlp)))\(cter_labels,strofreal((tot_nr_xs\unadj_ovlp_sig_xs))))
	}
	"T-statistics Adjusted"
	(("","adj_":+strofreal((1::nexp_cat)'))\(row_labels,strofreal((tmedian\tmin\tmax\nobs_ovlp\t_adj)))\(cter_labels,strofreal((tot_nr_xs\adj_sig_xs))))
	
	// Stores matb_all and mat_all as ASCII files
	 if (strlen(ovlp_var)==0) {
		 mm_outsheet(fname+"_b_bl_"+strofreal(nblocks)+".out", (cols_labels1\(row_labels,strofreal((first_col,((tmedian,tmedian)\(tmin,tmin)\(tmax,tmax)\(nobs,nobs_ovlp)\matb_all))))),"replace")
		 mm_outsheet(fname+"_t_bl_"+strofreal(nblocks)+".out", ((cols_labels2\(row_labels,strofreal((tmedian,tmedian)\(tmin,tmin)\(tmax,tmax)\(nobs,nobs_ovlp)\mat_all)))\(cter_labels,strofreal(((tot_nr_xs\unadj_sig_xs),(tot_nr_xs\adj_sig_xs))))),"replace")
	}
	else {
		mm_outsheet(fname+"_b_bl_"+strofreal(nblocks)+".out", (cols_labels1\(row_labels,strofreal((first_col,((tmedian,tmedian,tmedian)\(tmin,tmin,tmin)\(tmax,tmax,tmax)\(nobs,nobs_ovlp,nobs_ovlp)\matb_all))))),"replace")
		mm_outsheet(fname+"_t_bl_"+strofreal(nblocks)+".out", ((cols_labels2\(row_labels,strofreal((tmedian,tmedian,tmedian)\(tmin,tmin,tmin)\(tmax,tmax,tmax)\(nobs,nobs_ovlp,nobs_ovlp)\mat_all)))\(cter_labels,strofreal(((tot_nr_xs\unadj_sig_xs),(tot_nr_xs\unadj_ovlp_sig_xs),(tot_nr_xs\adj_sig_xs))))),"replace")
	}
	// Drops temporary variables
	st_dropvar((idx1,idx2))

	// Drops centered variables created by "center" command
	if (std==1) stata("drop " + mm_invtokens(d_xvar_nms'))
	
	// Stores matb_all and mat_all as matrix in Stata
	//st_matrix(bt_all,((tmedian,tmedian)\matb_all))
	//st_matrixrowstripe(bt_all,(" ":*J(rows(row_labels),1,1),row_labels))
	//st_matrixcolstripe(bt_all,(" ":*J(nexp_cat*2,1,1),cols_labels[2..(nexp_cat*2+1)]'))
	//st_matrix(t_all,((tmedian,tmedian)\mat_all))
	//st_matrixrowstripe(t_all,(" ":*J(rows(row_labels),1,1),row_labels))
	//st_matrixcolstripe(t_all,(" ":*J(nexp_cat*2,1,1),cols_labels[2..(nexp_cat*2+1)]'))
}
mata mosave balancing(), replace
end
