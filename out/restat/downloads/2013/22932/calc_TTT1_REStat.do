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

* paths
cd "C:\Vanha D\OttoE\Tekes\Bruegel_project\Finland\TTT1_code\REStat"
adopath + "C:\Vanha D\OttoE\Tekes\Bruegel_project\Finland\TTT1_code\REStat"

local mydate: di %tdDNCY date(c(current_date),"DMY")  /* Get today's date for dataname */ 

* NOTE: change capital letter according to which integration do-file 
* (see row 389) is used to produce implications of the model

log using "TTT_REStat_A_`mydate'.log", replace

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

* applicant 
gen hakija =0  
replace hakija = 1 if (projekti_id>0)

* # previous applications
gen hak_aik = haklkm_2000enn_plvara 
gen hak_aik2 = hak_aik^2
gen hallkoko = hallitus_koko
gen halko2 =  hallitus_koko^2
gen lv2 = lv_99^2

* exporter
gen exporter = 0
replace exporter = 1 if vieja==1
replace exporter =1 if vietuo==1

* sme dummy
gen sme_s = (lv_99 <=40000)
gen sme_b = (tase_99 <=27000)
gen sme_e = (hlolkm00<250)
gen sme = 0
replace sme = 1 if (sme_e == 1 & sme_b == 1 | sme_e == 1 & sme_s == 1)
gen s_H = (1 - sme) * 0.5 + sme * 0.6

* accepted R&D costs
gen lnhyvkust = ln(hyv_kust)+ln(1-s_H)
gen lnhyvkust2 = ln(hyv_kust)

* applied R&D costs
gen lnhaettu = ln(haettu_kust)+ln(1-s_H)
gen lnhaettu2 = ln(haettu_kust)
gen lnhyvkust_hak = lnhyvkust
replace lnhyvkust_hak = lnhaettu if lnhyvkust_hak == .
gen lnhyvkust_hak2 = lnhyvkust2
replace lnhyvkust_hak2 = lnhaettu2 if lnhyvkust_hak2 == .

* subsidy rate
replace laina_ti = 0 if (laina_ti ==.)
replace polaina_ti = 0 if (polaina_ti==.)
replace avustus_ti = 0 if (avustus_ti==.)
gen tukint = laina_ti+polaina_ti+avustus_ti
* tukint = subsidy rate (= s in the paper)
replace tukint = 0.6 if (tukint>= 0.6)
gen hyvhyl1 = (tukint >0)
gen hyvhyl2 = 1
replace hyvhyl2 = 2 if (tukint >= s_H)
gen hyvhyl3 = hyvhyl1*hyvhyl2
gen hyvhyl = (hyvhyl3+1)*hakija

/*gen ORDERED PROBIT DEP VARS */

* technical challenge
gen haaste =. 
replace haaste =0 if (haaste_id==1790 |haaste_id==1791)
replace haaste = 1 if (haaste_id==1792)
replace haaste = 2 if (haaste_id==1793)
replace haaste = 3 if (haaste_id==1794)
replace haaste = 4 if (haaste_id==1795)

* market risk
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


/************************************************************************************



	ESTIMATION STARTS HERE



************************************************************************************/




/* ESTIMATION OF OUR MODEL */
/*STEPS:
1. estimation of tekes screening variable using ordered probit, and generation of prob's
2. two-limit tobit of Tekes subsidy-rule
3. calculation of the subsidy term in the selection eq.
4. estimation of the the application and R&D investment equations simultaneously.
*/

/* 1. ESTIMATION OF TEKES SCREENING VARIABLES USING ORDERED PROBITS */

*******************************


* Table A.3


*******************************

/*1.a. technical challenge */
* Table A.3, col 1 in TTT_REStat
oprobit haaste $rhst3
/* generation of predicted prob's */
predict ph0 ph1 ph2 ph3 ph4
/* 1b. market risk */
* Table A.3, col 2 in TTT_REStat
oprobit riski $rhst3
/* generation of predicted prob's */
predict pr0 pr1 pr2 pr3 pr4

/* 2. TWO-LIMIT TOBIT ESTIMATION OF TEKES DECISION RULE*/

*******************************


* Table 5


*******************************

* Table 5 in TTT_REStat
ml model lf ourtobit3_lf (tukint hyvhyl = riski haaste $rhst2) /sigma_e
ml search
/*ml check*/
ml maximize
matrix coeffs = e(b)
svmat coeffs
scalar sig_e = coeffs27 
scalar sig_eta = sig_e

/* 3.GENERATION OF THE EXPECTED SUBSIDY TERMS E[-ln(1-s)]=lnes AND E[s]=es_i*/
matrix B = e(b) 
local r = e(df_m) 
local r1 = e(df_m) + 1 
matrix b = B[1,3..`r1'] 
gen const = 1 
gen yhat00 = .  
global apu $rhst2 const 

mata:  
apu = st_global("apu")
rhst = tokens(apu)
st_view(X=., ., (rhst))
b=st_matrix("b")
y = X*b'
st_store(., "yhat00" , y)
end

local r2 = e(df_m) + 2 
scalar sig_e = el(B, 1, `r2') 
scalar sig_eta = sig_e 

gen es = yhat00 + _b[haaste] * (ph1 + ph2 * 2 + ph3 * 3 + ph4 * 4) + _b[riski] * (pr1 + pr2 * 2 + pr3 * 3 + pr4 * 4)  /* use expected haaste and riski for non-applicants */
gen es_uc = es
gen es_1 = es+0.2 /* assumption that g = 1.2 */
replace es = 0 if es<=0
replace es = s_H if es>=s_H & es != .

* do numerical integration
qui do "pred1_TTT1_REStat.do"
qui do "integ_loop_TTT1_REStat.do"
qui do "pred2_TTT1_REStat.do"

gen lnlnes = ln(lnes)



/*4. OWN SAMPLE SELECTION MODEL (R&D AND APPLICATION EQUATIONS)*/

*******************************


* Table 7 (the upper part: lnappl)


*******************************

heckman lnhaettu $rhst4, select(hakija = $rhst4 sme lnlnes)
matrix c_est = e(b)
predict ess1, xb/* predicted value of the investment equation = x'b - note that lnhaettu = ln(haettu_kust)+ln(1-s_H) */
gen elnhaettu = ess1 - ln(1-s_H) /* ln(R(s=s_H))- note that lnhaettu = ln(haet_kust)+ln(1-s_H) */
gen e=lnhaettu-ess1
predict ess2, xbsel /* predicted value (linear) of the application equation = x'(b-theta)+lnlnes/sigma_nu */
scalar isignu = c_est[1,57]

* SUMMARY STATISTICS
*******************************


* Table 1 & A.1


*******************************
* Table 1 & Table A.1 in TTT_REstat
tabstat agri $rhst3 laani01 hlolkm00 sme if e(sample), stat(mean sd p50 min max n) casewise

*******************************


* Table 2 & A.2


*******************************

* Table 2, col 1 and 2 & Table A.2, col 1 in TTT_REStat(the row with applicant == 1)
tabstat $rhst3 hlolkm00 sme if e(sample), stat(mean sd p50 min max n) by(hakija) casewise
* Table 2, col 3 in TTT_REStat
tabstat $rhst3 hlolkm00 if e(sample) & hakija == 1 & tukint == 0, stat(mean sd p50 min max n) casewise
* Table 2, col 4 and 2 & Table A.2, col 2 in TTT_REStat
tabstat $rhst3 hlolkm00 sme if e(sample) & hakija == 1 & tukint > 0, stat(mean sd p50 min max n) casewise
* Table A.2, col 3 in TTT_REStat
tabstat $rhst3 hlolkm00 sme if e(sample) & hakija == 1 & haaste != . & riski != ., stat(mean sd p50 min max n) casewise

gen subs_only = .
replace subs_only = 0 if hakija == 1
replace subs_only = 1 if laina_ti == 0 & polaina_ti == 0 & avustus_ti > 0
gen success = .
replace success = 0 if hakija == 1 & tukint == 0
replace success = 1 if hakija == 1 & tukint > 0

*******************************


* Table 3


*******************************

gen subs_app_only = 0
replace subs_app_only = 1 if haettu_a >= 0 & haettu_l == . & haettu_e == . & haettu_l2 == .

* first col of table reproduces Table 3 row 1 in TTT_REStat
tabstat haettu_kust subs_app_only hyv_kust $rhst3 hlolkm00 sme , stat(mean sd n) by(success) casewise
* first col of table reproduces Table 3 row 2 in TTT_REStat
tabstat subs_app_only haettu_kust hyv_kust $rhst3 hlolkm00 sme , stat(mean sd n) by(success) casewise
* first col of table reproduces Table 3 row 3 in TTT_REStat
tabstat haaste $rhst3 hlolkm00 sme , stat(mean sd n) by(success) casewise
* first col of table reproduces Table 3 row 4 in TTT_REStat
tabstat riski $rhst3 hlolkm00 sme , stat(mean sd n) by(success) casewise
* first & second col of table reproduces Table 3 rows 5 & 6 in TTT_REStat
tabstat tukint subs_only $rhst3 hlolkm00 sme, stat(mean sd n) by(success) casewise

*******************************


* Table 4 is a table of 
* variables, and therefore
* not reproduced


*******************************


/* CALCULATIONS OF THE IMPLICATIONS*/
/* generate covariance terms for integration below */

scalar crh_ev = (exp(2*c_est[1,59])-1)/(exp(2*c_est[1,59])+1)
scalar csig_e = exp(c_est[1,60])
scalar csig_nu = 1/abs(c_est[1,57])
scalar crh = (crh_ev/csig_e)*csig_nu
scalar csig_nu0 = sqrt((csig_nu)^2-(crh^2)*(csig_e^2))
scalar sig_e = exp(c_est[1,60])

/* coefficients for the application cost function */

local j = 1
local i = 29
while `j' <28  { 
gen c_`j' = -(1/isignu)*c_est[1,`i']+c_est[1,`j']
local j = `j'+1
local i = `i'+1
} 
gen c_28 = -(1/isignu)*c_est[1,56]
gen c_29 = -(1/isignu)*c_est[1,58]+c_est[1,28]

*******************************


* Table 6


*******************************

* Table 6 in TTT_REStat
* c_1 is coefficient of Age
* c_2 is coefficient of Age sq.
* c_3 is coefficient of log of employment
* c_4 is coefficient of Ln(emp) sq.
* c_5 is coefficient of sales/employee
* c_6 is coefficient of sales/empl sq.
* c_7 is coefficient of parent company
* c_8 is coefficient of #previous applications
* c_9 is coefficient of #previous applications sq.
* c_10 is coefficient of CEO also chairman
* c_11 is coefficient of Board size
* c_12 is coefficient of Exporter
* c_28 is coefficient of SME
* c_29 is coefficient of Constant

sum c_*

*******************************


* Table 8


*******************************

* Table 8 in TTT_REStat
* csig_e is on row 1 in Table 8
* sig_eta is on row 2 in Table 8
* csignu0 is on row 3 in Table 8
* 1 + abs(crh) is on row 4 in Table 8
* crh_ev is on row 5 in Table 8
scalar list



/* generate application costs assuming zero values for unobservables */
gen ytheta = c_1*ika+c_2*ika2+c_3*lnhlo+c_4*lnhlo2+c_5*lvh+c_6*lvh2+ /*
*/c_7*emo_y+c_8*hak_aik+c_9*hak_aik2+c_10*tj_pj+c_11*hallkoko+c_12*exporter+ /*
*/c_13*food+c_14*paper+c_15*chemi+c_16*rubber+c_17*metals+c_18*electric+c_19*radiotv+ /*
*/c_20*otherman+c_21*telecom+c_22*datapro+c_23*r_d+c_24*laani02+c_25*laani03+/*
*/c_26*laani04+c_27*laani056+c_28*sme + c_29
gen eappcost = exp(ytheta)


* numerical integration over error term distribution(s)
* use this to produce column 1 results in Table 9
qui do "integ_hak_TTT1_REStat.do"
* use this to produce column 2 results in Table 9
*qui do "integ_hak_ML_TTT1_REStat.do"

*replace appcost_appl = f3unc`p'_appl if applicant== 1
local p = 100
gen dprof_s_hak =.
replace dprof_s_hak = f7unc`p'_hak if hakija== 1
/*marginal profitability of ln(R)*/
gen mprof_hak =.
replace mprof_hak = f2unc`p'_hak if hakija == 1
/*application costs*/
gen appcost_hak =.
replace appcost_hak = f3unc`p'_hak if hakija== 1
/*change in net profits due to actual subsidies*/
gen nprof_s_hak = .
replace nprof_s_hak = f6unc`p'_hak if hakija== 1

qui do "integ_Vpos_TTT1_REStat.do" /* needed to calc expected Z*delta + eta for those capped by the upper bound */
gen g_e = 0.2
local p = 100
gen ev_0_s_hak = (tukint+func_`p'+ g_e)*mprof_hak
gen ev_s = ev_0_s_hak/(1-tukint)
gen ev_d_s = ev_0_s_hak*(tukint/(1-tukint))

*******************************


* Table 9


*******************************
* Table 9 in TTT_REStat, rows 1, 2, & 4
tabstat dprof* nprof* ev_d_s if tukint> 0, stat(p50 mean n)
* Table 9 in TTT_REStat, row 3
tabstat appcost* , stat(p50 mean n)

log close
exit
