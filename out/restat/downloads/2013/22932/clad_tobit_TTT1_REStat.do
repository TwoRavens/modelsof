clear all
drop _all
label drop _all
scalar drop _all
constraint drop _all
discard
set more off
set memory 64m
capture log close

use O:\tekes\newdata\est_y_99_TTT1_REStat

cd "C:\Vanha D\OttoE\Tekes\Bruegel_project\Finland\TTT1_code\REStat"
adopath + "C:\Vanha D\OttoE\Tekes\Bruegel_project\Finland\TTT1_code\REstat"

local mydate: di %tdDNCY date(c(current_date),"DMY")  /* Get today's date for dataname */ 

log using "TTT_REStat_clad_`mydate'.log", replace

set matsize 800
/* GENERATION OF VARIABLES */

drop if ika == .
drop if hlolkm00 == .
drop muu*
gen laani056 = laani05 + laani06
gen hlolkm2 = (hlolkm00^2) / 100
gen lnhlo = ln(hlolkm00)
gen lnhlo2 = lnhlo^2
gen ika2 = ika^2
gen lvh = 0
replace lvh = lv_99 / hlolkm00 if (lv_99 > 0)
gen lvh2 = lvh^2
replace projekti_id = 0 if (projekti_id == .)
gen applicant = 0  
replace applicant = 1 if (projekti_id > 0)

/* rename variables */
rename haklkm_2000enn_plvara appllkm_2000enn_plvara /* count of previous applications */
rename hyv_kust acc_cost /* accepted costs */
rename haettu_kust appl_cost /* original costs */

gen appl_count = appllkm_2000enn_plvara 
gen appl_count2 = appl_count^2
gen hallkoko = hallitus_koko /* size of board */
gen halko2 =  hallitus_koko^2 /* size of board squared */
gen lv2 = lv_99^2

/* gen EXPORTER */
gen exporter = 0
replace exporter = 1 if vieja == 1
replace exporter =1 if vietuo == 1

/* gen SME DUMMY*/
gen sme_s = (lv_99 <= 40000)
gen sme_b = (tase_99 <= 27000)
gen sme_e = (hlolkm00 < 250)
gen sme = 0
replace sme = 1 if (sme_e == 1 & sme_b == 1 | sme_e == 1 & sme_s == 1)
gen s_H = (1-sme)*0.5 + sme*0.6

/*gen lnacc_cost lnapp_cost */

gen lnacc_cost = ln(acc_cost) + ln(1-s_H)
gen lnacc_cost2 = ln(acc_cost)
gen lnappl = ln(appl_cost) + ln(1-s_H)
gen lnappl2 = ln(appl_cost)
gen lnacc_cost_appl = lnacc_cost
replace lnacc_cost_appl = lnappl if lnacc_cost_appl == .
gen lnacc_cost_appl2 = lnacc_cost2
replace lnacc_cost_appl2 = lnappl2 if lnacc_cost_appl2 == .

/* gen SUBSIDY INTENSITY VARIABLE*/
replace laina_ti = 0 if (laina_ti == .)
replace polaina_ti = 0 if (polaina_ti == .)
replace avustus_ti = 0 if (avustus_ti == .)
gen subs_rate = laina_ti + polaina_ti + avustus_ti
replace subs_rate = 0.6 if (subs_rate >= 0.6)
gen hyvhyl1 = (subs_rate > 0)
gen hyvhyl2 = 1
replace hyvhyl2 = 2 if (subs_rate >= s_H)
gen hyvhyl3 = hyvhyl1 * hyvhyl2
gen hyvhyl = (hyvhyl3+1) * applicant

/*gen ORDERED PROBIT DEP VARS */
/* haaste = technical challenge */
gen haaste = . 
replace haaste = 0 if (haaste_id == 1790 | haaste_id == 1791)
replace haaste = 1 if (haaste_id == 1792)
replace haaste = 2 if (haaste_id == 1793)
replace haaste = 3 if (haaste_id == 1794)
replace haaste = 4 if (haaste_id == 1795)
/* riski = market risk */
gen riski =.
replace riski = 0 if (riski_markets_id == 2100)
replace riski = 1 if (riski_markets_id == 2101)
replace riski = 2 if (riski_markets_id == 2102)
replace riski = 3 if (riski_markets_id == 2103)
replace riski = 4 if (riski_markets_id == 2104)
replace riski = 5 if (riski_markets_id == 2105)

/* gen VECTORS OF EXPL. VARIABLES*/
global ind_dum food paper chemi rubber metals electric radiotv otherman telecom datapro r_d
global ind_dum2 food paper chemi rubber metals electric radiotv otherman datapro r_d
global laanit laani02 laani03 laani04 laani056 /* 4 areas */
global rhst3 ika lnhlo lvh emo_y appl_count tj_pj hallkoko exporter $ind_dum $laanit
global rhst2 ika lnhlo lvh sme emo_y appl_count tj_pj hallkoko exporter $ind_dum2 $laanit
global rhst4 ika ika2 lnhlo lnhlo2 lvh lvh2 emo_y appl_count appl_count2 tj_pj hallkoko exporter $ind_dum $laanit


/* ESTIMATION OF OUR MODEL */
/*STEPS:
1. estimation of tekes screening variable using ordered probit, and generation of prob's
2. two-limit tobit of Tekes subsidy-rule
3. calculation of the subsidy term in the selection eq.
4. estimation of the the application and R&D investment equations simultaneously.
*/

/* 1. ESTIMATION OF TEKES SCREENING VARIABLES USING ORDERED PROBITS */
/*1.a. haaste*/

oprobit haaste $rhst3
/* generation of predicted prob's */
predict ph0 ph1 ph2 ph3 ph4
predict haashat, xb
/* 1b. riski */
oprobit riski $rhst3
/* generation of predicted prob's */
predict pr0 pr1 pr2 pr3 pr4
sum ph* pr*
predict riskhat, xb

/* II. ESTIMATION OF TWO-LIMIT CLAD */


*******************************


* Table A.4 column 1


*******************************

ml model lf ourtobit3_lf (subs_rate hyvhyl = riski haaste $rhst2) /sigma_e
ml search
/*ml check*/
ml maximize


***************************************************


* Table A.4 column 2


***************************************************

local j = 0
local i = 1
replace subs_rate = . if applicant == 0
qreg subs_rate riski haaste $rhst2
matrix est0 = e(b)
quietly predict subs0, xb
quietly gen t0 =1
quietly replace t0=. if(subs0<0|subs0>(s_H+0.0125))
quietly gen subs_rate0 = .
quietly replace subs_rate0 = t0*subs_rate
gen mindist = 1
while mindist>0.00001 {
qreg subs_rate`j' riski haaste $rhst2
quietly predict subs`i', xb
matrix est`i' = e(b)
quietly gen t`i' =1
quietly replace t`i'=. if(subs`i'<0|subs`i'>(s_H+0.0125))
quietly gen subs_rate`i' = .
quietly replace subs_rate`i' = t`i'*subs_rate
matrix diff = est`i'-est`j'
svmat diff
local k = 1
while `k' <27 {
replace diff`k' = abs(diff`k')
local k = `k'+1
}
replace mindist = max(diff1,diff2,diff3,diff4,diff5,diff6,diff7,diff8,diff9,diff10,diff11,diff12,diff13,/*
*/diff14,diff15,diff16,diff17,diff18,diff19,diff20,diff21,diff22,diff23,diff24,diff25,diff26)
drop diff*
local i = `i'+1
local j = `j'+1
}



**************************************************************************


* Table A.4 column 3 is the last table produced by this do-fle


**************************************************************************

exit
