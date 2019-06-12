***Table 1*** (Weather and Presidential Elections)
clear
set matsize 11000
set more off
use "WeatherPresidentialElections.dta"
g norain = precip == 0
g voteshare = (100 - GOPVoteShare)/100
rename Turnout turnout
rename Year year
rename FIPS_County county
replace turnout = turnout/100
keep turnout voteshare year county norain
forvalues i = 1952(4)2000{
g yr`i' = year == `i'
}
drop if year == 1968
drop yr1968
*Point Estimates*
areg turnout norain yr*, a(county) cluster(county)
scalar marginal = _b[norain]
predict p_turnout
sum p_turnout if norain == 0
scalar regular = r(mean)
areg voteshare norain yr*, a(county) cluster(county)
scalar v_effect = _b[norain]
predict p_voteshare
sum p_voteshare if norain == 0
scalar v_regular = r(mean)
scalar v_marginal = ((regular+marginal)*(v_regular+v_effect) - regular*v_regular)/marginal
disp v_regular
disp v_marginal
disp v_marginal - v_regular
*Bootstrapped Confidence Intervals*
drop p_turnout p_voteshare
matrix C = J(10000,6,.)
forvalues i = 1/10000 {
quietly{
preserve
bsample, cluster(county)
areg turnout norain yr*, a(county)
scalar marginal = _b[norain]
predict p_turnout
sum p_turnout if norain == 0
scalar regular = r(mean)
areg voteshare norain yr*, a(county)
scalar v_effect = _b[norain]
predict p_voteshare
sum p_voteshare if norain == 0
scalar v_regular = r(mean)
scalar v_marginal = ((regular+marginal)*(v_regular+v_effect) - regular*v_regular)/marginal
matrix C[`i',1] = marginal
matrix C[`i',2] = v_effect
matrix C[`i',3] = v_marginal
matrix C[`i',4] = v_regular
matrix C[`i',5] = regular
matrix C[`i',6] = v_marginal - v_regular
restore
}
if (`i'/1000) == round(`i'/1000){
	disp `i'
	}
}
svmat C
g diff = C3 - C4
forvalues i = 1/6{
sort C`i'
sum C`i' if _n == 251
sum C`i' if _n == 9750
count if C`i' < 0
}

***Gubernatorial Election Analysis***
***Figure 1***
clear
set more off
use "GubernatorialStateMeans.dta"
*Figure 1a*
ttest presturnout, by(on) unequal
kdensity presturnout if on == 1, nograph at(presturnout) g(p_t_on) bw(.04)
kdensity presturnout if on == 0, nograph at(presturnout) g(p_t_off) bw(.04)
sort presturnout
graph twoway line p_t_on p_t_off presturnout
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Turnout in Presidential Elections (1992-2008)
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Density
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.reset_rule .3 .7 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.reset_rule 0 6 2 , tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .style.editstyle declared_ysize(2.5) editcopy
graph save "Figure1a.gph", replace
*Figure 1b*
ttest presvote, by(on) unequal
kdensity presvote if on == 1, nograph at(presvote) g(p_v_on) bw(.04)
kdensity presvote if on == 0, nograph at(presvote) g(p_v_off) bw(.04)
sort presvote
graph twoway line p_v_on p_v_off presvote
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Democratic Vote Share in Presidential Elections (1992-2008)
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Density
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.reset_rule .3 .7 .1 , tickset(major) ruletype(range)
gr_edit .yaxis1.reset_rule 0 6 2 , tickset(major) ruletype(range)  
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .style.editstyle declared_ysize(2.5) editcopy
graph save "Figure1b.gph", replace
*Figure 1c*
ttest govturnout, by(on) unequal
kdensity govturnout if on == 1, nograph at(govturnout) g(g_t_on) bw(.04)
kdensity govturnout if on == 0, nograph at(govturnout) g(g_t_off) bw(.04)
sort govturnout
graph twoway line g_t_on g_t_off govturnout
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Turnout in Gubernatorial Elections (1991-2010)
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Density
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .xaxis1.reset_rule .3 .7 .1 , tickset(major) ruletype(range) 
gr_edit .yaxis1.reset_rule 0 6 2 , tickset(major) ruletype(range) 
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(color(gs8)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(black)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .style.editstyle declared_ysize(2.5) editcopy
graph save "Figure1c.gph", replace
graph combine "Figure1a.gph" "Figure1b.gph" "Figure1c.gph", col(1)
gr_edit .style.editstyle declared_ysize(7) editcopy
gr_edit .style.editstyle margin(zero) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .plotregion1.graph1.plotregion1.AddTextBox added_text editor 5.236232994540384 .6296213050302919
gr_edit .plotregion1.graph1.plotregion1.added_text_new = 1
gr_edit .plotregion1.graph1.plotregion1.added_text_rec = 1
gr_edit .plotregion1.graph1.plotregion1.added_text[1].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph1.plotregion1.added_text[1].style.editstyle color(gs8) editcopy
gr_edit .plotregion1.graph1.plotregion1.added_text[1].text = {}
gr_edit .plotregion1.graph1.plotregion1.added_text[1].text.Arrpush On Cycle
gr_edit .plotregion1.graph1.plotregion1.AddTextBox added_text editor 2.8319740764066 .4375789555641934
gr_edit .plotregion1.graph1.plotregion1.added_text_new = 2
gr_edit .plotregion1.graph1.plotregion1.added_text_rec = 2
gr_edit .plotregion1.graph1.plotregion1.added_text[2].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph1.plotregion1.added_text[2].text = {}
gr_edit .plotregion1.graph1.plotregion1.added_text[2].text.Arrpush Off Cycle
gr_edit .plotregion1.graph2.plotregion1.AddTextBox added_text editor 1.300087395182921 .5601788255035283
gr_edit .plotregion1.graph2.plotregion1.added_text_new = 1
gr_edit .plotregion1.graph2.plotregion1.added_text_rec = 1
gr_edit .plotregion1.graph2.plotregion1.added_text[1].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[1].style.editstyle color(gs8) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[1].text = {}
gr_edit .plotregion1.graph2.plotregion1.added_text[1].text.Arrpush On Cycle
gr_edit .plotregion1.graph2.plotregion1.AddTextBox added_text editor 2.822784710000976 .6028896506953874
gr_edit .plotregion1.graph2.plotregion1.added_text_new = 2
gr_edit .plotregion1.graph2.plotregion1.added_text_rec = 2
gr_edit .plotregion1.graph2.plotregion1.added_text[2].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[2].text = {}
gr_edit .plotregion1.graph2.plotregion1.added_text[2].text.Arrpush Off Cycle
gr_edit .plotregion1.graph3.plotregion1.AddTextBox added_text editor 4.763716466081656 .5707975733390975
gr_edit .plotregion1.graph3.plotregion1.added_text_new = 1
gr_edit .plotregion1.graph3.plotregion1.added_text_rec = 1
gr_edit .plotregion1.graph3.plotregion1.added_text[1].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph3.plotregion1.added_text[1].style.editstyle color(gs8) editcopy
gr_edit .plotregion1.graph3.plotregion1.added_text[1].text = {}
gr_edit .plotregion1.graph3.plotregion1.added_text[1].text.Arrpush On Cycle
gr_edit .plotregion1.graph3.plotregion1.AddTextBox added_text editor 5.511708129501052 .3277854839506081
gr_edit .plotregion1.graph3.plotregion1.added_text_new = 2
gr_edit .plotregion1.graph3.plotregion1.added_text_rec = 2
gr_edit .plotregion1.graph3.plotregion1.added_text[2].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph3.plotregion1.added_text[2].text = {}
gr_edit .plotregion1.graph3.plotregion1.added_text[2].text.Arrpush Off Cycle
gr_edit .plotregion1.graph3.plotregion1.added_text[2].DragBy .0801419639377936 -.0049721143608898
gr_edit .plotregion1.graph1.plotregion1.AddTextBox added_text editor 6 .3
gr_edit .plotregion1.graph1.plotregion1.added_text_new = 3
gr_edit .plotregion1.graph1.plotregion1.added_text_rec = 3
gr_edit .plotregion1.graph1.plotregion1.added_text[3].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph1.plotregion1.added_text[3].text = {}
gr_edit .plotregion1.graph1.plotregion1.added_text[3].text.Arrpush On Cycle Mean = .585
gr_edit .plotregion1.graph1.plotregion1.AddTextBox added_text editor 5.5 .3
gr_edit .plotregion1.graph1.plotregion1.added_text_new = 4
gr_edit .plotregion1.graph1.plotregion1.added_text_rec = 4
gr_edit .plotregion1.graph1.plotregion1.added_text[4].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph1.plotregion1.added_text[4].text = {}
gr_edit .plotregion1.graph1.plotregion1.added_text[4].text.Arrpush Off Cycle Mean = .588
gr_edit .plotregion1.graph1.plotregion1.AddTextBox added_text editor 5.0 .3
gr_edit .plotregion1.graph1.plotregion1.added_text_new = 5
gr_edit .plotregion1.graph1.plotregion1.added_text_rec = 5
gr_edit .plotregion1.graph1.plotregion1.added_text[5].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph1.plotregion1.added_text[5].text = {}
gr_edit .plotregion1.graph1.plotregion1.added_text[5].text.Arrpush Difference = -.003
gr_edit .plotregion1.graph1.plotregion1.AddTextBox added_text editor 4.5 .3
gr_edit .plotregion1.graph1.plotregion1.added_text_new = 6
gr_edit .plotregion1.graph1.plotregion1.added_text_rec = 6
gr_edit .plotregion1.graph1.plotregion1.added_text[6].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph1.plotregion1.added_text[6].text = {}
gr_edit .plotregion1.graph1.plotregion1.added_text[6].text.Arrpush p-value = .869
gr_edit .plotregion1.graph2.plotregion1.AddTextBox added_text editor 6 .3
gr_edit .plotregion1.graph2.plotregion1.added_text_new = 3
gr_edit .plotregion1.graph2.plotregion1.added_text_rec = 3
gr_edit .plotregion1.graph2.plotregion1.added_text[3].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[3].text = {}
gr_edit .plotregion1.graph2.plotregion1.added_text[3].text.Arrpush On Cycle Mean = .472
gr_edit .plotregion1.graph2.plotregion1.AddTextBox added_text editor 5.5 .3
gr_edit .plotregion1.graph2.plotregion1.added_text_new = 4
gr_edit .plotregion1.graph2.plotregion1.added_text_rec = 4
gr_edit .plotregion1.graph2.plotregion1.added_text[4].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[4].text = {}
gr_edit .plotregion1.graph2.plotregion1.added_text[4].text.Arrpush Off Cycle Mean = .498
gr_edit .plotregion1.graph2.plotregion1.AddTextBox added_text editor 5.0 .3
gr_edit .plotregion1.graph2.plotregion1.added_text_new = 5
gr_edit .plotregion1.graph2.plotregion1.added_text_rec = 5
gr_edit .plotregion1.graph2.plotregion1.added_text[5].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[5].text = {}
gr_edit .plotregion1.graph2.plotregion1.added_text[5].text.Arrpush Difference = -.026
gr_edit .plotregion1.graph2.plotregion1.AddTextBox added_text editor 4.5 .3
gr_edit .plotregion1.graph2.plotregion1.added_text_new = 6
gr_edit .plotregion1.graph2.plotregion1.added_text_rec = 6
gr_edit .plotregion1.graph2.plotregion1.added_text[6].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph2.plotregion1.added_text[6].text = {}
gr_edit .plotregion1.graph2.plotregion1.added_text[6].text.Arrpush p-value = .379
gr_edit .plotregion1.graph3.plotregion1.AddTextBox added_text editor 2.5 .58
gr_edit .plotregion1.graph3.plotregion1.added_text_new = 3
gr_edit .plotregion1.graph3.plotregion1.added_text_rec = 3
gr_edit .plotregion1.graph3.plotregion1.added_text[3].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph3.plotregion1.added_text[3].text = {}
gr_edit .plotregion1.graph3.plotregion1.added_text[3].text.Arrpush On Cycle Mean = .556
gr_edit .plotregion1.graph3.plotregion1.AddTextBox added_text editor 2.0 .58
gr_edit .plotregion1.graph3.plotregion1.added_text_new = 4
gr_edit .plotregion1.graph3.plotregion1.added_text_rec = 4
gr_edit .plotregion1.graph3.plotregion1.added_text[4].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph3.plotregion1.added_text[4].text = {}
gr_edit .plotregion1.graph3.plotregion1.added_text[4].text.Arrpush Off Cycle Mean = .405
gr_edit .plotregion1.graph3.plotregion1.AddTextBox added_text editor 1.5 .58
gr_edit .plotregion1.graph3.plotregion1.added_text_new = 5
gr_edit .plotregion1.graph3.plotregion1.added_text_rec = 5
gr_edit .plotregion1.graph3.plotregion1.added_text[5].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph3.plotregion1.added_text[5].text = {}
gr_edit .plotregion1.graph3.plotregion1.added_text[5].text.Arrpush Difference = .151
gr_edit .plotregion1.graph3.plotregion1.AddTextBox added_text editor 1.0 .58
gr_edit .plotregion1.graph3.plotregion1.added_text_new = 6
gr_edit .plotregion1.graph3.plotregion1.added_text_rec = 6
gr_edit .plotregion1.graph3.plotregion1.added_text[6].style.editstyle  angle(default) size(medsmall) color(black) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.graph3.plotregion1.added_text[6].text = {}
gr_edit .plotregion1.graph3.plotregion1.added_text[6].text.Arrpush p-value = .000
graph save "Figure1.gph", replace


***Table 2*** 
clear
set matsize 11000
set more off
use "GubernatorialData.dta"
g voteshare = dem/(dem + rep)
g demwin = dem > rep
g turnout = (dem+rep)/vep
g on = floor(year/4) == (year/4)
*Point Estimates*
reg turnout on pres_normal pres_turnout [aw = vep], cluster(state)
scalar marginal = _b[on]
predict p_turnout
sum p_turnout if on == 0
scalar regular = r(mean)
reg voteshare on pres_normal pres_turnout [aw = vep], cluster(state)
scalar v_effect = _b[on]
predict p_voteshare
sum p_voteshare if on == 0
scalar v_regular = r(mean)
reg demwin on pres_normal pres_turnout [aw = vep], cluster(state)
scalar v_marginal = ((regular+marginal)*(v_regular+v_effect) - regular*v_regular)/marginal
disp v_regular
disp v_marginal
disp v_marginal - v_regular
*Bootstrapped Confidence Intervals*
drop p_turnout p_voteshare
scalar below_zero = 0
local samples = 10000
matrix C = J(`samples',16,.)
forvalues i = 1/`samples' {
quietly{
preserve
bsample, cluster(state)
reg turnout on pres_normal pres_turnout [aw = vep]
scalar marginal = _b[on]
scalar npv1 = _b[pres_normal]
scalar npt1 = _b[pres_turnout]
scalar cons1 = _b[_cons]
predict p_turnout
sum p_turnout if on == 0
scalar regular = r(mean)
reg voteshare on pres_normal pres_turnout [aw = vep]
scalar v_effect = _b[on]
scalar npv2 = _b[pres_normal]
scalar npt2 = _b[pres_turnout]
scalar cons2 = _b[_cons]
predict p_voteshare
sum p_voteshare if on == 0
scalar v_regular = r(mean)
scalar v_marginal = ((regular+marginal)*(v_regular+v_effect) - regular*v_regular)/marginal
reg demwin on pres_normal pres_turnout [aw = vep]
scalar victory_effect = _b[on]
scalar npv3 = _b[pres_normal]
scalar npt3 = _b[pres_turnout]
scalar cons3 = _b[_cons]
matrix C[`i',1] = regular
matrix C[`i',2] = marginal
matrix C[`i',3] = v_regular
matrix C[`i',4] = v_marginal
matrix C[`i',5] = v_marginal - v_regular
matrix C[`i',6] = v_effect
matrix C[`i',7] = victory_effect
matrix C[`i',8] = npv1
matrix C[`i',9] = npv2
matrix C[`i',10] = npv3
matrix C[`i',11] = npt1
matrix C[`i',12] = npt2
matrix C[`i',13] = npt3
matrix C[`i',14] = cons1
matrix C[`i',15] = cons2
matrix C[`i',16] = cons3
if (v_marginal - v_regular) < 0 {
	scalar below_zero = below_zero + 1
	}	
restore
}
if (`i'/1000) == round(`i'/1000){
	disp `i'
	}
}
disp (below_zero/`samples')*2
svmat C
forvalues i = 1/16{
sort C`i'
sum C`i' if _n == 251
sum C`i' if _n == 9750
count if C`i' < 0
}


***Table A1***
clear
set matsize 11000
set more off
use "GubernatorialData.dta"
g voteshare = dem/(dem + rep)
g demwin = dem > rep
g turnout = (dem+rep)/vep
g on = floor(year/4) == (year/4)
g dem_pres_approval = dem_pres*approval
*Point Estimates*
reg turnout on pres_normal pres_turnout dem_pres approval dem_pres_approval [aw = vep], cluster(state)
scalar marginal = _b[on]
predict p_turnout
sum p_turnout if on == 0
scalar regular = r(mean)
reg voteshare on pres_normal pres_turnout dem_pres approval dem_pres_approval [aw = vep], cluster(state)
scalar v_effect = _b[on]
predict p_voteshare
sum p_voteshare if on == 0
scalar v_regular = r(mean)
reg demwin on pres_normal pres_turnout dem_pres approval dem_pres_approval [aw = vep], cluster(state)
scalar v_marginal = ((regular+marginal)*(v_regular+v_effect) - regular*v_regular)/marginal
disp v_regular
disp v_marginal
disp v_marginal - v_regular
*Bootstrapped Confidence Intervals*
drop p_turnout p_voteshare
scalar below_zero = 0
local samples = 10000
matrix C = J(`samples',5,.)
forvalues i = 1/`samples' {
quietly{
preserve
bsample, cluster(state)
reg turnout on pres_normal pres_turnout dem_pres approval dem_pres_approval [aw = vep]
scalar marginal = _b[on]
predict p_turnout
sum p_turnout if on == 0
scalar regular = r(mean)
reg voteshare on pres_normal pres_turnout dem_pres approval dem_pres_approval [aw = vep]
scalar v_effect = _b[on]
predict p_voteshare
sum p_voteshare if on == 0
scalar v_regular = r(mean)
scalar v_marginal = ((regular+marginal)*(v_regular+v_effect) - regular*v_regular)/marginal
matrix C[`i',1] = regular
matrix C[`i',2] = marginal
matrix C[`i',3] = v_regular
matrix C[`i',4] = v_marginal
matrix C[`i',5] = v_marginal - v_regular
if (v_marginal - v_regular) < 0 {
	scalar below_zero = below_zero + 1
	}	
restore
}
if (`i'/1000) == round(`i'/1000){
	disp `i'
	}
}
disp (below_zero/`samples')*2
svmat C
forvalues i = 1/5{
sort C`i'
sum C`i' if _n == 251
sum C`i' if _n == 9750
count if C`i' < 0
}


***Table 3, Rows 1-6*** (ANES Analysis)
clear
set more off
use "ANES.dta" 
g age = 0
replace age = 18 if VCF0101 >= 17
replace age = 25 if VCF0101 >= 25
replace age = 30 if VCF0101 >= 30 
replace age = 35 if VCF0101 >= 35
replace age = 40 if VCF0101 >= 40 
replace age = 45 if VCF0101 >= 45
replace age = 50 if VCF0101 >= 50
replace age = 60 if VCF0101 >= 60
replace age = 70 if VCF0101 >= 70
replace age = 80 if VCF0101 >= 80 
rename VCF0110 education
rename VCF0114 income
replace income = 0 if income == .
g male = VCF0104 == 1
rename VCF0004 year
drop if year == 1948
g presyear = floor(year/4) == (year/4)
keep if presyear == 1
drop presyear
g white = VCF0106a == 1
g black = VCF0106a == 2
g hispanic = VCF0106a == 5
g valid_years = year == 1964 | year == 1976 | year == 1980 | year == 1984 | year == 1988
g turnout_reported = VCF0702 == 2
g turnout_validated = VCF9155 == 1
replace turnout_validated = . if valid_years == 0
g pres_choice = .
replace pres_choice = 0 if turnout_reported == 0
replace pres_choice = 1 if VCF0704 == 1
replace pres_choice = -1 if VCF0704 == 2
g pres_choice_valid = pres_choice if valid_years == 1
replace pres_choice_valid = 0 if turnout_validated == 0
g intent = VCF0713 == 2 | VCF0713 == 1
g votechoice = .
replace votechoice = 0 if VCF9023 == 2
replace votechoice = 1 if VCF9023 == 1
replace votechoice = 0 if VCF0704 == 2
replace votechoice = 1 if VCF0704 == 1
*reported preferences, reported turnout
ttest votechoice, by(turnout_reported) unequal
*predicted preference, reported turnout
xi:mlogit pres_choice i.age white black hispanic i.year i.edu i.income male
predict p_rep p_abstain p_dem
g p_dem_conditional = p_dem/(p_dem + p_rep)
ttest p_dem_conditional, by(turnout_reported) unequal
drop p_*
*intended to vote but didn't, reported turnout
sum votechoice if intent == 1 & turnout_reported == 0
*reported preferences, validated turnout
ttest votechoice, by(turnout_validated) unequal
*MNL validated
xi:mlogit pres_choice_valid i.age white black hispanic i.year i.edu i.income male if valid_years == 1
predict p_rep p_abstain p_dem
g p_dem_conditional = p_dem/(p_dem + p_rep)
ttest p_dem_conditional, by(turnout_validated) unequal
drop p_*
*intended to vote but didn't, validated turnout
sum votechoice if intent == 1 & turnout_reported == 0


***Table 3, Row 7*** (Catalist Analysis)
clear
set more off
use "CatalistData.dta"
sum dem_voted
scalar d_v = r(sum)
sum rep_voted
scalar r_v = r(sum)
sum dem_non
scalar d_n = r(sum)
sum rep_non
scalar r_n = r(sum)
disp d_v/(d_v + r_v)
disp d_n/(d_n + r_n)
disp d_n/(d_n + r_n) -  d_v/(d_v + r_v)



