* Summary Statistics -- Table 1
set more 1
clear 
use ${DTA}\LAdata_finance
capture log close
log using ${LOG}\Table1, replace text

foreach var in ppexpcurr fracbl {
	gen x=`var' if year==1961
	egen `var'1961=max(x), by(fipscnty)
	drop x
	}

keep if year==1965|year==1970

local depvars "lnenrwh lnenrwh_all fracprivwh lnenroll lnav lnav_real lnav_nr lnppav pprevtot pprevloc pprevst_psf pprevfed_esea pprevnl_oth ppexpcurr tsrat pptransport"
local indvars "percapinc6 perplumb6 perinclt30006 lnpop6 perurban6 ppexpcurr1961 fracti1966"

foreach var in `depvars' {
	gen x=`var' if year==1965
	gen y=`var' if year==1970
	egen x1=max(x), by(fipscnty)
	egen y1=max(y), by(fipscnty)
	gen ch`var'=y1-x1 
	drop x y x1 y1
	}

tempfile temp
save `temp'

foreach var in `depvars' `indvars' {
	clear
	use `temp'
	statsby, by(year) clear: sum `var'
	keep year mean sd
	rename mean mean`var'
	rename sd sd`var'
	sort year
	save ${DTA}\statsby\summstats`var', replace
	}

foreach var in `depvars' {
	clear
	use `temp'
	statsby, by(year) clear: sum ch`var'
	keep year mean sd
	rename mean meanch`var'
	rename sd sdch`var'
	sort year
	save ${DTA}\statsby\summstatsch`var', replace
	}

foreach var in `depvars' `indvars' {
	sort year
	merge year using ${DTA}\statsby\summstats`var'
	drop _merge
	}

foreach var in `depvars' {
	sort year
	merge year using ${DTA}\statsby\summstatsch`var'
	drop _merge
	}

order year meanlnenrwh sdlnenrwh meanlnenrwh_all sdlnenrwh_all meanfracprivwh sdfracprivwh meanlnenroll sdlnenroll meanlnav sdlnav meanlnav_real sdlnav_real meanlnav_nr sdlnav_nr meanlnppav sdlnppav meanpprevtot sdpprevtot meanpprevloc sdpprevloc meanpprevst_psf sdpprevst_psf meanpprevfed_esea sdpprevfed_esea meanpprevnl_oth sdpprevnl_oth meanppexpcurr sdppexpcurr meantsrat sdtsrat meanpptransport sdpptransport meanchlnenrwh sdchlnenrwh meanchlnenrwh_all sdchlnenrwh_all meanchfracprivwh sdchfracprivwh meanchlnenroll sdchlnenroll meanchlnav sdchlnav meanchlnav_real sdchlnav_real meanchlnav_nr sdchlnav_nr meanchlnppav sdchlnppav meanchpprevtot sdchpprevtot meanchpprevloc sdchpprevloc meanchpprevst_psf sdchpprevst_psf meanchpprevfed_esea sdchpprevfed_esea meanchpprevnl_oth sdchpprevnl_oth meanchppexpcurr sdchppexpcurr meanchtsrat sdchtsrat meanchpptransport sdchpptransport

outsheet mean* if year==1965 using $OUTREG/means1965.csv, c replace
outsheet sd* if year==1965 using $OUTREG/sd1965.csv, c replace

outsheet mean* if year==1970 using $OUTREG/means1970.csv, c replace
outsheet sd* if year==1970 using $OUTREG/sd1970.csv, c replace

outsheet meanpercapinc6 meanperplumb6 meanperinclt30006 meanlnpop6 meanperurban6 meanppexpcurr1961 meanfracti1966 using $OUTREG/means-indep.csv if year==1965, c replace
outsheet sdpercapinc6 sdperplumb6 sdperinclt30006 sdlnpop6 sdperurban6 sdppexpcurr1961 sdfracti1966 using $OUTREG/sd-indep.csv if year==1965, c replace

/*enrollment
table year , c(mean lnenrwh mean lnenrwh_all mean fracprivwh mean lnenroll )
table year , c(sd lnenrwh sd lnenrwh_all sd fracprivwh sd lnenroll )
table year , c(mean chlnenrwh mean chlnenrwh_all mean chfracprivwh mean chlnenroll )
table year , c(sd chlnenrwh sd chlnenrwh_all sd chfracprivwh sd chlnenroll )


*mean lnav mean lnav_real mean lnav_nr mean lnppav

