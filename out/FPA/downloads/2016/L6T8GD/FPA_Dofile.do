/*Use NGOData_01012013 Data*/

/*Basic Test Table 2*/

xtreg leadaid ngo, fe
estimates store model1
xtreg leadaid ngo polity lngdp lnpop morin ally, fe
estimates store model2
xtreg leadaid ngo, re
estimates store model3
xtreg leadaid ngo polity lngdp lnpop morin ally america europe africa middle asia , re
estimates store model4
xttobit leadaid ngo polity lngdp lnpop morin ally, re ll(0)
estimates store model5
xttobit leadaid ngo polity lngdp lnpop morin ally america europe africa middle asia , re ll(0)
estimates store model6

esttab model1 model2 model3 model4 model5 model6 using table2, replace se star(* 0.05 ** 0.01 *** 0.001) nogaps nodep nolines 

xtreg leadaid ngotime, fe
estimates store model1
xtreg leadaid ngotime polity lngdp lnpop morin ally, fe
estimates store model2
xtreg leadaid ngotime, re
estimates store model3
xtreg leadaid ngotime polity lngdp lnpop morin ally america europe africa middle asia , re
estimates store model4
xttobit leadaid ngotime polity lngdp lnpop morin ally, re ll(0)
estimates store model5
xttobit leadaid ngotime polity lngdp lnpop morin ally america europe africa middle asia , re ll(0)
estimates store model6

esttab model1 model2 model3 model4 model5 model6 using table3, replace se star(* 0.05 ** 0.01 *** 0.001) nogaps nodep nolines 

xtreg leadaid wngo, fe
estimates store model1
xtreg leadaid wngo polity lngdp lnpop morin ally, fe
estimates store model2
xtreg leadaid wngo, re
estimates store model3
xtreg leadaid wngo polity lngdp lnpop morin ally america europe africa middle asia , re
estimates store model4
xttobit leadaid wngo polity lngdp lnpop morin ally, re ll(0)
estimates store model5
xttobit leadaid wngo polity lngdp lnpop morin ally america europe africa middle asia , re ll(0)
estimates store model6

esttab model1 model2 model3 model4 model5 model6 using tabel4, replace se star(* 0.05 ** 0.01 *** 0.001) nogaps nodep nolines


