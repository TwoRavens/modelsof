****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
**  "An Asymmetrical 'President-in-Power' Effect" 											                  **
** 		Authors: Davide Morisi, John Jost, and Vishal Singh													  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article: 												  **
**																											  **
**		Appendix F: Aggregate data (surveys retrieved from Pew Research Center)								  **
**		Appendix G (results for aggregate data only)														  **
****************************************************************************************************************

*This dataset includes aggregate levels of trust in the government by ideology/partisanship from 128 surveys conducted between 1972 and 2017

*The data have been retrieved from the Pew Research Center:
*Pew Research Center (2017.) “Public Trust in Government: 1958-2017”, December 14 2017
*Available at: http://www.people-press.org/2017/12/14/public-trust-in-government-1958-2017/ [retrieved on July 1, 2018]

*Import the dataset (uploaded on APSR dataverse)
*File: "trustgov_surveys.xlsx"
*import excel "...\trustgov_surveys.xlsx", sheet("recoded") firstrow clear


*******************************************************************************
*******************************************************************************
*RECODING

*Trust
*share of respondents who trust govt always or most of the time
sum trust, d
gen trust01 = trust/100
sum trust01, d // rescaled from 0 to 1

*Ideology
encode ideo, gen(ideo_en)
recode ideo_en (1=2 "conservative/republican") (2=1 "liberal/democrat"), gen(ideo2)
fre ideo2
drop ideo_en

*Democratic/Republican president
ta presparty
ta president presparty
rename presparty prespower
label de prespower 1"democratic president" 2"republican president"
label values prespower prespower
fre prespower
ta year prespower // note diff. pres in years 1980 and 2008

*President with same ideology/from same party as R
fre prespower ideo2
*Liberals/Democrats
gen ownpresL = prespower if ideo2==1
ta ownpresL
recode ownpresL 2=0 .=0
*Conservatives/Republicans
gen ownpresC = prespower if ideo2==2
ta ownpresC
recode ownpresC 2=1 1=0 .=0
*Combined
gen ownpresLC = ownpresL + ownpresC if (ideo2==1 | ideo2==2) & (prespower==1 | prespower==2)
label variable ownpresLC "President with same ideology as R"
label define ownpresLC 0"Other ideology" 1"Same ideology"
label values ownpresLC ownpresLC
fre ownpresLC
ta ideo2 prespower
ta ideo2 ownpresLC

*Party with majority in Senate
encode senate, gen(senate_en)
fre senate_en

*Party with majority in House
encode house, gen(house_en)
fre house_en

*Source
encode source, gen(source_en)
fre source_en

*Year
ta year

*Time: progressive number of months starting from January 1972
ta time

********************************
*Save as recoded dataset
*save "...\trustgov_surveys_recoded.dta"



*******************************************************************************
*******************************************************************************
*ANALYSIS

*Appendix F: Aggregate data (surveys retrieved from Pew Research Center)

*Starting file
*use "...\trustgov_surveys_recoded.dta", clear

*
*Table F1. President-in-power effects on trust in the government by ideology/partisanship (aggre-gate data)
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2
eststo: reg trust01 i.ownpresLC##i.ideo2 i.source_en time
eststo: reg trust01 i.ownpresLC##i.ideo2 i.source_en time i.senate_en i.house_en
esttab using "~TableF1.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table F1")  compress noeqlines replace 

*
*Figure F1. President-in-power effects on trust in the government by ideology/partisanship (aggregate data)
reg trust01 i.ownpresLC##i.ideo2 i.source_en time i.senate_en i.house_en
margins 0.ownpresLC 1.ownpresLC, at(ideo2=1) // liberals
marginsplot, recast(bar) plotopts(barw(.8)) name(figF1_A)
reg trust01 i.ownpresLC##i.ideo2 i.source_en time i.senate_en i.house_en
margins 0.ownpresLC 1.ownpresLC, at(ideo2=2) // conservatives
marginsplot, recast(bar) plotopts(barw(.8)) name(figF1_B)
reg trust01 i.ownpresLC##i.ideo2 i.source_en time i.senate_en i.house_en
margins ideo2, dydx(ownpresLC) post
coefplot, vert yline(0) name(figF1_C)
graph combine figF1_A figF1_B figF1_C


*******************************************************************************
*******************************************************************************
*APPENDIX G: Analysis of changing effects over time

*
*Figure G1. Change in “trust gap” by ideology and partisanship over time (aggregate surveys)
preserve
	gen trustlib = trust01 if ideo2==1
	gen trustcon = trust01 if ideo2==2
	collapse (mean) trustlib trustcon, by(time)
	gen trustgap_ideo = abs(trustlib-trustcon)
	twoway (scatter trustgap_ideo time, sort(time) connect(ascending) color(green) xlabel(0(50)552, valuelabel) xtitle("Time (months)") ytitle("Trust gap (absolute values)") title("Aggregate surveys") name(figG1_agg)) ///
	(lfit trustgap_ideo time, color(green) lpattern(dash)) 

	*Table G1. Regressions of “trust gap” on time variables (aggregate surveys)
	*Column 7
	gen trustgap_ideo100 = trustgap_ideo*100 // rescale DV from 0 to 100
	eststo clear
	eststo: reg trustgap_ideo100 time
	esttab using "~TableG1_agg.rtf", ///
	b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G1. aggregate surveys")  compress noeqlines replace 
restore
	
*
*Table G2. President-in-power effects on trust in the government by ideology and time variables (Aggregate data)
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2##c.time i.source_en 
esttab using "~TableG2_agg.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G2. Aggregate data")  compress noeqlines replace 

*
*Figure G2. President-in-power effects on trust in the government by time variables (difference between conservatives and liberals) (Aggregate data)
reg trust01 i.ownpresLC##i.ideo2##c.time i.source_en 
margins r.ideo2, dydx(ownpresLC) at(time==(0(50)552))
marginsplot, yline(0) name(figG2_agg)













