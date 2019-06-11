*Title: SCBH Attitudes and Behaviors
*Author: Jack Reilly
*Date: 4.28.17
*Purpose: Look at descriptive statistics and trends across connectedness
*Requires: 1992 CNES Data File, "Data Management.do", "coefplot" package, "sol" graphics scheme
*Output: Descriptive statistics for table 1, figure 1
*Stata 13.1 SE on macOS 10.12

cd "~/your/working/directory"
use "connectedness_working.dta", clear

gen pid3_scale = -abs((pid3-1)/2)
gen ideo_scale = -(ideology-1)/9
recode v51 1=3 3=2 5=1 8=0, gen(interest)

save "connectedness_working_interest.dta", replace

*Tables
bys outdegree: sum turnout
bys outdegree: sum pid3_scale
bys outdegree: sum ideo_scale

bys outdegree: sum votebush
bys outdegree: sum voteclinton
bys outdegree: sum voteperot

bys outdegree: sum proaffaction
bys outdegree: sum proenvironment
bys outdegree: sum progovthealth
bys outdegree: sum prolife

bys outdegree: sum convince
bys outdegree: sum campaignwork
bys outdegree: sum attpolmeetings
bys outdegree: sum yardsticker
bys outdegree: sum donatemoney

tab outdegree

*trends

logit proaffaction outdegree
logit proenvironment outdegree
logit progovthealth outdegree
logit prolife outdegree
reg pid outdegree

logit proaffaction outdegree educ income black  hispanic female interest
estimates store affact

logit proenvironment outdegree educ income black  hispanic female interest
estimates store enviro

logit progovthealth outdegree educ income black  hispanic female  interest
estimates store health	

logit prochoice outdegree educ income black  hispanic female  interest
estimates store abort

ologit ideology  outdegree educ income black  hispanic female  interest
estimates store ideology

ologit vote outdegree educ income black  hispanic female  interest
estimates store vote

logit votebush outdegree educ income black  hispanic female  interest
logit voteclinton outdegree educ income black  hispanic female  interest
logit voteperot outdegree educ income black  hispanic female  interest

ologit pid3 outdegree educ income black  hispanic female  interest
estimates store pid3

logit convince outdegree 
logit campaignwork outdegree
logit attpolmeetings outdegree
logit yardsticker outdegree
logit donatemoney outdegree
logit turnout outdegree

logit convince outdegree educ income black  hispanic female  interest
estimates store convince

logit campaignwork outdegree educ income black  hispanic female  interest
estimates store campaign

logit attpolmeetings outdegree educ income black  hispanic female  interest
estimates store meetings

logit yardsticker outdegree educ income black  hispanic female  interest
estimates store yard

logit donatemoney outdegree educ income black  hispanic female  interest
estimates store donate

logit turnout outdegree educ income black  hispanic female  interest
estimates store turnout

ologit totalacts outdegree educ income black  hispanic female  interest
estimates store totalacts

set scheme sol

coefplot pid3 || ideology || vote || affact || enviro || health || abort || turnout || convince || campaign || meetings || yard || donate || totalacts, xline(3.5 7.5 13.5) yline(0, lwidth(medium) lpattern(dot)) ylabel(-.1(.1).4, labsize(medlarge) angle(horizontal)) bycoefs vertical byopts(yrescale) drop(_cons educ income black hispanic female interest) scheme(s1manual) title("Point Estimate with 95% Confidence Intervals", size(medsmall)) xlabel(1 "Partisanship" 2 "Ideology" 3 "Vote Choice" 4 "Aff. Action" 5 "Environment" 6 "Health Care" 7 "Abortion" 8 "Turnout" 9 "Persuade" 10 "Campaign" 11 "Go to Meetings" 12 "Yard Signs" 13 "Donate Money" 14 "Total Acts", angle(vertical)) ytitle("Effect of Connectedness on Attitude/Behavior", size(medsmall)) ci(95) xsize(6) ysize(4)
graph export "fxgraphfull_interest.pdf", replace
