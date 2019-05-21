clear all

*set working directory to folder containing data files
use "Study 1 Pretest Replication Data.dta"

gen HA = 0
replace HA=1 if (haldr==1 | hahdr==1 | hald==1 | hahd==1)
gen HD = 0
replace HD=1 if (lahdr==1 | lahd==1 | hahdr==1 | hahd==1)

gen Disgust = (emot_1 + emot_2 + emot_3)/3
gen Anxiety = (emot_4 + emot_5 + emot_6)/3

ttest Disgust, by(HD)
ttest Anxiety, by(HD)

ttest Disgust, by(HA)
ttest Anxiety, by(HA)
