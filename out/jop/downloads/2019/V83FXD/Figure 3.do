* Date: February 8, 2019
* Description: Analyze candidate support for police study

clear


* Import predicted probabilities from Table A8

import excel "...\1903 JOP\Fig 3 support simqi.xlsx", sheet("Sheet1") firstrow


* Create black values to facilitate bar spacing

set obs 13
replace model = 1 in 13
replace treatment = "blank1" in 13
replace law_sheriff = 0 in 13
replace law_da = 0 in 13
set obs 14
replace model = 1 in 14
replace treatment = "blank2" in 14
replace law_sheriff = 0 in 14
replace law_da = 0 in 14
set obs 15
replace model = 1 in 15
replace treatment = "blank3" in 15
replace law_sheriff = 0 in 15
replace law_da = 0 in 15
set obs 16
replace model = 1 in 16
replace treatment = "blank4" in 16
replace law_sheriff = 0 in 16
replace law_da = 0 in 16
set obs 17
replace model = 1 in 17
replace treatment = "blank5" in 17
replace law_sheriff = 0 in 17
replace law_da = 0 in 17
set obs 18
replace model = 1 in 18
replace treatment = "blank6" in 18
replace law_sheriff = 0 in 18
replace law_da = 0 in 18
set obs 19
replace model = 1 in 19
replace treatment = "blank7" in 19
replace law_sheriff = 0 in 19
replace law_da = 0 in 19


* Create order term

gen order1 = 0
replace order1 = 1 if treatment=="control" & group=="sac"
replace order1 = 2 if treatment=="endorse" & group=="sac"
replace order1 = 3 if treatment=="blank1"
replace order1 = 4 if treatment=="trust_poa" & group=="sac"
replace order1 = 5 if treatment=="trust_poa_endorse" & group=="sac"
replace order1 = 6 if treatment=="blank2"
replace order1 = 7 if treatment=="blank3"
replace order1 = 8 if treatment=="control" & group=="non"
replace order1 = 9 if treatment=="endorse" & group=="non"
replace order1 = 10 if treatment=="blank4"
replace order1 = 11 if treatment=="trust_poa" & group=="non"
replace order1 = 12 if treatment=="trust_poa_endorse" & group=="non"
replace order1 = 13 if treatment=="blank5"
replace order1 = 14 if treatment=="blank6"
replace order1 = 15 if treatment=="control" & group=="black"
replace order1 = 16 if treatment=="endorse" & group=="black"
replace order1 = 17 if treatment=="blank7"
replace order1 = 18 if treatment=="trust_poa" & group=="black"
replace order1 = 19 if treatment=="trust_poa_endorse" & group=="black"


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
	 bar(8, lcolor(black) bcolor(white)) ///
	 bar(9, lcolor(black) bcolor(black)) ///
	 bar(11, lcolor(black) bcolor(white)) ///
	 bar(12, lcolor(black) bcolor(black)) ///
	 bar(15, lcolor(black) bcolor(white)) ///
	 bar(16, lcolor(black) bcolor(black)) ///
	 bar(18, lcolor(black) bcolor(white)) ///
	 bar(19, lcolor(black) bcolor(black)) ///
	 text(.33 3 "{bf:.25}", size(medlarge)) ///
	 text(.37 9 "{bf:.29}", size(medlarge)) ///
	 text(.54 18 "{bf:.46}", size(medlarge)) ///
	 text(.68 24 "{bf:.60 *#}", size(medlarge)) ///
	 text(.36 38 "{bf:.28}", size(medlarge)) ///
	 text(.44 46 "{bf:.34 *}", size(medlarge)) ///
	 text(.39 54 "{bf:.31}", size(medlarge)) ///
	 text(.61 61 "{bf:.53 *#}", size(medlarge)) ///
	 text(.37 75 "{bf:.29}", size(medlarge)) ///
	 text(.40 81 "{bf:.32}", size(medlarge)) ///
	 text(.28 90 "{bf:.20}", size(medlarge)) ///
	 text(.54 97 "{bf:.46 *#}", size(medlarge)) ///
	 text(-.06 6 "{bf:Low}", size(medlarge)) ///
	 text(-.06 21 "{bf:High}", size(medlarge)) ///
	 text(-.06 42 "{bf:Low}", size(medlarge)) ///
	 text(-.06 58 "{bf:High}", size(medlarge)) ///
	 text(-.06 78 "{bf:Low}", size(medlarge)) ///
	 text(-.06 94 "{bf:High}", size(medlarge)) ///
	 text(-.19 13 "{bf:Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.19 50 "{bf:Non-Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.19 86 "{bf:Black}" "{bf:Respondents}", size(medlarge)) ///
	 intensity(*0.9) scheme(s1color) ///
	 note(" " " " " " " " " ") ///
     graphregion(color(white)) plotregion(color(white))


* Figure 3b.  Probability prefer endorsed candidate for DA

graph bar law_da if model==1, ///
     over(order1, label(nolabels)) ///
     asyvars bargap(0) ylabel(0(.10)1.03, labsize(large)) legend(off) ///
	 ytitle(" ") ///
	 bar(1, lcolor(black) bcolor(white)) ///
	 bar(2, lcolor(black) bcolor(black)) ///
	 bar(4, lcolor(black) bcolor(white)) ///
	 bar(5, lcolor(black) bcolor(black)) ///
	 bar(8, lcolor(black) bcolor(white)) ///
	 bar(9, lcolor(black) bcolor(black)) ///
	 bar(11, lcolor(black) bcolor(white)) ///
	 bar(12, lcolor(black) bcolor(black)) ///
	 bar(15, lcolor(black) bcolor(white)) ///
	 bar(16, lcolor(black) bcolor(black)) ///
	 bar(18, lcolor(black) bcolor(white)) ///
	 bar(19, lcolor(black) bcolor(black)) ///
	 text(.41 3 "{bf:.33}", size(medlarge)) ///
	 text(.40 9 "{bf:.32}", size(medlarge)) ///
	 text(.51 18 "{bf:.43}", size(medlarge)) ///
	 text(.67 24 "{bf:.59 *#}", size(medlarge)) ///
	 text(.41 38 "{bf:.33}", size(medlarge)) ///
	 text(.39 46 "{bf:.31}", size(medlarge)) ///
	 text(.51 54 "{bf:.43}", size(medlarge)) ///
	 text(.55 61 "{bf:.47}", size(medlarge)) ///
	 text(.41 75 "{bf:.33}", size(medlarge)) ///
	 text(.35 81 "{bf:.27}", size(medlarge)) ///
	 text(.45 90 "{bf:.37}", size(medlarge)) ///
	 text(.39 97 "{bf:.31}", size(medlarge)) ///
	 text(-.06 6 "{bf:Low}", size(medlarge)) ///
	 text(-.06 21 "{bf:High}", size(medlarge)) ///
	 text(-.06 42 "{bf:Low}", size(medlarge)) ///
	 text(-.06 58 "{bf:High}", size(medlarge)) ///
	 text(-.06 78 "{bf:Low}", size(medlarge)) ///
	 text(-.06 94 "{bf:High}", size(medlarge)) ///
	 text(-.19 13 "{bf:Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.19 50 "{bf:Non-Sacramento}" "{bf:Respondents}", size(medlarge)) ///
	 text(-.19 86 "{bf:Black}" "{bf:Respondents}", size(medlarge)) ///
	 intensity(*0.9) scheme(s1color) ///
	 note(" " " " " " " " " ") ///
     graphregion(color(white)) plotregion(color(white))

* End
