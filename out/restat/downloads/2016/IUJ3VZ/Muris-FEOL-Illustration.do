/*
 Vancouver, November 2015
 
 This code accompanies the paper
   "Estimation in the fixed effects ordered logit model"
 by Chris Muris. 
 
 For any questions about this code, please email me
 at cmuris@sfu.ca. 
 
 If you use this code, please cite the latest version of the paper 
 (title above). See my website for more information (www.sfu.ca/~cmuris).
 
*/

log using "Muris-FEOL-Illustration", text

//////////////////////////////////////////
// 1. Load the data ///////////////////////
///////////////////////////////////////////

// Preliminaries
clear all

// The data used in this paper is MEPS panel 16.
// You can get the data from: 
//    http://meps.ahrq.gov/data_stats/download_data_files_detail.jsp?cboPufNumber=HC-156
//  The .dta file is created by running the do-file "h156stu.txt", also
//    available on the website. Make sure the resulting H156.dta file is 
//    in the working directory.
use "H156.dta"

///////////////////////////////////////////
// 2. Select data+sample in paper /////////
///////////////////////////////////////////

// First, select children whose age who had not reached age 18 by the end of 
//   the survey, to be consistent with the analysis in Murasko (2008).
keep if AGEY2X<18
keep if AGEY2X>1
// Throw out anomalous data based on family income and family size.
keep if FAMINCY1>0
keep if FAMINCY2>0
keep if FAMSY1>1
keep if FAMSY2>1

// Age is measured at beginning of sample
gen AGE = AGEY1X - 1

// There are five rounds of interviews, but only two observations for income.
// Based on the timing of the interviews, it makes sense
//   to assign the second and fourth round as year one and two.
//   See paper.
replace RTHLTH1 = RTHLTH2
replace RTHLTH2 = RTHLTH4

// Throw away the rounds we do not need.
drop RTHLTH3 RTHLTH4 RTHLTH5

// Keep only the variables that we will use in the following analysis
keep DUID PID AGE RTHLTH* FAMINCY* FAMSY* WAGEPY* WAGIMPY* UNINSY* ENDRFYY* SEX ///
     REGIONY1 MSAY1 RACEV1X

//////////////////////////////////////////////////////
// 3. Prepare the data for the OL estimators /////////
//////////////////////////////////////////////////////

// Change some variable names for the reshape command that follows.
ren WAGEPY1X WAGEPY1
ren WAGEPY2X WAGEPY2
ren MSAY1 MSA
ren REGIONY1 REGION

// Setting up the cross-section identifier.
gen CASEID = _n

// Force into panel data using the "reshape" command
reshape long RTHLTH FAMINCY WAGEPY FAMSY UNINSY ENDRFYY, i(CASEID) j(YEAR)

// Set the panel dimensions
xtset CASEID YEAR

// Balance the panel
bys CASEID: gen nyear=[_N]
keep if nyear==2
replace CASEID = int((_n-1)/2) +1

// Deal with the missing data on the health outcomes.
replace RTHLTH = . if RTHLTH<1 
drop if RTHLTH == .

// Truncate family size at 5.
replace FAMSY = 5 if FAMSY>5

// Set up age categories, as in Murasko (2008) and in earlier work.
gen AGE1 = AGE<=3
gen AGE2 = AGE>3 & AGE<=8
gen AGE3 = AGE>8 & AGE<=12
gen AGE4 = AGE>12

// For the main explanatory variable, use logs and drop the highest-income fams.
// Age-income gradient
qui replace FAMINCY = log(FAMINCY)
local trimmer = r(p95)
keep if FAMINCY <= `trimmer'


// Normalize
qui replace FAMSY = (FAMSY - 4.18778)
gen AGEOLD = AGE
qui replace AGE = (AGE - 7.402057)
qui replace FAMINCY = (FAMINCY - 10.52615)


// Generate the interactions
gen AGEINC = FAMINCY*AGE
gen AGE1INC = AGE1*FAMINCY
gen AGE2INC = AGE2*FAMINCY
gen AGE3INC = AGE3*FAMINCY
gen AGE4INC = AGE4*FAMINCY

gen cut = 0

//////////
// CMLE //
//////////

// Compute the number of transformations / CMLEs
local J = 5
local Jminone = `J'-1
local jminonet = (`Jminone')^(2)


// The following double for loop computes each of the CMLEs
//   and saves the results in est`j1'`j2' for each pair of cut points.
forval j1 = 1/`Jminone' {
	forval j2 = 1/`Jminone' {
		gen d`j1'`j2' = 0
		gen cut`j1'`j2' = 0
		qui replace d`j1'`j2' = 1 if RTHLTH<=`j1' & YEAR==1
		qui replace d`j1'`j2' = 1 if RTHLTH<=`j2' & YEAR==2
		qui replace cut`j1'`j2' = 1 if YEAR==2

		if (`j1'==`j2') {
			qui clogit d`j1'`j2' FAMINCY AGEINC FAMSY, group(CASEID)
			
			if(`j1'==3) {
				qui eststo: clogit d`j1'`j2' FAMINCY AGEINC FAMSY, group(CASEID)
			}
		}		
		else {
			qui clogit d`j1'`j2' FAMINCY AGEINC FAMSY i.cut`j1'`j2', group(CASEID)
		} 			
		est sto est`j1'`j2'
	}
}

/////////////////////////////////
// CORRELATED RANDOM EFFECTS  ///
/////////////////////////////////

// Obtain the variables to include for the approximation of alpha_i.

// AGE, SEX, MSA, i.REGION
bys CASEID: egen FAMINCY_AV = mean(FAMINCY)
bys CASEID: egen AGEINC_AV = mean(AGEINC)
bys CASEID: egen FAMSY_AV = mean(FAMSY)

qui eststo: xtologit RTHLTH FAMINCY AGEINC FAMSY
lincom [cut2]_cons-[cut1]_cons
lincom [cut3]_cons-[cut2]_cons
lincom [cut4]_cons-[cut3]_cons

qui eststo: xtologit RTHLTH FAMINCY AGEINC FAMSY AGE SEX MSA i.REGION RACEV1X FAMINCY_AV AGEINC_AV FAMSY_AV
lincom [cut2]_cons-[cut1]_cons
lincom [cut3]_cons-[cut2]_cons
lincom [cut4]_cons-[cut3]_cons

// Obtain APE
predict prob*, pu0
replace FAMINCY = FAMINCY+1
replace AGEINC = AGEINC + AGE
predict probnew*, pu0

// Present
sum prob* if RTHLTH==2 & AGEOLD==15

// Reset the covariate values
replace FAMINCY = FAMINCY-1
replace AGEINC = AGEINC - AGE

//xtreg RTHLTH FAMINCY AGEINC FAMSY AGE SEX MSA i.REGION RACEV1X FAMINCY_AV AGEINC_AV FAMSY_AV, fe


///////////////////////////
// COMPOSITE LIKELIHOOD ///
///////////////////////////

// Set the number of transformations
local jminonet = (`J'-1)^(2)
// Make 16 copies of the data.
qui expand `jminonet'
// Sort and generate a "tid" identifier, "tid" for "transformation ID"
qui sort CASEID YEAR
gen tid = mod(_n-1,`jminonet') + 1

// Set the cutpoints.
// 16 transformations, for cuts in total
//  4 are j,j
//  6 are j,k, j<k
//  last 6 are transpose of the second group, i.e. k,j
replace cut = 0

// First four: j,j
//
// 1. pi = (1,1)
qui replace cut = 1 if tid == 1
// 2. pi = (2,2)
qui replace cut = 2 if tid == 2
// 3. pi = (3,3)
qui replace cut = 3 if tid == 3
// 4. pi = (4,4)
qui replace cut = 4 if tid == 4
//
// Second six, j<k
// 
// 5. pi = (1,2)
qui replace cut = 1 if tid == 5 & YEAR == 1
qui replace cut = 2 if tid == 5 & YEAR == 2
// 6. pi = (1,3)
qui replace cut = 1 if tid == 6 & YEAR == 1
qui replace cut = 3 if tid == 6 & YEAR == 2
// 7. pi = (1,4)
qui replace cut = 1 if tid == 7 & YEAR == 1
qui replace cut = 4 if tid == 7 & YEAR == 2
// 8. pi = (2,3)
qui replace cut = 2 if tid == 8 & YEAR == 1
qui replace cut = 3 if tid == 8 & YEAR == 2
// 9. pi = (2,4)
qui replace cut = 2 if tid == 9 & YEAR == 1
qui replace cut = 4 if tid == 9 & YEAR == 2
// 10. pi = (3,4)
qui replace cut = 3 if tid == 10 & YEAR == 1
qui replace cut = 4 if tid == 10 & YEAR == 2
//
// Third six, j>k. Mirrors second group
// 
// 11. pi = (2,1)
qui replace cut = 2 if tid == 11 & YEAR == 1
qui replace cut = 1 if tid == 11 & YEAR == 2
// 12. pi = (3,1)
qui replace cut = 3 if tid == 12 & YEAR == 1
qui replace cut = 1 if tid == 12 & YEAR == 2
// 13. pi = (4,1)
qui replace cut = 4 if tid == 13 & YEAR == 1
qui replace cut = 1 if tid == 13 & YEAR == 2
// 14. pi = (3,2)
qui replace cut = 3 if tid == 14 & YEAR == 1
qui replace cut = 2 if tid == 14 & YEAR == 2
// 15. pi = (4,2)
qui replace cut = 4 if tid == 15 & YEAR == 1
qui replace cut = 2 if tid == 15 & YEAR == 2
// 16. pi = (4,3)
qui replace cut = 4 if tid == 16 & YEAR == 1
qui replace cut = 3 if tid == 16 & YEAR == 2

   
// The dependent variable is RTHLTH
local LHS RTHLTH
// The explanatory variables (see paper)
//local RHS FAMINCY AGEINC FAMSY i.ENDRFYY i.cut
local RHS FAMINCY AGEINC FAMSY i.cut

// The dependent variable in the implementation is a transformation
//   of RTHLTH.
gen ybin = `LHS'<=cut

// And adjust the group identifier, so that different transformations
//   of the same cross-section unit are viewed as different cross-section units.
gen newid = CASEID*100 + tid

//
// Column 2
// BUC estimator (Baetschmann et al. (2015) uses only the ones with constant cutoffs, i.e. tid <= 4
//
qui eststo: clogit ybin `RHS' if tid<=4, group(newid) cluster(CASEID)

//
// Column 3
// Estimator in the paper uses all transformations
//
eststo: clogit ybin `RHS', group(newid) cluster(CASEID)
lincom 3.cut-2.cut
lincom 4.cut-3.cut


///////////////////////////////////
// 5. Present the results  ////////
///////////////////////////////////

di "Remember: reported results for transformed estimators should be multiplied by (-1)."

esttab, se b(a2) mtitle("pi=(3,3)" "RE" "CRE" "BUC" "CLE")
eststo clear

log close
