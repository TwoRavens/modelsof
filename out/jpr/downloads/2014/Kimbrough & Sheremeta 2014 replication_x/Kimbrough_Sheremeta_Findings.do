clear alluse "/Users/ekimbrough/Desktop/Dropbox/Conflict Resolution/Paper 2/Paper/Data and Scripts/Kimbrough_Sheremeta_Data.dta", cleariis Subjectreplace bid = 0 			if bid==-1replace otherbid = 0 		if otherbid==-1gen fight = 0replace fight = 1 		if  enter==1  gen totalbid = bid + otherbidgen surplus = 60 - totalbid gen pdE = Period*EarnedRightgen EarnAcc = EarnedRight*acceptgen EarnOff = EarnedRight*offergen rs = Risk*Sexgen se = EarnedRight*Sexgen sa = Sex*acceptgen Responder = 1 if Type==2replace Responder = 0 if Responder==.tabulate Session, gen(s)gen cooperate = 1 if offer>=15replace cooperate = 0 if cooperate==.gen ce = cooperate*EarnedRightgen oa = offer*acceptgen et = EarnedRight*Respondertabulate Subject, gen(p)gen notfight = !fight
gen notenter = !enterreplace bid =. if fight==0

gen thirds = cond(Period < 11, 1, cond(Period < 21, 2, 3))gen offertype = cond(offer==0, 1, cond(offer < 16, 2, cond(offer < 30, 3, cond(offer==30, 4,5))))gen offertype2 = cond(offer < 16, 1, cond(offer <= 30, 2, 3))//Data and analysis for Table 2
tabstat offer bid Payoff surplus if Responder==0, by(EarnedRight) stat(mean sd)
tabstat notfight bid Payoff surplus if Responder==1, by(EarnedRight) stat(mean sd)
xtreg surplus Period if  EarnedRight==0 & Period>0, re vce(cluster Session)test _cons=30.0xtreg surplus Period if  EarnedRight==1 & Period>0, re vce(cluster Session)test (_cons + Period)=30.0xtreg bid Period Responder if  EarnedRight==0 & fight==1, re vce(cluster Session)test _cons=15
test _cons + Responder = 15
xtreg bid Period Responder if  EarnedRight==1 & fight==1, re vce(cluster Session)test _cons=15test _cons + Responder = 15
xtreg offer Period if  EarnedRight==0 & Period>0 & Type==1, re vce(cluster Session)test _cons=0.0xtreg offer Period if  EarnedRight==1 & Period>0 & Type==1, re vce(cluster Session)test _cons=0.0

xtreg notfight Period if  EarnedRight==0 & Period>0 & Type==2, re vce(cluster Session)test _cons=0.0xtreg notfight Period if  EarnedRight==1 & Period>0 & Type==2, re vce(cluster Session)test _cons=0.0xtreg Payoff Period Responder if EarnedRight==0 & Period>0, re vce(cluster Session)test _cons=15test _cons + Responder = 15xtreg Payoff Period Responder if EarnedRight==1 & Period>0, re vce(cluster Session)test _cons=15test _cons + Responder = 15//Data for table 3tabstat notenter if Responder==1 & EarnedRight==0, by(offertype2)tabstat notenter if Responder==1 & EarnedRight==1, by(offertype2)//Estimates for table 4xtreg enter offer EarnedRight accept Period if Type==2 & Period>0 &  offer>0, re vce(cluster Session)

//Estimates for table 5

xtreg offer EarnedRight Period pdE if  Period>0 & Type==1, re vce(cluster Session)
test (Period + pdE = 0)//Estimates for footnote 11xtreg surplus EarnedRight Period if Period>0, re vce(cluster Session)//Estimates for footnote 12
xtreg Payoff EarnedRight Period if Period>0 & Responder==0, re vce(cluster Session)xtreg Payoff EarnedRight Period if Period>0 & Responder==1, re vce(cluster Session)//Data for Table 6tabstat offer if Responder==0, by(EarnedRight) stat(N)tabstat offer if Responder==0 & offer>0, by(EarnedRight) stat(N)
tabstat offer if Responder==0 & accept==0, by(EarnedRight) stat(N)
tabstat offer if Responder==0 & accept==0 & offer>0, by(EarnedRight) stat(N)
tabstat offer if Responder==1 & notenter==1, by(EarnedRight) stat(N)//Data for Table 7

tabstat offer bid if offer>0 & accept==1 & Responder==0 & notenter==0, by(EarnedRight) stat(mean sd)tabstat offer bid if offer>0 & accept==1 & Responder==1 & notenter==0, by(EarnedRight) stat(mean sd)tabstat offer bid if offer>0 & accept==0 & Responder==0 & notenter==0, by(EarnedRight) stat(mean sd)tabstat offer bid if offer>0 & accept==0 & Responder==1 & notenter==0, by(EarnedRight) stat(mean sd)//Estimates for Table 8xtreg bid offer EarnedRight Period accept EarnAcc if Responder==0 & fight==1 & offer>0, re vce(cluster Session)
test (accept + EarnAcc = 0)xtreg bid offer EarnedRight Period accept EarnAcc if Responder==1 & fight==1 & offer>0, re vce(cluster Session)

//Estimates for footnote 13xtreg bid offer EarnedRight Period accept if Responder==0 & fight==1 & offer>0, re vce(cluster Session)