*Contractionary Devaluation Risk: Evidence from the Free Silver Movement, 1878-1900
*Colin Weiss (colin.r.weiss@frb.gov)
*This program runs the daily-level analysis, including bootstrapped percentiles, preliminary analysis (Table 2), diff-in-diff specifications (Tables 3 and 4) and default risk mechanisms
*See the read-me for further descriptions and the data read-me for information about the datasets
*Store/output regression results using whatever command/program you like*

clear

*Set your directory*
global root "C:\Users\m1crw01\Downloads"
*insert preferred directory above*
global temp "$root\temp"
*********Preliminary Analysis**********************************************

*Bootstrapped percentiles
use "$root\devaluationrisk_preliminary.dta"
*Bounds for pre-Panic of 1893 data (5th and 95th percentiles)*
bootstrap r(p5), reps(1000) seed(1234): summarize hpr if event==0 & post_panic==0, detail
matrix p_low=e(b)
list if  hpr<float(p_low[1,1]) & event!=0 & post_panic==0
bootstrap r(p95), reps(1000) seed(1234): summarize hpr if event==0 & post_panic==0, detail
matrix p_high=e(b)
list if hpr>float(p_high[1,1]) & event!=0 & post_panic==0
*Bounds for post-Panic of 1893 data (5th and 95th percentiles)*
bootstrap r(p5), reps(1000) seed(1234): summarize hpr if event==0 & post_panic==1, detail
matrix p_low2=e(b)
list if  hpr<float(p_low2[1,1]) & event!=0 & post_panic==1
bootstrap r(p95), reps(1000) seed(1234): summarize hpr if event==0 & post_panic==1, detail
matrix p_high2=e(b)
list if hpr>float(p_high2[1,1]) & event!=0 & post_panic==1

*Table 2
*Column 1 (all events)
xi: reg hpr event i.month, robust

*Column 2 (separating events before and after Panic of 1893)
xi: reg hpr c.event##post_panic i.month, robust

*Column 3 (Gold reserve/event interaction)
xi: reg hpr c.event##c.reserves i.month, robust

*Re-doing above analysis with absolute values
replace hpr=abs(hpr)
replace event=abs(event)
*Pre-Panic bound
bootstrap r(p90), reps(1000) seed(1234): summarize hpr if event==0 & post_panic==0, detail
matrix p_90=e(b)
list if hpr>float(p_90[1,1]) & event!=0 & post_panic==0
*Post-Panic bound
bootstrap r(p90), reps(1000) seed(1234): summarize hpr if event==0 & post_panic==1, detail
matrix p2_90=e(b)
list if hpr>float(p2_90[1,1]) & event!=0 & post_panic==1

*Table A2
*Column 1
xi: reg hpr event i.month, robust
*Column 2
xi: reg hpr event##post_panic i.month, robust
*Column 3
xi: reg hpr event##c.reserves i.month, robust
*********************************************************************************

******Diff-in-diff**************************************************************
use "$root\devaluationrisk_eventmain.dta", clear
*Table 3
*Column 1 (all events)
xi: reg hpr dep_bust##c.event dep_bust##i.month, robust
*Column 2 (pre-panic events)
xi: reg hpr c.event##dep_bust dep_bust##i.month if pre_panic==1 | event==0, robust
*Column 3 (post-panic events)
xi: reg hpr c.event##dep_bust dep_bust##i.month if pre_panic==0, robust

*Table A3 
replace hpr=abs(hpr)
replace event=abs(event)
*Column 1 (all events)
xi: reg hpr dep_bust##c.event dep_bust##i.month, robust
*Column 2 (pre-panic events)
xi: reg hpr c.event##dep_bust dep_bust##i.month if pre_panic==1 | event==0, robust
*Column 3 (post-panic events)
xi: reg hpr c.event##dep_bust dep_bust##i.month if pre_panic==0, robust

*Table 4*
use "$root\devaluationrisk_eventcapm.dta", clear
*Column 1 (all events)
xi: reg exposed_hpr event safe_hpr i.month, robust
*Column 2 (pre-panic events)
xi: reg exposed_hpr event safe_hpr i.month if pre_panic==1 | event==0, robust
*Column 3 (post-panic events)
xi: reg exposed_hpr event safe_hpr i.month if pre_panic==0, robust

*Table A4*
replace exposed_hpr=abs(exposed_hpr)
replace safe_hpr=abs(safe_hpr)
replace event=abs(event)
*Column 1 (all events)
xi: reg exposed_hpr event safe_hpr i.month, robust
*Column 2 (pre-panic events)
xi: reg exposed_hpr event safe_hpr i.month if pre_panic==1 | event==0, robust
*Column 3 (post-panic events)
xi: reg exposed_hpr event safe_hpr i.month if pre_panic==0, robust

************************************************************************************************

*******Default Risk Mechanism Evidence**********************************************************

*Table 5*

use "$root\devaluationrisk_mechanism.dta", clear
*Column 1 Zero-Return Days
xi: reg HPR zero_day1891 i.event, vce(cluster firm)
*Column 2 Earnings after Depreciation
xi: reg HPR earnigngschange_dep i.event, vce(cluster firm)
*Column 3 Actual Change in Earnings
xi: reg HPR earningschange_act i.event, vce(cluster firm)
*Column 4 All variables
xi: reg HPR zero_day1891 earningschange_dep earningschange_act i.event, vce(cluster firm)
