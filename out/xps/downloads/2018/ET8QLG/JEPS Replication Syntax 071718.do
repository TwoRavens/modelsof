*Panagopoulos and Bailey: Replication Syntax*

*Table 1*

oneway male treatment if north==1, tab scheffe
oneway male treatment if north==0, tab scheffe

*Table 2*

bys treatment: summ  voted_1114 if northampton==1

bys treatment: summ  voted_1114 if nazareth==1

bys treatment: summ  voted_1114 if homecounty_butnot_hometown==1

bys treatment: summ  voted_1114 if nazareth==1

bys treatment: summ  voted_1114 if northampton==0

bys treatment: summ  voted_1114 

*Table 3*

xi: reg  voted_1114 i.treatment if nazareth==1

xi: reg  voted_1114 i.treatment age male voted12 if nazareth==1

xi: reg  voted_1114 i.treatment if homecounty_butnot_hometown==1

xi: reg  voted_1114 i.treatment age male voted12 if homecounty_butnot_hometown==1 

xi: reg  voted_1114 i.treatment if northampton==1

xi: reg  voted_1114 i.treatment age male voted12 if northampton==1

xi: reg  voted_1114 i.treatment if northampton==0

xi: reg  voted_1114 i.treatment age male voted12 if northampton==0

xi: reg  voted_1114 i.treatment north  treat1Xnorth treat2Xnorth treat3Xnorth [aw=ipw]

xi: reg  voted_1114 i.treatment north  treat1Xnorth treat2Xnorth treat3Xnorth age male voted12 [aw=ipw]


