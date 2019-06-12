
* Stata code to build tables and figures for
* Michael Clemens, Claudio Montenegro, and Lant Pritchett
* The Place Premium: Bounding the Price Equivalent of Migration Barriers
* June 18, 2018

* On typical computers this code takes a very long time to run, circa 18 hours, due to bootstrap cycles.
* Successive dots ("...") output to the Results frame show the progress of each bootstrap iteration in sets of 500.

* Running this code requires installation of user-written -bsweights- and -svmat2- (from the dm79 package)
* and changing the filepath below to your working directory

version 15.1
clear
set more off
set mem 800m
set matsize 10000

cd "XXXXXXX"     // Change to your working directory

use "full_sample_ready_small.dta", clear

capture log close
log using PlacePremiumOutput, replace

** MAKE NEW LATE-ARRIVAL DUMMY FOR ARRIVAL AFTER AGE 20
replace yr2us = . if yr2us == 0
gen agearrive = age +.5 - (2000-yr2us)
drop dummy_arr
gen dummy_arr = agearrive >= 20      // indicates arrived as adult
replace dummy_arr = 0 if country1 == "USA" | country != "USA"
drop inmigeducusa
gen inmigeducusa = 0
replace inmigeducusa = 1 if noinmig == 0 & country1 != "USA" & dummy_arr == 0    

drop age age2 educy yr2us wrklyr weeks hours foreign_in_us inmig educy2 educy3 age3 agearrive _icountry_*

rename country1 country_birth
rename country country_res
gen us_res = 1-noinmig
gen wageoer = exp(lwageoer)
gen wageppp = exp(lwageppp)

replace country_birth = "Argentina" if country_birth =="ARG"
replace country_birth = "Bangladesh" if country_birth =="BGD"
replace country_birth = "Belize" if country_birth =="BLZ"
replace country_birth = "Bolivia" if country_birth =="BOL"
replace country_birth = "Brazil" if country_birth =="BRA"
replace country_birth = "Chile" if country_birth =="CHL"
replace country_birth = "Cameroon" if country_birth =="CMR"
replace country_birth = "Colombia" if country_birth =="COL"
replace country_birth = "Costa Rica" if country_birth =="CRI"
replace country_birth = "Dominican Rep." if country_birth =="DOM"
replace country_birth = "Ecuador" if country_birth =="ECU"
replace country_birth = "Egypt" if country_birth =="EGY"
replace country_birth = "Ethiopia" if country_birth =="ETH"
replace country_birth = "Ghana" if country_birth =="GHA"
replace country_birth = "Guatemala" if country_birth =="GTM"
replace country_birth = "Guyana" if country_birth =="GUY"
replace country_birth = "Haiti" if country_birth =="HTI"
replace country_birth = "Indonesia" if country_birth =="IDN"
replace country_birth = "India" if country_birth =="IND"
replace country_birth = "Jamaica" if country_birth =="JAM"
replace country_birth = "Jordan" if country_birth =="JOR"
replace country_birth = "Cambodia" if country_birth =="KHM"
replace country_birth = "Sri Lanka" if country_birth =="LKA"
replace country_birth = "Morocco" if country_birth =="MAR"
replace country_birth = "Mexico" if country_birth =="MEX"
replace country_birth = "Nigeria" if country_birth =="NGA"
replace country_birth = "Nicaragua" if country_birth =="NIC"
replace country_birth = "Nepal" if country_birth =="NPL"
replace country_birth = "Pakistan" if country_birth =="PAK"
replace country_birth = "Panama" if country_birth =="PAN"
replace country_birth = "Peru" if country_birth =="PER"
replace country_birth = "Philippines" if country_birth =="PHL"
replace country_birth = "Paraguay" if country_birth =="PRY"
replace country_birth = "Sierra Leone" if country_birth =="SLE"
replace country_birth = "Thailand" if country_birth =="THA"
replace country_birth = "Turkey" if country_birth =="TUR"
replace country_birth = "Uganda" if country_birth =="UGA"
replace country_birth = "Uruguay" if country_birth =="URY"
replace country_birth = "United States" if country_birth =="USA"
replace country_birth = "Venezuela" if country_birth =="VEN"
replace country_birth = "Vietnam" if country_birth =="VNM"
replace country_birth = "Yemen" if country_birth =="YEM"
replace country_birth = "South Africa" if country_birth =="ZAF"

replace country_res = "Argentina" if country_res =="ARG"
replace country_res = "Bangladesh" if country_res =="BGD"
replace country_res = "Belize" if country_res =="BLZ"
replace country_res = "Bolivia" if country_res =="BOL"
replace country_res = "Brazil" if country_res =="BRA"
replace country_res = "Chile" if country_res =="CHL"
replace country_res = "Cameroon" if country_res =="CMR"
replace country_res = "Colombia" if country_res =="COL"
replace country_res = "Costa Rica" if country_res =="CRI"
replace country_res = "Dominican Rep." if country_res =="DOM"
replace country_res = "Ecuador" if country_res =="ECU"
replace country_res = "Egypt" if country_res =="EGY"
replace country_res = "Ethiopia" if country_res =="ETH"
replace country_res = "Ghana" if country_res =="GHA"
replace country_res = "Guatemala" if country_res =="GTM"
replace country_res = "Guyana" if country_res =="GUY"
replace country_res = "Haiti" if country_res =="HTI"
replace country_res = "Indonesia" if country_res =="IDN"
replace country_res = "India" if country_res =="IND"
replace country_res = "Jamaica" if country_res =="JAM"
replace country_res = "Jordan" if country_res =="JOR"
replace country_res = "Cambodia" if country_res =="KHM"
replace country_res = "Sri Lanka" if country_res =="LKA"
replace country_res = "Morocco" if country_res =="MAR"
replace country_res = "Mexico" if country_res =="MEX"
replace country_res = "Nigeria" if country_res =="NGA"
replace country_res = "Nicaragua" if country_res =="NIC"
replace country_res = "Nepal" if country_res =="NPL"
replace country_res = "Pakistan" if country_res =="PAK"
replace country_res = "Panama" if country_res =="PAN"
replace country_res = "Peru" if country_res =="PER"
replace country_res = "Philippines" if country_res =="PHL"
replace country_res = "Paraguay" if country_res =="PRY"
replace country_res = "Sierra Leone" if country_res =="SLE"
replace country_res = "Thailand" if country_res =="THA"
replace country_res = "Turkey" if country_res =="TUR"
replace country_res = "Uganda" if country_res =="UGA"
replace country_res = "Uruguay" if country_res =="URY"
replace country_res = "United States" if country_res =="USA"
replace country_res = "Venezuela" if country_res =="VEN"
replace country_res = "Vietnam" if country_res =="VNM"
replace country_res = "Yemen" if country_res =="YEM"
replace country_res = "South Africa" if country_res =="ZAF"

** Generate new interaction variables

gen forborn = 0
replace forborn = 1 if dummy_arr == 1 | inmigeducusa == 1



*** TABLE 1 AND APPENDIX TABLE A1

* GENERATE RATIOS: Analysis at PPP (purchasing power parity) and OER (official exchange rate)
* Combined into a single loop so that generating bootstrap weights, which carries the highest computational burden, is only done once per country

local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultppp = J(42,8,0)
matrix rownames resultppp = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultppp = nocontrols se1 controls se2 foreduc se3 ratio se4 
matrix resultoer = J(42,8,0)
matrix rownames resultoer = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultoer = nocontrols se1 controls se2 foreduc se3 ratio se4 
 
sca counter = 1
foreach ctry of local countrylist {
	preserve
	keep if country_birth=="`ctry'"
	* No controls
		* PPP
		quietly regress lwageppp us_res _iunitwage_* [pw=wgt], vce(robust)
		quietly margins, dydx(us_res) post
		mat rtable = r(table)
		mat resultppp[counter,1] = rtable[1,1]
		mat resultppp[counter,2] = rtable[2,1]
		* OER
		quietly regress lwageoer us_res _iunitwage_* [pw=wgt], vce(robust)
		quietly margins, dydx(us_res) post
		mat rtable = r(table)
		mat resultoer[counter,1] = rtable[1,1]
		mat resultoer[counter,2] = rtable[2,1]
	dis counter "." _continue
	* Controls
		* PPP
		quietly regress lwageppp us_res##(i.educycat i.agecat i.gender1) _iunitwage_* [pw=wgt], vce(robust)
		quietly margins, dydx(us_res) at(educycat=3 agecat=4 gender1=0) post
		mat rtable = r(table)
		mat resultppp[counter,3] = rtable[1,2]
		mat resultppp[counter,4] = rtable[2,2]
		* OER
		quietly regress lwageoer us_res##(i.educycat i.agecat i.gender1) _iunitwage_* [pw=wgt], vce(robust)
		quietly margins, dydx(us_res) at(educycat=3 agecat=4 gender1=0) post
		mat rtable = r(table)
		mat resultoer[counter,3] = rtable[1,2]
		mat resultoer[counter,4] = rtable[2,2]
	dis "." _continue
	* Controls, and restrict to foreign-educated
		* PPP
		quietly regress lwageppp us_res##(i.educycat i.agecat i.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa, vce(robust)
		quietly margins, dydx(us_res) at(educycat=3 agecat=4 gender1=0) post
		mat rtable = r(table)
		mat resultppp[counter,5] = rtable[1,2]
		mat resultppp[counter,6] = rtable[2,2]
		* OER
		quietly regress lwageoer us_res##(i.educycat i.agecat i.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa, vce(robust)
		quietly margins, dydx(us_res) at(educycat=3 agecat=4 gender1=0) post
		mat rtable = r(table)
		mat resultoer[counter,5] = rtable[1,2]
		mat resultoer[counter,6] = rtable[2,2]
	dis "." 
	* Bootstrapped ratio
	set seed 12345
	bsweights bsw, reps(500) n(1) nosvy
	svyset [w=wgt], vce(bootstrap) bsrweight(bsw*) bsn(1)
		* PPP
		svy bootstrap rat=exp(_b[1.us_res]+_b[1.us_res#3.educycat]+_b[1.us_res#4.agecat]): regress lwageppp us_res##(i.educycat i.agecat i.gender1) _iunitwage_* if !inmigeducusa
		mat rtable = r(table)
		mat resultppp[counter,7] = rtable[1,1]
		mat resultppp[counter,8] = rtable[2,1]
		mat list resultppp
		outtable using ratiosppp, mat(resultppp) replace caption("PPP ratios") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
		* OER
		svy bootstrap rat=exp(_b[1.us_res]+_b[1.us_res#3.educycat]+_b[1.us_res#4.agecat]): regress lwageoer us_res##(i.educycat i.agecat i.gender1) _iunitwage_* if !inmigeducusa
		mat rtable = r(table)
		mat resultoer[counter,7] = rtable[1,1]
		mat resultoer[counter,8] = rtable[2,1]
		mat list resultoer
		outtable using ratiosoer, mat(resultoer) replace caption("OER ratios") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
	sca counter = counter+1
	restore
}

* Sort result matrices in reverse order by the ratio column, and save into LaTeX tables

preserve
svmat2 resultppp, names(col) rnames(ctryname)
keep ctryname nocontrols se1 controls se2 foreduc se3 ratio se4
order ctryname nocontrols se1 controls se2 foreduc se3 ratio se4
drop if ctryname==""
gsort -ratio
mat drop resultppp
mkmat nocontrols se1 controls se2 foreduc se3 ratio se4, matrix(resultppp) rownames(ctryname)
outtable using ratiosppp, mat(resultppp) replace caption("PPP ratios") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
rename nocontrols nocontrolsppp
rename se1 se1_nocontrols_ppp
rename controls controlsppp
rename se2 se2_controls_ppp
rename foreduc foreduc_ppp
rename se3 se3_foreduc_ppp
rename ratio ratioppp
rename se4 se4_ratio_ppp
sort ctryname
save resultppp.dta, replace
restore

preserve
svmat2 resultoer, names(col) rnames(ctryname)
keep ctryname nocontrols se1 controls se2 foreduc se3 ratio se4
order ctryname nocontrols se1 controls se2 foreduc se3 ratio se4
drop if ctryname==""
gsort -ratio
mat drop resultoer
mkmat nocontrols se1 controls se2 foreduc se3 ratio se4, matrix(resultoer) rownames(ctryname)
outtable using ratiosoer, mat(resultoer) replace caption("OER ratios") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
rename nocontrols nocontrolsoer
rename se1 se1_nocontrols_oer
rename controls controlsoer
rename se2 se2_controls_oer
rename foreduc foreduc_oer
rename se3 se3_foreduc_oer
rename ratio ratiooer
rename se4 se4_ratio_oer
sort ctryname
save resultoer.dta, replace
restore


*** TABLE 2

* Oster coefficient stability test

set more off
local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultoster = J(42,6,0)
matrix rownames resultoster = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultoster = original beta1 beta2 delta rro gain
 
sca counter = 1
foreach ctry of local countrylist {
	* Store beta and R for controlled and uncontrolled regressions
	qui regress lwageppp _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'", vce(robust)   // To determine what fraction of variance is explained by wage-period dummies alone
	sca r_bkgnd = e(r2_a)    // This 'background' adj-R^2 will be subtracted from the R^2s of interest
	qui regress lwageppp us_res##(ib3.educycat ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'", vce(robust)
	sca btilde = _b[1.us_res]
	sca rtilde = e(r2_a) - r_bkgnd
	sca constant = _b[_cons]
	regress lwageppp us_res _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'", vce(robust)
	sca bzero = _b[us_res]
	sca rzero = e(r2_a) - r_bkgnd

	* Original result
	mat resultoster[counter,1] = exp(btilde)
	* e^Beta if delta = 1 and rmax = 1.3 *R~
	mat resultoster[counter,2] = exp(btilde - 1*(bzero - btilde)*((min(1,1.3*rtilde) - rtilde)/(rtilde - rzero)))
	* e^Beta if delta = 1 and rmax = 2 *R~
	mat resultoster[counter,3] = exp(btilde - 1*(bzero - btilde)*((min(1,2*rtilde) - rtilde)/(rtilde - rzero)))
	* Delta if beta = 0 and rmax = 1.3 *R~
	mat resultoster[counter,4] = (btilde*(rtilde - rzero))/((bzero-btilde)*(min(1,1.3*rtilde) - rtilde)) 
	* Selection on observables: R/Ro
	mat resultoster[counter,5] = bzero/btilde 
	mat resultoster[counter,6] = 12*((resultoster[counter,2]*exp(constant)) - exp(constant))  // PPP dollar value wage gain/yr implied by col. 2
	
	mat list resultoster
	outtable using ostertest, mat(resultoster) replace caption("Coefficient stability test") format(%04.3f %04.3f %04.3f %04.3f %04.3f %7.0fc)
	sca counter = counter+1
}

preserve
svmat2 resultoster, names(col) rnames(ctryname)
keep ctryname original beta1 beta2 delta rro gain
order ctryname original beta1 beta2 delta rro gain
drop if ctryname==""
gsort -original
mat drop resultoster
mkmat original beta1 beta2 delta rro gain, matrix(resultoster) rownames(ctryname)
outtable using ostertest, mat(resultoster) replace caption("Coefficient stability test") format(%04.3f %04.3f %04.3f %04.3f %04.3f %7.0fc)
rename original orig_oster
rename beta1 beta1_oster
rename beta2 beta2_oster
rename delta delta_oster
rename gain gain_oster
sort ctryname
save resultoster.dta, replace
restore



*** APPENDIX TABLE A4

* Coefficients at different levels of observed skill

* For a few countries there are few observations at education level 5 (Sierra Leone, Nepal, Guyana)
* Thus create new education category that combines 4 and 5

gen educycat_alt = educycat
replace educycat_alt = 4 if educycat == 5

local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultobskill = J(42,5,0)
matrix rownames resultobskill = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultobskill = beta2 beta3 beta4 diff se
 
sca counter = 1
foreach ctry of local countrylist {

	regress lwageppp us_res##(i.educycat_alt i.agecat i.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth == "`ctry'", vce(robust)
	margins, dydx(us_res) at(educycat_alt=(2 3 4) agecat=4 gender1=0) post
	mat resultobskill[counter,1] = exp([1.us_res]1._at)
	mat resultobskill[counter,2] = exp([1.us_res]2._at)
	mat resultobskill[counter,3] = exp([1.us_res]3._at)
	nlcom exp([1.us_res]3._at) - exp([1.us_res]1._at), post
	mat resultobskill[counter,4] = r(b)
	mat rV = r(V)
	mat resultobskill[counter,5] = sqrt(rV[1,1])
	mat list resultobskill
	outtable using testobskill, mat(resultobskill) replace caption("Ratios by observed skill level") format(%04.3f %04.3f %04.3f %04.3f %04.3f)
	sca counter = counter+1
}
preserve
svmat2 resultobskill, names(col) rnames(ctryname)
keep ctryname beta2 beta3 beta4 diff se
order ctryname beta2 beta3 beta4 diff se
drop if ctryname==""
gsort -beta3
mat drop resultobskill
mkmat beta2 beta3 beta4 diff se, matrix(resultobskill) rownames(ctryname)
outtable using resultobskill, mat(resultobskill) replace caption("Ratios by observed skill level") format(%04.3f %04.3f %04.3f %04.3f %04.3f)
restore

preserve
svmat2 resultobskill, names(col) rnames(ctryname) 
keep ctryname beta2 beta3 beta4 diff se
order ctryname beta2 beta3 beta4 diff se
drop if ctryname==""
sort ctryname
save resultobskill.dta, replace
restore


*** FIGURE 3 AND APPENDIX TABLE A5

* How unobserved skill relative to US born at destination varies with skill level

gen us_born = country_birth == "United States"
gen non_us_born = 1-us_born     // Indicator for foreign-born

local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultrelus = J(42,6,0)
matrix rownames resultrelus = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultrelus = beta2 se2 beta3 se3 beta4 se4 
 
sca counter = 1
foreach ctry of local countrylist {
	* Educ category 2
	regress lwageppp non_us_born##(ib2.educycat_alt ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if (us_res & !inmigeducusa & country_birth == "`ctry'") | (country_birth=="United States"), vce(robust)
	nlcom exp(_b[1.non_us_born]), post
	mat resultrelus[counter,1] = r(b)
	mat rV = r(V)
	mat resultrelus[counter,2] = sqrt(rV[1,1])
	* Educ category 3
	regress lwageppp non_us_born##(ib3.educycat_alt ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if (us_res & !inmigeducusa & country_birth == "`ctry'") | (country_birth=="United States"), vce(robust)
	nlcom exp(_b[1.non_us_born]), post
	mat resultrelus[counter,3] = r(b)
	mat rV = r(V)
	mat resultrelus[counter,4] = sqrt(rV[1,1])
	* Educ category (alt) 4
	regress lwageppp non_us_born##(ib4.educycat_alt ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if (us_res & !inmigeducusa & country_birth == "`ctry'") | (country_birth=="United States"), vce(robust)
	nlcom exp(_b[1.non_us_born]), post
	mat resultrelus[counter,5] = r(b)
	mat rV = r(V)
	mat resultrelus[counter,6] = sqrt(rV[1,1])
	
	mat list resultrelus
	outtable using relusbyskill, mat(resultrelus) replace caption("Unobs. determinants of earnings relative to U.S. born, by obs. skill") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
	sca counter = counter+1
}
preserve
svmat2 resultrelus, names(col) rnames(ctryname)
keep ctryname beta2 se2 beta3 se3 beta4 se4 
order ctryname beta2 se2 beta3 se3 beta4 se4  
drop if ctryname==""
gsort -beta3
mat drop resultrelus
mkmat beta2 se2 beta3 se3 beta4 se4, matrix(resultrelus) rownames(ctryname)
outtable using resultrelus, mat(resultrelus) replace caption("Unobs. determinants of earnings relative to U.S. born, by obs. skill") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
restore

preserve
svmat2 resultrelus, names(col) rnames(ctryname) 
keep ctryname beta2 se2 beta3 se3 beta4 se4 
order ctryname beta2 se2 beta3 se3 beta4 se4 
rename beta2 diff2_relus
rename se2 se2_relus
rename beta3 diff3_relus
rename se3 se3_relus
rename beta4 diff4_relus
rename se4 se4_relus
drop if ctryname==""
sort ctryname
save resultrelus.dta, replace
restore


*** FIGURE 1 AND APPENDIX TABLE A4

* Test difference in std. dev. of income determined by UNOBSERVABLES by us_res

set more off
local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultsd = J(42,6,0)
matrix rownames resultsd = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultsd = sddiff2 pval2 sddiff3 pval3 sddiff4 pval4 
 
sca counter = 1
foreach ctry of local countrylist {
	* Get residual wage, resolve to monthly
	* regress lwageppp us_res##(ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if country_birth=="`ctry'" & !inmigeducusa, vce(robust)

	qui regress lwageppp us_res##(ib3.educycat ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'", vce(robust)
	
	predict resid if country_birth=="`ctry'" & !inmigeducusa, residuals

	* Generate difference of sd between US resident and non US resident, for each (alt) educ group
	
	tabstat resid if educycat_alt==2 & country_birth=="`ctry'" [w=wgt], by(us_res) stats(sd) save
	mat r1 = r(Stat1)
	sca sd_for = r1[1,1]
	mat r2 = r(Stat2)
	sca sd_us = r2[1,1]
	mat resultsd[counter,1] = sd_us - sd_for
	sdtest resid if educycat_alt==2 & country_birth=="`ctry'", by(us_res)
	mat resultsd[counter,2] = r(p)
	
	tabstat resid if educycat_alt==3 & country_birth=="`ctry'" [w=wgt], by(us_res) stats(sd) save
	mat r1 = r(Stat1)
	sca sd_for = r1[1,1]
	mat r2 = r(Stat2)
	sca sd_us = r2[1,1]
	mat resultsd[counter,3] = sd_us - sd_for
	sdtest resid if educycat_alt==3 & country_birth=="`ctry'", by(us_res)
	mat resultsd[counter,4] = r(p)
	
	tabstat resid if educycat_alt==4 & country_birth=="`ctry'" [w=wgt], by(us_res) stats(sd) save
	mat r1 = r(Stat1)
	sca sd_for = r1[1,1]
	mat r2 = r(Stat2)
	sca sd_us = r2[1,1]
	mat resultsd[counter,5] = sd_us - sd_for
	sdtest resid if educycat_alt==4 & country_birth=="`ctry'", by(us_res)
	mat resultsd[counter,6] = r(p)
	
	drop resid
	
	mat list resultsd
	outtable using resultsdtable, mat(resultsd) replace caption("Compare std dev of wages determined by UNOBSERVABLES, US vs non-US") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
	sca counter = counter+1
}
preserve
svmat2 resultsd, names(col) rnames(ctryname)
keep ctryname sddiff2 pval2 sddiff3 pval3 sddiff4 pval4 
order ctryname sddiff2 pval2 sddiff3 pval3 sddiff4 pval4   
drop if ctryname==""
gsort -sddiff3
mat drop resultsd
mkmat sddiff2 pval2 sddiff3 pval3 sddiff4 pval4, matrix(resultsd) rownames(ctryname)
outtable using resultsdtable, mat(resultsd) replace caption("Compare std dev of wages determined by UNOBSERVABLES, US vs non-US") format(%04.3f %04.3f %04.3f %04.3f %04.3f %04.3f)
restore

preserve
svmat2 resultsd, names(col) rnames(ctryname) 
keep ctryname sddiff2 pval2 sddiff3 pval3 sddiff4 pval4
order ctryname sddiff2 pval2 sddiff3 pval3 sddiff4 pval4
drop if ctryname==""
sort ctryname
save resultsd.dta, replace
restore




*** APPENDIX TABLE A3

* Generate ratios after dropping the poorest

sca perday1 = ln(30*1)
sca perday2 = ln(30*2)
sca perday4 = ln(30*4)  // See Banerjee & Duflo JEP 2008 and Easterly JEG 2001

local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultpov = J(42,4,0)
matrix rownames resultpov = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultpov = pov_orig pov_1day pov_2day pov_4day
 
sca counter = 1
foreach ctry of local countrylist {
	preserve
	keep if country_birth=="`ctry'"
	* Controls, and restrict to foreign-educated
		qui regress lwageppp us_res##(ib3.educycat ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'", vce(robust)
		mat resultpov[counter,1] = exp(_b[1.us_res])
		qui regress lwageppp us_res##(ib3.educycat ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'" & (us_res | lwageppp>perday1), vce(robust)
		mat resultpov[counter,2] = exp(_b[1.us_res])
		qui regress lwageppp us_res##(ib3.educycat ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'" & (us_res | lwageppp>perday2), vce(robust)
		mat resultpov[counter,3] = exp(_b[1.us_res])
		qui regress lwageppp us_res##(ib3.educycat ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa & country_birth=="`ctry'" & (us_res | lwageppp>perday4), vce(robust)
		mat resultpov[counter,4] = exp(_b[1.us_res])

		mat list resultpov
		outtable using resultpov, mat(resultpov) replace caption("Dropping the poorest") format(%04.3f %04.3f %04.3f %04.3f )
	sca counter = counter+1
	restore
}

* Sort result matrices in reverse order by the ratio column, and save into LaTeX tables

preserve
svmat2 resultpov, names(col) rnames(ctryname)
keep ctryname pov_orig pov_1day pov_2day pov_4day
order ctryname pov_orig pov_1day pov_2day pov_4day
drop if ctryname==""
gsort -pov_orig
mat drop resultpov
mkmat pov_orig pov_1day pov_2day pov_4day, matrix(resultpov) rownames(ctryname)
outtable using resultpov, mat(resultpov) replace caption("Dropping the poorest") format(%04.3f %04.3f %04.3f %04.3f)
sort ctryname
save resultpov.dta, replace
restore


*** FIGURE 2 AND APPENDIX TABLE A4

* Create matrix of shifts in coefficients, with and without controls, for graphs

set more off
local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultshift = J(42,3,0)
matrix rownames resultshift = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultshift = shift2 shift3 shift4 
 
sca counter = 1
foreach ctry of local countrylist {
	preserve
	keep if country_birth=="`ctry'"
	forvalues i = 2/4 {
		regress lwageppp us_res _iunitwage_* [pw=wgt], vce(robust) 
		sca without = _b[us_res]
		regress lwageppp us_res##(ib`i'.educycat_alt ib4.agecat ib0.gender1) _iunitwage_* [pw=wgt] if !inmigeducusa, vce(robust)
		sca with = _b[1.us_res]
		mat resultshift[counter,`i'-1] = exp(without - with)
	}
	mat list resultshift
	outtable using resultshift, mat(resultshift) replace caption("Shifts in coefficients without and with controls, by (alt) educ group") format(%04.3f %04.3f %04.3f)
	sca counter = counter+1
	restore
}

* Sort result matrices in reverse order by the ratio column, and save into LaTeX tables

preserve
svmat2 resultshift, names(col) rnames(ctryname)
keep ctryname shift2 shift3 shift4 
order ctryname shift2 shift3 shift4 
drop if ctryname==""
gsort -shift3
mat drop resultshift
mkmat shift2 shift3 shift4, matrix(resultshift) rownames(ctryname)
outtable using resultshift, mat(resultshift) replace caption("Shifts in coefficients without and with controls, by (alt) educ group") format(%04.3f %04.3f %04.3f)
sort ctryname
save resultshift.dta, replace
restore



* Create matrix of average incomes in origin country, for graphs 

set more off
local countrylist `" "Argentina" "Bangladesh" "Belize" "Bolivia" "Brazil" "Chile" "Cameroon" "Colombia" "Costa Rica" "Dominican Rep." "Ecuador" "Egypt" "Ethiopia" "Ghana" "Guatemala" "Guyana" "Haiti" "Indonesia" "India" "Jamaica" "Jordan" "Cambodia" "Sri Lanka" "Morocco" "Mexico" "Nigeria" "Nicaragua" "Nepal" "Pakistan" "Panama" "Peru" "Philippines" "Paraguay" "Sierra Leone" "Thailand" "Turkey" "Uganda" "Uruguay" "Venezuela" "Vietnam" "Yemen" "South Africa" "'

* initialize results matrices
matrix resultavgwage = J(42,3,0)
matrix rownames resultavgwage = Argentina Bangladesh Belize Bolivia Brazil Chile Cameroon Colombia Costa_Rica Dominican_Rep Ecuador Egypt Ethiopia Ghana Guatemala Guyana Haiti Indonesia India Jamaica Jordan Cambodia Sri_Lanka Morocco Mexico Nigeria Nicaragua Nepal Pakistan Panama Peru Philippines Paraguay Sierra_Leone Thailand Turkey Uganda Uruguay Venezuela Vietnam Yemen South_Africa    // Spaces in rownames result in improper matrix processing
matrix colnames resultavgwage = avglwage2 avglwage3 avglwage4 
 
sca counter = 1
foreach ctry of local countrylist {
	preserve
	keep if country_birth=="`ctry'"
	forvalues i = 2/4 {
	* Controls, and restrict to foreign-educated
		qui regress lwageppp ib`i'.educycat_alt ib4.agecat ib0.gender1 _iunitwage_* [pw=wgt] if !us_res, vce(robust)
		mat resultavgwage[counter,`i'-1] = exp(_b[_cons])
	}
	mat list resultavgwage
	outtable using resultavgwage, mat(resultavgwage) replace caption("Average log wage in origin country by observed skill (alt)") format(%04.3f %04.3f %04.3f)
	sca counter = counter+1
	restore
}

* Sort result matrices in reverse order by the ratio column, and save into LaTeX tables

preserve
svmat2 resultavgwage, names(col) rnames(ctryname)
keep ctryname avglwage2 avglwage3 avglwage4
order ctryname avglwage2 avglwage3 avglwage4
drop if ctryname==""
gsort -avglwage3
mat drop resultavgwage
mkmat avglwage2 avglwage3 avglwage4, matrix(resultavgwage) rownames(ctryname)
outtable using resultavgwage, mat(resultavgwage) replace caption("Average log wage in origin country by observed skill (alt)") format(%04.3f %04.3f %04.3f)
sort ctryname
save resultavgwage.dta, replace
restore


*** GRAPH FIGURES 1, 2, AND 3 FROM EARLIER CALCULATIONS

* First extract average income of base-group US worker, for graph
qui regress lwageppp ib3.educycat_alt ib4.agecat ib0.gender1 _iunitwage_* [pw=wgt] if country_birth=="United States", vce(robust)
sca uslwage_monthly = _b[_cons]   
sca uswage_annual = 12*exp(uslwage_monthly) // Annual ppp ln wage of US worker 35-39 year old male with 9-12 years of education

preserve
use resultrelus.dta, clear
merge 1:1 ctryname using resultobskill.dta
drop _merge
merge 1:1 ctryname using resultsd.dta
drop _merge
merge 1:1 ctryname using resultppp.dta
drop _merge
merge 1:1 ctryname using resultavgwage.dta
drop _merge
merge 1:1 ctryname using resultshift.dta
drop _merge
merge 1:1 ctryname using resultoster.dta
drop _merge
merge 1:1 ctryname using population_working_age.dta
drop _merge

gen ctrycode = ""
replace ctrycode = "ZAF" if ctryname == "South_Africa"
replace ctrycode = "UGY" if ctryname == "Uruguay"
replace ctrycode = "PRY" if ctryname == "Paraguay"
replace ctrycode = "BLZ" if ctryname == "Belize"
replace ctrycode = "KHM" if ctryname == "Cambodia"
replace ctrycode = "IND" if ctryname == "India"
replace ctrycode = "BRA" if ctryname == "Brazil"
replace ctrycode = "ARG" if ctryname == "Argentina"
replace ctrycode = "YEM" if ctryname == "Yemen"
replace ctrycode = "GUY" if ctryname == "Guyana"
replace ctrycode = "CHL" if ctryname == "Chile"
replace ctrycode = "PAK" if ctryname == "Pakistan"
replace ctrycode = "CMR" if ctryname == "Cameroon"
replace ctrycode = "IDN" if ctryname == "Indonesia"
replace ctrycode = "JAM" if ctryname == "Jamaica"
replace ctrycode = "EGY" if ctryname == "Egypt"
replace ctrycode = "TUR" if ctryname == "Turkey"
replace ctrycode = "PER" if ctryname == "Peru"
replace ctrycode = "VEN" if ctryname == "Venezuela"
replace ctrycode = "PAN" if ctryname == "Panama"
replace ctrycode = "GHA" if ctryname == "Ghana"
replace ctrycode = "JOR" if ctryname == "Jordan"
replace ctrycode = "VNM" if ctryname == "Vietnam"
replace ctrycode = "UGA" if ctryname == "Uganda"
replace ctrycode = "LKA" if ctryname == "Sri_Lanka"
replace ctrycode = "BGD" if ctryname == "Bangladesh"
replace ctrycode = "BOL" if ctryname == "Bolivia"
replace ctrycode = "CRI" if ctryname == "Costa_Rica"
replace ctrycode = "ETH" if ctryname == "Ethiopia"
replace ctrycode = "COL" if ctryname == "Colombia"
replace ctrycode = "NIC" if ctryname == "Nicaragua"
replace ctrycode = "NGA" if ctryname == "Nigeria"
replace ctrycode = "GTM" if ctryname == "Guatemala"
replace ctrycode = "SLE" if ctryname == "Sierra_Leone"
replace ctrycode = "THA" if ctryname == "Thailand"
replace ctrycode = "PHL" if ctryname == "Philippines"
replace ctrycode = "MAR" if ctryname == "Morocco"
replace ctrycode = "DOM" if ctryname == "Dominican_Rep"
replace ctrycode = "ECU" if ctryname == "Ecuador"
replace ctrycode = "MEX" if ctryname == "Mexico"
replace ctrycode = "HTI" if ctryname == "Haiti"
replace ctrycode = "NPL" if ctryname == "Nepal"

* For making 45 degree lines:
set obs 43
replace beta2 = 0 in 43
replace beta3 = 0 in 43
replace beta4 = 0 in 43


gen lbeta2 = ln(beta2)
gen lbeta3 = ln(beta3)
gen lbeta4 = ln(beta4)

* For drawing the 45 degree line:
replace lbeta2 = 0.1 in 43
replace lbeta3 = 0.1 in 43
replace lbeta4 = 0.1 in 43

* Graph estimates of gain against unobs. skill relative to US, by observed skill level

graph twoway lpoly diff2_relus lbeta2, degree(1) bwidth(.3) lcolor(gs12) || scatter diff2_relus lbeta2, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) ylabel(0(1)2) aspect(.4) || line lbeta2 lbeta2 if lbeta2<=2.2, sort lcolor(gs10) lpattern(shortdash) legend(off) scheme(s1manual) plotregion(lcolor(none)) text(2.3 2.3 "45{&degree}", size(small) color(gs10)) ytitle("{it:E}{sub:US}[ln {it:w}{sub:US}] `=uchar(8211)' {it:E}[ln {it:w} *]", margin(medsmall)) xtitle("{it:R{sub:c}} (log scale)", margin(medsmall)) xlabel(0 "1" 1.609 "5" 2.303 "10" 2.708 "15" 2.996 "20") xmtick(0 0.693147181 1.098612289 1.386294361 1.609437912 1.791759469 1.945910149 2.079441542 2.197224577 2.302585093 2.397895273 2.48490665 2.564949357 2.63905733 2.708050201 2.772588722 2.833213344 2.890371758 2.944438979 2.995732274)
graph export relus_2.pdf, replace

graph twoway lpoly diff3_relus lbeta3, degree(1) bwidth(.3) lcolor(gs12) || scatter diff3_relus lbeta3, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) ylabel(0(1)2) aspect(.4) || line lbeta3 lbeta3 if lbeta3<=2.2, sort lcolor(gs10) lpattern(shortdash) legend(off) scheme(s1manual) plotregion(lcolor(none)) text(2.25 2.25 "45{&degree}", size(small) color(gs10)) ytitle("{it:E}{sub:US}[ln {it:w}{sub:US}] `=uchar(8211)' {it:E}[ln {it:w} *]", margin(medsmall)) xtitle("{it:R{sub:c}} (log scale)", margin(medsmall)) xlabel(0 "1" 1.609 "5" 2.303 "10" 2.708 "15" 2.996 "20") xmtick(0 0.693147181 1.098612289 1.386294361 1.609437912 1.791759469 1.945910149 2.079441542 2.197224577 2.302585093 2.397895273 2.48490665 2.564949357 2.63905733 2.708050201 2.772588722 2.833213344 2.890371758 2.944438979 2.995732274)
graph export relus_3.pdf, replace

graph twoway lpoly diff4_relus lbeta4, degree(1) bwidth(.3) lcolor(gs12) || scatter diff4_relus lbeta4, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) ylabel(0(1)2) aspect(.4) || line lbeta4 lbeta4 if lbeta4<=2.2, sort lcolor(gs10) lpattern(shortdash) legend(off) scheme(s1manual) plotregion(lcolor(none)) text(2.3 2.3 "45{&degree}", size(small) color(gs10)) ytitle("{it:E}{sub:US}[ln {it:w}{sub:US}] `=uchar(8211)' {it:E}[ln {it:w} *]", margin(medsmall)) xtitle("{it:R{sub:c}} (log scale)", margin(medsmall)) xlabel(0 "1" 1.609 "5" 2.303 "10" 2.708 "15" 2.996 "20") xmtick(0 0.693147181 1.098612289 1.386294361 1.609437912 1.791759469 1.945910149 2.079441542 2.197224577 2.302585093 2.397895273 2.48490665 2.564949357 2.63905733 2.708050201 2.772588722 2.833213344 2.890371758 2.944438979 2.995732274)
graph export relus_4.pdf, replace


* For confidence interval in text:
reg diff2_relus lbeta2
reg diff3_relus lbeta3
reg diff4_relus lbeta4

* Graph estimates of gain against relative variances



graph twoway lpoly lbeta2 sddiff2, degree(1) bwidth(.5) lcolor(gs12) || scatter lbeta2 sddiff2, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) xlabel(,format(%03.1f)) xline(0, lpattern(dot) lcolor(black)) xtitle("`=uchar(120590)'{sub:US} `=uchar(8211)' `=uchar(120590)'{sub:0}", margin(medsmall)) ytitle("{it:R{sub:c}} (log scale)", margin(medsmall)) ylabel(0 "1" 1.609 "5" 2.303 "10" 2.708 "15" 2.996 " ") ylabel(3.1 "20", add custom tstyle(major_notick) labgap(2.1)) ymtick(0 0.693147181 1.098612289 1.386294361 1.609437912 1.791759469 1.945910149 2.079441542 2.197224577 2.302585093 2.397895273 2.48490665 2.564949357 2.63905733 2.708050201 2.772588722 2.833213344 2.890371758 2.944438979 2.995732274  )
graph export resultsd_2.pdf, replace
graph twoway lpoly lbeta3 sddiff3, degree(1) bwidth(.5) lcolor(gs12) || scatter lbeta3 sddiff3, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) xlabel(,format(%03.1f)) xline(0, lpattern(dot) lcolor(black)) xtitle("`=uchar(120590)'{sub:US} `=uchar(8211)' `=uchar(120590)'{sub:0}", margin(medsmall)) ytitle("{it:R{sub:c}} (log scale)", margin(medsmall)) ylabel(0 "1" 1.609 "5" 2.303 "10" 2.708 "15" 2.996 " ") ylabel(3.1 "20", add custom tstyle(major_notick) labgap(2.1)) ymtick(0 0.693147181 1.098612289 1.386294361 1.609437912 1.791759469 1.945910149 2.079441542 2.197224577 2.302585093 2.397895273 2.48490665 2.564949357 2.63905733 2.708050201 2.772588722 2.833213344 2.890371758 2.944438979 2.995732274  )
graph export resultsd_3.pdf, replace
graph twoway lpoly lbeta4 sddiff4 , degree(1) bwidth(.5) lcolor(gs12) || scatter lbeta4 sddiff4, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) xlabel(,format(%03.1f)) xline(0, lpattern(dot) lcolor(black)) xtitle("`=uchar(120590)'{sub:US} `=uchar(8211)' `=uchar(120590)'{sub:0}", margin(medsmall)) ytitle("{it:R{sub:c}} (log scale)", margin(medsmall)) ylabel(0 "1" 1.609 "5" 2.303 "10" 2.708 "15" 2.996 " ") ylabel(3.1 "20", add custom tstyle(major_notick) labgap(2.1)) ymtick(0 0.693147181 1.098612289 1.386294361 1.609437912 1.791759469 1.945910149 2.079441542 2.197224577 2.302585093 2.397895273 2.48490665 2.564949357 2.63905733 2.708050201 2.772588722 2.833213344 2.890371758 2.944438979 2.995732274  )
graph export resultsd_4.pdf, replace

*graph twoway lpoly sddiff2 beta2, degree(1) bwidth(3) lcolor(gs12) || scatter sddiff2 beta2, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) ylabel(,format(%03.1f)) yline(0, lpattern(dot) lcolor(black)) ytitle("`=uchar(120590)'{sub:1}  `=uchar(8211)' `=uchar(120590)'{sub:0}", margin(medsmall)) xtitle("{it:R{sub:o}}", margin(medsmall))

*graph twoway lpoly sddiff3 beta3, degree(1) bwidth(3) lcolor(gs12) || scatter sddiff3 beta3, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) ylabel(,format(%03.1f)) yline(0, lpattern(dot) lcolor(black)) ytitle("`=uchar(120590)'{sub:1}  `=uchar(8211)' `=uchar(120590)'{sub:0}", margin(medsmall)) xtitle("{it:R{sub:o}}", margin(medsmall))

*graph twoway lpoly sddiff4 beta4, degree(1) bwidth(3) lcolor(gs12) || scatter sddiff4 beta4, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) ylabel(,format(%03.1f)) yline(0, lpattern(dot) lcolor(black)) ytitle("`=uchar(120590)'{sub:1}  `=uchar(8211)' `=uchar(120590)'{sub:0}", margin(medsmall)) xtitle("{it:R{sub:o}}", margin(medsmall))



* Unicode character for italicized sigma is the "HTML entity decimal" number from here: http://www.fileformat.info/info/unicode/char/1d70e/index.htm
* corresponding to this: https://en.wikipedia.org/wiki/Mathematical_Alphanumeric_Symbols


* Graph shift in beta, with vs. without controls, versus average wage at origin

graph twoway lpoly shift2 avglwage2 , degree(1) bwidth(100) lcolor(gs12) || scatter shift2 avglwage2, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) ylabel(0(1)4,format(%03.1f))  ytitle("ln {it:R{sub:u}} /{it:R{sub:c}}", margin(medsmall)) xtitle("Average wage in home country (PPP$/mo.)", margin(medsmall)) yline(1, lpattern(dot)) 
* Note: Average wage is actually geometric average, since it's exp(E[lnwageppp]), and is for the standard worker analyzed above (educ code 3, age code 4, male)
graph export resultshift2.pdf, replace

graph twoway lpoly shift3 avglwage3 , degree(1) bwidth(100) lcolor(gs12) || scatter shift3 avglwage3, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) ylabel(0(1)4,format(%03.1f))  ytitle("ln {it:R{sub:u}} /{it:R{sub:c}}", margin(medsmall)) xtitle("Average wage in home country (PPP$/mo.)", margin(medsmall)) yline(1, lpattern(dot)) 
* Note: Average wage is actually geometric average, since it's exp(E[lnwageppp]), and is for the standard worker analyzed above (educ code 3, age code 4, male)
graph export resultshift3.pdf, replace

graph twoway lpoly shift4 avglwage4 if avglwage4<2000, degree(1) bwidth(175) lcolor(gs12) || scatter shift4 avglwage4, msymbol(none) mlabel(ctrycode) mlabpos(0) mlabsize(vsmall) aspect(.4) legend(off) scheme(s1manual) plotregion(lcolor(none)) ylabel(0(1)4,format(%03.1f))  ytitle("ln {it:R{sub:u}} /{it:R{sub:c}}", margin(medsmall)) xtitle("Average wage in home country (PPP$/mo.)", margin(medsmall)) yline(1, lpattern(dot)) 
* Note: Average wage is actually geometric average, since it's exp(E[lnwageppp]), and is for the standard worker analyzed above (educ code 3, age code 4, male)
graph export resultshift4.pdf, replace


* Create table comparing Rc estimates by skill level to relative sd of unobserved skill

gsort -beta3
drop if ctryname==""
mkmat sddiff2 pval2 sddiff3 pval3 sddiff4 pval4 beta2 beta3 beta4, matrix(ratio_vs_sd) rownames(ctryname)
outtable using ratio_vs_sd, mat(ratio_vs_sd) replace caption("Compare Rc estimates by skill level to relative sd of unobserved skill") format(%04.3f %04.2f %04.3f %04.2f %04.3f %04.2f %04.3f %04.3f %04.3f)



*** FIGURE 4

* Graph global supply price envelope

gen migwage = uswage_annual * diff3_relus
gen originwage_bound = migwage/beta1_oster
sort originwage_bound
gen pop_cumul = pop_wa in 1
replace pop_cumul = pop_cumul[_n-1]+ pop_wa if pop_cumul==.
gen pop_cumul_half = .5*pop_wa in 1
replace pop_cumul_half = pop_cumul[_n-1]+ .5*pop_wa if pop_cumul_half==.
* Create country-specific label positions, for graph clarity
gen label_pos = 4
replace label_pos = 3 if inlist(ctrycode,"YEM","EGY","ZAF","GUY","BLZ")
replace label_pos = 5 if inlist(ctrycode,"ECU","VEN","BGD","BOL","CRI")
replace label_pos = 5 if inlist(ctrycode,"DOM","PRY","UGA","PER","PHL","NIC")
* Rescale population variables and generate dash marker
gen pop_cumul_million = pop_cumul/1e6
gen pop_cumul_half_million = pop_cumul_half/1e6
gen marker = "-"
*Store average of migrant wage in U.S. (unweighted, across countries)
mean migwage
mat eb=e(b)
sca migwage_avg = eb[1,1]

set obs 43								// To make first stairstep extend to the y-axis
replace originwage_bound = 1185.5469 in 43  // To make first stairstep extend to the y-axis
replace pop_cumul_million = 0 in 43 		// To make first stairstep extend to the y-axis

gen supplyprice15 = 1.5*originwage_bound
gen supplyprice20 = 2.0*originwage_bound
sort originwage_bound pop_cumul_million

graph twoway line originwage_bound supplyprice15 supplyprice20 pop_cumul_million, connect(stepstair stepstair stepstair) lcolor(black gs6 gs6) lpattern(solid dot dot) || scatter originwage_bound pop_cumul_half_million, msymbol(none) mlabel(ctrycode) mlabvpos(label_pos) mlabsize(tiny) mlabgap(*1.5) mlabangle(-45) || scatter migwage pop_cumul_half_million, msymbol(none) mlabel(marker) mlabpos(0) legend(off) scheme(s1manual) plotregion(lcolor(none)) text(5000 614 "{it:w}{sub:home}", size(small) justification(right)) text(7000 575 "1.5{c 215}{it:w}{sub:home}", size(small) justification(right) color(gs10)) text(9025 575 "2.0{c 215}{it:w}{sub:home}", size(small) justification(right) color(gs10)) text(4970 593 "{c 175}") text(7000 595 "{c 175}", color(gs10)) text(9000 595 "{c 175}", color(gs10)) ylabel(0 10000 20000 30000,format(%7.0fc)) ymtick(5000(10000)25000) yline(`=scalar(uswage_annual)', lcolor(gs10) lpattern(shortdash)) text(`=scalar(uswage_annual)+700' 545 "{it: U.S. workers}", size(vsmall) color(gs10)) yline(`=scalar(migwage_avg)', lcolor(gs10) lpattern(shortdash)) text(`=scalar(migwage_avg)+700' 535 "{it: Immigrant avg.}", size(vsmall) color(gs10)) xlabel(0(500)1500,format(%5.0fc)) ytitle("Annual wage, {c S|}PPP", margin(medsmall)) xtitle("Cumulative population age 15`=uchar(8211)'49, millions", margin(medsmall))

graph export supplyprice.pdf, replace


restore

log close


*** END


