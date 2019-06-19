clear all

// Benchmark results, Figures 1a, 1b, 2 and 3a
//////////////////////////////////////////////
use data/boot_bench, clear
foreach zz of numlist 0 1{
	gen y = EY`zz' if NB>1
	bys P: egen sd = sd(y)
	gen lb`zz' = EY`zz'-invnormal(.975)*sd
	gen ub`zz' = EY`zz'+invnormal(.975)*sd
	drop y sd
}
// Figure 1a
sc EY1 lb1 ub1 P if NB==1 & inrange(P,Pmin,Pmax), c(i l l) clp("" "-#-#" "-#-#") ms(. i i) sort legend(off) xt("") yt("") ylab(, labs(medlarge)) xlab(, labs(medlarge))

// Figure 1b
sc EY0 lb0 ub0 P if NB==1 & inrange(P,Pmin,Pmax), c(i l l) clp("" "-#-#" "-#-#") ms(. i i) sort legend(off) xt("") yt("") ylab(, labs(medlarge)) xlab(, labs(medlarge))

gen ATE = EY1-EY0
gen y = ATE if NB>1
bys P: egen sd = sd(y)
gen lbate = ATE-invnormal(.975)*sd
gen ubate = ATE+invnormal(.975)*sd
drop y sd

// Figure 2
sc ATE lbate ubate P if NB==1 & inrange(P,Pmin,Pmax), c(i l l) clp("" "-#-#" "-#-#") ms(. i i) sort legend(off) xt("") yt("") ylab(, labs(medlarge)) xlab(, labs(medlarge))

// just for the comparison graphs, drop obs with P>.1
drop if P>.1
replace ub0 = . if ub0>.7
replace lb1 = . if lb1<.3

// Figure 3a
sc EY1 lb1 ub1 P if NB==1 & inrange(P,Pmin,Pmax), c(i l l) clp("" "-#-#" "-#-#") ms(. i i) mc(black) sort legend(off) xt("") yt("")   ///
                                                  ylab(, labs(medlarge)) xlab(, labs(medlarge))   ///
|| sc EY0 lb0 ub0 P if NB==1 & inrange(P,Pmin,Pmax), c(l l l) clp("solid" "-#-#" "-#-#") ms(i i i) mc(black) sort legend(off) xt("") yt("")    ///
                                                  ylab(, labs(medlarge)) xlab(, labs(medlarge))												  
												  
// Robustness checks - Figures 3b-3h
////////////////////////////////////

// set local name and then run the following for each figure in 3b-3h
// local name = "MXh" // Fig 3b
// local name = "fe" // Fig 3c
// local name = "a10" // Fig 3d
// local name = "a25" // Fig 3e
// local name = "nq4" // Fig 3f
// local name = "occ" // Fig 3g
// local name = "zy915" // Fig 3h

use data/boot_`name', clear
foreach zz of numlist 0 1{
	gen y = EY`zz' if NB>1
	bys P: egen sd = sd(y)
	gen lb`zz' = EY`zz'-invnormal(.975)*sd
	gen ub`zz' = EY`zz'+invnormal(.975)*sd
	drop y sd
}
drop if P>.1
if "`name'"~="zy915" replace ub0 = . if ub0>.7
replace lb1 = . if lb1<.3
sc EY1 lb1 ub1 P if NB==1 & inrange(P,Pmin,Pmax), c(i l l) clp("" "-#-#" "-#-#") ms(. i i) mc(black) sort legend(off) xt("") yt("")   ///
												ylab(, labs(medlarge)) xlab(, labs(medlarge))   ///
	|| sc EY0 lb0 ub0 P if NB==1 & inrange(P,Pmin,Pmax), c(l l l) clp("solid" "-#-#" "-#-#") ms(i i i) mc(black) sort legend(off) xt("") yt("")    ///
												ylab(, labs(medlarge)) xlab(, labs(medlarge))				

