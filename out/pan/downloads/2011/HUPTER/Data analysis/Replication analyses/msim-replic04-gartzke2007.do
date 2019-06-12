
* Open log 
**********
capture log close
log using "Data analysis\Replication analyses\msim-replic04-gartzke2007.log", replace


* ***********************************************************
* Replication of logist regression analysis in Gartzke (2007)
* ***********************************************************

* Programme:	msim-replic04-gartzke2007.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file replicates the logit regression in Table 1 of Gartzke (2007: 177) using different similarity indices.
* The replications of model 5 using the original S measure, Cohen's Kappa, and Scott's Pi is reported in the article.
* Reference: Erik Gartzke (2007) 'The Capitalist Peace'. American Journal of Political Science 51(1): 166-191.
* I thank Erik Gartzke for providing his replication dataset and do-file.
* (see http://dss.ucsd.edu/~egartzke/data/capitalistpeace_012007.zip [5 March 2010]).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off
set memory 500m


* Load original dataset
use "Data analysis\Replication analyses\Gartzke 2007 Capitalist peace, AJPS\capitalistpeace_012007.dta", clear 


* Preparation of original dataset for replication analysis
**********************************************************

* Rename country code variables
rename statea ccode1
rename stateb ccode2

* Recode GDP per capita variables
replace rgdppclo = rgdppclo/1000
replace gdpcontg = gdpcontg/1000

* Keep only relevant variables
keep maoznewl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt _spline* /*
	*/ sun* warl deadlyl namerica samerica europe africa nafmeast asia waryear* deadyer* ccode1 ccode2 year dyadid

* Label variables in original dataset
label var ccode1 "Country 1 code (COW)"
label var ccode2 "Country 2 code (COW)"
label var year "Year"
label var dyadid "Dyad code"
label var maoznewl "Militarized dispute onset"
label var warl "War onset"
label var deadlyl "Fatal MID onset"
label var demlo "Democracy (low)"
label var demhi "Democracy (high)"
label var deplo "Trade dependence (low)"
label var capopenl "Financial openness (low)"
label var rgdppclo "GDP per capita/1000 (low)"
label var gdpcontg "GDP per capita/1000 x contiguity"
label var contig "Contiguity"
label var logdstab "Distance (logged)"
label var majpdyds "Major power"
label var allies "Alliance"
label var lncaprt "Capability ratio (logged)"
label var _spline1 "MID spline 1"
label var _spline2 "MID spline 2"
label var _spline3 "MID spline 3"
label var waryear1 "War spline 1"
label var waryear2 "War spline 2"
label var waryear3 "War spline 3"
label var deadyer1 "Fatal MID spline 1"
label var deadyer2 "Fatal MID spline 2"
label var deadyer3 "Fatal MID spline 3"
label var namerica "North America"
label var samerica "South America"
label var europe "Europe"
label var africa "Africa"
label var nafmeast "Middle East"
label var asia "Asia"
label var sun2cati "S (abs. distances, Gartzke)"

* Define list of model variables
local var1 maoznewl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt _spline*
local var2 warl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia waryear*
local var3 deadlyl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia deadyer*

* Generate sample indicator for Model 5 
egen miss1 = rowmiss(`var1' sun2cati)
tab miss1, m
generate dmiss1 = 0
replace dmiss1 = 1 if miss1 > 0
label var dmiss1 "List-wise missing Model 5"
tab dmiss1, m
drop miss1

* Generate sample indicator for Model 7
egen miss2 = rowmiss(`var2')
tab miss2, m
generate dmiss2 = 0
replace dmiss2 = 1 if miss2 > 0
label var dmiss2 "List-wise missing Model 7"
tab dmiss2, m
drop miss2

* Generate sample indicator for Model 9
egen miss3 = rowmiss(`var3')
tab miss3, m
generate dmiss3 = 0
replace dmiss3 = 1 if miss3 > 0
label var dmiss3 "List-wise missing Model 9"
tab dmiss3, m
* Note: Sample is further reduced by drop of 6315 dyads whose outcome is perfectly predicted by region dummy variables
drop miss3


* Replication of Gartzke's results using the original S measure
***************************************************************

* Model 5 in Table 1 with Gartzke's S measure
logit `var1' sun2cati, cluster(dyadid)
estimates store m5

* Print model estimates
estout m5, label legend cells(b(star fmt(2)) se(par fmt(2))) stats(N ll chi2, fmt(0 3 2)) starlevels(* 0.05)
* The regression model is exactly replicated

* Model 7 in Table 2 without S measure
logit warl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia waryear*, cluster(dyadid)
estimates store m7
parmest, label list(parm estimate min* max*) idstr(m7) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7.dta", replace) 

* Model 7 in Table 2 with Gartzke's S measure
logit warl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia waryear* sun2cati, cluster(dyadid)
estimates store m7a
parmest, label list(parm estimate min* max*) idstr(m7a) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7a.dta", replace) 

* Model 9 in Table 2 without S measure
logit deadlyl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia deadyer*, cluster(dyadid)
estimates store m9 

* Model 9 in Table 2 with Gartzke's S measure
logit deadlyl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia deadyer* sun2cati, cluster(dyadid)
estimates store m9a


* Merge Gartzke's data with chance-corrected agreement indices (undirected dyadic data based on valued UN voting relationships)
*******************************************************************************************************************************

* Merge datasets 
sort year ccode1 ccode2
merge year ccode1 ccode2 using "Datasets\Derived\msim-data11e-votesimvalued1", unique
* Note: The dependent variable is already one year ahead, so new independent variables do not need to be lagged

* Check merge results
tab _merge, m

* Drop observations that are not part of the time period analysed
tab year _merge
drop if year < 1950 | year > 1992

* Drop all observations that are not included in any model estimation
table dmiss1 dmiss2 dmiss3
drop if dmiss1 == 1 & dmiss2 == 1 & dmiss3 == 1

* Drop dyads constituting relationships of dyad members to themselves that come from using data
drop if ccode1 == ccode2 & _merge == 2


* Examine all dyads that are only included in Gartzke's data
************************************************************

* Generate interpolation indicator
egen smiss = rowmiss(sun2cat)
label var smiss "Similarity value missing"
tab smiss, m

* Check how many additional dyads are due to interpolation of similarity values
tab smiss _merge, m

* Check which additional dyads are not due to interpolation of similarity values
tab ccode1 if smiss == 0 & _merge == 1
list ccode1 ccode2 year if smiss == 0 & _merge == 1
* Only dyads involving Taiwan in 1972 and 1973 (this is a mistake in the original voting data)

* Drop 223 dyads involving Taiwan in 1972 and 1973 (error in original voting data)
tab year if _merge == 1 & smiss == 0 & (ccode1 == 713 | ccode2 == 713)
drop if _merge == 1 & smiss == 0 & (ccode1 == 713 | ccode2 == 713) & (year == 1972 | year == 1973)

* Check which additional dyads are due to interpolation
tab ccode1 if _merge == 1
tab ccode2 if _merge == 1
* Includes mostly dyads with countries that were not members of the UN at the time

* Drop 452 dyads involving Taiwan after 1973 (excluded from the UNGA since 1972, error due to interpolation)
tab year if _merge == 1 & (ccode1 == 713 | ccode2 == 713)
drop if _merge == 1 & (ccode1 == 713 | ccode2 == 713) & year > 1973

* Drop 2117 dyads involving South Africa between 1975 and 1992 (excluded from the UNGA during that time)
tab year if _merge == 1 & (ccode1 == 560 | ccode2 == 560)
drop if _merge == 1 & (ccode1 == 560 | ccode2 == 560) & year > 1974 & year < 1993

* Drop 696 dyads involving the Federal Republic of Germany before 1972 (not member of UNGA before 1973)
tab year if _merge == 1 & (ccode1 == 260 | ccode2 == 260)
drop if _merge == 1 & (ccode1 == 260 | ccode2 == 260) & year < 1973

* Drop 2726 dyads involving the Republic of Korea before 1991 (not member of UNGA before 1992)
tab year if _merge == 1 & (ccode1 == 732 | ccode2 == 732)
drop if _merge == 1 & (ccode1 == 732 | ccode2 == 732) & year < 1991

* Drop 780 dyads involving Vietnam before 1977 (not a member of UNGA before 1978)
tab year if _merge == 1 & (ccode1 == 817 | ccode2 == 817)
drop if _merge == 1 & (ccode1 == 817 | ccode2 == 817) & year < 1977

* Drop 111 dyads involving Bangladesh before 1974 (not a member of UNGA before 1975)
tab year if _merge == 1 & (ccode1 == 771 | ccode2 == 771)
drop if _merge == 1 & (ccode1 == 771 | ccode2 == 771) & year < 1974

* Drop 95 dyads involving Switzerland (not a member of UNGA at all)
tab year if _merge == 1 & (ccode1 == 225 | ccode2 == 225)
drop if _merge == 1 & (ccode1 == 225 | ccode2 == 225)

* Drop merge variable
tab _merge, m
drop _merge


* Check which observations are missing in Gartzke's similarity variable
***********************************************************************

* Check overlap between missings for different models
tab dmiss1, m
tab dmiss2, m
tab ccode2 if dmiss1 == 1

* 126 dyads involving Uzbekistan in 1992 (became member that year)
tab year if dmiss1 == 1 & (ccode1 == 704 | ccode2 == 704)

* 125 dyads involving Georgia in 1992 (became member that year)
tab year if dmiss1 == 1 & (ccode1 == 372 | ccode2 == 372)

* Check and compare similarity scores
pwcorr sun2cati sun2cat sun3cati sun3cat
corr sun2cati sun3cati srsvva srsvvs kappavv pivv

* Label chance-corrected agreement indices
label var sun2cati "S (abs. distances, Gartzke 2 cat)"
label var sun3cati "S (abs. distances, Gartzke 3 cat)"
label var srsvva "S (abs. distances)"
label var srsvvs "S (sqrd. distances)"
label var kappavv "Cohen's kappa"
label var pivv "Scott's pi"


* Replication using chance-corrected agreement indices
******************************************************

* Model 5
*********

* Gartzke's two-value similarity measure has missing values where his three-value measure has not.
* As a result, models relying on the three-value measure have one more observation in their sample.

* Define list of model variables
local var1 maoznewl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt _spline*

* Original model on smaller sample (reduced through merge)
logit `var1' sun2cati, cluster(dyadid)
estimates store m5a

* Original model on smaller sample (reduced through merge) with Gartzke's 3-category similarity variable
logit `var1' sun3cati, cluster(dyadid)
estimates store m5b

* Model with S based on absolute distances
logit `var1' srsvva, cluster(dyadid)
estimates store m5c

* Model with S based on squared distances
logit `var1' srsvvs, cluster(dyadid)
estimates store m5d

* Model with Scott's pi
logit `var1' pivv, cluster(dyadid)
estimates store m5e

* Model with Cohen's kappa
logit `var1' kappavv, cluster(dyadid)
estimates store m5f

* Print model estimates
estout m5 m5a m5b m5c m5d m5e m5f, label /*
	*/ cells(b(star fmt(2)) se(par fmt(2))) stats(N chi2 ll, fmt(0 2 2) star(chi2))

* Model 9
*********

* Define list of model variables
local var3 deadlyl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia deadyer*

* Original model on smaller sample (reduced through merge)
logit `var3' sun2cati, cluster(dyadid)
estimates store m9b

* Original model on smaller sample (reduced through merge) with Gartzke's 3-category similarity variable
logit `var3' sun3cati, cluster(dyadid)
estimates store m9c

* Model with S based on absolute distances
logit `var3' srsvva, cluster(dyadid)
estimates store m9d

* Model with S based on squared distances
logit `var3' srsvvs, cluster(dyadid)
estimates store m9e

* Model with Scott's pi
logit `var3' pivv, cluster(dyadid)
estimates store m9f

* Model with Cohen's kappa
logit `var3' kappavv, cluster(dyadid)
estimates store m9g

* Print model estimates
estout m9 m9a m9b m9c m9d m9e m9f m9g, label /*
	*/ cells(b(star fmt(3)) se(par fmt(3))) stats(N chi2 ll, fmt(0 1 2))

* Model 7
*********

* Define list of model variables
local var2 warl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia waryear*

* Original model on smaller sample (reduced through merge)
logit `var2' sun2cati, cluster(dyadid)
estimates store m7b
parmest, label list(parm estimate min* max*) idstr(m7b) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7b.dta", replace) 

* Original model on smaller sample (reduced through merge) with Gartzke's 3-category similarity variable
logit `var2' sun3cati, cluster(dyadid)
estimates store m7c
parmest, label list(parm estimate min* max*) idstr(m7c) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7c.dta", replace) 

* Model with S based on absolute distances
logit `var2' srsvva, cluster(dyadid)
estimates store m7d
parmest, label list(parm estimate min* max*) idstr(m7d) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7d.dta", replace) 

* Model with S based on squared distances
logit `var2' srsvvs, cluster(dyadid)
estimates store m7e
parmest, label list(parm estimate min* max*) idstr(m7e) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7e.dta", replace) 

* Model with Scott's pi
logit `var2' pivv, cluster(dyadid)
estimates store m7f
parmest, label list(parm estimate min* max*) idstr(m7f) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7f.dta", replace) 

* Model with Cohen's kappa
local var2 warl demlo demhi deplo capopenl rgdppclo gdpcontg contig logdstab majpdyds allies lncaprt namerica samerica europe africa nafmeast asia waryear*
logit `var2' kappavv, cluster(dyadid)
estimates store m7g
parmest, label list(parm estimate min* max*) idstr(m7g) /*
	*/ saving("Data analysis\Replication analyses\msim-replic04-gartzke2007-m7g.dta", replace) 


* Generate Appendix Table 1
***************************
	
* Print model estimates
estout m7 m7a m7b m7c m7d m7e m7f m7g using "Data analysis\Replication analyses\msim-replic04-gartzke2007-table.txt" /*
	*/ , replace title("Replication of Gartzke's (2007) logit regression analysis of war onset") /*
	*/ label collabels(none) legend starlevels(* 0.05) /*
	*/ mlabels("Original model" "Original model, 2-cat S" "Original model, new data" /*
	*/ "New data, 3-cat S" "New data, abs. dist" "New data, sqrd. dist." /*
	*/ "Scott's Pi" "Cohen's Kappa") /*
	*/ cells(b(star fmt(3)) se(par fmt(3))) /*
	*/ stats(N chi2 ll, fmt(0 2 2) star(chi2) /*
	*/ labels("N" "Chi-squared" "Log likelihood")) /*
	*/ postf("The dependent variable indicates the onset of war, the sample covers dyads between 1966 and 1992, robust standard errors adjusted for clustering on dyad, two-tailed significance tests")


* Generate Figure 7
*******************
	
* Merge datasets of parameter estimates and confidence intervals
use "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7.dta", clear
append using "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7a.dta"
append using "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7b.dta"
append using "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7c.dta"
append using "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7d.dta"
append using "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7e.dta"
append using "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7f.dta"
append using "Data analysis\Replication analyses\msim-replic04-gartzke2007-m7g.dta"

* Recode parameter variable to make sure that similarity parameter is in same position after sorting
replace parm = "skappavv" if parm == "kappavv"
replace parm = "spivv" if parm == "pivv"

* Add one additional observation for similarity parameter omitted from original model
local N = _N+1
di `N'
set obs `N'
replace idstr = "m7" if idstr == ""
replace parm = "snone" if parm == ""
replace label = "S ommitted" if label == ""

* Generate parameter number variable for each set of results
sort idstr parm
by idstr: generate parmno = _n
label var parmno "Parameter number"

* Recode paremeter number to reflect order in regression results table
list parm parmno
recode parmno (1=19) (2=13) (3=11) (4=14) (5=5) (6=8) (7=3) (8=2) (9=4) /*
	*/ (10=7) (11=12) (12=9) (13=10) (14=16) (15=17) (16=15) (17=18) /*
	*/ (18=6) (19=1) (20=20) (21=21) (22=22)
tab parmno, m

* Define value labels for parameter number
label def parmnol /*
	*/ 1 "Foreign policy similarity" /*
	*/ 2 "Democracy (low)" /*
	*/ 3 "Democracy (high)" /*
	*/ 4 "Trade dependence (low)" /*
	*/ 5 "Financial openness (low)" /*
	*/ 6 "GDP per capita (low)" /*
	*/ 7 "GDP per capita x contiguity" /*
	*/ 8 "Contiguity" /*
	*/ 9 "Distance" /*
	*/ 10 "Major power" /*
	*/ 11 "Alliance" /*
	*/ 12 "Capability ratio" /*
	*/ 13 "Africa" /*
	*/ 14 "Asia" /*
	*/ 15 "Europe" /*
	*/ 16 "Middle East" /*
	*/ 17 "North America" /*
	*/ 18 "South America" /*
	*/ 19 "Constant" /*
	*/ 20 "Spline 1" /*
	*/ 21 "Spline 2" /*
	*/ 22 "Spline 3", modify
label val parmno parmnol
tab parmno, m
	
* Generate variable for model specification number
sort parmno idstr 
by parmno: generate modelno = _n
label var modelno "Model specification number"
label define modelnol /*
	*/ 1 "{it:S} omitted" /*
	*/ 2 "{it:S} (2-cat., original sample)" /*
	*/ 3 "{it:S} (2-cat.)" /*
	*/ 4 "{it:S} (3-cat.)" /*
	*/ 5 "{it:S} (abs. dist.)" /*
	*/ 6 "{it:S} (sqrd. dist.)" /*
	*/ 7 "Scott's {&pi}" /*
	*/ 8 "Cohen's {&kappa}", replace
label value modelno modelnol
tab modelno, m

* Generate alternative parameter order of first 7 variables
recode parmno (1=3) (2=1) (3=2) (4=6) (5=7) (6=4) (7=5), generate(parmno2)
label var parmno2 "Parameter number (reduced)"
label def parmno2l /*
	*/ 3 "Foreign policy similarity" /*
	*/ 1 "Democracy (low)" /*
	*/ 2 "Democracy (high)" /*
	*/ 6 "Trade dependence (low)" /*
	*/ 7 "Financial openness (low)" /*
	*/ 4 "GDP per capita (low)" /*
	*/ 5 "GDP per capita x contiguity" /*
	*/ 8 "Contiguity" /*
	*/ 9 "Distance" /*
	*/ 10 "Major power" /*
	*/ 11 "Alliance" /*
	*/ 12 "Capability ratio" /*
	*/ 13 "Africa" /*
	*/ 14 "Asia" /*
	*/ 15 "Europe" /*
	*/ 16 "Middle East" /*
	*/ 17 "North America" /*
	*/ 18 "South America" /*
	*/ 19 "Constant" /*
	*/ 20 "Spline 1" /*
	*/ 21 "Spline 2" /*
	*/ 22 "Spline 3", modify
label val parmno2 parmno2l
tab parmno2, m	

* Generate narrower model specification number variable
generate modelno2 = .
replace modelno2 = 1 if modelno == 1
replace modelno2 = 2 if modelno == 3
replace modelno2 = 3 if modelno == 5
replace modelno2 = 4 if modelno == 6
replace modelno2 = 5 if modelno == 7
replace modelno2 = 6 if modelno == 8
label var modelno2 "Model specification number (reduced)"
label define modelno2l /*
	*/ 1 "{it:S} omitted" /*
	*/ 2 "{it:S} (Gartzke)" /*
	*/ 3 "{it:S} (abs. dist.)" /*
	*/ 4 "{it:S} (sqrd. dist.)" /*
	*/ 5 "Scott's {&pi}" /*
	*/ 6 "Cohen's {&kappa}", replace
label value modelno2 modelno2l
tab modelno2, m


* Plot the 6 most important replication results for the first eight variables
eclplot estimate min95 max95 modelno2 if parmno2 < 8, /*
	*/ by(parmno2, xrescale hole(6) cols(3) note("") iscale(*.75)) /*
	*/ hori ylabel(1 2:6, valuelabel nogrid) subtitle(, size(medsmall)) /*
	*/ ciopts(lcolor(white)) estopts(mcolor(white)) /*
	*/ xline(0, lcolor(white) lpattern(-)) ytitle("Model specification", size(small)) /*
	*/ yscale(range(0.5 6.5)) xsize(5) ysize(4.5) /*
	*/ xtitle("          Parameter estimate and 95% conficence interval", size(small))


* Exit do-file
log close
exit
