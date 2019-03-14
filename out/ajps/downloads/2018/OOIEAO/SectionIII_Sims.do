***Lost in Aggregation***
***Cook and Weidmann*****
***July 5, 2018*********
***Section III Sims******

clear all 
set more off 
set matsize 800

**set working directory here**
*cd "C:\Users\..."

**install package for weighted least squares (if not already installed)**
findit wls0

**Fixed conditions in the simulated data**
set seed 586268

local N = 1000 
set obs `N' 

gen id = _n
gen x = uniform()

scalar beta0 = 2 
scalar beta1 = 3 
gen y = . 

gen w1 = . 
gen w2 = . 
gen w3 = . 
gen w_close = . 


matrix m1_mse_b1 = J(1,1,.) 
matrix m2_mse_b1 = J(1,1,.) 
matrix m3_mse_b1 = J(1,1,.)
matrix m4_mse_b1 = J(1,1,.) 
matrix m5_mse_b1 = J(1,1,.)
matrix m6_mse_b1 = J(1,1,.)


forvalues v = 1/30{

matrix b_m1 = J(1,2,.) 
matrix b_m2 = J(1,2,.) 
matrix b_m3 = J(1,2,.) 
matrix b_m4 = J(1,2,.) 
matrix b_m5 = J(1,2,.) 
matrix b_m6 = J(1,5,.) 


forvalues tr = 1/500 {

**Generates the simulated data**
qui replace y = beta0 + beta1*x  + rnormal()
scalar rerr = `v'*0.1 
gen serr = rnormal(0,0.1)
replace w1 = y + rnormal()*rerr + serr[1] 
replace w2 = y + rnormal()*rerr + serr[2]
replace w3 = y + rnormal()*rerr + serr[3]

forvalues i =1/3{
       gen norm`i' = rnormal()
}


forval i = 1/3 {
  replace w`i' = . if norm`i' <= -1
}

qui gen w1_dist = abs(w1 - y) 
qui gen w2_dist = abs(w2 - y) 
qui gen w3_dist = abs(w3 - y) 

qui replace w_close = w1 if w1_dist < w2_dist & w1_dist < w3_dist & !missing(w1_dist) 
qui replace w_close = w2 if w2_dist < w1_dist & w2_dist < w3_dist  & !missing(w2_dist) 
qui replace w_close = w3 if w3_dist < w1_dist & w3_dist < w2_dist  & !missing(w3_dist) 

gen miss = rnormal()
gen w_close_err_50 = . 
qui replace w_close_err_50 = w_close if miss > 0 
replace w_close_err_50 = w3 if miss <= 0 & w3!=w_close & !missing(w3_dist)
replace w_close_err_50 = w2 if miss <= 0 & w2!=w_close & !missing(w2_dist)
replace w_close_err_50 = w1 if miss <= 0 & w1!=w_close & !missing(w1_dist)

drop w1_dist w2_dist w3_dist 

egen w_avg =rmean(w1 w2 w3 )
egen wnonmissing = rownonmiss(w1 w2 w3)

**Run the estimators** 
qui reg w1 x 
qui matrix b_m1 = b_m1 \ e(b)

qui reg w_close x 
qui matrix b_m2 = b_m2 \ e(b)

qui reg w_close_err_50 x 
qui matrix b_m3 = b_m3 \ e(b)

qui reg w_avg x 
qui matrix b_m4 = b_m4 \ e(b)

qui wls0 w_avg x, wvar(wnonmissing) type(e2) 
qui matrix b_m5 = b_m5 \ e(b)

qui reshape long w, i(id) j(r)
qui mixed w x ||_all:R.r ||id:, difficult iterate(200)
qui matrix b_m6 = b_m6 \ e(b)
qui reshape wide w, i(id) j(r)

display as text "iteration # = " `v' `tr'
drop miss w_close_err_50 w_avg serr wnonmissing  norm* 
}

svmat b_m1 
svmat b_m2
svmat b_m3
svmat b_m4
svmat b_m5
svmat b_m6

**Evaluate the estimators** 
gen m1_dif = (beta1 - b_m11)^2
sum m1_dif
qui matrix m1_mse_b1 = m1_mse_b1 \ r(mean) 

gen m2_dif = (beta1 - b_m21)^2
sum m2_dif
qui matrix m2_mse_b1 = m2_mse_b1 \ r(mean) 

gen m3_dif = (beta1 - b_m31)^2
sum m3_dif 
qui matrix m3_mse_b1 = m3_mse_b1 \ r(mean)  

gen m4_dif = (beta1 - b_m41)^2
sum m4_dif
qui matrix m4_mse_b1 = m4_mse_b1 \ r(mean)  

gen m5_dif = (beta1 - b_m51)^2
sum m5_dif 
qui matrix m5_mse_b1 = m5_mse_b1 \ r(mean) 

gen m6_dif = (beta1 - b_m61)^2
sum m6_dif 
qui matrix m6_mse_b1 = m6_mse_b1 \ r(mean)  

drop b_m1* b_m2* b_m3* b_m4* b_m5* b_m6* m1_dif m2_dif m3_dif m4_dif m5_dif m6_dif
matrix drop b_m1 b_m2 b_m3 b_m4 b_m5 b_m6
}

svmat m1_mse_b1
svmat m2_mse_b1
svmat m3_mse_b1
svmat m4_mse_b1
svmat m5_mse_b1
svmat m6_mse_b1


**Generate plots to compare estimator performance**
egen number = seq(), from(0) to(30)
gen rep_var = (number*10)/100
 
  ***Figure 3***
 graph twoway scatter m1_mse_b11 m2_mse_b11 m3_mse_b11 m6_mse_b11 rep_var, mcolor(gs5 gs7 gs9 gs3) msymbol(x + sh t) ///
 graphregion(color(white)) bgcolor(white) ///
 xtitle("Report Error Variance") ///
 ytitle("Root Mean Squared Error") ///
 legend(col(1) position(3) ring(3) region(lcolor(white)) subtitle("{bf:Model}") order(1 "Single Report - OLS" 2 "Best Report - OLS (100%)" 3  "Best Report - OLS (50%)"  4 "All Reports - HLM")) 

 **uncomment below to export the figure as pdf**
 *graph export reportasY_maintext_rmse_figure3.pdf, replace

  ***Figure 4***
 graph twoway scatter m4_mse_b11 m5_mse_b11 m6_mse_b11 rep_var, mcolor(gs5 gs7 gs3) msymbol(o dh t) ///
 graphregion(color(white)) bgcolor(white) ///
 xtitle("Report Error Variance") ///
 ytitle("Root Mean Squared Error") ///
 legend(col(1) position(3) ring(3) region(lcolor(white)) subtitle("{bf:Model}") order(1 "Mean Reports - OLS" 2 "Mean Report - WLS"  3 "All Reports - HLM")) 

 **uncomment below to export the figure as pdf**
 *graph export reportasY_maintext_rmse_figure4.pdf, replace

 

 
