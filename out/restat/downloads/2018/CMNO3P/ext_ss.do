/* Extract data for Social Security project */
/* Data from 1980-1987 is from IPUMS-CPS */
/* Data from 1988-2013 is from NBER */

/* Some 1995 variables names are slightly different so process 1995 first */

#delimit';'
set memory 1500m;
set more off;

global nbervars "h_year a_age a_sex a_hga a_maritl a_exprrp
                 ph_seq ffpos pppos h_month a_lineno a_spouse workyn
                 povll fpersons fheadidx fownu18 frelu18 ftotval fearnval
                 fkind
                 ss_yn ss_val i_ssyn i_ssval
                 uc_yn uc_val i_ucyn i_ucval
                 wc_yn wc_type wc_val i_wcyn i_wctyp i_wcval 
                 ssi_yn ssi_val i_ssiyn i_ssival
                 paw_yn paw_typ paw_mon paw_val 
                 i_pawyn i_pawtyp i_pawval i_pawmo 
                 wsal_yn wsal_val
                 i_ernval i_ernyn i_frmval i_frmyn
                 i_seval i_seyn i_wsval i_wsyn
                 lkweeks i_lkweek
                 fl_665
                 marsupwt hsup_wgt";

/* First, just check means of IPUMS-CPS data */
/* Can replace filename cps_ipums.dta with name of downloaded data from CPS */
use "cps_ipums.dta";
sum;
clear;

/* Then, open data from NBER */
/* Start with 1995 data since variables names need to be changed */
use "cpsmar95.dta";
replace h_year = 1995;

rename peage a_age;
rename pesex a_sex;
rename peeduca a_hga;
rename prmarsta a_maritl;
rename perace a_race;
rename pulineno a_lineno;
rename pespouse a_spouse;
keep ${nbervars} hg_st60 a_race;
sum;


/* For 1994, a_lineno is called pulineno */
/* So need to bring it outside of the loop! */
quietly append using "cpsmar94.dta";
replace h_year = 1994 if h_year==4; /* Year single digit <99 */
replace a_lineno = pulineno if h_year==1994;
keep ${nbervars} hg_st60 a_race;
sum;



/* Then loop through adding other years: */
/* 1988-1991 - have separate education completed var a_hgc */
/* 1992-1993 - 1994 and 1995 above */
/* Beginning 1996, have individual medicaid (also need other insurance) */
/* Beginning 2000, do not need to replace year */
/* Beginning 2001, add a follow-up set of health insurance questions */
/* Also, variable name for state of residence based on 1960 Census code is */
/* hg_st60 for 1988-2004 and gestcen for 2005-2013 */
/* Race is a_race -2002 and then prdtrace from 2003- */
for num 88/91: quietly append using "cpsmarX.dta",
                       keep(${nbervars} a_hgc hg_st60 a_race)\
               replace h_year = 19X if h_year<1900; /* Year single digit <99 */
for num 92/93: quietly append using "cpsmarX.dta",
                       keep(${nbervars} hg_st60 a_race)\
               replace h_year = 19X if h_year<1900; /* Year single digit <99 */
for num 96/99: quietly append using "cpsmarX.dta",
                       keep(${nbervars} hg_st60 a_race
                            mcaid mcare cov_hi champ
                            i_hi i_dephi i_priv i_depriv i_out
                            i_caid i_care i_oth i_otyp i_ostper i_ostyp)\
               replace h_year = 19X if h_year<1900; /* Year single digit <99 */
/* 2000 by itself */
quietly append using "cpsmar00.dta", keep(${nbervars} hg_st60 a_race
                            mcaid mcare cov_hi champ
                            i_hi i_dephi i_priv i_depriv i_out
                            i_caid i_care i_oth i_otyp i_ostper i_ostyp);
for num 1/2: quietly append using "cpsmar0X.dta",
                     keep(${nbervars} hg_st60 a_race
                            mcaid mcare cov_hi champ pchip
                            i_hi i_dephi i_priv i_depriv i_out iahityp i_pchip
                            i_caid i_care i_oth i_otyp i_ostper i_ostyp);
for num 3/4: quietly append using "cpsmar0X.dta",
                     keep(${nbervars} hg_st60 prdtrace
                            mcaid mcare cov_hi champ pchip
                            i_hi i_dephi i_priv i_depriv i_out iahityp i_pchip
                            i_caid i_care i_oth i_otyp i_ostper i_ostyp);
for num 5/9: quietly append using "cpsmar0X.dta",
                     keep(${nbervars} gestcen prdtrace
                            mcaid mcare cov_hi champ pchip
                            i_hi i_dephi i_priv i_depriv i_out iahityp i_pchip
                            i_caid i_care i_oth i_otyp i_ostper i_ostyp);
for num 0/3: quietly append using "cpsmar1X.dta",
                      keep(${nbervars} gestcen prdtrace
                            mcaid mcare cov_hi champ pchip
                            i_hi i_dephi i_priv i_depriv i_out iahityp i_pchip
                            i_caid i_care i_oth i_otyp i_ostper i_ostyp);
sum;

/* Rename variables to match IPUMS-CPS names */
rename h_year year;
rename a_age age;
rename a_sex sex;
rename a_maritl marst;
rename a_exprrp relate;
rename a_race race;
rename h_month month;
rename ss_val incss;
rename i_ssval qincss;
rename paw_val incwelfr;
rename i_pawval qincwelf;
rename wsal_val incwage;
rename marsupwt wtsupp;
rename hsup_wgt hwtsupp;

/* For 2003 and later, race is in the multipunch variable prdtrace */
replace race = prdtrace if year>=2003;
drop prdtrace;


/* Put the state of residence variable into one variable */
replace hg_st60 = gestcen if year>=2005;
drop gestcen;
tab hg_st60, missing;
tab year if hg_st60==.;

/* Now merge on state fips code to replace 1960 Census codes */
gen census_code = hg_st60;
sort census_code;
merge census_code using "state_fips_1960census.dta", keep(fips_code);
tab _merge;
rename fips_code statefip;
tab statefip, missing;
tab year if statefip==.;
tab hg_st60 if statefip==.;
drop _merge census_code;

/* Check the race variable */
bysort year: tab race, nolabel;

/* Recode to match race */
/* -1987 there are three race codes: white, black, other */
/* 1988-1995 have five: add american indian and asian */
/* 1996-2002 have four: drop other */
recode race (1 = 100) (2 = 200) (3 = 300) (4 = 650) (5 = 700)
            if year>=1988&year<=2002, gen(race1);
tab year race1;
/* 2003-2012 goes multipunch: have 21 */
recode race (1 = 100) (2 = 200) (3 = 300) (4 = 651) (5 = 652)
            (6 = 801) (7 = 802) (8 = 803) (9 = 804) (10 = 805)
            (11 = 806) (12 = 807) (13 = 808) (14 = 809) (15 = 810)
            (16 = 811) (17 = 812) (18 = 813) (19 = 814) (20 = 820)
            (21 = 830)
            if year>=2003&year<=2012, gen(race2);
bysort year: tab race2;
/* 2013- add more multipunch: goes to 26 */
/* CPS codes the same for 1-13 but then insert new codes */
recode race (1 = 100) (2 = 200) (3 = 300) (4 = 651) (5 = 652)
            (6 = 801) (7 = 802) (8 = 803) (9 = 804) (10 = 805)
            (11 = 806) (12 = 807) (13 = 808)
            (14 = 815) (15 = 809) (16 = 810) (17 = 811)
            (18 = 816) (19 = 812)
            (20 = 817) (21 = 813) 
            (22 = 818) (23 = 814)
            (24 = 819) (25 = 820) (26 = 830)
            if year>=2013, gen(race3);
bysort year: tab race3;

replace race = race1 if year>=1988&year<=2002;
replace race = race2 if year>=2003&year<=2012;
replace race = race3 if year>=2013;
drop race1 race2 race3;

/* Check RECODED race variable */
bysort year: tab race, nolabel;


/* Check relationship to head variable */
bysort year: tab relate, nolabel;

/* Recode to match relate */
/* IMPORTANT - from 1995 and on,CPS codes 12-14 change */
/* However, for purposes here, these are all non-relatives so it is fine */
/* But should re-visit later */
recode relate (1/2 = 101) (3/4 = 201) (5 = 301) (6 = 303) (7 = 901) (8 = 501)
              (9 = 701) (10 = 1001) (11 = 1242) (12 14 = 1260) (13 = 1113);

/* Check RECODED relationship to head variable */
bysort year: tab relate, nolabel;


/* Check marital status by year */
bysort year: tab marst, nolabel;

/* Remap Marital status to match IPUMS values */
recode marst (1/2 = 1) (3 = 2) (4 = 5) (5 = 4) (6 = 3) (7 = 6);

/* Check RECODED marital status by year */
bysort year: tab marst, nolabel;

/* Modify the label for marital status to account for the recodes */
label define prmarsta 2 "Married - spouse absent", modify;
label define prmarsta 3 "Separated", modify;
label define prmarsta 4 "Divorced", modify;
label define prmarsta 5 "Widowed", modify;
label define prmarsta 6 "Never married/single", modify;




/* Create education variable to match IPUMS EDUC variable */
/* a_hga is same as IPUMS EDUC99 variable */
/* Checked cross-walk based on sample sizes in IPUMS to link */
bysort year: tab a_hga, nolabel;
bysort year: tab a_hga a_hgc, nolabel;


/* Create the IPUMS EDUC variable */
/* First for 1988-1991 */
gen educ = 1 if year>=1988&year<=1991&a_hga==0&a_hgc==0;
replace educ = 2 if year>=1988&year<=1991&((a_hga==0&a_hgc==2)|(a_hga==1&a_hgc==2));
replace educ = 11 if year>=1988&year<=1991&((a_hga==1&a_hgc==1)|(a_hga==2&a_hgc==2));
replace educ = 12 if year>=1988&year<=1991&((a_hga==2&a_hgc==1)|(a_hga==3&a_hgc==2));
replace educ = 13 if year>=1988&year<=1991&((a_hga==3&a_hgc==1)|(a_hga==4&a_hgc==2));
replace educ = 14 if year>=1988&year<=1991&((a_hga==4&a_hgc==1)|(a_hga==5&a_hgc==2));
replace educ = 21 if year>=1988&year<=1991&((a_hga==5&a_hgc==1)|(a_hga==6&a_hgc==2));
replace educ = 22 if year>=1988&year<=1991&((a_hga==6&a_hgc==1)|(a_hga==7&a_hgc==2));
replace educ = 31 if year>=1988&year<=1991&((a_hga==7&a_hgc==1)|(a_hga==8&a_hgc==2));
replace educ = 32 if year>=1988&year<=1991&((a_hga==8&a_hgc==1)|(a_hga==9&a_hgc==2));
replace educ = 40 if year>=1988&year<=1991&((a_hga==9&a_hgc==1)|(a_hga==10&a_hgc==2));
replace educ = 50 if year>=1988&year<=1991&((a_hga==10&a_hgc==1)|(a_hga==11&a_hgc==2));
replace educ = 60 if year>=1988&year<=1991&((a_hga==11&a_hgc==1)|(a_hga==12&a_hgc==2));
replace educ = 72 if year>=1988&year<=1991&a_hga==12&a_hgc==1;
replace educ = 73 if year>=1988&year<=1991&a_hga==13&a_hgc==2;
replace educ = 80 if year>=1988&year<=1991&((a_hga==13&a_hgc==1)|(a_hga==14&a_hgc==2));
replace educ = 90 if year>=1988&year<=1991&((a_hga==14&a_hgc==1)|(a_hga==15&a_hgc==2));
replace educ = 100 if year>=1988&year<=1991&((a_hga==15&a_hgc==1)|(a_hga==16&a_hgc==2));
replace educ = 110 if year>=1988&year<=1991&((a_hga==16&a_hgc==1)|(a_hga==17&a_hgc==2));
replace educ = 121 if year>=1988&year<=1991&((a_hga==17&a_hgc==1)|(a_hga==18&a_hgc==2));
replace educ = 122 if year>=1988&year<=1991&a_hga==18&a_hgc==1;

/* Then for 1992-2013 */
replace educ = 1 if year>=1992&year<=2013&a_hga==0;
replace educ = 2 if year>=1992&year<=2013&a_hga==31;
replace educ = 10 if year>=1992&year<=2013&a_hga==32;
replace educ = 20 if year>=1992&year<=2013&a_hga==33;
replace educ = 30 if year>=1992&year<=2013&a_hga==34;
replace educ = 40 if year>=1992&year<=2013&a_hga==35;
replace educ = 50 if year>=1992&year<=2013&a_hga==36;
replace educ = 60 if year>=1992&year<=2013&a_hga==37;
replace educ = 71 if year>=1992&year<=2013&a_hga==38;
replace educ = 73 if year>=1992&year<=2013&a_hga==39;
replace educ = 81 if year>=1992&year<=2013&a_hga==40;
replace educ = 91 if year>=1992&year<=2013&a_hga==41;
replace educ = 92 if year>=1992&year<=2013&a_hga==42;
replace educ = 111 if year>=1992&year<=2013&a_hga==43;
replace educ = 123 if year>=1992&year<=2013&a_hga==44;
replace educ = 124 if year>=1992&year<=2013&a_hga==45;
replace educ = 125 if year>=1992&year<=2013&a_hga==46;

bysort year: tab educ;


/* Use the same CPI99 variable to adjust price level */
gen long CPI99 = .;
for num 1988/2013 \
    num 1.467 1.408 1.344 1.275 1.223 1.187
        1.153 1.124 1.093 1.062 1.038 1.022
        1.000 0.967 0.941 0.926 0.905 0.882
        0.853 0.826 0.804 0.774 0.777 0.764
        0.741 0.726 :
      replace CPI99 = Y if year==X;
sum CPI99, detail;


/* Finally add on IPUMS-CPS data */
append using "cps_ipums.dta";
for var incss incwelfr: replace X = 0 if X==99999&year>=1980&year<=1987;
   /* IPUMS-CPS makes inc vars 99999 for those not age eligible for inc quest*/
   /* Map back to regular CPS for purposes here */
sum;


/* Check the weights by year to see if anything odd happens over time */
/* When moving from IPUMS to NBER data */
bysort year: sum wtsupp, detail;
bysort year: sum hwtsupp, detail;

/* Save the data file */
save "cps_ss_8013",replace;
sum;

