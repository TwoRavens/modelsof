*Notes: install sppack, shp2dta, st0243_1

********************
********DATA********
********************

version 11.2

cd "YOUR DIRECTORY HERE/DFGN Replication Files"
clear matrix
clear mata
clear
set more off

*Defines period over which unrest frequency is defined
global start = 1851
global end = 1863
do merge_replication

local vector "distance_moscow goodsoil lnurban lnpopn province_capital"

*********************************
***TABLE 1: SUMMARY STATISTICS***
*********************************

*NOTE: User should manually transfer this output to preferred format to obtain Table 1

sum peasantrep afreq alargefreq atsgaorfreq serfperc religpolar `vector' lnschools_1860 sh_orth if zemstvo == 1
****

preserve
clear
global start = 1851
global end = 1860
do merge_replication
sum afreq if zemstvo == 1
restore


*******************************
**TABLE 2: OLS and IV (serfdom)
*******************************

* (1) Baseline
reg peasantrepresentation_1864 afreq `vector', robust
outreg2 using table2, excel bdec(3) ctitle(OLS) replace

* (2) IV serfdom

ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table2, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Baseline) 
matrix drop A
scalar drop X

* (3) Large events only

ivregress 2sls peasantrepresentation_1864 (alargefreq = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table2, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Large) 
matrix drop A
scalar drop X

* (4) TSGAOR events only  
ivregress 2sls peasantrepresentation_1864 (atsgaorfreq = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table2, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(TsGAOR) 
matrix drop A
scalar drop X

* (5) Events from 1851 to 1860
preserve
clear
global start = 1851
global end = 1860
do merge_replication
 
ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table2, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(1861-1863) 
matrix drop A
scalar drop X 
restore

* (6) Province fixed effects 

xi:ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector' i.province, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table2, excel bdec(3) adec(3) adds(First-stage F-stat, X) drop(_Iprovince* o._Iprovince*) ctitle(Province FEs) 
matrix drop A
scalar drop X 

* (7) Spatial disturbances
preserve
 *spatial model
clear mata
ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector'
keep if e(sample)
save temp, replace
 *break down shapefile
shp2dta using 1897Uezd, database(uezd) coordinates(uezdxy) genid(id) gencentroid(c) replace
 *merge with data
use uezd, clear
merge 1:1 masterid using temp
keep if _m == 3
save "uezd.dta", replace
 *create weighting matrixes
spmat idistance distmat x_c y_c, id(id)
 *spatial error models
spivreg peasantrepresentation_1864 (afreq = serfperc) `vector', id(id) elmat(distmat) het
outreg2 using table2, excel bdec(3) ctitle(Spatial distance) 

restore

* (8) Include schools

ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector' lnschools_1860, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table2, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Schools) 
matrix drop A
scalar drop X


* (9) Reduced-form 

reg peasantrepresentation_1864 serfperc `vector', robust
outreg2 using table2, excel bdec(3) ctitle(OLS)


*****************************************
***Table 3: IV (religious polarization)***
*****************************************

* (1) Baseline
ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Baseline) replace
matrix drop A
scalar drop X

* (2) Large events only  

ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Large) 
matrix drop A
scalar drop X

* (3) TSGAOR events only  
ivregress 2sls peasantrepresentation_1864 (atsgaorfreq = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(TsGAOR) 
matrix drop A
scalar drop X

* (4) Events from 1851 to 1860
preserve
clear
global start = 1851
global end = 1860
do merge_replication    

ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(1851-1860)
matrix drop A
scalar drop X 
restore

* (5) Province fixed effects
*Note: borderline weak-instrument problem 

xi:ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector' i.province, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table3, excel bdec(3) adec(3) adds(First-stage F-stat, X) drop(_Iprovince* o._Iprovince*) ctitle(Province FEs)
matrix drop A
scalar drop X 

* (6) Spatial disturbances
preserve
 *spatial model
clear mata
ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector'
keep if e(sample)
save temp, replace
 *break down shapefile
shp2dta using 1897Uezd, database(uezd) coordinates(uezdxy) genid(id) gencentroid(c) replace
 *merge with data
use uezd, clear
merge 1:1 masterid using temp
keep if _m == 3
save "uezd.dta", replace
 *create weighting matrixes
spmat idistance distmat x_c y_c, id(id)

spivreg peasantrepresentation_1864 (afreq = religpolar) `vector', id(id) elmat(distmat) het
outreg2 using table3, excel bdec(3) ctitle(Spatial distance) 
restore

* (7) Include share Orthodox
 
ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector' sh_orth, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using table3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Orthodox)
matrix drop A
scalar drop X 

*(8) Reduced-form

reg peasantrepresentation_1864 religpolar `vector', robust
outreg2 using table3, excel bdec(3) ctitle(OLS)

*****************************
***Table 4: REDISTRIBUTION***  
*****************************

* (1) Main variable

ivreg2 ch_schools_pc (afreq afreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat)) replace

* (2) Main variable, Cobb-Douglas

ivreg2 redist (afreq afreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))

* (3) Large events only

ivreg2 ch_schools_pc (alargefreq alargefreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat))

* (4) Large events only, Cobb-Douglas

ivreg2 redist (alargefreq alargefreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))

* (5) TsGAOR only

ivreg2 ch_schools_pc (atsgaorfreq atsgaorfreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat))

* (6) TsGAOR only, Cobb-Douglas

ivreg2 redist (atsgaorfreq atsgaorfreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))


* (7) Events from 1851 to 1860
preserve
clear
global start = 1851
global end = 1860
do merge_replication

ivreg2 ch_schools_pc (afreq afreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(Events 1851-60, IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat))

* (8) Events from 1851 to 1860, Cobb-Douglas

ivreg2 redist (afreq afreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using table4, excel bdec(3) ctitle(Events 1851-60, IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))

restore
   
********************
***CASE SELECTION***
********************

*IV first stage
reg afreq serfperc `vector' if zemstvo == 1
predict afreq_ if e(sample)

*Case selection
reg peasantrepresentation_1864 afreq_ `vector'
predict e_regression if e(sample), resid
reg afreq_ `vector'
predict e_afreq_ if e(sample), resid
reg peasantrepresentation_1864 `vector'
predict e_peasantrep if e(sample), resid
gen case = ""
replace case = uezd if abs(e_regression) < 5 & (e_afreq_ > .19 |  e_afreq_ < -.1) & e(sample) ~= .
sort e_afreq_
list province uezd peasantrep afreq afreq_ e_afreq e_regression if case  ~= ""

*AV plot illustrating case selection
twoway (scatter e_peasantrep e_afreq if case == "", mcolor("117 112 179")) (scatter e_peasantrep e_afreq if province == "Kazan", mcolor("27 158 119") mlabel(case) mlabp(9) mlabc("27 158 119")) (scatter e_peasantrep e_afreq if province == "Perm", mcolor("217 95 2") mlabel(case) mlabp(9) mlabc("217 95 2")) (lfit e_peasantrep e_afreq, lcolor("117 112 179")), xlabel(-.1(.1).2) xsc(r(-.17 .2)) xtitle("(Instrumented unrest) | covariates") ytitle("(Peasant representation) | covariates") legend(order(2 3 1) bmargin(medium) label(2 "Kazan") label(3 "Perm") label(1 "Other") pos(1) ring(0) col(1) size(small) subtitle("Province", size(small))) scheme(s1color)
corr e_peasantrep e_afreq
corr e_peasantrep e_afreq if province == "Kazan"
corr e_peasantrep e_afreq if province == "Perm"

drop afreq_ e_* case



********************
***Table A1: 
********************


gen effectivepeasantrep_1864=peasantrepresentation_1864
replace effectivepeasantrep_1864=0 if zemstvo==0

***
preserve 

collapse (mean) zemstvo afreq religpolar serfperc distance_moscow goodsoil lnurban lnpopn province_capital, by(provincenumber)

*(1) 
reg zemstvo afreq `vector', r  
outreg2 using tableA1, excel bdec(3) ctitle(OLS, Selection) replace 

*(2) 
ivreg2 zemstvo (afreq=serfperc) `vector', r  
outreg2 using tableA1, excel bdec(3) ctitle(IV Serfdom, Selection)  adec(3) adds(First-stage F-stat, e(widstat))

*(3) 
ivreg2 zemstvo (afreq=religpolar) `vector', r  
outreg2 using tableA1, excel bdec(3) ctitle(IV Relig. polar., Selection)  adec(3) adds(First-stage F-stat, e(widstat))


restore
***


*(4) 
tobit  effectivepeasantrep_1864 afreq `vector', ll(0) robust
outreg2 using tableA1, excel bdec(3) ctitle(Tobit)  onecol  

*(5) 
ivtobit effectivepeasantrep_1864 (afreq=serfperc) `vector', ll(0) robust
outreg2 using tableA1, excel bdec(3) ctitle(IV Tobit, Serfdom)  onecol

*(6) 
ivtobit  effectivepeasantrep_1864 (afreq=religpolar) `vector', ll(0) robust
outreg2 using tableA1, excel bdec(3) ctitle(IV Tobit, Relig. polar.)  onecol

************************
***Table A2: First-stage
************************

*(1)  
reg afreq serfperc `vector' if zemstvo == 1, robust
outreg2 using tableA2, excel bdec(3) ctitle(Baseline) replace

*(2)
reg alargefreq serfperc `vector' if zemstvo == 1, robust
outreg2 using tableA2, excel bdec(3) ctitle(Large)

*(3)
reg atsgaorfreq serfperc `vector' if zemstvo == 1, robust
outreg2 using tableA2, excel bdec(3) ctitle(TsGAOR)

*(4)
reg afreq serfperc `vector' if zemstvo == 1, robust
outreg2 using tableA2, excel bdec(3) ctitle(1851-1860) 

*(5)
xi:reg afreq serfperc `vector' i.province if zemstvo == 1, robust
outreg2 using tableA2, excel bdec(3) ctitle(Province FEs) 

*(6)
reg afreq serfperc `vector' lnschools_1860 if zemstvo == 1, robust
outreg2 using tableA2, excel bdec(3) ctitle(Schools)


*************************************
***Table A3: Large events, IV serfdom 
*************************************


* (1) Large events only, OLS
reg peasantrepresentation_1864 alargefreq `vector', robust
outreg2 using tableA3, excel bdec(3) ctitle(OLS) replace


* (2) Large events only
ivregress 2sls peasantrepresentation_1864 (alargefreq = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Large) 
matrix drop A
scalar drop X


* (3) TSGAOR events only

ivregress 2sls peasantrepresentation_1864 (atsgaorlargefreq = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(TsGAOR Large) 
matrix drop A
scalar drop X

* (4) Events from 1851 to 1860
preserve
clear
global start = 1851
global end = 1860
do merge_replication

ivregress 2sls peasantrepresentation_1864 (alargefreq = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(1851-1860, Large) 
matrix drop A
scalar drop X 
restore

* (5) Province fixed effects
 
xi:ivregress 2sls peasantrepresentation_1864 (alargefreq = serfperc) `vector' i.province, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA3, excel bdec(3) adec(3) adds(First-stage F-stat, X) drop(_Iprovince* o._Iprovince*) ctitle(Province FEs) 
matrix drop A
scalar drop X 

* (6) Spatial disturbances
preserve
 *spatial model
clear mata
ivregress 2sls peasantrepresentation_1864 (alargefreq = serfperc) `vector'
keep if e(sample)
save temp, replace
 *break down shapefile
shp2dta using 1897Uezd, database(uezd) coordinates(uezdxy) genid(id) gencentroid(c) replace
 *merge with data
use uezd, clear
merge 1:1 masterid using temp
keep if _m == 3
save "uezd.dta", replace
 *create weighting matrixes
spmat idistance distmat x_c y_c, id(id)
 *spatial error models
spivreg peasantrepresentation_1864 (alargefreq = serfperc) `vector', id(id) elmat(distmat) het
outreg2 using tableA3, excel bdec(3) ctitle(Spatial distance)

restore

* (7) Include schools
corr schools_1860_pc serfperc if zemstvo == 1
ivregress 2sls peasantrepresentation_1864 (alargefreq = serfperc) `vector' lnschools_1860, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA3, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Schools) 
matrix drop A
scalar drop X


*******************************************
***Table A4: Additional results, IV serfdom 
*******************************************

*Intensity
ivregress 2sls peasantrepresentation_1864 (atot_pc = serfperc) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA4, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Intensity)  replace
matrix drop A
scalar drop X


* Spatial disturbances
preserve
 *spatial model
clear mata
ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector'
keep if e(sample)
save temp, replace
 *break down shapefile
shp2dta using 1897Uezd, database(uezd) coordinates(uezdxy) genid(id) gencentroid(c) replace
 *merge with data
use uezd, clear
merge 1:1 masterid using temp
keep if _m == 3
save "uezd.dta", replace
 *create weighting matrixes
spmat contiguity contigmat using uezdxy, id(id)

spivreg peasantrepresentation_1864 (afreq = serfperc) `vector', id(id) elmat(contigmat) het
outreg2 using tableA4, excel bdec(3) ctitle(Spatial contig) 
restore

*Lat/long controls
ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector' latitude latitude2 longitude longitude2, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA4, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Lat/long) 
matrix drop A
scalar drop X

*Exclude Moscow and St. Petersburg
ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector' if masterid ~= 204 & masterid ~= 339, robust first
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA4, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Mos/StP) 
matrix drop A
scalar drop X

*Control for Emancipation land norms
reg afreq serfperc `vector' landnorm_high if zemstvo == 1, robust
outreg2 using table_SERFPERC_1stSTAGE, excel bdec(3) ctitle(Baseline) replace
ivregress 2sls peasantrepresentation_1864 (afreq = serfperc) `vector' landnorm_high, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA4, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Land norms) 
matrix drop A
scalar drop X


*****************************************
***Table A5: Additional robustness checks
*****************************************


*(1,2) Time weighted


ivregress 2sls peasantrepresentation_1864 (tweight_afreq = serfperc) `vector' , robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA5, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(IV Serfdom, Time-weighted) replace
matrix drop A
scalar drop X

ivregress 2sls peasantrepresentation_1864 (tweight_afreq = religpolar) `vector' , robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA5, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(IV Relig. Polar., Time-weighted) 
matrix drop A
scalar drop X

*(3,4) Nonzero


ivregress 2sls peasantrepresentation_1864 (afreq  = serfperc) `vector' if afreq>0, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA5, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(IV Serfdom, Nonzero) 
matrix drop A
scalar drop X    

ivregress 2sls peasantrepresentation_1864 (afreq  = religpolar) `vector' if afreq>0, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA5, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(IV Relig. Polar., Nonzero) 
matrix drop A
scalar drop X     

* (5) Quadratic

gen sq_afreq=afreq^2
gen sq_serfperc=serfperc^2
gen sq_religpolar=religpolar^2

*reg peasantrepresentation_1864 afreq sq_afreq `vector', robust
*outreg2 using table_MOREROBUST_SERFPERC, excel bdec(3) ctitle(OLS, Quadratic form)

ivreg2 peasantrepresentation_1864 (afreq sq_afreq = serfperc sq_serfperc) `vector' , robust
outreg2 using tableA5, excel bdec(3) adec(3) adds(First-stage F-stat, e(widstat)) ctitle(IV Serfdom, Quadratic form) 




*(6) Obrok share

replace obrokshare=. if obrokshare==-99

*reg peasantrepresentation_1864 afreq `vector' obrokshare, robust
*outreg2 using table_MOREROBUST_SERFPERC, excel bdec(3) ctitle(OLS, Obrok share) 

ivregress 2sls peasantrepresentation_1864 (afreq  = serfperc) `vector' obrokshare, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA5, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(IV Serfdom, Obrok share) 
matrix drop A
scalar drop X


**************************************
***Table A6: Accounting for rye prices
**************************************
             

*(1)

bootstrap, reps(500) seed(10101): ivreg2 peasantrepresentation_1864 (aresid_ryeprobitfreq=serfperc) `vector' if zemstvo==1
outreg2 using tableA6, excel bdec(3) ctitle(IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat)) replace

*(2)
bootstrap, reps(500) seed(10101): ivreg2 peasantrepresentation_1864 (aresid_ryeprobitfreq=religpolar) `vector' if zemstvo==1
outreg2 using tableA6, excel bdec(3) ctitle(IV Relig. polar.) adec(3) adds(First-stage F-stat, e(widstat))


*(3)
bootstrap, reps(500) seed(10101): ivreg2 peasantrepresentation_1864 (aresid_ryeprobitfreq=serfperc) `vector' if latitude>=50 & zemstvo==1
outreg2 using tableA6, excel bdec(3) ctitle(IV Serfdom, No southern latitudes) adec(3) adds(First-stage F-stat, e(widstat))

*(4)
bootstrap, reps(500) seed(10101): ivreg2 peasantrepresentation_1864 (aresid_ryeprobitfreq=religpolar) `vector' if latitude>=50 & zemstvo==1
outreg2 using tableA6, excel bdec(3) ctitle(IV Relig. polar, No southern latitudes) adec(3) adds(First-stage F-stat, e(widstat))



***************************************
***Table A7: First-stage, relig. polar.
***************************************
*(1)
reg afreq religpolar `vector' if zemstvo == 1, robust
outreg2 using tableA7, excel bdec(3) ctitle(Baseline) replace 

*(2)
reg alargefreq religpolar `vector' if zemstvo == 1, robust
outreg2 using tableA7, excel bdec(3) ctitle(Large)

*(3)
reg atsgaorfreq religpolar `vector' if zemstvo == 1, robust
outreg2 using tableA7, excel bdec(3) ctitle(TsGAOR)

*(4)
reg afreq religpolar `vector' if zemstvo == 1, robust
outreg2 using tableA7, excel bdec(3) ctitle(1851-1860) 

*(5)
xi:reg afreq religpolar `vector' i.province if zemstvo == 1, robust
outreg2 using tableA7, excel bdec(3) ctitle(Province FEs) 

*(6)
reg afreq religpolar `vector' sh_orth if zemstvo == 1, robust
outreg2 using tableA7, excel bdec(3) ctitle(Share Orthodox) 

*******************************************
***Table A8: Large events, IV relig. polar.
*******************************************
 
* (1) Large events only
ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA8, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Large) replace
matrix drop A
scalar drop X

* (2) TSGAOR events only

ivregress 2sls peasantrepresentation_1864 (atsgaorlargefreq = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA8, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(TsGAOR Large) 
matrix drop A
scalar drop X

* (3) Events from 1851 to 1860
preserve
clear
global start = 1851
global end = 1860
do merge_replication
sum afreq

* (4)
ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA8, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(1851-1860, Large)
matrix drop A
scalar drop X 
restore

* (5) Province fixed effects
*Note:  weak-instrument problem

xi:ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector' i.province, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA8, excel bdec(3) adec(3) adds(First-stage F-stat, X) drop(_Iprovince* o._Iprovince*) ctitle(Province FEs)
matrix drop A
scalar drop X 

* (6) Spatial disturbances
preserve
 *spatial model
clear mata
ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector'
keep if e(sample)
save temp, replace
 *break down shapefile
shp2dta using 1897Uezd, database(uezd) coordinates(uezdxy) genid(id) gencentroid(c) replace
 *merge with data
use uezd, clear
merge 1:1 masterid using temp
keep if _m == 3
save "uezd.dta", replace
 *create weighting matrixes
spmat idistance distmat x_c y_c, id(id)

 *spatial error models
spivreg peasantrepresentation_1864 (alargefreq = religpolar) `vector', id(id) elmat(distmat) het
outreg2 using tableA8, excel bdec(3) ctitle(Spatial distance) 

restore

* (7) Include share Orthodox
corr religpolar sh_orth if zemstvo == 1

ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector' sh_orth, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA8, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Orthodox)
matrix drop A
scalar drop X 
*robust to using share of largest religious minority
ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector' sh_largestreligminority, robust


*************************************************
***Table A9: Additional results, IV relig. polar.
*************************************************


* (1)
*Intensity
ivregress 2sls peasantrepresentation_1864 (atot_pc = religpolar) `vector', robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA9, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Intensity) replace
matrix drop A
scalar drop X 


* (2) Spatial disturbances
preserve
 *spatial model
clear mata
ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector'
keep if e(sample)
save temp, replace
 *break down shapefile
shp2dta using 1897Uezd, database(uezd) coordinates(uezdxy) genid(id) gencentroid(c) replace
 *merge with data
use uezd, clear
merge 1:1 masterid using temp
keep if _m == 3
save "uezd.dta", replace
 *create weighting matrixes
*spmat idistance distmat x_c y_c, id(id)
spmat contiguity contigmat using uezdxy, id(id)
 *spatial error models
*spivreg peasantrepresentation_1864 (afreq = religpolar) `vector', id(id) elmat(distmat) het
*outreg2 using table_OLS_RELIGPOLAR, excel bdec(3) ctitle(Spatial distance) 
spivreg peasantrepresentation_1864 (afreq = religpolar) `vector', id(id) elmat(contigmat) het
outreg2 using tableA9, excel bdec(3) ctitle(Spatial contig) 
restore

* (3) Lat/long controls
ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector' latitude latitude2 longitude longitude2, robust
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA9, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Lat/long)
matrix drop A
scalar drop X 

* (4) Exclude Moscow and St. Petersburg
ivregress 2sls peasantrepresentation_1864 (afreq = religpolar) `vector' if masterid ~= 204 & masterid ~= 339, robust first
estat firststage
matrix A = r(singleresults)
scalar X = A[1,4]
outreg2 using tableA9, excel bdec(3) adec(3) adds(First-stage F-stat, X) ctitle(Mos/StP)
matrix drop A
scalar drop X 


******************************************
***Table A10: Overidentification tests
******************************************



* (1)
ivreg2 peasantrepresentation_1864 (afreq = serfperc religpolar) `vector', robust
outreg2 using tableA10, excel bdec(3) adec(3) adds(First-stage F-stat, e(widstat), Hansen J statistic, e(j), p-value, e(jp)) ctitle(Main) replace

* (2)
ivreg2 peasantrepresentation_1864 (alargefreq = serfperc religpolar) `vector', robust
outreg2 using tableA10, excel bdec(3) adec(3) adds(First-stage F-stat, e(widstat), Hansen J statistic, e(j), p-value, e(jp)) ctitle(Large events)

* (3)
ivreg2 peasantrepresentation_1864 (atsgaorfreq = serfperc religpolar) `vector', robust
outreg2 using tableA10, excel bdec(3) adec(3) adds(First-stage F-stat, e(widstat), Hansen J statistic, e(j), p-value, e(jp)) ctitle(TsGAOR only)

* (4)
preserve
clear
global start = 1851
global end = 1860
do merge_replication
sum afreq
ivreg2 peasantrepresentation_1864 (afreq = serfperc religpolar) `vector', robust
outreg2 using tableA10, excel bdec(3) adec(3) adds(First-stage F-stat, e(widstat), Hansen J statistic, e(j), p-value, e(jp)) ctitle(1851-1860)

restore

* (5)
xi: ivreg2 peasantrepresentation_1864 (afreq = serfperc religpolar) `vector' i.province, robust
outreg2 using tableA10, excel bdec(3) adec(3) adds(First-stage F-stat, e(widstat), Hansen J statistic, e(j), p-value, e(jp)) drop(_Iprovince* o._Iprovince*) ctitle(Province FE)

* (6)
preserve
 *spatial model
clear mata
ivregress 2sls peasantrepresentation_1864 (afreq = serfperc religpolar) `vector'
keep if e(sample)
save temp, replace
 *break down shapefile
shp2dta using 1897Uezd, database(uezd) coordinates(uezdxy) genid(id) gencentroid(c) replace
 *merge with data
use uezd, clear
merge 1:1 masterid using temp
keep if _m == 3
save "uezd.dta", replace
 *create weighting matrixes
spmat idistance distmat x_c y_c, id(id)
*spmat contiguity contigmat using uezdxy, id(id)
 *spatial error models
spivreg peasantrepresentation_1864 (afreq = serfperc1 religpolar) `vector', id(id) elmat(distmat) het
outreg2 using tableA10, excel bdec(3) ctitle(Spatial distance)

restore

*************************************************************
***Table A11: Unrest and redistribution, Additional results I
*************************************************************
		 
drop redist

* (1)
gen redist = ((1-.10)/.10)*(schools_1880/(rural_late/1000)) + (schools_1880-schools_1860)/(rural_late/1000)
ivreg2 redist (afreq afreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
sum redist if e(sample)
outreg2 using tableA11, excel bdec(3) ctitle(Serf, alpha = .10) adec(3) adds(First-stage F-stat, e(widstat)) replace
drop redist

* (2)
gen redist = ((1-.50)/.50)*(schools_1880/(rural_late/1000)) + (schools_1880-schools_1860)/(rural_late/1000)
ivreg2 redist (afreq afreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
sum redist if e(sample)
outreg2 using tableA11, excel bdec(3) ctitle(Serf, alpha = .50) adec(3) adds(First-stage F-stat, e(widstat))
drop redist

* (3)
ivreg2 ch_schools_pc (afreq afreq_nozem = religpolar relig_nozem) nozemstvo `vector', robust
outreg2 using tableA11, excel bdec(3) ctitle(IV Relig. polar.) adec(3) adds(First-stage F-stat, e(widstat)) 

* (4,5,6)
foreach i of numlist .10 .25 .50 {
gen redist = ((1-`i')/`i')*(schools_1880/(rural_late/1000)) + (schools_1880-schools_1860)/(rural_late/1000)
ivreg2 redist (afreq afreq_nozem = religpolar relig_nozem) nozemstvo `vector', robust
outreg2 using tableA11, excel bdec(3) ctitle(Religion, alpha = `i') adec(3) adds(First-stage F-stat, e(widstat))
drop redist
}


**************************************************************
***Table A12: Unrest and redistribution, Additional results II
**************************************************************

******Robustness to droppiong non-zemstvo districts outside of Ukraine, Belorussia, and Baltics
preserve
drop if province == "Orenburg" | province == "Astrakhan" | province == "Arkhangel'sk" | uezd == "Ismail'skii"
gen redist = ((1-.25)/.25)*(schools_1880/(rural_late/1000)) + (schools_1880-schools_1860)/(rural_late/1000)


* (1 and 2) Main variable

ivreg2 ch_schools_pc (afreq afreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat)) replace

ivreg2 redist (afreq afreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))

* (3 and 4) Large events only

ivreg2 ch_schools_pc (alargefreq alargefreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat))

ivreg2 redist (alargefreq alargefreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))

* (5 and 6) TsGAOR only

ivreg2 ch_schools_pc (atsgaorfreq atsgaorfreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat))

ivreg2 redist (atsgaorfreq atsgaorfreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))


* (7 and 8) Events from 1851 to 1860
restore, preserve
clear
global start = 1851
global end = 1860
do merge_replication
sum afreq
drop if province == "Orenburg" | province == "Astrakhan" | province == "Arkhangel'sk" | uezd == "Ismail'skii"

ivreg2 ch_schools_pc (afreq afreq_nozem = serfperc1 serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(Events 1851-60, IV Serfdom) adec(3) adds(First-stage F-stat, e(widstat))

ivreg2 redist (afreq afreq_nozem = serfperc serf_nozem) nozemstvo `vector', robust
outreg2 using tableA12, excel bdec(3) ctitle(Events 1851-60, IV Serfdom, alpha = .25) adec(3) adds(First-stage F-stat, e(widstat))

restore

********************************
*RESULTS REFERENCED IN FOOTNOTES
********************************

*robust to using share of largest religious minority
ivregress 2sls peasantrepresentation_1864 (alargefreq = religpolar) `vector' sh_largestreligminority, robust

*No explanatory power in first-stage
ivregress 2sls peasantrepresentation_1864 (afreq sq_afreq = religpolar sq_religpolar) `vector' , robust

*robust to using polarization instrument
ivregress 2sls peasantrepresentation_1864 (afreq  = religpolar) `vector' obrokshare, robust

*Reduced-form with both instruments
reg peasantrepresentation_1864 serfperc religpolar `vector' if zemstvo==1, robust




******************
******************
