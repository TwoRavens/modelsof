clear all
gen notenter = !enter

gen thirds = cond(Period < 11, 1, cond(Period < 21, 2, 3))
tabstat offer bid Payoff surplus if Responder==0, by(EarnedRight) stat(mean sd)
tabstat notfight bid Payoff surplus if Responder==1, by(EarnedRight) stat(mean sd)

test _cons + Responder = 15



xtreg notfight Period if  EarnedRight==0 & Period>0 & Type==2, re vce(cluster Session)

//Estimates for table 5

xtreg offer EarnedRight Period pdE if  Period>0 & Type==1, re vce(cluster Session)
test (Period + pdE = 0)
xtreg Payoff EarnedRight Period if Period>0 & Responder==0, re vce(cluster Session)
tabstat offer if Responder==0 & accept==0, by(EarnedRight) stat(N)
tabstat offer if Responder==0 & accept==0 & offer>0, by(EarnedRight) stat(N)
tabstat offer if Responder==1 & notenter==1, by(EarnedRight) stat(N)

tabstat offer bid if offer>0 & accept==1 & Responder==0 & notenter==0, by(EarnedRight) stat(mean sd)
test (accept + EarnAcc = 0)

//Estimates for footnote 13