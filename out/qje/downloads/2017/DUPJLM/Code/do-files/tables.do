
use oursample.dta, clear

keep if uibase>uibase70
keep if age>=25  & age<50


***************************
***************************
*table A-1
***************************
***************************

preserve
ttest sex, by(after)
ttest age, by(after)
recode qeduc 1=8 2=12 3=16, gen(qeduc2)
ttest qeduc2, by(after)
ttest linc2002, by(after)
ttest linc2003, by(after)
ttest linc2004, by(after)
ttest length_nobenef, by(after)
ttest reempbon1tier, by(after)
ttest train, by(after)
ttest wrong, by(after)
ta after


***************************
***************************
*table A-10
***************************
***************************


global X  educy_2 educy_22 age52-age55 sex length_nobenef linc2002 linc2003  ///
	linc2002_mis  linc2003_mis   occlastjob1dig2-occlastjob1dig10 occlastjob1dig_mis ///
		county2-county20 beguispell_month2-beguispell_month9 beguispell_day2-beguispell_day31 

drop col*
		
quietly  reg durnoempcap $X  if after==0
predict col1 if after==0
su col1,d
quietly  reg durnoempcap $X  if after==1
predict col2 if after==0
su col2,d

quietly  reg lfirst $X  if after==0
predict col3 if after==0
su col3,d
quietly  reg lfirst $X  if after==1
predict col4 if after==0
su col4,d

