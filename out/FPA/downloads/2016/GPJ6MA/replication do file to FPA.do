*Please feel free to contact murdiea@missouri.edu if you have any questions 

use "C:\Users\murdiea\Dropbox\journalists killed amanda\FPA R&R\replication data file to FPA Asal et al.dta", clear
set more off 
xi: logit   KCPJBINARY  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table1, replace word label bdec(5)

relogit   KCPJBINARY   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table1, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table1 , append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table1 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table1 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table1 , append word label bdec(5)



logit   KCPJBINARY  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop   _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007  ,cluster( ccode)

drop durat*
prgen p_polity2  , from (-10) to (10) generate(durat) rest(mean) ci 

label variable duratp1 "Probability *of Journalist Killing" 

label variable duratx "Revised Combined Polity Score"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"



twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none) yaxis(1)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(non) yaxis(1)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none) yaxis(1)) (kdensity p_polity2 if e(sample), yaxis(2))

sum duratp1 duratp1lb duratp1ub  if duratx==-4
sum duratp1 duratp1lb duratp1ub  if duratx==8

logit   KCPJBINARY  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop   _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007  ,cluster( ccode)

prgen ciri_speech  , from (0) to (2) generate(durac) rest(mean) ci 

sum duracp1 duracp1lb duracp1ub  if duracx==0
sum duracp1 duracp1lb duracp1ub  if duracx==1
sum duracp1 duracp1lb duracp1ub  if duracx==2





*    DEMOC POLITY2ANOC POLITY2AUTO


xi: logit   KCPJBINARY  icrg_qog    DEMOC    informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table48, replace word label bdec(5)
xi: logit   KCPJBINARY  icrg_qog    POLITY2ANOC    informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table48, append  word label bdec(5)
xi: logit   KCPJBINARY  icrg_qog    POLITY2AUTO   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table48, append word label bdec(5)
*maybe put that in the text 


**online appendix tables 

*Table 0A3:
**UN rate 

xi: logit   KCPJBINARY  icrg_qog  UNrate    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech        lnpop  i.year   ,cluster( ccode)
outreg2 using Table3  , replace word label bdec(5)

relogit   KCPJBINARY   icrg_qog   UNrate    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech        lnpop   _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using  Table3  , append word label bdec(5)

xi: ologit   ORDEREDKCPJ    UNrate  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech        lnpop     i.year   ,cluster( ccode)
outreg2 using  Table3 , append word label bdec(5)

xi: ologit   OO   icrg_qog    UNrate  p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech        lnpop  i.year   ,cluster( ccode)
outreg2 using  Table3 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog   UNrate    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech        lnpop  i.year  ,cluster( ccode)
outreg2 using  Table3  , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    UNrate   p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech         i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using  Table3  , append word label bdec(5)



**Table 0A4: 

xi: logit   KCPJBINARY  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_ass         lnpop  i.year   ,cluster( ccode)
outreg2 using Table4 , replace word label bdec(5)

relogit   KCPJBINARY   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_ass           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table4, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_ass         lnpop     i.year   ,cluster( ccode)
outreg2 using Table4, append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_ass         lnpop  i.year   ,cluster( ccode)
outreg2 using Table4 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_ass            lnpop  i.year  ,cluster( ccode)
outreg2 using Table4 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_ass             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table4 , append word label bdec(5)

*Table 0A5:

*     HIGHDEMOC LOWDEMOC POLITY2ANOC POLITY2AUTO

xi: zinb   cpj_killed  icrg_qog   HIGHDEMOC   informationflows  maxintyearv410     ciri_physint ciri_ass           i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table5 , replace word label bdec(5)

xi: zinb   cpj_killed  icrg_qog   LOWDEMOC   informationflows  maxintyearv410     ciri_physint ciri_ass           i.year ,cluster( ccode) inflate(lnpop)
outreg2 using Table5  , append word label bdec(5)

xi: zinb   cpj_killed icrg_qog   POLITY2ANOC   informationflows  maxintyearv410     ciri_physint ciri_ass             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table5  , append word label bdec(5)

xi: zinb   cpj_killed  icrg_qog   POLITY2AUTO   informationflows  maxintyearv410     ciri_physint ciri_ass            i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table5  , append word label bdec(5)



*Table 0A6:
*with Gandhi Cheibub indicator instead *of polity

xi: logit   KCPJBINARY  icrg_qog     chga_demo   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table6, replace word label bdec(5)


relogit   KCPJBINARY   icrg_qog     chga_demo   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table6, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    chga_demo  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table6 , append word label bdec(5)

xi: ologit   OO   icrg_qog    chga_demo  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table6 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog     chga_demo  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table6 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog     chga_demo   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table6 , append word label bdec(5)


*Table 0A7:
*with gdp per cap

*gen lngdp = ln(wdi_gdp)
logit   KCPJBINARY  icrg_qog    p_polity2  lngdp informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table7, replace word label bdec(5)


relogit   KCPJBINARY   icrg_qog    p_polity2   lngdp  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table7, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2  lngdp   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table7 , append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2   lngdp  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table7 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2  lngdp   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table7 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2  lngdp  informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table7 , append word label bdec(5)

*Table 0A8:  with TV(Banks)

logit   KCPJBINARY  icrg_qog    p_polity2  banksTVsfromnorris1999only informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table8, replace word label bdec(5)


relogit   KCPJBINARY   icrg_qog    p_polity2   banksTVsfromnorris1999only informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table8, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2  banksTVsfromnorris1999only   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table8 , append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2   banksTVsfromnorris1999only informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table8 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2  banksTVsfromnorris1999only  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table8 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2  banksTVsfromnorris1999only  informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table8 , append word label bdec(5)


*Table 0A9: with newspaper circulation (papersbanksfromnorris1999only)



logit   KCPJBINARY  icrg_qog    p_polity2  papersbanksfromnorris1999only informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table9, replace word label bdec(5)


relogit   KCPJBINARY   icrg_qog    p_polity2   papersbanksfromnorris1999only informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table9, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2  papersbanksfromnorris1999only   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table9 , append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2   papersbanksfromnorris1999only informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table9, append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2  papersbanksfromnorris1999only informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table9 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2  papersbanksfromnorris1999only  informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table9 , append word label bdec(5)


*Table 0A10: with dependent variable as log *of killings

*tab  cpj_killed 

*gen lncpj_killed = ln( cpj_killed +1)

reg   lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xtgee  lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop    , corr(ar1) robust force


*Table 0A11: squared polity 

*gen squaredpolity = p_polity2 * p_polity2 



xi : logit   KCPJBINARY  icrg_qog    p_polity2   squaredpolity informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table10, replace word label bdec(5)




relogit   KCPJBINARY   icrg_qog    p_polity2 squaredpolity   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table10, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2 squaredpolity   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table10 , append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2  squaredpolity  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table10 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2 squaredpolity   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table10 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2 squaredpolity   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table10 , append word label bdec(5)




*Table 0A12: FH Freedom *of the Press Measure

*"The press freedom index is computed by adding four (three) component ratings: Laws 
*and regulations, Political pressures and controls, Economic Influences and Repressive 
*actions (the latter is since 2001 not assessed as a separate component, see below). The 
*scale ranges from 0 (most free) to 100 (least free)." (QoG Codebook)


xi: logit   KCPJBINARY  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint fh_press         lnpop  i.year   ,cluster( ccode)
outreg2 using Table11, replace word label bdec(5)

relogit   KCPJBINARY   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint fh_press          lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table11, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint fh_press          lnpop     i.year   ,cluster( ccode)
outreg2 using Table11 , append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint fh_press         lnpop  i.year   ,cluster( ccode)
outreg2 using Table11 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint fh_press           lnpop  i.year  ,cluster( ccode)
outreg2 using Table11 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint fh_press            i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table11 , append word label bdec(5)



***Table 0A13: Van Belle data 
*like Whitten-Woodring (2009), we recode "0"s as missings

replace mf=. if mf==0


xi: logit   KCPJBINARY  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint  mf         lnpop  i.year   ,cluster( ccode)
outreg2 using Table36, replace word label bdec(5)

relogit   KCPJBINARY   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint  mf        lnpop    _Iyear_1994 _Iyear_1995  , cluster( ccode)
outreg2 using Table36, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint  mf       lnpop     i.year   ,cluster( ccode)
outreg2 using Table36 , append word label bdec(5)

xi: ologit   OO   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint  mf        lnpop  i.year   ,cluster( ccode)
outreg2 using Table36 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint  mf          lnpop  i.year  ,cluster( ccode)
outreg2 using Table36 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint  mf           i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table36 , append word label bdec(5)




*outliers


reg   lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  
*gen id = _n
lvr2plot, mlabel(id)

*nothing in the upper right *of the graph

*can run without those two

*Table OA 14

reg   lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  if id!=1828 & id!=1827
outreg2 using Table39, replace word label bdec(5)

*even without logging the killed variable
reg   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  
lvr2plot, mlabel(id)
lvr2plot, mlabel(id)

reg   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  if id!=1828 & id!=1827
outreg2 using Table40, replace word label bdec(5)


*let's look at leverage as well
reg   lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  

predict leverage, leverage

sum leverage

di (2*23)/1975

reg   lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  if leverage<.02329114
outreg2 using Table41, replace word label bdec(5)


*also cooksd 
reg   lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  
predict cooksd, cooksd
sum cooksd
di 2/(sqrt(1975))

reg   lncpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year if cooksd<.045
outreg2 using Table42, replace word label bdec(5)

*same two cases too (id 1827 and 1828)

*Table OA 15

*Council *of Europe argument - regional controls 


xi: logit   KCPJBINARY  icrg_qog   i.ht_region2    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table43, replace word label bdec(5)

relogit   KCPJBINARY   icrg_qog     _Iht_region_2 _Iht_region_3 _Iht_region_4 _Iht_region_5 _Iht_region_6 _Iht_region_7 _Iht_region_8 _Iht_region_9 p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table43, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog    i.ht_region2   p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table43 , append word label bdec(5)

xi: ologit   OO   icrg_qog   i.ht_region2   p_polity2     informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table43 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog    i.ht_region2   p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table43 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog     i.ht_region2  p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table43 , append word label bdec(5)

*Table OA 16 

*Council *of Europe argument - no post 2007

xi: logit   KCPJBINARY  icrg_qog     p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year  if year <2007  ,cluster( ccode)
outreg2 using Table45, replace word label bdec(5)

relogit   KCPJBINARY   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005  if year <2007, cluster( ccode)
outreg2 using Table45, append word label bdec(5)

xi: ologit   ORDEREDKCPJ    icrg_qog     p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   if year <2007,cluster( ccode)
outreg2 using Table45 , append word label bdec(5)

xi: ologit   OO   icrg_qog      p_polity2    informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   if year <2007,cluster( ccode)
outreg2 using Table45 , append word label bdec(5)

xi: nbreg   cpj_killed  icrg_qog      p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  if year <2007,cluster( ccode)
outreg2 using Table45 , append word label bdec(5)

xi: zinb   cpj_killed   icrg_qog      p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  if year <2007,cluster( ccode) inflate(lnpop)
outreg2 using Table45 , append word label bdec(5)


*Table OA 17 

*causal stuff - granger?
*thanks to Dursun Peksen for this code! 
* Granger "Causality" Test Based on Granger (1969)
*Null Hypothesis: x does not "granger cause" y - we run an F-test on Beta
* Logic: x granger-causes y if past values *of x help explain y, once we also account for the past values *of y. 



*Granger Causality tests

****granger stuff with controls (sometimes recommended)

*Granger Causality tests

*two lags
sort ccodecow year
reg cpj_killed l.cpj_killed l.p_polity2  l2.cpj_killed  l2.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.p_polity2 l2.p_polity2 
reg p_polity2 l.p_polity2 l.cpj_killed l2.p_polity2 l2.cpj_killed icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed 
*one sig from p_polity2 to KCPBINARY 


*lag length 3
sort ccodecow year
reg cpj_killed l.cpj_killed p_polity2  l2.cpj_killed  l2.p_polity2 l3.cpj_killed  l3.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.p_polity2 l2.p_polity2 l3.p_polity2 
reg p_polity2 l.p_polity2 l.cpj_killed l2.p_polity2 l2.cpj_killed l3.cpj_killed l3.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed
*sig from p_polity2 to KCPBINARY but also sig from cpj_killed to p_polity2 



*lag length 4
sort ccodecow year
reg cpj_killed l.cpj_killed p_polity2  l2.cpj_killed  l2.p_polity2 l3.cpj_killed  l3.p_polity2 l4.cpj_killed  l4.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.p_polity2 l2.p_polity2 l3.p_polity2 l4.p_polity2
reg p_polity2 l.p_polity2 l.cpj_killed l2.p_polity2 l2.cpj_killed l3.cpj_killed l3.p_polity2 l4.cpj_killed l4.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed
*sig from p_polity2 to KCPBINARY and from p_polity2 to cpj_killed 


*lag length 5
sort ccodecow year
reg cpj_killed l.cpj_killed p_polity2  l2.cpj_killed  l2.p_polity2 l3.cpj_killed  l3.p_polity2 l4.cpj_killed  l4.p_polity2 l5.cpj_killed  l5.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.p_polity2 l2.p_polity2 l3.p_polity2 l4.p_polity2 l5.p_polity2
reg p_polity2 l.p_polity2 l.cpj_killed l2.p_polity2 l2.cpj_killed l3.cpj_killed l3.p_polity2 l4.cpj_killed l4.p_polity2 l5.cpj_killed l5.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed 
*one sig from p_polity2 to KCPBINARY 



*lag length 6
reg cpj_killed l.cpj_killed p_polity2  l2.cpj_killed  l2.p_polity2 l3.cpj_killed  l3.p_polity2 l4.cpj_killed  l4.p_polity2 l5.cpj_killed  l5.p_polity2 l6.cpj_killed  l6.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.p_polity2 l2.p_polity2 l3.p_polity2 l4.p_polity2 l5.p_polity2 l6.p_polity2
reg p_polity2 l.p_polity2 l.cpj_killed l2.p_polity2 l2.cpj_killed l3.cpj_killed l3.p_polity2 l4.cpj_killed l4.p_polity2 l5.cpj_killed l5.p_polity2 l6.cpj_killed l6.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed
*sig from p_polity2 to KCPBINARY and from p_polity2 to cpj_killed 



*lag length 7
sort ccodecow year
reg cpj_killed l.cpj_killed p_polity2  l2.cpj_killed  l2.p_polity2 l3.cpj_killed  l3.p_polity2 l4.cpj_killed  l4.p_polity2 l5.cpj_killed  l5.p_polity2 l6.cpj_killed  l6.p_polity2 l7.cpj_killed  l7.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.p_polity2 l2.p_polity2 l3.p_polity2 l4.p_polity2 l5.p_polity2 l6.p_polity2 l7.p_polity2
reg p_polity2 l.p_polity2 l.cpj_killed l2.p_polity2 l2.cpj_killed l3.cpj_killed l3.p_polity2 l4.cpj_killed l4.p_polity2 l5.cpj_killed l5.p_polity2 l6.cpj_killed l6.p_polity2  l7.cpj_killed l7.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed
*sig from p_polity2 to KCPBINARY and from p_polity2 to cpj_killed  


*lag length 8
sort ccodecow year
reg cpj_killed l.cpj_killed p_polity2  l2.cpj_killed  l2.p_polity2 l3.cpj_killed  l3.p_polity2 l4.cpj_killed  l4.p_polity2 l5.cpj_killed  l5.p_polity2 l6.cpj_killed  l6.p_polity2 l7.cpj_killed  l7.p_polity2 l8.cpj_killed  l8.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.p_polity2 l2.p_polity2 l3.p_polity2 l4.p_polity2 l5.p_polity2 l6.p_polity2 l7.p_polity2 l8.p_polity2
reg p_polity2 l.p_polity2 l.cpj_killed l2.p_polity2 l2.cpj_killed l3.cpj_killed l3.p_polity2 l4.cpj_killed l4.p_polity2 l5.cpj_killed l5.p_polity2 l6.cpj_killed l6.p_polity2  l7.cpj_killed l7.p_polity2 l8.cpj_killed l8.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed l8.cpj_killed 
*sig from p_polity2 to KCPBINARY and from p_polity2 to cpj_killed



****granger stuff with controls (sometimes recommended)

*Granger Causality tests

*two lags
sort ccodecow year
reg cpj_killed l.cpj_killed l.D.p_polity2  l2.cpj_killed  l2.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed 
*one sig from D.p_polity2 to KCPBINARY 


*lag length 3
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed
*sig from D.p_polity2 to KCPBINARY but also sig from cpj_killed to D.p_polity2 



*lag length 4
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed
*sig from D.p_polity2 to KCPBINARY and from D.p_polity2 to cpj_killed 


*lag length 5
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed 
*one sig from D.p_polity2 to KCPBINARY 



*lag length 6
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 l6.cpj_killed  l6.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2 l6.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 l6.cpj_killed l6.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed
*sig from D.p_polity2 to KCPBINARY and from D.p_polity2 to cpj_killed 



*lag length 7
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 l6.cpj_killed  l6.D.p_polity2 l7.cpj_killed  l7.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2 l6.D.p_polity2 l7.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 l6.cpj_killed l6.D.p_polity2  l7.cpj_killed l7.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed
*sig from D.p_polity2 to KCPBINARY and from D.p_polity2 to cpj_killed  


*lag length 8
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 l6.cpj_killed  l6.D.p_polity2 l7.cpj_killed  l7.D.p_polity2 l8.cpj_killed  l8.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2 l6.D.p_polity2 l7.D.p_polity2 l8.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 l6.cpj_killed l6.D.p_polity2  l7.cpj_killed l7.D.p_polity2 l8.cpj_killed l8.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed l8.cpj_killed 
*sig from D.p_polity2 to KCPBINARY and from D.p_polity2 to cpj_killed
 
 
 *lag length 9
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 l6.cpj_killed  l6.D.p_polity2 l7.cpj_killed  l7.D.p_polity2 l8.cpj_killed  l8.D.p_polity2  l9.cpj_killed  l9.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2 l6.D.p_polity2 l7.D.p_polity2 l8.D.p_polity2 l9.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 l6.cpj_killed l6.D.p_polity2  l7.cpj_killed l7.D.p_polity2 l8.cpj_killed l8.D.p_polity2  l9.cpj_killed l9.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed l8.cpj_killed  l9.cpj_killed

 
 *lag length 10
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 l6.cpj_killed  l6.D.p_polity2 l7.cpj_killed  l7.D.p_polity2 l8.cpj_killed  l8.D.p_polity2  l9.cpj_killed  l9.D.p_polity2 l10.cpj_killed  l10.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2 l6.D.p_polity2 l7.D.p_polity2 l8.D.p_polity2 l9.D.p_polity2 l10.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 l6.cpj_killed l6.D.p_polity2  l7.cpj_killed l7.D.p_polity2 l8.cpj_killed l8.D.p_polity2  l9.cpj_killed l9.D.p_polity2 l10.cpj_killed  l10.D.p_polity2  icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed l8.cpj_killed  l9.cpj_killed l10.cpj_killed


 *lag length 11
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 l6.cpj_killed  l6.D.p_polity2 l7.cpj_killed  l7.D.p_polity2 l8.cpj_killed  l8.D.p_polity2  l9.cpj_killed  l9.D.p_polity2 l10.cpj_killed  l10.D.p_polity2 l11.cpj_killed  l11.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2 l6.D.p_polity2 l7.D.p_polity2 l8.D.p_polity2 l9.D.p_polity2 l10.D.p_polity2 l11.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 l6.cpj_killed l6.D.p_polity2  l7.cpj_killed l7.D.p_polity2 l8.cpj_killed l8.D.p_polity2  l9.cpj_killed l9.D.p_polity2 l10.cpj_killed  l10.D.p_polity2 l11.cpj_killed  l11.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed l8.cpj_killed  l9.cpj_killed l10.cpj_killed l11.cpj_killed



 *lag length 12
sort ccodecow year
reg cpj_killed l.cpj_killed D.p_polity2  l2.cpj_killed  l2.D.p_polity2 l3.cpj_killed  l3.D.p_polity2 l4.cpj_killed  l4.D.p_polity2 l5.cpj_killed  l5.D.p_polity2 l6.cpj_killed  l6.D.p_polity2 l7.cpj_killed  l7.D.p_polity2 l8.cpj_killed  l8.D.p_polity2  l9.cpj_killed  l9.D.p_polity2 l10.cpj_killed  l10.D.p_polity2 l11.cpj_killed  l11.D.p_polity2 l12.cpj_killed  l12.D.p_polity2 icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.D.p_polity2 l2.D.p_polity2 l3.D.p_polity2 l4.D.p_polity2 l5.D.p_polity2 l6.D.p_polity2 l7.D.p_polity2 l8.D.p_polity2 l9.D.p_polity2 l10.D.p_polity2 l11.D.p_polity2 l12.D.p_polity2
reg D.p_polity2 l.D.p_polity2 l.cpj_killed l2.D.p_polity2 l2.cpj_killed l3.cpj_killed l3.D.p_polity2 l4.cpj_killed l4.D.p_polity2 l5.cpj_killed l5.D.p_polity2 l6.cpj_killed l6.D.p_polity2  l7.cpj_killed l7.D.p_polity2 l8.cpj_killed l8.D.p_polity2  l9.cpj_killed l9.D.p_polity2 l10.cpj_killed  l10.D.p_polity2 l11.cpj_killed  l11.D.p_polity2 l12.cpj_killed  l12.D.p_polity2  icrg_qog        informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year , cluster(ccode)
estat ic
testparm l.cpj_killed l2.cpj_killed l3.cpj_killed l4.cpj_killed l5.cpj_killed  l6.cpj_killed l7.cpj_killed l8.cpj_killed  l9.cpj_killed l10.cpj_killed l11.cpj_killed l12.cpj_killed




***Like R2 wants, with just democ anoc and auto



*Table OA 19 

relogit   KCPJBINARY   icrg_qog    DEMOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table49, replace word label bdec(5)
relogit   KCPJBINARY   icrg_qog     POLITY2ANOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table49, append word label bdec(5)
relogit   KCPJBINARY   icrg_qog      POLITY2AUTO  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table49, append word label bdec(5)


*Table OA 20 
xi: ologit   ORDEREDKCPJ    icrg_qog    DEMOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table50 , replace word label bdec(5)
xi: ologit   ORDEREDKCPJ    icrg_qog     POLITY2ANOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table50 , append word label bdec(5)
xi: ologit   ORDEREDKCPJ    icrg_qog   POLITY2AUTO    informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table50 , append word label bdec(5)

*Table OA 21 
xi: ologit   OO   icrg_qog   DEMOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table51 , replace word label bdec(5)
xi: ologit   OO   icrg_qog  POLITY2ANOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table51 , append word label bdec(5)
xi: ologit   OO   icrg_qog   POLITY2AUTO informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table51 , append word label bdec(5)


*Table OA 22 
xi: nbreg   cpj_killed  icrg_qog    DEMOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table52 , replace  word label bdec(5)
xi: nbreg   cpj_killed  icrg_qog    POLITY2ANOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table52 , append word label bdec(5)
xi: nbreg   cpj_killed  icrg_qog    POLITY2AUTO    informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table52 , append word label bdec(5)
*Table OA 23 

xi: zinb   cpj_killed   icrg_qog   DEMOC    informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table53 , replace word label bdec(5)
xi: zinb   cpj_killed   icrg_qog   POLITY2ANOC  informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table53 , append word label bdec(5)
xi: zinb   cpj_killed   icrg_qog    POLITY2AUTO   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table53 , append word label bdec(5)

sum cpj_killed if DEMOC==1 
sum cpj_killed if POLITY2ANOC==1
sum cpj_killed if POLITY2AUTO==1

sum KCPJBINARY  if DEMOC==1
sum KCPJBINARY   if POLITY2ANOC==1
sum KCPJBINARY   if POLITY2AUTO==1


sum ORDEREDKCPJ if DEMOC==1
sum ORDEREDKCPJ   if POLITY2ANOC==1
sum ORDEREDKCPJ   if POLITY2AUTO==1


sum OO if DEMOC==1
sum OO  if POLITY2ANOC==1
sum OO  if POLITY2AUTO==1


sum lncpj_killed if DEMOC==1 
sum lncpj_killed if POLITY2ANOC==1
sum lncpj_killed if POLITY2AUTO==1


sum cpj_killed if DEMOC==1 
sum cpj_killed if POLITY2ANOC==1 & id!=1828 & id!=1827
sum cpj_killed if POLITY2AUTO==1

*logit specification for the high stuff (as R2 suggests) HIGHDEMOC LOWDEMOC POLITY2ANOC POLITY2AUTO

*Table OA 24
xi: logit   KCPJBINARY  icrg_qog    HIGHDEMOC   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table54, replace word label bdec(5)

xi: logit   KCPJBINARY  icrg_qog   LOWDEMOC   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table54, append  word label bdec(5)

xi: logit   KCPJBINARY  icrg_qog   POLITY2ANOC  informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table54, append word label bdec(5)

xi: logit   KCPJBINARY  icrg_qog    POLITY2AUTO  informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table54, append word label bdec(5)



*Table OA 25
relogit   KCPJBINARY   icrg_qog     HIGHDEMOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table55, replace word label bdec(5)
relogit   KCPJBINARY   icrg_qog    LOWDEMOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table55, append word label bdec(5)
relogit   KCPJBINARY   icrg_qog     POLITY2ANOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table55, append word label bdec(5)
relogit   KCPJBINARY   icrg_qog      POLITY2AUTO  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table55, append word label bdec(5)

*Table OA 26

xi: ologit   ORDEREDKCPJ    icrg_qog    HIGHDEMOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table56 , replace word label bdec(5)
xi: ologit   ORDEREDKCPJ    icrg_qog   LOWDEMOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table56 , append word label bdec(5)
xi: ologit   ORDEREDKCPJ    icrg_qog     POLITY2ANOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table56 , append word label bdec(5)
xi: ologit   ORDEREDKCPJ    icrg_qog   POLITY2AUTO    informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table56 , append word label bdec(5)

*Table OA 27
xi: ologit   OO   icrg_qog   HIGHDEMOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table57 , replace word label bdec(5)
xi: ologit   OO   icrg_qog   LOWDEMOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table57 , append word label bdec(5)
xi: ologit   OO   icrg_qog  POLITY2ANOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table57 , append word label bdec(5)
xi: ologit   OO   icrg_qog   POLITY2AUTO informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table57 , append word label bdec(5)

*Table OA 28
xi: nbreg   cpj_killed  icrg_qog    HIGHDEMOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table58 , replace word label bdec(5)
xi: nbreg   cpj_killed  icrg_qog    LOWDEMOC  informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table58, append word label bdec(5)
xi: nbreg   cpj_killed  icrg_qog    POLITY2ANOC   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table58 , append word label bdec(5)
xi: nbreg   cpj_killed  icrg_qog    POLITY2AUTO    informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table58 , append word label bdec(5)

*Table OA 29
xi: zinb   cpj_killed   icrg_qog   HIGHDEMOC    informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table59 , replace  word label bdec(5)
xi: zinb   cpj_killed   icrg_qog   LOWDEMOC    informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table59 , append word label bdec(5)
xi: zinb   cpj_killed   icrg_qog   POLITY2ANOC  informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table59 , append word label bdec(5)
xi: zinb   cpj_killed   icrg_qog    POLITY2AUTO   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table59, append word label bdec(5)


*alternative ZINB specifications 
*Table OA 30
xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech     lnpop        i.year  ,cluster( ccode) inflate(icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year )
outreg2 using Table60 ,replace word label bdec(5)
xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech     lnpop        i.year  ,cluster( ccode) inflate( p_polity2       )
outreg2 using Table60 , append word label bdec(5)
xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech     lnpop        i.year  ,cluster( ccode) inflate(  lfh_repres     )
outreg2 using Table60 , append word label bdec(5)
xi: zinb   cpj_killed   icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech     lnpop        i.year  ,cluster( ccode) inflate(  lfh_press          )
outreg2 using Table60, append word label bdec(5)

****graph over time

sort year
*by year: egen meancpj_killed = mean(cpj_killed)
graph twoway line meancpj_killed year if year>1992 & year<2009

histogram cpj_killed 
clear

*some discussion of motives of murder 
use "C:\Users\murdiea\Dropbox\journalists killed amanda\FPA R&R\Asal et al FPA - murder type of death.dta"
tab typeofdeath DEMOC
tab typeofdeath p_polity2
tab typeofdeath POLITY2AUTO
use "C:\Users\murdiea\Dropbox\journalists killed amanda\FPA R&R\replication data file to FPA Asal et al.dta", clear
tsset ccodecow year
*models with various lags 
*Table OA 31
xi: logit   KCPJBINARY  icrg_qog    l1.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l2.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l3.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l4.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l5.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l6.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l7.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l8.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l9.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
xi: logit   KCPJBINARY  icrg_qog    l10.p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)

gen l1p_polity2 = l1.p_polity2
gen l2p_polity2 = l2.p_polity2
gen l3p_polity2 = l3.p_polity2
gen l4p_polity2 = l4.p_polity2
gen l5p_polity2 = l5.p_polity2
gen l6p_polity2 = l6.p_polity2
gen l7p_polity2 = l7.p_polity2
gen l8p_polity2 = l8.p_polity2
gen l9p_polity2 = l9.p_polity2
gen l10p_polity2 = l10.p_polity2



 
relogit   KCPJBINARY   icrg_qog    l1p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l2p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l3p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l4p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l5p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l6p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l7p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l8p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l9p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
relogit   KCPJBINARY   icrg_qog    l10p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)


xi: ologit   ORDEREDKCPJ    icrg_qog    l1p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l2p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l3p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l4p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l5p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l6p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l7p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l8p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l9p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   ORDEREDKCPJ    icrg_qog    l10p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)


xi: ologit   OO    icrg_qog    l1p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO    icrg_qog    l2p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO    icrg_qog    l3p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO    icrg_qog    l4p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO    icrg_qog    l5p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO   icrg_qog    l6p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO    icrg_qog    l7p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO    icrg_qog    l8p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO   icrg_qog    l9p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
xi: ologit   OO   icrg_qog    l10p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)


xi: nbreg   cpj_killed  icrg_qog    l1p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l2p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l3p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l4p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l5p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l6p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l7p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l8p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l9p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
xi: nbreg   cpj_killed  icrg_qog    l10p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)

xi: zinb   cpj_killed   icrg_qog    l1p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l2p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l3p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l4p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l5p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l6p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l7p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l8p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l9p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
xi: zinb   cpj_killed   icrg_qog    l10p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)

**endogeneity discussion 

*Table OA 34

ivreg2 cpj_killed icrg_qog   informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop _Iyear_*  (p_polity2 = ajr_settmort  ), first
outreg2 using Table61 ,append word label bdec(5)

ivendog




*model with lagged dvar:
*Table OA 35 

logit   KCPJBINARY L.KCPJBINARY icrg_qog    p_polity2 informationflows  maxintyearv410     ciri_physint ciri_speech          lnpop  i.year   ,cluster( ccode)
outreg2 using Table65 ,replace word label bdec(5)

relogit   KCPJBINARY lagKCPJBINARY  icrg_qog    p_polity2    informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop    _Iyear_1993 _Iyear_1994 _Iyear_1995 _Iyear_1996 _Iyear_1997 _Iyear_1998 _Iyear_1999 _Iyear_2000 _Iyear_2001 _Iyear_2002 _Iyear_2003 _Iyear_2004 _Iyear_2005 _Iyear_2006 _Iyear_2007, cluster( ccode)
outreg2 using Table65 ,append word label bdec(5)

xi: ologit   ORDEREDKCPJ   i.lagORDEREDKCPJ icrg_qog    p_polity2    informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop     i.year   ,cluster( ccode)
outreg2 using Table65 ,append word label bdec(5)

xi: ologit   OO   i.lagOO icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year   ,cluster( ccode)
outreg2 using Table65 ,append word label bdec(5)

xi: nbreg   cpj_killed l.cpj_killed icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech           lnpop  i.year  ,cluster( ccode)
outreg2 using Table65 ,append word label bdec(5)

xi: zinb   cpj_killed  lagcpj_killed icrg_qog    p_polity2   informationflows  maxintyearv410     ciri_physint ciri_speech             i.year  ,cluster( ccode) inflate(lnpop)
outreg2 using Table65 ,append word label bdec(5)
