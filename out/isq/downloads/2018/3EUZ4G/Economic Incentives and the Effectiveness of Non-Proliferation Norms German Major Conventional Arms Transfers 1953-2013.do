********************************************************************************
******************************ANALYSIS*****************************************
********************************************************************************

*** Table 3 *** 
********************************************************************************
*** 1990-2013 post cold war period *********************************************
********************************************************************************

*** log-log-linear Heckman Model static (this one was used in Paper)

heckman lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if year>1989, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Modelle1990-2013.xls,append ctitle(Log-Log-Linear Heckman static) label dec(3)

********************************************************************************
*** 1953-1989 Cold-War Period **************************************************
********************************************************************************

*** log-log-linear Heckman Model static ***

heckman lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if year<1990, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Modelle1953-1989.xls,append ctitle(Log-Log-Linear Heckman static) label dec(3)

********************************************************************************
*** 1953-2013 Whole Period Models **********************************************
********************************************************************************

*** log-log-linear Heckman Model static ***

heckman lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Modelle1953-2013.xls,append ctitle(Log-Log-Linear Heckman static) label dec(3)


***Robustness Check Models ***
********************************************************************************
********** Robustness Check Models 1990-2013 Table A4 **************************
********************************************************************************

*** Pooled separated dynamic Models ***

*** Probit ***

probit decision lagdecision c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number if year>1989, vce(cluster country)
outreg2 using Modelle1990-2013.xls,append ctitle(pooled dynamic probit) label dec(3)

*** Pooled Regression ***

regress lnexporte lnpex lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if year>1989 & dec==1, vce(cluster country)
outreg2 using Modelle1990-2013.xls,append ctitle(pooled dynamic regression) label dec(3)

*** Heckman manually no-LDV Models ***

xtprobit dec c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner gdp_brd  milex_brd lr i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereignyears if year>1989, re
outreg2 using Modelle1990-2013.xls,append ctitle(xtprobit manual Heckman) label dec(3)

predict prob1989 if year>1989,xb
gen phi1989=(1/sqrt(2*_pi))*exp(-(prob1989^2/2)) if year>1989
gen capphi1989=normal(prob1989) if year>1989
gen invmills1989=phi1989/capphi1989 if year>1989

xtreg lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign invmills1989 if year>1989 & decision==1, re
outreg2 using Modelle1990-2013.xls,append ctitle(xtreg RE manual Heckman) label dec(3)

xtreg lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign invmills1989 if year>1989 & decision==1, fe
outreg2 using Modelle1990-2013.xls,append ctitle(xtreg FE manual Heckman) label dec(3)

*** Fixed Effects separated models ***

xtlogit dec c.counter##c.counter##c.counter lagdec lngdp_1000 polity_2 dist_100 partner gdp_brd  milex_brd lr embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereignyears if year>1989, fe
outreg2 using Modelle1990-2013.xls,append ctitle(xtlogit fe) label dec(3)

xtreg lnexporte lnpex lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if year>1989 & decision==1, fe
outreg2 using Modelle1990-2013.xls,append ctitle(xtreg fe) label dec(3)

********************************************************************************
*** Robustness Check Models 1953-1989 Table A4 *********************************
********************************************************************************

*** Pooled separated dynamic Models ***

*** Probit ***

probit decision lagdecision c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number if year<1990, vce(cluster country)
outreg2 using Modelle1953-1989.xls,append ctitle(pooled dynamic probit) label dec(3)

*** Pooled Regression ***

regress lnexporte lnpex lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if year<1990 & dec==1, vce(cluster country)
outreg2 using Modelle1953-1989.xls,append ctitle(pooled dynamic regression) label dec(3)

*** Heckman manually no-LDV Models ***

xtprobit dec c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner gdp_brd  milex_brd lr embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereignyears if year<1990, re
outreg2 using Modelle1953-1989.xls,append ctitle(xtprobit manual Heckman) label dec(3)

predict prob if year<1990,xb
gen phi=(1/sqrt(2*_pi))*exp(-(prob^2/2)) if year<1990
gen capphi=normal(prob) if year<1990
gen invmills=phi/capphi if year<1990

xtreg lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign invmills if year<1990 & decision==1, re
outreg2 using Modelle1953-1989.xls,append ctitle(xtreg RE manual Heckman) label dec(3)

xtreg lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign invmills if year<1990 & decision==1, fe
outreg2 using Modelle1953-1989.xls,append ctitle(xtreg FE manual Heckman) label dec(3)

*** Fixed Effects ***

xtlogit dec c.counter##c.counter##c.counter lagdec lngdp_1000 polity_2 dist_100 partner gdp_brd  milex_brd lr embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereignyears if year<1990, fe
outreg2 using Modelle1953-1989.xls,append ctitle(xtlogit fe) label dec(3)

xtreg lnexporte lnpex lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if year<1990 & decision==1, fe
outreg2 using Modelle1953-1989.xls,append ctitle(xtreg fe) label dec(3)

********************************************************************************
*** Robustness Check Models 1953-2013 Table A4 *********************************
********************************************************************************

*** Pooled separated dynamic Models ***

*** Probit ***

probit decision lagdecision c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number, vce(cluster country)
outreg2 using Modelle1953-2013.xls,append ctitle(pooled dynamic probit) label dec(3)

*** Pooled Regression ***

regress lnexporte lnpex lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if dec==1, vce(cluster country)
outreg2 using Modelle1953-2013.xls,append ctitle(pooled dynamic regression) label dec(3)

*** Heckman manually no-LDV Models ***

xtprobit dec c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner gdp_brd  milex_brd lr embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereignyears, re
outreg2 using Modelle1953-2013.xls,append ctitle(xtprobit manual Heckman) label dec(3)

predict proball,xb
gen phiall=(1/sqrt(2*_pi))*exp(-(proball^2/2))
gen capphi1all=normal(proball)
gen invmillsall=phiall/capphi1all

xtreg lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign invmillsall if decision==1, re
outreg2 using Modelle1953-2013.xls,append ctitle(xtreg RE manual Heckman) label dec(3)

xtreg lnexporte lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign invmillsall if decision==1, fe
outreg2 using Modelle1953-2013.xls,append ctitle(xtreg FE manual Heckman) label dec(3)

*** Fixed Effects ***

xtlogit dec c.counter##c.counter##c.counter lagdec lngdp_1000 polity_2 dist_100 partner gdp_brd  milex_brd lr embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereignyears, fe
outreg2 using Modelle1953-2013.xls,append ctitle(xtlogit fe) label dec(3)

xtreg lnexporte lnpex lngdp_1000 polity_2 dist_100 partner gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy number souvereign if decision==1, fe
outreg2 using Modelle1953-2013.xls,append ctitle(xtreg fe) label dec(3)

********************************************************************************
********************* Figure 3 *************************************************
********************************************************************************

*** Figure 3 is based on the spmap-ado ***

*** 1953-1989 ***

spmap exports_1989 using worldcoor.dta if admin!="Antarctica", id(id) fcolor(Greys) clnumber(13) legend(symy(*2) symx(*2) size(*2)) legorder(lohi)

*** 1990-2013 ***

spmap exports_2013 using worldcoor.dta if admin!="Antarctica", id(id) fcolor(Greys) clnumber(13) legend(symy(*2) symx(*2) size(*2)) legorder(lohi)


********************************************************************************
********************* Figure 4 *************************************************
********************************************************************************

heckman lnexporte lngdp_1000 polity_2 dist_100 milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi c.dummy##c.dummy##c.dummy number souvereign if year>1989, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
sum lngdp
margins, predict(psel) at(lngdp_1000=(-1.6(0.5)3.76))
marginsplot
gr save 1

heckman lnexporte lngdp_1000 polity_2 dist_100 milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi c.dummy##c.dummy##c.dummy number souvereign if year<1990, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd embargo c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
margins, predict(psel) at(lngdp_1000=(-1.6(0.5)3.76))
marginsplot
gr save 2

graph combine 1.gph 2.gph

********************************************************************************
******************** Table A3 Online supplementary *****************************
********************************************************************************

***prior 1966 first principle***

heckman lnexporte lngdp_1000 polity_2 dist_100 milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi c.dummy##c.dummy##c.dummy number souvereign if year<1966, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Final.xls,append ctitle(ante 1966) label dec(3)

***post 1966 first principle***

heckman lnexporte lngdp_1000 polity_2 dist_100 milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi c.dummy##c.dummy##c.dummy number souvereign if year>1966, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Final.xls,append ctitle(post 1966) label dec(3)

***post 1972 second principle***

heckman lnexporte lngdp_1000 polity_2 dist_100 milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi c.dummy##c.dummy##c.dummy number souvereign if year>1972, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Final.xls,append ctitle(post 1972) label dec(3)

***post 1982 third principle***

heckman lnexporte lngdp_1000 polity_2 dist_100 milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi c.dummy##c.dummy##c.dummy number souvereign if year>1982, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Final.xls,append ctitle(post 1982) label dec(3)

***post 2000 fourth principle***

heckman lnexporte lngdp_1000 polity_2 dist_100 milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi c.dummy##c.dummy##c.dummy number souvereign if year>2000, select (decision= c.counter##c.counter##c.counter lngdp_1000 polity_2 dist_100 partner lr gdp_brd milex_brd i.multi c.cinc##c.cinc totint toteth totciv2 boarders total_r israel saudi oil c.dummy##c.dummy##c.dummy souvereign number) vce(cluster country)
outreg2 using Final.xls,append ctitle(post 2000) label dec(3)

********************************************************************************
*********************************END********************************************
********************************************************************************
