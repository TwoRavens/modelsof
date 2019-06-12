

use ticket-exchange, clear
sort place treatment Cycle Period Group type
drop BeginTicket
gen BeginTicket=.
replace BeginTicket=ticket+grouptransfer if type==1& treatment==2
replace BeginTicket=ticket-grouptransfer if type==2& treatment==2
gen Coop=(Choice ==2|Choice ==3) if type==2
gen OtherCoop =(otherchoice==2|otherchoice==3) if type==1
gen CoopOutcome=Coop==1|OtherCoop==1
gen MALE=gender==2
 * dummy to indicate that a ticket transfer is feasible 
gen feasible=(type==1&BeginTicket>0&partnerticket<2)|(type==2&BeginTicket<2&partnerticket>0) 
 * cycle dummies
tab Cycle ,gen(cycle)
 * treatment dummies
gen TICKET = treatment ==2
 * period dummies
 gen periods_2_5=Period >1&Period <6
 gen periods_6_10=Period >5&Period <11
 gen periods_11_17=Period >10&Period <18
 gen periods_18_25=Period >17&Period <26
 gen periods_26=Period >25
 
 * subject dummies

forvalues p=1/2{
	forvalues t=1/4{
		forvalues s=1/20{
			gen sbj`s'treat`t'pl`p'=Subject==`s'&treatment ==`t'&place ==`p'
		}
	}
}

 * major dummies
gen EngScienceMath=major==5|major==2
gen Business=major==1

 * risk dummies
gen HighRiskAttitude=Risk==5
gen LowRiskAttitude=Risk<3

 * length of previous cycle
bysort session Cycle: egen duration=max(Period)
sort session Subject Cycle Period
by session Subject: gen comodo=duration[_n-1]
replace comodo=-1 if Period>1
by session Subject Cycle: egen lagduration=max(comodo)
replace lagduration=14.3 if Cycle==1
drop comodo

 * grim trigger strategy
gen comodo=1000
replace comodo=Period if CoopOutcome==0
bysort session Cycle Subject: egen primo=min(comodo)
bysort session Cycle Subject: gen grimtrigger=(Period>primo)
drop comodo primo

 * lag 1 an lag 2
sort session Subject Cycle Period
gen CountRed=0 if OtherCoop ==0
replace CountRed =CountRed[_n-1]+(type==2) if CountRed ==.&Period >1
 * replace CountRed = CountRed[_n-1]+(type==2) if CountRed ==0&Period >1&OtherCoop[_n-1]!=0
gen Lag1=CountRed==1&type ==2
gen Lag2=CountRed==2&type ==2
replace CountRed = CountRed[_n-1]+(type==2) if CountRed ==0&Period >1&CountRed[_n-1]<2
replace CountRed = CountRed[_n-1]+(type==2) if Period >1&CountRed[_n-1]<2
replace Lag2=1 if CountRed==2&type ==2

keep if type == 2

*Table 7 

probit Coop TICKET lagduration cycle2-cycle5 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2 & Period==1, cluster(session)
probit Coop TICKET lagduration cycle2-cycle5 periods* grimtrigger Lag1 Lag2 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2, cluster(session)

save DatCC1, replace


