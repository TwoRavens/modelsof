log using McCabe_Snyder_ReStat_Table_1, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_1.DO
* 
* Computes descriptive statistics for Table 1.  Also computes 
* some isolated statistics cited in the text and some of the numbers
* used to make the figures.
*
* McCabe & Snyder August 2013
*
**********************************************************************

* Set initial Stata parameters
version 12
set more 1


* Compute Table 1 Row 1 (year journal founded)
use McCabe_Snyder_ReStat_combined
sort journal
keep if journal ~= journal[_n-1]
summ fpubdate


* Compute Table 1 Row 2 (year volume published)
clear
use McCabe_Snyder_ReStat_combined
sort journal pyear
egen jp = group(journal pyear)
sort jp
keep if jp ~= jp[_n-1]
summ pyear


* Compute Table 1 Rows 3, 4, 6 (citation year, cites, and OA)
clear
use McCabe_Snyder_ReStat_combined
gen cit = cusa + ceng + ceur + coth + cmis

* Suffix 1 refers to partial access
gen digit1 = (own1 + elsevier1 + jstor1 + ingaoc1 +  blackwell1 + ebsco1 + proquest1 + digz1) >= 1

* Suffix 2 refers to full access
gen digit2 = (own2 + elsevier2 + jstor2 + ingaoc2 +  blackwell2 + ebsco2 + proquest2 + digz2) >= 1
quietly replace digit1 = 0 if digit2 == 1

summ cyear cit digit2

* Compute age and time fixed effects graphed in Figures 1 and 2
gen age = cyear - pyear

forvalues num = 0/49 {
   generate age`num' = age == `num'
   }

forvalues num = 1980/2005 {
   generate c`num'= cyear == `num'
   }
   
gen c95_99 = (cyear >= 1995) & (cyear <= 1999)
gen c00_05 = (cyear >= 2000) & (cyear <= 2005)

gen d1c95 = digit1 * c95_99
gen d1c00 = digit1 * c00_05
gen d2c95 = digit2 * c95_99
gen d2c00 = digit2 * c00_05

xtpqml cit age1-age49 c1981-c2005 d1c* d2c*, i(journal) fe cluster(journal)


* Generate numbers behind Figure 3 (Proportion of content digitized by citation year)
tabulate cyear, summarize(digit2)

* Generate numbers behind Figure 6 (Proportion of content in digital channels by publication year)
tabulate pyear, summarize(digit2)
tabulate pyear, summarize(jstor2)
tabulate pyear, summarize(elsevier2)

* Generate numbers behind Figure 7 (Subscription trends)
clear
use McCabe_Snyder_ReStat_combined
* Look at MAX entry for each CYEAR and multiply by 100 to get points on JSTOR graph
by jstor2 cyear, sort: summ jss2
* Look at MAX entry for each CYEAR and multiply by 100 to get points on Elsevier graph
by elsevier2 cyear, sort: summ es2


* Compute Table 1 Row 5 ("Long-tail" statistic, fraction articles cited) 
clear
use McCabe_Snyder_ReStat_combined

gen fraction_null = count_null/obs_count
replace fraction_null = 1 if fraction_80 == .
gen fraction_pos = 1 - fraction_null
summ fraction_pos

