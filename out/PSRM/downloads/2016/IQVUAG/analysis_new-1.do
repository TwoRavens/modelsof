/*********** ANALYSIS.DO


IMPORTANT INFO:

The spmap cmd can be obtained typing "net describe spmap, from(http://fmwww.bc.edu/RePEc/bocode/s)" 
in the STATA CMD line

It is necessary to add a folders to that directory called "tables" and "figures" to properly save 
tables and figures */


clear all
set more off
capture log close

/* IMPORTANT the following line defines the working directory */
cd  "\DATA\Dropbox\PoliticalEconomy\"


log using analysis.log, replace

use  ita_prov_d.dta
ren NOME provincia
replace provincia=lower(provincia)
sort provincia
save ita_prov_dtemp, replace


use master, replace
bysort circ comune year: gen Ncollegi=_N
gen una_collegio=Ncollegi==1
gen pochi_elettori=elettori<1200


*********** SUMMARY STATISTICS

drop if p_schedebianche==.
gen di_turn=turnout*dmdistanza
gen di_ncand=ncand*dmdistanza

lab var p_votinonvalidi  "Invalid ballots"
lab var p_votinonvalidi_p  "Invalid ballots in the proportional race"

lab var turnout "Turnout"
lab var turnout_p "Turnout in the proportional race"

lab var p_schedebianche "Blank ballots" 
lab var p_schedebianche_p "Blank ballots in the proportional race" 

lab var lp_votinonvalidi  "log-Invalid ballots"
lab var lp_votinonvalidi_p  "log-Invalid ballots in the proportional race"

lab var lturnout "log-Turnout"
lab var lturnout_p "log-Turnout in the proportional race"

lab var lp_schedebianche "log-Blank ballots" 
lab var lp_schedebianche_p "log-Blank ballots in the proportional race" 

lab var destra1 "Right coalition leads"
lab var sinistra1 "Left coalition leads"
lab var wincumb "Incumbent party leads"
lab var incumbent_present "Incumbent participates"
lab var incumbent_won "Incumbent leads"

lab var distanza "Leading margin at electoral unit level" 
lab var c_distanza "Leading margin at district level" 

lab var ldistanza "log-Leading margin" 
lab var N_coll "N. of individual obs."
lab var ncandidati "Number of candidates"
lab var lncand "Log-N. of candidates"
lab var D1996 "Year 1996"
lab var D2001 "Year 2001"
replace unemp=unemp/100
lab var unemp_rate "Unemployment rate"
replace refturnout=refturnout/100
lab var refturnout "Turnout at national referenda"

replace act_rate=act_rate/100
lab var act_rate "Labor activity rate"
replace ass_mafiosa=ass_mafiosa>0
lab var ass_mafio "Provinces with mafia-related crimes"
lab var laurea_rate "Fraction of pop. with university degree"
lab var diploma_rate "Fraction of pop. with high school degree"
replace realgdp=real/10000
lab var real "GDP per capita (in \euro 10,000)"
replace urb_rate=urb/100
lab var urb "Rate of urbanization"

gen dmafia=NUM_SCIO>0 & NUM_SCI<.
lab var dmafia "Dissolution of a city council between 1999-2009"

foreach y of var delitti* mafia{
replace `y'=`y'/pop2001*100
}
lab var delitti_pa "Corruption Crime Rate (per 100 inh.)"
lab var mafia "Organized Crime Rate (per 100 inh.)"
lab var delitti "Total Crime Rate (per 100 inh.)"

sutex p_votinonvalidi p_schedebianche turnout distanza c_distanza destra1 sinistra1 wincumb /*
*/ incumbent_won ncand delitti_pa mafia dmafia delitti laurea_rate diploma_rate refturnout act_rate /*
*/ unemp_rate realgdp urb_rate , labels min

bysort circ coll comune: egen x=mean(p_votinonvalidi)
bysort circ coll comune: replace x=100*abs(p_votinonvalidi-x)
bysort circ coll comune: egen adev_invalid=mean(x)
bysort circ coll comune: egen sd_invalid=sd(p_votinonvalidi)
drop x
bysort circ coll comune: egen x=mean(p_schedebianche)
bysort circ coll comune: replace x=100*abs(p_schedebianche-x)
bysort circ coll comune: egen adev_blank=mean(x)
bysort circ coll comune: egen sd_blank=sd(p_schedebianche)
bysort circ coll year: egen ysd_invalid=sd(p_votinonvalidi)
drop x



****** Pivotal

gen larger=p_votinonvalidi>distanza & p_votinonvalidi<.
gen larger2=1/2*p_votinonvalidi>distanza & p_votinonvalidi<.
*table region year , c(mean distanza mean p_votinonvalidi mean larger  mean larger2)



preserve
collapse adev_invalid sd_inv p_votinonvalidi p_schedebianche dmafia (sum) pop2001 mafia delitti* , by(provincia)
replace provincia="massa carrara" if provincia=="massa-carrara"
replace provincia="pesaro e urbino" if provincia=="pesaro-urbino"
replace provincia="verb-cus-ossola" if provincia=="verbano-cusio-ossola"
replace provincia="pesaro e urbino" if provincia=="pesaro-urbino"
replace provincia="forli'-cesena" if provincia=="forli-cesena"
replace provincia="forli'-cesena" if provincia=="forli-cesena"
replace provincia="aosta" if provincia=="valle d'aosta/valle d'aoste"
sort provincia
merge provincia using ita_prov_dtemp.dta
tab  provincia _m
drop _m

foreach y of var delitti* mafia{
replace `y'=`y'/pop2001*100000
}


spmap delitti using ita_prov_c.dta, id(id)  clnumber(9) clmethod(quantile)  ndsize(thick) ti("Total Crime Rate")
graph export figures/delitti_prov.pdf, replace

spmap delitti_pa using ita_prov_c.dta, id(id)  clnumber(9) clmethod(quantile)  ndsize(thick) ti("Corruption Crime Rate")
graph export figures/pa_prov.pdf, replace

spmap dmafia using ita_prov_c.dta, id(id)  clnumber(9) clmethod(custom) clbreaks(0 0.00001 0.01 0.015 0.02 .1 .2 .25 .3) ndsize(thick) ti("Fraction of Dissolved City Councils")
graph export figures/dismantelled_prov.pdf, replace

spmap mafia using ita_prov_c.dta, id(id)  clnumber(9) clmethod(quantile)  ndsize(thick) ti("Organized Crime Rate")
graph export figures/mafia_prov.pdf, replace


/* This is Figure 3 in the paper*/
spmap p_voti using ita_prov_c.dta, id(id)  clnumber(9) clmethod(quantile)  ndsize(thick) 
graph export figures/pvoti_prov.pdf, replace

spmap p_schede using ita_prov_c.dta, id(id)  clnumber(9) clmethod(quantile)  ndsize(thick) 
graph export figures/pschede_prov.pdf, replace


spmap adev using ita_prov_c.dta, id(id)  clnumber(9) clmethod(quantile)  ndsize(thick) 
graph export figures/adev_prov.pdf, replace
restore

*********/


**********skip graphs ***********************

preserve // Simple correlation between voting and margin of victory
sort distanza
keep if distanza!=. & p_votinonvalidi!=.
gen  pct_dist = int(100*(_n-1)/_N)
sort pct_dis distanza
by pct_dis: gen cent_dis=distanza[1]
by pct_dis: egen minv=mean(p_votinonvalidi)
by pct_dis: gen n=_n
by pct_dis: egen mblank=mean(p_schedebianche)
lab var mblank "Fraction of blank ballots"

lab var minv "Fraction of invalid ballots"
lab var cent_dis "Leading margin of the 1st candidate over the 2nd"

scatter minv cent_dis if n==1, ti("Invalid ballots (full sample)")
graph export figures/pct.pdf, replace
scatter mblank cent_dis if n==1, ti("Blank ballots, margin between 1st and 2nd candidate")
graph export figures/pblank.pdf, replace
restore


preserve // Simple correlation between voting and margin of victory
sort distanza
keep if distanza!=. & p_votinonvalidi!=.&north==1
gen  pct_dist = int(100*(_n-1)/_N)
sort pct_dis distanza
by pct_dis: gen cent_dis=distanza[1]
by pct_dis: egen minv=mean(p_votinonvalidi)
by pct_dis: gen n=_n
by pct_dis: egen mblank=mean(p_schedebianche)
lab var mblank "Fraction of blank ballots"

lab var minv "Fraction of invalid ballots"
lab var cent_dis "Leading margin of the 1st candidate over the 2nd"

scatter minv cent_dis if n==1, ti("Invalid ballots, margin between 1st and 2nd candidate")
graph export figures/pct_north.pdf, replace
scatter mblank cent_dis if n==1, ti("Blank ballots, margin between 1st and 2nd candidate")
graph export figures/pblank_north.pdf, replace
restore

preserve //Same thing for municipalities with less than 1200 voters
sort distanza
keep if distanza!=. & p_votinonvalidi!=.&elettori<=1200
gen  pct_dist = int(100*(_n-1)/_N)
sort pct_dis distanza
by pct_dis: gen cent_dis=distanza[1]
by pct_dis: egen minv=mean(p_votinonvalidi)
by pct_dis: gen n=_n
by pct_dis: egen mblank=mean(p_schedebianche)
lab var mblank "Fraction of blank ballots"
lab var minv "Fraction of invalid ballots"
lab var cent_dis "Leading margin of the 1st candidate over the 2nd"

scatter minv cent_dis if n==1&elettori<1200, ti("Invalid ballots (<1200 eligible voters)")
graph export figures/pct1200.pdf, replace
scatter mblank cent_dis if n==1&elettori<1200, ti("Blank ballots, margin between 1st and 2nd candidate")
graph export figures/pblank1200.pdf, replace
restore



preserve // Same thing at the collegio elettorale level
sort c_distanza
gen  pct_dist = int(100*(_n-1)/_N)
sort pct_dis c_distanza
by pct_dis: gen cent_dis=c_distanza[1]
by pct_dis: egen minv=mean(p_votinonvalidi)
by pct_dis: gen n=_n
by pct_dis: egen mblank=mean(p_schedebianche)
lab var mblank "Fraction of blank ballots"

lab var minv "Fraction of invalid ballots"
lab var cent_dis "Leading margin of the 1st candidate over the 2nd"

scatter minv cent_dis if n==1&cent_dis<=1, ti("Italy")
graph export figures/c_pct.pdf, replace
scatter mblank cent_dis if n==1&cent_dis<=1, ti("Italy")
graph export figures/c_pblank.pdf, replace
restore

preserve // Do it by level of electoral competition
qui su c_distanza, de
gen bmedian=c_distanza<r(p50)
sort distanza
gen  pct_dist = int(100*(_n-1)/_N)
sort bmedian pct_dis distanza
by bmedian pct_dis: gen cent_dis=distanza[1]
by bmedian pct_dis: egen minv=mean(p_votinonvalidi)
by bmedian pct_dis: gen n=_n
by bmedian pct_dis: egen mblank=mean(p_schedebianche)
lab var mblank "Fraction of blank ballots"

lab var minv "Fraction of invalid ballots"
lab var cent_dis "Leading margin of the 1st candidate over the 2nd"


twoway(scatter minv cent_dis if n==1&bmedian==0, msy(o) ti("Invalid ballots, margin between 1st and 2nd candidate"))/*
*/	(scatter minv cent_dis if n==1&bmedian==1,  msy(d))/*
*/	(lfit minv cent_dis if n==1&bmedian==0)(lfit minv cent_dis if n==1&bmedian==1), legend(label(1 "Non-competitive district") label(2 "Competitive district") label(3 "linear fit") label(4 "linear fit"))
graph export figures/pct_competition.pdf, replace
restore


preserve // Do it by level of electoral competition for municipalities with less than 1200 voters
keep if elettori<=1200
qui su c_distanza, de
gen bmedian=c_distanza<r(p50)
sort distanza
gen  pct_dist = int(100*(_n-1)/_N)
sort bmedian pct_dis distanza
by bmedian pct_dis: gen cent_dis=distanza[1]
by bmedian pct_dis: egen minv=mean(p_votinonvalidi)
by bmedian pct_dis: gen n=_n
by bmedian pct_dis: egen mblank=mean(p_schedebianche)
lab var mblank "Fraction of blank ballots"

lab var minv "Fraction of invalid ballots"
lab var cent_dis "Leading margin of the 1st candidate over the 2nd"

twoway(scatter minv cent_dis if n==1&bmedian==0&elettori<1200, msy(o) ti("Invalid ballots, margin between 1st and 2nd candidate"))/*
*/	(scatter minv cent_dis if n==1&bmedian==1&elettori<1200,  msy(d))/*
*/	(lfit minv cent_dis if n==1&bmedian==0&elettori<1200)(lfit minv cent_dis if n==1&bmedian==1&elettori<1200), legend(label(1 "Non-competitive district") label(2 "Competitive district") label(3 "linear fit") label(4 "linear fit"))
graph export figures/pct_competition1200.pdf, replace
restore

*foreach y of varlist estorsioni ass_mafiosa total_crime{
foreach y of varlist delitti_pa mafia dmafia{
preserve
replace `y'=`y'/pop2001*100000
qui su `y', de
gen bmedian=`y'<=r(p50)
sort distanza
gen pct_`y' = int(100*(_n-1)/_N)
sort bmedian pct_`y' distanza
by bmedian pct_`y': gen cent_dis=distanza[1]
by bmedian pct_`y': egen minv=mean(p_votinonvalidi)
by bmedian pct_`y': gen n=_n
by bmedian pct_`y': egen mblank=mean(p_schedebianche)
lab var minv "Fraction of invalid ballots"
lab var cent_dis "Leading margin of the 1st candidate over the 2nd"
if "`y'"=="delitti_pa" {
local ti "Invalid ballots and leading margin (Crime: corruption)"
}
if "`y'"=="mafia" {
local ti "Invalid ballots and leading margin (Crime : mafia) "
}
if "`y'"=="dmafia" {
local ti "Invalid ballots and leading margin (Dismissed council)"
}
twoway(scatter minv cent_dis if n==1&bmedian==0, msy(o)  ti("`ti'"))/*
*/	(scatter minv cent_dis if n==1&bmedian==1,  msy(d))/*
*/	(lfit minv cent_dis if n==1&bmedian==0)(lfit minv cent_dis if n==1&bmedian==1), legend(label(1 "Above median") label(2 "Below median") label(3 "linear fit") label(4 "linear fit"))
graph export figures/pct_`y'.pdf, replace
restore
}


************skip graphs*********/

*********** REGRESSIONS OLS
local opt "bdec(4) excel lab nocons"


local otherX "delitti_pa mafia delitti laurea_rate diploma_rate refturnout act_rate unemp_rate realgdp urb_rate"

* FIRST TABLE

reg p_votinonvalidi distanza, cluster(id_coll)
outreg2 using tables/lreg1, replace `opt'  

reg p_votinonvalidi distanza turnout p_schedebianche ncandidati, cluster(id_coll)
outreg2 using tables/lreg1, `opt'

reg p_votinonvalidi distanza turnout p_schedebianche ncandidati delitti_pa mafia delitti laurea_rate diploma_rate refturnout act_rate unemp_rate realgdp urb_rate, cluster(id_coll)
outreg2 using tables/lreg1, `opt'

areg p_votinonvalidi distanza turnout p_schedebianche ncandidati D*, cluster(id_coll) absorb(id)
outreg2 using tables/lreg1, `opt'

reg p_votinonvalidi distanza if elettori<=1200, cluster(id_coll)
outreg2 using tables/lreg1b, replace `opt'  

reg p_votinonvalidi distanza turnout p_schedebianche ncandidati  if elettori<=1200, cluster(id_coll)
outreg2 using tables/lreg1b, `opt'

reg p_votinonvalidi distanza turnout p_schedebianche ncandidati delitti_pa mafia delitti  laurea_rate diploma_rate refturnout act_rate unemp_rate realgdp urb_rate  if elettori<=1200, cluster(id_coll)
outreg2 using tables/lreg1b, `opt'

areg p_votinonvalidi distanza turnout p_schedebianche ncandidati D*  if elettori<=1200, cluster(id_coll) absorb(id)
outreg2 using tables/lreg1b, `opt'
*/

* SECOND TABLE

foreach y of varlist turnout{
su `y'
gen `y'_sq=(`y'-r(mean))^2
gen `y'_cu=(`y'-r(mean))^3
gen `y'_ed1=`y'*laurea_rate 
gen `y'_ed2=`y'*diploma_rate
gen `y'_ed12=`y'_sq*laurea_rate 
gen `y'_ed22=`y'_sq*diploma_rate
gen `y'_ed13=`y'_cu*laurea_rate 
gen `y'_ed23=`y'_cu*diploma_rate
}


areg p_votinonvalidi distanza turnout turnout_sq turnout_cu p_schedebianche ncandidati D*, cluster(id_coll)  absorb(id)
outreg2 using tables/lreg2, `opt' replace

areg p_votinonvalidi distanza turnout* p_schedebianche ncandidati D*, cluster(id_coll)  absorb(id)
outreg2 using tables/lreg2, `opt'

areg p_votinonvalidi distanza turnout p_schedebianche ncandidati D* if north==1, cluster(id_coll)  absorb(id)
outreg2 using tables/lreg2, `opt'

areg p_votinonvalidi distanza turnout p_schedebianche ncandidati D* if north==0, cluster(id_coll)  absorb(id)
outreg2 using tables/lreg2, `opt'

areg p_votinonvalidi distanza turnout p_schedebianche ncandidati di_turn di_ncand D*, cluster(id_coll) absorb(id)
outreg2 using tables/lreg2, `opt'

areg p_votinonvalidi distanza turnout p_schedebianche ncandidati di_turn di_ncand D* if north==1, cluster(id_coll) absorb(id)
outreg2 using tables/lreg2, `opt'

areg p_votinonvalidi distanza turnout p_schedebianche ncandidati di_turn di_ncand D* if north==0, cluster(id_coll) absorb(id)
outreg2 using tables/lreg2, `opt'



* THIRD TABLE

qui su distanza
local rmean=r(mean)
qui su c_distanza
gen inter=(c_distanza-r(mean))*(distanza-`rmean')

areg p_votinonvalidi distanza c_distanza turnout p_schedebianche ncandidati D* destra1 sinistra1, cluster(id_coll) absorb(id)
outreg2 using tables/lreg3, `opt' replace
 
areg p_votinonvalidi distanza c_distanza inter turnout p_schedebianche ncandidati D* destra1 sinistra1, cluster(id_coll) absorb(id)
outreg2 using tables/lreg3, `opt'
drop inter 

qui su distanza if elettori<=1200
local rmean=r(mean)
qui su c_distanza
gen inter=(c_distanza-r(mean))*(distanza-`rmean')

areg p_votinonvalidi distanza c_distanza turnout p_schedebianche ncandidati D* destra1 sinistra1  if elettori<=1200, cluster(id_coll) absorb(id)
outreg2 using tables/lreg3, `opt' 
 
areg p_votinonvalidi distanza c_distanza inter turnout p_schedebianche ncandidati D* destra1 sinistra1  if elettori<=1200, cluster(id_coll) absorb(id)
outreg2 using tables/lreg3, `opt'
drop inter 

*/




* FOURTH TABLE INTERACTIONS
local replace "replace"
foreach y of varlist delitti_pa mafia dmafia{
qui su distanza
local rmean=r(mean)
qui su `y'

gen inter=(`y'-r(mean))/r(sd)*(distanza-`rmean')
reg p_votinonvalidi distanza `y' inter turnout p_schedebianche ncandidati D*, cluster(id_coll)
outreg2 using tables/lreg4, `opt' `replace'
local replace ""
areg p_votinonvalidi distanza `y' inter turnout p_schedebianche ncandidati D*, cluster(id_coll) absorb(id)
outreg2 using tables/lreg4, `opt' `replace'
drop inter
}



log close

