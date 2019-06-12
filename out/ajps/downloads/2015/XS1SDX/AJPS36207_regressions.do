clear

set more off


/*SET YOUR PATH*/

cd "C:\Users\YOUR PATH\"

use AJPS36207.dta


/***Table 1***/
preserve
keep if elec==1
drop if cand==1
drop candidate 

rename promise_a promise_1
rename promise_b promise_2
rename mybelief_v_a mybelief_v_1
rename mybelief_v_b mybelief_v_2

reshape long promise_ mybelief_v_   , i(id session) j(candidate)
gen promise_sqr=promise_^2

reg mybelief_v_ promise_ , cluster(session)
reg mybelief_v_ promise_ promise_sqr, cluster(session)

*Robustness: Tobit
tobit mybelief_v_ promise_ , cluster(session) ul(450) ll(0)
tobit mybelief_v_ promise_ promise_sqr, cluster(session) ul(450) ll(0)

restore

/***Table 2***/
preserve
drop if cand==1

replace diffpromise=diffpromise/100
replace diffpromise2=diffpromise2/10000

reg vote_a diffpromise if elec==1, robust cluster(session)
reg vote_a diffpromise diffpromise2 if elec==1, robust cluster(session)


*Robustness: Probit
probit vote_a diffpromise if elec==1, robust cluster(session)
probit vote_a diffpromise diffpromise2 if elec==1, robust cluster(session)

restore

/***Table 3***/
preserve
keep if cand==1

reg avgmyshare elec if nocamp==0 , robust
reg avgmyshare elec promise if nocamp==0, robust
reg avgmyshare elec nocamp, robust
test nocamp=elec

*Robustness: Tobit
tobit avgmyshare elec if nocamp==0 , ul(450) ll(0) robust
tobit avgmyshare elec promise if nocamp==0, ul(450) ll(0) robust
tobit avgmyshare elec nocamp, ul(450) ll(0) robust
test nocamp=elec

restore

/***Table 4***/
preserve
keep if cand==1
reshape long mysharev, i(id) j(votes)

recode votes (1=60) (2=80) (3=100)
gen votesXelec=votes*elec
gen votesXrandom=votes*random


reg myshare votes promise if elec==1 , robust cluster(id)
est store strategy
reg myshare votes promise if random==1 , robust cluster(id)
reg myshare votes  if nocamp==1 , robust cluster(id)
reg myshare votes elec random votesXelec votesXrandom, r cluster(session)
test votesXelec= votesXrandom



*Robustness: Tobit
tobit  myshare votes promise if elec==1 , ul(450) ll(0) robust cluster(id)
tobit  myshare votes promise if random==1 , ul(450) ll(0) robust cluster(id)
tobit  myshare votes  if nocamp==1 , ul(450) ll(0) robust cluster(id)
tobit  myshare votes elec random votesXelec votesXrandom, ul(450) ll(0) cluster(session)
test votesXelec= votesXrandom

restore


/***Table 5***/

preserve
clear

use AJPS36207direct.dta
drop if cand==0

recode votes_winner (2=66) (3=100)
recode my_approval (0=0) (1=33) (2=66) (3=100)
gen votes_winnerXperiod= votes_winner*period


reg myshare votes_winner promise, cluster(session)
est store direct
reg myshare votes_winner promise times_elected_before, cluster(session)


restore


*Comparing coefficient "Approval" in direct and strategy method data 

est for strategy: matrix b_strategy = e(b)
est for strategy: matrix cov_strategy = e(V)


est for direct: matrix b_direct = e(b)
est for direct: matrix cov_direct = e(V)

matrix b_direct = b_direct[1,1..1]
matrix var_direct = cov_direct[1..1,1..1]

matrix b_strategy = b_strategy[1,1..1]
matrix var_strategy = cov_strategy[1..1,1..1]


scalar chisqr = (b_direct[1,1] - b_strategy[1,1])^2/(var_direct[1,1] + var_strategy[1,1])

di "Chi2-Test: Difference in response to approval rate: Direct vs.  Strategy Chi2(1),p = ", chi2tail(1,chisqr)


/*** Table 7***/
preserve
keep if elec==1
drop if cand==1
drop candidate 

rename promise_a promise_1
rename promise_b promise_2
rename mybelief_v_a mybelief_v_1
rename mybelief_v_b mybelief_v_2

gen promisetext_1=a_promise
gen promisetext_2=b_promise


reshape long promise_ mybelief_v_   promisetext_, i(id session) j(candidate)

gen promise_sqr=promise_^2
gen promisetextXpromise_ = promisetext_ * promise_

reg mybelief_v_ promise_ promisetext_, cluster(session)
reg mybelief_v_ promise_ promisetext_ promisetextXpromise_, cluster(session)
reg mybelief_v_ promise_ promise_sqr promisetext_ promisetextXpromise_, cluster(session)

*Robustness: Tobit
tobit mybelief_v_ promise_ promisetext_, cluster(session) ul(450) ll(0)
tobit mybelief_v_ promise_ promisetext_ promisetextXpromise, cluster(session) ul(450) ll(0)
tobit mybelief_v_ promise_ promise_sqr promisetext_ promisetextXpromise, cluster(session) ul(450) ll(0)

restore




/***Table 8***/
preserve
drop if cand==1

replace diffpromise=diffpromise/100
replace diffpromise2=diffpromise2/10000

gen diffpromiseXdiffmessage=diffpromise*diffmessage

reg vote_a diffpromise diffpromise2 diffmessage  if elec==1, robust cluster(session)
reg vote_a diffpromise diffpromise2 diffmessage diffpromiseXdiffmessage if elec==1, robust cluster(session)

*Robustness: Probit
probit vote_a diffpromise diffpromise2 diffmessage  if elec==1, robust cluster(session)
probit vote_a diffpromise diffpromise2 diffmessage diffpromiseXdiffmessage if elec==1, robust cluster(session)

restore


/***Table 9***/


preserve
keep if cand==1

reg avgmyshare elec promise abpromisetext if nocamp==0, robust
reg avgmyshare elec promise abpromisetext promiseXabpromisetext if nocamp==0, robust


*Robustness: Tobit
tobit avgmyshare elec promise abpromisetext if nocamp==0 , ul(450) ll(0) robust
tobit avgmyshare elec promise abpromisetext if nocamp==0, ul(450) ll(0) robust


restore




/***Table 10***/
preserve
keep if cand==1
keep if elec==1

reshape long mybeliefcand mysharev, i(id) j(votes)

recode votes (1=60) (2=80) (3=100)
gen votesXelec=votes*elec
gen votesXrandom=votes*random

reg mybeliefcand votes promise  , robust cluster(id)
reg myshare votes  mybeliefcand, robust cluster(id)


*Robustness: Tobit
tobit  mybeliefcand votes promise , ul(450) ll(0) robust cluster(id)
tobit  myshare votes  mybeliefcand , ul(450) ll(0) robust cluster(id)


restore



