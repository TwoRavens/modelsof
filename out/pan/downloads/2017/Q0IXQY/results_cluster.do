// This do-file runs the simulations w/ clustered sample reported in Figure A.3 in the paper 
// "Using Split Samples to Improve Inference on Causal Effects" (M. Fafchamps and J. Labonne)

version 12
set more off , perm
net set ado  "ado"
adopath +  "ado"
set scheme sol

* Start by creating a file with all the values of the various parameters 
* n captures the sample (varies from 500 to 10,000 in increments of 50) 
clear
set seed 234
set obs 191
g n=50*(9+_n)
save "data/main_frame.dta" , replace

* rho captures the intra cluster correlation
foreach rho in .05 .1     {

	use "data/main_frame.dta" 
	g rho = `rho'

	local s2 =100*`rho'
	save "data/frame_`s2'.dta" , replace

		
}	

* append all the files 
clear
foreach rho in 5 10     {
	
	append using "data/frame_`rho'.dta"
	erase "data/frame_`rho'.dta"

}

g effect_size = .2
g m=100
g non_true_ratio=1
g m0 = m*(100-non_true)/100
g alpha=.05
g share=.5
g obs_per_clus = 20

****************************************
* Full sample w/ cluster, bonferonni corrections
****************************************
// this is equation (5) from the paper 
g power_bonf=normal( effect_size * sqrt(n/(4*[1+(obs_per_clus-1)*rho])) - invnormal(1-alpha/(2*m)) )  

****************************************
* Split sample,  bonferonni corrections
****************************************
// this is equation (5) from the paper (adjusted for the fact that we use a subset of the data on the training sample
g power_first_share =normal( effect_size * sqrt(share*n/(4*[1+(obs_per_clus-1)*rho])) - invnormal(1-alpha/(2)) )  

*Note: From that point forward we need to run some simulations as the values depend 
*on the number of tests that are carried out on the testing sample 

//here we compute how many hypotheses are rejected on the training sample and thus tested on the testing sample
capture drop nb_tests_total
g nb_tests_total = rbinomial(m0,alpha) + rbinomial(m - m0 , power_first_share) if power_first_share < 1 
replace nb_tests_total = rbinomial(m0,alpha) + m - m0  if power_first_share == 1 

// power on the testing sample depends on the number of variables for which the null is rejected on the training sample
g power_second_share_bonf = normal( effect_size * sqrt((1-share)*n/(4*[1+(obs_per_clus-1)*rho])) - invnormal(1-alpha/(2*nb_tests_total)) ) if nb_tests_total> 0
replace power_second_share_bonf = 0 if nb_tests_total==0

capture drop nb_tests_true
g nb_tests_true = rbinomial(m0,alpha) 

* This step runs the 10,000 iterations 
forvalues i=2(1)10000 {

	display "`i' out of 10,000"

	qui {
		* Split sample, bonferonni corrections
		capture drop nb_tests_total
		g nb_tests_total = rbinomial(m0,alpha) + rbinomial(m - m0 , power_first_share) if power_first_share < 1 
		replace nb_tests_total = rbinomial(m0,alpha) + m - m0  if power_first_share == 1 
		replace power_second_share_bonf = (`i'-1)/`i'* power_second_share_bonf + ///
		1/`i'*[normal( effect_size * sqrt((1-share)*n/(4*[1+(obs_per_clus-1)*rho])) - invnormal(1-alpha/(2*nb_tests_total))) ] if nb_tests_total > 0

		replace power_second_share_bonf = (`i'-1)/`i'* power_second_share_bonf if nb_tests_total == 0

	}
}

g power_split_bonf = power_first_share * power_second_share_bonf
save "data/results_clustering.dta", replace


use "data/results_clustering.dta" , clear

//odd STATA behavior with the variables effect_size and rho 
// need to hardcode them
levelsof effect_size
g effect_size2 = ".2"  
destring effect_size2 , replace force
drop effect_size
rename effect_size2 effect_size
levelsof rho
g rho2 = ".05" 
replace rho2 = ".1" if  rho > .06 &  rho < .15 
destring rho2 , replace force
drop rho
rename rho2 rho

*** FIGURE A.3		
	
	tw 	(line power_bonf n if rho==.05, msize(vsmall) lpattern(solid) lcolor(gs9) legend(label(1 "Full sample ({&rho}=-.05)"))) ///
	(line power_split_bonf n if rho==.05, msize(vsmall) lpattern(longdash) lcolor(gs9) legend(label(2 "Split sample ({&rho}=-.05)"))) ///
	(line power_bonf n if rho==.1, msize(vsmall) lpattern("-.") lcolor(gs9) legend(label(3 "Full sample ({&rho}=-.1)"))) ///
	(line power_split_bonf n if rho==.1, msize(vsmall) lpattern(shortdash) lcolor(gs9) legend(label(4 "Split sample ({&rho}=-.1)")) ///
	xtitle("Sample Size [Effect Size: .2]") ytitle("Power") name(power`b' , replace) )
	graph export "output/cluster_power_20.pdf", as(pdf) replace
		
	



rease "data/main_frame.dta" 


	
	
