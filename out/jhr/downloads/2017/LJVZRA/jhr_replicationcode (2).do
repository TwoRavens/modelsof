*Level of Women's Rights (Figure 1)
#delimit ;

histogram womenscale, 
	discrete percent
	xtitle("Level of Women's Rights", size(3.5))
	ylabel(, nogrid)
	xlabel(0 1 2 3 4 5 6 7 8 9)
	yscale(noline)
	ytitle("% of Countries", size(3.5))
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

* Domestic Attacks (Figure 2)
#delimit ;
graph bar (mean) terrordomestic, over(womenscale)
	title("Domestic Terror Attacks")
	ytitle("")
	ylabel(, nogrid)
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
	
* Transnational Attacks Attacks (Figure 2)	
#delimit ;
graph bar (mean) transevents, over(womenscale)
	title("Transnational Terror Attacks")
	ytitle("")
	ylabel(, nogrid)
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));

* Domestic Attacks (Table 1)
xtnbreg terrordomestic physint womenscale xconst lngdp lnpop coldwar, fe

* Transnational Attacks (Table 1)
xtnbreg transevents physint womenscale xconst lngdp lnpop coldwar, fe

* Predicted Number of Events (Figure 3)
xtnbreg terrordomestic physint i.womenscale xconst lngdp lnpop coldwar, fe

margins womenscale, atmeans predict(nu0)

#delimit ;

marginsplot, 
	recast(line) recastci(rarea)
	title("")
	xtitle("Level of Women's Rights", size(3.5))
	ylabel(0 0.1 0.2 0.3 0.4 0.5 0.6, nogrid)
	ytitle("Predicted Number of Events", size(3.5))
	yline(0, lcolor(gs10))
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
