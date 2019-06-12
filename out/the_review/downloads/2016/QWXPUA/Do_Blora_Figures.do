*ANALYZE BLORA DATA FOR ACADEMIC PAPER

************************************************************
*CALL MASTER DATA
************************************************************

cd "~/Dropbox/BLORA_TAX_REP_FINAL/"  // adjust to suit your individual file path

global tables "Tables"
global figures "Figures"
global ri "Randomization_Inference"


clear
use "Data_Blora_Final.dta"  


************************************************************
*FIGURE 2
************************************************************

preserve

*Obtain the means for beliefs and ideals for each category of spending
foreach item in educ infrastruct health ag leaders other {
	egen `item'_prior_temp = mean(q132_actual_`item'_REC1)
	g `item'_prior = `item'_prior_temp/10000*100
	egen `item'_ideal_temp = mean(q131_decider_`item'_REC1)
	g `item'_ideal = `item'_ideal_temp/10000*100
}

	egen pg_prior_temp = mean(q133_amt_services_REC1)
	g pg_prior = pg_prior_temp/10000*100

*Transform the dataset
	keep if _n==1
	keep educ_prior educ_ideal infrastruct_prior infrastruct_ideal health_prior health_ideal ag_prior ag_ideal leaders_prior leaders_ideal other_prior other_ideal pg_prior	
	local vars educ_prior educ_ideal infrastruct_prior infrastruct_ideal health_prior health_ideal ag_prior ag_ideal leaders_prior leaders_ideal other_prior other_ideal pg_prior	
 	
set obs 7
foreach var of varlist `vars' {
	replace `var' = `var'[_n-1] if `var'==.
}	

g category = "Education" if _n==1
	replace category = "Farming" if _n==2
	replace category = "Health" if _n==3
	replace category = "Infrastructure" if _n==4
	replace category = "Leaders" if _n==5
	replace category = "Other" if _n==6
	replace category = "PG (overall)" if _n==7

*This was information presented in the campaign based on the budget analysis
	g actual = 47 if _n==1
	replace actual = 2 if _n==2
	replace actual = 9 if _n==3
	replace actual = 12 if _n==4
	replace actual = 18 if _n==5
	replace actual = 12 if _n==6
	replace actual = 27 if _n==7

g priors = educ_prior if _n==1
	replace priors = ag_prior if _n==2
	replace priors = health_prior if _n==3
	replace priors = infrastruct_prior if _n==4
	replace priors = leaders_prior if _n==5
	replace priors = other_prior if _n==6
	replace priors = pg_prior if _n==7

g ideals = educ_ideal if _n==1
		replace ideals = ag_ideal if _n==2
		replace ideals = health_ideal if _n==3
		replace ideals = infrastruct_ideal if _n==4
		replace ideals = leaders_ideal if _n==5
		replace ideals = other_ideal if _n==6
	
# delimit ;
graph bar actual priors ideals, over(category) scheme(lean1) ylab(0(10)60)
	legend(position(12) ring(0)  region(style(outline))) 
	legend(label(1 "Actual (info treatment)") label(2 "Prior beliefs") label(3 "Ideals")) 
	bar(1, fcolor(gs3) lcolor(black) lwidth(thin)) bar(2, fcolor(gs8) lcolor(black) lwidth(thin)) bar(3, fcolor(gs13) lcolor(black) lwidth(thin))
	saving("$figures/fig2")
	;

	
restore	
	
************************************************************
*FIGURE 3
************************************************************

*PANEL A
  
    reg q141_performance_REC2 Z1 Z2 Z3 Z4, nocons robust
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }

   
*Stick this in Stata's Do-File editor to run
# delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(20(10)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel A: District Leaders Doing Worse") 
	saving("$figures/fig3_panelA")
	;

	drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*

*PANEL B
    reg q142_satis_apbd_REC2 Z1 Z2 Z3 Z4, nocons robust
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }

# delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(20(10)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel B: Dissatisfaction with Budget") 
	saving("$figures/fig3_panelB") ;

	drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*

*PANEL C
    reg q144_trust_bupati_REC2 Z1 Z2 Z3 Z4, nocons robust
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }

# delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(20(10)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel C: Distrust the District Head") 
	saving("$figures/fig3_panelC") ;

	drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*

	
	
************************************************************
*FIGURE 4
************************************************************

*PANEL A
    reg q147_learnmore_apbd_REC2 Z1 Z2 Z3 Z4, nocons vce(hc2)
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }

 # delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(60(5)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
		|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel A: Monitor Budget")
	saving("$figures/fig4_panelA") ;

    drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*


*PANEL B 
    reg POST Z1 Z2 Z3 Z4, nocons vce(hc2)
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }

   
# delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(60(5)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel B: Participation (Postcard)")
	saving("$figures/fig4_panelB") ;
 
	drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*

*PANEL C
    reg GOODGOV Z1 Z2 Z3 Z4, nocons vce(hc2)
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }

   
*Stick this in Stata's Do-File editor to run
# delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(60(5)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel C: Sanctioning (Postcard)") 
	saving("$figures/fig4_panelC");

	drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*


************************************************************
*FIGURE A.1 (APPENDIX)
*Example (y=60, 65, 70, 85)
************************************************************

preserve
	clear
	
	set obs 4
    g x=[_n]
    g taxgrp=x==2 | x==4
    g infogrp=x==3 | x==4

    g y=60 if x==1
    replace y=65 if x==2
    replace y=70 if x==3
    replace y=85 if x==4


#delimit ;
	graph twoway connected y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(55(5)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	legend(position(5) ring(0)  region(style(outline)))
	|| connected y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	legend(order(1 2)) 
	ytitle("Percent Monitoring, Participating, Sanctioning")
	saving("$figures/append_A1") ;


restore



************************************************************
*FIGURE J.1 (APPENDIX)
************************************************************

*Panel A
	reg GOODGOV Z1 Z2 Z3 Z4 if q85_satis_govt_REC2==0, nocons vce(hc2)
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }


#delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(50(5)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel A: Sanctioning (Postcard), Satisfied") 
	saving("$figures/append_J1_satis") ;

	drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*


*PANEL B
	reg GOODGOV Z1 Z2 Z3 Z4 if q85_satis_govt_REC2==1, nocons vce(hc2)
   
    predict y
    g Y=y*100

    foreach num of numlist 1/4 {
        matrix b=e(b)
        matrix V=e(V)
        scalar b`num'=b[1,`num']
        scalar varb`num'=V[`num',`num']
        g b`num'=b`num'
        g se`num'=sqrt(varb`num')
        g ci_max_`num'=(b`num'+1.96*se`num')*100
        g ci_min_`num'=(b`num'-1.96*se`num')*100
    }


#delimit ;
	graph twoway connected Y infogrp if taxgrp==0, clpattern(solid)
	xscale(range(-.25 1.25)) xlabel(0(1)1,val) ylabel(50(5)90)
	legend(label(1 "Windfall Group") label(2 "Tax Group"))
	xlabel(0 "Low" 1 "High")  symbol(square) color(blue)
	xtitle("Information Treatment") ytitle("Percent") scheme(lean1) msize(large)
	|| connected Y infogrp if taxgrp==1, clpattern(solid) msize(large) color(red) symbol(circle)
	|| rcap ci_min_1 ci_max_1 infogrp if infogrp==0 & taxgrp==0, lcolor(blue) 
 	|| rcap ci_min_2 ci_max_2 infogrp if infogrp==0 & taxgrp==1, lcolor(red)
	|| rcap ci_min_3 ci_max_3 infogrp if infogrp==1 & taxgrp==0, lcolor(blue) 
	|| rcap ci_min_4 ci_max_4 infogrp if infogrp==1 & taxgrp==1, lcolor(red)
	legend(order(1 2)) title("Panel B: Sanctioning (Postcard), Dissatisfied") 
	saving("$figures/append_J1_dissatis") ;

	drop Y y b1 b2 b3 b4 se1 se2 se3 se4 ci_max* ci_min*


************************************************************
*FIGURE K.1 (APPENDIX)
************************************************************

egen viltag=tag(vill_code)

	# delimit ;
	hist picked_up_dh if viltag==1, freq scheme(lean1) discrete
	title("") xtitle("")
	fi(inten200) xlab(0(1)5) ytitle("") 
	saving("$figures/append_K1")  ;

	
	

*END*	
	
	
	
	









