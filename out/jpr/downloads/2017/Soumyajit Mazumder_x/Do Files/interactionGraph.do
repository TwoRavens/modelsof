set more off
	* Marginal effect of PTACent using 2.1
quietly logit mzinit c.PTACent1_lag##c.pol1_lag democracy_2_lag igos dependlow_lag requivlag5 PTASameGT0_lag oil_1_lag contigdum logdist rgdp1_lag rgdp2_lag s_wt_glo initshare majmaj minmaj majmin pcyrsmzinit pcyrsmzinits*, robust cluster(dirdyadid)
tab democracy_1_lag if e(sample)
margins, dydx(PTACent1_lag) at(pol1_lag=(-10(1)10)) vsquish post
matrix at=e(at)
matrix at=at[1...,"pol1_lag"]
matrix list at
parmest, norestore
svmat at
twoway (line min95 at1, lpattern(dash)) (line estimate at1) (line max95 at1, lpattern(dash)), legend(order (1 "Upper 95% c.i." 3 "Lower 95% c.i.")) yline(0) ///
       xtitle(Polity Score) ytitle(Marginal Effect of PTA Degree Centrality) scheme(s1mono) yscale(range(-.001 0.004)) ylabel(#5)
save margcent_1.dta, replace
exit
