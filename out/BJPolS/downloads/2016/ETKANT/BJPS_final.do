
** Replication do file for Peterson, Murdie, and Asal: "Human Rights NGO Shaming and the Exports of Abusive States"
** Jan 19, 2016
** Please contact Timothy Peterson with any questions or comments: timothy.peterson@sc.edu



**********************
*** Primary Models ***
**********************

xtset dyad year

* Table 1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year if dyadsanct == 0, fe robust
est store m1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year, fe robust
est store m2
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year if c.abuse1 < 3 & dyadsanct == 0, fe robust
est store m3
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if c.abuse1 < 3, fe robust
est store m4
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year if c.abuse1 > 5 & c.abuse1 < . & dyadsanct == 0 , fe robust
est store m5
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if c.abuse1 > 5 & c.abuse1 < ., fe robust
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using Table1, word  bdec(3) alpha(0.001, 0.01, 0.05)

* Table 2
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno thirdsanctdum i.year if dyadsanct == 0, re robust
est store m1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno dyadsanct thirdsanctdum i.year, re robust
est store m2
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno thirdsanctdum i.year if dyadsanct == 0 & abuse1 < 3, re robust
est store m3
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno dyadsanct thirdsanctdum i.year if abuse1 < 3, re robust
est store m4
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno thirdsanctdum i.year if dyadsanct == 0 & c.abuse1 > 5 & c.abuse1 < ., re robust
est store m5
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno dyadsanct thirdsanctdum i.year if c.abuse1 > 5 & c.abuse1 < ., re robust
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using Table2, word  bdec(3) alpha(0.001, 0.01, 0.05)



**************************
*** Substantive Values ***
**************************

* for figure
margins, dydx(abuse2) at(lngovnonpos = (0(.05)2.6) abuse1 = (0 4 8))

* 1 shaming event
disp ln(2)
lincom abuse2 + .69314718 * c.abuse2#c.lngovnonpos
disp 1-exp(-.0260245)

* 12 shaming events
disp ln(13)
lincom abuse2 + 2.5649494 * c.abuse2#c.lngovnonpos
disp 1-exp(-.0742194)



***********************
*** Appendix Models ***
***********************

* Table A1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 thirdsanctdum i.year if dyadsanct == 0, fe robust
est store m1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 dyadsanct thirdsanctdum i.year, fe robust
est store m2
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 thirdsanctdum i.year if c.abuse1 < 3 & dyadsanct == 0, fe robust
est store m3
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 dyadsanct thirdsanctdum i.year if c.abuse1 < 3, fe robust
est store m4
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 thirdsanctdum i.year if c.abuse1 > 5 & c.abuse1 < . & dyadsanct == 0 , fe robust
est store m5
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 dyadsanct thirdsanctdum i.year if c.abuse1 > 5 & c.abuse1 < ., fe robust
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using TableA1, word  bdec(3) alpha(0.001, 0.01, 0.05)

* Table A2
xtreg f.lnexp2to1 lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year if dyadsanct == 0, fe robust
est store m1
xtreg f.lnexp2to1 lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year, fe robust
est store m2
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno thirdsanctdum i.year c.wbgi_rle1##c.wbgi_rle2 if dyadsanct == 0, re robust
est store m3
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno dyadsanct thirdsanctdum i.year c.wbgi_rle1##c.wbgi_rle2, re robust
est store m4
xtreg f.lnexp2to1 c.totabuse2##c.lngovnonpos##c.totabuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year if dyadsanct == 0, fe robust
est store m5
xtreg f.lnexp2to1 c.totabuse2##c.lngovnonpos##c.totabuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year, fe robust
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using TableA2, word  bdec(3) alpha(0.001, 0.01, 0.05)

* Table A3
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno thirdsanctdum i.year lnarabrat if dyadsanct == 0, re robust
est store m1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno dyadsanct thirdsanctdum i.year lnarabrat, re robust
est store m2
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno thirdsanctdum i.year lnarabrat lnpoprat lncaprat if dyadsanct == 0, re robust
est store m3
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno dyadsanct thirdsanctdum i.year lnarabrat lnpoprat lncaprat, re robust
est store m4
outreg2 [m1 m2 m3 m4] using TableA3, word  bdec(3) alpha(0.001, 0.01, 0.05)

* Table A4
xtreg f.lnexp2to1_imp c.lngovnonpos lnother thirdsanctdum i.year if dyadsanct == 0, fe robust
est store ma1
xtreg f.lnexp2to1_imp c.lngovnonpos lnother dyadsanct thirdsanctdum i.year, fe robust
est store ma2
xtreg f.lnexp2to1_imp c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year if dyadsanct == 0, fe robust
est store ma3
xtreg f.lnexp2to1_imp c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year, fe robust
est store ma4
outreg2 [ma1 ma2 ma3 ma4] using TableA4, word  bdec(3) alpha(0.001, 0.01, 0.05)

* Table A5
xtreg f.lnexp2to1 lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if abuse1 <3 & abuse2 > 5 & abuse2 <. , fe robust
est store m1
xtreg f.lnexp2to1 lngovnonpos lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if abuse1 > 5 & abuse1 < . & abuse2 > 5 & abuse2 <. , fe robust
est store m2
xtreg f.lnexp2to1 abuse2 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if abuse1 <3 & lngovnonpos <0.087 , fe robust
est store m3
xtreg f.lnexp2to1 abuse2 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if abuse1 <3 & lngovnonpos >=0.087 , fe robust
est store m4
xtreg f.lnexp2to1 abuse2 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if abuse1 > 5 & abuse1 < . & lngovnonpos <0.087 , fe robust
est store m5
xtreg f.lnexp2to1 abuse2 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if abuse1 > 5 & abuse1 < . & lngovnonpos >=0.087 , fe robust
est store m6
outreg2 [m1 m2 m3 m4 m5 m6] using TableA5, word  bdec(3) alpha(0.001, 0.01, 0.05)

* Table A6
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year PTAdum if dyadsanct == 0, fe robust
est store ma1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year PTAdum, fe robust
est store ma2
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno thirdsanctdum i.year PTAdum defense if dyadsanct == 0, re robust
est store ma3
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 lndist contig comlang_ethno dyadsanct thirdsanctdum i.year PTAdum defense, re robust
est store ma4
outreg2 [ma1 ma2 ma3 ma4] using TableA6, word  bdec(3) alpha(0.001, 0.01, 0.05)

* Table A8
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 thirdsanctdum i.year if gle_cgdpc1 <= 25702.36 & p_polity21 < 7 & dyadsanct == 0, fe robust
est store m1
xtreg f.lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother c.lngdp1 c.lngdp2 lnpop1 lnpop2 dyadsanct thirdsanctdum i.year if gle_cgdpc1 <= 25702.36 & p_polity21 < 7, fe robust
est store m2
xtabond2 f.lnexp2to1 lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother lngdp1 lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 thirdsanctdum comlang_ethno lndist contig i.year if dyadsanct == 0, gmm(lnexp2to1 c.abuse2 c.lngovnonpos c.abuse1 lngdp1 lngdp2 c.lnpolity1##c.lnpolity2 thirdsanctdum, lag(0 2) ) iv(lnpop1 lnpop2 lndist contig i.year comlang_ethno) twostep
est store m3
xtabond2 f.lnexp2to1 lnexp2to1 c.abuse2##c.lngovnonpos##c.abuse1 lnother lngdp1 lngdp2 lnpop1 lnpop2 c.lnpolity1##c.lnpolity2 dyadsanct thirdsanctdum comlang_ethno lndist contig i.year , gmm(lnexp2to1 c.abuse2 c.lngovnonpos c.abuse1 lngdp1 lngdp2 c.lnpolity1##c.lnpolity2 dyadsanct thirdsanctdum, lag(0 2) ) iv(lnpop1 lnpop2 lndist contig i.year comlang_ethno) twostep
est store m4
outreg2 [m1 m2 m3 m4 ] using TableA8, word  bdec(3) alpha(0.001, 0.01, 0.05)



****************************************
*** Recoding data for monadic models ***
****************************************

gen contiggdp = gle_gdp1 if contig == 1
gen contigpop = gle_pop1 if contig == 1
gen contigpolity = lnpolity1 if contig == 1


gen gdpltd = gle_gdp1 if dist < 7907
gen popltd = gle_pop1 if dist < 7907
gen polltd = lnpolity1 if dist < 7907

bysort ccode2 year: egen totflow1 = sum(flow1)
bysort ccode2 year: egen totptadyads = sum(PTAdum)
bysort ccode2 year: egen totsanctions = sum(dyadsanct)
bysort ccode2 year: egen borders = sum(contig)
bysort ccode2 year: egen countlang = sum(comlang_ethno)

bysort ccode2 year: egen totgdpltd = sum(gdpltd)
bysort ccode2 year: egen totpopltd = sum(popltd)
bysort ccode2 year: egen avpolltd = mean(polltd)

sort ccode2 year
drop if ccode2==ccode2[_n-1] & year==year[_n-1]

gen lntotexp2 = ln(((totflow1/divide)*1000)+1)
gen lngdpltd = ln(totgdpltd)
gen lnpopltd = ln(totpopltd)

xtset ccode2 year

* Table A7
xtreg f.lntotexp2 c.abuse2##c.lngovnonpos lnother c.lngdp2 lngdpltd lnpop2 lnpopltd  year, fe robust
est store mm1
xtreg f.lntotexp2 c.abuse2##c.lngovnonpos lnother c.lngdp2 lngdpltd lnpop2 lnpopltd countlang totptadyads totsanctions border c.lnpolity2##c.avpolltd year, re robust
est store mm2

outreg2 [mm1 mm2] using TableA7, word  bdec(3) alpha(0.01, 0.05, 0.1)







