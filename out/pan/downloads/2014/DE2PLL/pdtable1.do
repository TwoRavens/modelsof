clear
clear matrix
log using /users/jjacksn/documents/pathdep/conference/pdtable1.log, replace
use  /users/jjacksn/documents/pathdep/conference/pdfinal/pdtable1
replace y = . if[y==0]
replace y0 = . if[y0 == 0]
gen sample = country != 4 & country != 7 & country != 11 & country != 13 & country != 15
replace y = y/100
replace y0 = y0/100
gen y1 = y[_n-1]
gen y2 = y1[_n-1]
replace y2 = y1 if[year == 1961]
gen aussie = country == 1
gen aust = country == 2
gen canada = country == 3
gen denmark = country == 4
gen finland = country == 5
gen france = country == 6
gen germany = country == 7
gen iceland = country == 8
gen ireland = country == 9
gen japan = country == 10
gen nz = country == 11
gen norway = country == 12
gen portugal = country == 13
gen spain = country == 14
gen sweden = country == 15
gen uk = country == 16
gen us = country == 17
gen t1 = (year - 1961)/10
gen t11 = t1[_n-1]
gen t2 = (year - 1961)/10
gen t21 = t2[_n-1]
replace t11 = 0 if[year < 1962]
replace t21 = 0 if[year < 1962]
gen y0lt = y0 * log(t1)
gen y0lt1 = y0lt[_n-1]
replace y0lt = y0 if[y0lt==.]
replace y0lt1 = y0 if[y0lt1 == .]

nl (y = {d1}*aussie +{d2}*aust+{d3}*canada+{d5}*finland+{d6}*france+{d8}*iceland+{d9}*ireland+{d10}*japan+{d12}*norway+{d14}*spain+{d16}*uk+{d17}*us + ((1-{a2=.14}) + {a2=.14}*exp({a3=-2.3}*t1))*y1 + (1 - ((1-{a2=.14}) + {a2=.14}*exp({a3=-2.3}*t1)))*({b1=.4} + {b2=.7}*exp({b3=-.004}*t2)*y0) - {d=.13}*(y1-({b1=.4} + {b2=.7}*exp({b3=-.004}*t2)*y0 )) +{d=.13}*((1-{a2=.14}) + {a2=.14}*exp({a3=-2.3}*t11))*(y2-({b1=.4} + {b2=.7}*exp({b3=-.004}*t21)*y0))) if[year > 1960 & sample == 1], nolog vce(hc3)
display e(ll)

nl (y = {d1}*aussie +{d2}*aust+{d3}*canada+{d5}*finland+{d6}*france+{d8}*iceland+{d9}*ireland+{d10}*japan+{d12}*norway+{d14}*spain+{d16}*uk+{d17}*us + ((1-{a2=.16}) + {a2=.16}*exp({a3=-1.8}*t1))*y1 + (1 - ((1-{a2=.16}) + {a2=.16}*exp({a3=-1.8}*t1)))*({b1=.5} + ({b2=.54}+{b2us=-.95}*us)*exp({b3=-.006}*t2)*y0) - {d=.13}*(y1-({b1=.5} + ({b2=.54}+{b2us=-.95}*us)*exp({b3=-.006}*t2)*y0 )) +{d=.13}*((1-{a2=.16}) + {a2=.16}*exp({a3=-1.8}*t11))*(y2-({b1=.5} + ({b2=.54}+{b2us=-.95}*us)*exp({b3=-.006}*t21)*y0))) if[year > 1960 & sample == 1], nolog vce(hc3)
display e(ll)

nl (y = {d1}*aussie +{d2}*aust+{d3}*canada+{d5}*finland+{d6}*france+{d8}*iceland+{d9}*ireland+{d10}*japan+{d12}*norway+{d14}*spain+{d16}*uk+{d17}*us + ((1-{a2=.16}) + {a2=.16}*exp({a3=-1.8}*t1))*y1 + (1 - ((1-{a2=.16}) + {a2=1.8}*exp({a3=-.16}*t1)))*({b1=.5} + {b1us}*us + ({b2=.54}+{b2us=-.95}*us)*exp({b3=-.006}*t2)*y0) - {d=.13}*(y1-({b1=.5} + {b1us}*us + ({b2=.54}+{b2us=-.95}*us)*exp({b3=-.006}*t2)*y0 )) +{d=.13}*((1-{a2=.16}) + {a2=.16}*exp({a3=-1.8}*t11))*(y2-({b1=.5} + {b1us}*us + ({b2=.54}+{b2us=-.95}*us)*exp({b3=-.006}*t21)*y0))) if[year > 1960 & sample == 1], nolog vce(hc3)
display e(ll)
log close
ext

