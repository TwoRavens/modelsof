*Stata Commands for "Voice and Silence in Terrorist Campaigns"

*Variable labels
label var year "Year of attack"
label var month "Month of attack"
label var day "Day of attack"
label var groups_t1 "Number of active terrorist organizations in year t-1"
label var suicide "Suicide attacks"
label define suicide 0 "No" 1 "Yes"
label var claimed "Claim of responsibilty"
label define claimed 0 "No" 1"Yes"
label var nleft_t1 "Number of active left-wing/nationalist groups in year t-1"
label var settlers "West Bank Settler Population"
label var outsiders "Attacks included operatives from neighboring countries"
label define external_help 0 "No" 1 "Yes"
label var milresponse "Number of military counter--terrorism actions within seven days of attack"
label var religious "Number of active religious/millenarian groups in year t-1"
label var ratio "Ratio of active religious/millenarian groups to left-wing/nationalist groups"
label var spon_per "Percentage of active groups receiving state sponsorship"
label var att_date "Month, day, year code"
label var time "Days passed since 14 November 1967 (use with variogram analysis)"

*Variable transformations (and labels)
generate group3=exp(groups_t1-3)/(1+exp(groups_t1-3))
label var group3 "Logit of Competitive context with inflection point at 3 groups"
generate group4=exp(groups_t1-4)/(1+exp(groups_t1-4))
label var group4 "Logit of Competitive context with inflection point at 4 groups"
generate group5=exp(groups_t1-5)/(1+exp(groups_t1-5))
label var group5 "Logit of Competitive context with inflection point at 5 groups"
generate group55=exp(groups_t1-5.5)/(1+exp(groups_t1-5.5))
label var group55 "Logit of Competitive context with inflection point at 5.5 groups"
generate group6=exp(groups_t1-6)/(1+exp(groups_t1-6))
label var group6 "Logit of Competitive context with inflection point at 6 groups"
generate milsquared=milresponse^2
label var milsquared "Number of military counter--terrorism actions within seven days of attack (squared)"
generate settlerlog=log(settlers)
label var settlerlog "West Bank Settler Population (logged)"

*Table I: Logistic Regression Results.

*Model 1
logit claimed group55
fitstat

*Model 2
logit claimed group55 ratio milresponse settlerlog spon_per suicide
fitstat

*Model 3
logit claimed group55 ratio milresponse milsquared settlerlog spon_per suicide
fitstat

*Model 4
logit claimed ratio milresponse milsquared settlerlog spon_per suicide
fitstat

*Table II: Change in Predicted Probabilities for Model Three (uses CLARIFY)
estsimp logit claimed group55 ratio milresponse milsquared settlerlog spon_per suicide
setx mean
simqi, fd(pr) changex(group55 min max)
setx mean
simqi, fd(pr) changex(ratio min max)
setx mean
simqi, fd(pr) changex(milresponse min max)
setx mean
simqi, fd(pr) changex(milsquared min max)
setx mean
simqi, fd(pr) changex(settlerlog min max)
setx mean
simqi, fd(pr) changex(suicide min max)


*BTSCS Logistic regression (appendix)
btscs claimed days Israel, g(silence) nspline(3)
logit claimed group55 ratio milresponse milsquared settlerlog spon_per suicide silence _spline1 _spline2 _spline3

*Sensitivity checks for Model 3 (appendix)
quietly logit claimed group55 ratio milresponse milsquared settlerlog spon_per suicide
lstat
lroc

*See SAS command file for commands to replicate Figure 2 (appendix), Standard and Robust Variograms"





