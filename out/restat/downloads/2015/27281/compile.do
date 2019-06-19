//setup
   clear all
   set matsize 4000
   args SEED REPS TYPE
   capture cd "D:/DATA.IDB/Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
     if _rc==0 global cd = "D:/DATA.IDB/Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
   capture cd "D:/Dropbox/My Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
     if _rc==0 global cd = "D:/Dropbox/My Dropbox/1.Research/2.Methods/BDM/BDM2012/code/"
   capture cd "/accounts/fac/jmccrary/research/BDM2012/code/"
     if _rc==0 global cd = "/accounts/fac/jmccrary/research/BDM2012/code/"
   global dir = "$cd/"
   global server = "/accounts/fac/jmccrary/research/BDM2012/code/"

// Move files into a new directory
   forvalues j = 1(1)50{
    foreach type in frolich frolich_est frolich001 frolich_est001 nsw misspec{
      !mkdir  $server/SIMS`type'/
      !mv -f  $server/sim`type'_`j'.dta $server/SIMS`type'/
      !mv -f  $server/sim`type'_`j'*.log $server/SIMS`type'/
	 }
   }
  
// Compile Simulations
   local estimators = "nn1_X nn2_X nn3_X nn4_X bcm1_X bcm2_X bcm3_X bcm4_X nn1_pX nn2_pX nn3_pX nn4_pX bcm1_pX bcm2_pX bcm3_pX bcm4_pX llr ipw1 ipw2 gpe"
   //Frolich based DGPs
   foreach type in frolich frolich_est frolich001 frolich_est001{
    forvalues i = 1(1)50{
   	 if `i'==1 use "$dir/SIMS`type'/sim`type'_`i'.dta", clear
	 if `i'>1  capture append using "$dir/SIMS`type'/sim`type'_`i'.dta"
	  }
	  bysort  design: gen rep = _n
	  reshape long `estimators', i(design rep) j(curve) string
	  replace curve = regexr(curve,"_y","")
	  destring curve, replace
	  gen truth = 0
	  drop if rep>10000
	  replace gpe = . if gpe<-9999
	  save "$dir/SIMS`type'/sim`type'.dta", replace
     }
	  
//NSW based DGPs
	  forvalues i = 1(1)50{
		if `i'==1 use "$dir/SIMSnsw/simnsw_`i'.dta", clear
		if `i'>1  capture append using "$dir/SIMSnsw/simnsw_`i'.dta"
	  }
	  bysort overlap: gen rep = _n
	  reshape long `estimators', i(rep overlap) j(curve) string
	  drop curve 
	  gen     truth = 2.334351 if overlap==1
	  replace truth = 0.734492 if overlap==5 
	  drop if rep>10000
	  replace gpe = . if gpe<-9999
	  save "$dir/SIMSnsw/simnsw.dta", replace
	  
   //Misspecified models
	forvalues i = 1(1)50{
		if `i'==1 use "$dir/SIMSmisspec/simmisspec_`i'.dta", clear
		if `i'>1  capture append using "$dir/SIMSmisspec/simmisspec_`i'.dta"
	  }
	bysort wiggle: gen rep = _n
	reshape long `estimators', i(wiggle rep) j(row) string
	gen row2 = regexr(row,"_y1_","")
	gen pscore_model = "True Index" if substr(row2,1,1)=="1"
	replace pscore_model = "Interactions" if substr(row2,1,1)=="2"
	replace pscore_model = "Linear" if substr(row2,1,1)=="3"
	replace pscore_model = "Linear+Interactions" if substr(row2,1,1)=="4"
	gen biasadj_model    = "True Index" if substr(row2,3,1)=="1"
	replace biasadj_model = "Interactions" if substr(row2,3,1)=="2"
	replace biasadj_model = "Linear" if substr(row2,3,1)=="3"
	replace biasadj_model = "Linear+Interactions" if substr(row2,3,1)=="4"
	gen truth = 1
	replace gpe = . if gpe<-9999
	order pscore_model biasadj_model
	drop row row2
	save "$dir/SIMSmisspec/simmisspec.dta", replace

