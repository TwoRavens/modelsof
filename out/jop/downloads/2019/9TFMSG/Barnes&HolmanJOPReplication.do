 clear
 set more off
 ******************************************************************************************
 ******************************************************************************************
 ********* 					replication code for Barnes & Holman 				***********
 ********* 	Gender Quotas, Women's Representation, and Legislative Diversity	***********
 ********* 								March 2019				 				***********
 ******************************************************************************************
 ******************************************************************************************
 
 ***** set working directory here with dataset in the folder **** 
 
 *** install clarify if you have not already done so **** 

clear

 
 use "Barnes&HolmanJOPReplication.dta"  
 
 

 ****************************
//Table 1: Results 
 eststo clear
//ClassPublic


eststo: glm prof_diversity  female quotayear   logdm  senate unemployment  gdi    , cluster(prov_chamber) 
eststo: glm diversity_person  female quotayear   logdm senate unemployment  gdi    , cluster(prov_chamber)  

eststo: glm prof_diversity_f  female quotayear   logdm senate unemployment  gdi    , cluster(prov_chamber) 
eststo: glm diversity_person_f  female quotayear   logdm  senate unemployment  gdi     , cluster(prov_chamber) 

eststo: glm prof_diversity_m  female quotayear  logdm  senate unemployment  gdi    , cluster(prov_chamber) 
eststo: glm diversity_person_m  female quotayear   logdm  senate unemployment  gdi    , cluster(prov_chamber)  

 # delimit ;
esttab using Table1Results.rtf, nogap se b(%9.3f) starlevels(* .10 ** .05 *** .01) r2(%9.3f) 
	title("Table 1: Professional and Personal Diversity " )
	 label nonumbers
	//addnote("Dependent variable")//
	compress replace;
 #delimit cr 
 
 
	 
 
 
*** regression models for slope and r2 in Figure 2 **** 


	eststo clear 

	eststo all_prof_p: reg prof_diversity female
	eststo all_prof_q: reg prof_diversity quotayear 

	eststo f_prof_p: reg prof_diversity_f female
	eststo f_prof_q: reg prof_diversity_f quotayear 
	
	eststo m_prof_p: reg prof_diversity_m female
	eststo m_prof_q: reg prof_diversity_m quotayear 
	
	# delimit ;
	esttab using Figure2_slope_r2_professional.rtf, nogap se b(%9.3f) starlevels(* .10 ** .05 *** .01 ) r2(%9.3f) 
		title("Bivariate results: Professional Diversity" )
		label nonumbers
		addnote("Dependent variable")
		compress replace;
	 #delimit cr

	eststo clear 
	
	
	eststo all_personal_p: reg diversity_person female
	eststo all_personal_q: reg diversity_person quotayear 

	
	eststo f_personal_p: reg diversity_person_f female
	eststo f_personal_q: reg diversity_person_f quotayear 
	
	eststo m_personal_p: reg diversity_person_m female
	eststo m_personal_q: reg diversity_person_m quotayear 
	
	
	

	# delimit ;
	esttab using Figure2_slope_r2_personal.rtf, nogap se b(%9.3f) starlevels(* .10 ** .05 *** .01 ) r2(%9.3f) 
		title("Bivariate results: Personal Diversity" )
		label nonumbers
		addnote("Dependent variable")
		compress replace;
	 #delimit cr
	 
**** Figure 2: Chamber-wide Professional and Personal Diversity Indexes by Percent Women and Years Since Quota ********** 

	twoway (scatter prof_diversity female, msymbol(diamond)) || lfit prof_diversity female, ///
	xtitle("% Women", size(large)) ytitle("Professional", size(large))   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid) ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid) legend(off) title()  ///
	caption("b=.331**(.089), r=.322", ring(-1) pos(6) size(large))
	graph save Graph "profallp.gph", replace
	
	
	twoway (scatter prof_diversity quotayear, msymbol(diamond)) || lfit prof_diversity quotayear, ///
	xtitle("Quota years", size(large))  ytitle("Professional", size(large))  ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid) legend(off) title() ///
	caption("b=.006*(.002), r=.237", ring(-1) pos(6) size(large))
	graph save Graph "profallq.gph", replace
	

	twoway (scatter diversity_person female, msymbol(diamond)) || lfit diversity_person female, ///
	xtitle("% Women", size(large)) ytitle("Personal", size(large))   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid)  legend(off) title() ///
	caption("b=.02(.01), r=.041", ring(-1) pos(6) size(large))
	graph save Graph "personalallp.gph", replace
	
	
	twoway (scatter diversity_person quotayear, msymbol(diamond)) || lfit diversity_person quotayear, ///
	xtitle("Quota years", size(large))  ytitle("Personal", size(large))  ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid)  legend(off) title()  ///
	caption("b=.009***(.002), r=.318", ring(-1) pos(6) size(large))
	graph save Graph "personalallq.gph", replace
	
	graph combine "profallp" "profallq", col(1) title("   Professional Diversity") graphregion(margin(tiny))
	graph save professional_all.gph, replace
	
	
	graph combine "personalallp" "personalallq", col(1) title("   Personal Diversity") graphregion(margin(tiny))
	graph save personal_all.gph, replace
	
	
	graph combine "professional_all" "personal_all", col(2) graphregion(margin(tiny)) 
	graph save "Figure 2.gph", replace
	graph export "Figure 2.png", replace width(1800)
	
	
***************** Figure 3: Chamber wide diversity ***************************


 ///Figures for Diversity among CHAMBER 
********FIGURES FOR % WOMEN**************

clear


use  "Barnes&HolmanJOPReplication.dta"
replace female = female*100

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm prof_diversity  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 


///Create Predicted Probailittes for first model//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =5 
local b =1
	#delimit ;
	while `a' <= 45{;
         

predictnl prob   = ((_b[_cons] + _b[female]* `a'  + _b[quotayear]* 12.6  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 5;


};

#delimit cr


	
//Figure % Women Increase
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
  			  			
            xtitle("% Women", size(vlarge))
            ytitle("Professional", size(vlarge)) 
			ylab(.20(.1).5)
			xlab(5(10)45)
			ylab(, nogrid  labsize(vlarge)) 
			xlab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			legend(off)
			name(pwomen_prof, replace)
			scheme (s2mono)	
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 



capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm diversity_person  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 


///Create Predicted Probabilities //
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =5 
local b =1
	#delimit ;
	while `a' <= 45{;
         

predictnl prob   = ((_b[_cons] + _b[female]* `a'  + _b[quotayear]* 12.6  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 5;


};

#delimit cr


	
//Figure % Women Increase
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
  			  			
            xtitle("% Women", size(vlarge))
            ytitle("Personal", size(vlarge)) 
			ylab(.20(.1).5)
			xlab(5(10)45)
			xlab(, nogrid  labsize(vlarge)) 
			ylab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			scheme (s2mono)
			legend(off)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white))
			name(pwomen_person, replace);
 			#delimit cr
			 			 
			 
 
 **********QUOTA YEARS***********
 
 

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm prof_diversity  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 


///Create Predicted Probabilities//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =0 
local b =1
	#delimit ;
	while `a' <= 20{;
         

predictnl prob   = ((_b[_cons] + _b[female]* 27 + _b[quotayear]* `a'  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 2;


};

#delimit cr


	
//Figure Quota Years
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
 
            xtitle("Quota Years", size(vlarge))
            ytitle("Professional", size(vlarge)) 
			ylab(.1(.1).5)
			xlab(, nogrid  labsize(vlarge)) 
			ylab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			legend(off)
            name(quota_prof, replace)
			scheme (s2mono)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 

			 

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm diversity_person  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 


///Create Predicted Probabilities //
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =0 
local b =1
	#delimit ;
	while `a' <= 20{;
         

predictnl prob   = ((_b[_cons] + _b[female]* 27 + _b[quotayear]* `a'  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 2;


};

#delimit cr


	//Quota Years 
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
 
            xtitle("Quota Years", size(vlarge))
            ytitle("Personal", size(vlarge)) 
			ylab(.1(.1).5)
			ylab(, nogrid  labsize(vlarge))
			xlab(, nogrid  labsize(vlarge))
            title(" ", size(smallmedium) color(black))
			scheme (s2mono)
			legend(off)
            name(quota_person, replace)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 
			 			 

			 
			 			 
# delimit ;			 
 graph combine  pwomen_prof quota_prof , col(1)
 graphregion(fcolor(white) lcolor (white) icolor(white))
 plotregion(fcolor(white) lcolor (white) icolor(white))
 name(prof_combined, replace)
 title("  Professional Diversity")
 xsize(12);

 	 			 
# delimit ;			 
 graph combine   pwomen_person quota_person, col(1)
 graphregion(fcolor(white) lcolor (white) icolor(white))
 plotregion(fcolor(white) lcolor (white) icolor(white))
 name(personal_combined, replace)
 title("  Personal Diversity")
 xsize(12);

    # delimit ;	
graph combine prof_combined personal_combined, col(2)
 graphregion(fcolor(white) lcolor (white) icolor(white) margin(vsmall))
 plotregion(fcolor(white) lcolor (white) icolor(white))
  name(chamber, replace);
   #delimit cr
   
   
	graph save "Figure 3.gph", replace
	graph export "Figure 3.png", replace width(1800)
   
********************* Figure 4: Professional and Personal Diversity Indexes and Covariance with Percent Women and Quota years ***** 
clear

use  "Barnes&HolmanJOPReplication.dta"

	twoway (scatter prof_diversity_f female, msymbol(circle)) || lfit prof_diversity_f female, ///
	xtitle("% women", size(large)) ytitle("Professional Diversity Index", size(large))   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%", nogrid)  legend(off) graphregion(margin(tiny)) ///
	caption("b=.62***(.17), r=.31", ring(-1) pos(6) size(large))
	graph save Graph "proffp.gph", replace
	
	
	twoway (scatter prof_diversity_f quotayear, msymbol(circle)) || lfit prof_diversity_f quotayear, ///
	xtitle("Quota years", size(large))  ytitle("")  ///
	ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" , nogrid)  legend(off) title() graphregion(margin(tiny)) ///
	caption("b=.02***(.00), r=.56", ring(-1) pos(6) size(large))
	graph save Graph "proffq.gph", replace
	

	twoway (scatter diversity_person_f female, msymbol(circle)) || lfit diversity_person_f female, ///
	xtitle("% women", size(large)) ytitle("Personal Diversity Index", size(large))   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" , nogrid)  legend(off) title() graphregion(margin(tiny)) ///
	caption("b=.67**(.20), r=.26", ring(-1) pos(6) size(large))
	graph save Graph "personalfp.gph", replace
	
	
	twoway (scatter diversity_person_f quotayear, msymbol(circle)) || lfit diversity_person_f quotayear, ///
	xtitle("Quota years", size(large))  ytitle("")  ///
	ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%", nogrid)  legend(off) title() graphregion(margin(tiny)) ///
	caption("b=.02***(.00), r=.51", ring(-1) pos(6) size(large))
	graph save Graph "personalfq.gph", replace
	
			
	graph combine "proffp" "proffq", row(1) title(Professional Diversity) graphregion(margin(tiny))
	graph save professional_f.gph, replace
	
	
	graph combine "personalfp" "personalfq", row(1) title(Personal Diversity) graphregion(margin(tiny))
	graph save personal_f.gph, replace
	
	
	graph combine "professional_f" "personal_f", row(1) ysize(3.25) graphregion(margin(vsmall)) ///
	title(Women, size(large))
	graph save "Figure 4A.gph", replace
	graph export "Figure 4A.png", replace width(1800)

	twoway (scatter prof_diversity_m female, msymbol(diamond)) || lfit prof_diversity_m female, ///
	xtitle("% women", size(large)) ytitle("Professional Diversity Index", size(large))   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid) ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid) legend(off) title() graphregion(margin(tiny)) ///
	caption("b=.19(.12), r=.08", ring(-1) pos(6) size(large))
	graph save Graph "profmp.gph", replace
	
	
	twoway (scatter prof_diversity_m quotayear, msymbol(diamond)) || lfit prof_diversity_m quotayear, ///
	xtitle("Quota years", size(large))  ytitle("")  ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid) legend(off) title() graphregion(margin(tiny)) ///
	caption("b=.01*(.00), r=.14", ring(-1) pos(6) size(large))
	graph save Graph "profmq.gph", replace
	

	twoway (scatter diversity_person_m female, msymbol(diamond)) || lfit diversity_person_m female, ///
	xtitle("% women", size(large)) ytitle("Personal Diversity Index", size(large))   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid)  legend(off) title() graphregion(margin(tiny)) ///
	caption("b=.01(.37), r=.00", ring(-1) pos(6) size(large))
	graph save Graph "personalmp.gph", replace
	
	
	twoway (scatter diversity_person_m quotayear, msymbol(diamond)) || lfit diversity_person_m quotayear, ///
	xtitle("Quota years", size(large))  ytitle("")  ///
	ylabel(.1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%", nogrid)  legend(off) title() graphregion(margin(tiny)) ///
	caption("b=.01*(.00), r=.17", ring(-1) pos(6) size(large))
	graph save Graph "personalmq.gph", replace
	
			
	graph combine "profmp" "profmq", row(1) title(Professional Diversity) graphregion(margin(tiny))
	graph save professional_m.gph, replace
	
	
	graph combine "personalmp" "personalmq", row(1) title(Personal Diversity) graphregion(margin(tiny))
	graph save personal_m.gph, replace
	
	
	graph combine "professional_m" "personal_m", row(1) ysize(3.25) graphregion(margin(vsmall)) ///
	title(Men, size(large))
	graph save "Figure 4B.gph", replace
	graph export "Figure 4B.png", replace width(1800)
	
		
	
	graph combine "Figure 4A.gph" "Figure 4B.gph", row(2) 
	graph save "Figure4.gph", replace
	graph export "Figure 4.png", replace width(1800)


   
 ******************** Figure 5: Men's and women's diversity ************************
 
clear

use  "Barnes&HolmanJOPReplication.dta"	
	
	
///Figures for Diversity among Women 
********FIGURES FOR % WOMEN**************
clear


use  "Barnes&HolmanJOPReplication.dta"

replace female = female*100

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm prof_diversity_f  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 



///Create Predicted Probabilities for first model//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =5 
local b =1
	#delimit ;
	while `a' <= 45{;
         

predictnl prob   = ((_b[_cons] + _b[female]* `a'  + _b[quotayear]* 12.6  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 5;


};

#delimit cr


	
//Figure % Women Increase
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
  			  			
            xtitle("% Women", size(vlarge))
            ytitle("Professional", size(vlarge)) 
			ylab(.1(.1).5)
			xlab(5(10)45)
			ylab(, nogrid  labsize(vlarge)) 
			xlab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			legend(off)
			name(pwomen_prof, replace)
			scheme (s2mono)	
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 



capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm diversity_person_f  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 

capture drop lowCI hiCI fem_mean xaxis
///Create Predicted Probabilities for first model//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =5 
local b =1
	#delimit ;
	while `a' <= 45{;
         

predictnl prob   = ((_b[_cons] + _b[female]* `a'  + _b[quotayear]* 12.6  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 5;


};

#delimit cr


	
//Figure % Women Increase
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
  			  			
            xtitle("% Women", size(vlarge))
            ytitle("Personal", size(vlarge)) 
			ylab(.1(.1).5)
			xlab(5(10)45)
			xlab(, nogrid  labsize(vlarge)) 
			ylab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			scheme (s2mono)
			legend(off)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white))
			name(pwomen_person, replace);
 			#delimit cr
			 			 
			 
 
 **********QUOTA YEARS***********
 
 

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm prof_diversity_f  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 

capture drop lowCI hiCI fem_mean xaxis
///Create Predicted Probabilities for first model//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =0 
local b =1
	#delimit ;
	while `a' <= 20{;
         

predictnl prob   = ((_b[_cons] + _b[female]* 27 + _b[quotayear]* `a'  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 2;


};

#delimit cr


	
//Figure Quota Years
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
 
            xtitle("Quota Years", size(vlarge))
            ytitle("Professional", size(vlarge)) 
			ylab(.1(.1).5)
			xlab(, nogrid  labsize(vlarge)) 
			ylab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			legend(off)
            name(quota_prof, replace)
			scheme (s2mono)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 

			 

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm diversity_person_f  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 


///Create Predicted Probabilities for first model//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =0 
local b =1
	#delimit ;
	while `a' <= 20{;
         

predictnl prob   = ((_b[_cons] + _b[female]* 27 + _b[quotayear]* `a'  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 2;


};

#delimit cr


	//Quota Years 
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
 
            xtitle("Quota Years", size(vlarge))
            ytitle("Personal", size(vlarge)) 
			ylab(.1(.1).5)
			ylab(, nogrid  labsize(vlarge))
			xlab(, nogrid  labsize(vlarge))
            title(" ", size(smallmedium) color(black))
			scheme (s2mono)
			legend(off)
            name(quota_person, replace)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 
			 			 
# delimit ;			 
 graph combine  pwomen_prof quota_prof, col(1)
 graphregion(fcolor(white) lcolor (white) icolor(white))
 plotregion(fcolor(white) lcolor (white) icolor(white))
 name(female_prof_combined, replace)
 title("Women's Professional Diversity", size(vlarge) color(black))
 xsize(12);

 	 			 
# delimit ;			 
 graph combine   pwomen_person quota_person, col(1)
 graphregion(fcolor(white) lcolor (white) icolor(white))
 plotregion(fcolor(white) lcolor (white) icolor(white))
 name(female_personal_combined, replace)
 title("Women's Personal Diversity", size(vlarge) color(black))
 xsize(12);

  #delimit cr

  # delimit ;	
graph combine female_prof_combined female_personal_combined, col(2)
 graphregion(fcolor(white) lcolor (white) icolor(white) margin(vsmall))
 plotregion(fcolor(white) lcolor (white) icolor(white))
  name(women, replace);
   #delimit cr


	graph save "Figure 5A.gph", replace
	graph export "Figure 5A.png", replace width(1800)
 
set more off
///Figures for Diversity among Men
********FIGURES FOR % WOMEN**************


capture drop lowCI hiCI fem_mean xaxis
set more off
//eststo: glm prof_diversity_m  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 
eststo: glm prof_diversity_m  female quotayear senate  logdm  unemployment  gdi  if chamber_year!=26 & chamber_year!=22 & chamber_year!=1 & chamber_year!=6  & chamber_year!=16   , cluster(prov_chamber) 

set more off

///Create Predicted Probabilities for first model//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =5 
local b =1
	#delimit ;
	while `a' <= 45{;
         

predictnl prob   = ((_b[_cons] + _b[female]* `a'  + _b[quotayear]* 12.6  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 5;


};

#delimit cr


	
//Figure % Women Increase
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
  			  			
            xtitle("% Women", size(vlarge))
            ytitle("Professional", size(vlarge)) 
			ylab(.1(.1).5)
			xlab(5(10)45)
			ylab(, nogrid  labsize(vlarge)) 
			xlab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			legend(off)
			name(pwomen_prof, replace)
			scheme (s2mono)	
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 



capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm diversity_person_m  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 

set more off

///Create Predicted Probabilities//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =5 
local b =1
	#delimit ;
	while `a' <= 45{;
         

predictnl prob   = ((_b[_cons] + _b[female]* `a'  + _b[quotayear]* 12.6  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 5;


};

#delimit cr


	
//Figure % Women Increase
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
  			  			
            xtitle("% Women", size(vlarge))
            ytitle("Personal", size(vlarge)) 
			ylab(.1(.1).5)
			xlab(5(10)45)
			xlab(, nogrid  labsize(vlarge)) 
			ylab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			scheme (s2mono)
			legend(off)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white))
			name(pwomen_person, replace);
 			#delimit cr
			 			 
			 
 
 **********QUOTA YEARS***********
 
 

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm prof_diversity_m  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 


///Create Predicted Probabilities//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =0 
local b =1
	#delimit ;
	while `a' <= 20{;
         

predictnl prob   = ((_b[_cons] + _b[female]* 27 + _b[quotayear]* `a'  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 2;


};

#delimit cr


	
//Figure Quota Years
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
 
            xtitle("Quota Years", size(vlarge))
            ytitle("Professional", size(vlarge)) 
			ylab(.1(.1).5)
			xlab(, nogrid  labsize(vlarge)) 
			ylab(, nogrid  labsize(vlarge)) 
            title(" ", size(smallmedium) color(black))
			legend(off)
            name(quota_prof, replace)
			scheme (s2mono)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 

			 

capture drop lowCI hiCI fem_mean xaxis
set more off
eststo: glm diversity_person_m  female quotayear senate  logdm  unemployment  gdi    ,cluster(prov_chamber) 


///Create Predicted Probabilities//
gen fem_mean=.
gen lowCI=.
gen hiCI=.
gen xaxis = . 


local a =0 
local b =1
	#delimit ;
	while `a' <= 20{;
         

predictnl prob   = ((_b[_cons] + _b[female]* 27 + _b[quotayear]* `a'  + _b[senate]* 0  + _b[logdm]*2.4 + _b[unemployment]*7.1  + _b[gdi]*.82 )), se(fem_se); 
replace fem_mean = prob in `b';
replace lowCI = fem_mean-( 1.645* fem_se) in `b';
replace hiCI = fem_mean+( 1.645* fem_se) in `b';
drop prob  fem_se;
replace xaxis=`a' in `b';
local b = `b' + 1;

local a = `a' + 2;


};

#delimit cr


	//Quota Years 
			 # delimit ;
twoway rarea lowCI hiCI xaxis, color(gs12) ||
 line fem_mean xaxis , color(black)  msize(vlarge) ||,
 
            xtitle("Quota Years", size(vlarge))
            ytitle("Personal", size(vlarge)) 
			ylab(.1(.1).5)
			ylab(, nogrid  labsize(vlarge))
			xlab(, nogrid  labsize(vlarge))
            title(" ", size(smallmedium) color(black))
			scheme (s2mono)
			legend(off)
            name(quota_person, replace)
            graphregion(fcolor(white) lcolor (white) icolor(white))
 			plotregion(fcolor(white) lcolor (white) icolor(white));
 			#delimit cr
			 
			 			 
# delimit ;			 
 graph combine  pwomen_prof quota_prof , col(1)
 graphregion(fcolor(white) lcolor (white) icolor(white))
 plotregion(fcolor(white) lcolor (white) icolor(white))
 name(male_prof_combined, replace)
 title("Men's Professional Diversity", size(vlarge) color(black))
 xsize(12);

 	 			 
# delimit ;			 
 graph combine   pwomen_person quota_person , col(1)
 graphregion(fcolor(white) lcolor (white) icolor(white))
 plotregion(fcolor(white) lcolor (white) icolor(white))
 name(male_personal_combined, replace)
 title("Men's Personal Diversity", size(vlarge) color(black))
 xsize(12);

 
   # delimit ;	
graph combine male_prof_combined male_personal_combined, col(2)
 graphregion(fcolor(white) lcolor (white) icolor(white) margin(vsmall))
 plotregion(fcolor(white) lcolor (white) icolor(white))
  name(men, replace);
   #delimit cr
   
   
 
	graph save "Figure 5B.gph", replace
	graph export "Figure 5B.png", replace width(1800)
 
   
     			 			 
  # delimit ;	
  graph combine women men, col(2)
  graphregion(fcolor(white) lcolor (white) icolor(white) margin(vsmall))
 plotregion(fcolor(white) lcolor (white) icolor(white))
  name(Figure3a_b, replace)
  xsize(8);
 #delimit cr

 
 
	graph save "Figure 5.gph", replace
	graph export "Figure 5.png", replace width(1800)
 
 
 ***********************************************************
 ***********************************************************
 ***********************************************************
 
 ****** APPENDIX FIGURES & TABLES **************************
 ***********************************************************
 
clear


use  "Barnes&HolmanJOPReplication.dta"




**** repeat bivariate analysis for Appendix Tables A3 and A4 ***

	eststo clear 

	eststo all_prof_p: reg prof_diversity female
	eststo all_prof_q: reg prof_diversity quotayear 

	eststo f_prof_p: reg prof_diversity_f female
	eststo f_prof_q: reg prof_diversity_f quotayear 
	
	eststo m_prof_p: reg prof_diversity_m female
	eststo m_prof_q: reg prof_diversity_m quotayear 
	
	# delimit ;
	esttab using TableA3.rtf, nogap se b(%9.3f) starlevels(* .10 ** .05 *** .01 ) r2(%9.3f) 
		title("Bivariate results: Professional Diversity" )
		label nonumbers
		addnote("Dependent variable")
		compress replace;
	 #delimit cr

	eststo clear 
	
	
	eststo all_personal_p: reg diversity_person female
	eststo all_personal_q: reg diversity_person quotayear 

	
	eststo f_personal_p: reg diversity_person_f female
	eststo f_personal_q: reg diversity_person_f quotayear 
	
	eststo m_personal_p: reg diversity_person_m female
	eststo m_personal_q: reg diversity_person_m quotayear 
	
	
	

	# delimit ;
	esttab using TableA4.rtf, nogap se b(%9.3f) starlevels(* .10 ** .05 *** .01 ) r2(%9.3f) 
		title("Bivariate results: Personal Diversity" )
		label nonumbers
		addnote("Dependent variable")
		compress replace;
	 #delimit cr
	
	
 ****************************
//Appendix Table A5: OLS
 eststo clear
//ClassPublic

eststo: reg prof_diversity  female quotayear   logdm  senate unemployment  gdi    , cluster(prov_chamber) 
eststo: reg diversity_person  female quotayear   logdm senate unemployment  gdi    , cluster(prov_chamber) 

eststo: reg prof_diversity_f  female quotayear   logdm senate unemployment  gdi    , cluster(prov_chamber) 
eststo: reg diversity_person_f  female quotayear   logdm  senate unemployment  gdi     , cluster(prov_chamber) 

eststo: reg prof_diversity_m  female quotayear  logdm  senate unemployment  gdi    , cluster(prov_chamber) 
eststo: reg diversity_person_m  female quotayear   logdm  senate unemployment  gdi    , cluster(prov_chamber)  


 # delimit ;
esttab using TableA5.rtf, nogap se b(%9.3f) starlevels(* .10 ** .05 *** .01) r2(%9.3f) 
	title("Table A5: Legislative Diversity: OLS " )
	 label
	//addnote("Dependent variable")//
	compress replace;
 #delimit cr 
 
 

***** Figure 1A Components of Chamber-Wide Professional Diversity and Covariance with Percent Women and Quota years   ***** 

	twoway (scatter s_private female, msymbol(square)) || lfit s_private female,  ///
	xtitle("Quota years") ytitle("% w private career")   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Private Career)
	graph save Graph "private_all.gph", replace
		
	
	twoway (scatter s_party female, msymbol(square)) || lfit s_party female, ///
	xtitle("% women") ytitle("% w party background") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Party Background)
	graph save Graph "party_all.gph", replace
	
	twoway (scatter s_public female, msymbol(square)) || lfit s_public female, ///
	xtitle("% women") ytitle("% w public career") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Public Career)
	graph save Graph "public_all.gph", replace	
	
	twoway (scatter s_cl_politician female, msymbol(square)) || lfit s_cl_politician female, ///
	xtitle("% women") ytitle("% w political career") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Politician)
	graph save Graph "political_all.gph", replace
	
	twoway (scatter s_cl_white female, msymbol(square)) || lfit s_cl_white female, ///
	xtitle("% women") ytitle("% w white collar career") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(White Collar)
	graph save Graph "white collar_all.gph", replace
		
	twoway (scatter s_cl_blue female, msymbol(square)) || lfit s_cl_blue female, ///
	xtitle("% women") ytitle("% w blue collar career") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Blue Collar)
	graph save Graph "blue collar_all.gph", replace
	
	
	graph combine "public_all" "private_all" "party_all" "blue collar_all" "white collar_all" "political_all", ///
	title(% Women)
	graph save FigureA1A.gph, replace
	graph export FigureA1A.png, replace width(1800)
	
	
	twoway (scatter s_private quotayear, msymbol(square_hollow)) || lfit s_private quotayear, ///
	xtitle("Quota years")  ytitle("% w private career")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Private Career)
	graph save Graph "private_allq.gph", replace
		
	twoway (scatter s_party quotayear, msymbol(square_hollow)) || lfit s_party quotayear, ///
	xtitle("Quota years")  ytitle("% w party background")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Party Background)
	graph save Graph "party_allq.gph", replace
	
	twoway (scatter s_public quotayear, msymbol(square_hollow)) || lfit s_public quotayear, ///
	xtitle("Quota years")  ytitle("% w public career")    ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Public Career)
	graph save Graph "public_allq.gph", replace
		
	twoway (scatter s_cl_politician quotayear, msymbol(square_hollow)) || lfit s_cl_politician quotayear, ///
	xtitle("Quota years")  ytitle("% w political career")    ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Politician)
	graph save Graph "political_allq.gph", replace
		
	twoway (scatter s_cl_white quotayear, msymbol(square_hollow)) || lfit s_cl_white quotayear, ///
	xtitle("Quota years")  ytitle("% w white collar career")    ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(White Collar)
	graph save Graph "white collar_allq.gph", replace
		
	twoway (scatter s_cl_blue quotayear, msymbol(square_hollow)) || lfit s_cl_blue quotayear, ///
	xtitle("Quota years") ytitle("% w blue collar career")    ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Blue Collar)
	graph save Graph "blue collar_allq.gph", replace
		
	
	graph combine "public_allq" "private_allq" "party_allq" "blue collar_allq" "white collar_allq" "political_allq", ///
	title("Quota Years") 
	graph save FigureA1B.gph, replace
	graph export FigureA1B.png, replace width(1800)
	
	
	
************ Figure A2: Components of Chamber-Wide Personal Diversity and Covariance with Percent Women and Quota years **** 

	twoway (scatter s_child female, msymbol(square)) || lfit s_child female, ///
	xtitle("% women") ytitle("% w children") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Children)
	graph save Graph "children_all.gph", replace
	
	twoway (scatter s_married female, msymbol(square)) || lfit s_married female, ///
	xtitle("% women") ytitle("% married")   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")  legend(off) title(Married)
	graph save Graph "married_allp.gph", replace
		

	twoway (scatter s_college female, msymbol(square)) || lfit s_college female, ///
	xtitle("% women") ytitle("% w college degree")   ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(College Education)
	graph save Graph "college_allp.gph", replace
		
		
	graph combine "children_all" "married_allp" "college_allp", row(1) ///
	title (% Women)
	graph save FigureA2A.gph, replace
	graph export FigureA2A.png, replace width(1800)
	
	twoway (scatter s_child quotayear, msymbol(square_hollow)) || lfit s_child quotayear, ///
	xtitle("Quota years") ytitle("% w children")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Children)
	graph save Graph "children_allq.gph", replace
		
	twoway (scatter s_married quotayear, msymbol(square_hollow)) || lfit s_married quotayear, ///
	xtitle("Quota years") ytitle("% married")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(Married)
	graph save Graph "married_allq.gph", replace
		
	twoway (scatter s_college quotayear, msymbol(square_hollow)) || lfit s_college quotayear, ///
	xtitle("Quota years") ytitle("% w college degree")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(College Education)
	graph save Graph "college_allq.gph", replace
	
	
	graph combine "children_allq" "married_allq" "college_allq", row(1) ///
	title (Quota years)
	graph save FigureA2B.gph, replace
	graph export FigureA2B.png, replace width(1800)
	
	graph combine "FigureA2A" "FigureA2B", col(1) 
	graph save FigureA2.gph, replace
	graph export FigureA2.png, replace width(1800)
	
	
******* Figure A3: Components of Women’s Professional Diversity and Covariance with Percent Women and Quota years

	twoway (scatter s_f_private female, msymbol(circle)) || lfit s_f_private female,  ///
	xtitle("% women") ytitle("% w private career")  ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Private Career)
	graph save Graph "private_f.gph", replace
		
	twoway (scatter s_f_party female, msymbol(circle)) || lfit s_f_party female,  ///
	xtitle("% women") ytitle("% w party background") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Party Background)
	graph save Graph "party_f.gph", replace
	
	twoway (scatter s_f_public female, msymbol(circle)) || lfit s_f_public female,  ///
	xtitle("% women") ytitle("% w public career")  ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Public Career)
	graph save Graph "public_f.gph", replace
	
	twoway (scatter s_cl_fpolitician female, msymbol(circle)) || lfit s_cl_fpolitician female,  ///
	xtitle("% women") ytitle("% politician")  ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Politician)
	graph save Graph "political_f.gph", replace
	
	twoway (scatter s_cl_fwhite female, msymbol(circle)) || lfit s_cl_fwhite female,  ///
	xtitle("% women") ytitle("% white collar")  ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(White Collar)
	graph save Graph "white collar_f.gph", replace
	
	twoway (scatter s_cl_fblue female, msymbol(circle)) || lfit s_cl_fblue female,  ///
	xtitle("% women") ytitle("% blue collar")  ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Blue Collar)
	graph save Graph "blue collar_f.gph", replace
	
	graph combine "public_f" "private_f" "party_f" "blue collar_f" "white collar_f" "political_f", ///
	title (% Women) 
	graph save FigureA3A.gph, replace
	graph export FigureA3A.png, replace width(1800)

	twoway (scatter s_f_private quotayear) || lfit s_f_private quotayear,  ///
	xtitle("Quota years") ytitle("% w private career")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Private Career)
	graph save Graph "private_fq.gph", replace
	
	twoway (scatter s_f_party quotayear) || lfit s_f_party quotayear,  ///
	xtitle("Quota years") ytitle("% w party background")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Party Background)
	graph save Graph "party_fq.gph", replace

	twoway (scatter s_f_public quotayear) || lfit s_f_public quotayear,  ///
	xtitle("Quota years") ytitle("% w public career")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Public Career)
	graph save Graph "public_fq.gph", replace
	
	twoway (scatter s_cl_fpolitician quotayear) || lfit s_cl_fpolitician quotayear,  ///
	xtitle("Quota years") ytitle("% politician") msymbol(circle) ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Politician)
	graph save Graph "political_fq.gph", replace

	twoway (scatter s_cl_fwhite quotayear) || lfit s_cl_fwhite quotayear,  ///
	xtitle("Quota years") ytitle("% white collar")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(White Collar)
	graph save Graph "white collar_fq.gph", replace	
		
	twoway (scatter s_cl_fblue quotayear) || lfit s_cl_fblue quotayear,  ///
	xtitle("Quota years") ytitle("% blue collar")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Blue Collar)
	graph save Graph "blue collar_fq.gph", replace

		
	graph combine "public_fq" "private_fq" "party_fq" "blue collar_fq" "white collar_fq" "political_fq", ///
	title (Quota Years) 
	graph save FigureA3B.gph, replace
	graph export FigureA3B.png, replace width(1800)


**** Figure A4: Components of Men’s Professional Diversity and Covariance with Percent Women and Quota years **** 

	twoway (scatter s_m_private female, msymbol(diamond)) || lfit s_m_private female,  ///
	xtitle("% women") ytitle("% w private career")  ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Private Career)
	graph save Graph "private_m.gph", replace
	
	twoway (scatter s_m_party female, msymbol(diamond)) || lfit s_m_party female,  ///
	xtitle("% women") ytitle("% with party background") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Party Background)
	graph save Graph "party_m.gph", replace
		
	twoway (scatter s_m_public female, msymbol(diamond)) || lfit s_m_public female,  ///
	xtitle("% women") ytitle("% w public career") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Public Career)
	graph save Graph "public_m.gph", replace
	
	twoway (scatter s_cl_mpolitician female, msymbol(diamond)) || lfit s_cl_mpolitician female,  ///
	xtitle("% women") ytitle("% politician") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Politician)
	graph save Graph "political_m.gph", replace
	
	twoway (scatter s_cl_mwhite female, msymbol(diamond)) || lfit s_cl_mwhite female,  ///
	xtitle("% women") ytitle("% white collar") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(White Collar)
	graph save Graph "white collar_m.gph", replace
		
	twoway (scatter s_cl_mblue female, msymbol(diamond)) || lfit s_cl_mblue female,  ///
	xtitle("% women") ytitle("% blue collar") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Blue Collar)
	graph save Graph "blue collar_m.gph", replace
	
	
	graph combine "public_m" "private_m" "party_m" "blue collar_m" "white collar_m" "political_m", ///
	title (% Women) 
	graph save FigureA4A.gph, replace
	graph export FigureA4A.png, replace width(1800)

		
	
	twoway (scatter s_m_private quotayear, msymbol(diamond_hollow)) || lfit s_m_private quotayear,  ///
	xtitle("Quota years") ytitle("% w private career")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Private Career)
	graph save Graph "private_mq.gph", replace
		
	twoway (scatter s_m_party quotayear, msymbol(diamond_hollow))  || lfit s_m_party quotayear,  ///
	xtitle("Quota years") ytitle("% w party background")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Party Background)
	graph save Graph "party_mq.gph", replace
		
	twoway (scatter s_m_public quotayear, msymbol(diamond_hollow))  || lfit s_m_public quotayear,  ///
	xtitle("Quota years") ytitle("% w public career")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Public Career)
	graph save Graph "public_mq.gph", replace
		
	twoway (scatter s_cl_mpolitician quotayear, msymbol(diamond_hollow))  || lfit s_cl_mpolitician quotayear,  ///
	xtitle("Quota years") ytitle("% politician") msymbol(circle) ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Politician)
	graph save Graph "political_mq.gph", replace
	
	twoway (scatter s_cl_mwhite quotayear, msymbol(diamond_hollow))  || lfit s_cl_mwhite quotayear,  ///
	xtitle("Quota years") ytitle("% white collar")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(White Collar)
	graph save Graph "white collar_mq.gph", replace
	
	twoway (scatter s_cl_mblue quotayear, msymbol(diamond_hollow))  || lfit s_cl_mblue quotayear,  ///
	xtitle("Quota years") ytitle("% blue collar")  ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Blue Collar)
	graph save Graph "blue collar_mq.gph", replace
	
	
	graph combine "public_mq" "private_mq" "party_mq" "blue collar_mq" "white collar_mq" "political_mq", ///
	title(Quota Years)
	graph save FigureA4B.gph, replace
	graph export FigureA4B.png, replace width(1800)
	


******** Figure A5: Components of Women’s Personal Diversity and Covariance with Percent Women and Quota years *** 


	twoway (scatter s_f_child female) || lfit s_f_child female,  ///
	xtitle("% women") ytitle("% w children") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Children)
	graph save Graph "children_f.gph", replace

	twoway (scatter s_f_married female) || lfit s_f_married female,  ///
	xtitle("% women") ytitle("% married") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%")  legend(off) title(Married) ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")
	graph save Graph "married_fp.gph", replace


	twoway (scatter s_f_college female) || lfit s_f_college female,  ///
	xtitle("% women") ytitle("% w college education") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%")  legend(off) title(College Education) ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")
	graph save Graph "college_fp.gph", replace
	


	graph combine "children_f" "married_fp" "college_fp", row(1) ///
	title (% Women) 
	graph save FigureA5A.gph, replace
	graph export FigureA5A.png, replace width(1800)
	


	twoway (scatter s_f_child quotayear, msymbol(circle)) || lfit s_f_child quotayear,  ///
	xtitle("Quota years") ytitle("% w children")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(Children)
	graph save Graph "children_fq.gph", replace


	twoway (scatter s_f_married quotayear, msymbol(circle)) || lfit s_f_married quotayear,  ///
	xtitle("Quota years") ytitle("% married")   ///
	legend(off) title(Married) ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")
	graph save Graph "married_fq.gph", replace
	

	twoway (scatter s_f_college quotayear, msymbol(circle)) || lfit s_f_college quotayear,  ///
	xtitle("Quota years") ytitle("% w college degree")   ///
	legend(off) title(College Education) ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")
	graph save Graph "college_fq.gph", replace
	
	
	graph combine "children_fq" "married_fq" "college_fq" , row(1) ///
	title (Quota yearss)
	graph save FigureA5B.gph, replace
	graph export FigureA5B.png, replace width(1800)
	
	
			
	graph combine "FigureA5A" "FigureA5B", col(1) ///
	l1("Women's characteristics") 
	graph save FigureA5.gph, replace
	graph export FigureA5.png, replace width(1800)
	
	
	
	
*********** Figure A6: Components of Men’s Personal Diversity and Covariance with Percent Women and Quota years ****************
	twoway (scatter s_m_child female, msymbol(hollow_diamond)) || lfit s_m_child female,  ///
	xtitle("% women") ytitle("% w children") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Children)
	graph save Graph "children_m.gph", replace
	
	twoway (scatter s_m_college female, msymbol(hollow_diamond)) || lfit s_m_college female,  ///
	xtitle("% women") ytitle("% w college degree") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///	
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(College Education)
	graph save Graph "college_mp.gph", replace
	
	twoway (scatter s_m_married female, msymbol(hollow_diamond)) || lfit s_m_married female,  ///
	xtitle("% women") ytitle("% married") ///
	xlabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%") ///	
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(Married)
	graph save Graph "married_mp.gph", replace
	
	graph combine "children_m" "married_mp" "college_mp" , row(1) ///
	title (% Women) 
	graph save FigureA6A.gph, replace
	graph export FigureA6A.png, replace width(1800)
	
	twoway (scatter s_m_college quotayear, msymbol(diamond)) || lfit s_m_college quotayear,  ///
	xtitle("Quota years") ytitle("% w college degree")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(College Education)
	graph save Graph "college_mq.gph", replace
	
	twoway (scatter s_m_married quotayear, msymbol(diamond)) || lfit s_m_married quotayear,  ///
	xtitle("Quota years") ytitle("% married")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%") legend(off) title(Married)
	graph save Graph "married_mq.gph", replace
			
	twoway (scatter s_m_child quotayear, msymbol(diamond)) || lfit s_m_child quotayear,  ///
	xtitle("Quota years") ytitle("% w children")   ///
	ylabel(0 "0%" .20 "20%" .40 "40%" .60 "60%" .80 "80%" 1.00 "100%")legend(off) title(Children)
	graph save Graph "children_mq.gph", replace
		
	graph combine "children_mq" "married_mq" "college_mq" , row(1) ///
	title (Quota years)
	graph save FigureA6B.gph, replace
	graph export FigureA6B.png, replace width(1800)
			
	graph combine "FigureA6A" "FigureA6B", col(1) ///
	l1("Men's characteristics") 
	graph save FigureA6.gph, replace
	graph export FigureA6.png, replace width(1800)
	