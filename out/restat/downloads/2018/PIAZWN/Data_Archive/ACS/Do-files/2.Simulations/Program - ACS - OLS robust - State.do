******************************************************************************
*Before running this code, we need to run "Generate dataset-State" to generate
*the variables used in this simulation.
*This program generates part of the results in Table 3 in the main paper
*****************************************************************************
clear *
set mem 2000m
********************************************************
prog define Simulation, rclass
args Y
 {
 
set more off
set matsize 6000

cd "XXXX define path to folders XXXX/ACS"

use Final_datasets/State_individual, clear

summ S
local a=r(max)

mat R=J(`a',11,.)

forvalues s=1(1)`a' {

preserve

* Keep group in only one pair of years
summ Group if S==`s'
local a=r(mean)
keep if Group==`a'

* Generate DID dummy
gen T=year>=2000+`a' 
gen DD=(S==`s' & T==1)


areg `Y' DD i.year [pw=perw], ab(S) robust
mat R[`s',1]=_b[DD]
mat R[`s',2]=_b[DD]/_se[DD]


	* Keep information on M
	
	summ M_bin2 if DD>0
	mat R[`s',9]=r(mean)	
	
	*summ M_bin10 if DD>0
	*mat R[`s',10]=r(mean)	
	
	sum id if DD>0
	mat R[`s',11]=r(mean)	
	


	*
	*
	display "`s',  Y=`Y'"     
	display `s'
	*
	*

	restore
	
}


set more off	
clear
svmat R
	
rename R11 id	
	
	
gen t = R2

rename R9 M_bin2

rename R10 M_bin10

gen reject_OLS = R2<invnorm(0.025) | R2>invnorm(0.975) if R2!=.


gen Y="`Y'"
gen Group = "State"

saveold Results/ACS_OLS_robust_State_`Y'.dta, replace

			
}
end
********************************************************

Simulation employed

Simulation l_wage





