*Ansolabehere and Hersh
*CCES-Catalist Validation
*Replication for publication in Political Analysis 


use cces_replication_data.dta


gen weight = V201


gen val_reg1 = 1 if votersta == "active" | votersta == "inactive" | votersta == "multipleAppearances"
recode val_reg1 .=0
*"Multiple Appearances" are people who are currently registered in one state but are thought to live in a different state

gen rep_reg = V256
recode rep_reg 1 =1 2=0 3=.

gen val_vote =1 if e2008g != ""
recode val_vote .=0
replace val_vote =. if state == "VA"
replace val_vote =. if stateusps == "VA"
replace val_vote =. if reg_since_08el ==1 
*stateusps comes from the CCES self report; state comes from Catalist
*Virginia did not allow us to see the vote history for VA voters, so we must exclude them from the validated vote analysis
*We also exclude registrants who registered between the 2008 election and the time of the valitation


gen rep_vote = CC403
recode rep_vote 5=1 nonmis = 0


**********************
*****TABLE 1**********
tab rep_vote val_vote [aw=weight], row col
**********************


*Generating control variables
gen edu = V213 
recode edu 1=0 2=1 3 4= 2 5=3 6=4

gen income = V246 
recode income 15=.
recode income 1 2 3=1 4 5 =2 6 7 8 9 =3 10 11 12 13 14=4
gen white = V211 ==1
gen black = V211 == 2
gen other_nonwhite =1 if V211 !=1 & V211 !=2
recode other .=0

gen married = V214 == 1

gen attend = V217 
recode attend 7=.  6=0 4 5 = 1 3=2 1 2 =3

gen age_rep = 2008-V207
gen agecoh1 =1 if age_rep > 17 & age_rep <=24
recode agecoh1 .=0 if age_rep !=.
gen agecoh2 =1 if age_rep >= 25 & age_rep <=34
recode agecoh2 .=0 if age_rep !=.
gen agecoh3 =1 if age_rep >= 35 & age_rep <=44
recode agecoh3 .=0 if age_rep !=.
gen agecoh4 =1 if age_rep >= 45 & age_rep <=54
recode agecoh4 .=0 if age_rep !=.
gen agecoh5 =1 if age_rep >= 55 & age_rep !=.
recode agecoh5 .=0 if age_rep !=.



gen ideo_strengh = V243 
recode ideo 3 6 = 0 2 4 = 1 1 5 = 2
gen female = V208-1

gen polinter = V244 
recode polinter 7 4 = 0 3=1 2=2 1=3

gen dem = CC423 == 1
gen rep = CC423 == 2
recode dem rep (0=.) if CC423 == . 

gen partisan_strength = CC424
recode partisan_strength 4 8 =0 3 5 =1 2 6 = 2 1 7 = 3 



gen recentmover = CC334 
recode recent 1 2 3 4 =1 5 6 = 0

sum edu income white black other_non married attend age_rep ideo_str female polinter dem rep recent [aw=weight]

tab stateusps, gen(states)
bysort stateusps: egen pct_valvote = mean(val_vote)
bysort stateusps: egen pct_repvote = mean(rep_vote)
bysort stateusps: egen obs_state = count(val_vote) if rep_vote != . 
sort stateusps


******************
****FIGURE 1******
scatter pct_valvote pct_repvote if _n != _n-1 & stateusps != "", mlabel(stateusps) mlabposition(12) ///
ytitle("Validated Vote Rate") xtitle("Reported Vote Rate") plotregion(style(none)) ///
scheme(s1mono) ylabel(.4(.1)1) xlabel(.80(.05)1)
******************


******************
****TABLE 2*******

reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0
*For appendix (table 8)
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0
******************

******************
****TABLE 3*******
*First model
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0
estimates store m1
*Add State Fixed Effects
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent states1-states51 if val_vote == 0
estimates store m2
lrtest m1 m2
*Likelihood ratio test has a chi-squared value of 118.7, statistically significant difference between the models

*Restrict to voters  located by Catalist
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent states1-states51 if val_vote == 0 & votersta != ""
estimates  store m3

*Add confidence measure
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent confidence states1-states51 if val_vote == 0 & votersta != ""
estimates store m4
lrtest m3 m4
*Likelihood ratio test has a chi-squared value of 1.8, not statistically significant difference between the models
**********************************


*Generating county-level validation quality measures

gen countyquality = (pct_undeliv + pct_deadwood  + discrep08)/3
*summary quality measure

xtile cyqual4 = countyquality, nq(4)
*quartiles of county quality


*For figure 2
xtile undl4 = pct_undeliv, nq(4)
xtile ded4 = pct_deadwood, nq(4)
xtile dic4 = discrep08, nq(4)

*The output from the three following commands are copied and pasted into a spreadsheet, named "county_quality.csv" 
*The commands for calling that spreadsheet into STATA and producing Figure 2 are included below in this do-file.

bysort undl4: ci rep_vote if val_vote == 0 [aw=weight]
bysort ded4: ci rep_vote if val_vote == 0 [aw=weight]
bysort dic4: ci rep_vote if val_vote == 0 [aw=weight]


centile pct_undeliv, centile(0 25 50 75 100)
centile pct_deadwood, centile(0 25 50 75 100)
centile discrep08, centile(0 25 50 75 100)

******************
****TABLE 4*******
*Model 1
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0 & cyqual4 != .

*Model 2
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent   if val_vote == 0 & cyqual4 == 1

*Model 3
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent  if val_vote == 0 & cyqual4 == 2

*Model 4
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent  if val_vote == 0 & cyqual4 == 3

*Model 5
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent  if val_vote == 0 & cyqual4 == 4

*Chow Test calculations from above models
di (972-(239+237+215+274))/16
di  (239+237+215+274)/((1519+1510+1439+1899)-(2*16))
di .4375/.15232833
di (1519+1510+1439+1899)-(2*16)
*Chow test statistic = 2.87
*F(16, 6335) 
*stat sig at .01 level
***********************************************

***Logit versions of Table 3 and Table 4 (Tables 9 and 10)
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent states1-states51 if val_vote == 0
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent states1-states51 if val_vote == 0 & votersta != ""
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent confidence states1-states51 if val_vote == 0 & votersta != ""

logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0 & cyqual4 != .
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0 & cyqual4 == 1
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0 & cyqual4 == 2
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0 & cyqual4 == 3
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent if val_vote == 0 & cyqual4 == 4
*****************


*Generating variables for Table 4
gen race_file = race if racesource == "voterFile"
gen race_valid = 1 if race_file == "caucasian" 
replace race_valid =2 if race_file == "black"
replace race_valid =3 if race_file == "asian" | race_file == "hispanic" | race_file == "nativeAmerican" | race_file == "unknown"
gen race_report = V211
recode race_report 1=1 2=2 nonmis=3
label values race_report V211
gen party_valid = 1 if partyaff == "DEM" 
replace party_valid = 2 if partyaff == "REP"
replace party_valid = 3 if partyaff == "NPA" | partyaff == "DTS" | partyaff == "IND"
replace party_valid = 4 if partyaff == "CST" | partyaff == "GRE" | partyaff == "LIB" | partyaff == "OTH" | partyaff == "REF" | partyaff == "SOC"
recode party_valid 4=3
gen party_report = CC402 
recode party_report 1=1 2=2 4 10 =3 3 5 6 7 8 9 =4
recode party_report 4=3
gen votemethod_report = "Y" if CC405 == 1
replace votemethod_report = "E" if CC405 == 2
replace votemethod_report = "A" if CC405 == 3
replace votemethod_report = "earlyabs" if votemethod_repor == "A" | votemethod_report == "E"
gen votemethod_valid = e2008g
replace votemethod_valid = "A" if votemethod_valid == "M"
replace votemethod_valid = "earlyabs" if votemethod_valid == "A" | votemethod_val == "E"

****************
****TABLE 4*****
tab party_valid party_repo [aw=weight], row col
tab race_valid race_report [aw=weight], row col
tab votemethod_valid votemethod_report [aw=weight], row col 
tab val_reg1  rep_reg [aw=weight], row col

tab party_report if party_valid == 1 | party_valid == 2 [aw=weight]
tab party_report if party_valid == 3 [aw=weight]
tab race_report if race_valid == 1 | party_valid == 2 [aw=weight]
tab race_report if race_valid == 3 [aw=weight]
****************

*Generating dependent variables for Table 5
gen report_party = party_rep
recode report_party 1 2 =1 3=0
gen report_polls = 1 if votemethod_rep == "Y"
replace report_polls = 0 if votemethod_rep == "earlyabs"
gen report_absentee = 1 if votemethod_rep == "earlyabs"
replace report_abs = 0 if votemethod_rep == "Y" 

***************
****TABLE 5****
*COMPARE MISREPORTERS ON VOTE HISTORY AND MISREPORTERS ON REGISTRATION AND MISREPORTERS ON PARTY
*Model 1
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent  if val_vote == 0

*Model 2
reg rep_reg edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent   if val_reg1 == 0

*Model 3
reg report_abs edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent  if votemethod_val == "Y"

*Model 4
reg report_party edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent  if party_val ==3
************************

*Logit version of Table 5 (Table 11)

logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent  if val_vote == 0
logit rep_reg edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent   if val_reg1 == 0
logit report_abs edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent  if votemethod_val == "Y"
logit report_party edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent  if party_val ==3
*********************************


*Generating binary variables for use in Figure 3 
gen ba = V213
recode ba 1 2 3 4 =0 5 6 =1

gen inc14 = V246
recode inc14 15=.
gen inc100plus = V246
recode inc100 1/11 =0 12 13 14 = 1 15=.

gen reg_attend = V217
recode reg_attend 1 2 =1 3 4 5 6 = 0 7 =. 
tab age_rep
	gen strong_ideo = V243
	recode strong_ideo 1 5= 1 2 3 4 = 0 6=.
gen high_news = V244
recode high_news 1=1 2 3 4 =0 7 = .
gen strong_part = CC424
recode strong_part  1 7 = 1 8 =.  nonmis =0


ci ba inc100 black other married reg_attend agecoh1 agecoh5 strong_ideo high_news strong_part recent female [aw=weight] if val_vote == 0 & rep_vote !=.
ci ba inc100 black other married reg_attend agecoh1 agecoh5 strong_ideo high_news strong_part recent female [aw=weight] if val_vote == 1  & rep_vote !=.
ci ba inc100 black other married reg_attend agecoh1 agecoh5 strong_ideo high_news strong_part recent female [aw=weight]  if rep_vote == 0 & val_vote !=. 
ci ba inc100 black other married reg_attend agecoh1 agecoh5 strong_ideo high_news strong_part recent female [aw=weight]  if rep_vote == 1 & val_vote !=.


*Outputs from the following commands are copied and pasted into a spreadsheet, "rep_vs_val_voters_and_nonvoters.csv". 
*Figure 3 is generated from that file, as described in code below.

ttesti	6916	.1893657	.0047116	19265	.293955	.0032823	
ttesti	6490	.1275852	.0041416	18149	.1926235	.0029274
ttesti	6916	.0986029	.0035851	19265	.1121409	.0022734
ttesti 6916	.1788407	.0046084 19265	.1125326	.0022769	
ttesti 6916	.4922375	.006012		19265	.6023572	.0035261					
ttesti	6833	.2448468	.0052022	19182	.3391584	.0034183
ttesti	6916	.1909412	.0047265		19265	.0972497	.0021348
ttesti	6916	.2319563	.0050757		19265	.3513782	.0034396
ttesti	5934	.2025705	.0052179		18552	.2476738	.0031693
ttesti	6719	.4148124	.0060111	19174	.6026253	.0035341			
ttesti	6533    .3819732    .0060117   19049    .5424542    .0036097 	
ttesti	6909	.3821124	.0058462	19241	.2430564	.0030923
ttesti 6916	.4828222	.0060092 19265	.5415472	.00359	

ttesti	2817	.0725932	.0048895	 23364	.2961908	.0029871	
ttesti 2652	.0516128	.004297	21987	.1947221	.0026706	
ttesti	2817	.0955896	.0055408	23364	.1101708	.0020484	
ttesti	2817	.203988	.0075936	23364	.1202423	.0021279	
ttesti	2817	.4536542	.0093817	23364	.5889598	.003219					
ttesti	2761	.1942665	.0075308 23254	.3308081	.0030855	
ttesti	2817	.2047925	.0076047	23364	.1121914	.0020648
ttesti	2817	.1679124	.0070438	23364	.3409943	.0031014
ttesti	1986	.1647734	.0083266	22500	.2433501	.0028608
ttesti	2649	.1879849	.0075925	23244	.6063203	.0032046						
ttesti	2484    .2610413    .0088141 23098	.5316842	.0032834	 
ttesti	2814	.4108494	.0092762	23336	.2636972	.0028845
ttesti 2817	.619899	.0091473	23364	.5049677	.003271	

***************
**APPENDIX TABLE
**SUMMARY STATISTICS

sum rep_vote val_vote edu income white black other_non married attend agecoh1 agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_st recent confidence pct_dead pct_undel discrep [aw=weight]



***************
****COMMANDS TO GENERATE FIGURES 2 and 3 FROM SUMMARY FILES


*FIGURE 2
clear 
insheet using county_quality.csv

twoway (scatter mean quartile if var == "dead", mcolor(black) msymbol(circle)) ///
(rcap lb ub quartile if var == "dead", lcolor(gs10)), ytitle("Pr(Over-Report Vote)") ///
 ylabel(.3(.1).7) xtitle(Quartiles of County Data Quality) ///
plotregion(style(none)) title(Deadwood)  ///
legend(off)  fysize(40) fxsize(80)
graph save dead.gph, replace

twoway (scatter mean quartile if var == "und", mcolor(black) msymbol(circle)) ///
(rcap lb ub quartile if var == "und", lcolor(gs10)), ytitle("Pr(Over-Report Vote)") ///
 ylabel(.3(.1).7) xtitle(Quartiles of County Data Quality) ///
plotregion(style(none)) title(Undeliverable Addresses)  ///
legend(off)  fysize(40) fxsize(80)
graph save undeliv.gph, replace

twoway (scatter mean quartile if var == "discrep", mcolor(black) msymbol(circle)) ///
(rcap lb ub quartile if var == "discrep", lcolor(gs10)), ytitle("Pr(Over-Report Vote)") ///
 ylabel(.3(.1).7) xtitle(Quartiles of County Data Quality) ///
plotregion(style(none)) title(Vote History Discrepancies)  ///
legend(off) fysize(40) fxsize(80)
graph save discrep.gph, replace

graph combine dead.gph undeliv.gph discrep.gph, cols(3) rows(1) iscale(.7) scheme(s1mono)

*FIGURE 3
insheet using rep_vs_val_voters_and_nonvoters.csv, clear
gen r_dif2 = r_dif*(-1)
gen v_dif2 = v_dif*(-1)
gen r_lb2 = r_dlb*(-1)
gen r_ub2 = r_dub*(-1)
gen v_lb2 = v_dlb*(-1)
gen v_ub2 = v_dub*(-1)
gen vars = _n
recode vars 1=13 2=12 3=11 4=10 5=9 6=8 7=7 8=6 9=5 10=4 11=3 12=2 13=1
label define variabs 13 "Bachelor Deg." 12 "High Income" 11 "Black" 10 "Other Non-White" 9 "Married" ///
8 "Church Goer" 7 "Age 18-24" 6  "Age 55+" 5 "Ideological" 4 "High Poli. Interest" 3 "Strong D or R" 2 "Recent Mover" 1 "Female"
label values vars variabs
label var vars "Individual Characeteristics"

graph twoway (dot r_dif2 vars, hor msymbol(O) mc(black) msize(large)) ///
(rcap r_lb2 r_ub2 vars, hor lc(black) lw(medthin)) /// 
(dot v_dif2 vars, hor msymbol(O) mc(gs10) msize(large)) ///
(rcap v_lb2 v_ub2 vars, hor lc(gs10) lw(medthin)), ///
ylabel(1 2 3 4 5 6 7 8 9 10 11 12 13, val angle(0) labs(medsmall) noticks) ///
xlabel(-.2(.1).5)  plotregion(style(none))  scheme(s1mono)  ///
legend(order(1 "Diff. Reported Voters - Non-Voters" 2 "95% CI" 3 "Diff. Valid Voters - Non-Voters" 4 "95% CI") region(lcolor(none)))




















