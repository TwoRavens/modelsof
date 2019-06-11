******			
****This code replicates the models in the appendix to the paper "Politically Unengaged, Distrusting, and Disaffected Individuals Drive the Link Between Compulsory Voting and Invalid Balloting", by Shane P. Singh, which appears in Political Science Research and Methods.
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
*Table A1
******	
tabstat  CVscale_Payne would_spoil_or_blank if samp_CVspoil_noUSCAN==1, statistics(mean) columns(variables)    by(country) 


******	
*Table A2
******
*AmericasBarometer
tabstat would_spoil_or_blank spoiled_or_blanked  dont_understa lack_of_polinf no_interest  dont_trust_gov dont_trust_congress  dont_trust_elec dem_not_matter leaders_dont_ dissatisfaction ignor_disint_scale distrust_scale negative_orient_dem_scale age_10 educ ideo urban   GDPpercapita_PPP  polity_Bel cpi    if samp_CVspoil_noUSCAN == 1 /// 
	, statistics(mean sd min max) columns(statistics)   casewise 
	

save "/*file pathway*/PSRM Replication Data, Singh.dta"
	

*Latinobarometer
use "/*file pathway*/PSRM Replication Data, Latinobarometer, Singh", clear

tabstat wouldspoilorblank  lackinterest donttrustgov donttrustcong demnotmatter dissatisfaction age_10 educ    gdppercappppWB_thou  polity cpi ///
	, statistics(mean sd min max) columns(statistics)   casewise 
	
	
use "/*file pathway*/PSRM Replication Data, Singh.dta", clear
	
	
******	
*Figure A1
******		
*get means of each variable within surveys
tabulate countryandyear, gen(cntryyeardummy)

gen dont_understa_mean = . 
gen lack_of_polinf_mean = .
gen no_interest_mean = .
gen dont_trust_gov_mean = . 
gen dont_trust_cong_mean = . 
gen dont_trust_elec_mean = .
gen dem_not_matter_mean = .
gen leaders_dont_mean = . 
gen dissatisfaction_mean = . 


foreach x of varlist cntryyeardummy* {
		sum dont_understand_issues if `x' == 1 
		replace dont_understa_mean = r(mean) if `x' == 1
		sum lack_of_polinf if `x' == 1 
		replace lack_of_polinf_mean = r(mean) if `x' == 1
		sum no_interest if `x' == 1 
		replace no_interest_mean = r(mean) if `x' == 1
		sum dont_trust_gov if `x' == 1 
		replace dont_trust_gov_mean = r(mean) if `x' == 1
		sum dont_trust_congress if `x' == 1 
		replace dont_trust_cong_mean = r(mean) if `x' == 1
		sum dont_trust_elec if `x' == 1 
		replace dont_trust_elec_mean = r(mean) if `x' == 1
		sum dem_not_matter if `x' == 1 
		replace dem_not_matter_mean = r(mean) if `x' == 1
		sum leaders_dont_care if `x' == 1 
		replace leaders_dont_mean = r(mean) if `x' == 1
		sum dissatisfaction if `x' == 1 
		replace dissatisfaction_mean = r(mean) if `x' == 1
	}
	 

drop cntryyeardummy*	
	
*center each independent variable at its mean
sum dont_understand_issues if samp_CVspoil_noUSCAN == 1
gen dont_understand_issues_cent = dont_understand_issues - r(mean)

sum lack_of_polinf if samp_CVspoil_noUSCAN == 1
gen lack_of_polinf_cent = lack_of_polinf - r(mean)

sum no_interest if samp_CVspoil_noUSCAN == 1
gen no_interest_cent = no_interest - r(mean)

sum dont_trust_gov if samp_CVspoil_noUSCAN == 1
gen dont_trust_gov_cent = dont_trust_gov - r(mean)

sum dont_trust_congress if samp_CVspoil_noUSCAN == 1
gen dont_trust_congress_cent = dont_trust_congress - r(mean)

sum dont_trust_elec if samp_CVspoil_noUSCAN == 1
gen dont_trust_elec_cent = dont_trust_elec - r(mean)

sum dem_not_matter if samp_CVspoil_noUSCAN == 1
gen dem_not_matter_cent = dem_not_matter - r(mean)

sum leaders_dont_care if samp_CVspoil_noUSCAN == 1
gen leaders_dont_care_cent = leaders_dont_care - r(mean)

sum dissatisfaction if samp_CVspoil_noUSCAN == 1
gen dissatisfaction_cent = dissatisfaction - r(mean)	
	
	
meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.dont_understand_issues_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi dont_understa_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: dont_understand_issues_cent, intpoints(6)  difficult 
margins, over(CVscale_Payne) at(dont_understand_issues_cent = (-3(1)3)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Misunderstanding of Political Issues)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-3 "1" -2 "2" -1 "3" 0 "4" 1 "5" 2 "6" 3 "7") ///
	 name(dont_understa, replace)

melogit would_spoil_or_blank   b0.CVscale_Payne##c.lack_of_polinf_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi lack_of_polinf_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: lack_of_polinf_cent, intpoints(11)  difficult  
margins, over(CVscale_Payne) at(lack_of_polinf_cent = (-.33 -.08 .17 .42 .67)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Lack of Political Information)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-.33 "0"  -.08 ".25" .17 ".5" .42 ".75" .67 "1") ///
	 name(lack_of_polinf, replace)

meqrlogit would_spoil_or_blank   b0.CVscale_Payne##c.no_interest_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi no_interest_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: no_interest_cent, intpoints(6)  difficult 
margins, over(CVscale_Payne) at(no_interest_cent = (-2(1)1)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Lack of Political Interest)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-2 "1" -1 "2" 0 "3" 1 "4") ///
	 name(no_interest, replace)

meqrlogit would_spoil_or_blank   b0.CVscale_Payne##c.dont_trust_gov_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi dont_trust_gov_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: dont_trust_gov_cent, intpoints(6)  difficult 
margins, over(CVscale_Payne) at(dont_trust_gov_cent = (-3(1)3)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Distrust of Government)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-3 "1" -2 "2" -1 "3" 0 "4" 1 "5" 2 "6" 3 "7") ///
	 name(dont_trust_gov, replace) 

meqrlogit would_spoil_or_blank   b0.CVscale_Payne##c.dont_trust_congress_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi dont_trust_cong_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: dont_trust_congress_cent, intpoints(6)  difficult 
margins, over(CVscale_Payne) at(dont_trust_congress_cent = (-3.4 -2.4 -1.4 -.4 .6 1.6 2.6)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Distrust of Congress)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-3.4 "1" -2.4 "2" -1.4 "3" -.4 "4" .6 "5" 1.6 "6" 2.6 "7") ///
	 name(dont_trust_congress, replace) 

meqrlogit would_spoil_or_blank   b0.CVscale_Payne##c.dont_trust_elec_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi dont_trust_elec_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: dont_trust_elec_cent, intpoints(6)  difficult 
margins, over(CVscale_Payne) at(dont_trust_elec_cent = (-3(1)3)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Distrust of Elections)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-3 "1" -2 "2" -1 "3" 0 "4" 1 "5" 2 "6" 3 "7") ///
	 name(dont_trust_elec, replace)

meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.dem_not_matter_cent    age_10 educ  GDPpercapita_PPP polity_Bel cpi dem_not_matter_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: dem_not_matter_cent, intpoints(6)  difficult 
margins, over(CVscale_Payne) at(dem_not_matter_cent = (-.11 .89)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Belief that Democracy Does Not Matter)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-.11 "0"  .89 "1") ///
	 name(dem_not_matter, replace)

meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.leaders_dont_care_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi leaders_dont_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: leaders_dont_care_cent, intpoints(6)  difficult 
margins, over(CVscale_Payne) at(leaders_dont_care_cent =(-3.7 -2.7 -1.7 -.7 .3 1.3 2.3)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Belief that Leaders Do Not Care)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-3.7 "1" -2.7 "2" -1.7 "3" -.7 "4" .3 "5" 1.3 "6" 2.3 "7") ///
	 name(leaders_dont, replace) 

melogit would_spoil_or_blank  b0.CVscale_Payne##c.dissatisfaction_cent age_10 educ  GDPpercapita_PPP polity_Bel cpi  dissatisfaction_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: dissatisfaction_cent, intpoints(1)  intmethod(mcaghermite)  difficult 
margins, over(CVscale_Payne) at(dissatisfaction_cent = (-1.44 -.44  .56 1.56)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Dissatisfaction with Democracy)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-1.44 "1" -.44 "2"  .56 "3"  1.56 "4") ///
	 name(dissatisfaction, replace) 	
	
	
grc1leg  ///
	dont_understa ///
	lack_of_polinf ///
	no_interest ///
	dont_trust_gov ///
	dont_trust_congress ///
	dont_trust_elec ///
	dem_not_matter ///
	leaders_dont ///
	dissatisfaction ///
	, rows(3) ysize(5.5) xsize(5.5) iscale(.375) scale(1.15) ycommon graphregion(margin(zero)) scheme(s1color)  ///
		saving(Figure_A1)
*Use Graph Editor to change y-size to 5.5. Also change legend "keys" to "tiny" and "labels" to "vsmall".


******	
*Figure A2
******	
meqrlogit would_spoil_or_blank  b0.CVscale_Payne  age_10 educ  GDPpercapita_PPP polity_Bel cpi if samp_CVspoil_noUSCAN == 1 || country: || countryandyear:, intpoints(2)  difficult
margins, over(CVscale_Payne) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(green*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(green)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Pr(Blank or Spoiled Ballot))  aspectratio(1.25) ///
		saving(Figure_A2)
	 
	 
******	
*Figure A3
******	
melogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean if samp_CVspoil_noUSCAN == 1 || country: || countryandyear: ignor_disint_scale_cent,  intpoints(2)  difficult 
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
	 name(ignor_disint_A3, replace)


meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean if samp_CVspoil_noUSCAN == 1 || country: || countryandyear: distrust_scale_cent,  intpoints(11)  difficult   
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
	 name(distrust_A3, replace)


melogit would_spoil_or_blank  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1 || country: || countryandyear: negative_orient_dem_scale_cent,  intpoints(4)  difficult
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
	 name(negative_orient_dem_A3, replace)



grc1leg  ignor_disint_A3 distrust_A3  negative_orient_dem_A3 ///
	, rows(1) ysize(5.5) xsize(5.5) scale(.7) ycommon graphregion(margin(zero)) scheme(s1color)   ///
		saving(Figure_A3)
*Use Graph Editor to change offset for legend's y-axis to 24 and overall y-axis offset to -23
	 

	 
******	
*Figure A4
******	
xtlogit would_spoil_or_blank  b0.CVscale_Payne  age_10 educ  GDPpercapita_PPP polity_Bel cpi if samp_CVspoil_noUSCAN == 1  & would_abstain~=1, i(cntryyearnum) intmethod(ghermite)
margins, over(CVscale_Payne) atmeans predict(pu0)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(green*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(green)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Pr(Blank or Spoiled Ballot))  aspectratio(1.25)   ///
		saving(Figure_A4)

	

******	
*Figure A5
******	
melogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean if samp_CVspoil_noUSCAN == 1  & would_abstain~=1  || countryandyear: ignor_disint_scale_cent,  intpoints(11)  difficult
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
	 name(ignor_disint_A5, replace)
	 

melogit would_spoil_or_blank  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean if samp_CVspoil_noUSCAN == 1  & would_abstain~=1  || countryandyear: distrust_scale_cent,  intpoints(3)  difficult
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
	 name(distrust_A5, replace)
	 

melogit would_spoil_or_blank  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1  & would_abstain~=1  || countryandyear: negative_orient_dem_scale_cent,  intpoints(5)  difficult
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
	 name(negative_orient_dem_A5, replace) 


grc1leg  ignor_disint_A5 distrust_A5  negative_orient_dem_A5 ///
	, rows(1) ysize(5.5) xsize(5.5) scale(.7) ycommon graphregion(margin(zero)) scheme(s1color)   ///
		saving(Figure_A5)
*Use Graph Editor to change offset for legend's y-axis to 24 and overall y-axis offset to -23

	

******	
*Figures A6 and A7
******	
gen intended_vote = .
replace intended_vote = 1 if vb20 == 2
replace intended_vote = 1 if vb20 == 3
replace intended_vote = 2 if vb20 == 1
replace intended_vote = 3 if vb20 == 4
replace intended_vote = . if vb20 == .c | vb20 == .b
label var intended_vote "multinomial categorization of intended vote, lumping opp. and inc. voting together"

label define vote_choice 1 "Voted" 2 "Abstained" 3 "Spoiled or Blank" , replace
label values intended_vote vote_choice

*get rid of countries where vb20 is included but blank/spoiled wasn't a question option
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum would_spoil_or_blank if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

replace intended_vote = . if included == 0

drop included cntryyeardummy*

*Figure A6
mlogit intended_vote  b0.CVscale_Payne  age_10 educ  GDPpercapita_PPP polity_Bel cpi if samp_CVspoil_noUSCAN == 1, cl(cntryyearnum) 	
margins, over(CVscale_Payne) atmeans predict(outcome(3)) 
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(green*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(green)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Pr(Blank or Spoiled Ballot))  aspectratio(1.25)  ///
		saving(Figure_A6)
		


*Figure A7
mlogit intended_vote  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi  if samp_CVspoil_noUSCAN == 1 , cl(cntryyearnum) 
margins, over(CVscale_Payne) at(ignor_disint_scale_cent = (-2 -1 0 1 2)) atmeans predict(outcome(3)) 
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
	 name(ignor_disint_A7, replace) 


mlogit intended_vote  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi  if samp_CVspoil_noUSCAN == 1 , cl(cntryyearnum)   
margins, over(CVscale_Payne) at(distrust_scale_cent = (-3 -1.5 0 1.5 3)) atmeans predict(outcome(3)) 
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
	 name(distrust_A7, replace)

	
mlogit intended_vote  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi  if samp_CVspoil_noUSCAN == 1  , cl(cntryyearnum)  
margins, over(CVscale_Payne) at(negative_orient_dem_scale_cent = (-2 -1 0 1 2)) atmeans predict(outcome(3)) 
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
	 name(negative_orient_dem_A7, replace) 


grc1leg  ignor_disint_A7 distrust_A7  negative_orient_dem_A7 ///
	, rows(1) ysize(5.5) xsize(5.5) scale(.7) ycommon graphregion(margin(zero)) scheme(s1color)   ///
		saving(Figure_A7)
*Use Graph Editor to change offset for legend's y-axis to 24 and overall y-axis offset to -23
		


******	
*Figure A8
******	
xtlogit spoiled_or_blanked  b0.CVscale_Payne  age_10 educ  GDPpercapita_PPP polity_Bel cpi if samp_CVspoil_noUSCAN == 1, i(cntryyearnum) intmethod(ghermite)
margins, over(CVscale_Payne) atmeans predict(pu0)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(green*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(green)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Pr(Blank or Spoiled Ballot))  aspectratio(1.25)  ///
		saving(Figure_A8)

	

******	
*Figure A9
******	

melogit spoiled_or_blanked  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean if samp_CVspoil_noUSCAN == 1    || countryandyear: ignor_disint_scale_cent,  intpoints(3) intmethod(mcaghermite)  difficult   
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
	 name(ignor_disint_A9, replace) 


melogit spoiled_or_blanked  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean if samp_CVspoil_noUSCAN == 1    || countryandyear: distrust_scale_cent,  intpoints(1) intmethod(mcaghermite) difficult   
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
	 name(distrust_A9, replace)

melogit spoiled_or_blanked  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1    || countryandyear: negative_orient_dem_scale_cent,  intpoints(5)  difficult   
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
	 name(negative_orient_dem_A9, replace) 
	 

grc1leg  ignor_disint_A9 distrust_A9  negative_orient_dem_A9 ///
	, rows(1) ysize(5.5) xsize(5.5) scale(.7) ycommon graphregion(margin(zero)) scheme(s1color)  ///
		saving(Figure_A9)
*Use Graph Editor to change offset for legend's y-axis to 24 and overall y-axis offset to -23

	
******	
*Figure A10
******	
sum ideo if samp_CVspoil_noUSCAN == 1
gen ideo_cent = ideo - r(mean)

meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  b0.CVscale_Payne##c.age_10_cent b0.CVscale_Payne##c.educ  b0.CVscale_Payne##c.urban b0.CVscale_Payne##c.ideo_cent GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: ignor_disint_scale_cent age_10_cent educ urban ideo_cent,  intpoints(1)  difficult   
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
	 name(ignor_disint_A10, replace) 

meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.distrust_scale_cent  b0.CVscale_Payne##c.age_10_cent b0.CVscale_Payne##c.educ  b0.CVscale_Payne##c.urban b0.CVscale_Payne##c.ideo_cent  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: distrust_scale_cent age_10_cent educ urban ideo_cent,  intpoints(1)  difficult   
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
	 name(distrust_A10, replace)

meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  b0.CVscale_Payne##c.age_10_cent b0.CVscale_Payne##c.educ  b0.CVscale_Payne##c.urban b0.CVscale_Payne##c.ideo_cent GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: negative_orient_dem_scale_cent age_10_cent educ urban ideo_cent,  intpoints(1)  difficult   
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
	 name(negative_orient_dem_A10, replace) 

grc1leg  ignor_disint_A10 distrust_A10  negative_orient_dem_A10 ///
	, rows(1) ysize(5.5) xsize(5.5) scale(.7) ycommon graphregion(margin(zero)) scheme(s1color)  ///
		saving(Figure_A10) 
*Use Graph Editor to change offset for legend's y-axis to 24 and overall y-axis offset to -23

		
******	
*Figure A11
******	
meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean if samp_CVspoil_noUSCAN == 1 & country ~= "Ecuador"  || countryandyear: ignor_disint_scale_cent ,  intpoints(1)  difficult   
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
	 name(ignor_disint_A11, replace) 

meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean if samp_CVspoil_noUSCAN == 1 & country ~= "Ecuador"  || countryandyear: distrust_scale_cent ,  intpoints(1)  difficult 
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
	 name(distrust_A11, replace)

meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1 & country ~= "Ecuador"  || countryandyear: negative_orient_dem_scale_cent ,  intpoints(1)  difficult 
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
	 name(negative_orient_dem_A11, replace) 

grc1leg  ignor_disint_A11 distrust_A11  negative_orient_dem_A11 ///
	, rows(1) ysize(5.5) xsize(5.5) scale(.7) ycommon graphregion(margin(zero)) scheme(s1color)   ///
		saving(Figure_A11) 
*Use Graph Editor to change offset for legend's y-axis to 24 and overall y-axis offset to -23

		
******	
*Table A3
******	
*Model A1	
xtlogit would_spoil_or_blank  b0.CVscale_Payne  age_10 educ_cont_0_10  GDPpercapita_PPP polity_Bel cpi if samp_CVspoil_noUSCAN == 1, i(cntryyearnum) intmethod(ghermite)
estat ic

*Model A2	
melogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ_cont_0_10  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: ignor_disint_scale_cent,  intpoints(11)  difficult  
estat ic

*Model A3	
melogit would_spoil_or_blank  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ_cont_0_10  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: distrust_scale_cent,  intpoints(11)  difficult 
estat ic

*Model A4	
melogit would_spoil_or_blank  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ_cont_0_10  GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: negative_orient_dem_scale_cent,  intpoints(5)  difficult  
estat ic

*Model A5
meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  b0.CVscale_Payne##c.distrust_scale_cent  b0.CVscale_Payne##c.negative_orient_dem_scale_cent  age_10 educ_cont_0_10  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean distrust_scale_mean negative_orient_dem_scale_mean if samp_CVspoil_noUSCAN == 1  || countryandyear: ignor_disint_scale_cent distrust_scale_cent negative_orient_dem_scale_cent,  intpoints(2)  difficult   
estat ic
	 
******	
*Table A4
******	
*Impute the data. Do it twice. Once for countries where the trust questions were not asked, and a second time for countries where they were.


*First, go through for country-years without the distrust scale
*Drop country-years that were missing completely on needed variables
*make a variable that identifies countries where invalid balloting question was asked
preserve

tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum would_spoil_or_blank if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included


*make a variable that identifies countries where no cpi info
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum cpi if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included

*make a variable that identifies countries where no GDP info
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum GDPpercapita_PPP if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included

*make a variable that identifies countries where no Polity info
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum polity_Bel if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included

mi set mlong

gen neg_orient_dem_scale_cent = negative_orient_dem_scale_cent //*shorten variable name to prevent error message
mi register imputed  would_spoil_or_blank age_10 educ  ignor_disint_scale_cent    neg_orient_dem_scale_cent  
mi impute chained   (logit) would_spoil_or_blank  educ (regress) age_10  ignor_disint_scale_cent    neg_orient_dem_scale_cent, rseed(123) add(20) augment by(countryandyear) 

save "imputed LAPOP_without_distrust.dta"
restore


*Second, go through for country-years with the distrust scale
***Drop country-years that were missing completely on needed variables
*make a variable that identifies countries where invalid balloting question was asked
preserve

tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum would_spoil_or_blank if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included


*make a variable that identifies countries where no cpi info
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum cpi if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included

*make a variable that identifies countries where no GDP info
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum GDPpercapita_PPP if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included

*make a variable that identifies countries where no Polity info
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum polity_Bel if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included


*make a variable that identifies countries where there was info for distrust scale
tabulate countryandyear, gen(cntryyeardummy)
gen included = .
foreach x of varlist cntryyeardummy* {
	sum distrust_scale_cent if `x' == 1
	replace included =  r(mean) if `x' == 1
	}

	drop  cntryyeardummy*

drop if included==.
drop included

mi set mlong

gen neg_orient_dem_scale_cent = negative_orient_dem_scale_cent
mi register imputed  would_spoil_or_blank age_10 educ  ignor_disint_scale_cent  distrust_scale_cent  neg_orient_dem_scale_cent  
mi impute chained   (logit) would_spoil_or_blank  educ (regress) age_10  ignor_disint_scale_cent  distrust_scale_cent  neg_orient_dem_scale_cent, rseed(123) add(20) augment by(countryandyear) //*impute specifying logit for the dichotomous variables and OLS for the others

save "imputed LAPOP_with_distrust.dta"

restore


*Run the  MI models
*First, for country-years without the distrust scale
preserve

use "imputed LAPOP_without_distrust.dta", clear

*Model A6	
mi estimate, dots post: xtlogit would_spoil_or_blank  b0.CVscale_Payne  age_10 educ  GDPpercapita_PPP polity_Bel cpi , i(cntryyearnum) intmethod(ghermite)

*Model A7	
mi estimate, dots post: melogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean   || countryandyear: ignor_disint_scale_cent,  intpoints(11)  difficult   

*Model A9	 
mi estimate, dots post: melogit would_spoil_or_blank  b0.CVscale_Payne##c.neg_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi negative_orient_dem_scale_mean   || countryandyear: neg_orient_dem_scale_cent,  intpoints(5)  difficult   

restore
	 

*Second, for country-years with the distrust scale
preserve

use "imputed LAPOP_with_distrust.dta", clear

*Model A8		 
mi estimate, dots post: melogit would_spoil_or_blank  b0.CVscale_Payne##c.distrust_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi distrust_scale_mean   || countryandyear: distrust_scale_cent,  intpoints(11)  difficult   

*Model A10 	 
mi estimate, dots post: meqrlogit would_spoil_or_blank  b0.CVscale_Payne##c.ignor_disint_scale_cent  b0.CVscale_Payne##c.distrust_scale_cent  b0.CVscale_Payne##c.neg_orient_dem_scale_cent  age_10 educ  GDPpercapita_PPP polity_Bel cpi ignor_disint_scale_mean distrust_scale_mean negative_orient_dem_scale_mean  || countryandyear: ignor_disint_scale_cent distrust_scale_cent neg_orient_dem_scale_cent,  intpoints(3)  difficult 

restore


******	
*Figures A12 and A13
******	
*Artificially Low Placebo Age Thresholds

*Ignorance and Disinterest	
*get 25th and 75th percentiles
sum ignor_disint_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Ignorance and Disinterest in countries with thresholds.  
rd  would_spoil_or_blank  age_rd_placebo_10below if ignor_disint_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_ignor_disint_scale_low, replace

*run an RD model for those high on Ignorance and Disinterest in countries with thresholds
rd  would_spoil_or_blank  age_rd_placebo_10below if ignor_disint_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_ignor_disint_scale_high, replace


*Distrust in Democratic Institutions and Actors	
*get 25th and 75th percentiles

sum distrust_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Distrust in Democratic Institutions and Actors in countries with thresholds.  
rd  would_spoil_or_blank  age_rd_placebo_10below if distrust_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_distrust_scale_low, replace

*run an RD model for those high on Distrust in Democratic Institutions and Actors in countries with thresholds
rd  would_spoil_or_blank  age_rd_placebo_10below if distrust_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_distrust_scale_high, replace



*Negative Orientations toward Democracy	
*get 25th and 75th percentiles
sum negative_orient_dem_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Negative Orientations toward Democracy in countries with thresholds. 
rd  would_spoil_or_blank  age_rd_placebo_10below if negative_orient_dem_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_negative_orient_dem_scale_low, replace

*run an RD model for those high on Negative Orientations toward Democracy in countries with thresholds
rd  would_spoil_or_blank  age_rd_placebo_10below if negative_orient_dem_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_negative_orient_dem_scale_high, replace


*Figure A12: Use Graph Editor after combining to improve aesthetics. These graphs correspond to the estimations that double the size of the Imbens and Kalyanaraman optimal window (these are appended with "200").

graph combine ///
	"rd_ignor_disint_scale_low.gph" ///
	"rd_ignor_disint_scale_high.gph" ///
	"rd_distrust_scale_low.gph" ///
	"rd_distrust_scale_high.gph" ///
	"rd_negative_orient_dem_scale_low.gph" ///
	"rd_negative_orient_dem_scale_high.gph" ///
	, rows(3) ysize(7) xsize(5) iscale(.55) scale(1) xcommon ycommon graphregion(margin(zero)) scheme(s1color)  	 ///
		saving(Figure_A12)  
	 

*Artificially High Placebo Age Thresholds

*Ignorance and Disinterest	
*get 25th and 75th percentiles
sum ignor_disint_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Ignorance and Disinterest in countries with thresholds.  
rd  would_spoil_or_blank  age_rd_placebo_10above if ignor_disint_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_ignor_disint_scale_low, replace

*run an RD model for those high on Ignorance and Disinterest in countries with thresholds
rd  would_spoil_or_blank  age_rd_placebo_10above if ignor_disint_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_ignor_disint_scale_high, replace


*Distrust in Democratic Institutions and Actors	
*get 25th and 75th percentiles

sum distrust_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Distrust in Democratic Institutions and Actors in countries with thresholds.  
rd  would_spoil_or_blank  age_rd_placebo_10above if distrust_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_distrust_scale_low, replace

*run an RD model for those high on Distrust in Democratic Institutions and Actors in countries with thresholds
rd  would_spoil_or_blank  age_rd_placebo_10above if distrust_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_distrust_scale_high, replace



*Negative Orientations toward Democracy	
*get 25th and 75th percentiles
sum negative_orient_dem_scale, detail
global p25 = r(p25)
global p75 = r(p75)

*run an RD model for those low on Negative Orientations toward Democracy in countries with thresholds. 
rd  would_spoil_or_blank  age_rd_placebo_10above if negative_orient_dem_scale<$p25  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_negative_orient_dem_scale_low, replace

*run an RD model for those high on Negative Orientations toward Democracy in countries with thresholds
rd  would_spoil_or_blank  age_rd_placebo_10above if negative_orient_dem_scale>$p75  & (country == "Peru" | country == "Bolivia" | country == "Brazil" | country == "Ecuador" | country == "Argentina") , gr noscatter mbw(200)
graph save rd_negative_orient_dem_scale_high, replace


*Figure A13: Use Graph Editor after combining to improve aesthetics. These graphs correspond to the estimations that double the size of the Imbens and Kalyanaraman optimal window (these are appended with "200").

graph combine ///
	"rd_ignor_disint_scale_low.gph" ///
	"rd_ignor_disint_scale_high.gph" ///
	"rd_distrust_scale_low.gph" ///
	"rd_distrust_scale_high.gph" ///
	"rd_negative_orient_dem_scale_low.gph" ///
	"rd_negative_orient_dem_scale_high.gph" ///
	, rows(3) ysize(7) xsize(5) iscale(.55) scale(1) xcommon ycommon graphregion(margin(zero)) scheme(s1color)   ///
		saving(Figure_A13) 	 
	 	 
	 
******
*Figures A14 and A15 (Latinobarometer Data)
******	
*Open Latinobarometer data and get it ready
use "/*file pathway*/PSRM Replication Data, Latinobarometer, Singh", clear

*Create variable that will limit the sample to observations that are not missing on the key covariates. Exclude people living in countries with compulsory voting that are above or below age enforcement thresholds, and exlude observations in Spain
destring year, replace
gen ageCV = .
label var ageCV "person was of CV age in Ecuador, Peru, Argentina, Bolivia, or Brazil"
replace ageCV = 1 if country == "Ecuador"  | country == "Peru"  | country == "Argentina"| country ==  "Brazil"  | country ==  "Bolivia" 
replace ageCV = 0 if country == "Ecuador" & age>64 | country == "Peru" & age>69 | country == "Argentina" & age>69 | country ==  "Brazil" & age>69 | country ==  "Brazil" & age<18 | country ==  "Bolivia" & age>69
replace ageCV = 0 if country == "Ecuador" & age<18 & year > 2008
replace ageCV = 0 if country == "Argentina" & age<18 & year > 2011
replace ageCV = 0 if country == "Bolivia"  & age<21 
replace ageCV = . if age == .
reg wouldspoilorblank   age_10 educ    gdppercappppWB_thou  polity cpi if ageCV ~= 0 & country~="Spain" , cl(country)
gen samp_CVspoil = 1 if e(sample)
	
	
*Figure A14 
xtlogit wouldspoilorblank   b0.CVscale_Payne  age_10 educ    gdppercappppWB_thou  polity cpi  if samp_CVspoil == 1, i(cntryyearnum) intmethod(ghermite)
margins, over(CVscale_Payne) atmeans predict(pu0)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)  title("") ///
	 ci1opts(color(green*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(green)) ///  
	 xlabel(0 "VV{subscript: }" 1 "CV{subscript:low}" 2 "CV{subscript:med}" 3 "CV{subscript:high}")   ///
     xtitle(Level of Compulsory Voting, margin(medsmall))  ytitle(Pr(Blank or Spoiled Ballot))  aspectratio(1.25) ///
		saving(Figure_A14)
	 

*Figure A15 
melogit wouldspoilorblank    b0.CVscale_Payne##c.lackinterest_cent  age_10 educ  gdppercappppWB_thou  polity cpi lackinterest_mean if samp_CVspoil == 1 || cntryyearnum: lackinterest_cent, intpoints(15)  intmethod(ghermite)
margins, over(CVscale_Payne) at(lackinterest_cent = (-2(1)1)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Lack of Political Interest)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-2 "1" -1 "2" 0 "3" 1 "4") ///
	 name(no_interest, replace) 

melogit wouldspoilorblank    b0.CVscale_Payne##c.donttrustgov_cent  age_10 educ  gdppercappppWB_thou  polity cpi donttrustgov_mean if samp_CVspoil == 1 || cntryyearnum: donttrustgov_cent,  intpoints(3) intmethod(ghermite) 
margins, over(CVscale_Payne) at(donttrustgov_cent = (-1.66 -.66 .34 1.34)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Distrust of Government)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-1.66 "1" -.66 "2" .34 "3" 1.34 "4") ///
	 name(dont_trust_gov, replace) 
	 

melogit wouldspoilorblank    b0.CVscale_Payne##c.donttrustcong_cent  age_10 educ  gdppercappppWB_thou  polity cpi donttrustcong_mean if samp_CVspoil == 1 || cntryyearnum: donttrustcong_cent,  intpoints(15) intmethod(ghermite)
margins, over(CVscale_Payne) at(donttrustcong_cent = (-2(1)1)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Distrust of Congress)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-2 "1" -1 "2" 0 "3" 1 "4") ///
	 name(dont_trust_congress, replace) 

melogit wouldspoilorblank    b0.CVscale_Payne##c.demnotmatter_cent  age_10 educ  gdppercappppWB_thou  polity cpi demnotmatter_mean if samp_CVspoil == 1 || cntryyearnum: demnotmatter_cent, intpoints(15)  intmethod(ghermite)
margins, over(CVscale_Payne) at(demnotmatter_cent = (-.20 .80)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Belief that Democracy Does Not Matter)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-.20 "0"  .80 "1") ///
	 name(dem_not_matter, replace) 

melogit wouldspoilorblank    b0.CVscale_Payne##c.dissatisfaction_cent  age_10 educ  gdppercappppWB_thou  polity cpi dissatisfaction_mean if samp_CVspoil == 1 || cntryyearnum: dissatisfaction_cent, intpoints(15)  intmethod(ghermite)
margins, over(CVscale_Payne) at(dissatisfaction_cent = (-1.65 -.65  .35 1.35)) atmeans predict(mu fixedonly)
marginsplot, ///
     recast(scatter) recastci(rcap) scheme(s1color)   title("") ///
	 ci1opts(color(pink*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(pink))  ///	 
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red))  ///  
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue))  ///  
	 ci4opts(color(black*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(black))  ///  
     xtitle(Dissatisfaction with Democracy)  ytitle("Pr(Blank or Spoiled Ballot)")  ///
	 legend(order(5 "VV" 6 "CV{subscript:low}" 7 "CV{subscript:med}" 8 "CV{subscript:high}") rows(1)) aspect(1) ///
	 xlabel(-1.65 "1" -.65 "2"  .35 "3"  1.35 "4") ///
	 name(dissatisfaction, replace) 

	
grc1leg  ///
	no_interest ///
	dont_trust_gov ///
	dont_trust_congress ///
	dem_not_matter ///
	dissatisfaction ///
	, rows(2) ysize(5.5) xsize(5.5) iscale(.45) scale(1.45) ycommon graphregion(margin(zero)) scheme(s1color)  ///
		saving(Figure_A15)
*Use Graph Editor to change y-size to 4.5 and x-size to 6.3. Also change legend "keys" and "labels" to "vsmall".	



