clear all
set more off

// first, call in all the generic functions
run mc_funcs.do

timer on 1
// The fifth test, the mean test
local capj=5
local simreps=1000
local bsreps=1000
scalar numl=`capj'
// set the degree of violation of H0
/* for b=0 and b=3 cases reported in Table A.1, just change the b value below  */
local b=2
matrix decchi=J(5,1,.)
// loop over 5 differet sample sizes reported in Table A.1.
forval nind=1/5{
local n=500*`nind'
clear
set seed 123
// the simulation function takes in # of simulations, # bootstrap for variance-covariance
// estimation, # of observations, b value of the DGP
// mcmain_end indicates it's DGP 2 for the endogenouse
// testmean(1) indicates conducting the mean test
simulate bsstat=r(bsstat) decchi=r(decf) decf=r(decf) df=r(df), reps(`simreps'): /*
*/mcmain_end, bsreps(`bsreps') obs(`n') b(`b') testmean(1)
sum
timer off 1
timer list 1
timer on 1
}  
