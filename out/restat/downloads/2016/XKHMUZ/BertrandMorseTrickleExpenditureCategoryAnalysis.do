********************************
* BERTRAND AND MORSE, REVEIW OF ECONOMICS & STATISTICS 
*"TRICKLE-DOWN CONSUMPTION"
**
* CODE FOR THE EXPENDITURE CATEGORIES ANALYSIS.*
*****FIGURE 1 OF THE PAPER
*****INTERNET APPENDIX TABLES 9 & 10
***DATA CONSUMPTION CATEGORIES CORRESPOND TO COLUMN 1 OF INTERNET APPENDIX TABLE 1
********************************
*
clear all
set more off

use BertrandMorseTrickleCEXData
macro define controls "age_ref agesq i.sex_ref dracenew* i.educ1  num_child_i* num_adult_i*  "


*trickle by category: ols p80
xi:areg lnexpense_erikcat1 lnma3_p80 $controls  i.year i.state*year unemployed  if  ave_inc<p80 [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9Levelsols80_erik , bdec(3) 3aster br se replace
gen levols80beta1=_b[lnma3_p80]
gen levols80se1=_se[lnma3_p80]


foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14  15{
display "`v'"
xi:areg lnexpense_erikcat`v' lnma3_p80 $controls i.year i.state*year unemployed  if  ave_inc<p80  [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9Levelsols80_erik, bdec(3) 3aster br se append
gen levols80beta`v'=_b[lnma3_p80]
gen levols80se`v'=_se[lnma3_p80]
}

*trickle by category: iv totexp_80p

xi:ivregress liml lnexpense_erikcat1 (lnma3_totexp_80100 = lnma3_p80  lnma3_p95 )  $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9Levelsivexp80_erik, bdec(3) 3aster br se replace  
gen levivexp80beta1=_b[lnma3_totexp_80100]
gen levivexp80se1=_se[lnma3_totexp_80100]

foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
display "`v'"
xi:ivregress liml lnexpense_erikcat`v' (lnma3_totexp_80100 = lnma3_p80  lnma3_p95 )   $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9Levelsivexp80_erik, bdec(3) 3aster br se append  
gen levivexp80beta`v'=_b[lnma3_totexp_80100]
gen levivexp80se`v'=_se[lnma3_totexp_80100]

}


*trickle by category: ols p90
xi:areg lnexpense_erikcat1 lnma3_p90 $controls  i.year i.state*year unemployed  if  ave_inc<p80 [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9Levelsols90_erik , bdec(3) 3aster br se replace 
gen levols90beta1=_b[lnma3_p90]
gen levols90se1=_se[lnma3_p90]


foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
display "`v'"
xi:areg lnexpense_erikcat`v' lnma3_p90 $controls  i.year i.state*year unemployed  if  ave_inc<p80  [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9Levelsols90_erik, bdec(3) 3aster br se append
gen levols90beta`v'=_b[lnma3_p90]
gen levols90se`v'=_se[lnma3_p90]
}

*trickle by category: iv totexp_90p

xi:ivregress liml lnexpense_erikcat1 (lnma3_totexp_90100 =   lnma3_p95 )   $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9Levelsivexp90_erik, bdec(3) 3aster br se replace
gen levivexp90beta1=_b[lnma3_totexp_90100]
gen levivexp90se1=_se[lnma3_totexp_90100]

foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
display "`v'"
xi:ivregress liml lnexpense_erikcat`v' (lnma3_totexp_90100 =   lnma3_p95 )   $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9Levelsivexp90_erik, bdec(3) 3aster br se append
gen levivexp90beta`v'=_b[lnma3_totexp_90100]
gen levivexp90se`v'=_se[lnma3_totexp_90100]
}


*trickle by category: ols p80
xi:areg ww_1 lnma3_p80 $controls lndcpi* lnlocalcpi i.year i.state*year unemployed  if  ave_inc<p80 [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9ols80_erik , bdec(3) 3aster br se replace
gen ols80beta1=_b[lnma3_p80]
gen ols80se1=_se[lnma3_p80]


foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
display "`v'"
xi:areg ww_`v' lnma3_p80 lndcpi* lnlocalcpi $controls lndcpi* lnlocalcpi i.year i.state*year unemployed  if  ave_inc<p80  [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9ols80_erik, bdec(3) 3aster br se append
gen ols80beta`v'=_b[lnma3_p80]
gen ols80se`v'=_se[lnma3_p80]
}

*trickle by category: iv totexp_80p

xi:ivregress liml ww_1 (lnma3_totexp_80100 = lnma3_p80  lnma3_p95 )  lndcpi* lnlocalcpi lndcpi* lnlocalcpi $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9ivexp80_erik, bdec(3) 3aster br se replace
gen ivexp80beta1=_b[lnma3_totexp_80100]
gen ivexp80se1=_se[lnma3_totexp_80100]

foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
display "`v'"
xi:ivregress liml ww_`v' (lnma3_totexp_80100 = lnma3_p80  lnma3_p95 )  lndcpi* lnlocalcpi lndcpi* lnlocalcpi $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9ivexp80_erik, bdec(3) 3aster br se append
gen ivexp80beta`v'=_b[lnma3_totexp_80100]
gen ivexp80se`v'=_se[lnma3_totexp_80100]
}



*trickle by category: ols p90
xi:areg ww_1 lnma3_p90 lndcpi* lnlocalcpi $controls lndcpi* lnlocalcpi i.year i.state*year unemployed  if  ave_inc<p80 [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9ols90_erik , bdec(3) 3aster br se replace
gen ols90beta1=_b[lnma3_p90]
gen ols90se1=_se[lnma3_p90]


foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
display "`v'"
xi:areg ww_`v' lnma3_p90 lndcpi* lnlocalcpi $controls lndcpi* lnlocalcpi i.year i.state*year unemployed  if  ave_inc<p80  [aweight=weight],absorb(inc_bucket) cluster(state)
outreg using A9ols90_erik, bdec(3) 3aster br se append
gen ols90beta`v'=_b[lnma3_p90]
gen ols90se`v'=_se[lnma3_p90]
}

*trickle by category: iv totexp_90p

xi:ivregress liml ww_1 (lnma3_totexp_90100 =   lnma3_p95 )  lndcpi* lnlocalcpi  $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9ivexp90_erik, bdec(3) 3aster br se replace
gen ivexp90beta1=_b[lnma3_totexp_90100]
gen ivexp90se1=_se[lnma3_totexp_90100]

foreach v in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
display "`v'"
xi:ivregress liml ww_`v' (lnma3_totexp_90100 =   lnma3_p95 )  lndcpi* lnlocalcpi  $controls i.year i.inc_bucket i.state*year unemployed   if   ave_in<p80  [aweight = weight], cluster(state)
outreg using A9ivexp90_erik, bdec(3) 3aster br se append
gen ivexp90beta`v'=_b[lnma3_totexp_90100]
gen ivexp90se`v'=_se[lnma3_totexp_90100]
}

******************

*Weighted averges
foreach v in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 {
gen ww_`v'b=ww_`v'
replace ww_`v'b=. if ave_inc>=p80
gen w_ww_`v'b=weight*ww_`v'b
egen ss`v'=sum(w_ww_`v'b)
gen weight`v'b=weight
replace weight`v'b=. if w_ww_`v'b==. 
egen sw`v'=sum(weight`v'b)
gen mww`v'= ss`v'/sw`v'
}

keep  ols*beta* ols*se* mww*  iv* lev*
 
duplicates drop 
gen ones=1

reshape long ols80beta ols80se  ivexp80beta ivexp80se ols90beta ols90se  ivexp90beta ivexp90se levols80beta levols80se  levivexp80beta levivexp80se levols90beta levols90se  levivexp90beta levivexp90se mww , i(ones) j(category)

merge 1:1 category using elasticityall_erik
drop _m

merge 1:1 category using visibility_erik
drop _m

	
gen categoryname=""
#delimit ;
replace categoryname="Clothing/Jewelry" if category==1;
replace categoryname="Housing" if category==2;
replace categoryname="Food at home" if category==3;
replace categoryname="Food away" if category==4;
replace categoryname="Alcohol tobacco" if category==5;
replace categoryname="Personal Care" if category==6;
replace categoryname="Communication services" if category==7;
replace categoryname="Entertainment services" if category==8;
replace categoryname="Utilities" if category==9;
replace categoryname="Other Transportation" if category==10;
replace categoryname="Health & Education" if category==11;
replace categoryname="Other nondurables" if category==12;
replace categoryname="Home Furnishings" if category==13;
replace categoryname="Entertainment Durables" if category==14;
replace categoryname="Vehicles" if category==15;
#delimit cr

foreach var in  ols80   ivexp80 ols90   ivexp90 {
gen weight_`var'=1/(`var'se^2)
gen rat`var'=`var'beta/mww
}

*OUTPUT FOR INTERNET APPENDIX TABLE 9 , PANEL B

table category, c(m visibil m elasti m mww m rativexp80 m rativexp90)
label var visi "Visibility"
label var elas "Elasticity"
label var ratols80 "Estimated Coefficient (Log 80 Pctile Income)/Budget Share"
label var rativexp80 "Estimated Coefficient (IV Rich Consumption)/Budget Share"

label var ratols90 "Estimated Coefficient (Log 90 Pctile Income)/Budget Share"
label var rativexp90 "Estimated Coefficient (IV Very Rich Consumption)/Budget Share"

*FIGURE 1
twoway  (lfit  visibility rativexp80) (scatter visibility rativexp80, ytitle(Visibility) xtitle(Estimated Coefficient (IV Rich Consumption)/Budget Share) sort mlabel(categoryname) mlabposition(5)), ylabel(.2(.1).8, format(%9.1f))  xlabel(-.75(.25)1.25, format(%9.2f)) xmtick(, format(%9.1f)) scheme(s2mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(white))  name(erikivexp80_vis, replace) legend(off)
twoway (lfit  elasticity rativexp80) (scatter elasticity rativexp80, ytitle(Elasticity) xtitle(Estimated Coefficient (IV Rich Consumption)/Budget Share)sort mlabel(categoryname) mlabposition(5)), ylabel(0.1(.1).9, format(%9.1f))  xlabel(-.75(.25)1.25, format(%9.2f)) xmtick(, format(%9.1f)) scheme(s2mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(white))  name(erikivexp80_elas, replace) legend(off)
reg visibility rativexp80
reg elasticity rativexp80


