/*******************************************/

  This code replicates the results from 
  "Newspaper Market Structure and Behavior: 
  Partisan Coverage of Political Scandals 
  in the U.S. from 1870 to 1910"

********************************************/

set more off

# delimit ;

use scandal_data, clear;

local controls "urban1 urban2 white male21 lmoutput lmwage ltotpop";

/* VARIABLES (INTERACTION TERMS) */

foreach x in opp own all {;
	gen i_`x'_log_num = `x' * log_num;
	gen i_`x'_year    = `x' * year;
};

/* VARIABLE LABELS */

label var i_opp_log_num         "Opposition Party $\times$ Log Newspapers";
label var i_own_log_num         "Own Party $\times$ Log Newspapers";
label var i_all_log_num         "Overall Bias $\times$ Log Newspapers";
label var i_opp_year            "Opposition Party $\times$ Year";
label var i_own_year            "Own Party $\times$ Year";
label var i_all_year            "Overall Bias $\times$ Year";

/* INVESTIGATE BIAS AS A FUNCTION OF THE LOG OF NUMBER OF NEWSPAPERS */

/* TABLE 3 */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                                             i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                          year  `controls'   i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num                     i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year  `controls'   i.scandal , cluster(scandal);

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                                             i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                          year  `controls'   i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num                     i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year  `controls'   i.scandal , cluster(scandal);

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                                             i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                          year  `controls'   i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num                     i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year  `controls'   i.scandal , cluster(scandal);

esttab using table3.txt, replace label nostar nomtitles nonotes nodepvar b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits)
 keep(freq in_state in_region log_num opp i_opp_log_num own i_own_log_num all i_all_log_num) 
order(freq in_state in_region log_num opp i_opp_log_num own i_own_log_num all i_all_log_num) 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");


/* INCLUDE COUNTY-LEVEL DEMOCRATIC SHARE OF PRESIDENTIAL VOTE */

/* TABLE 4 */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                                 i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                          year   i_opp_vs  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num         i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year   i_opp_vs  `controls'  i.scandal , cluster(scandal);

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                                 i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                          year   i_opp_vs  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num         i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year   i_opp_vs  `controls'  i.scandal , cluster(scandal);

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                                 i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                          year   i_opp_vs  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num         i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year   i_opp_vs  `controls'  i.scandal , cluster(scandal);

esttab using table4.tex, replace label nostar nomtitles nonotes nodepvar b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits)
 keep(freq in_state in_region log_num opp i_opp_log_num own i_own_log_num all i_all_log_num i_opp_vs) 
order(freq in_state in_region log_num opp i_opp_log_num own i_own_log_num all i_all_log_num i_opp_vs) 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");



/* INCLUDE EACH BIAS VARIABLE TIMES LINEAR TIME TREND */

/* TABLE 5 */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year  i_opp_year              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year  i_opp_year  `controls'  i.scandal , cluster(scandal);

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year  i_own_year              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year  i_own_year  `controls'  i.scandal , cluster(scandal);

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year  i_all_year              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year  i_all_year  `controls'  i.scandal , cluster(scandal);

esttab using table5.tex, replace label nostar nomtitles nonotes nodepvar b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits)
 keep(log_num opp i_opp_log_num own i_own_log_num all i_all_log_num i_opp_vs year i_opp_year i_own_year i_all_year) 
order(log_num opp i_opp_log_num own i_own_log_num all i_all_log_num i_opp_vs year i_opp_year i_own_year i_all_year) 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");


/* MAKE GRAPH SHOWING ESTIMATED EFFECTS AS A FUNCTION OF THE NUMBER OF NEWSPAPERS */

/* FIGURE 1 */

xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  i.scandal , cluster(scandal);
local b1 = _b[opp];
local b2 = _b[log_num];
local b3 = _b[i_opp_log_num];
gen y_hat_opp = `b1' + (`b3' + `b2') * log_num;

xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  i.scandal , cluster(scandal);
local b1 = _b[own];
local b2 = _b[log_num];
local b3 = _b[i_own_log_num];
gen y_hat_own = `b1' + (`b3' + `b2') * log_num;

xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  i.scandal , cluster(scandal);
local b1 = _b[all];
local b2 = _b[log_num];
local b3 = _b[i_all_log_num];
gen y_hat_all = `b1' + (`b3' + `b2') * log_num;

label var y_hat_opp "Opp. Party Scandal";
label var y_hat_own "Own Party Scandal";
label var y_hat_all "Overall Bias Scandal";
label var num_tot   "Number of Newspapers";
label var log_num   "Log Newspapers";

sort log_num;
scatter y_hat_opp y_hat_own y_hat_all num_tot if num_tot<=10, yline(0) xlabel(1 2 3 4 5 6 7 8 9 10) ylabel(-1.5 -1 -.5 0 .5 1 1.5 2 2.5) c(l l l) s(i i i) lc(gs0 gs7 gs10) ytitle("Relative Hits") ;
graph export graph_showing_effects.pdf, replace;


/* ONLINE APPENDIX TABLES - SPLITS TABLES 3, 4, 5 INTO 9 TABLES */

/* TABLE 3 */

/* (ONLINE APPENDIX TABLE 1) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                                           i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                          year  `controls' i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num                   i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year  `controls' i.scandal , cluster(scandal);

esttab using table_app_1.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num opp i_opp_log_num year `controls') 
order(freq in_state in_region log_num opp i_opp_log_num year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");

/* (ONLINE APPENDIX TABLE 2) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                                             i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                          year  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num                     i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year  `controls'  i.scandal , cluster(scandal);

esttab using table_app_2.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num own i_own_log_num year `controls') 
order(freq in_state in_region log_num own i_own_log_num year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");

/* (ONLINE APPENDIX TABLE 3) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                                             i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                          year  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num                     i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year  `controls'  i.scandal , cluster(scandal);

esttab using table_app_3.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num all i_all_log_num year `controls') 
order(freq in_state in_region log_num all i_all_log_num year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");


/* TABLE 4 */

/* (ONLINE APPENDIX TABLE 4) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                                 i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp                          year  i_opp_vs  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num         i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year  i_opp_vs  `controls'  i.scandal , cluster(scandal);

esttab using table_app_4.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num opp i_opp_log_num i_opp_vs year `controls') 
order(freq in_state in_region log_num opp i_opp_log_num i_opp_vs year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");

/* (ONLINE APPENDIX TABLE 5) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                                 i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own                          year  i_opp_vs  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num         i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year  i_opp_vs  `controls'  i.scandal , cluster(scandal);

esttab using table_app_5.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num own i_own_log_num i_opp_vs year `controls') 
order(freq in_state in_region log_num own i_own_log_num i_opp_vs year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");

/* (ONLINE APPENDIX TABLE 6) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                                 i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all                          year  i_opp_vs  `controls'  i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num         i_opp_vs              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year  i_opp_vs  `controls'  i.scandal , cluster(scandal);

esttab using table_app_6.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num all i_all_log_num i_opp_vs year `controls') 
order(freq in_state in_region log_num all i_all_log_num i_opp_vs year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");


/* TABLE 5 */

/* (ONLINE APPENDIX TABLE 7) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year            i_opp_year              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  opp  log_num  i_opp_log_num  year            i_opp_year  `controls'  i.scandal , cluster(scandal);

esttab using table_app_7.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num opp i_opp_log_num year i_opp_year `controls') 
order(freq in_state in_region log_num opp i_opp_log_num year i_opp_year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");

/* (ONLINE APPENDIX TABLE 8) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year            i_own_year              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  own  log_num  i_own_log_num  year            i_own_year  `controls'  i.scandal , cluster(scandal);

esttab using table_app_8.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num own i_own_log_num year i_own_year `controls') 
order(freq in_state in_region log_num own i_own_log_num year i_own_year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal." "Scandal fixed effects included in all columns." "Even numbered columns include all additional controls.");

/* (ONLINE APPENDIX TABLE 9) */

eststo clear;

eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year            i_all_year              i.scandal , cluster(scandal);
eststo: xi: quietly reg  hits_scandal_rel  freq  in_state  in_region  all  log_num  i_all_log_num  year            i_all_year  `controls'  i.scandal , cluster(scandal);

esttab using table_app_9.tex, replace label nostar nodepvar nomtitles nonotes b(%5.3f) se(%5.3f) title(Newspaper Biases: Dependent Variable = Relative Hits) nomtitles
 keep(freq in_state in_region log_num all i_all_log_num year i_all_year `controls') 
order(freq in_state in_region log_num all i_all_log_num year i_all_year `controls') 
addnotes("Standard errors in parentheses, clustered by scandal" "Scandal fixed effects included in all columns" "Even numbered columns include all additional controls");


/* SUMMARY STATISTICS */

/* APPENDIX TABLE 2 */

eststo clear ;

eststo: quietly estpost sum hits_scandal_rel hits_scandal_null freq in_state in_region log_num opp own all;

esttab using table_sum1.tex, replace label cells("min(label(Min) fmt(%5.3f)) max(label(Max)) mean(label(Mean)) sd(label(Std. Dev.)) count(label(N) f(0))") noobs nomtitles nonumbers alignment(rrrcc)
  title(Summary Statistics: Baseline Estimates);  
  
eststo clear ;

eststo: quietly estpost sum hits_scandal_rel hits_scandal_null freq in_state in_region log_num opp own all i_opp_vs if i_opp_vs != .;

esttab using table_sum2.tex, replace label cells("min(label(Min) fmt(%5.3f)) max(label(Max)) mean(label(Mean)) sd(label(Std. Dev.)) count(label(N) f(0))") noobs nomtitles nonumbers alignment(rrrcc)
  title(Summary Statistics: With Voter Partisanship);


/* TABLE 1 */

# delimit ;

keep year1 year2 scandal office_type party_s_int;
duplicates drop;

latab party_s_int, dec(1);
latab office_type, dec(1);


/* TABLE 2 */

use scandal_data, clear;

keep state_n city newspaper party_n_int;
duplicates drop;
latab party_n_int, dec(1);

use scandal_data, clear;
keep city newspaper state_n num_tot2;
duplicates drop;

latab num_tot2, dec(1);







