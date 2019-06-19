clear
set mem 400m
use "suicide_final_county_level.dta", clear
gen s_rate = (s_freq/county_pop)*100000
label var s_rate "Suicides per 100000 Persons"
pwcorr s_rate mean if year==1990, sig
pwcorr s_rate mean [aw=county_pop] if year==1990, sig
gen logmean = log(mean)
label var logmean "Mean Family Income (log scale)"

** Graph for REStat
	*Raw data
	export excel county_pop year s_rate logmean using ///
	"Figure4_raw_data.xls" ///
	if year==1990 & s_rate<50 & s_rate>0, sheet("Raw_data") ///
	sheetreplace firstrow(variables) nolabel

	*Graph
	twoway (scatter s_rate logmean if year==1990 & s_rate<50 & s_rate>0 [aweight = county_pop], mcolor(black) msize(small) msymbol(circle_hollow)) (lfit s_rate logmean), xscale(log) xlabel(#4) title("Figure 4. County Suicide Rates vs. County Income in 1990", size(medsmall) color(black))
	graph save "Figure4", replace
	
	*Graph without shading in background for manuscript
	#delimit ;
	twoway 
		(scatter s_rate logmean if year==1990 & s_rate<50 & s_rate>0 [aweight = county_pop],
		  mcolor(black) 
		  msize(small) 
		  msymbol(circle_hollow))
		(lfit s_rate logmean)
		, 
		xscale(log) 
		xlabel(#4) 
		title("Figure 4. County Suicide Rates vs. County Income in 1990", size(medsmall)
		color(black))
		graphregion(fcolor(white) lcolor(white) ilcolor(white)) plotregion(fcolor(white) lcolor(white) ilcolor(white));
	#delimit cr
	graph export "Figure4_clean.emf", replace
