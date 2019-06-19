//This do file uses Stata 12. It replicates the tables in the paper "Asymmetric Information and Middleman Margins: An Experiment with Indian Potato Farmers" by Mitra, Mookherjee, 
//Torero and Visaria (2017).

set more off
cap log close
log using testingreplication.log, replace

*******************Table 1: Potato Cultivation & Sales by Sample Farmers, 2008
use analysisdata, clear

//Potato cultivation & allocation
tabstat Totarea Totharv Pctgs Pcths Pctcs Pctsp Qtysold Pctmkt Pctphmlda Totrev Netrev if utag_all==1, stats(mean semean) columns(statistics)

//The mandi price
use mandiprices, clear
collapse (mean) mandipx if (variety==1 | variety==2), by(mv_mktgroup year harvest)

tabstat mandipx if year==2008, statistics(mean semean)

******Row 1 in Table A1: Traders sold at
tabstat mandipx if year==2008, by(harvest) statistics(mean semean)

//The tracked price
use information2008data, clear
tabstat I2_wholeprice if (variety==1 | variety==2) & intvn==1, stats(mean semean)

*******************Table 2: Pass-through
use mandiprices, clear

collapse (count) numvillages=mzcode (mean) mandipx=mandipx farmgatepx=meanfarmgatepx retailpx=retailprice meanyield=meanyield retailprice market v_wagecashmale d=d dscode=dscode (sum) totarea=totarea tothhs=v_numofhhs totlandlinehhs=v_landlinehhs totcanals=v_numofcanals tottubewells=v_numoftubewells totpuccaroad=puccaroad totindmill=industrymill bank=bank, by(mv_mktgroup year week)

gen pctlandline=totlandlinehhs/tothhs
gen canalsphh=totcanals/tothhs
gen tubewellsphh=tottubewells/tothhs
gen puccaroadpv=totpuccaroad/numvillages
gen indmillpv=totindmill/numvillages
gen bankphh=bank/tothhs
gen medpur=(dscode==2)
gen dxretail=d*retailprice
gen totoutput=meanyield*totarea
replace meanyield=meanyield/1000
replace d=d/100

gen harvest=(week>0 & week<=12)
gen postharvearly=(week>12 & week<=26)
gen postharvlate=(week>26 & week<=52)

///Regressions for mandi price
areg mandipx retailprice meanyield pctlandline puccaroadpv indmillpv i.week i.year if harvest==0, absorb(mv_mktgroup) robust

areg mandipx retailprice i.week if year==2008 & harvest==0, absorb(mv_mktgroup) robust

//Regressions for farmgate price: this can only be run for 2008
areg farmgatepx retailprice meanyield i.week if harvest==0, absorb(mv_mktgroup) robust

//Regression for farmgate price on mandi price: this can only be run for 2008
areg farmgatepx mandipx meanyield i.week if harvest==0, absorb(mv_mktgroup) robust

*******************Table 3: Effect of Interventions on Farmers' Price Tracking Behavior & Precision
use information2008data, clear

rename i2_wholeprice trackedpx

gen nophonecontrol=(intvn==2 & phone==0)
replace nophonecontrol=. if (intvn==3 | phone==1)
gen withphonecontrol=(intvn==2 & phone==1)
replace withphonecontrol=. if (intvn==3 | (intvn==2 & phone==0))
gen withphonenophone=(phone==1)
replace withphonenophone=. if (intvn==1 | intvn==3)

gen sourceother=(sourceofinfo_whole==3)
replace sourceother=. if sourceofinfo_whole==.

*****Panel A: Effect of Information on Price Tracking
//Do you track wholesale prices?
logit i2_trackwhole int2 phone int3 own2008 i.variety medpur i.month if (variety==1 | variety==2) & uvmtag==1, or clus(mzid)

//Minimum number of days ago that the price was tracked
poisson minnumdays_whole int2 phone int3 own2008 i.variety medpur i.month if (variety==1 | variety==2) & uvmtag==1, irr clus(mzid)

//Who is your source of information?
logit sourceother int2 phone int3 own2008 i.variety medpur i.month if (variety==1 | variety==2) & uvmtag==1, or clus(mzid)

*****Panel B: Change in normalized error
//Normalized error in tracked price = (tracked price - mandi price)/mandi price. Test if error is lower for intervention farmers.
gen e=trackedpx-mandipx
gen norme=e/mandipx
gen normesq=norme^2

//Change in normalized error
tabstat normesq if (variety==1|variety==2) & uvmtag==1, stats(mean N) by(nophonecontrol) save
matrix S1=r(Stat1)
matrix S2=r(Stat2)
di S1[1,1]
di S2[1,1]
di S1[2,1]
di S2[2,1]
local f=S1[1,1]/S2[1,1]
di 1-F(S1[2,1]-1,S2[2,1]-1,`f')

//With phone v. control
tabstat normesq if (variety==1|variety==2) & uvmtag==1, stats(mean N) by(withphonecontrol) save
matrix S1=r(Stat1)
matrix S2=r(Stat2)
di S1[1,1]
di S2[1,1]
di S1[2,1]
di S2[2,1]
local f=S1[1,1]/S2[1,1]
di 1-F(S1[2,1]-1,S2[2,1]-1,`f')

//With phone v. without phone
tabstat normesq if (variety==1|variety==2) & uvmtag==1, stats(mean N) by(withphonenophone) save
matrix S1=r(Stat1)
matrix S2=r(Stat2)
di S1[1,1]
di S2[1,1]
di S1[2,1]
di S2[2,1]
local f=S1[1,1]/S2[1,1]
di 1-F(S1[2,1]-1,S2[2,1]-1,`f')

//Public information v. control
tabstat normesq if (variety==1|variety==2) & uvmtag==1, stats(mean N) by(villagecontrol) save
matrix S1=r(Stat1)
matrix S2=r(Stat2)
di S1[1,1]
di S2[1,1]
di S1[2,1]
di S2[2,1]
local f=S1[1,1]/S2[1,1]
di 1-F(S1[2,1]-1,S2[2,1]-1,`f')

//Public information v. private information
tabstat normesq if (variety==1|variety==2) & uvmtag==1, stats(mean N) by(villagemobile) save
matrix S1=r(Stat1)
matrix S2=r(Stat2)
di S1[1,1]
di S2[1,1]
di S1[2,1]
di S2[2,1]
local f=S1[1,1]/S2[1,1]
di 1-F(S1[2,1]-1,S2[2,1]-1,`f')

*******************Table 5: Average Effects
use analysisdata, clear

//Without mandi fixed effects: Quantity sold
reg Totsold int2 phone int3 own2008 i.variety i.quality medpur if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., clus(mzid)
summ Totsold if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. 
global SE_DV = r(sd)/sqrt(r(N))
di $SE_DV

//Without mandi fixed effects: Net price received
reg Netdiscprice int2 phone int3 own2008 i.variety i.quality medpur if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., clus(mzid)
summ Netdiscprice if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. 
global SE_DV = r(sd)/sqrt(r(N))
di $SE_DV

//With mandi fixed effects: Quantity sold
areg Totsold int2 phone int3 own2008 i.variety i.quality if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., absorb(mv_mktgroup) clus(mzid)
summ Totsold if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. 
global SE_DV = r(sd)/sqrt(r(N))
di $SE_DV

//With mandi fixed effects: Net price received
areg Netdiscprice int2 phone int3 own2008 i.variety i.quality if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., absorb(mv_mktgroup) clus(mzid)
summ Netdiscprice if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. 
global SE_DV = r(sd)/sqrt(r(N))
di $SE_DV


*******************Tables 6 & 7: Heterogenous Effects on Quantity Sold & Net Price Received. Also Appendix Table A4.
use analysisdata, clear

foreach v in Totsold Netdiscprice {
 //Column 1: Farmer-specific average of mandi price
 areg `v' Avgmktpr int2 int2avgmktpr phone phoneavgmktpr int3 int3avgmktpr own2008 i.variety i.quality if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., absorb(mv_mktgroup) clus(mzid)
 summ `v' if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. & Avgmktpr~=.
 global SE_DV = r(sd)/sqrt(r(N))
 di $SE_DV

 //Column 2: Weighted average of mandi price (using district weights)
 areg `v' Avgmktpr_district_08 int2 int2avgmktpr_district_08 phone phoneavgmktpr_district_08 int3 int3avgmktpr_district_08 own2008 i.variety i.quality if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., absorb(mv_mktgroup) clus(mzid)
 summ `v' if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. & Avgmktpr_district_08~=.
 global SE_DV = r(sd)/sqrt(r(N))
 di $SE_DV

 //Column 3: Farmer-specific average deviation of mandi price from expected price
 reg `v' Dev_mandipx int2 int2devmandipx phone phonedevmandipx int3 int3devmandipx own2008 medpur i.variety i.quality if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., vce(boot, cluster(mzid) reps(400) seed(2906))
 summ `v' if (int2==0 & int3==0) & Dev_mandipx~=.
 global SE_DV = r(sd)/sqrt(r(N))
 di $SE_DV

 //Column 4: Farmer-specific instrumented mandi price
 ivregress2 2sls `v' int2 phone int3 (Avgmktpr int2avgmktpr phoneavgmktpr int3avgmktpr = dxretail int2dxretail phonedxretail int3dxretail) own2008 i.variety i.quality i.mv_mktgroup if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., clus(mzid)
 summ `v' if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. & Avgmktpr~=.
 global SE_DV = r(sd)/sqrt(r(N))
 di $SE_DV

 //Column 5: Farmers with long-term relationships
 areg `v' Avgmktpr int2 phone int3 int2avgmktpr phoneavgmktpr int3avgmktpr own2008 i.quality if sellertolongbuyer==1 & (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., absorb(mv_mktgroup) clus(mzid)
 summ `v' if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. & Avgmktpr~=. & sellertolongbuyer==1
 global SE_DV = r(sd)/sqrt(r(N))
 di $SE_DV

 //Columns 1 & 2 in Table A4: Households not asked about price tracking
 areg `v' Avgmktpr int2 phone int3 int2avgmktpr phoneavgmktpr int3avgmktpr own2008 i.quality if askedi2==0 & (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., absorb(mv_mktgroup) clus(mzid)
 summ `v' if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=. & Avgmktpr~=. & askedi2==0
 global SE_DV = r(sd)/sqrt(r(N))
 di $SE_DV
}

 //Column 6 in Table 6: Fraction sold at harvest time
 areg c_pctqty_harvsold Avgmktpr_h int2 int2avgmktpr_h phone phoneavgmktpr_h int3 int3avgmktpr_h own2008 i.variety i.quality if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., absorb(mv_mktgroup) clus(mzid)
 summ c_pctqty_harvsold if (int2==0 & int3==0) & (variety==1|variety==2) & uvqtag==1 & Netpricercvd~=.
 global SE_DV = r(sd)/sqrt(r(N))
 di $SE_DV


*******************Table 8: Price Dispersion
use analysisdata, clear

//Measures of price dispersion within the village
egen netdiscpxsd=sd(Netdiscprice) if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., by(mzid)
gen netdiscpxvar=netdiscpxsd^2
egen netdiscpxmax=max(Netdiscprice) if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., by(mzid)
egen netdiscpxmin=min(Netdiscprice) if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., by(mzid)
gen netdiscpxmaxmin=abs(netdiscpxmax-netdiscpxmin)
gen Totdiscprice=Discpayrcvd/Totsold
egen totdiscpxsd=sd(Totdiscprice) if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., by(mzid)
gen totdiscpxvar=totdiscpxsd^2
egen totdiscpxmax=max(Totdiscprice) if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., by(mzid)
egen totdiscpxmin=min(Totdiscprice) if (variety==1 | variety==2) & uvqtag==1 & Netpricercvd~=., by(mzid)
gen totdiscpxmaxmin=abs(totdiscpxmax-totdiscpxmin)

//mzidtag variable
egen mzvtag=tag(mzid variety) if Netpricercvd~=. & (variety==1|variety==2) & uvqtag==1

***Within the village
//Column 1: variance of gross prices
reg totdiscpxvar int2 int3 i.variety if mzvtag==1, robust

//Column 2: range of gross prices
reg totdiscpxmaxmin int2 int3 i.variety if mzvtag==1, robust

//Column 3: variance of net prices
reg netdiscpxvar int2 int3 i.variety if mzvtag==1, robust

//Column 4: range of net prices
reg netdiscpxmaxmin int2 int3 i.variety if mzvtag==1, robust

***Across villages
use villagehaatpxdata, clear

//Compute dispersion measures by village-week only for villages that face multiple haats
//Identify the villages that face multiple haats
bys mzid variety weeksold: egen mktsd=sd(mkt)
keep if mktsd~=.

collapse (sd) haatpxsd=haatpx (min) haatpxmin=haatpx (max) haatpxmax=haatpx (mean) int2=int2 int3=int3 int1=int1, by(mzid variety weeksold)
gen haatpxvar=haatpxsd^2 
gen haatpxmaxmin=abs(haatpxmax-haatpxmin)
replace haatpxvar=0 if haatpxvar==. & haatpxmaxmin==0

//Column 5: variance of haat prices
areg haatpxvar int2 int3 i.variety, absorb(weeksold) clus(mzid)

//Column 6: range of haat prices
areg haatpxmaxmin int2 int3 i.variety, absorb(weeksold) clus(mzid)

 
*******************Figure 1: Intervention Impacts
use graphdata, clear
//Average across mandis
gen intvn=1 if int1==1
replace intvn=2 if int2==1
replace intvn=3 if int3==1

collapse (mean) farmgatepx_j mandipx_j kolpx_j bhupx_j farmgatepx_c mandipx_c kolpx_c bhupx_c farmgatepx_b mandipx_b kolpx_b bhupx_b, by(variety intvn weeksold)
twoway (scatter farmgatepx_b weeksold if intvn==1, scheme(s2mono) sort xline(12 26) xlabel(1 12 26 52, valuelabel) ytitle(Market price) xtitle(Week) connect(l)) (scatter farmgatepx_b weeksold if intvn==2, sort xline(12 26) connect(l)) (scatter farmgatepx_b weeksold if intvn==3, sort xline(12 26) connect(l)) (scatter mandipx_b weeksold, sort xline(12 26) connect(l)), title("Mandi prices & Farmer net prices by intervention, 2008") legend(on title(2008) rows(2) label(1 "Control") label(2 "Mobile") label(3 "Village") label(4 "Mandi price"))


*******************Appendix Table A1: Low Bounds on Average Middleman Margins
//Row 1: Price traders sold at: See above the code for Table 1

//Row 2: Price traders bought at
use analysisdata, clear
gen totpricercvd=totpayrcvd/qtysold

tabstat totprice if harvest==1 & soldtophmlda==1 & (variety==1 | variety==2), statistics (mean semean)
tabstat totprice if harvest==0 & soldtophmlda==1 & (variety==1 | variety==2), statistics (mean semean)

//Rows 4, 5 & 6: Unit costs
gen avgtrancost=trancost/qtysold
gen avghandcost=handcost/qtysold
gen avgstorcost=storcost/qtysold
gen avgothcost=othcost/qtysold

gen paidtran=(trancost~=0 & (soldtomarket==1 | soldtophmlda==1) & (variety==1 | variety==2))
gen paidhand=(handcost~=0 & (soldtomarket==1 | soldtophmlda==1) & (variety==1 | variety==2))
gen paidstor=(storcost~=0 & (soldtomarket==1 | soldtophmlda==1) & (variety==1 | variety==2))
gen paidoth=(othcost~=0 & (soldtomarket==1 | soldtophmlda==1) & (variety==1 | variety==2))

//Transport cost
summ avgtrancost if (variety==1 | variety==2) & soldtomarket==1 & paidtran==1 & harvest==1
local adj_avgtrancost=(round(r(mean),.01)/5)*8.5
di `adj_avgtrancost'

//Handling + Other costs: Harvest time
summ avghandcost if (variety==1 | variety==2) & soldtomarket==1 & paidhand==1 & harvest==1
local avghandcost=r(mean)
summ avgothcost if (variety==1 | variety==2) & soldtomarket==1 & paidoth==1 & harvest==1
local avgothcost=r(mean)
di round(`avghandcost' + `avgothcost', 0.01)

//Handling + Other costs: After harvest time
summ avghandcost if (variety==1 | variety==2) & soldtomarket==1 & paidhand==1 & harvest==0
local avghandcost=r(mean)
summ avgothcost if (variety==1 | variety==2) & soldtomarket==1 & paidoth==1 & harvest==0
local avgothcost=r(mean)
di round(`avghandcost' + `avgothcost', 0.01)

//Storage cost 
summ avgstorcost if soldtomarket==1 & (variety==1 | variety==2) & storcost~=0 
di round(r(mean),0.01)

*******************Appendix Table A2:
use descriptivesdata, clear

gen anycult=(numcult>0)
gen maxcultyears=maxculted if maxculted<=12
replace maxcultyears=13 if maxculted==13
replace maxcultyears=15 if maxculted==14
replace maxcultyears=16 if maxculted==15
replace maxcultyears=17 if maxculted==16
replace maxcultyears=14 if maxculted==17

estpost tabstat own2008 maxcultage maxcultyears anypotatoes anyjyoti anycmukhi areapotatoes2006 harvest2006 frachome2006 fracsold2006 price2006 fracphmlda2006 fracmkt2006 havelandline havecellphone asktrader onlytrader askmarket askfriends askmedia dontsearch, by(intvn) statistics(N mean semean) columns(statistics)

foreach v of varlist own2008 maxcultage maxcultyears anypotatoes anyjyoti anycmukhi areapotatoes2006 harvest2006 frachome2006 fracspoil2006 fracsold2006 price2006 fracphmlda2006 fracmkt2006 havelandline havecellphone asktrader onlytrader askmarket askfriends askmedia dontsearch {
 matrix `v'=J(1,2,0)
 qui reg `v' villagecontrol, clus(mzid)
 matrix `v'[1,1]=_b[villagecontrol]
 test villagecontrol
 matrix `v'[1,2]=r(p)
}
 
matrix allvc = own2008 \ maxcultage \ maxcultyears \ anypotatoes \ anyjyoti \ anycmukhi \ areapotatoes2006 \ harvest2006 \ frachome2006 \ fracsold2006 \ price2006 \ fracphmlda2006 \ fracmkt2006 \ havelandline \ havecellphone \ onlytrader \ asktrader \ askmarket \ askfriends \ askmedia \ dontsearch
matrix list allvc

foreach v of varlist own2008 maxcultage maxcultyears anypotatoes anyjyoti anycmukhi areapotatoes2006 harvest2006 frachome2006 fracspoil2006 fracsold2006 price2006 fracphmlda2006 fracmkt2006 havelandline havecellphone asktrader onlytrader askmarket askfriends askmedia dontsearch {
 matrix `v'=J(1,2,0)
 qui reg `v' mobilecontrol, clus(mzid)
 matrix `v'[1,1]=_b[mobilecontrol]
 test mobilecontrol
 matrix `v'[1,2]=r(p)
 }
 
matrix allmc = own2008 \ maxcultage \ maxcultyears \ anypotatoes \ anyjyoti \ anycmukhi \areapotatoes2006 \ harvest2006 \ frachome2006 \ fracsold2006 \ price2006 \ fracphmlda2006 \ fracmkt2006 \ havelandline \ havecellphone \ onlytrader \ asktrader \ askmarket \ askfriends \ askmedia \ dontsearch
matrix list allmc

foreach v of varlist own2008 maxcultage maxcultyears anypotatoes anyjyoti anycmukhi areapotatoes2006 harvest2006 frachome2006 fracsold2006 price2006 fracphmlda2006 fracmkt2006 havelandline havecellphone asktrader onlytrader askmarket askfriends askmedia dontsearch {
 matrix `v'=J(1,2,0)
 qui reg `v' villagemobile, clus(mzid)
 matrix `v'[1,1]=_b[villagemobile]
 test villagemobile
 matrix `v'[1,2]=r(p)
 }
 
matrix allvm = own2008 \ maxcultage \ maxcultyears \ anypotatoes \ anyjyoti \ anycmukhi \ areapotatoes2006 \ harvest2006 \ frachome2006 \ fracsold2006 \ price2006 \ fracphmlda2006 \ fracmkt2006 \ havelandline \ havecellphone \ onlytrader \ asktrader \ askmarket \ askfriends \ askmedia \ dontsearch
matrix list allvm

matrix all = allvc, allmc, allvm

logit villagecontrol own2008 maxcultage maxcultyears anypotatoes anyjyoti anycmukhi areapotatoes2006 harvest2006 fracsold2006 price2006 fracphmlda2006 havelandline havecellphone onlytrader askmarket askfriends, clus(mzid)
logit mobilecontrol own2008 maxcultage maxcultyears anypotatoes anyjyoti anycmukhi areapotatoes2006 harvest2006 fracsold2006 price2006 fracphmlda2006 havelandline havecellphone onlytrader askmarket askfriends, clus(mzid)
logit villagemobile own2008 maxcultage maxcultyears anypotatoes anyjyoti anycmukhi areapotatoes2006 harvest2006 fracsold2006 price2006 fracphmlda2006 havelandline havecellphone onlytrader askmarket askfriends, clus(mzid)

*******************Appendix Table A3:
use mandiprices_median, clear

foreach v of varlist d retailprice dxretail meanyield v_wagecashmale pctlandline tubewellspv canalspv puccaroadpv indmillpv bankpv {
ttest `v' if medpur==0, by(reltomedian)
}

foreach v of varlist d retailprice dxretail meanyield v_wagecashmale pctlandline tubewellspv canalspv puccaroadpv indmillpv bankpv {
ttest `v' if medpur==1, by(reltomedian)
}

*******************Appendix Table A4: See above the code for Tables 6 & 7
