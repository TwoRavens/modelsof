/*

Replication file for 
Ryan Enos and Eitan Hersh (2015)
"Campaign Perceptions of Electoral Closeness: Uncertainty, Fear, and Over-Confidence"
British Journal of Political Science



NOTE: To protect the identity of individual respondents and individual down-ballot campaigns, 
the main data file, replication_data.dta, has been scraped of identifying fields. Therefore, 
this do-file, when used with the public version of the data, will not replicate many figures and tables.
This is because the state of the campaign and the vote share of specific candidates, is sufficient to
identify down-ballot respondetnts.
*/

cd "BJPS Replication Folder"

 
 u replication_data.dta, clear

gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100

gen dif_predict = abs(d_share-elect_gen) if committee != "Organizing for America"
replace dif_predict = abs(d_share-obama_st_1) if committee == "Organizing for America"

gen dif_predict2 = elect_gen-d_share if committee != "Organizing for America"
replace dif_predict2 = obama_st_1-d_share if committee == "Organizing for America"

gen overpredict_dem = 1 if dif_predict2 >0 & dif_predict2 != .
replace overpredict_dem = 0 if dif_predict2 <0 & dif_predict2 != .


**********
*Figure 1*
**********

*Stats discussed re: Figure 1
		ci dif_predict if committee != "Organizing for America"
		tab overpredict_dem if committee != "Organizing for America"

*Figure 1
twoway histogram dif_predict2 if committee != "Organizing for America", ///
 bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("Prediction Minus Dem. Vote Share", size(medlarge)) xsize(6) ysize(4) ///
 ytitle(Percent, size(medlarge)) title(Predictions of Down-Ballot Workers)  xlabel(-50(10)50, labsize(medlarge)) ///
 plotregion(style(none))  ylabel( , labsize(medlarge)) yscale(noextend) xscale(noextend) xline(0, lcolor(black)) ///
 caption(74% Over-Predict Democrat, size(medlarge)  position(2) ring(0) margin(medium)) ///
 note(26% Over-Predict Republican,  size(medlarge) position(10) ring(0) margin(medium)) 
 
**********
*Figure 2*
**********
 
 u replication_data.dta, clear

gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100

bysort camp_state: egen state_obama = mean(obama_st_1)
bysort camp_state: egen state_sample = count(obama_st_1)
bysort com_state: egen nonpres_predict = mean(elect_gen) if committee != "Organizing for America"
bysort com_state: egen cand_sample = count(elect_gen)

collapse (mean) nonpres_predict d_share d_inc, by(com_state)

 *black and white
 twoway (line d_share d_share, lc(gs12) lpattern(solid) lwidth(vthin)) ///
(scatter nonpres_predict d_share if d_inc == 0,  ms(circle_hollow) mc(gs8)) ///
(scatter nonpres_predict d_share if  d_inc ==1,  ms(circle) mc(black) ) ///
(scatteri 72 72 "Perfect Prediction", msymbol(i) color(gs12) mlabpos(0)  mlabangle(34) mlabsize(medium)), ///
yline(50, lcolor(gs5)) xline(50, lcolor(gs5)) xsize(8) ysize(6) ///
ytitle(Campaign Prediction of Democratic Vote Share) ylabel(25(10)85) xlabel(25(10)85) ///
  xtitle(Actual Democratic Vote Share) plotregion(style(none)) yscale(noextend) xscale(noextend) scheme(s1mono) ///
 legend( cols(1) order(3 "Incumbent Campaigns" 2 "Non-Incumbent Campaigns" ) position(5) ring(0) region (fcolor(none) lcolor(none)))  
 
**********
*Figure 3*
**********
 
 
 
 u replication_data.dta, clear

gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100

gen dif_predict = abs(d_share-elect_gen) if committee != "Organizing for America"
replace dif_predict = abs(d_share-obama_st_1) if committee == "Organizing for America"


gen paidstaff =1 if camp_role == 4 
recode paidstaff .=0
replace paidstaff = 1 if camp_role_text == "Candidate" | camp_role_text== "candidate"


gen presidential =1 if camp_type == 2
gen usfed = 1 if camp_type ==3 | camp_type == 5 
gen staterace = 1 if camp_type == 6 | camp_type == 9 | camp_type == 10 | camp_type == 4
recode presidential-staterace (.=0) 
gen campaign_other = 1 if presidential == 0 & usfed == 0 & staterace == 0 
recode campaign_other .=0


ci dif_predict if usfed == 1
ci dif_predict if staterace == 1
ci dif_predict if usfed == 1 & paid ==1 
ci dif_predict if staterace == 1 & paid ==1
ci dif_predict if usfed == 1 & paid ==0
ci dif_predict if staterace == 1 & paid ==0

*The statistics above are copied into a .csv file, called race_type_closeness.csv

insheet using race_type_closeness.csv, clear

gen cat = 1 if race == "state"
replace cat = 2 if race == "fed"
recode cat 1=1.1 2=2.1  if user == "paid"
recode cat 1=.9 2=1.9  if user == "vol"

twoway (rcap lb ub cat, lcolor(black))  ///
(scatter mean cat if user== "vol", mc(black) msize(medlarge) msymbol(square)) ///
(scatter mean cat if user== "all", mc(black) msize(medlarge) msymbol(triangle)) ///
(scatter mean cat if user == "paid", mc(black) msize(medlarge) msymbol(circle)), ///
xlabel(1 "State Races" 2 "Federal Races" , valuelabel labsize(medlarge)) xsize(3) ysize(4) ///
legend(  cols(3) order(2 "Volunteers" 3 "All" 4	  "Staff/Candidates" ) size(medium) region(fcolor(none) lcolor(none)))  ///
 xtitle(" ")plotregion(style(none)) ytitle(Mean Absolute Deviation, size(medlarge)) ylabel( , labsize(medlarge))
 
**********
*Figure 4*
**********
 u replication_data.dta, clear

 gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100


keep if committee != "Organizing for America"
	
	
gen dif_predict = abs(d_share-elect_gen) if committee != "Organizing for America"
replace dif_predict = abs(d_share-obama_st_1) if committee == "Organizing for America"

gen size_of_margin = abs(dem_cand-rep_cand)

 ci dif_predict if  size_of_margin >=0 & size_of_margin <5
 ci dif_predict if size_of_margin >=5 & size_of_margin <10
 ci dif_predict if  size_of_margin >=10 & size_of_margin <20
 ci dif_predict if  size_of_margin >=20 & size_of_margin != .

 *The statistics above are copied into a .csv file, called tossup_closeness.csv, which contains data
 *for both Figure 4 (down-ballot campaigns) and Figure 6 (Obama campaign).

bysort rcp: ci dif_predict 
 *The statistics above are copied into a .csv file, called tossup_closeness.csv, which contains data
 *for both Figure 4 (down-ballot campaigns) and Figure 6 (Obama campaign). Note RCP stands for 
 *RealClearPolitics, the source of our pre-election measure of competitiveness.
 
 
 insheet using "tossup_closeness.csv", clear

gen cat_ante = 3 if margin == "safe"
replace cat_ante = 2 if margin == "lean"
replace cat_ante  = 1 if margin == "tossup"

 
gen cat_post = 1 if margin == "0 to 5"
replace cat_post = 2 if margin == "5 to 10"
replace cat_post = 3 if margin == "10 to 20"
replace cat_post = 4 if margin == "20 plus"


twoway (rcap lb ub cat_ante if obama == 0, lcolor(black))  ///
(scatter mean cat_ante if obama ==0, mc(black) msize(medlarge) msymbol(circle_hollow)), ///
xlabel(1 "Toss-Up" 2 "Lean" 3 "Safe", valuelabel labsize(large)) ///
legend(off)  xscale(noextend) yscale(noextend) ylabel( , labsize(large)) ///
xtitle("RCP Pre-Election Categories", size(large)) plotregion(style(none)) ytitle("", size(zero)) subtitle({it:Ex Ante} Competitiveness, size(large)) 
 graph save exante_db.gph, replace
 

twoway (rcap lb ub cat_post if obama ==0 , lcolor(black))  ///
(scatter mean cat_post if obama == 0, mc(black) msize(medlarge) msymbol(circle_hollow)), ///
xlabel(1 "0-5" 2 "5-10" 3 "10-20" 4 "20+", valuelabel labsize(large))  xscale(noextend) yscale(noextend) ///
legend(off)   ylabel( , labsize(large)) ///
xtitle("Actual  Margin Between Dem. and Rep.", size(large)) plotregion(style(none)) ytitle("", size(zero)) subtitle({it:Ex Post} Measure of Competitiveness, size(large)) 
 graph save expost_db.gph, replace

 graph combine exante_db.gph expost_db.gph, col(2) l1title(Mean Absolute Deviation, size(medlarge)) ///
title(Predictions by Competitiveness in Down-Ballot Races, size(medlarge))  xsize(6) ysize(4)
 
 




**********
*Figure 5*
**********
 
 
 u replication_data.dta, clear

gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100

gen dif_predict = abs(d_share-elect_gen) if committee != "Organizing for America"
replace dif_predict = abs(d_share-obama_st_1) if committee == "Organizing for America"

gen dif_predict2 = elect_gen-d_share if committee != "Organizing for America"
replace dif_predict2 = obama_st_1-d_share if committee == "Organizing for America"

gen overpredict_dem = 1 if dif_predict2 >0 & dif_predict2 != .
replace overpredict_dem = 0 if dif_predict2 <0 & dif_predict2 != .


 *Stats discussed re: Figure 5
		ci dif_predict if committee == "Organizing for America"		
		tab overpredict_dem if committee == "Organizing for America"

*Figure 5 
histogram dif_predict2 if committee == "Organizing for America", ///
 bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("Prediction Minus State Vote Share", size(medlarge)) xsize(6) ysize(4)  ///
 ytitle(Percent, size(medlarge)) title(Predictions of Obama Workers) ylabel(0(10)40, labsize(medlarge)) xlabel(-50(10)50, labsize(medlarge)) ///
 caption(77% Over-Predict Obama, size(medlarge) position(2) ring(0) margin(medium)) ///
 note(23% Over-Predict Romney, size(medlarge) position(10) ring(0) margin(medium)) ///
 plotregion(style(none))  yscale(noextend) xscale(noextend) xline(0, lcolor(black))

**********
*Figure 6*
**********
 
 u replication_data.dta, clear

 gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100


keep if committee == "Organizing for America"
	
	
gen dif_predict = abs(d_share-elect_gen) if committee != "Organizing for America"
replace dif_predict = abs(d_share-obama_st_1) if committee == "Organizing for America"

gen size_of_margin = abs(dem_cand-rep_cand)

 ci dif_predict if  size_of_margin >=0 & size_of_margin <5
 ci dif_predict if size_of_margin >=5 & size_of_margin <10
 ci dif_predict if  size_of_margin >=10 & size_of_margin <20
 ci dif_predict if  size_of_margin >=20 & size_of_margin != .

 *The statistics above are copied into a .csv file, called tossup_closeness.csv, which contains data
 *for both Figure 4 (down-ballot campaigns) and Figure 6 (Obama campaign).

bysort rcp: ci dif_predict 
 *The statistics above are copied into a .csv file, called tossup_closeness.csv, which contains data
 *for both Figure 4 (down-ballot campaigns) and Figure 6 (Obama campaign). Note RCP stands for 
 *RealClearPolitics, the source of our pre-election measure of competitiveness.
 
 
 insheet using "tossup_closeness.csv", clear

gen cat_ante = 3 if margin == "safe"
replace cat_ante = 2 if margin == "lean"
replace cat_ante  = 1 if margin == "tossup"

 
gen cat_post = 1 if margin == "0 to 5"
replace cat_post = 2 if margin == "5 to 10"
replace cat_post = 3 if margin == "10 to 20"
replace cat_post = 4 if margin == "20 plus"


twoway (rcap lb ub cat_ante if obama == 1, lcolor(black))  ///
(scatter mean cat_ante if obama ==1, mc(black) msize(medlarge) msymbol(circle_hollow)), ///
xlabel(1 "Toss-Up" 2 "Lean" 3 "Safe", valuelabel labsize(large)) ///
legend(off)  xscale(noextend) yscale(noextend) ylabel( , labsize(large)) ///
xtitle("RCP Pre-Election Categories", size(large)) plotregion(style(none)) ytitle("", size(zero)) subtitle({it:Ex Ante} Competitiveness, size(large)) 
 graph save exante_ob.gph, replace
 

twoway (rcap lb ub cat_post if obama ==1 , lcolor(black))  ///
(scatter mean cat_post if obama == 1, mc(black) msize(medlarge) msymbol(circle_hollow)), ///
xlabel(1 "0-5" 2 "5-10" 3 "10-20" 4 "20+", valuelabel labsize(large))  xscale(noextend) yscale(noextend) ///
legend(off)   ylabel( , labsize(large)) ///
xtitle("Actual  Margin Between Dem. and Rep.", size(large)) plotregion(style(none)) ytitle("", size(zero)) subtitle({it:Ex Post} Measure of Competitiveness, size(large)) 
 graph save expost_ob.gph, replace

 graph combine exante_ob.gph expost_ob.gph, col(2) l1title(Mean Absolute Deviation, size(medlarge)) ///
title(Predictions by Competitiveness in the Presidential Contest, size(medlarge))  xsize(6) ysize(4)


**********
*Figure 7*
**********

u mass_public_survey, clear

gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100


gen dif_predict = abs(d_share-obama_st_pre)
gen dif_predict2 = (obama_st_pre-d_share)

gen dem = pid3 == 1
gen rep = pid3 == 2
gen party3 = pid3
recode party3 1=1 2=2 nonmis = 3

gen overpredict_dem = 1 if dif_predict2 >0 & dif_predict2 != .
replace overpredict_dem = 0 if dif_predict2 <0 & dif_predict2 != .


*Some relevant statistics
sum dif_predict [aw=weight]
*Ave. Absolute Deviation: 17 points
sum dif_predict2 [aw=weight]
sum dif_predict2 if dem == 1 [aw=weight], detail
sum dif_predict2 if rep == 1 [aw=weight], detail
tab party3 overpredi [aw=weight], row col
ci dif_predict if dem == 1 [aw=weight]
ci dif_predict if rep == 1 [aw=weight]
ci dif_predict if party3 == 3 [aw=weight]
 
 
histogram dif_predict2 if dem ==1, bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("", size(zero)) ///
 ytitle("", size(zero)) subtitle("Democrats")  ylabel(0(5)25) xlabel(-50(20)50, labsize(small)) ///
 text(24 20 "72% Over-Predict Obama", size(medsmall)) ///
 plotregion(style(none))  xline(0, lcolor(black)) xscale(noextend) yscale(noextend)	
 graph save dem_cces_hist.gph, replace
 
  histogram dif_predict2 if rep ==1, bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("", size(zero)) ///
 ytitle("", size(zero)) subtitle("Republicans") ylabel(0(5)25)  xlabel(-50(20)50, labsize(small)) ///
 text(24 20 "36% Over-Predict Obama", size(medsmall)) ///
 plotregion(style(none))  xline(0, lcolor(black)) xscale(noextend) yscale( off noextend)	
graph save rep_cces_hist.gph, replace

histogram dif_predict2 if party3==3, bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("", size(zero)) ///
 ytitle("", size(zero)) subtitle("Independents") ylabel(0(5)25) xlabel(-50(20)50, labsize(small)) ///
 text(24 20 "54% Over-Predict Obama", size(medsmall))  ///
 plotregion(style(none)) xline(0, lcolor(black)) xscale(noextend) yscale( off noextend)	
graph save ind_cces_hist.gph, replace

graph combine  dem_cces_hist.gph  rep_cces_hist.gph   ind_cces_hist.gph, ///
col(3) xsize(6) ysize(2) iscale(1.75) b1title(Prediction Minus State Vote Share, size(vlarge)) l1title(Percent, size(vlarge))

*********
*Table 1*
*********

 u replication_data.dta, clear

 gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100
	
gen dif_predict = abs(d_share-elect_gen) if committee != "Organizing for America"
replace dif_predict = abs(d_share-obama_st_1) if committee == "Organizing for America"

gen ob_vs_oth = 1 if committee == "Organizing for America" 
replace ob_vs_oth = 0 if committee != "Organizing for America"


gen veryliberal = ideology == 1
gen collegetrack = edu
recode collegetrack 5 6 = 1 1 2 3 4 =0 
replace collegetrack =1 if  edu <=3 & age <=22
gen college_justgrads = edu
recode college_justgrads 5 6 = 1 1 2 3 4 =0 

gen paidstaff =1 if camp_role == 4 
recode paidstaff .=0
replace paidstaff = 1 if camp_role_text == "Candidate" | camp_role_text== "candidate"

gen usfed = 1 if camp_type ==3 | camp_type == 5 
recode usfed .=0

ren weekly_obama_advantage_state ad_st
sort camp_state fullst
replace ad_st = ad_st[_n-1] if camp_state == camp_state[_n-1] & ad_st == .
gen state_lag2 = ad_st[_n-1] if ad_st != ad_st[_n-1] & camp_state == camp_state[_n-1]
replace state_lag2 = state_lag2[_n-1] if camp_state == camp_state[_n-1] & state_lag2 ==.
gen st_ad_change = ad_st-state_lag2

gen nov = 1 if monthstart == 11
gen oct = 1 if monthstart == 10
gen sept = 1 if monthstart == 9 
gen summer = 1 if monthstart <9
recode nov .=0 if monthstart != .
recode oct .=0 if monthstart != .
recode sept .=0 if monthstart != .
recode summer .=0 if monthstart != .

reg dif_predict  collegetrack paid verylib if ob_v == 1, vce(cluster camp_state)
outreg2 using models2.xls, excel dec(2) replace
reg dif_predict  collegetrack paid  verylib  n_polls if ob_v == 1, vce(cluster camp_state)
outreg2 using models2.xls, excel dec(2) append
reg dif_predict  collegetrack paid verylib  summer sept oct  n_polls st_ad_change if ob_v == 1, vce(cluster camp_state)
outreg2 using models2.xls, excel dec(2) append

reg dif_predict  collegetrack paid verylib if ob_v == 0, vce(cluster com_state)
outreg2 using models2.xls, excel dec(2) append
reg dif_predict  collegetrack paid verylib  n_polls summer sept oct d_inc usfed    if ob_v == 0, vce(cluster com_state)
outreg2 using models2.xls, excel dec(2) append
areg dif_predict  collegetrack paid verylib   summer sept oct d_inc usfed if ob_v == 0, a(camp_state)
outreg2 using models2.xls, excel dec(2) append



***************************
***************************
***************************
******APPENDIX*************
***************************
***************************
***************************

************
*Figure A.1*
************

 u replication_data.dta, clear

 gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100
	
gen ob_vs_oth = 1 if committee == "Organizing for America" 
replace ob_vs_oth = 0 if committee != "Organizing for America"

gen dif_predict2 = elect_gen-d_share if committee != "Organizing for America"
replace dif_predict2 = obama_st_1-d_share if committee == "Organizing for America"

twoway (scatter dif_predict fullstart if ob_v == 1 & dif_predict <20 & dif_predict >-20 & fullstart <19304, msymbol(circle_hollow) msize(small) mcolor(gs12)) ///
 (lowess dif_predict fullstart if ob_v == 1  & fullstart <19304, lwidth(thick) lcolor(black)), ///
 plotregion(style(none)) legend(off) subtitle(Obama Campaign) ///
 ytitle("Abs(Prediction Minus Outcome)") xtitle(Date) xlabel(19155 "June 11" 19175 "July 1" 19206 "Aug. 1" 19237 "Sept. 1" 19267 "Oct. 1" 19298 "Nov. 1", valuelabels)
graph save pred_time_ob2.gph, replace

twoway (scatter dif_predict fullstart if ob_v == 0 & dif_predict <20 & dif_predict >-20 & fullstart <19304 & fullstart >19226, msymbol(circle_hollow) msize(small) mcolor(gs12)) ///
 (lowess dif_predict fullstart if ob_v == 0  & fullstart <19304 & fullstart >19226, lwidth(thick) lcolor(black)), ///
 plotregion(style(none)) legend(off) subtitle(Down-Ballot Campaigns) ///
 ytitle("Abs(Prediction Minus Outcome)") xtitle(Date) xlabel(19227 "Aug. 22" 19237 "Sept. 1" 19267 "Oct. 1" 19298 "Nov. 1", valuelabels)
graph save pred_time_non2.gph, replace

graph combine pred_time_ob2.gph pred_time_non2.gph, cols(2) xsize(4) ysize(2)


***********
*Table A.1*
***********

u response_rate_file.dta, clear

gen shown4 = surveyshown
replace shown4 = 4 if shown4 >=4 & shown4 !=.

gen enter = 0 if surveyentry ==0 
replace enter = 1 if surveyentry >0 & surveyentry != .

tab shown4 enter, row

************
*Figure A.2*
************

u response_rate_file.dta, clear

gen shown4 = surveyshown
replace shown4 = 4 if shown4 >=4 & shown4 !=.

gen enter = 0 if surveyentry ==0 
replace enter = 1 if surveyentry >0 & surveyentry != .

gen month = month(date)

bysort month: egen enter_date = mean(enter)
bysort month: egen enter_date_ob = mean(enter) if obama ==1 
bysort month: egen enter_date_non = mean(enter) if obama ==0 

drop if month <8 & obama ==0 
*we did not interview down-ballot races prior to August. Some down-ballot
*races appear before August due to classification issues.

twoway(connected enter_date_ob month, sort mcolor(black) msize(medlarge) lcolor(black) lwidth(medthick)) ///
 (connected enter_date_non month if month > 2, sort mcolor(gs10) msize(medlarge) lcolor(gs10) lwidth(medthick)), ///
ytitle(Response Rate) xtitle(Month) xlabel(6 "June" 7 "July" 8 "Aug." 9 "Sept." 10 "Oct." 11 "Nov", valuelabels) ///
legend(size(small) position(10) ring(0) cols(1) order(1 "Obama Campaign" 2 "Down-Ballot Campaigns") region(fcolor(none) lcolor(none))) ///
plotregion(style(none)) ylabel(.1(.1).7)


***********
*Table A.2*
***********
 u replication_data.dta, clear
 
 tab camp_type
 *See survey codebook

 
***********
*Table A.3*
***********
 u replication_data.dta, clear
	
tab camp_role if  committee == "Organizing for America" 
tab camp_role if  committee != "Organizing for America" 
tab camp_role_text if committee != "Organizing for America" 


***********
*Table A.4*
***********
 u replication_data.dta, clear
	
tab camp_title if  committee == "Organizing for America" 
tab camp_title if  committee != "Organizing for America" 
tab camp_role_text if committee != "Organizing for America" 
 
 
**********
*Figure A.3*
**********

u mass_public_survey, clear

gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100


gen dif_predict = abs(d_share-obama_st_pre)
gen dif_predict2 = (obama_st_pre-d_share)

gen dem = pid3 == 1
gen rep = pid3 == 2
gen party3 = pid3
recode party3 1=1 2=2 nonmis = 3

gen overpredict_dem = 1 if dif_predict2 >0 & dif_predict2 != .
replace overpredict_dem = 0 if dif_predict2 <0 & dif_predict2 != .



gen ed_lib_d = 1 if ideo ==1 & dem == 1 & (educ == 5 | educ == 6)
gen ed_con_r = 1 if ideo == 5  & rep == 1 &  (educ == 5 | educ == 6)
gen ed_mod_i = 1 if ideo == 3 & party3== 3 &    (educ == 5 | educ == 6)

tab ed_lib_d overpredi [aw=weight], row col
tab ed_con_r overpredi [aw=weight], row col
tab ed_mod_i overpredi [aw=weight], row col

ci dif_predict if ed_lib_d == 1 [aw=weight]
ci dif_predict if ed_con_r == 1 [aw=weight]
ci dif_predict if ed_mod_i == 1 [aw=weight]



histogram dif_predict2 if ed_lib_d == 1, bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("", size(zero)) ///
 ytitle("", size(zero)) subtitle("High-Edu., V. Liberal Dems")  ylabel(0(5)35) xlabel(-50(20)50, labsize(small)) ///
 text(35 25 "82% Over-Predict Obama", size(medsmall))  ///
 plotregion(style(none))  xline(0, lcolor(black)) xscale(noextend) yscale(noextend)	
 graph save edu_strong_dem_cces_hist.gph, replace
 
  histogram dif_predict2 if ed_con_r ==1, bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("", size(zero)) ///
 ytitle("", size(zero)) subtitle("High-Edu., V. Conservative Reps") ylabel(0(5)35)  xlabel(-50(20)50, labsize(small)) ///
 text(35 25 "24% Over-Predict Obama", size(medsmall))  ///
 plotregion(style(none))  xline(0, lcolor(black)) xscale(noextend) yscale(off noextend)	
graph save edu_strong_rep_cces_hist.gph, replace

histogram dif_predict2 if party3==3, bin(20) percent fcolor(gs12) lcolor(black) ///
xtitle("", size(zero)) ///
 ytitle("", size(zero)) subtitle("High Edu., Moderate Inds") ylabel(0(5)35) xlabel(-50(20)50, labsize(small)) ///
 text(35 25 "43% Over-Predict Obama", size(medsmall))  ///
 plotregion(style(none)) xline(0, lcolor(black)) xscale(noextend) yscale(off noextend)	
graph save edu_mod_ind_cces_hist.gph, replace



graph combine  edu_strong_dem_cces_hist.gph  edu_strong_rep_cces_hist.gph  edu_mod_ind_cces_hist.gph, ///
col(3) xsize(6) ysize(2) iscale(1.75) b1title(Prediction Minus State Vote Share, size(vlarge)) l1title(Percent, size(vlarge))



***********
*Table A.5*
***********

 u replication_data.dta, clear

 gen d_share = dem_cand/(dem_cand+rep_cand)
replace d_share = d_share*100
	
gen dif_predict = abs(d_share-elect_gen) if committee != "Organizing for America"
replace dif_predict = abs(d_share-obama_st_1) if committee == "Organizing for America"

gen ob_vs_oth = 1 if committee == "Organizing for America" 
replace ob_vs_oth = 0 if committee != "Organizing for America"


gen veryliberal = ideology == 1
gen collegetrack = edu
recode collegetrack 5 6 = 1 1 2 3 4 =0 
replace collegetrack =1 if  edu <=3 & age <=22
gen college_justgrads = edu
recode college_justgrads 5 6 = 1 1 2 3 4 =0 

gen paidstaff =1 if camp_role == 4 
recode paidstaff .=0
replace paidstaff = 1 if camp_role_text == "Candidate" | camp_role_text== "candidate"

gen usfed = 1 if camp_type ==3 | camp_type == 5 
recode usfed .=0

ren weekly_obama_advantage_state ad_st
sort camp_state fullst
replace ad_st = ad_st[_n-1] if camp_state == camp_state[_n-1] & ad_st == .
gen state_lag2 = ad_st[_n-1] if ad_st != ad_st[_n-1] & camp_state == camp_state[_n-1]
replace state_lag2 = state_lag2[_n-1] if camp_state == camp_state[_n-1] & state_lag2 ==.
gen st_ad_change = ad_st-state_lag2

gen nov = 1 if monthstart == 11
gen oct = 1 if monthstart == 10
gen sept = 1 if monthstart == 9 
gen summer = 1 if monthstart <9
recode nov .=0 if monthstart != .
recode oct .=0 if monthstart != .
recode sept .=0 if monthstart != .
recode summer .=0 if monthstart != .



reg dif_predict  collegetrack paid verylib first if ob_v == 1, vce(cluster camp_state)
outreg2 using modelsapp.xls, excel dec(2) replace
reg dif_predict  collegetrack paid first verylib  n_polls if ob_v == 1, vce(cluster camp_state)
outreg2 using modelsapp.xls, excel dec(2) append
reg dif_predict  collegetrack paid first verylib  summer sept oct  n_polls st_ad_change if ob_v == 1, vce(cluster camp_state)
outreg2 using modelsapp.xls, excel dec(2) append

reg dif_predict  collegetrack paid first verylib if ob_v == 0, vce(cluster com_state)
outreg2 using modelsapp.xls, excel dec(2) append
reg dif_predict  collegetrack paid first verylib  n_polls summer sept oct d_inc usfed    if ob_v == 0, vce(cluster com_state)
outreg2 using modelsapp.xls, excel dec(2) append
areg dif_predict  collegetrack paid first verylib   summer sept oct d_inc usfed if ob_v == 0, a(camp_state) 
outreg2 using modelsapp.xls, excel dec(2) append
****
