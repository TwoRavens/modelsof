/*----------------------------------------------------------HC_rev_dfig_contractrest.do

Stuart Craig
Last updated	20180816
*/

	timestamp, output
	cap mkdir dfig_contractrest
	cd dfig_contractrest

	loc proc ip
	use ${ddHC}/HC_cdata_`proc'_i.dta, clear
	// How many times does a hospital treat each DRG in a year?
	bys prov_e_npi ep_adm_y ep_drg: gen N=_N

	gen pps=c_type==1
	gen ptc=c_type==2
	gen unc=pps==0&ptc==0

	cap postclose temp
	postfile temp r pps ptc unc using temp.dta, replace

	forval r=1/200 {
		qui summ pps if N>=`r', mean
		loc pps = r(mean)
		qui summ ptc if N>=`r', mean
		loc ptc = r(mean)
		qui summ unc if N>=`r', mean
		loc unc = r(mean)
		post temp (`r') (`pps') (`ptc') (`unc')
		di ., _c
		if mod(`r',20)==0 di `r'
	}
	postclose temp
	use temp, clear

	gen cat1 = ptc
	gen cat2 = cat1 + pps
	gen cat3 = cat2	+ unc

	tw area cat1 r || ///
		rarea cat2 cat1 r || ///
		rarea cat3 cat2 r, fc(gs13) lc(gs13) ///
		ytitle("Fraction") ylab(0(.2)1,format(%2.1f)) ///
		xtitle("Minimum Count Restriction") ///
		legend(order( 1 "Share of Charges" 2 "Prospective Payment" 3 "Unclassified") ring(0) pos(11) row(1))
	graph export HC_rev_dfig_contractrest.png, replace	

exit
