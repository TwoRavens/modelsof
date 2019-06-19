#delimit ;
set more off;
set scheme s1mono;
log using FreedmanOwens_RESTAT_Log.txt, text replace;
*********************************************************************;
* Program: FreedmanOwens_RESTAT.do
* Authors: Freedman & Owens
* Date: July 31, 2014
* Description: Calculates statistics and runs regressions for figures tables in 
  "Your Friends & Neighbors: Localized Economic Development and Criminal Activity" (RESTAT)
* Inputs: Main.dta, Table2.dta, Figure2.dta, Figures3_4.dta; 
*********************************************************************;

use FreedmanOwens_RESTAT_Main, replace;

*********************************************************************;
di as txt "Descriptive Statistics [Table 1]";
sum shrcon_dec, det;
local shrcon_dec_p50=r(p50);
di "Cutoff for High/Low Share Construction: " `shrcon_dec_p50';
gen shrcon_high=(shrcon_dec>=`shrcon_dec_p50');
count if year==2000 & shrcon_high!=1;
gen TRACTS=r(N) if shrcon_high!=1;
count if year==2000 & shrcon_high==1;
replace TRACTS=r(N) if shrcon_high==1;
	* Employment Shares (2000);
	tabstat shrcon_dec n_shrcon_dec shracc_dec shrhc_dec TRACTS if year==2000, by(shrcon_high) col(stat);
	* Demographic and Housing Characteristics (2000);
	tabstat population_i shrbk_i shrhis_i shrmal_i shrpop18_i shrspan_i shrhs_i 
		    poverty_rate mdhhy mdvalhs vehicles_hu shrvehicle2plus housingunits shroccupied shrmoved5 TRACTS if year==2000, by(shrcon_high) col(stat);
	* Demographic and Housing Characteristics (2005-2009);
	tabstat population_i 
	        poverty_rate mdhhy mdvalhs vehicles_hu shrvehicle2plus housingunits shroccupied shrmoved5 TRACTS if year==2009, by(shrcon_high) col(stat);			
	drop TRACTS;
	* Crime Rates (2000-2010);
	count if shrcon_high~=1;
	gen TRACTS=r(N) if shrcon_high!=1;
	count if shrcon_high==1;
	replace TRACTS=r(N) if shrcon_high==1;
	tabstat numBURGLARY_pc numCARTHEF_pc numLARCNY_pc numROBBERY_pc numMURDER_pc numRAPE_pc numASSLT_pc numASSLT_FAM_pc  TRACTS, by(shrcon_high) col(stat);
	drop TRACTS;

*********************************************************************;
* Main Outcomes and Controls for All Regressions;	
local outcomes BURGLARY CARTHEF LARCNY ROBBERY MURDER RAPE ASSLT ASSLT_FAM;	
local controls shrmal_i shrbk_i shrhis_i shrspan_i shrpop18_i shrhs_i;
tab year, gen(year_);	

*********************************************************************;
di as txt "Fixed Effects Estimates of Crime and Construction Workers in Bexar County [Table 3]";
* Note: These also produce a subset of the results in Appendix Tables A3-A6;
local sectors  brac2005_x_p_shrcon_dec brac2007_x_p_shrcon_dec brac2005_x_p_shracc_dec brac2007_x_p_shracc_dec brac2005_x_p_shrhc_dec brac2007_x_p_shrhc_dec;
foreach y in `outcomes' {;
	areg ln_num`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r1;
	areg ln_firstcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r2;	
	areg ln_repeatcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r3;	
	areg ln_repeatcv`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r4;	
	estout * using Table3_`y'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;					
};

*********************************************************************;
di as txt "Fixed Effects Estimates of Crime and Construction Workers in Bexar County, with Adjacent Block Groups [Table 4]";
* Note: These also produce a subset of the results in Appendix Tables A3-A6;
local sectors  brac2005_x_p_shrcon_dec brac2007_x_p_shrcon_dec brac2005_x_p_n_shrcon_dec brac2007_x_p_n_shrcon_dec brac2005_x_p_shracc_dec brac2007_x_p_shracc_dec brac2005_x_p_shrhc_dec brac2007_x_p_shrhc_dec;
foreach y in `outcomes' {;
	areg ln_num`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r1;
	areg ln_firstcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r2;	
	areg ln_repeatcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r3;	
	areg ln_repeatcv`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r4;	
	estout * using Table4_`y'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;					
};

*********************************************************************;
di as txt "Fixed Effects Estimates of Crime and Construction Workers in Bexar County, with Adjacent Block Groups and Block Group Pre-Treatment Trend by Year Fixed Effects [Table 5]";
* Note: These also produce a subset of the results in Appendix Tables A3-A6;
local sectors  brac2005_x_p_shrcon_dec brac2007_x_p_shrcon_dec brac2005_x_p_n_shrcon_dec brac2007_x_p_n_shrcon_dec brac2005_x_p_shracc_dec brac2007_x_p_shracc_dec brac2005_x_p_shrhc_dec brac2007_x_p_shrhc_dec;
xi i.dtCRM*i.year, prefix(T_);
foreach y in `outcomes' {;
	areg ln_num`y'_pc `sectors' `controls' year_* T_*, cluster(bg) absorb(bg);
	est store r1;
	areg ln_firstcr`y'_pc `sectors' `controls' year_* T_*, cluster(bg) absorb(bg);
	est store r2;	
	areg ln_repeatcr`y'_pc `sectors' `controls' year_* T_*, cluster(bg) absorb(bg);
	est store r3;	
	areg ln_repeatcv`y'_pc `sectors' `controls' year_* T_*, cluster(bg) absorb(bg);
	est store r4;	
	estout * using Table5_`y'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;					
};
drop T_*;

*********************************************************************;
di as txt "Fixed Effects Estimates of Crime and Construction Workers in Bexar County, with Adjacent Block Groups and QCEW Construction Employment Interactions [Table 6]";
* Note: These also produce a subset of the results in Appendix Tables A3-A6;
local sectors  brac2005_x_p_shrcon_dec brac2007_x_p_shrcon_dec brac2005_x_p_n_shrcon_dec brac2007_x_p_n_shrcon_dec brac2005_x_p_shracc_dec brac2007_x_p_shracc_dec brac2005_x_p_shrhc_dec brac2007_x_p_shrhc_dec;
local qcew p_shrcon_dec_x_ln_con_qcew;
foreach y in `outcomes' {;
	areg ln_num`y'_pc `sectors' `controls' `qcew' year_*, cluster(bg) absorb(bg);
	est store r1;
	areg ln_firstcr`y'_pc `sectors' `controls' `qcew' year_*, cluster(bg) absorb(bg);
	est store r2;	
	areg ln_repeatcr`y'_pc `sectors' `controls' `qcew' year_*, cluster(bg) absorb(bg);
	est store r3;	
	areg ln_repeatcv`y'_pc `sectors' `controls' `qcew' year_*, cluster(bg) absorb(bg);
	est store r4;	
	estout * using Table6_`y'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;					

};

*********************************************************************;
di as txt "Fixed Effects Estimates of Crime and Construction Workers in Bexar County, with Adjacent Block Groups and Relaxing the Timing of BRAC [Tables 7 and 8]";
local sectors  	b2004_x_p_shrcon_dec b20052006_x_p_shrcon_dec b20072008_x_p_shrcon_dec b20092010_x_p_shrcon_dec 
				b2004_x_p_n_shrcon_dec b20052006_x_p_n_shrcon_dec b20072008_x_p_n_shrcon_dec b20092010_x_p_n_shrcon_dec
				b2004_x_p_shracc_dec b20052006_x_p_shracc_dec b20072008_x_p_shracc_dec b20092010_x_p_shracc_dec  
				b2004_x_p_shrhc_dec b20052006_x_p_shrhc_dec b20072008_x_p_shrhc_dec b20092010_x_p_shrhc_dec;
foreach y in BURGLARY CARTHEF LARCNY ROBBERY {;
	areg ln_num`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r1;
	areg ln_firstcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r2;	
	areg ln_repeatcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r3;	
	areg ln_repeatcv`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r4;	
	estout * using Table7_`y'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;					
};
foreach y in MURDER RAPE ASSLT ASSLT_FAM {;
	areg ln_num`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r1;
	areg ln_firstcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r2;	
	areg ln_repeatcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r3;	
	areg ln_repeatcv`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r4;	
	estout * using Table8_`y'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;					
};

*********************************************************************;
di as txt "APPENDIX: Fixed Effects Estimates of Crime and Construction Workers in Bexar County, Level Analysis with Adjacent Block Groups [Appendix Table A2]";
local sectors  	brac2005_x_p_shrcon_dec brac2007_x_p_shrcon_dec brac2005_x_p_n_shrcon_dec brac2007_x_p_n_shrcon_dec brac2005_x_p_shracc_dec brac2007_x_p_shracc_dec brac2005_x_p_shrhc_dec brac2007_x_p_shrhc_dec;
foreach y in `outcomes' {;
	areg num`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r1;
	areg firstcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r2;	
	areg repeatcr`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r3;	
	areg repeatcv`y'_pc `sectors' `controls' year_*, cluster(bg) absorb(bg);
	est store r4;	
	estout * using Appendix_A2_`y'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;					
};

*********************************************************************;
di as txt "Acquisitive and Non-Acquisitive Crimes in Bexar County in Neighborhoods with High and Low Construction Shares for First-Time and Repeat Offenders [Figures 5, 6, 7, 8, 9, and 10]";
gen highgroup=p_shrcon_dec>3;
replace highgroup=2 if p_shrcon_dec>15;
sort year highgroup;
by year highgroup: egen pop_year=sum(population);
by year: egen pop_all=sum(population);
foreach c in BURGLARY CARTHEF LARCNY ROBBERY MURDER RAPE ASSLT ASSLT_FAM {;
	by year: egen num`c'_all=sum(num`c');
	by year highgroup: egen num`c'_year=sum(num`c');
	by year highgroup: egen cv`c'_year1=sum(firstcr`c');
	by year highgroup: egen cv`c'_year2=sum(repeatcr`c');
	by year highgroup: egen cv`c'_year3=sum(repeatcv`c');
	gen num`c'_pc_all=1000*num`c'_all/pop_all;
	gen num`c'_pc_year=1000*num`c'_year/pop_year;
	gen num`c'_pc_year1=1000*(cv`c'_year1)/pop_year;
	gen num`c'_pc_year2=1000*(cv`c'_year2)/pop_year;
	gen num`c'_pc_year3=1000*(cv`c'_year3)/pop_year;
};
by year: gen all_n=_n;
by year highgroup: gen year_n=_n;
gen numMURDER_10pc_all=10*numMURDER_pc_all;
gen numRAPE_10pc_all=10*numRAPE_pc_all;
gen numMURDER_10pc_year=10*numMURDER_pc_year;
gen numRAPE_10pc_year=10*numRAPE_pc_year;
gen numMURDER_10pc_year1=10*numMURDER_pc_year1;
gen numRAPE_10pc_year1=10*numRAPE_pc_year1;
gen numMURDER_10pc_year2=10*numMURDER_pc_year2;
gen numRAPE_10pc_year2=10*numRAPE_pc_year2;
gen numMURDER_10pc_year3=10*numMURDER_pc_year3;
gen numRAPE_10pc_year3=10*numRAPE_pc_year3;
twoway (line numBURGLARY_pc_all numCARTHEF_pc_all numLARCNY_pc_all numROBBERY_pc_all year if all_n==1), xline(2005, lpattern(dash)) xline(2007, lpattern(dash)) ytitle("Offenses/1000 Population") xtitle("Year") saving(Figure5.gph, replace);
twoway (line numMURDER_10pc_all numRAPE_10pc_all numASSLT_pc_all numASSLT_FAM_pc_all year if all_n==1), xline(2005, lpattern(dash)) xline(2007, lpattern(dash)) ytitle("Offenses/1000 Population") xtitle("Year") saving(Figure6.gph, replace);
foreach crime in BURGLARY_pc CARTHEF_pc ROBBERY_pc LARCNY_pc ASSLT_pc ASSLT_FAM_pc MURDER_10pc RAPE_10pc {;
	twoway 	(line num`crime'_year year if year_n==1 & highgroup==2 , lcolor(black) lpattern(solid) lwidth(medthick))
			(line num`crime'_year year if year_n==1 & highgroup==0 , lcolor(black) lpattern(dash_dot) lwidth(medthick)) ,
			xline(2005, lpattern(dash)) xline(2007, lpattern(dash))
			ytitle("Offenses/1000 Population") xtitle("Year")
			title("`crime'")
			legend(off);
			graph save `crime'share.gph, replace;
}; 
gr combine BURGLARY_pcshare.gph CARTHEF_pcshare.gph LARCNY_pcshare.gph ROBBERY_pcshare.gph, saving(Figure7.gph, replace);
gr combine MURDER_10pcshare.gph RAPE_10pcshare.gph ASSLT_pcshare.gph ASSLT_FAM_pcshare.gph, saving(Figure8.gph, replace);
foreach g in BURGLARY_pcshare.gph CARTHEF_pcshare.gph LARCNY_pcshare.gph ROBBERY_pcshare.gph MURDER_10pcshare.gph RAPE_10pcshare.gph ASSLT_pcshare.gph ASSLT_FAM_pcshare.gph {;
	erase `g';
};

foreach crime in BURGLARY_pc CARTHEF_pc ROBBERY_pc LARCNY_pc ASSLT_pc ASSLT_FAM_pc MURDER_10pc RAPE_10pc {;
	twoway 	(line num`crime'_year1 year if year_n==1 & highgroup==2 , lcolor(gray) lpattern(solid) lwidth(medthick))
		(line num`crime'_year1 year if year_n==1 & highgroup==0 , lcolor(gray) lpattern(dash_dot) lwidth(medthick)) 
		(line num`crime'_year3 year if year_n==1 & highgroup==2 , lcolor(black) lpattern(solid) lwidth(medthick))
		(line num`crime'_year3 year if year_n==1 & highgroup==0 , lcolor(black) lpattern(dash_dot) lwidth(medthick)) ,
		xline(2005, lpattern(dash)) xline(2007, lpattern(dash))
		ytitle("Offenses/1000 Population") xtitle("Year")
		title("`crime'")
		legend(off);
		graph save `crime'share.gph, replace;
};
gr combine BURGLARY_pcshare.gph CARTHEF_pcshare.gph LARCNY_pcshare.gph ROBBERY_pcshare.gph, saving(Figure9.gph, replace);
gr combine MURDER_10pcshare.gph RAPE_10pcshare.gph ASSLT_pcshare.gph ASSLT_FAM_pcshare.gph, saving(Figure10.gph, replace);
foreach g in BURGLARY_pcshare.gph CARTHEF_pcshare.gph LARCNY_pcshare.gph ROBBERY_pcshare.gph MURDER_10pcshare.gph RAPE_10pcshare.gph ASSLT_pcshare.gph ASSLT_FAM_pcshare.gph {;
	erase `g';
};

clear;

*********************************************************************;
di as txt "Neighborhood Outcomes and Construction Workers in Bexar and Travis Counties, 2000 to 2005-2009 [Table 2]";
use FreedmanOwens_RESTAT_Table2, replace;
foreach d in poverty_rate ln_mdhhy ln_mdvalhs shrvehicle2plus vehicles_hu ln_population ln_housingunits shroccupied shrmoved5 {;
	sum `d', det;
	areg `d' brac_x_shrcon_dec brac_x_shracc_dec brac_x_shrhc_dec `controls' year_2000 if BEXAR==1, cluster(bg) absorb(bg);
	est store r1;
	areg `d' brac_x_shrcon_dec brac_x_shracc_dec brac_x_shrhc_dec `controls' year_2000 if BEXAR==0, cluster(bg) absorb(bg);
	est store r2;
	estout * using Table2_`d'.txt, replace cells(b(star fmt(3)) se(par([ ]) fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2);
	est clear;
};

clear;

*********************************************************************;
di as txt "QCEW Relative Wages and Excess Jobs in Construction, Bexar vs. Travis County [Figure 2]";
use FreedmanOwens_RESTAT_Figure2.dta;
twoway line relwage year, mcolor(black) ms(O) lcolor(black) lwidth(medthick) yaxis(1) ||
       line excess year,  lwidth(medthick) lcolor(black) lpattern(dash) ms(S) yaxis(2) ,
	  scheme(s1mono)
	  xline(2005 2007, lpattern(dash))
	  text(0.91 2003.6 "BRAC Announced")
	  text(0.84 2008.5 "First BRAC Contract")
	  ytitle("Bexar Wage / Travis Wage") 
	  ytitle("Bexar Jobs - Travis Jobs" , axis(2) )
	  xtitle("Year")
	  legend( row(1) 
	  label(1 "Relative Wages") 
	  label(2 "Excess Jobs") region(lstyle(none)) );
	  graph save Figure2.gph, replace;

clear;

*********************************************************************;
di as txt "QCEW Employment in Bexar County in Construction, Tourism, and Health Care [Figure 2]";
use FreedmanOwens_RESTAT_Figures3_4.dta, clear;
replace emp=emp/1000;
replace accemp=accemp/1000;
replace healthemp=healthemp/1000;
twoway line emp year, mcolor(black) ms(O) lcolor(black) lwidth(medthick) yaxis(1) ||
	line accemp year,  lwidth(medthick)  ms(D) yaxis(2) ||
	line healthemp year,  lwidth(medthick) lcolor(black) lpattern(dash) ms(S) yaxis(2) ,
	  scheme(s1mono)
	  xline(2005 2007, lpattern(dash) lcolor(black))
	  text(42 2003.5 "BRAC Announced")
	  text(35 2008.6 "First BRAC Contract")
	  ytitle("Construction (1000s)") 
	  ytitle("Tourism and Health (1000s)" , axis(2) )
	  xtitle("Year")
	  legend( row(1) label(1 "Construction") 
	  label(2 "Tourism") 
	  label(3 "Health") region(lstyle(none)));
	  graph save Figure3.gph, replace;
	  
*********************************************************************;
di as txt "QCEW Weekly Wages in Bexar County in Construction, Tourism, and Health Care [Figure 3]";
twoway line avgwage year, mcolor(black) ms(O) lcolor(black) lwidth(medthick) yaxis(1) ||
	line accwage year,  lwidth(medthick) ms(S) yaxis(1) ||
	line healthwage year,  lwidth(medthick) lcolor(black) lpattern(dash) ms(D) yaxis(1) ,
	  scheme(s1mono)
	  xline(2005 2007, lpattern(dash) lcolor(black))
	  text(820 2003.7 "BRAC Announced")
	  text(550 2008.4 "First BRAC Contract")
	  ytitle("Average Weekly Wages ($)")
	  xtitle("Year")
	  legend( row(1) label(1 "Construction") 
	  label(2 "Tourism") 
	  label(3 "Health") region(lstyle(none)));
	  graph save Figure4.gph, replace;

log close;
clear;	  
	  
*********************************************************************;

