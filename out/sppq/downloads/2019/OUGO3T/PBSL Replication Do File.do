**Replication Do File for "Professional Backgrounds in State Legislatures, 1993-2012"
**Todd Makse, November 2018
**Figure 1
use "PBSL Occupations by Period.dta", clear 
xtline pct, t(period) i(order) overlay
	gr_edit .legend.plotregion1.key[1].view.style.editstyle line(pattern(dash)) editcopy
	gr_edit .xaxis1.style.editstyle majorstyle(use_labels(yes)) editcopy
	gr_edit .xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .yaxis1.title.style.editstyle size(small) editcopy
	gr_edit .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Percentage of All Legislators
	gr_edit .yaxis1.title.style.editstyle margin(small) editcopy
	gr_edit .legend.Edit , style(cols(3)) style(rows(0)) style(col_gap(medlarge)) style(key_ysize(small)) keepstyles 
	gr_edit .legend.Edit, style(labelstyle(size(vsmall)))
	gr_edit .legend.plotregion1.key[4].view.style.editstyle line(pattern(dot)) editcopy
	gr_edit .legend.plotregion1.key[4].view.style.editstyle line(color(black)) editcopy
	gr_edit .plotregion1.plot4.style.editstyle line(pattern(vshortdash)) editcopy
	gr_edit .legend.plotregion1.key[7].view.style.editstyle line(pattern(longdash)) editcopy
	gr_edit .legend.plotregion1.key[8].view.style.editstyle line(pattern(shortdash)) editcopy
	gr_edit .legend.plotregion1.key[2].view.style.editstyle line(pattern(shortdash)) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
	gr_edit .style.editstyle declared_xsize(3.5) editcopy
	gr_edit .xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(vsmall)))) editcopy

**Figure 2
use "PBSL Occupations by Time and Party.dta", clear 
twoway dropline chg_time order in 1/34 , horizontal xline(0) ylabel(1 "Homemaker" 2 "Conservation professions" 3 "Office workers and clerical" 4 "Humanities professions" 5 "Social scientist" 6 "Physical scientist" 7 "Technician" 8 "Social worker" 9 "Sports and entertainment" 10 "Semi-skilled laborer" 11 "Retail and service professions" 12 "Unskilled laborer" 13 "Education administrator" 14 "Operations manager" 15 "Journalism and media" 16 "Finance and banking" 17 "Engineer" 18 "Doctor" 19 "Consultant" 20 "Sales" 21 "Military professions" 22 "Contractors and construction" 23 "Management specialist" 24 "Clergy" 25 "Skilled trades" 26 "Medical professions" 27 "Government" 28 "Financial specialists" 29 "Transportation professions" 30 "Education staff" 31 "Nonprofit" 32 "Design professions" 33 "IT professions" 34 "Artist")
	gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .yaxis1.style.editstyle majorstyle(tickangle(horizontal)) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
	gr_edit .xaxis1.title.style.editstyle size(small) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush % Change in Background Prevalence, 1993-1994 to 2011-2012
	gr_edit .xaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .xaxis1.title.style.editstyle margin(small) editcopy
	gr_edit .yaxis1.title.text = {}
	

**Figure 3 
use "PBSL Occupations by Time and Party.dta", clear 
graph hbar (asis) pct_gop , over(occ_name) yline(48.2)
	gr_edit .style.editstyle declared_ysize(3) editcopy
	gr_edit .gmetric_mult = .7
	gr_edit .plotregion1.GraphEdit, cmd(_set_sort_height 1)
	gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .scaleaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .scaleaxis.title.style.editstyle margin(small) editcopy
	gr_edit .scaleaxis.title.text = {}
	gr_edit .scaleaxis.title.text.Arrpush Percent of Republican Legislators from Occupation
	gr_edit .scaleaxis.title.style.editstyle size(small) editcopy
	gr_edit .note.text = {}
	gr_edit .note.text.Arrpush Note: vertical line reflects average across all professions
	gr_edit .note.style.editstyle horizontal(center) editcopy
	gr_edit .note.style.editstyle box_alignment(south) editcopy
	gr_edit .note.style.editstyle size(small) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy

**Figure 4
use "PBSL Occupations by Gender Race Legislative Traits.dta", clear 
graph hbar prof_high prof_low, over(order) xalternate
	gr_edit .legend.plotregion1.label[1].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[1].text = {}
	gr_edit .legend.plotregion1.label[1].text.Arrpush Highest Professionalism
	gr_edit .legend.plotregion1.label[2].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[2].text = {}
	gr_edit .legend.plotregion1.label[2].text.Arrpush Lowest Professionalism
	gr_edit .legend.Edit , style(stacked(yes)) keepstyles 
	gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .scaleaxis.title.text = {}
	gr_edit .scaleaxis.title.text.Arrpush Percentage of Legislators from Occupation
	gr_edit .scaleaxis.title.style.editstyle margin(small) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy


**Figure 5 
use "PBSL Occupations by Gender Race Legislative Traits.dta", clear 
graph hbar turn_high turn_low, over(order) xalternate
	gr_edit .legend.plotregion1.label[1].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[1].text = {}
	gr_edit .legend.plotregion1.label[1].text.Arrpush Highest Turnover
	gr_edit .legend.plotregion1.label[2].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[2].text = {}
	gr_edit .legend.plotregion1.label[2].text.Arrpush Lowest Turnover
	gr_edit .legend.Edit , style(stacked(yes)) keepstyles 
	gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .scaleaxis.title.text = {}
	gr_edit .scaleaxis.title.text.Arrpush Percentage of Legislators from Occupation
	gr_edit .scaleaxis.title.style.editstyle margin(small) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy

**Figure 6
use "PBSL Occupations by Gender Race Legislative Traits.dta", clear 
graph hbar female male, over(order) xalternate
	gr_edit .legend.plotregion1.label[1].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[1].text = {}
	gr_edit .legend.plotregion1.label[1].text.Arrpush Female Legislators
	gr_edit .legend.plotregion1.label[2].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[2].text = {}
	gr_edit .legend.plotregion1.label[2].text.Arrpush Male Legislators
	gr_edit .legend.Edit , style(stacked(yes)) keepstyles 
	gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .scaleaxis.title.text = {}
	gr_edit .scaleaxis.title.text.Arrpush Percentage of Legislators from Occupation
	gr_edit .scaleaxis.title.style.editstyle margin(small) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy

**Figure 7
use "PBSL Occupations by Gender Race Legislative Traits.dta", clear 
graph hbar maj_bl maj_hisp non_mmd, over(order) xalternate
	gr_edit .legend.Edit , style(stacked(yes)) keepstyles 
	gr_edit .legend.Edit , style(cols(3)) style(rows(0)) keepstyles 
	gr_edit .legend.Edit, style(labelstyle(size(vsmall)))
	gr_edit .legend.plotregion1.label[1].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[1].text = {}
	gr_edit .legend.plotregion1.label[1].text.Arrpush Black Majority Districts
	gr_edit .legend.plotregion1.label[2].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[2].text = {}
	gr_edit .legend.plotregion1.label[2].text.Arrpush Hispanic Majority Districts
	gr_edit .legend.plotregion1.label[3].style.editstyle size(small) editcopy
	gr_edit .legend.plotregion1.label[3].text = {}
	gr_edit .legend.plotregion1.label[3].text.Arrpush All Others
	gr_edit .legend.Edit , style(stacked(yes)) keepstyles 
	gr_edit .grpaxis.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .scaleaxis.title.text = {}
	gr_edit .scaleaxis.title.text.Arrpush Percentage of Legislators from Occupation
	gr_edit .scaleaxis.title.style.editstyle margin(small) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy


**Code for miscellaneous comparisons in descriptive section
use "PBSL Replication Data.dta", clear 
tab occ_code if legret==1
tab occ_code if legret==2
sum pipeline working
tab occ_code if party==100 & app==1
tab occ_code if party==200 & app==1
tabstat pipeline if app==1, by(party)
tabstat working if app==1, by(party)
tab occ_code if squire_hilo==1
tab occ_code if squire_hilo==0
tabstat pipeline, by(squire_hilo)
tabstat working, by(squire_hilo)
tab occ_code if turnover_hilo==1
tab occ_code if turnover_hilo==0
tabstat pipeline, by(turnover_hilo)
tabstat working, by(turnover_hilo)
tabstat pipeline if app==1, by(party)
tabstat working if app==1, by(party)
tab occ_code if female==1 & app==1
tab occ_code if female==0 & app==1
tabstat pipeline if app==1, by(female)
tabstat working if app==1, by(female)
tab occ_code if black_mmd==1 & app==1
tab occ_code if hisp_mmd==1 & app==1
tab occ_code if black_mmd==0 & hisp_mmd==0 & app==1
tabstat pipeline if app==1 & hisp_mmd==0, by(black_mmd)
tabstat pipeline if app==1 & black_mmd==0, by(hisp_mmd)
tabstat working if app==1 & hisp_mmd==0, by(black_mmd)
tabstat working if app==1 & black_mmd==0, by(hisp_mmd)


**Tables 1 and 2
use "PBSL Replication Data.dta", clear 
*Model 1
melogit politico c.squire##c.turnover termlim senate normal black_mmd hisp_mmd bapct urbanpct marrpct commute govtpct if noelec==0 || styr: senate
*Marginal effects 
margins, at(squire=(0.08 0.31) turnover=(0.17 0.31)) asbalanced noatlegend
margins, at(normal=(0.351 0.669)) asbalanced noatlegend
margins, at(black_mmd=(0 1)) asbalanced noatlegend
margins, at(hisp_mmd=(0 1)) asbalanced noatlegend
margins, at(urbanpct=(0.40 1.00)) asbalanced noatlegend
margins, at(marrpct=(46.4 64.0)) asbalanced noatlegend
margins, at(commute=(18.3 29.4)) asbalanced noatlegend
*Model 2
melogit pipeline squire turnover termlim senate normal black_mmd hisp_mmd bapct urbanpct marrpct commute govtpct if noelec==0 || styr: senate
*Marginal effects
margins, at(squire=(0.08 0.31)) asbalanced noatlegend
margins, at(senate=(0 1)) asbalanced noatlegend
margins, at(black_mmd=(0 1)) asbalanced noatlegend
margins, at(bapct=(11.4 36.2)) asbalanced noatlegend
margins, at(urbanpct=(0.40 1.00)) asbalanced noatlegend
margins, at(marrpct=(46.4 64.0)) asbalanced noatlegend
margins, at(commute=(18.3 29.4)) asbalanced noatlegend
margins, at(govtpct=(9.7 20.6)) asbalanced noatlegend
*Model 3
melogit working squire turnover termlim senate normal black_mmd hisp_mmd bapct urbanpct marrpct commute govtpct if noelec==0 || styr:
*Marginal effects
margins, at(squire=(0.08 0.31)) asbalanced noatlegend
margins, at(senate=(0 1)) asbalanced noatlegend
margins, at(normal=(0.351 0.669)) asbalanced noatlegend
margins, at(black_mmd=(0 1)) asbalanced noatlegend
margins, at(hisp_mmd=(0 1)) asbalanced noatlegend
margins, at(bapct=(11.4 36.2)) asbalanced noatlegend
margins, at(marrpct=(46.4 64.0)) asbalanced noatlegend

**Table 3 and Figure 8
use "PBSL Replication Data.dta", clear 
ssc install matsort
*Democrats
reg smideol normal ln_medinc blackpct hisppct urbandist south i.occ_code if party==100 & noelec==0 , cl(distdecade)
margins, at(occ_code=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44)) asbalanced noatlegend
matrix plot = r(table)'
matsort plot 1 "down"
matrix plot = plot'
coefplot (matrix(plot[1,])), xline(-.737) ci((plot[5,] plot[6,])) drop (normal ln_medinc blackpct hisppct urbandist south 5._at 7._at 10._at 11._at 12._at 13._at 14._at 17._at 18._at 20._at 23._at 25._at 27._at 29._at 30._at 31._at 30._at 31._at 33._at 35._at 37._at 38._at  39._at 42._at 44._at _cons)
	gr_edit .yaxis1.style.editstyle majorstyle(use_labels(yes)) editcopy
	gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .yaxis1.major.num_rule_ticks = 0
	gr_edit .yaxis1.edit_tick 1 1 `"Transportation professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 2 2 `"Insurance"', tickset(major)
	gr_edit .yaxis1.edit_tick 3 3 `"Contractors and construction"', tickset(major)
	gr_edit .yaxis1.edit_tick 4 4 `"Real estate"', tickset(major)
	gr_edit .yaxis1.edit_tick 5 5 `"Engineer"', tickset(major)
	gr_edit .yaxis1.edit_tick 6 6 `"Farmer"', tickset(major)
	gr_edit .yaxis1.edit_tick 7 7 `"Sales"', tickset(major)
	gr_edit .yaxis1.edit_tick 8 8 `"Business executive"', tickset(major)
	gr_edit .yaxis1.edit_tick 9 9 `"Business owner"', tickset(major)
	gr_edit .yaxis1.edit_tick 10 10 `"Government"', tickset(major)
	gr_edit .yaxis1.edit_tick 11 11 `"Attorney"', tickset(major)
	gr_edit .yaxis1.edit_tick 12 12 `"Medical professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 13 13 `"Consultant"', tickset(major)
	gr_edit .yaxis1.edit_tick 14 14 `"Nonprofit"', tickset(major)
	gr_edit .yaxis1.edit_tick 15 15 `"Politics and advocacy"', tickset(major)	
	gr_edit .yaxis1.edit_tick 16 16 `"Teacher"', tickset(major)
	gr_edit .yaxis1.edit_tick 17 17 `"Social worker"', tickset(major)	
	gr_edit .yaxis1.edit_tick 18 18 `"Journalism and media"', tickset(major)
	gr_edit .yaxis1.edit_tick 19 19 `"Artist"', tickset(major)	
	gr_edit .yaxis1.edit_tick 20 20 `"Humanities professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 21 21 `"Sports and entertainment"', tickset(major)
	gr_edit .xaxis1.title.style.editstyle margin(small) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Predicted Shor-McCarty Score
	gr_edit .xaxis1.plotregion._xylines_new = 1
	gr_edit .xaxis1.plotregion._xylines_rec = 1
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Democrats
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.style.editstyle margin(small) editcopy
	gr_edit .title.style.editstyle boxmargin(small) editcopy
	gr_edit .title.style.editstyle fillcolor(white) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy

*Republicans
reg smideol normal ln_medinc blackpct hisppct urbandist south i.occ_code if party==200 & noelec==0, cl(distdecade)
margins, at(occ_code=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44)) asbalanced noatlegend
matrix plot = r(table)'
matsort plot 1 "down"
matrix plot = plot'
coefplot (matrix(plot[1,])), xline(.709) ci((plot[5,] plot[6,])) drop (normal ln_m blackpct hisppct urbandist south 1._at 2._at 4._at 7._at 9._at 10._at 12._at 14._at 17._at 20._at 21._at 22._at 24._at 25._at 27._at 28._at 29._at 30._at 31._at 33._at 34._at 36._at  37._at 38._at 39._at 41._at 43._at 44._at _cons)
	gr_edit .yaxis1.style.editstyle majorstyle(use_labels(yes)) editcopy
	gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .yaxis1.major.num_rule_ticks = 0
	gr_edit .yaxis1.edit_tick 1 1 `"Technician"', tickset(major)
	gr_edit .yaxis1.edit_tick 2 2 `"Design professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 3 3 `"IT professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 4 4 `"Engineer"', tickset(major)
	gr_edit .yaxis1.edit_tick 5 5 `"Contractors and construction"', tickset(major)
	gr_edit .yaxis1.edit_tick 6 6 `"Business manager"', tickset(major)
	gr_edit .yaxis1.edit_tick 7 7 `"Finance and banking"', tickset(major)
	gr_edit .yaxis1.edit_tick 8 8 `"Business owner"', tickset(major)
	gr_edit .yaxis1.edit_tick 9 9 `"Teacher"', tickset(major)
	gr_edit .yaxis1.edit_tick 10 10 `" Politics and advocacy "', tickset(major)
	gr_edit .yaxis1.edit_tick 11 11 `"Medical professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 12 12 `"Government"', tickset(major)
	gr_edit .yaxis1.edit_tick 13 13 `"Retail and service professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 14 14 `"Attorney"', tickset(major)
	gr_edit .yaxis1.edit_tick 15 15 `"Education administrator"', tickset(major)
	gr_edit .yaxis1.edit_tick 16 16 `"Social worker"', tickset(major)
	gr_edit .xaxis1.title.style.editstyle margin(small) editcopy
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Predicted Shor-McCarty Score
	gr_edit .xaxis1.plotregion._xylines_new = 1
	gr_edit .xaxis1.plotregion._xylines_rec = 1
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Republicans
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.style.editstyle margin(small) editcopy
	gr_edit .title.style.editstyle boxmargin(small) editcopy
	gr_edit .title.style.editstyle fillcolor(white) editcopy
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy

*Table 4 and Figure 9
use "PBSL Replication Data.dta", clear 
logit leader c.normal##c.normal c.smideol##c.smideol senate c.srty##c.turnover female i.occ_code if leader_inc==1,cl(nameid_ch)
margins, at(occ_code=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44)) asbalanced noatlegend
matrix plot = r(table)'
matsort plot 1 "down"
matrix plot = plot'
coefplot (matrix(plot[1,])), xline(0.09) ci((plot[5,] plot[6,])) drop (normal ln_medinc blackpct hisppct urbandist south 1._at 5._at 6._at 7._at 8._at 9._at 10._at 11._at 12._at 13._at 14._at 15._at 17._at 18._at 19._at 20._at 22._at 24._at 25._at 26._at 27._at 28._at 29._at 31._at 32._at 33._at 34._at 35._at 36._at 37._at 38._at 39._at 40._at 41._at 42._at 43._at _cons)
	gr_edit .yaxis1.style.editstyle majorstyle(use_labels(yes)) editcopy
	gr_edit .yaxis1.style.editstyle majorstyle(tickstyle(textstyle(size(small)))) editcopy
	gr_edit .yaxis1.major.num_rule_ticks = 0
	gr_edit .yaxis1.edit_tick 1 1 `"Business executive"', tickset(major)
	gr_edit .yaxis1.edit_tick 2 2 `"Attorney"', tickset(major)
	gr_edit .yaxis1.edit_tick 3 3 `"Engineer"', tickset(major)
	gr_edit .yaxis1.edit_tick 4 4 `"IT professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 5 5 `"Operations manager"', tickset(major)
	gr_edit .yaxis1.edit_tick 6 6 `"Artist"', tickset(major)
	gr_edit .yaxis1.edit_tick 7 7 `"Humanities professions"', tickset(major)
	gr_edit .yaxis1.edit_tick 8 8 `"Unskilled laborers"', tickset(major)
	gr_edit .xaxis1.reset_rule 0 0.15 .05 , tickset(major) ruletype(range) 
	gr_edit .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Probability of Holding Leadership Position
	gr_edit .xaxis1.title.style.editstyle margin(small) editcopy
	gr_edit .xaxis1.plotregion._xylines_new = 1
	gr_edit .xaxis1.plotregion._xylines_rec = 1
	gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
	gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
logit leader c.normal##c.normal c.smideol##c.smideol senate c.srty##c.turnover female pipeline working if leader_inc==1,cl(nameid_ch)


**Footnotes
use "PBSL Replication Data.dta", clear 

*Footnote 5 
tab occ_code if senate==1 
tab occ_code if senate==0

*Footnote 8
tab occ_code if termlim==1
tab occ_code if termlim==0

*Footnote 14
melogit politico c.squire##c.turnover termlim senate normal black_mmd hisp_mmd if noelec==0 || styr: senate
melogit pipeline squire turnover termlim senate normal black_mmd hisp_mmd if noelec==0 || styr: senate
melogit working squire turnover termlim senate normal black_mmd hisp_mmd if noelec==0 || styr:

*Footnote 17
reg smideol normal ln_medinc blackpct hisppct south i.occ_code if party==100,cl(distdecade)
margins, at(occ_code=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44)) asbalanced noatlegend
reg smideol normal ln_medinc blackpct hisppct south i.occ_code if party==200, cl(distdecade)
margins, at(occ_code=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44)) asbalanced noatlegend

