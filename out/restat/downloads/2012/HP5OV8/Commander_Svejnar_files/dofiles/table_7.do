#delimit ;
cap log close;

log using $logs/table7.txt, text replace;

/*use of the consolidated database with panel dummy*/
use  $data/final_data.dta, clear;
drop if owner_new4 == 1;

/* Variables */

local variables1 = "sales employ fixas numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5 exp_prc_sales";
local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ
	constrqK constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15";
local variables3 = "labunsec age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR perfqH  perfqI  perfqJ_winsor  perfqG  perfqW_winsor";

foreach var of local variables2 {;
   cap drop BI_`var';
   egen BI_`var'=mean(`var'), by(country prod2DIG sizeb year);
  };

local variables4 = "BI_constrqA BI_constrqB BI_constrqD BI_constrqE BI_constrqF BI_constrqG BI_constrqH BI_constrqJ
	BI_constrqK BI_constrqL BI_constrqM BI_constrqN BI_constrqO BI_constrqP BI_constrqC BI_constrqALL15";


label variable constrqA  "ACCESS TO FINANCING ";
label variable constrqB  "COST OF FINANCING ";
label variable constrqC  "INFRASTRUCTURE ";
label variable constrqD  "TAX RATES ";
label variable constrqE  "TAX ADMINISTRATION ";
label variable constrqF  "CUSTOM/FOREIGN TRADE REGULATIONS ";
label variable constrqG  "BUSINESS LICENCING & PERMIT ";
label variable constrqH  "LABOUR REGULATIONS ";
label variable constrqJ  "UNCERTAINTY ABOUT REGULATORY POLICIES ";
label variable constrqK  "MACROECONOMIC INSTABILITY ";
label variable constrqL  "FUNCTIONING OF THE JUDICIARY ";
label variable constrqM  "CORRUPTION ";
label variable constrqN  "STREET CRIME THEFT & DISORDER ";
label variable constrqO  "ORGANISED CRIME MAFIA ";
label variable constrqP  "ANTI-COMPETITIVE PRACTICES ";

label variable BI_constrqA  "ACCESS TO FINANCING ";
label variable BI_constrqB  "COST OF FINANCING ";
label variable BI_constrqC  "INFRASTRUCTURE ";
label variable BI_constrqD  "TAX RATES ";
label variable BI_constrqE  "TAX ADMINISTRATION ";
label variable BI_constrqF  "CUSTOM/FOREIGN TRADE REGULATIONS ";
label variable BI_constrqG  "BUSINESS LICENCING & PERMIT ";
label variable BI_constrqH  "LABOUR REGULATIONS ";
label variable BI_constrqJ  "UNCERTAINTY ABOUT REGULATORY POLICIES ";
label variable BI_constrqK  "MACROECONOMIC INSTABILITY ";
label variable BI_constrqL  "FUNCTIONING OF THE JUDICIARY ";
label variable BI_constrqM  "CORRUPTION ";
label variable BI_constrqN  "STREET CRIME THEFT & DISORDER ";
label variable BI_constrqO  "ORGANISED CRIME MAFIA ";
label variable BI_constrqP  "ANTI-COMPETITIVE PRACTICES ";

keep if panel == 1;
sort country_UKR_1st id_merge year;
egen sump = sum(panel), by(id_merge);
drop if sump == 1;

foreach var of local variables4 {;
	replace `var' = `var'[_n-1] if year == 2005;
};

foreach var of varlist owner_new* logExp numcomp3 {;
	replace `var' = `var'[_n-1] if year == 2005;
};


keep if year == 2005;

egen minSG = min(perfqG - 1) if logS !=.;
gen logSG = log(perfqG - minSG);
egen minEG = min(perfqJ - 1) if logE !=.;
gen logEG = log(perfqJ - minEG);
egen minAG = min(perfqH - 1) if logA !=.;
gen logAG = log(perfqH - minAG);

global PARS    	= "logEG logAG";
global PARS2	= "logEG logAG owner_new1 owner_new2 owner_new5";
global PARS3  	= "logEG logAG owner_new1 owner_new2 owner_new5 logExp numcomp3";

global EXOGEN   = "BI_constrqB BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM  BI_constrqN BI_constrqP";
global EXOGEN2  = "BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM";

global DUMMIES  = "sect1-sect2  sect4-sect7 i.year i.country";

global INSTR    = "labunsec labunsec2 age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR citytown perfqH perfqI";

gen x = 1;
foreach var of global INSTR {;
replace x = 0 if `var' ==.;
};

keep if x == 1;

/* regressions with constraints */
xi: regress logSG $PARS3 $EXOGEN $DUMMIES, robust;
outreg2 $PARS3 $EXOGEN using $tables/table7, replace bdec(3) se aster(se) bracket label;

xi: regress logSG $PARS $DUMMIES, robust;
outreg2 $PARS using $tables/table7, append bdec(3) se aster(se) bracket label;

xi: regress logSG $PARS2 $DUMMIES, robust;
outreg2 $PARS2 using $tables/table7, append bdec(3) se aster(se) bracket label;

xi: regress logSG $PARS logExp numcomp3 $DUMMIES, robust;
outreg2 $PARS logExp numcomp3 using $tables/table7, append bdec(3) se aster(se) bracket label;

xi: regress logSG $PARS3 $DUMMIES, robust;
outreg2 $PARS3 using $tables/table7, append bdec(3) se aster(se) bracket label;

foreach var of global EXOGEN{;
xi: regress logSG $PARS3 `var' $DUMMIES, robust;
outreg2 $PARS3 `var' using $tables/table7, append bdec(3) se aster(se) bracket label;
};

xi: regress logSG $PARS3 BI_constrqALL15 $DUMMIES, robust;
outreg2 $PARS3 BI_constrqALL15 using $tables/table7, append bdec(3) se aster(se) bracket label;

xi: regress logSG $PARS3 $EXOGEN $DUMMIES, robust;
outreg2 $PARS3 $EXOGEN using $tables/table7, append bdec(3) se aster(se) bracket label  sortvar($PARS3 $EXOGEN constrqALL15);


log close;

