

/* Pilot Study, March 2015 */
/* APPENDIX 9 and 10 */


gen treatment = 999
recode treatment 999=1 if control==1
recode treatment 999=2 if person==1
recode treatment 999=3 if statspercent==1
recode treatment 999=4 if statsN==1
recode treatment 999=.

sort treatment



/* Appendix 9 */
tab female
tab age44_over
tab democrat
tab college
tab income45k_over

/* Appendix 9 */
by treatment: sum sympathy
ttest sympathy if (treatment==1 | treatment==2), by(treatment)
ttest sympathy if (treatment==1 | treatment==3), by(treatment)
ttest sympathy if (treatment==1 | treatment==4), by(treatment)

by treatment: sum worried
ttest worried if (treatment==1 | treatment==2), by(treatment)
ttest worried if (treatment==1 | treatment==3), by(treatment)
ttest worried if (treatment==1 | treatment==4), by(treatment)

/* Appendix 10 */
by treatment: sum blame
ttest blame if (treatment==1 | treatment==2), by(treatment)
ttest blame if (treatment==1 | treatment==3), by(treatment)
ttest blame if (treatment==1 | treatment==4), by(treatment)
