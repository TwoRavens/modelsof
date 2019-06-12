****************************************************************
***This is the function that runs the boostrap with heteroskedasticity
***correction and without heteroskedasticity correction. The inputs in
***this function are:
***N: number of groups
***a: lower bound for the number of observations within group
***b: upper bound for the number of observations within group
***c: the value of "rho", intra-group correlation
***R: number of replications
******************************************************************

clear *

********************************************************
prog define Simulation, rclass
args N a b c power R
 {

 
 
qui {
 
set more off
set matsize 500
clear *

set seed `R'

mat R=J(500,14,.)


forvalues row=1(1)500  {


clear

* Set number of groups (N)
set obs `N'

gen S=_n
	
* Set M_j
	
	gen temp = runiform()
	
	gen M=`a' + int((`b'-`a'+1)*temp)
	
	drop temp
	
	gen D=_n==1

	* Keep information on M

	xtile M_bin10 = M, n(10)
			
	summ M_bin10 if D==1
	mat R[`row',8]=r(mean)		


	* Expand to T=2

	expand 2
	sort S
	bysort S: gen T=_n==2
	
	gen DD=D*T // This is the treatment dummy, which is equal to one only for group 1 at time 1
	
	
* Set correlated errors

	gen nu = rnormal()

* Expand to individual level

	expand M
	sort S T
	
	gen epsilon = rnormal() // Individual-level error
	 
* Generate Y
	
	gen Y = `c' * nu + sqrt(1-`c'^2) * epsilon
	replace Y = Y + `power'/10 if DD==1
	
	areg Y DD T, ab(S) robust
	mat R[`row',1]=_b[DD]
	mat R[`row',7]=_b[DD]/_se[DD] // t-statistic using robust s.e.
	
	
	collapse (mean) Y DD D M M_*, by(S T) // Aggregate at group x time level

	areg Y T [pw=M], ab(S) // Aggregate-level DID regression (with H_0 imposed). With M as weights => recovers individual-level DID estimator 

	predict eta_jt, residual

	gen numerator_W = (T-0.5)*eta_jt
	
	gen denominator = (T-0.5)^2

	collapse (mean) Y  M M_* D (sum) numerator* denominator, by(S)

	gen W_j = numerator_W/denominator // In this case with T=2, W_j = eta_j1 - eta_j0

	centile W_j, centile(2.5 97.5) // Calculate critical values for Conley and Taber (2011) method.
		
	mat R[`row',2] = r(c_1)    
	mat R[`row',3] = r(c_2)


* Estimate var(W_j|M_j) = G(M_j)

	summ W_j [fw=M], detail
	local mean=r(mean)
	
	gen W2 = (W_j-`mean')^2
	
	gen q=1/M
	
	reg W2 q [pw=M]
	predict G_M
	
	mat R[`row',9]=_b[q]
	mat R[`row',10]=_b[_cons]

	* Finite-sample adjustment
	summ G_M 
	local min=r(min)

	gen test=G_M<0
	summ test
	mat R[`row',11]=r(mean)	

	summ test if D==1
	mat R[`row',12]=r(mean)	

	replace G_M=1 if `min'<0 & R[`row',9]<0
	replace G_M=1/M if `min'<0 & R[`row',10]<0

	gen W_normalized = W_j/sqrt(G_M)

	gen W_normalized_real = W_j/sqrt(2*(`c'^2+(1-`c'^2)/M))	
	

	summ W_j if D==1
	local  treated=r(mean)
	
	summ W_j if D==0  [aw=M]
	local control=r(mean)

	

	mat B=J(500,3,.)




* Run residual bootstrap without correction, with correction using the estimated var(W_j|M_j), and with correction using the real var(W_j|M_j)
	
	forvalues Round=1(1)500 {     


	
		gen h1=uniform()  
		gen h2=1 + int((`N'-1+1)*h1)

		gen W_tilde = W_j[h2] 

		
		gen W_tilde_corrected = W_normalized[h2] * sqrt(G_M) 	

			
		gen W_tilde_corrected_real = W_normalized_real[h2] * sqrt(2*(`c'^2+(1-`c'^2)/M))	 	


		summ W_tilde if D==1
		local  treated=r(mean)
	
		summ W_tilde if D==0 [aw=M]
		local control=r(mean)

		mat B[`Round',1]=`treated' - `control'
		
		
		summ W_tilde_corrected if D==1
		local treated=r(mean)
	
		summ W_tilde_corrected if D==0 [aw=M]
		local control=r(mean)
		
		mat B[`Round',2]=`treated' - `control'


		summ W_tilde_corrected_real if D==1
		local treated=r(mean)
	
		summ W_tilde_corrected_real if D==0  [aw=M]
		local control=r(mean)
		
		mat B[`Round',3]=`treated' - `control'

		drop h1 h2 *tilde* 
	
	}

	
* Generate true variance for UMP test
	gen Var_W = 2*(`c'^2 + (1-`c'^2)/M)
	
	summ Var_W if D==1 
	local  Var_treated=r(mean)	

	summ Var_W if D==0 
	local  Var_control=r(mean)	

	local sd = sqrt(`Var_treated' + `Var_control'/(`N'-1))
	
	mat R[`row',13] = R[`row',1]/`sd'

	
	
	

	set more off
	clear 
	svmat B
	
* Calculate p-values
	
	** Without correction
		
	gen p_without=B1^2>R[`row',1]^2  if B1!=.  & R[`row',1]!=.


	summ p_without
	mat R[`row',4] = r(mean)

	
	** Correction, estimated variance
		
	gen p_FP=B2^2>R[`row',1]^2 if B2!=. & R[`row',1]!=.

	summ p_FP
	mat R[`row',5] = r(mean)

	** Correction, known variance
		
	gen p_FP_real=B3^2>R[`row',1]^2 if B3!=. & R[`row',1]!=.


	summ p_FP_real
	mat R[`row',6] = r(mean)


	
}

set more off	
clear
svmat R

ren R2 L_CT
ren R3 U_CT
ren R4 p_without
ren R5 p_FP
ren R6 p_FP_real

* Generate rejection variable for each method

gen reject_OLS =  R7<invnorm(0.025) | R7>invnorm(0.975) if R7!=.

gen reject_t =  R13<invnorm(0.025) | R13>invnorm(0.975) if R13!=.


gen reject_CT = R1<L_CT | R1>U_CT if L_CT!=.

foreach x in 5 {  

	gen reject_without_`x' = p_without<=`x'/100 if p_without!=.
	gen reject_FP_`x' = p_FP<=`x'/100 if p_FP!=.
	gen reject_FP_real_`x' = p_FP_real<=`x'/100 if p_FP_real!=.
	
}

ren R1 alpha_hat
ren R9 B
ren R10 A
ren R8 M_bin10

gen N=`N'
gen a=`a'
gen b=`b'
gen c=`c'

gen Round=`R'

gen Simulation=_n

drop R1*
order alpha_hat M* p* reject* 

}

saveold "Results/`N'_`a'_`b'_`c'_`power'_Round`R'.dta", replace


			
}
end
********************************************************






