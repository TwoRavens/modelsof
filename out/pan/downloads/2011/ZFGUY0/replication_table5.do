*************************************************************************
* simulations: standard errors fevd: comparison with breusch etal, greene, ols, re
***********************************************************************************
cd c:\paper\TI\mc\se\senew

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
* sd(u)=1, n=20, t=30
*************************************************************************
* C: varying correlation between x, z and u
* corr(x,u)=0, corr(z,u)=0.1
*************************************************************************	
	



	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu00zu01_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.1		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0*u+1*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0, corr(z,u)=0.3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu00zu03_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.3		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0*u+1*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0, corr(z,u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu00zu05_n20t30.dta, replace
	
	
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
	drawnorm u z, corr(C) n(`N') 

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0*u+1*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0, corr(z,u)=0.7
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu00zu07_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.7		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0*u+1*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0, corr(z,u)=0.9
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu00zu09_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.9		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0*u+1*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.1, corr(z,u)=0.1
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu01zu01_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.1		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.1*u+0.9*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.1, corr(z,u)=0.3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu01zu03_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.3		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.1*u+0.9*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.1, corr(z,u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu01zu05_n20t30.dta, replace
	
	
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
	drawnorm u z, corr(C) n(`N') 

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.1*u+0.9*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.1, corr(z,u)=0.7
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu01zu07_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.7		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.1*u+0.9*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.1, corr(z,u)=0.9
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu01zu09_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.9		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.1*u+0.9*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.3, corr(z,u)=0.1
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu03zu01_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.1		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.25*u+0.75*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.3, corr(z,u)=0.3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu03zu03_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.3		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.25*u+0.75*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.3, corr(z,u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu03zu05_n20t30.dta, replace
	
	
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
	drawnorm u z, corr(C) n(`N') 

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.25*u+0.75*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.3, corr(z,u)=0.7
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu03zu07_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.7		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.25*u+0.75*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.3, corr(z,u)=0.9
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu03zu09_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.9		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.25*u+0.75*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.5, corr(z,u)=0.1
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu05zu01_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.1		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
* C: varying correlation between x, z and u
* corr(x,u)=0.5, corr(z,u)=0.3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu05zu03_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.3		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
* C: varying correlation between x, z and u
* corr(x,u)=0.5, corr(z,u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu05zu05_n20t30.dta, replace
	
	
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
	drawnorm u z, corr(C) n(`N') 

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
* C: varying correlation between x, z and u
* corr(x,u)=0.5, corr(z,u)=0.7
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu05zu07_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.7		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
* C: varying correlation between x, z and u
* corr(x,u)=0.5, corr(z,u)=0.9
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu05zu09_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.9		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
* C: varying correlation between x, z and u
* corr(x,u)=0.7, corr(z,u)=0.1
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu07zu01_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.1		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.5*u+0.5*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.7, corr(z,u)=0.3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu07zu03_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.3		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.5*u+0.5*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.7, corr(z,u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu07zu05_n20t30.dta, replace
	
	
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
	drawnorm u z, corr(C) n(`N') 

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.5*u+0.5*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.7, corr(z,u)=0.7
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu07zu07_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.7		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.5*u+0.5*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.7, corr(z,u)=0.9
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu07zu09_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.9		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.5*u+0.5*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.9, corr(z,u)=0.1
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu09zu01_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.1		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.75*u+0.25*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.9, corr(z,u)=0.3
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu09zu03_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.3		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.75*u+0.25*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.9, corr(z,u)=0.5
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu09zu05_n20t30.dta, replace
	
	
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
	drawnorm u z, corr(C) n(`N') 

	expand `T'
	sort csvar
	by csvar: gen date = _n
	

	tempvar x_1
	drawnorm x `x_1' e, n(`obs') 
	gen x1=0.75*u+0.25*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.9, corr(z,u)=0.7
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu09zu07_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.7		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.75*u+0.25*`x_1'
	

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
* C: varying correlation between x, z and u
* corr(x,u)=0.9, corr(z,u)=0.9
*************************************************************************	
	
	


	set more off
	postutil clear
	capture program drop fevdse1
	program fevdse1
	version 10.0

	tempname SE1
	
	postfile `SE1' b_z_fevd se_z_fevd se_z_bwnk se_z_glong se_z_greene b_z_ols se_z_ols b_z_re se_z_re using senew1_xu09zu09_n20t30.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 20
	local T 30
	local obs 600
	local a 0
	local b1 1
	local b2 1	

	
	local rho 0.9		/* korrelation zwischen u und z3 und beeinflusst korrelation zwischen u und x3*/
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
	gen x1=0.75*u+0.25*`x_1'
	

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
	postfile `r1' cz_fevd_xu00zu01 cz_bwnk_xu00zu01 cz_glong_xu00zu01 cz_greene_xu00zu01 cz_ols_xu00zu01 cz_re_xu00zu01 cz_fevd_xu00zu03 cz_bwnk_xu00zu03 cz_glong_xu00zu03 cz_greene_xu00zu03 cz_ols_xu00zu03 cz_re_xu00zu03 cz_fevd_xu00zu05 cz_bwnk_xu00zu05 cz_glong_xu00zu05 cz_greene_xu00zu05 cz_ols_xu00zu05 cz_re_xu00zu05 cz_fevd_xu00zu07 cz_bwnk_xu00zu07 cz_glong_xu00zu07 cz_greene_xu00zu07 cz_ols_xu00zu07 cz_re_xu00zu07 cz_fevd_xu00zu09 cz_bwnk_xu00zu09 cz_glong_xu00zu09 cz_greene_xu00zu09 cz_ols_xu00zu09 cz_re_xu00zu09 /*
*/ cz_fevd_xu01zu01 cz_bwnk_xu01zu01 cz_glong_xu01zu01 cz_greene_xu01zu01 cz_ols_xu01zu01 cz_re_xu01zu01 cz_fevd_xu01zu03 cz_bwnk_xu01zu03 cz_glong_xu01zu03 cz_greene_xu01zu03 cz_ols_xu01zu03 cz_re_xu01zu03 cz_fevd_xu01zu05 cz_bwnk_xu01zu05 cz_glong_xu01zu05 cz_greene_xu01zu05 cz_ols_xu01zu05 cz_re_xu01zu05 cz_fevd_xu01zu07 cz_bwnk_xu01zu07 cz_glong_xu01zu07 cz_greene_xu01zu07 cz_ols_xu01zu07 cz_re_xu01zu07 cz_fevd_xu01zu09 cz_bwnk_xu01zu09 cz_glong_xu01zu09 cz_greene_xu01zu09 cz_ols_xu01zu09 cz_re_xu01zu09 /*
*/ cz_fevd_xu03zu01 cz_bwnk_xu03zu01 cz_glong_xu03zu01 cz_greene_xu03zu01 cz_ols_xu03zu01 cz_re_xu03zu01 cz_fevd_xu03zu03 cz_bwnk_xu03zu03 cz_glong_xu03zu03 cz_greene_xu03zu03 cz_ols_xu03zu03 cz_re_xu03zu03 cz_fevd_xu03zu05 cz_bwnk_xu03zu05 cz_glong_xu03zu05 cz_greene_xu03zu05 cz_ols_xu03zu05 cz_re_xu03zu05 cz_fevd_xu03zu07 cz_bwnk_xu03zu07 cz_glong_xu03zu07 cz_greene_xu03zu07 cz_ols_xu03zu07 cz_re_xu03zu07 cz_fevd_xu03zu09 cz_bwnk_xu03zu09 cz_glong_xu03zu09 cz_greene_xu03zu09 cz_ols_xu03zu09 cz_re_xu03zu09 /*
*/ cz_fevd_xu05zu01 cz_bwnk_xu05zu01 cz_glong_xu05zu01 cz_greene_xu05zu01 cz_ols_xu05zu01 cz_re_xu05zu01 cz_fevd_xu05zu03 cz_bwnk_xu05zu03 cz_glong_xu05zu03 cz_greene_xu05zu03 cz_ols_xu05zu03 cz_re_xu05zu03 cz_fevd_xu05zu05 cz_bwnk_xu05zu05 cz_glong_xu05zu05 cz_greene_xu05zu05 cz_ols_xu05zu05 cz_re_xu05zu05 cz_fevd_xu05zu07 cz_bwnk_xu05zu07 cz_glong_xu05zu07 cz_greene_xu05zu07 cz_ols_xu05zu07 cz_re_xu05zu07 cz_fevd_xu05zu09 cz_bwnk_xu05zu09 cz_glong_xu05zu09 cz_greene_xu05zu09 cz_ols_xu05zu09 cz_re_xu05zu09 /*
*/ cz_fevd_xu07zu01 cz_bwnk_xu07zu01 cz_glong_xu07zu01 cz_greene_xu07zu01 cz_ols_xu07zu01 cz_re_xu07zu01 cz_fevd_xu07zu03 cz_bwnk_xu07zu03 cz_glong_xu07zu03 cz_greene_xu07zu03 cz_ols_xu07zu03 cz_re_xu07zu03 cz_fevd_xu07zu05 cz_bwnk_xu07zu05 cz_glong_xu07zu05 cz_greene_xu07zu05 cz_ols_xu07zu05 cz_re_xu07zu05 cz_fevd_xu07zu07 cz_bwnk_xu07zu07 cz_glong_xu07zu07 cz_greene_xu07zu07 cz_ols_xu07zu07 cz_re_xu07zu07 cz_fevd_xu07zu09 cz_bwnk_xu07zu09 cz_glong_xu07zu09 cz_greene_xu07zu09 cz_ols_xu07zu09 cz_re_xu07zu09 /*
*/ cz_fevd_xu09zu01 cz_bwnk_xu09zu01 cz_glong_xu09zu01 cz_greene_xu09zu01 cz_ols_xu09zu01 cz_re_xu09zu01 cz_fevd_xu09zu03 cz_bwnk_xu09zu03 cz_glong_xu09zu03 cz_greene_xu09zu03 cz_ols_xu09zu03 cz_re_xu09zu03 cz_fevd_xu09zu05 cz_bwnk_xu09zu05 cz_glong_xu09zu05 cz_greene_xu09zu05 cz_ols_xu09zu05 cz_re_xu09zu05 cz_fevd_xu09zu07 cz_bwnk_xu09zu07 cz_glong_xu09zu07 cz_greene_xu09zu07 cz_ols_xu09zu07 cz_re_xu09zu07 cz_fevd_xu09zu09 cz_bwnk_xu09zu09 cz_glong_xu09zu09 cz_greene_xu09zu09 cz_ols_xu09zu09 cz_re_xu09zu09 /*
*/ using table5_se_xzu.dta, replace


	clear 
	use senew1_xu00zu01_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu00zu01=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu00zu01=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu00zu01=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu00zu01=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu00zu01=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu00zu01=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu00zu03_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu00zu03=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu00zu03=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu00zu03=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu00zu03=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu00zu03=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu00zu03=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu00zu05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu00zu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu00zu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu00zu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu00zu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu00zu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu00zu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu00zu07_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu00zu07=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu00zu07=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu00zu07=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu00zu07=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu00zu07=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu00zu07=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu00zu09_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu00zu09=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu00zu09=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu00zu09=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu00zu09=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu00zu09=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu00zu09=mean_sez_re/sd_bz_re  



	clear 
	use senew1_xu01zu01_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu01zu01=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu01zu01=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu01zu01=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu01zu01=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu01zu01=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu01zu01=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu01zu03_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu01zu03=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu01zu03=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu01zu03=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu01zu03=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu01zu03=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu01zu03=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu01zu05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu01zu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu01zu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu01zu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu01zu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu01zu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu01zu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu01zu07_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu01zu07=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu01zu07=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu01zu07=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu01zu07=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu01zu07=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu01zu07=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu01zu09_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu01zu09=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu01zu09=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu01zu09=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu01zu09=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu01zu09=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu01zu09=mean_sez_re/sd_bz_re  



	clear 
	use senew1_xu03zu01_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu03zu01=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu03zu01=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu03zu01=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu03zu01=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu03zu01=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu03zu01=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu03zu03_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu03zu03=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu03zu03=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu03zu03=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu03zu03=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu03zu03=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu03zu03=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu03zu05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu03zu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu03zu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu03zu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu03zu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu03zu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu03zu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu03zu07_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu03zu07=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu03zu07=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu03zu07=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu03zu07=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu03zu07=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu03zu07=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu03zu09_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu03zu09=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu03zu09=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu03zu09=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu03zu09=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu03zu09=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu03zu09=mean_sez_re/sd_bz_re  



	clear 
	use senew1_xu05zu01_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu05zu01=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu05zu01=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu05zu01=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu05zu01=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu05zu01=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu05zu01=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu05zu03_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu05zu03=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu05zu03=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu05zu03=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu05zu03=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu05zu03=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu05zu03=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu05zu05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu05zu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu05zu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu05zu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu05zu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu05zu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu05zu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu05zu07_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu05zu07=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu05zu07=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu05zu07=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu05zu07=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu05zu07=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu05zu07=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu05zu09_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu05zu09=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu05zu09=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu05zu09=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu05zu09=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu05zu09=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu05zu09=mean_sez_re/sd_bz_re  




	clear 
	use senew1_xu07zu01_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu07zu01=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu07zu01=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu07zu01=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu07zu01=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu07zu01=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu07zu01=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu07zu03_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu07zu03=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu07zu03=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu07zu03=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu07zu03=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu07zu03=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu07zu03=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu07zu05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu07zu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu07zu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu07zu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu07zu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu07zu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu07zu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu07zu07_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu07zu07=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu07zu07=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu07zu07=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu07zu07=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu07zu07=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu07zu07=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu07zu09_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu07zu09=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu07zu09=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu07zu09=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu07zu09=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu07zu09=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu07zu09=mean_sez_re/sd_bz_re  



	clear 
	use senew1_xu09zu01_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu09zu01=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu09zu01=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu09zu01=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu09zu01=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu09zu01=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu09zu01=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu09zu03_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu09zu03=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu09zu03=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu09zu03=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu09zu03=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu09zu03=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu09zu03=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu09zu05_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu09zu05=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu09zu05=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu09zu05=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu09zu05=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu09zu05=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu09zu05=mean_sez_re/sd_bz_re  

	clear 
	use senew1_xu09zu07_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu09zu07=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu09zu07=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu09zu07=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu09zu07=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu09zu07=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu09zu07=mean_sez_re/sd_bz_re  


	clear 
	use senew1_xu09zu09_n20t30.dta
	
	sum b_z_fevd
	scalar sd_bz_fevd=r(sd)
	sum se_z_fevd
	scalar mean_sez_fevd=r(mean)
	scalar cz_fevd_xu09zu09=mean_sez_fevd/sd_bz_fevd 
	
	sum se_z_bwnk
	scalar mean_sez_bwnk=r(mean)
	scalar cz_bwnk_xu09zu09=mean_sez_bwnk/sd_bz_fevd

	sum se_z_glong
	scalar mean_sez_glong=r(mean)
	scalar cz_glong_xu09zu09=mean_sez_glong/sd_bz_fevd

	sum se_z_greene
	scalar mean_sez_greene=r(mean)
	scalar cz_greene_xu09zu09=mean_sez_greene/sd_bz_fevd

	sum b_z_ols
	scalar sd_bz_ols=r(sd)
	sum se_z_ols
	scalar mean_sez_ols=r(mean)
	scalar cz_ols_xu09zu09=mean_sez_ols/sd_bz_ols

	sum b_z_re
	scalar sd_bz_re=r(sd)
	sum se_z_re
	scalar mean_sez_re=r(mean)
	scalar cz_re_xu09zu09=mean_sez_re/sd_bz_re  





	post `r1' (cz_fevd_xu00zu01) (cz_bwnk_xu00zu01) (cz_glong_xu00zu01) (cz_greene_xu00zu01) (cz_ols_xu00zu01) (cz_re_xu00zu01) (cz_fevd_xu00zu03) (cz_bwnk_xu00zu03) (cz_glong_xu00zu03) (cz_greene_xu00zu03) (cz_ols_xu00zu03) (cz_re_xu00zu03) (cz_fevd_xu00zu05) (cz_bwnk_xu00zu05) (cz_glong_xu00zu05) (cz_greene_xu00zu05) (cz_ols_xu00zu05) (cz_re_xu00zu05) (cz_fevd_xu00zu07) (cz_bwnk_xu00zu07) (cz_glong_xu00zu07) (cz_greene_xu00zu07) (cz_ols_xu00zu07) (cz_re_xu00zu07) (cz_fevd_xu00zu09) (cz_bwnk_xu00zu09) (cz_glong_xu00zu09) (cz_greene_xu00zu09) (cz_ols_xu00zu09) (cz_re_xu00zu09) /*
*/ (cz_fevd_xu01zu01) (cz_bwnk_xu01zu01) (cz_glong_xu01zu01) (cz_greene_xu01zu01) (cz_ols_xu01zu01) (cz_re_xu01zu01) (cz_fevd_xu01zu03) (cz_bwnk_xu01zu03) (cz_glong_xu01zu03) (cz_greene_xu01zu03) (cz_ols_xu01zu03) (cz_re_xu01zu03) (cz_fevd_xu01zu05) (cz_bwnk_xu01zu05) (cz_glong_xu01zu05) (cz_greene_xu01zu05) (cz_ols_xu01zu05) (cz_re_xu01zu05) (cz_fevd_xu01zu07) (cz_bwnk_xu01zu07) (cz_glong_xu01zu07) (cz_greene_xu01zu07) (cz_ols_xu01zu07) (cz_re_xu01zu07) (cz_fevd_xu01zu09) (cz_bwnk_xu01zu09) (cz_glong_xu01zu09) (cz_greene_xu01zu09) (cz_ols_xu01zu09) (cz_re_xu01zu09) /*
*/ (cz_fevd_xu03zu01) (cz_bwnk_xu03zu01) (cz_glong_xu03zu01) (cz_greene_xu03zu01) (cz_ols_xu03zu01) (cz_re_xu03zu01) (cz_fevd_xu03zu03) (cz_bwnk_xu03zu03) (cz_glong_xu03zu03) (cz_greene_xu03zu03) (cz_ols_xu03zu03) (cz_re_xu03zu03) (cz_fevd_xu03zu05) (cz_bwnk_xu03zu05) (cz_glong_xu03zu05) (cz_greene_xu03zu05) (cz_ols_xu03zu05) (cz_re_xu03zu05) (cz_fevd_xu03zu07) (cz_bwnk_xu03zu07) (cz_glong_xu03zu07) (cz_greene_xu03zu07) (cz_ols_xu03zu07) (cz_re_xu03zu07) (cz_fevd_xu03zu09) (cz_bwnk_xu03zu09) (cz_glong_xu03zu09) (cz_greene_xu03zu09) (cz_ols_xu03zu09) (cz_re_xu03zu09) /*
*/ (cz_fevd_xu05zu01) (cz_bwnk_xu05zu01) (cz_glong_xu05zu01) (cz_greene_xu05zu01) (cz_ols_xu05zu01) (cz_re_xu05zu01) (cz_fevd_xu05zu03) (cz_bwnk_xu05zu03) (cz_glong_xu05zu03) (cz_greene_xu05zu03) (cz_ols_xu05zu03) (cz_re_xu05zu03) (cz_fevd_xu05zu05) (cz_bwnk_xu05zu05) (cz_glong_xu05zu05) (cz_greene_xu05zu05) (cz_ols_xu05zu05) (cz_re_xu05zu05) (cz_fevd_xu05zu07) (cz_bwnk_xu05zu07) (cz_glong_xu05zu07) (cz_greene_xu05zu07) (cz_ols_xu05zu07) (cz_re_xu05zu07) (cz_fevd_xu05zu09) (cz_bwnk_xu05zu09) (cz_glong_xu05zu09) (cz_greene_xu05zu09) (cz_ols_xu05zu09) (cz_re_xu05zu09) /*
*/ (cz_fevd_xu07zu01) (cz_bwnk_xu07zu01) (cz_glong_xu07zu01) (cz_greene_xu07zu01) (cz_ols_xu07zu01) (cz_re_xu07zu01) (cz_fevd_xu07zu03) (cz_bwnk_xu07zu03) (cz_glong_xu07zu03) (cz_greene_xu07zu03) (cz_ols_xu07zu03) (cz_re_xu07zu03) (cz_fevd_xu07zu05) (cz_bwnk_xu07zu05) (cz_glong_xu07zu05) (cz_greene_xu07zu05) (cz_ols_xu07zu05) (cz_re_xu07zu05) (cz_fevd_xu07zu07) (cz_bwnk_xu07zu07) (cz_glong_xu07zu07) (cz_greene_xu07zu07) (cz_ols_xu07zu07) (cz_re_xu07zu07) (cz_fevd_xu07zu09) (cz_bwnk_xu07zu09) (cz_glong_xu07zu09) (cz_greene_xu07zu09) (cz_ols_xu07zu09) (cz_re_xu07zu09) /*
*/ (cz_fevd_xu07zu01) (cz_bwnk_xu07zu01) (cz_glong_xu07zu01) (cz_greene_xu07zu01) (cz_ols_xu07zu01) (cz_re_xu07zu01) (cz_fevd_xu07zu03) (cz_bwnk_xu07zu03) (cz_glong_xu07zu03) (cz_greene_xu07zu03) (cz_ols_xu07zu03) (cz_re_xu07zu03) (cz_fevd_xu07zu05) (cz_bwnk_xu07zu05) (cz_glong_xu07zu05) (cz_greene_xu07zu05) (cz_ols_xu07zu05) (cz_re_xu07zu05) (cz_fevd_xu07zu07) (cz_bwnk_xu07zu07) (cz_glong_xu07zu07) (cz_greene_xu07zu07) (cz_ols_xu07zu07) (cz_re_xu07zu07) (cz_fevd_xu07zu09) (cz_bwnk_xu07zu09) (cz_glong_xu07zu09) (cz_greene_xu07zu09) (cz_ols_xu07zu09) (cz_re_xu07zu09)

	postclose `r1'

 