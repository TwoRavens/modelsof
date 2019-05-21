

use article_level_data.dta, replace

gen LOCAL=1    if CULPRIT!=.   

gen LOCAL_POLITICS=1  if (CULPRIT<5|CULPRIT==8) &CULPRIT!=.

gen COPS=1    if CULPRIT>4 &CULPRIT<8 &CULPRIT!=. 

gen LOCAL_HI_POLITICS=1 if (CULPRIT ==1|CULPRIT==8)&CULPRIT_LEVEL!=1&CULPRIT!=. 

gen LOCAL_PETTY=1 if COPS==1|((CULPRIT<3|CULPRIT==8)&(CULPRIT_LEVEL==1)&CULPRIT!=.) 

bys NWSP date_p: egen local_articles=count(LOCAL)

label variable local_a "Local articles, including police and human rights abuse"
 
bys NWSP date_p: egen local_politics_articles=count(LOCAL_POLITICS)

label variable local_p "Local articles on political and bureaucratic corruption"

by NWSP date_p: egen local_cops=count(COPS)

label variable local_cops "Local articles on police and human rights abuse"

by NWSP date_p: egen local_hilevel=count(LOCAL_HI_POLITICS)

label variable local_hile "Local articles on politicians at state and federal level"

by NWSP date_p: egen local_petty=count(LOCAL_PETTY)

label variable local_petty "Local articles on politicians and bureaucrats at municipal level, and cops"

bys NWSP date_p: keep if _n==1 

drop LOCAL LOCAL_POLITICS COPS LOCAL_HI_POLITICS LOCAL_PETTY HEAD_N HEAD_FULL SECT PAGE LENGTH REMARK NON_LOC ALLEG_TYPE ALLEG_OTHER LOCAL_SPECIFIC CULPRIT CULPRIT_LEVEL ALLEG_TYPE2 ALLEG_TYPE3 vote_buy elect_fraud hr_abuse desvio not_corruption

save mexpress.dta, replace

