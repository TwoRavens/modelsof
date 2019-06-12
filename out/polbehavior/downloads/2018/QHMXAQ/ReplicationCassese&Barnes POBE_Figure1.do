
//Replication file for Cassese & Barnes POBE
//This file is used to create:
	//Figure 1

use "ReplicationCassese&Barnes POBE_Figure1.dta"

	
//Figure 1 
//Panel A: All Voters
	capture graph drop allvoters
	 # delimit ;
	twoway line AfemaleR year if year>=1980, lwidth(medthick) lcolor(black) || line AmaleR year if year>=1980 , lwidth(medthick) lpattern(dash) lcolor(black) || 
	line AfemaleD year if year>=1980, lwidth(medthick) lcolor(gs9) || line AmaleD year if year>=1980 , lwidth(medthick) lpattern(dash) lcolor(gs9) 
	name(allvoters) xsize(10) graphregion(fcolor(white)) plotregion(fcolor(white))
	legend(order(1 "Republican Women" 2 "Republican Men" 3 "Democrat Women" 4 "Democrat Men"))
	title("Panel A: All Voters")
	ytitle("Vote Share", size(medium))
	xtitle(" ", size(medium))
	ylabel(0(20)100)
	;
		#delimit cr	
	
	
//Panel B: White Voters
	capture graph drop whitevoters
	 # delimit ;
	twoway line femaleR year if year>=1980, lcolor(black) lwidth(medthick) || line maleR year if year>=1980 , lwidth(medthick)lpattern(dash) lcolor(black) || 
	line femaleD year if year>=1980, lwidth(medthick) lcolor(gs9) || line maleD year if year>=1980 , lwidth(medthick) lpattern(dash) lcolor(gs9) 
	name(whitevoters) xsize(10) graphregion(fcolor(white)) plotregion(fcolor(white))
	legend(order(1 "Republican Women" 2 "Republican Men" 3 "Democrat Women" 4 "Democrat Men"))
	title("Panel B: White Voters")
	ytitle("Vote Share", size(medium))
	xtitle(" ", size(medium))
	ylabel(0(20)100);
 
	#delimit cr	
	
	
	
	
//Panel C: Nonwhite
	capture graph drop nonwvoters
	 # delimit ;
	twoway line NfemaleR year if year>=1980, lwidth(medthick) lcolor(black) || line NmaleR year if year>=1980 , lwidth(medthick) lpattern(dash) lcolor(black) || 
	line NfemaleD year if year>=1980, lwidth(medthick) lcolor(gs9) || line NmaleD year if year>=1980 , lwidth(medthick) lpattern(dash) lcolor(gs9) 
	name(nonwvoters) xsize(10) graphregion(fcolor(white)) plotregion(fcolor(white))
	legend(order(1 "Republican Women" 2 "Republican Men" 3 "Democrat Women" 4 "Democrat Men"))
	title("Panel C: Nonwhite Voters")
	ytitle("Vote Share", size(medium))
	xtitle(" ", size(medium))
	ylabel(0(20)100);
 
	#delimit cr	
	
	
