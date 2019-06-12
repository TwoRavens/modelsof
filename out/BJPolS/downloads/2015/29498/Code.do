*********** U.S. House ************
clear
set more off
use "FinalDataSet_House.dta"

***Figure 2
areg cvp0 treatment rv* if absrv < .3, a(year) cluster(state_dist)
predict p_1 if treatment == 1
predict p_0 if treatment == 0
sort rep_voteshare
graph twoway (scatter cvp0 rep_voteshare) (line p_1 p_0 rep_voteshare) if absrv < .3, xline(.5)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Republican Vote Share
gr_edit .xaxis1.reset_rule .2 .8 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Conservative Vote Probability
gr_edit .yaxis1.reset_rule -.6 .6 .2 , tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(size(tiny)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(gs8))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. House
graph save "Figure2_House.gph", replace
drop p_1 p_0
*DW-NOMINATE version
areg dw0 treatment rv* if absrv < .3, a(year) cluster(state_dist)
predict p_1 if treatment == 1
predict p_0 if treatment == 0
sort rep_voteshare
graph twoway (scatter dw0 rep_voteshare) (line p_1 p_0 rep_voteshare) if absrv < .3, xline(.5)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Republican Vote Share
gr_edit .xaxis1.reset_rule .2 .8 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush DW-NOMINATE
gr_edit .yaxis1.reset_rule -1.2 1.6 .4 , tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(size(tiny)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(gs8))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(red)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. House
graph save "Figure2_House_DW.gph", replace
drop p_1 p_0

***Figures 3 & 4
areg victory1 treatment rv* if absrv < .3, a(year) cluster(state_dist)
local hypothetical = _b[treatment]
matrix B = J(8, 5, .)
forvalues i = 0/7 {
areg victory`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `hypothetical'^`i'
matrix B[`num', 5] = `i'
}
svmat B
graph twoway line B2 B3 B1 B5, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. House
graph save "Figure3_House.gph", replace
graph twoway line B4 B2 B3 B1 B5, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot4.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .4 2
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush True Effects
gr_edit .plotregion1.AddTextBox added_text editor .163 .95
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(gs8) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush Markov-Chain Effects
graph save "Figure4.gph", replace
drop B*

***Figure 6
matrix B = J(11, 3, .)
forvalues i = 0/10 {
areg victory`i' treatment rv* if absrv < .3 & open == 1, a(year) cluster(state_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
areg victory`i' treatment rv* if absrv < .3 & open == 0, a(year) cluster(state_dist)
matrix B[`num', 2] = _b[treatment]
matrix B[`num', 3] = `i'
}
svmat B
graph twoway line B2 B1 B3
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 10 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot1.style.editstyle line(color(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .27 3.5
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Open Seat Races
gr_edit .plotregion1.AddTextBox added_text editor .13 1.5
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(gs8) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush Incumbent Running
graph save "Figure6.gph", replace
drop B*

***Figure 7
g cycle = floor((year - 2)/10)*10 + 2
replace cycle = 1952 if cycle < 1952
g partisanship = 2
forvalues i = 1952(10)2002 {
	sum rep_twoparty_pres if cycle == `i', d 
	replace partisanship = 3 if rep_twoparty_pres >= r(p75) & cycle == `i'
	replace partisanship = 1 if rep_twoparty_pres <= r(p25) & cycle == `i'
}
matrix B = J(8, 4, .)
forvalues i = 0/7 {
	local num = `i' + 1
	forvalues j = 1/3 {
		areg victory`i' treatment rv* if absrv < .3 & partisanship == `j', a(year) cluster(state_dist)
		matrix B[`num', `j'] = _b[treatment]
	}
	matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B1 B3 B2 B4, yline(0) 
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot1.style.editstyle line(color(gs5)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(gs11)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .3 3.2
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Moderate Districts
gr_edit .plotregion1.AddTextBox added_text editor .15 1
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(gs11) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush Republican Districts
gr_edit .plotregion1.AddTextBox added_text editor -.02 2.4
gr_edit .plotregion1.added_text_new = 3
gr_edit .plotregion1.added_text_rec = 3
gr_edit .plotregion1.added_text[3].style.editstyle  angle(default) size(small) color(gs5) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[3].text = {}
gr_edit .plotregion1.added_text[3].text.Arrpush Democratic Districts
graph save "Figure7.gph", replace
drop B*

***Figure 8
matrix B = J(8, 4, .)
forvalues i = 0/7 {
areg cvp`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downsream Representation
gr_edit .yaxis1.reset_rule 0 .4 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. House
graph save "Figure8_House.gph", replace
drop B*
*DW-NOMINATE version
matrix B = J(8, 4, .)
forvalues i = 0/7 {
areg dw`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downsream Representation
gr_edit .yaxis1.reset_rule 0 .6 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. House
graph save "Figure8_House_DW.gph", replace
drop B*

***Figure 9
matrix B = J(8, 3, .)
forvalues i = 0/7 {
areg victory`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
matrix B[`num', 2] = _b[treatment]
matrix B[`num', 3] = `i'
}
svmat B
graph twoway (line B1 B3, yaxis(1)) (line B2 B3, yaxis(2))
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis2.reset_rule 0 .39 .39, tickset(major) ruletype(range) 
gr_edit .yaxis1.reset_rule 0 1 1, tickset(major) ruletype(range) 
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion2.plot2.style.editstyle line(color(gs8)) editcopy
gr_edit .plotregion2.plot2.style.editstyle line(pattern(dash)) editcopy
gr_edit .plotregion2.plot2.style.editstyle line(width(thick)) editcopy
*gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(color(maroon)))) editcopy
*gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(linestyle(color(maroon)))) editcopy
*gr_edit .yaxis1.style.editstyle linestyle(color(maroon)) editcopy
*gr_edit .yaxis1.title.style.editstyle color(maroon) editcopy
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Partisan Representation
gr_edit .yaxis2.style.editstyle majorstyle(tickstyle(textstyle(color(gs8)))) editcopy
gr_edit .yaxis2.style.editstyle majorstyle(tickstyle(linestyle(color(gs8)))) editcopy
gr_edit .yaxis2.style.editstyle linestyle(color(gs8)) editcopy
gr_edit .yaxis2.title.style.editstyle color(gs8) editcopy
gr_edit .yaxis2.title.text = {}
gr_edit .yaxis2.title.text.Arrpush Effect of One Election on Roll-Call Representation
graph save "Figure9.gph", replace
drop B*

***Figure A1 (robustness to sorting)
matrix B = J(8, 4, .)
forvalues i = 0/7 {
local num = `i' + 1
areg cvp`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
matrix B[`num', 1] = _b[treatment]
areg cvp`i' treatment rv* lag_voteshare lag_victory if absrv < .3, a(year) cluster(state_dist)
matrix B[`num', 2] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .3 & absrv > .005, a(year) cluster(state_dist)
matrix B[`num', 3] = _b[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downsream Representation
gr_edit .yaxis1.reset_rule 0 .4 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot1.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(green)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(red)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .04 5
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(blue) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush No Controls
gr_edit .plotregion1.AddTextBox added_text editor .18 1.1
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(green) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush w/ Controls
gr_edit .plotregion1.AddTextBox added_text editor .075 2.3
gr_edit .plotregion1.added_text_new = 3
gr_edit .plotregion1.added_text_rec = 3
gr_edit .plotregion1.added_text[3].style.editstyle  angle(default) size(small) color(red) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[3].text = {}
gr_edit .plotregion1.added_text[3].text.Arrpush Donut
graph save "FigureA1.gph", replace
drop B*

***Figure A2 (robustness across specifications)
g int_rv1 = rv1*treatment
matrix B = J(8, 27, .)
forvalues i = 0/7 {
local num = `i' + 1
areg cvp`i' treatment rv* if absrv < .05, a(year) cluster(state_dist)
matrix B[`num', 1] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .1, a(year) cluster(state_dist)
matrix B[`num', 2] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .15, a(year) cluster(state_dist)
matrix B[`num', 3] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .2, a(year) cluster(state_dist)
matrix B[`num', 4] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .25, a(year) cluster(state_dist)
matrix B[`num', 5] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
matrix B[`num', 6] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .35, a(year) cluster(state_dist)
matrix B[`num', 7] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .45, a(year) cluster(state_dist)
matrix B[`num', 8] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .5, a(year) cluster(state_dist)
matrix B[`num', 9] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .05, a(year) cluster(state_dist)
matrix B[`num', 10] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .1, a(year) cluster(state_dist)
matrix B[`num', 11] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .15, a(year) cluster(state_dist)
matrix B[`num', 12] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .2, a(year) cluster(state_dist)
matrix B[`num', 13] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .25, a(year) cluster(state_dist)
matrix B[`num', 14] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .3, a(year) cluster(state_dist)
matrix B[`num', 15] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .35, a(year) cluster(state_dist)
matrix B[`num', 16] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .45, a(year) cluster(state_dist)
matrix B[`num', 17] = _b[treatment]
areg cvp`i' treatment rv1 rv2 rv3 if absrv < .5, a(year) cluster(state_dist)
matrix B[`num', 18] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .03, a(year) cluster(state_dist)
matrix B[`num', 19] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .04, a(year) cluster(state_dist)
matrix B[`num', 20] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .05, a(year) cluster(state_dist)
matrix B[`num', 21] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .06, a(year) cluster(state_dist)
matrix B[`num', 22] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .07, a(year) cluster(state_dist)
matrix B[`num', 23] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .08, a(year) cluster(state_dist)
matrix B[`num', 24] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .09, a(year) cluster(state_dist)
matrix B[`num', 25] = _b[treatment]
areg cvp`i' treatment rv1 int_rv1 if absrv < .10, a(year) cluster(state_dist)
matrix B[`num', 26] = _b[treatment]
matrix B[`num', 27] = `i'
}
svmat B
graph twoway line B*, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downsream Representation
gr_edit .yaxis1.reset_rule 0 .4 .1, tickset(major) ruletype(range)
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
graph save "FigureA2.gph", replace
drop B*

*Figure A3 (replication of Figure 3 for redistricting years)
matrix B = J(5, 4, .)
forvalues i = 0/4 {
local num = `i' + 1
areg victory`i' treatment rv* if absrv < .3 & year == cycle, a(year) cluster(state_dist)
matrix B[`num', 1] = _b[treatment]
areg victory`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
matrix B[`num', 2] = _b[treatment]
matrix B[`num', 3] = `i'
}
svmat B
graph twoway line B1 B2 B3, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 4 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot1.style.editstyle line(color(green)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dash)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(purple)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .4 2
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(green) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Redistricting Years
gr_edit .plotregion1.AddTextBox added_text editor .3 1.6
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(purple) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush All Years
graph save "FigureA3.gph", replace
drop B*

*Figure A4 (replication of Figure 8 for redistricting years)
matrix B = J(5, 4, .)
forvalues i = 0/4 {
local num = `i' + 1
areg cvp`i' treatment rv* if absrv < .3 & year == cycle, a(year) cluster(state_dist)
matrix B[`num', 1] = _b[treatment]
areg cvp`i' treatment rv* if absrv < .3, a(year) cluster(state_dist)
matrix B[`num', 2] = _b[treatment]
matrix B[`num', 3] = `i'
}
svmat B
graph twoway line B1 B2 B3, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 4 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .yaxis1.reset_rule 0 .4 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot1.style.editstyle line(color(green)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dash)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(purple)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .16 1.5
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(green) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Redistricting Years
gr_edit .plotregion1.AddTextBox added_text editor .12 1
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(purple) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush All Years
graph save "FigureA4.gph", replace
drop B*

***Figure A7 (variation over time in effect of one election on subsequent elections)
matrix B = J(28, 8, .)
forvalues j = 1/7 {
	local maxyear = 2006 - 2*`j'
	forvalues i = 1950(2)`maxyear' {
		local num = (`i' - 1948)/2
		qui:areg victory`j' treatment rv* if absrv < .3 & abs(year - `i') <= 4, a(year) cluster(state_dist)
		matrix B[`num', `j'] = _b[treatment]
	}
}
forvalues i = 1950(2)2004 {
	local num = (`i' - 1948)/2
	matrix B[`num', 8] = `i'
}
svmat B
graph twoway line B*
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Year
gr_edit .xaxis1.reset_rule 1950 2004 6, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 .7 .1, tickset(major) ruletype(range)
gr_edit .xaxis1.plotregion.xscale.curmax = 2005
gr_edit .plotregion1.AddTextBox added_text editor .6 1975
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(navy) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .51 1980
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(maroon) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .31 1998
gr_edit .plotregion1.added_text_new = 3
gr_edit .plotregion1.added_text_rec = 3
gr_edit .plotregion1.added_text[3].style.editstyle  angle(default) size(small) color(forest_green) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .17 1994
gr_edit .plotregion1.added_text_new = 4
gr_edit .plotregion1.added_text_rec = 4
gr_edit .plotregion1.added_text[4].style.editstyle  angle(default) size(small) color(dkorange) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .09 1996
gr_edit .plotregion1.added_text_new = 5
gr_edit .plotregion1.added_text_rec = 5
gr_edit .plotregion1.added_text[5].style.editstyle  angle(default) size(small) color(teal) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor 0 1992
gr_edit .plotregion1.added_text_new = 6
gr_edit .plotregion1.added_text_rec = 6
gr_edit .plotregion1.added_text[6].style.editstyle  angle(default) size(small) color(cranberry) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor -.01 1984
gr_edit .plotregion1.added_text_new = 7
gr_edit .plotregion1.added_text_rec = 7
gr_edit .plotregion1.added_text[7].style.editstyle  angle(default) size(small) color(lavender) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
forvalues i = 1/7 {
	gr_edit .plotregion1.plot`i'.style.editstyle line(width(thick)) editcopy
	gr_edit .plotregion1.added_text[`i'].text = {}
	gr_edit .plotregion1.added_text[`i'].text.Arrpush k = `i'
}
graph save "FigureA7.gph", replace
drop B*

***Figure A8 (variation over time in effect of one election on downstream representation)
matrix B = J(29, 9, .)
forvalues j = 0/7 {
	local jnum = `j' + 1
	local maxyear = 2006 - 2*`j'
	forvalues i = 1950(2)`maxyear' {
		local num = (`i' - 1948)/2
		qui:areg cvp`j' treatment rv* if absrv < .3 & abs(year - `i') <= 4, a(year) cluster(state_dist)
		matrix B[`num', `jnum'] = _b[treatment]
	}
}
forvalues i = 1950(2)2006 {
	local num = (`i' - 1948)/2
	matrix B[`num', 9] = `i'
}
svmat B
graph twoway line B2-B8 B1 B9
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Year
gr_edit .xaxis1.reset_rule 1950 2004 6, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downstreatm Representation
gr_edit .yaxis1.reset_rule 0 .5 .1, tickset(major) ruletype(range)
gr_edit .xaxis1.plotregion.xscale.curmax = 2005
gr_edit .plotregion1.AddTextBox added_text editor .27 1990
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(navy) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .15 1990
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(maroon) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .12 2001
gr_edit .plotregion1.added_text_new = 3
gr_edit .plotregion1.added_text_rec = 3
gr_edit .plotregion1.added_text[3].style.editstyle  angle(default) size(small) color(forest_green) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .07 1999
gr_edit .plotregion1.added_text_new = 4
gr_edit .plotregion1.added_text_rec = 4
gr_edit .plotregion1.added_text[4].style.editstyle  angle(default) size(small) color(dkorange) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .03 1997
gr_edit .plotregion1.added_text_new = 5
gr_edit .plotregion1.added_text_rec = 5
gr_edit .plotregion1.added_text[5].style.editstyle  angle(default) size(small) color(teal) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor -.01 1990
gr_edit .plotregion1.added_text_new = 6
gr_edit .plotregion1.added_text_rec = 6
gr_edit .plotregion1.added_text[6].style.editstyle  angle(default) size(small) color(cranberry) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .01 1977
gr_edit .plotregion1.added_text_new = 7
gr_edit .plotregion1.added_text_rec = 7
gr_edit .plotregion1.added_text[7].style.editstyle  angle(default) size(small) color(lavender) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .4 1982
gr_edit .plotregion1.added_text_new = 8
gr_edit .plotregion1.added_text_rec = 8
gr_edit .plotregion1.added_text[8].style.editstyle  angle(default) size(small) color(chocolate) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
forvalues i = 1/7 {
	gr_edit .plotregion1.plot`i'.style.editstyle line(width(thick)) editcopy
	gr_edit .plotregion1.added_text[`i'].text = {}
	gr_edit .plotregion1.added_text[`i'].text.Arrpush k = `i'
}
gr_edit .plotregion1.plot8.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot8.style.editstyle line(color(chocolate)) editcopy
gr_edit .plotregion1.added_text[8].text = {}
gr_edit .plotregion1.added_text[8].text.Arrpush k = 0
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush CVP
graph save "FigureA8_CVP.gph", replace
drop B*
*DW-NOMINATE version
matrix B = J(29, 9, .)
forvalues j = 0/7 {
	local jnum = `j' + 1
	local maxyear = 2006 - 2*`j'
	forvalues i = 1950(2)`maxyear' {
		local num = (`i' - 1948)/2
		qui:areg dw`j' treatment rv* if absrv < .3 & abs(year - `i') <= 4, a(year) cluster(state_dist)
		matrix B[`num', `jnum'] = _b[treatment]
	}
}
forvalues i = 1950(2)2006 {
	local num = (`i' - 1948)/2
	matrix B[`num', 9] = `i'
}
svmat B
graph twoway line B2-B8 B1 B9
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Year
gr_edit .xaxis1.reset_rule 1950 2004 6, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downstreatm Representation
gr_edit .yaxis1.reset_rule 0 .8 .2, tickset(major) ruletype(range)
gr_edit .xaxis1.plotregion.xscale.curmax = 2005
gr_edit .plotregion1.AddTextBox added_text editor .44 1990
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(navy) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .27 1990
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(maroon) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .24 2001
gr_edit .plotregion1.added_text_new = 3
gr_edit .plotregion1.added_text_rec = 3
gr_edit .plotregion1.added_text[3].style.editstyle  angle(default) size(small) color(forest_green) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .13 1999
gr_edit .plotregion1.added_text_new = 4
gr_edit .plotregion1.added_text_rec = 4
gr_edit .plotregion1.added_text[4].style.editstyle  angle(default) size(small) color(dkorange) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .07 1997
gr_edit .plotregion1.added_text_new = 5
gr_edit .plotregion1.added_text_rec = 5
gr_edit .plotregion1.added_text[5].style.editstyle  angle(default) size(small) color(teal) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor -.01 1992
gr_edit .plotregion1.added_text_new = 6
gr_edit .plotregion1.added_text_rec = 6
gr_edit .plotregion1.added_text[6].style.editstyle  angle(default) size(small) color(cranberry) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .02 1977
gr_edit .plotregion1.added_text_new = 7
gr_edit .plotregion1.added_text_rec = 7
gr_edit .plotregion1.added_text[7].style.editstyle  angle(default) size(small) color(lavender) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .59 1982
gr_edit .plotregion1.added_text_new = 8
gr_edit .plotregion1.added_text_rec = 8
gr_edit .plotregion1.added_text[8].style.editstyle  angle(default) size(small) color(chocolate) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
forvalues i = 1/7 {
	gr_edit .plotregion1.plot`i'.style.editstyle line(width(thick)) editcopy
	gr_edit .plotregion1.added_text[`i'].text = {}
	gr_edit .plotregion1.added_text[`i'].text.Arrpush k = `i'
}
gr_edit .plotregion1.plot8.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot8.style.editstyle line(color(chocolate)) editcopy
gr_edit .plotregion1.added_text[8].text = {}
gr_edit .plotregion1.added_text[8].text.Arrpush k = 0
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush DW-NOMINATE
graph save "FigureA8_DW.gph", replace
drop B*
*Figure A8 (Combining CVP and DW)
graph combine "FigureA8_CVP.gph" "FigureA8_DW.gph", col(1)
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .style.editstyle declared_ysize(6) editcopy
gr_edit .plotregion1.graph1.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph2.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph1.yaxis1.title.fill_if_undrawn.setstyle, style(no)
gr_edit .l1title.text = {}
gr_edit .l1title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .l1title.style.editstyle size(medsmall) editcopy
graph save "FigureA8.gph", replace

*How representative are the places that have close elections?
preserve
egen party_dist = mean(treatment), by(state_dist)
g variation = party_dist > 0 & party_dist < 1
sort state_dist
drop if state_dist == state_dist[_n-1]
sum variation
restore
preserve
g decade = floor((year - 2)/10)*10 + 2
egen state_dist_decade = group(state_dist decade)
egen party_dist = mean(treatment), by(state_dist_decade)
g variation = party_dist > 0 & party_dist < 1
sort state_dist_decade
drop if state_dist_decade == state_dist_decade[_n-1]
sum variation
restore
g close = absrv < .02
sum rep_twoparty_pres if close == 1
sum rep_twoparty_pres if close == 0
drop close


*********** U.S. Senate ************
clear
set more off
use "FinalDataSet_Senate.dta"

*Figure 2
areg cvp0 treatment rv* if absrv < .3, a(year) cluster(state)
predict p_1 if treatment == 1
predict p_0 if treatment == 0
sort rep_voteshare
graph twoway (scatter cvp0 rep_voteshare) (line p_1 p_0 rep_voteshare) if absrv < .3, xline(.5)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Republican Vote Share
gr_edit .xaxis1.reset_rule .2 .8 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Conservative Vote Probability
gr_edit .yaxis1.reset_rule -.6 .6 .2 , tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(size(tiny)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(gs8))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. Senate
graph save "Figure2_Senate.gph", replace
drop p_1 p_0
*DW-NOMINATE version
areg dw0 treatment rv* if absrv < .3, a(year) cluster(state)
predict p_1 if treatment == 1
predict p_0 if treatment == 0
sort rep_voteshare
graph twoway (scatter dw0 rep_voteshare) (line p_1 p_0 rep_voteshare) if absrv < .3, xline(.5)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Republican Vote Share
gr_edit .xaxis1.reset_rule .2 .8 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush DW-NOMINATE
gr_edit .yaxis1.reset_rule -1 1 .2, tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(size(tiny)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(gs8))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(red)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. Senate
graph save "Figure2_Senate_DW.gph", replace
drop p_1 p_0

*Figure 3
matrix B = J(8, 4, .)
forvalues i = 0/7 {
areg victory`i' treatment rv* if absrv < .3, a(year) cluster(state)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. Senate
graph save "Figure3_Senate.gph", replace
drop B*

*Figure 8
matrix B = J(21, 4, .)
forvalues i = 0/20 {
areg cvp`i' treatment rv* if absrv < .3, a(year) cluster(state)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Congressional Sessions Downstream
gr_edit .xaxis1.reset_rule 0 20 4, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .yaxis1.reset_rule 0 .4 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. Senate
graph save "Figure8_Senate.gph", replace
drop B*
*DW-NOMINATE Version
matrix B = J(21, 4, .)
forvalues i = 0/20 {
areg dw`i' treatment rv* if absrv < .3, a(year) cluster(state)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Congressional Sessions Downstream
gr_edit .xaxis1.reset_rule 0 20 4, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .yaxis1.reset_rule -.1 .7 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush U.S. Senate
graph save "Figure8_Senate_DW.gph", replace  
drop B*

*Figure A5 (DW Version of Figure 2)
graph combine "Figure2_House_DW.gph" "Figure2_Senate_DW.gph", col(1)
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .style.editstyle declared_ysize(6) editcopy
graph save "FigureA5.gph", replace

*Figure A6 (DW Version of Figure 8)
graph combine "Figure8_House_DW.gph" "Figure8_Senate_DW.gph", col(1)
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .style.editstyle declared_ysize(6) editcopy
gr_edit .plotregion1.graph1.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph2.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph1.yaxis1.title.fill_if_undrawn.setstyle, style(no)
gr_edit .l1title.text = {}
gr_edit .l1title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .l1title.style.editstyle size(medsmall) editcopy
graph save "FigureA6.gph", replace


*********** State Legislatures ************
clear
set more off
use "FinalDataSet_StateLegislatures.dta"

*Figure 2 -- Lower
areg cvp0 treatment rv* if absrv < .3 & lower == 1, a(state_chamber_year) cluster(state_chamber_dist)
predict p_1 if treatment == 1
predict p_0 if treatment == 0
sort rep_voteshare
graph twoway (scatter cvp0 rep_voteshare) (line p_1 p_0 rep_voteshare) if absrv < .3, xline(.5)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Republican Vote Share
gr_edit .xaxis1.reset_rule .2 .8 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Conservative Vote Probability
gr_edit .yaxis1.reset_rule -.8 .8 .2 , tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(size(tiny)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(gs8))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush State Legislatures (Lower)
graph save "Figure2_Lower.gph", replace
drop p_1 p_0
*Figure 2 -- Upper
areg cvp0 treatment rv* if absrv < .3 & lower == 0, a(state_chamber_year) cluster(state_chamber_dist)
predict p_1 if treatment == 1
predict p_0 if treatment == 0
sort rep_voteshare
graph twoway (scatter cvp0 rep_voteshare) (line p_1 p_0 rep_voteshare) if absrv < .3, xline(.5)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Republican Vote Share
gr_edit .xaxis1.reset_rule .2 .8 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Conservative Vote Probability
gr_edit .yaxis1.reset_rule -.8 .8 .2 , tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(size(tiny)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(fillcolor(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle marker(linestyle(color(gs8))) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush State Legislatures (Upper)
graph save "Figure2_Upper.gph", replace

*Figure 2 (combining all settings)
graph combine "Figure2_House.gph" "Figure2_Senate.gph" "Figure2_Lower.gph" "Figure2_Upper.gph", col(2)
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.graph1.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph2.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph3.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph4.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph1.yaxis1.title.fill_if_undrawn.setstyle, style(no)
gr_edit .l1title.text = {}
gr_edit .l1title.text.Arrpush Conservative Vote Probability
gr_edit .l1title.style.editstyle size(medsmall) editcopy
graph save "Figure2.gph", replace

*Figure 3 -- Lower
matrix B = J(15, 4, .)
forvalues i = 0/14 {
areg victory`i' treatment rv* if absrv < .3 & lower == 1, a(state_chamber_year) cluster(state_chamber_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 14 2, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush State Legislatures (Lower)
graph save "Figure3_Lower.gph", replace
drop B*
*Figure 3 -- Upper
matrix B = J(8, 4, .)
forvalues i = 0/7 {
areg victory`i' treatment rv* if absrv < .3 & lower == 0, a(state_chamber_year) cluster(state_chamber_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush State Legislatures (Upper)
graph save "Figure3_Upper.gph", replace
drop B*

*Figure 3 (combining all settings)
graph combine "Figure3_House.gph" "Figure3_Senate.gph" "Figure3_Lower.gph" "Figure3_Upper.gph", col(2)
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.graph1.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph2.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph3.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph4.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph1.yaxis1.title.fill_if_undrawn.setstyle, style(no)
gr_edit .l1title.text = {}
gr_edit .l1title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .l1title.style.editstyle size(medsmall) editcopy
graph save "Figure3.gph", replace

*Figure 5
matrix B = J(6, 4, .)
forvalues i = 0/5 {
local num = `i' + 1
areg victory`i' treatment rv* if absrv < .3 & termlimit == 1, a(state_chamber_year) cluster(state_chamber_dist)
matrix B[`num', 1] = _b[treatment]
areg victory`i' treatment rv* if absrv < .3 & termlimit == 0, a(state_chamber_year) cluster(state_chamber_dist)
matrix B[`num', 2] = _b[treatment]
matrix B[`num', 3] = `i'
}
svmat B
graph twoway line B1 B2 B3, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 5 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Subsequent Elections
gr_edit .yaxis1.reset_rule 0 1 .2, tickset(major) ruletype(range)
gr_edit .plotregion1.plot1.style.editstyle line(color(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dash)) editcopy 
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor .1 1.9
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(gs8) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Term Limits
gr_edit .plotregion1.AddTextBox added_text editor .2 2.9
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush No Term Limits
graph save "Figure5.gph", replace
drop B*

*Figure 8 -- Lower
matrix B = J(15, 4, .)
forvalues i = 0/14 {
areg cvp`i' treatment rv* if absrv < .3 & lower == 1, a(state_chamber_year) cluster(state_chamber_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 14 2, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .yaxis1.reset_rule 0 .4 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush State Legislatures (Lower)
graph save "Figure8_Lower.gph", replace
drop B*
*Figure 8 -- Upper
matrix B = J(8, 4, .)
forvalues i = 0/7 {
areg cvp`i' treatment rv* if absrv < .3 & lower == 0, a(state_chamber_year) cluster(state_chamber_dist)
local num = `i' + 1
matrix B[`num', 1] = _b[treatment]
matrix B[`num', 2] = _b[treatment] + 1.96*_se[treatment]
matrix B[`num', 3] = _b[treatment] - 1.96*_se[treatment]
matrix B[`num', 4] = `i'
}
svmat B
graph twoway line B2 B3 B1 B4, yline(0)
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Terms Downstream
gr_edit .xaxis1.reset_rule 0 7 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .yaxis1.reset_rule 0 .4 .1, tickset(major) ruletype(range)
gr_edit .plotregion1.plot3.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(pattern(dot)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(pattern(dot)) editcopy 
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(color(black)) editcopy
gr_edit .plotregion1._xylines[1].style.editstyle linestyle(pattern(dash)) editcopy
gr_edit .title.style.editstyle color(black) editcopy
gr_edit .title.text = {}
gr_edit .title.text.Arrpush State Legislatures (Upper)
graph save "Figure8_Upper.gph", replace
drop B*

*Figure 8 (combining all settings)
graph combine "Figure8_House.gph" "Figure8_Senate.gph" "Figure8_Lower.gph" "Figure8_Upper.gph", col(2)
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.graph1.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph2.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph3.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph4.yaxis1.title.draw_view.setstyle, style(no)
gr_edit .plotregion1.graph1.yaxis1.title.fill_if_undrawn.setstyle, style(no)
gr_edit .l1title.text = {}
gr_edit .l1title.text.Arrpush Effect of One Election on Downstream Representation
gr_edit .l1title.style.editstyle size(medsmall) editcopy
graph save "Figure8.gph", replace


