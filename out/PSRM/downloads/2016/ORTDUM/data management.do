**************************************************************************************************************************
** Brother or Burden? The Effect of Religious Primes and Economic Cost Information 
* on Support for Syrian Refugees in Turkey 

** Data management commands 
** If you have any questions about replication materials, please contact 
* the authors at el2666@columbia.edu and ks2481@columbia.edu 
** We used Stata 12.1
** For certain versions of Stata you nay need to install the center.ado files,
* one can do so by typing 'findit center.ado' and running the installation"


use "raw data.dta"

** DATA MANAGEMENT **
clear all

* Treatment variables 

generate treatment = surveytype

generate control = 1 if surveytype == 1
replace control = 0 if control ==.

generate treatment_Sunni = 1 if surveytype == 2
replace treatment_Sunni =0 if surveytype ==1

generate treatment_Muslim = 1 if surveytype ==3
replace treatment_Muslim =0 if surveytype ==1

generate treatment_Cost = 1 if surveytype ==4
replace treatment_Cost =0 if surveytype ==1

generate treatment_Sunni_Cost = 1 if surveytype ==5
replace treatment_Sunni_Cost =0 if surveytype ==1

generate treatment_Muslim_Cost = 1 if surveytype ==6
replace treatment_Muslim_Cost =0 if surveytype ==1


*** Interaction Effects *** 

generate treatment0 = 1 if surveytype == 1
replace treatment0 = 0 if treatment0 == .

generate treatment1 = 1 if surveytype == 2
replace treatment1 = 1 if surveytype == 5
replace treatment1 = 0 if treatment1 == .

generate treatment2 = 1 if surveytype == 3
replace treatment2 = 1 if surveytype == 6
replace treatment2 = 0 if treatment2 == .

generate treatment3 = 1 if surveytype == 4
replace treatment3 = 1 if surveytype == 5
replace treatment3 = 1 if surveytype == 6
replace treatment3 = 0 if treatment3 == .

gen t1_t3 = treatment1*treatment3
gen t2_t3 = treatment2*treatment3




*** Outcomes * 


* Should Stay  

generate shouldstay = 1 if staygo == "1"
replace shouldstay = 0 if staygo == "2"

* spending 

generate spend_ref = 1 if spending == 1
replace spend_ref = 2 if spending == 2
replace spend_ref = 3 if spending == 3

replace spend_ref = . if spending == 4



* trust 

generate trust_ref = 1 if trust == "3"
replace trust_ref = 2 if trust == "2"
replace trust_ref = 3 if trust == "1"
replace trust_ref = . if trust == "4"

* tolerate refugees in the neighborhood 

generate neighborhood_ref = 1 if neighborhood == "2"
replace neighborhood_ref = 2 if neighborhood == "3"
replace neighborhood_ref = 3 if neighborhood == "1"



***** GENERAL INDEX OF SUPPORT ****



cap program drop genindex
program genindex
	syntax varlist [aw] , nv(string)
	qui {
	// Standardize variable
		center `varlist' , pre(z_) st
		
	// #1-c Anderson ('08) wgt'd by Var-Cov mat, 0/1 at median: A
		tempname R K T A
		mat accum `R' = `varlist' , nocons dev //X'X
		mat `R' = syminv(`R'/r(N)) // 1/N(X'X)^{-1}
		mat `K' = J(colsof(`R') , 1 , 1) // K is a Kx1 matrix with of 1s

		local c = 1
		while `c' <= colsof(`R') {  //run loop K times
			mat `T' = `R'[`c' , 1..colsof(`R')] // T = cth row of R
			mat `A' = `T'*`K' // multiply each row of R(1xK+1) by K(1X3)
			global wgt`c' = `A'[1 , 1] //set global c = cth element of R
			local ++c
			}
		
		tempvar samp1 outp1
		gen `samp1' = 0
		gen `outp1' = 0
		local c = 1
		foreach z in `varlist' {
			replace `samp1' = `samp1' + $wgt`c'
			replace `outp1' = z_`z'*($wgt`c') + `outp1'
			local ++c
			}

		replace `outp1' = `outp1'/`samp1'
		rename `samp1' n_`nv'
		rename `outp1' `nv'
		
		drop z_*
		macro drop _all
		}	
end

genindex shouldstay spend_ref trust_ref neighborhood_ref donation, nv(support_general)



******* Covariates ********
***************************

generate income_real = real(income)

generate religiosity = real(prayers)

generate religiosity_dummy = 1 if religiosity == 3 
replace religiosity_dummy =0 if religiosity == 2
replace religiosity_dummy =0 if religiosity == 1

generate sharia = 4 if law == "1"
replace sharia = 3 if law == "2"
replace sharia = 2 if law == "4"
replace sharia = 1 if law == "3" 

generate unemployed = 1 if employment == "2"
replace unemployed = 0 if employment == "1"
replace unemployed = 0 if employment == "3"

generate retired = 1 if employment == "3"
replace retired = 0 if employment == "1"
replace retired = 0 if employment == "2"

generate finance_situation = 1 if finincialsituation == "5"
replace finance_situation = 2 if finincialsituation == "4"
replace finance_situation = 3 if finincialsituation == "3"
replace finance_situation = 4 if finincialsituation == "2"
replace finance_situation = 5 if finincialsituation == "1"

generate contact_ref = 1 if contact == "3" 
replace contact_ref = 2 if contact == "2" 
replace contact_ref = 3 if contact == "1" 


generate contact_dummy = 0 if contact_ref == 1 | contact_ref == 2
replace contact_dummy = 1 if contact_ref == 3


generate Gaziantep = 1 if city == "gaziantep"
replace Gaziantep = 1 if city =="Gaziantep"
replace Gaziantep = 0 if Gaziantep ==.

generate Fatih = 1 if district == "fatih"
replace Fatih = 0 if Fatih ==. 

generate Bagcilar = 1 if district == "bagcilar" 
replace Bagcilar = 0 if Bagcilar ==. 

generate Besiktas =1 if district=="besiktas"
replace Besiktas = 0 if Besiktas ==.

generate friday = 1 if day == "Friday"
replace friday =1 if day == "Friday  "
replace friday = 0 if friday ==.


save "/Users/egorlazarev/Dropbox/Research/Turkey 2013 Project/Paper/PSRM/FINAL/REPLICATION FILES/final data.dta
> "


