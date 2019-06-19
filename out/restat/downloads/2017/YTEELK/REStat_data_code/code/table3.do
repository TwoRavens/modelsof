********************************************************************************
* This file: create Table 3
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
log using "results/table3.log", replace

********************************************************************************

cap program drop main
program main
    use_data_cnty_year
    regs_unweighted
    create_table3
end

cap program drop export_results
program export_results
    esttab _all using "results/table3.csv", append ///
        drop(stateyrv* $controls _cons) stats(F_stat N, fmt(1 0)) ///
        b(3) se(3) nolz gaps depvars numbers
    eststo clear
    estimates clear
end

cap program drop run_2sls
program run_2sls
    // generic function to run 2SLS regressions
    args mining iv period sample

    tab stateyr if `mining'_state==1 & (`period') & (`sample'), gen(stateyrv)
    eststo: ivreg2 D.log_real_ssi (D.log_real_earn = `iv') ///
        $controls stateyrv* $regWeight, cluster(fips) savefirst

        // save first stage and F-stat for excluded instruments
        tsunab ivs: `iv'
        local ivreg2result = e(firsteqs)
        foreach model of local ivreg2result {
            estimates restore `model'
            test `ivs'
            estadd scalar F_stat = r(F)
        }

    drop stateyrv*
    export_results
end

cap program drop create_table3
program create_table3
    // Column 1: Oil & Gas 1970–1993
    run_2sls og "${og_oilprice_cont_67}" "tin(1970, 1993)" "${ssi_bal}"
    // Column 2: Oil & Gas 1970–1993, excluding 1973–74
    run_2sls og "${og_oilprice_cont_67}" "tin(1970, 1993) & year!=1974" "${ssi_bal}"
    // Column 3 is from Black et al
    // Column 4: Replication of Black et al
    run_2sls coal "${coal_price_res}" "tin(1970, 1993)" "${ssi_unbal}"
    // Column 5: same as column 4 but excluding 1973–74 change
    run_2sls coal "${coal_price_res}" "tin(1970, 1993) & year!=1974" "${ssi_unbal}"
end

********************************************************************************

main

log close
exit
