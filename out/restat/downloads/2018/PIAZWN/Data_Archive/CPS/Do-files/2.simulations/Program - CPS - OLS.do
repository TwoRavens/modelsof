*******************************************************************************
**Using the data generated by the program "Generate dataset.do", this code 
**produces the results in columns (1)-(2) of Table 4.
********************************************************************************
clear *
set mem 2000m
********************************************************
prog define Simulation, rclass
args Y Range
 {
 
set more off
set matsize 5000
clear *

set seed 1

cd "XXXX define path to folders XXXX/CPS"

use "Final Dataset/CPS.dta", clear

merge m:1 year state using "Final Dataset/M_bin.dta"

egen S=group(state) 

keep if `Y'!=.
gen c=1
egen M=sum(c), by(state year)


mat R=J(5000,15,.)


local row=1

forvalues s=1(1)51 {

	local end=2015-`Range'

	forvalues year=1979(1)`end' {

	preserve

	* Keep only 2 years
	keep if inrange(year,`year',`year'+`Range')

	* Generate DID dummy
	gen T=year>=`year'+`Range'/2
	gen D=(S==`s')
	gen DD=(S==`s' & T==1)

	gen M0 = M if T==0
	gen M1 = M if T==1


	mat R[`row',8]=`year'
	mat R[`row',9]=`s'


	* OLS individual level
	
	areg `Y' DD i.year [pw= weight], ab(S) 
	mat R[`row',1]=_b[DD]
	mat R[`row',2]=_b[DD]/_se[DD]


	* Keep information on M
	
	summ M_bin2 if S==`s' & year==`year'
	mat R[`row',6]=r(mean)	
	

 	
	*
	*
	display `s'
	display `s'
	*
	*
	
	local ++row
	
	restore
	
	}
	
}

set more off	
clear
svmat R


gen reject_OLS = R2<invnorm(0.025) | R2>invnorm(0.975) if R2!=.

ren R6 M_bin2
ren R8 year
ren R9 S
ren R10 B
ren R11 A
gen above=M_bin2==2 if M_bin2!=.
gen below=1-above if M_bin2!=.

gen Y="`Y'"

summ rej*

gen Range=`Range'

saveold "Results/CPS_OLS_`Y'_`Range'.dta", replace


}
end
****************************


foreach Range in 1 3 5 7  {

Simulation employed  `Range'

Simulation l_wage `Range'

}


