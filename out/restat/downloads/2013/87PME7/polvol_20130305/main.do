#delimit;
clear;
*clear matrix;
set mem 600m;
set more off;

global date "20130305";
global direct "polvol";


set more off;

*global startdir "C:/My Research";
*global startdir "S:/RA-TA/shore-ra";
global startdir "C:";
*global startdir "K:/shore-ra";
global inputdata "$direct/inputdata";
global outputdata "$direct/outputdata";
global outputtables "$direct/outputtables/outputtables_$date";
global graphs "$direct/graphs";
global dofiles "$direct/dofiles/polvol_$date";
global logfiles "$direct/logsselect";
capture log close;
!mkdir "$startdir/$outputtables";
log using "$startdir/$outputtables/gesamtkunstwerk.txt", append text;

global control "yes";  *this means that we use the residual of log income after correcting for education, age, etc.;
global bootstrap "noBS";
global rho=1; 
global bigrho=100*$rho;
global rhotrans=1;

**commenting them out once they have run fully;
**do "$startdir/$dofiles/load_fipscodes.do";
        *sets up (PSID birth cohort) to fips or state name to fips merge;

**do "$startdir/$dofiles/load_ipums.do";
        *loads general ipums data by calling ipums_maker_YEAR for 9 years; 

**do "$startdir/$dofiles/make_ind_indexreturns.do";
        *creates (industry) x (year)-specific stock returns;

**do "$startdir/$dofiles/make_statenat_indexreturns.do";
**do "$startdir/$dofiles/load_state_polconditions.do";
        *creates (industry-based state)            x (year)-specific stock returns;
        *creates  industry-based and market-cap-based year -specific stock returns;
        *loads (state) x (year)-specific "policy" (political party) variable;

**do "$startdir/$dofiles/create_state_econconditions.do";
        *creates (state) x (year)-specific measures of GDP growth per capita;
**do "$startdir/$dofiles/create_nat_macroconditions.do";
       *creates (year)-specific measures of GDP growth per capita and recessions;		
**do "$startdir/$dofiles/create_state_industrialbase.do";
        *creates (state) x (year)-specific measures based on industrial base x industrial employment change;
		
		
**do "$startdir/$dofiles/create_alleconconds.do";
        *brings together all the econ conditions




global control "yes";
**do "$startdir/$dofiles/make_cohorts.do";
        *creates (state) x (age) x (year) cohorts with c.s. income moments;
        *creates national  (age) x (year) cohorts with c.s. income moments;
**do "$startdir/$dofiles/load_incomeeducation.do";	
        *makes state and national obs-level education, % black, and income;	
**do "$startdir/$dofiles/merge_nat_conditions_rho.do";

**do "$startdir/$dofiles/merge_state_conditionsOLD.do";
	*this file was from a previous iteration that does not accommodate the rho;
	*we still run it because it makes some useful files (fipstemps and samestateeconconds);
**do "$startdir/$dofiles/merge_state_conditions_rho.do";
        *merge current, initial, and cumulative economic conditions with cohort data on c.s. income moments;
*/;
/*
        *now make all these files using raw log income rather than residual log income;
global control "no"; 
do "$startdir/$dofiles/make_cohorts.do";
        *creates (state) x (age) x (year) cohorts with c.s. income moments;
        *creates national  (age) x (year) cohorts with c.s. income moments;
do "$startdir/$dofiles/load_incomeeducation.do";	
        *makes state and national obs-level education, % black, and income;	
do "$startdir/$dofiles/merge_nat_conditions_rho.do";

do "$startdir/$dofiles/merge_state_conditionsOLD.do";
		*this file was from a previous iteration that does not accommodate the rho;
		*we still run it because it makes some useful files (fipstemps and samestateeconconds);
do "$startdir/$dofiles/merge_state_conditions_rho.do";
        *merge current, initial, and cumulative economic conditions with cohort data on c.s. income moments;
do "$startdir/$dofiles/fig_1_natvar.do"; 
        *figures uses raw log income, not residual;
*/;

	
global control "yes"; 



*MAKE ALL THE TABLES: note that I have written in the publication table numbers in comments;

*do "$startdir/$dofiles/tab_1_sumstat.do";  *Table 1; 
/*
do "$startdir/$dofiles/tab_2_natvar.do"; *Table 2; 
do "$startdir/$dofiles/tab_3and4_baseline.do"; *Table 3 and 4 together;
do "$startdir/$dofiles/tab_6_stocks.do"; *Table 5; 
do "$startdir/$dofiles/tab_13_samestate.do"; *Table 6;
do "$startdir/$dofiles/tab_5_altstatecontrols.do"; * Table 7;


**APPENDIX TABLES (Table A.1 not automated);
***do "$startdir/$dofiles/tab_b_betadist.do"; *Table A.2;
***do "$startdir/$dofiles/tab_20_natrobust.do"; *Table C.1;
***do "$startdir/$dofiles/tab_7_staterobust.do"; *Table C.2; 
***do "$startdir/$dofiles/tab_8_betarobust.do"; *Table C.3; 
***do "$startdir/$dofiles/tab_9_educrace.do"; *Table C.4; 
***do "$startdir/$dofiles/tab_16_timing.do"; *Table C.5;
***do "$startdir/$dofiles/tab_17_natvarrho.do"; *Table C.6; 
***do "$startdir/$dofiles/tab_14_rho.do"; *Table C.7;
***do "$startdir/$dofiles/tab_15_guvenen.do"; *Table C.8; 
***do "$startdir/$dofiles/tab_10_altincomes.do"; Table C.9;
***do "$startdir/$dofiles/tab_11_altbottomcodes.do"; Table C.10; 



**the below runs our bootstrapping algorithm when $bootstrap=="BS";
*do "$startdir/$dofiles/bootstrapSEs.do";



/*

log close _all

