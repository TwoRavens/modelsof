/* Replication Code For:

How Much of the Incumbency Advantage is Due to Scare-off?
Andrew B. Hall and James M. Snyder, Jr.
Political Science Research and Methods

Date: 9/2/14 */

/* NOTE: This file produces two types of output:
First, it outputs .tex files for all tables in the paper.
Second, it produces .dta files to be read into R for graphics.
Please see accompanying R code for graphics.
*/


#delimit;
clear all;

set linesize 255;

/* Set working directory here */
/* cd "~/Dropbox/State Elections Data/Chall_Quality_RDD"; */
cd "C:/Users/Babak/Desktop/Hall";

/* RDD margin */
local margin = 5;

/* MAKE LOCALS CONTAINING RESULTS FOR LATEX TABLES */

/* STATEWIDE OFFICES */

use tmp_rdd_us_statewide, clear;

matrix D = J(3, 1, .);
matrix D2 = J(3, 1, .);

/* Drop cases where third party in top 2 */
gen to_drop = pct_I > pct_D | pct_I > pct_R;

/* Count how many cases are dropped for this */
count if to_drop == 1;
local num_drop = r(N);

tab to_drop;
local frac_dropped = `num_drop' / r(N);

matrix D[1,1] = `frac_dropped';

count if to_drop == 1 & share_first - share_second < 5;
local num_drop = r(N);

tab to_drop if share_first - share_second < 5;
local frac_dropped = `num_drop' / r(N);

matrix D2[1,1] = `frac_dropped';

/* Make pct_D the two-party vote share */
replace pct_D = pct_D/(pct_D + pct_R);

/* RDs on quality and victory */
reg next_qual_D treat rv_treat rv if margin < `margin', robust;
local SW_B_qual_D = _b[treat];
local SW_S_qual_D = _se[treat];
local SW_N_qual_D = e(N);
reg next_qual_R treat rv_treat rv if margin < `margin', robust;
local SW_B_qual_R = _b[treat];
local SW_S_qual_R = _se[treat];
local SW_N_qual_R = e(N);
reg next_win_D  treat rv_treat rv if margin < `margin', robust;
local SW_B_win_D = _b[treat];
local SW_S_win_D = _se[treat];
local SW_N_win_D = e(N);

gen next_diff = next_qual_D - next_qual_R;
reg next_diff treat rv_treat rv if margin < `margin', robust;
local SW_B_diff_D = _b[treat];
local SW_S_diff_D = _se[treat];
local SW_N_diff_D = e(N);

reg next_pct_D  treat rv_treat rv if margin < `margin', robust;
local SW_B_vs_D = _b[treat];
local SW_S_vs_D = _se[treat];
local SW_N_vs_D = e(N);

gen qual_diff = qual_D - qual_R;

reg qual_diff  treat rv_treat rv if margin < `margin', robust;
local SW_balance_diff = _b[treat];
local SW_balance_diff_S = _se[treat];
local SW_N_balance_diff = e(N);


foreach j in 2 {;
  foreach i of varlist *_L *_W {;
    sum `i' if margin < `j'+2 & next_cand_L != .;
    local SW_ALL_`j'_N   = r(N);
    if strpos("`i'","pct") == 0 {;
      local SW_ALL_`j'_`i' = 100 * r(mean);
    };
    else {;
      local SW_ALL_`j'_`i' = r(mean);
    };
  };
  local SW_ALL_`j'_next_inc_G  = `SW_ALL_`j'_next_win_W' - `SW_ALL_`j'_next_win_L';
  local SW_ALL_`j'_next_pct_G  = `SW_ALL_`j'_next_pct_W' - `SW_ALL_`j'_next_pct_L';
  local SW_ALL_`j'_chng_qual_L = `SW_ALL_`j'_next_qual_L' - `SW_ALL_`j'_qual_L';
  local SW_ALL_`j'_chng_qual_W = `SW_ALL_`j'_next_qual_W' - `SW_ALL_`j'_qual_W';
  local SW_ALL_`j'_chng_qual_G = `SW_ALL_`j'_chng_qual_W' - `SW_ALL_`j'_chng_qual_L';

  foreach i of varlist *_L *_W {;
	/* Note that j+2 = 4 means that vote is between 52 and 48 */
    sum `i' if margin < `j'+2 & next_cand_L != . & openseat == 1;
    local SW_OPEN_`j'_N   = r(N);
    if strpos("`i'","pct") == 0 {;
      local SW_OPEN_`j'_`i' = 100 * r(mean);
    };
    else {;
      local SW_OPEN_`j'_`i' = r(mean);
    };
  };
  local SW_OPEN_`j'_next_win_G  = `SW_OPEN_`j'_next_win_W' - `SW_OPEN_`j'_next_win_L';
  local SW_OPEN_`j'_next_pct_G  = `SW_OPEN_`j'_next_pct_W' - `SW_OPEN_`j'_next_pct_L';
  local SW_OPEN_`j'_chng_qual_L = `SW_OPEN_`j'_next_qual_L' - `SW_OPEN_`j'_qual_L';
  local SW_OPEN_`j'_chng_qual_W = `SW_OPEN_`j'_next_qual_W' - `SW_OPEN_`j'_qual_W';
  local SW_OPEN_`j'_chng_qual_G = `SW_OPEN_`j'_chng_qual_W' - `SW_OPEN_`j'_chng_qual_L';
};

/* Future scare-off tests */

gen net_qual2 = next_qual_D_2 - next_qual_R_2;
gen net_qual3 = next_qual_D_3 - next_qual_R_3;
gen net_qual4 = next_qual_D_4 - next_qual_R_4;

reg next_diff treat rv rv_treat rv if margin < `margin', robust;
reg net_qual2 treat rv_treat rv if margin < `margin', robust;
reg net_qual3 treat rv_treat rv if margin < `margin', robust;
reg net_qual4 treat rv_treat rv if margin < `margin', robust;

matrix B = J(4, 4, .);

reg next_diff treat rv rv_treat rv if margin < `margin', robust;
matrix B[1, 1] = 1;
matrix B[1, 2] = _b[treat];
matrix B[1, 3] = _b[treat] - 1.96*_se[treat];
matrix B[1, 4] = _b[treat] + 1.96*_se[treat];

reg net_qual2 treat rv_treat rv if margin < `margin', robust;
matrix B[2, 1] = 2;
matrix B[2, 2] = _b[treat];
matrix B[2, 3] = _b[treat] - 1.96*_se[treat];
matrix B[2, 4] = _b[treat] + 1.96*_se[treat];

reg net_qual3 treat rv_treat rv if margin < `margin', robust;
matrix B[3, 1] = 3;
matrix B[3, 2] = _b[treat];
matrix B[3, 3] = _b[treat] - 1.96*_se[treat];
matrix B[3, 4] = _b[treat] + 1.96*_se[treat];

reg net_qual4 treat rv_treat rv if margin < `margin', robust;
matrix B[4, 1] = 4;
matrix B[4, 2] = _b[treat];
matrix B[4, 3] = _b[treat] - 1.96*_se[treat];
matrix B[4, 4] = _b[treat] + 1.96*_se[treat];

/* Save off estimates for R graph */

preserve;
svmat B;
keep B*;
keep if B1 != .;
saveold downstream_r_graph.dta, replace;
restore;


/* U.S. HOUSE */

use tmp_rdd_us_house_period_2, clear;

gen to_drop = pct_I > pct_D | pct_I > pct_R;

count if to_drop == 1;
local num_drop = r(N);

tab to_drop;
local frac_dropped = `num_drop' / r(N);

matrix D[2,1] = `frac_dropped';

count if to_drop == 1 & share_first - share_second < 5;
local num_drop = r(N);

tab to_drop if share_first - share_second < 5;
local frac_dropped = `num_drop' / r(N);

matrix D2[2,1] = `frac_dropped';

replace pct_D = pct_D/(pct_D + pct_R);

reg next_qual_D treat rv_treat rv if margin < `margin', robust;
local C2_B_qual_D = _b[treat];
local C2_S_qual_D = _se[treat];
local C2_N_qual_D = e(N);
reg next_qual_R treat rv_treat rv if margin < `margin', robust;
local C2_B_qual_R = _b[treat];
local C2_S_qual_R = _se[treat];
local C2_N_qual_R = e(N);
reg next_win_D  treat rv_treat rv if margin < `margin', robust;
local C2_B_win_D = _b[treat];
local C2_S_win_D = _se[treat];
local C2_N_win_D = e(N);

gen next_diff = next_qual_D - next_qual_R;
reg next_diff treat rv_treat rv if margin < `margin', robust;
local C2_B_diff_D = _b[treat];
local C2_S_diff_D = _se[treat];
local C2_N_diff_D = e(N);

reg next_pct_D  treat rv_treat rv if margin < `margin', robust;
local C2_B_vs_D = _b[treat];
local C2_S_vs_D = _se[treat];
local C2_N_vs_D = e(N);

gen qual_diff = qual_D - qual_R;

reg qual_diff  treat rv_treat rv if margin < `margin', robust;
local C2_balance_diff = _b[treat];
local C2_balance_diff_S = _se[treat];
local C2_N_balance_diff = e(N);

foreach j in 2 {;
  foreach i of varlist *_L *_W {;
    sum `i' if margin < `j'+2 & next_cand_L != .;
    local C2_ALL_`j'_N   = r(N);
    if strpos("`i'","pct") == 0 {;
      local C2_ALL_`j'_`i' = 100 * r(mean);
    };
    else {;
      local C2_ALL_`j'_`i' = r(mean);
    };
  };
  local C2_ALL_`j'_next_win_G  = `C2_ALL_`j'_next_win_W' - `C2_ALL_`j'_next_win_L';
  local C2_ALL_`j'_next_pct_G  = `C2_ALL_`j'_next_pct_W' - `C2_ALL_`j'_next_pct_L';
  local C2_ALL_`j'_chng_qual_L = `C2_ALL_`j'_next_qual_L' - `C2_ALL_`j'_qual_L';
  local C2_ALL_`j'_chng_qual_W = `C2_ALL_`j'_next_qual_W' - `C2_ALL_`j'_qual_W';
  local C2_ALL_`j'_chng_qual_G = `C2_ALL_`j'_chng_qual_W' - `C2_ALL_`j'_chng_qual_L';

  foreach i of varlist *_L *_W {;
    sum `i' if margin < `j'+2 & next_cand_L != . & openseat == 1;
    local C2_OPEN_`j'_N   = r(N);
    if strpos("`i'","pct") == 0 {;
      local C2_OPEN_`j'_`i' = 100 * r(mean);
    };
    else {;
      local C2_OPEN_`j'_`i' = r(mean);
    };
  };
  local C2_OPEN_`j'_next_win_G  = `C2_OPEN_`j'_next_win_W' - `C2_OPEN_`j'_next_win_L';
  local C2_OPEN_`j'_next_pct_G  = `C2_OPEN_`j'_next_pct_W' - `C2_OPEN_`j'_next_pct_L';
  local C2_OPEN_`j'_chng_qual_L = `C2_OPEN_`j'_next_qual_L' - `C2_OPEN_`j'_qual_L';
  local C2_OPEN_`j'_chng_qual_W = `C2_OPEN_`j'_next_qual_W' - `C2_OPEN_`j'_qual_W';
  local C2_OPEN_`j'_chng_qual_G = `C2_OPEN_`j'_chng_qual_W' - `C2_OPEN_`j'_chng_qual_L';
};


/* STATE SENATES */

use tmp_rdd_stleg, clear;

gen to_drop =  pct_I > pct_D | pct_I > pct_R;

count if to_drop == 1;
local num_drop = r(N);

tab to_drop;
local frac_dropped = `num_drop' / r(N);

matrix D[3,1] = `frac_dropped';

count if to_drop == 1 & share_first - share_second < 5;
local num_drop = r(N);

tab to_drop if share_first - share_second < 5;
local frac_dropped = `num_drop' / r(N);

matrix D2[3,1] = `frac_dropped';


replace pct_D = pct_D/(pct_D + pct_R);

keep if office == "S" & year >= 1978;

reg next_qual_D treat rv_treat rv if margin < `margin', robust;
local SS_B_qual_D = _b[treat];
local SS_S_qual_D = _se[treat];
local SS_N_qual_D = e(N);
reg next_qual_R treat rv_treat rv if margin < `margin', robust;
local SS_B_qual_R = _b[treat];
local SS_S_qual_R = _se[treat];
local SS_N_qual_R = e(N);
reg next_win_D  treat rv_treat rv if margin < `margin', robust;
local SS_B_win_D = _b[treat];
local SS_S_win_D = _se[treat];
local SS_N_win_D = e(N);

gen next_diff = next_qual_D - next_qual_R;
reg next_diff treat rv_treat rv if margin < `margin', robust;
local SS_B_diff_D = _b[treat];
local SS_S_diff_D = _se[treat];
local SS_N_diff_D = e(N);

reg next_pct_D  treat rv_treat rv if margin < `margin', robust;
local SS_B_vs_D = _b[treat];
local SS_S_vs_D = _se[treat];
local SS_N_vs_D = e(N);

gen qual_diff = qual_D - qual_R;

reg qual_diff  treat rv_treat rv if margin < `margin', robust;
local SS_balance_diff = _b[treat];
local SS_balance_diff_S = _se[treat];
local SS_N_balance_diff = e(N);

foreach j in 2{;
  foreach i of varlist *_L *_W {;
    sum `i' if margin < `j'+2 & next_cand_L != .;
    local SS_ALL_`j'_N   = r(N);
    if strpos("`i'","pct") == 0 {;
      local SS_ALL_`j'_`i' = 100 * r(mean);
    };
    else {;
      local SS_ALL_`j'_`i' = r(mean);
    };
  };
  local SS_ALL_`j'_next_win_G  = `SS_ALL_`j'_next_win_W' - `SS_ALL_`j'_next_win_L';
  local SS_ALL_`j'_next_pct_G  = `SS_ALL_`j'_next_pct_W' - `SS_ALL_`j'_next_pct_L';
  local SS_ALL_`j'_chng_qual_L = `SS_ALL_`j'_next_qual_L' - `SS_ALL_`j'_qual_L';
  local SS_ALL_`j'_chng_qual_W = `SS_ALL_`j'_next_qual_W' - `SS_ALL_`j'_qual_W';
  local SS_ALL_`j'_chng_qual_G = `SS_ALL_`j'_chng_qual_W' - `SS_ALL_`j'_chng_qual_L';

  foreach i of varlist *_L *_W {;
    sum `i' if margin < `j'+2 & next_cand_L != . & openseat == 1;
    local SS_OPEN_`j'_N   = r(N);
    if strpos("`i'","pct") == 0 {;
      local SS_OPEN_`j'_`i' = 100 * r(mean);
    };
    else {;
      local SS_OPEN_`j'_`i' = r(mean);
    };
  };
  local SS_OPEN_`j'_next_win_G  = `SS_OPEN_`j'_next_win_W' - `SS_OPEN_`j'_next_win_L';
  local SS_OPEN_`j'_next_pct_G  = `SS_OPEN_`j'_next_pct_W' - `SS_OPEN_`j'_next_pct_L';
  local SS_OPEN_`j'_chng_qual_L = `SS_OPEN_`j'_next_qual_L' - `SS_OPEN_`j'_qual_L';
  local SS_OPEN_`j'_chng_qual_W = `SS_OPEN_`j'_next_qual_W' - `SS_OPEN_`j'_qual_W';
  local SS_OPEN_`j'_chng_qual_G = `SS_OPEN_`j'_chng_qual_W' - `SS_OPEN_`j'_chng_qual_L';
};



/* MAKE LATEX TABLES */

quietly {;
	cap log close;
	log using balance_table.tex, text replace;
	noisily display "\begin{table}[h]";
	noisily display "\centering";
	noisily display "\caption*{\bf Table A3 -- Balance Tests for RDD}";
    noisily display "\begin{tabular}{lccc}";
    noisily display "\toprule \toprule";
	noisily display " & U.S. House & Statewide Offices & State Senates \\";
	noisily display "\midrule";
	noisily display "Dem Win at $ t $    & " %5.2f `C2_balance_diff' " & " %5.2f `SW_balance_diff' " & " %5.2f `SS_balance_diff' " \\";
	noisily display " & (" %3.2f `C2_balance_diff_S' ") & (" %3.2f `SW_balance_diff_S' ") & (" %3.2f `SS_balance_diff_S' ") \\";
	noisily display "\midrule";
  	noisily display "\# Observations       &  " %3.0f `C2_N_balance_diff' " &  " %3.0f `SW_N_balance_diff' "  &  " %3.0f `SS_N_balance_diff' " \\ [.01in]";
	noisily display "\bottomrule \bottomrule";
	noisily display "\end{tabular}";
	noisily display "\end{table}";
	log close;
};

quietly {;

  log using table_2.tex, text replace;

  noisily display "";
  noisily display "\begin{table}[h]";
  noisily display "\centering";
  noisily display "\footnotesize";
    noisily display "\caption*{\bf Table 1b -- Summary Statistics on Candidate Experience and Winning (Win Margin $<$ 2); Statewide Offices, 1970-2010}";
  noisily display "\begin{tabular}{lcc}";
  noisily display "\toprule \toprule";
  noisily display "Variable & \multicolumn{1}{c}{All Races} & \multicolumn{1}{c}{Open-Seat Races} \\";
  noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Electoral Outcomes} \\";
  noisily display "\midrule";
  noisily display "\% Wins at $ t \!+\! 1 $, Party Losing at $ t $                                     &     " %5.1f `SW_ALL_2_next_win_L'   " &     "  %5.1f `SW_OPEN_2_next_win_L'  " \\ [.02in]";
  noisily display "\% Wins at $ t \!+\! 1 $, Party Winning at $ t $                                    &     "  %5.1f `SW_ALL_2_next_win_W'   " &     "  %5.1f `SW_OPEN_2_next_win_W'  " \\ [.02in]";
  noisily display "\bf \hspace{5mm} Difference in \% Wins at $ \mathbf t \!+\! 1 $                                  & \bf "  %5.1f `SW_ALL_2_next_win_G'   " & \bf "  %5.1f `SW_OPEN_2_next_win_G'  " \\ [.10in]";
  noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Candidate Experience} \\";
  noisily display "\midrule";
  noisily display "\% Experienced at $ t $, Party Losing at $ t $                            &     "  %5.1f `SW_ALL_2_qual_L'       " &     "  %5.1f `SW_OPEN_2_qual_L'      " \\ [.02in]";
  noisily display "\% Experienced at $ t \!+\! 1 $, Party Losing at $ t $                    &     "  %5.1f `SW_ALL_2_next_qual_L'  " &     "  %5.1f `SW_OPEN_2_next_qual_L' " \\ [.02in]";
  noisily display "\hspace{5mm} \bf Change from $ t $ to $ t + 1 $ & \bf" %5.1f (`SW_ALL_2_next_qual_L' - `SW_ALL_2_qual_L') " & \bf" %5.1f (`SW_OPEN_2_next_qual_L' - `SW_OPEN_2_qual_L' ) " \\ [.1in] ";
  
  noisily display "\% Experienced at $ t $, Party Winning at $ t $                           &     "  %5.1f `SW_ALL_2_qual_W'       " &     "  %5.1f `SW_OPEN_2_qual_W'      " \\ [.02in]";
  noisily display "\% Experienced$^*$ at $ t \!+\! 1 $, Party Winning at $ t $               &     "  %5.1f `SW_ALL_2_next_qual_W'  " &     "  %5.1f `SW_OPEN_2_next_qual_W' " \\ [.02in]";
  noisily display "\bf \hspace{5mm} Change from $ t $ to $ t + 1 $ & \bf " %5.1f (`SW_ALL_2_next_qual_W' - `SW_ALL_2_qual_W') " & \bf " %5.1f (`SW_OPEN_2_next_qual_W' - `SW_OPEN_2_qual_W' ) " \\ [.1in] ";

  
  
  noisily display "\bf Diff. in Change in \% Experienced $ \mathbf t $ to $ \mathbf t \!+\! 1 $  & \bf "  %5.1f `SW_ALL_2_chng_qual_G'  " & \bf "  %5.1f `SW_OPEN_2_chng_qual_G' " \\ [.10in]";

  noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Competition} \\";
  noisily display "\midrule";

  noisily display "\% With Candidate at $ t \!+\! 1 $, Party Losing at $ t $                           &     "  %5.1f `SW_ALL_2_next_cand_L'  " &     " %5.1f `SW_OPEN_2_next_cand_L' " \\ [.02in]";
  noisily display "\% With Candidate at $ t \!+\! 1 $, Party Winning at $ t $                          &     "  %5.1f `SW_ALL_2_next_cand_W'  " &     " %5.1f `SW_OPEN_2_next_cand_W' " \\ [.02in]";
  noisily display "\% Same Candidate at $ t \!+\! 1 $, Party Winning at $ t $                          &     "  %5.1f `SW_ALL_2_next_same_W'   " &     " %5.1f `SW_OPEN_2_next_same_W'  " \\ [.02in]";
  noisily display "\% Same Candidate at $ t \!+\! 1 $, Party Losing at $ t $                          &     "  %5.1f `SW_ALL_2_next_same_L'   " &     " %5.1f `SW_OPEN_2_next_same_L'  " \\ [.10in]";

  noisily display "Number of races                                                                     &     " %3.0f `SW_ALL_2_N'            " &     "  %3.0f `SW_OPEN_2_N'           " \\ [.05in]";


  noisily display "\bottomrule \\[-.12in]";
	   noisily display "\multicolumn{3}{p{.8\textwidth}}{$^*$ The officeholding due to the victory at $ t $ is not included in calculating \% Experienced for the Party Winning at $ t $.}";

  noisily display "\end{tabular}";

  noisily display "\end{table}";
  noisily display "";
  noisily display "\clearpage";
  noisily display "";
  
  log close;

 };


quietly {;

  log using table_1.tex, text replace;
  
  noisily display "";
  noisily display "\begin{table}[h]";
  noisily display "\centering";
  noisily display "\footnotesize";
    noisily display "\caption*{\bf Table 1a -- Summary Statistics on Candidate Experience and Winning (Win Margin $<$ 2); U.S. House, 1948-2010}";
  noisily display "\begin{tabular}{lcc}";
  noisily display "\toprule \toprule";
  noisily display "Variable & \multicolumn{1}{c}{All Races} & \multicolumn{1}{c}{Open-Seat Races} \\";
   noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Electoral Outcomes} \\";
  noisily display "\midrule";
  noisily display "\% Wins at $ t \!+\! 1 $, Party Losing at $ t $                                     &     " %5.1f `C2_ALL_2_next_win_L'   " &     "  %5.1f `C2_OPEN_2_next_win_L'  " \\ [.02in]";
  noisily display "\% Wins at $ t \!+\! 1 $, Party Winning at $ t $                                    &     "  %5.1f `C2_ALL_2_next_win_W'   " &     "  %5.1f `C2_OPEN_2_next_win_W'  " \\ [.02in]";
  noisily display "\bf \hspace{5mm} Difference in \% Wins at $ \mathbf t \!+\! 1 $                                  & \bf "  %5.1f `C2_ALL_2_next_win_G'   " & \bf "  %5.1f `C2_OPEN_2_next_win_G'  " \\ [.10in]";

  noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Candidate Experience} \\";
  noisily display "\midrule";

  noisily display "\% Experienced at $ t $, Party Losing at $ t $                            &     "  %5.1f `C2_ALL_2_qual_L'       " &     "  %5.1f `C2_OPEN_2_qual_L'      " \\ [.02in]";
  noisily display "\% Experienced at $ t \!+\! 1 $, Party Losing at $ t $                    &     "  %5.1f `C2_ALL_2_next_qual_L'  " &     "  %5.1f `C2_OPEN_2_next_qual_L' " \\ [.02in]";
  noisily display "\hspace{5mm} \bf Change from $ t $ to $ t + 1 $ & \bf" %5.1f (`C2_ALL_2_next_qual_L' - `C2_ALL_2_qual_L') " & \bf" %5.1f (`C2_OPEN_2_next_qual_L' - `C2_OPEN_2_qual_L' ) " \\ [.1in] ";
  
  noisily display "\% Experienced at $ t $, Party Winning at $ t $                           &     "  %5.1f `C2_ALL_2_qual_W'       " &     "  %5.1f `C2_OPEN_2_qual_W'      " \\ [.02in]";
  noisily display "\% Experienced$^*$ at $ t \!+\! 1 $, Party Winning at $ t $               &     "  %5.1f `C2_ALL_2_next_qual_W'  " &     "  %5.1f `C2_OPEN_2_next_qual_W' " \\ [.02in]";
  noisily display "\bf \hspace{5mm} Change from $ t $ to $ t + 1 $ & \bf " %5.1f (`C2_ALL_2_next_qual_W' - `C2_ALL_2_qual_W') " & \bf " %5.1f (`C2_OPEN_2_next_qual_W' - `C2_OPEN_2_qual_W' ) " \\ [.1in] ";

  
  
  noisily display "\bf Diff. in Change in \% Experienced $ \mathbf t $ to $ \mathbf t \!+\! 1 $  & \bf "  %5.1f `C2_ALL_2_chng_qual_G'  " & \bf "  %5.1f `C2_OPEN_2_chng_qual_G' " \\ [.10in]";

  noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Competition} \\";
  noisily display "\midrule";

  noisily display "\% With Candidate at $ t \!+\! 1 $, Party Losing at $ t $                           &     "  %5.1f `C2_ALL_2_next_cand_L'  " &     " %5.1f `C2_OPEN_2_next_cand_L' " \\ [.02in]";
  noisily display "\% With Candidate at $ t \!+\! 1 $, Party Winning at $ t $                          &     "  %5.1f `C2_ALL_2_next_cand_W'  " &     " %5.1f `C2_OPEN_2_next_cand_W' " \\ [.02in]";
  noisily display "\% Same Candidate at $ t \!+\! 1 $, Party Winning at $ t $                          &     "  %5.1f `C2_ALL_2_next_same_W'   " &     " %5.1f `C2_OPEN_2_next_same_W'  " \\ [.02in]";
  noisily display "\% Same Candidate at $ t \!+\! 1 $, Party Losing at $ t $                          &     "  %5.1f `C2_ALL_2_next_same_L'   " &     " %5.1f `C2_OPEN_2_next_same_L'  " \\ [.10in]";

  noisily display "Number of races                                                                     &     " %3.0f `C2_ALL_2_N'            " &     "  %3.0f `C2_OPEN_2_N'           " \\ [.05in]";


  noisily display "\bottomrule \\[-.12in]";
	   noisily display "\multicolumn{3}{p{.8\textwidth}}{$^*$ The officeholding due to the victory at $ t $ is not included in calculating \% Experienced for the Party Winning at $ t $.}";

  noisily display "\end{tabular}";

  noisily display "\end{table}";
  noisily display "";
  noisily display "\clearpage";
  noisily display "";
  
  log close;
};


quietly {;

  log using table_3.tex, text replace;
  
  noisily display "";
  noisily display "\begin{table}[h]";
  noisily display "\centering";
  noisily display "\footnotesize";
    noisily display "\caption*{\bf Table 1c -- Summary Statistics on Candidate Experience and Winning (Win Margin $<$ 2); State Senates, 1978-2010}";
  noisily display "\begin{tabular}{lcc}";
  noisily display "\toprule \toprule";
  noisily display "Variable & \multicolumn{1}{c}{All Races} & \multicolumn{1}{c}{Open-Seat Races} \\";
   noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Electoral Outcomes} \\";
  noisily display "\midrule";
  noisily display "\% Wins at $ t \!+\! 1 $, Party Losing at $ t $                                     &     " %5.1f `SS_ALL_2_next_win_L'   " &     "  %5.1f `SS_OPEN_2_next_win_L'  " \\ [.02in]";
  noisily display "\% Wins at $ t \!+\! 1 $, Party Winning at $ t $                                    &     "  %5.1f `SS_ALL_2_next_win_W'   " &     "  %5.1f `SS_OPEN_2_next_win_W'  " \\ [.02in]";
  noisily display "\bf \hspace{5mm} Difference in \% Wins at $ \mathbf t \!+\! 1 $                                  & \bf "  %5.1f `SS_ALL_2_next_win_G'   " & \bf "  %5.1f `SS_OPEN_2_next_win_G'  " \\ [.10in]";

   noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Candidate Experience} \\";
  noisily display "\midrule";

  noisily display "\% Experienced at $ t $, Party Losing at $ t $                            &     "  %5.1f `SS_ALL_2_qual_L'       " &     "  %5.1f `SS_OPEN_2_qual_L'      " \\ [.02in]";
  noisily display "\% Experienced at $ t \!+\! 1 $, Party Losing at $ t $                    &     "  %5.1f `SS_ALL_2_next_qual_L'  " &     "  %5.1f `SS_OPEN_2_next_qual_L' " \\ [.02in]";
  noisily display "\hspace{5mm} \bf Change from $ t $ to $ t + 1 $ & \bf" %5.1f (`SS_ALL_2_next_qual_L' - `SS_ALL_2_qual_L') " & \bf" %5.1f (`SS_OPEN_2_next_qual_L' - `SS_OPEN_2_qual_L' ) " \\ [.1in] ";
  
  noisily display "\% Experienced at $ t $, Party Winning at $ t $                           &     "  %5.1f `SS_ALL_2_qual_W'       " &     "  %5.1f `SS_OPEN_2_qual_W'      " \\ [.02in]";
  noisily display "\% Experienced$^*$ at $ t \!+\! 1 $, Party Winning at $ t $               &     "  %5.1f `SS_ALL_2_next_qual_W'  " &     "  %5.1f `SS_OPEN_2_next_qual_W' " \\ [.02in]";
  noisily display "\bf \hspace{5mm} Change from $ t $ to $ t + 1 $ & \bf " %5.1f (`SS_ALL_2_next_qual_W' - `SS_ALL_2_qual_W') " & \bf " %5.1f (`SS_OPEN_2_next_qual_W' - `SS_OPEN_2_qual_W' ) " \\ [.1in] ";

  
  
  noisily display "\bf Diff. in Change in \% Experienced $ \mathbf t $ to $ \mathbf t \!+\! 1 $  & \bf "  %5.1f `SS_ALL_2_chng_qual_G'  " & \bf "  %5.1f `SS_OPEN_2_chng_qual_G' " \\ [.10in]";

   noisily display "\midrule";
  noisily display "\multicolumn{3}{c}{\bf Competition} \\";
  noisily display "\midrule";

  noisily display "\% With Candidate at $ t \!+\! 1 $, Party Losing at $ t $                           &     "  %5.1f `SS_ALL_2_next_cand_L'  " &     " %5.1f `SS_OPEN_2_next_cand_L' " \\ [.02in]";
  noisily display "\% With Candidate at $ t \!+\! 1 $, Party Winning at $ t $                          &     "  %5.1f `SS_ALL_2_next_cand_W'  " &     " %5.1f `SS_OPEN_2_next_cand_W' " \\ [.02in]";
  noisily display "\% Same Candidate at $ t \!+\! 1 $, Party Winning at $ t $                          &     "  %5.1f `SS_ALL_2_next_same_W'   " &     " %5.1f `SS_OPEN_2_next_same_W'  " \\ [.02in]";
  noisily display "\% Same Candidate at $ t \!+\! 1 $, Party Losing at $ t $                          &     "  %5.1f `SS_ALL_2_next_same_L'   " &     " %5.1f `SS_OPEN_2_next_same_L'  " \\ [.10in]";

  noisily display "Number of races                                                                     &     " %3.0f `SS_ALL_2_N'            " &     "  %3.0f `SS_OPEN_2_N'           " \\ [.05in]";


  noisily display "\bottomrule \\[-.12in]";
	   noisily display "\multicolumn{3}{p{.8\textwidth}}{$^*$ The officeholding due to the victory at $ t $ is not included in calculating \% Experienced for the Party Winning at $ t $.}";

  noisily display "\end{tabular}";

  noisily display "\end{table}";
  noisily display "";
  noisily display "";
  
  log close;

};


quietly {;

  log using cand_quality_rdd_table_andy.tex, text replace;

  noisily display "\begin{table}[h]";
  noisily display "\caption*{{\bf Table 2 -- RDD Estimates, Candidate Experience and Winning}}";
  noisily display "\centering";
  noisily display "\footnotesize";
  noisily display "\begin{tabular}{lcccc}";
  noisily display "\toprule\toprule";
  noisily display " & Dem Win       & Dem Candidate          & Repub Candidate & Dem - Repub   \\ ";
  noisily display " & at $ t \!+\! 1 $ & Experience at $ t \!+\! 1 $ & Experience at $ t \!+\! 1 $ & Experience at $ t \!+\! 1 $\\";
  noisily display "\midrule";
  
  
  noisily display "\multicolumn{5}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{5}{c}{\bf U.S. House of Representatives, 1948-2010} \\ [.10in]";
  noisily display "\midrule";

   noisily display " & & & & \\ [-.10in]";
  noisily display "Dem Win at $ t $    &  " %5.2f `C2_B_win_D'   " & " %5.2f `C2_B_qual_D' "  &  " %5.2f `C2_B_qual_R' " & " %5.2f `C2_B_diff_D' " \\ [0.05in]       ";
  noisily display "                      & (" %3.2f `C2_S_win_D' ") & (" %3.2f `C2_S_qual_D' ") & (" %3.2f `C2_S_qual_R' ") & (" %3.2f `C2_S_diff_D' ") \\ [0.05in]";
  noisily display " & [" %3.2f `C2_B_win_D' - 1.96*`C2_S_win_D' ", " %3.2f `C2_B_win_D'+1.96*`C2_S_win_D' "] &
  [" %3.2f `C2_B_qual_D'-1.96*`C2_S_qual_D' ", " %3.2f `C2_B_qual_D'+1.96*`C2_S_qual_D' "] & [" %3.2f `C2_B_qual_R'-1.96*`C2_S_qual_R' ", " %3.2f `C2_B_qual_R'+1.96*`C2_S_qual_R' "] & [" 
  %3.2f `C2_B_diff_D' - 1.96*`C2_S_diff_D' ", " %3.2f `C2_B_diff_D' + 1.96*`C2_S_diff_D' "] \\ [.1in]";
  noisily display "\# Observations       &  " %3.0f `C2_N_win_D' "  &  " %3.0f `C2_N_qual_D' "  &  " %3.0f `C2_N_qual_R' " & " %3.0f `C2_N_diff_D' "\\ [.05in]";
  noisily display "\midrule";
 

  noisily display "\multicolumn{5}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{5}{c}{\bf Statewide Offices, 1970-2010} \\ [.10in]";
  noisily display "\midrule";
  noisily display " & & & &  \\ [-.10in]";
  noisily display "Dem Win at $ t $    &  " %5.2f `SW_B_win_D'  "  & " %5.2f `SW_B_qual_D' "  &  " %5.2f `SW_B_qual_R' " & " %5.2f `SW_B_diff_D' " \\ [0.05in]       ";
  noisily display " & (" %3.2f `SW_S_win_D' ") & (" %3.2f `SW_S_qual_D' ") & (" %3.2f `SW_S_qual_R' ") & (" %3.2f `SW_S_diff_D' ") \\ [0.05in]";
  noisily display "	& [" %3.2f `SW_B_win_D' - 1.96*`SW_S_win_D' ", " %3.2f `SW_B_win_D'+1.96*`SW_S_win_D' "] & [" %3.2f `SW_B_qual_D'-1.96*`SW_S_qual_D' ", " %3.2f `SW_B_qual_D'+1.96*`SW_S_qual_D' "] & [" %3.2f `SW_B_qual_R'-1.96*`SW_S_qual_R' ", " %3.2f `SW_B_qual_R'+1.96*`SW_S_qual_R' "] & [" %3.2f `SW_B_diff_D'-1.96*`SW_S_diff_D' ", " %3.2f `SW_B_diff_D'+1.96*`SW_S_diff_D' "] \\ [.1in]";
  noisily display "\# Observations       &  " %3.0f `SW_N_win_D' " &  " %3.0f `SW_N_qual_D' "  &  " %3.0f `SW_N_qual_R' " & " %3.0f `SW_N_diff_D' " \\ [.05in]";
  noisily display "\midrule";

  noisily display "\multicolumn{5}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{5}{c}{\bf State Senates, 1978-2010} \\ [.10in]";
  noisily display "\midrule";

   noisily display " & & & & \\ [-.10in]";
  noisily display "Dem Win at $ t $    &  " %5.2f `SS_B_win_D'  " & " %5.2f `SS_B_qual_D' "  &  " %5.2f `SS_B_qual_R' " & " %5.2f `SS_B_diff_D' "\\ [0.05in]       ";
  noisily display "                      & (" %3.2f `SS_S_win_D' ") & (" %3.2f `SS_S_qual_D' ") & (" %3.2f `SS_S_qual_R' ") & (" %3.2f `SS_S_diff_D' ") \\ [0.05in]";
  noisily display "	& [" %3.2f `SS_B_win_D' - 1.96*`SS_S_win_D' ", " %3.2f `SS_B_win_D'+1.96*`SS_S_win_D' "] &
  [" %3.2f `SS_B_qual_D'-1.96*`SS_S_qual_D' ", " %3.2f `SS_B_qual_D'+1.96*`SS_S_qual_D' "] & [" %3.2f `SS_B_qual_R'-1.96*`SS_S_qual_R' ", " %3.2f `SS_B_qual_R'+1.96*`SS_S_qual_R' "] & [" %3.2f `SS_B_diff_D'-1.96*`SS_S_diff_D' ", " %3.2f `SS_B_diff_D'+1.96*`SS_S_diff_D' "] \\ [.1in]";
  noisily display "\# Observations       &  " %3.0f `SS_N_win_D' " &  " %3.0f `SS_N_qual_D' "  &  " %3.0f `SS_N_qual_R' " & " %3.0f `SS_N_diff_D' " \\ [.05in]";
  noisily display "\bottomrule\bottomrule \\[-.09in]";
  noisily display "\multicolumn{5}{p{.85\textwidth}}{The officeholding due to victory at $ t $ is not 
  included in calculating experience at $ t+1 $. Robust standard errors in parentheses; 95\% confidence intervals in brackets.";
  noisily display "RDD estimates are from Equation 1, using a local linear specification of the running variable with a 5 percentage-point bandwidth.}";
  noisily display "\end{tabular} \\[0.1in]";
  noisily display "\end{table}";
  noisily display "";

  log close;

};

local jac = 0.16;
local hyp = `C2_B_win_D'/2;
local hyp3 = `C2_B_win_D';
local SWhyp = `SW_B_win_D'/2;
local SWhyp3 = `SW_B_win_D';
local SShyp = `SS_B_win_D'/2;
local SShyp3 = `SS_B_win_D';
  

  
quietly {;

  log using calc_table.tex, text replace;
  noisily display "\begin{table}[h]";
  noisily display "\caption*{{\bf Table 3 -- Estimates of the Scare-Off Effect}}";
  noisily display "\centering";
  noisily display "\footnotesize";
  noisily display "\begin{tabular}{llcc}";
  noisily display "\toprule \toprule";
  noisily display " & & Estimated Scare-Off Effect &  Estimated Share \\";
  noisily display " & Estimator & On Win Probability & of Incumbency Advantage\\";
  noisily display "\midrule";
  noisily display "\multicolumn{4}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{4}{c}{\bf U.S. House, 1948-2010}\\[.1in]";
  noisily display "\midrule";
  noisily display " & \bf Hypothetical 1 & \bf " %5.2f (`C2_B_diff_D')*`hyp' " & \bf " %5.2f ((`C2_B_diff_D')*`hyp') / `C2_B_win_D' " \\";
  noisily display " & Hypothetical 2 & " %5.2f (`C2_B_diff_D')*`hyp3' " & " %5.2f ((`C2_B_diff_D')*`hyp3') / `C2_B_win_D' " \\";
  

  noisily display "\midrule";
  noisily display "\multicolumn{4}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{4}{c}{\bf Statewide Offices, 1970-2010}\\[.1in]";
  noisily display "\midrule";
  noisily display " & \bf Hypothetical 1 & \bf " %5.2f (`SW_B_diff_D')*`SWhyp' " & \bf " %5.2f ((`SW_B_diff_D')*`SWhyp') / `SW_B_win_D' " \\";
  noisily display " & Hypothetical 2 & " %5.2f (`SW_B_diff_D')*`SWhyp3' " & " %5.2f ((`SW_B_diff_D')*`SWhyp3') / `SW_B_win_D' " \\";
  
    noisily display "\midrule";
  noisily display "\multicolumn{4}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{4}{c}{\bf State Senates, 1978-2010}\\[.1in]";
  noisily display "\midrule";
  noisily display " & \bf Hypothetical 1 & \bf " %5.2f (`SS_B_diff_D')*`SShyp' " & \bf " %5.2f ((`SS_B_diff_D')*`SShyp') / `SS_B_win_D' " \\";
  noisily display " & Hypothetical 2 & " %5.2f (`SS_B_diff_D')*`SShyp3' " & " %5.2f ((`SS_B_diff_D')*`SShyp3') / `SS_B_win_D' " \\";
  
  noisily display "\bottomrule \bottomrule \\[-.1in]";
  noisily display "\multicolumn{4}{p{.8\textwidth}}{The first column multiplies each hypothetical estimate for the win-probability return to experience by the 
  estimated difference in quality caused by incumbency in the relevant electoral context.";  
  noisily display "The second column divides the first column by the estimated incumbency advantage for the given electoral context.}\\";
  noisily display "\end{tabular}";
  noisily display "\end{table}";
  
  log close;
  
};

quietly {;

  local jac = 2.8;
  local hyp = `C2_B_vs_D'/2;
  local hyp3 = `C2_B_vs_D';
  local SWhyp = `SW_B_vs_D'/2;
  local SWhyp3 = `SW_B_vs_D';
  local SShyp = `SS_B_vs_D'/2;
  local SShyp3 = `SS_B_vs_D';

  log using vote_share_table.tex, text replace;

  noisily display "\begin{table}[h]";
  noisily display "\caption*{{\bf Table A1 -- Incumbency and Vote Share}}";
  noisily display "\centering";
  noisily display "\footnotesize";
  noisily display "\begin{tabular}{lccc}";
  noisily display "\toprule\toprule";
  noisily display "& \bf U.S. House & \bf Statewide Offices & \bf State Senates \\";
  noisily display "& \bf 1948-2010 & \bf 1970-2010 & \bf 1978-2010 \\";
  noisily display "\midrule";
  noisily display "Dem Win at $ t $ & " %5.2f `C2_B_vs_D' " & " %5.2f `SW_B_vs_D' " & " %5.2f `SS_B_vs_D' " \\";
  noisily display " & (" %3.2f `C2_S_vs_D' ") & (" %3.2f `SW_S_vs_D' ") & (" %3.2f `SS_S_vs_D' ") \\[0.1in]";
  noisily display "\# Observations & " %3.0f `C2_N_vs_D' " & " %3.0f `SW_N_vs_D' " & " %3.0f `SS_N_vs_D' "\\";
  noisily display "\bottomrule \bottomrule \\[-.1in]";
  noisily display "\multicolumn{4}{p{.65\textwidth}}{Outcome variable is Democratic vote share at time $ t+1$.  Robust standard errors in parentheses; 95\% confidence intervals in brackets.";
  noisily display "RDD estimates are from Equation 1, using a local linear specification of the running variable with a 5 percentage-point bandwidth.}";
  noisily display "\end{tabular} \\[0.1in]";
  noisily display "\end{table}";
  noisily display "";
  
  noisily display "\begin{table}[h]";
  noisily display "\caption*{{\bf Table A2 -- Vote-share Estimates of the Scare-Off Effect}}";
  noisily display "\centering";
  noisily display "\footnotesize";
  noisily display "\begin{tabular}{llcc}";
  noisily display "\toprule \toprule";
  noisily display " & & Estimated Scare-Off Effect &  Estimated Share \\";
  noisily display " & Estimator & On Vote Percentage & of Incumbency Advantage\\";
  noisily display "\midrule";
  noisily display "\multicolumn{4}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{4}{c}{\bf U.S. House, 1948-2010}\\[.1in]";
  noisily display "\midrule";
  noisily display " & \bf Hypothetical 1 & \bf " %5.2f (`C2_B_diff_D')*`hyp' " & \bf " %5.2f ((`C2_B_diff_D')*`hyp') / `C2_B_vs_D' " \\";
  noisily display " & Hypothetical 2 & " %5.2f (`C2_B_diff_D')*`hyp3' " & " %5.2f ((`C2_B_diff_D')*`hyp3') / `C2_B_vs_D' " \\";
  
  
  
  
  noisily display "\midrule";
  noisily display "\multicolumn{4}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{4}{c}{\bf Statewide Offices, 1970-2010}\\[.1in]";
  noisily display "\midrule";
  noisily display " & \bf Hypothetical 1 & \bf " %5.2f (`SW_B_diff_D')*`SWhyp' " & \bf " %5.2f ((`SW_B_diff_D')*`SWhyp') / `SW_B_vs_D' " \\";
  noisily display " & Hypothetical 2 & " %5.2f (`SW_B_diff_D')*`SWhyp3' " & " %5.2f ((`SW_B_diff_D')*`SWhyp3') / `SW_B_vs_D' " \\";
  
  noisily display "\midrule";
  noisily display "\multicolumn{4}{c}{} \\ [-.10in]";
  noisily display "\multicolumn{4}{c}{\bf State Senates, 1978-2010}\\[.1in]";
  noisily display "\midrule";
  noisily display " & \bf Hypothetical 1 & \bf " %5.2f (`SS_B_diff_D')*`SShyp' " & \bf" %5.2f ((`SS_B_diff_D')*`SShyp') / `SS_B_vs_D' " \\";
  noisily display " & Hypothetical 2 & " %5.2f (`SS_B_diff_D')*`SShyp3' " & " %5.2f ((`SS_B_diff_D')*`SShyp3') / `SS_B_vs_D' " \\";
  
  noisily display "\bottomrule \bottomrule\\[-.1in]";
  noisily display "\multicolumn{4}{p{.8\textwidth}}{The first column multiplies each hypothetical estimate for the vote-share return to experience by the 
  estimated difference in quality caused by incumbency in the relevant electoral context.";  
  noisily display "The second column divides the first column by the estimated incumbency advantage for the given electoral context.}\\";
  noisily display "\end{tabular}";
  noisily display "\end{table}";
  


  log close;

};

/* Produce robustness DTAs for R plots for Appendix */

local count = 1;

foreach data in tmp_rdd_us_statewide tmp_rdd_us_house_period_2 tmp_rdd_stleg {;


use `data', clear;

if "`data'" == "tmp_rdd_stleg" {;
	keep if office == "S" & year >= 1978;
};

drop if pct_I > pct_D | pct_I > pct_R;
replace pct_D = pct_D/(pct_D + pct_R);

gen next_diff = next_qual_D - next_qual_R;

gen rv2 = rv^2;
gen rv3 = rv^3;
gen rv4 = rv^4;

foreach d in next_diff {;



matrix B = J(50, 5, .);
quietly forvalues j=1/50 {;
	reg `d' treat rv rv_treat if margin < `j', r;
	matrix B[`j', 1] = _b[treat];
	reg `d' treat rv rv2 if margin < `j', r;
	matrix B[`j', 2] = _b[treat];
	reg `d' treat rv rv2 rv3 if margin < `j', r;
	matrix B[`j', 3] = _b[treat];
	reg `d' treat rv rv2 rv3 rv4 if margin < `j', r;
	matrix B[`j', 4] = _b[treat];
	matrix B[`j', 5] = `j';
};

preserve;

svmat B;
keep B1-B5;
keep if B1 != .;
saveold "for_robust_graph`count'", replace;

restore;

local count = `count' + 1;
};

};


/* Produce balance DTAs for balance plots in Appendix */ 

local count = 1;
foreach data in tmp_rdd_us_statewide tmp_rdd_us_house_period_2 tmp_rdd_stleg {;


use `data', clear;

if "`data'" == "tmp_rdd_stleg" {;
	keep if office == "S" & year >= 1978;
};

drop if pct_I > pct_D | pct_I > pct_R;
replace pct_D = pct_D/(pct_D + pct_R);

gen diff = qual_D - qual_R;

gen rv2 = rv^2;
gen rv3 = rv^3;
gen rv4 = rv^4;

foreach d in diff {;



matrix B = J(50, 4, .);
quietly forvalues j=1/50 {;
	reg `d' treat rv rv_treat if margin < `j', r;
	matrix B[`j', 1] = _b[treat];
	matrix B[`j', 2] = _b[treat] + 1.96*_se[treat];
	matrix B[`j', 3] = _b[treat] - 1.96*_se[treat];
	matrix B[`j', 4] = `j';
};

preserve;

svmat B;
keep B1-B4;
keep if B1 != .;
saveold "for_balance_graph`count'", replace;

restore;

local count = `count' + 1;
};

};


/* Produce files with fitted lines and bins for RD graphs made in R */

foreach files in tmp_rdd_us_statewide tmp_rdd_us_house_period_2 tmp_rdd_stleg {;

use `files', clear;

if "`files'" == "tmp_rdd_stleg" {;
	keep if office == "S" & year >= 1978;
};

gen bin=rv - mod(rv, .5);
egen mean_R=mean(next_qual_R) , by(bin);
egen mean_D=mean(next_qual_D) , by(bin);
egen mean_win=mean(next_win_D) , by(bin);


reg next_qual_R treat rv_treat rv if margin < 5, robust;
predict y, xb;

reg next_qual_D treat rv_treat rv if margin < 5, robust;
predict y_d, xb;

reg next_pct_D treat rv_treat rv if margin < 5, robust;
predict y_share, xb;

reg next_win_D treat rv_treat rv if margin < 5, robust;
predict y_win, xb;

keep if margin < 5;

saveold `files'_R, replace;

};


