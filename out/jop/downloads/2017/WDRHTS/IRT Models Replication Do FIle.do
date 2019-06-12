
/// This do file reproduces the appendix analysis that replicates the main text analysis
/// using estimates of policy orientations derived from a hybrid IRT model
use  "Zingher JOP 2017.dta", clear
cd  "Analysis Files"

set more off

drop if vcf0010z==.
/// Constructing IRT Models
irt hybrid (nrm Fed_Gov_Too_Strong More_Less_Gov_Scale) (grm Gov_Ins_Placement Gov_SL_Placement SS_Spending_Scale Fair_jobs_blacks Welfare_Scale School_Fund_Scale Immigrants_Scale Envir_Spend_Scale Aid_Blacks_Placement Aid_to_poor_Scale School_Busing_Scale Urban_Unrest_Scale Federal_Gov_Wasteful) [pweight= vcf0010z], iterate(20) vce(r)
predict lat_var, latent se(latse)
irt hybrid (nrm School_Prayer) (grm New_Lifestyles_Moraldecay Bible_Scale Abortion_Scale  Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale Womens_Role_Placement Abortion_Scale_Alt Bible_Scale_Alt Equal_Rgts_Amend) [pweight= vcf0010z]
predict lat_var2, latent se(latse2)
/// Appendix Table 6
probit Pres_Vote c.lat_var c.lat_var2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat c.dwnom1_difference c.lat_var#c.dwnom1_difference c.lat_var2#c.dwnom1_difference policy_mood Mean_Dem_Support   if year>=1971 & white==1 [pweight= vcf0010z]  , robust
outreg2 using Appendix_IRT_CV, replace auto(2) alpha(.05) dec(2) symbol(*) e(r2_p) 
probit Pres_Vote c.lat_var c.lat_var2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat c.dwnom1_difference c.lat_var#c.dwnom1_difference c.lat_var2#c.dwnom1_difference policy_mood Mean_Dem_Support Party_Dis  if year>=1971 & white==1 [pweight= vcf0010z]  , robust
outreg2 using Appendix_IRT_CV, append auto(2) alpha(.05) dec(2) symbol(*)  e(r2_p)
regress PID_7 c.lat_var c.lat_var2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat c.dwnom1_difference c.lat_var#c.dwnom1_difference c.lat_var2#c.dwnom1_difference policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= vcf0010z]  , robust
outreg2 using Appendix_IRT_CV, append auto(2) alpha(.05) dec(2) symbol(*) 
regress PID_7 c.lat_var c.lat_var2 white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat c.dwnom1_difference c.lat_var#c.dwnom1_difference c.lat_var2#c.dwnom1_difference policy_mood Mean_Dem_Support Party_Dis if year>=1971 & white==1 [pweight= vcf0010z]  , robust
outreg2 using Appendix_IRT_CV, append auto(2) alpha(.05) dec(2) symbol(*) 

	#delimit ; 

probit Pres_Vote c.lat_var##c.dwnom1_difference  c.lat_var2##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Economic" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(lat_var) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice - Economic")
        name(Panel_`name', replace) 
		;
		graph save "Vote Choice - Economic IRT", replace;
		;
	
	#delimit cr

/// Figures--Vote Choice Social ME

	#delimit ; 

probit Pres_Vote  c.lat_var2##c.dwnom1_difference c.lat_var##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Social" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(lat_var2) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice - Social")
        name(Panel_`name', replace)
		;
		graph save "Vote Choice - Social IRT", replace;
		;
	
	#delimit cr

/// Figures--PID Economic


	#delimit ; 

regress PID_7 c.lat_var##c.dwnom1_difference  c.lat_var2##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Economic" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(lat_var) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID - Economic")
        name(Panel_`name', replace) 
		;
		graph save "PID - Economic IRT", replace;
		;
		
	#delimit cr

/// Figures PID--Social


	#delimit ; 

regress PID_7  c.lat_var2##c.dwnom1_difference c.lat_var##c.dwnom1_difference  white_southerner female Income age weeklychurch Catholic Jew unionmember education_6cat  Party_Dis Mean_Dem_Support if white==1, robust ;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local name = "Social" ;
		local interval = ((`max'-`min')/10) ;
		margins, dydx(lat_var2) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(dwnom1_difference) lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID - Social")
        name(Panel_`name', replace) 
		;
		graph save "PID - Social IRT", replace;
		;

		#delimit cr
		
/// Appendix Figure 9		
graph combine "Vote Choice - Economic IRT" "Vote Choice - Social IRT" "PID - Economic IRT" "PID - Social IRT", xsize(6.5) 
graph export "IRT MEs Combined.pdf", replace 

local a = 1972
gen wtmedianl=.
while `a' <=2012{
summarize lat_var [w=vcf0009z] if year==`a', detail
replace wtmedianl = r(p50) if year==`a'
local a = `a' + 4
}
 
 
local a = 1972
gen wwtmedianl=.
while `a' <=2012{
summarize lat_var [w=vcf0009z] if year==`a' & white==1, detail
replace wwtmedianl = r(p50) if year==`a'
local a = `a' + 4
}
 
local a = 1972
gen wtmedian2l=.
while `a' <=2012{
summarize lat_var2 [w=vcf0009z] if year==`a', detail
replace wtmedian2l = r(p50) if year==`a'
local a = `a' + 4
}
 
 
local a = 1972
gen wwtmedian2l=.
while `a' <=2012{
summarize lat_var2 [w=vcf0009z] if year==`a' & white==1, detail
replace wwtmedian2l = r(p50) if year==`a'
local a = `a' + 4
}
 
gen whitedistlat = wwtmedianl-wtmedianl
gen whitedist2lat = wwtmedian2l-wtmedian2l

/// Appendix Figure 8
twoway scatter whitedistlat year, xtitle(year) xlabel(1972(8)2012) ylabel(-.1(.1).3) ytitle(Distance from the Overall Median) legend(off) title(Economic) || lfit whitedistlat year
graph save "IRT Distance Econ.gph", replace 
twoway scatter whitedist2lat year, xtitle(year) xlabel(1972(8)2012) ylabel(-.1(.1).3) ytitle(Distance from the Overall Median) legend(off) title(Social) || lfit whitedist2lat year
graph save "IRT Distance Social.gph", replace 
graph combine "IRT Distance Econ.gph" "IRT Distance Social.gph", xsize(6)
graph export "IRT White Distance from the Median.pdf", replace 
