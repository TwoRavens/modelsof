set mem 400m
log using "G:\whalley\projects\college_spending\programs\analysis\RESTAT_final\table2.log", replace
#delimit ;
set more 1;
*
* TABLE2.DO
* BY Alex Whalley
* VERSION OF 03/10/09
*
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
keep if ECFET_bp == 1 & income_bp == 1;
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
* PUT 1900 MANUFACTURING NUMBERS IN PER CAPITA TERMS
*;
gen mfgout1900_pc =  mfgout1900/totpop1900;
*
* PART (A): MEDIAN COLLEGE SPENDING DIFFS
*
* LOOK AT COLLEGE OUTCOMES AND EXPENDITURE BY COLLEGE SPENDING
*;
sum ECFET if year == 81 & col_county == 1 , d;
gen above_m_ECFET81 = 0 if col_county == 1;
replace above_m_ECFET81 = 1 if ECFET >= r(p50) & col_county == 1;
egen m_ECFET = sum(above_m_ECFET), by(FIPSCOUNTY);
sum endow if year == 81 & col_county == 1, d;
gen above_m_endow = 0 if col_county == 1;
replace above_m_endow = 1 if endow >= r(p50) & col_county == 1;
egen m_endow = sum(above_m_endow), by(FIPSCOUNTY);
*
* SUM ALL
*;
sum income ECFET init_endow_spindex public schoolrank totpop percap_y hrent per_colgrad per_black 
crime_rt  amuse_recpt   RDON PBUILDADD tot_ft_ug tot_ft_gr domestic_equity_avg year_open totpop1900 mfgout_pc1900  if col_county == 1;
*
* PART (A1) MEDIAN SPENDING
*;
sum above_m_ECFET81 m_ECFET;
sum income ECFET endow public schoolrank totpop percap_y hrent per_colgrad per_black 
crime_rt  amuse_recpt   RDON PBUILDADD tot_ft_ug tot_ft_gr domestic_equity_avg year_open totpop1900 mfgout_pc1900  if m_ECFET == 1 & col_county == 1;
sum income ECFET endow public schoolrank totpop percap_y hrent per_colgrad per_black
crime_rt  amuse_recpt  RDON PBUILDADD tot_ft_ug tot_ft_gr domestic_equity_avg year_open totpop1900 mfgout_pc1900  if m_ECFET == 0 & col_county == 1;
*
* GET T-TESTS
*;
reg income m_ECFET if col_county == 1;
reg ECFET m_ECFET if col_county == 1;
reg endow m_ECFET if col_county == 1;
reg public m_ECFET if col_county == 1;
reg schoolrank m_ECFET if col_county == 1;
reg totpop m_ECFET if col_county == 1;
reg percap_y m_ECFET if col_county == 1;
reg hrent m_ECFET if col_county == 1;
reg per_colgrad	m_ECFET if col_county == 1;
reg per_black m_ECFET if col_county == 1;
reg crime_rt m_ECFET if col_county == 1;
reg amuse_recpt m_ECFET if col_county == 1;
reg RDON m_ECFET if col_county == 1;
reg PBUILDADD m_ECFET if col_county == 1;
reg tot_ft_ug m_ECFET if col_county == 1;
reg tot_ft_gr m_ECFET if col_county == 1;
reg domestic_equity_avg m_ECFET if col_county == 1;
reg year_open m_ECFET if col_county == 1;
reg mfgout_pc1900 m_ECFET if col_county == 1;
reg totpop1900 m_ECFET if col_county == 1;
*
* PART (A2) MEDIAN INITIAL ENDOWMENT
*;
sum income ECFET endow public schoolrank totpop percap_y hrent per_colgrad per_black 
crime_rt  amuse_recpt   RDON PBUILDADD tot_ft_ug tot_ft_gr domestic_equity_avg year_open totpop1900 mfgout_pc1900 if m_endow == 1 & col_county == 1;
sum income ECFET endow public schoolrank totpop percap_y hrent per_colgrad per_black
crime_rt  amuse_recpt  RDON PBUILDADD tot_ft_ug tot_ft_gr domestic_equity_avg year_open totpop1900 mfgout_pc1900 if m_endow == 0 & col_county == 1;
*
* GET T-TESTS
*;
reg income m_endow if col_county == 1;
reg ECFET m_endow if col_county == 1;
reg endow m_endow if col_county == 1;
reg public m_endow if col_county == 1;
reg schoolrank m_endow if col_county == 1;
reg totpop m_endow if col_county == 1;
reg percap_y m_endow if col_county == 1;
reg hrent m_endow if col_county == 1;
reg per_colgrad	m_endow if col_county == 1;
reg per_black m_endow if col_county == 1;
reg crime_rt m_endow if col_county == 1;
reg amuse_recpt m_endow if col_county == 1;
reg RDON m_endow if col_county == 1;
reg PBUILDADD m_endow if col_county == 1;
reg tot_ft_ug m_endow if col_county == 1;
reg tot_ft_gr m_endow if col_county == 1;
reg domestic_equity_avg m_endow if col_county == 1;
reg year_open m_endow if col_county == 1;
reg mfgout_pc1900 m_endow if col_county == 1;
reg totpop1900 m_endow if col_county == 1;
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
gen lemp = log(emp);
gen lest = log(est);
*
* KEEP NEEDED VARIABLES AND RESHAPE
*;
keep ind fipstate fipscty frac_emp col_county m_ECFET m_endow;
reshape wide frac_emp, i(fipstate fipscty) j(ind);
*
* PART (C1): COLLGE COUNTY DIFFS: SPENDING
*;
sum frac_emp1-frac_emp9 if m_ECFET == 1;
sum frac_emp1-frac_emp9 if m_ECFET == 0;
*
* GET T-TESTS
*;
reg frac_emp1 m_ECFET;
reg frac_emp2 m_ECFET;
reg frac_emp3 m_ECFET;
reg frac_emp4 m_ECFET;
reg frac_emp5 m_ECFET;
reg frac_emp6 m_ECFET;
reg frac_emp7 m_ECFET;
reg frac_emp8 m_ECFET;
reg frac_emp9 m_ECFET;
*
* PART (C2): COLLGE COUNTY DIFFS: INITAL ENDOWMENT
*;
sum frac_emp1-frac_emp9 if m_endow == 1;
sum frac_emp1-frac_emp9 if m_endow == 0;
*
* GET T-TESTS
*;
reg frac_emp1 m_endow;
reg frac_emp2 m_endow;
reg frac_emp3 m_endow;
reg frac_emp4 m_endow;
reg frac_emp5 m_endow;
reg frac_emp6 m_endow;
reg frac_emp7 m_endow;
reg frac_emp8 m_endow;
reg frac_emp9 m_endow;
*
* CLOSE LOG, CLEAR AND END
*;
log close;
*clear;
