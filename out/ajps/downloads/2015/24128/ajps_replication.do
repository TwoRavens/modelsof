use ajps_replication, clear

keep if country=="Netherlands" | country=="Germany" | country=="Denmark"


// 1.	Median Dominance Model //

nbreg totalchanges_wyes_new nonmedianminister minmeddist minnonmeddist_nonmedmin minor nocomm logno_articles_new censor exposure germany nether dimension3 dimension4 dimension7 dimension8
outtex, level below labels legend file(medresults) replace
keep if e(sample)

// Obtain individual log-likelihoods and relevant statistics for Vuong and Clarke tests //

estimates store median

global ll_med=e(ll)
global k_med=e(k)
global N_med=e(N)

predict double xb_med

matrix B_med=e(b)
matrix A_med=B_med[1,"lnalpha:_cons"]
scalar a_med=exp(A_med[1,1])

gen double lnf_med = lngamma(totalchanges_wyes_new + (1/a_med))-lngamma((1/a_med)) - lnfactorial(totalchanges_wyes_new) - (totalchanges_wyes_new+(1/a_med))*ln(1+a_med*xb_med)+ totalchanges_wyes_new*ln(a_med) + totalchanges_wyes_new*ln(xb_med)

// Graph of median effect //

su minmeddist if e(sample) & nonmedianminister==1
global meddist_min=r(min)
global meddist_max=r(max)
global level_meddist=$meddist_min
global increment=.5
global maxstep=ceil(($meddist_max-$meddist_min)/$increment)

gen level_meddist=$level_meddist in 1
replace level_meddist=level_meddist[_n-1]+$increment in 2/$maxstep

gen effect_meddist=.
gen effect_meddist_p5=.
gen effect_meddist_p95=.

local i=1
while `i'<=$maxstep {
	lincom minmeddist*$level_meddist
	replace effect_meddist=100*(exp(r(estimate))-exp(0)) in `i'
	replace effect_meddist_p5=100*(exp(r(estimate)-1.96*r(se))-exp(0)) in `i'
	replace effect_meddist_p95=100*(exp(r(estimate)+1.96*r(se))-exp(0)) in `i'
	global level_meddist=$level_meddist+$increment
	local i=`i'+1
	}

gen yline_med=0 
gen xlevel_med=_n-1 in 1/11

twoway  (rarea effect_meddist_p5 effect_meddist_p95 level_meddist, fcolor(gs15) lcolor(white)) (line effect_meddist level_meddist) (line yline_med xlevel_med, lwidth(medthick) lpattern(tight_dot)) (kdensity minmeddist if e(sample) & nonmedianminister==1, yaxis(2) recast(line) lpattern(shortdash)),  ytitle(Kernel Density, axis(2)) ytitle(, size(small) margin(medsmall) axis(2)) ylabel(, labsize(small) axis(2))  ytitle("Expected Percentage Change" "in Number of Amended Articles") ytitle(, size(small) margin(medsmall))  ylabel(, labsize(small))  xtitle("Distance between Minister and Median Party") xtitle(, size(small) margin(medsmall)) xlabel(, labsize(small))legend(off) scheme(s1mono) 
gr save median_line, replace


// 2.	Coalition Compromise Model //

nbreg totalchanges_wyes_new MDgov MDnonpvtopp_com MDpvtopp_com minor nocomm logno_articles_new censor exposure germany nether dimension3 dimension4 dimension7 dimension8
outtex, level below labels legend file(comresults) replace
keep if e(sample)

// Obtain individual log-likelihoods and relevant statistics for Vuong and Clarke tests //

estimates store compromise

global ll_com=e(ll)
global k_com=e(k)
global N_com=e(N)

predict double xb_com

matrix B_com=e(b)
matrix A_com=B_com[1,"lnalpha:_cons"]
scalar a_com=exp(A_com[1,1])

gen double lnf_com = lngamma(totalchanges_wyes_new + (1/a_com))-lngamma((1/a_com)) - lnfactorial(totalchanges_wyes_new) - (totalchanges_wyes_new+(1/a_com))*ln(1+a_com*xb_com)+ totalchanges_wyes_new*ln(a_com) + totalchanges_wyes_new*ln(xb_com)
 
// Graph of compromise effect //

su MDgov if e(sample)
global MDgov_min=r(min)
global MDgov_max=r(max)
global level_MDgov=$MDgov_min
global increment=.5
global maxstep=ceil(($MDgov_max-$MDgov_min)/$increment)

gen level_MDgov=$level_MDgov in 1
replace level_MDgov=level_MDgov[_n-1]+$increment in 2/$maxstep

gen effect_MDgov=.
gen effect_MDgov_p5=.
gen effect_MDgov_p95=.

local i=1
while `i'<=$maxstep {
	lincom MDgov*$level_MDgov
	replace effect_MDgov=100*(exp(r(estimate))-exp(0)) in `i'
	replace effect_MDgov_p5=100*(exp(r(estimate)-1.96*r(se))-exp(0)) in `i'
	replace effect_MDgov_p95=100*(exp(r(estimate)+1.96*r(se))-exp(0)) in `i'
	global level_MDgov=$level_MDgov+$increment
	local i=`i'+1
	}

gen yline_MD=0 
gen xlevel_MD=_n-1 in 1/11

twoway  (rarea effect_MDgov_p5 effect_MDgov_p95 level_MDgov, fcolor(gs15) lcolor(white)) (line effect_MDgov level_MDgov) (line yline_MD xlevel_MD, lwidth(medthick) lpattern(tight_dot)) (kdensity MDgov if e(sample), yaxis(2) recast(line) lpattern(shortdash)), ytitle(Kernel Density, axis(2)) ytitle(, size(small) margin(medsmall) axis(2)) ylabel(, labsize(small) axis(2)) ytitle("Expected Percentage Change" "in Number of Amended Articles") ytitle(, size(small) margin(medsmall))   ylabel(, labsize(small)) xtitle("Distance between Minister and Coalition Compromise") xtitle(, size(small) margin(medsmall)) xlabel(, labsize(small))legend(off) scheme(s1mono) 
gr save compromise_line, replace

gr combine median_line.gph compromise_line.gph, ycomm scheme(s1mono)
gr save figure3, replace
gr export figure3.eps, logo(off) orientation(portrait) replace  // Figure 2 in AJPS article //


// 3.	Vuong test (two-tailed) //

global DFcorrection=($k_med/2)*ln($N_med) - ($k_com/2)*ln($N_com)

global vuong_numer = $ll_med - $ll_com - $DFcorrection

gen lnf_diff=(lnf_med-lnf_com)
su lnf_diff
scalar lnf_diff_avg=r(mean)

gen lnf_diffsq=(lnf_med-lnf_com)^2
su lnf_diffsq
scalar lnf_diffsq_avg=r(mean)

global vuong_denom=sqrt($N_com)*sqrt(lnf_diffsq_avg-lnf_diff_avg^2)

global vuong_zstat=$vuong_numer/$vuong_denom
global vuong_pvalue=2*normal($vuong_zstat)

kdensity lnf_diff, normal // Check whether distribution of individual likelihood ratios is mesokurtic //

// 4.	Clarke test //

signtest lnf_med=lnf_com  // In this case, DF correction need not be applied to individual likelihoods because models have the same number of covariates //


// 5.	Scatterplot of (a) median position versus coalition compromise position and (b) minister-median versus minister-compromise distance //

keep if e(sample)

// (a) //

by medianpos coalcompromise, sort: gen npairs_counter=_n==1
replace npairs_counter=sum(npairs_counter)

gen npairs=.

su npairs_counter
local npair_max=r(max)
forv i=1/`npair_max' {
	count if npairs_counter==`i'
	replace npairs=r(N) if npairs_counter==`i'
	}	
	
gen line45=_n-1 in 1/21

twoway (scatter medianpos coalcompromise if e(sample) [fweight = npairs], sort msize(small) msymbol(circle_hollow) mlwidth(vvvthin)) (line line45 line45, lwidth(medthin)), ytitle(Median Party Position) ytitle(, margin(medsmall) size(small)) yscale(range(3 18)) ylabel(0(5)20, labsize(small)) xtitle(Coalition Compromise Position) xtitle(, margin(medsmall) size(small)) xscale(range(0 20)) xlabel(0(5)20, labsize(small)) legend(off) scheme(s1mono)
gr save figure4a, replace

// (b) //

preserve

keep if e(sample) & nonmedianminister==1 & medingov==1

by minmeddist MDgov, sort: gen npairs_dist_counter=_n==1
replace npairs_dist_counter=sum(npairs_dist_counter)

gen npairs_dist=.

su npairs_dist_counter
local npair_dist_max=r(max)
forv i=1/`npair_dist_max' {
	count if npairs_dist_counter==`i'
	replace npairs_dist=r(N) if npairs_dist_counter==`i'
	}	

drop line45	
gen line45=_n-2 in 1/12

twoway (scatter minmeddist MDgov if e(sample) [fweight = npairs_dist], sort msize(small) msymbol(circle_hollow) mlwidth(vvvthin)) (line line45 line45, lwidth(medthin)), ytitle(Distance between Minister and Median Party) ytitle(, margin(medsmall) size(small)) yscale(range(-0.5 10)) ylabel(0(2)10, labsize(small)) xtitle(Distance between Minister and Coalition Compromise) xtitle(, margin(medsmall) size(small)) xscale(range(-0.5 10)) xlabel(0(2)10, labsize(small)) legend(off) scheme(s1mono)
gr save figure4b, replace
gr export figure4b.eps, logo(off) orientation(portrait) replace // Figure 3 in AJPS article //

restore

gr combine figure4a.gph figure4b.gph, rows(2) scheme(s1mono)
gr export figure4.eps, logo(off) orientation(portrait) replace


// 6.	Joint model //

nbreg totalchanges_wyes_new nonmedianminister minmeddist minnonmeddist_nonmedmin MDgov MDnonpvtopp_com MDpvtopp_com minor nocomm logno_articles_new censor exposure germany nether dimension3 dimension4 dimension7 dimension8
outtex, level below labels legend file(jointresults) replace

lrtest median
lrtest compromise

estimates store joint

global ll_com=e(ll)
global k_com=e(k)
global N_com=e(N)

predict double xb_joint

matrix B_com=e(b)
matrix A_com=B_com[1,"lnalpha:_cons"]
scalar a_com=exp(A_com[1,1])

gen double lnf_joint = lngamma(totalchanges_wyes_new + (1/a_com))-lngamma((1/a_com)) - lnfactorial(totalchanges_wyes_new) - (totalchanges_wyes_new+(1/a_com))*ln(1+a_com*xb_joint)+ totalchanges_wyes_new*ln(a_com) + totalchanges_wyes_new*ln(xb_joint)
 

// Graph of median effect //

su minmeddist if e(sample) & nonmedianminister==1
global meddist_min=r(min)
global meddist_max=r(max)
global level_meddist=$meddist_min
global increment=.5
global maxstep=ceil(($meddist_max-$meddist_min)/$increment)

gen level_meddist_joint=$level_meddist in 1
replace level_meddist_joint=level_meddist_joint[_n-1]+$increment in 2/$maxstep

gen effect_meddist_joint=.
gen effect_meddist_joint_p5=.
gen effect_meddist_joint_p95=.

local i=1
while `i'<=$maxstep {
	lincom minmeddist*$level_meddist
	replace effect_meddist_joint=100*(exp(r(estimate))-exp(0)) in `i'
	replace effect_meddist_joint_p5=100*(exp(r(estimate)-1.96*r(se))-exp(0)) in `i'
	replace effect_meddist_joint_p95=100*(exp(r(estimate)+1.96*r(se))-exp(0)) in `i'
	global level_meddist=$level_meddist+$increment
	local i=`i'+1
	}

gen yline_med_joint=0 
gen xlevel_med_joint=_n-1 in 1/11

twoway  (rarea effect_meddist_joint_p5 effect_meddist_joint_p95 level_meddist_joint, fcolor(gs15) lcolor(white)) (line effect_meddist_joint level_meddist_joint) (line yline_med_joint xlevel_med_joint, lwidth(medthick) lpattern(tight_dot)) (kdensity minmeddist if e(sample) & nonmedianminister==1, yaxis(2) recast(line) lpattern(shortdash)),  ytitle(Kernel Density, axis(2)) ytitle(, size(small) margin(medsmall) axis(2)) ylabel(, labsize(small) axis(2))  ytitle("Expected Percentage Change" "in Number of Amended Articles") ytitle(, size(small) margin(medsmall))  ylabel(, labsize(small))  xtitle("Distance between Minister and Median Party") xtitle(, size(small) margin(medsmall)) xlabel(, labsize(small))legend(off) scheme(s1mono) 
gr save median_line_joint, replace

// Graph of compromise effect //

su MDgov if e(sample)
global MDgov_min=r(min)
global MDgov_max=r(max)
global level_MDgov=$MDgov_min
global increment=.5
global maxstep=ceil(($MDgov_max-$MDgov_min)/$increment)

gen level_MDgov_joint=$level_MDgov in 1
replace level_MDgov_joint=level_MDgov_joint[_n-1]+$increment in 2/$maxstep

gen effect_MDgov_joint=.
gen effect_MDgov_joint_p5=.
gen effect_MDgov_joint_p95=.

local i=1
while `i'<=$maxstep {
	lincom MDgov*$level_MDgov
	replace effect_MDgov_joint=100*(exp(r(estimate))-exp(0)) in `i'
	replace effect_MDgov_joint_p5=100*(exp(r(estimate)-1.96*r(se))-exp(0)) in `i'
	replace effect_MDgov_joint_p95=100*(exp(r(estimate)+1.96*r(se))-exp(0)) in `i'
	global level_MDgov=$level_MDgov+$increment
	local i=`i'+1
	}

gen yline_MD_joint=0 
gen xlevel_MD_joint=_n-1 in 1/11

twoway  (rarea effect_MDgov_joint_p5 effect_MDgov_joint_p95 level_MDgov_joint, fcolor(gs15) lcolor(white)) (line effect_MDgov_joint level_MDgov_joint) (line yline_MD_joint xlevel_MD_joint, lwidth(medthick) lpattern(tight_dot)) (kdensity MDgov if e(sample), yaxis(2) recast(line) lpattern(shortdash)), ytitle(Kernel Density, axis(2)) ytitle(, size(small) margin(medsmall) axis(2)) ylabel(, labsize(small) axis(2)) ytitle("Expected Percentage Change" "in Number of Amended Articles") ytitle(, size(small) margin(medsmall))   ylabel(, labsize(small)) xtitle("Distance between Minister and Coalition Compromise") xtitle(, size(small) margin(medsmall)) xlabel(, labsize(small))legend(off) scheme(s1mono) 
gr save compromise_line_joint, replace

gr combine median_line_joint.gph compromise_line_joint.gph, ycomm scheme(s1mono)
gr save figure5, replace
gr export figure5.eps, logo(off) orientation(portrait) replace  // Figure 4 in AJPS article //


