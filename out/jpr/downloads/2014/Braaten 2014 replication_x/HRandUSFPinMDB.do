/* 
This file replicates the analysis in Braaten, Daniel "Determinants of US foreign policy in the multilateral development 
banks: The place of human rights" Journal of Peace Research.  Please contact Daniel Braaten at dbraaten@tlu.edu or dannybraaten12@yahoo.com
if you have any questions or any problems arise while running this file.
*/



use "HRandUSFPinMDBdata.dta"

/*
multinomial logistic regression on full model and change in predicted probabilities.  Seen in Table I
*/
mlogit USVOTE POL PI MILAID UNVOTE lnTRADE lnDEV IDEOLOGY CONFLICT lnPOPULATION, robust cluster(countryyear)
prchange
/*
probability and confidence intervals of US no, abstention, and yes votes given each value of the Political 
Rights variable and the Military Aid variable.  This will produce the full results for Table II seen in the 
online appendix.     
*/
prvalue, x(POL=1 MILAID=0)
prvalue, x(POL=1 MILAID=1)
prvalue, x(POL=2 MILAID=0)
prvalue, x(POL=2 MILAID=1)
prvalue, x(POL=3 MILAID=0)
prvalue, x(POL=3 MILAID=1)
prvalue, x(POL=4 MILAID=0)
prvalue, x(POL=4 MILAID=1)
prvalue, x(POL=5 MILAID=0)
prvalue, x(POL=5 MILAID=1)
prvalue, x(POL=6 MILAID=0)
prvalue, x(POL=6 MILAID=1)
prvalue, x(POL=7 MILAID=0)
prvalue, x(POL=7 MILAID=1)
/*
probability and confidence intervals of US no, abstention, and yes votes given each value of the Political 
Rights variable and the values two standard deviations below and above the mean of the lnTRADE variable.  
This will produce the full results for Table II seen in the online appendix.  The summarize lnTrade command 
produces the mean and standard deviation for lnTRADE and from which the values two standard deviations below and 
above the mean were calculated
*/
summarize lnTRADE
prvalue, x(POL=1 lnTRADE=2.284785)
prvalue, x(POL=2 lnTRADE=2.284785)
prvalue, x(POL=3 lnTRADE=2.284785)
prvalue, x(POL=4 lnTRADE=2.284785)
prvalue, x(POL=5 lnTRADE=2.284785)
prvalue, x(POL=6 lnTRADE=2.284785)
prvalue, x(POL=7 lnTRADE=2.284785)
prvalue, x(POL=1 lnTRADE=12.856913)
prvalue, x(POL=2 lnTRADE=12.856913)
prvalue, x(POL=3 lnTRADE=12.856913)
prvalue, x(POL=4 lnTRADE=12.856913)
prvalue, x(POL=5 lnTRADE=12.856913)
prvalue, x(POL=6 lnTRADE=12.856913)
prvalue, x(POL=7 lnTRADE=12.856913)
/*
probability and confidence intervals of US no, abstention, and yes votes given each value of the Political 
Rights variable and the values two standard deviations below and above the mean of the lnDEV variable.  
This will produce the full results for Table II seen in the online appendix.  The summarize lnDEV command produces 
the mean and standard deviation for lnDEV and from which the values two standard deviations below and above the 
mean were calculated
*/
summarize lnDEV
prvalue, x(POL=1 lnDEV=5.281008)
prvalue, x(POL=2 lnDEV=5.281008)
prvalue, x(POL=3 lnDEV=5.281008)
prvalue, x(POL=4 lnDEV=5.281008)
prvalue, x(POL=5 lnDEV=5.281008)
prvalue, x(POL=6 lnDEV=5.281008)
prvalue, x(POL=7 lnDEV=5.281008)
prvalue, x(POL=1 lnDEV=9.807464)
prvalue, x(POL=2 lnDEV=9.807464)
prvalue, x(POL=3 lnDEV=9.807464)
prvalue, x(POL=4 lnDEV=9.807464)
prvalue, x(POL=5 lnDEV=9.807464)
prvalue, x(POL=6 lnDEV=9.807464)
prvalue, x(POL=7 lnDEV=9.807464)
/*
robustness test seen in Table VI in the online appendix.  the variable DEMOCRACY is substituted for POL in this 
multinomial logistic regression and change in predicted probabilities
*/
mlogit USVOTE DEMOCRACY PI MILAID UNVOTE lnTRADE lnDEV IDEOLOGY CONFLICT lnPOPULATION, robust cluster(countryyear)
prchange
/*
robustness test seen in Table VII in the online appendix.  the variable EMPIX is substituted for POL in this 
multinomial logistic regression and change in predicted probabilities
*/
mlogit USVOTE EMPIX PI MILAID UNVOTE lnTRADE lnDEV IDEOLOGY CONFLICT lnPOPULATION, robust cluster(countryyear)
prchange
/*
robustness test seen in Table VIII in the online appendix.  the variable DEMOCRACY is added to the full model seen 
Table I in this multinomial logistic regression and change in predicted probabilities
*/
mlogit USVOTE POL PI DEMOCRACY MILAID UNVOTE lnTRADE lnDEV IDEOLOGY CONFLICT lnPOPULATION, robust cluster(countryyear)
prchange
/*
tabulates the number of votes for each country in the dataset.  the Top 10 countries with the most votes are seen in
Table IV in the online appendix
*/
tabulate country USVOTE
/*
tabulates the number of country votes for each category in the POL variable in the dataset.  All countries with at
least one country vote in worst violators of Political Rights category (POL=1) are produced in Table V in the
online appendix.
*/
tabulate country POL
/*
drops all observations in the dataset for China.  the Correlates of War country code for China is 710
*/
drop if cowcode==710
/*
multinomial logistic regression on model without China observation and change in predicted probabilities.  
Seen in Table III
*/
mlogit USVOTE POL PI MILAID UNVOTE lnTRADE lnDEV IDEOLOGY CONFLICT lnPOPULATION, robust cluster(countryyear)
prchange






