*************************************************************************
* simulations: hausman-taylor, pretest, shrinkage
*************************************************************************

cd "c:\Users\Thomas\My Documents\My Dropbox\TI\MC\bwnknorm"
*cd c:\vera\tp\time_invariants\pa\comments\mc\ht\bwnknorm
clear all
version 11
mata:
void bmix (string scalar ivht, string scalar ivef, string scalar zx, real scalar N, real scalar T, real scalar obs, real scalar s2_e_12, real scalar s2_u_12)
{

	st_view(IVHT=.,.,ivht)
	st_view(IVEF=.,.,ivef)
	st_view(ZX=.,.,zx)
	XHT =  IVHT*(qrinv(IVHT)*ZX)
	XEF =  IVEF*(qrinv(IVEF)*ZX)
	XHT2 = XHT' * XHT
	XEF2 = XEF' * XEF
	D1=I(N)
	T1=J(T,1,1)
	D=D1#T1
	P=D*invsym(D'*D)*D'
	A=I(obs)
	Q=A-P
	O1=s2_e_12*Q+(s2_e_12+T*s2_u_12)*P
	S12=qrinv(XHT2) * (XHT' * O1 * XEF) * qrinv(XEF2)
	st_matrix("r(S12)", S12)

}
end


*************************************************************************
* 1. basic DGP: 2 time varying x, 2 completely time invariant z, x3 and z3 endogenous, mx1,  dx1 dx3, z1 instruments
*********************************************************************************************************************
*****************************************************************************************************************************************************************************************
*********************************************************************************************************************
* n=100, t=20
*********************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevd_z3 b_mixbwnk_z3 rhouz3 rhoumx1 using bwnk2_n100t20_z3unorm_mx1unorm_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/5000 {

	drop _all

	set obs 1000
	gen counter = _n



	tempvar c1 c1_1 c1_max c2 c2_1 c2_max c1_r c2_r 

	gen `c1'= 0.25*invnorm(uniform())
	replace `c1'=sqrt(`c1'^2)
	replace `c1'=. if `c1'>=0.8 
	gen `c2'= 0.25*invnorm(uniform())
	replace `c2'=sqrt(`c2'^2)
	replace `c2'=. if `c2'>=0.8
	gen `c1_1' = `c1' if counter==5
	gen `c2_1' = `c2' if counter==5
	replace `c1_1'=0 if `c1_1'==.
	replace `c2_1'=0 if `c2_1'==.
	egen `c1_max'=max(`c1_1')
	egen `c2_max'=max(`c2_1')
	gen `c1_r' = round(`c1_max',.01)
	gen `c2_r' = round(`c2_max',.01)
	local rhouz3 = `c1_r'	/*correlation between u and z3 */
	local rhoumx1 = `c2_r'  /*correlation between u and mx1 */


	drop _all
	local N 100
	local T 20
	local obs 2000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	

	local rhoz3mx1 0.5		/* korrelation zwischen z3 und x1*/

	scalar rhouz3 = `rhouz3'
	scalar rhoumx1 = `rhoumx1'

	
	set obs `N'
	gen csvar = _n


	matrix C = (1, `rhouz3', `rhoumx1' \ `rhouz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz3mx1', 1)
	drawnorm u z3 mx1, corr(C) n(`N') 

	drawnorm z1 mx3
	
	expand `T'
	sort csvar
	by csvar: gen date = _n
	
	tempvar x_1 x_3 mx_1 mx_3 dx1 dx3
	drawnorm `x_1' `x_3' e, n(`obs') 
	bysort csvar: egen  `mx_1'=mean(`x_1')
	bysort csvar: egen  `mx_3'=mean(`x_3')
	
	gen `dx1'=`x_1'-`mx_1'
	gen `dx3'=`x_3'-`mx_3'
	
	gen x1=mx1+`dx1'
	gen x3=mx3+`dx3'


	tsset csvar date
	gen con=1
	gen y = x1+x3+z1+z3+u+e

	
	xtreg y x1 x3 z1 z3, fe
	local s2_u_fe =(e(sigma_u))^2
	local s2_e_fe=(e(sigma_e))^2
	
	
	xtfevd y x1 x3 z1 z3, invariant(z1 z3)
	scalar b_fevd_x1=_b[x1]
	scalar b_fevd_z1=_b[z1]
	scalar b_fevd_z3=_b[z3]
	scalar b_fevd_x3=_b[x3]
	matrix FEVD=e(V)
	matrix FEVDZ3=FEVD[4,4]
	scalar FEVD_Z3=FEVDZ3[1,1]


	xtfevd y x1 x3 z1 z3, invariant(z1 z3) bwnk
	matrix BWNK=e(V)
	matrix BWNKZ3=BWNK[4,4]
	scalar BWNK_Z3=BWNKZ3[1,1]

	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]
	scalar b_ht_z1=_b[z1]
	scalar b_ht_x3=_b[x3]
	scalar b_ht_x1=_b[x1]
	local s2_u_ht =(e(sigma_u))^2
	local s2_e_ht=(e(sigma_e))^2
	matrix HT=e(V)
	matrix HTZ3=HT[4,4]
	scalar HT_Z3=HTZ3[1,1]
	scalar S11=HT_Z3
	
	scalar diff=b_fevd_z3-b_ht_z3
	scalar FEVD_Z3_bias=FEVD_Z3+diff^2
	scalar S22=FEVD_Z3_bias
	scalar BWNK_Z3_bias=BWNK_Z3+diff^2 
	scalar S22bwnk=BWNK_Z3_bias
	
	local s2_u_12=(`s2_u_fe'+`s2_u_ht')/2
	local s2_e_12=(`s2_e_fe'+`s2_e_ht')/2

	
	local ivht `dx1' `dx3' x1 z1 con
	local zx z1 z3 con x1 x3 
	local ivef `dx1' `dx3' x1 z1 z3 con
	
	mata: bmix ("`ivht'", "`ivef'", "`zx'", `N', `T', `obs', `s2_e_12', `s2_u_12')
	
	matrix S12=r(S12)
	scalar S12=S12[4,4]
	
	scalar w=(S22-S12)/(S11+S22-2*S12)
	scalar b_mixfevd_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	scalar w=(S22bwnk-S12)/(S11+S22bwnk-2*S12)
	scalar b_mixbwnk_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	
	post `HT1' (b_fevd_z3) (b_mixbwnk_z3) (rhouz3) (rhoumx1)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*********************************************************************************************************************
* n=300, t=20
*********************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevd_z3 b_mixbwnk_z3 rhouz3 rhoumx1 using bwnk2_n300t20_z3unorm_mx1unorm_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/5000 {

	drop _all

	set obs 1000
	gen counter = _n


	tempvar c1 c1_1 c1_max c2 c2_1 c2_max c1_r c2_r 

	gen `c1'= 0.25*invnorm(uniform())
	replace `c1'=sqrt(`c1'^2)
	replace `c1'=. if `c1'>=0.8 
	gen `c2'= 0.25*invnorm(uniform())
	replace `c2'=sqrt(`c2'^2)
	replace `c2'=. if `c2'>=0.8
	gen `c1_1' = `c1' if counter==5
	gen `c2_1' = `c2' if counter==5
	replace `c1_1'=0 if `c1_1'==.
	replace `c2_1'=0 if `c2_1'==.
	egen `c1_max'=max(`c1_1')
	egen `c2_max'=max(`c2_1')
	gen `c1_r' = round(`c1_max',.01)
	gen `c2_r' = round(`c2_max',.01)
	local rhouz3 = `c1_r'	/*correlation between u and z3 */
	local rhoumx1 = `c2_r'  /*correlation between u and mx1 */



	drop _all
	local N 300
	local T 20
	local obs 6000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	

	local rhoz3mx1 0.5		/* korrelation zwischen z3 und x1*/

	scalar rhouz3 = `rhouz3'
	scalar rhoumx1 = `rhoumx1'

	
	set obs `N'
	gen csvar = _n


	matrix C = (1, `rhouz3', `rhoumx1' \ `rhouz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz3mx1', 1)
	drawnorm u z3 mx1, corr(C) n(`N') 

	drawnorm z1 mx3
	
	expand `T'
	sort csvar
	by csvar: gen date = _n
	
	tempvar x_1 x_3 mx_1 mx_3 dx1 dx3
	drawnorm `x_1' `x_3' e, n(`obs') 
	bysort csvar: egen  `mx_1'=mean(`x_1')
	bysort csvar: egen  `mx_3'=mean(`x_3')
	
	gen `dx1'=`x_1'-`mx_1'
	gen `dx3'=`x_3'-`mx_3'
	
	gen x1=mx1+`dx1'
	gen x3=mx3+`dx3'


	tsset csvar date
	gen con=1
	gen y = x1+x3+z1+z3+u+e

	
	xtreg y x1 x3 z1 z3, fe
	local s2_u_fe =(e(sigma_u))^2
	local s2_e_fe=(e(sigma_e))^2
	
	
	xtfevd y x1 x3 z1 z3, invariant(z1 z3)
	scalar b_fevd_x1=_b[x1]
	scalar b_fevd_z1=_b[z1]
	scalar b_fevd_z3=_b[z3]
	scalar b_fevd_x3=_b[x3]
	matrix FEVD=e(V)
	matrix FEVDZ3=FEVD[4,4]
	scalar FEVD_Z3=FEVDZ3[1,1]


	xtfevd y x1 x3 z1 z3, invariant(z1 z3) bwnk
	matrix BWNK=e(V)
	matrix BWNKZ3=BWNK[4,4]
	scalar BWNK_Z3=BWNKZ3[1,1]

	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]
	scalar b_ht_z1=_b[z1]
	scalar b_ht_x3=_b[x3]
	scalar b_ht_x1=_b[x1]
	local s2_u_ht =(e(sigma_u))^2
	local s2_e_ht=(e(sigma_e))^2
	matrix HT=e(V)
	matrix HTZ3=HT[4,4]
	scalar HT_Z3=HTZ3[1,1]
	scalar S11=HT_Z3
	
	scalar diff=b_fevd_z3-b_ht_z3
	scalar FEVD_Z3_bias=FEVD_Z3+diff^2
	scalar S22=FEVD_Z3_bias
	scalar BWNK_Z3_bias=BWNK_Z3+diff^2 
	scalar S22bwnk=BWNK_Z3_bias
	
	local s2_u_12=(`s2_u_fe'+`s2_u_ht')/2
	local s2_e_12=(`s2_e_fe'+`s2_e_ht')/2

	
	local ivht `dx1' `dx3' x1 z1 con
	local zx z1 z3 con x1 x3 
	local ivef `dx1' `dx3' x1 z1 z3 con
	
	mata: bmix ("`ivht'", "`ivef'", "`zx'", `N', `T', `obs', `s2_e_12', `s2_u_12')
	
	matrix S12=r(S12)
	scalar S12=S12[4,4]
	
	scalar w=(S22-S12)/(S11+S22-2*S12)
	scalar b_mixfevd_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	scalar w=(S22bwnk-S12)/(S11+S22bwnk-2*S12)
	scalar b_mixbwnk_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	
	post `HT1' (b_fevd_z3) (b_mixbwnk_z3) (rhouz3) (rhoumx1)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*********************************************************************************************************************
* n=20, t=100
*********************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevd_z3 b_mixbwnk_z3 rhouz3 rhoumx1 using bwnk2_n20t100_z3unorm_mx1unorm_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/5000 {

	drop _all

	set obs 1000
	gen counter = _n



	tempvar c1 c1_1 c1_max c2 c2_1 c2_max c1_r c2_r 

	gen `c1'= 0.25*invnorm(uniform())
	replace `c1'=sqrt(`c1'^2)
	replace `c1'=. if `c1'>=0.8 
	gen `c2'= 0.25*invnorm(uniform())
	replace `c2'=sqrt(`c2'^2)
	replace `c2'=. if `c2'>=0.8
	gen `c1_1' = `c1' if counter==5
	gen `c2_1' = `c2' if counter==5
	replace `c1_1'=0 if `c1_1'==.
	replace `c2_1'=0 if `c2_1'==.
	egen `c1_max'=max(`c1_1')
	egen `c2_max'=max(`c2_1')
	gen `c1_r' = round(`c1_max',.01)
	gen `c2_r' = round(`c2_max',.01)
	local rhouz3 = `c1_r'	/*correlation between u and z3 */
	local rhoumx1 = `c2_r'  /*correlation between u and mx1 */


	drop _all
	local N 20
	local T 100
	local obs 2000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	

	local rhoz3mx1 0.5		/* korrelation zwischen z3 und x1*/

	scalar rhouz3 = `rhouz3'
	scalar rhoumx1 = `rhoumx1'

	
	set obs `N'
	gen csvar = _n


	matrix C = (1, `rhouz3', `rhoumx1' \ `rhouz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz3mx1', 1)
	drawnorm u z3 mx1, corr(C) n(`N') 

	drawnorm z1 mx3
	
	expand `T'
	sort csvar
	by csvar: gen date = _n
	
	tempvar x_1 x_3 mx_1 mx_3 dx1 dx3
	drawnorm `x_1' `x_3' e, n(`obs') 
	bysort csvar: egen  `mx_1'=mean(`x_1')
	bysort csvar: egen  `mx_3'=mean(`x_3')
	
	gen `dx1'=`x_1'-`mx_1'
	gen `dx3'=`x_3'-`mx_3'
	
	gen x1=mx1+`dx1'
	gen x3=mx3+`dx3'


	tsset csvar date
	gen con=1
	gen y = x1+x3+z1+z3+u+e

	
	xtreg y x1 x3 z1 z3, fe
	local s2_u_fe =(e(sigma_u))^2
	local s2_e_fe=(e(sigma_e))^2
	
	
	xtfevd y x1 x3 z1 z3, invariant(z1 z3)
	scalar b_fevd_x1=_b[x1]
	scalar b_fevd_z1=_b[z1]
	scalar b_fevd_z3=_b[z3]
	scalar b_fevd_x3=_b[x3]
	matrix FEVD=e(V)
	matrix FEVDZ3=FEVD[4,4]
	scalar FEVD_Z3=FEVDZ3[1,1]


	xtfevd y x1 x3 z1 z3, invariant(z1 z3) bwnk
	matrix BWNK=e(V)
	matrix BWNKZ3=BWNK[4,4]
	scalar BWNK_Z3=BWNKZ3[1,1]

	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]
	scalar b_ht_z1=_b[z1]
	scalar b_ht_x3=_b[x3]
	scalar b_ht_x1=_b[x1]
	local s2_u_ht =(e(sigma_u))^2
	local s2_e_ht=(e(sigma_e))^2
	matrix HT=e(V)
	matrix HTZ3=HT[4,4]
	scalar HT_Z3=HTZ3[1,1]
	scalar S11=HT_Z3
	
	scalar diff=b_fevd_z3-b_ht_z3
	scalar FEVD_Z3_bias=FEVD_Z3+diff^2
	scalar S22=FEVD_Z3_bias
	scalar BWNK_Z3_bias=BWNK_Z3+diff^2 
	scalar S22bwnk=BWNK_Z3_bias
	
	local s2_u_12=(`s2_u_fe'+`s2_u_ht')/2
	local s2_e_12=(`s2_e_fe'+`s2_e_ht')/2

	
	local ivht `dx1' `dx3' x1 z1 con
	local zx z1 z3 con x1 x3 
	local ivef `dx1' `dx3' x1 z1 z3 con
	
	mata: bmix ("`ivht'", "`ivef'", "`zx'", `N', `T', `obs', `s2_e_12', `s2_u_12')
	
	matrix S12=r(S12)
	scalar S12=S12[4,4]
	
	scalar w=(S22-S12)/(S11+S22-2*S12)
	scalar b_mixfevd_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	scalar w=(S22bwnk-S12)/(S11+S22bwnk-2*S12)
	scalar b_mixbwnk_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	
	post `HT1' (b_fevd_z3) (b_mixbwnk_z3) (rhouz3) (rhoumx1)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*********************************************************************************************************************
* n=20, t=300
*********************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevd_z3 b_mixbwnk_z3 rhouz3 rhoumx1 using bwnk2_n20t300_z3unorm_mx1unorm_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/5000 {

	drop _all

	set obs 1000
	gen counter = _n



	tempvar c1 c1_1 c1_max c2 c2_1 c2_max c1_r c2_r 

	gen `c1'= 0.25*invnorm(uniform())
	replace `c1'=sqrt(`c1'^2)
	replace `c1'=. if `c1'>=0.8 
	gen `c2'= 0.25*invnorm(uniform())
	replace `c2'=sqrt(`c2'^2)
	replace `c2'=. if `c2'>=0.8
	gen `c1_1' = `c1' if counter==5
	gen `c2_1' = `c2' if counter==5
	replace `c1_1'=0 if `c1_1'==.
	replace `c2_1'=0 if `c2_1'==.
	egen `c1_max'=max(`c1_1')
	egen `c2_max'=max(`c2_1')
	gen `c1_r' = round(`c1_max',.01)
	gen `c2_r' = round(`c2_max',.01)
	local rhouz3 = `c1_r'	/*correlation between u and z3 */
	local rhoumx1 = `c2_r'  /*correlation between u and mx1 */


	drop _all
	local N 20
	local T 300
	local obs 6000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	

	local rhoz3mx1 0.5		/* korrelation zwischen z3 und x1*/

	scalar rhouz3 = `rhouz3'
	scalar rhoumx1 = `rhoumx1'

	
	set obs `N'
	gen csvar = _n


	matrix C = (1, `rhouz3', `rhoumx1' \ `rhouz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz3mx1', 1)
	drawnorm u z3 mx1, corr(C) n(`N') 

	drawnorm z1 mx3
	
	expand `T'
	sort csvar
	by csvar: gen date = _n
	
	tempvar x_1 x_3 mx_1 mx_3 dx1 dx3
	drawnorm `x_1' `x_3' e, n(`obs') 
	bysort csvar: egen  `mx_1'=mean(`x_1')
	bysort csvar: egen  `mx_3'=mean(`x_3')
	
	gen `dx1'=`x_1'-`mx_1'
	gen `dx3'=`x_3'-`mx_3'
	
	gen x1=mx1+`dx1'
	gen x3=mx3+`dx3'


	tsset csvar date
	gen con=1
	gen y = x1+x3+z1+z3+u+e

	
	xtreg y x1 x3 z1 z3, fe
	local s2_u_fe =(e(sigma_u))^2
	local s2_e_fe=(e(sigma_e))^2
	
	
	xtfevd y x1 x3 z1 z3, invariant(z1 z3)
	scalar b_fevd_x1=_b[x1]
	scalar b_fevd_z1=_b[z1]
	scalar b_fevd_z3=_b[z3]
	scalar b_fevd_x3=_b[x3]
	matrix FEVD=e(V)
	matrix FEVDZ3=FEVD[4,4]
	scalar FEVD_Z3=FEVDZ3[1,1]


	xtfevd y x1 x3 z1 z3, invariant(z1 z3) bwnk
	matrix BWNK=e(V)
	matrix BWNKZ3=BWNK[4,4]
	scalar BWNK_Z3=BWNKZ3[1,1]

	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]
	scalar b_ht_z1=_b[z1]
	scalar b_ht_x3=_b[x3]
	scalar b_ht_x1=_b[x1]
	local s2_u_ht =(e(sigma_u))^2
	local s2_e_ht=(e(sigma_e))^2
	matrix HT=e(V)
	matrix HTZ3=HT[4,4]
	scalar HT_Z3=HTZ3[1,1]
	scalar S11=HT_Z3
	
	scalar diff=b_fevd_z3-b_ht_z3
	scalar FEVD_Z3_bias=FEVD_Z3+diff^2
	scalar S22=FEVD_Z3_bias
	scalar BWNK_Z3_bias=BWNK_Z3+diff^2 
	scalar S22bwnk=BWNK_Z3_bias
	
	local s2_u_12=(`s2_u_fe'+`s2_u_ht')/2
	local s2_e_12=(`s2_e_fe'+`s2_e_ht')/2

	
	local ivht `dx1' `dx3' x1 z1 con
	local zx z1 z3 con x1 x3 
	local ivef `dx1' `dx3' x1 z1 z3 con
	
	mata: bmix ("`ivht'", "`ivef'", "`zx'", `N', `T', `obs', `s2_e_12', `s2_u_12')
	
	matrix S12=r(S12)
	scalar S12=S12[4,4]
	
	scalar w=(S22-S12)/(S11+S22-2*S12)
	scalar b_mixfevd_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	scalar w=(S22bwnk-S12)/(S11+S22bwnk-2*S12)
	scalar b_mixbwnk_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	
	post `HT1' (b_fevd_z3) (b_mixbwnk_z3) (rhouz3) (rhoumx1)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*********************************************************************************************************************
* n=20, t=500
*********************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevd_z3 b_mixbwnk_z3 rhouz3 rhoumx1 using bwnk2_n20t500_z3unorm_mx1unorm_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/5000 {

	drop _all

	set obs 1000
	gen counter = _n



	tempvar c1 c1_1 c1_max c2 c2_1 c2_max c1_r c2_r 

	gen `c1'= 0.25*invnorm(uniform())
	replace `c1'=sqrt(`c1'^2)
	replace `c1'=. if `c1'>=0.8 
	gen `c2'= 0.25*invnorm(uniform())
	replace `c2'=sqrt(`c2'^2)
	replace `c2'=. if `c2'>=0.8
	gen `c1_1' = `c1' if counter==5
	gen `c2_1' = `c2' if counter==5
	replace `c1_1'=0 if `c1_1'==.
	replace `c2_1'=0 if `c2_1'==.
	egen `c1_max'=max(`c1_1')
	egen `c2_max'=max(`c2_1')
	gen `c1_r' = round(`c1_max',.01)
	gen `c2_r' = round(`c2_max',.01)
	local rhouz3 = `c1_r'	/*correlation between u and z3 */
	local rhoumx1 = `c2_r'  /*correlation between u and mx1 */


	drop _all
	local N 20
	local T 500
	local obs 10000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	

	local rhoz3mx1 0.5		/* korrelation zwischen z3 und x1*/

	scalar rhouz3 = `rhouz3'
	scalar rhoumx1 = `rhoumx1'

	
	set obs `N'
	gen csvar = _n


	matrix C = (1, `rhouz3', `rhoumx1' \ `rhouz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz3mx1', 1)
	drawnorm u z3 mx1, corr(C) n(`N') 

	drawnorm z1 mx3
	
	expand `T'
	sort csvar
	by csvar: gen date = _n
	
	tempvar x_1 x_3 mx_1 mx_3 dx1 dx3
	drawnorm `x_1' `x_3' e, n(`obs') 
	bysort csvar: egen  `mx_1'=mean(`x_1')
	bysort csvar: egen  `mx_3'=mean(`x_3')
	
	gen `dx1'=`x_1'-`mx_1'
	gen `dx3'=`x_3'-`mx_3'
	
	gen x1=mx1+`dx1'
	gen x3=mx3+`dx3'


	tsset csvar date
	gen con=1
	gen y = x1+x3+z1+z3+u+e

	
	xtreg y x1 x3 z1 z3, fe
	local s2_u_fe =(e(sigma_u))^2
	local s2_e_fe=(e(sigma_e))^2
	
	
	xtfevd y x1 x3 z1 z3, invariant(z1 z3)
	scalar b_fevd_x1=_b[x1]
	scalar b_fevd_z1=_b[z1]
	scalar b_fevd_z3=_b[z3]
	scalar b_fevd_x3=_b[x3]
	matrix FEVD=e(V)
	matrix FEVDZ3=FEVD[4,4]
	scalar FEVD_Z3=FEVDZ3[1,1]


	xtfevd y x1 x3 z1 z3, invariant(z1 z3) bwnk
	matrix BWNK=e(V)
	matrix BWNKZ3=BWNK[4,4]
	scalar BWNK_Z3=BWNKZ3[1,1]

	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]
	scalar b_ht_z1=_b[z1]
	scalar b_ht_x3=_b[x3]
	scalar b_ht_x1=_b[x1]
	local s2_u_ht =(e(sigma_u))^2
	local s2_e_ht=(e(sigma_e))^2
	matrix HT=e(V)
	matrix HTZ3=HT[4,4]
	scalar HT_Z3=HTZ3[1,1]
	scalar S11=HT_Z3
	
	scalar diff=b_fevd_z3-b_ht_z3
	scalar FEVD_Z3_bias=FEVD_Z3+diff^2
	scalar S22=FEVD_Z3_bias
	scalar BWNK_Z3_bias=BWNK_Z3+diff^2 
	scalar S22bwnk=BWNK_Z3_bias
	
	local s2_u_12=(`s2_u_fe'+`s2_u_ht')/2
	local s2_e_12=(`s2_e_fe'+`s2_e_ht')/2

	
	local ivht `dx1' `dx3' x1 z1 con
	local zx z1 z3 con x1 x3 
	local ivef `dx1' `dx3' x1 z1 z3 con
	
	mata: bmix ("`ivht'", "`ivef'", "`zx'", `N', `T', `obs', `s2_e_12', `s2_u_12')
	
	matrix S12=r(S12)
	scalar S12=S12[4,4]
	
	scalar w=(S22-S12)/(S11+S22-2*S12)
	scalar b_mixfevd_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	scalar w=(S22bwnk-S12)/(S11+S22bwnk-2*S12)
	scalar b_mixbwnk_z3=w*b_ht_z3+(1-w)*b_fevd_z3

	
	post `HT1' (b_fevd_z3) (b_mixbwnk_z3) (rhouz3) (rhoumx1)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
