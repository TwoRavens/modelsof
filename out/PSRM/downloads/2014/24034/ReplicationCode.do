clear
set more off
use "EnosFowler_PivotalityExperiment.dta"

*** Table 1 ****
areg s11 pivotal, a(stratum_id) cluster(phone_id)
areg s11 pivotal if ind_contact == 1, a(stratum_id)
areg s11 pivotal if ind_contact == 1 & informed == 0, a(stratum_id)
areg s11 pivotal if ind_contact == 1 & informed == 0 & previous_turnout >= 3, a(stratum_id)
areg s11 pivotal if ind_contact == 1 & informed == 0 & previous_turnout <= 2, a(stratum_id)

*** Figure 1 ***
g prob_prev = previous_turnout/9
lpoly s11 prob_prev if ind_contact == 1 & informed == 0 & pivotal == 0, gen(k_control) se(se_control) bw(.15) nograph at(prob_prev)
lpoly s11 prob_prev if ind_contact == 1 & informed == 0 & pivotal == 1, gen(k_treated) se(se_treated) bw(.15) nograph at(prob_prev)
g k_control_upper = k_control + se_control
g k_control_lower = k_control - se_control
g k_treated_upper = k_treated + se_treated
g k_treated_lower = k_treated - se_treated
sort prob_prev
graph twoway line k_* prob_prev
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Pr(Turnout in Previous Elections)
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Pr(Turnout in Special Election)
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(red)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
forvalues i = 3/4 {
gr_edit .plotregion1.plot`i'.style.editstyle line(color(red)) editcopy
gr_edit .plotregion1.plot`i'.style.editstyle line(pattern(dot)) editcopy
}
forvalues i = 5/6 {
gr_edit .plotregion1.plot`i'.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot`i'.style.editstyle line(pattern(dot)) editcopy
}
gr_edit .plotregion1.AddTextBox added_text editor .7494963093691656 .6224441595360418
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(medsmall) color(blue) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Pivotal
gr_edit .plotregion1.added_text[1].DragBy -.018220590842267 .0299329876113367
gr_edit .plotregion1.AddTextBox added_text editor .3408344861926023 .7140038863471891
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(medsmall) color(red) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush Reminder
graph save "Figure1.gph", replace

*** Placebo Tests ***
foreach i in g10 s09 g08 hispanic age dem rep s11_absentee unmatched {
areg `i' pivotal, a(stratum_id) cluster(phone_id)
areg `i' pivotal if ind_contact == 1, a(stratum_id)
areg `i' pivotal if ind_contact == 1 & informed == 0, a(stratum_id)
areg `i' pivotal if ind_contact == 1 & informed == 0 & previous_turnout >= 3, a(stratum_id)
areg `i' pivotal if ind_contact == 1 & informed == 0 & previous_turnout <= 2, a(stratum_id)
}
