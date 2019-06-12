version 14
set more off
adopath + ../external/lib/stata/gslab_misc/ado
adopath + ../external/lib/stata/trans/ado
preliminaries

program main
    bring_sd_vars

    make_graph, lambda("markup_iv_")        param("markup") sen_type("sen")        perturb_scaling("yes")
    make_graph, lambda("markup_iv_sample_") param("markup") sen_type("sample_sen") perturb_scaling("yes")
    make_graph, lambda("markup_")           param("markup") sen_type("stsen")
    make_graph, lambda("markup_sample_")    param("markup") sen_type("sample_stsen")
end

program bring_sd_vars
    import delimited ../temp/moments_standard_deviation_matrix.tsv, clear
    drop v1
    gen scaled_sens = .
    save ../temp/mom_std_matrix.dta, replace   
end

program make_graph
    syntax, [lambda(string) param(string) perturb_scaling(string) sen_type(string)]
    
    prepare_data, lambda("`lambda'") perturb_scaling("`perturb_scaling'")
    
    quietly ds *_sen
    local all_vars = "`r(varlist)'"
    local param_list = subinstr("`all_vars'", "_sen", "", .)
    
    use ../temp/figures_data.dta, clear
    gen abs_`param'_sen = abs(`param'_sen)
    prepare_param_sensitivity, param("`param'") sen_type("`sen_type'")
    prepare_moments
    make_dot_plot, param(`param') sen_type("`sen_type'") perturb_scaling("`perturb_scaling'") notitle excludediv 
end

program prepare_data
    syntax, [lambda(string)] [perturb_scaling(string)]
    prepare_figures_data, sen_file(../temp/`lambda'sensitivity_matrix.tsv)                  ///
                          stsen_file(../output/standardized_`lambda'sensitivity_matrix.tsv) ///
                          param_file(../external/data/param_data_blp1995.dta)                   ///
                          mom_file(../external/data/mom_data_blp1995.dta)                       ///
                          out_file(../temp/figures_data.dta)                                    ///
                          mom_type_order(Demand_moments Supply_moments)
    
    use ../temp/figures_data.dta, clear
    if "`perturb_scaling'" == "yes" {
        gen order = _n
        preserve
        import delimited "../output/perturb_scaling.tsv", delimiter(tab) varnames(1) encoding(ISO-8859-1)    clear
        rename v2 perturb_scaling
        rename v1 perturb_version
        replace perturb_version = strtrim(perturb_version)
        gen type_order = 1 if perturb_version == "demand"
        replace type_order = 2 if perturb_version == "supply"
        save "../temp/perturb_scaling.dta", replace
        restore
        merge m:1 type_order using "../temp/perturb_scaling.dta"
        drop _merge
        sort order
        destring perturb_scaling, replace
        save ../temp/figures_data.dta, replace
    }
end

program prepare_moments
    split moment_label, p(: ) gen(z_moment_label)
    
    gsort z_moment_label1, gen(z_order_category)
    replace z_order_category = -2 if regexm(lower(z_moment_label1), "this car")
    replace z_order_category = -1 if regexm(lower(z_moment_label1), "same firm")
    replace z_order_category = 0 if regexm(lower(z_moment_label1), "rival firms")
    
    gsort z_moment_label2, gen(z_order_moment)
    replace z_order_moment = -4 if regexm(z_moment_label2, "(C|c)onstant|# Cars")
    replace z_order_moment = -3 if regexm(z_moment_label2, "horsepower/weight")
    replace z_order_moment = -2 if regexm(z_moment_label2, "AC standard")
    replace z_order_moment = -1 if regexm(z_moment_label2, "miles/dollar")
    replace z_order_moment = -0 if regexm(z_moment_label2, "^size")
    
    * Standardizes spacing
    replace z_moment_label2 = trim(z_moment_label2)
    replace z_moment_label2 = "          " + z_moment_label2 if regexm(z_moment_label2, "AC standard")

    gen moment_type_clean = subinstr(moment_type, "_", " ", .)

end

program make_dot_plot
    syntax, param(string) [notitle excludediv sen_type(string) perturb_scaling(string)]
	
    * Note ordering depends on z_order_category and NOT z_moment_label1
    local moment_category_label_demand 1 `"" " "This car" " ""' 2 `""Other cars" "by same firm""' 3 `""Cars by" "rival firms""'
    local moment_category_label_supply `moment_category_label_demand'
    if "`title'" ~= "notitle" {
        local param_descrip = descr`param'
    }

    * Restricts to excluded instruments
    if "`excludediv'" == "excludediv" {
        local suffix "_excludediv"
        local demand_condition & regexm(z_moment_label1, "same firm|rival firms")
        local supply_condition `demand_condition' | moment == "supply_mpd"
        local moment_category_label_demand 1 `""Other cars" "by same firm""' 2 `""Cars by" "rival firms""'
    }

    * Sets up plot variables based on sensitivity type
    if "`sen_type'" == "stsen" | "`sen_type'" == "sample_stsen" { 
        local param_sens = "`param'_stsen"
        local param_filename = "`param'_stsen" + "s"
        local ytitle         = "Standardized sensitivity"
    } 
    else if "`sen_type'" == "drop_mom" { 
        local param_sens = "`param'_stsen"
        local param_filename = "markup_change_drop_mom"
        local ytitle         = "Standardized {&Delta} markup"
    }
    else if "`sen_type'" == "sen" | "`sen_type'" == "sample_sen" {
        local param_sens = "abs_`param'_sen"
        local param_filename = "`param'_sen" + "s"
        local ytitle         = "Unstandardized sensitivity"
		        
        * Adds perturbation scaling
        if "`perturb_scaling'" == "yes" {
            preserve
            gen scaled_sens = .
            merge m:1 scaled_sens using ../temp/mom_std_matrix.dta, nogen keep(3) assert(3) 
            local std_varlist hpwt mpd logspace logmpg loghpwt

            local moment_levels demand_air demand_const demand_firm_air demand_firm_const demand_firm_hpwt ///
                                demand_firm_mpd demand_hpwt demand_mpd                                     ///
                                demand_rival_air demand_rival_const demand_rival_hpwt demand_rival_mpd     ///
                                demand_space supply_air supply_const supply_firm_air                       ///
                                supply_firm_const supply_firm_loghpwt supply_firm_logmpg                   ///
                                supply_firm_trend supply_loghpwt                                           ///
                                supply_logmpg supply_logspace supply_mpd supply_rival_air                  ///
                                supply_rival_const supply_rival_loghpwt                                    ///
                                supply_rival_logmpg supply_rival_logspace supply_firm_logspace supply_trend

			foreach mom in `moment_levels' {
                replace scaled_sens =  abs_`param'_sen / sd_`mom' if moment == "`mom'"  

            }
            local param_filename = "`param'_scaled_sen" 
            replace scaled_sens = scaled_sens * perturb_scaling
                
            * Adds scaling by perturbation values
            local param_sens scaled_sens
            local ytitle = "Sensitivity"
        }
    }

    * Add "_sample" to sample sensitivity plots
    if ("`sen_type'" == "sample_sen" | "`sen_type'" == "sample_stsen") local param_filename = "`param_filename'" + "_sample"
    
    * Add prefix "blp1995_" to the average markup plots 
    if "`param'" == "markup"  local param_filename = "blp1995_" + "`param_filename'"

    * Determine axis scale for the demand and supply moment plots
    quietly summarize `param_sens' 
    local Scale range(0 `r(max)')
    local font_size      = "small"

    make_individual_dot_plot `param_sens'                                               ///
        if ~missing(`param_sens') & moment_type == "Demand_moments" `demand_condition', ///
        name(demand) color(blue*4) symbol(Oh)                                           ///
        title(Demand-side instruments) ytitle("`ytitle'")                               ///
        moment_category_label(`moment_category_label_demand') scale(`Scale')            ///
        title_font("`font_size'") 
    make_individual_dot_plot `param_sens'                                               ///
        if ~missing(`param_sens') & moment_type == "Supply_moments" `supply_condition', ///
        name(supply) color(red*1.5) symbol(D)                                           ///
        title(Supply-side instruments) ytitle("`ytitle'")                               ///
        moment_category_label(`moment_category_label_supply') scale(`Scale')                ///
        title_font("`font_size'")
        
    graph combine demand supply, title(`param_descrip', size(medlarge)) col(2) ysize(3.3)
    graph export "../output/`param_filename'`suffix'.eps", as(eps) replace
    graph export "../temp/`param_filename'`suffix'.png", as(png) replace height(800)
    
end

program make_individual_dot_plot
    syntax varname if, name(string) color(string) symbol(string) title(string) /// 
        moment_category_label(string asis) ytitle(string) scale(string) [title_font(str)]
    
    graph dot `varlist' `if',                                                                                ///
        over(z_moment_label2, sort(z_order_moment) label(labsize(small)) axis(noline) gap(-40)) nofill       ///
        over(z_order_category, label(labsize(medium)) axis(noline) gap(75) relabel(`moment_category_label')) ///
        title(`title', size(medium) nobox span)                                                              ///
        ytitle(`ytitle', size("`title_font'"))                                                               ///
        m(1, mcolor(`color') ms(`symbol'))                                                                   ///
        dots(mcolor(gs15)) ndots(50)                                                                         ///
        ylabel(#3, labsize(vsmall)) yscale(`scale')                                                          ///
        plotr(margin(0 0 2 2))                                                                               ///
        name(`name', replace) nodraw
end

program graph_dropping_moments
    /* note that the `sen_file' argument is passed so that the prepare_figures_data 
       function can be used, even though it is not plotted. */
    prepare_figures_data,                                              ///
        sen_file(../output/dropping_moments_mean_markup_change.tsv)    ///
        stsen_file(../output/dropping_moments_mean_markup_change.tsv)  ///
        param_file(../external/data/param_data_blp1995.dta)            /// 
        mom_file(../external/data/mom_data_blp1995.dta)                ///
        out_file(../temp/figures_data.dta)                             ///
        mom_type_order(Demand_moments Supply_moments)
 
    gen keyst_markup_change = 1
    
    prepare_param_sensitivity, param("st_markup_change") sen_type("stsen")
    prepare_moments
    replace st_markup_change_stsen = abs(st_markup_change_stsen)
    make_dot_plot, param(st_markup_change) sen_type("drop_mom") notitle
end
    
program make_supplydemand_plot
    syntax, varname(string)
    
    insheet using "../external/data/param_crosswalk.csv", clear
    replace output_names = subinstr(output_names, "random coefficient", "standard deviations",.)
    gen sort_order = _n
    replace sort_order = sort_order + 6 if blp1995_names == "alpha_price"
    save ../temp/param_crosswalk, replace
    
    * Determine the input filename
    if "`varname'" == "sensitivity" local filename supplydemand_sens
    if "`varname'" == "sufficiency" local filename partial_sufficiencies

    import delimited "../output/`filename'.tsv", clear varnames(1)
    gen blp1995_names = trim(v1) 
    merge 1:1 blp1995_names using ../temp/param_crosswalk, keep(3) assert(3)
    
    * Provide the categories of parameters with appropriate labels
    gen category = regexr(output_names, ":(.*)", "")
    replace output_names = regexr(output_names, "(.*):", "")
    
    replace category =  `" "Utility Function" "(Standard Deviations)" "' ///
        if  regexm(output_names, " \(.*\)") 
    
    replace category = `" "Utility Function"  "(Means)" "' ///
        if  regexm(category, "Utility function$") 
    
    replace category = "Marginal Cost" ///
        if  regexm(category, "Marginal cost")    
    
    replace output_names = regexr(output_names, " \(.*\)", "") 

    * Determine plot options based on the variable of interest
    if "`varname'" == "sensitivity" {
        local yTitle "Standardized sensitivity"
        
        * Get yscale for standarised sensitivity
        quietly summarize demandmoments
        local max_val `r(max)'
        quietly summarize supplymoments
        if `max_val' < `r(max)' local max_val `r(max)'
        
        local yScale range(0 `max_val')
    }
    if "`varname'" == "sufficiency" {
        local yTitle "Sufficiency"
        local yScale range(0 1)
    }
    
    graph dot demandmoments supplymoments,                                           ///
        over(output_names, sort(sort_order) label(labsize(vsmall)) axis(noline) )    ///
        over(category, sort(sort_order) label(labsize(small)) axis(noline) ) nofill  ///
        m(1, mc(blue*4) m(Oh)) m(2, mc(red*1.5) m(D))                             ///
        legend(col(1) size(small) region(lwidth(none))                            ///
            label(1 "Demand moments") label(2 "Supply moments"))                  ///
        dots(mcolor(gs10)) ndots(50)                                              ///
        ylabel(#3, labsize(small))                                                ///
        ytitle(`yTitle') aspectratio(2) yscale(`yScale') plotr(margin(0 0 2 2))
    
    graph export "../output/`filename'.eps", as(eps) replace
    graph export "../temp/`filename'.png", as(png) replace height(800)
end 

* Execute
main
