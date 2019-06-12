*Set working directory to the file location

use "JEPS Replication Data.dta", clear

*** Equity and Self-Interest Results ***
//T-tests for Participants in the Door Rule Condition//
//Disadvantaged vs. Equal Comparison
ttest fairratings if sourcecond == 1 & faircond != 2, by(faircond)
*Effect size
esize twosample fairratings if sourcecond == 1 & faircond != 2, by(faircond)

//Advantaged  vs. Equal Comparison
ttest fairratings if sourcecond == 1 & faircond < 3, by(faircond)
*Effect size
esize twosample fairratings if sourcecond == 1 & faircond < 3, by(faircond)

//Advantaged vs. Disadvantaged Comparison
ttest fairratings if sourcecond == 1 & faircond >1, by(faircond)
*Effect Size
esize twosample fairratings if sourcecond == 1 & faircond >1, by(faircond)

//T-tests for Participants in the Eyes Rule Condition//
//Disadvantaged vs. Equal Comparison
ttest fairratings if sourcecond == 3 & faircond != 2, by(faircond)
*Effect size
esize twosample fairratings if sourcecond == 3 & faircond != 2, by(faircond)

//Advantaged  vs. Equal Comparison
ttest fairratings if sourcecond == 3 & faircond < 3, by(faircond)
*Effect size
esize twosample fairratings if sourcecond == 3 & faircond < 3, by(faircond)

//Advantaged vs. Disadvantaged Comparison
ttest fairratings if sourcecond == 3 & faircond >1, by(faircond)
*Effect Size
esize twosample fairratings if sourcecond == 3 & faircond >1, by(faircond)

//T-tests for Participants in the Party Rule Condition//
//Disadvantaged vs. Equal Comparison
ttest fairratings if sourcecond == 2 & faircond != 2, by(faircond)
*Effect size
esize twosample fairratings if sourcecond == 2 & faircond != 2, by(faircond)

//Advantaged  vs. Equal Comparison
ttest fairratings if sourcecond == 2 & faircond < 3, by(faircond)
*Effect size
esize twosample fairratings if sourcecond == 2 & faircond < 3, by(faircond)

//Advantaged vs. Disadvantaged Comparison
ttest fairratings if sourcecond == 2 & faircond >1, by(faircond)
*Effect Size
esize twosample fairratings if sourcecond == 2 & faircond >1, by(faircond)


*** Divisiveness and Affective Polarization Results***
///T-tests for Participants in Disadvantaged Condition
//Eye vs. Door Comparison
ttest fairratings if faircond == 3 & sourcecond != 2, by(sourcecond)
*Effect Size
esize twosample fairratings if faircond == 3 & sourcecond != 2, by(sourcecond)

//Door vs. Party Comparison
ttest fairratings if faircond == 3 & sourcecond < 3, by(sourcecond)
*Effect Size
esize twosample fairratings if faircond == 3 & sourcecond < 3, by(sourcecond)

//Party vs. Eye Comparison
ttest fairratings if faircond == 3 & sourcecond >1, by(sourcecond)
*Effect Size
esize twosample fairratings if faircond == 3 & sourcecond >1, by(sourcecond)


///T-tests for Participants in Advantaged Condition
//Eye vs. Door Comparison
ttest fairratings if faircond == 2 & sourcecond != 2, by(sourcecond)
*Effect Size
esize twosample fairratings if faircond == 2 & sourcecond != 2, by(sourcecond)

//Door vs. Party Comparison
ttest fairratings if faircond == 2 & sourcecond < 3, by(sourcecond)
*Effect Size
esize twosample fairratings if faircond == 3 & sourcecond < 3, by(sourcecond)

//Party vs. Eye Comparison
ttest fairratings if faircond == 2 & sourcecond >1, by(sourcecond)
*Effect Size
esize twosample fairratings if faircond == 3 & sourcecond >1, by(sourcecond)


***How does partisan strength relate to judgemnts of fairness discimrination (Table 3)***
// Generate a dichomtomous variable for Strong/Moderate Partisanship (1) vs. Weak Partisanship (0)
gen strongparty = 0
replace strongparty = 1 if party != 3 & party != 4
///Disadvantaged Participants///
//Door vs. Party for Strong Partisans
ttest fairratings if faircond == 3 & sourcecond<3 & strongparty == 1, by(sourcecond)
*Effect size
esize twosample fairratings if faircond == 3 & sourcecond <3 & strongparty == 1, by(sourcecond)
//Eyes vs. Party for Strong Partisans
ttest fairratings if faircond == 3 & sourcecond > 1 & strongparty == 1, by(sourcecond)
*Effect size
esize twosample fairratings if faircond == 3 & sourcecond > 1 & strongparty == 1, by(sourcecond)
//Door vs. Party for Weak Partisans
ttest fairratings if faircond == 3 & sourcecond<3 & strongparty == 0, by(sourcecond)
*Effect size
esize twosample fairratings if faircond == 3 & sourcecond <3 & strongparty == 0, by(sourcecond)
//Eyes vs. Party for Weak Partisans
ttest fairratings if faircond == 3 & sourcecond > 1 & strongparty == 0, by(sourcecond)
*Effect size
esize twosample fairratings if faircond == 3 & sourcecond > 1 & strongparty == 0, by(sourcecond)

///Advantaged Participants///
//Door vs. Party for Strong Partisans
ttest fairratings if faircond == 2 & sourcecond <3 & strongparty == 1, by(sourcecond)
*Effect size
esize twosample fairratings if faircond == 2 & sourcecond <3 & strongparty == 1, by(sourcecond)
//Eyes vs. Party for Strong Partisans
ttest fairratings if faircond == 2 & sourcecond > 1 & strongparty == 1, by(sourcecond)
esize twosample fairratings if faircond == 2 & sourcecond > 1 & strongparty == 1, by(sourcecond)
//Door vs. Party for Weak Partisans
ttest fairratings if faircond == 2 & sourcecond <3 & strongparty == 0, by(sourcecond)
*Effect size
esize twosample fairratings if faircond == 2 & sourcecond <3 & strongparty == 0, by(sourcecond)
//Eyes vs. Party for Weak Partisans
ttest fairratings if faircond == 2 & sourcecond > 1 & strongparty == 0, by(sourcecond)
*Effect size
esize twosample fairratings if faircond == 2 & sourcecond > 1 & strongparty == 0, by(sourcecond)

/*Appendix Analyses start here*/
***Table A1***
///Disadvantaged Participants
//Door vs. Eyes Comparison
ranksum fairratings if faircond == 3 & sourcecond != 2, by(sourcecond)
//Door vs. Party Comparison
ranksum fairratings if faircond == 3 & sourcecond < 3, by(sourcecond)
//Eyes vs. Party Comparison
ranksum fairratings if faircond == 3 & sourcecond >1, by(sourcecond)
///Advantaged Participants
//Door vs. Eyes Comparison
ranksum fairratings if faircond == 2 & sourcecond != 2, by(sourcecond)
//Door vs. Party Comparison
ranksum fairratings if faircond == 2 & sourcecond < 3, by(sourcecond)
//Eyes vs. Party Comparison
ranksum fairratings if faircond == 2 & sourcecond >1, by(sourcecond)

***Table A2***

///OLS for Disadvantaged Participants
reg fairratings i.sourcecond female age if faircond == 3
*Comparison of party rule to eyes rule
test 2.sourcecond = 3.sourcecond
///OLS for Advantaged Participants
reg fairratings i.sourcecond female age if faircond ==2

