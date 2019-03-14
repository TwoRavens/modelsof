****** Figures 
** Set the working directory to where the repliction files are located


clear all

cd "/Users/johnkuk/Dropbox/14_GSR/Zoli/Voter ID Law/rebuttal/finalcode"
use "jop_replication.dta", clear

****
**** Figure 1
****


// drop 2006 (all) and 2008 (VA)
// for every model
gen goodstate = 1
replace goodstate = 0 if year == 2006
replace goodstate = 0 if state == "Virginia" & year == 2008


// Stores data for graph
matrix estimates = J(8, 3, -9)
// Lower bound on CI for graph
local lb = .025
// Lower bound on CI for graph
local ub = .975


* Table 1
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010  if voteregpre==1 & goodstate==1  [pw=weight],  cluster(inputstate)

matrix temp = e(V)
local i = 1
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


* Democrats Only
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 if voteregpre==1 & dem==1 & goodstate==1 [pw=weight],  cluster(inputstate)


matrix temp = e(V)
local i = 2
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


* Extra political controls
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010 spending dem_house dem_senate dempnew dem_governor /*
*/ if voteregpre==1 & goodstate==1  [pw=weight],  cluster(inputstate)


matrix temp = e(V)
local i = 3
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


* Extra demographic controls
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010 church_attendence born_again relig_importance news_interest /*
*/ if voteregpre==1 & goodstate==1 [pw=weight],  cluster(inputstate)

matrix temp = e(V)
local i = 4
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


** Control South
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 southz if voteregpre==1 & goodstate==1 [pw=weight],  cluster(inputstate)

matrix temp = e(V)
local i = 5
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


*** Table A9 with sample weight and cluster se
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2006 y2008 y2010 i.inputstate /*
*/ if voteregpre==1 & goodstate==1 [pw=weight],  cluster(inputstate)

matrix temp = e(V)
local i = 6
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

***
*** Grimmer et al preferred sample (don't condition on voteregpre and replace missing with zeros)
***


// don't condition on voteregpre, keep newstrict
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/  y2008 y2010 i.inputstate if goodstate == 1  [pw=weight], cluster(inputstate)


matrix temp = e(V)
local i = 7
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

// + replace missings w/ zeros
replace votegenval = 0 if missing(votegenval)
regress votegenval stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/  y2008 y2010 i.inputstate if goodstate == 1  [pw=weight], cluster(inputstate)

matrix temp = e(V)
local i = 8
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')




// Plots 95% CIs from Selected Models

clear
svmat estimates

// Scales by 100
forvalues i = 1(1)3 {
replace estimates`i' = estimates`i'*100
}

rename estimates1 coefficients
rename estimates2 lowerbound
rename estimates3 upperbound

gen model = 4 if _n == 8
replace model = 8 if _n == 7
replace model = 12 if _n == 6
replace model = 16 if _n == 5
replace model = 20 if _n == 4
replace model = 24 if _n == 3
replace model = 28 if _n == 2
replace model = 32 if _n == 1


label define model 32 "Table 1", replace
label define model 28 "Democrats Only", add
label define model 24 "Extra Political Controls", add
label define model 20 "Extra Demographic Controls", add
label define model 16 "Southern Controls", add
label define model 12 "State Fixed Effects", add
label define model 8 "Include Non-Registered", add
label define model 4 "& Include Non-Matches", add


label values model model

gen group = 2 if _n == 8
replace group = 2 if _n == 7
replace group = 1 if _n == 6
replace group = 1 if _n == 5
replace group = 1 if _n == 4
replace group = 1 if _n == 3
replace group = 1 if _n == 2
replace group = 1 if _n == 1


label define group 1 "Hajnal et al Models", replace
label define group 2 "Grimmer et al Models", add
label values group group


twoway (scatter model coefficients, mcolor(black)) /*
*/ (rspike lowerbound upperbound model, horizontal lcolor(black)), /*
*/ plotregion(color(white) ) xlabel(-15(5)15) /*
*/ xtitle("General elections" " " "{&Delta} turnout percentage after strict voter ID implemented")/*
*/ ylabel(4 8 12 16 20 24 28 32, nogrid valuelabel angle(0) noticks) xline(0) ytitle("") /*
*/ legend(label(1 "Hispanics") order(1)) by(group, graphregion(color(white)) note("")) subtitle(,fcolor(white) lcolor(gray))
graph export "figure1.eps", replace

twoway (scatter model coefficients, mcolor(black)) /*
*/ (rspike lowerbound upperbound model, horizontal lcolor(black)), /*
*/ plotregion(color(white) ) xlabel(-15(5)15) /*
*/ xtitle("General elections" " " "{&Delta} turnout percentage after strict voter ID implemented") /*
*/ ylabel(4 8 12 16 20 24 28 32, nogrid valuelabel angle(0) noticks) xline(0) ytitle("") /*
*/ legend(label(1 "Hispanics") order(1)) by(group, graphregion(color(white)) note("")) subtitle(,fcolor(white) lcolor(gray))
graph save "figure1.gph", replace



****
**** Figure 2
****


clear all

cd "/Users/johnkuk/Dropbox/14_GSR/Zoli/Voter ID Law/rebuttal/finalcode"
use "jop_replication.dta", clear


// drop 2006 (all) and VA, LA
// for every model
gen goodstate = 1
replace goodstate = 0 if year == 2006
replace goodstate = 0 if state == "Louisiana"
replace goodstate = 0 if state == "Virginia"



// Stores data for graph
matrix estimates = J(24, 3, -9)
// Lower bound on CI for graph
local lb = .025
// Lower bound on CI for graph
local ub = .975


* Table 1
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010  if voteregpre==1 & goodstate==1  [pw=weight],  cluster(inputstate)

matrix temp = e(V)
local i = 1
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 2
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 3
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


* Democrats Only
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 if voteregpre==1 & dem==1 & goodstate==1 [pw=weight],  cluster(inputstate)


matrix temp = e(V)
local i = 4
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 5
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 6
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')



* Extra political controls
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010 spending dem_house dem_senate dempnew dem_governor /*
*/ if voteregpre==1 & goodstate==1 [pw=weight],  cluster(inputstate)


matrix temp = e(V)
local i = 7
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 8
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 9
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')



* Extra demographic controls
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear  marginpnew /*
*/ y2006 y2008 y2010 church_attendence born_again relig_importance news_interest /*
*/ if voteregpre==1 & goodstate==1  [pw=weight],  cluster(inputstate)

matrix temp = e(V)
local i = 10
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 11
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 12
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')



** Control South
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist /*
*/ days_before_election early_in_person vote_by_mail no_excuse_absence_ /*
*/ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew /*
*/ y2006 y2008 y2010 southz if voteregpre==1  [pw=weight] ,  cluster(inputstate)

matrix temp = e(V)
local i = 13
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 14
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 15
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')



*** Table A9 with sample weight and cluster se
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2006 y2008 y2010 i.inputstate /*
*/ if voteregpre==1 & goodstate==1 [pw=weight],  cluster(inputstate)

matrix temp = e(V)
local i = 16
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 17
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 18
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


***
*** Grimmer et al preferred sample (don't condition on voteregpre and replace missing with zeros)
***


// don't condition on voteregpre, keep newstrict
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2008 y2010 i.inputstate if goodstate == 1  [pw=weight], cluster(inputstate)


matrix temp = e(V)
local i = 19
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 20
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 21
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


// + replace missings w/ zeros
replace voteprival = 0 if missing(voteprival)
regress voteprival stricty newstrict blackstricty hispstricty asianstricty mixedracestricty  /*
*/ black hispanic asian mixedrace foreignb firstgen age educ inc male married childrenz unionz /*
*/ unemp  ownhome protestant catholic jewish atheist  days_before_election early_in_person vote_by_mail /*
*/ no_excuse_absence_ presidentialelectionyear gubernatorialelectionyear senateelectionyear marginpnew  /*
*/ y2008 y2010 i.inputstate if goodstate == 1  [pw=weight], cluster(inputstate)


matrix temp = e(V)
local i = 22
local pointestimate = _b[stricty] + _b[blackstricty]
local sigma = (temp[1, 1] + 2*temp[1, 3] + temp[3, 3])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 23
local pointestimate = _b[stricty] + _b[hispstricty]
local sigma = (temp[1, 1] + 2*temp[1, 4] + temp[4, 4])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')

matrix temp = e(V)
local i = 24
local pointestimate = _b[stricty] + _b[asianstricty]
local sigma = (temp[1, 1] + 2*temp[1, 5] + temp[5, 5])^(1/2)
matrix estimates[`i', 1] = `pointestimate'
matrix estimates[`i', 2] = `pointestimate' + `sigma' * invt(e(df_r), `lb')
matrix estimates[`i', 3] = `pointestimate' + `sigma' * invt(e(df_r), `ub')


// Plots 95% CIs from Selected Models

clear
svmat estimates

// Scales by 100
forvalues i = 1(1)3 {
replace estimates`i' = estimates`i'*100
}

rename estimates1 coefficients
rename estimates2 lowerbound
rename estimates3 upperbound

gen model = 4 if _n == 24
replace model = 6 if _n == 23
replace model = 8 if _n == 22
replace model = 14 if _n == 21
replace model = 16 if _n == 20
replace model = 18 if _n == 19
replace model = 24 if _n == 18
replace model = 26 if _n == 17
replace model = 28 if _n == 16
replace model = 34 if _n == 15
replace model = 36 if _n == 14
replace model = 38 if _n == 13
replace model = 44 if _n == 12
replace model = 46 if _n == 11
replace model = 48 if _n == 10
replace model = 54 if _n == 9
replace model = 56 if _n == 8
replace model = 58 if _n == 7
replace model = 64 if _n == 6
replace model = 66 if _n == 5
replace model = 68 if _n == 4
replace model = 74 if _n == 3
replace model = 76 if _n == 2
replace model = 78 if _n == 1





label define model 78 " ", replace
label define model 76 "Table 1", add
label define model 74 " ", add
label define model 68 " ", add
label define model 66 "Democrats Only", add
label define model 64 " ", add
label define model 58 " ", add
label define model 56 "Extra Political Controls", add
label define model 54 " ", add
label define model 48 " ", add
label define model 46 "Extra Demographic Controls", add
label define model 44 " ", add
label define model 38 " ", add
label define model 36 "Southern Controls", add
label define model 34 " ", add
label define model 28 " ", add
label define model 26 "State Fixed Effects", add
label define model 24 " ", add
label define model 18 " ", add
label define model 16 "Include Non-Registered", add
label define model 14 " ", add
label define model 8 " ", add
label define model 6 "& Include Non-Matches ", add
label define model 4 " ", add


label values model model

gen group = 2 if _n <= 24 | _n >= 19
replace group = 1 if _n <= 18

label define group 1 "Hajnal et al Models", replace
label define group 2 "Grimmer et al Models", add

label values group group




twoway (scatter model coefficients if mod(model, 10) == 8, mlcolor(black) mfcolor(white)) /*
*/ (scatter  model coefficients if mod(model, 10) == 6, mcolor(black)) /*
*/ (scatter  model coefficients if mod(model, 10) == 4, mlcolor(gray) mfcolor(gray)) /*
*/ (rspike lowerbound upperbound model, horizontal lcolor(black)), /*
*/ plotregion(color(white)) graphregion(color(white)) xlabel(-15(5)15) /*
*/ xtitle("Primary elections" " " "{&Delta} turnout percentage after strict voter ID implemented") /*
*/ ylabel(4 6 8 14 16 18 24 26 28 34 36 38 44 46 48 54 56 58 64 66 68 74 76 78, nogrid valuelabel angle(0) noticks) xline(0) ytitle("") /*
*/ legend(label(1 "Black") label(2 "Hispanics") label(3 "Asians") order(1 2 3)) by(group, graphregion(color(white)) note("")) subtitle(,fcolor(white) lcolor(gray))
graph export "figure2.eps", replace

twoway (scatter model coefficients if mod(model, 10) == 8, mlcolor(black) mfcolor(white)) /*
*/ (scatter  model coefficients if mod(model, 10) == 6, mcolor(black)) /*
*/ (scatter  model coefficients if mod(model, 10) == 4, mlcolor(gray) mfcolor(gray)) /*
*/ (rspike lowerbound upperbound model, horizontal lcolor(black)), /*
*/ plotregion(color(white)) graphregion(color(white)) xlabel(-15(5)15) /*
*/ xtitle("Primary elections" " " "{&Delta} turnout percentage after strict voter ID implemented") /*
*/ ylabel(4 6 8 14 16 18 24 26 28 34 36 38 44 46 48 54 56 58 64 66 68 74 76 78, nogrid valuelabel angle(0) noticks) xline(0) ytitle("") /*
*/ legend(label(1 "Black") label(2 "Hispanics") label(3 "Asians") order(1 2 3)) by(group, graphregion(color(white)) note("")) subtitle(,fcolor(white) lcolor(gray))
graph save "figure2.gph", replace


