
*Code for all analyses
*Short-Term Pain for Long-Term Gain: The Logic of Legislative Party Switching in the Contemporary American South
*Authors: Antoine Yoshinaka and Seth C. McKee
*All analyses conducted with Stata SE 14.2

use Yoshinaka-McKee-PartySwitchingSouth-replication-data.dta

*Table 1, Model 1 (DV: Retirements)
logit retired switcher term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1

*Table 1, Model 2 (DV: win next election)
logit won_next switcher years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1

*Table 1, Model 2 (DV: vote %)
reg genvote_next switcher years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1

*Table 1, Model 2 (DV: vote % at previous election, placebo)
reg genvote_last switcher years_in_office age black_legislator majority redistricting_next double_lag hhincome_000s_last /*
*/ somecollege_last black_last senate ar-va census1990_last if other~=1

*Table 1, Model 3 (DV: higher office)
logit higher_office_sought_next switcher term_limited years_in_office age black_legislator majority redistricting_next /*
*/ genvote_last hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1

*Table 2 (using Clarify 2.1). We estimate the model twice, each time setting the "switcher" paramter to either
* 0 or 1 in the simulations, respectively, in order to estimate the predicted probabilities used in Figure 1
net install clarify
estsimp mlogit next switcher years_in_office age black_legislator majority redistricting_next genvote_last hhincome_000s_last /*
*/ somecollege_last black_last senate ar-va census1990_last if other~=1 & term_limited==0, b(2)
setx switcher 0 years_in_office 7.25 age 51.88 black_legislator 0 majority 0 redistricting_next 0 genvote_last 81.7 /*
*/ hhincome_000s_last 39.03 somecollege_last 24.29 black_last 30.43 senate 0 census1990_last 1 ar-va 0
simqi, pr
drop b1-b46

estsimp mlogit next switcher years_in_office age black_legislator majority redistricting_next genvote_last hhincome_000s_last /*
*/ somecollege_last black_last senate ar-va census1990_last if other~=1 & term_limited==0, b(2)
setx switcher 1 years_in_office 7.25 age 51.88 black_legislator 0 majority 0 redistricting_next 0 genvote_last 81.7 /*
*/ hhincome_000s_last 39.03 somecollege_last 24.29 black_last 30.43 senate 0 census1990_last 1 ar-va 0
simqi, pr
drop b1-b46

*Table 3, base model
logit Ran_AnyHigher_Later switcher term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1

*Table 3, conditional model
logit Ran_AnyHigher_Later switcher switcherX1990s_last term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1


/* Appendix */

*Table S2
mprobit next switcher years_in_office age black_legislator majority redistricting_next genvote_last hhincome_000s_last /*
*/ somecollege_last black_last senate ar-va census1990_last if other~=1 & term_limited==0, base(2)

*Table S3
logit won_general_next switcher years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate census1990_last if other~=1

*Table S4, Model 1 (DV: Retirements)
logit retired switcher term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome000s_next somecollege_next black_next senate ar-va census1990_last if other~=1

*Table S4, Model 2 (DV: win next election)
logit won_next switcher years_in_office age black_legislator majority redistricting_next genvote_last hhincome000s_next /*
*/ somecollege_next black_next senate ar-va census1990_last if other~=1

*Table S4, Model 2 (DV: vote %)
reg genvote_next switcher years_in_office age black_legislator majority redistricting_next genvote_last hhincome000s_next /*
*/ somecollege_next black_next senate ar-va census1990_last if other~=1

*Table S4, Model 2 (DV: vote % at previous election, placebo)
reg genvote_last switcher years_in_office age black_legislator majority redistricting_next double_lag hhincome000s_next /*
*/ somecollege_next black_next senate ar-va census1990_last if other~=1

*Table S4, Model 3 (DV: higher office)
logit higher_office_sought_next switcher term_limited years_in_office age black_legislator majority redistricting_next /*
*/ genvote_last hhincome000s_next somecollege_next black_next senate ar-va census1990_last if other~=1

*Table S5, Model (4)
mlogit next switcher years_in_office age black_legislator majority redistricting_next genvote_last hhincome000s_next /*
*/ somecollege_next black_next senate ar-va census1990_last if other~=1 & term_limited==0, b(2)

*Table S5, Model (5), left column
logit Ran_AnyHigher_Later switcher term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome000s_next somecollege_next black_next senate ar-va census1990_last if other~=1

*Table S5, Model (5), right column
logit Ran_AnyHigher_Later switcher switcherX1990s_last term_limited years_in_office age black_legislator majority /*
*/ redistricting_next genvote_last hhincome000s_next somecollege_next black_next senate ar-va census1990_last if other~=1

*Table S6, Model 1 (DV: Retirements)
logit retired switcher term_limited years_in_office age majority redistricting_next genvote_last hhincome_000s_last /*
*/ somecollege_last black_last senate ar-va census1990_last if other~=1 & black_legislator==0

*Table S6, Model 2 (DV: win next election)
logit won_next switcher years_in_office age majority redistricting_next genvote_last hhincome_000s_last somecollege_last /*
*/ black_last senate ar-va census1990_last if other~=1 & black_legislator==0

*Table S6, Model 2 (DV: vote %)
reg genvote_next switcher years_in_office age majority redistricting_next genvote_last hhincome_000s_last somecollege_last /*
*/ black_last senate ar-va census1990_last if other~=1 & black_legislator==0

*Table S6, Model 2 (DV: vote % at previous election, placebo)
reg genvote_last switcher years_in_office age majority redistricting_next double_lag hhincome_000s_last somecollege_last /*
*/ black_last senate ar-va census1990_last if other~=1 & black_legislator==0

*Table S6, Model 3 (DV: higher office)
logit higher_office_sought_next switcher term_limited years_in_office age majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1 & black_legislator==0

*Table S7, Model (4)
mlogit next switcher years_in_office age majority redistricting_next genvote_last hhincome_000s_last somecollege_last /*
*/ black_last senate ar-va census1990_last if other~=1 & term_limited==0 & black_legislator==0, b(2)

*Table S7, Model (5), left column
logit Ran_AnyHigher_Later switcher term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome000s_next somecollege_next black_next senate ar-va census1990_last if other~=1 & black_legislator==0

*Table S7, Model (5), right column
logit Ran_AnyHigher_Later switcher switcherX1990s_last term_limited years_in_office age majority redistricting_next genvote_last hhincome000s_next /*
*/ somecollege_next black_next senate ar-va census1990_last if other~=1 & black_legislator==0

*Table S8, Model 1 (DV: Retirements)
logit retired switcher term_limited years_in_office age black_legislator majority shor redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1 & shor_switcher_RepIdeol~=1

*Table S8, Model 2 (DV: win next election)
logit won_next switcher years_in_office age black_legislator majority shor redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1 & shor_switcher_RepIdeol~=1

*Table S8, Model 2 (DV: vote %)
reg genvote_next switcher years_in_office age black_legislator majority shor redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1 & shor_switcher_RepIdeol~=1

*Table S8, Model 2 (DV: vote % at previous election, placebo)
reg genvote_last switcher years_in_office age black_legislator majority shor redistricting_next double_lag hhincome_000s_last /*
*/ somecollege_last black_last senate ar-va census1990_last if other~=1 & shor_switcher_RepIdeol~=1

*Table S8, Model 3 (DV: higher office)
logit higher_office_sought_next switcher term_limited years_in_office age black_legislator majority shor redistricting_next /*
*/ genvote_last hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1 & shor_switcher_RepIdeol~=1

*Table S9, Model (4)
mlogit next switcher years_in_office age black_legislator majority shor redistricting_next genvote_last hhincome_000s_last /*
*/ somecollege_last black_last senate ar-va census1990_last if other~=1 & term_limited==0 & shor_switcher_RepIdeol~=1, b(2)

*Table S9, Model (5), left column
logit Ran_AnyHigher_Later switcher term_limited years_in_office age black_legislator majority shor redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1 & shor_switcher_RepIdeol~=1

*Table S9, Model (5), right column
logit Ran_AnyHigher_Later switcher switcherX1990s_last term_limited years_in_office age black_legislator majority shor redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last if other~=1 & shor_switcher_RepIdeol~=1

*Table S10, Model 1 (DV: Retirements)
logit retired switcher term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last /*
*/ change_dem_pct_seat squire if other~=1

*Table S10, Model 2 (DV: win next election)
logit won_next switcher years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate ar-va census1990_last /*
*/ change_dem_pct_seat squire  if other~=1

*Table S10, Model 2 (DV: vote %)
reg genvote_next switcher years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate change_dem_pct_seat squire ar-va census1990_last /*
*/ if other~=1

*Table S10, Model 2 (DV: vote % at previous election, placebo)
reg genvote_last switcher years_in_office age black_legislator majority redistricting_next double_lag hhincome_000s_last /*
*/ somecollege_last black_last senate change_dem_pct_seat squire ar-va census1990_last /*
*/ if other~=1

*Table S10, Model 3 (DV: higher office)
logit higher_office_sought_next switcher term_limited years_in_office age black_legislator majority redistricting_next /*
*/ genvote_last hhincome_000s_last somecollege_last black_last senate change_dem_pct_seat squire ar-va census1990_last /*
*/ if other~=1

*Table S11, Model (4)
mlogit next switcher years_in_office age black_legislator majority redistricting_next genvote_last hhincome_000s_last /*
*/ somecollege_last black_last senate change_dem_pct_seat squire ar-va census1990_last /*
*/ if other~=1 & term_limited==0, b(2)

*Table S11, Model (5), left column
logit Ran_AnyHigher_Later switcher term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate change_dem_pct_seat squire ar-va census1990_last /*
*/ if other~=1

*Table S11, Model (5), right column
logit Ran_AnyHigher_Later switcher switcherX1990s_last term_limited years_in_office age black_legislator majority redistricting_next genvote_last /*
*/ hhincome_000s_last somecollege_last black_last senate change_dem_pct_seat squire ar-va census1990_last /*
*/ if other~=1
