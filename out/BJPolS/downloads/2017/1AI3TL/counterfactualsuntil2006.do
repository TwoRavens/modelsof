drop _all
*change to your working directory
cd "/Users//`=c(username)'/"
use "BW_replicationuntil2006.dta"

*bischof
gen difference=pshiftt2-vshift
*Intersting case to look into is the Front National in France (1993). 
*Also one might be intrested in varying the communists & greens. 

regress pshift2 adams vshift pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
keep if e(sample)

regress pshift2 c.bischof##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)


matrix coeffs_bischof = e(b)
matrix covmat_bischof = e(V)


keep if year==1993 & adams_country=="France"
expand 3
bysort partydan: gen n=_n
gen id= adams_party+string(n,"%02.0f")
replace bischof=0.28 if n==1
replace bischof=0.42 if n==2
replace bischof=0.80 if n==3


set obs 1000
drawnorm bischofc1-bischofc14, means(coeffs_bischof) cov(covmat_bischof) double
sum bischofc1-bischofc14
matrix list e(b)

*Now we want to vary the nicheness of each party from its 5% percentile to its 95% percentile: 
sum bischof, detail
gen bischof2=bischof

tab id, gen(partydum)
 
 forvalues k = 1/15 {
  generate bprob`k' = .

}
 
*1 counterfactuals:
*0.2 0.3 0.4 0.5 0.6 0.7
nois _dots 0, title() reps(1000)
quietly forvalues j = 1/1000 {
  mkmat bischofc1-bischofc14 if _n==`j', matrix(draw)
  emdb
  predict bischofpred 
    
  forvalues n = 1/15 {
  egen bt_prob`n' = total(bischofpred) if partydum`n' == 1
  egen bprob_temp`n' = max(bt_prob`n')
  
  replace bprob`n' = bprob_temp`n' if _n==`j'
  
  drop bt_prob`n' bprob_temp`n' 
  }
  
  drop bischofpred
  nois _dots `j' 0

  }
 
keep bprob7 bprob8 bprob9
rename bprob7 per10
rename bprob8 per50
rename bprob9 per90 

gen party="FN"
gen simulated="Bischof"
save "simulation1.dta"
drop _all


*policy
drop _all
*change to your working directory
cd "/Users//`=c(username)'/"
use "BW_replicationuntil2006.dta"

replace OffPolMR=-(OffPolMR-21)
*policy
regress pshift2 adams vshift pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
keep if e(sample)
drop laverhunt
rename OffPolMR laverhunt
regress pshift2 c.laverhunt##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)


matrix coeffs_laver = e(b)
matrix covmat_laver = e(V)


keep if year==1993 & adams_country=="France"
expand 3
bysort partydan: gen n=_n
gen id= adams_party+string(n,"%02.0f")
replace laver=8.68 if n==1
replace laver=11.525 if n==2
replace laver=13.36 if n==3

set obs 1000
drawnorm laverc1-laverc14, means(coeffs_laver) cov(covmat_laver) double
sum laverc1-laverc14
matrix list e(b)

*Now we want to vary the nicheness of each party from its 5% percentile to its 95% percentile: 
sum laverhunt, detail
gen laver2=laverhunt

tab id, gen(partydum)
 
 forvalues k = 1/15 {
  generate bprob`k' = .

}
 
*1 counterfactuals:
*0.2 0.3 0.4 0.5 0.6 0.7
nois _dots 0, title() reps(1000)
quietly forvalues j = 1/1000 {
  mkmat laverc1-laverc14 if _n==`j', matrix(draw)
  emdb
  predict laverpred 
    
  forvalues n = 1/15 {
  egen bt_prob`n' = total(laverpred) if partydum`n' == 1
  egen bprob_temp`n' = max(bt_prob`n')
  
  replace bprob`n' = bprob_temp`n' if _n==`j'
  
  drop bt_prob`n' bprob_temp`n' 
  }
  
  drop laverpred
  nois _dots `j' 0

  }
  
keep bprob7 bprob8 bprob9
rename bprob7 per10
rename bprob8 per50
rename bprob9 per90 

gen party="FN"
gen simulated="Policy"
save "simulation2.dta"
drop _all

*activists
drop _all
*change to your working directory
cd "/Users//`=c(username)'/"
use "BW_replicationuntil2006.dta"

*activists
regress pshift2 adams vshift pshiftt12 votec1 pvoteshift ///
Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)
keep if e(sample)
regress pshift2 c.laverhunt##c.vshift pshiftt12 votec1 pvoteshift Italy Britain Greece Luxembourg Denmark Netherlands Spain, cluster(clnum)


matrix coeffs_laver = e(b)
matrix covmat_laver = e(V)


keep if year==1993 & adams_country=="France"
expand 3
bysort partydan: gen n=_n
gen id= adams_party+string(n,"%02.0f")
replace laver=-12.6 if n==1
replace laver=-8.6 if n==2
replace laver=2.33 if n==3


set obs 1000
drawnorm laverc1-laverc14, means(coeffs_laver) cov(covmat_laver) double
sum laverc1-laverc14
matrix list e(b)

*Now we want to vary the nicheness of each party from its 5% percentile to its 95% percentile: 
sum laverhunt, detail
gen laver2=laverhunt

tab id, gen(partydum)
 
 forvalues k = 1/15 {
  generate bprob`k' = .

}
 
*1 counterfactuals:
*0.2 0.3 0.4 0.5 0.6 0.7
nois _dots 0, title() reps(1000)
quietly forvalues j = 1/1000 {
  mkmat laverc1-laverc14 if _n==`j', matrix(draw)
  emdb
  predict laverpred 
    
  forvalues n = 1/15 {
  egen bt_prob`n' = total(laverpred) if partydum`n' == 1
  egen bprob_temp`n' = max(bt_prob`n')
  
  replace bprob`n' = bprob_temp`n' if _n==`j'
  
  drop bt_prob`n' bprob_temp`n' 
  }
  
  drop laverpred
  nois _dots `j' 0

  }
  
keep bprob7 bprob8 bprob9
rename bprob7 per10
rename bprob8 per50
rename bprob9 per90 

gen party="FN"
gen simulated="Activists"
save "simulation3.dta"
drop _all

use "simulation1.dta"
append using "simulation2.dta"
append using "simulation3.dta"

replace simulated="Bischof" if simulated=="Bichof"

tw kdensity per10 if simulated == "Bischof", xline(0, lpattern(solid) lcol(black)) || ///
kdensity per50 if simulated == "Bischof", lpattern(dash) || ///
kdensity per90 if simulated == "Bischof", lpattern(vshortdash) ///
title("{bf:Bischof}") xtitle("simulated outcome") name(niche) legend(off) ///
xlabel(-0.5 0 0.5 0.7) ylabel(0 0.5 1.0 1.5 2.0 2.5)

tw kdensity per10 if simulated == "Policy", xline(0, lpattern(solid) lcol(black)) || ///
kdensity per50 if simulated == "Policy", lpattern(dash) || ///
kdensity per90 if simulated == "Policy", lpattern(vshortdash) ///
title("{bf:Laver & Hunt: Policy-seeking}") xtitle("simulated outcome") name(policy) legend(off) ///
xlabel(-0.5 0 0.5 0.7) ylabel(0 0.5 1.0 1.5 2.0 2.5)

tw kdensity per10 if simulated == "Activists", xline(0, lpattern(solid) lcol(black)) || ///
kdensity per50 if simulated == "Activists", lpattern(dash) || ///
kdensity per90 if simulated == "Activists", lpattern(vshortdash) ///
title("{bf:Laver & Hunt: Activists}") xtitle("simulated outcome") name(activist) ///
legend(order(1 "10%" 2 "50%" 3 "90%")) ///
xlabel(-0.5 0 0.5 0.7) ylabel(0 0.5 1.0 1.5 2.0 2.5)


grc1leg niche policy activist, legendfrom(activist) position(4)
graph drop niche policy activist


