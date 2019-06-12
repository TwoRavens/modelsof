 /*Testing the effects of globalization on small arms imports_International Interactions 2009_de Soysa, Jackson & Ormhaug paper*/

use cti2, replace

/*regression of trade dependence on small arms imports per capita*/

xi: newey tot8pc lntrade tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
outreg using table1.rtf , nolabel 3aster replace 
mfx
mfx, at(lntrade = 5.6)
mfx, at (democ_dummy = 1)
mfx, at (civil_war = 0)


xi: newey tot8pc lnexportgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
outreg using table1.rtf , nolabel 3aster append 
mfx
mfx, at (lnexportgdp = 4.9)

xi: newey tot8pc lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
outreg using table1.rtf , nolabel 3aster append 
mfx
mfx, at(lnfdikgdp = 5.0)

xi: newey tot8pc ief tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
outreg using table1.rtf , nolabel 3aster append 
mfx
mfx, at (ief = 8.9)


**************Extending the Economic Freedom analyses *********************

xi: newey tot8pc ief lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
outreg using table2.rtf , nolabel 3aster replace
 xi: newey tot8pc  milexpgdp milpers ief lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
outreg using table2.rtf , nolabel 3aster append

xi: newey tot8pc ipcoc ief lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
outreg using table2.rtf , nolabel 3aster append


*************************Sensitivity & Robustness Checks***************************


******only LDCs
xi: newey tot8pc lntrade tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year if ldcs==1, force lag(1)
xi: newey tot8pc lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year if ldcs==1, force lag(1)
xi: newey tot8pc ief tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year if ldcs==1, force lag(1)

********other robustness checks
xi: newey tot8pc  inafrme issafrica iasia ilatam ieeurop lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
xi: newey tot8pc  ipoil inafrme issafrica iasia ilatam ieeurop lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
xi: newey tot8pc  imuslim ipoil inafrme issafrica iasia ilatam ieeurop lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
xi: newey tot8pc  lnmidist_usa lnmidist_bel inafrme issafrica iasia ilatam ieeurop lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
xi: newey tot8pc  avgpol lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)
xi: newey tot8pc  africons lntrade lnfdikgdp tot8exppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year, force lag(1)

******************ONLY HANDGUNS********************************
xi: newey hgimppc lntrade hgexppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year if ldcs==1, force lag(1)
outreg using table3.rtf , nolabel 3aster replace
xi: newey hgimppc lnfdikgdp hgexppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year if ldcs==1, force lag(1)
outreg using table3.rtf , nolabel 3aster append
xi: newey hgimppc ief hgexppc lngdppc growth lnpop democ_dummy civil_war civpeaceyrs interstate_war intpeaceyrs i.year if ldcs==1, force lag(1)
outreg using table3.rtf , nolabel 3aster append

exit
