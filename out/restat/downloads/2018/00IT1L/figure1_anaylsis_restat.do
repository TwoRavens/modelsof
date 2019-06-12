	clear *
	set matsize 11000
	set more off
	capture log close 
	global mypath "\\rschfs1x\userRS\A-E\dbr88_RS\Documents\Selection over time\"

	global run_regressions "on" //Yearly regressions to create the means for the graph
	global make_graphs "on"  //Turns coefficients into graphs 

if "${run_regressions}"=="on" {
	
		global cps_reg_types	 regress
		global cps_reg_specs  \${cps_uncontrolled_controls}  `"\${cps_primary_controls}"' 
		global cps_dependent `""unemployment_rate" "'	
		global cps_primary_controls 	`"b2.education i.female i.race  b3.age i.size"'
		global cps_extra_controls " i.marriage i.statenum i.urban_rural i.interview_month "
		global cps_uncontrolled_controls    b2.education i.female i.race i.children b3.age " "
		global cps_reg_options  `", vce(cluster hrhhid)"'
		
		use  "${mypath}data\combined_stata_cleaned.dta", clear //reads in cleaned new data
		qui destring _all, replace
		g  hrhhid_s=string(hrhhid)
		drop hrhhid
		rename hrhhid_s hrhhid
		append using "\\rschfs1x\userRS\A-E\dbr88_RS\Documents\Selection\cps\data\cps_analysis", force //feeds in data from original paper
		destring hrhhid, replace 
		
		log using "${mypath}regression_log.txt", text replace 
		
	forvalues year=1995/2012 {

		foreach dependent in ${cps_dependent} {
			di "`year' `dependent'"
			regress `dependent' difficulty##(${cps_primary_controls} ${cps_extra_controls}) if interview_year==`year'			
				local `dependent'`year'n=e(N)
				margins i.difficulty, post
				forvalues i=1/4 {
					local `dependent'`year'`i'=_b[`i'.difficulty]
					local `dependent'`year'`i'se=_se[`i'.difficulty]
					
				}
				regress `dependent' difficulty##(${cps_primary_controls} ${cps_extra_controls}) if interview_year==`year'
				margins, post 
				local `dependent'`year'overall=_b[_cons]
				local `dependent'`year'overallse=_se[_cons]

				pause
			}	
		}
		capture log close
		g coeff_est=.
		g coeff_se=.
		g coeff_year=.
		g coeff_diff=.
		g coeff_type=""
		g coeff_n=.
		local m=1
		forvalues year=1995/2012 {

			foreach dependent in ${cps_dependent} {
				forvalues i=0/6 {
					if `i'==0 {
						replace coeff_est=``dependent'`year'overall' if _n==`m'
						replace coeff_se=``dependent'`year'overallse' if _n==`m'
					}
					else if `i'>0 & `i'<5 {
						replace coeff_est=``dependent'`year'`i'' if _n==`m'
						replace coeff_se=``dependent'`year'`i'se' if _n==`m'

					}
					else if `i'==5 {
						replace coeff_est=``dependent'`year'1'-``dependent'`year'3' if _n==`m'
					
					}
					else if `i'==6 {
						replace coeff_est=``dependent'`year'2'-``dependent'`year'3' if _n==`m'
					
					}						
					di "``dependent'`year'`i''"
					replace coeff_year=`year' if _n==`m'
					replace coeff_diff=`i' if _n==`m'
					replace coeff_type="`dependent'" if _n==`m'
					replace  coeff_n= ``dependent'`year'n'  if _n==`m' 

					local ++m
				}
			}	
		}
		destring coeff_est, replace
		keep coeff*
		keep if coeff_est!=.
		
		save "${mypath}data\cps_for_graphs.dta", replace	
		
		
		
		
		
		
}
	
	
if "${make_graphs}"=="on" {	
	use "${mypath}data\cps_for_graphs.dta", clear	

	replace coeff_est=coeff_est*100
	replace coeff_se=coeff_se*100
	
	
	foreach outcome in unemployment_rate  {
	if "`outcome'"=="unemployment_rate" {
			local title ""
			local ytitle `" ytitle("Unemployment rate and difference (%)" , size(medsmall)) "'
			local xtitle `" xtitle("Year", size(medsmall)) "'
			local xlabel "xlabel(1994(2)2012)"
			local ylabel "ylabel(0(2)10, angle(horizontal))"
			local yticks "yticks(0 .2 .4 .6 .8 1 1.2 1.4 1.6 1.8 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0, grid)"
			local xticks ""
			
		}


		
		
		graph twoway connected coeff_est coeff_year if coeff_diff==1 & coeff_type=="`outcome'", msymbol(S) mcolor(black)|| connected coeff_est coeff_year if coeff_diff==5 & coeff_type=="`outcome'", msymbol(Sh) mcolor(black) || connected coeff_est coeff_year if coeff_diff==2 & coeff_type=="`outcome'" ,msymbol(T) mcolor(gs6) || connected coeff_est coeff_year if coeff_diff==6 & coeff_type=="`outcome'", msymbol(Th) mcolor(gs6) || connected coeff_est coeff_year if coeff_diff==3 & coeff_type=="`outcome'"  , msymbol(D) mcolor(gs10) legend(label(1 "1 attempt") label(2 "1 minus 3+")  label(3 "2 attempts") label(4 "2 minus 3+") label(5 "3+ attempts")   cols(2)  title("Adjusted means:         Difference in means :", size(medsmall) justification(right) ) size(medsmall) symysize(*.7) symxsize(*.7) pos(11) ring(0) )  `ytitle' `xtitle' `xlabel' title("`title'") `ylabel' `yticks' `xticks'  scheme(sj) xsize(3.575) ysize(2)
		
		graph export "${mypath}graphs\overtime_`outcome'.pdf", replace
		
	}
	




	
	
	
	
	
}
	
	
	
	
	
	