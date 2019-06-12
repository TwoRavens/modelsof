*************************************************************************
* simulations: standard errors fevd: comparison with breusch etal, greene, ols, re
*************************************************************************

cd c:\paper

clear all
version 11
mata:
void se_glong (string scalar x, string scalar z, string scalar m_x, string scalar dm_x, real scalar s2_e, real scalar s2_eta, real scalar T)
{
	st_view(X=.,., x)
	st_view(MX=.,., m_x)
	st_view(DMX=.,., dm_x)
	O2=s2_eta+s2_e*(1/T+MX'*qrinv(X'*DMX)*MX)
	st_view(Z=.,., z)
	V1 = qrinv(Z'*Z)*Z'*O2*Z*qrinv(Z'*Z)
	st_matrix("r(VC)", V1)
	st_matrix("r(Omega)", O2) 
}
end

version 11
mata:
void se_greene (string scalar z, string scalar Omega)
{
	st_view(Z=.,., z)
	O2=st_matrix(Omega)
	V2 = qrinv(Z'*Z)*Z'*O2*Z*qrinv(Z'*Z)
	st_matrix("r(VC)", V2)
}
end


	fevdse1
	clear

*************************************************************************
* 1. basic DGP: 1 time varying x, 1 completely time invariant z
*************************************************************************
* no correlations, n=20, t=30
*************************************************************************
* B: varying size of unit effects
* sd(u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_u05_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(0.5, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=u+1.6166*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear


*************************************************************************
* B: varying size of unit effects
* sd(u)=1
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_u10_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(1, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=u+1.6166*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=1.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_u15_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(1.5, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=u+1.6166*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=2
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_u20_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(2, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=u+1.6166*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_u30_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(3, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=u+1.6166*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=4
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_u40_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(4, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=u+1.6166*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_u50_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(5, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=u+1.6166*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* c(x,u)=0.5 c(z,u)=0.5, n=20, t=30
*************************************************************************
* B: varying size of unit effects
* sd(u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xzu05_u05_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.5		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(0.5, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.35*u+0.65*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x1+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=1
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xzu05_u10_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.5		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(1, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.35*u+0.65*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x1+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=1.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xzu05_u15_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.5		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(1.5, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.35*u+0.65*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x1+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=2
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xzu05_u20_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.5		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(2, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.35*u+0.65*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x1+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xzu05_u30_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.5		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(3, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.35*u+0.65*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x1+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=4
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xzu05_u40_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.5		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(4, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.35*u+0.65*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x1+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear

*************************************************************************
* B: varying size of unit effects
* sd(u)=5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xzu05_u50_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.5		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
	local rho2 0		/* korrelation zwischen u und z2*/ 
	local rho3 0		/* korrelation zwischen z2 und z3*/
	local rho4 0		/* korrelation zwischen u und z1*/


	local reps 1000


	set obs `N'
	gen csvar = _n


	matrix C = (1, `rho' \ `rho', 1)
	drawnorm u z, corr(C) n(`N') sds(5, 1)

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.35*u+0.65*`x_1'
	

	tsset csvar date
	gen y = `a'+`b1'*x1+`b2'*z+u+2*e

	
	xtfevd y x z, invariant(z)
	scalar b_z_fevd=_b[z]
	scalar se_z_fevd=_se[z]


	xtfevd y x z, invariant(z) bwnk
	scalar se_z_bwnk=_se[z]	

	reg y x z
	scalar b_z_ols=_b[z]
	scalar se_z_ols=_se[z]

	xtreg y x z, re
	scalar b_z_re=_b[z]
	scalar se_z_re=_se[z]
	
	tempvar fe_g e h
	tempname b_1 b3 b_long V_long b_short V_short

	xtreg y x z, fe
	predict `fe_g', u
	predict `e', e
	sum `e'
	local s2_e=r(Var)
	reg `fe_g' z
	predict `h', resid
	sum `h'
	local s2_eta=r(Var)


	reg y x z `h'
	matrix `b_1'=e(b)
	matrix `b3'=`b_1'[1,2]

	bysort csvar: egen m_x=mean(x)
	gen dm_x=x-m_x

	mata: se_glong ("x", "z", "m_x", "dm_x", `s2_e', `s2_eta', `T')


	matrix `b_long'=`b3'
	matrix rownames `b_long' = y
	matrix colnames `b_long' = z
	matrix `V_long'=r(VC)
	matrix rownames `V_long' = z
	matrix colnames `V_long' = z
	matrix Omega=r(Omega)

	
	ereturn post `b_long' `V_long'

	ereturn display
	scalar se_z_glong=_se[z]
	
	collapse `fe_g' z, by(csvar)

	mata: se_greene ("z", "Omega")


	matrix `b_short'=`b3'
	matrix rownames `b_short' = y
	matrix colnames `b_short' = z	
	matrix `V_short'=r(VC)
	matrix rownames `V_short' = z
	matrix colnames `V_short' = z

	ereturn post `b_short' `V_short'

	ereturn display
	scalar se_z_greene=_se[z]

	
	post `SE1' (b_z_fevd) (se_z_fevd) (se_z_bwnk) (se_z_glong) (se_z_greene) (b_z_ols) (se_z_ols) (b_z_re) (se_z_re)


		}
	
	}


	postclose `SE1'


	end
	
	fevdse1
	clear



***********************************************************************************************************************************************************************
***********************************************************************************************************************************************************************
* results
***********************************************************************************************************************************************************************
	
	tempname r1
	postfile `r1' cz_fevd_u05 cz_bwnk_u05 cz_glong_u05 cz_greene_u05 cz_ols_u05 cz_re_u05 cz_fevd_u10 cz_bwnk_u10 cz_glong_u10 cz_greene_u10 cz_ols_u10 cz_re_u10 cz_fevd_u15 cz_bwnk_u15 cz_glong_u15 cz_greene_u15 cz_ols_u15 cz_re_u15 cz_fevd_u20 cz_bwnk_u20 cz_glong_u20 cz_greene_u20 cz_ols_u20 cz_re_u20 cz_fevd_u30 cz_bwnk_u30 cz_glong_u30 cz_greene_u30 cz_ols_u30 cz_re_u30 /*
*/ cz_fevd_u40 cz_bwnk_u40 cz_glong_u40 cz_greene_u40 cz_ols_u40 cz_re_u40 cz_fevd_u50 cz_bwnk_u50 cz_glong_u50 cz_greene_u50 cz_ols_u50 cz_re_u50 /*
*/ cz_fevd_u05_xzu05 cz_bwnk_u05_xzu05 cz_glong_u05_xzu05 cz_greene_u05_xzu05 cz_ols_u05_xzu05 cz_re_u05_xzu05 cz_fevd_u10_xzu05 cz_bwnk_u10_xzu05 cz_glong_u10_xzu05 cz_greene_u10_xzu05 cz_ols_u10_xzu05 cz_re_u10_xzu05 cz_fevd_u15_xzu05 cz_bwnk_u15_xzu05 cz_glong_u15_xzu05 cz_greene_u15_xzu05 cz_ols_u15_xzu05 cz_re_u15_xzu05 cz_fevd_u20_xzu05 cz_bwnk_u20_xzu05 cz_glong_u20_xzu05 cz_greene_u20_xzu05 cz_ols_u20_xzu05 cz_re_u20_xzu05 cz_fevd_u30_xzu05 cz_bwnk_u30_xzu05 cz_glong_u30_xzu05 cz_greene_u30_xzu05 cz_ols_u05_xzu05 cz_re_u30_xzu05 /*
*/ cz_fevd_u40_xzu05 cz_bwnk_u40_xzu05 cz_glong_u40_xzu05 cz_greene_u40_xzu05 cz_ols_u40_xzu05 cz_re_u40_xzu05 cz_fevd_u50_xzu05 cz_bwnk_u50_xzu05 cz_glong_u50_xzu05 cz_greene_u50_xzu05 cz_ols_u50_xzu05 cz_re_u50_xzu05 /*
*/ using table4_se_sdu.dta, replace


	clear 
	use senew1_nc_u05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u05=mean_sez_re/sd_bz_re  


	clear 
	use senew1_nc_u10_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u10=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u10=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u10=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u10=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u10=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u10=mean_sez_re/sd_bz_re 


	clear 
	use senew1_nc_u15_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u15=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u15=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u15=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u15=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u15=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u15=mean_sez_re/sd_bz_re  	


	clear 
	use senew1_nc_u20_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u20=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u20=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u20=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u20=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u20=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u20=mean_sez_re/sd_bz_re  


	clear 
	use senew1_nc_u30_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u30=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u30=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u30=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u30=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u30=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u30=mean_sez_re/sd_bz_re  

	clear 
	use senew1_nc_u40_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u40=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u40=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u40=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u40=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u40=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u40=mean_sez_re/sd_bz_re  

	clear 
	use senew1_nc_u50_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u50=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u50=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u50=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u50=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u50=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u50=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xzu05_u05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u05_xzu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u05_xzu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u05_xzu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u05_xzu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u05_xzu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u05_xzu05=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xzu05_u10_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u10_xzu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u10_xzu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u10_xzu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u10_xzu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u10_xzu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u10_xzu05=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xzu05_u15_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u15_xzu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u15_xzu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u15_xzu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u15_xzu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u15_xzu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u15_xzu05=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xzu05_u20_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u20_xzu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u20_xzu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u20_xzu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u20_xzu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u20_xzu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u20_xzu05=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xzu05_u30_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u30_xzu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u30_xzu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u30_xzu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u30_xzu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u30_xzu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u30_xzu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xzu05_u40_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u40_xzu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u40_xzu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u40_xzu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u40_xzu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u40_xzu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u40_xzu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xzu05_u50_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_u50_xzu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_u50_xzu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_u50_xzu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_u50_xzu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_u50_xzu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_u50_xzu05=mean_sez_re/sd_bz_re  



	post `r1' (cz_fevd_u05) (cz_bwnk_u05) (cz_glong_u05) (cz_greene_u05) (cz_ols_u05) (cz_re_u05) (cz_fevd_u10) (cz_bwnk_u10) (cz_glong_u10) (cz_greene_u10) (cz_ols_u10) (cz_re_u10) (cz_fevd_u15) (cz_bwnk_u15) (cz_glong_u15) (cz_greene_u15) (cz_ols_u15) (cz_re_u15) (cz_fevd_u20) (cz_bwnk_u20) (cz_glong_u20) (cz_greene_u20) (cz_ols_u20) (cz_re_u20) (cz_fevd_u30) (cz_bwnk_u30) (cz_glong_u30) (cz_greene_u30) (cz_ols_u30) (cz_re_u30) /*
*/ (cz_fevd_u40) (cz_bwnk_u40) (cz_glong_u40) (cz_greene_u40) (cz_ols_u40) (cz_re_u40) (cz_fevd_u50) (cz_bwnk_u50) (cz_glong_u50) (cz_greene_u50) (cz_ols_u50) (cz_re_u50) /*
*/ (cz_fevd_u05_xzu05) (cz_bwnk_u05_xzu05) (cz_glong_u05_xzu05) (cz_greene_u05_xzu05) (cz_ols_u05_xzu05) (cz_re_u05_xzu05) (cz_fevd_u10_xzu05) (cz_bwnk_u10_xzu05) (cz_glong_u10_xzu05) (cz_greene_u10_xzu05) (cz_ols_u10_xzu05) (cz_re_u10_xzu05) (cz_fevd_u15_xzu05) (cz_bwnk_u15_xzu05) (cz_glong_u15_xzu05) (cz_greene_u15_xzu05) (cz_ols_u15_xzu05) (cz_re_u15_xzu05) (cz_fevd_u20_xzu05) (cz_bwnk_u20_xzu05) (cz_glong_u20_xzu05) (cz_greene_u20_xzu05) (cz_ols_u20_xzu05) (cz_re_u20_xzu05) (cz_fevd_u30_xzu05) (cz_bwnk_u30_xzu05) (cz_glong_u30_xzu05) (cz_greene_u30_xzu05) (cz_ols_u30_xzu05) (cz_re_u30_xzu05) /*
*/ (cz_fevd_u40_xzu05) (cz_bwnk_u40_xzu05) (cz_glong_u40_xzu05) (cz_greene_u40_xzu05) (cz_ols_u40_xzu05) (cz_re_u40_xzu05) (cz_fevd_u50_xzu05) (cz_bwnk_u50_xzu05) (cz_glong_u50_xzu05) (cz_greene_u50_xzu05) (cz_ols_u50_xzu05) (cz_re_u50_xzu05) /*
*/

	postclose `r1'

 