
use "$data/podes_pkhrollout.dta", clear	
		

keep if rctsample==1
keep if year==2005

sum treat_pkhrct if treat_pkhrct>0
 gen N=`r(N)' if treat_pkhrct>0
 
sum treat_pkhrct if treat_pkhrct==0
replace N=`r(N)' if treat_pkhrct==0 

gen census=.

	
	label var nsuicidespc "Suicide rate"
	label var suicide "Any suicide"
	label var n_educbaseline "Education institutions per capita"
	label var n_healthfacilitiesbaseline "Health institutions per capita "
	label var asphaltroadbaseline "\% villages with asphalted road"
	label var lightingbaseline "\% villages with lighting"
	label var perc_elebaseline "\% villages with electricity"
	label var ruralbaseline "\% rural villages"
	label var nvillages2005 "Number of villages"
	label var pop_size "Population size" 
	label var n_familiesbaseline "Number of families"
	label var perc_farmers2005 "Percentage of farmers"
	label var N "\midrule N"

  
loc covars "nsuicidespc suicide n_educbaseline n_healthfacilitiesbaseline asphaltroadbaseline lightingbaseline ruralbaseline nvillages2005 pop_size n_familiesbaseline  perc_farmers2005 N"

/* Balance tables */

    preserve

    clear all
    eststo clear
    estimates drop _all

    set obs 10
    qui gen x = 1
    qui gen y = 1

    forval i = 1/5{

        qui eststo col`i': reg x y

    }

    restore

/* Statistics */

    loc tabletitle "Baseline balance: Randomized experiment"
    loc rowstats ""
    loc rowlabels ""
    loc colnames " "Treatment" "Control" "$\Delta$" "se($\Delta$)" "p($\Delta$=0)""

    loc varlength: list sizeof covars
    loc varindex = 1

    mat def P1 = J(`varlength', 1, .)
    mat def P2 = J(`varlength', 1, .)
    mat def P3 = J(`varlength', 1, .)

    foreach var in `covars' {

 
        cap noi {
            qui sum `var' if treat_pkhrct  == 1  
            estadd loc `var'_m = string(r(mean), "%9.3f"): col1
        }

        cap noi {
            qui sum `var' if treat_pkhrct  == 0 
            estadd loc `var'_m = string(r(mean), "%9.3f"): col2
        }


		cap noi {
           reg `var' treat_pkhrct , cluster(kecid)
					local temp = _b[treat_pkhrct]
	           estadd loc `var'_m =  string(`temp', "%9.3f"): col3
		   
		    reg `var' treat_pkhrct , cluster(kecid)		
			local temp = _se[treat_pkhrct]
		   estadd loc `var'_m ="(" +string(`temp', "%9.3f")+ ")": col4
		   
		        reg `var' treat_pkhrct , cluster(kecid)
				test treat_pkhrct=0
		    estadd loc `var'_m = string(r(p), "%9.3f"): col5
        }

        loc rowstats "`rowstats' `var'_m `var'_sd"
        loc rowlabels "`rowlabels' `"`: var la `var''"' " " "

        loc ++varindex

    }

	sum N if treat_pkhrct >0  
	estadd loc N_m= string(r(N), "%9.0f"), replace: col1
	sum N if treat_pkhrct  == 0
	estadd loc N_m= string(r(N), "%9.0f"), replace: col2
	sum N if treat_pkhrct  !=.
	estadd loc N_m= string(r(N), "%9.0f"), replace: col3 
		sum N if treat_pkhrct  !=.
	estadd loc N_m= string(r(N), "%9.0f"), replace: col4
		sum N if treat_pkhrct  !=.
	estadd loc N_m= string(r(N), "%9.0f"), replace: col5
	
    esttab * using "$tables/TableA2_balance.tex", replace cells(none) booktabs nonotes nonum compress alignment(c) nogap noobs nobaselevels label mtitle(`colnames') stats(`rowstats', labels(`rowlabels'))
    eststo clear

*** Omnibus balance test ***

reg treat_pkhrct nsuicidespc suicide n_educbaseline n_healthfacilitiesbaseline asphaltroadbaseline ///
	lightingbaseline   ruralbaseline  nvillages2005 pop_size n_familiesbaseline perc_farmers2005, cluster(kecid200)
	
di "The p-value of the F-statistic of the omnibus balance test is: "	e(F)
	
	

