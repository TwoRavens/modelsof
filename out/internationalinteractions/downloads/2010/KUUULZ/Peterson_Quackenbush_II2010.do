***Peterson and Quackenbush: "Not all Peace Years are Created Equal: Trade, Imposed Settlements, and Military Conflict" replication data
**inquiries can be emailed to Tim Peterson: tmp2q2@mail.missouri.edu


*note: these replication models include corrections for violations of the proportional hazards assumption

*Table 1
use ".../rep_data_all_mids.dta"
**Model 1
stcox imposed lowerdep lowerdepxdurmo higherdep interdep bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo strival if unclearsettle==0, cluster(dyadid) nohr
**Model 2
stcox imposeedep imposerdep imp_interdep bothdem2 bothdem2xdurmo imp_relpow imp_relpowdif lndist strival if imposed==1, cluster(dyadid) nohr
**Model 3
stcox lowerdep higherdep interdep bothdem2 relpow relpowdif relpowdifxdurmo lndist strival if negot==1, cluster(dyadid) nohr 
**Model 4
stcox lowerdep lowerdepxdurmo higherdep interdep bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo strival if none==1, cluster(dyadid) nohr

*Table 2
use ".../rep_data_use_of_force.dta"
**Model 5
stcox imposed lowerdep lowerdepxdurmo higherdep interdep interdepxdurmo bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo strival if unclearsettle==0, cluster(dyadid) nohr
**Model 6
stcox imposeedep imposerdep imp_interdep bothdem2 imp_relpow imprpxdurmo imp_relpowdif lndist strival if imposed==1, cluster(dyadid) nohr
**Model 7
stcox lowerdep lowerdepxdurmo higherdep interdep interdepxdurmo bothdem2 relpow relpowdif lndist lndistxdurmo strival if negot==1, cluster(dyadid) nohr 
**Model 8
stcox lowerdep higherdep interdep bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo strival if none==1, cluster(dyadid) nohr 



****all three figures are from model 6

stcurve, at1(imposeedep=.0255377 imposerdep=.0106842 imp_interdep=.00027285) at2(imposeedep=0 imposerdep= .0106842 imp_interdep=0) at3(imposeedep=.0814653 imposerdep=.0106842 imp_interdep=.00087039) surv range(0 900) xtitle(Time in months) title(Survival of peace by recipient trade) legend(label(1 "recipient trade/GDP at mean") label(2 "recipient trade/GDP at zero") label(3 "recipient trade at mean+1sd")) lpattern(shortdash solid longdash) scheme(s2manual)

stcurve, at1(imposeedep=.0255377 imposerdep=.0106842 imp_interdep=.00027285) at2(imposeedep=.0255377 imposerdep=0 imp_interdep=0) at3(imposeedep=.0255377 imposerdep=.0354165  imp_interdep=.00090446) surv range(0 900) xtitle(Time in months) title(Survival of peace by imposee trade dependence) legend(label(1 "imposer trade/GDP at mean") label(2 "imposer trade/GDP at zero") label(3 "imposer trade/GDP at mean+1sd")) lpattern(shortdash solid longdash) scheme(s2manual)

stcurve, at1(imposeedep=.0255377 imposerdep=.0106842 imp_interdep=.00027285) at2(imposeedep=0 imposerdep=0 imp_interdep=0) at3(imposeedep= .0814653 imposerdep=.0354165 imp_interdep=.00288522) surv range(0 900) xtitle(Time in months) title(Survival of peace by trade) legend(label(1 "trade/GDP at mean") label(2 "trade/GDP at zero") label(3 "trade at mean+1sd")) lpattern(shortdash solid longdash) scheme(s2manual)


***Alternate models including fatal dispute dummy variable
use ".../rep_data_all_mids.dta"
**alternate Model 1
stcox imposed lowerdep lowerdepxdurmo higherdep interdep bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo fatal strival if unclearsettle==0, cluster(dyadid) nohr
**alternate Model 2
stcox imposeedep imposerdep imp_interdep bothdem2 bothdem2xdurmo imp_relpow imp_relpowdif lndist fatal strival if imposed==1, cluster(dyadid) nohr
**alternate Model 3
stcox lowerdep higherdep interdep bothdem2 relpow relpowdif relpowdifxdurmo  lndist fatal strival if negot==1, cluster(dyadid) nohr
**alternate Model 4
stcox lowerdep lowerdepxdurmo higherdep interdep bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo fatal strival if none==1, cluster(dyadid) nohr


use ".../rep_data_use_of_force.dta"
**alternate Model 5
stcox imposed lowerdep higherdep interdep interdepxdurmo bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo fatal strival if unclearsettle==0, cluster(dyadid) nohr
**alternate Model 6
stcox imposeedep imposerdep imp_interdep bothdem2 imp_relpow imprpxdurmo imp_relpowdif lndist fatal strival if imposed==1, cluster(dyadid) nohr
**alternate Model 7
stcox lowerdep lowerdepxdurmo higherdep interdep interdepxdurmo bothdem2 relpow relpowdif lndist lndistxdurmo strival if negot==1, cluster(dyadid) nohr  
**alternate Model 8
stcox lowerdep higherdep interdep bothdem2 bothdem2xdurmo relpow relpowdif lndist lndistxdurmo strival if none==1, cluster(dyadid) nohr


******Robustness checks (all MIDs sample)******
use ".../rep_data_all_mids.dta"
***with tau b
stcox imposeedep imposerdep imp_interdep bothdem2 bothdem2xdurmo imp_relpow imp_relpowdif lndist tau_glob if imposed==1, cluster(dyadid) nohr
***with S score
stcox imposeedep imposerdep imp_interdep bothdem2 bothdem2xdurmo imp_relpow imp_relpowdif lndist s_wt_glo if imposed==1, cluster(dyadid) nohr

***simultaneous model for trade and conflict (note: CDSIMEQ is available for download [Keshk 2005])
cdsimeq (imp_interdep imposercap imposeecap bothdem2) (_d imposeedep imposerdep bothdem2 imp_relpow imp_relpowdif lndist strival) if imposed==1




