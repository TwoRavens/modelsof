*******************************************************************************
*** Description: 	This document provides the code for reproducing the 	***
***					tables and figures in Study 1 of the paper, "Compulsory ***
***					Voting and Parties’ Vote Seeking Strategies," which	is	***
***					authored by Shane P. Singh and appears in the American	***
***					Journal of Political Science. 							***
***					It also provides the for reproducing the tables and		***
***					figures associated with Study 1 in the appendix.		***
*******************************************************************************

**************
**************
*Set the Version                                                                                                                                 
**************
**************
version 13.1



**************
**************
*Open the Varieties of Democracy Version 7 Data, which First Needs to be Prepared in "V-Dem Preparation.do"                                                                                                                         
**************
**************
use "V-Dem_AJPS_Replication.dta", clear

	
	
**************
**************
*Remove Observations Flagged by V-Dem                                                                                                                       
**************
**************
*A cautionary note in the Version 7 codebook says not to use point estimates for country-variable-years with three or fewer (<=3) ratings for the period 2013-2016.
drop if v2elvotbuy_nr <=3 & year >=2013 
drop if v2psprlnks_nr <=3 & year >=2013 
	
	
	

**************
**************
*Exclude Years in Which a Country Was Deemed Not Free or Not Assessed by Freedom House
**************
**************
drop if  e_fh_status_numeric==3 
drop if  e_fh_status_numeric==.


	
**************
**************
*To Ensure That the Same Countries are Included in Each Model, Drop Countries for Which There is No Information on the Vote Buying Scale                                                                                                                    
**************
**************	
gen samp_vb = 0
reg v2elvotbuy_rev_0_10 , cl(country) 
replace samp_vb = 1 if e(sample)
tabulate country, gen(countrynum)
gen included = .
foreach x of varlist countrynum* {
	sum samp_vb if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

drop if included == 0
drop included countrynum* samp_vb




**************
**************
*Create Country-Specific Time Trends
**************
**************
encode country, gen(cntrynum_temp) //*First, create a new numerical country identifier, as the current identifier is not sequential due to the above dropping of the countries without data on the vote buying measure. 
sum cntrynum_temp
global total_number =  r(max) //*Recover number of included countries to use below.

sum year if year >=1972 & year<=2015 //*Restrict the range to years on which data are available for each variable that will appear in the models.
gen time = (year - r(min))/(r(max) - r(min))
forvalues i = 1/$total_number {
gen cntrynum_temp`i' = cntrynum_temp == `i'
gen trend`i' = time*cntrynum_temp`i'
}



**************
**************
*Model 1 of Table 1
**************
**************
xtreg v2psprlnks_0_10  i.v2elcomvot  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2  v2cltrnslw majoritarian_filled presidential federal latin trend* , i(cntrynum) mle
estimates table, b(%9.3f) se(%9.3f)  stats(rho N N_g chi2)
estimates store Study1Model1



**************
**************
*Model 2 of Table 1
**************
**************
xtreg v2elvotbuy_rev_0_10  i.v2elcomvot  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2 v2cltrnslw  majoritarian_filled presidential federal latin trend*, i(cntrynum) mle
estimates table, b(%9.3f) se(%9.3f)  stats(rho N N_g chi2)
estimates store Study1Model2



**************
**************
*Figure 1
**************
**************
estimates restore Study1Model1
margins ,  at(v2elcomvot=(0(1)3)) atmeans post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Programmatism)  aspectratio(1.25) ///
	 name(Study1Model1Predictions, replace)

estimates restore Study1Model2
margins ,  at(v2elcomvot=(0(1)3)) atmeans post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Vote Buying)  aspectratio(1.25)  ///
	 name(Study1Model2Predictions, replace)

graph combine Study1Model1Predictions Study1Model2Predictions ///
	,  xcommon scheme(s1color) rows(1) iscale(1) graphregion(margin(zero)) xsize(7)
	

	
**************
**************
*Evidence for Claim Made in the Footnotes: "When the time trends are removed, results indicate that about 80 percent of the unmodeled variation in the dependent variables exists across countries."
**************
**************	
xtreg v2psprlnks_0_10  i.v2elcomvot  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2  v2cltrnslw majoritarian_filled presidential federal latin, i(cntrynum) mle //*rho is 0.83
xtreg v2elvotbuy_rev_0_10  i.v2elcomvot  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2 v2cltrnslw  majoritarian_filled presidential federal latin, i(cntrynum) mle //*rho is 0.76
	
	

**************
**************
*Appendix Section 2, Table A1: Countries with Compulsory Voting Included in the V-Dem Sample and the Classification of Compulsory Voting Rules
**************
**************	
*First Column: Which countries in the sample used compulsory voting?
estimates restore Study1Model1
tabstat  v2elcomvot if v2elcomvot_any~=0 & v2elcomvot_any~=. & e(sample), by(country) stats(mean range)

*Second Column: What years are included for countries in sample (formerly) with CV?
tab year if country ==	"Argentina" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Australia" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Austria" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Belgium" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Bolivia" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Brazil" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Burundi" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Chile" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Costa Rica" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Cyprus" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Dominican Republic" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Ecuador" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Egypt" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Fiji" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Gabon" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Greece" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Guatemala" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Honduras" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Italy" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Kazakhstan" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Mexico" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Mongolia" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Panama" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Paraguay" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Peru" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Singapore" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Thailand" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Turkey" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Uruguay" & e(sample) & v2elcomvot_any == 1
tab year if country ==	"Venezuela" & e(sample) & v2elcomvot_any == 1

*Third Column: What is the level of CV in the most recently included year with an election?
tabstat  year if v2elcomvot_any~=0 & v2elcomvot_any~=. & e(sample) &  (v2eltype_0 == 1 |  v2eltype_6  == 1), by(country) stats(max) //*get most recent election year in the sample with this line 
tab v2elcomvot if country ==	"Argentina" & e(sample) & year == 2015
tab v2elcomvot if country ==	"Australia" & e(sample) & year == 2013
tab v2elcomvot if country ==	"Austria" & e(sample) & year == 2004
tab v2elcomvot if country ==	"Belgium" & e(sample) & year == 2014
tab v2elcomvot if country ==	"Bolivia" & e(sample) & year == 2014
tab v2elcomvot if country ==	"Brazil" & e(sample) & year == 2014
tab v2elcomvot if country ==	"Burundi" & e(sample) & year == 2010
tab v2elcomvot if country ==	"Chile" & e(sample) & year == 2009
tab v2elcomvot if country ==	"Costa Rica" & e(sample) & year == 2014
tab v2elcomvot if country ==	"Cyprus" & e(sample) & year == 2013
tab v2elcomvot if country ==	"Dominican Republic" & e(sample) & year == 2012
tab v2elcomvot if country ==	"Ecuador" & e(sample) & year == 2013
tab v2elcomvot if country ==	"Egypt" & e(sample) & year == 2012
tab v2elcomvot if country ==	"Fiji" & e(sample) & year == 2006
tab v2elcomvot if country ==	"Gabon" & e(sample) & year == 2006
tab v2elcomvot if country ==	"Greece" & e(sample) & year == 2012
tab v2elcomvot if country ==	"Guatemala" & e(sample) & year == 1985
tab v2elcomvot if country ==	"Honduras" & e(sample) & year == 2013
tab v2elcomvot if country ==	"Italy" & e(sample) & year == 1992
tab v2elcomvot if country ==	"Kazakhstan" & e(sample) & year == 1991
tab v2elcomvot if country ==	"Mexico" & e(sample) & year == 2015
tab v2elcomvot if country ==	"Mongolia" & e(sample) & year == 1990
tab v2elcomvot if country ==	"Panama" & e(sample) & year == 2009
tab v2elcomvot if country ==	"Paraguay" & e(sample) & year == 2013
tab v2elcomvot if country ==	"Peru" & e(sample) & year == 2011
tab v2elcomvot if country ==	"Singapore" & e(sample) & year == 2015
tab v2elcomvot if country ==	"Thailand" & e(sample) & year == 2011
tab v2elcomvot if country ==	"Turkey" & e(sample) & year == 2015
tab v2elcomvot if country ==	"Uruguay" & e(sample) & year == 2014
tab v2elcomvot if country ==	"Venezuela" & e(sample) & year == 1988
	
	
**************
**************
*Support Claim Made in Note to Table A1: "Results are substantively the same if voting is coded as voluntary for Austria in the entire period under study."
**************
**************	
*Create new ordinal compulsory voting measure with Austria coded as voluntary for all years.
gen v2elcomvot_Austriarecode = v2elcomvot
replace v2elcomvot_Austriarecode = 0 if country == "Austria"
replace v2elcomvot_Austriarecode = . if v2elcomvot == .

xtreg v2psprlnks_0_10  i.v2elcomvot_Austriarecode  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2  v2cltrnslw majoritarian_filled presidential federal latin trend* , i(cntrynum) mle	
xtreg v2elvotbuy_rev_0_10  i.v2elcomvot_Austriarecode  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2 v2cltrnslw  majoritarian_filled presidential federal latin trend* , i(cntrynum) mle

drop  v2elcomvot_Austriarecode


**************
**************
*Appendix Section 3, Figure A1: Compulsory Voting, Predicted Programmatism, and Predicted Vote Buying Across Countries: Three Category Classification of Compulsory Voting
**************
**************	
*Create new ordinal compulsory voting measure with the top two categories collapsed into one.
gen v2elcomvot_three_cat = v2elcomvot
replace v2elcomvot_three_cat = 2 if v2elcomvot == 3
replace v2elcomvot_three_cat = . if v2elcomvot == .

*Left Panel
xtreg v2psprlnks_0_10  i.v2elcomvot_three_cat  	c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2  v2cltrnslw majoritarian_filled presidential federal latin trend*, i(cntrynum) mle
margins ,  at(v2elcomvot_three_cat=(0(1)2)) atmeans post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med/high}")   ///
	 ylabel(5(1)8) ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Programmatism)  aspectratio(1.25) ///
	 name(Study1FigureA1Programmatism, replace)

*Right Panel	 
xtreg v2elvotbuy_rev_0_10  i.v2elcomvot_three_cat  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2 v2cltrnslw  majoritarian_filled presidential federal latin trend*, i(cntrynum) mle
margins ,  at(v2elcomvot_three_cat=(0(1)2)) atmeans post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med/high}")   ///
	 ylabel(1(1)5) ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Vote Buying)  aspectratio(1.25) ///
	 name(Study1FigureA1VoteBuying, replace)


*Combine Graphs
graph combine Study1FigureA1Programmatism Study1FigureA1VoteBuying ///
	,  xcommon scheme(s1color) rows(1) iscale(1) graphregion(margin(zero)) xsize(7)
	
	
drop v2elcomvot_three_cat
	


**************
**************
*Appendix Section 3, Figure A2: Compulsory Voting, Predicted Programmatism, and Predicted Vote Buying Across Countries, Alternate Classification of Australia’s Compulsory Voting Rule
**************
**************	
*Create new ordinal compulsory voting measure with Australia coded as having the highest level of compulsory voting.
gen v2elcomvot_Ausrecode = v2elcomvot
replace v2elcomvot_Ausrecode = 3 if v2elcomvot == 2 & country == "Australia"
replace v2elcomvot_Ausrecode = . if v2elcomvot == .

*Left Panel
xtreg v2psprlnks_0_10  i.v2elcomvot_Ausrecode  	c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2  v2cltrnslw majoritarian_filled presidential federal latin trend*, i(cntrynum) mle
margins ,  at(v2elcomvot_Ausrecode=(0(1)3)) atmeans post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med/high}")   ///
	 ylabel(5(1)8) ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Programmatism)  aspectratio(1.25) ///
	 name(Study1FigureA2Programmatism, replace)

*Right Panel	 
xtreg v2elvotbuy_rev_0_10  i.v2elcomvot_Ausrecode  c.GDP_percap_dol_Taiw##c.GDP_percap_dol_Taiw c.e_polity2##c.e_polity2 v2cltrnslw  majoritarian_filled presidential federal latin trend*, i(cntrynum) mle
margins ,  at(v2elcomvot_Ausrecode=(0(1)3)) atmeans post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med/high}")   ///
	 ylabel(1(1)5) ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Vote Buying)  aspectratio(1.25) ///
	 name(Study1FigureA2VoteBuying, replace)


*Combine Graphs
graph combine Study1FigureA2Programmatism Study1FigureA2VoteBuying ///
	,  xcommon scheme(s1color) rows(1) iscale(1) graphregion(margin(zero)) xsize(7)
	
	
drop v2elcomvot_Ausrecode



**************************************************************************************************
**************************************************************************************************
*Unless Otherwise Indicated, All Code Below Pertains to Appendix Section 4: "Cross-National Patterns 
*in Compulsory Voting and Party Strategies in Data From the Democratic Accountability and Linkages Project (DALP)"
**************************************************************************************************
**************************************************************************************************

**************
**************
*Open the Democratic Accountability and Linkages Project Data, which First Needs to be Prepared in "DALP Preparation.do"                                                                                                                         
**************
**************
use "DALP_AJPS_Replication.dta", clear


**************
**************
*Exclude Years in Which a Country Was Deemed Not Free or Not Assessed by Freedom House
**************
**************
drop if  e_fh_status_numeric==3 
drop if  e_fh_status_numeric==.



**************
**************
*Model A1 of Table A3
**************
**************
xtreg mobilize_positions_0_10  i.v2elcomvot##c.vote_share  c.GDP_percapita##c.GDP_percapita c.polity##c.polity v2cltrnslw majoritarian presidential federal latin, i(cntrynum) mle
estimates table, b(%9.3f) se(%9.3f)  stats(rho N N_g chi2)
estimates store Study1ModelA1



**************
**************
*Model A2 of Table A3
**************
**************
xtreg gen_programmatic_struc_0_10  i.v2elcomvot##c.vote_share  c.GDP_percapita##c.GDP_percapita c.polity##c.polity v2cltrnslw majoritarian presidential federal latin, i(cntrynum) mle
estimates table, b(%9.3f) se(%9.3f)  stats(rho N N_g chi2)
estimates store Study1ModelA2




**************
**************
*Figure A3
**************
**************
estimates restore Study1ModelA1
margins v2elcomvot, at(vote_share = 45) post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") xdimension(v2elcomvot) ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Policy Emphasis)  aspectratio(1.25) ///
	 name(Study1ModelA1Predictions, replace)


estimates restore Study1ModelA2
margins v2elcomvot, at(vote_share = (45))  post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color)  title("") xdimension(v2elcomvot) ///
	 ci1opts(color(black*.8) lwidth(medium))  /// 
     plot1opts(mcolor(black)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Predicted Level of Programmatism)  aspectratio(1.25) ///
	 name(Study1ModelA2Predictions, replace)


graph combine Study1ModelA1Predictions Study1ModelA2Predictions ///
	,  xcommon scheme(s1color) rows(1) iscale(1) graphregion(margin(zero)) xsize(7)
	



**************
**************
*Appendix Section 2, Table A2: Countries with Compulsory Voting Included in the DALP Sample and the Classification of Compulsory Voting Rules
**************
**************	
estimates restore Study1ModelA1
tabstat  year v2elcomvot  if v2elcomvot_any~=0 & v2elcomvot_any~=. & e(sample), by(country) stats(mean)






