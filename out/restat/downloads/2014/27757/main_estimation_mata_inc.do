* MAIN_ESTIMATION_MATA_INC.DO
*
* This code is "included" by the "main_estimation.do" programs so these mata functions are defined in memory
*
* Program written for Flores, Carlos A. and Oscar A. Mitnik (2013). 
* "Comparing Treatments across Labor Markets: An Assessment of Nonexperimental 
* Multiple-Treatment Strategies", Review of Economics and Statistics, 
* December 2013, Vol. 95, No. 5, Pages 1691-1707.
*
* Version: November 2010
*

* Mata function to calculate root mean squared distance, mean absolute distance and maximum distance
* from a vector of estimated coefficients
version 9.2
set matastrict off
mata:
void dist(string betas_vec, scalar mean, string rmsd_val, string mad_val, string maxdist_val, string mean_val, | scalar wgt_mean_opt, scalar ystd_opt)
{
	// Reads vector with coefficients (this has to be a row vector)
	betas=st_matrix(betas_vec)
	
	// This change: August 2009
	// If "wgt_mean_opt" = 1 then use input scalar "mean" in calculation of RMSD and MAD (and saves it to "mean_val")
	// (this input scalar "mean" could be either zero (if `betastd'==0) or the mean calculated above, which implicitly 
	//  weights more sites with more individuals)
	// If "wgt_mean_opt" = 0 then disregards input scalar "mean" and uses arithmetic mean of betas to calculate RMSD and MAD
	// (then, this is an unweighted mean). It also, saves this arithmetic mean to "mean_val".
	if (wgt_mean_opt==0) calc_mean=mean(betas')
	else if (wgt_mean_opt==1) calc_mean=mean
	 	
	// November 2010 modification: divide RMSD, MAD and MDIST by abs(mean) of estimated betas (calc_mean)
	//                             BUT only if outcome is NOT standardized (to avoid dividng by zero)
	if (ystd_opt== 0) div_mean=abs(calc_mean)
	else div_mean=1
	// Calculates root mean squared distance to mean (or zero, if mean=0)
	rmsd=(sqrt(rowsum((betas:-calc_mean):^2)/cols(betas)))/div_mean
	// Calculates mean absoulte distance to mean (or zero, if mean=0) 
	mad=(rowsum(abs(betas:-calc_mean))/cols(betas))/div_mean
	// Calculates maximum distance
	maxdist=(rowmax(betas)-rowmin(betas))/div_mean
	
	// Puts results in Stata matrices (1x1)
	st_matrix(rmsd_val,rmsd)
	st_matrix(mad_val,mad)
	st_matrix(maxdist_val,maxdist)
	st_matrix(mean_val,calc_mean)
}
end


* Mata function to calculate root mean squared distance, mean absolute distance and maximum distance
* from a dataset of estimated coefficients (i.e. from bootstrap replications)
* Returns to stata just the lower bound and upper bound of a 95% confidence interval
* (i.e. returns percentiles 0.025 and 0.975) for the particular outcome and estimator
version 11
mata:
void dist_bs(string betas_suffix, string treat_vals, string rmsd_ci, string mad_ci, string maxdist_ci, string mean_val_ci, | scalar ystd_opt)
{
	// Reads matrix with coefficients (#rows=# BS replications, #columns=#treatments)
	betas=J(0,0,0)
	st_view(betas,.,J(1,cols(tokens(treat_vals)),betas_suffix)+tokens(treat_vals),0)
	
	// Mean of betas
	calc_mean=mean(betas')'
	 	
	// Divide RMSD, MAD and MDIST by abs(mean) of estimated betas
	// BUT only if outcome is NOT standardized (to avoid dividng by zero)
	if (ystd_opt== 0) div_mean=abs(calc_mean)
	else div_mean=1
	
	// Calculates root mean squared distance to mean (or zero, if mean=0)
	rmsd=(sqrt(rowsum((betas:-calc_mean):^2):/cols(betas))):/div_mean
	// Calculates mean absoulte distance to mean (or zero, if mean=0) 
	mad=(rowsum(abs(betas:-calc_mean)):/cols(betas)):/div_mean
	// Calculates maximum distance
	maxdist=(rowmax(betas)-rowmin(betas)):/div_mean
	
	// Calculates CIs for rmsd, mad, maxdist and mean_val 
	// This is a 95% CI based on 0.025 and 0.0975 percentiles
	rmsd_ci_n     = mm_quantile(rmsd,1,(.025\.975)) 
	mad_ci_n      = mm_quantile(mad,1,(.025\.975)) 
	maxdist_ci_n  = mm_quantile(maxdist,1,(.025\.975)) 
	mean_val_ci_n = mm_quantile(calc_mean,1,(.025\.975)) 
	
	// Puts results in Stata matrices (2x1)
	st_matrix(rmsd_ci,rmsd_ci_n)
	st_matrix(mad_ci,mad_ci_n)
	st_matrix(maxdist_ci,maxdist_ci_n)
	st_matrix(mean_val_ci,mean_val_ci_n)
}
end
