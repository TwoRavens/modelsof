
use katrina, clear


*Their data cleaning and preparation


** SAMPLE SELECTION
** ================

** Only keep observations that could hear the audio
** (only those observations were asked the giving questions)
count
keep if soundcheck==3
count

** DROP observations that did NOT report giving
** (there are only 5 such observations)
drop if giving==.
count

** ==================================
** 1. SOME DATA CLEANING AND RECODING
** ==================================

** 1A - Experimental Manipulation Variables
** ========================================
tab surveyvariant, m
gen byte var_racesalient = surveyvariant==2
gen byte var_fullstakes  = surveyvariant==3


** 1B - Outcome Variables
** =======================

** Perceived bw racial Difference:
** = perceived % black - perceived % white
** (i.e. other races are left out of the equation)
gen       per_hfhdif = per_hfhblk-per_hfhwht
label var per_hfhdif "Perceived %Black - %White HfH recipients"

** Topcode hypothetical giving so that it is not driven by a handful of outliers
list giving hypothgiving if hypothgiving>500 & hypothgiving<.
gen    hypgiv_tc500=hypothgiving
recode hypgiv_tc500 500/max=500

** Binary measure for giving all, nothing, 50%
** useful for summary statistics
gen byte giving_100 =giving==100
gen byte giving_50  =giving==50
gen byte giving_0   =giving==0
egen     giving_oth =rsum(giving_*)
replace  giving_oth =1-giving_oth



** 1C - Demographic control variables
** ==================================
** useful for conditioning

** Race/ethnicity of respondent
gen byte white=ppethm==1
gen byte black=ppethm==2
gen byte other=1-black-white
label var white "Non-Hispanic White panelist"
label var black "Non-Hispanic Black panelist"
label var other "Panelist is not Non-Hispanic white or black"

** Age and age squared
gen age    = ppage
gen age2   = ppage^2

** Dual income households
gen byte dualin = ppdualin

** Education dummies
tab ppeducat, sum(ppeducat)
gen byte edudo  = ppeducat==1
gen byte eduhs  = ppeducat==2
gen byte edusc  = ppeducat==3
gen byte educp  = ppeducat==4

** Log Household size
gen lnhhsz = ln(pphhsize)

** For household income take mid-points of categories
gen     lnhhinc = .
replace lnhhinc = ln(2500) if ppincimp==1
replace lnhhinc = ln((  5000  +  7499  )/2) if ppincimp==2
replace lnhhinc = ln((  7500  +  9999  )/2) if ppincimp==3
replace lnhhinc = ln(( 10000  + 12499  )/2) if ppincimp==4
replace lnhhinc = ln(( 12500  + 14999  )/2) if ppincimp==5
replace lnhhinc = ln(( 15000  + 19999  )/2) if ppincimp==6
replace lnhhinc = ln(( 20000  + 24999  )/2) if ppincimp==7
replace lnhhinc = ln(( 25000  + 29999  )/2) if ppincimp==8
replace lnhhinc = ln(( 30000  + 34999  )/2) if ppincimp==9
replace lnhhinc = ln(( 35000  + 39999  )/2) if ppincimp==10
replace lnhhinc = ln(( 40000  + 49999  )/2) if ppincimp==11
replace lnhhinc = ln(( 50000  + 59999  )/2) if ppincimp==12
replace lnhhinc = ln(( 60000  + 74999  )/2) if ppincimp==13
replace lnhhinc = ln(( 75000  + 84999  )/2) if ppincimp==14
replace lnhhinc = ln(( 85000  + 99999  )/2) if ppincimp==15
replace lnhhinc = ln(( 100000 + 124999 )/2) if ppincimp==16
replace lnhhinc = ln(( 125000 + 149999 )/2) if ppincimp==17
replace lnhhinc = ln(( 150000 + 174999 )/2) if ppincimp==18
replace lnhhinc = ln( 350000 )              if ppincimp==19  

** Marital status and gender
tab ppmarit, sum(ppmarit)
gen byte married = ppmarit==1

tab ppgender, sum(ppgender)
gen byte male  = ppgender==1

gen byte singlemale = male & ~married

** Region of residence
tab ppreg4, sum(ppreg4)
gen byte nrtheast = ppreg4==1
gen byte midwest  = ppreg4==2
gen byte south    = ppreg4==3
gen byte west     = ppreg4==4
assert (nrtheast+midwest+south+west)==1

** Labor force status
tab ppwork, sum(ppwork)
gen byte work     = ppwork<=4
gen byte retired  = ppwork==6
gen byte disabled = ppwork==7
gen byte unempl   = ppwork==5
gen byte notwork  = ppwork==8 | ppwork==9
assert retired + disabled + unempl + notwork + work == 1


** Self-reported prior charitable giving
** create a dummy for any prior charitable giving for Katrina
gen     dcharkatrina  = charkatrina>0 & charkatrina~=.
** create log charitable Katrina giving; set to zero if missing
gen     lcharkatrina  = log(charkatrina)
recode  lcharkatrina  .=0

** Do the same for total charitable giving in 2005
gen     dchartot2005  = chartot2005>0 & chartot2005~=.
** create log charitable Katrina giving; set to zero if missing
gen     lchartot2005  = log(chartot2005)
recode  lchartot2005  .=0


** Create lifepriority variables containing the rank of each item (1=least important, 6=most important)
gen byte lifepriorities_help  = 1+5*(lifepriorities1== 2)+4*(lifepriorities2== 2)+3*(lifepriorities3== 2)+2*(lifepriorities4== 2)+1*(lifepriorities5== 2) if lifepriorities5~=.
gen byte lifepriorities_mony  = 1+5*(lifepriorities1== 6)+4*(lifepriorities2== 6)+3*(lifepriorities3== 6)+2*(lifepriorities4== 6)+1*(lifepriorities5== 6) if lifepriorities5~=.
label var  lifepriorities_help    "Important To help others in need (1=least imp., 6=most imp.)"
label var  lifepriorities_mony    "Important To earn a lot of money (1=least imp., 6=most imp.)"


** Subjective identification with ethnic or racial group
** recode such that higher numbers indicate greater identification
tab ppeg0044, sum(ppeg0044)
gen byte ethclose=ppeg0044
recode ethclose -1 5=. 1=4 2=3 3=2 4=1
label var ethclose "Subjective identification with ethnic/racial group (1-4)"

** Now as dummy variable
gen ethclosed=ethclose==3|ethclose==4 if ethclose<.
tab ethclosed

** Social Contact by race
tab soccon_wht, m
tab soccon_blk, m
gen soccon_dif = soccon_blk-soccon_wht
gen soccon_difd = soccon_dif
recode soccon_difd -6/-1=0 0/6=1
tab soccon_difd

** Opportunities for African-Americans
tab oppblk, m
gen oppblkd = oppblk>=4 if oppblk<.   
tab oppblkd, m




** 1.D Put the control variables into globals:
** ===========================================

** MANIPULATION CONTROL VARIABLES
global manip aud_republ aud_econdis aud_govtben aud_prephur aud_church aud_crime aud_helpoth aud_contrib aud_loot cityslidell var_fullstakes var_racesalient

** BASELINE SET OF DEMOGRAPHIC CONTROL VARIABLES
global cntrldems age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired dcharkatrina lcharkatrina dchartot2005 lchartot2005

** controls excluding past charitable giving
global cntrlx    age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired

** POSSIBLE ADDITIONAL CONTROLS (used in table 5, row 5):
global addcntrl1  hfh_effective lifepriorities_help lifepriorities_mony


** 1.E PROGRAMS TO CREATE INTERACTION EFFECTS:
** ===========================================

** 1. Interact: One continous picture interaction; show everything
** Syntax: interact [depvbl] [interaction vlb]
capture program drop interact
program define interact
  capture drop int_*
  qui gen int_picshowb  =  `2' * picshowblack
  qui gen int_picobscur =  `2' * picobscur
  qui gen int_picraceb  =  `2' * picraceb
  reg `1' int_* `2' picshowblack picraceb picobscur $manip $cntrldems if $mycondition $andif, rob
end


** 2. Interactd: For one interaction DUMMY [D], ONLY interact picture manipulations
** Syntax: interactd [depvbl] [interaction Dummy]
capture program drop interactd
  program define interactd
  capture drop int?_*
  assert (`2'==0)|(`2'==1)|(`2'>=.)  /* check that the argument is a dummy */
  qui gen int1_picshowb  =    `2'   * picshowblack /* the effect on the group where dummy==1 */
  qui gen int1_picobscur =    `2'   * picobscur    /* the effect on the group where dummy==1 */
  qui gen int1_picraceb  =    `2'   * picraceb     /* the effect on the group where dummy==1 */
  qui gen int0_picshowb  =  (1-`2') * picshowblack /* the effect on the group where dummy==0 */
  qui gen int0_picobscur =  (1-`2') * picobscur    /* the effect on the group where dummy==0 */
  qui gen int0_picraceb  =  (1-`2') * picraceb     /* the effect on the group where dummy==0 */
  reg `1' int?_* `2' $manip $cntrldems if $mycondition $andif, rob
  test int1_picshowb = int0_picshowb
  qui lincom int1_picshowb - int0_picshowb
  di "Estimate and t-stat on interaction with 'picture shows black victims' " r(estimate) "      (" r(estimate)/r(se) ")"
end




** 2. Interactd: For one interaction DUMMY [D], ONLY interact picture manipulations
** Syntax: interactd [depvbl] [interaction Dummy]
capture program drop interactd
  program define interactd
  capture drop int?_*
  assert (`2'==0)|(`2'==1)|(`2'>=.)  
  qui gen int1_picshowb  =    `2'   * picshowblack 
  qui gen int1_picobscur =    `2'   * picobscur    
  qui gen int1_picraceb  =    `2'   * picraceb     
  qui gen int0_picshowb  =  (1-`2') * picshowblack 
  qui gen int0_picobscur =  (1-`2') * picobscur    
  qui gen int0_picraceb  =  (1-`2') * picraceb     
  reg `1' int?_* `2' $manip $cntrldems if $mycondition $andif, rob
  test int1_picshowb = int0_picshowb
  qui lincom int1_picshowb - int0_picshowb
  di "Estimate and t-stat on interaction with 'picture shows black victims' " r(estimate) "      (" r(estimate)/r(se) ")"
end



** ==================================
** 2.  RESULTS REPORTED IN THE PAPER
** ==================================




** --------------------
** TABLE 2: Mean Giving
** --------------------
** Simple DD table of avg. giving by picture race and race obscured
** Only use main survey variant because only in that survey variant
** all four picture types are balanced (the full-stakes and race-salient
** variants don't contain race obscured pictures).
**
** Note: in the paper the order of the rows is reversed (row with black victims
** is shown first in the table in the paper, but second in the Stata table)
**
** Standard errors are std/sqrt(N)
** Differences and standard errors are calculated in a spreadsheet.
** tab02
tab picraceb picobscur if surveyvariant==1, sum(giving)

*Table 3 - Coefficient error in column 3


** col. 1: Manipulation check
** tab03.c1
reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [pw=tweight], robust


** col. 2: BASELINE REGRESSION
** tab03.c2
reg giving picshowblack picraceb picobscur $manip $cntrldems [pw=tweight], robust


** col. 3.: Interaction with respondent race
** Interactions of picture manipulations with respondent race
gen byte picshowb_resb   = picshowblack * black
gen byte picobscur_resb  = picobscur    * black
gen byte picraceb_resb   = picraceb     * black

** tab03.c3 - COEFFICIENT ERROR
reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if ~other, robust


** col. 4.: Interaction with Subjective identification with blacks
** double check that ethclose is coded correctly
tab ppeg0044 ethclose, m
tab ppeg0044 if white, m
tab ppeg0044 if black, m

** let subj_iden_blk be one for blacks that are close or very close to their ethnic/racial group
** let subj_iden_blk be one for whites that are not close or not close at all to their ethnic/racial group
gen     subj_iden_blk=ethclose==3|ethclose==4 if ethclose<. & black
replace subj_iden_blk=ethclose==1|ethclose==2 if ethclose<. & white
gen picshowb_sib  = picshowblack * subj_iden_blk
gen picraceb_sib  = picraceb     * subj_iden_blk
gen picobscur_sib = picobscur    * subj_iden_blk
** tab03.c4
reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [pw=tweight] if ~other, robust

** Test for the significance for the sum of the coefficients
lincom picshowb_sib + picshowblack


** col. 5.: Same as col. 4, but just white respondents
** tab03.c5
reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if white, robust

** Test for the significance for the sum of the coefficients
lincom picshowb_sib + picshowblack


** col. 6.: Same as col. 4, but just black respondents
** tab03.c6
reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if black, robust

** Test for the significance for the sum of the coefficients
lincom picshowb_sib + picshowblack



*Table 4 - Rounding error in panel 3.

** -----------------------------------------------------------------------
** TABLE 4: Results by Race of the Respondent and by Measure of Generosity
** -----------------------------------------------------------------------
**
** Nr of manipulations indicating that the victims are "worthy" or deserving:
** + helping others
** + willing to work hard
** + prepared for hurricane
** - crime & drug abuse
**
** Not included:
** looting           (because (i) we were not trying to suggest the victims were looters
**                    and (ii) looting suggest that the government was not effective at restoring
**                    order after Katrina, so it affects the gov_effective variable directly)
** church            (not clear whether this is positive)
** govt benefits     (because this is confounded with need)
** republican        (not an indicator of "worthiness," at least not a generally accepted one)
** econ disadvantage (because this is mostly a measure of need, and is reported separately)
**

** variable counting the number of worthiness manipulations
gen nraudworthy =    aud_helpoth - aud_crime + aud_contrib + aud_prephur
global nraud aud_econdis nraudworthy aud_republ aud_govtben aud_church aud_loot cityslidell var_fullstakes var_racesalient


** Panel 1, baseline
** tab04.r1a
reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight], robust

** tab04.r1b
reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if white, robust

** tab04.r1c
reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if black, robust


** Panel 2, hypothetical giving (is top coded at $500, to prevent a few outliers from driving it)
sum hypothgiving, d
** these are the topcoded observations
list giving hypothgiving if hypothgiving>500 & hypothgiving<.
sum hypgiv_tc500, d
** tab04.r2a
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight], robust

** tab04.r2b
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if white, robust

** tab04.r2c
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if black, robust


*Rounding error
** Panel 3, should charities spend more to help to Katrina victims
tab subjsupchar, m
** tab04.r3a
reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight], robust

** tab04.r3b
reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if white, robust

** tab04.r3c
reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if black, robust


** Panel 4, should govt spend more to help to Katrina victims
tab subjsupgov, m
** tab04.r4a
reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight], robust

** tab04.r4b
reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if white, robust

** tab04.r4c
reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if black, robust




*Table 5 - R2 rounding error

** ------------------------------
** Table 5: Robustness Checks
** ------------------------------
**
** Each panel had a different dependent variable (giving, hypoth. giving,
** subj. support for charity spending, subj. support for government spending).
**
** Under each outcome we have 8 rows of specification checks
**
** So 4 x 8 = 32 rows in total.
**
** Each specification in a row
** Row 1:  baseline (from table 3)
** Row 2: just main sample (surveyvariant==1)
** Row 3: just Slidell
** Row 4: just Biloxi
** Row 5: no demographic controls
** Row 6: addition of possibly endogenous controls (effictiveness of HfH, lifepriority helping, lifepriority money)
** Row 7: censored regression / ordered probit
** Row 8: Just using the race-shown sample
**
** NOTE, These regressions are just for WHITE respondents.
** The same 32 regressions are also run for ALL and BLACK respondents in the "Extra section (below)"
**
** Note for row 2 (just main sample):
** When sample is limited to surveyvariant==1, we need to use mweights)
**
** NOTE: cnreg only allows aweights, so use aweights in that case

** Create the variable that indicates which observations are censored
gen cens_giving=(giving==100)-(giving==0)
tab cens_giving

gen cens_hypgiv_tc500=(hypgiv_tc500==500)-(hypgiv_tc500==0)
tab cens_hypgiv_tc500



** ---------- ROW 1 - Giving --------------
** tab05.r1.s1 (baseline)
reg   giving picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white                  , robust

** tab05.r1.s2 (only main sample)
reg   giving picshowblack picraceb picobscur $nraud $cntrldems            [pw=mweight] if white & surveyvariant==1       , robust

** tab05.r1.s3 (Slidell only)
reg   giving picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & cityslidell     , robust

** tab05.r1.s4 (Biloxi only)
reg   giving picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~cityslidell    , robust

** tab05.r1.s5 (No Demographic controls)
reg   giving picshowblack picraceb picobscur $nraud black other           [pw=tweight] if white                , robust

** tab05.r1.s6 (Extra controls)
reg   giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if white                , robust

** tab05.r1.s7 (Censored regression)
cnreg giving picshowblack picraceb picobscur $nraud $cntrldems            [aw=tweight] if white                , cens(cens_giving)

** tab05.r1.s8 (just race-shown treatment)
reg   giving picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~picobscur         , robust



*R2 rounding error

** ---------- ROW 2 - Hypothetical Giving --------------
** tab05.r2.s1 (baseline)
reg   hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white                , robust

** tab05.r2.s2 (only main sample)
reg   hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems            [pw=mweight] if white & surveyvariant==1       , robust

** tab05.r2.s3 (Slidell only)
reg   hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & cityslidell     , robust

** tab05.r2.s4 (Biloxi only)
reg   hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~cityslidell    , robust

** tab05.r2.s5 (No Demographic controls)
reg   hypgiv_tc500 picshowblack picraceb picobscur $nraud black other           [pw=tweight] if white                , robust

** tab05.r2.s6 (Extra controls)
reg   hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if white                , robust

** tab05.r2.s7 (Censored regression)
cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems            [aw=tweight] if white                , cens(cens_hypgiv_tc500)

** tab05.r2.s8 (just race-shown treatment)
reg   hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~picobscur         , robust





** ---------- ROW 3 - Subjective support for charity spending --------------
** tab05.r3.s1 (baseline)
reg   subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white                , robust

** tab05.r3.s2 (only main sample)
reg   subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems            [pw=mweight] if white & surveyvariant==1       , robust

** tab05.r3.s3 (Slidell only)
reg   subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & cityslidell     , robust

** tab05.r3.s4 (Biloxi only)
reg   subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~cityslidell    , robust

** tab05.r3.s5 (No Demographic controls)
reg   subjsupchar  picshowblack picraceb picobscur $nraud black other           [pw=tweight] if white                , robust

** tab05.r3.s6 (Extra controls)
reg   subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if white                , robust

** tab05.r3.s7 (Ordered probit)
oprob subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white                , robust

** tab05.r3.s8 (just race-shown treatment)
reg   subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~picobscur         , robust




** ---------- ROW 4 - Subjective support for government spending --------------
** tab05.r4.s1 (baseline)
reg   subjsupgov  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white                , robust

** tab05.r4.s2 (only main sample)
reg   subjsupgov  picshowblack picraceb picobscur $nraud $cntrldems            [pw=mweight] if white & surveyvariant==1       , robust

** tab05.r4.s3 (Slidell only)
reg   subjsupgov  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & cityslidell     , robust

** tab05.r4.s4 (Biloxi only)
reg   subjsupgov  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~cityslidell    , robust

** tab05.r4.s5 (No Demographic controls)
reg   subjsupgov  picshowblack picraceb picobscur $nraud black other           [pw=tweight] if white                , robust

** tab05.r4.s6 (Extra controls)
reg   subjsupgov  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if white                , robust

** tab05.r4.s7 (Ordered probit)
oprob subjsupgov  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white                , robust

** tab05.r4.s8 (just race-shown treatment)
reg   subjsupgov  picshowblack picraceb picobscur $nraud $cntrldems            [pw=tweight] if white & ~picobscur         , robust




** TABLE 6: Effects of Interactions between Race Manipulation and Subjective Racial Attitudes on Racial Bias
** ---------------------------------------------------------------------------------------------------------
**


** Panel A -- White respondents
** Note: the program "interactd" conditions the regressions on whatever condition is
** contained in "mycondition"
global mycondition="white"

** 6.1  Close to ethnic or racial group
tab ppeg0044  if $mycondition, m
tab ethclosed if $mycondition

** tab06.r1.c1
interactd giving       ethclosed

** tab06.r1.c2
interactd hypgiv_tc500 ethclosed

** tab06.r1.c3
interactd subjsupchar  ethclosed

** tab06.r1.c4
interactd subjsupgov   ethclosed

** tab06.r1.cA (Extra, NOT in paper, interaction with perceptions)
** This is an interesting regression; it shows that some of the people
** who are most racially biased (whites close to their group) do not
** report perceiving more blacks if we show them pictures of blacks
** though they do significantly reduce their giving in that case
** This casts some doubt on whether people honestly report their
** race perceptions (alternatively, these biases and perceptions
** operate subconsciously)
interactd per_hfhdif   ethclosed


** 6.2: Frequent contact with blacks
tab soccon_dif  if $mycondition, m
tab soccon_difd if $mycondition

** tab06.r2.c1
interactd giving        soccon_difd

** tab06.r2.c2
interactd hypgiv_tc500  soccon_difd

** tab06.r2.c3
interactd subjsupchar   soccon_difd

** tab06.r2.c4
interactd subjsupgov    soccon_difd





** 6.3  Belief that Blacks have more econ. opportunities (than other Americans)
tab oppblk if $mycondition, m
tab oppblkd if $mycondition

** tab06.r3.c1
interactd giving        oppblkd

** tab06.r3.c2
interactd hypgiv_tc500  oppblkd

** tab06.r3.c3
interactd subjsupchar   oppblkd

** tab06.r3.c4
interactd subjsupgov    oppblkd




** Panel B -- Black respondents
global mycondition="black"

** 6.4  Close to ethnic or racial group
tab ppeg0044  if $mycondition, m
tab ethclosed if $mycondition

** tab06.r4.c1
interactd giving        ethclosed

** tab06.r4.c2
interactd hypgiv_tc500  ethclosed

** tab06.r4.c3
interactd subjsupchar   ethclosed

** tab06.r4.c4
interactd subjsupgov    ethclosed



** 6.4: Frequent contact with blacks
tab soccon_dif  if $mycondition, m
tab soccon_difd if $mycondition

** tab06.r5.c1
interactd giving        soccon_difd

** tab06.r5.c2
interactd hypgiv_tc500  soccon_difd

** tab06.r5.c3
interactd subjsupchar   soccon_difd

** tab06.r5.c4
interactd subjsupgov    soccon_difd





** 6.6  Belief that Blacks have more econ. opportunities (than other Americans)
tab oppblk  if $mycondition, m
tab oppblkd if $mycondition

** tab06.r6.c1
interactd giving        oppblkd

** tab06.r6.c2
interactd hypgiv_tc500  oppblkd

** tab06.r6.c3
interactd subjsupchar   oppblkd

** tab06.r6.c4
interactd subjsupgov    oppblkd



*****************************************


*Now my code, need to keep all observations and introduce conditionals for regressions

use katrina, clear

generate S = 1 if soundcheck == 3
replace S = . if giving == .

*Add in dropped treatments (participants didn't complete)
append using katrinamissing

*Their code
tab surveyvariant, m
gen byte var_racesalient = surveyvariant==2
gen byte var_fullstakes  = surveyvariant==3
gen       per_hfhdif = per_hfhblk-per_hfhwht
gen    hypgiv_tc500=hypothgiving
recode hypgiv_tc500 500/max=500
gen byte giving_100 =giving==100
gen byte giving_50  =giving==50
gen byte giving_0   =giving==0
egen     giving_oth =rsum(giving_*)
replace  giving_oth =1-giving_oth
gen byte white=ppethm==1
gen byte black=ppethm==2
gen byte other=1-black-white
gen age    = ppage
gen age2   = ppage^2
gen byte dualin = ppdualin
tab ppeducat, sum(ppeducat)
gen byte edudo  = ppeducat==1
gen byte eduhs  = ppeducat==2
gen byte edusc  = ppeducat==3
gen byte educp  = ppeducat==4
gen lnhhsz = ln(pphhsize)
gen     lnhhinc = .
replace lnhhinc = ln(2500) if ppincimp==1
replace lnhhinc = ln((  5000  +  7499  )/2) if ppincimp==2
replace lnhhinc = ln((  7500  +  9999  )/2) if ppincimp==3
replace lnhhinc = ln(( 10000  + 12499  )/2) if ppincimp==4
replace lnhhinc = ln(( 12500  + 14999  )/2) if ppincimp==5
replace lnhhinc = ln(( 15000  + 19999  )/2) if ppincimp==6
replace lnhhinc = ln(( 20000  + 24999  )/2) if ppincimp==7
replace lnhhinc = ln(( 25000  + 29999  )/2) if ppincimp==8
replace lnhhinc = ln(( 30000  + 34999  )/2) if ppincimp==9
replace lnhhinc = ln(( 35000  + 39999  )/2) if ppincimp==10
replace lnhhinc = ln(( 40000  + 49999  )/2) if ppincimp==11
replace lnhhinc = ln(( 50000  + 59999  )/2) if ppincimp==12
replace lnhhinc = ln(( 60000  + 74999  )/2) if ppincimp==13
replace lnhhinc = ln(( 75000  + 84999  )/2) if ppincimp==14
replace lnhhinc = ln(( 85000  + 99999  )/2) if ppincimp==15
replace lnhhinc = ln(( 100000 + 124999 )/2) if ppincimp==16
replace lnhhinc = ln(( 125000 + 149999 )/2) if ppincimp==17
replace lnhhinc = ln(( 150000 + 174999 )/2) if ppincimp==18
replace lnhhinc = ln( 350000 )              if ppincimp==19  
tab ppmarit, sum(ppmarit)
gen byte married = ppmarit==1
tab ppgender, sum(ppgender)
gen byte male  = ppgender==1
gen byte singlemale = male & ~married
tab ppreg4, sum(ppreg4)
gen byte nrtheast = ppreg4==1
gen byte midwest  = ppreg4==2
gen byte south    = ppreg4==3
gen byte west     = ppreg4==4
tab ppwork, sum(ppwork)
gen byte work     = ppwork<=4
gen byte retired  = ppwork==6
gen byte disabled = ppwork==7
gen byte unempl   = ppwork==5
gen byte notwork  = ppwork==8 | ppwork==9
gen     dcharkatrina  = charkatrina>0 & charkatrina~=.
gen     lcharkatrina  = log(charkatrina)
recode  lcharkatrina  .=0
gen     dchartot2005  = chartot2005>0 & chartot2005~=.
gen     lchartot2005  = log(chartot2005)
recode  lchartot2005  .=0
gen byte lifepriorities_help  = 1+5*(lifepriorities1== 2)+4*(lifepriorities2== 2)+3*(lifepriorities3== 2)+2*(lifepriorities4== 2)+1*(lifepriorities5== 2) if lifepriorities5~=.
gen byte lifepriorities_mony  = 1+5*(lifepriorities1== 6)+4*(lifepriorities2== 6)+3*(lifepriorities3== 6)+2*(lifepriorities4== 6)+1*(lifepriorities5== 6) if lifepriorities5~=.
tab ppeg0044, sum(ppeg0044)
gen byte ethclose=ppeg0044
recode ethclose -1 5=. 1=4 2=3 3=2 4=1
gen ethclosed=ethclose==3|ethclose==4 if ethclose<.
gen soccon_dif = soccon_blk-soccon_wht
gen soccon_difd = soccon_dif
recode soccon_difd -6/-1=0 0/6=1

gen oppblkd = oppblk>=4 if oppblk<.   
gen byte picshowb_resb   = picshowblack * black
gen byte picobscur_resb  = picobscur    * black
gen byte picraceb_resb   = picraceb     * black
gen     subj_iden_blk=ethclose==3|ethclose==4 if ethclose<. & black
replace subj_iden_blk=ethclose==1|ethclose==2 if ethclose<. & white
gen picshowb_sib  = picshowblack * subj_iden_blk
gen picraceb_sib  = picraceb     * subj_iden_blk
gen picobscur_sib = picobscur    * subj_iden_blk
gen nraudworthy =    aud_helpoth - aud_crime + aud_contrib + aud_prephur
gen cens_giving=(giving==100)-(giving==0)
gen cens_hypgiv_tc500=(hypgiv_tc500==500)-(hypgiv_tc500==0)

global manip aud_republ aud_econdis aud_govtben aud_prephur aud_church aud_crime aud_helpoth aud_contrib aud_loot cityslidell var_fullstakes var_racesalient
global cntrldems age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired dcharkatrina lcharkatrina dchartot2005 lchartot2005
global cntrlx    age age2 black other edudo edusc educp lnhhinc dualin married male singlemale south work disabled retired
global addcntrl1  hfh_effective lifepriorities_help lifepriorities_mony
global nraud nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot cityslidell var_fullstakes var_racesalient

*I add, to drop treatment variables which are dropped certain regressions so that my extracted treatment covariance matrices don't have blanks
global manipb aud_republ aud_econdis aud_govtben aud_prephur aud_church aud_crime aud_helpoth aud_contrib aud_loot cityslidell 
global nraudb nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot cityslidell 
global nraud1 nraudworthy aud_republ aud_econdis aud_govtben aud_church aud_loot var_fullstakes var_racesalient

*Table 3 - Coefficient error in column 3

reg per_hfhdif picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
reg giving picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1, robust
reg giving picshowb_resb picraceb_resb picobscur_resb picshowblack picraceb picobscur $manip $cntrldems [pw=tweight] if S == 1 & ~other, robust
reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems [pw=tweight] if S == 1 & ~other, robust
reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manip subj_iden_blk $cntrldems if S == 1 &  white, robust
reg giving picshowb_sib picraceb_sib picobscur_sib picshowblack picraceb picobscur $manipb subj_iden_blk $cntrldems if S == 1 & black, robust

*Table 4 - Rounding error in panel 3.

reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
reg subjsupchar picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg subjsupchar picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust
reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1, robust
reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=tweight] if S == 1 & black, robust

*Table 5 - R2 rounding error in panel B.

reg giving picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg giving picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
reg giving picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
reg giving picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
reg giving picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
cnreg giving picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_giving)
reg giving picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
reg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
cnreg hypgiv_tc500 picshowblack picraceb picobscur $nraud $cntrldems [aw=tweight] if S == 1 & white, cens(cens_hypgiv_tc500)
reg hypgiv_tc500 picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg subjsupchar  picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
reg subjsupchar picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
reg subjsupchar  picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
reg subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
oprob subjsupchar  picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg subjsupchar picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust
reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg subjsupgov picshowblack picraceb picobscur $nraudb $cntrldems [pw=mweight] if S == 1 & white & surveyvariant==1, robust
reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & cityslidell, robust
reg subjsupgov picshowblack picraceb picobscur $nraud1 $cntrldems [pw=tweight] if S == 1 & white & ~cityslidell, robust
reg subjsupgov picshowblack picraceb picobscur $nraud black other [pw=tweight] if S == 1 & white, robust
reg subjsupgov picshowblack picraceb picobscur $nraud $cntrldems $addcntrl1 [pw=tweight] if S == 1 & white, robust
oprob subjsupgov picshowblack picraceb picobscur $nraud $cntrldems [pw=tweight] if S == 1 & white, robust
reg subjsupgov picshowblack $nraud $cntrldems [pw=tweight] if S == 1 & white & ~picobscur, robust


*Version of programme for my use - Note $andif never defined anywhere in their do-file

capture program drop interactdd
  program define interactdd
  capture drop int?_*
  qui gen int1_picshowb  =    `2'   * picshowblack 
  qui gen int1_picraceb  =    `2'   * picraceb     
  qui gen int1_picobscur =    `2'   * picobscur    
  qui gen int0_picshowb  =  (1-`2') * picshowblack 
  qui gen int0_picraceb  =  (1-`2') * picraceb     
  qui gen int0_picobscur =  (1-`2') * picobscur    
  reg `1' int?_* $manip `2' $cntrldems if S ==1 & $mycondition $andif, rob
end


*Table 6 - All okay

global mycondition="white"

interactdd giving ethclosed
interactdd hypgiv_tc500 ethclosed
interactdd subjsupchar ethclosed
interactdd subjsupgov ethclosed
interactdd giving soccon_difd
interactdd hypgiv_tc500 soccon_difd
interactdd subjsupchar soccon_difd
interactdd subjsupgov soccon_difd
interactdd giving oppblkd
interactdd hypgiv_tc500 oppblkd
interactdd subjsupchar oppblkd
interactdd subjsupgov oppblkd

global mycondition="black"

interactdd giving ethclosed
interactdd hypgiv_tc500 ethclosed
interactdd subjsupchar ethclosed
interactdd subjsupgov ethclosed
interactdd giving soccon_difd
interactdd hypgiv_tc500 soccon_difd
interactdd subjsupchar soccon_difd
interactdd subjsupgov soccon_difd
interactdd giving oppblkd
interactdd hypgiv_tc500 oppblkd
interactdd subjsupchar oppblkd
interactdd subjsupgov oppblkd

save DatFL, replace










