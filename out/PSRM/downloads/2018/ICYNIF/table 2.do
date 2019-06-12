/*******************************************************************************
This file replicates Table 2.
*******************************************************************************/

use dataset, clear
gen adtarget = ""
gen study = .
gen n = .
gen match = .

*** loop over the target-study combinations ***

local demographics = "age1824_4 age25plus_4 noba_4 baorhigher_4 white_2 black_2" 
local behavior = "veryliberal_5 liberal_5 democrat_5 donate_5"
local location = "atlanta_3 charlotte_3 memphis_4 memphis_2 seattle_3 stpetersburg_3 toledo_3 zip_1 zip_2 zip_6"

local k = 1
local m = 1
qui: {
foreach targetgroup in "`demographics'" "`behavior'" "`location'" {

	local j = 1	

	foreach targetstudy in `targetgroup' {	

		if `j' == 1 & `m' == 1 replace adtarget = "\emph{Demographics:}" if _n == `k'
		if `j' == 1 & `m' == 2 replace adtarget = "\emph{Behavior:}" if _n == `k'
		if `j' == 1 & `m' == 3 replace adtarget = "\emph{Location:}" if _n == `k'
		if `j' == 1 local k = `k' + 1
		
		gen x = "`targetstudy'"
		split x, parse("_")
		local target = x1[1]
		local study = x2[1]
		di "`target'"
		su `target' if target_`target' == 1 & studynumber == `study'
		replace adtarget = "`target'" if _n == `k'
		replace study = `study' if _n == `k'
		replace n = r(N) if _n == `k'
		replace match = r(mean) if _n == `k'

		drop x*

		local j = `j' + 1
		local k = `k' + 1
	
	}

	local m = `m' + 1

}
}

*** formatting tweaks ***

replace match = round(match, .001)
replace match = match*100
format match %20.01fc
format n %20.00fc

replace adtarget = "Age: 18-24" if adtarget == "age1824"
replace adtarget = "Age: 25+" if adtarget == "age25plus"
replace adtarget = "Education: Less than BA" if adtarget == "noba"
replace adtarget = "Education: BA or Higher" if adtarget == "baorhigher"
replace adtarget = "Race: White" if adtarget == "white"
replace adtarget = "Race: Black" if adtarget == "black"
replace adtarget = "Ideology: Very Liberal" if adtarget == "veryliberal"
replace adtarget = "Ideology: Liberal" if adtarget == "liberal"
replace adtarget = "Party: Democrat" if adtarget == "democrat"
replace adtarget = "Donate to Liberal Causes" if adtarget == "donate"
replace adtarget = "City: Atlanta, GA" if adtarget == "atlanta"
replace adtarget = "City: Charlotte, NC" if adtarget == "charlotte" 
replace adtarget = "City: Memphis, TN" if adtarget == "memphis" 
replace adtarget = "City: Seattle, WA" if adtarget == "seattle" 
replace adtarget = "City: St. Petersburg, FL" if adtarget == "stpetersburg" 
replace adtarget = "City: Toledo, OH" if adtarget == "toledo" 
replace adtarget = "Zip Code: 1,244 Codes" if adtarget == "zip" & study == 1
replace adtarget = "Zip Code: 12 Codes" if adtarget == "zip" & study == 2
replace adtarget = "Zip Code: 40 Codes" if adtarget == "zip" & study == 6

tostring study, replace
replace study = "I" if study == "1"
replace study = "II" if study == "2"
replace study = "III" if study == "3"
replace study = "IV" if study == "4"
replace study = "V" if study == "5"
replace study = "VI" if study == "6"
replace study = "" if study == "."

replace adtarget = "~~~~" + adtarget if study != ""

*** output ***

keep if !mi(adt)
keep adtarget study n match
list  

#delimit;

	listtex 
		using "table 2.tex"
		,
		replace
		type rstyle(tabular)
		head(
			\begin{tabular*}{\hsize}{@{\hskip\tabcolsep\extracolsep\fill}l*{4}{c}}
			\toprule Ad Target&Study&Recruited (N)&Match Rate (\%)\\
			\midrule
		)
		foot("\bottomrule\end{tabular*}")
		;
		
#delimit cr
