/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do


log using output/log_figureA10.txt, replace text



include code/set_globals.do



*-------------------------------------------------------
* figure A10
*-------------------------------------------------------


* FIPS-DMA crosswalks
tempfile xwalk

use input/xwalk/dma_county_map, clear 

drop if multi_dma

gen fips = state*1000 + county

keep fips dma_code

save `xwalk'




*** calculate distances
use input/distances.dta, clear


* merge in FIPS codes
rename in_fid FID
merge m:1 FID using input/FID_FIPS_crosswalk, keepusing(FIPS)
assert _merge==3
drop _merge
drop FID
rename FIPS state_county

rename near_fid FID
merge m:1 FID using input/FID_FIPS_crosswalk, keepusing(FIPS)
assert _merge==3
drop _merge

* distnace in km (convert degree to km)
gen distance = near_dist*78.71 

rename FIPS neighbor

keep state_county neighbor distance


*merge in DMA codes
rename state_county fips
merge m:1 fips using `xwalk', keep(3)
drop _merge
rename fips state_county
rename dma_code dma_own

rename neighbor fips
merge m:1 fips using `xwalk', keep(3)
drop _merge
rename fips neighbor
rename dma_code dma_other


compress
tempfile distance_matrix
save `distance_matrix', replace


gen state_self=floor(state_county/1000)
gen state_other=floor(neighbor/1000)
gen byte same_state=(state_self==state_other)

gen byte other_dma=(dma_own!=dma_other)

* drop Alaska, Hawaii & territories b/c they aren't in CMAG sample
drop if state_self==2 | state_self==15 | state_self==66 | state_self==72 | state_self==78 | state_self==60


keep if same_state & other_dma
sum distance if same_state, d
local mean_distance_sstate=r(mean)
local median_distance_sstate=r(p50)

sort distance
keep if mod(_n,100)==1
cumul distance, generate(cdf1)
keep distance cdf1
tempfile cdf1
save `cdf1', replace



*** nearest-neighbor matching

use input/sample_allcounties.dta, clear


* drop states w/ only one media market
by state year, sort: egen dummy=sd(dma_code)
drop if dummy==0
drop dummy



* define "treatment indicators"
by state year: egen dummy=median(cmag_prez_ptya_base)
gen Tall=(cmag_prez_ptya_base>dummy)
drop dummy
by state year: egen dummy1=count(Tall)
by state year: egen dummy2=total(Tall)
gen sample_all=(dummy1>=5 & dummy2>=5)
drop dummy*
by state year: egen dummy=median(cmag_prez_ptyd_base)
gen Tdiff=(cmag_prez_ptyd_base>dummy)
drop dummy
by state year: egen dummy1=count(Tdiff)
by state year: egen dummy2=total(Tdiff)
gen sample_diff=(dummy1>=5 & dummy2>=5)
drop dummy*

* save temp data sets for subsampling
tempfile data_diff
tempfile data_all
preserve
keep if sample_diff==1
save `data_diff'
restore
preserve
keep if sample_all==1
save `data_all'
restore




* point estimates
teffects nnmatch (cmag_prez_ptyd_base $extra_controls $demo_controls lag_vote_share2pty_ptydf) (Tdiff) if sample_diff, vce(iid) ematch(year state) biasadj($extra_controls $demo_controls lag_vote_share2pty_ptydf) nneighbor(1)
matrix b= e(b)
local pe_diff = b[1,1]
teffects nnmatch (vote_share2pty_ptydf $extra_controls $demo_controls lag_vote_share2pty_ptydf) (Tdiff) if sample_diff, vce(iid) ematch(year state) biasadj($extra_controls $demo_controls lag_vote_share2pty_ptydf) gen(distance_diff_nn) nneighbor(1)
matrix b= e(b)
local pe_vote = b[1,1]

local effect_diff = `pe_vote'/`pe_diff'
di "Effect *diff*: `effect_diff'"

gen FIPSnear_diff=state[distance_diff_nn1]*1000 + county[distance_diff_nn1]
gen same_state_diff=(state==state[distance_diff_nn1])
tab same_state_diff if e(sample)

teffects nnmatch (cmag_prez_ptya_base $extra_controls $demo_controls lag_turnout_pres) (Tall) if sample_all, vce(iid) ematch(year state) biasadj($extra_controls $demo_controls lag_turnout_pres) nneighbor(1)
matrix b= e(b)
local pe_all = b[1,1]
teffects nnmatch (turnout $extra_controls $demo_controls lag_turnout_pres) (Tall) if sample_all, vce(iid) ematch(year state) biasadj($extra_controls $demo_controls lag_turnout_pres) gen(distance_all_nn) nneighbor(1)
matrix b= e(b)
local pe_turnout = b[1,1]

local effect_all = `pe_turnout'/`pe_all'
di "Effect *all*: `effect_all'"

gen FIPSnear_all=state[distance_all_nn1]*1000 + county[distance_all_nn1]
gen same_state_all=(state==state[distance_all_nn1])
tab same_state_all if e(sample)




*** distances of nearest neighbors

drop state_county
gen state_county=1000*state+county
rename FIPSnear_diff neighbor
merge m:1 state_county neighbor using `distance_matrix', keep(3)
drop _merge
rename distance nneighbor_distance_diff
rename neighbor FIPSnear_diff

rename FIPSnear_all neighbor
merge m:1 state_county neighbor using `distance_matrix', keep(3)
drop _merge
rename distance nneighbor_distance_all
rename neighbor FIPSnear_all


count
local N = r(N)
count if nneighbor_distance_diff<=`median_distance_sstate'
local Nbelow_diff = r(N)
count if nneighbor_distance_all<=`median_distance_sstate'
local Nbelow_all = r(N)
di "share below median (diff): "`Nbelow_diff'/`N'
di "share below median (all): "`Nbelow_all'/`N'


cumul nneighbor_distance_all, generate(cdf_all)
cumul nneighbor_distance_diff, generate(cdf_diff)

preserve

keep nneighbor_distance_* cdf_*

append using `cdf1'

sort distance nneighbor_distance_diff
twoway (line cdf1 distance) (line cdf_diff nneighbor_distance_diff)
graph play code/figureA10.grec
graph save output/figureA10.gph, replace
graph export output/figureA10.eps, replace





log close

