
log using "C:\Users\bauschaw\Documents\awb257 (POLFS1)\experiment2\data\psrm.log"

clear 
use "C:\Users\bauschaw\Documents\awb257 (POLFS1)\experiment2\data\psrm.dta", clear

xtset uniquesubject period
gen log_period = ln(period)
gen log_timesleader = ln(timesleader)
gen democracy = 0
replace democracy = 1 if votesneeded == 3



gen myDist = dist1 if playernum == 1
replace myDist = dist2 if playernum == 2
replace myDist = dist3 if playernum == 3
replace myDist = dist4 if playernum == 4
replace myDist = dist5 if playernum == 5
replace myDist = dist6 if playernum == 6

gen totaluse = dist1 + dist2 + dist3 + dist4 + dist5 + dist6 + pubgood
gen useZero = 0
replace useZero =1  if totaluse == 0 & finalgrouppoints != 0 
	

** This is only correct for the leader
gen privgood = dist1 + dist2 + dist3 + dist4 + dist5 + dist6 - myDist if leader == 1


** endowment dummies
gen endow200 = 0
replace endow200 = 1 if grouproundpoints ==200
gen endow150 = 0
replace endow150 = 1 if grouproundpoints == 150

gen nowar =0
replace nowar =1 if accept1 == 1 & oppresponse1 == 1
	
	
***** PSRM paper
*** Table 1
* Produces Table 1, Model 1
xtlogit vote roundpayoff i.democracy i.grouproundpoints  log_timesleader if leader == 0 & nowar==1
est store A


* Produces Table 1, Model 2 
xttobit roundpayoff i.democracy i.grouproundpoints log_timesleader if leader == 0 & nowar==1, ll(0) 
est store B
* Produces predictions from text on bottom of page 13
margins democracy, predict(ystar(0,.)) post
test 0.democracy == 1.democracy

* Produces Table 1, Model 3 
xttobit pubgood i.democracy i.grouproundpoints log_timesleader if leader == 1 & useZero ==0 & nowar==1, ll(0) ul(finalgrouppoints)
est store C
* Produces Figure 1
margins democracy, at(grouproundpoints = (100 (50) 200)) predict(ystar(0,.)) post
marginsplot, legend(off) xtitle("Endowment") ytitle("Public Good Investment") title("") ///
 plot1opts(msymbol(D)) plot2opts(msymbol(S)) xscale(range(90 210))
test 0.democracy#1._at == 1.democracy#1._at 
test 0.democracy#2._at == 1.democracy#2._at 
test 0.democracy#3._at == 1.democracy#3._at


* Produces Table 1, Model 4
xttobit privgood i.democracy i.grouproundpoints log_timesleader if leader == 1 & useZero ==0 & nowar==1, ll(0) ul(finalgrouppoints)
est store D
* Produces Figure 2
margins democracy, at(grouproundpoints = (100 (50) 200)) predict(ystar(0,.)) post
marginsplot, legend(off) xtitle("Endowment") ytitle("Private Goods") title("") ///
 plot1opts(msymbol(D)) plot2opts(msymbol(S)) xscale(range(90 210))
test 0.democracy#1._at == 1.democracy#1._at 
test 0.democracy#2._at == 1.democracy#2._at 
test 0.democracy#3._at == 1.democracy#3._at

gen privBinary = 0
replace privBinary = 1 if privgood != 0
* Produces Table 1, Model 5
xtlogit privBinary i.democracy i.grouproundpoints log_timesleader if leader == 1 & useZero ==0 & nowar==1
est store E
*margins democracy, at(grouproundpoints = (100 (50) 200)) predict(pu0) post
*marginsplot, legend(off) xtitle("Endowment") ytitle("Private Goods") title("") ///
* plot1opts(msymbol(D)) plot2opts(msymbol(S))
*test 0.democracy#1._at == 1.democracy#1._at 
*test 0.democracy#2._at == 1.democracy#2._at 
*test 0.democracy#3._at == 1.democracy#3._at

*lqreg privBinary democracy  endow150 endow200 log_timesleader if leader == 1 & useZero ==0 & wonwar==-1, cluster(uniquesubject) quantiles(.15)	


* To create Tables
esttab A B C D E using table1.tex, replace f ///
 	label booktabs b(3) p(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01)


******* Lags 
sort uniquesubject period 
by uniquesubject: gen lag_vote = vote[_n-1] if timesleader != 1 
replace lag_vote = . if leader == 1

by uniquesubject: gen lag_roundpayoff = roundpayoff[_n-1] if timesleader != 1 
replace lag_roundpayoff = . if leader == 1

by uniquesubject: gen lag_nowar = nowar[_n-1] if timesleader != 1

by uniquesubject: gen lag_grouproundpoints = grouproundpoints[_n-1] if timesleader != 1

gen endowdiff = grouproundpoints - lag_grouproundpoints

gen myDistBinary = 0
replace myDistBinary = 1 if myDist > 0


*** Table 2


* Produces Table 2, Model 1
xttobit roundpayoff  i.democracy##i.lag_vote endowdiff log_timesleader  if leader ==0 &  useZero == 0 & nowar==1 & lag_nowar==1, ll(0) 
est store T
* Produces Table 3, Left
margins democracy,  at (lag_vote == (0 1) ) predict(ystar(0,.)) post
test 0.democracy#1._at == 0.democracy#2._at 
test 1.democracy#1._at == 1.democracy#2._at 

* Produces Table 2, Model 2
xttobit  myDist i.democracy##i.lag_vote endowdiff log_timesleader  if leader ==0 & useZero == 0 & nowar==1 & lag_nowar==1, ll(0) ul(finalgrouppoints)
est store U
* Produces Table 3, Center
margins democracy,  at (lag_vote == (0 1) ) predict(ystar(0,.)) post
test 0.democracy#1._at == 0.democracy#2._at 
test 1.democracy#1._at == 1.democracy#2._at 

* Produces Table 2, Model 3
xtprobit myDistBinary i.democracy##i.lag_vote endowdiff log_timesleader  if leader ==0 & useZero == 0 & nowar==1 & lag_nowar==1
est store V
* Produces Table 3, Right
margins democracy,  at (lag_vote == (0 1) ) predict(pu0) post
test 0.democracy#1._at == 0.democracy#2._at 
test 1.democracy#1._at == 1.democracy#2._at 


esttab T U V using table7.tex, replace f ///
 	label booktabs b(3) p(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01)
 
 
*** Leader Payoffs
*** Table 4
gen experiencedLeader = 0 if leader == 1
replace experiencedLeader = 1 if leader ==1 & timesleader > 1
* Produces Table 4, Model 1
xttobit myDist  i.democracy i.grouproundpoints if leader ==1 & useZero == 0 & wonvote ==1 & nowar==1, ll(0) 
est store W
* Produces predictions in text on top of page 21
margins democracy, predict(ystar(0,.)) post	

* Produces Table 3, Model 2
xttobit myDist  i.democracy##i.experiencedLeader i.grouproundpoints if leader ==1 & useZero == 0 & wonvote ==1 & nowar==1, ll(0) 
est store X
* Produces predictions related to the text near bottom of page 21
margins democracy,  at (experiencedLeader == (0 1)) predict(ystar(0,.)) post
test 0.democracy#1._at == 0.democracy#2._at 
test 1.democracy#1._at == 1.democracy#2._at 

* Produces Table 4, Model 3	
xttobit roundpayoff  i.democracy##i.experiencedLeader i.grouproundpoints if leader ==1 & useZero == 0 & wonvote ==1 & nowar==1, ll(0) 
est store Y
* Produces predictions related to text on bottom of page 21 and top of page 22
margins democracy,  at (experiencedLeader == (0 1)) predict(ystar(0,.)) post
test 0.democracy#1._at == 0.democracy#2._at 
test 1.democracy#1._at == 1.democracy#2._at 

* Produces summary stats for footnote 17
sum roundpayoff if  leader ==1 & useZero == 0 & wonvote ==1 & nowar==1 & democracy==0 & experiencedLeader == 0
sum roundpayoff if  leader ==1 & useZero == 0 & wonvote ==1 & nowar==1 & democracy==0 & experiencedLeader == 1
sum roundpayoff if  leader ==1 & useZero == 0 & wonvote ==1 & nowar==1 & democracy==1 & experiencedLeader == 0
sum roundpayoff if  leader ==1 & useZero == 0 & wonvote ==1 & nowar==1 & democracy==1 & experiencedLeader == 1


 esttab W X Y using table7.tex, replace f ///
 	label booktabs b(3) p(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01)
 
 
 
** Scatter plots
* pub goods
* Produces Figure 1 in the appendix
graph twoway (scatter pubgood timesleader if democracy==0 & leader==1 & nowar==1,  msymbol(D) jitter(10)) ///
	(scatter pubgood timesleader if democracy==1 & leader==1 & nowar==1, msymbol(S) jitter(10)) ///
    (lowess pubgood timesleader if democracy==0 & leader==1 & nowar==1, lcolor(navy)) ///
	(lowess pubgood timesleader if democracy==1 & leader==1 & nowar==1, lcolor(maroon) ///
	xtitle("Times Leader") ytitle("Public Goods") title("") legend(label( 1 "Small Coalition") label( 2 "Large Coalition") label( 3 "Small Coalition Lowess") label( 4 "Large Coalition Lowess")))

* Produces Figure 2 in the appendix
graph twoway (scatter pubgood log_timesleader if democracy==0 & leader==1 & nowar==1,  msymbol(D) jitter(10)) ///
	(scatter pubgood log_timesleader if democracy==1 & leader==1 & nowar==1, msymbol(S) jitter(10)) ///
    (lowess pubgood log_timesleader if democracy==0 & leader==1 & nowar==1, lcolor(navy)) ///
	(lowess pubgood log_timesleader if democracy==1 & leader==1 & nowar==1, lcolor(maroon) ///
	xtitle("Log of Times Leader") ytitle("Public Goods") title("") legend(label( 1 "Small Coalition") label( 2 "Large Coalition") label( 3 "Small Coalition Lowess") label( 4 "Large Coalition Lowess")))
		
	
* priv goods	
* Produces Figure 3 in the appendix
graph twoway (scatter privgood timesleader if democracy==0 & leader==1 & nowar==1,  msymbol(D) jitter(10)) ///
	(scatter privgood timesleader if democracy==1 & leader==1 & nowar==1, msymbol(S) jitter(10)) ///
    (lowess privgood timesleader if democracy==0 & leader==1 & nowar==1, lcolor(navy)) ///
	(lowess privgood timesleader if democracy==1 & leader==1 & nowar==1, lcolor(maroon) ///
	xtitle("Times Leader") ytitle("Private Goods") title("") legend(label( 1 "Small Coalition") label( 2 "Large Coalition") label( 3 "Small Coalition Lowess") label( 4 "Large Coalition Lowess")))

* Produces Figure 4 in the appendix
graph twoway (scatter privgood log_timesleader if democracy==0 & leader==1 & nowar==1,  msymbol(D) jitter(10)) ///
	(scatter privgood log_timesleader if democracy==1 & leader==1 & nowar==1, msymbol(S) jitter(10)) ///
    (lowess privgood log_timesleader if democracy==0 & leader==1 & nowar==1, lcolor(navy)) ///
	(lowess privgood log_timesleader if democracy==1 & leader==1 & nowar==1, lcolor(maroon) ///
	xtitle("Log of Times Leader") ytitle("Private Goods") title("") legend(label( 1 "Small Coalition") label( 2 "Large Coalition") label( 3 "Small Coalition Lowess") label( 4 "Large Coalition Lowess")))

* Lag Vote
* Produces Figure 5 in the appendix
graph twoway (scatter roundpayoff log_timesleader if democracy==0 & leader==0 & nowar==1 & lag_vote==0 &  useZero == 0 & lag_nowar==1,  msymbol(T) jitter(10)) ///
	(scatter roundpayoff log_timesleader if democracy==0 & leader==0 & nowar==1 & lag_vote==1 &  useZero == 0 & lag_nowar==1, msymbol(X) jitter(10)) ///
	(lowess roundpayoff log_timesleader if democracy==0 & leader==0 & nowar==1 & lag_vote==0 &  useZero == 0 & lag_nowar==1, lcolor(navy)) ///
	(lowess roundpayoff log_timesleader if democracy==0 & leader==0 & nowar==1 & lag_vote==1 &  useZero == 0 & lag_nowar==1, lcolor(maroon) ///
	xtitle("Small Coalition: Log of Times Leader") ytitle("Round Payoff") title("") legend(label( 1 "Lag Vote = 0") label( 2 "Lag Vote = 1") label( 3 "Lag Vote = 0 Lowess") label( 4 "Lag Vote = 1 Lowess")))	

* Produces Figure 6 in the appendix
graph twoway (scatter roundpayoff log_timesleader if democracy==1 & leader==0 & nowar==1 & lag_vote==0 &  useZero == 0 & lag_nowar==1,  msymbol(T) jitter(10)) ///
	(scatter roundpayoff log_timesleader if democracy==1 & leader==0 & nowar==1 & lag_vote==1 &  useZero == 0 & lag_nowar==1, msymbol(X) jitter(10)) ///
	(lowess roundpayoff log_timesleader if democracy==1 & leader==0 & nowar==1 & lag_vote==0 &  useZero == 0 & lag_nowar==1, lcolor(navy)) ///
	(lowess roundpayoff log_timesleader if democracy==1 & leader==0 & nowar==1 & lag_vote==1 &  useZero == 0 & lag_nowar==1, lcolor(maroon) ///
	xtitle("Large Coalition: Log of Times Leader") ytitle("Round Payoff") title("") legend(label( 1 "Lag Vote = 0") label( 2 "Lag Vote = 1") label( 3 "Lag Vote = 0 Lowess") label( 4 "Lag Vote = 1 Lowess")))	

log close
