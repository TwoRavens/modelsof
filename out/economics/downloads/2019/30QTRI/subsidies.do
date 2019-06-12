xtset code year

"Results in table 2 to table 4"
xthreg interd1 hhi1 logassets1 logsales1 salesgrow1 debtratio1, rx(logsubsidy1) qx(hhi1) thnum(2) bs(300 250) trim(0.005 0.005) grid(100)
xthreg exterd1 hhi1 logassets1 logsales1 salesgrow1 debtratio1, rx(logsubsidy1) qx(hhi1) thnum(2) bs(300 300) trim(0.005 0.005) grid(100)
xthreg interd1 indusmargin1 logassets1 logsales1 salesgrow1 debtratio1, rx(logsubsidy1) qx(indusmargin1) thnum(2) bs(300 300) trim(0.01 0.01) grid(100)
xthreg exterd1 indusmargin1 logassets1 logsales1 salesgrow1 debtratio1, rx(logsubsidy1) qx(indusmargin1) thnum(2) bs(300 300) trim(0.01 0.01) grid(100)

_matplot e(LR21), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("First Threshold") recast(line)
_matplot e(LR22), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("Second Threshold") recast(line)



"Results in table 5"
xthreg interd1 hhi1 logassets1 logsales1 salesgrow1 debtratio1, rx(ivmean1) qx(hhi1) thnum(2) bs(300 300) trim(0.005 0.005) grid(100)
xthreg exterd1 hhi1 logassets1 logsales1 salesgrow1 debtratio1, rx(ivmean1) qx(hhi1) thnum(2) bs(300 300) trim(0.005 0.005) grid(100)
xthreg interd1 indusmargin1 logassets1 logsales1 salesgrow1 debtratio1 , rx(ivmean1) qx(indusmargin1) thnum(2) bs(300 300) trim(0.01 0.01) grid(100)
xthreg exterd1 indusmargin1 logassets1 logsales1 salesgrow1 debtratio1 , rx(ivmean1) qx(indusmargin1) thnum(2) bs(300 300) trim(0.01 0.01) grid(100)


"Results in table 6"
xthreg interd1 hhi1 logassets1 logsales1 salesgrow1 debtratio1, rx(l.logsubsidy1) qx(hhi1) thnum(2) bs(300 300) trim(0.005 0.005) grid(100)
xthreg exterd1 hhi1 logassets1 logsales1 salesgrow1 debtratio1, rx(l.logsubsidy1) qx(hhi1) thnum(2) bs(300 300) trim(0.005 0.005) grid(100)
xthreg interd1 indusmargin1 logassets1 logsales1 salesgrow1 debtratio1, rx(l.logsubsidy1) qx(indusmargin1) thnum(2) bs(300 300) trim(0.01 0.01) grid(100)
xthreg exterd1 indusmargin1 logassets1 logsales1 salesgrow1 debtratio1, rx(l.logsubsidy1) qx(indusmargin1) thnum(2) bs(300 300) trim(0.01 0.01) grid(100)

