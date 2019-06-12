** Note -- This code produces approximations of the main results in the paper (everything in the tables and figures and a few additional results)
* It does so using top/middle/bottom third of the distribution variables for population, poverty rate, percent black, percent Hispanic and HUD Assesment Score. 
* This allows for public replication of the substantive results while blinding the community level variables (included as continuous variables in the real analysis) that would publicly identify the observations when match to the census
* The straight experimental results do not depend on these demographic indicators and thus directly replicate results
** Note -- all analysis conducted with Stata/SE 12.1 for Mac
*  Only additional package is SPost for Stata. Used for calculating predicted probability changes  (accessible via "Findit SPOST")






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







*** Statistical models using the "1/3" variables to blind continuous/identifying census demographic data


* Once again START with the master data 






** Prepare variables Race and sex


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



*** Basic models subbing in 1/3s for percent black, percent hispanic, population, and poverty rate (Table 1) 



* Model 1, response 

xi: logit Response_Dichotomous i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail  



*Model 2, 24 Hour Response DV

xi: logit Respond24 i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail

** Model 3, Proper Name DV -- including predicted probability (section 4.1)


xi: logit ProperName i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail

prvalue if e(sample), x(_Irace_1==0 _Irace_2==0) rest(mean) save
prvalue if e(sample), x(_Irace_1==0 _Irace_2==1) rest(mean) diff



***** Calculating Likelihood Ratio tests and estimating logit models without consolidating gender and race/ethnicity of treatment -- TABLES SI2-SI4



* Table SI 2 and likelihood ratio test

logit Response_Dichotomous i.male i.race male#race

logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail
estimates store m1

logit Response_Dichotomous i.male i.race male#race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail
estimates store m2

lrtest m1 m2



** SI 3 and likelihood ratio test

logit Respond24 i.male i.race male#race


logit Respond24 i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail
estimates store m3

logit Respond24 i.male i.race male#race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmailestimates store m4

lrtest m3 m4




** SI 4 and likelihood ratio test

logit ProperName i.male i.race male#race


logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail
estimates store m5

logit ProperName i.male i.race male#race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail
estimates store m6

lrtest m5 m6




***** Checking that the main results are robust to including the professionalism scores -- FOOTNOTE 10


xi: logit Response_Dichotomous i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail i.assesment_third
xi: logit Respond24 i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail i.assesment_third
xi: logit ProperName i.race i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail i.assesment_third



***** Focusing on community demgraphics, high, medium, and low black, white, and Hispanic areas (Tables SI 5 and 6, and Figure 4)
** These results in the paper already use top/mid/bottom third by race. Only change is subbing in population and poverty rate by thirds

* Models for Responsiveness DV -- Table SI5 and Figure 4 (left panel) -- Models include these "1/3" variables and are estimated separately for the three racial/ethnic treatments

*Column 1 (white treatment names)
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==0
*Column 2 (black treatment names)
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==1
*Column 3 (Hispanic treatment names)
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==2




* Calculate the Predicted Probability Change when moving from a community in the bottom third to one in the top third
*Results reported in Figure 4 Left Panel (constructed manually in powerpoint)
** For all of the predicted probabilities, the number on the graphs is the "change" estimate (the change in predicted probabilty) and the confidence interval is the confidence interval around this difference
* this function (the prvalue) is in the SPost Package for Stata



* Bottom to top third black population: white names
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==0
prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: black names
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==1

prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: Hispanic names
xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==2


prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff


* Bottom to top third Hispanic population: white names

xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==0
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

* Bottom to top third Hispanic population: black names

xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

* Bottom to top third Hispanic population: Hispanic names

xi: logit Response_Dichotomous i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff



*** Same analysis but using the "proper name greeting" dependent variable (Table SI6 and Figure 4 (right panel))
*Uses same 1/3 cutoffs as prior analysis

*Column 1 (white treatment names)
xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==0
*Column 2 (black treatment names)
xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==1
*Column 1 (Hispanic treatment names)
xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==2






** Same as above (now using proper name greeting DV), predicted probabilities to produce the results reported in Figure 4 (right panel)


* Bottom to top third black population: white names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==0
prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: black names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==1

prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff

* Bottom to top third black population: hispanic names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==2


prvalue if e(sample), x(_Iblack_pop_3==0 _Iblack_pop_2==0) rest(mean) save
prvalue if e(sample), x(_Iblack_pop_3==1 _Iblack_pop_2==0) rest(mean) diff


* Bottom to top third Hispanic population: white names
xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==0
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

* Bottom to top third Hispanic population: black names

xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff

** Bottom to top third Hispanic population: Hispanic names

xi: logit ProperName i.black_pop_third i.hispanic_pop_third i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(_Ihispanic__3==0 _Ihispanic__2==0) rest(mean) save
prvalue if e(sample), x(_Ihispanic__3==1 _Ihispanic__2==0) rest(mean) diff




***** Focusing on "Theoretically revelant" community demographic combination categories (e.g. "high black and hispanic".... "high white, low everything else") - 
******* Analysis for Tables SI 7 and 8, and Figure 5 


*The four categories of focus are based on the top and bottom 1/3 (white, black, and Hispanic)  

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
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==0
* black emailers (column 2)
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
* Hispanic emaliers (column 3)
logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2


** Figure 5 (Left Panel) Using the same models to derive predicted probabilities of theoretically relevant comparisons (e.g. High White vs. High Black) -- 

*white emailer names model

* going from high white community to high black and Hispanic
xi: logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==0
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff
 
** black emailer names models

** going from high white community to high black 
xi: logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff

* going from high white community to high black and Hispanic

xi: logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

* going from high Hispanic community to high black 

xi: logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff



**Hispanic emailer names models 

** going from high white community to Hispanic black 

xi: logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff

** going from high white community to high black and Hispanic 

xi: logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

** going from high black community to high Hispanic 

xi: logit Response_Dichotomous MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff



*** Same analysis but using the proper name greeting dependent variable (Table SI 8 and Figure 5 (right panel)

** Models for table SI 8

* white emailers (column 1)
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==0
* black emailers (column 2)
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
*hispanic emailers (column 3)
logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2


** Figure 5 (Right Panel) Using the same models to derive predicted probabilities of theoretically relevant comparisons (e.g. High White vs. High Black) -- 

*white emailer names model

* going from high white community to high black and Hispanic


xi: logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==0
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff
 

*black emailer names model

* going from high white community to high black 

xi: logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff

* going from high white community to high black and Hispanic

xi: logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

* going from high Hispanic community to high black 
xi: logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==1
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) diff



*Hispanic emailer names model

* going from high white community to high Hispanic 
 
xi: logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff

* going from high white community to high black and Hispanic

xi: logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==1 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==0 HighBlackAndHispanic==1) rest(mean) diff

* going from high black community to high Hispanic

xi: logit ProperName MainlyWhite HighBlack HighHispanic HighBlackAndHispanic i.total_pop_third i.poverty_pop_third HardEmail if race ==2
prvalue if e(sample), x(MainlyWhite==0 HighBlack==1 HighHispanic==0 HighBlackAndHispanic==0) rest(mean) save
prvalue if e(sample), x(MainlyWhite==0 HighBlack==0 HighHispanic==1 HighBlackAndHispanic==0) rest(mean) diff




