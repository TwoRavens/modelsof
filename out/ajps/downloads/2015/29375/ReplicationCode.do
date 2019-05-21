***Figure 1***
clear
set more off
use "Senate.dta"
keep year congress senator earmarks appropriations
drop if year < 2008
egen minyear = min(year), by(senator)
egen maxyear = max(year), by(senator)
drop if minyear != 2008
drop if maxyear != 2010
egen category = mean(appropriations), by(senator)
replace category = 2 if category != 0 & category != 1
g category_year = category*1000 + congress
egen meanearmarks = mean(earmarks), by(category_year)
sort category_year
drop if category_year == category_year[_n-1]
keep category congress meanearmarks
rename meanearmarks earmarks
reshape wide earmarks, i(congress) j(category)
graph twoway (line earmarks* congress) (scatter earmarks* congress)
gr_edit .style.editstyle margin(vsmall) editcopy
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit .style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush Earmarks (dollars per capita)
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Congress
gr_edit .yaxis1.style.editstyle majorstyle(gridstyle(linestyle(color(white)))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .xaxis1.reset_rule 110 111 1, tickset(major) ruletype(range) 
gr_edit .yaxis1.reset_rule 0 100 20, tickset(major) ruletype(range)
gr_edit .xaxis1.plotregion.xscale.curmin = 109.8
gr_edit .xaxis1.plotregion.xscale.curmax = 111.2
gr_edit .plotregion1.plot5.style.editstyle marker(symbol(diamond)) editcopy
gr_edit .plotregion1.plot5.style.editstyle marker(fillcolor(green)) editcopy
gr_edit .plotregion1.plot5.style.editstyle marker(linestyle(color(green))) editcopy
gr_edit .plotregion1.plot5.style.editstyle marker(size(medlarge)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot2.style.editstyle line(color(green)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor 85 110.7
gr_edit .plotregion1.added_text_new = 1
gr_edit .plotregion1.added_text_rec = 1
gr_edit .plotregion1.added_text[1].style.editstyle  angle(default) size(small) color(green) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[1].text = {}
gr_edit .plotregion1.added_text[1].text.Arrpush Appropriations Committee Members
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot6.style.editstyle marker(symbol(diamond)) editcopy
gr_edit .plotregion1.plot6.style.editstyle marker(fillcolor(blue)) editcopy
gr_edit .plotregion1.plot6.style.editstyle marker(linestyle(color(blue))) editcopy
gr_edit .plotregion1.plot6.style.editstyle marker(size(medlarge)) editcopy
gr_edit .plotregion1.AddTextBox added_text editor 75 110.15
gr_edit .plotregion1.added_text_new = 2
gr_edit .plotregion1.added_text_rec = 2
gr_edit .plotregion1.added_text[2].style.editstyle  angle(default) size(small) color(blue) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[2].text = {}
gr_edit .plotregion1.added_text[2].text.Arrpush Joined Appropriations between 110th and 111th
gr_edit .plotregion1.plot1.style.editstyle line(color(red)) editcopy
gr_edit .plotregion1.plot1.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle marker(size(medlarge)) editcopy
gr_edit .plotregion1.plot4.style.editstyle marker(symbol(diamond)) editcopy
gr_edit .plotregion1.plot4.style.editstyle marker(fillcolor(red)) editcopy
gr_edit .plotregion1.plot4.style.editstyle marker(linestyle(color(red))) editcopy
gr_edit .plotregion1.AddTextBox added_text editor 34 110.4
gr_edit .plotregion1.added_text_new = 3
gr_edit .plotregion1.added_text_rec = 3
gr_edit .plotregion1.added_text[3].style.editstyle  angle(default) size(small) color(red) horizontal(left) vertical(middle) margin(zero) linegap(zero) drawbox(no) boxmargin(zero) fillcolor(bluishgray) linestyle( width(thin) color(black) pattern(solid)) box_alignment(east) editcopy
gr_edit .plotregion1.added_text[3].text = {}
gr_edit .plotregion1.added_text[3].text.Arrpush Non-Members
graph save "Figure1.gph", replace


***Table 1***
clear
set more off
use "Senate.dta"
*mean and standard deviation of dollars per capita
sum faads
postfile Table1 coef ster pval upper lower using "Table1.dta", replace
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
xi:areg log_faads `i' i.year majority seniority, a(id) cluster(state)
post Table1 (_b[`i']) (_se[`i']) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (_b[`i'] + _se[`i']*invttail(e(df_r),.025)) (_b[`i'] - _se[`i']*invttail(e(df_r),.025))		
}
postclose Table1
clear
use "Table1.dta"
foreach i of varlist coef ster upper lower {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
g result = coef + " (" + ster + ") [" + lower + "," + upper + "]"
replace result = result + "*" if pval <= .05
replace result = result + "*" if pval <= .01
replace result = subinstr(result, ".000 (.000)**", "", .)
g committee = ""
replace committee = "Aging" if _n == 1
replace committee = "Agriculture" if _n == 2
replace committee = "Appropriations" if _n == 3
replace committee = "Armed Services" if _n == 4
replace committee = "Banking" if _n == 5
replace committee = "Budget" if _n == 6
replace committee = "Commerce" if _n == 7
replace committee = "Economic" if _n == 8
replace committee = "Energy" if _n == 9
replace committee = "Environment" if _n == 10
replace committee = "Ethics" if _n == 11
replace committee = "Finance" if _n == 12
replace committee = "Foreign Affairs" if _n == 13
replace committee = "Governmental Affairs" if _n == 14
replace committee = "Health" if _n == 15
replace committee = "Indian Affairs" if _n == 16
replace committee = "Intelligence" if _n == 17
replace committee = "Judiciary" if _n == 18
replace committee = "Labor" if _n == 19
replace committee = "Library" if _n == 20
replace committee = "Printing" if _n == 21
replace committee = "Rules" if _n == 22
replace committee = "Small Business" if _n == 23
replace committee = "Veterans' Affairs" if _n == 24
keep committee result
order committee result
sort committee
save "Table1.dta", replace
browse


***Table2***
clear
set more off
use "House.dta"
*mean and standard deviation of dollars per capita
sum faads
postfile Table2 coef ster pval upper lower using "Table2.dta", replace
foreach i of varlist agricul-waysmeans {
xi:areg log_faads `i' i.year majority seniority, a(id) cluster(state)
post Table2 (_b[`i']) (_se[`i']) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (_b[`i'] + _se[`i']*invttail(e(df_r),.025)) (_b[`i'] - _se[`i']*invttail(e(df_r),.025))		
}
postclose Table2
clear
use "Table2.dta"
foreach i of varlist coef ster upper lower {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
g result = coef + " (" + ster + ") [" + lower + "," + upper + "]"
replace result = result + "*" if pval <= .05
replace result = result + "*" if pval <= .01
replace result = subinstr(result, ".000 (.000)**", "", .)
g committee = ""
replace committee = "Agriculture" if _n == 1
replace committee = "Appropriations" if _n == 2
replace committee = "Armed Services" if _n == 3
replace committee = "Banking" if _n == 4
replace committee = "Budget" if _n == 5
replace committee = "DC" if _n == 6
replace committee = "Education" if _n == 7
replace committee = "Energy" if _n == 8
replace committee = "Foreign Affairs" if _n == 9
replace committee = "Government Operations" if _n == 10
replace committee = "Homeland Security" if _n == 11
replace committee = "House Administration" if _n == 12
replace committee = "Judiciary" if _n == 13
replace committee = "Merchant Marine" if _n == 14
replace committee = "Natural Resources" if _n == 15
replace committee = "Post Office" if _n == 16
replace committee = "Public Works" if _n == 17
replace committee = "Rules" if _n == 18
replace committee = "Science" if _n == 19
replace committee = "Small Business" if _n == 20
replace committee = "Ethics" if _n == 21
replace committee = "Veterans' Affairs" if _n == 22
replace committee = "Ways and Means" if _n == 23
keep committee result
order committee result
sort committee
save "Table2.dta", replace
browse


***Table 3***
clear
set more off
use "Senate.dta"
postfile Table3 mean_dollars sd_dollars auth_coef auth_se auth_pval approp_coef approp_se approp_pval using "Table3.dta", replace
foreach i in ag com def energy home hud interior labor milcon trans {
sum faads_`i'
scalar mean_dollars = r(mean)
scalar sd_dollars = r(sd)
xi:areg log_faads_`i' auth_`i' i.year majority seniority, a(senator) cluster(state)
scalar auth_coef = _b[auth_`i']
scalar auth_se = _se[auth_`i']
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_`i']/_se[auth_`i']))
xi:areg log_faads_`i' mem_`i' i.year majority seniority, a(senator) cluster(state)
post Table3 (mean_dollars) (sd_dollars) (auth_coef) (auth_se) (auth_pval) (_b[mem_`i']) (_se[mem_`i']) (2*ttail(e(df_r),abs(_b[mem_`i']/_se[mem_`i']))) 
}
*Pooled
tostring year, gen(year_string)
g senator_year = senator + "_" + year_string
keep log_faads_* faads_* auth_* mem_* year majority seniority senator senator_year state year_string
reshape long mem_ faads_ log_faads_ auth_, i(senator_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "treas"
g senator_sc = senator + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
xi:areg log_faads_ auth_ i.year_sc seniority majority, a(senator_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
xi:areg log_faads_ mem_ i.year_sc seniority majority, a(senator_sc) cluster(state)
post Table3 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
*Naive
areg log_faads_ auth_ seniority majority, a(year_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
areg log_faads_ mem_ seniority majority, a(year_sc) cluster(state)
post Table3 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
postclose Table3
clear
use "Table3.dta"
browse
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Transportation" if _n == 10
replace issue = "Pooled" if _n == 11
replace issue = "Naive" if _n == 12
foreach i of varlist mean_dollars sd_dollars {
tostring `i', replace format(%5.1f) force
replace `i' = trim(`i')
replace `i' = "" if `i' == "."
}
foreach i of varlist auth_coef auth_se approp_coef approp_se {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
foreach i in auth approp {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
g dollars = mean_dollars + " (" + sd_dollars + ")"
replace dollars = "" if dollars == " ()"
keep issue dollars auth approp
order issue dollars auth approp
save "Table3.dta", replace
browse


***Table 4****
clear
set more off
use "House.dta"
postfile Table4 mean_dollars sd_dollars auth_coef auth_se auth_pval approp_coef approp_se approp_pval using "Table4.dta", replace
foreach i in ag com def energy hs hud interior labor milcon trans va {
sum faads_`i'
scalar mean_dollars = r(mean)
scalar sd_dollars = r(sd)
xi:areg log_faads_`i' auth_`i' i.year majority seniority , a(id) cluster(state)
scalar auth_coef = _b[auth_`i']
scalar auth_se = _se[auth_`i']
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_`i']/_se[auth_`i']))
xi:areg log_faads_`i' mem_`i' i.year majority seniority , a(id) cluster(state)
post Table4 (mean_dollars) (sd_dollars) (auth_coef) (auth_se) (auth_pval) (_b[mem_`i']) (_se[mem_`i']) (2*ttail(e(df_r),abs(_b[mem_`i']/_se[mem_`i']))) 
}
*Pooled
tostring year, gen(year_string)
g id_year = id + "_" + year_string
keep log_faads_* mem_* auth_* year majority seniority id id_year state year_string
reshape long mem_ auth_ log_faads_ , i(id_year) j(subcommittee) string
g id_sc = id + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
drop if subcommittee == "dc" | subcommittee == "for" | subcommittee == "fin" | subcommittee == "leg" | subcommittee == "treas" | subcommittee == "state"
drop if mem_ == . & auth_ == .
xi:areg log_faads_ auth_ i.year_sc seniority majority, a(id_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
xi:areg log_faads_ mem_ i.year_sc seniority majority, a(id_sc) cluster(state)
post Table4 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
*Naive
areg log_faads_ auth_ seniority majority, a(year_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
areg log_faads_ mem_ seniority majority, a(year_sc) cluster(state)
post Table4 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
postclose Table4
clear
use "Table4.dta"
browse
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Veterans' Affairs" if _n == 10
replace issue = "Transportation" if _n == 11
replace issue = "Pooled" if _n == 12
replace issue = "Naive" if _n == 13
foreach i of varlist mean_dollars sd_dollars {
tostring `i', replace format(%5.1f) force
replace `i' = trim(`i')
replace `i' = "" if `i' == "."
}
foreach i of varlist auth_coef auth_se approp_coef approp_se {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
foreach i in auth approp {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
g dollars = mean_dollars + " (" + sd_dollars + ")"
replace dollars = "" if dollars == " ()"
keep issue dollars auth approp
order issue dollars auth approp
save "Table4.dta", replace
browse


***Table 5***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "Senate.dta"
postfile Table5 coef_1 se_1 pval_1 coef_2 se_2 pval_2 coef_3 se_3 pval_3 coef_4 se_4 pval_4 coef_5 se_5 pval_5 coef_6 se_6 pval_6 using "Table5.dta", replace
foreach i in ag com def energy home hud interior labor milcon trans {
	forvalues j = 1/6 {
	g approp_`i'_`j' = approp_`i' == `j'
	replace approp_`i'_`j' = . if approp_`i' == .
	}
xi:areg log_faads_`i' approp_`i'_* i.year majority seniority, a(senator) cluster(state)
post Table5 ///
(_b[approp_`i'_1]) (_se[approp_`i'_1]) (2*ttail(e(df_r),abs(_b[approp_`i'_1]/_se[approp_`i'_1]))) ///
(_b[approp_`i'_2]) (_se[approp_`i'_2]) (2*ttail(e(df_r),abs(_b[approp_`i'_2]/_se[approp_`i'_2]))) ///
(_b[approp_`i'_3]) (_se[approp_`i'_3]) (2*ttail(e(df_r),abs(_b[approp_`i'_3]/_se[approp_`i'_3]))) ///
(_b[approp_`i'_4]) (_se[approp_`i'_4]) (2*ttail(e(df_r),abs(_b[approp_`i'_4]/_se[approp_`i'_4]))) ///
(_b[approp_`i'_5]) (_se[approp_`i'_5]) (2*ttail(e(df_r),abs(_b[approp_`i'_5]/_se[approp_`i'_5]))) ///
(_b[approp_`i'_6]) (_se[approp_`i'_6]) (2*ttail(e(df_r),abs(_b[approp_`i'_6]/_se[approp_`i'_6]))) 
drop approp_`i'_*
}
*Pooled
tostring year, gen(year_string)
g senator_year = senator + "_" + year_string
keep log_faads_* approp_* year majority seniority senator senator_year state year_string
reshape long approp_ log_faads_ , i(senator_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "treas"
g senator_sc = senator + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
rename approp_ approp
forvalues j = 1/6 {
g approp_`j' = approp == `j'
replace approp_`j' = . if approp == .
}
xi:areg log_faads_ approp_* i.year_sc seniority majority, a(senator_sc) cluster(state)
post Table5 ///
(_b[approp_1]) (_se[approp_1]) (2*ttail(e(df_r),abs(_b[approp_1]/_se[approp_1]))) ///
(_b[approp_2]) (_se[approp_2]) (2*ttail(e(df_r),abs(_b[approp_2]/_se[approp_2]))) ///
(_b[approp_3]) (_se[approp_3]) (2*ttail(e(df_r),abs(_b[approp_3]/_se[approp_3]))) ///
(_b[approp_4]) (_se[approp_4]) (2*ttail(e(df_r),abs(_b[approp_4]/_se[approp_4]))) ///
(_b[approp_5]) (_se[approp_5]) (2*ttail(e(df_r),abs(_b[approp_5]/_se[approp_5]))) ///
(_b[approp_6]) (_se[approp_6]) (2*ttail(e(df_r),abs(_b[approp_6]/_se[approp_6]))) 
postclose Table5
clear
use "Table5.dta"
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Transportation" if _n == 10
replace issue = "Pooled" if _n == 11
forvalues j = 1/6 {
	foreach i of varlist coef_`j' se_`j' {
	tostring `i', replace format(%5.3f) force
	replace `i' = subinstr(`i', "0.", ".", .)
	replace `i' = subinstr(`i', "-.000", ".000", .)
	replace `i' = trim(`i')
	}
g result_`j' = coef_`j' + " (" + se_`j' + ")"
replace result_`j' = result_`j' + "*" if pval_`j' <= .05
replace result_`j' = result_`j' + "*" if pval_`j' <= .01
}
keep issue result_*
save "Table5.dta", replace
browse


***Table 6***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "House.dta"
postfile Table6 coef_1 se_1 pval_1 coef_2 se_2 pval_2 coef_3 se_3 pval_3 coef_4 se_4 pval_4 coef_5 se_5 pval_5 coef_6 se_6 pval_6 using "Table6.dta", replace
foreach i in ag com def energy hs hud interior labor milcon trans va {
	forvalues j = 1/6 {
	g approp_`i'_`j' = approp_`i' == `j'
	replace approp_`i'_`j' = . if approp_`i' == .
	}
xi:areg log_faads_`i' approp_`i'_* i.year majority seniority , a(id) cluster(state)
post Table6 ///
(_b[approp_`i'_1]) (_se[approp_`i'_1]) (2*ttail(e(df_r),abs(_b[approp_`i'_1]/_se[approp_`i'_1]))) ///
(_b[approp_`i'_2]) (_se[approp_`i'_2]) (2*ttail(e(df_r),abs(_b[approp_`i'_2]/_se[approp_`i'_2]))) ///
(_b[approp_`i'_3]) (_se[approp_`i'_3]) (2*ttail(e(df_r),abs(_b[approp_`i'_3]/_se[approp_`i'_3]))) ///
(_b[approp_`i'_4]) (_se[approp_`i'_4]) (2*ttail(e(df_r),abs(_b[approp_`i'_4]/_se[approp_`i'_4]))) ///
(_b[approp_`i'_5]) (_se[approp_`i'_5]) (2*ttail(e(df_r),abs(_b[approp_`i'_5]/_se[approp_`i'_5]))) ///
(_b[approp_`i'_6]) (_se[approp_`i'_6]) (2*ttail(e(df_r),abs(_b[approp_`i'_6]/_se[approp_`i'_6]))) 
drop approp_`i'_*
}
*Pooled
tostring year, gen(year_string)
g id_year = id + "_" + year_string
keep log_faads_* faads_* approp_* log_non_* non_* year majority seniority id id_year state year_string
reshape long approp_ faads_ log_faads_ log_non_ non_, i(id_year) j(subcommittee) string
g id_sc = id + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
drop if subcommittee == "dc" | subcommittee == "for" | subcommittee == "fin" | subcommittee == "leg" | subcommittee == "treas" | subcommittee == "state"
drop if approp_ == .
rename approp_ approp
forvalues j = 1/6 {
g approp_`j' = approp == `j'
replace approp_`j' = . if approp == .
}
xi:areg log_faads_ approp_* i.year_sc seniority majority, a(id_sc) cluster(state)
post Table6 ///
(_b[approp_1]) (_se[approp_1]) (2*ttail(e(df_r),abs(_b[approp_1]/_se[approp_1]))) ///
(_b[approp_2]) (_se[approp_2]) (2*ttail(e(df_r),abs(_b[approp_2]/_se[approp_2]))) ///
(_b[approp_3]) (_se[approp_3]) (2*ttail(e(df_r),abs(_b[approp_3]/_se[approp_3]))) ///
(_b[approp_4]) (_se[approp_4]) (2*ttail(e(df_r),abs(_b[approp_4]/_se[approp_4]))) ///
(_b[approp_5]) (_se[approp_5]) (2*ttail(e(df_r),abs(_b[approp_5]/_se[approp_5]))) ///
(_b[approp_6]) (_se[approp_6]) (2*ttail(e(df_r),abs(_b[approp_6]/_se[approp_6]))) 
postclose Table6
clear
use "Table6.dta"
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Transportation" if _n == 10
replace issue = "Veterans' Affairs" if _n == 11
replace issue = "Pooled" if _n == 12
forvalues j = 1/6 {
	foreach i of varlist coef_`j' se_`j' {
	tostring `i', replace format(%5.3f) force
	replace `i' = subinstr(`i', "0.", ".", .)
	replace `i' = subinstr(`i', "-.000", ".000", .)
	replace `i' = trim(`i')
	}
g result_`j' = coef_`j' + " (" + se_`j' + ")"
replace result_`j' = result_`j' + "*" if pval_`j' <= .05
replace result_`j' = result_`j' + "*" if pval_`j' <= .01
}
keep issue result_*
save "Table6.dta", replace
browse


**Table A1**
clear
set more off
use "Senate.dta"
rename id legislator
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
egen `i'_ever = max(`i'), by(legislator)
egen `i'_always = min(`i'), by(legislator)
}
egen mincong = min(congress), by(legislator)
drop if mincong == 98
sort legislator
drop if legislator == legislator[_n-1]
postfile TableA1_senate senate using "TableA1_senate.dta", replace
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
sum `i'_always if `i'_ever == 1
post TableA1_senate (1 - r(mean))
}
postclose TableA1_senate
clear
use "TableA1_senate.dta"
tostring senate, replace format(%5.3f) force
replace senate = subinstr(senate, "0.", ".", .)
replace senate = subinstr(senate, "1.000", "1", .)
g committee = ""
replace committee = "Aging" if _n == 1
replace committee = "Agriculture" if _n == 2
replace committee = "Appropriations" if _n == 3
replace committee = "Armed Services" if _n == 4
replace committee = "Banking" if _n == 5
replace committee = "Budget" if _n == 6
replace committee = "Commerce" if _n == 7
replace committee = "Economic" if _n == 8
replace committee = "Energy" if _n == 9
replace committee = "Environment" if _n == 10
replace committee = "Ethics" if _n == 11
replace committee = "Finance" if _n == 12
replace committee = "Foreign Affairs" if _n == 13
replace committee = "Governmental Affairs" if _n == 14
replace committee = "Health" if _n == 15
replace committee = "Indian Affairs" if _n == 16
replace committee = "Intelligence" if _n == 17
replace committee = "Judiciary" if _n == 18
replace committee = "Labor" if _n == 19
replace committee = "Library" if _n == 20
replace committee = "Printing" if _n == 21
replace committee = "Rules" if _n == 22
replace committee = "Small Business" if _n == 23
replace committee = "Veterans' Affairs" if _n == 24
order committee senate
sort committee
save "TableA1_senate.dta", replace
browse
clear
set more off
use "House.dta"
split id, p(_)
egen legislator = group(id1 id2 id3)
drop id1-id4
foreach i in agricul approps armserv_natlsec banking_finserv budget dc educlab ///
engycom fornaff_intlrel govtops homesec hradmin judicry merchmar natrlres ///
postoff_civserv pubwork_transpo_infrast rules scitech smallbus ethics vetaffrs waysmeans {
egen `i'_ever = max(`i'), by(legislator)
egen `i'_always = min(`i'), by(legislator)
}
egen mincong = min(congress), by(legislator)
drop if mincong == 98
sort legislator
drop if legislator == legislator[_n-1]
postfile TableA1_house house using "TableA1_house.dta", replace
foreach i in agricul approps armserv_natlsec banking_finserv budget dc educlab ///
engycom fornaff_intlrel govtops homesec hradmin judicry merchmar natrlres ///
postoff_civserv pubwork_transpo_infrast rules scitech smallbus ethics vetaffrs waysmeans {
sum `i'_always if `i'_ever == 1
post TableA1_house (1 - r(mean))
}
postclose TableA1_house
clear
use "TableA1_house.dta"
tostring house, replace format(%5.3f) force
replace house = subinstr(house, "0.", ".", .)
g committee = ""
replace committee = "Agriculture" if _n == 1
replace committee = "Appropriations" if _n == 2
replace committee = "Armed Services" if _n == 3
replace committee = "Banking" if _n == 4
replace committee = "Budget" if _n == 5
replace committee = "DC" if _n == 6
replace committee = "Education" if _n == 7
replace committee = "Energy" if _n == 8
replace committee = "Foreign Affairs" if _n == 9
replace committee = "Government Operations" if _n == 10
replace committee = "Homeland Security" if _n == 11
replace committee = "House Administration" if _n == 12
replace committee = "Judiciary" if _n == 13
replace committee = "Merchant Marine" if _n == 14
replace committee = "Natural Resources" if _n == 15
replace committee = "Post Office" if _n == 16
replace committee = "Public Works" if _n == 17
replace committee = "Rules" if _n == 18
replace committee = "Science" if _n == 19
replace committee = "Small Business" if _n == 20
replace committee = "Ethics" if _n == 21
replace committee = "Veterans' Affairs" if _n == 22
replace committee = "Ways and Means" if _n == 23
order committee house
sort committee
save "TableA1_house.dta", replace
browse

**Table A2**
clear
set more off
use "Senate.dta"
egen mincong = min(congress), by(id)
foreach i in ag com def energy home hud interior labor milcon trans {
g `i'_on = approp_`i' >= 3 & approp_`i' <= 6
egen `i'_ever = max(`i'_on), by(id)
egen `i'_always = min(`i'_on), by(id)
}
drop if mincong == 98
sort id
drop if id == id[_n-1]
postfile TableA2_senate senate using "TableA2_senate.dta", replace
foreach i in ag com def energy home hud interior labor milcon trans {
sum `i'_always if `i'_ever == 1
post TableA2_senate (1 - r(mean))
}
postclose TableA2_senate
clear
use "TableA2_senate.dta"
tostring senate, replace format(%5.3f) force
replace senate = subinstr(senate, "0.", ".", .)
replace senate = subinstr(senate, "1.000", "1", .)
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Transportation" if _n == 10
order issue senate
sort issue
save "TableA2_senate.dta", replace
browse
clear
set more off
use "House.dta"
split id, p(_)
egen legislator = group(id1 id2 id3)
drop id1-id4
egen mincong = min(congress), by(legislator)
foreach i in ag com def energy hs interior labor milcon trans va {
g `i'_on = approp_`i' >= 3 & approp_`i' <= 6
egen `i'_ever = max(`i'_on), by(legislator)
egen `i'_always = min(`i'_on), by(legislator)
}
drop if mincong == 98
sort legislator
drop if legislator == legislator[_n-1]
postfile TableA2_house house using "TableA2_house.dta", replace
foreach i in ag com def energy hs interior labor milcon trans va {
sum `i'_always if `i'_ever == 1
post TableA2_house (1 - r(mean))
}
postclose TableA2_house
clear
use "TableA2_house.dta"
tostring house, replace format(%5.3f) force
replace house = subinstr(house, "0.", ".", .)
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Interior" if _n == 6
replace issue = "Labor" if _n == 7
replace issue = "Military Construction" if _n == 8
replace issue = "Transportation" if _n == 9
replace issue = "Veterans' Affairs" if _n == 10
order issue house
sort issue
save "TableA2_house.dta", replace
browse


***Table A3***
clear
set more off
use "Senate.dta"
egen state_year = group(state year)
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
egen tot_`i' = total(`i'), by(state_year)
replace tot_`i' = 1 if tot_`i' == 3
replace tot_`i' = . if `i' == .
}
postfile TableA3 first_coef first_se first_pval f_stat second_coef second_se second_pval using "TableA3.dta", replace
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
xi:reg tot_`i' `i' i.year i.id majority seniority, cluster(state)
scalar first_coef = _b[`i']
scalar first_se = _se[`i']
scalar first_pval = 2*ttail(e(df_r),abs(_b[`i']/_se[`i']))
test `i'
scalar fstat = r(F)
xi:ivregress 2sls log_faads (tot_`i' = `i') i.year i.id majority seniority, cluster(state)
post TableA3 (first_coef) (first_se) (first_pval) (fstat) (_b[tot_`i']) (_se[tot_`i']) (2*ttail(e(N),abs(_b[tot_`i']/_se[tot_`i'])))
}
postclose TableA3
clear
use "TableA3.dta"
*In how many cases is the first stage coefficient statistically distinguishable from 1?
count if abs(first_coef - 1)/first_se >= 1.96
foreach i of varlist first_coef first_se second_coef second_se {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
foreach i in first second {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
replace `i' = subinstr(`i', ".000 (.000)**", "", .)
}
tostring f_stat, replace format(%7.1f) force
replace f_stat = trim(f_stat)
g committee = ""
replace committee = "Aging" if _n == 1
replace committee = "Agriculture" if _n == 2
replace committee = "Appropriations" if _n == 3
replace committee = "Armed Services" if _n == 4
replace committee = "Banking" if _n == 5
replace committee = "Budget" if _n == 6
replace committee = "Commerce" if _n == 7
replace committee = "Economic" if _n == 8
replace committee = "Energy" if _n == 9
replace committee = "Environment" if _n == 10
replace committee = "Ethics" if _n == 11
replace committee = "Finance" if _n == 12
replace committee = "Foreign Affairs" if _n == 13
replace committee = "Governmental Affairs" if _n == 14
replace committee = "Health" if _n == 15
replace committee = "Indian Affairs" if _n == 16
replace committee = "Intelligence" if _n == 17
replace committee = "Judiciary" if _n == 18
replace committee = "Labor" if _n == 19
replace committee = "Library" if _n == 20
replace committee = "Printing" if _n == 21
replace committee = "Rules" if _n == 22
replace committee = "Small Business" if _n == 23
replace committee = "Veterans' Affairs" if _n == 24
keep committee first f_stat second
order committee first f_stat second
save "TableA3.dta", replace
browse


***Table A4***
clear
set more off
use "Senate.dta"
egen state_year = group(state year)
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
egen tot_`i' = total(`i'), by(state_year)
replace tot_`i' = 1 if tot_`i' == 3
replace tot_`i' = . if `i' == .
g other_`i' = tot_`i' - `i'
g both_`i' = `i'*other_`i'
}
postfile TableA4 comm_coef comm_se comm_pval interaction_coef interaction_se interaction_pval switches_with switches_without using "TableA4.dta", replace
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
sort id year
qui:count if abs(`i' - `i'[_n-1]) == 1 & other_`i' == 1 & other_`i'[_n-1] == 1
scalar switches_with = r(N)
qui:count if abs(`i' - `i'[_n-1]) == 1 & other_`i' == 0 & other_`i'[_n-1] == 0
scalar switches_without = r(N)
qui:xi:areg log_faads `i' other_`i' both_`i' i.year majority seniority, a(id) cluster(state)
post TableA4 (_b[`i']) (_se[`i']) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (_b[both_`i']) (_se[both_`i']) (2*ttail(e(df_r),abs(_b[both_`i']/_se[both_`i']))) (switches_with) (switches_without)
}
postclose TableA4
clear
use "TableA4.dta"
g committee = ""
replace committee = "Aging" if _n == 1
replace committee = "Agriculture" if _n == 2
replace committee = "Appropriations" if _n == 3
replace committee = "Armed Services" if _n == 4
replace committee = "Banking" if _n == 5
replace committee = "Budget" if _n == 6
replace committee = "Commerce" if _n == 7
replace committee = "Economic" if _n == 8
replace committee = "Energy" if _n == 9
replace committee = "Environment" if _n == 10
replace committee = "Ethics" if _n == 11
replace committee = "Finance" if _n == 12
replace committee = "Foreign Affairs" if _n == 13
replace committee = "Governmental Affairs" if _n == 14
replace committee = "Health" if _n == 15
replace committee = "Indian Affairs" if _n == 16
replace committee = "Intelligence" if _n == 17
replace committee = "Judiciary" if _n == 18
replace committee = "Labor" if _n == 19
replace committee = "Library" if _n == 20
replace committee = "Printing" if _n == 21
replace committee = "Rules" if _n == 22
replace committee = "Small Business" if _n == 23
replace committee = "Veterans' Affairs" if _n == 24
foreach i of varlist comm_coef comm_se interaction_coef interaction_se {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
foreach i in comm interaction {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01 
replace `i' = subinstr(`i', ".000 (.000)**", "", .)
}
keep committee comm interaction switches*
order committee comm interaction switches_without switches_with
save "TableA4.dta", replace
browse


***Table A5***
clear
set more off
use "Senate.dta"
egen state_year = group(state year)
foreach i of varlist aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans mem_ag-mem_treas {
egen sen_`i' = max(`i'), by(state_year)
replace sen_`i' = . if `i' == .
}
sort state_year
drop if state_year == state_year[_n-1]
keep state year sen_*
foreach i in ag com energy fin def milcon for hud home interior labor trans treas {
rename sen_mem_`i' sen_approp_`i'
}
sort state year
save "SenateStateLevelCommittees.dta", replace
clear
use "House.dta"
sort state year
merge state year using "SenateStateLevelCommittees.dta"
tab _merge
keep if _merge == 3
drop _merge
rename sen_agriculture sen_agricul
rename sen_appropriations sen_approps
rename sen_armed sen_armserv_natlsec
g sen_banking_finserv = max(sen_banking, sen_finance) 
rename sen_labor sen_educlab
g sen_engycom = max(sen_energy, sen_commerce)
rename sen_foreign sen_fornaff_intlrel
rename sen_government sen_govtops
rename sen_judiciary sen_judicry
g sen_natrlres = max(sen_energy, sen_environment, sen_indian)
rename sen_commerce sen_pubwork_transpo_infrast
rename sen_small sen_smallbus
rename sen_veterans sen_vetaffrs
postfile TableA5 without_coef without_se withsenator_coef withsenator_se using "TableA5.dta", replace
foreach i in agricul approps armserv_natlsec banking_finserv budget educlab engycom ethics ///
fornaff_intlrel govtops judicry natrlres pubwork_transpo_infrast rules smallbus vetaffrs {
qui:g both_`i' = `i'*sen_`i'
qui:xi:areg log_faads `i' sen_`i' both_`i' i.year majority seniority, a(id) cluster(state)
post TableA5 (_b[`i']) (_se[`i']) (_b[both_`i']) (_se[both_`i'])
}
postclose TableA5
clear
use "TableA5.dta"
foreach i in without withsenator {
g `i'_stars = abs(`i'_coef/`i'_se) >= 1.96
replace `i'_stars = 2 if abs(`i'_coef/`i'_se) >= 2.576
}
foreach i of varlist without_coef-withsenator_se {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
foreach i in without withsenator {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_stars == 1
replace `i' = `i' + "**" if `i'_stars == 2
replace `i' = subinstr(`i', ".000 (.000)**", "", .)
}
g committee = ""
replace committee = "Agriculture" if _n == 1
replace committee = "Appropriations" if _n == 2
replace committee = "Armed Services" if _n == 3
replace committee = "Banking" if _n == 4
replace committee = "Budget" if _n == 5
replace committee = "Education" if _n == 6
replace committee = "Energy" if _n == 7
replace committee = "Ethics" if _n == 8
replace committee = "Foreign Affairs" if _n == 9
replace committee = "Government Operations" if _n == 10
replace committee = "Judiciary" if _n == 11
replace committee = "Natural Resources" if _n == 12
replace committee = "Public Works" if _n == 13
replace committee = "Rules" if _n == 14
replace committee = "Small Business" if _n == 15
replace committee = "Veterans' Affairs" if _n == 16
keep committee without withsenator
order committee without withsenator
save "TableA5.dta", replace
browse


***Table A6***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "Senate.dta"
postfile TableA6 coef_1 se_1 pval_1 coef_2 se_2 pval_2 coef_3 se_3 pval_3 coef_4 se_4 pval_4 coef_5 se_5 pval_5 coef_6 se_6 pval_6 using "TableA6.dta", replace
foreach i in ag com def energy home hud interior labor milcon trans {
	forvalues j = 1/6 {
	g approp_`i'_`j' = approp_`i' == `j'
	replace approp_`i'_`j' = . if approp_`i' == .
	}
xi:areg log_non_`i' approp_`i'_* i.year majority seniority, a(senator) cluster(state)
post TableA6 ///
(_b[approp_`i'_1]) (_se[approp_`i'_1]) (2*ttail(e(df_r),abs(_b[approp_`i'_1]/_se[approp_`i'_1]))) ///
(_b[approp_`i'_2]) (_se[approp_`i'_2]) (2*ttail(e(df_r),abs(_b[approp_`i'_2]/_se[approp_`i'_2]))) ///
(_b[approp_`i'_3]) (_se[approp_`i'_3]) (2*ttail(e(df_r),abs(_b[approp_`i'_3]/_se[approp_`i'_3]))) ///
(_b[approp_`i'_4]) (_se[approp_`i'_4]) (2*ttail(e(df_r),abs(_b[approp_`i'_4]/_se[approp_`i'_4]))) ///
(_b[approp_`i'_5]) (_se[approp_`i'_5]) (2*ttail(e(df_r),abs(_b[approp_`i'_5]/_se[approp_`i'_5]))) ///
(_b[approp_`i'_6]) (_se[approp_`i'_6]) (2*ttail(e(df_r),abs(_b[approp_`i'_6]/_se[approp_`i'_6]))) 
drop approp_`i'_*
}
*Pooled
tostring year, gen(year_string)
g senator_year = senator + "_" + year_string
keep log_non_* approp_* year majority seniority senator senator_year state year_string
reshape long approp_ log_non_ , i(senator_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "treas"
g senator_sc = senator + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
rename approp_ approp
forvalues j = 1/6 {
g approp_`j' = approp == `j'
replace approp_`j' = . if approp == .
}
xi:areg log_non_ approp_* i.year_sc seniority majority, a(senator_sc) cluster(state)
post TableA6 ///
(_b[approp_1]) (_se[approp_1]) (2*ttail(e(df_r),abs(_b[approp_1]/_se[approp_1]))) ///
(_b[approp_2]) (_se[approp_2]) (2*ttail(e(df_r),abs(_b[approp_2]/_se[approp_2]))) ///
(_b[approp_3]) (_se[approp_3]) (2*ttail(e(df_r),abs(_b[approp_3]/_se[approp_3]))) ///
(_b[approp_4]) (_se[approp_4]) (2*ttail(e(df_r),abs(_b[approp_4]/_se[approp_4]))) ///
(_b[approp_5]) (_se[approp_5]) (2*ttail(e(df_r),abs(_b[approp_5]/_se[approp_5]))) ///
(_b[approp_6]) (_se[approp_6]) (2*ttail(e(df_r),abs(_b[approp_6]/_se[approp_6]))) 
postclose TableA6
clear
use "TableA6.dta"
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Transportation" if _n == 10
replace issue = "Pooled" if _n == 11
forvalues j = 1/6 {
	foreach i of varlist coef_`j' se_`j' {
	tostring `i', replace format(%5.3f) force
	replace `i' = subinstr(`i', "0.", ".", .)
	replace `i' = subinstr(`i', "-.000", ".000", .)
	replace `i' = trim(`i')
	}
g result_`j' = coef_`j' + " (" + se_`j' + ")"
replace result_`j' = result_`j' + "*" if pval_`j' <= .05
replace result_`j' = result_`j' + "*" if pval_`j' <= .01
}
keep issue result_*
save "TableA6.dta", replace
browse


***Table A7***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "House.dta"
postfile TableA7 coef_1 se_1 pval_1 coef_2 se_2 pval_2 coef_3 se_3 pval_3 coef_4 se_4 pval_4 coef_5 se_5 pval_5 coef_6 se_6 pval_6 using "TableA7.dta", replace
foreach i in ag com def energy hs hud interior labor milcon trans va {
	forvalues j = 1/6 {
	g approp_`i'_`j' = approp_`i' == `j'
	replace approp_`i'_`j' = . if approp_`i' == .
	}
xi:areg log_non_`i' approp_`i'_* i.year majority seniority , a(id) cluster(state)
post TableA7 ///
(_b[approp_`i'_1]) (_se[approp_`i'_1]) (2*ttail(e(df_r),abs(_b[approp_`i'_1]/_se[approp_`i'_1]))) ///
(_b[approp_`i'_2]) (_se[approp_`i'_2]) (2*ttail(e(df_r),abs(_b[approp_`i'_2]/_se[approp_`i'_2]))) ///
(_b[approp_`i'_3]) (_se[approp_`i'_3]) (2*ttail(e(df_r),abs(_b[approp_`i'_3]/_se[approp_`i'_3]))) ///
(_b[approp_`i'_4]) (_se[approp_`i'_4]) (2*ttail(e(df_r),abs(_b[approp_`i'_4]/_se[approp_`i'_4]))) ///
(_b[approp_`i'_5]) (_se[approp_`i'_5]) (2*ttail(e(df_r),abs(_b[approp_`i'_5]/_se[approp_`i'_5]))) ///
(_b[approp_`i'_6]) (_se[approp_`i'_6]) (2*ttail(e(df_r),abs(_b[approp_`i'_6]/_se[approp_`i'_6]))) 
drop approp_`i'_*
}
*Pooled
tostring year, gen(year_string)
g id_year = id + "_" + year_string
keep log_faads_* faads_* approp_* log_non_* non_* year majority seniority id id_year state year_string
reshape long approp_ faads_ log_faads_ log_non_ non_, i(id_year) j(subcommittee) string
g id_sc = id + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
drop if subcommittee == "dc" | subcommittee == "for" | subcommittee == "fin" | subcommittee == "leg" | subcommittee == "treas" | subcommittee == "state"
drop if approp_ == .
rename approp_ approp
forvalues j = 1/6 {
g approp_`j' = approp == `j'
replace approp_`j' = . if approp == .
}
xi:areg log_non_ approp_* i.year_sc seniority majority, a(id_sc) cluster(state)
post TableA7 ///
(_b[approp_1]) (_se[approp_1]) (2*ttail(e(df_r),abs(_b[approp_1]/_se[approp_1]))) ///
(_b[approp_2]) (_se[approp_2]) (2*ttail(e(df_r),abs(_b[approp_2]/_se[approp_2]))) ///
(_b[approp_3]) (_se[approp_3]) (2*ttail(e(df_r),abs(_b[approp_3]/_se[approp_3]))) ///
(_b[approp_4]) (_se[approp_4]) (2*ttail(e(df_r),abs(_b[approp_4]/_se[approp_4]))) ///
(_b[approp_5]) (_se[approp_5]) (2*ttail(e(df_r),abs(_b[approp_5]/_se[approp_5]))) ///
(_b[approp_6]) (_se[approp_6]) (2*ttail(e(df_r),abs(_b[approp_6]/_se[approp_6]))) 
postclose TableA7
clear
use "TableA7.dta"
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Transportation" if _n == 10
replace issue = "Veterans' Affairs" if _n == 11
replace issue = "Pooled" if _n == 12
forvalues j = 1/6 {
	foreach i of varlist coef_`j' se_`j' {
	tostring `i', replace format(%5.3f) force
	replace `i' = subinstr(`i', "0.", ".", .)
	replace `i' = subinstr(`i', "-.000", ".000", .)
	replace `i' = trim(`i')
	}
g result_`j' = coef_`j' + " (" + se_`j' + ")"
replace result_`j' = result_`j' + "*" if pval_`j' <= .05
replace result_`j' = result_`j' + "*" if pval_`j' <= .01
replace result_`j' = "" if result_`j' == ".000 (.000)"
}
keep issue result_*
save "TableA7.dta", replace
browse


***Table A8***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "Senate.dta"
postfile TableA8 coef_1 se_1 pval_1 coef_2 se_2 pval_2 coef_3 se_3 pval_3 coef_4 se_4 pval_4 using "TableA8.dta", replace
foreach i in ag com def energy hud interior labor milcon trans {
	forvalues j = 1/4 {
	g authstatus_`i'_`j' = authstatus_`i' == `j'
	replace authstatus_`i'_`j' = . if authstatus_`i' == .
	}
xi:areg log_faads_`i' authstatus_`i'_* i.year majority seniority, a(senator) cluster(state)
post TableA8 ///
(_b[authstatus_`i'_1]) (_se[authstatus_`i'_1]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_1]/_se[authstatus_`i'_1]))) ///
(_b[authstatus_`i'_2]) (_se[authstatus_`i'_2]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_2]/_se[authstatus_`i'_2]))) ///
(_b[authstatus_`i'_3]) (_se[authstatus_`i'_3]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_3]/_se[authstatus_`i'_3]))) ///
(_b[authstatus_`i'_4]) (_se[authstatus_`i'_4]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_4]/_se[authstatus_`i'_4])))
drop authstatus_`i'_*
}
*Pooled
tostring year, gen(year_string)
g senator_year = senator + "_" + year_string
keep log_faads_* authstatus_* year majority seniority senator senator_year state year_string
reshape long log_faads_ authstatus_, i(senator_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "treas" | subcommittee == "home"
g senator_sc = senator + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
rename authstatus_ authstatus
forvalues j = 1/4 {
g authstatus_`j' = authstatus == `j'
}
xi:areg log_faads_ authstatus_* i.year_sc seniority majority, a(senator_sc) cluster(state)
post TableA8 ///
(_b[authstatus_1]) (_se[authstatus_1]) (2*ttail(e(df_r),abs(_b[authstatus_1]/_se[authstatus_1]))) ///
(_b[authstatus_2]) (_se[authstatus_2]) (2*ttail(e(df_r),abs(_b[authstatus_2]/_se[authstatus_2]))) ///
(_b[authstatus_3]) (_se[authstatus_3]) (2*ttail(e(df_r),abs(_b[authstatus_3]/_se[authstatus_3]))) ///
(_b[authstatus_4]) (_se[authstatus_4]) (2*ttail(e(df_r),abs(_b[authstatus_4]/_se[authstatus_4])))
postclose TableA8
clear
use "TableA8.dta"
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Housing" if _n == 5
replace issue = "Interior" if _n == 6
replace issue = "Labor" if _n == 7
replace issue = "Military Construction" if _n == 8
replace issue = "Transportation" if _n == 9
replace issue = "Pooled" if _n == 10
forvalues j = 1/4 {
	foreach i of varlist coef_`j' se_`j' {
	tostring `i', replace format(%5.3f) force
	replace `i' = subinstr(`i', "0.", ".", .)
	replace `i' = subinstr(`i', "-.000", ".000", .)
	replace `i' = trim(`i')
	}
g result_`j' = coef_`j' + " (" + se_`j' + ")"
replace result_`j' = result_`j' + "*" if pval_`j' <= .05
replace result_`j' = result_`j' + "*" if pval_`j' <= .01
}
keep issue result_*
save "TableA8.dta", replace
browse


***Table A9***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "House.dta"
postfile TableA9 coef_1 se_1 pval_1 coef_2 se_2 pval_2 coef_3 se_3 pval_3 coef_4 se_4 pval_4 using "TableA9.dta", replace
foreach i in ag com def energy hs hud interior labor milcon trans va {
	forvalues j = 1/4 {
	g authstatus_`i'_`j' = authstatus_`i' == `j'
	replace authstatus_`i'_`j' = . if authstatus_`i' == .
	}
xi:areg log_faads_`i' authstatus_`i'_* i.year majority seniority, a(id) cluster(state)
post TableA9 ///
(_b[authstatus_`i'_1]) (_se[authstatus_`i'_1]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_1]/_se[authstatus_`i'_1]))) ///
(_b[authstatus_`i'_2]) (_se[authstatus_`i'_2]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_2]/_se[authstatus_`i'_2]))) ///
(_b[authstatus_`i'_3]) (_se[authstatus_`i'_3]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_3]/_se[authstatus_`i'_3]))) ///
(_b[authstatus_`i'_4]) (_se[authstatus_`i'_4]) (2*ttail(e(df_r),abs(_b[authstatus_`i'_4]/_se[authstatus_`i'_4])))
drop authstatus_`i'_*
}
*Pooled
tostring year, gen(year_string)
g id_year = id + "_" + year_string
keep log_faads_* authstatus_* year majority seniority id id_year state year_string
reshape long log_faads_ authstatus_, i(id_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "state" | subcommittee == "treas"
g id_sc = id + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
rename authstatus_ authstatus
forvalues j = 1/4 {
g authstatus_`j' = authstatus == `j'
}
xi:areg log_faads_ authstatus_* i.year_sc seniority majority, a(id_sc) cluster(state)
post TableA9 ///
(_b[authstatus_1]) (_se[authstatus_1]) (2*ttail(e(df_r),abs(_b[authstatus_1]/_se[authstatus_1]))) ///
(_b[authstatus_2]) (_se[authstatus_2]) (2*ttail(e(df_r),abs(_b[authstatus_2]/_se[authstatus_2]))) ///
(_b[authstatus_3]) (_se[authstatus_3]) (2*ttail(e(df_r),abs(_b[authstatus_3]/_se[authstatus_3]))) ///
(_b[authstatus_4]) (_se[authstatus_4]) (2*ttail(e(df_r),abs(_b[authstatus_4]/_se[authstatus_4])))
postclose TableA9
clear
use "TableA9.dta"
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Defense" if _n == 3
replace issue = "Energy" if _n == 4
replace issue = "Homeland Security" if _n == 5
replace issue = "Housing" if _n == 6
replace issue = "Interior" if _n == 7
replace issue = "Labor" if _n == 8
replace issue = "Military Construction" if _n == 9
replace issue = "Transportation" if _n == 10
replace issue = "Veterans' Affairs" if _n == 11
replace issue = "Pooled" if _n == 12
forvalues j = 1/4 {
	foreach i of varlist coef_`j' se_`j' {
	tostring `i', replace format(%5.3f) force
	replace `i' = subinstr(`i', "0.", ".", .)
	replace `i' = subinstr(`i', "-.000", ".000", .)
	replace `i' = trim(`i')
	}
g result_`j' = coef_`j' + " (" + se_`j' + ")"
replace result_`j' = result_`j' + "*" if pval_`j' <= .05
replace result_`j' = result_`j' + "*" if pval_`j' <= .01
}
keep issue result_*
save "TableA9.dta", replace
browse


***Table A10***
clear
set more off
use "Senate.dta"
postfile TableA10 mean_dollars sd_dollars auth_coef auth_se auth_pval approp_coef approp_se approp_pval using "TableA10.dta", replace
foreach i in ag com energy hud interior labor trans {
sum formula_`i'
scalar mean_dollars = r(mean)
scalar sd_dollars = r(sd)
xi:areg log_formula_`i' auth_`i' i.year majority seniority, a(senator) cluster(state)
scalar auth_coef = _b[auth_`i']
scalar auth_se = _se[auth_`i']
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_`i']/_se[auth_`i']))
xi:areg log_formula_`i' mem_`i' i.year majority seniority, a(senator) cluster(state)
post TableA10 (mean_dollars) (sd_dollars) (auth_coef) (auth_se) (auth_pval) (_b[mem_`i']) (_se[mem_`i']) (2*ttail(e(df_r),abs(_b[mem_`i']/_se[mem_`i']))) 
}
*Pooled
tostring year, gen(year_string)
g senator_year = senator + "_" + year_string
keep log_formula_* auth_* mem_* year majority seniority senator senator_year state year_string
reshape long mem_ log_formula_ auth_, i(senator_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "treas" | subcommittee == "def" | subcommittee == "home" | subcommittee == "milcon"
g senator_sc = senator + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
xi:areg log_formula_ auth_ i.year_sc seniority majority, a(senator_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
xi:areg log_formula_ mem_ i.year_sc seniority majority, a(senator_sc) cluster(state)
post TableA10 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
*Naive
areg log_formula_ auth_ seniority majority, a(year_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
areg log_formula_ mem_ seniority majority, a(year_sc) cluster(state)
post TableA10 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
postclose TableA10
clear
use "TableA10.dta"
browse
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Energy" if _n == 3
replace issue = "Housing" if _n == 4
replace issue = "Interior" if _n == 5
replace issue = "Labor" if _n == 6
replace issue = "Transportation" if _n == 7
replace issue = "Pooled" if _n == 8
replace issue = "Naive" if _n == 9
foreach i of varlist mean_dollars sd_dollars {
tostring `i', replace format(%5.1f) force
replace `i' = trim(`i')
replace `i' = "" if `i' == "."
}
foreach i of varlist auth_coef auth_se approp_coef approp_se {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
foreach i in auth approp {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
g dollars = mean_dollars + " (" + sd_dollars + ")"
replace dollars = "" if dollars == " ()"
keep issue dollars auth approp
order issue dollars auth approp
save "TableA10.dta", replace
browse


***Table A11***
clear
set more off
use "House.dta"
postfile TableA11 mean_dollars sd_dollars auth_coef auth_se auth_pval approp_coef approp_se approp_pval using "TableA11.dta", replace
foreach i in ag com energy hud interior labor trans va {
sum formula_`i'
scalar mean_dollars = r(mean)
scalar sd_dollars = r(sd)
xi:areg log_formula_`i' auth_`i' i.year majority seniority , a(id) cluster(state)
scalar auth_coef = _b[auth_`i']
scalar auth_se = _se[auth_`i']
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_`i']/_se[auth_`i']))
xi:areg log_formula_`i' mem_`i' i.year majority seniority , a(id) cluster(state)
post TableA11 (mean_dollars) (sd_dollars) (auth_coef) (auth_se) (auth_pval) (_b[mem_`i']) (_se[mem_`i']) (2*ttail(e(df_r),abs(_b[mem_`i']/_se[mem_`i']))) 
}
*Pooled
tostring year, gen(year_string)
g id_year = id + "_" + year_string
keep log_formula_* mem_* auth_* year majority seniority id id_year state year_string
reshape long mem_ auth_ log_formula_ , i(id_year) j(subcommittee) string
g id_sc = id + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
drop if subcommittee == "dc" | subcommittee == "for" | subcommittee == "fin" | subcommittee == "leg" | subcommittee == "treas" | subcommittee == "state" | subcommittee == "def" | subcommittee == "hs" | subcommittee == "milcon"
drop if mem_ == . & auth_ == .
xi:areg log_formula_ auth_ i.year_sc seniority majority, a(id_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
xi:areg log_formula_ mem_ i.year_sc seniority majority, a(id_sc) cluster(state)
post TableA11 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
*Naive
areg log_formula_ auth_ seniority majority, a(year_sc) cluster(state)
scalar auth_coef = _b[auth_]
scalar auth_se = _se[auth_]
scalar auth_pval = 2*ttail(e(df_r),abs(_b[auth_]/_se[auth_]))
areg log_formula_ mem_ seniority majority, a(year_sc) cluster(state)
post TableA11 (.) (.) (auth_coef) (auth_se) (auth_pval) (_b[mem_]) (_se[mem_]) (2*ttail(e(df_r),abs(_b[mem_]/_se[mem_]))) 
postclose TableA11
clear
use "TableA11.dta"
browse
g issue = ""
replace issue = "Agriculture" if _n == 1
replace issue = "Commerce" if _n == 2
replace issue = "Energy" if _n == 3
replace issue = "Housing" if _n == 4
replace issue = "Interior" if _n == 5
replace issue = "Labor" if _n == 6
replace issue = "Transportation" if _n == 7
replace issue = "Veterans' Affairs" if _n == 8
replace issue = "Pooled" if _n == 9
replace issue = "Naive" if _n == 10
foreach i of varlist mean_dollars sd_dollars {
tostring `i', replace format(%5.1f) force
replace `i' = trim(`i')
replace `i' = "" if `i' == "."
}
foreach i of varlist auth_coef auth_se approp_coef approp_se {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
foreach i in auth approp {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
g dollars = mean_dollars + " (" + sd_dollars + ")"
replace dollars = "" if dollars == " ()"
keep issue dollars auth approp
order issue dollars auth approp
save "TableA11.dta", replace
browse


***Table A12***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "Senate.dta"
g turnover = congress == 99 | congress == 103 | congress == 106 | congress == 107 | congress == 109
tostring year, gen(year_string)
g senator_year = senator + "_" + year_string
keep log_faads_* approp_* year majority seniority senator senator_year state year_string turnover*
reshape long approp_ log_faads_ , i(senator_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "treas"
g senator_sc = senator + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
rename approp_ approp
forvalues j = 1/6 {
g approp_`j' = approp == `j'
replace approp_`j' = . if approp == .
g turnover_approp_`j' = turnover*approp_`j'
}
matrix B = J(6, 6, .)
xi:areg log_faads_ approp_* turnover_* i.year_sc seniority majority, a(senator_sc) cluster(state)
forvalues i = 1/6 {
matrix B[`i', 1] = _b[approp_`i']
matrix B[`i', 2] = _se[approp_`i']
matrix B[`i', 3] = 2*ttail(e(df_r),(_b[approp_`i']/_se[approp_`i']))
matrix B[`i', 4] = _b[turnover_approp_`i']
matrix B[`i', 5] = _se[turnover_approp_`i']
matrix B[`i', 6] = 2*ttail(e(df_r),(_b[turnover_approp_`i']/_se[turnover_approp_`i']))
}
svmat B
keep B*
drop if B1 == .
foreach i of varlist B1 B2 B4 B5 {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
rename B1 approp_coef
rename B2 approp_se
rename B3 approp_pval
rename B4 turnover_coef
rename B5 turnover_se
rename B6 turnover_pval
foreach i in approp turnover {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
keep approp turnover
rename approp result_Appropriations
rename turnover result_Turnover
g id = _n
reshape long result_, i(id) j(variable) string
sort id variable
set obs 16
replace variable = "Legislator-Subcommittee Fixed Effects" if _n == 13
replace variable = "Year-Subcommittee Fixed Effects" if _n == 14
replace variable = "R-squared" if _n == 15
replace variable = "Observations" if _n == 16
replace result_ = "X" if _n == 13 | _n == 14
disp e(r2)
replace result_ = ".95" if _n == 15
disp e(N)
replace result_ = "23,660" if _n == 16
drop id
g row = _n
replace variable = "Minority Appropriations" if row == 1
replace variable = "Minority Appropriations*Turnover" if row == 2
replace variable = "Majority Appropriations" if row == 3
replace variable = "Majority Appropriations*Turnover" if row == 4
replace variable = "Minority Subcommittee" if row == 5
replace variable = "Minority Subcommittee*Turnover" if row == 6
replace variable = "Majority Subcommittee" if row == 7
replace variable = "Majority Subcommittee*Turnover" if row == 8
replace variable = "Ranking Minority" if row == 9
replace variable = "Ranking Minority*Turnover" if row == 10
replace variable = "Subcommittee Chair" if row == 11
replace variable = "Subcommittee Chair*Turnover" if row == 12
rename result_ result_senate
sort row
save "TableA12.dta", replace
clear
clear matrix
clear mata
set matsize 10000
set more off
use "House.dta"
g turnover = congress == 103 | congress == 109 | congress == 111
tostring year, gen(year_string)
g id_year = id + "_" + year_string
keep log_faads_* faads_* approp_* log_non_* non_* year majority seniority id id_year state year_string turnover
reshape long approp_ faads_ log_faads_ log_non_ non_, i(id_year) j(subcommittee) string
g id_sc = id + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
drop if subcommittee == "dc" | subcommittee == "for" | subcommittee == "fin" | subcommittee == "leg" | subcommittee == "treas" | subcommittee == "state"
drop if approp_ == .
rename approp_ approp
forvalues i = 1/6 {
g approp_`i' = approp == `i'
g turnover_approp_`i' = turnover*approp_`i'
}
matrix B = J(6, 6, .)
xi:areg log_faads_ approp_* turnover_* i.year_sc seniority majority, a(id_sc) cluster(state)
forvalues i = 1/6 {
matrix B[`i', 1] = _b[approp_`i']
matrix B[`i', 2] = _se[approp_`i']
matrix B[`i', 3] = 2*ttail(e(df_r),(_b[approp_`i']/_se[approp_`i']))
matrix B[`i', 4] = _b[turnover_approp_`i']
matrix B[`i', 5] = _se[turnover_approp_`i']
matrix B[`i', 6] = 2*ttail(e(df_r),(_b[turnover_approp_`i']/_se[turnover_approp_`i']))
}
svmat B
keep B*
drop if B1 == .
foreach i of varlist B1 B2 B4 B5 {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
rename B1 approp_coef
rename B2 approp_se
rename B3 approp_pval
rename B4 turnover_coef
rename B5 turnover_se
rename B6 turnover_pval
foreach i in approp turnover {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
keep approp turnover
rename approp result_Appropriations
rename turnover result_Turnover
g id = _n
reshape long result_, i(id) j(variable) string
set obs 16
replace result_ = "X" if _n == 13 | _n == 14
disp e(r2)
replace result_ = ".91" if _n == 15
disp e(N)
replace result_ = "95,318" if _n == 16
rename result_ result_house
keep result_house
g row = _n
sort row
merge row using "TableA12.dta"
drop row _merge
order variable result_senate result_house
save "TableA12.dta", replace
browse


***Table A13***
clear
clear matrix
clear mata
set matsize 10000
set more off
use "Senate.dta"
tostring year, gen(year_string)
g senator_year = senator + "_" + year_string
keep log_faads_* approp_* year majority seniority senator senator_year state year_string rep
reshape long approp_ log_faads_ , i(senator_year) j(subcommittee) string
drop if subcommittee == "fin" | subcommittee == "for" | subcommittee == "treas"
g senator_sc = senator + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
rename approp_ approp
forvalues j = 1/6 {
g approp_`j' = approp == `j'
replace approp_`j' = . if approp == .
g rep_approp_`j' = rep*approp_`j'
}
matrix B = J(6, 6, .)
xi:areg log_faads_ approp_* rep_* i.year_sc seniority majority, a(senator_sc) cluster(state)
forvalues i = 1/6 {
matrix B[`i', 1] = _b[approp_`i']
matrix B[`i', 2] = _se[approp_`i']
matrix B[`i', 3] = 2*ttail(e(df_r),(_b[approp_`i']/_se[approp_`i']))
matrix B[`i', 4] = _b[rep_approp_`i']
matrix B[`i', 5] = _se[rep_approp_`i']
matrix B[`i', 6] = 2*ttail(e(df_r),(_b[rep_approp_`i']/_se[rep_approp_`i']))
}
svmat B
keep B*
drop if B1 == .
foreach i of varlist B1 B2 B4 B5 {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
rename B1 approp_coef
rename B2 approp_se
rename B3 approp_pval
rename B4 rep_coef
rename B5 rep_se
rename B6 rep_pval
foreach i in approp rep {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
keep approp rep
rename approp result_Appropriations
rename rep result_Rep
g id = _n
reshape long result_, i(id) j(variable) string
sort id variable
set obs 16
replace variable = "Legislator-Subcommittee Fixed Effects" if _n == 13
replace variable = "Year-Subcommittee Fixed Effects" if _n == 14
replace variable = "R-squared" if _n == 15
replace variable = "Observations" if _n == 16
replace result_ = "X" if _n == 13 | _n == 14
disp e(r2)
replace result_ = ".95" if _n == 15
disp e(N)
replace result_ = "23,660" if _n == 16
drop id
g row = _n
replace variable = "Minority Appropriations" if row == 1
replace variable = "Minority Appropriations*Republican" if row == 2
replace variable = "Majority Appropriations" if row == 3
replace variable = "Majority Appropriations*Republican" if row == 4
replace variable = "Minority Subcommittee" if row == 5
replace variable = "Minority Subcommittee*Republican" if row == 6
replace variable = "Majority Subcommittee" if row == 7
replace variable = "Majority Subcommittee*Republican" if row == 8
replace variable = "Ranking Minority" if row == 9
replace variable = "Ranking Minority*Republican" if row == 10
replace variable = "Subcommittee Chair" if row == 11
replace variable = "Subcommittee Chair*Republican" if row == 12
rename result_ result_senate
sort row
save "TableA13.dta", replace
clear
clear matrix
clear mata
set matsize 10000
set more off
use "House.dta"
g turnover = congress == 103 | congress == 109 | congress == 111
tostring year, gen(year_string)
g id_year = id + "_" + year_string
keep log_faads_* faads_* approp_* log_non_* non_* year majority seniority id id_year state year_string rep
reshape long approp_ faads_ log_faads_ log_non_ non_, i(id_year) j(subcommittee) string
g id_sc = id + "_" + subcommittee
g year_sc = year_string + "_" + subcommittee
drop if subcommittee == "dc" | subcommittee == "for" | subcommittee == "fin" | subcommittee == "leg" | subcommittee == "treas" | subcommittee == "state"
drop if approp_ == .
rename approp_ approp
forvalues i = 1/6 {
g approp_`i' = approp == `i'
g rep_approp_`i' = rep*approp_`i'
}
matrix B = J(6, 6, .)
xi:areg log_faads_ approp_* rep_* i.year_sc seniority majority, a(id_sc) cluster(state)
forvalues i = 1/6 {
matrix B[`i', 1] = _b[approp_`i']
matrix B[`i', 2] = _se[approp_`i']
matrix B[`i', 3] = 2*ttail(e(df_r),(_b[approp_`i']/_se[approp_`i']))
matrix B[`i', 4] = _b[rep_approp_`i']
matrix B[`i', 5] = _se[rep_approp_`i']
matrix B[`i', 6] = 2*ttail(e(df_r),(_b[rep_approp_`i']/_se[rep_approp_`i']))
}
svmat B
keep B*
drop if B1 == .
foreach i of varlist B1 B2 B4 B5 {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
rename B1 approp_coef
rename B2 approp_se
rename B3 approp_pval
rename B4 rep_coef
rename B5 rep_se
rename B6 rep_pval
foreach i in approp rep {
g `i' = `i'_coef + " (" + `i'_se + ")"
replace `i' = `i' + "*" if `i'_pval <= .05
replace `i' = `i' + "*" if `i'_pval <= .01
}
keep approp rep
rename approp result_Appropriations
rename rep result_Rep
g id = _n
reshape long result_, i(id) j(variable) string
set obs 16
replace result_ = "X" if _n == 13 | _n == 14
disp e(r2)
replace result_ = ".91" if _n == 15
disp e(N)
replace result_ = "95,318" if _n == 16
rename result_ result_house
keep result_house
g row = _n
sort row
merge row using "TableA13.dta"
drop row _merge
order variable result_senate result_house
save "TableA13.dta", replace
browse


**Table A14** (State-Level Federal Employment and Procurement Grants)
clear
set more off
use "Senate.dta"
sort state year 
merge state year using "FederalEmployment_1969_2013.dta"
keep if _merge == 3
g fedciv_pop = fedciv/pop
g fedciv_log = log(fedciv + 1)
sum fedciv_pop
postfile TableA14_fedciv coef ster pval upper lower using "TableA14_fedciv.dta", replace
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
xi:areg fedciv_log `i' i.year majority seniority, a(id) cluster(state)
post TableA14_fedciv (_b[`i']) (_se[`i']) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (_b[`i'] + _se[`i']*invttail(e(df_r),.025)) (_b[`i'] - _se[`i']*invttail(e(df_r),.025))		
}
postclose TableA14_fedciv
clear
use "TableA14_fedciv.dta"
foreach i of varlist coef ster upper lower {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
g result = coef + " (" + ster + ")"
replace result = result + "*" if pval <= .05
replace result = result + "*" if pval <= .01
replace result = subinstr(result, ".000 (.000)**", "", .)
g committee = ""
replace committee = "Aging" if _n == 1
replace committee = "Agriculture" if _n == 2
replace committee = "Appropriations" if _n == 3
replace committee = "Armed Services" if _n == 4
replace committee = "Banking" if _n == 5
replace committee = "Budget" if _n == 6
replace committee = "Commerce" if _n == 7
replace committee = "Economic" if _n == 8
replace committee = "Energy" if _n == 9
replace committee = "Environment" if _n == 10
replace committee = "Ethics" if _n == 11
replace committee = "Finance" if _n == 12
replace committee = "Foreign Affairs" if _n == 13
replace committee = "Governmental Affairs" if _n == 14
replace committee = "Health" if _n == 15
replace committee = "Indian Affairs" if _n == 16
replace committee = "Intelligence" if _n == 17
replace committee = "Judiciary" if _n == 18
replace committee = "Labor" if _n == 19
replace committee = "Library" if _n == 20
replace committee = "Printing" if _n == 21
replace committee = "Rules" if _n == 22
replace committee = "Small Business" if _n == 23
replace committee = "Veterans' Affairs" if _n == 24
keep committee result
order committee result
sort committee
save "TableA14_fedciv.dta", replace
browse

clear
set more off
use "Senate.dta"
sort state year 
merge state year using "FederalEmployment_1969_2013.dta"
keep if _merge == 3
g military_pop = military/pop
g military_log = log(military + 1)
sum military_pop
postfile TableA14_military coef ster pval upper lower using "TableA14_military.dta", replace
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
xi:areg military_log `i' i.year majority seniority, a(id) cluster(state)
post TableA14_military (_b[`i']) (_se[`i']) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (_b[`i'] + _se[`i']*invttail(e(df_r),.025)) (_b[`i'] - _se[`i']*invttail(e(df_r),.025))		
}
postclose TableA14_military
clear
use "TableA14_military.dta"
foreach i of varlist coef ster upper lower {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
g result = coef + " (" + ster + ")"
replace result = result + "*" if pval <= .05
replace result = result + "*" if pval <= .01
replace result = subinstr(result, ".000 (.000)**", "", .)
g committee = ""
replace committee = "Aging" if _n == 1
replace committee = "Agriculture" if _n == 2
replace committee = "Appropriations" if _n == 3
replace committee = "Armed Services" if _n == 4
replace committee = "Banking" if _n == 5
replace committee = "Budget" if _n == 6
replace committee = "Commerce" if _n == 7
replace committee = "Economic" if _n == 8
replace committee = "Energy" if _n == 9
replace committee = "Environment" if _n == 10
replace committee = "Ethics" if _n == 11
replace committee = "Finance" if _n == 12
replace committee = "Foreign Affairs" if _n == 13
replace committee = "Governmental Affairs" if _n == 14
replace committee = "Health" if _n == 15
replace committee = "Indian Affairs" if _n == 16
replace committee = "Intelligence" if _n == 17
replace committee = "Judiciary" if _n == 18
replace committee = "Labor" if _n == 19
replace committee = "Library" if _n == 20
replace committee = "Printing" if _n == 21
replace committee = "Rules" if _n == 22
replace committee = "Small Business" if _n == 23
replace committee = "Veterans' Affairs" if _n == 24
keep committee result
order committee result
sort committee
save "TableA14_military.dta", replace
browse


clear
set more off
use "Senate.dta"
sort state year 
merge state year using "Procurements_1983_2010.dta"
keep if _merge == 3
drop _merge
g procurement_pop = procurement/pop
g procurement_log = log(procurement + 1)
sum procurement_pop
postfile TableA14_procurement coef ster pval upper lower using "TableA14_procurement.dta", replace
foreach i in aging agriculture appropriations armed banking budget commerce economic energy ///
environment ethics finance foreign government health indian intelligence judiciary ///
labor library printing rules small veterans {
xi:areg procurement_log `i' i.year majority seniority, a(id) cluster(state)
post TableA14_procurement (_b[`i']) (_se[`i']) (2*ttail(e(df_r),abs(_b[`i']/_se[`i']))) (_b[`i'] + _se[`i']*invttail(e(df_r),.025)) (_b[`i'] - _se[`i']*invttail(e(df_r),.025))		
}
postclose TableA14_procurement
clear
use "TableA14_procurement.dta"
foreach i of varlist coef ster upper lower {
tostring `i', replace format(%5.3f) force
replace `i' = subinstr(`i', "0.", ".", .)
replace `i' = subinstr(`i', "-.000", ".000", .)
replace `i' = trim(`i')
}
g result = coef + " (" + ster + ")"
replace result = result + "*" if pval <= .05
replace result = result + "*" if pval <= .01
replace result = subinstr(result, ".000 (.000)**", "", .)
g committee = ""
replace committee = "Aging" if _n == 1
replace committee = "Agriculture" if _n == 2
replace committee = "Appropriations" if _n == 3
replace committee = "Armed Services" if _n == 4
replace committee = "Banking" if _n == 5
replace committee = "Budget" if _n == 6
replace committee = "Commerce" if _n == 7
replace committee = "Economic" if _n == 8
replace committee = "Energy" if _n == 9
replace committee = "Environment" if _n == 10
replace committee = "Ethics" if _n == 11
replace committee = "Finance" if _n == 12
replace committee = "Foreign Affairs" if _n == 13
replace committee = "Governmental Affairs" if _n == 14
replace committee = "Health" if _n == 15
replace committee = "Indian Affairs" if _n == 16
replace committee = "Intelligence" if _n == 17
replace committee = "Judiciary" if _n == 18
replace committee = "Labor" if _n == 19
replace committee = "Library" if _n == 20
replace committee = "Printing" if _n == 21
replace committee = "Rules" if _n == 22
replace committee = "Small Business" if _n == 23
replace committee = "Veterans' Affairs" if _n == 24
keep committee result
order committee result
sort committee
save "TableA14_procurement.dta", replace
browse


***Other Facts Noted in the Text of the Paper***
*How many members of the Senate Appropriations Committee are chairs or ranking minority members ? 
clear
set more off
use "Senate.dta"
g maxrank = max(approp_ag, approp_com, approp_energy, approp_fin, approp_def, approp_milcon, approp_for, approp_hud, approp_home, approp_interior, approp_labor, approp_trans, approp_treas)
tab maxrank
disp (290 + 295)/(4 + 70 + 121 + 290 + 295)
disp 295/(4 + 70 + 121 + 290 + 295)
*How many will be a chair or ranking minority member at some point in their career?
egen maxmaxrank = max(maxrank), by(senator)
tab maxmaxrank
disp (155 + 735)/(23 + 24 + 132 + 155 + 735)
disp 735/(23 + 24 + 132 + 155 + 735)

*How many members of the House Appropriations Committee are chairs or ranking minority members in a given year?
clear
set more off
use "House.dta"
g maxrank = max(approp_ag, approp_com, approp_def, approp_energy, approp_fin, approp_for, approp_hud, approp_interior, approp_labor, approp_leg, approp_milcon, approp_hs, approp_state, approp_treas, approp_va)
tab maxrank
disp (253 + 260)/(31 + 32 + 342 + 580 + 253 + 260)
*How many will be a chair or ranking minority member at some point in their career?
split id, p(_)
g representative = id1 + "_" + id2 + "_" + id3
egen maxmaxrank = max(maxrank), by(representative)
tab maxmaxrank
disp (310 + 669)/(74 + 50 + 126 + 738 + 310 + 669)

*Employment Data and Selection onto Committees
clear
set more off
use "House.dta"
split id, p(_)
drop id1 id3 id4
destring id2, replace
rename id2 dist
sort state dist
merge state dist using "Employment.dta"
tab _merge
keep if cong >= 108
keep if _merge == 3
table auth_ag, content(mean agriculture)
table auth_def, content(mean military)


