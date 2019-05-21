** Note -- all analysis conducted with Stata/SE 12.1 for Mac
*  Only additional package is SPost for Stata. Used for calculating predicted probability changes  (accessible via "Findit SPOST")


******** demographic comparisons -- TABLE SI1 in the Appendix

** Start with the master data

collapse (mean) per_white per_black per_hispanic md_hhinc poverty per_owner, by(TreatmentGroup)

** The collapsed data (accessed via "Edit" in Stata) are the demographic by treatment that we report in Table SI 1 in the appendix.




*********************** Unmodeled / straightforward Results -- UnModeled Point Estimates With Standard Errors  -- (Figures 1-3 and SI 1)
*First by six treatments, and then by three racial/ethnic groups. 
*Followed by analysis of Hispanic sounding respondent names


* Start with master data


*"Collapse" by treatment condition to create Standard Error Graphs by Treatment Group (6 categories) -- (create point estimates and standard errors for each of the three variables across the six conditions) 


collapse (mean) Response_Dichotomous ProperName Respond24 (sebinomial) SEResponse_Dichotomous = Response_Dichotomous SEProperName=ProperName SERespond24=Respond24, by(NumberAssignment)




* Make the graphs

set scheme s1color

* Fig 1 (left panel) - Responsiveness by treatment  -- NOTE (varibale is coded NA (".") in a small number of cases in which emails were bounced back by bad addresses
serrbar Response_Dichotomous SEResponse_Dichotomous NumberAssignment, scale(1.96) mvopts(mcolor(black) msize(large) msymbol(circle) mlabel(NumberAssignment) mlabposition(2) mlabcolor(blue)) ytitle(Proportion Getting a Response) yscale(range(0 1)) ylabel(0(.2)1) xtitle(Treatment Group) xscale(range(.5 6.5)) xlabel(none) lwidth(medium) lcolor(gray)

* Fig SI1 (left panel) Responsiveness in 24 hours by treatment
serrbar Respond24 SERespond24 NumberAssignment, scale(1.96) mvopts(mcolor(black) msize(large) msymbol(circle) mlabel(NumberAssignment) mlabposition(2) mlabcolor(blue)) ytitle(Proportion of Responses Within 24 Hours) yscale(range(0 1)) ylabel(0(.2)1) xtitle(Treatment Group) xscale(range(.5 6.5)) xlabel(none) lwidth(medium) lcolor(gray)

* Fig 2 (left panel) named greeting by treatment
serrbar ProperName SEProperName NumberAssignment, scale(1.96) mvopts(mcolor(black) msize(large) msymbol(circle) mlabel(NumberAssignment) mlabposition(2) mlabcolor(blue)) ytitle(Proportion Getting a Response Using a Proper Name) yscale(range(0 1)) ylabel(0(.2)1) xtitle(Treatment Group) xscale(range(.5 6.5)) xlabel(none) lwidth(medium) lcolor(gray)



*Same thing, but now consolidated by sex (three race/ethnic groups) for summary graphs 

*START with the master data set (not the collapsed version from previous analysis)


* Convert the six treatment conditions  ( 3 races x M/F) into three racial groups by consolidating 

gen race = 0
replace race = 1 if NumberAssignment==3
replace race = 1 if NumberAssignment==4
replace race = 2 if NumberAssignment==5
replace race = 2 if NumberAssignment==6

label define race 0 "Black" 
label define race 1 "Hispanic", add
label define race 2 "White", add

label values race race

collapse (mean) Response_Dichotomous ProperName Respond24 (sebinomial) SEResponse_Dichotomous = Response_Dichotomous SEProperName=ProperName SERespond24=Respond24, by(race)


** Make graphs
set scheme s1color

* Fig 1 (right panel) - Responsiveness by race/ethnicity

serrbar Response_Dichotomous SEResponse_Dichotomous race, scale(1.96) mvopts(mcolor(black) msize(large) msymbol(circle) mlabel(race) mlabposition(2) mlabcolor(blue)) ytitle(Proportion Getting a Response) yscale(range(0 1)) ylabel(0(.2)1) xtitle(Treatment Group) xscale(range(.5 2.5)) xlabel(none)  lwidth(medium) lcolor(gray) xsc(r(-.5 2.5))

* Fig SI 1 (right panel) responsiveness in 24 hours by race/ethnicity

serrbar Respond24 SERespond24 race, scale(1.96) mvopts(mcolor(black) msize(large) msymbol(circle) mlabel(race) mlabposition(2) mlabcolor(blue)) ytitle(Proportion of Responses Within 24 Hours) yscale(range(0 1)) ylabel(0(.2)1) xtitle(Treatment Group) xscale(range(.5 2.5)) xlabel(none)  lwidth(medium) lcolor(gray) xsc(r(-.5 2.5))

* Fig 2 (right panel) named greeting by race/ethnicity

serrbar ProperName SEProperName race, scale(1.96) mvopts(mcolor(black) msize(large) msymbol(circle) mlabel(race) mlabposition(2) mlabcolor(blue)) ytitle(Proportion Getting a Response Using a Proper Name) yscale(range(0 1)) ylabel(0(.2)1) xtitle(Treatment Group) xscale(range(.5 2.5)) xlabel(none)  lwidth(medium) lcolor(gray) xsc(r(-.5 2.5))




*Identifying the race/ethnicity of the housing official that responded (Hispanic only as explained in the text) - section 4.2 and Figure 3

* Note, this analysis is out of order (comes later in the paper than it does in this code) because it requires collapsing the data to make a graph. It's easier to get all of the collapsing out of the way to avoid having to keep reloading and prepping the data


*START with master data

* Basic tabulation of % of responses to white, black and Hispanic treatments that came from Hispanic housing officials -- Middle of page 21 in text 

gen race = 0
replace race = 1 if NumberAssignment==3
replace race = 1 if NumberAssignment==4
replace race = 2 if NumberAssignment==5
replace race = 2 if NumberAssignment==6

label define race 0 "Black" 
label define race 1 "Hispanic", add
label define race 2 "White", add

label values race race


tabulate HispanicEmailer race, column chi2

** tabluation of likelihood of response coming within 24 hours -- Hispanic housing official vs. Non Hispanic Housing official by each of the three race treatments
* page 21 in text

tabulate Respond24 race if HispanicEmailer==1, column chi2


** Need to collapse observations in which a Hispanic Emailer replied by the race/ethnicity of the treatment 


collapse (mean) Response_Dichotomous ProperName (sebinomial) SEResponse_Dichotomous = Response_Dichotomous SEProperName=ProperName if HispanicEmailer==1, by(race)


* generating graph -- FIGURE 3 

set scheme s1color


serrbar ProperName SEProperName race, scale(1.96) mvopts(mcolor(black) msize(large) msymbol(circle) mlabel(race) mlabposition(2) mlabcolor(blue)) ytitle(Proportion Getting a Response Using a Proper Name) yscale(range(0 1)) ylabel(0(.2)1) xtitle(Treatment Group) xscale(range(-.5 2.5)) xlabel(none) lwidth(medium) lcolor(gray) xsc(r(-.5 2.5))





****Statistical Models and other results



* Once again START with the master data (not he collapsed data used to make the standard error plots above)




**** Prepare variables for statistical models


** Generate race/ethnic group of treatment variables -- Note, the ordering has changed from above to make "white" the easy baseline in the models  


gen race = 0
replace race = 1 if NumberAssignment==1
replace race = 1 if NumberAssignment==2
replace race = 2 if NumberAssignment==3
replace race = 2 if NumberAssignment==4

label define race 1 "Black" 
label define race 2 "Hispanic", add
label define race 0 "White", add

label values race race





*****generate M/F and group indicators

gen male=0
replace male =1 if NumberAssignment==1
replace male =1 if NumberAssignment==3
replace male =1 if NumberAssignment==5

label define male 1 "Male" 
label define male 0 "Female", add

label values male male
















**Clean up community-demographic variables

gen pov_rate = poverty/100

gen Log_Population = log(total) 



******* Results and Analysis

* Chi^2 result reported in first paragraph of section 4
tab Response_Dichotomous NumberAssignment if Response_Dichotomous!=., col chi2




****************LOGIT MODELS and LIKELIHOOD RATIO TESTS


***** Table 1 Models , racial/ethnic group variables consolidated by gender


* Model 1, Response DV
xi: logit Response_Dichotomous i.race per_black per_hispanic pov_rate Log_Population HardEmail


*** likelihood ratio test -  for model 1 -- Result referenced in text, p 17 near the bottom -- Model with demographics compared to model with demographics and indicators for race/ethnicity of emailer
xi: logit Response_Dichotomous per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m1

xi: logit Response_Dichotomous i.race per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m2

lrtest m1 m2

*Model 2, 24 Hour Response DV

xi: logit Respond24 i.race per_black per_hispanic pov_rate Log_Population HardEmail


* likelihood ratio test for model (2)  Not in paper
xi: logit Respond24 per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m3

xi: logit Respond24 i.race per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m4

lrtest m3 m4


** Model 3, Proper Name DV



xi: logit ProperName i.race per_black per_hispanic pov_rate Log_Population HardEmail


*** Predicted probability change: Moving from white to hispanic treatment.  Named greeting DV --- Result in text, bottom paragraph page 20

prvalue if e(sample), x(_Irace_1==0 _Irace_2==0) rest(mean) save
prvalue if e(sample), x(_Irace_1==0 _Irace_2==1) rest(mean) diff







***** Calculating Likelihood Ratio tests and estimating logit models without consolidating gender and race/ethnicity of treatment -- TABLES SI2-SI4



* Table SI 2 and likelihood ratio test

logit Response_Dichotomous i.male i.race male#race

logit Response_Dichotomous per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m1

logit Response_Dichotomous i.male i.race male#race per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m2

lrtest m1 m2



** SI 3 and likelihood ratio test

logit Respond24 i.male i.race male#race


logit Respond24 per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m3

logit Respond24 i.male i.race male#race per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m4

lrtest m3 m4




** SI 4 and likelihood ratio test

logit ProperName i.male i.race male#race


logit ProperName per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m5

logit ProperName i.male i.race male#race per_black per_hispanic pov_rate Log_Population HardEmail
estimates store m6

lrtest m5 m6






***** Checking that the main results are robust to including the professionalism scores -- FOOTNOTE 10


xi: logit Response_Dichotomous i.race per_black per_hispanic pov_rate Log_Population HardEmail AssesmentScore
xi: logit Respond24 i.race per_black per_hispanic pov_rate Log_Population HardEmail AssesmentScore
xi: logit ProperName i.race per_black per_hispanic pov_rate Log_Population HardEmail AssesmentScore


**** "truncated by death analysis" -- recoding all non responses as "unfriendly"  -- FOOTNOTE 11


gen ProperName_D=0
replace ProperName_D = 1 if ProperName==1

tab ProperName_D race, col chi2




*** Two other supplemental analyses both noted on page 18

*1) Did they provide waitlist info more or less often by race/ethnicity (bottom of page 18)

gen waitlist_info = 1
replace waitlist_info = 0 if WaitListFinal== "NA"
replace waitlist_info = . if Response_Dichotomous == 0 

tab waitlist_info race, col chi2


* 2) summary of racial/ethnic demographics of the comunities in the data set, indirect refutation of the possibility that black officials help blacks and vice versa. Page 18 top

mean per_black
mean per_white
mean per_hispanic









***** Focusing on community demgraphics, high, medium, and low black, white, and Hispanic areas (Tables SI 5 and 6, and Figure 4)


** To split the continuous "percent white" variable into thirds 
*first identify the cut points

_pctile per_white, p(33.333, 66.667)
return list

* Rsults pasted here, bottom third goes to 59.4%, top third starts at 82.5% 
r(r1) =  .594467145
r(r2) =  .825479285

* Use these cut points to generate indicators for top, middle, and bottom third white

gen white_pop_third = 2
replace white_pop_third = 1 if per_white < .594467145
replace white_pop_third = 3 if per_white > .825479285
replace white_pop_third = . if per_white==.

label define third 1 "Lower Third",
label define third 2 "Middle Third", add
label define third 3 "Top Third", add

label values white_pop_third third

** Repeat for percent black

_pctile per_black, p(33.333, 66.667)
return list

r(r1) =  .024659765
r(r2) =  .129531332


gen black_pop_third = 2
replace black_pop_third = 1 if per_black < .024659765
replace black_pop_third = 3 if per_black > .129531332
replace black_pop_third = . if per_black==.





label values black_pop_third third


*Repeat for percent Hispanic

_pctile per_hispanic, p(33.333, 66.667)
return list

 r(r1) =  .034627547
 r(r2) =  .112923659


gen hispanic_pop_third = 2
replace hispanic_pop_third = 1 if per_hispanic < .034627547
replace hispanic_pop_third = 3 if per_hispanic > .112923659
replace hispanic_pop_third = . if per_hispanic==.
				 
label values hispanic_pop_third third				 




* Models for Responsiveness DV -- Table SI5 and Figure 4 (left panel) -- Models include these "1/3" variables and are estimated separately for the three racial/ethnic treatments

*Column 1 (white treatment names)
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==0
*Column 2 (black treatment names)
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==1
*Column 3 (Hispanic treatment names)
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==2




* Calculate the Predicted Probability Change when moving from a community in the bottom third to one in the top third
*Results reported in Figure 4 Left Panel (constructed manually in powerpoint)
** For all of the predicted probabilities, the number on the graphs is the "change" estimate (the change in predicted probabilty) and the confidence interval is the confidence interval around this difference
* this function (the prvalue) is in the SPost Package for Stata



* Bottom to top third black population: white names
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==0
prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: black names
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==1

prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: Hispanic names
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==2


prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff


* Bottom to top third Hispanic population: white names

xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==0
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

* Bottom to top third Hispanic population: black names

xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

* Bottom to top third Hispanic population: Hispanic names

xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff



*** Same analysis but using the "proper name greeting" dependent variable (Table SI6 and Figure 4 (right panel))
*Uses same 1/3 cutoffs as prior analysis

*Column 1 (white treatment names)
xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==0
*Column 2 (black treatment names)
xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==1
*Column 1 (Hispanic treatment names)
xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==2






** Same as above (now using proper name greeting DV), predicted probabilities to produce the results reported in Figure 4 (right panel)


* Bottom to top third black population: white names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==0
prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: black names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==1

prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: hispanic names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==2


prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff


* Bottom to top third Hispanic population: white names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==0
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

* Bottom to top third Hispanic population: black names

xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

** Bottom to top third Hispanic population: Hispanic names

xi: logit ProperName i.black_pop_third i.hispanic_pop_third pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff


******* Robustness Check, Using 4ths and 5ths of the population instead of 1/3s as in the previous analysis. 
*These robustness checks for the responsiveness variable and the proper name variable are briefly mentioned in the text at the bottom of page 23 and top of page 24


*** The steps and procedures are identical to the prior analsysis after breaking community "percent white" "percent black" and "percent Hispanic" into 1/4s and 1/5s instead of 1/3s
* See the 1/3s analysis just annodated in depth for details
 
 ** Create the 1/4 variables and 1/5s variables
 
 * derive the cut points for 1/4s (25 (r2) and 75 (r3)  and 1/5s ( 20 (r1) and 80 (r4) -- repeat for black and Hispanic below 
_pctile per_white, p(20, 25, 75, 80)
return list

* the cutpoints - pasted here
 r(r1) =  .4633148285
                 r(r2) =  .507822021
                 r(r3) =  .860829327
                 r(r4) =  .8825434785


gen white_pop_fourth = 2	
replace white_pop_fourth = 1 if per_white < .507822021
replace white_pop_fourth = 3 if per_white > .860829327
replace white_pop_fourth = . if per_white==.

label define fourth 1 "Lower Fourth",
label define fourth 2 "Middle", add
label define fourth 3 "Top Fourth", add

label values white_pop_fourth fourth


gen white_pop_fifth = 2	
replace white_pop_fifth = 1 if per_white < .4633148285
replace white_pop_fifth = 3 if per_white > .8825434785
replace white_pop_fifth = . if per_white==.

label define fifth 1 "Lower Fifth",
label define fifth 2 "Middle", add
label define fifth 3 "Top Fifth", add

label values white_pop_fifth fifth


_pctile per_black, p(20, 25, 75, 80)
return list

 r(r1) =  .0119928105
                 r(r2) =  .016198754
                 r(r3) =  .1980862875
                 r(r4) =  .2488313745



gen black_pop_fourth = 2	
replace black_pop_fourth = 1 if per_black < .016198754
replace black_pop_fourth = 3 if per_black > .1980862875
replace black_pop_fourth = . if per_black==.



label values black_pop_fourth fourth


gen black_pop_fifth = 2	
replace black_pop_fifth = 1 if per_black < .0119928105
replace black_pop_fifth = 3 if per_black > .2488313745
replace black_pop_fifth = . if per_black==.



label values black_pop_fifth fifth


_pctile per_hispanic, p(20, 25, 75, 80)
return list

r(r1) =  .021695617
                 r(r2) =  .025742395
                 r(r3) =  .164593428
                 r(r4) =  .2186604785




gen hispanic_pop_fourth = 2	
replace hispanic_pop_fourth = 1 if per_hispanic < .025742395
replace hispanic_pop_fourth = 3 if per_hispanic > .164593428
replace hispanic_pop_fourth = . if per_hispanic==.



label values hispanic_pop_fourth fourth


gen hispanic_pop_fifth = 2	
replace hispanic_pop_fifth = 1 if per_hispanic < .021695617
replace hispanic_pop_fifth = 3 if per_hispanic > .2186604785
replace hispanic_pop_fifth = . if per_hispanic==.



label values hispanic_pop_fifth fifth



*** Responsiveness models using the top 1/4 and bottom 1/4 variables just created

xi: logit Response_Dichotomous i.black_pop_fourth i.hispanic_pop_fourth pov_rate Log_Population HardEmail if race ==0
xi: logit Response_Dichotomous i.black_pop_fourth i.hispanic_pop_fourth pov_rate Log_Population HardEmail if race ==1
xi: logit Response_Dichotomous i.black_pop_fourth i.hispanic_pop_fourth pov_rate Log_Population HardEmail if race ==2

*** Responsiveness models using the top 1/5 and bottom 1/5 variables just created

xi: logit Response_Dichotomous i.black_pop_fifth i.hispanic_pop_fifth pov_rate Log_Population HardEmail if race ==0
xi: logit Response_Dichotomous i.black_pop_fifth i.hispanic_pop_fifth pov_rate Log_Population HardEmail if race ==1
xi: logit Response_Dichotomous i.black_pop_fifth i.hispanic_pop_fifth pov_rate Log_Population HardEmail if race ==2


*** Proper Name models using the top 1/4 and bottom 1/4 variables just created


xi: logit ProperName i.black_pop_fourth i.hispanic_pop_fourth pov_rate Log_Population HardEmail if race ==0
xi: logit ProperName i.black_pop_fourth i.hispanic_pop_fourth pov_rate Log_Population HardEmail if race ==1
xi: logit ProperName i.black_pop_fourth i.hispanic_pop_fourth pov_rate Log_Population HardEmail if race ==2

*** Proper Name models using the top 1/5 and bottom 1/5 variables just created


xi: logit ProperName i.black_pop_fifth i.hispanic_pop_fifth pov_rate Log_Population HardEmail if race ==0
xi: logit ProperName i.black_pop_fifth i.hispanic_pop_fifth pov_rate Log_Population HardEmail if race ==1
xi: logit ProperName i.black_pop_fifth i.hispanic_pop_fifth pov_rate Log_Population HardEmail if race ==2












***** Focusing on "Theoretically revelant" community demographic combination categories (e.g. "high black and hispanic".... "high white, low everything else") - 
******* Analysis for Tables SI 7 and 8, and Figure 5 


*The four categories of focus are based on the top and bottom 1/3 (white, black, and Hispanic) created above.  

*Mainly white varible - top 1/3 white, bottom 1/3 black and Hispanic
gen MainlyWhite = 0
replace MainlyWhite =1 if white_pop_third==3 & black_pop_third==1 & hispanic_pop_third==1 
replace MainlyWhite = . if white_pop_third==.

* high black variable -  top third black, bottom third white and Hispanic
gen HighBlack = 0
replace HighBlack =1 if black_pop_third==3 & white_pop_third==1 & hispanic_pop_third==1 
replace HighBlack = . if black_pop_third==.

* high Hispanic varible - top 1/3 Hispanic , bottom 1/3 white, bottom 1/3 black

gen HighHispanic = 0
replace HighHispanic =1 if hispanic_pop_third==3 & white_pop_third==1 & black_pop_third==1 
replace HighHispanic = . if hispanic_pop_third==.


** High black and Hispanic, top 1/3 black AND top 1/3 Hispanic

gen HighBlackAndHispanic = 0
replace HighBlackAndHispanic =1 if hispanic_pop_third==3 & black_pop_third==3  
replace HighBlackAndHispanic = . if hispanic_pop_third==.


*Models for the did they respond DV, Table SI 7 (and Figure 5 below) 

* white emailers (column 1)
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==0
* black emailers (column 2)
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
* Hispanic emaliers (column 3)
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2


** Figure 5 (Left Panel) Using the same models to derive predicted probabilities of theoretically relevant comparisons (e.g. High White vs. High Black) -- 

*white emailer names model

* going from high white community to high black and Hispanic
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==0
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff
 
** black emailer names models

** going from high white community to high black 
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff

* going from high white community to high black and Hispanic

logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

* going from high Hispanic community to high black 

logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff



**Hispanic emailer names models 

** going from high white community to Hispanic black 

logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff

** going from high white community to high black and Hispanic 

logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

** going from high black community to high Hispanic 

logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff



*** Same analysis but using the proper name greeting dependent variable (Table SI 8 and Figure 5 (right panel)

** Models for table SI 8

* white emailers (column 1)
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==0
* black emailers (column 2)
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
*hispanic emailers (column 3)
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2


** Figure 5 (Right Panel) Using the same models to derive predicted probabilities of theoretically relevant comparisons (e.g. High White vs. High Black) -- 

*white emailer names model

* going from high white community to high black and Hispanic


logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==0
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff
 

*black emailer names model

* going from high white community to high black 

logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff

* going from high white community to high black and Hispanic

logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

* going from high Hispanic community to high black 
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff



*Hispanic emailer names model

* going from high white community to high Hispanic 
 
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff

* going from high white community to high black and Hispanic

logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

* going from high black community to high Hispanic

logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff



** Robustness check -- using top and bottom 1/4 cutoffs instead of 1/3s to identify the cities that fit into each catetory 
*This robustness check is mentioned in the text at the bottom of page 25
* Everything here is identical to the previous section except we use the 1/4 cutoffs establed above to generate the "high white" "high black" etc. variables

gen MainlyWhite4 = 0
replace MainlyWhite4 =1 if white_pop_fourth==3 & black_pop_fourth==1 & hispanic_pop_fourth==1 
replace MainlyWhite4 = . if white_pop_fourth==.

gen HighBlack4 = 0
replace HighBlack4 =1 if black_pop_fourth==3 & white_pop_fourth==1 & hispanic_pop_fourth==1 
replace HighBlack4 = . if black_pop_fourth==.

gen HighHispanic4 = 0
replace HighHispanic4 =1 if hispanic_pop_fourth==3 & white_pop_fourth==1 & black_pop_fourth==1 
replace HighHispanic4 = . if hispanic_pop_fourth==.

gen HighBlackAndHispanic4 = 0
replace HighBlackAndHispanic4 =1 if hispanic_pop_fourth==3 & black_pop_fourth==3  
replace HighBlackAndHispanic4 = . if hispanic_pop_fourth==.



logit Response_Dichotomous MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==0
logit Response_Dichotomous MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==1
logit Response_Dichotomous MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==2



logit ProperName MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==0
logit ProperName MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==1
logit ProperName MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==2

logit ProperName MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite4==1 HighBlack4==0 HighHispanic4==0 HighBlackAndHispanic4==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite4==0 HighBlack4==0 HighHispanic4==1 HighBlackAndHispanic4==0) rest(mean) diff

logit ProperName MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite4==1 HighBlack4==0 HighHispanic4==0 HighBlackAndHispanic4==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite4==0 HighBlack4==0 HighHispanic4==0 HighBlackAndHispanic4==1) rest(mean) diff


logit ProperName MainlyWhite4 HighBlack4 HighHispanic4 HighBlackAndHispanic4 pov_rate Log_Population HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite4==0 HighBlack4==1 HighHispanic4==0 HighBlackAndHispanic4==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite4==0 HighBlack4==0 HighHispanic4==1 HighBlackAndHispanic4==0) rest(mean) diff







***** Using HUD Assessment Scores to differentiate "high performers" and "low performers" (HUDs own terminology e.g. over 89 = "high performer")

** Discussed in last paragraph before the paper's Conclusion section 
* In the paper we split the assessment scores into "high performer" and "low performer" (which is everything but high performer)

_pctile AssesmentScore, p(50)

return list

** Shows that median is 89 - this is also at the cut point for "high performer" status in the official definition


* create the high vs. low performer variable
gen performer = 0
replace performer = 1 if AssesmentScore >89
replace performer = . if AssesmentScore ==.
  


** test responsiveness by race/ethnicity by high or low performer

by race, sort : prtest Response_Dichotomous, by(performer)

by performer, sort : prtest Response_Dichotomous if race!=0, by(race)



** Robustness check -- break into three categories, (high, medium, amd low) instead of the two we did above, and then plot by race of emailer. 
* As mentioned in paper, shows similar pattern (increases with capacity, blacks doing better than Hispanics in high capacity housing authorities -- but less strong pattern than the high/low comparison



gen AssessmentGroup2 = AssesmentScore
recode   AssessmentGroup2 (min/79=1) (80/89=2) (90/99=3) 

label define Assessment2 1 "<80" 
label define Assessment2 2 "80-89", add
label define Assessment2 3 "90-99", add

label values AssessmentGroup2 Assessment2

graph bar (mean) Response_Dichotomous, over(AssessmentGroup2) over(race)



















*************** 	END OF REPLICATION CODE *********************

_pctile total, p(33.333, 66.667)
return list

* Rsults pasted here, bottom third goes to 59.4%, top third starts at 82.5% 
  r(r1) =  17573
                 r(r2) =  60008


* Use these cut points to generate indicators for top, middle, and bottom third white

gen total_pop_third = 2
replace total_pop_third = 1 if total < 17573
replace total_pop_third = 3 if total > 60008
replace total_pop_third = . if total ==.

label values total_pop_third third




_pctile poverty, p(33.333, 66.667)
return list

* Rsults pasted here, bottom third goes to 59.4%, top third starts at 82.5% 
r(r1) =  11.1
                 r(r2) =  16.5


* Use these cut points to generate indicators for top, middle, and bottom third white

gen poverty_pop_third = 2
replace poverty_pop_third = 1 if poverty < 11.1
replace poverty_pop_third = 3 if poverty > 16.5
replace poverty_pop_third = . if poverty ==.

label values total_pop_third third


* Model 1, response 

xi: logit Response_Dichotomous i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail  



*Model 2, 24 Hour Response DV

xi: logit Respond24 i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail

** Model 3, Proper Name DV



xi: logit ProperName i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail


