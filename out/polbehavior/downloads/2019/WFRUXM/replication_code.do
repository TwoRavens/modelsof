*** Table 3 ***

* Model 1 *

stcox termlen  sex minority i.STATEBYTE if appointed==01,  ///
	tvc(vested age  chief  ideoagree   log_salary_cpi ///
	log_workload   intermediate_c) texp(_t) vce(cluster jcode) 
	
* Model 2* 

stcox termlen  sex minority i.STATEBYTE if appointed==01,  ///
	tvc(percentS age  chief  ideoagree   log_salary_cpi ///
	log_workload   intermediate_c) texp(_t) vce(cluster jcode)
	
* Model 3 * 

stcox termlen  sex minority i.STATEBYTE if appointed==01,  ///
	tvc(pension_maxed age  chief  ideoagree   log_salary_cpi ///
	log_workload   intermediate_c) texp(_t) vce(cluster jcode)
	

*** Table 4 *** 

* Model 1 *

stcox termlen district sex minority i.STATEBYTE if appointed==0,  ///
	tvc(vested chief age ideoagree ideodist2 closelec log_salary_cpi ///
	 intermapp white_de log_workload intermediate_court) texp(_t) ///
	 vce(cluster jcode) 

* Model 2 * 
	 
stcox termlen district sex minority i.STATEBYTE if appointed==0,  ///
	tvc(percentS chief age ideoagree ideodist2 closelec log_salary_cpi ///
	 intermapp white_de log_workload intermediate_court) texp(_t) vce(cluster jcode)
	 
* Model 3*

stcox termlen district sex minority i.STATEBYTE if appointed==0,  ///
	tvc(pension_maxed chief age ideoagree ideodist2 closelec log_salary_cpi ///
	 intermapp white_de log_workload intermediate_court) texp(_t) vce(cluster jcode)


