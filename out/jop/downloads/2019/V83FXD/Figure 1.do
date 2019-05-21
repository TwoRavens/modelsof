* Date: February 8, 2019
* Description: Analyze trust ratings for police study

clear


* Import predicted probabilities from Table A3

import excel "...\1903 JOP\Fig 1 trust simqi.xlsx", sheet("Sheet1") firstrow


* Create black values to facilitate bar spacing

set obs 10
replace model = 1 in 10
replace treatment = "blank1" in 10
replace trust_spd = 0 in 10
replace trust_poa = 0 in 10
set obs 11
replace model = 1 in 11
replace treatment = "blank2" in 11
replace trust_spd = 0 in 11
replace trust_poa = 0 in 11
set obs 12
replace model = 1 in 12
replace treatment = "blank3" in 12
replace trust_spd = 0 in 12
replace trust_poa = 0 in 12


* Create order term

gen order1 = 0
replace order1 = 1 if treatment=="control" & group=="sac"
replace order1 = 2 if treatment=="pattern" & group=="sac"
replace order1 = 3 if treatment=="reform" & group=="sac"
replace order1 = 4 if treatment=="blank1"
replace order1 = 5 if treatment=="control" & group=="non"
replace order1 = 6 if treatment=="pattern" & group=="non"
replace order1 = 7 if treatment=="reform" & group=="non"
replace order1 = 8 if treatment=="blank2"
replace order1 = 9 if treatment=="control" & group=="black"
replace order1 = 10 if treatment=="pattern" & group=="black"
replace order1 = 11 if treatment=="reform" & group=="black"
replace order1 = 12 if treatment=="blank3"


sort model order1


* Figure 1a.  Probability strongly / somewhat agree trust SPD leaders

graph bar trust_spd if model==1, ///
     over(order1, label(nolabels)) ///
     asyvars bargap(0) ylabel(0(.10)1.03, labsize(large)) legend(off) ///
	 ytitle(" ") ///
	 bar(1, lcolor(black) bcolor(white)) ///
	 bar(2, lcolor(black) bcolor(gray)) ///
	 bar(3, lcolor(black) bcolor(black)) ///
	 bar(5, lcolor(black) bcolor(white)) ///
	 bar(6, lcolor(black) bcolor(gray)) ///
	 bar(7, lcolor(black) bcolor(black)) ///
	 bar(9, lcolor(black) bcolor(white)) ///
	 bar(10, lcolor(black) bcolor(gray)) ///
	 bar(11, lcolor(black) bcolor(black)) ///
	 text(.80 5 "{bf:.72}", size(vlarge)) ///
	 text(.78 14 "{bf:.70}", size(vlarge)) ///
	 text(.82 23 "{bf:.74}", size(vlarge)) ///
	 text(.74 37 "{bf:.61}", size(vlarge)) ///
	 text(.67 46 "{bf:.49 *}", size(vlarge)) ///
	 text(.79 56 "{bf:.66 #}", size(vlarge)) ///
	 text(.35 69 "{bf:.27}", size(vlarge)) ///
	 text(.29 78 "{bf:.21}", size(vlarge)) ///
	 text(.35 88 "{bf:.27}", size(vlarge)) ///
	 text(-.08 13 "{bf:Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 46 "{bf:Non-Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 78 "{bf:Black}" "{bf:Respondents}", size(medlarge)) ///
	 intensity(*0.9) scheme(s1color) ///
	 note(" " " " " ") ///
     graphregion(color(white)) plotregion(color(white))


* Figure 1b.  Probability say local POA knows a lot / some AND say agrees all / most of the time

graph bar trust_poa if model==1, ///
     over(order1, label(nolabels)) ///
     asyvars bargap(0) ylabel(0(.10)1.03, labsize(large)) legend(off) ///
	 ytitle(" ") ///
	 bar(1, lcolor(black) bcolor(white)) ///
	 bar(2, lcolor(black) bcolor(gray)) ///
	 bar(3, lcolor(black) bcolor(black)) ///
	 bar(5, lcolor(black) bcolor(white)) ///
	 bar(6, lcolor(black) bcolor(gray)) ///
	 bar(7, lcolor(black) bcolor(black)) ///
	 bar(9, lcolor(black) bcolor(white)) ///
	 bar(10, lcolor(black) bcolor(gray)) ///
	 bar(11, lcolor(black) bcolor(black)) ///
	 text(.55 5 "{bf:.47}", size(vlarge)) ///
	 text(.55 14 "{bf:.47}", size(vlarge)) ///
	 text(.60 23 "{bf:.52}", size(vlarge)) ///
	 text(.54 37 "{bf:.46}", size(vlarge)) ///
	 text(.55 46 "{bf:.47}", size(vlarge)) ///
	 text(.58 56 "{bf:.50}", size(vlarge)) ///
	 text(.38 69 "{bf:.30}", size(vlarge)) ///
	 text(.39 78 "{bf:.31}", size(vlarge)) ///
	 text(.29 88 "{bf:.21}", size(vlarge)) ///
	 text(-.08 13 "{bf:Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 46 "{bf:Non-Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 78 "{bf:Black}" "{bf:Respondents}", size(medlarge)) ///
	 intensity(*0.9) scheme(s1color) ///
	 note(" " " " " ") ///
     graphregion(color(white)) plotregion(color(white))

* End
