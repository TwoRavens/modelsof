
set more off

use "ai/rawdata/ron/RONrrhrd8_isq.dta", clear
** Notes: 
** 1. I can't find one of their "UIA number of NGOs" variable
** 2. This doesn't converge
*xtgee ainr sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , family(nbinomial) link(identity) corr(unstructured) i(country) t(year) robust


xtset country year
xtnbreg ainr sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


** add in ratification dates by hand
** Standardizing the country names was going to be a huge hassle

gen catrat = .
*edit  country iso year catrat

** entered by hand using this data: "ai/rawdata/ratification dates/CATratdates.csv"

replace catrat = 1 in 83
replace catrat = 1 in 91
replace catrat = 1 in 113
replace catrat = 1 in 124
replace catrat = 1 in 137
replace catrat = 1 in 161
replace catrat = 1 in 193
replace catrat = 1 in 208
replace catrat = 1 in 227
replace catrat = 1 in 254
replace catrat = 1 in 256
replace catrat = 1 in 277
replace catrat = 1 in 314
replace catrat = 1 in 323
replace catrat = 1 in 345
replace catrat = 1 in 349
replace catrat = 1 in 376
replace catrat = 1 in 404
replace catrat = 1 in 413
replace catrat = 1 in 427
replace catrat = 1 in 436
replace catrat = 1 in 452
replace catrat = 1 in 472
replace catrat = 1 in 505
replace catrat = 1 in 513
replace catrat = 1 in 528
replace catrat = 1 in 542
replace catrat = 1 in 555
replace catrat = . in 555
replace catrat = 1 in 570
replace catrat = 1 in 593
replace catrat = 1 in 610
replace catrat = 1 in 622
replace catrat = 1 in 640
replace catrat = 1 in 651
replace catrat = 1 in 668
replace catrat = 1 in 581
replace catrat = 1 in 707
replace catrat = 1 in 768
replace catrat = 1 in 781
replace catrat = 1 in 806
replace catrat = 1 in 846
replace catrat = 1 in 864
replace catrat = 1 in 889
replace catrat = 1 in 901
replace catrat = 1 in 930
replace catrat = 1 in 954
replace catrat = 1 in 965
replace catrat = 1 in 990
replace catrat = 1 in 993
replace catrat = 1 in 1025
replace catrat = 1 in 1039
replace catrat = 1 in 1065
replace catrat = 1 in 1068
replace catrat = 1 in 1106
replace catrat = 1 in 1112
replace catrat = 1 in 1136
replace catrat = 1 in 1152
replace catrat = 1 in 1168
replace catrat = 1 in 1221
replace catrat = 1 in 1234
replace catrat = 1 in 1274
replace catrat = 1 in 1281
replace catrat = 1 in 1303
replace catrat = 1 in 1317
replace catrat = 1 in 1346
replace catrat = 1 in 1362
replace catrat = 1 in 1387
replace catrat = 1 in 1410
replace catrat = 1 in 1444
replace catrat = 1 in 1460
replace catrat = 1 in 1481
replace catrat = 1 in 1487
replace catrat = 1 in 1526
replace catrat = 1 in 1574
replace catrat = 1 in 1580
replace catrat = 1 in 1627
replace catrat = 1 in 1636
replace catrat = 1 in 1671
replace catrat = 1 in 1703
replace catrat = 1 in 1724
replace catrat = 1 in 1749
replace catrat = 1 in 1776
replace catrat = 1 in 1788
replace catrat = 1 in 1804
replace catrat = 1 in 1843
replace catrat = 1 in 1861
replace catrat = 1 in 1922
replace catrat = 1 in 1955
replace catrat = 1 in 1968
replace catrat = 1 in 1981
replace catrat = 1 in 1999
replace catrat = 1 in 2014
replace catrat = 1 in 2040
replace catrat = 1 in 2050
replace catrat = 1 in 2065
replace catrat = 1 in 2075
replace catrat = 1 in 2087
replace catrat = 1 in 2205
replace catrat = 1 in 2217
replace catrat = 1 in 2236
replace catrat = 1 in 2221
replace catrat = . in 2236
replace catrat = 1 in 2242
replace catrat = 1 in 2288
replace catrat = 1 in 2303
replace catrat = 1 in 2330
replace catrat = 1 in 2353
replace catrat = 1 in 2357
replace catrat = 1 in 2379
replace catrat = 1 in 2386
replace catrat = 1 in 2431
replace catrat = 1 in 2470
replace catrat = 1 in 2499
replace catrat = 1 in 2507
replace catrat = 1 in 2553
replace catrat = 1 in 2568
replace catrat = 1 in 2594
replace catrat = 1 in 2596
replace catrat = 1 in 2612
replace catrat = 1 in 2643
replace catrat = 1 in 2679
replace catrat = 1 in 2686
replace catrat = 1 in 2710
replace catrat = 1 in 2736
replace catrat = 1 in 2803

replace catrat=0 if catrat==.

xtset country year
xtnbreg ainr catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


** Now, add article 22 ratifications

gen art22rat = .
*edit  country iso year art22rat

replace art22rat = 1 in 34
replace art22rat = 1 in 254
replace art22rat = 1 in 314
replace art22rat = 1 in 323
replace art22rat = 1 in 349
replace art22rat = 1 in 376
replace art22rat = 1 in 413
replace art22rat = 1 in 452
replace art22rat = 1 in 513
replace art22rat = 1 in 651
replace art22rat = 1 in 668
replace art22rat = 1 in 768
replace art22rat = 1 in 889
replace art22rat = 1 in 954
replace art22rat = 1 in 965
replace art22rat = 1 in 990
replace art22rat = 1 in 993
replace art22rat = 1 in 1025
replace art22rat = 1 in 1136
replace art22rat = 1 in 1234
replace art22rat = 1 in 1303
replace art22rat = 1 in 1460
replace art22rat = 1 in 1487
replace art22rat = 1 in 1580
replace art22rat = 1 in 1636
replace art22rat = 1 in 1671
replace art22rat = 1 in 1703
replace art22rat = 1 in 1788
replace art22rat = 1 in 1804
replace art22rat = 1 in 1968
replace art22rat = 1 in 2014
replace art22rat = 1 in 2050
replace art22rat = 1 in 2087
replace art22rat = 1 in 2222
replace art22rat = . in 2222
replace art22rat = 1 in 2221
replace art22rat = 1 in 2242
replace art22rat = 1 in 2288
replace art22rat = 1 in 2303
replace art22rat = 1 in 2353
replace art22rat = 1 in 2357
replace art22rat = 1 in 2568

replace art22rat=0 if art22rat==.


gen iccprrat = .
*edit  country iso year iccprrat

replace iccprrat = 1 in 21
replace iccprrat = 1 in 34
replace iccprrat = 1 in 67
replace iccprrat = 1 in 91
replace iccprrat = 1 in 113
replace iccprrat = 1 in 157
replace iccprrat = 1 in 210
replace iccprrat = 1 in 266
replace iccprrat = 1 in 277
replace iccprrat = 1 in 323
replace iccprrat = 1 in 345
replace iccprrat = 1 in 352
replace iccprrat = 1 in 404
replace iccprrat = 1 in 410
replace iccprrat = 1 in 427
replace iccprrat = 1 in 473
replace iccprrat = 1 in 505
replace iccprrat = 1 in 538
replace iccprrat = 1 in 607
replace iccprrat = 1 in 622
replace iccprrat = 1 in 668
replace iccprrat = 1 in 743
replace iccprrat = 1 in 812
replace iccprrat = 1 in 846
replace iccprrat = 1 in 863
replace iccprrat = 1 in 954
replace iccprrat = 1 in 990
replace iccprrat = 1 in 1002
replace iccprrat = 1 in 1011
replace iccprrat = 1 in 1027
replace iccprrat = 1 in 1065
replace iccprrat = 1 in 1086
replace iccprrat = 1 in 1107
replace iccprrat = 1 in 1204
replace iccprrat = 1 in 1221
replace iccprrat = 1 in 1346
replace iccprrat = 1 in 1359
replace iccprrat = 1 in 1380
replace iccprrat = 1 in 1387
replace iccprrat = 1 in 1417
replace iccprrat = 1 in 1468
replace iccprrat = 1 in 1476
replace iccprrat = 1 in 1523
replace iccprrat = 1 in 1580
replace iccprrat = 1 in 1677
replace iccprrat = 1 in 1718
replace iccprrat = 1 in 1749
replace iccprrat = 1 in 1776
replace iccprrat = 1 in 1831
replace iccprrat = 1 in 1853
replace iccprrat = 1 in 1957
replace iccprrat = 1 in 1981
replace iccprrat = 1 in 2045
replace iccprrat = 1 in 2063
replace iccprrat = 1 in 2200
replace iccprrat = 1 in 2242
replace iccprrat = 1 in 2261
replace iccprrat = 1 in 2288
replace iccprrat = 1 in 2302
replace iccprrat = 1 in 2330
replace iccprrat = 1 in 2353
replace iccprrat = 1 in 2386
replace iccprrat = 1 in 2474
replace iccprrat = 1 in 2486
replace iccprrat = 1 in 2499
replace iccprrat = 1 in 2592
replace iccprrat = 1 in 2605
replace iccprrat = 1 in 2677
replace iccprrat = 1 in 2710
replace iccprrat = 1 in 2811

replace iccprrat = 0 if iccprrat==.


gen op1rat = .
*edit  country iso year op1rat

replace op1rat = 1 in 34
replace op1rat = 1 in 67
replace op1rat = 1 in 91
replace op1rat = 1 in 113
replace op1rat = 1 in 126
replace op1rat = 1 in 137
replace op1rat = 1 in 232
replace op1rat = 1 in 249
replace op1rat = 1 in 277
replace op1rat = 1 in 325
replace op1rat = 1 in 382
replace op1rat = 1 in 404
replace op1rat = 1 in 480
replace op1rat = 1 in 520
replace op1rat = 1 in 505
replace op1rat = . in 520
replace op1rat = 1 in 517
replace op1rat = 1 in 612
replace op1rat = 1 in 625
replace op1rat = 1 in 652
replace op1rat = 1 in 668
replace op1rat = 1 in 805
replace op1rat = 1 in 812
replace op1rat = 1 in 846
replace op1rat = 1 in 933
replace op1rat = 1 in 969
replace op1rat = . in 969
replace op1rat = 1 in 954
replace op1rat = 1 in 968
replace op1rat = 1 in 990
replace op1rat = 1 in 1002
replace op1rat = 1 in 1035
replace op1rat = 1 in 1043
replace op1rat = 1 in 1079
replace op1rat = 1 in 1113
replace op1rat = 1 in 1204
replace op1rat = 1 in 1359
replace op1rat = 1 in 1389
replace op1rat = 1 in 1425
replace op1rat = 1 in 1444
replace op1rat = 1 in 1468
replace op1rat = 1 in 1476
replace op1rat = 1 in 1526
replace op1rat = 1 in 1580
replace op1rat = 1 in 1686
replace op1rat = 1 in 1749
replace op1rat = 1 in 1776
replace op1rat = 1 in 1804
replace op1rat = 1 in 1831
replace op1rat = 1 in 1960
replace op1rat = 1 in 1984
replace op1rat = 1 in 2001
replace op1rat = 1 in 2045
replace op1rat = 1 in 2078
replace op1rat = 1 in 2091
replace op1rat = 1 in 2242
replace op1rat = 1 in 2261
replace op1rat = 1 in 2288
replace op1rat = 1 in 2303
replace op1rat = 1 in 2330
replace op1rat = 1 in 2382
replace op1rat = 1 in 2474
replace op1rat = 1 in 2499
replace op1rat = 1 in 2508
replace op1rat = 1 in 2592
replace op1rat = 1 in 2605
replace op1rat = 1 in 2616
replace op1rat = 1 in 2710

replace op1rat = 0 if op1rat == .


xtset country year
** just the year of
xtnbreg ainr art22rat catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
** just the year after
xtnbreg ainr l.art22rat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
** both the year of and the year after
xtnbreg ainr art22rat l.art22rat catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


** all the treaties entered together
xtnbreg ainr art22rat l.art22rat catrat l.catrat iccprrat l.iccprrat op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr art22rat l.art22rat catrat l.catrat iccprrat l.iccprrat op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , fe

** combining the ai report types
gen allai =  ainr +  aibr
xtnbreg allai art22rat l.art22rat catrat l.catrat iccprrat l.iccprrat op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

** no lags
xtnbreg allai art22rat catrat iccprrat op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr art22rat catrat iccprrat op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr art22rat catrat iccprrat op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


** each treaty one at a time because they might confound each other
xtnbreg ainr art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


xtnbreg aibr art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


** Make a unified ratification variable
gen allrat = iccprrat + op1rat + catrat + art22rat
tab allrat
replace allrat = 1 if allrat > 1

** model with the unified ratification variable
xtnbreg ainr allrat l.allrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr allrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr l.allrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

xtnbreg aibr allrat l.allrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr allrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr l.allrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


** look only at those with bad human rights
xtnbreg ainr allrat l.allrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if sdpts>=4, re

** bad human rights with all treaties
xtnbreg ainr art22rat l.art22rat catrat l.catrat iccprrat l.iccprrat op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if sdpts>=4, re


*********************************************
** THESE ARE THE MODELS I REPORT in the paper

** each treaty one at a time because they might confound each other
xtnbreg allai art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

xtnbreg ainr art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


xtnbreg aibr art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re


** 29 April 2012
capture mkdir "ai/results"
log using "ai/results/log 29apr2012.smcl", replace
** Original models
xtnbreg allai iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

** all treaties in the same model
xtnbreg allai iccprrat l.iccprrat op1rat l.op1rat catrat l.catrat art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

** split up amnesty reports into news reports and briefs
xtnbreg ainr iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg ainr art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

xtnbreg aibr iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg aibr art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

** Look only at the year of
xtnbreg allai iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
xtnbreg allai art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re

** Fixed effects
xtnbreg allai iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , fe
xtnbreg allai op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , fe
xtnbreg allai catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , fe
xtnbreg allai art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , fe

** Only look at states that have a possibility of getting shamed
egen countrynum = group(country)
egen avgallai = mean(allai), by(countrynum)
sum avgallai if avgallai==0
sum avgallai if avgallai<1
sum avgallai, detail

xtnbreg allai iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<1, re
xtnbreg allai op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<1, re
xtnbreg allai catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<1, re
xtnbreg allai art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<1, re

xtnbreg allai iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<3, re
xtnbreg allai op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<3, re
xtnbreg allai catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<3, re
xtnbreg allai art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia if avgallai<3, re

 
log close


** Original models
xtnbreg allai iccprrat l.iccprrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
outreg2 using "ai/results/ai table.doc", word append

xtnbreg allai op1rat l.op1rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
outreg2 using "ai/results/ai table.doc", word append

xtnbreg allai catrat l.catrat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
outreg2 using "ai/results/ai table.doc", word append

xtnbreg allai art22rat l.art22rat sdpts polity4 conf pcntdth gdp milper pop usmlas oda avmdia , re
outreg2 using "ai/results/ai table.doc", word append


