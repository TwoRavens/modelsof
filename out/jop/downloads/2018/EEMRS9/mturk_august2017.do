
/* DO FILE FOR MTURK AUGUST 2017 STUDY ON RESPONSIBILITY ATTITUDES */

/* APPENDIX 10 */



gen treatment=.
replace treatment=1 if high_percent==1
replace treatment=2 if high_N==1
replace treatment=3 if low_percent==1
replace treatment=4 if low_N==1

/* RESPONSIBILTY QUESTIONS */


/* models */
by treatment: sum polecon
ttest polecon if (treatment==1 | treatment==2), by(treatment)
ttest polecon if (treatment==1 | treatment==3), by(treatment)
ttest polecon if (treatment==1 | treatment==4), by(treatment)

by treatment: sum lackeffort
ttest lackeffort if (treatment==1 | treatment==2), by(treatment)
ttest lackeffort if (treatment==1 | treatment==3), by(treatment)
ttest lackeffort if (treatment==1 | treatment==4), by(treatment)

by treatment: sum outsidecontrol
ttest outsidecontrol if (treatment==1 | treatment==2), by(treatment)
ttest outsidecontrol if (treatment==1 | treatment==3), by(treatment)
ttest outsidecontrol if (treatment==1 | treatment==4), by(treatment)

by treatment: sum shouldhelp
ttest shouldhelp if (treatment==1 | treatment==2), by(treatment)
ttest shouldhelp if (treatment==1 | treatment==3), by(treatment)
ttest shouldhelp if (treatment==1 | treatment==4), by(treatment)






