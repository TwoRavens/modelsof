*************************************************************************
* simulations: standard errors fevd: comparison with breusch etal, green, re, ols
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







*************************************************************************
* 1. basic DGP: 1 time varying x, 1 completely time invariant z
*************************************************************************
* no correlations
*************************************************************************
* A: varying N and T
* n=10, t=10
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n10t10.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 10
	local T 10
	local obs 100
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=10, t=30
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n10t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 10
	local T 30
	local obs 300
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=10, t=50
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re senew1_nc_n10t50.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 10
	local T 50
	local obs 500
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=10, t=70
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n10t70.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 10
	local T 70
	local obs 700
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=10, t=100
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re senew1_nc_n10t100.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 10
	local T 100
	local obs 1000
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=30, t=10
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n30t10.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 10
	local obs 300
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
	drawnorm u z, corr(C) n(`N') 

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
* n=30, t=30
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n30t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 30
	local obs 900
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=30, t=50
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n30t50.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 50
	local obs 1500
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=30, t=70
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n30t70.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 70
	local obs 2100
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=30, t=100
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n30t100.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 100
	local obs 3000
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=50, t=10
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n50t10.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 50
	local T 10
	local obs 500
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
	drawnorm u z, corr(C) n(`N') 

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
* n=50, t=30
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n50t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 50
	local T 30
	local obs 1500
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=50, t=50
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n50t50.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 50
	local T 50
	local obs 2500
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=50, t=70
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n50t70.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 50
	local T 70
	local obs 3500
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=50, t=100
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n50t100.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 50
	local T 100
	local obs 5000
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=10
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n70t10.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 70
	local T 10
	local obs 700
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
	drawnorm u z, corr(C) n(`N') 

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
* n=70, t=30
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n70t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 70
	local T 30
	local obs 2100
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=50
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n70t50.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 70
	local T 50
	local obs 3500
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=70
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n70t70.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 70
	local T 70
	local obs 4900
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=100
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n70t100.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 70
	local T 100
	local obs 7000
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=10
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n100t10.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 10
	local obs 1000
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
	drawnorm u z, corr(C) n(`N') 

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
* n=70, t=30
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n100t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 30
	local obs 3000
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=50
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n100t50.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 50
	local obs 5000
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=70
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n100t70.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 70
	local obs 7000
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
	drawnorm u z, corr(C) n(`N') 

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
* A: varying N and T
* n=70, t=100
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_nc_n100t100.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 100
	local T 100
	local obs 10000
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
	drawnorm u z, corr(C) n(`N') 

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


***********************************************************************************************************************************************************************
***********************************************************************************************************************************************************************
* results
***********************************************************************************************************************************************************************
	
	tempname r1
	postfile `r1' cz_fevd_n10t10 cz_bwnk_n10t10 cz_glong_n10t10 cz_greene_n10t10 cz_ols_n10t10 cz_re_n10t10 cz_fevd_n10t30 cz_bwnk_n10t30 cz_glong_n10t30 cz_greene_n10t30 cz_ols_n10t30 cz_re_n10t30 cz_fevd_n10t50 cz_bwnk_n10t50  cz_glong_n10t50 cz_greene_n10t50 cz_ols_n10t50 cz_re_n10t50 cz_fevd_n10t70 cz_bwnk_n10t70 cz_glong_n10t70 cz_greene_n10t70 cz_ols_n10t70 cz_re_n10t70 cz_fevd_n10t100 cz_bwnk_n10t100 cz_glong_n10t100 cz_greene_n10t100 cz_ols_n10t100 cz_re_n10t100 /*
*/ cz_fevd_n30t10 cz_bwnk_n30t10 cz_glong_n30t10 cz_greene_n30t10 cz_ols_n30t10 cz_re_n30t10 cz_fevd_n30t30 cz_bwnk_n30t30 cz_glong_n30t30 cz_greene_n30t30 cz_ols_n30t30 cz_re_n30t30 cz_fevd_n30t50 cz_bwnk_n30t50 cz_glong_n30t50 cz_greene_n30t50 cz_ols_n30t50 cz_re_n30t50 cz_fevd_n30t70 cz_bwnk_n30t70 cz_glong_n30t70 cz_greene_n30t70 cz_ols_n30t70 cz_re_n30t70 cz_fevd_n30t100 cz_bwnk_n30t100 cz_glong_n30t100 cz_greene_n30t100 cz_ols_n30t100 cz_re_n30t100 /*
*/ cz_fevd_n50t10 cz_bwnk_n50t10 cz_glong_n50t10 cz_greene_n50t10 cz_ols_n50t10 cz_re_n50t10 cz_fevd_n50t30 cz_bwnk_n50t30 cz_glong_n50t30 cz_greene_n50t30 cz_ols_n50t30 cz_re_n50t30 cz_fevd_n50t50 cz_bwnk_n50t50 cz_glong_n50t50 cz_greene_n50t50 cz_ols_n50t50 cz_re_n50t50 cz_fevd_n50t70 cz_bwnk_n50t70 cz_glong_n50t70 cz_greene_n50t70 cz_ols_n50t70 cz_re_n50t70 cz_fevd_n50t100 cz_bwnk_n50t100 cz_glong_n50t100 cz_greene_n50t100 cz_ols_n50t100 cz_re_n50t100 /*
*/ cz_fevd_n70t10 cz_bwnk_n70t10 cz_glong_n70t10 cz_greene_n70t10 cz_ols_n70t10 cz_re_n70t10 cz_fevd_n70t30 cz_bwnk_n70t30 cz_glong_n70t30 cz_greene_n70t30 cz_ols_n70t30 cz_re_n70t30 cz_fevd_n70t50 cz_bwnk_n70t50 cz_glong_n70t50 cz_greene_n70t50 cz_ols_n70t50 cz_re_n70t50 cz_fevd_n70t70 cz_bwnk_n70t70 cz_glong_n70t70 cz_greene_n70t70 cz_ols_n70t70 cz_re_n70t70 cz_fevd_n70t100 cz_bwnk_n70t100 cz_glong_n70t100 cz_greene_n70t100 cz_ols_n70t100 cz_re_n70t100 /*
*/ cz_fevd_n100t10 cz_bwnk_n100t10 cz_glong_n100t10 cz_greene_n100t10 cz_ols_n100t10 cz_re_n100t10 cz_fevd_n100t30 cz_bwnk_n100t30 cz_glong_n100t30 cz_greene_n100t30 cz_ols_n100t30 cz_re_n100t30 cz_fevd_n100t50 cz_bwnk_n100t50 cz_glong_n100t50 cz_greene_n100t50 cz_ols_n100t50 cz_re_n100t50 cz_fevd_n100t70 cz_bwnk_n100t70 cz_glong_n100t70 cz_greene_n100t70 cz_ols_n100t70 cz_re_n100t70 cz_fevd_n100t100 cz_bwnk_n100t100 cz_glong_n100t100 cz_greene_n100t100 cz_ols_n100t100 cz_re_n100t100 /*
*/ using table3_se_NT.dta, replace


	clear 
	use senew1_nc_n10t10.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n10t10=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n10t10=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n10t10=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n10t10=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n10t10=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n10t10=mean_sez_re/sd_bz_re  


	clear 
	use senew1_nc_n10t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n10t30=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n10t30=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n10t30=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n10t30=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n10t30=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n10t30=mean_sez_re/sd_bz_re



	clear 
	use senew1_nc_n10t50.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n10t50=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n10t50=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n10t50=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n10t50=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n10t50=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n10t50=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n10t70.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n10t70=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n10t70=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n10t70=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n10t70=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n10t70=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n10t70=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n10t100.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n10t100=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n10t100=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n10t100=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n10t100=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n10t100=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n10t100=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n30t10.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n30t10=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n30t10=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n30t10=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n30t10=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n30t10=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n30t10=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n30t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n30t30=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n30t30=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n30t30=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n30t30=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n30t30=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n30t30=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n30t50.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n30t50=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n30t50=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n30t50=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n30t50=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n30t50=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n30t50=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n30t70.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n30t70=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n30t70=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n30t70=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n30t70=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n30t70=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n30t70=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n30t100.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n30t100=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n30t100=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n30t100=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n30t100=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n30t100=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n30t100=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n50t10.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n50t10=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n50t10=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n50t10=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n50t10=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n50t10=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n50t10=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n50t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n50t30=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n50t30=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n50t30=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n50t30=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n50t30=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n50t30=mean_sez_re/sd_bz_re
	
	
	clear 
	use senew1_nc_n50t50.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n50t50=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n50t50=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n50t50=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n50t50=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n50t50=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n50t50=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n50t70.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n50t70=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n50t70=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n50t70=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n50t70=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n50t70=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n50t70=mean_sez_re/sd_bz_re



	clear 
	use senew1_nc_n50t100.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n50t100=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n10t10=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n50t100=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n50t100=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n50t100=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n50t100=mean_sez_re/sd_bz_re



	clear 
	use senew1_nc_n70t10.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n70t10=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n70t10=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n70t10=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n70t10=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n70t10=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n70t10=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n70t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n70t30=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n70t30=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n70t30=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n70t30=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n70t30=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n70t30=mean_sez_re/sd_bz_re



	clear 
	use senew1_nc_n70t50.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n70t50=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n70t50=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n70t50=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n70t50=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n70t50=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n70t50=mean_sez_re/sd_bz_re

	clear 
	use senew1_nc_n70t70.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n70t70=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n70t70=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n70t70=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n70t70=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n70t70=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n70t70=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n70t100.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n70t100=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n70t100=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n70t100=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n70t100=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n70t100=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n70t100=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n100t10.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n100t10=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n100t10=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n100t10=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n100t10=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n100t10=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n100t10=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n100t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n100t30=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n100t30=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n100t30=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n100t30=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n100t30=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n100t30=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n100t50.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n100t50=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n100t50=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n100t50=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n100t50=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n100t50=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n100t50=mean_sez_re/sd_bz_re

	clear 
	use senew1_nc_n100t70.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n100t70=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n100t70=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n100t70=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n100t70=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n100t70=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n100t70=mean_sez_re/sd_bz_re


	clear 
	use senew1_nc_n100t100.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_n100t100=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_n100t100=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_n100t100=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_n100t100=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_n100t100=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_n100t100=mean_sez_re/sd_bz_re

	post `r1' (cz_fevd_n10t10) (cz_bwnk_n10t10) (cz_glong_n10t10) (cz_greene_n10t10) (cz_ols_n10t10) (cz_re_n10t10) (cz_fevd_n10t30) (cz_bwnk_n10t30) (cz_glong_n10t30) (cz_greene_n10t30) (cz_ols_n10t30) (cz_re_n10t30) (cz_fevd_n10t50) (cz_bwnk_n10t50) (cz_glong_n10t50) (cz_greene_n10t50) (cz_ols_n10t50) (cz_re_n10t50) (cz_fevd_n10t70) (cz_bwnk_n10t70) (cz_glong_n10t70) (cz_greene_n10t70) (cz_ols_n10t70) (cz_re_n10t70) (cz_fevd_n10t100) (cz_bwnk_n10t100) (cz_glong_n10t100) (cz_greene_n10t100) (cz_ols_n10t100) (cz_re_n10t100) /*
*/ (cz_fevd_n30t10) (cz_bwnk_n30t10) (cz_glong_n30t10) (cz_greene_n30t10) (cz_ols_n30t10) (cz_re_n30t10) (cz_fevd_n30t30) (cz_bwnk_n30t30) (cz_glong_n30t30) (cz_greene_n30t30) (cz_ols_n30t30) (cz_re_n30t30) (cz_fevd_n30t50) (cz_bwnk_n30t50) (cz_glong_n30t50) (cz_greene_n30t50) (cz_ols_n30t50) (cz_re_n30t50) (cz_fevd_n30t70) (cz_bwnk_n30t70) (cz_glong_n30t70) (cz_greene_n30t70) (cz_ols_n30t70) (cz_re_n30t70) (cz_fevd_n30t100) (cz_bwnk_n30t100) (cz_glong_n30t100) (cz_greene_n30t100) (cz_ols_n30t100) (cz_re_n30t100) /*
*/ (cz_fevd_n50t10) (cz_bwnk_n50t10) (cz_glong_n50t10) (cz_greene_n50t10) (cz_ols_n50t10) (cz_re_n50t10) (cz_fevd_n50t30) (cz_bwnk_n50t30) (cz_glong_n50t30) (cz_greene_n50t30) (cz_ols_n50t30) (cz_re_n50t30) (cz_fevd_n50t50) (cz_bwnk_n50t50) (cz_glong_n50t50) (cz_greene_n50t50) (cz_ols_n50t50) (cz_re_n50t50) (cz_fevd_n50t70) (cz_bwnk_n50t70) (cz_glong_n50t70) (cz_greene_n50t70) (cz_ols_n50t70) (cz_re_n50t70) (cz_fevd_n50t100) (cz_bwnk_n50t100) (cz_glong_n50t100) (cz_greene_n50t100) (cz_ols_n50t100) (cz_re_n50t100) /*
*/ (cz_fevd_n70t10) (cz_bwnk_n70t10) (cz_glong_n70t10) (cz_greene_n70t10) (cz_ols_n70t10) (cz_re_n70t10) (cz_fevd_n70t30) (cz_bwnk_n70t30) (cz_glong_n70t30) (cz_greene_n70t30) (cz_ols_n70t30) (cz_re_n70t30) (cz_fevd_n70t50) (cz_bwnk_n70t50) (cz_glong_n70t50) (cz_greene_n70t50) (cz_ols_n70t50) (cz_re_n70t50) (cz_fevd_n70t70) (cz_bwnk_n70t70) (cz_glong_n70t70) (cz_greene_n70t70) (cz_ols_n70t70) (cz_re_n70t70) (cz_fevd_n70t100) (cz_bwnk_n70t100) (cz_glong_n70t100) (cz_greene_n70t100) (cz_ols_n70t100) (cz_re_n70t100) /*
*/ (cz_fevd_n100t10) (cz_bwnk_n100t10) (cz_glong_n100t10) (cz_greene_n100t10) (cz_ols_n100t10) (cz_re_n100t10) (cz_fevd_n100t30) (cz_bwnk_n100t30) (cz_glong_n100t30) (cz_greene_n100t30) (cz_ols_n100t30) (cz_re_n100t30) (cz_fevd_n100t50) (cz_bwnk_n100t50) (cz_glong_n100t50) (cz_greene_n100t50) (cz_ols_n100t50) (cz_re_n100t50) (cz_fevd_n100t70) (cz_bwnk_n100t70) (cz_glong_n100t70) (cz_greene_n100t70) (cz_ols_n100t70) (cz_re_n100t70) (cz_fevd_n100t100) (cz_bwnk_n100t100) (cz_glong_n100t100) (cz_greene_n100t100) (cz_ols_n100t100) (cz_re_n100t100)


	postclose `r1'

 