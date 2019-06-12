******			
****This code replicates the models in the paper "Politically Unengaged, Distrusting, and Disaffected Individuals Drive the Link Between Compulsory Voting and Invalid Balloting", by Shane P. Singh, which appears in Political Science Research and Methods.
******	
set seed 123
version 13		
use "/*file pathway*/PSRM Replication Data, Singh.dta"


******
*Install necessary add-ons
******
ssc install rd

net from http://www.stata.com/users/vwiggins
net install grc1leg



******	
*Create variable that will limit the sample to observations that are not missing on the key covariates. Exclude people living in countries with compulsory voting that are above or below age enforcement thresholds, and exlude observations in the USA and Canada and other countries that were not originally in the AmericasBarometer Grand Merged File
******	
destring year, replace
gen ageCV = .
label var ageCV "person was of CV age in Ecuador, Peru, Argentina, Bolivia, or Brazil"
replace ageCV = 1 if country == "Ecuador"  | country == "Peru"  | country == "Argentina"| country ==  "Brazil"  | country ==  "Bolivia" 
replace ageCV = 0 if country == "Ecuador" & age>64 | country == "Peru" & age>69 | country == "Argentina" & age>69 | country ==  "Brazil" & age>69 | country ==  "Brazil" & age<18 | country ==  "Bolivia" & age>69
replace ageCV = 0 if country == "Ecuador" & age<18 & year > 2008
replace ageCV = 0 if country == "Argentina" & age<18 & year > 2011
replace ageCV = 0 if country == "Bolivia"  & age<21 

reg would_spoil_or_blank age_10 educ    GDPpercapita_PPP polity_Bel cpi if ageCV ~= 0 & country~= "United States" & country~= "Canada" & country~= "Suriname" & country~= "Trinidad & Tobago" , cl(countryandyear)
gen samp_CVspoil_noUSCAN = 1 if e(sample)



******			
****Multilevel Ordered Logit Models and Associated Figures. Use "difficult" and/or nonadaptive quadrature ("intmethod(ghermite)") options to facilitate convergence.
******

**
*Model 1
**
xtlogit would_spoil_or_blank  b0.CVscale_Payne  age_10 educ  GDPpercapita_PPP polity_Bel cpi if samp_CVspoil_noUSCAN == 1, i(cntryyearnum) intmethod(ghermite)
estat ic

**
*Figure 1
**
margins, over(CVscale_Payne) atmeans predict(pu0)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(green*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(green)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Pr(Blank or Spoiled Ballot))  aspectratio(1.25) 


	 
**
*Model 2
**
melogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: ignor_disint_scale_cent,  intpoints(11)  difficult   intmethod(ghermite) 
estat ic
margins, over(CVscale_Payne) at(ignor_disint_scale_cent = (-2 -1 0 1 2)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Lack of Political Information and Interest)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-2 "1" -1 "2" 0 "3" 1 "4" 2 "5") ///
	 name(ignor_disint, replace)

	 
**
*Model 3
**
melogit would_spoil_or_blank  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: distrust_scale_cent,  intpoints(14)     intmethod(ghermite) iterate(25) 
estat ic
margins, over(CVscale_Payne) at(distrust_scale_cent = (-3 -1.5 0 1.5 3))  atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Political Distrust)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-3 "1" -1.5 "1.5" 0 "3" 1.5 "4.5" 3 "7") ///
	 name(distrust, replace)
	
	
	
**
*Model 4
**
melogit would_spoil_or_blank  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: negative_orient_dem_scale_cent,  intpoints(11)     intmethod(ghermite) 
estat ic
margins, over(CVscale_Payne) at(negative_orient_dem_scale_cent = (-2 -1 0 1 2)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Negative Orientation Toward Democracy)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-2 "1" -1 "2" 0 "3" 1 "4" 2 "5") ///
	 name(negative_orient_dem, replace)
	 
	 
**
*Figure 2: Use Graph Editor to change offset for legend's y-axis to 24 and overall y-axis offset to -23
**
grc1leg  ignor_disint distrust  negative_orient_dem ///
	, rows(1) ysize(5.5) xsize(5.5) scale(.7) ycommon graphregion(margin(zero)) scheme(s1color)  

**
*Model 5: Use QR decomposition and two integration points to achieve convergence
**
meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  b0.CVscale_Payne##c.distrust_scale_cent  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean distrust_scale_mean negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: ignor_disint_scale_cent distrust_scale_cent negative_orient_dem_scale_cent,  intpoints(2)  difficult   
estat ic



******			
****Regression Discontinuity Models
******
*create a variable that takes the cutoff to be one year above the cutoff age---that is, set this value to 0, as per the way the rd package works
gen age_rd = age-71 if country~="Ecuador"
replace age_rd = age-66 if country=="Ecuador"

***Ignorance and Disinterest	
*get 25th and 75th percentiles
sum ignor_disint_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Ignorance and Disinterest in countries with thresholds.  
rd  would_spoil_or_blank  age_rd if ignor_disint_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_ignor_disint_scale_low, replace

*run an RD model for those high on Ignorance and Disinterest in countries with thresholds
rd  would_spoil_or_blank  age_rd if ignor_disint_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_ignor_disint_scale_high, replace


***Distrust in Democratic Institutions and Actors	
*get 25th and 75th percentiles

sum distrust_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Distrust in Democratic Institutions and Actors in countries with thresholds.  
rd  would_spoil_or_blank  age_rd if distrust_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_distrust_scale_low, replace

*run an RD model for those high on Distrust in Democratic Institutions and Actors in countries with thresholds
rd  would_spoil_or_blank  age_rd if distrust_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_distrust_scale_high, replace



***Negative Orientations toward Democracy	
*get 25th and 75th percentiles
sum negative_orient_dem_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Negative Orientations toward Democracy in countries with thresholds. 
rd  would_spoil_or_blank  age_rd if negative_orient_dem_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_negative_orient_dem_scale_low, replace

*run an RD model for those high on Negative Orientations toward Democracy in countries with thresholds
rd  would_spoil_or_blank  age_rd if negative_orient_dem_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_negative_orient_dem_scale_high, replace

**
*Figure 3: Use Graph Editor after combining to improve aesthetics. These graphs correspond to the estimations that double the size of the Imbens and Kalyanaraman optimal window (these are appended with "200").
**
graph combine ///
	"rd_ignor_disint_scale_low.gph" ///
	"rd_ignor_disint_scale_high.gph" ///
	"rd_distrust_scale_low.gph" ///
	"rd_distrust_scale_high.gph" ///
	"rd_negative_orient_dem_scale_low.gph" ///
	"rd_negative_orient_dem_scale_high.gph" ///
	, rows(3) ysize(7) xsize(5) iscale(.55) scale(1) xcommon ycommon graphregion(margin(zero)) scheme(s1color)  	 
	 

	 
	 
