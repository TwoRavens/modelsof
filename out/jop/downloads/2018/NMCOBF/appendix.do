
clear *
set more off


/*-----------------------------------------------------------------------------------------*/
/* Figure A1 */
/*-----------------------------------------------------------------------------------------*/

* load google ngram data (downloaded May 31, 2016)
import excel google-ngrams-data.xlsx, sheet("Sheet1") firstrow clear
keep if year ~= .
egen total = rowtotal(assetdeclaration-assetsdisclosure)
gen share = total/tothe
tsset year
replace share = share*100
tsline share, scheme(s1mono) ylabel(,grid) ///
	ytitle("Share of 'to the' 2-gram (%)") lcolor(black) ///
	xtitle(Year)
	
	
/*-----------------------------------------------------------------------------------------*/
/* Figure A2 */
/*-----------------------------------------------------------------------------------------*/

* load Access World News search results (dates, publication name, article title)
import delimited awn-dates-titles.csv, varnames(1) encoding(UTF-8) clear

* data prep and cleaning
split date, parse(" - ")
drop if date1 == "TendersInfo"
drop if date1 == "TenderNews.com"
drop date3
rename date1 source
drop date
rename date2 date

split date, parse(",")
destring date2, replace
rename date2 year
split date1, parse(" ")
rename date12 day
destring day, replace
gen month = . 
for any January February March April May June July August September ///
	October November December \ any 1 2 3 4 5 6 7 8 9 10 11 12: ///
	replace month = Y if date11 == "X"
drop date1 date11

gen count = 1
collapse (count) count, by(month year)

local n1 = _N + 1
local all = _N + 2
set obs `all'
replace year = 2007 in `n1'
replace month = 5 in `n1'
replace year = 2007 in `all'
replace month = 12 in `all'
replace count = 0 if count == .
sort year month
*gen day = 1
gen date = ym(year,month)
tsset date
format date %tm
drop if year == 2003

* hodrick-prescott filter
tsfilter hp hp = count, trend(trend)
* graph
tsline count, name(g1, replace) scheme(s1mono) xtitle(Month) ///
	ytitle("") ylabel(,grid) lcolor(black) title(Number of articles) nodraw
tsline trend, name(g2, replace) scheme(s1mono) xtitle(Month) ///
	ytitle("") ylabel(,grid) lcolor(black) title(Trend in articles) nodraw
gr combine g1 g2, xcommon rows(2) scheme(s1mono)


/*-----------------------------------------------------------------------------------------*/
/* Figure A3 */
/*-----------------------------------------------------------------------------------------*/

* load asset increase and electoral victory data
use asset-increase-winning-data, replace

* create binned wealth increase variable (30 bins, excluding large outliers)
egen pct = cut(percent_increase) if percent_increase < 10, group(30)
replace pct = pct+1
replace percent_increase = percent_increase*100
la def pct 0 "", replace
forval i = 1/30 {
	sum percent_increase if pct == `i'
	local l = round(r(mean),1)
	local l2 = "`l'%"
	la def pct `i' "`l2'", modify
	}
la val pct pct
collapse win, by(pct)
* graph
twoway (scatter win pct) (lfit win pct, lcolor(red)), ///
	scheme(s1mono) ytitle(Probability of victory) ///
	xlabel(2 "0%" 10 "100%" 18 "200%" 26 "500%") ///
	xtitle("Wealth increase (binned)"" among rerunning incumbents") ///
	legend(off)


/*-----------------------------------------------------------------------------------------*/
/* Figure A7 */
/*-----------------------------------------------------------------------------------------*/

* load wealth increase data across states (for rerunning state legislators)
import excel asset-increase-data.xlsx, sheet("Sheet1") ///
	firstrow clear
destring percent_increase, replace
replace percent = percent*100
rename percent w_pct

* use only the last election pair for each state
bys state: egen maxyear = max(year)
keep if maxyear == year
* exclude outliers
sum w_pct, d
drop if w_pct > r(p99)
* exclude problematic observations
drop if data_problem == 1
replace state = trim(state)
* gen variable to order states by mean
bys state: egen meanw = mean(w_pct)
preserve
collapse meanw, by(state)
egen order = rank(meanw)
save tempmean, replace
restore
merge m:1 state using tempmean
* mean and meadian values to show on graph
sum w_pct if state == "Bihar", d
local mean_bihar = round(r(mean),1)
local med_bihar = round(r(p50),1)
sum w_pct, d
local mean_all = round(r(mean),1)
local med_all = round(r(p50),1)
* graph
graph box w_pct, over(state, sort(order) label(angle(45) labsize(small)) ) scheme(s1mono) ///
	ytitle("Wealth accumulation (5-year % increase)" "among rerunning incumbents", ///
	size(medium)) nooutsides ///
	text(2000 15 "Mean, Bihar: `mean_bihar'%", size(medium)) ///
	text(1800 15 "Median, Bihar: `med_bihar'%", size(medium)) ///
	text(2000 55 "Mean, all: `mean_all'%", size(medium)) ///
	text(1800 55 "Median, all: `med_all'%", size(medium)) ///
	note("") ylabel(, nogrid)
erase tempmean.dta


/*-----------------------------------------------------------------------------------------*/
/* Figure A8 */
/*-----------------------------------------------------------------------------------------*/

* custom program to draw histograms
program define chist
	args v h t a b /* v = var name, h = height on hist, t = title, a = x-title, b = bihar or not */
	qui sum `v' if district == "Madhepura"
	local m = r(mean)
	hist `v', bin(10) color(gs10) addplot(pci 0 `m' `h' `m', lcolor(black) lwidth(thick)) legend(off) ///
		scheme(s1mono) name(`v'_`b', replace) xtitle("`a'") ytitle("") ///
		title("`t'") legend(off) aspect(.7) nodraw
end

* load census data
import delimited census-2011-data.csv, clear

* create variables
gen male = (total_tot_m/total_tot_p)*100
gen sc = (total_p_sc/total_tot_p)*100
gen ruralpop = (rural_tot_p/total_tot_p)*100
gen worker = (total_tot_work_p/total_tot_p)*100
gen main_worker = (total_mainwork_p/total_tot_work_p)*100
gen marg_worker = (total_margwork_p/total_tot_work_p)*100
gen cult_worker = (total_main_cl_p/total_tot_work_p)*100
gen agri_worker = (total_main_al_p/total_tot_work_p)*100
gen non_agri = 100-(cult_worker+agri_worker)
gen ill = (total_p_ill/total_tot_p)*100

* histograms for census variables
chist male .4 "Male population" "Percent" n
chist sc .08 "Scheduled caste" "Percent" n
chist ruralpop .043 "Rural population" "Percent" n
chist worker .08 "Employed" "Percent" n
chist main_worker .045 "Permanently employed" "Percent" n
chist marg_worker .045 "Part-time employed" "Percent" n
chist cult_worker .045 "Farmers" "Percent" n
chist non_agri .04 "Non-agricultural" "Percent" n
chist ill .06 "Illiterate" "Percent" n

* load wealth increase data
import excel asset-increase-data.xlsx, sheet("Sheet1") ///
	firstrow clear
destring percent_increase, replace
replace percent = percent*100
rename percent w_pct
* use only the last election pair for each state
bys state: egen maxyear = max(year)
keep if maxyear == year
* exclude outliers
sum w_pct, d
drop if w_pct > r(p99)
* exclude problematic observations
drop if data_problem == 1
replace state = trim(state)

gen north = (state == "Bihar" | state=="Rajasthan" | state=="Uttar Pradesh" | state=="Madhya Pradesh")
* histogram for wealth increase
hist w_pct if north == 1 & w_pct < 2000, bin(10) color(gs10) addplot(pci 0 302 .002 302, lcolor(black) lwidth(thick)) ///
	legend(off) scheme(s1mono) name(wealth_n, replace) xtitle("Percent") ytitle("") ///
	title("Wealth increase") aspect(.7) nodraw
	
* electoral data from Electoral Commission of India
import delimited eci-electoral-data.csv, ///
	clear
keep if state == "Bihar" | state=="Rajasthan" | state=="Uttar_Pradesh" | state=="Madhya_Pradesh"
bys state: egen maxyear = max(year)
keep if year == maxyear
destring enop turnout, force replace
collapse turnout enop, by(district state)
replace district = proper(district)

* histograms for ECI variables
chist turnout .05 "Turnout" "Percent" n
chist enop .9 "ENP" "Count" n

* combine all histograms
gr combine male_n sc_n ruralpop_n worker_n main_worker_n ///
	marg_worker_n cult_worker_n non_agri_n ill_n wealth_n ///
	turnout_n enop_n, row(3) scheme(s1mono) ///
	l1("Density")

	
/*-----------------------------------------------------------------------------------------*/
/* Table A2 */
/*-----------------------------------------------------------------------------------------*/

local vars "_age _residence _schooling _married _yadav1 _muslim1 _land _pucca _kutcha _hut _occ1 _occ2 _occ3 _occ4 _occ5 _assets _cattle _income"
* demographics from second survey
use second-survey, clear
keep `vars'
gen info = 1
tempfile info
save "`info'"
* demographics from conjoint survey
use conjoint-survey, clear
keep if vignette == 1
keep `vars'
append using "`info'"
replace info = 0 if info == .
* variables to store the summary statistics
gen coef = .
gen pval = .
gen var = ""
foreach x in conjoint info {
	gen `x'_mean = .
	gen `x'_sd = .
	}
* calculate and store summary statistics
local nvars : word count `vars'
forval i = 1/`nvars' {
	replace var = "`: word `i' of `vars''" in `i'
	qui sum `: word `i' of `vars'' if info == 0
	replace conjoint_mean = r(mean) in `i'
	replace conjoint_sd = r(sd) in `i'
	qui sum `: word `i' of `vars'' if info == 1
	replace info_mean = r(mean) in `i'
	replace info_sd = r(sd) in `i'
	reg `: word `i' of `vars'' info, r
	mat tab = r(table)
	replace coef = tab[1,1] in `i'
	replace pval = tab[4,1] in `i'
	}
* create and export table
keep if var ~= ""
keep coef-info_sd
mkmat conjoint_mean conjoint_sd info_mean info_sd coef pval, mat(all)
* format table
frmttable, clear
frmttable, statmat(all) substat(0) sdec(2) ///
	rtitles("Age (years)" \ "Years in residence" \ "Schooling (years)" \ "Married (prop.)" \ ///
	"Yadav (prop.)" \ "Muslim (prop.)" \ "Agricultural land" \ "House type: pucca (prop.)" \ ///
	"House type: kutcha (prop.)" \ "House type: hut (prop.)" \ "Farmer (prop.)" \ ///
	"Agricultural laborer (prop.)" \ "Shop owner (prop.)" \ "Government worker (prop.)" \ ///
	"Private job (prop.)" \ "Assets (count)" \ "Cattle (count)" \ "Income (rupees)") ///
	replace tex fragment ///
	statfont(fs11) hlines(101{0}1) vlines(000101{0}) noblankrows ///
	ctitles("","First survey (N=1,020)","","Second survey (N=232)","","Difference","" \ ///
	"","Mean","St. dev.","Mean","St. dev.","Coef.","\it{p}-value") ///
	multicol(1,2,2;1,4,2;1,6,2) ///
	title("\caption{Sample characteristics in our two surveys\label{tab:sample-comparison}}\leavevmode") ///
	titlfont(normalsize)


/*-----------------------------------------------------------------------------------------*/
/* Table A3 */
/*-----------------------------------------------------------------------------------------*/

* for first two columns, see above (subset of results)
* for columns 3-6
* load IDHS data
use idhs-data, clear

* variable names to lower case
foreach v of var * { 
	rename `v' `=lower("`v'")'
	} 
svyset psuid [pweight=wt]
* keep only main household
keep if hhsplitid == 1

* recode variables
gen hhschooling = hheduc
replace hhschooling = 11 if hheduc == 11 | hheduc == 12
replace hhschooling = . if hheduc == 13 | hheduc == 14
replace hhschooling = 12 if hheduc == 15
replace hhschooling = 13 if hheduc == 16
replace hhschooling = 0 if hheduc == 55
gen muslim = 0
replace muslim = 1 if id11 == 2
gen hhassets = 0
replace hhassets = cg21+cgtv+cgmotorv+cg4+cg17+cg13+cg18

* summary statistics 
mat res = J(5,4,.)
* means for Bihar
preserve
keep if stateid == 10
* first collapse by district
collapse (mean) hhschooling npersons muslim sa1 hhassets stateid [pweight=wt], by(district)
* then collapse at the statelevel
collapse (mean) hhschooling npersons muslim sa1 hhassets, by(stateid)
local j = 1
foreach v of varlist hhsch-hhass {
	qui sum `v'
	mat res[`j',1] = r(mean)
	local j = `j' + 1
	}
restore
* sd's for Bihar
preserve
keep if stateid == 10
collapse (sd) hhschooling npersons muslim sa1 hhassets (mean) stateid [aweight=wt], by(district)
collapse (mean) hhschooling npersons muslim sa1 hhassets, by(stateid)
local j = 1
foreach v of varlist hhsch-hhass {
	qui sum `v'
	mat res[`j',2] = r(mean)
	local j = `j' + 1
	}
restore
* means for North India
preserve
keep if stateid == 09 | stateid == 10 | stateid == 08 | stateid == 23  
collapse (mean) hhschooling npersons muslim sa1 hhassets stateid [pweight=wt], by(district)
gen region = "North India"
collapse (mean) hhschooling npersons muslim sa1 hhassets, by(region)
local j = 1
foreach v of varlist hhsch-hhass {
	qui sum `v'
	mat res[`j',3] = r(mean)
	local j = `j' + 1
	}
restore
* sd's for North India
keep if stateid == 09 | stateid == 10 | stateid == 08 | stateid == 23  
collapse (sd) hhschooling npersons muslim sa1 hhassets (mean) stateid [aweight=wt], by(district)
collapse (mean) hhschooling npersons muslim sa1 hhassets, by(stateid)
gen region = "North India"
collapse (mean) hhschooling npersons muslim sa1 hhassets, by(region)
local j = 1
foreach v of varlist hhsch-hhass {
	qui sum `v'
	mat res[`j',4] = r(mean)
	local j = `j' + 1
	}
* display results
frmttable, statmat(res) substat(0) sdec(2) ///
	rtitles("Schooling (years)" \ "Household size" \ ///
	"Muslim (prop.)" \ "Number of rooms" \ "Assets (count)") ///
	replace tex fragment ///
	statfont(fs11) noblankrows ///
	ctitles("","Bihar","","North India","" \ ///
	"","Mean","St. dev.","Mean","St. dev.") ///
	multicol(1,2,2;1,4,2)
	

/*-----------------------------------------------------------------------------------------*/
/* Table A5 */
/*-----------------------------------------------------------------------------------------*/

* load conjoint survey
use conjoint-survey, clear

* program to perform F-test of joint significance of all conjoint treatments
program define btests
	args y z /* y = outcome variable 
				z = balance matrix row number */
	* first store the relevant results in a matrix
	qui ivregress 2sls `y' i.photo i.dist i.out_party i.record i.family i.crime ///
		i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
	qui test non_co_ethn 2.photo 3.photo 4.photo 5.photo 6.photo 2.dist ///
		3.dist 4.dist 5.dist 6.dist 7.dist 8.dist 1.out_party 2.record ///
		2.family 3.family 2.crime 2.w2010r 3.w2010r 2.wmultr 3.wmultr ///
		1.legal 2.wmultr#1.legal
	matrix b1[`z',1] = r(p)
end

* matrix to store results
forval i = 1/2 {
	matrix b`i' = J(10,1,.)
	}
* column 1, conjoint experiment F-tests
encode _ethnicity, gen(_ethn)
local j = 1
foreach x in _age _married _schooling _occupation _household ///
	_land _house _rooms _income _ethn {
		btests `x' `j'
		local j = `j' + 1
		}
* column 2: balance across pre-treatment characteristics in which profile the respondents rated
egen profile = group(photo dist non_co_ethn out_party family crime w2010r wmultr legal)
local j = 1
foreach x in _age _married _schooling _occupation _household ///
	_land _house _rooms _income _ethn {
		qui reg profile `x', cl(id)
		matrix est = r(table)
		matrix b2[`j',1] = est[4,1]
		local j = `j' + 1
		}
* create basic table 
frmttable, clear
forval i = 1/2 {
	frmttable, statmat(b`i') substat(0) sdec(3) ///
	rtitles("Age" \ "Married" \ "Years of schooling" \ "Occupation" \ ///
		"Household size" \ "Size of land owned" \ "House type" \ "Number of rooms" \ ///
		"Household income" \ "Ethnicity") merge
		}
* display results
frmttable, tex fragment ///
	hlines(11{0}1) statfont(fs11) ///
	ctitles("","Omnibus test","Profile rated") ///
	title("\caption{Balance tests\label{tab:balance_tests}}\leavevmode") ///
	titlfont(normalsize) noblankrows 
	

/*-----------------------------------------------------------------------------------------*/
/* Table A6 */
/*-----------------------------------------------------------------------------------------*/

* program to export AMCEs for each vignette
program define export_amce
	args z /* z = vignette number */

	* load conjoint survey
	use conjoint-survey, clear

	* store the relevant results in matrices to build tables
	recode co_ethn_dummy (0 = 1) (1 = 0)
	reg dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
		i.w2010r i.wmultr##i.legal co_ethn_dummy if vignette == `z', ///
		cl(id)
	* calculate legality AMCE
	lincom (1.legal + (2.wmultr#1.legal + 2.wmultr#1.legal)*(1/3))*(-1)
	global legal_b = r(estimate)
	global legal_se = r(se)
	mat coef = e(b)
	mat var = vecdiag(e(V))
	matmap var se, m(sqrt(@))
	mat coef = coef', se'
	* eliminate constant
	scalar R = rowsof(coef)-1
	mat coef = coef[1..R,1..2]
	* put into a dataset
	clear
	svmat coef
	* eliminate the legality terms, photo and district
	gen names = ""
	local names : rownames coef
	local k = 1
	foreach j of local names {
		replace names = "`j'" in `k'
		local k = `k' + 1
		}
	gen drop1 = regexm(names, "legal")
	gen drop2 = regexm(names, "photo")
	gen drop3 = regexm(names, "dist")
	egen drop = rowtotal(drop*)
	drop if drop == 1
	drop drop*
	* reorder ethnicity and add base category
	local newn = _N+1
	set obs `newn'
	replace names = "0b.co_ethn_dummy" in `newn'
	forval i = 1/2 {
		replace coef`i' = . if coef`i' == 0
		}
	* add legality AMCE
	local newn = _N+2
	set obs `newn'
	local pu = _N-1
	foreach x in coef1 coef2 {
		replace `x' = . in `pu'
		}
	replace names = "1b.legal" in `pu'
	replace coef1 = $legal_b in `newn'
	replace coef2 = $legal_se in `newn'
	replace names = "2.legal" in `newn'
	local m 2 3 8 9 14 15 16 11 12 18 19 20 22 23 24 6 5 26 27
	gen merge = .
	local k = 1
	foreach j of local m {
		replace merge = `j' in `k'
		local k = `k' + 1
		}
	save graph_temp, replace
	clear
	set obs 8
	local m 1 4 7 10 13 17 21 25
	gen merge = .
	local k = 1
	foreach j of local m {
		replace merge = `j' in `k'
		local k = `k' + 1
		}
	gen group = 1
	merge 1:1 merge using graph_temp
	sort merge
	drop _m
	gen pval = (1-normal(abs(coef1/coef2)))*2
	* back to matrices
	mkmat coef1 coef2, matrix(r`z')
	mkmat pval, matrix(p`z')
	local rnum = rowsof(r`z')
	matrix stars`z' = J(`rnum',1,.)
	forval i = 1/`rnum' {
		local pval = p`z'[`i',1]
		if `pval' <= .10 & `pval' > .05 {
			matrix stars`z'[`i',1] = 1
			}
		if `pval' <= .05 & `pval' > .01 {
			matrix stars`z'[`i',1] = 2
			}
		if `pval' <= .01 & `pval' ~= . {
			matrix stars`z'[`i',1] = 3
			}
		if `pval' > .10 & `pval' ~= . {
			matrix stars`z'[`i',1] = 0
			}
		if `pval' == . {
			matrix stars`z'[`i',1] = 0
			}
		}
end

forval i = 1/3 {
	export_amce `i'
	}

* add fourth column with F-tests for each effect across vignettes
use conjoint-survey, clear
recode co_ethn_dummy (0 = 1) (1 = 0)
reg dv_vote i.photo##i.vignette i.dist##i.vignette i.out_party##i.vignette ///
	i.record##i.vignette i.family##i.vignette i.crime##i.vignette ///
	i.w2010r##i.vignette i.wmultr##i.legal##i.vignette co_ethn_dummy##i.vignette, ///
	cl(id)
matrix r4 = J(27,2,.)
* party
test 1.out_party#2.vignette 1.out_party#3.vignette 
matrix r4[3,1] = r(F)
matrix r4[3,2] = r(p)
* ethnicity
test 1.co_ethn_dummy#2.vignette 1.co_ethn_dummy#3.vignette 
matrix r4[6,1] = r(F)
matrix r4[6,2] = r(p)
* record
test 2.record#2.vignette 2.record#3.vignette 
matrix r4[9,1] = r(F)
matrix r4[9,2] = r(p)
* criminality
test 2.crime#2.vignette 2.crime#3.vignette 
matrix r4[12,1] = r(F)
matrix r4[12,2] = r(p)
* family background
test 2.family#2.vignette 2.family#3.vignette
matrix r4[15,1] = r(F)
matrix r4[15,2] = r(p)
test 3.family#2.vignette 3.family#3.vignette
matrix r4[16,1] = r(F)
matrix r4[16,2] = r(p)
* 2010 wealth
test 2.w2010#2.vignette 2.w2010#3.vignette
matrix r4[19,1] = r(F)
matrix r4[19,2] = r(p)
test 3.w2010#2.vignette 3.w2010#3.vignette
matrix r4[20,1] = r(F)
matrix r4[20,2] = r(p)
* wealth increase
test 2.wmult#2.vignette 2.wmult#3.vignette
matrix r4[23,1] = r(F)
matrix r4[23,2] = r(p)
test 3.wmult#2.vignette 3.wmult#3.vignette
matrix r4[24,1] = r(F)
matrix r4[24,2] = r(p)
* legality
test 1.legal#2.vignette 1.legal#3.vignette
matrix r4[27,1] = r(F)
matrix r4[27,2] = r(p)

* create and display table 
frmttable, clear
forval i = 1/3 {
	frmttable, statmat(r`i') substat(1) sdec(3) annotate(stars`i') ///
	asymbol(*,**,***) ///
	rtitles("\textbf{Co-partisanship}" \ "" \ "\hspace{1em} \emph{Base: Yes}" \ "" \ "\hspace{1em} No" \ "" \ ///
		"\textbf{Co-ethnicity}" \ "" \ "\hspace{1em} \emph{Base: Yes}" \ "" \ "\hspace{1em} No" \ "" \ ///
		"\textbf{Record}" \ "" \ "\hspace{1em} \emph{Base: Good}" \ "" \ "\hspace{1em} Bad" \ "" \ ///
		"\textbf{Criminality}" \ "" \ "\hspace{1em} \emph{Base: No}" \ "" \ "\hspace{1em} Yes" \ "" \ ///
		"\textbf{Background}" \ "" \ "\hspace{1em} \emph{Base: Poor}" \ "" \ "\hspace{1em} Middle-income" \ "" \ ///
		"\hspace{1em} Rich" \ "" \ "\textbf{2010 wealth}" \ "" \ "\hspace{1em} \emph{Base: Below median}" \ "" \ ///
		"\hspace{1em} Median--75 pctile" \ "" \ "\hspace{1em} Above 75 pctile" \ "" \ ///
		"\textbf{Wealth increase}" \ "" \ "\hspace{1em} \emph{Base: No increase}" \ "" \ "\hspace{1em} Below median" \ "" \ ///
		"\hspace{1em} Above median" \ "" \ "\textbf{Illegal wealth incr.}" \ "" \ ///
		"\hspace{1em} \emph{Base: No}" \ "" \ "\hspace{1em} Yes") ///
	merge
	}
frmttable, statmat(r4) substat(1) sdec(3) squarebrack merge 
frmttable, tex fragment ///
	hlines(11{0}1) statfont(fs11) ///
	ctitles("","Vignette 1","Vignette 2","Vignette 3", "F-test") ///
	title("\caption{Variability in attribute effects on vote intention by vignette\label{tab:order_effects}}\leavevmode") ///
	titlfont(normalsize) noblankrows
	
erase graph_temp.dta


/*-----------------------------------------------------------------------------------------*/
/* Figure A10 */
/*-----------------------------------------------------------------------------------------*/

* load conjoint survey
use conjoint-survey, clear

ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010r##i.wealth_order i.wmultr##i.legal##wealth_order ///
	(non_co_ethn = co_ethn_dummy), cl(id)
* store results
matrix wmultr2 = J(7,2,.)
matrix wmultr3 = J(7,2,.)
forval i = 2/7 {
	forval j = 2/3 {
		lincom `j'.wmultr + `j'.wmultr#`i'.wealth_order
		matrix wmultr`j'[`i',1] = r(estimate)
		matrix wmultr`j'[`i',2] = r(se)
	}
}
forval j = 2/3 {
	matrix wmultr`j'[1,1] = _b[`j'.wmultr]
	matrix wmultr`j'[1,2] = _se[`j'.wmultr]
	}
clear
svmat wmultr2
svmat wmultr3
forval j = 2/3 {
	gen lb`j' = wmultr`j'1 + invnormal(.025)*wmultr`j'2
	gen ub`j' = wmultr`j'1 + invnormal(.975)*wmultr`j'2
	}
gen label = ""
for any "Row 1" "Row 2" "Row 3" "Row 4" "Row 5" "Row 6" "Row 7" ///
	\ any 1 2 3 4 5 6 7: ///
	replace label = "X" in Y
gen order = _n
local obs = _N
forval i = 1/`obs' {
	local name = label in `i'
	label define order `i' "`name'", modify
	}
label values order order
* below-median wealth increase AMCEs
twoway (scatter order wmultr21, mcolor(black)) ///
	(rcap ub2 lb2 order, horizontal msize(0) lcolor(black)), ///
	legend(off) yscale(reverse) ///
	ylabel(#7, valuelab angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) title("Below median", color(black)) ///
	ytitle("Position on vignette") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Effect on Pr(vote)") name(below, replace) ///
	xscale(range(.1(.1)-.5)) xlabel(#7) ///
	xline(0, lcolor(black)) nodraw
* above-median wealth increase AMCEs
twoway (scatter order wmultr31, mcolor(black)) ///
	(rcap ub3 lb3 order, horizontal msize(0) lcolor(black)), ///
	legend(off) yscale(reverse) ///
	ylabel(#7, valuelab angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) title("Above median", color(black)) ///
	ytitle("Position on vignette") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Effect on Pr(vote)") name(above, replace) ///
	yscale(alt) xscale(range(.1(.1)-.5)) xlabel(#7) ///
	xline(0, lcolor(black)) nodraw
gr combine below above, xcommon ycommon graphregion(color(white))


/*-----------------------------------------------------------------------------------------*/
/* Figure A11 */
/*-----------------------------------------------------------------------------------------*/

* program that preps data for graphing
program define gprep
	args y /* y = outcome variable */
	
	* load conjoint survey
	use conjoint-survey, clear
	
	* first store the relevant results in a matrix
	ivregress 2sls `y' i.photo i.dist i.out_party i.record i.family i.crime ///
		i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
	lincom (1.legal + (2.wmultr#1.legal + 2.wmultr#1.legal)*(1/3))*(-1)
	global legal_b = r(estimate)
	global legal_se = r(se)
	mat coef = e(b)
	mat var = vecdiag(e(V))
	matmap var se, m(sqrt(@))
	mat coef = coef', se'
	* eliminate constant
	scalar R = rowsof(coef)-1
	mat coef = coef[1..R,1..2]
	* put into a dataset
	*preserve
	clear
	svmat coef
	* eliminate the legality terms, photo and district
	gen names = ""
	local names : rownames coef
	local k = 1
	foreach j of local names {
		replace names = "`j'" in `k'
		local k = `k' + 1
		}
	gen drop1 = regexm(names, "legal")
	egen drop = rowtotal(drop*)
	drop if drop == 1
	drop drop*

	* reorder ethnicity and add base category
	expand 3 in 1
	drop in 1
	local pu = _N-1
	foreach x in coef1 coef2 {
		replace `x' = 0 in `pu'
		}
	replace names = "1b.non_co_ethn" in `pu'
	* add legality AMCE
	local newn = _N+2
	set obs `newn'
	local pu = _N-1
	foreach x in coef1 coef2 {
		replace `x' = 0 in `pu'
		}
	replace names = "1b.legal" in `pu'
	replace coef1 = $legal_b in `newn'
	replace coef2 = $legal_se in `newn'
	replace names = "2.legal" in `newn'
	local m 20 21 22 23 24 25 26 27 28 29 30 31 32 33 1 2 5 6 9 10 11 7 8 12 13 14 15 16 17 3 4 18 19
	gen graph_order = .
	local k = 1
	foreach j of local m {
		replace graph_order = `j' in `k'
		local k = `k' + 1
		}
		
	gen group = 1 if coef1 == 0 & coef2 == 0
	gen pval = (1-normal(abs(coef1/coef2)))*2
	sort pval
	gen pval_order = _n if pval ~= .
	sum pval_order
	local max = r(max)
	gen bh1 = (pval_order/`max')*0.05
	gen bh2 = (pval < bh1)
	replace pval = 0 if pval == .
	sort graph_order
	gen label = ""
	for any "Co-partisanship:" "No" "Co-ethnicity:" "No" ///
		"Record:" "Bad" "Criminality:" "Yes" ///
		"Background:" "Middle-income" "Rich" "2010 wealth:" ///
		"Median--75 pctile" "Above 75 pctile" ///
		"Wealth increase:" "Below median" "Above median" ///
		"Illegal wealth incr.:" "Yes" ///
		"Photo:" "Photo 2" "Photo 3" "Photo 4" "Photo 5" ///
		"Photo 6" "District:" "Jahanabad" "Katihar" "Lakhisarai" ///
		"Madhubani" "Muzaffarpur" "Navada" "Samastipur" ///
		\ any 1 2 3 4 5 6 7 8 9 10 11 12 ///
		13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33: ///
		replace label = "X" in Y
	replace label = "Yes" if label == "8es"
	replace label = "Yes" if label == "19es"
	replace label = "{bf:" + label if group == 1
	replace label = label + "}" if group == 1
	local obs = _N
	forval i = 1/`obs' {
		local name = label in `i'
		label define graph_order `i' "`name'", modify
		}
	label values graph_order graph_order
end

* Vote intention
gprep dv_vote
twoway (scatter graph_order pval if group == . & bh2 == 1, mcolor(black)) ///
	(scatter graph_order pval if group == . & bh2 == 0, mcolor(black) symbol(Oh)) ///
	(scatter graph_order pval if group == 1, mcolor(none)), ///
	legend(off) yscale(reverse) ///
	ylabel(#33, valuelab angle(0) labsize(vsmall) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) aspect(1) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle({it:p}-value) title(Vote Intention, color(black)) name(vote, replace) ///
	nodraw

* Corruption rating
gprep dv_corrupt
twoway (scatter graph_order pval if group == . & bh2 == 1, mcolor(black)) ///
	(scatter graph_order pval if group == . & bh2 == 0, mcolor(black) symbol(Oh)) ///
	(scatter graph_order pval if group == 1, mcolor(none)), ///
	legend(off) yscale(reverse) ///
	ylabel(#33, valuelab angle(0) labsize(vsmall) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) aspect(1) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle({it:p}-value) title(Corruption Rating, color(black)) name(corrupt, replace) ///
	nodraw

* Violence rating
gprep dv_violence
twoway (scatter graph_order pval if group == . & bh2 == 1, mcolor(black)) ///
	(scatter graph_order pval if group == . & bh2 == 0, mcolor(black) symbol(Oh)) ///
	(scatter graph_order pval if group == 1, mcolor(none)), ///
	legend(off) aspect(1) ///
	ylabel(#33, valuelab angle(0) labsize(vsmall) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle({it:p}-value) title(Violence Rating, color(black)) ///
	name(violence, replace) yscale(reverse) nodraw

* graph
gr combine vote corrupt violence, col(1) ycommon xcommon ///
	graphregion(color(white)) ysize(20) xsize(10)


/*-----------------------------------------------------------------------------------------*/
/* Figure A12 */
/*-----------------------------------------------------------------------------------------*/

* load second survey
use second-survey, clear

* coding guesses about 2010 wealth
gen bad_guess2010 = ownMLA_assetBG-3
gen w2010 = _n in 1/7
lab val w2010 initialwealth 

global covar _age _schooling income _assets _occ4 

* is the right guess more likely than others? 
forval i = 1/2 {
	foreach x in g d lb ub {
		gen `x'`i'_2010 = .
		gen `x'`i'_inc = .
		}
	}
* Shekhar
qui mlogit ownMLA_assetBG $covar if MLA == "Chandra Shekhar", r
margins, post
forval i = 1/7 {
	replace g1_2010 = _b[`i'._predict] in `i'
	}
qui mlogit bad_guess2010 $covar if MLA == "Chandra Shekhar", r
margins, post
mat tab = r(table)
foreach x in 1 2 4 5 6 7 {
	lincom _b[`x'._predict]-_b[3._predict]
	replace d1_2010 = r(estimate) in `x'
	replace lb1_2010 = r(estimate)+invnormal(.025)*r(se) in `x'
	replace ub1_2010 = r(estimate)+invnormal(.975)*r(se) in `x'
	}
format g1_2010 %9.2g
twoway (bar g1_2010 w2010 if w2010 ~= 3, color(gs10)) ///
	(bar g1_2010 w2010 if w2010 == 3, color(gs5)) ///
	(rcap lb1_2010 ub1_2010 w2010, msize(0) lcolor(black)) ///
	(scatter d1_2010 w2010, msymbol(O) mcolor(black)) ///
	(scatter g1_2010 w2010, msym(none) mlab(g1_2010) mlabpos(11) mlabcolor(black)), /// 
	legend(off) xlabel(#7, valuelab) xtitle("") aspect(.7) ///
	ytitle("Proportion (bars)," "difference in probabilities (caps)") ///
	title(Chandra Shekhar) scheme(s1mono) name(m1, replace) nodraw
	
* Rishidev
qui mlogit ownMLA_assetBG $covar if MLA ~= "Chandra Shekhar", r
margins, post
forval i = 1/6 {
	replace g2_2010 = _b[`i'._predict] in `i'
	}
replace g2_2010 = 0 in 7
replace d2_2010 = _b[3._predict] in 7
replace lb2_2010 = _b[3._predict] in 7
replace ub2_2010 = _b[3._predict] in 7
qui mlogit bad_guess2010 $covar if MLA ~= "Chandra Shekhar", r
margins, post
mat tab = r(table)
foreach x in 1 2 4 5 6 {
	lincom _b[`x'._predict]-_b[3._predict]
	replace d2_2010 = r(estimate) in `x'
	replace lb2_2010 = r(estimate)+invnormal(.025)*r(se) in `x'
	replace ub2_2010 = r(estimate)+invnormal(.975)*r(se) in `x'
	}
format g2_2010 %9.2g
twoway (bar g2_2010 w2010 if w2010 ~= 3, color(gs10)) ///
	(bar g2_2010 w2010 if w2010 == 3, color(gs5)) ///
	(rcap lb2_2010 ub2_2010 w2010, msize(0) lcolor(black)) ///
	(scatter d2_2010 w2010, msymbol(O) mcolor(black)) ///
	(scatter g2_2010 w2010, msym(none) mlab(g2_2010) mlabpos(11) mlabcolor(black)), /// 
	legend(off) xlabel(#7, valuelab) xtitle("") aspect(.7) ///
	ytitle("Proportion (bars)," "difference in probabilities (caps)") ///
	title(Ramesh Rishidev) scheme(s1mono) name(m2, replace) nodraw
* graph	
gr combine m1 m2, scheme(s1mono) ycommon xsize(6) ysize(3)


/*-----------------------------------------------------------------------------------------*/
/* Figure A13 */
/*-----------------------------------------------------------------------------------------*/

* load second survey
use second-survey, clear

replace biharMLA_incBG = 1 if biharMLA_assetINC == 0
gen bad_guess_b = biharMLA_incBG-4
gen bad_guess2010_b = biharMLA_assetBG-5
gen w2010 = _n in 1/7
lab val w2010 initialwealth 
gen wmult = _n in 1/6
lab def wmult 1 "0-0.2x" 2 "2x" 3 "3x" 4 "5x" 5 "10x" 6 "30x", replace
lab val wmult wmult

* variables to store results
foreach x in 2010 inc {
	gen g_`x' = .
	gen d_`x' = .
	gen lb_`x' = .
	gen ub_`x' = .
	}
* predicted probabilities and tabulated values
* 2010 assets
qui mlogit biharMLA_assetBG $covar, r
margins, post
forval i = 1/7 {
	replace g_2010 = _b[`i'._predict] in `i'
	}
qui mlogit bad_guess2010_b $covar, r
margins, post
mat tab = r(table)
foreach x in 1 2 3 4 6 7 {
	lincom _b[`x'._predict]-_b[5._predict]
	replace d_2010 = r(estimate) in `x'
	replace lb_2010 = r(estimate)+invnormal(.025)*r(se) in `x'
	replace ub_2010 = r(estimate)+invnormal(.975)*r(se) in `x'
	}
format g_2010 %9.2g
twoway (bar g_2010 w2010 if w2010 ~= 5, color(gs10)) ///
	(bar g_2010 w2010 if w2010 == 5, color(gs5)) ///
	(rcap lb_2010 ub_2010 w2010, msize(0) lcolor(black)) ///
	(scatter d_2010 w2010, msymbol(O) mcolor(black)) ///
	(scatter g_2010 w2010, msym(none) mlab(g_2010) mlabpos(11) mlabcolor(black)), /// 
	legend(off) xlabel(#7, valuelab) xtitle("") aspect(.7) ///
	ytitle("Proportion (bars)," "difference in probabilities (caps)") ///
	title(2010 wealth) scheme(s1mono) name(m1, replace) nodraw
* 2010-2015 wealth increase
qui mlogit biharMLA_incBG $covar, r
margins, post
forval i = 1/6 {
	replace g_inc = _b[`i'._predict] in `i'
	}
qui mlogit bad_guess_b $covar, r
margins, post
mat tab = r(table)
foreach x in 1 2 3 5 6  {
	lincom _b[`x'._predict]-_b[4._predict]
	replace d_inc = r(estimate) in `x'
	replace lb_inc = r(estimate)+invnormal(.025)*r(se) in `x'
	replace ub_inc = r(estimate)+invnormal(.975)*r(se) in `x'
	}
format g_inc %9.2g
twoway (bar g_inc wmult if wmult ~= 4, color(gs10)) ///
	(bar g_inc wmult if wmult == 4, color(gs5)) ///
	(rcap lb_inc ub_inc wmult, msize(0) lcolor(black)) ///
	(scatter d_inc wmult, msymbol(O) mcolor(black)) ///
	(scatter g_inc wmult, msym(none) mlab(g_inc) mlabpos(11) mlabcolor(black)), /// 
	legend(off) xlabel(#6, valuelab) xtitle("") aspect(.7) ///
	ytitle("Proportion (bars)," "difference in probabilities (caps)") ///
	title(2010-2015 wealth increase) scheme(s1mono) name(m2, replace) nodraw
* combine
gr combine m1 m2, scheme(s1mono) xsize(6) ysize(3)


/*-----------------------------------------------------------------------------------------*/
/* Table A7 */
/*-----------------------------------------------------------------------------------------*/

use second-survey, clear

* know of disclosures AND that they are public?
gen know_dec = (know_decb4 == 1 & know_decpub == 1)

* correct or incorrect guesses of own MLA's wealth increase? 
replace ownMLA_incBG = 1 if ownMLA_assetINC == 0
gen bad_guess = ownMLA_incBG-2 if MLA == "Chandra Shekhar"
replace bad_guess = ownMLA_incBG-4 if MLA == "Ramesh Rishidev"
gen correct = (bad_guess == 0) if bad_guess ~= .
gen under = (bad_guess < 0) if bad_guess ~= .
gen over = (bad_guess > 0) if bad_guess ~= .
* correct or incorrect recall of own MLA's 2010 wealth?
gen bad_guess2010 = ownMLA_assetBG-3
gen correct2010 = (bad_guess2010 == 0) if bad_guess2010 ~= .
gen under2010 = (bad_guess2010 < 0) if bad_guess2010 ~= .
gen over2010 = (bad_guess2010 > 0) if bad_guess2010 ~= .

/* Guesses and recall of information for Bihari MLAs 
	Wealth increase: on average, 5 times
	2010 wealth: 73 lahks (closest to 85 lahks) */
* wealth increase
replace biharMLA_incBG = 1 if biharMLA_assetINC == 0
gen bad_guess_b = biharMLA_incBG-4
gen correct_b = (bad_guess_b == 0) if bad_guess_b ~= .
gen under_b = (bad_guess_b < 0) if bad_guess_b ~= .
gen over_b = (bad_guess_b > 0) if bad_guess_b ~= .
* 2010 wealth
gen bad_guess2010_b = biharMLA_assetBG-5
gen correct2010_b = (bad_guess2010_b == 0) if bad_guess2010_b ~= .
gen under2010_b = (bad_guess2010_b < 0) if bad_guess2010_b ~= .
gen over2010_b = (bad_guess2010_b > 0) if bad_guess2010_b ~= .

* covariates
recode party_support (88/98 = .) (5/7 = 5)
global covar _age _schooling income _assets _occ4  
global covar2 $covar _land b5.party _yadav1 _muslim1

* create a table to store results
mat out = J(4,6,.)
mat pval = J(4,6,1)
* results for column 1
local j = 1
foreach x in correct2010 correct2010_b correct correct_b {
	reg `x' know_dec $covar2, r
	mat tab = r(table)
	mat out[`j',1] = _b[know_dec]
	mat out[`j',2] = _se[know_dec]
	mat pval[`j',1] = tab[4,1]
	local j = `j'+1
	}
* results for column 2
local j = 1
foreach x in under2010 under2010_b under under_b {
	reg `x' know_dec $covar2, r
	mat tab = r(table)
	mat out[`j',3] = _b[know_dec]
	mat out[`j',4] = _se[know_dec]
	mat pval[`j',3] = tab[4,1]	
	local j = `j'+1
	}
* results for column 3
local j = 1
foreach x in over2010 over2010_b over over_b {
	reg `x' know_dec $covar2, r
	mat tab = r(table)
	mat out[`j',5] = _b[know_dec]
	mat out[`j',6] = _se[know_dec]
	mat pval[`j',5] = tab[4,1]
	local j = `j'+1
	}
local R = rowsof(out)
local C = colsof(out)
mat stars = J(`R',`C',0)
forval i = 1/`R' {
	forval j = 1/`C' {
		local pval = pval[`i',`j']
		if `pval' <= .10 & `pval' > .05 {
			matrix stars[`i',`j'] = 1
			}
		if `pval' <= .05 & `pval' > .01 {
			matrix stars[`i',`j'] = 2 
			}
		if `pval' <= .01 {
			matrix stars[`i',`j'] = 3
			}
		}
	}
frmttable, clear
frmttable, statmat(out) substat(1) sdec(2) annotate(stars) asymbol(*,**,***) ///
	rtitles("Own MLA--2010 wealth" \ "" \ "Ave. Bihar MLA--2010 wealth" \ "" \ ///
	"Own MLA--2010-2015 wealth increase" \ "" \ "Ave. Bihar MLA--2010-2015 wealth increase" \ "") ///
	tex fragment statfont(fs11) hlines(11{0}1) noblankrows ///
	ctitles("","Correct","Under-estimate","Over-estimate") ///
	title("\caption{Knowledge of disclosures and precision of information and guesses\label{tab:know-dec-guesses}}\leavevmode") ///
	titlfont(normalsize)
	

/*-----------------------------------------------------------------------------------------*/
/* Figure A14 */
/*-----------------------------------------------------------------------------------------*/

prog drop _all
* set matrices to export results
program define matprep
	use conjoint-survey, clear
	mat wi1 = J(2,2,.)
	mat wi2 = J(2,2,.)
	mat wi3 = J(2,2,.)
end

* export results to matrices
program define matexp
	args x /* intx var */
	forval i = 2/3 {
		local j = `i'-1
		mat wi1[`j',1] = _b[`i'.wmultr]
		mat wi1[`j',2] = _se[`i'.wmultr]
		}
	forval i = 2/3 {
		local j = `i'-1
		lincom `i'.wmultr + `x'#`i'.wmultr
		local b = r(estimate)
		local se = r(se)
		mat wi2[`j',1] = `b'
		mat wi2[`j',2] = `se'
		}
	forval i = 2/3 {
		local j = `i'-1
		mat wi3[`j',1] = _b[`x'#`i'.wmultr]
		mat wi3[`j',2] = _se[`x'#`i'.wmultr]
		}
end
		
* prepare data to use for graphs
program define gprep
	clear
	forval i = 1/3 {
		svmat wi`i'
		rename wi`i'1 b`i'
		rename wi`i'2 se`i'
		gen lb`i' = b`i' + invnormal(.025)*se`i'
		gen ub`i' = b`i' + invnormal(.975)*se`i'
		}
	* graph
	local newn = _N+1
	set obs `newn'
	forval i = 1/3 {
		foreach x in b lb ub {
			replace `x'`i' = 0 if `x'`i' == .
			}
		}
	gen order = .
	local m 2 3 1
	local k = 1
	foreach j of local m {
		replace order = `j' in `k'
		local k = `k' + 1
		}
	sort order
end

* create graphs
program define gcreate
	args x y /* graph names, axis labels */
	gen label = "No increase" in 1
	replace label = "Below median" in 2 
	replace label = "Above median" in 3
	local obs = _N
	forval i = 1/`obs' {
		local name = label in `i'
		label define order `i' "`name'", modify
		}
	label values order order
	twoway (scatter order b1, mcolor(black)) ///
		(rcap lb1 ub1 order, horizontal msize(0) lcolor(black)), ///
		legend(off) ylabel(#3, valuelab angle(0) notick ///
		glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
		graphregion(color(white)) yscale(reverse) ///
		ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
		yscale(lcolor(white)) xscale(lcolor(white) range(-.4(.1).2)) ///
		xtitle("Pr(voting for candidate)") aspect(1) title(`x', color(black)) ///
		name(l1, replace) nodraw
	twoway (scatter order b2, mcolor(black)) ///
		(rcap lb2 ub2 order, horizontal msize(0) lcolor(black)), ///
		legend(off) ylabel(#3, nolabels noticks) ///
		plotregion(color(gs13) lcolor(white)) ///
		graphregion(color(white)) yscale(reverse) ///
		ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
		yscale(lcolor(white)) xscale(lcolor(white) range(-.4(.1).2)) ///
		xtitle("Pr(voting for candidate)") aspect(1) title(`y', color(black)) ///
		name(l2, replace) nodraw
	twoway (scatter order b3, mcolor(black)) ///
		(rcap lb3 ub3 order, horizontal msize(0) lcolor(black)), ///
		legend(off) ylabel(#3, valuelab angle(0) notick ///
		glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
		graphregion(color(white)) yscale(reverse alt) ///
		ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
		yscale(lcolor(white)) xscale(lcolor(white) range(-.4(.1).2)) ///
		xtitle("Pr(voting for candidate)") aspect(1) title("Difference", color(black)) ///
		name(l3, replace) nodraw
end

* Record
matprep
ivregress 2sls dv_vote i.photo i.dist i.out_party i.family ///
	i.crime i.record##w2010r i.record##i.wmultr##i.legal ///
	(non_co_ethn = co_ethn_dummy), cl(id)
matexp 2.record
gprep
gcreate "Good record" "Bad record" 
gr combine l1 l2 l3, row(1) ycommon xcommon ///
	graphregion(color(white)) xsize(7) ysize(2) ///
	title("Record", color(black)) name(record, replace) nodraw

* Party
matprep	
ivregress 2sls dv_vote i.photo i.dist i.record i.family i.crime ///
	i.out_party##w2010r i.out_party##i.wmultr##i.legal ///
	(non_co_ethn = co_ethn_dummy), cl(id)
matexp 1.out_party
gprep	
gcreate "Co-partisan" "Non-co-partisan"
gr combine l1 l2 l3, row(1) ycommon xcommon ///
	graphregion(color(white)) xsize(7) ysize(2) ///
	title("Party", color(black)) name(party, replace) nodraw
* Ethnicity
matprep
reg dv_vote i.photo i.dist i.out_party i.record i.family ///
	i.crime i.non_co_ethn##w2010r i.non_co_ethn##i.wmultr##i.legal, cl(id)
matexp 1.non_co_ethn
gprep
gcreate "Co-ethnic" "Non-co-ethnic"
gr combine l1 l2 l3, row(1) ycommon xcommon ///
	graphregion(color(white)) xsize(7) ysize(2) ///
	title("Ethnicity", color(black)) name(ethnicity, replace) nodraw
* all combined
gr combine record party ethnicity, row(3) ycommon xcommon ///
	graphregion(color(white)) iscale(.5) xsize(6) ysize(6)
	

/*-----------------------------------------------------------------------------------------*/
/* Table A8 */
/*-----------------------------------------------------------------------------------------*/

cap prog drop matexp
program define matexp
	args z /* z = matrix number -- which moderator */
	mat coef = e(b)
	mat var = vecdiag(e(V))
	matmap var se, m(sqrt(@))
	mat coef = coef', se'
	* eliminate constant
	scalar R = rowsof(coef)-1
	mat coef = coef[1..R,1..2]
	* put into a dataset
	* separate for below and above median wealth increase
	forval h = 2/3 {
		clear
		svmat coef
		gen names = ""
		local names : rownames coef
		local k = 1
		foreach j of local names {
			replace names = "`j'" in `k'
			local k = `k' + 1
			}
		gen keep1 = regexm(names, "`h'.wmultr")
		keep if keep1 == 1
		gen drop1 = regexm(names, "legal")
		drop if drop1 == 1
		gen drop2 = regexm(names, "o.")
		drop if drop2 == 1
		gen drop3 = regexm(names, "b.")
		drop if drop3 == 1
		drop drop* keep
		gen pval = (1-normal(abs(coef1/coef2)))*2
		local new = _N+1
		set obs `new'
		local last = _N
		gen order = 1 in `last'
		local pen = `last'-1
		replace order = _n+1 in 1/`pen'
		sort order
		mkmat coef1 coef2, mat(r`z'_`h')
		mkmat pval, mat(p`z'_`h')
		}
end

* initial wealth X wealth increase
use conjoint-survey, clear
ivregress 2sls dv_vote i.photo i.dist i.out_party i.family ///
	i.crime i.wmultr##i.legal##w2010r (non_co_ethn = co_ethn_dummy), cl(id)
matexp 1
* family background X wealth increase
use conjoint-survey, clear
ivregress 2sls dv_vote i.photo i.dist i.out_party ///
	i.crime w2010r i.wmultr##i.legal##i.family (non_co_ethn = co_ethn_dummy), cl(id)
matexp 2
* crime X wealth increase
use conjoint-survey, clear
ivregress 2sls dv_vote i.photo i.dist i.out_party i.family ///
	w2010r i.wmultr##i.legal##i.crime (non_co_ethn = co_ethn_dummy), cl(id)
matexp 3
* join matrices
forval h = 2/3 {
	matrix res_`h' = r1_`h'\r2_`h'\r3_`h'
	matrix pv_`h' = p1_`h'\p2_`h'\p3_`h'
	local rnum = rowsof(pv_`h')
	matrix stars_`h' = J(`rnum',1,.)
	forval i = 1/`rnum' {
		local pval = pv_`h'[`i',1]
		if `pval' <= .10 & `pval' > .05 {
			matrix stars_`h'[`i',1] = 1
			}
		if `pval' <= .05 & `pval' > .01 {
			matrix stars_`h'[`i',1] = 2
			}
		if `pval' <= .01 & `pval' ~= . {
			matrix stars_`h'[`i',1] = 3
			}
		if `pval' > .10 & `pval' ~= . {
			matrix stars_`h'[`i',1] = 0
			}
		if `pval' == . {
			matrix stars_`h'[`i',1] = 0
			}
		}
	}
* format table
frmttable, clear
forval i = 2/3 {
	frmttable, statmat(res_`i') substat(1) sdec(3) annotate(stars_`i') ///
	asymbol(*,**,***) ///
	rtitles("\textbf{2010 wealth}" ///
		\ "" \ "\hspace{1em} $@$ Below median 2010 wealth" \ "" \ "\hspace{1em} $\times$ Median -- 75th pctile" ///
		\ "" \ "\hspace{1em} $\times$ Above 75th pctile" ///
		\ "" \ "\textbf{Family background}" ///
		\ "" \ "\hspace{1em} $@$ Poor family" \ "" \ "\hspace{1em} $\times$ Middle-class family" ///
		\ "" \ "\hspace{1em} $\times$ Rich family" ///
		\ "" \ "\textbf{Criminality}" /// 
		\ "" \ 	"\hspace{1em} $@$ No criminal record" \ "" \ "\hspace{1em} $\times$ Criminal record" ///
		\ "" ) ///
	merge
	}
frmttable, tex fragment ///
	hlines(101{0}1) statfont(fs11) ///
	ctitles("","Below median","Above median" \ "","wealth increase","wealth increase") ///
	title("\caption{Interaction between wealth increase and initial wealth, family background, and criminality\label{tab:intx_w2010_family_crime}}\leavevmode") ///
	titlfont(normalsize) noblankrows
	

/*-----------------------------------------------------------------------------------------*/
/* Table A9 */
/*-----------------------------------------------------------------------------------------*/

cap prog drop matexp
program define matexp
	args z /* z = matrix number -- which moderator */
	mat coef = e(b)
	mat var = vecdiag(e(V))
	matmap var se, m(sqrt(@))
	mat coef = coef', se'
	* eliminate constant
	scalar R = rowsof(coef)-1
	mat coef = coef[1..R,1..2]
	* put into a dataset
	* separate for below and above median wealth increase
	forval h = 2/3 {
		clear
		svmat coef
		gen names = ""
		local names : rownames coef
		local k = 1
		foreach j of local names {
			replace names = "`j'" in `k'
			local k = `k' + 1
			}
		gen keep1 = regexm(names, "`h'.wmultr")
		keep if keep1 == 1
		gen drop1 = regexm(names, "legal")
		drop if drop1 == 1
		drop drop* keep
		
		gen pval = (1-normal(abs(coef1/coef2)))*2
		
		local new = _N+1
		set obs `new'
		local last = _N
		gen order = 1 in `last'
		local pen = `last'-1
		replace order = _n+1 in 1/`pen'
		sort order
		mkmat coef1 coef2, mat(r`z'_`h')
		mkmat pval, mat(p`z'_`h')
		}
end

use conjoint-survey, clear
* create factor income scale
preserve
collapse _land-_income, by(id)
replace _income = ln(_income)
xi i._land i._house 
factor _I_land* _I_house* _rooms-_income
predict inc, reg
egen income = std(inc)
keep id income
tempfile income
save `income'
restore
merge m:1 id using `income'
drop _merge
egen subset = cut(income), group(4)
replace subset = subset + 1
		
ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.crime i.family ///
	i.w2010r##i.subset i.wmultr##i.legal##i.subset (non_co_ethn = co_ethn_dummy), ///
	cl(id)
matexp 1
* join matrices
forval h = 2/3 {
	matrix res_`h' = r1_`h'
	matrix pv_`h' = p1_`h'
	local rnum = rowsof(pv_`h')
	matrix stars_`h' = J(`rnum',1,.)
	forval i = 1/`rnum' {
		local pval = pv_`h'[`i',1]
		if `pval' <= .10 & `pval' > .05 {
			matrix stars_`h'[`i',1] = 1
			}
		if `pval' <= .05 & `pval' > .01 {
			matrix stars_`h'[`i',1] = 2
			}
		if `pval' <= .01 & `pval' ~= . {
			matrix stars_`h'[`i',1] = 3
			}
		if `pval' > .10 & `pval' ~= . {
			matrix stars_`h'[`i',1] = 0
			}
		if `pval' == . {
			matrix stars_`h'[`i',1] = 0
			}
		}
	}
frmttable, clear	
forval i = 2/3 {
	frmttable, statmat(res_`i') substat(1) sdec(3) annotate(stars_`i') ///
	asymbol(*,**,***) ///
	rtitles("\textbf{Respondent wealth}" ///
		\ "" \ "\hspace{1em} $@$ Lowest quartile" \ "" \ "\hspace{1em} $\times$ 2nd quartile" ///
		\ "" \ "\hspace{1em} $\times$ 3rd quartile" \ "" \ "\hspace{1em} $\times$ Highest quartile" ///
		\ "" ) ///
	merge
	}
frmttable, tex fragment ///
	hlines(101{0}1) statfont(fs11) ///
	ctitles("","Below median","Above median" \ "","wealth increase","wealth increase") ///
	title("\caption{Interaction between wealth increase and respondent wealth\label{tab:intx_resp_income}}\leavevmode") ///
	titlfont(normalsize) noblankrows

	
/*-----------------------------------------------------------------------------------------*/
/* Figure A15 */
/*-----------------------------------------------------------------------------------------*/

use conjoint-survey, clear

* first calculate legality AMCE based on all levels
qui ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010 i.wmult##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
lincom (1.legal + (2.wmult#1.legal + 3.wmult#1.legal + 4.wmult#1.legal ///
	+ 5.wmult#1.legal + 6.wmult#1.legal)*(1/6))*(-1)
global legal_b = r(estimate)
global legal_se = r(se)
global legal_pval = (1-normal(abs(r(estimate)/r(se))))*2

* then store the relevant results in a matrix
ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010 i.wmult##i.legal (non_co_ethn = co_ethn_dummy), cl(id)

mat coef = e(b)
mat var = vecdiag(e(V))
matmap var se, m(sqrt(@))
mat tab = r(table)
scalar C = colsof(tab)
mat tab = tab[4..4,1..C]
mat coef = coef', se',tab'
* eliminate constant
scalar R = rowsof(coef)-1
mat coef = coef[1..R,1..3]
* put into a dataset
clear
svmat coef
* eliminate the legality terms, photo and district
gen names = ""
local names : rownames coef
local k = 1
foreach j of local names {
	replace names = "`j'" in `k'
	local k = `k' + 1
	}
gen drop1 = regexm(names, "legal")
gen drop2 = regexm(names, "photo")
gen drop3 = regexm(names, "dist")
egen drop = rowtotal(drop*)
drop if drop == 1
drop drop*
* reorder ethnicity and add base category
expand 3 in 1
drop in 1
local pu = _N-1
foreach x in coef1 coef2 {
	replace `x' = 0 in `pu'
	}
replace names = "1b.non_co_ethn" in `pu'
replace coef3 = . if names == "1b.non_co_ethn"

* add legality AMCE
local newn = _N+2
set obs `newn'
local pu = _N-1
foreach x in coef1 coef2 {
	replace `x' = 0 in `pu'
	}
replace names = "1b.legal" in `pu'
replace coef1 = $legal_b in `newn'
replace coef2 = $legal_se in `newn'
replace coef3 = $legal_pval in `newn'
replace names = "2.legal" in `newn'
gen lb = coef1 + invnormal(.025)*coef2
gen ub = coef1 + invnormal(.975)*coef2

local m 2 3 8 9 14 15 16 11 12 18 19 20 21 22 23 24 26 27 28 29 30 31 32 5 6 34 35 
gen merge = .
local k = 1
foreach j of local m {
	replace merge = `j' in `k'
	local k = `k' + 1
	}
save graph_temp, replace
clear
set obs 8
local m 1 4 7 10 13 17 25 33
gen merge = .
local k = 1
foreach j of local m {
	replace merge = `j' in `k'
	local k = `k' + 1
	}
gen group = 1
	
merge 1:1 merge using graph_temp
sort merge
drop _m
foreach x in coef1 lb ub {
	replace `x' = 0 if `x' == .
	}
gen label = ""
for any "Co-partisanship:" "Yes" "No" "Co-ethnicity:" "Yes" "No" ///
	"Record:" "Good" "Bad" "Criminality:" "No" "Yes" ///
	"Background:" "Poor" "Middle-income" "Rich" "2010 wealth:" ///
	"5 lakh" "8 lakh" "20 lakh" "45 lakh" "85 lakh" "2 crore" "4 crore" ///
	"Wealth increase:" "No increase" "0.2x" "2x" "3x" "5x" "10x" "30x" ///
	"Illegal wealth incr.:" "No" "Yes" \ any 1 2 3 4 5 6 7 8 9 10 11 12 ///
	13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35: ///
	replace label = "X" in Y
	
replace label = "Yes" if label == "2es"
replace label = "Yes" if label == "5es"
replace label = "Yes" if label == "12es"
replace label = "Yes" if label == "35es"
replace label = "{bf:" + label if group == 1
replace label = label + "}" if group == 1
gen order = _n
sort order
local obs = _N
forval i = 1/`obs' {
	local name = label in `i'
	label define order `i' "`name'", modify
	}
label values order order

* coefs and pvalues for showing on second y-axis
gen coef = coef1
gen pval = coef3
foreach x in coef pval {
	tostring `x', replace force format(%9.2f)
	}
gen b1 = "["
gen b2 = "]"
egen pvala = concat(b1 pval b2)
replace pvala = "" if pvala == "[.]"
egen both = concat(coef pvala), punct(" ")
replace both = " " if both == "0.00"
	
gen order2 = _n
local obs = _N
forval i = 1/`obs' {
	local name = both in `i'
	lab def order2 `i' "`name'", modify
	}
lab val order2 order2

twoway (scatter order coef1 if group == ., mcolor(black)) ///
	(scatter order coef1 if group == 1, mcolor(none)) ///
	(scatter order2 coef1, mcolor(none) yaxis(2)) ///
	(rcap ub lb order, horizontal msize(0) lcolor(black)), ///
	plotregion(color(gs13) lcolor(white)) ///
	legend(off) ///
	ylabel(#35, valuelab angle(0) labsize(small) notick glcolor(white) axis(2)) ///
	ylabel(#35, valuelab angle(0) labsize(small) notick glcolor(white)) ///
	yscale(reverse lcolor(white)) yscale(reverse lcolor(white) axis(2)) ///
	graphregion(color(white)) ///
	ytitle("") ytitle("", axis(2)) ///
	xline(0, lcolor(black) lwidth(vvthin)) ///
	xscale(lcolor(white)) ///
	xtitle("Effect on Pr(voting for candidate)")
	gr_edit yaxis2.style.editstyle draw_major_grid(yes) editcopy

erase graph_temp.dta


/*-----------------------------------------------------------------------------------------*/
/* Figures A16, A17, and A18 */
/*-----------------------------------------------------------------------------------------*/

* program to draw graphs with different DVs
cap prog drop graph_amce
program define graph_amce
	args y w /* y = outcome variable 
				w = x-axis label */
	
	use conjoint-survey, clear
	
	* first calculate legality AMCE based on all levels
	ivregress 2sls `y' i.photo i.dist i.out_party i.record i.family i.crime ///
		i.w2010 i.wmult##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
	lincom (1.legal + (2.wmult#1.legal + 3.wmult#1.legal + 4.wmult#1.legal ///
			+ 5.wmult#1.legal + 6.wmult#1.legal)*(1/6))*(-1)
	global legal_b = r(estimate)
	global legal_se = r(se)
	di $legal_b
	* then store the relevant results in a matrix
	ivregress 2sls `y' i.photo i.dist i.out_party i.record i.family i.crime ///
		i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
		
	mat coef = e(b)
	mat var = vecdiag(e(V))
	matmap var se, m(sqrt(@))
	mat coef = coef', se'
	* eliminate constant
	scalar R = rowsof(coef)-1
	mat coef = coef[1..R,1..2]
	* put into a dataset
	*preserve
	clear
	svmat coef
	* eliminate the legality terms, photo and district
	gen names = ""
	local names : rownames coef
	local k = 1
	foreach j of local names {
		replace names = "`j'" in `k'
		local k = `k' + 1
		}
	gen drop1 = regexm(names, "legal")
	gen drop2 = regexm(names, "photo")
	gen drop3 = regexm(names, "dist")
	egen drop = rowtotal(drop*)
	drop if drop == 1
	drop drop*

	* reorder ethnicity and add base category
	expand 3 in 1
	drop in 1
	local pu = _N-1
	foreach x in coef1 coef2 {
		replace `x' = 0 in `pu'
		}
	replace names = "1b.non_co_ethn" in `pu'

	* add legality AMCE
	local newn = _N+2
	set obs `newn'
	local pu = _N-1
	foreach x in coef1 coef2 {
		replace `x' = 0 in `pu'
		}
	replace names = "1b.legal" in `pu'
	replace coef1 = $legal_b in `newn'
	replace coef2 = $legal_se in `newn'
	replace names = "2.legal" in `newn'

	gen lb = coef1 + invnormal(.025)*coef2
	gen ub = coef1 + invnormal(.975)*coef2

	local m 2 3 8 9 14 15 16 11 12 18 19 20 22 23 24 5 6 26 27

	gen merge = .
	local k = 1
	foreach j of local m {
		replace merge = `j' in `k'
		local k = `k' + 1
		}
	save graph_temp, replace

	clear
	set obs 8
	local m 1 4 7 10 13 17 21 25
	gen merge = .
	local k = 1
	foreach j of local m {
		replace merge = `j' in `k'
		local k = `k' + 1
		}
	gen group = 1
		
	merge 1:1 merge using graph_temp
	sort merge
	drop _m
	foreach x in coef1 lb ub {
		replace `x' = 0 if `x' == .
		}

	gen label = ""
	for any "Co-partisanship:" "Yes" "No" "Co-ethnicity:" "Yes" "No" ///
		"Record:" "Good" "Bad" "Criminality:" "No" "Yes" ///
		"Background:" "Poor" "Middle-income" "Rich" "2010 wealth:" ///
		"Below median" "Median--75 pctile" "Above 75 pctile" ///
		"Wealth increase:" "No increase" "Below median" "Above median" ///
		"Illegal wealth incr.:" "No" "Yes" \ any 1 2 3 4 5 6 7 8 9 10 11 12 ///
		13 14 15 16 17 18 19 20 21 22 23 24 25 26 27: ///
		replace label = "X" in Y
		
	replace label = "Yes" if label == "2es"
	replace label = "Yes" if label == "5es"
	replace label = "Yes" if label == "12es"
	replace label = "Yes" if label == "27es"
	replace label = "{bf:" + label if group == 1
	replace label = label + "}" if group == 1

	gen order = _n
	sort order

	local obs = _N
	forval i = 1/`obs' {
		local name = label in `i'
		label define order `i' "`name'", modify
		}
	label values order order
		
	twoway (scatter order coef1 if group == ., mcolor(black)) ///
		(scatter order coef1 if group == 1, mcolor(none)) ///
		(rcap ub lb order, horizontal msize(0) lcolor(black)), ///
		legend(off) yscale(reverse) ///
		ylabel(#27, valuelab angle(0) labsize(vsmall) notick ///
		glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
		graphregion(color(white)) ///
		ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
		yscale(lcolor(white)) xscale(lcolor(white)) ///
		xtitle(`w')

	erase graph_temp.dta
end

* Corruption rating
graph_amce dv_corrupt "Effect on corruption rating"

* Violence rating	
graph_amce dv_violence "Effect on violence rating"

* Representation rating
graph_amce dv_repr "Effect on representation rating"

* Personal usefulness rating (Figure A18)
graph_amce dv_person "Effect on personal usefulness rating"


/*-----------------------------------------------------------------------------------------*/
/* Table A10 */
/*-----------------------------------------------------------------------------------------*/

program define photo_district
	args y z /* y = outcome variable 
			z = matrix number */

	use conjoint-survey, clear
	ivregress 2sls `y' i.photo i.dist i.out_party i.record i.family i.crime ///
		i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
		
	mat coef = e(b)
	mat var = vecdiag(e(V))
	matmap var se, m(sqrt(@))
	mat coef = coef', se'
	* keep only the photo and district coefficients
	clear
	svmat coef
	gen names = ""
	local names : rownames coef
	local k = 1
	foreach j of local names {
		replace names = "`j'" in `k'
		local k = `k' + 1
		}
	gen keep1 = regexm(names, "photo")
	gen keep2 = regexm(names, "dist")
	egen keep = rowtotal(keep*)
	keep if keep == 1
	drop keep*
	
	gen order = _n+1 in 1/6
	replace order = _n+2 in 7/14
	local newn = _N+2
	set obs `newn'
	replace order = 1 in 15
	replace order = 8 in 16
	sort order
	
	forval i = 1/2 {
		replace coef`i' = . if coef`i' == 0
		}
	* back to matrices
	mkmat coef1 coef2, matrix(r`z')
	gen pval = (1-normal(abs(coef1/coef2)))*2
	mkmat pval, matrix(p`z')
	local rnum = rowsof(r`z')
	matrix stars`z' = J(`rnum',1,.)
	forval i = 1/`rnum' {
		local pval = p`z'[`i',1]
		if `pval' <= .10 & `pval' > .05 {
			matrix stars`z'[`i',1] = 1
			}
		if `pval' <= .05 & `pval' > .01 {
			matrix stars`z'[`i',1] = 2
			}
		if `pval' <= .01 & `pval' ~= . {
			matrix stars`z'[`i',1] = 3
			}
		if `pval' > .10 & `pval' ~= . {
			matrix stars`z'[`i',1] = 0
			}
		if `pval' == . {
			matrix stars`z'[`i',1] = 0
			}
		}
	
	use conjoint-survey, clear
	* check interactions with wealth increase
	ivregress 2sls `y' i.photo##i.wmultr##i.legal i.dist##i.wmultr##i.legal i.out_party ///
		i.record i.family i.crime i.w2010r (non_co_ethn = co_ethn_dummy), cl(id)
	test 2.photo#2.wmultr 2.photo#3.wmultr 3.photo#2.wmultr 3.photo#3.wmultr ///
		4.photo#2.wmultr 4.photo#3.wmultr 5.photo#2.wmultr 5.photo#3.wmultr ///
		6.photo#2.wmultr 6.photo#3.wmultr
	matrix s[1,`z'] = r(p)
	test 2.dist#2.wmultr 2.dist#3.wmultr 3.dist#2.wmultr 3.dist#3.wmultr ///
		4.dist#2.wmultr 4.dist#3.wmultr 5.dist#2.wmultr 5.dist#3.wmultr ///
		6.dist#2.wmultr 6.dist#3.wmultr 7.dist#2.wmultr 7.dist#3.wmultr ///
		8.dist#2.wmultr 8.dist#3.wmultr
	matrix s[2,`z'] = r(p)
end

matrix s = J(2,3,.)
local j = 1
* results for three different DVs
foreach x in dv_vote dv_corrupt dv_violence {
	photo_district `x' `j'
	local j = `j' + 1
	}
* format results into table
frmttable, clear
forval i = 1/3 {
	frmttable, statmat(r`i') substat(1) sdec(3) annotate(stars`i') ///
		asymbol(*,**,***) ///
	rtitles("\textbf{Photograph}" \ "" \ "\hspace{1em} \emph{Base: Photo 1}" \ "" \ "\hspace{1em} Photo 2" \ "" \ ///
		"\hspace{1em} Photo 3" \ "" \ "\hspace{1em} Photo 4" \ "" \ "\hspace{1em} Photo 5" \ "" \ ///
		"\hspace{1em} Photo 6" \ "" \ "\textbf{District}" \ "" \ "\hspace{1em} \emph{Base: Banka}" \ "" \ ///
		"\hspace{1em} Jahanabad" \ "" \ "\hspace{1em} Katihar" \ "" \ "\hspace{1em} Lakhisarai" \ "" \ ///
		"\hspace{1em} Madhubani" \ "" \ "\hspace{1em} Muzaffarpur" \ "" \ "\hspace{1em} Navada" \ "" \ ///
		"\hspace{1em} Samastipur") merge
		}
frmttable, statmat(s) sdec(3) append rtitles("Photo $\times$ wealth increase (\emph{F}-test \emph{p}-value)" \ ///
	"District $\times$ wealth increase (\emph{F}-test \emph{p}-value)")
frmttable, tex fragment ///
	hlines(11{0}101) statfont(fs11) ///
	ctitles("","Vote","Corruption","Violence") ///
	title("\caption{Photo and district effects\label{tab:photo_district}}\leavevmode") ///
	titlfont(normalsize) noblankrows 

	
/*-----------------------------------------------------------------------------------------*/	
/* Figure A19 */
/*-----------------------------------------------------------------------------------------*/

use conjoint-survey, clear
* matrices to store results
matrix legal1 = J(5,3,.)
reg dv_vote i.wmult if legal == 1, cl(id)
forval i = 1/5 {
	local j = `i'+2
	matrix legal1[`i',1] = _b[`j'.wmult]
	matrix legal1[`i',2] = _b[`j'.wmult] + invnormal(.025)*_se[`j'.wmult]
	matrix legal1[`i',3] = _b[`j'.wmult] + invnormal(.975)*_se[`j'.wmult]
	}
matrix legal2 = J(5,3,.)
reg dv_vote i.wmult if legal == 2, cl(id)
forval i = 1/5 {
	local j = `i'+2
	matrix legal2[`i',1] = _b[`j'.wmult]
	matrix legal2[`i',2] = _b[`j'.wmult] + invnormal(.025)*_se[`j'.wmult]
	matrix legal2[`i',3] = _b[`j'.wmult] + invnormal(.975)*_se[`j'.wmult]
	}
clear
svmat legal1
svmat legal2
expand 2 in 1
local N = _N
forval i = 1/3 {
	replace legal1`i' = 0 in `N'
	replace legal2`i' = 0 in `N'
	}
gen order = _n in 1/5
replace order = order + 1
replace order = 1 in `N'
sort order
label define order 1 "0.2x" 2 "2x" 3 "3x" 4 "5x" ///
	5 "10x" 6 "30x", replace
label values order order
* wealth increase AMCEs with no suspicion of illegality
twoway (scatter order legal11, mcolor(black)) ///
	(rcap legal12 legal13 order, horizontal msize(0) lcolor(black)), ///
	legend(off) yscale(reverse) aspect(1) ///
	ylabel(#6, valuelab angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white) range(-.3(.1).1)) ///
	xtitle("Effect on Pr(vote for candidate)") name(legal1, replace) ///
	title("No Suspicion of Illegality", color(black)) nodraw
* wealth increase AMCEs with suspicion of illegality
twoway (scatter order legal21, mcolor(black)) ///
	(rcap legal22 legal23 order, horizontal msize(0) lcolor(black)), ///
	legend(off) yscale(reverse) aspect(1) ///
	ylabel(#6, valuelab angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white) range(-.3(.1).1)) ///
	xtitle("Effect on Pr(vote for candidate)") name(legal2, replace) ///
	title("Suspicion of Illegality", color(black)) nodraw
* combined graph
gr combine legal1 legal2, row(1) ycommon xcommon ///
	graphregion(color(white)) ysize(2.5)


/*-----------------------------------------------------------------------------------------*/	
/* Table A11 */
/*-----------------------------------------------------------------------------------------*/

use conjoint-survey, clear
recode _trust_media (8 = .)
gen trust = (_trust_media > 4) if _trust_media ~= .
matrix out1 = J(6,6,.)
matrix out2 = J(6,6,.)
mat pval1 = J(6,6,1)
mat pval2 = J(6,6,1)
forval a = 1/2 {
	qui logit dv_vote i.wmult##i.legal##i.trust, cl(id)
	margins, at(trust = (0 1) wmult=(2(1)7) legal=`a') post
	mat tab = r(table)
	forval i = 2/7 {
		di "wmult level: `i'"
		local j = (`i'-1)*2-1
		local k = `j'+1
		local r = `i'-1
		mat out`a'[`r',1] = _b[`k'._at]
		mat out`a'[`r',2] = _se[`k'._at]
		mat out`a'[`r',3] = _b[`j'._at]
		mat out`a'[`r',4] = _se[`j'._at]
		lincom _b[`k'._at]-_b[`j'._at]
		mat out`a'[`r',5] = r(estimate)
		mat out`a'[`r',6] = r(se)
		mat pval`a'[`r',5] = (1-normal(abs(r(estimate)/r(se))))*2
		}
	}
mat out = out1,out2
mat pval = pval1,pval2
local R = rowsof(out)
local C = colsof(out)
mat stars = J(`R',`C',0)
forval i = 1/`R' {
	forval j = 1/`C' {
		local pval = pval[`i',`j']
		if `pval' <= .10 & `pval' > .05 {
			matrix stars[`i',`j'] = 1
			}
		if `pval' <= .05 & `pval' > .01 {
			matrix stars[`i',`j'] = 2 
			}
		if `pval' <= .01 {
			matrix stars[`i',`j'] = 3
			}
		}
	}
frmttable, clear
frmttable, statmat(out) substat(1) sdec(2) annotate(stars) asymbol(*,**,***) ///
	rtitles("0.2x" \ "" \ "2x" \ "" \ "3x" \ "" \ "5x" \ "" \ "10x" \ "" \ ///
	"30x" \ "")
frmttable, tex fragment ///
	statfont(fs11) hlines(1001{0}1) vlines(00001{0}) noblankrows ///
	ctitles("","Wealth increase with","","","Wealth increase with","","" \ ///
	"","no suspicion of illegality","","","suspicion of illegality","","" \ ///
	"","High trust","Low trust","Diff","High trust","Low trust","Diff") ///
	multicol(1,2,3;1,5,3;2,2,3;2,5,3) ///
	title("\caption{Results by trust in media\label{tab:media-trust}}\leavevmode") ///
	titlfont(normalsize)
	
/*-----------------------------------------------------------------------------------------*/
/* Figure A20 */
/*-----------------------------------------------------------------------------------------*/

use conjoint-survey, clear

logit dv_vote i.record i.wmult##i.legal, cl(id)
margins, at(record=(1 2) wmult=(2 7) legal = (1 2)) post
mat tab = r(table)
lincom _b[4._at]-_b[5._at]
foreach x in est lb ub {
	gen `x' = .
	}
forval i = 4/5 {
	local j = `i'-3
	replace est = tab[1,`i'] in `j'
	replace lb = tab[5,`i'] in `j'
	replace ub = tab[6,`i'] in `j'
	}
replace est = r(estimate) in 3
replace lb = r(estimate)+invnormal(.025)*r(se) in 3
replace ub = r(estimate)+invnormal(.975)*r(se) in 3
gen order = _n in 1/3
lab def order 1 `""Good record, high" "suspicious" "wealth increase""' ///
	2 `""Bad record, low" "unsuspicious" "wealth increase""' ///
	3 "Difference", replace
lab val order order
twoway (scatter order est, msymbol(O) mcolor(black)) ///
	(rcap lb ub order, lcolor(black) msize(0) horizontal), ///
	legend(off) ylabel(#3, valuelab angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) yscale(reverse) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Pr(voting for candidate)") aspect(1)


* clear all graphs
gr drop _all
