******************************************************************
* Figure 1: Rise of Polarization in Survey Data (ANES) 1984-2012
******************************************************************

clear
use "ANES_Polarization.dta", clear

twoway (line tau year if question==1, lcolor(black) lwidth(medthick)) ///
	(line tau year if question==2, lcolor(black) lwidth(medthick) lpattern("--")) ///
	(line tau year if question==3, lcolor(black) lwidth(medthick) lpattern("_")) ///
	(line tau year if question==4, lcolor(black) lwidth(medthick) lpattern("-...")) ///
	(line tau year if question==5, lcolor(black) lwidth(medthick) lpattern("_...")) ///
	(line tau year if question==6, lcolor(black) lwidth(medthick) lpattern(".")) ///
	(line unit year, lcolor(white) lwidth(medthick) yaxis(2)) ///
	, ///
	xtitle (Year) ///
	ytitle("Correlation (Kendall's {&tau})" " ") ///
	ytitle("Unit Response Rate" " ", axis(2)) ///
	ylabel(0(0.2)1, angle(0) nogrid) ///
	ylabel(0 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", angle(0) nogrid axis(2)) ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(gs10) lcolor(black)) ///
	legend(on region(fcolor(gs10) lcolor(black)) rows(3) size(small) ///
		label(1 "Aid to blacks") label(2 "Abortion") label(3 "Jobs") ///
		label(4 "Health Insurance") label(5 "Defense Spending")  ///
		label(6 "Goverment Spending") label(7 "Unit Response Rate")  ///
		holes(7) order(1 6 2 4 5 3 7)) ///
	xlabel(1984(4)2012)  ///
	note("- The polarization lines are the Kendall tau correlation coefficients of party identification"  ///
		"  (Democrat-Republican; 7 scale) and policy position (Liberal-Conservative; 7 scale).")

******************************************************************
* 2003 Pew Survey - comparing standard to rigorous sample
******************************************************************

clear
use "Pew_2003.dta", clear

* figure A1 (Appendix)
graph bar abs_d, ///
	over(sample) over(topic) asyvars horizontal ///
	graphregion(fcolor(white) lcolor(black)) ///
	plotregion(fcolor(gs8) lcolor(black) margin(r=10)) ///
	ylabel(0 "0" 0.2 "0.2 Low" 0.5 "0.5 Moderate" 0.8 "0.8 High", nogrid) ///
	yline(.2, lpattern(.) lcolor(white)) ///
	yline(.5, lpattern(.) lcolor(white)) ///
	yline(.8, lpattern(.) lcolor(white)) ///
	ytitle("Cohen's d Measure of Partisan Differences") ///
	legend(region(lcolor(black) fcolor(gs8)) rows(3) ///
		order(10 "Sample:" 1 "Rigorous (50% Response Rate)" 2 "Standard  (25% Response Rate)")) ///
	bar(1, color(white)) bar(2, color(black)) ///
	xsize(9) ysize(6)		
		
******************************************************************
* ANES Comparison: 2008 vs. 2012
******************************************************************

clear
use "ANES_2008_2012.dta", clear

******************************************************************
* Pew Unit Response Rate & Attention to News
******************************************************************


clear
use "Pew_2004_2014_unitresponse.dta", clear

collapse (mean) unit, by(year)

twoway (lowess unit year, bwidth(0.8) lcolor(gs10)) ///
	(lowess unit year, bwidth(0.8) lcolor(white)) ///
	(lowess unit year, bwidth(0.8) lcolor(none) yaxis(2)) ///
	, ///
	plotregion(fcolor(gs10) lcolor(black)) 	///
	graphregion(fcolor(white) lcolor(white)) ///
	ylabel(0 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", angle(0) nogrid axis(1) labsize(medsmall)) ///
	ytitle("Percent", axis(1) size(medsmall)) ///
	xtitle("Year",  size(medsmall)) xlabel(, labsize(medsmall)) ///
	xsize(9) ysize(6) ///
	legend(on rows(3) region(fcolor(gs10) lcolor(black)) order(1 2 3) ///
		label(2 "Unit Response Rate") ///
		label(1 " ") ///
		label(3 " ")  size(medsmall)) ///
	ytitle(" ", axis(2)  size(medsmall)) ///
	ylabel(, noticks labcolor(white) axis(2) labsize(medsmall)) ///
	title("Decline in Unit Response Rate", color(black) size(medsmall))

graph rename unit, replace	

rename unitresponserate unit
   
clear 
use "Pew_2004_2014_engagement.dta", clear

twoway (lowess vote unit, bwidth(0.8) lcolor(white)) ///
	(lowess vote unit, bwidth(0.8) lcolor(black)) ///
	(lowess news unit, bwidth(0.8) lcolor(black) lpattern(_) yaxis(2)) ///
	(lowess non unit, bwidth(0.8) lcolor(black) lpattern(-) yaxis(2)) ///
	, ///
	plotregion(fcolor(gs10) lcolor(black) margin(b=0 t=0 r=0 l=0)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylabel(0 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%", angle(0) nogrid axis(1) labsize(medsmall)) ///
	ylabel(0(1)3, angle(0) nogrid axis(2) labsize(medsmall)) ///
	legend(on rows(2) region(fcolor(gs10) lcolor(black) margin(zero)) ///
		label(2 "Reported Voting (Percent)") label(3 "Attention to News (Mean)") ///
		label(4 "Item Nonresponse (Mean)") label(1 "Unit Response Rate (Percent)") ///
		symxsize(*0.6) size(small)) ///
	ytitle("", axis(1) size(medsmall)) ///
	ytitle("Mean", axis(2) size(medsmall)) ///
	xtitle("Unit Response Rate", size(medsmall)) xscale(reverse) ///
	xlabel(30 "30%" 25 "25%" 20 "20%" 15 "15%" 10 "10%" 5 "5%", labsize(medsmall)) ///
	xsize(9) ysize(6) ///
	title("Increase in Political Engagement", color(black) size(medsmall))

graph rename engaged, replace	

grc1leg unit engaged, legendfrom(engaged) ///
	graphregion(fcolor(white) lcolor(white))
	
************************************************
* Difference between attentive and non-attentive	
************************************************
	
clear
use "Pew_2004_2014_Attention.dta", clear
ttest abs_d, by(attention)

************************************************************************
* Table 2: The Effect of Unit Response on Mass Polarization in Surveys
************************************************************************

clear
use "Pew_Models.dta", clear
reg abd_d unit d_congress if economy==1, beta
predict yecon, xb
reg abd_d unit d_congress if civil_rights==1, beta
predict yciv, xb
reg abd_d unit d_congress if energy==1, beta
predict yenerg, xb
reg abd_d unit d_congress if immigration==1, beta
predict yimm, xb
reg abd_d unit d_congress if welfare==1, beta
predict ywelf, xb
reg abd_d unit d_congress if field==2, beta // foreign
predict yfor, xb

* Figure 3

twoway (lfit yciv unit , lwidth(medthick) lcolor(white) lpattern(longdash))/*
	*/ (lfit ywelf unit , lwidth(medthick) lcolor(white) lpattern(dash_dot))/*
	*/ (lfit yfor unit , lwidth(medthick) lcolor(white))/*
	*/ (lfit yecon unit , lwidth(medthick) lcolor(black)) /*
	*/ (lfit yenerg unit , lwidth(medthick) lcolor(black) lpattern(longdash))/*
	*/ (lfit yimm unit , lwidth(medthick) lcolor(black) lpattern(dash_dot))/*
	*/ if year<2015,/*
	*/ graphregion(fcolor(white))/*
	*/ plotregion(margin(b=0 l=0 t=0 r=0) fcolor(gs8) lcolor(black))/*
	*/ ylabel(0 0.2 "Low .2" .5 "Medium .5" 0.8 "High .8" 1, angle(0) nogrid)/*
	*/ ytitle("Polarization" " ")/*
	*/ xtitle(Unit Response Rate)/*
	*/ xlabel(30 "30%" 25 "25%" 20 "20%" 15 "15%" 10 "10%" 5 "5%")/*
	*/ xscale(reverse)/*
	*/ legend(on rows(2) region(fcolor(gs8) lcolor(black)) order(4 5 6 1 2 3) /*
		*/ label(4 "Economy")/*
		*/ label(1 "Civil Rights")/*
		*/ label(5 "Energy")/*
		*/ label(6 "Immigration")/*
		*/ label(2 "Welfare")/*
		*/ label(3 "Foreign Affairs")) /*
	*/ xsize(9) ysize(6) /*
	*/ note("* Polarization is predicted probabilities based on the models in Table 2.")

************************************************************************
* Appendix: Table B1: Mean Difference: Items with Two Options Only
************************************************************************
	
clear
use "Pew_Models.dta", clear

reg dif unit difc if economy==1 & values==2
reg dif unit difc if civil_rights==1 & values==2
reg dif unit difc if energy==1 & values==2
reg dif unit difc if immigration==1 & values==2
reg dif unit difc if welfare==1 & values==2
reg dif unit difc if field==2 & values==2 // foreign

************************************************************************
* Appendix: Table B2: Results using t-statistics
************************************************************************
	
clear
use "Pew_Models.dta", clear

reg abs_t unit t_congress if economy==1
reg abs_t unit t_congress if civil_rights==1
reg abs_t unit t_congress if energy==1
reg abs_t unit t_congress if immigration==1
reg abs_t unit t_congress if welfare==1
reg abs_t unit t_congress if field==2 // foreign

************************************************************************
* Appendix: Figure B2: Mean Sample Size in Pew Surveys over Time
************************************************************************

clear
use "Pew_SampleSize.dta", clear

collapse (mean) landline_n cellular_n n, by(year)

twoway (line landline_n year, lwidth(medthick) lcolor(gs12)) ///
	(line cellular_n year, lwidth(medthick) lcolor(white)) ///
	(line n year, lwidth(medthick) lcolor(black)), ///
	ylabel(0(500)2500, angle(0) nogrid) ytitle(Sample Size) ///
	xtitle(Year) ///
	graphregion(fcolor(white) lcolor(black)) ///
	plotregion(fcolor(gs8) lcolor(black)) ///
	legend(on rows(1) region(lcolor(black) fcolor(gs8)) order(3 1 2) ///
		label(1 "Landline") ///
		label(2 "Cellular") ///
		label(3 "Overall") ) 

************************************************************************
* Appendix: Comparing unit response rate in cellular and landline samples
************************************************************************

clear
use "Pew_ContactMethod.dta", clear
	
twoway (scatter unit_ll year, color(black) msymbol(Oh)) ///
	(scatter unit_cell year, color(black) msymbol(Oh)) ///
	(lowess unit_ll year, bwidth(0.5) lwidth(medthick) lcolor(white)) ///
	(lowess unit_cell year, bwidth(0.5) lwidth(medthick) lcolor(gs12)) ///
	(lowess unit_combined year, bwidth(0.5) lwidth(medthick) lcolor(black))	///
	, ///
	ylabel(0 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%" 60 "60%", angle(0) nogrid) ///
	graphregion(fcolor(white)) ///
	plotregion(fcolor(gs10) lcolor(black) margin(l=5 r=5 b=0)) ///
	legend(on rows(1) order(5 "Combined" 3 "Landline" 4 "Cellular" 1 "Surveys (combined)") ///
		symxsize(*0.5) region(fcolor(gs10) lcolor(black))) ///
	xlabel(2004 `"{bf:2004 (14)}"' 2005 `"{bf:2005 (7)}"' 2006 `"{bf:2006 (10)}"' ///
	2007 `"{bf:2007 (10)}"' 2008 `"{bf:2008 (11)}"' 2009 `"{bf:2009 (14)}"' ///
	2010 `"{bf:2010 (12)}"' 2011 `"{bf:2011 (11)}"' 2012 `"{bf:2012 (13)}"' ///
	2013 `"{bf:2013 (18)}"' 2014 `"{bf:2014 (15)}"', angle(45)) ///
	ytitle(Response Rate) ///
	xtitle("Year (Number of Surveys)") ///
	note("- Lines represent lowess smoothing lines with 0.5 bandwidth." ///
		, placement(center) ring(1))		
