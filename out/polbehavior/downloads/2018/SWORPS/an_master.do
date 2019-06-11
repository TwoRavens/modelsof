****************************************************************************************************************************************************************
*REPLICATION MATERIAL FOR 
*Däubler, T., L. Rudolph (2018) 
*"Cue-taking, satisficing, or both? Quasi-experimental evidence for ballot position effects", 
*Political Behavior, forthcoming.
*
*Version 1.0, written 2018-10-10
****************************************************************************************************************************************************************

****************************************************************************************************************************************************************
*This Do-File replicates the results presented in Tables 2 - 5 and A.2 - A.8 and Figure 1 and Figures A.1 and A.3
****************************************************************************************************************************************************************


****************************************************************************************************************************************************************
*prepare Stata

version 15
set more off
clear all
capture log close

/* if not already installed: install the followint Stata packages in order to run this do-file: 

estout by Ben Jann in Version st0085_2 (Stata Journal 14-2) via "findit st0085_2".
stripplot by Nicholas Cox from http://fmwww.bc.edu/RePEc/bocode/s
texsave by Julian Reif from http://fmwww.bc.edu/RePEc/bocode/t
sortobs by Julian Reif from http://fmwww.bc.edu/RePEc/bocode/s
svret by Julian Reif from http://fmwww.bc.edu/RePEc/bocode/s

*/

****************************************************************************************************************************************************************
*set working directory to folder containing the folder with subfolder for replication data ("data/master.dta") and subfolders "tables/" and "figures/" 

cd ""

log using replication.log, replace

****************************************************************************************************************************************************************
*open data set

use data/master.dta, clear

****************************************************************************************************************************************************************
*prepare for analysis and set makros

set matsize 5000

xtset newid stknr

global controls = "neighboring residence"

*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************
*FIGURES IN MAIN PAPER
*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************

********************************************************************************
*Figure 1: Effects of moving up one rank by rank and by omitted first versus any subsequent baseline list position
********************************************************************************

global controls = "neighboring residence"

eststo fig1: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)

*change labels for arrows in figure
preserve 

label variable twoone "2 `=ustrunescape("\u21d2")' 1"
label variable threetwo1 "3 `=ustrunescape("\u21d2")' 2"
label variable threetwo2 "3 `=ustrunescape("\u21d2")' 2"
label variable fourfivesix1 "4/5/6 `=ustrunescape("\u21d2")' 3/4/5"
label variable fourfivesix2p "4/5/6 `=ustrunescape("\u21d2")' 3/4/5"
label variable seveneightnineten1 "7/8/9/10 `=ustrunescape("\u21d2")' 6/7/8/9" 
label variable seveneightnineten2p "7/8/9/10 `=ustrunescape("\u21d2")' 6/7/8/9" // 8 `=ustrunescape("\u21d2")' 7 / 9 `=ustrunescape("\u21d2")' 8 / 
label variable eleventofifteen1  "11-15 `=ustrunescape("\u21d2")' 10-14"
label variable eleventofifteen2p  "11-15 `=ustrunescape("\u21d2")' 10-14"
 
 
coefplot (fig1, keep(twoone threetwo1 fourfivesix1  seveneightnineten1  eleventofifteen1 ) ///
	mcolor(blue) ciopts(lcolor(blue))  label("1{superscript:st} candidate is dropped" ) ) ///
	(fig1 , keep(threetwo2  fourfivesix2p  seveneightnineten2p eleventofifteen2p) ///
	mcolor(green) ciopts(lcolor(green)) msym(circle_hollow) label("2{superscript:nd} or other better placed is dropped"))  , ///
	order(twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p ///
	eleventofifteen1 eleventofifteen2p) ///
	scheme(s1mono)  nooffset ///
	plotregion(color(gs14))  xlabel(0(.25) 1.5, grid glcolor(white))  scale(0.9)
	
restore 

graph export "figures\figure1.tif" , replace width(4000)



*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************
*TABLES IN MAIN PAPER
*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************

********************************************************************************
*Table 1: Key theoretical expectations for a candidate’s intra-party vote share across the four ideal worlds
********************************************************************************

*Drawn manually


********************************************************************************
*Table 2: Baseline treatment effects of moving up one list position
********************************************************************************

*model with candidate fixed effects
eststo tab1m1: reg logsv  twoone threetwo fourfivesix seveneightnineten eleventofifteen listrank##listrank i.newid if listrank <=15 & listrank >=1 , cluster(candid)
eststo tab1m2: reg logsv  twoone threetwo fourfivesix seveneightnineten eleventofifteen listrank##listrank i.newid neighboring residence if listrank <=15 & listrank >=1 , cluster(candid)

*model with list fixed effects 
eststo tab1m3: reg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen   listrank##listrank i.wk_nr##i.year##i.party_nr  if listrank<=15 & listrank >=1 , cluster(candid)

esttab tab1m1 tab1m2 tab1m3 using "tables\table2.tex" ///
 , ///   
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N r2_a, label(N "Adjusted R^{2}")) ///
order() ///
drop() nobaselevels /// 
indicate("pre election rank= *listrank*" "list fixed effects = *wk_nr* *year* *party*" "candidate fixed effects = *newid*") ///
numbers  ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)



********************************************************************************
*Table 3:  Heterogeneity in treatment effects by features of dropped candidates
********************************************************************************

global controls = "residence neighboring"
capture drop qualdrop

eststo clear

gen qualdrop = dropspromi
label variable qualdrop "drops high appeal cand."
eststo tab3m1: xtreg logsv twoone##qualdrop threetwo##qualdrop  fourfivesix##qualdrop seveneightnineten##qualdrop eleventofifteen##qualdrop if  listrank <= 15, fe cluster(newid)
eststo tab3m2: xtreg logsv twoone##qualdrop threetwo##qualdrop  fourfivesix##qualdrop seveneightnineten##qualdrop eleventofifteen##qualdrop $controls if  listrank <= 15, fe cluster(newid)

replace qualdrop = (dropsinc==1 | dropspromi==1)
label variable qualdrop "drops high appeal cand."
eststo tab3m3: xtreg logsv twoone##qualdrop  threetwo##qualdrop  fourfivesix##qualdrop seveneightnineten##qualdrop eleventofifteen##qualdrop if  listrank <= 15, fe cluster(newid)
eststo tab3m4: xtreg logsv twoone##qualdrop  threetwo##qualdrop  fourfivesix##qualdrop seveneightnineten##qualdrop eleventofifteen##qualdrop $controls if listrank <= 15, fe cluster(newid)

esttab using "tables\table3.tex" ///
 , ///   
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N N_clust r2_w, label(N "Clusters" "Within R^{2}")) ///
order(*twoone* *threetwo* *four* ) /// *seven* *eleven* ) ///
drop() nobaselevels /// 
numbers  ///
mgroups("high appeal = minister or visible party office" "high appeal = incumbent MP or minister or visible party office", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)

drop qualdrop



********************************************************************************
*Table 4: Changes in vote shares if prominent candidate/incumbent further down the list drops 
********************************************************************************

eststo clear

*by listranks one, two and three, generate variable that indicates whether in any list position below listrank there is a prominent/incumbent politician dropped from the list 
foreach x in 1 2 3 {
capture drop dropspromidown 
capture drop dropsincdown 
gen dropspromidown = 0
gen dropsincdown = 0
replace dropspromidown = 1 if dropspromi == 1 & listrank_dropped > `x'
replace dropsincdown = 1 if dropsinc == 1 & listrank_dropped > `x'
eststo tab4m`x' : xtreg logsv treatment dropspromidown dropsincdown  if listrank==`x'  , fe cluster(newid)
}

*by listranks one, two and three, generate variable that indicates whether in subsequent two list positions below listrank there is a prominent/incumbent politician dropped from the list 
foreach x in 1 2 3 {
capture drop dropspromidown 
capture drop dropsincdown 
gen dropspromidown = 0
gen dropsincdown = 0
replace dropspromidown = 1 if dropspromi == 1 & listrank_dropped > `x' & (listrank_dropped < (`x'+2))  
replace dropsincdown = 1 if dropsinc == 1 & listrank_dropped > `x' & (listrank_dropped < (`x'+2))
eststo tab4m`x'plus3: xtreg logsv treatment dropspromidown dropsincdown  if listrank==`x' , fe cluster(newid)
}

label variable treatment "Moving up one rank"
label variable dropspromidown "Drops promi below $r_i$"
label variable dropsincdown "Drops incumbent below $r_i$"

esttab tab4m1 tab4m2 tab4m3 tab4m1plus3 tab4m2plus3 tab4m3plus3  using "tables\table4.tex" ///
 ,  mtitle ///
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N N_clust r2_w, label(N "Clusters" "Within R^{2}")) ///
order(treat* drops*) noomitted ///
drop() nobaselevels /// 
numbers  ///
mgroups("unrestricted drop" "drop in subsequent 2 listpositions", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)


********************************************************************************
*Table 5: Key theoretical expectations on what affects a candidate’s within-party-list vote share under OLPR and supporting evidence (grey) across the four theoretical models 
********************************************************************************

*Drawn manually


*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************
*FIGURES IN APPENDIX
*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************


********************************************************************************
*Figure A.1: Distribution of candidate OLPR votes (% and %, logged) in all districts by candidates with baseline pre-electoral list position one to nine 
********************************************************************************

*adapt label
label variable sv "OLPR candidate vote (%) in district"
label variable logsv "OLPR candidate vote (%, logged) in district"

preserve // in order to not permanently affect labels

label define listrank  1 "pre-electoral list position 1" 2 "pre-electoral list position 2" 3 "pre-electoral list position 3" 4 "pre-electoral list position 4" 5 "pre-electoral list position 5" 6 "pre-electoral list position 6"
label values listrank listrank

recode up 1=0 0=1
label define up 1 "baseline" 0 "moved up one rank", replace
label values up up

*create plot
stripplot sv if listrank<7 , ///
name(share, replace) by(listrank, rows(6) note("")) over(up) stack centre box(barw(0.8) blcolor(black)) ///
   width(0.1) cumpr mc(gs6 blue) scheme(s1color) yla(, ang(h)) legend(off) yscale(reverse) plotregion(color(gs15)) ///
   ytitle("") ysize(12) fxsize(100) ///
   xtitle("OLPR candidate vote (%) in district" , size(small) margin(20 0 0 0))

label define up 1 " " 0 " ", replace
label values up up
  
stripplot logsv if listrank<7 , ///
name(logged, replace) by(listrank, rows(6) note("")) over(up) stack centre box(barw(0.8) blcolor(black)) ///
   width(0.1) cumpr mc(gs6 blue) scheme(s1color) yla(, labcolor(bg)) legend(off) yscale(reverse) plotregion(color(gs15)) ///
   ytitle("") ysize(12) fxsize(67) ///
   xtitle("OLPR candidate vote (%, logged) in district" , size(small) )
   
graph combine share logged, scheme(s1color) ysize(12) xsize(8)

graph export "figures\figurea1.png", replace width(3000) height(3000)   

restore

*readapt label
label variable sv "OLPR candidate vote (\%) in district"
label variable logsv "OLPR candidate vote (\%, logged) in district"


****************************************************************************************************************************************************************
********************************************************************************
*Figure A.2: Geographical distribution of 2013 candidates on pre election listranks r=1 to r=3 by place of residence in Bavaria.   
********************************************************************************

*place of residence for candidates with baseline list position one to three stems from residence data of candidates provided by Bavarian Statistical Office
*place of residence is available at Bavarian Statistical Office 
*(Publication "Wahlkreisvorschläge, Bewerber", Kennziffer B VII 2-2, respective year [2013, 2008, 2003], Der Landeswahlleiter des Freistaates Bayern, Bayerisches Landesamt für Statistik und Datenverarbeitung)

*=> latitude and longitude generated based on this data with the geocode function (in R), drawing on Google Maps API

*=> Figure A.2 generated based on this list with software QGIS


****************************************************************************************************************************************************************
********************************************************************************
*Figure A.3: Geographical distribution of SMDs with 2013 candidates that have pre election listranks r=1 to r=3 in Bavaria.  
********************************************************************************

*generate list of SMDs that have, in 2013, a candidate with listrank 1/2/3 running. 

preserve

*drop list-only candidates
drop if smd==.

*reduce dataset to one observation per candidate 
keep year stk_residence smd candid name_simple party listrank 
duplicates drop year stk_residence smd candid name_simple party listrank, force

*reduce dataset to candidates with baseline list rank one to three
keep if listrank <=3

*reduce dataset to 2013
keep if year == 2013

sort listrank smd
bysort listrank: list smd

restore

*=> Figure A.3 generated based on this list with software QGIS


*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************
*TABLES IN APPENDIX
*______________________________________________________________________________________________________________
****************************************************************************************************************************************************************


****************************************************************************************************************************************************************
********************************************************************************
*Table A.1: Quantifying the share of voters influenced by list rank (figures in %)
********************************************************************************

*replicated by R script "appendix_share_switched.R" in replication file folder



********************************************************************************
*Table A.2: Baseline treatment effects - additional specifications for Models 1 and 2 in Table 2
********************************************************************************

eststo taba2m1 : reg logsv c.listrank##c.listrank $controls, cluster(newid)
eststo taba2m2 : xtreg logsv up $controls, fe cluster(newid)
eststo taba2m3 : xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen sixteentolast $controls, fe cluster(newid)


esttab taba2m1 taba2m2 taba2m3 using "tables\tablea2.tex" ///
 ,    nomtitles ///
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N N_clust r2_w r2_a, label(N "Clusters" "Within R^{2}" "Adj. R^{2}")) ///
order(*rank* up two* three* four* seven* eleven* sixteentolast) ///
drop() nobaselevels /// 
numbers  ///
mgroups("Logged second vote shares" , pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)


********************************************************************************
*Table A.3: Effects of moving up one rank assuming list fixed effects - full results for baseline list positions 1-15 (comp. Model 2-3)
********************************************************************************

eststo tab1m3istaba3m1: reg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen   listrank##listrank i.wk_nr##i.year##i.party_nr  if listrank<=15 & listrank >=1 , cluster(candid)
eststo taba3m2: reg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen   listrank##listrank i.wk_nr##i.year##i.party_nr neighboring residence if listrank<=15 & listrank >=1 , cluster(candid)


esttab tab1m3istaba3m1 taba3m2 using "tables\tablea3.tex" ///
 , ///   
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N r2_a, label(N "Adjusted R^{2}")) ///
order(twoone threetwo fourfivesix seveneightnineten eleventofifteen neighboring residence *listrank*) ///
drop() nobaselevels /// 
indicate("list fixed effects = *wk_nr* *year* *party*" "candidate fixed effects = ")  ///
numbers  ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)


********************************************************************************
*Table Table A.4: Effects of moving up one rank assuming list fixed effects - full results for baseline list positions 1-15 (comp. Model 2-3)
********************************************************************************

eststo taba4m1: xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen ///
	residence##treatment ///
	residence##i.listrank_cat ///
	neighboring##treatment ///
	neighboring##i.listrank_cat ///
	if listrank<=15, fe cluster(newid)
		
		
esttab taba4m1 using "tables/tablea4.tex" ///
 , ///   
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N N_clust r2_w, label(N "Clusters" "Within R^{2}")) ///
order(twoone threetwo fourfivesix seveneightnineten eleventofifteen *treat* ) ///
drop() nobaselevels noomitted /// 
numbers  ///
mgroups("logged shares" "logged shares", pattern(1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)




********************************************************************************
*Table A.5: Effects of moving up one rank by rank and by omitted first versus any subsequent baseline list position (as reported in Figure 1)
********************************************************************************

eststo taba5m1: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p if listrank<=15, fe cluster(newid)
eststo fig1istaba5m2: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)

esttab taba5m1 fig1istaba5m2 using "tables\tablea5.tex" ///
 , ///   
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N N_clust r2_w, label(N "Clusters" "Within R^{2}")) ///
order() ///
drop() nobaselevels /// 
numbers  ///
mgroups("OLPR candidate vote (\%, loggend) in district", pattern(1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)

*significant differences?
xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
lincom threetwo1 - threetwo2
lincom fourfivesix1 - fourfivesix2p 
lincom seveneightnineten1 - seveneightnineten2p 
lincom eleventofifteen1 - eleventofifteen2p 


********************************************************************************
*Table A.6: Comparability of listrank distributions by observable district covariates   
********************************************************************************

preserve
clear
tempfile output

*first round of loop to set up the output file for city-indicator-variable 
foreach x in urban {
use data/master.dta, clear
ksmirnov listrank if sv==. & listrank <= 15, by(`x') // calls only on observations with baseline list position less or equal 15 and with sv==., i.e. where observation is a candidate-district-year observation for an OLPR candidate who is running in this district-year as SMD candidate
svret r , long  format(%8.3fc) keep(r(D) r(p) r(p_cor))
rename contents `x'
save `output', replace
}

*repeat the KS-test for all other indicator variables and store results
foreach x in affair csu_fv_median employment_share_median immigrant_share_median population_median influx_median buildings_median farmers_median pc_tax_median {
use data/master.dta, clear
ksmirnov listrank if sv==. & listrank <= 15, by(`x')
svret r , long  format(%8.3fc) keep(r(D) r(p) r(p_cor))
rename contents `x'
merge 1:1 variable using `output'
drop _merge
save `output', replace
}

*prepare labelling
rename urban City
rename affair ScandalDistrict
rename csu_fv_median CSUFirstVote
rename employment_share_median EmploymentShare
rename immigrant_share_median ImmigrantShare
rename population_median PopulationDensity
rename influx_median PopulationInflux
rename buildings_median Constructions
rename farmers_median Farmers
rename pc_tax_median TaxPC
rename variable Statistic

replace Statistic = "Combined K-S" if Statistic == "r(D)"
replace Statistic = "p-value" if Statistic == "r(p)"
replace Statistic = "p-value (corrected)" if Statistic == "r(p_cor)"
set obs 4
foreach x of varlist TaxPC - City {
replace `x' = "673" in 4 // data on district covariates available for 2008 and 2013 only
}
replace Statistic = "N" in 4

*export table 

sortobs Statistic, values("Combined K-S" "p-value" "p-value (corrected)")
texsave using "tables\tablea6.tex", title(Comparability of listrank distributions by covariates in sample) ///
footnote("Two-sample Kolmogorov-Smirnov test for equality of distribution functions. Test reports whether distribution of listrank differs in characteristics of candidate-district observations where listrank is less or equal 15. Characteristics are expressed as binary variables (binary indicator or above/below 50th percentile). D-value of K-S-test as well as p-value and corrected p-value for a test on equality of distributions is reported. Data only available for observations from 2008 and 2013. Binary variables: district with 2013 CSU relatives affair \citep{Rudolph2016,Potrafke2016}, urban district (SMD district predominantly is a city or town); continuous variables, separated at 50th percentile: CSU first vote, employment share, immigrant share, population density, population influx (1000s), constructions (1000s), farmers (1000s), taxes per capita (1000s).") ///
frag size(footnotesize) replace

restore



********************************************************************************
*Table A.7: Effects in Table 2 for subgroups   
********************************************************************************

global controls = "neighboring residence"

*baseline for comparison
eststo b12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)

*effects with and without party leaders on the ballot
preserve
keep if spitzenkandidat==0
eststo s11: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo s12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if spitzenkandidat==1
eststo s21: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo s22: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore

*effects in high and low information environments , i.e. urban-rural

preserve
keep if urban==0
eststo u11: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo u12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if urban==1
eststo u21: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo u22: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore


*effects with relevant consequences for candidate ordering and where OLPR vote is only expressive (rest vs. CSU)

preserve
keep if party_nr != 1
eststo c11: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo c12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if party_nr == 1
eststo c21: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo c22: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore


*effects with above mean political interest in district

preserve
keep if highinterest==0
eststo i11: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo i12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if highinterest==1
eststo i21: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo i22: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore


*effects with above mean party rating in district

preserve
keep if highrating==0
eststo r11: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo r12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if highrating==1
eststo r21: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo r22: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore


*effects with higher complexity in choice sets, i.e. longer list length
*
*variation in list lengths by regional districts: 
	*1 obb: up to 60
	*2 nb: 18
	*3 op: up to 17
	*4 of: up to 17
	*5 mf: 25
	*6 uf: 20
	*7 schw: 26
*cutoffs: <=20, <=40, <=60

global controls = "neighboring residence"

preserve
keep if length==1
eststo l11: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo l12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if length==2
eststo l21: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo l22: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if length==3
eststo l31: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo l32: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore


*effect for district that is congruent with only one media market (Swabia)

global controls = "neighboring residence"

preserve
keep if wknr!=7
eststo m11: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo m12: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore
preserve
keep if wknr==7
eststo m21: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen  if listrank<=15, fe cluster(newid)
eststo m22: quietly xtreg logsv twoone threetwo fourfivesix seveneightnineten eleventofifteen $controls if listrank<=15, fe cluster(newid)
restore


*all models in one table (only models estimated with inclusion of controls)

esttab  ??2 using "tables\tablea7.tex" ///
 ,    nomtitles ///
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N N_clust r2_w, label(N "Clusters" "Within R^{2}")) ///
order(two* three* four* seven* eleven*) ///
drop() nobaselevels /// 
numbers  ///
mgroups("Main effect" "Frontrunner on ballot (no/yes)" "Urban setting (no/yes)" "Dominant party (CSU) (no/yes)"  "Above average political interest (no/yes)" "Above average rating (no/yes)" "Short/medium/long list" "One media market (no/yes)", pattern(1 1 0 1 0 1 0 1 0 1 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)


********************************************************************************
*Table A.8: Effects in Table A.5 for subgroups   
********************************************************************************

eststo clear

*baseline
eststo base: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)

*effects for various binary subgroups
foreach x in spitzenkandidat urban party_csu highinterest highrating  {

preserve
keep if `x' == 0
eststo `x'0: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
restore

preserve
keep if `x' == 1
eststo `x'1: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
restore

}

*effects for subgroup listlenght

preserve
keep if length == 1
eststo length1: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
restore

preserve
keep if length == 2
eststo length2: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
restore

preserve
keep if length == 3
eststo length3: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
restore

*effects for subgroup media market
preserve
keep if wknr != 7
eststo wknr0: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
restore

preserve
keep if wknr == 7
eststo wknr1: xtreg logsv twoone threetwo? fourfivesix1 fourfivesix2p seveneightnineten1 seveneightnineten2p eleventofifteen1 eleventofifteen2p $controls if listrank<=15, fe cluster(newid)
restore

*table output
esttab  using "tables/tablea8.tex" ///
 ,    nomtitles ///
label se(a2) b(a2) replace star(+ 0.1 * 0.05 ** 0.01)  stats(N N_clust r2_w, label(N "Clusters" "Within R^{2}")) ///
order(two* three* four* seven* eleven*) ///
drop() nobaselevels /// 
numbers  ///
mgroups("Main effect" "Frontrunner on ballot (no/yes)" "Urban setting (no/yes)" "Dominant party (CSU) (no/yes)" "Above average political interest (no/yes)" "Above average rating (no/yes)" "Short/medium/long list" "One media market (no/yes)", pattern(1 1 0 1 0 1 0 1 0 1 0 1 0 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
)


*********************************************
*END
*********************************************

log close
