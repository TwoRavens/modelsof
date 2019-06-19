********************************************************************************
* This file: create Table 1
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
log using "results/table1.log", replace

********************************************************************************

cap program drop main
program main
    use_data_cnty_year
    regs_weighted
    create_table1
end

cap program drop export_results
program export_results
    esttab _all using "results/table1.csv", append ///
        drop(stateyrv* $controls _cons) stats(F_stat N, fmt(1 0)) ///
        b(3) se(3) nolz gaps depvars numbers
    eststo clear
    estimates clear
end

cap program drop create_table1
program create_table1
    foreach depv in ssdi ssi {
        tab stateyr if og_state==1 & tin(1970, 2011) & ${`depv'_bal}, gen(stateyrv)

        foreach econ in real_earn emp {
            // OLS: columns 1 and 3
            eststo: reg D.log_real_`depv' D.log_`econ' $controls ///
                stateyrv* $regWeight, cluster(fips)

            // 2SLS: columns 2 and 4
            eststo: ivreg2 D.log_real_`depv' (D.log_`econ' = $og_oilprice_cont_67) ///
                $controls stateyrv* $regWeight, cluster(fips) savefirst
                // add F stat for excluded instruments to the results
                tsunab ivs: $og_oilprice_cont_67
                local ivreg2result = e(firsteqs)
                foreach model of local ivreg2result {
                    estimates restore `model'
                    test `ivs'
                    estadd scalar F_stat = r(F)
                }
            export_results
        }
        drop stateyrv*
    }
end


********************************************************************************

main

log close
exit
