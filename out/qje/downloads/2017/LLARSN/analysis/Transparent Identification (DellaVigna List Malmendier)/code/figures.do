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
    prepare_figures_data,                                         ///
        sen_file(../temp/sensitivity_matrix.tsv)                  ///
        stsen_file(../temp/standardized_sensitivity_matrix.tsv)   ///
        param_file(../external/data/param_data_dlm2012.dta)       /// 
        mom_file(../external/data/mom_data_dlm2012.dta)           ///
        out_file(../temp/figures_data.dta)                        ///
        mom_type_order(lar ecu svy)    

    use ../temp/figures_data.dta, replace
end

program graph_params
    ds *_sen
    local all_vars = "`r(varlist)'"
    local param_list = subinstr("`all_vars'", "_sen", "", .)
    qui foreach param in `param_list' {
        gen abs_`param'_sen = .
        prepare_param_sensitivity, param("`param'") 
		
		replace `param'_sen = `param'_sen / 100
        
        local charities `" "ecu" "lar" "'
        foreach charity of local charities{
            make_dot_plot, param(`param') charity(`charity')
        }
    }
end
    
program make_dot_plot
    syntax, param(string) charity(string)

    * prepare parameter values
    gen z_key_stsen         = `param'_stsen   if param_key == 1
    replace abs_`param'_sen = abs(`param'_sen)
    gen z_key_sen           = abs_`param'_sen if param_key == 1
    gen z_nonkey_stsen      = `param'_stsen   if param_key == 0
    
    split moment_label, p(: ) gen(z_moment_label)
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
    
    * make standardized sensitivity plot
    make_plot, param(`param') type("stsen") descrip(`param_descrip') ///
               labsize("vsmall") rescale("norescale") ///
               name_suffix("stsens") charity(`charity')
   
    * make sensitivity plot
    replace `param'_sen = abs_`param'_sen
    
    * get plot dimensions
    quietly summ `param'_sen
    local min = `r(min)'
    local max = `r(max)'
    
    * set font size
    local labsize_type = "vsmall"
    if (`min' < 0 < `max' & (`max' - `min') > 1000) {
        local labsize_type = "tiny"
    } 

    make_plot, param(`param') type("sen") descrip(`param_descrip') ///
               labsize(`labsize_type') rescale("norescale") ///
               name_suffix("sens") charity(`charity') 
	drop z_*
end

program make_plot
    syntax, param(string) type(string) descrip(string) labsize(string) ///
            rescale(string) name_suffix(string) charity(string)
    
    * Determine the axis range
    summarize z_key_`type' `param'_`type' if moment_type == "`charity'"
    if (`r(max)' <= 0.5 & `r(max)' > 0.1) local range_max 0.5
	if (`r(max)' <= 0.1) local range_max 0.1

    if "`rescale'" == "norescale" {
        local yscale_opts yscale(range(0 `range_max') off noline noextend)
    }    
    else {
        local yscale_opts yscale(off noline noextend)
    }
    
	if "`range_max'" == "0.5" local ylabel_opts ylabel(0(.25)0.5, labsize(vsmall))
	if "`range_max'" == "0.1" local ylabel_opts ylabel(0(.05)0.1, labsize(vsmall))
	
    if "`type'" == "stsen" {
        * Set the axis ticks as appropriate given the axis range
        if "`range_max'" == "" local ylabel_opts ylabel(0(.5 )1, labsize(vsmall))
        local y_title ytitle(Standardized sensitivity, size(vsmall))
    }    
    else {
        if "`range_max'" == "" local ylabel_opts ylabel(#3, labsize(`labsize'))
        local y_title ytitle(Sensitivity, size(vsmall))
    }
    
    graph dot z_key_`type' `param'_`type' if moment_type == "`charity'", ///
        by(z_moment_label1, col(1) im(medsmall) title("", size(small)) note("") legend(pos(6)) `rescale') ///
        over(z_mom_treatment, label(labsize(tiny)) axis(noline)) ///
        over(z_mom_prob, sort(z_order_prob) label(labsize(vsmall)) axis(noline) gap(100)) nofill ///
        legend(order(1 "Key moments" 2 "Other moments") size(vsmall) cols(2) region(style(none))) ///
        subtitle("", size(small) nobox) `y_title' ///
        m(1, mc(blue) ms(O)) m(2, mc(gs10) ms(Oh)) ///
        dots(mcolor(gs15)) ndots(50) `ylabel_opts' ///
        aspectratio(4) `yscale_opts'  ///
        plotr(margin(0 0 2 2)) xsize(20) ysize(15) 
    gr_edit .b1title.xoffset = 13
	gr_edit .b1title.yoffset = 3
    gr_edit .legend.xoffset  = 13
	gr_edit .legend.yoffset = 3
    graph export "../output/`param'_`name_suffix'_`charity'.eps", as(eps) replace	
end

* Execute
main
