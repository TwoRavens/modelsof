* Date: February 8, 2019
* Description: Analyze candidate support for police study

clear


* Import predicted probabilities from Table A6

import excel "...\1903 JOP\Fig 2 support simqi.xlsx", sheet("Sheet1") firstrow


* Create black values to facilitate bar spacing

set obs 7
replace model = 1 in 7
replace treatment = "blank1" in 7
replace law_sheriff = 0 in 7
replace law_da = 0 in 7
set obs 8
replace model = 1 in 8
replace treatment = "blank2" in 8
replace law_sheriff = 0 in 8
replace law_da = 0 in 8
set obs 9
replace model = 1 in 9
replace treatment = "blank3" in 9
replace law_sheriff = 0 in 9
replace law_da = 0 in 9


* Create order term

gen order1 = 0
replace order1 = 1 if treatment=="control" & group=="sac"
replace order1 = 2 if treatment=="endorse" & group=="sac"
replace order1 = 3 if treatment=="blank1"
replace order1 = 4 if treatment=="control" & group=="non"
replace order1 = 5 if treatment=="endorse" & group=="non"
replace order1 = 6 if treatment=="blank2"
replace order1 = 7 if treatment=="control" & group=="black"
replace order1 = 8 if treatment=="endorse" & group=="black"
replace order1 = 9 if treatment=="blank3"


sort model order1


* Figure 2a.  Probability prefer endorsed candidate for sheriff

graph bar law_sheriff if model==1, ///
     over(order1, label(nolabels)) ///
     asyvars bargap(0) ylabel(0(.10)1.03, labsize(large)) legend(off) ///
	 ytitle(" ") ///
	 bar(1, lcolor(black) bcolor(white)) ///
	 bar(2, lcolor(black) bcolor(black)) ///
	 bar(4, lcolor(black) bcolor(white)) ///
	 bar(5, lcolor(black) bcolor(black)) ///
	 bar(7, lcolor(black) bcolor(white)) ///
	 bar(8, lcolor(black) bcolor(black)) ///
	 text(.42 6 "{bf:.34}", size(vlarge)) ///
	 text(.51 17 "{bf:.43 *}", size(vlarge)) ///
	 text(.38 38 "{bf:.30}", size(vlarge)) ///
	 text(.51 49 "{bf:.43 *}", size(vlarge)) ///
	 text(.34 71 "{bf:.26}", size(vlarge)) ///
	 text(.42 82 "{bf:.34}", size(vlarge)) ///
	 text(-.08 13 "{bf:Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 46 "{bf:Non-Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 78 "{bf:Black}" "{bf:Respondents}", size(medlarge)) ///
	 intensity(*0.9) scheme(s1color) ///
	 note(" " " " " ") ///
     graphregion(color(white)) plotregion(color(white))


* Figure 2b.  Probability prefer endorsed candidate for DA

graph bar law_da if model==1, ///
     over(order1, label(nolabels)) ///
     asyvars bargap(0) ylabel(0(.10)1.03, labsize(large)) legend(off) ///
	 ytitle(" ") ///
	 bar(1, lcolor(black) bcolor(white)) ///
	 bar(2, lcolor(black) bcolor(black)) ///
	 bar(4, lcolor(black) bcolor(white)) ///
	 bar(5, lcolor(black) bcolor(black)) ///
	 bar(7, lcolor(black) bcolor(white)) ///
	 bar(8, lcolor(black) bcolor(black)) ///
	 text(.46 6 "{bf:.38}", size(vlarge)) ///
	 text(.53 17 "{bf:.45 *}", size(vlarge)) ///
	 text(.46 38 "{bf:.38}", size(vlarge)) ///
	 text(.48 49 "{bf:.40}", size(vlarge)) ///
	 text(.42 71 "{bf:.34}", size(vlarge)) ///
	 text(.36 82 "{bf:.28}", size(vlarge)) ///
	 text(-.08 13 "{bf:Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 46 "{bf:Non-Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.08 78 "{bf:Black}" "{bf:Respondents}", size(medlarge)) ///
	 intensity(*0.9) scheme(s1color) ///
	 note(" " " " " ") ///
     graphregion(color(white)) plotregion(color(white))

* End
