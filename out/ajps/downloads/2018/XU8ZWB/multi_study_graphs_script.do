****
****
****	Replication file for Figures 2 & 3 for:
****		
****	"The Two Income-Participation Gaps"
****
****	by Christopher Ojeda
****
****
****	Table of Contents
****
****	- Section 1: Code for Creating Figure 2
****
****	- Section 2: Code for Creating Figure 3
****
****
****	Analyses carried out using Stata/SE 14.2
****



********************************************************************************
****** Section 1: Code for Creating Figure 2

**
** GSS

use "GSS_clean.dta", clear
xtile inc_tile = inc_adj, nq(5)

tab inc_tile if incom16 == 1
/*
5 quantiles |
 of inc_adj |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        829       31.24       31.24
          2 |        635       23.93       55.16
          3 |        459       17.29       72.46
          4 |        396       14.92       87.38
          5 |        335       12.62      100.00
------------+-----------------------------------
      Total |      2,654      100.00
*/

tab inc_tile if incom16 == 5
/*
 of inc_adj |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        130       21.81       21.81
          2 |         74       12.42       34.23
          3 |        101       16.95       51.17
          4 |         99       16.61       67.79
          5 |        192       32.21      100.00
------------+-----------------------------------
      Total |        596      100.00
*/


**
** NLSY79
use "NLSY79_clean.dta", clear
drop pov_ratiol
foreach i in 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 96 98{
rename pov_ratio`i' pov_ratio19`i'
}
*
foreach i in 00 02 04 06 08 10{
rename pov_ratio`i' pov_ratio20`i'
}
*
foreach i in 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1996 1998 2000 2002 2004 2006 2008 2010{
xtile pov_rtile`i' = pov_ratio`i', nq(5)
}
xtile pov_ctile = pov_child, nq(5)
keep mom_id pov_ratio* pov_rtile* pov_child pov_ctile
reshape	long pov_ratio pov_rtile, i(mom_id) j(year)
drop if pov_child == . | pov_ratio == .
	
keep if year == 2006

tab pov_rtile if pov_ctile == 1

/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        428       34.54       34.54
          2 |        293       23.65       58.19
          3 |        230       18.56       76.76
          4 |        166       13.40       90.15
          5 |        122        9.85      100.00
------------+-----------------------------------
      Total |      1,239      100.00
*/

tab pov_rtile if pov_ctile == 5

/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         99        7.68        7.68
          2 |        139       10.78       18.46
          3 |        246       19.08       37.55
          4 |        348       27.00       64.55
          5 |        457       35.45      100.00
------------+-----------------------------------
      Total |      1,289      100.00
*/


**
** YPSS

use "YPSS_clean.dta", clear
xtile cinc5_tile = child_inc_new, nq(5)
xtile inc5_tile73 = fam_inc73, nq(5)
xtile inc5_tile82 = fam_inc82, nq(5)
xtile inc5_tile97 = fam_inc97, nq(5)
	
keep v5 child_inc_new cinc5_tile inc5_tile* fam_inc*
reshape	long fam_inc inc5_tile, i(v5) j(year)
drop if child_inc_new == . | fam_inc == .
sample 1, count by(v5)

tab inc5_tile if cinc5_tile == 1	
/*
  inc5_tile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         82       34.75       34.75
          2 |         52       22.03       56.78
          3 |         48       20.34       77.12
          4 |         34       14.41       91.53
          5 |         20        8.47      100.00
------------+-----------------------------------
      Total |        236      100.00
*/

tab inc5_tile if cinc5_tile == 5

/*
  inc5_tile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         27       22.88       22.88
          2 |         19       16.10       38.98
          3 |         19       16.10       55.08
          4 |         19       16.10       71.19
          5 |         34       28.81      100.00
------------+-----------------------------------
      Total |        118      100.00
*/	  


**
** CNLSY79

use "CNLSY79_clean.dta", clear

xtile pov_rtile2004 = current_pov04, nq(5)
xtile pov_rtile2006 = current_pov06, nq(5)
xtile pov_ctile = pov_child, nq(5)

keep child_id pov_rtile2004 pov_rtile2006 pov_ctile
reshape	long pov_rtile, i(child_id) j(year)
drop if pov_rtile == . | pov_ctile == .

sample 1, count by(child_id)

tab pov_rtile if pov_ctile == 1
/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        149       46.56       46.56
          2 |         81       25.31       71.88
          3 |         49       15.31       87.19
          4 |         25        7.81       95.00
          5 |         16        5.00      100.00
------------+-----------------------------------
      Total |        320      100.00
*/

tab pov_rtile if pov_ctile == 5
/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         16        4.98        4.98
          2 |         19        5.92       10.90
          3 |         32        9.97       20.87
          4 |         90       28.04       48.91
          5 |        164       51.09      100.00
------------+-----------------------------------
      Total |        321      100.00	  
*/


**
** NLSY97

use "NLSY97_clean.dta", clear
foreach i in 04 06 08 10{
rename pov_ratio`i' pov_ratio20`i'
}
*

foreach i in 2004 2006 2008 2010{
xtile pov_rtile`i' = pov_ratio`i', nq(5)
}
*

xtile pov_ctile = pov_child, nq(5)

keep case_id pov_rtile* pov_ctile
reshape	long pov_rtile, i(case_id) j(year)
drop if pov_rtile == . | pov_ctile == .

sample 1, count by(case_id)

tab pov_rtile if pov_ctile == 1

/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        588       42.70       42.70
          2 |        333       24.18       66.88
          3 |        210       15.25       82.14
          4 |        152       11.04       93.17
          5 |         94        6.83      100.00
------------+-----------------------------------
      Total |      1,377      100.00
*/

tab pov_rtile if pov_ctile == 5
/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        154       11.56       11.56
          2 |        157       11.79       23.35
          3 |        226       16.97       40.32
          4 |        308       23.12       63.44
          5 |        487       36.56      100.00
------------+-----------------------------------
      Total |      1,332      100.00
*/
	 
	 
**
** PSID

use "PSID_clean.dta", clear
foreach i in 2005 2007 2009 2011{
xtile pov_rtile`i' = pov_ratio`i', nq(5)
}
*

xtile pov_ctile = pov_child, nq(5)

keep aid_ind aid_fam pov_rtile* pov_ctile
reshape	long pov_rtile, i(aid_fam aid_ind) j(year)
drop if pov_rtile == . | pov_ctile == .

sample 1, count by(aid_fam aid_ind)

tab pov_rtile if pov_ctile == 1

/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |        188       55.95       55.95
          2 |         92       27.38       83.33
          3 |         37       11.01       94.35
          4 |         13        3.87       98.21
          5 |          6        1.79      100.00
------------+-----------------------------------
      Total |        336      100.00
*/


tab pov_rtile if pov_ctile == 5
/*
  pov_rtile |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         19        5.67        5.67
          2 |         17        5.07       10.75
          3 |         22        6.57       17.31
          4 |         78       23.28       40.60
          5 |        199       59.40      100.00
------------+-----------------------------------
      Total |        335      100.00
*/



**
** Graph
clear
set obs 6
gen data = _n

foreach i in 1 2 3 4 5{
gen bottom`i' = .
gen top`i' = .
}
*

*GSS
replace bottom1 = 31.24 if _n == 1
replace bottom2 = 23.93 if _n == 1
replace bottom3 = 17.29 if _n == 1
replace bottom4 = 14.92 if _n == 1
replace bottom5 = 12.62 if _n == 1

*NLSY79
replace bottom1 = 34.54 if _n == 2
replace bottom2 = 23.65 if _n == 2
replace bottom3 = 18.56 if _n == 2
replace bottom4 = 13.40 if _n == 2
replace bottom5 = 9.85 if _n == 2

*YPSS
replace bottom1 = 34.75 if _n == 3
replace bottom2 = 22.03 if _n == 3
replace bottom3 = 20.34 if _n == 3
replace bottom4 = 14.41 if _n == 3
replace bottom5 = 8.47 if _n == 3

*CNLSY79
replace bottom1 = 46.56 if _n == 4
replace bottom2 = 25.31 if _n == 4
replace bottom3 = 15.31 if _n == 4
replace bottom4 = 7.81 if _n == 4
replace bottom5 = 5.00 if _n == 4

*NLSY97
replace bottom1 = 42.70 if _n == 5
replace bottom2 = 24.18 if _n == 5
replace bottom3 = 15.25 if _n == 5
replace bottom4 = 11.04 if _n == 5
replace bottom5 = 6.83 if _n == 5

*PSID
replace bottom1 = 55.95 if _n == 6
replace bottom2 = 27.38 if _n == 6
replace bottom3 = 11.01 if _n == 6
replace bottom4 = 3.87 if _n == 6
replace bottom5 = 1.79 if _n == 6

* Figure 2		
graph bar bottom1 bottom2 bottom3 bottom4 bottom5, ///
	over(data, relabel(1 "GSS" 2 "NLSY79" 3 "YPSS" 4 "CNLSY79" 5 "NLSY97" 6 "PSID")) stack ///
	legend(order(1 2 3 4 5) label(1 "Bottom" "Quintile") label(2 "Second" "Quintile") label(3 "Middle" "Quintile") label(4 "Fourth" "Quintile") label(5 "Top" "Quintile") rows(1) symxsize(5)) ///
	ylabel(0 10 20 30 40 50 60 70 80 90 100, labsize(2.5) angle(horizontal)) ///
	bar(1, color("27 158 119")) ///
	bar(2, color("217 95 2")) ///
	bar(3, color("117 112 179")) ///
	bar(4, color("231 41 138")) ///
	bar(5, color("102 166 30")) ///
	title("Current Economic Statuses of" "Respondents Who Grew up in the Bottom Quintile") ///
	yscale(titlegap(3)) ///
	scheme(s2mono) graphregion(fcolor(white))

	

********************************************************************************
****** Section 2: Code for Creating Figure 3

* Current economic status
coefplot(matrix(current_79nlsy3[.,1]), se(current_79nlsy3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(current_79nlsy4[.,1]), se(current_79nlsy4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ////
		(matrix(current_ypss3[.,1]), se(current_ypss3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(current_ypss4[.,1]), se(current_ypss4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ////
		(matrix(current_cnlsy3[.,1]), se(current_cnlsy3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(current_cnlsy4[.,1]), se(current_cnlsy4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(current_97nlsy3[.,1]), se(current_97nlsy3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(current_97nlsy4[.,1]), se(current_97nlsy4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(current_psid3[.,1]), se(current_psid3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(current_psid4[.,1]), se(current_psid4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))), ///
		vertical ///
		legend(off) ///
		level(95) ///
		ytitle("Estimated Coefficient", size(4)) ///
		ylabel(-.2 0 .2 .4 .6 .8, labsize(2.5) angle(horizontal)) ///
		title("Current Economic Status") ///
		xlabel(1.5 "NLSY79" 3.5 "YPSS" 5.5 "CNLSY79" 7.5 "NLSY97" 9.5 "PSID", labsize(4) labgap(2) angle(45) tick) ///
		yscale(titlegap(2)) ///
		yline(0, lpattern(dash) lcolor(gs14)) ///
		grid(n) ///
		scheme(s1mono) graphregion(fcolor(white)) plotregion(fcolor(white)) ///
		text(.3012 1.4 "{bf:Precursors Only}", orientation(vertical) color("217 95 2") place(n) size(3)) ///
		text(.1696 2.0 "{bf:Precursors + Mediators}", orientation(vertical) color("27 158 119") place(n) size(3)) ///
		name(coef_current, replace)
		
* Economic history	
coefplot (matrix(history_79nlsy3[.,1]), se(history_79nlsy3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(history_79nlsy4[.,1]), se(history_79nlsy4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ////
		(matrix(history_ypss3[.,1]), se(history_ypss3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(history_ypss4[.,1]), se(history_ypss4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ////
		(matrix(history_cnlsy3[.,1]), se(history_cnlsy3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(history_cnlsy4[.,1]), se(history_cnlsy4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(history_97nlsy3[.,1]), se(history_97nlsy3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(history_97nlsy4[.,1]), se(history_97nlsy4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(history_psid3[.,1]), se(history_psid3[.,2]) offset(.2) m(O) msize(medlarge) mfcolor("217 95 2") mlc("217 95 2") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))) ///
		(matrix(history_psid4[.,1]), se(history_psid4[.,2]) offset(-.2) m(O) msize(medlarge) mfcolor("27 158 119") mlc("27 158 119") ciop(lcolor(gs12 gs6) lwidth(medthick medthin))), ///
		vertical ///
		legend(off) ///
		level(95) ///
		ytitle("Estimated Coefficient", size(4)) ///
		ylabel(-.2 0 .2 .4 .6 .8, labsize(2.5) angle(horizontal)) ///
		title("Economic History") ///
		xlabel(1.5 "NLSY79" 3.5 "YPSS" 5.5 "CNLSY79" 7.5 "NLSY97" 9.5 "PSID", labsize(4) labgap(2) angle(45) tick) ///
		yscale(titlegap(2)) ///
		yline(0, lpattern(dash) lcolor(gs14)) ///
		grid(n) ///
		scheme(s1mono) graphregion(fcolor(white)) plotregion(fcolor(white)) ///
		text(0.1017 1.4 "{bf:Precursors Only}", orientation(vertical) color("217 95 2") place(n) size(3)) ///
		text(0.04653 2.0 "{bf:Precursors + Mediators}", orientation(vertical) color("27 158 119") place(n) size(3)) ///
		name(coef_history, replace)	

* Figure 3
graph combine coef_current coef_history, ///
		scheme(s2mono) ///
		graphregion(color(white)) ///
		plotregion(color(white)) 	
		
				
