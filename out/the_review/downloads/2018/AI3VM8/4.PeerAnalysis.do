*******************************************************************
* The effect of the ID program on peer evaluations
**********************************************************
	capture log close
	clear all
	macro drop _all
	set more off
	version 14.2
	set matsize 11000

****************************************************** 
*Set working directory 

capture cd "replication_APSR"
	
******************************************************
* Import councilor peer evaluation
******************************************************
use "Peer_evaluations.dta" 

	egen avescore= rmean(peer_score*) 
	order avescore, b(peer_score1)
	lab var avescore "Average peer evaluation"

******************************************************
* merge-in councilor covariates
******************************************************	
	merge 1:1 id using "Councilors_covariates_v2.dta"
	keep if _m==3
	drop _merge

********************************************************
* Define covariates
******************************************************

	gl covs NRM SWC Edu SMS cterms FirstTerm NOfChallengers2011 lpop constit_poverty constit_hhi 
	su $covs

	* assign mean values of control to missing values of covariates (Lin, green and Coppock, 2015))
	foreach y in $covs {
	 egen `y'_mean=mean(`y')
	 gen `y'_miss = `y'==.
	 replace `y' = `y'_mean if `y'==.
	 }

	gen initial_score = total_score_2011_2012

	bys district: egen initial_mean_low=mean(total_score_2011_2012) if competitive ==0
	replace initial_score = initial_mean_low if initial_score==. & competitive ==0
	
	bys district: egen initial_mean_high=mean(total_score_2011_2012) if competitive ==1
	replace initial_score = initial_mean_high if initial_score==. & competitive ==1
	gen initial_score_miss = total_score_2011_2012==.
	
	gl controls NRM SWC Edu SMS  FirstTerm NOfChallengers2011 lpop constit_poverty  FirstTerm_miss NOfChallengers2011_miss constit_hhi lpop_miss constit_poverty_miss constit_hhi_miss 
	su $controls
	 
* define sample
	gen sample=0
	replace sample=1 if NRM!=. & SWC!=. & Edu!=. & SMS!=. & FirstTerm!=. & NOfChallengers2011!=. & lpop!=. & constit_poverty!=. & constit_hhi!=. & competitive!=.

* create var capturing whether the councilor's baseline scorer was above the district median

	bysort distid : egen median_by_dist = median(initial_score) 
	gen HighP = cond(missing(initial_score), ., (initial_score > median_by_dist))
	lab var HighP "Initial score above median" 
	
	* Majority distance: alternative measure of competitivness
	replace MarginOfVictory2011=-1*MarginOfVictory2011
	gen kcomp= -1*(VoteShare2011-.5)
	egen medianK = median(kcomp) 
	gen kcompB = cond(missing(kcomp), ., (kcomp > medianK))
	lab var kcompB "Majority distance binary"

******************************************************
* reshape long format	
******************************************************
	 reshape long peer_score, i(id) j(peer) 	
	 drop if peer_score==.
	 label values peer .
	 lab define pscore 1 "Far below average" 2 "Below average" 3 "Average" 4 "Above average" 5 "Far above average", modify
	 lab value peer_score pscore
	 tab peer_score
	 egen tag=tag(id avescore)

saveold "Peer_evaluations_long.dta", replace	 

******************************************************
* unconditional ID effects	
******************************************************	 

* M1: with district FEs
reghdfe peer_score i.ID if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control ""
	est store peer_score_m1
	
* M2: add councilor level random effects
reghdfe peer_score i.ID $controls if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store peer_score_m2

******************************************************
* ID effects Conditional on electoral competition	
******************************************************	 
* M4: base
set more off

* M3: with district FEs
reghdfe peer_score ID##competitive $controls if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store peer_score_m3
	margins, dydx(ID) over(competitive)
	
* M4: add controls
reghdfe peer_score ID##kcompB $controls if sample==1 [pw=IPW], abs(distid) cl(id)
	estadd local control "X"
	est store peer_score_m4
	margins, dydx(ID) over(kcompB)

* M5: full model with continuous measure
reghdfe peer_score ID##c.MarginOfVictory2011 $controls if sample==1 [pw=IPW], abs(distid) cl(id)	
	estadd local control "X"
	est store peer_score_m5
	
reghdfe peer_score ID##c.kcomp $controls if sample==1 [pw=IPW], abs(distid) cl(id)	
	estadd local control "X"
	est store peer_score_m6	

************************************			
* Table	15 online appendix				
************************************	
	# delimit ; 
	esttab  peer_score_m1 peer_score_m2 peer_score_m3 peer_score_m4 peer_score_m5 peer_score_m6
	using "tables/peer_score.tex", replace
		keep (1.ID 1.competitive 1.ID#1.competitive 1.kcompB 1.ID#1.kcompB MarginOfVictory2011  1.ID#c.MarginOfVictory2011 kcomp 1.ID#c.kcomp)
		order(1.ID 1.competitive 1.ID#1.competitive 1.kcompB 1.ID#1.kcompB MarginOfVictory2011  1.ID#c.MarginOfVictory2011 kcomp 1.ID#c.kcomp)
			cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
			starlevels(* .10 ** .05 *** .01) 					
			mgroups("\textbf{Unconditional}" "\textbf{Conditional (binary)}" "\textbf{Conditional (cont)}", pattern(1 0 1 0 1 0)
			span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
			varlabels(1.ID "ID"
					  1.competitive "Competitive (MoV)"
					  1.ID#1.competitive "ID*Competitive (MoV)"
					  1.kcompB "Competitive (MD)"
					  1.ID#1.kcompB "ID*Competitive (MD)"
					  MarginOfVictory2011 "Margin of Victory"
					  1.ID#c.MarginOfVictory2011 "ID*Margin of Victory"
					  kcomp "Majority distance"
					  1.ID#c.kcomp "ID*Majority distance")
			stats(control N, labels("Controls" "N" )
			fmt(0 0)) collabels(none)	label booktabs nonotes;
	#delimit cr	
	
exit	
