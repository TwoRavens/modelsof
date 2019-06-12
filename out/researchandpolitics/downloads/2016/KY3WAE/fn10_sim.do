/*This STATA code replicates results for Footnote 10*/
#d ;
set more off ;
clear ;
set seed 456789 ;
cap mkdir "Change Directory Here" ;
global nocoint "Change Directory Here" ;
cap mkdir "$nocoint\results" ;

/*bivariate*/
#d ;
cap program drop bivariate ;
program define bivariate, rclass ;
syntax [, obs(integer 200)] ;
	#d ;
	drop _all ;
	set obs `obs' ;
	gen t = _n ;
	tsset t ;
	gen e_1 = invnorm(uniform()) ;
	gen x_1=e_1 if t==1 ;
	gen u=invnorm(uniform()) ;
	gen y=u if t==1 ;
	replace x_1= l.x_1+e_1 if t>1 ;
	replace y= l.y + u if t>1 ;
	/*drop the first 100 observations*/
		drop if t<=100 ;
		/*Error Correction Model (ECM)*/
		reg d.y l.y d.x_1 l.x_1 ;
		return scalar beta_ly = _b[l.y] ; /*Save these coefficients to check bias.*/
		return scalar obs=`obs' ;
end ;

#d ;
postfile bivariate 
obs beta_mean_ly 
				using "$nocoint\results\nocoint_1", replace ; 
foreach obs of numlist 200 300 { ;
				simul obs=r(obs) beta_ly=r(beta_ly), 
				reps(10000): 
				bivariate, obs(`obs') ;			
				/*Save coefficients*/
				local obs_n=`obs'-100 ;
				sum beta_ly ; 
				local beta_mean_ly = round(r(mean), .001) ; 
				post bivariate (`obs_n') (`beta_mean_ly') ;
				} ;
				postclose bivariate ;			
clear ;

/*five IVs*/
#d ;
cap program drop fiveivs ;
program define fiveivs, rclass ;
syntax [, obs(integer 200)] ;
	#d ;
	drop _all ;
	set obs `obs' ;
	gen t = _n ;
	tsset t ;
	gen e_1 = invnorm(uniform()) ;
	gen x_1=e_1 if t==1 ;
	gen e_2 = invnorm(uniform()) ;
	gen x_2=e_2 if t==1 ;
	gen e_3 = invnorm(uniform()) ;
	gen x_3=e_3 if t==1 ;
	gen e_4 = invnorm(uniform()) ;
	gen x_4=e_4 if t==1 ;
	gen e_5 = invnorm(uniform()) ;
	gen x_5=e_5 if t==1 ;
	gen u=invnorm(uniform()) ;
	gen y=u if t==1 ;
	replace x_1= l.x_1+e_1 if t>1 ; 
	replace x_2= l.x_2+e_2 if t>1 ;
	replace x_3= l.x_3+e_3 if t>1 ;
	replace x_4= l.x_4+e_4 if t>1 ;
	replace x_5= l.x_5+e_5 if t>1 ;
	replace y= l.y + u if t>1 ;
		drop if t<=100 ;
		/*Error Correction Model (ECM)*/
		reg d.y l.y d.x_1 l.x_1 d.x_2 l.x_2 d.x_3 l.x_3 d.x_4 l.x_4 d.x_5 l.x_5 ;
		return scalar beta_ly = _b[l.y] ; /*Save these coefficients to check bias.*/
		return scalar obs=`obs' ;
end ;

#d ;
postfile fiveivs 
obs beta_mean_ly 
				using "$nocoint\results\nocoint_5", replace ; 
foreach obs of numlist 200 300 { ;
				simul obs=r(obs) beta_ly=r(beta_ly), 
				reps(10000): 
				fiveivs, obs(`obs') ;			
				/*Save coefficients*/
				local obs_n=`obs'-100 ;
				sum beta_ly ; 
				local beta_mean_ly = round(r(mean), .001) ; 
				post fiveivs (`obs_n') (`beta_mean_ly') ;
				} ;
				postclose fiveivs ;			
clear ;

