version 12
set more off
adopath + ../external/lib/stata/gslab_misc/ado
preliminaries

program main
    local specs "2dgrid tab3est tab3pub tab5est"

    prepare_sample_moments
    prepare_vary_param, param("beta") specs("`specs'")
    prepare_vary_param, param("rho") specs("`specs'")

    local 2dgrid_title "Discount Factor and Risk Aversion (2D)"
    local tab3est_title "Column (1) of Table III (Re-estimated)"
    local tab3pub_title "Column (1) of Table III (As published)"
    local tab5est_title "Column (1) of Table V (Re-estimated)"

    foreach spec in `specs' {
        compare_sample_fitted, specification("`spec'") title("``spec'_title'")
        vary_param, param("beta") specification("`spec'") title("``spec'_title' --- Vary {&beta}") increment(".01")
        vary_param, param("rho") specification("`spec'") title("``spec'_title' --- Vary {&rho}") increment(".17")
    }
end

program prepare_sample_moments
    insheet using ../output/sample_moments.csv, comma clear
    rename v1 age
    rename v2 consumption
    save_data ../temp/sample_moments, key(age) replace
    
    insheet using ../output/income.csv, comma clear
    rename v1 age 
    rename v2 income
    
    mmerge age using ../temp/sample_moments, type(1:1)
    assert _merge == 3
    save_data ../temp/income_sample_moments, key(age) replace
end

program compare_sample_fitted
    syntax, specification(string) title(string) 

    insheet using ../output/`specification'/fitted_moments.csv, comma clear
    rename v1 age
    rename v2 fitted_consumption
    replace fitted_consumption = fitted_consumption/1000
        
    prepare_graph_vars
    graph_vars, line_vars("fitted_consumption") ///
                clwidth_info("medthick thick") ///
                clpattern_info("solid solid") ///
                legend_info(`"order(1 "Raw consumption" 2 "Fitted consumption" 3 "Income") size(small)"') ///
                specification("`specification'") ///
                title("`title'")
end

program prepare_vary_param
    syntax, param(string) specs(string)

    foreach spec in `specs' {
        foreach mod in inc dec {
            insheet using ../temp/fitted_moments_`spec'_`mod'`param'.csv, comma clear

            rename v1 age
            rename v2 fitted_consumption_`mod'`param'
            save_data ../temp/fitted_moments_`spec'_`mod'`param'.dta, key(age) replace
        }
    
        use ../temp/fitted_moments_`spec'_inc`param'.dta, clear
        mmerge age using ../temp/fitted_moments_`spec'_dec`param'.dta, type(1:1)
        assert _merge == 3
        drop _m
        
        save_data ../temp/fitted_moments_`spec'_vary`param'.dta, key(age) replace
    }
end 

program vary_param
    syntax, param(string) specification(string) title(string) increment(string)

    use ../temp/fitted_moments_`specification'_vary`param'.dta, clear
    replace fitted_consumption_inc`param' = fitted_consumption_inc`param'/1000
    replace fitted_consumption_dec`param' = fitted_consumption_dec`param'/1000
    
    prepare_graph_vars
    
    graph_vars, line_vars("fitted_consumption_inc`param' fitted_consumption_dec`param'") ///
                clwidth_info("thin thick thick") ///
                clpattern_info("dash_dot dash_dot solid") ///
                legend_info(`"order(1 "Raw consumption" 4 "Income" 2 "Fitted cons., {&`param'} + `increment'" 3 "Fitted cons., {&`param'} - `increment'") size(small)"') ///
                specification("`specification'_vary_`param'") ///
                title("`title'")
end

program prepare_graph_vars
    mmerge age using ../temp/income_sample_moments, type(1:1)
    assert _merge == 3

    replace consumption = consumption/1000
    replace income = income/1000
end

program graph_vars
    syntax, line_vars(string) clpattern_info(string) clwidth_info(string) ///
            legend_info(string) specification(string) title(string)
    
    twoway (scatter consumption age, ///
                msymbol(Oh) mlcolor(black)) ///
           (line `line_vars' income age, ///
                ylabel(16(2)28, ang(h)) xlabel(26(3)65) xmtick(#40) ///
                title("`title'") ytitle("Thousands of Dollars") xtitle("Age") ///
                clcolor(black black black) clwidth(`clwidth_info') clpattern(`clpattern_info') ///
                legend(`legend_info'))
                
    tokenize "`specification'", parse("_")
    graph export ../temp/sample_fitted_`specification'.png, as(png) height(800) width(1000) replace
    graph export ../output/`1'/sample_fitted_moments`2'`3'`4'`5'.eps, as(eps) replace
end

main
