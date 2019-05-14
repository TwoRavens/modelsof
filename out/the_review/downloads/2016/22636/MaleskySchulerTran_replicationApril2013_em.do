#delimit;
clear all;
set more off;
cd "C:\Users\ejm5\Dropbox\APSR_Experiment_Public";
log using replication.smcl, replace;
use electionresults_replication_public.dta, clear;
save electionresults_replication_public2.dta,replace;

/***************************************************Index**************************************************
Table1: Line 460 to 484
Table2: Line 488 to 490
Table3: Line 36 to Line 110; Panel C(Line 659 to Line 672)
Table4: Line 240 to Line 253
Table5: Line 165 to Line 193
Table6: Line 493 to Line 501
Table7: Line 508 to 648

Figure1: Line 330 to 452


Appendix5a: Line 741 to 759
Appendix5b: Line 766 to 776
Appendix6: Line 255 to Line 269
Appendix7: Line 115 to Line 136
Appendix8: Line 140 to Line 159
Appendix9: Line 676 to Line 685
Appendix10: Line 700 to Line 716
Appendix11: Line 200 to Line 240; Line 721 to 736
Appendix12: Line 273 to Line 301
Appendix13: Line 305 to Line 326
****************************************************************************************************************/




/*****************************TABLE 3 --- Panel D (Page 174)*********************  Average Treatment Effect*/
#delimit;
sort delegate_id session;
xi: reg  question_count t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using ate, e(all) bdec(3) tdec(3) replace;
xi: reg  criticize_total_per t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using ate, e(all) bdec(3) tdec(3);
xi: reg  question_count t2 fulltime centralnom retirement if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using ate, e(all) bdec(3) tdec(3);
xi: reg  criticize_total_per t2 fulltime centralnom retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using ate, e(all) bdec(3) tdec(3);
xi: reg  question_count t2 fulltime centralnom retirement interview if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using ate, e(all) bdec(3) tdec(3);
xi: reg  criticize_total_per t2 fulltime centralnom retirement interview if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using ate, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/



/******************Table 3 --- Panel A (Page 174)********Diff Between 5 and 6th Sessions - Regressed on Treatment (Diff-in-Diff)*/
/*Diff-in-Diff*/
#delimit;
generate time=0 if session==5;
replace time=1 if session==6;
xi: reg  question_count i.t2*time if  politburo==0, robust cluster(pci_id);
xi: reg  criticize_total_per  i.t2*time if  politburo==0, robust cluster(pci_id);

#delimit;
xi: reg  d.question_count t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff_table3_a, e(all) bdec(3) tdec(3) replace;
xi: reg  d.question_count t2 fulltime centralnom retirement if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff_table3_a, e(all) bdec(3) tdec(3);
xi: reg  d.question_count t2 interview fulltime centralnom retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff_table3_a, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff_table3_a, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per t2 fulltime centralnom retirement if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff_table3_a, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per t2 interview fulltime centralnom retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff_table3_a, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/

 
/*Table 3 --- Panel B (Page 174)********Diff Between Average and 6th Sessions - Regressed on Treatment (Diff-in-Diff)*/
#delimit;
by delegate_id, sort:  egen avg_speech=mean(speaknum_count) if session <5.9;
by delegate_id, sort:  egen avg_speechpost=mean(speaknum_count) if session >5.9;
generate diff_speech=speaknum_count-l.avg_speech if session==6;
lab var diff_speech "Speeches - Difference Between 6th and Delegate Average in Previous Sessions (#)";
 
#delimit;
by delegate_id, sort:  egen avg_quest=mean(question_count) if session <5.9;
by delegate_id, sort:  egen avg_questpost=mean(question_count) if session >5.9;
generate diff_quest= question_count-l.avg_quest if session==6;
lab var diff_quest "Questions - Difference Between 6th and Delegate Average in Previous Sessions (#)";

by delegate_id, sort:  egen avg_crit=mean(criticize_total_per) if session <5.9;
by delegate_id, sort:  egen avg_critpost=mean(criticize_total_per) if session >5.9;
generate diff_crit=criticize_total_per-l.avg_crit if session==6;
lab var diff_quest "Difference Between 6th and Delegate Average in Previous Sessions (% Critical)";


#delimit;

xi: reg  diff_quest t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff1_table3_b, e(all) bdec(3) tdec(3) replace;
xi: reg  diff_quest t2 fulltime centralnom retirement if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff1_table3_b, e(all) bdec(3) tdec(3);
xi: reg  diff_quest t2 interview fulltime centralnom retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff1_table3_b, e(all) bdec(3) tdec(3);
xi: reg diff_crit t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff1_table3_b, e(all) bdec(3) tdec(3);
xi: reg  diff_crit t2 fulltime centralnom retirement if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff1_table3_b, e(all) bdec(3) tdec(3);
xi: reg  diff_crit t2 interview fulltime centralnom retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using diff1_table3_b, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/



/**************************APPENDIX 7 & 8:  Interactions Effects by Blocked Categories****************************************/

/*Appendix 7 5v6*/

#delimit;
xi: reg  d.question_count i.t2*fulltime centralnom retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3) replace;
xi: reg  d.question_count i.t2*centralnom fulltime  retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3);
xi: reg  d.question_count i.t2*retirement centralnom fulltime  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3);
xi: reg  d.question_count i.t2*percentage centralnom fulltime  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3);

xi: reg  d.criticize_total_per i.t2*fulltime centralnom retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per i.t2*centralnom fulltime  retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per i.t2*retirement centralnom fulltime  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per i.t2*percentage centralnom fulltime  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix7, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/


/*Appendix 8 Avg.v6*/
#delimit;
xi: reg  diff_quest i.t2*fulltime centralnom retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3) replace;
xi: reg  diff_quest i.t2*centralnom fulltime  retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3);
xi: reg  diff_quest i.t2*retirement centralnom fulltime  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3);
xi: reg diff_quest i.t2*percentage retirement centralnom fulltime   if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3);


xi: reg  diff_crit i.t2*fulltime centralnom retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3);
xi: reg  diff_crit i.t2*centralnom fulltime  retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3);
xi: reg  diff_crit i.t2*retirement centralnom fulltime  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3);
xi: reg  diff_crit i.t2*percentage retirement centralnom fulltime  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix8, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/




/*****************************************TABLE 5: Dose Treatment Effect Internet (Panels A&B)*************************************************/  

#delimit;
/*Panel A - Questions*/
xi: reg  d.question_count i.t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3) replace;
xi: reg  d.question_count i.t2*internet_users100 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);
xi: reg  d.question_count i.t2*internet_users100 centralnom fulltime retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);
xi: reg  d.question_count i.t2*internet_users100 centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);

/*Panel A - Criticism*/
xi: reg  d.criticize_total_per i.t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per i.t2*internet_users100 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per i.t2*internet_users100 centralnom fulltime retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per i.t2*internet_users100 centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);


/*Panel B - Avg. v. 6th*/
xi: reg  diff_quest i.t2*internet_users100 centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3);
xi: reg  diff_crit  i.t2*internet_users100 centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table5, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/


/**********************************************Appendix 11 Robust to other Intensity of Treatment Effects*******************************************/
#delimit;
xtset delegate_id session;
lab var thanh_thi_per "Urban Population %";
lab var state_labor_per "State Labor Share %";
lab var student_per "College Students %";

/*Panel A - Questions*/
xi: reg  d.question_count i.t2*thanh_thi_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3) replace;
xi: reg  d.question_count i.t2*state_labor_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);
xi: reg  d.question_count i.t2*student_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);

/*Panel B - Criticism*/
xi: reg  d.criticize_total_per  i.t2*thanh_thi_per  centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per  i.t2*state_labor_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per  i.t2*student_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);

/*Panel B - Questions*/
xi: reg  diff_quest i.t2*thanh_thi_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);
xi: reg  diff_quest i.t2*state_labor_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);
xi: reg  diff_quest i.t2*student_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);


/*Panel B - Criticsm*/
xi: reg  diff_crit  i.t2*thanh_thi_per  centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);
xi: reg  diff_crit  i.t2*state_labor_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3);
xi: reg  diff_crit  i.t2*student_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix11b, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/



/*************************************Table 4 & Appendix 6: Determinants of Page Views*************************************************************/
#delimit;
replace total_view=total_view/100 if total_view !=0;
#delimit;
xi: reg    total_view internet  if session==6 & politburo==0 & t2==1, robust cluster(pci_id);
outreg2 using Table4, e(all) bdec(3) tdec(3) replace;
xi: reg    total_view internet interview   if session==6 & politburo==0 & t2==1, robust cluster(pci_id);
outreg2 using Table4, e(all) bdec(3) tdec(3);
xi: reg    total_view internet interview  question_count   if session==6 & politburo==0 & t2==1, robust cluster(pci_id);
outreg2 using Table4, e(all) bdec(3) tdec(3);
xi: reg    total_view internet interview  question_count  centralnom fulltime retirement female  if session==6 & politburo==0 & t2==1, robust cluster(pci_id);
outreg2 using Table4, e(all) bdec(3) tdec(3);
xi: reg    total_view internet interview   question_count  centralnom fulltime retirement female ln_gdp ln_pop city  if session==6 & politburo==0 & t2==1, robust cluster(pci_id);
outreg2 using Table4, e(all) bdec(3) tdec(3);

/*Appendix 6*/
avplot internet, xtitle("e(Internet Penetration|X)", margin(med)) ytitle("e(Page Views|X)", margin(medlarge)) 
note(, size(small) position(7)) title("Full Sample of Treated Delegates");
graph save avplot_full.gph, replace;

xi: reg    total_view internet interview question_count  centralnom fulltime retirement female ln_gdp ln_pop city  if session==6 & politburo==0 & t2==1
& delegate_id !=24 & delegate_id !=27& delegate_id !=69, robust cluster(pci_id);
outreg2 using Table4, e(all) bdec(3) tdec(3) excel;

avplot internet, xtitle("e(Internet Penetration|X)", margin(med)) ytitle("e(Page Views|X)", margin(medlarge)) 
note(, size(small) position(7)) title("Outliers Dropped");
graph save avplot_out.gph, replace;

graph combine avplot_full.gph avplot_out.gph, cols(2);
graph save Appendix6.gph, replace;
/********************************************************************************************************************************/


/*Appendix 12*/
#delimit;
generate high_internet4 =1 if internet>4 & internet !=.;
replace high_internet4=0 if internet<=4 & internet !=.;
generate high_internet6 =1 if internet>6 & internet !=.;
replace high_internet6=0 if internet<=4 & internet !=.;

#delimit;
xi: reg d.question_count i.t2*high_internet4 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3) replace;
xi: reg d.criticize_total_per i.t2*high_internet4 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);
xi: reg diff_quest i.t2*high_internet4 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);
xi: reg diff_crit i.t2*high_internet4 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);
xi: reg d.debate_speeches i.t2*high_internet4 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);

xi: reg d.question_count i.t2*high_internet6 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);
xi: reg d.criticize_total_per i.t2*high_internet6 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);
xi: reg diff_quest i.t2*high_internet6 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);
xi: reg diff_crit i.t2*high_internet6 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3);
xi: reg debate_speeches i.t2*high_internet6 if session==6 & politburo==0, cluster(pci_id);
outreg2 using Appendix12, e(rmse) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/


/*Appendix 13*/
#delimit;
xi: reg  d.question_count  i.t2*transfer centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3) replace;
xi: reg  d.criticize_total_per  i.t2*transfer centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3);
xi: reg  debate_speeches  i.t2*transfer centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3);

xi: reg  d.question_count  i.t2*ln_gdpcap centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per  i.t2*ln_gdpcap centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3);
xi: reg  debate_speeches  i.t2*ln_gdpcap centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3);

xi: reg  d.question_count  i.t2*ln_pop centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3);
xi: reg  d.criticize_total_per  i.t2*ln_pop centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3);
xi: reg  debate_speeches  i.t2*ln_pop centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Appendix13, e(all) bdec(3) tdec(3) excel;



/*******************************Simulations for Figure 1 -- CLARIFY ON MINISTERIAL EFFECTS**********************************/


#delimit;
set more off;
xi: estsimp reg  diff_quest i.t2*internet centralnom fulltime retirement  city ln_gdpcap 
ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id) genname(xi1);

foreach num of numlist 0(.5)9 {;
setx mean;
setx `num';
simqi, fd(ev) changex(_It2_1 0 1   _It2Xinter_1 0 1*`num')  level(95);
};


#delimit;
drop xi*;

#delimit;
xi: estsimp reg  diff_crit i.t2*internet centralnom fulltime retirement  city ln_gdpcap 
ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id) genname(xi1);

#delimit;
foreach num of numlist 0(.5)9 {;
setx mean;
setx `num';
simqi, fd(ev) changex(_It2_1 0 1   _It2Xinter_1 0 1*`num')  level(95);
};


#delimit;
drop xi*;
xi: estsimp reg  d.question_count i.t2*internet centralnom fulltime retirement  city ln_gdpcap 
ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id) genname(xi1);

#delimit;
foreach num of numlist 0(.5)9 {;
setx mean;
setx `num';
simqi, fd(ev) changex(_It2_1 0 1  _It2Xinter_1 0 1*`num')  level(95);
};


#delimit;
drop xi*;
#delimit;
xi: estsimp reg  d.criticize_total_per i.t2*internet centralnom fulltime retirement  city ln_gdpcap 
ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id) genname(xi1);

#delimit;
foreach num of numlist 0(.5)9 {;
setx mean;
setx `num';
simqi, fd(ev) changex(_It2_1 0 1   _It2Xinter_1 0 1*`num')  level(95);
};



drop xi*;

save electionresults_replication_public2.dta,replace;

/*FIGURE 1*/
#delimit;
use clarify.dta, clear;


#delimit;
twoway (rcap  low hi internet if type==3)   
(scatter  mean internet if type==3, msymbol(triangle) mcolor(maroon)),
yline(0, lcolor(red) lpattern(dash))
ytitle("Change in Questions Asked", size(medium) margin(medsmall))
xtitle("Internet Subscribers per 100 Citizens", size(medium) margin(medsmall)) 
title("6th Session vs. Average", size(large))
legend(off);

graph save interact_diffquest2.gph, replace;

#delimit;
twoway (rcap  low hi internet if type==1)   
(scatter  mean internet if type==1, msymbol(triangle) mcolor(maroon)),
yline(0, lcolor(red) lpattern(dash))
ytitle("Change in Questions Asked", size(medium) margin(medsmall))
xtitle("Internet Subscribers per 100 Citizens", size(medium) margin(medsmall)) 
title("6th vs. 5th Session", size(large))
legend(off);

graph save interact_diffquest1.gph, replace;


#delimit;
twoway (rcap  low hi internet if type==4)   
(scatter  mean internet if type==4, msymbol(triangle) mcolor(maroon)),
yline(0, lcolor(red) lpattern(dash))
ytitle("Change in Critical Questions (%)", size(medium) margin(medsmall))
xtitle("Internet Subscribers per 100 Citizens", size(medium) margin(medsmall)) 
title("6th Session vs. Average", size(large))
legend(off);

graph save interact_diffcrit2.gph, replace;

#delimit;
twoway (rcap  low hi internet if type==2)   
(scatter  mean internet if type==2, msymbol(triangle) mcolor(maroon)),
yline(0, lcolor(red) lpattern(dash))
ytitle("Change in Critical Questions (%)", size(medium) margin(medsmall))
xtitle("Internet Subscribers per 100 Citizens", size(medium) margin(medsmall)) 
title("6th vs. 5th Session", size(large))
legend(off);

graph save interact_diffcrit1.gph, replace;

#delimit;
graph combine interact_diffquest1.gph interact_diffquest2.gph, cols(2) xcommon ycommon title("Change in Questions Asked", size(large));
graph save interact_questions_total.gph, replace;


graph combine interact_diffcrit1.gph interact_diffcrit2.gph, cols(2) xcommon ycommon title("Change in Criticism", size(large));
graph save interact_criticism_total.gph, replace;

#delimit;
graph combine interact_questions_total.gph interact_criticism_total.gph, rows(2) xcommon;
graph save APSR_FIGURE1.gph, replace;







/************************************TABLE 1: Balance Check - Page 772********************************************************/
#delimit;
use electionresults_replication_public2.dta, clear;
preserve;
replace avg_speech=l.avg_speech if session==6;
replace avg_crit=l.avg_crit if session==6;
replace avg_quest=l.avg_quest if session==6;
drop if session!=6;
keep politburo t2 age male minority party percentage  avg_speech avg_crit gdp pop_stacked internet thanh_thi_per  south transfer student_per centralnominated fulltime avg_quest retirement;
save balance.dta, replace;
order politburo t2 age male minority party percentage  avg_speech avg_crit gdp pop_stacked internet thanh_thi_per  south transfer student_per centralnominated fulltime avg_quest retirement;
mat T= J(18,2,1000);
mat rownames T=age male minority party percentage  avg_speech avg_crit gdp pop_stacked internet thanh_thi_per  south transfer student_per centralnominated fulltime avg_quest retirement;
mat colnames T=T2_P T2_T;  
	local counter=0;
	foreach v of varlist age-retirement{;
		local counter = `counter'+1;
		tabstat `v' if t2==1 & politburo==0, stat(mean sd min max);
		tabstat `v' if t2==0 & politburo==0, stat(mean sd min max);
		ttest `v' if polit==0, by(t2) unequal;
		mat T[`counter',1]=r(p);
		mat T[`counter',2]=r(t);	
	};
mat list T;
restore;



/**********************TABLE 2******************************/
tabstat speaknum_count question_count criticize_total_per local_total_per cutri_total_per if session<7, by(session) stat(mean);
tabstat speaknum_count question_count criticize_total_per local_total_per cutri_total_per if session<7 & question_count>1 & question_count !=., by(session);


/**********************************************Table 6: Debate Speeches*********************Difference in Levels*/;
#delimit;
xi: reg  debate_speeches i.t2 if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table6, e(all) bdec(3) tdec(3) replace;
xi: reg  debate_speeches i.t2*internet if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table6, e(all) bdec(3) tdec(3);
xi: reg  debate_speeches i.t2*internet centralnom fulltime retirement  if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table6, e(all) bdec(3) tdec(3);
xi: reg  debate_speeches i.t2*internet centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id);
outreg2 using Table6, e(all) bdec(3) tdec(3) excel;
/***********************************************************************************************************************/




/*******************************Table 7:  Election Results Replication*********************************************************/;
#delimit;
replace renominated=0 if renominated==.;
tab renominated if session==6;

*gen result2011b=result2011;
replace result2011=0 if result2011==.;
replace incumbent2011=0 if incumbent2011==.;
replace cert_cent2011=0 if cert_cent2011==.;
#delimit;


tab  centralnominated renominated if session==6, row nofreq chi;
tab  fulltime renominated if session==6, row nofreq chi;
tab  retire  renominated if session==6, row nofreq chi;
tab  t2  renominated if session==6, row nofreq chi;
tab  interview  renominated if session==6, row nofreq chi;
tab  minority renominated if session==6, row nofreq chi;
tab  female renominated if session==6, row nofreq chi;

/*Effect of endogenous activity*/


/*Renominate: Table 7, Panel 1.1*/
#delimit;
xi: dprobit   renominated  t2  centralnominated age fulltime  if politburo==0 & t2 !=.a & t2 !=.b & session==6, robust cluster(pci_id);
outreg2 using Table7_1_1, e(all) bdec(3) tdec(3) replace;
xi: dprobit   renominated   i.t2*debate  centralnominated age fulltime  if politburo==0 & t2 !=.a & t2 !=.b & session==6, robust cluster(pci_id);
outreg2 using Table7_1_1, e(all) bdec(3) tdec(3);
xi: dprobit   renominated  i.t2*question_count  centralnominated age fulltime   if politburo==0 & t2 !=.a & t2 !=.b & session==6, robust cluster(pci_id);
outreg2 using Table7_1_1, e(all) bdec(3) tdec(3) excel;

/*Result, Table 7, Panel 1.2*/
#delimit;
xi: dprobit result2011b  t2  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b & session==6, robust cluster(pci_id);
outreg2 using Table7_1_2, e(all) bdec(3) tdec(3) replace;
xi: dprobit result2011b   i.t2*debate  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b & session==6, robust cluster(pci_id);
outreg2 using Table7_1_2, e(all) bdec(3) tdec(3);
xi: dprobit result2011b  i.t2*question_count  centralnominated retire fulltime if politburo==0 & t2 !=.a & t2 !=.b & session==6, robust cluster(pci_id);
outreg2 using Table7_1_2, e(all) bdec(3) tdec(3) excel;


/*Vote Share, Table 7, Panel 1.3*/
#delimit;
xi: reg cert_cent2011 t2  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b & session==6 & renominate==1, robust cluster(pci_id);
outreg2 using Table7_1_3, e(all) bdec(3) tdec(3) replace;
xi: reg cert_cent2011  i.t2*debate centralnominated retire fulltime    if politburo==0 & t2 !=.a & t2 !=.b & session==6 & renominate==1, robust cluster(pci_id);
outreg2 using Table7_1_3, e(all) bdec(3) tdec(3);
xi: reg cert_cent2011  i.t2*question_count  centralnominated retire fulltime   if politburo==0 & t2 !=.a & t2 !=.b & session==6 & renominate==1, robust cluster(pci_id);
outreg2 using Table7_1_3, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/


/*****************************************Now, moving onto Electoral District Data****************/
#delimit cr
clear
set more off
use power_total_with_PAPI_NA2.dta


/*Candidates Per Seat Results*/
generate candidate_seat= diselected_delegates/discandidates
rename post_criticize_total_per post_cr_per
rename post_speaknum_count post_speak
rename post_question_count post_quest
label variable t2 "Treated"
label values t2 group
label define group 0 Control 1 Treated

/*Generate Promotion Variables*/
gen promote=0 if incumbent==1
replace leader2011=0 if leader2011!=1 & incumbent==1
replace government2011=0 if government2011!=1 & incumbent==1
replace promote=( government2011+ leader2011)-( leader2007+ government2007)
gen promote2=promote
replace promote2=0 if promote==-1


/*Seat to Candidate Ratio, Table 7, Panel 2.1*/
#delimit;
generate candidate_seat2=1 if candidate_seat==.5;
replace candidate_seat2=2 if candidate_seat>.5 & candidate_seat<.66;
replace candidate_seat2=3 if candidate_seat>.66 & candidate_seat<.75;
replace candidate_seat2=4 if candidate_seat==.75;
#delimit;
xi: oprobit candidate_seat2  t2  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_1, e(all) bdec(3) tdec(3) replace;
xi: oprobit candidate_seat2  i.t2*debate  centralnominated retire  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_1, e(all) bdec(3) tdec(3);
xi: oprobit candidate_seat2  i.t2*post_quest  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_1, e(all) bdec(3) tdec(3) excel;


/*Power Total, Table 7, Panel 2.2*/
#delimit;
xi: reg power_total  t2  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_2, e(all) bdec(3) tdec(3) replace;
xi: reg power_total  i.t2*debate centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_2, e(all) bdec(3) tdec(3);
xi: reg power_total  i.t2*post_quest  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_2, e(all) bdec(3) tdec(3) excel;

/*Promotion, Table 7, Panel 2.3*/
#delimit;
xi: reg promote2  t2  centralnominated age fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_3, e(all) bdec(3) tdec(3) replace;
xi: reg promote2  i.t2*debate centralnominated age fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_3, e(all) bdec(3) tdec(3);
xi: reg promote2  i.t2*post_quest  centralnominated age fulltime   if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_2_3, e(all) bdec(3) tdec(3) excel;

/*Spoiled Ballots, Panel 3.1*/
#delimit;
xi: reg disspoil_ratio  t2  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_3_1, e(all) bdec(3) tdec(3) replace;
xi: reg disspoil_ratio  i.t2*debate centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_3_1, e(all) bdec(3) tdec(3);
xi: reg disspoil_ratio  i.t2*post_quest  centralnominated retire fulltime if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_3_1, e(all) bdec(3) tdec(3) excel;


/*Actual Turnout, Panel 3.2*/
#delimit;
xi: reg disactual_voters_ratio  t2  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_3_2, e(all) bdec(3) tdec(3) replace;
xi: reg disactual_voters_ratio  i.t2*debate  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_3_2, e(all) bdec(3) tdec(3);
xi: reg disactual_voters_ratio i.t2*post_quest  centralnominated retire fulltime if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using Table7_3_2, e(all) bdec(3) tdec(3) excel;

/*Voter Preferences from PAPI, Panel 3.3 to Panel 4.3*/
#delimit;
foreach x in watchNA_wy1 know_NAterm_wy1 turnout_wy1 contactNA_wy1 confidenceNA_wy1  {;
xi: reg `x'  t2  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using `x', e(all) bdec(3) tdec(3) replace;
xi: reg `x'  i.t2*debate  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using `x', e(all) bdec(3) tdec(3);
xi: reg `x' i.t2*post_quest  centralnominated retire fulltime  if politburo==0 & t2 !=.a & t2 !=.b, robust cluster(ELECTION_DISTRICT);
outreg2 using `x', e(all) bdec(3) tdec(3) excel;
};
/********************************************************************************************************************************/




/***************************************Table 3: Panel C - Difference Between Ministers********************/;
#delimit;
use minister_replication2.dta, replace;



/*Replication of Analysis by Minister************************************************************************************************/
#delimit;
xi: reg  diff3_quest i.t2 if  politburo==0, robust cluster(pci_id);
outreg2 using Table3_C, e(all) bdec(3) tdec(3) replace;
xi: reg  diff3_quest i.t2 fulltime centralnom retirement  if  politburo==0, robust cluster(pci_id);
outreg2 using Table3_C, e(all) bdec(3) tdec(3);
xi: reg  diff3_quest i.t2 interview fulltime centralnom retirement  if  politburo==0, robust cluster(pci_id);
outreg2 using Table3_C, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2 if politburo==0, robust cluster(pci_id);
outreg2 using Table3_C, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2 fulltime centralnom retirement  if  politburo==0, robust cluster(pci_id);
outreg2 using Table3_C, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2 interview fulltime centralnom retirement  if  politburo==0, robust cluster(pci_id);
outreg2 using Table3_C, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/


/*Interaction Difference 2*/
#delimit;
xi: reg  diff3_quest i.t2*fulltime centralnom retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3) replace;
xi: reg  diff3_quest i.t2*centralnom fulltime  retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3);
xi: reg  diff3_quest i.t2*retirement centralnom fulltime  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3);
xi: reg diff3_quest i.t2*percentage retirement centralnom fulltime   if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3);
/********************************************************************************************************************************/


xi: reg  diff3_crit i.t2*fulltime centralnom retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*centralnom fulltime  retirement  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*retirement centralnom fulltime  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*percentage retirement centralnom fulltime  if politburo==0, robust cluster(pci_id);
outreg2 using Appendix9, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/


/*Appendix 10: Internet Penetration*/
#delimit;
generate ln_pop=ln(pop);
#delimit;

xi: reg  diff3_quest i.t2*internet_users100 if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix10, e(all) bdec(3) tdec(3) replace;
xi: reg  diff3_quest i.t2*internet_users100 centralnom fulltime retirement  if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix10, e(all) bdec(3) tdec(3);
xi: reg  diff3_quest i.t2*internet_users100 centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix10, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*internet_users100 if politburo==0, robust cluster(pci_id);
outreg2 using Appendix10, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*internet_users100 centralnom fulltime retirement  if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix10, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*internet_users100 centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix10, e(all) bdec(3) tdec(3) excel;
/********************************************************************************************************************************/



/*Appendix 11c: Robust Dose Treatment*/
#delimit;
xi: reg  diff3_quest i.t2*thanh_thi_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix11, e(all) bdec(3) tdec(3);
xi: reg  diff3_quest i.t2*state_labor_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix11, e(all) bdec(3) tdec(3);
xi: reg  diff3_quest i.t2*student_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix11, e(all) bdec(3) tdec(3);

xi: reg  diff3_crit i.t2*thanh_thi_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix11, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*state_labor_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix11, e(all) bdec(3) tdec(3);
xi: reg  diff3_crit i.t2*student_per centralnom fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if  politburo==0, robust cluster(pci_id);
outreg2 using Appendix11, e(all) bdec(3) tdec(3) excel;
clear all;
/********************************************************************************************************************************/



/**************************Appendix 5a&b********************/
#delimit;
set more off;
use electionresults_replication_public2.dta, clear;
foreach num of numlist 1(1)6 {;
nbreg question_count percentage if session==`num', robust cluster(pci_id);
predict p_`num';
predict se_`num', stdp;
generate low_`num'=p_`num'-(se_`num'*1.6);
generate hi_`num'=p_`num'+(se_`num'*1.6);
twoway (scatter p_`num' percentage, mcolor(blue) msymbol(diamond) msize(small)) 
(scatter low_`num' percentage, msize(vsmall) msymbol(circle) mcolor(black)) 
(scatter  hi_`num' percentage, msize(vsmall) msymbol(circle) mcolor(black)),
legend(off) ytitle("Questions", size(medlarge) margin(medsmall)) xtitle("Vote Share", size(medlarge) margin(medsmall)) title(Session `num', size(vlarge));
graph save session_`num'.gph, replace;
};

graph combine session_1.gph session_2.gph session_3.gph  session_4.gph  session_5.gph  session_6.gph, rows(3) cols(3) xcommon ycommon;
graph save Appendix5.gph, replace;

#delimit;
generate ln_crit=ln(criticize_total_per+1);
generate ln_local=ln(local_total_per+1);
generate ln_cutri=ln(cutri_total_per+1);


/*Appendix 5b*/
#delimit;
xi: nbreg speaknum  i.fulltime*centralnom percentage south transfer if session==6, cluster(pci_id);
outreg2 using Appendix5, e(all) tdec(3) bdec(3) replace;
xi: nbreg question_count  i.fulltime*centralnom percentage south transfer if session==6, cluster(pci_id);
outreg2 using Appendix5, e(all) tdec(3) bdec(3);
xi: reg ln_crit i.fulltime*centralnom percentage south transfer if session==6, cluster(pci_id);
outreg2 using Appendix5, e(all) tdec(3) bdec(3);
xi: reg ln_local i.fulltime*centralnom percentage south transfer if session==6, cluster(pci_id) ;
outreg2 using Appendix5, e(all) tdec(3) bdec(3);
xi: reg ln_cutri i.fulltime*centralnom percentage south transfer if session==6, cluster(pci_id) ;
outreg2 using Appendix5, e(all) tdec(3) bdec(3) excel;
/********************************************************************************************************************************/

