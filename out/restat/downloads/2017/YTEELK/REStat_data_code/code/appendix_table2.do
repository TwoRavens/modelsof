********************************************************************************
* This file: create Appendix Table 2
********************************************************************************

// preambles
set more off
set matsize 4000
clear all
macro drop _all

// set working directory
local path "~/Dropbox/Research/Oil_Transfer/prep_for_pub/REStat_data_code/"
cd `path'

// import project routines
do "code/project_routines.do"

cap log close
log using "results/appendix_table2.log", replace

********************************************************************************

cap program drop main
program main
    use_data_state_year
    create_appendix_table2
end

cap program drop create_appendix_table2
program create_appendix_table2
    // keep oil states in 1974
    keep if year == 1974
    keep if inlist(fips_st, 8, 20, 22, 28, 30, 35, 38, 40, 48, 49, 56)

    gen mining_emp_share = minenumemp / cbpnumemp
    gen ogest_share = ognumest / minenumest

    gsort -mining_emp_share
    list state_name mining_emp_share ogest_share

    // Column 3 is manucally calculated using the data from 1967 CBP book
    // source: https://hdl.handle.net/2027/uc1.32106017493179
end

********************************************************************************

main

log close
exit
