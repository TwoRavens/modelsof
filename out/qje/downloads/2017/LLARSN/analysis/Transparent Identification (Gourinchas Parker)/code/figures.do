version 13
set more off
adopath + ../external/lib/stata/gslab_misc/ado
// preliminaries

program main
    prepare_data
    create_figures
end

program prepare_data
    prepare_matrix_data, filestem(sensitivity) varstub(sens) ///
        models(tab3est tab3pub 2dgrid tab5est)
    prepare_matrix_data, filestem(jacobian) varstub(jacobian) ///
        models(tab3est tab3pub 2dgrid tab5est)
    prepare_matrix_data, filestem(combined_cond_sensitivity) varstub(comcondsen) ///
        models(tab3est tab3pub tab5est) 
    prepare_matrix_data, filestem(disc_factor_cond_sensitivity) varstub(condsen) ///
        models(tab3est tab3pub 2dgrid tab5est)
    prepare_matrix_data, filestem(risk_aversion_cond_sensitivity) varstub(condsen) ///
        models(tab3est tab3pub 2dgrid tab5est)
    merge_clean_sensitivity_data
end

program prepare_matrix_data
    syntax, filestem(string) varstub(string) [ models(string) ]
    foreach m in `models' {
        insheet using "../temp/`filestem'_`m'.tsv", clear tab
        rename v1 moment
        cap rename discountfactor disc_factor_`varstub'_`m'
        cap rename riskaversion* risk_aversion_`varstub'_`m'
        cap rename initialwealth initial_wealth_`varstub'_`m'
        cap rename retirementrulegamma_0 gamma0_`varstub'_`m'
        cap rename retirementrulegamma_1 gamma1_`varstub'_`m'
        save_data "../temp/`filestem'_`m'.dta", key(moment) replace
        global file_list "$file_list `filestem'_`m'"
    }
end 

program merge_clean_sensitivity_data 
    local file_list "$file_list"
    local head_file "sensitivity_tab3est"
    local file_list : list file_list - head_file
    use ../temp/`head_file'.dta, clear 
    foreach f of local file_list {
        merge 1:1 moment using ../temp/`f'.dta
        assert _merge == 3
		drop _merge 
    }
    replace moment = subinstr(moment, "AGE ","",1)
    destring moment, replace 
    assert `=_N' == 40
    clean_variable_labels 
    save_data "../temp/figure_data.csv", key(moment) outsheet comma replace
end 

program clean_variable_labels 
    foreach v of varlist disc_factor* {
        label variable `v' "Discount factor"
    }
    foreach v of varlist risk_aversion* {
        label variable `v' "Coefficient of relative risk aversion"
    }
    foreach v of varlist gamma0* {
        label variable `v' "Retirement rule: {&gamma}{subscript:0}"
    }
    foreach v of varlist gamma1* {
        label variable `v' "Retirement rule: {&gamma}{subscript:1}"
    }
    foreach v of varlist initial_wealth* {
        label variable `v' "Initial wealth"
    }
end 

program create_figures
    foreach m in tab3est tab3pub 2dgrid tab5est {
        make_plot, graphvars(*_sens_`m') ytitle(Sensitivity) plot_type(line) ///
            plot_options(lwidth(medthick) lcolor(black) /// 
			yline(0, lpattern(dash) lwidth(thin) lcolor(maroon)))
        make_plot, graphvars(*_jacobian_`m') ytitle(Jacobian) plot_type(line) ///
            plot_options(lwidth(medthick) lcolor(black) /// 
			yline(0, lpattern(dash) lwidth(thin) lcolor(maroon)))
        make_plot, graphvars(*_condsen_`m') ytitle(Conditional sensitivity) plot_type(line) ///
            plot_options(lwidth(medthick) lcolor(black) /// 
			yline(0, lpattern(dash) lwidth(thin) lcolor(maroon)))
        if "`m'" != "2dgrid" {
            make_plot, graphvars(*_comcondsen_`m') ytitle(Conditional sensitivity) plot_type(line) ///
                plot_options(lwidth(medthick) lcolor(black) /// 
			yline(0, lpattern(dash) lwidth(thin) lcolor(maroon))) filestem(combined_)
        }
    }
end

program make_plot
    syntax, graphvars(string) ytitle(string) plot_type(string) [ plot_options(string) filestem(string) ]
    foreach v of varlist `graphvars' {
        if "`plot_type'" == "line" {
            local mark_line "|| scatter `v' moment, msize(small) mcolor(maroon)"
        }
        else local mark_line ""
        twoway `plot_type' `v' moment, xlabel(26(3)65) xmtick(#40) xtitle("Age") ///
            ytitle(`ytitle') legend(off) `plot_options' `mark_line'
        local filestub = "`v'"
        foreach s in _sens _condsen _comcondsen _jacobian {
            local filestub : subinstr local filestub "`s'" ""
            local filetitle = lower(subinstr("`ytitle'", " ", "_",.))
        }
        graph export "../output/`filestem'`filetitle'_`filestub'.eps", as(eps) replace
        graph export "../temp/`filestem'`filetitle'_`filestub'.png", as(png) width(1500) height(600) replace
    }
end

main 
