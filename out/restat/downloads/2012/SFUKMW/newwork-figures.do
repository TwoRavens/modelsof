cd /Users/jeff/Documents/Academic/Research/Innovation.2008/
clear
set mem 6g
set matsize 1200
set more off

#delimit ;

/* Figure 1 */
/* occupation distribution, by new title share */

#delimit ;
use tmp/new2000-wk.dta, clear;
histogram new_lin, frac
	xlab(0 .2 .4 .6 .8 1, labsize(small))
	xscale(range(0 1))	ylab(none, labsize(small))	xtitle("", size(small))	ytitle("", size(small))
	title("2000", size(small))
	scheme(s1mono) legend(off)	lwidth(none)
	saving(gph/fig-1c.gph, replace);
graph export gph/fig-1c.png, replace;
	
use tmp/new1990-wk.dta, clear;
histogram newtsh_convt, frac
	xlab(0 .2 .4 .6 .8 1, labsize(small))	ylab(none, labsize(small))	xtitle("", size(small))	ytitle("", size(small))	title("1990", size(small))
	xscale(range(0 1))	scheme(s1mono) legend(off)	lwidth(none)
	saving(gph/fig-1b.gph, replace);
graph export gph/fig-1b.png, replace;

use tmp/new1980-wk.dta, clear;
histogram newmaster_tsh, frac
	xlab(0 .2 .4 .6 .8 1, labsize(small))	ylab(, labsize(small))	xtitle("", size(small))	ytitle("", size(small))	title("1980", size(small))
	xscale(range(0 1))	scheme(s1mono) legend(off)	lwidth(none)
	saving(gph/fig-1a.gph, replace);
graph export gph/fig-1a.png, replace;

#delimit ;
graph combine gph/fig-1a.gph gph/fig-1b.gph gph/fig-1c.gph, r(1) ycomm xcomm iscale(1)
	scheme(s1mono)
	b1title("New title share", size(small))	l1title("Census detailed occupations (fraction)", size(small))	;
graph export gph/fig-1.eps, replace;

/* Figure 2 */
/* new title count share vs new title employment share, using the 1971:4 double-coded cps */

#delimit cr
	use "/Users/jeff/Documents/Academic/Research/Data/DOT/DOT77 work/dot77-new-work.dta", clear	merge dot77n using dta/xwalk_dot77_dot91.dta, keep(dot91 dot91n) nokeep		tab _merge		drop _m	sort dot77n	merge dot77n using dta/delete_dot77_dot91.dta, keep(dot91 dot91n) nokeep update replace		tab _merge		drop _m	replace dot91n = dot77n if dot91n==.	sort dot91n	merge dot91n using dta/xwalk_dot91_soc1980.dta, nokeep		tab _merge		drop _merge
	bysort soc1980: egen titles = nvals(dot77n)
	bysort soc1980: egen newtitles = nvals(dot77n) if newmaster==1
		replace newtitles = 0 if newtitles==.
	gen newmaster_tsh = newtitles/titles
	sort dot77n
	save tmp/cps71tmp.dta, replace
	do "/Users/jeff/Documents/Academic/Research/Data/DOT/ICPSR 7845/10180500/ICPSR_07845/DS0001/import_clean.do"	drop V*	replace perwt=perwt/100	gen long dot77n = dot77
	drop if dot77 == 999999999	sort dot77n
	merge dot77n using tmp/cps71tmp.dta, nokeep	tab _merge	*codebook dot77 if _m==1
	drop _merge	gen wt71=1
	
	log using log/fig2.log, replace
	codebook dot77n
	codebook soc77
	log close
	
	bysort soc77: egen cpstitles = nvals(dot77n)
	bysort soc77: egen cpsnewtitles = nvals(dot77n) if newmaster==1
	replace cpsnewtitles = 0 if cpsnewtitles==.
	
	preserve
	
	collapse (mean) newmaster_tsh (sum) wt71 newmaster [pw=perwt], by(soc1980)
	gen newmaster_empsh = newmaster/wt71
	
	#delimit ;
	twoway (scatter newmaster_tsh newmaster_empsh, jitter(1) m(oh))
			(lfit newmaster_tsh newmaster_empsh,
			legend(off)
			range(0 .4)
			estopts(nocons)
			xlab(, labsize(small))			ylab(, labsize(small))			xtitle("")
			title("All DOT titles", size(small))
			saving(gph/fig-2a.gph, replace));
	#delimit cr
	restore
	
	preserve
	
	collapse (mean) cpstitles cpsnewtitles (sum) wt71 newmaster [pw=perwt], by(soc77)
	gen cpsnewmaster_tsh = cpsnewtitles/cpstitles
	gen newmaster_empsh = newmaster/wt71
	
	#delimit ;
	twoway (scatter cpsnewmaster_tsh newmaster_empsh, jitter(1) m(oh))
			(lfit cpsnewmaster_tsh newmaster_empsh,
			range(0 .4)
			estopts(nocons)
			legend(off)
			xlab(, labsize(small))			ylab(, labsize(small))			xtitle("")
			title("CPS-observed titles only", size(small))
			saving(gph/fig-2b.gph, replace));
	#delimit cr
	
	#delimit ;
	graph combine gph/fig-2a.gph gph/fig-2b.gph, r(1) ycomm xcomm iscale(1)
	scheme(s1mono)
	b1title("New title (employment) share", size(small))	l1title("New title (count) share", size(small))	;
	graph export gph/fig-2.eps, replace;
	#delimit cr
		
/* Figure 3 */
/* map of new work employment share */

capture program drop mapcapture
program define mapcapture
use dta/ipums/`1'/`1'-wk2, clear
collapse (mean) `2', by(geoid)
sort geoid
save tmp/geonew`1'.dta, replace
outsheet using arc/m/geomap`1'.txt, replace
end
mapcapture 2000 new_lin
mapcapture 1990 newtsh_convt
mapcapture 1980 newmaster_tsh




/* Figure 4 */
/* new work employment share and patents */


/* First for industries */
use "/Users/jeff/Documents/Academic/Research/Data/USPTO/patsic02/patsic02.dta", clearren sic1 sicseqsort sicseqmerge sicseq using "/Users/jeff/Documents/Academic/Research/Data/USPTO/sicind.dta", nokeeptab _mergedrop _merge
forvalues yr=1960(10)1990 {
preserve
keep if appyear>=`yr' & appyear<=`yr'+10ren i2 indsiccollapse (count) patent, by(indsic)sort indsicsave tmp/patsic-`yr'-wk1.dta, replace
restore
}

capture program drop indpat
program define indpat
use dta/ipums/`1'/`1'-wk2, clear
keep if ind1950>0 & ind1950<946gen indsic=-1replace indsic = 202 if ind1950>=316 & ind1950<=326replace indsic = 203 if ind1950>=336 & ind1950<=348replace indsic = 204 if ind1950>=356 & ind1950<=358replace indsic = 205 if ind1950>=367 & ind1950<=367replace indsic = 206 if ind1950>=376 & ind1950<=379replace indsic = 208 if ind1950>=399 & ind1950<=399replace indsic = 209 if ind1950>=406 & ind1950<=429replace indsic = 210 if ind1950>=436 & ind1950<=466replace indsic = 214 if ind1950>=467 & ind1950<=469replace indsic = 215 if ind1950>=476 & ind1950<=477replace indsic = 216 if ind1950>=478 & ind1950<=478

#delimit ;
label define indsiclbl 202 "CONCR." 
						203 "METALS"
						204 "MACHINERY"
						205 "ELEC. MACH."
						206 "TR. EQUIP."
						208 "MISC. MFG."
						209 "FOOD"
						210 "TEXTILES"
						214 "CHEM."
						215 "PETROL."
						216 "RUBBER"
						-1 "NON-MFG.";

#delimit cr
label values indsic indsiclbl

gen emp = 1
collapse (sum) `2' emp, by(indsic)sort indsicmerge indsic using tmp/patsic-`3'-wk1.dtatab _mergedrop _m
gen new = `2'/emp
gen patpc = patent/emp
gen lnpat = log(patent)

end

indpat 2000 new_lin 1990
#delimit ;
scatter new lnpat [w=emp], m(oh) mcolor(gs14) || scatter new lnpat, 
	legend(off)
	xsc(range(8.5 13.0))
	xlabel(none)
	ylab(, labsize(tiny))	xtitle("")
	ytitle("")
	title("Industries 2000",size(vsmall))
	m(none) mlab(indsic) mlabpos(0) mlabsize(tiny)
	saving(gph/fig4c.gph, replace)
	;
#delimit cr

indpat 1990 newtsh_convt 1980
#delimit ;
scatter new lnpat [w=emp], m(oh) mcolor(gs14) || scatter new lnpat, 
	legend(off)
	xsc(range(8.3 12.6))
	ysc(range(0.045 .09))
	xlabel(none)
	ylab(, labsize(tiny))	xtitle("")
	ytitle("")
	title("Industries 1990",size(vsmall))
	m(none) mlab(indsic) mlabpos(0) mlabsize(tiny)
	saving(gph/fig4b.gph, replace)
	;
#delimit cr

indpat 1980 newmaster_tsh 1970
#delimit ;
scatter new lnpat [w=emp], m(oh) mcolor(gs14) || scatter new lnpat, 
	legend(off)
	xsc(range(8.3 12.6))
	ysc(range(0.045 .09))
	xlabel(none)
	ylab(, labsize(tiny))	xtitle("")
	ytitle("")
	title("Industries 1980",size(vsmall))
	m(none) mlab(indsic) mlabpos(0) mlabsize(tiny)
	saving(gph/fig4a.gph, replace)
	;
#delimit cr



use dta/ipums/2000/2000-wk2, clear
collapse (mean) new_lin, by(geoid year)
sort geoid year
ren year matchyear
merge geoid matchyear using tmp/geo-final.dta, nokeep

#delimit ;
scatter new_lin geo_patents_ln [w=geo_pop],
	legend(off)
	xsc(range(1.3 11.4))
	xlabel(none)
	ylab(, labsize(tiny))	xtitle("")
	ytitle("")
	m(oh)
	mcolor(gs14)
	title("Cities 2000",size(vsmall))
	|| scatter new_lin geo_patents_ln,
	m(none) mlab(cbsaname) mlabsize(tiny) mlabpos(0)
	saving(gph/fig4d.gph, replace)
	;
#delimit cr




#delimit ;
graph combine gph/fig4a.gph gph/fig4b.gph gph/fig4c.gph gph/fig4d.gph, r(2) c(2) iscale(1) imargin(tiny)
	scheme(s1mono)
	b1title("Log patents, previous decade", size(vsmall))	l1title("New work employment share", size(vsmall))	;
#delimit cr
graph export gph/fig-4.eps, replace




/* Figure 5 */
/* new work employment share and tfp growth */


use "/Users/jeff/Documents/Academic/Research/Data/NBER-CES Manufacturing Productivity/bbg96_87.dta", clear
do do/_incl_tfp_ind.do

capture program drop geotfp
program define geotfp

use dta/ipums/`1'/`1'-wk2, clear
drop if ind1990<100 | ind1990>395
drop if ind1990==301 | ind1990 ==332 | ind1990==350 | ind1990 ==392
sort ind1990
merge ind1990 using tmp/TFPind, nokeep
tab _merge
drop _merge
egen geo_tfp`2'=mean(tfp`2'), by(geoid)
egen geo_tfp`3'=mean(tfp`3'), by(geoid)
egen newmfg=mean(`4'), by(geoid)
egen mfgemp = count(ind1990), by(geoid)
egen tag = tag(geoid)
keep if tag
keep geoid geo_tfp`2' geo_tfp`3' mfgemp newmfg year
gen dtfp = ln(geo_tfp`3'/geo_tfp`2')
ren year matchyear
sort geoid matchyear
merge geoid matchyear using tmp/geo-final, keep(cbsaname)
end

geotfp 2000 90 96 new_lin
#delimit ;
scatter newmfg dtfp,
	legend(off)
	xlabel(none)
	ylab(, labsize(tiny))	xsc(range(-.1 .6))
	xtitle("")
	ytitle("")
	title("2000",size(vsmall))
	m(oh)
	mcolor(gs14)
	|| scatter newmfg dtfp,
	m(none) mlab(cbsaname) mlabsize(vsmall) mlabpos(0)
	saving(gph/fig-5-2000.gph, replace);
#delimit cr
geotfp 1990 77 90 newtsh_convt
#delimit ;
scatter newmfg dtfp,
	legend(off)
	xlabel(none)
	ylab(, labsize(tiny))	xtitle("")
	xsc(range(-.2 .4))
	ytitle("")
	title("1990",size(vsmall))
	m(oh)
	mcolor(gs14)
	|| scatter newmfg dtfp,
	m(none) mlab(cbsaname) mlabsize(vsmall) mlabpos(0)
	saving(gph/fig-5-1990.gph, replace);
#delimit cr
geotfp 1980 65 77 newmaster_tsh
#delimit ;
scatter newmfg dtfp,
	legend(off)
	xlabel(none)
	ylab(, labsize(tiny))	xtitle("")
	ytitle("")
	title("1980",size(vsmall))
	xsc(range(-.057 .12))
	m(oh)
	mcolor(gs14)
	|| scatter newmfg dtfp,
	m(none) mlab(cbsaname) mlabsize(vsmall) mlabpos(0)
	saving(gph/fig-5-1980.gph, replace);
#delimit cr

#delimit ;
graph combine gph/fig-5-1980.gph gph/fig-5-1990.gph gph/fig-5-2000.gph, r(1) iscale(1)
	scheme(s1mono)
	l1title("New work employment share, manufacturing", size(small))
	b1title("Imputed TFP growth, manufacturing", size(small))
	ysize(2)
	;
#delimit cr
graph export gph/fig-5.eps, replace

