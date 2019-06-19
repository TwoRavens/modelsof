**************************************************************************************
***THIS PROGRAM DOES A RESPONSE SURFACE METHODOLOGY AFTER ALL THE BETA MONTE CARLOS***
**************************************************************************************

***SETUP***

clear
timer clear
set more off
set type double
set memory 500m
pause on

global path="C:\data"

***GENERATE DATASET FOR REGRESSIONS***

quietly {
	foreach alpha in 0.5 1 3 5 10 25 {
		foreach beta in 0.5 1 3 5 10 25 {
			use "$path\_mc_rbeta(`alpha',`beta')_10000.dta
			drop *_se_* y*
			replace zvar=zvar/(zmean^2)
			replace zskew=zskew/(zmean^3)
			replace zkurt=zkurt/(zmean^4)

			foreach var of varlist gini_full gini_50 gini_40 gini_30 gini_20 gini_15 gini_14 gini_13 gini_12 gini_11 gini_10 gini_9 gini_8 gini_7 gini_6 gini_5 gini_4 gini_3 gini_2 {
				sum `var'
				replace `var'=r(mean)
			}
			keep in 1
			save $path\responsesurface_`alpha'_`beta'.dta, replace
		}
	}
	drop in 1
	foreach alpha in 0.5 1 3 5 10 25 {
		foreach beta in 0.5 1 3 5 10 25 {
			append using $path\responsesurface_`alpha'_`beta'.dta
			erase $path\responsesurface_`alpha'_`beta'.dta
		}
	}
}


***REGRESSIONS***

log using $path\responsesurface.log, replace
foreach num of numlist 2/15 20 30 40 50 {
	quietly {
		gen absbias_`num'=gini_full-gini_`num'
		gen soabsbias_`num'=gini_full-((`num'^2)/((`num'^2)-1))*gini_`num'
	}
	regress absbias_`num' zvar zskew zkurt
	regress soabsbias_`num' zvar zskew zkurt
	quietly drop *bias*
}
log close
