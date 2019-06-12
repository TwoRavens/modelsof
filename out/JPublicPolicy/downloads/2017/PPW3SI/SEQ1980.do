

******************************************************************************
*                                                                            *
*   	       Computation of Spatial Lags based on Commuting Data           *
*                                                                            *
*                                                                            *
******************************************************************************
//////////////////////////////////////////////////////////////////////////////

clear

use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Datasets/Dataset_final.dta"
levelsof bfs_nr
global bfs_nr=r(levels)
clear

******************************************************************************
*                                                                            *
*       Loading Individual Commuting Data & Generating Job Categories        *
*                                                                            *
******************************************************************************
* As a basis for computation of similarity of municipal out-commuting patterns
*
* Source: National Census 1970, 1980, 1990, 2000 (Federal Statistical Office)

local sample 1970 1980 1990 2000

foreach x in `sample' {
* Load Census raw data
clear
import delimited using "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/VZ_`x'.csv", delimiter(";")
* This is vital for future understanding(!)
rena zgde ResMun
rena agde WorMun
lab var ResMun "Municipality the surveyed individual lives in"
lab var WorMun "Municipality the surveyed individual works in"

* Drop observations of individuals who are not part of the working population
* or who do not chose their place of residence themselves, i.e. apprentice, 
* retiree and other people not working

drop if ams==13 /* Apprentices */
drop if ams==4 /* People under age of 15 */
drop if ams==40 /* People under age of 15 */
drop if ams==34 /* Retiree */
drop if ams==35 /* other people not working*/

* Drop if question for "place of work" is not answered or "unknown"
drop if WorMun==9999 | WorMun==0

* Drop those observations who are working in their municipality of residence
* -> contain no information for out-commuting patterns
drop if WorMun==ResMun

* Generate 20 rough job categories, based on type of job and necessary level 
* of education

drop if wart==0 & wart==999
gen jc=0
replace jc=1 if wart<100 
/* Gardening, forestry & fishery */
replace jc=2 if wart==110 
/* Energy & water supply */
replace jc=3 if wart>210 & wart<231 
/* Production of food, drinks & tabacco */
replace jc=4 if wart>240 & wart<256 
/* Production of textiles */
replace jc=5 if wart>260 & wart<273 
/* Production of wooden goods */
replace jc=6 if wart==280 | wart==350 | wart==371 | wart==372 
/* Production of machinery, watches, jewelry and publishing */
replace jc=7 if wart>290 & wart<312 /* Production of leather goods, shoes & chemicals */
replace jc=8 if wart>313 & wart<346 
/* Oil industry, production of synthetics, ceramics, glas & hardware */
replace jc=9 if wart>380 & wart<385
/* Production of mucial instruments, toy and sports equipment, goods for photography */
replace jc=10 if wart>409 & wart<424
/* Construction industry, building services, electric installations */ 
replace jc=11 if wart>510 & wart<518 | wart==519
/* Retail business (foods, textiles, pharmacy, cars, funiture aso.) */
replace jc=12 if wart==518 | wart==831 | wart==833
/* Retail business (fine mechanics, electronics) & medical facilities */
replace jc=13 if wart>760 & wart<764
/* Washery, coiffeur, cleaning businesses */
replace jc=14 if wart==580 | wart==840 | wart==912
/* Reparation, waste disposal, prison regimes */
replace jc=15 if wart>609 & wart<653
/* Pulic transport (train, plain, bus) */
replace jc=16 if wart==660 | wart>809 & wart<821 | wart==886 | wart==911
/* News agencies, educational system, civil service */
replace jc=17 if wart>709 & wart<754
/* Finance, insurances, real estate, legal, trust */
replace jc=18 if wart==570 | wart==890
/* Gastronomy & facility management */
replace jc=19 if wart==851 | wart>880 & wart<883
/* Retirement and other homes, cultural institutions, arts */
replace jc=20 if wart>854 & wart<871
/* Public welfare institutions, churches, monastery */


order WorMun, after(ResMun)
keep zjhr ResMun WorMun wart jc wseko avemi 

save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters`x'raw.dta", replace

levelsof jc
global jc=r(levels)

clear

* For each job category, generate dataset with number of workers commuting from
* Zurich municipality a to other municipalites b

foreach z in $jc {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters`x'raw.dta"
keep if jc==`z'
 
* Collapse to number of individuals living in "ResMun" & working in "WorMun"
gen WorMun_nr=1
collapse (count) WorMun_nr, by(ResMun WorMun)

* Drop all other cantons
drop if ResMun>=300

gen cs=`x'
order cs, after(ResMun)
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters_`x'_jc`z'.dta", replace

clear
}
}

******************************************************************************
*                                                                            *
*                          Imputation of Missing Years                       *
*                                                                            *
******************************************************************************

clear

foreach x in $jc {

clear
gen ResMun=0
gen WorMun=0
gen WorMun_sh=0
gen WorMun_nr=0
gen cs=0
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/CommutersPanel_jc`x'.dta",replace
clear

use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters_1970_jc`x'.dta"
append using "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters_1980_jc`x'.dta"
append using "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters_1990_jc`x'.dta"
append using "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters_2000_jc`x'.dta"

* Recode cs for simpler imputation
recode cs 1970=1 1980=11 1990=21 2000=31

sort ResMun cs WorMun
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters_jc`x'.dta", replace

* Linear imputation

foreach z in $bfs_nr {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/Commuters_jc`x'.dta"

drop if ResMun!=`z'

* Generate cs for those jc, years & municipalities for which no workers are observed
local cs 1 11 21 31
levels cs, local(ncs)
local gen: list cs- ncs
di `gen'

sum cs
local obs=`r(N)'
local e=`obs'+1
set obs `=_N+1'
replace cs=999 in `e'

sort cs
reshape wide WorMun_nr, i(WorMun) j(cs)

foreach u in `gen' {
gen WorMun_nr`u'=0
}
drop WorMun_nr999
recode WorMun_nr1 .=0
recode WorMun_nr11 .=0
recode WorMun_nr21 .=0
recode WorMun_nr31 .=0

gen diff1=WorMun_nr11-WorMun_nr1
gen diff2=WorMun_nr21-WorMun_nr11
gen diff3=WorMun_nr31-WorMun_nr21

order diff1 diff2 diff3, after(WorMun_nr31)

* Generate missing years
foreach y in 2 3 4 5 6 7 8 9 10 12 13 14 15 16 17 18 19 20 22 23 24 25 26 27 28 29 30 32 33 34 35 36 37 38 39 40 41 42 {
gen WorMun_nr`y'=0
}
* Impute missing years
forval v=2/10{
local y=`v'-1
replace WorMun_nr`v'=WorMun_nr`y'+(diff1/10)
}
forval v=12/20{
local y=`v'-1
replace WorMun_nr`v'=WorMun_nr`y'+(diff2/10)
}
forval v=22/30{
local y=`v'-1
replace WorMun_nr`v'=WorMun_nr`y'+(diff3/10)
}
* Impute 2001-2012 linearly from diff1990-2000
forval v=32/42{
local y=`v'-1
replace WorMun_nr`v'=WorMun_nr`y'+(diff3/10)
}
drop diff1 diff2 diff3 ResMun

reshape long WorMun_nr, i(WorMun) j(cs)

* Recode if linear imputation of 2000-2012 resulted in negative values
replace WorMun_nr=0 if WorMun_nr<0

* Round to "whole" humans
gen WorMun_Nr=round(WorMun_nr,1)
drop WorMun_nr

* Compute for each cs the share of total workers commuting to each working
* municipality
egen sum=sum(WorMun_Nr), by (cs)
gen WorMun_sh=WorMun_Nr*100/sum
recode WorMun_sh .=0
gen WorMun_Sh=round(WorMun_sh,.01)
drop WorMun_sh
rena WorMun_Sh WorMun_sh

gen ResMun=`z'
order ResMun WorMun cs
sort ResMun WorMun cs

save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/temp/mun`z'_jc`x'.dta", replace
clear
}
foreach z in $bfs_nr {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/CommutersPanel_jc`x'.dta"
append using "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/temp/mun`z'_jc`x'.dta"

save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/CommutersPanel_jc`x'.dta", replace
}
clear
}


******************************************************************************
*                                                                            *
*       Computation of Matrices of Out-Commuting Pattern Similarity          *
*                                                                            *
******************************************************************************
* For each job category, a simple correlation of out-commuting patterns of all
* municipalities is calculated. This correlation captures the similarity of 
* work places of workers (in the same job category) living in each pair of 
* municipality

clear 

foreach x in $jc {
forval y=11/42 {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/CommutersPanel_jc`x'.dta"

drop if WorMun==.
* Reduce data to single cross-section, working municipality & share of workers
* in job category jc`x' working there
drop if cs!=`y'
drop cs WorMun_Nr sum

* Add zero observations for each municipality "ResMun" in the canton nobody in job
* category jc`x' is living in
levels ResMun, local(a)
di `a'
local tot $bfs_nr
di `tot'
local miss: list tot- a
di `miss'

reshape wide WorMun_sh, i(WorMun) j(ResMun)
foreach z in `miss' {
gen WorMun_sh`z'=0
}

reshape long WorMun_sh, i(WorMun) j(ResMun)
order ResMun WorMun
recode WorMun_sh miss=0

* Add zero observations for each municipality "WorMun" in the canton nobody in job
* category jc`x' is working in
levels WorMun, local(b)
local miss2: list tot- b
di `miss2'
reshape wide WorMun_sh, i(ResMun) j(WorMun)
foreach z in `miss2' {
gen WorMun_sh`z'=0
}

order _all, sequential
order ResMun
* Now for each municipality "ResMun", dataset contains complete list of shares of
* workers in job category `y' are commuting to which municipality "WorMun" (both
* in the canton and in other cantons)

* sxpose swaps x- & y-axes -> municipalities "ResMun" are now in rows, and "WorMun"
* in columns
sxpose, force clear
order _all, sequential
foreach var of varlist * {
  destring `var', replace
  recode `var' miss=0
  gen `var'_2=round(`var',.01)
  drop `var'
  rena `var'_2 `var'
}
drop if _n==1
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/temp/WorMun_sh_`y'_jc`x'", replace

* For each row and thus "ResMun", calculate Pearson correlation with each other
* row & thus correlation of shares of workers in job category jc`x' commuting
* to all other municipalities in the sample. The command "correlate" codes 
* "ResMun" from which nobody in job category `x' is commuting to  another *
* municipality as missings
correlate

* Store correlations in a matrix
mat CommCorr`y'_jc`x'=r(C)

* Store correlations in a dataset and recode missings (i.e. mun. with no workers
* working in respective jc)
drop _var1-_var171
svmat CommCorr`y'_jc`x'
foreach var of varlist * {
recode `var' miss=0
}

* Store final correlation matrices
mkmat _all, matrix(CommCorr`y'_jc`x')

save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Weighted/CommCorr`y'_jc`x'_uw.dta", replace
clear
}
}

/* If already calculated (computationally intensive):
foreach x in $jc {
forval y=11/42 {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Weighted/CommCorr`y'_jc`x'_uw.dta"
mkmat _all, matrix(CommCorr`y'_jc`x')
}
}
*/
******************************************************************************
*                                                                            *
*                      Computation of Job Category Shares                    *
*                                                                            *
******************************************************************************
* The share of workers working in each of the 20 job categories will be used
* for weighting the correlations of out-commuting patterns according to the 
* relevance of each job category for the respective "ResMun" and thus refine
* the measure of out-commuting similarity

clear

* For each job category, cross-section and municipality, save sums of workers
* into a single matrix
foreach x in $jc {
mat JC`x'sums=J(33,261,0)
forval y=11/42 {
foreach z in $bfs_nr {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/CommutersPanel_jc`x'.dta"
keep if cs==`y'
keep if ResMun==`z'
local u=`y'-10
mat JC`x'sums[`u',`z']=sum[1]
clear
}
}
svmat JC`x'sums
foreach var of varlist * {
  recode `var' miss=0 
}
mkmat _all, matrix(JC`x'sums)
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/temp2/JC`x'sums.dta", replace
clear
}

* Sum sums of workers in each job category to total out-commuting workers for each
* municipality and cross-section
mat Sums_tot=J(33,261,0)
forval y=11/42 {
foreach z in $bfs_nr {
local u=`y'-10
mat Sums_tot[`u',`z']= JC1sums[`u',`z'] + JC2sums[`u',`z'] + JC3sums[`u',`z'] /*
*/+ JC4sums[`u',`z'] + JC5sums[`u',`z'] + JC6sums[`u',`z'] + JC7sums[`u',`z'] /*
*/+ JC8sums[`u',`z'] + JC9sums[`u',`z'] + JC10sums[`u',`z'] + JC11sums[`u',`z'] /*
*/+ JC12sums[`u',`z'] + JC13sums[`u',`z'] + JC14sums[`u',`z'] + JC15sums[`u',`z'] /*
*/+ JC16sums[`u',`z'] + JC17sums[`u',`z'] + JC18sums[`u',`z'] + JC19sums[`u',`z'] /*
*/+ JC20sums[`u',`z']
}
}

svmat Sums_tot
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/temp2/Sums_tot.dta", replace
clear

* For each municipality and cross-section, calculate share of commuting workers
* working in each category
foreach x in $jc {
mat JC`x'shares=J(33,261,0)
forval y=11/42 {
foreach z in $bfs_nr {
local u=`y'-10
mat JC`x'shares[`u',`z']=(JC`x'sums[`u',`z']*100) / Sums_tot[`u',`z']
}
}
}

******************************************************************************
*                                                                            *
*         Weighting Correlation Matrices Based on Job Category Shares        *
*                                                                            *
******************************************************************************
* Weighting of the correlation matrices of out-commuting similarity reached in 
* the 20 job categories.
*
* Main ideas: 
* 1.: The more similar two municipalities' shares of workers working in a  
* specific job category are, the more the similarity of out-commuting patterns  
* of workers in this category should count for the "overall" similarity 
* of out-commuting patterns
* -> (1 - abs((jc`x'shares[`v',`z']/100) - (jc`x'shares[`v',`u']/100)))/20
* -> the smaller the difference in shares working in job category jc`x', the higher
*    the correlation of this job category's out-commuting patterns is weighted
*
* 2.: The higher the shares of worker working in a specific job category as com-
* pared to all other categories are, the more the similarity of out-commuting 
* patterns of workers in this category should count for the "overall" similarity
* of out-commuting patterns
* -> (((jc`x'shares[`v',`z']/100)+(jc`x'shares[`v',`u']/100))/2)
* -> the equation in (1.) is multiplied by the above, i.e. the average of the 
*    shares of workers working in job category jc`x' in the pair of municipalities
*
* Intuition: If in a pair of municipalities most people work in the financial sector,
* the correlation of the out-commuting pattern of people working in this job
* category is weighted higher than that of other categories because
* a) a similar share of workers living in these municipalities work in the 
*    financial sector 
*    -> which underlines the similarity of those municipalities
* b) a high share of workers work in the financial sector as compared to all other 
*    job categories  
*    -> which underlines the importance of the out-commuting pattern of workers 
*    working in this category as compared to those of people working in other 
*    categories

* Compute weightings and save into matrices & datasets (since quite computation heavy)
foreach x in $jc {
forval y=11/42 {
local v=`y'-10
mat Cs`y'_jc`x'_wg=J(261,261,0)
foreach z in $bfs_nr {
foreach u in $bfs_nr {
mat Cs`y'_jc`x'_wg[`z',`u']= (1 - /*
*/ abs((JC`x'shares[`v',`z']/100) - (JC`x'shares[`v',`u']/100)))/20 * /*
*/ (((JC`x'shares[`v',`z']/100)+(JC`x'shares[`v',`u']/100))/2)
}
}


* "Boil down" to 171x171-matrix (i.e. delete empty variables/observations)
* Drop all rows and columbs that are empty because of non-numerical bfs_nrs
* -> unbfs contains number of all rows and columns which have to be deleted to 
*    transform data to 171x171 matrices
clear
insheet using "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/bfs-num-diff2.csv", delimiter(";")
levelsof unbfs, local(unbfs)
di `unbfs'
global unbfs `unbfs'
di $unbfs

svmat Cs`y'_jc`x'_wg
foreach z in $unbfs {
drop Cs`y'_jc`x'_wg`z'
}

* drop empty rows
foreach a in 15 15 15 15 15 15 39 39 39 39 39 39 61 61 61 61 61 61 61 61 83 /*
*/ 83 83 83 83 83 83 83 94 94 94 94 94 94 94 94 94 106 106 106 106 106 106 106 /*
*/ 106 117 117 117 117 117 117 117 117 117 129 129 129 129 129 129 129 129 139 /*
*/ 139 139 139 139 139 139 139 139 139 160 160 160 160 160 160 160 160 160 171 /*
*/ 171 171 171 171 171 171 171 171 {
drop if _n==`a'
}
drop unbfs
mkmat _all, matrix(Cs`y'_jc`x'_wgUnbfs)

save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/temp2/Cs`y'_jc`x'_wg.dta", replace
clear
}
}

/* if loading from stored datasets
foreach x in $jc {
forval y=20/42 {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Pendler/temp2/Cs`y'_jc`x'_wg"
mkmat _all, matrix(Cs`y'_jc`x'_wg)
clear
}
}
*/

* Multiply correlations with weightings to single 171x171 matrix of 
* out-commuting similarity for each pair of municipalities and cross-section

forval y=11/42 {
mat CommCorr`y'wgUnbfs=J(171,171,0)
}
forval y=11/42 {
forval i=1/171 {
	forval j=1/171{
mat CommCorr`y'wgUnbfs[`i',`j']=(((Cs`y'_jc1_wgUnbfs[`i',`j']) * CommCorr`y'_jc1[`i',`j'])+/*
*/((Cs`y'_jc2_wgUnbfs[`i',`j']) * CommCorr`y'_jc2[`i',`j'])+/*
*/((Cs`y'_jc3_wgUnbfs[`i',`j']) * CommCorr`y'_jc3[`i',`j'])+/*
*/((Cs`y'_jc4_wgUnbfs[`i',`j']) * CommCorr`y'_jc4[`i',`j'])+/*
*/((Cs`y'_jc5_wgUnbfs[`i',`j']) * CommCorr`y'_jc5[`i',`j'])+/*
*/((Cs`y'_jc6_wgUnbfs[`i',`j']) * CommCorr`y'_jc6[`i',`j'])+/*
*/((Cs`y'_jc7_wgUnbfs[`i',`j']) * CommCorr`y'_jc7[`i',`j'])+/*
*/((Cs`y'_jc8_wgUnbfs[`i',`j']) * CommCorr`y'_jc8[`i',`j'])+/*
*/((Cs`y'_jc9_wgUnbfs[`i',`j']) * CommCorr`y'_jc9[`i',`j'])+/*
*/((Cs`y'_jc10_wgUnbfs[`i',`j']) * CommCorr`y'_jc10[`i',`j'])+/*
*/((Cs`y'_jc11_wgUnbfs[`i',`j']) * CommCorr`y'_jc11[`i',`j'])+/*
*/((Cs`y'_jc12_wgUnbfs[`i',`j']) * CommCorr`y'_jc12[`i',`j'])+/*
*/((Cs`y'_jc13_wgUnbfs[`i',`j']) * CommCorr`y'_jc13[`i',`j'])+/*
*/((Cs`y'_jc14_wgUnbfs[`i',`j']) * CommCorr`y'_jc14[`i',`j'])+/*
*/((Cs`y'_jc15_wgUnbfs[`i',`j']) * CommCorr`y'_jc15[`i',`j'])+/*
*/((Cs`y'_jc16_wgUnbfs[`i',`j']) * CommCorr`y'_jc16[`i',`j'])+/*
*/((Cs`y'_jc17_wgUnbfs[`i',`j']) * CommCorr`y'_jc17[`i',`j'])+/*
*/((Cs`y'_jc18_wgUnbfs[`i',`j']) * CommCorr`y'_jc18[`i',`j'])+/*
*/((Cs`y'_jc19_wgUnbfs[`i',`j']) * CommCorr`y'_jc19[`i',`j'])+/*
*/((Cs`y'_jc20_wgUnbfs[`i',`j']) * CommCorr`y'_jc20[`i',`j'])) 
}
}
* Set main diagonal zero
forval i=1/171 {
mat	CommCorr`y'wgUnbfs[`i',`i']=0
	}
svmat CommCorr`y'wgUnbfs
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Weighted/CommCorr`y'wg.dta", replace
clear
}

* Normalize correlations to values between 0 and 1

forval y=11/42 {
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Weighted/CommCorr`y'wg.dta"
forval x=1/171 {
su CommCorr`y'wgUnbfs`x', meanonly
gen NCommCorr`y'wg`x'=(CommCorr`y'wgUnbfs`x'-r(min))/(r(max)-r(min))
drop CommCorr`y'wgUnbfs`x'
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Weighted/NCommCorr`y'wg.dta", replace
}
clear
}

//////////////////////////////////////////////////////////////////////////////
******************************************************************************
*                                                                            *
*     		          Basic Model - "Structural Equivalence"				 *
*                                                                            *
*                                                                            *
******************************************************************************
clear

cd "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Weighted/"

* Transpose matrix to have "ResMun" back in columns
noisily forval j=11/42 {
use "NCommCorr`j'wg.dta"
mkmat _all, matrix(NCommCorr`j'_A)
mat NCommCorr`j'=NCommCorr`j'_A'
clear
svmat NCommCorr`j'
forval z=1/171 {
rena NCommCorr`j'`z' Mun`z'
}

save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/weighted/NCommCorr`j'_trans.dta", replace
}

clear

* Row-standardization

noisily forval j=11/42 {
clear
use NCommCorr`j'_trans.dta
copy NCommCorr`j'_trans.dta NCommCorr`j'_stand.dta, replace
clear
use NCommCorr`j'_stand.dta
egen rsum=rowtotal(Mun1-Mun171)
noisily forval i=1/171 {
	replace Mun`i'=Mun`i'/rsum
	recode Mun`i' miss=0
	noisily display "`j'"_c
}
noisily display "`i'"
drop rsum
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/weighted/NCommCorr`j'_stand.dta", replace
}


cd "\\psf\Dropbox\WSL\Paper 2 - Diffusion\Data\Connectivity Matrices\weighted\"
clear
clear matrix
set matsize 5000

forval y=11/40 {
use "NCommCorr`y'_stand.dta"
mkmat _all, matrix(NCommCorr`y'wg)
clear
}

******************************************************************************
*                                                                            
* Three alternatives
*******************************************************************************

////// Time-variant 10 year lag

* Enter matrices in NxT (i.e. 171x20) matrices (one per threshold)
* -> Lag W-matrices by ten years (i.e. use 1980-2000), in order to prevent 
*    potential endogeneity of W and the dependent variable from biasing the 
*    results 

mat NCommCorr = J(3420,3420,0)
forval x=11/30 {
forvalues i = 1/171 {
	forvalues j = 1/171 {
		 matrix NCommCorr[(([`x'-11]*171)+`i'),(([`x'-11]*171)+`j')]=NCommCorr`x'wg[`i',`j']
}
}
}

svmat NCommCorr
 save "NCommCorr_stand_panel_10yL.dta", replace
saveold "NCommCorr_stand_panelR_10yL.dta", replace
clear

////// Time-invariant 

* -> Lag W-matrix by 30 years, in order to prevent 
*    potential endogeneity of W and the dependent variable from biasing the 
*    results  -> enter strucutral equivalence of 1980 for all years

mat NCommCorr = J(3420,3420,0)
forval x=21/40 {
forvalues i = 1/171 {
	forvalues j = 1/171 {
		 matrix NCommCorr[(([`x'-21]*171)+`i'),(([`x'-21]*171)+`j')]=NCommCorr11wg[`i',`j']
}
}
}
svmat NCommCorr
 save "NCommCorr_stand_panel_1980.dta", replace
saveold "NCommCorr_stand_panelR_1980.dta", replace
clear

* -> Lag W-matrix by 30 years, in order to prevent 
*    potential endogeneity of W and the dependent variable from biasing the 
*    results  -> enter strucutral equivalence of 1990 for all years

mat NCommCorr = J(3420,3420,0)
forval x=21/40 {
forvalues i = 1/171 {
	forvalues j = 1/171 {
		 matrix NCommCorr[(([`x'-21]*171)+`i'),(([`x'-21]*171)+`j')]=NCommCorr21wg[`i',`j']
}
}
}

svmat NCommCorr
 save "NCommCorr_stand_panel_1990.dta", replace
saveold "NCommCorr_stand_panelR_1990.dta", replace
clear

******************************************************************************
*                                                                            *
*                            "Regional Planning Groups"                      *
*                                                                            *
*                                                                            *
******************************************************************************

clear
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Datasets/Dataset_final.dta"

keep bfs_nr year planReg
keep if year==2000
drop year
recode planReg 101=2 102=3 103=4 104=5 105=6 106=7 107=8 108=9 109=10 110=11 111=12

forval x=1/171 {
gen mun`x'=planReg
replace mun`x'=1 if planReg[`x']==mun`x'
replace mun`x'=0 if mun`x'>1
}

* Manual recoding of neighbouring municipalities of those municipalities at 
* a border of a planning region

replace mun133=1 if bfs_nr==261| bfs_nr==161| bfs_nr==160| bfs_nr==154| bfs_nr==152| bfs_nr==192| bfs_nr==196
replace mun76=1 if bfs_nr==90| bfs_nr==97| bfs_nr==261| bfs_nr==245| bfs_nr==249| bfs_nr==251
replace mun77=1 if bfs_nr==72| bfs_nr==92| bfs_nr==90| bfs_nr==96| bfs_nr==261
replace mun137=1 if bfs_nr==176| bfs_nr==174| bfs_nr==172| bfs_nr==198| bfs_nr==194
replace mun13=1 if bfs_nr==261| bfs_nr==242| bfs_nr==248| bfs_nr==131| bfs_nr==136
replace mun53=1 if bfs_nr==224| bfs_nr==230| bfs_nr==213| bfs_nr==64| bfs_nr==62
replace mun151=1 if bfs_nr==26| bfs_nr==24| bfs_nr==32| bfs_nr==31
replace mun142=1 if bfs_nr==31| bfs_nr==32| bfs_nr==21| bfs_nr==39
replace mun122=1 if bfs_nr==199| bfs_nr==200| bfs_nr==52| bfs_nr==64
replace mun62=1 if bfs_nr==98| bfs_nr==93| bfs_nr==101| bfs_nr==95
replace mun130=1 if bfs_nr==116| bfs_nr==115| bfs_nr==196| bfs_nr==195
replace mun161=1 if bfs_nr==13| bfs_nr==14| bfs_nr==3
replace mun143=1 if bfs_nr==24| bfs_nr==57| bfs_nr==56
replace mun50=1 if bfs_nr==72| bfs_nr==63| bfs_nr==65
replace mun70=1 if bfs_nr==97| bfs_nr==96| bfs_nr==83
replace mun165=1 if bfs_nr==84| bfs_nr==85| bfs_nr==87
replace mun63=1 if bfs_nr==95| bfs_nr==86| bfs_nr==90
replace mun4=1 if bfs_nr==136| bfs_nr==133| bfs_nr==132
replace mun88=1 if bfs_nr==192| bfs_nr==157| bfs_nr==153
replace mun52=1 if bfs_nr==65| bfs_nr==213| bfs_nr==176
replace mun128=1 if bfs_nr==228| bfs_nr==231| bfs_nr==180
replace mun120=1 if bfs_nr==178| bfs_nr==172| bfs_nr==199
replace mun25=1 if bfs_nr==223| bfs_nr==221| bfs_nr==214
replace mun45=1 if bfs_nr==23| bfs_nr==24| bfs_nr==215
replace mun33=1 if bfs_nr==211| bfs_nr==214| bfs_nr==216
replace mun18=1 if bfs_nr==57| bfs_nr==215| bfs_nr==223
replace mun167=1 if bfs_nr==261| bfs_nr==13
replace mun160=1 if bfs_nr==3| bfs_nr==14
replace mun152=1 if bfs_nr==56| bfs_nr==65
replace mun141=1 if bfs_nr==64| bfs_nr==65
replace mun75=1 if bfs_nr==83| bfs_nr==82
replace mun78=1 if bfs_nr==82| bfs_nr==94
replace mun170=1 if bfs_nr==84| bfs_nr==96
replace mun60=1 if bfs_nr==62| bfs_nr==97
replace mun74=1 if bfs_nr==91| bfs_nr==98
replace mun108=1 if bfs_nr==112| bfs_nr==116
replace mun124=1 if bfs_nr==180| bfs_nr==174
replace mun126=1 if bfs_nr==182| bfs_nr==178
replace mun156=1 if bfs_nr==181| bfs_nr==182
replace mun134=1 if bfs_nr==195| bfs_nr==192
replace mun118=1 if bfs_nr==174| bfs_nr==199
replace mun132=1 if bfs_nr==197| bfs_nr==199
replace mun26=1 if bfs_nr==223| bfs_nr==214
replace mun44=1 if bfs_nr==215| bfs_nr==224
replace mun14=1 if bfs_nr==242| bfs_nr==241
replace mun3=1 if bfs_nr==241| bfs_nr==242
replace mun64=1 if bfs_nr==251| bfs_nr==246
replace mun164=1 if bfs_nr==96| bfs_nr==261
replace mun149=1 if bfs_nr==31
replace mun144=1 if bfs_nr==39
replace mun139=1 if bfs_nr==39
replace mun17=1 if bfs_nr==57
replace mun51=1 if bfs_nr==62
replace mun158=1 if bfs_nr==65
replace mun81=1 if bfs_nr==82
replace mun73=1 if bfs_nr==82
replace mun66=1 if bfs_nr==83
replace mun71=1 if bfs_nr==94
replace mun168=1 if bfs_nr==96
replace mun72=1 if bfs_nr==97
replace mun112=1 if bfs_nr==116
replace mun1=1 if bfs_nr==136
replace mun84=1 if bfs_nr==153
replace mun40=1 if bfs_nr==176
replace mun138=1 if bfs_nr==176
replace mun159=1 if bfs_nr==182
replace mun87=1 if bfs_nr==192
replace mun135=1 if bfs_nr==194
replace mun107=1 if bfs_nr==195
replace mun109=1 if bfs_nr==195
replace mun115=1 if bfs_nr==195
replace mun116=1 if bfs_nr==195
replace mun136=1 if bfs_nr==199
replace mun15=1 if bfs_nr==214
replace mun20=1 if bfs_nr==223
replace mun127=1 if bfs_nr==228
replace mun65=1 if bfs_nr==246
replace mun67=1 if bfs_nr==246
replace mun99=1 if bfs_nr==1 | bfs_nr==4 | bfs_nr==13
replace mun131=1 if bfs_nr==261
replace mun129=1 if bfs_nr==261
replace mun57=1 if bfs_nr==261
replace mun54=1 if bfs_nr==261
replace mun166=1 if bfs_nr==261
replace mun169=1 if bfs_nr==261
replace mun94=1 if bfs_nr==261
replace mun98=1 if bfs_nr==261
replace mun116=1 if bfs_nr==261
replace mun171=1 if bfs_nr==13 | bfs_nr==66 | bfs_nr==69 | bfs_nr==96
replace mun171=1 if bfs_nr==97 | bfs_nr==131 | bfs_nr==135 | bfs_nr==161
replace mun171=1 if bfs_nr==191 | bfs_nr==193 | bfs_nr==195 | bfs_nr==245
replace mun171=1 if bfs_nr==247 | bfs_nr==248 | bfs_nr==250
replace mun94=1 if bfs_nr==13 | bfs_nr==261
replace mun96=1 if bfs_nr==4
replace mun95=1 if bfs_nr==4

drop planReg

/* test if matrix is symmetric 
drop bfs_nr

mkmat _all, matrix(test)
matrix sym=issymmetric(test)
mat list sym
*/

save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/PlanRegions.dta", replace

* Multiply normalized matrices of out-commuting similarity with planning region+
* neighbourhood-dummies
clear
noisily forval j=20/42 {
copy "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/weighted/NCommCorr`j'wg.dta" /*
*/ "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Tests/NCommCorr`j'_PlanRegion.dta", replace
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Tests/NCommCorr`j'_PlanRegion.dta"

merge 1:1 _n using "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/PlanRegions.dta"
drop _merge

* Multiply correlations with planning region+neighbourhood-dummies
forval z=1/171 {
gen Mun`z'=mun`z'*NCommCorr`j'wg`z'
}
drop bfs_nr mun* NCommCorr`j'wg*

* Transpose matrix to have "ResMun" back in columns
mkmat _all, matrix(NCommCorr`j'_PlanRegionA)
mat NCommCorr`j'_PlanRegion=NCommCorr`j'_PlanRegionA'
svmat NCommCorr`j'_PlanRegion
forval z=1/171 {
drop Mun`z'
rena NCommCorr`j'_PlanRegion`z' Mun`z'
}
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Tests/NCommCorr`j'_PlanRegion.dta", replace
clear
}

* Row-standardization

noisily forval j=20/42 {
clear
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Tests/NCommCorr`j'_PlanRegion.dta"
copy "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Tests/NCommCorr`j'_PlanRegion.dta" /*
*/ "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Tests/NCommCorr`j'_PlanRegion_stand.dta", replace
clear
use "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/Tests/NCommCorr`j'_PlanRegion_stand.dta"
egen rsum=rowtotal(Mun1-Mun171)
noisily forval i=1/171 {
	replace Mun`i'=Mun`i'/rsum
	recode Mun`i' miss=0
	noisily display "`j'"_c
}
noisily display "`i'"
drop rsum
save "/Users/berli/Dropbox/WSL/Paper 2 - Diffusion/Data/Connectivity Matrices/weighted/NCommCorr`j'_PlanRegion_stand.dta", replace
}



cd "\\psf\Dropbox\WSL\Paper 2 - Diffusion\Data\Connectivity Matrices\weighted\"
clear
clear matrix
set matsize 5000

* Load matrices for all cross-sections into matrices
forval j=21/40 {
use "NCommCorr`j'_PlanRegion_stand.dta"
mkmat _all, matrix(NCommCorr`j'_PlanRegion)
clear
}


* Enter matrices in NxT (i.e. 171x20) matrices (one per threshold)
* -> Lag W-matrices by one year (i.e. use 1990-2009), in order to prevent 
*    potential endogeneity of W and the dependent variable from biasing the 
*    results (i.e. if municipal zoning affects the similarity of municipalities'
*    commuting patterns)

mat NCommCorr_PlanRegion = J(3420,3420,0)
forval x=21/40 {
forvalues i = 1/171 {
	forvalues j = 1/171 {
		 matrix NCommCorr_PlanRegion[(([`x'-21]*171)+`i'),(([`x'-21]*171)+`j')]=NCommCorr`x'_PlanRegion[`i',`j']
}
}
}
	 
svmat NCommCorr_PlanRegion
save "NCommCorr_PlanRegion_stand_panel.dta", replace
saveold "NCommCorr_PlanRegion_stand_panelR.dta", replace
clear


//////////////////////////////////////////////////////////////////////////////
******************************************************************************
*                                                                            *
*                               "Neighbourhood"                              *
*                                                                            *
*                                                                            *
******************************************************************************

clear

cd "\\psf\Dropbox\WSL\Paper 2 - Diffusion\Data\Connectivity Matrices\Tests\"
import delimited neighbour_mat.tab
drop gmdnr
mkmat _all, matrix(neigh)
mat NeighbourMat = J(3420,3420,0)
forval x=21/40 {
forvalues i = 1/171 {
	forvalues j = 1/171 {
		 matrix NeighbourMat[(([`x'-21]*171)+`i'),(([`x'-21]*171)+`j')]=neigh[`i',`j']
}
}
}
clear
svmat NeighbourMat
save "NeighbourMat.dta", replace
saveold "NeighbourMat_R.dta", replace



