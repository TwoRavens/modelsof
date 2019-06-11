*This code will implement a parametric bootstrap for effect confidence intervals. See final footnote.

clear
mat drop _all
set matsize 1000
set more off

cd C:\Users\jch61\Desktop\Summer_Work_2014\Boehmke_etal\FINAL_SUBMISSION\PA_REPLICATION_FILES\

use "effects.dta", clear
mkmat var1-var4, matrix(X)
mkmat var5-var10, matrix(b)
mat b = b[1,1..6]
mkmat var11-var16, matrix(V)
mat V = V[1..6,1..6]
drop _all

use "alliance_W_rs.dta", clear
mkmat var1-var44, matrix(W)
drop _all

local nobs = 44
matrix eye = I(`nobs')

matrix erw = eye - b[1,5]*W
matrix mult = inv(erw)
matrix lincomb = X*[b[1,1],b[1,2],b[1,3],b[1,4]]'
matrix pred = mult*lincomb


matrix coeff = [b[1,5],b[1,1]]                                                          

matrix VCVM = [V[5,5], V[5,1] \ V[1,5], V[1,1]]	
local draw = 1000                                                 
drop _all
corr2data rho_drw beta_drw, n(`draw') means(coeff) cov(VCVM)
mkmat rho_drw-beta_drw, matrix(draws)
drop _all

local i = 1
   while `i' < `draw'+1 {

	matrix estcf1 = eye - draws[`i',1]*W 
	matrix estcf = draws[`i',2]*inv(estcf1)
	matrix estcf_col = estcf[1...,27]                     /*Need to Change this for Different Countries.*/                          
	svmat estcf_col, n(estcf_col`i')                      /* Country 27 is Germany. Country 29 is Italy.*/
	mat drop estcf1 estcf estcf_col
      local i = `i' + 1

           }
mkmat estcf_col11-estcf_col`draw'1, matrix(estcf_set)
matrix estcf_set_tr = estcf_set'
drop _all
svmat estcf_set_tr, n(estcf)


//Provides the percentiles for all
sum estcf1-estcf44, d
