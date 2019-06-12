*Analysis for "Do Democracies Spend Less?"
*ISQ, completed in January 2004.
*The commands in this file will replicate the analysis in the article.
*They should be run on the Stata file 'fwisq.dta'.

*Descriptive statistics for Table 1
tsset ccode year
xtsum milgdp polity bdthpct cwdthpct srivalcap allycap gdp emppop if year > 1949 & year < 1998
xtsum milgdpest milpct diehl polity bdthpct cwdthpct srivalcap allycap gdp tpop dsize emppop if year < 1998

*Models for Table 2 
*Post-1950 GDP data.
xtpcse milgdp polity bdthpct cwdthpct srivalcap allycap gdp emppop if year > 1949 & year < 1998, corr(ar1) pairwise

*Military personnel
xtpcse milpct polity bdthpct cwdthpct srivalcap allycap tpop emppop if year < 1998, corr(ar1) pairwise

*The Diehl index
xtpcse diehl polity bdthpct cwdthpct srivalcap allycap dsize emppop if year < 1998, corr(ar1) pairwise

*Additional analyses for problems with indicators for Table 3
*Military spending as a percentage of GDP
gen bdthpctsq = bdthpct*bdthpct
xtpcse milgdp polity bdthpct cwdthpct srivalcap allycap gdp emppop if major==1 & year < 1998, corr(ar1) pairwise
xtpcse milgdpest polity bdthpct cwdthpct srivalcap allycap gdpest emppop if year < 1998, corr(ar1) pairwise
xtpcse milgdpest polity bdthpct bdthpctsq cwdthpct srivalcap allycap gdpest emppop if year < 1998, corr(ar1) pairwise

*Military personnel
xtpcse milpct polity bdthpct cwdthpct srivalcap allycap tpop emppop if year < 1861, corr(ar1) pairwise
xtpcse milpct polity bdthpct cwdthpct srivalcap allycap tpop emppop if year > 1946 & year < 1998, corr(ar1) pairwise
xtpcse milpct polity bdthpct bdthpctsq cwdthpct srivalcap allycap tpop emppop if year < 1998, corr(ar1) pairwise

*The Diehl index
gen ww1 = 1 if year > 1913 & year < 1919
recode ww1 .=0
xtpcse diehl polity bdthpct bdthpctsq cwdthpct srivalcap allycap dsize emppop if year < 1998, corr(ar1) pairwise
xtpcse diehl polity bdthpct ww1 cwdthpct srivalcap allycap dsize emppop if year < 1998, corr(ar1) pairwise
xtpcse diehl polity bdthpct cwdthpct srivalcap allycap dsize emppop if year < 1914, corr(ar1) pairwise
xtpcse diehl polity bdthpct cwdthpct srivalcap allycap dsize emppop if year < 1861, corr(ar1) pairwise
xtpcse diehl polity bdthpct cwdthpct srivalcap allycap dsize emppop if year > 1945 & year < 1998, corr(ar1) pairwise
