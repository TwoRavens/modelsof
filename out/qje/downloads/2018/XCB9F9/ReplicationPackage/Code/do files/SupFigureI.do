#delimit cr

preserve

keep plot_id season s2_shock13?? s2_shock14?? s3_shock14?? s3_shock1501 

foreach x of numlist 1/9 {
	rename s2_shock130`x' s2_shock13`x'
	rename s2_shock140`x' s2_shock14`x'
	rename s3_shock140`x' s3_shock14`x'
}

* Generate Graphs

foreach x of numlist 8/12 {
	sum s2_shock13`x'
	local s2_shockmean`x' = r(mean)
}	
foreach x of numlist 1/7 {
	sum s2_shock14`x'
	local s2_shockmean`x' = r(mean)
}	
foreach x of numlist 8/12 {
	sum s3_shock14`x'
	local s3_shockmean`x' = r(mean)
}	
sum s3_shock1501
local s3_shockmean13 = r(mean)

hist s2_shock138  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean8' , lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("Density") xtitle("Relative Rainfall") title("2013, August", size(medlarge))    saving("Temp/Rain_Season1_Month8", replace)
hist s2_shock139  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean9' , lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2013, September", size(medlarge)) saving("Temp/Rain_Season1_Month9", replace)
hist s2_shock1310 if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean10', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2013, October", size(medlarge))   saving("Temp/Rain_Season1_Month10", replace)
hist s2_shock1311 if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean11', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2013, November", size(medlarge))  saving("Temp/Rain_Season1_Month11", replace)
hist s2_shock1312 if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean12', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2013, December", size(medlarge))  saving("Temp/Rain_Season1_Month12", replace)
hist s2_shock141  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean1' , lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, January", size(medlarge))   saving("Temp/Rain_Season1_Month13", replace)

hist s2_shock142  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean2', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("Density") xtitle("Relative Rainfall") title("2014, February", size(medlarge))  saving("Temp/Rain_Season2_Month2", replace)
hist s2_shock143  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean3', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, March", size(medlarge))     saving("Temp/Rain_Season2_Month3", replace)
hist s2_shock144  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean4', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, April", size(medlarge))     saving("Temp/Rain_Season2_Month4", replace)
hist s2_shock145  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean5', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, May", size(medlarge))       saving("Temp/Rain_Season2_Month5", replace)
hist s2_shock146  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean6', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, June", size(medlarge))      saving("Temp/Rain_Season2_Month6", replace)
hist s2_shock147  if season == 2, xline(1, lc(red) lp(dash)) xline(`s2_shockmean7', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, July", size(medlarge))      saving("Temp/Rain_Season2_Month7", replace)

hist s3_shock148  if season == 3, xline(1, lc(red) lp(dash)) xline(`s3_shockmean8', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("Density") xtitle("Relative Rainfall") title("2014, August", size(medlarge))    saving("Temp/Rain_Season3_Month8", replace)
hist s3_shock149  if season == 3, xline(1, lc(red) lp(dash)) xline(`s3_shockmean9', lc(black) lp(dash))  w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, September", size(medlarge)) saving("Temp/Rain_Season3_Month9", replace)
hist s3_shock1410 if season == 3, xline(1, lc(red) lp(dash)) xline(`s3_shockmean10', lc(black) lp(dash)) w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, October", size(medlarge))   saving("Temp/Rain_Season3_Month10", replace)
hist s3_shock1411 if season == 3, xline(1, lc(red) lp(dash)) xline(`s3_shockmean11', lc(black) lp(dash)) w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, November", size(medlarge))  saving("Temp/Rain_Season3_Month11", replace)
hist s3_shock1412 if season == 3, xline(1, lc(red) lp(dash)) xline(`s3_shockmean12', lc(black) lp(dash)) w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2014, December", size(medlarge))  saving("Temp/Rain_Season3_Month12", replace)
hist s3_shock1501 if season == 3, xline(1, lc(red) lp(dash)) xline(`s3_shockmean13', lc(black) lp(dash)) w(0.25) start(0) xsc(r(0 2.75)) xlabel(0(.5)2.5) ysc(r(0 2.75)) ylabel(0(.5)2.5) ytitle("")        xtitle("Relative Rainfall") title("2015, January", size(medlarge))   saving("Temp/Rain_Season3_Month13", replace)


graph combine "Temp/Rain_Season1_Month8.gph" "Temp/Rain_Season1_Month9.gph" "Temp/Rain_Season1_Month10.gph" "Temp/Rain_Season1_Month11.gph" "Temp/Rain_Season1_Month12.gph" "Temp/Rain_Season1_Month13.gph", cols(6) title("Rainfall: Season 0", position(11)) saving("Temp/Rain_Season1", replace) 
graph combine "Temp/Rain_Season2_Month2.gph" "Temp/Rain_Season2_Month3.gph" "Temp/Rain_Season2_Month4.gph" "Temp/Rain_Season2_Month5.gph" "Temp/Rain_Season2_Month6.gph" "Temp/Rain_Season2_Month7.gph"    , cols(6) title("Rainfall: Season 1", position(11)) saving("Temp/Rain_Season2", replace)
graph combine "Temp/Rain_Season3_Month8.gph" "Temp/Rain_Season3_Month9.gph" "Temp/Rain_Season3_Month10.gph" "Temp/Rain_Season3_Month11.gph" "Temp/Rain_Season3_Month12.gph" "Temp/Rain_Season3_Month13.gph", cols(6) title("Rainfall: Season 2", position(11)) saving("Temp/Rain_Season3", replace) 
	
graph combine "Temp/Rain_Season1.gph" "Temp/Rain_Season2.gph" "Temp/Rain_Season3.gph", rows(3) xsize(6) ysize(4.5) 
graph save "Output/RainFallExperimentalSeason.pdf", replace

restore

#delimit ;
