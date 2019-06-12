*************************************************************************
* simulations: hausman-taylor, pretest, shrinkage, fevd
*************************************************************************

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
* N=100, T=10
*************************************************************************	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu00_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
   	local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
* 2. change endogeneity of z3 --> corr with u
*****************************************************************************************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu00_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu00_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu00_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu00_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu00_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
* 3. change strength of instrument: mx1 --> corr with z3
*****************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu00_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu00_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu00_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu00_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu00_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu00_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
***************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu00_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu00_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu00_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu00_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu00_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu00_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu00_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu00_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu00_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu00_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu00_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu00_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu00_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu00_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu00_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu00_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu00_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu00_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
* 4. change validity of instruments
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu01_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu01_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu01_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu01_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu01_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu01_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu01_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu01_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu01_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu01_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu01_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu01_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
***************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu01_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu01_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu01_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu01_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu01_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu01_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu01_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu01_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu01_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu01_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu01_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu01_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu01_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu01_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu01_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu01_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu01_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu01_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.1		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*******************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu03_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu03_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu03_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu03_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu03_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu03_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu03_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu03_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu03_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu03_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu03_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu03_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
***************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu03_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu03_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu03_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu03_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu03_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu03_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu03_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu03_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu03_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu03_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu03_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu03_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu03_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu03_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu03_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu03_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu03_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu03_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.3		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu05_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu05_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu05_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu05_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu05_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu05_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu05_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu05_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu05_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu05_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu05_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu05_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
***************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu05_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu05_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu05_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu05_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu05_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu05_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu05_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu05_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu05_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu05_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu05_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu05_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu05_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu05_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu05_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu05_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu05_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu05_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.5		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu07_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************

	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu07_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu07_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu07_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu07_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu07_instz300.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	

*****************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu07_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu07_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu07_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu07_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu07_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu07_instz301.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.1
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
***************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu07_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu07_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu07_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu07_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu07_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu07_instz303.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.3
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu07_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu07_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu07_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu07_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu07_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu07_instz305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.5
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

**************************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u00_instu07_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u01_instu07_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.1		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u03_instu07_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.3		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u05_instu07_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************

	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u07_instu07_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.7		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1'  b_fevd_z3  b_ht_z3 b_dwh_z3en b_dwh_z3ex b_mixbwnk_z3 p_dwh using htiv_n100t10_z3u09_instu07_instz307.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouz1 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.9		/* korrelation zwischen u und z3*/
	local rhoumx1 0.7		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoz1z3 0	
	local rhoz1mx1 0	
	local rhoz1mx2 0
	local rhoz1mx3 0
	local rhoz2z3 0
	local rhoz2mx1 0
	local rhoz2mx2 0
	local rhoz2mx3 0
	local rhoz3mx1 0.7
	local rhoz3mx2 0
	local rhoz3mx3 0
	local rhomx1mx2 0
	local rhomx1mx3 0
	local rhomx2mx3 0
	
	local reps 1000

	drop _all
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
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(z1 mx1)
	scalar b_fevdiv_z3=_b[z3]

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
	
	*DWH test
	
	reg z3 z1 mx1 `dx1' `dx3'
	predict z3resid, resid
	
	reg y z1 z3 x1 x3 z3resid
	
	test z3resid
    local p=r(p)
	scalar p_dwh=`p'
	
	tempvar b_dwh_z3ex b_dwh_z3en
	
	gen `b_dwh_z3ex'=b_fevd_z3 if p_dwh>0.05
	gen `b_dwh_z3en'=b_fevd_z3+(b_ht_z3-b_fevd_z3) if p_dwh<=0.05
	
	scalar b_dwh_z3ex=`b_dwh_z3ex'
	scalar b_dwh_z3en=`b_dwh_z3en'
	
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

	
	post `HT1' (b_fevd_z3) (b_ht_z3) (b_dwh_z3en) (b_dwh_z3ex)_z3) (b_mixbwnk_z3) (p_dwh)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

