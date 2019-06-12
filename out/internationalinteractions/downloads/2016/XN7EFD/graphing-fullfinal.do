/* This file is used to graph the resulting CSV files from SAS */



//Shared IGO Memberships & MIDs(force) (Figure 1, pg 45)
import delimited model_1_finaldraft_p45_fatalmid.csv, varnames(1) 

graph twoway line i2_numigo year || line i2_numigo_l year || line i2_numigo_u year || ///
		if year>1950 & year<2000, ///
		yscale(r(-.2 .1)) ylabel(-.2(.05).1, grid) yline(0, lwidth(medium) lcolor(black)) ///
		title("Time Varying Effect of Shared IGO Memberships on MIDs") subtitle("DV: MIDs") ///
		legend(cols(1) label(1 "IGO comembership") label(2 "95% CI upper bounds") label(3 "95% CI lower bounds"))
		
		graph export figure1.pdf, replace
clear

		
//Shared IGO Memberships & Fatal MID (Figure 3, pg 47) 
import delimited model_3_finaldraft_p47_fatalmid.csv, varnames(1) 

graph twoway line i2_numigo year || line i2_numigo_l year || line i2_numigo_u year || ///
		if year>1950 & year<2000, ///
		yscale(r(-.2 .1)) ylabel(-.2(.05).1, grid) yline(0, lwidth(medium) lcolor(black)) ///
		title("Time Varying Effect of Shared IGO Memberships on MIDs") subtitle("DV: Fatal MIDs") ///
		legend(cols(1) label(1 "IGO comembership") label(2 "95% CI upper bounds") label(3 "95% CI lower bounds"))
		
		graph export figure3.pdf, replace
clear
	
	
//Shared IGO Memberships (MTOPS) & MIDs(force) (Figure 5, pg 49) 
import delimited model_5_finaldraft_p49_fatalmid.csv, varnames(1) 

graph twoway line i2_num_mtops year || line i2_num_mtops_l year || line i2_num_mtops_u year || ///
		if year>1950 & year<2000, ///
		yscale(r(-1 .4)) ylabel(-1(.2).4, grid) yline(0, lwidth(medium) lcolor(black)) ///
		title("Time Varying Effect of Shared Security IGO Memberships on MIDs", size(medlarge)) subtitle("DV: MIDs") ///
		note (mtops data) ///
		legend(cols(1) label(1 "IGO comembership") label(2 "95% CI upper bounds") label(3 "95% CI lower bounds"))
		
		graph export figure5.pdf, replace
clear		


//Shared IGO Memberships (MTOPS) & Fatal MIDs (Figure 6, pg 50) 
import delimited model_6_finaldraft_p50_fatalmid.csv, varnames(1) 

graph twoway line i2_num_mtops year || line i2_num_mtops_l year || line i2_num_mtops_u year || ///
		if year>1950 & year<2000, ///
		yscale(r(-1 .4)) ylabel(-1(.2).4, grid) yline(0, lwidth(medium) lcolor(black)) ///
		title("Time Varying Effect of Shared Security IGO Memberships on MIDs", size(medlarge)) subtitle("DV: Fatal MIDs") ///
		note (mtops data) ///
		legend(cols(1) label(1 "IGO comembership") label(2 "95% CI upper bounds") label(3 "95% CI lower bounds"))

		graph export figure6.pdf, replace
clear	



/************************************************************/
/******************** BGN BGN BGN ***************************/
/************************************************************/
//models with the SCOUNT variable (using "BGN" data that only goes to 1992)


//security IGOs (scount) & MIDs(force) (Figure 2, pg 46) 
import delimited model_2_finaldraft_p46_bgn.csv, varnames(1) 

graph twoway line scount year || line scount_l year || line scount_u year || ///
		if year>1950 & year<1989, ///
		yscale(r(-6 2)) ylabel(-6(1)2) yline(0, lwidth(medium) lcolor(black)) ///
		title("Time Varying Effect of Shared Security IGO Memberships on MIDs", size(medlarge)) subtitle("DV: MIDs") ///
		legend(cols(1) label(1 "IGO comembership") label(2 "95% CI upper bounds") label(3 "95% CI lower bounds"))

		graph export figure2.pdf, replace		
clear


//security IGOs (scount) & Fatale MIDs (Figure 4, pg 48) 
import delimited model_4_finaldraft_p48_bgn.csv, varnames(1) 

graph twoway line scount year || line scount_l year || line scount_u year || ///
		if year>1950 & year<1989, ///
		yscale(r(-6 2)) ylabel(-6(1)2) yline(0, lwidth(medium) lcolor(black)) ///
		title("Time Varying Effect of Shared Security IGO Memberships on MIDs", size(medlarge)) subtitle("DV: Fatal MIDs") ///
		legend(cols(1) label(1 "IGO comembership") label(2 "95% CI upper bounds") label(3 "95% CI lower bounds"))

		graph export figure4.pdf, replace
clear

