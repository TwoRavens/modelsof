use "EES 2009 - stacked.dta", clear

xtreg ptv lrproxch lrsamesidech i.countrystack, cluster(id) fe
estimates store ptv_ch_1

xtreg ptv c.lrproxch##lrsamesidech i.countrystack, cluster(id) fe
estimates store ptv_ch_2

xtreg voterec lrproxch lrsamesidech i.countrystack, cluster(id) fe
estimates store vote_ch_1

xtreg voterec c.lrproxch##lrsamesidech i.countrystack, cluster(id) fe
estimates store vote_ch_2

esttab ptv_ch_1 ptv_ch_2 vote_ch_1 vote_ch_2, replace compress nogap ///
	label drop(0b.lrsamesidech 0b.lrsamesidech#co.lrproxch )  ///
	indicate(Party-Fixed Eff. = *countrystack) title("Results with Party Positions Based on Chapel Hill Expert Surveys") ///
	rename(1.lrsamesidech lrsamesidech 1.lrsamesidech#c.lrproxch "Prox~X~Same") se b(3) scalars(r2_a N N_clust) sfmt(%9.3f %9.0f) 

