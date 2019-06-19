clear all
set more off

// first, call in all the generic functions
run mc_funcs.do


timer on 1
// The fourth test, Omega={0.2,0.3,0.4,0.5,0.6,0.7,0.8}
global qt "0.2 0.3 0.4 0.5 0.6 0.7 0.8"
local capj=5
local simreps=1000
local bsreps=1000
scalar numl=`capj'
local numqt: word count $qt
scalar numqt=`numqt'
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
// the default is testmean(0), which indicates distributional test
// with the Omega set passed on through the local defined above.
simulate bsstat=r(bsstat) decchi=r(decf) decf=r(decf) df=r(df), reps(`simreps'): /*
*/mcmain_end, bsreps(`bsreps') obs(`n') b(`b')
sum
timer off 1
timer list 1
timer on 1
}  
