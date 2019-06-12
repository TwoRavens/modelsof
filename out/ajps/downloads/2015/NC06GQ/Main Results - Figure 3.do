
** Note: This file provides the code to generate the results reported in Figure 3 from our paper. 
** The estimates produced by this file are turned into a graph by using "r". 
** The actual Figure 3 can be reproduced by using the file "Main Resutls - Figure 3.R".



****
** Main Results - Figure 3
***

*1) political parties
clear
use m.vote.dta
ologit elecsd i.polpart lngdp lnpop polity2 civilwar injud iswar INGO_uia i.year, cluster(country)
margins polpart, pr(out(0))
margins polpart, pr(out(2))
margins, dydx(polpart) pr(out(2))
margins, dydx(polpart) pr(out(0))

*2) worker
clear
use m.worker.dta
ologit worker i.tradeun_strike lngdp lnpop polity2 civilwar injud iswar INGO_uia i.year, cluster(country)
margins tradeun_strike, pr(out(0))
margins tradeun_strike, pr(out(2))
margins, dydx(tradeun_strike) pr(out(2))
margins, dydx(tradeun_strike) pr(out(0))


*3) Assembly
clear
use m.assem.dta
ologit assn i.assem_assoc lngdp lnpop polity2 civilwar injud iswar INGO_uia i.year, cluster(country)
margins assem_assoc, pr(out(0))
margins assem_assoc, pr(out(2))
margins, dydx(assem_assoc) pr(out(2))
margins, dydx(assem_assoc) pr(out(0))

*4) Religion
clear
use m.rel.dta
ologit relfre i.relig polity2 lngdp lnpop iswar civilwar injud INGO_uia i.year, cluster(country)
margins relig, pr(out(0))
margins relig, pr(out(2))
margins, dydx(relig) pr(out(2))
margins, dydx(relig) pr(out(0))
