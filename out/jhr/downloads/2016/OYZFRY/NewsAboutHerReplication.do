

*created on November 19, 2015 for News About Her Replication
version 14.1
set linesize 80
set scheme s2color
use "NewsAboutHer", clear

*For Table 2
ologit WECON WECON_tm1  freemedia xconst cedaw inttot civtot lnrgdpe_pc  lnpop chgenpct  isgenpct higenpct norelpct if year<1996 , cluster(ccode) 
ologit WECON WECON_tm1  freemedia internetusers  xconst cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)
ologit WECON WECON_tm1  i.freemedia##c.internetusers  xconst cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)

************Table 3 Average Marginal effects of non-interactive variables*********
ologit WECON WECON_tm1  i.freemedia##c.internetusers  xconst i.cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)
mchange xconst civtot isgenpct, amount(sd) brief

************Interaction of Internet and MF on WECON Graph***********
ologit WECON WECON_tm1  i.freemedia##c.internetusers  xconst cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)
margins  freemedi, at( internetusers=(0(1)100)) predict(outcome(3))
marginsplot, xlabel(0(10)100) ylabel(0(.1).5) recast(line) recastci(rarea) 

*For Table 4
ologit WOPOL WOPOL_tm1  freemedia xconst cedaw inttot civtot lnrgdpe_pc  lnpop chgenpct  isgenpct  higenpct norelpct if year<1996, cluster(ccode)
ologit WOPOL WOPOL_tm1  freemedia internetusers  xconst cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)
ologit WOPOL WOPOL_tm1  i.freemedia##c.internetusers  xconst cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)

*************Table 5 Average Marginal Effects of non-interactive variables************
ologit WOPOL WOPOL_tm1  i.freemedia##c.internetusers  xconst i.cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)
mchange WOPOL_tm1 cedaw chgenpct isgenpct

************Interaction of Internet and MF on WOPOL Graph
ologit WOPOL WOPOL_tm1  i.freemedia##c.internetusers  xconst cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct , cluster(ccode)
margins  freemedia, at( internetusers=(0(1)100)) predict(outcome(3))
marginsplot, xlabel(0(10)100) ylabel(0(.2)1) recast(line) recastci(rarea) 

*Table 6
ologit rPSW   freemedia  internetusers xconst cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct 
ologit rPSW   i.freemedia##c.internetusers xconst  cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct 

*Table 7 Average Marginal Effects
ologit rPSW   i.freemedia##c.internetusers xconst  cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct 
mchange xconst civtot

ologit rPSW   i.freemedia##c.internetusers xconst  cedaw inttot civtot   lnpop chgenpct  isgenpct  higenpct norelpct 
margins  freemedia, at( internetusers=(0(1)100)) predict(outcome(3))
marginsplot, xlabel(0(10)100) ylabel(0(.2)1) recast(line) recastci(rarea) 


