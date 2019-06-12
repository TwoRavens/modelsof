
***************************************************************************************************************
*										ONLINE APPENDIX REPLICATION CODE
*							Francesc Amat, Carles Boix, Jordi Muñoz and Toni Rodon (2019)
*     From Political Mobilization to Electoral Participation: Turnout in Barcelona in the 1930s	
*										Journal of Politics
***************************************************************************************************************

************************
* Directory structure
************************

*set working directory where replication materials were unzipped

global original "00_original_data\"
global do "02_do_files\"
global output "03_output\"
global aux "04_aux\"

*---------------------------------------------------*
*-------------Preamble & Variable creation----------*
*---------------------------------------------------*




*---------------------------------------------------*
*----------Tables & figures ONLINE APPENDIX---------*
*---------------------------------------------------*

log using ${output}log_appendix.log, replace


*Table A.1: Descriptives of variables used in individual-level models
use ${original}Barcelona1930s_main_short.dta, clear
quietly reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district , r cluster( pct_id)

eststo summstats: estpost summarize vote1936 vote1934 worker female literacy age /// 
	log_meters_ateneu log_meters_anarchist log_meters_sport sharebornspainpct shareworkerpct if e(sample)
esttab summstats using  ${output}tablesappendix.tex, cells("count mean(fmt(2)) sd(fmt(2)) min max") noobs nomtitles nonum replace 

*Table A.2: Descriptives of variables used in aggregate-level models
use ${original}Barcelona1930s_aggregate_short.dta, clear
quietly reg part36 c.log_meters_ateneu##c.illiterate c.log_meters_sport##c.illiterate  left34 densitypct dist_center   i.district, robust

eststo summstats: estpost summarize part36  log_meters_ateneu log_meters_factory log_meters_sport /// 
	left34 illiterate  densitypct dist_center  if e(sample)
esttab summstats  using  ${output}tablesappendix.tex, cells("count mean(fmt(2)) sd(fmt(2)) min max") noobs nomtitles nonum append 


*Table A.3: Distribution of (registered) occupations, by gender
use ${original}Barcelona1930s_main_short.dta, clear
estpost tabulate csp female
esttab . using  ${output}tablesappendix.tex, cell(colpct(fmt(2))) unstack noobs append 

*Table A.4: Turnout rates by age, gender, literacy and occupational status

recode age (18/24=1 "18/24") (25/34=2 "25/34") (35/44=3 "35/44") (45/54=4 "45/54") (55/64=5 "55/64") (65/74=6 "65/74") (75/100=7 "Over 75"), gen(agegroup)

eststo edat34: estpost tab agegroup vote1934
eststo edat36: estpost tab agegroup vote1936
esttab edat* using  ${output}tablesappendix.tex, cell(rowpct(fmt(2))) unstack noobs nonumber app

eststo female34: estpost tab female vote1934
eststo female36: estpost tab female vote1936
esttab female* using  ${output}tablesappendix.tex, cell(rowpct(fmt(2))) unstack noobs nonumber app


eststo literacy34: estpost tab literacy vote1934
eststo literacy36: estpost tab literacy vote1936
esttab literacy* using  ${output}tablesappendix.tex, cell(rowpct(fmt(2))) unstack noobs nonumber app


eststo hisclass34: estpost tab hisclass vote1934
eststo hisclass36: estpost tab hisclass vote1936
esttab hisclass34 hisclass36 using  ${output}tablesappendix.tex, cell(rowpct(fmt(2))) unstack noobs nonumber app

esttab hisclass34 hisclass36, cell(rowpct(fmt(2))) unstack  app

 
*Table A.5: Individual factors. Turnout in 1936. OLS model with Precinct Fixed Effects

*Table:  BaseLine Models
eststo ind1: reg  vote1936   worker##female literacy c.age##c.age if outpanel==0, r cluster( pct_id)
estadd local pctFE "No"

eststo ind2: reg  vote1936   worker##female literacy c.age##c.age i. pct_id if outpanel==0,  r cluster( pct_id)
est store ind2
estadd local pctFE "Yes"

eststo ind3: reg  vote1936  vote1934  worker##female literacy c.age##c.age i. pct_id if outpanel==0,  r cluster( pct_id)
estadd local pctFE "Yes"

esttab ind* using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 scalars("pctFE Precinct Fixed-Effects") ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///																					///
 age "Age" c.age#c.age "Age squared"  _cons "Constant") drop(*.pct_id) ///
 mtitles collabels(,none) varwidth(20) compress append

*Figure A.1: The Quadratic effect of age in the baseline models
reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district , r cluster( pct_id)
quietly margins, at(age=(18(1)100))
marginsplot, scheme(s1mono) recast(line) noci title("The quadratic effect of Age on Turnout 1936") xtitle("Age") ytitle("Predicted probability of voting")
graph export ${output}figureG3.pdf, replace
 
*Table D.1: Balance

capt prog drop mergemodels
prog mergemodels, eclass
 version 8
 syntax namelist
 tempname b V tmp
 foreach name of local namelist {
   qui est restore `name'
   mat `b' = nullmat(`b') , e(b)
   mat `b' = `b'[1,1..colsof(`b')-1]
   mat `tmp' = e(V)
   mat `tmp' = `tmp'[1..rowsof(`tmp')-1,1..colsof(`tmp')-1]
   capt confirm matrix `V'
   if _rc {
     mat `V' = `tmp'
   }
   else {
     mat `V' = ///
      ( `V' , J(rowsof(`V'),colsof(`tmp'),0) ) \ ///
      ( J(rowsof(`tmp'),colsof(`V'),0) , `tmp' )
   }
 }
 local names: colfullnames `b'
 mat coln `V' = `names'
 mat rown `V' = `names'
 eret post `b' `V'
 eret local cmd "whatever"
end

eststo m1: reg log_meters_ateneu densitypct
eststo m2: reg log_meters_ateneu shareworkerpct 
eststo m3: reg log_meters_ateneu illiterate 
eststo m4: reg log_meters_ateneu dist_center
eststo m5: reg log_meters_ateneu log_meters_sport


set trace off
mergemodels m1 m2 m3 m4 m5
est sto m_dist

eststo vot1: reg vote1936 densitypct
eststo vot2: reg vote1936 shareworkerpct 
eststo vot3: reg vote1936 illiterate 
eststo vot4: reg vote1936 dist_center
eststo vot5: reg vote1936 log_meters_sport


mergemodels vot1 vot2 vot3 vot4 vot5
est sto m_vot
estout m_dist m_vot using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) se(par)) append


*Table E.1: Robustness: Logit Specification

logit  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker  i.district if outpanel==0, r cluster( pct_id)
est store logit1

logit  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
est store logit2

logit  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker log_meters_sport c.shareworkerpct densitypct sharebornspainpct  i.district if outpanel==0, r cluster( pct_id)
est store logit3

logit  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
est store logit4


esttab logit* using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2_p N, fmt(%9.3f %9.0g) labels("Pseudo R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 log_meters_ateneu "Log distance to republican/socalist"  1.worker#c.log_meters_ateneu "Worker X Log distance to republican/socalist" /// 
 literacy "Literacy" age "Age" vote1934 "Turnout 1934" c.age#c.age "Age squared" densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930"  /// 
 shareworkerpct_h "Density unskilled workers" log_meters_sport "Log distance to sports association" /// 
 1.worker#c.log_meters_sport "Worker X Log distance to sports association" _cons "Constant") drop(*.district) ///
 mtitles collabels(,none) varwidth(20) nobase noomitted compress append 
 

*Table E.2: Robustness: Linear Mixed-effects models


mixed  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker  i.district if outpanel==0, r cluster( pct_id)
est store ml1

mixed  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
est store ml2

mixed  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker log_meters_sport c.shareworkerpct densitypct sharebornspainpct  i.district if outpanel==0, r cluster( pct_id)
est store ml3

mixed  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
est store ml4


esttab ml* using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2_p N, fmt(%9.3f %9.0g) labels("Pseudo R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 log_meters_ateneu "Log distance to republican/socalist"  1.worker#c.log_meters_ateneu "Worker X Log distance to republican/socalist" /// 
 literacy "Literacy" age "Age" vote1934 "Turnout 1934" c.age#c.age "Age squared" densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930"  /// 
 shareworkerpct_h "Density unskilled workers" log_meters_sport "Log distance to sports association" /// 
 1.worker#c.log_meters_sport "Worker X Log distance to sports association" _cons "Constant") drop(*.district)  ///
 mtitles collabels(,none) varwidth(20) nobase noomitted compress append 
 

*Table E.3: Robustness: Baseline Fully Interacted Models to Explore the Mechanism

use ${original}Barcelona1930s_main_short.dta, clear
recode age (18/24=1 "18/24") (25/34=2 "25/34") (35/44=3 "35/44") (45/54=4 "45/54") (55/64=5 "55/64") (65/74=6 "65/74") (75/100=7 "Over 75"), gen(agegroup)
egen FE_ageg_female_lit_pct=group(female agegroup literacy  pct_id)
xtset FE_ageg_female_lit_pct

xtreg vote1936   c.age##c.age  worker##c.log_meters_ateneu##vote1934  worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport, fe robust  cluster( pct_id)
est store femech1

xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu##c.shareworkerpct  worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport ,  fe robust  cluster( pct_id)
est store femech2

xtreg vote1936   c.age##c.age  worker##c.log_meters_ateneu##c.shareworkerpct  worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport  if vote1934==0  , fe robust  cluster( pct_id)
est store femech3

esttab femech* using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2_p N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend noomitted ///
 nobaselevels varlabels(1.worker "Worker" 1.vote1934 "Vote in (t-1)" c.log_meters_ateneu "Proximity to Rep/Soc" 1.worker#c.log_meters_ateneu "Worker X Proximity to Rep/Soc"  ///
 shareworkerpct_h "Density Unskilled Workers"  1.worker#c.shareworkerpct_h "Worker X Density Unskilled Workers" age "Age" c.age#c.age "Age Squared" vote1934 "Vote(t-1)"  _cons "Constant" ///
 c.log_meters_ateneu#c.shareworkerpct_h "Proximity to Repub/Soc X Density Unskilled Workers" ///
 1.worker#c.log_meters_ateneu#c.shareworkerpct_h "Worker X Proximity to Rep/Soc X Density Unskilled Workers" ) ///
 mtitles collabels(,none) varwidth(20) nobase noomitted compress append 
 
  
*Table E.4: Robustness: Panel Individual Random Effects Models

use ${original}Barcelona1930s_long_short.dta, clear

xtset individual election

xtreg vot  i.election##c.log_meters_anarchist    i.election##i.worker, re robust 
est store bpanelre1

xtreg vot  i.election##c.log_meters_anarchist    i.election##i.worker i.election##c.densitypct i.election##c.shareworkerpct, re robust 
est store bpanelre2


esttab bpanelre* using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 r2_o sigma_u rho F F_f N, fmt(%9.3f) labels("R-squared" "N")) legend ///
 varlabels(2.election "1936 election"  shareworkerpct "Density Unskilled Workers"  log_meters_ateneu "Log Distance to nearest Rep/Soc" /// 
 log_meters_anarchist "Log distance to nearest Anarchist Ateneu" 2.election#c.log_meters_anarchist "1936 X Distance to Anarchists"  ///
 2.election#1.worker "1936 X Worker" 2.election#c.densitypct "1936 X Density" 2.election#c.shareworkerpct_h "1936 X Share unskilled" _cons "Constant") noomitted nobase ///
 mtitles collabels(,none) varwidth(20) nobase noomitted compress append
 

*Figure E.1: Predicted turnout by Gender, distance to organizations and occupation
use ${original}Barcelona1930s_main_short.dta, clear
reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker##female c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
margins, dydx(log_meters_ateneu) at(female=(0 1) worker=(0 1))
marginsplot, scheme(s1mono) by(female) yline(0)
 graph export ${output}figureD1.pdf, replace

*Table E.5: Full fixed-effect models, by gender
  
use ${original}Barcelona1930s_main_short.dta, clear
recode age (18/24=1 "18/24") (25/34=2 "25/34") (35/44=3 "35/44") (45/54=4 "45/54") (55/64=5 "55/64") (65/74=6 "65/74") (75/100=7 "Over 75"), gen(agegroup)
egen FE_ageg_female_lit_pct=group(female agegroup literacy  pct_id)
xtset FE_ageg_female_lit_pct
xtreg vote1936  vote1934 c.age##c.age worker##c.log_meters_ateneu worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport  if outpanel==0 & female==0, fe robust  cluster( pct_id)
est store fe_male
xtreg vote1936  vote1934 c.age##c.age worker##c.log_meters_ateneu worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport  if outpanel==0 & female==1, fe robust  cluster( pct_id)
est store fe_female

esttab fe_male fe_female using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend nobase noomitted ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 c.log_meters_ateneu "Log distance to republican/socalist" 1.worker#c.shareworkerpct_h "Worker X Density unskilled workers" literacy "Literacy" age "Age" vote1934_dep "Turnout 1934" ///
 c.age#c.age "Age squared"  densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930" dist_center "Distance to City center" /// 
 shareworkerpct_h "Density unskilled workers" _cons "Constant") drop(*age)  ///
 mtitles collabels(,none) varwidth(20) compress append 

*Table E.6, Measurement error

gen outpanel2=outpanel
replace outpanel2=1 if v13==-2

reg  vote1936  worker##female literacy c.age##c.age vote1934_dep c.log_meters_ateneu##worker  i.district if outpanel2==0, r cluster( pct_id)
est store depurada1

reg  vote1936  worker##female literacy c.age##c.age vote1934_dep c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel2==0, r cluster( pct_id)
est store depurada2

reg  vote1936  worker##female literacy c.age##c.age vote1934_dep c.log_meters_ateneu##worker log_meters_sport c.shareworkerpct densitypct sharebornspainpct  i.district if outpanel2==0, r cluster( pct_id)
est store depurada3

reg  vote1936  worker##female literacy c.age##c.age vote1934_dep c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel2==0 , r cluster( pct_id)
est store depurada4


esttab depurada* using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 log_meters_ateneu "Log distance to republican/socalist" ///
 1.worker#c.shareworkerpct_h "Worker X Density unskilled workers" literacy "Literacy" age "Age" ///
 log_meters_sport "Log distance to sports association" /// 
 1.worker#c.log_meters_sport "Worker X Log distance to sports association" 1.worker#c.log_meters_ateneu "Worker X Proximity to Rep/Soc"  ///
 vote1934_dep "Turnout 1934 Modified" ///
 c.age#c.age "Age squared" densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930"  ///
 shareworkerpct_h "Density unskilled workers" _cons "Constant") drop(*.district) nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append 

*Table E.7: Baseline results with alternative occupation measure

 
reg  vote1936  b1.hisclass_3##female literacy c.age##c.age vote1934 c.log_meters_ateneu##b1.hisclass_3  i.district if outpanel==0, r cluster( pct_id)
est store base1

reg  vote1936  b1.hisclass_3##female literacy c.age##c.age vote1934 c.log_meters_ateneu##b1.hisclass_3 c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
est store base2

reg  vote1936  b1.hisclass_3##female literacy c.age##c.age vote1934 c.log_meters_ateneu##b1.hisclass_3 log_meters_sport c.shareworkerpct densitypct sharebornspainpct  i.district if outpanel==0, r cluster( pct_id)
est store base3

reg  vote1936  b1.hisclass_3##female literacy c.age##c.age vote1934 c.log_meters_sport##b1.hisclass_3 c.log_meters_ateneu##b1.hisclass_3 c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
est store base4

esttab base* using  ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 log_meters_ateneu "Log distance to republican/socalist" ///
 1.worker#c.shareworkerpct_h "Worker X Density unskilled workers" literacy "Literacy" age "Age" ///
 log_meters_sport "Log distance to sports association" /// 
 1.worker#c.log_meters_sport "Worker X Log distance to sports association" 1.worker#c.log_meters_ateneu "Worker X Proximity to Rep/Soc"  ///
 vote1934 "Turnout 1934" ///
 c.age#c.age "Age squared" densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930"  ///
 shareworkerpct_h "Density unskilled workers" _cons "Constant") drop(*.district) ///
 mtitles collabels(,none) varwidth(20) compress append 
 
*Figure E.2 Predicted  turnout  by  distance  to  organizations  and occupation
reg  vote1936  b1.hisclass_3##female literacy c.age##c.age vote1934 c.log_meters_sport##b1.hisclass_3 c.log_meters_ateneu##b1.hisclass_3 c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0, r cluster( pct_id)
margins, at(log_meters_ateneu=(0(1)7) hisclass_3=(3 2 1))
marginsplot, recastci(rspike) recast(line) title("Predicted Turnout, by Log Distance to Rep/Soc Association and Occupational Group") 
graph export ${output}figureE2.pdf, replace


***********************************************
************ FIGURES IN APPENDIX F ************
***********************************************



*Figure F.1: Joint Density Function of Left Increase and Turnout Increase, 1934-36
use ${original}Barcelona1930s_aggregate_short.dta, clear
*use ${original}Barcelona1930s_aggregate_short.dta, clear
set more off
net from http://dasp.ecn.ulaval.ca/modules/DASP_V2.3/dasp
net install dasp_p1, force
net install dasp_p2, force
net install dasp_p3, force
net install dasp_p4, force
*Gen additional vars
gen difturnout= part36-part34
gen fec36f_cens=(part36/100)*(fec36f/100)
gen left34_cens=(part34/100)*(left34/100)
gen difleft_cens=fec36f_cens-left34_cens
*Keep only precincts with individual-level data:
keep if shareworkerpct!=. 
*Figure F.1: (sample of precincts with individual-level data):
sjdensity difturnout difleft_cens, lab1(Turnout Increase) lab2(Left Increase) title(Joint Density Function Left Increase and Turnout Increase 1934-1936) max1(30) par1(50) max2(0.35) par2(50)
*Figure F.2: (sample of precincts with individual-level data):
sjdensity  shareworkerpct   difleft_cens, lab1(Density Unskilled Male Workers) lab2(Left Increase) title(Joint Density Function Left Increase and Density Unskilled Workers 1934-1936) min1(0) max1(1.2)  par1(50) min2(0) max2(0.35) max2(25) par2(50)


*Figure F.3: Spatial Correlations: 1930s Rep/Soc Associations and 1930s Sports Associations
use ${original}Barcelona1930s_aggregate_short.dta, clear
twoway (scatter log_meters_ateneu log_meters_sport ) (lfit log_meters_ateneu log_meters_sport), legend(off) ///
	title("Log Distance to Nearest 1930s Rep/Soc Association and Log Distance to Nearest 1930s Sports Association")
graph export ${output}figureG3.pdf, replace
	*Figure F.4: Spatial Correlations:1930s Rep/Soc Associations and 1906 Main Factories
twoway (scatter log_meters_ateneu log_meters_factory ) (lfit log_meters_ateneu log_meters_factory), legend(off) ///
	title("Log Distance to Nearest 1930s Rep/Soc Association and Log Distance to Nearest 1906 Factories")
graph export ${output}figureG4.pdf, replace



**********************************
************ TABLE G1 ************
**********************************


*Open the spatial dataset
use ${original}coord.dta, clear
*Merge it with the limits dataset
merge 1:1 cartodb_id using ${original}Barcelona1930s_aggregate_short.dta
*drop one of the missings
keep if _merge==3
drop _merge

*Import file with distances calculated using random centroids. 
*Random centroids and distances are generated on the script "script_maps.R". See line 189 onwards
merge 1:1 uniqueid using ${original}r_distances.dta

spmatrix import W using "${original}contig.txt", replace

spregress part36   rlog_dist_factories  illiterate  left34  densitypct dist_center i.districte, gs2sls dvarlag(W) force
est store r_aggre1
spregress part36   rlog_dist_factories rlog_dist_repsoc   illiterate left34 densitypct dist_center i.district, gs2sls dvarlag(W) force
est store r_aggre2
spregress part36   rlog_dist_factories rlog_dist_repsoc rlog_dist_sports illiterate left34 densitypct dist_center i.district, gs2sls dvarlag(W) force
est store r_aggre3
spregress part36  c.rlog_dist_repsoc##c.illiterate c.rlog_dist_sports##c.illiterate illiterate left34  densitypct  dist_center i.district, gs2sls dvarlag(W) force
est store r_aggre4



esttab r_aggre* using "03_output/tablesappendix.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(N, fmt(%9.3f) labels("N")) legend ///
 varlabels(illiterate "Illiteracy" log_dist_repsoc "Log Distance to nearest Rep/Soc" /// 
	log_dist_sport "Log distance to sports association" ///
 log_dist_factories "Log distance to 1906 Factory" _cons "Constant" c.log_dist_repsoc#c.illiterate "Log distance to Rep/Soc X Illiteracy" ///
 c.log_meters_sport#c.illiterate "Log distance to sports X Illiteracy" part36 "Turnout (spatial lag)" ) ///
 drop(*.district left34 densitypct dist_center) nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append



**********************************
************ TABLE G2 ************
**********************************

use ${original}Barcelona1930s_main_short.dta, clear
merge m:1 pct_id using ${original}distances_sample.dta

reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker  i.district if outpanel==0 [iw=rdistance], r cluster( pct_id)
est store sp_dep_a1
reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0 [iw=rdistance], r cluster( pct_id)
est store sp_dep_a2
reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_ateneu##worker C.log_meters_sport c.shareworkerpct densitypct sharebornspainpct  i.district if outpanel==0 [iw=rdistance], r cluster( pct_id)
est store sp_dep_a3
reg  vote1936  worker##female literacy c.age##c.age vote1934 c.log_meters_sport##worker c.log_meters_ateneu##worker c.shareworkerpct densitypct sharebornspainpct i.district if outpanel==0 [iw=rdistance], r cluster( pct_id)
est store sp_dep_a4



esttab sp_dep_a* using ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 c.log_meters_ateneu "Log distance to republican/socalist" c.meters_to_nidrepsoc "Distance to republican/socalist" ///
 1.worker#c.shareworkerpct_h "Worker X Density unskilled workers" literacy "Literacy" age "Age" vote1934 "Turnout 1934" ///
 c.age#c.age "Age squared" prox_km_to_nidrepsoc "Proximity to republican/socialist" ///
 densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930" dist_center "Distance to City center" shareworkerpct "Density unskilled workers" _cons "Constant" ///
 suminvdistrepsoc  "Sum Inverse Distance to Rep/Soc Centers" log_meters_ateneu "Log Distance to nearest Rep/Soc"  ///
 c.log_meters_ateneu#1.worker  "Log Distance to nearest Rep/Soc X Unskilled worker" ///
 log_meters_sport "Log distance to sports association") ///
 drop(*.district) nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append 

**********************************
************ TABLE G3 ************
**********************************



use ${original}Barcelona1930s_main_short.dta, clear
merge m:1 pct_id using ${original}distances_sample.dta

recode age (18/24=1 "18/24") (25/34=2 "25/34") (35/44=3 "35/44") (45/54=4 "45/54") (55/64=5 "55/64") (65/74=6 "65/74") (75/100=7 "Over 75"), gen(agegroup)
egen FE_ageg_female_lit_pct=group(female agegroup literacy  pct_id)

xtset FE_ageg_female_lit_pct

xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu worker##c.densitypct if outpanel==0 [w=rdistance], fe robust  cluster( pct_id)
est store sp_dep_b1
xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu worker##c.densitypct worker##c.shareworkerpct if outpanel==0 [w=rdistance], fe robust  cluster( pct_id)
est store sp_dep_b2
xtreg vote1936  vote1934 c.age##c.age  worker##c.log_meters_ateneu worker##c.densitypct worker##c.shareworkerpct worker##c.log_meters_sport  if outpanel==0 [w=rdistance], fe robust  cluster( pct_id)
est store sp_dep_b3


esttab sp_dep_b* using ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 c.log_meters_ateneu "Log distance to republican/socalist" c.meters_to_nidrepsoc "Distance to republican/socalist" ///
 1.worker#c.shareworkerpct_h "Worker X Density unskilled workers" literacy "Literacy" age "Age" vote1934 "Turnout 1934" ///
 c.age#c.age "Age squared" prox_km_to_nidrepsoc "Proximity to republican/socialist" ///
 densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930" dist_center "Distance to City center" shareworkerpct_h "Density unskilled workers" _cons "Constant" ///
 suminvdistrepsoc  "Sum Inverse Distance to Rep/Soc Centers" log_meters_ateneu "Log Distance to nearest Rep/Soc"  ///
 c.log_meters_ateneu#1.worker  "Log Distance to nearest Rep/Soc X Unskilled worker" ///
 log_meters_sport "Log distance to sports association")nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append 
 
 

**********************************
************ TABLE G4 ************
**********************************


use ${original}Barcelona1930s_long_short.dta, clear
merge m:1 pct_id using ${original}distances_sample.dta

xtset individual election

xtreg vot  i.election##c.log_meters_ateneu##i.worker if election!=3 & outpanel==0 [w=rdistance], fe robust  cluster( pct_id)
est store sp_dep_c1
xtreg vot  i.election##c.log_meters_ateneu##i.worker  i.election##c.densitypct  if election!=3 & outpanel==0 [w=rdistance], fe robust  cluster( pct_id)
est store sp_dep_c2
xtreg vot  i.election##c.log_meters_ateneu##i.worker i.election##c.densitypct i.election##c.shareworkerpct  if election!=3 & outpanel==0 [w=rdistance], fe robust  cluster( pct_id)
est store sp_dep_c3


esttab sp_dep_c* using ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels(1.worker "Unskilled worker" 1.female "Female" 1.worker#1.female "Worker x female" 1.literacy "Literate" ///
 c.log_meters_ateneu "Log distance to republican/socalist" c.meters_to_nidrepsoc "Distance to republican/socalist" ///
 1.worker#c.shareworkerpct_h "Worker X Density unskilled workers" literacy "Literacy" age "Age" vote1934 "Turnout 1934" ///
 c.age#c.age "Age squared" prox_km_to_nidrepsoc "Proximity to republican/socialist" 2.election "1936 election" ///
 densitypct "Population density" sharebornspainpct "Share born outside Catalonia 1930" dist_center "Distance to City center" shareworkerpct_h "Density unskilled workers" _cons "Constant" ///
 suminvdistrepsoc  "Sum Inverse Distance to Rep/Soc Centers" log_meters_ateneu "Log Distance to nearest Rep/Soc"  ///
 c.log_meters_ateneu#1.worker  "Log Distance to nearest Rep/Soc X Unskilled worker" ///
 log_meters_sport "Log distance to sports association") nobase noomitted ///
 mtitles collabels(,none) varwidth(20) compress append 
 

**********************************
************ TABLE G5 ************
**********************************

xtset individual election


xtreg vot  i.election##c.log_meters_anarchist    i.election##i.worker [w=rdistance], fe robust  cluster( pct_id)
est store sp_dep_d1
xtreg vot  i.election##c.log_meters_anarchist    i.election##i.worker i.election##c.densitypct i.election##c.shareworkerpct  [w=rdistance] , fe robust  cluster( pct_id)
est store sp_dep_d2
xtreg vot  i.election##c.log_meters_anarchist##i.worker i.election##c.densitypct i.election##c.shareworkerpct  [w=rdistance] , fe robust  cluster( pct_id)
est store sp_dep_d3

esttab sp_dep_d* using ${output}tablesappendix.tex, cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 r2_o sigma_u rho F F_f N, fmt(%9.3f) labels("R-squared" "N")) legend ///
 varlabels(i.election "election"  shareworkerpct "Density Unskilled Workers"  log_meters_ateneu "Log Distance to nearest Rep/Soc" /// 
 log_meters_anarchist "Log distance to nearest Anarchist Ateneu"  _cons "Constant") ///
 mtitles collabels(,none) varwidth(20) compress append





**********************************
************ TABLE G6 ************
**********************************

*Open the spatial dataset
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


spregress part36 log_meters_factory illiterate left34 densitypct dist_center i.district, gs2sls dvarlag(W) force
estat impact
spregress part36  log_meters_factory log_meters_ateneu illiterate left34 densitypct dist_center   i.district, gs2sls dvarlag(W) force
estat impact
spregress part36  log_meters_factory log_meters_ateneu log_meters_sport illiterate left34 densitypct dist_center   i.district, gs2sls dvarlag(W) force 
estat impact

gen inter1 = log_meters_ateneu*illiterate
gen inter2 = log_meters_sport*illiterate
spregress part36 log_meters_ateneu log_meters_sport illiterate c.inter1 c.inter2  left34 densitypct dist_center   i.district, gs2sls dvarlag(W) force  
estat impact

*WARNING: esttab does not work with "estat impact"

log close
