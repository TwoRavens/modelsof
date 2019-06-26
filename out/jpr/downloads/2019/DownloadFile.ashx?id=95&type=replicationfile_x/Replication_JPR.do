

/* ----------------------------------------------------------------------------
					Replication file for article
Jordi Muñoz & Eva Anduiza (2018) "'If a Fight Starts, Watch the Crowd'
	The Effect of Violence on Popular Support for Social Movements."
					Journal of Peace Research
Additional details: jordi.munoz@ub.edu & eva.anduiza@uab.cat 
------------------------------------------------------------------------------*/

*User-written Packages
ssc install orth_out
ssc install ebalance

*Set path

*Open data
use riots_replication.dta

*-----------------------------------------*
*---Recoding and creation of variables----*
*-----------------------------------------*

*Dependent variable
recode assoc6_2 (8/9=.) (3=2), gen(simp15m)
recode simp (2=0)

*Treatment variables:

*1. Pre-post (Main treatment)
gen banc3=.
replace banc3=1 if DIA>tc(26may2016 00:00:00)
replace banc3=0 if DIA<tc(24may2016 00:00:00)

*Alternative treatments, for robustness

*2. Pre - During+Post 
gen banc=0
replace banc=1 if DIA>tc(24may2016 00:00:00)
tab banc

*3. Pre-During-Post
gen banc2=0
replace banc2=1 if DIA>tc(24may2016 00:00:00)
replace banc2=2 if DIA>tc(26may2016 00:00:00)


*For Heterogeneous effects
recode rec_gen (1=1 "Core") (2/3=2 "Weak") (4/7=3 "Opposers") (55/88=4 "Non-aligned") (99=.) (50=.), gen(partisans_pastvote)

*Alternative measures, for robustness
recode partyid  (4/8=1 "Core") (12=1) (2/3=2 "Weak") (1=3 "Opposers") (9/11=3) (50/99=4 "Non-aligned"), gen(partisans)
recode rile (0/2=1) (3/4=2) (5=3) (6/7=4) (8/10=5) (88/99=.), gen(ideol5)

*Other variables
*Left-right
gen ideol=rile if rile<11

*Gràcia district
gen gracia=DIST==6
*Linear time trend
gen data=dofc(DIA)
gen diesn=data-20598

*Placebo outcomes
recode efpolex1 8=. 4=0 3=1 2=2 1=3, gen(efipol)
recode assoc4_2 (8/9=.) (3=0) (2=0), gen(av_simp)
recode assoc8_2 (8/9=.) (3=2) (2=0), gen(anc_simp)
recode assoc5_2 (8/9=.) (3=2) (2=0), gen(pah_simp)

*Know the movement, for attrition analysis
recode assoc6_1 2=0, gen(know15m)

*For balance test
recode nacionalidad 2=1 3=0, gen(spanishnational)
recode assoc3 9=., gen(association)
recode inet1 2/3=1 4=0, gen(internetaccess)
recode siteco_nal 8/9=., gen(nateco)
recode idcatesp 8/9=., gen(natid)
gen socialtrust=soctrust if soctrust<11

*Index of political knowledge
gen polknow1_ok=polknow1==1
gen polknow2_ok=polknow2==3
gen polknow3_ok=polknow3==2
replace polknow3_ok=1 if polknow3==3
gen indexpolknow= polknow1_ok+ polknow2_ok+ polknow3_ok

*Dummies support status
tab partisans_p, gen(partisans_p)

*Save file with recoded variables
save riots_replication_rec.dta, replace

*--------------------------*
*-------Analysis-----------*
*--------------------------*

use riots_replication_rec.dta


*TABLE I Balance
orth_out partisans_p1 partisans_p2 partisans_p3 partisans_p4 edat1 ideol /// 
	sexe indexpolknow lat lon spanishnational association internetaccess nateco natid /// 
	socialtrust polint_g  using balance.tex, by(banc3) compare test  latex full replace

*Table II descriptives
tab simp banc3, col 
prtest simp, by(banc3)


*Table III Main table
reg simp banc3, cluster(SECC2)
est store m1
*Results are robust to controls for observables
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe lat lon i.DIST, cluster(SECC2)
est store m2
*Results are robust to control  reachability, and exclude the final day
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA!=td(09jun2016), cluster(SECC2)
est store m3	
*entropy balancing
ebalance banc3 c.edat1 b4.partisans_pastvote refusals i.sexe lat lon i.DIST , tar(2)
reg simp banc3 [pw=_webal], cluster(SECC2)
est store m4

esttab m1 m2 m3 m4  using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") wide ///
 mtitles collabels(,none) varwidth(20) compress replace
 
 *Table IV - Estimate under different time windows
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(11may2016 00:00:00) & DIA<tc(09jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t1
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(12may2016 00:00:00) & DIA<tc(08jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t2
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(13may2016 00:00:00) & DIA<tc(07jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t3
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(14may2016 00:00:00) & DIA<tc(06jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t4
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(15may2016 00:00:00) & DIA<tc(05jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t5
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(16may2016 00:00:00) & DIA<tc(04jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t6
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(17may2016 00:00:00) & DIA<tc(03jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t7
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(18may2016 00:00:00) & DIA<tc(02jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t8
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(19may2016 00:00:00) & DIA<tc(01jun2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t9
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(20may2016 00:00:00) & DIA<tc(31may2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t10
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(21may2016 00:00:00) & DIA<tc(30may2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t11
reg simp banc3 c.edat1 b4.partisans_pastvote ideol i.sexe refusals lat lon i.DIST if DIA>tc(22may2016 00:00:00) & DIA<tc(28may2016 00:00:00), cluster(SECC2)
tab	banc3	if	e(sample)
est store t12

esttab t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 , keep(banc3)  cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(N, fmt(%9.0g) labels("N")) legend ///
 nobaselevels mtitles collabels(,none) varwidth(20) long compress replace

 *Table V: Differences, by previous support
prtest simp if partisans_pastvote==1, by(banc3)
prtest simp if partisans_pastvote==2, by(banc3)
prtest simp if partisans_pastvote==3, by(banc3)
prtest simp if partisans_pastvote==4, by(banc3)
prtest simp, by(banc3)


*Figure 2
ebalance banc3 c.edat1 refusals i.sexe lat lon i.DIST , tar(2) gen(webal2)
reg simp banc3##b1.partisans_pastvote [pw=webal2], cluster(SECC2)
margins, dydx(banc3) over(partisans)
marginsplot, recast(scatter) recastci(rspike) yline(0) xtitle("") title("Effects of Riot exposure on support for the 15M, by past vote") ytitle("")
graph export "heterogeneous_pastvote.pdf", as(pdf) replace



*--------------------------------*
*---------Appendices-------------*
*--------------------------------*


*A1. Pre-weighting Balance
ebalance banc3 c.edat1 b4.partisans_pastvote refusals i.sexe lat lon i.DIST , tar(2)

*B1 Heterogeneous effects, full tables and figures with alternative measures

reg simp banc3##b1.partisans_pastvote [pw=webal2], cluster(SECC2)
est store het1

reg simp banc3##b1.partisans [pw=webal2], cluster(SECC2)
est store het2
margins, dydx(banc3) over(partisans)
marginsplot, recast(scatter) recastci(rspike) yline(0) xtitle("") title("Effects of Riot exposure on support for the 15M, by partisanship") ytitle("")
graph export "heterogeneous_partisans.pdf", as(pdf) replace

reg simp banc3##b1.ideol5 [pw=webal2], cluster(SECC2)
est store het3
margins, dydx(banc3) over(ideol5)
marginsplot, recast(scatter) recastci(rspike) yline(0) xtitle("") title("Effects of Riot exposure on support for the 15M, by ideology") ytitle("")
graph export "heterogeneous_ideol.pdf", as(pdf) replace

esttab het1 het2 het3 using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") wide ///
 mtitles collabels(,none) varwidth(20) compress append

 *C1 Refusals 
bysort DIA: gen entrevistes=_N
collapse (sum) refusals (count) entrevistes, by(DIA)
gen propref= refusals/entrevistes
label var entrevistes "Completed interviews"
label var propref "Refusals per interview"
twoway (line propref entrev DIA, yaxis(1)) 
graph export Graph "refusals.pdf", as(pdf) replace
save collapsedrefusals.dta

*C.2 Time trends 
use riots_replication_rec.dta, clear

reg simp c.diesn##banc3 [pw=_webal], cluster(SECC2)
est store trend1
reg simp c.diesn [pw=_webal] if banc3==0, cluster(SECC2)
est store trend2
reg simp c.diesn [pw=_webal] if banc3==1, cluster(SECC2)
est store trend3

*Placebo dates
gen placebodata=0
replace placebodata=. if banc3==1
replace placebodata=1 if diesn>=-10
replace placebodata=. if diesn==.
replace placebo=. if diesn>0
reg simp placebodata [pw=_webal], cluster(SECC2)
est store trend4

gen aniv15m=0
replace aniv15=1 if diesn>-8 & diesn<.
reg simp aniv banc3 [pw=_webal], cluster(SECC2)
est store trend5

reg simp aniv  [pw=_webal] if banc3==0, cluster(SECC2)
est store trend6

esttab trend* using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") wide ///
 mtitles collabels(,none) varwidth(20) compress replace
 
*C.3 Gràcia effect 
*Gracia
reg simp banc3##gracia [pw=_webal], cluster(SECC2)
est store gracia
esttab gracia using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") ///
 mtitles collabels(,none) varwidth(20) compress replace

*C.4 Alternative operationalizations of treatment
ebalance banc c.edat1 b4.partisans_pastvote refusals i.sexe lat lon i.DIST , tar(2) gen(webal2)
reg simp banc [pw=webal2], cluster(SECC2)
est store banc1
reg simp i.banc2 [pw=webal2], cluster(SECC2)
est store banc2
esttab banc1 banc2 using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") ///
 mtitles collabels(,none) varwidth(20) compress replace

*C.5 Alternative and placebo outcomes

reg av_simp banc3 [pw=_webal], cluster(SECC2)
est store av
reg anc_simp banc3  [pw=_webal], cluster(SECC2)
est store anc
reg pah_simp banc3 [pw=_webal], cluster(SECC2)
est store pah
reg efipol banc3 [pw=_webal], cluster(SECC2)
est store efipol


esttab av anc pah efipol using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") ///
 mtitles collabels(,none) varwidth(20) compress replace
 
*C.6 Attrition & Non-response

*Attrition
logit know banc3 
est store know_1
logit know banc3 c.indexpolknow c.ideol edat1 sexe i.partisans_past i.DIST
est store know_3
logit know banc3##c.indexpolknow c.ideol edat1 sexe i.partisans_past i.DIST
est store know_4
logit know c.indexpolknow banc3##c.ideol edat1 sexe i.partisans_past i.DIST
est store know_5

esttab know_* using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2_p N, fmt(%9.3f %9.0g) labels("Pseudo-R2" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") ///
 mtitles collabels(,none) varwidth(20) compress replace

*Multiple imputation
use riots_replication_rec.dta
save riots_replication_rec_mi.dta, replace
use "riots_replication_rec_mi.dta", clear

mi set wide
 
*Second step: To register and classify variables (imputed, regulars and passives)
*mi register {imputed | regular | passive} varlist
mi register imputed simp
*Third step : To analyze missing patterns
*mi misstable {summarize|patterns|tree|nested} varlist
mi misstable summarize simp

mi impute logit simp c.edat1 b4.partisans_past ideol i.sexe i.BARR, add(10) nois augment force

*Fifth step: To estimate from imputations
mi estimate, post:  reg simp banc3 
est store mi_1
mi estimate, post:  reg simp banc3 c.edat1 b4.partisans_past ideol i.sexe
est store mi_2
mi estimate, post:  reg simp banc3 c.edat1 b4.partisans_past ideol i.sexe i.DIST
est store mi_3

esttab mi* using "models.tex", cells(b(star fmt(%9.2f)) ///
 se(par)) starlev(* .1 ** .05 *** .01) stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N")) legend ///
 nobaselevels varlabels( _cons "Constant") ///
 mtitles collabels(,none) varwidth(20) compress replace
