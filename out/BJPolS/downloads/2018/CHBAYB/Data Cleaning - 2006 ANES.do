**********************************************************************
**********************************************************************
***********************2006 ANES Pilot Survey*************************
**********************************************************************
**********************************************************************
**********************************************************************


**********************************************************************
****************************Data Cleaning****************************
**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************
clear
set more off
use "ANES2006.dta"
set more off
	
		************************************
		*********Economic Assessments*******
		************************************

recode V06P808 (1=3) (2=2) (3=1) (8=.) (9=.), gen(retro)
label def ret 1 "Worse" 2 "Same" 3 "Better" 
label values retro ret
label var retro "Retrospective Economic Assessments"
tab retro

		
		************************************
		*********Partisanship***************
		************************************
		
***2006 ANES Pilot
	*checking the two versions
	gen version = .
	replace version = 1 if V06P680a !=.
	replace version = 0 if  V06P680b !=.
	label def ver 1 "Version 1" 0 "Version 2" 
	label values version ver
	label var version "PID Version"
	
	tab V06P680
	tab V06P680 version, row col chi2
	
	*7-point scale
	recode V06P680 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=.) (9=.), gen(partyid)
	label def pi 1 "Strong Dem" 2 "Weak Dem" 3 "Lean Dem" 4 "Ind." 5 "Lean Rep" 6 "Weak Rep" 7 "Strong Rep"
	label values partyid pi
	label var partyid "Party Identification"
	tab partyid
	tab partyid version, row col chi2
	
	*3-point categorical
	gen pid_3 = . 
	replace pid_3 = 1 if partyid >=1 & partyid <= 3
	replace pid_3 = 3 if partyid == 4
	replace pid_3 = 2 if partyid >=5 & partyid <= 7
	label var pid_3 "Party ID (Categorical)"
	label def pi2 1 "Democrat" 3 "Independent" 2 "Republican"
	label values pid_3 pi2
	
	*Republican vs. Democrat
	gen pid_2 = . 
	replace pid_2 = 1 if partyid >=1 & partyid <= 3
	replace pid_2 = 0 if partyid >=5 & partyid <= 7
	label var pid_2 "PID" 
	label def pi3 1 "Democrat" 0 "Republican"
	label values pid_2 pi3
	
	tab partyid
	tab pid_3
	tab pid_2
	tab pid_2 version, row col chi2
	
	*Partisan
	recode pid_2 (1=0) (0=1), gen(partisan)
	label var partisan "Co-Partisan to Inc. President"
	label def part1 1 "In-Partisan" 0 "Out-Partisan"
	label values partisan part1

*PID Strength (Non-Independents)*
	gen pid_str = . 
	replace pid_str = 1 if partyid == 3
	replace pid_str = 1 if partyid == 5
	replace pid_str = 2 if partyid == 2
	replace pid_str = 2 if partyid == 6
	replace pid_str = 3 if partyid == 1
	replace pid_str = 3 if partyid == 7
	label var pid_str "PID Str."
	label def pi4 1 "Leaner" 2 "Weak" 3 "Strong"
	label values pid_str pi4

	tab pid_str	
	tab pid_str version, row col chi2
	
	summ pid_str
	gen pid_str01 = (pid_str - r(min))/(r(max)-r(min))
	label var pid_str01 "PID Str."
	
	
*PID Strength (Full)
	recode partyid (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(pid_str_full)
	label var pid_str_full "PID Str."
	label def pi5 1 "Ind" 2 "Leaner" 3 "Weak" 4 "Strong"
	label values pid_str_full pi5


***2004 ANES TS
	*7-pt scale*
	recode  V043116 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=.) (8=.) (9=.), gen(partyid04)
	label var partyid04 "PID - 2004"
	label values partyid04 pi 
	*3-pt
	gen pid_304 = . 
	replace pid_304 = 1 if partyid04 >=1 & partyid04 <= 3
	replace pid_304 = 3 if partyid04 == 4
	replace pid_304 = 2 if partyid04 >=5 & partyid04 <= 7
	label var pid_304 "Party ID (Categorical; 2004)"
	label values pid_304 pi2
	*Republican vs. Democrat*
	gen pid_204 = . 
	replace pid_204 = 1 if partyid04 >=1 & partyid04 <= 3
	replace pid_204 = 0 if partyid04 >=5 & partyid04 <= 7
	label var pid_204 "PID" 
	label values pid_204 pi3
	
	*Partisan
		recode pid_204 (1=0) (0=1), gen(partisan2004)
		label values partisan2004 part1
		
	
	*PID Strength
		recode partyid04 (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(pid_str2004_full)
		label values pid_str2004_full pi5		
		
		recode partyid04 (1=3) (2=2) (3=1) (4=.) (5=1) (6=2) (7=3), gen(pid_str2004)
		label values pid_str2004 pi4	
		
		label var pid_str2004_full "PID Str."
		label var pid_str2004 "PID Str."
		
	
	*Relationship with 2006
	tab partyid partyid04, row col chi2
	tab pid_3 pid_304, row col chi2
	tab pid_2 pid_204, row col chi2
	pwcorr partyid partyid04, sig
	
***Bivariate Relationship with Economic Assessments**
	tab retro pid_2, row col chi2
	tab retro pid_204, row col chi2

		
		

		
		*****************************************************
		*********Network Size and Disagreement***************
		*****************************************************
		
*Name Generator Version*
	recode 	V06P406 (1=0) (2=1), gen(net_version)
	label var net_version "Name Generator Version"
	label def net1 1 "Gov't/Elections Generator" 0 "Important Things Generator"
	label values net_version net1
	tab net_version

*Number of Names Given*
	gen numgiven = V06P588
	replace numgiven = . if numgiven == 99
	label var numgiven "Number of Listed Discussants"
	tab numgiven
	summ numgiven, detail
	
	gen numgiven1 = numgiven
	replace numgiven1 = 3 if numgiven >= 3 & numgiven <=10
	label var numgiven1 "Number of Disc. Asked About"
	tab numgiven1
	tab numgiven numgiven1
	
	gen names = numgiven1 
	replace names = . if names == 0
	
	summ names
	gen numgiven01 = (names - r(min))/(r(max)-r(min))
	label var numgiven01 "Network Size"
	
	
	
*****Partisan Disagreement
	
*Discussant Partisanship*
	foreach var in V06P603x V06P608x V06P613x {
		tab `var'
		}
		*0-2: Democrat
		*3: Independent
		*4-6: Republican
		
*# and Avg. Disagreeable Partners
	*Number Agreeable
		*Agreeable = Dem/Dem, Ind/Ind, Rep/Rep
		label def agr 1 "PID Agree" 0 "PID Disagree" 
		gen d1_agree = . 
		replace d1_agree = 1 if pid_3 == 1 & V06P603x >=0 & V06P603x <=2
		replace d1_agree = 1 if pid_3 == 2 & V06P603x >=4 & V06P603x <=6 
		replace d1_agree = 1 if pid_3 == 3 & V06P603x == 3
		
		replace d1_agree = 0 if pid_3 == 1 & V06P603x >=4 & V06P603x <=6
		replace d1_agree = 0 if pid_3 == 1 & V06P603x == 3
		replace d1_agree = 0 if pid_3 == 2 & V06P603x >=0 & V06P603x <=2
		replace d1_agree = 0 if pid_3 == 2 & V06P603x == 3
		replace d1_agree = 0 if pid_3 == 3 & V06P603x >=0 & V06P603x <=2
		replace d1_agree = 0 if pid_3 == 3 & V06P603x >=4 & V06P603x <=6
		label var d1_agree "Agree with D1?"
		label values d1_agree agr
		
		gen d2_agree = . 
		replace d2_agree = 1 if pid_3 == 1 & V06P608x >=0 & V06P608x <=2
		replace d2_agree = 1 if pid_3 == 2 & V06P608x >=4 & V06P608x <=6 
		replace d2_agree = 1 if pid_3 == 3 & V06P608x == 3
		replace d2_agree = 0 if pid_3 == 1 & V06P608x >=4 & V06P608x <=6
		replace d2_agree = 0 if pid_3 == 1 & V06P608x == 3
		replace d2_agree = 0 if pid_3 == 2 & V06P608x >=0 & V06P608x <=2
		replace d2_agree = 0 if pid_3 == 2 & V06P608x == 3
		replace d2_agree = 0 if pid_3 == 3 & V06P608x >=0 & V06P608x <=2
		replace d2_agree = 0 if pid_3 == 3 & V06P608x >=4 & V06P608x <=6
		label var d2_agree "Agree with D2?"
		label values d2_agree agr
		
		gen d3_agree = . 
		replace d3_agree = 1 if pid_3 == 1 & V06P613x >=0 & V06P613x <=2
		replace d3_agree = 1 if pid_3 == 2 & V06P613x >=4 & V06P613x <=6 
		replace d3_agree = 1 if pid_3 == 3 & V06P613x == 3
		replace d3_agree = 0 if pid_3 == 1 & V06P613x >=4 & V06P613x <=6
		replace d3_agree = 0 if pid_3 == 1 & V06P613x == 3
		replace d3_agree = 0 if pid_3 == 2 & V06P613x >=0 & V06P613x <=2
		replace d3_agree = 0 if pid_3 == 2 & V06P613x == 3
		replace d3_agree = 0 if pid_3 == 3 & V06P613x >=0 & V06P613x <=2
		replace d3_agree = 0 if pid_3 == 3 & V06P613x >=4 & V06P613x <=6
		label var d3_agree "Agree with D3?"
		label values d3_agree agr
		
		tab d1_agree
		tab d2_agree
		tab d3_agree
		tab d1_agree d2_agree, row col chi2
		tab d1_agree d3_agree, row col chi2
		tab d2_agree d3_agree, row col chi
		
		
		*Number Disagreeble
		label def dagr 1 "PID Disgree" 0 "PID Agree" 
		gen d1_disagree = . 
		replace d1_disagree = 0 if pid_3 == 1 & V06P603x >=0 & V06P603x <=2
		replace d1_disagree = 0 if pid_3 == 2 & V06P603x >=4 & V06P603x <=6 
		replace d1_disagree = 0 if pid_3 == 3 & V06P603x == 3
		replace d1_disagree = 1 if pid_3 == 1 & V06P603x >=4 & V06P603x <=6
		replace d1_disagree = 1 if pid_3 == 1 & V06P603x == 3
		replace d1_disagree = 1 if pid_3 == 2 & V06P603x >=0 & V06P603x <=2
		replace d1_disagree = 1 if pid_3 == 2 & V06P603x == 3
		replace d1_disagree = 1 if pid_3 == 3 & V06P603x >=0 & V06P603x <=2
		replace d1_disagree = 1 if pid_3 == 3 & V06P603x >=4 & V06P603x <=6
		label var d1_disagree "Disagree with D1?"
		label values d1_disagree dagr
			
		gen d2_disagree = . 
		replace d2_disagree = 0 if pid_3 == 1 & V06P608x >=0 & V06P608x <=2
		replace d2_disagree = 0 if pid_3 == 2 & V06P608x >=4 & V06P608x <=6 
		replace d2_disagree = 0 if pid_3 == 3 & V06P608x == 3
		replace d2_disagree = 1 if pid_3 == 1 & V06P608x >=4 & V06P608x <=6
		replace d2_disagree = 1 if pid_3 == 1 & V06P608x == 3
		replace d2_disagree = 1 if pid_3 == 2 & V06P608x >=0 & V06P608x <=2
		replace d2_disagree = 1 if pid_3 == 2 & V06P608x == 3
		replace d2_disagree = 1 if pid_3 == 3 & V06P608x >=0 & V06P608x <=2
		replace d2_disagree = 1 if pid_3 == 3 & V06P608x >=4 & V06P608x <=6
		label var d2_disagree "Agree with D2?"
		label values d2_disagree dagr
		
		gen d3_disagree = . 
		replace d3_disagree = 0 if pid_3 == 1 & V06P613x >=0 & V06P613x <=2
		replace d3_disagree = 0 if pid_3 == 2 & V06P613x >=4 & V06P613x <=6 
		replace d3_disagree = 0 if pid_3 == 3 & V06P613x == 3
		replace d3_disagree = 1 if pid_3 == 1 & V06P613x >=4 & V06P613x <=6
		replace d3_disagree = 1 if pid_3 == 1 & V06P613x == 3
		replace d3_disagree = 1 if pid_3 == 2 & V06P613x >=0 & V06P613x <=2
		replace d3_disagree = 1 if pid_3 == 2 & V06P613x == 3
		replace d3_disagree = 1 if pid_3 == 3 & V06P613x >=0 & V06P613x <=2
		replace d3_disagree = 1 if pid_3 == 3 & V06P613x >=4 & V06P613x <=6
		label var d3_disagree "Agree with D3?"
		label values d3_disagree dagr
	
*Summary and Average
	*Summary Agreement
		egen pid_agree = rowtotal(d1_agree d2_agree d3_agree), missing
	*Disagreement
		egen pid_disagree = rowtotal(d1_disagree d2_disagree d3_disagree), missing
	
	*Summary Scale
			*See Lupton and Thornton: Exposure = D - A
			gen disagree_total = pid_disagree - pid_agree
			label var disagree_total "Network Disagreement"
		*Divided by network size
			*See Lupton and Thonrton: (D-A)/(D+A)
			gen disagree_avg = [pid_disagree - pid_agree]/[pid_disagree + pid_agree]
			label var disagree_avg "Network Disagreement"
						
		*Standardized*
			foreach var in disagree_total disagree_avg {
				summ `var'
				gen `var'01 = (`var' - r(min))/(r(max)-r(min))
			}
			
			label var disagree_total01 "Network Disagreement"
			label var disagree_avg01 "Network Disagreement"
	
	*Diversity Measure*
		*From Nir (2005): [(Agree+Disagree)/2] - |A-D|
			gen network_ambiv = [(pid_agree+pid_disagree)/2] - abs(pid_agree - pid_disagree)
			label var network_ambiv "Network Political Diversity"
		
			summ network_ambiv
			gen network_ambiv01=(network_ambiv - r(min))/(r(max)-r(min))
			label var network_ambiv01 "Network Political Diversity"

				
	
*General Disagreement*
	foreach var in V06P600 V06P601 V06P602 {
			tab `var'
			}
		
		recode V06P600 (1=5) (2=4) (3=3) (4=2) (5=1) (8=.), gen(disc1_gen)
		recode V06P601 (1=5) (2=4) (3=3) (4=2) (5=1) (8=.), gen(disc2_gen)
		recode V06P602 (1=5) (2=4) (3=3) (4=2) (5=1) (8=.), gen(disc3_gen)
		label def gagree 1 "Not At All" 2 "Slightly Different" 3 "Moderately Different" 4 "Very Different" 5 "Extremely Different"
		
		foreach var in disc1_gen disc2_gen disc3_gen {
			label values `var' gagree
			tab `var'
			summ `var'
			}
			
		egen disc_gen = rowmean(disc1_gen disc2_gen disc3_gen)
		label var disc_gen "Avg. General Disagreement"
		summ disc_gen


	*Relationship wtih PID Total
		pwcorr disagree_total disagree_avg disc_gen, sig
		pwcorr d1_disagree disc1_gen d2_disagree disc2_gen d3_disagree disc3_gen, sig
		tab d1_disagree disc1_gen, row col chi2
		tab d2_disagree disc2_gen, row col chi2
		tab d3_disagree disc3_gen, row col chi2
		ttest disc1_gen, by(d1_disagree)
		ttest disc2_gen, by(d2_disagree)
		ttest disc3_gen, by(d3_disagree)
		
		
	*Combined Index (Old)
		gen d1_both = d1_disagree + disc1_gen
		gen d2_both = d2_disagree + disc2_gen
		gen d3_both = d3_disagree + disc3_gen
		tab d1_both
		tab d2_both
		tab d3_both
		
		egen dis_both = rowmean(d1_both d2_both d3_both)
		label var dis_both "Index of Network Disagreement"
		summ dis_both, detail
		tab dis_both
		
	*Combined Index (new)
	/**fn. 5 (Lupton and Thornton: 
			A = sum(ai * si) where a = 1 if agree and s = agreement weight
			D = sum(di * si) where d = 1 if disagree and s = disagreement weight
			Disagreement = D - A**/
			
		*Agreement Coding*
			foreach var in disc1_gen disc2_gen disc3_gen {
				recode `var' (1=5) (2=4) (3=3) (4=2) (5=1), gen(`var'_ag)
				}
		*Agree Scale
			gen a1 = d1_agree * disc1_gen_ag
			gen a2 = d2_agree * disc2_gen_ag
			gen a3 = d3_agree * disc3_gen_ag
			egen agree_weight = rowtotal(a1 a2 a3), missing

		
		*Disagree Scale
			gen d1 = d1_disagree * disc1_gen
			gen d2 = d2_disagree * disc2_gen
			gen d3 = d3_disagree * disc3_gen
			egen disagree_weight = rowtotal(d1 d2 d3), missing

		*Exposure to Disagreement
			gen disagree_total_weight = disagree_weight - agree_weight
			gen disagree_avg_weight = disagree_total_weight/(pid_disagree+pid_agree)
		
			foreach var in disagree_total_weight disagree_avg_weight {
				summ `var' 
				gen `var'01 = (`var' - r(min))/(r(max)-r(min))
				tab `var'01
			}
			
			label var disagree_total_weight "Network Disagreement"
			label var disagree_total_weight "Network Disagreement"
		
			label var disagree_avg_weight "Network Disagreement"
			label var disagree_avg_weight "Network Disagreement"
		


*Netowrk Disagreemetn (Klofstad)
	foreach var in V06P603x V06P608x V06P613x {
		tab `var'
		}
		*0-2: Democrat
		*3: Independent
		*4-6: Republican
		
	recode V06P603x (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=.) (9=.), gen(partyid_d1)
	recode V06P608x (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=.) (9=.), gen(partyid_d2)
	recode V06P613x (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=.) (9=.), gen(partyid_d3)
	label values partyid_d1 pi
	label values partyid_d2 pi
	label values partyid_d3 pi
	
	gen pdiff_d1 = abs(partyid - partyid_d1)
	gen pdiff_d2 = abs(partyid - partyid_d2)
	gen pdiff_d3 = abs(partyid - partyid_d3)
	egen pdiff_avg = rowmean(pdiff_d1 pdiff_d1 pdiff_d3)
	label var pdiff_avg "Avg. Disagreement in PID Scale"
	
	
	
	
	
	
		***************************************************
		*****************Control Variables*****************
		***************************************************
		
*Education
	recode  V043254 (0=1) (1=1) (2=1) (3=2) (4=3) (5=3) (6=4) (7=4), gen(educ)
	label var educ "Education"
	label def edu 1 "< HS" 2 "HS" 3 "Some College" 4 "College Degree+"
	label values educ edu
	tab educ
	
	summ educ 
	gen educ01 = (educ - r(min))/(r(max)-r(min))
	label var educ01 "Education"



*Gender
	recode V06P005 (2=1) (1=0), gen(gender)
	label def gend 1 "Female" 0 "Male"
	label values gender gend
	label var gender gend
	

*Age
	rename V06P006 age
	summ age 
	
	summ age
	gen age01 = (age - r(min))/(r(max)-r(min))
	label var age01 "Age"
	
	

*Race/Hisp
	gen race = . 
	replace race = 1 if V043299 == 50
	replace race = 1 if V043299 == 45
	replace race = 2 if V043299 >= 10 & V043299  <= 15
	replace race = 3 if V043299 >= 20 & V043299  <= 40
	replace race = 3 if V043299 == 70
	tab V043299  race
	label var race "Race"
	label def rac 1 "White" 2 "Black" 3 "Other"
	label values race rac
	
	
*Marital Status
	recode  V043251 (1=1) (2=0) (3=0) (4=0) (5=0) (6=0) (8=.), gen(marital)
	label def mar 1 "Married" 0 "Not Married" 
	label values marital mar
	label var marital "2004 Marital Status"
	tab marital
	
*Employment
	recode  V043260c (1=1) (2=2) (4=2) (5=3) (6=4) (7=5) (8=6) (9=.), gen(employment)
	label var employment "2004 Employment Status" 
	label def emp 1 "Employed" 2 "Unemployed" 3 "Retired" 4 "Perm. Disabled" 5 "Homemaker" 6 "Student"
	label values employment emp
	tab employment if  V06P004 !=.
	
	recode employment (1=1) (2=2) (3=3) (4=4) (5=4) (6=4), gen(employed)
	label var employed "2004 Employment Status" 
	label def emp1 1 "Employed" 2 "Unemployed" 3 "Retired" 4 "Disabled/Homemaker/Student"
	label values employed emp1
	

*Income
	tab V043293x
	rename V043293x income
	label var income "2004 Household Income"
	mvdecode income, mv(00 = .a \ 88 = .b \ 89 = .c)
	tab income
	summ income, detail
	label var income "Income (2004)"
	
	summ income
	gen income01 = (income - r(min))/(r(max)-r(min))
	label var income01 "2004 Household Income"

	
*Borrowing
	recode V06P545 (1=1) (2=0) (9=.), gen(borrow)
	label var borrow "Could Borrow Money?"
	label def bor 1 "Could Borrow" 0 "Could Not Borrow"
	label values borrow bor
	tab borrow
	
	gen borrow_total = .
	replace borrow_total = 0 if borrow == 0
	replace borrow_total = V06P547 if borrow_total == . 
	label var borrow_total "Total that Could be Borrowed"
	tab borrow_total
	summ borrow_total, detail
	
	
*Interest
	foreach var in V06P630 V06P631 V06P632 V06P633 V06P634 { 
			tab `var'
			}
			
		recode V06P630 (1=5) (2=4) (3=3) (4=2) (5=1) (9=.), gen(int_a1)
		recode V06P631  (1=5) (2=4) (3=3) (4=2) (5=1) (9=.), gen(int_a2)
		recode V06P632  (1=5) (2=4) (3=3) (4=2) (5=1) (9=.), gen(int_a3)
		recode V06P633  (1=3) (2=2) (3=1), gen(int_b1)
		recode V06P634  (1=4) (2=3) (3=2) (4=1), gen(int_b2)
	
		pwcorr int_a1-int_a3, sig
		pwcorr int_b1 int_b2, sig
		
		factor int_a1-int_a3, pcf
		predict factor1
		rename factor1 interest_v1 
		label var interest_v1 "Interest (Version 1)"
		factor int_b1 int_b2, pcf
		predict factor1 
		rename factor1 interest_v2
		label var interest_v2 "Interest (Version 2)"
		
		summ interest_v1 interest_v2
	
		gen interest = interest_v1
		replace interest = interest_v2 if interest == . 
		summ interest
		label var interest "Interest (Both Versions)"
		
		
*Ideology
		tab V045117
		gen ideol = V045117
		replace ideol = . if ideol > 8
		label def id 1 "Ext. Liberal" 2 "Liberal" 3 "Slightly Liberal" 4 "Moderate" 5 "Slight Cons." 6 "Conservative" 7 "Ext. Conservative"
		label values ideol id
		tab ideol
		tab V045117 ideol
		
		recode ideol (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(ideol_str)
		label var ideol_str "Ideological Extremity"
		
		summ ideol_str
		gen ideol_str01 = (ideol_str - r(min))/(r(max)-r(min))
		label var ideol_str01 "Ideological Extremity"
		
*2004 Retro/Prosp Evaluations*
	label def bette1 1 "Much Worse" 2 "Somewhat Worse" 3 "Same" 4 "Somewhat Better" 5 "Much Better"
	recode  V043098 (1=5) (2=4) (3=3) (4=2) (5=1) , gen(retro2004)
	label var retro2004 "Retro Econ Evals (2004)"
	label values retro2004 bette1
	tab retro2004
	summ retro2004
	
	recode V043100 (1=5) (2=4) (3=3) (4=2) (5=1)  (8=.), gen(prosp2004)
	label var prosp2004 "Prosp Econ Evals (2004)
	label values prosp2004 bette
	tab prosp2004
	summ prosp2004
	
	recode V043102 (1=5) (2=4) (3=3) (4=2) (5=1) (8=.), gen(retro_unempl2004)
	label var retro_unempl2004 "Retro Unempl. Evals (2004)"
	label values retro_unempl2004 bette1
	tab retro_unempl2004
	summ retro_unempl2004
	
	recode V043103 (1=1) (3=2) (5=3) (0=.) (8=.) (9=.), gen(prosp_unempl2004)
	label var prosp_unempl2004 "Prosp Unempl. Evals (2004)"
	label def prun 1 "More Unmployment" 2 "Same" 3 "Less Unemployment"
	label values prosp_unempl2004 prun
	tab prosp_unempl2004
	summ prosp_unempl2004
	
	recode  V043105 (1=5) (2=4) (3=3) (4=2) (5=1), gen(retro_inflation2004)
	label var retro_inflation2004 "Retro Inflation (2004)"
	label values retro_inflation2004 bette1
	summ retro_inflation2004
	tab retro_inflation2004
	
	recode  V043106 (1=1) (3=2) (5=3) (0=.) (8=.) (9=.), gen(prosp_inflation2004)
	label var prosp_inflation2004 "Prosp. Inflation (2004)"
	label def prun1 1 "More Inflation" 2 "Same" 3 "Lower Inflation"
	label values prosp_inflation2004 prun1
	tab prosp_inflation2004
	summ prosp_inflation2004
		
	pwcorr retro2004 prosp2004 retro_unempl2004 prosp_unempl2004 retro_inflation2004 prosp_inflation2004, sig
	factor retro2004 prosp2004 retro_unempl2004 prosp_unempl2004 retro_inflation2004 prosp_inflation2004, pcf
	rotate
	predict factor1 factor2
	rename factor1 retro2004_factor
	label var retro2004_factor "Retro Evals (2004; Factor)"
	rename factor2 prosp2004_factor 
	label var prosp2004_factor "Prosp Evals (2004; Factor)"


	
*Network Interest
		foreach var in V06P618 V06P619 V06P620 {
			tab `var'
			}
		
		recode V06P618 (1=5) (2=4) (3=3) (4=2) (5=1) (8=.), gen(disc1_interest)
		recode V06P619 (1=5) (2=4) (3=3) (4=2) (5=1) (8=.), gen(disc2_interest)
		recode V06P620 (1=5) (2=4) (3=3) (4=2) (5=1) (8=.), gen(disc3_interest)
	
		egen disc_interest = rowmean(disc1_interest disc2_interest disc3_interest)
		label var disc_interest "Network Pol. Interest"
		
		summ disc_interest
		gen disc_int01 = (disc_interest - r(min))/(r(max)-r(min))
		label var disc_int01 "Network Interest"
		
		
		*Weighted Scale of Exposure to Disagreement
		
			*Agree/Weight
			gen a1i = d1_agree * disc1_interest
			gen a2i = d2_agree * disc2_interest
			gen a3i = d3_agree * disc3_interest
			egen agree_int = rowtotal(a1i a2i a3i), missing
		
			*Disagree/Weight
			gen d1i = d1_disagree * disc1_interest
			gen d2i = d2_disagree * disc2_interest
			gen d3i = d3_disagree * disc3_interest
			egen disagree_int = rowtotal(d1i d2i d3i), missing
		
			*Scale
				gen disagree_total_int = disagree_int - agree_int
				gen disagree_avg_int = disagree_total_int/(pid_disagree + pid_agree)
				label var disagree_total_int "Network Disagreement (Interest Weighted)"
				label var disagree_avg_int "Network Disagreement (Interest Weighted)"
				
				foreach var in disagree_total_int disagree_avg_int {
					summ `var'
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					}
				
				label var disagree_total_int01 "Network Disagreement (Interest Weighted)"
				label var disagree_avg_int01 "Network Disagreement (Interest Weighted)"
				
				
		
*Frequency of Talking
		foreach var in V06P591x V06P593x V06P595x { 
			tab `var' 
			summ `var'
			}
		
		mvdecode V06P593x, mv(8888 = .a)
		
		egen disc_freq = rowmean(V06P591x V06P593x V06P595x)
		label var disc_freq "Avg. #Days in Past 6mos Talked with Discussants"
	
		*WeightedScale
			foreach var in V06P591x V06P593x V06P595x {
				egen cut_`var' = cut(`var'), group(5)
				replace cut_`var' = cut_`var' + 1
				}

		
			
			*Agree
				gen a1f = d1_agree * cut_V06P591x
				gen a2f = d2_agree * cut_V06P593x
				gen a3f = d3_agree * cut_V06P595x
				egen agree_freq = rowtotal(a1f a2f a3f), missing
			*Disagree
				gen d1f = d1_disagree * cut_V06P591x
				gen d2f = d2_disagree * cut_V06P593x
				gen d3f = d3_disagree * cut_V06P595x
				egen disagree_freq = rowtotal(d1f d2f d3f), missing
				
			*Scale
				gen disagree_total_freq = disagree_freq - agree_freq
				gen disagree_avg_freq = disagree_total_freq/(pid_disagree + pid_agree)
				label var disagree_total_freq "Network Disagreement (Frequency Weighted)"
				label var disagree_avg_freq "Network Disagreement (Frequency Weighted)"
				
				foreach var in disagree_total_freq disagree_avg_freq {
					summ `var'
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					}
				
				label var disagree_total_freq01 "Network Disagreement (Frequency Weighted)"
				label var disagree_avg_freq01 "Network Disagreement (Frequency Weighted)"

*Tie Closeness*
	mvdecode V06P590 V06P592 V06P594, mv(8=.)
	
	recode V06P590 V06P592 V06P594 (1=5) (2=4) (3=3) (4=2) (5=1), gen(close1 close2 close3)
	
	*Agree
		gen a1c = d1_agree * close1
		gen a2c = d2_agree * close2
		gen a3c = d3_agree * close3
		egen agree_close = rowtotal(a1c a2c a3c), missing
	*Disagree
		gen d1c = d1_disagree * close1
		gen d2c = d2_disagree * close2
		gen d3c = d3_disagree * close3
		egen disagree_close = rowtotal(d1c d2c d3c), missing
	*Scale
		gen disagree_total_close = disagree_close - agree_close
		label var disagree_total_close "Disagreement (Closeness Weighted)"
		
		
	*Reverse Scaled, so that high = less close*
		gen a1c1 = d1_agree * V06P590
		gen a2c1 = d2_agree * V06P592
		gen a3c1 = d3_agree * V06P594
		egen agree_close1 = rowtotal(a1c1 a2c1 a3c1), missing
		
		gen d1c1 = d1_disagree * V06P590
		gen d2c1 = d2_disagree * V06P592
		gen d3c1 = d3_disagree * V06P594
		egen disagree_close1 = rowtotal(d1c1 d2c1 d3c1), missing

		gen disagree_total_close1 = disagree_close1 - agree_close1
		label var disagree_total_close1 "Disagreement (Closeness Weighted; Rev)"
		
		
	
	
	
	
	
		
*Follow POlitics (2004)

recode V045095 (1=4) (2=3) (3=2) (4=1) (8=.) (9=.), gen(follow04)
summ follow04
label var follow04 "Political Interest"
gen follow01 = (follow04 - r(min))/(r(max)-r(min))
label var follow01 "Political Interest"

**Partisan Ambivalence
recode V043053 (9=.), gen(dem_likes)
recode V043055 (9=.), gen(dem_dislikes)
recode V043057 (9=.), gen(rep_likes)
recode V043059 (9=.), gen(rep_dislikes)

	*ID Consistent
		gen consistent = . 
		replace consistent = dem_likes + rep_dislikes if pid_204 == 1
		replace consistent = dem_dislikes + rep_likes if pid_204 == 0
		label var consistent "Partisan Identity Consistent Likes/Dislikes"

	*ID Conflicting
		gen conflicting = . 
		replace conflicting = dem_dislikes + rep_likes if pid_204 == 1
		replace conflicting = dem_likes + rep_dislikes if pid_204 == 0
		label var conflicting "Partisan Identity Conclifting Likes/Dislikes"
	
	
*Cognitive Style

	*need to evaluate
		recode V045218 (1=4) (2=3) (3=2) (4=1) (9=.), gen(opinionated)
		rename V045219a opinions
		
		foreach var in opinionated opinions {
			summ `var'
			gen `var'01 = (`var' - r(min))/(r(max)-r(min))
			}

		egen evaluate1 = rowtotal(opinionated01 opinions01), missing
		label var evaluate1 "Need to Evaluate"
			
		
	*need for cognition
		recode V045220a (1=5) (2=4) (3=3) (4=2) (5=1), gen(thinking)
		recode V045221 (1=0) (5=1) (8=.) (9=.), gen(complex)
		
		summ thinking
		gen thinking01 = (thinking - r(min))/(r(max)-r(min))
	
		egen nfc1 = rowtotal(thinking01 complex), missing
		label var nfc1 "Need for Cognition"
		
*for matching

	
rename V043250 age2004
label var age2004 "Age (2004)"


tabulate race, gen(rac_)

tabulate pid_str2004, gen(pstr_)




*2004 knowledge*
	foreach var in V045162 V045163 V045164 V045165 V045089 V045090 { 
		codebook `var' 
		}
		
		label def corre 1 "Correct" 0 "Incorrect/No Guess"
		recode V045162 (1=1) (5=0) (8=0), gen(hastert)
		recode V045163 (1=1) (5=0) (8=0), gen(cheney)
		recode V045164 (1=1) (5=0) (8=0), gen(blair) 
		recode V045165 (1=1) (5=0) (8=0), gen(rein) 
		recode V045089 (1=0) (5=1) (8=0), gen(house)
		recode V045090 (1=0) (5=1) (8=0), gen(senate)

		foreach var in hastert cheney blair rein house senate {
			label values `var' corre
			tab `var'
			}
		egen knowl04 = rowtotal(hastert cheney blair rein house senate), missing
		tab knowl04
		summ knowl04, detail
		label var knowl04 "Political Knowledge (2004)"


summ interest
gen interest01 = (interest - r(min))/(r(max)-r(min))
label var interest01 "Political Interest"

/*******************************************Leeaners as Ind.*******************************/



gen d1_agree_nol = . 
		replace d1_agree_nol = 1 if pid_3 == 1 & V06P603x >=0 & V06P603x <=1
		replace d1_agree_nol = 1 if pid_3 == 2 & V06P603x >=5 & V06P603x <=6 
		replace d1_agree_nol = 1 if pid_3 == 3 & V06P603x == 3

		replace d1_agree_nol = 0 if pid_3 == 1 & V06P603x >=2 & V06P603x <=6
		replace d1_agree_nol = 0 if pid_3 == 2 & V06P603x >=0 & V06P603x <=4
		replace d1_agree_nol = 0 if pid_3 == 3 & V06P603x >=0 & V06P603x <=2
		replace d1_agree_nol = 0 if pid_3 == 3 & V06P603x >=4 & V06P603x <=6
		label var d1_agree_nol "Agree with D1?"
		label values d1_agree_nol agr
		
		gen d2_agree_nol = . 
		replace d2_agree_nol = 1 if pid_3 == 1 & V06P608x >=0 & V06P608x <=1
		replace d2_agree_nol = 1 if pid_3 == 2 & V06P608x >=5 & V06P608x <=6 
		
		replace d2_agree_nol = 0 if pid_3 == 1 & V06P608x >=2 & V06P608x <=6
		replace d2_agree_nol = 0 if pid_3 == 2 & V06P608x >=0 & V06P608x <=4

		replace d2_agree_nol = 1 if pid_3 == 3 & V06P608x == 3
		replace d2_agree_nol = 0 if pid_3 == 3 & V06P608x >=0 & V06P608x <=2
		replace d2_agree_nol = 0 if pid_3 == 3 & V06P608x >=4 & V06P608x <=6
		
		label var d2_agree_nol "Agree with D2?"
		label values d2_agree_nol agr
		
		gen d3_agree_nol = . 
		replace d3_agree_nol = 1 if pid_3 == 1 & V06P613x >=0 & V06P613x <=1
		replace d3_agree_nol = 1 if pid_3 == 2 & V06P613x >=5 & V06P613x <=6 
		replace d3_agree_nol = 0 if pid_3 == 1 & V06P613x >=2 & V06P613x <=6
		replace d3_agree_nol = 0 if pid_3 == 2 & V06P613x >=0 & V06P613x <=4

		replace d3_agree_nol = 1 if pid_3 == 3 & V06P613x == 3
		replace d3_agree_nol = 0 if pid_3 == 3 & V06P613x >=0 & V06P613x <=2
		replace d3_agree_nol = 0 if pid_3 == 3 & V06P613x >=4 & V06P613x <=6
		
		label var d3_agree_nol "Agree with D3?"
		label values d3_agree_nol agr

		
		
		*Number Disagreeble
		foreach var in d1_agree_nol d2_agree_nol  d3_agree_nol {
			omscore `var'
			}
			
		rename rr_d1_agree_nol d1_disagree_nol
		rename rr_d2_agree_nol d2_disagree_nol
		rename rr_d3_agree_nol d3_disagree_nol

	
		label var d1_disagree_nol "Disagree with D1?"
		label values d1_disagree_nol dagr
			
		label var d2_disagree_nol "Agree with D2?"
		label values d2_disagree_nol dagr
				
		label var d3_disagree_nol "Agree with D3?"
		label values d3_disagree_nol dagr
	
*Summary and Average
	*Summary Agreement
		egen pid_agree_nl = rowtotal(d1_agree_nol d2_agree_nol d3_agree_nol), missing
	*Disagreement
		egen pid_disagree_nl = rowtotal(d1_disagree_nol d2_disagree_nol d3_disagree_nol), missing
	
	*Summary Scale
			*See Lupton and Thornton: Exposure = D - A
			gen disagree_total_nl = pid_disagree_nl - pid_agree_nl
			label var disagree_total_nl "Network Disagreement"
