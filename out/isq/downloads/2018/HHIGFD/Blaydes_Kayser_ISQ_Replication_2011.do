// Replication do-file for Blaydes & Kayser, ISQ 2011//
// Two accompanying datasets: (1) Blaydes_Kayser_GiniCalValidity_ISQ2011_Replication.dta and (2) Blaydes_Kayser_Calories_ISQ2011_Replication.dta


set mem 300m
set matsize 400



/*------------------------------------------*/
/*           	   Table 1		            */
/*------------------------------------------*/

* just summary statistics

/*------------------------------------------*/
/*           Table 2 (Validity)             */
/*------------------------------------------*/

use Blaydes_Kayser_GiniCalValidity_ISQ2011_Replication.dta, clear
set more off
reg gini calstotal lngdpcppp
est2vec val_table, e(r2 F) vars(calstotal lngdpcppp) name(Gini) replace
reg gini calstotal lngdpcppp if commie==0 & oil==0
est2vec val_table, addto(val_table) name(Gini_Small) replace

reg bottom20 calstotal lngdpcppp  
est2vec val_table, addto(val_table) name(Bot20) replace
reg bottom20 calstotal lngdpcppp if commie==0 & oil==0
est2vec val_table, addto(val_table) name(Bot20_Small) replace

reg top20 calstotal lngdpcppp
est2vec val_table, addto(val_table) name(Top20) replace
reg top20 calstotal lngdpcppp if commie==0 & oil==0
est2vec val_table, addto(val_table) name(Top20_Small) replace
est2tex val_table, mark(stars) preserve fancy dropall replace

/*--------------------------------------*/
/*          Figure 1 (Validity)         */
/*--------------------------------------*/

avplot calstotal
gr combine Quint1_All_Clean.gph Quint5_All_Clean.gph 



/*---------------------------------------------------------*/
/*							Table 3	   				       */
/*---------------------------------------------------------*/


use Blaydes_Kayser_Calories_ISQ2011_Replication.dta, clear
*gen authoritarian = polity3cat==0
*gen semidemoc = polity3cat ==1
*gen democ = polity3cat==2


******************* TOTAL CALORIES **************************
set more off
* (1.1) interaction, l.polityPOS*Growth, pooled
xi3: reg d_calstotal l.calstotal l.gdpcxr100 d_gdpcxr100*i.polity3cat  if groutlier==0, r
est2vec table_1, e(r2 N_g) vars(l.calstotal l.calsanimal d_gdpcxr100 l.gdpcxr100 _Ipolity3ca_1 _Ipolity3ca_2 _Id_Xpo1 _Id_Xpo2 _cons) name (Tot_NoFE) replace

* (1.2) interaction, l.polityPOS*Growth, fixed effects
xi3: xtreg d_calstotal l.calstotal l.gdpcxr100 d_gdpcxr100*i.polity3cat  if groutlier==0, fe r
est2vec table_1, addto(table_1) name(Tot_C_FE) replace


* (1.3) interaction, l.polityPOS*Growth, fixed effects (country & year)
xi3: xtreg d_calstotal l.calstotal l.gdpcxr100 d_gdpcxr100*i.polity3cat i.year if groutlier==0, fe r
est2vec table_1, addto(table_1) name(Tot_CY_FE) replace


******************* ANIMAL CALORIES **************************

* (1.1) interaction, l.polityPOS*Growth, pooled
xi3: reg d_calsanimal l.calsanimal l.gdpcxr100 d_gdpcxr100*i.polity3cat if groutlier==0, r
est2vec table_1, addto(table_1) name(An_NoFE) replace


* (1.2) interaction, l.polityPOS*Growth, fixed effects
xi3: xtreg d_calsanimal l.calsanimal l.gdpcxr100 d_gdpcxr100*i.polity3cat if groutlier==0, fe r
est2vec table_1, addto(table_1) name(An_C_FE) replace


* (1.3) interaction, l.polityPOS*Growth, fixed effects (country & year)
xi3: xtreg d_calsanimal l.calsanimal l.gdpcxr100 d_gdpcxr100*i.polity3cat i.year if groutlier==0, fe r
est2vec table_1, addto(table_1) name(An_CY_FE) replace
est2tex table_1, mark(stars) preserve fancy dropall replace






/*-----------------------------------------------------------*/
/*					Figure 2 (SHORT RUN)					 */
/*-----------------------------------------------------------*/

***********Total Cals*********

set more off
*gen regime = . 
gen SR = .
gen cihi = .
gen cilo = .

forvalues cat = 0/2 {

	tempvar row 
	tempvar se

	gen `row' = `cat'+1 //set the row number to record the results// 

	//specification order changed to enable use of same matrix below//
	capture xi3: xtreg d_calstotal d_gdpcxr100 hybrid d_gdpcxr100Xhybrid l.gdpcxr100 l.calstotal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==0, fe r
	capture xi3: xtreg d_calstotal d_gdpcxr100 hybrid d_gdpcxr100Xhybrid l.gdpcxr100 l.calstotal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==1, fe r
	capture xi3: xtreg d_calstotal d_gdpcxr100 democ d_gdpcxr100Xdemoc l.gdpcxr100 l.calstotal d_gdpcxr100Xhybrid hybrid if groutlier==0 & `cat'==2, fe r


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

	scalar list b1 b2 b3 varb1 varb3 covb1b3 covb2b3



	if `cat'==0 {
		replace SR = b1+b3*0 if _n==`row' //short-run effect//
		gen `se'=sqrt(varb1)
		replace cihi = SR + 1.96*`se' if _n==`row'
		replace cilo = SR - 1.96*`se' if _n==`row'
		*di "se = " `se'
		*di "cihi = " cihi
		*di "cilo = " cilo
	}

	if `cat'>0 {
		replace SR = b1+b3*(`cat'/`cat') if _n==`row' //short-run effect//
		gen `se'= sqrt(varb1 + varb3 + (2*covb1b3))
		replace cihi = SR + 1.96*`se' if _n==`row'
		replace cilo = SR - 1.96*`se' if _n==`row'
		*di "se = " `se'
		*di "cihi = " cihi
		*di "cilo = " cilo
	}

	replace regime = `cat' if _n==`row'

}

list SR cihi cilo regime in 1/5

graph twoway rspike cihi cilo regime, lcolor(black) xscale(range(-1 3)) xtick(0 1 2) xlabel(0(1)2 0 "autoc" 1"hybrid" 2"democ") /*
	*/ || scatter SR regime, mcolor(black) title("Total Calories") legend(off) xtitle(" ")

drop SR cihi cilo

gr save cals_total_SR_3cat, replace


/*---------Animal Cals SR Effects Plot--------------*/
set more off
*gen regime = . 
gen SR = .
gen cihi = .
gen cilo = .

forvalues cat = 0/2 {

	tempvar row 
	tempvar se

	gen `row' = `cat'+1 //set the row number to record the results// 

	//specification order changed to enable use of same matrix below//
	capture xi3: xtreg d_calsanimal d_gdpcxr100 hybrid d_gdpcxr100Xhybrid l.gdpcxr100 l.calsanimal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==0, fe r
	capture xi3: xtreg d_calsanimal d_gdpcxr100 hybrid d_gdpcxr100Xhybrid l.gdpcxr100 l.calsanimal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==1, fe r
	capture xi3: xtreg d_calsanimal d_gdpcxr100 democ d_gdpcxr100Xdemoc l.gdpcxr100 l.calsanimal d_gdpcxr100Xhybrid hybrid if groutlier==0 & `cat'==2, fe r


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

	scalar list b1 b2 b3 varb1 varb3 covb1b3 covb2b3



	if `cat'==0 {
		replace SR = b1+b3*0 if _n==`row' //short-run effect//
		gen `se'=sqrt(varb1)
		replace cihi = SR + 1.96*`se' if _n==`row'
		replace cilo = SR - 1.96*`se' if _n==`row'
		*di "se = " `se'
		*di "cihi = " cihi
		*di "cilo = " cilo
	}

	if `cat'>0 {
		replace SR = b1+b3*(`cat'/`cat') if _n==`row' //short-run effect//
		gen `se'= sqrt(varb1 + varb3 + (2*covb1b3))
		replace cihi = SR + 1.96*`se' if _n==`row'
		replace cilo = SR - 1.96*`se' if _n==`row'
		*di "se = " `se'
		*di "cihi = " cihi
		*di "cilo = " cilo
	}

	replace regime = `cat' if _n==`row'

}

list SR cihi cilo regime in 1/5

graph twoway rspike cihi cilo regime, lcolor(black) xscale(range(-1 3)) xtick(0 1 2) xlabel(0(1)2 0 "autoc" 1"hybrid" 2"democ") /*
	*/ || scatter SR regime, mcolor(black) title("Animal Calories") legend(off) xtitle(" ")

drop SR cihi cilo

gr save cals_animal_SR_3cat, replace

gr combine cals_total_SR_3cat.gph cals_animal_SR_3cat.gph




/*-----------------------------------------------------------*/
/*					Figure 3 (LONG RUN)						 */
/*-----------------------------------------------------------*/

***********Total Cals*********


*gen regime = . 
*gen TotEff = . 

forvalues cat = 0/2 {

	tempvar row 
	tempvar SR 
	tempvar LRM 

	gen `row' = `cat'+1 //set the row number to record the results// 

	//specification order changed to enable use of same matrix below//
	capture xi3: xtreg d_calstotal d_gdpcxr100 semidemoc d_gdpcxr100Xsemidemoc l.gdpcxr100 l.calstotal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==0, fe r
	capture xi3: xtreg d_calstotal d_gdpcxr100 semidemoc d_gdpcxr100Xsemidemoc l.gdpcxr100 l.calstotal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==1, fe r
	capture xi3: xtreg d_calstotal d_gdpcxr100 democ d_gdpcxr100Xdemoc l.gdpcxr100 l.calstotal d_gdpcxr100Xsemidemoc semidemoc if groutlier==0 & `cat'==2, fe r

	matrix b=e(b)

	scalar b1=b[1,1]
	scalar b2=b[1,2]
	scalar b3=b[1,3]
	scalar b4=b[1,4]
	scalar b5=b[1,5]

	scalar list b1 b2 b3 b4 b5


	if `cat'==0 {
		gen `SR' = b1+b3*0 //short-run effect//
		gen `LRM' = -(b4+b1+b3*0)/ (b5-1) //long run multiplier//
		di "SR = " `SR'
		di "LRM' = `LRM'
	}

	if `cat'>0 {
		gen `SR' = b1+b3*(`cat'/`cat') //short-run effect//
		gen `LRM' = -(b4+b1+b3*(`cat'/`cat'))/ (b5-1) //long run multiplier//
		di "SR = " `SR'
		di "LRM' = `LRM'
	}

	replace TotEff = `SR'*`LRM' if _n==`row' //total effect: short- and long-run//
	replace regime = `cat' if _n==`row'

}

list TotEff regime in 1/5

tempvar cutoff
gen `cutoff'=25

gen years =_n-1
gen autocracy = TotEff[1]*(1-(1+b5)^(_n-1)) if _n<=`cutoff'
gen semidemocracy = TotEff[2]*(1-(1+b5)^(_n-1)) if _n<=`cutoff'
gen democracy = TotEff[3]*(1-(1+b5)^(_n-1)) if _n<=`cutoff'

gr twoway line autocracy years if _n <=`cutoff', lpattern(l) lwidth(medium) lcolor(black) /*
	*/ || line semidemocracy years if _n <=`cutoff', lpattern(shortdash) lwidth(medium) lcolor(black)/*
	*/ || line democracy years if _n <=`cutoff', lpattern(dash) lwidth(medium) lcolor(black) title("Total Calories") legend(off)

gr save cals_total_LR_3cat, replace

drop autocracy semidemocracy democracy years





************Animal Cals************


*gen regime = . 
*gen TotEff = . 

forvalues cat = 0/2 {

	tempvar row 
	tempvar SR 
	tempvar LRM 

	gen `row' = `cat'+1 //set the row number to record the results// 

	//specification order changed to enable use of same matrix below//
	capture xi3: xtreg d_calsanimal d_gdpcxr100 semidemoc d_gdpcxr100Xsemidemoc l.gdpcxr100 l.calsanimal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==0, fe r
	capture xi3: xtreg d_calsanimal d_gdpcxr100 semidemoc d_gdpcxr100Xsemidemoc l.gdpcxr100 l.calsanimal d_gdpcxr100Xdemoc democ if groutlier==0 & `cat'==1, fe r
	capture xi3: xtreg d_calsanimal d_gdpcxr100 democ d_gdpcxr100Xdemoc l.gdpcxr100 l.calsanimal d_gdpcxr100Xsemidemoc semidemoc if groutlier==0 & `cat'==2, fe r

	matrix b=e(b)

	scalar b1=b[1,1]
	scalar b2=b[1,2]
	scalar b3=b[1,3]
	scalar b4=b[1,4]
	scalar b5=b[1,5]

	scalar list b1 b2 b3 b4 b5


	if `cat'==0 {
		gen `SR' = b1+b3*0 //short-run effect//
		gen `LRM' = -(b4+b1+b3*0)/ (b5-1) //long run multiplier//
	}

	if `cat'>0 {
		gen `SR' = b1+b3*(`cat'/`cat') //short-run effect//
		gen `LRM' = -(b4+b1+b3*(`cat'/`cat'))/ (b5-1) //long run multiplier//
	}

	replace TotEff = `SR'*`LRM' if _n==`row' //total effect: short- and long-run//
	replace regime = `cat' if _n==`row'

}

list TotEff regime in 1/5

tempvar cutoff
gen `cutoff'=25

gen years =_n-1
gen autocracy = TotEff[1]*(1-(1+b5)^(_n-1)) if _n<=`cutoff'
gen semidemocracy = TotEff[2]*(1-(1+b5)^(_n-1)) if _n<=`cutoff'
gen democracy = TotEff[3]*(1-(1+b5)^(_n-1)) if _n<=`cutoff'

gr twoway line autocracy years if _n <=`cutoff', lpattern(l) lwidth(medium) lcolor(black) /*
	*/ || line semidemocracy years if _n <=`cutoff', lpattern(shortdash) lwidth(medium) lcolor(black)/*
	*/ || line democracy years if _n <=`cutoff', lpattern(dash) lwidth(medium) lcolor(black) title("Animal Calories") legend(off)

gr save cals_animal_LR_3cat, replace

drop autocracy semidemocracy democracy years

gr combine cals_total_LR_3cat.gph cals_animal_LR_3cat.gph




/*----------------------------------------------*/
/*				TABLE 4	(Jackknife)				*/
/*----------------------------------------------*/

**************** TOTAL CALORIES ***************


xi3: xtreg d_calstotal l.calstotal l.gdpcxr100 d_gdpcxr100 semidemoc democ d_gdpcxr100Xsemidemoc d_gdpcxr100Xdemoc, fe r

xi: xtjack d_calstotal l.calstotal l.gdpcxr100  d_gdpcxr100 semidemoc democ d_gdpcxr100Xsemidemoc d_gdpcxr100Xdemoc i.cnum

set more off
forvalues y =1/177 {
display "omitted cnum is : " `y'
xi: xtreg d_calstotal l.calstotal l.gdpcxr100  d_gdpcxr100 semidemoc democ d_gdpcxr100Xsemidemoc d_gdpcxr100Xdemoc if cnum~=`y', fe r
}



/*----------------------------------------------*/
/*				TABLE 5	(Jackknife)				*/
/*----------------------------------------------*/
**************** ANIMAL CALORIES ***************


xi3: xtreg d_calsanimal l.calsanimal l.gdpcxr100  d_gdpcxr100 semidemoc democ d_gdpcxr100Xsemidemoc d_gdpcxr100Xdemoc, fe r

xi: xtjack d_calsanimal l.calsanimal l.gdpcxr100  d_gdpcxr100 semidemoc democ d_gdpcxr100Xsemidemoc d_gdpcxr100Xdemoc i.cnum

set more off
forvalues y =1/177 {
display "omitted cnum is : " `y'
xi: xtreg d_calsanimal l.calsanimal l.gdpcxr100  d_gdpcxr100 semidemoc democ d_gdpcxr100Xsemidemoc d_gdpcxr100Xdemoc if cnum~=`y', fe r
}
