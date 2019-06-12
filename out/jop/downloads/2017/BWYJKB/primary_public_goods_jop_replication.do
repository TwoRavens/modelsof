#delimit;

/* 06304-0001-Data.txt and 06304-0002-Data.txt are from ICPSR study 6304 */
/* census_1900_1920.dta includes data from ICPSR study 3 */

/*
clear;
insheet using 06304-0001-Data.txt;  /* state and local finance data for 1902 */
rename v1 state;
rename v3 type;
rename v4 iso;
rename v5 value;
drop v2;
gen year = 1902;
sort state iso;
drop if type == "" & iso == . & value == .;
keep if type == "TGG";           /* keep only state and total government expenditures */
keep if iso == 4250 | iso == 3;  /* keep total expenditures (iso = 4250) and capital outlays (iso = 3) */
save c:\temp\csgov, replace;

clear;
insheet using 06304-0002-Data.txt;  /* state and local finance data for 1913 */
rename v1 state;
rename v3 type;
rename v4 iso;
rename v5 value;
drop v2;
gen year = 1913;
keep if type == "SSS" | type == "CCC" | type == "L11"; /* CCC is counties, L12 municipalities with populations btw 2,500 and 8,000, L11 is incorporated places over 2,500 */ 
sort state iso; 
replace type = "TGG" if type == "CCC";
by state iso: egen tgg = sum(value);
replace value = tgg if type == "TGG";
drop tgg;
drop if type == "" & iso == . & value == .;
keep if type == "TGG";
keep if iso == 4250 | iso == 3;
append using c:\temp\csgov;
save c:\temp\csgov, replace;

use c:\temp\csgov;
keep if iso == 4250 & type == "TGG";
rename value tot_cap_outlays_a;
sort state year;
save c:\temp\csgova, replace;

clear;
use c:\temp\csgov;
keep if iso == 3 & type == "TGG";
rename value tot_total_exp_a;
sort state year;
merge state year using c:\temp\csgova;
drop _merge;
sort state year;
save c:\temp\csgovb, replace;

/* this section is to make the contributions comparable 1902 to 1913 */
/* 1902 has data on total government expenditure and data on expenditures for minor civil divisions other than cities with populations above 8,000*/
/* 1913 has data on state government, county government, and incorporated places 2,500 to 8,000 */

clear;
insheet using 06304-0001-Data.txt;
rename v1 state;
rename v3 type;
rename v4 iso; /* iso 3 is expenditures iso 4250 is capital outlays */
rename v5 value;
drop v2;
gen year = 1902;
sort state iso;
drop if type == "" & iso == . & value == .;
keep if type == "TGG" | type == "L03"; /* Note that L03 is other minor civil divisions that seem to be those less than 8,000  -- checked with census numbers and this looks right */
sort state iso type;
gen value2 = value-value[_n-1] if type == "TGG" & type[_n-1] == "L03" & iso == iso[_n-1];  /* subtracting out mcd less than 8,000 */
keep if type == "TGG";
keep if iso == 4250 | iso == 3;
save c:\temp\csgov2, replace;

clear;
insheet using 06304-0002-Data.txt;
rename v1 state;
rename v3 type;
rename v4 iso;
rename v5 value;
drop v2;
gen year = 1913;
keep if type == "SSS" | type == "CCC" | type == "L11" | type == "L12"; /* L12 is incorporated places between 2,500 and 8,000 and L11 is incorporated places over 2,500 */ 
sort state iso type;
gen value2 = value - value[_n+1] if type == "L11" & type[_n+1] == "L12" & iso == iso[_n+1] & state == state[_n+1];
replace value2 = value if type == "SSS" | type == "CCC";
sort state iso; 
by state iso: egen tgg = sum(value2);
replace type = "TGG" if type == "L11";
replace value2 = tgg if type == "TGG";
drop if type == "" & iso == . & value == .;
keep if type == "TGG";
keep if iso == 4250 | iso == 3;
append using c:\temp\csgov2;
save c:\temp\csgov2, replace;

use c:\temp\csgov2;
keep if iso == 4250 & type == "TGG";
rename value2 tot_cap_outlays;
sort state year;
save c:\temp\csgova2, replace;

clear;
use c:\temp\cs_gov2;
keep if iso == 3 & type == "TGG";
rename value2 tot_total_exp;
sort state year;
merge state year using c:\temp\csgova2;
drop _merge;
sort state year;
save c:\temp\csgovb2, replace;

sort state year;
merge state year using c:\temp\csgovb;
drop tgg _merge;
save c:\temp\csgovb3, replace;

clear;
use c:\temp\csgovb3; 

gen tot_co_exp = tot_cap_outlays / tot_total_exp;   /* This is expenditures for municipalities above 8,000 */
gen tot_co_exp_a = tot_cap_outlays_a / tot_total_exp_a;  /* This is expenditures for municipalities above 2,500 in 1913 and all municipalites in 1902 */

gen p_date = 1958 if state == "AK";
replace p_date = 1896 if state == "SC";
replace p_date = 1898 if state == "GA";
replace p_date = 1900 if state == "AR";
replace p_date = 1902 if state == "AL" | state == "FL" | state == "MS";
replace p_date = 1903 if state == "WI";
replace p_date = 1904 if state == "LA" | state == "OR";
replace p_date = 1905 if state == "TX" | state == "VA";
replace p_date = 1907 if state == "IA" | state == "MO" | state == "NE" | state == "ND" | state == "WA";
replace p_date = 1908 if state == "IL" | state == "KS" | state == "OK";
replace p_date = 1909 if state == "AZ" | state == "CA" | state == "ID" | state == "MI" | state == "NV" | state == "NH";
replace p_date = 1910 if state == "CO" | state == "MD";
replace p_date = 1911 if state == "ME" | state == "MA" | state == "NJ" | state == "WY";
replace p_date = 1912 if state == "KY" | state == "MT";
replace p_date = 1915 if state == "NC" | state == "VT" | state == "WV";
replace p_date = 1917 if state == "TN";  /* passed law in 1909 but then struck down by supreme court.  Little evidence of use until after 1917 law*/
replace p_date = 1937 if state == "UT";
replace p_date = 1939 if state == "NM";
replace p_date = 1947 if state == "RI";
replace p_date = 1955 if state == "CT";
replace p_date = 1969 if state == "DE";
replace p_date = 1915 if state == "IN"; 
replace p_date = 1901 if state == "MN"; /* statewide office in 1912 */
replace p_date = 1913 if state == "NY";
replace p_date = 1908 if state == "OH"; /* MANDATORY PRIMARY LAW 1913 -- CITIES AND COUNTIES 1908 */
replace p_date = 1907 if state == "PA"; /* statewide offices later statewide in 1913 */
replace p_date = 1907 if state == "SD"; 

/* 1902, 1913, 1932 and 1942 */

local y = 1;
gen prim = (year > (p_date + `y') & year != .);
gen prim1 = prim;

sort state year;
save c:\temp\csgov, replace;

use census_1900_1920, clear;
keep if year == 1902 | year == 1913;
sort state year;
gen popden = ln(pop_total/area);
gen mfo_pw = ln(mfg_output/mfg_workers);
gen p_rural = rur_2500/pop_total;
gen pop2500 = pop_total - rur_2500;
sort state year;
merge state year using c:\temp\csgov;
drop _merge;

keep if year == 1902 | year == 1913;
sort state year;
gen ctot_co_exp = tot_co_exp - tot_co_exp[_n-1] if state == state[_n-1] & year == 1913 & year[_n-1] == 1902;
gen ctot_co_exp_a = tot_co_exp_a - tot_co_exp_a[_n-1] if state == state[_n-1] & year == 1913 & year[_n-1] == 1902;
gen cprim = prim - prim[_n-1] if state == state[_n-1] & year == 1913 & year[_n-1] == 1902;
gen cmfo_pw = mfo_pw - mfo_pw[_n-1] if state == state[_n-1] & year == 1913 & year[_n-1] == 1902;
gen cpopden = popden - popden[_n-1] if state == state[_n-1] & year == 1913 & year[_n-1] == 1902;
drop if year == 1902;

*/

clear;

use jop_replication;

/* main results */

reg ctot_co_exp_a cprim;
local t_b_oe_1_1_1 = _b[cprim];
local t_s_oe_1_1_1 = _se[cprim];
local t_n_oe_1_1_1 = _result(1);

reg ctot_co_exp cprim;
local t_b_oe_1_2_1 = _b[cprim];
local t_s_oe_1_2_1 = _se[cprim];
local t_n_oe_1_2_1 = _result(1);

reg ctot_co_exp_a cprim p_rural;
local t_b_oe_1_3_1 = _b[cprim];
local t_s_oe_1_3_1 = _se[cprim];
local t_b_oe_1_3_2 = _b[p_rural];
local t_s_oe_1_3_2 = _se[p_rural];
local t_n_oe_1_3_1 = _result(1);

reg ctot_co_exp_a cprim cpopden cmfo_pw;
local t_b_oe_1_4_1 = _b[cprim];
local t_s_oe_1_4_1 = _se[cprim];
local t_b_oe_1_4_3 = _b[cpopden];
local t_s_oe_1_4_3 = _se[cpopden];
local t_b_oe_1_4_4 = _b[cmfo_pw];
local t_s_oe_1_4_4 = _se[cmfo_pw];
local t_n_oe_1_4_1 = _result(1);

reg ctot_co_exp cprim cpopden cmfo_pw;
local t_b_oe_1_5_1 = _b[cprim];
local t_s_oe_1_5_1 = _se[cprim];
local t_b_oe_1_5_3= _b[cpopden];
local t_s_oe_1_5_3 = _se[cpopden];
local t_b_oe_1_5_4 = _b[cmfo_pw];
local t_s_oe_1_5_4 = _se[cmfo_pw];
local t_n_oe_1_5_1 = _result(1);

reg ctot_co_exp_a cprim p_rural cpopden cmfo_pw;
local t_b_oe_1_6_1 = _b[cprim];
local t_s_oe_1_6_1 = _se[cprim];
local t_b_oe_1_6_2 = _b[p_rural];
local t_s_oe_1_6_2 = _se[p_rural];
local t_b_oe_1_6_3 = _b[cpopden];
local t_s_oe_1_6_3 = _se[cpopden];
local t_b_oe_1_6_4 = _b[cmfo_pw];
local t_s_oe_1_6_4 = _se[cmfo_pw];
local t_n_oe_1_6_1 = _result(1);

quietly {;
capture log close;
log using table_1_main.tex, text replace;

noi disp "\begin{table}[htbp] ";
noi disp "\centering ";
noi display "\begin{threeparttable} ";
noi display "\caption{\bf Total Capital Outlays and Primary Introduction} ";
noi display "\label{table_1} ";
noi display "\begin{tabular}{lcccccc} ";
noi display "\toprule ";
noi display "  \multicolumn{7}{c}{$\Delta$  Capital Outlays / Total Expenditures}                 \\ ";
noi display "\midrule ";
noi display "$\Delta$ Primary Use  &" %5.3f `t_b_oe_1_1_1' " &  " %5.3f `t_b_oe_1_2_1' " &  " %5.3f `t_b_oe_1_3_1' "&  " %5.3f `t_b_oe_1_4_1' "&  " %5.3f `t_b_oe_1_5_1' "&  " %5.3f `t_b_oe_1_6_1' "\\ ";
noi display "  &(" %5.3f `t_s_oe_1_1_1' ") &  (" %5.3f `t_s_oe_1_2_1' ") &  (" %5.3f `t_s_oe_1_3_1' ") &  (" %5.3f `t_s_oe_1_4_1' ") &  (" %5.3f `t_s_oe_1_5_1' ") &  (" %5.3f `t_s_oe_1_6_1' ")  \\ [.05in]";
noi display "$\Delta$ Pop Density  & &   &  &  " %5.3f `t_b_oe_1_4_3' "&  " %5.3f `t_b_oe_1_5_3' "&  " %5.3f `t_b_oe_1_6_3' "\\ ";
noi display "  & & & &  (" %5.3f `t_s_oe_1_4_3' ") &  (" %5.3f `t_s_oe_1_5_3' ") &  (" %5.3f `t_s_oe_1_6_3' ") \\ [.05in]";
noi display "$\Delta$ Mfg Out/Work  & &   &  &  " %5.3f `t_b_oe_1_4_4' "&  " %5.3f `t_b_oe_1_5_4' "&  " %5.3f `t_b_oe_1_6_4' "\\ ";
noi display "  & & &  &  (" %5.3f `t_s_oe_1_4_4' ") &  (" %5.3f `t_s_oe_1_5_4' ") &  (" %5.3f `t_s_oe_1_6_4' ") \\ [.05in]";
noi display "$\%$ Pop $<$ 2,500  & & &    " %5.3f `t_b_oe_1_3_2' "&  & & " %5.3f `t_b_oe_1_6_2' "  \\ ";
noi display "  & & &  (" %5.3f `t_s_oe_1_3_2' ") &  & & (" %5.3f `t_s_oe_1_6_2' ")    \\ [.05in]";
noi display "\midrule ";
noi display "Number Obs &" %5.0f `t_n_oe_1_1_1' " &  " %5.0f `t_n_oe_1_2_1' "& " %5.0f `t_n_oe_1_3_1' " &  " %5.0f `t_n_oe_1_4_1' "&" %5.0f `t_n_oe_1_5_1' " &  " %5.0f `t_n_oe_1_6_1' "\\[.1in] ";
noi display "\midrule ";
noi display "\bottomrule ";
noi display "\end{tabular} ";
noi display "\begin{tablenotes} ";
noi display "{\footnotesize Columns 2 and 4 include expenditures by state, county and local governments with populations above 8,000. The other columns include all government expenditures in 1902 and all government expenditures minus expenditures by local governments with populations below 2,500 in 1913.}"; 
noi display "\end{tablenotes} ";
noi display "\end{threeparttable} ";
noi display "\end{table} ";

log close;

};


gen prim_g = "Primary Introduction" if cprim == 1;
replace prim_g = "No Change in Primary" if cprim == 0;

graph box ctot_co_exp_a, over(prim_g) ytitle("Change in Capital Outlays / Total Expenditures", size(small)) graphregion(color(white)) bgcolor(white);
graph export fig1.pdf, replace;

