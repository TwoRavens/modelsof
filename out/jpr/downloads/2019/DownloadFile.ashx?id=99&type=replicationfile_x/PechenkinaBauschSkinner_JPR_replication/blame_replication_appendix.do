// Anna Pechenkina & Andrew Bausch & Kiron Skinner
// Corresponding author: anna.pechenkina@usu.edu
// How do civilians attribute blame for state indiscriminate violence?
// Journal of Peace research

// Be sure to adjust all pathnames throughout

/***  REPLICATION OF THE ONLINE APPENDIX  ***/


// Be sure to adjust the pathname:
cd "/Users/.../PechenkinaBauschSkinner_JPR_replication"

clear
use "omnislav_full.dta"


/*** Table A1: Descriptive statistics for the Slovyansk sample ***/


estpost sum whichstatement_ordinal whichstatement_binary eastern  ///
female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  ///
nodamage rebeldamage govtdamage otherdamage if slovyansk==1

esttab using slov_descriptive_tableA1.tex, replace label cell((count mean sd min max sum)) nonumber nomtitle


/*** Table A2: Descriptive statistics for the combined sample ***/

estpost sum whichstatement_ordinal whichstatement_binary bombing nodamage ///
rebeldamage govtdamage otherdamage  eastern Donetska fighting ///
female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus 

esttab using combined_descriptive_tableA2.tex, replace label cell((count mean sd min max sum)) nonumber nomtitle


/*** Table A3: Descriptive statistics and difference-in-means tests for the individuals surveyed as part
of the national and Slovyansk samples***/
mat T = J(10,5,.)

ttest female , by(slovyansk)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  , by(slovyansk)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary , by(slovyansk)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian , by(slovyansk)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus , by(slovyansk)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other , by(slovyansk)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both , by(slovyansk)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus , by(slovyansk)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal , by(slovyansk)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary, by(slovyansk)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = female age education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using combined_ttest_tableA3.doc, statmat(T) varlabels replace ///
	ctitle("", "", Slovyansk=0, Slovyansk=1, Difference, t-statistic, p-value)
					
/*** Table A4: Differences in the characteristics and blame attribution between individuals who lived
in the provinces where fighting occurred and those who did not ***/
mat T = J(10,5,.)

ttest female if slovya==0, by(fighting)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  if slovya==0, by(fighting)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary if slovya==0, by(fighting)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian if slovya==0, by(fighting)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus if slovya==0, by(fighting)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other if slovya==0, by(fighting)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both if slovya==0, by(fighting)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus if slovya==0, by(fighting)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal if slovya==0, by(fighting)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary if slovya==0, by(fighting)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using national_ttest_tableA4.doc, statmat(T) varlabels replace ///
	ctitle("", "",Fighting=0, Fighting=1, Difference, t-statistic, p-value)
					

/*** Table A5: Differences in the characteristics and blame attribution between individuals who lived
in Donetska province and those who did not***/

mat T = J(10,5,.)

ttest female if slovya==0, by(Donetska)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  if slovya==0, by(Donetska)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary if slovya==0, by(Donetska)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian if slovya==0, by(Donetska)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus if slovya==0, by(Donetska)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other if slovya==0, by(Donetska)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both if slovya==0, by(Donetska)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus if slovya==0, by(Donetska)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal if slovya==0, by(Donetska)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary if slovya==0, by(Donetska)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using national_ttest_tableA5.doc, statmat(T) varlabels replace ///
	ctitle("","", Donetska=0, Donetska=1, Difference, t-statistic, p-value)
					


/*** Table A6: Differences in the characteristics and blame attribution between individuals who lived
in the eastern macroregion and those who did not. One the national sample ***/
mat T = J(10,5,.)

ttest female if slovya==0, by(eastern)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  if slovya==0, by(eastern)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary if slovya==0, by(eastern)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian if slovya==0, by(eastern)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus if slovya==0, by(eastern)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other if slovya==0, by(eastern)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both if slovya==0, by(eastern)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus if slovya==0, by(eastern)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal if slovya==0, by(eastern)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary if slovya==0, by(eastern)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using national_ttest_tableA6.doc, statmat(T) varlabels replace ///
	ctitle("","", Eastern=0, Eastern=1, Difference, t-statistic, p-value)
					

/*** Table A7: Differences in the characteristics and blame attribution between individuals who experienced
direct damage by the government and those who did not in the Slovyansk sample ***/
mat T = J(10,5,.)

ttest female if slovya==1, by(govtdamage)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  if slovya==1, by(govtdamage)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary if slovya==1, by(govtdamage)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian if slovya==1, by(govtdamage)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus if slovya==1, by(govtdamage)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other if slovya==1, by(govtdamage)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both if slovya==1, by(govtdamage)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus if slovya==1, by(govtdamage)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal if slovya==1, by(govtdamage)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary if slovya==1, by(govtdamage)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

/* NOTE: Language is not displayed in the online appendix, bc there is no variation: everyone speaks 
Russian in Slovyansk */
 
	frmttable using slov_ttest_tableA7.doc, statmat(T) varlabels replace ///
	ctitle("", "", "Govt Damage=0", "Govt Damage=1", Difference, t-statistic, p-value)

	
	
/*** Table A8: Differences in the characteristics and blame attribution between individuals who experienced
direct damage by the rebels and those who did not in the Slovyansk sample ***/
mat T = J(10,5,.)

ttest female if slovya==1, by(rebeldamage)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  if slovya==1, by(rebeldamage)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary if slovya==1, by(rebeldamage)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian if slovya==1, by(rebeldamage)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus if slovya==1, by(rebeldamage)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other if slovya==1, by(rebeldamage)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both if slovya==1, by(rebeldamage)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus if slovya==1, by(rebeldamage)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal if slovya==1, by(rebeldamage)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary if slovya==1, by(rebeldamage)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

 /* NOTE: Language is not displayed in the online appendix, bc there is no variation: everyone speaks 
Russian in Slovyansk */
	frmttable using slov_ttest_tableA8.doc, statmat(T) varlabels replace ///
	ctitle("", "", Rebel Damage=0, Rebel Damage=1, Difference, t-statistic, p-value)	
	
	


/*** Table A9: Differences in the characteristics and blame attribution between individuals who experienced
direct damage from unknown source and those who did not in the Slovyansk sample ***/
mat T = J(10,5,.)

ttest female if slovya==1, by(otherdamage)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  if slovya==1, by(otherdamage)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary if slovya==1, by(otherdamage)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian if slovya==1, by(otherdamage)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus if slovya==1, by(otherdamage)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other if slovya==1, by(otherdamage)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both if slovya==1, by(otherdamage)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus if slovya==1, by(otherdamage)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal if slovya==1, by(otherdamage)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary if slovya==1, by(otherdamage)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

/* NOTE: Language is not displayed in the online appendix, bc there is no variation: everyone speaks 
Russian in Slovyansk */
	frmttable using slov_ttest_tableA9.doc, statmat(T) varlabels replace ///
	ctitle("", "", Other Damage=0, Other Damage=1, Difference, t-statistic, p-value)	
	
	
/*** Table A10: Differences in the characteristics and blame attribution between individuals who lived
in the provinces where fighting occurred and those who did not. Combined national and Slovyansk ***/
mat T = J(10,5,.)

ttest female , by(fighting)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  , by(fighting)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary , by(fighting)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian , by(fighting)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus , by(fighting)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other , by(fighting)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both , by(fighting)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus , by(fighting)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal , by(fighting)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary , by(fighting)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using combined_ttest_A10.doc, statmat(T) varlabels replace ///
	ctitle("","", "Fighting=0", "Fighting=1", Difference, t-statistic, p-value)
					
					
					
/*** Table A11: Differences in the characteristics and blame attribution between individuals who lived
in Donetska province and those who did not. Combined national and Slovyansk samples ***/
mat T = J(10,5,.)

ttest female , by(Donetska)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  , by(Donetska)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary , by(Donetska)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian , by(Donetska)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus , by(Donetska)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other , by(Donetska)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both , by(Donetska)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus , by(Donetska)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal , by(Donetska)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary , by(Donetska)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///
 "Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using combined_ttest_A11.doc, statmat(T) varlabels replace ///
	ctitle("", "", Donetska=0, Donetska=1, Difference, t-statistic, p-value)
	
	
	
/*** Table A12: Differences in the characteristics and blame attribution between individuals who lived
in the eastern macroregion and those who did not. Combined national and Slovyansk samples ***/
mat T = J(10,5,.)

ttest female , by(eastern)
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(t)
mat T[1,5] = r(p)

ttest age  , by(eastern)
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(t)
mat T[2,5] = r(p)

ttest educ_binary , by(eastern)
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(t)
mat T[3,5] = r(p)

ttest eth_russian , by(eastern)
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(t)
mat T[4,5] = r(p)

ttest eth_both_ukrrus , by(eastern)
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(t)
mat T[5,5] = r(p)

ttest eth_other , by(eastern)
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(t)
mat T[6,5] = r(p)

ttest lang_both , by(eastern)
mat T[7,1] = r(mu_1)
mat T[7,2] = r(mu_2)
mat T[7,3] = r(mu_1) - r(mu_2)
mat T[7,4] = r(t)
mat T[7,5] = r(p)

ttest lang_rus , by(eastern)
mat T[8,1] = r(mu_1)
mat T[8,2] = r(mu_2)
mat T[8,3] = r(mu_1) - r(mu_2)
mat T[8,4] = r(t)
mat T[8,5] = r(p)

ttest whichstatement_ordinal , by(eastern)
mat T[9,1] = r(mu_1)
mat T[9,2] = r(mu_2)
mat T[9,3] = r(mu_1) - r(mu_2)
mat T[9,4] = r(t)
mat T[9,5] = r(p)

ttest whichstatement_binary , by(eastern)
mat T[10,1] = r(mu_1)
mat T[10,2] = r(mu_2)
mat T[10,3] = r(mu_1) - r(mu_2)
mat T[10,4] = r(t)
mat T[10,5] = r(p)


mat rownames T = Female  Age Education "Ethnicity: Russian" "Ethnicity: Both" "Ethnicity: Other" ///  
"Language: Both" "Language: Russian" "Which Statement (ordinal)" "Which Statement (binary)"

	frmttable using combined_ttest_A12.doc, statmat(T) varlabels replace ///
	ctitle("", "", Eastern=0, Eastern=1, Difference, t-statistic, p-value)

	
/********* SECTION A.10.1: ROBUSTNESS CHECKS FOR THE MAIN RESULTS IN THE PAPER *********/

/*** Table A13: Marginal effects of experience of bombing on individual attributions of blame for
provoked state indiscriminate violence. Logistic regressions***/

clear
use "omnislav_noslovyansk.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus ,  robust cluster(province1)
eststo full_mfx: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1: mfx


keep if eastern==1
save "omnislav_eastern.dta", replace
use "omnislav_eastern.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_east: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_east: mfx

keep if fighting==1
save "omnislav_donbas.dta", replace
use "omnislav_donbas.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_donbas: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donbas: mfx


keep if Donetska==1
save "omnislav_Donetska.dta", replace
use "omnislav_Donetska.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_donetska: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donetska: mfx





esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA13.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star( * 0.05 ** 0.01) pr2 aic bic


/*** Table A14: Marginal effects of experience of bombing on individual attributions of blame for
 provoked state indiscriminate violence. OLS regressions ***/
 
clear
use "omnislav_noslovyansk.dta"
 
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus ,  robust cluster(province1)
eststo full_mfx: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1: mfx


clear 
use "omnislav_eastern.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_east: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_east: mfx

clear
use "omnislav_donbas.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus,  robust cluster(province1)
eststo full_mfx_donbas: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donbas: mfx

clear
use "omnislav_Donetska.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_donetska: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donetska: mfx



esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA14.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.05 ** 0.01) r2 aic bic
	
	
/*** Table A15: Marginal effects of experience of bombing on individual attributions of blame for provoked state indiscriminate violence. 
Logistic regressions. Errors are clustered on the province of residence as of January 2014***/	

clear
use "omnislav_noslovyansk.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus ,  robust cluster(province2014)
eststo full_mfx: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province2014)
eststo full_mfx1: mfx


clear 
use "omnislav_eastern.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province2014)
eststo full_mfx_east: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province2014)
eststo full_mfx1_east: mfx


clear
use "omnislav_donbas.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province2014)
eststo full_mfx_donbas: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province2014)
eststo full_mfx1_donbas: mfx


clear
use "omnislav_Donetska.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust 
eststo full_mfx_donetska: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus   [iweight = cem_weights], robust 
eststo full_mfx1_donetska: mfx





esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA15.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.05 ** 0.01) pr2 aic 
	
	
/*** Table A16: Marginal effects of experience of bombing on individual attributions of blame for provoked state indiscriminate violence. OLS regressions. 
Errors are clustered on the province of residence as of January 2014***/

clear
use "omnislav_noslovyansk.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus ,  robust cluster(province2014)
eststo full_mfx: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus [iweight = cem_weights], robust cluster(province2014)
eststo full_mfx1: mfx


clear
use "omnislav_eastern.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province2014)
eststo full_mfx_east: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus   [iweight = cem_weights], robust cluster(province2014)
eststo full_mfx1_east: mfx



clear
use "omnislav_donbas.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province2014)
eststo full_mfx_donbas: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province2014)
eststo full_mfx1_donbas: mfx


clear
use "omnislav_Donetska.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust 
eststo full_mfx_donetska: mfx

reg whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus   [iweight = cem_weights], robust 
eststo full_mfx1_donetska: mfx





esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA16.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.05 ** 0.01) r2 aic 	
	
	
/********* SECTION A.10.2: ROBUSTNESS CHECKS FOR THE MAIN RESULTS IN THE PAPER *********/

	
/*** Table A17: Marginal effects of experience of bombing on individual attributions of blame for 
provoked state indiscriminate violence. Ordinal logistic regressions***/

clear
use "omnislav_noslovyansk.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(bombing) useweights


ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus ,  robust cluster(province1)
eststo full_mfx: mfx

ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1: mfx



clear
use "omnislav_eastern.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus,  robust cluster(province1)
eststo full_mfx_east: mfx

ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_east: mfx



clear
use "omnislav_donbas.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus , treatment(bombing) useweights


ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus,  robust cluster(province1)
eststo full_mfx_donbas: mfx

ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donbas: mfx



clear
use "omnislav_Donetska.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_donetska: mfx

ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donetska: mfx


esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA17.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star( * 0.05 ** 0.01) pr2 aic 

/*** Figure A1: Predicted probabilities individual willingness to attribute blame for provoked state indiscriminate violence. ***/


clear
use "omnislav_noslovyansk.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing) useweights


ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus [iweight = cem_weights], robust cluster(province1)
margins,  at(bombing==(0 1)) atmeans post	


clear
use "omnislav_eastern.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights

ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  [iweight = cem_weights], robust cluster(province1)
margins,  at(bombing==(0 1)) atmeans post	



clear
use "omnislav_donbas.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights

ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
margins,  at(bombing==(0 1)) atmeans post	



clear
use "omnislav_Donetska.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus , treatment(bombing) useweights

ologit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus [iweight = cem_weights], robust cluster(province1)
margins,  at(bombing==(0 1)) atmeans post	

clear
use "probs_ordinal.dta"



#delimit ;
twoway  (bar mean type2 if (type2 == 1 | type2 == 5 | type2 ==9 | type2 ==13 | type2 ==17 | type2 ==21 | type2==25 | type2==29), col(black)) 
		(bar mean type2 if (type2 == 2 | type2 ==  6 | type2 ==10 | type2 ==14 | type2 ==18 | type2 ==22 | type2==26 | type2==30), col(sky)) 
		(bar mean type2 if (type2 == 3 | type2 ==  7 | type2 ==11 | type2 ==15 | type2 ==19 | type2 ==23 | type2==27 | type2==31), col(reddish))
		(rcap high low type2 , lc(gs11)), 
		legend(pos(6) order(1 "Depends if Provocation" 2 "Hard to Say" 3 "Crime Regardless") region(lwidth(none)) cols(3) colfirst)  
		xlabel(2 "National - NO" 6 "National - Y" 10 "Eastern - NO" 14 "Eastern - Y" 18 "Fighting - NO" 22 "Fighting - Y" 26 "Donetska - NO" 30.5 "Donetska - Y", noticks) xtitle("")
		ytitle("Probability of Answer")  ylab(0(.20)1)  ;
		
/********* SECTION A.10.3 Replication and extension of the main results with unordered dependent variable *********/
		

/*** Table A18: Marginal effects of experience of bombing on individual attributions of blame for 
provoked state indiscriminate violence. Multinomial logistic regressions ***/



clear
use "omnislav_noslovyansk.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(bombing) useweights


mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus ,  robust cluster(province1) base(-1)
estimates store full_mfx

mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province1) base(-1)
estimates store full_mfx1


clear
use "omnislav_eastern.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(bombing) useweights


mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1) base(-1)
estimates store full_mfx_east

mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus   [iweight = cem_weights], robust cluster(province1) base(-1)
estimates store full_mfx1_east



clear
use "omnislav_donbas.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other   , treatment(bombing) useweights


mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other ,  robust cluster(province1) base(-1)
estimates store full_mfx_donbas

mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other [iweight = cem_weights], robust cluster(province1) base(-1)
estimates store full_mfx1_donbas



clear
use "omnislav_Donetska.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other   , treatment(bombing)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other   , treatment(bombing)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other   , treatment(bombing) useweights


mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other ,  robust cluster(province1) base(-1)
estimates store full_mfx_donetska

mlogit whichstatement_ordinal bombing female age educ_binary eth_russian eth_both_ukrrus eth_other [iweight = cem_weights], robust cluster(province1) base(-1)
estimates store full_mfx1_donetska



esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA18.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star( * 0.05 ** 0.01) pr2 aic 


/********* SECTION A.10.4 Proximity-based measures of exposure to violence *********/

/*** Table A19: Marginal effects of proximity to warfare on individual attributions of blame for 
provoked state indiscriminate violence ***/


clear
use "omnislav_full.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(fighting)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting) useweights


logit whichstatement_binary fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus,  robust cluster(province1)
eststo full_mfx: mfx

logit whichstatement_binary fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1: mfx



clear
use "omnislav_noslovyansk.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(fighting) useweights



logit whichstatement_binary fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_east: mfx

logit whichstatement_binary fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus   [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_east: mfx


clear
use "omnislav_full.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    , treatment(Donetska)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    , treatment(Donetska)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    , treatment(Donetska) useweights


logit whichstatement_binary Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  ,  robust cluster(province1)
eststo full_mfx_donbas: mfx

logit whichstatement_binary Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donbas: mfx



clear
use "omnislav_noslovyansk.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska) useweights


logit whichstatement_binary Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus,  robust cluster(province1)
eststo full_mfx_donetska: mfx

logit whichstatement_binary Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donetska: mfx





esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA19.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01) pr2 aic 


	
/*** Table A20: Marginal effects of proximity to warfare on individual attributions of blame for 
provoked state indiscriminate violence ***/

clear
use "omnislav_full.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(fighting)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting) useweights


ologit whichstatement_ordinal fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus,  robust cluster(province1)
eststo full_mfx: mfx

ologit whichstatement_ordinal fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1: mfx


clear
use "omnislav_noslovyansk.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus  , treatment(fighting)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting) useweights



ologit whichstatement_ordinal fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus ,  robust cluster(province1)
eststo full_mfx_east: mfx

ologit whichstatement_ordinal fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus   [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_east: mfx

clear
use "omnislav_full.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    , treatment(Donetska)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    , treatment(Donetska)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    , treatment(Donetska) useweights


ologit whichstatement_ordinal Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  ,  robust cluster(province1)
eststo full_mfx_donbas: mfx

ologit whichstatement_ordinal Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus    [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donbas: mfx


clear
use "omnislav_noslovyansk.dta"

imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska) useweights


ologit whichstatement_ordinal Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus if slovya==0 ,  robust cluster(province1)
eststo full_mfx_donetska: mfx

ologit whichstatement_ordinal Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  if slovya==0  [iweight = cem_weights], robust cluster(province1)
eststo full_mfx1_donetska: mfx





esttab full_mfx full_mfx1 full_mfx_east full_mfx1_east full_mfx_donbas full_mfx1_donbas full_mfx_donetska full_mfx1_donetska ///
    using tableA20.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01) pr2 aic 

/*** Figure A2: Predicted probabilities individual willingness to attribute blame for provoked state indiscriminate violence. ***/

**Models 4 and 8 from Table A20:
clear
use "omnislav_noslovyansk.dta"
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus   , treatment(fighting) useweights

ologit whichstatement_ordinal fighting female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  if slovya==0 [iweight = cem_weights], robust cluster(province1)
margins,  at(fighting==(0 1)) atmeans post	


imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska)
cem  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska)
imb  female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  , treatment(Donetska) useweights

ologit whichstatement_ordinal Donetska female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both lang_rus  if slovya==0  [iweight = cem_weights], robust cluster(province1)
margins,  at(Donetska==(0 1)) atmeans post	

clear
use "probs_ordinal_proximity.dta"

#delimit ;
twoway  (bar mean type2 if  (type2 == 1 | type2 == 5 | type2 ==9 | type2 ==13 ), col(black)) 
		(bar mean type2 if (type2 == 2 | type2 ==  6 | type2 ==10 | type2 ==14 ), col(sky)) 
		(bar mean type2 if (type2 == 3 | type2 ==  7 | type2 ==11 | type2 ==15 ), col(reddish))
		(rcap high low type2 if type2 <16, lc(gs11)), 
		legend(pos(6) order(1 "Depends if Provocation" 2 "Hard to Say" 3 "Crime Regardless" ) region(lwidth(none) ) cols(3) colfirst size(2.5))  
		xlabel(2 "No Fighting" 6 "Fighting" 10 "No Donetska" 14 "Donetska" , noticks) xtitle("")
		ytitle("Probability of Answer")  ylab(0(.20)1) xsize(4) ;

/********* SECTION A.10.5 Effects of direct damage on blame attribution in the Slovyansk sample *********/

/***Table A21: Effects of suffering damage to property on individual attributions of blame for pro-
voked state indiscriminate violence in the Slovyansk Sample ***/


use "omnislav_full.dta"
keep if slovyansk==1
save "omnislav_onlyslov.dta", replace	
use "omnislav_onlyslov.dta"
	
imb  female age educ_binary eth_russian    , treatment(anydamage)
cem  female age educ_binary eth_russian    , treatment(anydamage)
imb  female age educ_binary eth_russian     , treatment(anydamage) useweights


logit whichstatement_binary anydamage female age educ_binary eth_russian ,  robust 
eststo full_mfx1: mfx

logit whichstatement_binary anydamage female age educ_binary eth_russian [iweight = cem_weights], robust 
eststo full_mfx2: mfx
margins,  at(anydamage==(0 1)) atmeans post	
test 1._at == 2._at


imb  female age educ_binary eth_russian   , treatment(rebeldamage)
cem  female age educ_binary eth_russian   , treatment(rebeldamage)
imb  female age educ_binary eth_russian   , treatment(rebeldamage) useweights



logit whichstatement_binary rebeldamage female age educ_binary eth_russian ,  robust 
eststo full_mfx3: mfx

logit whichstatement_binary rebeldamage female age educ_binary eth_russian [iweight = cem_weights], robust 
eststo full_mfx4: mfx
margins,  at(rebeldamage==(0 1)) atmeans post	
test 1._at == 2._at


imb  female age educ_binary eth_russian   , treatment(govtdamage)
cem  female age educ_binary eth_russian   , treatment(govtdamage)
imb  female age educ_binary eth_russian   , treatment(govtdamage) useweights


logit whichstatement_binary govtdamage female age educ_binary eth_russian,  robust 
eststo full_mfx5: mfx

logit whichstatement_binary govtdamage female age educ_binary eth_russian [iweight = cem_weights], robust 
eststo full_mfx6: mfx
margins,  at(govtdamage==(0 1)) atmeans post	
test 1._at == 2._at




esttab full_mfx1 full_mfx2  full_mfx3 full_mfx4 full_mfx5 full_mfx6 ///
    using tableA21.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01) pr2 aic 	
	
	
	
/********* SECTION A.11 Replication of main results with entropy balancing *********/

	
/*** Table A22: Marginal effects of individual experience of bombing on individual attributions of
blame for provoked state indiscriminate violence. Entropy balancing ***/	


clear
use "omnislav_noslovyansk.dta"
ebalance bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus, targets(3)


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus, robust cluster(province1)
eststo full_mfx1: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus [iweight = _webal], robust cluster(province1)
eststo full_mfx2: mfx




ebalance bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if eastern ==1, targets(3)


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if eastern ==1, robust cluster(province1)
eststo full_mfx3: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if eastern ==1 [iweight = _webal], robust cluster(province1)
eststo full_mfx4: mfx



ebalance bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if fighting ==1, targets(3)


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if fighting ==1, robust cluster(province1)
eststo full_mfx5: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if fighting ==1 [iweight = _webal], robust cluster(province1)
eststo full_mfx6: mfx



ebalance bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if Donetska ==1, targets(3)


logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if Donetska ==1, robust cluster(province1)
eststo full_mfx7: mfx

logit whichstatement_binary bombing female age educ_binary eth_russian eth_both_ukrrus eth_other lang_both  lang_rus if Donetska ==1 [iweight = _webal], robust cluster(province1)
eststo full_mfx8: mfx


esttab full_mfx1 full_mfx2  full_mfx3 full_mfx4 full_mfx5 full_mfx6 full_mfx7 full_mfx8 ///
    using tableA22.tex, replace f ///
 	label booktabs margin se(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01) pr2 aic 	
	


