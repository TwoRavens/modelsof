***********************************************************************************
*** Description: 	This document provides the code for reproducing the 		***
***					models, figures, and in-text claims in the paper, "The 		***
***					Effects of Militarized Interstate Disputes on Incumbent 	***
***					Voting Across Genders," which is authored by Shane P. 		***
***					Singh and Jaroslav Tir and appears in Political Behavior.	***
***					It also provides code for reproducing the tables and		***
***					figures in the appendix.									***
***********************************************************************************


**************
**************
*Open the CSES Data, Which Includes Merged In Macro-Level Variables                                                                                                                         
**************
**************
*First, navigate to the folder in which the data are saved.
use "Singh_and_Tir_PB_Replication.dta", clear 
	
	
	
**************
**************
*Create a Variable That Defines the Estimation Sample                                                                                                                     
**************
**************
reg voted_inc       dispgov_centered	initiator_past1 target_past1		female		partyID_inc	 unemployed  age educ distance_inc  LR_inc  unemployment GDP_growth polity presidential propormmp enep federal hostility_dich , cl(cntryyear)
gen samp = 1 if e(sample)
	

	
**************
**************
*Model 1 of Table 1
**************
**************
xtlogit voted_inc 		i.initiator_past1		i.target_past1	female		c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1, i(cntryyearnum) intmethod(ghermite) 
estimates store Model1



**************
**************
*Model 2 of Table 1
**************
**************
xtlogit voted_inc 		i.initiator_past1##i.female 		i.target_past1##i.female			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1, i(cntryyearnum) intmethod(ghermite) 
estimates store Model2



**************
**************
*Model 3 of Table 1
**************
**************
xtlogit voted_inc 		i.initiator_past1##i.hostility_dich##i.female 	i.target_past1##i.hostility_dich##i.female 				c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	   if samp == 1, i(cntryyearnum) intmethod(ghermite) 
estimates store Model3



**************
**************
*Figure 1
**************
**************
estimates restore Model2
xtlogit
estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(initiator_past1=0 target_past1=0) predict(pu0) post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color) horizontal aspect(.05, placement(south))  ///
	 ci1opts(color(black*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(black)) scale(.5) /// 
	 title("") xline(0, lpattern(dash) lcolor(black)) ///  
	 ylabel(, nogrid labsize(small))  ///
     ytitle("")  xtitle("                {&Delta}Pr(Vote for Incumbent) if MID Onset", size(small)) ///
	 xlabel(-.15(.05).15)  ///
	 bydimension(_deriv, elabel(1 "MID Initiator" 2 "MID Target")) ///
	 byopt(title("") rows(2) noxrescale) 	subtitle( , size(small) fcolor(black*.15)) 

	

**************
**************
*Figure 2
**************
**************
estimates restore Model3
xtlogit
estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(initiator_past1=0 target_past1=0 hostility_dich=(0 1)) predict(pu0) post coeflegend
fmarginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color) horizontal aspect(.10, placement(south))  ///
	 ci1opts(color(black*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(black)) scale(.5) /// 
	 title("") xline(0, lpattern(dash) lcolor(black)) ///  
	 ylabel(, nogrid labsize(small))  ///
     ytitle("")  xtitle("                {&Delta}Pr(Vote for Incumbent) if MID Onset", size(small)) ///
	 xlabel(-.15(.05).15)  ///
	 bydimension(_deriv hostility_dich, elabel(1 "Initiator, Low Hostility Level" 2 "Initiator, High Hostility Level" 3 "Target, Low Hostility Level" 4 "Target, High Hostility Level")) ///
	 byopt(title("") rows(2) noxrescale) 	subtitle( , size(small) fcolor(black*.15))


	 
**************
**************
*Claim in text: "According to our measure, 27.41% of individuals in our sample selected the incumbent party."
**************
**************
sum voted_inc if samp ==1 



**************
**************
*Claim in text: "MID initiation, as opposed to no initiation or targeting, increases the probability of voting for the incumbent by about 1.5 percentage points (p < 0.05, two-sided), and being targeted in a MID decreases this probability by about 3.0 percentage points (p < 0.01, two-sided)."
**************
**************
estimates restore Model1
xtlogit
estimates esample: samp, replace
margins,  dydx(initiator_past1 target_past1) atmeans at(initiator_past1=0 target_past1=0) predict(pu0) 



**************
**************
*Claim in text: "To get an idea of baseline incumbent support, we examined incumbent voting rates across genders in elections 
*that were not preceded by MIDs in the previous year. We first regressed our incumbent voting measure on gender and all of the 
*control variables in countries without pre-election MIDs. From this, we calculated predicted incumbent support rates, 
*which are 27.79% for men and 28.09% for women. These predicted support rates are not statistically different from one another 
*(p = 0.46, two-sided)"
**************
**************
reg voted_inc 		i.female		c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1 & initiator_past1 ~= 1 & target_past1 ~= 1 & samp == 1, cl(countryandyear_nohyphen) 
margins, over(female) post coefleg atmeans
test _b[0bn.female] = _b[1.female]



**************
**************
*Claim in text: "With regard to low-hostility MID initiation, we uncover some unexpected evidence of a gendered effect. 
*Here, for women the boost in the probability of voting for the incumbent (7.5 percentage points) is stronger than that 
*of males (5.0 percentage points) (the difference in these effects is significant at p < 0.05, two-sided)."
**************
**************	
estimates restore Model3
xtlogit
estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(initiator_past1=0 target_past1=0 hostility_dich=(0 1)) predict(pu0) post coeflegend
test _b[1.initiator_past1:1bn._at#0bn.female] = _b[1.initiator_past1:1bn._at#1.female]



**************
**************
*Claim in text: "In the high-hostility scenario, women punish incumbents for MID initiation more so than men, 
*though both sets of citizens express proclivity to blame and punish the incumbent for initiating a MID. 
*The changes in the predicted probability of incumbent voting are -6.5 and -4.1, respectively, though it is 
*not clear that difference is statistically meaningful (p = 0.09, two-sided)."
**************
**************	
estimates restore Model3
xtlogit
estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(initiator_past1=0 target_past1=0 hostility_dich=(0 1)) predict(pu0) post coeflegend
test  _b[1.initiator_past1:2._at#0bn.female] = _b[1.initiator_past1:2._at#1.female]



**************
**************
*Claim in text: "...after low-hostility MID targeting, males become significantly less likely to vote for the incumbent, and they do so with about the 
*same probability as females (-3.7 percentage points for both genders); the two effects are not statistically different (p = 0.99, two-sided). 
*Similarly, there is no evidence of a gender-conditional effect in the situation of high-hostility MID targeting, after which both men 
*(7.7 percentage points) and women (7.3 percentage points) both become more likely to vote for the incumbent; again, the two effects 
*are not statistically different (p = 0.88, two-sided)."
**************
**************
estimates restore Model3
xtlogit
estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(initiator_past1=0 target_past1=0 hostility_dich=(0 1)) predict(pu0) post coeflegend
test _b[1.target_past1:1bn._at#0bn.female] =  _b[1.target_past1:1bn._at#1.female] //* low hostility
test  _b[1.target_past1:2._at#1.female] =  _b[1.target_past1:2._at#0bn.female] //*high hostility



**************
**************
*Claim in footnote 3: "If we remove abstainers, we find that 31.95% of those who voted chose the incumbent party."
**************
**************
sum voted_inc if samp ==1 & voted==1

	

**************
**************
*Claim in footnote 6: "In a logistic regression of incumbent voting on missingness, the two-sided p-value associated with the coefficient on missingness was 0.56."
**************
**************	 
gen missing_ideo = 0
replace missing_ideo = 1 if ideo==.
logit voted_inc missing_ideo, cl(cntryyear) 
	 
	 

**************
**************
*Claim in footnote 10: "The two-sided p-values associated with the differences in the effects of MID initiation and targeting across men and women are 0.12 and 0.96, respectively."
**************
**************	
estimates restore Model2
xtlogit
estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(initiator_past1=0 target_past1=0) predict(pu0) post coeflegend
test _b[1.initiator_past1:0bn.female] =  _b[1.initiator_past1:1.female]
test _b[1.target_past1:0bn.female] =  _b[1.target_past1:1.female]



**************
**************
*Appendix Table A1
**************
**************	
tab countryandyear_nohyphen if (initiator_past1 == 1 | target_past1 == 1) & samp == 1 

	
	
**************
**************
*Appendix Table A2
**************
**************	
tab countryandyear_nohyphen if (initiator_past1 == 1) & samp == 1 &  hostility_dich == 0 | (countryandyear_nohyphen == "United States 2004" & samp == 1) //*with initiation, low hostility, USA_2004 also had a low-hostility initiation this year but the hostility coding only uses the highest level
tab countryandyear_nohyphen if (initiator_past1 == 1) & samp == 1 &  hostility_dich == 1 //*with initiation, high hostility

tab countryandyear_nohyphen if (target_past1 == 1) & samp == 1 &  hostility_dich == 0 | (countryandyear_nohyphen == "Israel 2003" & samp == 1) //*with targeting, low hostility, ISR_2003 also had low-hostility targeting this year but the hostility coding only uses the highest level
tab countryandyear_nohyphen if (target_past1 == 1) & samp == 1 &  hostility_dich == 1 //*with targeting, high hostility



**************
**************
*Appendix Table A3
**************
**************	
tabstat voted_inc female unemployed age educ  distance_inc partyID_inc	initiator_past1	target_past1 unemployment GDP_growth polity LR_inc dispgov_uncentered  hostility_dich  if samp == 1 /// 
	, statistics(mean sd min max) columns(statistics)   casewise 

	

**************
**************
*Figure A1
**************
**************	
xtlogit voted_inc 		i.initiator_past1##i.female##c.age	 i.target_past1##i.female##c.age			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1, i(cntryyearnum) intmethod(ghermite) iterate(47)

sum age if samp==1, detail
global age_p10 = r(p10)
global age_p90 = r(p90)

estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(age = ($age_p10 $age_p90) initiator_past1=0 target_past1=0) predict(pu0) post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color) horizontal aspect(.10, placement(south)) ///
	 ci1opts(color(black*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(black)) scale(.5) /// 
	 title("") xline(0, lpattern(dash) lcolor(black)) ///
	 xlabel(-.15(.05).15)  /// 
	 ylabel(, nogrid labsize(small))  ///
     ytitle("")  xtitle("                {&Delta}Pr(Vote for Incumbent) if MID Onset", size(small)) ///
	 bydimension(_deriv age, elabel(1 "MID Initiator, Young Voter" 2 "MID Initiator, Elder Voter" 3 "MID Target, Young Voter" 4 "MID Target, Elder Voter")) ///
	 byopt(title("") rows(2) noxrescale) 	subtitle( , size(small) fcolor(black*.15))

**
*Claim about the effects shown in the figure: "Results show that MID initiation has a positive effect on incumbent voting, 
*but only for younger people, and there are no meaningful gender-related differences in this effect 
*(the two-sided p-value associated with the difference in this effect across genders is 0.23). 
*Further, when a country is targeted in a MID, younger voters punish the incumbent, regardless of gender 
*(the two-sided p-value associated with the difference in this effect across genders is 0.33).
**
test _b[1.initiator_past1:1bn._at#0bn.female] = _b[1.initiator_past1:1bn._at#1.female]
test _b[1.target_past1:1bn._at#0bn.female] =  _b[1.target_past1:1bn._at#1.female]


**************
**************
*Figure A2
**************
**************	
*first, create a dichotomous variable that captures coalition-based initiation
gen init_coal = 0 
replace init_coal = 1 if cntryyear == "ISL_1999" 
replace init_coal = 1 if cntryyear == "DEU_2002"  
replace init_coal = 1 if cntryyear == "FRA_2002"  
replace init_coal = 1 if cntryyear == "NLD_2002" 
replace init_coal = 1 if cntryyear == "PRT_2002"
replace init_coal = 1 if cntryyear == "USA_2004" 
replace init_coal = 1 if cntryyear == "USA_2008" 

gen init_noncoal = 0 
replace init_noncoal =  1 - init_coal if initiator_past1 == 1

xtlogit voted_inc 		i.init_coal##i.female 	i.init_noncoal##i.female 		i.target_past1##i.female			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.init_coal##c.dispgov_centered  i.init_noncoal##c.dispgov_centered			i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1, i(cntryyearnum) intmethod(ghermite) iterate(47)

estimates esample: samp, replace
margins ,  dydx(init_coal init_noncoal) over(female) atmeans at(init_coal=0 init_noncoal=0 target_past1=0) predict(pu0) post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color) horizontal aspect(.05, placement(south))  ///
	 ci1opts(color(black*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(black)) scale(.5) /// 
	 title("") xline(0, lpattern(dash) lcolor(black)) ///  
	 ylabel(, nogrid labsize(small))  ///
     ytitle("")  xtitle("                {&Delta}Pr(Vote for Incumbent) if MID Onset", size(small)) ///
	 xlabel(-.15(.05).15)  ///
	 bydimension(_deriv, elabel(1 "MID Initiator, in Coalition" 2 "MID Initiator, Not in Coalition" 3 "MID Target")) ///
	 byopt(title("") rows(2) noxrescale) 	subtitle( , size(small) fcolor(black*.15))

**
*Claim about the effects shown in the figure: "For coalition-based initiated MIDs, the two-sided p-value associated with 
*the difference in the effect of initiation on incumbent voting across 
*men and women is 0.41; for unilateral initiated MIDs, the corresponding p-value is 0.28."
**
test _b[1.init_coal:0bn.female] = _b[1.init_coal:1.female]
test  _b[1.init_noncoal:0bn.female] = _b[1.init_noncoal:1.female]



**************
**************
*Figure A3
**************
**************
xtlogit voted_inc 		i.initiator_past1##i.female##c.fertility_rate 		i.target_past1##i.female##c.fertility_rate			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1, i(cntryyearnum) intmethod(ghermite) iterate(47)

sum fertility_rate if samp==1, detail
global fertility_rate_p10 = r(p10)
global fertility_rate_p90 = r(p90)

estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female) atmeans at(fertility_rate = ($fertility_rate_p10 $fertility_rate_p90) initiator_past1=0 target_past1=0) predict(pu0) post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color) horizontal aspect(.10, placement(south)) ///
	 ci1opts(color(black*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(black)) scale(.5) /// 
	 title("") xline(0, lpattern(dash) lcolor(black)) ///  
	 ylabel(, nogrid labsize(small))  ///
     ytitle("")  xtitle("                {&Delta}Pr(Vote for Incumbent) if MID Onset", size(small)) ///
	 bydimension(_deriv fertility_rate, elabel(1 "MID Initiator, Low Fertility" 2 "MID Initiator, High Fertility" 3 "MID Target, Low Fertility" 4 "MID Target, High Fertility")) /// 
	 byopt(title("") rows(2) noxrescale) 	subtitle( , size(small) fcolor(black*.15)) 


**
*Claim about the effects shown in the figure: "...the differences in the effects depicted in each panel of Figure A3 are never 
*statistically different from zero at conventional levels."
**
test _b[1.initiator_past1:1bn._at#0bn.female] = _b[1.initiator_past1:1bn._at#1.female]
test _b[1.initiator_past1:2._at#0bn.female] = _b[1.initiator_past1:2._at#1.female]
test _b[1.target_past1:1bn._at#0bn.female] =  _b[1.target_past1:1bn._at#1.female]
test _b[1.target_past1:2._at#0bn.female] = _b[1.target_past1:2._at#1.female]



**************
**************
*Figure A4
**************
**************
forval i=50(100)350{
gen initiator_past1_`i' = initiator_past1
replace initiator_past1_`i' = 0 if time_since_end_initiator > `i'
}


forval i=50(100)350{
gen target_past1_`i' = target_past1
replace target_past1_`i' = 0 if time_since_end_target > `i'
}


forval i=50(100)350{
xtlogit voted_inc 		i.initiator_past1_`i'##i.female 		i.target_past1_`i'##i.female			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1_`i'##c.dispgov_centered		i.target_past1_`i'##c.dispgov_centered	  hostility_dich  if samp == 1 , i(cntryyearnum) intmethod(ghermite) iterate(99)
margins ,  dydx(initiator_past1_`i') over(female) atmeans at(initiator_past1_`i'=0 target_past1_`i'=0) predict(pu0) post coeflegend
estimates  store initiator_past1_`i' 
}

forval i=50(100)350{
xtlogit voted_inc 		i.initiator_past1_`i'##i.female 		i.target_past1_`i'##i.female			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1_`i'##c.dispgov_centered		i.target_past1_`i'##c.dispgov_centered	  hostility_dich  if samp == 1 , i(cntryyearnum) intmethod(ghermite) iterate(99)
margins ,  dydx(target_past1_`i') over(female) atmeans at(initiator_past1_`i'=0 target_past1_`i'=0) predict(pu0) post coeflegend
estimates store target_past1_`i'
}



*ssc install lincomest //*first install lincomest if needed
forval i=50(100)350{
estimates restore initiator_past1_`i'
margins
lincomest _b[1.initiator_past1_`i':0bn.female]- _b[1.initiator_past1_`i':1.female]
estimates store initiator_past1_dif_`i'
}


forval i=50(100)350{
estimates restore target_past1_`i'
margins
lincomest _b[1.target_past1_`i':0bn.female]- _b[1.target_past1_`i':1.female]
estimates store target_past1_dif_`i'
}


*ssc install coefplot //*first install coefplot if needed
coefplot 	 ///
			(initiator_past1_dif_50, mcolor(black) ciopts(lcolor(black*.5)))  (target_past1_dif_50, mcolor(red) ciopts(lcolor(red*.5))), bylabel(50 Days) ///
		||	(initiator_past1_dif_150)  (target_past1_dif_150), bylabel(150 Days) ///
		||	(initiator_past1_dif_250)  (target_past1_dif_250), bylabel(250 Days) ///
		||	(initiator_past1_dif_350)  (target_past1_dif_350), bylabel(350 Days) ///
		scheme(s1color)  title("")  ///
		xline(0, lpattern(shortdash) lcolor(black)) /// 
		grid(none) 	 xlabel(-.05(.01).05)  ylabel(none) ///
		recast(scatter)  scale(0.9)  ///
		xtitle("Difference {&Delta}Pr(Vote for Incumbent) if MID Onset," "Female minus Male", size(small))  ytitle("")  ///
		byopts(rows(4)) subtitle(, fcolor(black*.15))  ///
		legend(order(2 "MID Initiator" 4 "MID Target") rows(1) size(vsmall)) ///
		xsize(4) 

		

**************
**************
*Figure A5
**************
**************
*first, create indicator variables for country-years with multiple MIDs
gen initiator_mult = 0
replace	 initiator_mult = . if initiator_past1 == . 
replace	 initiator_mult = 1 if countryandyear_nohyphen == "Russia 1999"
replace	 initiator_mult = 1 if countryandyear_nohyphen == "United States 2004"
replace	 initiator_mult = 1 if countryandyear_nohyphen == "United States 2008"

gen target_mult = 0
replace	 target_mult = . if target_past1 == . 
replace	 target_mult = 1 if countryandyear_nohyphen == "Israel 2003"
replace	 target_mult = 1 if countryandyear_nohyphen == "Russia 1999"

xtlogit voted_inc 		i.initiator_past1##i.female i.initiator_mult 		i.target_past1##i.female i.target_mult			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1, i(cntryyearnum) intmethod(ghermite) iterate(47)

estimates esample: samp, replace
margins ,  dydx(initiator_past1 target_past1) over(female initiator_mult target_mult) atmeans at(initiator_past1=0 target_past1=0) predict(pu0) post coeflegend
marginsplot, ///
     recast(scatter) recastci(rspike) scheme(s1color) horizontal aspect(.05, placement(south))  ///
	 ci1opts(color(black*.5) lwidth(medthick))  /// 
     plot1opts(mcolor(black))  ///
	 ci2opts(color(red*.5) lwidth(medthick))  /// 
     plot2opts(mcolor(red)) ///
	 ci3opts(color(blue*.5) lwidth(medthick))  /// 
     plot3opts(mcolor(blue)) ///
	 ci4opts(color(green*.5) lwidth(medthick))  /// 
     plot4opts(mcolor(green))  ///
	 title("") xline(0, lpattern(dash) lcolor(black)) ///  
	 ylabel(, nogrid labsize(small))  ///
     ytitle("")  xtitle("                {&Delta}Pr(Vote for Incumbent) if MID Onset", size(small)) ///
	 xlabel(-.15(.05).15) scale(.5)  ///
	 bydimension(_deriv, elabel(1 "MID Initiator" 2 "MID Target")) ///
	 legend(order(5 "One Initiation or Targeting" 7 "Multiple Initiation" 6 "Multiple Targeting") rows(3) size(vsmall)) ///
	 byopt(title("") rows(2) noxrescale) 	subtitle( , size(small) fcolor(black*.15)) 

*remove logically impossible plot points
gr_edit .plotregion1.plotregion1[1].plot8.style.editstyle marker(fillcolor(none)) editcopy
gr_edit .plotregion1.plotregion1[1].plot8.style.editstyle marker(linestyle(color(none))) editcopy
gr_edit .plotregion1.plotregion1[1].plot4.style.editstyle area(linestyle(color(none))) editcopy
gr_edit .plotregion1.plotregion1[1].plot6.draw_view.setstyle, style(no)
gr_edit .plotregion1.plotregion1[1].plot2.draw_view.setstyle, style(no)
gr_edit .plotregion1.plotregion1[2].plot3.draw_view.setstyle, style(no)
gr_edit .plotregion1.plotregion1[2].plot7.draw_view.setstyle, style(no)

**
*Claim about the effects shown in the figure: "...the effects of MID initiation and targeting are never significantly different across 
*males and females."
**
test _b[1.initiator_past1:0bn.female#0bn.initiator_mult#0bn.target_mult] = _b[1.initiator_past1:1.female#0bn.initiator_mult#0bn.target_mult]
test _b[1.initiator_past1:0bn.female#1.initiator_mult#0bn.target_mult] = _b[1.initiator_past1:1.female#1.initiator_mult#0bn.target_mult]

test _b[1.target_past1:0bn.female#0bn.initiator_mult#0bn.target_mult] = _b[1.target_past1:1.female#0bn.initiator_mult#0bn.target_mult]
test _b[1.target_past1:0bn.female#0bn.initiator_mult#1.target_mult] = _b[1.target_past1:1.female#0bn.initiator_mult#1.target_mult]



**************
**************
*Figure A6
**************
**************
encode countryandyear_nohyphen if (initiator_past1 == 1 | target_past1 == 1) & samp == 1, gen(cntrynum)
sum cntrynum
global num_MIDs = r(max)


forval i=1/$num_MIDs{
xtlogit voted_inc 		i.initiator_past1##i.female 		i.target_past1##i.female			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1 & cntrynum~=`i', i(cntryyearnum) intmethod(ghermite) iterate(99)
margins ,  dydx(initiator_past1) over(female) atmeans at(initiator_past1=0 target_past1=0) predict(pu0) post coeflegend
estimates store init_not_equal_`i' 
}


forval i=1/$num_MIDs{
xtlogit voted_inc 		i.initiator_past1##i.female 		i.target_past1##i.female			c.unemployed##c.LR_inc  c.age##c.LR_inc c.educ##c.LR_inc distance_inc partyID_inc unemployment GDP_growth polity i.initiator_past1##c.dispgov_centered		i.target_past1##c.dispgov_centered	  hostility_dich  if samp == 1 & cntrynum~=`i', i(cntryyearnum) intmethod(ghermite) iterate(99)
margins ,  dydx(target_past1) over(female) atmeans at(initiator_past1=0 target_past1=0) predict(pu0) post coeflegend
estimates store targ_not_equal_`i'
}



*ssc install lincomest //*first install lincomest if needed
forval i=1/$num_MIDs{
estimates use "/Users/singh/Google Drive/PLS/Research/With Jaroslav/MIDs, Gender, and Support/models/temporary models/init_not_equal_`i'" //*recall the margins results for initiation so they can be "stored" for coefplot
margins
lincomest _b[1.initiator_past1:0bn.female]- _b[1.initiator_past1:1.female]
estimates store init_not_equal_MFdif`i'
}


forval i=1/$num_MIDs{ 
estimates use "/Users/singh/Google Drive/PLS/Research/With Jaroslav/MIDs, Gender, and Support/models/temporary models/targ_not_equal_`i'" //*recall the margins results for targeting so they can be "stored" for coefplot
margins
lincomest _b[1.target_past1:0bn.female]- _b[1.target_past1:1.female]
estimates store targ_not_equal_MFdif`i'
}



coefplot 	 ///
			(init_not_equal_MFdif1, mcolor(black) ciopts(lcolor(black*.5)))  (targ_not_equal_MFdif1, mcolor(red) ciopts(lcolor(red*.5))), bylabel(No Belgium 1999) ///
		||	(init_not_equal_MFdif2)  (targ_not_equal_MFdif2), bylabel(No Bulgaria 2001) ///
		||	(init_not_equal_MFdif3)  (targ_not_equal_MFdif3), bylabel(No Canada 1997) ///
		||	(init_not_equal_MFdif4)  (targ_not_equal_MFdif4), bylabel(No Canada 2004) ///
		||	(init_not_equal_MFdif5)  (targ_not_equal_MFdif5), bylabel(No Germany 1998) ///
		||	(init_not_equal_MFdif6)  (targ_not_equal_MFdif6), bylabel(No Germany 2002) ///
		||	(init_not_equal_MFdif7)  (targ_not_equal_MFdif7), bylabel(No Iceland 1999) ///
		||	(init_not_equal_MFdif8)  (targ_not_equal_MFdif8), bylabel(No Israel 2003) ///
		||	(init_not_equal_MFdif9)  (targ_not_equal_MFdif9), bylabel(No Netherlands 2002) ///
		||	(init_not_equal_MFdif10)  (targ_not_equal_MFdif10), bylabel(No Norway 2001) ///
		||	(init_not_equal_MFdif11)  (targ_not_equal_MFdif11), bylabel(No Poland 1997) ///
		||	(init_not_equal_MFdif12)  (targ_not_equal_MFdif12), bylabel(No Poland 2001) ///
		||	(init_not_equal_MFdif13)  (targ_not_equal_MFdif13), bylabel(No Portugal 2002) ///
		||	(init_not_equal_MFdif14)  (targ_not_equal_MFdif14), bylabel(No Russia 1999) ///
		||	(init_not_equal_MFdif15)  (targ_not_equal_MFdif15), bylabel(No Spain 2000) ///
		||	(init_not_equal_MFdif16)  (targ_not_equal_MFdif16), bylabel(No Switzerland 2003) ///
		||	(init_not_equal_MFdif17)  (targ_not_equal_MFdif17), bylabel(No Taiwan 1996) ///
		||	(init_not_equal_MFdif18)  (targ_not_equal_MFdif18), bylabel(No Taiwan 2001) ///
		||	(init_not_equal_MFdif19)  (targ_not_equal_MFdif19), bylabel(No United States 2004) ///
		||	(init_not_equal_MFdif20)  (targ_not_equal_MFdif20), bylabel(No United States 2008) ///
		scheme(s1color)  title("")  ///
		xline(0, lpattern(shortdash) lcolor(black)) /// 
		grid(none) 	 xlabel(-.05(.01).05)  ylabel(none) ///
		recast(scatter)  scale(1.3)  ///
		xtitle("Difference {&Delta}Pr(Vote for Incumbent) if MID Onset," "Female minus Male", size(vsmall))  ytitle("")  ///
		byopts(rows(10)) subtitle(, fcolor(black*.15))  ///
		legend(order(2 "MID Initiator" 4 "MID Target") rows(1) size(vsmall)) ///
		xsize(3)
























