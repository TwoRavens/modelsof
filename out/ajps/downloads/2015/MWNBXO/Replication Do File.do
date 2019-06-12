/*    REPLICATION NOTES  

*This do-file contains the syntax for all data sets used in the paper. Please be sure to load the according data set when replicating results.

Date:        		17 April 2015
Code Version:		Final Version
Author:      		Bearce, Tuxhorn
Purpose:     		These files reproduce all results reported in tables for AJPS
					"When Are Monetary Policy Preferences Egocentric?					Evidence from American Surveys and an Experiment" (Year XXXX; Vol. XX; Issue XX)
Publications:		Paper: "When Are Monetary Policy Preferences Egocentric?.17Apr2015.docx"					
Data Used:   		Mechanical Turk Surveys and CCES Surveys
File Names:   		"Replication Do File" (file that estimates the models reported in paper)
Input Files:		"MT survey.dta "   
					"CCES 2012.dta"  
					"CCES 2013.dta" 
					"MT experiment.dta " 
Machine:     		MGF; Macbook
Version:			Stata 12.1
*/


*************Using MT survey data set***************
clear
set more off
use "MT survey.dta", clear

**TABLE 1**
*Descriptive Statistics for the 2012 MT Sample
sum  dmpa income educ industry_exports industry_imports nontradeable_industry net_industry_exports overseas_biz_none overseas_biz_some overseas_biz_most overseas_biz_all overseas_biz union unemployed retired age female white black liberal_ideo democrat republican 


**TABLE 2**
*Model 2.1
reg  dmpa income educ industry_exports industry_imports nontradeable_industry overseas_biz_some overseas_biz_most overseas_biz_all union unemployed retired age female white black liberal_ideo democrat republican, cluster (state)

*Model 2.2
reg  dmpa income educ net_industry_exports overseas_biz union unemployed retired age female white black liberal_ideo democrat republican, cluster (state)

*Model 2.3
reg  dmpa income educ net_industry_exports overseas_biz union age female white black liberal_ideo democrat republican if retired==0 & unemployed==0, cluster (state)



************Using CCES 2012 data set*************
**TABLE 1**
*Descriptive Statistics for the 2012 CCES Sample
use "CCES 2012.dta", clear

sum dmpa income educ industry_exports industry_imports nontradeable_industry net_industry_exports overseas_biz_none overseas_biz_some overseas_biz_most overseas_biz_all overseas_biz union unemployed retired age female white black liberal_ideo democrat republican

**TABLE 3**
*Model 3.1
reg dmpa income educ industry_exports industry_imports nontradeable_industry overseas_biz_some overseas_biz_most overseas_biz_all union age female white black liberal_ideo democrat republican [pweight=weights_10_2013], cluster (state)

*Model 3.2
reg dmpa income educ net_industry_exports overseas_biz union age female white black liberal_ideo democrat republican [pweight=weights_10_2013], cluster (state)



***********Using MT experiment data set***************
use "MT experiment.dta", clear

**TABLE 4**
*Descriptive Statistics for the No Vignette Sample (Column 1)
sum income educ net_industry_exports overseas_biz unemployed retired union age female white black liberal_ideo democrat republican if no_vig==1

*Descriptive Statistics for the CCES Vignette Sample (Column 2)
sum income educ net_industry_exports overseas_biz unemployed retired union age female white black liberal_ideo democrat republican if CCESvignette==1

*Descriptive Statistics for the MT Vignette Sample (Column 3)
sum income educ net_industry_exports overseas_biz unemployed retired union age female white black liberal_ideo democrat republican if MTvignette==1

**TABLE 5**
*Model 5.1
reg dmpa income educ net_industry_exports overseas_biz CCESvignette MTvignette wave01, cluster (state)

*Model 5.2
reg dmpa income educ net_industry_exports overseas_biz wave01 if no_vig==1, cluster (state)

*Model 5.3
reg dmpa income educ net_industry_exports overseas_biz wave01 if CCESvignette==1, cluster (state)

*Model 5.4
reg dmpa income educ net_industry_exports overseas_biz wave01 if MTvignette==1, cluster (state)

*Model 5.5
reg dmpa income educ net_industry_exports overseas_biz overseas_bizXCCES overseas_bizXMT CCESvignette MTvignette wave01, cluster (state)



**********Using CCES 2013 data set***************
use "CCES 2013.dta", clear

**TABLE 6**
*Descriptive Statistics for the 2013 CCES Sample
sum dmpa income educ industry_exports industry_imports nontradeable_industry net_industry_exports overseas_biz_none overseas_biz_some overseas_biz_most overseas_biz_all overseas_biz union unemployed retired age female white black liberal_ideo democrat republican

**TABLE 7**
*Model 7.1
reg dmpa income educ industry_exports industry_imports nontradeable_industry overseas_biz_some overseas_biz_most overseas_biz_all union unemployed retired age female white black liberal_ideo democrat republican [pweight=weight], cluster (state)

*Model 7.2
reg dmpa income educ net_industry_exports overseas_biz union unemployed retired age female white black liberal_ideo democrat republican [pweight=weight], cluster (state)

*Model 7.3
reg dmpa income educ net_industry_exports overseas_biz union age female white black liberal_ideo democrat republican [pweight=weight] if retired==0 & unemployed==0, cluster (state)
