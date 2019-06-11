log using Log_analysis_ISSP_data.txt, text replace

****************************************************************************************************************
***Analysis of ISSP data for "Pedersen & Mutz: Attitudes toward Economic Inequality: The Illusory Agreement" ***
****************************************************************************************************************
***Written for STATA 14 ****************************************************************************************
****************************************************************************************************************


******************************************************
***Installing required packages and setting schemes***
******************************************************
ssc install estout // This installs the "estout" package 
set scheme s1mono
graph set window fontface "Garamond"

**********************
***Data***************
**********************

* Run this do-file on the data file "ZA5400_v3-0-0" 
* Data file originally downloaded from https://dbk.gesis.org/dbksearch/sdesc2.asp?no=5400 on 24 november, 2015 

*************************
***Setting up the data***
*************************

***Creating the two key variables***
 format V23 V25 V28 V30 %20.0g
 gen Estimated_CEO_unskilled = V23/V25
 gen Ideal_CEO_unskilled = V28/V30
 gen Estimated_CEO_unskilled_missing=mi(Ideal_CEO_unskilled)
 gen Ideal_CEO_unskilled_missing=mi(Ideal_CEO_unskilled)

***The difference between Estimated and Ideal ratios***
 gen wantlowerdifference=.
 replace wantlowerdifference=-1 if Estimated_CEO_unskilled<Ideal_CEO_unskilled
 replace wantlowerdifference=0 if Estimated_CEO_unskilled==Ideal_CEO_unskilled
 replace wantlowerdifference=1 if Estimated_CEO_unskilled>Ideal_CEO_unskilled
 label define wantlowerdifference -1 "Ideal is larger than perceived" 0 "Ideal is equal to percieved" 1 "Ideal is smaller than perceived"
 label values wantlowerdifference wantlowerdifference

 ***Describing the two key variables***
sum Estimated_CEO_unskilled Ideal_CEO_unskilled, detail //*Variables have some extreme outliers and is skewed

***Dealing with the extreme outliers/skewness by taking the natural log***
gen Estimated_CEO_unskilled_log  = ln(Estimated_CEO_unskilled)
gen Ideal_CEO_unskilled_log      = ln(Ideal_CEO_unskilled)

***Setting up other variables***

*Left-right placement*
tab PARTY_LR, missing //A left-right position is attributed to only 50.2 percent of the respondents (footnote 1 in paper)
recode PARTY_LR (1=0) (2=.25) (3=.5) (4=.75) (5=1) (else=.), gen(Left_right)

*Gender*
recode SEX (2=1 "Female") (1=0 "Male") (else=.), gen(Female)
 
*Age* 
gen Age:"Age (years)"=AGE 

*Education*
recode EDUCYRS (95 96=.), gen(Education)
label variable Education "Education in years"

*Q20 Which social class would you say you belong to?*
recode V66 (1=0) (2=.2) (3=.4) (4=.6) (5=.8) (6=1) (else=.), gen(social_class)
 
*Q6a Differences in income in <R's country> are too large.*
recode V32 (5=0) (4=.25)(3=.5)(2=.75) (1=1) (else=.), gen(dif_too_large)
   recode V32 (5 4=0) (3=1) (2 1=2), gen(dif_too_large_3) //this variable is not used in regressions, only for use in table
   label define dif_too_large_3 0 "Strongly disagree / Disagree" 1 "Neither Agree nor Disagree" 2 "Strongly Agree /Agree"
   label values dif_too_large_3 dif_too_large_3
   
**********************************************************************************************************************
***Analyses***********************************************************************************************************
**********************************************************************************************************************

*Testing for non-response bias in the measurement of the key variables (Are leftwingers/egalitarians more likely to provide an answer on ideal pay?)*
pwcorr Ideal_CEO_unskilled_missing dif_too_large, sig obs //there is no significant correelation between R's attitude on current level of inequality and willingness to provide an answer
pwcorr Ideal_CEO_unskilled_missing Left_right, sig obs    // there is no significant correelation between R's attitude on current level of inequality and willingness to provide an answer

*Dropping cases with missing data on relevant variables
drop if Ideal_CEO_unskilled_log==.
drop if dif_too_large==.
drop if Left_right==.
drop if Estimated_CEO_unskilled_log==.
sum Ideal_CEO_unskilled_log dif_too_large Left_right Estimated_CEO_unskilled_log //We limit our analyses to cases without missing values on the variables of interest to us, which still leaves us with 23,096 respondents


***Regressions - What explains preferred pay ratios***
	reg Ideal_CEO_unskilled_log      dif_too_large , robust
	eststo m1
	reg Ideal_CEO_unskilled_log      dif_too_large Left_right, robust
	eststo m2
	reg Ideal_CEO_unskilled_log      dif_too_large Left_right Estimated_CEO_unskilled_log , robust
	eststo m3
	*Does R2 drop if we exclude dif_too_large from model 3?*
	reg Ideal_CEO_unskilled_log      Left_right Estimated_CEO_unskilled_log , robust //drop in R2 is very small
	
*Table 1: Predicting repondents' ideal pay ratio (CEO/Worker)	
esttab using table1.rtf, b(2) se(2) r2(3) compress replace ///
   title("TABLE 1: PREDICTING RESPONDENTS' IDEAL PAY RATIO (CEO/ WORKER)") ///
   mtitles(" " " " " ") ///
   coeflabels(dif_too_large "Differences in Income Too Large (range 0-1)" Left_right "Rigthwing (Left-Right, range 0-1)" Estimated_CEO_unskilled_log "Estimated ratio, Chairman/worker (ln)" _cons "Constant") ///
   nonotes  addnotes("Note: Entries are OLS regression coefficients predicting the natural log of respondents' Ideal" ///
	"Pay Ratios, with robust standard errors in parentheses." ///
	"* p<0.05, ** p<0.01, *** p<0.001")
   eststo clear

*Figure 1: Lack of Correspondence Between Semantic Assessment of Income Differences and Pay Ratios*
tab dif_too_large_3 wantlowerdifference
	di (1165+751)/18939 //  among those agree or strongly agree that differences in income are too large, only 10 percent provide perceived and ideal ratios that are inconsistent with their stated views
	di 1341/1940 // , among those who disagree or strongly disagree that income differences are too large, 69 percent provide perceived and ideal ratios that do not accurately reflect that view.  
tab dif_too_large_3 wantlowerdifference, col chi

graph bar, 	over(dif_too_large_3, axis(off)) asyvars ///
			bar(1, fcolor(gs16) lcolor(black)) bar(2, fcolor(gs8) lcolor(black)) bar(3, fcolor(gs2) lcolor(black)) blabel(total, format(%9.0f)) ///
			ytitle(" ")  yscale(lcolor(gs14)) ///
			ylabel(0 "0%" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%" 60 "60%" 70 "70%" 80 "80%" 90 "90%" 100 "100%", angle(horizontal) noticks  gmax tlcolor(white)) ///
			by(, title("Figure 1: Lack of Correspondence Between Semantic" "Assessment of Income Differences and Pay Ratios", span) ///
			subtitle(, position(6)) ///
			caption(" " "Note: Bars represent the percentages that answered as indicated on the semantic questions about whether income" "differences are too large (Conditional on their answers regarding Ideal and Perceived pay ratios).", size(small)) ///
			note("                              (n=1,627)                                             (n=1,300)                                           (n=20,169)", size(small) justification(center))) ///
			by(, legend(on position(12))) legend(rows(1) size(small) title(`" {it:"Income differences are too large"} "', size(medsmall))) by(, clegend(on position(12))) ///
			by(, graphregion(margin(zero) lcolor(none))) by(wantlowerdifference, style(default) imargin(zero) rows(1)) subtitle(, position(6) nobox) graphregion(lcolor(none) ilcolor(none)) plotregion(lcolor(none) ilcolor(none))
graph export Figure1.pdf, replace

*********       
*THE END*
*********

log close
