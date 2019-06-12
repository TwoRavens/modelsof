use "L:\barthmoene\AJPS FINAL SUBMISSION FILES\political reinforcement replication data_Main.dta", clear
xtset countrynumber year

*table 1
xtreg welfareleft ld9d1 lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq , fe cluster(countrynumber)
xtreg welfareright ld9d1 lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg welfareright ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq , fe cluster(countrynumber)
gen sample = 1 if e(sample)==1

*table 2
xtreg mgenelno welfareleft trend trendsq if sample==1 & gov_left>0, fe cluster(countrynumber)
xtreg muegenelno welfareleft trend trendsq if sample==1 & gov_left>0, fe cluster(countrynumber)
xtreg msickgenelno welfareleft trend trendsq if sample==1 & gov_left>0, fe cluster(countrynumber)
xtreg mpengenelno welfareleft trend trendsq if sample==1 & gov_left>0, fe cluster(countrynumber)

*table 3
clear
use "L:\barthmoene\AJPS FINAL SUBMISSION FILES\political reinforcement replication data_Table3.dta"
xtreg unemp p9010 module_2, fe cluster(ccode)
xtreg health p9010 module_2, fe cluster(ccode)
xtreg pension p9010 module_2, fe cluster(ccode)

*table 4
use "L:\barthmoene\AJPS FINAL SUBMISSION FILES\political reinforcement replication data_Main.dta", clear
xtset countrynumber year
xtivreg2 welfareleft lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq  (ld9d1= l2ip_adjcov5 l2ip_enucfs), fe first cluster(countrynumber)
xtivreg2 welfareright lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq   (ld9d1= l2ip_adjcov5 l2ip_enucfs), fe first cluster(countrynumber)

*table A4
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq lmaj_left, fe cluster(countrynumber)
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq loverallgenerosity, fe cluster(countrynumber)
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq lue, fe cluster(countrynumber)
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq llnforeignpop, fe cluster(countrynumber)
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq lvturn, fe cluster(countrynumber)
xtreg welfareleft ld9d1 ld9010Xmaj lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq leffpar_leg , fe cluster(countrynumber)

*table A5
xtreg welfareleft lwelfareleft_cf ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg welfareleft ld9d5 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg welfareleft lwelfareleft_cf ld9d5 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg welfareleft ld5d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg welfareleft lwelfareleft_cf ld5d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)
xtreg myrl3left lmyrl3left_cf ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq, fe cluster(countrynumber)

*table a6
areg welfareleft  ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq [aweight=1/welfareSEleft], absorb(countrynumber) cluster(countrynumber)
areg welfareright ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq  [aweight=1/welfareSEright], absorb(countrynumber) cluster(countrynumber)

*table a7
xtreg welfareleft ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq lsocdemXtrend lconsXtrend  , fe cluster(countrynumber)
test lsocdemXtrend lconsXtrend
xtreg welfareright ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq lsocdemXtrend lconsXtrend , fe cluster(countrynumber)
test lsocdemXtrend lconsXtrend

*table a8
use "L:\barthmoene\AJPS FINAL SUBMISSION FILES\political reinforcement replication data_TableA8.dta", clear
xtset countrynumber year
xtreg rightscore_left d9d1 ud median_cf vturn d9d1vturn echp net annual, fe cluster(countrynumber)
xtreg rightscore_left d9d1 ud median_cf vturn d9d1vturn echp net annual trend trendsq, fe cluster(countrynumber)

use "L:\barthmoene\AJPS FINAL SUBMISSION FILES\political reinforcement replication data_Main.dta", clear
xtset countrynumber year
xtreg welfareright ld9d1 lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq , fe cluster(countrynumber)
gen sample = 1 if e(sample)==1

*table a9
xtreg pactneg lip_adjcov5 lip_enucfs lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq if sample==1 , fe cluster(countrynumber)
xtreg pactsign lip_adjcov5 lip_enucfs lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq if sample==1, fe cluster(countrynumber)
xtreg ri lip_adjcov5 lip_enucfs lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq if sample==1, fe cluster(countrynumber)

*table a10
xtivreg2 welfareleft lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq  (fd9d1= fip_adjcov5 fip_enucfs), fe cluster(countrynumber)
xtivreg2 welfareright lgdpgr lelderly llntexp lud ludsq lechp lnet lannual ltrend ltrendsq  (fd9d1= fip_adjcov5 fip_enucfs), fe cluster(countrynumber)


