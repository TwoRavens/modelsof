

***************************************************************************************************************
*										REPLICATION CODE FOR:
*							Francesc Amat, Carles Boix, Jordi Muñoz and Toni Rodon (2019)
*     From Political Mobilization to Electoral Participation: Turnout in Barcelona in the 1930s	
*										Journal of Politics
*										Run with Stata/SE 15.1
***************************************************************************************************************

************************
* Directory structure
************************

*set working directory where replication materials were unzipped

global original "00_original_data\"
global do "02_do_files\"
global output "03_output\"
global aux "04_aux\"

/*--------------------------------------------------*
*-------------Variable & dataset creation-----------*
*---------------------------------------------------*

use ${original}Barcelona1930s_main.dta, clear

save ${working}Barcelona1930s_main.dta, replace

*Create long dataset
use ${original}Barcelona1930s_main.dta, clear
gen individualid=_n
rename vote1934 vot1
rename vote1936 vot2
reshape long vot, i(individual) j(election)
by individual: egen nonmissing = count(vot) if (election==1 | election==2)
keep if nonmissing==2
save ${original}Barcelona1930s_long.dta, replace 
*/

*---------------------------------------------------*
*------------Tables & figures main paper------------*
*---------------------------------------------------*

log using ${output}log_mainfile.log, replace

*figure 1: see Database_Figure1.xlsx

*Figure 2: Map see scriptMaps.R

*--------------Table 1: Baseline results. Vote in 1936. Linear Probability models

use ${original}Barcelona1930s_main_short.dta, clear

reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker  i.district, r cluster( pct_id)
est store base1

reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district , r cluster( pct_id)
est store base2

reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker log_meters_sport c.shareworkerpct densitypct sharebornspainpct  i.district , r cluster( pct_id)
est store base3

reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district , r cluster( pct_id)
est store base4


esttab base* using ${output}models.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 c.log_meters_ateneu "Log distance to republican/socalist" c.meters_to_nidrepsoc "Distance to republican/socalist" ///
 1.worker#c.shareworkerpct_h "Worker X Density unskilled workers" literacy "Literacy" age "Age" vote1934_depurada "Turnout 1934" ///
 c.age#c.age "Age squared" prox_km_to_nidrepsoc "Proximity to republican/socialist" ///
 densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930" dist_cat "Distance to City center" /// 
 shareworkerpct_h "Density unskilled workers" _cons "Constant" ///
 suminvdistrepsoc  "Sum Inverse Distance to Rep/Soc Centers"  ) drop(*.district) nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress replace 

 *------Figure 3: Probability to vote, by distance to the closest Ateneu

reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district , r cluster( pct_id)
margins, at(log_meters_ateneu=(3.5(0.1)7) worker=(1))
marginsplot, scheme(s1mono) xlabel(3 3.5 4 4.5 5 5.5 6 6.5 7 7.5)   addplot(hist log_meters_ateneu  if e(sample), bin(10) yaxis(2)  xlabel(3 3.5 4 4.5 5 5.5 6 6.5 7 7.5) /// 
	lcolor(gs8) fcolor(none)  dens) recast(line) recastci(rline) title("Unskilled workers") name(base1)
 
 
reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district , r cluster( pct_id)
margins, at(log_meters_ateneu=(3.5(0.1)7) worker=(0))
marginsplot,  scheme(s1mono) xlabel(3 3.5 4 4.5 5 5.5 6 6.5 7 7.5)  addplot(hist log_meters_ateneu  if e(sample), bin(10) yaxis(2)  xlabel(3 3.5 4 4.5 5 5.5 6 6.5 7 7.5) /// 
	lcolor(gs8) fcolor(none)  dens) recast(line) recastci(rline) title("Rest") name(base2)
 
 graph combine base1 base2, xcommon ycommon scheme(s1mono)
 graph export ${output}figure3.pdf, replace
 
*-------------Table 2: Full fixed-effect models-----------*
recode age (18/24=1 "18/24") (25/34=2 "25/34") (35/44=3 "35/44") (45/54=4 "45/54") (55/64=5 "55/64") (65/74=6 "65/74") (75/100=7 "Over 75"), gen(agegroup)
egen FE_ageg_female_lit_pct=group(female agegroup literacy  pct_id)
xtset FE_ageg_female_lit_pct

xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu worker##c.densitypct , fe robust  cluster( pct_id)
est store feimai1

xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu worker##c.densitypct worker##c.shareworkerpct , fe robust  cluster( pct_id)
est store feimai2

xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport  , fe robust  cluster( pct_id)
est store feimai3

esttab feimai* using ${output}models.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2_p N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Worker" log_meters_ateneu "Log distance to nearest Rep/Soc association" 1.worker#c.log_meters_ateneu "Worker X Log distance to nearest Rep/Soc association"  ///
 c.shareworkerpct_h "Density Unskilled Workers"  1.worker#c.shareworkerpct_h "Worker X Density Unskilled Workers" age "Age" c.age#c.age "Age Squared" vote1934 "Vote(t-1)"  _cons "Constant" ///
 1.worker#c.dist_centerasquare "worker X Distance Catalunya Sq" ) nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append 
 
*---------------------------------------------------*
*-------------Table 3: Panel models. Individual Fixed Effects Models---------*
*---------------------------------------------------*

use ${original}Barcelona1930s_long_short.dta, clear

xtset individual election

xtreg vot  i.election##c.log_meters_ateneu##i.worker , fe robust  cluster( pct_id)
est store apanelfe1

xtreg vot  i.election##c.log_meters_ateneu##i.worker  i.election##c.densitypct  , fe robust  cluster( pct_id)
est store apanelfe2

xtreg vot  i.election##c.log_meters_ateneu##i.worker i.election##c.densitypct i.election##c.shareworkerpct  , fe robust  cluster( pct_id)
est store apanelfe3

esttab apanelfe* using ${output}models.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 r2_o sigma_u rho F F_f N, fmt(%9.3f) labels("R-squared" "N")) legend ///
 varlabels(i.election "election"  shareworkerpct "Density Unskilled Workers"  log_meters_ateneu "Log Distance to nearest Rep/Soc" /// 
 log_meters_anarchist "Log distance to nearest Anarchist Ateneu"  _cons "Constant") nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append 

*---------------------------------------------------*
*---------Figure 4: 1934-36 D Probability to vote, by distance to the closest Ateneu
*---------------------------------------------------*

xtreg vot  i.election##c.log_meters_ateneu##i.worker i.election##c.densitypct i.election##c.shareworkerpct , fe robust  cluster( pct_id)
margins, dydx(election) at( log_meters_ateneu=(3.5(0.1)7) worker=(1)) noestimcheck 
marginsplot,  scheme(s1mono) yline(0)  addplot(hist log_meters_ateneu  if e(sample), bin(10) yaxis(2) ///
	xlabel(3 3.5 4 4.5 5 5.5 6 6.5 7 7.5) lcolor(gs8) fcolor(none)  dens) recast(line) recastci(rline) title("Unskilled workers")  name(p1)


margins, dydx(election) at( log_meters_ateneu=(3.5(0.1)7) worker=(0)) noestimcheck 
marginsplot,  scheme(s1mono) yline(0) addplot(hist log_meters_ateneu  if e(sample), bin(10) yaxis(2)  /// 
	xlabel(3 3.5 4 4.5 5 5.5 6 6.5 7 7.5) lcolor(gs8) fcolor(none)  dens) recast(line) recastci(rline) title("Rest")  name(p2)

graph combine p1 p2, xcommon ycommon scheme(s1mono)
 graph export ${output}figure4.pdf, replace

*---------------------------------------------------*
*Figure 5: Indirect effects. The conditioning role of the density of unskilled workers
*---------------------------------------------------*

use ${original}Barcelona1930s_main_short.dta, clear
recode age (18/24=1 "18/24") (25/34=2 "25/34") (35/44=3 "35/44") (45/54=4 "45/54") (55/64=5 "55/64") (65/74=6 "65/74") (75/100=7 "Over 75"), gen(agegroup)
egen FE_ageg_female_lit_pct=group(female agegroup literacy  pct_id)
xtset FE_ageg_female_lit_pct

xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu##c.shareworkerpct  worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport ,  fe robust  cluster( pct_id)
margins, dydx(log_meters_ateneu) at(shareworkerpct=(0.1(0.01)0.8)  worker=(1)) noestimcheck 
marginsplot,  scheme(s1mono) xlabel(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8)  yline(0) addplot(hist shareworkerpct if e(sample), bin(10) yaxis(2) /// 
	xlabel(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8) lcolor(gs8) fcolor(none)  dens) recast(line) recastci(rline) title("Effect of Log Distance to Rep/Socialist Ateneu for Unskilled Workers") 
graph export ${output}figure5.pdf, replace

*---------------------------------------------------*
*-------------Table 4: Panel Models CNT-------------*
*---------------------------------------------------*

use ${original}Barcelona1930s_long_short.dta, clear

xtset individual election

xtreg vot  i.election##c.log_meters_anarchist    i.election##i.worker , fe robust  cluster( pct_id)
est store bpanelfe1

xtreg vot  i.election##c.log_meters_anarchist    i.election##i.worker i.election##c.densitypct i.election##c.shareworkerpct   , fe robust  cluster( pct_id)
est store bpanelfe2

xtreg vot  i.election##c.log_meters_anarchist##i.worker i.election##c.densitypct i.election##c.shareworkerpct   , fe robust  cluster( pct_id)
est store bpanelfe3

esttab bpanelfe* using ${output}models.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 r2_o sigma_u rho F F_f N, fmt(%9.3f) labels("R-squared" "N")) legend ///
 varlabels(i.election "election"  shareworkerpct "Density Unskilled Workers"  log_meters_ateneu "Log Distance to nearest Rep/Soc" /// 
 log_meters_anarchist "Log distance to nearest Anarchist Ateneu"  _cons "Constant") nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append

*---------------------------------------------------*
*-----Figure 6: Anarchist mobilization effects across elections, 1934-36
*---------------------------------------------------*

xtreg vot  i.election##c.log_meters_anarchist  i.election##i.worker i.election##c.densitypct i.election##c.shareworkerpct   , re robust 
margins, dydx(log_meters_anarchist) over(election)  post
coefplot, scheme(s1mono) yline(0, lp(shortdash) lc(black)) levels(95 90) ciopts(lwidth(medium thick)) vertical xtitle("Election") /// 
	title("Effect of Log Distance to Anarchist Ateneu by Election") coeflabel(1.election="1934" 2.election="1936")
graph export ${output}figure6.pdf, replace


*---------------------------------------------------*
*-------------Table 5: Aggregate Models-------------*
*---------------------------------------------------*

*Open the sp[atial dataset
use ${original}coord.dta, clear
*Merge it with the limits dataset
merge 1:1 cartodb_id using ${original}Barcelona1930s_aggregate_short.dta
*drop one of the missings
keep if _merge==3
drop _merge

/*To create the spatial matrix, place the shapefiles in the same folder than the dataset
 (otherwise it does not work) and execute the following commented line */
*spmatrix create contiguity W, rook replace

*Import spatial weight matrix
spmatrix import W using "${original}contig.txt", replace

**********************************
************ TABLE 5 *************
**********************************

spregress part36 log_meters_factory illiterate left34 densitypct dist_center i.district, gs2sls dvarlag(W) force
est store aggre1
spregress part36  log_meters_factory log_meters_ateneu illiterate left34 densitypct dist_center   i.district, gs2sls dvarlag(W) force
est store aggre2
spregress part36  log_meters_factory log_meters_ateneu log_meters_sport illiterate left34 densitypct dist_center   i.district, gs2sls dvarlag(W) force 
est store aggre3
spregress part36 c.log_meters_ateneu##c.illiterate c.log_meters_sport##c.illiterate  left34 densitypct dist_center   i.district, gs2sls dvarlag(W) force  
est store aggre4



esttab aggre* using ${output}models.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(N, fmt(%9.3f) labels("N")) legend ///
 varlabels(illiterate "Illiteracy" log_meters_ateneu "Log Distance to nearest Rep/Soc" /// 
 log_meters_anarchist "Log distance to nearest Anarchist Ateneu" log_meters_to_nidesports "Log distance to sports association" ///
 log_meters_factory "Log distance to 1906 Factory" _cons "Constant" c.log_meters_ateneu#c.illiterate "Log distance to Rep/Soc X Illiteracy" ///
 c.log_meters_to_nidesports#c.illiterate "Log distance to sports X Illiteracy" part36 "Turnout (spatial lag)" ) ///
 drop(*.district left34 densitypct dist_center) ///
 mtitles collabels(,none) varwidth(20) nobase noomitted compress append
 
 log close
 
