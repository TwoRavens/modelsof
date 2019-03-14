/* Sarah F. Anzia
December 29, 2017
This code reproduces the numerical results in 
"When Does a Group of Citizens Influence Policy?
Evidence from Senior Citizen Participation in City Politics" 

There are two data files used here:
The main file is a city-level dataset (433 obs).
The second file is an age-level dataset.

*/


* Table 1: Registration and Voting in City Elections, by Age Group

* Load city level dataset

/* Row 1: % of Population Registered
(Note that 3-4 very small cities have fractions slightly >1 here
because the numerator and denominator for this row 
come from different sources: PDI and the Census.) */ 
tabstat reg_pcpop_10G_young reg_pcpop_10G_old, stat(mean)
ttest reg_pcpop_10G_young = reg_pcpop_10G_old

/* Row 2: % of Registered Voting in City Election
(In everything that follows, both the numerator and
denominator are from PDI.) */
tabstat vote_pcreg_young vote_pcreg_old, stat(mean)
ttest vote_pcreg_young=vote_pcreg_old

*Row 3: Concurrent with presidential elections
tabstat vote_pcreg_young vote_pcreg_old if presgen==1, stat(mean count)
ttest vote_pcreg_young=vote_pcreg_old if presgen==1

*Row 4: Concurrent with midterm elections
tabstat vote_pcreg_young vote_pcreg_old if gubgen==1, stat(mean count)
ttest vote_pcreg_young=vote_pcreg_old if gubgen==1

*Row 5: Concurrent with statewide primaries
tabstat vote_pcreg_young vote_pcreg_old if prim==1, stat(mean count)
ttest vote_pcreg_young=vote_pcreg_old if prim==1

*Row 6: Off-cycle
tabstat vote_pcreg_young vote_pcreg_old if off==1, stat(mean count)
ttest vote_pcreg_young=vote_pcreg_old if off==1


* Figure 1: Senior citizens in California municipalities

kdensity pctpop_over65, addplot((kdensity pctreg_over65) (kdensity pctvote_over65)) 
summarize pctvote_over65, detail
summarize pctpop_over65, detail
summarize pctreg_over65, detail
codebook city if pctvote_over65>(1/3)


* Table 2: Seniors in the Electorate and Senior-Friendly Policy

* Column 1: Ordinal logit
xi: ologit drexclusive pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Column 2: Ordinal logit, county FE
xi: ologit drexclusive pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote i.county, cluster(county)

* Column 3: Ordinal logit, consistent election timing
xi: ologit drexclusive pctvote_over65_alloff lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)


* Table 3: Turnout, Non-Voting Participation, and Group Cohesivness

* Column 1: all cases
xi: ologit drexclusive pctvote_over65 commission seniorcenter lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Column 2: consistent election timing
xi: ologit drexclusive pctvote_over65_alloff commission seniorcenter lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Column 3: county FE
xi: ologit drexclusive pctvote_over65_alloff commission seniorcenter lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote i.county, cluster(county)

* Column 4: PSA variables, share city senior 1980, number of commissions
xi: ologit drexclusive pctvote_over65_alloff commission seniorcenter lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive sharepop_60plus sharepop_75plus sharelow_60plus sharemin_60plus ///
pop_65andover_pc1980 ln_number_commissions, cluster(county)

* Column 5: senior center age
xi: ologit drexclusive pctvote_over65_alloff commission lnagesenior lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive sharepop_60plus sharepop_75plus sharelow_60plus sharemin_60plus ///
pop_65andover_pc1980 ln_number_commissions, cluster(county)

* Column 6: senior club in 1960s
xi: ologit drexclusive pctvote_over65_alloff commission hasseniorclub lnpop2010 lnincomepc2013 ///
lnpopdens2010 dem2ptyvote ln_number_commissions i.county, cluster(county)

* Column 7: interaction of turnout and senior center
xi: ologit drexclusive i.seniorcenter*pctvote_over65_alloff commission lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive sharepop_60plus sharepop_75plus sharelow_60plus sharemin_60plus ///
pop_65andover_pc1980 ln_number_commissions, cluster(county)
lincom pctvote_over65_alloff + _IsenXpctvo_1


* Table 4: Predicted Probability of Exclusive DR Service

* Row 1
estsimp ologit drexclusive pctvote_over65 seniorcenter commission lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive

codebook pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote

* Without senior center, without senior commission
set seed 201
setx pctvote_over65 .273539 seniorcenter 0 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

* With senior center, without senior commission
set seed 202
setx pctvote_over65 .273539 seniorcenter 1 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

* Without senior center, with senior commission
set seed 203
setx pctvote_over65 .273539 seniorcenter 0 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

* With senior center, with senior commission
set seed 204
setx pctvote_over65 .273539 seniorcenter 1 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

* Row 2
drop b1-b10
estsimp ologit drexclusive seniorcenter commission  ///
 pctvote_over65_alloff seniorcenter_pctvote_over65 ///
lnpop2010 lnpopdens2010 lnincomepc2013 dem2ptyvote pop_65andover_pc1980 ///
ln_number_commissions countydrexclusive sharepop_60plus ///
sharepop_75plus sharelow_60plus sharemin_60plus

summarize pctvote_over65_alloff, detail
summarize pctvote_over65, detail
summarize pop_65andover_pc1980, detail
summarize ln_number_commissions, detail
summarize sharepop_60plus if pop_65andover_pc1980~=. & ln_number_commissions~=. ///
& pctvote_over65_alloff~=., detail
summarize sharepop_75plus if pop_65andover_pc1980~=. & ln_number_commissions~=. ///
& pctvote_over65_alloff~=., detail
summarize sharelow_60plus if pop_65andover_pc1980~=. & ln_number_commissions~=. ///
& pctvote_over65_alloff~=., detail
summarize sharemin_60plus if pop_65andover_pc1980~=. & ln_number_commissions~=. ///
& pctvote_over65_alloff~=., detail

* No senior center, average senior turnout, no commission
set seed 201
setx pctvote_over65_alloff .273539 seniorcenter 0 seniorcenter_pctvote_over65 0 ///
commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 pop_65andover_pc1980 0.113184 ///
ln_number_commissions 1.85073 countydrexclusive 0 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

* No senior center, average senior turnout, with commission
set seed 202
setx pctvote_over65_alloff .273539 seniorcenter 0 seniorcenter_pctvote_over65 0 ///
commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 pop_65andover_pc1980 0.113184 ///
ln_number_commissions 1.85073 countydrexclusive 0 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

* Senior center, low senior turnout, no commission
set seed 203
setx pctvote_over65_alloff 0.15 seniorcenter 1 seniorcenter_pctvote_over65 0.15 ///
commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 pop_65andover_pc1980 0.113184 ///
ln_number_commissions 1.85073 countydrexclusive 0 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

* Senior center, low senior turnout, with commission
set seed 204
setx pctvote_over65_alloff 0.15 seniorcenter 1 seniorcenter_pctvote_over65 0.15 ///
commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 pop_65andover_pc1980 0.113184 ///
ln_number_commissions 1.85073 countydrexclusive 0 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

* Senior center, high senior turnout, no commission
set seed 203
setx pctvote_over65_alloff .44 seniorcenter 1 seniorcenter_pctvote_over65 .44 ///
commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 pop_65andover_pc1980 0.113184 ///
ln_number_commissions 1.85073 countydrexclusive 0 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

* Senior center, high senior turnout, with commission
set seed 203
setx pctvote_over65_alloff .44 seniorcenter 1 seniorcenter_pctvote_over65 .44 ///
commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 pop_65andover_pc1980 0.113184 ///
ln_number_commissions 1.85073 countydrexclusive 0 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi


/* APPENDIX TABLES 

Figure A1: Turnout in City Elections by Age

Load age-level dataset. */

twoway (line turnout_pcreg age, sort)

* Figure A2: Turnout in City Elections, by Age and Timing

twoway (line turnout_pcreg_presgen_3yr age, sort) (line turnout_pcreg_gubgen_3yr age, sort) ///
(line turnout_pcreg_prim_3yr age, sort) (line turnout_pcreg_off_3yr age, sort) 

* Figure A3: Turnout in City Elections, With Presidential Election Comparisons

twoway (line turnout_pcreg_off_3yr age, sort) (line turnout_pcreg_off_prescomp_3yr age, sort) ///
(line turnout_pcreg_prim_3yr age, sort) (line turnout_pcreg_prim_prescomp_3yr age, sort)

* Table A1: Explaining the Age Turnout Gap in City Elections

* Load city-level dataset

* Column 1
reg agegap gubgen prim off, robust

* Column 2
reg agegap gubgen prim off mayor lnpop2010 lnpopdens2010 ///
lnincomepc2013 dem2ptyvote, robust

* Table A2: Within-city difference in Percent Senior, cities with on-cycle elections

tabstat presdiff midtermdiff maxdiff if timingtype=="on-cycle", ///
stat(min p5 p25 median p75 p95 max mean sd count)

* Table A3: Within-city difference in Percent Senior, cities with elections w/ primaries

sort city
list city vote_65overpc_08P vote_65overpc_12P primarydiff if timingtype=="primary"

/* Table A4: Within-city difference in Percent Senior, cities that switched
election schedules. (Note that the most recent on-cycle election for each city is 
November 2012 except for Seal Beach, which is November 2010.) */

list city vote_65overpc_12G vote_65overpc_10G pctvote_over65_alloff ///
if timingtype=="on-cycle with history" & pctvote_over65_alloff~=.

* Figure A4: Percent senior and DR service (box plot)

graph box pctvote_over65, over(drexclusive)

* Table A5: Alternate dependent and independent variables

* Column 1: logit, DV=1 if city has any DR from city or transit authority

xi: logit citytransdr_dum pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydr_dum, cluster(county)

* Column 2: logit, DV=1 only if city provides DR service

xi: logit citydr_dum pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydr_dum authoritydr_dum, cluster(county)

* Column 3: ordinal logit, coded as DR even if provided by county

xi: ologit includecountyDR pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote, cluster(county)

* Column 4: ordinal logit, with senior turnout rate

xi: ologit drexclusive turnout_over65pop lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Column 5: ordinal logit, with senior turnout rate and senior share of population

xi: ologit drexclusive turnout_over65pop pctpop_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Table A6: OLS

* Column 1
xi: reg drexclusive pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Column 2
xi: reg drexclusive pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote i.county, cluster(county)

* Column 3
xi: reg drexclusive pctvote_over65_alloff lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Table A7: Multinomial logit

* Column 1
xi: mlogit drexclusive pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

** Column 2
xi: mlogit drexclusive pctvote_over65 lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote i.county, cluster(county)

* Column 3
xi: mlogit drexclusive pctvote_over65_alloff lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Table A8: Transportation spending

* Column 1: OLS, Pub. Transp. Operating Expenditures

xi: reg lnopexp_publictransit_percap pctvote_over65_alloff lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote i.county, cluster(county)

* Column 2: Tobit

xi: tobit lnopexp_publictransit_percap pctvote_over65_alloff lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote i.county, cluster(county) ll

* Column 3: OLS, Total transportation operating expenditures

xi: reg lnopexp_totaltransit_percap pctvote_over65_alloff lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote i.county, cluster(county)

/* Table A9: Analysis of 2006 Social Capital Community Survey data

[The data are available at 
https://ropercenter.cornell.edu/2006-social-capital-community-benchmark-survey/
as indicated in the online appendix. The following shows the code
needed to reproduce the numbers from Table A9 of the appendix.] */

ttest voteus if age>=65, by(grpeld)
ttest petition if age>=65, by(grpeld)
ttest rally if age>=65, by(grpeld)
ttest project if age>=65, by(grpeld)

/* Table A10: cross-tabs

Load city-level data file. */

tab drexclusive seniorcenter, column
tab drexclusive commission, column

* Table A11: See code for Table A3

/* Table A12: Full set of predicted probabilities from Table 3

Note that the code for predicted probabilities for row (1) and row (7) 
is provided above and is not repeated here. */

* Row 2

estsimp ologit drexclusive pctvote_over65_alloff seniorcenter commission lnpop2010 ///
lnpopdens2010 lnincomepc2013 dem2ptyvote countydrexclusive  ///

set seed 201
setx pctvote_over65_alloff .273539 seniorcenter 0 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

set seed 202
setx pctvote_over65_alloff .273539 seniorcenter 1 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

set seed 204
setx pctvote_over65_alloff .273539 seniorcenter 0 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

set seed 205
setx pctvote_over65_alloff .273539 seniorcenter 1 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 
simqi

* Row 3

xi: ologit drexclusive pctvote_over65_alloff commission seniorcenter lnpop2010 ///
lnpopdens2010 lnincomepc2013 dem2ptyvote i.county, cluster(county)
predict e if e(sample)
drop if e==.

drop b1-b10

xi: estsimp ologit drexclusive pctvote_over65_alloff seniorcenter commission lnpop2010 ///
lnpopdens2010 lnincomepc2013 dem2ptyvote countydrexclusive i.county 

set seed 201
setx pctvote_over65_alloff .273539 seniorcenter 0 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0 
simqi

set seed 202
setx pctvote_over65_alloff .273539 seniorcenter 1 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0 
simqi

set seed 204
setx pctvote_over65_alloff .273539 seniorcenter 0 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0 
simqi

set seed 205
setx pctvote_over65_alloff .273539 seniorcenter 1 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0 
simqi

* Row 4

* Re-load city-level dataset

estsimp ologit drexclusive pctvote_over65_alloff seniorcenter commission ///
lnpop2010 lnpopdens2010 lnincomepc2013 dem2ptyvote countydrexclusive ///
pop_65andover_pc1980 ln_number_commissions sharepop_60plus sharepop_75plus ///
sharelow_60plus sharemin_60plus  

set seed 201
setx pctvote_over65_alloff .273539 seniorcenter 0 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

set seed 202
setx pctvote_over65_alloff .273539 seniorcenter 1 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

set seed 204
setx pctvote_over65_alloff .273539 seniorcenter 0 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

set seed 205
setx pctvote_over65_alloff .273539 seniorcenter 1 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

* Row 5

drop b1-b16

estsimp ologit drexclusive pctvote_over65_alloff lnagesenior commission lnpop2010 ///
lnpopdens2010 lnincomepc2013 dem2ptyvote countydrexclusive pop_65andover_pc1980 ///
ln_number_commissions sharepop_60plus sharepop_75plus sharelow_60plus sharemin_60plus 

di ln(2)
di ln(30)

set seed 201
setx pctvote_over65_alloff .273539 lnagesenior 0.69314718 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

set seed 202
setx pctvote_over65_alloff .273539 lnagesenior 3.4011974 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

set seed 204
setx pctvote_over65_alloff .273539 lnagesenior 0.69314718 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

set seed 205
setx pctvote_over65_alloff .273539 lnagesenior 3.4011974 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 countydrexclusive 0 pop_65andover_pc1980 0.113184 ln_number_commissions 1.85073 ///
sharepop_60plus .140253 sharepop_75plus 0.038716 sharelow_60plus .1433528 sharemin_60plus .1349708
simqi

* Row 6

drop b1-b16

xi: reg drexclusive pctvote_over65_alloff commission hasseniorclub lnpop2010 lnincomepc2013 ///
lnpopdens2010 dem2ptyvote ln_number_commissions i.county, cluster(county)
predict e if e(sample)
drop if e==.

xi: estsimp ologit drexclusive pctvote_over65_alloff hasseniorclub commission ///
lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote ln_number_commissions i.county 

* no senior club, no senior commission
set seed 201
setx pctvote_over65_alloff .273539 hasseniorclub 0 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 ln_number_commissions 1.85073 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0
simqi

* has senior club, no senior commission
set seed 202
setx pctvote_over65_alloff .273539 hasseniorclub 1 commission 0 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 ln_number_commissions 1.85073 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0
simqi

* no senior club, has senior commission
set seed 204
setx pctvote_over65_alloff .273539 hasseniorclub 0 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 ln_number_commissions 1.85073 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0
simqi

* has senior club, has senior commission
set seed 205
setx pctvote_over65_alloff .273539 hasseniorclub 1 commission 1 lnpop2010 9.933 lnpopdens2010 7.11233 ///
lnincomepc2013 10.2351 dem2ptyvote .596684 ln_number_commissions 1.85073 ///
_Icounty_2-_Icounty_8 0 _Icounty_9 1 _Icounty_10-_Icounty_52 0
simqi

/* The R code for Table A13 is in a separate file. 

The matching only uses a few variables, so open the city-level dataset in Stata,
run this line

keep city drexclusive seniorcenter commission countydrexclusive pctvote_over65 lnpop2010 ///
lnpopdens2010 lnincomepc2013 dem2ptyvote

Then save the smaller new file and load it into R to run the matching code.

*/

* Table A14: OLS and Multinomial logit

* Reload city-level data

xi: reg drexclusive pctvote_over65 seniorcenter commission lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

xi: mlogit drexclusive pctvote_over65 seniorcenter commission lnpop2010 lnpopdens2010 lnincomepc2013 ///
dem2ptyvote countydrexclusive, cluster(county)

* Figure A5: Senior center establishment dates

hist centerestab, bin(40) frequency

* Figure A6: Number of citizen commissions, boards, and committees in each city

hist number_commissions, bin(40) frequency
