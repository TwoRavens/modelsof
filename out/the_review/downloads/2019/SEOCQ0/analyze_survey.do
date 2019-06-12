*##########################################################*
* Hobbs and Lajevardi                                      *
* Effects of Divisive Political Campaigns on the Day-to-Day*
* Segregation of Arab and Muslim Americans                 *
* Journal: American Political Science Review               *
* Stata Replication Code                                   *
* Tested on Stata 15.1                                     *
*##########################################################*

clear all
set more off
*Researcher should change directory to where they have stored the data e.g. cd "/Users/Nick/Desktop/Data/"*
*Researcher should make sure that they have already run "ssc install latab" and "ssc install estout" in stata for the latabstat and eststo functions

****************
****Table A8****
****************
use "June 2016 table A8.dta", replace
count /*At the outset, 280 people clicked on the survey link*/
tab consent /*Of these 280 people, 265 consented to the survey, and 15 did not*/
tab postmar9 /* Since postmar9 was the last question on the survey, we can see that 204 people completed the full survey.*/

use "Dec 2016 table A8.dta", replace
count /*289 people clicked on the December 2016 survey link*/

/*Next, we drop the 70 respondents SSI reported as not being Muslim as part of their investigation*/
drop if responseid == "R_yK3QFP3yC7ckfq9" 
drop if responseid == "R_3P6N4EEZixlApKL"
drop if responseid == "R_77c8piMBDQAbd61"
drop if responseid == "R_TopiGROAEi3pX9f"
drop if responseid == "R_RgJyxHqBpkfM3HH"
drop if responseid == "R_1et58eFIO3mCjTj"
drop if responseid == "R_1pMYR50XZNyhlmW"
drop if responseid == "R_3QDU4yRMTg4XhZ0"
drop if responseid == "R_C3826EdXO3DYWlz"
drop if responseid == "R_1QtrBCsR9MWFCPE"
drop if responseid == "R_31tJ7v2fLl9EVeI"
drop if responseid == "R_3jeSCSCEbdXiOLH"
drop if responseid == "R_6ETcyLtyRcv77YR"
drop if responseid == "R_2UWAe6lqEWRc3uO"
drop if responseid == "R_10VLYIjku84vMAb"
drop if responseid == "R_3Elyocahmp655Wp"
drop if responseid == "R_2tzleIwCYbLylY8"
drop if responseid == "R_27ydyc97EcUQXuq"
drop if responseid == "R_3KOUCHht16RLjEs"
drop if responseid == "R_2UfJvfdP4pSNbQS"
drop if responseid == "R_71icmBJ1QOK6xtb"
drop if responseid == "R_tLFaF9GkMypD4Sl"
drop if responseid == "R_2uqWsbqUX6noiio"
drop if responseid == "R_Zt4E5ClTvBnx0hH"
drop if responseid == "R_qIs4XHP6F1YVkJ3"
drop if responseid == "R_3CZZ8KQXEj1siM3"
drop if responseid == "R_3M041Pp6DZXzikg"
drop if responseid == "R_2BePojCxZQI64bR"
drop if responseid == "R_O8U6Roap4xo8EgN"
drop if responseid == "R_248xligiMnllofm"
drop if responseid == "R_1pLRTAAcnXqT3Vx"
drop if responseid == "R_1Fy0bSoODPZpUmq"
drop if responseid == "R_8e7yH0kCVqeQacR"
drop if responseid == "R_3j87meibD8WA5BT"
drop if responseid == "R_XBMPEcUz3qjYuY1"
drop if responseid == "R_31KLxzBKpLJuLKa"
drop if responseid == "R_1DYxoliP9JlS5D5"
drop if responseid == "R_12rwU8PBZoy7PNX"
drop if responseid == "R_3m7t3EXGOKuxcmT"
drop if responseid == "R_1liVL3vH1WGFCU9"
drop if responseid == "R_bIXzSAV4e5sNFvj"
drop if responseid == "R_qwnpp1cf2w0ksTL"
drop if responseid == "R_3HFeTD7Eucws7ly"
drop if responseid == "R_2DRBtLXdnnuzDh6"
drop if responseid == "R_b3FDlegStufZviB"
drop if responseid == "R_O6zHmIKIZPYFACR"
drop if responseid == "R_2idG2S9VYJIfbVL"
drop if responseid == "R_3kBt38VtHTw15sn"
drop if responseid == "R_21zYFqP9DEmxDC4"
drop if responseid == "R_vxj65kJqsqSETPX"
drop if responseid == "R_3ejWjLAObLCqsrr"
drop if responseid == "R_20V7gP61WR9ZMri"
drop if responseid == "R_2YgHJ8Ky76uV8ju"
drop if responseid == "R_24IAyzcbz8ijXzS"
drop if responseid == "R_ue8slypZ8xlhqEh"
drop if responseid == "R_2ZDNDBzVgF98aTO"
drop if responseid == "R_3oL0WwEDzO34HVb"
drop if responseid == "R_6ETVzFKOJb3xTeZ"
drop if responseid == "R_2tEDjkLwE2nTfuW"
drop if responseid == "R_2zD3kwjgI6WYH4a"
drop if responseid == "R_3svPZXHucfXVtmV"
drop if responseid == "R_3O34GsTZ3kzBcQe"
drop if responseid == "R_5C0Ri4SkHhKOyW1"
drop if responseid == "R_RyQ7aEFFpa6BYf7"
drop if responseid == "R_qEqCJ8660D3zxHH"
drop if responseid == "R_3RlSS5gTDVXhBG1"
drop if responseid == "R_23WAF10nDCRDGU8"
drop if responseid == "R_2zObQTexbq0bc3R"
drop if responseid == "R_2CrnIfOKsyq6qOr"
drop if responseid == "R_V4hilOtECRBv9Jf"

drop if consent != "I consent" /*We then drop any respondent who did not consent to taking the survey*/
drop if respondentmuslim =="No" /* Next we drop any respondent who self-reported that they were not Muslim*/

count /*We see that 169 respondents are left in the survey*/
tab postmar9 /*Once again, postmar9 is the last question in the survey. We can see that 149 poeple completed the survey*/

use "Feb 2017 tables A8-A9.dta", replace
count /*1,062 opened the survey link for the February 2017 survey*/
drop if consent =="I dont consent" /*Next, we drop anyone who did not consent to the survey.*/
tab respondentmuslim /*That leaves us with 230 individuals who selected "Islam" as their religion*/
drop if respondentmuslim != "Islam" /*We drop anyone who did not select Islam as their religion*/
tab postmar9 /*Since postmar9 was the last question on this survey as well, we can see that 204 individuals completed the survey*/



****************
****Table A9****
****************
use "Feb 2017 tables A8-A9.dta", replace
tab recordeddate1 /*We can see how many respondents took the February 2017 survey by date*/



*****************
****Table A10****
*****************
use "Feb 2017 tables a10-a12 fig a7.dta", replace
latabstat avoid1 avoid2 avoid3 avoid4, by(mosqueatt2) stat(mean sd min max count) col(stat) long /*Here we obtain summary statistics for the four avoidance statements for those with high and low religiosity*/
latabstat avoid1 avoid2 avoid3 avoid4, by(linkedfate2) stat(mean sd min max count) col(stat) long /*Next we obtain summary statistics for the four avoidance statements for those with high and low linked fate*/
latabstat avoid1 avoid2 avoid3 avoid4, stat(mean sd min max count) col(stat) long /*Finally, we obtain summary statistics for the four avoidance statements for the full sample*/


*****************
****Figure A7****
*****************
use "Feb 2017 tables a10-a12 fig a7.dta", replace
*This code creates the histogram on the lefthand side of Figure A7, and displays the mean values of avoidance statements by religiosity
	graph bar (mean) avoid1 avoid2 avoid3 avoid4, ///
	bargap(5) ///
	graphregion(color(white)) ///
	over(mosqueatt2, gap(50) label(angle(45))) /// 
	ytitle("Mean Value of Avoidance Statement") ///
	ylabel(, angle(horizontal)) ///
	bar(1, color(blue*0.4)) bar(2, color(purple*0.4)) ///
	legend(label(1 "AS 1") label(2 "AS 2") label(3 "AS 3") label(4 "AS 4") rows(4) ring(0) pos(-5) region(lcolor(white))) ///
	title("Religiosity") ///
	nofill
	graph export gdp-bar.png, width(1200) replace
	graph save Graph "mygraph1.gph", replace

*This code creates the histogram on the righthand side of Figure A7, and displays the mean values of avoidance statements by linked fate
	graph bar (mean) avoid1 avoid2 avoid3 avoid4, ///
	bargap(5) ///
	graphregion(color(white)) ///
	over(linkedfate2, gap(50) label(angle(45)))  /// 
	ytitle("Mean Value of Avoidance Statement") ///
	ylabel(, angle(horizontal)) ///
	bar(1, color(blue*0.4)) bar(2, color(purple*0.4)) ///
	legend(label(1 "AS 1") label(2 "AS 2") label(3 "AS 3") label(4 "AS 4") rows(4) ring(0) pos(-5) region(lcolor(white))) ///
	title("Linked Fate") ///
	nofill
	graph export gdp-bar.png, width(1200) replace
	graph save Graph "mygraph2.gph", replace

		*legend(label(1 "Avoidance Statement 1") label(2 "Avoidance Statement 2") label(3 "Avoidance Statement 3") label(4 "Avoidance Statement 4") rows(2) ring(0) pos(-10) region(lcolor(white))) ///

*This next code combines the two histograms into one figure
	graph combine mygraph1.gph mygraph2.gph,scheme(sj) commonscheme

*****************
****Table A11****
*****************
use "Feb 2017 tables a10-a12 fig a7.dta", replace

*Examining aggregate societal discrimination and aggregate political discrimination as predictors of avoidance 
eststo clear
quietly eststo: reg avoid1 agg_sd agg_pd 
quietly eststo: reg avoid2 agg_sd agg_pd 
quietly eststo: reg avoid3 agg_sd agg_pd 
quietly eststo: reg avoid4 agg_sd agg_pd
esttab, r2
esttab using tablea11.tex, se ar2 replace		

*****************
****Table A12****
*****************
use "Feb 2017 tables a10-a12 fig a7.dta", replace

*Examining aggregate societal discrimination and aggregate political discrimination as predictors of avoidance with controls
eststo clear
quietly eststo: reg avoid1 agg_sd agg_pd male white age income educ democrat independent citizen
quietly eststo: reg avoid2 agg_sd agg_pd male white age income educ democrat independent citizen
quietly eststo: reg avoid3 agg_sd agg_pd male white age income educ democrat independent citizen
quietly eststo: reg avoid4 agg_sd agg_pd male white age income educ democrat independent citizen
esttab, r2
esttab using tablea12.tex, se ar2 replace		










