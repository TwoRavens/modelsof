

** This creates Figure 1
clear
set scheme s1color
insheet using ".\loyaltycouppred.csv"

* generate error bars
gen hi = mean + (1.96 * se)
gen low = mean - (1.96 * se)

* used for spacing Figure
gen type2 = type
replace type2 = type2+2 if (type ==3 | type == 4)
replace type2 = type2+4 if (type ==5 | type == 6)

twoway (bar mean type2 if (type == 1 | type == 3 | type == 5 ), col(dknavy)) (bar mean type2 if (type == 2 | type == 4 | type == 6 ), col(maroon)) (rcap hi low type2, lc(gs11)), ///
legend( order(1 "Opposite Subgroup" 2 "Same Subgroup")) ///
xlabel(1.5 "Control" 5.5 "Election" 9.5 "Coup", noticks) ///
 ytitle("Probability of Making Best Choice") xtitle("Loyalty Model") ylab(0(20)100) yline(20(20)80, lc(ltbluishgray))
*used graph editor to move xtitle below legend
 

** This Creates Figure 2
clear
set scheme s1color
insheet using ".\rotationcouppred0.csv"

* generate error bars
gen hi = mean + (1.96 * se)
gen low = mean - (1.96 * se) 

gen type2 = type
 
twoway (scatter mean type2, col(dknavy)) (rcap hi low type2, lc(gs11)), ///
xlabel(0 " " 1 "Election" 2 "Coup" 3 " ", noticks) ///
 ytitle("Difference From Control") xtitle("Rotation Model") ylab(0(20)-100) yline(-20(20)-80, lc(ltbluishgray)) legend(off)
* used graph editor to move xtitle down



 
clear
use ".\coupproofing.dta" 

* Summary stats for Table 1
tab currenttreat bestchoiceClean if leader == 1, row

* Probit for Table 2, Model 1
probit bestchoiceClean i.demGroup i.coupGroup i.sameGroup if leader ==1 & currenttreat < 4, vce(cluster uniqueid)
est store A
* Marginal effects used to create Figure 1
margins coupGroup, at(demGroup=(0 1) sameGroup =(0 1)) post

test 0.coupGroup#1._at == 1.coupGroup#1._at
test 0.coupGroup#2._at == 1.coupGroup#2._at
test 0.coupGroup#3._at == 1.coupGroup#1._at
test 0.coupGroup#4._at == 1.coupGroup#2._at
* test dem vs control
test 0.coupGroup#1._at == 0.coupGroup#3._at
test 0.coupGroup#2._at == 0.coupGroup#4._at



* Probit for Table 2, Model 2
probit bestchoiceClean i.demRotate i.coupRotate if leader ==1 & currenttreat > 3, asis vce(cluster uniqueid)
est store B
* Marginal effects used to create Figure 2
margins coupRotate, at(demRotate=(0 1)) post


esttab A B using coupTable1.tex, replace f ///
 	label booktabs b(3) p(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01)


* Probit for Table 3
probit coupattempt i.selectedSameGroup if choice ==playernum & currenttreat ==3, vce(cluster uniqueid)
est store C
margins selectedSameGroup

esttab C using coupTable2.tex, replace f ///
 	label booktabs b(3) p(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01)


*** Appendix
* cut points say when a block ended
gen cutpoint1 = 1
gen cutpoint2 = 12
gen cutpoint3 = 22
gen cutpoint4 = 31
gen cutpoint5 = 42
gen cutpoint6 = 51
* blockPeriod says how many rounds into a block we are
gen blockPeriod = 0
replace blockPeriod = period - cutpoint1 + 1 
replace blockPeriod = period - cutpoint2 + 1 if  period >= cutpoint2
replace blockPeriod = period - cutpoint3 + 1 if  period >= cutpoint3
replace blockPeriod = period - cutpoint4 + 1 if period >= cutpoint4
replace blockPeriod = period - cutpoint5 + 1 if  period >= cutpoint5
replace blockPeriod = period - cutpoint6 + 1 if  period >= cutpoint6

* dummy for if a general was selected or now
gen selected = 0
replace selected = 1 if choice == playernum

* dummy for if a general had the highest win prob or not
gen highestProb = 0
replace highestProb = 1 if playernum ==1 & player1prob >= player2prob & player1prob >= player3prob & player1prob >= player4prob
replace highestProb = 1 if playernum ==2 & player2prob >= player1prob & player2prob >= player3prob & player2prob >= player4prob
replace highestProb = 1 if playernum ==3 & player3prob >= player2prob & player3prob >= player1prob & player3prob >= player4prob
replace highestProb = 1 if playernum ==4 & player4prob >= player2prob & player4prob >= player3prob & player4prob >= player1prob


* set up who has attempted a coup
sort uniqueid period
gen attemptedCoup = .
replace attemptedCoup = 0 if (currenttreat == 3 | currenttreat == 6)
by uniqueid: replace attemptedCoup = coupattempt[_n-1] if ( playernum[_n-1] == choice[_n-1]) 
replace attemptedCoup = . if period == cutpoint1  | period == cutpoint2  | period == cutpoint3  | period == cutpoint4  | period == cutpoint5  | period == cutpoint6
by uniqueid: replace attemptedCoup = . if (currenttreat == 3 | currenttreat == 6) & leadernum[_n-1] != leadernum
by uniqueid: replace attemptedCoup = attemptedCoup[_n-1] if ((currenttreat == 3 | currenttreat == 6) & attemptedCoup[_n-1] >  .2 & attemptedCoup[_n-1] < 1.2) 
replace attemptedCoup = . if period == cutpoint1  | period == cutpoint2  | period == cutpoint3  | period == cutpoint4  | period == cutpoint5  | period == cutpoint6

* Probit for Table A2
probit selected i.highestProb i.subgroup##i.attemptedCoup blockPeriod if leader !=1 & currenttreat == 3, vce(cluster uniqueid)
est store D
margins attemptedCoup, at(subgroup=(0 1) highestProb=(0 1)) post
test 0.attemptedCoup#2._at == 1.attemptedCoup#2._at
test 0.attemptedCoup#4._at == 1.attemptedCoup#4._at

esttab D using coupTableA.tex, replace f ///
 	label booktabs b(3) p(3) eqlabels(none) alignment(S S) collabels("\multicolumn{1}{c}{$\beta$ / SE}") ///
	star(* 0.10 ** 0.05 *** 0.01)
