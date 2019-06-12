/* Title: Shaping Democratic Practice and the Causes of Electoral Fraud: The Case of Nineteenth-Century Germany (ASPR, Vol. 103, No. 1, February 2009)  Input: APSRReplicationZiblatt.dta    Daniel Ziblatt, Harvard University  Created: 12/05/2010  Modified: 12/05/2010
*/

use APSRReplicationZiblatt.dta, clear

*** Generate variables ***
gen competitiveness = -competer2
gen competitivenessLag = -competer2Lag


*** Summary Statistics ***
summ landgini1895

* 948 cases out of 5161 elections were coded as fraudulent (this differs from the 974 total petitions filed since in some years multiple petitions were filed for each seat)
count if fraud==1

* Figure 2: Number of disputed elections by year
count if fraud==1 & year_1871==1
count if fraud==1 & year_1874==1
count if fraud==1 & year_1877==1
count if fraud==1 & year_1878==1
count if fraud==1 & year_1881==1
count if fraud==1 & year_1884==1
count if fraud==1 & year_1887==1
count if fraud==1 & year_1890==1
count if fraud==1 & year_1893==1
count if fraud==1 & year_1898==1
count if fraud==1 & year_1903==1
count if fraud==1 & year_1907==1
count if fraud==1 & year_1912==1

* Show that first decile of ag1 variable is below 11.7% and median is 52.4%
summarize ag1, detail

** For replication of Figure 3, run command "by district: count if fraud==1" to tally number of elections that were coded as fradulent by district




macro define myout1 "pvalue tdec(3) pdec(3)" 

*** Table 1: Time-Series Cross-Sectional Analysis of Fraud ***
* Model 1: Baseline
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged if ag1 >= 11.7, robust
outreg2 using Table1.doc, $myout1 replace word

* Model 2: Controlling for Time
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time if ag1 >= 11.7, robust
outreg2 using Table1.doc, $myout1 append word

* Model 3: Controlling for Time and Time Squared
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time time2 if ag1 >= 11.7, robust
outreg2 using Table1.doc, $myout1 append word

* Model 4: Controlling for Partisan Center of Gravity of Election Committee
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged committteecengravity if ag1 >= 11.7, robust
outreg2 using Table1.doc, $myout1 append word

* Model 5: Controlling for Neutrality of Election Committee Chair
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged sympathy if ag1 >= 11.7, robust
outreg2 using Table1.doc, $myout1 append word


*** Table 1.a: Time-Series Cross-Sectional Analysis of Fraud For All Districts (Footnote 19a) ***
* Model 1: Baseline
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged, robust
outreg2 using Table1a.doc, $myout1 replace word

* Model 2: Controlling for Time
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time, robust
outreg2 using Table1a.doc, $myout1 append word

* Model 3: Controlling for Time and Time Squared
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time time2, robust
outreg2 using Table1a.doc, $myout1 append word

* Model 4: Controlling for Partisan Center of Gravity of Election Committee
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged committteecengravity, robust
outreg2 using Table1a.doc, $myout1 append word

* Model 5: Controlling for Neutrality of Election Committee Chair
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged sympathy, robust
outreg2 using Table1a.doc, $myout1 append word


*** Table 1.b: Time-Series Cross-Sectional Analysis of Fraud For Districts with Over 52% Employed in Agriculture (Footnote 19b) ***
* Model 1: Baseline
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged if ag1 >= 52, robust
outreg2 using Table1b.doc, $myout1 replace word

* Model 2: Controlling for Time
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time if ag1 >= 52, robust
outreg2 using Table1b.doc, $myout1 append word

* Model 3: Controlling for Time and Time Squared
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time time2 if ag1 >= 52, robust
outreg2 using Table1b.doc, $myout1 append word

* Model 4: Controlling for Partisan Center of Gravity of Election Committee
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged committteecengravity if ag1 >= 52, robust
outreg2 using Table1b.doc, $myout1 append word

* Model 5: Controlling for Neutrality of Election Committee Chair
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged sympathy if ag1 >= 52, robust
outreg2 using Table1b.doc, $myout1 append word


*** Table 1.c: Time-Series Cross-Sectional Analysis of Fraud with Dummy Variable for Prussia (Footnote 21e) ***
* Model 1: Baseline
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged prussiadummy if ag1 >= 11.7, robust
outreg2 using Table1c.doc, $myout1 replace word

* Model 2: Controlling for Time
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time prussiadummy if ag1 >= 11.7, robust
outreg2 using Table1c.doc, $myout1 append word

* Model 3: Controlling for Time and Time Squared
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged time time2 prussiadummy if ag1 >= 11.7, robust
outreg2 using Table1c.doc, $myout1 append word

* Model 4: Controlling for Partisan Center of Gravity of Election Committee
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged committteecengravity prussiadummy if ag1 >= 11.7, robust
outreg2 using Table1c.doc, $myout1 append word

* Model 5: Controlling for Neutrality of Election Committee Chair
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 fraudlagged sympathy prussiadummy if ag1 >= 11.7, robust
outreg2 using Table1c.doc, $myout1 append word





*** Table 2: Cross-Sectional Analysis of Electoral Fraud by Year ***
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1871==1, robust
outreg2 using Table2.doc, $myout1 replace word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1874==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1877==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1878==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1881==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1884==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1887==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1890==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1893==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1898==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1903==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1907==1, robust
outreg2 using Table2.doc, $myout1 append word
logit fraud landgini1895 competitiveness catholic turnoutr2 pop ag1 if ag1 >= 11.7 & year_1912==1, robust
outreg2 using Table2.doc, $myout1 append word



