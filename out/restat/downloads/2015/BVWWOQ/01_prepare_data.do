set mem 9k
clear all
set more off
global ldir "C:\Users\russellthomson\Dropbox\REStat documents and data\Data"

** set up empty tables, used later
clear all
gen i = .
save "$ldir\oecd_ind_by_country_tidy_full", replace 
clear
gen country  = ""
gen year = .
gen industry = ""
sort country year industry
save "$ldir\stan_iva_reshape.dta", replace

clear
gen country  = ""
gen year = .
gen industry = ""
sort country year industry
save "$ldir\rdtype_reshape.dta", replace

clear
gen country  = ""
gen year = .
gen industry = ""
sort country year industry
save "$ldir\rdsource_reshape.dta", replace

clear all
gen year = .
gen country = ""
save "$ldir\gdp_2015_reshape.dta", replace


clear
gen country  = ""
gen year = .
sort country year
save "$ldir\msti_reshape.dta", replace




/* INPUT DATA ON VALUE ADDED BY INDUSTRY */
insheet using "$ldir\stan value added.csv", names clear 
save "$ldir\stan value added.dta", replace					/* here we get iva & iva def */ 
replace industry = "total" if industry == "CTOTAL TOTAL"

* Reshape
rename time year
drop if variable == "PROD Production (gross output), current prices" | variable == "PRDP Production (Gross Output), deflators"
gen indicator =""
replace indicator = "iva" if  variable == "VALU Value added, current prices"
replace indicator = "iva_def" if  variable == "VALP Value Added, deflators"

local indicators "iva iva_def"

foreach i of local indicators {
preserve
keep if indicator == "`i'"
rename value  `i'
rename flags flagss_`i'
sort country year
drop indicator variable
sort country year industry
merge country year industry using "$ldir\stan_iva_reshape.dta"
sort country year industry
drop _merge
save "$ldir\stan_iva_reshape.dta", replace
restore
}

use "$ldir\stan_iva_reshape.dta", clear
drop if year > 2006
qui: nameclean country
drop if country == "chile" | country == "israel" | country == "iceland" | country == "luxembourg" | country == "slovak republic" | country == "slovenia" | country == "estonia"
drop if country == "west germany" & year == 1991
replace country = "germany" if country == "west germany"

/* industry code for merging*/
gen indcode = substr(industry,1,6)

local ucls A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
local lcls a b c d e f g h i j k l m n o p q r s t u v w x y z 

forvalues x = 1/5 {
foreach i of loca ucls {
qui: replace indcode=subinstr(indcode, " `i'"," ",.)
}
}
replace indcode=subinstr(indcode, " ","",.)

foreach i of local lcls {
replace indcode=subinstr(indcode, "`i'","",.)
}

*cleaned industry name in words to make master industry list table to be merged to BERD data before being cleaned and then merged to STAN.
sort country year

gen ind = substr(industry,5,.)
replace ind=trim(ind)
replace ind =lower(ind)
	
forvalues x = 0/9 {
replace ind=subinstr(ind, "`x'","",.)
}

replace ind=subinstr(ind, ".","",.)
replace ind=subinstr(ind, ",","",.)
replace ind=trim(ind)
drop if ind == ""

replace indcode = "TOTAL" if industry == "total"  
replace indcode = "C50T74X" if industry == "C50T74X BUSINESS SECTOR SERVICES excluding real estate" 
sort country year indcode
duplicates l country year indcode
drop flagss_iva_def flagss_iva
save "$ldir\stan_iva_reshape2.dta", replace


/* used for identifying master industry list */
keep ind indcode
rename ind industry
duplicates drop
sort industry
save "$ldir\industry_code_list.dta", replace


*******************************************
/* input data on R&D by TYPE OF EXPENDITURE  by industry */
/* units are unitsforexpenditure Million 2000 Dollars - Constant prices and PPPs ; source OECD; download 17/2/2012*/
insheet using "$ldir\berd_cost_industry.csv", names clear
rename typeofcosts indicatorname

gen indicator =""
replace indicator = "rd_lab" if indicatorname == "Labour costs"
replace indicator = "rd_ocurr" if indicatorname == "Other current costs"
replace indicator = "rd_cap" if indicatorname == "Sub-total capital expenditure"
replace indicator = "rdt_total" if indicatorname =="Total (all types of costs)"

* Reshape
local indicators "rd_lab rd_ocurr rd_cap rdt_total"

foreach i of local indicators {
preserve
keep if indicator == "`i'"
rename value `i'
drop indicator  flags unitsforexpenditure indicatorname
sort country year industry
merge country year industry using "$ldir\rdtype_reshape.dta"
sort country year industry
drop _merge 
save "$ldir\rdtype_reshape.dta", replace
restore
}

use "$ldir\rdtype_reshape.dta", clear
nameclean country
replace country = "korea" if country == "korea rep"
drop if country == "luxembourg"
drop if year > 2006 
sort country year
nameclean industry

sort country year industry
save "$ldir\rdtype_reshape.dta", replace

*********************************
/* input data on R&D by SOURCE OF FUNDS by industry */
insheet using "$ldir\berd_by_ind_by_funds.csv", comma names clear
/* units are unitsforexpenditure Million 2000 Dollars - Constant prices and PPPs ; source OECD; download 17/2/2012*/

rename sourceoffunds indicatorname
gen indicator =""
replace indicator = "rdfind" if indicatorname == "Business enterprise"
replace indicator = "rdfgov" if indicatorname == "Sub-total government"
replace indicator = "rdfabr" if indicatorname == "Funds from abroad"
replace indicator = "rdf_total" if indicatorname =="Total (funding sector)"

* Reshape
local indicators "rdfind rdfgov rdfabr rdf_total"

foreach i of local indicators {
preserve
keep if indicator == "`i'"
rename value `i'
drop indicator  flags unitsforexpenditure indicatorname
sort country year industry
merge country year industry using "$ldir\rdsource_reshape.dta"
sort country year industry
drop _merge 
save "$ldir\rdsource_reshape.dta", replace
restore
}

use "$ldir\rdsource_reshape.dta", clear
nameclean country
replace country = "korea" if country == "korea rep"
drop if year > 2006 

nameclean industry
sort country year industry
save "$ldir\rdsource_reshape.dta", replace


merge 1:1 country year industry using "$ldir\rdtype_reshape.dta"
drop _merge
replace ind = "total" if ind == "total berd"
save  "$ldir\rdtype_rdsource.dta", replace

sort industry
merge m:1 industry using "$ldir\industry_code_list.dta" 
/*clean ind name*/
replace indcode = "C15T16" if industry == "food beverages and tobacco"
replace indcode = "C18" if industry == "wearing apparel and fur"
replace indcode = "C19" if industry == "leather products and footwear"
replace indcode = "C20" if industry == "wood and cork not furniture"
replace indcode = "C22" if industry == "publishing printing and reproduction of recorded media"
replace indcode = "C24X" if industry == "chemicals and chemical products less pharmaceuticals"
replace indcode = "C25" if industry == "rubber and plastic products"
replace indcode = "C26" if industry == "non metallic mineral products"
replace indcode = "C271T3" if industry == "basic metals iron and steel"
replace indcode = "C272T3" if industry == "basic metals non ferrous"
replace indcode = "C32" if industry == "radio tv and communications equipment and apparatus"
replace indcode = "C33" if industry == "medical precision and optical instruments watches and clocks instruments"
replace indcode = "C34" if industry == "motor vehicles trailers and semi trailers"
replace indcode = "C35" if industry == "other transport equipment"
replace indcode = "C36" if industry == "other manufacturing nec"
replace indcode = "C64" if industry == "telecommunications"
replace indcode = "TOTAL" if industry == "total"

drop if _merge == 2

drop if indcode == "" 
drop _merge

preserve
keep indcode
duplicates drop
save  "$ldir\industry_using.dta", replace 
restore

sort country year indcode 
merge 1:1 country year indcode using "$ldir\stan_iva_reshape2.dta"
drop _merge

merge m:1 indcode using "$ldir\industry_using.dta"
drop if _merge !=3
drop _merge

gen ccode  = ""

replace ccode = "au" if country =="australia"
replace ccode = "at" if country =="austria"
replace ccode = "be" if country =="belgium" 
replace ccode = "ca" if country =="canada" 
replace ccode = "ch" if country =="switzerland"
replace ccode = "cz" if country =="czech republic" 
replace ccode = "dk" if country =="denmark" 
replace ccode = "es" if country =="spain"
replace ccode = "fi" if country =="finland" 
replace ccode = "fr" if country =="france"
replace ccode = "gb" if country =="united kingdom"
replace ccode = "de" if country =="germany"
replace ccode = "gr" if country =="greece"
replace ccode = "hu" if country =="hungary"
replace ccode = "ie" if country =="ireland"
replace ccode = "it" if country =="italy"
replace ccode = "jp" if country =="japan" 
replace ccode = "kr" if country =="korea"
replace ccode = "mx" if country =="mexico"
replace ccode = "nl" if country =="netherlands"
replace ccode= "no" if country =="norway"
replace ccode = "nz" if country =="new zealand"
replace ccode = "pl" if country =="poland"
replace ccode = "pt" if country =="portugal"
replace ccode = "se" if country =="sweden" 
replace ccode = "us" if country =="united states"

rename year t
gen x =  ccode+indcode
encode x, gen(i)
drop x

tsset i t
tsfill

decode i, gen(i_string)
replace ccode = substr(i_string,1,2) if ccode == ""
replace indcode = substr(i_string,3,.) if indcode == ""
drop i_string i

save  "$ldir\industry level data.dta" , replace

*********************************************
* country level aggregates
************************************
clear
/*GDP figures from OECD rebased to 2000 for consistency, used to generate control varialbe IVA */
insheet using "$ldir\oecd_gdp.csv", names clear 
* Reshape
local indicators "DOB VPCOB VPVOB"
foreach i of local indicators {
preserve
keep if measure == "`i'"
rename value  `i'

local xx = v6[1]
di "`xx'"
label var `i' "`xx'"

sort country year

keep country year `i'
merge 1:1 country year using "$ldir\gdp_2015_reshape.dta"
drop _merge
save  "$ldir\gdp_2015_reshape.dta", replace
restore
}

use "$ldir\gdp_2015_reshape.dta", clear
replace country = lower(country)
sort country year
gen xx = DOB if year == 2000
bysort country: egen DOBBY = min(xx)
gen dob_rebased = DOB / DOBBY *100
gen gdp2000by =  VPCOB / dob_rebased *100
keep country year gdp2000by 
nameclean country
replace country = "korea" if country == "korea rep"
drop if year > 2006 

save "$ldir\gdp_2015_reshape.dta", replace


/*input herd and govrd and biggest sample of berd rdfind */
insheet using "$ldir\msti.csv", comma names clear


save "$ldir\macro variables.dta", replace 
gen indicator =""
replace indicator = "herdint" if  mstivariables == "HERD as a percentage of GDP"
replace indicator = "govrdint" if  mstivariables== "GOVERD as a percentage of GDP"
replace indicator = "pberdfind" if mstivariables =="Percentage of BERD financed by industry"
replace indicator = "berdint" if mstivariables =="BERD as a percentage of GDP"
replace indicator = "pberdfgov" if mstivariables =="Percentage of BERD financed by government"
drop if indicator == "" 

local indicators "herdint govrdint pberdfgov pberdfind berdint"
foreach i of local indicators {
preserve
keep if indicator == "`i'"
rename value  `i'
sort country year
drop indicator mstivariables
merge 1:1 country year  using "$ldir\msti_reshape.dta"
sort country year
drop _merge
save "$ldir\msti_reshape.dta", replace
restore
}
use "$ldir\msti_reshape.dta", clear

/*
*Note - OECD documentation observes an issue relating to the reported figures from Japan. quoting the OECD website: 
"Up to and including 1995, Japanese data for R&D personnel was expressed as the number of physical persons 
(working on R&D) rather than in terms of full-time equivalent. In consequence R&D personnel and labour cost 
data were overestimated by international standards. Studies by some Japanese authorities had suggested that in order
 to reach FTE the numbers of researchers might be cut by perhaps 40 % in the Higher Education sector and by about 30 % 
for the national total. In consequence HERD would be reduced by about 25 % and GERD by about 15 %." 
* use the adjusted figures
*/


drop if year <1996 & country =="Japan" 
drop if year >1995 & country =="Japan (Adj.)"
replace country = "Japan" if country =="Japan (Adj.)" 

nameclean country
drop flags

save "$ldir\msti_reshape.dta", replace
merge 1:1 country year using "$ldir\gdp_2015_reshape.dta"

drop if _merge !=3 
drop _merge

gen ccode  = ""
replace ccode = "au" if country =="australia"
replace ccode = "at" if country =="austria"
replace ccode = "be" if country =="belgium" 
replace ccode = "ca" if country =="canada" 
replace ccode = "ch" if country =="switzerland"
replace ccode = "cz" if country =="czech republic" 
replace ccode = "dk" if country =="denmark" 
replace ccode = "es" if country =="spain"
replace ccode = "fi" if country =="finland" 
replace ccode = "fr" if country =="france"
replace ccode = "gb" if country =="united kingdom"
replace ccode = "de" if country =="germany"
replace ccode = "gr" if country =="greece"
replace ccode = "hu" if country =="hungary"
replace ccode = "ie" if country =="ireland"
replace ccode = "it" if country =="italy"
replace ccode = "jp" if country =="japan" 
replace ccode = "kr" if country =="korea"
replace ccode = "mx" if country =="mexico"
replace ccode = "nl" if country =="netherlands"
replace ccode= "no" if country =="norway"
replace ccode = "nz" if country =="new zealand"
replace ccode = "pl" if country =="poland"
replace ccode = "pt" if country =="portugal"
replace ccode = "se" if country =="sweden" 
replace ccode = "us" if country =="united states"

rename year t


gen berd = berdint *gdp2000by  
gen herd = herdint *gdp2000by  
gen govrd = govrdint *gdp2000by  

gen berdfind = pberdfind * berd
gen berdfgov = pberdfgov * berd

drop pberdfgov pberdfind pberdfind *int

rename gdp2000by gdp


save "$ldir\msti_gdp.dta", replace


/* INPUT THE B-INDEX DATA BY TYPE OF EXPENDITURE */
import excel "$ldir\tax policy_final.xlsx", sheet("tax policy input") firstrow clear

gen ccode = lower(isocode)
drop isocode
replace ccode = "au" if ccode =="aus"
replace ccode = "at" if ccode =="aut" 
replace ccode = "be" if ccode =="bel" 
replace ccode = "ca" if ccode =="can" 
replace ccode = "ch" if ccode =="che" 
replace ccode = "cz" if ccode =="cze" 
replace ccode = "dk" if ccode =="dnk" 
replace ccode = "es" if ccode =="esp" 
replace ccode = "fi" if ccode =="fin" 
replace ccode = "fr" if ccode =="fra" 
replace ccode = "gb" if ccode =="gbr" 
replace ccode = "de" if ccode =="ger" 
replace ccode = "gr" if ccode =="grc" 
replace ccode = "hu" if ccode =="hun" 
replace ccode = "ie" if ccode =="irl" 
replace ccode = "it" if ccode =="ita" 
replace ccode = "jp" if ccode =="jpn" 
replace ccode = "kr" if ccode =="kor" 
replace ccode = "mx" if ccode =="mex" 
replace ccode = "nl" if ccode =="nld" 
replace ccode= "no"  if ccode =="nor" 
replace ccode = "nz" if ccode =="nzl" 
replace ccode = "pl" if ccode =="pol" 
replace ccode = "pt" if ccode =="prt" 
replace ccode = "se" if ccode =="swe" 
replace ccode = "us" if ccode =="usa"

rename yr t
sort ccode t

merge 1:1 ccode t using "$ldir\msti_gdp.dta", nogen

joinby ccode t using "$ldir\industry level data.dta", unmatched(both)
drop _merge

replace industry = "total" if indcode == "total"
replace indcode = "TOTAL" if ccode == "ch" & indcode == ""

******************************************
*** 1. clean SAMPLE INDUSTRY AND COUNTRY 
** e.g., avoid including any industry components twice.
drop if ccode == "hu" & t < 1991
drop if ccode == "cz" & t  < 1994
drop if ccode == "pl" & t  < 1991

drop if indcode == "C15T37"  | indcode == "C55" | indcode == ""
drop if  indcode == "C271T3" | indcode == "C272T3" 
drop if indcode == "C01T02"   | indcode == "C74"    | indcode == "C45O"  |indcode == "C64"  |indcode == "C353" | indcode ==  "C70T74"  | indcode == "C24" | indcode == "C15" | indcode == "C16"


replace indcode=trim(indcode)

gen x =  ccode+indcode
encode x, gen(i)
drop x

tsset i t

order i ccode indcode t

/* 2. CONSISTENCY & CLEANING */
order i ccode indcode t
gen bt = 			(	rd_cap > rdt_total )  &  (rd_cap !=. )
replace  bt = 1 if 	(	rd_ocurr > rdt_total)  &  ( rd_ocurr != . )
replace  bt = 1 if	(	rd_lab > rdt_total)  &  ( rd_lab !=.)

* don't use if components data don't add up 
local rdvars rd_cap rd_lab rd_ocurr rdt_total
foreach i of local rdvars {
replace `i' = . if bt == 1
}

tsfill
decode i, gen(i_string)
replace ccode = substr(i_string,1,2) if ccode == ""
replace indcode = substr(i_string,3,.) if indcode == ""
drop i_string

gen rd = rdt_total 
replace rd = rdf_total if rd ==.

*****************************************************
/* CALCULATE R&D EXPENDITURE COMPONANT SHARES  */
 * (a) make country specific 
 * (b) make global averge - used in robustness checks & for countries without expenditure by type data
  
* sum of types by original data - there are missings in this
egen o_typesum =  rowtotal(rd_cap  rd_ocurr  rd_lab)

local types "cap ocurr lab"
foreach i of local types {
gen missing_`i' =  (rd_`i' == .)
}

gen numbermissing = missing_cap + missing_ocurr + missing_lab

/* data consistency  cleaning */
foreach i of local types {
di "missing some componant `i'"
replace rd_`i' = . if (numbermissing > 0)
di "excessive deviation `i' :" 
replace rd_`i' = . if (numbermissing == 0) & abs(o_typesum-rd)/rd > 0.5 /*no componant missing & componants sum to very dif figure than tot: flagss data ISSUE */
di "zero labour `i' :" 
replace rd_`i' = . if rd_lab == 0 & rd != 0   /* all R&D should have non-zero labour componant: flags data issue */
di "no total `i' :" 
replace rd_`i' = . if rdt_total == .  & rd_`i' == 0  /* if OECD don't report a total - then there is something wrong with data / split */
}

drop *missing* o_typesum

******
** limited length interpolation of expenditure components that are used for weighting R&D tax price  
preserve
by i (t), sort: drop if sum(!missing(rd_cap)) == 0  /*trims off series of missings at the start */
gsort i -t
by i: drop if sum(!missing(rd_cap)) == 0 /*trims off series of missings at the end */
sort i t
tsspell, cond(missing(rd_cap))
qui: egen length = max(_seq), by(i _spell)
qui: drop  _end _seq _spell
qui: by i: egen maxspell = max(length) 
keep i t maxspell 
save  "$ldir\maxspellflag.dta", replace
restore
*************

*several national R&D survey's are biannual  so lin. interp max 3 years) *
sort i t
local ipolatevars rdfind  rd rd_cap rd_lab rd_ocurr
foreach i of local ipolatevars {
qui: by i: ipolate `i' t, generate(i_`i')
tsspell, cond(missing(`i'))
qui: egen length = max(_seq), by(i _spell)
qui: drop  _end _seq _spell
qui: replace i_`i' = . if length > 3
qui: drop length
qui: drop `i'
qui: rename i_`i' `i'
}


merge 1:1 i t using "$ldir\maxspellflag.dta", nogen
bysort i: egen x = max(maxspell)
replace maxspell = x if maxspell == .
drop x

local full_ipolatevars govrd herd rdfabr rdfgov gdp berd berdfind berdfgov iva 
foreach i of local full_ipolatevars {
qui: by i: ipolate `i' t, generate(i_`i')
qui: drop `i'
qui: rename i_`i' `i'
}

* filled (such that we have all three types) sum of expenditure by types -  these may not add up to the interpolated total
gen f_typesum =  rd_cap  + rd_ocurr + rd_lab

gen rd_tcurr = rd_lab + rd_ocurr

** COUNTRY SPECIFIC SHARES
* Shares add up to 1 - shares are derived as a ratio of interperlated & cleaned totals. 
local types2 "cap ocurr lab tcurr"

foreach i of local types2 {
gen `i'share = rd_`i' / f_typesum
replace `i'share  = . if rd_`i' == .
}

save  "$ldir\oecd_ind_by_country_full2", replace   

/*** MAKE THE GLOBAL AVERAGE SHARES */
keep i t rd_cap rd_ocurr rd_lab rd indcode ccode maxspell
drop if indcode == "TOTAL" | maxspell > 5
tsfill, full 
decode i, gen(i_string)
replace ccode = substr(i_string,1,2) if ccode == ""
replace indcode = substr(i_string,3,.) if indcode == ""
replace rd = . if rd == 0
sort i t
local ipolatevars1 rd rd_cap rd_ocurr rd_lab 
foreach i of local ipolatevars1 {
qui: by i: ipolate `i' t, generate(i_`i')
}

** Ensure that components add up to  total for calculating share
* Pseudo componants are used for calculating the GLOBAL share by industry (aggregate figure taken to be best available). 
gen f_typesum = i_rd_cap + i_rd_ocurr + i_rd_lab
gen sc_rd_cap = i_rd * (i_rd_cap / f_typesum)
gen sc_rd_ocurr  = i_rd * (i_rd_ocurr/ f_typesum)
gen sc_rd_lab = i_rd * (i_rd_lab/ f_typesum)

**  important not to have variation in sample driving variation in shares: generate best window for each industry
gen missing = (sc_rd_lab  ==.) 
local industries "C10T14 C15T16 C17 C18 C19 C20 C21 C22 C23 C2423 C24X C25 C26 C27 C28 C29 C30 C31 C32 C33 C34 C35 C36 C37 C40T41 C45 C60T64 C72 C73 "

pause on

foreach i of local industries {
	local ncs = 0
	
	local syear = 1986 
	local eyear = 2013
	
		while `ncs' < 3 {					
		local syear = `syear' +1 
		local eyear = `eyear' -1
		preserve
		qui: drop if t < `syear' | t > `eyear'
		qui: keep if indcode == "`i'"
		qui: sort i
		by i: egen somemissing = max(missing) 
		sort somemissing
		qui: egen x = tag(ccode somemissing)
		qui: replace x = 0 if somemissing == 1
		qui: egen nnn = sum(x)
		local ncs = nnn[1]
		restore
		}
		
gen outofrange = (t < `syear' | t > `eyear')
drop if indcode == "`i'" & outofrange == 1

di "industry: `i', number of countries:`ncs' from `syear' to `eyear' "
drop outofrange
}
count
by i: egen somemissing = max(missing) 
keep if somemissing == 0
sort indcode
gen x = 1
collapse (sum) sc_rd_cap sc_rd_ocurr sc_rd_lab gav_nocountries = x, by(indcode t)
gen gav_capshare = sc_rd_cap / (sc_rd_cap  + sc_rd_ocurr + sc_rd_lab)
gen gav_labshare = sc_rd_lab/ (sc_rd_cap  + sc_rd_ocurr + sc_rd_lab)
gen gav_ocurrshare = sc_rd_ocurr/ (sc_rd_cap  + sc_rd_ocurr + sc_rd_lab)
keep gav* i t 

joinby i t using "$ldir\oecd_ind_by_country_full2", unmatched(both)
sort i t

gen w_b =  			l.labshare* bl +		l.ocurrshare*bcurr+		l.capshare * 	(0.5*bme+0.5*bb)    /*industry-country weights; recall Rt = Bt-1*/
gen gav_b  =  	gav_labshare*bl + 	gav_ocurrshare * bcurr+ 	gav_capshare * (0.5*bme+0.5*bb)  /*global average industry weights */
gen f_b =  			w_b													
replace f_b = gav_b if ccode == "be" | ccode == "nz"  | ccode == "us" | ccode == "nl" | ccode == "gb"  /*countries with inadequate component data, use global share weights */

gen test_av = 		gav_labshare + 	gav_ocurrshare + 	gav_capshare * (0.5+0.5)
gen test =  			labshare +		ocurrshare+		capshare * 	(0.5+0.5)
gen testshares = labshare + ocurrshare + capshare
gen av_testshares = gav_labshare + gav_ocurrshare + gav_capshare
sum *testshares /* must sum to unity */
drop *test* w_b gav* maxspell f_typesum 

***************************************************
/* MAKE REGRESSION VARIABLES  */
** depvar is R&D financed by the business and enterprise sector if available, or business expenditure on R&D if not.
keep if rd !=. | indcode == "TOTAL"
replace rdfind = rd if  ccode == "nl" | ccode == "be" | ccode == "nz" | ccode == "ie"  | ccode == "ca"  | ccode == "gb" | ccode == "mx"

** IVA
sort ccode t
by ccode t: gen xx = iva if indcode == "TOTAL"    /*use actual data not interpolated amount */
by ccode t: egen national_iva = min(xx)
gen iva_share = iva/national_iva
gen ivadollars = iva_share * gdp
drop xx _merge iva_share national_iva

local logvars  govrd herd  rd rdfabr rdfgov rdfind rd_cap rd_ocurr rd_lab  iva ivadollars berd berdfind gdp berdfgov f_b
foreach i of local logvars {
	gen l`i' = ln(`i')
}

encode ccode, gen(cc)
sort i t

quietly: tab t, gen(timedum)

drop if t < 1986 | t > 2006

gen manuf = (indcode != "C60T64"  & indcode != "C37"  & indcode != "C45"  & indcode != "C73"  & indcode != "C72"  & indcode != "C40T41")
drop if indcode == "TOTAL"

local lagvariables lrdfind livadollars lf_b
foreach i of local lagvariables {
gen l_`i' = l.`i'
}

save  "$ldir\oecd_ind_by_country_final", replace

/*end */
exit

