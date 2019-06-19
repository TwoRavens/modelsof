set mem 400m
log using "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\table1.log", replace
#delimit ;
set more 1;
*
* TABLE1.DO
* BY Alex Whalley
* VERSION OF 03/10/09
*;
use "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\descriptives_data.dta", replace;
sum;
*
* MERGE IN THE 1900 CENSUS COUNTY DATA
*;
rename  state ICPRSTATECODE; 
sort ICPRSTATECODE county;
merge  ICPRSTATECODE county using G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\county_1900.dta;
tab _merge;
drop if _merge ==2;
gen no_merge_1900 = 0;
replace no_merge_1900 = 1 if _merge != 3;
rename  ICPRSTATECODE state;
gen mfgout_pc1900 = mfgout1900 / totpop1900 ;
*
* KEEP ONLY THE FIRST YEAR OF DATA AND THOSE IN CBP
*; 
tab year;
tab yr;
*
* DROP SMALL COUNTIES 
*;
drop if totpop < 250000;
*
* GENERATE A BALANCED PANEL INDICATOR AND KEEP ONLY BALANCED PANEL
*;
sum emp, d;
sum ECFET, d;
sort  FIPSCOUNTY yr;
gen count = 0;
replace count = 1 if ECFET != 0 & ECFET != .;
tab count;
egen scount = sum(count), by(FIPSCOUNTY);
tab scount;
gen ECFET_bp = 0;
replace ECFET_bp = 1 if scount == 16;
gen icount = 0;
replace icount = 1 if income != 0 & income != .;
tab icount;
egen sicount = sum(icount), by(FIPSCOUNTY);
tab sicount;
gen income_bp = 0;
replace income_bp = 1 if sicount == 16;
tab income_bp ECFET_bp;
*keep if ECFET_bp == 1 & income_bp == 1;
sum emp, d;
*
* MAKE A COLLEGE COUNTY INDICATOR
*;
gen col_county = 0;
replace col_county = 1 if ECFET != 0 & ECFET != . & ECFET_bp == 1;
replace col_county = 0 if ECFET == 0 | ECFET == .;
tab col_county;
*
* REPLACE ZERO/NEGATIVE OUTCOMES WITH MISSING
*;
replace emp = . if emp <= 0; 
*
* REORMALIZE TOTAL EXPENDITURE TO BE PER CAPITA
*;
gen endow = NEBEGMKT / (totpop * 1000);
gen ECFETp = ECFET / (totpop * 1000);
gen EPPMOTp = EPPMOT / (totpop * 1000); 
gen EEGETp = EEGET / (totpop * 1000); 
gen ESAGTp = ESAGT / (totpop * 1000); 
gen PBUILDADDp = PBUILDADD / (totpop * 1000); 
gen PEQUIPADDp = PEQUIPADD / (totpop * 1000); 
gen tot_ft_ugp = tot_ft_ug/ (totpop * 1000); 
gen tot_ft_grp = tot_ft_gr / (totpop * 1000);
gen RDONp = RDON / (totpop * 1000);
drop ECFET EPPMOT EEGET ESAGT PBUILDADD PEQUIPADD tot_ft_ug tot_ft_gr RDON;
rename ECFETp ECFET;
rename EPPMOTp EPPMOT; 
rename EEGETp EEGET;
rename ESAGTp ESAGT;
rename PBUILDADDp PBUILDADD;
rename PEQUIPADDp PEQUIPADD;
rename tot_ft_ugp tot_ft_ug;
rename tot_ft_grp tot_ft_gr;
rename RDONp RDON;
sum ECFET PBUILDADD if col_county == 1, d;
*
* RENORMALIZE INCOME TO BE DOLLARS
*;
gen pincome = (income) * 1000;
drop income;
rename pincome income;
drop if year != 81;
*
* PART (A): COLLEGE COUNTY DIFFS
*;
sum income ECFET endow public schoolrank totpop percap_y hrent per_colgrad per_black 
crime_rt amuse_recpt RDON PBUILDADD tot_ft_ug tot_ft_gr domestic_equity_avg year_open totpop1900 mfgout_pc1900  if col_county == 1;
sum income ECFET endow public schoolrank totpop percap_y hrent per_colgrad per_black 
crime_rt amuse_recpt RDON PBUILDADD tot_ft_ug tot_ft_gr domestic_equity_avg year_open  totpop1900 mfgout_pc1900 if col_county == 0;
*
* GET T-TESTS
*;
reg income col_county;
reg totpop col_county;
reg percap_y col_county;
reg hrent col_county;
reg per_colgrad	col_county;
reg per_black col_county;
reg crime_rt col_county;
reg amuse_recpt col_county;
reg totpop1900 col_county;
reg mfgout_pc1900 col_county;
*
* MAKE MISSING INDICATORS
*;
gen crime_rt_m = 0;
gen amuse_recpt_m = 0;
replace amuse_recpt_m = 1 if amuse_recpt ==.;
replace crime_rt_m = 1 if crime_rt ==.;
replace crime_rt = 0 if crime_rt == .;
replace amuse_recpt = 0 if amuse_recpt ==.;
*
* PART (B): RUN OLS REGRESSIONS: COLLEGE SPENDING
*;
gen ECFETp = ECFET / totpop;
replace ECFETp = 0 if ECFETp == .;
*
* MERGE IN 1982 CBP DATA FOR INDUSTRY DISTRIBUTION
*;
drop _merge;
rename emp totemp;
rename statefip fipstate;
rename counfip fipscty;
sort fipstate fipscty;
merge fipstate fipscty using "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\cbp82.dta";
tab _merge;
*drop if _merge != 3;
tab sic;
gen sic3 = substr(sic,3,1);
tab sic3;
keep if sic3 == "-";
drop if sic == "----" | sic =="99--";
tab sic;
egen totemp1 = sum(emp), by(fipstate fipscty);
gen frac_emp = emp / totemp1;
gen ind = .;
replace ind = 1 if sic == "07--";
replace ind = 2 if sic == "10--";
replace ind = 3 if sic == "15--";
replace ind = 4 if sic == "19--";
replace ind = 5 if sic == "40--";
replace ind = 6 if sic == "50--";
replace ind = 7 if sic == "52--";
replace ind = 8 if sic == "60--";
replace ind = 9 if sic == "70--";
*
* RENORMALIZE INCOME TO BE DOLLARS
*;
*gen pincome = (income / emp) * 1000;
*gen lincome = log(pincome);
gen lemp = log(emp);
gen lest = log(est);
*
* KEEP NEEDED VARIABLES AND RESHAPE
*;
keep ind fipstate fipscty frac_emp col_county ECFET;
reshape wide frac_emp, i(fipstate fipscty) j(ind);
*
* PART (A): COLLGE COUNTY DIFFS
*;
sum frac_emp1-frac_emp9 if col_county == 1;
sum frac_emp1-frac_emp9 if col_county == 0 & (ECFET == 0 | ECFET == .);
*
* GET T-TESTS
*;
reg frac_emp1 col_county;
reg frac_emp2 col_county;
reg frac_emp3 col_county;
reg frac_emp4 col_county;
reg frac_emp5 col_county;
reg frac_emp6 col_county;
reg frac_emp7 col_county;
reg frac_emp8 col_county;
reg frac_emp9 col_county;
*
* CLOSE LOG, CLEAR AND END
*;
log close;
*clear;
