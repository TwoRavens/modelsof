
use "O:\tekes\newdata\est_y_99_TTT1_REStat.dta", clear

cd "C:\Vanha D\OttoE\Tekes\Bruegel_project\Finland\TTT1_code\REStat"
adopath + "C:\Vanha D\OttoE\Tekes\Bruegel_project\Finland\TTT1_code\REStat"
log using "bs_results.log", replace

set matsize 800
/* GENERATION OF VARIABLES */
drop if ika ==.
drop if hlolkm00 ==.
drop muu*
gen laani056 = laani05+laani06
gen hlolkm2 = (hlolkm00^2)/100
gen lnhlo = ln(hlolkm00)
gen lnhlo2 = lnhlo^2
gen ika2 = ika^2
gen lvh = 0
replace lvh = lv_99/hlolkm00 if (lv_99>0)
gen lvh2 = lvh^2
replace projekti_id = 0 if (projekti_id==.)
gen hakenut =0  
replace hakenut = 1 if (projekti_id>0)
gen hak_aik=haklkm_2000enn_plvara 
gen hak_aik2 = hak_aik^2
gen hallkoko = hallitus_koko
/* gen EXPORTER */
gen exporter = 0
replace exporter = 1 if vieja==1
replace exporter =1 if vietuo==1
/* gen SME DUMMY*/
gen sme_s= (lv_99 <=40000)
gen sme_b= (tase_99 <=27000)
gen sme_e = (hlolkm00<250)
gen sme = 0
replace sme = 1 if (sme_e==1&sme_b==1|sme_e==1&sme_s==1)
gen s_H = (1-sme)*0.5+sme*0.6
/*gen LNHYVKUST LNHAETTU */
gen lnhyvkust = ln(hyv_kust)+ln(1-s_H)
gen lnhyvkust2 = ln(hyv_kust)
gen lnhaettu = ln(haettu_kust)+ln(1-s_H)
gen lnhaettu2 = ln(haettu_kust)
gen lnhyvkust_hak = lnhyvkust
replace lnhyvkust_hak = lnhaettu if lnhyvkust_hak == .
gen lnhyvkust_hak2 = lnhyvkust2
replace lnhyvkust_hak2 = lnhaettu2 if lnhyvkust_hak2 == .
/* gen SUBSIDY INTENSITY VARIABLE*/
replace laina_ti = 0 if (laina_ti ==.)
replace polaina_ti = 0 if (polaina_ti==.)
replace avustus_ti = 0 if (avustus_ti==.)
gen tukint = laina_ti+polaina_ti+avustus_ti
replace tukint = 0.6 if (tukint>= 0.6)
/* gen SUBSIDY DECISION CATEGORIES*/
gen hyvhyl1 = (tukint >0)
gen hyvhyl2 = 1
replace hyvhyl2 = 2 if (tukint >= s_H)
gen hyvhyl3 = hyvhyl1*hyvhyl2
gen hyvhyl = (hyvhyl3+1)*hakenut
/*gen ORDERED PROBIT DEP VARS */
gen haaste =. 
replace haaste =0 if (haaste_id==1790 |haaste_id==1791)
replace haaste = 1 if (haaste_id==1792)
replace haaste = 2 if (haaste_id==1793)
replace haaste = 3 if (haaste_id==1794)
replace haaste = 4 if (haaste_id==1795)
gen riski =.
replace riski = 0 if (riski_markets_id==2100)
replace riski = 1 if (riski_markets_id==2101)
replace riski = 2 if (riski_markets_id==2102)
replace riski = 3 if (riski_markets_id==2103)
replace riski = 4 if (riski_markets_id==2104)
replace riski = 5 if (riski_markets_id==2105)
/* gen VECTORS OF EXPL. VARIABLES*/
global ind_dum food paper chemi rubber metals electric radiotv otherman telecom datapro r_d
global ind_dum2 food paper chemi rubber metals electric radiotv otherman datapro r_d
global laanit laani02 laani03 laani04 laani056 /* 4 areas */
global rhst3 ika lnhlo lvh emo_y hak_aik tj_pj hallkoko exporter $ind_dum $laanit
global rhst2 ika lnhlo lvh sme emo_y hak_aik tj_pj hallkoko exporter $ind_dum2 $laanit
global rhst4 ika ika2 lnhlo lnhlo2 lvh lvh2 emo_y hak_aik hak_aik2 tj_pj hallkoko exporter $ind_dum $laanit

/* ESTIMATION OF OUR MODEL */
/*STEPS:
1. estimation of tekes screening variable using ordered probit, and generation of prob's
2. two-limit tobit of Tekes subsidy-rule
3. calculation of the expected subsidy term in the selection eq. -ln(1-s) and the expected subsidy
4. estimation of the the application and R&D investment equations simultaneously.
*/

/* 1. ESTIMATION OF TEKES SCREENING VARIABLES USING ORDERED PROBITS */
/*1.a. haaste*/
oprobit haaste $rhst3
/* generation of predicted prob's */
predict ph0 ph1 ph2 ph3 ph4
/* 1b. riski */
oprobit riski $rhst3
/* generation of predicted prob's */
predict pr0 pr1 pr2 pr3 pr4

/* 2. TWO-LIMIT TOBIT ESTIMATION OF TEKES DECISION RULE*/
ml model lf ourtobit3_lf (tukint hyvhyl = riski haaste $rhst2) /sigma_e
ml search
/*ml check*/
ml maximize
matrix coeffs = e(b)
svmat coeffs
scalar sig_e = coeffs27

/* 3.GENERATION OF THE EXPECTED SUBSIDY TERMS E[-ln(1-s)]=lnes AND E[s]=es_i*/
qui gen yhati1=_b[_cons]+_b[ika]*ika+_b[lnhlo]*lnhlo/*
*/+_b[lvh]*lvh+_b[sme]*sme+_b[emo_y]*emo_y+_b[hak_aik]*hak_aik
qui gen yhati2 =_b[tj_pj]*tj_pj+_b[hallkoko]*hallkoko+_b[exporter]*exporter/*
*/+_b[food]*food+_b[paper]*paper+_b[chemi]*chemi+_b[rubber]*rubber+_b[metals]*metals+_b[electric]*electric+_b[radiotv]*radiotv
qui gen yhati3 =_b[otherman]*otherman+_b[datapro]*datapro+_b[r_d]*r_d+_b[laani02]*laani02+_b[laani03]*laani03/*
*/+_b[laani04]*laani04+_b[laani056]*laani056
qui gen yhat00 = yhati1+yhati2+yhati3

do "pred1_TTT1_REStat.do"
do "integ_loop_TTT1_REStat.do"
do "pred2_TTT1_REStat.do"

gen lnlnes = ln(lnes)

/*4. OWN SAMPLE SELECTION MODEL (R&D AND APPLICATION EQUATIONS)*/
gen lnappl = ln(haettu_kust) + ln(1-s_H)
heckman lnappl $rhst4, select(hakija = $rhst4 sme lnlnes)
matrix c_est = e(b)


