
********************************************************************************************************
*SKILL SPECIFICITY AND ATTITUDES TOWARDS IMMIGRATION, by Sergi Pardos-Prado and Carla Xena-Galindo     *
*                                                                                                      *
*Syntax file to reproduce 'CROSS-NATIONAL ANALYSIS' section, using "European_social_survey.dta" dataset*
*                                                                                                      *
*Software used: Stata MP version 14                                                                    *
********************************************************************************************************


***********************************************
*CODING AND RECODING VARIABLES BEFORE ANALYSIS*
***********************************************

findit plottig /*to find and install Bischoff's graph schemes for graph layouts, if not installed yet*/

set scheme plottig /*once 'plottig' graph schemes have been installed*/

capture drop index 
gen index=imbgeco+imueclt+imwbcnt /*generating dependent variable as additive index of immigration attitudes*/
replace index=-index /*recoding dependent variable to range from positive to negative attitudes towards immigration*/

* Creating "skill specificity" variables 
capture drop x isco_str group length totgroup totworkforce numerator denominator iscosklevel
gen x=1 if isco!=.
tostring isco, gen(isco_str)
gen group= substr(isco_str, 1,1)
gen length=length(isco_str)
replace group="0" if length==3 
bysort country_ess essround group: egen totgroup = total(x) if x != .
*total N per group, country, wave
tab totgroup if group == "1" & country_ess == "AT" & essround == 1
bysort country_ess essround: egen totworkforce = total(x) if x != .
*total N (workforce) per country, wave
gen numerator = 0.08 if group == "1" 
replace numerator = 0.14 if group == "2"
replace numerator = 0.19 if group == "3"
replace numerator = 0.06 if group == "4" | group == "5" | group == "9"
replace numerator = 0.04 if group == "6"
replace numerator = 0.18 if group == "7" | group == "8" 
replace numerator = 0.003 if group == "0" 

/* Brief explanation on numerator:
For example, 'plant & machine operators and assemblers' (ISCO major group 8), contains 70 unit groups. 

Total unit groups (for 10 major groups) is 390 --> 70/390=0.18  
(see http://www.ilo.org/public/english/bureau/stat/isco/isco88/publ3.htm)*/

gen denominator = totgroup/totworkforce
capture drop skillsp
gen skillsp = (numerator/denominator)
* skillsp is average skill specialisation within major group: 'baseline' measure (a.k.a 'absolute skill specificity')

/* Notes: 
1. ILO does not assign an "ISCO skill-level" to ISCO88-1d group "1" (Legislators, senior officials, managers). 
Iversen & Soskice assign the highest "ISCO skill-level" (4) to this group. 
This measure is reffered to in Iversen & Soskice (APSR 2001) as "ISCO level of skills"
2. ILO does not assign an "ISCO skill-level" to ISCO88 group "0" (Armed Forces).*/

gen iscosklevel = 4 if group == "1" | group == "2" 
replace iscosklevel = 3 if group == "3"
replace iscosklevel = 2 if group == "4" | group == "5" | group == "6" | group == "7" | group == "8"
replace iscosklevel = 1 if group == "9" 
replace iscosklevel =. if group == "0" 

capture drop skill1
gen skill1 = skillsp/iscosklevel if iscosklevel !=. & skillsp !=.
*skill1: relative to ISCO 4levels

capture drop skill2
gen skill2 = skillsp/edulvla if edulvla !=. & skillsp !=. & group != "0" 
*skill2: relative to education

drop x isco_str group length totgroup totworkforce numerator denominator iscosklevel

* Create "% immigration" variable
capture drop  isco88 isco88_2dg isco88_3dg percentimmigr 
capture drop parentsborn nativeno nativeparentsno tot_nativeno tot_nativeparentsno percentparentsimmigr


/* 

Three recoded variables from original ESS data

1. Variable "borncntry" is a recoded version of the original "brncntr" variable in the ESS database:
gen borncntry = 0 if brncntr == 2
replace borncntry = 1 if brncntr == 1
Where individuals not born in the country are assigned a "0", and individuals born in the country are assigned a "1".

2. Variable "bornfather" is a recoded version of the original "facntr" variable in the ESS database:
gen bornfather = 0 if facntr == 2
replace bornfather = 1 if facntr == 1
Where individuals where father was not born in the country are assigned a "0", and individuals where father was born in the country are assigned a "1".

3. Variable "bornmother" is a recoded version of the original "mocntr" variable in the ESS database:
gen bornmother = 0 if mocntr == 2
replace bornmother = 1 if mocntr == 1
Where individuals where mother was not born in the country are assigned a "0", and individuals where mother was born in the country are assigned a "1".
*/

*Variable indicating that both parents were born in country
gen parentsborn=.
replace parentsborn = 1 if bornfather == 1 & bornmother == 1
replace parentsborn = 0 if bornfather == 0 & bornmother == 0 
replace parentsborn = 1 if bornfather == 0 & bornmother == 1 | bornfather == 1 & bornmother == 0
tab parentsborn
lab var parentsborn "both parents born in country"
lab var borncntry "individual born in country"
** Create ISCO variables **
tostring iscoco, gen(isco88)
gen isco88_2dg = substr(isco88, 1, 2)
destring isco88_2dg, replace
*isco variable with 2 digit groups
gen isco88_3dg = substr(isco88, 1, 3)
destring isco88_3dg, replace
*isco variable with 3 digit groups
* For a definition of major groups see http://www.ilo.org/public/english/bureau/stat/isco/isco88/major.htm *
** Create immigration variables (3 digits)**
bysort isco88_3dg country_ess essround: egen nativeno = total(borncntry)
bysort isco88_3dg country_ess essround: egen nativeparentsno = total(parentsborn)
bysort isco88_3dg country_ess essround: egen tot_nativeno = count(borncntry)
bysort isco88_3dg country_ess essround: egen tot_nativeparentsno = count(parentsborn)
lab var nativeno "total non-immigrants per country/round & isco group 3 digits"
lab var nativeparentsno "total non-immigrant parents per country/round & isco group 3 digits"
** Create ISCO & immigration variables (3 digits) **
* Variable as a % of immigrants within each ISCO group (3 digits) *
gen percentimmigr = ((tot_nativeno-nativeno)/tot_nativeno)*100
gen percentparentsimmigr = ((tot_nativeparentsno-nativeparentsno)/tot_nativeparentsno)*100
lab var percentimmigr "% immigrants by country/round & isco group 3 digits"
lab var percentparentsimmigr "% immigrant parents by country/round & isco group 3 digits"

* Creating final auxiliary variables
encode country_ess, gen(numcountry) /*generating country dummies*/
tab essround, generate(dum) /*generating ESS wave dummies*/
capture drop missing /*generating missing variable count to use only cases with valid observations across all variables*/
egen missing=rmiss(skillsp our manualwork income unempl7 eduyrs rlgdgr agea gndr lrscale stfgov stfeco foreign gdp unemployment eprc_v1 ept_v1 unemployment_sp percentimmigr)

* Centering all independent variables around their grand mean to use in hierarchical models:
foreach x of varlist skillsp skill1 skill2 our percentimmigr manualwork income unempl7  eduyrs rlgdgr agea gndr lrscale stfgov stfeco foreign gdp unemployment eprc_v1 ept_v1 unemployment_sp {
sum `x', d
gen `x'_cent=`x'-r(mean)
}

* Logging variables
gen log_gdp=log(gdp_cent) /*logarithm of country-year GDP*/
gen log_unemplsp=log(unemployment_sp_cent) /*logarithm of country-year spending on unemployment policy*/



*********
*TABLE 1*
*********

mixed index skillsp_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store m1

mixed index our_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store m2

mixed index skillsp_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store m3

mixed index our_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store m4

*FIGURES 1A AND 1B INVOLVE CHANGING THE DATASET INTO SIMULATED COEFFICIENTS AND THE CODE IS PROVIDED AT THE END OF THIS DO-FILE


***********
*FIGURE 2A*
***********

mixed index c.skillsp_cent##c.eduyrs_cent manualwork_cent income_cent unempl7_cent  rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 ///
 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store educ1



capture drop MV conb conse a upper lower
generate MV=_n-13
replace MV=. if MV>44

label var MV"Education"



matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a





graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("Education (centred)", size(6)) xlabel(-12(10)44, labsize(3.5)) ylabel(-0.2 3, labsize(3.5) axis(1)) fcolor(gs6) ytitle(Effect Skill Specificity, size(6))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity eduyrs_cent, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density education, size(6) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2))

***********
*FIGURE 2B*
***********


mixed index c.our_cent##c.eduyrs_cent manualwork_cent income_cent unempl7_cent  rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 ///
 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store educ2



capture drop MV conb conse a upper lower
generate MV=_n-13
replace MV=. if MV>44

label var MV"Education"



matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a


graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("Education (centred)", size(6)) xlabel(-12(10)44, labsize(2.5)) ylabel(-0.2 3, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Occupational Unemployment, size(6))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity eduyrs_cent, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density education, size(6) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2)) 


***********
*FIGURE 3A*
***********

mixed index c.skillsp_cent##c.income_cent manualwork_cent  eduyrs_cent unempl7_cent  rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 ///
 || _all: R.essround || _all: numcountry || isco:, mle variance
estat ic
est store inc1




est restore inc1
capture drop MV conb conse a upper lower
generate MV=_n-6
replace MV=. if MV>7
label var MV"Income"
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]
gen conb=b1+b3*MV
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("Income (centred)", size(6)) xlabel(-5(1)7, labsize(2.5)) ylabel(-0.1 0.7, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Skill Specificity, size(6))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity income_cent, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density income, size(6) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2))


***********
*FIGURE 3B*
***********

mixed index c.our_cent##c.income_cent manualwork_cent  eduyrs_cent unempl7_cent  rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 ///
 || _all: R.essround || _all: numcountry || isco:, mle variance
estat ic
est store inc2


est restore inc2
capture drop MV conb conse a upper lower
generate MV=_n-6
replace MV=. if MV>7
label var MV"Income"
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]
gen conb=b1+b3*MV
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a


graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("Income (centred)", size(6)) xlabel(-5(1)7, labsize(2.5)) ylabel(-0.1 0.2, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Occupational Unemployment, size(5))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity income_cent, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density income, size(6) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2)) 



***********
*FIGURE 4A*
***********

mixed index c.skillsp_cent##c.percentimmigr_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent  log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 ///
 || _all: R.essround || _all: numcountry || isco:, mle variance

 est store imm1



est restore imm1
capture drop MV conb conse a upper lower
generate MV=_n-9
replace MV=. if MV>91
label var MV"% immigrants in occupation"
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]
gen conb=b1+b3*MV
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a



graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("% migrants in ISCO group (centred)", size(6)) xlabel(-9(20)91, labsize(2.5)) ylabel(-0.1 3, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Skill Specificity, size(6))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity percentimmigr_cent, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density % migrants, size(6) axis(2)) ylabel(0 0.1, labsize(2.5) axis(2)) 


***********
*FIGURE 4B*
***********
 
mixed index c.our_cent##c.percentimmigr_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent  foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 ///
|| _all: R.essround || _all: numcountry || isco:, mle variance

 est store imm2
 
est restore imm2
capture drop MV conb conse a upper lower
generate MV=_n-9
replace MV=. if MV>91
label var MV"% immigrants in occupation"
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]
gen conb=b1+b3*MV
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a


graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("% migrants in ISCO group (centred)", size(6)) xlabel(-9(20)91, labsize(2.5)) ylabel(-0.5 0.5, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Occupational Unemployment, size(5))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity percentimmigr_cent, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density % migrants, size(6) axis(2)) ylabel(0 0.1, labsize(2.5) axis(2)) 




*********************
***ONLINE APPENDIX***
*********************

**********
*TABLE A1*
**********


sum index skillsp skill1 skill2 manualwork income unempl7 eduyrs rlgdgr agea gndr lrscale stfgov stfeco foreign gdp unemployment ///
eprc_v1 ept_v1 unemployment_sp if missing==0, format



**********
*TABLE A2*
**********
pwcorr skillsp our eduyrs income if missing==0, sig




**********
*TABLE A3*
**********


oneway skillsp edulvla if missing==0, tab bonferroni

**********
*TABLE A4*
**********

xtile incometile = income, nquantiles(5)

oneway skillsp incometile if missing==0, tab bonferroni

**********
*TABLE A5*
**********

oneway our edulvla if missing==0, tab bonferroni

**********
*TABLE A6*
**********

oneway our incometile if missing==0, tab bonferroni




**********
*TABLE A7*
**********

mixed index skill1_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store alt1


mixed index skill2_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store alt2



************
*TABLE A7.1*
************

* Create factor *

factor imbgeco imueclt imwbcnt
rotate, oblimin
predict factor
replace factor = factor*-1 if factor != . /* Factor recoded for ease of interpretation */



mixed factor skillsp_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent percentimmigr_cent  ///
foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic

mixed factor our_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent percentimmigr_cent ///
foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic



**********
*TABLE A8*
**********

gen temporary=wrkctra==2


mixed index skillsp_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent temporary union percentimmigr_cent socialspend labour_sp epr_v1 trade_openess if missing==0 ///
 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store robust4


mixed index our_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent temporary union percentimmigr_cent socialspend labour_sp epr_v1 trade_openess if missing==0 ///
 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store robust5



**********
*TABLE A9*
**********

mixed index our_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent if missing==0 || numcountry:isco88_2dg, mle variance
estat ic


  
***********
*TABLE A10*
***********

mixed stfeco skillsp_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic 
est store econ1

mixed stfeco our_cent manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent percentimmigr_cent ///
foreign_cent log_gdp unemployment_cent eprc_v1_cent ept_v1_cent log_unemplsp if missing==0 || _all: R.essround || _all: R.numcountry|| isco:, mle variance
estat ic
est store econ2


*******************
*FIGURE 1 APPENDIX*
*******************

mixed index c.skillsp_cent##c.eduyrs_cent manualwork_cent income_cent unempl7_cent  rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 & eduyrs<31 ///
 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store educ_below1


capture drop MV conb conse a upper lower
generate MV=_n-13
replace MV=. if MV>18

label var MV"Education"



matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a





graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("Education (centred)", size(small)) xlabel(-12(10)18, labsize(2.5)) ylabel(-0.2 3, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Skill Specificity, size(3))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity eduyrs_cent if eduyrs_cent<18, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density education, size(3) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2))

 
*******************
*FIGURE 2 APPENDIX*
*******************

mixed index c.our_cent##c.eduyrs_cent manualwork_cent income_cent unempl7_cent  rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 & eduyrs<31 ///
 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store educ_below2

est restore educ_below2


capture drop MV conb conse a upper lower
generate MV=_n-13
replace MV=. if MV>18

label var MV"Education"



matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

gen conb=b1+b3*MV

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)

gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("Education (centred)", size(small)) xlabel(-12(10)18, labsize(2.5)) ylabel(-0.2 3, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Occupational Unemployment, size(3))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity eduyrs_cent if eduyrs_cent<18, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density education, size(3) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2))



*******************
*FIGURE 3 APPENDIX*
*******************

forvalues x=1(1)6{
bysort country_ess isco88_3dg: gen immocc`x' = percentimmigr_cent if essround==`x'
}

forvalues x=1(1)6{
egen immoc_good`x' = mode(immocc`x'), by(numcountry isco88_3dg)
}

gen immoccdiff=.
replace immoccdiff=immoc_good2-immoc_good1 if essround==2
replace immoccdiff=immoc_good3-immoc_good2 if essround==3
replace immoccdiff=immoc_good4-immoc_good3 if essround==4
replace immoccdiff=immoc_good5-immoc_good4 if essround==5
replace immoccdiff=immoc_good6-immoc_good5 if essround==6

help mode

mixed index c.skillsp_cent##c.immoccdiff manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent  gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 ///
 || _all: R.essround || _all: R.numcountry || isco:, mle variance

 est store immdiff1



est restore immdiff1
capture drop MV conb conse a upper lower
generate MV=_n-101
replace MV=. if MV>100
label var MV"change in % immigrants in occupation"
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]
gen conb=b1+b3*MV
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a


graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("change % migrants in ISCO group", size(small)) xlabel(-100(20)100, labsize(2.5)) ylabel(-0.5 1.5, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Skill Specificity, size(3))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity immoccdiff, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density change % migrants, size(3) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2)) 



*******************
*FIGURE 4 APPENDIX*
*******************


mixed index c.our_cent##c.immoccdiff manualwork_cent income_cent unempl7_cent eduyrs_cent rlgdgr_cent agea_cent gndr_cent lrscale_cent stfgov_cent stfeco_cent  foreign_cent gdp_cent unemployment_cent eprc_v1_cent ept_v1_cent unemployment_sp_cent if missing==0 ///
|| _all: R.essround || _all: R.numcountry|| isco:, mle variance

 est store immdiff2

est restore immdiff2
capture drop MV conb conse a upper lower
generate MV=_n-101
replace MV=. if MV>100
label var MV"change in % immigrants in occupation"
matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]
gen conb=b1+b3*MV
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV)
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

graph twoway (scatter conb MV, yaxis(1) msymbol(circle) msize(small) mcolor(black) yline(0)  ///
 graphregion(color(white)) ///
 xtitle("change % migrants in ISCO group", size(small)) xlabel(-100(20)100, labsize(2.5)) ylabel(-0.3 0.3, labsize(2.5) axis(1)) fcolor(gs6) ytitle(Effect Occupational Unemployment, size(3))  legend(off)) ///
 (rcap lower upper MV, lcolor(black) vertical) || kdensity immoccdiff, yaxis(2) ///
 lpattern(solid) lstyle(minor_grid) lwidth(thin) ytitle(Density change % migrants, size(3) axis(2)) ylabel(0 0.2, labsize(2.5) axis(2)) 





*******************
*FIGURE 5 APPENDIX*
*******************


foreach x of varlist skillsp skill1 skill2 our percentimmigr manualwork income unempl7  eduyrs rlgdgr agea gndr lrscale stfgov stfeco foreign gdp unemployment eprc_v1 ept_v1 unemployment_sp {
sum `x', d
gen `x'_std=(`x'-r(mean))/r(sd)
}


gen log_gdp_std=log(gdp_std)
gen log_unemplsp_std=log(unemployment_sp_std)


mixed index skillsp_std manualwork_std income_std unempl7_std eduyrs_std rlgdgr_std agea_std gndr_std lrscale_std stfgov_std stfeco_std percentimmigr_std ///
foreign_std log_gdp_std unemployment_std eprc_v1_std ept_v1_std log_unemplsp_std if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store m5

coefplot, keep(skillsp_std manualwork_std income_std eduyrs_std) xline(0) xtitle(Standardized coefficients) ///
coeflabel(skillsp_std = "Skill specificity" manualwork_std = "Manual worker" income_std = "Income" eduyrs_std = "Education")

*******************
*FIGURE 6 APPENDIX*
*******************

mixed index our_std manualwork_std income_std unempl7_std eduyrs_std rlgdgr_std agea_std gndr_std lrscale_std stfgov_std stfeco_std percentimmigr_std ///
foreign_std log_gdp_std unemployment_std eprc_v1_std ept_v1_cent log_unemplsp_std if missing==0 || _all: R.essround || _all: R.numcountry || isco:, mle variance
estat ic
est store m6


coefplot, keep(our_std manualwork_std income_std eduyrs_std) xline(0) xtitle(Standardized coefficients) ///
coeflabel(our_std = "Occupational unemployment" manualwork_std = "Manual worker" income_std = "Income" eduyrs_std = "Education")


****************************************************
****************************************************

*********************************************************************************************************
*FIGURE 1A IN MAIN PAPER (DATASET WILL TURN INTO SIMULATED DRAW OF COEFFICIENTS SO PLEASE DON'T SAVE IT!*
*********************************************************************************************************


	est restore m3



	matrix list e(b)
	set seed 10000


	drawnorm MG_b1-MG_b23, n(10000) means(e(b)) cov(e(V)) clear

	gen betahat_skill1 = MG_b1*(32.69) + MG_b19
	gen betahat_skill2 = MG_b1*(-0.77) + MG_b19

	gen betahat_manual1 = MG_b2*(0.94) + MG_b19
	gen betahat_manual2 = MG_b2*(-0.06) + MG_b19

	gen betahat_income1 = MG_b3*(6.41) + MG_b19
	gen betahat_income2 = MG_b3*(-4.59) + MG_b19

	gen betahat_educ1 = MG_b5*(43.92) + MG_b19
	gen betahat_educ2 = MG_b5*(-12.08) + MG_b19


	forvalues i = 1(1)2 {
	egen mean_skill`i'=mean(betahat_skill`i')
	_pctile betahat_skill`i', p(2.5,97.5)
	scalar low_skill`i'=r(r1)
	gen lowbound_skill`i'=low_skill`i'
	_pctile betahat_skill`i', p(2.5,97.5)
	scalar high_skill`i'=r(r2)
	gen highbound_skill`i'=high_skill`i'
	}

	forvalues i = 1(1)2 {
	egen mean_manual`i'=mean(betahat_manual`i')
	_pctile betahat_manual`i', p(2.5,97.5)
	scalar low_manual`i'=r(r1)
	gen lowbound_manual`i'=low_manual`i'
	_pctile betahat_manual`i', p(2.5,97.5)
	scalar high_manual`i'=r(r2)
	gen highbound_manual`i'=high_manual`i'
	}

	forvalues i = 1(1)2 {
	egen mean_income`i'=mean(betahat_income`i')
	_pctile betahat_income`i', p(2.5,97.5)
	scalar low_income`i'=r(r1)
	gen lowbound_income`i'=low_income`i'
	_pctile betahat_income`i', p(2.5,97.5)
	scalar high_income`i'=r(r2)
	gen highbound_income`i'=high_income`i'
	}

	forvalues i = 1(1)2 {
	egen mean_educ`i'=mean(betahat_educ`i')
	_pctile betahat_educ`i', p(2.5,97.5)
	scalar low_educ`i'=r(r1)
	gen lowbound_educ`i'=low_educ`i'
	_pctile betahat_educ`i', p(2.5,97.5)
	scalar high_educ`i'=r(r2)
	gen highbound_educ`i'=high_educ`i'
	}

	gen diff_skill=mean_skill1 - mean_skill2
	gen diff_manual=mean_manual1 - mean_manual2
	gen diff_income=mean_income1 - mean_income2
	gen diff_educ=mean_educ1 - mean_educ2

	gen h_skill=highbound_skill1-highbound_skill2
	gen h_manual=highbound_manual1-highbound_manual2
	gen h_income=highbound_income1-highbound_income2
	gen h_educ=highbound_educ1-highbound_educ2

	gen l_skill=lowbound_skill1-lowbound_skill2
	gen l_manual=lowbound_manual1-lowbound_manual2
	gen l_income=lowbound_income1-lowbound_income2
	gen l_educ=lowbound_educ1-lowbound_educ2


	*Graph

	gen n=_n

	rename diff_skill diff1
	rename diff_manual diff2
	rename diff_income diff3
	rename diff_educ diff4

	rename l_skill low1
	rename l_manual low2
	rename l_income low3
	rename l_educ low4

	rename h_skill high1
	rename h_manual high2
	rename h_income high3
	rename h_educ high4

	keep n diff* low* high*

	drop if n>1

	reshape long diff low high, i(n) j(j)

	capture label drop j
	capture label define j 1"Skill specificity" 2"Working class" 3"Income" 4"Education"
	label val j j



	graph twoway (bar  diff j, ///
	 graphregion(color(white)) ///
	 ytitle("E(Y|Max(X))-E(Y|Min(X))", size(5)) ylabel(-20(5)25, labsize(small)) ///
	 xlabel(#4, valuelabel labsize(4)) fcolor(gs6) xtitle(j, color(white)) legend(off)) ///
	 (rcap low high j, lcolor(black))
  




*********************************************************************************************************
*FIGURE 1B IN MAIN PAPER (DATASET WILL TURN INTO SIMULATED DRAW OF COEFFICIENTS SO PLEASE DON'T SAVE IT!*
*********************************************************************************************************


	est restore m4



	matrix list e(b)
	set seed 10000


	drawnorm MG_b1-MG_b23, n(10000) means(e(b)) cov(e(V)) clear

	gen betahat_skill1 = MG_b1*(21.43) + MG_b19
	gen betahat_skill2 = MG_b1*(-5.94) + MG_b19

	gen betahat_manual1 = MG_b2*(0.94) + MG_b19
	gen betahat_manual2 = MG_b2*(-0.06) + MG_b19

	gen betahat_income1 = MG_b3*(6.41) + MG_b19
	gen betahat_income2 = MG_b3*(-4.59) + MG_b19

	gen betahat_educ1 = MG_b5*(44) + MG_b19
	gen betahat_educ2 = MG_b5*(-12) + MG_b19

	forvalues i = 1(1)2 {
	egen mean_skill`i'=mean(betahat_skill`i')
	_pctile betahat_skill`i', p(2.5,97.5)
	scalar low_skill`i'=r(r1)
	gen lowbound_skill`i'=low_skill`i'
	_pctile betahat_skill`i', p(2.5,97.5)
	scalar high_skill`i'=r(r2)
	gen highbound_skill`i'=high_skill`i'
	}

	forvalues i = 1(1)2 {
	egen mean_manual`i'=mean(betahat_manual`i')
	_pctile betahat_manual`i', p(2.5,97.5)
	scalar low_manual`i'=r(r1)
	gen lowbound_manual`i'=low_manual`i'
	_pctile betahat_manual`i', p(2.5,97.5)
	scalar high_manual`i'=r(r2)
	gen highbound_manual`i'=high_manual`i'
	}

	forvalues i = 1(1)2 {
	egen mean_income`i'=mean(betahat_income`i')
	_pctile betahat_income`i', p(2.5,97.5)
	scalar low_income`i'=r(r1)
	gen lowbound_income`i'=low_income`i'
	_pctile betahat_income`i', p(2.5,97.5)
	scalar high_income`i'=r(r2)
	gen highbound_income`i'=high_income`i'
	}

	forvalues i = 1(1)2 {
	egen mean_educ`i'=mean(betahat_educ`i')
	_pctile betahat_educ`i', p(2.5,97.5)
	scalar low_educ`i'=r(r1)
	gen lowbound_educ`i'=low_educ`i'
	_pctile betahat_educ`i', p(2.5,97.5)
	scalar high_educ`i'=r(r2)
	gen highbound_educ`i'=high_educ`i'
	}

	gen diff_skill=mean_skill1 - mean_skill2
	gen diff_manual=mean_manual1 - mean_manual2
	gen diff_income=mean_income1 - mean_income2
	gen diff_educ=mean_educ1 - mean_educ2

	gen h_skill=highbound_skill1-highbound_skill2
	gen h_manual=highbound_manual1-highbound_manual2
	gen h_income=highbound_income1-highbound_income2
	gen h_educ=highbound_educ1-highbound_educ2

	gen l_skill=lowbound_skill1-lowbound_skill2
	gen l_manual=lowbound_manual1-lowbound_manual2
	gen l_income=lowbound_income1-lowbound_income2
	gen l_educ=lowbound_educ1-lowbound_educ2


	*Graph

	gen n=_n

	rename diff_skill diff1
	rename diff_manual diff2
	rename diff_income diff3
	rename diff_educ diff4

	rename l_skill low1
	rename l_manual low2
	rename l_income low3
	rename l_educ low4

	rename h_skill high1
	rename h_manual high2
	rename h_income high3
	rename h_educ high4

	keep n diff* low* high*

	drop if n>1

	reshape long diff low high, i(n) j(j)

	capture label drop j
	capture label define j 1"Occup unemployment" 2"Working class" 3"Income" 4"Education"
	label val j j



	graph twoway (bar  diff j, ///
	 graphregion(color(white)) ///
	 ytitle("E(Y|Max(X))-E(Y|Min(X))", size(5)) ylabel(-18(5)13, labsize(small)) ///
	 xlabel(#4, valuelabel labsize(4)) fcolor(gs6) xtitle(j, color(white)) legend(off)) ///
	 (rcap low high j, lcolor(black))
	  
