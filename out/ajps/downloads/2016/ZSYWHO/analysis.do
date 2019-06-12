/*
This script replicates all the tables in the paper and online appendix, using files
"mininglocal.dta" and "mininglocal_nw.dta" as input data. Users should change the working directory to the location 
of the replication files in the -cd- statement on line 23. 

Also note: The -estout- package must be updated to the latest version for the output of the tables to be correct 
(if already installed). Run "adoupdate estout, update".
*/

clear
set more off
version 13

capture which ivreg2.ado
if _rc!=0 {
	ssc install ivreg2
	}
capture which estout.ado
if _rc!=0 {
	ssc install estout
	}
	
cd "SET PATH TO REPLICATION PACKAGE TOP FOLDER"

use "mininglocal.dta"

/* Tables in the main manuscript */
/*------------------------------ */

*** Table 1 ***

quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
test active50-inactive50=0
estadd scalar difference = _b[active50]-_b[inactive50]
estadd scalar F_t = r(F), replace  
estadd scalar p_f = r(p), replace 
summarize `x' if e(sample)==1
estadd scalar mean_depvar = r(mean)
}

local varlist ///
active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(difference F_t p_f mean_depvar r2 N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "baseline_all_waves.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
		active50 "Active 50 km"
		inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table 2 ***

quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x in `depvar' {
xtreg `x' active50 female educ urban age age2 _I* _Y* ///
	if suspended50==0 ///
	, cluster(minefixed50) fe
eststo `x'
summarize `x' if e(sample)==1
estadd scalar mean_depvar = r(mean)
}

local varlist ///
active50

noisily esttab `depvar' , ///
	keep(`varlist') order(`varlist') stats(mean_depvar r2 N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar' using "baseline_fixedeffects.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		mean_depvar r2 N, 
		labels( 
			"Mean dep. var"
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
		active50 "Active 50 km"
		inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}


*** Table 3 ***
preserve
gen opening_year=int_year-yearssince_active50
replace opening_year=9999 if active50==0

collapse (mean) police_station police bribe_police urban age age2 female education ///
	(first) _I* _Y*  active50 inactive50 suspended50 opening_year median mean ///
	, by(cluster int_year year)

gen active= 1 if year>=opening_year &  opening_year<.
replace active=0 if active==. 

gen active2= 1 if year>=opening_year &  opening_year<.
replace active2=0 if year<opening_year & opening_year<9999

gen active_median=active50*median
gen active_mean=active50*mean

quietly {
eststo clear
eststo median_: reg median active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0 & year==int_year, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace
	estadd scalar p_f = r(p), replace
	summarize median if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo b_med: reg bribe_police median urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo b_cont: reg bribe_police active50 inactive50 median urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace
	estadd scalar p_f = r(p), replace
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo int_: reg bribe_police median active_median active50 urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)

local varlist active50 inactive50 median active_median

noisily esttab median_ b_med b_cont int_, ///
	keep(`varlist') order(`varlist') stats(difference F_t p_f mean_depvar r2 N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab median_ b_med b_cont int_  using "light_table.tex",
    style(tex) nostar booktabs b(4) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N
		, labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	) 
    mtitles("Median light" "Bribe to Police" "Bribe to Police" "Bribe to Police" )
    keep(`varlist') order(`varlist')
    varlabels(
		active50 "Active 50 km"
		inactive50 "Inactive 50 km"
		median "Median light"
		active_median "Median light $\times$ Active 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}
/* Light tables in the online appendix */
/* ----------------------------------- */

*** Table A.55 ***

quietly {
eststo clear
eststo act: reg bribe_police median urban age age2 female education _I* _Y* if suspended50==0 & year== int_year & active50==1, cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo inact: reg bribe_police median urban age age2 female education _I* _Y* if suspended50==0 & year== int_year & active50==0, cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)

local varlist median

noisily esttab act inact, ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab act inact  using "median_light_on_bribe_diff_areas.tex",
    style(tex) nostar booktabs b(4) t(3)
	stats(
		mean_depvar r2 N
		, labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)    
	mtitles("Bribe to Police in active areas" "Bribe to Police in non-active areas" )
    keep(`varlist') order(`varlist')
    varlabels(
	median "Median light"
	)
    prehead("\begin{tabular}{l*{2}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.56 ***

quietly  reg mean active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
gen light_sample=1 if e(sample)==1

quietly {
eststo clear
eststo br_coll: reg bribe_police active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0 & year== int_year  & light_sample==1, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace
	estadd scalar p_f = r(p), replace
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo mean_: reg mean active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace 
	estadd scalar p_f = r(p), replace
	summarize mean if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo b_med: reg bribe_police mean urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo b_cont: reg bribe_police active50 inactive50 mean urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace
	estadd scalar p_f = r(p), replace
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo int_: reg bribe_police mean active_mean active50 urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)

local varlist active50 inactive50 mean active_mean

noisily esttab br_coll mean_ b_med b_cont int_, ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab br_coll mean_ b_med b_cont int_  using "light_app_table.tex",
    style(tex) nostar booktabs b(4) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N
		, labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	) 
    mtitles("Bribe to Police" "Mean light" "Bribe to Police" "Bribe to Police" "Bribe to Police" )
    keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	mean "Average light"
	active_mean "Average light $\times$ Active 50 km"
	)
    prehead("\begin{tabular}{l*{5}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.59 ***
quietly {
local depvar "police police_station"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' median urban age age2 female education _I* _Y* if suspended50==0 & year== int_year, cl(cluster)
		summarize `x' if e(sample)==1
		estadd scalar mean_depvar = r(mean)
	eststo `x'_a: reg `x' median urban age age2 female education _I* _Y* if suspended50==0 & year== int_year & active50==1, cl(cluster)
		summarize `x' if e(sample)==1
		estadd scalar mean_depvar = r(mean)
	eststo `x'_i: reg `x' median urban age age2 female education _I* _Y* if suspended50==0 & year== int_year & active50==0, cl(cluster)
		summarize `x' if e(sample)==1
		estadd scalar mean_depvar = r(mean)
}

local varlist median 

noisily esttab police police_station  police_a police_station_a police_i police_station_i, ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab police police_station police_a police_station_a police_i police_station_i using "light_pol.tex",
	style(tex) booktabs nostar b(4) t(3)
	stats(
		mean_depvar r2 N, 
		labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)   
    mtitles("Officer" "Station" "Officer" "Station" "Officer" "Station")
    keep(`varlist') order(`varlist')
    mgroups(
		"All" "Active mine areas" "Non-active mine areas"
		, pattern(1 0 1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	varlabels(
	median "Median light"
	)
    prehead("\begin{tabular}{l*{6}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

restore 

/* Other tables in the online appendix */
/* ----------------------------------- */

*** Table A.1 ***
eststo clear
reg bribe_police active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
qui estpost tab country wave if e(sample)
#delimit ;
esttab using "countriesandwaves.tex",
	cell(b(fmt(0))) unstack noobs booktabs style(tex)
	nonumbers nodepvars replace
    prehead("\begin{tabular}{l*{6}{S}}" "\toprule") 
	posthead(
		"&\multicolumn{1}{l}{2}&
		\multicolumn{1}{l}{2.5}&
		\multicolumn{1}{l}{3}&
		\multicolumn{1}{l}{4}&
		\multicolumn{1}{l}{5}&
		\multicolumn{1}{l}{Total} \\"
		"\midrule"
	)
    postfoot("\bottomrule" "\end{tabular}");
#delimit cr

/* Descriptive statistics for all countries and for South Africa */
*** Table A.2 ***
quietly{
eststo clear
reg bribe_police active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
gen b_s=1 if e(sample)==1

local varlist /// 
kilometers active50 inactive50 active25 inactive25 ///
bribe_police bribe_permit local_corruption corruption_police ///
urban age female education ///

cd "$results"
estpost summarize `varlist' if b_s==1
est save "desk_dep", replace

local varlist /// 
kilometers active50 inactive50 active25 inactive25 ///
bribe_police bribe_permit local_corruption corruption_police ///
urban age female education ///

estpost summarize `varlist' if country=="South Africa" & b_s==1
est save "desk_dep_SA", replace

est use "desk_dep"
eststo dep

est use "desk_dep_SA"
eststo dep_SA

local varlist /// 
kilometers active50 inactive50 active25 inactive25 ///
bribe_police bribe_permit local_corruption corruption_police ///
urban age female education ///

* Manual editing after table generate: 1) remove empty top line. 2) wrap 
* \multicolumn{1}{S[table-format=4.4,output-decimal-marker = {,}]}{NUMBEROFOBSERVATIONS}
* around N, adding "," to separate thousands.
cd "$results"
#delimit;
esttab dep using "desk_dep.tex",
    style(tex) booktabs nonumbers
    cells("mean (fmt(3) pattern(1 1 1 1 1 1)) sd (fmt(3) par pattern(1 1 1 1 1 1)) ") 
	order(`varlist')
    collabels(\multicolumn{1}{c}{Mean} \multicolumn{1}{c}{SD})
	varlabels(
	kilometers "\hspace{3mm} Kilometers"
	active50 "\hspace{3mm} Active 50 km"
	inactive50 "\hspace{3mm} Inactive 50 km"
	active25 "\hspace{3mm} Active 25 km"
	inactive25 "\hspace{3mm} Inactive 25 km"
	bribe_police "\hspace{3mm} -- to the Police" 
	bribe_permit "\hspace{3mm} -- for a Permit"
	local_corruption "\hspace{3mm} Local councilors"
	corruption_police "\hspace{3mm} Police" 
	corruption_teachers "\hspace{3mm} Teachers" 
	urban "\hspace{3mm} Urban"
	age "\hspace{3mm} Age" 
	female "\hspace{3mm} Female" 
	education "\hspace{3mm} Education" 
	,blist(kilometers "\multicolumn{5}{l}{\emph{Mining variables}} \\" 
			bribe_police "\multicolumn{5}{l}{\emph{Dependent variables: Paid a bribe last year }} \\"
			local_corruption "\multicolumn{5}{l}{\emph{Perception of corruption}} \\" 
			urban "\multicolumn{5}{l}{\emph{Control variables}} \\" )
	)
    prehead("\begin{tabular}{l*{12}{S[table-format=4.4]}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr

********* Table A.34 **************

* Manual editing after table generate: 1) remove empty line between Sample groupings and "SD" and "mean". 
* 2) wrap \multicolumn{1}{S[table-format=4.4,output-decimal-marker = {,}]}{NUMBEROFOBSERVATIONS}
* around N, adding "," to separate thousands.
cd "$results"
#delimit;
esttab dep dep_SA using "desk_dep_SA.tex",
    style(tex) booktabs nonumbers
    cells("mean (fmt(3) pattern(1 1 1 1 1 1)) sd (fmt(3) par pattern(1 1 1 1 1 1)) ") 
	mgroups(
		"Total sample" "South Africa"
		, pattern(1 1) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	order(`varlist')
    collabels(\multicolumn{1}{c}{Mean} \multicolumn{1}{c}{SD})
	varlabels(
	kilometers "\hspace{3mm} Kilometers"
	active50 "\hspace{3mm} Active 50 km"
	inactive50 "\hspace{3mm} Inactive 50 km"
	active25 "\hspace{3mm} Active 25 km"
	inactive25 "\hspace{3mm} Inactive 25 km"
	bribe_police "\hspace{3mm} -- to the Police" 
	bribe_permit "\hspace{3mm} -- for a Permit"
	local_corruption "\hspace{3mm} Local councilors"
	corruption_police "\hspace{3mm} Police" 
	corruption_teachers "\hspace{3mm} Teachers" 
	urban "\hspace{3mm} Urban"
	age "\hspace{3mm} Age" 
	female "\hspace{3mm} Female" 
	education "\hspace{3mm} Education" 
	,blist(kilometers "\multicolumn{5}{l}{\emph{Mining variables}} \\" 
			bribe_police "\multicolumn{5}{l}{\emph{Dependent variables: Paid a bribe last year }} \\"
			local_corruption "\multicolumn{5}{l}{\emph{Perception of corruption}} \\" 
			urban "\multicolumn{5}{l}{\emph{Control variables}} \\" )
	)
    prehead("\begin{tabular}{l*{12}{S[table-format=4.4]}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.3 ***
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' dia50 urban age age2 female education _I* _Y* , cl(cl)
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist dia50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar' using "diamonds.tex",
    style(tex) nostar 	
    stats(
		mean_depvar r2 N
		, labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3)
	mtitles("Police" "Permit" "Local Councilors" "Police" ) keep(`varlist') order(`varlist')
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
	varlabels(
	dia50 "At least one diamond mine within 50 km"
	inactive50 "Inactive 50 km"
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
	prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
	postfoot("\bottomrule" "\end{tabular}")
	replace;
#delimit cr
}


*** Table A.4 ***
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' dia50 _I* _Y* , cl(cl)
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist dia50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "diamonds_less_controls_ind.tex",
    style(tex) nostar 	
    stats(
		mean_depvar r2 N
		, labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
	mtitles("Police" "Permit" "Local Councilors" "Police" ) keep(`varlist') order(`varlist')
     mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	dia50 "At least one diamond mine within 50 km"
	inactive50 "Inactive 50 km"
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.5 ***
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' usgs50 urban age age2 female education _I* _Y* , cl(cl)
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist usgs50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "usgs.tex",
    style(tex) nostar 	
    stats(
		mean_depvar r2 N
		, labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
	mtitles("Police" "Permit" "Local Councilors" "Police") keep(`varlist') order(`varlist')
     mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	mine50 "At least one diamond mine within 50 km"
	inactive50 "Inactive 50 km"
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.6 ***
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' usgs50 _I* _Y* , cl(cl)
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist usgs50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2 N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "usgs_less_controls_ind.tex",
    style(tex) nostar 	stats(
		mean_depvar r2 N
		, labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
	mtitles("Police" "Permit" "Local Councilors" "Police" )  keep(`varlist') order(`varlist')
     mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	mine50 "At least one diamond mine within 50 km"
	inactive50 "Inactive 50 km"
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.7 ***
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' oil_cluster urban age age2 female education _I* _Y* , cl(cluster)
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist oil_cluster

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "Oil.tex",
    style(tex) nostar 	stats(
		mean_depvar r2 N
		, labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
	mtitles("Police" "Permit" "Local Councilors" "Police") keep(`varlist') order(`varlist')
     mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	oil_cluster "Onshore oil cluster"
	inactive50 "Inactive 50 km"
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.8 ***
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' oil_cluster _I* _Y*, cl(cluster)
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist oil_cluster

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "Oil_less_controls_ind.tex",
    style(tex) nostar 	stats(
		mean_depvar r2 N
		, labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 			
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
	mtitles("Police" "Permit" "Local Councilors" "Police") keep(`varlist') order(`varlist')
     mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	oil_cluster "Onshore oil cluster"
	inactive50 "Inactive 50 km"
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}
*** Table A.9 ***
quietly {
local depvar "corruption_pr corruption_na"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "placebos_present.tex",
    style(tex) nostar booktabs 	
    stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)    starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
	mtitles("President" "National gov.") keep(`varlist') order(`varlist')
     mgroups(
		"Perceptions of Corruption"
		, pattern(1 0 0 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	active50 " Active 50 km"
	inactive50 " Inactive 50 km"
	active25 " Active 25 km"
	inactive25 " Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}
*** Table A.10 ***
quietly {
local depvar "bribe_school bribe_service bribe_border"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

	#delimit;
	esttab `depvar'  using "bribe_other.tex",
    style(tex) nostar booktabs 	
    stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)    
	starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
    mtitles("School" "Services" "Border crossing") keep(`varlist') order(`varlist')
     mgroups(
		"Bribes"
		, pattern(1 0 0 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	active50 "\ Active 50 km"
	inactive50 "\ Inactive 50 km"
	active25 "\ Active 25 km"
	inactive25 "\ Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr

}
*** Table A.11 ***
quietly {
local depvar "bribe_medical bribe_electio bribe_water bribe_tax "
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

	#delimit;
	esttab `depvar' using "bribe_other2.tex",
    style(tex) nostar booktabs 
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)    
	starlevels(* 0.10 ** 0.05 *** 0.01) b(3) t(3) 
    mtitles("Healthcare" " Election officials" "Water" "Tax officials")
	keep(`varlist') order(`varlist')
    mgroups(
		"Bribes"
		, pattern(1 0 0 0)
	prefix(\multicolumn{@span}{c}{) 
	suffix(}) 
	span 
	erepeat(\cmidrule(lr){@span})
	)
    varlabels(
	active50 "\ Active 50 km"
	inactive50 "\ Inactive 50 km"
	active25 "\ Active 25 km"
	inactive25 "\ Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

/* Sensitivity / robustness */
*** Table A.12 ***
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(_1closestmine)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "cluster_mine_50.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.13
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "No_education.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.14
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 age age2 female _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "No_education_urban.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.15
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50  _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "No_ind_controls.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.16
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50  if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "AET_no_c.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.17
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active25 inactive25 urban age age2 female education _I* _Y* if suspended25==0, cl(cluster)
	test active25-inactive25=0
	estadd scalar difference = _b[active25]-_b[inactive25]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active25 inactive25

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2 N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "baseline_25.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.18
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': ologit `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar' , ///
	keep(`varlist') order(`varlist') stats(r2_p N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "ologit_50.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		r2_p N, 
		labels( 
			"Pseudo R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.19
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
eststo `x': ologit `x' active25 inactive25 urban age age2 female education _I* _Y* if suspended25==0, cl(cluster)
test active25-inactive25=0
estadd scalar difference = _b[active25]-_b[inactive25]
estadd scalar F_t = r(F), replace  
estadd scalar p_f = r(p), replace 
summarize `x' if e(sample)==1
estadd scalar mean_depvar = r(mean)
}

local varlist active25 inactive25

noisily esttab `depvar' , ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "ologit_25.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		r2_p N, 
		labels( 
			"Pseudo R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.20
quietly {
local depvar "bribe_police_dummy bribe_permit_dummy local_corruption_dummy corruption_police_dummy"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "baseline_dummy_50km.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.21
quietly {
set more off
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & (yearssince_active50<10 | (active50==0 & inactive50==0)), cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "baseline_agerestr.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

** Dosage
* Table A.22
preserve
collapse (mean) bribe_police bribe_permit local_corruption corruption_police urban age age2 female education ///
(first) _I* _Y* int_year active50 inactive50 suspended50, by(cluster)

quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "collapsed.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}
restore

* Table A.23
quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 ///
		urban age* female education _I* _Y* ///
		if suspended50==0 & (high_prod==1 | (active50==0 & inactive50==0)) ///
		, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace 
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab, ///
	keep(`varlist') order(`varlist') stats(difference p_f r2 N) starlevels(* 0.10 ** 0.05)

#delimit;
esttab using "dosage_highprod.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.24
quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 ///
		urban age* female education _I* _Y* ///
		if suspended50==0 & (high_prod==0 | (active50==0 & inactive50==0)) ///
		, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace 
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab, ///
	keep(`varlist') order(`varlist') stats(difference p_f r2 N) starlevels(* 0.10 ** 0.05)

#delimit;
esttab using "dosage_lowprod.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}
* Table A.25
quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 ///
		urban age* female education _I* _Y* ///
		if suspended50==0 & (high_value==1 | (active50==0 & inactive50==0)) ///
		, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace 
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50
noisily esttab, ///
	keep(`varlist') order(`varlist') stats(difference p_f r2 N) starlevels(* 0.10 ** 0.05)

#delimit;
esttab using "dosage_highvalue.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.26
quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 ///
		urban age* female education _I* _Y* ///
		if suspended50==0 & (high_value==0 | (active50==0 & inactive50==0)) ///
		, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace 
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab, ///
	keep(`varlist') order(`varlist') stats(difference p_f r2 N) starlevels(* 0.10 ** 0.05)

#delimit;
esttab using "dosage_lowvalue.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.27
quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	reg `x' active50 nactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	eststo `x'
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}
	
local varlist active50 nactive50

noisily esttab, ///
	keep(`varlist') order(`varlist') stats(r2 N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar' using "intensity_n.tex",
    style(tex) booktabs nostar b(3) t(3)
	stats(
		mean_depvar r2 N, 
		labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		fmt(3 3 %10.0fc)
		layout(
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
	)
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
    keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	nactive50 "Number of active 50 km"
	lognactive50 "Log number of active 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.28
quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	reg `x' active50 lognactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	eststo `x'
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 lognactive50

noisily esttab, ///
	keep(`varlist') order(`varlist') stats(r2 N, fmt(2 %10.0fc) layout("@" "@")) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar' using "intensity_log.tex",
    style(tex) booktabs nostar b(3) t(3)
	stats(
		mean_depvar r2 N, 
		labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		fmt(3 3 %10.0fc)
		layout(
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
	)
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
    keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	nactive50 "Number of active 50 km"
	lognactive50 "Log number of active 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.29
gen active50_max1 = nactive50==1
replace active50_max1=. if nactive50>1 // will drop all resp with >1 active mine from reg

quietly {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	eststo `x'_max1: reg `x' active50_max1 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0, cl(cluster)
	test active50_max1`i'-inactive50=0
	estadd scalar difference = _b[active50_max1`i']-_b[inactive50]
	estadd scalar F_t = r(F), replace 
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50_* inactive50
noisily esttab, ///
	keep(`varlist') order(`varlist') stats(difference p_f r2 N) starlevels(* 0.10 ** 0.05)

#delimit;
esttab using "active50_max1.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
	varlabels(
	active50_max1 "\textit{One} Active 50 km"
	inactive50 "Inactive 50 km"
	)
	prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
	postfoot("\bottomrule" "\end{tabular}")
	replace;
#delimit cr
}

* Table A.30-A.33
quietly {
forvalues i = 2/5 {
eststo clear
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	eststo `x'_`i': reg `x' active50_`i' inactive50 urban age age2 female education _I* _Y* ///
		if (nactive50>=`i' | inactive50==1 | (active50==0 & inactive50==0)) & suspended50==0, cl(cluster)
	test active50_`i'-inactive50=0
	estadd scalar difference = _b[active50_`i']-_b[inactive50]
	estadd scalar F_t = r(F), replace 
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50_* inactive50
noisily esttab, ///
	keep(`varlist') order(`varlist') stats(difference p_f r2 N) starlevels(* 0.10 ** 0.05)
	
#delimit;
esttab using "active50_`i'.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
	varlabels(
	active50_`i' "$\geq$`i' Active 50 km"
	inactive50 "Inactive 50 km"
	)
	prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
	postfoot("\bottomrule" "\end{tabular}")
	replace;
#delimit cr
}
}

* Table A.34: see A.2 above

* Table A.35
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if country=="South Africa" & suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "SA_baseline_50.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}


* Table A.36
quietly {
eststo clear
xtset minefixed50
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x in `depvar' {
qui xtreg `x' active50 female educ urban age age2 _I* _Y*  ///
	if suspended50==0 & country=="South Africa" ///
	,cluster(minefixed50) fe
eststo `x'
summarize `x' if e(sample)==1
estadd scalar mean_depvar = r(mean)
}

local varlist active50

noisily esttab `depvar' , ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar' using "SA_fixedeffects.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		 mean_depvar r2 N, 
		labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.37
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & country=="South Africa", cl(_1closestmine)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "cluster_mine_50_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.38
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female _I* _Y* ///
		if suspended50==0 & country=="South Africa", cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "No_education_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.39
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 age age2 female _I* _Y* ///
		if suspended50==0 & country=="South Africa", cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "No_education_urban_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.40
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 _I* _Y* ///
		if suspended50==0 & country=="South Africa", cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar' , ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "No_ind_controls_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.41
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active25 inactive25 urban age age2 female education _I* _Y* ///
		if country=="South Africa" & suspended25==0, cl(cluster)
	test active25-inactive25=0
	estadd scalar difference = _b[active25]-_b[inactive25]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active25 inactive25

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "SA_baseline_25.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.42
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': ologit `x' active50 inactive50 urban age age2 female education _I* _Y* ///
	if suspended50==0 & country=="South Africa", cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar' , ///
	keep(`varlist') order(`varlist') stats(r2_p N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "ologit_50_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		r2_p N, 
		labels( 
			"Pseudo R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.43
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': ologit `x' active25 inactive25 urban age age2 female education _I* _Y* ///
		if suspended25==0 & country=="South Africa", cl(cluster)
	test active25-inactive25=0
	estadd scalar difference = _b[active25]-_b[inactive25]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active25 inactive25

noisily esttab `depvar' , ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "ologit_25_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		r2_p N, 
		labels( 
			"Pseudo R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active25 "Active 25 km"
	inactive25 "Inactive 25 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}


* Table A.44
quietly {
local depvar "bribe_police_dummy bribe_permit_dummy local_corruption_dummy corruption_police_dummy"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & country=="South Africa", cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "baseline_dummy_50km_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.45
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & country=="South Africa" & (yearssince_active50<10 | (active50==0 & inactive50==0)), cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "baseline_agerestr_SA_rob.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.46
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if country!="South Africa" & suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "baseline_50_not_sa.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.47
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if ///
		suspended50==0 & rich_country==1, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "rich_countries.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.48

quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & rich_country==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "poor_countries.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.49
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & corrupt_country==1, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "corrupt_countries.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.50
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & corrupt_country==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "non_corrupt_countries.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.51
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & democratic_country==1, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "democratic_countries.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

* Table A.52

quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* ///
		if suspended50==0 & democratic_country==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

local varlist active50 inactive50

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "non_democratic_countries.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Police" "Permit" "Local Councilors" "Police" )
	mgroups(
		"Bribes" "Perceptions of Corruption"
		, pattern(1 0 1 0) 
		prefix(\multicolumn{@span}{c}{) 
		suffix(}) 
		span 
		erepeat(\cmidrule(lr){@span})
	)
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	inactive50 "Inactive 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.53 ***
quietly {
eststo clear
local ivlist "nwithin100_200 d_nwithin100_200 sactive_nwithin priceXpresence"
foreach x in `ivlist' {
	eststo `x': ivreg2 bribe_police (active50 = `x') ///
		urban age* female education _I* _Y* if suspended50==0 ///
		, cl(cluster) savefirst savefprefix(first) noid
	summarize bribe_police if e(sample)
	estadd scalar mean_depvar = r(mean)
	est restore firstactive50
	eststo first_`x'
}
local ivlist "nwithin100_200 d_nwithin100_200 sactive_nwithin priceXpresence"

local varlist active50
noisily esttab `ivlist', ///
	keep(`varlist') order(`varlist') stats(r2 N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `ivlist' using "iv_maintable.tex", nonumbers
    style(tex) booktabs alignment(l)
	stats(
		mean_depvar N, 
		labels(
			"Mean dep. var" 
			"No. of respondents"
		)
		layout(
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 %10.0fc)
	)
	nostar b(3) t(3)
	mlabels("Bribe to police" "Bribe to police" "Bribe to police" "Bribe to police",
		span prefix(\multicolumn{@span}{l}{) suffix(})
	)
    keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule" "\textbf{A: Second stage}") 
	posthead("\midrule")
    postfoot("\midrule")
    replace;
#delimit cr

local ivlist "nwithin100_200 d_nwithin100_200 sactive_nwithin priceXpresence"

noisily esttab first_*, ///
	keep(`ivlist') order(`ivlist') stats(r2_a N) starlevels(* 0.10 ** 0.05) 

* Append the first stage to the table
local varlist `ivlist'
#delimit;
esttab first_*  using "iv_maintable.tex", nonumbers
    style(tex) booktabs  alignment(l)
	stats(
		r2_a N, 
		labels(
			"R-squared" 
			"No. of respondents"
		) 
		layout(
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""'
		)
		fmt(3 %10.0fc)
	)
	nostar  b(3) t(3)
	mlabels("Mines 100-200km" "$>$0 mines 100-200km" "Share active" "Price interaction"
		,span prefix(\multicolumn{@span}{l}{) suffix(})
	)    
	keep(`varlist') order(`varlist')
    varlabels(
	active50 "Active 50 km"
	)
    prehead("\textbf{B: First stage}") 
	posthead("\midrule")
    postfoot("\bottomrule" "\end{tabular}")
    append;
#delimit cr
}


*** Table A.54 ***
quietly { 
local depvar "bribe_police"
eststo clear
foreach x of local depvar {
eststo `x': reg `x' active200_not100 inactive200_not100 urban age age2 female education _I* _Y* if suspended50==0 ///
	, cl(cluster)
test active200_not100-inactive200_not100=0
estadd scalar difference = _b[active200_not100]-_b[inactive200_not100]
estadd scalar F_t = r(F), replace 
estadd scalar p_f = r(p), replace 
summarize `x' if e(sample)==1
estadd scalar mean_depvar = r(mean)
}

local varlist active200_not100 inactive200_not100

noisily esttab `depvar', ///
	keep(`varlist') order(`varlist') stats(r2 difference p_f N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab `depvar'  using "iv_exclrestr.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2_a N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
	mtitles("Bribe to Police")
	keep(`varlist') order(`varlist')
    varlabels(
	active200_not100 "Active within 200 km, but not within 100 km"
	inactive200_not100 "Inactive within 200 km, but not within 100 km"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.55 ***
* See below Table 3 above.
***** Table A.56 ****
* See below Table 3 above.

*** Table A.57 ***
eststo clear
quietly {

eststo p_b: reg bribe_police police urban age age2 female education _I* _Y* if suspended50==0 , cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo ps_b: reg bribe_police police_station urban age age2 female education _I* _Y* if suspended50==0 , cl(cluster)
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)

local varlist police police_station

noisily esttab p_b ps_b , ///
	keep(`varlist') order(`varlist') stats(r2  N) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab p_b ps_b  using "pol_bribe.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		mean_depvar r2 N, 
		labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 %10.0fc)
	)      
	mtitles("Bribe to Police" "Bribe to Police" )
    keep(`varlist') order(`varlist')
    varlabels(
	police_station "Police station in area"
	police "Police in area"
	)
    prehead("\begin{tabular}{l*{2}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.58 ***
eststo clear

quietly {
local depvar "police_station police"
eststo clear
foreach x of local depvar {
	eststo `x': reg `x' active50 inactive50 urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize `x' if e(sample)==1
	estadd scalar mean_depvar = r(mean)
}

eststo p_br: reg bribe_police active50 inactive50 police urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)
eststo ps_br: reg bribe_police active50 inactive50 police_station urban age age2 female education _I* _Y* if suspended50==0, cl(cluster)
	test active50-inactive50=0
	estadd scalar difference = _b[active50]-_b[inactive50]
	estadd scalar F_t = r(F), replace  
	estadd scalar p_f = r(p), replace 
	summarize bribe_police if e(sample)==1
	estadd scalar mean_depvar = r(mean)


local varlist active50 inactive50 police_station police

noisily esttab police_station police p_br ps_br, ///
	keep(`varlist') order(`varlist') stats(r2  N difference p_f) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab police_station police p_br ps_br  using "pol_app.tex",
	style(tex) booktabs nostar b(3) t(3)
	stats(
		difference F_t p_f mean_depvar r2 N, 
		labels(
			"Difference in differences" 
			"F-test: active-inactive=0" 
			"p-value, F-test" 
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		) 
		layout(
			"@" 
			"@" 
			"@" 
			"@" 
			"@"
			`""\multicolumn{1}{S[output-decimal-marker = {,}]}{@}""' 
		)
		fmt(3 3 3 3 3 %10.0fc)
	)  
    mtitles("Station" "Officer" "Bribe to Police" "Bribe to Police" )
    keep(`varlist') order(`varlist')
    varlabels(
	active50 " Active 50 km"
	inactive50 " Inactive 50 km"
	police_station "Police station in area"
	police "Police in area"
	)
    prehead("\begin{tabular}{l*{4}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}


*** Nationwide, collapsed ***
use "mininglocal_nw.dta", clear

*** Table A.60 ***
eststo clear
quietly {
reg wbgi_cce opened _Y*, cl(ccode)
	eststo ols_wgi
	summarize wbgi_cce if e(sample)==1
	estadd scalar mean_depvar = r(mean)
xtreg wbgi_cce opened _Y*, fe  cl(ccode)
	eststo fe_wgi
	summarize wbgi_cce if e(sample)==1
	estadd scalar mean_depvar = r(mean)

local varlist opened
noisily esttab ols_* fe_*, ///
	keep(`varlist') order(`varlist') stats(r2 N) indicate("Year fixed" = _Y*) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab ols_* fe_* using "nationwide_wbgi.tex", 
    style(tex) booktabs nostar b(3) t(3)
	stats(
		mean_depvar r2 N, 
		labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations" 
		)
		layout(
			"@" 
			"@" 
			"\multicolumn{1}{c}{@}"
		)
		fmt(3 3 %10.0fc)
	)
	mgroups(
		"WBGI Control of corruption"
		, pattern(1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})
	)
	mtitles(
		"OLS" "Fixed effects"
	)
    keep(`varlist') order(`varlist')
    varlabels(
	opened "No. of mines opened"
	)
    prehead("\begin{tabular}{l*{2}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

*** Table A.61 ***
eststo clear
quietly {
local depvar "bribe_police bribe_permit local_corruption corruption_police"
foreach x of local depvar {
	qui reg `x' opened _Y*
		eststo ols_`x'
		summarize `x' if e(sample)==1
		estadd scalar mean_depvar = r(mean)
	qui xtreg `x' opened _Y*, fe 
		eststo fe_`x'
		summarize `x' if e(sample)==1
		estadd scalar mean_depvar = r(mean)
}

local varlist opened
noisily esttab, ///
	keep(`varlist') order(`varlist') stats(r2 N) indicate("Year fixed" = _Y*) starlevels(* 0.10 ** 0.05) 

#delimit;
esttab ols_* fe_* using "nationwide_ab.tex", 
    style(tex) booktabs nostar b(3) t(3)     
	stats(
		mean_depvar r2 N, 
		labels(
			"Mean dep. var" 
			"R-squared"
			"No. of observations"
		)
		layout(
			"@" 
			"@" 
			"\multicolumn{1}{c}{@}"
		)
		fmt(3 3 %10.0fc)
	)
	mgroups(
		"Bribe to Police" "Bribe for Permit" "Local Corruption" "Police Corruption"
		, pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})
	)
	mtitles(
		"OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE" 
	)
    keep(`varlist') order(`varlist')
    varlabels(
	opened "No. of mines opened"
	)
    prehead("\begin{tabular}{l*{8}{S}}" "\toprule") posthead(\midrule)
    postfoot("\bottomrule" "\end{tabular}")
    replace;
#delimit cr
}

