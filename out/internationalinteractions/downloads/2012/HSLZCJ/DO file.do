set more off

*** provide labels ***

label var maj "Number of US majority-owned foreign affiliates operating in the host country"
label var lnpe "Investments in Fixed Assets by US firms (log)"
label var lnassets "Investments in Total Assets by US firms (log)"
label var lnincome "Total Income of US firms (log)"
label var polityiv "Polity IV Democracy Index (-10 to +10 scale)"
label var polcon3 "Political Constraints Index III (0 - 1 scale)"
label var polcon5 "Political Constraints Index V (0 - 1 scale)"
label var econ "Executive Constraints Index (1 to 7 scale)"
label var checksdpi "Checks and Balances Index of DPI (0 to 18 scale)"
label var lnpcgdp "Per capita GDP (log)"
label var lnpopulation "Total Population (log)"
label var ggdp "Rate of Growth of GDP"
label var lninfrastructure "Infrastructure (log)"
label var credit "Private Credit/GDP"
label var exch "Exchange Rate to US$"
label var oil "Oil exporting country (dummy)"
label var labour "Rate of Growth in Labour Force"
label var fdireforms "index of FDI policy reforms covering capital account convertibility, current account convertibility, existence of multiple exchange rates"
label var arc "conflicts intensity (0-5 scale)"
label var ngo "Count of Non-Governmental Organizations and Inter-Governmental Organizations"
label var ofrac "Opposition Fractionalization Index"


*** MANUAL IV APPROACH ***

** IV Poisson Models **

xtile u = polityiv, nq(3)
quietly tab u, gen(u_)
xi: oprobit u lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict q1 q2 q3, p
xi: nbreg maj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc q3 i.years
estimates store kc
outreg2 using "og", excel

xtile u2 = polcon3, nq(3)
quietly tab u2, gen(u2_)
xi: oprobit u2 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict q4 q5 q6, p
xi: nbreg maj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc q6 i.years
outreg2 using "og", excel

xtile u3 = polcon5, nq(3)
quietly tab u3, gen(u3_)
xi: oprobit u3 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict q7 q8 q9, p
xi: nbreg maj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc q9 i.years
outreg2 using "og", excel

xtile u4 = econ, nq(3)
quietly tab u4, gen(u4_)
xi: oprobit u4 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict q10 q11 q12, p
xi: nbreg maj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc q12 i.years
estimates store k
outreg2 using "ou", excel

xtile u5 = checksdpi, nq(3)
quietly tab u5, gen(u5_)
xi: oprobit u5 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict q13 q14 q15, p
xi: nbreg maj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc q15 i.years
outreg2 using "ou", excel

** Multi-Level Linear Mixed IV Models **

* Investments in Fixed Assets by US firms *

xtile y = polityiv, nq(3)
quietly tab y, gen(y_)
xi: oprobit y lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict p1 p2 p3, p
xi: xtmixed lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc p3 i.years || countries :
outreg2 using "og", excel

xtile y2 = polcon3, nq(3)
quietly tab y2, gen(y2_)
xi: oprobit y2 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict p4 p5 p6, p
xi: xtmixed lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc p6 i.years || countries :
outreg2 using "og", excel

xtile y3 = polcon5, nq(3)
quietly tab y3, gen(y3_)
xi: oprobit y3 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict p7 p8 p9, p
xi: xtmixed lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc p9 i.years || countries :
outreg2 using "og", excel

xtile y4 = econ, nq(3)
quietly tab y4, gen(y4_)
xi: oprobit y4 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict p10 p11 p12, p
xi: xtmixed lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc p12 i.years || countries :
outreg2 using "ou", excel

xtile y5 = checksdpi, nq(3)
quietly tab y5, gen(y5_)
xi: oprobit y5 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict p13 p14 p15, p
xi: xtmixed lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc p15 i.years || countries :
outreg2 using "ou", excel

* Investments in Total Assets by US firms *

xtile x1 = polityiv, nq(3)
quietly tab x1, gen(x1_)
xi: oprobit x1 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict a1 a2 a3, p
xi: xtmixed lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc a3 i.years || countries :
outreg2 using "og", excel

xtile x2 = polcon3, nq(3)
quietly tab x2, gen(x2_)
xi: oprobit x2 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict a4 a5 a6, p
xi: xtmixed lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc a6 i.years || countries :
outreg2 using "og", excel

xtile x3 = polcon5, nq(3)
quietly tab x3, gen(x3_)
xi: oprobit x3 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict a7 a8 a9, p
xi: xtmixed lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc a9 i.years || countries :
outreg2 using "og", excel

xtile x4 = econ, nq(3)
quietly tab x4, gen(x4_)
xi: oprobit x4 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict a10 a11 a12, p
xi: xtmixed lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc a12 i.years || countries :
outreg2 using "ou", excel

xtile x5 = checksdpi, nq(3)
quietly tab x5, gen(x5_)
xi: oprobit x5 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict a13 a14 a15, p
xi: xtmixed lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc a15 i.years || countries :
outreg2 using "ou", excel

* Total Income of US firms *

xtile z1 = polityiv, nq(3)
quietly tab z1, gen(z1_)
xi: oprobit z1 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict b1 b2 b3, p
xi: xtmixed lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc b3 i.years || countries :
outreg2 using "og", excel

xtile z2 = polcon3, nq(3)
quietly tab z2, gen(z2_)
xi: oprobit z2 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict b4 b5 b6, p
xi: xtmixed lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc b6 i.years || countries :
outreg2 using "og", excel

xtile z3 = polcon5, nq(3)
quietly tab z3, gen(z3_)
xi: oprobit z3 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict b7 b8 b9, p
xi: xtmixed lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc b9 i.years || countries :
outreg2 using "og", excel

xtile z4 = econ, nq(3)
quietly tab z4, gen(z4_)
xi: oprobit z4 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict b10 b11 b12, p
xi: xtmixed lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc b12 i.years || countries :
outreg2 using "ou", excel

xtile z5 = checksdpi, nq(3)
quietly tab z5, gen(z5_)
xi: oprobit z5 lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc ngo ofrac i.years
predict b13 b14 b15, p
xi: xtmixed lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc b15 i.years || countries :
outreg2 using "ou", excel


*** 2SLS-IV APPROACH ***

* US firms with majority equity share *

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), robust first
ivhettest, fitlev
estimates store kc
outreg2 using "op", excel

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), robust first
ivhettest, fitlev
estimates store k
outreg2 using "ot", excel

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "ot", excel

* Investments in Fixed Assets by US firms *

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "ot", excel

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "ot", excel

* Investments in Total Assets by US firms *

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "ot", excel

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "ot", excel

* Total Income of US firms *

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "op", excel

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "om", excel

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "ot", excel

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), robust first
ivhettest, fitlev
outreg2 using "ot", excel


*** OTHER TESTS ***

** Durbin-Wu-Hausman test **

* US firms with majority equity share *

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), first
ivendog polityiv

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), first
ivendog polcon3

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), first
ivendog polcon5

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), first
ivendog econ

xi: ivreg2 lnmaj lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), first
ivendog checksdpi

* Investments in Fixed Assets by US firms *

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), first
ivendog polityiv

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), first
ivendog polcon3

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), first
ivendog polcon5

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), first
ivendog econ

xi: ivreg2 lnpe lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), first
ivendog checksdpi

* Investments in Total Assets by US firms *

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), first
ivendog polityiv

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), first
ivendog polcon3

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), first
ivendog polcon5

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), first
ivendog econ

xi: ivreg2 lnassets lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), first
ivendog checksdpi

* Total Income of US firms *

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofrac), first
ivendog polityiv

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), first
ivendog polcon3

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon5 = ngo ofrac), first
ivendog polcon5

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), first
ivendog econ

xi: ivreg2 lnincome lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), first
ivendog checksdpi


*** ROBUSTNESS CHECKS: Value Added by US firms ***

* Total Value Added by US firms *

xi: ivreg2 lngva lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polityiv = ngo ofracn), robust first

xi: ivreg2 lngva lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (polcon3 = ngo ofrac), robust first

xi: ivreg2 lngva lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (econ = ngo ofrac), robust first

xi: ivreg2 lngva lnpcgdp lnpopulation ggdp lninfrastructure credit exch oil labour fdireforms arc i.year (checksdpi = ngo ofrac), robust first
