******Do-file to create Figure 1 "Impact Training on Productivity and Wages"

use acf_train_bootstrapREStat.dta

twoway (scatter betaT_ACF btr_wageaug , mlabel(nace2)) /*
	*/ (line betaT_ACF betaT_ACF , lcolor(red) lwidth(medthick)) if nace2 ~= 64 & nace2 ~= 65 /*
	*/ , xscale(range(0 0.6)) yscale(range(0 0.6)) legend(off) /* 
	*/ ytitle("Impact Training on Productivity") xtitle("Impact Training on Wages") /*
	*/ graphregion(fcolor(white)) title("Impact Training on Productivity and Wages")
