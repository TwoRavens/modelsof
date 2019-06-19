********************************************************************************
* This file: create Appendix Table 3
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
log using "results/appendix_table3.log", replace

********************************************************************************

cap program drop main
program main
    use_data_cnty_year
    regs_weighted
    create_appendix_table3
end

cap program drop export_results
program export_results
    esttab _ivreg2_* using "results/appendix_table3.csv", append ///
        drop(stateyrv* $controls _cons) stats(F_stat N, fmt(1 0)) ///
        b(3) se(3) nolz gaps depvars numbers
    eststo clear
    estimates clear
end

cap program drop run_2sls
program run_2sls
    // generic function to run 2SLS regressions
    args depv period

    tab stateyr if og_state==1 & (`period') & (${`depv'_bal}), gen(stateyrv)
    eststo: ivreg2 D.log_real_`depv' (D.log_real_earn = $og_oilprice_cont_67) ///
        $controls stateyrv* $regWeight, cluster(fips) savefirst

        // save first stage and F-stat for excluded instruments
        tsunab ivs: $og_oilprice_cont_67
        local ivreg2result = e(firsteqs)
        foreach model of local ivreg2result {
            estimates restore `model'
            test `ivs'
            estadd scalar F_stat = r(F)
        }

    drop stateyrv*
    export_results
end

cap program drop create_appendix_table3
program create_appendix_table3
    foreach pay in ssdi ssi {
        // Column 1: 1970–2011
        run_2sls `pay' "tin(1970, 2011)"
        // Column 2: 1970–1993
        run_2sls `pay' "tin(1970, 1993)"
        // Column 3: 1994–2011
        run_2sls `pay' "tin(1994, 2011)"
    }
end

********************************************************************************

main

log close
exit
