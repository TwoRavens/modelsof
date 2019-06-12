

****TABLE 1: TVERSKY AND KAHNEMAN (1981)
***STUDY 2, WAVE 2
clear
set mem 100m
use "Screener_SSI__Wave_2.dta"

g die_frame=1 if kt_treatment=="KT_die"
replace die_frame = 0 if kt_treatment=="KT_saved"

tab kt_program die_frame if trained==0, col
tab kt_program die_frame if trained==0 & correct_scr_3==1, col
tab kt_program die_frame if trained==0 & correct_scr_3==0, col



****TABLE 2: ANES CORRELATIONS
****STUDY 2, WAVE 1
clear
set mem 100m
use "Screener_SSI__Wave_1.dta"


corr govt_std govt_spend govt_inc if trained==0
corr govt_std govt_spend govt_inc if correct_scr_2==1 & trained==0
corr govt_std govt_spend govt_inc  if correct_scr_2==0 & trained==0


*****TABLE 3: CORRELATION AMONG PASSAGE RATES
****STUDY 2, WAVE 1
clear
set mem 100m
use "Screener_SSI__Wave_1.dta"

corr correct_web correct_int correct_color correct_feel


*****TABLE 4: CORRELATION ACROSS WAVES
clear
set mem 100m
use "merged.dta"

corr correct_web1 correct_web2
corr correct_int1 correct_int2
corr correct_color1 correct_color2
corr correct_feel1 correct_feel2


******TABLE 5: DEMOGRAHICS CAN PREDICT SCREENER PASSAGE

**ADAM'S SSI DATA
clear
set mem 500m
set more off
use "SSI DP Data.dta"

*use scrn_s, age age2, female, black, hisp, poliinfo, college

g some_coll=0
replace some_coll=1 if edu==3 | edu==4

g hs_orless=0
replace hs_orless=1 if edu<3

replace age2 = age2/1000

g other_race =0
replace other_race = 1 if race>3
replace other_race=. if race==.

reg scrn_s some_coll college poliinfo  age age2 female black hisp other_race, r
reg scrn_s some_coll college age age2 female black hisp other_race, r




 **MIDWEST DATA SCREEN OR CUE
 clear
 set mem 100m
 use "Partisanship_MPSA__SSI_cleaned_new.dta"

destring warning, replace
gen warned = 1 if warning!=.
replace warned = 0 if warning==.

rename hisp hispanic

g other = race>3
replace other=. if race==.

drop if age<18
replace age2 = age2/1000

destring edu, replace
g some_coll=0
replace some_coll=1 if edu==3 | edu==4

g hs_orless=0
replace hs_orless=1 if edu<3
replace hs_orless=. if edu==.

g college=0
replace college=1 if edu>4
replace college=. if edu==.

destring nfc*, replace
g cog_a =0 if nfc3==2
replace cog_a=0.5 if nfc3==3
replace cog_a=1 if nfc3==1

g cog_b=1 if nfc4==2
replace cog_b=0 if nfc4==1

egen cog = rmean(cog_a cog_b)

destring relevant, replace

reg screen some_coll college age age2 black hispanic other cog if warned==0, r
reg screen some_coll college age age2 black hispanic other if warned==0, r




**SUMMER 2011 SSI

clear
set mem 100m
use "Screener_SSI__Wave_1.dta"

gen educ2 = .
replace educ2 = 0 if educ == 1 | educ == 2
replace educ2 = 1 if educ == 3 | educ == 4
replace educ2 = 2 if educ > 4 & educ != .

gen age2 = (age^2)/1000

*exclude repsondents who were in the training condition
xi: reg screen i.educ2 age age2 female black hisp other cognition if trained==0, r
xi: reg screen i.educ2 age age2 female black hisp other if trained==0, r





**JANUARY 2012 SSI

clear 
set mem 100m
use "SSI_January_2012_merged_cleaned.dta"

gen educ_recode = .
replace educ_recode = 0 if educ == 1 | educ == 2
replace educ_recode = 1 if educ == 3 | educ == 4
replace educ_recode = 2 if educ > 4 & educ != .

*use female, black, age1, cog1, knowledge1

replace agesq1 = (age1^2)/1000

g hispanic=race==3
replace hispanic=. if race==.

g other=race>3
replace other=. if race==.

*want to exclude respondents trained on the first screener (if trained on second screener, it's after 2nd screener)
xi: reg screen1  i.educ_recode knowledge1 age1 agesq1 female1 black1 hispanic other cog1 if trained_news1==0, r
xi: reg screen1  i.educ_recode age1 agesq1 female1 black1 hispanic other if trained_news1==0, r



**May 2012 SSI
clear
set mem 500m

insheet using "1728_Survey.csv"

gen female = gender - 1
gen age = yob+11
gen age2 = (age^2)/1000

gen educ_recode = .
replace educ_recode = 0 if educ == 1 | educ == 2
replace educ_recode = 1 if educ == 3 | educ == 4
replace educ_recode = 2 if educ > 4 & educ != .

g black=race==2
replace black=. if race==.

g hispanic=race==3
replace hispanic=. if race==.

g other= race>3
replace other=. if race==.

g correct_scr1 = 1 if scr_int==6
replace correct_scr1 = 0 if scr_int==1 | scr_int==2 | scr_int==3 | scr_int==4 | scr_int==5

g correct_scr2 = 1 if q168==6
replace correct_scr2 = 0 if q168==1 | q168==2 | q168==3 | q168==4 | q168==5

g screen=1 if correct_scr1==1 | correct_scr2==1
replace screen=0 if correct_scr1==0 | correct_scr2==0
replace screen=. if correct_scr1==. & correct_scr2==.

** political information
gen constitutional = info1 == 3
replace constitutional =. if info1 == .
gen nominate = info2 == 1
replace nominate =. if info2 == . 
gen geithner = info3 == 2
replace geithner =. if info3 == . 
gen reid = info4 == 3
replace reid =. if info4 == . 
gen boehner = info5 == 1
replace boehner =. if info5 == . 

egen poliinfo = rmean(constitutional nominate geithner reid boehner)

xi: reg screen i.educ_recode poliinfo age age2 female black hispanic other, r
xi: reg screen i.educ_recode age age2 female black hispanic other, r




****TABLE A3: TVERSKY AND KAHNEMAN (1981) PROXIMITY
**STUDY 2; WAVE 2

clear
set mem 100m
use "merged.dta"


g die_frame2=1 if kt_treatment2=="KT_die"
replace die_frame2 = 0 if kt_treatment2=="KT_saved"

*passed screener 1 on wave 2
tab kt_program2 die_frame2 if correct_scr_12==1 & trained2==0, col

*passed screener 3 on wave 2 (directly before)
tab kt_program2 die_frame2 if correct_scr_32==1 & trained2==0, col



****TABLE A4: ANES PROXIMITY
**STUDY 2; WAVE 1

clear
set mem 100m
use "Screener_SSI__Wave_1.dta"

*passed screener 1 on wave 1
corr govt_std govt_spend govt_inc if correct_scr_1==1 & trained==0

*passed screener 2 on wave 1 (directly before)
corr govt_std govt_spend govt_inc  if correct_scr_2==1 & trained==0





*******TABLE A5: TVERSKY AND KAHNEMAN (1981) PROXIMITY ACROSS WAVES
clear
set mem 100m
use "merged.dta"

g die_frame2=1 if kt_treatment2=="KT_die"
replace die_frame2 = 0 if kt_treatment2=="KT_saved"

*passed screener 3 on wave 1
tab kt_program2 die_frame2 if correct_scr_31==1 & trained1==0 & trained2==0, col

*passed screener 3 on wave 2
tab kt_program2 die_frame2 if correct_scr_32==1 & trained1==0 & trained2==0, col





*******TABLE A6: ANES PROXIMITY ACROSS WAVES
clear
set mem 100m
use "merged.dta"

*passed screener 2 in Wave 1
corr govt_std2 govt_spend2 govt_inc2 if trained2==0 & trained1==0 & correct_scr_21==1

*passed screener 2 in Wave 2
corr govt_std2 govt_spend2 govt_inc2 if trained2==0 & trained1==0 & correct_scr_22==1
