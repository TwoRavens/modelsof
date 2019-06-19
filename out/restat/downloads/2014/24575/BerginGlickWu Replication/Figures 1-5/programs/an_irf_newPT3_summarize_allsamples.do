*** Note: this file uses the Imbs_equiv cutdown sample: i.e. (MarksSul country+ Finland)/(US) pairs
/* Written by Andrew Cohn, April 2009.
	The purpose of this file is to create summary graphs across goods from the various IRFs created in the 3var Pt III CCEP ECM
	specification, specifically look at the 
		an_ccep_semiannual_ecm_newPT3_f1_`descrip'.do 
	series of files. This program creates summary graphs for a number of samples, specified below in samplelist
*/
matrix drop _all
clear
clear results
clear mata
capture log close
set more off
set mem 700m
set varabbrev off

// NB this is a new version. The old one erroneously plotted medians rather than means: this led to inconsistent picking of goods between s, p, q


global graphPath "P:\BerginGlickWu Replication\Figures 1-5\Graphs"
local programpath "P:\BerginGlickWu Replication\Figures 1-5\programs"
local outpath1 "P:\BerginGlickWu Replication\Figures 1-5\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"



capture program drop _all

cd "$programPath"
set maxvar 30000
set matsize 5000

local numgoods = 101
local nirp = 40								// Number of impulse response periods
local lowpct = 10
local upppct = 90
local samplelist indust             		// List of sample cutdowns

*** Looping across samples, making graphs for each
foreach sample of local samplelist {
	di "`sample'
	** Setting output path, loading data
	use "`datapath'/irfcoeffs_newPT3_semiannual_PW_f1_indust.dta", clear
	

	keep if horizon <= `nirp'
	keep horizon girff* VD* CVD*
	
	**** Changing naming convention: exchange rate goes from s to e. capture command needed as some goods are missing
	forvalues j = 1/`numgoods' {
		capture {
			foreach name in s p pk qk q {
				rename girff_`name'_Sshock_good`j'		 girff_`name'_eshock_good`j'
			}
			foreach name in e P pk {
				rename girff_s_`name'shock_good`j'		 girff_e_`name'shock_good`j'
			}
			foreach name in S P pk {
				rename VD_`name'_from_S_good`j' 		 VD_`name'_from_e_good`j'
			}
			foreach name in e P pk {
				rename VD_S_from_`name'_good`j'		 VD_e_from_`name'_good`j'
			}
			foreach name in qk Q Q_minus_qk {
				rename CVD_`name'_from_S_good`j'		 CVD_`name'_from_e_good`j'
			}
		}
	}

	local shocklist e P pk						// Three types of shocks

	*** Generating lists of variables to reshape along			
	foreach type of local shocklist {
		local irfvars_`type'  	girff_e_`type'shock_good 	girff_p_`type'shock_good 	girff_pk_`type'shock_good 	girff_q_`type'shock_good 	girff_qk_`type'shock_good
		**local vdvars_`type' 	VD_e_`type'shock_good 	VD_p_`type'shock_good 	VD_pk_`type'shock_good
		local vdvars_`type' 	VD_`type'_from_e_good 	VD_`type'_from_P_good 	VD_`type'_from_pk_good
	}
	
	local cvdlist 	Q  qk			// Three variables used for CVDS
	foreach cvdvar of local cvdlist { 
		local cvdvars_`cvdvar'		CVD_`cvdvar'_from_e_good	CVD_`cvdvar'_from_P_good	CVD_`cvdvar'_from_pk_good	 
	}

	*** Reshaping long along goods. CAPTURE command needed because otherwise it crashes labelling vars (names are too long)
	capture reshape long `irfvars_e' `irfvars_P' `irfvars_pk' `vdvars_e' `vdvars_P' `vdvars_pk' `cvdvars_Q' `cvdvars_qk' `cvdvars_Q_minus_qk', i(horizon) j(good)
	sort horizon good
	di "Done reshaping..."

	foreach type of local shocklist {
		rename girff_e_`type'shock_good 	girff_e_`type'shock
		rename girff_p_`type'shock_good 	girff_p_`type'shock 
		rename girff_pk_`type'shock_good 	girff_pk_`type'shock
		rename girff_q_`type'shock_good 	girff_q_`type'shock
		rename girff_qk_`type'shock_good 	girff_qk_`type'shock

		rename VD_`type'_from_e_good 		VD_`type'_from_e
		rename VD_`type'_from_P_good 		VD_`type'_from_p
		rename VD_`type'_from_pk_good		VD_`type'_from_pk
		
		*** Generating means and pctiles of irfs across goods, for a given shock. Labelling variables to be plotted
		local mylist e p pk q qk
		foreach var of local mylist {
			by horizon: egen girff_`var'_`type'shock_mean = mean(girff_`var'_`type'shock)
			label var 	girff_`var'_`type'shock_mean 	"`var'"
			by horizon: egen tempsd = sd(girff_`var'_`type'shock)
			by horizon: gen girff_`var'_`type'shock_low = girff_`var'_`type'shock_mean - tempsd
			by horizon: gen girff_`var'_`type'shock_upp = girff_`var'_`type'shock_mean + tempsd	
			drop tempsd	
		}
	
		*** Generating means and pctiles of variance decompositions across goods, for a given shock
		local mylist e p pk
		foreach var of local mylist {
			by horizon: egen VD_`type'_from_`var'_mean = mean(VD_`type'_from_`var')
			label var  VD_`type'_from_`var'_mean 	"`var' contribution"
			by horizon: egen tempsd = sd(VD_`type'_from_`var')
			by horizon: gen VD_`type'_from_`var'_low = VD_`type'_from_`var'_mean - tempsd
			by horizon: gen VD_`type'_from_`var'_upp = VD_`type'_from_`var'_mean + tempsd	
			drop tempsd
		}

		preserve
		by horizon: gen counter = [_n]			// Use this to pull only one observation/date for graphing
		keep if counter == 1
		tsset horizon

		#delimit ;
		tsline 	girff_e_`type'shock_mean 	girff_p_`type'shock_mean 	girff_q_`type'shock_mean 
				girff_pk_`type'shock_mean	girff_qk_`type'shock_mean 
				, xlabel(0(20)`nirp') title("`type'-shock. Mean, `lowpct' - `upppct' pctiles")
				saving("$graphPath/irfsummary_`type'shock_nobounds_`sample'.gph", replace);
		graph export "$graphPath/irfsummary_`type'shock_nobounds_`sample'.png", replace;
		
		#delimit cr
		
		restore
	}

	*** Need to loop along different set of variables for composite variance decompositions
	foreach cvdvar of local cvdlist {
		rename CVD_`cvdvar'_from_e_good 		CVD_`cvdvar'_from_e
		rename CVD_`cvdvar'_from_P_good 		CVD_`cvdvar'_from_p
		rename CVD_`cvdvar'_from_pk_good		CVD_`cvdvar'_from_pk
		

		*** Generating medians and pctiles of variance decompositions across goods, for a given shock
		local mylist e p pk
		foreach var of local mylist {
			by horizon: egen CVD_`cvdvar'_from_`var'_mean = mean(CVD_`cvdvar'_from_`var')
			label var 	CVD_`cvdvar'_from_`var'_mean 		"`var' contribution"
			by horizon: egen tempsd = sd(CVD_`cvdvar'_from_`var')
			by horizon: gen CVD_`cvdvar'_from_`var'_low = CVD_`cvdvar'_from_`var'_mean - tempsd
			by horizon: gen CVD_`cvdvar'_from_`var'_upp = CVD_`cvdvar'_from_`var'_mean + tempsd
			drop tempsd	
		}
		
		preserve
		by horizon: gen counter = [_n]			// Use this to pull only one observation/date for graphing
		keep if counter == 1
		tsset horizon

		#delimit ;
		tsline 	CVD_`cvdvar'_from_e_mean 		CVD_`cvdvar'_from_p_mean			CVD_`cvdvar'_from_pk_mean 				
				, lpattern(solid solid solid )
	  			lcolor(red green lime)
				name(CVD, replace) xlabel(0(20)`nirp') ylabel(0(.2)1, grid) title("")
				saving("$graphPath/CVDsummary_`cvdvar'_`sample'.gph", replace);
		graph export "$graphPath/CVDsummary_`cvdvar'_`sample'.png", replace;

		#delimit cr
		
		restore
	}

	** Outsheeting mean IRFs, VDs, CVDs to excel. Will be found in Graphs/IRFnewPT3/`sample'/ folder
	preserve
	by horizon: gen counter = [_n]			// Use this to pull only one observation/date for graphing
	keep if counter == 1
	tsset horizon
	outsheet horizon girff_*_mean VD_*_mean CVD_*_mean using "$graphPath/irf_VD_newPT3_meanresponse_`sample'.csv", comma names replace
	restore
}
capture log close
exit


