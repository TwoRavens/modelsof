

* Setup

# delimit;
capture log close;
clear;
set more off;
set mem 300m;
set matsize 800;
/**set maxvar  1000;
set more off;
global dir = "C:\Documents and Settings\Matias Busso\My Documents\1- Work_in_Progress\D- RA\F- BEEPS\Hein-Matias";

cd "$dir"; */

log using logs/data.final_data.txt, text replace;

/*use of the consolidated database with panel dummy*/
use data/data_panel, clear;

**************************************************************************************************************************
START CREATION OF VARIABLES FOR REGRESSIONS (DUMMIES, LOG TRANSOFRMATIONS, ETC,...)
**************************************************************************************************************************;

/* Drop Turkey from the database */
keep if country~=5; 

/* Millcity - million inhabitants city dummy; citysize - size of the city including the capital */
/*
gen citysize=i_citytown if i_citytown>1;
replace citysize=2 if capital==1 & (country==1 | country==5 | country==8 | country==9 | country==10 | country==11 | country==12 | country==14 | country==15 | country==20 | country==21 | country==23 | country==24 | country==26);
replace citysize=3 if capital==1 & (country==2 | country==3 | country==4 | country==6 | country==7 | country==13 | country==16 | country==17 | country==18 | country==19 | country==22 | country==27 | country==28);
gen millcity=0;
replace millcity=1 if citysize==2;
label var millcity "LARGE CITY";
*/
tab citytown, gen(citytown);

/*label var capital "CAPITAL CITY";*/
/*label var citysize "SIZE OF CITY";*/

/* Sectors: other, construction, manufacturing, transport, trade, real estate, other services; base: 3 */
gen branch=ind if ind>1 & ind<8;
replace branch=1 if ind==1 | ind==9 | ind==10;
replace branch=7 if ind==8;
tab branch, gen(sect);

tab year branch;
label var branch "SECTOR AFFILIATION ";
label define codesSEC 1 "OTHERS" 2 "CONSTRUCTION" 3 "MANUFACTURING" 4 "TRANSPORT, STORAGE & COMMUNIC" 5 "WHOLESALE & RETAIL TRADE" 6 "REAL ESTATE RENTING & BUSINESS SERVICES" 7 "OTHER SERVICES"; 
label values branch codesSEC;

/* Main product of activity */
tab prod2DIG, gen(sect2D);

tab prod2DIG year;

/* status: single proprietorship, partnership, corporation, state firm, other; base: 1 */
gen status=legstqA if legstqA<3;
replace status=3 if legstqA==4 | legstqA==5 ;
replace status=4 if legstqA>6 & legstqA~=.;
replace status=5 if status==. & legstqA~=.;
tab status, gen(status);


/* How established: privatization, originally private, state-owned, other; base: 2 */
gen origin=estb if estb<3;
replace origin=3 if estb==7;
replace origin=4 if estb==4 | estb==5 | estb==3;
tab origin, gen(origin);


/*age-dummy*/
gen age_dummy=1 if age<=3 & age~=.;
replace age_dummy=2 if age>3 & age<=10;
replace age_dummy=3 if age>10;
tab age_dummy, gen(age_dummy);

/* Ownership categories: individual, family, domestic firm, foreign firm, state, others */
gen sobst=.;
replace sobst=1 if owner==1;
replace sobst=2 if owner==2;
replace sobst=3 if owner==4;
replace sobst=4 if owner==5;
replace sobst=5 if owner==10;
replace sobst=6 if sobst==. & owner~=.;
tab sobst, gen (mainown);

/*
* REDEFINITION *
* How established: privatization, originally private, others *
* Joint ventures = originally private *
* Private subsid. of formerly state owned = privatized 
*/

gen howest=estb if estb<3;
replace howest=3 if estb==7;
replace howest=2 if estb==4;
replace howest=1 if estb==3;
replace howest=4 if estb==5;
label var howest "OWNERSHIP TYPE";
label define Lhowest 1 "PRIVATIZATION" 2 "NEW PRIVATE" 3 "STATE" 4 "OTHER"; 
label values howest Lhowest; 


/* PRIVATIZED DUMMY */
gen prvtzd=0 if howest<4;
replace prvtzd=1 if howest==1;
label var prvtzd "PRIVATISED";

/* NEW PRIVATE FIRMS DUMMY */
gen new_prvt=0 if howest<4;
replace new_prvt=1 if howest==2;
label var new_prvt "NEW PRIVATE";

/* STATE */
gen statefirm=0 if howest<4;
replace statefirm=1 if howest==3;
label var statefirm "STATE-OWNED ENTERPRISE";

/* NOTE: howest=4 should be dropped/should not be used */

/* FOREIGN-OWNED DUMMY */
gen for_owned=0 if sobst~=.;
replace for_owned=1 if sobst==4;
label var for_owned "LARGE FOREIGN SHAREHOLDER";
gen maj_for=0 if ownedqB~=.;
replace maj_for=1 if ownedqB>=50 & ownedqB~=.;
label var maj_for "MAJORITY FOREIGN";

gen owner_new=howest;
replace owner_new=5 if ownedqB>=50 & ownedqB~=.;
replace owner_new=3 if ownedqE>=50 & ownedqE~=.;
replace owner_new=4 if owner_new==.;

tab owner_new, m; 
label define Lowner_new 1 "PRIVATIZATION" 2 "NEW PRIVATE" 3 "STATE" 4 "OTHER" 5 "FOREIGN"; 
label values owner_new Lowner_new;

tab owner_new, gen (owner_new);


/*new countries variables in order to get ukraine as reference*/

gen country_UKR_1st=country;
replace country_UKR_1st=9 if country==1;
replace country_UKR_1st=1 if country==9;

/* Creation of  Country Dummies*/
tab country_UKR_1st, gen (countryD);

/*Number of competitors dummy*/
tab nocomp, gen(numcomp);

/*Number of competitors dummy lagged*/
tab nocompR, gen(numcompR);


/*exluding firms declaring no obstacle for all the countraints questions*/
/*
drop if  constrqA==1& constrqB==1& Q2_3constrqC1==1& 
Q2_3constrqC2==1& Q2_3constrqC3==1& Q2_3constrqC4==1& 
Q2_3constrqC5==1& constrqD==1& constrqE==1& 
constrqF==1& constrqG==1& constrqH==1& 
Q2_3constrqI==1& constrqJ==1& constrqK==1& 
constrqL==1& constrqM==1& constrqN==1& 
constrqO==1& constrqP==1& Q2_3constrqQ==1;
*/


/* Generate lag of the capture variable */
gen Q2_3seek_infl_reg=1 if Q2_3seek_infl==1;
replace Q2_3seek_infl_reg=0 if Q2_3seek_infl==2;

********Variables for TFP growth;

gen Dsls=log(1+perfqG/100);

gen Demp=log(1+perfqJ_winsor/100);

gen Dfas=log(1+perfqH/100);

******Variables for TFP in levels;

gen sales=Q2_3sales_per;

gen employ=Q2_3TOT_emp;

gen fixas=Q2_3fixed_assts_per; 

gen logS=log(sales);

gen logE=log(employ);

gen logA=log(fixas);

********Additional variables for Value Added & Materials;

gen materials = mats;

replace matsp = . if matsp <0;

replace materials = matsp/100*sales if materials ==.;

gen valad = sales - materials;

gen logV = log(valad);

gen logM = log(materials + 1);

******Variables logs in levels;

gen logSoE=log(Q2_3salesonemp_new);

gen logExp=log(1+exp_prc_sales/100);

gen logPay=log(1+Q2_3pay_perc_sales_prc/100);

gen logWrk_catqA=log(1+Q2_3ft_wrk_catqA/100); 
gen logWrk_catqB=log(1+Q2_3ft_wrk_catqB/100); 
gen logWrk_catqC=log(1+Q2_3ft_wrk_catqC/100); 
gen logWrk_catqE=log(1+Q2_3ft_wrk_catqE/100);
gen logEdu_lbrqB=log(1+Q2_3edu_lbrqB/100); 
gen logEdu_lbrqC=log(1+Q2_3edu_lbrqC/100); 
gen logEdu_lbrqD=log(1+Q2_3edu_lbrqD/100);

/*

/*potential instruments for the level*/

gen perfqH2=perfqH*perfqH;
gen perfqI2=perfqI*perfqI;
gen perfqJ2=perfqJ_winsor*perfqJ_winsor;
gen perfqG2=perfqG*perfqG;
gen perfqW2=perfqW_winsor*perfqW_winsor;

gen Q2_3cap_utlR2=Q2_3cap_utlR*Q2_3cap_utlR;
gen Q2_3perm_full_empR2=Q2_3perm_full_empR*Q2_3perm_full_empR;
gen Q2_3part_tm_empR2=Q2_3part_tm_empR*Q2_3part_tm_empR;

gen INTor_sect=origin2*branch;
gen INTor_age=origin2*age_dummy3;
gen INTor_perm=origin2*Q2_3perm_full_empR;
gen INTor_part=origin2*Q2_3part_tm_empR;
gen INTage_sect=age_dummy3*branch;
gen INTempg_sect=perfqJ_winsor*branch;
gen INTempg2_sect=perfqJ2*branch;
gen INTexpg_sect=perfqI*branch;
gen INTexpg2_sect=perfqI2*branch;
gen INTfag_sect=perfqH*branch;
gen INTfag2_sect=perfqH2*branch;

gen INTsal_sect=perfqG*branch;
gen INTsal2_sect=perfqG2*branch;

gen INTsoe_sect=perfqW_winsor*branch;
gen INTsoe2_sect=perfqW2*branch;

gen INTcu_sect=Q2_3cap_utlR*branch;
gen INTcu2_sect=Q2_3cap_utlR2*branch;
gen INTfull_sect=Q2_3perm_full_empR*branch;
gen INTfull2_sect=Q2_3perm_full_empR2*branch;
gen INTpart_sect=Q2_3part_tm_empR*branch;
gen INTpart2_sect=Q2_3part_tm_empR*branch;

*/

/*new instruments suggested by jan and yuriy 30 january
: ratio skilled-unskilled, university-secondary*/

gen labsunsk=Q2_3ft_wrk_catqC/Q2_3ft_wrk_catqD;
gen labsnonp=Q2_3ft_wrk_catqC/Q2_3ft_wrk_catqE;

gen labunsec=Q2_3edu_lbrqD/Q2_3edu_lbrqC;
gen labunOTHERS=Q2_3edu_lbrqD/(100-Q2_3edu_lbrqD);
replace labunOTHERS=100 if Q2_3edu_lbrqD==100;
gen labunvoc=Q2_3edu_lbrqD/Q2_3edu_lbrqB;

gen labsunsk_age=labsunsk*age;
gen labsnonp_age=labsnonp*age;

gen labunsec_age=labunsec*age;
gen labunOTHERS_age=labunOTHERS*age;
gen labunsec2=labunsec*labunsec;
gen labunOTHERS2=labunOTHERS*labunOTHERS;
gen labunsec_age2=labunsec*age2;
gen labunOTHERS_age2=labunOTHERS*age2;
gen labunvoc_age=labunvoc*age;
 
gen labpartfull=Q2_3part_tm_emp/Q2_3perm_full_emp;

gen labpartfullR=Q2_3part_tm_empR/Q2_3perm_full_empR;

gen labpartfull_age=labpartfull*age;
gen labpartfullR_age=labpartfullR*age;

/*
*gen prod4DIG=string(Q2_3main_prdc);
tostring prod4DIG, replace;
gen prod3DIG=substr(prod4DIG,1,3);
*gen prod2DIG=substr(prod4DIG,1,2);
*gen prod1DIG=substr(prod4DIG,1,1);

*tab prod4DIG year;
*tab prod3DIG year;
*tab prod2DIG year;
*tab prod1DIG year;

destring prod4DIG, replace;
*/

/*creation of average business environment at the level of the 2digit nace within a country an d year*/

/*
foreach var of varlist 

constrqA
constrqB
constrqC
constrqE
constrqF
constrqG
constrqK
constrqM
constrqP

{;
egen BI_`var'=mean(`var'), by(country prod2DIG year);
};

/*Pricipal components for some variables*/

pca

Q2_3perm_full_empR
Q2_3part_tm_empR;
*score empR_1st_comp;

pca
Q2_3perm_full_empR2
Q2_3part_tm_empR2;
*score empR2_1st_comp;

pca
perfqH
perfqI
perfqG;
*score perf_1st_comp;


/* box variables (i.e. not used)
perfqJ_winsor
perfqW_winsor
perfqJ2
perfqW2
*/


pca
perfqH2
perfqI2
perfqG2;
*score perf2_1st_comp;

*/
drop if year==1999;

/*The following files is the FINAL REGRESSION file. ALL the variables needed in the
regressions are included. Notice that the 1999 data have been dropped and 
that the external (GDP, CPI, EBRD indicators, etc) are included
the variable called panel defines the panel subsample*/



/********************************************************************/


label variable logExp "Log Exp. % Sales";

label variable logE "Log Employment";

label variable logA "Log Fixed Assets";

label variable logS "Log Sales";

label variable logV "Log Value Added";

label variable logM "Log Materials";

label variable perfqH "Growth Fix.Ass. last 3 years "; 
label variable perfqI "Growth Exports last 3 years"; 
label variable perfqJ_winsor "Growth Employment last 3 years "; 
label variable perfqG   "Growth Sales last 3 years";
label variable perfqW_winsor "Growth Sales/Worker last 3 years";
/*label variable perfqH2  "(Growth Fix.ASS. last 3 years)^2";
label variable perfqI2  "(Growth Exports last 3 years)^2";
label variable perfqJ2  "(Growth Employment last 3 years)^2";
label variable perfqG2  "(Growth Sales last 3 years)^2 ";
label variable perfqW2  "(Growth Sales/Worker last 3 years)^2";*/
label variable Q2_3cap_utlR "Capacity Utilisation 3y-ago";
label variable Q2_3perm_full_empR "Full empl 3y-ago";
label variable Q2_3part_tm_empR  "Part-time emp 3y-ago";
/*label variable Q2_3cap_utlR2 "(Capacity Utilisation 3y-ago)^2";
label variable Q2_3perm_full_empR2 "(Full empl 3y-ago)^2";
label variable Q2_3part_tm_empR2 "(Part-time emp 3y-ago)^2";*/
/*label variable INTor_sect "Interaction: leg.origin-sector";
label variable INTor_age "Interactio: leg.origin-age ";
label variable INTor_perm "Interaction: leg.origin-perm.emp.";
label variable INTor_part "Interaction: leg.origin-part.time.emp.";
label variable INTage_sect "Interaction: age-sector";
label variable INTempg_sect "Interaction: Emp.Growth-sector";
label variable INTempg2_sect "Interaction: (Emp.Growth)^2-sector";
label variable INTexpg_sect "Interaction: Exp.Growth-sector";
label variable INTexpg2_sect "Interaction: (Exp.Growth)^2-sector";
label variable INTfag_sect "Interaction: Fix.ASS.Growth-sector";
label variable INTfag2_sect "Interaction: (Fix.ASS.Growth)^2-sector";
label variable INTsal_sect "Interaction: Sales.Growth-sector";
label variable INTsal2_sect "Interaction: (Sales.Growth)^2-sector";
label variable INTsoe_sect "Interaction: Sales/work.Growth-sector";
label variable INTsoe2_sect "Interaction: (Sales/work.Growth)^2-sector";
label variable INTcu_sect "Interaction: Cap.Util.-sector";
label variable INTcu2_sect "Interaction: (Cap.Util.)^2-sector";
label variable INTfull_sect "Interaction: full.emp-sector";
label variable INTfull2_sect "Interaction: (full.emp)^2-sector";
label variable INTpart_sect "Interaction: part.time-sector";
label variable INTpart2_sect "Interaction: (part.time)^2-sector";

label variable BI_constrqA "Avrg. Access financing";
label variable BI_constrqB "Avrg. Cost of financing";
label variable BI_constrqC "Avrg. Infrastructure";
label variable BI_constrqE "Avrg. Tax administration";
label variable BI_constrqF "Avrg. Custom-Trade";
label variable BI_constrqG "Avrg. Business licensing";
label variable BI_constrqK "Avrg. Macroeconomic Instability";
label variable BI_constrqM "Avrg. Corruption";
label variable BI_constrqP "Avrg. Anti-competitive";*/

preserve;
insheet using "$data\educ.txt", clear;

foreach var of varlist nmigr trt_sch_enr trt_sch_enrf trt_sch_enrm country_name {;
        replace `var'= trim(`var');
        };

destring  trt_sch_enr trt_sch_enrf trt_sch_enrm life_expf life_expm life_exp nmigr, force replace;

sort country_name year;
tempfile temp1;
save `temp1', replace;
restore;

sort country_name year;
merge country_name year using `temp1';
tab _merge;
drop if _merge==2;
drop _merge;

drop health_gdp;

sort country_name year;
merge country_name year using data\wdi_data;
tab _merge;
drop if _merge == 2;
drop _merge;

replace trt_sch_enr = trt_sch_enr/100;


save data/final_data.dta, replace;

