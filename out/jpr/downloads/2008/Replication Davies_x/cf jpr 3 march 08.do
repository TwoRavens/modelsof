tsset id year,yearly




***Table III

***1
reg clinef inflpost y1-y29, robust

***2
reg clinef inflpost war postwar y1-y29, robust

***3
reg clinef inflpost war postwar gdpgrowth inflation dollar invest aid lagcline lnpci y1-y29, robust

***4
reg clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagcline laglnpci y1-y29, robust 

***5
reg clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagaid lagcline y1-y29, robust 

***6
reg clinef first5infl last5infl war postwar gdpgrowth inflation lagdollar invest aid lnpci lagcline y1-y29, robust 

***7
reg clinef first5infl last5infl war postwar lgdpg laginfl lagdollar laginvest lagcline lnpci y1-y29, robust 


***8
reg clinef linflpost war postwar lagdollar lgdpg laginfl laginvest lagaid y1-y29, robust 





*** Wooldridge test for first order autocorrelation: Table III, models 1-7

***1
xtserial clinef inflpost y1-y29

***2
xtserial clinef inflpost war postwar y1-y29

***3
xtserial clinef inflpost war postwar gdpgrowth inflation dollar invest aid lagcline lnpci y1-y29

***4
xtserial clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagcline laglnpci y1-y29

***5
xtserial clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagaid lagcline y1-y29

***6
xtserial clinef first5infl last5infl war postwar gdpgrowth inflation lagdollar invest aid lnpci lagcline y1-y29

***7
xtserial clinef first5infl last5infl war postwar lgdpg laginfl lagdollar laginvest lagcline lnpci y1-y29




***Table IV
***1
xtgls clinef inflpost war postwar gdpgrowth inflation dollar invest aid lagcline lnpci y1-y29, c(psar1) force


***2
xtgls clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagcline laglnpci y1-y29, c(psar1) force 


***3
xtgls clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagaid lagcline y1-y29, c(psar1) force 

***4
xtgls clinef first5infl last5infl war postwar gdpgrowth inflation lagdollar invest aid lnpci lagcline y1-y29, c(psar1) force 

***5
xtgls clinef first5infl last5infl war postwar lgdpg laginfl lagdollar laginvest lagcline lnpci y1-y29, c(psar1) force 

***6
xtgls clinef linflpost war postwar lagdollar lgdpg laginfl laginvest lagaid y1-y29, c(psar1) force 





***Table V

***1
xtreg clinef inflpost y1-y29, i(id) fe robust

***2
xtreg clinef inflpost war postwar y1-y29, i(id) fe robust

***3
xtreg clinef inflpost war postwar gdpgrowth inflation dollar invest aid lagcline lnpci y1-y29, i(id) fe robust

***4
xtreg clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagcline laglnpci y1-y29, i(id) fe robust 

***5
xtreg clinef inflpost war postwar lgdpg laginfl lagdollar laginvest lagaid lagcline y1-y29, i(id) fe robust 

***6
xtreg clinef first5infl last5infl war postwar gdpgrowth inflation lagdollar invest aid lnpci lagcline y1-y29, i(id) fe robust 

***7
xtreg clinef first5infl last5infl war postwar lgdpg laginfl lagdollar laginvest lagcline lnpci y1-y29, i(id) fe robust 

***8
xtreg clinef linflpost war postwar lagdollar lgdpg laginfl  laginvest  lagaid y1-y29, i(id) fe robust 






****Appendix IIIa  



***3
reg wbresf inflpost war postwar gdpgrowth inflation dollar invest aid lagwbres lnpci y1-y29, robust

reg morganf inflpost war postwar gdpgrowth inflation dollar invest aid lagmorgan lnpci y1-y29, robust

reg dooleyf inflpost war postwar gdpgrowth inflation dollar invest aid lagdooley lnpci y1-y29, robust

xtgls wbresf inflpost war postwar gdpgrowth inflation dollar invest aid lagwbres lnpci y1-y29, c(psar1) force

xtgls morganf inflpost war postwar gdpgrowth inflation dollar invest aid lagmorgan lnpci y1-y29, c(psar1) force

xtgls dooleyf inflpost war postwar gdpgrowth inflation dollar invest aid lagdooley lnpci y1-y29, c(psar1) force

xtreg wbresf inflpost war postwar gdpgrowth inflation dollar invest aid lagwbres lnpci y1-y29, i(id) fe robust

xtreg morganf inflpost war postwar gdpgrowth inflation dollar invest aid lagmorgan lnpci y1-y29, i(id) fe robust

xtreg dooleyf inflpost war postwar gdpgrowth inflation dollar invest aid lagdooley lnpci y1-y29, i(id) fe robust




****Appendix IIIb


reg wbresf inflpost war postwar lgdpg laginfl lagdollar laginvest lagwbres laglnpci y1-y29, robust 

reg morganf inflpost war postwar lgdpg laginfl lagdollar laginvest lagmorgan laglnpci y1-y29, robust 


reg dooleyf inflpost war postwar lgdpg laginfl lagdollar laginvest lagdooley laglnpci y1-y29, robust 


xtgls wbresf inflpost war postwar lgdpg laginfl lagdollar laginvest lagwbres laglnpci y1-y29, c(psar1) force 


xtgls morganf inflpost war postwar lgdpg laginfl lagdollar laginvest lagmorgan laglnpci y1-y29, c(psar1) force 

xtgls dooleyf inflpost war postwar lgdpg laginfl lagdollar laginvest lagdooley laglnpci y1-y29, c(psar1) force 


xtreg wbresf inflpost war postwar lgdpg laginfl lagdollar laginvest lagwbres laglnpci y1-y29, i(id) fe robust 

xtreg morganf inflpost war postwar lgdpg laginfl lagdollar laginvest lagmorgan laglnpci y1-y29, i(id) fe robust 

xtreg dooleyf inflpost war postwar lgdpg laginfl lagdollar laginvest lagdooley laglnpci y1-y29, i(id) fe robust 









