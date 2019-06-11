cd "~/Dropbox/Shared Folder - J. Ladd & M (1). Meredith/Replication Files/"
cap log close
log using "LogFiles/Figure6.log", replace

clear all
set more off

mat Figure6 = J(25, 4, -9)

use "RawData/anes_timeseries_cdf.dta", clear
keep if VCF0004 >= 1960

//
// Issue Positions
//

// 2-Point Scale
foreach variable of varlist VCF0805 VCF0808 VCF0816 VCF0826 VCF0828 VCF0829 {
tab `variable'
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' = `variable' - 1
}

// 2-Point Scale (1 to 5)
foreach variable of varlist VCF0833 VCF0878 {
tab `variable' 
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' = (`variable' - 1) / 4
}

// 2-Point Scale (reversed)
foreach variable of varlist VCF0819 {
tab `variable' 
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' =  2 - `variable' 
}

// 3-Point Scale
foreach variable of varlist VCF0814 VCF0815 VCF0827 VCF0886 VCF0887 VCF0888 /*
*/ VCF0889 VCF0890 VCF0891 VCF0892 VCF0893 VCF0894 {
tab `variable' 
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' = (`variable' - 1) / 2
}

// 4-Point Scale
foreach variable of varlist VCF0837 VCF0838 {
tab `variable' 
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' = (`variable' - 1) / 3
}

// 4-Point Scale (1, 2, 4, 5)
foreach variable of varlist VCF0818 VCF0867a VCF0876a VCF0877a {
tab `variable' 
replace `variable' = . if `variable' == 0 | `variable' == 7 |  /*
*/ `variable' == 8 | `variable' == 9 
replace `variable' = 0 if `variable' == 1
replace `variable' = 1/3 if `variable' == 2
replace `variable' = 2/3 if `variable' == 4
replace `variable' = 1 if `variable' == 5
}

// 5-Point Scale
foreach variable of varlist VCF0879 {
tab `variable'
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' = (`variable' - 1) / 4
}

// 5-Point Scale (reversed)
foreach variable of varlist VCF0844 {
tab `variable'
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' = (5 - `variable') / 4
}


// 7-Point Scale
foreach variable of varlist VCF0806 VCF0809 VCF0811 VCF0817 /*
*/ VCF0827a VCF0830 VCF0832 VCF0834 VCF0839 VCF0841 VCF0842 VCF0843 {
tab `variable' 
replace `variable' = . if `variable' == 0 | `variable' == 8 | `variable' == 9 
replace `variable' = (`variable' - 1) / 6
}

// Social Welfare Spending:
// VCF0805: Government Assistance with Medical Care
// VCF0806: Government Health Insurance Scale
// VCF0808: Guaranteed Jobs and Income
// VCF0809: Guaranteed Jobs and Income Scale
// VCF0830: Aid to Blacks Scale 
// VCF0839: Government Services-Spending Scale
// VCF0886: Federal Spending- Poor/Poor People
// VCF0887: Federal Spending- Child Care
// VCF0889: Federal Spending- Research/Fight Aids
// VCF0890: Federal Spending- Public Schools
// VCF0893: Federal Spending- The Homeless
// VCF0894: Federal Spending- Welfare 

foreach var of varlist VCF0805 VCF0806 VCF0808 VCF0809 VCF0830 VCF0839 VCF0886 /*
*/ VCF0887 VCF0889 VCF0890 VCF0893 VCF0894 {
display "`var'"
tab VCF0004 if missing(`var') == 0
}

// Other Policies:
// VCF0811: Urban Unrest Scale 
// VCF0814: Civil Rights Pushes Too Fast or Not Fast Enough
// VCF0815: Segregation or Desegregation
// VCF0816: Should Government Ensure School Integration
// VCF0817: School Busing Scale
// VCF0818: Should Government Ensure Fair Jobs/Housing for Blacks
// VCF0819: Open Housing 
// VCF0826: Did U.S. Do  Right Thing Getting Involved in War
// VCF0827: How Should  U.S. Proceed in Current War
// VCF0827a: U.S. Stand in Vietnam Scale
// VCF0828: Should Government Cut Military Spending
// VCF0829: Is the Government in Washington Too Strong
// VCF0832: Rights of the Accused Scale
// VCF0833: Favor or Oppose Equal Rights Amendment
// VCF0834: Women Equal Role Scale
// VCF0837: When Should Abortion Be Allowed
// VCF0838: By Law, When Should Abortion Be Allowed
// VCF0841: Cooperation with U.S.S.R. Scale 
// VCF0842: Environmental Regulation Scale 
// VCF0843: Defense Spending Scale
// VCF0844: How Willing Should U.S. Be to Use Military Force
// VCF0867a: Affirmative Action in Hiring/Promotion
// VCF0876a: Position on Law to Protect Homosexuals Against Discrimination
// VCF0877a: Position on Gays in the Military
// VCF0878: Should Gays/Lesbians Be Able to Adopt Children
// VCF0879: Increase or Decrease Number of Immigrants to U.S. 
// VCF0888: Federal Spending- Dealing with Crime
// VCF0891: Federal Spending- Fin Aid for  College Students
// VCF0892: Federal Spending- Federal Spending- Foreign Aid

foreach var of varlist VCF0811 VCF0814 VCF0815 VCF0816 VCF0817 VCF0818 VCF0819 /*
*/ VCF0826 VCF0827 VCF0827a VCF0828 VCF0829 VCF0832 VCF0833 VCF0834 VCF0837 VCF0838 /*
*/ VCF0841 VCF0842 VCF0843 VCF0844 VCF0867a VCF0876a VCF0877a VCF0878 VCF0879 /*
*/ VCF0888 VCF0891 VCF0892 {
display "`var'"
tab VCF0004 if missing(`var') == 0
}

egen conservatism = rmean(VCF0805 VCF0806 VCF0808 VCF0809 VCF0830 VCF0839 VCF0886 /*
*/ VCF0887 VCF0889 VCF0890 VCF0893 VCF0894 VCF0811 VCF0814 VCF0815 VCF0816 VCF0817 /*
*/ VCF0818 VCF0819 VCF0826 VCF0827 VCF0827a VCF0828 VCF0829 VCF0832 VCF0833 VCF0834 /*
*/ VCF0837 VCF0838 VCF0841 VCF0842 VCF0843 VCF0844 VCF0867a VCF0876a VCF0877a /*
*/ VCF0878 VCF0879 VCF0888 VCF0891 VCF0892)
egen welfare = rmean(VCF0805 VCF0806 VCF0808 VCF0809 VCF0830 VCF0839 VCF0886 /*
*/ VCF0887 VCF0889 VCF0890 VCF0893 VCF0894)
gen gender = VCF0834
egen other = rmean(VCF0811 VCF0814 VCF0815 VCF0816 VCF0817 /*
*/ VCF0818 VCF0819 VCF0826 VCF0827 VCF0827a VCF0828 VCF0829 VCF0832 VCF0833 /*
*/ VCF0837 VCF0838 VCF0841 VCF0842 VCF0843 VCF0844 VCF0867a VCF0876a VCF0877a /*
*/ VCF0878 VCF0879 VCF0888 VCF0891 VCF0892)

foreach var of varlist conservatism welfare gender other {
egen mean_`var' = mean(`var'), by(VCF0004)
egen sd_`var' = sd(`var'), by(VCF0004)
gen std_`var' = (`var' - mean_`var') / sd_`var'
drop mean_`var' sd_`var'
}


// Party Identification

tab VCF0301
gen partyid = 0 if VCF0301 == 1 
replace partyid = 0 if VCF0301 == 2 
replace partyid = 1/2 if VCF0301 == 3
replace partyid = 1/2 if VCF0301 == 4 
replace partyid = 1/2 if VCF0301 == 5
replace partyid = 1 if VCF0301 == 6 
replace partyid = 1 if VCF0301 == 7 

// Gender 

tab VCF0104 
gen female = (VCF0104 == 2)

gen std_welfareXfemale = std_welfare * female
gen std_genderXfemale = std_gender * female
gen std_otherXfemale = std_other * female

// Education 

tab VCF0110 VCF0004
gen college = (VCF0110 == 4)
replace college = . if VCF0110 == 0

local j = 1 
forvalues i = 1960(2)2004 {
regress partyid std_conservatism [pweight = VCF0009z] if college == 1 & VCF0004 == `i', robust
mat Figure6[`j', 1] = _b[std_conservatism]
mat Figure6[`j', 2] = _se[std_conservatism]
regress partyid std_conservatism [pweight = VCF0009z] if college == 0 & VCF0004 == `i', robust
mat Figure6[`j', 3] = _b[std_conservatism]
mat Figure6[`j', 4] = _se[std_conservatism]
local j = `j' + 1
}
regress partyid std_conservatism [pweight = VCF0009z] if college == 1 & VCF0004 == 2008, robust
mat Figure6[`j', 1] = _b[std_conservatism]
mat Figure6[`j', 2] = _se[std_conservatism]
regress partyid std_conservatism [pweight = VCF0009z] if college == 0 & VCF0004 == 2008, robust
mat Figure6[`j', 3] = _b[std_conservatism]
mat Figure6[`j', 4] = _se[std_conservatism]
local j = `j' + 1
regress partyid std_conservatism [pweight = VCF0009z] if college == 1 & VCF0004 == 2012, robust
mat Figure6[`j', 1] = _b[std_conservatism]
mat Figure6[`j', 2] = _se[std_conservatism]
regress partyid std_conservatism [pweight = VCF0009z] if college == 0 & VCF0004 == 2012, robust
mat Figure6[`j', 3] = _b[std_conservatism]
mat Figure6[`j', 4] = _se[std_conservatism]

matlist Figure6

clear
svmat Figure6

gen year = 1960 + (_n - 1)*2
replace year = 2012 if year == 2008
replace year = 2008 if year == 2006

gen results1 = Figure61
gen results2 = Figure61 - 1.96*Figure62
gen results3 = Figure61 + 1.96*Figure62
gen results4 = Figure63
gen results5 = Figure63 - 1.96*Figure64
gen results6 = Figure63 + 1.96*Figure64

gen group = 1 if year >= 1960 & year <= 1968
replace group = 2 if year >= 1970 & year <= 1978
replace group = 3 if year >= 1980 & year <= 1988
replace group = 4 if year >= 1990 & year <= 1998
replace group = 5 if year >= 2000 & year <= 2012

egen avg_results1 = mean(results1), by(group)
egen avg_results4 = mean(results4), by(group)

twoway (scatter results1 year, mcolor(black) mfcolor(white) msymbol(circle) msize(large)) /*
*/ (rspike results2 results3 year, lcolor(black) lpattern(dash)) /*
*/ (scatter results4 year, mcolor(gray) mfcolor(gray) msymbol(circle) msize(large)) /*
*/ (rspike results5 results6 year, lcolor(gray) lpattern(dash)) /*
*/ (lfit avg_results1 year if year >= 1960 & year <= 1968, lcolor(black)) /*
*/ (lfit avg_results4 year if year >= 1960 & year <= 1968, lcolor(gray)) /*
*/ (lfit avg_results1 year if year >= 1970 & year <= 1978, lcolor(black)) /*
*/ (lfit avg_results4 year if year >= 1970 & year <= 1978, lcolor(gray)) /*
*/ (lfit avg_results1 year if year >= 1980 & year <= 1988, lcolor(black)) /*
*/ (lfit avg_results4 year if year >= 1980 & year <= 1988, lcolor(gray)) /*
*/ (lfit avg_results1 year if year >= 1990 & year <= 1998, lcolor(black)) /*
*/ (lfit avg_results4 year if year >= 1990 & year <= 1998, lcolor(gray)) /*
*/ (lfit avg_results1 year if year >= 2000 & year <= 2012, lcolor(black)) /*
*/ (lfit avg_results4 year if year >= 2000 & year <= 2012, lcolor(gray)), /*
*/ legend(cols(2) label(1 "Point Estimate") label(3 "Point Estimate") /*
*/ label(5 "Average in Decade") label(6 "Average in Decade") /*
*/ order(- "College Graduates:" - "Non-College Graduates:" 1 3 5 6)) /*
*/ xtitle("Survey Year") ytitle("Association Between Standardized" "Issue Preferences And Party ID") /*
*/ xlabel(1960(10)2010) ylabel(0(.05).3) plotregion(color(white)) graphregion(color(white)) ylabel(,grid) 

graph export "TablesFigures/Figure6.eps", replace

log close
