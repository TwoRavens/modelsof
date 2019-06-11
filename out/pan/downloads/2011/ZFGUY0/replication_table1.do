*************************************************************************
* Plümper/Troeger PA 2011
* table 1: HT vs. FEVD-IV
************************************
* column 1: internal instrument
*************************************************************************
* N=30, T=20
*************************************************************************	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevdiv_z3 b_ht_z3 using htfevdiv2_z1z300_z1mx100_z3u05_mx1u00_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 20
	local obs 600
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


	matrix C = (1, `rhouz1', `rhouz3', `rhoumx1' \ `rhouz1', 1, `rhoz1z3', `rhoz1mx1' \ `rhouz3', `rhoz1z3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz1mx1', `rhoz3mx1', 1)
	drawnorm u z1 z3 mx1, corr(C) n(`N')
	

	drawnorm mx3
	
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
	

	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(mx1)
	scalar b_fevdiv_z3=_b[z3]


	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]

	

	
	post `HT1' (b_fevdiv_z3) (b_ht_z3)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear


*************************************************************************
* N=100, T=20
*************************************************************************	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevdiv_z3 b_ht_z3 using htfevdiv2_n100t20_z1z300_z1mx100_z3u05_mx1u00_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


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


	matrix C = (1, `rhouz1', `rhouz3', `rhoumx1' \ `rhouz1', 1, `rhoz1z3', `rhoz1mx1' \ `rhouz3', `rhoz1z3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz1mx1', `rhoz3mx1', 1)
	drawnorm u z1 z3 mx1, corr(C) n(`N')
	

	drawnorm mx3
	
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
	

	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(mx1)
	scalar b_fevdiv_z3=_b[z3]


	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]

	

	
	post `HT1' (b_fevdiv_z3) (b_ht_z3)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*************************************************************************
*************************************************************************
* N=30, T=100
*************************************************************************	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevdiv_z3 b_ht_z3 using htfevdiv2_n30t100_z1z300_z1mx100_z3u05_mx1u00_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 100
	local obs 3000
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


	matrix C = (1, `rhouz1', `rhouz3', `rhoumx1' \ `rhouz1', 1, `rhoz1z3', `rhoz1mx1' \ `rhouz3', `rhoz1z3', 1, `rhoz3mx1' \ `rhoumx1', `rhoz1mx1', `rhoz3mx1', 1)
	drawnorm u z1 z3 mx1, corr(C) n(`N')
	

	drawnorm mx3
	
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
	

	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(mx1)
	scalar b_fevdiv_z3=_b[z3]


	xthtaylor y x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]

	

	
	post `HT1' (b_fevdiv_z3) (b_ht_z3)  


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*********************************************************************************************************************
*********************************************************************************************************************
* table 1: column 2: external instrument
*********************************************************************************************************************
* N=30, T=20
********************************************	
*************************************************************************	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevdiv_z3 b_ht_z3 using htfevdivei_n30t20_eiz305_z3u05_mx1u00_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 20
	local obs 600
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouei 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoeiz3 0.5	
	local rhoeimx1 0	
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


	matrix C = (1, `rhouei', `rhouz3', `rhoumx1' \ `rhouei', 1, `rhoeiz3', `rhoeimx1' \ `rhouz3', `rhoeiz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoeimx1', `rhoz3mx1', 1)
	drawnorm u ei z3 mx1, corr(C) n(`N') 

	drawnorm mx3 z1
	
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
	
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(mx1 ei)
	scalar b_fevdiv_z3=_b[z3]


	xthtaylor y ei x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]


	
	post `HT1' (b_fevdiv_z3) (b_ht_z3)   


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear

***************************************************************
* N=100, T=20
*********************************************************************************************************************	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevdiv_z3 b_ht_z3 using htfevdivei_n100t20_eiz305_z3u05_mx1u00_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


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
	
	local rhouei 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoeiz3 0.5	
	local rhoeimx1 0	
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


	matrix C = (1, `rhouei', `rhouz3', `rhoumx1' \ `rhouei', 1, `rhoeiz3', `rhoeimx1' \ `rhouz3', `rhoeiz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoeimx1', `rhoz3mx1', 1)
	drawnorm u ei z3 mx1, corr(C) n(`N') 

	drawnorm mx3 z1
	
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
	
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(mx1 ei)
	scalar b_fevdiv_z3=_b[z3]


	xthtaylor y ei x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]


	
	post `HT1' (b_fevdiv_z3) (b_ht_z3)   


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
*************************************************************************
* N=30, T=100
*************************************************************************	
	
	set more off
	postutil clear
	capture program drop fevdht1
	program fevdht1
	version 10.0

	tempname HT1
	
	postfile `HT1' b_fevdiv_z3 b_ht_z3 using htfevdivei_n30t100_eiz305_z3u05_mx1u00_mx1z305.dta, replace
	
	
	qui {	

	forvalues i = 1/1000 {


	drop _all
	local N 30
	local T 100
	local obs 3000
	local a 1
	local b1 1
	local b2 1	
	local b3 1
	local b4 1
	local b5 1
	local b6 1
	
	local rhouei 0		/* korrelation zwischen u und z1 und beeinflusst korrelation zwischen u und x3*/
	local rhouz2 0		/* korrelation zwischen u und z2*/ 
	local rhouz3 0.5		/* korrelation zwischen u und z3*/
	local rhoumx1 0		/* korrelation zwischen u und x1*/
	local rhoumx2 0		/* korrelation zwischen u und x1*/
	local rhoumx3 0		/* korrelation zwischen u und x1*/
	local rhoz1z2 0		/* korrelation zwischen u und x1*/
	local rhoeiz3 0.5	
	local rhoeimx1 0	
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


	matrix C = (1, `rhouei', `rhouz3', `rhoumx1' \ `rhouei', 1, `rhoeiz3', `rhoeimx1' \ `rhouz3', `rhoeiz3', 1, `rhoz3mx1' \ `rhoumx1', `rhoeimx1', `rhoz3mx1', 1)
	drawnorm u ei z3 mx1, corr(C) n(`N') 

	drawnorm mx3 z1
	
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
	
	
	xtfevd y z1 z3 x1 x3, invariant(z1 z3) s2iv_endog(z3) s2iv_exog(mx1 ei)
	scalar b_fevdiv_z3=_b[z3]


	xthtaylor y ei x1 x3 z1 z3, endog(x3 z3)
	scalar b_ht_z3=_b[z3]


	
	post `HT1' (b_fevdiv_z3) (b_ht_z3)   


		}
	
	}


	postclose `HT1'


	end
	
	fevdht1
	clear
	
*****************************************************************************************************************************************************************************************
