************************
***EXPERTISE SAMPLING***
************************

*Working Directory
cd "D:\Informant Paper\political_analysis\Replication Materials"

*Data
use "CCES Data", clear

*District-level partisan distribution
tab pid, g(piddum)
egen districtn=count(pid3), by(district)
egen districtndem=total(piddum1), by(district)
egen districtnind=total(piddum2), by(district)
egen districtnrep=total(piddum3), by(district)
g percdem=districtndem/districtn
g percind=districtnind/districtn
g percrep=districtnrep/districtn

*Dropping District with too few experts
drop if expert_n<30

*Saving
save sim_temp, replace

*Setting Up File to Save To
postutil clear
postfile mypost skewed number expert ///
	rel rel_p rel_wp val val_p val_wp  ///
	relL rel_pL rel_wpL valL val_pL val_wpL  ///
	relH rel_pH rel_wpH valH val_pH val_wpH  ///
	using cces_sim_results, replace

*Looping Through Multiple Iterations
foreach number_sims of numlist 1/1{
	display `number_sims' " " 
	
	*Looping Through Partisan Distribution 
	foreach random_or_skewed of numlist 0/1 {	
		
		*Looping Through Random and Expert Samples
		foreach random_or_expert of numlist 0/1 {	
			
				*Looping Through Sample Size
				quietly foreach num of numlist 2(5)30 {
			
				**********
				***DATA***
				**********
				
				*Data
				use sim_temp, clear
				
				*Dropping District with too few experts
				drop if expert_n<30

				*Random or Expert
				g r_or_e=`random_or_expert'
				drop if expert==0&r_or_e==1
				
				*Randomly assigning district to by skewed Democrat/Republican
				g x=runiform()
				egen xmean=mean(x), by(district)
				recode xmean min/.5=0 .5/max=1, g(republican) 
				
				*Assigning weights
				g weight=1 
				if `random_or_skewed'==1 {
					replace weight=1/percind if pid3==0
					replace weight=1.5/percrep if republican==0&pid3==1
					replace weight=7.5/percdem if republican==0&pid3==-1	
					replace weight=7.5/percrep if republican==1&pid3==1
					replace weight=1.5/percdem if republican==1&pid3==-1		
				}			
					
				*Weighting
				expand weight

				*Sampling Respondents 
				bsample `num', strata(district)
			
				*****************
				***PURGED MEAN***
				*****************
				
				*Multilevel Purging
				xtmixed rlc_voter pid3 ||district: pid3, iterate(10) 
				predict rslope rintercept , reffects
				scalar rpurge=_b[pid3]
				g rlc_p=rlc_voter-(_b[pid3]+rslope)*pid3 
				xtmixed dlc_voter pid3 ||district: pid3, iterate(10) 
				predict dslope dintercept , reffects
				scalar dpurge=_b[pid3]
				g dlc_p=dlc_voter-(_b[pid3]+dslope)*pid3 
				
				*Incumbent Ideology
				g inclc_p=rlc_p if repinc10==1&incran10==1
				replace inclc_p=dlc_p if deminc10==1&incran10==1

				*******************
				***WEIGHTED MEAN***
				*******************
				
				*An Alpha of 4
				replace expertise=expertise^4
			
				*Constructing Weighted Measure
				egen sumexpertise=sum(expertise), by(district)
				egen inclc_wp=sum(expertise/sumexpertise*inclc_p), by(district)
				
				*****************
				***Reliability***
				*****************
				
				*Simple Mean
				loneway inclc district
				scalar rel=r(rho_t)
				loneway inclc district if absdistpartymediannominate_D==0
				scalar relL=r(rho_t)
				loneway inclc district if absdistpartymediannominate_D==1
				scalar relH=r(rho_t)	
				
				*Purged Mean
				loneway inclc_p district
				scalar rel_p=r(rho_t)
				loneway inclc_p district if absdistpartymediannominate_D==0
				scalar rel_pL=r(rho_t)
				loneway inclc_p district if absdistpartymediannominate_D==1
				scalar rel_pH=r(rho_t)	
				
				*Weighted/Purged Mean
				loneway inclc_p district [aw=expertise]
				scalar rel_wp=r(rho_t)
				loneway inclc_p district [aw=expertise] if absdistpartymediannominate_D==0
				scalar rel_wpL=r(rho_t)
				loneway inclc_p district [aw=expertise] if absdistpartymediannominate_D==1
				scalar rel_wpH=r(rho_t)	
				
				***************************
				***AGGREGATING RESPONSES***
				***************************
				
				*Aggregating Simple and Purged Measures
				collapse inclc inclc_p inclc_wp nominate10 *D, by(district)
				
				**************
				***VALIDITY***
				**************
						
				*Simple Mean
				cor inclc nominate10
				scalar val=r(rho)
				cor inclc nominate10 if absdistpartymediannominate_D==0
				scalar valL=r(rho)
				cor inclc nominate10 if absdistpartymediannominate_D==1
				scalar valH=r(rho)
				
				*Purged Mean
				cor inclc_p nominate10
				scalar val_p=r(rho)
				cor inclc_p nominate10 if absdistpartymediannominate_D==0
				scalar val_pL=r(rho)
				cor inclc_p nominate10 if absdistpartymediannominate_D==1
				scalar val_pH=r(rho)
				
				*Weighted/Purged Mean
				cor inclc_wp nominate10
				scalar val_wp=r(rho)		
				cor inclc_wp nominate10 if absdistpartymediannominate_D==0
				scalar val_wpL=r(rho)
				cor inclc_wp nominate10 if absdistpartymediannominate_D==1
				scalar val_wpH=r(rho)
								
				*Saving Restults
				post mypost (`random_or_skewed') (`num') (`random_or_expert')  ///
					(rel) (rel_p) (rel_wp) (val) (val_p) (val_wp) ///
					(relL) (rel_pL) (rel_wpL) (valL) (val_pL) (val_wpL) ///
					(relH) (rel_pH) (rel_wpH) (valH) (val_pH) (val_wpH) 
			}
		}
	}
}
postclose mypost

*********************
***COLLAPSING DATA***
*********************

*Results
use cces_sim_results, clear

*Collapsing
collapse  rel-val_wpH, by(number expert skewed)

*Random and Expert Indicators
recode expert 1=0 0=1, g(random)

***********************************************************************
***EFFECT OF SAMPLE SIZE AND EXPERTISE AS DIFFICULTY OF TASK CHANGES***
***********************************************************************

*Figure 1
twoway  (scatter rel number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter rel number if expert==1&skewed==0, legend(order(1 "Unscreened" 2 "Screened")))
twoway  (scatter val number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter val number if expert==1&skewed==0, legend(order(1 "Unscreened" 2 "Screened")))
		
*Figure 2
twoway  (scatter relL number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter relL number if expert==1&skewed==0, legend(order(1 "Unscreened" 2 "Screened")))
twoway  (scatter relH number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter relH number if expert==1&skewed==0, legend(order(1 "Unscreened" 2 "Screened")))
twoway  (scatter valL number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter valL number if expert==1&skewed==0, legend(order(1 "Unscreened" 2 "Screened")))
twoway  (scatter valH number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter valH number if expert==1&skewed==0, legend(order(1 "Unscreened" 2 "Screened")))
		
*Figure 3
twoway  (scatter rel number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter rel_p number if expert==0&skewed==0, legend(order(1 "Uncorrected" 2 "Corrected")))
twoway  (scatter rel number if expert==1&skewed==0, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter rel_p number if expert==1&skewed==0, legend(order(1 "Uncorrected" 2 "Corrected")))
twoway  (scatter val number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter val_p number if expert==0&skewed==0, legend(order(1 "Uncorrected" 2 "Corrected")))
twoway  (scatter val number if expert==1&skewed==0, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter val_p number if expert==1&skewed==0, legend(order(1 "Uncorrected" 2 "Corrected")))

*Figure 4
twoway  (scatter rel number if expert==0&skewed==1, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter rel_p number if expert==0&skewed==1, legend(order(1 "Uncorrected" 2 "Corrected")))
twoway  (scatter rel number if expert==1&skewed==1, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter rel_p number if expert==1&skewed==1, legend(order(1 "Uncorrected" 2 "Corrected")))
twoway  (scatter val number if expert==0&skewed==1, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter val_p number if expert==0&skewed==1, legend(order(1 "Uncorrected" 2 "Corrected")))
twoway  (scatter val number if expert==1&skewed==1, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter val_p number if expert==1&skewed==1, legend(order(1 "Uncorrected" 2 "Corrected")))

*Figure 5
twoway  (scatter rel_p number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter rel_wp number if expert==0&skewed==0, legend(order(1 "Unweighted" 2 "Weighted")))
twoway  (scatter rel_p number if expert==1&skewed==0, ylab(.55(.15)1) ytitle("Reliability") xtitle("Number of Respondents")) ///
		(scatter rel_wp number if expert==1&skewed==0, legend(order(1 "Unweighted" 2 "Weighted")))
twoway  (scatter val_p number if expert==0&skewed==0, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter val_wp number if expert==0&skewed==0, legend(order(1 "Unweighted" 2 "Weighted")))
twoway  (scatter val_p number if expert==1&skewed==0, ylab(.55(.15)1) ytitle("Correlation") xtitle("Number of Respondents")) ///
		(scatter val_wp number if expert==1&skewed==0, legend(order(1 "Unweighted" 2 "Weighted")))
