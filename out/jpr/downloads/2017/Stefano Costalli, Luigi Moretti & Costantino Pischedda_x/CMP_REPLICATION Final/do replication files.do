
clear all
*use synth.ado  version 0.0.6  Jens Hainmueller 06/17/07
cd "C:\CMP_REPLICATION\CMP_REPLICATION\replication_files"
*algeria
local tru_49 49
local msp1_49 1975  
local msp2_49 1991  
local msp3_49 2007  
local treat_49 1992  
local time_49 33 
local var_49 " rgdpch(1975) rgdpch(1976) rgdpch(1977) rgdpch(1978)  rgdpch(1979) rgdpch(1980) rgdpch(1981) rgdpch(1982) rgdpch(1983)  rgdpch(1984) rgdpch(1985) rgdpch(1986) rgdpch(1987) rgdpch(1988)  rgdpch(1989) rgdpch(1990) rgdpch(1991) ki openk popgr sec"

*congo republic
local tru_37 37
local msp1_37 1983
local msp2_37 1992
local msp3_37 1999
local treat_37 1993
local time_37 17
local var_37 "rgdpch(1983) rgdpch(1984) rgdpch(1985) rgdpch(1986) rgdpch(1987) rgdpch(1988) rgdpch(1989) rgdpch(1990) rgdpch(1991) rgdpch(1992) ki openk popgr sec"

*cote d'ivoire
local tru_35 35
local msp1_35 1992
local msp2_35 2001
local msp3_35 2005
local treat_35 2002
local time_35 14
local var_35 "rgdpch(1992) rgdpch(1993) rgdpch(1994) rgdpch(1995) rgdpch(1996) rgdpch(1997) rgdpch(1998) rgdpch(1999) rgdpch(2000) rgdpch(2001) ki openk popgr sec"

*djibouti
local tru_45 45
local msp1_45 1981
local msp2_45 1990
local msp3_45 1994
local treat_45 1991
local time_45 14
local var_45 "rgdpch(1981) rgdpch(1982) rgdpch(1983) rgdpch(1984) rgdpch(1985) rgdpch(1986) rgdpch(1987) rgdpch(1988) rgdpch(1989) rgdpch(1990) ki openk popgr sec"

*egypt
local tru_51 51
local msp1_51 1984
local msp2_51 1993
local msp3_51 1997
local treat_51 1994
local time_51 14
local var_51 "rgdpch(1984) rgdpch(1985) rgdpch(1986) rgdpch(1987) rgdpch(1988) rgdpch(1989) rgdpch(1990) rgdpch(1991) rgdpch(1992) rgdpch(1993) ki openk popgr sec"

*el salvador
local tru_153 153
local msp1_153 1965
local msp2_153 1978
local msp3_153 1992
local treat_153 1979
local time_153 28
local var_153 "rgdpch(1965) rgdpch(1966) rgdpch(1967) rgdpch(1968) rgdpch(1969) rgdpch(1970) rgdpch(1971) rgdpch(1972)  rgdpch(1973) rgdpch(1974) rgdpch(1975) rgdpch(1976) rgdpch(1977)  rgdpch(1978) ki openk popgr sec"

*haiti
local tru_76 76
local msp1_76 1981
local msp2_76 1990
local msp3_76 1995
local treat_76 1991
local time_76 15
local var_76 "rgdpch(1981) rgdpch(1982)  rgdpch(1983) rgdpch(1984) rgdpch(1985) rgdpch(1986) rgdpch(1987)  rgdpch(1988) rgdpch(1989) rgdpch(1990) ki openk popgr sec"

*kenya
local tru_90 90
local msp1_90 1981
local msp2_90 1990
local msp3_90 1993
local treat_90 1991
local time_90 13
local var_90 "rgdpch(1981) rgdpch(1982)  rgdpch(1983) rgdpch(1984) rgdpch(1985) rgdpch(1986) rgdpch(1987) rgdpch(1988) rgdpch(1989) rgdpch(1990) ki openk popgr sec"

*liberia
local tru_99 99
local msp1_99 1974
local msp2_99 1988
local msp3_99 2003
local treat_99 1989
local time_99 30
local var_99 "rgdpch(1974) rgdpch(1975)  rgdpch(1976) rgdpch(1977) rgdpch(1978) rgdpch(1978)  rgdpch(1979) rgdpch(1980) rgdpch(1981) rgdpch(1982) rgdpch(1983)  rgdpch(1984) rgdpch(1985) rgdpch(1986) rgdpch(1987) rgdpch(1988)  ki openk popgr sec"

*nepal
local tru_130 130
local msp1_130 1985
local msp2_130 1995
local msp3_130 2006
local treat_130 1996
local time_130 22
local var_130 "rgdpch(1985) rgdpch(1986) rgdpch(1987) rgdpch(1988) rgdpch(1989)  rgdpch(1990) rgdpch(1991) rgdpch(1992) rgdpch(1993) rgdpch(1994)  rgdpch(1995) ki openk popgr sec"

*nicaragua
local tru_127 127
local msp1_127 1965
local msp2_127 1977
local msp3_127 1990
local treat_127 1978
local time_127 26
local var_127 "rgdpch(1965) rgdpch(1966) rgdpch(1967) rgdpch(1968)  rgdpch(1969) rgdpch(1970) rgdpch(1971) rgdpch(1972) rgdpch(1973)  rgdpch(1974) rgdpch(1975) rgdpch(1976)  rgdpch(1977) ki openk popgr sec"

*nigeria
local tru_126 126
local msp1_126 1971
local msp2_126 1979
local msp3_126 1985
local treat_126 1980
local time_126 15
local var_126 "rgdpch(1971) rgdpch(1972) rgdpch(1973) rgdpch(1974) rgdpch(1975) rgdpch(1976) rgdpch(1977) rgdpch(1978) rgdpch(1979) ki openk popgr sec"

*peru
local tru_135 135
local msp1_135 1963
local msp2_135 1979
local msp3_135 1996
local treat_135 1980
local time_135 34
local var_135 "rgdpch(1963) rgdpch(1964) rgdpch(1965) rgdpch(1966) rgdpch(1967) rgdpch(1968) rgdpch(1969) rgdpch(1970) rgdpch(1971) rgdpch(1972) rgdpch(1973) rgdpch(1974) rgdpch(1975) rgdpch(1976) rgdpch(1977) rgdpch(1978) rgdpch(1979) ki openk popgr sec"

*rwanda
local tru_146 146
local msp1_146 1980
local msp2_146 1989
local msp3_146 1994
local treat_146 1990
local time_146 15
local var_146 "rgdpch(1980) rgdpch(1981) rgdpch(1982) rgdpch(1983) rgdpch(1984) rgdpch(1985)  rgdpch(1986)  rgdpch(1987) rgdpch(1988)  rgdpch(1989)   ki openk popgr sec"

*senegal
local tru_149 149
local msp1_149 1978
local msp2_149 1988
local msp3_149 1999
local treat_149 1989
local time_149 22
local var_149 "rgdpch(1978) rgdpch(1979) rgdpch(1980) rgdpch(1981) rgdpch(1982) rgdpch(1983) rgdpch(1984) rgdpch(1985)  rgdpch(1986)  rgdpch(1987) rgdpch(1988) ki openk popgr sec"

*sierra leone
local tru_152 152
local msp1_152 1981
local msp2_152 1990
local msp3_152 1996
local treat_152 1991
local time_152 16
local var_152 "rgdpch(1981) rgdpch(1982) rgdpch(1983) rgdpch(1984) rgdpch(1985)  rgdpch(1986)  rgdpch(1987) rgdpch(1988)  rgdpch(1989)  rgdpch(1990)  ki openk popgr sec"

*somalia
local tru_154 154
local msp1_154 1970
local msp2_154 1987
local msp3_154 2007
local treat_154 1988
local time_154 38
local var_154 " rgdpch(1970)  rgdpch(1971) rgdpch(1972) rgdpch(1973) rgdpch(1974) rgdpch(1975) rgdpch(1976) rgdpch(1977) rgdpch(1978) rgdpch(1979) rgdpch(1980) rgdpch(1981) rgdpch(1982) rgdpch(1983) rgdpch(1984) rgdpch(1985)  rgdpch(1986)  rgdpch(1987) ki openk popgr sec"

*thailand
local tru_166 166
local msp1_166 1994
local msp2_166 2003
local msp3_166 2007
local treat_166 2004
local time_166 14
local var_166 "rgdpch(1994) rgdpch(1995) rgdpch(1996) rgdpch(1997) rgdpch(1998) rgdpch(1999) rgdpch(2000) rgdpch(2001) rgdpch(2002) rgdpch(2003) ki openk popgr sec"

*turkey
local tru_173 173
local msp1_173 1968
local msp2_173 1983
local msp3_173 1999
local treat_173 1984
local time_173 32
local var_173 "rgdpch(1968) rgdpch(1969) rgdpch(1970) rgdpch(1971) rgdpch(1972) rgdpch(1973) rgdpch(1974) rgdpch(1975) rgdpch(1976) rgdpch(1977) rgdpch(1978) rgdpch(1979) rgdpch(1980) rgdpch(1981) rgdpch(1982) rgdpch(1983)   ki openk popgr sec"

*uganda
local tru_176 176
local msp1_176 1968
local msp2_176 1977
local msp3_176 1987
local treat_176 1978
local time_176 20
local var_176 "rgdpch(1968) rgdpch(1969) rgdpch(1970) rgdpch(1971) rgdpch(1972) rgdpch(1973) rgdpch(1974) rgdpch(1975) rgdpch(1976)  rgdpch(1977) ki openk popgr sec"

***FIGURE 1
foreach i in  49 37 35 45 51 153 76 90 99 130 127 126 135 146 149 152 154 166 173 176 {
u repdatasetmain_`i'
levelsof isocode if unit==`i', local(code)
tsset unit year
synth rgdpch `var_`i'' ,  unitnames(isocode) trunit(`i') trperiod(`treat_`i'')  keep(`i', replace) figure
graph export `i'.emf, as(emf)   replace
clear
}
*

***TABLE I
*use the outcomes of Figure I
u reptable1
by unit, sort: egen mtreat=mean(_Y_treat)
by unit, sort: egen msynth=mean(_Y_synth)
gen meff=((mtreat-msynth)/msynth)*100
egen tag=tag(unit)
keep if tag==1
keep country meff
list country meff
clear

***FIGURE 2
foreach i in  49 37 35 45 51 153 76 90 99 130 127 126 135 146 149 152 154 166 173 176 {
forval h = 1/100 {
* use datasets including half (and randomly chosen) control countries used for Figure I
u repdataset50_`i'_`h'
levelsof isocode if unit==`i', local(code)
tsset unit year
synth rgdpch `var_`i'' ,  unitnames(isocode) trunit(`i') trperiod(`treat_`i'')  keep(`i'_`h'_50, replace)
clear 
}
}
foreach i in  49 37 35 45 51 153 76 90 99 130 127 126 135 146 149 152 154 166 173 176 {
*use the outcomes save in "`i'_`h'_50" and in "`i'"
u repgraph50_`i'
local call
forval h=1/100{
local call `call' line diff_`h' _time, lc(gray) lcolor(gray) lwidth(vvvthin)||
}
twoway `call'|| line treateddiff _time, lcolor(black) lwidth(thick) xscale(range(`msp1_`i'' `msp3_`i'')) xtitle(Year) xline(`treat_`i'',lcolor(black) lwidth(vvvthin) lpattern(dash)) yline(0,lcolor(black) lwidth(vvvthin) lpattern(dash)) legend(off)  title(`i')
graph export random_`i'.emf, as(emf)   replace
clear
}
*

clear
*models for tables 2, A3, A4, A5, A8, A9, A10, A11
local column1 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 d70 d80 d90"
local column2 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ldeath d70 d80 d90"
local column3 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ldeath ETHFRAC_ldeath d70 d80 d90"
local column4 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 l.y d70 d80 d90"
local column5 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 l.y ldeath d70 d80 d90"
local column6 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 l.y ldeath ETHFRAC_ldeath d70 d80 d90"
local column7 "polity2 polity2sq yatwar ldeath ETHFRAC_ldeath c1-c19 d70 d80 d90"
local column8 "polity2 polity2sq yatwar ldeath ETHFRAC_ldeath l.y c1-c19 d70 d80 d90"

***TABLE 2
u repregression
gen y=perc_gap
foreach i in 1 2 3 4 5 6 7 8 {
xtpcse y `column`i'', correlation(psar1) pair
}
*
clear
***TABLE 3
local alcolumn1 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ETHFRAC_yatwar d70 d80 d90"
local alcolumn2 "ETHFRAC polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ETHFRAC_ethnic d70 d80 d90"
local alcolumn3 "ETHPOL  polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 d70 d80 d90"
local alcolumn4 "ETHPOL  polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ldeath d70 d80 d90"
local alcolumn5 "ETHPOL  polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ldeath ETHPOL_ldeath d70 d80 d90"
local alcolumn6 "ETHPOL  polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ETHPOL_yatwar d70 d80 d90 "
local alcolumn7 "ETHPOL  polity2 polity2sq yatwar ethnicwar tecreb2 tecreb3 ETHPOL_ethnic d70 d80 d90"
u repregression
gen y=perc_gap
foreach i in 1 2 3 4 5 6 7 {
xtpcse y `alcolumn`i'', correlation(psar1) pair
}
clear

***TABLE A1
u repdif
foreach i in 49 37 35 45 51 153 76 90 99 130 127 126 135 146 149 152 154 166 173 176  {
levelsof isocode if unit==`i', local(code)
reg y treated post treated_post if unit==`i', robust
}

***TABLE A2
clear
u repselectednonselected
foreach i in ETHFRAC death polity2 duration ethnicwar post1990 conventional irregular {
ttest `i' , by(selected)
}
clear
***TABLE A3
u repregressionpollag
gen y=perc_gap
replace polity2=polity2lag1
replace polity2sq=polity2lag1*polity2lag1
foreach i in 1 2 3 4 5 6 7 8{
xtpcse y `column`i'', correlation(psar1) pair
}
clear

***TABLE A4
u repregressionpollag
gen y=perc_gap
replace polity2=polity2lag5
replace polity2sq=polity2lag5*polity2lag5
foreach i in 1 2 3 4 5 6 7 8{
xtpcse y `column`i'', correlation(psar1) pair
}
clear

***TABLE A5
local polcolumn1 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 d70 d80 d90"
local polreport1 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3"
local polcolumn2 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 ldeath d70 d80 d90"
local polreport2 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 ldeath"
local polcolumn3 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 ldeath ETHFRAC_ldeath d70 d80 d90"
local polreport3 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 ldeath ETHFRAC_ldeath"
local polcolumn4 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 l.y d70 d80 d90"
local polreport4 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 l.y"
local polcolumn5 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 l.y ldeath d70 d80 d90"
local polreport5 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 l.y ldeath"
local polcolumn6 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 l.y ldeath ETHFRAC_ldeath d70 d80 d90"
local polreport6 "ETHFRAC yatwar ethnicwar tecreb2 tecreb3 l.y ldeath ETHFRAC_ldeath"
local polcolumn7 "yatwar ldeath ETHFRAC_ldeath c1-c19 d70 d80 d90"
local polreport7 "yatwar ldeath ETHFRAC_ldeath"
local polpolcolumn8 "yatwar ldeath ETHFRAC_ldeath l.y c1-c19 d70 d80 d90"
local polpolreport8 "yatwar ldeath ETHFRAC_ldeath l.y"
u repregressionpollag.dta
gen y=perc_gap
foreach i in 1 2 3 4 5 6 7 8{
xtpcse y `polcolumn`i'', correlation(psar1) pair
}
clear

*model for tables A6-A7
local intencolumn1 "yatwar"
local intencolumn2 "yatwar yatwarsq"
local intencolumn3 "yatwar d70 d80 d90"
local intencolumn4 "yatwar yatwarsq d70 d80 d90"
local intencolumn5 "yatwar d70 d80 d90 c1-c19"
local intencolumn6 "yatwar yatwarsq d70 d80 d90 c1-c19"
local intencolumn7 "deathth"
local intencolumn8 "deathth deaththsq"
local intencolumn9 "deathth d70 d80 d90"
local intencolumn10 "deathth deaththsq d70 d80 d90"
local intencolumn11 "deathth d70 d80 d90 c1-c19"
local intencolumn12 "deathth deaththsq d70 d80 d90 c1-c19"
local intencolumn13 "yatwar yatwarsq deathth deaththsq"
local intencolumn14 "yatwar yatwarsq deathth deaththsq d70 d80 d90"
local intencolumn15 "yatwar yatwarsq deathth deaththsq d70 d80 d90 c1-c19"
local intencolumn16 "ETHFRAC polity2 polity2sq yatwar yatwarsq ethnicwar tecreb2 tecreb3 d70 d80 d90"
local intencolumn17 "ETHFRAC polity2 polity2sq yatwar yatwarsq deathth ethnicwar tecreb2 tecreb3 d70 d80 d90"
local intencolumn18 "ETHFRAC polity2 polity2sq yatwar yatwarsq deathth deaththsq ethnicwar tecreb2 tecreb3 d70 d80 d90"

***TABLE A6 
clear
u repregressionyeardeathsq
gen y=perc_gap
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12{
xtpcse y `intencolumn`i'', correlation(psar1) pair
}
*
clear

***TABLE A7
u repregressionyeardeathsq
gen y=perc_gap
foreach i in 13 14 15 16 17 18{
xtpcse y `intencolumn`i'', correlation(psar1) pair
}
*

clear
***TABLE A8-A9-A10
clear
u repregressionaltern50.dta
local tmeanpc A8
local tmedianpc A9
local tminpc A10
gen y=.
foreach y in meanpc medianpc minpc{
replace y=`y'
foreach i in 1 2 3 4 5 6 7 8{
xtpcse y `column`i'', correlation(psar1) pair
}
}
*

***TABLE A11
clear
u repregressioncluster
gen y= perc_gapcluster
foreach i in 1 2 3 4 5 6 7 8{
xtpcse y `column`i'', correlation(psar1) pair
}
*

***FIGURE A1
clear
u  repgraphsgdpsize.dta
graph twoway (qfit eff lmgdppc) (scatter eff lmgdppc), xtitle(log(GDP per capita)) ytitle(Mean effect on GDP per capita) legend(off)
graph twoway (qfit peff lmgdppc) (scatter peff lmgdppc), xtitle(log(GDP per capita)) ytitle(Mean % effect on GDP per capita) legend(off)
graph twoway (qfit eff lsurface) (scatter eff lsurface), xtitle(log(Surface area sq. km)) ytitle(Mean effect on GDP per capita) legend(off)
graph twoway (qfit peff lsurface) (scatter peff lsurface), xtitle(log(Surface area sq. km)) ytitle(Mean % effect on GDP per capita) legend(off)
clear


***FIGURE A2
foreach i in  49 37 35 45 51 153 76 90 99 130 127 126 135 146 149 152 154 166 173 176 {
forval h = 1/100 {
* use datasets including 1/4 (and randomly chosen) control countries used for Figure I
u repdataset25_`i'_`h'
levelsof isocode if unit==`i', local(code)
tsset unit year
synth rgdpch `var_`i'' ,  unitnames(isocode) trunit(`i') trperiod(`treat_`i'')  keep(`i'_`h'_25, replace)
clear 
}
}
foreach i in  49 37 35 45 51 153 76 90 99 130 127 126 135 146 149 152 154 166 173 176 {
*use the outcomes save in "`i'_`h'_25" and in "`i'"
u repgraph25_`i'
local call
forval h=1/100{
local call `call' line diff_`h' _time, lc(gray) lcolor(gray) lwidth(vvvthin)||
}
twoway `call'|| line treateddiff _time, lcolor(black) lwidth(thick) xscale(range(`msp1_`i'' `msp3_`i'')) xtitle(Year) xline(`treat_`i'',lcolor(black) lwidth(vvvthin) lpattern(dash)) yline(0,lcolor(black) lwidth(vvvthin) lpattern(dash)) legend(off)  title(`i')
graph export random25_`i'.emf, as(emf)   replace
clear
}
*


***FIGURE A3
foreach i in  49 37 35 45 51 153 76 90 99 130 127 126 135 146 149 152 154 166 173 176 {
u repdatasetcl_`i'
levelsof isocode if unit==`i', local(code)
tsset unit year
synth rgdpch `var_`i'' ,  unitnames(isocode) trunit(`i') trperiod(`treat_`i'')  keep(`i', replace) figure
graph export cl_`i'.emf, as(emf)   replace
clear
}
*
