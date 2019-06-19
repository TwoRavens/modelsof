* GPS_MATA.DO
*
* GPS Estimation Mata Function 
* (Compiled for execution purposes)
*
* Mata function to calculate GPS conditional on covariates (xcvar, xdisc) of variable tvar, 
* plus evaluated (predicted) at all points between tmin and tmax, creating temporary variables (stored in local macros 
* gps_suffix, for actual gps, and gps_suffix_tmin to gps_suffix_tmax for the predicted values of GPS at tmin to tmax)
*
* Function written for Flores, Carlos A. and Oscar A. Mitnik (2013). 
* "Comparing Treatments across Labor Markets: An Assessment of Nonexperimental Multiple-Treatment Strategies",
* Review of Economics and Statistics, December 2013, Vol. 95, No. 5, Pages 1691-1707.
*
* Version: March 2011 
*
* THE DEFAULT FOR GPS ESTIMATION IS A MULTINOMIAL LOGIT	MODEL
*
* Inputs for the function are
* tvar             = treatment variable (for which the GPS is calculated)
* tvar_cat         = categories of treatment var (based on which overlap is determined)
* xvar             = variables used in estimating the GPS model
* gps_suffix       = string with the name of the gps variable
* apply_overlap    = 0 or 1, =0, nothing happens, =1 implies that overlap conditions, as specified by 
*										 options ovlp_value, ovlp_pooled and ovlp_one_tail are applied
* ovlp_value       = Value that will be used to create overlap variable. If option ovlp_pooled=1, then the comparison
*			               is based on the individuals treated at a certain level, vs not treaed at that level. If ovlp_pooled=0, then 
* 				           the comparison is each treament level against each of the others, one-by-one.
*	                   When ovlp_value=0, creates one variable for overlap. When ovlp_value>0, creates in addition to the based on 0,
*				             one based on the particular percentile requested.
*                  = 0 means that across all the distributions only individuals above the max(min gps) and below
*                    the min(max gps) are considered as "overlap"=1 
*    		             (a variable under macro name gps_suffix_ovlp will be created in this case)
*                    >0 means the same applied on percentiles (gps>max(percentile gps) and gps<min(percentile gps)
*			               (in this case, creates an additional variable under macro name gps_suffix_ovlp_p)
*			               Percentiles are defined in the [0,1] interval
*                    Example: ovlp_value=0.01 will use the .01 and .99 percentiles to determine cutoff points
* ovlp_pooled	    =  Define whether overlap will be based 
*                    on treatment-level-by-treatment-level, or based on a treatment vs all other treatments pooled
* 				           0=not pooled, 1=pooled
*				             Note, pooled~ "weak unconfoundedness"; not pooled ~ "strong unconfoundedness"
* ovlp_one_tail    = For the above definitions of overlap only use the lower tails of the distributions instead of the lower and 
*				             upper tail
*				             0 = two-tails, 1= lower-tail
* touse            = variable that containts 1 for observations that will be used in calculations, 0 o/w
* mprobit          = indicator =0 (default) for estimating GPS with a multinomial logit, =1 for estimating GPS with a multinomial probit
* ologit					 = indicator =0 (default) for estimating GPS with a multinomial logit, =1 for estimating GPS with an ordered logit model
* gmm              = indicator =0 (default) for estimating GPS with a multinomial logit, =1 for estimating GPS with a GMM model
* gmm_method			 = only if glm=1, indicate gmm method. There are four options:
*										 - mlogit_gmm: for estimating GPS with a standard multinomial logit model but by GMM
*										 - mlogit_ipt: for estimating mltinomial logit model by GMM and imposing perfect balancing conditions (IPT)
*										 - logit_ipt:  for estimating GPS by GMM, using a system of binary logit models for each treatment category,
*											 imposing perfect balancing conditions 
*										 - indiv_logit_ipt: for estimating GPS by GMM, using a series of one-by-one logit models for each treatment category,
*                      imposing perfect balancing conditions
*									   NOTE: estimating with logit_ipt or indiv_logit_ipt should give the same results, but with a large number of treatment
*										       categories, indiv_logit_ipt may be faster
* glm              = indicator =0 (default) for estimating GPS with a multinomial logit, =1 for estimating GPS with a GLM model
* glm_family			 = only if glm=1, indicate glm family
* glm_link   			 = only if glm=1, indicate link
* glm_options      = options for glm estimation			 
*
* To run the function, in Stata write: 
* mata: gps("tvar", "tvar_cat", "xvar", "gps_suffix", apply_overlap, ovlp_pooled, ovlp_value, ovlp_one_tail,  "`touse'",  mprobit, ologit, gmm, "gmm_method", glm, "glm_family", "glm_link", "glm_options")

version 11.1
mata:
void function gps(string tvar, string tvar_cat, string xvar, string gps_suffix, scalar apply_overlap, scalar ovlp_pooled, scalar ovlp_value,scalar ovlp_one_tail, | string scalar touse, scalar mprobit, scalar ologit, scalar gmm, string gmm_method, scalar glm, string glm_family, string glm_link, string glm_options)
{
	// If `touse' is not defined
	if (strlen(touse)==0) tousest=""
	else tousest=" if " + touse + "==1"
	
	// Gets data as views
	t=J(0,0,0)
	st_view(t,.,tokens(tvar),touse)
	t_cat=J(0,0,0)
	st_view(t_cat,.,tokens(tvar_cat),touse)
	
	// Information on the treatment and the sample
	ft=mm_freq(t,1,tval=.)       				        // tval is a vector with all the distinct values of t
	tnr=rows(ft)               				          // tnr has the total number of treatments
	ft_cat=mm_freq(t_cat,1,t_catval=.)       		// t_ctval is a vector with all the distinct values of t_cat
	t_catnr=rows(ft_cat)               				  // t_catnr has the total number of treatment categories
	
	n=rows(t)                                    // Size of the sample
	
	// Estimate mlogit (default), mprobit or ologit models for GPS (all using maximum likelihood)
	if (gmm==0 & glm==0) {
		// Estimate GPS with multinomial logit as default (base outcome is the minimum value of the treatment)
		// or multinomial probit or ologit if specified
		if (mprobit==1) stata("mprobit " + tvar + " " +  xvar  + " " + tousest + ", baseoutcome(" + strofreal(min(tval)) + ") difficult technique(nr bhhh dfp bfgs)")
		else if (ologit==1) stata("ologit " + tvar + " " +  xvar  + " " + tousest + ", difficult technique(nr bhhh dfp bfgs)")
		else stata("mlogit " + tvar + " " +  xvar  + " " + tousest + ", baseoutcome(" + strofreal(min(tval)) + ")")
		idx_gps_t=st_tempname(tnr)                   // Adds temporary variable names where the gps_t variables will be created
		gps_t_list = invtokens(idx_gps_t)            // String with all the names of the gps_t variables to be created
	
		// Creates gps_t variables (Pr(treatment=t for each individual))
		stata("predict " + gps_t_list + " " + tousest + ", pr") 	
		for (tt=1; tt<=tnr; tt++) {                  // Stores name of temporary variables gps_t in macro "gps_suffix"_t in Stata
			st_local(gps_suffix + "_" +strofreal(tval[tt]),idx_gps_t[tt]) 
		}
		
		// Read into matrix gps_t all the variables created by predicting the model in Stata
		gps_t=J(0,0,0)
		st_view(gps_t,.,idx_gps_t,touse)
	}
	// Estimate GLM model for GPS
	else if (glm==1) {
		if (glm_family=="gamma") {			
			// Adds a few temporary variable names to create auxiliary variables to estimate GPS
			mu_hat = st_tempname()
			a = st_tempname()
			b = st_tempname()
			// GLM model with "glm_family" family and "glm_link" link
			stata("glm " + tvar + " " + xvar + " "  + tousest + ", family(" + glm_family + ") link(" + glm_link + ") " + glm_options)
			// Predict GPS at different values of treatment variable
			stata("predict " + mu_hat + " if e(sample)")      // Default is to calculate mu=E(y)=g(xB)
			stata("gen " + a + " = 1/e(phi) if e(sample)")
			stata("gen " + b + " = " + mu_hat + "/" + a + " if e(sample)")
			idx_gps_t=st_tempname(tnr)                   // Adds temporary variable names where the gps_t variables will be created
			for (tt=1; tt<=tnr; tt++) {
				gps_t=idx_gps_t[tt]   // Adds temporary variable name where the gps_t variable will be created
				// Creates gps_t variable (Pr(treatment=t for each individual))
				stata("gen " + gps_t + " = gammaden(" + a + "," + b + ",0," + strofreal(tt) +")" + " if e(sample)")
				// Stores name of temporary variable gps_t in macro "gps_suffix"_t in Stata
				st_local(gps_suffix + "_" +strofreal(tval[tt]),gps_t) 
			}
			
			// Read into matrix gps_t all the variables created by predicting the model in Stata
			gps_t=J(0,0,0)
			st_view(gps_t,.,idx_gps_t,touse)
		}
		else exit(_error("GLM fammily specified not supported"))
	}
	// GMM estimation: either MNL (no perfect balancing), or with extra IPT conditions, or estimate system of logit models, 
	// or series of individual logit models
	else if (gmm==1) {
		// Generate temporary variable "constant" that will be added to the model
		idx_constant=st_addvar("double",name_cons=st_tempname(1))
		st_store(.,idx_constant,touse,J(n,1,1))
		
		// Number of variables in estimation (including constant)
		k=cols(tokens(xvar))+1
				
		// For methods mlogit_gmm, mlogit_ipt and logit_ipt use gmm evaluator
		if (gmm_method=="mlogit_gmm"|gmm_method=="mlogit_ipt"|gmm_method=="logit_ipt") {
			// Determines number of equations and coefficients for GMM estimation
			// For multinomial logit with no IPT constraints
			if (gmm_method== "mlogit_gmm") {
				// Number of equations is tnr-1 
				// Number of parameters is k*(tnr-1), where k is the number of columns in x_data (includes constant)
				nr_eqs  = strofreal(tnr-1)
				nr_pars = strofreal(k*(tnr-1))
				winitial = "winitial(identity)"
				
				// Because system is overidentified run two-step GMM
				gmm_step = "twostep"
			}
			// For multinomial logit with IPT constraints
			if (gmm_method== "mlogit_ipt") {
				// Number of equations is (tnr*2)-1 
				// Number of parameters is k*(tnr-1), where k is the number of columns in x_data (includes constant)
				nr_eqs  = strofreal((tnr*2)-1)
				nr_pars = strofreal(k*(tnr-1))
				winitial = "winitial(identity)"
				
				// Because system is overidentified run two-step GMM
				gmm_step = "twostep"
			}
			// For system of logit models with IPT constraints
			if (gmm_method== "logit_ipt") {
				// Number of equations is tnr 
				// Number of parameters is k*tnr, where k is the number of columns in x_data (includes constant)
				nr_eqs  = strofreal(tnr)
				nr_pars = strofreal(k*tnr)
				winitial = "winitial(unadjusted, independent)"
								
				// Because system is just identified run one-step GMM
				gmm_step = "onestep"
			}
			
			// Estimates GMM model
			stata("capture noisily gmm gmm_ipt_eval " + tousest + ", yvar(" + tvar + ") xvar(" + xvar + " " + name_cons + ")  instruments(" + xvar + " " + name_cons + ", noconstant) nequations(" + nr_eqs + ") nparameters(" + nr_pars + ") " + winitial + " " + gmm_step + " method(" + gmm_method + ") hasderivatives  conv_maxiter(100)")
			stata("local gmm_result = _rc")
			if (st_local("gmm_result")=="430") exit()

			// Obtain vector of coefficients from GMM estimation
			b_tt=st_matrix("e(b)")
		}
		else if (gmm_method=="indiv_logit_ipt") {
			// For each treatment level estimate a logit model by GMM with perfect balancing moment conditions imposed
						
			// Number of equations is 1 
			// Number of parameters is k, where k is the number of columns in x_data (includes constant)
			nr_eqs  = "1"
			nr_pars = strofreal(k)
			winitial = "winitial(identity)"
							
			// Because system is just identified run one-step GMM
			gmm_step = "onestep"
						
			//Initialize b_tt and run loop
			b_tt=J(1,0,0)
			for (tt=1; tt<=tnr; tt++) {
				//Determine treatment for which logit model will be estimated (=1 for that treatment, =0 for all other treatments)
				//Temporary variable "name_tt" has the dummy variable for the particular treatment
				treat_tt=t:==tval[tt,1]
				idx_treat_tt=st_addvar("double",name_tt=st_tempname(1))
				st_store(.,idx_treat_tt,touse,treat_tt)
								
				// Estimates GMM model
				stata("capture noisily gmm gmm_ipt_eval " + tousest + ", yvar(" + name_tt + ") xvar(" + xvar + " " + name_cons + ")  instruments(" + xvar + " " + name_cons + ", noconstant) nequations(" + nr_eqs + ") nparameters(" + nr_pars + ") " + winitial + " " + gmm_step + " method(" + gmm_method + ") hasderivatives  conv_maxiter(100)")
				stata("local gmm_result = _rc")
				if (st_local("gmm_result")=="430") exit()
								
				//Accumulate vectors of coefficients from GMM estimation
				bi_tt=st_matrix("e(b)")
				b_tt=(b_tt,bi_tt)
			}
		}
		else exit(_error("GMM method specified not supported"))
				
		// Read variables used in estimation (including "constant")
		x_data=J(0,0,0)
		st_view(x_data,.,tokens(xvar + " " + name_cons),touse)
								
		// Calculates GPS: creates gps_t variables (Pr(treatment=tt for each individual))
		if (gmm_method == "mlogit_gmm" | gmm_method == "mlogit_ipt") {
			b_tt_col=rowshape(b_tt,tnr-1)'
			exp_xb=(exp(x_data*b_tt_col),J(n,1,1))
			gps_t=exp_xb:/rowsum(exp_xb)
		}
		else if (gmm_method == "logit_ipt"|gmm_method == "indiv_logit_ipt") {
			b_tt_col=rowshape(b_tt,tnr)'
			exp_xb=exp(x_data*b_tt_col)
			gps_t=exp_xb:/(1:+exp_xb)
		}

		//gps_t variables will have predicted probability of each treatment value
		idx_gps_t=st_tempname(tnr)                   // Adds temporary variable names where the gps_t variables will be created
		gps_t_list = invtokens(idx_gps_t)            // String with all the names of the gps_t variables to be created
		
		// Stores name of temporary variables gps_t in macro "gps_suffix"_t in Stata
		for (tt=1; tt<=tnr; tt++) {                  
			st_local(gps_suffix + "_" +strofreal(tval[tt]),idx_gps_t[tt]) 
		}

		// Stores gps_t as temporary variables gps_t in Stata
		idx=st_addvar("double", idx_gps_t)
		st_store(.,idx_gps_t,touse,gps_t)
	}
			
	// Creates GPS (taking from gps_t matrix the value corresponding to observed t)
	gps=rowsum(gps_t:*(mm_expand(t,1,tnr):==(J(n,1,1)*tval')))
	
	// Adds GPS as temporary variable to the dataset
	idx_gps=st_tempname(1)
	idx=st_addvar("double",idx_gps)
	st_store(.,idx_gps,touse,gps)
	st_local(gps_suffix,idx_gps)                 // Stores name of variable with calculated GPS in macro "gps" in Stata

	
	// If the # of values associated to t_cat = # values associated to t (i.e. t_cat=t) then skip step below
	if (tnr==t_catnr) {
		gps_tcat=gps_t
		tmedian=tval
	}
	else {
		// For each category of t_cat determines median exposure and builds a matrix with estimated GPS for 
		// each of those median exposures (matrix will have number of columns = t_catnr)
		// Vector tmedian has the median exposure level for each category of expvar
		tmedian=J(1,t_catnr,0)
		gps_tcat=J(n,t_catnr,0)
		for (c=1; c<=t_catnr; c++) {
	 		
	 	 	// Median of exposure variable for observations with exposure in category "c"
	 	 	// Calculate median
	 	 	med=mm_median(select(t,(t_cat:==t_catval[c])))
	 	 	// Check that the value for the median is actually one of the values in tval
	 	 	// If it is not, it takes the closest value to an actual value in tval 
	 	 	// (if there is a tie, take the firt one)
	 	 	tmedian[c]=tval[colmin(mm_which(abs(tval:-med):<=colmin(abs(tval:-med))))]
	 
	 	  // Gets appropriate estimated GPS variables (i.e. GPS for median treatment within each category of t_cat)
	 	  gps_tcat[.,c]=select(gps_t,(tval':==tmedian[c]))
		} 	
	}
	// Stores the list of median values of treatment inside each treatment category in a macro variable
	st_local("t_cat_median_list",mm_invtokens(strofreal(tmedian))) 
	
	// Imposes overlap conditions
	if (apply_overlap==1) {
		if (ovlp_pooled==0) {
			min_gps=J(t_catnr,t_catnr,.)
			max_gps=J(t_catnr,t_catnr,.)
			min_p_gps=J(t_catnr,t_catnr,.)
			max_p_gps=J(t_catnr,t_catnr,.)
		}
		if (ovlp_pooled==1) {
			min_gps=J(2,t_catnr,.)
			max_gps=J(2,t_catnr,.)
			min_p_gps=J(2,t_catnr,.)
			max_p_gps=J(2,t_catnr,.)
		}
		for (tt=1; tt<=t_catnr; tt++) {
			
			// Collect in two matrices (one for the min value, another for the max value) the min
			// and max GPS of all the individuals with a PARTICULAR treatment OBSERVED value,
			// for EACH estimated GPS (given tmedian).
			// Then, each matrix will be square with size equal to the number of possible categories of 
			// treatments. Rows will have the value of the ACTUAL OBSERVED treatment, while
			// columns will have the EVALUATED treatment
			// (if ovlp_pooled==1, then instead of square matrix is 2*# treatments, where the 
			// first row has the percentile for observed treatment, second row for all other pooled treatments)
			// The parameter ovlp_value (see beginning of program) will determine if raw minimums
			// and maximums or if also percentiles are stored
			if (ovlp_pooled==0) {
				// Min/max is done treatment-category-by-treatment-category
				min_gps[tt,.]= colmin(select(gps_tcat,t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0)) 
				max_gps[tt,.]= colmax(select(gps_tcat,t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0)) 
			}
			if (ovlp_pooled==1) {
				// Min/max is done for each treatment CATEGORY vs other treatments pooled
				min_gps[1,tt]= colmin(select(gps_tcat[.,tt],t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0)) 
				min_gps[2,tt]= colmin(select(gps_tcat[.,tt],t_cat:~=tt :& gps:~=. :& rowmissing(gps_t):==0)) 
				max_gps[1,tt]= colmax(select(gps_tcat[.,tt],t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0)) 
				max_gps[2,tt]= colmax(select(gps_tcat[.,tt],t_cat:~=tt :& gps:~=. :& rowmissing(gps_t):==0)) 
			}
			if (ovlp_value>0) {
				// Percentile-based overlap is done treatment-category-by-treatment-category
				if (ovlp_pooled==0) {
					min_p_gps[tt,.]= mm_quantile(select(gps_tcat,t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0), 1, ovlp_value)
					max_p_gps[tt,.]= mm_quantile(select(gps_tcat,t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0), 1, 1-ovlp_value)
				}
				// Percentile-based overlap is done using the percentiles from the treatment of interest vs pooled all other treatments
				if (ovlp_pooled==1) {
					min_p_gps[1,tt]= mm_quantile(select(gps_tcat[.,tt],t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0), 1, ovlp_value)
					min_p_gps[2,tt]= mm_quantile(select(gps_tcat[.,tt],t_cat:~=tt :& gps:~=. :& rowmissing(gps_t):==0), 1, ovlp_value)
					max_p_gps[1,tt]= mm_quantile(select(gps_tcat[.,tt],t_cat:==tt :& gps:~=. :& rowmissing(gps_t):==0), 1, 1-ovlp_value)
					max_p_gps[2,tt]= mm_quantile(select(gps_tcat[.,tt],t_cat:~=tt :& gps:~=. :& rowmissing(gps_t):==0), 1, 1-ovlp_value)
				}
			}
		}
		
		// Overlap condition
		// If ovlp_one_tail == 0, for EACH TREATMENT LEVEL will mark the individuals with evaluated gps 
		// greater or equal to the maximum of min_gps matrix (that is for each row 
		// of min_gps), and less or equal to the minimum of the max_gps matrix, for each row
		if (ovlp_one_tail == 0) {
				ovlp_mat=(gps_tcat:>=colmax(min_gps)) :& (gps_tcat:<=colmin(max_gps))
		}
		// If ovlp_one_tail == 1, for EACH TREATMENT LEVEL will mark the individuals with evaluated gps 
		// greater or equal ONLY to the maximum of min_gps matrix (that is for each row 
		// of min_gps) 
		else {
				ovlp_mat=(gps_tcat:>=colmax(min_gps))
		}
		// For percentile-based overlap, also mark obs based on two-tails or one-tail
		if (ovlp_value>0) {
			if (ovlp_one_tail == 0) {
				ovlp_p_mat=(gps_tcat:>=colmax(min_p_gps)) :& (gps_tcat:<=colmin(max_p_gps))
			}
			else {
				ovlp_p_mat=(gps_tcat:>=colmax(min_p_gps))
			}
		}
		
		// Overlap=1 indicates that the individual satisfies these two conditions for 
		// ALL evaluated treatments
		overlap=rowsum(ovlp_mat):==tnr
		overlap[mm_which(gps:==. :| rowmissing(gps_t):>0),1]=J(rows(mm_which(gps:==. :| rowmissing(gps_t):>0)),1,0)
		// In addition impose that gps is strictly>0 and strictly<1
		overlap[mm_which(gps:==0 :| gps:>=1),1]=J(rows(mm_which(gps:==0 :| gps:>=1)),1,0)
		if (ovlp_value>0) {
			overlap_p=rowsum(ovlp_p_mat):==t_catnr
			overlap_p[mm_which(gps:==. :| rowmissing(gps_t):>0),1]=J(rows(mm_which(gps:==. :| rowmissing(gps_t):>0)),1,0)
			// In addition impose that gps is strictly>0 and strictly<1
			overlap_p[mm_which(gps:==0 :| gps:>=1),1]=J(rows(mm_which(gps:==0 :| gps:>=1)),1,0)
		}
			
		// Stores overlap as temporary variable "gps_suffix_ovlp"
		ovlpname=st_tempname(1)
		idx=st_addvar("double",ovlpname)
		st_store(.,idx,touse,overlap)   
		st_local(gps_suffix+"_ovlp",ovlpname) 
		// If ovlp_value>0 stores additional variable as temporary variable "gps_suffix_ovlp_p"
		if (ovlp_value>0) {
			ovlpname_p=st_tempname(1)
			idx2=st_addvar("double",ovlpname_p)
			st_store(.,idx2,touse,overlap_p)
			st_local(gps_suffix+"_ovlp_p",ovlpname_p)
		}
	}
}
mata mosave gps(), replace
end


