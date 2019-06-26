*JPR DO FILE: PEKSEN, DURSUN "FOREIGN MILITARY INTERVENTION AND WOMEN'S RIGHTS"

* Model 1 - Women's Political Rights
ologit wopol lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay  lgdppclog lpolity2 laglntrade  lpricwar meastnafrica lwopol1 lwopol2 lwopol3, nolog robust cluster(ccode)

* Model 2 - Women's Economic Rights
ologit wecon lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay  lgdppclog lpolity2 laglntrade lpricwar  meastnafrica lwecon1 lwecon2 lwecon3, nolog robust cluster(ccode)

* Model 3 - Women's Social Rights
ologit wosoc lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay lgdppclog lpolity2 laglntrade lpricwar meastnafrica  lwosoc1 lwosoc2 lwosoc3, nolog robust cluster(ccode)


* Web Appendix
* Model - Women's Political Rights (Developing Countries)
ologit wopol lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay  lgdppclog lpolity2 laglntrade  lpricwar meastnafrica lwopol1 lwopol2 lwopol3 if developed==0, nolog robust cluster(ccode)
* Model - Women's Political Rights (Non-Democracies)
ologit wopol lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay  lgdppclog lpolity2 laglntrade  lpricwar meastnafrica lwopol1 lwopol2 lwopol3 if polity2<8, nolog robust cluster(ccode)

* Model - Women's Economic Rights (Developing Countries)
ologit wecon lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay  lgdppclog lpolity2 laglntrade lpricwar  meastnafrica lwecon1 lwecon2 lwecon3 if developed==0, nolog robust cluster(ccode)
* Model - Women's Economic Rights (Non-Democracies)
ologit wecon lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay  lgdppclog lpolity2 laglntrade lpricwar  meastnafrica lwecon1 lwecon2 lwecon3 if polity2<8, nolog robust cluster(ccode)

* Model - Women's Social Rights (Developing Countries)
ologit wosoc lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay lgdppclog lpolity2 laglntrade lpricwar meastnafrica  lwosoc1 lwosoc2 lwosoc3 if developed==0, nolog robust cluster(ccode)
* Model - Women's Social Rights (Non-Democracies)
ologit wosoc lnonUSunionset lagnonusenyenidecay lusonset lusonsetdecay liosupponset liosuppdecay lgdppclog lpolity2 laglntrade lpricwar meastnafrica  lwosoc1 lwosoc2 lwosoc3 if polity2<8, nolog robust cluster(ccode)
