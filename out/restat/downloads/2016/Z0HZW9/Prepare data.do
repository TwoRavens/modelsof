


// ------------------------------------------------------------------------ // 
//
//		Prepare data set
//
//		"Richer (and Holier) Than Thou? The Impact of Relative Income
//		Improvements on Demand for Redistribution"
//
// ------------------------------------------------------------------------ // 




// ------------------ Variables for the main paper ------------------ //


gen bias = perceived - position
gen nbias = (bias <- 10) if bias!=.
gen pbias = (bias > 10) if bias!=.
gen nobias = (pbias == 0 & nbias == 0 & perceived!=.)

// Difference between stated and actual income
gen diffyp = 100 * (F17_ink - cfviki10) / cfviki10 if cfviki10!=. & F17_ink!=.


// Outcome variables
gen against_redist = (f02 <= 4) if f02!=.
gen cons_party = (f09 == 6) if f09!=.
gen decrease_tax = (f07 < 5) if f07!=.
gen effort = F13


// Outcome Index
foreach x in against_redist cons_party decrease_tax {
	tabstat `x' if t == 0, s(mean sd) save
	matrix M = r(StatTotal)
	scalar controlmean = M[1,1]
	scalar controlsd = M[2,1]
	gen z`x' = (`x' - controlmean) / controlsd
}
egen outcome_index = rowmean(zagainst_redist zcons_party zdecrease_tax)


// Information
egen media = rowmean(F06a - F06e) 
gen informed = (media < 1.8) if media != .


// Urban (lan=county, the four counties below are the most densely populated)
gen urban = (lan==1 | lan==12 | lan==14 | lan==3) if lan!=.


// Education
gen primary=(Sun2000niva<300) if Sun2000niva!=.
gen highschool=(Sun2000niva>=300 & Sun2000niva<400) if Sun2000niva!=.
gen college=(Sun2000niva>=500 & Sun2000niva<900) if Sun2000niva!=.


// High IQ
gen iq6 = iq>=6 if iq!=.


// Income and wealth
gen lincome = log(cfviki10)
gen lwage = log(LoneInk09 + 1)
egen netwealth = rowtotal(frealmv06 ffinmv06 fovrtmv06)		// Sum of real, financial and other wealth
replace netwealth = netwealth - fskulmv06 if fskulmv06!=.	// Subtract debt
replace netwealth = - fskulmv06 if netwealth==.
gen lwealth = log(netwealth + sqrt(netwealth^2 + 1))		// Inverse hyperbolic sine transformation to account for negative wealth


// Income history
gen posdiff = (position - position_2000) > 40 if position!=. & position_2000 != .
gen movedup=(F15a>F15b) if F15a!=. & F15b!=.				// Subjective relative income growth
gen movingup=(F15e>F15a) if F15a!=. & F15e!=.				// Subjective future relative income growth


// Pre-treatment party preferences
gen center = (f08==1) if f08!=.
gen folk = (f08==3) if f08!=.
gen krist = (f08==4) if f08!=.
gen miljo = (f08==5) if f08!=.
gen moderat = (f08==6) if f08!=.
gen social = (f08==7) if f08!=.
gen sd = (f08==8) if f08!=.
gen fi = (f08==2) if f08!=.
gen vanster = (f08==9) if f08!=.
gen blank = (f08==11) if f08!=.
gen novote = (f08==12) if f08!=.
gen dontknow = (f08==13) if f08!=.
gen left = (f08==5 | f08==7 | f08==9) if f08!=.
gen right = (f08 == 1 | f08 == 3 | f08 == 4 | f08 == 6) if f08 != .
gen right_sd = (f08==1 | f08==3 | f08==4 | f08==6 | f08==8) if f08!=.
gen right_left = right
replace right_left = . if right == 0 & left == 0


// Luck vs effort and distortive effects of taxation
gen luck = (F22a <= 5) if F22a!=.
gen nodist = (F26a <= 5) if F26a!=.


// Redist-Distort
foreach x in luck nodist {
	tabstat `x' if t == 0, s(mean sd) save
	matrix M = r(StatTotal)
	scalar controlmean = M[1,1]
	scalar controlsd = M[2,1]
	gen z`x' = (`x' - controlmean) / controlsd
}
egen redist_distort = rowmean(zluck znodistort)




// ------------------ Variables for the appendices ------------------ //

// Unemployment benefits
gen ui = Akassa

gen absbias = abs(bias)

gen cons_party2 = cons_party
recode cons_party2 (.=0)


gen rightscale = 12 if vanster_post==1		// Left-right ranking 2010
replace rightscale = 33 if social_post==1
replace rightscale = 39 if miljo_post==1
replace rightscale = 66 if folk_post==1
replace rightscale = 63 if center_post==1
replace rightscale = 68 if krist_post==1
replace rightscale = 83 if cons_party==1
replace rightscale = 74 if sd_post==1
replace rightscale = 63 if fi_post==1
replace rightscale = 63 if blank_post==1
replace rightscale = 66 if novote_post==1
replace rightscale = 74 if dontknow_post==1
replace rightscale = 63 if noresp_post==1
replace rightscale = rightscale - 12
replace rightscale = rightscale / 71


// Outcome index with the right-left scale
tabstat rightscale if t == 0, s(mean sd) save
matrix M = r(StatTotal)
scalar controlmean = M[1,1]
scalar controlsd = M[2,1]
gen zrightscale = (rightscale - controlmean) / controlsd
egen outcome_index_rightscale = rowmean(zagainst_redist zrightscale zdecrease_tax)

gen against_redist_cont = f02
gen decrease_tax_cont = f07 


// Test question after treatment
gen wronganswer=0 if f01!=.
replace wronganswer=1 if position>=60 & f01==0
replace wronganswer=1 if position<=50 & f01==1


gen belowmed_true = (position <= 50) if position!=.


gen care = (F10c >= 6) if F10c!=.
gen just = (F10f >= 6) if F10f!=.


// Treatment interactions
foreach x in bias nbias nobias pbias right right_sd right_left redist_distort ///
luck nodist redist_distort belowmed_true {
	gen t`x' = t * `x'
}


// Sample definition
gen diff_inc1 = (cfviki10 - F17_ink) / cfviki10 if cfviki10!=. & F17_ink!=.
gen diff_inc2 = (F17_ink - cfviki10) / F17_ink if cfviki10!=. & F17_ink!=.
gen wronginc = (diff_inc1 < -7.5 | diff_inc2 < -7.5) if cfviki10!=. & F17_ink!=.
gen misund= (F17_ink > F19_ink + 19000 & F16_proc <= 50 & abs(bias) >= 40) if F16_proc!=. & F17_ink!=. & F19_ink!=. & bias!=.
gen sample = 1 if misund!=. & wronginc!=. & F16_proc!=. & F17_ink!=.
replace sample = 0 if wronginc == 1
replace sample = 0 if misund == 1
recode sample (.=0)
keep if sample == 1


// Save
save final, replace





















