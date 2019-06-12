*---------------------------------------------------------------------------------------------
// Stata do-file for
// Höhmann, D. & Tober, T.
// 'Electoral Rules and Partisan Control of Government: A Replication Study'
// The Journal of Politics
*---------------------------------------------------------------------------------------------


version 14
set more off


*---------------------------------------------------------------------------------------------
// Figure 1
*---------------------------------------------------------------------------------------------

* Data for left panel of Figure 1 (without additional observations for USA and Canada)

use "figure1_replication.dta", clear

gen LeftGovMedian = .
replace LeftGovMedian = 1 if CoGLowe < PosParlmedian
replace LeftGovMedian = 0 if CoGLowe > PosParlmedian
#delimit;
label define LeftGovMedian
0 "Right Gov"
1 "Left Gov";
#delimit cr
label value LeftGovMedian LeftGovMedian

tab partysys LeftGovMedian, row

ttest LeftGovMedian , by (partysys) 
ttest LeftGovMedian == 0.5 if partysys==0
ttest LeftGovMedian == 0.5 if partysys==1

* Data for right panel of Figure 1 (with additional observations for USA and Canada)

use "figure1_replication_add_USA_CAN.dta", clear

#delimit;
label define partysys
0 "Majoritarian"
1 "Proportional";
#delimit cr
label value partysys partysys

gen LeftGovMedian = .
replace LeftGovMedian = 1 if CoGLowe < PosParlmedian
replace LeftGovMedian = 0 if CoGLowe > PosParlmedian
#delimit;
label define LeftGovMedian
0 "Right Gov"
1 "Left Gov";
#delimit cr
label value LeftGovMedian LeftGovMedian

tab partysys LeftGovMedian, row 

ttest LeftGovMedian , by (partysys) 
ttest LeftGovMedian == 0.5 if partysys==0
ttest LeftGovMedian == 0.5 if partysys==1

*---------------------------------------------------------------------------------------------
// Regression Tables
*---------------------------------------------------------------------------------------------

use "tables_replication.dta", clear

* Median District Magnitude

gen CoGLowe_median = .
replace CoGLowe_median = CoGLowe-PosParlmedian
gen DistMag_cat_3 = .
replace DistMag_cat_3 = 0 if DistMag_Median == 1
replace DistMag_cat_3 = 1 if DistMag_Median > 1 & DistMag_Median <= 6
replace DistMag_cat_3 = 2 if DistMag_Median > 6

* Country 

gen country = .
replace country = 1 if xland == "united states"
replace country = 2 if xland == "canada"
replace country = 3 if xland == "united kingdom"
replace country = 4 if xland == "ireland"
replace country = 5 if xland == "netherlands"
replace country = 6 if xland == "belgium"
replace country = 7 if xland == "france"
replace country = 7 if xland == "switzerland"
replace country = 8 if xland == "germany"
replace country = 9 if xland == "austria"
replace country = 10 if xland == "italy"
replace country = 11 if xland == "finland"
replace country = 12 if xland == "sweden"
replace country = 13 if xland == "norway"
replace country = 14 if xland == "denmark"
replace country = 15 if xland == "japan"
replace country = 16 if xland == "australia"
replace country = 17 if xland == "new zealand"
replace country = 18 if xland == "switzerland"

* Lagged DVs
 
sort country contydo
by country: gen CoGLowemedian_lag = CoGLowe_median[_n-1] if contydo==contydo[_n-1]+1
by country: gen CoGLowe_lag = CoGLowe[_n-1] if contydo==contydo[_n-1]+1
by country: gen cogcab_lag = cogcab[_n-1] if contydo==contydo[_n-1]+1
by country: gen diffmeds_lag = diffmeds[_n-1] if contydo==contydo[_n-1]+1

* Country FEs

tab country, gen(cnt)

* Models of Table 1

xtset country contydo

xtpcse CoGLowe_median CoGLowemedian_lag DistMag_cat_3 cnt2-cnt17 
xtpcse CoGLowe_median CoGLowemedian_lag DistMag_cat_3 leftfrag cnt2-cnt17 
xtpcse CoGLowe_median CoGLowemedian_lag DistMag_cat_3 Right_Overrepresentation cnt2-cnt17 
xtpcse CoGLowe CoGLowe_lag DistMag_cat_3 leftfrag Right_Overrepresentation cnt2-cnt17 
xtpcse CoGLowe CoGLowe_lag DistMag_cat_3 turnout Union FEMPAR cnt2-cnt17 

* Models of Table A3 

// DV: Expert, MDM
xtpcse diffmeds diffmeds_lag DistMag_cat_3 
xtpcse diffmeds diffmeds_lag DistMag_cat_3 leftfrag 
xtpcse diffmeds diffmeds_lag DistMag_cat_3 Right_Overrepresentation 
xtpcse cogcab cogcab_lag DistMag_cat_3 leftfrag Right_Overrepresentation 
xtpcse cogcab cogcab_lag DistMag_cat_3 turnout Union FEMPAR 

// DV: Expert, PR Dummy
xtpcse diffmeds diffmeds_lag partysys 
xtpcse diffmeds diffmeds_lag partysys leftfrag 
xtpcse diffmeds diffmeds_lag partysys Right_Overrepresentation 
xtpcse cogcab cogcab_lag partysys leftfrag Right_Overrepresentation 
xtpcse cogcab cogcab_lag partysys turnout Union FEMPAR 

// DV: Manfisto, MDM
xtpcse CoGLowe_median CoGLowemedian_lag DistMag_cat_3 
xtpcse CoGLowe_median CoGLowemedian_lag DistMag_cat_3 leftfrag 
xtpcse CoGLowe_median CoGLowemedian_lag DistMag_cat_3 Right_Overrepresentation 
xtpcse CoGLowe CoGLowe_lag DistMag_cat_3 leftfrag Right_Overrepresentation 
xtpcse CoGLowe CoGLowe_lag DistMag_cat_3 turnout Union FEMPAR 

// DV: Manfisto, PR Dummy
xtpcse CoGLowe_median CoGLowemedian_lag partysys 
xtpcse CoGLowe_median CoGLowemedian_lag partysys leftfrag 
xtpcse CoGLowe_median CoGLowemedian_lag partysys Right_Overrepresentation 
xtpcse CoGLowe CoGLowe_lag partysys leftfrag Right_Overrepresentation 
xtpcse CoGLowe CoGLowe_lag partysys turnout Union FEMPAR 

* Models of Table A4 (DV: Expert, for DV: Manfisto see Table 1)

xtpcse diffmeds diffmeds_lag DistMag_cat_3 cnt2-cnt17 
xtpcse diffmeds diffmeds_lag DistMag_cat_3 leftfrag cnt2-cnt17 
xtpcse diffmeds diffmeds_lag DistMag_cat_3 Right_Overrepresentation cnt2-cnt17 
xtpcse cogcab cogcab_lag DistMag_cat_3 leftfrag Right_Overrepresentation cnt2-cnt17 
xtpcse cogcab cogcab_lag DistMag_cat_3 turnout Union FEMPAR cnt2-cnt17 

* Models of Table A2 

collapse diffmeds cogcab CoGLowe_median CoGLowe partysys DistMag_cat_3 leftfrag Right_Overrepresentation turnout Union FEMPAR, by(CCODE) 

// DV: Expert, MDM
reg diffmeds DistMag_cat_3 if CCODE~=225 
reg diffmeds DistMag_cat_3 leftfrag if CCODE~=225
reg diffmeds DistMag_cat_3 Right_Overrepresentation if CCODE~=225 
reg cogcab DistMag_cat_3 leftfrag Right_Overrepresentation if CCODE~=225 
reg cogcab DistMag_cat_3 turnout Union FEMPAR if CCODE~=225

// DV: Expert, PR Dummy (reproduces results of Table 7 in Iversen & Soskice 2006)
reg diffmeds partysys if CCODE~=225 
reg diffmeds partysys leftfrag if CCODE~=225
reg diffmeds partysys Right_Overrepresentation if CCODE~=225 
reg cogcab partysys leftfrag Right_Overrepresentation if CCODE~=225 
reg cogcab partysys turnout Union FEMPAR if CCODE~=225

// DV: Manifesto, MDM
reg CoGLowe_median DistMag_cat_3 if CCODE~=225 
reg CoGLowe_median DistMag_cat_3 leftfrag if CCODE~=225
reg CoGLowe_median DistMag_cat_3 Right_Overrepresentation if CCODE~=225 
reg CoGLowe DistMag_cat_3 leftfrag Right_Overrepresentation if CCODE~=225 
reg CoGLowe DistMag_cat_3 turnout Union FEMPAR if CCODE~=225

// DV: Manifesto, PR Dummy
reg CoGLowe_median partysys if CCODE~=225 
reg CoGLowe_median partysys leftfrag if CCODE~=225
reg CoGLowe_median partysys Right_Overrepresentation if CCODE~=225 
reg CoGLowe partysys leftfrag Right_Overrepresentation if CCODE~=225 
reg CoGLowe partysys turnout Union FEMPAR if CCODE~=225
