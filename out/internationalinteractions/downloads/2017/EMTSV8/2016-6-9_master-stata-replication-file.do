log using esarey-demeritt-nameshame.log, replace

*****************************************************
* Create bilateral aid boxplots
*****************************************************


clear all
set mem 1000M
set more off
set matsize 800

use "ISQ 2010 Murdie Davis final to ISQ.dta", clear
rename cowcode CCODE
rename year YEAR
save murdie_merge.dta, replace

** merge in public resolution data
use jprworkdatanew.dta, clear

quietly{
tsset CCODE YEAR
gen X=YEAR-1990
gen linear=2*X
gen quad=(4*(X*X))-2
gen tri=8*(X*X*X)-12*X
replace WBCOMMIT=WBCOMMIT*1000000
replace BILATCOM=BILATCOM*1000000
replace MULTCOM=MULTCOM*1000000
gen WBPOP=WBCOMMIT/POPULATI
gen BIPOP=BILATCOM/POPULATI
gen MUPOP=MULTCOMM/POPULATI
gen GDPPOP=GDP/POPULATI
replace WBPOP=1 if WBPOP<1 & WBPOP !=.
replace WBPOP=ln(WBPOP) 
replace BIPOP=1 if BIPOP<1 & BIPOP !=.
replace BIPOP=ln(BIPOP) 
replace MUPOP=1 if MUPOP<1 & MUPOP !=.
replace MUPOP=ln(MUPOP) 
replace GDPPOP=ln(GDPPOP)
drop if YEAR>2002

merge m:1 CCODE YEAR using murdie_merge.dta
tsset CCODE YEAR 

}



gen d_lnBIPOP = BIPOP - l.BIPOP
gen lagBIPOP = l.BIPOP


twoway (kdensity d_lnBIPOP if(PUBRES==0 & lagBIPOP<3.25), range(-2 2)) (kdensity d_lnBIPOP if(PUBRES==1 & lagBIPOP<3.25) , range(-2 2)), name(panela, replace) ysize(5) xsize(5) nodraw 
twoway (kdensity d_lnBIPOP if(PUBRES==0 & lagBIPOP>=3.25), range(-2 2)) (kdensity d_lnBIPOP if(PUBRES==1 & lagBIPOP>=3.25) , range(-2 2)), name(panelb, replace) ysize(5) xsize(5) nodraw 

graph hbox d_lnBIPOP if(lagBIPOP<3.25), over(PUBRES) name(panela, replace) nodraw yscale(r(-4 4)) ylabel(#5)
graph hbox d_lnBIPOP if(lagBIPOP>=3.25), over(PUBRES) name(panelb, replace) nodraw yscale(r(-4 4)) ylabel(#5)
graph combine panela panelb, rows(2) commonscheme scheme(s2mono) ysize(5) xsize(10)

reg d_lnBIPOP PUBRES if lagBIPOP<3.25
reg d_lnBIPOP PUBRES if lagBIPOP>=3.25



graph hbox d_lnBIPOP if(BIPOP<3.25), over(PUBRES) name(panela, replace) nodraw yscale(r(-4 4)) ylabel(#5)
graph hbox d_lnBIPOP if(BIPOP>=3.25), over(PUBRES) name(panelb, replace) nodraw yscale(r(-4 4)) ylabel(#5)
graph combine panela panelb, rows(2) commonscheme scheme(s2mono) ysize(5) xsize(10)

reg d_lnBIPOP PUBRES if BIPOP<3.25
reg d_lnBIPOP PUBRES if BIPOP>=3.25


graph hbox BIPOP if(lagBIPOP<3.25), over(PUBRES, relabel(1 "not condemned" 2 "condemned")) name(panela, replace) nodraw yscale(r(0 8)) ylabel(#5) ytitle("ln(aggregate bilateral aid PC + 1)") title("lag ln(aggregate bilateral aid PC + 1) < 3.25")

graph hbox BIPOP if(lagBIPOP>=3.25),over(PUBRES, relabel(1 "not condemned" 2 "condemned")) name(panelb, replace) nodraw yscale(r(0 8))  ylabel(#5) ytitle("ln(aggregate bilateral aid PC + 1)") title("lag ln(aggregate bilateral aid PC + 1) {&ge} 3.25")

graph combine panela panelb, cols(1) commonscheme scheme(s2mono) ysize(5) xsize(10)

graph export aid_by_lag.eps, replace

tobit BIPOP PUBRES if BIPOP<3.25, ll(0)
tobit BIPOP PUBRES if BIPOP>=3.25, ll(0)



gen ngodum = .
replace ngodum = 1 if l.HRnc2gcnc2>=1 & l.HRnc2gcnc2!=.
replace ngodum = 0 if l.HRnc2gcnc2<1 & l.HRnc2gcnc2!=.

graph hbox BIPOP if(lagBIPOP<3.25), over(ngodum, relabel(1 "no shaming events" 2 "any shaming events")) name(panela, replace) nodraw yscale(r(0 8)) ylabel(#5) ytitle("ln(aggregate bilateral aid PC + 1)") title("lag ln(aggregate bilateral aid PC + 1) < 3.25")

graph hbox BIPOP if(lagBIPOP>=3.25),over(ngodum,  relabel(1 "no shaming events" 2 "any shaming events"))  name(panelb, replace) nodraw yscale(r(0 8))  ylabel(#5) ytitle("ln(aggregate bilateral aid PC + 1)") title("lag ln(aggregate bilateral aid PC + 1) {&ge} 3.25")

graph combine panela panelb, cols(1) commonscheme scheme(s2mono) ysize(5) xsize(10)

graph export aid_by_lag_ngo.eps, replace

tobit BIPOP ngodum if BIPOP<3.25, ll(0)
tobit BIPOP ngodum if BIPOP>=3.25, ll(0)

gen lagdum = .
replace lagdum = 1 if BIPOP>=3.25 & BIPOP!=.
replace lagdum = 0 if BIPOP<3.25 & BIPOP!=.
xi: tobit BIPOP i.ngodum*i.lagdum, ll(0)


gen PUBRES_jit = PUBRES + (0.75* (runiform() - 0.5) )
twoway (scatter PUBRES_jit l.HRnc2gcnc2 if(l.HRnc2gcnc2 < 11)) (qfit PUBRES l.HRnc2gcnc2), ytitle("UNCHR Resolution (with jitter)") xtitle("Count of NGO Shaming Events") legend(label(1 "Recipient Country-Year") label(2 "Quadratic Fit")) ylabel(0 "No" 1 "Yes") scheme(s2mono)

graph export pubresVsNgo.eps, replace

unique COUNTRY if e(sample)
tab YEAR if e(sample)

sum PUBRES l.HRnc2gcnc2 if e(sample)
gen lagHRnc2gcnc2 = l.HRnc2gcnc2
tab lagHRnc2gcnc2 PUBRES if e(sample)
sum PUBRES ngodum if e(sample)
tab ngodum PUBRES if e(sample), column row

gen HRnc2gcnc2_sq = (l.HRnc2gcnc2)^2
reg PUBRES l.HRnc2gcnc2 HRnc2gcnc2_sq
estat ic

reg PUBRES l.HRnc2gcnc2
estat ic

gen lagHRIGHTS = l.HRIGHTS
gen lagCIVIL = l.CIVIL
gen lagGDPPOP = l.GDPPOP
gen lagLNPOP = l.LNPOP
gen lagUSAGREE = l.USAGREE

label variable BIPOP "ln (Bilateral aid PC + 1)"
label variable lagBIPOP "lag ln (Bilateral aid PC + 1)"
label variable lagHRIGHTS "lag Personal Integrity Abuse"
label variable lagCIVIL "lag Civil Liberties"
label variable lagGDPPOP "lag ln GDP per capita"
label variable lagLNPOP "lag ln Population"
label variable lagUSAGREE "lag Agreement with USA"
label variable WAR "lag War"
label variable CAPAB "lag CINC Capabilities"
label variable PUBRES "lag UNCHR resolution"

label define PUBRES 0 "No Resolution" 1 "Resolution Passed"
label values PUBRES PUBRES

bysort PUBRES: eststo: estpost summarize BIPOP lagBIPOP lagCIVIL lagGDPPOP lagLNPOP lagUSAGREE WAR CAPAB polity2 if lagHRIGHTS < 2.5
bysort PUBRES: eststo: estpost summarize BIPOP lagBIPOP lagCIVIL lagGDPPOP lagLNPOP lagUSAGREE WAR CAPAB polity2 if lagHRIGHTS >= 2.5
esttab using unchr-summary.tex, cells(mean(fmt(3)) sd(par fmt(3)) ) label nodepvar varwidth(30) modelwidth(26) mtitles("\shortstack{low abuse\\no resolution}" "\shortstack{low abuse\\resolution passed}" "\shortstack{high abuse\\no resolution}" "\shortstack{high abuse\\resolution passed}") nonumbers title("Summary Statistics for State-Years, by UNCHR Shaming Resolution Status and Lagged Personal Integrity Abuse Score*\label{tab:unchrsum-1}") replace
estimates clear

label define ngodum 0 "No Shaming" 1 "Shaming"
label values ngodum ngodum

bysort ngodum: eststo: estpost summarize BIPOP lagBIPOP lagCIVIL lagGDPPOP lagLNPOP lagUSAGREE WAR CAPAB polity2 if lagHRIGHTS < 2.5
bysort ngodum: eststo: estpost summarize BIPOP lagBIPOP lagCIVIL lagGDPPOP lagLNPOP lagUSAGREE WAR CAPAB polity2 if lagHRIGHTS >= 2.5
esttab using ngo-summary.tex, cells(mean(fmt(3)) sd(par fmt(3)) ) label nodepvar varwidth(30) modelwidth(26) mtitles("\shortstack{low abuse\\no shaming}" "\shortstack{low abuse\\shaming}" "\shortstack{high abuse\\no shaming}" "\shortstack{high abuse\\shaming}") nonumbers title("Summary Statistics for State-Years, by Murdie and Davis (2012) NGO Shaming Status and Lagged Personal Integrity Abuse Score*\label{tab:ngosum-1}") replace
estimates clear

*****************************************************
* Create aid flow data plots for Guatemala and
* El Salvador
*****************************************************



clear all
set mem 1000M
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear

quietly{
tsset CCODE YEAR
gen X=YEAR-1990
gen linear=2*X
gen quad=(4*(X*X))-2
gen tri=8*(X*X*X)-12*X
replace WBCOMMIT=WBCOMMIT*1000000
replace BILATCOM=BILATCOM*1000000
replace MULTCOM=MULTCOM*1000000
gen WBPOP=WBCOMMIT/POPULATI
gen BIPOP=BILATCOM/POPULATI
gen MUPOP=MULTCOMM/POPULATI
gen GDPPOP=GDP/POPULATI
replace WBPOP=1 if WBPOP<1 & WBPOP!=.
replace WBPOP=ln(WBPOP) 
replace BIPOP=1 if BIPOP<1 & BIPOP!=.
replace BIPOP=ln(BIPOP) 
replace MUPOP=1 if MUPOP<1 & MUPOP!=.
replace MUPOP=ln(MUPOP) 
replace GDPPOP=ln(GDPPOP)
drop if YEAR>2002
}

rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta

gen PUBRES_plot = 12*PUBRES

twoway  (bar PUBRES_plot year if countryname=="Guatemala", color(gs13)) (scatter lneconaidpc year if countryname=="Guatemala" & donorname=="United States") (lowess lneconaidpc year if countryname=="Guatemala" & donorname=="United States" & year>1980, bwidth(0.3)) (scatter lneconaidpc year if countryname=="Guatemala" & donorname=="Belgium") (lowess lneconaidpc year if countryname=="Guatemala" & donorname=="Belgium", bwidth(0.3)), legend(holes(2) label(1 "Guatemala condemned by UNCHR resolution") label(2 "ln(aid PC + 1) from the US") label(3 "smoothed aid from the US") label(4 "ln(aid PC + 1) from Belgium") label(5 "smoothed aid from Belgium")) scheme(s2mono) graphregion(fcolor("white")) ylabel(0 2 4 6 8 10)


gr_edit .legend.plotregion1.label[1].xoffset = 18
gr_edit .legend.plotregion1.key[1].xoffset = 18
gr_edit .legend.plotregion1.label[3].xoffset = -10
gr_edit .legend.plotregion1.key[3].xoffset = -10
gr_edit .legend.plotregion1.label[5].xoffset = -10
gr_edit .legend.plotregion1.key[5].xoffset = -10


drop PUBRES_plot

graph export guatemala-dyad-aid.eps, replace


* how much does Guatemalan aid change?
list lneconaidpc year countryname donorname PUBRES if countryname=="Guatemala" & donorname=="United States"
display exp(9.250107) - 1
display exp(7.899117) - 1

gen PUBRES_plot = 12*PUBRES

twoway  (bar PUBRES_plot year if countryname=="El Salvador", color(gs13)) (scatter lneconaidpc year if countryname=="El Salvador" & donorname=="United States") (lowess lneconaidpc year if countryname=="El Salvador" & donorname=="United States", bwidth(0.3)) (scatter lneconaidpc year if countryname=="El Salvador" & donorname=="Belgium") (lowess lneconaidpc year if countryname=="El Salvador" & donorname=="Belgium", bwidth(0.3)), legend(holes(2) label(1 "El Salvador condemned by UNCHR resolution") label(2 "ln( aid PC + 1) from the US") label(3 "smoothed aid from the US") label(4 "ln(aid PC + 1) from Belgium") label(5 "smoothed aid from Belgium")) scheme(s2mono) graphregion(fcolor("white")) ylabel(0 2 4 6 8 10 12)


gr_edit .legend.plotregion1.label[1].xoffset = 18
gr_edit .legend.plotregion1.key[1].xoffset = 18
gr_edit .legend.plotregion1.label[3].xoffset = -10
gr_edit .legend.plotregion1.key[3].xoffset = -10
gr_edit .legend.plotregion1.label[5].xoffset = -10
gr_edit .legend.plotregion1.key[5].xoffset = -10


drop PUBRES_plot

graph export elsalvador-dyad-aid.eps, replace




*****************************************************
* Neilsen data
* dyadic aid flow analysis
* Lebovic/Voeten UNCHR condemnation variable
*****************************************************

* create common sample for old and new models

clear all
set mem 1000M
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lagXpub = PUBRES*l.lneconaidpc

* the neilsen model
eststo neilsen: xttobit lneconaidpc l.physint l.alliance l.alliance_physint l.donorallyneighbor2 l.allyneighbor2_physint l.s3un l.s3un_physint l.lnreftotal l.lnreftotal_physint l.lnnytimes l.lnnytimes_physint l.ratpercent l.ratpercent_physint l.donor_physint l.donor_physint_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.ColdWar_physint l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(20)

tab year if e(sample)
gen neil_samp = 0
replace neil_samp = 1 if e(sample)
esttab using table1.csv, csv nogaps replace

unique countryname if e(sample)
estadd scalar countries = r(sum): neilsen

unique donorname if e(sample)
estadd scalar donors = r(sum): neilsen

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): neilsen

* how many countries are condemned in the window of this model?
unique countryname if e(sample) & PUBRES == 1

* the esarey-demeritt model
eststo esdem3: xttobit lneconaidpc PUBRES lagXpub l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

tab year if e(sample)
gen ed_samp = 0
replace ed_samp = 1 if e(sample)
esttab using table3.csv, csv nogaps replace

* how many countries are condemned in the window of this model?
unique countryname if e(sample) & PUBRES == 1

*Grab necessary elements of the B and VCV matrixes needed to calculate MFX and SEs
matrix b=e(b)
mat2txt, matrix(b) saving(xttobit_beta.txt) replace

matrix V=e(V)
mat2txt, matrix(V) saving(xttobit_VCV.txt) replace


unique countryname if e(sample)
estadd scalar countries = r(sum): esdem3

unique donorname if e(sample)
estadd scalar donors = r(sum): esdem3

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): esdem3


* determine average values for marginal effects plots
summarize PUBRES lagXpub l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(ed_samp==1)


tab ed_samp neil_samp

gen comm_samp = 0
replace comm_samp=1 if neil_samp==1 & ed_samp==1

tab ed_samp comm_samp
tab neil_samp comm_samp

keep dyadnum year comm_samp neil_samp ed_samp
save common_sample.dta, replace





** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lagXpub = PUBRES*l.lneconaidpc


* calculate common sample AIC/BIC of the neilsen model
drop _merge
merge m:1 dyadnum year using common_sample.dta
tsset dyadnum year
xttobit lneconaidpc l.physint l.alliance l.alliance_physint l.donorallyneighbor2 l.allyneighbor2_physint l.s3un l.s3un_physint l.lnreftotal l.lnreftotal_physint l.lnnytimes l.lnnytimes_physint l.ratpercent l.ratpercent_physint l.donor_physint l.donor_physint_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.ColdWar_physint l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(comm_samp==1), ll(0) intpoints(20)
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: neilsen
estadd scalar BIC = bicsto: neilsen

* compare to version 9 results
version 9
xttobit lneconaidpc l.physint l.alliance l.alliance_physint l.donorallyneighbor2 l.allyneighbor2_physint l.s3un l.s3un_physint l.lnreftotal l.lnreftotal_physint l.lnnytimes l.lnnytimes_physint l.ratpercent l.ratpercent_physint l.donor_physint l.donor_physint_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.ColdWar_physint l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(20)
version 14.1


* calculate common sample AIC/BIC of the esarey-demeritt model
xttobit lneconaidpc PUBRES lagXpub l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(comm_samp==1), ll(0) intpoints(20)
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: esdem3
estadd scalar BIC = bicsto: esdem3


* compare to version 9 results
version 9
xttobit lneconaidpc PUBRES lagXpub l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)
version 14.1

gen l_lneconaidpc = L.lneconaidpc
keep if e(sample)
saveold neilsen_3_R_figure_data.dta, version(12) replace


***
* remove all the physint interactions and add PUBRES interactions
***

** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lagXpub = PUBRES*l.lneconaidpc


eststo neilsen2: xttobit lneconaidpc PUBRES l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if inmysample==1, ll(0) intpoints(19)

esttab using table2.csv, csv nogaps replace

unique countryname if e(sample)
estadd scalar countries = r(sum): neilsen2

unique donorname if e(sample)
estadd scalar donors = r(sum): neilsen2

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): neilsen2

* how many countries are condemned in the window of this model?
unique countryname if e(sample) & PUBRES == 1


* calculate common sample AIC/BIC of this model
drop _merge
merge m:1 dyadnum year using common_sample.dta
tsset dyadnum year

xttobit lneconaidpc PUBRES l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(comm_samp==1), ll(0) intpoints(20)
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: neilsen2
estadd scalar BIC = bicsto: neilsen2


* compare to version 9 results
version 9
xttobit lneconaidpc PUBRES l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if inmysample==1, ll(0) intpoints(19)
version 14.1



***
* PUBRES with the lag interaction, but no other interactions
***

eststo esdem4: xttobit lneconaidpc PUBRES lagXpub l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

esttab using table4.csv, csv nogaps replace


unique countryname if e(sample)
estadd scalar countries = r(sum): esdem4

unique donorname if e(sample)
estadd scalar donors = r(sum): esdem4

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): esdem4

* how many countries are condemned in the window of this model?
unique countryname if e(sample) & PUBRES == 1


* calculate common sample AIC/BIC of this model
xttobit lneconaidpc PUBRES lagXpub l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(comm_samp==1), ll(0) intpoints(20)
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: esdem4
estadd scalar BIC = bicsto: esdem4

	

esttab neilsen neilsen2 esdem3 esdem4 using "neilsen.tex", title("State-dependence in Dyadic Bilateral Aid Flows*\label{tab:Neilsen-1}") longtable replace keep(L.lneconaidpc L.physint PUBRES lagXpub L.alliance L.alliance_physint allXpub L.donorallyneighbor2 L.allyneighbor2_physint neiXpub L.s3un L.s3un_physint s3unXpub) order(L.lneconaidpc L.physint PUBRES lagXpub L.alliance L.alliance_physint allXpub L.donorallyneighbor2 L.allyneighbor2_physint neiXpub L.s3un L.s3un_physint s3unXpub) eqlabels(,none) nomtitles nodepvars coeflabels(L.lneconaidpc  "DV\$_{i(t-1)}$" L.physint  "Physical Integrity Violations\$_{i(t-1)}$" PUBRES "UNCHR Resolution\$_{i(t-1)}$" lagXpub "DV\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.alliance "Alliance\$_{i(t-1)}$" L.alliance_physint "Alliance\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" allXpub "Alliance\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$_{i(t-1)}$" L.allyneighbor2_physint "Ally Neighbor\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" neiXpub "Ally Neighbor\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.s3un "UN Voting Similarity\$_{i(t-1)}$" L.s3un_physint "UN Similarity\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" s3unXpub "UN Similarity\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$") noabbrev wrap gaps varwidth(48) align(r) substitute(\_ _) stats(N dyads countries donors blank AIC BIC, labels("Observations" "Dyads" "Recipients" "Donors" " " "AIC" "BIC"))






*****************************************************
* Neilsen data
* dyadic aid flow analysis
* Murdie/Davis NGO Shaming variable
*****************************************************


clear all
set more off
set matsize 800


** merge in NGO data
use "ISQ 2010 Murdie Davis final to ISQ.dta", clear
rename cowcode countrynumcode_g
save murdie_merge.dta, replace

** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using murdie_merge.dta
drop if _merge==2

drop _merge

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year


* no interactions
eststo ngoplain: tobit lneconaidpc L.HRnc2gcnc2 l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) cluster(dyadnum)

estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoplain
estadd scalar BIC = bicsto: ngoplain

scalar drop aicsto bicsto
mat drop icsto

unique countryname if e(sample)
estadd scalar countries = r(sum): ngoplain

unique donorname if e(sample)
estadd scalar donors = r(sum): ngoplain

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): ngoplain


gen allXngo = l.HRnc2gcnc2*l.alliance
gen neiXngo = l.HRnc2gcnc2*l.donorallyneighbor2
gen s3unXngo = l.HRnc2gcnc2*l.s3un

gen lagXngo = l.HRnc2gcnc2*l.lneconaidpc

* lag interaction with PUBRES only
eststo ngoreg: tobit lneconaidpc L.HRnc2gcnc2 lagXngo l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) cluster(dyadnum)


estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoreg
estadd scalar BIC = bicsto: ngoreg


tab year if e(sample)

unique countryname if e(sample)
estadd scalar countries = r(sum): ngoreg

unique donorname if e(sample)
estadd scalar donors = r(sum): ngoreg

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): ngoreg


* save information necessary to generate marginal effects plots
matrix b=e(b)
mat2txt, matrix(b) saving(tobit_beta_ngo.txt) replace

matrix V=e(V)
mat2txt, matrix(V) saving(tobit_VCV_ngo.txt) replace





clear
set mem 1000M
set more off
set matsize 800



** merge in NGO data
use "ISQ 2010 Murdie Davis final to ISQ.dta", clear
rename cowcode countrynumcode_g
save murdie_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using murdie_merge.dta
drop if _merge==2

tsset dyadnum year


gen ngodum = .
replace ngodum = 1 if l.HRnc2gcnc2>=1 & l.HRnc2gcnc2!=.
replace ngodum = 0 if l.HRnc2gcnc2<1 & l.HRnc2gcnc2!=.


* no interactions
eststo ngoplain2: tobit lneconaidpc ngodum l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) cluster(dyadnum)

estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoplain2
estadd scalar BIC = bicsto: ngoplain2

unique countryname if e(sample)
estadd scalar countries = r(sum): ngoplain2

unique donorname if e(sample)
estadd scalar donors = r(sum): ngoplain2

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): ngoplain2

gen allXngodum = ngodum*l.alliance
gen neiXngodum = ngodum*l.donorallyneighbor2
gen s3unXngodum = ngodum*l.s3un

gen lagXngodum = ngodum*l.lneconaidpc


* lag interaction with PUBRES only
eststo ngoreg2: tobit lneconaidpc ngodum lagXngodum l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) cluster(dyadnum)

estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoreg2
estadd scalar BIC = bicsto: ngoreg2

tab year if e(sample)

unique countryname if e(sample)
estadd scalar countries = r(sum): ngoreg2

unique donorname if e(sample)
estadd scalar donors = r(sum): ngoreg2

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): ngoreg2

* save information necessary to generate marginal effects plots
matrix b=e(b)
mat2txt, matrix(b) saving(tobit_beta_ngo2.txt) replace

matrix V=e(V)
mat2txt, matrix(V) saving(tobit_VCV_ngo2.txt) replace


esttab ngoplain ngoreg ngoplain2 ngoreg2 using "ngo-tobits.tex", title("State-Dependence in Dyadic Bilateral Economic Aid Flows, Murdie and Davis (2012) NGO Shaming Measure*\label{tab:State-Dependence-NGO}") longtable replace order(L.lneconaidpc L.physint L.HRnc2gcnc2 lagXngo ngodum lagXngodum L.alliance L.donorallyneighbor2 L.s3un) keep(L.lneconaidpc L.HRnc2gcnc2 lagXngo ngodum lagXngodum L.physint L.alliance L.donorallyneighbor2 L.s3un) eqlabels(,none) nomtitles nodepvars coeflabels(L.lneconaidpc "DV\$_{i(t-1)}$" L.physint "Physical Integrity Violations\$\_{i(t-1)}$" L.HRnc2gcnc2 "NGO Shaming\$\_{i(t-1)}$" lagXngo "DV\$\_{i(t-1)}$ * NGO Shaming\$\_{i(t-1)}$" ngodum "NGO Shaming\$\_{i(t-1)} \geq 1$" lagXngodum "DV\$\_{i(t-1)}$ * NGO Shaming\$\_{i(t-1)} \geq 1$" L.alliance "Alliance\$\_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$\_{i(t-1)}$" L.s3un "UN Voting Similarity\$\_{i(t-1)}$") noabbrev wrap gaps varwidth(50) align(r) substitute(\_ _) stats(N dyads countries donors blank AIC BIC, labels("Observations" "Dyads" "Recipients" "Donors" " " "AIC" "BIC"))

gen l_lneconaidpc = L.lneconaidpc
keep if e(sample)
saveold "ngo-shaming.dta", replace version(12)



*****************************************************
* Lebovic and Voeten data
* aggregate bilateral aid analysis
*****************************************************

clear all

use "ISQ 2010 Murdie Davis final to ISQ.dta", clear
rename cowcode CCODE
rename year YEAR
save murdie_merge.dta, replace


quietly{
clear
clear matrix
set mem 1000m
set matsize 1000
use jprworkdatanew.dta, clear
*tsset idorigin year, yearly
set seed 091836
set more off
}

* Begin replication code provided by the authors):
* (Lebovic and Voeten Table 2)

quietly{
tsset CCODE YEAR
gen X=YEAR-1990
gen linear=2*X
gen quad=(4*(X*X))-2
gen tri=8*(X*X*X)-12*X
replace WBCOMMIT=WBCOMMIT*1000000
replace BILATCOM=BILATCOM*1000000
replace MULTCOM=MULTCOM*1000000
gen WBPOP=WBCOMMIT/POPULATI
gen BIPOP=BILATCOM/POPULATI
gen MUPOP=MULTCOMM/POPULATI
gen GDPPOP=GDP/POPULATI
replace WBPOP=1 if WBPOP<1
replace WBPOP=ln(WBPOP) 
replace BIPOP=1 if BIPOP<1
replace BIPOP=ln(BIPOP) 
replace MUPOP=1 if MUPOP<1
replace MUPOP=ln(MUPOP) 
replace GDPPOP=ln(GDPPOP)
drop if YEAR>2002
*End replication code

gen l_BIPOP = l.BIPOP
gen d_HRIGHTS = d.HRIGHTS
gen l_HRIGHTS = l.HRIGHTS
gen d_CIVIL = d.CIVIL
gen l_CIVIL = l.CIVIL
gen l_GDPPOP = l.GDPPOP
gen l_LNPOP = l.LNPOP
gen l_USAGREE = l.USAGREE


*Generate necessary interactions
gen RESxBI=PUBRES*l.BIPOP
gen RESxMU=PUBRES*l.MUPOP
gen RESxWB=PUBRES*l.WBPOP
gen RESxAG=PUBRES*l.USAGREE
}

* LV Table 2 replication
eststo lvrep: xtreg BIPOP l.BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: lvrep
estadd scalar BIC = bicsto: lvrep

unique CCODE if e(sample)
estadd scalar countries = r(sum): lvrep

tab YEAR if e(sample)

* variation in variables in this model
summarize BIPOP PUBRES  d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad  if e(sample)

* how many countries are condemned in the window of this model?
unique CCODE if e(sample) & PUBRES == 1

* with interaction
eststo lvinteract: xtreg BIPOP l.BIPOP PUBRES RESxBI d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: lvinteract
estadd scalar BIC = bicsto: lvinteract

unique CCODE if e(sample)
estadd scalar countries = r(sum): lvinteract

tab YEAR if e(sample)

esttab lvrep lvinteract using "bipop.tex", longtable title("State-dependence in Aggregate Bilateral Aid Flows, UNCHR Resolution Shaming Measure*\label{tab:LV}") replace order(L.BIPOP PUBRES RESxBI D.HRIGHTS L.HRIGHTS D.CIVIL L.CIVIL L.GDPPOP L.LNPOP L.USAGREE WAR CAPAB linear quad) keep(L.BIPOP PUBRES RESxBI D.HRIGHTS L.HRIGHTS D.CIVIL L.CIVIL L.GDPPOP L.LNPOP L.USAGREE WAR CAPAB linear quad) eqlabels(,none) nomtitles nodepvars coeflabels(L.BIPOP "DV\$_{i(t-1)}$" PUBRES "UNCHR Resolution\$\_{i(t-1)}$" RESxBI "DV\$_{i(t-1)}$ * UNCHR Res\$\_{i(t-1)}$" L.USAGREE "Agreement with USA\$\_{i(t-1)}$" D.HRIGHTS "\$\Delta$ Personal Integrity Abuse" L.HRIGHTS "Personal Integrity Abuse\$\_{i(t-1)}$" D.CIVIL "\$\Delta$ Civil Liberties" L.CIVIL "Civil Liberties\$\_{i(t-1)}$" L.GDPPOP "ln GDP per capita\$\_{i(t-1)}$" L.LNPOP "ln population\$\_{i(t-1)}$" WAR "War\$\_{i(t-1)}$" CAPAB "Capabilities\$\_{i(t-1)}$" linear "Time (linear)" quad "Time (quadratic)") noabbrev wrap gaps varwidth(45) align(r) substitute(\_ _) stats(N countries blank AIC BIC, labels("Observations" "Recipients" " " "AIC" "BIC"))


* try other Lebovic/Voeten dependent variables

xtreg MUPOP l.MUPOP PUBRES d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic

xtreg MUPOP l.MUPOP PUBRES RESxMU d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic

xtreg WBPOP l.WBPOP PUBRES d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic

xtreg WBPOP l.WBPOP PUBRES RESxWB d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic





merge m:1 CCODE YEAR using murdie_merge.dta
drop _merge

tsset CCODE YEAR


eststo ngoplain: xtreg BIPOP l.BIPOP L.HRnc2gcnc2 d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoplain
estadd scalar BIC = bicsto: ngoplain

unique CCODE if e(sample)
estadd scalar countries = r(sum): ngoplain


gen lagXngo = l.HRnc2gcnc2*l.BIPOP
eststo ngoreg: xtreg BIPOP l.BIPOP L.HRnc2gcnc2 lagXngo d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoreg
estadd scalar BIC = bicsto: ngoreg


tab YEAR if e(sample)

unique CCODE if e(sample)
estadd scalar countries = r(sum): ngoreg

gen ngodum = .
replace ngodum = 1 if l.HRnc2gcnc2>=1 & l.HRnc2gcnc2!=.
replace ngodum = 0 if l.HRnc2gcnc2<1 & l.HRnc2gcnc2!=.

eststo ngoplain2: xtreg BIPOP l.BIPOP ngodum d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoplain2
estadd scalar BIC = bicsto: ngoplain2

unique CCODE if e(sample)
estadd scalar countries = r(sum): ngoplain2


gen lagXngodum = ngodum*l.BIPOP
eststo ngoreg2: xtreg BIPOP l.BIPOP ngodum lagXngodum d.HRIGHTS l.HRIGHTS d.CIVIL l.CIVIL l.GDPPOP l.LNPOP l.USAGREE WAR CAPAB linear quad , mle i(CCODE) nolog
estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: ngoreg2
estadd scalar BIC = bicsto: ngoreg2

unique CCODE if e(sample)
estadd scalar countries = r(sum): ngoreg2


esttab ngoplain ngoreg ngoplain2 ngoreg2 using "ngo-bipop.tex", longtable title("State-dependence in Aggregate Bilateral Aid Flows, Murdie et al. (2012) NGO Shaming Measure*\label{tab:ngo-appendix}") replace order(L.BIPOP L.HRnc2gcnc2 lagXngo ngodum lagXngodum D.HRIGHTS L.HRIGHTS D.CIVIL L.CIVIL L.GDPPOP L.LNPOP L.USAGREE WAR CAPAB linear quad) keep(L.BIPOP L.HRnc2gcnc2 lagXngo ngodum lagXngodum  D.HRIGHTS L.HRIGHTS D.CIVIL L.CIVIL L.GDPPOP L.LNPOP L.USAGREE WAR CAPAB linear quad) eqlabels(,none) nomtitles nodepvars coeflabels(L.BIPOP "DV\$_{i(t-1)}$" L.HRnc2gcnc2 "NGO Shaming\$\_{i(t-1)}$" lagXngo "DV\$_{i(t-1)}$ * NGO Shaming\$\_{i(t-1)}$" ngodum "NGO Shaming\$\_{i(t-1)} \geq 1$" lagXngodum "DV\$_{i(t-1)}$ * NGO Shaming\$\_{i(t-1)} \geq 1$" L.USAGREE "Agreement with USA\$\_{i(t-1)}$" D.HRIGHTS "\$\Delta$ Personal Integrity Abuse" L.HRIGHTS "Personal Integrity Abuse\$\_{i(t-1)}$" D.CIVIL "\$\Delta$ Civil Liberties" L.CIVIL "Civil Liberties\$\_{i(t-1)}$" L.GDPPOP "ln GDP per capita\$\_{i(t-1)}$" L.LNPOP "ln population\$\_{i(t-1)}$" WAR "War\$\_{i(t-1)}$" CAPAB "Capabilities\$\_{i(t-1)}$" linear "Time (linear)" quad "Time (quadratic)") noabbrev wrap gaps varwidth(50) align(r) substitute(\_ _) stats(N countries blank AIC BIC, labels("Observations" "Recipients" " " "AIC" "BIC"))


*********************************************
* run R code in order to create R figures
*********************************************

* prepare the data
use jprworkdatanew, clear

quietly{
  tsset CCODE YEAR
  gen X=YEAR-1990
  gen linear=2*X
  gen quad=(4*(X*X))-2
  gen tri=8*(X*X*X)-12*X
  replace WBCOMMIT=WBCOMMIT*1000000
  replace BILATCOM=BILATCOM*1000000
  replace MULTCOM=MULTCOM*1000000
  gen WBPOP=WBCOMMIT/POPULATI
  gen BIPOP=BILATCOM/POPULATI
  gen MUPOP=MULTCOMM/POPULATI
  gen GDPPOP=GDP/POPULATI
  replace WBPOP=1 if WBPOP<1
  replace WBPOP=ln(WBPOP) 
  replace BIPOP=1 if BIPOP<1
  replace BIPOP=ln(BIPOP) 
  replace MUPOP=1 if MUPOP<1
  replace MUPOP=ln(MUPOP) 
  replace GDPPOP=ln(GDPPOP)
  drop if YEAR>2002
  
  *Generate necessary interactions
  gen RESxBI=PUBRES*l.BIPOP
  gen RESxMU=PUBRES*l.MUPOP
  gen RESxWB=PUBRES*l.WBPOP
  
  gen l_BIPOP = l.BIPOP
  gen d_HRIGHTS = d.HRIGHTS
  gen l_HRIGHTS = l.HRIGHTS
  gen d_CIVIL = d.CIVIL
  gen l_CIVIL = l.CIVIL
  gen l_GDPPOP = l.GDPPOP
  gen l_LNPOP = l.LNPOP
  gen l_USAGREE = l.USAGREE
  
}

saveold jprworkdatanewMOD, replace version(12)

shell R CMD BATCH 2016-4-3_figure-construction.r












* determine out of sample forecasting fit
* for esarey-demeritt model #3

clear all
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lagXpub = PUBRES*l.lneconaidpc


* generate lag variables to enable setting initial values
* for the xttobit model
gen lagphysint = l.physint 
gen lagalliance = l.alliance 
gen lagdonorallyneighbor2 = l.donorallyneighbor2 
gen lags3un = l.s3un 
gen laglnreftotal = l.lnreftotal 
gen laglnnytimes = l.lnnytimes 
gen lagratpercent = l.ratpercent 
gen lagdonor_physint = l.donor_physint 
gen lagpolity2 = l.polity2 
gen laglneconaidpc = l.lneconaidpc 
gen lagln_rgdpc = l.ln_rgdpc 
gen lagln_population = l.ln_population 
gen lagln_trade = l.ln_trade 
gen lagwar = l.war

* use paper model to generate initial values
xttobit lneconaidpc PUBRES lagXpub lagphysint lagalliance allXpub lagdonorallyneighbor2 neiXpub lags3un s3unXpub laglnreftotal laglnnytimes lagratpercent lagdonor_physint lagpolity2 laglneconaidpc lnworldaidecon lagln_rgdpc lagln_population lagln_trade dyad_colony socialist ColdWar coldwarsoc lagwar region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

* set the initial values
matrix init = e(b)

* estimate the model on data up to 1998
* don't include post2001 variable (obviously)
eststo trainmod: xttobit lneconaidpc PUBRES lagXpub lagphysint lagalliance allXpub lagdonorallyneighbor2 neiXpub lags3un s3unXpub laglnreftotal laglnnytimes lagratpercent lagdonor_physint lagpolity2 laglneconaidpc lnworldaidecon lagln_rgdpc lagln_population lagln_trade dyad_colony socialist ColdWar coldwarsoc lagwar region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1 & year<=1998), ll(0) intpoints(19) from(init)

* create out of sample predictions for 1999 and 2000
predict oospredict if(inmysample==1 &(year==1999 | year==2000)), ys(0, .)
gen epsilon = oospredict - lneconaidpc
*code source: http://www.stata.com/statalist/archive/2011-10/msg00827.html
egen mean_epsilon = mean(epsilon), by(dyadnum)
* note: this is to correct for the fact that predictions margin out the random effects
gen oospredict_a = oospredict - mean_epsilon

* how does it look?
scatter oospredict_a lneconaidpc


* compare to fit without the PUBRES interaction
* use paper model to generate initial values
xttobit lneconaidpc PUBRES lagphysint lagalliance allXpub lagdonorallyneighbor2 neiXpub lags3un s3unXpub laglnreftotal laglnnytimes lagratpercent lagdonor_physint lagpolity2 laglneconaidpc lnworldaidecon lagln_rgdpc lagln_population lagln_trade dyad_colony socialist ColdWar coldwarsoc lagwar region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

* set the initial values
matrix init = e(b)

* estimate the model
eststo noint: xttobit lneconaidpc PUBRES lagphysint lagalliance allXpub lagdonorallyneighbor2 neiXpub lags3un s3unXpub laglnreftotal laglnnytimes lagratpercent lagdonor_physint lagpolity2 laglneconaidpc lnworldaidecon lagln_rgdpc lagln_population lagln_trade dyad_colony socialist ColdWar coldwarsoc lagwar region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1 & year<=1998), ll(0) intpoints(19) from(init)

*create out of sample predictions for 1999 and 2000
predict oospredict2 if(inmysample==1 &(year==1999 | year==2000)), ys(0, .)
gen epsilon2 = oospredict2 - lneconaidpc
*code source: http://www.stata.com/statalist/archive/2011-10/msg00827.html
egen mean_epsilon2 = mean(epsilon2), by(dyadnum)
* again, correct predictions for the margining out of random effects
gen oospredict2_a = oospredict2 - mean_epsilon2

* which country-year observations changed the most between the models?
gen change_abs = abs(oospredict - oospredict2)
gen change = oospredict - oospredict2
centile change_abs, c(98.5)
set more off
sort change_abs
list change_abs change countryname donorname year if change_abs >= (.3897903 ) & change_abs != .

* how much did OOS forecasting error change?
gen error_a = (oospredict_a - lneconaidpc)^2
gen error2_a = (oospredict2_a - lneconaidpc)^2
gen errorchange = error_a - error2_a
ci means errorchange, level(90)
ci means errorchange, level(50)

tsset dyadnum year

* generate predictions for the original model on the full sample
eststo esdem3: xttobit lneconaidpc PUBRES lagXpub l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

predict esdempred, ys(0, .)
gen esdem_epsilon = esdempred - lneconaidpc
*code source: http://www.stata.com/statalist/archive/2011-10/msg00827.html
egen mean_esdem_epsilon = mean(esdem_epsilon), by(dyadnum)
* correct for margining out of random effects
gen esdempred_a = esdempred - mean_esdem_epsilon 

* generate predictions for the no lag interaction model on the full sample
eststo nolag: xttobit lneconaidpc PUBRES l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

predict nolagpred, ys(0, .)
gen nolag_epsilon = nolagpred - lneconaidpc
*code source: http://www.stata.com/statalist/archive/2011-10/msg00827.html
egen mean_nolag_epsilon = mean(nolag_epsilon), by(dyadnum)
* correct for margining out of random effects
gen nolagpred_a = nolagpred - mean_nolag_epsilon 


* create some plots comparing the (in-sample) predictions of the models with and without the PUBRES interaction
sort dyadnum year

line esdempred_a nolagpred_a lneconaidpc year if(countryname == "Rwanda" & donorname == "United Kingdom" & year >=1982 & year <= 2002), legend(label(1 "Prediction with Lag DV X UNCHR (Model 3)") label(2 "Prediction w/o Lag DV X UNCHR (Model 2)") label(3 "observed DV") size(vsmall)) scheme(s2mono) ytitle("ln (economic aid per capita + 1)")

graph export rwanda-uk.eps, replace

line esdempred_a nolagpred_a lneconaidpc year if(countryname == "Morocco" & donorname == "France" & year >=1982 & year <= 2002), legend(label(1 "Prediction with Lag DV X UNCHR (Model 3)") label(2 "Prediction w/o Lag DV X UNCHR (Model 2)") label(3 "observed DV") size(vsmall)) scheme(s2mono) ytitle("ln (economic aid per capita + 1)")

graph export morocco-france.eps, replace

line esdempred_a nolagpred_a lneconaidpc year if(countryname == "Peru" & donorname == "Germany" & year >=1982 & year <= 2002), legend(label(1 "Prediction with Lag DV X UNCHR (Model 3)") label(2 "Prediction w/o Lag DV X UNCHR (Model 2)") label(3 "observed DV") size(vsmall)) scheme(s2mono) ytitle("ln (economic aid per capita + 1)")

graph export peru-germany.eps, replace



















*****************************************************
* Neilsen data
* dyadic aid flow analysis
* Lebovic/Voeten UNCHR condemnation variable
* 
* auxiliary analysis: more lags
*****************************************************

* create common sample for old and new models

clear all
set mem 1000M
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lagXpub = PUBRES*l.lneconaidpc
gen lag2Xpub = PUBRES*L2.lneconaidpc

gen laglneconaidpc = l.lneconaidpc 
gen lag2lneconaidpc = L2.lneconaidpc 

* the esarey-demeritt model with more lags
eststo morelags: xttobit lneconaidpc PUBRES lagXpub lag2Xpub laglneconaidpc lag2lneconaidpc l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

gen lagsample = e(sample)

estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: morelags
estadd scalar BIC = bicsto: morelags

scalar drop aicsto bicsto
mat drop icsto

unique countryname if e(sample)
estadd scalar countries = r(sum): morelags

unique donorname if e(sample)
estadd scalar donors = r(sum): morelags

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): morelags

tab year if e(sample)

* the esarey-demeritt model
eststo fewlags: xttobit lneconaidpc PUBRES lagXpub laglneconaidpc l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(lagsample==1), ll(0) intpoints(19)

estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: fewlags
estadd scalar BIC = bicsto: fewlags

scalar drop aicsto bicsto
mat drop icsto

unique countryname if e(sample)
estadd scalar countries = r(sum): fewlags

unique donorname if e(sample)
estadd scalar donors = r(sum): fewlags

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): fewlags

tab year if e(sample)



esttab fewlags morelags using "lagcheck.tex", title("Dyadic Bilateral Aid Flows, Alternate Lags*\label{tab:lagcheck-1}") longtable replace keep(laglneconaidpc lag2lneconaidpc L.physint PUBRES lagXpub lag2Xpub L.alliance allXpub L.donorallyneighbor2 neiXpub L.s3un s3unXpub) order(PUBRES laglneconaidpc lag2lneconaidpc lagXpub lag2Xpub L.physint L.alliance allXpub L.donorallyneighbor2 neiXpub L.s3un s3unXpub) eqlabels(,none) nomtitles nodepvars coeflabels(laglneconaidpc  "DV\$_{i(t-1)}$" lag2lneconaidpc  "DV\$_{i(t-2)}$" L.physint  "Physical Integrity Violations\$_{i(t-1)}$" PUBRES "UNCHR Resolution\$_{i(t-1)}$" lagXpub "DV\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" lag2Xpub "DV\$_{i(t-2)}$ * Resolution\$_{i(t-1)}$" L.alliance "Alliance\$_{i(t-1)}$" allXpub "Alliance\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$_{i(t-1)}$" neiXpub "Ally Neighbor\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.s3un "UN Voting Similarity\$_{i(t-1)}$" s3unXpub "UN Similarity\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$") noabbrev wrap gaps varwidth(48) align(r) substitute(\_ _) stats(N dyads countries donors blank AIC BIC, labels("Observations" "Dyads" "Recipients" "Donors" " " "AIC" "BIC"))








* alternative approach to initial condition problem
* per Wooldridge 2005


clear all
set mem 1000M
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lagXpub = PUBRES*l.lneconaidpc


* generate lag variables to enable setting initial values
* for the xttobit model
gen lagphysint = l.physint 
gen lagalliance = l.alliance 
gen lagdonorallyneighbor2 = l.donorallyneighbor2 
gen lags3un = l.s3un 
gen laglnreftotal = l.lnreftotal 
gen laglnnytimes = l.lnnytimes 
gen lagratpercent = l.ratpercent 
gen lagdonor_physint = l.donor_physint 
gen lagpolity2 = l.polity2 
gen laglneconaidpc = l.lneconaidpc 
gen lagln_rgdpc = l.ln_rgdpc 
gen lagln_population = l.ln_population 
gen lagln_trade = l.ln_trade 
gen lagwar = l.war

* repeat paper model 
eststo noinit: xttobit lneconaidpc PUBRES lagXpub lagphysint lagalliance allXpub lagdonorallyneighbor2 neiXpub lags3un s3unXpub laglnreftotal laglnnytimes lagratpercent lagdonor_physint lagpolity2 laglneconaidpc lnworldaidecon lagln_rgdpc lagln_population lagln_trade dyad_colony socialist ColdWar coldwarsoc lagwar post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: noinit
estadd scalar BIC = bicsto: noinit

unique countryname if e(sample)
estadd scalar countries = r(sum): noinit

unique donorname if e(sample)
estadd scalar donors = r(sum): noinit

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): noinit

tab year if e(sample)

keep if e(sample)

* code source: http://www.stata.com/statalist/archive/2013-06/msg00457.html
gen initlneconaidpc = laglneconaidpc
bysort dyadnum (year): replace initlneconaidpc = initlneconaidpc[1]

* the esarey-demeritt model
eststo initcond:  xttobit lneconaidpc PUBRES lagXpub lagphysint lagalliance allXpub lagdonorallyneighbor2 neiXpub lags3un s3unXpub laglnreftotal laglnnytimes lagratpercent lagdonor_physint lagpolity2 laglneconaidpc lnworldaidecon lagln_rgdpc lagln_population lagln_trade dyad_colony socialist ColdWar coldwarsoc lagwar post2001 region_SSA region_Latin region_MENA region_EAsiaPac initlneconaidpc, ll(0) intpoints(19)

estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: initcond
estadd scalar BIC = bicsto: initcond

scalar drop aicsto bicsto
mat drop icsto

unique countryname if e(sample)
estadd scalar countries = r(sum): initcond

unique donorname if e(sample)
estadd scalar donors = r(sum): initcond

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): initcond

tab year if e(sample)

esttab noinit initcond using "initcond.tex", title("Dyadic Bilateral Aid Flows, Varying Initial Condition Modeling*\label{tab:initcond-1}") longtable replace keep(laglneconaidpc lagphysint PUBRES lagXpub initlneconaidpc lagalliance allXpub lagdonorallyneighbor2  neiXpub lags3un s3unXpub) order(PUBRES laglneconaidpc lagXpub initlneconaidpc lagphysint lagalliance allXpub lagdonorallyneighbor2 neiXpub lags3un s3unXpub) eqlabels(,none) nomtitles nodepvars coeflabels(laglneconaidpc  "DV\$_{i(t-1)}$" lagphysint  "Physical Integrity Violations\$_{i(t-1)}$" PUBRES "UNCHR Resolution\$_{i(t-1)}$" lagXpub "DV\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" initlneconaidpc "Initial Value of lag DV" lagalliance "Alliance\$_{i(t-1)}$" lagalliance_physint "Alliance\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" allXpub "Alliance\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" lagdonorallyneighbor2 "Ally Neighbor\$_{i(t-1)}$" lagallyneighbor2_physint "Ally Neighbor\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" neiXpub "Ally Neighbor\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" lags3un "UN Voting Similarity\$_{i(t-1)}$" lags3un_physint "UN Similarity\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" s3unXpub "UN Similarity\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$") noabbrev wrap gaps varwidth(48) align(r) substitute(\_ _) stats(N dyads countries donors blank AIC BIC, labels("Observations" "Dyads" "Recipients" "Donors" " " "AIC" "BIC"))














*****************************************************
* Neilsen data
* dyadic aid flow analysis
* Lebovic/Voeten UNCHR condemnation variable
* does donor respect for physint rights matter?
*****************************************************

clear all
set mem 1000M
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lagXpub = PUBRES*l.lneconaidpc

* interaction with donor physint?
gen donorphysintXpub = PUBRES*l.donor_physint

eststo donormod: xttobit lneconaidpc PUBRES lagXpub l.donor_physint donorphysintXpub l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)


estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: donormod
estadd scalar BIC = bicsto: donormod

scalar drop aicsto bicsto
mat drop icsto

unique countryname if e(sample)
estadd scalar countries = r(sum): donormod

unique donorname if e(sample)
estadd scalar donors = r(sum): donormod

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): donormod

tab year if e(sample)

eststo papermod: xttobit lneconaidpc PUBRES lagXpub l.donor_physint l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)


estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: papermod
estadd scalar BIC = bicsto: papermod

scalar drop aicsto bicsto
mat drop icsto

unique countryname if e(sample)
estadd scalar countries = r(sum): papermod

unique donorname if e(sample)
estadd scalar donors = r(sum): papermod

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): papermod

tab year if e(sample)



esttab papermod donormod using "physint.tex", title("State-dependence in Dyadic Bilateral Aid Flows with Donor Physical Integrity Score Interactions*\label{tab:physint}") longtable replace keep(L.lneconaidpc L.physint PUBRES lagXpub L.donor_physint donorphysintXpub L.alliance L.donorallyneighbor2 L.s3un) order(L.lneconaidpc L.physint PUBRES lagXpub L.donor_physint donorphysintXpub L.alliance L.donorallyneighbor2 L.s3un) eqlabels(,none) nomtitles nodepvars coeflabels(L.lneconaidpc  "DV\$_{i(t-1)}$" L.physint  "Physical Integrity Violations\$_{i(t-1)}$" PUBRES "UNCHR Resolution\$_{i(t-1)}$" lagXpub "DV\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.donor_physint "Donor Violations\$_{i(t-1)}$" donorphysintXpub "Donor Violations\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$"  L.alliance "Alliance\$_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$_{i(t-1)}$" L.s3un "UN Voting Similarity\$_{i(t-1)}$") noabbrev wrap gaps varwidth(65) align(r) substitute(\_ _) stats(N dyads countries donors blank AIC BIC, labels("Observations" "Dyads" "Recipients" "Donors" " " "AIC" "BIC"))













*****************************************************
* Neilsen data
* dyadic aid flow analysis
* Murdie/Davis NGO Shaming variable
* does donor level of shaming matter?
*****************************************************


clear all
set more off
set matsize 800


** merge in NGO data
use "ISQ 2010 Murdie Davis final to ISQ.dta", clear
rename cowcode countrynumcode_g
rename NAMES_STD donorname
save murdie_merge.dta, replace

** merge in NGO data
use "ISQ 2010 Murdie Davis final to ISQ.dta", clear
rename country donorname
rename HRnc2gcnc2 donor_shaming
keep if donorname == "Australia" | donorname == "Austria" | donorname == "Belgium" | donorname == "Canada" | donorname == "Denmark" | donorname == "Finland" | donorname == "France" | donorname == "Germany" | donorname == "Ireland" | donorname == "Italy" | donorname == "Japan" | donorname == "Luxembourg" | donorname == "Netherlands" | donorname == "New Zealand" | donorname == "Norway" | donorname == "Portugal" | donorname == "Spain" | donorname == "Sweden" | donorname == "Switzerland" | donorname == "United Kingdom" | donorname == "United States"
save murdie_merge_2.dta, replace

** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using murdie_merge.dta
drop if _merge==2
drop _merge

merge m:1 donorname year using murdie_merge_2.dta, keepusing(donor_shaming)
drop if _merge==2
drop _merge

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

* no interactions
eststo shamedonors: tobit lneconaidpc L.HRnc2gcnc2 l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1 & L.donor_shaming>=1), ll(0) cluster(dyadnum)


estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: shamedonors
estadd scalar BIC = bicsto: shamedonors

scalar drop aicsto bicsto
mat drop icsto


tab year if e(sample)

unique countryname if e(sample)
estadd scalar countries = r(sum): shamedonors

unique donorname if e(sample)
estadd scalar donors = r(sum): shamedonors

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): shamedonors



gen allXngo = l.HRnc2gcnc2*l.alliance
gen neiXngo = l.HRnc2gcnc2*l.donorallyneighbor2
gen s3unXngo = l.HRnc2gcnc2*l.s3un

gen lagXngo = l.HRnc2gcnc2*l.lneconaidpc

* lag interaction with PUBRES only
eststo shamedonors2: tobit lneconaidpc L.HRnc2gcnc2 lagXngo l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1 & L.donor_shaming>=1), ll(0) cluster(dyadnum)


estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: shamedonors2
estadd scalar BIC = bicsto: shamedonors2

scalar drop aicsto bicsto
mat drop icsto


tab year if e(sample)

unique countryname if e(sample)
estadd scalar countries = r(sum): shamedonors2

unique donorname if e(sample)
estadd scalar donors = r(sum): shamedonors2

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): shamedonors2


gen donorshamingXngo = l.HRnc2gcnc2*L.donor_shaming


* interaction with donor shaming
eststo shamedonorsint: tobit lneconaidpc L.HRnc2gcnc2 L.donor_shaming donorshamingXngo l.physint l.alliance l.donorallyneighbor2 l.s3un l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) cluster(dyadnum)


estat ic
mat icsto = r(S)
scalar aicsto = icsto[1,5]
scalar bicsto = icsto[1,6]
estadd scalar AIC = aicsto: shamedonorsint
estadd scalar BIC = bicsto: shamedonorsint

scalar drop aicsto bicsto
mat drop icsto


tab year if e(sample)

unique countryname if e(sample)
estadd scalar countries = r(sum): shamedonorsint

unique donorname if e(sample)
estadd scalar donors = r(sum): shamedonorsint

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): shamedonorsint



esttab shamedonors shamedonors2 using "shame-donor-tobits.tex", title("Dyadic Bilateral Economic Aid Flows, Murdie and Davis (2012) NGO Shaming Measure Among Shamed Donors*\label{tab:shamedonors}") longtable replace order(L.lneconaidpc L.physint L.HRnc2gcnc2 lagXngo L.alliance L.donorallyneighbor2 L.s3un) keep(L.lneconaidpc L.HRnc2gcnc2 lagXngo L.physint L.alliance L.donorallyneighbor2 L.s3un) eqlabels(,none) nomtitles nodepvars coeflabels(L.lneconaidpc "DV\$_{i(t-1)}$" L.physint "Physical Integrity Violations\$\_{i(t-1)}$" L.HRnc2gcnc2 "NGO Shaming\$\_{i(t-1)}$" lagXngo "DV\$\_{i(t-1)}$ * NGO Shaming\$\_{i(t-1)}$" L.alliance "Alliance\$\_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$\_{i(t-1)}$" L.s3un "UN Voting Similarity\$\_{i(t-1)}$") noabbrev wrap gaps varwidth(45) align(r) substitute(\_ _) stats(N dyads countries donors blank AIC BIC, labels("Observations" "Dyads" "Recipients" "Donors" " " "AIC" "BIC"))


esttab shamedonorsint using "shame-donor-int-tobits.tex", title("Dyadic Bilateral Economic Aid Flows, Murdie and Davis (2012) NGO Shaming Measure with Donor Shaming Interaction*\label{tab:shamedonorsinteraction}") longtable replace order(L.lneconaidpc L.physint L.HRnc2gcnc2 L.donor_shaming donorshamingXngo L.alliance L.donorallyneighbor2 L.s3un) keep(L.lneconaidpc L.HRnc2gcnc2 L.donor_shaming donorshamingXngo L.physint L.alliance L.donorallyneighbor2 L.s3un) eqlabels(,none) nomtitles nodepvars coeflabels(L.lneconaidpc "DV\$_{i(t-1)}$" L.physint "Physical Integrity Violations\$\_{i(t-1)}$" L.HRnc2gcnc2 "NGO Shaming\$\_{i(t-1)}$"L.donor_shaming "Donor NGO Shaming\$\_{i(t-1)} \geq 1$" donorshamingXngo "Donor NGO Shaming\$\_{i(t-1)} \geq 1$ * NGO Shaming\$\_{i(t-1)}$" L.alliance "Alliance\$\_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$\_{i(t-1)}$" L.s3un "UN Voting Similarity\$\_{i(t-1)}$") noabbrev wrap gaps varwidth(45) align(r) substitute(\_ _) stats(N dyads countries donors blank AIC BIC, labels("Observations" "Dyads" "Recipients" "Donors" " " "AIC" "BIC"))













*****************************************************
* Reviewer table only
* Neilsen data
* dyadic aid per log GDP flow analysis
* Lebovic/Voeten UNCHR condemnation variable
*****************************************************

* create common sample for old and new models

clear all
set mem 1000M
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = PUBRES*l.alliance
gen neiXpub = PUBRES*l.donorallyneighbor2
gen s3unXpub = PUBRES*l.s3un

gen lneconaidpcbygdp = log( (exp(lneconaidpc)-1) / exp(ln_rgdpc) + 1)

gen lagXpub = PUBRES*l.lneconaidpcbygdp


* the neilsen model
eststo neilsen: xttobit lneconaidpcbygdp l.physint l.alliance l.alliance_physint l.donorallyneighbor2 l.allyneighbor2_physint l.s3un l.s3un_physint l.lnreftotal l.lnreftotal_physint l.lnnytimes l.lnnytimes_physint l.ratpercent l.ratpercent_physint l.donor_physint l.donor_physint_physint l.polity2 l.lneconaidpcbygdp lnworldaidecon l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.ColdWar_physint l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(20)

tab year if e(sample)

unique countryname if e(sample)
estadd scalar countries = r(sum): neilsen

unique donorname if e(sample)
estadd scalar donors = r(sum): neilsen

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): neilsen

* how many countries are condemned in the window of this model?
unique countryname if e(sample) & PUBRES == 1

* the esarey-demeritt model
eststo esdem3: xttobit lneconaidpcbygdp PUBRES lagXpub l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpcbygdp lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

tab year if e(sample)

* how many countries are condemned in the window of this model?
unique countryname if e(sample) & PUBRES == 1
unique countryname if e(sample)
estadd scalar countries = r(sum): esdem3

unique donorname if e(sample)
estadd scalar donors = r(sum): esdem3

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): esdem3


esttab neilsen esdem3 using "percapita.rtf", title("State-dependence in Dyadic Bilateral Aid Per Capita Divided by GDP per Capita") longtable replace keep(L.lneconaidpcbygdp L.physint PUBRES lagXpub L.alliance L.alliance_physint allXpub L.donorallyneighbor2 L.allyneighbor2_physint neiXpub L.s3un L.s3un_physint s3unXpub) order(L.lneconaidpcbygdp L.physint PUBRES lagXpub L.alliance L.alliance_physint allXpub L.donorallyneighbor2 L.allyneighbor2_physint neiXpub L.s3un L.s3un_physint s3unXpub) eqlabels(,none) nomtitles nodepvars coeflabels(L.lneconaidpcbygdp  "DV\$_{i(t-1)}$" L.physint  "Physical Integrity Violations\$_{i(t-1)}$" PUBRES "UNCHR Resolution\$_{i(t-1)}$" lagXpub "DV\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.alliance "Alliance\$_{i(t-1)}$" L.alliance_physint "Alliance\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" allXpub "Alliance\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$_{i(t-1)}$" L.allyneighbor2_physint "Ally Neighbor\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" neiXpub "Ally Neighbor\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$" L.s3un "UN Voting Similarity\$_{i(t-1)}$" L.s3un_physint "UN Similarity\$_{i(t-1)}$ * Violations\$_{i(t-1)}$" s3unXpub "UN Similarity\$_{i(t-1)}$ * Resolution\$_{i(t-1)}$") noabbrev wrap gaps varwidth(48) align(r) substitute(\_ _) stats(N dyads countries donors, labels("Observations" "Dyads" "Recipients" "Donors"))
















*****************************************************
* Reviewer table only
* Neilsen data
* dyadic aid analysis
* Lebovic/Voeten UNHCR ordinal variable
*****************************************************

* create common sample for old and new models

clear all
set mem 1000M
set more off
set matsize 800


** merge in public resolution data
use jprworkdatanew.dta, clear
rename YEAR year 
rename CCODE countrynumcode_g
save jpr_merge.dta, replace

use "dat2.dta", clear

merge m:1 year countrynumcode_g year using jpr_merge.dta
drop if _merge==2

tsset dyadnum year

gen allXpub = UNHRC*l.alliance
gen neiXpub = UNHRC*l.donorallyneighbor2
gen s3unXpub = UNHRC*l.s3un

* use the ordinal UNHRC variable from the Lebovic and Voeten data set
gen lagXpub = UNHRC*l.lneconaidpc

* the esarey-demeritt model
eststo esdem3: xttobit lneconaidpc UNHRC lagXpub l.physint l.alliance allXpub l.donorallyneighbor2 neiXpub l.s3un s3unXpub l.lnreftotal l.lnnytimes l.ratpercent l.donor_physint l.polity2 l.lneconaidpc lnworldaidecon l.ln_rgdpc l.ln_population l.ln_trade dyad_colony socialist ColdWar coldwarsoc l.war post2001 region_SSA region_Latin region_MENA region_EAsiaPac if(inmysample==1), ll(0) intpoints(19)

tab year if e(sample)
tab UNHRC if e(sample)

* how many countries are condemned in the window of this model?
unique countryname if e(sample)
estadd scalar countries = r(sum): esdem3

unique donorname if e(sample)
estadd scalar donors = r(sum): esdem3

unique dyadnum if e(sample)
estadd scalar dyads= r(sum): esdem3

esttab esdem3 using "unchrcontinuous.rtf", title("State-dependence in Dyadic Bilateral Aid Flows") longtable replace keep(L.lneconaidpc L.physint UNHRC lagXpub L.alliance allXpub L.donorallyneighbor2 neiXpub L.s3un s3unXpub) order(L.lneconaidpc L.physint UNHRC lagXpub L.alliance allXpub L.donorallyneighbor2 neiXpub L.s3un s3unXpub) eqlabels(,none) nomtitles nodepvars coeflabels(L.lneconaidpc "DV\$_{i(t-1)}$" L.physint  "Physical Integrity Violations\$_{i(t-1)}$" UNHRC "UNCHR Action\$_{i(t-1)}$" lagXpub "DV\$_{i(t-1)}$ * UNCHR\$_{i(t-1)}$" L.alliance "Alliance\$_{i(t-1)}$" allXpub "Alliance\$_{i(t-1)}$ * UNCHR\$_{i(t-1)}$" L.donorallyneighbor2 "Ally Neighbor\$_{i(t-1)}$" neiXpub "Ally Neighbor\$_{i(t-1)}$ * UNCHR\$_{i(t-1)}$" L.s3un "UN Voting Similarity\$_{i(t-1)}$" s3unXpub "UN Similarity\$_{i(t-1)}$ * UNCHR\$_{i(t-1)}$") noabbrev wrap gaps varwidth(48) align(r) substitute(\_ _) stats(N dyads countries donors, labels("Observations" "Dyads" "Recipients" "Donors"))


log close

