
* Gathering NOMINATE data and calculating the mean and 
clear all
cd  "Analysis Files"
use "DW-NOMINATE Scores House and Senate.dta"

keep if cong >= 87

keep cong state cd statenm party dwnom1 dwnom2
drop if state == 99
sort cong 

* Congress means and variances
by cong: egen dwnom1_cmean = mean(dwnom1)
by cong: egen dwnom2_cmean = mean(dwnom2)
by cong: egen dwnom1_cvar = sd(dwnom1)
by cong: egen dwnom2_cvar = sd(dwnom2)


label var dwnom1_cmean "Congress Mean (First Dimension)"
label var dwnom2_cmean "Congress Mean (Second Dimension)"
label var dwnom1_cvar "Congress Variance (First Dimension)"
label var dwnom2_cvar "Congress Variance (Second Dimension)"


* Party means and variances
by cong: egen dwnom1_dmean = mean(dwnom1) if party == 100
by cong: egen dwnom1_rmean = mean(dwnom1) if party == 200

by cong: egen dwnom2_dmean = mean(dwnom2) if party == 100
by cong: egen dwnom2_rmean = mean(dwnom2) if party == 200

by cong: egen dwnom1_dvar = sd(dwnom1) if party == 100
by cong: egen dwnom1_rvar = sd(dwnom1) if party == 200

by cong: egen dwnom2_dvar = sd(dwnom2) if party == 100
by cong: egen dwnom2_rvar = sd(dwnom2) if party == 200

replace dwnom1_dvar = dwnom1_dvar^2
replace dwnom1_rvar = dwnom1_rvar^2
replace dwnom2_dvar = dwnom2_dvar^2
replace dwnom2_rvar = dwnom2_rvar^2

label var dwnom1_dmean "Democratic Mean (First Dimension)"
label var dwnom1_rmean "Republican Mean (First Dimension)"
label var dwnom2_dmean "Democratic Mean (Second Dimension)"
label var dwnom2_rmean "Republican Mean (Second Dimension)"
label var dwnom1_dvar "Democratic Variance (First Dimension)"
label var dwnom1_rvar "Republican Variance (First Dimension)"
label var dwnom2_dvar "Democratic Variance (Second Dimension)"
label var dwnom2_rvar "Republican Variance (Second Dimension)"

collapse (mean) dwnom1_cmean dwnom2_cmean dwnom1_cvar dwnom2_cvar dwnom1_dmean dwnom1_rmean dwnom2_dmean dwnom2_rmean dwnom1_dvar dwnom1_rvar dwnom2_dvar dwnom2_rvar , by(cong)

tsset cong
gen year = 1962 if cong == 87
replace year = l.year+2 if year == . 

label var year "Last Year of Congress"

sort year

tempfile clear
tempfile NOMINATE_CS

save `NOMINATE_CS'

clear

use "GSS Post Factor.dta"
sort year
merge m:1 year using `NOMINATE_CS', gen(nominate_merge) update replace


save `NOMINATE_CS', replace

keep if nominate_merge == 2
keep year dwnom1_cmean dwnom2_cmean dwnom1_cvar dwnom2_cvar dwnom1_dmean dwnom1_rmean dwnom2_dmean dwnom2_rmean dwnom1_dvar dwnom1_rvar dwnom2_dvar dwnom2_rvar 

tsset year

foreach var of varlist dwnom1_cmean-dwnom2_rvar {
rename `var' `var'_lag
}

replace year = year + 2
drop if year > 2014
sort year

tempfile NOMINATE_CS_LAG
save `NOMINATE_CS_LAG', replace

clear

use `NOMINATE_CS'
merge m:1 year using `NOMINATE_CS_LAG', nogen update replace


*drop dwnom1_difference inter1 inter2 inter3 inter4

gen dwnom1_difference = dwnom1_rmean-dwnom1_dmean 


gen policy_mood = . 
replace policy_mood = 63.64 if year==1972
replace policy_mood = 63.64 if year==1972
replace policy_mood = 55.6 if year==1976
replace policy_mood = 50.1 if year==1980
replace policy_mood = 58.34 if year==1983
replace policy_mood = 58.90 if year==1984
replace policy_mood = 60.28 if year==1986
replace policy_mood = 62.9 if year==1987
replace policy_mood = 64.77 if year==1988
replace policy_mood = 66.05 if year==1989
replace policy_mood = 64.58 if year==1990
replace policy_mood = 65.49 if year==1991
replace policy_mood = 65.42 if year==1992
replace policy_mood = 62.48 if year==1993
replace policy_mood = 58.24 if year==1994
replace policy_mood = 56.74 if year==1996
replace policy_mood = 59.16 if year==1998
replace policy_mood = 60.58 if year==2000
replace policy_mood = 66.7 if year==2002
replace policy_mood = 64.7 if year==2004
replace policy_mood = 66.4 if year==2006
replace policy_mood = 66.6 if year==2008
replace policy_mood = 65.23 if year==2009
replace policy_mood = 61.48 if year==2010
replace policy_mood = 62.3 if year==2011
replace policy_mood = 61.25 if year==2012
replace policy_mood = 60.4 if year==2013
replace policy_mood = 59.1 if year==2014




local a = 1972
gen wtmedian=.
while `a' <=2014{
summarize F1_Adj if year==`a' [w=wtssall], detail
replace wtmedian = r(p50) if year==`a'
local a = `a' + 1
}
 
 
local a = 1972
gen wwtmedian=.
while `a' <=2014{
summarize F1_Adj  if year==`a' & white==1 [w=wtssall], detail
replace wwtmedian = r(p50) if year==`a'
local a = `a' + 1
}
 
local a = 1972
gen wtmedian2=.
while `a' <=2014{
summarize F2_Adj if year==`a' [w=wtssall], detail
replace wtmedian2 = r(p50) if year==`a'
local a = `a' + 1
}
 
 
local a = 1972
gen wwtmedian2=.
while `a' <=2014{
summarize F2_Adj  if year==`a' & white==1 [w=wtssall], detail
replace wwtmedian2 = r(p50) if year==`a'
local a = `a' + 1
}


gen Med_1987_F1 =.
summarize F1_Adj [w=oversamp] if year==1987, detail 
replace Med_1987_F1 = r(p50)

gen Med_1987_F2 =.
summarize F2_Adj [w=oversamp] if year==1987, detail 
replace Med_1987_F2 = r(p50)

gen Med_1987_F1W =.
summarize F1_Adj [w=oversamp] if year==1987 & white==1, detail 
replace Med_1987_F1W = r(p50)

gen Med_1987_F2W =.
summarize F2_Adj [w=oversamp] if year==1987 & white==1, detail 
replace Med_1987_F2W = r(p50)

replace wtmedian = Med_1987_F1 if year==1987
replace wtmedian2 = Med_1987_F2 if year==1987
replace wwtmedian = Med_1987_F1W if year==1987
replace wwtmedian2 = Med_1987_F2W if year==1987

/// White Median relative to the overall median
gen whitedist = wwtmedian-wtmedian
gen whitedist2 = wwtmedian2-wtmedian2

/// Distance From Median
gen Med_Dist = wtmedian-(-F1_Adj)
gen Med_Dist_F2 = wtmedian2-(-F2_Adj)

/// Constructing Implicit Racism Scale

recode racdif1 (8=.) (9=.)
recode racdif2 (2=1) (1=2) (8=.) (9=.)
recode racdif3 (8=.) (9=.)
recode racdif4 (2=1) (1=2) (8=.) (9=.)
recode wrkwayup (1=5) (2=4) (4=2) (5=1) (8=.) (9=.)

polychoric racdif1 racdif2 racdif3 racdif4  wrkwayup [pw=wtssall], pw
display r(sum_w)
matrix IRS = r(R)
factormat IRS, n(7052) factors(1) blanks(.4) ml
rotate
predict IRS_beta

zscore racdif1 racdif2 racdif3 racdif4  wrkwayup 

gen I1= racdif1*.171
gen I2= racdif2*.139
gen I3= racdif3*.167
gen I4= racdif4*.469
gen I5= wrkwayup*.238

egen I1_max1=  max(I1)   
egen I2_max2=  max(I2)    
egen I3_max3=  max(I3)
egen I4_max4=  max(I4)
egen I5_max5=  max(I5)

gen I1_MI = 1 if I1~=.
gen I2_MI = 1 if I2~=.
gen I3_MI = 1 if I3~=.
gen I4_MI = 1 if I4~=.
gen I5_MI = 1 if I5~=.

gen I1_Ind_MAX = I1_max1* I1_MI
gen I2_Ind_MAX = I2_max2* I2_MI
gen I3_Ind_MAX = I3_max3* I3_MI
gen I4_Ind_MAX = I4_max4* I4_MI
gen I5_Ind_MAX = I5_max5* I5_MI

egen IMP_Ind_Max = rowtotal(I1_Ind_MAX-I5_Ind_MAX)
egen MaxIMP = max(IMP_Ind_Max)
gen Pct_MaxIMP = IMP_Ind_Max/MaxIMP

egen IMP_Score = rowtotal(I1-I5)
replace IMP_Score=. if Pct_MaxIMP<.4
replace IMP_Score= IMP_Score/Pct_MaxIMP if IMP_Score~=.

egen time = group(year)

/// WHITE DISTANCE FROM THE MEDIAN FIGURE

twoway scatter whitedist year if year>1982 , xlabel(1982(4)2014) || lfit whitedist year, xtitle(Year) ytitle(Distance from Overall Median) legend(off) title(Economic)
graph save "White Distance-Econ GSS", replace
twoway scatter whitedist2 year if year>1982 , xlabel(1982(4)2014) || lfit whitedist2 year, xtitle(Year) ytitle(Distance from Overall Median) legend(off) title(Social)
graph save "White Distance-Soc GSS", replace
graph combine "White Distance-Econ GSS" "White Distance-Soc GSS", xsize(8) ysize(4)
graph export "White Distance GSS Combined.pdf", replace

gen inter1 = dwnom1_difference*Med_Dist
gen inter2 = dwnom1_difference*Med_Dist_F2
gen inter3 = IMP_Score*dwnom1_difference

rename partyid PID_7

recode PID_7 (0=6) (1=5) (2=4) (4=2) (5=1) (6=0)

label define RepDem 0 Republican 1 Democrat
label values Pres_Vote RepDem
rename income Income

/// Black Registration Data
gen Black_Reg = .
replace Black_Reg=.655 if year>=1972 & year<=1975
replace Black_Reg=.585 if year>=1976 & year<=1979
replace Black_Reg=.60 if year>=1980  & year<=1983
replace Black_Reg=.663 if year>=1984 & year<=1987
replace Black_Reg=.645 if year>=1988 & year<=1991
replace Black_Reg=.639 if year>=1992 & year<=1995
replace Black_Reg=.635 if year>=1996 & year<=1999
replace Black_Reg=.636 if year>=2000 & year<=2003
replace Black_Reg=.644 if year>=2004 & year<=2007
replace Black_Reg=.655 if year>=2008 & year<=2011
replace Black_Reg=.685 if year>=2012 & year<=2014
/// Hispanic Registration Data
gen Hisp_Reg=.
replace Hisp_Reg=.444 if year>=1972 & year<=1975
replace Hisp_Reg=.378 if year>=1976 & year<=1979
replace Hisp_Reg=.364 if year>=1980 & year<=1983
replace Hisp_Reg=.401 if year>=1984 & year<=1987
replace Hisp_Reg=.355 if year>=1988 & year<=1991
replace Hisp_Reg=.35 if year>=1992  & year<=1995
replace Hisp_Reg=.357 if year>=1996 & year<=1999
replace Hisp_Reg=.349 if year>=2000 & year<=2003
replace Hisp_Reg=.343 if year>=2004 & year<=2007
replace Hisp_Reg=.376 if year>=2008 & year<=2011
replace Hisp_Reg=.389 if year>=2012 & year<=2014
/// Black Turnout Data
gen Black_TO=.
replace Black_TO = 52.1 if year==1972
replace Black_TO = 48.7 if year==1976
replace Black_TO = 50.5 if year==1980
replace Black_TO = 55.8 if year==1984
replace Black_TO = 51.5 if year==1988
replace Black_TO = 54.1 if year==1992
replace Black_TO = 50.6 if year==1996
replace Black_TO = 53.5 if year==2000
replace Black_TO = 56.3 if year==2004
replace Black_TO = 60.8 if year==2008
replace Black_TO = 62 if year==2012
///Hipanic Turnout Data
gen Hisp_TO = .
replace Hisp_TO = 37.5 if year==1972
replace Hisp_TO = 31.8 if year==1976
replace Hisp_TO = 29.9 if year==1980
replace Hisp_TO = 32.7 if year==1984
replace Hisp_TO = 28.8 if year==1988
replace Hisp_TO = 28.9 if year==1992
replace Hisp_TO = 26.8 if year==1996
replace Hisp_TO = 27.5 if year==2000
replace Hisp_TO = 28   if year==2004
replace Hisp_TO = 31.6 if year==2008
replace Hisp_TO = 31.8 if year==2012
/// gen AA Dem_Proportion
gen AA_Proportion =.
replace AA_Proportion = .23 if year>=1972 & year<=1975
replace AA_Proportion = .17 if year>=1976 & year<=1979
replace AA_Proportion = .23 if year>=1980 & year<=1983
replace AA_Proportion = .21 if year>=1984 & year<=1987
replace AA_Proportion = .18 if year>=1988 & year<=1991
replace AA_Proportion = .18 if year>=1992 & year<=1995
replace AA_Proportion = .16 if year>=1996 & year<=1999
replace AA_Proportion = .19 if year>=2000 & year<=2003
replace AA_Proportion = .21 if year>=2004 & year<=2007
replace AA_Proportion = .26 if year>=2008 & year<=2011
replace AA_Proportion = .28 if year>=2012 & year<=2014
/// gen Hispanic Dem_Proportion
gen Lat_Proportion =.
replace Lat_Proportion = .05 if year>=1972 & year<=1975
replace Lat_Proportion = .05 if year>=1976 & year<=1979
replace Lat_Proportion = .05 if year>=1980 & year<=1983
replace Lat_Proportion = .07 if year>=1984 & year<=1987
replace Lat_Proportion = .10 if year>=1988 & year<=1991
replace Lat_Proportion = .07 if year>=1992 & year<=1995
replace Lat_Proportion = .11 if year>=1996 & year<=1999
replace Lat_Proportion = .09 if year>=2000 & year<=2003
replace Lat_Proportion = .13 if year>=2004 & year<=2007
replace Lat_Proportion = .15 if year>=2008 & year<=2011
replace Lat_Proportion = .17 if year>=2012 & year<=2014

/// Total VAP
gen Total_Pop = . 
replace Total_Pop = 136203 if year>=1972 & year<=1975
replace Total_Pop = 146548 if year>=1976 & year<=1979
replace Total_Pop = 157085 if year>=1980 & year<=1983
replace Total_Pop = 169963 if year>=1984 & year<=1987
replace Total_Pop = 178098 if year>=1988 & year<=1991
replace Total_Pop = 185684 if year>=1992 & year<=1995
replace Total_Pop = 193651 if year>=1996 & year<=1999
replace Total_Pop = 202609 if year>=2000 & year<=2003
replace Total_Pop = 215694 if year>=2004 & year<=2007
replace Total_Pop = 225499 if year>=2008 & year<=2011
replace Total_Pop = 235248 if year>=2012 & year<=2014
/// Total Number of Registered voters
gen Total_Reg = . 
replace Total_Reg = 136203*.723 if year>=1972 & year<=1975
replace Total_Reg = 146548*.667 if year>=1976 & year<=1979
replace Total_Reg = 157085*.669 if year>=1980 & year<=1983
replace Total_Reg = 169963*.683 if year>=1984 & year<=1987
replace Total_Reg = 178098*.666 if year>=1988 & year<=1991
replace Total_Reg = 185684*.682 if year>=1992 & year<=1995
replace Total_Reg = 193651*.659 if year>=1996 & year<=1999
replace Total_Reg = 202609*.639 if year>=2000 & year<=2003
replace Total_Reg = 215694*.659 if year>=2004 & year<=2007
replace Total_Reg = 225499*.649 if year>=2008 & year<=2011
replace Total_Reg = 235248*.651 if year>=2012 & year<=2014
/// Group Size, AA
gen AA_GS = .
replace AA_GS = .11 if year>=1972 & year<=1975
replace AA_GS = .11 if year>=1976 & year<=1979
replace AA_GS = .12 if year>=1980 & year<=1983
replace AA_GS = .12 if year>=1984 & year<=1987
replace AA_GS = .12 if year>=1988 & year<=1991
replace AA_GS = .12 if year>=1992 & year<=1995
replace AA_GS = .12 if year>=1996 & year<=1999
replace AA_GS = .13 if year>=2000 & year<=2003
replace AA_GS = .13 if year>=2004 & year<=2007
replace AA_GS = .13 if year>=2008 & year<=2011
replace AA_GS = .13 if year>=2012 & year<=2014
/// Group Size, Latino
gen LAT_GS = .
replace LAT_GS = .05 if year>=1972 & year<=1975
replace LAT_GS = .06 if year>=1976 & year<=1979
replace LAT_GS = .06 if year>=1980 & year<=1983
replace LAT_GS = .07 if year>=1984 & year<=1987
replace LAT_GS = .08 if year>=1988 & year<=1991
replace LAT_GS = .09 if year>=1992 & year<=1995
replace LAT_GS = .11 if year>=1996 & year<=1999
replace LAT_GS = .13 if year>=2000 & year<=2003
replace LAT_GS = .14 if year>=2004 & year<=2007
replace LAT_GS = .16 if year>=2008 & year<=2011
replace LAT_GS = .18 if year>=2012 & year<=2014

/// Group Size, WHITE
gen WHITE_GS = .
replace WHITE_GS = .83 if year>=1972 & year<=1975
replace WHITE_GS = .81 if year>=1976 & year<=1979
replace WHITE_GS = .80 if year>=1980 & year<=1983
replace WHITE_GS = .78 if year>=1984 & year<=1987
replace WHITE_GS = .77 if year>=1988 & year<=1991
replace WHITE_GS = .76 if year>=1992 & year<=1995
replace WHITE_GS = .73 if year>=1996 & year<=1999
replace WHITE_GS = .70 if year>=2000 & year<=2003
replace WHITE_GS = .67 if year>=2004 & year<=2007
replace WHITE_GS = .64 if year>=2008 & year<=2011
replace WHITE_GS = .63 if year>=2012 & year<=2014

gen total_AA = Total_Pop*AA_GS
gen total_AA_REG = total_AA*Black_Reg

gen total_LAT = Total_Pop*LAT_GS
gen total_LAT_REG = total_LAT*Hisp_Reg

gen Minority_Prop = (total_AA_REG+total_LAT_REG)/Total_Reg
replace Minority_Prop = Minority_Prop * 100

bysort year: egen Mean_Dem_Support = mean(Pres_Vote)

save "Zingher JOP 2017 GSS.dta", replace
xtset year

/// Base Equation--Vote Choice

probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= wtssall]  , robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  replace
estimates save Vote_Choice, replace
probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support IMP_Score if year>=1971 & white==1 [pweight= wtssall]  , robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  append
probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ  dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support IMP_Score inter3 if year>=1971 & white==1 [pweight= wtssall]  , robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  append
probit Pres_Vote Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support IMP_Score inter3 Minority_Prop if year>=1971 & white==1 [pweight= wtssall]  , robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) e(r2_p)  append


/// Base Equation--PID
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= wtssall], robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) append
estimates save Partisanship, replace
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support IMP_Score if year>=1971 & white==1 [pweight= wtssall], robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) append
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support IMP_Score inter3 if year>=1971 & white==1 [pweight= wtssall], robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) append
regress PID_7 Med_Dist Med_Dist_F2 white_southerner female Income age weeklychurch Catholic Jew Union educ dwnom1_difference inter1 inter2 policy_mood Mean_Dem_Support IMP_Score inter3 Minority_Prop if year>=1971 & white==1 [pweight= wtssall], robust
outreg2 using table1A, auto(2) alpha(.05) dec(2) symbol(*) append

#delimit ; 
regress PID_7 c.Med_Dist##c.dwnom1_difference c.Med_Dist_F2##c.dwnom1_difference  white_southerner female Income age weeklychurch Catholic Jew Union educ  policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= wtssall], robust;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(Med_Dist) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(0(.2)-1, format(%9.2fc)  axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID - Econ")
        name(Panel_`name', replace) 
		;
		graph save "Econ PID GSS", replace;
		;

		#delimit cr
		
		#delimit ; 
		
regress PID_7 c.Med_Dist##c.dwnom1_difference c.Med_Dist_F2##c.dwnom1_difference  white_southerner female Income age weeklychurch Catholic Jew Union educ  policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= wtssall], robust;
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(Med_Dist_F2) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(0(.2)-1, format(%9.2fc)  axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("PID - Social")
        name(Panel_`name', replace) 
		;
		graph save "Social PID GSS", replace;
		;

		#delimit cr
		
/// Figures IMP--Vote Choice

		#delimit ; 
		
probit Pres_Vote c.Med_Dist##c.dwnom1_difference c.Med_Dist_F2##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew Union educ policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= wtssall]  , robust;		
		
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(Med_Dist) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ; 

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(0(.05).25, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice - Econ")
		;
		graph save "Vote Choice - Econ GSS", replace;
		;

		#delimit cr
		
				#delimit ; 
		
probit Pres_Vote c.Med_Dist##c.dwnom1_difference c.Med_Dist_F2##c.dwnom1_difference white_southerner female Income age weeklychurch Catholic Jew Union educ policy_mood Mean_Dem_Support if year>=1971 & white==1 [pweight= wtssall]  , robust;		
		
		sum dwnom1_difference if e(sample) ;
		local min = r(min) ;
		local max = r(max) ;
		local interval = ((`max'-`min')/10)  ;
		margins, dydx(Med_Dist_F2) at(dwnom1_difference=(`min'(`interval')`max')) vsquish ;

		#delimit ;
		marginsplot, xlabel(`min'(`interval')`max') recastci(rarea) recast(line) 
		ci1opts(color(gs14) fintensity(100) yaxis(2))   
		plot1opts(lwidth(.50) yaxis(2)) 
		xlabel(, format(%9.2fc)) 
		xdimension(dwnom1_difference)
		ylabel(0(.05).25, format(%9.2fc) axis(2))
		ytitle("Marginal Effect", axis(2))
		addplot(kdensity dwnom1_difference if e(sample), xlab(`min'(`interval')`max') xtitle(Polarization) color(gs10) lpattern(dash) yaxis(1) yscale(alt off)
		|| function y = 0.00, range(`min' `max') lwidth(.25) yaxis(2)
		)
		legend(off)
		title("")
		subtitle("Vote Choice - Social")
		;
		graph save "Vote Choice - Social", replace;
		;

		#delimit cr
		
		graph combine "Vote Choice - Econ GSS" "Vote Choice - Social" "Econ PID GSS" "Social PID GSS", xsize(6.5) 
		
		graph export "GSS Combined ME.pdf", replace 
