clear
mat drop _all
set more off
set matsize 1100
matrix results_fx_rs = [0]
matrix par_results_rs = [0,0,0,0,0,0,0,0] 
matrix results_fx_dth = [0]
matrix par_results_dth = [0,0,0,0,0,0,0,0,0,0,0,0] 
local i = 1

   while `i' < 101 {
   
insheet using "C:\Users\scott\Dropbox\Spatial Probit PSRM\PSRM_R&R\Monte_Code\Data\sp_tscs_phi30_rho10_`i'.csv", c

*Regime Switching 
probit v3 v4 v5 v6 if v1>1 
matrix beta = e(b)
matrix vcov = e(V)
matrix se = vecdiag(vcov)
matrix par_results_rs`i' = [beta[1,1],beta[1,2], beta[1,3],beta[1,4],se[1,1],se[1,2],se[1,3], se[1,4]]

mkmat v3
mkmat v5
mkmat v6 

if v3[72,1] == 1{
local p0 = _b[v4]*0.6889 + _b[v5]*(v5[51,1]-0.25) + _b[v6]*v6[51,1] + _b[_cons]
matrix results_fx_rs`i' = normal(`p0' + _b[v5]*0.25) - normal(`p0') 
}

else{
local p0 = _b[v4]*0.6889 + _b[v5]*v5[51,1] + _b[v6]*v6[51,1] + _b[_cons]
matrix results_fx_rs`i' = normal(`p0' + _b[v5]*0.25) - normal(`p0')
}

matrix results_fx_rs = [results_fx_rs\ results_fx_rs`i']
mat drop results_fx_rs`i'

matrix par_results_rs = [par_results_rs \ par_results_rs`i']
mat drop par_results_rs`i'



*Discrete Time Hazard  
btscs v3 v2 v1, g(pyrs)
gen pyrs2 = pyrs^2
gen pyrs3 = pyrs^3

probit v3 v4 v5 pyrs pyrs2 pyrs3 if v1>1
matrix beta = e(b)
matrix vcov = e(V)
matrix se = vecdiag(vcov)
matrix par_results_dth`i' = [beta[1,1],beta[1,2], beta[1,3],beta[1,4],beta[1,5],beta[1,6], se[1,1],se[1,2],se[1,3], se[1,4],se[1,5],se[1,6] ]

mkmat pyrs
mkmat pyrs2
mkmat pyrs3 



if v3[72,1] == 1{
local p0 = _b[v4]*0.6889 + _b[v5]*(v5[51,1]-0.25) + _b[pyrs]*pyrs[51,1] + _b[pyrs2]*pyrs2[51,1] + _b[pyrs3]*pyrs3[51,1] + _b[_cons]
matrix results_fx_dth`i' = normal(`p0' + _b[v5]*0.25) - normal(`p0') 
}

else{
local p0 = _b[v4]*0.6889 + _b[v5]*v5[51,1] + _b[pyrs]*pyrs[51,1] + _b[pyrs2]*pyrs2[51,1] + _b[pyrs3]*pyrs3[51,1] + _b[_cons]
matrix results_fx_dth`i' = normal(`p0' + _b[v5]*0.25) - normal(`p0')
}


matrix results_fx_dth = [results_fx_dth\ results_fx_dth`i']
mat drop results_fx_dth`i'


matrix par_results_dth = [par_results_dth \ par_results_dth`i']
mat drop par_results_dth`i'
*/

drop _all 
 
      local i = `i' + 1

}

mat dir 
svmat results_fx_rs
svmat results_fx_dth 

drop in 1

sum results_fx_rs results_fx_dth 
