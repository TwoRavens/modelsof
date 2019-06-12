***************************************************************************
* File:               MI_Table3_aggregate_results.do
* Author:             Miguel R. Rueda
* Description:        Runs multiple imputation models. Results are in data editor.
* Created:            Aug - 16 - 2015
* Last Modified: 	  
* Language:           STATA 13.1 for Windows
* Related Reference:  "Small aggregates..."
***************************************************************************
cd "\Datasets\Amelia_MI_datasets\"

clear all

use outdata1.dta, clear
quietly: reg VB l4margin_index2 la_nbi_i l4pob_mesa lown_resources lpopulation larmed_actor  l4lsize, cluster(muni_code)
regsave using results_mi2, replace detail(all)
 

set more off
foreach var in 1 2 3 4 5 6 7 8 9 10{
	use outdata`var'.dta, clear
	tsset muni_code year, yearly

	rename VB VB_moe 
	
	gen l4lpob_mesa=log(l4pob_mesa)
	gen llnbi_i=la_nbi_i
	
 
	*Run regressions and store results
	foreach var1 in VB{
		

		xtpoisson `var1'_moe l4margin_index2 llnbi_i l4lpob_mesa lown_resources lpopulation larmed_actor l4lsize, fe
		regsave using results_mi2, append detail(all)
		nbreg `var1'_moe l4margin_index2 llnbi_i l4lpob_mesa lown_resources lpopulation larmed_actor l4lsize, cluster(muni_code)
		regsave using results_mi2, append detail(all)
	}
	
}

use results_mi2.dta,clear
save results_mib2.dta, replace

*Vote Buying and Polling Place Size (Table 3 models 5,6) 

*Setting up multiple imputation results for main models
foreach file in results_mib2.dta{
	use "`file'",clear

	drop if depvar=="VB"
	duplicates drop
	keep var coef stderr cmd depvar N N_clust N_g

	if "`file'"=="results_mib.dta"{
		foreach name in VB_moe { 
			replace var="l4lpob_mesa" if var=="`name':l4lpob_mesa"
			replace var="l4lsize" if var=="`name':l4lsize"
			replace var="larmed_actor" if var=="`name':larmed_actor"
		}
	}

	if "`file'"=="results_mib.dta"{
		keep if (var=="larmed_actor"|var=="l4lsize"|var=="l4lpob_mesa")
	}

*Calculating p-values adjusting for imputation error
	bysort cmd var depvar: egen mean_c=mean(coef)
	bysort cmd var depvar: egen mean_s=mean(stderr)
	bysort cmd var depvar: egen mean_N=mean(N)
	bysort cmd var depvar: egen mean_NC=mean(N_clust)
	bysort cmd var depvar: egen mean_Ng=mean(N_g)
	gen desv=(coef-mean_c)^2
	gen aux=1
	bysort cmd var depvar: egen obs=sum(aux)
	replace obs=obs-1
	bysort cmd var depvar: egen aux2=sum(desv)
	gen sq=aux2/obs
	gen st_mi=mean_s+sq*(1+1/(obs+1))
	keep cmd var depvar mean_c st_mi obs mean_N mean_NC mean_Ng

	duplicates drop
	gen p_val=min(normal(mean_c/st_mi),1-normal(mean_c/st_mi))*2

	save "`file'",replace
}
*Number of observations and municipalities are averages of observations and municipalities used in each regression
