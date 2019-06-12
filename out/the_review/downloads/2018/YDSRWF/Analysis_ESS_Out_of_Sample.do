*************** REPLICATION CODE FOR CONSTRUCTION OF MAIN DATASET FROM THE BASE ESS DATA



*** Set working directory
capture cd "????"



*** Extract and code relevant variables from the raw ESS datasets for all countries with a noted compulsory education reform
quietly foreach x in "Austria" "Belgium" "Denmark" "Finland" "France" "Germany" "Greece" ///
	"Ireland" "Italy" "Netherlands" "Portugal" "Spain" "Sweden" "UK" {
	use "ESS_`x'", clear
	gen year = 2002 if essround == 1
	replace year = 2004 if essround == 2 
	replace year = 2006 if essround == 3 
	replace year = 2008 if essround == 4 
	replace year = 2010 if essround == 5 
	replace year = 2012 if essround == 6 
	replace year = 2014 if essround == 7
	label var year "Survey year"
	gen yearat8 = yrbrn + 8
	gen yearat9 = yrbrn + 9
	gen yearat10 = yrbrn + 10
	gen yearat11 = yrbrn + 11
	gen yearat12 = yrbrn + 12
	gen yearat13 = yrbrn + 13
	gen yearat14 = yrbrn + 14
	gen yearat15 = yrbrn + 15
	foreach n of numlist 8(1)15 {
		label var yearat`n' "Year respondent was aged `n'"
	}
	gen plus5 = 0 if eduyrs!=.
	replace plus5 = 1 if eduyrs > 4
	gen plus6 = 0 if eduyrs!=.
	replace plus6 = 1 if eduyrs > 5
	gen plus7 = 0 if eduyrs!=.
	replace plus7 = 1 if eduyrs > 6
	gen plus8 = 0 if eduyrs!=.
	replace plus8 = 1 if eduyrs > 7
	gen plus9 = 0 if eduyrs!=.
	replace plus9 = 1 if eduyrs > 8
	gen plus10 = 0 if eduyrs!=.
	replace plus10 = 1 if eduyrs > 9
	gen plus11 = 0 if eduyrs!=.
	replace plus11 = 1 if eduyrs > 10
	gen plus12 = 0 if eduyrs!=.
	replace plus12 = 1 if eduyrs > 11
	gen plus13 = 0 if eduyrs!=.
	replace plus13 = 1 if eduyrs > 12
	gen plus14 = 0 if eduyrs!=.
	replace plus14 = 1 if eduyrs > 13
	foreach n of numlist 5(1)14 {
		label var plus`n' "Indicator for respondent obtaining `n' years of schooling"
	}
	save "`x'_clean", replace
}



*** Combine these datasets in a single file, duplicating the UK dataset to account for the two separate reforms analyzed (that only apply to GB, not UK)
clear all
use "UK_clean.dta", clear
g second_reform = 1
quietly foreach x in "Austria" "Belgium" "Denmark" "Finland" "France" "Germany" "Greece" ///
	"Ireland" "Italy" "Netherlands" "Portugal" "Spain" "Sweden" "UK" {
	append using "`x'_clean"
	erase "`x'_clean.dta"
}
replace second_reform = 0 if second_reform==.
label var second_reform "Indicator for GB's second reform"



*** Apply code to define anti-immigrant parties
quietly do "Coding_Far_Right_Parties.do"



*** Define reform treatments
g treatment = 0 if yrbrn!=.
replace treatment = 1 if yearat14>=1962 & cntry=="AT"
replace treatment = 1 if yearat15>=1972 & cntry=="GB" & second_reform==1 & regiongb!=12
replace treatment = 1 if yearat14>=1947 & cntry=="GB" & second_reform==0 & regiongb!=12
replace treatment = 1 if yearat15>=1974 & cntry=="NL"
replace treatment = 1 if yearat14>=1967 & cntry=="FR"
replace treatment = 1 if yearat14>=1983 & cntry=="BE"
replace treatment = 1 if yearat14>=1958 & cntry=="DK"
replace treatment = 1 if yearat14>=1967 & cntry=="IE"
replace treatment = 1 if yearat11>=1963 & cntry=="IT"
replace treatment = 1 if yearat12>=1969 & cntry=="ES"
replace treatment = 1 if yearat14>=1965 & cntry=="SE"
replace treatment = 1 if yearat12>=1975 & cntry=="GR"
replace treatment = 1 if yearat8>=1964 & cntry=="PT"
replace treatment = 1 if yearat13>=1969 & regionfi==1 & cntry=="FI"
replace treatment = 1 if yearat13>=1968 & regionfi==2 & cntry=="FI"
replace treatment = 1 if yearat13>=1966 & regionfi==3 & cntry=="FI"
replace treatment = 1 if yearat13>=1965 & regionfi==4 & cntry=="FI"
replace treatment = 1 if yearat13>=1964 & regionfi==5 & cntry=="FI"
replace treatment = 1 if yearat14>=1955 & regionde==1 & cntry=="DE"
replace treatment = 1 if yearat14>=1948 & regionde==2 & cntry=="DE"
replace treatment = 1 if yearat14>=1961 & regionde==3 & cntry=="DE"
replace treatment = 1 if yearat14>=1957 & regionde==4 & cntry=="DE"
replace treatment = 1 if yearat14>=1967 & regionde==5 & cntry=="DE"
replace treatment = 1 if yearat14>=1967 & regionde==6 & cntry=="DE"
replace treatment = 1 if yearat14>=1967 & regionde==7 & cntry=="DE"
replace treatment = 1 if yearat14>=1967 & regionde==8 & cntry=="DE"
replace treatment = 1 if yearat14>=1969 & regionde==9 & cntry=="DE"
replace treatment = 1 if yearat14>=1963 & regionde==10 & cntry=="DE"
replace treatment = 1 if yearat14>=1990 & regionde==12 & cntry=="DE"
replace treatment = 1 if yearat14>=1990 & regionde==13 & cntry=="DE"
replace treatment = 1 if yearat14>=1990 & regionde==14 & cntry=="DE"
replace treatment = 1 if yearat14>=1990 & regionde==15 & cntry=="DE"
replace treatment = 1 if yearat14>=1990 & regionde==16 & cntry=="DE"
replace treatment = . if regionde>=11 & regionde<=16 & cntry=="DE"
label var treatment "Indicator for respondents affected by a country's schooling reform"



*** Define the running variable for each reform, centering on the reform date
g running = yearat15 - 1972 if cntry=="GB" & second_reform==1 & regiongb!=12
replace running = yearat14 - 1947 if cntry=="GB" & second_reform==0 & regiongb!=12
replace running = yearat14 - 1962 if cntry=="AT"
replace running = yearat15 - 1974 if cntry=="NL"
replace running = yearat14 - 1967 if cntry=="FR"
replace running = yearat14 - 1983 if cntry=="BE"
replace running = yearat14 - 1958 if cntry=="DK"
replace running = yearat14 - 1967 if cntry=="IE"
replace running = yearat11 - 1963 if cntry=="IT"
replace running = yearat12 - 1969 if cntry=="ES"
replace running = yearat14 - 1965 if cntry=="SE"
replace running = yearat12 - 1975 if cntry=="GR"
replace running = yearat8 - 1964 if cntry=="PT"
replace running = yearat13 - 1969 if regionfi==1 & cntry=="FI"
replace running = yearat13 - 1968 if regionfi==2 & cntry=="FI"
replace running = yearat13 - 1966 if regionfi==3 & cntry=="FI"
replace running = yearat13 - 1965 if regionfi==4 & cntry=="FI"
replace running = yearat13 - 1964 if regionfi==5 & cntry=="FI"
replace running = yearat14 - 1955 if regionde==1 & cntry=="DE"
replace running = yearat14 - 1948 if regionde==2 & cntry=="DE"
replace running = yearat14 - 1961 if regionde==3 & cntry=="DE"
replace running = yearat14 - 1957 if regionde==4 & cntry=="DE"
replace running = yearat14 - 1967 if regionde==5 & cntry=="DE"
replace running = yearat14 - 1967 if regionde==6 & cntry=="DE"
replace running = yearat14 - 1967 if regionde==7 & cntry=="DE"
replace running = yearat14 - 1967 if regionde==8 & cntry=="DE"
replace running = yearat14 - 1969 if regionde==9 & cntry=="DE"
replace running = yearat14 - 1963 if regionde==10 & cntry=="DE"
label var running "Number of cohorts either side of schooling reform"



*** Label country-reforms
g reform = "GB (1947)" if cntry=="GB" & cntry!="" & yearat14!=. & regiongb!=12 & second_reform==0
replace reform = "GB (1972)" if cntry=="GB" & cntry!="" & yearat14!=. & regiongb!=12 & second_reform==1
replace reform = "DK (1958)" if cntry=="DK" & cntry!="" & yearat14!=.
replace reform = "FR (1967)" if cntry=="FR" & cntry!="" & yearat14!=.
replace reform = "NL (1974)" if cntry=="NL" & cntry!="" & yearat14!=.
replace reform = "SE (1962)" if cntry=="SE" & cntry!="" & yearat14!=.
replace reform = "BE (1983)" if cntry=="BE" & cntry!="" & yearat14!=.
replace reform = "DE (varies by region)" if cntry=="DE" & cntry!="" & yearat14!=.
replace reform = "FI (varies by region)" if cntry=="FI" & cntry!="" & yearat14!=.
replace reform = "IE (1967)" if cntry=="IE" & cntry!="" & yearat14!=.
replace reform = "IT (1963)" if cntry=="IT" & cntry!="" & yearat14!=.
replace reform = "ES (1969)" if cntry=="ES" & cntry!="" & yearat14!=.
replace reform = "AT (1962)" if cntry=="AT" & cntry!="" & yearat14!=.
replace reform = "GR (1975)" if cntry=="GR" & cntry!="" & yearat14!=.
replace reform = "PT (1964)" if cntry=="PT" & cntry!="" & yearat14!=.
label var reform "Country-reform"



*** Apply age and year of birth restrictions
keep if age >= 30
keep if yearat15 >= 1930



*** Drop if cohort is not known
drop if yearat15==.



*** Recode the education variable to cap at 13 years (the point after which secondary schooling ends in countries 
*** with the longest education systems, and the point at which reforms no longer increase education levels - see below)
g total_eduyrs = eduyrs
label var total_eduyrs "Years of education (total)"
replace eduyrs = 13 if eduyrs>13



*** Demean years of completed education [necessary for RD estimator below]
g eduyrs_actual = eduyrs
label var eduyrs_actual "Years of education (capped at 13)"
sum eduyrs, det
replace eduyrs = eduyrs - `r(mean)'



*** Figure A1: Years of completed schooling among students who completed at least the minimum years of schooling required by the reform in cases excluded from our analysis (third-order polynomials either side of the reform)
quietly foreach x in "PT (1964)" "ES (1969)" "AT (1962)" "DE (varies by region)" "FI (varies by region)" "IE (1967)" "IT (1963)" "GR (1975)" "BE (1983)" {
	di "******************** Reform = `x' **********************"
	foreach y in eduyrs_actual {
		rdplot `y' running if reform=="`x'", c(0) p(3) lowerend(-20) upperend(19) numbinl(20) numbinr(20) graph_options(graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ///
			title("`x'") ytitle("Years of completed schooling") xtitle("Cohort relative to reform") legend(off) ylabel(#3))
		graph save Graph "g_`y'_`x'.gph", replace
	}
}

gr combine "g_eduyrs_actual_AT (1962).gph" "g_eduyrs_actual_BE (1983).gph" "g_eduyrs_actual_FI (varies by region).gph" "g_eduyrs_actual_DE (varies by region).gph" "g_eduyrs_actual_GR (1975).gph" "g_eduyrs_actual_IE (1967).gph" "g_eduyrs_actual_IT (1963).gph" "g_eduyrs_actual_PT (1964).gph" "g_eduyrs_actual_ES (1969).gph", rows(3) cols(3) ///
	subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "no_FS_years.gph", replace

quietly foreach x of varlist plus8 plus9 plus11 eduyrs_actual {
	foreach x in "g_`y'_GR (1975).gph" "g_`y'_IT (1963).gph" "g_`y'_IE (1967).gph" "g_`y'_AT (1962).gph" "g_`y'_FI (varies by region).gph" "g_`y'_DE (varies by region).gph" "g_`y'_BE (1983).gph" "g_`y'_PT (1964).gph" "g_`y'_ES (1969).gph" {
		capture erase "`x'"
	}
}



*** Keep d'Hombres and Nunziati countries with larger samples
drop if cntry=="IE" | cntry=="AT" | cntry=="DK" | cntry=="FR" | cntry=="GB" | cntry=="NL" | cntry=="SE"



*** Re-demean years of completed education in the final sample of reforms
drop eduyrs
g eduyrs = eduyrs_actual
sum eduyrs, det
replace eduyrs = eduyrs - `r(mean)'
label var eduyrs "Demeaned years of education (capped at 13)"



*** Tertiary education indicator
g any_tertiary = edulvla==5 if edulvla<55
label var any_tertiary "Indicator for receiving any tertiary education"



*** Create binary indicators
tab essround, g(round_)
g female = gndr==2 if gndr!=.
quietly foreach x of varlist blgetmg facntr mocntr {
	replace `x' = `x'-1
}



*** Generate anti-immigration attitude outcome variables

* Against immigration: "OR" survey logic versions
g anti_immi1_or = imsmetn == 4 | imdfetn == 4 | impcntr == 4 if imsmetn!=. & impcntr!=. & impcntr!=.
g anti_immi2_or = imsmetn > 2 | imdfetn > 2 | impcntr > 2 if imsmetn!=. & impcntr!=. & impcntr!=.

* Against immigration: "AND" survey logic versions
g anti_immi1_and = imsmetn == 4 & imdfetn == 4 & impcntr == 4 if imsmetn!=. & impcntr!=. & impcntr!=.
g anti_immi2_and = imsmetn > 2 & imdfetn > 2 & impcntr > 2 if imsmetn!=. & impcntr!=. & impcntr!=.

* Against immigration: "AVERAGE" survey logic versions
g anti_immi1_ave = ( (imsmetn == 4) + (imdfetn == 4) + (impcntr == 4) ) / 3 if imsmetn!=. & impcntr!=. & impcntr!=.
g anti_immi2_ave = ( (imsmetn > 2) + (imdfetn > 2) + (impcntr > 2) ) /3 if imsmetn!=. & impcntr!=. & impcntr!=.

* National preference
g nat_pref = (imdfetn > imsmetn) & (impcntr > imsmetn) if imsmetn!=. & impcntr!=. & impcntr!=.

* Liveability: imbgeco imueclt imwbcnt, and index of the three (then reverse to make it anti-immigrant)
sum imbgeco imueclt imwbcnt
alpha imbgeco imueclt imwbcnt, gen(immi) std
replace immi = -immi

* Binary outcomes for each variable
quietly foreach x of varlist imdfetn imsmetn impcntr {
	g `x'_dummy = `x'>=3 if `x'!=.
	g `x'_dummy_strong = `x'==4 if `x'!=.
}
quietly foreach x of varlist imbgeco imueclt imwbcnt {
	g `x'_dummy = `x'<5 if `x'!=.
}



*** Generate close to far right scale
g close_far_right_scale = 0 if close_far_right!=.
replace close_far_right_scale = 5 - prtdgcl if close_far_right==1



*** Clean pre-treatment parent education variables
g mother_secondary = edulvlma>=2 if edulvlma>=0 & edulvlma<=5
g father_secondary = edulvlfa>=2 if edulvla>=0 & edulvlfa<=5



*** Clean variables used for exclusion restriction tests
g live_with_partner = partner==1 if partner!=.
g never_married = maritalb==6 if maritalb!=.
g ever_divorced = dvrcdeva==1 if dvrcdeva!=.
g child_at_home = chldhm==1 if chldhm!=.
g ever_child_at_home = chldhhe==1 if chldhhe!=.



*** Standardize other continuous variables (neccessary for RD estimator)
replace imbgeco = - imbgeco 
replace imueclt = - imueclt 
replace imwbcnt = - imwbcnt
quietly foreach x of varlist imdfetn imsmetn impcntr imbgeco imueclt imwbcnt close_far_right_scale gincdif lrscale edulvlfa edulvlma {
	egen `x'_s = std(`x')
	drop `x'
	rename `x'_s `x'
}



*** Overall immigration scale: standardizing across countries
alpha anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right, g(scale) std
alpha imdfetn imsmetn impcntr imbgeco imueclt imwbcnt close_far_right_scale, g(cont_scale) std

factor anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right, ipf
predict factor, bartlett



*** Overall immigration scale: standardizing within countries and aggregating
g scale_within = .
g cont_scale_within = .
g factor_within = .
foreach x in "BE (1983)" "DE (varies by region)" "FI (varies by region)" "GR (1975)" "IT (1963)" {
	local X = subinstr("`x'", " ", "", .)
	local X = subinstr("`X'", "(", "", .)
	local X = subinstr("`X'", ")", "", .)
	alpha anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right if reform=="`x'", g(scale_`X') std
	replace scale_within = scale_`X' if scale_within==.
	alpha imdfetn imsmetn impcntr imbgeco imueclt imwbcnt close_far_right_scale if reform=="`x'", g(cont_scale_`X') std
	replace cont_scale_within = cont_scale_`X' if cont_scale_within==.
	factor anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right if reform=="`x'", ipf
	predict factor_within_`X', bartlett
	replace factor_within = factor_within_`X' if factor_within==.
	drop scale_`X' cont_scale_`X' factor_within_`X'
}
foreach x in "ES (1969)" "PT (1964)" {
	local X = subinstr("`x'", " ", "", .)
	local X = subinstr("`X'", "(", "", .)
	local X = subinstr("`X'", ")", "", .)
	alpha anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right if reform=="`x'", g(scale_`X') std
	replace scale_within = scale_`X' if scale_within==.
	alpha imdfetn imsmetn impcntr imbgeco imueclt imwbcnt close_far_right_scale if reform=="`x'", g(cont_scale_`X') std
	replace cont_scale_within = cont_scale_`X' if cont_scale_within==.
	factor anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy if reform=="`x'", ipf
	predict factor_within_`X', bartlett
	replace factor_within = factor_within_`X' if factor_within==.
	drop scale_`X' cont_scale_`X' factor_within_`X'
}



*** Label variables
label var anti_immi1_or "Anti-immigration (none only)"
label var anti_immi2_or "Anti-immigration (none or few)"
label var anti_immi1_and "Strongly anti-immigrant (and)"
label var anti_immi2_and "Weakly anti-immigrant (and)"
label var anti_immi1_ave "Strongly anti-immigrant (average)"
label var anti_immi2_ave "Weakly anti-immigrant (average)"
label var imbgeco_dummy "Immigration is bad for the economy"
label var imueclt_dummy "Immigration undermines local culture"
label var imwbcnt_dummy "Immigration reduces local liveability"
label var factor "Anti-immigration factor (across-country)"
label var factor_within "Anti-immigration factor (within-country)"
label var scale "Anti-immigration scale (across-country)"
label var scale_within "Anti-immigration scale (within-country)"
label var cont_scale "Continuous anti-immigration scale (across-country)"
label var cont_scale_within "Continuous anti-immigration scale (within-country)"
label var blgetmg "Ethnic minority"
label var facntr "Father born in country"
label var edulvlfa "Father education level"
label var father_secondary "Father has secondary education"
label var mother_secondary "Mother has secondary education"
label var mocntr "Mother born in country"
label var edulvlma "Mother education level"
label var imdfetn "Allow fewer immigrants of different race/ethnic group"
label var imsmetn "Allow fewer immigrants of same race/ethnic group"
label var impcntr "Allow fewer immigrants from poorer countries"
label var imbgeco "Immigration is bad for the economy"
label var imueclt "Immigration undermines local culture"
label var imwbcnt "Immigration reduces local liveability"
label var close_far_right "Feel close to far right"
label var close_far_right_scale "Closeness to far right scale"
label var live_with_partner "Live with partner"
label var never_married "Never married or entered a civil partnership"
label var ever_divorced "Never divorced or ended a civil partnership"
label var child_at_home "Currently at least one child at home"
label var ever_child_at_home "At least one child has lived at home"



*** Keep main variables
keep cntry year reform running eduyrs_actual eduyrs plus6 plus7 plus8 plus9 plus10 plus11 plus12 plus13 any_tertiary ///
	anti_immi1_* anti_immi2_* imdfetn* imsmetn* impcntr* close_far_right scale scale_within imbgeco* imueclt* imwbcnt* close_far_right_scale cont_scale cont_scale_within factor factor_within ///
	female blgetmg facntr father_secondary mocntr mother_secondary round_* ///
	live_with_partner never_married ever_divorced child_at_home ever_child_at_home ipeqopt ipudrst freehms euftf


	
*** Create list of main outcomes
global main_outcomes "anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy close_far_right scale scale_within"
global continuous_outcomes "imdfetn imsmetn impcntr imbgeco imueclt imwbcnt close_far_right_scale cont_scale cont_scale_within"
global main_outcomes_minus_far_right "anti_immi1_or anti_immi2_or imbgeco_dummy imueclt_dummy imwbcnt_dummy scale scale_within"



*** Create log file for results
log using "Results - Out of Sample.smcl", replace



*** Table A1: The effect of compulsory education on years of completed schooling and anti-immigration attitudes, in countries included by d’Hombres and Nunziata (2016) but removed from our sample due to their weak first stage
local j=1
quietly foreach x in "BE (1983)" "DE (varies by region)" "GR (1975)" "IT (1963)" {
	matrix ALL_RF_`j' = J(6,9,0)
	matrix rownames ALL_RF_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF_`j' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	noisily di "********************  Reform = `x'  **********************"
	foreach y of varlist eduyrs $main_outcomes {
		local i=`i'+1
		rdrobust `y' running if reform=="`x'", c(0)
		matrix ALL_RF_`j'[1,`i'] = e(tau_cl)
		matrix ALL_RF_`j'[2,`i'] = e(se_cl)
		matrix ALL_RF_`j'[3,`i'] = e(pv_cl)
		matrix ALL_RF_`j'[5,`i'] = e(N_l) + e(N_r)
		matrix ALL_RF_`j'[4,`i'] = floor(e(h_bw))
		sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
		matrix ALL_RF_`j'[6,`i'] = `r(mean)'
		if `i'==1 {
			sum eduyrs_actual if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_`j'[6,`i'] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}
local j=1
quietly foreach x in "FI (varies by region)" "PT (1964)" "ES (1969)" {
	matrix ALL_RF_`j' = J(6,9,0)
	matrix rownames ALL_RF_`j' = "Reform" "SE" "p-value" "Bandwidth" "Observations" "Outcome mean"
	matrix colnames ALL_RF_`j' = "(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)"
	local i=0
	noisily di "********************  Reform = `x'  **********************"
	foreach y of varlist eduyrs $main_outcomes_minus_far_right {
		local i=`i'+1
		if `i'>=1 & `i'<=6 {
			rdrobust `y' running if reform=="`x'", c(0)
			matrix ALL_RF_`j'[1,`i'] = e(tau_cl)
			matrix ALL_RF_`j'[2,`i'] = e(se_cl)
			matrix ALL_RF_`j'[3,`i'] = e(pv_cl)
			matrix ALL_RF_`j'[5,`i'] = e(N_l) + e(N_r)
			matrix ALL_RF_`j'[4,`i'] = floor(e(h_bw))
			sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_`j'[6,`i'] = `r(mean)'
			if `i'==1 {
				sum eduyrs_actual if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
				matrix ALL_RF_`j'[6,`i'] = `r(mean)'
			}
		}
		if `i'==7 | `i'==8 {
			rdrobust `y' running if reform=="`x'", c(0)
			matrix ALL_RF_`j'[1,`i'+1] = e(tau_cl)
			matrix ALL_RF_`j'[2,`i'+1] = e(se_cl)
			matrix ALL_RF_`j'[3,`i'+1] = e(pv_cl)
			matrix ALL_RF_`j'[5,`i'+1] = e(N_l) + e(N_r)
			matrix ALL_RF_`j'[4,`i'+1] = floor(e(h_bw))
			sum `y' if reform=="`x'" & running>=-floor(e(h_bw)) & running<=floor(e(h_bw))
			matrix ALL_RF_`j'[6,`i'+1] = `r(mean)'
		}
	}
	noisily estout matrix(ALL_RF_`j', fmt("3 3 4 0 0 2")), style(tex)
	local j=`j'+1
}



log close
