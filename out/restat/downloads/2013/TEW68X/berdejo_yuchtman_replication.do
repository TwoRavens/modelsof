****Berdejo and Yuchtman Replication .do file****

*Start by calling up the dataset used in the main analysis: "berdejo_yuchtman_replication_baseline_data.dta"

****************************
*Table 1: Summary statistics
****************************

*(see online appendix Table A3 for a list of the variables used in the analysis)*

sum defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj crimeclass4d capsent3 devup3 lindist lowrange3 highrange3 if lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.


**********************************************************************
*Table 2: Comparison of case characteristics pre- versus post-election
**********************************************************************

***Summary stats for different case subsets:

*Pre-election (trials and pleas)
sum defgender2 blackdef2 hispdef2 agedef1 priorconv priorconv3 pleaadj lindist lowrange3 highrange3 if (quartertoelect==1 | quartertoelect==2) & (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.)

*Post-election (trials and pleas)
sum defgender2 blackdef2 hispdef2 agedef1 priorconv priorconv3 pleaadj lindist lowrange3 highrange3 if (quartertoelect==16 | quartertoelect==15) & (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.)

*Pre-election (only pleas)
sum defgender2 blackdef2 hispdef2 agedef1 priorconv priorconv3 pleaadj lindist lowrange3 highrange3 if (quartertoelect==1 | quartertoelect==2) & (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.) & pleaadj==1

*Post-election (only pleas)
sum defgender2 blackdef2 hispdef2 agedef1 priorconv priorconv3 pleaadj lindist lowrange3 highrange3 if (quartertoelect==16 | quartertoelect==15) & (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.) & pleaadj==1

*Pre-election (only trials)
sum defgender2 blackdef2 hispdef2 agedef1 priorconv priorconv3 pleaadj lindist lowrange3 highrange3 if (quartertoelect==1 | quartertoelect==2) & (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.) & pleaadj==0

*Post-election (only trials)
sum defgender2 blackdef2 hispdef2 agedef1 priorconv priorconv3 pleaadj lindist lowrange3 highrange3 if (quartertoelect==16 | quartertoelect==15) & (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.) & pleaadj==0

***T-tests of differences in mean characteristics pre- versus post-election

*Define pre- versus and post-election indicator variable
gen post_election=.
replace post_election=0 if quartertoelect==1 | quartertoelect==2
replace post_election=1 if quartertoelect==16 | quartertoelect==15

*T-tests for pleas and trials:
ttest defgender2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest blackdef2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest hispdef2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest agedef1 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest priorconv if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest priorconv3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest pleaadj if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest lindist if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest lowrange3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)
ttest highrange3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=.), by(post_election)

*T-tests for pleas only:
ttest defgender2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest blackdef2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest hispdef2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest agedef1 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest priorconv if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest priorconv3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest pleaadj if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest lindist if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest lowrange3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)
ttest highrange3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==1), by(post_election)

*T-tests for trials only:
ttest defgender2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest blackdef2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest hispdef2 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest agedef1 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest priorconv if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest priorconv3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest pleaadj if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest lindist if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest lowrange3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)
ttest highrange3 if (lindist!=. & commissioner==0 & crimeclass6!="" & capsent3!=. & pleaadj==0), by(post_election)



************************************
*Table 3: Cycles in sentence length
************************************

*Column 1: Baseline

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*Column 2: Pre-Blakely

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 i.judgeid if commissioner==0 & postblakely==0, robust cluster(sentdateyearquarter)

*Column 3: Excluding murder cases:

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass4 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*Column 4: Only pleas

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0 & pleaadj==1, robust cluster(sentdateyearquarter)

*Column 5: Exogenous linear distance explanatory variable

xi: reg capsent3 lindist_exog violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*Column 6: No "unusual" cells

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3 postblakely i.judgeid if commissioner==0 & numberincell3>=50, robust cluster(sentdateyearquarter)

*Column 7: High - and low-end of sentencing range linear controls

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict highrange3 lowrange3 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*Column 8: 1985-2006 time period

*Call up the dataset covering 1985-2006: "berdejo_yuchtman_replication_1985-2006_data.dta"

*Regression:
xi: reg capsent3 lindist  defgender2 blackdef2 hispdef2 asiandef2 nativedef2 i.verdict i.countyname i.naturalquarter i.sentdateyear i.crimeclass6 i.fakecell3, robust cluster(sentdateyearquarter)

*Column 9: Log of sentence length outcome variable

*Open the baseline dataset again: "berdejo_yuchtman_replication_baseline_data.dta"

*Generate log of sentence length in months (plus 1) outcome:

gen logcapsent3=log(1+capsent3) if capsent3!=.

xi: reg logcapsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)


********************************************
*Table 4: Evaluating alternative hypotheses
********************************************

*Column 1: Time-varying effect of adjudication type

*We include a "trial" dummy variable:
gen trialadj=.
replace trialadj=1 if pleaadj==0
replace trialadj=0 if pleaadj==1

*Regression:

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.trialadj*lindist i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*Column 2: No adjudication or sentencing guidelines controls

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*Column 3: "Retiring terms" of judges who both face a re-election and retire in the sample

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0 & retiredjudge==1 & compretire==1 & control==1, robust cluster(sentdateyearquarter)

*Column 4: "Non-retiring terms" of judges who both face a re-election and retire in the sample

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0 & retiredjudge==1 & compretire==1 & control==0, robust cluster(sentdateyearquarter)

*Column 5: Less visible crimes

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0 & crimeclass6=="", robust cluster(sentdateyearquarter)

*Column 6: Repetition of baseline results (visible crimes)

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*Column 7: Check of Oregon sentencing cycles

*Open Oregon data: "berdejo_yuchtman_replication_oregon_data.dta"

*Regression:
xi: reg capsent3 lindist agedef defgender2 blackdef2 hispdef2 asiandef2 nativedef2 i.countyname i.naturalquarter i.sentdateyear i.offense if crimeclass6d==1 & sentdateyear>1995 | (sentdateyear==1995 & sentdatemonth>6), robust cluster(sentdateyearquarter)

*Column 8: Washington data using the Oregon specification

*Open the baseline Washington data again: "berdejo_yuchtman_replication_baseline_data.dta"

*Regression:
xi: reg capsent3 lindist agedef defgender2 blackdef2 hispdef2 asiandef2 nativedef2 i.countyname i.naturalquarter i.sentdateyear i.crimeclass6 if commissioner==0, robust cluster(sentdateyearquarter)

***************************
*Table 5: Upward deviations
***************************

*Column 1: Baseline

xi: reg devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0 & highrange4<1200, robust cluster(sentdateyearquarter)

*Column 2: Pre-Blakely

xi: reg devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 i.judgeid if commissioner==0 & postblakely==0 & highrange4<1200, robust cluster(sentdateyearquarter)

*Column 3: Excluding murder cases:

xi: reg devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass4 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0 & highrange4<1200, robust cluster(sentdateyearquarter)

*Column 4: Only pleas

xi: reg devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0 & pleaadj==1 & highrange4<1200, robust cluster(sentdateyearquarter)

*Column 5: Exogenous linear distance explanatory variable

xi: reg devup4 lindist_exog violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0 & highrange4<1200, robust cluster(sentdateyearquarter)

*Column 6: No "unusual" cells

xi: reg devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4 postblakely i.judgeid if commissioner==0 & numberincell4>=50 & highrange4<1200, robust cluster(sentdateyearquarter)

*Column 7: High - and low-end of sentencing range linear controls

xi: reg devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict highrange4 lowrange4 postblakely i.judgeid if commissioner==0 & highrange4<1200, robust cluster(sentdateyearquarter)

*Column 8: 1985-2006 time period

*Call up the dataset covering 1985-2006: "berdejo_yuchtman_replication_1985-2006_data.dta"

* Regression:

xi: reg devup4 lindist  defgender2 blackdef2 hispdef2 asiandef2 nativedef2 i.verdict i.countyname i.naturalquarter i.sentdateyear i.crimeclass6 i.fakecell4 if highrange4<1200, robust cluster(sentdateyearquarter)

*Column 9: Probit model

*Open the baseline dataset again: "berdejo_yuchtman_replication_baseline_data.dta"

*Regression:

xi: probit devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0 & highrange4<1200, robust cluster(sentdateyearquarter)


**********************************
*Table 6: Censored sentence length
**********************************

*Generate censored sentence length
gen capsent3_censored=capsent3
replace capsent3_censored =highrange3 if capsent3>highrange3 & capsent3!=.
replace capsent3_censored =lowrange3 if capsent3<lowrange3 & capsent3!=.

*Column 1: All cases
xi: reg capsent3_censored lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)


*Column 2: Pleas only
xi: reg capsent3_censored lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0 & pleaadj==1, robust cluster(sentdateyearquarter)


**************************************************************************************
*Figure 1 data: Sentence length (relative to high-end of range) by quarter to election
**************************************************************************************

gen sent_minus_high_range = capsent3 - highrange3

bysort quartertoelect: sum sent_minus_high_range if crimeclass6!=. & commissioner==0


*************************************************
*Figure 2 data: Sentencing by quarter to election
*************************************************
char quartertoelect[omit] 16
xi: reg capsent3 i.quartertoelect violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)



****************************************************************************************
*Figure 3 data: Sentencing by quarter to election for judges who do not face competition (note: regression results also presented in the online appendix, Table A7, column 1)
****************************************************************************************

char quartertoelecta[omit] 16

*Regression
xi: reg capsent3 i.quartertoelecta violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)



*******************

*******************

*******************

***ONLINE APPENDIX MATERIAL***

****************************************
*TABLE A1: Summary statistics, all cases
****************************************

sum defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj crimeclass4d capsent3 devup3 lindist lowrange3 highrange3 if lindist!=. & commissioner==0 & capsent3!=.


***********************************************
*TABLE A2: Summary statistics, judge-level data
***********************************************

*First, call up the judge level dataset (note: already purged of commissioners): "berdejo_yuchtman_replication_judge_level_data.dta"

*Now, generate summary statistics:

sum appointmentdate enddate genderjudge blackjudge hispanicjudge asianjudge admissiontobar publicdefender prosecutor judicialexper retiredjudge

*********************************************
*TABLE A3: Data description -- no replication
*********************************************

****************************************
*TABLE A4: Comparison of case characteristics pre- versus post-election, all cases
****************************************

*Open baseline case data again: "berdejo_yuchtman_replication_baseline_data.dta""

*Define pre- versus and post-election indicator variable
gen post_election=.
replace post_election=0 if quartertoelect==1 | quartertoelect==2
replace post_election=1 if quartertoelect==16 | quartertoelect==15

*T-tests for pleas and trials (also shows means):
ttest defgender2 if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest blackdef2 if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest hispdef2 if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest agedef1 if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest priorconv if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest priorconv3 if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest pleaadj if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest crimeclass4d if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest crimeclass6d if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest lindist if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest lowrange3 if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)
ttest highrange3 if (lindist!=. & commissioner==0 & capsent3!=.), by(post_election)


***************************************************************
*TABLE A5: Baseline regression showing coefficients on controls
***************************************************************

*Repetition of baseline specification from above:

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)

*********************************************************
*TABLE A6: Sentencing cycles -- additional specifications
*********************************************************

*Column 1: trials only

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0 & pleaadj==0, robust cluster(sentdateyearquarter)

*Column 2: Dataset used for 1985-2006 analysis, but only examining the 1995-2006 period

*Call up the dataset covering 1985-2006: "berdejo_yuchtman_replication_1985-2006_data.dta"

*Regression:
xi: reg capsent3 lindist  defgender2 blackdef2 hispdef2 asiandef2 nativedef2 i.verdict i.countyname i.naturalquarter i.sentdateyear i.crimeclass6 i.fakecell3 if sentdateyear>1995 | (sentdateyear==1995 & sentdatemonth>6), robust cluster(sentdateyearquarter)

*Column 3: No judge fixed effects (includes controls for judge gender, experience, and race)

*Open the baseline dataset again: "berdejo_yuchtman_replication_baseline_data.dta"

*Regression:

xi: reg capsent3 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely genderjudge timefrombar prosecutor blackjudge hispanicjudge if commissioner==0, robust cluster(sentdateyearquarter)

*Column 4: Top-coding of sentence length = 1,200 months

xi: reg capsent4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)


****************************************
*TABLE A7: Sentencing and upward deviations, by quarter to election, for judges not facing electoral competition
****************************************

char quartertoelecta[omit] 16

*Column 1: Sentence length in months (repetition of regression used to produce Figure 3)

xi: reg capsent3 i.quartertoelecta violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)


*Column 2: Upward deviations

xi: reg devup4 i.quartertoelecta violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0 & highrange4<1200, robust cluster(sentdateyearquarter)


****************************************
*TABLE A8: Summary statistics, cases sentenced by judges who both retire and face competition in our sample; retirement terms and pre-retirement terms
****************************************

*Case/defendant characteristics for "retirement" terms

sum defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj crimeclass4d capsent3 devup3 lindist lowrange3 highrange3 if compretire==1 & control==1 & lindist!=. & commissioner==0 & capsent3!=. & crimeclass6!=""


*Case/defendant characteristics for "non-retirement" terms

sum defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj crimeclass4d capsent3 devup3 lindist lowrange3 highrange3 if compretire==1 & control==0 & lindist!=. & commissioner==0 & capsent3!=. & crimeclass6!=""


****************************************
*TABLE A9: Sentencing cycles, full sample (with interaction between lindist and visible crime dummy)
****************************************

*Variable "crimeclass6d" is a dummy variable indicating that a crime is "visible"

*Column 1: all crimes, interaction between visible dummy and distance to election
xi: reg capsent3 i.crimeclass6d*lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)


****************************************
*TABLE A10: Sentencing by quarter to election, all judges
****************************************

char quartertoelect[omit] 16

*Column 1: All visible crime cases (repetition of regression used to produce Figure 2)

xi: reg capsent3 i.quartertoelect violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 pleaadj i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0, robust cluster(sentdateyearquarter)


****************************************
*TABLE A11: Upward deviations across the political cycle, trials only
****************************************

*Column 1: Trials only
xi: reg devup4 lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell4150 postblakely i.judgeid if commissioner==0 & pleaadj==0 & highrange4<1200, robust cluster(sentdateyearquarter)


****************************************
*TABLE A12: Sentencing cycles with censored sentence lengths, trials only
****************************************

*Generate censored sentence length
gen capsent3_censored=capsent3
replace capsent3_censored =highrange3 if capsent3>highrange3 & capsent3!=.
replace capsent3_censored =lowrange3 if capsent3<lowrange3 & capsent3!=.

*Column 1: Trials only
xi: reg capsent3_censored lindist violcrimerate crimerate unemp defgender2 blackdef2 hispdef2 asiandef2 nativedef2 agedef1 priorconv priorconv3 i.sentdateyear i.naturalquarter i.crimeclass6 i.judicialdistrict i.fakecell3150 postblakely i.judgeid if commissioner==0 & pleaadj==0, robust cluster(sentdateyearquarter)

