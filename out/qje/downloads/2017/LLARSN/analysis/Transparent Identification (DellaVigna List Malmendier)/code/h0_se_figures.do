version 12
set more off
adopath + ../external/lib/stata/gslab_misc/ado
adopath + ../external/lib/stata/trans/ado
preliminaries

program main
    prepare_data
    graph_params
end

program prepare_data
    prepare_figures_data, sen_file(../temp/model_se.tsv)            ///
                          stsen_file(../temp/model_se.tsv)   ///
                          param_file(../external/data/param_data_dlm2012.dta) /// 
                          mom_file(../external/data/mom_data_dlm2012.dta)     ///
                          out_file(../temp/emp_mom.dta)                  ///
                          mom_type_order(lar ecu svy)    

    use ../temp/emp_mom.dta, replace
    gen keyempirical_moment_mean   = keyh_0
    gen keymodel_standard_error    = keyh_0
    gen descrempirical_moment_mean = "Mean of empirical moments"
    gen descrmodel_standard_error  = "Standard errors of empirical moments"
end

program graph_params
    quietly ds *_sen
    local all_vars = "`r(varlist)'"
    local param_list = subinstr("`all_vars'", "_sen", "", .)
    foreach param in `param_list' {
        gen abs_`param'_sen = .
        prepare_param_sensitivity, param("`param'")
        make_dot_plot, param(`param')
    }
end
    
program make_dot_plot
    syntax, param(string) 
    gen z_key_stsen = `param'_stsen if param_key == 1
    replace abs_`param'_sen = abs(`param'_sen)
    gen z_key_sen   = abs_`param'_sen   if param_key == 1
    gen z_nonkey_stsen = `param'_stsen if param_key == 0
    
    split moment_label, p(: ) gen(z_moment_label)
    replace z_moment_label1 = "Survey"    if z_moment_label1 == "SV"
    replace z_moment_label1 = "La Rabida" if z_moment_label1 == "LR"
    gen z_mom_prob =      regexs(1) if regexm(z_moment_label2, "(P\(.+\)) (.*)")
    gen z_mom_treatment = regexs(2) if regexm(z_moment_label2, "(P\(.+\)) (.*)")

    gsort z_mom_prob, gen(z_order_prob)
    replace z_order_prob = -3 if z_mom_prob == "P(Home)"
    replace z_order_prob = -2 if z_mom_prob == "P(Opt out)"
    replace z_order_prob = -1 if z_mom_prob == "P(Giving)"
    replace z_order_prob = 0  if z_mom_prob == "P(Surv)"

    local param_descrip = subinstr(descr`param', "Prob.", "Probability", .)

    replace z_mom_prob = "Gives $" + regexs(1) if regexm(z_mom_prob, "P\(\\$(.+)\)")
    replace z_mom_prob = "Gives any"  if z_mom_prob == "P(Giving)"
    replace z_mom_prob = "Opens door" if z_mom_prob == "P(Home)"
    replace z_mom_prob = "Completes survey"  if z_mom_prob == "P(Surv)"
    replace z_mom_prob = "Opts out"   if z_mom_prob == "P(Opt out)"
    replace z_mom_prob = "Gives any"  if z_mom_prob == "P(Giving)"
    
    if "`param'" == "empirical_moment_mean" {
        local ytitle = "Mean"
    }
    else {
        local ytitle = "Standard error"
    }
    
    quietly summarize `param'_stsen
    local range_min = r(min)
    local range_max = r(max)
    
    graph dot z_key_stsen `param'_stsen, ///
        by(z_moment_label1, col(3) im(medsmall) title(`param_descrip', size(small)) note("") legend(pos(6))) ///
        over(z_mom_treatment, label(labsize(tiny)) axis(noline)) ///
        over(z_mom_prob, sort(z_order_prob) label(labsize(vsmall)) axis(noline) gap(100)) nofill ///
        legend(order(1 "Key moments for Prob. of home presence (2008)" 2 "Other moments") size(vsmall) cols(2) region(style(none))) ///
        subtitle(, size(small) nobox) ///
        ytitle(`ytitle', size(small)) ///
        m(1, mcolor(blue) ms(O)) m(2, mcolor(gs10) ms(Oh)) ///
        dots(mcolor(gs15)) ndots(50) ///
        ylabel(#3, labsize(vsmall)) ///
        aspectratio(4) yscale(range(`range_min' `range_max') off noline noextend) ///
        plotr(margin(0 0 2 2)) xsize(20) ysize(15)
    graph export "../output/`param'.eps", as(eps) replace

    drop z_*
end
    
* Execute
main
