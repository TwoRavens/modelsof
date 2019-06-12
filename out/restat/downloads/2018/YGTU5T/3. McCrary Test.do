********************************************************************************
*                                                                              *
*                    MCCRARY TEST FOR CONTINUOUS RUNNING VARIABLE              *
*                                                                              *
********************************************************************************


adopath + "U:\Current projects\Probleemwijken\Stata\Ado\" // Set adopath
cd "U:\" // Set directory
local threshold 7.3
local bandwidth 3.5
clear
set mem 2G
set more off
set seed 1234567


use "Data\kw_pc4.dta", clear
*use "Data\NVM_20002014.dta", clear
*drop if kwadjacent == 1
*collapse (mean) zscore, by(pc4)
DCdensity zscore, breakpoint(`threshold') generate(Xj Yj r0 fhat se_fhat) graphname(DCdensity_example.eps) 

keep Yj Xj r0 fhat se_fhat 

export excel using "Results\Figures.xlsx", sheet("Fig 2") sheetmodify firstrow(variables)


clear all

use "Data\kw_pc4.dta", clear
*use "Data\NVM_20002014.dta", clear
*drop if kwdist > 0 & kwdist < 2.5
*collapse (mean) zscore, by(pc4)

keep if zscore > (`threshold'-`bandwidth') & zscore < (`threshold'+`bandwidth')

DCdensity zscore, breakpoint(`threshold') generate(Xj Yj r0 fhat se_fhat) graphname(DCdensity_example.eps)

keep Yj Xj r0 fhat se_fhat 

export excel using "Results\Figures.xlsx", sheet("Fig B1") sheetmodify firstrow(variables)
