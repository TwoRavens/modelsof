set seed 112233 

clear all
set mem 5000m
set more off			
capture log close
log using corrcov_TI.log,replace 
log off


forvalues i=0(1)2 {
	use earnings_long,clear
	quietly summ cohort if bob==`i'
	global min_`i'=_result(5)
	global max_`i'=_result(6)
	forvalues y=${min_`i'}(3)${max_`i'} {
		use earnings_long,clear
		keep if bob == `i'
		ta year, ge(years)
		di `y'
		ge agesq=ageC^2
		ge eta=year-yob
		sort pnr eta
		ge d3040=eta>=30 & eta<=40
		regress  logearn years* ageC agesq if cohort==`y',noc
		predict res if cohort==`y',resid
		keep pnr pnrf logearn res year yob bob  age* cohort d3040
		keep if cohort==`y'
		compress
		save res_`i'_`y',replace
	}
}


forvalues i=0(1)2 {
	use earnings_long,clear
	quietly summ cohort if bob==`i'
	global min_`i'=_result(5)
	global max_`i'=_result(6)
	use res_`i'_${min_`i'}
	local j = ${min_`i'} + 3
	forvalues y = `j'(3)${max_`i'} {			/*puts residualised earnings back together by bob*/
		append using res_`i'_`y'
		erase res_`i'_`y'.dta
	}
	erase res_`i'_${min_`i'}.dta

	bysort pnr: ge mres=sum(res)/_N						/*long term earnings as the average earnings in that range*/
	bysort pnr: gen mres3040=sum(res*d3040)/sum(d3040)	/*or in 30-40*/
	bysort pnr: keep if _n==_N
	
	reg mres
	predict rmres`i', resid						/*take deviations from generational means*/
	xtile prmres`i' = rmres`i', nq(100)
	reg mres3040
	predict rmres3040`i',resid
	xtile prmres3040`i' = rmres3040`i', nq(100)
	keep pnrf rmres`i' rmres3040`i'  prmres`i' prmres3040`i'  
	save res_`i',replace
}


use res_0
merge 1:1 pnrf using res_1
drop _m
merge 1:1 pnrf using res_2
drop _m

qui reg rmres0 rmres1 //ancillary regression so does not get confused with the eclass commands


cap program drop foo2
program define foo2, eclass
	tempname b V
	matrix `b' = e(b)
	matrix `V' = e(V)
	matrix define `V' = Vi
	matrix define `b' = bi
	ereturn post `b' `V' 
end


* computes intergenerational shares for permanent income, permennet income 30-40
* percentiles of permanent income, percentiles of permanent income 30-40

foreach j in rmres rmres3040 prmres prmres3040 {
		forv t = 0(1)1 {
			local t1 = `t' +1
			forv s = `t1'(1)2 {
				pwcorr `j'`t' `j'`s', obs
				sca n`t'`s'=r(N)
				bootstrap r(cov_12): corr `j'`t' `j'`s' if `j'`t'!=. &  `j'`s'!=. , c
				mat c`t'`s'= e(b)
				mat coln c`t'`s' = c`t'`s'
				mat v`t'`s' = e(V)
				mat coln v`t'`s' = c`t'`s'

			}
		}
		mat bi = (c01,c02,c12)
		mat vi = (v01,v02,v12)
		mat Vi = diag(vi)
		preserve
		foo2
		log on
		nlcom (c01:_b[c01]) (c02:_b[c02]) (c12:_b[c12]) (cI: (n01/(n01+n02))*_b[c01] + (n02/(n01+n02))*_b[c02]) ///
		 (Ishare_`j': ((n01/(n01+n02))*_b[c01] + (n02/(n01+n02))*_b[c02]) /_b[c12])
		log off
		restore
}
				
				
* computes sibling and intergenerational correlation for permanent income, permanent income 30-40
* percentiles of permanent income, percentiles of permanent income 30-40

foreach j in rmres rmres3040 prmres prmres3040 {
		forv t = 0(1)1 {
			local t1 = `t' +1
				forv s = `t1'(1)2 {
				log on
					bootstrap r(rho): corr `j'`t' `j'`s' if `j'`s'!=.
				log off	
			}
		}
}







log off

*****************************************
*PRESENT DISCOUNTED VALUES
*****************************************

clear all
set mem 5000m
set more off			
use earnings_long,clear

ge eta=year - yob

ge de05=earnings/((1+.05)^(eta-25))
ge de01=earnings/((1+.01)^(eta-25))
ge de03=earnings/((1+.03)^(eta-25))







save earnings_long_rate, replace

forvalues i=0(1)2 {
	use earnings_long_rate,clear
	quietly summ cohort if bob==`i'
	global min_`i'=_result(5)
	global max_`i'=_result(6)
	forvalues y=${min_`i'}(3)${max_`i'} {
		use earnings_long_rate,clear
		keep if bob == `i'
		ta year, ge(years)
		di `y'
		ge agesq=ageC^2
		keep pnr pnrf logearn de* year yob bob  age* cohort 
		keep if cohort==`y'
		compress
		save res_`i'_`y',replace
	}
}


forvalues i=0(1)2 {
	use earnings_long_rate,clear
	quietly summ cohort if bob==`i'
	global min_`i'=_result(5)
	global max_`i'=_result(6)
	use res_`i'_${min_`i'}
	local j = ${min_`i'} + 3
	forvalues y = `j'(3)${max_`i'} {			 
		append using res_`i'_`y'
		erase res_`i'_`y'.dta
	}
	foreach k in 01 03 05 {
		bysort pnr: ge pdv`k'_`i'=sum(de`k')/_N				/*per-year-pdv*/
		ge lpdv`k'_`i' = log(pdv`k'_`i')						/*and its log*/
	}
	bysort pnr: keep if _n==_N
	keep pnrf pdv* lpdv* bob
	save res_`i',replace
	erase res_`i'_${min_`i'}.dta
}



use res_0
merge 1:1 pnrf using res_1
drop _m
merge 1:1 pnrf using res_2
drop _m

save pdv,replace

*ancillary
qui reg pdv01_0 lpdv01_0


cap program drop foo2
program define foo2, eclass
	tempname b V
	matrix `b' = e(b)
	matrix `V' = e(V)
	matrix define `V' = Vi
	matrix define `b' = bi
	ereturn post `b' `V' 
end





foreach j in lpdv01_ lpdv03_ lpdv05_   {
		forv t = 0(1)1 {
			local t1 = `t' +1
			forv s = `t1'(1)2 {
				pwcorr `j'`t' `j'`s', obs
				sca n`t'`s'=r(N)
				bootstrap r(cov_12): corr `j'`t' `j'`s' if `j'`t'!=. &  `j'`s'!=. , c
				mat c`t'`s'= e(b)
				mat coln c`t'`s' = c`t'`s'
				mat v`t'`s' = e(V)
				mat coln v`t'`s' = c`t'`s'

			}
		}
		mat bi = (c01,c02,c12)
		mat vi = (v01,v02,v12)
		mat Vi = diag(vi)
		preserve
		foo2
		log on
		nlcom (c01:_b[c01]) (c02:_b[c02]) (c12:_b[c12]) (cI: (n01/(n01+n02))*_b[c01] + (n02/(n01+n02))*_b[c02]) ///
		 (Ishare_`j': ((n01/(n01+n02))*_b[c01] + (n02/(n01+n02))*_b[c02]) /_b[c12])
		log off
		restore
}
				
				

foreach j in lpdv01_ lpdv03_ lpdv05_  {
		forv t = 0(1)1 {
			local t1 = `t' +1
				forv s = `t1'(1)2 {
				log on
					bootstrap r(rho): corr `j'`t' `j'`s' if `j'`s'!=.
				log off	
			}
		}
}


log off
*****************************************
*YEARS OF EDUCATION
*****************************************
clear all
set mem 5000m
set more off			

use earnings_long,clear
bysort pnr: keep if _n==1
keep if bob > 0
keep pnr pnrf bob
sort pnr
merge 1:1 pnr using fatherandoffspringschooling.dta, keepusing(educ educf) 
keep if _merge == 3
drop _m
sort pnrf bob
keep  pnrf bob educ educf
save educ_data,replace

use educ_data, clear
keep if bob==1
keep  pnrf  educ 
rename educ edu_b1
sort pnrf
save edu_b1, replace

use educ_data, clear
keep if bob==2
keep  pnrf  educ 
rename educ edu_b2
sort pnrf
save edu_b2, replace

use educ_data, clear
keep  pnrf  educf  
bysort pnrf: keep if _n==1
rename educf edu_b0
sort pnrf
save edu_b0, replace

use edu_b1, clear
merge 1:1 pnrf using edu_b0
sort pnrf
drop _merge
merge 1:1 pnrf using edu_b2
sort pnrf
drop _merge

save cov_edu,replace


qui reg edu_b0 edu_b1


cap program drop foo2
program define foo2, eclass
	tempname b V
	matrix `b' = e(b)
	matrix `V' = e(V)
	matrix define `V' = Vi
	matrix define `b' = bi
	ereturn post `b' `V' 
end




		forv t = 0(1)1 {
			local t1 = `t' +1
			forv s = `t1'(1)2 {
				pwcorr edu_b`t' edu_b`s', obs
				sca n`t'`s'=r(N)
				bootstrap r(cov_12): corr edu_b`t' edu_b`s'  if edu_b`t'!=. & edu_b`s'!=. , c
				mat c`t'`s'=e(b)
				mat coln c`t'`s' = c`t'`s'
				mat v`t'`s' = e(V)
				mat coln v`t'`s' = c`t'`s'

			}
		}
		mat bi = (c01,c02,c12)
		mat vi = (v01,v02,v12)
		mat Vi = diag(vi)
		preserve
		foo2
		log on
		nlcom (c01:_b[c01]) (c02:_b[c02]) (c12:_b[c12]) (cI: (n01/(n01+n02))*_b[c01] + (n02/(n01+n02))*_b[c02]) ///
		 (Ishare_edu: ((n01/(n01+n02))*_b[c01] + (n02/(n01+n02))*_b[c02]) /_b[c12])
		 log off
		restore

		
		
		
		forv t = 0(1)1 {
			local t1 = `t' +1
				forv s = `t1'(1)2 {
				log on
					bootstrap r(rho): corr edu_b`t' edu_b`s' if edu_b`s'!=.
				log off	
			}
		}
		
		

log close


 
 
 
 
 
 
 
 






