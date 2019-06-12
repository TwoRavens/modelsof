// This do-file runs the main simulations reported in the paper [Table 1 and Figures 1-5 and A.1-A.2]
// "Using Split Samples to Improve Inference on Causal Effects" (M. Fafchamps and J. Labonne, forthcoming in Political Analysis)



version 12
set more off , perm
net set ado  "ado/"
adopath +  "ado/"
set scheme sol

capture ssc install logout

* Start by creating a file with all the values of the various parameters 
* n captures the sample (varies from 500 to 10,000 in increments of 50) 
clear
set seed 234
set obs 191
g n=50*(9+_n)
save "data/main_frame.dta" , replace

* e captures the 3 effect sizes 
* s captures the share of observations allocated to the testing/training sample
* m captures the number of variables in the datasets
* m0 captures the number of variables for which the null hypothese is false
foreach e in  .10 .20 .30 {
	foreach s in  .30 .50 .70   {
		foreach m in 10 100 1000 { 
		foreach m0 in 1 10 { 

				use "data/main_frame.dta"
				g effect_size = `e'
				g share = `s'
				g m=`m'
				g non_true_ratio=`m0' 
		
				local e2 =100*`e'
				local s2 =100*`s'
				save "data/frame_`e2'_`s2'_`m'_`m0'.dta" , replace
		}
		}
	}	
}	

* append all the files 
clear
foreach e in 10 20 30 {
	foreach s in 30 50 70   {
			foreach m in 10 100 1000 { 
				foreach m0 in 1 10 {
	
				append using "data/frame_`e'_`s'_`m'_`m0'.dta"
				erase "data/frame_`e'_`s'_`m'_`m0'.dta"
			}
			}
	}
}

drop if m==10 & non_true_ratio==1
g m0 = m*(100-non_true)/100
g alpha=.05

//odd STATA behavior with the variables effect_size and share 
// need to hardcode them

levelsof effect_size
g effect_size2 = ".05" 
replace effect_size2 = ".1" if  effect_size > .06 &  effect_size < .14 
replace effect_size2 = ".2" if  effect_size > .15 &  effect_size < .25 
replace effect_size2 = ".3" if  effect_size > .25 
destring effect_size2 , replace force
drop effect_size
rename effect_size2 effect_size

levelsof share
g share2 = ".3" 
replace share2 = ".5" if  share > .45 &  share < .55 
replace share2 = ".7" if  share > .65 &  share < .75 
destring share2 , replace force
drop share 
rename share2 share
levelsof share

******************************
*** COMPUTE POWER & FWER 
******************************

****************************************
* Full sample, bonferonni corrections w/ PAP
****************************************
// this is equation (2) from the paper
// we assume that the PAP includes 10 variables 
g power_bonf_pap =normal( effect_size * sqrt(n/4) - invnormal(1-alpha/(2*10)) )  

// For various values of Psi 
// Psi is the likelihood that variables for which the null hypotheses is non-true are included in the PAP
g power_bonf_pap_75 = power_bonf_pap*.75
g power_bonf_pap_50 = power_bonf_pap*.5
g power_bonf_pap_25 = power_bonf_pap*.25

g fwer_bonf = 1 - (1-alpha/m)^(m0) 


***************************************
* Split sample,  bonferonni corrections
****************************************
// this is the first part of equation (3) from the paper
// It's the likelihood that the null is rejected on the testing sample
g power_first_share =normal( effect_size * sqrt(share*n/4) - invnormal(1-alpha/(2)) )  

*Note: From that point forward we need to run some simulations as the values depend 
*on the number of tests that are carried out on the testing sample 

* We start by initializing the various counts
	// this is equation (4) in the paper
	// compute the number of variables that are going to be tested on the training sample
	g nb_tests_total = rbinomial(m0,alpha) + rbinomial(m - m0 , power_first_share) if power_first_share < 1 
	replace nb_tests_total = rbinomial(m0,alpha) + m - m0  if power_first_share == 1 
	
	// this is the second part of equation (3) [depends on whether at least one variable is rejected on the training sample]
	// power on the testing sample depends on the number of variables for which the null is rejected on the training sample
	g power_second_share_bonf = normal( effect_size * sqrt((1-share)*n/4) - invnormal(1-alpha/(2*nb_tests_total)) ) if nb_tests_total> 0
	replace power_second_share_bonf = 0 if nb_tests_total==0
	
	capture drop nb_tests_true
	g nb_tests_true = rbinomial(m0,alpha) 
	g fwer_split_bonf = 1 - (1-alpha/nb_tests_total)^(nb_tests_true) 


****************************************
* Split sample,  bonferonni corrections (10% threshold on the training sample)
* Note: this repeats the previous step. The only differnce is that instead of using the 5% threshold 
* on the training sample we use the 10% threshold
****************************************
// It's is the likelihood that the null is rejected on the testing sample
g power_first_share_10 =normal( effect_size * sqrt(share*n/4) - invnormal(1-2*alpha/(2)) ) 


* We start by initializing the various counts
	// compute the number of variables that are going to be tested on the training sample
	capture drop nb_tests_total
	g nb_tests_total = rbinomial(m0,2*alpha) + rbinomial(m - m0 , power_first_share_10) if power_first_share_10 < 1 
	replace nb_tests_total = rbinomial(m0,2*alpha) + m - m0  if power_first_share_10 == 1 
	
	// power on the testing sample depends on the number of variables for which the null is rejected on the training sample
	g power_second_share_bonf_10 = normal( effect_size * sqrt((1-share)*n/4) - invnormal(1-alpha/(2*nb_tests_total)) ) if nb_tests_total> 0
	replace power_second_share_bonf_10 = 0 if nb_tests_total==0

* This step runs the 10,000 iterations
forvalues i=2(1)10000 {

	display "`i' out of 10,000"

	qui {
	
		* Split sample, bonferonni corrections
		// compute the number of variables that are going to be tested on the training sample
		capture drop nb_tests_total
		g nb_tests_total = rbinomial(m0,alpha) + rbinomial(m - m0 , power_first_share) if power_first_share < 1 
		replace nb_tests_total = rbinomial(m0,alpha) + m - m0  if power_first_share == 1 
		replace power_second_share_bonf = (`i'-1)/`i'* power_second_share_bonf + ///
		1/`i'*[normal( effect_size * sqrt((1-share)*n/4) - invnormal(1-alpha/(2*nb_tests_total))) ] if nb_tests_total > 0

		replace power_second_share_bonf = (`i'-1)/`i'* power_second_share_bonf if nb_tests_total == 0

		capture drop nb_tests_true
		g nb_tests_true = rbinomial(m0,alpha) 
		
		replace fwer_split_bonf = (`i'-1)/`i'* fwer_split_bonf + 1/`i'* [ 1 - (1-alpha/nb_tests_total)^(nb_tests_true)]  if nb_tests_total > 0
		replace fwer_split_bonf = (`i'-1)/`i'* fwer_split_bonf   if nb_tests_total == 0

		* Split sample, bonferonni corrections (10% threshold on the training sample)
		capture drop nb_tests_total
		g nb_tests_total = rbinomial(m0,2*alpha) + rbinomial(m - m0 , power_first_share_10) if power_first_share_10 < 1 
		replace nb_tests_total = rbinomial(m0,alpha) + m - m0  if power_first_share_10 == 1 
		replace power_second_share_bonf_10 = (`i'-1)/`i'* power_second_share_bonf_10 + ///
		1/`i'*[normal( effect_size * sqrt((1-share)*n/4) - invnormal(1-alpha/(2*nb_tests_total))) ] if nb_tests_total > 0

		replace power_second_share_bonf_10 = (`i'-1)/`i'* power_second_share_bonf_10 if nb_tests_total == 0
		
	}
}

// This is equation (3) in the paper
g power_split_bonf = power_first_share * power_second_share_bonf
g power_split_bonf_10 = power_first_share_10 * power_second_share_bonf_10
save "data/results.dta", replace



// From now on we generate the various graphs
use "data/results.dta"  , clear 

*** FIGURES 1 (e=.2),2 (e=.1) and 3 (e=.3)
foreach e in  .1 .2 .3  {
	
	local b=100*`e'
	local sample effect_size==`e' & share ==.5 &  m==100 & non_true_ratio==1

	tw 	(line power_split_bonf n if `sample' , msize(vsmall) lpattern(solid) lcolor(gs4) legend(label(1 "Split sample"))) ///
	(line power_bonf_pap n if `sample' , msize(vsmall) lpattern("-") lcolor(gs4) legend(label(2 "Full sample ({&psi}=1) "))) ///
	(line power_bonf_pap_75 n if `sample', msize(vsmall) lpattern("-.") lcolor(gs6) legend(label(3 "Full sample ({&psi}=.75)"))) ///
	(line power_bonf_pap_50 n if `sample', msize(vsmall) lpattern("-..") lcolor(gs8) legend(label(4 "Full sample ({&psi}=.50)"))) ///
	(line power_bonf_pap_25 n if `sample', msize(vsmall) lpattern("-...") lcolor(gs10) legend(label(5 "Full sample ({&psi}=.25)")) ///
	xtitle("Sample Size [Effect Size: `e']") ytitle("Power") name(power`b' , replace) )
	graph export "output/power_psi_`b'.pdf", as(pdf) replace
		
}


**** FIGURE 4
local sample share ==.5 &  m==100 & non_true_ratio==1
g ratio = power_split_bonf / power_bonf_pap 

	tw (line ratio n if effect_size==.1  & `sample' , msize(vsmall) lpattern(solid) lcolor(gs9) legend(label(1 "Effect size .1"))   ) ///
	(line ratio n if effect_size==.2   & `sample' , msize(vsmall) lpattern(longdash) lcolor(gs9) legend(label(2 "Effect size .2"))) ///
	(line ratio n if effect_size==.3   & `sample'  , msize(vsmall) lpattern(shortdash) lcolor(gs9)  legend(label(3 "Effect size .3")) ///
	xtitle("Sample Size") ytitle("{&psi}*") name( learning , replace) )
	graph export "output/learning.pdf", as(pdf) replace

drop ratio

*** FIGURE 5
	local sample effect_size==.2 & share==.5 
	tw ///
	(line power_split_bonf n if `sample' & m==10 & non_true_ratio==10, msize(vsmall) lpattern("_.") lcolor(gs9)  legend(label(1 "m=10 & m0=9"))) ///
	(line power_split_bonf n if `sample' & m==100 & non_true_ratio==1, msize(vsmall) lpattern(longdash) lcolor(gs9) legend(label(2 "m=100 & m0=99"))) ///
	(line power_split_bonf n if `sample' & m==100 & non_true_ratio==10, msize(vsmall) lpattern(shortdash) lcolor(gs9) legend(label(3 "m=100 & m0=90"))) ///
	(line power_split_bonf n if `sample' & m==1000 & non_true_ratio==1, msize(vsmall) lpattern("-.") lcolor(gs9) legend(label(4 "m=1000 & m0=990"))) ///
	(line power_split_bonf n if `sample' & m==1000 & non_true_ratio==10, msize(vsmall) lpattern("-..") lcolor(gs9)legend(label(5 "m=1000  & m0=900")) ///
	xtitle("Sample Size [Effect Size: .2]") ytitle("Power")  )
	graph export "output/power_nb_var.pdf", as(pdf) replace

*** FIGURE A.1
	local sample effect_size==.2 &  m==100 & non_true_ratio==1 
	tw ///
	(line power_split_bonf n if `sample' & share ==.3 , msize(vsmall) lpattern(longdash) lcolor(gs9) legend(label(1 "Split: 30/70"))) ///
	(line power_split_bonf n if `sample' & share ==.5 , msize(vsmall) lpattern(solid) lcolor(gs9) legend(label(2 "Split: 50/50"))) ///
	(line power_split_bonf n if `sample' & share ==.7 , msize(vsmall) lpattern("-.") lcolor(gs9) legend(label(3 "Split: 70/30")) ///
	xtitle("Sample Size [Effect Size: .2]") ytitle("Power")  )
	graph export "output/power_share.pdf", as(pdf) replace
	
*** FIGURE A.2
	local sample share==.5 &  m==100 & non_true_ratio==1
	tw (line power_split_bonf n  if effect_size==.1 & `sample' , msize(vsmall) lpattern("-.") lcolor(gs12) legend(label(1 "DR: 5% (Effect size: .1)"))   ) ///
	(line power_split_bonf_10 n  if effect_size==.1 & `sample'  , msize(vsmall) lcolor(gs12)  legend(label(2 "DR: 10% (Effect size: .1)"))   ) ///
	(line power_split_bonf n  if effect_size==.2 & `sample'  , msize(vsmall) lpattern("-.") lcolor(gs9) legend(label(3 "DR: 5% (Effect size: .2)"))   ) ///
	(line power_split_bonf_10 n  if effect_size==.2 & `sample'  , msize(vsmall) lcolor(gs9)  legend(label(4 "DR: 10% (Effect size: .2)"))   ) ///
	(line power_split_bonf n  if effect_size==.3 & `sample'  , msize(vsmall) lpattern("-.") lcolor(gs6) legend(label(5 "DR: 5% (Effect size: .3)"))   ) ///
	(line power_split_bonf_10 n if  effect_size==.3 & `sample'  , msize(vsmall) lcolor(gs6) legend(label(6 "DR: 10% (Effect size: .3)")) ///
	xtitle("Sample Size") ytitle("Power") name(power`b' , replace) )
	graph export "output/power_decision_rule.pdf", as(pdf) replace	
	
** Generate TABLE 1

keep if effect_size==.2 & share==.5
collapse (mean) fwer_bonf  fwer_split_bonf  , by(m m0)
format fwer* %9.3f

foreach X in m m0   {
	tostring `X'  , replace force format("%9.0f")

}

foreach X in  fwer_bonf  fwer_split_bonf    {
	tostring `X'  , replace force format("%9.3f")

}

logout  , save(output/fwer_table) clear tex replace dec(3)



erase "data/main_frame.dta" 

