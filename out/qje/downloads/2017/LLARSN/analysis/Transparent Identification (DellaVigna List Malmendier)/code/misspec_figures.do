version 12
set more off
adopath + ../external/lib/stata/gslab_misc/ado
adopath + ../external/lib/stata/trans/ado
preliminaries

program main
    plot_misspec, misspec_type("threshold") type(line)
    plot_misspec, misspec_type("fixed_giving") type(line)
    plot_misspec, misspec_type("fixed_giving_global") type(dot)
end


program plot_misspec
    syntax, misspec_type(string) type(string)

    if "`misspec_type'" == "threshold" {
        local suffix `""'
        local x_title `"Value of alternative giving threshold"'
		local y_title `"Bias in estimated social pressure"'
    }
    else if "`misspec_type'" == "fixed_giving" {
        local suffix `"_crude"'
        local x_title `"Gift size of model violators"'
		local y_title `"Bias in estimated social pressure"'
    }
    else if "`misspec_type'" == "fixed_giving_global" {
        local suffix `"_crude_global"'
        local x_title `"Gift size of model violators"'
		local y_title `"Global sensitivity of social pressure"'
    }
	
    * Prepare the data
    import delimited "../output/S_misspec_change`suffix'.csv", clear
    rename (v1 v2 v3) (grid LAR ECU)

    * Produce a misspecification plot for each charity
    local charities `" "ECU" "LAR" "'
    foreach charity of local charities{
        graph twoway (`type' `charity' grid), yline(0, lcolor(grey) lpattern(.)) ///
            xtitle("`x_title'")                                                ///
            ytitle("`y_title'")

        graph export "../output/S_misspec_change`suffix'_`charity'.eps", ///
            as(eps) replace
    }
end

* EXECUTE
main
