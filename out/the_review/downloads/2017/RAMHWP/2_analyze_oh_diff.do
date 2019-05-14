clear all
cd "~/Dropbox/Apps/ShareLaTeX/WA MPSA 2017/replication/data"

use OH_Diff_2016_anon, clear

xtset id

//Primary Results - Compare those canvassed to everyone else
xtreg presidential canvassed i.t, fe cl(id)
xtreg senate canvassed i.t, fe cl(id)

//Robustness Test - Compare those canvassed to those attempted
xtreg presidential canvassed i.t if ever_attempted == 1, fe cl(id)
xtreg senate canvassed i.t if ever_attempted == 1, fe cl(id)

//Placebo Test - Differential Trends Graphs
preserve
collapse presidential senate, by(first_canvass t)
	graph twoway (connect presidential t if first_canvass == 1, ms(smcircle_hollow) color(gs12)) || (connect presidential t if first_canvass == 2, ms(smdiamond_hollow) color(gs10)) || (connect presidential t if first_canvass == 3, ms(smtriangle_hollow) color(gs8)) || (connect presidential t if first_canvass == 4, ms(smsquare_hollow) color(gs6)) || (connect presidential t if first_canvass == 99, ms(X) msize(large) color(red)), scheme(s1color) ////
	legend(label(1 "Canvassed by Time 1") ////
	label(2 "Canvassed by Time 2") ////
	label(3 "Canvassed by Time 3") ////
	label(4 "Canvassed by Time 4") ////
	label(5 "Never Canvassed")) ////
	ytitle("Presidential Outcome Factor") saving(pres_oh, replace)

	graph twoway (connect senate t if first_canvass == 1, ms(smcircle_hollow) color(gs12)) || (connect senate t if first_canvass == 2, ms(smdiamond_hollow) color(gs10)) || (connect senate t if first_canvass == 3, ms(smtriangle_hollow) color(gs8)) || (connect senate t if first_canvass == 4, ms(smsquare_hollow) color(gs6)) || (connect senate t if first_canvass == 99, ms(X) msize(large) color(red)), scheme(s1color) ////
	legend(label(1 "Canvassed by Time 1") ////
	label(2 "Canvassed by Time 2") ////
	label(3 "Canvassed by Time 3") ////
	label(4 "Canvassed by Time 4") ////
	label(5 "Never Canvassed")) ////
	ytitle("Senate Outcome Factor") saving(senate_oh, replace)

	grc1leg pres_oh.gph senate_oh.gph, scheme(s1color) ycommon
	graph export ../SI/oh_parallel_trends.pdf, replace
restore

//Placebo Test - Regression
eststo clear
quietly eststo: xtreg presidential ever_canvassed i.t if inlist(first_canvass, 2, 99) & inlist(t, 0, 1), cl(id)
quietly eststo: xtreg presidential ever_canvassed i.t if inlist(first_canvass, 3, 99) & inlist(t, 0, 1, 2), cl(id)
quietly eststo: xtreg presidential ever_canvassed i.t if inlist(first_canvass, 4, 99) & inlist(t, 0, 1, 2, 3), cl(id)
esttab, mtitles("Canvassed t2" "Canvassed t3" "Canvassed t4") b(3) se(2) coeflabels(ever_canvassed "Canvassed") title("Testing Presidential Parallel Trends")

eststo clear
quietly eststo: xtreg senate ever_canvassed i.t if inlist(first_canvass, 2, 99) & inlist(t, 0, 1), cl(id)
quietly eststo: xtreg senate ever_canvassed i.t if inlist(first_canvass, 3, 99) & inlist(t, 0, 1, 2), cl(id)
quietly eststo: xtreg senate ever_canvassed i.t if inlist(first_canvass, 4, 99) & inlist(t, 0, 1, 2, 3), cl(id)
esttab, mtitles("Canvassed t2" "Canvassed t3" "Canvassed t4") b(3) se(2) coeflabels(ever_canvassed "Canvassed") title("Testing Senate Parallel Trends")
