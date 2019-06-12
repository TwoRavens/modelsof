******************************************************************************
*Before running this code, we need to run "Generate dataset-State" to generate
*the variables used in this simulation.
*This program generates the numbers to construct figure 4 in the main paper
*****************************************************************************
clear *

cd "XXXX define path to folders XXXX/ACS/"

********************************************************
prog define Simulation, rclass
args Y B 
 {


set more off
set matsize 5000
clear *

mat R=J(765,15,.) 

set seed 1

forvalues s=1(1)765  {

clear


use Final_datasets/State_`Y', clear
	
* Keep group in only one pair of years
summ Group if S==`s'
local a=r(mean)
keep if Group==`a'

* Generate DID dummy
gen T=year>=2000+`a' 
gen D=S==`s'
gen DD=(S==`s' & T==1)



summ id if D==1
mat R[`s',15]=r(mean)	


	* Keep information on M
	
	xtile M_bin2=M if T==0, n(2)
		
	summ M_bin2 if S==`s'
	mat R[`s',14]=r(mean)	
		
	* Generate DID estimator
	
	areg `Y' DD i.year [pw=P_jt], ab(S) 
	mat R[`s',1]=_b[DD]
		
	* Generate residuals with H_0 imposed
	
	areg `Y' i.year [pw=P_jt], ab(S) 
	predict eta_jt, residual


	* Define parameters to estimate linear combination Wj. This will be based on the linear combination of the treated unit.

	egen P_post=sum(P_jt) if D==1&T==1 	
	egen P_pre=sum(P_jt) if D==1&T==0

	gen temp=(P_jt/P_post) if D==1&T==1 
	replace temp=(P_jt/P_pre) if D==1&T==0

	egen a_1t=mean(temp), by(year)
	drop temp P_post P_pre

	* This variable will generate the linear combination Wj when we summ it for each j
	gen W=a_1t*eta_jt  if T==1
	replace W=-a_1t*eta_jt  if T==0

	* Generates the variable to estimate the var(W|M) function.
	gen q=(a_1t^2)*omega2/(P_jt)^2


	collapse (mean) D M_bin* (sum) W q P_jt, by(S)
	
	summ W [aw=P_jt], detail
	local mean=r(mean)
	
	gen W2 = (W-`mean')^2
		
	* Estimate var(W|M)
	reg W2 q [pw=P_jt] 
	predict var_M
	
	mat R[`s',10]=_b[q]
	mat R[`s',11]=_b[_cons]

	* Finite sample correction
	summ var_M 
	local min=r(min)

	gen test=var_M<0
	summ test
	mat R[`s',12]=r(mean)	

	summ test if D==1
	mat R[`s',13]=r(mean)	

	replace var_M=1 if `min'<0 & R[`s',10]<0
	replace var_M=q if `min'<0 & R[`s',11]<0
	
	gen W_normalized = W/sqrt(var_M)


	summ W if D==1
	local  treated=r(mean)
	
	summ W if D==0 [aw=P_jt]
	local control=r(mean)


	mat B=J(`B',3,.)
	
	summ S
	local N=r(N)
		
	* Run residual bootstrap with and without correction		
		
	forvalues Round=1(1)`B' {    
	

	
		gen h1=uniform()  
		gen h2=1 + int((`N'-1+1)*h1)

		gen W_tilde = W[h2] 

		
		gen W_tilde_corrected = W_normalized[h2] * sqrt(var_M) 	

			

		summ W_tilde if D==1
		local  treated=r(mean)
	
		summ W_tilde if D==0 [aw=P_jt]
		local control=r(mean)

		mat B[`Round',1]=`treated' - `control'
		
		
		summ W_tilde_corrected if D==1
		local treated=r(mean)
	
		summ W_tilde_corrected if D==0 [aw=P_jt]
		local control=r(mean)
		
		mat B[`Round',2]=`treated' - `control'


		drop h1 h2 *tilde* 
	
	}


* Calculate p-values

	set more off
	clear 
	svmat B
	
	** Without correction
		
	gen p_without=B1^2>R[`s',1]^2  if B1!=.  & R[`s',1]!=.


	summ p_without
	mat R[`s',2] = r(mean)

	
	** Correction, unknown variance
		
	gen p_FP=B2^2>R[`s',1]^2 if B2!=. & R[`s',1]!=.

	summ p_FP
	mat R[`s',3] = r(mean)


	*
	*
	display `s'
	display `s'
	*
	*
	
}

set more off	
clear
svmat R



ren R2 p_without
ren R3 p_FP
ren R1 alpha_hat

* Generate rejection variable

foreach x in 5 {  // Generate rejection rates

	gen reject_without_`x' = p_without<=`x'/100 if p_without!=.
	gen reject_FP_`x' = p_FP<=`x'/100 if p_FP!=.

		
}

ren R9 B
ren R10 A
ren R14 M_bin2
gen above=M_bin2==2 if M_bin2!=.
gen below=1-above if M_bin2!=.

ren R15 id


gen Y="`Y'"
gen Group = "State"

summ rej*

saveold Results/ACS_Bootstrap_State_`Y'_`B'.dta, replace


}
end
****************************

Simulation "l_wage" 5000

Simulation "employed" 5000

